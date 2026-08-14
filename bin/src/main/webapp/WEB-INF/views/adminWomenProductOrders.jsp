<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Product Orders & Stock — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon:        #1e1b4b;
    --maroon-light:  #312e81;
    --maroon-dark:   #0b0920;
    --maroon-pale:   #f8fafc;
    --maroon-border: rgba(30, 27, 75, 0.12);
    --shadow-sm: 0 6px 20px rgba(125,42,90,0.10);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; }

  /* ── TOPBAR ── */
  .topbar {
    background: var(--maroon); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    box-shadow: 0 3px 16px rgba(125,42,90,0.28);
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff;
    border:1px solid rgba(255,255,255,0.3); border-radius:7px;
    padding:5px 16px; font-size:0.85rem; font-weight:600;
    text-decoration:none; transition:background 0.2s;
  }

  /* ── LAYOUT ── */
  .layout { display:flex; min-height:calc(100vh - 58px); }

  /* ── SIDEBAR ── */
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
    transition: all 0.3s ease;
  }
  .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
  }
  .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
  .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
  .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
  .navlink.active i { color: #fff; }

  /* ── MAIN ── */
  .main { flex:1; min-width:0; padding:28px 20px 48px; overflow-x:hidden;}
  .mainInner { max-width:1200px; margin:0 auto; animation:fadeUp 0.35s ease-out; }
  @keyframes fadeUp { from{opacity:0;transform:translateY(18px)} to{opacity:1;transform:translateY(0)} }

  /* ── PAGE HEADER ── */
  .pg-header {
    background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 55%, #c04b7a 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:28px;
    box-shadow:0 8px 28px rgba(125,42,90,0.22);
    display:flex; align-items:center; justify-content:space-between;
  }
  .pg-header h4 { color:#fff; font-weight:700; font-size:1.2rem; margin:0; }
  .pg-header p { color:rgba(255,255,255,0.7); margin:4px 0 0; font-size:0.85rem; }

  /* ── TABLE CARDS ── */
  .card-table {
    background:#fff; border-radius:16px; overflow:hidden;
    border:1px solid var(--maroon-border); box-shadow:var(--shadow-sm);
    margin-bottom: 28px;
  }
  .card-table-header {
    background: var(--maroon-pale);
    padding: 16px 20px;
    border-bottom: 1px solid var(--maroon-border);
    font-weight: 700;
    color: var(--maroon-dark);
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .badge-count {
      background: var(--maroon-light);
      color: #fff;
      border-radius: 20px;
      padding: 2px 10px;
      font-size: 0.75rem;
      font-weight: 700;
      margin-left: auto;
  }
  
  .table { margin-bottom:0; }
  .table thead th {
    background: rgba(125,42,90,0.03); color:var(--maroon-dark);
    font-size:0.75rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:16px; border:none; border-bottom:1px solid var(--maroon-border); text-align:center;
  }
  .table tbody td {
    padding:16px; vertical-align:middle; border-bottom:1px solid var(--maroon-border);
    font-size:0.9rem; text-align:center;
  }
  .table tbody tr:last-child td { border-bottom: none; }
  .table tbody tr:hover { background:rgba(125,42,90,0.02); }

  /* ── BADGES ── */
  .badge-status {
    padding:6px 12px; border-radius:999px; font-size:0.75rem; font-weight:700;
    display:inline-block; border:1px solid transparent;
  }

  /* Order Statuses */
  .status-PLACED { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-CONFIRMED { background:#e0f2fe; color:#0369a1; border-color:#bae6fd; }
  .status-SHIPPED { background:#dbeafe; color:#1d4ed8; border-color:#bfdbfe; }
  .status-DELIVERED { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-CANCELLED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }
  
  /* Stock Statuses */
  .status-IN-STOCK { background:#dcfce7; color:#166534; border-color:#bbf7d0; }
  .status-LOW-STOCK { background:#fef9c3; color:#854d0e; border-color:#fef08a; }
  .status-OUT-OF-STOCK { background:#fee2e2; color:#991b1b; border-color:#fecaca; }

  .meta-text {
      font-size: 0.8rem;
      color: #6b7280;
      margin-top: 4px;
  }
  
  .product-thumb {
      width: 44px;
      height: 44px;
      object-fit: cover;
      border-radius: 8px;
      border: 1px solid var(--maroon-border);
  }
  
  .btn-view-seller {
      padding: 4px 10px;
      font-size: 0.75rem;
      font-weight: 700;
      color: var(--maroon);
      background: var(--maroon-pale);
      border: 1px solid var(--maroon-border);
      border-radius: 6px;
      text-decoration: none;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 4px;
  }
  .btn-view-seller:hover {
      background: var(--maroon);
      color: #fff;
  }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--maroon-border);}
  }
</style>
</head>
<body>

<div class="topbar">
  <span class="brand">&#x1F6E1;&#xFE0F; Fight D Fear Admin</span>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">
      
      <!-- Header -->
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-box-open me-2"></i>Women Product Orders & Stock</h4>
          <p>Monitor platform-wide marketplace inventory and customer orders</p>
        </div>
      </div>

      <!-- Product Stock Levels Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-chart-bar text-primary"></i> Product Stock Levels
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Product</th>
                      <th>Seller</th>
                      <th>Category</th>
                      <th>Price</th>
                      <th>Stock Level</th>
                      <th>Status</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty products}">
                      <c:forEach var="p" items="${products}">
                           <tr>
                               <td class="text-start">
                                   <div class="d-flex align-items-center gap-3 ps-3">
                                       <img src="${pageContext.request.contextPath}${p.imagePath}" class="product-thumb" 
                                            onerror="this.src='https://placehold.co/100x100?text=No+Image'">
                                       <div class="fw-bold">${p.name}</div>
                                   </div>
                               </td>
                               <td>
                                   <div class="fw-bold">${p.seller.businessName}</div>
                                   <a href="${pageContext.request.contextPath}/admin/sellers/${p.seller.id}/profile" class="btn-view-seller mt-1">
                                       <i class="fas fa-user-circle"></i> View Profile
                                   </a>
                               </td>
                              <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                              <td class="fw-bold text-success">&#8377;${p.price}</td>
                              <td class="fw-bold">${p.stock}</td>
                              <td>
                                <c:choose>
                                  <c:when test="${p.stock > 10}"><span class="badge-status status-IN-STOCK">In Stock</span></c:when>
                                  <c:when test="${p.stock > 0}"><span class="badge-status status-LOW-STOCK">Low Stock</span></c:when>
                                  <c:otherwise><span class="badge-status status-OUT-OF-STOCK">Out of Stock</span></c:otherwise>
                                </c:choose>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="6" class="py-4 text-center text-muted">No products available in the marketplace yet.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- All Customer Orders Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-receipt text-warning"></i> All Customer Orders
          <span class="badge-count">${not empty orders ? orders.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle" style="min-width: 1000px;">
              <thead>
                  <tr>
                      <th>ID</th>
                      <th>Customer</th>
                      <th>Product Info</th>
                      <th>Seller</th>
                      <th>Payment</th>
                      <th>Address</th>
                      <th>Date</th>
                      <th>Status</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty orders}">
                      <c:forEach var="o" items="${orders}">
                          <tr>
                              <td class="fw-bold text-muted">#${o.id}</td>
                              <td>
                                  <div class="fw-bold text-dark">${o.user.fullName}</div>
                                  <div class="meta-text">${o.user.email}</div>
                              </td>
                               <td>
                                   <div class="fw-bold">${o.product.name}</div>
                                   <div class="meta-text">Qty: ${o.quantity} · <span class="text-success fw-bold">&#8377;${o.totalPrice}</span></div>
                               </td>
                               <td>
                                   <div class="fw-bold">${o.seller.businessName}</div>
                                   <a href="${pageContext.request.contextPath}/admin/sellers/${o.seller.id}/profile" class="btn-view-seller mt-1">
                                       <i class="fas fa-user-circle"></i> Profile
                                   </a>
                               </td>
                              <td>
                                  <span class="badge ${o.paymentMethod == 'COD' ? 'bg-warning text-dark' : 'bg-info'} border">${o.paymentMethod}</span>
                              </td>
                              <td>
                                  <div style="max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="${o.shippingAddress}">
                                      ${o.shippingAddress}
                                  </div>
                              </td>
                              <td class="meta-text order-date" data-datetime="${o.orderTime}">${o.orderTime}</td>
                              <td>
                                <c:choose>
                                  <c:when test="${o.status == 'PLACED'}"><span class="badge-status status-PLACED">Placed</span></c:when>
                                  <c:when test="${o.status == 'CONFIRMED'}"><span class="badge-status status-CONFIRMED">Confirmed</span></c:when>
                                  <c:when test="${o.status == 'SHIPPED'}"><span class="badge-status status-SHIPPED">Shipped</span></c:when>
                                  <c:when test="${o.status == 'DELIVERED'}"><span class="badge-status status-DELIVERED">Delivered</span></c:when>
                                  <c:when test="${o.status == 'CANCELLED'}"><span class="badge-status status-CANCELLED">Cancelled</span></c:when>
                                  <c:otherwise><span class="badge-status status-PLACED">${o.status}</span></c:otherwise>
                                </c:choose>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="8" class="py-4 text-center text-muted">No orders have been placed yet.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

    </div>
  </main>
</div>

<script>
document.querySelectorAll('.order-date').forEach(function(el) {
  var raw = el.getAttribute('data-datetime');
  if (!raw) return;
  try {
    var d = new Date(raw);
    if (isNaN(d.getTime())) {
      // Handle LocalDateTime format "2026-05-04T14:41:29.492427"
      var parts = raw.replace('T', ' ').split(/[.\-: ]/);
      d = new Date(parts[0], parts[1] - 1, parts[2], parts[3] || 0, parts[4] || 0);
    }
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var day = String(d.getDate()).padStart(2, '0');
    var mon = months[d.getMonth()];
    var year = d.getFullYear();
    var hrs = String(d.getHours()).padStart(2, '0');
    var mins = String(d.getMinutes()).padStart(2, '0');
    el.textContent = day + ' ' + mon + ' ' + year + ', ' + hrs + ':' + mins;
  } catch(e) { /* keep raw value */ }
});
</script>
</body>
</html>

