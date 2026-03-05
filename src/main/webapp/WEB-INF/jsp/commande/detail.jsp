<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="utils" uri="http://orderapp.com/utils" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails de la Commande</title>
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
                <h2>Détails de la Commande ${commande.numeroCommande}</h2>
                <a href="${pageContext.request.contextPath}/commande" class="btn btn-secondary">
                    Retour à la liste
                </a>
            </div>

            <!-- Messages -->
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

            <div class="details-grid">
                <!-- Informations générales -->
                <div class="card">
                    <h3>Informations Générales</h3>
                    <div class="detail-row">
                        <span class="label">Numéro de commande :</span>
                        <span class="value">${commande.numeroCommande}</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Date de commande :</span>
                        <span class="value">
                            ${utils:formatDateTime(commande.dateCommande)}
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Statut :</span>
                        <span class="value">
                            <span class="badge badge-${commande.statut.name().toLowerCase()}">
                                ${commande.statut.libelle}
                            </span>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Montant total :</span>
                        <span class="value amount-large">
                            <fmt:formatNumber value="${commande.montantTotal}" 
                                            type="currency" currencySymbol="DH"/>
                        </span>
                    </div>
                    <c:if test="${not empty commande.commentaire}">
                        <div class="detail-row">
                            <span class="label">Commentaire :</span>
                            <span class="value">${commande.commentaire}</span>
                        </div>
                    </c:if>
                </div>

                <!-- Informations client -->
                <div class="card">
                    <h3>Client</h3>
                    <div class="detail-row">
                        <span class="label">Nom :</span>
                        <span class="value">${commande.client.nomComplet}</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Email :</span>
                        <span class="value">${commande.client.email}</span>
                    </div>
                    <c:if test="${not empty commande.client.telephone}">
                        <div class="detail-row">
                            <span class="label">Téléphone :</span>
                            <span class="value">${commande.client.telephone}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty commande.client.adresse}">
                        <div class="detail-row">
                            <span class="label">Adresse :</span>
                            <span class="value">
                                ${commande.client.adresse}<br>
                                ${commande.client.codePostal} ${commande.client.ville}
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Lignes de commande -->
            <div class="card">
                <h3>Articles commandés</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Produit</th>
                            <th>Prix unitaire</th>
                            <th>Quantité</th>
                            <th>Sous-total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ligne" items="${commande.lignes}">
                            <tr>
                                <td>${ligne.produit.nom}</td>
                                <td class="amount">
                                    <fmt:formatNumber value="${ligne.prixUnitaire}" 
                                                     type="currency" currencySymbol="DH"/>
                                </td>
                                <td class="text-center">${ligne.quantite}</td>
                                <td class="amount">
                                    <fmt:formatNumber value="${ligne.sousTotal}" 
                                                     type="currency" currencySymbol="DH"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="text-right"><strong>Total :</strong></td>
                            <td class="amount">
                                <strong>
                                    <fmt:formatNumber value="${commande.montantTotal}" 
                                                     type="currency" currencySymbol="DH"/>
                                </strong>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>

            <!-- Actions -->
            <div class="card">
                <h3>Actions</h3>
                <div class="button-group">
                    <c:if test="${commande.statut == 'EN_ATTENTE'}">
                        <form method="post" action="${pageContext.request.contextPath}/commande" 
                              style="display: inline;" onsubmit="return confirm('Confirmer la validation ?')">
                            <input type="hidden" name="action" value="valider">
                            <input type="hidden" name="id" value="${commande.id}">
                            <button type="submit" class="btn btn-success">Valider la commande</button>
                        </form>
                    </c:if>

                    <c:if test="${commande.statut != 'ANNULEE' && commande.statut != 'LIVREE'}">
                        <form method="post" action="${pageContext.request.contextPath}/commande" 
                              style="display: inline;">
                            <input type="hidden" name="action" value="changerStatut">
                            <input type="hidden" name="id" value="${commande.id}">
                            <select name="statut" class="inline-select" required>
                                <option value="">Changer le statut...</option>
                                <c:forEach var="statutItem" items="${statuts}">
                                    <c:if test="${statutItem != commande.statut && statutItem != 'ANNULEE'}">
                                        <option value="${statutItem}">${statutItem.libelle}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary">Mettre à jour</button>
                        </form>
                    </c:if>

                    <c:if test="${commande.statut != 'ANNULEE' && commande.statut != 'LIVREE'}">
                        <form method="post" action="${pageContext.request.contextPath}/commande" 
                              style="display: inline;" onsubmit="return confirm('Confirmer l\'annulation ? Les stocks seront restaurés.')">
                            <input type="hidden" name="action" value="annuler">
                            <input type="hidden" name="id" value="${commande.id}">
                            <button type="submit" class="btn btn-danger">Annuler la commande</button>
                        </form>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/commande" 
                          style="display: inline;" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer définitivement cette commande ?')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${commande.id}">
                        <button type="submit" class="btn btn-danger">Supprimer la commande</button>
                    </form>
                </div>
            </div>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes </p>
        </footer>
    </div>
</body>
</html>
