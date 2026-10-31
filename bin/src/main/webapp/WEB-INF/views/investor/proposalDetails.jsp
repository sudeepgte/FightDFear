<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${proposal.title} — Investor Portal | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #0f172a;
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --primary-plum: #4c0519;
            --bg-light: #f8fafc;
            --rose-bg-light: #fff1f2;
            --rose-border: #fecdd3;
            --card-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
            --card-border: 1px solid #e2e8f0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #1e293b;
            min-height: 100vh;
        }

        h1, h2, h3, h4, h5, h6, .font-heading {
            font-family: 'Outfit', sans-serif;
        }

        #wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
        }

        /* Fixed Sidebar */
        #sidebar-wrapper {
            width: 240px;
            min-width: 240px;
            max-width: 240px;
            background: #ffffff;
            color: #0f172a;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding: 24px 0;
            z-index: 1040;
            box-shadow: 2px 0 16px rgba(244,63,94,0.06);
            border-right: 1px solid #ffe4e6;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .sidebar-brand {
            padding: 0 24px 20px;
            font-size: 1.15rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid #ffe4e6;
            color: #4c0519;
            letter-spacing: -0.5px;
        }

        .sidebar-nav {
            padding: 16px 12px;
            flex: 1;
            overflow-y: auto;
        }

        .sidebar-link {
            color: #64748b;
            padding: 11px 16px;
            margin-bottom: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            transition: all 0.2s ease;
            border-radius: 10px;
        }

        .sidebar-link i {
            font-size: 1.15rem;
            transition: transform 0.2s ease;
        }

        .sidebar-link:hover {
            color: #f43f5e;
            background: #fff1f2;
        }

        .sidebar-link:hover i {
            transform: translateX(2px);
        }

        .sidebar-link.active {
            color: #ffffff;
            background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
            font-weight: 600;
        }

        .sidebar-footer {
            padding: 16px 20px 0;
            border-top: 1px solid #ffe4e6;
        }

        /* Content Area */
        #page-content-wrapper {
            flex: 1;
            margin-left: 240px;
            padding: 24px 32px 48px;
            min-height: 100vh;
            background: #f8fafc;
        }

        /* Premium Cards */
        .glass-card {
            background: #ffffff;
            border-radius: 18px;
            border: var(--card-border);
            box-shadow: var(--card-shadow);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .hero-banner-card {
            background: linear-gradient(135deg, #ffffff 0%, #fff7f8 100%);
            border: 1px solid #ffe4e6;
            border-radius: 20px;
            padding: 28px 32px;
            box-shadow: 0 6px 24px rgba(244, 63, 94, 0.06);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }

        .hero-banner-card::after {
            content: '';
            position: absolute;
            top: -60px;
            right: -60px;
            width: 220px;
            height: 220px;
            background: radial-gradient(circle, rgba(244,63,94,0.08) 0%, rgba(244,63,94,0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }

        /* Stats Pill Grid */
        .metric-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 16px 20px;
            border: 1px solid #f1f5f9;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.03);
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .metric-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
        }

        /* Buttons & Badges */
        .btn-rose {
            background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
            color: #ffffff;
            border: none;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.28);
            transition: all 0.2s ease;
        }

        .btn-rose:hover {
            background: linear-gradient(135deg, #e11d48 0%, #be123c 100%);
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(244, 63, 94, 0.35);
        }

        .btn-outline-rose {
            color: #f43f5e;
            border: 1.5px solid #f43f5e;
            background: transparent;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-outline-rose:hover {
            background: #f43f5e;
            color: #ffffff;
        }

        .badge-rose {
            background-color: #fff1f2;
            color: #f43f5e;
            border: 1px solid #fecdd3;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 30px;
        }

        .badge-verified {
            background-color: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 30px;
            font-size: 0.75rem;
        }

        /* Progress Bar */
        .progress-bar-custom {
            height: 12px;
            border-radius: 10px;
            background-color: #f1f5f9;
            overflow: hidden;
        }

        .progress-bar-fill {
            background: linear-gradient(90deg, #f43f5e 0%, #fb7185 100%);
            height: 100%;
            border-radius: 10px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Image Gallery */
        .gallery-card {
            border-radius: 14px;
            overflow: hidden;
            position: relative;
            cursor: pointer;
            border: 1px solid #f1f5f9;
            aspect-ratio: 4 / 3;
            background: #f8fafc;
        }

        .gallery-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .gallery-card:hover img {
            transform: scale(1.05);
        }

        .gallery-overlay {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.2s ease;
            color: white;
            font-size: 1.5rem;
        }

        .gallery-card:hover .gallery-overlay {
            opacity: 1;
        }

        /* Sticky Action Rail */
        .sticky-rail {
            position: sticky;
            top: 24px;
            z-index: 10;
        }

        /* Preset Chips */
        .preset-chip {
            border: 1px solid #e2e8f0;
            background: #ffffff;
            color: #475569;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .preset-chip:hover {
            border-color: #f43f5e;
            color: #f43f5e;
            background: #fff1f2;
        }

        /* Discussion cards */
        .qa-card {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #f1f5f9;
            padding: 16px 20px;
            margin-bottom: 12px;
            transition: border-color 0.2s ease;
        }

        .qa-card:hover {
            border-color: #fecdd3;
        }

        /* Mobile View Adjustments */
        @media (max-width: 992px) {
            #sidebar-wrapper {
                position: fixed;
                left: -280px;
                transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            #sidebar-wrapper.show-sidebar {
                left: 0;
            }

            #page-content-wrapper {
                margin-left: 0;
                padding: 16px 16px 40px;
            }

            .hero-banner-card {
                padding: 20px;
            }
        }

        .sidebar-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.4);
            z-index: 1030;
            backdrop-filter: blur(2px);
        }

        .sidebar-backdrop.show {
            display: block;
        }
    </style>
</head>
<body>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<div id="wrapper">
    <!-- Sidebar Navigation -->
    <aside id="sidebar-wrapper">
        <div>
            <div class="sidebar-brand">
                <i class="bi bi-shield-heart-fill text-danger fs-4"></i>
                <div>
                    <div style="line-height:1.1;">Fight D Fear</div>
                    <span style="font-size:0.7rem; font-weight:600; color:#94a3b8; text-transform:uppercase; letter-spacing:1px;">Investor Portal</span>
                </div>
            </div>

            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                    <i class="bi bi-house"></i>
                    <span>Public Home</span>
                </a>
                <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                    <i class="bi bi-grid-1x2-fill"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link active">
                    <i class="bi bi-shop-window"></i>
                    <span>Marketplace</span>
                </a>
                <a href="${pageContext.request.contextPath}/investor/dashboard#bookings-section" class="sidebar-link">
                    <i class="bi bi-calendar-check-fill"></i>
                    <span>My Bookings</span>
                </a>
                <a href="${pageContext.request.contextPath}/investor/dashboard#portfolio-section" class="sidebar-link">
                    <i class="bi bi-wallet2"></i>
                    <span>Wallet & Capital</span>
                </a>
                <a href="${pageContext.request.contextPath}/investor/complete-profile" class="sidebar-link">
                    <i class="bi bi-person-badge-fill"></i>
                    <span>My Profile</span>
                </a>
            </nav>
        </div>

        <div class="sidebar-footer pb-4">
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mb-0">
                <i class="bi bi-box-arrow-right"></i>
                <span>Sign Out</span>
            </a>
        </div>
    </aside>

    <!-- Page Content Wrapper -->
    <main id="page-content-wrapper">
        <div class="container-fluid px-0">

            <!-- Mobile Top Bar Header -->
            <div class="d-flex d-lg-none justify-content-between align-items-center mb-3 p-3 bg-white rounded-3 shadow-sm border">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-heart-fill text-danger fs-5"></i>
                    <span class="fw-bold" style="color: var(--primary-plum);">Fight D Fear</span>
                </div>
                <button class="btn btn-outline-rose btn-sm" id="mobileSidebarToggle" type="button" aria-label="Toggle Navigation">
                    <i class="bi bi-list fs-5"></i>
                </button>
            </div>

            <!-- Top Header & Breadcrumbs Bar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 gap-2">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0 small">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/investor/dashboard" class="text-secondary text-decoration-none">
                                <i class="bi bi-speedometer2"></i> Dashboard
                            </a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/investor/marketplace" class="text-secondary text-decoration-none">Marketplace</a>
                        </li>
                        <li class="breadcrumb-item active text-rose fw-semibold" aria-current="page">Proposal #${proposal.id}</li>
                    </ol>
                </nav>

                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/investor/marketplace" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                        <i class="bi bi-arrow-left me-1"></i> Back to Marketplace
                    </a>
                    <div class="d-none d-sm-flex align-items-center gap-2 bg-white px-3 py-1 rounded-pill border shadow-sm">
                        <div class="rounded-circle bg-rose text-white d-flex align-items-center justify-content-center" style="width:26px; height:26px; font-size:0.75rem;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <span class="small fw-semibold text-dark">${investor.fullName}</span>
                    </div>
                </div>
            </div>

            <!-- Flash Alert Banners -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center" role="alert">
                    <i class="bi bi-check-circle-fill fs-4 text-success me-3"></i>
                    <div>
                        <strong>Success!</strong> ${success}
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4 d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-4 text-danger me-3"></i>
                    <div>
                        <strong>Attention:</strong> ${error}
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Hero Proposal Banner Card -->
            <div class="hero-banner-card">
                <div class="row align-items-center g-3">
                    <div class="col-lg-8">
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                            <span class="badge-rose"><i class="bi bi-tag-fill me-1"></i>${proposal.category}</span>
                            <span class="badge bg-white text-secondary border px-3 py-2 rounded-pill small">
                                <i class="bi bi-geo-alt-fill text-danger me-1"></i>${proposal.location}
                            </span>
                            <c:if test="${proposal.featured}">
                                <span class="badge bg-warning text-dark border px-3 py-2 rounded-pill small fw-bold">
                                    <i class="bi bi-star-fill text-dark me-1"></i>Featured Opportunity
                                </span>
                            </c:if>
                            <span class="badge-verified">
                                <i class="bi bi-patch-check-fill me-1"></i>Verified Business
                            </span>
                        </div>
                        <h2 class="fw-bold mb-2 text-dark" style="font-size: 1.85rem; letter-spacing: -0.5px;">${proposal.title}</h2>
                        <p class="text-secondary mb-0 small" style="max-width: 650px; line-height: 1.6;">
                            Founded by <strong>${proposal.entrepreneur.fullName}</strong> • Seeking growth capital with projected monthly returns.
                        </p>
                    </div>
                    <div class="col-lg-4 text-lg-end">
                        <div class="d-flex flex-wrap gap-2 justify-content-lg-end">
                            <a href="#investment-terminal" class="btn btn-rose rounded-pill px-4 py-2 small">
                                <i class="bi bi-shield-lock-fill me-1"></i> Invest via Admin Escrow
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Financial Progress Highlights inside Hero -->
                <div class="mt-4 pt-3 border-top">
                    <div class="row g-3 mb-3">
                        <div class="col-6 col-md-3">
                            <div class="metric-card">
                                <div class="metric-icon-wrap bg-light text-primary">
                                    <i class="bi bi-bullseye"></i>
                                </div>
                                <div>
                                    <span class="text-muted small d-block">Target Goal</span>
                                    <h5 class="fw-bold mb-0 text-dark">₹<fmt:formatNumber value="${proposal.fundingNeeded}" pattern="#,##,###" /></h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="metric-card">
                                <div class="metric-icon-wrap" style="background:#ecfdf5; color:#059669;">
                                    <i class="bi bi-graph-up-arrow"></i>
                                </div>
                                <div>
                                    <span class="text-muted small d-block">Capital Raised</span>
                                    <h5 class="fw-bold mb-0 text-success">₹<fmt:formatNumber value="${proposal.amountRaised}" pattern="#,##,###" /></h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="metric-card">
                                <div class="metric-icon-wrap" style="background:#fff1f2; color:#f43f5e;">
                                    <i class="bi bi-hourglass-split"></i>
                                </div>
                                <div>
                                    <span class="text-muted small d-block">Open Remaining</span>
                                    <h5 class="fw-bold mb-0 text-rose">₹<fmt:formatNumber value="${openRemaining}" pattern="#,##,###" /></h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="metric-card">
                                <div class="metric-icon-wrap" style="background:#f0f9ff; color:#0284c7;">
                                    <i class="bi bi-cash-coin"></i>
                                </div>
                                <div>
                                    <span class="text-muted small d-block">Est. Monthly Profit</span>
                                    <h5 class="fw-bold mb-0 text-info" style="color:#0284c7 !important;">₹<fmt:formatNumber value="${proposal.expectedMonthlyIncome}" pattern="#,##,###" /></h5>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Visual Progress Bar -->
                    <c:set var="pctRaised" value="${(proposal.amountRaised / proposal.fundingNeeded) * 100}" />
                    <div class="d-flex justify-content-between align-items-center mb-2 small fw-semibold">
                        <span class="text-dark">
                            Funding Progress: <strong class="text-rose"><fmt:formatNumber value="${pctRaised}" maxFractionDigits="1" />%</strong> Complete
                        </span>
                        <c:if test="${pendingAmount > 0}">
                            <span class="text-warning small">
                                <i class="bi bi-clock-history me-1"></i>₹<fmt:formatNumber value="${pendingAmount}" pattern="#,##,###" /> pending admin release
                            </span>
                        </c:if>
                    </div>
                    <div class="progress-bar-custom">
                        <div class="progress-bar-fill" style="width: ${pctRaised > 100 ? 100 : pctRaised}%;"></div>
                    </div>
                </div>
            </div>

            <!-- Balanced 2-Column Grid -->
            <div class="row g-4">
                
                <!-- LEFT COLUMN (col-lg-8): Pitch Details, Media, Q&A, and Meetings -->
                <div class="col-lg-8">
                    
                    <!-- Business Overview Card -->
                    <div class="glass-card p-4 mb-4">
                        <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                            <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                <i class="bi bi-file-earmark-text text-rose"></i> Business Overview & Vision
                            </h5>
                            <span class="badge bg-light text-secondary border small">Verified Details</span>
                        </div>
                        <div class="text-secondary mb-4" style="line-height: 1.8; font-size: 0.95rem; white-space: pre-line;">${proposal.description}</div>

                        <!-- Highlights Quick Badges -->
                        <div class="p-3 bg-light rounded-3 border">
                            <div class="row g-2 text-center text-sm-start">
                                <div class="col-sm-4">
                                    <span class="text-muted small d-block">Industry Sector</span>
                                    <span class="fw-bold text-dark">${proposal.category}</span>
                                </div>
                                <div class="col-sm-4">
                                    <span class="text-muted small d-block">Operational Base</span>
                                    <span class="fw-bold text-dark">${proposal.location}</span>
                                </div>
                                <div class="col-sm-4">
                                    <span class="text-muted small d-block">Revenue Model</span>
                                    <span class="fw-bold text-dark">Direct Profit Share</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Photo Gallery Card -->
                    <c:if test="${not empty proposal.photos}">
                        <div class="glass-card p-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-images text-rose"></i> Business & Operations Gallery
                                </h5>
                                <span class="text-muted small">Click any photo to inspect</span>
                            </div>
                            <div class="row g-3">
                                <c:forEach var="photo" items="${fn:split(proposal.photos, ',')}">
                                    <div class="col-6 col-md-4">
                                        <div class="gallery-card" onclick="openPhotoLightbox('${pageContext.request.contextPath}${photo}')">
                                            <img src="${pageContext.request.contextPath}${photo}" alt="Business Photo" onerror="this.src='https://placehold.co/400x300/f8fafc/f43f5e?text=Photo+Unavailable'">
                                            <div class="gallery-overlay">
                                                <i class="bi bi-zoom-in"></i>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Pitch Video Card -->
                    <c:if test="${not empty proposal.videoPitch}">
                        <div class="glass-card p-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-play-circle-fill text-rose"></i> Founder Video Pitch
                                </h5>
                                <span class="badge bg-danger-subtle text-danger border small">HD Video</span>
                            </div>
                            <div class="ratio ratio-16x9 rounded-4 overflow-hidden border shadow-sm">
                                <video controls preload="metadata" class="w-100 h-100 bg-black">
                                    <source src="${pageContext.request.contextPath}${proposal.videoPitch}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </div>
                        </div>
                    </c:if>

                    <!-- Investor Q&A Discussion Card (Moved out of cramped sidebar) -->
                    <div class="glass-card p-4 mb-4">
                        <div class="d-flex align-items-center justify-content-between mb-3 border-bottom pb-2">
                            <div>
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-chat-square-quote-fill text-rose"></i> Investor Q&A Board
                                </h5>
                                <span class="text-muted small">Ask questions directly to ${proposal.entrepreneur.fullName}</span>
                            </div>
                            <span class="badge bg-light text-dark border">${fn:length(qna)} Questions</span>
                        </div>

                        <!-- Post Question Form -->
                        <form action="${pageContext.request.contextPath}/investor/proposal/${proposal.id}/ask" method="post" class="mb-4">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <div class="input-group">
                                <input type="text" name="question" class="form-control py-2 px-3 rounded-start-pill border-end-0" placeholder="Ask about revenue projections, inventory, or margins..." required>
                                <button class="btn btn-rose rounded-end-pill px-4" type="submit">
                                    <i class="bi bi-send-fill me-1"></i> Submit Question
                                </button>
                            </div>
                        </form>

                        <!-- Questions & Answers List -->
                        <c:choose>
                            <c:when test="${not empty qna}">
                                <div class="d-flex flex-column gap-2">
                                    <c:forEach var="q" items="${qna}">
                                        <div class="qa-card">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <div class="d-flex align-items-center gap-2">
                                                    <div class="rounded-circle bg-light border d-flex align-items-center justify-content-center text-secondary" style="width:28px; height:28px; font-size:0.75rem;">
                                                        <i class="bi bi-person"></i>
                                                    </div>
                                                    <span class="fw-bold text-dark small">${q.investor.fullName}</span>
                                                </div>
                                                <span class="badge bg-light text-muted border small">Investor Inquiry</span>
                                            </div>
                                            <p class="text-dark small mb-2 ps-4 fw-medium">"${q.question}"</p>
                                            
                                            <!-- Answer Area -->
                                            <div class="ps-4">
                                                <div class="p-3 bg-light rounded-3 border-start border-4 border-rose">
                                                    <div class="d-flex align-items-center gap-2 mb-1">
                                                        <span class="fw-bold text-rose small"><i class="bi bi-reply-fill"></i> ${proposal.entrepreneur.fullName} (Founder):</span>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${not empty q.answer}">
                                                            <p class="text-secondary small mb-0">"${q.answer}"</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small fst-italic">Awaiting response from founder...</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 bg-light rounded-4 border">
                                    <i class="bi bi-chat-dots text-muted fs-2 d-block mb-2"></i>
                                    <h6 class="fw-bold text-dark mb-1">No Questions Posted Yet</h6>
                                    <p class="text-muted small mb-0">Be the first investor to ask a question regarding this proposal.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>



                </div><!-- END col-lg-8 -->

                <!-- RIGHT COLUMN (col-lg-4): Action Rail (Investment Calculator, Founder Profile, Schedule Meeting) -->
                <div class="col-lg-4">
                    <div class="sticky-rail">
                        
                        <!-- 1. Investment Terminal Card -->
                        <div class="glass-card p-4 mb-4 border-rose" id="investment-terminal" style="border: 1.5px solid #fecdd3; background: linear-gradient(180deg, #ffffff 0%, #fffbfb 100%);">
                            <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-wallet2 text-rose"></i> Investment Terminal
                                </h5>
                                <span class="badge bg-light text-rose border small">Direct Allocation</span>
                            </div>

                            <c:choose>
                                <c:when test="${proposal.amountRaised >= proposal.fundingNeeded}">
                                    <div class="alert alert-success text-center py-3 mb-0 rounded-4" style="background:#ecfdf5; border: 1px solid #a7f3d0;">
                                        <i class="bi bi-patch-check-fill fs-3 text-success d-block mb-2"></i>
                                        <h6 class="fw-bold text-success mb-1">100% Fully Funded!</h6>
                                        <p class="small text-muted mb-0">This proposal has reached its target capital goal.</p>
                                    </div>
                                </c:when>
                                <c:when test="${openRemaining <= 0}">
                                    <div class="alert alert-warning text-center py-3 mb-0 rounded-4" style="background:#fffbeb; border: 1px solid #fde68a;">
                                        <i class="bi bi-hourglass-split fs-3 text-warning-emphasis d-block mb-2"></i>
                                        <h6 class="fw-bold text-dark mb-1">Fully Committed</h6>
                                        <p class="small text-muted mb-0">Pending admin gateway confirmation for outstanding shares.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Investment Form -->
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <label class="form-label fw-bold small text-dark mb-0">Investment Amount (₹)</label>
                                            <span class="text-muted small">Max: ₹<fmt:formatNumber value="${openRemaining}" pattern="#,##,###" /></span>
                                        </div>

                                        <div class="input-group mb-2">
                                            <span class="input-group-text bg-light fw-bold text-rose">₹</span>
                                            <input type="number" class="form-control form-control-lg fw-bold text-dark" id="fundingAmountInput" min="100" max="${openRemaining}" step="100" value="1000" oninput="handleAmountInputChange(this.value)">
                                        </div>

                                        <!-- Sync Slider -->
                                        <input type="range" class="form-range" id="fundingSlider" min="100" max="${openRemaining}" step="100" value="1000" oninput="handleSliderChange(this.value)">
                                        
                                        <!-- Quick Presets -->
                                        <div class="d-flex flex-wrap gap-1 mt-2">
                                            <button type="button" class="preset-chip" onclick="setPresetAmount(1000)">+₹1,000</button>
                                            <button type="button" class="preset-chip" onclick="setPresetAmount(5000)">+₹5,000</button>
                                            <button type="button" class="preset-chip" onclick="setPresetAmount(10000)">+₹10,000</button>
                                            <button type="button" class="preset-chip" onclick="setPresetAmount(${openRemaining})">Max (₹<fmt:formatNumber value="${openRemaining}" pattern="#,##,###" />)</button>
                                        </div>
                                    </div>

                                    <!-- Projected Returns Calculator Box -->
                                    <div class="p-3 bg-light rounded-3 border mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="small text-muted">Est. Monthly Profit Share:</span>
                                            <span class="fw-bold text-success" id="estMonthlyShareDisplay">₹0 / month</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center small text-muted">
                                            <span>Ownership Share:</span>
                                            <span class="fw-semibold text-dark" id="ownershipShareDisplay">0%</span>
                                        </div>
                                    </div>

                                    <button class="btn btn-rose w-100 py-3 rounded-pill fw-bold fs-6" onclick="triggerInvestmentCheckout()">
                                        <i class="bi bi-shield-lock-fill me-1"></i> Pay &amp; Invest via Razorpay Escrow
                                    </button>

                                    <div class="text-center mt-2">
                                        <span class="text-muted" style="font-size:0.75rem;">
                                            <i class="bi bi-shield-check text-success me-1"></i> 100% Escrow Protected • Funds Released by Admin Only
                                        </span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 2. Founder Profile Card -->
                        <div class="glass-card p-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-person-badge-fill text-rose"></i> Founder Profile
                                </h5>
                                <span class="badge-verified"><i class="bi bi-patch-check-fill me-1"></i>Verified</span>
                            </div>

                            <div class="text-center mb-3">
                                <div class="position-relative d-inline-block">
                                    <img src="${pageContext.request.contextPath}${proposal.entrepreneur.profilePhoto}" alt="Founder Profile" class="rounded-circle border shadow-sm" style="width:84px; height:84px; object-fit:cover;" onerror="this.src='https://placehold.co/100x100/f8fafc/f43f5e?text=Founder'">
                                    <span class="position-absolute bottom-0 end-0 bg-success border border-white rounded-circle p-1" title="Active"></span>
                                </div>
                                <h6 class="fw-bold mt-2 mb-0 text-dark">${proposal.entrepreneur.fullName}</h6>
                                <span class="badge bg-light text-secondary border small mt-1">
                                    ${proposal.entrepreneur.businessExperience} Years Experience
                                </span>
                            </div>

                            <div class="small bg-light p-3 rounded-3 border mb-3">
                                <div class="d-flex justify-content-between py-1 border-bottom">
                                    <span class="text-muted">Email:</span>
                                    <span class="fw-semibold text-dark text-truncate" style="max-width:170px;">${proposal.entrepreneur.email}</span>
                                </div>
                                <div class="d-flex justify-content-between py-1 border-bottom">
                                    <span class="text-muted">Phone:</span>
                                    <span class="fw-semibold text-dark">${proposal.entrepreneur.phone}</span>
                                </div>
                                <div class="d-flex justify-content-between py-1 border-bottom">
                                    <span class="text-muted">Aadhaar:</span>
                                    <span class="fw-semibold text-success"><i class="bi bi-check-circle-fill me-1"></i>Verified</span>
                                </div>
                                <div class="d-flex justify-content-between py-1">
                                    <span class="text-muted">Bank:</span>
                                    <span class="fw-semibold text-dark">${proposal.entrepreneur.bankName}</span>
                                </div>
                            </div>

                        </div>

                        <!-- 3. Admin Escrow Guarantee Card -->
                        <div class="glass-card p-4">
                            <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                                <h5 class="fw-bold text-dark m-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-shield-lock-fill text-rose"></i> Admin Escrow Guarantee
                                </h5>
                            </div>
                            <div class="p-3 rounded-3 mb-3" style="background:#fff1f2; border:1px solid #fecdd3;">
                                <div class="fw-bold text-danger mb-1" style="font-size:0.85rem;"><i class="bi bi-patch-check-fill me-1"></i>100% Secure Payment</div>
                                <p class="text-secondary small mb-0" style="line-height:1.5;">
                                    Your investment funds are paid directly into Fight D Fear Admin Escrow. They are safely held until the administrator verifies the milestone and releases the capital to the entrepreneur.
                                </p>
                            </div>
                            <div class="small text-muted d-flex flex-column gap-2">
                                <div><i class="bi bi-check2-circle text-success me-1"></i> Razorpay UPI / Card / NetBanking</div>
                                <div><i class="bi bi-check2-circle text-success me-1"></i> Complete Payment Traceability</div>
                                <div><i class="bi bi-check2-circle text-success me-1"></i> Verified Entrepreneur Bank Account</div>
                            </div>
                        </div>

                    </div><!-- END sticky-rail -->
                </div><!-- END col-lg-4 -->

            </div><!-- END row g-4 -->

        </div>
    </main>
</div>

<!-- IMAGE LIGHTBOX PREVIEW MODAL -->
<div class="modal fade" id="photoLightboxModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content bg-transparent border-0 text-center">
            <div class="position-relative d-inline-block mx-auto">
                <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3 z-3 shadow" data-bs-dismiss="modal" aria-label="Close"></button>
                <img id="lightboxTargetImg" src="" alt="Enlarged Photo" class="img-fluid rounded-4 shadow-lg border border-white" style="max-height: 80vh; object-fit: contain;">
            </div>
        </div>
    </div>
</div>

<!-- SIMULATED RAZORPAY CHECKOUT MODAL -->
<div class="modal fade" id="mockCheckoutModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <!-- Header -->
            <div class="modal-header bg-dark text-white border-0 py-3">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-fill-check text-rose fs-3"></i>
                    <div>
                        <h6 class="modal-title fw-bold m-0" style="letter-spacing:1px;">RAZORPAY GATEWAY</h6>
                        <span class="text-white-50 small" style="font-size:11px;">Test Environment Simulation</span>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" id="checkoutCloseBtn"></button>
            </div>
            <!-- Body -->
            <div class="modal-body p-4 text-center">
                <div class="mb-4">
                    <p class="text-muted mb-1 text-uppercase fw-semibold" style="font-size: 11px;">Simulated Capital Contribution</p>
                    <h2 class="fw-bold text-dark" id="checkoutAmountLabel">₹0.00</h2>
                </div>

                <!-- Simulation Confirmation Info -->
                <div id="checkoutFormContent">
                    <div class="p-3 border rounded-3 text-start bg-light mb-4 small">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Target Venture:</span>
                            <span class="fw-bold text-dark">${proposal.title}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Beneficiary Founder:</span>
                            <span class="fw-bold text-dark">${proposal.entrepreneur.fullName}</span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">Investor Account:</span>
                            <span class="fw-bold text-dark">${investor.fullName}</span>
                        </div>
                    </div>
                    
                    <button class="btn btn-rose w-100 rounded-pill py-3 fw-bold" onclick="completeMockPayment()">
                        Confirm Investment in Escrow
                    </button>
                    <div class="text-muted small mt-2">No actual money will be charged.</div>
                </div>

                <!-- Loading Screen -->
                <div id="checkoutLoadingContent" style="display:none;" class="py-4">
                    <div class="spinner-border text-danger" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <h5 class="fw-bold text-dark mt-4">Processing Escrow Allocation...</h5>
                    <p class="text-muted small">Please do not refresh or close this modal.</p>
                </div>

                <!-- Success Screen -->
                <div id="checkoutSuccessContent" style="display:none;" class="py-4">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-success mt-4">Investment Committed!</h5>
                    <p class="text-muted small">Recording transaction and notifying administrator...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    // Global Constants
    const TOTAL_FUNDING_NEEDED = ${proposal.fundingNeeded > 0 ? proposal.fundingNeeded : 1};
    const EXPECTED_MONTHLY_INCOME = ${proposal.expectedMonthlyIncome > 0 ? proposal.expectedMonthlyIncome : 0};
    const MAX_OPEN_REMAINING = ${openRemaining > 0 ? openRemaining : 0};

    let activeCheckoutForm = null;

    // Mobile Sidebar Toggle
    const mobileToggle = document.getElementById('mobileSidebarToggle');
    const sidebar = document.getElementById('sidebar-wrapper');
    const backdrop = document.getElementById('sidebarBackdrop');

    if (mobileToggle) {
        mobileToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show-sidebar');
            backdrop.classList.toggle('show');
        });
    }

    if (backdrop) {
        backdrop.addEventListener('click', function() {
            sidebar.classList.remove('show-sidebar');
            backdrop.classList.remove('show');
        });
    }

    // Lightbox Modal
    function openPhotoLightbox(src) {
        document.getElementById('lightboxTargetImg').src = src;
        const modal = new bootstrap.Modal(document.getElementById('photoLightboxModal'));
        modal.show();
    }

    // Slider & Input Synchronizer
    function handleSliderChange(val) {
        val = parseFloat(val);
        document.getElementById('fundingAmountInput').value = val;
        recalculateShares(val);
    }

    function handleAmountInputChange(val) {
        val = parseFloat(val);
        if (isNaN(val)) val = 0;
        if (val > MAX_OPEN_REMAINING) val = MAX_OPEN_REMAINING;
        document.getElementById('fundingSlider').value = val;
        recalculateShares(val);
    }

    function setPresetAmount(amount) {
        let val = parseFloat(amount);
        if (val > MAX_OPEN_REMAINING) val = MAX_OPEN_REMAINING;
        document.getElementById('fundingAmountInput').value = val;
        document.getElementById('fundingSlider').value = val;
        recalculateShares(val);
    }

    function recalculateShares(amount) {
        if (isNaN(amount) || amount <= 0) {
            document.getElementById('estMonthlyShareDisplay').innerText = "₹0 / month";
            document.getElementById('ownershipShareDisplay').innerText = "0%";
            return;
        }

        const sharePct = (amount / TOTAL_FUNDING_NEEDED) * 100;
        const estMonthlyReturn = (sharePct / 100) * EXPECTED_MONTHLY_INCOME;

        document.getElementById('estMonthlyShareDisplay').innerText = "₹" + Math.round(estMonthlyReturn).toLocaleString('en-IN') + " / month";
        document.getElementById('ownershipShareDisplay').innerText = sharePct.toFixed(1) + "%";
    }

    // Initialize display on load
    document.addEventListener('DOMContentLoaded', function() {
        const initialVal = document.getElementById('fundingAmountInput') ? document.getElementById('fundingAmountInput').value : 0;
        if (initialVal) {
            recalculateShares(parseFloat(initialVal));
        }
    });

    // Razorpay Integration
    function triggerInvestmentCheckout() {
        const inputElem = document.getElementById('fundingAmountInput');
        let amount = parseFloat(inputElem.value);

        if (isNaN(amount) || amount <= 0) {
            alert('Please specify a valid investment amount.');
            return;
        }
        if (amount > MAX_OPEN_REMAINING) {
            alert('Maximum available remaining funding is ₹' + MAX_OPEN_REMAINING);
            return;
        }

        const csrfToken = document.querySelector('meta[name="_csrf"]').content;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        // Step 1: Create Order in Backend
        fetch('${pageContext.request.contextPath}/investor/proposal/${proposal.id}/create-order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({ amount: amount })
        })
        .then(response => {
            if (!response.ok) throw new Error('Order creation failed');
            return response.json();
        })
        .then(data => {
            if (data.error) {
                alert('Order error: ' + data.error);
                return;
            }

            // Step 2: Open Razorpay Checkout Modal or Mock Fallback
            if (data.isMock) {
                showMockPaymentDialog(data.orderId, amount);
            } else {
                const options = {
                    key: data.keyId || '${razorpayKeyId}',
                    amount: data.amount,
                    currency: data.currency || 'INR',
                    name: 'Fight D Fear Admin Escrow',
                    description: 'Investment – ${fn:escapeXml(proposal.title)}',
                    order_id: data.orderId,
                    prefill: {
                        name: '${fn:escapeXml(investor.fullName)}',
                        email: '${fn:escapeXml(investor.email)}',
                        contact: '${fn:escapeXml(investor.phone)}'
                    },
                    theme: {
                        color: '#f43f5e'
                    },
                    handler: function(response) {
                        verifyRazorpayPayment(response, amount);
                    }
                };
                const rzp = new Razorpay(options);
                rzp.open();
            }
        })
        .catch(err => {
            console.error('Payment initialization error:', err);
            // Fallback to test simulation
            showMockPaymentDialog('order_mock_' + Date.now(), amount);
        });
    }

    function verifyRazorpayPayment(rzpResponse, amount) {
        const csrfToken = document.querySelector('meta[name="_csrf"]').content;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

        fetch('${pageContext.request.contextPath}/investor/proposal/${proposal.id}/verify-payment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({
                razorpay_payment_id: rzpResponse.razorpay_payment_id,
                razorpay_order_id: rzpResponse.razorpay_order_id,
                razorpay_signature: rzpResponse.razorpay_signature,
                amount: amount
            })
        })
        .then(res => res.json())
        .then(res => {
            if (res.success) {
                alert(res.message);
                window.location.reload();
            } else {
                alert('Payment verification failed: ' + res.error);
            }
        })
        .catch(err => {
            alert('Error recording investment: ' + err.message);
        });
    }

    function showMockPaymentDialog(orderId, amount) {
        document.getElementById('checkoutAmountLabel').innerText = "₹" + amount.toLocaleString('en-IN', {minimumFractionDigits: 2});
        document.getElementById('checkoutFormContent').style.display = 'block';
        document.getElementById('checkoutLoadingContent').style.display = 'none';
        document.getElementById('checkoutSuccessContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'block';

        window._pendingMockOrder = { orderId: orderId, amount: amount };
        const modal = new bootstrap.Modal(document.getElementById('mockCheckoutModal'));
        modal.show();
    }

    function completeMockPayment() {
        if (!window._pendingMockOrder) return;
        const { orderId, amount } = window._pendingMockOrder;
        document.getElementById('checkoutFormContent').style.display = 'none';
        document.getElementById('checkoutCloseBtn').style.display = 'none';
        document.getElementById('checkoutLoadingContent').style.display = 'block';

        setTimeout(() => {
            document.getElementById('checkoutLoadingContent').style.display = 'none';
            document.getElementById('checkoutSuccessContent').style.display = 'block';

            setTimeout(() => {
                verifyRazorpayPayment({
                    razorpay_payment_id: 'pay_mock_' + Date.now(),
                    razorpay_order_id: orderId,
                    razorpay_signature: 'mock_signature'
                }, amount);
            }, 600);
        }, 1000);
    }
</script>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
