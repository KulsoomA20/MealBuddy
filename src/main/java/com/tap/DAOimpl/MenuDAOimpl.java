package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.MenuDAO;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDAOimpl implements MenuDAO {

	private static final String INSERT_QUERY = "INSERT INTO menu(restId, itemName, description, price, category, isAvailable, imagePath, isVeg) VALUES(?,?,?,?,?,?,?,?)";
	private static final String UPDATE_QUERY = "UPDATE menu SET restId=?, itemName=?, description=?, price=?, category=?, isAvailable=?, imagePath=?, isVeg=? WHERE menuId=?";
	private static final String DELETE_QUERY = "DELETE FROM menu WHERE menuId=?";
	private static final String SELECT_QUERY = "SELECT * FROM menu WHERE menuId=?";
	private static final String SELECT_BY_REST_QUERY = "SELECT * FROM menu WHERE restId=?";
	private static final String SELECT_AVAILABLE_BY_REST_QUERY = "SELECT * FROM menu WHERE restId=? AND isAvailable=1";

	@Override
	public void addMenuItem(Menu m) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, m.getRestId());
			pstmt.setString(2, m.getItemName());
			pstmt.setString(3, m.getDescription());
			pstmt.setDouble(4, m.getPrice());
			pstmt.setString(5, m.getCategory());
			pstmt.setBoolean(6, m.isAvailable());
			pstmt.setString(7, m.getImagePath());
			pstmt.setBoolean(8, m.isVeg());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateMenuItem(Menu m) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			pstmt.setInt(1, m.getRestId());
			pstmt.setString(2, m.getItemName());
			pstmt.setString(3, m.getDescription());
			pstmt.setDouble(4, m.getPrice());
			pstmt.setString(5, m.getCategory());
			pstmt.setBoolean(6, m.isAvailable());
			pstmt.setString(7, m.getImagePath());
			pstmt.setBoolean(8, m.isVeg());
			pstmt.setInt(9, m.getMenuId());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteMenuItem(int menuId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			pstmt.setInt(1, menuId);
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Menu getMenuItem(int menuId) {
		Connection connection = DBConnection.getConnection();
		Menu m = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			pstmt.setInt(1, menuId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				m = getMenuByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return m;
	}

	@Override
	public List<Menu> getMenuByRestaurant(int restId) {
		Connection connection = DBConnection.getConnection();
		List<Menu> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_REST_QUERY);
			pstmt.setInt(1, restId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getMenuByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Menu> getAvailableMenuByRestaurant(int restId) {
		Connection connection = DBConnection.getConnection();
		List<Menu> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_AVAILABLE_BY_REST_QUERY);
			pstmt.setInt(1, restId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getMenuByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private static Menu getMenuByResultSet(ResultSet res) throws SQLException {
		int menuId = res.getInt("menuId");
		int restId = res.getInt("restId");
		String itemName = res.getString("itemName");
		String description = res.getString("description");
		double price = res.getDouble("price");
		String category = res.getString("category");
		boolean isAvailable = res.getBoolean("isAvailable");
		String imagePath = res.getString("imagePath");
		boolean isVeg = res.getBoolean("isVeg");

		return new Menu(menuId, restId, itemName, description, price, category, isAvailable, imagePath, isVeg);
	}
}
