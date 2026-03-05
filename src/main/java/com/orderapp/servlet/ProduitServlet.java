package com.orderapp.servlet;

import com.orderapp.ejb.ProduitBean;
import com.orderapp.entity.Produit;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/produit")
public class ProduitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
                    listerProduits(request, response);
                    break;
                case "create":
                    request.getRequestDispatcher("/WEB-INF/jsp/produit/create.jsp").forward(request, response);
                    break;
                case "edit":
                    afficherFormulaireEdition(request, response);
                    break;
                default:
                    listerProduits(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    creerProduit(request, response);
                    break;
                case "update":
                    mettreAJourProduit(request, response);
                    break;
                case "delete":
                    supprimerProduit(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/produit");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    private void listerProduits(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Produit> produits = produitBean.getTousProduits();
        request.setAttribute("produits", produits);
        request.getRequestDispatcher("/WEB-INF/jsp/produit/list.jsp").forward(request, response);
    }

    private void afficherFormulaireEdition(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Produit produit = produitBean.getProduit(id);
        
        if (produit == null) {
            request.setAttribute("error", "Produit introuvable");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("produit", produit);
        request.getRequestDispatcher("/WEB-INF/jsp/produit/edit.jsp").forward(request, response);
    }

    private void creerProduit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Produit produit = new Produit();
        produit.setNom(request.getParameter("nom"));
        produit.setDescription(request.getParameter("description"));
        produit.setPrix(new BigDecimal(request.getParameter("prix")));
        produit.setStock(Integer.parseInt(request.getParameter("stock")));
        produit.setCategorie(request.getParameter("categorie"));
        produit.setImage(request.getParameter("image"));

        produitBean.creerProduit(produit);
        
        request.getSession().setAttribute("success", "Produit créé avec succès");
        response.sendRedirect(request.getContextPath() + "/produit");
    }

    private void mettreAJourProduit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        Produit produit = produitBean.getProduit(id);
        
        if (produit == null) {
            request.setAttribute("error", "Produit introuvable");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        produit.setNom(request.getParameter("nom"));
        produit.setDescription(request.getParameter("description"));
        produit.setPrix(new BigDecimal(request.getParameter("prix")));
        produit.setStock(Integer.parseInt(request.getParameter("stock")));
        produit.setCategorie(request.getParameter("categorie"));
        produit.setImage(request.getParameter("image"));

        produitBean.mettreAJourProduit(produit);
        
        request.getSession().setAttribute("success", "Produit modifié avec succès");
        response.sendRedirect(request.getContextPath() + "/produit");
    }

    private void supprimerProduit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        produitBean.supprimerProduit(id);
        
        request.getSession().setAttribute("success", "Produit supprimé avec succès");
        response.sendRedirect(request.getContextPath() + "/produit");
    }
}
