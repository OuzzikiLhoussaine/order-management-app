package com.orderapp.ejb;

import com.orderapp.entity.Produit;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Stateless
public class ProduitBean {

    @PersistenceContext(unitName = "OrderManagementPU")
    private EntityManager em;

    /**
     * Créer un nouveau produit
     */
    public Produit creerProduit(Produit produit) {
        em.persist(produit);
        return produit;
    }

    /**
     * Mettre à jour un produit
     */
    public Produit mettreAJourProduit(Produit produit) {
        return em.merge(produit);
    }

    /**
     * Supprimer un produit
     */
    public void supprimerProduit(Long id) {
        Produit produit = em.find(Produit.class, id);
        if (produit != null) {
            em.remove(produit);
        }
    }

    /**
     * Récupérer un produit par ID
     */
    public Produit getProduit(Long id) {
        return em.find(Produit.class, id);
    }

    /**
     * Récupérer tous les produits
     */
    public List<Produit> getTousProduits() {
        TypedQuery<Produit> query = em.createNamedQuery("Produit.findAll", Produit.class);
        return query.getResultList();
    }

    /**
     * Récupérer les produits disponibles (en stock)
     */
    public List<Produit> getProduitsDisponibles() {
        TypedQuery<Produit> query = em.createNamedQuery("Produit.findAvailable", Produit.class);
        return query.getResultList();
    }

    /**
     * Récupérer les produits par catégorie
     */
    public List<Produit> getProduitsParCategorie(String categorie) {
        TypedQuery<Produit> query = em.createNamedQuery("Produit.findByCategorie", Produit.class);
        query.setParameter("categorie", categorie);
        return query.getResultList();
    }

    /**
     * Mettre à jour le stock d'un produit
     */
    public void mettreAJourStock(Long produitId, Integer nouveauStock) {
        Produit produit = em.find(Produit.class, produitId);
        if (produit != null) {
            produit.setStock(nouveauStock);
            em.merge(produit);
        }
    }
}
