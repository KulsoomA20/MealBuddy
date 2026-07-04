<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.OrderTable, com.tap.model.Restaurant, com.tap.model.User" %>
<%
    OrderTable order = (OrderTable) request.getAttribute("order");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    User rider = (User) request.getAttribute("rider");
    
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }
    
    String status = order.getStatus();
    
    // Determine progress bar width
    String progressWidth = "0%";
    if ("PLACED".equalsIgnoreCase(status)) progressWidth = "12.5%";
    else if ("Confirmed".equalsIgnoreCase(status) || "Preparing".equalsIgnoreCase(status)) progressWidth = "37.5%";
    else if ("Ready".equalsIgnoreCase(status)) progressWidth = "62.5%";
    else if ("Out_for_Delivery".equalsIgnoreCase(status)) progressWidth = "87.5%";
    else if ("Delivered".equalsIgnoreCase(status)) progressWidth = "100%";
    
    // Determine step states (completed, active, or pending)
    String s1 = "pending", s2 = "pending", s3 = "pending", s4 = "pending", s5 = "pending";
    
    if ("PLACED".equalsIgnoreCase(status)) {
        s1 = "active";
    } else if ("Confirmed".equalsIgnoreCase(status) || "Preparing".equalsIgnoreCase(status)) {
        s1 = "completed"; s2 = "active";
    } else if ("Ready".equalsIgnoreCase(status)) {
        s1 = "completed"; s2 = "completed"; s3 = "active";
    } else if ("Out_for_Delivery".equalsIgnoreCase(status)) {
        s1 = "completed"; s2 = "completed"; s3 = "completed"; s4 = "active";
    } else if ("Delivered".equalsIgnoreCase(status)) {
        s1 = "completed"; s2 = "completed"; s3 = "completed"; s4 = "completed"; s5 = "completed";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order #<%= order.getOrderId() %> - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="track-container">
        <div class="track-card glass-panel">
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
                <div>
                    <h2 style="font-size:1.8rem; font-weight:850; background: var(--primary-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Track Order #<%= order.getOrderId() %></h2>
                    <p style="color:var(--text-muted); font-size:0.9rem; margin-top:0.25rem;">Placed on <%= order.getOrderDate() %></p>
                </div>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                    <i class="fa-solid fa-clock-rotate-left"></i> Order History
                </a>
            </div>

            <!-- Tracker Timeline -->
            <div class="tracker-flow">
                <div class="tracker-flow-bar" style="width: <%= progressWidth %>;"></div>
                
                <div class="tracker-step <%= s1 %>">
                    <div class="tracker-dot"><i class="fa-solid fa-receipt"></i></div>
                    <span class="tracker-label">Placed</span>
                </div>
                <div class="tracker-step <%= s2 %>">
                    <div class="tracker-dot"><i class="fa-solid fa-fire-burner"></i></div>
                    <span class="tracker-label">Preparing</span>
                </div>
                <div class="tracker-step <%= s3 %>">
                    <div class="tracker-dot"><i class="fa-solid fa-utensils"></i></div>
                    <span class="tracker-label">Ready</span>
                </div>
                <div class="tracker-step <%= s4 %>">
                    <div class="tracker-dot"><i class="fa-solid fa-motorcycle"></i></div>
                    <span class="tracker-label">Out</span>
                </div>
                <div class="tracker-step <%= s5 %>">
                    <div class="tracker-dot"><i class="fa-solid fa-house-chimney-user"></i></div>
                    <span class="tracker-label">Delivered</span>
                </div>
            </div>

            <!-- Details Panel -->
            <div class="track-details">
                <div>
                    <h3 style="font-size:1.15rem; font-weight:700; margin-bottom:1rem; border-bottom:1px solid var(--border-color); padding-bottom:0.5rem;">From Restaurant</h3>
                    <div style="font-weight:700; font-size:1.1rem; color:var(--text-main);"><%= restaurant != null ? restaurant.getRestName() : "Unknown Restaurant" %></div>
                    <div style="color:var(--text-muted); font-size:0.9rem; margin-top:0.25rem;"><%= restaurant != null ? restaurant.getAddress() : "" %></div>
                    
                    <% if ("Preparing".equalsIgnoreCase(status)) { %>
                        <div style="margin-top:1.5rem; display:flex; align-items:center; gap:0.75rem; color:#facc15; font-size:0.9rem; font-weight:600;">
                            <i class="fa-solid fa-fire-burner fa-bounce"></i> Chef is preparing your hot meal...
                        </div>
                    <% } else if ("Ready".equalsIgnoreCase(status)) { %>
                        <div style="margin-top:1.5rem; display:flex; align-items:center; gap:0.75rem; color:var(--accent); font-size:0.9rem; font-weight:600;">
                            <i class="fa-solid fa-circle-check fa-fade"></i> Food is packed and ready for pickup!
                        </div>
                    <% } else if ("Out_for_Delivery".equalsIgnoreCase(status)) { %>
                        <div style="margin-top:1.5rem; display:flex; align-items:center; gap:0.75rem; color:#f97316; font-size:0.9rem; font-weight:600;">
                            <i class="fa-solid fa-motorcycle fa-shake"></i> Delivery partner is racing to your door!
                        </div>
                    <% } else if ("Delivered".equalsIgnoreCase(status)) { %>
                        <div style="margin-top:1.5rem; display:flex; align-items:center; gap:0.75rem; color:var(--accent); font-size:0.9rem; font-weight:600;">
                            <i class="fa-solid fa-circle-check"></i> Delivered successfully. Enjoy your meal!
                        </div>
                    <% } %>
                </div>

                <div>
                    <h3 style="font-size:1.15rem; font-weight:700; margin-bottom:1rem; border-bottom:1px solid var(--border-color); padding-bottom:0.5rem;">Delivery Status</h3>
                    <div style="font-size:1rem; margin-bottom:0.5rem;">
                        Order Status: <strong style="text-transform:uppercase; color:<%= 
                            "Delivered".equalsIgnoreCase(status) ? "#10b981" :
                            "Cancelled".equalsIgnoreCase(status) ? "#ef4444" :
                            "Out_for_Delivery".equalsIgnoreCase(status) ? "#f97316" :
                            "Ready".equalsIgnoreCase(status) ? "#eab308" :
                            "#38bdf8"
                        %>;"><%= status %></strong>
                    </div>
                    
                    <% if (rider != null) { %>
                        <div style="margin-top:1rem; border-top:1px solid var(--border-color); padding-top:1rem;">
                            <div style="font-size:0.8rem; color:var(--text-muted); text-transform:uppercase; font-weight:700; letter-spacing:0.05em; margin-bottom:0.25rem;">Delivery Executive</div>
                            <div style="font-weight:700; font-size:1.05rem;"><%= rider.getUserName() %></div>
                            <div style="color:var(--text-muted); font-size:0.9rem; margin-top:0.2rem;"><i class="fa-solid fa-phone"></i> <%= rider.getPhone() %></div>
                        </div>
                    <% } else if (!"Cancelled".equalsIgnoreCase(status) && !"Delivered".equalsIgnoreCase(status)) { %>
                        <div style="color:var(--text-muted); font-size:0.9rem; margin-top:1rem;">
                            <i class="fa-solid fa-clock"></i> Assigning a delivery partner shortly...
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
