package com.tap.controller.order;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.PaymentDAOimpl;
import com.tap.model.Payment;

@WebServlet("/mobile-pay")
public class MobilePayServlet extends HttpServlet {
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
            response.getWriter().println("Invalid Payment Parameters");
            return;
        }

        request.setAttribute("orderIds", orderIds);
        request.setAttribute("amount", amountStr);

        request.getRequestDispatcher("customer/mobile-pay.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIds = request.getParameter("orderIds");

        if (orderIds != null) {
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
            // Forward to dynamic mobile success screen
            request.setAttribute("amount", request.getParameter("amount"));
            request.getRequestDispatcher("customer/mobile-success.jsp").forward(request, response);
        } else {
            response.getWriter().println("Payment Session Expired");
        }
    }
}
