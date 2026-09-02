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
        :root {
            --bg-60: #F8FAFC;
            --surface-60: #FFFFFF;
            --struct-30: #FFF1F2; /* Soft rose background */
            --accent-10: #F43F5E;
            --text-primary: #0F172A; /* Dark navy/near-black */
            --text-secondary: #64748B; /* Muted slate/gray */
            --border-neutral: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #FFFFFF;
            color: var(--text-primary);
            min-height: 100vh;
            padding-bottom: 80px;
        }

        .hero-section {
            background: #FFFFFF !important;
            padding: 80px 0;
            margin-bottom: -60px;
            position: relative;
            z-index: 1;
            border-bottom: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .hero-section::before {
            display: none !important;
        }
        
        .hero-section h1 {
            color: var(--accent-10) !important;
            text-shadow: none !important;
        }

        .hero-section p {
            color: var(--accent-10) !important;
        }

        .booking-card {
            background: var(--surface-60);
            border-radius: 24px;
            border: 1px solid var(--border-neutral);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border-color: var(--struct-30);
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

        /* Semantic colors remain as requested */
        .status-pending { background: rgba(245, 158, 11, 0.1); color: #d97706; }
        .status-confirmed { background: rgba(16, 185, 129, 0.1); color: #059669; }
        .status-rejected { background: rgba(239, 68, 68, 0.1); color: #dc2626; }
        .status-completed { background: rgba(13, 110, 253, 0.1); color: #0d6efd; }
        .status-cancelled { background: rgba(108, 117, 125, 0.1); color: #6c757d; }

        .service-type-pill {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 12px;
            background: var(--bg-60);
            color: var(--text-secondary);
            border: 1px solid var(--border-neutral);
        }

        .booking-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.4rem;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .salon-name {
            font-size: 0.95rem;
            color: var(--accent-10);
            font-weight: 600;
            margin-bottom: 20px;
            display: block;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .info-item i { color: var(--accent-10); }

        .price-display {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-top: 15px;
        }

        .nav-tabs-custom {
            border: none;
            gap: 15px;
            margin-bottom: 40px;
            justify-content: center;
        }

        .nav-tabs-custom .nav-link {
            border: 1px solid var(--border-neutral);
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 700;
            color: var(--text-secondary);
            background: var(--surface-60);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            transition: 0.3s;
        }

        .nav-tabs-custom .nav-link.active {
            background: var(--accent-10);
            color: white;
            border-color: var(--accent-10);
            box-shadow: 0 10px 20px rgba(244, 63, 94, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 100px 20px;
            background: var(--struct-30); /* 30% empty state bg */
            border-radius: 32px;
            border: 1px dashed var(--accent-10);
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
        <c:if test="${not empty bookingSuccess}">
            <div class="alert alert-success rounded-4 shadow-sm mt-3" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${bookingSuccess}
            </div>
        </c:if>

        <c:set var="tab" value="${empty activeTab ? 'all' : activeTab}" />

        <!-- Navigation Tabs -->
        <ul class="nav nav-tabs nav-tabs-custom" id="bookingTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link ${tab == 'all' ? 'active' : ''}" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button">All</button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${tab == 'services' ? 'active' : ''}" id="services-tab" data-bs-toggle="tab" data-bs-target="#services" type="button">Services</button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${tab == 'treatments' ? 'active' : ''}" id="treatments-tab" data-bs-toggle="tab" data-bs-target="#treatments" type="button">Treatments</button>
            </li>
            <li class="nav-item">
                <button class="nav-link ${tab == 'offers' ? 'active' : ''}" id="offers-tab" data-bs-toggle="tab" data-bs-target="#offers" type="button">Exclusive Offers</button>
            </li>
        </ul>

        <div class="tab-content" id="bookingTabContent">

            <!-- All Appointments -->
            <div class="tab-pane fade ${tab == 'all' ? 'show active' : ''}" id="all">
                <c:choose>
                    <c:when test="${not empty allBookings || not empty offerBookings}">
                        <div class="row">
                            <c:forEach var="b" items="${allBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card">
                                        <div class="booking-status ${b.status eq 'CONFIRMED' ? 'status-confirmed' : (b.status eq 'REJECTED' ? 'status-rejected' : 'status-pending')}">
                                            ${b.status != null ? b.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill">
                                            <c:choose>
                                                <c:when test="${b.service != null}">Service</c:when>
                                                <c:when test="${b.treatment != null}">Treatment</c:when>
                                                <c:when test="${b.offer != null}">Offer</c:when>
                                                <c:otherwise>Booking</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <h3 class="booking-title">
                                            <c:choose>
                                                <c:when test="${b.service != null}">${b.service.name}</c:when>
                                                <c:when test="${b.treatment != null}">${b.treatment.serviceName}</c:when>
                                                <c:when test="${b.offer != null}">${b.offer.title}</c:when>
                                                <c:otherwise>Appointment #${b.id}</c:otherwise>
                                            </c:choose>
                                        </h3>
                                        <span class="salon-name">${b.salon != null ? b.salon.name : 'Salon'}</span>
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
                                        <div class="price-display">&#8377;${b.price}</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:forEach var="o" items="${offerBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card" style="border-left: 6px solid var(--accent-10);">
                                        <div class="booking-status ${o.status eq 'CONFIRMED' ? 'status-confirmed' : (o.status eq 'REJECTED' ? 'status-rejected' : 'status-pending')}">
                                            ${o.status != null ? o.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill" style="background: var(--struct-30); color: var(--accent-10); border: 1px solid var(--accent-10);">PROMOTION</span>
                                        <h3 class="booking-title">${o.offer.title}</h3>
                                        <span class="salon-name">${o.salon.name}</span>
                                        <div class="price-display">&#8377;${o.originalPrice}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-calendar-x text-muted" style="font-size: 4rem;"></i>
                            <h3 class="fw-800 mt-4">No Appointments Yet</h3>
                            <p class="text-muted">Your confirmed reservations will appear here.</p>
                            <a href="${pageContext.request.contextPath}/services" class="btn text-white rounded-pill" style="background-color: var(--accent-10); border: none;" px-5 mt-3">Explore Services</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Service Bookings -->
            <div class="tab-pane fade ${tab == 'services' ? 'show active' : ''}" id="services">
                <c:choose>
                    <c:when test="${not empty serviceBookings}">
                        <div class="row">
                            <c:forEach var="b" items="${serviceBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card">
                                        <div class="booking-status ${b.status eq 'CONFIRMED' ? 'status-confirmed' : (b.status eq 'COMPLETED' ? 'status-completed' : (b.status eq 'REJECTED' || b.status eq 'CANCELLED' ? 'status-rejected' : 'status-pending'))}">
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

                                        <div class="price-display">&#8377;${b.price}</div>
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
                            <a href="${pageContext.request.contextPath}/services" class="btn text-white rounded-pill" style="background-color: var(--accent-10); border: none;" px-5 mt-3">Explore Services</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Treatment Bookings -->
            <div class="tab-pane fade ${tab == 'treatments' ? 'show active' : ''}" id="treatments">
                <c:choose>
                    <c:when test="${not empty treatmentBookings}">
                        <div class="row">
                            <c:forEach var="t" items="${treatmentBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card">
                                        <div class="booking-status ${t.status eq 'CONFIRMED' ? 'status-confirmed' : (t.status eq 'COMPLETED' ? 'status-completed' : (t.status eq 'REJECTED' || t.status eq 'CANCELLED' ? 'status-rejected' : 'status-pending'))}">
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

                                        <div class="price-display">&#8377;${t.price}</div>
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
                            <a href="${pageContext.request.contextPath}/user/salons" class="btn text-white rounded-pill" style="background-color: var(--accent-10); border: none;" px-5 mt-3">View Salons</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Offer Bookings -->
            <div class="tab-pane fade ${tab == 'offers' ? 'show active' : ''}" id="offers">
                <c:choose>
                    <c:when test="${not empty offerBookings || not empty offerBookingOnes}">
                        <div class="row">
                            <c:forEach var="o" items="${offerBookings}">
                                <div class="col-lg-6">
                                    <div class="booking-card" style="border-left: 6px solid var(--accent-10);">
                                        <div class="booking-status ${o.status eq 'CONFIRMED' ? 'status-confirmed' : (o.status eq 'COMPLETED' ? 'status-completed' : (o.status eq 'REJECTED' || o.status eq 'CANCELLED' ? 'status-rejected' : 'status-pending'))}">
                                            ${o.status != null ? o.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill" style="background: var(--struct-30); color: var(--accent-10); border: 1px solid var(--accent-10);">PROMOTION</span>
                                        <h3 class="booking-title">${o.offer.title}</h3>
                                        <span class="salon-name">${o.salon.name}</span>
                                        
                                        <div class="mb-4 small text-muted">${o.offer.description}</div>
                                        
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="text-decoration-line-through text-muted small">&#8377;${o.originalPrice}</div>
                                            <c:if test="${o.offer != null}">
                                                <div class="price-display mt-0 ">&#8377;${o.originalPrice - (o.originalPrice * o.offer.discountPercent / 100)}</div>
                                                <span class="badge  ">${o.offer.discountPercent}% OFF</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:forEach var="ob" items="${offerBookingOnes}">
                                <div class="col-lg-6">
                                    <div class="booking-card" style="border-left: 6px solid var(--accent-10);">
                                        <div class="booking-status ${ob.status eq 'CONFIRMED' ? 'status-confirmed' : (ob.status eq 'REJECTED' ? 'status-rejected' : 'status-pending')}">
                                            ${ob.status != null ? ob.status : 'PENDING'}
                                        </div>
                                        <span class="service-type-pill" style="background: var(--struct-30); color: var(--accent-10); border: 1px solid var(--accent-10);">PROMOTION</span>
                                        <h3 class="booking-title">${ob.offer.title}</h3>
                                        <span class="salon-name">${ob.salon.name}</span>
                                        <div class="info-item"><i class="bi bi-calendar3"></i> ${ob.bookingDate}</div>
                                        <div class="info-item"><i class="bi bi-clock"></i> ${ob.preferredTime}</div>
                                        <div class="price-display">&#8377;${ob.price}</div>
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

