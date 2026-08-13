<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Reviews | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f5ff;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--brand-purple-darker);
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar */
        .sidebar {
            background: var(--gradient-dark);
            color: white;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            text-decoration: none;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 10px 0 30px rgba(0,0,0,0.1);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .page-header {
            margin-bottom: 40px;
        }

        .review-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(124, 45, 94, 0.08);
            border-color: var(--brand-pink-light);
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            background: var(--gradient-primary);
            color: white;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .rating-stars {
            color: #ffc107;
            font-size: 1rem;
            display: flex;
            gap: 3px;
        }

        .review-content {
            font-size: 1rem;
            color: #495057;
            line-height: 1.7;
            margin: 15px 0;
            font-style: italic;
        }

        .review-date {
            font-size: 0.85rem;
            color: #adb5bd;
            font-weight: 600;
        }

        .rating-summary-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 40px;
        }

        .big-rating {
            font-size: 4rem;
            font-weight: 900;
            color: var(--brand-purple-darker);
            line-height: 1;
        }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar { padding: 20px; }
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
        }

        .mobile-header {
            background: var(--gradient-dark);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold d-flex align-items-center gap-2"><i class="bi bi-stars"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 2rem;"></i>
        </button>
    </div>

    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="offcanvas-header d-lg-none border-bottom border-secondary mb-3 pb-3">
            <h5 class="offcanvas-title text-white fw-bold"><i class="bi bi-stars"></i> Fight D Fear</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebarMenu"></button>
        </div>

        <a href="${pageContext.request.contextPath}/stylists/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i>
            <span>Fight D Fear</span>
        </a>

        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/profile">
                <i class="bi bi-person-circle"></i>
                <span>Stylist Profile</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard#bookings">
                <i class="bi bi-calendar-check"></i>
                <span>My Bookings</span>
            </a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/stylists/reviews">
                <i class="bi bi-star-half"></i>
                <span>Client Reviews</span>
            </a>
            <div class="mt-5">
                <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/stylists/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </div>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <h2 class="fw-800 m-0">Customer Feedback</h2>
                <p class="text-muted">Real reviews from clients you've served.</p>
            </div>

            <div class="rating-summary-card">
                <div class="text-center">
                    <div class="big-rating">${avgRating}</div>
                    <div class="rating-stars justify-content-center mt-2">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="bi bi-star-fill ${i <= avgRating ? '' : 'text-light-grey'}"></i>
                        </c:forEach>
                    </div>
                </div>
                <div>
                    <h4 class="fw-800 m-0 text-purple">Overall Satisfaction</h4>
                    <p class="text-muted m-0">Based on ${reviews.size()} verified customer ratings.</p>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="row">
                        <div class="col-lg-10">
                            <c:forEach var="r" items="${reviews}">
                                <div class="review-card">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="d-flex gap-3 align-items-center">
                                            <div class="user-avatar">
                                                ${r.user.fullName != null ? r.user.fullName.substring(0,1).toUpperCase() : 'C'}
                                            </div>
                                            <div>
                                                <h5 class="fw-800 m-0 text-dark">${r.user.fullName != null ? r.user.fullName : r.user.email}</h5>
                                                <div class="rating-stars mt-1">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="bi bi-star-fill ${i <= r.rating ? '' : 'text-light-grey'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="review-date">
                                            <i class="bi bi-clock me-1"></i> ${r.createdAt}
                                        </div>
                                    </div>
                                    <div class="review-content">
                                        "${r.comment}"
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5 bg-white rounded-5 border">
                        <i class="bi bi-chat-left-dots text-muted" style="font-size: 4rem;"></i>
                        <h4 class="mt-4 fw-800">No Reviews Yet</h4>
                        <p class="text-muted">Complete appointments and provide excellent service to start receiving feedback!</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

