<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${restaurant.restName} - Menu - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <!-- Restaurant Banner -->
    <div class="menu-banner glass-panel">
        <!-- Left Side: Restaurant Image -->
        <div class="banner-image-container">
            <c:choose>
                <c:when test="${not empty restaurant.imagePath}">
                    <img src="${fn:startsWith(restaurant.imagePath, 'http') ? restaurant.imagePath : pageContext.request.contextPath.concat('/images/').concat(restaurant.imagePath)}" alt="${restaurant.restName}" style="width: 100%; height: 100%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(255, 255, 255, 0.02);">
                        <i class="fa-solid fa-utensils" style="font-size: 3rem; color: var(--text-muted); opacity: 0.3;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Right Side: Restaurant Details -->
        <div class="banner-details">
            <h2>${restaurant.restName}</h2>
            <p><i class="fa-solid fa-map-marker-alt" style="color: var(--primary);"></i> ${restaurant.address}</p>
            <div class="banner-meta">
                <span><i class="fa-solid fa-utensils"></i> ${restaurant.cuisineType}</span>
                <span><i class="fa-solid fa-star" style="color: #fbbf24;"></i> ${restaurant.rating} / 5.0</span>
                <span><i class="fa-solid fa-truck" style="color: var(--accent);"></i> ${restaurant.deliveryTime} mins delivery</span>
            </div>
        </div>
    </div>

    <!-- Menu Section -->
    <main class="menu-section">
        
        <div class="filter-row">
            <h3 style="font-size: 1.5rem; font-weight: 700;">Menu Items</h3>
            <div class="filter-buttons">
                <button class="filter-btn active" onclick="applyFilter(this, 'all')">All</button>
                <button class="filter-btn" onclick="applyFilter(this, 'veg')">🟢 Veg Only</button>
                <button class="filter-btn" onclick="applyFilter(this, 'nonveg')">🔺 Non-Veg Only</button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty menuList}">
                <div class="menu-grid">
                    <c:forEach var="item" items="${menuList}">
                        <div class="menu-item-card glass-panel" data-type="${item.veg ? 'veg' : 'nonveg'}">
                            <!-- Left Side: Details -->
                            <div class="item-details">
                                <div class="item-text-group">
                                    <span class="item-category">${item.category}</span>
                                    <div class="item-name-row">
                                        <c:choose>
                                            <c:when test="${item.veg}">
                                                <span class="veg-icon" title="Vegetarian"></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="nonveg-icon" title="Non-Vegetarian"></span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="item-name">${item.itemName}</span>
                                    </div>
                                    <div class="item-desc">${item.description}</div>
                                </div>
                                <div class="item-price">Rs. ${item.price}</div>
                            </div>
                            
                            <!-- Right Side: Image and Add Action -->
                            <div class="item-right-panel">
                                <div class="item-img">
                                    <c:choose>
                                        <c:when test="${not empty item.imagePath}">
                                            <img src="${fn:startsWith(item.imagePath, 'http') ? item.imagePath : pageContext.request.contextPath.concat('/images/').concat(item.imagePath)}" alt="${item.itemName}">
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${item.category == 'Beverages'}"><i class="fa-solid fa-glass-water" style="color: #38bdf8; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Pizza'}"><i class="fa-solid fa-pizza-slice" style="color: #ff5f2e; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Desserts' || item.category == 'Waffles' || item.category == 'Cheesecake' || item.category == 'Pastries' || item.category == 'Sundaes'}"><i class="fa-solid fa-cake-candles" style="color: #ff2a5f; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Sushi'}"><i class="fa-solid fa-fish" style="color: #06b6d4; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Burgers'}"><i class="fa-solid fa-burger" style="color: #f97316; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Sides'}"><i class="fa-solid fa-bowl-food" style="color: #fb923c; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Main Course'}"><i class="fa-solid fa-plate-wheat" style="color: #eab308; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Biryani'}"><i class="fa-solid fa-bowl-rice" style="color: #f59e0b; font-size: 2rem;"></i></c:when>
                                                <c:when test="${item.category == 'Kebabs'}"><i class="fa-solid fa-drumstick-bite" style="color: #ef4444; font-size: 2rem;"></i></c:when>
                                                <c:otherwise><i class="fa-solid fa-utensils" style="color: var(--text-muted); font-size: 2rem;"></i></c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="item-action">
                                    <c:set var="inCartQty" value="${cartQtyMap[item.menuId]}" />
                                    <c:choose>
                                        <c:when test="${not empty inCartQty && inCartQty > 0}">
                                            <!-- Item is in cart: show - qty + stepper -->
                                            <div class="cart-stepper">
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="display:contents;">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="menuId" value="${item.menuId}">
                                                    <input type="hidden" name="restId" value="${restaurant.restId}">
                                                    <input type="hidden" name="quantity" value="-1">
                                                    <input type="hidden" name="redirectUrl" value="menu?restId=${restaurant.restId}">
                                                    <button type="submit" title="Decrease">−</button>
                                                </form>
                                                <span class="qty-display">${inCartQty}</span>
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="display:contents;">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="menuId" value="${item.menuId}">
                                                    <input type="hidden" name="restId" value="${restaurant.restId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <input type="hidden" name="redirectUrl" value="menu?restId=${restaurant.restId}">
                                                    <button type="submit" title="Increase">+</button>
                                                </form>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Item not in cart: show Add button -->
                                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="menuId" value="${item.menuId}">
                                                <input type="hidden" name="restId" value="${restaurant.restId}">
                                                <input type="hidden" name="quantity" value="1">
                                                <input type="hidden" name="redirectUrl" value="menu?restId=${restaurant.restId}">
                                                <button type="submit" class="btn btn-primary add-btn-fresh">
                                                    Add <i class="fa-solid fa-plus"></i>
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="glass-panel" style="text-align: center; padding: 4rem; margin-top: 2rem;">
                    <i class="fa-solid fa-mug-hot" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                    <h3>Menu Empty</h3>
                    <p style="color: var(--text-muted); margin-top: 0.5rem;">This restaurant hasn't added any dishes yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
        <!-- Reviews Section -->
        <div class="reviews-section">
            <h3 style="font-size: 1.6rem; font-weight: 700; margin-bottom: 1.5rem;"><i class="fa-solid fa-comments" style="color: var(--primary);"></i> Customer Reviews</h3>
            
            <div class="reviews-grid">
                <!-- Left Column: Existing Reviews -->
                <div>
                    <c:choose>
                        <c:when test="${not empty reviewList}">
                            <c:forEach var="rev" items="${reviewList}">
                                <div class="review-card glass-panel">
                                    <div class="review-meta">
                                        <span style="font-weight: 700; color: var(--text-main);"><i class="fa-solid fa-circle-user"></i> ${rev.userName}</span>
                                        <span>${rev.createdDate}</span>
                                    </div>
                                    <div class="rating-select-group" style="font-size: 0.9rem; margin-bottom: 0.25rem;">
                                        <c:forEach var="i" begin="1" end="5">
                                            <c:choose>
                                                <c:when test="${i <= rev.rating}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-regular fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <div class="review-comment">
                                        ${rev.comment}
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="glass-panel" style="text-align: center; padding: 3rem 1.5rem; color: var(--text-muted);">
                                <i class="fa-regular fa-comment-dots" style="font-size: 2.5rem; margin-bottom: 1rem;"></i>
                                <p>No reviews yet. Be the first to review this restaurant!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Right Column: Add Review Form -->
                <div>
                    <c:choose>
                        <c:when test="${not empty loggedUser}">
                            <div class="review-form-card glass-panel">
                                <h4 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 1.2rem; border-bottom: 1px solid var(--border-color); padding-bottom: 0.5rem;">Add a Review</h4>
                                <form action="${pageContext.request.contextPath}/add-review" method="POST">
                                    <input type="hidden" name="restId" value="${restaurant.restId}">
                                    
                                    <div class="form-group" style="display: flex; flex-direction: column; gap: 0.4rem;">
                                        <label style="font-size: 0.9rem; font-weight: 500;">Rating</label>
                                        <div class="rating-stars" style="display: flex; gap: 0.5rem; font-size: 1.8rem; color: var(--text-muted); cursor: pointer; margin-bottom: 0.25rem;">
                                            <i class="fa-solid fa-star star-btn" data-value="1"></i>
                                            <i class="fa-solid fa-star star-btn" data-value="2"></i>
                                            <i class="fa-solid fa-star star-btn" data-value="3"></i>
                                            <i class="fa-solid fa-star star-btn" data-value="4"></i>
                                            <i class="fa-solid fa-star star-btn" data-value="5"></i>
                                        </div>
                                        <input type="hidden" id="rating-input" name="rating" value="5" />
                                    </div>
                                    
                                    <div class="form-group" style="margin-top: 1rem; display: flex; flex-direction: column; gap: 0.4rem;">
                                        <label for="comment" style="font-size: 0.9rem; font-weight: 500;">Comment (Optional)</label>
                                        <textarea id="comment" name="comment" class="form-control" rows="4" placeholder="How was the food and service?" style="background: var(--bg-dark); color: var(--text-main); border: 1px solid var(--border-color); padding: 0.8rem; border-radius: var(--radius-sm); font-family: inherit; resize: vertical;"></textarea>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1.5rem; padding: 0.75rem;">
                                        Submit Review <i class="fa-solid fa-paper-plane"></i>
                                    </button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="glass-panel" style="padding: 2rem; text-align: center; color: var(--text-muted);">
                                <i class="fa-solid fa-lock" style="font-size: 1.8rem; margin-bottom: 1rem;"></i>
                                <p>Please <a href="${pageContext.request.contextPath}/login.jsp" style="color: var(--primary); font-weight: 600;">log in</a> to share your review.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <!-- Filter & Rating JS Script -->
    <script>
        function applyFilter(button, type) {
            // Remove active class from all filter buttons
            const buttons = document.querySelectorAll('.filter-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Add active class to clicked button
            button.classList.add('active');
            
            // Show/Hide menu item cards based on data-type attribute
            const cards = document.querySelectorAll('.menu-item-card');
            cards.forEach(card => {
                const cardType = card.getAttribute('data-type');
                if (type === 'all' || cardType === type) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Interactive 5-Star Rating System
        document.addEventListener("DOMContentLoaded", function() {
            const stars = document.querySelectorAll(".star-btn");
            const ratingInput = document.getElementById("rating-input");
            
            if (stars.length > 0 && ratingInput) {
                // Set default to 5 stars golden on load
                highlightStars(ratingInput.value);
                
                stars.forEach(star => {
                    star.addEventListener("click", function() {
                        const value = this.getAttribute("data-value");
                        ratingInput.value = value;
                        highlightStars(value);
                    });
                    
                    star.addEventListener("mouseover", function() {
                        const value = this.getAttribute("data-value");
                        highlightStars(value);
                    });
                    
                    star.addEventListener("mouseout", function() {
                        highlightStars(ratingInput.value);
                    });
                });
            }
            
            function highlightStars(val) {
                stars.forEach(star => {
                    const starValue = star.getAttribute("data-value");
                    if (parseInt(starValue) <= parseInt(val)) {
                        star.style.color = "#fbbf24"; // golden
                    } else {
                        star.style.color = "var(--text-muted)"; // grey/muted
                    }
                });
            }

    </script>
</body>
</html>
