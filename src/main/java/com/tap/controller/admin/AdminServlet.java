package com.tap.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.MenuDAOimpl;
import com.tap.DAOimpl.OrderTableDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/admin-control")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAOimpl restaurantDAO;
    private MenuDAOimpl menuDAO;
    private OrderTableDAOimpl orderDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOimpl();
        menuDAO = new MenuDAOimpl();
        orderDAO = new OrderTableDAOimpl();
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

        String role = loggedUser.getRole();
        String action = request.getParameter("action");

        // Action-based authorization check
        if ("updateOrderStatus".equals(action)) {
            if (!"admin".equals(role) && !"delivery".equals(role)) {
                response.sendRedirect("login.jsp");
                return;
            }
        } else {
            // All other administrative tasks require admin role
            if (!"admin".equals(role)) {
                response.sendRedirect("login.jsp");
                return;
            }
        }

        if (action != null) {
            try {
                if ("addRestaurant".equals(action)) {
                    String restName = request.getParameter("restName");
                    String cuisineType = request.getParameter("cuisineType");
                    int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                    String address = request.getParameter("address");
                    boolean isActive = request.getParameter("isActive") != null;
                    String imagePath = request.getParameter("imagePath");
                    String restType = request.getParameter("restType");
                    if (restType == null) restType = "Both";

                    Restaurant r = new Restaurant(restName, cuisineType, deliveryTime, address, 0.0, isActive, imagePath, loggedUser.getUserId(), restType);
                    restaurantDAO.addRestaurant(r);
                    response.sendRedirect("admin/manage-restaurants.jsp");
                    return;
                } 
                else if ("updateRestaurant".equals(action)) {
                    int restId = Integer.parseInt(request.getParameter("restId"));
                    String restName = request.getParameter("restName");
                    String cuisineType = request.getParameter("cuisineType");
                    int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                    String address = request.getParameter("address");
                    boolean isActive = request.getParameter("isActive") != null;
                    String imagePath = request.getParameter("imagePath");

                    Restaurant r = restaurantDAO.getRestaurant(restId);
                    if (r != null) {
                        r.setRestName(restName);
                        r.setCuisineType(cuisineType);
                        r.setDeliveryTime(deliveryTime);
                        r.setAddress(address);
                        r.setActive(isActive);
                        r.setImagePath(imagePath);
                        String restType = request.getParameter("restType");
                        if (restType != null) {
                            r.setRestType(restType);
                        }
                        restaurantDAO.updateRestaurant(r);
                    }
                    response.sendRedirect("admin/manage-restaurants.jsp");
                    return;
                }
                else if ("toggleRestaurantStatus".equals(action)) {
                    int restId = Integer.parseInt(request.getParameter("restId"));
                    Restaurant r = restaurantDAO.getRestaurant(restId);
                    if (r != null) {
                        r.setActive(!r.isActive());
                        restaurantDAO.updateRestaurant(r);
                    }
                    response.sendRedirect("admin/manage-restaurants.jsp");
                    return;
                }
                else if ("addMenuItem".equals(action)) {
                    int restId = Integer.parseInt(request.getParameter("restId"));
                    String itemName = request.getParameter("itemName");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    String category = request.getParameter("category");
                    boolean isAvailable = request.getParameter("isAvailable") != null;
                    String imagePath = request.getParameter("imagePath");
                    boolean isVeg = request.getParameter("isVeg") != null;

                    Menu m = new Menu(restId, itemName, description, price, category, isAvailable, imagePath, isVeg);
                    menuDAO.addMenuItem(m);
                    response.sendRedirect("admin/manage-menu.jsp?restId=" + restId);
                    return;
                }
                else if ("updateMenuItem".equals(action)) {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int restId = Integer.parseInt(request.getParameter("restId"));
                    String itemName = request.getParameter("itemName");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    String category = request.getParameter("category");
                    boolean isAvailable = request.getParameter("isAvailable") != null;
                    String imagePath = request.getParameter("imagePath");
                    boolean isVeg = request.getParameter("isVeg") != null;

                    Menu m = menuDAO.getMenuItem(menuId);
                    if (m != null) {
                        m.setItemName(itemName);
                        m.setDescription(description);
                        m.setPrice(price);
                        m.setCategory(category);
                        m.setAvailable(isAvailable);
                        m.setImagePath(imagePath);
                        m.setVeg(isVeg);
                        menuDAO.updateMenuItem(m);
                    }
                    response.sendRedirect("admin/manage-menu.jsp?restId=" + restId);
                    return;
                }
                else if ("toggleMenuItemStatus".equals(action)) {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int restId = Integer.parseInt(request.getParameter("restId"));
                    Menu m = menuDAO.getMenuItem(menuId);
                    if (m != null) {
                        m.setAvailable(!m.isAvailable());
                        menuDAO.updateMenuItem(m);
                    }
                    response.sendRedirect("admin/manage-menu.jsp?restId=" + restId);
                    return;
                }
                else if ("updateOrderStatus".equals(action)) {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    
                    orderDAO.updateOrderStatus(orderId, status);

                    if ("delivery".equals(role)) {
                        response.sendRedirect("delivery/delivery-dashboard.jsp");
                    } else {
                        response.sendRedirect("admin/manage-orders.jsp");
                    }
                    return;
                }
                else if ("assignRider".equals(action)) {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    int riderId = Integer.parseInt(request.getParameter("riderId"));

                    orderDAO.assignDeliveryPartner(orderId, riderId);
                    orderDAO.updateOrderStatus(orderId, "Confirmed");
                    response.sendRedirect("admin/manage-orders.jsp");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if ("delivery".equals(role)) {
            response.sendRedirect("delivery/delivery-dashboard.jsp");
        } else {
            response.sendRedirect("admin/admin-dashboard.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (loggedUser != null && "delivery".equals(loggedUser.getRole())) {
            response.sendRedirect("delivery/delivery-dashboard.jsp");
        } else {
            response.sendRedirect("admin/admin-dashboard.jsp");
        }
    }
}
