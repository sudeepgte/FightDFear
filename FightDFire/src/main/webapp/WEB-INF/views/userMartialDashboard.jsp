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
            --primary-purple: #1e1b4b;
            --primary-purple-light: #312e81;
            --primary-coral: #f43f5e;
            --dark-bg: #0f0f1a;
            --light-bg: #fffcfd;
            --glass-bg: rgba(255, 255, 255, 0.9);
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            --shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.08);
            --transition-smooth: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            background: var(--light-bg);
            font-family: 'Poppins', sans-serif;
            color: #333;
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
        .blob-1 { top: -100px; right: -100px; background: var(--primary-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--primary-coral); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid rgba(0,0,0,0.08);
            position: relative;
            margin-bottom: 40px;
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
            color: #666;
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid rgba(0,0,0,0.08);
            color: var(--primary-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .top-btn:hover {
            background: var(--primary-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }

        /* Custom Tabs */
        .custom-nav-tabs {
            border: none;
            justify-content: center;
            margin-bottom: 30px;
        }

        .custom-nav-tabs .nav-link {
            border: none;
            color: #666;
            font-weight: 600;
            padding: 12px 30px;
            border-radius: 30px;
            margin: 0 10px;
            transition: var(--transition-smooth);
            background: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .custom-nav-tabs .nav-link.active {
            background: var(--gradient-primary);
            color: white;
            box-shadow: 0 8px 20px rgba(123, 44, 191, 0.3);
        }

        /* Stats Cards */
        .stat-card {
            background: #fff;
            border-radius: 20px;
            padding: 25px;
            border: none;
            box-shadow: var(--shadow-lg);
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.12);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        /* Enrollment Cards */
        .enrollment-card {
            background: white;
            border-radius: 20px;
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: var(--transition-smooth);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .enrollment-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .enrollment-header {
            background: var(--gradient-primary);
            color: white;
            padding: 15px 20px;
            font-weight: 600;
        }

        /* Center Grid Cards */
        .center-card {
            background: #fff;
            border-radius: 24px;
            overflow: hidden;
            transition: var(--transition-smooth);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid rgba(123, 44, 191, 0.05);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .center-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-purple-light);
        }

        .center-img {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }

        .center-btn {
            background: var(--gradient-primary);
            border: none;
            border-radius: 30px;
            color: white;
            font-weight: 600;
            padding: 10px 25px;
            transition: var(--transition-smooth);
        }

        .center-btn:hover {
            box-shadow: 0 5px 15px rgba(123, 44, 191, 0.4);
            color: white;
            transform: scale(1.02);
        }
    </style>
</head>

<body>

    <!-- ======= Header ======= -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip; background: var(--light-bg);">
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-house-door"></i> Home
                </a>
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="top-btn">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </a>
            </div>
            
            <h1>Martial Arts Hub</h1>
            <p>Welcome back, ${user.fullName}. Elevate your self-defense prowess and mastery. Discover verified martial arts centres, browse interactive training courses, or track your custom belt progression.</p>
        </div>

    <div class="container mb-5">
        <!-- Dashboard Navigation -->
        <ul class="nav nav-tabs custom-nav-tabs" id="hubTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab">My Dashboard</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="explore-tab" data-bs-toggle="tab" data-bs-target="#explore" type="button" role="tab">Browse Dojos</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="online-tab" data-bs-toggle="tab" data-bs-target="#online-classes" type="button" role="tab">
                    Live Online Classes
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="journey-tab" data-bs-toggle="tab" data-bs-target="#journey" type="button" role="tab">My Journey</button>
            </li>
        </ul>

        <div class="tab-content" id="hubTabContent">
            
            <!-- Tab 1: User Overview & Enrollments -->
            <div class="tab-pane fade show active" id="overview" role="tabpanel">
                
                <!-- Stats Overview -->
                <div class="row g-4 mb-5">
                    <div class="col-md-4" data-aos="fade-up">
                        <div class="stat-card">
                            <div>
                                <h6 class="text-muted mb-1">Total Enrolled</h6>
                                <h2 class="mb-0 fw-bold" id="enrolledCount">0</h2>
                            </div>
                            <div class="stat-icon bg-primary"><i class="fas fa-hand-fist"></i></div>
                        </div>
                    </div>
                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                        <div class="stat-card">
                            <div>
                                <h6 class="text-muted mb-1">In Progress</h6>
                                <h2 class="mb-0 fw-bold" id="progressCount">0</h2>
                            </div>
                            <div class="stat-icon bg-warning"><i class="fas fa-spinner fa-spin"></i></div>
                        </div>
                    </div>
                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                        <div class="stat-card">
                            <div>
                                <h6 class="text-muted mb-1">Certificates</h6>
                                <h2 class="mb-0 fw-bold" id="completedCount">0</h2>
                            </div>
                            <div class="stat-icon bg-success"><i class="fas fa-certificate"></i></div>
                        </div>
                    </div>
                </div>

                <!-- My Enrollments Listing -->
                <h3 class="mb-4 fw-bold text-dark"><i class="fas fa-bookmark text-primary me-2"></i> My Active Trainings</h3>
                <div id="enrollmentGrid" class="row g-4">
                    <div class="col-12 text-center py-5" id="loadingState">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-3 text-muted">Retrieving your training status...</p>
                    </div>
                </div>
            </div>

            <!-- Tab: Dedicated Online Classes Dashboard -->
            <div class="tab-pane fade" id="online-classes" role="tabpanel">
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm rounded-4 p-4 mb-4" style="background: linear-gradient(90deg, #FDF2F8 0%, #FFFFFF 100%);">
                            <div class="d-flex align-items-center">
                                <div class="bg-pink-100 p-3 rounded-4 me-4">
                                    <i class="fas fa-video fa-2x text-pink-600"></i>
                                </div>
                                <div>
                                    <h4 class="fw-bold mb-1">Live Online Sessions</h4>
                                    <p class="text-muted mb-0">Join your virtual dojo sessions here. Mark attendance automatically by joining live.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="onlineClassGrid" class="row g-4">
                    <!-- Dynamic Online Classes will load here -->
                    <div class="col-12 text-center py-5">
                        <p class="text-muted">Loading your virtual classes...</p>
                    </div>
                </div>
            </div>

            <!-- Tab 2: Explore Available Dojos -->
            <div class="tab-pane fade" id="explore" role="tabpanel">
                
                <!-- Search & Filter Area -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="input-group shadow-sm rounded-pill overflow-hidden bg-white p-1">
                            <span class="input-group-text border-0 bg-white ms-2"><i class="fas fa-search text-muted"></i></span>
                            <input type="text" id="dojoSearch" class="form-control border-0 bg-white" placeholder="Search by academy name or location...">
                        </div>
                    </div>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-warning rounded-4 border-0 shadow-sm mb-4">${message}</div>
                </c:if>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <p class="text-muted mb-0">
                        <strong>${approvedCentreCount}</strong> verified centres
                        <c:if test="${totalBatchCount > 0}"> · <strong>${totalBatchCount}</strong> open batches</c:if>
                    </p>
                    <c:if test="${empty user}">
                        <a href="${pageContext.request.contextPath}/login?redirect=/centres/allacceptedcentres" class="btn btn-sm btn-outline-primary rounded-pill">Login to book</a>
                    </c:if>
                </div>
                <div class="row g-4" id="dojoGrid">
                    <c:forEach var="center" items="${centers}">
                        <c:choose>
                            <c:when test="${not empty center.batches}">
                                <c:forEach var="batch" items="${center.batches}">
                                    <div class="col-md-4 center-card-item" data-name="${center.name} ${batch.style} ${batch.name}" data-location="${center.location}">
                                        <div class="center-card">
                                            <div class="position-relative">
                                                <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="center-img" alt="${center.name}" onerror="this.src='${pageContext.request.contextPath}/beauty/images/centres.jpg'">
                                                <div class="position-absolute top-0 end-0 p-3">
                                                    <span class="badge bg-primary rounded-pill shadow-sm">${batch.batchType}</span>
                                                </div>
                                            </div>
                                            <div class="p-4 flex-grow-1 d-flex flex-column">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="fw-bold text-dark mb-0">${batch.style}</h5>
                                                    <span class="text-primary fw-bold">₹${batch.fee}</span>
                                                </div>
                                                <p class="text-muted small mb-2"><i class="fas fa-university text-primary-subtle me-2"></i>${center.name}</p>
                                                <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt text-primary-subtle me-2"></i>${center.location}</p>
                                                <div class="mb-3">
                                                    <div class="d-flex align-items-center mb-1">
                                                        <i class="fas fa-user-tie text-muted me-2 small"></i>
                                                        <span class="small text-muted">Instructor: ${batch.instructor}</span>
                                                    </div>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-clock text-muted me-2 small"></i>
                                                        <span class="small text-muted">${batch.timeSlot}</span>
                                                    </div>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${not empty enrolledBatchIds and enrolledBatchIds.contains(batch.id)}">
                                                        <button type="button" class="btn btn-success py-2 px-3 rounded-pill w-100 mt-auto border-0" onclick="document.getElementById('overview-tab').click(); window.scrollTo({top: 0, behavior: 'smooth'});">
                                                            <i class="fas fa-check-circle me-2"></i>Already Enrolled
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${not empty user}">
                                                        <a href="${pageContext.request.contextPath}/enrollment/enrollForm/${center.id}?batchId=${batch.id}" class="center-btn text-center text-decoration-none mt-auto">Book Now</a>
                                                        <a href="${pageContext.request.contextPath}/centres/details/${center.id}" class="btn btn-link btn-sm text-muted text-center mt-2">View details</a>
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
                                <div class="col-md-4 center-card-item" data-name="${center.name}" data-location="${center.location}">
                                    <div class="center-card">
                                        <div class="position-relative">
                                            <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="center-img" alt="${center.name}" onerror="this.src='${pageContext.request.contextPath}/beauty/images/centres.jpg'">
                                            <div class="position-absolute top-0 end-0 p-3">
                                                <span class="badge bg-success rounded-pill shadow-sm">Verified</span>
                                            </div>
                                        </div>
                                        <div class="p-4 flex-grow-1 d-flex flex-column">
                                            <h5 class="fw-bold text-dark mb-2">${center.name}</h5>
                                            <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt me-2"></i>${center.location}</p>
                                            <c:if test="${not empty center.martialArtsTypes}">
                                                <p class="small text-muted mb-3">Programs:
                                                    <c:forEach var="t" items="${center.martialArtsTypes}" varStatus="st">
                                                        ${t.name}<c:if test="${!st.last}">, </c:if>
                                                    </c:forEach>
                                                </p>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/centres/details/${center.id}" class="center-btn text-center text-decoration-none mt-auto">View &amp; Enquire</a>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${empty centers}">
                        <div class="col-12 text-center py-5">
                            <p class="text-muted mb-2">No admin-approved centres are listed yet.</p>
                            <p class="small text-muted">Centres appear here after admin approval in Martial Arts Management.</p>
                        </div>
                    </c:if>
                </div>
            </div>
            <!-- Tab 3: My Journey Track -->
            <div class="tab-pane fade" id="journey" role="tabpanel">
                <div class="row">
                    <div class="col-lg-10 mx-auto">
                        <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-dark text-white p-5 text-center" style="background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%) !important;">
                            <div class="mb-4">
                                <i class="fas fa-map-marked-alt fa-4x text-danger mb-3"></i>
                                <h2 class="fw-bold">Your Training Journey Awaits</h2>
                                <p class="text-white-50 lead">Track every milestone, from your first stance to your black belt. View attendance, trainer feedback, and skill progression in your personal dashboard.</p>
                            </div>
                            <div class="d-flex justify-content-center gap-3">
                                <a href="${pageContext.request.contextPath}/users/training-journey" class="btn btn-danger btn-lg rounded-pill px-5 fw-bold shadow">
                                    Open Full Journey Dashboard <i class="bi bi-arrow-right ms-2"></i>
                                </a>
                            </div>
                            
                            <div class="row mt-5 g-4">
                                <div class="col-md-4">
                                    <div class="p-3 bg-white bg-opacity-10 rounded-4">
                                        <i class="fas fa-medal text-warning mb-2 fa-lg"></i>
                                        <h6 class="mb-0 small">Belt Progress</h6>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 bg-white bg-opacity-10 rounded-4">
                                        <i class="fas fa-chart-line text-info mb-2 fa-lg"></i>
                                        <h6 class="mb-0 small">Skill Tracking</h6>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 bg-white bg-opacity-10 rounded-4">
                                        <i class="fas fa-calendar-check text-success mb-2 fa-lg"></i>
                                        <h6 class="mb-0 small">Attendance</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Timeline CSS -->
    <style>
        .journey-timeline {
            position: relative;
            padding-left: 50px;
        }
        .journey-timeline::before {
            content: '';
            position: absolute;
            left: 20px;
            top: 0;
            bottom: 0;
            width: 3px;
            background: #eee;
            border-radius: 3px;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 40px;
        }
        .timeline-dot {
            position: absolute;
            left: -42px;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            background: #fff;
            border: 4px solid #ddd;
            z-index: 2;
            transition: all 0.3s ease;
        }
        .timeline-item.active .timeline-dot {
            border-color: var(--primary-purple);
            background: var(--primary-purple);
            box-shadow: 0 0 0 5px rgba(30, 27, 75, 0.1);
        }
        .timeline-item.completed .timeline-dot {
            border-color: #198754;
            background: #198754;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 10px;
        }
        .timeline-content {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            transition: all 0.3s ease;
        }
        .timeline-item.active .timeline-content {
            background: #fff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            border-left: 5px solid var(--primary-purple);
        }
    </style>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>


<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <script>
        AOS.init({
            duration: 800,
            easing: 'slide',
            once: true
        });

        // Search mechanism for Dojos
        document.getElementById('dojoSearch').addEventListener('input', function(e) {
            const query = e.target.value.toLowerCase();
            const items = document.querySelectorAll('.center-card-item');
            
            items.forEach(item => {
                const name = item.getAttribute('data-name').toLowerCase();
                const loc = item.getAttribute('data-location').toLowerCase();
                if (name.includes(query) || loc.includes(query)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });        // Dynamic Enrollments Loader
        const userId = '${user.id}';
        if (userId) {
            // Fetch All Enrollments for Main Dashboard
            fetch('${pageContext.request.contextPath}/enrollment/trainee/my-trainings')
                .then(res => res.json())
                .then(data => {
                    const grid = document.getElementById('enrollmentGrid');
                    const loading = document.getElementById('loadingState');
                    if(loading) loading.style.display = 'none';

                    if (data && data.length > 0) {
                        document.getElementById('enrolledCount').innerText = data.length;
                        let inProgress = 0, completed = 0, htmlContent = '';

                        data.forEach(enroll => {
                            if (enroll.status === 'COMPLETED') completed++;
                            else inProgress++;


                            const badgeClass = enroll.status === 'COMPLETED' ? 'bg-success' : 
                                             enroll.status === 'IN_PROGRESS' || enroll.status === 'APPROVED' ? 'bg-primary' : 'bg-warning text-dark';
                            
                            const contextPath = '${pageContext.request.contextPath}';
                            let actionHtml = '';
                            if (enroll.status === 'COMPLETED') {
                                actionHtml = '<a href="' + contextPath + '/enrollment/downloadCertificate/' + enroll.id + '" class="btn btn-sm btn-success rounded-pill px-3 w-100"><i class="fas fa-download me-2"></i>Download Certificate</a>';
                            } else {
                                actionHtml = '<button class="btn btn-sm btn-outline-primary rounded-pill px-3 w-100" disabled><i class="fas fa-running me-2"></i>Keep training to reach 100%</button>';
                            }

                            const statusBadge = enroll.status === 'COMPLETED' ? 'bg-success' : 
                                              enroll.status === 'REJECTED' ? 'bg-danger' : 
                                              enroll.status === 'APPROVED' ? 'bg-primary' : 'bg-warning text-dark';
                            
                            const paymentBadge = enroll.paymentStatus === 'PAID' ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning-emphasis';


                            htmlContent += `
                                <div class="col-12 col-xl-6" data-aos="fade-up">
                                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 training-record-card">
                                        <div class="card-header bg-white border-0 p-4 pb-0">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <span class="badge rounded-pill mb-2 \${statusBadge}">\${enroll.status}</span>
                                                    <h5 class="fw-bold text-dark mb-1">\${enroll.martialArtType}</h5>
                                                    <p class="text-muted small mb-0"><i class="fas fa-university me-2"></i>\${enroll.centreName} (ID: \${enroll.centreId})</p>
                                                </div>
                                                <div class="text-end">
                                                    <span class="badge \${paymentBadge} px-3 rounded-pill mb-1">PAYMENT: \${enroll.paymentStatus}</span>
                                                    <div class="text-muted small">ID: #\${enroll.enrollmentId}</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-3 pt-3 border-top">
                                            \${actionHtml}

                                        <div class="card-body p-4">
                                            <div class="row g-3 mb-4">
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100">
                                                        <small class="text-muted d-block mb-1">Trainer</small>
                                                        <span class="fw-bold small">\${enroll.trainerName}</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100">
                                                        <small class="text-muted d-block mb-1">Mode</small>
                                                        <span class="badge bg-primary-subtle text-primary rounded-pill">\${enroll.mode.toUpperCase()}</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100">
                                                        <small class="text-muted d-block mb-1">Batch</small>
                                                        <span class="fw-bold small">\${enroll.batchName}</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100">
                                                        <small class="text-muted d-block mb-1">Timing</small>
                                                        <span class="small fw-semibold">\${enroll.slot}</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100">
                                                        <small class="text-muted d-block mb-1">Attendance</small>
                                                        <span class="fw-bold text-primary">\${enroll.attendancePercentage}%</span>
                                                    </div>
                                                </div>
                                                <div class="col-6 col-sm-4">
                                                    <div class="p-3 bg-light rounded-4 h-100 border-start border-3 border-warning">
                                                        <small class="text-muted d-block mb-1">Next Class</small>
                                                        <span class="small fw-bold text-dark">\${enroll.nextClassDate}</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span class="small fw-bold text-dark">Course Progress</span>
                                                    <span class="small fw-bold text-primary">\${enroll.progress}%</span>
                                                </div>
                                                <div class="progress" style="height: 10px; border-radius: 5px; background: #E2E8F0;">
                                                    <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                                         role="progressbar" 
                                                         style="width: \${enroll.progress}%; background: linear-gradient(90deg, #6366F1 0%, #A855F7 100%);" 
                                                         aria-valuenow="\${enroll.progress}" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                                <small class="text-muted">Enrolled: \${enroll.enrollmentDate}</small>
                                                \${enroll.status === 'COMPLETED' ? 
                                                    `<a href="\${pageContext.request.contextPath}/enrollment/downloadCertificate/\${enroll.enrollmentId}" class="btn btn-success rounded-pill px-4"><i class="fas fa-download me-2"></i>Certificate</a>` : 
                                                    `<button class="btn btn-primary rounded-pill px-4" onclick="const tabId = '\${enroll.mode.toLowerCase() === 'online' ? 'online-tab' : 'journey-tab'}'; document.getElementById(tabId).click(); window.scrollTo({top: 0, behavior: 'smooth'});">
                                                        <i class="fas fa-running me-2"></i>Keep Going
                                                    </button>`
                                                }
                                            </div>

                                        </div>
                                    </div>
                                </div>`;
                        });
                        document.getElementById('progressCount').innerText = inProgress;
                        document.getElementById('completedCount').innerText = completed;
                        grid.innerHTML = htmlContent;
                    } else {
                        grid.innerHTML = '<div class="col-12 text-center py-5"><div class="p-5 bg-light rounded-4"><i class="fas fa-bookmark fa-3x text-muted mb-3 opacity-25"></i><p class="text-muted fw-bold">No trainings enrolled yet</p><a href="#explore" class="btn btn-primary rounded-pill px-4 mt-2" data-bs-toggle="tab">Explore Dojos</a></div></div>';
                    }
                })
                .catch(err => {
                    console.error('Enrollments load error:', err);
                    if(grid) grid.innerHTML = '<div class="col-12 text-center py-5 text-danger"><p>Failed to load your training records. Please try again.</p></div>';
                });

            // Fetch Dedicated Online Classes
            const onlineGrid = document.getElementById('onlineClassGrid');
            fetch('${pageContext.request.contextPath}/online-class/my-classes')
                .then(res => {
                    if(!res.ok) throw new Error('Unauthorized or Session Expired');
                    return res.json();
                })
                .then(sections => {
                    if (!onlineGrid) return;
                    
                    let html = '';
                    const renderedClassIds = new Set();

                    // 1. Invitations Section
                    if (sections && sections.invitations && sections.invitations.length > 0) {
                        let invHtml = '';
                        sections.invitations.forEach(inv => {
                            if (renderedClassIds.has(inv.id)) return;
                            renderedClassIds.add(inv.id);
                            invHtml += `
                                <div class="col-md-6 col-lg-4" data-aos="fade-up">
                                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 border-start border-4 border-primary">
                                        <div class="p-4">
                                            <div class="d-flex justify-content-between align-items-start mb-3">
                                                <div>
                                                    <h5 class="fw-bold mb-0">\${inv.title}</h5>
                                                    <small class="text-muted">\${inv.centerName} • \${inv.trainerName}</small>
                                                </div>
                                                <span class="badge bg-primary-subtle text-primary rounded-pill">ONLINE</span>
                                            </div>
                                            <div class="mb-4">
                                                <div class="text-muted small mb-1"><i class="fas fa-calendar me-2"></i>\${inv.date}</div>
                                                <div class="text-muted small mb-1"><i class="fas fa-clock me-2"></i>\${inv.startTime} - \${inv.endTime}</div>
                                                <div class="badge bg-light text-dark fw-normal mt-2"><i class="fas fa-tag me-1 text-primary"></i> \${inv.sessionType || 'Group Session'}</div>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <button onclick="respondInvite(\${inv.invitationId}, 'ACCEPT')" class="btn btn-primary flex-grow-1 rounded-pill small">Accept</button>
                                                <button onclick="respondInvite(\${inv.invitationId}, 'REJECT')" class="btn btn-outline-secondary flex-grow-1 rounded-pill small">Decline</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                        if (invHtml) {
                            html += `<div class="col-12 mb-4"><h5 class="fw-bold text-dark"><i class="fas fa-envelope-open-text text-primary me-2"></i>Session Invitations</h5></div>` + invHtml;
                        }
                    }

                    // 2. Live Now Section
                    if (sections && sections.live && sections.live.length > 0) {
                        let liveHtml = '';
                        sections.live.forEach(oc => {
                            if (renderedClassIds.has(oc.id)) return;
                            renderedClassIds.add(oc.id);
                            liveHtml += `
                                <div class="col-md-6 col-lg-4" data-aos="fade-up">
                                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 border-start border-4 border-danger">
                                        <div class="p-4">
                                            <div class="d-flex justify-content-between mb-3">
                                                <span class="badge bg-danger rounded-pill pulse px-3">LIVE SESSION</span>
                                                <small class="fw-bold text-danger">Ongoing</small>
                                            </div>
                                            <h5 class="fw-bold mb-1">\${oc.title}</h5>
                                            <p class="text-muted small mb-2">\${oc.martialArtType} • \${oc.sessionType || 'Live'}</p>
                                            \${oc.notes ? `<div class="bg-light p-2 rounded-3 small text-muted mb-3"><i class="fas fa-info-circle me-1"></i> \${oc.notes}</div>` : ''}
                                            <div class="d-grid mt-auto">
                                                <button onclick="joinOnlineClass('\${oc.id}')" class="btn btn-danger rounded-pill shadow-sm py-2">
                                                    <i class="fas fa-video me-2"></i> \${oc.meetingLink && oc.meetingLink.includes('jit.si') ? 'Join Jitsi Class' : 'Join Live Class'}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                        if (liveHtml) {
                            html += `<div class="col-12 mt-4 mb-4"><h5 class="fw-bold text-danger"><i class="fas fa-broadcast-tower me-2"></i>Live Now</h5></div>` + liveHtml;
                        }
                    }

                    // 3. Upcoming Section
                    if (sections && sections.upcoming && sections.upcoming.length > 0) {
                        let upcomingHtml = '';
                        sections.upcoming.forEach(oc => {
                            if (renderedClassIds.has(oc.id)) return;
                            renderedClassIds.add(oc.id);
                            upcomingHtml += `
                                <div class="col-md-6 col-lg-4" data-aos="fade-up">
                                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 bg-light opacity-75">
                                        <div class="p-4">
                                            <h5 class="fw-bold mb-1 text-muted">\${oc.title}</h5>
                                            <p class="text-muted small mb-3">\${oc.martialArtType}</p>
                                            <div class="mb-3">
                                                <div class="text-muted small"><i class="fas fa-calendar me-2"></i>\${oc.date}</div>
                                                <div class="text-muted small"><i class="fas fa-clock me-2"></i>\${oc.startTime}</div>
                                            </div>
                                            <div class="d-grid mt-4">
                                                <button class="btn btn-outline-secondary rounded-pill w-100" disabled>
                                                    Scheduled for \${oc.startTime}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                        if (upcomingHtml) {
                            html += `<div class="col-12 mt-5 mb-4"><h5 class="fw-bold text-dark"><i class="fas fa-calendar-alt text-muted me-2"></i>Upcoming Sessions</h5></div>` + upcomingHtml;
                        }
                    }

                    // 4. Completed Section
                    if (sections && sections.completed && sections.completed.length > 0) {
                        let completedHtml = '';
                        sections.completed.forEach(oc => {
                            completedHtml += `
                                <div class="col-md-6 col-lg-4" data-aos="fade-up">
                                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 bg-light border-top border-4 border-success">
                                        <div class="p-4">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="badge bg-success-subtle text-success rounded-pill px-3">COMPLETED</span>
                                                <small class="text-muted">\${oc.date}</small>
                                            </div>
                                            <h5 class="fw-bold mb-1 text-muted">\${oc.title}</h5>
                                            <p class="text-muted small mb-3">\${oc.martialArtType}</p>
                                            <div class="d-grid mt-4">
                                                \${oc.recordingLink ? 
                                                    `<a href="\${oc.recordingLink}" target="_blank" class="btn btn-outline-success rounded-pill w-100">
                                                        <i class="fas fa-play-circle me-2"></i>Watch Recording
                                                    </a>` :
                                                    `<button class="btn btn-light rounded-pill w-100" disabled>No Recording Available</button>`
                                                }
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        });
                        if (completedHtml) {
                            html += `<div class="col-12 mt-5 mb-4"><h5 class="fw-bold text-dark"><i class="fas fa-check-double text-success me-2"></i>Completed Sessions</h5></div>` + completedHtml;
                        }
                    }

                    if (html === '') {
                        onlineGrid.innerHTML = '<div class="col-12 text-center py-5"><p class="text-muted">Your online schedule is empty. Check back later for invites!</p></div>';
                    } else {
                        onlineGrid.innerHTML = html;
                    }
                })
                .catch(err => {
                    console.error('Online classes load error:', err);
                    if(onlineGrid) onlineGrid.innerHTML = '<div class="col-12 text-center py-5 text-muted"><i class="fas fa-lock mb-3 fa-2x opacity-25"></i><br>Please login to view your online classes.</div>';
                });
        } else {
            // Guest User Handling
            const grid = document.getElementById('enrollmentGrid');
            const onlineGrid = document.getElementById('onlineClassGrid');
            const loading = document.getElementById('loadingState');
            if(loading) loading.style.display = 'none';
            if(grid) grid.innerHTML = '<div class="col-12 text-center py-5 text-muted"><p>Please login to view your training dashboard.</p></div>';
            if(onlineGrid) onlineGrid.innerHTML = '<div class="col-12 text-center py-5 text-muted"><i class="fas fa-lock mb-3 fa-2x opacity-25"></i><br>Please login to view your online classes.</div>';
        }


        async function respondInvite(invitationId, action) {
            const res = await fetch('${pageContext.request.contextPath}/online-class/invitation/respond', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ invitationId, action })
            });
            if (res.ok) {
                location.reload();
            } else {
                alert('Action failed. Please try again.');
            }
        }

        function joinOnlineClass(onlineClassId) {
            fetch('${pageContext.request.contextPath}/online-class/trainee-join/' + onlineClassId, {
                method: 'POST'
            }).then(res => res.json())
                .then(data => {
                    if (data.meetingLink) {
                        window.open(data.meetingLink, '_blank');
                        location.reload();
                    } else {
                        alert(data.message || 'Unable to join class');
                    }
                }).catch(err => alert('Error joining class'));
        }

        // Add CSS for status badges if not present
        const style = document.createElement('style');
        style.textContent = `
            .status-upcoming { background: #DBEAFE; color: #1E40AF; }
            .status-live { background: #FEE2E2; color: #DC2626; animation: pulse 2s infinite; }
            .status-completed { background: #D1FAE5; color: #065F46; }
            @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
            .pulse { animation: pulse 1.5s infinite; }
        `;
        document.head.appendChild(style);

        // Auto-activate a specific tab if requested by server
        const activeTab = '${activeTab}';
        if (activeTab && activeTab !== '') {
            const tabEl = document.getElementById(activeTab + '-tab');
            if (tabEl) {
                const tab = new bootstrap.Tab(tabEl);
                tab.show();
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }

    </script>
    </div>
</div>
</body>
</html>

