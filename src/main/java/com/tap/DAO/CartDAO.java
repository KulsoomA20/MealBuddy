package com.tap.DAO;

import com.tap.model.Cart;

import java.util.List;

public interface CartDAO {
	
	 void addToCart(Cart c);
	 
	 void updateCartQuantity(int cartId, int quantity);
	 
	 void removeFromCart(int cartId);
	 
	 List<Cart> getCartByUser(int userId);
	 
	 Cart getCartItem(int userId, int menuId);
	 
	 void clearCart(int userId);

}
