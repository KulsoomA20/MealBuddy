package com.tap.model;

public class Address {
	
	private int addressId;
	private int userId;
	private String label;
	private String street;
	private String city;
	private String state;
	private String pincode;
	private boolean isDefault;

	public Address() {
		
	}

	public Address(int userId, String label, String street, String city, String state, String pincode,
			boolean isDefault) {
		super();
		this.userId = userId;
		this.label = label;
		this.street = street;
		this.city = city;
		this.state = state;
		this.pincode = pincode;
		this.isDefault = isDefault;
	}

	public Address(int addressId, int userId, String label, String street, String city, String state, String pincode,
			boolean isDefault) {
		super();
		this.addressId = addressId;
		this.userId = userId;
		this.label = label;
		this.street = street;
		this.city = city;
		this.state = state;
		this.pincode = pincode;
		this.isDefault = isDefault;
	}

	public int getAddressId() {
		return addressId;
	}

	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getPincode() {
		return pincode;
	}

	public void setPincode(String pincode) {
		this.pincode = pincode;
	}

	public boolean isDefault() {
		return isDefault;
	}

	public void setDefault(boolean isDefault) {
		this.isDefault = isDefault;
	}

	@Override
	public String toString() {
		return "Address [addressId=" + addressId + ", userId=" + userId + ", label=" + label + ", street=" + street
				+ ", city=" + city + ", state=" + state + ", pincode=" + pincode + ", isDefault=" + isDefault + "]";
	}
	
	
}


