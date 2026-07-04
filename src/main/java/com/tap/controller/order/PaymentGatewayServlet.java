package com.tap.controller.order;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.PaymentDAOimpl;
import com.tap.model.Payment;

@WebServlet("/payment-gateway")
public class PaymentGatewayServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAOimpl paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAOimpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIds = request.getParameter("orderIds");
        String amountStr = request.getParameter("amount");

        if (orderIds == null || amountStr == null) {
            response.sendRedirect("restaurants");
            return;
        }

        // Dynamically resolve base URL from request headers (works for Localhost, Ngrok, and Railway domains)
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();

        // Handle reverse proxy headers from hosting platforms like Railway/Ngrok
        String protoHeader = request.getHeader("X-Forwarded-Proto");
        if (protoHeader != null) {
            scheme = protoHeader;
        }
        String hostHeader = request.getHeader("X-Forwarded-Host");
        if (hostHeader != null) {
            serverName = hostHeader;
            // Standard port mapping for proxy
            serverPort = scheme.equalsIgnoreCase("https") ? 443 : 80;
        }

        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(serverName);

        if ((scheme.equalsIgnoreCase("http") && serverPort != 80) || 
            (scheme.equalsIgnoreCase("https") && serverPort != 443)) {
            baseUrl.append(":").append(serverPort);
        }

        // Mobile checkout URL
        String mobilePayUrl = baseUrl.toString() + request.getContextPath() + "/mobile-pay?orderIds=" + orderIds + "&amount=" + amountStr;
        String qrCodeApiUrl = "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=" + URLEncoder.encode(mobilePayUrl, "UTF-8");

        request.setAttribute("orderIds", orderIds);
        request.setAttribute("amount", amountStr);
        request.setAttribute("localIp", serverName);
        request.setAttribute("mobilePayUrl", mobilePayUrl);
        request.setAttribute("qrCodeApiUrl", qrCodeApiUrl);

        request.getRequestDispatcher("customer/payment-gateway.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIds = request.getParameter("orderIds");
        String action = request.getParameter("action"); // "card" or "upi"

        if (orderIds != null && action != null) {
            // Update payment status to Success for all orders
            String[] ids = orderIds.split(",");
            for (String id : ids) {
                try {
                    int orderId = Integer.parseInt(id.trim());
                    Payment payment = paymentDAO.getPaymentByOrder(orderId);
                    if (payment != null) {
                        paymentDAO.updatePaymentStatus(payment.getPaymentId(), "Success");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("customer/order-success.jsp?orderId=" + orderIds);
        } else {
            response.sendRedirect("restaurants");
        }
    }
}
