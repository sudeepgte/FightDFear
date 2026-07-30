<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Bookings — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--brand-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--brand-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Sub Navigation Pills */
        .glow-nav {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        .glow-nav a {
            padding: 10px 24px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .glow-nav a:hover, .glow-nav a.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.2);
        }

        /* Content Container */
        .bookings-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .section-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title i {
            color: var(--brand-pink);
        }

        /* Modern Table Card wrapper */
        .table-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 40px;
            overflow: hidden;
        }
        
        .table {
            margin-bottom: 0;
        }
        .table th {
            font-weight: 700;
            color: var(--brand-purple);
            border-top: none;
            padding: 14px 10px;
        }
        .table td {
            padding: 14px 10px;
            vertical-align: middle;
            font-size: 14px;
        }
        
        .empty-bookings {
            text-align: center;
            padding: 50px 20px;
            color: var(--fdf-muted);
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
            .glow-nav { gap: 8px; margin-top: 20px; }
            .glow-nav a { padding: 8px 16px; font-size: 12px; }
            .bookings-container { padding: 20px 15px; }
            .table-card { padding: 15px 10px; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/doctors/myAppointments" class="top-btn">
                    <i class="bi bi-heart-pulse"></i> Medical Appointments
                </a>
            </div>
            
            <h1>My Bookings</h1>
            <p>Track your reservations, view appointment details, check confirmations, or process safety and worker support bookings.</p>
            
            <!-- Category Navigation Tab Pills -->
            <div class="glow-nav">
                <a href="${pageContext.request.contextPath}/index/templates">Overview</a>
                <a href="${pageContext.request.contextPath}/user/salons">Explore Salons</a>
                <a href="${pageContext.request.contextPath}/salon/treatments/viewtreatments">SkinCare Treatments</a>
                <a href="${pageContext.request.contextPath}/user/stylists">Stylists</a>
                <a href="${pageContext.request.contextPath}/salon/offers">Discounts &amp; Offers</a>
            </div>
        </div>

        <!-- Bookings Container -->
        <div class="bookings-container">
            
            <!-- Beauty & Treatment Bookings -->
            <div class="section-title">
                <i class="bi bi-bookmark-check-fill"></i>
                <span>Glow Space Appointments</span>
            </div>
            
            <div class="table-card">
                <c:choose>
                    <c:when test="${not empty serviceBookings || not empty treatmentBookings || not empty offerBookings}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Type</th>
                                        <th>Item Name</th>
                                        <th>Salon / Stylist</th>
                                        <th>Mode</th>
                                        <th>Price</th>
                                        <th>Emergency Contact</th>
                                        <th>Date &amp; Time</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Service Bookings -->
                                    <c:forEach var="b" items="${serviceBookings}">
                                        <tr>
                                            <td><span class="badge rounded-pill bg-primary px-3">Service</span></td>
                                            <td class="fw-bold">${b.service.name}</td>
                                            <td>${b.salon.name}</td>
                                            <td><span class="text-capitalize text-muted small">${b.bookingType}</span></td>
                                            <td class="fw-bold text-dark">₹${b.price}</td>
                                            <td>${b.emergencyContact}</td>
                                            <td>
                                                <div class="small">${b.bookingDate}</div>
                                                <div class="text-muted small">${b.preferredTime}</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'CONFIRMED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'REJECTED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <!-- Treatment Bookings -->
                                    <c:forEach var="t" items="${treatmentBookings}">
                                        <tr>
                                            <td><span class="badge rounded-pill bg-info text-dark px-3">Treatment</span></td>
                                            <td class="fw-bold">${t.treatment.serviceName}</td>
                                            <td>${t.salon.name}</td>
                                            <td><span class="text-capitalize text-muted small">${t.bookingType}</span></td>
                                            <td class="fw-bold text-dark">₹${t.price}</td>
                                            <td>${t.emergencyContact}</td>
                                            <td>
                                                <div class="small">${t.bookingDate}</div>
                                                <div class="text-muted small">${t.preferredTime}</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.status eq 'CONFIRMED'}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${t.status eq 'REJECTED'}">
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <!-- Offer Bookings -->
                                    <c:forEach var="o" items="${offerBookings}">
                                        <tr>
                                            <td><span class="badge rounded-pill bg-danger px-3">Offer Deal</span></td>
                                            <td class="fw-bold">${o.offer.title}</td>
                                            <td>${o.salon.name}</td>
                                            <td><span class="text-muted small">Offer</span></td>
                                            <td class="fw-bold text-dark">
                                                ₹${o.originalPrice - (o.originalPrice * o.offer.discountPercent / 100)}
                                            </td>
                                            <td>—</td>
                                            <td>
                                                <div class="small">${o.bookingDate}</div>
                                            </td>
                                            <td>
                                                <span class="badge bg-success px-2 py-1">Booked</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-bookings">
                            <i class="bi bi-calendar-x display-2 mb-3 text-muted"></i>
                            <h4>No beauty appointments booked yet</h4>
                            <p class="text-muted small mb-0">Browse salons or treatments to schedule your first wellness session!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Marketplace Worker Bookings -->
            <c:if test="${not empty workerBookings}">
                <div class="section-title mt-5">
                    <i class="bi bi-tools"></i>
                    <span>Marketplace Booked Workers</span>
                </div>
                
                <div class="table-card">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Worker Name</th>
                                    <th>Category</th>
                                    <th>Booking Details</th>
                                    <th>Client Note</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="wb" items="${workerBookings}">
                                    <tr>
                                        <td class="fw-bold">${wb.jobApplication.user.fullName}</td>
                                        <td><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-3">${wb.jobApplication.jobCategory}</span></td>
                                        <td>
                                            <div class="small">${wb.bookingDate}</div>
                                            <div class="mt-1 small">
                                                <span class="badge bg-light text-dark border">
                                                    <c:choose>
                                                        <c:when test="${wb.hours != null}">Hrs: ${wb.hours}</c:when>
                                                        <c:otherwise>Custom Offer</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="badge bg-success-subtle text-success border border-success-subtle">Amount: ₹${wb.totalAmount != null ? wb.totalAmount : 0.0}</span>
                                            </div>
                                        </td>
                                        <td><span class="small fst-italic text-muted">${not empty wb.note ? wb.note : '—'}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${wb.status == 'PENDING'}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1">Pending</span>
                                                </c:when>
                                                <c:when test="${wb.status == 'ACCEPTED'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">Accepted</span>
                                                </c:when>
                                                <c:when test="${wb.status == 'REJECTED'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Rejected</span>
                                                </c:when>
                                                <c:when test="${wb.status == 'PAID'}">
                                                    <span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-1">Paid</span>
                                                </c:when>
                                                <c:when test="${wb.status == 'COMPLETED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Completed</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${wb.status == 'ACCEPTED' || wb.status == 'COMPLETED'}">
                                                    <div class="d-flex gap-2">
                                                        <a href="${pageContext.request.contextPath}/chat/window/${wb.jobApplication.user.id}" class="btn btn-sm btn-outline-primary rounded-pill px-3">Chat</a>
                                                        <button type="button" class="btn btn-sm btn-success rounded-pill px-3" onclick="payForWorker(${wb.id}, 500)">Pay Now</button>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
            
        </div><!-- /bookings-container -->

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });
</script>

<script>
  (function () {
    let initialSignature = "";
    try {
      initialSignature = [
        <c:forEach var="booking" items="${bookings}">
          "B:${booking.id}|${booking.status};",
        </c:forEach>
        <c:forEach var="b" items="${serviceBookings}">
          "B1:${b.id}|${b.status};",
        </c:forEach>
        <c:forEach var="t" items="${treatmentBookings}">
          "B1:${t.id}|${t.status};",
        </c:forEach>
        <c:forEach var="o" items="${offerBookings}">
          "O:${o.id}|${o.status};",
        </c:forEach>
      ].join("");
    } catch (e) {}

    async function checkForUpdates() {
      try {
        const res = await fetch("${pageContext.request.contextPath}/user/bookings.meta", {
          headers: { "Accept": "application/json" }
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data && data.signature && data.signature !== initialSignature) {
          window.location.reload();
        }
      } catch (e) {
        // ignore
      }
    }

    setInterval(checkForUpdates, 8000);
  })();
</script>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    function payForWorker(bookingId, amount) {
        fetch("${pageContext.request.contextPath}/payment/create-order", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ amount: amount, type: "WORKER_BOOKING" })
        })
        .then(response => response.json())
        .then(orderData => {
            if (orderData.error) {
                alert("Error creating order: " + orderData.error);
                return;
            }
            var options = {
                "key": orderData.key,
                "amount": orderData.amount,
                "currency": "INR",
                "name": "Fight D Fear",
                "description": "Worker Booking Payment",
                "order_id": orderData.orderId,
                "handler": function (response) {
                    fetch("${pageContext.request.contextPath}/payment/verify", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                            razorpay_order_id: response.razorpay_order_id,
                            razorpay_payment_id: response.razorpay_payment_id,
                            razorpay_signature: response.razorpay_signature,
                            type: "WORKER_BOOKING",
                            targetId: bookingId,
                            amount: amount
                        })
                    })
                    .then(res => res.json())
                    .then(verifyData => {
                        if (verifyData.status === "success") {
                            alert("Payment Successful!");
                            window.location.reload();
                        } else {
                            alert("Payment Verification Failed: " + verifyData.error);
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        alert("Error verifying payment.");
                    });
                },
                "theme": { "color": "#10b981" }
            };
            var rzp = new Razorpay(options);
            rzp.open();
        })
        .catch(err => {
            console.error(err);
            alert("Failed to initialize payment.");
        });
    }
</script>

</body>
</html>
