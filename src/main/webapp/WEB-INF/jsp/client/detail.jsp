<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Client</title>
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
                <h2>Détails du Client</h2>
                <a href="${pageContext.request.contextPath}/client" class="btn btn-secondary">
                    Retour à la liste
                </a>
            </div>

            <div class="card">
                <h3>Informations du Client</h3>
                
                <div class="detail-row">
                    <span class="label">Nom complet :</span>
                    <span class="value">${client.nomComplet}</span>
                </div>
                
                <div class="detail-row">
                    <span class="label">Email :</span>
                    <span class="value">${client.email}</span>
                </div>
                
                <c:if test="${not empty client.telephone}">
                    <div class="detail-row">
                        <span class="label">Téléphone :</span>
                        <span class="value">${client.telephone}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty client.adresse}">
                    <div class="detail-row">
                        <span class="label">Adresse :</span>
                        <span class="value">
                            ${client.adresse}<br>
                            ${client.codePostal} ${client.ville}
                        </span>
                    </div>
                </c:if>
            </div>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/client?action=edit&amp;id=${client.id}" 
                   class="btn btn-warning">Modifier</a>
                <a href="${pageContext.request.contextPath}/commande?action=historique&amp;clientId=${client.id}" 
                   class="btn btn-info">Voir l'historique des commandes</a>
            </div>
        </main>

        <footer>
            <p>&copy;Gestion des Commandes </p>
        </footer>
    </div>
</body>
</html>
