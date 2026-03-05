<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="utils" uri="http://orderapp.com/utils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Commandes</title>
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
                <h2>Liste des Commandes</h2>
                <a href="${pageContext.request.contextPath}/commande?action=create" class="btn btn-primary">
                    Nouvelle Commande
                </a>
            </div>

            <!-- Messages de succès/erreur -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    ${sessionScope.success}
                    <c:remove var="success" scope="session"/>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    ${sessionScope.error}
                    <c:remove var="error" scope="session"/>
                </div>
            </c:if>

            <!-- Filtres -->
            <div class="filters">
                <form method="get" action="${pageContext.request.contextPath}/commande">
                    <label for="statut">Filtrer par statut :</label>
                    <select name="statut" id="statut" onchange="this.form.submit()">
                        <option value="">Tous les statuts</option>
                        <c:forEach var="statutItem" items="${statuts}">
                            <option value="${statutItem}" ${param.statut == statutItem ? 'selected' : ''}>
                                ${statutItem.libelle}
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <!-- Tableau des commandes -->
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Numéro</th>
                            <th>Client</th>
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
                                <td>${commande.client.nomComplet}</td>
                                <td>
                                    ${utils:formatDateTime(commande.dateCommande)}
                                </td>
                                <td class="amount">
                                    <fmt:formatNumber value="${commande.montantTotal}" 
                                                     type="currency" currencySymbol="DH"/>
                                </td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/commande" style="display: inline;">
                                        <input type="hidden" name="action" value="changerStatut">
                                        <input type="hidden" name="id" value="${commande.id}">
                                        <select name="statut" class="inline-select" onchange="this.form.submit()" 
                                                ${commande.statut == 'ANNULEE' || commande.statut == 'LIVREE' ? 'disabled' : ''}>
                                            <c:forEach var="statutItem" items="${statuts}">
                                                <option value="${statutItem}" ${commande.statut == statutItem ? 'selected' : ''}>
                                                    ${statutItem.libelle}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </form>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/commande?action=detail&amp;id=${commande.id}" 
                                       class="btn btn-sm btn-info">Détails</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty commandes}">
                            <tr>
                                <td colspan="6" class="text-center">Aucune commande trouvée</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
