<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Packages & Memberships | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Select2 for multi-select dropdown -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

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
        
        .btn-add-new {
            background: var(--brand-purple);
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
            background: var(--brand-purple-darker);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
        }
        
        /* Tabs Styling */
        .nav-pills-custom .nav-link {
            color: #6c757d;
            font-weight: 600;
            border-radius: 50px;
            padding: 12px 30px;
            margin-right: 15px;
            background: white;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s;
        }
        
        .nav-pills-custom .nav-link.active {
            background: var(--brand-purple);
            color: white;
            border-color: var(--brand-purple);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
        }

        /* Package/Membership Cards */
        .card-custom {
            background: white;
            border-radius: 20px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(106, 13, 173, 0.1);
            border-color: rgba(106, 13, 173, 0.2);
        }
        
        .card-custom.inactive {
            opacity: 0.7;
            filter: grayscale(0.5);
        }

        .card-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .card-title-custom {
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--brand-purple-darker);
            margin: 0;
        }

        .card-price {
            font-size: 2rem;
            font-weight: 900;
            color: var(--brand-purple);
            margin: 15px 0;
        }
        
        .card-badge {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 600;
            background: #f8f9fa;
            padding: 5px 12px;
            border-radius: 50px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .service-list {
            list-style: none;
            padding: 0;
            margin: 0 0 20px 0;
            flex-grow: 1;
        }
        
        .service-list li {
            padding: 5px 0;
            color: #4a5568;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 0.95rem;
        }
        
        .service-list li i {
            color: var(--brand-purple);
            margin-top: 3px;
        }

        .benefits-text {
            color: #4a5568;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 25px;
            flex-grow: 1;
            white-space: pre-wrap;
        }

        .card-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }

        .btn-toggle {
            flex: 1;
            padding: 10px;
            border-radius: 12px;
            font-weight: 600;
            border: none;
            transition: all 0.2s;
        }
        
        .btn-toggle-active {
            background: rgba(32, 201, 151, 0.1);
            color: #20c997;
        }
        
        .btn-toggle-active:hover { background: #20c997; color: white; }
        
        .btn-toggle-inactive {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }
        
        .btn-toggle-inactive:hover { background: #dc3545; color: white; }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            padding: 10px 15px;
            border-radius: 12px;
            border: none;
            transition: all 0.2s;
        }
        
        .btn-delete:hover { background: #dc3545; color: white; }

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
        
        .select2-container--default .select2-selection--multiple {
            border-radius: 20px;
            border: 1px solid #dee2e6;
            padding: 5px;
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
                <h2>Packages & Memberships</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-3 mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <!-- Tabs -->
            <ul class="nav nav-pills nav-pills-custom mb-5" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#pills-packages" type="button">
                        <i class="bi bi-box2-heart"></i> Service Packages
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#pills-memberships" type="button">
                        <i class="bi bi-gem"></i> VIP Memberships
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
                
                <!-- Packages Tab -->
                <div class="tab-pane fade show active" id="pills-packages">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark m-0">Bundled Services</h4>
                        <button type="button" class="btn-add-new" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                            <i class="bi bi-plus-lg"></i> Create Package
                        </button>
                    </div>

                    <div class="row g-4">
                        <c:forEach var="pkg" items="${packages}">
                            <div class="col-xl-4 col-md-6">
                                <div class="card-custom ${!pkg.isActive ? 'inactive' : ''}">
                                    <div class="card-header-flex">
                                        <h3 class="card-title-custom">${pkg.packageName}</h3>
                                        <c:if test="${pkg.isActive}">
                                            <span class="badge bg-success rounded-pill px-3">Active</span>
                                        </c:if>
                                        <c:if test="${!pkg.isActive}">
                                            <span class="badge bg-secondary rounded-pill px-3">Inactive</span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="card-price">₹${pkg.price}</div>
                                    
                                    <p class="text-muted small mb-3">${pkg.description}</p>
                                    
                                    <h6 class="fw-bold mt-2 mb-3">Included Services:</h6>
                                    <ul class="service-list">
                                        <c:choose>
                                            <c:when test="${not empty pkg.includedServices}">
                                                <c:forEach var="service" items="${pkg.includedServices}">
                                                    <li><i class="bi bi-check2-circle"></i> ${service.name}</li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="text-muted fst-italic">No specific services linked.</li>
                                            </c:otherwise>
                                        </c:choose>
                                    </ul>
                                    
                                    <div class="card-actions">
                                        <form action="${pageContext.request.contextPath}/salon/packages/togglePackage" method="POST" class="flex-grow-1 m-0">
                                            <input type="hidden" name="packageId" value="${pkg.id}">
                                            <button type="submit" class="btn-toggle w-100 ${pkg.isActive ? 'btn-toggle-inactive' : 'btn-toggle-active'}">
                                                <i class="bi ${pkg.isActive ? 'bi-pause-circle' : 'bi-play-circle'} me-1"></i>
                                                ${pkg.isActive ? 'Deactivate' : 'Activate'}
                                            </button>
                                        </form>
                                        
                                        <form action="${pageContext.request.contextPath}/salon/packages/deletePackage" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to delete this package?');">
                                            <input type="hidden" name="packageId" value="${pkg.id}">
                                            <button type="submit" class="btn-delete" title="Delete Package">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${empty packages}">
                        <div class="text-center py-5">
                            <i class="bi bi-box-seam text-muted" style="font-size: 4rem;"></i>
                            <h4 class="mt-4 fw-bold">No Packages Yet</h4>
                            <p class="text-muted">Create service bundles to increase your average order value.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Memberships Tab -->
                <div class="tab-pane fade" id="pills-memberships">
                    
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark m-0">Time-based Perks</h4>
                        <button type="button" class="btn-add-new" data-bs-toggle="modal" data-bs-target="#addMembershipModal">
                            <i class="bi bi-plus-lg"></i> Create Membership
                        </button>
                    </div>

                    <div class="row g-4">
                        <c:forEach var="mem" items="${memberships}">
                            <div class="col-xl-4 col-md-6">
                                <div class="card-custom ${!mem.isActive ? 'inactive' : ''}">
                                    <div class="card-header-flex">
                                        <h3 class="card-title-custom text-warning"><i class="bi bi-stars"></i> ${mem.membershipName}</h3>
                                        <c:if test="${mem.isActive}">
                                            <span class="badge bg-success rounded-pill px-3">Active</span>
                                        </c:if>
                                        <c:if test="${!mem.isActive}">
                                            <span class="badge bg-secondary rounded-pill px-3">Inactive</span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="card-price">₹${mem.price}</div>
                                    
                                    <div class="card-badge">
                                        <i class="bi bi-hourglass-split me-1"></i> Valid for ${mem.durationInMonths} Month(s)
                                    </div>
                                    
                                    <h6 class="fw-bold mt-2 mb-3">Member Benefits:</h6>
                                    <div class="benefits-text">${mem.benefits}</div>
                                    
                                    <div class="card-actions">
                                        <form action="${pageContext.request.contextPath}/salon/packages/toggleMembership" method="POST" class="flex-grow-1 m-0">
                                            <input type="hidden" name="membershipId" value="${mem.id}">
                                            <button type="submit" class="btn-toggle w-100 ${mem.isActive ? 'btn-toggle-inactive' : 'btn-toggle-active'}">
                                                <i class="bi ${mem.isActive ? 'bi-pause-circle' : 'bi-play-circle'} me-1"></i>
                                                ${mem.isActive ? 'Deactivate' : 'Activate'}
                                            </button>
                                        </form>
                                        
                                        <form action="${pageContext.request.contextPath}/salon/packages/deleteMembership" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to delete this membership?');">
                                            <input type="hidden" name="membershipId" value="${mem.id}">
                                            <button type="submit" class="btn-delete" title="Delete Membership">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${empty memberships}">
                        <div class="text-center py-5">
                            <i class="bi bi-gem text-muted" style="font-size: 4rem;"></i>
                            <h4 class="mt-4 fw-bold">No Memberships Yet</h4>
                            <p class="text-muted">Create memberships to guarantee recurring revenue and customer loyalty.</p>
                        </div>
                    </c:if>
                </div>

            </div>

        </div>
    </div>

    <!-- Add Package Modal -->
    <div class="modal fade" id="addPackageModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none;">
                <div class="modal-header border-0 pb-0">
                    <h4 class="modal-title fw-bold" style="color: var(--brand-purple-darker);">Create Service Package</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/salon/packages/addPackage" method="POST">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-8">
                                <label class="form-label fw-bold">Package Name *</label>
                                <input type="text" name="packageName" class="form-control rounded-pill" required placeholder="e.g., Premium Bridal Package">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Total Price (₹) *</label>
                                <input type="number" name="price" step="0.01" class="form-control rounded-pill" required placeholder="0.00">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Select Included Services *</label>
                            <select name="serviceIds" class="form-select select2-multiple" multiple="multiple" style="width: 100%;" required>
                                <c:forEach var="svc" items="${salonServices}">
                                    <option value="${svc.id}">${svc.name} (₹${svc.price})</option>
                                </c:forEach>
                            </select>
                            <div class="form-text mt-2">Hold Ctrl (Windows) or Cmd (Mac) to select multiple services.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Short Description *</label>
                            <textarea name="description" class="form-control rounded-3" rows="2" required placeholder="Describe the package appeal..."></textarea>
                        </div>
                        
                        <div class="text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-add-new px-5 ms-2">Create Package</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Membership Modal -->
    <div class="modal fade" id="addMembershipModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none;">
                <div class="modal-header border-0 pb-0">
                    <h4 class="modal-title fw-bold" style="color: var(--brand-purple-darker);">Create VIP Membership</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/salon/packages/addMembership" method="POST">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Membership Name *</label>
                            <input type="text" name="membershipName" class="form-control rounded-pill" required placeholder="e.g., Gold Member">
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Price (₹) *</label>
                                <input type="number" name="price" step="0.01" class="form-control rounded-pill" required placeholder="0.00">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Validity (Months) *</label>
                                <input type="number" name="durationInMonths" class="form-control rounded-pill" required placeholder="e.g., 6">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Member Benefits *</label>
                            <textarea name="benefits" class="form-control rounded-3" rows="4" required placeholder="20% OFF Hair Services&#10;15% OFF Facial Services&#10;1 Free Hair Spa&#10;Priority Booking"></textarea>
                            <div class="form-text mt-1">Press Enter to put each benefit on a new line.</div>
                        </div>
                        
                        <div class="text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-add-new px-5 ms-2">Create Membership</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap & jQuery & Select2 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('.select2-multiple').select2({
                placeholder: "Search and select services...",
                allowClear: true,
                dropdownParent: $('#addPackageModal')
            });
        });
    </script>
</body>
</html>

