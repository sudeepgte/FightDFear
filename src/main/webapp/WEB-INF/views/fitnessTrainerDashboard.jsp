<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trainer Studio - Dashboard</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --primary-purple: #1e1b4b; 
            --primary-purple-light: #312e81; 
            --primary-coral: #f43f5e; 
            --primary-teal: #20c997;
            --primary-gold: #ffd700;
            --light-bg: #f4f6fa;
            --shadow-sm: 0 4px 15px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 10px 30px rgba(0, 0, 0, 0.08);
            --sidebar-text: rgba(255, 255, 255, 0.7);
        }

        body {
            background: var(--light-bg);
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
            color: #1a1a2e;
            padding-top: 0;
        }

        /* === Sidebar Layout CSS === */
        #wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        
        #sidebar-wrapper {
            min-width: 195px;
            max-width: 195px;
            background: var(--primary-purple);
            color: white;
            transition: all 0.3s ease-in-out;
            min-height: 100vh;
            z-index: 1000;
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            border-top-right-radius: 0;
            padding-top: 0;
            padding-bottom: 30px;
            box-shadow: 4px 0 15px rgba(0,0,0,0.08);
        }
        
        #sidebar-wrapper::-webkit-scrollbar { width: 4px; }
        #sidebar-wrapper::-webkit-scrollbar-thumb { background-color: var(--primary-purple-light); border-radius: 10px; }
        
        .sidebar-heading {
            padding: 16px 18px 14px;
            font-size: 1rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 6px;
        }
        
        .list-group-item {
            background: transparent;
            color: var(--sidebar-text);
            border: none;
            padding: 10px 18px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
            text-decoration: none;
            cursor: pointer;
            width: 100%;
            text-align: left;
        }
        .list-group-item i { font-size: 1rem; width: 18px; text-align: center; }
        .list-group-item:hover, .list-group-item.active {
            color: white;
            background: transparent;
        }
        .list-group-item:hover::before, .list-group-item.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            height: 70%;
            width: 4px;
            background: var(--primary-coral);
            border-radius: 0 4px 4px 0;
        }

        #page-content-wrapper {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
            padding: 20px 24px;
            margin-left: 195px;
        }
        
        .dashboard-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .dashboard-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-purple);
            margin: 0;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .logout-btn {
            background: var(--primary-coral);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }
        .logout-btn:hover { background: #e11d48; color: white; transform: translateY(-2px); }

        .dashboard-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        /* Stat cards — premium gradient redesign */
        .stat-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }
        .stat-card-new {
            border-radius: 20px;
            padding: 22px 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 12px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(0,0,0,0.10);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            min-height: 130px;
            color: white;
        }
        .stat-card-new:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 36px rgba(0,0,0,0.14);
        }
        /* Decorative circle behind icon */
        .stat-card-new::before {
            content: '';
            position: absolute;
            right: -18px;
            top: -18px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255,255,255,0.12);
        }
        .stat-card-new::after {
            content: '';
            position: absolute;
            right: 14px;
            bottom: -24px;
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: rgba(255,255,255,0.07);
        }
        /* Card colour themes */
        .stat-card-teal  { background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); }
        .stat-card-blue  { background: linear-gradient(135deg, #6366f1 0%, #3b82f6 100%); }
        .stat-card-coral { background: linear-gradient(135deg, #f43f5e 0%, #f97316 100%); }
        .stat-card-label {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.82;
        }
        .stat-card-value {
            font-size: 2rem;
            font-weight: 800;
            line-height: 1;
            letter-spacing: -0.5px;
        }
        .stat-card-icon {
            font-size: 1.6rem;
            opacity: 0.92;
            position: relative;
            z-index: 1;
        }
        .stat-card-footer {
            font-size: 0.72rem;
            opacity: 0.75;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Workspace Panels */
        .panel-new {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(0,0,0,0.02);
        }

        /* Lists & Forms */
        .list-item-box {
            border: 1.5px solid #f5f0f8;
            border-radius: 16px;
            padding: 18px;
            margin-bottom: 16px;
            transition: all 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .list-item-box:hover { border-color: #d1d5db; }
        .btn-action { font-size: 0.85rem; font-weight: 600; border-radius: 20px; padding: 6px 20px; }
        .form-label { font-weight: 600; font-size: 0.85rem; color: #555; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .form-control, .form-select { border-radius: 12px; border: 1.5px solid #e2e8f0; padding: 12px; font-size: 0.95rem; }
        .form-control:focus, .form-select:focus { border-color: var(--primary-teal); box-shadow: 0 0 0 3px rgba(32,201,151,0.15); }
        .btn-submit { background: linear-gradient(135deg, var(--primary-teal), #10b981); color: white; border: none; border-radius: 12px; font-weight: 700; padding: 12px; transition: all 0.2s; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(16,185,129,0.3); color: white; }
        
        @media (max-width: 1200px) {
            #wrapper {
                flex-direction: column;
            }
            #sidebar-wrapper {
                min-width: 100%;
                max-width: 100%;
                height: auto;
                min-height: auto;
                position: relative;
                top: 0;
                left: 0;
                border-top-right-radius: 0;
                border-bottom-left-radius: 30px;
                border-bottom-right-radius: 30px;
                padding-bottom: 20px;
            }
            #studioTab {
                flex-direction: row !important;
                flex-wrap: wrap;
                gap: 8px;
                padding: 10px 15px;
            }
            #studioTab .list-group-item {
                width: auto !important;
                padding: 8px 16px;
                border-radius: 20px;
                background: rgba(255,255,255,0.05);
                white-space: nowrap;
                display: inline-flex;
            }
            #studioTab .list-group-item::before {
                display: none !important;
            }
            #studioTab .list-group-item.active {
                background: var(--primary-coral);
                color: white;
            }
            #page-content-wrapper {
                padding: 16px 12px;
                margin-left: 0;
            }
            .dashboard-header-flex {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            .header-actions {
                width: 100%;
                justify-content: flex-end;
            }
        }
        @media (max-width: 768px) {
            .tab-pane#messagesContent .row {
                height: 800px !important;
                flex-direction: column;
            }
            .tab-pane#messagesContent .col-md-4 {
                height: 250px !important;
                border-bottom: 1px solid #dee2e6;
                border-right: none !important;
            }
            .tab-pane#messagesContent .col-md-8 {
                height: 550px !important;
            }
        }
    </style>
</head>
<body>

<%-- Hide the global header navbar for this page --%>
<div style="display:none; visibility:hidden;">
<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>
</div>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading" style="flex-direction:column; align-items:flex-start; gap:2px; padding:14px 18px 12px;">
            <div style="display:flex; align-items:center; gap:8px;">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 24px; width: 24px; border-radius: 6px; object-fit: cover;">
                <span style="font-size:0.92rem; font-weight:700;">Coach Studio</span>
            </div>
            <div style="font-size:0.78rem; color:rgba(255,255,255,0.55); padding-left:32px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:160px;">${trainer.fullName}</div>
        </div>
        <div class="nav flex-column nav-pills" id="studioTab">
            <button class="list-group-item active" onclick="switchTab('requestsContent', this)" type="button">
                <i class="bi bi-inbox-fill" style="color:rgba(255,255,255,0.75);"></i> Booking Requests <span class="badge ms-auto rounded-pill" style="background:rgba(255,255,255,0.2); font-size:0.7rem;">${requests.size()}</span>
            </button>
            <button class="list-group-item" onclick="switchTab('activeContent', this)" type="button">
                <i class="bi bi-calendar3" style="color:rgba(255,255,255,0.75);"></i> Upcoming Sessions <span class="badge ms-auto rounded-pill" style="background:rgba(255,255,255,0.2); font-size:0.7rem;">${activeBookings.size()}</span>
            </button>
            <button class="list-group-item" onclick="switchTab('classesContent', this)" type="button">
                <i class="bi bi-grid-1x2" style="color:rgba(255,255,255,0.75);"></i> Manage Classes
            </button>
            <button class="list-group-item" onclick="switchTab('packagesContent', this)" type="button">
                <i class="bi bi-tag-fill" style="color:rgba(255,255,255,0.75);"></i> Packages &amp; Plans <span class="badge ms-auto rounded-pill" style="background:rgba(255,255,255,0.2); font-size:0.7rem;">${packages.size()}</span>
            </button>
            <button class="list-group-item" onclick="switchTab('attendanceContent', this)" type="button">
                <i class="bi bi-clipboard-check-fill" style="color:rgba(255,255,255,0.75);"></i> Attendance &amp; Roster
            </button>
            <button class="list-group-item" onclick="switchTab('progressContent', this)" type="button">
                <i class="bi bi-activity" style="color:rgba(255,255,255,0.75);"></i> Client Progress
            </button>
            <button class="list-group-item" onclick="switchTab('completedContent', this)" type="button">
                <i class="bi bi-check2-square" style="color:rgba(255,255,255,0.75);"></i> Completed Classes
            </button>
            <button class="list-group-item" onclick="switchTab('messagesContent', this)" type="button">
                <i class="bi bi-chat-square-text" style="color:rgba(255,255,255,0.75);"></i> Messages
            </button>
            <button class="list-group-item" onclick="switchTab('scheduleContent', this)" type="button">
                <i class="bi bi-sliders" style="color:rgba(255,255,255,0.75);"></i> Settings &amp; Fees
            </button>
            <button class="list-group-item" onclick="switchTab('reviewsContent', this)" type="button">
                <i class="bi bi-bar-chart-line" style="color:rgba(255,255,255,0.75);"></i> Feedback Ratings
            </button>
            <button class="list-group-item" onclick="switchTab('editProfileContent', this)" type="button">
                <i class="bi bi-person-lines-fill" style="color:rgba(255,255,255,0.75);"></i> Edit Profile
            </button>
            <a href="${pageContext.request.contextPath}/" class="list-group-item" type="button">
                <i class="bi bi-chevron-left" style="color:rgba(255,255,255,0.75);"></i> Back to Home
            </a>

            <a href="${pageContext.request.contextPath}/fitness/trainer/logout" class="list-group-item" style="color:rgba(255,100,100,0.85);" type="button">
                <i class="bi bi-power" style="color:rgba(255,100,100,0.85);"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="dashboard-header-flex" style="justify-content:center; text-align:center; flex-direction:column; align-items:center; gap:8px; margin-bottom:20px;">
            <div class="d-flex flex-column align-items-center">
                <c:if test="${not empty trainer.profilePhotoPath}">
                    <img src="${trainer.profilePhotoPath}" alt="Trainer Profile" style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover; margin-bottom:10px;" class="shadow-sm">
                </c:if>
                <c:if test="${empty trainer.profilePhotoPath}">
                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 60px; height: 60px; font-size: 1.5rem; margin-bottom:10px;">
                        <i class="bi bi-person-fill"></i>
                    </div>
                </c:if>
                <div style="font-size:0.72rem; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#94a3b8; margin-bottom:2px;">Trainer Profile</div>
                <h1 class="dashboard-title" style="text-align:center;">Welcome back, ${trainer.fullName}</h1>
                <p class="text-muted small mt-1 mb-0" style="text-align:center;">Manage your schedule, classes, and coaching requests.</p>
            </div>
        </div>

        <c:if test="${trainer.verificationStatus != 'VERIFIED' && trainer.partnerProfileStatus != 'APPROVED'}">
            <div class="alert alert-warning d-flex align-items-center justify-content-between p-3 mb-4 rounded-4 shadow-sm" style="background:#FFFBEB; border: 1px solid #FCD34D;">
                <div>
                    <h5 class="fw-bold text-dark mb-1"><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Trainer Profile Verification Pending</h5>
                    <p class="mb-0 text-muted" style="font-size:0.9rem;">Your trainer account is awaiting admin verification. Class & workout creation is locked until verified.</p>
                </div>
                <a href="${pageContext.request.contextPath}/fitness/trainer/profile-completion" class="btn btn-warning fw-bold text-dark px-4 rounded-pill shadow-sm" style="white-space:nowrap;">Complete Profile <i class="bi bi-arrow-right ms-1"></i></a>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show mb-4" style="border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <i class="bi bi-check-circle-fill me-2"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4" style="border-radius: 12px;">${error}</div>
        </c:if>

        <div class="dashboard-container">
            <!-- Analytics overview cards -->
            <div class="stat-cards-grid">

                <!-- Earnings Card -->
                <div class="stat-card-new stat-card-teal">
                    <div class="d-flex justify-content-between align-items-flex-start">
                        <div class="stat-card-label">Accumulated Earnings</div>
                        <i class="bi bi-wallet2 stat-card-icon"></i>
                    </div>
                    <div class="stat-card-value">₹${totalEarnings}</div>
                    <div class="stat-card-footer">
                        <i class="bi bi-arrow-up-circle-fill"></i> Total lifetime payouts
                    </div>
                </div>

                <!-- Active Sessions Card -->
                <div class="stat-card-new stat-card-blue">
                    <div class="d-flex justify-content-between align-items-flex-start">
                        <div class="stat-card-label">Active Classes Scheduled</div>
                        <i class="bi bi-calendar-check stat-card-icon"></i>
                    </div>
                    <div class="stat-card-value">${activeBookings.size()}</div>
                    <div class="stat-card-footer">
                        <i class="bi bi-clock-history"></i> Currently active bookings
                    </div>
                </div>

                <!-- Reviews Card -->
                <div class="stat-card-new stat-card-coral">
                    <div class="d-flex justify-content-between align-items-flex-start">
                        <div class="stat-card-label">Coaching Reviews</div>
                        <i class="bi bi-star-fill stat-card-icon"></i>
                    </div>
                    <div class="stat-card-value">${reviews.size()}</div>
                    <div class="stat-card-footer">
                        <i class="bi bi-chat-left-heart-fill"></i> Client feedback received
                    </div>
                </div>

            </div>

            <!-- Content Area -->
            <div class="panel-new" id="studioTabContent">
                
                <!-- BOOKING REQUESTS -->
                <div class="tab-section" id="requestsContent" style="display:block;">
                    <h4 class="fw-bold mb-4 text-dark">Booking Requests</h4>
                    
                    <c:choose>
                        <c:when test="${empty requests}">
                            <div class="text-center py-5">
                                <i class="bi bi-inbox text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No pending booking requests currently.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${requests}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div>
                                        <h6 class="fw-bold mb-1">${r.user.fullName}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="badge bg-light border text-dark">${r.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-laptop me-1"></i> ${r.sessionType}</span>
                                        </div>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-event text-primary me-1"></i> ${r.bookingDate} @ ${r.bookingTime}</span>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${r.id}">
                                            <input type="hidden" name="action" value="APPROVE">
                                            <button type="submit" class="btn btn-success btn-action"><i class="bi bi-check-lg me-1"></i> Accept</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${r.id}">
                                            <input type="hidden" name="action" value="REJECT">
                                            <button type="submit" class="btn btn-outline-danger btn-action"><i class="bi bi-x-lg me-1"></i> Reject</button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- UPCOMING SESSIONS -->
                <div class="tab-section" id="activeContent" style="display:none;">
                    <h4 class="fw-bold mb-4 text-dark">Upcoming Coaching Classes</h4>
                    
                    <c:choose>
                        <c:when test="${empty activeBookings}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No upcoming scheduled classes currently.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${activeBookings}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div style="flex:1; min-width:250px;">
                                        <h6 class="fw-bold mb-1">${b.user.fullName}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">${b.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-broadcast me-1"></i> ${b.sessionType}</span>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">
                                                <c:choose>
                                                    <c:when test="${b.duration == 'SINGLE'}">Single Session</c:when>
                                                    <c:when test="${b.duration == 'MONTHLY'}">Monthly Package</c:when>
                                                    <c:when test="${b.duration == 'QUARTERLY'}">Quarterly Package</c:when>
                                                    <c:when test="${b.duration == 'HALF_YEAR'}">6 Months Package</c:when>
                                                    <c:when test="${b.duration == 'YEAR'}">1 Year Package</c:when>
                                                    <c:otherwise>Active Plan</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-muted small fw-medium mb-2"><i class="bi bi-calendar-check text-primary me-1"></i> Validity: ${b.startDate} to ${b.endDate} @ ${b.bookingTime}</div>
                                        
                                        <c:set var="pct" value="0" />
                                        <c:if test="${b.totalSessions > 0}">
                                            <c:set var="pct" value="${(b.completedSessions * 100) / b.totalSessions}" />
                                        </c:if>
                                        <div class="w-100" style="max-width:350px;">
                                            <div class="d-flex justify-content-between mb-1 small text-muted">
                                                <span>Progress</span>
                                                <span>${b.completedSessions} / ${b.totalSessions} Sessions</span>
                                            </div>
                                            <div class="progress" style="height: 6px; border-radius: 3px;">
                                                <div class="progress-bar bg-success" role="progressbar" style="width: ${pct}%" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="${pageContext.request.contextPath}/fitness/trainer/booking/status" method="POST">
                                            <input type="hidden" name="bookingId" value="${b.id}">
                                            <input type="hidden" name="action" value="COMPLETE">
                                            <button type="submit" class="btn btn-primary btn-action">
                                                <c:choose>
                                                    <c:when test="${b.totalSessions > 1}">
                                                        <i class="bi bi-check2-circle me-1"></i> Log Attended Session
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-check2-circle me-1"></i> Mark Completed
                                                    </c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- COMPLETED CLASSES -->
                <div class="tab-section" id="completedContent" style="display:none;">
                    <h4 class="fw-bold mb-4 text-dark">Completed Session Logs</h4>
                    
                    <c:choose>
                        <c:when test="${empty completed}">
                            <div class="text-center py-5">
                                <i class="bi bi-journal-x text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No historical completed classes.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${completed}">
                                <div class="list-item-box d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-bold mb-1">${b.user.fullName}</h6>
                                        <span class="badge bg-light border text-dark me-2">${b.category}</span>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-event text-secondary me-1"></i> ${b.bookingDate}</span>
                                    </div>
                                    <div>
                                        <span class="badge bg-success px-3 py-2" style="font-size:0.85rem;"><i class="bi bi-check-lg me-1"></i> +₹${b.paymentAmount}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- MANAGE GROUP CLASSES -->
                <div class="tab-section" id="classesContent" style="display:none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark mb-0">Scheduled Group Classes</h4>
                        <button class="btn btn-submit btn-sm px-3" data-bs-toggle="modal" data-bs-target="#createClassModal"><i class="bi bi-plus-lg"></i> New Class</button>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty trainerClasses}">
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-event text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No scheduled group classes yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="fc" items="${trainerClasses}">
                                <div class="list-item-box d-flex justify-content-between align-items-center flex-wrap gap-3">
                                    <div>
                                        <h6 class="fw-bold mb-1">${fc.className}</h6>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25">${fc.category}</span>
                                            <span class="badge bg-light border text-dark"><i class="bi bi-clock me-1"></i> ${fc.durationMinutes} mins</span>
                                            <span class="badge ${fc.currentEnrollment >= fc.maxCapacity ? 'bg-danger' : 'bg-success'} text-white px-2 rounded-pill small">${fc.currentEnrollment} / ${fc.maxCapacity} Enrolled</span>
                                        </div>
                                        <span class="text-muted small fw-medium"><i class="bi bi-calendar-check text-primary me-1"></i> ${fc.classDate} @ ${fc.formattedClassTime}</span>
                                    </div>
                                    <div class="fw-bold text-success fs-5 d-flex flex-column align-items-end gap-2">
                                        <div>₹${fc.price}</div>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-sm btn-outline-primary edit-class-btn"
                                                    data-id="${fc.id}"
                                                    data-name="${fc.className}"
                                                    data-category="${fc.category}"
                                                    data-description="${fc.description}"
                                                    data-date="${fc.classDate}"
                                                    data-time="${fc.classTime}"
                                                    data-duration="${fc.durationMinutes}"
                                                    data-type="${fc.sessionType}"
                                                    data-capacity="${fc.maxCapacity}"
                                                    data-price="${fc.price}"
                                                    data-location="${fc.meetingLinkOrLocation}"
                                                    style="border-radius: 20px; font-size: 0.8rem; font-weight:600; padding:4px 12px;">
                                                <i class="bi bi-pencil-fill"></i> Edit
                                            </button>
                                            <form action="${pageContext.request.contextPath}/fitness/trainer/class/delete" method="POST" onsubmit="return confirm('Are you sure you want to delete this class? This will refund all enrolled students.');" class="m-0">
                                                <input type="hidden" name="classId" value="${fc.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" style="border-radius: 20px; font-size: 0.8rem; font-weight:600; padding:4px 12px;">
                                                    <i class="bi bi-trash-fill"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Embedded Attendees List -->
                                <div class="bg-light p-3 rounded-bottom-4 border border-top-0 mt-[-10px] mb-4">
                                    <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-people-fill text-primary me-2"></i> Registered Attendees</h6>
                                    <c:set var="attendees" value="${classAttendees[fc.id]}" />
                                    <c:choose>
                                        <c:when test="${empty attendees}">
                                            <p class="text-muted small mb-0 fw-medium"><i class="bi bi-info-circle me-1"></i> No one has registered for this class yet.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive bg-white border rounded-3 p-2">
                                                <table class="table table-sm table-borderless align-middle mb-0">
                                                    <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                                        <tr>
                                                            <th class="ps-3">Student Name</th>
                                                            <th>Email Address</th>
                                                            <th>Phone Number</th>
                                                            <th>Payment Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody style="font-size: 0.9rem;">
                                                        <c:forEach var="booking" items="${attendees}">
                                                            <tr style="border-bottom: 1px solid #f8f9fa;">
                                                                <td class="fw-bold text-dark ps-3 py-2">
                                                                    <i class="bi bi-person-circle text-secondary me-2 fs-5 align-middle"></i>${booking.user.fullName}
                                                                </td>
                                                                <td class="text-muted">${booking.user.email}</td>
                                                                <td class="text-muted">${booking.user.phoneNumber != null ? booking.user.phoneNumber : '<span class="text-white-50">N/A</span>'}</td>
                                                                <td><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1"><i class="bi bi-check-circle-fill me-1"></i> Paid</span></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- PACKAGES & MEMBERSHIP PLANS -->
                <div class="tab-section" id="packagesContent" style="display:none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Fitness Packages &amp; Membership Plans</h4>
                            <p class="text-muted small mb-0">Create recurring class passes and multi-session membership tiers for your clients.</p>
                        </div>
                        <button class="btn btn-submit btn-sm px-3" data-bs-toggle="modal" data-bs-target="#createPackageModal">
                            <i class="bi bi-plus-lg me-1"></i> New Package
                        </button>
                    </div>

                    <c:choose>
                        <c:when test="${empty packages}">
                            <div class="text-center py-5">
                                <i class="bi bi-tag text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No membership packages created yet. Click "New Package" to offer passes to clients.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row g-3">
                                <c:forEach var="pkg" items="${packages}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="card h-100 border-0 shadow-sm rounded-4 p-4 position-relative" style="background:#fff;">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <span class="badge ${pkg.active ? 'bg-success' : 'bg-secondary'} bg-opacity-10 text-${pkg.active ? 'success' : 'secondary'} border border-${pkg.active ? 'success' : 'secondary'} border-opacity-25 px-2 py-1 rounded-pill small">
                                                    ${pkg.active ? 'Active' : 'Inactive'}
                                                </span>
                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25">${pkg.sessionType}</span>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-1">${pkg.packageName}</h5>
                                            <span class="badge bg-light text-muted border mb-2 align-self-start">${pkg.category}</span>
                                            <p class="text-muted small mb-3 flex-grow-1">${pkg.description != null && !pkg.description.isEmpty() ? pkg.description : 'Standard training package'}</p>
                                            
                                            <div class="d-flex justify-content-between align-items-center border-top pt-3 mt-auto">
                                                <div>
                                                    <div class="fw-bold text-dark fs-5">₹${pkg.price}</div>
                                                    <div class="text-muted small">${pkg.sessionCount == 0 ? 'Unlimited' : pkg.sessionCount} Sessions &bull; ${pkg.durationDays} Days</div>
                                                </div>
                                                <div class="d-flex gap-2">
                                                    <form action="${pageContext.request.contextPath}/fitness/trainer/package/toggle/${pkg.id}" method="POST" class="m-0">
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary rounded-pill" title="Toggle Active">
                                                            <i class="bi bi-power"></i>
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/fitness/trainer/package/delete/${pkg.id}" method="POST" onsubmit="return confirm('Delete this package?');" class="m-0">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Package">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- ATTENDANCE & ROSTER -->
                <div class="tab-section" id="attendanceContent" style="display:none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Session Attendance &amp; Client Roster</h4>
                            <p class="text-muted small mb-0">Record date-by-date student check-ins and track remaining pass sessions.</p>
                        </div>
                    </div>

                    <!-- Client Roster Table -->
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-people-fill text-primary me-2"></i> Active Trainees</h6>
                    <c:choose>
                        <c:when test="${empty activeBookings}">
                            <div class="text-center py-4 bg-light rounded-4 mb-4">
                                <p class="text-muted mb-0 fw-medium">No active student bookings to take attendance for.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive bg-white border rounded-4 p-3 shadow-sm mb-5">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                        <tr>
                                            <th>Client Name</th>
                                            <th>Program / Category</th>
                                            <th>Session Usage</th>
                                            <th>Time Slot</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="b" items="${activeBookings}">
                                            <tr>
                                                <td class="fw-bold text-dark">
                                                    <i class="bi bi-person-circle text-secondary me-2 fs-5"></i>${b.user.fullName}
                                                </td>
                                                <td><span class="badge bg-light border text-dark">${b.category}</span></td>
                                                <td>
                                                    <div class="small fw-bold text-dark mb-1">${b.completedSessions} / ${b.totalSessions} attended</div>
                                                    <div class="progress" style="height: 5px; width: 140px;">
                                                        <div class="progress-bar bg-success" style="width: ${(b.completedSessions * 100) / (b.totalSessions > 0 ? b.totalSessions : 1)}%"></div>
                                                    </div>
                                                </td>
                                                <td class="text-muted small">${b.bookingTime}</td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary rounded-pill px-3"
                                                            onclick="openAttendanceModal(${b.id}, '${b.user.fullName}', '${b.bookingTime}')">
                                                        <i class="bi bi-check2-circle me-1"></i> Check In
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Recent Check-In History -->
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-clock-history text-secondary me-2"></i> Recent Attendance Logs</h6>
                    <c:choose>
                        <c:when test="${empty attendanceList}">
                            <div class="text-center py-4 bg-light rounded-4">
                                <p class="text-muted mb-0 fw-medium">No check-in attendance logs recorded yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive bg-white border rounded-4 p-3 shadow-sm">
                                <table class="table table-sm table-borderless align-middle mb-0">
                                    <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                        <tr>
                                            <th>Date</th>
                                            <th>Client Name</th>
                                            <th>Session Time</th>
                                            <th>Status</th>
                                            <th>Coach Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody style="font-size: 0.9rem;">
                                        <c:forEach var="att" items="${attendanceList}">
                                            <tr style="border-bottom: 1px solid #f8f9fa;">
                                                <td class="fw-medium text-dark">${att.sessionDate}</td>
                                                <td class="fw-bold text-dark">${att.user.fullName}</td>
                                                <td class="text-muted">${att.sessionTime}</td>
                                                <td>
                                                    <span class="badge ${att.status == 'PRESENT' ? 'bg-success' : (att.status == 'LATE' ? 'bg-warning text-dark' : 'bg-danger')} bg-opacity-10 text-${att.status == 'PRESENT' ? 'success' : (att.status == 'LATE' ? 'warning' : 'danger')} border px-2 py-1">
                                                        ${att.status}
                                                    </span>
                                                </td>
                                                <td class="text-muted small">${att.notes != null ? att.notes : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- CLIENT PROGRESS TRACKER -->
                <div class="tab-section" id="progressContent" style="display:none;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="fw-bold text-dark mb-1">Client Fitness Progress &amp; Milestone Logs</h4>
                            <p class="text-muted small mb-0">Record authentic body metric changes and fitness capability assessments for enrolled clients.</p>
                        </div>
                        <button class="btn btn-submit btn-sm px-3" data-bs-toggle="modal" data-bs-target="#logProgressModal">
                            <i class="bi bi-plus-lg me-1"></i> Log Client Metric
                        </button>
                    </div>

                    <c:choose>
                        <c:when test="${empty progressLogs}">
                            <div class="text-center py-5 bg-white border rounded-4 shadow-sm">
                                <i class="bi bi-activity text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No client fitness milestones logged yet. Click "Log Client Metric" to add evaluation data.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive bg-white border rounded-4 p-3 shadow-sm">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="text-muted" style="font-size: 0.85rem; border-bottom: 1px solid #eee;">
                                        <tr>
                                            <th>Date</th>
                                            <th>Client</th>
                                            <th>Weight</th>
                                            <th>Body Fat</th>
                                            <th>Workouts Completed</th>
                                            <th>Capabilities Radar</th>
                                            <th>Workout Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${progressLogs}">
                                            <tr>
                                                <td class="fw-medium text-dark">${log.logDate}</td>
                                                <td class="fw-bold text-dark">${log.user.fullName}</td>
                                                <td><span class="badge bg-light border text-dark">${log.weightKg != null ? log.weightKg : '—'} kg</span></td>
                                                <td><span class="badge bg-light border text-dark">${log.bodyFatPct != null ? log.bodyFatPct : '—'}%</span></td>
                                                <td><span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">${log.workoutsCompleted} Sessions</span></td>
                                                <td class="small text-muted">${log.metricsJson != null ? log.metricsJson : 'General Assessment'}</td>
                                                <td class="small text-muted">${log.workoutNotes != null ? log.workoutNotes : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- SCHEDULE & CONFIG -->
                <div class="tab-section" id="scheduleContent" style="display:none;">
                    <h4 class="fw-bold mb-4 text-dark">Schedule &amp; Fees Configuration</h4>

                    
                    <form action="${pageContext.request.contextPath}/fitness/trainer/update-schedule" method="POST">
                        <div class="mb-4">
                            <label class="form-label">Session Fees (₹ per Class)</label>
                            <input type="number" name="sessionFees" class="form-control" value="${trainer.sessionFees}" min="0" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Available Hours</label>
                            <input type="text" name="availableTimings" class="form-control" value="${trainer.availableTimings}" required>
                            <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Example: "09:00 - 13:00, 16:00 - 20:00"</div>
                        </div>

                        <div class="mb-5">
                            <label class="form-label">Coaching Specialties</label>
                            <select name="specializations" class="form-select" multiple required style="height: 180px;">
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${trainer.specializations.contains(cat) ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                            <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> Hold Ctrl/Cmd to select multiple categories.</div>
                        </div>

                        <button type="submit" class="btn btn-submit w-100"><i class="bi bi-save2-fill me-1"></i> Save Configuration</button>
                    </form>
                </div>

                <!-- RATINGS FEEDBACK -->
                <div class="tab-section" id="reviewsContent" style="display:none;">
                    <h4 class="fw-bold mb-4 text-dark">Client Feedback & Ratings</h4>
                    
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <div class="text-center py-5">
                                <i class="bi bi-star text-muted" style="font-size:3rem; opacity:0.5;"></i>
                                <p class="text-muted mt-3 fw-medium">No client reviews submitted yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reviews}">
                                <div class="list-item-box bg-light border-0">
                                    <div class="d-flex justify-content-between mb-2">
                                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-person-circle text-secondary me-2"></i>${r.booking.user.fullName}</h6>
                                        <span class="text-warning small">
                                            <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                        </span>
                                    </div>
                                    <p class="text-muted small mb-0 ps-4">"${r.comment}"</p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- MESSAGES -->
                <div class="tab-section" id="messagesContent" style="display:none;">
                    <h4 class="fw-bold mb-4 text-dark"><i class="bi bi-chat-dots text-danger me-2"></i> Client Messages</h4>
                    <div class="row g-0 border rounded-4 overflow-hidden bg-white shadow-sm" style="height: calc(100vh - 220px); min-height: 500px;">
                        <!-- Contacts List -->
                        <div class="col-md-3 border-end bg-light overflow-auto h-100">
                            <div class="p-3 border-bottom bg-white sticky-top z-2 shadow-sm">
                                <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-people-fill text-primary me-2"></i> Your Clients</h6>
                            </div>
                            <c:choose>
                                <c:when test="${empty chatUsers}">
                                    <div class="p-5 text-center text-muted">
                                        <i class="bi bi-person-x opacity-25" style="font-size: 3rem;"></i>
                                        <p class="small mt-2 fw-medium">No clients available to chat yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="list-group list-group-flush" id="chatContactList">
                                        <c:forEach var="u" items="${chatUsers}">
                                            <button class="list-group-item list-group-item-action d-flex align-items-center gap-3 p-3 chat-contact-btn border-bottom" 
                                                    onclick="loadChat(${u.id}, ${trainer.id}, '${u.fullName}')">
                                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; min-width: 45px;">
                                                    <i class="bi bi-person-fill fs-5"></i>
                                                </div>
                                                <div class="text-truncate">
                                                    <h6 class="mb-1 fw-bold text-dark">${u.fullName}</h6>
                                                    <small class="text-muted text-truncate d-block"><i class="bi bi-envelope me-1"></i>${u.email}</small>
                                                </div>
                                            </button>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Chat Box -->
                        <div class="col-md-9 d-flex flex-column h-100 position-relative bg-white" id="chatBoxArea">
                            <!-- Empty State -->
                            <div class="d-flex flex-column align-items-center justify-content-center h-100 text-muted" id="chatEmptyState">
                                <i class="bi bi-chat-heart text-light" style="font-size: 6rem;"></i>
                                <h5 class="mt-3 fw-bold text-secondary">Your Messages</h5>
                                <p class="fw-medium">Select a client from the left to start chatting</p>
                            </div>
                            
                            <!-- Active Chat -->
                            <div id="activeChatArea" class="d-none flex-column h-100">
                                <!-- Chat Header -->
                                <div class="p-3 border-bottom bg-white d-flex align-items-center gap-3 shadow-sm z-1">
                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-5"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-0 fw-bold text-dark" id="chatUserName">Client Name</h5>
                                        <small class="text-success fw-medium"><i class="bi bi-circle-fill text-success" style="font-size:0.5rem; vertical-align: middle;"></i> Connected</small>
                                    </div>
                                </div>
                                
                                <!-- Chat Messages -->
                                <div class="flex-grow-1 p-4 overflow-auto" id="chatMessages" style="background-color: #f0f2f5;">
                                    <!-- Messages loaded via JS -->
                                </div>
                                
                                <!-- Chat Input -->
                                <div class="p-3 border-top bg-white">
                                    <form id="chatForm" onsubmit="sendMessage(event)" class="d-flex gap-2">
                                        <input type="hidden" id="chatUserId">
                                        <input type="hidden" id="chatTrainerId" value="${trainer.id}">
                                        <input type="text" id="chatInput" class="form-control rounded-pill bg-light border-0 px-4 py-2" placeholder="Type your message here..." required autocomplete="off">
                                        <button type="submit" class="btn btn-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; min-width: 45px;">
                                            <i class="bi bi-send-fill ms-1"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- EDIT PROFILE -->
                <div class="tab-section" id="editProfileContent" style="display:none;">
                    <h4 class="fw-bold mb-1 text-dark"><i class="bi bi-person-gear me-2" style="color:#a78bfa;"></i>Edit Profile</h4>
                    <p class="text-muted small mb-4">Update your personal details, availability, and profile photo.</p>

                    <form action="${pageContext.request.contextPath}/fitness/trainer/update-profile" method="POST" enctype="multipart/form-data">
                        <div class="row g-3">

                            <!-- Profile Photo Preview + Upload -->
                            <div class="col-12 text-center mb-2">
                                <div style="position:relative; display:inline-block;">
                                    <c:if test="${not empty trainer.profilePhotoPath}">
                                        <img id="profilePreview" src="${trainer.profilePhotoPath}" alt="Profile"
                                             style="width:90px;height:90px;border-radius:50%;object-fit:cover;border:3px solid #e0e7ff;box-shadow:0 4px 12px rgba(0,0,0,0.1);">
                                    </c:if>
                                    <c:if test="${empty trainer.profilePhotoPath}">
                                        <div id="profilePreview" style="width:90px;height:90px;border-radius:50%;background:#e0e7ff;display:flex;align-items:center;justify-content:center;font-size:2rem;color:#6366f1;border:3px solid #e0e7ff;">
                                            <i class="bi bi-person-fill"></i>
                                        </div>
                                    </c:if>
                                    <label for="profilePhotoEdit" style="position:absolute;bottom:2px;right:2px;background:#6366f1;color:white;border-radius:50%;width:26px;height:26px;display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:0.75rem;box-shadow:0 2px 6px rgba(0,0,0,0.2);">
                                        <i class="bi bi-camera-fill"></i>
                                    </label>
                                    <input type="file" id="profilePhotoEdit" name="profilePhoto" accept="image/*" style="display:none;" onchange="previewPhoto(this)">
                                </div>
                                <div class="text-muted small mt-2">Click camera to change photo</div>
                            </div>

                            <!-- Full Name -->
                            <div class="col-md-6">
                                <label class="form-label">Full Name *</label>
                                <input type="text" name="fullName" class="form-control" value="${trainer.fullName}" required maxlength="50">
                            </div>

                            <!-- Phone -->
                            <div class="col-md-6">
                                <label class="form-label">Phone Number *</label>
                                <input type="tel" name="phone" class="form-control" value="${trainer.phone}" required maxlength="10" pattern="[6-9][0-9]{9}">
                            </div>

                            <!-- Experience -->
                            <div class="col-md-4">
                                <label class="form-label">Experience (Years) *</label>
                                <input type="number" name="experience" class="form-control" value="${trainer.experience}" min="0" max="50" required>
                            </div>

                            <!-- Bio -->
                            <div class="col-md-12">
                                <label class="form-label">Professional Bio / About Me *</label>
                                <textarea name="bio" class="form-control" rows="3" required minlength="10">${trainer.bio}</textarea>
                            </div>

                            <!-- Session Fees -->
                            <div class="col-md-4">
                                <label class="form-label">Fee per Session (₹) *</label>
                                <input type="number" name="sessionFees" class="form-control" value="${trainer.sessionFees}" min="1" required>
                            </div>

                            <!-- Available Timings -->
                            <div class="col-md-4">
                                <label class="form-label">Available Hours *</label>
                                <input type="text" name="availableTimings" class="form-control" value="${trainer.availableTimings}" placeholder="e.g. 08:00-12:00" required>
                            </div>

                            <!-- Specializations -->
                            <div class="col-12">
                                <label class="form-label">Specializations *</label>
                                <select name="specializations" class="form-select" multiple style="height:130px;">
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}" ${trainer.specializations != null and trainer.specializations.contains(cat) ? 'selected' : ''}>${cat}</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text"><i class="bi bi-info-circle me-1"></i>Hold Ctrl/Cmd to select multiple.</div>
                            </div>

                            <!-- Submit -->
                            <div class="col-12">
                                <button type="submit" class="btn btn-submit w-100">
                                    <i class="bi bi-check2-circle me-2"></i>Save Profile Changes
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Create Class Modal -->
<div class="modal fade" id="createClassModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-plus-circle-fill text-primary me-2"></i> Create New Class</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form id="createClassForm" action="${pageContext.request.contextPath}/fitness/trainer/class/create" method="POST" onsubmit="return validateCreateClassForm()">
          <div class="modal-body p-4">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Class Name</label>
                    <input type="text" name="className" class="form-control" required placeholder="e.g. Morning Power Yoga">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-select" required>
                        <option value="" disabled selected>Select Category</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="2" required placeholder="What will attendees learn?" maxlength="2000"></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date</label>
                    <input type="date" name="classDate" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Time</label>
                    <input type="time" name="classTime" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Duration (Mins)</label>
                    <input type="number" name="durationMinutes" class="form-control" required value="60">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Format</label>
                    <select name="sessionType" class="form-select" required>
                        <option value="ONLINE">Online</option>
                        <option value="OFFLINE">In-Person</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Max Capacity</label>
                    <input type="number" name="maxCapacity" class="form-control" required value="10" min="1" max="999" oninput="if(this.value.length > 3) this.value = this.value.slice(0,3);">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" name="price" class="form-control" required value="500" min="0.01" max="999999" step="0.01">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Location Address / Zoom Link</label>
                    <input type="text" name="meetingLinkOrLocation" class="form-control" required>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Create Class</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Class Modal -->
<div class="modal fade" id="editClassModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square text-primary me-2"></i> Edit Class</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form id="editClassForm" action="${pageContext.request.contextPath}/fitness/trainer/class/edit" method="POST" onsubmit="return validateEditClassForm()">
          <div class="modal-body p-4">
            <input type="hidden" name="classId" id="editClassId">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Class Name</label>
                    <input type="text" name="className" id="editClassName" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="category" id="editClassCategory" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" id="editClassDescription" class="form-control" rows="2" required maxlength="2000"></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Date</label>
                    <input type="date" name="classDate" id="editClassDate" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Time</label>
                    <input type="time" name="classTime" id="editClassTime" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Duration (Mins)</label>
                    <input type="number" name="durationMinutes" id="editClassDuration" class="form-control" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Format</label>
                    <select name="sessionType" id="editClassType" class="form-select" required>
                        <option value="ONLINE">Online</option>
                        <option value="OFFLINE">In-Person</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Max Capacity</label>
                    <input type="number" name="maxCapacity" id="editClassCapacity" class="form-control" required min="1" max="9999">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" name="price" id="editClassPrice" class="form-control" required min="0.01" max="999999" step="0.01">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Location Address / Zoom Link</label>
                    <input type="text" name="meetingLinkOrLocation" id="editClassLocation" class="form-control" required>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Update Class</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Chat Script for Trainer -->
<script>
    let chatPollingInterval;

    function loadChat(userId, trainerId, userName) {
        // UI Updates
        document.getElementById('chatEmptyState').classList.add('d-none');
        document.getElementById('activeChatArea').classList.remove('d-none');
        document.getElementById('activeChatArea').classList.add('d-flex');
        document.getElementById('chatUserName').innerText = userName;
        document.getElementById('chatUserId').value = userId;

        // Highlight active contact
        document.querySelectorAll('.chat-contact-btn').forEach(btn => btn.classList.remove('active', 'bg-primary', 'text-white'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active', 'bg-primary', 'text-white');
        }

        fetchChatMessages(userId, trainerId);

        // Start polling
        if(chatPollingInterval) clearInterval(chatPollingInterval);
        chatPollingInterval = setInterval(() => fetchChatMessages(userId, trainerId, false), 3000);
    }

    function fetchChatMessages(userId, trainerId, scrollToBottom = true) {
        fetch(`${pageContext.request.contextPath}/api/fitness/chat/` + userId + `/` + trainerId)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById('chatMessages');
                
                // Keep track of scroll to see if user is already at the bottom
                const isAtBottom = chatBox.scrollHeight - chatBox.scrollTop === chatBox.clientHeight;

                chatBox.innerHTML = '';
                
                data.forEach(msg => {
                    const isMe = (msg.senderType === 'TRAINER');
                    const align = isMe ? 'justify-content-end' : 'justify-content-start';
                    const bgClass = isMe ? 'text-white' : 'bg-white text-dark border shadow-sm';
                    
                    // Realistic Chat Bubble Styling
                    const customBg = isMe ? 'background: linear-gradient(135deg, #0ea5e9, #2563eb);' : '';
                    const radiusClass = isMe ? 'border-radius: 18px 18px 0px 18px;' : 'border-radius: 18px 18px 18px 0px;';
                    
                    const dateObj = new Date(msg.timestamp);
                    const timeString = isNaN(dateObj) ? '' : dateObj.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                    
                    const msgElement = `
                        <div class="d-flex mb-3 `+align+`">
                            <div class="p-3 `+bgClass+`" style="`+customBg+` `+radiusClass+` max-width: 85%; line-height: 1.4;">
                                <p class="mb-1" style="font-size: 0.95rem;">`+msg.message+`</p>
                                <small class="d-block `+(isMe ? 'text-white-50' : 'text-muted')+` text-end" style="font-size: 0.7rem; margin-top: 4px;">`+timeString+`</small>
                            </div>
                        </div>
                    `;
                    chatBox.innerHTML += msgElement;
                });
                
                if (scrollToBottom || isAtBottom) {
                    chatBox.scrollTop = chatBox.scrollHeight;
                }
            })
            .catch(err => console.error("Error fetching messages:", err));
    }

    function sendMessage(e) {
        e.preventDefault();
        const userId = document.getElementById('chatUserId').value;
        const trainerId = document.getElementById('chatTrainerId').value;
        const input = document.getElementById('chatInput');
        const message = input.value;

        if(!message.trim()) return;

        const formData = new URLSearchParams();
        formData.append('userId', userId);
        formData.append('trainerId', trainerId);
        formData.append('message', message);

        fetch(`${pageContext.request.contextPath}/api/fitness/chat/send`, {
            method: 'POST',
            body: formData,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(res => {
            if(res.ok) {
                input.value = '';
                fetchChatMessages(userId, trainerId, true);
            }
        });
    }
    function validateCreateClassForm() {
        const maxCapacityInput = document.querySelector('#createClassModal input[name="maxCapacity"]');
        const priceInput = document.querySelector('#createClassModal input[name="price"]');
        
        if (maxCapacityInput) {
            const val = parseInt(maxCapacityInput.value, 10);
            if (isNaN(val) || val < 1 || val > 9999) {
                alert("Please enter a logical Maximum Capacity between 1 and 9,999.");
                maxCapacityInput.focus();
                return false;
            }
        }
        
        if (priceInput) {
            const val = parseFloat(priceInput.value);
            if (isNaN(val) || val < 0.01 || val > 999999) {
                alert("Please enter a logical Price between ₹0.01 and ₹999,999.");
                priceInput.focus();
                return false;
            }
        }
        return true;
    }

    document.querySelectorAll('.edit-class-btn').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('editClassId').value = this.dataset.id;
            document.getElementById('editClassName').value = this.dataset.name;
            document.getElementById('editClassCategory').value = this.dataset.category;
            document.getElementById('editClassDescription').value = this.dataset.description;
            document.getElementById('editClassDate').value = this.dataset.date;
            document.getElementById('editClassTime').value = this.dataset.time;
            document.getElementById('editClassDuration').value = this.dataset.duration;
            document.getElementById('editClassType').value = this.dataset.type;
            document.getElementById('editClassCapacity').value = this.dataset.capacity;
            document.getElementById('editClassPrice').value = this.dataset.price;
            document.getElementById('editClassLocation').value = this.dataset.location;
            
            const editModal = new bootstrap.Modal(document.getElementById('editClassModal'));
            editModal.show();
        });
    });

    function validateEditClassForm() {
        const maxCapacityInput = document.querySelector('#editClassModal input[name="maxCapacity"]');
        const priceInput = document.querySelector('#editClassModal input[name="price"]');
        
        if (maxCapacityInput) {
            const val = parseInt(maxCapacityInput.value, 10);
            if (isNaN(val) || val < 1 || val > 9999) {
                alert("Please enter a logical Maximum Capacity between 1 and 9,999.");
                maxCapacityInput.focus();
                return false;
            }
        }
        
        if (priceInput) {
            const val = parseFloat(priceInput.value);
            if (isNaN(val) || val < 0.01 || val > 999999) {
                alert("Please enter a logical Price between ₹0.01 and ₹999,999.");
                priceInput.focus();
                return false;
            }
        }
        return true;
    }
</script>

<!-- Create Package Modal -->
<div class="modal fade" id="createPackageModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-tag-fill text-primary me-2"></i> Create Fitness Membership Package</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/fitness/trainer/package/create" method="POST">
          <div class="modal-body p-4">
            <div class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">Package Name *</label>
                    <input type="text" name="packageName" class="form-control" placeholder="e.g. 10-Class Yoga Pass, Monthly Unlimited Gym" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Category *</label>
                    <select name="category" class="form-select" required>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12">
                    <label class="form-label">Description / Inclusions</label>
                    <textarea name="description" class="form-control" rows="2" placeholder="Include benefits, equipment access, personal locker, etc."></textarea>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Total Sessions (0 = Unlimited)</label>
                    <input type="number" name="sessionCount" class="form-control" value="10" min="0" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Validity (Days)</label>
                    <input type="number" name="durationDays" class="form-control" value="30" min="1" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Price (₹) *</label>
                    <input type="number" name="price" class="form-control" value="1999" min="0" step="1" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Training Mode</label>
                    <select name="sessionType" class="form-select" required>
                        <option value="OFFLINE">In-Person Studio</option>
                        <option value="ONLINE">Online Live Sessions</option>
                        <option value="HYBRID">Hybrid (Studio + Online)</option>
                    </select>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Save Package</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Mark Attendance Modal -->
<div class="modal fade" id="markAttendanceModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-clipboard-check text-success me-2"></i> Mark Client Attendance</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/fitness/trainer/attendance/mark" method="POST">
          <input type="hidden" name="bookingId" id="attBookingId">
          <div class="modal-body p-4">
            <div class="mb-3">
                <label class="form-label">Client Name</label>
                <input type="text" id="attClientName" class="form-control bg-light" readonly>
            </div>
            <div class="mb-3">
                <label class="form-label">Session Date *</label>
                <input type="date" name="sessionDate" id="attSessionDate" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Session Time</label>
                <input type="text" name="sessionTime" id="attSessionTime" class="form-control" placeholder="e.g. 07:00 AM - 08:00 AM">
            </div>
            <div class="mb-3">
                <label class="form-label">Attendance Status *</label>
                <select name="status" class="form-select" required>
                    <option value="PRESENT" selected>Present (Deduct 1 Session)</option>
                    <option value="LATE">Late / Partial (Deduct 1 Session)</option>
                    <option value="ABSENT">Absent (No deduction)</option>
                    <option value="EXCUSED">Excused Absence</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Coach Notes / Workout Focus</label>
                <textarea name="notes" class="form-control" rows="2" placeholder="e.g. Completed heavy leg day + 15 min HIIT cooldown"></textarea>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-success rounded-pill px-4">Confirm Attendance</button>
          </div>
      </form>
    </div>
  </div>
</div>

<!-- Log Progress Modal -->
<div class="modal fade" id="logProgressModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content border-0 rounded-4 shadow">
      <div class="modal-header bg-light border-0 rounded-top-4">
        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-activity text-danger me-2"></i> Log Client Fitness Metric &amp; Progress</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/fitness/trainer/progress/log" method="POST">
          <div class="modal-body p-4">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Select Client *</label>
                    <select name="userId" class="form-select" required>
                        <c:forEach var="b" items="${activeBookings}">
                            <option value="${b.user.id}">${b.user.fullName} (${b.category})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Current Weight (kg)</label>
                    <input type="number" name="weightKg" class="form-control" placeholder="e.g. 68.5" step="0.1" min="20" max="300">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Body Fat %</label>
                    <input type="number" name="bodyFatPct" class="form-control" placeholder="e.g. 18.2" step="0.1" min="3" max="70">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Fitness Capabilities Radar (Scores out of 100)</label>
                    <input type="text" name="metricsJson" class="form-control" value="Endurance: 80, Strength: 75, Flexibility: 70, Core: 85, Stamina: 80" placeholder="e.g. Endurance: 85, Strength: 80, Flexibility: 75">
                </div>
                <div class="col-md-12">
                    <label class="form-label">Coach Milestone Notes</label>
                    <textarea name="workoutNotes" class="form-control" rows="3" placeholder="Document achievements, personal records (PRs), posture corrections, diet adherence..."></textarea>
                </div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-submit rounded-pill px-4">Save Milestone</button>
          </div>
      </form>
    </div>
  </div>
</div>

<script>
    function openAttendanceModal(bookingId, clientName, bookingTime) {
        document.getElementById('attBookingId').value = bookingId;
        document.getElementById('attClientName').value = clientName;
        document.getElementById('attSessionTime').value = bookingTime;
        document.getElementById('attSessionDate').value = new Date().toISOString().split('T')[0];
        var attModal = new bootstrap.Modal(document.getElementById('markAttendanceModal'));
        attModal.show();
    }

    function switchTab(tabId, clickedBtn) {
        document.querySelectorAll('.tab-section').forEach(function(section) {
            section.style.display = 'none';
        });
        document.querySelectorAll('#studioTab .list-group-item').forEach(function(btn) {
            btn.classList.remove('active');
        });
        var target = document.getElementById(tabId);
        if (target) target.style.display = 'block';
        if (clickedBtn) clickedBtn.classList.add('active');
    }

    function previewPhoto(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var preview = document.getElementById('profilePreview');
                if (preview.tagName === 'IMG') {
                    preview.src = e.target.result;
                } else {
                    var img = document.createElement('img');
                    img.id = 'profilePreview';
                    img.src = e.target.result;
                    img.alt = 'Profile';
                    img.style.cssText = 'width:90px;height:90px;border-radius:50%;object-fit:cover;border:3px solid #e0e7ff;box-shadow:0 4px 12px rgba(0,0,0,0.1);';
                    preview.parentNode.replaceChild(img, preview);
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

</body>
</html>

