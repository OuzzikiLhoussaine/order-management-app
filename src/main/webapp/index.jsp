<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Commandes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .dashboard-card {
            background: linear-gradient(135deg, var(--primary-color), #1e40af);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            text-align: center;
            transition: transform 0.3s;
            text-decoration: none;
            display: block;
            box-shadow: var(--shadow-md);
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        
        .dashboard-card h3 {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            border: none;
            padding: 0;
        }
        
        .dashboard-card p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .features {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            margin-top: 3rem;
            box-shadow: var(--shadow-sm);
        }
        
        .features h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .features ul {
            list-style: none;
            padding: 0;
        }
        
        .features li {
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .features li:before {
            content: "✓";
            color: var(--success-color);
            font-weight: bold;
            margin-right: 1rem;
            font-size: 1.2rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Système de Gestion des Commandes</h1>
            <nav>
                <a href="${pageContext.request.contextPath}/commande">Commandes</a>
                <a href="${pageContext.request.contextPath}/client">Clients</a>
                <a href="${pageContext.request.contextPath}/produit">Produits</a>
            </nav>
        </header>

        <main>
            <div class="page-header">
                <h2>Bienvenue dans l'application de gestion des commandes</h2>
            </div>

            <div class="dashboard">
                <a href="${pageContext.request.contextPath}/commande" class="dashboard-card">
                    <h3>📦 Commandes</h3>
                    <p>Gérer les commandes clients</p>
                </a>

                <a href="${pageContext.request.contextPath}/client" class="dashboard-card" 
                   style="background: linear-gradient(135deg, var(--success-color), #15803d);">
                    <h3>👥 Clients</h3>
                    <p>Gérer les clients</p>
                </a>

                <a href="${pageContext.request.contextPath}/produit" class="dashboard-card" 
                   style="background: linear-gradient(135deg, var(--warning-color), #d97706);">
                    <h3>🏷️ Produits</h3>
                    <p>Gérer le catalogue produits</p>
                </a>
            </div>

            </div>
        </main>

        <footer>
            <p>&copy;Gestion des Commandes</p>
        </footer>
    </div>
</body>
</html>
