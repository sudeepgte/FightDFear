<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Delivery Dashboard — Women Products</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    .wp-stat-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:14px; margin:20px 0 28px; }
    .wp-stat { background:#fff; border-radius:16px; padding:18px; border:1px solid #E2E8F0; box-shadow:0 4px 20px rgba(0,0,0,0.03); }
    .wp-stat h3 { margin:0; font-size:1.4rem; color:#0F172A; }
    .wp-stat p { margin:4px 0 0; color:#64748b; font-size:0.85rem; font-weight:600; }
    .wp-panel { display:none; }
    .wp-panel.active { display:block; }
    .wp-card { background:#fff; border:1px solid #E2E8F0; border-radius:16px; overflow:hidden; }
    table { width:100%; border-collapse:collapse; }
    th, td { padding:12px 14px; text-align:left; border-bottom:1px solid #f1f5f9; font-size:0.9rem; }
    th { background:#FFF1F2; color:#9F1239; font-size:0.75rem; text-transform:uppercase; letter-spacing:.4px; }
    .btn { background:#F43F5E; color:#fff; border:none; padding:7px 12px; border-radius:10px; font-weight:700; cursor:pointer; font-family:inherit; }
    select { padding:6px 8px; border-radius:8px; border:1px solid #e2e8f0; }
    .status-pill { display:inline-block; padding:4px 10px; border-radius:999px; font-size:0.75rem; font-weight:800; background:#fff7ed; color:#c2410c; }
    @media (max-width: 800px) {
      table { min-width: 760px; }
    }
  </style>
</head>
<body class="wp-portal">
  <div class="mobile-topbar">
    <div>Delivery Partner</div>
    <i class="bi bi-list" style="font-size:1.8rem; cursor:pointer;" onclick="toggleMobileSidebar()"></i>
  </div>
  <div class="sidebar-overlay" onclick="toggleMobileSidebar()"></div>
  <div class="fdf-sidebar">
    <div class="sidebar-header">
      <i class="bi bi-truck"></i>
      <h2>Delivery Portal</h2>
      <span>${partner.fullName}</span>
    </div>
    <nav class="nav-menu">
      <a href="#dashboard" class="nav-link active" data-panel="dashboard" onclick="return showPanel('dashboard', this)"><i class="bi bi-speedometer2"></i> Dashboard</a>
      <a href="#assigned" class="nav-link" data-panel="assigned" onclick="return showPanel('assigned', this)"><i class="bi bi-clipboard-check"></i> Assigned Orders</a>
      <a href="#pickup" class="nav-link" data-panel="pickup" onclick="return showPanel('pickup', this)"><i class="bi bi-box-seam"></i> Pickup</a>
      <a href="#transit" class="nav-link" data-panel="transit" onclick="return showPanel('transit', this)"><i class="bi bi-arrow-left-right"></i> In Transit</a>
      <a href="#ofd" class="nav-link" data-panel="ofd" onclick="return showPanel('ofd', this)"><i class="bi bi-geo-alt"></i> Out for Delivery</a>
      <a href="#delivered" class="nav-link" data-panel="delivered" onclick="return showPanel('delivered', this)"><i class="bi bi-check-circle"></i> Delivered</a>
    </nav>
    <div class="sidebar-footer">
      <a class="nav-link" href="${pageContext.request.contextPath}/logout" style="color:#ef4444;"><i class="bi bi-box-arrow-left"></i> Logout</a>
    </div>
  </div>

  <div class="fdf-main">
    <div class="header-info">
      <div>
        <h1>Women Products delivery</h1>
        <div style="font-weight:600;color:var(--martial-muted);margin-top:4px;">${partner.fullName} · ${partner.email}</div>
      </div>
    </div>
    <c:if test="${not empty message}"><div class="wp-alert-ok" style="margin-bottom:16px;">${message}</div></c:if>
    <c:if test="${not empty error}"><div class="wp-alert-err" style="margin-bottom:16px;">${error}</div></c:if>
    <c:if test="${not approved}"><div class="wp-alert-err" style="margin-bottom:16px;">Waiting for admin approval. You can view this page, but status updates are locked.</div></c:if>

    <div id="panel-dashboard" class="wp-panel active">
      <div class="wp-stat-grid">
        <div class="wp-stat"><h3>${pickupOrders.size()}</h3><p>Pickup</p></div>
        <div class="wp-stat"><h3>${activeDeliveries.size()}</h3><p>Active deliveries</p></div>
        <div class="wp-stat"><h3>${deliveredOrders.size()}</h3><p>Delivered</p></div>
        <div class="wp-stat"><h3>${assigned.size()}</h3><p>Assigned total</p></div>
      </div>
      <h2 style="font-size:1.05rem;margin:0 0 12px;">Assigned orders</h2>
      <c:if test="${empty assigned}"><div class="wp-empty"><i class="bi bi-inbox"></i>No assigned Women Products deliveries yet.</div></c:if>
      <c:if test="${not empty assigned}">
        <div class="wp-card wp-table-wrap"><c:set var="list" value="${assigned}" scope="request"/><jsp:include page="delivery-order-table.jsp"/></div>
      </c:if>
    </div>

    <div id="panel-assigned" class="wp-panel">
      <h2 style="font-size:1.05rem;margin:0 0 12px;">Assigned Orders</h2>
      <c:if test="${empty assigned}"><div class="wp-empty"><i class="bi bi-inbox"></i>No assigned orders.</div></c:if>
      <c:if test="${not empty assigned}">
        <div class="wp-card wp-table-wrap"><c:set var="list" value="${assigned}" scope="request"/><jsp:include page="delivery-order-table.jsp"/></div>
      </c:if>
    </div>

    <div id="panel-pickup" class="wp-panel">
      <h2 style="font-size:1.05rem;margin:0 0 12px;">Pickup</h2>
      <c:if test="${empty pickupOrders}"><div class="wp-empty"><i class="bi bi-box-seam"></i>No pickup orders right now.</div></c:if>
      <c:if test="${not empty pickupOrders}">
        <div class="wp-card wp-table-wrap"><c:set var="list" value="${pickupOrders}" scope="request"/><jsp:include page="delivery-order-table.jsp"/></div>
      </c:if>
    </div>

    <div id="panel-transit" class="wp-panel">
      <h2 style="font-size:1.05rem;margin:0 0 12px;">In Transit</h2>
      <c:set var="transitCount" value="0"/>
      <c:forEach var="o" items="${assigned}">
        <c:if test="${o.status == 'PICKED_UP' || o.status == 'IN_TRANSIT' || o.status == 'SHIPPED'}"><c:set var="transitCount" value="${transitCount + 1}"/></c:if>
      </c:forEach>
      <c:if test="${transitCount == 0}"><div class="wp-empty"><i class="bi bi-truck"></i>No in-transit orders.</div></c:if>
      <c:if test="${transitCount > 0}">
        <div class="wp-card wp-table-wrap">
          <table>
            <thead><tr><th>Order</th><th>Customer</th><th>Pickup</th><th>Delivery address</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
              <c:forEach var="o" items="${assigned}">
                <c:if test="${o.status == 'PICKED_UP' || o.status == 'IN_TRANSIT' || o.status == 'SHIPPED'}">
                  <tr>
                    <td>#ORD-${o.id}</td>
                    <td>${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer'}</td>
                    <td>${not empty o.seller ? o.seller.address : '-'}</td>
                    <td>${o.shippingAddress}</td>
                    <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0"/></td>
                    <td><span class="status-pill">${o.status}</span></td>
                    <td>
                      <c:set var="opts" value="${nextStatuses[o.id]}"/>
                      <c:if test="${approved && not empty opts}">
                        <form method="post" action="${pageContext.request.contextPath}/women-products/delivery/orders/${o.id}/status">
                          <select name="status"><c:forEach var="st" items="${opts}"><option value="${st}">${st}</option></c:forEach></select>
                          <button class="btn" type="submit">Update</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:if>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:if>
    </div>

    <div id="panel-ofd" class="wp-panel">
      <h2 style="font-size:1.05rem;margin:0 0 12px;">Out for Delivery</h2>
      <c:set var="ofdCount" value="0"/>
      <c:forEach var="o" items="${assigned}">
        <c:if test="${o.status == 'OUT_FOR_DELIVERY'}"><c:set var="ofdCount" value="${ofdCount + 1}"/></c:if>
      </c:forEach>
      <c:if test="${ofdCount == 0}"><div class="wp-empty"><i class="bi bi-geo-alt"></i>No out-for-delivery orders.</div></c:if>
      <c:if test="${ofdCount > 0}">
        <div class="wp-card wp-table-wrap">
          <table>
            <thead><tr><th>Order</th><th>Customer</th><th>Pickup</th><th>Delivery address</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
              <c:forEach var="o" items="${assigned}">
                <c:if test="${o.status == 'OUT_FOR_DELIVERY'}">
                  <tr>
                    <td>#ORD-${o.id}</td>
                    <td>${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer'}</td>
                    <td>${not empty o.seller ? o.seller.address : '-'}</td>
                    <td>${o.shippingAddress}</td>
                    <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0"/></td>
                    <td><span class="status-pill">${o.status}</span></td>
                    <td>
                      <c:set var="opts" value="${nextStatuses[o.id]}"/>
                      <c:if test="${approved && not empty opts}">
                        <form method="post" action="${pageContext.request.contextPath}/women-products/delivery/orders/${o.id}/status">
                          <select name="status"><c:forEach var="st" items="${opts}"><option value="${st}">${st}</option></c:forEach></select>
                          <button class="btn" type="submit">Update</button>
                        </form>
                      </c:if>
                    </td>
                  </tr>
                </c:if>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:if>
    </div>

    <div id="panel-delivered" class="wp-panel">
      <h2 style="font-size:1.05rem;margin:0 0 12px;">Delivered</h2>
      <c:if test="${empty deliveredOrders}"><div class="wp-empty"><i class="bi bi-check-circle"></i>No delivered orders yet.</div></c:if>
      <c:if test="${not empty deliveredOrders}">
        <div class="wp-card wp-table-wrap"><c:set var="list" value="${deliveredOrders}" scope="request"/><jsp:include page="delivery-order-table.jsp"/></div>
      </c:if>
    </div>
  </div>
  <script>
    function toggleMobileSidebar() {
      document.querySelector('.fdf-sidebar').classList.toggle('show');
      document.querySelector('.sidebar-overlay').classList.toggle('show');
    }
    function showPanel(id, el) {
      document.querySelectorAll('.wp-panel').forEach(p => p.classList.remove('active'));
      document.querySelectorAll('.nav-link[data-panel]').forEach(a => a.classList.remove('active'));
      const panel = document.getElementById('panel-' + id);
      if (panel) panel.classList.add('active');
      if (el) el.classList.add('active');
      return false;
    }
  </script>
</body>
</html>
