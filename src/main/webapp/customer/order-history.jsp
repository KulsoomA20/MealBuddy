<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .orders-container {
            max-width: 900px;
            margin: 6rem auto 4rem auto;
            padding: 0 2rem;
        }
        .orders-header {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }
        .orders-header h2 {
            font-size: 1.8rem;
            font-weight: 800;
        }
        .order-card {
            padding: 1.5rem 2rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.5rem;
        }
        .order-info {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }
        .order-id {
            font-weight: 700;
            font-size: 1.1rem;
        }
        .order-rest {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-main);
        }
        .order-date {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        .order-price {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-main);
        }
        .order-status {
            font-size: 0.8rem;
            font-weight: 700;
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        /* Status Badges */
        .status-placed { background: rgba(59, 130, 246, 0.1); color: #60a5fa; border: 1px solid rgba(59, 130, 246, 0.2); }
        .status-confirmed { background: rgba(139, 92, 246, 0.1); color: #a78bfa; border: 1px solid rgba(139, 92, 246, 0.2); }
        .status-preparing { background: rgba(234, 179, 8, 0.1); color: #facc15; border: 1px solid rgba(234, 179, 8, 0.2); }
        .status-out_for_delivery { background: rgba(249, 115, 22, 0.1); color: #f97316; border: 1px solid rgba(249, 115, 22, 0.2); }
        .status-delivered { background: rgba(16, 185, 129, 0.1); color: #34d399; border: 1px solid rgba(16, 185, 129, 0.2); }
        .status-cancelled { background: rgba(239, 68, 68, 0.1); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.2); }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <main class="orders-container">
        <div class="orders-header">
            <h2>Order History</h2>
        </div>

        <c:choose>
            <c:when test="${not empty orderDetails}">
                <c:forEach var="detail" items="${orderDetails}">
                    <div class="order-card glass-panel">
                        <div class="order-info">
                            <div class="order-id">Order #${detail.order.orderId}</div>
                            <div class="order-rest"><i class="fa-solid fa-utensils"></i> ${detail.restaurant.restName}</div>
                            <div class="order-date">
                                Placed on: ${detail.order.orderDate}
                            </div>
                            <div style="font-size: 0.9rem; color: var(--text-muted); margin-top: 0.25rem;">
                                Payment: <strong>${detail.order.paymentMethod}</strong>
                            </div>
                        </div>

                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 0.75rem;">
                            <div class="order-price">Rs. ${detail.order.totalAmount}</div>
                            
                            <!-- Display Status Badge dynamically based on string -->
                            <c:set var="statusClass" value="status-placed" />
                            <c:choose>
                                <c:when test="${detail.order.status == 'Confirmed'}"><c:set var="statusClass" value="status-confirmed" /></c:when>
                                <c:when test="${detail.order.status == 'Preparing'}"><c:set var="statusClass" value="status-preparing" /></c:when>
                                <c:when test="${detail.order.status == 'Out_for_Delivery'}"><c:set var="statusClass" value="status-out_for_delivery" /></c:when>
                                <c:when test="${detail.order.status == 'Delivered'}"><c:set var="statusClass" value="status-delivered" /></c:when>
                                <c:when test="${detail.order.status == 'Cancelled'}"><c:set var="statusClass" value="status-cancelled" /></c:when>
                            </c:choose>
                             <span class="order-status ${statusClass}">${detail.order.status}</span>
                             <c:if test="${detail.order.status != 'Delivered' && detail.order.status != 'Cancelled'}">
                                 <a href="${pageContext.request.contextPath}/track-order?orderId=${detail.order.orderId}" class="btn btn-secondary" style="padding: 0.35rem 0.75rem; font-size: 0.75rem; border:1px solid var(--border-color); margin-top: 0.5rem; display:inline-flex; align-items:center; gap:0.25rem;">
                                     Track Live <i class="fa-solid fa-location-crosshairs"></i>
                                 </a>
                             </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="glass-panel" style="text-align: center; padding: 4rem;">
                    <i class="fa-solid fa-receipt" style="font-size: 3.5rem; color: var(--text-muted); margin-bottom: 1.5rem;"></i>
                    <h3>No Orders Found</h3>
                    <p style="color: var(--text-muted); margin-top: 0.5rem; margin-bottom: 2rem;">You haven't placed any orders yet.</p>
                    <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary">Order Now</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
