# 🍔 MealBuddy - Gourmet Food Delivery Platform

[![Java Version](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/technologies/downloads/)
[![Tomcat Version](https://img.shields.io/badge/Tomcat-10-blue.svg)](https://tomcat.apache.org/)
[![Database](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

MealBuddy is a premium, full-stack Java Web Application built using JSP, Servlets, and Maven. It provides an end-to-end marketplace for gourmet food ordering and delivery, featuring separate dedicated portals for **Customers**, **Restaurant Merchants**, and **Delivery Riders**.

---

## 🌟 Key Features

### 👤 Customer Portal
*   **Aesthetic Showcase**: Browse premium restaurant menus with responsive layouts and elastic micro-animations.
*   **Smart Cart & Checkout**: Easily manage items, review prices, and place orders.
*   **Dual Payment Modes**: Pay on delivery (COD) or complete payments instantly via a **Dynamic QR Code Checkout**.
*   **Real-time Tracking**: Monitor order status updates (Placed, Preparing, Out for Delivery, Delivered).

### 🏪 Merchant Partner Portal
*   **Dashboard Analytics**: Track live incoming orders and total revenue.
*   **Menu Management**: Add, update, or remove restaurant menu categories and items.
*   **Order Fulfillment**: Accept, prepare, and update order statuses dynamically.

### 🚴 Rider Delivery Portal
*   **Job Dispatch**: Instantly view and accept pending delivery orders.
*   **Navigation & Statusing**: Mark tasks as "Out for Delivery" and complete them with one click.

### 🔒 Enterprise Security
*   **BCrypt Hashing**: Implements salted BCrypt password encryption for all user roles (replaces insecure plain-text storage).
*   **Automatic Upgrades**: Login system automatically upgrades old plain-text database hashes on login.

---

## 🎨 Visual Identity: The Limón Theme
MealBuddy features a custom-crafted design system called **The Limón Theme**, designed for maximum visual appeal and a premium experience:
*   **Color Palette**: High-contrast Warm Cream (`#fffde6`) canvas, Black Olive (`#1d0b0d`) body background, and Lemon Zest (`#f7ea48`) primary actions.
*   **Typography**: Powered by the modern 'Plus Jakarta Sans' font family.
*   **Interactions**: Flat, elevation-free modern cards with smooth card-lifting translations and image-scale hover transitions.

---

## 🛠️ Technology Stack
*   **Core Logic**: Java 17, Jakarta Servlet API 6.0, Jakarta Server Pages (JSP) 3.1
*   **Dependency Management**: Apache Maven
*   **Database**: MySQL (relational structure with relational constraints)
*   **Security**: `jbcrypt` (0.4)
*   **Deployment Server**: Apache Tomcat 10 (Servlet 6.0 compatible container)

---

## 🚀 How to Run Locally

### Prerequisites
*   Java Development Kit (JDK) 17+
*   Apache Tomcat 10+
*   MySQL Server 8.0+
*   Eclipse IDE for Enterprise Java Developers

### Database Setup
1.  Open your MySQL client and create a database named `dao_project`:
    ```sql
    CREATE DATABASE dao_project;
    ```
2.  Import the database schema and seed data:
    *   Locate the SQL seed files inside the project files.
    *   Execute the script to populate the tables (`user`, `restaurant`, `menu`, `ordertable`, `orderitem`, etc.).

### Build & Deploy in Eclipse
1.  Clone the repository and import it into Eclipse as an **Existing Maven Project**.
2.  Open **[DBConnection.java](src/main/java/com/tap/util/DBConnection.java)** and set your local database username and password (default is `root` / `root`).
3.  Right-click the project root ➔ **Maven** ➔ **Update Project**.
4.  Right-click the project ➔ **Run As** ➔ **Run on Server** (select your Tomcat 10 installation).
5.  Access the site at: `http://localhost:8080/MealBuddy/`

---

## ☁️ Cloud Deployment (Railway)
MealBuddy is designed for zero-configuration cloud deployment:
1.  **Dynamic Connection**: The database connector automatically detects cloud connection variables (`MYSQLHOST`, `MYSQLPORT`, etc.) when running on Railway.
2.  **Tomcat Runner**: Bundled with `webapp-runner` in Maven to containerize the WAR file.
3.  **Start Command**:
    ```bash
    java -jar target/dependency/webapp-runner.jar --port $PORT target/MealBuddy.war
    ```

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
