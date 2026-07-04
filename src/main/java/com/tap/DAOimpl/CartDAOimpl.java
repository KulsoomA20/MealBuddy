package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.CartDAO;
import com.tap.model.Cart;
import com.tap.util.DBConnection;

public class CartDAOimpl implements CartDAO {

	private static final String INSERT_QUERY = "INSERT INTO cart(userId, menuId, quantity, addedDate) VALUES(?,?,?,?)";
	private static final String UPDATE_QTY_QUERY = "UPDATE cart SET quantity=? WHERE cartId=?";
	private static final String DELETE_QUERY = "DELETE FROM cart WHERE cartId=?";
	private static final String SELECT_BY_USER_QUERY = "SELECT * FROM cart WHERE userId=?";
	private static final String SELECT_ITEM_QUERY = "SELECT * FROM cart WHERE userId=? AND menuId=?";
	private static final String CLEAR_QUERY = "DELETE FROM cart WHERE userId=?";

	@Override
	public void addToCart(Cart c) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, c.getUserId());
			pstmt.setInt(2, c.getMenuId());
			pstmt.setInt(3, c.getQuantity());
			pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateCartQuantity(int cartId, int quantity) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QTY_QUERY);
			pstmt.setInt(1, quantity);
			pstmt.setInt(2, cartId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void removeFromCart(int cartId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			pstmt.setInt(1, cartId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Cart> getCartByUser(int userId) {
		Connection connection = DBConnection.getConnection();
		List<Cart> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_USER_QUERY);
			pstmt.setInt(1, userId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getCartByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Cart getCartItem(int userId, int menuId) {
		Connection connection = DBConnection.getConnection();
		Cart c = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_ITEM_QUERY);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, menuId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				c = getCartByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return c;
	}

	@Override
	public void clearCart(int userId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(CLEAR_QUERY);
			pstmt.setInt(1, userId);

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private static Cart getCartByResultSet(ResultSet res) throws SQLException {
		int cartId = res.getInt("cartId");
		int userId = res.getInt("userId");
		int menuId = res.getInt("menuId");
		int quantity = res.getInt("quantity");
		Timestamp addedDate = res.getTimestamp("addedDate");

		return new Cart(cartId, userId, menuId, quantity, addedDate);
	}
}
