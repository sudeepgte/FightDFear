<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Martial Arts Hub | Fight D Fear</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

    <style>
        :root {
            --navy: #0F172A;
            --navy-light: #1E293B;
            --primary-red: #F43F5E;
            --primary-red-hover: #E11D48;
            --text-dark: #0F172A;
            --text-gray: #64748B;
            --light-bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 20px rgba(0,0,0,0.06);
            --shadow-lg: 0 12px 30px rgba(0,0,0,0.08);
            --radius-lg: 18px;
            --radius-md: 12px;
            --radius-pill: 9999px;
            --transition: all 0.25s ease;
        }

        body {
            background: var(--light-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
        }

        /* Clean Top Hero — Phase 1 light surface */
        .hub-hero {
            background: #FFFFFF;
            color: #0F172A;
            padding: 28px 0 20px;
            border-radius: 0;
            margin-bottom: 24px;
            border-bottom: 1px solid #E2E8F0;
            box-shadow: none;
        }

        .hub-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.85rem;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #0F172A;
        }

        .hub-hero p {
            color: #64748B;
            font-size: 0.95rem;
            max-width: 620px;
            line-height: 1.5;
            margin-bottom: 16px;
        }

        .hero-belt-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #FFF1F2;
            border: 1px solid #FECDD3;
            color: #9F1239;
            padding: 6px 16px;
            border-radius: var(--radius-pill);
            font-size: 0.85rem;
            font-weight: 700;
        }

        .status-banner {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-left: 4px solid #F43F5E;
            border-radius: 14px;
            padding: 16px 18px;
            margin-bottom: 16px;
        }
        .status-banner.pending { border-left-color: #F59E0B; background: #FFFBEB; }
        .status-banner.approved { border-left-color: #F43F5E; background: #FFF1F2; }
        .status-banner.rejected { border-left-color: #DC2626; background: #FEF2F2; }

        /* Quick Metric Cards */
        .metric-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 20px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 100%;
        }

        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: #CBD5E1;
        }

        .metric-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }

        /* Category Chips Bar (Cult-Style Discovery) */
        .style-chip-container {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 8px;
            scrollbar-width: thin;
        }

        .style-chip-container::-webkit-scrollbar {
            height: 4px;
        }

        .style-chip-container::-webkit-scrollbar-thumb {
            background: #CBD5E1;
            border-radius: 4px;
        }

        .style-chip {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            color: var(--text-dark);
            padding: 8px 18px;
            border-radius: var(--radius-pill);
            font-size: 0.84rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            user-select: none;
        }

        .style-chip:hover {
            border-color: var(--primary-red);
            color: var(--primary-red);
            transform: translateY(-1px);
        }

        .style-chip.active {
            background: var(--primary-red);
            border-color: var(--primary-red);
            color: #FFFFFF;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.35);
        }

        /* Quick Filters Row */
        .filter-pill {
            background: #F1F5F9;
            border: 1px solid transparent;
            color: var(--text-gray);
            padding: 6px 14px;
            border-radius: var(--radius-pill);
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
        }

        .filter-pill:hover {
            background: #E2E8F0;
            color: var(--navy);
        }

        .filter-pill.active {
            background: var(--navy);
            color: #FFFFFF;
        }

        /* Center / Batch Card */
        .center-card {
            background: #FFFFFF;
            border-radius: var(--radius-lg);
            overflow: hidden;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .center-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: #CBD5E1;
        }

        .center-img {
            height: 180px;
            object-fit: cover;
            width: 100%;
        }

        .center-btn {
            background: var(--primary-red);
            border: none;
            border-radius: var(--radius-pill);
            color: #FFFFFF;
            font-weight: 700;
            font-size: 0.88rem;
            padding: 10px 20px;
            transition: var(--transition);
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .center-btn:hover {
            background: var(--primary-red-hover);
            color: #FFFFFF;
            transform: scale(1.02);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.35);
        }

        /* Active Training Highlight Card */
        .active-training-hero-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }

        .active-training-hero-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: var(--primary-red);
        }

        /* Tabs Custom */
        .hub-tabs .nav-link {
            border: none;
            color: var(--text-gray);
            font-weight: 700;
            font-size: 0.95rem;
            padding: 10px 24px;
            border-radius: var(--radius-pill);
            margin-right: 8px;
            transition: var(--transition);
            background: transparent;
        }

        .hub-tabs .nav-link.active {
            background: #FFF1F2;
            color: #F43F5E;
            box-shadow: none;
            border: 1px solid #FECDD3;
        }
    </style>
</head>

<body>

    <!-- ======= Header ======= -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="min-height: 100vh; background: var(--light-bg);">

            <!-- Top Hero Banner -->
            <div class="hub-hero">
                <div class="container">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <span class="badge rounded-pill px-3 py-1 text-uppercase" style="font-size:0.75rem; letter-spacing:0.5px; background:#FFF1F2; color:#F43F5E;">
                                    <i class="fas fa-shield-halved me-1"></i> Martial Arts
                                </span>
                                <c:if test="${not empty currentBelt and currentBelt != 'Guest' and currentBelt != 'Not assessed'}">
                                    <div class="hero-belt-badge">
                                        <i class="fas fa-medal"></i> Current Belt: ${currentBelt}
                                    </div>
                                </c:if>
                            </div>
                            <h1>Welcome back, <c:out value="${not empty user.fullName ? user.fullName : 'Martial Artist'}"/> </h1>
                            <p>Discover verified martial arts centres and training batches near you. Continue your journey with real attendance, streaks, and belt progress.</p>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="#explorePane" class="btn rounded-pill px-4 fw-bold text-white" style="background:#F43F5E;" data-bs-toggle="tab">
                                <i class="fas fa-compass me-2"></i> Explore Dojos
                            </a>
                            <c:if test="${not empty user}">
                                <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="btn btn-outline-secondary rounded-pill px-4 fw-bold">
                                    <i class="fas fa-qrcode me-2"></i> Check In
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container pb-5">

                <c:if test="${not empty userEnrollments}">
                    <c:forEach var="en" items="${userEnrollments}">
                        <c:if test="${en.status == 'PENDING'}">
                            <div class="status-banner pending">
                                <strong>Application Status</strong>
                                <div class="mt-1">Waiting for centre review — <c:out value="${en.batch != null ? en.batch.name : 'Batch'}"/> at <c:out value="${en.center != null ? en.center.name : 'Centre'}"/>.</div>
                            </div>
                        </c:if>
                        <c:if test="${en.status == 'APPROVED' && (empty en.paymentStatus || en.paymentStatus == 'PENDING')}">
                            <div class="status-banner approved">
                                <strong>Approved</strong>
                                <div class="mt-1">Payment required to activate enrollment for <c:out value="${en.batch != null ? en.batch.name : 'your batch'}"/>.</div>
                                <a class="btn btn-sm rounded-pill text-white mt-2 fw-bold" style="background:#F43F5E;"
                                   href="${pageContext.request.contextPath}/enrollment/payment/${en.id}">Complete Payment →</a>
                            </div>
                        </c:if>
                        <c:if test="${en.status == 'REJECTED'}">
                            <div class="status-banner rejected">
                                <strong>Application rejected</strong>
                                <div class="mt-1"><c:out value="${en.batch != null ? en.batch.name : 'Batch'}"/> was not approved by the centre.</div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:if>

                <!-- 1. Stats Overview Grid -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-lg-3">
                        <div class="metric-card">
                            <div>
                                <span class="d-block text-muted small fw-bold text-uppercase" style="font-size:0.72rem;">ENROLLED BATCHES</span>
                                <h3 class="fw-bold mb-0 text-dark" id="enrolledCount">${not empty userEnrollments ? userEnrollments.size() : 0}</h3>
                            </div>
                            <div class="metric-icon" style="background:#EFF6FF; color:#3B82F6;">
                                <i class="fas fa-layer-group"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="metric-card">
                            <div>
                                <span class="d-block text-muted small fw-bold text-uppercase" style="font-size:0.72rem;">CLASSES ATTENDED</span>
                                <h3 class="fw-bold mb-0 text-dark">${attendedCount}</h3>
                            </div>
                            <div class="metric-icon" style="background:#ECFDF5; color:#10B981;">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="metric-card">
                            <div>
                                <span class="d-block text-muted small fw-bold text-uppercase" style="font-size:0.72rem;">TRAINING STREAK</span>
                                <h3 class="fw-bold mb-0 text-dark">${streak} <span class="fs-6 text-muted fw-normal">Days</span></h3>
                            </div>
                            <div class="metric-icon" style="background:#FFF1F2; color:#F43F5E;">
                                <i class="fas fa-fire-flame-curved"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="metric-card">
                            <div>
                                <span class="d-block text-muted small fw-bold text-uppercase" style="font-size:0.72rem;">CURRENT RANK</span>
                                <h3 class="fw-bold mb-0 text-dark">${currentBelt} <span class="fs-6 text-muted fw-normal">Belt</span></h3>
                            </div>
                            <div class="metric-icon" style="background:#FEF3C7; color:#D97706;">
                                <i class="fas fa-award"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. Active Training Spotlight -->
                <c:if test="${not empty activeEnrollment}">
                    <div class="active-training-hero-card">
                        <div class="row align-items-center g-3">
                            <div class="col-lg-7">
                                <span class="badge bg-danger-subtle text-danger rounded-pill px-3 py-1 fw-bold text-uppercase mb-2" style="font-size:0.72rem;">
                                    <i class="fas fa-play-circle me-1"></i> Active Training Spotlight
                                </span>
                                <h4 class="fw-bold mb-1" style="color:var(--navy);">
                                    <c:out value="${not empty activeEnrollment.batch ? activeEnrollment.batch.name : 'Martial Arts Program'}"/>
                                    <span class="badge bg-dark rounded-pill ms-2 text-white" style="font-size:0.75rem;">
                                        <c:out value="${not empty activeEnrollment.batch ? activeEnrollment.batch.style : (not empty activeEnrollment.martialArtsType ? activeEnrollment.martialArtsType.name : 'Self-Defense')}"/>
                                    </span>
                                </h4>
                                <p class="text-muted small mb-2">
                                    <i class="fas fa-university text-danger me-1"></i> <strong><c:out value="${activeEnrollment.center.name}"/></strong>
                                    · <i class="fas fa-map-marker-alt text-muted ms-2 me-1"></i> <c:out value="${activeEnrollment.center.location}"/>
                                </p>
                                <div class="d-flex flex-wrap gap-3 small text-muted">
                                    <span><i class="fas fa-user-tie text-muted me-1"></i> Coach: <strong><c:out value="${not empty activeEnrollment.batch.instructor ? activeEnrollment.batch.instructor : activeEnrollment.center.contactPerson}"/></strong></span>
                                    <span><i class="fas fa-calendar-alt text-muted me-1"></i> Days: <strong><c:out value="${activeEnrollment.batch.availableDays}"/></strong></span>
                                    <span><i class="fas fa-clock text-muted me-1"></i> Slot: <strong><c:out value="${activeEnrollment.batch.timeSlot}"/></strong></span>
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <div class="p-3 rounded-3 bg-light border">
                                    <div class="d-flex justify-content-between align-items-center mb-1 small">
                                        <span class="fw-bold text-muted">Attendance Rate</span>
                                        <strong class="text-success">${attendancePercentage}%</strong>
                                    </div>
                                    <div class="progress mb-3" style="height: 6px;">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: ${attendancePercentage}%;"></div>
                                    </div>
                                    <div class="d-flex justify-content-between gap-2">
                                        <a href="${pageContext.request.contextPath}/users/training-journey" class="btn btn-sm btn-dark rounded-pill px-3 flex-grow-1">
                                            <i class="fas fa-chart-line me-1"></i> Journey
                                        </a>
                                        <c:if test="${activeEnrollment.status == 'COMPLETED'}">
                                            <a href="${pageContext.request.contextPath}/enrollment/downloadCertificate/${activeEnrollment.id}" class="btn btn-sm btn-success rounded-pill px-3">
                                                <i class="fas fa-certificate me-1"></i> Certificate
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Navigation Tabs -->
                <ul class="nav nav-pills hub-tabs mb-4" id="martialTabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="explore-tab" data-bs-toggle="tab" data-bs-target="#explorePane" type="button">
                            <i class="fas fa-compass me-2"></i> Browse &amp; Discover Dojos
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="mytraining-tab" data-bs-toggle="tab" data-bs-target="#myTrainingsPane" type="button">
                            <i class="fas fa-user-ninja me-2"></i> My Enrolled Batches
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="online-tab" data-bs-toggle="tab" data-bs-target="#onlinePane" type="button">
                            <i class="fas fa-video me-2"></i> Live Online Classes
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="journey-tab" data-bs-toggle="tab" data-bs-target="#journeyPane" type="button">
                            <i class="fas fa-award me-2"></i> Journey &amp; Belts
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="martialTabsContent">

                    <!-- TAB 1: BROWSE & DISCOVER -->
                    <div class="tab-pane fade show active" id="explorePane" role="tabpanel">
                        <div class="mb-3">
                            <label class="small fw-bold text-muted text-uppercase mb-2 d-block" style="letter-spacing:0.5px;">
                                <i class="fas fa-filter me-1"></i> Filter by Discipline / Style
                            </label>
                            <div class="style-chip-container" id="styleFilterBar">
                                <div class="style-chip active" data-style="">All Disciplines</div>
                                <c:forEach var="st" items="${catalogStyles}">
                                    <div class="style-chip" data-style="${st.toLowerCase()}">${st}</div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
                            <div class="row g-2 align-items-center">
                                <div class="col-lg-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" id="dojoSearch" class="form-control bg-light border-start-0" placeholder="Search by academy name, city, location...">
                                    </div>
                                </div>
                                <div class="col-lg-7">
                                    <div class="d-flex flex-wrap align-items-center justify-content-lg-end gap-2">
                                        <span class="small fw-bold text-muted">Quick:</span>
                                        <button type="button" class="filter-pill active" data-quick="all">All</button>
                                        <button type="button" class="filter-pill" data-quick="women">Women-Only</button>
                                        <button type="button" class="filter-pill" data-quick="kids">Kids &amp; Teens</button>
                                        <button type="button" class="filter-pill" data-quick="online">Live Online</button>
                                        <button type="button" class="filter-pill" data-quick="trial">Free Trial</button>
                                        <select id="feeFilter" class="form-select form-select-sm" style="width:auto; border-radius:var(--radius-pill); font-size:0.8rem; font-weight:600;">
                                            <option value="">Any Fee</option>
                                            <option value="1000">Under ₹1,000</option>
                                            <option value="2000">Under ₹2,000</option>
                                            <option value="4000">Under ₹4,000</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <p class="text-muted small mb-0">
                                Showing verified academies and open batches (<strong id="visibleCardCount">${approvedCentreCount}</strong> available)
                            </p>
                        </div>

                        <div class="row g-4" id="dojoGrid">
                            <c:forEach var="center" items="${centers}">
                                <c:choose>
                                    <c:when test="${not empty center.batches}">
                                        <c:forEach var="batch" items="${center.batches}">
                                            <div class="col-md-6 col-xl-4 center-card-item" 
                                                 data-name="${center.name} ${batch.style} ${batch.name}" 
                                                 data-location="${center.location} ${center.city}" 
                                                 data-style="${batch.style.toLowerCase()}" 
                                                 data-fee="${batch.fee != null ? batch.fee : 0}"
                                                 data-mode="${batch.batchType != null ? batch.batchType.toLowerCase() : 'offline'}"
                                                 data-trial="${batch.trialType != null ? batch.trialType.toLowerCase() : 'none'}"
                                                 data-age="${batch.ageGroup != null ? batch.ageGroup.toLowerCase() : 'all'}">
                                                <div class="center-card">
                                                    <div class="position-relative">
                                                        <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="center-img" alt="${center.name}" onerror="this.src='${pageContext.request.contextPath}/beauty/images/centres.jpg'">
                                                        <div class="position-absolute top-0 start-0 p-3">
                                                            <span class="badge bg-dark rounded-pill px-3 py-1 shadow-sm" style="font-size:0.72rem;">
                                                                <i class="fas fa-wifi me-1"></i> ${batch.batchType}
                                                            </span>
                                                        </div>
                                                        <div class="position-absolute top-0 end-0 p-3">
                                                            <span class="badge bg-success rounded-pill px-3 py-1 shadow-sm" style="font-size:0.72rem;">
                                                                <i class="fas fa-patch-check me-1"></i> Verified
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="p-4 flex-grow-1 d-flex flex-column">
                                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                                            <div>
                                                                <span class="badge bg-danger-subtle text-danger rounded-pill px-2 py-1 mb-1 fw-bold" style="font-size:0.75rem;">
                                                                    ${batch.style}
                                                                </span>
                                                                <h5 class="fw-bold text-dark mb-0" style="font-size:1.05rem;">${batch.name}</h5>
                                                            </div>
                                                            <div class="text-end">
                                                                <c:choose>
                                                                    <c:when test="${batch.fee == null || batch.fee == 0}">
                                                                        <span class="text-success fw-bold fs-6">FREE</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-success fw-bold fs-6">₹${batch.fee}/mo</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        <p class="text-muted small mb-1"><i class="fas fa-university text-danger me-2"></i><strong>${center.name}</strong></p>
                                                        <p class="text-muted small mb-2"><i class="fas fa-map-marker-alt text-muted me-2"></i>${center.location}</p>
                                                        <div class="mb-3 p-2 rounded-3 bg-light border" style="font-size:0.8rem;">
                                                            <div class="d-flex justify-content-between mb-1">
                                                                <span><i class="fas fa-user-tie text-muted me-1"></i> ${not empty batch.instructor ? batch.instructor : center.contactPerson}</span>
                                                                <span><i class="fas fa-layer-group text-muted me-1"></i> ${batch.skillLevel}</span>
                                                            </div>
                                                            <div class="d-flex justify-content-between">
                                                                <span><i class="fas fa-calendar-alt text-muted me-1"></i> ${batch.availableDays}</span>
                                                                <span><i class="fas fa-clock text-muted me-1"></i> ${batch.timeSlot}</span>
                                                            </div>
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${not empty enrolledBatchIds and enrolledBatchIds.contains(batch.id)}">
                                                                <button type="button" class="btn btn-success py-2 px-3 rounded-pill w-100 mt-auto border-0" onclick="document.getElementById('mytraining-tab').click(); window.scrollTo({top: 0, behavior: 'smooth'});">
                                                                    <i class="fas fa-check-circle me-2"></i>Already Enrolled
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${not empty user}">
                                                                <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batch.id}" class="center-btn text-center text-decoration-none mt-auto">Book This Batch</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/login?redirect=/enrollment/enrollForm/${center.id}%3FbatchId%3D${batch.id}" class="center-btn text-center text-decoration-none mt-auto">Login to Book</a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-md-6 col-xl-4 center-card-item" data-name="${center.name}" data-location="${center.location}" data-style="${center.stylesTaught.toLowerCase()}" data-fee="0" data-mode="offline" data-trial="none" data-age="all">
                                            <div class="center-card">
                                                <div class="position-relative">
                                                    <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="center-img" alt="${center.name}" onerror="this.src='${pageContext.request.contextPath}/beauty/images/centres.jpg'">
                                                </div>
                                                <div class="p-4 flex-grow-1 d-flex flex-column">
                                                    <h5 class="fw-bold text-dark mb-2">${center.name}</h5>
                                                    <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt me-2 text-danger"></i>${center.location}</p>
                                                    <a href="${pageContext.request.contextPath}/centres/details/${center.id}" class="center-btn text-center text-decoration-none mt-auto">View Details</a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- TAB 2: MY ENROLLED BATCHES -->
                    <div class="tab-pane fade" id="myTrainingsPane" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty userEnrollments}">
                                <div class="row g-4">
                                    <c:forEach var="e" items="${userEnrollments}">
                                        <div class="col-md-6">
                                            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100 border">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <span class="badge bg-danger-subtle text-danger rounded-pill px-3 py-1 fw-bold text-uppercase mb-1" style="font-size:0.72rem;">
                                                            <c:out value="${not empty e.batch ? e.batch.style : (not empty e.martialArtsType ? e.martialArtsType.name : 'Martial Arts')}"/>
                                                        </span>
                                                        <h5 class="fw-bold mb-0 text-dark"><c:out value="${not empty e.batch ? e.batch.name : 'Enrolled Batch'}"/></h5>
                                                    </div>
                                                    <span class="badge rounded-pill px-3 py-1 ${e.status == 'COMPLETED' ? 'bg-success' : (e.status == 'APPROVED' ? 'bg-primary' : 'bg-warning text-dark')}">
                                                        <c:out value="${e.status}"/>
                                                    </span>
                                                </div>
                                                <p class="text-muted small mb-3">
                                                    <i class="fas fa-university text-danger me-1"></i> <strong><c:out value="${e.center.name}"/></strong>
                                                    · <i class="fas fa-map-marker-alt text-muted ms-2 me-1"></i> <c:out value="${e.center.location}"/>
                                                </p>
                                                <div class="p-3 rounded-3 bg-light border mb-3 small">
                                                    <div class="row g-2">
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">INSTRUCTOR</span>
                                                            <strong><c:out value="${not empty e.batch.instructor ? e.batch.instructor : 'Academy Coach'}"/></strong>
                                                        </div>
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">SCHEDULE</span>
                                                            <strong><c:out value="${not empty e.batch.availableDays ? e.batch.availableDays : 'Standard'}"/></strong>
                                                        </div>
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">TIMESLOT</span>
                                                            <strong><c:out value="${not empty e.batch.timeSlot ? e.batch.timeSlot : 'TBD'}"/></strong>
                                                        </div>
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">PAYMENT</span>
                                                            <span class="badge ${e.paymentStatus == 'PAID' ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-dark'}">
                                                                <c:out value="${not empty e.paymentStatus ? e.paymentStatus : 'PENDING'}"/>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center mt-auto pt-2">
                                                    <a href="${pageContext.request.contextPath}/users/training-journey" class="btn btn-sm btn-outline-dark rounded-pill px-3">
                                                        <i class="fas fa-chart-line me-1"></i> View Progress
                                                    </a>
                                                    <c:if test="${e.status == 'COMPLETED'}">
                                                        <a href="${pageContext.request.contextPath}/enrollment/downloadCertificate/${e.id}" class="btn btn-sm btn-success rounded-pill px-3">
                                                            <i class="fas fa-download me-1"></i> Certificate
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 bg-white rounded-4 shadow-sm border p-5">
                                    <i class="fas fa-user-ninja fa-3x text-muted mb-3"></i>
                                    <h4 class="fw-bold">No Active Enrollments</h4>
                                    <p class="text-muted mb-3">You have not enrolled in any Martial Arts batches yet.</p>
                                    <button class="btn btn-danger rounded-pill px-4 fw-bold" onclick="document.getElementById('explore-tab').click();">
                                        Browse Available Dojos
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- TAB 3: LIVE ONLINE CLASSES -->
                    <div class="tab-pane fade" id="onlinePane" role="tabpanel">
                        <c:choose>
                            <c:when test="${not empty upcomingOnlineClasses}">
                                <div class="row g-4">
                                    <c:forEach var="oc" items="${upcomingOnlineClasses}">
                                        <div class="col-md-6">
                                            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white border">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <div>
                                                        <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-1 fw-bold text-uppercase mb-1" style="font-size:0.72rem;">
                                                            Live Virtual Dojo
                                                        </span>
                                                        <h5 class="fw-bold mb-0 text-dark"><c:out value="${oc.title}"/></h5>
                                                    </div>
                                                    <span class="badge bg-success rounded-pill px-3 py-1">Scheduled</span>
                                                </div>
                                                <p class="text-muted small mb-3"><c:out value="${oc.description}"/></p>
                                                <div class="p-3 rounded-3 bg-light border mb-3 small">
                                                    <div class="row g-2">
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">DATE &amp; TIME</span>
                                                            <strong><c:out value="${oc.date}"/> · <c:out value="${oc.startTime}"/></strong>
                                                        </div>
                                                        <div class="col-6">
                                                            <span class="d-block text-muted">INSTRUCTOR</span>
                                                            <strong><c:out value="${oc.instructor}"/></strong>
                                                        </div>
                                                    </div>
                                                </div>
                                                <c:if test="${not empty oc.meetingLink}">
                                                    <a href="${oc.meetingLink}" target="_blank" class="btn btn-primary rounded-pill px-4 fw-bold w-100">
                                                        <i class="fas fa-video me-2"></i> Join Live Session
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5 bg-white rounded-4 shadow-sm border p-5">
                                    <i class="fas fa-video-slash fa-3x text-muted mb-3"></i>
                                    <h4 class="fw-bold">No Live Classes Right Now</h4>
                                    <p class="text-muted mb-0">Live online interactive martial arts sessions scheduled by your academy will appear here.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- TAB 4: MY JOURNEY & BELT PROGRESSION -->
                    <div class="tab-pane fade" id="journeyPane" role="tabpanel">
                        <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white border">
                            <div class="mb-4">
                                <i class="fas fa-medal fa-4x text-warning mb-3"></i>
                                <h2 class="fw-bold" style="color:var(--navy);">Your Martial Arts Journey</h2>
                                <p class="text-muted lead" style="max-width: 640px; margin: 0 auto;">
                                    Track attendance, unlock higher belt ranks, review instructor feedback, and download your accredited certificates.
                                </p>
                            </div>

                            <div class="row g-3 justify-content-center mb-4">
                                <div class="col-md-3">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <span class="d-block text-muted small fw-bold">CURRENT RANK</span>
                                        <h4 class="fw-bold mb-0 text-dark">${currentBelt} Belt</h4>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <span class="d-block text-muted small fw-bold">ATTENDANCE RATE</span>
                                        <h4 class="fw-bold mb-0 text-success">${attendancePercentage}%</h4>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="p-3 bg-light rounded-4 border">
                                        <span class="d-block text-muted small fw-bold">TRAINING STREAK</span>
                                        <h4 class="fw-bold mb-0 text-danger">${streak} Days</h4>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <a href="${pageContext.request.contextPath}/users/training-journey" class="btn btn-danger btn-lg rounded-pill px-5 fw-bold shadow-sm">
                                    Open Full Interactive Journey Dashboard <i class="fas fa-arrow-right ms-2"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>

    <script>
        AOS.init({ duration: 800, once: true });

        // Category & Search Filters Engine
        let selectedStyle = '';
        let quickFilter = 'all';

        // 1. Style chips handler
        document.querySelectorAll('.style-chip').forEach(chip => {
            chip.addEventListener('click', function() {
                document.querySelectorAll('.style-chip').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                selectedStyle = (this.getAttribute('data-style') || '').toLowerCase().trim();
                applyFilters();
            });
        });

        // 2. Quick filter pills handler
        document.querySelectorAll('.filter-pill').forEach(pill => {
            pill.addEventListener('click', function() {
                document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
                this.classList.add('active');
                quickFilter = this.getAttribute('data-quick');
                applyFilters();
            });
        });

        // 3. Search input & fee dropdown
        document.getElementById('dojoSearch').addEventListener('input', applyFilters);
        document.getElementById('feeFilter').addEventListener('change', applyFilters);

        function normalizeStyle(value) {
            return (value || '').toLowerCase().replace(/[^a-z0-9]/g, '');
        }

        function applyFilters() {
            const query = (document.getElementById('dojoSearch').value || '').toLowerCase().trim();
            const maxFee = parseFloat(document.getElementById('feeFilter').value) || 0;
            const items = document.querySelectorAll('.center-card-item');
            let visibleCount = 0;
            const selectedNorm = normalizeStyle(selectedStyle);

            items.forEach(item => {
                const name = (item.getAttribute('data-name') || '').toLowerCase();
                const loc = (item.getAttribute('data-location') || '').toLowerCase();
                const style = (item.getAttribute('data-style') || '').toLowerCase();
                const styleNorm = normalizeStyle(style);
                const fee = parseFloat(item.getAttribute('data-fee')) || 0;
                const mode = (item.getAttribute('data-mode') || '').toLowerCase();
                const trial = (item.getAttribute('data-trial') || '').toLowerCase();
                const age = (item.getAttribute('data-age') || '').toLowerCase();

                let matchQuery = !query || name.includes(query) || loc.includes(query) || style.includes(query);
                let matchStyle = !selectedNorm || styleNorm.includes(selectedNorm) || selectedNorm.includes(styleNorm);
                let matchFee = maxFee <= 0 || (fee > 0 && fee <= maxFee);

                let matchQuick = true;
                if (quickFilter === 'women') {
                    matchQuick = name.includes('women') || style.includes('self-defence') || style.includes('self-defense') || styleNorm.includes('selfdefence');
                } else if (quickFilter === 'kids') {
                    matchQuick = age.includes('kid') || age.includes('teen') || name.includes('kid') || name.includes('teen');
                } else if (quickFilter === 'online') {
                    matchQuick = mode.includes('online') || mode.includes('hybrid');
                } else if (quickFilter === 'trial') {
                    matchQuick = trial.includes('free') || trial.includes('demo');
                }

                if (matchQuery && matchStyle && matchFee && matchQuick) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            const countEl = document.getElementById('visibleCardCount');
            if (countEl) countEl.innerText = visibleCount;
        }
    </script>
</body>
</html>

