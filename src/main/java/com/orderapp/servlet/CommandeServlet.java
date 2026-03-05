package com.orderapp.servlet;

import com.orderapp.ejb.CommandeBean;
import com.orderapp.ejb.CommandeException;
import com.orderapp.ejb.ClientBean;
import com.orderapp.ejb.ProduitBean;
import com.orderapp.entity.Commande;
import com.orderapp.entity.StatutCommande;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/commande")
public class CommandeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private CommandeBean commandeBean;

    @EJB
    private ClientBean clientBean;

    @EJB
    private ProduitBean produitBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listerCommandes(request, response);
                    break;
                case "detail":
                    afficherDetail(request, response);
                    break;
                case "create":
                    afficherFormulaireCreation(request, response);
                    break;
                case "historique":
                    afficherHistorique(request, response);
                    break;
                default:
                    listerCommandes(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            request.setAttribute("error", "Erreur : " + e.getMessage());
            // Redirect to list page instead of error page
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    creerCommande(request, response);
                    break;
                case "valider":
                    validerCommande(request, response);
                    break;
                case "changerStatut":
                    changerStatut(request, response);
                    break;
                case "annuler":
                    annulerCommande(request, response);
                    break;
                case "delete":
                    supprimerCommande(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/commande");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the error
            request.getSession().setAttribute("error", "Erreur : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    private void listerCommandes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String statutParam = request.getParameter("statut");
        List<Commande> commandes;

        if (statutParam != null && !statutParam.isEmpty()) {
            StatutCommande statut = StatutCommande.valueOf(statutParam);
            commandes = commandeBean.getCommandesParStatut(statut);
        } else {
            commandes = commandeBean.getToutesCommandes();
        }

        request.setAttribute("commandes", commandes);
        request.setAttribute("statuts", StatutCommande.values());
        request.getRequestDispatcher("/WEB-INF/jsp/commande/list.jsp").forward(request, response);
    }

    private void afficherDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        Commande commande = commandeBean.getCommande(id);

        if (commande == null) {
            request.getSession().setAttribute("error", "Commande introuvable");
            response.sendRedirect(request.getContextPath() + "/commande");
            return;
        }

        request.setAttribute("commande", commande);
        request.setAttribute("statuts", StatutCommande.values());
        request.getRequestDispatcher("/WEB-INF/jsp/commande/detail.jsp").forward(request, response);
    }

    private void afficherFormulaireCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("clients", clientBean.getTousClients());
        request.setAttribute("produits", produitBean.getProduitsDisponibles());
        request.getRequestDispatcher("/WEB-INF/jsp/commande/create.jsp").forward(request, response);
    }

    private void creerCommande(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Validate clientId parameter
            String clientIdParam = request.getParameter("clientId");
            if (clientIdParam == null || clientIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner un client");
                request.setAttribute("clients", clientBean.getTousClients());
                request.setAttribute("produits", produitBean.getProduitsDisponibles());
                request.getRequestDispatcher("/WEB-INF/jsp/commande/create.jsp").forward(request, response);
                return;
            }
            
            Long clientId = Long.parseLong(clientIdParam);
            String commentaire = request.getParameter("commentaire");

            // Récupérer les lignes de commande
            String[] produitIds = request.getParameterValues("produitId");
            String[] quantites = request.getParameterValues("quantite");

            List<CommandeBean.LigneCommandeDTO> lignes = new ArrayList<>();
            
            if (produitIds != null && quantites != null) {
                for (int i = 0; i < produitIds.length; i++) {
                    if (produitIds[i] != null && !produitIds[i].trim().isEmpty()) {
                        Long produitId = Long.parseLong(produitIds[i]);
                        Integer quantite = Integer.parseInt(quantites[i]);
                        
                        if (quantite > 0) {
                            lignes.add(new CommandeBean.LigneCommandeDTO(produitId, quantite));
                        }
                    }
                }
            }

            if (lignes.isEmpty()) {
                request.setAttribute("error", "Veuillez ajouter au moins un produit à la commande");
                request.setAttribute("clients", clientBean.getTousClients());
                request.setAttribute("produits", produitBean.getProduitsDisponibles());
                request.getRequestDispatcher("/WEB-INF/jsp/commande/create.jsp").forward(request, response);
                return;
            }

            Commande commande = commandeBean.creerCommande(clientId, lignes, commentaire);
            
            // Use session attribute for success message
            request.getSession().setAttribute("success", "Commande créée avec succès : " + commande.getNumeroCommande());
            
            // Redirect to detail page
            response.sendRedirect(request.getContextPath() + "/commande?action=detail&id=" + commande.getId());

        } catch (CommandeException e) {
            e.printStackTrace(); // Log the error
            request.setAttribute("error", e.getMessage());
            request.setAttribute("clients", clientBean.getTousClients());
            request.setAttribute("produits", produitBean.getProduitsDisponibles());
            request.getRequestDispatcher("/WEB-INF/jsp/commande/create.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Log the error
            request.setAttribute("error", "Format de données invalide");
            request.setAttribute("clients", clientBean.getTousClients());
            request.setAttribute("produits", produitBean.getProduitsDisponibles());
            request.getRequestDispatcher("/WEB-INF/jsp/commande/create.jsp").forward(request, response);
        }
    }

    private void validerCommande(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            commandeBean.validerCommande(id);
            
            request.getSession().setAttribute("success", "Commande validée avec succès");
            response.sendRedirect(request.getContextPath() + "/commande?action=detail&id=" + id);
            
        } catch (CommandeException e) {
            e.printStackTrace(); // Log the error
            request.getSession().setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    private void changerStatut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            StatutCommande statut = StatutCommande.valueOf(request.getParameter("statut"));
            
            commandeBean.changerStatut(id, statut);
            
            request.getSession().setAttribute("success", "Statut modifié avec succès");
            response.sendRedirect(request.getContextPath() + "/commande?action=detail&id=" + id);
            
        } catch (CommandeException e) {
            e.printStackTrace(); // Log the error
            request.getSession().setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    private void annulerCommande(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            commandeBean.annulerCommande(id);
            
            request.getSession().setAttribute("success", "Commande annulée avec succès");
            response.sendRedirect(request.getContextPath() + "/commande?action=detail&id=" + id);
            
        } catch (CommandeException e) {
            e.printStackTrace(); // Log the error
            request.getSession().setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    private void supprimerCommande(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            commandeBean.supprimerCommande(id);
            
            request.getSession().setAttribute("success", "Commande supprimée avec succès");
            response.sendRedirect(request.getContextPath() + "/commande");
            
        } catch (CommandeException e) {
            e.printStackTrace(); // Log the error
            request.getSession().setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/commande");
        }
    }

    private void afficherHistorique(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long clientId = Long.parseLong(request.getParameter("clientId"));
        List<Commande> commandes = commandeBean.getCommandesParClient(clientId);
        
        request.setAttribute("commandes", commandes);
        request.setAttribute("client", clientBean.getClient(clientId));
        request.getRequestDispatcher("/WEB-INF/jsp/commande/historique.jsp").forward(request, response);
    }
}