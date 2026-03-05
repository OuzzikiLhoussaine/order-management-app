<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="utils" uri="http://orderapp.com/utils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Commandes</title>
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
                <h2>Historique des Commandes - ${client.nomComplet}</h2>
                <a href="${pageContext.request.contextPath}/client" class="btn btn-secondary">
                    Retour aux clients
                </a>
            </div>

            <div class="card">
                <h3>Informations Client</h3>
                <p><strong>Email :</strong> ${client.email}</p>
                <c:if test="${not empty client.telephone}">
                    <p><strong>Téléphone :</strong> ${client.telephone}</p>
                </c:if>
            </div>

            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Date</th>
                            <th>Montant</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="commande" items="${commandes}">
                            <tr>
                                <td>${commande.numeroCommande}</td>
                                <td>
                                    ${utils:formatDateTime(commande.dateCommande)}
                                </td>
                                <td class="amount">
                                    <fmt:formatNumber value="${commande.montantTotal}" 
                                                     type="currency" currencySymbol="DH"/>
                                </td>
                                <td>
                                    <span class="badge badge-${commande.statut.name().toLowerCase()}">
                                        ${commande.statut.libelle}
                                    </span>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/commande?action=detail&amp;id=${commande.id}" 
                                       class="btn btn-sm btn-info">Détails</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty commandes}">
                            <tr>
                                <td colspan="5" class="text-center">Aucune commande trouvée pour ce client</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes </p>
        </footer>
    </div>
</body>
</html>
