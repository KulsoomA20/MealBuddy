<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-section brand-info">
            <div class="footer-logo">MealBuddy</div>
            <p>Delivering happiness and gourmet meals to your doorstep 24/7. Fresh food, lightning fast delivery, and premium local culinary experiences.</p>
        </div>
        <div class="footer-section">
            <h4>For Restaurants</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/register.jsp?role=admin" target="_blank">Partner With Us</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/admin-dashboard.jsp">Merchant Dashboard</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h4>For Riders</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/register.jsp?role=delivery" target="_blank">Deliver With Us</a></li>
                <li><a href="${pageContext.request.contextPath}/delivery/delivery-dashboard.jsp">Rider Portal</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h4>Company</h4>
            <ul>
                <li><a href="#">About Us</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Terms of Service</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; <%= java.time.Year.now().getValue() %> MealBuddy Inc. All rights reserved.</p>
    </div>
</footer>
