<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MealBuddy Secure UPI - Mobile Pay</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --bg-dark: #090d16;
            --card-dark: #121824;
            --primary: #ff5f2e;
            --accent: #10b981;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: rgba(255,255,255,0.08);
        }
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
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
        .mobile-card {
            width: 100%;
            max-width: 400px;
            background: var(--card-dark);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        .header {
            text-align: center;
        }
        .logo {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 0.5rem;
        }
        .logo span {
            color: var(--primary);
        }
        .subtitle {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        .payment-summary {
            background: rgba(255,255,255,0.02);
            border: 1px solid var(--border-color);
            padding: 1.25rem;
            border-radius: 12px;
            text-align: center;
        }
        .amount-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }
        .amount {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--accent);
        }
        .order-ids {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 0.5rem;
            border-top: 1px dashed var(--border-color);
            padding-top: 0.5rem;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .form-group label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
        }
        .pin-input {
            width: 100%;
            padding: 1rem;
            font-size: 1.5rem;
            letter-spacing: 0.5rem;
            text-align: center;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            background: rgba(0,0,0,0.2);
            color: #fff;
            outline: none;
            transition: 0.2s;
        }
        .pin-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 10px rgba(255, 95, 46, 0.2);
        }
        .btn-pay {
            background: var(--primary);
            color: #fff;
            border: none;
            padding: 1.1rem;
            font-size: 1.05rem;
            font-weight: 700;
            border-radius: 12px;
            cursor: pointer;
            transition: 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-pay:active {
            transform: scale(0.98);
        }
        .secure-footer {
            text-align: center;
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
        }
    </style>
</head>
<body>

    <div class="mobile-card">
        <div class="header">
            <div class="logo" style="display: flex; align-items: center; justify-content: center; gap: 0.5rem; margin-bottom: 0.25rem;">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="MealBuddy Logo" style="height: 35px; width: auto; object-fit: contain;">
            </div>
            <div class="subtitle">Secure UPI Checkout Portal</div>
        </div>

        <div class="payment-summary">
            <div class="amount-label">Amount to Pay</div>
            <div class="amount">₹${amount}</div>
            <div class="order-ids">Order IDs: ${orderIds}</div>
        </div>

        <form action="${pageContext.request.contextPath}/mobile-pay" method="POST">
            <input type="hidden" name="orderIds" value="${orderIds}">
            <input type="hidden" name="amount" value="${amount}">
            
            <div class="form-group">
                <label for="upiPin">Enter 4 or 6-digit UPI PIN</label>
                <input type="password" id="upiPin" class="pin-input" pattern="[0-9]{4,6}" inputmode="numeric" placeholder="••••" required autocomplete="off">
            </div>

            <button type="submit" class="btn-pay" style="margin-top: 1rem;">
                Proceed & Confirm Payment <i class="fa-solid fa-circle-check"></i>
            </button>
        </form>

        <div class="secure-footer">
            <i class="fa-solid fa-lock" style="color: var(--accent);"></i> Secured by NPCI / Unified Payments Interface
        </div>
    </div>

</body>
</html>
