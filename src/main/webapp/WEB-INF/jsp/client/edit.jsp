<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Client</title>
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
                <h2>Modifier le Client</h2>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/client" class="form-horizontal">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${client.id}">

                <div class="card">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom">Nom *</label>
                            <input type="text" name="nom" id="nom" class="form-control" 
                                   value="${client.nom}" required>
                        </div>

                        <div class="form-group">
                            <label for="prenom">Prénom *</label>
                            <input type="text" name="prenom" id="prenom" class="form-control" 
                                   value="${client.prenom}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" name="email" id="email" class="form-control" 
                                   value="${client.email}" required>
                        </div>

                        <div class="form-group">
                            <label for="telephone">Téléphone</label>
                            <input type="tel" name="telephone" id="telephone" class="form-control" 
                                   value="${client.telephone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="adresse">Adresse</label>
                        <input type="text" name="adresse" id="adresse" class="form-control" 
                               value="${client.adresse}">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="codePostal">Code Postal</label>
                            <input type="text" name="codePostal" id="codePostal" class="form-control" 
                                   value="${client.codePostal}">
                        </div>

                        <div class="form-group">
                            <label for="ville">Ville</label>
                            <input type="text" name="ville" id="ville" class="form-control" 
                                   value="${client.ville}">
                        </div>
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                    <a href="${pageContext.request.contextPath}/client" class="btn btn-secondary">Annuler</a>
                </div>
            </form>

            <!-- Delete Section -->
            <div class="card" style="margin-top: 2rem; border: 2px solid var(--danger-color);">
                <h3 style="color: var(--danger-color);">Zone dangereuse</h3>
                <p style="color: var(--text-secondary); margin-bottom: 1rem;">
                    La suppression du client est définitive et ne peut pas être annulée.
                </p>
                <form method="post" action="${pageContext.request.contextPath}/client" 
                      style="display: inline;" 
                      onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce client ? Cette action est irréversible.')">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${client.id}">
                    <button type="submit" class="btn btn-danger">Supprimer ce client</button>
                </form>
            </div>
        </main>

        <footer>
            <p>&copy;Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
