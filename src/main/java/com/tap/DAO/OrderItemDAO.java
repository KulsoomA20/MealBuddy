package com.tap.DAO;

import com.tap.model.OrderItem;

import java.util.List;

public interface OrderItemDAO {
	
	 void addOrderItem(OrderItem oi);
	 
	 List<OrderItem> getOrderItemsByOrder(int orderId);

}
