package com.orderapp.servlet;

import com.orderapp.ejb.ClientBean;
import com.orderapp.entity.Client;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/client")
public class ClientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private ClientBean clientBean;

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
                    listerClients(request, response);
                    break;
                case "create":
                    request.getRequestDispatcher("/WEB-INF/jsp/client/create.jsp").forward(request, response);
                    break;
                case "edit":
                    afficherFormulaireEdition(request, response);
                    break;
                case "detail":
                    afficherDetail(request, response);
                    break;
                default:
                    listerClients(request, response);
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
                    creerClient(request, response);
                    break;
                case "update":
                    mettreAJourClient(request, response);
                    break;
                case "delete":
                    supprimerClient(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/client");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    private void listerClients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Client> clients = clientBean.getTousClients();
        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/WEB-INF/jsp/client/list.jsp").forward(request, response);
    }

    private void afficherDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Client client = clientBean.getClient(id);
        
        if (client == null) {
            request.setAttribute("error", "Client introuvable");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("client", client);
        request.getRequestDispatcher("/WEB-INF/jsp/client/detail.jsp").forward(request, response);
    }

    private void afficherFormulaireEdition(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Client client = clientBean.getClient(id);
        
        if (client == null) {
            request.setAttribute("error", "Client introuvable");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("client", client);
        request.getRequestDispatcher("/WEB-INF/jsp/client/edit.jsp").forward(request, response);
    }

    private void creerClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Client client = new Client();
        client.setNom(request.getParameter("nom"));
        client.setPrenom(request.getParameter("prenom"));
        client.setEmail(request.getParameter("email"));
        client.setTelephone(request.getParameter("telephone"));
        client.setAdresse(request.getParameter("adresse"));
        client.setVille(request.getParameter("ville"));
        client.setCodePostal(request.getParameter("codePostal"));

        clientBean.creerClient(client);
        
        request.getSession().setAttribute("success", "Client créé avec succès");
        response.sendRedirect(request.getContextPath() + "/client");
    }

    private void mettreAJourClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        Client client = clientBean.getClient(id);
        
        if (client == null) {
            request.setAttribute("error", "Client introuvable");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            return;
        }

        client.setNom(request.getParameter("nom"));
        client.setPrenom(request.getParameter("prenom"));
        client.setEmail(request.getParameter("email"));
        client.setTelephone(request.getParameter("telephone"));
        client.setAdresse(request.getParameter("adresse"));
        client.setVille(request.getParameter("ville"));
        client.setCodePostal(request.getParameter("codePostal"));

        clientBean.mettreAJourClient(client);
        
        request.getSession().setAttribute("success", "Client modifié avec succès");
        response.sendRedirect(request.getContextPath() + "/client");
    }

    private void supprimerClient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        clientBean.supprimerClient(id);
        
        request.getSession().setAttribute("success", "Client supprimé avec succès");
        response.sendRedirect(request.getContextPath() + "/client");
    }
}
