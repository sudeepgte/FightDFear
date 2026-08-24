<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><c:out value="${center.name}"/> - Martial Arts Training & Batches | Fight D Fear</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700;800;900&family=Poppins:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Icons & CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

    <style>
        :root {
            --navy: #0F172A;
            --navy-surface: #1E293B;
            --navy-deep: #0B0F19;
            --primary-red: #F43F5E;
            --primary-red-hover: #E11D48;
            --primary-red-light: rgba(244, 63, 94, 0.08);
            --primary-red-border: rgba(244, 63, 94, 0.2);
            --emerald: #10B981;
            --emerald-light: rgba(16, 185, 129, 0.1);
            --amber: #F59E0B;
            --amber-light: rgba(245, 158, 11, 0.1);
            --text-dark: #0F172A;
            --text-body: #334155;
            --text-muted: #64748B;
            --light-bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --radius-xl: 20px;
            --radius-lg: 14px;
            --radius-md: 10px;
            --radius-pill: 9999px;
            --shadow-card: 0 4px 20px -2px rgba(15, 23, 42, 0.06), 0 2px 6px -1px rgba(15, 23, 42, 0.04);
            --shadow-hover: 0 16px 32px -4px rgba(15, 23, 42, 0.12), 0 6px 12px -2px rgba(15, 23, 42, 0.06);
            --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-body);
            line-height: 1.6;
            padding-bottom: 70px;
        }

        h1, h2, h3, h4, h5, h6, .heading-font {
            font-family: 'Montserrat', sans-serif;
            color: var(--text-dark);
            font-weight: 700;
        }

        .outfit-font {
            font-family: 'Outfit', sans-serif;
        }

        /* ======= Header Navigation ======= */
        .site-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }

        .site-logo {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--primary-red);
            text-decoration: none;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .site-logo img {
            height: 38px;
            width: 38px;
            border-radius: 10px;
            object-fit: cover;
            box-shadow: 0 2px 8px rgba(244, 63, 94, 0.25);
        }

        .nav-link-custom {
            color: var(--text-body);
            font-weight: 600;
            font-size: 0.92rem;
            padding: 8px 14px;
            border-radius: var(--radius-pill);
            text-decoration: none;
            transition: var(--transition);
        }

        .nav-link-custom:hover {
            color: var(--primary-red);
            background: var(--primary-red-light);
        }

        .nav-link-custom.active {
            color: var(--primary-red);
            background: var(--primary-red-light);
            font-weight: 700;
        }

        /* ======= Breadcrumbs & Top Bar ======= */
        .breadcrumb-bar {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 12px 0;
            font-size: 0.88rem;
        }

        .back-link {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--primary-red);
            transform: translateX(-3px);
        }

        /* ======= Modern Centre Hero ======= */
        .centre-hero-card {
            background: linear-gradient(135deg, #0F172A 0%, #1E1B4B 60%, #312E81 100%);
            border-radius: var(--radius-xl);
            color: #FFFFFF;
            padding: 36px 32px;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.15);
            position: relative;
            overflow: hidden;
            margin-bottom: 32px;
        }

        .centre-hero-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(244, 63, 94, 0.18) 0%, rgba(244, 63, 94, 0) 70%);
            pointer-events: none;
        }

        .centre-avatar {
            width: 110px;
            height: 110px;
            border-radius: 20px;
            object-fit: cover;
            border: 3px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
            background: #FFFFFF;
            flex-shrink: 0;
        }

        .centre-avatar-fallback {
            width: 110px;
            height: 110px;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--primary-red) 0%, #BE123C 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #FFFFFF;
            border: 3px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
            flex-shrink: 0;
        }

        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(16, 185, 129, 0.18);
            border: 1px solid rgba(16, 185, 129, 0.4);
            color: #34D399;
            font-weight: 700;
            font-size: 0.78rem;
            padding: 4px 12px;
            border-radius: var(--radius-pill);
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .hero-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(6px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #F1F5F9;
            font-size: 0.82rem;
            font-weight: 500;
            padding: 5px 14px;
            border-radius: var(--radius-pill);
        }

        .hero-pill i {
            color: #FDA4AF;
        }

        .btn-hero-book {
            background: var(--primary-red);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 0.95rem;
            padding: 12px 28px;
            border-radius: var(--radius-pill);
            border: none;
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.4);
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-hero-book:hover {
            background: var(--primary-red-hover);
            color: #FFFFFF;
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(244, 63, 94, 0.5);
        }

        .btn-hero-contact {
            background: rgba(255, 255, 255, 0.12);
            color: #FFFFFF;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 12px 24px;
            border-radius: var(--radius-pill);
            border: 1px solid rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-hero-contact:hover {
            background: rgba(255, 255, 255, 0.22);
            color: #FFFFFF;
            border-color: rgba(255, 255, 255, 0.4);
        }

        /* ======= Section Header ======= */
        .section-header {
            margin-bottom: 24px;
        }

        .section-title {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-subtitle {
            color: var(--text-muted);
            font-size: 0.92rem;
            margin-bottom: 0;
        }

        /* ======= Cult-Style Filter Bar ======= */
        .filter-container {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-card);
        }

        .filter-scroll-row {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding-bottom: 4px;
            scrollbar-width: thin;
        }

        .filter-scroll-row::-webkit-scrollbar {
            height: 4px;
        }

        .filter-scroll-row::-webkit-scrollbar-thumb {
            background: #CBD5E1;
            border-radius: 4px;
        }

        .filter-chip {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            color: var(--text-dark);
            padding: 6px 16px;
            border-radius: var(--radius-pill);
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: var(--transition);
            user-select: none;
        }

        .filter-chip:hover {
            border-color: var(--primary-red);
            color: var(--primary-red);
            background: var(--primary-red-light);
        }

        .filter-chip.active {
            background: var(--navy);
            color: #FFFFFF;
            border-color: var(--navy);
            box-shadow: 0 4px 10px rgba(15, 23, 42, 0.18);
        }

        /* ======= Cult-Style Batch Cards ======= */
        .batch-card {
            background: var(--card-bg);
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-card);
            transition: var(--transition);
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            cursor: pointer;
        }

        .batch-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
            border-color: #CBD5E1;
        }

        .batch-card.selected {
            border-color: var(--primary-red);
            box-shadow: 0 0 0 2px var(--primary-red), var(--shadow-hover);
            background: linear-gradient(180deg, #FFFFFF 0%, #FFF5F7 100%);
        }

        .batch-badge-style {
            background: var(--primary-red-light);
            color: var(--primary-red);
            border: 1px solid var(--primary-red-border);
            font-weight: 700;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .batch-badge-level {
            background: #F1F5F9;
            color: #475569;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
        }

        .batch-badge-mode {
            background: #E0E7FF;
            color: #3730A3;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
        }

        .batch-title {
            font-size: 1.18rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-top: 12px;
            margin-bottom: 14px;
            line-height: 1.35;
        }

        .batch-meta-row {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 10px;
            font-size: 0.87rem;
        }

        .batch-meta-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 0.88rem;
            flex-shrink: 0;
        }

        .batch-meta-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 600;
            letter-spacing: 0.4px;
            display: block;
            line-height: 1.2;
        }

        .batch-meta-value {
            font-weight: 600;
            color: var(--text-dark);
            line-height: 1.3;
        }

        /* Seats Progress */
        .seat-progress-box {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 10px 14px;
            margin-top: 14px;
            margin-bottom: 16px;
        }

        .seat-progress-bar {
            height: 6px;
            border-radius: 4px;
            background: #E2E8F0;
            overflow: hidden;
            margin-top: 6px;
        }

        .seat-progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #10B981 0%, #F59E0B 80%, #EF4444 100%);
            border-radius: 4px;
            transition: width 0.4s ease;
        }

        .batch-price-row {
            border-top: 1px dashed var(--border-color);
            padding-top: 14px;
            margin-top: 14px;
            display: flex;
            align-items: baseline;
            justify-content: space-between;
        }

        .batch-price {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--navy);
        }

        .batch-price-period {
            font-size: 0.8rem;
            font-weight: 500;
            color: var(--text-muted);
        }

        .batch-admission-fee {
            font-size: 0.76rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .btn-book-batch {
            background: var(--primary-red);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 0.9rem;
            padding: 10px 20px;
            border-radius: var(--radius-pill);
            border: none;
            width: 100%;
            margin-top: 14px;
            text-align: center;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }

        .btn-book-batch:hover {
            background: var(--primary-red-hover);
            color: #FFFFFF;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.35);
        }

        .btn-batch-disabled {
            background: #E2E8F0;
            color: #94A3B8;
            font-weight: 700;
            font-size: 0.9rem;
            padding: 10px 20px;
            border-radius: var(--radius-pill);
            border: none;
            width: 100%;
            margin-top: 14px;
            cursor: not-allowed;
            text-align: center;
        }

        /* ======= Content Card & Info Sections ======= */
        .info-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 28px;
            box-shadow: var(--shadow-card);
            margin-bottom: 28px;
        }

        .info-card-title {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-card-title i {
            color: var(--primary-red);
            font-size: 1.25rem;
        }

        .teaching-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .teaching-list li {
            position: relative;
            padding-left: 30px;
            margin-bottom: 12px;
            font-size: 0.93rem;
            color: var(--text-body);
        }

        .teaching-list li i {
            position: absolute;
            left: 0;
            top: 4px;
            color: var(--emerald);
            font-size: 1rem;
        }

        .feature-chip {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            color: var(--text-dark);
            padding: 8px 16px;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-right: 8px;
            margin-bottom: 10px;
        }

        .feature-chip i {
            color: var(--primary-red);
        }

        /* ======= Training Gallery ======= */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
        }

        .gallery-img-card {
            border-radius: var(--radius-lg);
            overflow: hidden;
            height: 180px;
            position: relative;
            background: #000000;
            box-shadow: var(--shadow-card);
        }

        .gallery-img-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .gallery-img-card:hover img {
            transform: scale(1.08);
            opacity: 0.9;
        }

        /* ======= Sticky Booking Summary (Desktop) ======= */
        .sticky-summary-box {
            position: sticky;
            top: 90px;
            background: var(--card-bg);
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 26px;
            box-shadow: var(--shadow-card);
            transition: var(--transition);
        }

        .summary-header {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 14px;
            margin-bottom: 18px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 0.88rem;
        }

        .summary-label {
            color: var(--text-muted);
            font-weight: 500;
        }

        .summary-val {
            font-weight: 700;
            color: var(--text-dark);
            text-align: right;
        }

        .summary-total-box {
            background: var(--light-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 16px;
            margin-top: 18px;
            margin-bottom: 18px;
        }

        /* ======= Mobile Bottom Sticky Bar ======= */
        .mobile-bottom-bar {
            display: none;
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: #FFFFFF;
            border-top: 1px solid var(--border-color);
            padding: 12px 20px;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.08);
            z-index: 1040;
        }

        @media (max-width: 991.98px) {
            .mobile-bottom-bar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 14px;
            }
            .sticky-summary-box {
                position: static;
                margin-top: 24px;
            }
        }

        /* ======= Footer ======= */
        .site-footer {
            background: var(--navy-deep);
            color: #94A3B8;
            padding: 48px 0 24px;
            margin-top: 60px;
            font-size: 0.9rem;
        }

        .site-footer a {
            color: #CBD5E1;
            text-decoration: none;
            transition: var(--transition);
        }

        .site-footer a:hover {
            color: var(--primary-red);
        }
    </style>
</head>
<body>

    <!-- ======= Header ======= -->
    <header class="site-header py-2">
        <div class="container-xl d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/users/dashboard" class="site-logo">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
                <span>Fight D Fear</span>
            </a>

            <!-- Desktop Nav -->
            <nav class="d-none d-lg-flex align-items-center gap-1">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="nav-link-custom">Dashboard</a>
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link-custom active">Martial Arts Centres</a>
                <a href="${pageContext.request.contextPath}/video/reels" class="nav-link-custom">Reels</a>
                <a href="${pageContext.request.contextPath}/user/bookings" class="nav-link-custom">My Bookings</a>
                <c:if test="${not empty user}">
                    <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link-custom">Profile</a>
                </c:if>
            </nav>

            <!-- User / Auth Actions -->
            <div class="d-flex align-items-center gap-2">
                <a class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-semibold" href="${pageContext.request.contextPath}/qna">
                    <i class="bi bi-question-circle me-1"></i> Q&amp;A
                </a>
                <c:choose>
                    <c:when test="${not empty user}">
                        <a class="btn btn-sm btn-danger rounded-pill px-3 fw-bold" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-sm btn-danger rounded-pill px-4 fw-bold" href="${pageContext.request.contextPath}/login">
                            Login
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- ======= Breadcrumb & Return Bar ======= -->
    <div class="breadcrumb-bar">
        <div class="container-xl d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Martial Arts Centres
            </a>
            <div class="d-none d-md-flex align-items-center gap-2">
                <span class="badge bg-light text-muted border px-3 py-1 rounded-pill">
                    <i class="fas fa-shield-halved text-danger me-1"></i> Verified Platform Center
                </span>
            </div>
        </div>
    </div>

    <!-- ======= Main Page Container ======= -->
    <main class="container-xl my-4">

        <!-- ======= Compact Centre Profile Hero ======= -->
        <div class="centre-hero-card">
            <div class="row align-items-center gy-4">
                <div class="col-lg-8">
                    <div class="d-flex flex-column flex-sm-row align-items-start gap-4">
                        
                        <!-- Centre Photo / Fallback Avatar -->
                        <c:choose>
                            <c:when test="${not empty center.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${center.profilePhoto}" alt="${center.name}" class="centre-avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="centre-avatar-fallback">
                                    <i class="fas fa-shield-halved"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div>
                            <!-- Verified Badge -->
                            <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                                <span class="verified-badge">
                                    <i class="fas fa-check-circle"></i> Verified Centre
                                </span>
                                <c:if test="${not empty center.centreType}">
                                    <span class="hero-pill">
                                        <i class="fas fa-building"></i> ${center.centreType}
                                    </span>
                                </c:if>
                                <c:if test="${not empty center.affiliation and center.affiliation != 'None'}">
                                    <span class="hero-pill">
                                        <i class="fas fa-certificate"></i> ${center.affiliation}
                                    </span>
                                </c:if>
                            </div>

                            <!-- Centre Name & Tagline -->
                            <h1 class="text-white mb-1" style="font-size: 2.1rem; letter-spacing: -0.5px;">
                                <c:out value="${center.name}"/>
                            </h1>
                            <p class="text-white-50 mb-3" style="font-size: 0.95rem;">
                                <c:choose>
                                    <c:when test="${not empty center.designation}">
                                        ${center.designation} • Discipline • Strength • Confidence
                                    </c:when>
                                    <c:otherwise>
                                        Discipline • Strength • Confidence
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <!-- Key Metrics Row -->
                            <div class="d-flex flex-wrap gap-2">
                                <c:if test="${not empty center.location}">
                                    <div class="hero-pill">
                                        <i class="fas fa-map-marker-alt"></i> <c:out value="${center.location}"/>
                                    </div>
                                </c:if>
                                <c:if test="${not empty center.city}">
                                    <div class="hero-pill">
                                        <i class="fas fa-city"></i> <c:out value="${center.city}"/>
                                    </div>
                                </c:if>
                                <c:if test="${not empty batches}">
                                    <div class="hero-pill">
                                        <i class="fas fa-layer-group"></i> ${fn:length(batches)} Active Batches
                                    </div>
                                </c:if>
                                <c:if test="${center.womenOnlyBatches}">
                                    <div class="hero-pill" style="background: rgba(244, 63, 94, 0.2); border-color: rgba(244, 63, 94, 0.4);">
                                        <i class="fas fa-venus text-white"></i> Women-Only Batches
                                    </div>
                                </c:if>
                                <c:if test="${center.femaleInstructor}">
                                    <div class="hero-pill">
                                        <i class="fas fa-user-shield"></i> Female Instructor
                                    </div>
                                </c:if>
                                <c:if test="${not empty center.rating and center.rating > 0}">
                                    <div class="hero-pill" style="background: rgba(245, 158, 11, 0.2); border-color: rgba(245, 158, 11, 0.4);">
                                        <i class="fas fa-star text-warning"></i> <fmt:formatNumber value="${center.rating}" maxFractionDigits="1"/>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hero Actions -->
                <div class="col-lg-4 text-lg-end">
                    <div class="d-flex flex-sm-row flex-lg-column justify-content-lg-end gap-2">
                        <a href="#batches-section" class="btn-hero-book">
                            <i class="fas fa-calendar-check"></i> Explore Batches
                        </a>
                        <c:if test="${not empty center.phoneNumber or not empty center.email}">
                            <a href="#contact-section" class="btn-hero-contact">
                                <i class="fas fa-phone-volume"></i> Contact Centre
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- ======= Main Content Grid ======= -->
        <div class="row g-4">

            <!-- Left Main Column (Batches, About, Methodology, Gallery, Contact) -->
            <div class="col-lg-8">

                <!-- ============================================== -->
                <!-- 1. PRIMARY SECTION: AVAILABLE TRAINING BATCHES -->
                <!-- ============================================== -->
                <section id="batches-section" class="mb-5">
                    <div class="section-header d-flex flex-wrap justify-content-between align-items-end gap-2">
                        <div>
                            <h2 class="section-title">
                                <i class="fas fa-bolt text-danger"></i> Available Training Batches
                            </h2>
                            <p class="section-subtitle">
                                Choose a program and schedule that fits your goals. Instant seat confirmation.
                            </p>
                        </div>
                        <c:if test="${not empty batches}">
                            <span class="badge bg-dark text-white rounded-pill px-3 py-2 fw-bold" style="font-size: 0.82rem;">
                                ${fn:length(batches)} Batches
                            </span>
                        </c:if>
                    </div>

                    <!-- Interactive Client-Side Filter Bar -->
                    <c:if test="${not empty batches}">
                        <div class="filter-container">
                            <div class="d-flex flex-column gap-3">
                                <!-- Martial Arts Style Filters -->
                                <div>
                                    <small class="text-muted fw-bold text-uppercase d-block mb-2" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                                        Filter by Martial Arts Discipline
                                    </small>
                                    <div class="filter-scroll-row" id="style-filters">
                                        <button type="button" class="filter-chip active" data-filter-type="style" data-filter-val="all">All Styles</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Karate">Karate</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Taekwondo">Taekwondo</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Krav Maga">Krav Maga</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Boxing">Boxing</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Kickboxing">Kickboxing</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Jiu-Jitsu">Jiu-Jitsu</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Muay Thai">Muay Thai</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Kung Fu">Kung Fu</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="MMA">MMA</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Judo">Judo</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Kalaripayattu">Kalaripayattu</button>
                                        <button type="button" class="filter-chip" data-filter-type="style" data-filter-val="Self-Defence">Self-Defence</button>
                                    </div>
                                </div>

                                <!-- Skill Level & Mode Filters -->
                                <div class="d-flex flex-wrap gap-2 pt-2 border-top">
                                    <div class="filter-scroll-row" id="level-filters">
                                        <button type="button" class="filter-chip active" data-filter-type="level" data-filter-val="all">All Levels</button>
                                        <button type="button" class="filter-chip" data-filter-type="level" data-filter-val="Beginner">Beginner</button>
                                        <button type="button" class="filter-chip" data-filter-type="level" data-filter-val="Intermediate">Intermediate</button>
                                        <button type="button" class="filter-chip" data-filter-type="level" data-filter-val="Advanced">Advanced</button>
                                    </div>
                                    <div class="ms-auto filter-scroll-row" id="mode-filters">
                                        <button type="button" class="filter-chip active" data-filter-type="mode" data-filter-val="all">All Modes</button>
                                        <button type="button" class="filter-chip" data-filter-type="mode" data-filter-val="Offline">At Centre</button>
                                        <button type="button" class="filter-chip" data-filter-type="mode" data-filter-val="Online">Online</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Batch Cards Grid -->
                    <div class="row g-4" id="batches-grid">
                        <c:forEach var="batch" items="${batches}" varStatus="status">
                            <c:set var="enrolled" value="${enrolledCountByBatch[batch.id]}"/>
                            <c:if test="${empty enrolled}"><c:set var="enrolled" value="0"/></c:if>
                            <c:set var="isCapacitySet" value="${batch.capacity != null && batch.capacity > 0}"/>
                            <c:set var="isFull" value="${isCapacitySet && enrolled >= batch.capacity}"/>
                            <c:set var="isClosed" value="${batch.status != null && batch.status.equalsIgnoreCase('Closed')}"/>
                            
                            <%-- Calculate percentage filled --%>
                            <c:set var="pctFilled" value="0"/>
                            <c:if test="${isCapacitySet}">
                                <c:set var="pctFilled" value="${(enrolled * 100) / batch.capacity}"/>
                            </c:if>

                            <div class="col-md-6 batch-card-item" 
                                 data-style="${not empty batch.style ? batch.style : 'General'}" 
                                 data-level="${not empty batch.skillLevel ? batch.skillLevel : 'All'}" 
                                 data-mode="${not empty batch.batchType ? batch.batchType : 'Offline'}">
                                
                                <div class="batch-card ${status.first ? 'selected' : ''}" 
                                     id="batch-card-${batch.id}"
                                     onclick="selectBatch('${batch.id}', '${center.id}', '${fn:escapeXml(batch.name)}', '${fn:escapeXml(batch.style)}', '${fn:escapeXml(batch.instructor)}', '${fn:escapeXml(batch.availableDays)}', '${fn:escapeXml(batch.timeSlot)}', '${batch.fee}', '${batch.admissionFee}', ${isFull || isClosed})">
                                    
                                    <div>
                                        <!-- Top Badges Row -->
                                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                                            <div class="d-flex flex-wrap align-items-center gap-1">
                                                <span class="batch-badge-style">
                                                    <c:out value="${not empty batch.style ? batch.style : 'Martial Arts'}"/>
                                                </span>
                                                <c:if test="${not empty batch.skillLevel}">
                                                    <span class="batch-badge-level">
                                                        <c:out value="${batch.skillLevel}"/>
                                                    </span>
                                                </c:if>
                                            </div>
                                            <span class="batch-badge-mode">
                                                <i class="${batch.batchType != null && batch.batchType.equalsIgnoreCase('Online') ? 'bi bi-camera-video' : 'bi bi-geo-alt'} me-1"></i>
                                                <c:out value="${not empty batch.batchType ? batch.batchType : 'Offline'}"/>
                                            </span>
                                        </div>

                                        <!-- Batch Name -->
                                        <h3 class="batch-title">
                                            <c:out value="${batch.name}"/>
                                        </h3>

                                        <!-- Meta Info Hierarchy -->
                                        <div class="batch-meta-row">
                                            <div class="batch-meta-icon">
                                                <i class="fas fa-user-tie text-danger"></i>
                                            </div>
                                            <div>
                                                <span class="batch-meta-label">Lead Instructor</span>
                                                <span class="batch-meta-value">
                                                    <c:out value="${not empty batch.instructor ? batch.instructor : 'Certified Master Instructor'}"/>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="batch-meta-row">
                                            <div class="batch-meta-icon">
                                                <i class="fas fa-calendar-week text-primary"></i>
                                            </div>
                                            <div>
                                                <span class="batch-meta-label">Schedule Days</span>
                                                <span class="batch-meta-value">
                                                    <c:choose>
                                                        <c:when test="${not empty batch.availableDays}">
                                                            <c:out value="${batch.availableDays}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Mon • Wed • Fri
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="batch-meta-row">
                                            <div class="batch-meta-icon">
                                                <i class="fas fa-clock text-warning"></i>
                                            </div>
                                            <div>
                                                <span class="batch-meta-label">Time &amp; Duration</span>
                                                <span class="batch-meta-value">
                                                    <c:out value="${not empty batch.timeSlot ? batch.timeSlot : 'Flexible Timings'}"/>
                                                    <c:if test="${not empty batch.durationMinutes and batch.durationMinutes > 0}">
                                                        (${batch.durationMinutes} mins)
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>

                                        <c:if test="${not empty batch.ageGroup}">
                                            <div class="batch-meta-row">
                                                <div class="batch-meta-icon">
                                                    <i class="fas fa-users text-info"></i>
                                                </div>
                                                <div>
                                                    <span class="batch-meta-label">Age Group</span>
                                                    <span class="batch-meta-value">
                                                        <c:out value="${batch.ageGroup}"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Capacity & Seats Bar -->
                                        <c:if test="${isCapacitySet}">
                                            <div class="seat-progress-box">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="small fw-semibold text-muted">
                                                        <i class="bi bi-person-check me-1"></i> Available Seats
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${isFull}">
                                                            <span class="badge bg-danger rounded-pill px-2 py-1">FULL</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-1">
                                                                ${enrolled} / ${batch.capacity} Enrolled
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="seat-progress-bar">
                                                    <div class="seat-progress-fill" style="width: ${pctFilled > 100 ? 100 : pctFilled}%;"></div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Bottom Pricing & CTA -->
                                    <div>
                                        <div class="batch-price-row">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${batch.fee == null || batch.fee == 0}">
                                                        <span class="batch-price text-success">FREE</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="batch-price">&#8377;<fmt:formatNumber value="${batch.fee}" maxFractionDigits="0"/></span>
                                                        <span class="batch-price-period">/ month</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty batch.admissionFee and batch.admissionFee > 0}">
                                                    <div class="batch-admission-fee">
                                                        + &#8377;<fmt:formatNumber value="${batch.admissionFee}" maxFractionDigits="0"/> one-time admission
                                                    </div>
                                                </c:if>
                                            </div>
                                            <c:if test="${not empty batch.status}">
                                                <span class="badge ${isFull ? 'bg-danger' : (isClosed ? 'bg-secondary' : 'bg-primary-subtle text-primary')} rounded-pill px-3 py-1 text-uppercase" style="font-size: 0.72rem;">
                                                    <c:out value="${isFull ? 'FULL' : batch.status}"/>
                                                </span>
                                            </c:if>
                                        </div>

                                        <!-- Booking Action Button -->
                                        <c:choose>
                                            <c:when test="${isFull}">
                                                <button class="btn-batch-disabled" disabled>
                                                    <i class="bi bi-x-circle me-1"></i> Batch Full
                                                </button>
                                            </c:when>
                                            <c:when test="${isClosed}">
                                                <button class="btn-batch-disabled" disabled>
                                                    <i class="bi bi-lock me-1"></i> Batch Closed
                                                </button>
                                            </c:when>
                                            <c:when test="${not empty user}">
                                                <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batch.id}" class="btn-book-batch">
                                                    <span>BOOK THIS BATCH</span>
                                                    <i class="fas fa-arrow-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}%3FbatchId%3D${batch.id}" class="btn-book-batch">
                                                    <span>LOGIN TO BOOK</span>
                                                    <i class="fas fa-arrow-right"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Empty State if no batches exist in backend -->
                        <c:if test="${empty batches}">
                            <div class="col-12">
                                <div class="info-card text-center py-5">
                                    <div class="mb-3 text-muted" style="font-size: 3rem;">
                                        <i class="fas fa-calendar-xmark"></i>
                                    </div>
                                    <h4 class="fw-bold mb-2">No Training Batches Available</h4>
                                    <p class="text-muted mb-4 max-w-md mx-auto">
                                        This centre hasn't published any upcoming training batches yet. You can contact the centre directly or explore other nearby martial arts centres.
                                    </p>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-outline-dark rounded-pill px-4">
                                            Explore Other Centres
                                        </a>
                                        <a href="#contact-section" class="btn btn-danger rounded-pill px-4">
                                            Contact Centre
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Filter Empty State (Hidden by default) -->
                    <div id="filter-empty-state" class="info-card text-center py-5 d-none">
                        <div class="mb-3 text-muted" style="font-size: 2.5rem;">
                            <i class="fas fa-filter-circle-xmark"></i>
                        </div>
                        <h5 class="fw-bold mb-1">No Batches Match Your Filter</h5>
                        <p class="text-muted small mb-3">Try clearing or selecting a different discipline or skill level.</p>
                        <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="resetAllFilters()">
                            Reset Filters
                        </button>
                    </div>
                </section>

                <!-- ============================================== -->
                <!-- 2. CENTRE INFORMATION (ABOUT & HOW WE TEACH)   -->
                <!-- ============================================== -->
                <section class="mb-5">
                    <!-- About Card -->
                    <div class="info-card">
                        <h2 class="info-card-title">
                            <i class="fas fa-info-circle"></i> About the Centre
                        </h2>
                        <div class="text-secondary" style="font-size: 0.95rem; line-height: 1.7;">
                            <c:choose>
                                <c:when test="${not empty center.about}">
                                    <c:out value="${center.about}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${center.name}"/> is a verified professional martial arts training facility dedicated to building self-defense mastery, mental fortitude, and supreme physical fitness under certified instructors.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- How We Teach Card -->
                    <div class="info-card">
                        <h2 class="info-card-title">
                            <i class="fas fa-graduation-cap"></i> How We Teach
                        </h2>
                        <c:choose>
                            <c:when test="${not empty center.howWeTeach}">
                                <div class="text-secondary" style="font-size: 0.95rem; line-height: 1.7;">
                                    ${center.howWeTeach}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <ul class="teaching-list">
                                    <li>
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Comprehensive Warm-Up &amp; Mobility:</strong> Injury-prevention conditioning and dynamic flexibility before every training session.
                                    </li>
                                    <li>
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Structured Progressive Curriculum:</strong> Step-by-step biomechanical skill progressions from foundational stances to advanced strikes and counters.
                                    </li>
                                    <li>
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Controlled Practical Sparring:</strong> Safe, supervised real-time application and reaction drills tailored to each student's belt level.
                                    </li>
                                    <li>
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Mindset, Discipline &amp; Self-Defense:</strong> High focus on situational awareness, de-escalation, confidence, and respect.
                                    </li>
                                    <li>
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Individualized Coaching:</strong> Continuous instructor feedback and periodic belt-ranking assessments.
                                    </li>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- What We Offer & Facilities -->
                    <div class="info-card">
                        <h2 class="info-card-title">
                            <i class="fas fa-award"></i> Programs &amp; Facilities
                        </h2>
                        
                        <h6 class="fw-bold text-dark mb-2 small text-uppercase" style="letter-spacing: 0.5px;">Training Highlights</h6>
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${not empty center.whatWeOffer}">
                                    <div class="text-secondary mb-3">${center.whatWeOffer}</div>
                                </c:when>
                                <c:otherwise>
                                    <span class="feature-chip"><i class="fas fa-shield-halved"></i> Regular Training Classes</span>
                                    <span class="feature-chip"><i class="fas fa-medal"></i> Official Belt Grading</span>
                                    <span class="feature-chip"><i class="fas fa-person-running"></i> Self-Defense Workshops</span>
                                    <span class="feature-chip"><i class="fas fa-child"></i> Kids &amp; Teen Batches</span>
                                    <span class="feature-chip"><i class="fas fa-heart-pulse"></i> Conditioning &amp; Stamina</span>
                                    <span class="feature-chip"><i class="fas fa-venus"></i> Women's Safety Seminars</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${not empty center.facilities}">
                            <h6 class="fw-bold text-dark mb-2 small text-uppercase" style="letter-spacing: 0.5px;">Centre Amenities</h6>
                            <div>
                                <c:set var="facList" value="${fn:split(center.facilities, ',')}"/>
                                <c:forEach var="fac" items="${facList}">
                                    <span class="feature-chip">
                                        <i class="fas fa-check text-success"></i> ${fn:trim(fac)}
                                    </span>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </section>

                <!-- ============================================== -->
                <!-- 3. TRAINING GALLERY                           -->
                <!-- ============================================== -->
                <section class="mb-5">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-images text-danger"></i> Training at <c:out value="${center.name}"/>
                        </h2>
                        <p class="section-subtitle">Real training environment, sparring equipment, and community moments.</p>
                    </div>

                    <div class="info-card p-4">
                        <c:choose>
                            <c:when test="${not empty center.galleryPhotos}">
                                <div class="gallery-grid">
                                    <c:forEach var="photo" items="${center.galleryPhotos}">
                                        <div class="gallery-img-card">
                                            <img src="${pageContext.request.contextPath}${photo}" alt="Centre Gallery" loading="lazy">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <div class="text-muted mb-2" style="font-size: 2.2rem;">
                                        <i class="bi bi-camera"></i>
                                    </div>
                                    <p class="text-muted small mb-0">No gallery photos uploaded yet for this centre.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- ============================================== -->
                <!-- 4. LOCATION & CONTACT                          -->
                <!-- ============================================== -->
                <section id="contact-section" class="mb-4">
                    <div class="section-header">
                        <h2 class="section-title">
                            <i class="fas fa-location-dot text-danger"></i> Centre Location &amp; Contact
                        </h2>
                        <p class="section-subtitle">Get in touch with the training administrators directly.</p>
                    </div>

                    <div class="info-card">
                        <div class="row g-4">
                            <!-- Location Box -->
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-3">
                                    <div class="batch-meta-icon bg-danger-subtle text-danger" style="width: 42px; height: 42px; font-size: 1.1rem;">
                                        <i class="fas fa-map-location-dot"></i>
                                    </div>
                                    <div>
                                        <h6 class="fw-bold text-dark mb-1">Address &amp; Location</h6>
                                        <p class="text-muted mb-2 small">
                                            <c:out value="${center.location}"/>
                                            <c:if test="${not empty center.area}">, ${center.area}</c:if>
                                            <c:if test="${not empty center.city}">, ${center.city}</c:if>
                                            <c:if test="${not empty center.state}">, ${center.state}</c:if>
                                            <c:if test="${not empty center.pincode}"> - ${center.pincode}</c:if>
                                        </p>
                                        <c:if test="${not empty center.googleMapLocation}">
                                            <a href="${center.googleMapLocation}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                                <i class="bi bi-map me-1"></i> Open Google Maps
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Contact Box -->
                            <div class="col-md-6">
                                <div class="d-flex align-items-start gap-3">
                                    <div class="batch-meta-icon bg-primary-subtle text-primary" style="width: 42px; height: 42px; font-size: 1.1rem;">
                                        <i class="fas fa-headset"></i>
                                    </div>
                                    <div>
                                        <h6 class="fw-bold text-dark mb-1">Direct Contact</h6>
                                        <c:if test="${not empty center.contactPerson}">
                                            <p class="text-dark fw-semibold small mb-1">
                                                <i class="bi bi-person me-1"></i> Contact: <c:out value="${center.contactPerson}"/>
                                            </p>
                                        </c:if>
                                        <c:if test="${not empty center.phoneNumber}">
                                            <p class="text-muted small mb-1">
                                                <i class="bi bi-telephone me-1"></i>
                                                <a href="tel:${center.phoneNumber}" class="text-decoration-none text-dark fw-semibold">
                                                    <c:out value="${center.phoneNumber}"/>
                                                </a>
                                            </p>
                                        </c:if>
                                        <c:if test="${not empty center.whatsappNumber}">
                                            <p class="text-muted small mb-1">
                                                <i class="bi bi-whatsapp text-success me-1"></i>
                                                <a href="https://wa.me/${center.whatsappNumber}" target="_blank" rel="noopener noreferrer" class="text-decoration-none text-success fw-semibold">
                                                    WhatsApp Us
                                                </a>
                                            </p>
                                        </c:if>
                                        <c:if test="${not empty center.email}">
                                            <p class="text-muted small mb-0">
                                                <i class="bi bi-envelope me-1"></i>
                                                <a href="mailto:${center.email}" class="text-decoration-none text-dark">
                                                    <c:out value="${center.email}"/>
                                                </a>
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Operating Days & Hours -->
                            <c:if test="${not empty sortedAvailableDays or not empty center.openTime}">
                                <div class="col-12 border-top pt-3">
                                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                                        <div>
                                            <span class="small text-muted fw-bold text-uppercase me-2" style="font-size: 0.72rem;">Available Days:</span>
                                            <c:forEach var="day" items="${sortedAvailableDays}">
                                                <span class="badge bg-light text-dark border rounded-pill me-1 px-2 py-1 small">${day}</span>
                                            </c:forEach>
                                        </div>
                                        <c:if test="${not empty center.openTime}">
                                            <div class="small text-muted">
                                                <i class="bi bi-clock me-1 text-danger"></i>
                                                <strong>Hours:</strong> ${center.openTime} <c:if test="${not empty center.closeTime}">- ${center.closeTime}</c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </section>

            </div>

            <!-- Right Sidebar Column (Sticky Booking Summary on Desktop) -->
            <div class="col-lg-4">
                <div class="sticky-summary-box">
                    <div class="summary-header">
                        <span class="badge bg-danger-subtle text-danger rounded-pill px-3 py-1 text-uppercase fw-bold mb-2" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                            Training Enrollment
                        </span>
                        <h4 class="fw-bold mb-0">Booking Summary</h4>
                    </div>

                    <!-- Selected Training Details -->
                    <div class="summary-row">
                        <span class="summary-label">Centre</span>
                        <span class="summary-val"><c:out value="${center.name}"/></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Selected Batch</span>
                        <span class="summary-val text-primary" id="summary-batch-name">
                            <c:choose>
                                <c:when test="${not empty batches}">
                                    <c:out value="${batches[0].name}"/>
                                </c:when>
                                <c:otherwise>No batch selected</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Style &amp; Mode</span>
                        <span class="summary-val" id="summary-batch-style">
                            <c:choose>
                                <c:when test="${not empty batches}">
                                    <c:out value="${batches[0].style != null ? batches[0].style : 'Martial Arts'}"/> (<c:out value="${batches[0].batchType != null ? batches[0].batchType : 'Offline'}"/>)
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Instructor</span>
                        <span class="summary-val" id="summary-batch-instructor">
                            <c:choose>
                                <c:when test="${not empty batches}">
                                    <c:out value="${batches[0].instructor != null ? batches[0].instructor : 'Master Instructor'}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Schedule &amp; Time</span>
                        <span class="summary-val" id="summary-batch-timing">
                            <c:choose>
                                <c:when test="${not empty batches}">
                                    <c:out value="${batches[0].timeSlot != null ? batches[0].timeSlot : 'Flexible'}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- Price Total Breakdown -->
                    <div class="summary-total-box">
                        <div class="d-flex justify-content-between align-items-baseline mb-1">
                            <span class="fw-bold text-dark">Monthly Fee</span>
                            <span class="fw-bold text-danger fs-5" id="summary-batch-fee">
                                <c:choose>
                                    <c:when test="${not empty batches && (batches[0].fee == null || batches[0].fee == 0)}">
                                        FREE
                                    </c:when>
                                    <c:when test="${not empty batches}">
                                        &#8377;<fmt:formatNumber value="${batches[0].fee}" maxFractionDigits="0"/>
                                    </c:when>
                                    <c:otherwise>&#8377;0</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center small text-muted" id="summary-admission-row">
                            <span>One-time Admission</span>
                            <span id="summary-batch-admission">
                                <c:choose>
                                    <c:when test="${not empty batches && batches[0].admissionFee != null && batches[0].admissionFee > 0}">
                                        &#8377;<fmt:formatNumber value="${batches[0].admissionFee}" maxFractionDigits="0"/>
                                    </c:when>
                                    <c:otherwise>&#8377;0</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <!-- Booking Button in Sticky Bar -->
                    <c:choose>
                        <c:when test="${not empty batches}">
                            <c:choose>
                                <c:when test="${not empty user}">
                                    <a id="summary-book-btn" href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batches[0].id}" class="btn-book-batch py-3 fs-6">
                                        <i class="fas fa-lock me-1"></i> PROCEED TO ENROLL
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a id="summary-book-btn" href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}%3FbatchId%3D${batches[0].id}" class="btn-book-batch py-3 fs-6">
                                        <i class="fas fa-sign-in-alt me-1"></i> LOGIN TO ENROLL
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-batch-disabled py-3" disabled>No Batches Available</button>
                        </c:otherwise>
                    </c:choose>

                    <div class="text-center mt-3">
                        <small class="text-muted" style="font-size: 0.76rem;">
                            <i class="fas fa-shield-halved text-success me-1"></i> 100% Safe &amp; Verified Booking Platform
                        </small>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- ======= Mobile Sticky Bottom Bar ======= -->
    <div class="mobile-bottom-bar" id="mobile-bottom-bar">
        <div>
            <div class="fw-bold text-dark small" id="mobile-batch-name" style="line-height: 1.2;">
                <c:choose>
                    <c:when test="${not empty batches}"><c:out value="${batches[0].name}"/></c:when>
                    <c:otherwise><c:out value="${center.name}"/></c:otherwise>
                </c:choose>
            </div>
            <div class="fw-bold text-danger" id="mobile-batch-fee">
                <c:choose>
                    <c:when test="${not empty batches && (batches[0].fee == null || batches[0].fee == 0)}">FREE</c:when>
                    <c:when test="${not empty batches}">&#8377;<fmt:formatNumber value="${batches[0].fee}" maxFractionDigits="0"/>/mo</c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </div>
        </div>
        <c:choose>
            <c:when test="${not empty batches}">
                <c:choose>
                    <c:when test="${not empty user}">
                        <a id="mobile-book-btn" href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batches[0].id}" class="btn btn-danger rounded-pill px-4 fw-bold">
                            Book Batch
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a id="mobile-book-btn" href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}%3FbatchId%3D${batches[0].id}" class="btn btn-danger rounded-pill px-4 fw-bold">
                            Login &amp; Book
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <button class="btn btn-secondary rounded-pill px-4" disabled>No Batches</button>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ======= Footer ======= -->
    <footer class="site-footer">
        <div class="container-xl">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px;">
                        <span class="text-white fw-bold fs-5">Fight D Fear</span>
                    </div>
                    <p class="small text-white-50 mb-2">
                        Empowering individuals and women across India through discipline, martial arts mastery, and proactive safety awareness.
                    </p>
                    <p class="small text-white-50">Awareness • Safety • Equality • Empowerment</p>
                </div>
                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="text-white fw-bold mb-3 small text-uppercase">Navigation</h6>
                    <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                        <li><a href="${pageContext.request.contextPath}/users/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Martial Arts Centres</a></li>
                        <li><a href="${pageContext.request.contextPath}/video/reels">Reels</a></li>
                        <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-3 col-6">
                    <h6 class="text-white fw-bold mb-3 small text-uppercase">Support</h6>
                    <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
                        <li><a href="${pageContext.request.contextPath}/qna">Safety Q&amp;A</a></li>
                        <li><a href="${pageContext.request.contextPath}/terms">Terms &amp; Conditions</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-12">
                    <h6 class="text-white fw-bold mb-3 small text-uppercase">Platform Support</h6>
                    <p class="small text-white-50 mb-3">
                        Have questions about enrolling in training batches or verifying your centre? Reach out to our community support desk.
                    </p>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/qna" class="btn btn-sm btn-outline-light rounded-pill px-3">
                            <i class="bi bi-chat-dots me-1"></i> Ask in Q&amp;A
                        </a>
                        <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                            <i class="bi bi-search me-1"></i> Browse Centres
                        </a>
                    </div>
                </div>
            </div>
            <div class="border-top border-secondary border-opacity-25 mt-4 pt-3 text-center small text-white-50">
                &copy; <strong>Fight D Fear</strong>. All Rights Reserved. Verified Martial Arts Network.
            </div>
        </div>
    </footer>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-Side Batch Selection & Filtering Scripts -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const isLoggedIn = ${not empty user ? 'true' : 'false'};

        // Active filters state
        let currentFilters = {
            style: 'all',
            level: 'all',
            mode: 'all'
        };

        // Select Batch and update sticky sidebar + mobile bar
        function selectBatch(batchId, centreId, name, style, instructor, days, timeSlot, fee, admissionFee, isUnavailable) {
            // Update selected class on batch cards
            document.querySelectorAll('.batch-card').forEach(card => card.classList.remove('selected'));
            const selectedCard = document.getElementById('batch-card-' + batchId);
            if (selectedCard) {
                selectedCard.classList.add('selected');
            }

            // Update desktop summary
            const summaryName = document.getElementById('summary-batch-name');
            const summaryStyle = document.getElementById('summary-batch-style');
            const summaryInstructor = document.getElementById('summary-batch-instructor');
            const summaryTiming = document.getElementById('summary-batch-timing');
            const summaryFee = document.getElementById('summary-batch-fee');
            const summaryAdmission = document.getElementById('summary-batch-admission');
            const summaryBtn = document.getElementById('summary-book-btn');

            if (summaryName) summaryName.textContent = name || 'Martial Arts Batch';
            if (summaryStyle) summaryStyle.textContent = (style || 'Martial Arts');
            if (summaryInstructor) summaryInstructor.textContent = instructor || 'Master Instructor';
            if (summaryTiming) summaryTiming.textContent = timeSlot || 'Flexible';
            
            const numFee = parseFloat(fee);
            if (summaryFee) {
                summaryFee.textContent = (!numFee || numFee === 0) ? 'FREE' : '₹' + Math.round(numFee);
            }

            const numAdm = parseFloat(admissionFee);
            if (summaryAdmission) {
                summaryAdmission.textContent = (!numAdm || numAdm === 0) ? '₹0' : '₹' + Math.round(numAdm);
            }

            const targetUrl = isLoggedIn 
                ? contextPath + '/enrollment/enrollForm/' + centreId + '?batchId=' + batchId
                : contextPath + '/login?redirect=' + encodeURIComponent('/enrollment/enrollForm/' + centreId + '?batchId=' + batchId);

            if (summaryBtn) {
                if (isUnavailable) {
                    summaryBtn.removeAttribute('href');
                    summaryBtn.classList.add('btn-batch-disabled');
                    summaryBtn.classList.remove('btn-book-batch');
                    summaryBtn.textContent = 'Batch Unavailable';
                } else {
                    summaryBtn.setAttribute('href', targetUrl);
                    summaryBtn.classList.remove('btn-batch-disabled');
                    summaryBtn.classList.add('btn-book-batch');
                    summaryBtn.innerHTML = isLoggedIn 
                        ? '<i class="fas fa-lock me-1"></i> PROCEED TO ENROLL' 
                        : '<i class="fas fa-sign-in-alt me-1"></i> LOGIN TO ENROLL';
                }
            }

            // Update mobile bar
            const mobName = document.getElementById('mobile-batch-name');
            const mobFee = document.getElementById('mobile-batch-fee');
            const mobBtn = document.getElementById('mobile-book-btn');

            if (mobName) mobName.textContent = name || 'Martial Arts Batch';
            if (mobFee) mobFee.textContent = (!numFee || numFee === 0) ? 'FREE' : '₹' + Math.round(numFee) + '/mo';
            if (mobBtn) {
                if (isUnavailable) {
                    mobBtn.removeAttribute('href');
                    mobBtn.classList.add('disabled');
                    mobBtn.textContent = 'Unavailable';
                } else {
                    mobBtn.setAttribute('href', targetUrl);
                    mobBtn.classList.remove('disabled');
                    mobBtn.textContent = isLoggedIn ? 'Book Batch' : 'Login & Book';
                }
            }
        }

        // Setup filter click handlers
        document.addEventListener('DOMContentLoaded', function() {
            const filterChips = document.querySelectorAll('.filter-chip');
            filterChips.forEach(chip => {
                chip.addEventListener('click', function() {
                    const type = this.getAttribute('data-filter-type');
                    const val = this.getAttribute('data-filter-val');
                    
                    // Toggle active inside parent group
                    this.parentElement.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
                    this.classList.add('active');

                    currentFilters[type] = val;
                    applyFilters();
                });
            });
        });

        // Apply client-side batch filtering
        function applyFilters() {
            const items = document.querySelectorAll('.batch-card-item');
            let visibleCount = 0;

            items.forEach(item => {
                const itemStyle = (item.getAttribute('data-style') || '').toLowerCase();
                const itemLevel = (item.getAttribute('data-level') || '').toLowerCase();
                const itemMode = (item.getAttribute('data-mode') || '').toLowerCase();

                const matchStyle = currentFilters.style === 'all' || itemStyle.includes(currentFilters.style.toLowerCase());
                const matchLevel = currentFilters.level === 'all' || itemLevel.includes(currentFilters.level.toLowerCase());
                const matchMode = currentFilters.mode === 'all' || itemMode.includes(currentFilters.mode.toLowerCase());

                if (matchStyle && matchLevel && matchMode) {
                    item.style.display = '';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            const emptyState = document.getElementById('filter-empty-state');
            if (emptyState) {
                if (visibleCount === 0 && items.length > 0) {
                    emptyState.classList.remove('d-none');
                } else {
                    emptyState.classList.add('d-none');
                }
            }
        }

        // Reset all filters
        function resetAllFilters() {
            currentFilters = { style: 'all', level: 'all', mode: 'all' };
            document.querySelectorAll('.filter-chip').forEach(chip => {
                if (chip.getAttribute('data-filter-val') === 'all') {
                    chip.classList.add('active');
                } else {
                    chip.classList.remove('active');
                }
            });
            applyFilters();
        }
    </script>
</body>
</html>
