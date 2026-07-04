package com.tap.model;

import java.sql.Timestamp;

public class Payment {

	private int paymentId;
	private int orderId;
	private double amount;
	private String paymentStatus;
	private Timestamp paymentDate;
	
	public Payment() {
		// TODO Auto-generated constructor stub
	}

	public Payment(int orderId, double amount, String paymentStatus) {
		super();
		this.orderId = orderId;
		this.amount = amount;
		this.paymentStatus = paymentStatus;
	}

	public Payment(int paymentId, int orderId, double amount, String paymentStatus, Timestamp paymentDate) {
		super();
		this.paymentId = paymentId;
		this.orderId = orderId;
		this.amount = amount;
		this.paymentStatus = paymentStatus;
		this.paymentDate = paymentDate;
	}

	public int getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(int paymentId) {
		this.paymentId = paymentId;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public Timestamp getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Timestamp paymentDate) {
		this.paymentDate = paymentDate;
	}

	@Override
	public String toString() {
		return "Payment [paymentId=" + paymentId + ", orderId=" + orderId + ", amount=" + amount + ", paymentStatus="
				+ paymentStatus + ", paymentDate=" + paymentDate + "]";
	}
	
	
}
