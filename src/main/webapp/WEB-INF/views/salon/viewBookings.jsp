<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings | Fight D Fear</title>

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

        .glass-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }

        .page-header {
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-header h2 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin: 0;
        }

        .table-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
        }

        .table-custom thead th {
            background: #f8f5ff;
            border: none;
            color: var(--brand-purple);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 15px;
        }

        .table-custom tbody tr {
            background: white;
            transition: all 0.3s ease;
        }

        .table-custom tbody tr:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .table-custom tbody td {
            border: none;
            padding: 20px 15px;
            vertical-align: middle;
            font-size: 0.9rem;
            font-weight: 500;
            border-top: 1px solid #f1f3f5;
            border-bottom: 1px solid #f1f3f5;
        }

        .table-custom tbody td:first-child {
            border-left: 1px solid #f1f3f5;
            border-radius: 15px 0 0 15px;
        }

        .table-custom tbody td:last-child {
            border-right: 1px solid #f1f3f5;
            border-radius: 0 15px 15px 0;
        }

        .badge-status {
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
        }

        .badge-confirmed { background: rgba(32, 201, 151, 0.1); color: #157347; }
        .badge-rejected { background: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .badge-pending { background: rgba(255, 193, 7, 0.1); color: #b8860b; }
        .badge-completed { background: rgba(13, 110, 253, 0.1); color: #0d6efd; }
        .badge-cancelled { background: rgba(108, 117, 125, 0.1); color: #6c757d; }

        .btn-action-pill {
            padding: 6px 15px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.8rem;
            border: none;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-confirm { background: #e6f9f4; color: #157347; }
        .btn-confirm:hover { background: #157347; color: white; }
        .btn-reject { background: #fff5f5; color: #dc3545; }
        .btn-reject:hover { background: #dc3545; color: white; }
        .btn-complete { background: #e7f1ff; color: #0d6efd; }
        .btn-complete:hover { background: #0d6efd; color: white; }
        .btn-cancel { background: #f8f9fa; color: #6c757d; }
        .btn-cancel:hover { background: #6c757d; color: white; }

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
                <h2>Customer Bookings</h2>
                <div class="d-flex gap-2">
                    <span class="badge bg-white text-dark border p-2 rounded-3"><i class="bi bi-info-circle me-2"></i> Manage your appointments here</span>
                </div>
            </div>

            <c:if test="${empty bookings and empty offerBookings}">
                <div class="glass-card text-center py-5">
                    <i class="bi bi-calendar-x text-muted" style="font-size: 3rem;"></i>
                    <h4 class="mt-3 fw-bold">No Bookings Yet</h4>
                    <p class="text-muted">Once customers start booking your services, they will appear here.</p>
                </div>
            </c:if>

            <c:set var="hasService" value="false" />
            <c:set var="hasTreatment" value="false" />
            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.service ne null}"><c:set var="hasService" value="true" /></c:if>
                <c:if test="${b.treatment ne null}"><c:set var="hasTreatment" value="true" /></c:if>
            </c:forEach>

            <!-- Service Bookings -->
            <c:if test="${hasService}">
                <div class="glass-card">
                    <h5 class="fw-bold mb-4 text-purple"><i class="bi bi-scissors me-2"></i> Service Appointments</h5>
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Customer</th>
                                    <th>Service</th>
                                    <th>Schedule</th>
                                    <th>Price</th>
                                    <th>Emergency</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <c:if test="${b.service ne null}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${b.user.fullName}</div>
                                                <div class="small text-muted">${b.bookingType}</div>
                                            </td>
                                            <td>${b.service.name}</td>
                                            <td>
                                                <div class="fw-bold">${b.bookingDate}</div>
                                                <div class="small text-muted">${b.preferredTime}</div>
                                            </td>
                                            <td class="fw-bold text-success">₹${b.price}</td>
                                            <td><span class="small">${b.emergencyContact}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'CONFIRMED'}"><span class="badge-status badge-confirmed">Confirmed</span></c:when>
                                                    <c:when test="${b.status eq 'REJECTED'}"><span class="badge-status badge-rejected">Rejected</span></c:when>
                                                    <c:when test="${b.status eq 'COMPLETED'}"><span class="badge-status badge-completed">Completed</span></c:when>
                                                    <c:when test="${b.status eq 'CANCELLED'}"><span class="badge-status badge-cancelled">Cancelled</span></c:when>
                                                    <c:otherwise><span class="badge-status badge-pending">Pending</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex gap-2 justify-content-end">
                                                    <c:if test="${b.status eq 'PENDING'}">
                                                        <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                            <input type="hidden" name="bookingId" value="${b.id}">
                                                            <input type="hidden" name="bookingType" value="NORMAL">
                                                            <input type="hidden" name="status" value="CONFIRMED">
                                                            <button type="submit" class="btn-action-pill btn-confirm"><i class="bi bi-check-circle"></i> Confirm</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                            <input type="hidden" name="bookingId" value="${b.id}">
                                                            <input type="hidden" name="bookingType" value="NORMAL">
                                                            <input type="hidden" name="status" value="REJECTED">
                                                            <button type="submit" class="btn-action-pill btn-reject"><i class="bi bi-x-circle"></i> Reject</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${b.status eq 'CONFIRMED'}">
                                                        <c:if test="${b.bookingDate le today}">
                                                            <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                                <input type="hidden" name="bookingType" value="NORMAL">
                                                                <input type="hidden" name="status" value="COMPLETED">
                                                                <button type="submit" class="btn-action-pill btn-complete"><i class="bi bi-check2-all"></i> Complete</button>
                                                            </form>
                                                        </c:if>
                                                        <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                            <input type="hidden" name="bookingId" value="${b.id}">
                                                            <input type="hidden" name="bookingType" value="NORMAL">
                                                            <input type="hidden" name="status" value="CANCELLED">
                                                            <button type="submit" class="btn-action-pill btn-cancel"><i class="bi bi-slash-circle"></i> Cancel</button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- Treatment Bookings -->
            <c:if test="${hasTreatment}">
                <div class="glass-card">
                    <h5 class="fw-bold mb-4 text-purple"><i class="bi bi-droplet me-2"></i> Treatment Appointments</h5>
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Customer</th>
                                    <th>Treatment</th>
                                    <th>Schedule</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <c:if test="${b.treatment ne null}">
                                        <tr>
                                            <td><div class="fw-bold text-dark">${b.user.fullName}</div></td>
                                            <td>${b.treatment.serviceName}</td>
                                            <td>
                                                <div class="fw-bold">${b.bookingDate}</div>
                                                <div class="small text-muted">${b.preferredTime}</div>
                                            </td>
                                            <td class="fw-bold text-success">₹${b.price}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'CONFIRMED'}"><span class="badge-status badge-confirmed">Confirmed</span></c:when>
                                                    <c:when test="${b.status eq 'REJECTED'}"><span class="badge-status badge-rejected">Rejected</span></c:when>
                                                    <c:when test="${b.status eq 'COMPLETED'}"><span class="badge-status badge-completed">Completed</span></c:when>
                                                    <c:when test="${b.status eq 'CANCELLED'}"><span class="badge-status badge-cancelled">Cancelled</span></c:when>
                                                    <c:otherwise><span class="badge-status badge-pending">Pending</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                    <div class="d-flex gap-2 justify-content-end">
                                                        <c:if test="${b.status eq 'PENDING'}">
                                                            <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                                <input type="hidden" name="bookingType" value="NORMAL">
                                                                <input type="hidden" name="status" value="CONFIRMED">
                                                                <button type="submit" class="btn-action-pill btn-confirm"><i class="bi bi-check-circle"></i> Confirm</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                                <input type="hidden" name="bookingType" value="NORMAL">
                                                                <input type="hidden" name="status" value="REJECTED">
                                                                <button type="submit" class="btn-action-pill btn-reject"><i class="bi bi-x-circle"></i> Reject</button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${b.status eq 'CONFIRMED'}">
                                                            <c:if test="${b.bookingDate le today}">
                                                                <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                                    <input type="hidden" name="bookingId" value="${b.id}">
                                                                    <input type="hidden" name="bookingType" value="NORMAL">
                                                                    <input type="hidden" name="status" value="COMPLETED">
                                                                    <button type="submit" class="btn-action-pill btn-complete"><i class="bi bi-check2-all"></i> Complete</button>
                                                                </form>
                                                            </c:if>
                                                            <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                                <input type="hidden" name="bookingId" value="${b.id}">
                                                                <input type="hidden" name="bookingType" value="NORMAL">
                                                                <input type="hidden" name="status" value="CANCELLED">
                                                                <button type="submit" class="btn-action-pill btn-cancel"><i class="bi bi-slash-circle"></i> Cancel</button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- Offer Bookings -->
            <c:if test="${not empty offerBookings}">
                <div class="glass-card">
                    <h5 class="fw-bold mb-4 text-purple"><i class="bi bi-gift me-2"></i> Claimed Promotions</h5>
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>Customer</th>
                                    <th>Promotion Title</th>
                                    <th>Details</th>
                                    <th>Schedule</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${offerBookings}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark">${b.user.fullName}</div>
                                            <div class="small text-muted">${b.user.email}</div>
                                        </td>
                                        <td><div class="fw-bold">${b.offer.title}</div></td>
                                        <td>
                                            <div class="small text-muted">${b.offer.description}</div>
                                            <div class="badge bg-gold text-dark fw-bold mt-1">${b.offer.discountPercent}% OFF</div>
                                        </td>
                                        <td>
                                            <div class="small fw-bold text-dark">${b.date}</div>
                                            <div class="small text-muted">${b.time}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.status eq 'CONFIRMED'}"><span class="badge-status badge-confirmed">Confirmed</span></c:when>
                                                <c:when test="${b.status eq 'REJECTED'}"><span class="badge-status badge-rejected">Rejected</span></c:when>
                                                <c:when test="${b.status eq 'COMPLETED'}"><span class="badge-status badge-completed">Completed</span></c:when>
                                                <c:when test="${b.status eq 'CANCELLED'}"><span class="badge-status badge-cancelled">Cancelled</span></c:when>
                                                <c:otherwise><span class="badge-status badge-pending">Pending</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-flex gap-2 justify-content-end">
                                                <c:if test="${b.status eq 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <input type="hidden" name="bookingType" value="OFFER">
                                                        <input type="hidden" name="status" value="CONFIRMED">
                                                        <button type="submit" class="btn-action-pill btn-confirm"><i class="bi bi-check-circle"></i> Confirm</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <input type="hidden" name="bookingType" value="OFFER">
                                                        <input type="hidden" name="status" value="REJECTED">
                                                        <button type="submit" class="btn-action-pill btn-reject"><i class="bi bi-x-circle"></i> Reject</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${b.status eq 'CONFIRMED'}">
                                                    <c:if test="${b.date le today}">
                                                        <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                            <input type="hidden" name="bookingId" value="${b.id}">
                                                            <input type="hidden" name="bookingType" value="OFFER">
                                                            <input type="hidden" name="status" value="COMPLETED">
                                                            <button type="submit" class="btn-action-pill btn-complete"><i class="bi bi-check2-all"></i> Complete</button>
                                                        </form>
                                                    </c:if>
                                                    <form action="${pageContext.request.contextPath}/booking/updateStatus" method="post">
                                                        <input type="hidden" name="bookingId" value="${b.id}">
                                                        <input type="hidden" name="bookingType" value="OFFER">
                                                        <input type="hidden" name="status" value="CANCELLED">
                                                        <button type="submit" class="btn-action-pill btn-cancel"><i class="bi bi-slash-circle"></i> Cancel</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



