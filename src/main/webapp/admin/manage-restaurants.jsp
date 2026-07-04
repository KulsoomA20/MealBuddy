<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.Restaurant, com.tap.DAOimpl.RestaurantDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
    List<Restaurant> ownedRestaurants = restaurantDAO.getRestaurantsByAdmin(loggedUser.getUserId());
    boolean isRestaurantAdmin = !ownedRestaurants.isEmpty();
    List<Restaurant> list = isRestaurantAdmin ? ownedRestaurants : restaurantDAO.getAllRestaurants();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Restaurants - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="manage-container">
        <!-- List of Restaurants -->
        <div>
            <div class="manage-card glass-panel">
                <div class="manage-title">Registered Restaurants</div>
                
                <% if (list != null && !list.isEmpty()) { %>
                    <% for (Restaurant rest : list) { %>
                        <div class="rest-row">
                            <div class="rest-details">
                                <h4><%= rest.getRestName() %></h4>
                                <p><i class="fa-solid fa-utensils"></i> <%= rest.getCuisineType() %> | <i class="fa-solid fa-map-marker-alt"></i> <%= rest.getAddress() %></p>
                                <p style="margin-top: 0.25rem; display: flex; gap: 1rem; align-items: center;">
                                    <span>
                                        Status: 
                                        <% if (rest.isActive()) { %>
                                            <span style="color: var(--accent); font-weight: 600;">Active</span>
                                        <% } else { %>
                                            <span style="color: #ef4444; font-weight: 600;">Inactive</span>
                                        <% } %>
                                    </span>
                                    <span>
                                        Type: 
                                        <% if ("Veg".equals(rest.getRestType())) { %>
                                            <span style="color: #22c55e; font-weight: 600;"><i class="fa-solid fa-leaf"></i> Veg</span>
                                        <% } else if ("Non-Veg".equals(rest.getRestType())) { %>
                                            <span style="color: #ef4444; font-weight: 600;"><i class="fa-solid fa-drumstick-bite"></i> Non-Veg</span>
                                        <% } else { %>
                                            <span style="color: #eab308; font-weight: 600;"><i class="fa-solid fa-circle-half-stroke"></i> Both</span>
                                        <% } %>
                                    </span>
                                </p>
                            </div>
                            
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <a href="manage-menu.jsp?restId=<%= rest.getRestId() %>" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                                    <i class="fa-solid fa-clipboard-list"></i> Menu
                                </a>
                                <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="display:contents;">
                                    <input type="hidden" name="action" value="toggleRestaurantStatus">
                                    <input type="hidden" name="restId" value="<%= rest.getRestId() %>">
                                    <button type="submit" class="btn <%= rest.isActive() ? "btn-secondary" : "btn-primary" %>" style="padding: 0.5rem 1rem; font-size: 0.85rem; border: 1px solid var(--border-color);">
                                        <%= rest.isActive() ? "Deactivate" : "Activate" %>
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div style="text-align: center; padding: 3rem 0; color: var(--text-muted);">
                        <i class="fa-solid fa-store-slash" style="font-size: 2.5rem; margin-bottom: 1rem;"></i>
                        <p>No restaurants registered. Add one on the right!</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Add Restaurant Form -->
        <div>
            <div class="manage-card glass-panel" style="position: sticky; top: 6rem;">
                <div class="manage-title">Add Restaurant</div>
                <form action="${pageContext.request.contextPath}/admin-control" method="POST">
                    <input type="hidden" name="action" value="addRestaurant">
                    
                    <div class="form-group">
                        <label for="restName">Restaurant Name</label>
                        <input type="text" id="restName" name="restName" class="form-control" placeholder="e.g. Pizza Palace" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="cuisineType">Cuisine Type</label>
                        <input type="text" id="cuisineType" name="cuisineType" class="form-control" placeholder="e.g. Italian, North Indian" required>
                    </div>

                    <div class="form-group">
                        <label for="deliveryTime">Delivery Time (minutes)</label>
                        <input type="number" id="deliveryTime" name="deliveryTime" class="form-control" placeholder="e.g. 30" required min="5">
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" class="form-control" placeholder="Enter full address" required>
                    </div>

                    <div class="form-group">
                        <label for="restType">Restaurant Type</label>
                        <select id="restType" name="restType" class="form-control" style="background: var(--bg-card); color: var(--text-color); border: 1px solid var(--border-color); padding: 0.8rem; border-radius: var(--radius-sm); width: 100%;">
                            <option value="Both">Both (Veg & Non-Veg)</option>
                            <option value="Veg">Veg Only</option>
                            <option value="Non-Veg">Non-Veg Only</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="imagePath">Image Path (filename)</label>
                        <input type="text" id="imagePath" name="imagePath" class="form-control" placeholder="e.g. pizza.jpg" required>
                    </div>

                    <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; cursor: pointer; margin-bottom: 1.5rem;">
                        <input type="checkbox" name="isActive" value="true" checked style="accent-color: var(--primary);"> Make restaurant active
                    </label>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.8rem;">
                        Register Restaurant
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
