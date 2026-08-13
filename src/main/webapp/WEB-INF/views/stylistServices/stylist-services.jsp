<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services &amp; Packages | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); margin: 0; overflow-x: hidden; }
        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; }
            .main-content { margin-left: var(--sidebar-width); }
        }
        @media (max-width: 991.98px) {
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
        }
        .mobile-header { background: var(--gradient-dark); color: white; padding: 15px 20px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 999; }
        .table-card { background: white; border-radius: 24px; padding: 30px; border: 1px solid var(--fdf-border); }
    </style>
</head>
<body>
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold d-flex align-items-center gap-2"><i class="bi bi-stars"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 2rem;"></i>
        </button>
    </div>

    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="offcanvas-header d-lg-none border-bottom border-secondary mb-3 pb-3">
            <h5 class="offcanvas-title text-white fw-bold"><i class="bi bi-stars"></i> Fight D Fear</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebarMenu"></button>
        </div>
        <a href="${pageContext.request.contextPath}/stylists/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i><span>Fight D Fear</span>
        </a>
        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/profile"><i class="bi bi-person-circle"></i><span>Stylist Profile</span></a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/stylists/services"><i class="bi bi-bag-heart-fill"></i><span>Services &amp; Packages</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard#bookings"><i class="bi bi-calendar-check"></i><span>My Bookings</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/reviews"><i class="bi bi-star-half"></i><span>Client Reviews</span></a>
            <div class="mt-5">
                <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/stylists/logout"><i class="bi bi-box-arrow-left"></i><span>Sign Out</span></a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h2 class="fw-800 m-0">Services &amp; Packages</h2>
                    <p class="text-muted mb-0">Manage the services clients can book from your profile.</p>
                </div>
                <a href="${pageContext.request.contextPath}/stylists/services/add" class="btn btn-primary rounded-pill px-4 fw-700">
                    <i class="bi bi-plus-circle me-1"></i> Add New Service
                </a>
            </div>

            <div class="table-card">
                <c:choose>
                    <c:when test="${not empty services}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Name</th>
                                        <th>Price (&#8377;)</th>
                                        <th>Duration (min)</th>
                                        <th>Ingredients</th>
                                        <th>Allergens</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${services}">
                                        <tr>
                                            <td class="fw-700">${s.name}</td>
                                            <td>${s.price}</td>
                                            <td>${s.durationMinutes}</td>
                                            <td>${s.ingredients}</td>
                                            <td>${s.allergenInfo}</td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/stylists/services/edit/${s.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3">Edit</a>
                                                <a href="${pageContext.request.contextPath}/stylists/services/delete/${s.id}"
                                                   onclick="return confirm('Delete this service?');"
                                                   class="btn btn-outline-danger btn-sm rounded-pill px-3">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-bag-x display-4 text-muted"></i>
                            <h4 class="fw-800 mt-3">No services yet</h4>
                            <p class="text-muted">Add your first service or package so clients can book you.</p>
                            <a href="${pageContext.request.contextPath}/stylists/services/add" class="btn btn-primary rounded-pill px-4">Add Service</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
