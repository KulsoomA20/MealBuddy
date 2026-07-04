package com.tap.controller.menu;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.CartDAOimpl;
import com.tap.DAOimpl.MenuDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.DAOimpl.ReviewDAOimpl;
import com.tap.model.Cart;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.Review;
import com.tap.model.User;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAOimpl menuDAO;
    private RestaurantDAOimpl restaurantDAO;
    private CartDAOimpl cartDAO;

    @Override
    public void init() throws ServletException {
        menuDAO = new MenuDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
        cartDAO = new CartDAOimpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String restIdStr = request.getParameter("restId");
        
        if (restIdStr != null) {
            try {
                int restId = Integer.parseInt(restIdStr);
                
                // Fetch the restaurant details
                Restaurant restaurant = restaurantDAO.getRestaurant(restId);
                
                // Fetch only available menu items for this restaurant
                List<Menu> menuList = menuDAO.getAvailableMenuByRestaurant(restId);
                
                // Fetch reviews list
                ReviewDAOimpl reviewDAO = new ReviewDAOimpl();
                List<Review> reviewList = reviewDAO.getReviewsByRestaurant(restId);
                
                // Build cart quantity map for current user (logged-in or guest)
                java.util.Map<Integer, Integer> cartQtyMap = new java.util.HashMap<>();
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    User loggedUser = (User) session.getAttribute("loggedUser");
                    if (loggedUser != null) {
                        List<Cart> userCart = cartDAO.getCartByUser(loggedUser.getUserId());
                        if (userCart != null) {
                            for (Cart c : userCart) {
                                cartQtyMap.put(c.getMenuId(), c.getQuantity());
                            }
                        }
                    } else {
                        @SuppressWarnings("unchecked")
                        List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
                        if (sessionCart != null) {
                            for (Cart c : sessionCart) {
                                cartQtyMap.put(c.getMenuId(), c.getQuantity());
                            }
                        }
                    }
                }
                
                // Set attributes for the View
                request.setAttribute("restaurant", restaurant);
                request.setAttribute("menuList", menuList);
                request.setAttribute("reviewList", reviewList);
                request.setAttribute("cartQtyMap", cartQtyMap);
                
                // Forward to menu view
                request.getRequestDispatcher("customer/menu.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // Fallback to restaurants list if no valid ID provided
        response.sendRedirect("restaurants");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
