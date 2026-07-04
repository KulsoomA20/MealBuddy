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

import com.tap.DAOimpl.AddressDAOimpl;
import com.tap.DAOimpl.CartDAOimpl;
import com.tap.DAOimpl.MenuDAOimpl;
import com.tap.DAOimpl.OrderItemDAOimpl;
import com.tap.DAOimpl.OrderTableDAOimpl;
import com.tap.DAOimpl.PaymentDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.model.Address;
import com.tap.model.Cart;
import com.tap.model.Menu;
import com.tap.model.OrderItem;
import com.tap.model.OrderTable;
import com.tap.model.Payment;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAOimpl cartDAO;
    private MenuDAOimpl menuDAO;
    private AddressDAOimpl addressDAO;
    private OrderTableDAOimpl orderDAO;
    private OrderItemDAOimpl orderItemDAO;
    private PaymentDAOimpl paymentDAO;
    private RestaurantDAOimpl restaurantDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAOimpl();
        menuDAO = new MenuDAOimpl();
        addressDAO = new AddressDAOimpl();
        orderDAO = new OrderTableDAOimpl();
        orderItemDAO = new OrderItemDAOimpl();
        paymentDAO = new PaymentDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
    }

    // Reuse the helper wrapper from CartServlet or define locally
    public static class CheckoutItem {
        private Cart cart;
        private Menu menu;
        private Restaurant restaurant;

        public CheckoutItem(Cart cart, Menu menu, Restaurant restaurant) {
            this.cart = cart;
            this.menu = menu;
            this.restaurant = restaurant;
        }

        public Cart getCart() { return cart; }
        public Menu getMenu() { return menu; }
        public Restaurant getRestaurant() { return restaurant; }
        public double getSubtotal() { return cart.getQuantity() * menu.getPrice(); }
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

        // Fetch cart details
        List<Cart> cartList = cartDAO.getCartByUser(loggedUser.getUserId());
        if (cartList.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        List<CheckoutItem> checkoutItems = new ArrayList<>();
        double totalAmount = 0;

        for (Cart c : cartList) {
            Menu m = menuDAO.getMenuItem(c.getMenuId());
            if (m != null) {
                Restaurant r = restaurantDAO.getRestaurant(m.getRestId());
                CheckoutItem item = new CheckoutItem(c, m, r);
                checkoutItems.add(item);
                totalAmount += item.getSubtotal();
            }
        }

        // Fetch user addresses
        List<Address> addressList = addressDAO.getAddressesByUser(loggedUser.getUserId());

        request.setAttribute("checkoutItems", checkoutItems);
        request.setAttribute("addressList", addressList);
        request.setAttribute("totalAmount", totalAmount);

        request.getRequestDispatcher("customer/checkout.jsp").forward(request, response);
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

        String addressIdStr = request.getParameter("addressId");
        String paymentMethod = request.getParameter("paymentMethod");

        if (addressIdStr == null || paymentMethod == null) {
            response.sendRedirect("checkout?error=missing_details");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);

        // Fetch user's cart
        List<Cart> cartList = cartDAO.getCartByUser(loggedUser.getUserId());
        if (cartList.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        // Load Address to calculate location-based delivery fee
        Address addr = addressDAO.getAddress(addressId);

        // Group cart items by restaurant
        java.util.Map<Integer, List<CheckoutItem>> restItemsMap = new java.util.HashMap<>();
        for (Cart c : cartList) {
            Menu m = menuDAO.getMenuItem(c.getMenuId());
            if (m != null) {
                Restaurant r = restaurantDAO.getRestaurant(m.getRestId());
                CheckoutItem item = new CheckoutItem(c, m, r);
                restItemsMap.computeIfAbsent(m.getRestId(), k -> new ArrayList<>()).add(item);
            }
        }

        List<Integer> orderIds = new ArrayList<>();
        boolean allSucceeded = true;
        double totalTransactionAmount = 0;

        for (java.util.Map.Entry<Integer, List<CheckoutItem>> entry : restItemsMap.entrySet()) {
            int restId = entry.getKey();
            List<CheckoutItem> items = entry.getValue();

            // Calculate subtotal for this restaurant's items
            double subtotal = 0;
            for (CheckoutItem item : items) {
                subtotal += item.getSubtotal();
            }

            // Calculate delivery fee for this restaurant's order
            double deliveryFee = 0.0;
            if (subtotal < 699.0) {
                Restaurant rest = restaurantDAO.getRestaurant(restId);
                int deliveryTime = (rest != null) ? rest.getDeliveryTime() : 30;
                
                if (deliveryTime <= 15) {
                    deliveryFee = 0.0;
                } else if (deliveryTime <= 25) {
                    deliveryFee = 40.0;
                } else {
                    deliveryFee = 50.0;
                }
            }

            double totalAmountForRest = subtotal + deliveryFee;
            totalTransactionAmount += totalAmountForRest;

            // 1. Create and Save Order
            OrderTable order = new OrderTable(loggedUser.getUserId(), restId, addressId, totalAmountForRest, paymentMethod);
            int orderId = orderDAO.placeOrder(order);

            if (orderId > 0) {
                orderIds.add(orderId);
                // 2. Save Order Items
                for (CheckoutItem item : items) {
                    OrderItem orderItem = new OrderItem(
                        orderId,
                        item.getCart().getMenuId(),
                        item.getCart().getQuantity(),
                        item.getMenu().getPrice(),
                        item.getSubtotal()
                    );
                    orderItemDAO.addOrderItem(orderItem);
                }

                // 3. Record Payment (Initially Pending for all)
                Payment payment = new Payment(orderId, totalAmountForRest, "Pending");
                paymentDAO.addPayment(payment);
            } else {
                allSucceeded = false;
            }
        }

        if (allSucceeded && !orderIds.isEmpty()) {
            // 4. Clear Customer Cart
            cartDAO.clearCart(loggedUser.getUserId());

            // Build comma-separated order IDs
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < orderIds.size(); i++) {
                sb.append(orderIds.get(i));
                if (i < orderIds.size() - 1) {
                    sb.append(", ");
                }
            }
            
            if ("Online".equals(paymentMethod)) {
                response.sendRedirect("payment-gateway?orderIds=" + sb.toString() + "&amount=" + totalTransactionAmount);
            } else {
                response.sendRedirect("customer/order-success.jsp?orderId=" + sb.toString());
            }
        } else {
            response.sendRedirect("checkout?error=order_failed");
        }
    }
}
