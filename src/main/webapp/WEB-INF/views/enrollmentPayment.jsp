<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Payment | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <style>
        :root {
            --rose: #F43F5E;
            --navy: #0F172A;
            --muted: #64748B;
            --bg: #F8FAFC;
        }
        body { font-family: 'Poppins', sans-serif; background: var(--bg); color: var(--navy); }
        .pay-card {
            background: #fff;
            border: 1px solid #E2E8F0;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(15,23,42,0.05);
            padding: 28px;
            max-width: 560px;
            margin: 0 auto;
        }
        .btn-pay {
            background: var(--rose);
            color: #fff;
            border: none;
            border-radius: 999px;
            font-weight: 700;
            padding: 14px 24px;
            width: 100%;
        }
        .btn-pay:disabled { opacity: 0.7; }
        .row-line { display:flex; justify-content:space-between; gap:12px; padding:10px 0; border-bottom:1px solid #F1F5F9; }
        .row-line:last-child { border-bottom:none; }
        .total { font-size: 1.25rem; font-weight: 800; color: var(--rose); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height:100vh; background:var(--bg); padding: 96px 20px 40px;">
            <div class="container" style="max-width:720px;">
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="text-decoration-none small fw-semibold" style="color:var(--muted);">
                    ← Back to Martial Arts
                </a>
                <h1 class="h3 fw-bold mt-3 mb-1">Complete Your Enrollment</h1>
                <p class="text-muted mb-4">Pay securely to activate your approved Martial Arts batch.</p>

                <div class="pay-card">
                    <div class="row-line">
                        <span class="text-muted">Centre</span>
                        <strong><c:out value="${enrollment.center.name}"/></strong>
                    </div>
                    <div class="row-line">
                        <span class="text-muted">Batch</span>
                        <strong>
                            <c:out value="${enrollment.batch.style}"/> —
                            <c:out value="${enrollment.batch.name}"/>
                        </strong>
                    </div>
                    <div class="row-line">
                        <span class="text-muted">Schedule</span>
                        <strong>
                            <c:out value="${enrollment.batch.availableDays}"/>
                            ·
                            <c:out value="${enrollment.batch.timeSlot}"/>
                        </strong>
                    </div>
                    <div class="row-line">
                        <span class="text-muted">Training Fee</span>
                        <strong>₹<fmt:formatNumber value="${fee}" type="number" maxFractionDigits="0"/></strong>
                    </div>
                    <div class="row-line">
                        <span class="fw-bold">TOTAL</span>
                        <span class="total">₹<fmt:formatNumber value="${fee}" type="number" maxFractionDigits="0"/></span>
                    </div>

                    <button type="button" id="payBtn" class="btn-pay mt-3" onclick="payEnrollment()">
                        Pay Securely with Razorpay
                    </button>
                    <p id="payError" class="text-danger small mt-3 mb-0" style="display:none;"></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
        async function payEnrollment() {
            const btn = document.getElementById('payBtn');
            const err = document.getElementById('payError');
            err.style.display = 'none';
            btn.disabled = true;
            btn.textContent = 'Preparing payment...';
            try {
                const orderRes = await fetch('${pageContext.request.contextPath}/payment/create-order', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        type: 'MARTIAL_ARTS',
                        enrollmentId: ${enrollment.id}
                    })
                });
                const order = await orderRes.json();
                if (!orderRes.ok || !order.orderId) {
                    throw new Error(order.error || 'Could not create payment order');
                }

                if (order.mock === true) {
                    const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            razorpay_order_id: order.orderId,
                            razorpay_payment_id: 'mock_pay_' + Date.now(),
                            razorpay_signature: 'mock_sig',
                            type: 'MARTIAL_ARTS',
                            enrollmentId: ${enrollment.id}
                        })
                    });
                    const verify = await verifyRes.json();
                    if (!verifyRes.ok || verify.error) throw new Error(verify.error || 'Payment verification failed');
                    window.location.href = '${pageContext.request.contextPath}/centres/allacceptedcentres?paid=1';
                    return;
                }

                const rzp = new Razorpay({
                    key: order.key,
                    amount: order.amount,
                    currency: order.currency || 'INR',
                    name: 'Fight D Fear',
                    description: 'Martial Arts Enrollment',
                    order_id: order.orderId,
                    theme: { color: '#F43F5E' },
                    handler: async function (response) {
                        const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_signature: response.razorpay_signature,
                                type: 'MARTIAL_ARTS',
                                enrollmentId: ${enrollment.id}
                            })
                        });
                        const verify = await verifyRes.json();
                        if (!verifyRes.ok || verify.error) {
                            err.textContent = verify.error || 'Payment verification failed';
                            err.style.display = 'block';
                            btn.disabled = false;
                            btn.textContent = 'Pay Securely with Razorpay';
                            return;
                        }
                        window.location.href = '${pageContext.request.contextPath}/centres/allacceptedcentres?paid=1';
                    }
                });
                rzp.on('payment.failed', function () {
                    err.textContent = 'Payment failed. Please try again.';
                    err.style.display = 'block';
                    btn.disabled = false;
                    btn.textContent = 'Pay Securely with Razorpay';
                });
                rzp.open();
                btn.disabled = false;
                btn.textContent = 'Pay Securely with Razorpay';
            } catch (e) {
                err.textContent = e.message || 'Payment error';
                err.style.display = 'block';
                btn.disabled = false;
                btn.textContent = 'Pay Securely with Razorpay';
            }
        }
    </script>
</body>
</html>
