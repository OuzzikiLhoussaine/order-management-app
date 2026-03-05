<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Clients</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
    <div class="header-inner">
        <h1>Gestion des Commandes</h1>
        <nav>
                <a href="${pageContext.request.contextPath}/commande">Commandes</a>
                <a href="${pageContext.request.contextPath}/client">Clients</a>
                <a href="${pageContext.request.contextPath}/produit">Produits</a>
            </nav>
    </div>
</header>

        <main>
            <div class="page-header">
                <h2>Liste des Clients</h2>
                <a href="${pageContext.request.contextPath}/client?action=create" class="btn btn-primary">
                    Nouveau Client
                </a>
            </div>

            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    ${sessionScope.success}
                    <c:remove var="success" scope="session"/>
                </div>
            </c:if>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                            <th>Ville</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="client" items="${clients}">
                            <tr>
                                <td>${client.nom}</td>
                                <td>${client.prenom}</td>
                                <td>${client.email}</td>
                                <td>${client.telephone}</td>
                                <td>${client.ville}</td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/client?action=detail&amp;id=${client.id}" 
                                       class="btn btn-sm btn-info">Détails</a>
                                    <a href="${pageContext.request.contextPath}/client?action=edit&amp;id=${client.id}" 
                                       class="btn btn-sm btn-warning">Modifier</a>
                                    <a href="${pageContext.request.contextPath}/commande?action=historique&amp;clientId=${client.id}" 
                                       class="btn btn-sm btn-secondary">Historique</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty clients}">
                            <tr>
                                <td colspan="6" class="text-center">Aucun client trouvé</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <footer>
            <p>&copy;Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
