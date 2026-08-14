<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Financial Literacy - Admin</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-purple: #7C2D5E;
            --primary-purple-light: #a64281;
            --primary-coral: #DB2777;
            --primary-gold: #ffd700;
            --dark-bg: #0f0f1a;
            --light-bg: #fffcfd;
            --light-gray: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: var(--light-bg);
        }

        /* Topbar */
        .topbar {
            background: var(--primary-purple);
            color: white;
            padding: 14px 18px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .topbar .wrap {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Layout */
        .layout {
            display: flex;
            min-height: calc(100vh - 56px);
        }

        .sidebar {
            width: 272px;
            background: #fff;
            border-right: 1px solid rgba(124, 45, 94, 0.18);
            padding: 14px 12px;
            height: calc(100vh - 56px);
            position: sticky;
            top: 56px;
            overflow-y: auto;
            flex-shrink: 0;
        }

        .navlink {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            border-radius: 12px;
            color: #4b5563;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.2s;
            margin-bottom: 2px;
        }

        .navlink:hover {
            background: rgba(124, 45, 94, 0.1);
            color: var(--primary-purple);
        }

        .navlink.active {
            background: var(--primary-purple);
            color: white;
        }

        .main {
            flex: 1;
            padding: 28px 16px 36px;
        }

        .mainInner {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* Section Card */
        .admin-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(124, 45, 94, 0.1);
            margin-bottom: 24px;
        }

        .admin-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--primary-purple);
            margin-bottom: 20px;
        }

        .btn-purple {
            background: var(--primary-purple);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-purple:hover {
            background: var(--primary-purple-light);
            transform: translateY(-2px);
            color: white;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid rgba(124, 45, 94, 0.1);
        }

        th {
            color: var(--primary-purple);
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container">
            <div class="wrap">
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="text-decoration-none text-white" style="font-weight: 700;">
                        <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                    </a>
                </div>
                <h5 class="mb-0">Financial Literacy - Admin Panel</h5>
            </div>
        </div>
    </div>

    <!-- Layout -->
    <div class="layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="navlink active">
                    <i class="fas fa-home"></i> Home
                </a>
            </div>
            
            <h6 class="mb-2" style="font-weight:700; color: #666; font-size: 0.8rem;">Videos</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="navlink">
                <i class="fas fa-plus-circle"></i> Add Video
            </a>
            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Live Sessions</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="navlink">
                <i class="fas fa-video"></i> Add Session
            </a>
            
            <h6 class="mb-2 mt-4" style="font-weight:700; color: #666; font-size: 0.8rem;">Workshops</h6>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="navlink">
                <i class="fas fa-calendar-check"></i> Add Workshop
            </a>
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations" class="navlink">
                <i class="fas fa-users"></i> View Registrations
            </a>
        </div>

        <!-- Main Content -->
        <main class="main">
            <div class="mainInner">
                
                <!-- Videos Section -->
                <div class="admin-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3>Recorded Videos</h3>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="btn-purple">
                            <i class="fas fa-plus me-2"></i> Add Video
                        </a>
                    </div>
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${not empty videos}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Category</th>
                                            <th>Description</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="video" items="${videos}">
                                            <tr>
                                                <td>${video.title}</td>
                                                <td>${video.category}</td>
                                                <td>${video.description}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-video" style="font-size: 3rem; color: #ccc;"></i>
                                    <p class="mt-3 mb-0">No videos added yet</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Live Sessions Section -->
                <div class="admin-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3>Live Sessions</h3>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="btn-purple">
                            <i class="fas fa-plus me-2"></i> Add Session
                        </a>
                    </div>
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${not empty liveSessions}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Speaker</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Seats</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="session" items="${liveSessions}">
                                            <tr>
                                                <td>${session.title}</td>
                                                <td>${session.speaker}</td>
                                                <td>${session.date}</td>
                                                <td>${session.time}</td>
                                                <td>${session.seats}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-check" style="font-size: 3rem; color: #ccc;"></i>
                                    <p class="mt-3 mb-0">No live sessions added yet</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Workshops Section -->
                <div class="admin-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3>Offline Workshops</h3>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="btn-purple">
                                <i class="fas fa-plus me-2"></i> Add Workshop
                            </a>
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations" class="btn-purple" style="background: #0f172a;">
                                <i class="fas fa-users me-2"></i> View Registrations
                            </a>
                        </div>
                    </div>
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${not empty workshops}">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Venue</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Seats</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="workshop" items="${workshops}">
                                            <tr>
                                                <td>${workshop.title}</td>
                                                <td>${workshop.venue}</td>
                                                <td>${workshop.date}</td>
                                                <td>${workshop.time}</td>
                                                <td>${workshop.seats}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-map-marker-alt" style="font-size: 3rem; color: #ccc;"></i>
                                    <p class="mt-3 mb-0">No workshops added yet</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </main>
    </div>

</body>
</html>