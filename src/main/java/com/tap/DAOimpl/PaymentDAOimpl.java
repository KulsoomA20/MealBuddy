package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.tap.DAO.PaymentDAO;
import com.tap.model.Payment;
import com.tap.util.DBConnection;

public class PaymentDAOimpl implements PaymentDAO {

	private static final String INSERT_QUERY = "INSERT INTO payment(orderId, amount, paymentStatus) VALUES(?,?,?)";
	private static final String UPDATE_STATUS_QUERY = "UPDATE payment SET paymentStatus=? WHERE paymentId=?";
	private static final String SELECT_BY_ORDER_QUERY = "SELECT * FROM payment WHERE orderId=?";

	@Override
	public void addPayment(Payment p) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, p.getOrderId());
			pstmt.setDouble(2, p.getAmount());
			pstmt.setString(3, p.getPaymentStatus());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updatePaymentStatus(int paymentId, String paymentStatus) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_STATUS_QUERY);
			pstmt.setString(1, paymentStatus);
			pstmt.setInt(2, paymentId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Payment getPaymentByOrder(int orderId) {
		Connection connection = DBConnection.getConnection();
		Payment p = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ORDER_QUERY);
			pstmt.setInt(1, orderId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				p = getPaymentByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return p;
	}

	private static Payment getPaymentByResultSet(ResultSet res) throws SQLException {
		int paymentId = res.getInt("paymentId");
		int orderId = res.getInt("orderId");
		double amount = res.getDouble("amount");
		String paymentStatus = res.getString("paymentStatus");
		Timestamp paymentDate = res.getTimestamp("paymentDate");

		return new Payment(paymentId, orderId, amount, paymentStatus, paymentDate);
	}
}
