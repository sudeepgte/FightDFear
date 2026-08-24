<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotions | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
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

        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        .nav-link-custom i { font-size: 1.2rem; }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            
            .main-content { margin-left: var(--sidebar-width); }
        }

        .page-header { margin-bottom: 30px; display: flex; align-items: center; justify-content: space-between; }
        .page-header h2 { font-weight: 800; color: var(--brand-purple-darker); margin: 0; }
        
        .btn-add-new { background: var(--brand-purple); color: white; padding: 10px 24px; border-radius: 50px; font-weight: 600; border: none; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; }
        .btn-add-new:hover { background: var(--brand-purple-darker); color: white; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3); }

        .stat-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; height: 100%; transition: all 0.3s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(106, 13, 173, 0.1); border-color: rgba(106, 13, 173, 0.2); }
        .stat-val { font-size: 2.5rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .stat-label { color: #6c757d; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; font-size: 0.85rem; }

        .promo-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; flex-direction: column; height: 100%; position: relative; overflow: hidden; transition: all 0.3s; }
        .promo-card:hover { transform: translateY(-4px); box-shadow: 0 15px 40px rgba(106, 13, 173, 0.08); }
        
        .promo-status { position: absolute; top: 20px; right: 20px; padding: 5px 15px; border-radius: 50px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }
        .status-Active { background: rgba(32, 201, 151, 0.15); color: #20c997; }
        .status-Scheduled { background: rgba(13, 110, 253, 0.15); color: #0d6efd; }
        .status-Expired { background: rgba(108, 117, 125, 0.15); color: #6c757d; }
        .status-Paused { background: rgba(255, 193, 7, 0.15); color: #ffc107; }

        .promo-title { font-size: 1.3rem; font-weight: 800; color: var(--brand-purple-darker); margin-bottom: 10px; padding-right: 90px; }
        .promo-dates { font-size: 0.9rem; color: #4a5568; font-weight: 600; margin-bottom: 15px; display: inline-flex; align-items: center; gap: 6px; background: #f8f9fa; padding: 5px 12px; border-radius: 8px; }
        .promo-desc { color: #6c757d; font-size: 0.95rem; margin-bottom: 20px; flex-grow: 1; }
        
        .promo-meta { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }
        .meta-item { background: #f8f5ff; padding: 10px; border-radius: 12px; text-align: center; }
        .meta-label { font-size: 0.75rem; color: #6c757d; text-transform: uppercase; font-weight: 700; }
        .meta-val { font-size: 1.1rem; font-weight: 800; color: var(--brand-purple); }

        .promo-actions { display: flex; gap: 10px; border-top: 1px solid #eee; padding-top: 20px; }
        .btn-action { flex: 1; padding: 8px; border-radius: 10px; font-weight: 600; border: none; font-size: 0.9rem; transition: all 0.2s; }
        
        .btn-pause { background: rgba(255, 193, 7, 0.1); color: #d39e00; }
        .btn-pause:hover { background: #ffc107; color: white; }
        .btn-resume { background: rgba(32, 201, 151, 0.1); color: #20c997; }
        .btn-resume:hover { background: #20c997; color: white; }
        .btn-archive { background: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .btn-archive:hover { background: #dc3545; color: white; }
        
        .select2-container--default .select2-selection--multiple { border-radius: 20px; border: 1px solid #dee2e6; padding: 5px; }

        @media (max-width: 991.98px) {
            
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
        }
        .mobile-header { background: var(--gradient-dark); color: white; padding: 15px 20px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 999; }
    
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

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <h2>Marketing Promotions</h2>
                <a href="${pageContext.request.contextPath}/salon/promotions/new" class="btn-add-new text-decoration-none">
                    <i class="bi bi-plus-lg"></i> Create Promotion
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-3 mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <!-- Stats -->
            <div class="row g-4 mb-5">
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-val text-dark">${totalCount}</div>
                        <div class="stat-label">Total Campaigns</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-val text-success">${activeCount}</div>
                        <div class="stat-label">Active</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-val text-primary">${scheduledCount}</div>
                        <div class="stat-label">Scheduled</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-val text-muted">${expiredCount}</div>
                        <div class="stat-label">Expired</div>
                    </div>
                </div>
            </div>

            <!-- List -->
            <div class="row g-4">
                <c:forEach var="promo" items="${promotions}">
                    <div class="col-xl-4 col-md-6">
                        <div class="promo-card">
                            <c:set var="status" value="${promo.dynamicStatus}" />
                            <div class="promo-status status-${status}">${status}</div>
                            
                            <h3 class="promo-title">✨ ${promo.promotionName}</h3>
                            
                            <div class="promo-dates">
                                <i class="bi bi-calendar-event"></i>
                                <fmt:parseDate value="${promo.startDate}" pattern="yyyy-MM-dd" var="sDate" type="date"/>
                                <fmt:formatDate pattern="dd MMM yy" value="${sDate}"/> 
                                - 
                                <fmt:parseDate value="${promo.endDate}" pattern="yyyy-MM-dd" var="eDate" type="date"/>
                                <fmt:formatDate pattern="dd MMM yy" value="${eDate}"/>
                            </div>
                            
                            <p class="promo-desc">${promo.description}</p>
                            
                            <div class="promo-meta">
                                <div class="meta-item">
                                    <div class="meta-label">Audience</div>
                                    <div class="meta-val fw-bold" style="font-size: 0.9rem; color: #333;">${promo.targetAudience}</div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Offers Linked</div>
                                    <div class="meta-val">${promo.promotedOffers.size()}</div>
                                </div>
                            </div>
                            
                            <div class="promo-actions">
                                <c:choose>
                                    <c:when test="${status == 'Paused'}">
                                        <form action="${pageContext.request.contextPath}/salon/promotions/status" method="POST" class="m-0 flex-grow-1">
                                            <input type="hidden" name="promotionId" value="${promo.id}">
                                            <input type="hidden" name="status" value="Resume">
                                            <button type="submit" class="btn-action btn-resume w-100"><i class="bi bi-play-circle me-1"></i> Resume</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/salon/promotions/status" method="POST" class="m-0 flex-grow-1">
                                            <input type="hidden" name="promotionId" value="${promo.id}">
                                            <input type="hidden" name="status" value="Paused">
                                            <button type="submit" class="btn-action btn-pause w-100" ${status == 'Expired' ? 'disabled' : ''}><i class="bi bi-pause-circle me-1"></i> Pause</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>

                                <form action="${pageContext.request.contextPath}/salon/promotions/delete" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to archive this promotion?');">
                                    <input type="hidden" name="promotionId" value="${promo.id}">
                                    <button type="submit" class="btn-action btn-archive"><i class="bi bi-archive me-1"></i></button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty promotions}">
                <div class="text-center py-5">
                    <i class="bi bi-megaphone text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-4 fw-bold">No Promotions Yet</h4>
                    <p class="text-muted">Create marketing campaigns to boost bookings.</p>
                </div>
            </c:if>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

