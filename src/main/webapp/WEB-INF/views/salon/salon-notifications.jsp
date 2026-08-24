<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Fight D Fear</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--light-bg, #f8f9fa);
        }
        
        .notification-card {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 15px;
            padding: 20px;
            display: flex;
            align-items: flex-start;
            transition: all 0.3s ease;
        }
        
        .notification-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 77, 77, 0.1);
            color: var(--primary-color, #ff4d4d);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-right: 20px;
            flex-shrink: 0;
        }
        
        .notification-content h6 {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .notification-content p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.95rem;
        }
        
        .notification-time {
            font-size: 0.8rem;
            color: #adb5bd;
            margin-left: auto;
            white-space: nowrap;
        }
        
        /* Sidebar layout adjustment */
        :root { --sidebar-width: 280px; }
        .sidebar { background: var(--gradient-dark); color: white; width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        
        .main-content {
            padding: 25px;
            margin-left: var(--sidebar-width);
        }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value=""/>
</jsp:include>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Notifications</h2>
                <p class="text-muted mb-0">Stay updated with your latest alerts and activities.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/salons/dashboard" class="btn btn-outline-secondary rounded-pill px-4">
                    <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="text-center py-5">
                            <i class="bi bi-bell-slash text-muted" style="font-size: 4rem;"></i>
                            <h4 class="mt-3 fw-bold text-secondary">No Notifications</h4>
                            <p class="text-muted">You're all caught up! New notifications will appear here.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="notif" items="${notifications}">
                            <div class="notification-card">
                                <div class="notification-icon">
                                    <i class="bi bi-bell-fill"></i>
                                </div>
                                <div class="notification-content">
                                    <h6>${notif.title}</h6>
                                    <p>${notif.message}</p>
                                </div>
                                <div class="notification-time">
                                    <i class="bi bi-clock me-1"></i>
                                    ${notif.timestamp.toLocalDate()} ${notif.timestamp.toLocalTime().toString().substring(0, 5)}
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

