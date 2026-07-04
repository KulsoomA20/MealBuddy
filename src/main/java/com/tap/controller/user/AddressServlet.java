package com.tap.controller.user;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.DAOimpl.AddressDAOimpl;
import com.tap.model.Address;
import com.tap.model.User;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AddressDAOimpl addressDAO;

    @Override
    public void init() throws ServletException {
        addressDAO = new AddressDAOimpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = request.getParameter("redirectUrl");
        if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
            redirectUrl = "customer/profile.jsp";
        }

        if ("add".equals(action)) {
            String label = request.getParameter("label");
            String street = request.getParameter("street");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String pincode = request.getParameter("pincode");
            boolean isDefault = request.getParameter("isDefault") != null;

            // If this is set to default, reset other addresses' default status
            if (isDefault) {
                List<Address> list = addressDAO.getAddressesByUser(loggedUser.getUserId());
                for (Address addr : list) {
                    if (addr.isDefault()) {
                        addr.setDefault(false);
                        addressDAO.updateAddress(addr);
                    }
                }
            }

            // Create and save new address
            Address newAddr = new Address(loggedUser.getUserId(), label, street, city, state, pincode, isDefault);
            addressDAO.addAddress(newAddr);
        }
        else if ("delete".equals(action)) {
            try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                addressDAO.deleteAddress(addressId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(redirectUrl);
    }
}
