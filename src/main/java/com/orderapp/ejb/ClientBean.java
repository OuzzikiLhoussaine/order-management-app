package com.orderapp.ejb;

import com.orderapp.entity.Client;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

@Stateless
public class ClientBean {

    @PersistenceContext(unitName = "OrderManagementPU")
    private EntityManager em;

    /**
     * Créer un nouveau client
     */
    public Client creerClient(Client client) {
        em.persist(client);
        return client;
    }

    /**
     * Mettre à jour un client
     */
    public Client mettreAJourClient(Client client) {
        return em.merge(client);
    }

    /**
     * Supprimer un client
     */
    public void supprimerClient(Long id) {
        Client client = em.find(Client.class, id);
        if (client != null) {
            em.remove(client);
        }
    }

    /**
     * Récupérer un client par ID
     */
    public Client getClient(Long id) {
        return em.find(Client.class, id);
    }

    /**
     * Récupérer tous les clients
     */
    public List<Client> getTousClients() {
        TypedQuery<Client> query = em.createNamedQuery("Client.findAll", Client.class);
        return query.getResultList();
    }

    /**
     * Rechercher un client par email
     */
    public Client rechercherParEmail(String email) {
        TypedQuery<Client> query = em.createNamedQuery("Client.findByEmail", Client.class);
        query.setParameter("email", email);
        List<Client> clients = query.getResultList();
        return clients.isEmpty() ? null : clients.get(0);
    }
}
