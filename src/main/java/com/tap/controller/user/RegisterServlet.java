package com.tap.controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.UserDAOimpl;
import com.tap.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAOimpl userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOimpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userName = request.getParameter("userName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        // Validate if user already exists
        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser != null) {
            request.setAttribute("errorMessage", "Email is already registered. Please log in.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            // Create new User instance
            User newUser = new User(userName, password, email, phone, role);
            
            // Insert user into DB
            userDAO.addUser(newUser);
            
            // Redirect to login page with a success message query param
            response.sendRedirect("login.jsp?success=registered");
        }
    }
}
