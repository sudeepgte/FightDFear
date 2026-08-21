<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>User Dashboard</title>

<!-- Fonts -->
<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

<!-- Icons & CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
<!-- Leaflet CSS -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>

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
    }

    #page-content-wrapper {
        flex: 1;
        min-width: 0;
        display: flex;
        flex-direction: column;
        padding: 25px 30px;
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
    .reload-data {
        color: #64748b;
        font-size: 0.9rem;
        font-weight: 600;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    
    /* 3-Column Layout structure */
    .dashboard-container {
        display: flex;
        gap: 25px;
        align-items: flex-start;
        width: 100%;
        max-width: 100%;
        box-sizing: border-box;
    }
    .main-col {
        flex: 1;
        min-width: 0;
        max-width: 100%;
    }
    .right-col {
        width: 320px;
        max-width: 100%;
        flex-shrink: 0;
        display: flex;
        flex-direction: column;
        gap: 25px;
        min-width: 0;
        overflow: hidden;
    }
    .right-col .panel-new {
        overflow: hidden;
    }
    
    /* 4 Stat Cards — fit available cards without empty grid tracks */
    .stat-cards-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 25px;
        width: 100%;
    }
    .stat-card-new {
        background: #fff;
        border-radius: 16px;
        padding: 20px;
        box-shadow: var(--shadow-sm);
        position: relative;
    }
    .stat-icon-box {
        width: 45px;
        height: 45px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        margin-bottom: 15px;
    }
    .stat-badge {
        position: absolute;
        top: 20px;
        right: 20px;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
    }
    .stat-value-text {
        font-size: 1.6rem;
        font-weight: 800;
        color: #1e293b;
        line-height: 1.2;
        margin-bottom: 5px;
    }
    .stat-label-text {
        font-size: 0.85rem;
        color: #94a3b8;
        font-weight: 500;
        margin: 0;
    }
    
    /* Icons styling */
    .icon-blue { color: #3b82f6; }
    .icon-orange { color: #f97316; }
    .icon-yellow { color: #eab308; }
    .icon-green { color: #22c55e; }
    
    .badge-green { background: #ffe4e6; color: #f43f5e; }
    .badge-red { background: #fee2e2; color: #ef4444; }
    
    /* Panels */
    .panel-new {
        background: #fff;
        border-radius: 16px;
        padding: 20px;
        box-shadow: var(--shadow-sm);
        margin-bottom: 25px;
    }
    /* Charts grid */
    .charts-grid {
        display: grid;
        grid-template-columns: minmax(0, 2fr) minmax(0, 1fr) minmax(0, 1fr);
        gap: 20px;
        margin-bottom: 25px;
        width: 100%;
    }
    .charts-grid > .panel-new {
        min-width: 0;
        width: 100%;
        box-sizing: border-box;
    }
    .panel-header-flex {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }

    /* Bottom grid */
    .bottom-grid {
        display: grid;
        grid-template-columns: minmax(0, 2fr) minmax(0, 1fr);
        gap: 20px;
        width: 100%;
    }
    .bottom-grid > .panel-new {
        min-width: 0;
        width: 100%;
        box-sizing: border-box;
    }
    .panel-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--primary-purple);
        margin: 0;
    }
    .panel-link {
        font-size: 0.85rem;
        color: #3b82f6;
        text-decoration: none;
        font-weight: 600;
    }
    
    /* Charts grid */
    .charts-grid {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr;
        gap: 20px;
        margin-bottom: 25px;
    }
    .charts-grid > .panel-new {
        min-width: 0;
    }

    .chart-container {
        position: relative;
        height: 250px;
        width: 100%;

        min-width: 0;
    }
    
    /* Bottom grid */
    .bottom-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 20px;

        max-width: 100%;
        box-sizing: border-box;

    }
    
    /* Lists */
    .activity-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .activity-item {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 12px 0;
        border-bottom: 1px solid #f1f5f9;
    }
    .activity-item:last-child { border-bottom: none; }
    
    .act-avatar {
        width: 40px; height: 40px; border-radius: 50%; object-fit: cover;
    }
    .act-info { flex: 1; min-width: 0; }
    .act-title { font-size: 0.9rem; font-weight: 600; color: #1e293b; margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .act-desc { font-size: 0.8rem; color: #94a3b8; margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;}
    .act-time { font-size: 0.75rem; color: #94a3b8; font-weight: 500; }
    .act-amount { font-size: 0.9rem; font-weight: 700; }
    .text-green { color: #22c55e; }
    .text-red { color: #ef4444; }
    
    /* Leaflet fix */
    #dangerMap {
        border-radius: 12px;
        z-index: 1;
        min-height: 280px;
        height: 280px;
        width: 100%;
        position: relative;
        overflow: hidden;
        background: #e2e8f0;
    }
    .map-panel-wrap {
        overflow: visible !important;
    }
    .map-panel-wrap .leaflet-container {
        height: 100% !important;
        width: 100% !important;
        border-radius: 12px;
    }
    
    @media (max-width: 1200px) {
        .dashboard-container { flex-direction: column; }
        .right-col { width: 100%; flex-direction: row; }
        .right-col .panel-new { flex: 1; margin-bottom: 0; }
        .charts-grid { grid-template-columns: 1fr; }
        .bottom-grid { grid-template-columns: 1fr; }
    }
    @media (max-width: 991px) {
        .stat-cards-grid { grid-template-columns: repeat(2, 1fr); }
        .right-col { flex-direction: column; }
    }
    @media (max-width: 768px) {
        #page-content-wrapper {
            padding: 14px 12px;
        }
        .dashboard-header-flex {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 18px;
        }
        .dashboard-title {
            font-size: 1.15rem;
            line-height: 1.35;
        }
        .header-actions {
            width: 100%;
            justify-content: space-between;
        }
        .stat-cards-grid {
            gap: 12px;
            margin-bottom: 18px;
        }
        .stat-card-new {
            padding: 16px;
        }
        .stat-value-text {
            font-size: 1.4rem;
        }
        .panel-new {
            padding: 16px;
            margin-bottom: 18px;
        }
        .chart-container {
            height: 220px;
        }
        #dangerMap {
            min-height: 240px;
            height: 240px;
        }
    }
    @media (max-width: 430px) {
        .stat-cards-grid {
            grid-template-columns: 1fr;
        }
        .dashboard-title {
            font-size: 1.05rem;
        }
        .dashboard-title .badge {
            display: block;
            margin-left: 0 !important;
            margin-top: 8px;
            width: fit-content;
        }
        .stat-value-text {
            font-size: 1.25rem;
        }
        .stat-icon-box {
            width: 40px;
            height: 40px;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .panel-title {
            font-size: 1rem;
        }
        .act-title,
        .act-desc {
            white-space: normal;
        }
        .chart-container {
            height: 200px;
        }
    }
</style>
</head>

<body>



    <!-- Header -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Page Content -->
    <div id="page-content-wrapper" data-skip-global-back="true">
        <div class="dashboard-header-flex">
            <h2 class="dashboard-title">
                General Report
                <c:if test="${isWorker}">
                    <span class="badge ms-2 fs-6 align-middle" style="background-color: #f43f5e; color: white;">
                        <i class="fas fa-user-check me-1"></i> Verified Worker
                    </span>
                </c:if>
            </h2>
            <div class="header-actions">
                <a href="#" class="reload-data" onclick="location.reload()"><i class="bi bi-arrow-clockwise"></i> Reload Data</a>
            </div>
        </div>

        <div class="dashboard-container">
            <!-- MAIN COLUMN -->
            <div class="main-col">
                
                <!-- 4 Stats Cards -->
                <div class="stat-cards-grid">

                    <div class="stat-card-new">
                        <span class="stat-badge badge-red">2% <i class="bi bi-arrow-down-short"></i></span>
                        <div class="stat-icon-box" style="background:#ffedd5; color:#f97316;"><i class="bi bi-shield-check"></i></div>
                        <div class="stat-value-text">${approvedCentreCount}</div>
                        <p class="stat-label-text">Martial Arts Centres</p>
                    </div>
                     
                    
                    <div class="stat-card-new">
                        <span class="stat-badge badge-green">22% <i class="bi bi-arrow-up-short"></i></span>
                        <div class="stat-icon-box" style="background:#dcfce7; color:#22c55e;"><i class="bi bi-bell"></i></div>
                        <div class="stat-value-text">${unreadBroadcastCount}</div>
                        <p class="stat-label-text">Unread Alerts</p>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="charts-grid">
                    <!-- Line Chart -->
                    <div class="panel-new">
                        <div class="panel-header-flex mb-1">
                            <h3 class="panel-title">Activity Report</h3>
                            <div class="d-flex align-items-center gap-2 border rounded px-3 py-1" style="font-size:0.8rem;">
                                <i class="bi bi-calendar3 text-muted"></i> 
                                <span>2 May - 2 Jun, 2026</span>
                            </div>
                        </div>
                        <div class="d-flex gap-4 mb-4 mt-3">
                            <div>
                                <div class="fs-4 fw-bold" style="color:var(--primary-purple);">15</div>
                                <div class="small text-muted fw-semibold">This Month</div>
                            </div>
                            <div>
                                <div class="fs-4 fw-bold text-muted">10</div>
                                <div class="small text-muted fw-semibold">Last Month</div>
                            </div>
                        </div>
                        <div class="chart-container">
                            <canvas id="lineChart"></canvas>
                        </div>
                    </div>
                    
                    <!-- Pie Chart -->
                    <div class="panel-new d-flex flex-column">
                        <div class="panel-header-flex">
                            <h3 class="panel-title">User Demographics</h3>
                            <a href="#" class="panel-link">Show More</a>
                        </div>
                        <div class="chart-container flex-grow-1 d-flex align-items-center" style="height: 180px;">
                            <canvas id="pieChart"></canvas>
                        </div>
                        <div class="mt-3 w-100">
                            <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                <span><i class="bi bi-circle-fill icon-blue me-2" style="font-size:10px;"></i> 17 - 30 Years old</span>
                                <span class="fw-bold text-dark">${demoAge17to30Pct}%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                <span><i class="bi bi-circle-fill icon-orange me-2" style="font-size:10px;"></i> 31 - 50 Years old</span>
                                <span class="fw-bold text-dark">${demoAge31to50Pct}%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center small text-muted">
                                <span><i class="bi bi-circle-fill icon-yellow me-2" style="font-size:10px;"></i> >= 50 Years old</span>
                                <span class="fw-bold text-dark">${demoAge51PlusPct}%</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Donut Chart -->
                    <div class="panel-new d-flex flex-column">
                        <div class="panel-header-flex">
                            <h3 class="panel-title">Gender Ratio</h3>
                            <a href="#" class="panel-link">Show More</a>
                        </div>
                        <div class="chart-container flex-grow-1 d-flex align-items-center" style="height: 180px;">
                            <canvas id="donutChart"></canvas>
                        </div>
                        <div class="mt-3 w-100">
                             <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                <span><i class="bi bi-circle-fill icon-blue me-2" style="font-size:10px;"></i> Male</span>
                                <span class="fw-bold text-dark">${malePct}%</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center small text-muted mb-2">
                                <span><i class="bi bi-circle-fill me-2" style="font-size:10px; color:#f43f5e;"></i> Female</span>
                                <span class="fw-bold text-dark">${femalePct}%</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Fitness Classes -->
                <div class="panel-new mb-4">
                    <div class="panel-header-flex">
                        <h3 class="panel-title"><i class="bi bi-calendar-event me-2" style="color: #f43f5e;"></i> Upcoming Fitness Classes</h3>
                        <a href="${pageContext.request.contextPath}/fitness" class="panel-link">Browse All</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty upcomingFitnessClasses}">
                            <div class="row g-3 mt-2">
                                <c:forEach var="fc" items="${upcomingFitnessClasses}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="border rounded-4 p-3 bg-white shadow-sm h-100 d-flex flex-column" style="transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h6 class="fw-bold mb-0 text-dark">${fc.className}</h6>
                                                <span class="badge border" style="font-size:0.7rem; background-color: rgba(244, 63, 94, 0.08); color: #f43f5e; border-color: rgba(244, 63, 94, 0.2) !important;">${fc.category}</span>
                                            </div>
                                            <div class="text-muted small mb-3"><i class="bi bi-person-badge text-secondary me-1"></i> By <strong>${fc.trainer.fullName}</strong></div>
                                            
                                            <div class="d-flex align-items-center gap-2 mb-2 small text-dark fw-medium">
                                                <i class="bi bi-calendar2-check text-primary"></i> ${fc.classDate} @ ${fc.formattedClassTime}
                                            </div>
                                            <div class="d-flex align-items-center gap-2 mb-3 small text-dark fw-medium">
                                                <i class="bi bi-people-fill text-info"></i> ${fc.maxCapacity - fc.currentEnrollment} Seats Left
                                            </div>
                                            
                                            <div class="mt-auto d-flex justify-content-between align-items-center pt-2 border-top">
                                                <div class="fw-bold fs-5" style="color: #f43f5e;">₹${fc.price}</div>
                                                <div class="d-flex gap-2">
                                                    <button type="button" class="btn btn-sm btn-outline-primary" style="border-radius: 20px; font-weight: 600; padding: 6px 12px;" onclick="openUserChat(${fc.trainer.id}, '${fc.trainer.fullName}')" title="Chat with Trainer">
                                                        <i class="bi bi-chat-dots-fill"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm" style="background: linear-gradient(135deg, #1e1b4b, #f43f5e); color: white; border-radius: 20px; font-weight: 600; padding: 6px 16px; border: none; box-shadow: 0 4px 10px rgba(244,63,94,0.2);" data-bs-toggle="modal" data-bs-target="#bookClassModal${fc.id}">Enroll</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Book Class Modal -->
                                    <div class="modal fade" id="bookClassModal${fc.id}" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 rounded-4 shadow-lg">
                                                <div class="modal-header bg-light border-0 rounded-top-4">
                                                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-calendar2-check-fill me-2" style="color: #f43f5e;"></i> Book Group Class</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/fitness/class/book" method="POST">
                                                    <div class="modal-body p-4">
                                                        <input type="hidden" name="classId" value="${fc.id}">
                                                        <div class="mb-4 text-center">
                                                            <h4 class="fw-bold text-dark mb-1">${fc.className}</h4>
                                                            <span class="badge border mb-3" style="background-color: rgba(244, 63, 94, 0.08); color: #f43f5e; border-color: rgba(244, 63, 94, 0.2) !important;">${fc.category}</span>
                                                        </div>
                                                        
                                                        <div class="p-3 bg-light rounded-3 mb-4">
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Trainer</span>
                                                                <span class="fw-bold text-dark small">${fc.trainer.fullName}</span>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Date & Time</span>
                                                                <span class="fw-bold text-dark small">${fc.classDate} @ ${fc.formattedClassTime}</span>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Duration</span>
                                                                <span class="fw-bold text-dark small">${fc.durationMinutes} Minutes</span>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Format</span>
                                                                <span class="fw-bold text-dark small">${fc.sessionType}</span>
                                                            </div>
                                                            <hr class="my-2">
                                                            <div class="d-flex justify-content-between">
                                                                <span class="text-muted fw-bold">Total Payable</span>
                                                                <span class="fw-bold fs-5" style="color: #f43f5e;">₹${fc.price}</span>
                                                            </div>
                                                        </div>

                                                        <div class="alert alert-warning py-2 mb-0" style="font-size:0.85rem;">
                                                            <i class="bi bi-info-circle-fill me-1"></i> The fee of ₹${fc.price} will be deducted directly from your wallet balance.
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer border-0 pt-0">
                                                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn rounded-pill px-4" style="background: #f43f5e; color: white; border: none;">Confirm Booking</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 bg-light rounded-4 mt-3">
                                <i class="bi bi-clock-history text-muted fs-3 opacity-50"></i>
                                <p class="text-muted small mt-2 mb-0 fw-medium">No upcoming classes available right now. Check back later!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Active Fitness Subscriptions / Progress -->
                <c:if test="${not empty activeSubscriptions}">
                    <div class="panel-new mb-4">
                        <div class="panel-header-flex">
                            <h3 class="panel-title"><i class="bi bi-activity me-2" style="color: #f43f5e;"></i> My Personal Coaching Subscriptions</h3>
                            <span class="badge text-white" style="background-color: #f43f5e;">${activeSubscriptions.size()} Active</span>
                        </div>
                        <div class="row g-3 mt-2">
                            <c:forEach var="sub" items="${activeSubscriptions}">
                                <div class="col-md-6 col-lg-4">
                                    <div class="border rounded-4 p-3 bg-white shadow-sm h-100 d-flex flex-column" style="transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h6 class="fw-bold mb-0 text-dark">${sub.category} Coaching</h6>
                                            <span class="badge border" style="font-size:0.7rem; background-color: rgba(244, 63, 94, 0.08); color: #f43f5e; border-color: rgba(244, 63, 94, 0.2) !important;">
                                                <c:choose>
                                                    <c:when test="${sub.duration == 'SINGLE'}">Single Session</c:when>
                                                    <c:when test="${sub.duration == 'MONTHLY'}">Monthly Package</c:when>
                                                    <c:when test="${sub.duration == 'QUARTERLY'}">Quarterly Package</c:when>
                                                    <c:when test="${sub.duration == 'HALF_YEAR'}">6 Months Package</c:when>
                                                    <c:when test="${sub.duration == 'YEAR'}">1 Year Package</c:when>
                                                    <c:otherwise>Active Plan</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-muted small mb-2"><i class="bi bi-person-badge text-secondary me-1"></i> Trainer: <strong>${sub.trainer.fullName}</strong></div>
                                        <div class="text-muted small mb-3"><i class="bi bi-calendar2-week text-secondary me-1"></i> Validity: <strong>${sub.startDate} to ${sub.endDate}</strong></div>

                                        <c:set var="pct" value="0" />
                                        <c:if test="${sub.totalSessions > 0}">
                                            <c:set var="pct" value="${(sub.completedSessions * 100) / sub.totalSessions}" />
                                        </c:if>
                                        <div class="mt-auto pt-3 border-top position-relative">
                                            <button type="button" class="btn btn-sm btn-outline-primary position-absolute end-0 top-0 mt-3 me-0 border-0" onclick="openUserChat(${sub.trainer.id}, '${sub.trainer.fullName}')" title="Chat with Trainer" style="background:#e0e7ff; color:#312e81; border-radius: 50%; width:32px; height:32px; display:flex; align-items:center; justify-content:center;">
                                                <i class="bi bi-chat-dots-fill"></i>
                                            </button>
                                            <div class="d-flex justify-content-between mb-1 small text-dark fw-medium" style="padding-right: 40px;">
                                                <span>Progress Tracker</span>
                                                <span>${sub.completedSessions} / ${sub.totalSessions} Sessions</span>
                                            </div>
                                            <div class="progress" style="height: 10px; border-radius: 5px; background-color:#e9ecef;">
                                                <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: ${pct}%; border-radius: 5px; background-color: #f43f5e !important;" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Completed Fitness Classes / Ratings -->
                <c:if test="${not empty completedFitnessBookings}">
                    <div class="panel-new mb-4">
                        <div class="panel-header-flex">
                            <h3 class="panel-title"><i class="bi bi-star-fill text-warning me-2"></i> Rate Your Sessions</h3>
                            <span class="badge bg-warning text-dark">${completedFitnessBookings.size()} Pending Reviews</span>
                        </div>
                        <style>
                        .rating-container > label:hover,
                        .rating-container > label:hover ~ label,
                        .rating-container > input:checked ~ label {
                            color: #ffc107 !important;
                        }
                        </style>
                        <div class="row g-3 mt-2">
                            <c:forEach var="cb" items="${completedFitnessBookings}">
                                <div class="col-md-6 col-lg-4">
                                    <div class="border rounded-4 p-3 bg-white shadow-sm h-100 d-flex flex-column" style="transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='translateY(0)'">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h6 class="fw-bold mb-0 text-dark">${cb.fitnessClass.className}</h6>
                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25" style="font-size:0.7rem;">Completed</span>
                                        </div>
                                        <div class="text-muted small mb-3"><i class="bi bi-person-badge text-secondary me-1"></i> Trained by <strong>${cb.trainer.fullName}</strong></div>
                                        
                                        <div class="d-flex align-items-center gap-2 mb-3 small text-dark fw-medium">
                                            <i class="bi bi-calendar-check me-1" style="color: #f43f5e;"></i> Session on ${cb.bookingDate}
                                        </div>
                                        
                                        <div class="mt-auto d-flex justify-content-end pt-2 border-top">
                                            <button type="button" class="btn btn-sm btn-warning fw-bold text-dark rounded-pill px-3 shadow-sm d-flex align-items-center gap-1" data-bs-toggle="modal" data-bs-target="#reviewModal${cb.id}">
                                                <i class="bi bi-star-fill"></i> Leave a Rating
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Review Modal -->
                                <div class="modal fade" id="reviewModal${cb.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 rounded-4 shadow-lg">
                                            <div class="modal-header bg-warning rounded-top-4 border-0">
                                                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-star-fill me-2"></i> Rate ${cb.trainer.fullName}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/fitness/review/submit" method="POST">
                                                <div class="modal-body p-4">
                                                    <input type="hidden" name="bookingId" value="${cb.id}">
                                                    
                                                    <div class="mb-4 text-center">
                                                        <h6 class="text-muted fw-bold mb-3">How was ${cb.fitnessClass.className}?</h6>
                                                        <div class="d-flex justify-content-center gap-2 flex-row-reverse rating-container">
                                                            <input type="radio" id="star5_${cb.id}" name="rating" value="5" class="d-none" required/>
                                                            <label for="star5_${cb.id}" class="fs-2 text-muted" style="cursor:pointer; transition: 0.2s;"><i class="bi bi-star-fill"></i></label>
                                                            <input type="radio" id="star4_${cb.id}" name="rating" value="4" class="d-none"/>
                                                            <label for="star4_${cb.id}" class="fs-2 text-muted" style="cursor:pointer; transition: 0.2s;"><i class="bi bi-star-fill"></i></label>
                                                            <input type="radio" id="star3_${cb.id}" name="rating" value="3" class="d-none"/>
                                                            <label for="star3_${cb.id}" class="fs-2 text-muted" style="cursor:pointer; transition: 0.2s;"><i class="bi bi-star-fill"></i></label>
                                                            <input type="radio" id="star2_${cb.id}" name="rating" value="2" class="d-none"/>
                                                            <label for="star2_${cb.id}" class="fs-2 text-muted" style="cursor:pointer; transition: 0.2s;"><i class="bi bi-star-fill"></i></label>
                                                            <input type="radio" id="star1_${cb.id}" name="rating" value="1" class="d-none"/>
                                                            <label for="star1_${cb.id}" class="fs-2 text-muted" style="cursor:pointer; transition: 0.2s;"><i class="bi bi-star-fill"></i></label>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold small text-muted">Write a comment (optional)</label>
                                                        <textarea name="comment" class="form-control rounded-3 bg-light border-0" rows="4" placeholder="Share your experience..."></textarea>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-0 pt-0 bg-white rounded-bottom-4">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                    <button type="submit" class="btn btn-warning fw-bold rounded-pill px-4 shadow-sm text-dark">Submit Review</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Bottom Grid -->
                <div class="bottom-grid">
                    <!-- Map -->
                    <div class="panel-new d-flex flex-column map-panel-wrap">
                        <div class="panel-header-flex">
                            <h3 class="panel-title">Community Safety Map</h3>
                            <div class="d-flex align-items-center gap-2 border rounded px-3 py-1 bg-light text-muted" style="font-size:0.8rem;">
                                <i class="bi bi-geo-alt"></i> ${dangerMapPointCount != null ? dangerMapPointCount : 0} reports
                            </div>
                        </div>
                        <div id="dangerMap"></div>
                        <div class="mt-3 text-muted small">
                            <i class="bi bi-info-circle me-1"></i> Showing verified safety reports across the community.
                            <a href="${pageContext.request.contextPath}/heatmap" class="ms-1">Open full map</a>
                        </div>
                    </div>
                    
                    <!-- Best Sellers (Featured Centres) -->
                    <div class="panel-new overflow-auto" style="max-height: 400px;">
                        <div class="panel-header-flex">
                            <h3 class="panel-title">Top Rated Centres</h3>
                        </div>
                        <c:choose>
                            <c:when test="${not empty approvedCentres}">
                                <ul class="activity-list">
                                    <c:forEach var="centre" items="${approvedCentres}" end="4">
                                        <li class="activity-item">
                                            <div class="act-avatar bg-light d-flex align-items-center justify-content-center text-primary" style="background:#e0e7ff; border-radius:8px;">
                                                <img src="${pageContext.request.contextPath}/assets/img/hero-bg.jpg" alt="img" class="w-100 h-100" style="border-radius:8px; object-fit:cover;">
                                            </div>
                                            <div class="act-info">
                                                <h4 class="act-title">${centre.name}</h4>
                                                <p class="act-desc">${centre.location}</p>
                                            </div>
                                            <span class="badge rounded-pill" style="font-size:0.7rem; background-color: rgba(244, 63, 94, 0.08); color: #f43f5e; border: 1px solid rgba(244, 63, 94, 0.2) !important;">Active</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted small">No centres available.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div><!-- /main-col -->
            
            <!-- RIGHT COLUMN -->
            <div class="right-col">
                 
                 <!-- Quick Safety Tools -->
                 <div class="panel-new">
                     <h3 class="panel-title mb-3"><i class="bi bi-shield-fill-check text-primary me-2"></i> Safety Toolbox</h3>
                     <div class="row g-2">
                         <div class="col-6">
                             <a href="${pageContext.request.contextPath}/heatmap" class="d-flex flex-column align-items-center justify-content-center text-center p-3 border rounded-3 bg-light text-decoration-none text-dark hover-translate" style="transition:0.2s;">
                                 <i class="bi bi-map text-primary fs-3 mb-2"></i>
                                 <span class="fw-bold small text-wrap">Danger Map</span>
                             </a>
                         </div>
                         <div class="col-6">
                             <a href="${pageContext.request.contextPath}/reminders" class="d-flex flex-column align-items-center justify-content-center text-center p-3 border rounded-3 bg-light text-decoration-none text-dark hover-translate" style="transition:0.2s;">
                                 <i class="bi bi-alarm text-primary fs-3 mb-2"></i>
                                 <span class="fw-bold small text-wrap">Reminders</span>
                             </a>
                         </div>
                         <div class="col-6">
                             <a href="${pageContext.request.contextPath}/journey" class="d-flex flex-column align-items-center justify-content-center text-center p-3 border rounded-3 bg-light text-decoration-none text-dark hover-translate" style="transition:0.2s;">
                                 <i class="bi bi-pin-map text-primary fs-3 mb-2"></i>
                                 <span class="fw-bold small text-wrap">Safety Tracker</span>
                             </a>
                         </div>
                         <div class="col-6">
                             <a href="${pageContext.request.contextPath}/buddy" class="d-flex flex-column align-items-center justify-content-center text-center p-3 border rounded-3 bg-light text-decoration-none text-dark hover-translate" style="transition:0.2s;">
                                 <i class="bi bi-people text-primary fs-3 mb-2"></i>
                                 <span class="fw-bold small text-wrap">Buddy Mode</span>
                             </a>
                         </div>
                     </div>
                 </div>
                
                <!-- Incoming Job requests moved to a dedicated page -->

                <!-- Transactions (Recent Broadcasts) -->
                <div class="panel-new">
                    <h3 class="panel-title mb-4">Recent Alerts</h3>
                    <c:choose>
                        <c:when test="${not empty recentBroadcasts}">
                            <ul class="activity-list">
                                <c:forEach var="msg" items="${recentBroadcasts}" end="4">
                                    <li class="activity-item">
                                        <div class="act-avatar d-flex align-items-center justify-content-center" style="background: ${msg.type == 'ALERT' ? '#fee2e2' : '#e0f2fe'}; color: ${msg.type == 'ALERT' ? '#ef4444' : '#0ea5e9'}">
                                            <i class="bi ${msg.type == 'ALERT' ? 'bi-exclamation-circle' : 'bi-info-circle'}"></i>
                                        </div>
                                        <div class="act-info">
                                            <h4 class="act-title">${msg.title}</h4>
                                            <p class="act-desc">${msg.sentAt}</p>
                                        </div>
                                        <div class="act-time fw-bold ${msg.type == 'ALERT' ? 'text-danger' : 'text-primary'}">${msg.type}</div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small">No recent alerts.</p>
                        </c:otherwise>
                    </c:choose>
                    <div class="mt-4 text-center">
                        <button class="btn border w-100 rounded text-muted fw-bold bg-light">View More</button>
                    </div>
                </div>


            </div><!-- /right-col -->
        </div><!-- /dashboard-container -->

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Line Chart
        var canvas = document.getElementById('lineChart');
        if(canvas) {
            var ctxLine = canvas.getContext('2d');
            var gradient = ctxLine.createLinearGradient(0, 0, 0, 250);
            gradient.addColorStop(0, 'rgba(59, 130, 246, 0.4)');
            gradient.addColorStop(1, 'rgba(59, 130, 246, 0)');
            
            new Chart(ctxLine, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [
                        {
                            label: 'Current Month',
                            data: [100, 250, 200, 450, 300, 650, 450, 800, 700, 950, 850, 1100],
                            borderColor: '#3b82f6',
                            backgroundColor: gradient,
                            borderWidth: 3,
                            pointRadius: 0,
                            pointHoverRadius: 6,
                            tension: 0.4,
                            fill: true
                        },
                        {
                            label: 'Last Month',
                            data: [150, 200, 180, 250, 220, 350, 320, 500, 450, 600, 580, 700],
                            borderColor: '#cbd5e1',
                            borderWidth: 2,
                            borderDash: [5, 5],
                            pointRadius: 0,
                            tension: 0.4,
                            fill: false
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { display: false }, ticks: {color: '#94a3b8'} },
                        y: { 
                            grid: { borderDash: [2, 2], color: '#f1f5f9' },
                            ticks: { color: '#94a3b8', callback: function(value) { return '$' + value; } }
                        }
                    }
                }
            });
        }

        // Pie Chart
        var pieCanvas = document.getElementById('pieChart');
        if (pieCanvas) {
            var ctxPie = pieCanvas.getContext('2d');
            var demoData = [
                ${demoAge17to30Pct == null ? 0 : demoAge17to30Pct},
                ${demoAge31to50Pct == null ? 0 : demoAge31to50Pct},
                ${demoAge51PlusPct == null ? 0 : demoAge51PlusPct}
            ];
            if (demoData.reduce(function(a, b) { return a + b; }, 0) === 0) {
                demoData = [1, 1, 1];
            }
            new Chart(ctxPie, {
                type: 'pie',
                data: {
                    labels: ['17-30 Years', '31-50 Years', '>=50 Years'],
                    datasets: [{
                        data: demoData,
                        backgroundColor: ['#3b82f6', '#f97316', '#eab308'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });
        }

        // Donut Chart
        var donutCanvas = document.getElementById('donutChart');
        if (donutCanvas) {
            var ctxDonut = donutCanvas.getContext('2d');
            var mPct = ${malePct == null ? 0 : malePct};
            var fPct = ${femalePct == null ? 0 : femalePct};
            if(mPct === 0 && fPct === 0) { mPct = 1; fPct = 1; }
            new Chart(ctxDonut, {
                type: 'doughnut',
                data: {
                    labels: ['Male', 'Female'],
                    datasets: [{
                        data: [mPct, fPct],
                        backgroundColor: ['#3b82f6', '#f43f5e'],
                        borderWidth: 0,
                        cutout: '75%'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });
        }
    });
</script>

<!-- Leaflet JS & Map Init -->
<script>
  window.__APP_CTX__ = "${pageContext.request.contextPath}";
</script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var mapEl = document.getElementById('dangerMap');
        if (!mapEl || typeof L === 'undefined') return;

        var points = [];
        try {
            points = ${empty dangerMapPointsJson ? '[]' : dangerMapPointsJson};
        } catch (e) {
            points = [];
        }

        var map = L.map('dangerMap', { scrollWheelZoom: false }).setView([20.5937, 78.9629], 5);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© OpenStreetMap'
        }).addTo(map);

        function refreshMapSize() {
            map.invalidateSize(true);
        }
        setTimeout(refreshMapSize, 100);
        setTimeout(refreshMapSize, 500);
        window.addEventListener('resize', refreshMapSize);

        if (Array.isArray(points) && points.length > 0) {
            var latLngs = [];
            points.forEach(function(p) {
                var lat = p.lat != null ? p.lat : p.latitude;
                var lng = p.lng != null ? p.lng : p.longitude;
                if (lat == null || lng == null) return;
                latLngs.push([lat, lng]);
                L.circleMarker([lat, lng], {
                    radius: 7,
                    color: '#ef4444',
                    fillColor: '#f43f5e',
                    fillOpacity: 0.75
                }).addTo(map).bindPopup(p.note || p.category || 'Safety report');
            });
            if (latLngs.length > 0) {
                map.fitBounds(L.latLngBounds(latLngs).pad(0.2));
            }
        } else {
            L.marker([20.5937, 78.9629]).addTo(map).bindPopup('No reports yet — map is ready for live safety data.');
        }
    });
</script>

<!-- WebSocket Badges -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
  (function () {
    const badge = document.getElementById("pendingRequestsBadge");
    if (!badge) return;
    function applyCount(count) {
      const n = Number(count || 0);
      if (n > 0) { badge.textContent = String(n); badge.style.display = "inline-block"; }
      else { badge.style.display = "none"; }
      const statEl = document.getElementById("statPendingRequests");
      if (statEl) statEl.textContent = String(n);
    }
    applyCount(${requestCount == null ? 0 : requestCount});
  })();
</script>

<!-- Floating Chat Window for User -->
<div id="userFloatingChat" class="card shadow-lg d-none" style="position: fixed; bottom: 20px; right: 25px; width: 330px; max-width: calc(100vw - 40px); z-index: 1050; border: none; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 40px rgba(0,0,0,0.15) !important;">
    <div class="card-header d-flex justify-content-between align-items-center p-3" style="background: linear-gradient(135deg, #1e1b4b, #312e81);">
        <h6 class="mb-0 fw-bold d-flex align-items-center gap-2 text-white">
            <i class="bi bi-chat-dots-fill text-warning"></i> <span id="userChatTrainerName" class="text-white">Trainer Name</span>
        </h6>
        <button type="button" class="btn-close btn-close-white" onclick="closeUserChat()"></button>
    </div>
    <div class="card-body p-3 overflow-auto" id="userChatMessages" style="height: 350px; background-color: #f4f6fa;">
        <!-- Messages loaded dynamically -->
    </div>
    <div class="card-footer bg-white p-3 border-top">
        <form id="userChatForm" onsubmit="sendUserMessage(event)" class="d-flex gap-2">
            <input type="hidden" id="userChatTrainerId">
            <input type="hidden" id="userChatUserId" value="${user.id}">
            <input type="text" id="userChatInput" class="form-control rounded-pill bg-light border-0 px-3" placeholder="Type a message..." required autocomplete="off">
            <button type="submit" class="btn btn-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; min-width: 40px;"><i class="bi bi-send-fill ms-1"></i></button>
        </form>
    </div>
</div>

<script>
    let userChatPollingInterval;

    function openUserChat(trainerId, trainerName) {
        document.getElementById('userFloatingChat').classList.remove('d-none');
        document.getElementById('userChatTrainerName').innerText = trainerName;
        document.getElementById('userChatTrainerId').value = trainerId;
        
        const userId = document.getElementById('userChatUserId').value;
        fetchUserChatMessages(userId, trainerId);

        if(userChatPollingInterval) clearInterval(userChatPollingInterval);
        userChatPollingInterval = setInterval(() => fetchUserChatMessages(userId, trainerId, false), 3000);
    }

    function closeUserChat() {
        document.getElementById('userFloatingChat').classList.add('d-none');
        if(userChatPollingInterval) clearInterval(userChatPollingInterval);
    }

    function fetchUserChatMessages(userId, trainerId, scrollToBottom = true) {
        fetch(`${pageContext.request.contextPath}/api/fitness/chat/` + userId + `/` + trainerId)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById('userChatMessages');
                const isAtBottom = chatBox.scrollHeight - chatBox.scrollTop === chatBox.clientHeight;
                
                chatBox.innerHTML = '';
                
                data.forEach(msg => {
                    const isMe = (msg.senderType === 'USER');
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

    function sendUserMessage(e) {
        e.preventDefault();
        const userId = document.getElementById('userChatUserId').value;
        const trainerId = document.getElementById('userChatTrainerId').value;
        const input = document.getElementById('userChatInput');
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
                fetchUserChatMessages(userId, trainerId, true);
            }
        });
    }
</script>

</body>
</html>
