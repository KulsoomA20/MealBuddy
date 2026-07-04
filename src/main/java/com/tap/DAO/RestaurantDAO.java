package com.tap.DAO;

import com.tap.model.Restaurant;

import java.util.List;

public interface RestaurantDAO {
	
	 void addRestaurant(Restaurant r);
	 
	 void updateRestaurant(Restaurant r);
	 
	 void deleteRestaurant(int restId);
	 
	 Restaurant getRestaurant(int restId);
	 
	 List<Restaurant> getAllRestaurants();
	 
	 List<Restaurant> getActiveRestaurants();
	 
	 List<Restaurant> getRestaurantsByAdmin(int adminUserId);

}
