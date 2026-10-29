<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${event.name} — Women Events</title>
    <meta name="description" content="${event.description}"/>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    
    <!-- Event detail theme only — cream / plum / pink. No global palette. -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/detail-premium.css?v=20260901"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css"/>
    <style>
        :root {
            --bg-primary: #F8FAFC;
            --bg-card: #FFFFFF;
            --bg-secondary: #FFF1F2;
            --border-neutral: #E2E8F0;
            --border-secondary: #FDA4AF;
            --color-accent: #F43F5E;
            --color-accent-hover: #E11D48;
            --text-primary: #0F172A;
            --text-secondary: #64748B;
            --shadow-sm: 0 4px 12px rgba(15, 23, 42, 0.04);
            --shadow-md: 0 12px 30px rgba(15, 23, 42, 0.07);
            --shadow-lg: 0 20px 48px rgba(15, 23, 42, 0.1);
        }
        body {
            background-color: #F8FAFC !important;
            color: #0F172A !important;
            font-family: 'Outfit', sans-serif;
        }
        #page-content-wrapper {
            background-color: #F8FAFC !important;
            color: #0F172A !important;
            padding: 0 0 80px 0 !important;
            min-height: 100vh;
        }
        .top-action-bar {
            max-width: 1240px;
            margin: 0 auto;
            padding: 20px 24px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .btn-back-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            color: #0F172A;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 8px 18px;
            border-radius: 99px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-back-pill:hover {
            background: #F1F5F9;
            color: #F43F5E;
            transform: translateX(-2px);
        }
        /* Event Hero */
        .event-hero { 
            position: relative !important;
            width: 100% !important;
            min-height: 420px !important;
            height: auto !important;
            background: #0F172A !important;
            overflow: hidden !important;
            display: flex !important;
            align-items: flex-end !important;
        }
        .event-hero .hero-bg-img {
            position: absolute !important;
            inset: 0 !important;
            width: 100% !important;
            height: 100% !important;
            object-fit: cover !important;
            z-index: 0 !important;
        }
        .hero-overlay {
            position: absolute !important;
            inset: 0 !important;
            background: linear-gradient(180deg, rgba(15, 23, 42, 0.35) 0%, rgba(15, 23, 42, 0.75) 55%, rgba(15, 23, 42, 0.95) 100%) !important;
            z-index: 1 !important;
            opacity: 1 !important;
        }
        .hero-content {
            position: relative !important;
            z-index: 2 !important;
            padding: 48px 24px 40px !important;
            max-width: 1240px !important;
            margin: 0 auto !important;
            width: 100% !important;
            box-sizing: border-box !important;
        }
        .hero-cat-badge {
            background-color: #F43F5E !important;
            color: #FFFFFF !important;
            font-weight: 700 !important;
            font-size: 0.82rem !important;
            padding: 6px 16px !important;
            border-radius: 99px !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 6px !important;
            margin-bottom: 14px !important;
            border: none !important;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.4) !important;
        }
        .event-title {
            font-size: clamp(2rem, 4.5vw, 3.2rem) !important;
            font-weight: 800 !important;
            line-height: 1.2 !important;
            margin-bottom: 16px !important;
            color: #FFFFFF !important;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.45) !important;
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .hero-meta {
            display: flex !important;
            flex-wrap: wrap !important;
            gap: 12px !important;
            font-size: 0.92rem !important;
            font-weight: 500 !important;
        }
        .hero-meta span {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            background: rgba(255, 255, 255, 0.14) !important;
            backdrop-filter: blur(8px) !important;
            -webkit-backdrop-filter: blur(8px) !important;
            border: 1px solid rgba(255, 255, 255, 0.22) !important;
            border-radius: 99px !important;
            padding: 6px 16px !important;
            color: #FFFFFF !important;
        }
        .hero-meta span i {
            color: #FDA4AF !important;
        }
        .hero-featured-badge {
            background: linear-gradient(135deg, #F59E0B, #D97706) !important;
            border: none !important;
            padding: 6px 16px !important;
            border-radius: 99px !important;
            font-weight: 700 !important;
            color: #FFFFFF !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 6px !important;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3) !important;
        }
        /* Detail Grid */
        .detail-grid { 
            display: grid !important; 
            grid-template-columns: minmax(0, 1fr) 380px !important; 
            gap: 32px !important;
            max-width: 1240px !important; 
            margin: 28px auto 0 !important; 
            padding: 0 24px 60px !important;
            width: 100% !important;
            box-sizing: border-box !important;
        }
        .main-content-column {
            min-width: 0 !important;
            width: 100% !important;
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .sidebar-column {
            width: 380px !important;
            max-width: 100% !important;
        }
        .register-sidebar {
            position: sticky !important;
            top: 96px !important;
            z-index: 10 !important;
            display: flex !important;
            flex-direction: column !important;
            gap: 20px !important;
        }
        .card-block {
            background-color: #FFFFFF !important;
            border: 1px solid #E2E8F0 !important;
            border-radius: 20px !important;
            padding: 32px !important;
            margin-bottom: 24px !important;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.03) !important;
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .card-block p {
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .block-title {
            font-size: 1.2rem !important;
            font-weight: 800 !important;
            color: #0F172A !important;
            margin-bottom: 20px !important;
            padding-bottom: 12px !important;
            border-bottom: 1px solid #F1F5F9 !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }
        .block-title i {
            color: #F43F5E !important;
        }
        .sidebar-card {
            background-color: #FFFFFF !important;
            border: 1px solid #E2E8F0 !important;
            border-radius: 20px !important;
            padding: 32px !important;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.04) !important;
            margin-bottom: 0 !important;
        }
        .sidebar-price {
            font-size: 2.25rem !important;
            font-weight: 800 !important;
            color: #0F172A !important;
            margin-bottom: 2px !important;
        }
        .sidebar-price-sub {
            font-size: 0.88rem !important;
            color: #64748B !important;
            margin-bottom: 24px !important;
        }
        .sidebar-meta-list {
            display: flex !important;
            flex-direction: column !important;
            gap: 16px !important;
            margin-bottom: 24px !important;
        }
        .sidebar-meta-item {
            display: flex !important;
            align-items: flex-start !important;
            gap: 14px !important;
            font-size: 0.92rem !important;
            padding-bottom: 12px !important;
            border-bottom: 1px solid #F1F5F9 !important;
        }
        .sidebar-meta-item:last-child {
            border-bottom: none !important;
            padding-bottom: 0 !important;
        }
        .sidebar-meta-item i {
            color: #F43F5E !important;
            font-size: 1.2rem !important;
            margin-top: 2px !important;
        }
        .sidebar-meta-item .meta-label {
            color: #64748B !important;
            font-weight: 600 !important;
            font-size: 0.8rem !important;
            text-transform: uppercase !important;
            letter-spacing: 0.5px !important;
        }
        .sidebar-meta-item .meta-value {
            color: #0F172A !important;
            font-weight: 700 !important;
            margin-top: 2px !important;
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .btn-premium-cta {
            width: 100% !important;
            background: linear-gradient(135deg, #F43F5E 0%, #E11D48 100%) !important;
            color: #FFFFFF !important;
            border: none !important;
            padding: 16px 24px !important;
            border-radius: 99px !important;
            font-weight: 700 !important;
            font-size: 1.05rem !important;
            box-shadow: 0 8px 24px rgba(244, 63, 94, 0.35) !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 10px !important;
            text-decoration: none !important;
            transition: all 0.25s ease !important;
        }
        .btn-premium-cta:hover {
            background: linear-gradient(135deg, #E11D48 0%, #BE123C 100%) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 12px 28px rgba(244, 63, 94, 0.45) !important;
            color: #FFFFFF !important;
        }
        .btn-premium-cta:disabled {
            background: #94A3B8 !important;
            box-shadow: none !important;
            transform: none !important;
            cursor: not-allowed !important;
        }
        .we-fact-grid {
            display: grid !important;
            grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)) !important;
            gap: 16px !important;
        }
        .we-fact {
            background: #F8FAFC !important;
            border: 1px solid #E2E8F0 !important;
            border-radius: 14px !important;
            padding: 14px 18px !important;
        }
        .we-fact .k {
            font-size: 0.78rem !important;
            text-transform: uppercase !important;
            letter-spacing: 0.05em !important;
            font-weight: 700 !important;
            color: #64748B !important;
            margin-bottom: 4px !important;
        }
        .we-fact .v {
            font-size: 1.02rem !important;
            font-weight: 700 !important;
            color: #0F172A !important;
            overflow-wrap: anywhere !important;
            word-break: break-word !important;
        }
        .bottom-registration-cta {
            background: linear-gradient(135deg, #FFFFFF 0%, #FFF1F2 100%) !important;
            border: 1px solid #FDA4AF !important;
            border-radius: 24px !important;
            padding: 40px 24px !important;
            text-align: center !important;
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.06) !important;
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            gap: 16px !important;
        }
        .bottom-registration-cta h3 {
            color: #0F172A !important;
            font-weight: 800 !important;
            font-size: 1.8rem !important;
            margin-bottom: 0 !important;
        }
        .bottom-registration-cta p {
            color: #64748B !important;
            max-width: 600px !important;
            margin-bottom: 4px !important;
        }
        .bottom-registration-cta .btn-premium-cta {
            max-width: 340px !important;
        }
        .reserved-pill {
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            background: #16A34A !important;
            color: #FFFFFF !important;
            padding: 12px 24px !important;
            border-radius: 99px !important;
            font-weight: 700 !important;
        }
        .btn-share-pill {
            background: #F43F5E !important;
            color: #FFFFFF !important;
            border: none !important;
            border-radius: 99px !important;
            padding: 10px 20px !important;
            font-weight: 700 !important;
            text-decoration: none !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 8px !important;
            transition: all 0.2s ease !important;
        }
        .btn-share-pill:hover {
            background: #E11D48 !important;
            color: #FFFFFF !important;
        }
        .btn-share-outline {
            background: transparent !important;
            color: #F43F5E !important;
            border: 1px solid #FDA4AF !important;
        }
        .btn-share-outline:hover {
            background: #FFF1F2 !important;
            color: #E11D48 !important;
        }
        .registered-badge-box {
            background: #F0FDF4 !important;
            border: 1px solid #86EFAC !important;
            color: #166534 !important;
            border-radius: 16px !important;
            padding: 20px !important;
            text-align: center !important;
        }
        .registered-badge-box i {
            font-size: 2rem !important;
            color: #16A34A !important;
            margin-bottom: 8px !important;
            display: block !important;
        }
        .registered-badge-box h5 {
            font-weight: 800 !important;
            color: #166534 !important;
            margin-bottom: 8px !important;
        }
        .ticket-link {
            display: inline-flex !important;
            align-items: center !important;
            gap: 6px !important;
            color: #16A34A !important;
            font-weight: 700 !important;
            text-decoration: none !important;
            border: 1px solid #86EFAC !important;
            padding: 6px 14px !important;
            border-radius: 99px !important;
            background: #FFFFFF !important;
        }
        .mobile-sticky-action-bar { display: none; }
        @media (max-width: 991px) {
            .detail-grid { 
                grid-template-columns: 1fr !important; 
                gap: 24px !important;
                padding: 0 16px 40px !important; 
            }
            .sidebar-column { 
                width: 100% !important;
                margin-top: 10px !important; 
            }
            .register-sidebar { 
                position: static !important; 
            }
            .mobile-sticky-action-bar { display: none !important; }
            .event-hero { min-height: 320px !important; }
            .hero-content { padding: 32px 16px 24px !important; }
        }
        @media (max-width: 575px) {
            .event-title { font-size: 1.8rem !important; }
            .we-fact-grid { grid-template-columns: 1fr !important; }
            .bottom-registration-cta { padding: 28px 16px !important; }
            .bottom-registration-cta h3 { font-size: 1.4rem !important; }
            .hero-meta { flex-direction: column !important; gap: 8px !important; }
            .hero-meta span { width: 100% !important; }
            .card-block { padding: 20px 16px !important; }
        }
    </style>
    <!-- Custom Theme & Detail Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css"/>
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    <style>
      .we-modal-overlay { display:none; position:fixed; inset:0; background:rgba(15,23,42,.45); z-index:2000; align-items:center; justify-content:center; padding:20px; }
      .we-modal-overlay.open { display:flex; }
    </style>
</head>
<body>

<!-- Header Component -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <!-- Sidebar Component -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip;" data-skip-global-back="true">
        <!-- Top Action & Navigation Bar -->
        <div class="top-action-bar">
            <a href="${pageContext.request.contextPath}/women-events" class="btn-back-pill">
                <i class="bi bi-arrow-left"></i> Back to Events
            </a>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0" style="font-size: 0.88rem;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events" style="color: #64748B; text-decoration: none;">Events</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events?category=${event.category}" style="color: #64748B; text-decoration: none;">${event.category.displayName}</a></li>
                    <li class="breadcrumb-item active" aria-current="page" style="color: #0F172A; font-weight: 600;">${event.name}</li>
                </ol>
            </nav>
        </div>

        <!-- Alert Banners -->
        <c:if test="${not empty success}">
            <div class="flash-alert alert alert-dismissible fade show mx-4 mt-2 mb-3" role="alert" style="background:#F0FDF4; border:1px solid #86EFAC; color:#166534; border-radius: 14px;">
                <i class="bi bi-check-circle-fill me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-alert alert alert-dismissible fade show mx-4 mt-2 mb-3" role="alert" style="background:#FFF1F2; border:1px solid #FDA4AF; color:#9F1239; border-radius: 14px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Premium Hero Section -->
        <div class="event-hero">
            <c:choose>
                <c:when test="${not empty event.bannerImage}">
                    <c:set var="bannerImg" value="${event.bannerImage}" />
                    <c:choose>
                        <c:when test="${bannerImg.startsWith('http://') or bannerImg.startsWith('https://')}">
                            <c:set var="resolvedBanner" value="${bannerImg}" />
                        </c:when>
                        <c:when test="${bannerImg.startsWith('/uploads/')}">
                            <c:set var="resolvedBanner" value="${pageContext.request.contextPath}${bannerImg}" />
                        </c:when>
                        <c:when test="${bannerImg.startsWith('/')}">
                            <c:set var="resolvedBanner" value="${pageContext.request.contextPath}${bannerImg}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="resolvedBanner" value="${pageContext.request.contextPath}/uploads/${bannerImg}" />
                        </c:otherwise>
                    </c:choose>
                    <img class="hero-bg-img" src="${resolvedBanner}" alt="${event.name}" onerror="this.style.display='none';"/>
                </c:when>
                <c:otherwise>
                    <!-- Fallback abstract premium background pattern if banner is missing -->
                    <div style="position: absolute; inset: 0; background: linear-gradient(135deg, #0F172A 0%, #1E293B 55%, #334155 100%);"></div>
                </c:otherwise>
            </c:choose>
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <span class="hero-cat-badge">
                    <i class="bi bi-bookmark-heart-fill"></i> ${event.category.displayName}
                </span>
                <h1 class="event-title">${event.name}</h1>
                <div class="hero-meta">
                    <span><i class="bi bi-calendar3"></i> ${event.eventDate} <c:if test="${not empty event.eventTime}">at ${event.eventTime}</c:if></span>
                    <span><i class="bi bi-geo-alt-fill"></i> ${event.venue}, ${event.city}</span>
                    <span><i class="bi bi-building-fill-check"></i> By ${event.organizerName}</span>
                    <c:if test="${event.featured}">
                        <span class="hero-featured-badge">
                            <i class="bi bi-star-fill"></i> Featured
                        </span>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Two-Column Page Layout -->
        <div class="detail-grid">
            
            <!-- Left Grid: Event Contents -->
            <div class="main-content-column">
                
                <!-- About Block -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-info-circle-fill"></i> About The Event</div>
                    <p style="color: var(--text-primary); font-size: 1.05rem; line-height: 1.8; white-space: pre-line; margin-bottom: 0;">
                        <c:choose>
                            <c:when test="${not empty event.description}">${event.description}</c:when>
                            <c:otherwise>Not provided</c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="card-block">
                    <div class="block-title"><i class="bi bi-calendar-event"></i> Event details</div>
                    <div class="we-fact-grid">
                        <div class="we-fact"><div class="k">Date</div><div class="v">${not empty event.eventDate ? event.eventDate : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Time</div><div class="v">${not empty event.eventTime ? event.eventTime : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Venue</div><div class="v">${not empty event.venue ? event.venue : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">City</div><div class="v">${not empty event.city ? event.city : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Mode</div><div class="v">${event.virtual ? 'Online' : 'In person'}</div></div>
                        <div class="we-fact"><div class="k">Capacity</div><div class="v">${event.maxParticipants != null ? event.maxParticipants : 'Not limited'}</div></div>
                        <div class="we-fact"><div class="k">Entry</div><div class="v"><c:choose><c:when test="${event.free}">Free</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></div></div>
                        <div class="we-fact"><div class="k">Registered</div><div class="v">${registrationCount}</div></div>
                    </div>
                    <c:if test="${event.virtual && not empty event.streamLink}">
                        <p class="mt-3 mb-0 small text-muted">Stream link is shared with registered attendees.</p>
                    </c:if>
                </div>

                <div class="card-block">
                    <div class="block-title"><i class="bi bi-building"></i> Organizer</div>
                    <div class="we-fact-grid">
                        <div class="we-fact"><div class="k">Name</div><div class="v">${not empty event.organizerName ? event.organizerName : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Type</div><div class="v">${not empty event.organizerType ? event.organizerType : 'Not provided'}</div></div>
                        <div class="we-fact" style="grid-column:1 / -1;"><div class="k">Contact</div><div class="v">${not empty event.contactInfo ? event.contactInfo : 'Not provided'}</div></div>
                    </div>
                </div>

                <!-- Map & Directions -->
                <c:if test="${not empty event.mapsLocation || (not empty event.venue and not empty event.city)}">
                    <c:set var="cleanMapQuery" value="${event.mapsLocation}" />
                    <c:if test="${not empty cleanMapQuery and cleanMapQuery.contains('q=')}">
                        <c:set var="cleanMapQuery" value="${cleanMapQuery.substring(cleanMapQuery.indexOf('q=') + 2)}" />
                        <c:if test="${cleanMapQuery.contains('&')}">
                            <c:set var="cleanMapQuery" value="${cleanMapQuery.substring(0, cleanMapQuery.indexOf('&'))}" />
                        </c:if>
                    </c:if>
                    <c:if test="${empty cleanMapQuery}">
                        <c:set var="cleanMapQuery" value="${event.venue}, ${event.city}" />
                    </c:if>
                    <c:set var="directionsLink" value="${event.mapsLocation}" />
                    <c:if test="${empty directionsLink || !directionsLink.startsWith('http')}">
                        <c:set var="directionsLink" value="https://maps.google.com/?q=${cleanMapQuery}" />
                    </c:if>

                    <div class="card-block">
                        <div class="block-title"><i class="bi bi-map-fill"></i> Location &amp; Directions</div>
                        <div class="map-container" style="position:relative; overflow:hidden; border-radius:18px; border:1px solid var(--border-neutral);">
                            <div id="eventDetailMap" style="width:100%; height:320px; background:#F1F5F9; z-index:1;"></div>
                            <div class="map-address-block" style="padding:16px 20px; background:#FFFFFF; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px; border-top:1px solid var(--border-neutral);">
                                <div>
                                    <h5 class="fw-bold mb-1" style="color: var(--text-primary); font-size: 1.05rem;">
                                        <i class="bi bi-geo-alt-fill me-2" style="color:#F43F5E;"></i> ${event.venue}
                                    </h5>
                                    <p class="text-muted small mb-0">
                                        <i class="bi bi-shield-check text-success me-1"></i> ${event.city} &bull; Safe Zone Verified
                                    </p>
                                </div>
                                <a href="${directionsLink}" target="_blank" rel="noopener noreferrer" class="btn-map-guide">
                                    <i class="bi bi-box-arrow-up-right me-1"></i> Get Directions in Google Maps
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Photo Gallery section -->
                <div class="card-block">
                    <div class="block-title">
                        <i class="bi bi-images"></i> Photo Gallery 
                        <span class="count-pill">${photos.size()} Files</span>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty photos}">
                            <div class="premium-gallery">
                                <c:forEach var="ph" items="${photos}">
                                    <div class="gallery-card-item" data-bs-toggle="modal" data-bs-target="#photoModal"
                                         onclick="document.getElementById('modalPhoto').src=this.querySelector('img').src">
                                        <img src="${pageContext.request.contextPath}/uploads/${ph.photoPath}" alt="${ph.caption}"/>
                                        <div class="gallery-overlay-effect">
                                            <i class="bi bi-zoom-in"></i>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="gallery-empty">
                                <i class="bi bi-flower1"></i>
                                <h5>No Gallery Photos Yet</h5>
                                <p>Be the first to share your positive visual experience from this event!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Upload Zone (if registered & event passed) -->
                    <c:if test="${alreadyRegistered && eventPassed && not empty loggedUser}">
                        <hr style="margin: 32px 0; border-color: var(--border-neutral);"/>
                        <div class="block-title" style="font-size:1.05rem;"><i class="bi bi-cloud-upload-fill"></i> Add Photo to Event Gallery</div>
                        <form action="${pageContext.request.contextPath}/women-events/${event.id}/upload-photo${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data">
                            <c:if test="${not empty _csrf}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            </c:if>
                            <div class="upload-zone" onclick="document.getElementById('photoFile').click()">
                                <i class="bi bi-camera-fill" style="font-size:2rem; color:var(--color-accent); display:block; margin-bottom:8px;"></i>
                                <div style="font-weight:700; color:var(--text-primary);">Click to pick a photo</div>
                                <div class="text-muted small">PNG, JPG or JPEG files up to 5MB supported</div>
                            </div>
                            <input type="file" id="photoFile" name="photo" accept="image/*" style="display:none;" required 
                                   onchange="this.form.querySelector('.upload-zone div').textContent=this.files[0].name"/>
                            <input type="text" name="caption" class="form-control mt-3" placeholder="Write a short photo caption (optional)"/>
                            <button type="submit" class="btn-premium-cta mt-3" style="padding: 12px 24px; font-size: 0.95rem; max-width: 250px;">
                                <i class="bi bi-cloud-arrow-up-fill"></i> Upload Image file
                            </button>
                        </form>
                    </c:if>
                </div>

                <!-- Reviews and Rating Section -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-star-fill"></i> Ratings &amp; Reviews</div>
                    
                    <div class="reviews-summary-box">
                        <div>
                            <div class="avg-rating-value">${avgRating > 0 ? avgRating : '—'}</div>
                            <div class="avg-rating-stars">
                                <c:forEach begin="1" end="${avgRating.intValue() > 0 ? avgRating.intValue() : 0}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                <c:forEach begin="${(avgRating.intValue() > 0 ? avgRating.intValue() : 0) + 1}" end="5" var="s"><i class="bi bi-star star-empty"></i></c:forEach>
                            </div>
                            <div class="text-muted text-center mt-2 small" style="font-weight: 600;">${reviews.size()} review${reviews.size() != 1 ? 's' : ''}</div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <div class="reviews-list-container">
                                <c:forEach var="rev" items="${reviews}">
                                    <div class="premium-review-card">
                                        <div class="review-card-header">
                                            <div class="reviewer-avatar-box">
                                                <div class="reviewer-avatar">${rev.user.fullName.substring(0,1).toUpperCase()}</div>
                                                <div>
                                                    <div class="reviewer-title-name">${rev.user.fullName}</div>
                                                    <div class="review-stars-metric">
                                                        <c:forEach begin="1" end="${rev.rating}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                                        <c:forEach begin="${rev.rating + 1}" end="5" var="s"><i class="bi bi-star star-empty"></i></c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="review-item-date">${rev.createdAt}</div>
                                        </div>
                                        <div class="review-body-text">${rev.reviewText}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 rounded-4" style="background: var(--bg-secondary); border: 1px dashed var(--border-neutral);">
                                <i class="bi bi-chat-heart text-muted mb-2" style="font-size: 2rem;"></i>
                                <p class="text-muted small mb-0">No reviews published yet for this event.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Critique Submission Form (registered & passed event) -->
                    <c:if test="${alreadyRegistered && eventPassed && not alreadyReviewed && not empty loggedUser}">
                        <hr style="margin: 32px 0; border-color: var(--border-neutral);"/>
                        <div class="block-title" style="font-size: 1.05rem;"><i class="bi bi-chat-quote-fill"></i> Share Your Review</div>
                        <form action="${pageContext.request.contextPath}/women-events/${event.id}/review" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <div class="mb-3">
                                <label class="form-label small text-muted font-weight-bold">Rate this Workshop</label>
                                <div class="star-input">
                                    <input type="radio" id="s5" name="rating" value="5" required/><label for="s5">★</label>
                                    <input type="radio" id="s4" name="rating" value="4"/><label for="s4">★</label>
                                    <input type="radio" id="s3" name="rating" value="3"/><label for="s3">★</label>
                                    <input type="radio" id="s2" name="rating" value="2"/><label for="s2">★</label>
                                    <input type="radio" id="s1" name="rating" value="1"/><label for="s1">★</label>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small text-muted font-weight-bold">Feedback Details</label>
                                <textarea name="reviewText" rows="4" required class="form-control" placeholder="Share how the event went for you..."></textarea>
                            </div>
                            <button type="submit" class="btn-premium-cta" style="max-width: 250px; padding: 12px 24px; font-size: 0.95rem;">
                                <i class="bi bi-send-fill"></i> Submit review
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- Right Grid: Sticky Registration/Details Sidebar -->
            <div class="sidebar-column">
                <div class="register-sidebar">
                    
                    <div class="sidebar-card">
                        <div class="sidebar-price"><c:choose><c:when test="${event.free}">FREE</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></div>
                        <div class="sidebar-price-sub">${event.free ? 'No entry fee' : 'Entry fee — paid at checkout'}</div>

                        <div class="sidebar-meta-list">
                            <div class="sidebar-meta-item">
                                <i class="bi bi-people-fill"></i>
                                <div>
                                    <div class="meta-label">Registered</div>
                                    <div class="meta-value">${registrationCount}<c:if test="${not empty event.maxParticipants}"> / ${event.maxParticipants}</c:if></div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-calendar3"></i>
                                <div>
                                    <div class="meta-label">Date</div>
                                    <div class="meta-value">${not empty event.eventDate ? event.eventDate : 'Not provided'}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-clock-fill"></i>
                                <div>
                                    <div class="meta-label">Time</div>
                                    <div class="meta-value">${not empty event.eventTime ? event.eventTime : 'Not provided'}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-geo-alt-fill"></i>
                                <div>
                                    <div class="meta-label">Venue</div>
                                    <div class="meta-value">${not empty event.venue ? event.venue : 'Not provided'}<c:if test="${not empty event.city}">, ${event.city}</c:if></div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-telephone-fill"></i>
                                <div>
                                    <div class="meta-label">Contact</div>
                                    <div class="meta-value">${not empty event.contactInfo ? event.contactInfo : 'Not provided'}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="sidebar-action-button-layer">
                            <c:choose>
                                <c:when test="${isOrganizerView}">
                                    <div class="registered-badge-box mb-3" style="background-color: #FFF1F2; border-color: #FECDD3;">
                                        <i class="bi bi-info-circle-fill" style="color:var(--we-accent);"></i>
                                        <h5 style="color:var(--we-navy); font-weight:700; margin-bottom:4px;">Organizer View</h5>
                                        <p style="font-size: 0.8rem; color: #64748B; margin-bottom: 8px;">You are the host of this event. Self-registration is restricted for organizers, but regular attendees see the active booking button.</p>
                                        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="ticket-link" style="border-color: #FECDD3; color: var(--we-accent);">
                                            <i class="bi bi-speedometer2"></i> Organizer Dashboard
                                        </a>
                                    </div>
                                    <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                                        <i class="bi bi-ticket-perforated-fill"></i>
                                        <c:choose>
                                            <c:when test="${event.free}">Preview Booking Flow (Free)</c:when>
                                            <c:otherwise>Review &amp; Pay ₹${event.entryFee} (Test Flow)</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <form id="eventRegisterForm" action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="display:none;"></form>
                                </c:when>
                                <c:when test="${empty loggedUser}">
                                    <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta">
                                        <i class="bi bi-person-circle"></i> Login to Register
                                    </a>
                                </c:when>
                                <c:when test="${alreadyRegistered}">
                                    <div class="registered-badge-box">
                                        <i class="bi bi-check-circle-fill"></i>
                                        <h5>Registration Active</h5>
                                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="ticket-link">
                                            <i class="bi bi-ticket-perforated-fill"></i> View My Ticket
                                        </a>
                                    </div>
                                </c:when>
                                <c:when test="${soldOut}">
                                    <button class="btn-premium-cta" disabled>
                                        <i class="bi bi-x-circle-fill"></i> SOLD OUT
                                    </button>
                                </c:when>
                                <c:when test="${registrationOpen == false}">
                                    <button class="btn-premium-cta" disabled>
                                        Registration for this event has closed.
                                    </button>
                                </c:when>
                                <c:when test="${eventPassed}">
                                    <button class="btn-premium-cta" disabled>
                                        <i class="bi bi-x-circle-fill"></i> Event has passed
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                                        <i class="bi bi-ticket-perforated-fill"></i>
                                        <c:choose>
                                            <c:when test="${event.free}">Review &amp; register</c:when>
                                            <c:otherwise>Review &amp; pay ₹${event.entryFee}</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <form id="eventRegisterForm" action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="display:none;">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"></form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr style="margin: 24px 0; border-color: var(--border-neutral);"/>
                        <div class="sidebar-extra">
                            <p class="mb-2"><i class="bi bi-shield-lock-fill me-2" style="color: #F43F5E;"></i> Verified identity protection system</p>
                            <p class="mb-0"><i class="bi bi-ticket-perforated-fill me-2" style="color: #16A34A;"></i> Digital ticket issued instantly upon confirmation</p>
                        </div>
                    </div>

                    <!-- Share Event Card structure -->
                    <div class="sidebar-card">
                        <h5 class="share-title"><i class="bi bi-share-fill"></i> Spread the Word</h5>
                        <div class="share-links-wrapper">
                            <a href="https://wa.me/?text=Check+out+this+workshop:+${event.name}+at+${pageContext.request.contextPath}/women-events/${event.id}"
                               target="_blank" class="btn-share-pill"><i class="bi bi-whatsapp"></i> Share on WhatsApp</a>
                            <button type="button" onclick="navigator.clipboard.writeText(window.location.href).then(()=>alert('Link copied!'))"
                                    class="btn-share-pill btn-share-outline"><i class="bi bi-link-45deg"></i> Copy Details Link</button>
                        </div>
                    </div>

                </div>
            </div>
            
        </div>

        <!-- Full-Width Bottom Registration CTA Banner -->
        <div class="container px-3 pb-5" style="max-width: 1200px; margin: 0 auto;">
            <div class="bottom-registration-cta">
                <h3>Register for ${event.name}</h3>
                <p>Review your booking details, then confirm. A ticket code is issued after registration.</p>
                <c:choose>
                    <c:when test="${isOrganizerView}">
                        <div class="mb-3">
                            <span class="reserved-pill" style="background-color: #FFF1F2; color: var(--we-accent); border: 1px solid #FECDD3;">
                                <i class="bi bi-info-circle-fill me-1"></i> Organizer View: Self-booking is restricted for event hosts. Regular attendees see the active booking option below.
                            </span>
                        </div>
                        <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                            <i class="bi bi-ticket-perforated-fill"></i>
                            <c:choose>
                                <c:when test="${event.free}">Review &amp; Register</c:when>
                                <c:otherwise>Review &amp; Pay ₹${event.entryFee}</c:otherwise>
                            </c:choose>
                        </button>
                    </c:when>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta">
                            <i class="bi bi-person-circle"></i> Login and register
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <div class="reserved-pill">
                            <i class="bi bi-check-circle-fill"></i> Seat Reserved &amp; Confirmed
                        </div>
                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="btn-premium-cta">
                            <i class="bi bi-ticket-perforated-fill"></i> View my ticket
                        </a>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="background:#555;">Event complete</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                            <i class="bi bi-ticket-perforated-fill"></i> Review &amp; register
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Mobile Sticky Bottom Buy Row -->
        <div class="mobile-sticky-action-bar">
            <div class="mobile-sticky-inner">
                <div class="mobile-price-section">
                    <span class="mobile-price-value"><c:choose><c:when test="${event.free}">FREE</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></span>
                    <span class="mobile-price-lbl">Entry</span>
                </div>
                <c:choose>
                    <c:when test="${isOrganizerView}">
                        <button type="button" class="btn-premium-cta" style="padding: 10px 18px; font-size: 0.85rem; width: auto;" onclick="openEventReviewModal()">
                            <i class="bi bi-ticket-perforated-fill me-1"></i> Book ₹${event.entryFee}
                        </button>
                    </c:when>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
                            <i class="bi bi-person-circle"></i> Login
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <span class="reserved-pill compact"><i class="bi bi-check-circle-fill me-1"></i> Registered</span>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="padding: 12px 24px; font-size: 0.9rem; width: auto;">Passed</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
                            <i class="bi bi-ticket-perforated-fill"></i> Register
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Lightbox Photo Viewer Modal -->
        <div class="modal fade" id="photoModal" tabindex="-1" style="backdrop-filter: blur(10px);">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 bg-transparent">
                    <div class="modal-body p-0 text-center">
                        <img id="modalPhoto" src="" style="max-width:100%; border-radius:16px; max-height:85vh; box-shadow: var(--shadow-lg); border: 2px solid white;"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- Booking review -->
        <div id="weReviewOverlay" class="we-modal-overlay" onclick="if(event.target===this)closeEventReviewModal()">
            <div class="we-modal" role="dialog" aria-labelledby="weReviewTitle">
                <div class="we-modal-header">
                    <div>
                        <h3 id="weReviewTitle">Review registration</h3>
                        <p>Confirm these details before submitting. Quantity is 1 attendee ticket.</p>
                    </div>
                    <button type="button" class="we-modal-close" onclick="closeEventReviewModal()" aria-label="Close">&times;</button>
                </div>
                <div class="we-modal-body">
                    <div class="we-modal-row"><span class="k">Event</span><span class="v">${event.name}</span></div>
                    <div class="we-modal-row"><span class="k">Organizer</span><span class="v">${not empty event.organizerName ? event.organizerName : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Date</span><span class="v">${not empty event.eventDate ? event.eventDate : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Time</span><span class="v">${not empty event.eventTime ? event.eventTime : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Venue</span><span class="v">${not empty event.venue ? event.venue : 'Not provided'}<c:if test="${not empty event.city}">, ${event.city}</c:if></span></div>
                    <div class="we-modal-row"><span class="k">Attendee</span><span class="v">${not empty loggedUser.fullName ? loggedUser.fullName : 'Signed-in user'}</span></div>
                    <div class="we-modal-row"><span class="k">Ticket</span><span class="v">1 × attendee</span></div>
                    <div class="we-modal-row"><span class="k">Amount</span><span class="v"><c:choose><c:when test="${event.free}">Free</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></span></div>
                </div>
                <div class="we-modal-footer">
                    <button type="button" class="we-modal-btn secondary" onclick="closeEventReviewModal()">Edit</button>
                    <button type="button" class="we-modal-btn primary" id="weConfirmRegisterBtn" onclick="confirmEventRegistration()">
                        <c:choose>
                            <c:when test="${event.free}">Confirm registration</c:when>
                            <c:otherwise>Continue to payment</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>
        </div>

        <!-- Razorpay Sim Gateway Modal -->
        <div class="modal fade" id="eventCheckoutModal" tabindex="-1" aria-hidden="true" style="backdrop-filter: blur(8px);">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 450px;">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; background: #ffffff;">
                    <!-- Modal Header -->
                    <div class="modal-header border-0 pb-0" style="padding: 24px 24px 0;">
                        <div class="d-flex align-items-center">
                            <div style="background: #fff1f2; color: #f43f5e; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; border: 1px solid var(--we-border);">
                                <i class="bi bi-wallet2"></i>
                            </div>
                            <div class="ms-3">
                                <h5 class="modal-title fw-bold" style="color: #0F172A; font-size: 1.15rem; font-family:'Outfit',sans-serif;">Razorpay Secure Gateway</h5>
                                <p class="text-muted small mb-0" style="font-size:0.75rem;">Simulated Test Transaction Mode</p>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="box-shadow: none;"></button>
                    </div>
                    <!-- Modal Body -->
                    <div class="modal-body py-4" style="padding: 24px;">
                        <div class="p-3 mb-4" style="background: #f8fafc; border-radius: 16px; border: 1px solid #e2e8f0;">
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Event ticket</span>
                                <span class="fw-bold">₹${event.entryFee}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Processing/Internet charge</span>
                                <span class="fw-bold" style="color:#16A34A;">₹0.00</span>
                            </div>
                            <hr style="border-style: dashed; margin: 12px 0;">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-semibold" style="color: #0F172A;">Total Payment</span>
                                <span class="fs-5 fw-bold" style="font-family:'Outfit',sans-serif; color:#F43F5E;">₹${event.entryFee}</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted mb-1 font-weight-bold">Choose Payment Method</label>
                            <div class="d-grid gap-2">
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #FDA4AF; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="upi" checked class="me-3">
                                    <i class="bi bi-qr-code me-2" style="font-size:1.15rem; color:#F43F5E;"></i> UPI (PhonePe / GPay / Paytm / BHIM)
                                </div>
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #E2E8F0; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="card" class="me-3">
                                    <i class="bi bi-credit-card me-2" style="font-size:1.15rem; color:#16A34A;"></i> Credit or Debit Card checkout
                                </div>
                            </div>
                        </div>
                        <div id="eventOtpSection" style="display:none;" class="mt-3">
                            <label class="form-label small mb-1 font-weight-bold" style="color:#F43F5E;">Simulated Authentication OTP (Enter 123456)</label>
                            <input type="text" id="eventOtpInput" class="form-control text-center fs-5 fw-bold" maxlength="6" placeholder="------" style="letter-spacing: 5px;">
                            <div class="small mt-1 text-center" id="eventOtpError" style="display:none; font-weight: 600; color:#F43F5E;">Invalid verification OTP! Use simulated 123456 code.</div>
                        </div>
                    </div>
                    <!-- Modal Footer -->
                    <div class="modal-footer border-0 pt-0" style="padding: 0 24px 24px;">
                        <button type="button" class="btn btn-outline-secondary w-100 mb-2 rounded-pill small" data-bs-dismiss="modal">Cancel Transaction</button>
                        <button type="button" class="btn w-100 rounded-pill fw-semibold py-2 btn-premium-cta" id="eventPayBtn" onclick="processEventBookingPayment()" style="background: var(--we-accent); border: none; box-shadow: none;">
                            Proceed Payment of ₹${event.entryFee} Securely
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script>
            var weEventIsFree = ${event.free};
            var weSubmitting = false;

            setTimeout(() => {
                document.querySelectorAll('.flash-alert').forEach(el => {
                    el.style.transition='opacity 0.5s'; el.style.opacity='0';
                    setTimeout(()=>el.remove(),500);
                });
            }, 4000);

            function openEventReviewModal() {
                document.getElementById('weReviewOverlay').classList.add('open');
            }
            function closeEventReviewModal() {
                document.getElementById('weReviewOverlay').classList.remove('open');
            }
            function confirmEventRegistration() {
                if (weSubmitting) return;
                closeEventReviewModal();
                if (weEventIsFree) {
                    submitEventRegisterForm();
                } else {
                    openEventCheckoutModal();
                }
            }
            function submitEventRegisterForm() {
                if (weSubmitting) return;
                var form = document.getElementById('eventRegisterForm');
                if (!form) return;
                weSubmitting = true;
                var btn = document.getElementById('weConfirmRegisterBtn');
                if (btn) { btn.disabled = true; btn.textContent = 'Submitting…'; }
                form.submit();
            }
            function openEventCheckoutModal() {
                var modal = new bootstrap.Modal(document.getElementById('eventCheckoutModal'));
                modal.show();
            }

            var eventPaymentStep = 1;
            function processEventBookingPayment() {
                if (eventPaymentStep === 1) {
                    document.getElementById('eventOtpSection').style.display = 'block';
                    document.getElementById('eventPayBtn').textContent = 'Verify simulated OTP';
                    eventPaymentStep = 2;
                } else if (eventPaymentStep === 2) {
                    var otp = document.getElementById('eventOtpInput').value;
                    if (otp === '123456') {
                        document.getElementById('eventOtpError').style.display = 'none';
                        submitEventRegisterForm();
                    } else {
                        document.getElementById('eventOtpError').style.display = 'block';
                    }
                }
            }
        </script>
    </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var mapEl = document.getElementById('eventDetailMap');
        if (!mapEl) return;

        var rawLocation = '${cleanMapQuery}'.trim();
        var venueText = '${event.venue}'.trim();
        var cityText = '${event.city}'.trim();
        var eventTitle = '${event.name}'.trim();

        // Default coordinates (Mysuru / South India)
        var defaultLat = 12.2958;
        var defaultLng = 76.6394;

        // Check if rawLocation contains explicit coordinates like "12.3051, 76.6554"
        var coordMatch = rawLocation.match(/(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)/);
        if (coordMatch) {
            initLeafletMap(parseFloat(coordMatch[1]), parseFloat(coordMatch[2]), 15);
        } else {
            var query = (venueText ? venueText + ', ' : '') + cityText + ', India';
            fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query))
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data && data.length > 0) {
                        initLeafletMap(parseFloat(data[0].lat), parseFloat(data[0].lon), 15);
                    } else if (cityText) {
                        fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(cityText + ', India'))
                            .then(function(r) { return r.json(); })
                            .then(function(cdata) {
                                if (cdata && cdata.length > 0) {
                                    initLeafletMap(parseFloat(cdata[0].lat), parseFloat(cdata[0].lon), 13);
                                } else {
                                    initLeafletMap(defaultLat, defaultLng, 13);
                                }
                            })
                            .catch(function() { initLeafletMap(defaultLat, defaultLng, 13); });
                    } else {
                        initLeafletMap(defaultLat, defaultLng, 13);
                    }
                })
                .catch(function() {
                    initLeafletMap(defaultLat, defaultLng, 13);
                });
        }

        function initLeafletMap(lat, lng, zoom) {
            var map = L.map('eventDetailMap').setView([lat, lng], zoom);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(map);

            var pinHtml = '<div style="background:#F43F5E; color:#FFFFFF; width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; box-shadow:0 4px 14px rgba(244,63,94,0.45); border:2.5px solid #FFFFFF;"><i class="bi bi-geo-alt-fill" style="font-size:18px;"></i></div>';
            var customIcon = L.divIcon({
                html: pinHtml,
                className: '',
                iconSize: [36, 36],
                iconAnchor: [18, 36],
                popupAnchor: [0, -36]
            });

            var marker = L.marker([lat, lng], { icon: customIcon }).addTo(map);
            marker.bindPopup('<div style="font-family:Outfit,sans-serif; padding:4px 2px;"><strong style="font-size:13px; color:#0F172A; display:block; margin-bottom:2px;">' + eventTitle + '</strong><span style="font-size:12px; color:#64748B;">' + venueText + (cityText ? ', ' + cityText : '') + '</span></div>').openPopup();

            setTimeout(function() { map.invalidateSize(); }, 400);
        }
    });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
