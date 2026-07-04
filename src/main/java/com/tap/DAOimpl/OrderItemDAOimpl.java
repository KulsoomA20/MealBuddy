package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDAOimpl implements OrderItemDAO {

	private static final String INSERT_QUERY = "INSERT INTO orderitem(orderId, menuId, quantity, price, itemTotal) VALUES(?,?,?,?,?)";
	private static final String SELECT_BY_ORDER_QUERY = "SELECT * FROM orderitem WHERE orderId=?";

	@Override
	public void addOrderItem(OrderItem oi) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, oi.getOrderId());
			pstmt.setInt(2, oi.getMenuId());
			pstmt.setInt(3, oi.getQuantity());
			pstmt.setDouble(4, oi.getPrice());
			pstmt.setDouble(5, oi.getItemTotal());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<OrderItem> getOrderItemsByOrder(int orderId) {
		Connection connection = DBConnection.getConnection();
		List<OrderItem> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ORDER_QUERY);
			pstmt.setInt(1, orderId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getOrderItemByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private static OrderItem getOrderItemByResultSet(ResultSet res) throws SQLException {
		int orderItemId = res.getInt("orderItemId");
		int orderId = res.getInt("orderId");
		int menuId = res.getInt("menuId");
		int quantity = res.getInt("quantity");
		double price = res.getDouble("price");
		double itemTotal = res.getDouble("itemTotal");

		return new OrderItem(orderItemId, orderId, menuId, quantity, price, itemTotal);
	}
}
