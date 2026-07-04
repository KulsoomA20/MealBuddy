<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Restaurants - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .restaurant-section {
            max-width: 95%;
            margin: 6rem auto 4rem auto;
            padding: 0 2rem;
        }
        .search-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            gap: 2rem;
            flex-wrap: wrap;
        }
        .page-title h2 {
            font-size: 2rem;
            font-weight: 700;
        }
        .page-title p {
            color: var(--text-muted);
            font-size: 0.95rem;
        }
        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
        }
        .rest-card {
            border-radius: var(--radius-md);
            overflow: hidden;
            transition: transform 0.4s cubic-bezier(0.165, 0.84, 0.44, 1), box-shadow 0.4s ease, border-color 0.4s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .rest-card:hover {
            transform: translateY(-12px) scale(1.03);
            border-color: rgba(255, 95, 46, 0.4);
            box-shadow: 0 20px 40px rgba(255, 95, 46, 0.2);
        }
        .rest-image-container {
            height: 180px;
            width: 100%;
            background: linear-gradient(135deg, rgba(255, 95, 46, 0.1) 0%, rgba(255, 42, 95, 0.1) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
            position: relative;
        }
        .rest-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: var(--primary-grad);
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(255, 95, 46, 0.2);
        }
        .rest-info {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            flex-grow: 1;
        }
        .rest-name {
            font-size: 1.3rem;
            font-weight: 700;
            line-height: 1.25;
            height: 3.2rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .rest-cuisine {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        .rest-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--border-color);
            padding-top: 1rem;
            margin-top: auto;
            font-size: 0.9rem;
        }
        .rest-rating {
            display: flex;
            align-items: center;
            gap: 0.3rem;
            font-weight: 600;
            color: #fbbf24;
        }
        .rest-time {
            display: flex;
            align-items: center;
            gap: 0.3rem;
            color: var(--text-muted);
        }
        .filter-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }
        .filter-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            padding: 0.5rem 1.2rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-grad);
            border-color: transparent;
            box-shadow: 0 4px 10px rgba(255, 95, 46, 0.2);
        }
        /* Inline Restaurant type badge */
        .type-badge-inline {
            padding: 0.25rem 0.6rem;
            border-radius: 6px;
            font-size: 0.7rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            white-space: nowrap;
            flex-shrink: 0;
        }
        .type-badge-inline.veg {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.3);
        }
        .type-badge-inline.nonveg {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border-color: rgba(239, 68, 68, 0.3);
        }
        .type-badge-inline.both {
            background: rgba(234, 179, 8, 0.15);
            color: #facc15;
            border-color: rgba(234, 179, 8, 0.3);
        }
        .veg-dot {
            width: 8px;
            height: 8px;
            background: #10b981;
            border-radius: 50%;
            display: inline-block;
        }
        .nonveg-triangle {
            width: 0;
            height: 0;
            border-left: 4.5px solid transparent;
            border-right: 4.5px solid transparent;
            border-bottom: 7.5px solid #ef4444;
            display: inline-block;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <!-- Restaurants Browse Page -->
    <main class="restaurant-section">
        <div class="search-row">
            <div class="page-title">
                <h2>Popular Restaurants</h2>
                <p>Order from your favorite kitchen in town</p>
            </div>
            <div class="filter-buttons">
                <button class="filter-btn" id="filter-veg" onclick="toggleFilter('pureVeg')">🟢 Pure Veg</button>
                <button class="filter-btn" id="filter-dessert" onclick="toggleFilter('desserts')">🍰 Desserts</button>
                <button class="filter-btn" id="filter-fast" onclick="toggleFilter('fastDelivery')">⚡ Fast Delivery</button>
                <button class="filter-btn" id="filter-rating" onclick="toggleFilter('highRating')">⭐ Rating 4.5+</button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty restaurantList}">
                <div class="restaurant-grid">
                    <c:forEach var="rest" items="${restaurantList}">
                        <a href="${pageContext.request.contextPath}/menu?restId=${rest.restId}" class="rest-card glass-panel" data-type="${rest.restType}" data-delivery="${rest.deliveryTime}" data-rating="${rest.rating}" data-cuisine="${rest.cuisineType}">
                            <div class="rest-image-container" style="padding: 0; overflow: hidden; display: flex; align-items: center; justify-content: center; background: rgba(255, 255, 255, 0.02);">
                                <c:choose>
                                    <c:when test="${not empty rest.imagePath}">
                                        <img src="${fn:startsWith(rest.imagePath, 'http') ? rest.imagePath : pageContext.request.contextPath.concat('/images/').concat(rest.imagePath)}" alt="${rest.restName}" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${fn:contains(fn:toLowerCase(rest.cuisineType), 'chinese') || fn:contains(fn:toLowerCase(rest.cuisineType), 'sichuan') || fn:contains(fn:toLowerCase(rest.cuisineType), 'asian')}">
                                                <i class="fa-solid fa-bowl-food" style="color: #fb923c;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-utensils" style="color: var(--text-muted); opacity: 0.5;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="rest-info">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 0.5rem; width: 100%; min-height: 3.2rem;">
                                    <div class="rest-name">${rest.restName}</div>
                                    <c:choose>
                                        <c:when test="${rest.restType == 'Veg'}">
                                            <span class="type-badge-inline veg"><span class="veg-dot"></span> Veg</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="type-badge-inline both"><i class="fa-solid fa-circle-half-stroke"></i> Veg & Non-Veg</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="rest-cuisine-type" style="color: var(--primary); font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-top: 0.25rem;">
                                    <i class="fa-solid fa-utensils"></i> ${rest.cuisineType}
                                </div>
                                <div class="rest-cuisine" style="margin-top: 0.25rem;"><i class="fa-solid fa-location-dot"></i> ${rest.address}</div>
                                <div class="rest-meta">
                                    <div class="rest-rating">
                                        <i class="fa-solid fa-star"></i> ${rest.rating}
                                    </div>
                                    <div class="rest-time">
                                        <i class="fa-regular fa-clock"></i> ${rest.deliveryTime} mins
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="glass-panel" style="text-align: center; padding: 4rem; margin-top: 2rem;">
                    <i class="fa-solid fa-store-slash" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                    <h3>No Restaurants Found</h3>
                    <p style="color: var(--text-muted); margin-top: 0.5rem;">Please check back later, we are adding new kitchens!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <!-- Filter JS Script -->
    <script>
        let activeFilters = {
            pureVeg: false,
            desserts: false,
            fastDelivery: false,
            highRating: false
        };

        function toggleFilter(filterName) {
            
            activeFilters[filterName] = !activeFilters[filterName];         
          
            let btnId = '';
            if (filterName === 'pureVeg') btnId = 'filter-veg';
            else if (filterName === 'desserts') btnId = 'filter-dessert';
            else if (filterName === 'fastDelivery') btnId = 'filter-fast';
            else if (filterName === 'highRating') btnId = 'filter-rating';
            
            document.getElementById(btnId).classList.toggle('active');
            
            // Show/Hide restaurant 
            const cards = document.querySelectorAll('.rest-card');
            cards.forEach(card => {
                const cardType = card.getAttribute('data-type');
                const cardCuisine = card.getAttribute('data-cuisine').toLowerCase();
                const cardDelivery = parseInt(card.getAttribute('data-delivery'), 10);
                const cardRating = parseFloat(card.getAttribute('data-rating'));
                
                let matchesVeg = !activeFilters.pureVeg || (cardType === 'Veg');
                let matchesDessert = !activeFilters.desserts || 
                    (cardCuisine.includes('dessert') || cardCuisine.includes('ice cream') || cardCuisine.includes('bakery') || cardCuisine.includes('gelato') || cardCuisine.includes('cake'));
                let matchesDelivery = !activeFilters.fastDelivery || (cardDelivery <= 25);
                let matchesRating = !activeFilters.highRating || (cardRating >= 4.5);
                
                if (matchesVeg && matchesDessert && matchesDelivery && matchesRating) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

    </script>
</body>
</html>
