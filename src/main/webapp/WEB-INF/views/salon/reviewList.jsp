<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reviews | Fight D Fear</title>

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

        .nav-link-custom i {
            font-size: 1.2rem;
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .page-header {
            margin-bottom: 40px;
        }

        .page-header h2 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin: 0;
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
            font-size: 0.9rem;
            display: flex;
            gap: 2px;
        }

        .review-content {
            font-size: 0.95rem;
            color: #495057;
            line-height: 1.6;
            margin: 15px 0;
        }

        .review-date {
            font-size: 0.8rem;
            color: #adb5bd;
            font-weight: 600;
        }

        .salon-reply-container {
            background: #f8f5ff;
            border-radius: 18px;
            padding: 20px;
            margin-top: 20px;
            border-left: 4px solid var(--brand-purple);
        }

        .reply-header {
            font-weight: 800;
            color: var(--brand-purple);
            font-size: 0.8rem;
            text-transform: uppercase;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .reply-form {
            margin-top: 20px;
        }

        .reply-textarea {
            border-radius: 15px;
            border: 2px solid rgba(30, 27, 75, 0.1);
            padding: 15px;
            font-size: 0.9rem;
            resize: none;
            transition: all 0.3s ease;
        }

        .reply-textarea:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
            outline: none;
        }

        .btn-reply {
            background: var(--gradient-dark);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            margin-top: 10px;
            transition: all 0.3s ease;
        }

        .btn-reply:hover {
            transform: translateX(5px);
            filter: brightness(1.2);
        }

        /* Responsive */
        @media (max-width: 991.98px) {
            
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
    
        /* Unified Premium Sidebar */
        .sidebar {
            background: linear-gradient(180deg, var(--fdf-burgundy) 0%, var(--fdf-burgundy-dark) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-brand-wrapper {
            padding: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            margin-bottom: 20px;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.15rem;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sidebar-brand i {
            color: var(--fdf-pink);
            font-size: 1.5rem;
        }

        .sidebar-brand-wrapper .subtitle {
            font-size: 0.72rem;
            color: rgba(255,255,255,0.4);
            margin-top: 4px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .nav-container {
            flex: 1;
            padding: 0 16px;
            overflow-y: auto;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 16px;
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 4px;
            transition: all 0.2s ease;
            font-weight: 500;
            font-size: 0.88rem;
        }

        .nav-link-custom:hover {
            background: rgba(255,255,255,0.05);
            color: white;
            transform: translateX(4px);
        }

        .nav-link-custom.active {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(219, 39, 119, 0.25);
            font-weight: 600;
        }

        .nav-link-custom i {
            font-size: 1.15rem;
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
    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="sidebar-brand-wrapper">
            <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
                <i class="bi bi-gender-female"></i>
                <span>${empty salon.name ? 'Priya Beauty & Wellness' : salon.name}</span>
            </a>
            <div class="subtitle">Women's Salon • Beauty • Wellness • Hair Styling</div>
        </div>

        <div class="nav-container">
            <nav class="nav flex-column">
                <a class="nav-link-custom" active" href="${pageContext.request.contextPath}/salons/dashboard">
                    <i class="bi bi-grid-1x2"></i>
                    <span>Dashboard</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Salon Profile</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                    <i class="bi bi-calendar-check"></i>
                    <span>Appointments</span>
                </a>
                <a class="nav-link-custom" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal">
                    <i class="bi bi-calendar3"></i>
                    <span>Calendar</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                    <i class="bi bi-magic"></i>
                    <span>Services</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists">
                    <i class="bi bi-people"></i>
                    <span>Staff / Stylists</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients">
                    <i class="bi bi-people-fill"></i>
                    <span>Clients</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages">
                    <i class="bi bi-box-seam"></i>
                    <span>Packages & Memberships</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
                    <i class="bi bi-percent"></i>
                    <span>Offers & Discounts</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/billing">
                    <i class="bi bi-receipt"></i>
                    <span>Billing & Invoices</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/payments">
                    <i class="bi bi-credit-card-2-front"></i>
                    <span>Payments & Payouts</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/inventory">
                    <i class="bi bi-box"></i>
                    <span>Inventory</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                    <i class="bi bi-star-half"></i>
                    <span>Reviews & Feedback</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/analytics">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports & Analytics</span>
                </a>

                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/settings">
                    <i class="bi bi-sliders"></i>
                    <span>Settings</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/support">
                    <i class="bi bi-question-circle"></i>
                    <span>Help & Support</span>
                </a>
                <a class="nav-link-custom text-danger mt-3" href="${pageContext.request.contextPath}/salons/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </nav>
        </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <h2>Customer Feedback</h2>
                <p class="text-muted">Manage reviews and interact with your salon guests</p>
            </div>

            <c:if test="${empty reviews}">
                <div class="text-center py-5 bg-white rounded-5 border shadow-sm">
                    <i class="bi bi-chat-heart text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-3 fw-800 text-purple">No Reviews Yet</h4>
                    <p class="text-muted">Your salon's reputation starts here. Encourage customers to leave feedback!</p>
                </div>
            </c:if>

            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="user-avatar">
                                        ${review.userName.substring(0,1).toUpperCase()}
                                    </div>
                                    <div>
                                        <h5 class="fw-800 m-0 text-dark">${review.userName}</h5>
                                        <div class="rating-stars mt-1">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="bi bi-star-fill ${i <= review.rating ? '' : 'text-light-grey'}"></i>
                                            </c:forEach>
                                            <span class="ms-2 small fw-bold text-dark">${review.rating}.0</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="review-date">
                                    <i class="bi bi-clock me-1"></i> ${review.createdAt}
                                </div>
                            </div>

                            <div class="review-content">
                                "${review.comment}"
                            </div>

                            <c:choose>
                                <c:when test="${not empty review.reply}">
                                    <div class="salon-reply-container">
                                        <div class="reply-header">
                                            <i class="bi bi-reply-fill"></i> Your Official Response
                                        </div>
                                        <p class="m-0 text-dark small fw-500">${review.reply}</p>
                                        <div class="text-end mt-2">
                                            <span class="small text-muted fw-600">Replied on ${review.repliedAt}</span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="reply-form">
                                        <form action="${pageContext.request.contextPath}/salon/reviews/reply" method="post">
                                            <input type="hidden" name="reviewId" value="${review.id}">
                                            <textarea name="reply" rows="2" class="form-control reply-textarea" placeholder="Thank your customer or address their concerns..." required></textarea>
                                            <div class="d-flex justify-content-end">
                                                <button type="submit" class="btn-reply">
                                                    Post Response <i class="bi bi-send-fill ms-2"></i>
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


