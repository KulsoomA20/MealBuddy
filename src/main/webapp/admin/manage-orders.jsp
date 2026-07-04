<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.OrderTable, com.tap.model.Restaurant, com.tap.DAOimpl.OrderTableDAOimpl, com.tap.DAOimpl.RestaurantDAOimpl, com.tap.DAOimpl.UserDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
    UserDAOimpl userDAO = new UserDAOimpl();
    OrderTableDAOimpl orderDAO = new OrderTableDAOimpl();

    List<Restaurant> ownedRestaurants = restaurantDAO.getRestaurantsByAdmin(loggedUser.getUserId());
    boolean isRestaurantAdmin = !ownedRestaurants.isEmpty();

    List<OrderTable> allOrders = orderDAO.getAllOrders();
    java.util.List<OrderTable> orders = new java.util.ArrayList<>();

    if (isRestaurantAdmin) {
        for (OrderTable o : allOrders) {
            for (Restaurant r : ownedRestaurants) {
                if (o.getRestId() == r.getRestId()) {
                    orders.add(o);
                    break;
                }
            }
        }
    } else {
        orders = allOrders;
    }
    List<User> riders = userDAO.getUsersByRole("delivery");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="manage-orders-container">
        <div class="orders-title" style="display:flex; justify-content:space-between; align-items:center;">
            <span><%= isRestaurantAdmin ? "Manage Restaurant Orders" : "Track all System Orders" %></span>
            <a href="admin-dashboard.jsp" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                <i class="fa-solid fa-arrow-left"></i> Dashboard
            </a>
        </div>

        <% if (orders != null && !orders.isEmpty()) { %>
            <% for (OrderTable order : orders) { 
                Restaurant rest = restaurantDAO.getRestaurant(order.getRestId());
                User customer = userDAO.getUser(order.getUserId());
            %>
                <div class="order-row-card glass-panel" style="margin-bottom: 1.5rem;">
                    <div class="order-col-left" style="flex: 1; min-width: 250px;">
                        <div style="font-weight: 700; font-size: 1.15rem; display: flex; align-items: center; gap: 0.75rem;">
                            <span>Order #<%= order.getOrderId() %></span>
                            <% if (isRestaurantAdmin) { %>
                                <span style="background:rgba(255, 95, 46, 0.1); color:var(--primary); font-size:0.7rem; padding:0.15rem 0.5rem; border-radius:4px; font-weight:600; text-transform:uppercase;">
                                    <%= rest != null ? rest.getRestName() : "" %>
                                </span>
                            <% } %>
                        </div>
                        
                        <% if (!isRestaurantAdmin) { %>
                            <div class="order-meta-info">
                                Restaurant: <strong><%= rest != null ? rest.getRestName() : "Unknown" %></strong>
                            </div>
                        <% } %>
                        <div class="order-meta-info">
                            Customer: <strong><%= customer != null ? customer.getUserName() : "User " + order.getUserId() %></strong> (ID: <%= order.getUserId() %>)
                        </div>
                        <div class="order-meta-info">
                            Date: <%= order.getOrderDate() %> | Payment: <strong><%= order.getPaymentMethod() %></strong>
                        </div>
                    </div>

                    <div class="order-col-right" style="min-width: 220px;">
                        <div style="font-size: 1.25rem; font-weight: 800; color: var(--text-main);">Rs. <%= order.getTotalAmount() %></div>
                        
                        <div class="order-meta-info" style="margin-bottom: 0.5rem;">
                            Status: <strong style="text-transform:uppercase; color:<%= 
                                "Delivered".equalsIgnoreCase(order.getStatus()) ? "#10b981" :
                                "Cancelled".equalsIgnoreCase(order.getStatus()) ? "#ef4444" :
                                "Out_for_Delivery".equalsIgnoreCase(order.getStatus()) ? "#f97316" :
                                "Ready".equalsIgnoreCase(order.getStatus()) ? "#eab308" :
                                "#38bdf8"
                            %>;"><%= order.getStatus() %></strong>
                        </div>

                        <!-- Operations (Rider Assignment or Status Update) -->
                        <div style="display: flex; flex-direction: column; gap: 0.5rem; align-items: flex-end; width: 100%;">
                            <% if (order.getDeliveryPartnerId() == 0 && !"Cancelled".equalsIgnoreCase(order.getStatus())) { %>
                                <!-- No Rider Assigned: Show Rider Selector -->
                                <form action="${pageContext.request.contextPath}/admin-control" method="POST" class="control-form" style="width: 100%; display: flex; gap: 0.25rem;">
                                    <input type="hidden" name="action" value="assignRider">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <label for="riderSelect-<%= order.getOrderId() %>" style="display:none;">Assign Rider</label>
                                    <select id="riderSelect-<%= order.getOrderId() %>" name="riderId" class="mini-select" style="flex-grow:1; padding:0.4rem; font-size:0.8rem; background:rgba(0,0,0,0.3); color:white; border:1px solid var(--border-color);" required>
                                        <option value="" disabled selected>Assign Rider</option>
                                        <% if (riders != null) { 
                                            for (User rider : riders) { %>
                                                <option value="<%= rider.getUserId() %>"><%= rider.getUserName() %></option>
                                        <%  } 
                                        } %>
                                    </select>
                                    <button type="submit" class="btn btn-primary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                                        Assign
                                    </button>
                                </form>
                            <% } else { 
                                User assignedRider = userDAO.getUser(order.getDeliveryPartnerId());
                            %>
                                <% if (assignedRider != null) { %>
                                    <div class="order-meta-info" style="font-size: 0.8rem;">
                                        Rider: <strong><%= assignedRider.getUserName() %></strong>
                                    </div>
                                <% } %>

                                <!-- Step-by-Step Transition Buttons -->
                                <div style="display: flex; gap: 0.5rem; justify-content: flex-end; width: 100%;">
                                    <% if ("PLACED".equalsIgnoreCase(order.getStatus())) { %>
                                        <!-- No buttons, user must assign rider first -->
                                        <span style="font-size: 0.8rem; color: var(--text-muted); font-style: italic;">Please assign a rider to confirm order</span>
                                    <% } else if ("Confirmed".equalsIgnoreCase(order.getStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="display:contents;">
                                            <input type="hidden" name="action" value="updateOrderStatus">
                                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                            <input type="hidden" name="status" value="Preparing">
                                            <button type="submit" class="btn btn-primary" style="padding: 0.45rem 1rem; font-size: 0.8rem; width: 100%;">
                                                Prepare Food <i class="fa-solid fa-fire-burner"></i>
                                            </button>
                                        </form>
                                    <% } else if ("Preparing".equalsIgnoreCase(order.getStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="display:contents;">
                                            <input type="hidden" name="action" value="updateOrderStatus">
                                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                            <input type="hidden" name="status" value="Ready">
                                            <button type="submit" class="btn btn-primary" style="background:#eab308; border-color:#eab308; padding: 0.45rem 1rem; font-size: 0.8rem; width: 100%;">
                                                Mark Food Ready <i class="fa-solid fa-check-double"></i>
                                            </button>
                                        </form>
                                    <% } else if ("Ready".equalsIgnoreCase(order.getStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="display:contents;">
                                            <input type="hidden" name="action" value="updateOrderStatus">
                                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                            <input type="hidden" name="status" value="Out_for_Delivery">
                                            <button type="submit" class="btn btn-primary" style="background:#f97316; border-color:#f97316; padding: 0.45rem 1rem; font-size: 0.8rem; width: 100%;">
                                                Mark Collected <i class="fa-solid fa-truck-ramp-box"></i>
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            <% } %>
                            
                            <% if (!"Delivered".equalsIgnoreCase(order.getStatus()) && !"Cancelled".equalsIgnoreCase(order.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="width:100%; display: flex; justify-content: flex-end;">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <input type="hidden" name="status" value="Cancelled">
                                    <button type="submit" class="btn btn-secondary" style="color:#ef4444; border-color:rgba(239, 68, 68, 0.2); padding: 0.3rem 0.6rem; font-size: 0.75rem; background:rgba(239, 68, 68, 0.05); width: 100%; margin-top: 0.25rem;">
                                        Cancel Order
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="glass-panel" style="text-align: center; padding: 4rem;">
                <i class="fa-solid fa-receipt" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                <h3>No Orders Recorded</h3>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Incoming orders from customers will show up here.</p>
            </div>
        <% } %>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
