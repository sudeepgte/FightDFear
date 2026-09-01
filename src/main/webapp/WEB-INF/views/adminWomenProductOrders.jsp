<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Product Orders & Stock — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.wp-admin-wp { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; }
  body.wp-admin-wp .layout { display: flex; min-height: 100vh; }
  body.wp-admin-wp .main { flex: 1; min-width: 0; background: var(--ap-bg); padding: 0 !important; }
  body.wp-admin-wp .mainInner { max-width: 1400px; margin: 0 auto; padding: 22px 24px 48px; }
  body.wp-admin-wp .card-table {
    background: var(--ap-card); border-radius: var(--ap-radius); overflow: hidden;
    border: 1px solid var(--ap-border); box-shadow: var(--ap-shadow); margin-bottom: 16px;
  }
  body.wp-admin-wp .card-table-header {
    padding: 14px 16px; border-bottom: 1px solid var(--ap-border);
    font-weight: 800; color: var(--ap-text); display: flex; align-items: center; gap: 8px; background: #fff;
  }
  body.wp-admin-wp .badge-count {
    background: var(--ap-accent); color: #fff; border-radius: 999px; padding: 2px 10px;
    font-size: 0.72rem; font-weight: 700; margin-left: auto;
  }
  body.wp-admin-wp .table { margin-bottom: 0; min-width: 720px; }
  body.wp-admin-wp .table thead th {
    text-align: left; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
    text-transform: uppercase; letter-spacing: 0.04em; padding: 12px 14px;
    border-bottom: 1px solid var(--ap-border); background: #FCFCFD;
  }
  body.wp-admin-wp .table tbody td {
    padding: 14px; vertical-align: middle; border-bottom: 1px solid #F1F5F9; font-size: 0.86rem;
  }
  body.wp-admin-wp .table tbody tr:hover { background: #FFF7F8; }
  body.wp-admin-wp .badge-status { padding: 4px 10px; border-radius: 999px; font-size: 0.72rem; font-weight: 700; }
  body.wp-admin-wp .status-PLACED { background: #FEF3C7; color: #854d0e; }
  body.wp-admin-wp .status-CONFIRMED { background: var(--ap-info-bg); color: var(--ap-info); }
  body.wp-admin-wp .status-SHIPPED { background: var(--ap-info-bg); color: var(--ap-info); }
  body.wp-admin-wp .status-DELIVERED { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-CANCELLED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .status-IN-STOCK { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-LOW-STOCK { background: #FEF3C7; color: #854d0e; }
  body.wp-admin-wp .status-OUT-OF-STOCK { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .meta-text { font-size: 0.78rem; color: var(--ap-muted); margin-top: 4px; }
  body.wp-admin-wp .product-thumb { width: 40px; height: 40px; object-fit: cover; border-radius: 10px; border: 1px solid var(--ap-border); }
  body.wp-admin-wp .btn-view-seller {
    display: inline-flex; align-items: center; gap: 4px; padding: 7px 12px; font-size: 0.8rem; font-weight: 600;
    color: var(--ap-text); background: #fff; border: 1px solid var(--ap-border); border-radius: 9px; text-decoration: none;
  }
  body.wp-admin-wp .btn-view-seller:hover { border-color: #FDA4AF; color: var(--ap-accent); }
  @media (max-width: 700px) { body.wp-admin-wp .mainInner { padding: 16px 14px 40px; } }
</style>
</head>
<body class="ap-page wp-admin-wp">
<c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:360px;">
          <i class="fas fa-search"></i>
          <input type="search" id="apHeaderSearch" placeholder="Search anything..." aria-label="Search">
          <span class="ap-kbd">Ctrl + K</span>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
          <i class="fas fa-bell"></i>
          <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
        </a>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${apAdmin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty apAdmin.profilePhoto}"><img src="${pageContext.request.contextPath}${apAdmin.profilePhoto}" alt=""></c:when>
              <c:otherwise>${fn:substring(apAdmin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span><div class="name"><c:out value="${apAdmin.name}"/></div><div class="role">Super Admin</div></span>
        </a>
      </div>
    </div>
    <div class="mainInner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <span>Product Orders</span>
      </nav>
      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-box-open"></i></div>
        <div>
          <h1>Women Product Orders &amp; Stock</h1>
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

