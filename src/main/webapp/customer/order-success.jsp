<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - BiteDash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .success-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            padding: 6rem 2rem 4rem 2rem;
        }
        .success-card {
            width: 100%;
            max-width: 500px;
            padding: 4rem 3rem;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5rem;
        }
        .success-icon {
            font-size: 4rem;
            color: var(--accent);
            background: rgba(16, 185, 129, 0.1);
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(16, 185, 129, 0.2);
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .success-card h2 {
            font-size: 2rem;
            font-weight: 800;
        }
        .success-card p {
            color: var(--text-muted);
            font-size: 1rem;
            line-height: 1.5;
        }
        .order-id-badge {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-color);
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-sm);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0.5rem 0;
            color: var(--text-main);
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/navbar.jsp" %>

    <!-- Success Screen -->
    <main class="success-wrapper">
        <div class="success-card glass-panel">
            <div class="success-icon">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h2>Order Confirmed!</h2>
            <p>
                Your gourmet feast is being prepared. Our kitchen has accepted your request, and a delivery partner will pick it up shortly.
            </p>
            
            <div style="font-size: 0.9rem; color: var(--text-muted);">
                <%= request.getParameter("orderId") != null && request.getParameter("orderId").contains(",") ? "ORDER IDs" : "ORDER ID" %>
            </div>
            <div class="order-id-badge">
                #<%= request.getParameter("orderId") %>
            </div>
            
            <%
                String orderIdParam = request.getParameter("orderId");
                String trackingId = orderIdParam;
                if (orderIdParam != null && orderIdParam.contains(",")) {
                    trackingId = orderIdParam.split(",")[0].trim();
                }
            %>
 
            <div style="display: flex; gap: 1rem; width: 100%; margin-top: 1.5rem;">
                <a href="${pageContext.request.contextPath}/track-order?orderId=<%= trackingId %>" class="btn btn-primary" style="flex: 1; padding: 0.9rem; text-align: center;">
                    Track Order <i class="fa-solid fa-route"></i>
                </a>
                <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-secondary" style="flex: 1; padding: 0.9rem; text-align: center;">
                    Order More
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <!-- Canvas Confetti Celebration Script -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // First burst
            confetti({
                particleCount: 150,
                spread: 80,
                origin: { y: 0.6 }
            });
            
            // Left burst
            setTimeout(function() {
                confetti({
                    particleCount: 60,
                    angle: 60,
                    spread: 55,
                    origin: { x: 0, y: 0.8 }
                });
            }, 250);

            // Right burst
            setTimeout(function() {
                confetti({
                    particleCount: 60,
                    angle: 120,
                    spread: 55,
                    origin: { x: 1, y: 0.8 }
                });
            }, 400);
        });
    </script>
</body>
</html>
