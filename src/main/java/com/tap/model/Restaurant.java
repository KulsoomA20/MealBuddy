package com.tap.model;

public class Restaurant {

	private int restId;
	private String restName;
	private String cuisineType;
	private int deliveryTime;
	private String address;
	private double rating;
	private boolean isActive;
	private String imagePath;
	private int adminUserId;
	private String restType;
	
	public Restaurant() {
		// TODO Auto-generated constructor stub
	}

	public Restaurant(String restName, String cuisineType, int deliveryTime, String address, double rating,
			boolean isActive, String imagePath, int adminUserId) {
		super();
		this.restName = restName;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
		this.adminUserId = adminUserId;
		this.restType = "Both";
	}

	public Restaurant(int restId, String restName, String cuisineType, int deliveryTime, String address, double rating,
			boolean isActive, String imagePath, int adminUserId) {
		super();
		this.restId = restId;
		this.restName = restName;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
		this.adminUserId = adminUserId;
		this.restType = "Both";
	}

	public Restaurant(String restName, String cuisineType, int deliveryTime, String address, double rating,
			boolean isActive, String imagePath, int adminUserId, String restType) {
		super();
		this.restName = restName;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
		this.adminUserId = adminUserId;
		this.restType = restType;
	}

	public Restaurant(int restId, String restName, String cuisineType, int deliveryTime, String address, double rating,
			boolean isActive, String imagePath, int adminUserId, String restType) {
		super();
		this.restId = restId;
		this.restName = restName;
		this.cuisineType = cuisineType;
		this.deliveryTime = deliveryTime;
		this.address = address;
		this.rating = rating;
		this.isActive = isActive;
		this.imagePath = imagePath;
		this.adminUserId = adminUserId;
		this.restType = restType;
	}

	public int getRestId() {
		return restId;
	}

	public void setRestId(int restId) {
		this.restId = restId;
	}

	public String getRestName() {
		return restName;
	}

	public void setRestName(String restName) {
		this.restName = restName;
	}

	public String getCuisineType() {
		return cuisineType;
	}

	public void setCuisineType(String cuisineType) {
		this.cuisineType = cuisineType;
	}

	public int getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(int deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public int getAdminUserId() {
		return adminUserId;
	}

	public void setAdminUserId(int adminUserId) {
		this.adminUserId = adminUserId;
	}

	public String getRestType() {
		return restType;
	}

	public void setRestType(String restType) {
		this.restType = restType;
	}

	@Override
	public String toString() {
		return "Restaurant [restId=" + restId + ", restName=" + restName + ", cuisineType=" + cuisineType
				+ ", deliveryTime=" + deliveryTime + ", address=" + address + ", rating=" + rating + ", isActive="
				+ isActive + ", imagePath=" + imagePath + ", adminUserId=" + adminUserId + ", restType=" + restType + "]";
	}
}
