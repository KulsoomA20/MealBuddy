package com.tap.DAO;

import com.tap.model.OrderTable;

import java.util.List;

public interface OrderTableDAO {
	
	 int placeOrder(OrderTable o);
	 
	 void updateOrderStatus(int orderId, String status);
	 
	 void assignDeliveryPartner(int orderId, int deliveryPartnerId);
	 
	 OrderTable getOrder(int orderId);
	 
	 List<OrderTable> getOrdersByUser(int userId);
	 
	 List<OrderTable> getOrdersByRestaurant(int restId);
	 
	 List<OrderTable> getOrdersByDeliveryPartner(int deliveryPartnerId);
	 
	 List<OrderTable> getAllOrders();

}
