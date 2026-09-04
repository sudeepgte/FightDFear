<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Stylists | Fight D Fear</title>

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
            --dashboard-bg: #f8f5ff;
            --brand-purple: #6a0dad;
            --brand-purple-darker: #4a0080;
            --gradient-dark: linear-gradient(135deg, #2b1055 0%, #7597de 100%);
            --fdf-border: #eee;
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

        .stylist-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            height: 100%;
        }

        .stylist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            border-color: rgba(106, 13, 173, 0.2);
        }

        .stylist-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #f8f5ff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }

        .stylist-name {
            font-weight: 700;
            font-size: 1.2rem;
            color: var(--brand-purple-darker);
            margin-bottom: 5px;
        }

        .stylist-role {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .stylist-stats {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.85rem;
            color: #495057;
            background: #f8f9fa;
            padding: 5px 10px;
            border-radius: 50px;
        }
        
        .stat-item i {
            color: #ffc107;
        }

        .btn-action-pill {
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85rem;
            border: none;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
        }

        .btn-add-new {
            background: linear-gradient(90deg, #2b1055 0%, #F43F5E 100%); border: none;
            color: white;
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add-new:hover {
            background: linear-gradient(90deg, #1e0940 0%, #e11d48 100%); border: none;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
        }
        
        .btn-delete { background: #fff5f5; color: #dc3545; }
        .btn-delete:hover { background: #dc3545; color: white; }

        .status-indicator {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
        
        .status-available { background-color: #20c997; box-shadow: 0 0 0 3px rgba(32, 201, 151, 0.2); }
        .status-unavailable { background-color: #adb5bd; }

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
    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="staff"/>
</jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/salons/dashboard" class="btn btn-sm" style="border: 1px solid #F43F5E; color: #F43F5E; font-weight: 600; border-radius: 8px;"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
            </div>
            
            <div class="page-header">
                <h2>Our Stylists</h2>
                <a href="${pageContext.request.contextPath}/addStylist" class="btn-add-new">
                    <i class="bi bi-plus-lg"></i> Add Stylist
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-3 mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <c:if test="${empty stylists}">
                <div class="glass-card text-center py-5">
                    <i class="bi bi-people text-muted" style="font-size: 3rem;"></i>
                    <h4 class="mt-3 fw-bold">No Stylists Found</h4>
                    <p class="text-muted">You haven't added any stylists to your salon yet. Add your team members to manage their bookings.</p>
                    <a href="${pageContext.request.contextPath}/addStylist" class="btn-add-new mt-3">Add Your First Stylist</a>
                </div>
            </c:if>

            <div class="row g-4">
                <c:forEach var="stylist" items="${stylists}">
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="stylist-card">
                            <div class="status-indicator ${stylist.available ? 'status-available' : 'status-unavailable'}" title="${stylist.available ? 'Available' : 'Not Available'}"></div>
                            
                            <img src="${not empty stylist.profileImage ? pageContext.request.contextPath.concat(stylist.profileImage) : 'https://ui-avatars.com/api/?name='.concat(stylist.firstName).concat('+').concat(stylist.lastName).concat('&background=6a0dad&color=fff&size=128')}" alt="${stylist.firstName}" class="stylist-avatar" onerror="this.src='https://ui-avatars.com/api/?name=${stylist.firstName}+${stylist.lastName}&background=6a0dad&color=fff&size=128';">
                            
                            <h4 class="stylist-name">${stylist.firstName} ${stylist.lastName}</h4>
                            <div class="stylist-role">${not empty stylist.specialization ? stylist.specialization : 'Hair Stylist'}</div>
                            
                            <div class="stylist-stats">
                                <div class="stat-item" title="Experience">
                                    <i class="bi bi-briefcase-fill text-muted"></i> ${stylist.experienceInYears} Yrs
                                </div>
                                <div class="stat-item" title="Rating">
                                    <i class="bi bi-star-fill"></i> ${not empty stylist.rating ? stylist.rating : '0.0'}
                                </div>
                            </div>
                            
                            <div class="d-flex flex-column gap-2 mt-4">
                                <a href="${pageContext.request.contextPath}/stylist/view?id=${stylist.id}" class="btn-action-pill btn-add-new" style="background-color: var(--brand-purple); color: white;">
                                    <i class="bi bi-person-lines-fill"></i> View Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/stylist/delete?id=${stylist.id}" class="btn-action-pill btn-delete" onclick="return confirm('Are you sure you want to remove this stylist? This action cannot be undone.')">
                                    <i class="bi bi-trash3"></i> Remove Stylist
                                </a>
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



