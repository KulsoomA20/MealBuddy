<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- Login Form Wrapper -->
    <main class="form-wrapper">
        <div class="auth-card glass-panel">
            <div class="auth-header">
                <h2>Welcome Back</h2>
                <p>Login to start ordering gourmet delights</p>
            </div>

            <!-- Error/Success Messages -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successMessage = (String) request.getParameter("success");
                if (errorMessage != null) {
            %>
                <div class="alert alert-danger">
                    ⚠️ <%= errorMessage %>
                </div>
            <% } %>
            <% if (successMessage != null && "registered".equals(successMessage)) { %>
                <div class="alert alert-success">
                    ✅ Registration successful! Please log in.
                </div>
            <% } %>

            <form action="login" method="POST">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required autocomplete="current-password">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.9rem;">
                    Sign In
                </button>
            </form>

            <div class="auth-footer">
                Don't have an account? <a href="register.jsp">Create Account</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
