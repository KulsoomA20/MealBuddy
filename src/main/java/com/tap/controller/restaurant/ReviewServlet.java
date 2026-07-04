package com.tap.controller.restaurant;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.DAOimpl.ReviewDAOimpl;
import com.tap.model.Restaurant;
import com.tap.model.Review;
import com.tap.model.User;

@WebServlet("/add-review")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAOimpl reviewDAO;
    private RestaurantDAOimpl restaurantDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String restIdStr = request.getParameter("restId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        if (comment == null) {
            comment = "";
        }

        if (restIdStr != null && ratingStr != null) {
            try {
                int restId = Integer.parseInt(restIdStr);
                int rating = Integer.parseInt(ratingStr);

                // Create and insert review
                Review r = new Review(restId, loggedUser.getUserId(), loggedUser.getUserName(), rating, comment);
                reviewDAO.addReview(r);

                // Recalculate average rating of the restaurant
                double newAvgRating = reviewDAO.getAverageRating(restId);
                Restaurant rest = restaurantDAO.getRestaurant(restId);
                if (rest != null) {
                    // Update average rating
                    rest.setRating(newAvgRating);
                    restaurantDAO.updateRestaurant(rest);
                }

                response.sendRedirect("menu?restId=" + restId);
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("restaurants");
    }
}
