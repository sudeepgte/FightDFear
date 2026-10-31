<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
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
    <link href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    
    <style>
        :root {
            /* 60% Primary Surfaces */
            --bg-primary: #F8FAFC;
            --glow-bg: #F8FAFC;
            --card-bg: #FFFFFF;

            /* 30% Secondary Structure */
            --bg-secondary: #F8FAFC;
            --fdf-border: #E2E8F0;
            --border-secondary: #E2E8F0;

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
        /* Page Unified Container */
        .we-browse-container {
            max-width: 1240px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
            padding: 20px 20px 60px;
        }

        /* Hero section with clean white-rose gradient */
        .hero-banner-section {
            background: linear-gradient(135deg, #FFFFFF 0%, #FFF1F2 100%);
            padding: 56px 32px 48px;
            border-radius: 28px;
            text-align: center;
            position: relative;
            overflow: hidden;
            border: 1px solid #FECDD3;
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.05);
            margin-bottom: 28px;
            margin-top: 4px;
        }
        .hero-banner-section::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 10% 20%, rgba(244, 63, 94, 0.05) 0%, transparent 45%);
            pointer-events: none;
        }
        .hero-badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #FFFFFF;
            border: 1px solid #FDA4AF;
            color: #F43F5E;
            font-size: 13px;
            font-weight: 700;
            padding: 6px 18px;
            border-radius: 99px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(244, 63, 94, 0.1);
        }
        .hero-banner-section h1 {
            font-family: 'Outfit', sans-serif;
            font-size: clamp(2rem, 3.8vw, 2.9rem);
            font-weight: 900;
            color: var(--fdf-text);
            letter-spacing: -0.5px;
            margin-bottom: 12px;
            line-height: 1.25;
        }
        .hero-banner-section h1 span {
            color: var(--brand-pink);
        }
        .hero-banner-section p {
            color: var(--fdf-muted);
            font-size: 16px;
            max-width: 660px;
            margin: 0 auto 28px;
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
            border: 1px solid #FDA4AF;
            box-shadow: 0 4px 20px rgba(244, 63, 94, 0.08); 
            transition: var(--transition-smooth);
        }
        .search-bar:focus-within {
            box-shadow: 0 8px 25px rgba(244, 63, 94, 0.16);
            border-color: var(--brand-pink);
        }
        .search-bar input { 
            border: none; 
            outline: none; 
            flex: 1; 
            font-size: 15px; 
            color: var(--fdf-text); 
            font-weight: 500;
            min-width: 0;
            text-overflow: ellipsis;
        }
        .search-bar input::placeholder {
            color: #94A3B8;
        }
        .search-bar button { 
            background: linear-gradient(135deg, var(--brand-pink) 0%, var(--brand-pink-dark) 100%);
            border: none; 
            color: #FFFFFF; 
            border-radius: 40px; 
            padding: 12px 28px;
            font-weight: 700; 
            cursor: pointer; 
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
            transition: var(--transition-smooth);
            white-space: nowrap;
            flex-shrink: 0;
        }
        .search-bar button:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.35);
        }
        @media (max-width: 576px) {
            .search-bar {
                padding: 6px 6px 6px 16px;
                gap: 8px;
            }
            .search-bar input {
                font-size: 13px;
            }
            .search-bar button {
                padding: 10px 18px;
                font-size: 13px;
            }
        }
 
        /* Stats strip */
        .stats-container-card {
            background: #FFFFFF;
            border-radius: 20px;
            padding: 20px 24px;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--shadow-sm);
            margin-bottom: 28px;
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
            margin-bottom: 32px;
        }
        .cat-scroll-container {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            scrollbar-width: none;
            padding: 4px 2px 8px;
            flex-wrap: wrap;
            justify-content: center;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .btn-cat-pill {
            padding: 10px 22px;
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
            box-shadow: 0 2px 6px rgba(15, 23, 42, 0.03);
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
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }
 
        /* Layout Grid */
        .main-grid { 
            display: grid; 
            grid-template-columns: 280px minmax(0, 1fr); 
            gap: 32px; 
            margin-bottom: 40px; 
            padding: 0; 
        }
        @media (max-width: 991px) { 
            .main-grid { grid-template-columns: 1fr; gap: 24px; } 
        }
 
        /* Filter panel */
        .filter-panel { 
            background: #FFFFFF; 
            border-radius: 24px; 
            padding: 24px;
            box-shadow: var(--shadow-sm); 
            height: fit-content; 
            border: 1px solid var(--fdf-border);
            position: sticky;
            top: 96px;
            z-index: 10;
        }
        .filter-title { 
            font-weight: 800; 
            font-size: 17px; 
            color: var(--fdf-text); 
            margin-bottom: 20px;
            display: flex; 
            align-items: center; 
            gap: 10px; 
            border-bottom: 1px solid var(--fdf-border);
            padding-bottom: 12px;
        }
        .filter-label { 
            font-size: 11px; 
            font-weight: 700; 
            color: var(--fdf-muted); 
            text-transform: uppercase;
            margin-bottom: 8px; 
            margin-top: 16px; 
            letter-spacing: 0.5px;
        }
        .filter-input { 
            width: 100%; 
            border: 1px solid var(--fdf-border); 
            border-radius: 12px; 
            padding: 10px 14px;
            font-size: 14px; 
            outline: none; 
            background: #F8FAFC;
            color: var(--fdf-text);
            font-weight: 500;
            transition: var(--transition-smooth);
        }
        .filter-input:focus {
            border-color: var(--brand-pink);
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }
        .filter-btn { 
            width: 100%; 
            background: linear-gradient(135deg, var(--brand-pink) 0%, var(--brand-pink-dark) 100%);
            color: #FFFFFF; 
            border: none; 
            border-radius: 99px; 
            padding: 12px; 
            font-weight: 700; 
            cursor: pointer; 
            margin-top: 20px; 
            font-size: 14px; 
            transition: var(--transition-smooth);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }
        .filter-btn:hover { 
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.35);
        }
        .filter-clear { 
            display: block; 
            text-align: center; 
            margin-top: 12px; 
            color: var(--fdf-muted);
            font-size: 13px; 
            text-decoration: none !important; 
            font-weight: 600; 
            transition: var(--transition-smooth);
        }
        .filter-clear:hover { 
            color: var(--brand-pink); 
        }

        .filter-action-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border-radius: 99px;
            padding: 10px 16px;
            text-align: center;
            text-decoration: none !important;
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 8px;
            transition: var(--transition-smooth);
        }
        .filter-action-link.primary {
            background: #FFF1F2;
            color: var(--brand-pink);
            border: 1px solid var(--brand-pink-light);
        }
        .filter-action-link.primary:hover {
            background: var(--brand-pink);
            color: #FFFFFF;
        }
        .filter-action-link.secondary {
            background: #F8FAFC;
            color: var(--fdf-text);
            border: 1px solid var(--fdf-border);
        }
        .filter-action-link.secondary:hover {
            background: #E2E8F0;
        }
 
        /* Featured Section */
        .featured-section { 
            background: linear-gradient(135deg, #FFFFFF 0%, #FFF1F2 100%); 
            border: 1px solid #FECDD3;
            border-radius: 24px;
            padding: 28px; 
            margin-bottom: 32px;
            box-shadow: 0 4px 16px rgba(244, 63, 94, 0.04);
        }
        .section-title { 
            font-size: 20px; 
            font-weight: 800; 
            color: var(--fdf-text); 
            margin-bottom: 20px;
            display: flex; 
            align-items: center; 
            gap: 10px; 
            letter-spacing: -0.3px;
        }
        .featured-scroll { 
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 24px;
        }
        .featured-card { 
            background: #FFFFFF; 
            border-radius: 20px;
            overflow: hidden; 
            box-shadow: var(--shadow-sm); 
            border: 1px solid var(--fdf-border);
            transition: var(--transition-smooth); 
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .featured-card:hover { 
            transform: translateY(-4px); 
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
            border-color: var(--brand-pink-light);
        }
 
        /* Event cards */
        .events-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 24px; 
        }
        .event-card { 
            background: #FFFFFF; 
            border-radius: 20px; 
            overflow: hidden;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.03); 
            transition: var(--transition-smooth); 
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .event-card:hover { 
            transform: translateY(-4px); 
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08); 
            border-color: var(--brand-pink-light);
        }
        .card-img-wrap { 
            position: relative; 
            overflow: hidden; 
            height: 190px;
            background: #F1F5F9;
        }
        .card-banner { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
            transition: transform 0.3s ease;
        }
        .event-card:hover .card-banner, .featured-card:hover .card-banner {
            transform: scale(1.04);
        }
        .card-banner-placeholder { 
            width: 100%; 
            height: 100%; 
            background: linear-gradient(135deg, #FFF1F2 0%, #FFE4E6 100%);
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 3rem; 
        }
        .card-body { 
            padding: 22px 20px; 
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .card-cat { 
            font-size: 11px; 
            font-weight: 800; 
            text-transform: uppercase; 
            letter-spacing: 0.8px;
            color: var(--brand-pink); 
            margin-bottom: 8px; 
        }
        .card-title { 
            font-size: 18px; 
            font-weight: 800; 
            margin-bottom: 12px; 
            line-height: 1.35;
            color: var(--fdf-text);
            overflow-wrap: anywhere;
            word-break: break-word;
        }
        .card-meta { 
            display: flex; 
            flex-direction: column; 
            gap: 8px; 
            margin-bottom: 18px; 
        }
        .card-meta span { 
            font-size: 13px; 
            color: var(--fdf-muted); 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            font-weight: 500;
            overflow-wrap: anywhere;
            word-break: break-word;
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
            padding-top: 14px;
            border-top: 1px solid var(--fdf-border);
        }
        .fee-badge { 
            background: var(--bg-secondary); 
            color: var(--brand-pink); 
            border-radius: 99px; 
            padding: 5px 14px; 
            font-size: 13px; 
            font-weight: 800; 
        }
        .fee-badge.free { 
            background: #F0FDF4; 
            color: #16A34A; 
        }
        .featured-badge { 
            position: absolute; 
            top: 12px; 
            left: 12px; 
            background: var(--brand-pink);
            color: #FFFFFF; 
            font-size: 11px; 
            font-weight: 800; 
            padding: 4px 12px; 
            border-radius: 99px; 
            box-shadow: 0 4px 10px rgba(244, 63, 94, 0.25);
            z-index: 2;
        }
        .register-btn { 
            font-size: 13px; 
            font-weight: 700; 
            color: var(--brand-pink); 
            text-decoration: none !important; 
            border: 1.5px solid var(--brand-pink); 
            border-radius: 99px; 
            padding: 5px 14px;
            transition: var(--transition-smooth); 
        }
        .register-btn:hover { 
            background: var(--brand-pink); 
            color: #FFFFFF; 
            border-color: transparent;
        }
 
        /* Full-Width Organizer CTA Banner */
        .organizer-cta { 
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            border-radius: 28px; 
            padding: 48px 32px; 
            text-align: center; 
            margin: 40px auto 20px;
            width: 100%;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.08);
            position: relative;
            overflow: hidden;
            color: #FFFFFF;
        }
        .organizer-cta::after {
            content: '';
            position: absolute;
            bottom: -50px; right: -50px;
            width: 250px; height: 250px;
            background: radial-gradient(circle, rgba(244, 63, 94, 0.15) 0%, transparent 65%);
            border-radius: 50%;
        }
        .organizer-cta-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #FDA4AF;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 14px;
            border-radius: 99px;
            margin-bottom: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .organizer-cta h3 { 
            font-size: clamp(1.5rem, 3vw, 2rem); 
            font-weight: 900; 
            color: #FFFFFF; 
            margin-bottom: 10px; 
        }
        .organizer-cta p { 
            color: #94A3B8; 
            margin-bottom: 24px; 
            font-size: 15px; 
            max-width: 620px; 
            margin-left: auto; 
            margin-right: auto; 
            line-height: 1.6;
        }
        .organizer-cta .cta-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .cta-btn-primary { 
            background: linear-gradient(135deg, var(--brand-pink) 0%, var(--brand-pink-dark) 100%);
            color: #FFFFFF; 
            border: none; 
            border-radius: 99px;
            padding: 12px 28px; 
            font-weight: 700; 
            cursor: pointer;
            font-size: 14px; 
            text-decoration: none !important; 
            display: inline-block; 
            transition: var(--transition-smooth); 
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.35);
        }
        .cta-btn-primary:hover { 
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(244, 63, 94, 0.5);
            color: #FFFFFF;
        }
        .cta-btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: #FFFFFF;
            border-radius: 99px;
            padding: 12px 28px;
            font-weight: 700;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none !important;
            display: inline-block;
            transition: var(--transition-smooth);
        }
        .cta-btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            color: #FFFFFF;
            transform: translateY(-2px);
        }
 
        /* Empty State */
        .no-events {
            background-color: #FFFFFF !important;
            border: 1px solid var(--fdf-border) !important;
            border-radius: 24px;
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
    
    <!-- Content wrapper: data-skip-global-back prevents the automatic sidebar back button on top-level pages -->
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">

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

        <div class="we-browse-container">
            <!-- Dashboard Header / Hero -->
            <div class="hero-banner-section" data-aos="fade-down">
                <span class="hero-badge-pill"><i class="bi bi-sparkles"></i> Women Empowerment &amp; Community</span>
                <h1>Discover <span>Events Made for Women</span> 🌸</h1>
                <p>Discover workshops, conferences, wellness retreats, entrepreneurship masterclasses, fitness bootcamps, and inspiring community meetups curated for you.</p>
                
                <form method="get" action="${pageContext.request.contextPath}/women-events" class="search-bar">
                    <i class="bi bi-search" style="color:var(--brand-pink); font-size: 16px;"></i>
                    <input type="text" name="query" placeholder="Search events by name, topic, or keyword..." value="${query}"/>
                    <button type="submit">Search Events</button>
                </form>
            </div>

            <!-- Stats Strip -->
            <div class="stats-container-card" data-aos="fade-up">
                <div class="row justify-content-center g-3">
                    <div class="col-6 col-md-3 stat-item">
                        <div class="stat-num">${events.size()}</div>
                        <div class="stat-label">Events Available</div>
                    </div>
                    <div class="col-6 col-md-3 stat-item">
                        <div class="stat-num">6</div>
                        <div class="stat-label">Categories</div>
                    </div>
                    <div class="col-6 col-md-3 stat-item">
                        <div class="stat-num">${cities.size()}</div>
                        <div class="stat-label">Active Cities</div>
                    </div>
                    <div class="col-6 col-md-3 stat-item">
                        <div class="stat-num">100%</div>
                        <div class="stat-label">Verified Safe</div>
                    </div>
                </div>
            </div>

            <!-- Category Pills Scroll -->
            <div class="cat-scroll-outer mt-4 mb-4" data-aos="fade-up">
                <div class="cat-scroll-container">
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
            </div>

            <!-- Featured Events (if any) -->
            <c:if test="${not empty featuredEvents && empty selectedCategory && empty query}">
                <div class="featured-section" data-aos="fade-up">
                    <div class="section-title"><i class="bi bi-star-fill text-warning"></i> Featured Events</div>
                    <div class="featured-scroll">
                        <c:forEach var="ev" items="${featuredEvents}">
                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="featured-card" style="text-decoration:none; color:inherit;">
                                <div class="card-img-wrap">
                                    <c:choose>
                                        <c:when test="${empty ev.bannerImage}">
                                            <div class="card-banner-placeholder">🌸</div>
                                        </c:when>
                                        <c:when test="${ev.bannerImage.startsWith('http://') or ev.bannerImage.startsWith('https://')}">
                                            <img src="${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:when>
                                        <c:when test="${ev.bannerImage.startsWith('/')}">
                                            <img src="${pageContext.request.contextPath}${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="featured-badge"><i class="bi bi-star-fill"></i> Featured</span>
                                </div>
                                <div class="card-body">
                                    <div class="card-cat">${not empty ev.category ? ev.category.displayName : 'Event'}</div>
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
            </c:if>

            <!-- Recommended Events (shown only when multiple recommendations exist and not duplicating single events) -->
            <c:if test="${not empty recommendations && recommendations.size() > 1 && events.size() > 2 && empty selectedCategory && empty query}">
                <div class="featured-section" style="background: linear-gradient(135deg, #FFFFFF 0%, #EFF6FF 100%); border-color: #BFDBFE;" data-aos="fade-up">
                    <div class="section-title" style="color: var(--fdf-text);"><i class="bi bi-stars text-primary"></i> Recommended for You</div>
                    <div class="featured-scroll">
                        <c:forEach var="ev" items="${recommendations}">
                            <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="featured-card" style="text-decoration:none; color:inherit;">
                                <div class="card-img-wrap">
                                    <c:choose>
                                        <c:when test="${empty ev.bannerImage}">
                                            <div class="card-banner-placeholder">🌸</div>
                                        </c:when>
                                        <c:when test="${ev.bannerImage.startsWith('http://') or ev.bannerImage.startsWith('https://')}">
                                            <img src="${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:when>
                                        <c:when test="${ev.bannerImage.startsWith('/')}">
                                            <img src="${pageContext.request.contextPath}${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="featured-badge" style="background: var(--brand-pink);"><i class="bi bi-stars"></i> Recommended</span>
                                </div>
                                <div class="card-body">
                                    <div class="card-cat" style="color: var(--brand-pink);">${not empty ev.category ? ev.category.displayName : 'Event'}</div>
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
            </c:if>

            <!-- Main Grid -->
            <div class="main-grid" data-aos="fade-up">
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

                    <hr style="margin: 20px 0; border-color: var(--fdf-border);"/>

                    <c:if test="${not empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="filter-action-link primary">
                            <i class="bi bi-ticket-perforated-fill text-danger"></i> My Tickets
                        </a>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty loggedHost}">
                            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="filter-action-link primary">
                                <i class="bi bi-speedometer2 text-danger"></i> Organizer Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/women-events/host/logout" class="filter-action-link secondary">
                                <i class="bi bi-box-arrow-right"></i> Host Logout
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/women-events/host/register" class="filter-action-link primary">
                                <i class="bi bi-person-badge-fill text-warning"></i> Register as Host
                            </a>
                            <a href="${pageContext.request.contextPath}/women-events/host/login" class="filter-action-link secondary">
                                <i class="bi bi-box-arrow-in-right text-danger"></i> Host Login
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${empty loggedUser && empty loggedHost}">
                        <a href="${pageContext.request.contextPath}/login" class="filter-action-link primary" style="background: var(--brand-pink); color: #FFFFFF; border-color: transparent; margin-top: 10px;">
                            <i class="bi bi-person-circle"></i> Login to Register
                        </a>
                    </c:if>
                </aside>

                <!-- Events Grid -->
                <div>
                    <div class="mb-4 d-flex align-items-center justify-content-between flex-wrap gap-2">
                        <div style="font-size: 15px; color: var(--fdf-muted); font-weight:600;">
                            Showing <strong>${events.size()}</strong> event${events.size() != 1 ? 's' : ''}
                            <c:if test="${not empty selectedCategory}"> in <strong>${selectedCategory}</strong></c:if>
                            <c:if test="${not empty selectedCity}"> in <strong>${selectedCity}</strong></c:if>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty events}">
                            <div class="events-grid">
                                <c:forEach var="ev" items="${events}">
                                    <div class="event-card">
                                        <a href="${pageContext.request.contextPath}/women-events/${ev.id}" style="text-decoration:none; color:inherit; display:flex; flex-direction:column; height:100%;">
                                            <div class="card-img-wrap">
                                                <c:choose>
                                                    <c:when test="${empty ev.bannerImage}">
                                                        <div class="card-banner-placeholder">
                                                            <c:choose>
                                                                <c:when test="${ev.category == 'HEALTH_WELLNESS'}">❤️</c:when>
                                                                <c:when test="${ev.category == 'ENTREPRENEURSHIP_CAREER'}">💼</c:when>
                                                                <c:when test="${ev.category == 'FITNESS_SPORTS'}">🏃‍♀️</c:when>
                                                                <c:when test="${ev.category == 'EDUCATION_SKILLS'}">📚</c:when>
                                                                <c:when test="${ev.category == 'SOCIAL_COMMUNITY'}">🤝</c:when>
                                                                <c:otherwise>🌸</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${ev.bannerImage.startsWith('http://') or ev.bannerImage.startsWith('https://')}">
                                                        <img src="${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                                    </c:when>
                                                    <c:when test="${ev.bannerImage.startsWith('/')}">
                                                        <img src="${pageContext.request.contextPath}${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/uploads/${ev.bannerImage}" class="card-banner" alt="${ev.name}" onerror="this.outerHTML='<div class=\'card-banner-placeholder\'>🌸</div>';"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${ev.featured}">
                                                    <span class="featured-badge"><i class="bi bi-star-fill"></i> Featured</span>
                                                </c:if>
                                            </div>
                                            <div class="card-body">
                                                <div class="card-cat">${not empty ev.category ? ev.category.displayName : 'Event'}</div>
                                                <h4 class="card-title">${ev.name}</h4>
                                                <div class="card-meta">
                                                    <span><i class="bi bi-calendar3"></i> ${not empty ev.eventDate ? ev.eventDate : 'Date not provided'}</span>
                                                    <span><i class="bi bi-geo-alt"></i> ${not empty ev.venue ? ev.venue : 'Venue not provided'}<c:if test="${not empty ev.city}">, ${ev.city}</c:if></span>
                                                    <span><i class="bi bi-person"></i> ${not empty ev.organizerName ? ev.organizerName : 'Organizer not provided'}</span>
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
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-events text-center py-5 text-muted bg-white rounded-4 border shadow-sm">
                                <span class="display-3 mb-3 d-block">🌸</span>
                                <h4 class="fw-bold text-dark mb-2">No Events Found</h4>
                                <p class="small text-muted mb-0">Currently there are no events matching your criteria. Try clearing your filters or check back later!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Full-Width Organizer CTA -->
            <div class="organizer-cta" data-aos="fade-up">
                <span class="organizer-cta-badge"><i class="bi bi-patch-check-fill"></i> For Organizers &amp; Communities</span>
                <h3>🌺 Host Your Own Event</h3>
                <p>NGOs, colleges, fitness trainers, women clubs, or entrepreneurs. Reach thousands of women eager to connect, learn, and grow together on Fight D Fear.</p>
                <div class="cta-actions">
                    <c:choose>
                        <c:when test="${not empty loggedHost}">
                            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="cta-btn-primary">
                                <i class="bi bi-speedometer2 me-1"></i> Organizer Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="cta-btn-secondary">
                                <i class="bi bi-plus-circle me-1"></i> Create New Event
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/women-events/host/register" class="cta-btn-primary">
                                <i class="bi bi-person-badge-fill me-1"></i> Register to Host
                            </a>
                            <a href="${pageContext.request.contextPath}/women-events/host/login" class="cta-btn-secondary">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Host Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div><!-- /.we-browse-container -->

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
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
