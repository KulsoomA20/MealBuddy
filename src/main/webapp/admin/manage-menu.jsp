<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User, com.tap.model.Restaurant, com.tap.model.Menu, com.tap.DAOimpl.RestaurantDAOimpl, com.tap.DAOimpl.MenuDAOimpl, java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String restIdStr = request.getParameter("restId");
    if (restIdStr == null) {
        response.sendRedirect("manage-restaurants.jsp");
        return;
    }

    int restId = Integer.parseInt(restIdStr);

    RestaurantDAOimpl restaurantDAO = new RestaurantDAOimpl();
    MenuDAOimpl menuDAO = new MenuDAOimpl();

    Restaurant restaurant = restaurantDAO.getRestaurant(restId);
    List<Menu> list = menuDAO.getMenuByRestaurant(restId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Menu - <%= restaurant.getRestName() %> - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="manage-container">
        <!-- List of Menu Items -->
        <div>
            <div class="manage-card glass-panel">
                <div class="manage-title" style="display:flex; justify-content:space-between; align-items:center;">
                    <span>Menu of <%= restaurant.getRestName() %></span>
                    <a href="manage-restaurants.jsp" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                        <i class="fa-solid fa-arrow-left"></i> Back
                    </a>
                </div>
                
                <% if (list != null && !list.isEmpty()) { %>
                    <% for (Menu item : list) { %>
                        <div class="item-row" style="flex-wrap: wrap; gap: 1rem;">
                            <div class="item-details" style="flex: 1; min-width: 250px;">
                                <span style="background:rgba(255,255,255,0.08); font-size:0.7rem; padding:0.15rem 0.5rem; border-radius:4px; text-transform:uppercase; color:var(--text-muted); font-weight:600;"><%= item.getCategory() %></span>
                                <h4 style="margin-top:0.4rem; display:flex; align-items:center; gap:0.5rem;">
                                    <% if (item.isVeg()) { %>
                                        <span class="veg-icon" title="Vegetarian"></span>
                                    <% } else { %>
                                        <span class="nonveg-icon" title="Non-Vegetarian"></span>
                                    <% } %>
                                    <%= item.getItemName() %>
                                </h4>
                                <p><%= item.getDescription() %></p>
                                <p style="margin-top: 0.25rem;">
                                    Status: 
                                    <% if (item.isAvailable()) { %>
                                        <span style="color: var(--accent); font-weight:600;">Available</span>
                                    <% } else { %>
                                        <span style="color: #ef4444; font-weight:600;">Unavailable</span>
                                    <% } %>
                                </p>
                            </div>
                            
                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 0.5rem; justify-content: center; min-width: 150px;">
                                <div class="item-price-tag">Rs. <%= item.getPrice() %></div>
                                <div style="display: flex; gap: 0.25rem; margin-top: 0.5rem;">
                                    <button type="button" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" onclick="editMenuItem(<%= item.getMenuId() %>, '<%= item.getItemName().replace("'", "\\'") %>', '<%= item.getDescription().replace("'", "\\'") %>', <%= item.getPrice() %>, '<%= item.getCategory().replace("'", "\\'") %>', '<%= item.getImagePath() %>', <%= item.isVeg() %>, <%= item.isAvailable() %>)">
                                        <i class="fa-solid fa-edit"></i> Edit
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin-control" method="POST" style="display:contents;">
                                        <input type="hidden" name="action" value="toggleMenuItemStatus">
                                        <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                                        <input type="hidden" name="restId" value="<%= restId %>">
                                        <button type="submit" class="btn <%= item.isAvailable() ? "btn-secondary" : "btn-primary" %>" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; border: 1px solid var(--border-color);">
                                            <%= item.isAvailable() ? "Deactivate" : "Activate" %>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div style="text-align: center; padding: 3rem 0; color: var(--text-muted);">
                        <i class="fa-solid fa-mug-hot" style="font-size: 2.5rem; margin-bottom: 1rem;"></i>
                        <p>No dishes added to this menu. Add one on the right!</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Add/Edit Menu Item Form -->
        <div>
            <div class="manage-card glass-panel" style="position: sticky; top: 6rem;" id="formContainer">
                <div class="manage-title" id="formHeader">Add Menu Item</div>
                <form action="${pageContext.request.contextPath}/admin-control" method="POST" id="itemForm">
                    <input type="hidden" id="formAction" name="action" value="addMenuItem">
                    <input type="hidden" id="formMenuId" name="menuId" value="">
                    <input type="hidden" name="restId" value="<%= restId %>">
                    
                    <div class="form-group">
                        <label for="itemName">Item Name</label>
                        <input type="text" id="itemName" name="itemName" class="form-control" placeholder="e.g. Cheese Pizza" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description</label>
                        <input type="text" id="description" name="description" class="form-control" placeholder="e.g. Loaded with mozzarella" required>
                    </div>

                    <div class="form-group">
                        <label for="price">Price (Rs.)</label>
                        <input type="number" id="price" name="price" class="form-control" placeholder="e.g. 299" required min="1" step="0.01">
                    </div>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <input type="text" id="category" name="category" class="form-control" placeholder="e.g. Pizza, Side, Beverage" required>
                    </div>

                    <div class="form-group">
                        <label for="imagePath">Image File Name</label>
                        <input type="text" id="imagePath" name="imagePath" class="form-control" placeholder="e.g. cheese_pizza.jpg" required>
                    </div>

                    <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; cursor: pointer; margin-bottom: 0.5rem;">
                        <input type="checkbox" id="isVeg" name="isVeg" value="true" checked style="accent-color: var(--primary);"> Item is vegetarian (Veg)
                    </label>

                    <label style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; cursor: pointer; margin-bottom: 1.5rem;">
                        <input type="checkbox" id="isAvailable" name="isAvailable" value="true" checked style="accent-color: var(--primary);"> Item is available to order
                    </label>

                    <button type="submit" id="submitBtn" class="btn btn-primary" style="width: 100%; padding: 0.8rem;">
                        Add Menu Item
                    </button>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <script>
        function editMenuItem(id, name, desc, price, cat, img, veg, avail) {
            document.getElementById('formHeader').innerText = 'Edit Menu Item';
            document.getElementById('formAction').value = 'updateMenuItem';
            document.getElementById('formMenuId').value = id;
            document.getElementById('itemName').value = name;
            document.getElementById('description').value = desc;
            document.getElementById('price').value = price;
            document.getElementById('category').value = cat;
            document.getElementById('imagePath').value = img;
            document.getElementById('isVeg').checked = veg;
            document.getElementById('isAvailable').checked = avail;
            document.getElementById('submitBtn').innerText = 'Update Menu Item';
            
            // Add a "Cancel Edit" button if it doesn't exist
            if (!document.getElementById('cancelEditBtn')) {
                const cancelBtn = document.createElement('button');
                cancelBtn.type = 'button';
                cancelBtn.id = 'cancelEditBtn';
                cancelBtn.className = 'btn btn-secondary';
                cancelBtn.style.width = '100%';
                cancelBtn.style.marginTop = '0.5rem';
                cancelBtn.style.padding = '0.8rem';
                cancelBtn.innerText = 'Cancel Edit';
                cancelBtn.onclick = function() {
                    resetForm();
                };
                document.getElementById('itemForm').appendChild(cancelBtn);
            }
            window.scrollTo({ top: document.getElementById('formContainer').offsetTop - 100, behavior: 'smooth' });
        }
        
        function resetForm() {
            document.getElementById('formHeader').innerText = 'Add Menu Item';
            document.getElementById('formAction').value = 'addMenuItem';
            document.getElementById('formMenuId').value = '';
            document.getElementById('itemName').value = '';
            document.getElementById('description').value = '';
            document.getElementById('price').value = '';
            document.getElementById('category').value = '';
            document.getElementById('imagePath').value = '';
            document.getElementById('isVeg').checked = true;
            document.getElementById('isAvailable').checked = true;
            document.getElementById('submitBtn').innerText = 'Add Menu Item';
            const cancelBtn = document.getElementById('cancelEditBtn');
            if (cancelBtn) {
                cancelBtn.remove();
            }
        }
    </script>
</body>
</html>
