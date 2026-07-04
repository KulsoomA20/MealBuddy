package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDAOimpl implements UserDAO {
	
	private static final String INSERT_QUERY = "INSERT INTO user(userName,password,email,phone,role,lastLoginDate)"
											+ "Values(?,?,?,?,?,?)";
	
	private static final String SELECT_QUERY = "SELECT * FROM user WHERE userId = ?";
	
	private static final String SELECT_QUERY_ALL = "SELECT * FROM user";
	
	private static final String UPDATE_QUERY = "UPDATE user SET userName = ?, "
			+ "password = ?, email = ?, phone = ?, lastLoginDate = ?"
			+ "WHERE userId = ?";
	
	private static final String DELETE_QUERY = "DELETE FROM user WHERE userId = ?";
	
	private static final String SELECT_EMAIL_QUERY = "SELECT * FROM user WHERE email = ?";
	
	private static final String SELECT_ROLE_QUERY = "SELECT * FROM user WHERE role = ?";

	@Override
	public void addUser(User u) {
		
		Connection connection = DBConnection.getConnection();
		
		try {
			PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
			
			pstmt.setString(1,u.getUserName() );
			
			String hashed = com.tap.util.PasswordHasher.hash(u.getPassword());
			u.setPassword(hashed);
			pstmt.setString(2, hashed);
			
			pstmt.setString(3, u.getEmail());
			pstmt.setString(4, u.getPhone());
			pstmt.setString(5, u.getRole());
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
			
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void updateUser(User u) {
		
		Connection connection = DBConnection.getConnection();
		
		try {
			PreparedStatement pstmt = connection.prepareStatement(UPDATE_QUERY);
			pstmt.setString(1,u.getUserName() );
			
			String pwd = u.getPassword();
			if (pwd != null && !pwd.startsWith("$2a$") && !pwd.startsWith("$2y$") && !pwd.startsWith("$2b$")) {
				pwd = com.tap.util.PasswordHasher.hash(pwd);
				u.setPassword(pwd);
			}
			pstmt.setString(2, pwd);
			
			pstmt.setString(3, u.getEmail());
			pstmt.setString(4, u.getPhone());
			pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(6, u.getUserId());
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
			
		} 
		catch (SQLException e) {

			e.printStackTrace();
		}
		
		
	}

	@Override
	public void deleteUser(int userId) {
		
		Connection connection = DBConnection.getConnection();
		
		try {
			
			PreparedStatement pstmt = connection.prepareStatement(DELETE_QUERY);
			pstmt.setInt(1, userId);
			
			int n = pstmt.executeUpdate();
			System.out.println(n);
		} 
		
		catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public User getUser(int userId) {
		
		Connection connection = DBConnection.getConnection();
		User u = null;
		
		try {
			
			PreparedStatement pstmt = connection.prepareStatement(SELECT_QUERY);
			pstmt.setInt(1, userId);
			
			ResultSet res = pstmt.executeQuery();
			
			while(res.next()) {
				
				u = getUserByResultSet(res);
			}	
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}

	@Override
	public List<User> getAllUsers() {
		
		ArrayList<User> allUser = new ArrayList<User>();
		
		Connection connection = DBConnection.getConnection();
		
		try {
			
			Statement stmt = connection.createStatement();
			
			ResultSet res = stmt.executeQuery(SELECT_QUERY_ALL);
			
			while(res.next()) {
				
				User u = getUserByResultSet(res);
				allUser.add(u);
			}
			
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return allUser;
	}
	
	

	@Override
	public User getUserByEmail(String email) {
		
		Connection connection = DBConnection.getConnection();
		User u = null;
		
		try {
			
			PreparedStatement pstmt = connection.prepareStatement(SELECT_EMAIL_QUERY);
			pstmt.setString(1, email);
			
			ResultSet res = pstmt.executeQuery();
			
			while(res.next()) {
				
				u = getUserByResultSet(res);
			}
			
			
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		return u;
	}



	@Override
	public List<User> getUsersByRole(String role) {
		
		Connection connection = DBConnection.getConnection();
		ArrayList<User> list = new ArrayList<User>();
		
		try {
			
			PreparedStatement pstmt = connection.prepareStatement(SELECT_ROLE_QUERY);
			pstmt.setString(1, role);
			
			ResultSet res = pstmt.executeQuery();
			
			while(res.next()) {
				User u = getUserByResultSet(res);
				list.add(u);
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	
	private static User getUserByResultSet(ResultSet res) throws SQLException {
		
		int userId = res.getInt("userId");
		String userName = res.getString("userName");
		String password = res.getString("password");
		String email = res.getString("email");
		String phone = res.getString("phone");
		String role = res.getString("role");
		Timestamp createdDate = res.getTimestamp("createdDate");
		Timestamp lastLoginDate = res.getTimestamp("lastLoginDate");
		
		User u = new User(userId, userName, password, email, phone, role, createdDate, lastLoginDate);
		
		return u;
	}

}
