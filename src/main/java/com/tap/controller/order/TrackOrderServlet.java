package com.tap.controller.order;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.OrderTableDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.DAOimpl.UserDAOimpl;
import com.tap.model.OrderTable;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/track-order")
public class TrackOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderTableDAOimpl orderDAO;
    private RestaurantDAOimpl restaurantDAO;
    private UserDAOimpl userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderTableDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
        userDAO = new UserDAOimpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect("orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderTable order = orderDAO.getOrder(orderId);
            
            if (order != null) {
                // Ensure this order belongs to the logged-in customer, or admin/rider
                if (order.getUserId() == loggedUser.getUserId() || "admin".equals(loggedUser.getRole()) || "delivery".equals(loggedUser.getRole())) {
                    Restaurant rest = restaurantDAO.getRestaurant(order.getRestId());
                    request.setAttribute("order", order);
                    request.setAttribute("restaurant", rest);
                    if (order.getDeliveryPartnerId() > 0) {
                        User rider = userDAO.getUser(order.getDeliveryPartnerId());
                        request.setAttribute("rider", rider);
                    }
                    request.getRequestDispatcher("customer/track-order.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("orders");
    }
}
