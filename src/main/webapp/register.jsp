<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String preselectedRole = request.getParameter("role");
    if (preselectedRole == null) preselectedRole = "customer";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- Register Form Wrapper -->
    <main class="form-wrapper" style="padding-top: 7rem;">
        <div class="auth-card glass-panel" style="max-width: 500px;">
            <div class="auth-header">
                <h2>Create Account</h2>
                <p>Join MealBuddy and explore culinary wonders</p>
            </div>

            <!-- Error Messages -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="alert alert-danger">
                    ⚠️ <%= errorMessage %>
                </div>
            <% } %>

            <form action="register" method="POST">
                <div class="form-group">
                    <label for="userName">Full Name</label>
                    <input type="text" id="userName" name="userName" class="form-control" placeholder="Enter your full name" required autocomplete="name">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="Enter 10-digit mobile number" required pattern="[0-9]{10}" autocomplete="tel">
                </div>

                <div class="form-group">
                    <label for="role">Register As</label>
                    <select id="role" name="role" class="form-control form-select" required>
                        <option value="customer" <%= "customer".equals(preselectedRole) ? "selected" : "" %>>Customer (Order Delicious Food)</option>
                        <option value="admin" <%= "admin".equals(preselectedRole) ? "selected" : "" %>>Restaurant Owner / Admin (Manage Restaurants)</option>
                        <option value="delivery" <%= "delivery".equals(preselectedRole) ? "selected" : "" %>>Delivery Partner (Deliver Delights)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required autocomplete="new-password">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.9rem;">
                    Create Account
                </button>
            </form>

            <div class="auth-footer">
                Already have an account? <a href="login.jsp">Sign In</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
