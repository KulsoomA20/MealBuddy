<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - MealBuddy</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap">
    <style>
        :root {
            --bg-dark: #1d0b0d; /* Black Olive */
            --card-dark: #1d0b0d; /* Black Olive */
            --primary: #f7ea48; /* Lemon Zest */
            --accent: #fcf9f0; /* Warm Cream */
            --text-main: #fcf9f0; /* Warm Cream */
            --text-muted: #dbe2dc; /* Sage Mist */
            --border-color: rgba(219, 226, 220, 0.15);
            --success-color: #34d399; /* Green checkmark for payment success */
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 1rem;
        }
        .success-card {
            width: 100%;
            max-width: 400px;
            background: var(--card-dark);
            border-radius: 0px; /* Limón unsoftened 0px */
            padding: 2.5rem;
            border: 1px solid var(--border-color);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5rem;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: rgba(52, 211, 153, 0.1);
            color: var(--success-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            animation: bounceIn 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        @keyframes bounceIn {
            0% { transform: scale(0.3); opacity: 0; }
            50% { transform: scale(1.05); opacity: 0.8; }
            70% { transform: scale(0.9); opacity: 0.9; }
            100% { transform: scale(1); opacity: 1; }
        }
        .title {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-main);
            text-transform: uppercase;
            letter-spacing: 0.9px;
        }
        .message {
            font-size: 0.95rem;
            color: var(--text-muted);
            line-height: 1.5;
        }
        .transaction-details {
            width: 100%;
            background: rgba(255,255,255,0.01);
            border: 1px solid var(--border-color);
            padding: 1rem;
            border-radius: 1px;
            font-size: 0.85rem;
            text-align: left;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
        }
        .secure-footer {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
    </style>
</head>
<body>

    <div class="success-card">
        <div class="success-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        
        <div class="title">Payment Done!</div>
        
        <div class="message">
            Your transaction was authorized successfully. Please return to your laptop/desktop screen to view order details.
        </div>

        <div class="transaction-details">
            <div class="detail-row">
                <span style="color: var(--text-muted);">Amount Paid</span>
                <span style="font-weight: 700; color: var(--accent);">₹${amount}</span>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-muted);">Status</span>
                <span style="font-weight: 600; color: var(--accent);">Success</span>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-muted);">Reference ID</span>
                <span style="font-family: monospace; color: var(--text-main);">TXN<%= System.currentTimeMillis() %></span>
            </div>
        </div>

        <div class="secure-footer">
            <i class="fa-solid fa-shield-halved" style="color: var(--accent);"></i> Secure Encrypted UPI Receipt
        </div>
    </div>

</body>
</html>
