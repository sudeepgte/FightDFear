<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            color: var(--brand-purple-darker);
            min-height: 100vh;
            padding-bottom: 80px;
        }

        .hero-section {
            background: var(--gradient-dark);
            padding: 80px 0;
            color: white;
            margin-bottom: -60px;
            position: relative;
            z-index: 1;
        }

        .booking-card {
            background: white;
            border-radius: 24px;
            border: 1px solid rgba(30, 27, 75, 0.1);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(30, 27, 75, 0.1);
            border-color: var(--brand-pink-light);
        }

        .booking-status {
            position: absolute;
            top: 30px;
            right: 30px;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .status-pending { background: rgba(245, 158, 11, 0.1); color: #d97706; }
        .status-confirmed { background: rgba(16, 185, 129, 0.1); color: #059669; }
        .status-rejected { background: rgba(239, 68, 68, 0.1); color: #dc2626; }

        .service-type-pill {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 12px;
            background: #f1f3f5;
            color: #6c757d;
        }

        .booking-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            margin-bottom: 5px;
            color: var(--brand-purple-darker);
        }

        .salon-name {
            font-size: 0.95rem;
            color: var(--brand-pink);
            font-weight: 600;
            margin-bottom: 20px;
            display: block;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 8px;
        }

        .info-item i { color: var(--brand-purple-light); }

        .price-display {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin-top: 15px;
        }

        .nav-tabs-custom {
            border: none;
            gap: 15px;
            margin-bottom: 40px;
            justify-content: center;
        }

        .nav-tabs-custom .nav-link {
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 700;
            color: #6c757d;
            background: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            transition: 0.3s;
        }

        .nav-tabs-custom .nav-link.active {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 100px 20px;
            background: white;
            border-radius: 32px;
            border: 1px dashed #dee2e6;
        }
    </style>
</head>
<body>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <h1 class="fw-900" style="font-family: 'Montserrat';">My Appointments</h1>
            <p class="opacity-75">Track and manage your beauty journey with Fight D Fear.</p>
        </div>
    </div>

    <div class="container">
        <!-- Navigation Tabs -->
        <ul class="nav nav-tabs nav-tabs-custom" id="bookingTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="services-tab" data-bs-toggle="tab" data-bs-target="#services" type="button">Services</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="treatments-tab" data-bs-toggle="tab" data-bs-target="#treatments" type="button">Treatments</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="offers-tab" data-bs-toggle="tab" data-bs-target="#offers" type="button">Exclusive Offers</button>
            </li>
        </ul>

        <div class="tab-content" id="bookingTabContent">
            
            <!-- Service Bookings -->
            <div class="tab-pane fade show active" id="services">
                <c:choose>
                    <c:when test="${not empty serviceBookings}">
                        <div class="row">
                            <c:forEach var="b" items="${serviceBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card">
                                        <div class="booking-status ${b.status eq 'CONFIRMED' ? 'status-confirmed' : (b.status eq 'REJECTED' ? 'status-rejected' : 'status-pending')}">
                                            ${b.status != null ? b.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill">${b.bookingType} Booking</span>
                                        <h3 class="booking-title">${b.service.name}</h3>
                                        <span class="salon-name">${b.salon.name}</span>
                                        
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <div class="info-item"><i class="bi bi-calendar3"></i> ${b.bookingDate}</div>
                                                <div class="info-item"><i class="bi bi-clock"></i> ${b.preferredTime}</div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="info-item"><i class="bi bi-geo-alt"></i> ${b.bookingType eq 'DOOR' ? b.address : 'Parlour Visit'}</div>
                                                <div class="info-item"><i class="bi bi-telephone"></i> ${b.emergencyContact}</div>
                                            </div>
                                        </div>

                                        <c:if test="${not empty b.notes}">
                                            <div class="mt-3 p-3 bg-light rounded-3 small text-muted">
                                                <strong>Notes:</strong> ${b.notes}
                                            </div>
                                        </c:if>

                                        <div class="price-display">₹${b.price}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-calendar-x text-muted" style="font-size: 4rem;"></i>
                            <h3 class="fw-800 mt-4">No Service Bookings</h3>
                            <p class="text-muted">You haven't booked any services yet.</p>
                            <a href="${pageContext.request.contextPath}/services" class="btn btn-purple rounded-pill px-5 mt-3">Explore Services</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Treatment Bookings -->
            <div class="tab-pane fade" id="treatments">
                <c:choose>
                    <c:when test="${not empty treatmentBookings}">
                        <div class="row">
                            <c:forEach var="t" items="${treatmentBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card">
                                        <div class="booking-status ${t.status eq 'CONFIRMED' ? 'status-confirmed' : (t.status eq 'REJECTED' ? 'status-rejected' : 'status-pending')}">
                                            ${t.status != null ? t.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill">${t.bookingType} Treatment</span>
                                        <h3 class="booking-title">${t.treatment.serviceName}</h3>
                                        <span class="salon-name">${t.salon.name}</span>
                                        
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <div class="info-item"><i class="bi bi-calendar3"></i> ${t.bookingDate}</div>
                                                <div class="info-item"><i class="bi bi-clock"></i> ${t.preferredTime}</div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="info-item"><i class="bi bi-geo-alt"></i> ${t.bookingType eq 'DOOR' ? t.address : 'Parlour Visit'}</div>
                                                <div class="info-item"><i class="bi bi-telephone"></i> ${t.emergencyContact}</div>
                                            </div>
                                        </div>

                                        <div class="price-display">₹${t.price}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-sparkles text-muted" style="font-size: 4rem;"></i>
                            <h3 class="fw-800 mt-4">No Specialized Treatments</h3>
                            <p class="text-muted">Ready for a glow-up? Check out our treatments.</p>
                            <a href="${pageContext.request.contextPath}/treatments" class="btn btn-purple rounded-pill px-5 mt-3">View Treatments</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Offer Bookings -->
            <div class="tab-pane fade" id="offers">
                <c:choose>
                    <c:when test="${not empty offerBookings}">
                        <div class="row">
                            <c:forEach var="o" items="${offerBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card" style="border-left: 6px solid var(--brand-pink);">
                                        <div class="booking-status status-confirmed">REDEEMED</div>
                                        <span class="service-type-pill" style="background: var(--brand-pink); color: white;">PROMOTION</span>
                                        <h3 class="booking-title">${o.offer.title}</h3>
                                        <span class="salon-name">${o.salon.name}</span>
                                        
                                        <div class="mb-4 small text-muted">${o.offer.description}</div>
                                        
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="text-decoration-line-through text-muted small">₹${o.originalPrice}</div>
                                            <div class="price-display mt-0 text-pink">₹${o.originalPrice - (o.originalPrice * o.offer.discountPercent / 100)}</div>
                                            <span class="badge bg-soft-pink text-pink">${o.offer.discountPercent}% OFF</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-gift text-muted" style="font-size: 4rem;"></i>
                            <h3 class="fw-800 mt-4">No Claimed Offers</h3>
                            <p class="text-muted">Save more with our exclusive partner discounts.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

