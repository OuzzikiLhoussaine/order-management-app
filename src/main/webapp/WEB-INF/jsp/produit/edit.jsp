<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Produit</title>
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
                <h2>Modifier le Produit</h2>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/produit" class="form-horizontal">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${produit.id}">

                <div class="card">
                    <div class="form-group">
                        <label for="nom">Nom du produit *</label>
                        <input type="text" name="nom" id="nom" class="form-control" 
                               value="${produit.nom}" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description" class="form-control" rows="3">${produit.description}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="prix">Prix (DH) *</label>
                            <input type="number" name="prix" id="prix" class="form-control" 
                                   step="0.01" min="0" value="${produit.prix}" required>
                        </div>

                        <div class="form-group">
                            <label for="stock">Stock *</label>
                            <input type="number" name="stock" id="stock" class="form-control" 
                                   min="0" value="${produit.stock}" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="categorie">Catégorie</label>
                            <select name="categorie" id="categorie" class="form-control">
                                <option value="">Sélectionner une catégorie</option>
                                <option value="Électronique" ${produit.categorie == 'Électronique' ? 'selected' : ''}>Électronique</option>
                                <option value="Mobilier" ${produit.categorie == 'Mobilier' ? 'selected' : ''}>Mobilier</option>
                                <option value="Livres" ${produit.categorie == 'Livres' ? 'selected' : ''}>Livres</option>
                                <option value="Sport" ${produit.categorie == 'Sport' ? 'selected' : ''}>Sport</option>
                                <option value="Maison" ${produit.categorie == 'Maison' ? 'selected' : ''}>Maison</option>
                            </select>
                        </div>

                        <!--  <div class="form-group">
                            <label for="image">URL Image</label>
                            <input type="text" name="image" id="image" class="form-control" 
                                   value="${produit.image}" placeholder="https://example.com/image.jpg">
                        </div>-->
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
                    <a href="${pageContext.request.contextPath}/produit" class="btn btn-secondary">Annuler</a>
                </div>
            </form>

            <!-- Delete Section -->
            <div class="card" style="margin-top: 2rem; border: 2px solid var(--danger-color);">
                <h3 style="color: var(--danger-color);">Zone dangereuse</h3>
                <p style="color: var(--text-secondary); margin-bottom: 1rem;">
                    La suppression du produit est définitive et ne peut pas être annulée.
                </p>
                <form method="post" action="${pageContext.request.contextPath}/produit" 
                      style="display: inline;" 
                      onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ? Cette action est irréversible.')">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${produit.id}">
                    <button type="submit" class="btn btn-danger">Supprimer ce produit</button>
                </form>
            </div>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
