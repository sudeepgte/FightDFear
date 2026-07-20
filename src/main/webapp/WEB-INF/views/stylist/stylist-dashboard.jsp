<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stylist Dashboard | Fight D Fear</title>

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

        .welcome-section {
            background: var(--gradient-primary);
            border-radius: 24px;
            padding: 40px;
            color: white;
            margin-bottom: 40px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(124, 45, 94, 0.2);
        }

        .welcome-section::after {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.05);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        .table-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            margin-bottom: 40px;
        }

        .badge-status {
            padding: 6px 12px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
        }

        .btn-action {
            width: 35px;
            height: 35px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            transform: scale(1.1);
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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/stylists/dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/profile">
                <i class="bi bi-person-circle"></i>
                <span>Stylist Profile</span>
            </a>
            <a class="nav-link-custom" href="#bookings">
                <i class="bi bi-calendar-check"></i>
                <span>My Bookings</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/reviews">
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
            
            <!-- Welcome Header -->
            <div class="welcome-section d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-4">
                <div>
                    <h1 class="fw-800 m-0">Hello, ${stylist.firstName}!</h1>
                    <p class="m-0 opacity-75 mt-2">Here's what's happening with your appointments today.</p>
                </div>
                <div class="text-start text-md-end">
                    <div class="badge ${stylist.available ? 'bg-success' : 'bg-danger'} px-3 py-2 rounded-pill mb-3 mb-md-2 d-inline-block">
                        <i class="bi ${stylist.available ? 'bi-check-circle' : 'bi-pause-circle'} me-1"></i>
                        ${stylist.available ? 'Accepting Requests' : 'Currently Offline'}
                    </div>
                    <a href="${pageContext.request.contextPath}/stylists/toggleAvailability" class="btn btn-light btn-sm rounded-pill px-4 py-2 fw-700 d-block d-md-inline-block">
                        Toggle Status
                    </a>
                </div>
            </div>

            <!-- Stats Row -->
            <div class="row g-4 mb-5">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-icon bg-primary text-white">
                            <i class="bi bi-calendar4-event"></i>
                        </div>
                        <h6 class="text-muted fw-600">Total Bookings</h6>
                        <h3 class="fw-800">${stylist.bookings != null ? stylist.bookings.size() : 0}</h3>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-icon bg-success text-white">
                            <i class="bi bi-check2-all"></i>
                        </div>
                        <h6 class="text-muted fw-600">Completed</h6>
                        <h3 class="fw-800">${completedBookings != null ? completedBookings.size() : 0}</h3>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-icon bg-warning text-white">
                            <i class="bi bi-currency-rupee"></i>
                        </div>
                        <h6 class="text-muted fw-600">Total Revenue</h6>
                        <h3 class="fw-800">₹${totalRevenue}</h3>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-icon bg-danger text-white">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                        <h6 class="text-muted fw-600">Pending</h6>
                        <h3 class="fw-800">${pendingBookings != null ? pendingBookings.size() : 0}</h3>
                    </div>
                </div>
            </div>

            <!-- Pending Bookings Table -->
            <div class="table-card" id="bookings">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-800 m-0"><i class="bi bi-clock-history me-2 text-primary"></i>New Requests</h4>
                    <span class="badge bg-soft-primary text-primary px-3 py-2 rounded-pill fw-bold">${pendingBookings.size()} New</span>
                </div>
                
                <c:choose>
                    <c:when test="${not empty pendingBookings}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="border-0 rounded-start">Client</th>
                                        <th class="border-0">Service Requested</th>
                                        <th class="border-0">Appointment Time</th>
                                        <th class="border-0 text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${pendingBookings}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="avatar-sm bg-soft-purple text-purple rounded-circle d-flex align-items-center justify-content-center fw-800" style="width: 40px; height: 40px;">
                                                        ${b.user.fullName != null ? b.user.fullName.substring(0,1) : 'C'}
                                                    </div>
                                                    <div>
                                                        <div class="fw-700">${b.user.fullName != null ? b.user.fullName : b.user.email}</div>
                                                        <small class="text-muted">${b.user.phone}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-600">${b.service.name}</span>
                                            </td>
                                            <td>
                                                <div class="fw-600"><i class="bi bi-calendar3 me-2"></i>${b.bookingTime}</div>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center gap-2">
                                                    <form action="${pageContext.request.contextPath}/stylists/booking/confirm" method="post">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">
                                                            <i class="bi bi-check-lg me-1"></i> Accept
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/stylists/booking/reject" method="post">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                                            Reject
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <img src="https://illustrations.popsy.co/purple/calendar.svg" style="width: 150px;" alt="Empty">
                            <h5 class="mt-4 fw-700 text-muted">No pending requests</h5>
                            <p class="text-muted small">New bookings will appear here once customers book your services.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Confirmed Bookings Table -->
            <div class="table-card">
                <h4 class="fw-800 mb-4"><i class="bi bi-check-circle-fill me-2 text-success"></i>Upcoming Appointments</h4>
                
                <c:choose>
                    <c:when test="${not empty confirmedBookings}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="border-0 rounded-start">Client</th>
                                        <th class="border-0">Service</th>
                                        <th class="border-0">Schedule</th>
                                        <th class="border-0 text-center">Status</th>
                                        <th class="border-0 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${confirmedBookings}">
                                        <tr>
                                            <td>
                                                <div class="fw-700">${b.user.fullName != null ? b.user.fullName : b.user.email}</div>
                                            </td>
                                            <td><span class="fw-600">${b.service.name}</span></td>
                                            <td><div class="fw-600 text-purple">${b.bookingTime}</div></td>
                                            <td class="text-center">
                                                <span class="badge bg-soft-success text-success px-3 py-2 rounded-pill">Confirmed</span>
                                            </td>
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/stylists/booking/complete" method="post">
                                                    <input type="hidden" name="bookingId" value="${b.id}">
                                                    <button type="submit" class="btn btn-purple btn-sm rounded-pill px-4 fw-700">
                                                        Mark Completed
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-muted py-4">No upcoming appointments confirmed yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

