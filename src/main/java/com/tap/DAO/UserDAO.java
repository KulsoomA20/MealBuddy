package com.tap.DAO;

import com.tap.model.User;

import java.util.List;

public interface UserDAO {
	
	 void addUser(User u);
	 
	 void updateUser(User u);
	 
	 void deleteUser(int userId);
	 
	 User getUser(int userId);
	 
	 User getUserByEmail(String email);
	 
	 List<User> getAllUsers();
	 
	 List<User> getUsersByRole(String role);

}
