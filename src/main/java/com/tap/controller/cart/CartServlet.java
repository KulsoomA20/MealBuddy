package com.tap.controller.cart;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.CartDAOimpl;
import com.tap.DAOimpl.MenuDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.model.Cart;
import com.tap.model.Menu;
import com.tap.model.Restaurant;
import com.tap.model.User;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAOimpl cartDAO;
    private MenuDAOimpl menuDAO;
    private RestaurantDAOimpl restaurantDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAOimpl();
        menuDAO = new MenuDAOimpl();
        restaurantDAO = new RestaurantDAOimpl();
    }

    // A helper wrapper class to pass both Cart and Menu details to the JSP
    public static class CartItemDetail {
        private Cart cart;
        private Menu menu;

        public CartItemDetail(Cart cart, Menu menu) {
            this.cart = cart;
            this.menu = menu;
        }

        public Cart getCart() { return cart; }
        public Menu getMenu() { return menu; }
        public double getSubtotal() { return cart.getQuantity() * menu.getPrice(); }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        User loggedUser = (User) session.getAttribute("loggedUser");

        List<CartItemDetail> cartDetails = new ArrayList<>();
        double grandTotal = 0;

        if (loggedUser != null) {
            // Fetch user's cart from database
            List<Cart> cartList = cartDAO.getCartByUser(loggedUser.getUserId());
            for (Cart c : cartList) {
                Menu m = menuDAO.getMenuItem(c.getMenuId());
                if (m != null) {
                    CartItemDetail detail = new CartItemDetail(c, m);
                    cartDetails.add(detail);
                    grandTotal += detail.getSubtotal();
                }
            }
        } else {
            // Fetch cart from session
            @SuppressWarnings("unchecked")
            List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
            if (sessionCart == null) {
                sessionCart = new ArrayList<>();
            }
            for (Cart c : sessionCart) {
                Menu m = menuDAO.getMenuItem(c.getMenuId());
                if (m != null) {
                    // Set cartId to menuId so it's a unique non-zero identifier for guest items in cart.jsp
                    c.setCartId(c.getMenuId());
                    CartItemDetail detail = new CartItemDetail(c, m);
                    cartDetails.add(detail);
                    grandTotal += detail.getSubtotal();
                }
            }
        }

        // Calculate delivery fee based on restaurant's delivery time
        double deliveryFee = 0.0;
        if (!cartDetails.isEmpty() && grandTotal < 699.0) {
            Menu firstMenu = cartDetails.get(0).getMenu();
            Restaurant rest = restaurantDAO.getRestaurant(firstMenu.getRestId());
            int deliveryTime = (rest != null) ? rest.getDeliveryTime() : 30;
            if (deliveryTime <= 15) {
                deliveryFee = 0.0;
            } else if (deliveryTime <= 25) {
                deliveryFee = 40.0;
            } else {
                deliveryFee = 50.0;
            }
        }

        request.setAttribute("cartDetails", cartDetails);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("deliveryFee", deliveryFee);
        
        request.getRequestDispatcher("customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        User loggedUser = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if (action != null) {
            try {
                if ("add".equals(action)) {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    Menu newMenuItem = menuDAO.getMenuItem(menuId);
                    if (newMenuItem != null) {
                        int newRestId = newMenuItem.getRestId();

                        if (loggedUser != null) {
                            // Check if existing database cart has items from a different restaurant
                            List<Cart> existingCart = cartDAO.getCartByUser(loggedUser.getUserId());
                            if (!existingCart.isEmpty()) {
                                Menu firstMenu = menuDAO.getMenuItem(existingCart.get(0).getMenuId());
                                if (firstMenu != null && firstMenu.getRestId() != newRestId) {
                                    cartDAO.clearCart(loggedUser.getUserId());
                                }
                            }

                            // Add or update quantity in DB
                            Cart existingItem = cartDAO.getCartItem(loggedUser.getUserId(), menuId);
                            if (existingItem != null) {
                                int newQty = existingItem.getQuantity() + quantity;
                                if (newQty <= 0) {
                                    cartDAO.removeFromCart(existingItem.getCartId());
                                } else {
                                    cartDAO.updateCartQuantity(existingItem.getCartId(), newQty);
                                }
                            } else if (quantity > 0) {
                                Cart newCart = new Cart(loggedUser.getUserId(), menuId, quantity);
                                cartDAO.addToCart(newCart);
                            }
                        } else {
                            // Session-based cart
                            @SuppressWarnings("unchecked")
                            List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
                            if (sessionCart == null) {
                                sessionCart = new ArrayList<>();
                            }

                            // Check if existing session cart has items from a different restaurant
                            if (!sessionCart.isEmpty()) {
                                Menu firstMenu = menuDAO.getMenuItem(sessionCart.get(0).getMenuId());
                                if (firstMenu != null && firstMenu.getRestId() != newRestId) {
                                    sessionCart.clear();
                                }
                            }

                            // Add or update quantity in session list
                            boolean found = false;
                            for (int i = 0; i < sessionCart.size(); i++) {
                                Cart c = sessionCart.get(i);
                                if (c.getMenuId() == menuId) {
                                    int newQty = c.getQuantity() + quantity;
                                    if (newQty <= 0) {
                                        sessionCart.remove(i);
                                    } else {
                                        c.setQuantity(newQty);
                                    }
                                    found = true;
                                    break;
                                }
                            }
                            if (!found && quantity > 0) {
                                Cart newCart = new Cart(0, menuId, quantity);
                                sessionCart.add(newCart);
                            }
                            session.setAttribute("sessionCart", sessionCart);
                        }
                    }
                } 
                else if ("update".equals(action)) {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    if (loggedUser != null) {
                        if (quantity <= 0) {
                            cartDAO.removeFromCart(cartId);
                        } else {
                            cartDAO.updateCartQuantity(cartId, quantity);
                        }
                    } else {
                        // For guest, cartId passed is the menuId
                        @SuppressWarnings("unchecked")
                        List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
                        if (sessionCart != null) {
                            for (int i = 0; i < sessionCart.size(); i++) {
                                Cart c = sessionCart.get(i);
                                if (c.getMenuId() == cartId) {
                                    if (quantity <= 0) {
                                        sessionCart.remove(i);
                                    } else {
                                        c.setQuantity(quantity);
                                    }
                                    break;
                                }
                            }
                            session.setAttribute("sessionCart", sessionCart);
                        }
                    }
                } 
                else if ("remove".equals(action)) {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    if (loggedUser != null) {
                        cartDAO.removeFromCart(cartId);
                    } else {
                        // For guest, cartId passed is the menuId
                        @SuppressWarnings("unchecked")
                        List<Cart> sessionCart = (List<Cart>) session.getAttribute("sessionCart");
                        if (sessionCart != null) {
                            for (int i = 0; i < sessionCart.size(); i++) {
                                if (sessionCart.get(i).getMenuId() == cartId) {
                                    sessionCart.remove(i);
                                    break;
                                }
                            }
                            session.setAttribute("sessionCart", sessionCart);
                        }
                    }
                } 
                else if ("clear".equals(action)) {
                    if (loggedUser != null) {
                        cartDAO.clearCart(loggedUser.getUserId());
                    } else {
                        session.removeAttribute("sessionCart");
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Redirect back to referring page (menu or cart)
        String redirectUrl = request.getParameter("redirectUrl");
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("cart");
        }
    }
}
