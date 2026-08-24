<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Management | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }
        
        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            
            .main-content { margin-left: var(--sidebar-width); }
        }

        .stat-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); text-align: center; }
        .stat-val { font-size: 2.2rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .stat-label { color: #6c757d; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; }

        .content-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); }
        
        .table-custom th { background: #f8f9fa; color: var(--brand-purple-darker); font-weight: 700; border-bottom: 2px solid #eee; text-transform: uppercase; font-size: 0.85rem; }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid #eee; color: #4a5568; }

        .btn-action { background: var(--gradient-primary); color: white; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; transition: all 0.3s ease; }
        .btn-action:hover { filter: brightness(1.1); transform: translateY(-2px); }

        .row-low-stock { background-color: rgba(255, 193, 7, 0.05) !important; }
        .row-out-of-stock { background-color: rgba(220, 53, 69, 0.05) !important; }
    
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
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-800 text-purple m-0">Inventory Management</h2>
                    <p class="text-muted mb-0">Track salon supplies and retail products.</p>
                </div>
                <button type="button" class="btn-action" data-bs-toggle="modal" data-bs-target="#addItemModal">
                    <i class="bi bi-plus-circle me-1"></i> Add New Product
                </button>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <div class="row g-4 mb-4">
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-dark">${totalItems}</div><div class="stat-label">Total Items</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-warning">${lowStockCount}</div><div class="stat-label">Low Stock Alerts</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-danger">${outOfStockCount}</div><div class="stat-label">Out of Stock</div></div></div>
                <div class="col-md-3"><div class="stat-card"><div class="stat-val text-success">₹${totalValue}</div><div class="stat-label">Stock Value</div></div></div>
            </div>

            <div class="content-panel">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                            <tr>
                                <th>Product / SKU</th>
                                <th>Type</th>
                                <th>Qty (In Stock)</th>
                                <th>Cost (₹)</th>
                                <th>Supplier</th>
                                <th>Quick Update</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <c:set var="status" value="${item.stockStatus}" />
                                <tr class="${status == 'LOW_STOCK' ? 'row-low-stock' : (status == 'OUT_OF_STOCK' ? 'row-out-of-stock' : '')}">
                                    <td>
                                        <div class="fw-bold text-purple">${item.itemName}</div>
                                        <div class="small text-muted">SKU: ${item.sku} | ${item.category}</div>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${item.usageType}</span></td>
                                    <td>
                                        <div class="fw-bold fs-5 ${status == 'OUT_OF_STOCK' ? 'text-danger' : (status == 'LOW_STOCK' ? 'text-warning' : 'text-success')}">
                                            ${item.quantityInStock}
                                        </div>
                                        <div class="small text-muted">Threshold: ${item.lowStockThreshold}</div>
                                    </td>
                                    <td>
                                        <div>Buy: ₹${item.unitCost}</div>
                                        <c:if test="${item.usageType == 'Retail'}">
                                            <div class="text-success small">Sell: ₹${item.retailPrice}</div>
                                        </c:if>
                                    </td>
                                    <td>${item.supplierName}</td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/salon/inventory/updateStock" method="POST" class="d-flex gap-1 m-0">
                                                <input type="hidden" name="itemId" value="${item.id}">
                                                <input type="number" name="stockAdjustment" class="form-control form-control-sm text-center" value="1" style="width: 60px;">
                                                <button type="submit" class="btn btn-sm btn-outline-success"><i class="bi bi-arrow-right-circle"></i></button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/salon/inventory/deleteItem" method="POST" class="m-0" onsubmit="return confirm('Delete this item?');">
                                                <input type="hidden" name="itemId" value="${item.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty items}">
                                <tr><td colspan="6" class="text-center text-muted py-5"><i class="bi bi-box2 fs-1 d-block mb-3"></i> No inventory items found. Add a product to get started.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- Add Item Modal -->
    <div class="modal fade" id="addItemModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-header border-bottom-0 bg-light rounded-top-4">
                    <h5 class="modal-title fw-bold text-purple"><i class="bi bi-box-seam me-2"></i> Register New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/salon/inventory/addItem" method="POST">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="fw-bold mb-1">Product Name *</label>
                                <input type="text" name="itemName" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="fw-bold mb-1">SKU / Barcode</label>
                                <input type="text" name="sku" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="fw-bold mb-1">Category</label>
                                <select name="category" class="form-select">
                                    <option value="Hair Care">Hair Care</option>
                                    <option value="Skin Care">Skin Care</option>
                                    <option value="Nails">Nails</option>
                                    <option value="Tools">Tools</option>
                                    <option value="Colors & Dyes">Colors & Dyes</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="fw-bold mb-1">Usage Type</label>
                                <select name="usageType" class="form-select">
                                    <option value="Professional">Professional (Salon Use)</option>
                                    <option value="Retail">Retail (Sell to Customer)</option>
                                </select>
                            </div>
                            
                            <hr class="my-4 text-muted">

                            <div class="col-md-6">
                                <label class="fw-bold mb-1">Quantity In Stock</label>
                                <input type="number" name="quantityInStock" class="form-control" value="0" required>
                            </div>
                            <div class="col-md-6">
                                <label class="fw-bold mb-1">Low Stock Warning Threshold</label>
                                <input type="number" name="lowStockThreshold" class="form-control" value="5" required>
                            </div>

                            <div class="col-md-4">
                                <label class="fw-bold mb-1">Wholesale Cost (₹)</label>
                                <input type="number" name="unitCost" class="form-control" step="0.01" value="0">
                            </div>
                            <div class="col-md-4">
                                <label class="fw-bold mb-1">Retail Price (₹)</label>
                                <input type="number" name="retailPrice" class="form-control" step="0.01" value="0">
                            </div>
                            <div class="col-md-4">
                                <label class="fw-bold mb-1">Supplier Name</label>
                                <input type="text" name="supplierName" class="form-control">
                            </div>

                        </div>
                        <div class="text-end mt-4 pt-3 border-top">
                            <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-action px-4">Save Product</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

