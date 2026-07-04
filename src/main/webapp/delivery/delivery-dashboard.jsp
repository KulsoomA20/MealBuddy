<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.OrderTable, com.tap.model.Restaurant, com.tap.model.Address, com.tap.DAOimpl.OrderTableDAOimpl, com.tap.DAOimpl.RestaurantDAOimpl, com.tap.DAOimpl.AddressDAOimpl, com.tap.DAOimpl.UserDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"delivery".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    OrderTableDAOimpl orderDAO = new OrderTableDAOimpl();
    RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
    AddressDAOimpl addressDAO = new AddressDAOimpl();
    UserDAOimpl userDAO = new UserDAOimpl();

    List<OrderTable> list = orderDAO.getOrdersByDeliveryPartner(loggedUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rider Dashboard - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="rider-container">
        <div class="rider-header">
            <h2>Assigned Deliveries</h2>
            <div style="font-size: 0.95rem; color: var(--text-muted);">
                Rider: <strong style="color: var(--text-main);"><%= loggedUser.getUserName() %></strong>
            </div>
        </div>

        <% if (list != null && !list.isEmpty()) { %>
            <% for (OrderTable order : list) { 
                Restaurant rest = restaurantDAO.getRestaurant(order.getRestId());
                Address delivAddr = addressDAO.getAddress(order.getAddressId());
                User customer = userDAO.getUser(order.getUserId());
            %>
                <div class="delivery-card glass-panel" style="margin-bottom: 1.5rem;">
                    <div style="display: flex; flex-direction: column; gap: 1.25rem; flex: 1;">
                        <div style="font-weight: 700; font-size: 1.2rem;">Delivery Order #<%= order.getOrderId() %></div>
                        
                        <!-- Restaurant pickup details -->
                        <div class="info-group">
                            <span class="info-title">1. Pickup Restaurant</span>
                            <span class="info-value"><%= rest != null ? rest.getRestName() : "Unknown" %></span>
                            <span style="color: var(--text-muted); font-size: 0.9rem;"><%= rest != null ? rest.getAddress() : "" %></span>
                        </div>

                        <!-- Customer delivery details -->
                        <div class="info-group">
                            <span class="info-title">2. Deliver To</span>
                            <span class="info-value"><%= customer != null ? customer.getUserName() : "Customer" %> (<%= customer != null ? customer.getPhone() : "" %>)</span>
                            <span style="color: var(--text-muted); font-size: 0.9rem;">
                                <%= delivAddr != null ? delivAddr.getStreet() + ", " + delivAddr.getCity() + " - " + delivAddr.getPincode() : "No Address" %>
                            </span>
                        </div>
                    </div>

                    <div class="action-column" style="min-width: 200px; display: flex; flex-direction: column; align-items: flex-end; justify-content: space-between;">
                        <div style="text-align: right;">
                            <div style="font-size: 1.25rem; font-weight: 800; color: var(--text-main);">Rs. <%= order.getTotalAmount() %></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 0.25rem;">
                                Method: <strong><%= order.getPaymentMethod() %></strong>
                            </div>
                        </div>

                        <div style="margin: 0.75rem 0;">
                            <span class="status-badge <%= "Delivered".equalsIgnoreCase(order.getStatus()) ? "status-done" : "status-active" %>" style="color:<%= 
                                "Delivered".equalsIgnoreCase(order.getStatus()) ? "#10b981" : "#f97316"
                            %>; border-color:<%=
                                "Delivered".equalsIgnoreCase(order.getStatus()) ? "rgba(16, 185, 129, 0.2)" : "rgba(249, 115, 22, 0.2)"
                            %>;">
                                <%= order.getStatus() %>
                            </span>
                        </div>

                        <!-- Update Delivery Status -->
                        <% if ("Ready".equalsIgnoreCase(order.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="width: 100%;">
                                <input type="hidden" name="action" value="updateOrderStatus">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="status" value="Out_for_Delivery">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.55rem; font-size: 0.85rem; background:#f97316; border-color:#f97316;">
                                    Collect Order <i class="fa-solid fa-truck-ramp-box" style="margin-left:0.25rem;"></i>
                                </button>
                            </form>
                        <% } else if ("Out_for_Delivery".equalsIgnoreCase(order.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="width: 100%;">
                                <input type="hidden" name="action" value="updateOrderStatus">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                <input type="hidden" name="status" value="Delivered">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.55rem; font-size: 0.85rem; background:#10b981; border-color:#10b981;">
                                    Mark Delivered <i class="fa-solid fa-house-chimney-user" style="margin-left:0.25rem;"></i>
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="glass-panel" style="text-align: center; padding: 4rem;">
                <i class="fa-solid fa-motorcycle" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                <h3>No Deliveries Assigned</h3>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">When the admin assigns an order, it will show up here.</p>
            </div>
        <% } %>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
