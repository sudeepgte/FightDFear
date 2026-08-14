<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Treatment Catalog | Fight D Fear</title>

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

        .btn-add {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-add:hover {
            filter: brightness(1.1);
            color: white;
            transform: translateY(-2px);
        }

        .btn-action-sm {
            width: 35px;
            height: 35px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-edit { background: rgba(255, 193, 7, 0.1); color: #b8860b; }
        .btn-edit:hover { background: #ffc107; color: black; }
        .btn-delete { background: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .btn-delete:hover { background: #dc3545; color: white; }

        .category-pill {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .pill-hair { background: #e0f2fe; color: #0369a1; }
        .pill-skin { background: #fdf2f8; color: #9d174d; }

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
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/treatments/view">
                <i class="bi bi-droplet-half"></i>
                <span>Specialized Treatments</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}">
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
            
            <div class="page-header">
                <div>
                    <h2 class="fw-800">Specialized Treatments</h2>
                    <p class="text-muted mb-0">Manage your high-end skin and hair treatment procedures.</p>
                </div>
                <a href="${pageContext.request.contextPath}/salon/treatments/add" class="btn-add">
                    <i class="bi bi-plus-lg"></i>
                    New Treatment
                </a>
            </div>

            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Treatment Details</th>
                                <th>Category</th>
                                <th>Specialization</th>
                                <th>Schedule</th>
                                <th>Pricing</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${treatments}" varStatus="status">
                                <tr>
                                    <td class="text-muted fw-bold">${status.index + 1}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${t.serviceName}</div>
                                        <div class="small text-muted" style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                            ${t.description}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="category-pill ${t.category == 'Hair' ? 'pill-hair' : 'pill-skin'}">
                                            ${t.category}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="small fw-bold">${t.treatmentType}</div>
                                        <div class="small text-muted">${t.skinType}</div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-1">
                                            <i class="bi bi-clock small text-purple"></i>
                                            <span class="fw-bold">${t.duration}</span>
                                            <span class="small text-muted">min</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-success">₹${t.price}</span>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-flex gap-2 justify-content-end">
                                            <a href="${pageContext.request.contextPath}/salon/treatments/edit/${t.id}" class="btn-action-sm btn-edit" title="Edit">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/salon/treatments/delete/${t.id}" class="btn-action-sm btn-delete" title="Delete" onclick="return confirm('Are you sure you want to remove this treatment?')">
                                                <i class="bi bi-trash3-fill"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty treatments}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="bi bi-droplet-half text-muted" style="font-size: 3rem;"></i>
                                        <h5 class="mt-3 fw-bold">No Treatments Defined</h5>
                                        <p class="text-muted">Start by adding your first specialized treatment procedure.</p>
                                        <a href="${pageContext.request.contextPath}/salon/treatments/add" class="btn btn-sm btn-outline-purple mt-2 rounded-pill px-4">Add Now</a>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

