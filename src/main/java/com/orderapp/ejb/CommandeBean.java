package com.orderapp.ejb;

import com.orderapp.entity.*;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Stateless
public class CommandeBean {

    @PersistenceContext(unitName = "OrderManagementPU")
    private EntityManager em;

    /**
     * Créer une nouvelle commande avec validation et gestion des stocks
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Commande creerCommande(Long clientId, List<LigneCommandeDTO> lignesDTO, String commentaire) 
            throws CommandeException {
        
        // Récupérer le client
        Client client = em.find(Client.class, clientId);
        if (client == null) {
            throw new CommandeException("Client introuvable avec l'ID : " + clientId);
        }

        // Créer la commande
        Commande commande = new Commande();
        commande.setClient(client);
        commande.setNumeroCommande(genererNumeroCommande());
        commande.setDateCommande(LocalDateTime.now());
        commande.setStatut(StatutCommande.EN_ATTENTE);
        commande.setCommentaire(commentaire);

        // Ajouter les lignes de commande
        BigDecimal montantTotal = BigDecimal.ZERO;
        for (LigneCommandeDTO ligneDTO : lignesDTO) {
            Produit produit = em.find(Produit.class, ligneDTO.getProduitId());
            
            if (produit == null) {
                throw new CommandeException("Produit introuvable avec l'ID : " + ligneDTO.getProduitId());
            }

            // Vérifier le stock
            if (produit.getStock() < ligneDTO.getQuantite()) {
                throw new CommandeException("Stock insuffisant pour le produit : " + produit.getNom() 
                    + " (disponible: " + produit.getStock() + ", demandé: " + ligneDTO.getQuantite() + ")");
            }

            // Créer la ligne de commande
            LigneCommande ligne = new LigneCommande();
            ligne.setProduit(produit);
            ligne.setQuantite(ligneDTO.getQuantite());
            ligne.setPrixUnitaire(produit.getPrix());
            ligne.calculerSousTotal();
            
            commande.ajouterLigne(ligne);
            montantTotal = montantTotal.add(ligne.getSousTotal());

            // Réduire le stock
            produit.setStock(produit.getStock() - ligneDTO.getQuantite());
            em.merge(produit);
        }

        commande.setMontantTotal(montantTotal);
        em.persist(commande);
        
        return commande;
    }

    /**
     * Valider une commande
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Commande validerCommande(Long commandeId) throws CommandeException {
        Commande commande = em.find(Commande.class, commandeId);
        
        if (commande == null) {
            throw new CommandeException("Commande introuvable avec l'ID : " + commandeId);
        }

        if (commande.getStatut() != StatutCommande.EN_ATTENTE) {
            throw new CommandeException("Seules les commandes en attente peuvent être validées");
        }

        commande.setStatut(StatutCommande.VALIDEE);
        return em.merge(commande);
    }

    /**
     * Changer le statut d'une commande
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Commande changerStatut(Long commandeId, StatutCommande nouveauStatut) throws CommandeException {
        Commande commande = em.find(Commande.class, commandeId);
        
        if (commande == null) {
            throw new CommandeException("Commande introuvable avec l'ID : " + commandeId);
        }

        if (commande.getStatut() == StatutCommande.ANNULEE) {
            throw new CommandeException("Une commande annulée ne peut pas changer de statut");
        }

        commande.setStatut(nouveauStatut);
        return em.merge(commande);
    }

    /**
     * Annuler une commande et restaurer les stocks
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void annulerCommande(Long commandeId) throws CommandeException {
        Commande commande = em.find(Commande.class, commandeId);
        
        if (commande == null) {
            throw new CommandeException("Commande introuvable avec l'ID : " + commandeId);
        }

        if (commande.getStatut() == StatutCommande.LIVREE) {
            throw new CommandeException("Une commande livrée ne peut pas être annulée");
        }

        // Restaurer les stocks
        for (LigneCommande ligne : commande.getLignes()) {
            Produit produit = ligne.getProduit();
            produit.setStock(produit.getStock() + ligne.getQuantite());
            em.merge(produit);
        }

        commande.setStatut(StatutCommande.ANNULEE);
        em.merge(commande);
    }

    /**
     * Supprimer une commande (avec restauration des stocks si nécessaire)
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void supprimerCommande(Long commandeId) throws CommandeException {
        Commande commande = em.find(Commande.class, commandeId);
        
        if (commande == null) {
            throw new CommandeException("Commande introuvable avec l'ID : " + commandeId);
        }

        // Restaurer les stocks si la commande n'était pas annulée
        if (commande.getStatut() != StatutCommande.ANNULEE) {
            for (LigneCommande ligne : commande.getLignes()) {
                Produit produit = ligne.getProduit();
                produit.setStock(produit.getStock() + ligne.getQuantite());
                em.merge(produit);
            }
        }

        em.remove(commande);
    }

    /**
     * Récupérer une commande par ID avec ses lignes (JOIN FETCH pour éviter LazyInitializationException)
     */
    public Commande getCommande(Long id) {
        TypedQuery<Commande> query = em.createQuery(
            "SELECT c FROM Commande c " +
            "LEFT JOIN FETCH c.lignes l " +
            "LEFT JOIN FETCH l.produit " +
            "WHERE c.id = :id", Commande.class);
        query.setParameter("id", id);
        List<Commande> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Récupérer toutes les commandes
     */
    public List<Commande> getToutesCommandes() {
        TypedQuery<Commande> query = em.createNamedQuery("Commande.findAll", Commande.class);
        return query.getResultList();
    }

    /**
     * Récupérer les commandes d'un client
     */
    public List<Commande> getCommandesParClient(Long clientId) {
        TypedQuery<Commande> query = em.createNamedQuery("Commande.findByClient", Commande.class);
        query.setParameter("clientId", clientId);
        return query.getResultList();
    }

    /**
     * Récupérer les commandes par statut
     */
    public List<Commande> getCommandesParStatut(StatutCommande statut) {
        TypedQuery<Commande> query = em.createNamedQuery("Commande.findByStatut", Commande.class);
        query.setParameter("statut", statut);
        return query.getResultList();
    }

    /**
     * Générer un numéro de commande unique
     */
    private String genererNumeroCommande() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return "CMD-" + LocalDateTime.now().format(formatter);
    }

    // Classe DTO pour créer les lignes de commande
    public static class LigneCommandeDTO {
        private Long produitId;
        private Integer quantite;

        public LigneCommandeDTO() {}

        public LigneCommandeDTO(Long produitId, Integer quantite) {
            this.produitId = produitId;
            this.quantite = quantite;
        }

        public Long getProduitId() {
            return produitId;
        }

        public void setProduitId(Long produitId) {
            this.produitId = produitId;
        }

        public Integer getQuantite() {
            return quantite;
        }

        public void setQuantite(Integer quantite) {
            this.quantite = quantite;
        }
    }
}
