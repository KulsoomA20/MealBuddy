<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .checkout-container {
            max-width: 1200px;
            margin: 6rem auto 4rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }
        @media (max-width: 968px) {
            .checkout-container {
                grid-template-columns: 1fr;
            }
        }
        .checkout-card {
            padding: 2rem;
            border-radius: var(--radius-md);
            margin-bottom: 2rem;
        }
        .checkout-title {
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
        }
        .address-box {
            display: flex;
            align-items: flex-start;
            padding: 1.2rem;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            margin-bottom: 1rem;
            cursor: pointer;
            transition: var(--transition);
        }
        .address-box:hover {
            border-color: var(--primary);
            background: rgba(255, 95, 46, 0.03);
        }
        .address-box input[type="radio"] {
            margin-top: 0.25rem;
            margin-right: 1rem;
            accent-color: var(--primary);
        }
        .address-details {
            font-size: 0.95rem;
        }
        .address-label {
            font-weight: 700;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .address-label span {
            background: rgba(255, 255, 255, 0.08);
            font-size: 0.7rem;
            padding: 0.1rem 0.5rem;
            border-radius: 4px;
        }
        .payment-option {
            display: flex;
            gap: 1.5rem;
            margin-top: 1rem;
        }
        .payment-box {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 1.2rem;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: var(--transition);
            font-weight: 600;
        }
        .payment-box input {
            display: none;
        }
        .payment-box:hover, .payment-box.active {
            border-color: var(--primary);
            color: var(--primary);
            background: rgba(255, 95, 46, 0.05);
        }
        .checkout-items-summary {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="checkout-container">
        <!-- Delivery and Payment Forms -->
        <div>
            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="POST">
                <!-- 1. Select Delivery Address -->
                <div class="checkout-card glass-panel">
                    <div class="checkout-title">Select Delivery Address</div>
                    
                    <c:choose>
                        <c:when test="${not empty addressList}">
                            <c:forEach var="addr" items="${addressList}">
                                <label class="address-box">
                                    <input type="radio" name="addressId" value="${addr.addressId}" data-city="${addr.city}" data-pincode="${addr.pincode}" ${addr.isDefault() ? 'checked' : ''} required onchange="calculateDeliveryFee()">
                                    <span class="address-details">
                                        <span class="address-label">
                                            ${addr.label}
                                            <c:if test="${addr.isDefault()}"><span>Default</span></c:if>
                                        </span>
                                        ${addr.street}, ${addr.city}, ${addr.state} - ${addr.pincode}
                                    </span>
                                </label>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 2rem; color: var(--text-muted);">
                                <i class="fa-solid fa-map-location-dot" style="font-size: 2rem; margin-bottom: 1rem;"></i>
                                <p>No saved addresses found. Please add a delivery address below.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 2. Select Payment Method -->
                <div class="checkout-card glass-panel">
                    <div class="checkout-title">Payment Method</div>
                    <div class="payment-option">
                        <label class="payment-box active" id="onlinePay">
                            <input type="radio" name="paymentMethod" value="Online" checked onclick="togglePayment('onlinePay')">
                            <i class="fa-solid fa-credit-card"></i> Pay Online
                        </label>
                        <label class="payment-box" id="codPay">
                            <input type="radio" name="paymentMethod" value="COD" onclick="togglePayment('codPay')">
                            <i class="fa-solid fa-hand-holding-dollar"></i> Cash on Delivery (COD)
                        </label>
                    </div>
                </div>
            </form>

            <!-- 3. Add New Address Form (UX details - redirect back to checkout) -->
            <div class="checkout-card glass-panel">
                <div class="checkout-title">Add New Address</div>
                <form action="${pageContext.request.contextPath}/address" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="redirectUrl" value="checkout"> <!-- Redirects back to checkout page -->
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                        <div class="form-group">
                            <label for="label">Address Type</label>
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

                    <button type="submit" class="btn btn-secondary" style="padding: 0.75rem 1.5rem;">
                        Save & Use Address
                    </button>
                </form>
            </div>
        </div>

        <!-- Order Summary Side Card -->
        <div>
            <div class="checkout-card glass-panel" style="position: sticky; top: 6rem;">
                <div class="checkout-title">Review Items</div>
                
                <div class="checkout-items-summary" style="margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); padding-bottom: 1.5rem;">
                    <c:forEach var="item" items="${checkoutItems}">
                        <div class="summary-item">
                            <span>${item.menu.itemName} x ${item.cart.quantity}</span>
                            <span>Rs. ${item.subtotal}</span>
                        </div>
                    </c:forEach>
                </div>

                <div class="checkout-items-summary" style="margin-bottom: 2rem;">
                    <div class="summary-item" style="color: var(--text-main); font-weight: 500;">
                        <span>Subtotal</span>
                        <span>Rs. ${totalAmount}</span>
                    </div>
                    <div class="summary-item" style="font-weight: 500;">
                        <span>Delivery Fee</span>
                        <span id="summaryDeliveryFee">FREE</span>
                    </div>
                    <div class="summary-item" style="color: var(--text-main); font-size: 1.2rem; font-weight: 800;">
                        <span>Grand Total</span>
                        <span id="summaryGrandTotal">Rs. ${totalAmount}</span>
                    </div>
                </div>

                <button type="submit" form="checkoutForm" class="btn btn-primary" style="width: 100%; padding: 1rem; font-size: 1rem;">
                    Place Order <i class="fa-solid fa-square-check"></i>
                </button>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <script>
        // Array of checkout items to calculate delivery fees correctly when split by restaurant
        const cartItems = [
            <c:forEach var="item" items="${checkoutItems}" varStatus="status">
                { restId: ${item.menu.restId}, subtotal: ${item.subtotal}, deliveryTime: ${not empty item.restaurant ? item.restaurant.deliveryTime : 30} }${not status.last ? ',' : ''}
            </c:forEach>
        ];
        const subtotal = ${totalAmount};

        function togglePayment(activeId) {
            document.getElementById('onlinePay').classList.remove('active');
            document.getElementById('codPay').classList.remove('active');
            document.getElementById(activeId).classList.add('active');
        }

        function calculateDeliveryFee() {
            // Group subtotals and deliveryTime by restaurant
            const restTotals = {};
            const restDeliveryTimes = {};
            cartItems.forEach(item => {
                restTotals[item.restId] = (restTotals[item.restId] || 0) + item.subtotal;
                restDeliveryTimes[item.restId] = item.deliveryTime;
            });

            let totalDeliveryFee = 0;
            for (const restId in restTotals) {
                const restSubtotal = restTotals[restId];
                if (restSubtotal < 699.0) {
                    const deliveryTime = restDeliveryTimes[restId] || 30;
                    let fee = 50.0; // More than 25 mins: 50 Rs.
                    if (deliveryTime <= 15) {
                        fee = 0.0; // Till 15 mins: FREE
                    } else if (deliveryTime <= 25) {
                        fee = 40.0; // Till 25 mins: 40 Rs.
                    }
                    totalDeliveryFee += fee;
                }
            }

            // Update UI
            const deliveryFeeSpan = document.getElementById('summaryDeliveryFee');
            const grandTotalSpan = document.getElementById('summaryGrandTotal');

            if (totalDeliveryFee === 0) {
                deliveryFeeSpan.textContent = "FREE";
                deliveryFeeSpan.style.color = "var(--accent)";
            } else {
                deliveryFeeSpan.textContent = "Rs. " + totalDeliveryFee.toFixed(2);
                deliveryFeeSpan.style.color = "var(--text-main)";
            }

            const grandTotal = subtotal + totalDeliveryFee;
            grandTotalSpan.textContent = "Rs. " + grandTotal.toFixed(2);
        }

        // Run initially on load
        window.addEventListener('DOMContentLoaded', (event) => {
            calculateDeliveryFee();
        });
    </script>
</body>
</html>
