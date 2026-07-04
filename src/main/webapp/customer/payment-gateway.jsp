<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Payment - MealBuddy</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .payment-container {
            max-width: 1000px;
            margin: 7rem auto 4rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 1.8fr 1.2fr;
            gap: 2rem;
        }
        @media (max-width: 768px) {
            .payment-container {
                grid-template-columns: 1fr;
            }
        }
        .gateway-card {
            padding: 2rem;
            border-radius: var(--radius-md);
            margin-bottom: 2rem;
        }
        .gateway-title {
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.75rem;
        }
        /* Tab Styles */
        .tab-nav {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }
        .tab-btn {
            background: transparent;
            border: none;
            color: var(--text-muted);
            padding: 0.75rem 1.2rem;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            border-radius: var(--radius-sm);
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .tab-btn:hover {
            color: var(--text-main);
            background: rgba(255, 255, 255, 0.03);
        }
        .tab-btn.active {
            color: var(--primary);
            background: rgba(255, 95, 46, 0.08);
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Form inputs */
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
        }
        /* QR Code section */
        .qr-section {
            text-align: center;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }
        .qr-frame {
            background: #ffffff;
            padding: 1rem;
            border-radius: var(--radius-md);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            display: inline-block;
        }
        .qr-frame img {
            display: block;
        }
        .polling-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--accent);
            font-weight: 600;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }
        .polling-indicator i {
            animation: spin 1.5s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        /* Billing summary */
        .summary-box {
            padding: 1.5rem;
            border-radius: var(--radius-sm);
            background: rgba(255,255,255,0.01);
            border: 1px solid var(--border-color);
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }
        .summary-total {
            border-top: 1px solid var(--border-color);
            padding-top: 0.75rem;
            margin-top: 0.75rem;
            font-weight: 800;
            font-size: 1.2rem;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <%@ include file="../includes/navbar.jsp" %>

    <div class="payment-container">
        <!-- Payment Methods Card -->
        <div class="gateway-card glass-panel">
            <div class="gateway-title">
                <i class="fa-solid fa-shield-halved" style="color: var(--accent);"></i> Secure Payment Gateway
            </div>

            <!-- Tab Navigation -->
            <div class="tab-nav">
                <button class="tab-btn active" onclick="switchTab('card')">
                    <i class="fa-solid fa-credit-card"></i> Card
                </button>
                <button class="tab-btn" onclick="switchTab('upi')">
                    <i class="fa-solid fa-mobile-screen-button"></i> UPI
                </button>
                <button class="tab-btn" onclick="switchTab('qr')">
                    <i class="fa-solid fa-qrcode"></i> Scan QR Code
                </button>
            </div>

            <!-- 1. Card Payment Tab -->
            <div id="tab-card" class="tab-content active">
                <form action="${pageContext.request.contextPath}/payment-gateway" method="POST">
                    <input type="hidden" name="orderIds" value="${orderIds}">
                    <input type="hidden" name="action" value="card">
                    
                    <div class="form-group">
                        <label for="cardName">Cardholder Name</label>
                        <input type="text" id="cardName" class="form-control" placeholder="Enter name on card" required>
                    </div>
                    <div class="form-group">
                        <label for="cardNumber">Card Number</label>
                        <input type="text" id="cardNumber" class="form-control" placeholder="1234 5678 1234 5678" pattern="[0-9\s]{13,19}" required>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label for="cardExpiry">Expiry Date</label>
                            <input type="text" id="cardExpiry" class="form-control" placeholder="MM/YY" pattern="(0[1-9]|1[0-2])\/[0-9]{2}" required>
                        </div>
                        <div class="form-group">
                            <label for="cardCvv">CVV</label>
                            <input type="password" id="cardCvv" class="form-control" placeholder="123" pattern="[0-9]{3}" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.9rem; margin-top: 1rem;">
                        Pay Rs. ${amount} Securely <i class="fa-solid fa-lock" style="margin-left: 0.5rem;"></i>
                    </button>
                </form>
            </div>

            <!-- 2. UPI Payment Tab -->
            <div id="tab-upi" class="tab-content">
                <form action="${pageContext.request.contextPath}/payment-gateway" method="POST">
                    <input type="hidden" name="orderIds" value="${orderIds}">
                    <input type="hidden" name="action" value="upi">
                    
                    <div class="form-group">
                        <label for="upiId">UPI ID / VPA</label>
                        <input type="text" id="upiId" class="form-control" placeholder="username@upi" required>
                        <p style="color: var(--text-muted); font-size: 0.75rem; margin-top: 0.5rem;">A payment request will be sent to your UPI client.</p>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.9rem; margin-top: 1rem;">
                        Pay Rs. ${amount} Securely <i class="fa-solid fa-lock" style="margin-left: 0.5rem;"></i>
                    </button>
                </form>
            </div>

            <!-- 3. QR Code Tab -->
            <div id="tab-qr" class="tab-content">
                <div class="qr-section">
                    <p style="font-weight: 700; color: var(--text-main); font-size: 1.05rem;">Scan QR to Pay with Mobile Phone</p>
                    <p style="color: var(--text-muted); font-size: 0.85rem; max-width: 450px;">Scan this QR code with any UPI app (GPay, PhonePe, Paytm) or your phone camera to initiate mobile payment.</p>
                    
                    <div class="qr-frame">
                        <img src="${qrCodeApiUrl}" alt="Scan to Pay QR Code">
                    </div>
                    
                    <div class="polling-indicator">
                        <i class="fa-solid fa-circle-notch"></i> Waiting for mobile payment confirmation...
                    </div>
                    
                    <p style="color: var(--text-muted); font-size: 0.75rem; margin-top: 1rem; border-top: 1px solid var(--border-color); padding-top: 1rem; width: 100%;">
                        Ensure your phone is connected to the same local Wi-Fi router network.
                    </p>
                </div>
            </div>
        </div>

        <!-- Billing Summary Sidebar -->
        <div>
            <div class="gateway-card glass-panel" style="position: sticky; top: 7rem;">
                <div class="gateway-title" style="font-size: 1.25rem;">
                    <i class="fa-solid fa-receipt"></i> Order Summary
                </div>
                <div class="summary-box">
                    <div class="summary-row">
                        <span style="color: var(--text-muted);">Order IDs</span>
                        <span style="font-weight: 700; color: var(--text-main);">${orderIds}</span>
                    </div>
                    <div class="summary-row">
                        <span style="color: var(--text-muted);">Status</span>
                        <span style="font-weight: 600; color: var(--accent);">Awaiting Payment</span>
                    </div>
                    <div class="summary-row summary-total">
                        <span>Total Payable</span>
                        <span style="background: var(--primary-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Rs. ${amount}</span>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 2rem; color: var(--text-muted); font-size: 0.8rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                    <i class="fa-solid fa-lock"></i> 256-bit SSL Encrypted Connection
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <%@ include file="../includes/footer.jsp" %>

    <script>
        function switchTab(tabId) {
            // Remove active classes
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

            // Find current tab button and activate it
            const activeBtn = Array.from(document.querySelectorAll('.tab-btn')).find(btn => btn.getAttribute('onclick').includes(tabId));
            if (activeBtn) activeBtn.classList.add('active');
            
            const activeContent = document.getElementById('tab-' + tabId);
            if (activeContent) activeContent.classList.add('active');
        }

        // Auto-poll payment status in the background immediately
        document.addEventListener("DOMContentLoaded", function() {
            setInterval(function() {
                fetch('${pageContext.request.contextPath}/check-payment-status?orderIds=${orderIds}')
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'SUCCESS') {
                            window.location.href = '${pageContext.request.contextPath}/customer/order-success.jsp?orderId=${orderIds}';
                        }
                    })
                    .catch(error => console.error("Error polling payment status:", error));
            }, 2000);
        });
    </script>
</body>
</html>
