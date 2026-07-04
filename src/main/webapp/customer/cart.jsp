<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <!-- Cart View -->
    <main class="cart-container ${empty cartDetails ? 'cart-empty' : ''}">
        <!-- Cart Items List -->
        <div>
            <div class="cart-header">
                <h2>Your Food Cart</h2>
                <c:if test="${not empty cartDetails}">
                    <form action="${pageContext.request.contextPath}/cart" method="POST">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.85rem; color: #ef4444; border-color: rgba(239, 68, 68, 0.2);">
                            <i class="fa-solid fa-trash-can"></i> Clear Cart
                        </button>
                    </form>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${not empty cartDetails}">
                    <c:forEach var="detail" items="${cartDetails}">
                        <div class="cart-item glass-panel">
                            <div class="cart-item-image" style="width: 80px; height: 80px; border-radius: var(--radius-sm); overflow: hidden; display: flex; align-items: center; justify-content: center; background: rgba(255, 255, 255, 0.02); flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty detail.menu.imagePath}">
                                        <img src="${fn:startsWith(detail.menu.imagePath, 'http') ? detail.menu.imagePath : pageContext.request.contextPath.concat('/images/').concat(detail.menu.imagePath)}" alt="${detail.menu.itemName}" style="width: 100%; height: 100%; object-fit: contain;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-solid fa-utensils" style="color: var(--text-muted); font-size: 1.5rem;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="item-info">
                                <div class="item-name">${detail.menu.itemName}</div>
                                <div class="item-price">Rs. ${detail.menu.price} each</div>
                            </div>
                            <div class="item-qty-control">
                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="display: flex; align-items: center;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="cartId" value="${detail.cart.cartId}">
                                    
                                    <button type="submit" name="quantity" value="${detail.cart.quantity - 1}" class="qty-btn">-</button>
                                    <label for="disp-${detail.cart.cartId}" style="display:none;">Quantity Display</label>
                                    <input type="text" id="disp-${detail.cart.cartId}" class="qty-disp" value="${detail.cart.quantity}" readonly>
                                    <button type="submit" name="quantity" value="${detail.cart.quantity + 1}" class="qty-btn">+</button>
                                </form>
                            </div>
                            <div class="item-subtotal">Rs. ${detail.subtotal}</div>
                            
                            <!-- Remove Item -->
                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="cartId" value="${detail.cart.cartId}">
                                <button type="submit" class="remove-btn" title="Remove Item">
                                    <i class="fa-solid fa-xmark"></i>
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="glass-panel" style="text-align: center; padding: 4rem; margin-top: 2rem;">
                        <i class="fa-solid fa-cart-shopping" style="font-size: 3.5rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                        <h3>Your Cart is Empty</h3>
                        <p style="color: var(--text-muted); margin-top: 0.5rem; margin-bottom: 2rem;">Add items from restaurants to satisfy your hunger.</p>
                        <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary">Browse Restaurants</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Summary & Checkout Details -->
        <c:if test="${not empty cartDetails}">
            <div class="summary-card glass-panel">
                <div class="summary-title">Order Summary</div>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>Rs. ${grandTotal}</span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <c:choose>
                        <c:when test="${deliveryFee == 0}">
                            <span style="color: var(--accent);">FREE</span>
                        </c:when>
                        <c:otherwise>
                            <span>Rs. ${deliveryFee}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="summary-row summary-total">
                    <span>Total Amount</span>
                    <span style="background: var(--primary-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Rs. ${grandTotal + deliveryFee}</span>
                </div>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary" style="width: 100%; padding: 0.9rem; text-align: center; margin-top: 1rem;">
                    Proceed to Checkout <i class="fa-solid fa-arrow-right"></i>
                </a>
                <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-secondary" style="width: 100%; padding: 0.9rem; text-align: center; margin-top: 0.5rem;">
                    <i class="fa-solid fa-arrow-left"></i> Continue Shopping
                </a>
            </div>
        </c:if>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
