<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Promotions | Fight D Fear</title>

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

        .nav-link-custom i {
            font-size: 1.2rem;
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
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .offer-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .offer-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.05);
            border-color: var(--brand-gold);
        }

        .discount-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: var(--brand-gold);
            color: var(--brand-purple-darker);
            font-weight: 800;
            padding: 8px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.3);
        }

        .offer-title {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin-bottom: 15px;
            padding-right: 80px;
        }

        .offer-desc {
            color: var(--fdf-muted);
            font-size: 0.9rem;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .price-tag {
            background: #f8f5ff;
            padding: 15px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .strike-price {
            text-decoration: line-through;
            color: #888;
            font-size: 0.9rem;
        }

        .final-price {
            color: #157347;
            font-weight: 800;
            font-size: 1.4rem;
        }

        .validity-info {
            font-size: 0.8rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }

        .btn-add-offer {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-add-offer:hover {
            filter: brightness(1.1);
            color: white;
            transform: translateY(-2px);
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

        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i>
            <span>Fight D Fear</span>
        </a>

        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                <i class="bi bi-person-circle"></i>
                <span>Salon Profile</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                <i class="bi bi-calendar-check"></i>
                <span>Manage Bookings</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Our Services</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                <i class="bi bi-star-half"></i>
                <span>Customer Reviews</span>
            </a>
            <div class="mt-5">
                <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/salons/logout">
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
                <div>
                    <h2 class="fw-800">Salon Promotions</h2>
                    <p class="text-muted mb-0">Create and manage exclusive deals for your clients.</p>
                </div>
                <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salonId}" class="btn-add-offer">
                    <i class="bi bi-plus-lg"></i>
                    New Promotion
                </a>
            </div>

            <c:if test="${empty offers}">
                <div class="text-center py-5 bg-white rounded-4 border">
                    <i class="bi bi-percent text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-4 fw-bold">No Active Offers</h4>
                    <p class="text-muted">Boost your bookings by creating limited-time promotions.</p>
                    <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salonId}" class="btn btn-purple rounded-pill px-4">Create First Offer</a>
                </div>
            </c:if>

            <div class="row g-4">
                <c:forEach var="offer" items="${offers}">
                    <div class="col-xl-4 col-md-6">
                        <div class="offer-card">
                            <div class="discount-badge">${offer.discountPercent}% OFF</div>
                            <h4 class="offer-title">${offer.title}</h4>
                            <p class="offer-desc">${offer.description}</p>
                            
                            <div class="price-tag">
                                <div class="final-price">₹${offer.offerPrice}</div>
                                <div class="strike-price">₹${offer.originalPrice}</div>
                            </div>

                            <div class="validity-info">
                                <i class="bi bi-calendar-event"></i>
                                <span>Valid: ${offer.startDate} to ${offer.endDate}</span>
                            </div>

                            <div class="d-flex gap-2">
                                <button class="btn btn-sm btn-outline-danger w-100 rounded-pill py-2 fw-bold disabled">Archive Offer</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

