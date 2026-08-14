<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Dashboard | Fight D Fear</title>

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

        .welcome-banner {
            background: var(--gradient-primary);
            border-radius: 24px;
            padding: 40px;
            color: white;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(124, 45, 94, 0.2);
        }

        .welcome-banner h2 {
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .welcome-banner::after {
            content: '';
            position: absolute;
            right: -100px;
            top: -100px;
            width: 300px;
            height: 300px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        /* Dashboard Cards */
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 30px rgba(0,0,0,0.05);
            border-color: var(--brand-pink-light);
        }

        .icon-box {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .card-title-custom {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 10px;
            color: var(--brand-purple-darker);
        }

        .card-desc {
            font-size: 0.9rem;
            color: var(--fdf-muted);
            margin-bottom: 20px;
        }

        .btn-action {
            width: 100%;
            padding: 10px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border: none;
        }

        /* Colors */
        .bg-glass-purple { background: rgba(30, 27, 75, 0.1); color: var(--brand-purple); }
        .bg-glass-pink { background: rgba(219, 39, 119, 0.1); color: var(--brand-pink); }
        .bg-glass-gold { background: rgba(255, 215, 0, 0.1); color: #b8860b; }
        .bg-glass-teal { background: rgba(32, 201, 151, 0.1); color: #157347; }

        .btn-purple { background: var(--brand-purple); color: white; }
        .btn-purple:hover { background: var(--brand-purple-dark); color: white; }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar { padding: 20px; }
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; }
            .welcome-banner { padding: 30px 20px; }
            .welcome-banner h2 { font-size: 1.8rem; }
            .stat-card { padding: 20px; }
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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salons/dashboard">
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
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/treatments/view">
                <i class="bi bi-droplet-half"></i>
                <span>Specialized Treatments</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
                <i class="bi bi-percent"></i>
                <span>Offers & Promotions</span>
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
            
            <div class="welcome-banner">
                <h2>Hello, <c:out value="${salon.name}"/>!</h2>
                <p>Welcome back to your partner dashboard. Here's what's happening today.</p>
            </div>

            <div class="row g-4 mb-5">
                <!-- Bookings -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-purple">
                                <i class="bi bi-calendar2-week"></i>
                            </div>
                            <h5 class="card-title-custom">Bookings</h5>
                            <p class="card-desc">Review and manage your incoming customer appointments.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/booking/list" class="btn btn-purple btn-action">View All Bookings</a>
                    </div>
                </div>

                <!-- Services -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-pink">
                                <i class="bi bi-flower1"></i>
                            </div>
                            <h5 class="card-title-custom">Services</h5>
                            <p class="card-desc">Update your service menu, pricing, and specialized treatments.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn btn-purple btn-action">Manage Services</a>
                    </div>
                </div>

                <!-- Offers -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-gold">
                                <i class="bi bi-percent"></i>
                            </div>
                            <h5 class="card-title-custom">Promotions</h5>
                            <p class="card-desc">Create enticing offers and discounts for your loyal clients.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}" class="btn btn-purple btn-action">View Offers</a>
                    </div>
                </div>

                <!-- Profile -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-teal">
                                <i class="bi bi-gear-wide-connected"></i>
                            </div>
                            <h5 class="card-title-custom">Settings</h5>
                            <p class="card-desc">Keep your salon information and contact details up to date.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salons/profile" class="btn btn-purple btn-action">Edit Profile</a>
                    </div>
                </div>
            </div>

            <h4 class="fw-bold mb-4">Quick Actions</h4>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="stat-card p-3 flex-row align-items-center gap-3">
                        <div class="icon-box bg-glass-purple mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-plus-lg"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/addService" class="text-decoration-none text-dark fw-semibold stretched-link">Add New Service</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card p-3 flex-row align-items-center gap-3">
                        <div class="icon-box bg-glass-gold mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-tag"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salon.id}" class="text-decoration-none text-dark fw-semibold stretched-link">Create New Offer</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card p-3 flex-row align-items-center gap-3">
                        <div class="icon-box bg-glass-pink mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-droplet"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/treatments/add" class="text-decoration-none text-dark fw-semibold stretched-link">Add Treatment</a>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



