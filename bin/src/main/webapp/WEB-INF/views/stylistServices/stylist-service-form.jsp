<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${service.id != null ? 'Edit Service' : 'Add Service'}"/> | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); margin: 0; }
        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; }
        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; }
            .main-content { margin-left: var(--sidebar-width); }
        }
        @media (max-width: 991.98px) {
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; }
        }
        .mobile-header { background: var(--gradient-dark); color: white; padding: 15px 20px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 999; }
        .form-card { background: white; border-radius: 24px; padding: 30px; border: 1px solid var(--fdf-border); max-width: 720px; }
    </style>
</head>
<body>
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold"><i class="bi bi-stars"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 2rem;"></i>
        </button>
    </div>

    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="offcanvas-header d-lg-none border-bottom border-secondary mb-3 pb-3">
            <h5 class="offcanvas-title text-white fw-bold">Fight D Fear</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
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
            <h2 class="fw-800 mb-4"><c:out value="${service.id != null ? 'Edit Service / Package' : 'Add Service / Package'}"/></h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-4">${error}</div>
            </c:if>
            <div class="form-card">
                <form action="${pageContext.request.contextPath}/stylists/services/save" method="post">
                    <input type="hidden" name="id" value="${service.id}">

                    <div class="mb-3">
                        <label class="form-label fw-700">Service / Package Name</label>
                        <input type="text" name="name" value="${service.name}" class="form-control form-control-lg" placeholder="e.g., Haircut, Bridal Package" maxlength="100" required>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-700">Price (&#8377;)</label>
                            <input type="number" step="0.01" min="0" name="price" value="${service.price}" class="form-control form-control-lg" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-700">Duration (minutes)</label>
                            <input type="number" min="1" max="600" name="durationMinutes" value="${service.durationMinutes}" class="form-control form-control-lg" required>
                        </div>
                    </div>

                    <div class="mb-3 mt-3">
                        <label class="form-label fw-700">Ingredients</label>
                        <input type="text" name="ingredients" value="${service.ingredients}" class="form-control form-control-lg" maxlength="255" placeholder="Optional">
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-700">Allergen Info</label>
                        <input type="text" name="allergenInfo" value="${service.allergenInfo}" class="form-control form-control-lg" maxlength="255" placeholder="Optional">
                    </div>

                    <div class="d-flex gap-2 flex-wrap">
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-700">
                            <c:out value="${service.id != null ? 'Update Service' : 'Add Service'}"/>
                        </button>
                        <a href="${pageContext.request.contextPath}/stylists/services" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
