<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.Address, com.tap.DAOimpl.AddressDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Fetch saved addresses
    AddressDAOimpl addressDAO = new AddressDAOimpl();
    List<Address> addressList = addressDAO.getAddressesByUser(loggedUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 6rem auto 4rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }
        @media (max-width: 968px) {
            .profile-container {
                grid-template-columns: 1fr;
            }
        }
        .profile-card {
            padding: 2.5rem;
            border-radius: var(--radius-md);
            height: fit-content;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 1.5rem;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: var(--primary-grad);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            box-shadow: 0 10px 20px rgba(255, 95, 46, 0.2);
        }
        .profile-details-list {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            border-top: 1px solid var(--border-color);
            padding-top: 1.5rem;
            text-align: left;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
        }
        .detail-item span:first-child {
            color: var(--text-muted);
        }
        .detail-item span:last-child {
            font-weight: 600;
        }
        .section-card {
            padding: 2.5rem;
            border-radius: var(--radius-md);
            margin-bottom: 2rem;
        }
        .section-title {
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .address-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2rem;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            margin-bottom: 1rem;
            transition: var(--transition);
        }
        .address-row:hover {
            border-color: rgba(255, 255, 255, 0.15);
        }
        .address-info {
            font-size: 0.95rem;
        }
        .address-tag {
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.25rem;
        }
        .address-tag span {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #34d399;
            font-size: 0.7rem;
            padding: 0.1rem 0.5rem;
            border-radius: 4px;
        }
        .delete-btn {
            background: transparent;
            border: none;
            color: #ef4444;
            cursor: pointer;
            font-size: 1.1rem;
            padding: 0.5rem;
            transition: var(--transition);
        }
        .delete-btn:hover {
            transform: scale(1.1);
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="profile-container">
        <!-- 1. Left Profile Summary Card -->
        <div class="profile-card glass-panel">
            <div class="profile-avatar">👤</div>
            <div>
                <h3 style="font-size: 1.4rem; font-weight: 700;"><%= loggedUser.getUserName() %></h3>
                <p style="color: var(--text-muted); font-size: 0.9rem; text-transform: capitalize;"><%= loggedUser.getRole() %></p>
            </div>
            
            <div class="profile-details-list">
                <div class="detail-item">
                    <span>Email</span>
                    <span><%= loggedUser.getEmail() %></span>
                </div>
                <div class="detail-item">
                    <span>Phone</span>
                    <span><%= loggedUser.getPhone() %></span>
                </div>
                <div class="detail-item">
                    <span>Member Since</span>
                    <span><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(loggedUser.getCreatedDate()) %></span>
                </div>
            </div>
        </div>

        <!-- 2. Right Actions (Saved Addresses & Add Address Form) -->
        <div>
            <!-- Saved Addresses List -->
            <div class="section-card glass-panel">
                <div class="section-title">Saved Delivery Addresses</div>
                
                <% if (addressList != null && !addressList.isEmpty()) { %>
                    <% for (Address addr : addressList) { %>
                        <div class="address-row">
                            <div class="address-info">
                                <div class="address-tag">
                                    <%= addr.getLabel() %>
                                    <% if (addr.isDefault()) { %><span>Default</span><% } %>
                                </div>
                                <div><%= addr.getStreet() %>, <%= addr.getCity() %>, <%= addr.getState() %> - <%= addr.getPincode() %></div>
                            </div>
                            <form action="${pageContext.request.contextPath}/address" method="POST">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="addressId" value="<%= addr.getAddressId() %>">
                                <input type="hidden" name="redirectUrl" value="customer/profile.jsp">
                                <button type="submit" class="delete-btn" title="Delete Address">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } else { %>
                    <div style="text-align: center; padding: 2rem 0; color: var(--text-muted);">
                        <i class="fa-solid fa-map-location" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                        <p>No saved addresses found. Add one below!</p>
                    </div>
                <% } %>
            </div>

            <!-- Add Address Form -->
            <div class="section-card glass-panel">
                <div class="section-title">Add New Address</div>
                <form action="${pageContext.request.contextPath}/address" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="redirectUrl" value="customer/profile.jsp"> <!-- Redirects back to profile -->
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                        <div class="form-group">
                            <label for="label">Address Label</label>
                            <input type="text" id="label" name="label" class="form-control" placeholder="Home, Office, etc." required>
                        </div>
                        <div class="form-group">
                            <label for="pincode">Pincode</label>
                            <input type="text" id="pincode" name="pincode" class="form-control" placeholder="6-digit pincode" required pattern="[0-9]{6}">
                        </div>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 1rem;">
                        <label for="street">Street Address</label>
                        <input type="text" id="street" name="street" class="form-control" placeholder="Flat/Room, Building/Street" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" name="city" class="form-control" placeholder="Enter City" required>
                        </div>
                        <div class="form-group">
                            <label for="state">State</label>
                            <input type="text" id="state" name="state" class="form-control" placeholder="Enter State" required>
                        </div>
                    </div>

                    <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; cursor: pointer; margin-bottom: 1.5rem;">
                        <input type="checkbox" name="isDefault" value="true" style="accent-color: var(--primary);"> Make this my default address
                    </label>

                    <button type="submit" class="btn btn-primary" style="padding: 0.8rem 1.8rem;">
                        Add Address
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
