<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }
        
        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
            .main-content { margin-left: var(--sidebar-width); }
        }

        .kpi-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); text-align: center; height: 100%; }
        .kpi-val { font-size: 2.2rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .kpi-label { color: #6c757d; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; }

        .content-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); height: 100%; }
        
        .list-group-custom .list-group-item { border: none; border-bottom: 1px solid #eee; padding: 15px 0; color: #4a5568; }
        .list-group-custom .list-group-item:last-child { border-bottom: none; }
    </style>
</head>
<body>

    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i> <span>Fight D Fear</span>
        </a>
        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/dashboard"><i class="bi bi-grid-1x2-fill"></i> <span>Dashboard</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile"><i class="bi bi-person-circle"></i> <span>Salon Profile</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list"><i class="bi bi-calendar-check"></i> <span>Manage Bookings</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients"><i class="bi bi-people-fill"></i> <span>Clients</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists"><i class="bi bi-person-badge"></i> <span>Staff / Stylists</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages"><i class="bi bi-box-seam"></i> <span>Packages & Memberships</span></a>
            
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}"><i class="bi bi-tags"></i> <span>Offers & Discounts</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/billing"><i class="bi bi-receipt"></i> <span>Billing & Invoices</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/payments"><i class="bi bi-wallet2"></i> <span>Payments & Payouts</span></a>
            
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/inventory"><i class="bi bi-box2"></i> <span>Inventory</span></a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/analytics"><i class="bi bi-bar-chart-fill"></i> <span>Reports & Analytics</span></a>
        </nav>
    </div>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-800 text-purple m-0">Business Intelligence</h2>
                    <p class="text-muted mb-0">Lifetime aggregated performance overview.</p>
                </div>
            </div>

            <!-- Top KPIs -->
            <div class="row g-4 mb-4">
                <div class="col-md-4"><div class="kpi-card"><div class="kpi-val text-success">₹${grossRevenue}</div><div class="kpi-label">Gross Revenue</div></div></div>
                <div class="col-md-4"><div class="kpi-card"><div class="kpi-val text-danger">₹${totalExpenses}</div><div class="kpi-label">Total Expenses</div></div></div>
                <div class="col-md-4"><div class="kpi-card"><div class="kpi-val text-primary">₹${netProfit}</div><div class="kpi-label">Net Profit</div></div></div>
            </div>

            <!-- Secondary Metrics -->
            <div class="row g-4 mb-4">
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-val text-dark">${totalInvoices}</div><div class="kpi-label">Walk-In Bills Generated</div></div></div>
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-val text-success">${completedBookings}</div><div class="kpi-label">Completed App Bookings</div></div></div>
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-val text-warning">${pendingBookings}</div><div class="kpi-label">Pending App Bookings</div></div></div>
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-val text-info">₹${totalInventoryValue}</div><div class="kpi-label">Inventory Capital</div></div></div>
            </div>

            <!-- Detailed Breakdowns -->
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="content-panel">
                        <h4 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-star-fill text-warning me-2"></i> Top Performing Services</h4>
                        <ul class="list-group list-group-custom">
                            <c:forEach var="entry" items="${topServices}">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-purple">${entry.key}</span>
                                    <span class="badge bg-success rounded-pill px-3 py-2">${entry.value} Sold</span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty topServices}">
                                <li class="list-group-item text-muted text-center py-4">No billing data available yet. Generate invoices to see your top services!</li>
                            </c:if>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="content-panel bg-primary text-white border-0 text-center d-flex flex-column justify-content-center">
                        <i class="bi bi-lightbulb fs-1 mb-3"></i>
                        <h4 class="fw-bold">Business Insights</h4>
                        <p class="mb-0 opacity-75">
                            <c:choose>
                                <c:when test="${netProfit > 0}">You are running a profitable business! Your revenue of ₹${grossRevenue} exceeds your expenses of ₹${totalExpenses}. Keep pushing those top-performing services!</c:when>
                                <c:when test="${netProfit < 0}">Your expenses currently outweigh your revenue. Consider running a Promotion or Discount Offer to attract more bookings and balance the ledger.</c:when>
                                <c:otherwise>You are breaking even or have not recorded enough data yet. Start generating invoices or logging expenses to see detailed insights!</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

