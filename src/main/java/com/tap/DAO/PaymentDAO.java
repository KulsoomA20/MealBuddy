package com.tap.DAO;

import com.tap.model.Payment;

public interface PaymentDAO {
	
	 void addPayment(Payment p);
	 
	 void updatePaymentStatus(int paymentId, String paymentStatus);
	 
	 Payment getPaymentByOrder(int orderId);

}
