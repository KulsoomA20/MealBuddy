package com.tap.controller.user;

import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.UserDAOimpl;
import com.tap.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAOimpl userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOimpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Fetch user from DB
        User user = userDAO.getUserByEmail(email);

        if (user != null && com.tap.util.PasswordHasher.check(password, user.getPassword())) {
            // Password matches, create session
            HttpSession session = request.getSession();
            
            // Auto-upgrade plain-text password to BCrypt
            String dbPassword = user.getPassword();
            if (dbPassword != null && !dbPassword.startsWith("$2a$") && !dbPassword.startsWith("$2y$") && !dbPassword.startsWith("$2b$")) {
                user.setPassword(password); // Will be automatically hashed inside updateUser
            }
            
            // Update last login date
            user.setLastLoginDate(new Timestamp(System.currentTimeMillis()));
            userDAO.updateUser(user);
            
            session.setAttribute("loggedUser", user);

            // Redirect based on role
            String role = user.getRole();
            if ("customer".equals(role)) {
                @SuppressWarnings("unchecked")
                java.util.List<com.tap.model.Cart> sessionCart = 
                    (java.util.List<com.tap.model.Cart>) session.getAttribute("sessionCart");
                if (sessionCart != null && !sessionCart.isEmpty()) {
                    com.tap.DAOimpl.CartDAOimpl cartDAO = new com.tap.DAOimpl.CartDAOimpl();
                    cartDAO.clearCart(user.getUserId());
                    for (com.tap.model.Cart item : sessionCart) {
                        item.setUserId(user.getUserId());
                        cartDAO.addToCart(item);
                    }
                    session.removeAttribute("sessionCart");
                    response.sendRedirect("cart");
                } else {
                    response.sendRedirect("restaurants");
                }
            } else if ("admin".equals(role)) {
                response.sendRedirect("admin/admin-dashboard.jsp");
            } else if ("delivery".equals(role)) {
                response.sendRedirect("delivery/delivery-dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // Invalid credentials
            request.setAttribute("errorMessage", "Invalid email or password.");
            String loginType = request.getParameter("loginType");
            if ("admin".equals(loginType)) {
                request.getRequestDispatcher("admin/login.jsp").forward(request, response);
            } else if ("delivery".equals(loginType)) {
                request.getRequestDispatcher("delivery/login.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}
