<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Commande</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        let ligneCount = 0;

        function ajouterLigne() {
            const container = document.getElementById('lignes-container');
            const ligne = document.createElement('div');
            ligne.className = 'ligne-commande';
            ligne.id = 'ligne-' + ligneCount;
            ligne.innerHTML = `
                <select name="produitId" class="form-control" required>
                    <option value="">Sélectionner un produit</option>
                    <c:forEach var="produit" items="${produits}">
                        <option value="${produit.id}" data-prix="${produit.prix}">
                            ${produit.nom} - <fmt:formatNumber value="${produit.prix}" type="currency" currencySymbol="DH "/> 
                            (Stock: ${produit.stock})
                        </option>
                    </c:forEach>
                </select>
                <input type="number" name="quantite" class="form-control" 
                       min="1" placeholder="Quantité" required>
                <button type="button" class="btn btn-danger btn-sm" onclick="supprimerLigne(${ligneCount})">
                    Supprimer
                </button>
            `;
            container.appendChild(ligne);
            ligneCount++;
        }

        function supprimerLigne(id) {
            const ligne = document.getElementById('ligne-' + id);
            if (ligne) {
                ligne.remove();
            }
        }

        function validerFormulaire(event) {
            // Vérifier si un client est sélectionné
            const clientSelect = document.getElementById('clientId');
            if (!clientSelect.value) {
                event.preventDefault();
                alert('Veuillez sélectionner un client');
                return false;
            }

            // Vérifier si au moins une ligne de produit est ajoutée
            const lignes = document.querySelectorAll('.ligne-commande');
            if (lignes.length === 0) {
                event.preventDefault();
                alert('Veuillez ajouter au moins un produit à la commande');
                return false;
            }

            // Vérifier que tous les produits sont sélectionnés et ont des quantités
            let valid = true;
            lignes.forEach((ligne) => {
                const select = ligne.querySelector('select[name="produitId"]');
                const input = ligne.querySelector('input[name="quantite"]');
                
                if (!select.value) {
                    valid = false;
                    alert('Veuillez sélectionner un produit pour chaque ligne');
                }
                
                if (!input.value || input.value <= 0) {
                    valid = false;
                    alert('Veuillez entrer une quantité valide pour chaque produit');
                }
            });

            if (!valid) {
                event.preventDefault();
                return false;
            }

            return true;
        }

        // Ajouter une première ligne au chargement
        window.onload = function() {
            ajouterLigne();
            
            // Ajouter l'écouteur d'événement pour la validation du formulaire
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', validerFormulaire);
            }
        };
    </script>
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
                <h2>Nouvelle Commande</h2>
                <a href="${pageContext.request.contextPath}/commande" class="btn btn-secondary">
                    Annuler
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ${success}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/commande">
                <input type="hidden" name="action" value="create">

                <div class="card">
                    <h3>Informations de la commande</h3>
                    
                    <div class="form-group">
                        <label for="clientId">Client *</label>
                        <select name="clientId" id="clientId" class="form-control" required>
                            <option value="">Sélectionner un client</option>
                            <c:forEach var="client" items="${clients}">
                                <option value="${client.id}">
                                    ${client.nomComplet} - ${client.email}
                                </option>
                            </c:forEach>
                        </select>
                        <c:if test="${empty clients}">
                            <p class="text-warning">Aucun client disponible. 
                                <a href="${pageContext.request.contextPath}/client?action=create">Créer un client</a>
                            </p>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="commentaire">Commentaire</label>
                        <textarea name="commentaire" id="commentaire" 
                                  class="form-control" rows="3"></textarea>
                    </div>
                </div>

                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3>Articles</h3>
                        <button type="button" class="btn btn-success" onclick="ajouterLigne()">
                            Ajouter un article
                        </button>
                    </div>
                    
                    <c:if test="${empty produits}">
                        <p class="text-warning">Aucun produit disponible. 
                            <a href="${pageContext.request.contextPath}/produit?action=create">Créer un produit</a>
                        </p>
                    </c:if>
                    
                    <div id="lignes-container" class="lignes-container">
                        <!-- Les lignes seront ajoutées dynamiquement ici -->
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary" 
                            <c:if test="${empty clients or empty produits}">disabled</c:if>>
                        Créer la commande
                    </button>
                    <a href="${pageContext.request.contextPath}/commande" class="btn btn-secondary">
                        Annuler
                    </a>
                </div>
            </form>
        </main>

        <footer>
            <p>&copy; Gestion des Commandes </p>
        </footer>
    </div>
</body>
</html>
