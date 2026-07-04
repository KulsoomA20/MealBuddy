package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderTableDAO;
import com.tap.model.OrderTable;
import com.tap.util.DBConnection;

public class OrderTableDAOimpl implements OrderTableDAO {

	private static final String INSERT_QUERY = "INSERT INTO ordertable(userId, restId, addressId, totalAmount, paymentMethod) VALUES(?,?,?,?,?)";
	private static final String UPDATE_STATUS_QUERY = "UPDATE ordertable SET status=? WHERE orderId=?";
	private static final String ASSIGN_PARTNER_QUERY = "UPDATE ordertable SET deliveryPartnerId=? WHERE orderId=?";
	private static final String SELECT_QUERY = "SELECT * FROM ordertable WHERE orderId=?";
	private static final String SELECT_BY_USER_QUERY = "SELECT * FROM ordertable WHERE userId=? ORDER BY orderId DESC";
	private static final String SELECT_BY_REST_QUERY = "SELECT * FROM ordertable WHERE restId=?";
	private static final String SELECT_BY_PARTNER_QUERY = "SELECT * FROM ordertable WHERE deliveryPartnerId=?";
	private static final String SELECT_ALL_QUERY = "SELECT * FROM ordertable";

	@Override
	public int placeOrder(OrderTable o) {
		Connection connection = DBConnection.getConnection();
		int generatedOrderId = -1;
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY, Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, o.getUserId());
			pstmt.setInt(2, o.getRestId());
			
			if (o.getAddressId() > 0) {
				pstmt.setInt(3, o.getAddressId());
			} else {
				pstmt.setNull(3, java.sql.Types.INTEGER);
			}
			
			pstmt.setDouble(4, o.getTotalAmount());
			pstmt.setString(5, o.getPaymentMethod());

			pstmt.executeUpdate();
			ResultSet res = pstmt.getGeneratedKeys();
			if (res.next()) {
				generatedOrderId = res.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return generatedOrderId;
	}

	@Override
	public void updateOrderStatus(int orderId, String status) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_STATUS_QUERY);
			pstmt.setString(1, status);
			pstmt.setInt(2, orderId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void assignDeliveryPartner(int orderId, int deliveryPartnerId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(ASSIGN_PARTNER_QUERY);
			if (deliveryPartnerId > 0) {
				pstmt.setInt(1, deliveryPartnerId);
			} else {
				pstmt.setNull(1, java.sql.Types.INTEGER);
			}
			pstmt.setInt(2, orderId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public OrderTable getOrder(int orderId) {
		Connection connection = DBConnection.getConnection();
		OrderTable o = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			pstmt.setInt(1, orderId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				o = getOrderByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return o;
	}

	@Override
	public List<OrderTable> getOrdersByUser(int userId) {
		Connection connection = DBConnection.getConnection();
		List<OrderTable> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_USER_QUERY);
			pstmt.setInt(1, userId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getOrderByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<OrderTable> getOrdersByRestaurant(int restId) {
		Connection connection = DBConnection.getConnection();
		List<OrderTable> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_REST_QUERY);
			pstmt.setInt(1, restId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getOrderByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<OrderTable> getOrdersByDeliveryPartner(int deliveryPartnerId) {
		Connection connection = DBConnection.getConnection();
		List<OrderTable> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_PARTNER_QUERY);
			pstmt.setInt(1, deliveryPartnerId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getOrderByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<OrderTable> getAllOrders() {
		Connection connection = DBConnection.getConnection();
		List<OrderTable> list = new ArrayList<>();
		try {
			Statement stmt = connection.createStatement();
			ResultSet res = stmt.executeQuery(SELECT_ALL_QUERY);
			while (res.next()) {
				list.add(getOrderByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private static OrderTable getOrderByResultSet(ResultSet res) throws SQLException {
		int orderId = res.getInt("orderId");
		int userId = res.getInt("userId");
		int restId = res.getInt("restId");
		int addressId = res.getInt("addressId");
		int deliveryPartnerId = res.getInt("deliveryPartnerId");
		Timestamp orderDate = res.getTimestamp("orderDate");
		double totalAmount = res.getDouble("totalAmount");
		String status = res.getString("status");
		String paymentMethod = res.getString("paymentMethod");

		return new OrderTable(orderId, userId, restId, addressId, deliveryPartnerId, orderDate, totalAmount, status, paymentMethod);
	}
}
