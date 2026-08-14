<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Workshop Registrations - Financial Literacy Admin</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;90&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-purple: #7C2D5E;
            --primary-purple-light: #a64281;
            --primary-pink: #DB2777;
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
            background: white;
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
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Section Card */
        .admin-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(124, 45, 94, 0.1);
        }

        .admin-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--primary-purple);
            margin-bottom: 24px;
        }

        .table {
            font-size: 0.9rem;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .badge-approved {
            background: #d1fae5;
            color: #065f46;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .badge-rejected {
            background: #fee2e2;
            color: #991b1b;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .btn-approve {
            background: #10b981;
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-approve:hover {
            background: #059669;
            color: white;
        }

        .btn-reject {
            background: #ef4444;
            color: white;
            border: none;
            padding: 6px 16px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-reject:hover {
            background: #dc2626;
            color: white;
        }
    </style>
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container">
            <div class="wrap">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="text-decoration-none text-white" style="font-weight: 700;">
                    <i class="fas fa-arrow-left me-2"></i> Back
                </a>
                <h5 class="mb-0">Registrations</h5>
            </div>
        </div>
    </div>

    <!-- Layout -->
    <div class="layout">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="navlink">
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
            <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations" class="navlink active">
                <i class="fas fa-users"></i> View Registrations
            </a>
        </div>

        <!-- Main Content -->
        <main class="main">
            <div class="mainInner">
                
                <div class="admin-card">
                    <ul class="nav nav-tabs mb-4" id="registrationTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="live-tab" data-bs-toggle="tab" data-bs-target="#live" type="button" role="tab" aria-controls="live" aria-selected="true">Live Sessions</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="workshop-tab" data-bs-toggle="tab" data-bs-target="#workshop" type="button" role="tab" aria-controls="workshop" aria-selected="false">Workshops</button>
                        </li>
                    </ul>
                    
                    <div class="tab-content" id="registrationTabsContent">
                        <!-- Live Sessions Tab -->
                        <div class="tab-pane fade show active" id="live" role="tabpanel" aria-labelledby="live-tab">
                            <h3><i class="fas fa-users me-2"></i> Live Session Registrations</h3>
                            
                            <c:if test="${empty liveSessionRegistrations}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No registrations yet</h5>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty liveSessionRegistrations}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Session</th>
                                                <th>Name</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>Occupation</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="registration" items="${liveSessionRegistrations}">
                                                <tr>
                                                    <td>
                                                        <c:forEach var="session" items="${liveSessions}">
                                                            <c:if test="${session.id == registration.sessionId}">
                                                                ${session.title}
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>${registration.fullName}</td>
                                                    <td>${registration.mobile}</td>
                                                    <td>${registration.email}</td>
                                                    <td>${registration.occupation}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registration.status == 'pending'}">
                                                                <span class="badge-pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'approved'}">
                                                                <span class="badge-approved">Approved</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'rejected'}">
                                                                <span class="badge-rejected">Rejected</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${registration.status == 'pending'}">
                                                            <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/approve" method="POST" style="display: inline;">
                                                                <input type="hidden" name="registrationId" value="${registration.id}">
                                                                <input type="hidden" name="type" value="live">
                                                                <button type="submit" class="btn-approve me-2">
                                                                    <i class="fas fa-check"></i> Approve
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/reject" method="POST" style="display: inline;">
                                                                <input type="hidden" name="registrationId" value="${registration.id}">
                                                                <input type="hidden" name="type" value="live">
                                                                <button type="submit" class="btn-reject">
                                                                    <i class="fas fa-times"></i> Reject
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <span class="text-muted">-</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Workshops Tab -->
                        <div class="tab-pane fade" id="workshop" role="tabpanel" aria-labelledby="workshop-tab">
                            <h3><i class="fas fa-users me-2"></i> Workshop Registrations</h3>
                            
                            <c:if test="${empty workshopRegistrations}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">No registrations yet</h5>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty workshopRegistrations}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Workshop</th>
                                                <th>Name</th>
                                                <th>Mobile</th>
                                                <th>Email</th>
                                                <th>City</th>
                                                <th>Occupation</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="registration" items="${workshopRegistrations}">
                                                <tr>
                                                    <td>
                                                        <c:forEach var="workshop" items="${workshops}">
                                                            <c:if test="${workshop.id == registration.workshopId}">
                                                                ${workshop.title}
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>${registration.fullName}</td>
                                                    <td>${registration.mobile}</td>
                                                    <td>${registration.email}</td>
                                                    <td>${registration.city}</td>
                                                    <td>${registration.occupation}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${registration.status == 'pending'}">
                                                                <span class="badge-pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'approved'}">
                                                                <span class="badge-approved">Approved</span>
                                                            </c:when>
                                                            <c:when test="${registration.status == 'rejected'}">
                                                                <span class="badge-rejected">Rejected</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${registration.status == 'pending'}">
                                                            <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/approve" method="POST" style="display: inline;">
                                                                <input type="hidden" name="registrationId" value="${registration.id}">
                                                                <input type="hidden" name="type" value="workshop">
                                                                <button type="submit" class="btn-approve me-2">
                                                                    <i class="fas fa-check"></i> Approve
                                                                </button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/financial-literacy/admin/registration/reject" method="POST" style="display: inline;">
                                                                <input type="hidden" name="registrationId" value="${registration.id}">
                                                                <input type="hidden" name="type" value="workshop">
                                                                <button type="submit" class="btn-reject">
                                                                    <i class="fas fa-times"></i> Reject
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${registration.status != 'pending'}">
                                                            <span class="text-muted">-</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

</body>
</html>
