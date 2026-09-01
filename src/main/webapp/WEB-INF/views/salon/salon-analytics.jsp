<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
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
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root { 
            --sidebar-width: 280px; 
            --dashboard-bg: #F8FAFC;
            --primary-accent: #F43F5E;
            --secondary-subtext: #64748B;
            --card-bg: #FFFFFF;
            
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            
            --border-color: #E2E8F0;
            --text-main: #0F172A;
        }
        
        body { 
            font-family: 'Poppins', sans-serif; 
            background-color: var(--dashboard-bg); 
            color: var(--text-main); 
            overflow-x: hidden; 
        }
        
        /* Sidebar styling remains roughly the same as layout requires it */
        .sidebar { background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: var(--primary-accent); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 4px 0 24px rgba(0,0,0,0.04); }
            .main-content { margin-left: var(--sidebar-width); }
        }

        .page-title {
            color: var(--text-main);
            font-weight: 800;
        }
        .page-subtitle {
            color: var(--secondary-subtext);
        }

        .kpi-card { 
            background: var(--card-bg); 
            border-radius: 16px; 
            padding: 24px; 
            border: 1px solid var(--border-color); 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); 
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%; 
        }
        .kpi-val { 
            font-size: 2rem; 
            font-weight: 800; 
            line-height: 1.2; 
            margin-bottom: 4px; 
        }
        .kpi-label { 
            color: var(--secondary-subtext); 
            font-weight: 600; 
            text-transform: uppercase; 
            font-size: 0.75rem; 
            letter-spacing: 0.05em;
        }

        /* Value Colors based on theme */
        .val-success { color: var(--success-text); }
        .val-error { color: var(--error-text); }
        .val-primary { color: var(--primary-accent); }
        .val-warning { color: var(--warning-text); }
        .val-neutral { color: var(--text-main); }

        .content-panel { 
            background: var(--card-bg); 
            border-radius: 16px; 
            padding: 32px; 
            border: 1px solid var(--border-color); 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03); 
            height: 100%; 
        }
        
        .panel-title {
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
        }
        .panel-title i {
            color: var(--warning-text);
            margin-right: 12px;
        }

        .list-group-custom .list-group-item { 
            border: none; 
            border-bottom: 1px solid var(--border-color); 
            padding: 16px 0; 
            background: transparent;
        }
        .list-group-custom .list-group-item:last-child { border-bottom: none; }
        
        .service-name {
            color: var(--text-main);
            font-weight: 600;
        }

        .badge-success {
            background-color: var(--success-bg) !important;
            color: var(--success-text) !important;
            font-weight: 600;
            padding: 8px 12px !important;
            border: 1px solid rgba(22, 163, 74, 0.2);
        }

        .insights-panel {
            background: var(--card-bg);
            border-top: 4px solid var(--primary-accent);
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .insights-icon {
            font-size: 3rem;
            color: var(--primary-accent);
            margin-bottom: 16px;
        }
        .insights-title {
            color: var(--text-main);
            font-weight: 800;
            margin-bottom: 12px;
        }
        .insights-text {
            color: var(--secondary-subtext);
            font-size: 1rem;
            line-height: 1.6;
        }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="analytics"/>
</jsp:include>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="mb-5">
                <h2 class="page-title m-0">Business Intelligence</h2>
                <p class="page-subtitle mt-1 mb-0">Lifetime aggregated performance overview.</p>
            </div>

            <!-- Top KPIs -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="kpi-card" style="background-color: var(--success-bg); border-color: rgba(22, 163, 74, 0.2);">
                        <div class="kpi-val val-success">₹${grossRevenue}</div>
                        <div class="kpi-label" style="color: var(--success-text);">Gross Revenue</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card" style="background-color: var(--error-bg); border-color: rgba(220, 38, 38, 0.2);">
                        <div class="kpi-val val-error">₹${totalExpenses}</div>
                        <div class="kpi-label" style="color: var(--error-text);">Total Expenses</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card" style="background-color: #FFF0F2; border-color: rgba(244, 63, 94, 0.2);">
                        <div class="kpi-val val-primary">₹${netProfit}</div>
                        <div class="kpi-label" style="color: var(--primary-accent);">Net Profit</div>
                    </div>
                </div>
            </div>

            <!-- Secondary Metrics -->
            <div class="row g-4 mb-5">
                <div class="col-md-3">
                    <div class="kpi-card">
                        <div class="kpi-val val-neutral">${totalInvoices}</div>
                        <div class="kpi-label">Walk-In Bills Generated</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card">
                        <div class="kpi-val val-success">${completedBookings}</div>
                        <div class="kpi-label">Completed App Bookings</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card" style="background-color: var(--warning-bg); border-color: rgba(194, 65, 12, 0.2);">
                        <div class="kpi-val val-warning">${pendingBookings}</div>
                        <div class="kpi-label" style="color: var(--warning-text);">Pending App Bookings</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card">
                        <div class="kpi-val val-neutral">₹${totalInventoryValue}</div>
                        <div class="kpi-label">Inventory Capital</div>
                    </div>
                </div>
            </div>

            <!-- Detailed Breakdowns -->
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="content-panel">
                        <h4 class="panel-title"><i class="bi bi-star-fill"></i> Top Performing Services</h4>
                        <ul class="list-group list-group-custom">
                            <c:forEach var="entry" items="${topServices}">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span class="service-name">${entry.key}</span>
                                    <span class="badge badge-success rounded-pill">${entry.value} Sold</span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty topServices}">
                                <li class="list-group-item text-center py-4" style="color: var(--secondary-subtext);">
                                    No billing data available yet. Generate invoices to see your top services!
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="content-panel insights-panel">
                        <i class="bi bi-lightbulb insights-icon"></i>
                        <h4 class="insights-title">Business Insights</h4>
                        <p class="insights-text m-0">
                            <c:choose>
                                <c:when test="${netProfit > 0}">You are running a profitable business! Your revenue of <strong>₹${grossRevenue}</strong> exceeds your expenses of <strong>₹${totalExpenses}</strong>. Keep pushing those top-performing services!</c:when>
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
