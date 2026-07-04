<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.Restaurant, com.tap.model.OrderTable, com.tap.DAOimpl.RestaurantDAOimpl, com.tap.DAOimpl.OrderTableDAOimpl, com.tap.DAOimpl.UserDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
    OrderTableDAOimpl orderDAO = new OrderTableDAOimpl();
    UserDAOimpl userDAO = new UserDAOimpl();

    List<Restaurant> ownedRestaurants = restaurantDAO.getRestaurantsByAdmin(loggedUser.getUserId());
    boolean isRestaurantAdmin = !ownedRestaurants.isEmpty();

    int totalRestaurants = 0;
    int totalOrders = 0;
    int totalCustomers = 0;
    int totalRiders = 0;
    double totalRevenue = 0.0;

    if (isRestaurantAdmin) {
        totalRestaurants = ownedRestaurants.size();
        List<OrderTable> allOrders = orderDAO.getAllOrders();
        for (OrderTable order : allOrders) {
            for (Restaurant r : ownedRestaurants) {
                if (order.getRestId() == r.getRestId()) {
                    totalOrders++;
                    if (!"Cancelled".equalsIgnoreCase(order.getStatus()) && 
                        ("Delivered".equalsIgnoreCase(order.getStatus()) || "Online".equalsIgnoreCase(order.getPaymentMethod()))) {
                        totalRevenue += order.getTotalAmount();
                    }
                }
            }
        }
        totalRiders = userDAO.getUsersByRole("delivery").size();
    } else {
        totalRestaurants = restaurantDAO.getAllRestaurants().size();
        List<OrderTable> allOrders = orderDAO.getAllOrders();
        totalOrders = allOrders.size();
        for (OrderTable order : allOrders) {
            if (!"Cancelled".equalsIgnoreCase(order.getStatus()) && 
                ("Delivered".equalsIgnoreCase(order.getStatus()) || "Online".equalsIgnoreCase(order.getPaymentMethod()))) {
                totalRevenue += order.getTotalAmount();
            }
        }
        totalCustomers = userDAO.getUsersByRole("customer").size();
        totalRiders = userDAO.getUsersByRole("delivery").size();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="admin-container">
        <div class="admin-header">
            <h2>Welcome, <%= loggedUser.getUserName() %></h2>
            <p><%= isRestaurantAdmin ? "Restaurant Partner Control Center" : "Global System Administrator Dashboard" %></p>
        </div>

        <!-- Metric Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card glass-panel">
                <div class="stat-icon"><i class="fa-solid fa-store"></i></div>
                <div>
                    <div class="stat-num"><%= totalRestaurants %></div>
                    <div class="stat-label">Restaurants</div>
                </div>
            </div>
            <div class="stat-card glass-panel">
                <div class="stat-icon"><i class="fa-solid fa-receipt"></i></div>
                <div>
                    <div class="stat-num"><%= totalOrders %></div>
                    <div class="stat-label">Total Orders</div>
                </div>
            </div>
            <% if (isRestaurantAdmin) { %>
                <div class="stat-card glass-panel">
                    <div class="stat-icon"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                    <div>
                        <div class="stat-num"><%= (int) totalRevenue %></div>
                        <div class="stat-label">Total Earnings (Rs.)</div>
                    </div>
                </div>
            <% } else { %>
                <div class="stat-card glass-panel">
                    <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                    <div>
                        <div class="stat-num"><%= totalCustomers %></div>
                        <div class="stat-label">Registered Customers</div>
                    </div>
                </div>
            <% } %>
            <div class="stat-card glass-panel">
                <div class="stat-icon"><i class="fa-solid fa-motorcycle"></i></div>
                <div>
                    <div class="stat-num"><%= totalRiders %></div>
                    <div class="stat-label">Active Riders</div>
                </div>
            </div>
        </div>

        <!-- Section Navigation Shortcuts -->
        <div class="admin-sections">
            <div class="section-action-card glass-panel">
                <h3>Manage Restaurants</h3>
                <p>Register new food establishments, edit details, upload banner images, and activate or deactivate outlets.</p>
                <a href="manage-restaurants.jsp" class="btn btn-primary" style="margin-top: auto; align-self: flex-start;">
                    Go to Restaurants <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>

            <div class="section-action-card glass-panel">
                <h3>Manage Orders</h3>
                <p>Monitor order cycles. Confirm incoming requests, assign available delivery partners, and coordinate status updates.</p>
                <a href="manage-orders.jsp" class="btn btn-primary" style="margin-top: auto; align-self: flex-start;">
                    Go to Orders <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
