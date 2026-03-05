<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Produit</title>
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
                <h2>Nouveau Produit</h2>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/produit" class="form-horizontal">
                <input type="hidden" name="action" value="create">

                <div class="card">
                    <div class="form-group">
                        <label for="nom">Nom du produit *</label>
                        <input type="text" name="nom" id="nom" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description" class="form-control" rows="3"></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="prix">Prix (DH) *</label>
                            <input type="number" name="prix" id="prix" class="form-control" 
                                   step="0.01" min="0" required>
                        </div>

                        <div class="form-group">
                            <label for="stock">Stock *</label>
                            <input type="number" name="stock" id="stock" class="form-control" 
                                   min="0" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="categorie">Catégorie</label>
                            <select name="categorie" id="categorie" class="form-control">
                                <option value="">Sélectionner une catégorie</option>
                                <option value="Électronique">Électronique</option>
                                <option value="Mobilier">Mobilier</option>
                                <option value="Livres">Livres</option>
                                <option value="Sport">Sport</option>
                                <option value="Maison">Maison</option>
                            </select>
                        </div>

                        <!-- <div class="form-group">
                            <label for="image">URL Image</label>
                            <input type="text" name="image" id="image" class="form-control" 
                                   placeholder="https://example.com/image.jpg">
                        </div> -->
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Créer le produit</button>
                    <a href="${pageContext.request.contextPath}/produit" class="btn btn-secondary">Annuler</a>
                </div>
            </form>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
