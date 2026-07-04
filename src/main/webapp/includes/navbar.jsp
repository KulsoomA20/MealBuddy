<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.DAOimpl.CartDAOimpl" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<script>
    // Immediately check local storage and apply the theme to prevent screen flash
    (function() {
        const savedTheme = localStorage.getItem('theme') || 'dark';
        document.documentElement.setAttribute('data-theme', savedTheme);
    })();
</script>
<%
    User navUser = (User) session.getAttribute("loggedUser");
    String contextPath = request.getContextPath();
    
    // Check current page for active styling in navbar
    String uri = request.getRequestURI().toLowerCase();
    boolean isHome = uri.endsWith("index.jsp") || uri.endsWith("/") || uri.endsWith("designpattern") || uri.endsWith("designpattern/");
    boolean isBrowse = uri.contains("/restaurants") || uri.contains("/menu") || uri.contains("home.jsp");
    boolean isCart = uri.contains("/cart") || uri.contains("cart.jsp");
    boolean isOrders = uri.contains("/orders") || uri.contains("/order-history.jsp") || uri.contains("order-history.jsp");
    boolean isProfile = uri.contains("/profile.jsp") || uri.contains("profile.jsp");
    boolean isAdminDashboard = uri.contains("admin-dashboard.jsp");
    boolean isAdminRestaurants = uri.contains("manage-restaurants.jsp") || uri.contains("manage-menu.jsp");
    boolean isAdminOrders = uri.contains("manage-orders.jsp");
    boolean isRiderPortal = uri.contains("delivery-dashboard.jsp");
    
    // Get cart item count & details for sliding drawer
    int cartCount = 0;
    List<com.tap.controller.cart.CartServlet.CartItemDetail> drawerCartList = new ArrayList<>();
    double drawerGrandTotal = 0;
    
    try {
        CartDAOimpl navCartDAO = new CartDAOimpl();
        com.tap.DAOimpl.MenuDAOimpl navMenuDAO = new com.tap.DAOimpl.MenuDAOimpl();
        List<Cart> rawCart = null;
        if (navUser != null) {
            rawCart = navCartDAO.getCartByUser(navUser.getUserId());
        } else {
            @SuppressWarnings("unchecked")
            List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
            rawCart = sessionCart;
        }
        
        if (rawCart != null) {
            cartCount = rawCart.size();
            for (Cart c : rawCart) {
                com.tap.model.Menu m = navMenuDAO.getMenuItem(c.getMenuId());
                if (m != null) {
                    com.tap.controller.cart.CartServlet.CartItemDetail detail = 
                        new com.tap.controller.cart.CartServlet.CartItemDetail(c, m);
                    drawerCartList.add(detail);
                    drawerGrandTotal += detail.getSubtotal();
                }
            }
        }
    } catch (Exception e) {
        cartCount = 0;
    }
%>

<header>
    <div class="nav-container">
        <a href="<%= contextPath %>/index.jsp" class="logo">
            <img src="<%= contextPath %>/images/logo1.png" alt="MealBuddy Logo" class="logo-dark-theme">
            <img src="<%= contextPath %>/images/logo2.png" alt="MealBuddy Logo" class="logo-light-theme">
        </a>
        <nav>
            <ul class="nav-links">
                <li><a href="<%= contextPath %>/index.jsp" <%= isHome ? "class=\"active\"" : "" %>>Home</a></li>
                
                <% if (navUser == null) { %>
                    <!-- Public Links -->
                    <li><a href="<%= contextPath %>/restaurants" <%= isBrowse ? "class=\"active\"" : "" %>>Browse</a></li>
                    <li><a href="#" onclick="toggleDrawer(true); return false;" class="cart-link<%= isCart ? " active" : "" %>"><i class="fa-solid fa-cart-shopping"></i> Cart<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount %></span><% } %></a></li>
                    <li><a href="<%= contextPath %>/login.jsp" class="btn btn-secondary">Login</a></li>
                    <li><a href="<%= contextPath %>/register.jsp" class="btn btn-primary">Sign Up</a></li>
                <% } else if ("customer".equals(navUser.getRole())) { %>
                    <!-- Customer Links -->
                    <li><a href="<%= contextPath %>/restaurants" <%= isBrowse ? "class=\"active\"" : "" %>>Restaurants</a></li>
                    <li><a href="#" onclick="toggleDrawer(true); return false;" class="cart-link<%= isCart ? " active" : "" %>"><i class="fa-solid fa-cart-shopping"></i> Cart<% if (cartCount > 0) { %><span class="cart-badge"><%= cartCount %></span><% } %></a></li>
                    <li><a href="<%= contextPath %>/orders" <%= isOrders ? "class=\"active\"" : "" %>>Orders</a></li>
                    <li><a href="<%= contextPath %>/customer/profile.jsp" <%= isProfile ? "class=\"active\"" : "" %>>👤 <%= navUser.getUserName() %></a></li>
                    <li><a href="<%= contextPath %>/logout" class="btn btn-secondary">Logout</a></li>
                <% } else if ("admin".equals(navUser.getRole())) { %>
                    <!-- Admin Links -->
                    <li><a href="<%= contextPath %>/admin/admin-dashboard.jsp" <%= isAdminDashboard ? "class=\"active\"" : "" %>>Dashboard</a></li>
                    <li><a href="<%= contextPath %>/admin/manage-restaurants.jsp" <%= isAdminRestaurants ? "class=\"active\"" : "" %>>Restaurants</a></li>
                    <li><a href="<%= contextPath %>/admin/manage-orders.jsp" <%= isAdminOrders ? "class=\"active\"" : "" %>>Orders</a></li>
                    <li><a href="<%= contextPath %>/logout" class="btn btn-secondary">Logout</a></li>
                <% } else if ("delivery".equals(navUser.getRole())) { %>
                    <!-- Delivery Partner Links -->
                    <li><a href="<%= contextPath %>/delivery/delivery-dashboard.jsp" <%= isRiderPortal ? "class=\"active\"" : "" %>>Rider Portal</a></li>
                    <li><a href="<%= contextPath %>/logout" class="btn btn-secondary">Logout</a></li>
                <% } %>
                <li>
                    <div class="theme-switch-wrapper">
                        <label class="theme-switch" for="checkbox">
                            <input type="checkbox" id="checkbox" onclick="toggleTheme()" />
                            <div class="slider round">
                                <i class="fa-solid fa-moon icon-moon"></i>
                                <i class="fa-solid fa-sun icon-sun"></i>
                            </div>
                        </label>
                    </div>
                </li>
            </ul>
        </nav>
    </div>
</header>

<!-- Sliding Cart Drawer Container -->
<div id="cartDrawer" class="cart-drawer">
    <div class="drawer-header">
        <h3>Shopping Cart</h3>
        <button onclick="toggleDrawer(false)" class="close-drawer">&times;</button>
    </div>
    <div class="drawer-content">
        <% if (drawerCartList.isEmpty()) { %>
            <div class="empty-drawer">
                <i class="fa-solid fa-cart-shopping" style="font-size: 3rem; opacity: 0.2; color: var(--primary);"></i>
                <p>Your cart is empty</p>
                <a href="<%= contextPath %>/restaurants" class="btn btn-primary" style="font-size: 0.85rem; padding: 0.5rem 1rem;" onclick="toggleDrawer(false)">Browse Restaurants</a>
            </div>
        <% } else { %>
            <ul class="drawer-items">
                <% for (com.tap.controller.cart.CartServlet.CartItemDetail item : drawerCartList) { %>
                    <li class="drawer-item">
                        <div class="drawer-item-details">
                            <div class="drawer-item-name"><%= item.getMenu().getItemName() %></div>
                            <div class="drawer-item-meta">
                                <%= item.getCart().getQuantity() %> x Rs. <%= item.getMenu().getPrice() %>
                            </div>
                        </div>
                        <div class="drawer-item-price">Rs. <%= item.getSubtotal() %></div>
                    </li>
                <% } %>
            </ul>
            <div class="drawer-footer">
                <div class="drawer-total">
                    <span>Total Amount</span>
                    <span style="color: var(--primary); font-weight: 800;">Rs. <%= drawerGrandTotal %></span>
                </div>
                <a href="<%= contextPath %>/cart" class="btn btn-secondary" style="display: block; text-align: center; padding: 0.75rem; font-size: 0.9rem; margin-bottom: 0.5rem;" onclick="toggleDrawer(false)">
                    View Full Cart
                </a>
                <a href="<%= contextPath %>/checkout" class="btn btn-primary" style="display: block; text-align: center; padding: 0.8rem; font-size: 0.95rem;">
                    Proceed to Checkout <i class="fa-solid fa-arrow-right" style="margin-left: 0.3rem;"></i>
                </a>
            </div>
        <% } %>
    </div>
</div>
<div id="drawerOverlay" class="drawer-overlay" onclick="toggleDrawer(false)"></div>

<script>
    function toggleTheme() {
        const checkbox = document.getElementById('checkbox');
        const newTheme = checkbox.checked ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
    }

    function toggleDrawer(open) {
        const drawer = document.getElementById('cartDrawer');
        const overlay = document.getElementById('drawerOverlay');
        if (open) {
            drawer.classList.add('open');
            overlay.classList.add('open');
        } else {
            drawer.classList.remove('open');
            overlay.classList.remove('open');
        }
    }

    // Set initial checkbox state on load and check URL query parameter
    document.addEventListener("DOMContentLoaded", function() {
        const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
        const checkbox = document.getElementById('checkbox');
        if (checkbox) {
            checkbox.checked = (currentTheme === 'light');
        }
        
        // Auto-open drawer if requested in the redirect query param
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('cart') === 'open') {
            toggleDrawer(true);
        }
    });
</script>
