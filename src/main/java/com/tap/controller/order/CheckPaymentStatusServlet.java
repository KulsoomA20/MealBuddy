package com.tap.controller.order;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.DAOimpl.PaymentDAOimpl;
import com.tap.model.Payment;

@WebServlet("/check-payment-status")
public class CheckPaymentStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAOimpl paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAOimpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String orderIds = request.getParameter("orderIds");
        if (orderIds == null) {
            response.getWriter().write("{\"status\":\"PENDING\"}");
            return;
        }

        boolean allPaid = true;
        String[] ids = orderIds.split(",");
        for (String id : ids) {
            try {
                int orderId = Integer.parseInt(id.trim());
                Payment payment = paymentDAO.getPaymentByOrder(orderId);
                if (payment == null || !"Success".equalsIgnoreCase(payment.getPaymentStatus())) {
                    allPaid = false;
                    break;
                }
            } catch (Exception e) {
                allPaid = false;
                break;
            }
        }

        if (allPaid) {
            response.getWriter().write("{\"status\":\"SUCCESS\"}");
        } else {
            response.getWriter().write("{\"status\":\"PENDING\"}");
        }
    }
}
