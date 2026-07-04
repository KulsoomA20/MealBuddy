<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Partner Sign In - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Simple Rider Header -->
    <header class="navbar" style="position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; display: flex; align-items: center; justify-content: space-between; padding: 1.2rem 5%; background: var(--bg-header); border-bottom: 1px solid var(--border-color); box-sizing: border-box;">
        <div class="logo" style="display: flex; align-items: center; gap: 0.5rem;">
            <img src="${pageContext.request.contextPath}/images/logo1.png" alt="MealBuddy Logo" style="height: 35px; width: auto; object-fit: contain;">
            <span style="font-size:0.8rem; background:rgba(16,185,129,0.15); color:var(--accent); padding:0.2rem 0.6rem; border-radius:4px; margin-left:0.5rem; text-transform:uppercase; font-weight:700;">Rider</span>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp" style="font-size: 0.9rem; color: var(--text-muted);"><i class="fa-solid fa-arrow-left"></i> Customer Site</a>
        </div>
    </header>

    <!-- Login Form Wrapper -->
    <main class="form-wrapper">
        <div class="auth-card glass-panel" style="max-width: 480px;">
            <div class="auth-header">
                <h2>Rider Partner Portal</h2>
                <p>Sign in to view assigned deliveries and accept delivery tasks</p>
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

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <input type="hidden" name="loginType" value="delivery">
                
                <div class="form-group">
                    <label for="email">Rider Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="rider@delivery.com" required autocomplete="email">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required autocomplete="current-password">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.9rem; background: var(--accent); border-color: var(--accent);">
                    Rider Sign In
                </button>
            </form>

            <div class="auth-footer">
                Want to deliver with us? <a href="${pageContext.request.contextPath}/register.jsp?role=delivery">Join as Rider</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
