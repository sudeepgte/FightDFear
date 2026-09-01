<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${salon.name} — Salon Services & Booking | Fight D Fear</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    
    <!-- CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css" rel="stylesheet">

    <style>
        :root {
            --brand-primary: #f43f5e;
            --brand-primary-hover: #e11d48;
            --brand-purple: #4c1d95;
            --brand-dark: #0f172a;
            --bg-soft: #fdf2f8;
            --card-bg: #ffffff;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-color: #f1f5f9;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fffcfd 0%, #fdf2f8 50%, #f5f3ff 100%);
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* ===== NAVIGATION BAR ===== */
        .fdf-navbar {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(244, 63, 94, 0.1);
            position: sticky;
            top: 0;
            z-index: 1050;
            padding: 12px 0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
        .fdf-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }
        .nav-btn-link {
            color: var(--text-dark);
            font-weight: 600;
            font-size: 0.9rem;
            padding: 8px 16px;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .nav-btn-link:hover {
            color: var(--brand-primary);
            background: rgba(244, 63, 94, 0.08);
        }
        .btn-action-primary {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-primary-hover));
            color: #fff !important;
            font-weight: 700;
            padding: 9px 22px;
            border-radius: 30px;
            text-decoration: none;
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.25);
            transition: all 0.3s ease;
        }
        .btn-action-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(244, 63, 94, 0.35);
        }

        /* ===== SALON HERO HEADER ===== */
        .salon-hero-card {
            background: #ffffff;
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.8);
            margin-top: 30px;
            margin-bottom: 40px;
        }
        .salon-hero-img-wrap {
            height: 380px;
            position: relative;
            overflow: hidden;
            background: #f1f5f9;
        }
        .salon-hero-img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 1;
            visibility: visible;
            position: relative;
            z-index: 1;
        }
        .salon-hero-badge {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 2;
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(10px);
            color: #ffffff;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 6px 16px;
            border-radius: 30px;
            letter-spacing: 0.5px;
        }
        @media (max-width: 991.98px) {
            .salon-hero-img-wrap { height: 260px; }
        }
        .salon-details-panel {
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .salon-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 2.2rem;
            color: var(--text-dark);
            margin-bottom: 12px;
        }
        .salon-location-tag {
            color: var(--brand-primary);
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .rating-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #fff8e6;
            color: #d97706;
            padding: 6px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.9rem;
            border: 1px solid #fef3c7;
            margin-bottom: 20px;
        }
        .meta-info-list p {
            margin-bottom: 8px;
            font-size: 0.92rem;
            color: var(--text-muted);
        }
        .meta-info-list strong {
            color: var(--text-dark);
        }

        /* ===== QUICK STATS RIBBON ===== */
        .quick-stats-bar {
            background: #ffffff;
            border-radius: 20px;
            padding: 20px 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            border: 1px solid var(--border-color);
            margin-bottom: 40px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-item h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--brand-primary);
            margin: 0;
        }
        .stat-item p {
            margin: 0;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* ===== SECTION ANCHOR TABS ===== */
        .section-tabs {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            padding-bottom: 10px;
            margin-bottom: 40px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-tab-btn {
            background: white;
            border: 1px solid #e2e8f0;
            padding: 10px 24px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-dark);
            text-decoration: none;
            white-space: nowrap;
            transition: all 0.3s ease;
        }
        .section-tab-btn:hover, .section-tab-btn.active {
            background: var(--brand-primary);
            color: #white;
            border-color: var(--brand-primary);
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.25);
        }

        /* ===== CARD DESIGNS ===== */
        .section-heading-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.6rem;
            color: var(--text-dark);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .service-card {
            background: #ffffff;
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .service-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(244, 63, 94, 0.12);
            border-color: rgba(244, 63, 94, 0.3);
        }
        .service-card-img {
            display: block;
            height: 220px;
            width: 100%;
            object-fit: cover;
            opacity: 1;
            visibility: visible;
            background: #f8fafc;
        }
        .service-card-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .service-cat-badge {
            background: rgba(244, 63, 94, 0.08);
            color: var(--brand-primary);
            font-size: 0.72rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            align-self: flex-start;
            margin-bottom: 10px;
        }
        .service-name {
            font-weight: 700;
            font-size: 1.15rem;
            color: var(--text-dark);
            margin-bottom: 8px;
        }
        .service-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid #f8fafc;
        }
        .price-text {
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--brand-primary);
        }
        .duration-chip {
            font-size: 0.8rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* ===== OFFER CARDS ===== */
        .offer-card {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            color: #ffffff;
            border-radius: 24px;
            padding: 30px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(30, 27, 75, 0.2);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .offer-discount-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: var(--brand-primary);
            color: #white;
            font-weight: 900;
            font-size: 0.9rem;
            padding: 6px 14px;
            border-radius: 20px;
            box-shadow: 0 6px 15px rgba(244, 63, 94, 0.4);
        }
        .offer-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.35rem;
            margin-bottom: 10px;
        }
        .offer-desc {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        /* ===== STYLIST CARDS ===== */
        .stylist-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 24px;
            text-align: center;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.03);
            transition: all 0.3s ease;
        }
        .stylist-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.06);
        }
        .stylist-avatar {
            display: block;
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 16px;
            border: 4px solid #fff5f8;
            box-shadow: 0 8px 20px rgba(244, 63, 94, 0.15);
            opacity: 1;
            visibility: visible;
            background: #f8fafc;
        }

        /* ===== FOOTER ===== */
        .footer-glow {
            background: var(--brand-dark);
            color: #ffffff;
            padding: 60px 0 30px;
            margin-top: 80px;
        }
        .footer-glow a {
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.3s;
        }
        .footer-glow a:hover {
            color: var(--brand-primary);
        }
    </style>
</head>
<body>

    <!-- ===== TOP HEADER ===== -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div id="wrapper">
        <!-- ===== SIDEBAR ===== -->
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        
        <!-- ===== CONTENT WRAPPER ===== -->
        <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;" data-skip-global-back="true">

    <div class="container">
        <!-- ===== SALON HERO HEADER ===== -->
        <div class="salon-hero-card">
            <div class="row g-0">
                <!-- Left Image -->
                <div class="col-lg-6 salon-hero-img-wrap">
                    <span class="salon-hero-badge"><i class="bi bi-check-circle-fill me-1 text-success"></i> Verified Salon</span>
                    <c:choose>
                        <c:when test="${not empty salon.profileImageUrl}">
                            <c:choose>
                                <c:when test="${salon.profileImageUrl.startsWith('http://') || salon.profileImageUrl.startsWith('https://')}">
                                    <c:set var="salonHeroSrc" value="${salon.profileImageUrl}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="salonHeroSrc" value="${salon.profileImageUrl.startsWith('/') ? salon.profileImageUrl : '/'.concat(salon.profileImageUrl)}"/>
                                </c:otherwise>
                            </c:choose>
                            <img src="${salonHeroSrc}"
                                 class="salon-hero-img" alt="<c:out value='${salon.name}'/>"
                                 loading="eager"
                                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800&q=80';">
                        </c:when>
                        <c:otherwise>
                            <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800&q=80"
                                 class="salon-hero-img" alt="<c:out value='${salon.name}'/>" loading="eager">
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Right Details -->
                <div class="col-lg-6 salon-details-panel">
                    <h1 class="salon-title">${salon.name}</h1>
                    
                    <div class="salon-location-tag">
                        <i class="bi bi-geo-alt-fill fs-5"></i>
                        <span>${salon.address}, ${salon.city}, ${salon.state} - ${salon.pincode}</span>
                    </div>

                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="rating-chip m-0">
                            <i class="bi bi-star-fill"></i>
                            <span><fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5.0</span>
                        </div>
                        <span class="text-muted small">(${not empty salon.reviews ? salon.reviews.size() : 0} Reviews)</span>
                    </div>

                    <div class="meta-info-list mb-4">
                        <p><i class="bi bi-telephone-fill me-2 text-rose"></i> <strong>Phone:</strong> ${salon.phone}</p>
                        <p><i class="bi bi-envelope-fill me-2 text-rose"></i> <strong>Email:</strong> ${salon.email}</p>
                        <c:if test="${not empty salon.website}">
                            <p><i class="bi bi-globe me-2 text-rose"></i> <strong>Website:</strong>
                                <c:choose>
                                    <c:when test="${salon.website.startsWith('http://') || salon.website.startsWith('https://')}">
                                        <a href="<c:out value='${salon.website}'/>" target="_blank" rel="noopener noreferrer" class="text-decoration-none"><c:out value="${salon.website}"/></a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="https://<c:out value='${salon.website}'/>" target="_blank" rel="noopener noreferrer" class="text-decoration-none"><c:out value="${salon.website}"/></a>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </c:if>
                        <p><i class="bi bi-clock-fill me-2 text-rose"></i> <strong>Availability:</strong>
                            <c:choose>
                                <c:when test="${not empty salon.availabilityHours}"><c:out value="${salon.availabilityHours}"/></c:when>
                                <c:otherwise><span class="text-muted">Not specified</span></c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${not empty salon.bio}">
                            <p class="mt-2 text-dark"><strong>About:</strong> ${salon.bio}</p>
                        </c:if>
                    </div>

                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/salon/reviews?id=${salon.id}#addReview" class="btn btn-outline-danger rounded-pill px-4">
                            <i class="bi bi-pen me-1"></i> Rate Us
                        </a>
                        <a href="${pageContext.request.contextPath}/salon/reviews?id=${salon.id}" class="btn btn-light rounded-pill px-4 border">
                            <i class="bi bi-star me-1"></i> View Reviews
                        </a>
                        <button type="button" class="btn btn-primary-custom btn-action-primary ms-auto" data-bs-toggle="modal" data-bs-target="#chatModal">
                            <i class="bi bi-chat-dots me-1"></i> Chat with Salon
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== QUICK STATS RIBBON ===== -->
        <div class="quick-stats-bar">
            <div class="row g-3">
                <div class="col-3 stat-item">
                    <h3>${not empty serviceList ? serviceList.size() : 0}</h3>
                    <p>Services</p>
                </div>
                <div class="col-3 stat-item border-start">
                    <h3>${not empty treatmentList ? treatmentList.size() : 0}</h3>
                    <p>Treatments</p>
                </div>
                <div class="col-3 stat-item border-start">
                    <h3>${not empty offerList ? offerList.size() : 0}</h3>
                    <p>Special Deals</p>
                </div>
                <div class="col-3 stat-item border-start">
                    <h3>${not empty stylists ? stylists.size() : 0}</h3>
                    <p>Stylists</p>
                </div>
            </div>
        </div>

        <!-- ===== ANCHOR TABS ===== -->
        <div class="section-tabs">
            <a href="#services-section" class="section-tab-btn active"><i class="bi bi-scissors me-1"></i> Services (${not empty serviceList ? serviceList.size() : 0})</a>
            <c:if test="${not empty treatmentList}">
                <a href="#treatments-section" class="section-tab-btn"><i class="bi bi-stars me-1"></i> Pricing Treatments (${treatmentList.size()})</a>
            </c:if>
            <c:if test="${not empty offerList}">
                <a href="#offers-section" class="section-tab-btn"><i class="bi bi-percent me-1"></i> Offers & Deals (${offerList.size()})</a>
            </c:if>
            <c:if test="${not empty stylists}">
                <a href="#stylists-section" class="section-tab-btn"><i class="bi bi-people me-1"></i> Experts (${stylists.size()})</a>
            </c:if>
        </div>

        <!-- ===== 1. SERVICES SECTION ===== -->
        <section id="services-section" class="mb-5">
            <h2 class="section-heading-title">
                <i class="bi bi-scissors text-rose"></i> Available Services
            </h2>

            <c:choose>
                <c:when test="${not empty serviceList}">
                    <div class="row g-4">
                        <c:forEach var="service" items="${serviceList}">
                            <div class="col-md-6 col-lg-4">
                                <div class="service-card">
                                    <c:choose>
                                        <c:when test="${not empty service.photoUrl}">
                                            <c:choose>
                                                <c:when test="${service.photoUrl.startsWith('http://') || service.photoUrl.startsWith('https://')}">
                                                    <c:set var="svcImg" value="${service.photoUrl}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="svcImg" value="${service.photoUrl.startsWith('/') ? service.photoUrl : '/'.concat(service.photoUrl)}"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="${svcImg}" alt="<c:out value='${service.name}'/>" class="service-card-img"
                                                 loading="lazy"
                                                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&q=80';">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&q=80" alt="<c:out value='${service.name}'/>" class="service-card-img" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div class="service-card-body">
                                        <span class="service-cat-badge">${service.category}</span>
                                        <h3 class="service-name">${service.name}</h3>
                                        
                                        <c:if test="${not empty service.ingredients}">
                                            <p class="text-muted small mb-2"><i class="bi bi-info-circle me-1"></i> ${service.ingredients}</p>
                                        </c:if>

                                        <div class="service-meta-row">
                                            <div>
                                                <span class="price-text">&#8377;<fmt:formatNumber value="${service.price}" type="number"/></span>
                                                <span class="duration-chip d-block"><i class="bi bi-clock me-1"></i> ${service.durationMinutes} mins</span>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button class="btn btn-outline-secondary btn-sm rounded-circle"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#serviceModal"
                                                        onclick="showServiceModal('${service.name}', '${service.category}', '${service.price}', '${service.durationMinutes}', '${service.ingredients}', '${service.allergenInfo}', '${pageContext.request.contextPath}${service.photoUrl}', '${service.salon.name}', '${service.id}')"
                                                        title="View Details">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <a href="${pageContext.request.contextPath}/booking/new?serviceId=${service.id}" class="btn btn-action-primary btn-sm px-3">
                                                    Book Now
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 bg-white rounded-4 border">
                        <i class="bi bi-calendar-x fs-1 text-muted"></i>
                        <p class="text-muted mt-2">No active services listed for this salon currently.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ===== 2. PRICING TREATMENTS SECTION ===== -->
        <c:if test="${not empty treatmentList}">
            <section id="treatments-section" class="mb-5">
                <h2 class="section-heading-title">
                    <i class="bi bi-stars text-rose"></i> Pricing Treatments
                </h2>
                <p class="text-muted mb-4">Select a treatment plan to view details and continue to booking.</p>

                <div class="row g-4">
                    <c:forEach var="treatment" items="${treatmentList}">
                        <div class="col-md-6 col-lg-4">
                            <div class="service-card p-4 h-100 d-flex flex-column">
                                <div class="text-center mb-3">
                                    <h4 class="m-0 fw-bold fs-5">${treatment.serviceName}</h4>
                                    <span class="price-text d-block mt-3">
                                        <sup style="font-size: 1rem; top: -0.4em;">&#8377;</sup>
                                        <fmt:formatNumber value="${treatment.price}" type="number" maxFractionDigits="0"/>
                                    </span>
                                    <span class="text-muted small d-block mt-1">
                                        <i class="bi bi-clock me-1"></i> ${treatment.duration} mins
                                    </span>
                                </div>

                                <p class="text-muted small mb-4 flex-grow-1 text-center">${treatment.description}</p>

                                <a href="${pageContext.request.contextPath}/booking/new?treatmentId=${treatment.id}"
                                   class="btn btn-action-primary w-100 py-3 fw-semibold">
                                    Get Started
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- ===== 3. SPECIAL OFFERS & DEALS ===== -->
        <c:if test="${not empty offerList}">
            <section id="offers-section" class="mb-5">
                <h2 class="section-heading-title">
                    <i class="bi bi-percent text-rose"></i> Exclusive Deals & Offers
                </h2>

                <div class="row g-4">
                    <c:forEach var="offer" items="${offerList}">
                        <div class="col-md-6 col-lg-4">
                            <div class="offer-card">
                                <span class="offer-discount-badge">-${offer.discountPercent}% OFF</span>
                                
                                <div>
                                    <h3 class="offer-title">${offer.title}</h3>
                                    <p class="offer-desc">${offer.description}</p>
                                </div>

                                <div>
                                    <div class="mb-3">
                                        <span class="fs-4 fw-bold text-warning">₹<fmt:formatNumber value="${offer.discountedPrice > 0 ? offer.discountedPrice : offer.originalPrice}" maxFractionDigits="0"/></span>
                                        <c:if test="${offer.originalPrice > 0}">
                                            <span class="text-white-50 text-decoration-line-through ms-2">₹<fmt:formatNumber value="${offer.originalPrice}" maxFractionDigits="0"/></span>
                                        </c:if>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/salon/book?offerId=${offer.id}" class="btn btn-light rounded-pill w-100 fw-bold py-2 text-dark">
                                        Claim & Book Offer
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- ===== 3.5. PACKAGES & MEMBERSHIPS ===== -->
        <c:if test="${not empty packages}">
            <section id="packages-section" class="mb-5">
                <h2 class="section-heading-title">
                    <i class="bi bi-box2-heart-fill text-rose"></i> Salon Packages
                </h2>
                <div class="row g-4">
                    <c:forEach var="pkg" items="${packages}">
                        <c:if test="${pkg.isActive}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card h-100 border-0 rounded-4 shadow-sm" style="background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);">
                                    <div class="card-body p-4 d-flex flex-column">
                                        <h3 class="fw-bold mb-1 text-dark fs-4">${pkg.packageName}</h3>
                                        <div class="fs-3 fw-bold text-primary mb-3">₹${pkg.price}</div>
                                        <p class="text-muted small mb-4">${pkg.description}</p>
                                        
                                        <c:if test="${not empty pkg.includedServices}">
                                            <div class="mb-4">
                                                <h6 class="fw-bold text-dark mb-2">Included Services:</h6>
                                                <ul class="list-unstyled mb-0">
                                                    <c:forEach var="service" items="${pkg.includedServices}">
                                                        <li class="mb-1 text-secondary"><i class="bi bi-check2-circle text-success me-2"></i>${service.name}</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:if>
                                        
                                        <div class="mt-auto">
                                            <a href="${pageContext.request.contextPath}/booking/new?packageId=${pkg.id}" class="btn btn-action-primary rounded-pill w-100 py-2">
                                                Book Package
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <c:if test="${not empty memberships}">
            <section id="memberships-section" class="mb-5">
                <h2 class="section-heading-title">
                    <i class="bi bi-stars text-rose"></i> Premium Memberships
                </h2>
                <div class="row g-4">
                    <c:forEach var="mem" items="${memberships}">
                        <c:if test="${mem.isActive}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card h-100 border-0 rounded-4 shadow-sm text-white" style="background: linear-gradient(135deg, #1e1e1e 0%, #2d2d2d 100%);">
                                    <div class="card-body p-4 d-flex flex-column">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="bi bi-award-fill text-warning fs-3 me-2"></i>
                                            <h3 class="fw-bold mb-0 fs-4">${mem.membershipName}</h3>
                                        </div>
                                        <div class="fs-2 fw-bold text-warning mb-2">₹${mem.price}</div>
                                        <div class="badge bg-light text-dark mb-3 w-50" style="font-size: 0.85rem;"><i class="bi bi-calendar-check me-1"></i> Valid for ${mem.durationInMonths} Month(s)</div>
                                        
                                        <div class="text-light opacity-75 small mb-4" style="white-space: pre-line;">${mem.benefits}</div>
                                        
                                        <div class="mt-auto">
                                            <a href="${pageContext.request.contextPath}/booking/new?membershipId=${mem.id}" class="btn btn-warning rounded-pill w-100 py-2 fw-bold text-dark">
                                                Join Membership
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- ===== 4. MEET OUR STYLISTS ===== -->
        <c:if test="${not empty stylists}">
            <section id="stylists-section" class="mb-5">
                <h2 class="section-heading-title">
                    <i class="bi bi-people text-rose"></i> Expert Hair & Beauty Stylists
                </h2>

                <div class="row g-4">
                    <c:forEach var="stylist" items="${stylists}">
                        <div class="col-md-6 col-lg-4">
                            <div class="stylist-card">
                                <c:choose>
                                    <c:when test="${not empty stylist.profileImage}">
                                        <c:choose>
                                            <c:when test="${stylist.profileImage.startsWith('http://') || stylist.profileImage.startsWith('https://')}">
                                                <c:set var="stylistImg" value="${stylist.profileImage}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:url var="stylistImg" value="${stylist.profileImage.startsWith('/') ? stylist.profileImage : '/'.concat(stylist.profileImage)}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <img src="${stylistImg}"
                                             alt="<c:out value='${stylist.firstName}'/>" class="stylist-avatar"
                                             loading="lazy"
                                             onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80" alt="<c:out value='${stylist.firstName}'/>" class="stylist-avatar" loading="lazy">
                                    </c:otherwise>
                                </c:choose>

                                <h4 class="fw-bold mb-1">${stylist.firstName} ${stylist.lastName}</h4>
                                <p class="text-rose font-weight-bold small mb-2">${stylist.specialization}</p>

                                <div class="d-flex align-items-center justify-content-center gap-3 text-muted small mb-3">
                                    <span><i class="bi bi-briefcase me-1"></i> ${stylist.experienceInYears} Years Exp</span>
                                    <c:if test="${stylist.rating != null && stylist.rating > 0}">
                                        <span><i class="bi bi-star-fill text-warning me-1"></i> <fmt:formatNumber value="${stylist.rating}" maxFractionDigits="1"/></span>
                                    </c:if>
                                </div>

                                <a href="${pageContext.request.contextPath}/user/stylist/view?id=${stylist.id}" class="btn btn-outline-danger btn-sm rounded-pill px-4 w-100">
                                    View Profile & Schedule
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </div>

    <!-- ===== SERVICE DETAILS MODAL ===== -->
    <div class="modal fade" id="serviceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
                <div class="modal-header bg-soft-pink border-0">
                    <h5 class="modal-title fw-bold text-dark" id="modalName">Service Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-5">
                            <img id="modalImage" src="" class="img-fluid rounded-3 shadow-sm w-100" style="height: 260px; object-fit: cover;" alt="Service">
                        </div>
                        <div class="col-md-7">
                            <span id="modalCategory" class="service-cat-badge mb-2">Category</span>
                            <h3 id="modalTitle" class="fw-bold text-dark mb-2"></h3>
                            <p class="text-muted mb-3"><i class="bi bi-shop me-1"></i> <span id="modalSalon"></span></p>
                            
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <span class="price-text fs-3">₹<span id="modalPrice"></span></span>
                                <span class="duration-chip"><i class="bi bi-clock me-1"></i> <span id="modalDuration"></span> mins</span>
                            </div>

                            <hr>

                            <p class="small text-muted mb-1"><strong>Ingredients:</strong> <span id="modalIngredients">N/A</span></p>
                            <p class="small text-muted mb-0"><strong>Allergen Info:</strong> <span id="modalAllergens">None</span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <a id="modalBookBtn" href="#" class="btn btn-action-primary px-4">Book Service Now</a>
                </div>
            </div>
        </div>
    </div>


    <!-- ===== CHAT MODAL ===== -->
    <div class="modal fade" id="chatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden" style="height: 85vh; max-height: 600px;">
                <div class="modal-header bg-soft-pink border-0" style="flex-shrink: 0;">
                    <h5 class="modal-title fw-bold text-dark">Chat with ${salon.name}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0 d-flex flex-column bg-light" style="overflow: hidden;">
                    <div id="chatMessages" class="flex-grow-1 p-3" style="overflow-y: auto;">
                        <div class="text-center p-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                    <div class="p-3 bg-white border-top" style="flex-shrink: 0;">
                        <form id="chatForm" class="d-flex gap-2 m-0">
                            <input type="text" id="chatInput" class="form-control rounded-pill px-4" placeholder="Type your message..." required autocomplete="off">
                            <button type="submit" class="btn btn-action-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; flex-shrink: 0;">
                                <i class="bi bi-send-fill"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>


        </div><!-- /#page-content-wrapper -->
    </div><!-- /#wrapper -->

    <!-- Bootstrap Bundle JS -->
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        function showServiceModal(name, category, price, duration, ingredients, allergens, photoUrl, salonName, serviceId) {
            document.getElementById("modalName").textContent = name;
            document.getElementById("modalTitle").textContent = name;
            document.getElementById("modalCategory").textContent = category;
            document.getElementById("modalPrice").textContent = price;
            document.getElementById("modalDuration").textContent = duration;
            document.getElementById("modalIngredients").textContent = ingredients || "Standard Salon Quality Products";
            document.getElementById("modalAllergens").textContent = allergens || "None reported";
            document.getElementById("modalSalon").textContent = salonName;
            document.getElementById("modalImage").src = photoUrl || "https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500";
            document.getElementById("modalBookBtn").href = "${pageContext.request.contextPath}/booking/new?serviceId=" + serviceId;
        }

        // Chat functionality
        let stompClient = null;
        let isConnected = false;
        const currentUserId = ${sessionScope.user != null ? sessionScope.user.id : 'null'};
        const salonId = ${salon.id};

        let chatPollInterval = null;

        document.getElementById('chatModal').addEventListener('show.bs.modal', function () {
            if (!currentUserId) {
                alert("Please log in to chat with the salon.");
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }
            if (!isConnected) {
                connectWebSocket();
            }
            fetchChatHistory();
            // Poll every 3 seconds as fallback for salon replies
            chatPollInterval = setInterval(fetchChatHistory, 3000);
        });

        document.getElementById('chatModal').addEventListener('hide.bs.modal', function () {
            if (chatPollInterval) {
                clearInterval(chatPollInterval);
                chatPollInterval = null;
            }
        });

        function connectWebSocket() {
            initStomp();
        }

        function initStomp() {
            if (typeof SockJS === 'undefined' || typeof Stomp === 'undefined') {
                console.error('SockJS or Stomp not loaded');
                return;
            }
            const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;
            stompClient.connect({}, function (frame) {
                isConnected = true;
                stompClient.subscribe('/topic/salon/chat/' + salonId, function (message) {
                    const msg = JSON.parse(message.body);
                    appendMessage(msg);
                });
            }, function(error) {
                console.error('STOMP error:', error);
            });
        }

        let lastMessageId = null;

        function fetchChatHistory() {
            fetch('${pageContext.request.contextPath}/api/salon/chat?salonId=' + salonId)
                .then(response => {
                    if (response.status === 401) {
                        return []; // Not logged in properly or API changed
                    }
                    return response.json();
                })
                .then(messages => {
                    if (!messages || !messages.length) {
                        if (!lastMessageId) {
                            document.getElementById('chatMessages').innerHTML = '<div class="text-center text-muted p-4">No previous messages. Start a conversation!</div>';
                        }
                        return;
                    }
                    // Show all messages for this user: messages sent BY user AND replies FROM salon to this user
                    const conversation = messages.filter(m => m.userId != null && String(m.userId) === String(currentUserId));
                    
                    if (conversation.length === 0) {
                        if (!lastMessageId) {
                            document.getElementById('chatMessages').innerHTML = '<div class="text-center text-muted p-4">No previous messages. Start a conversation!</div>';
                        }
                        return;
                    }
                    
                    // Only re-render if there are new messages (avoid flicker on poll)
                    const newestId = conversation[conversation.length - 1].id;
                    if (newestId === lastMessageId) return; // No change, skip re-render
                    lastMessageId = newestId;
                    
                    const chatMessages = document.getElementById('chatMessages');
                    chatMessages.innerHTML = '';
                    conversation.forEach(msg => appendMessage(msg));
                    scrollToBottom();
                })
                .catch(err => {
                    console.error('Error fetching chat history:', err);
                });
        }

        function appendMessage(msg) {
            console.log("Received message:", msg);
            const chatMessages = document.getElementById('chatMessages');
            if (chatMessages.innerHTML.includes("No previous messages") || chatMessages.innerHTML.includes("spinner-border")) {
                chatMessages.innerHTML = '';
            }

            const msgUserId = msg.userId;

            // isMine = true when the USER sent the message (shown on right, blue)
            const isMine = msg.senderRole === 'USER' && String(msgUserId) === String(currentUserId);
            
            // Only show messages that belong to this user's conversation:
            // - USER messages sent by this user
            // - SALON replies that are addressed to this user (userId matches)
            if (String(msgUserId) !== String(currentUserId)) {
                // Not part of this user's conversation, skip
                return;
            }

            const div = document.createElement('div');
            div.className = 'mb-3 ' + (isMine ? 'text-end' : 'text-start');
            
            const bubble = document.createElement('div');
            bubble.className = 'd-inline-block p-3 rounded-4 shadow-sm ' + (isMine ? 'bg-primary text-white' : 'bg-white text-dark');
            bubble.style.maxWidth = '75%';
            bubble.style.textAlign = 'left';
            
            let time;
            if (Array.isArray(msg.timestamp)) {
                // Handle Jackson LocalDateTime array: [year, month, day, hour, minute, second, ...]
                // Month is 1-indexed in Java, 0-indexed in JS Date
                time = new Date(msg.timestamp[0], msg.timestamp[1] - 1, msg.timestamp[2], msg.timestamp[3], msg.timestamp[4], msg.timestamp[5] || 0);
            } else {
                time = new Date(msg.timestamp || Date.now());
            }

            let timeStr = "";
            if (!isNaN(time.getTime())) {
                timeStr = time.getHours().toString().padStart(2, '0') + ':' + time.getMinutes().toString().padStart(2, '0');
            } else {
                timeStr = "now";
            }
            
            bubble.innerHTML = (msg.message || '') + '<br><small class="opacity-75" style="font-size: 0.7em;">' + timeStr + '</small>';
            
            div.appendChild(bubble);
            chatMessages.appendChild(div);
            scrollToBottom();
        }

        function scrollToBottom() {
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        document.getElementById('chatForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if (message && isConnected) {
                stompClient.send("/app/salon/chat", {}, JSON.stringify({
                    salonId: salonId,
                    userId: currentUserId,
                    senderRole: 'USER',
                    message: message
                }));
                input.value = '';
            }
        });
    </script>
</body>
</html>
