# MealBuddy - Gourmet Food Delivery Platform

[![Java Version](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/technologies/downloads/)
[![Tomcat Version](https://img.shields.io/badge/Tomcat-10-blue.svg)](https://tomcat.apache.org/)
[![Database](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)

MealBuddy is a premium, full-stack Java Web Application built using JSP, Servlets, and Maven. It provides an end-to-end marketplace for gourmet food ordering and delivery, featuring separate dedicated portals for **Customers**, **Restaurant Merchants**, and **Delivery Riders**.

Check it out here https://mealbuddy-production-0489.up.railway.app/

---

## Key Features

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

## 🛠️ Technology Stack
*   **Core Logic**: Java 17, Jakarta Servlet API 6.0, Jakarta Server Pages (JSP) 3.1
*   **Dependency Management**: Apache Maven
*   **Database**: MySQL (relational structure with relational constraints)
*   **Security**: `jbcrypt` (0.4)
*   **Deployment Server**: Apache Tomcat 10 (Servlet 6.0 compatible container)

---

## ☁️ Cloud Deployment (Railway)
MealBuddy is designed for zero-configuration cloud deployment:
1.  **Dynamic Connection**: The database connector automatically detects cloud connection variables (`MYSQLHOST`, `MYSQLPORT`, etc.) when running on Railway.
2.  **Tomcat Runner**: Bundled with `webapp-runner` in Maven to containerize the WAR file.



