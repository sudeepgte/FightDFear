<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services | Fight D Fear</title>

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
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-header h2 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin: 0;
        }

        .search-filter-card {
            background: white;
            border-radius: 20px;
            padding: 20px 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 25px rgba(0,0,0,0.03);
            margin-bottom: 40px;
        }

        .service-card-modern {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            border: 1px solid var(--fdf-border);
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .service-card-modern:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(30, 27, 75, 0.1);
            border-color: var(--brand-pink-light);
        }

        .service-img-wrapper {
            position: relative;
            height: 220px;
            overflow: hidden;
        }

        .service-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .service-card-modern:hover .service-img {
            transform: scale(1.1);
        }

        .category-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            color: var(--brand-purple);
            padding: 6px 14px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.7rem;
            text-transform: uppercase;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .service-body {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .service-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin-bottom: 10px;
        }

        .service-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            color: var(--brand-purple);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .service-info-text {
            color: #6c757d;
            font-size: 0.85rem;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .service-footer {
            padding: 20px 25px;
            border-top: 1px solid #f1f3f5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-edit {
            background: #f8f5ff;
            color: var(--brand-purple);
            border: none;
            padding: 8px 18px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .btn-edit:hover { background: var(--brand-purple); color: white; }

        .btn-delete-icon {
            color: #dc3545;
            background: #fff5f5;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-delete-icon:hover { background: #dc3545; color: white; }

        .btn-add-service {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 12px;
            font-weight: 700;
            box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-add-service:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
            color: white;
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

    <c:if test="${not empty successMessage}"><script>alert("${successMessage}");</script></c:if>
    <c:if test="${not empty errorMessage}"><script>alert("${errorMessage}");</script></c:if>

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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/treatments/view">
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
                    <h2>Our Services</h2>
                    <p class="text-muted m-0">Manage your salon's beauty treatments and offerings</p>
                </div>
                <a href="${pageContext.request.contextPath}/salon/addService" class="btn-add-service">
                    <i class="bi bi-plus-lg me-2"></i> Add New Service
                </a>
            </div>

            <!-- Search & Filter -->
            <div class="search-filter-card">
                <form class="row g-3 align-items-center" method="get" action="${pageContext.request.contextPath}/salon/viewServices">
                    <div class="col-md-auto">
                        <label class="fw-700 text-purple small text-uppercase">Filter by Category</label>
                    </div>
                    <div class="col-md-3">
                        <select name="category" class="form-select border-2 rounded-3">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" <c:if test="${param.category eq cat}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-auto">
                        <button type="submit" class="btn btn-purple rounded-3 px-4 fw-bold">Filter</button>
                    </div>
                </form>
            </div>

            <c:if test="${empty services}">
                <div class="text-center py-5">
                    <i class="bi bi-search text-muted" style="font-size: 3rem;"></i>
                    <h4 class="mt-3 fw-bold">No Services Found</h4>
                    <p class="text-muted">Try adjusting your filter or add your first service above.</p>
                </div>
            </c:if>

            <div class="row g-4">
                <c:forEach var="service" items="${services}">
                    <div class="col-xl-4 col-md-6">
                        <div class="service-card-modern">
                            <div class="service-img-wrapper">
                                <c:choose>
                                    <c:when test="${not empty service.photoUrl}">
                                        <img src="${pageContext.request.contextPath}${service.photoUrl}" class="service-img" alt="${service.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="h-100 bg-light d-flex align-items-center justify-content-center text-muted">
                                            <i class="bi bi-image" style="font-size: 3rem;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="category-badge">${service.category}</span>
                            </div>
                            
                            <div class="service-body">
                                <h3 class="service-title">${service.name}</h3>
                                <div class="service-meta">
                                    <span><i class="bi bi-currency-rupee me-1"></i>${service.price}</span>
                                    <span><i class="bi bi-clock me-1"></i>${service.durationMinutes} min</span>
                                </div>
                                <div class="service-info-text">
                                    <c:if test="${not empty service.ingredients}">
                                        <div class="mb-1"><strong>Ingredients:</strong> ${service.ingredients}</div>
                                    </c:if>
                                    <c:if test="${not empty service.allergenInfo}">
                                        <div><strong>Allergens:</strong> ${service.allergenInfo}</div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="service-footer">
                                <a href="${pageContext.request.contextPath}/salon/editService/${service.id}" class="btn-edit">
                                    <i class="bi bi-pencil-square me-1"></i> Edit
                                </a>
                                <form action="${pageContext.request.contextPath}/salon/deleteService" method="post" onsubmit="return confirm('Delete this service permanently?');">
                                    <input type="hidden" name="id" value="${service.id}">
                                    <button type="submit" class="btn-delete-icon">
                                        <i class="bi bi-trash3-fill"></i>
                                    </button>
                                </form>
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

 

