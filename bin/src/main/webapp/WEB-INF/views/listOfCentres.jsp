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

        /* Hero Banner (Legacy) */
        /* Removed in favor of interactive collage-hero system */

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

        /* Dashboard Button Styling */
        .dashboard-bar {
            position: relative;
            z-index: 99;
            margin-top: 10px;
            padding-right: 15px;
        }
        .dashboard-btn {
            background: var(--gradient-primary);
            color: #fff !important;
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            font-family: 'Poppins', sans-serif;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
        }
        .dashboard-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 25px rgba(124, 45, 94, 0.45);
            color: #fff !important;
        }
        .dashboard-btn i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }
        .dashboard-btn:hover i {
            transform: translateX(5px);
        }
    </style>
</head>

<body>

    <!-- ======= Header ======= -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="dashboard-bar container-fluid container-xl d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="dashboard-btn">
            Dashboard <i class="bi bi-arrow-right"></i>
        </a>
    </div>

    <style>
        .collage-hero {
            display: flex;
            width: 100%;
            height: 550px;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
            overflow: hidden;
            margin-bottom: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            position: relative;
            background: #000;
        }
        .collage-panel {
            flex: 1;
            height: 100%;
            border-right: 3px solid #111;
            overflow: hidden;
            position: relative;
            transition: flex 0.6s cubic-bezier(0.25, 1, 0.5, 1);
            cursor: pointer;
        }
        .collage-panel:last-child { border-right: none; }
        .collage-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.6) contrast(1.1);
            transition: all 0.6s ease;
        }
        .collage-panel:hover { flex: 2; }
        .collage-panel:hover img { filter: brightness(1); transform: scale(1.05); }
        .collage-overlay {
            position: absolute;
            inset: 0;
            pointer-events: none;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent 70%);
            z-index: 2;
        }
        .hub-hero-text {
            position: absolute;
            bottom: 60px;
            left: 0;
            right: 0;
            text-align: center;
            color: #fff;
            z-index: 10;
            pointer-events: none;
        }
        .hub-hero-text h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 3.5rem;
            text-shadow: 0 4px 20px rgba(0,0,0,0.8);
            margin-bottom: 10px;
        }
        .hub-hero-text p {
            font-size: 1.25rem;
            text-shadow: 0 2px 10px rgba(0,0,0,0.8);
        }
    </style>

    <!-- Hub Hero Collage -->
    <section class="collage-hero">
        <div class="collage-panel" onclick="window.location.href='${pageContext.request.contextPath}/centres/allacceptedcentres'">
            <img src="${pageContext.request.contextPath}/assets/img/ma-hero-1.jpg" alt="Martial Arts 1">
        </div>
        <div class="collage-panel" onclick="window.location.href='${pageContext.request.contextPath}/centres/allacceptedcentres'">
            <img src="${pageContext.request.contextPath}/assets/img/ma-hero-2.jpg" alt="Martial Arts 2">
        </div>
        <div class="collage-panel" onclick="window.location.href='${pageContext.request.contextPath}/centres/allacceptedcentres'">
            <img src="${pageContext.request.contextPath}/assets/img/ma-hero-3.jpg" alt="Martial Arts 3">
        </div>
        <div class="collage-overlay"></div>
        <div class="hub-hero-text">
            <h1 data-aos="fade-down">Empowerment Martial Arts Hub</h1>
            <p class="lead" data-aos="fade-up" data-aos-delay="100">Discover verified training academies near you.</p>
        </div>
    </section>

    <div class="container mb-5">
        <!-- Dashboard Navigation -->
        <ul class="nav nav-tabs custom-nav-tabs" id="hubTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="explore-tab" data-bs-toggle="tab" data-bs-target="#explore" type="button" role="tab">Browse Dojos</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab">My Dashboard</button>
            </li>
        </ul>

        <div class="tab-content" id="hubTabContent">
            
            <!-- Tab 1: Explore Available Dojos -->
            <div class="tab-pane fade show active" id="explore" role="tabpanel">
                
                <!-- Search & Filter Area -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="input-group shadow-sm rounded-pill overflow-hidden bg-white p-1">
                            <span class="input-group-text border-0 bg-white ms-2"><i class="fas fa-search text-muted"></i></span>
                            <input type="text" id="dojoSearch" class="form-control border-0 bg-white" placeholder="Search by academy name or location (e.g., Ernakulam, Palakkad)...">
                        </div>
                    </div>
                </div>

                <div class="row g-4" id="dojoGrid">
                    <c:forEach var="center" items="${centers}">
                        <div class="col-md-4 center-card-item" data-name="${center.name}" data-location="${center.location}">
                            <div class="center-card">
                                <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="center-img" alt="${center.name}" onerror="this.src='${pageContext.request.contextPath}/beauty/images/centres.jpg'">
                                <div class="p-4 flex-grow-1 d-flex flex-column">
                                    <h5 class="fw-bold text-dark mb-2">${center.name}</h5>
                                    <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt text-primary me-2"></i>${center.location}</p>
                                    <p class="text-muted small mb-3 flex-grow-1">
                                        <strong>Styles:</strong>
                                        <c:forEach var="type" items="${center.martialArtsTypes}">
                                            ${type.name}<c:if test="${!type.equals(center.martialArtsTypes[center.martialArtsTypes.size()-1])}">, </c:if>
                                        </c:forEach>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/centres/details/${center.id}" class="center-btn text-center text-decoration-none mt-auto">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty centers}">
                        <div class="col-12 text-center py-5">
                            <p class="text-muted">No centers currently listed.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Tab 2: User Overview & Enrollments -->
            <div class="tab-pane fade" id="overview" role="tabpanel">
                
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
                    <!-- Dynamic client side data will load here -->
                    <div class="col-12 text-center py-5" id="loadingState">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-3 text-muted">Retrieving your training status...</p>
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
        });

        // Dynamic Enrollments Loader
        const userId = '${user.id}';
        
        // Fallback or explicit check
        const targetUrl = userId ? '${pageContext.request.contextPath}/enrollment/getUserEnrollmentsJson/' + userId : '${pageContext.request.contextPath}/enrollment/getUserEnrollmentsJson/1';
        
        fetch(targetUrl)
            .then(res => res.json())
            .then(data => {
                const grid = document.getElementById('enrollmentGrid');
                const loading = document.getElementById('loadingState');
                loading.style.display = 'none';

                if (data && data.length > 0) {
                    document.getElementById('enrolledCount').innerText = data.length;
                    
                    let inProgress = 0;
                    let completed = 0;
                    let htmlContent = '';

                    data.forEach(enroll => {
                        if (enroll.status === 'COMPLETED' || enroll.status === 'Completed') {
                            completed++;
                        } else {
                            inProgress++;
                        }

                        const badgeClass = (enroll.status === 'COMPLETED' || enroll.status === 'Completed') ? 'bg-success' : 
                                         (enroll.status === 'IN_PROGRESS' || enroll.status === 'In Progress') ? 'bg-primary' : 'bg-warning text-dark';

                        htmlContent += '<div class="col-md-6" data-aos="zoom-in">' +
                            '<div class="enrollment-card">' +
                                '<div class="enrollment-header d-flex justify-content-between align-items-center">' +
                                    '<span>' + enroll.martialArtsType + '</span>' +
                                    '<span class="badge ' + badgeClass + '">' + enroll.status + '</span>' +
                                '</div>' +
                                '<div class="p-4">' +
                                    '<h5 class="fw-bold mb-2 text-dark">' + enroll.centerName + '</h5>' +
                                    '<p class="text-muted mb-2"><i class="fas fa-clock text-primary me-2"></i>Slot: ' + enroll.slot + '</p>' +
                                    '<div class="mt-3">';
                        
                        if (enroll.status === 'COMPLETED' || enroll.status === 'Completed') {
                            htmlContent += '<a href="${pageContext.request.contextPath}/enrollment/downloadCertificate/' + enroll.id + '" class="btn btn-sm btn-success rounded-pill px-3"><i class="fas fa-download me-2"></i>Download Certificate</a>';
                        } else {
                            htmlContent += '<button class="btn btn-sm btn-outline-secondary rounded-pill px-3" disabled><i class="fas fa-hourglass-half me-2"></i>Training ongoing</button>';
                        }

                        htmlContent += '</div></div></div></div>';
                    });

                    document.getElementById('progressCount').innerText = inProgress;
                    document.getElementById('completedCount').innerText = completed;
                    grid.innerHTML = htmlContent;

                } else {
                    grid.innerHTML = '<div class="col-12 text-center py-5">' +
                        '<div class="text-muted fs-4 mb-3"><i class="fas fa-feather fs-1 text-primary"></i></div>' +
                        '<p class="text-muted">You are not enrolled in any programs yet.</p>' +
                        '<button class="btn btn-primary rounded-pill px-4 mt-2" onclick="document.getElementById(\'explore-tab\').click()">Enroll in a Dojo</button>' +
                    '</div>';
                }
            })
            .catch(err => {
                console.error('Error fetching enrollments:', err);
                const loading = document.getElementById('loadingState');
                if(loading) loading.style.display = 'none';
                
                // Optional fallback to default static view
                const grid = document.getElementById('enrollmentGrid');
                grid.innerHTML = '<div class="col-12 text-center py-5"><p class="text-muted">No enrollments recorded for this account.</p></div>';
            });
    </script>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    </div>
</div>
</body>
</html>

