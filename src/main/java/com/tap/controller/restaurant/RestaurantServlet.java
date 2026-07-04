package com.tap.controller.restaurant;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.model.Restaurant;

@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAOimpl restaurantDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOimpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Fetch only active restaurants from the DB
        List<Restaurant> activeRestaurants = restaurantDAO.getActiveRestaurants();
        
        // Pass the list to the JSP
        request.setAttribute("restaurantList", activeRestaurants);
        
        // Forward the request to the customer home/browse page
        request.getRequestDispatcher("customer/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
