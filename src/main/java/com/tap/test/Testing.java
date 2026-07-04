package com.tap.test;

import java.sql.Timestamp;
import java.util.List;

import com.tap.DAOimpl.AddressDAOimpl;
import com.tap.DAOimpl.CartDAOimpl;
import com.tap.DAOimpl.MenuDAOimpl;
import com.tap.DAOimpl.OrderItemDAOimpl;
import com.tap.DAOimpl.OrderTableDAOimpl;
import com.tap.DAOimpl.PaymentDAOimpl;
import com.tap.DAOimpl.RestaurantDAOimpl;
import com.tap.DAOimpl.UserDAOimpl;
import com.tap.model.Address;
import com.tap.model.Cart;
import com.tap.model.Menu;
import com.tap.model.OrderItem;
import com.tap.model.OrderTable;
import com.tap.model.Payment;
import com.tap.model.Restaurant;
import com.tap.model.User;

public class Testing {

	public static void main(String[] args) {
		System.out.println("=== Starting Food Delivery App Database Test ===");

		// 1. Initialize DAO Implementations
		UserDAOimpl userDAO = new UserDAOimpl();
		AddressDAOimpl addressDAO = new AddressDAOimpl();
		RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
		MenuDAOimpl menuDAO = new MenuDAOimpl();
		CartDAOimpl cartDAO = new CartDAOimpl();
		OrderTableDAOimpl orderDAO = new OrderTableDAOimpl();
		OrderItemDAOimpl orderItemDAO = new OrderItemDAOimpl();
		PaymentDAOimpl paymentDAO = new PaymentDAOimpl();

		try {
			// 2. Test User Creation (Customer, Admin, Delivery)
			System.out.println("\n1. Creating Users...");
			User customer = new User("John Doe", "password123", "john@example.com", "9876543210", "customer");
			User admin = new User("Owner Alice", "admin123", "alice@restaurant.com", "9876543211", "admin");
			User delivery = new User("Rider Bob", "rider123", "bob@delivery.com", "9876543212", "delivery");

			userDAO.addUser(customer);
			userDAO.addUser(admin);
			userDAO.addUser(delivery);

			// Fetch users back to get their generated IDs
			User dbCustomer = userDAO.getUserByEmail("john@example.com");
			User dbAdmin = userDAO.getUserByEmail("alice@restaurant.com");
			User dbDelivery = userDAO.getUserByEmail("bob@delivery.com");

			System.out.println("Customer Created: " + dbCustomer);
			System.out.println("Admin Created: " + dbAdmin);
			System.out.println("Delivery Partner Created: " + dbDelivery);

			// 3. Test Address Creation
			System.out.println("\n2. Creating Address for Customer...");
			Address address = new Address(dbCustomer.getUserId(), "Home", "123 Main St, Apartment 4B", "Bengaluru", "Karnataka", "560001", true);
			addressDAO.addAddress(address);
			
			List<Address> customerAddresses = addressDAO.getAddressesByUser(dbCustomer.getUserId());
			Address dbAddress = customerAddresses.isEmpty() ? null : customerAddresses.get(0);
			System.out.println("Address Saved: " + dbAddress);

			// 4. Test Restaurant Creation
			System.out.println("\n3. Creating Restaurant...");
			Restaurant restaurant = new Restaurant("Pizza Paradise", "Italian", 30, "456 Food Street, BTM Layout", 4.5, true, "pizza_paradise.jpg", dbAdmin.getUserId());
			restaurantDAO.addRestaurant(restaurant);
			
			List<Restaurant> activeRest = restaurantDAO.getActiveRestaurants();
			Restaurant dbRestaurant = activeRest.isEmpty() ? null : activeRest.get(0);
			System.out.println("Restaurant Saved: " + dbRestaurant);

			// 5. Test Menu Item Creation
			System.out.println("\n4. Creating Menu Items...");
			Menu pizza = new Menu(dbRestaurant.getRestId(), "Margherita Pizza", "Classic cheese and tomato pizza", 299.00, "Main Course", true, "margherita.jpg", false);
			Menu coke = new Menu(dbRestaurant.getRestId(), "Diet Coke", "Chilled soft drink", 45.00, "Beverages", true, "coke.jpg", false);
			menuDAO.addMenuItem(pizza);
			menuDAO.addMenuItem(coke);

			List<Menu> dbMenu = menuDAO.getMenuByRestaurant(dbRestaurant.getRestId());
			System.out.println("Menu Items Saved (Count: " + dbMenu.size() + "):");
			for (Menu item : dbMenu) {
				System.out.println(" - " + item.getItemName() + " (Rs. " + item.getPrice() + ")");
			}

			// 6. Test Cart persistent operations
			System.out.println("\n5. Adding items to Cart...");
			Menu dbPizza = dbMenu.get(0);
			Cart cartItem = new Cart(dbCustomer.getUserId(), dbPizza.getMenuId(), 2); // 2 Margherita Pizzas
			cartDAO.addToCart(cartItem);

			List<Cart> dbCart = cartDAO.getCartByUser(dbCustomer.getUserId());
			System.out.println("Cart Items in DB: " + dbCart);

			// 7. Test placing Order
			System.out.println("\n6. Placing Order...");
			double totalAmount = dbPizza.getPrice() * 2; // Rs. 598.00
			OrderTable order = new OrderTable(dbCustomer.getUserId(), dbRestaurant.getRestId(), dbAddress.getAddressId(), totalAmount, "Online");
			
			int orderId = orderDAO.placeOrder(order);
			System.out.println("Order Placed Successfully! Generated Order ID: " + orderId);

			// 8. Test Order Items insertion
			System.out.println("\n7. Adding Order Items...");
			OrderItem orderItem = new OrderItem(orderId, dbPizza.getMenuId(), 2, dbPizza.getPrice(), totalAmount);
			orderItemDAO.addOrderItem(orderItem);

			List<OrderItem> dbOrderItems = orderItemDAO.getOrderItemsByOrder(orderId);
			System.out.println("Order Items Stored: " + dbOrderItems);

			// 9. Test Payment creation
			System.out.println("\n8. Recording Payment...");
			Payment payment = new Payment(orderId, totalAmount, "Success");
			paymentDAO.addPayment(payment);

			Payment dbPayment = paymentDAO.getPaymentByOrder(orderId);
			System.out.println("Payment Record: " + dbPayment);

			// 10. Update Order Status and assign Delivery Partner
			System.out.println("\n9. Assigning Driver and Updating Status...");
			orderDAO.assignDeliveryPartner(orderId, dbDelivery.getUserId());
			orderDAO.updateOrderStatus(orderId, "Preparing");

			OrderTable updatedOrder = orderDAO.getOrder(orderId);
			System.out.println("Final Updated Order State: " + updatedOrder);

			// 11. Clear Cart
			System.out.println("\n10. Clearing Cart after successful order...");
			cartDAO.clearCart(dbCustomer.getUserId());
			System.out.println("Cart size in DB now: " + cartDAO.getCartByUser(dbCustomer.getUserId()).size());

			System.out.println("\n=== Database Test Completed Successfully ===");

		} catch (Exception e) {
			System.err.println("Test Failed due to Exception!");
			e.printStackTrace();
		}
	}
}
