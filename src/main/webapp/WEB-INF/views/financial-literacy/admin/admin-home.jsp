<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Financial Educator Admin Dashboard</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fl-admin.css">

    <style>
        :root {
            --primary-purple: #7C2D5E;
            --primary-purple-light: #a64281;
            --primary-pink: #f43f5e;
            --light-bg: #f8fafc;
            --card-shadow: 0 10px 30px rgba(124, 45, 94, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: #F4F6FA;
            color: #17233D;
        }

        .topbar {
            background: #0B1736;
            color: white;
            padding: 14px 18px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .layout {
            display: flex;
            min-height: calc(100vh - 56px);
        }

        .main {
            flex: 1;
            padding: 24px 20px 40px;
            min-width: 0;
        }

        .mainInner {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Summary Stat Cards */
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(11, 23, 54, 0.08);
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }

        .stat-icon.purple { background: rgba(11, 23, 54, 0.1); color: #0B1736; }
        .stat-icon.pink { background: rgba(255, 59, 92, 0.1); color: #FF3B5C; }
        .stat-icon.blue { background: rgba(14, 165, 233, 0.1); color: #0ea5e9; }
        .stat-icon.gold { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }

        .stat-num {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            color: #0B1736;
            line-height: 1;
            margin-bottom: 4px;
        }

        .stat-label {
            font-size: 0.85rem;
            color: #5B6B86;
            font-weight: 500;
            margin: 0;
        }

        /* Section Container */
        .admin-card {
            background: white;
            border-radius: 20px;
            padding: 26px;
            box-shadow: var(--card-shadow);
            margin-bottom: 28px;
            border: 1px solid rgba(11, 23, 54, 0.08);
        }

        .admin-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 22px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .admin-card-header h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.35rem;
            color: #0B1736;
            margin: 0;
        }

        .btn-purple {
            background: #0B1736;
            color: white;
            border: none;
            padding: 9px 18px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-purple:hover {
            background: #FF3B5C;
            color: white;
            transform: translateY(-2px);
        }

        /* Module Item Card */
        .module-item-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            transition: all 0.2s ease;
        }

        .module-item-card:hover {
            border-color: rgba(11, 23, 54, 0.3);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        .item-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            color: #0B1736;
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .item-meta {
            font-size: 0.85rem;
            color: #5B6B86;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .item-meta i {
            color: #FF3B5C;
            width: 16px;
        }

        .item-desc {
            font-size: 0.88rem;
            color: #475569;
            margin-top: 10px;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Empty State */
        .empty-dashboard-state {
            text-align: center;
            padding: 45px 20px;
            background: #f8fafc;
            border-radius: 16px;
            border: 2px dashed #cbd5e1;
        }

        .empty-dashboard-state i {
            font-size: 2.8rem;
            color: #94a3b8;
            margin-bottom: 12px;
        }

        .empty-dashboard-state p {
            color: #64748b;
            font-weight: 500;
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {
            .layout { flex-direction: column; }
            .main { padding: 16px 12px 24px; }
            .admin-card { padding: 18px 14px; }
        }
    </style>
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container">
            <div class="d-flex align-items-center justify-content-between">
                <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="text-decoration-none text-white fw-bold">
                    <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                </a>
                <h5 class="mb-0 d-none d-md-block">Financial Educator Management Dashboard</h5>
            </div>
        </div>
    </div>

    <!-- Layout -->
    <div class="layout">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

        <!-- Main Content -->
        <main class="main">
            <div class="mainInner">

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show mb-4 rounded-3 shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-3 shadow-sm" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Dashboard Title Header -->
                <div class="mb-4">
                    <h2 class="fw-bold mb-1" style="font-family: 'Montserrat', sans-serif; color: #0f172a;">Financial Educator Dashboard</h2>
                    <p class="text-muted small mb-0">Manage your financial education videos, live sessions, and offline workshops.</p>
                </div>

                <!-- Top Summary Statistics Area -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon purple">
                                <i class="fas fa-video"></i>
                            </div>
                            <div>
                                <div class="stat-num">${videoCount != null ? videoCount : 0}</div>
                                <div class="stat-label">Recorded Videos</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon pink">
                                <i class="fas fa-broadcast-tower"></i>
                            </div>
                            <div>
                                <div class="stat-num">${liveCount != null ? liveCount : 0}</div>
                                <div class="stat-label">Live Sessions</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon blue">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <div>
                                <div class="stat-num">${workshopCount != null ? workshopCount : 0}</div>
                                <div class="stat-label">Offline Workshops</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="stat-card">
                            <div class="stat-icon gold">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div>
                                <div class="stat-num">${upcomingCount != null ? upcomingCount : 0}</div>
                                <div class="stat-label">Upcoming Sessions</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 1. Recorded Videos Section -->
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3><i class="fas fa-play-circle me-2 text-primary"></i>Recorded Videos</h3>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="btn-purple">
                            <i class="fas fa-plus"></i> Add Recorded Video
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty videos}">
                            <div class="row g-3">
                                <c:forEach var="video" items="${videos}">
                                    <div class="col-12 col-md-6 col-lg-4">
                                        <div class="module-item-card">
                                            <div>
                                                <div class="d-flex align-items-center justify-content-between mb-2">
                                                    <span class="badge bg-purple text-white px-3 py-2 rounded-pill small fw-bold">
                                                        <c:choose>
                                                            <c:when test="${video.category eq 'Others' and not empty video.customCategory}">
                                                                ${video.customCategory}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${video.category}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <i class="fas fa-film text-muted"></i>
                                                </div>
                                                <div class="item-title">${video.title}</div>
                                                <p class="item-desc">${video.description}</p>
                                            </div>

                                            <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                                <c:choose>
                                                    <c:when test="${empty video.videoUrl}">
                                                        <span class="btn btn-sm btn-light text-muted disabled"><i class="fas fa-video-slash me-1"></i> No URL</span>
                                                    </c:when>
                                                    <c:when test="${not fn:startsWith(video.videoUrl, 'http')}">
                                                        <a href="${pageContext.request.contextPath}${fn:startsWith(video.videoUrl, '/') ? '' : '/'}${video.videoUrl}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill">
                                                            <i class="fas fa-play me-1"></i> Watch
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${video.videoUrl}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill">
                                                            <i class="fas fa-play me-1"></i> Watch
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-video/${video.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Video">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-video/${video.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this recorded video?');">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Video">
                                                            <i class="fas fa-trash-alt"></i> Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-dashboard-state">
                                <i class="fas fa-video"></i>
                                <p class="mb-2">No recorded videos yet</p>
                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="btn btn-purple btn-sm">
                                    <i class="fas fa-plus me-1"></i> Add Recorded Video
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 2. Live Sessions Section -->
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3><i class="fas fa-broadcast-tower me-2 text-danger"></i>Live Sessions</h3>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="btn-purple">
                            <i class="fas fa-plus"></i> Add Live Session
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty liveSessions}">
                            <div class="row g-3">
                                <c:forEach var="session" items="${liveSessions}">
                                    <div class="col-12 col-md-6 col-lg-4">
                                        <div class="module-item-card">
                                            <div>
                                                <div class="d-flex align-items-center justify-content-between mb-2">
                                                    <span class="badge bg-secondary px-3 py-2 rounded-pill small fw-bold">
                                                        <c:choose>
                                                            <c:when test="${session.category eq 'Others' and not empty session.customCategory}">
                                                                ${session.customCategory}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${session.category}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>

                                                    <!-- Dynamic Status Badge -->
                                                    <c:choose>
                                                        <c:when test="${session.sessionStatus eq 'LIVE NOW'}">
                                                            <span class="badge bg-danger text-white px-2 py-1 rounded-pill small"><i class="fas fa-circle me-1 blink"></i> Live Now</span>
                                                        </c:when>
                                                        <c:when test="${session.sessionStatus eq 'COMPLETED'}">
                                                            <span class="badge bg-secondary text-white px-2 py-1 rounded-pill small"><i class="fas fa-check-circle me-1"></i> Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark px-2 py-1 rounded-pill small"><i class="fas fa-calendar-alt me-1"></i> Upcoming</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="item-title">${session.title}</div>
                                                
                                                <div class="item-meta">
                                                    <i class="fas fa-user-tie"></i>
                                                    <span><strong>Speaker:</strong> ${session.speaker}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-calendar-day"></i>
                                                    <span>${session.formattedDate != null ? session.formattedDate : session.date}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-clock"></i>
                                                    <span>${session.formattedTime != null ? session.formattedTime : session.time}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-chair"></i>
                                                    <span class="text-success fw-bold">${session.seatsLeft} seats available</span>
                                                    <span class="text-muted small">(${session.seats} total)</span>
                                                </div>
                                            </div>

                                            <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                                <a href="${pageContext.request.contextPath}/financial-literacy/live-session/${session.id}" class="btn btn-sm btn-outline-primary rounded-pill">
                                                    <i class="fas fa-eye me-1"></i> View Session
                                                </a>

                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-live-session/${session.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Session">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-live-session/${session.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this live session?');">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Session">
                                                            <i class="fas fa-trash-alt"></i> Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-dashboard-state">
                                <i class="fas fa-calendar-check"></i>
                                <p class="mb-2">No live sessions added yet</p>
                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="btn btn-purple btn-sm">
                                    <i class="fas fa-plus me-1"></i> Add Live Session
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 3. Offline Workshops Section -->
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3><i class="fas fa-map-marker-alt me-2 text-primary"></i>Offline Workshops</h3>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="btn-purple">
                                <i class="fas fa-plus"></i> Add Workshop
                            </a>
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations" class="btn-purple" style="background: #0f172a;">
                                <i class="fas fa-users me-1"></i> View Registrations
                            </a>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty workshops}">
                            <div class="row g-3">
                                <c:forEach var="workshop" items="${workshops}">
                                    <div class="col-12 col-md-6 col-lg-4">
                                        <div class="module-item-card">
                                            <div>
                                                <div class="d-flex align-items-center justify-content-between mb-2">
                                                    <span class="badge bg-secondary px-3 py-2 rounded-pill small fw-bold">
                                                        ${workshop.category}
                                                    </span>
                                                    <span class="badge bg-warning text-dark px-2 py-1 rounded-pill small">
                                                        <i class="fas fa-map-pin me-1"></i> Offline
                                                    </span>
                                                </div>

                                                <div class="item-title">${workshop.title}</div>
                                                
                                                <div class="item-meta">
                                                    <i class="fas fa-location-dot"></i>
                                                    <span>${workshop.city != null ? workshop.city : workshop.venue}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-calendar-day"></i>
                                                    <span>${workshop.date}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-clock"></i>
                                                    <span>${workshop.time}</span>
                                                </div>
                                                <div class="item-meta">
                                                    <i class="fas fa-chair"></i>
                                                    <span class="text-success fw-bold">${workshop.seatsLeft != null ? workshop.seatsLeft : workshop.seats} seats available</span>
                                                </div>
                                            </div>

                                            <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                                <a href="${pageContext.request.contextPath}/financial-literacy/workshop/${workshop.id}" class="btn btn-sm btn-outline-primary rounded-pill">
                                                    <i class="fas fa-eye me-1"></i> View Details
                                                </a>

                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-workshop/${workshop.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Workshop">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-workshop/${workshop.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this offline workshop?');">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Workshop">
                                                            <i class="fas fa-trash-alt"></i> Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-dashboard-state">
                                <i class="fas fa-map-marker-alt"></i>
                                <p class="mb-2">No workshops added yet</p>
                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="btn btn-purple btn-sm">
                                    <i class="fas fa-plus me-1"></i> Add Workshop
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>

</body>
</html>