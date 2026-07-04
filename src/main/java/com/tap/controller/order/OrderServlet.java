package com.tap.controller.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.OrderTableDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.model.OrderTable;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderTableDAOimpl orderDAO;
    private RestaurantDAOimpl restaurantDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderTableDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
    }

    public static class OrderDetail {
        private OrderTable order;
        private Restaurant restaurant;

        public OrderDetail(OrderTable order, Restaurant restaurant) {
            this.order = order;
            this.restaurant = restaurant;
        }

        public OrderTable getOrder() { return order; }
        public Restaurant getRestaurant() { return restaurant; }
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

        String role = loggedUser.getRole();

        if ("customer".equals(role)) {
            // Fetch customer orders
            List<OrderTable> orders = orderDAO.getOrdersByUser(loggedUser.getUserId());
            List<OrderDetail> orderDetails = new ArrayList<>();
            
            for (OrderTable o : orders) {
                Restaurant r = restaurantDAO.getRestaurant(o.getRestId());
                orderDetails.add(new OrderDetail(o, r));
            }
            
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("customer/order-history.jsp").forward(request, response);
        } 
        else if ("admin".equals(role)) {
            // Forward to Admin orders dashboard
            response.sendRedirect("admin/manage-orders.jsp");
        } 
        else if ("delivery".equals(role)) {
            // Forward to Rider dashboard
            response.sendRedirect("delivery/delivery-dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
