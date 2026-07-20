<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Secure Checkout | Fight D Fear</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #2D0B2E;
            --m-glass: rgba(255, 255, 255, 0.03);
            --m-glass-border: rgba(255, 255, 255, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--m-bg);
            background-image: 
                radial-gradient(circle at 15% 15%, rgba(219, 39, 119, 0.12) 0%, transparent 45%),
                radial-gradient(circle at 85% 85%, rgba(124, 45, 94, 0.12) 0%, transparent 45%);
            color: #ffffff;
            min-height: 100vh;
        }

        .checkout-container {
            margin-top: 60px;
            margin-bottom: 60px;
        }

        .glass-card {
            background: var(--m-glass);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--m-glass-border);
            border-radius: 30px;
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            transition: border-color 0.3s;
        }

        .glass-card:hover {
            border-color: rgba(219, 39, 119, 0.25);
        }

        .checkout-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            background: linear-gradient(135deg, #ffffff, #f472b6);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 30px;
        }

        .price-badge {
            font-size: 2.8rem;
            font-weight: 800;
            color: #f472b6;
            text-shadow: 0 5px 15px rgba(219, 39, 119, 0.2);
            margin: 20px 0;
        }

        .btn-premium-pay {
            background: linear-gradient(135deg, var(--m-pink), #a855f7);
            border: none;
            color: white;
            padding: 16px 32px;
            border-radius: 18px;
            font-weight: 800;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(219, 39, 119, 0.3);
        }

        .btn-premium-pay:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
            color: white;
            box-shadow: 0 15px 30px rgba(219, 39, 119, 0.4);
        }

        .details-list {
            list-style: none;
            padding: 0;
            margin: 25px 0;
            text-align: left;
        }

        .details-list li {
            padding: 12px 0;
            border-bottom: 1px solid var(--m-glass-border);
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
        }

        .details-list li:last-child {
            border-bottom: none;
        }

        .details-label {
            color: #a1a1aa;
            font-weight: 500;
        }

        .details-value {
            color: #ffffff;
            font-weight: 700;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="container checkout-container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="glass-card text-center">
                    <h3 class="checkout-title"><i class="bi bi-shield-lock-fill text-pink"></i> Secure Checkout</h3>
                    
                    <div class="price-badge">₹${enrollment.providerClass.price}</div>
                    
                    <div class="alert alert-dismissible fade show rounded-4 mb-4 text-start small" style="background: rgba(219, 39, 119, 0.08); color: #f472b6; border: 1px solid rgba(219,39,119,0.15);">
                        <i class="bi bi-info-circle-fill me-2"></i> You are enlisting in a verified premium class hosted by our community service partner.
                    </div>

                    <ul class="details-list">
                        <li>
                            <span class="details-label">Class Name</span>
                            <span class="details-value">${enrollment.providerClass.className}</span>
                        </li>
                        <li>
                            <span class="details-label">Host Provider</span>
                            <span class="details-value">${enrollment.providerClass.provider.fullName}</span>
                        </li>
                        <li>
                            <span class="details-label">Duration</span>
                            <span class="details-value">${enrollment.providerClass.duration}</span>
                        </li>
                        <li>
                            <span class="details-label">Schedule Time</span>
                            <span class="details-value">${enrollment.providerClass.dateTime}</span>
                        </li>
                    </ul>

                    <button id="payBtn" onclick="initiateRazorpayPayment()" class="btn-premium-pay py-3 mt-3">
                        <i class="bi bi-credit-card-2-front-fill me-2"></i> Pay & Confirm Enrollment
                    </button>
                    
                    <div class="d-flex justify-content-center align-items-center gap-3 mt-4 text-muted small">
                        <span><i class="bi bi-shield-fill-check text-success"></i> PCI Compliant</span>
                        <span>&bull;</span>
                        <span><i class="bi bi-lock-fill text-success"></i> 256-Bit SSL Encryption</span>
                    </div>

                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-link text-muted text-decoration-none small">
                            <i class="bi bi-arrow-left"></i> Cancel Checkout
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Razorpay SDK & Scripts -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <script>
        async function initiateRazorpayPayment() {
            const payBtn = document.getElementById('payBtn');
            payBtn.disabled = true;
            payBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Processing...';

            const amount = "${enrollment.providerClass.price}";
            const enrollmentId = "${enrollment.id}";

            try {
                const res = await fetch('${pageContext.request.contextPath}/payment/create-order', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ amount: amount, type: 'MARKETPLACE' })
                });

                if (!res.ok) throw new Error('Order creation failed');

                const order = await res.json();
                
                const options = {
                    key: order.key,
                    amount: order.amount,
                    currency: 'INR',
                    name: 'Fight D Fear Marketplace',
                    description: 'Enrolling in ${enrollment.providerClass.className}',
                    order_id: order.orderId,
                    handler: async function(response) {
                        const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_signature: response.razorpay_signature,
                                type: 'MARKETPLACE',
                                enrollmentId: enrollmentId,
                                amount: amount
                            })
                        });
                        
                        if (verifyRes.ok) {
                            window.location.href = '${pageContext.request.contextPath}/marketplace/my-classes?message=Enrolled-Successfully';
                        } else {
                            alert('Payment verification failed. Please contact support.');
                            location.reload();
                        }
                    },
                    modal: {
                        ondismiss: function() {
                            payBtn.disabled = false;
                            payBtn.innerHTML = '<i class="bi bi-credit-card-2-front-fill me-2"></i> Pay & Confirm Enrollment';
                        }
                    },
                    theme: {
                        color: '#f43f5e'
                    }
                };

                new Razorpay(options).open();
            } catch (e) {
                alert('Payment initiation failed. Please try again.');
                payBtn.disabled = false;
                payBtn.innerHTML = '<i class="bi bi-credit-card-2-front-fill me-2"></i> Pay & Confirm Enrollment';
            }
        }
    </script>
</body>
</html>

