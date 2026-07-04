package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.AddressDAO;
import com.tap.model.Address;
import com.tap.util.DBConnection;

public class AddressDAOimpl implements AddressDAO {
	
	private static final String INSERT_QUERY = "INSERT INTO address(userId, label, street, city, state, pincode, isDefault) VALUES(?,?,?,?,?,?,?)";
	private static final String UPDATE_QUERY = "UPDATE address SET label=?, street=?, city=?, state=?, pincode=?, isDefault=? WHERE addressId=?";
	private static final String DELETE_QUERY = "DELETE FROM address WHERE addressId=?";
	private static final String SELECT_QUERY = "SELECT * FROM address WHERE addressId=?";
	private static final String SELECT_BY_USER_QUERY = "SELECT * FROM address WHERE userId=?";
	private static final String SELECT_DEFAULT_QUERY = "SELECT * FROM address WHERE userId=? AND isDefault=1";

	@Override
	public void addAddress(Address a) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			pstmt.setInt(1, a.getUserId());
			pstmt.setString(2, a.getLabel());
			pstmt.setString(3, a.getStreet());
			pstmt.setString(4, a.getCity());
			pstmt.setString(5, a.getState());
			pstmt.setString(6, a.getPincode());
			pstmt.setBoolean(7, a.isDefault());
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateAddress(Address a) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			pstmt.setString(1, a.getLabel());
			pstmt.setString(2, a.getStreet());
			pstmt.setString(3, a.getCity());
			pstmt.setString(4, a.getState());
			pstmt.setString(5, a.getPincode());
			pstmt.setBoolean(6, a.isDefault());
			pstmt.setInt(7, a.getAddressId());
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deleteAddress(int addressId) {
		Connection connection = DBConnection.getConnection();
		try {
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			pstmt.setInt(1, addressId);
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Address getAddress(int addressId) {
		Connection connection = DBConnection.getConnection();
		Address address = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			pstmt.setInt(1, addressId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				address = getAddressByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return address;
	}

	@Override
	public List<Address> getAddressesByUser(int userId) {
		Connection connection = DBConnection.getConnection();
		List<Address> list = new ArrayList<>();
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_USER_QUERY);
			pstmt.setInt(1, userId);
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				list.add(getAddressByResultSet(res));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Address getDefaultAddress(int userId) {
		Connection connection = DBConnection.getConnection();
		Address address = null;
		try {
			PreparedStatement pstmt = connection.prepareStatement(SELECT_DEFAULT_QUERY);
			pstmt.setInt(1, userId);
			ResultSet res = pstmt.executeQuery();
			if (res.next()) {
				address = getAddressByResultSet(res);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return address;
	}
	
	private static Address getAddressByResultSet(ResultSet res) throws SQLException {
		int addressId = res.getInt("addressId");
		int userId = res.getInt("userId");
		String label = res.getString("label");
		String street = res.getString("street");
		String city = res.getString("city");
		String state = res.getString("state");
		String pincode = res.getString("pincode");
		boolean isDefault = res.getBoolean("isDefault");
		
		return new Address(addressId, userId, label, street, city, state, pincode, isDefault);
	}
}
