package com.tap.DAO;

import com.tap.model.Address;

import java.util.List;

public interface AddressDAO {
	
	 void addAddress(Address a);
	 
	 void updateAddress(Address a);
	 
	 void deleteAddress(int addressId);
	 
	 Address getAddress(int addressId);
	 
	 List<Address> getAddressesByUser(int userId);
	 
	 Address getDefaultAddress(int userId);

}
