<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.tap.DAOimpl.RestaurantDAOimpl" %>
<%@ page import="com.tap.DAOimpl.MenuDAOimpl" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>
<%
    RestaurantDAOimpl restDAO = new RestaurantDAOimpl();
    MenuDAOimpl menuDAO = new MenuDAOimpl();
    List<Restaurant> restList = restDAO.getAllRestaurants();
    List<Menu> signatureItems = new ArrayList<>();
    
    if (restList != null) {
        for (Restaurant r : restList) {
            List<Menu> menuList = menuDAO.getMenuByRestaurant(r.getRestId());
            if (menuList != null && !menuList.isEmpty()) {
                // Get the first menu item as the signature dish
                signatureItems.add(menuList.get(0));
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MealBuddy - Gourmet Food Delivered Instantly</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Slider Styles */
        .slider-section {
            margin: 6rem auto;
            max-width: 95%;
            overflow: hidden;
        }
        .slider-container {
            overflow: hidden;
            width: 100%;
            position: relative;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .slider-track {
            display: flex;
            gap: 2rem;
            width: max-content;
            animation: scroll 50s linear infinite;
        }
        .slider-track:hover {
            animation-play-state: paused;
        }
        @keyframes scroll {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(calc(-50% - 1rem));
            }
        }
        .dish-card {
            width: 280px;
            flex-shrink: 0;
            border-radius: var(--radius-md);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: var(--text-main);
            transition: var(--transition);
            border: 1px solid var(--border-color);
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(8px);
        }
        .dish-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary);
            box-shadow: 0 10px 20px rgba(255, 95, 46, 0.15);
            background: rgba(255, 255, 255, 0.06);
        }
        .dish-image-placeholder {
            height: 150px;
            width: 100%;
            background: linear-gradient(135deg, rgba(255, 95, 46, 0.15), rgba(255, 42, 95, 0.15));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            position: relative;
        }
        .dish-info {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .dish-name {
            font-size: 1.1rem;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .dish-rest {
            font-size: 0.85rem;
            color: var(--primary);
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .dish-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.5rem;
        }
        .dish-price {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--text-main);
        }
        .dish-badge {
            padding: 0.25rem 0.6rem;
            border-radius: 6px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            border: 1px solid rgba(255, 255, 255, 0.08);
            white-space: nowrap;
        }
        .dish-badge.veg {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.3);
        }
        .dish-badge.nonveg {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border-color: rgba(239, 68, 68, 0.3);
        }
    </style>
</head>
<body>

    <!-- Dynamic Header -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- Hero Section with Video Background -->
    <main class="hero centered-hero">
        <div class="video-background-container">
            <video autoplay loop muted playsinline class="video-bg">
                <source src="${pageContext.request.contextPath}/videos/cooking.mp4" type="video/mp4">
                <source src="https://www.w3schools.com/html/movie.mp4" type="video/mp4">
            </video>
            <div class="video-overlay"></div>
        </div>

        <div class="hero-content centered-content">
            <div class="hero-brand" style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 3.4rem; font-weight: 500; color: #fcf9f0; margin-bottom: 1rem; letter-spacing: 1.84px; text-transform: uppercase;">
                MealBuddy
            </div>
            <h1 class="hero-title" style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 2.8rem; font-weight: 400; color: #ffffff; margin-bottom: 1.5rem; line-height: 1.0; letter-spacing: 4.5px;">
                Gourmet Food,<br> Delivered Instantly
            </h1>
            <p class="hero-subtitle" style="margin: 1.5rem auto 3rem auto; color: #fcf9f0; max-width: 650px; font-size: 1.25rem; line-height: 1.25; letter-spacing: 0.4px;">
                Satisfy your cravings with the finest cuisines from top-rated local restaurants. Fast delivery, persistent cart, and real-time tracking.
            </p>
            
            <div class="search-container" style="margin: 0 auto; background: rgba(29, 11, 13, 0.85); border: 1px solid rgba(255,255,255,0.15); max-width: 650px; width: 100%; border-radius: 8px;">
                <input type="text" class="search-input" placeholder="Enter your delivery location..." style="color: #ffffff;">
                <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/restaurants'">Find Food</button>
            </div>
        </div>
    </main>

    <!-- Signature Dishes Slider Section -->
    <section class="slider-section">
        <div class="section-header" style="text-align: center; margin-bottom: 2.5rem;">
            <h2 style="color: var(--primary); font-size: 2.4rem;">Signature Delights</h2>
            <p style="color: var(--text-muted); margin-top: 0.5rem; font-size: 1.1rem; letter-spacing: 0.4px;">Best dishes from our top partner restaurants. Click to order!</p>
        </div>
        
        <div class="slider-container">
            <div class="slider-track">
                <!-- First copy of items for marquee loop -->
                <% if (signatureItems != null && !signatureItems.isEmpty()) { %>
                    <% for (Menu dish : signatureItems) { 
                        Restaurant rest = restDAO.getRestaurant(dish.getRestId());
                        String restName = (rest != null) ? rest.getRestName() : "Partner Restaurant";
                    %>
                        <a href="menu?restId=<%= dish.getRestId() %>" class="dish-card">
                            <div class="dish-image-placeholder" style="padding: 0; overflow: hidden; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.02); position: relative;">
                                <% if (dish.getImagePath() != null && !dish.getImagePath().trim().isEmpty()) { 
                                    String imgUrl = dish.getImagePath().trim();
                                    if (!imgUrl.startsWith("http")) {
                                        imgUrl = request.getContextPath() + "/images/" + imgUrl;
                                    }
                                %>
                                    <img src="<%= imgUrl %>" alt="<%= dish.getItemName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <i class="fa-solid fa-utensils" style="color: rgba(255, 255, 255, 0.25);"></i>
                                <% } %>
                            </div>
                            <div class="dish-info">
                                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                                    <span style="border: 1px solid <%= dish.isVeg() ? "#10b981" : "#ef4444" %>; padding: 2px; width: 14px; height: 14px; display: flex; align-items: center; justify-content: center; border-radius: 2px; flex-shrink: 0; box-sizing: border-box;">
                                        <span style="width: <%= dish.isVeg() ? "6px" : "0" %>; height: <%= dish.isVeg() ? "6px" : "0" %>; border-radius: <%= dish.isVeg() ? "50%" : "0" %>; border-left: <%= dish.isVeg() ? "none" : "3px solid transparent" %>; border-right: <%= dish.isVeg() ? "none" : "3px solid transparent" %>; border-bottom: <%= dish.isVeg() ? "none" : "6px solid #ef4444" %>; display: block; background: <%= dish.isVeg() ? "#10b981" : "transparent" %>;"></span>
                                    </span>
                                    <div class="dish-name" style="margin: 0; flex: 1;"><%= dish.getItemName() %></div>
                                </div>
                                <div class="dish-rest"><%= restName %></div>
                                <div class="dish-meta">
                                    <span class="dish-price">₹<%= String.format("%.2f", dish.getPrice()) %></span>
                                    <span style="font-size: 0.8rem; color: var(--text-muted);"><i class="fa-solid fa-star" style="color: #fbbf24; margin-right: 0.25rem;"></i><%= (rest != null) ? rest.getRating() : "4.0" %></span>
                                </div>
                            </div>
                        </a>
                    <% } %>
                    
                    <!-- Second copy of items to create seamless infinite scroll -->
                    <% for (Menu dish : signatureItems) { 
                        Restaurant rest = restDAO.getRestaurant(dish.getRestId());
                        String restName = (rest != null) ? rest.getRestName() : "Partner Restaurant";
                    %>
                        <a href="menu?restId=<%= dish.getRestId() %>" class="dish-card">
                            <div class="dish-image-placeholder" style="padding: 0; overflow: hidden; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.02); position: relative;">
                                <% if (dish.getImagePath() != null && !dish.getImagePath().trim().isEmpty()) { 
                                    String imgUrl = dish.getImagePath().trim();
                                    if (!imgUrl.startsWith("http")) {
                                        imgUrl = request.getContextPath() + "/images/" + imgUrl;
                                    }
                                %>
                                    <img src="<%= imgUrl %>" alt="<%= dish.getItemName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <i class="fa-solid fa-utensils" style="color: rgba(255, 255, 255, 0.25);"></i>
                                <% } %>
                            </div>
                            <div class="dish-info">
                                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                                    <span style="border: 1px solid <%= dish.isVeg() ? "#10b981" : "#ef4444" %>; padding: 2px; width: 14px; height: 14px; display: flex; align-items: center; justify-content: center; border-radius: 2px; flex-shrink: 0; box-sizing: border-box;">
                                        <span style="width: <%= dish.isVeg() ? "6px" : "0" %>; height: <%= dish.isVeg() ? "6px" : "0" %>; border-radius: <%= dish.isVeg() ? "50%" : "0" %>; border-left: <%= dish.isVeg() ? "none" : "3px solid transparent" %>; border-right: <%= dish.isVeg() ? "none" : "3px solid transparent" %>; border-bottom: <%= dish.isVeg() ? "none" : "6px solid #ef4444" %>; display: block; background: <%= dish.isVeg() ? "#10b981" : "transparent" %>;"></span>
                                    </span>
                                    <div class="dish-name" style="margin: 0; flex: 1;"><%= dish.getItemName() %></div>
                                </div>
                                <div class="dish-rest"><%= restName %></div>
                                <div class="dish-meta">
                                    <span class="dish-price">₹<%= String.format("%.2f", dish.getPrice()) %></span>
                                    <span style="font-size: 0.8rem; color: var(--text-muted);"><i class="fa-solid fa-star" style="color: #fbbf24; margin-right: 0.25rem;"></i><%= (rest != null) ? rest.getRating() : "4.0" %></span>
                                </div>
                            </div>
                        </a>
                    <% } %>
                <% } else { %>
                    <div style="padding: 2rem; color: var(--text-muted);">No featured dishes available at this moment.</div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Dynamic Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
