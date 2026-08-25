<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f9fc;
            --fdf-burgundy: #2d0b20;
            --fdf-burgundy-dark: #1f0615;
            --fdf-pink: #db2777;
            --fdf-pink-light: #fbcfe8;
            --fdf-rose: #f43f5e;
            --fdf-lavender: #f3e8ff;
            --fdf-text-dark: #1e1b4b;
            --fdf-text-muted: #64748b;
            --fdf-border: #f1e9f0;
            --card-shadow: 0 10px 30px rgba(79, 70, 229, 0.04);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--fdf-text-dark);
            margin: 0;
            overflow-x: hidden;
        }

        /* Scrollbar styling */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(30, 27, 75, 0.1); border-radius: 10px; }

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

        /* Upgrade card in sidebar */
        .upgrade-card {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 16px;
            margin: 20px 16px;
            font-size: 0.8rem;
        }
        .upgrade-card h6 {
            color: white;
            font-weight: 700;
            font-size: 0.85rem;
            margin-bottom: 8px;
        }
        .upgrade-card ul {
            list-style: none;
            padding: 0;
            margin: 0 0 12px 0;
            color: rgba(255,255,255,0.5);
        }
        .upgrade-card ul li {
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .upgrade-card ul li::before {
            content: "•";
            color: var(--fdf-pink);
            font-weight: bold;
        }
        .btn-upgrade {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            border: none;
            padding: 8px;
            width: 100%;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.8rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-upgrade:hover {
            filter: brightness(1.1);
        }

        /* Main Content */
        .main-content {
            padding: 24px 32px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                z-index: 1000;
                box-shadow: 10px 0 35px rgba(0,0,0,0.05);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
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
    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="services"/>
</jsp:include>

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
                                        <c:set var="catLower" value="${fn:toLowerCase(service.category)}" />
                                        <c:choose>
                                            <c:when test="${fn:contains(catLower, 'hair')}">
                                                <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:when>
                                            <c:when test="${fn:contains(catLower, 'makeup')}">
                                                <img src="https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:when>
                                            <c:when test="${fn:contains(catLower, 'nail') or fn:contains(catLower, 'manicure') or fn:contains(catLower, 'pedicure')}">
                                                <img src="https://images.unsplash.com/photo-1604654894610-df63bc536371?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:when>
                                            <c:when test="${fn:contains(catLower, 'facial') or fn:contains(catLower, 'skin')}">
                                                <img src="https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:when>
                                            <c:when test="${fn:contains(catLower, 'massage') or fn:contains(catLower, 'spa')}">
                                                <img src="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?w=500&q=80" class="service-img" alt="${service.name}">
                                            </c:otherwise>
                                        </c:choose>
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

 




