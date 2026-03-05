<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Produits</title>
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
                <h2>Liste des Produits</h2>
                <a href="${pageContext.request.contextPath}/produit?action=create" class="btn btn-primary">
                    Nouveau Produit
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
                            <th>Catégorie</th>
                            <th>Prix</th>
                            <th>Stock</th>
                            <th>Disponibilité</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="produit" items="${produits}">
                            <tr>
                                <td>${produit.nom}</td>
                                <td>${produit.categorie}</td>
                                <td class="amount">
                                    <fmt:formatNumber value="${produit.prix}" 
                                                     type="currency" currencySymbol="DH"/>
                                </td>
                                <td class="text-center">${produit.stock}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${produit.disponible}">
                                            <span class="badge badge-success">En stock</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Rupture</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/produit?action=edit&amp;id=${produit.id}" 
                                       class="btn btn-sm btn-warning">Modifier</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty produits}">
                            <tr>
                                <td colspan="6" class="text-center">Aucun produit trouvé</td>
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
