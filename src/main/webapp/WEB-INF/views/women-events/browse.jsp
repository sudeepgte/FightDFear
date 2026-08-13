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
            --accent-pink: #f43f5e;
            --accent-purple: #8b5cf6;
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
        .blob-1 { top: -100px; right: -100px; background: var(--accent-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--accent-pink); animation-delay: -5s; }
        
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

        /* Search bar */
        .search-bar { 
            background: white; 
            border-radius: 50px; 
            padding: 6px 6px 6px 20px;
            display: flex; 
            align-items: center; 
            gap: 8px; 
            max-width: 600px; 
            margin: 20px auto 0;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm); 
        }
        .search-bar input { 
            border: none; 
            outline: none; 
            flex: 1; 
            font-size: 14px; 
            color: #333; 
        }
        .search-bar button { 
            background: var(--gradient-primary);
            border: none; 
            color: white; 
            border-radius: 40px; 
            padding: 8px 22px;
            font-weight: 700; 
            cursor: pointer; 
            font-size: 13px;
        }

        /* Stats strip */
        .stats-strip { 
            background: white; 
            padding: 15px 0; 
            border-bottom: 1px solid var(--fdf-border); 
        }
        .stat-item { text-align: center; padding: 0 20px; }
        .stat-num { font-size: 22px; font-weight: 800; color: var(--brand-purple); }
        .stat-label { font-size: 10px; color: var(--fdf-muted); font-weight: 600; text-transform: uppercase; }

        /* Category pills scroll */
        .cat-scroll-container {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            scrollbar-width: none;
            padding-bottom: 4px;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .btn-cat-pill {
            padding: 8px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            white-space: nowrap;
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        /* Layout */
        .main-grid { 
            display: grid; 
            grid-template-columns: 280px 1fr; 
            gap: 30px; 
            max-width: 1200px;
            margin: 40px auto 60px; 
            padding: 0 15px; 
        }
        @media (max-width: 992px) { 
            .main-grid { grid-template-columns: 1fr; } 
            .filter-panel { order: -1; } 
        }

        /* Filter panel */
        .filter-panel { 
            background: white; 
            border-radius: 24px; 
            padding: 24px;
            box-shadow: var(--shadow-sm); 
            height: fit-content; 
            border: 1px solid var(--fdf-border);
        }
        .filter-title { 
            font-weight: 800; 
            font-size: 16px; 
            color: var(--brand-purple); 
            margin-bottom: 20px;
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        .filter-label { 
            font-size: 11px; 
            font-weight: 700; 
            color: var(--brand-purple); 
            text-transform: uppercase;
            margin-bottom: 8px; 
            margin-top: 16px; 
        }
        .filter-input { 
            width: 100%; 
            border: 1px solid var(--fdf-border); 
            border-radius: 12px; 
            padding: 10px 14px;
            font-size: 14px; 
            outline: none; 
            background: #fff;
        }
        .filter-btn { 
            width: 100%; 
            background: var(--gradient-primary);
            color: white; 
            border: none; 
            border-radius: 12px; 
            padding: 12px; 
            font-weight: 700; 
            cursor: pointer; 
            margin-top: 20px; 
            font-size: 14px; 
        }
        .filter-clear { 
            display: block; 
            text-align: center; 
            margin-top: 10px; 
            color: var(--fdf-muted);
            font-size: 13px; 
            text-decoration: none; 
            font-weight: 600; 
        }

        /* Featured Scroll */
        .featured-section { 
            background: rgba(244, 63, 94, 0.02); 
            border-top: 1px solid var(--fdf-border);
            border-bottom: 1px solid var(--fdf-border);
            padding: 30px 0; 
        }
        .section-title { 
            font-size: 18px; 
            font-weight: 800; 
            color: var(--brand-purple); 
            margin-bottom: 20px;
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }
        .featured-scroll { 
            display: flex; 
            gap: 20px; 
            overflow-x: auto; 
            scrollbar-width: none; 
            padding-bottom: 10px; 
        }
        .featured-scroll::-webkit-scrollbar { display: none; }
        .featured-card { 
            min-width: 290px; 
            max-width: 290px; 
            background: white; 
            border-radius: 20px;
            overflow: hidden; 
            box-shadow: var(--shadow-sm); 
            flex-shrink: 0;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s; 
        }
        .featured-card:hover { 
            transform: translateY(-4px); 
            box-shadow: var(--shadow-md);
            border-color: var(--brand-pink-light);
        }

        /* Event cards */
        .events-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 20px; 
        }
        .event-card { 
            background: white; 
            border-radius: 20px; 
            overflow: hidden;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm); 
            transition: all 0.3s; 
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .event-card:hover { 
            transform: translateY(-5px); 
            box-shadow: var(--shadow-lg); 
            border-color: var(--brand-pink-light);
        }
        .card-banner { 
            width: 100%; 
            height: 170px; 
            object-fit: cover; 
        }
        .card-banner-placeholder { 
            width: 100%; 
            height: 170px; 
            background: #fff5f7;
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 3rem; 
        }
        .card-body { 
            padding: 20px; 
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .card-cat { 
            font-size: 10px; 
            font-weight: 800; 
            text-transform: uppercase; 
            letter-spacing: 0.8px;
            color: var(--brand-pink); 
            margin-bottom: 6px; 
        }
        .card-title { 
            font-size: 15px; 
            font-weight: 800; 
            margin-bottom: 12px; 
            line-height: 1.4;
            color: var(--brand-purple);
        }
        .card-meta { 
            display: flex; 
            flex-direction: column; 
            gap: 6px; 
            margin-bottom: 16px; 
        }
        .card-meta span { 
            font-size: 12px; 
            color: var(--fdf-muted); 
            display: flex; 
            align-items: center; 
            gap: 6px; 
        }
        .card-footer-row { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            margin-top: auto;
            padding-top: 14px;
            border-top: 1px dashed var(--fdf-border);
        }
        .fee-badge { 
            background: #f0fdf4; 
            color: #15803d; 
            border-radius: 20px; 
            padding: 4px 12px;
            font-size: 12px; 
            font-weight: 700; 
        }
        .fee-badge.paid { 
            background: #fff7ed; 
            color: #c2410c; 
        }
        .featured-badge { 
            position: absolute; 
            top: 12px; 
            left: 12px; 
            background: var(--gradient-primary);
            color: white; 
            font-size: 10px; 
            font-weight: 700; 
            padding: 4px 10px; 
            border-radius: 20px; 
        }
        .card-img-wrap { position: relative; }
        .register-btn { 
            font-size: 12px; 
            font-weight: 700; 
            color: var(--brand-purple); 
            text-decoration: none !important;
            border: 1px solid var(--fdf-border); 
            border-radius: 20px; 
            padding: 5px 12px;
            transition: all 0.2s; 
        }
        .register-btn:hover { 
            background: var(--brand-purple); 
            color: white; 
            border-color: transparent;
        }

        /* Organizer CTA */
        .organizer-cta { 
            background: white;
            border: 1px solid var(--fdf-border);
            border-radius: 24px; 
            padding: 35px; 
            text-align: center; 
            margin: 40px auto;
            max-width: 800px; 
            box-shadow: var(--shadow-sm);
        }
        .organizer-cta h3 { font-size: 22px; font-weight: 800; color: var(--brand-purple); margin-bottom: 10px; }
        .organizer-cta p { color: var(--fdf-muted); margin-bottom: 24px; font-size: 14px; }
        
        .cta-btn { 
            background: var(--gradient-primary); 
            color: white; 
            border: none; 
            border-radius: 30px;
            padding: 12px 30px; 
            font-weight: 700; 
            cursor: pointer;
            font-size: 14px; 
            text-decoration: none !important; 
            display: inline-block; 
            transition: all 0.2s; 
        }
        .cta-btn:hover { 
            filter: brightness(1.1);
            color: white;
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
            animation: slideIn 0.4s ease; 
        }
        @keyframes slideIn { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

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

        <!-- Dashboard Header -->
        <div class="glow-header">
            <h1>Women Events 🌸</h1>
            <p>Discover educational seminars, fitness workout workshops, entrepreneur meetups, and local health safety campaigns near you.</p>
            
            <form method="get" action="${pageContext.request.contextPath}/women-events" class="search-bar">
                <i class="bi bi-search" style="color:var(--brand-purple); font-size: 14px;"></i>
                <input type="text" name="query" placeholder="Search events by name..." value="${query}"/>
                <button type="submit">Search</button>
            </form>
        </div>

        <!-- Stats Strip -->
        <div class="stats-strip">
            <div class="container">
                <div class="row justify-content-center g-3">
                    <div class="col-auto stat-item">
                        <div class="stat-num">${events.size()}</div>
                        <div class="stat-label">Events Near You</div>
                    </div>
                    <div class="col-auto stat-item">
                        <div class="stat-num">6</div>
                        <div class="stat-label">Categories</div>
                    </div>
                    <div class="col-auto stat-item">
                        <div class="stat-num">${cities.size()}</div>
                        <div class="stat-label">Cities</div>
                    </div>
                    <div class="col-auto stat-item">
                        <div class="stat-num">9+</div>
                        <div class="stat-label">Organizer Types</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Category Pills Scroll -->
        <div class="container mt-4">
            <div class="d-flex align-items-center justify-content-center mt-3" style="max-width: 800px; margin: 0 auto;">
                <button class="btn btn-sm btn-outline-secondary rounded-circle me-2" onclick="scrollCatLeft(this)">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container flex-grow-1" style="margin-top: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                    <a href="${pageContext.request.contextPath}/women-events" class="btn-cat-pill ${empty selectedCategory ? 'active' : ''}">
                        <i class="bi bi-grid-fill"></i> All Events
                    </a>
                    <a href="?category=HEALTH_WELLNESS" class="btn-cat-pill ${'HEALTH_WELLNESS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-heart-pulse"></i> Health &amp; Wellness
                    </a>
                    <a href="?category=ENTREPRENEURSHIP_CAREER" class="btn-cat-pill ${'ENTREPRENEURSHIP_CAREER' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-briefcase"></i> Entrepreneurship
                    </a>
                    <a href="?category=FITNESS_SPORTS" class="btn-cat-pill ${'FITNESS_SPORTS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-trophy"></i> Fitness &amp; Sports
                    </a>
                    <a href="?category=EDUCATION_SKILLS" class="btn-cat-pill ${'EDUCATION_SKILLS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-book"></i> Education &amp; Skills
                    </a>
                    <a href="?category=SOCIAL_COMMUNITY" class="btn-cat-pill ${'SOCIAL_COMMUNITY' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-people"></i> Social &amp; Community
                    </a>
                    <a href="?category=SAFETY_AWARENESS" class="btn-cat-pill ${'SAFETY_AWARENESS' == selectedCategory ? 'active' : ''}">
                        <i class="bi bi-shield-check"></i> Safety &amp; Awareness
                    </a>
                </div>
                <button class="btn btn-sm btn-outline-secondary rounded-circle ms-2" onclick="scrollCatRight(this)">
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
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Recommended Events (if any) -->
        <c:if test="${not empty recommendations && empty selectedCategory && empty query}">
            <div class="featured-section" style="background: rgba(16, 185, 129, 0.02); border-top: none;">
                <div class="container px-4">
                    <div class="section-title" style="color: #10b981;"><i class="bi bi-stars"></i> Recommended for You</div>
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
                                    <span class="featured-badge" style="background: #10b981;"><i class="bi bi-stars"></i> Recommended</span>
                                </div>
                                <div class="card-body">
                                    <div class="card-cat" style="color:#10b981;">${ev.category.displayName}</div>
                                    <div class="card-title">${ev.name}</div>
                                    <div class="card-meta">
                                        <span><i class="bi bi-calendar3"></i> ${ev.eventDate}</span>
                                        <span><i class="bi bi-geo-alt-fill"></i> ${ev.city}</span>
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
                <div class="filter-title"><i class="bi bi-funnel-fill"></i> Filter Events</div>
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
                       style="display:block; background:#fff5f7; color:var(--brand-purple); border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px; border: 1px solid var(--brand-pink-light);">
                        <i class="bi bi-ticket-perforated-fill"></i> My Tickets
                    </a>
                </c:if>

                <c:choose>
                    <c:when test="${not empty loggedHost}">
                        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard"
                           style="display:block; background:#f0fdf4; color:#15803d; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px;">
                            <i class="bi bi-calendar-plus-fill"></i> Organizer Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/women-events/host/logout"
                           style="display:block; background:#fee2e2; color:#ef4444; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px;">
                            <i class="bi bi-box-arrow-right"></i> Host Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/women-events/host/register"
                           style="display:block; background:#fef3c7; color:#d97706; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px;">
                            <i class="bi bi-person-badge-fill"></i> Register as Host
                        </a>
                        <a href="${pageContext.request.contextPath}/women-events/host/login"
                           style="display:block; background:#f0fdf4; color:#16a34a; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600; margin-bottom:10px;">
                            <i class="bi bi-box-arrow-in-right"></i> Host Login
                        </a>
                    </c:otherwise>
                </c:choose>

                <c:if test="${empty loggedUser && empty loggedHost}">
                    <a href="${pageContext.request.contextPath}/login"
                       style="display:block; background: var(--gradient-primary); color:white; border-radius:12px; padding:12px; text-align:center; text-decoration:none; font-weight:600;">
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
                                        <a href="${pageContext.request.contextPath}/women-events/${ev.id}">
                                            <div class="card-img-wrap">
                                                <c:choose>
                                                    <c:when test="${not empty ev.bannerImage}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-banner-placeholder">
                                                            <c:choose>
                                                                <c:when test="${ev.category == 'HEALTH_WELLNESS'}">💊</c:when>
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
                                                    <span class="fee-badge ${ev.free ? '' : 'paid'}">
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
                            <p class="small mb-0">Try adjusting your filters or <a href="${pageContext.request.contextPath}/women-events" style="color:var(--brand-purple); font-weight:700;">browse all events</a>.</p>
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
                            <a href="${pageContext.request.contextPath}/women-events/host/login" class="cta-btn me-2" style="background:#fff; border:1px solid var(--fdf-border); color:var(--brand-purple);">Host Login</a>
                            <a href="${pageContext.request.contextPath}/women-events/host/register" class="cta-btn">Register to Host</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>

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
