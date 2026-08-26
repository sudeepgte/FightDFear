<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Women Events — Discover Empowering Events</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            /* 60% Primary Surfaces */
            --bg-primary: #FFF1F2;
            --glow-bg: #FFF1F2;
            --card-bg: #FFFFFF;

            /* 30% Secondary Structure */
            --bg-secondary: #FFF1F2;
            --fdf-border: #E2E8F0;
            --border-secondary: #FDA4AF;

            /* 10% Accent */
            --brand-pink: #F43F5E;
            --brand-pink-light: #FDA4AF;
            --brand-pink-dark: #E11D48;
            --brand-gold: #F59E0B;

            /* Text colors */
            --fdf-text: #0F172A;
            --fdf-muted: #64748B;

            /* Shadows & Transitions */
            --shadow-sm: 0 10px 30px rgba(15, 23, 42, 0.04);
            --shadow-md: 0 15px 35px rgba(15, 23, 42, 0.06);
            --shadow-lg: 0 25px 55px rgba(15, 23, 42, 0.10);
            --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        body {
            font-family: 'Outfit', sans-serif;
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
            filter: blur(100px);
            opacity: 0.06;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--brand-pink); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Hero section with clean white-rose gradient */
        .hero-banner-section {
            background: linear-gradient(135deg, #FFFFFF 0%, var(--bg-secondary) 100%);
            padding: 85px 24px;
            border-radius: 32px;
            text-align: center;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(244, 63, 94, 0.08);
            box-shadow: var(--shadow-sm);
            margin-bottom: 40px;
            margin-top: 10px;
        }
        .hero-banner-section::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 10% 20%, rgba(244, 63, 94, 0.04) 0%, transparent 40%);
            pointer-events: none;
        }
        
        .hero-banner-section h1 {
            font-family: 'Outfit', sans-serif;
            font-size: 46px;
            font-weight: 900;
            color: var(--fdf-text);
            letter-spacing: -1px;
            margin-bottom: 15px;
            line-height: 1.2;
        }
        .hero-banner-section p {
            color: var(--fdf-muted);
            font-size: 17px;
            max-width: 680px;
            margin: 0 auto 30px;
            line-height: 1.6;
            font-weight: 500;
        }

        /* Search bar */
        .search-bar { 
            background: #FFFFFF; 
            border-radius: 50px; 
            padding: 8px 8px 8px 24px;
            display: flex; 
            align-items: center; 
            gap: 12px; 
            max-width: 650px; 
            margin: 0 auto;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm); 
            transition: var(--transition-smooth);
        }
        .search-bar:focus-within {
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.12);
            border-color: var(--brand-pink-light);
        }
        .search-bar input { 
            border: none; 
            outline: none; 
            flex: 1; 
            font-size: 15px; 
            color: var(--fdf-text); 
            font-weight: 500;
        }
        .search-bar input::placeholder {
            color: #94A3B8;
        }
        .search-bar button { 
            background: linear-gradient(135deg, var(--brand-pink) 0%, var(--brand-pink-dark) 100%);
            border: none; 
            color: #FFFFFF; 
            border-radius: 40px; 
            padding: 10px 28px;
            font-weight: 700; 
            cursor: pointer; 
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
            transition: var(--transition-smooth);
        }
        .search-bar button:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.3);
        }
 
        /* Stats strip */
        .stats-container-card {
            background: #FFFFFF;
            border-radius: 24px;
            padding: 24px;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm);
            margin-bottom: 40px;
        }
        .stat-item { text-align: center; position: relative; }
        .stat-item:not(:last-child)::after {
            content: '';
            position: absolute;
            right: 0;
            top: 15%;
            height: 70%;
            width: 1px;
            background: var(--fdf-border);
        }
        @media (max-width: 768px) {
            .stat-item:not(:last-child)::after { display: none; }
        }
        .stat-num { font-size: 28px; font-weight: 800; color: var(--fdf-text); }
        .stat-label { font-size: 11px; color: var(--fdf-muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
 
        /* Category pills scroll */
        .cat-scroll-outer {
            margin-bottom: 40px;
        }
        .cat-scroll-container {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            scrollbar-width: none;
            padding: 4px 0;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .btn-cat-pill {
            padding: 10px 24px;
            border-radius: 999px;
            background: #FFFFFF;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-text);
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-smooth);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            white-space: nowrap;
            box-shadow: var(--shadow-sm);
        }
        .btn-cat-pill:hover {
            border-color: var(--brand-pink-light);
            color: var(--brand-pink);
            transform: translateY(-1px);
        }
        .btn-cat-pill.active {
            background: var(--brand-pink);
            color: #FFFFFF;
            border-color: var(--brand-pink);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.15);
        }
 
        /* Layout */
        .main-grid { 
            display: grid; 
            grid-template-columns: 300px 1fr; 
            gap: 40px; 
            max-width: 1400px;
            margin: 0 auto 60px; 
            padding: 0 15px; 
        }
        @media (max-width: 992px) { 
            .main-grid { grid-template-columns: 1fr; } 
        }
 
        /* Filter panel (30% secondary structure soft-rose background) */
        .filter-panel { 
            background: var(--bg-secondary); 
            border-radius: 28px; 
            padding: 28px;
            box-shadow: var(--shadow-sm); 
            height: fit-content; 
            border: 1px solid var(--border-secondary);
        }
        .filter-title { 
            font-weight: 800; 
            font-size: 18px; 
            color: var(--fdf-text); 
            margin-bottom: 24px;
            display: flex; 
            align-items: center; 
            gap: 10px; 
            border-bottom: 2px solid var(--border-secondary);
            padding-bottom: 12px;
        }
        .filter-label { 
            font-size: 12px; 
            font-weight: 700; 
            color: var(--fdf-text); 
            text-transform: uppercase;
            margin-bottom: 10px; 
            margin-top: 20px; 
            letter-spacing: 0.5px;
        }
        .filter-input { 
            width: 100%; 
            border: 1px solid var(--fdf-border); 
            border-radius: 14px; 
            padding: 12px 16px;
            font-size: 15px; 
            outline: none; 
            background: #FFFFFF;
            color: var(--fdf-text);
            font-weight: 500;
            transition: var(--transition-smooth);
        }
        .filter-input:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }
        .filter-btn { 
            width: 100%; 
            background: var(--brand-pink);
            color: #FFFFFF; 
            border: none; 
            border-radius: 14px; 
            padding: 14px; 
            font-weight: 700; 
            cursor: pointer; 
            margin-top: 24px; 
            font-size: 15px; 
            transition: var(--transition-smooth);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.15);
        }
        .filter-btn:hover { 
            background: var(--brand-pink-dark);
            transform: translateY(-1px);
        }
        .filter-clear { 
            display: block; 
            text-align: center; 
            margin-top: 14px; 
            color: var(--fdf-muted);
            font-size: 14px; 
            text-decoration: none !important; 
            font-weight: 600; 
            transition: var(--transition-smooth);
        }
        .filter-clear:hover {
            color: var(--brand-pink);
        }
 
        /* Featured Section (30% secondary structure soft rose background) */
        .featured-section { 
            background: var(--bg-secondary); 
            border: 1px solid var(--border-secondary);
            border-radius: 32px;
            padding: 35px; 
            margin-bottom: 40px;
        }
        .section-title { 
            font-size: 22px; 
            font-weight: 900; 
            color: var(--fdf-text); 
            margin-bottom: 24px;
            display: flex; 
            align-items: center; 
            gap: 10px; 
            letter-spacing: -0.5px;
        }
        .featured-scroll { 
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }
        .featured-card { 
            background: #FFFFFF; 
            border-radius: 24px;
            overflow: hidden; 
            box-shadow: var(--shadow-sm); 
            border: 1px solid var(--fdf-border);
            transition: var(--transition-smooth); 
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .featured-card:hover { 
            transform: translateY(-6px); 
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
 
        /* Event cards */
        .events-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); 
            gap: 24px; 
        }
        .event-card { 
            background: #FFFFFF; 
            border-radius: 24px; 
            overflow: hidden;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm); 
            transition: var(--transition-smooth); 
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .event-card:hover { 
            transform: translateY(-6px); 
            box-shadow: var(--shadow-lg); 
            border-color: var(--brand-pink-light);
        }
        .card-banner { 
            width: 100%; 
            height: 200px; 
            object-fit: cover; 
            transition: var(--transition-smooth);
        }
        .event-card:hover .card-banner, .featured-card:hover .card-banner {
            transform: scale(1.05);
        }
        .card-banner-placeholder { 
            width: 100%; 
            height: 200px; 
            background: linear-gradient(135deg, #FFFFFF 0%, var(--bg-secondary) 100%);
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 3.5rem; 
        }
        .card-body { 
            padding: 24px; 
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .card-cat { 
            font-size: 11px; 
            font-weight: 800; 
            text-transform: uppercase; 
            letter-spacing: 1px;
            color: var(--brand-pink); 
            margin-bottom: 8px; 
        }
        .card-title { 
            font-size: 18px; 
            font-weight: 800; 
            margin-bottom: 14px; 
            line-height: 1.4;
            color: var(--fdf-text);
        }
        .card-meta { 
            display: flex; 
            flex-direction: column; 
            gap: 8px; 
            margin-bottom: 20px; 
        }
        .card-meta span { 
            font-size: 13px; 
            color: var(--fdf-muted); 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            font-weight: 500;
        }
        .card-meta i {
            color: var(--brand-pink);
            font-size: 14px;
        }
        .card-footer-row { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            margin-top: auto;
            padding-top: 18px;
            border-top: 1px solid var(--fdf-border);
        }
        .fee-badge { 
            background: var(--bg-secondary); 
            color: var(--brand-pink); 
            border-radius: 20px; 
            padding: 6px 16px;
            font-size: 13px; 
            font-weight: 800; 
        }
        .fee-badge.free { 
            background: #F0FDF4; 
            color: #16A34A; 
        }
        .featured-badge { 
            position: absolute; 
            top: 16px; 
            left: 16px; 
            background: var(--brand-pink);
            color: #FFFFFF; 
            font-size: 11px; 
            font-weight: 800; 
            padding: 6px 14px; 
            border-radius: 20px; 
            box-shadow: 0 4px 10px rgba(244, 63, 94, 0.25);
            z-index: 2;
        }
        .card-img-wrap { position: relative; overflow: hidden; }
        .register-btn { 
            font-size: 13px; 
            font-weight: 700; 
            color: var(--brand-pink); 
            text-decoration: none !important;
            border: 1.5px solid var(--brand-pink); 
            border-radius: 24px; 
            padding: 6px 16px;
            transition: var(--transition-smooth); 
        }
        .register-btn:hover { 
            background: var(--brand-pink); 
            color: #FFFFFF; 
            border-color: transparent;
        }
 
        /* Organizer CTA (30% secondary structure soft rose background) */
        .organizer-cta { 
            background: var(--bg-secondary);
            border-radius: 32px; 
            padding: 45px; 
            text-align: center; 
            margin: 60px auto 40px;
            max-width: 1000px; 
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border-secondary);
        }
        .organizer-cta::after {
            content: '';
            position: absolute;
            bottom: -50px; right: -50px;
            width: 250px; height: 250px;
            background: radial-gradient(circle, rgba(244, 63, 94, 0.1) 0%, transparent 60%);
            border-radius: 50%;
        }
        .organizer-cta h3 { font-size: 26px; font-weight: 900; color: var(--fdf-text); margin-bottom: 12px; }
        .organizer-cta p { color: var(--fdf-muted); margin-bottom: 30px; font-size: 15px; max-width: 600px; margin-left: auto; margin-right: auto; }
        
        .cta-btn { 
            background: var(--brand-pink); 
            color: #FFFFFF; 
            border: none; 
            border-radius: 30px;
            padding: 14px 36px; 
            font-weight: 700; 
            cursor: pointer;
            font-size: 15px; 
            text-decoration: none !important; 
            display: inline-block; 
            transition: var(--transition-smooth); 
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }
        .cta-btn:hover { 
            background: var(--brand-pink-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.35);
            color: #FFFFFF;
        }
 
        /* Empty State */
        .no-events.bg-white {
            background-color: var(--bg-secondary) !important;
            border-color: var(--border-secondary) !important;
        }

        /* Alert */
        .flash-alert { 
            position: fixed; 
            top: 100px; 
            right: 20px; 
            z-index: 9999; 
            max-width: 380px; 
            border-radius: 16px;
            box-shadow: var(--shadow-lg); 
            border: 1px solid var(--border-secondary) !important;
            animation: slideIn 0.4s ease; 
        }
        @keyframes slideIn { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <c:if test="${not empty success}">
            <div class="flash-alert alert alert-success alert-dismissible fade show border-0 rounded-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-alert alert alert-danger alert-dismissible fade show border-0 rounded-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Dashboard Header / Hero -->
        <div class="hero-banner-section">
            <h1>Discover <span>Events Made for Women</span> 🌸</h1>
            <p>Discover workshops, conferences, wellness events, entrepreneurship, finance, career, and community meetups designed to inspire and empower you.</p>
            
            <form method="get" action="${pageContext.request.contextPath}/women-events" class="search-bar">
                <i class="bi bi-search" style="color:var(--brand-pink); font-size: 16px;"></i>
                <input type="text" name="query" placeholder="Search events by name, category, or keyword..." value="${query}"/>
                <button type="submit">Search Events</button>
            </form>
        </div>

        <!-- Stats Strip -->
        <div class="stats-container-card">
            <div class="row justify-content-center g-3">
                <div class="col-6 col-md-3 stat-item">
                    <div class="stat-num">${events.size()}</div>
                    <div class="stat-label">Events Near You</div>
                </div>
                <div class="col-6 col-md-3 stat-item">
                    <div class="stat-num">6</div>
                    <div class="stat-label">Categories</div>
                </div>
                <div class="col-6 col-md-3 stat-item">
                    <div class="stat-num">${cities.size() > 0 ? cities.size() : 2}</div>
                    <div class="stat-label">Cities Active</div>
                </div>
                <div class="col-6 col-md-3 stat-item">
                    <div class="stat-num">9+</div>
                    <div class="stat-label">Organizer Types</div>
                </div>
            </div>
        </div>

        <!-- Category Pills Scroll -->
        <div class="cat-scroll-outer mt-4">
            <div class="d-flex align-items-center justify-content-center" style="max-width: 800px; margin: 0 auto;">
                <button class="btn btn-sm btn-outline-secondary rounded-circle me-2" onclick="scrollCatLeft(this)" style="border-color: var(--fdf-border); color: var(--fdf-text);">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container flex-grow-1" style="margin-top: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                    <a href="${pageContext.request.contextPath}/women-events" class="btn-cat-pill ${empty selectedCategory ? 'active' : ''}">
                        <i class="bi bi-grid-fill"></i> All Events
                    </a>
                    <a href="?category=HEALTH_WELLNESS" class="btn-cat-pill ${'HEALTH_WELLNESS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-heart-pulse-fill"></i> Health &amp; Wellness
                    </a>
                    <a href="?category=ENTREPRENEURSHIP_CAREER" class="btn-cat-pill ${'ENTREPRENEURSHIP_CAREER' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-briefcase-fill"></i> Entrepreneurship
                    </a>
                    <a href="?category=FITNESS_SPORTS" class="btn-cat-pill ${'FITNESS_SPORTS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-trophy-fill"></i> Fitness &amp; Sports
                    </a>
                    <a href="?category=EDUCATION_SKILLS" class="btn-cat-pill ${'EDUCATION_SKILLS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-book-fill"></i> Education &amp; Skills
                    </a>
                    <a href="?category=SOCIAL_COMMUNITY" class="btn-cat-pill ${'SOCIAL_COMMUNITY' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-people-fill"></i> Social &amp; Community
                    </a>
                    <a href="?category=SAFETY_AWARENESS" class="btn-cat-pill ${'SAFETY_AWARENESS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-shield-fill-check"></i> Safety &amp; Awareness
                    </a>
                </div>
                <button class="btn btn-sm btn-outline-secondary rounded-circle ms-2" onclick="scrollCatRight(this)" style="border-color: var(--fdf-border); color: var(--fdf-text);">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <!-- Featured Events (if any) -->
        <c:if test="${not empty featuredEvents && empty selectedCategory && empty query}">
            <div class="featured-section mt-4">
                <div class="container px-4">
                    <div class="section-title"><i class="bi bi-star-fill text-warning"></i> Featured Events</div>
                    <div class="featured-scroll">
                        <c:forEach var="ev" items="${featuredEvents}">
                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="featured-card" style="text-decoration:none; color:inherit;">
                                <div class="card-img-wrap">
                                    <c:choose>
                                        <c:when test="${not empty ev.bannerImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-banner-placeholder">🌸</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="featured-badge"><i class="bi bi-star-fill"></i> Featured</span>
                                </div>
                                <div class="card-body">
                                    <div class="card-cat">${ev.category.displayName}</div>
                                    <div class="card-title">${ev.name}</div>
                                    <div class="card-meta">
                                        <span><i class="bi bi-calendar3"></i> ${ev.eventDate}</span>
                                        <span><i class="bi bi-geo-alt-fill"></i> ${ev.city}</span>
                                    </div>
                                    <div class="card-footer-row">
                                        <span class="fee-badge ${ev.free ? 'free' : ''}">
                                            <c:choose>
                                                <c:when test="${ev.free}">🆓 Free</c:when>
                                                <c:otherwise>₹${ev.entryFee}</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="register-btn">View Details →</span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Recommended Events (if any) -->
        <c:if test="${not empty recommendations && empty selectedCategory && empty query}">
            <div class="featured-section" style="background: var(--bg-secondary); border: 1px solid var(--border-secondary); margin-top: 20px;">
                <div class="container px-4">
                    <div class="section-title" style="color: var(--fdf-text);"><i class="bi bi-stars text-warning"></i> Recommended for You</div>
                    <div class="featured-scroll">
                        <c:forEach var="ev" items="${recommendations}">
                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="featured-card" style="text-decoration:none; color:inherit;">
                                <div class="card-img-wrap">
                                    <c:choose>
                                        <c:when test="${not empty ev.bannerImage}">
                                            <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-banner-placeholder">🌸</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="featured-badge" style="background: var(--brand-pink);"><i class="bi bi-stars text-warning"></i> Recommended</span>
                                </div>
                                <div class="card-body">
                                    <div class="card-cat" style="color: var(--brand-pink);">${ev.category.displayName}</div>
                                    <div class="card-title">${ev.name}</div>
                                    <div class="card-meta">
                                        <span><i class="bi bi-calendar3"></i> ${ev.eventDate}</span>
                                        <span><i class="bi bi-geo-alt-fill"></i> ${ev.city}</span>
                                    </div>
                                    <div class="card-footer-row">
                                        <span class="fee-badge ${ev.free ? 'free' : ''}">
                                            <c:choose>
                                                <c:when test="${ev.free}">🆓 Free</c:when>
                                                <c:otherwise>₹${ev.entryFee}</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="register-btn">View Details →</span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Main Grid -->
        <div class="main-grid">
            <!-- Filter Panel -->
            <aside class="filter-panel">
                <div class="filter-title"><i class="bi bi-funnel-fill" style="color:var(--brand-pink);"></i> Filter Events</div>
                <form method="get" action="${pageContext.request.contextPath}/women-events">
                    <div class="filter-label">City</div>
                    <select name="city" class="filter-input">
                        <option value="">All Cities</option>
                        <c:forEach var="c" items="${cities}">
                            <option value="${c}" ${c == selectedCity ? 'selected' : ''}>${c}</option>
                        </c:forEach>
                    </select>

                    <div class="filter-label">Category</div>
                    <select name="category" class="filter-input">
                        <option value="">All Categories</option>
                        <option value="HEALTH_WELLNESS" ${'HEALTH_WELLNESS' == selectedCategory ? 'selected' : ''}>Health &amp; Wellness</option>
                        <option value="ENTREPRENEURSHIP_CAREER" ${'ENTREPRENEURSHIP_CAREER' == selectedCategory ? 'selected' : ''}>Entrepreneurship &amp; Career</option>
                        <option value="FITNESS_SPORTS" ${'FITNESS_SPORTS' == selectedCategory ? 'selected' : ''}>Fitness &amp; Sports</option>
                        <option value="EDUCATION_SKILLS" ${'EDUCATION_SKILLS' == selectedCategory ? 'selected' : ''}>Education &amp; Skills</option>
                        <option value="SOCIAL_COMMUNITY" ${'SOCIAL_COMMUNITY' == selectedCategory ? 'selected' : ''}>Social &amp; Community</option>
                        <option value="SAFETY_AWARENESS" ${'SAFETY_AWARENESS' == selectedCategory ? 'selected' : ''}>Safety &amp; Awareness</option>
                    </select>

                    <button type="submit" class="filter-btn"><i class="bi bi-search me-2"></i> Apply Filters</button>
                    <a href="${pageContext.request.contextPath}/women-events" class="filter-clear">Clear Filters</a>
                </form>

                <hr style="margin: 24px 0; border-color: var(--fdf-border);"/>

                <c:if test="${not empty loggedUser}">
                    <a href="${pageContext.request.contextPath}/women-events/my-registrations"
                       style="display:block; background:var(--bg-secondary); color:var(--fdf-text); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid var(--border-secondary);">
                        <i class="bi bi-ticket-perforated-fill text-danger me-1"></i> My Tickets
                    </a>
                </c:if>

                <c:choose>
                    <c:when test="${not empty loggedHost}">
                        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard"
                           style="display:block; background:var(--bg-secondary); color:var(--fdf-text); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid var(--fdf-border);">
                            <i class="bi bi-calendar-plus-fill me-1"></i> Organizer Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/women-events/host/logout"
                           style="display:block; background:var(--bg-secondary); color:var(--brand-pink); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid rgba(244,63,94,0.15);">
                            <i class="bi bi-box-arrow-right me-1"></i> Host Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/women-events/host/register"
                           style="display:block; background:var(--bg-secondary); color:var(--fdf-text); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid var(--border-secondary);">
                            <i class="bi bi-person-badge-fill text-warning me-1"></i> Register as Host
                        </a>
                        <a href="${pageContext.request.contextPath}/women-events/host/login"
                           style="display:block; background:#FFFFFF; color:var(--fdf-text); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid var(--fdf-border);">
                            <i class="bi bi-box-arrow-in-right text-danger me-1"></i> Host Login
                        </a>
                    </c:otherwise>
                </c:choose>

                <c:if test="${empty loggedUser && empty loggedHost}">
                    <a href="${pageContext.request.contextPath}/login"
                       style="display:block; background: var(--brand-pink); color:white; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:700; box-shadow: 0 4px 10px rgba(244,63,94,0.2); transition: var(--transition-smooth);">
                        <i class="bi bi-person-circle me-1"></i> Login to Register
                    </a>
                </c:if>
            </aside>

            <!-- Events Grid -->
            <div>
                <div class="mb-4">
                    <div style="font-size: 14px; color: var(--fdf-muted); font-weight:600;">
                        Showing <strong>${events.size()}</strong> event${events.size() != 1 ? 's' : ''}
                        <c:if test="${not empty selectedCategory}"> in <strong>${selectedCategory}</strong></c:if>
                        <c:if test="${not empty selectedCity}"> in <strong>${selectedCity}</strong></c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty events}">
                        <div class="events-grid">
                            <c:forEach var="ev" items="${events}">
                                <div class="col-12" style="display: contents;">
                                    <div class="event-card">
                                        <a href="${pageContext.request.contextPath}/women-events/${ev.id}" style="text-decoration:none; color:inherit; display:flex; flex-direction:column; height:100%;">
                                            <div class="card-img-wrap">
                                                <c:choose>
                                                    <c:when test="${not empty ev.bannerImage}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-banner-placeholder">
                                                            <c:choose>
                                                                <c:when test="${ev.category == 'HEALTH_WELLNESS'}">❤️</c:when>
                                                                <c:when test="${ev.category == 'ENTREPRENEURSHIP_CAREER'}">💼</c:when>
                                                                <c:when test="${ev.category == 'FITNESS_SPORTS'}">🏃‍♀️</c:when>
                                                                <c:when test="${ev.category == 'EDUCATION_SKILLS'}">📚</c:when>
                                                                <c:when test="${ev.category == 'SOCIAL_COMMUNITY'}">🤝</c:when>
                                                                <c:otherwise>🛡️</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${ev.featured}">
                                                    <span class="featured-badge"><i class="bi bi-star-fill"></i> Featured</span>
                                                </c:if>
                                            </div>
                                            <div class="card-body">
                                                <div class="card-cat">${ev.category.displayName}</div>
                                                <h4 class="card-title">${ev.name}</h4>
                                                <div class="card-meta">
                                                    <span><i class="bi bi-calendar3"></i> ${ev.eventDate}</span>
                                                    <span><i class="bi bi-geo-alt"></i> ${ev.venue}, ${ev.city}</span>
                                                    <span><i class="bi bi-person"></i> ${ev.organizerName} <small class="text-muted">(${ev.organizerType})</small></span>
                                                </div>
                                                <div class="card-footer-row">
                                                    <span class="fee-badge ${ev.free ? 'free' : ''}">
                                                        <c:choose>
                                                            <c:when test="${ev.free}">🆓 Free</c:when>
                                                            <c:otherwise>₹${ev.entryFee}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="register-btn">View Details →</span>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-events text-center py-5 text-muted bg-white rounded-4 border">
                            <span class="display-3 mb-3 d-block">🔍</span>
                            <h4 class="fw-bold text-dark mb-1">No events found</h4>
                            <p class="small mb-0">Try adjusting your filters or <a href="${pageContext.request.contextPath}/women-events" style="color:var(--brand-pink); font-weight:700;">browse all events</a>.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Organizer CTA -->
                <div class="organizer-cta mt-5">
                    <h3>🌺 Host Your Own Event</h3>
                    <p>NGOs, colleges, physical gyms, companies, or women entrepreneurs. Present your event directly to thousands of users on Fight D Fear.</p>
                    <c:choose>
                        <c:when test="${not empty loggedHost}">
                            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="cta-btn">Organizer Dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/women-events/host/login" class="cta-btn me-2" style="background:#FFFFFF; border:1px solid var(--fdf-border); color:var(--brand-pink);">Host Login</a>
                            <a href="${pageContext.request.contextPath}/women-events/host/register" class="cta-btn">Register to Host</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Footer -->
        

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

    function scrollCatLeft(btn) {
        const container = btn.nextElementSibling;
        container.scrollBy({ left: -200, behavior: 'smooth' });
    }
    function scrollCatRight(btn) {
        const container = btn.previousElementSibling;
        container.scrollBy({ left: 200, behavior: 'smooth' });
    }

    // Auto-dismiss alerts
    setTimeout(() => {
        document.querySelectorAll('.flash-alert').forEach(el => {
            el.style.transition = 'opacity 0.5s'; el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        });
    }, 4000);
</script>
</body>
</html>
