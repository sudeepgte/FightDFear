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
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root { 
            --sidebar-width: 280px; 
            --dashboard-bg: #F8FAFC; 
            --brand-purple: #F43F5E; 
            --brand-purple-darker: #1E293B; 
            --gradient-dark: linear-gradient(135deg, #1E293B 0%, #64748B 100%);
            --fdf-border: #cbd5e1;
        }
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

        .content-panel { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); }
        
        .table-custom th { background: #f8f9fa; color: var(--brand-purple-darker); font-weight: 700; border-bottom: 2px solid #eee; text-transform: uppercase; font-size: 0.85rem; }
        .table-custom td { vertical-align: middle; border-bottom: 1px solid #eee; color: #4a5568; }

        .btn-action { background: #F43F5E !important; color: white !important; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; transition: all 0.3s ease; text-transform: uppercase; letter-spacing: 1px; }
        .btn-action:hover { background: #e11d48 !important; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(244, 63, 94, 0.3); }

        .text-purple { color: var(--brand-purple-darker) !important; }
        td .text-purple { color: var(--brand-purple) !important; }
        
        .modal-title.text-purple { color: var(--brand-purple-darker) !important; }

        .row-low-stock { background-color: rgba(255, 193, 7, 0.05) !important; }
        .row-out-of-stock { background-color: rgba(220, 53, 69, 0.05) !important; }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="inventory"/>
</jsp:include>

    <div class="main-content">
        <div class="container-fluid">
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/salons/dashboard" class="btn btn-sm" style="border: 1px solid #F43F5E; color: #F43F5E; font-weight: 600; border-radius: 8px;"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
            </div>
            
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

