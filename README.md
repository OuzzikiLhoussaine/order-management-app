# 📦 Order Management Application

<div align="center">

![Java EE](https://img.shields.io/badge/Java%20EE-8-orange?style=for-the-badge&logo=java)
![WildFly](https://img.shields.io/badge/WildFly-26-red?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)
![Maven](https://img.shields.io/badge/Maven-3.x-C71A36?style=for-the-badge&logo=apachemaven)
![License](https://img.shields.io/badge/License-Academic-green?style=for-the-badge)

**A full-stack enterprise web application for managing orders, clients and products — built with Java EE 8.**

*Master DevOps & Cloud Computing · Faculté Polydisciplinaire – Larache · 2025–2026*

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Data Model](#-data-model)
- [Features](#-features)
- [Order Lifecycle](#-order-lifecycle)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Authors](#-authors)

---

## 🌟 Overview

This project is a complete **Order Management System** developed as part of the *Distributed Applications* module. It covers the full lifecycle of customer orders — from creation to delivery — with automatic stock management, transactional integrity via EJB, and a clean multi-tier architecture following JEE best practices.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Business Logic** | Enterprise JavaBeans (EJB 3.x) |
| **Persistence** | JPA 2.2 / Hibernate 5.6 |
| **Presentation** | Servlets + JSP / JSTL |
| **Database** | MySQL 8.0 |
| **Application Server** | WildFly 26 |
| **Build Tool** | Maven 3.x |
| **Java Version** | Java 11 |

---

## 🏗 Architecture

The application follows a clean **4-tier architecture**:

```
┌─────────────────────────────────────┐
│      Presentation Layer (View)       │
│            JSP / JSTL                │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Controller Layer               │
│  ClientServlet │ CommandeServlet     │
│                │ ProduitServlet      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Business Layer (EJB)           │
│  ClientBean │ CommandeBean           │
│             │ ProduitBean            │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Persistence Layer (JPA)          │
│         Repositories → MySQL         │
└─────────────────────────────────────┘
```

**Request flow:** User → Servlet → EJB (business logic) → JPA (data access) → MySQL → JSP (response rendered)

---

## 🗃 Data Model

```
CLIENT (1) ──────────── (N) COMMANDE
                              │
                              │ (1)
                              │
                        (N) LIGNE_COMMANDE (N) ──── (1) PRODUIT
```

**Key relations:**
- `Client ↔ Commande` : OneToMany — a client can have multiple orders
- `Commande ↔ LigneCommande` : OneToMany bidirectional, cascade ALL + orphanRemoval
- `Produit ↔ LigneCommande` : OneToMany — a product can appear in multiple order lines

---

## ✅ Features

### 👤 Client Management
- Create, read, update, delete clients
- Unique email constraint
- View full order history per client

### 📦 Product Management
- Add and update products with stock levels
- Real-time stock availability indicator (En stock / Rupture)
- Category-based filtering

### 🛒 Order Management
- Create orders with multiple product lines
- Automatic stock deduction on order creation
- Automatic stock restoration on order cancellation
- Status management with controlled transitions
- Filter orders by status

---

## 🔄 Order Lifecycle

```
  EN_ATTENTE ──► VALIDÉE ──► EN_PRÉPARATION ──► EXPÉDIÉE ──► LIVRÉE
      │              │               │                            ▲
      │              │               │                            │
      └──────────────┴───────────────┘                    (final state)
                     │
                     ▼
                  ANNULÉE
          (possible at any point
           except LIVRÉE)
```

| Status | Description |
|---|---|
| `EN_ATTENTE` | Order created, waiting for validation |
| `VALIDÉE` | Order confirmed |
| `EN_PRÉPARATION` | Order being prepared |
| `EXPÉDIÉE` | Order shipped to client |
| `LIVRÉE` | Order successfully delivered (final) |
| `ANNULÉE` | Order cancelled (stock restored) |

---

## 🚀 Getting Started

### Prerequisites

- Java 11+
- Maven 3.x
- MySQL 8.0
- WildFly 26

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/order-management-app.git
cd order-management-app
```

### 2. Set up the database

```sql
CREATE DATABASE order_management;
CREATE USER 'orderapp'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON order_management.* TO 'orderapp'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configure WildFly DataSource

Add a datasource in WildFly's `standalone.xml`:

```xml
<datasource jndi-name="java:jboss/datasources/OrderManagementDS"
            pool-name="OrderManagementDS" enabled="true">
    <connection-url>jdbc:mysql://localhost:3306/order_management</connection-url>
    <driver>mysql</driver>
    <security>
        <user-name>orderapp</user-name>
        <password>your_password</password>
    </security>
</datasource>
```

### 4. Build the project

```bash
mvn clean package
```

### 5. Deploy to WildFly

Copy the generated WAR to WildFly's deployment folder:

```bash
cp target/order-management.war $WILDFLY_HOME/standalone/deployments/
```

### 6. Access the application

```
http://localhost:8080/order-management
```

---

## 📁 Project Structure

```
mini-project/
├── pom.xml
└── src/
    └── main/
        ├── java/
        │   └── com/orderapp/
        │       ├── ejb/                   # Business layer (EJB)
        │       │   ├── ClientBean.java
        │       │   ├── CommandeBean.java
        │       │   ├── CommandeException.java
        │       │   └── ProduitBean.java
        │       ├── entity/                # JPA Entities
        │       │   ├── Client.java
        │       │   ├── Commande.java
        │       │   ├── LigneCommande.java
        │       │   ├── Produit.java
        │       │   └── StatutCommande.java
        │       ├── servlet/               # Controller layer
        │       │   ├── ClientServlet.java
        │       │   ├── CommandeServlet.java
        │       │   └── ProduitServlet.java
        │       └── util/
        │           └── DateTimeUtils.java
        ├── resources/
        │   └── META-INF/
        │       └── persistence.xml        # JPA configuration
        └── webapp/
            ├── WEB-INF/
            │   ├── jsp/
            │   │   ├── client/            # Client views
            │   │   ├── commande/          # Order views
            │   │   └── produit/           # Product views
            │   └── web.xml
            ├── css/
            └── index.jsp                  # Dashboard
```

---

## 👨‍💻 Authors

| Name | Role |
|---|---|
| **OUZZIKI Lhoussaine** | Developer — Master DevOps & Cloud Computing |
| **ARIBI Zakaria** | Developer — Master DevOps & Cloud Computing |

**Supervisor:** Pr. Mohamed EL MAHJOUBY  
**Institution:** Faculté Polydisciplinaire – Larache, Université Abdelmalek Essaadi  
**Module:** Applications Distribuées · 2025–2026

---

