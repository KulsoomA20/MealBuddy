package com.tap.model;

import java.sql.Timestamp;

public class OrderTable {
	
	private int orderId;
	private int userId;
	private int restId;
	private int addressId;
	private int deliveryPartnerId;
	private Timestamp orderDate;
	private double totalAmount;
	private String status;
	private String paymentMethod;
	
	public OrderTable() {
		// TODO Auto-generated constructor stub
	}

	public OrderTable(int userId, int restId, int addressId, double totalAmount, String paymentMethod) {
		super();
		this.userId = userId;
		this.restId = restId;
		this.addressId = addressId;
		this.totalAmount = totalAmount;
		this.paymentMethod = paymentMethod;
	}

	public OrderTable(int orderId, int userId, int restId, int addressId, int deliveryPartnerId, Timestamp orderDate,
			double totalAmount, String status, String paymentMethod) {
		super();
		this.orderId = orderId;
		this.userId = userId;
		this.restId = restId;
		this.addressId = addressId;
		this.deliveryPartnerId = deliveryPartnerId;
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.status = status;
		this.paymentMethod = paymentMethod;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getRestId() {
		return restId;
	}

	public void setRestId(int restId) {
		this.restId = restId;
	}

	public int getAddressId() {
		return addressId;
	}

	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}

	public int getDeliveryPartnerId() {
		return deliveryPartnerId;
	}

	public void setDeliveryPartnerId(int deliveryPartnerId) {
		this.deliveryPartnerId = deliveryPartnerId;
	}

	public Timestamp getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Timestamp orderDate) {
		this.orderDate = orderDate;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	@Override
	public String toString() {
		return "OrderTable [orderId=" + orderId + ", userId=" + userId + ", restId=" + restId + ", addressId="
				+ addressId + ", deliveryPartnerId=" + deliveryPartnerId + ", orderDate=" + orderDate + ", totalAmount="
				+ totalAmount + ", status=" + status + ", paymentMethod=" + paymentMethod + "]";
	}
	
	
}
