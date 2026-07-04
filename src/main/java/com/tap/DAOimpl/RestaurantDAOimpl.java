package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDAOimpl implements RestaurantDAO {

	private static final String INSERT_QUERY = "INSERT INTO restaurant(restName, cuisineType, deliveryTime, address, rating, isActive, imagePath, adminUserId, restType) VALUES(?,?,?,?,?,?,?,?,?)";
	private static final String UPDATE_QUERY = "UPDATE restaurant SET restName=?, cuisineType=?, deliveryTime=?, address=?, rating=?, isActive=?, imagePath=?, adminUserId=?, restType=? WHERE restId=?";
	private static final String DELETE_QUERY = "DELETE FROM restaurant WHERE restId=?";
	private static final String SELECT_QUERY = "SELECT * FROM restaurant WHERE restId=?";
	private static final String SELECT_ALL_QUERY = "SELECT * FROM restaurant";
	private static final String SELECT_ACTIVE_QUERY = "SELECT * FROM restaurant WHERE isActive=1";
	private static final String SELECT_BY_ADMIN_QUERY = "SELECT * FROM restaurant WHERE adminUserId=?";

	@Override
	public void addRestaurant(Restaurant r) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setString(1, r.getRestName());
			pstmt.setString(2, r.getCuisineType());
			pstmt.setInt(3, r.getDeliveryTime());
			pstmt.setString(4, r.getAddress());
			pstmt.setDouble(5, r.getRating());
			pstmt.setBoolean(6, r.isActive());
			pstmt.setString(7, r.getImagePath());
			
			if (r.getAdminUserId() > 0) {
				pstmt.setInt(8, r.getAdminUserId());
			} else {
				pstmt.setNull(8, java.sql.Types.INTEGER);
			}
			pstmt.setString(9, r.getRestType());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateRestaurant(Restaurant r) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			pstmt.setString(1, r.getRestName());
			pstmt.setString(2, r.getCuisineType());
			pstmt.setInt(3, r.getDeliveryTime());
			pstmt.setString(4, r.getAddress());
			pstmt.setDouble(5, r.getRating());
			pstmt.setBoolean(6, r.isActive());
			pstmt.setString(7, r.getImagePath());
			
			if (r.getAdminUserId() > 0) {
				pstmt.setInt(8, r.getAdminUserId());
			} else {
				pstmt.setNull(8, java.sql.Types.INTEGER);
			}
			
			pstmt.setString(9, r.getRestType());
			pstmt.setInt(10, r.getRestId());

			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteRestaurant(int restId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			pstmt.setInt(1, restId);
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Restaurant getRestaurant(int restId) {
		Connection connection = DBConnection.getConnection();
		Restaurant r = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			pstmt.setInt(1, restId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				r = getRestaurantByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return r;
	}

	@Override
	public List<Restaurant> getAllRestaurants() {
		Connection connection = DBConnection.getConnection();
		List<Restaurant> list = new ArrayList<>();
		try {
			Statement stmt = connection.createStatement();
			ResultSet res = stmt.executeQuery(SELECT_ALL_QUERY);
			while (res.next()) {
				list.add(getRestaurantByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Restaurant> getActiveRestaurants() {
		Connection connection = DBConnection.getConnection();
		List<Restaurant> list = new ArrayList<>();
		try {
			Statement stmt = connection.createStatement();
			ResultSet res = stmt.executeQuery(SELECT_ACTIVE_QUERY);
			while (res.next()) {
				list.add(getRestaurantByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Restaurant> getRestaurantsByAdmin(int adminUserId) {
		Connection connection = DBConnection.getConnection();
		List<Restaurant> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_ADMIN_QUERY);
			pstmt.setInt(1, adminUserId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getRestaurantByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private static Restaurant getRestaurantByResultSet(ResultSet res) throws SQLException {
		int restId = res.getInt("restId");
		String restName = res.getString("restName");
		String cuisineType = res.getString("cuisineType");
		int deliveryTime = res.getInt("deliveryTime");
		String address = res.getString("address");
		double rating = res.getDouble("rating");
		boolean isActive = res.getBoolean("isActive");
		String imagePath = res.getString("imagePath");
		int adminUserId = res.getInt("adminUserId");
		String restType = res.getString("restType");

		return new Restaurant(restId, restName, cuisineType, deliveryTime, address, rating, isActive, imagePath, adminUserId, restType);
	}
}
