<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Invoices | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
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

        .stat-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); text-align: center; }
        .stat-val { font-size: 2.2rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .stat-label { color: #6c757d; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; }

        .pos-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); }
        .table-custom th { background: #f8f9fa !important; color: #1e1b4b !important; font-weight: 800 !important; border-bottom: 2px solid #eee !important; text-transform: uppercase; font-size: 0.85rem; padding: 12px 15px !important; }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid #eee; color: #4a5568; padding: 12px 15px !important; }

        .btn-checkout { background: var(--gradient-primary); color: white; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; width: 100%; font-size: 1.1rem; }
        .btn-checkout:hover { filter: brightness(1.1); transform: translateY(-2px); }
        
        .select2-container--default .select2-selection--multiple { border-radius: 12px; border: 1px solid #dee2e6; background-color: #f8f9fa; padding: 6px; }
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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/billing"><i class="bi bi-receipt"></i> <span>Billing & Invoices</span></a>
        </nav>
    </div>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-800 text-purple m-0">Billing & POS</h2>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <div class="row g-4 mb-4">
                <div class="col-md-6"><div class="stat-card"><div class="stat-val text-success">₹${todayRevenue}</div><div class="stat-label">Total Revenue</div></div></div>
                <div class="col-md-6"><div class="stat-card"><div class="stat-val text-primary">${totalInvoices}</div><div class="stat-label">Total Invoices</div></div></div>
            </div>

            <div class="row g-4">
                <!-- POS Form -->
                <div class="col-lg-5">
                    <div class="pos-panel">
                        <h4 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-cart-plus me-2"></i> Quick Bill</h4>
                        <form action="${pageContext.request.contextPath}/salon/billing/create" method="POST">
                            
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Customer Name *</label>
                                <input type="text" name="clientName" class="form-control rounded-pill" required>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold mb-1">Customer Phone *</label>
                                <input type="text" name="clientPhone" class="form-control rounded-pill" required>
                            </div>

                            <div class="mb-3">
                                <label class="fw-bold mb-1">Select Services / Products *</label>
                                <select name="serviceIds" class="form-select select2-multiple" multiple="multiple" required style="width: 100%;">
                                    <c:forEach var="svc" items="${salonServices}">
                                        <option value="${svc.id}">${svc.name} (₹${svc.price})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="fw-bold mb-1">Discount (₹)</label>
                                    <input type="number" name="discountAmount" class="form-control rounded-pill" value="0" step="0.01">
                                </div>
                                <div class="col-6">
                                    <label class="fw-bold mb-1">Tax / GST (₹)</label>
                                    <input type="number" name="taxAmount" class="form-control rounded-pill" value="0" step="0.01">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="fw-bold mb-1">Payment Method</label>
                                <select name="paymentMethod" class="form-select rounded-pill">
                                    <option value="Cash">Cash</option>
                                    <option value="UPI">UPI</option>
                                    <option value="Credit Card">Credit / Debit Card</option>
                                </select>
                            </div>

                            <button type="submit" class="btn-checkout"><i class="bi bi-receipt me-2"></i> Generate Invoice</button>
                        </form>
                    </div>
                </div>

                <!-- Invoice History -->
                <div class="col-lg-7">
                    <div class="pos-panel">
                        <h4 class="fw-bold mb-4 border-bottom pb-2"><i class="bi bi-clock-history me-2"></i> Invoice History</h4>
                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th>Inv #</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Total</th>
                                        <th>Method</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="inv" items="${invoices}">
                                        <tr>
                                            <td class="fw-bold text-purple">${inv.invoiceNumber}</td>
                                            <td>${inv.invoiceDate.toLocalDate()}</td>
                                            <td>${inv.clientName}</td>
                                            <td class="fw-bold text-success">₹${inv.finalTotal}</td>
                                            <td><span class="badge bg-light text-dark border">${inv.paymentMethod}</span></td>
                                            <td><span class="badge bg-success">${inv.paymentStatus}</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty invoices}">
                                        <tr><td colspan="6" class="text-center text-muted py-4">No invoices found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.select2-multiple').select2({ placeholder: "Search and add services..." });
        });
    </script>
</body>
</html>

