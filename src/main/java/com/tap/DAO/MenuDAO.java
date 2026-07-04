package com.tap.DAO;

import com.tap.model.Menu;

import java.util.List;

public interface MenuDAO {
	
	 void addMenuItem(Menu m);
	 
	 void updateMenuItem(Menu m);
	 
	 void deleteMenuItem(int menuId);
	 
	 Menu getMenuItem(int menuId);
	 
	 List<Menu> getMenuByRestaurant(int restId);
	 
	 List<Menu> getAvailableMenuByRestaurant(int restId);

}
