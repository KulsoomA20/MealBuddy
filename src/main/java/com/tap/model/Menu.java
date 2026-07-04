package com.tap.model;

public class Menu {
	
	private int menuId;
	private int restId;
	private String itemName;
	private String description;
	private double price;
	private String category;
	private boolean isAvailable;
	private String imagePath;
	private boolean isVeg;
	
	public Menu() {
		// TODO Auto-generated constructor stub
	}

	public Menu(int restId, String itemName, String description, double price, String category, boolean isAvailable,
			String imagePath, boolean isVeg) {
		super();
		this.restId = restId;
		this.itemName = itemName;
		this.description = description;
		this.price = price;
		this.category = category;
		this.isAvailable = isAvailable;
		this.imagePath = imagePath;
		this.isVeg = isVeg;
	}

	public Menu(int menuId, int restId, String itemName, String description, double price, String category,
			boolean isAvailable, String imagePath, boolean isVeg) {
		super();
		this.menuId = menuId;
		this.restId = restId;
		this.itemName = itemName;
		this.description = description;
		this.price = price;
		this.category = category;
		this.isAvailable = isAvailable;
		this.imagePath = imagePath;
		this.isVeg = isVeg;
	}

	public int getMenuId() {
		return menuId;
	}

	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}

	public int getRestId() {
		return restId;
	}

	public void setRestId(int restId) {
		this.restId = restId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public boolean isAvailable() {
		return isAvailable;
	}

	public void setAvailable(boolean isAvailable) {
		this.isAvailable = isAvailable;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public boolean isVeg() {
		return isVeg;
	}

	public void setVeg(boolean isVeg) {
		this.isVeg = isVeg;
	}

	@Override
	public String toString() {
		return "Menu [menuId=" + menuId + ", restId=" + restId + ", itemName=" + itemName + ", description="
				+ description + ", price=" + price + ", category=" + category + ", isAvailable=" + isAvailable
				+ ", imagePath=" + imagePath + ", isVeg=" + isVeg + "]";
	}
}
