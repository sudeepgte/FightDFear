<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Seller Management — ${seller.businessName}</title>
      <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
      <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap"
        rel="stylesheet">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        html,
        body {
          overflow-x: hidden;
          width: 100%;
        }

        body {
          font-family: 'Poppins', sans-serif;
          background: #fdf2f8;
          color: var(--fdf-text);
          min-height: 100vh;
          display: flex;
        }

        .mobile-topbar {
          display: none;
          background: var(--brand-purple-darker);
          color: #fff;
          padding: 15px 20px;
          align-items: center;
          justify-content: space-between;
          position: sticky;
          top: 0;
          z-index: 999;
        }

        .sidebar-overlay {
          display: none;
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0, 0, 0, 0.5);
          z-index: 999;
        }

        /* Sidebar Styling */
        .fdf-sidebar {
          width: 280px;
          background: var(--brand-purple-darker);
          color: #fff;
          display: flex;
          flex-direction: column;
          position: fixed;
          height: 100vh;
          box-shadow: 10px 0 30px rgba(0, 0, 0, 0.1);
          z-index: 1000;
          overflow-y: auto;
        }
        .fdf-sidebar::-webkit-scrollbar {
          width: 6px;
        }
        .fdf-sidebar::-webkit-scrollbar-track {
          background: rgba(0, 0, 0, 0.1);
        }
        .fdf-sidebar::-webkit-scrollbar-thumb {
          background: rgba(255, 255, 255, 0.2);
          border-radius: 3px;
        }
        .fdf-sidebar::-webkit-scrollbar-thumb:hover {
          background: rgba(255, 255, 255, 0.4);
        }

        .sidebar-header {
          padding: 40px 30px;
          text-align: center;
          border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-header i {
          font-size: 48px;
          color: var(--brand-pink);
          display: block;
          margin-bottom: 15px;
        }

        .sidebar-header h2 {
          font-family: 'Montserrat', sans-serif;
          font-size: 1.1rem;
          font-weight: 800;
          letter-spacing: 0.5px;
        }

        .sidebar-header span {
          font-size: 0.8rem;
          opacity: 0.6;
          font-weight: 500;
        }

        .nav-menu {
          padding: 30px 20px;
          flex: 1;
        }

        .nav-link {
          display: flex;
          align-items: center;
          gap: 14px;
          padding: 14px 20px;
          border-radius: 14px;
          color: rgba(255, 255, 255, 0.7);
          text-decoration: none;
          font-size: 0.95rem;
          font-weight: 600;
          transition: all 0.3s;
          margin-bottom: 8px;
        }

        .nav-link:hover {
          background: rgba(219, 39, 119, 0.1);
          color: var(--brand-pink-light);
        }

        .nav-link.active {
          background: var(--gradient-primary);
          color: #fff;
          box-shadow: 0 8px 20px rgba(219, 39, 119, 0.2);
        }

        .nav-link i {
          font-size: 1.25rem;
        }

        .sidebar-footer {
          padding: 30px 20px;
          border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* Main Content Area */
        .fdf-main {
          margin-left: 280px;
          flex: 1;
          padding: 50px;
        }

        .header-info {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 40px;
        }

        .header-info h1 {
          font-family: 'Montserrat', sans-serif;
          font-size: 2rem;
          font-weight: 900;
          color: var(--brand-purple-darker);
        }

        /* Dashboard Stats */
        .stats-grid {
          display: grid;
          grid-template-columns: repeat(4, 1fr);
          gap: 24px;
          margin-bottom: 40px;
        }

        .stat-box {
          background: #fff;
          border: 1px solid var(--fdf-border);
          border-radius: 24px;
          padding: 24px;
          display: flex;
          align-items: center;
          gap: 20px;
          box-shadow: var(--shadow-sm);
          transition: transform 0.3s;
        }

        .stat-box:hover {
          transform: translateY(-5px);
          box-shadow: var(--shadow-md);
        }

        .stat-icon-circle {
          width: 56px;
          height: 56px;
          border-radius: 18px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 24px;
        }

        .stat-icon-circle.pink {
          background: #fff1f2;
          color: #e11d48;
        }

        .stat-icon-circle.purple {
          background: #f5f3ff;
          color: #7c3aed;
        }

        .stat-icon-circle.teal {
          background: #f0fdf4;
          color: #16a34a;
        }

        .stat-icon-circle.gold {
          background: #fffbeb;
          color: #d97706;
        }

        .stat-data h3 {
          font-size: 1.5rem;
          font-weight: 800;
          color: var(--brand-purple-dark);
        }

        .stat-data p {
          font-size: 0.85rem;
          color: var(--fdf-muted);
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        /* Tables & Sections */
        .fdf-section {
          background: #fff;
          border: 1px solid var(--fdf-border);
          border-radius: 24px;
          overflow: hidden;
          box-shadow: var(--shadow-sm);
          margin-bottom: 30px;
        }

        .fdf-section-header {
          padding: 24px 30px;
          background: #fafafa;
          border-bottom: 1px solid var(--fdf-border);
          display: flex;
          justify-content: space-between;
          align-items: center;
        }

        .fdf-section-header h2 {
          font-size: 1.1rem;
          font-weight: 800;
          color: var(--brand-purple-dark);
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .fdf-section-body {
          padding: 30px;
        }

        .premium-table {
          width: 100%;
          border-collapse: separate;
          border-spacing: 0;
        }

        .premium-table th {
          padding: 18px 20px;
          background: #fafafa;
          text-align: left;
          font-size: 0.75rem;
          text-transform: uppercase;
          font-weight: 800;
          color: var(--fdf-muted);
          letter-spacing: 1px;
          border-bottom: 1px solid var(--fdf-border);
        }

        .premium-table td {
          padding: 18px 20px;
          font-size: 0.9rem;
          border-bottom: 1px solid #f3f4f6;
          vertical-align: middle;
        }

        .premium-table tr:last-child td {
          border-bottom: none;
        }

        .premium-table tr:hover td {
          background: #fdf2f855;
        }

        .img-avatar {
          width: 54px;
          height: 54px;
          border-radius: 14px;
          object-fit: cover;
        }

        .fdf-badge {
          display: inline-block;
          padding: 6px 14px;
          border-radius: 999px;
          font-size: 0.75rem;
          font-weight: 800;
          text-transform: uppercase;
        }

        .badge-PLACED {
          background: #fef3c7;
          color: #92400e;
        }

        .badge-CONFIRMED {
          background: #dbeafe;
          color: #1e40af;
        }

        .badge-SHIPPED {
          background: #f3e8ff;
          color: #6b21a8;
        }

        .badge-DELIVERED {
          background: #d1fae5;
          color: #065f46;
        }

        .badge-CANCELLED {
          background: #fee2e2;
          color: #991b1b;
        }

        .badge-INSTOCK {
          background: #d1fae5;
          color: #065f46;
        }

        .badge-OUTOFSTOCK {
          background: #fee2e2;
          color: #991b1b;
        }

        .btn-fdf-action {
          padding: 10px 20px;
          border-radius: 12px;
          background: var(--gradient-primary);
          color: #fff;
          border: none;
          font-weight: 700;
          cursor: pointer;
          font-family: inherit;
          transition: 0.3s;
        }

        .btn-fdf-action:hover {
          filter: brightness(1.1);
          transform: scale(1.02);
        }

        /* Modal Styling */
        .fdf-modal {
          display: none;
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(15, 10, 30, 0.6);
          backdrop-filter: blur(8px);
          z-index: 9999;
          align-items: center;
          justify-content: center;
          padding: 20px;
        }

        .fdf-modal-content {
          background: #fff;
          border-radius: 32px;
          width: 100%;
          max-width: 600px;
          padding: 40px;
          max-height: 90vh;
          overflow-y: auto;
          box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }

        .form-ctrl {
          width: 100%;
          padding: 14px 18px;
          border-radius: 14px;
          border: 1px solid var(--fdf-border);
          background: #fdf2f8;
          font-family: inherit;
          font-size: 0.95rem;
          outline: none;
          margin-top: 8px;
        }

        .form-ctrl:focus {
          border-color: var(--brand-pink);
          background: #fff;
        }

        @media (max-width: 1200px) {
          .stats-grid {
            grid-template-columns: repeat(2, 1fr);
          }
        }

        @media (max-width: 800px) {
          body {
            flex-direction: column;
          }

          .mobile-topbar {
            display: flex;
          }

          .fdf-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            transform: translateX(-100%);
            transition: transform 0.3s ease;
            z-index: 1001;
          }

          .fdf-sidebar.show {
            transform: translateX(0);
          }

          .sidebar-overlay.show {
            display: block;
          }

          .fdf-main {
            margin-left: 0;
            padding: 20px 15px;
          }

          .stats-grid {
            grid-template-columns: 1fr 1fr;
            gap: 12px;
          }

          .stat-box {
            flex-direction: column;
            text-align: center;
            padding: 15px 10px;
            gap: 10px;
            border-radius: 18px;
          }

          .stat-icon-circle {
            width: 44px;
            height: 44px;
            font-size: 20px;
          }

          .stat-data h3 {
            font-size: 1.15rem;
            margin-bottom: 2px;
          }

          .stat-data p {
            font-size: 0.7rem;
            line-height: 1.2;
          }

          .fdf-section-body {
            overflow-x: auto;
          }

          .header-info {
            flex-direction: column;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 25px;
          }

          .header-info h1 {
            font-size: 1.5rem;
          }

          /* Modals */
          .fdf-modal-content {
            padding: 25px 20px;
          }

          .fdf-modal-content div[style*="grid-template-columns"] {
            grid-template-columns: 1fr !important;
          }
        }
      </style>
    </head>

    <body>
      <div class="mobile-topbar">
        <div style="font-family:'Montserrat',sans-serif; font-weight:800; font-size:1.1rem;">Seller Portal</div>
        <i class="bi bi-list" style="font-size:1.8rem; cursor:pointer;" onclick="toggleMobileSidebar()"></i>
      </div>
      <div class="sidebar-overlay" onclick="toggleMobileSidebar()"></div>
      <div class="fdf-sidebar">
        <div class="sidebar-header">
          <i class="bi bi-box-seam-fill"></i>
          <h2>${seller.businessName}</h2>
          <span>Portal ID: FS-${seller.id}</span>
        </div>

        <nav class="nav-menu">
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=overview"
            class="nav-link ${section == 'overview' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i> Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=products"
            class="nav-link ${section == 'products' ? 'active' : ''}">
            <i class="bi bi-magic"></i> My Products
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=orders"
            class="nav-link ${section == 'orders' ? 'active' : ''}">
            <i class="bi bi-truck"></i> Live Orders
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=earnings"
            class="nav-link ${section == 'earnings' ? 'active' : ''}">
            <i class="bi bi-graph-up-arrow"></i> Revenue Analytics
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=exchanges"
            class="nav-link ${section == 'exchanges' ? 'active' : ''}">
            <i class="bi bi-arrow-left-right"></i> Exchange Requests
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=refunds"
            class="nav-link ${section == 'refunds' ? 'active' : ''}">
            <i class="bi bi-currency-rupee"></i> Refund Requests
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=profile"
            class="nav-link ${section == 'profile' ? 'active' : ''}">
            <i class="bi bi-person-badge-fill"></i> My Profile
          </a>
          <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=reviews"
            class="nav-link ${section == 'reviews' ? 'active' : ''}">
            <i class="bi bi-chat-heart-fill"></i> Customer Reviews
          </a>
        </nav>

        <div class="sidebar-footer">
          <a href="${pageContext.request.contextPath}/women-products" class="nav-link" target="_blank">
            <i class="bi bi-eye"></i> Preview Shop
          </a>
          <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: #ef4444; opacity: 1;">
            <i class="bi bi-box-arrow-left"></i> Logout
          </a>
        </div>
      </div>

      <div class="fdf-main">
        <c:if test="${not empty message}">
          <div
            style="background: #ecfdf5; color: #059669; padding: 16px 24px; border-radius: 18px; font-weight: 700; margin-bottom: 32px; display: flex; align-items: center; gap: 12px; box-shadow: 0 4px 12px rgba(5, 150, 105, 0.1);">
            <i class="bi bi-check-circle-fill"></i> ${message}
          </div>
        </c:if>
        <c:if test="${not empty error}">
          <div
            style="background: #fef2f2; color: #b91c1c; padding: 16px 24px; border-radius: 18px; font-weight: 700; margin-bottom: 32px; display: flex; align-items: center; gap: 12px; box-shadow: 0 4px 12px rgba(185, 28, 28, 0.1); border: 1px solid #fee2e2;">
            <i class="bi bi-x-circle-fill"></i> ${error}
          </div>
        </c:if>

        <%-- ══════ OVERVIEW ══════ --%>
          <c:if test="${section == 'overview'}">
            <div class="header-info">
              <div>
                <h1>Overview</h1>
                <div style="font-weight: 600; color: var(--fdf-muted); margin-top: 5px;">Welcome back, ${seller.fullName}!</div>
              </div>
              <div style="display:flex; gap:12px; align-items:center;">
                <a href="${pageContext.request.contextPath}/index.html" class="btn-fdf-action" style="padding: 10px 18px; font-size: 0.9rem; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;"><i class="bi bi-house-door-fill"></i> Back to Home</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-fdf-action" style="padding: 10px 18px; font-size: 0.9rem; background: #ef4444; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;"><i class="bi bi-box-arrow-left"></i> Logout</a>
              </div>
            </div>

            <div class="stats-grid">
              <div class="stat-box">
                <div class="stat-icon-circle pink"><i class="bi bi-bag-heart"></i></div>
                <div class="stat-data">
                  <h3>${totalProducts}</h3>
                  <p>Active Inventory</p>
                </div>
              </div>
              <div class="stat-box">
                <div class="stat-icon-circle purple"><i class="bi bi-receipt-cutoff"></i></div>
                <div class="stat-data">
                  <h3>${totalOrders}</h3>
                  <p>Confirmed Sales</p>
                </div>
              </div>
              <div class="stat-box">
                <div class="stat-icon-circle teal"><i class="bi bi-currency-rupee"></i></div>
                <div class="stat-data">
                  <h3>&#8377;${totalEarnings}</h3>
                  <p>Settled Balance</p>
                </div>
              </div>
              <div class="stat-box">
                <div class="stat-icon-circle gold"><i class="bi bi-star-fill"></i></div>
                <div class="stat-data">
                  <h3>${seller.rating}</h3>
                  <p>Performance Score</p>
                </div>
              </div>
            </div>

            <div class="fdf-section">
              <div class="fdf-section-header" style="display:flex; justify-content:space-between; align-items:center;">
                <h2><i class="bi bi-lightning-charge-fill" style="color:var(--brand-pink);"></i> Recent Orders Queue</h2>
                <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=orders"
                  style="color: var(--brand-pink); font-size: 0.85rem; font-weight: 800; text-decoration: none; display:flex; align-items:center; gap:4px;">
                  View All Orders <i class="bi bi-arrow-right"></i>
                </a>
              </div>
              <div class="fdf-section-body" style="padding: 0;">
                <c:if test="${empty orders}">
                  <div style="padding: 80px; text-align: center; color: var(--fdf-muted); font-weight: 500;">
                    <i class="bi bi-inbox" style="font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.3;"></i>
                    No active orders found.
                  </div>
                </c:if>
                <c:if test="${not empty orders}">
                  <table class="premium-table">
                    <thead>
                      <tr>
                        <th>Order & Customer</th>
                        <th>Product Item</th>
                        <th style="text-align:center;">Qty</th>
                        <th>Amount</th>
                        <th style="text-align:center;">Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="o" items="${orders}" begin="0" end="4">
                        <tr>
                          <td>
                            <div style="display:flex; align-items:center; gap:12px;">
                              <div style="width:38px; height:38px; border-radius:50%; background:linear-gradient(135deg, #ec4899 0%, #8b5cf6 100%); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:0.9rem; flex-shrink:0;">
                                ${not empty o.user && not empty o.user.fullName ? o.user.fullName.substring(0,1) : 'C'}
                              </div>
                              <div>
                                <div style="font-weight: 800; color:var(--brand-purple-dark); font-size:0.9rem;">
                                  ${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer #'.concat(o.id)}
                                </div>
                                <div style="font-size: 0.75rem; color: var(--fdf-muted); font-weight:600; display:flex; align-items:center; gap:6px; margin-top:2px;">
                                  <span>#ORD-${o.id}</span> • 
                                  <span style="background:#f1f5f9; padding:2px 6px; border-radius:4px; font-weight:700; color:#475569; font-size:0.7rem;">${o.paymentMethod}</span>
                                </div>
                              </div>
                            </div>
                          </td>
                          <td>
                            <div style="display:flex; align-items:center; gap:10px;">
                              <c:if test="${not empty o.product.imagePath}">
                                <img src="${pageContext.request.contextPath}${o.product.imagePath}" style="width:36px; height:36px; border-radius:8px; object-fit:cover; border:1px solid #eee;">
                              </c:if>
                              <div>
                                <div style="font-weight:700; font-size:0.9rem; color:var(--brand-purple-dark);">${o.product.name}</div>
                              </div>
                            </div>
                          </td>
                          <td style="text-align:center;">
                            <span style="font-weight:800; background:#fdf2f8; color:var(--brand-pink); padding:4px 10px; border-radius:12px; font-size:0.85rem;">
                              ${o.quantity}
                            </span>
                          </td>
                          <td>
                            <span style="font-weight: 900; color: #16a34a; font-size:0.95rem;">
                              &#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0" />
                            </span>
                          </td>
                          <td style="text-align:center;">
                            <c:choose>
                              <c:when test="${o.status == 'DELIVERED'}">
                                <span style="background:#dcfce7; color:#15803d; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                  <i class="bi bi-check-circle-fill"></i> Delivered
                                </span>
                              </c:when>
                              <c:when test="${o.status == 'SHIPPED'}">
                                <span style="background:#f3e8ff; color:#6b21a8; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                  <i class="bi bi-truck"></i> Shipped
                                </span>
                              </c:when>
                              <c:when test="${o.status == 'CANCELLED'}">
                                <span style="background:#fee2e2; color:#b91c1c; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                  <i class="bi bi-x-circle-fill"></i> Cancelled
                                </span>
                              </c:when>
                              <c:otherwise>
                                <span style="background:#fef3c7; color:#b45309; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                  <i class="bi bi-box-seam-fill"></i> ${o.status}
                                </span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </c:if>
              </div>
            </div>
          </c:if>

          <%-- ══════ PRODUCTS ══════ --%>
            <c:if test="${section == 'products'}">
              <div class="header-info">
                <h1>Catalog Manager</h1>
                <button class="btn-fdf-action" onclick="openAddModal()">
                  <i class="bi bi-plus-lg"></i> Deploy New Item
                </button>
              </div>

              <div class="fdf-section">
                <div class="fdf-section-body" style="padding: 0;">
                  <c:if test="${empty products}">
                    <div style="padding: 80px; text-align: center; color: var(--fdf-muted); font-weight: 500;"><i
                        class="bi bi-box-seam"
                        style="font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.3;"></i> Your catalog is
                      currently offline.</div>
                  </c:if>
                  <c:if test="${not empty products}">
                    <table class="premium-table">
                      <thead>
                        <tr>
                          <th>Item ID</th>
                          <th>Display</th>
                          <th>Specifications</th>
                          <th>Category</th>
                          <th>Price Trace</th>
                          <th>Stock</th>
                          <th>Status</th>
                          <th>Control</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="p" items="${products}">
                          <tr>
                            <td
                              style="font-family:monospace; font-weight:800; font-size:0.85rem; color:var(--brand-purple-dark);">
                              #PRD-${p.id}</td>
                            <td>
                              <c:choose>
                                <c:when test="${not empty p.imagePath}"><img
                                    src="${pageContext.request.contextPath}${p.imagePath}" class="img-avatar" alt="">
                                </c:when>
                                <c:otherwise>
                                  <div class="img-avatar"
                                    style="background: #fff1f2; display: flex; align-items: center; justify-content: center; color: var(--brand-pink); font-size: 20px;">
                                    <i class="bi bi-image"></i></div>
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td>
                              <div style="font-weight: 800;">${p.name}</div>
                              <div
                                style="font-size: 0.75rem; opacity: 0.6; display: -webkit-box; -webkit-line-clamp: 1; line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; max-width: 200px;">
                                ${p.description}</div>
                            </td>
                            <td>${p.category}</td>
                            <td><span style="font-weight: 900; color: #16a34a;">&#8377;${p.price}</span></td>
                            <td>${p.stock} units</td>
                            <td><span
                                class="fdf-badge badge-${p.stock > 0 && p.active ? 'INSTOCK' : 'OUTOFSTOCK'}">${p.stock
                                > 0 && p.active ? 'Operational' : 'Depleted'}</span></td>
                            <td>
                              <div style="display:flex; gap:8px;">
                                <button type="button" 
                                        class="edit-product-btn"
                                        data-id="${p.id}"
                                        data-name="<c:out value='${p.name}' />"
                                        data-brand="<c:out value='${p.brand}' />"
                                        data-description="<c:out value='${p.description}' />"
                                        data-fullDescription="<c:out value='${p.fullDescription}' />"
                                        data-price="${p.price}"
                                        data-originalPrice="${p.originalPrice}"
                                        data-offerBadge="<c:out value='${p.offerBadge}' />"
                                        data-stock="${p.stock}"
                                        data-lowStockAlertLevel="${p.lowStockAlertLevel}"
                                        data-sku="<c:out value='${p.sku}' />"
                                        data-category="${p.category}"
                                        data-weightSize="<c:out value='${p.weightSize}' />"
                                        data-manufacturer="<c:out value='${p.manufacturer}' />"
                                        data-ingredients="<c:out value='${p.ingredients}' />"
                                        data-benefits="<c:out value='${p.benefits}' />"
                                        data-usageInstructions="<c:out value='${p.usageInstructions}' />"
                                        data-tags="<c:out value='${p.tags}' />"
                                        data-active="${p.active}"
                                        data-featured="${p.featured}"
                                        data-trackInventory="${p.trackInventory}"
                                        style="background: #dbeafe; color: #1e40af; border: none; width: 36px; height: 36px;
                                        border-radius: 10px; cursor: pointer;">
                                  <i class="bi bi-pencil-square"></i>
                                </button>
                                <form
                                  action="${pageContext.request.contextPath}/women-products/seller/products/${p.id}/delete"
                                  method="post" onsubmit="return confirm('Execute permanent removal?')">
                                  <button type="submit"
                                    style="background: #fee2e2; color: #ef4444; border: none; width: 36px; height: 36px; border-radius: 10px; cursor: pointer;"><i
                                      class="bi bi-trash3-fill"></i></button>
                                </form>
                              </div>
                            </td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </c:if>
                </div>
              </div>

              <div id="productModal" class="fdf-modal">
                <div class="fdf-modal-content" style="max-width: 800px;">
                  <div
                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px; position:sticky; top:0; background:#fff; z-index:10; padding-bottom:15px; border-bottom:1px solid #eee;">
                    <h2 id="modalTitle" style="font-family:'Montserrat',sans-serif; font-weight:900;"><i
                        class="bi bi-rocket-takeoff-fill" style="color:var(--brand-pink)"></i> Catalog Deployment</h2>
                    <button onclick="document.getElementById('productModal').style.display='none'"
                      style="background:none; border:none; font-size:24px; opacity:0.3; cursor:pointer;"><i
                        class="bi bi-x-circle"></i></button>
                  </div>
                  <form id="productForm" method="post"
                    action="${pageContext.request.contextPath}/women-products/seller/products/add"
                    enctype="multipart/form-data">
                    <input type="hidden" name="productId" id="editProductId" value="">

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-info-circle-fill"></i> Basic Information</h4>
                    <div class="fdf-form-group" style="margin-bottom: 15px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Product Name
                        *</label><input type="text" name="name" class="form-ctrl" required
                        placeholder="Enter product name"></div>
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:15px;">
                      <div><label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Domain Category
                          *</label>
                        <select name="category" class="form-ctrl" required>
                          <option value="">Select Category</option>
                          <option value="SKINCARE">Skincare Defense</option>
                          <option value="HAIRCARE">Haircare</option>
                          <option value="HYGIENE">Sanitary Hygiene</option>
                          <option value="CLOTHING">Personal Wear</option>
                          <option value="ACCESSORIES">Tactical Accessories</option>
                          <option value="WELLNESS">Wellness Essentials</option>
                          <option value="OTHER">Other Domains</option>
                        </select>
                      </div>
                      <div><label
                          style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Brand *</label><input
                          type="text" name="brand" class="form-ctrl" placeholder="Brand name" required></div>
                    </div>
                    <div class="fdf-form-group" style="margin-bottom: 15px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Short
                        Description</label><textarea name="description" class="form-ctrl" rows="2"
                        placeholder="Brief description (max 200 chars)"></textarea></div>
                    <div class="fdf-form-group" style="margin-bottom: 30px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Full
                        Description</label><textarea name="fullDescription" class="form-ctrl" rows="4"
                        placeholder="Detailed product description..."></textarea></div>

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-tags-fill"></i> Pricing</h4>
                    <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:20px; margin-bottom:30px;">
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Selling Price
                          (&#8377;) *</label><input type="number" name="price" step="0.01" min="0.01" class="form-ctrl" required
                          placeholder="0.00"></div>
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">MRP
                          (&#8377;)</label><input type="number" name="originalPrice" step="0.01" min="0.01" class="form-ctrl"
                          placeholder="0.00"></div>
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Offer
                          Badge</label><input type="text" name="offerBadge" class="form-ctrl"
                          placeholder="e.g., 20% OFF, SALE"></div>
                    </div>

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-box-seam-fill"></i> Inventory</h4>
                    <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:20px; margin-bottom:30px;">
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Stock Quantity
                          *</label><input type="number" name="stock" class="form-ctrl" required placeholder="0"></div>
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Alert
                          Level</label><input type="number" name="lowStockAlertLevel" value="5" class="form-ctrl"></div>
                      <div><label style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">SKU
                          Code</label><input type="text" name="sku" class="form-ctrl"
                          placeholder="Auto-generated if empty"></div>
                    </div>

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-card-list"></i> Product Details</h4>
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:15px;">
                      <div><label
                          style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Weight/Size</label><input
                          type="text" name="weightSize" class="form-ctrl" placeholder="e.g., 100ml, 500g, 60 tablets">
                      </div>
                      <div><label
                          style="font-size:0.85rem; font-weight:700; text-transform:uppercase;">Manufacturer</label><input
                          type="text" name="manufacturer" class="form-ctrl" placeholder="Manufacturer name"></div>
                    </div>
                    <div class="fdf-form-group" style="margin-bottom: 15px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Ingredients</label><textarea
                        name="ingredients" class="form-ctrl" rows="2" placeholder="List of ingredients..."></textarea>
                    </div>
                    <div class="fdf-form-group" style="margin-bottom: 15px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Benefits</label><textarea
                        name="benefits" class="form-ctrl" rows="2"
                        placeholder="Health benefits of the product..."></textarea></div>
                    <div class="fdf-form-group" style="margin-bottom: 15px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Usage
                        Instructions</label><textarea name="usageInstructions" class="form-ctrl" rows="2"
                        placeholder="How to use this product..."></textarea></div>
                    <div class="fdf-form-group" style="margin-bottom: 30px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Tags (for
                        search)</label><input type="text" name="tags" class="form-ctrl"
                        placeholder="Comma-separated tags, e.g., ayurvedic, herbal, immunity"></div>

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-images"></i> Product Images</h4>
                    <div class="fdf-form-group" style="margin-bottom: 30px;"><label
                        style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Upload Images (Multiple
                        Allowed)</label><input type="file" name="images" class="form-ctrl" accept="image/*" multiple
                        style="padding:10px;">
                      <small style="color: var(--fdf-muted); display: block; margin-top: 5px;">JPG, PNG up to 5MB
                        each</small>
                    </div>

                    <h4
                      style="margin-bottom: 15px; color: var(--brand-purple-dark); font-weight: 800; font-size: 1.1rem;">
                      <i class="bi bi-eye-fill"></i> Status & Visibility</h4>
                    <div style="display:flex; gap:30px; margin-bottom:40px;">
                      <label style="display:flex; align-items:center; gap:8px; font-weight:600; cursor:pointer;"><input
                          type="checkbox" name="active" value="true" checked
                          style="width:18px; height:18px; accent-color:var(--brand-pink);"> Active (Visible on
                        store)</label>
                      <label style="display:flex; align-items:center; gap:8px; font-weight:600; cursor:pointer;"><input
                          type="checkbox" name="featured" value="true"
                          style="width:18px; height:18px; accent-color:var(--brand-pink);"> Featured Product</label>
                      <label style="display:flex; align-items:center; gap:8px; font-weight:600; cursor:pointer;"><input
                          type="checkbox" name="trackInventory" value="true" checked
                          style="width:18px; height:18px; accent-color:var(--brand-pink);"> Track Inventory</label>
                    </div>

                    <button type="submit" class="btn-fdf-action"
                      style="width:100%; padding: 18px; font-size: 1.1rem; border-radius: 16px;">Initiate Listing
                      Deployment</button>
                  </form>
                </div>
              </div>
            </c:if>

            <%-- ══════ ORDERS ══════ --%>
              <c:if test="${section == 'orders'}">
                <div class="header-info" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom:24px; width:100%;">
                  <div>
                    <h1 style="margin:0; font-weight:800;">Order Fulfillment Stream</h1>
                    <p style="margin:4px 0 0 0; color:var(--fdf-muted); font-size:0.9rem;">Track customer orders, manage delivery dispatches, and update fulfillment statuses.</p>
                  </div>
                  <div style="background:#fff; padding:10px 20px; border-radius:14px; border:1px solid var(--fdf-border); display:flex; align-items:center; gap:10px; box-shadow:var(--shadow-sm);">
                    <span style="font-weight:800; color:var(--brand-purple-dark);">Total Direct Orders:</span>
                    <span style="color:var(--brand-pink); font-size:1.1rem; font-weight:900;">${not empty orders ? orders.size() : 0}</span>
                  </div>
                </div>

                <div class="fdf-section">
                  <div class="fdf-section-body" style="padding: 0;">
                    <c:if test="${empty orders}">
                      <div style="padding: 80px; text-align: center; color: var(--fdf-muted); font-weight: 500;">
                        <i class="bi bi-truck" style="font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.3;"></i>
                        No active fulfillment requests.
                      </div>
                    </c:if>
                    <c:if test="${not empty orders}">
                      <table class="premium-table">
                        <thead>
                          <tr>
                            <th>Order ID</th>
                            <th>Customer & Contact</th>
                            <th>Product Item</th>
                            <th>Qty & Amount</th>
                            <th>Shipping Address</th>
                            <th style="text-align:center;">Order Status</th>
                            <th style="text-align:center;">Update Action</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="o" items="${orders}">
                            <tr>
                              <td>
                                <span style="font-family:monospace; font-weight:800; font-size:0.85rem; background:#f1f5f9; color:var(--brand-purple-dark); padding:4px 10px; border-radius:8px; display:inline-block;">
                                  #ORD-${o.id}
                                </span>
                              </td>
                              <td>
                                <div style="display:flex; align-items:center; gap:12px;">
                                  <div style="width:38px; height:38px; border-radius:50%; background:linear-gradient(135deg, #ec4899 0%, #8b5cf6 100%); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:0.9rem; flex-shrink:0;">
                                    ${not empty o.user && not empty o.user.fullName ? o.user.fullName.substring(0,1) : 'C'}
                                  </div>
                                  <div>
                                    <div style="font-weight: 800; color:var(--brand-purple-dark); font-size:0.9rem;">
                                      ${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer #'.concat(o.id)}
                                    </div>
                                    <div style="font-size: 0.75rem; color: var(--fdf-muted); font-weight:600; display:flex; align-items:center; gap:6px; margin-top:2px;">
                                      <span>${not empty o.user && not empty o.user.email ? o.user.email : 'No Email'}</span> • 
                                      <span style="background:#fdf2f8; padding:2px 6px; border-radius:4px; font-weight:700; color:var(--brand-pink); font-size:0.7rem;">${o.paymentMethod}</span>
                                    </div>
                                  </div>
                                </div>
                              </td>
                              <td>
                                <div style="display:flex; align-items:center; gap:10px;">
                                  <c:if test="${not empty o.product.imagePath}">
                                    <img src="${pageContext.request.contextPath}${o.product.imagePath}" style="width:38px; height:38px; border-radius:8px; object-fit:cover; border:1px solid #eee;">
                                  </c:if>
                                  <div>
                                    <div style="font-weight:700; font-size:0.9rem; color:var(--brand-purple-dark);">${o.product.name}</div>
                                  </div>
                                </div>
                              </td>
                              <td>
                                <div style="font-weight:800; color:var(--brand-purple-dark); font-size:0.85rem;">${o.quantity} ${o.quantity == 1 ? 'item' : 'items'}</div>
                                <div style="font-weight:900; color:#16a34a; font-size:0.95rem; margin-top:2px;">
                                  &#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0" />
                                </div>
                              </td>
                              <td>
                                <div style="font-size: 0.8rem; line-height:1.4; max-width: 220px; background:#fafafa; padding:8px 12px; border-radius:10px; border:1px solid #eee; color:#475569;">
                                  <i class="bi bi-geo-alt-fill" style="color:var(--brand-pink); margin-right:4px;"></i> ${o.shippingAddress}
                                </div>
                              </td>
                              <td style="text-align:center;">
                                <c:choose>
                                  <c:when test="${o.status == 'DELIVERED'}">
                                    <span style="background:#dcfce7; color:#15803d; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                      <i class="bi bi-check-circle-fill"></i> Delivered
                                    </span>
                                  </c:when>
                                  <c:when test="${o.status == 'SHIPPED' || o.status == 'IN_TRANSIT'}">
                                    <span style="background:#f3e8ff; color:#6b21a8; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                      <i class="bi bi-truck"></i> In Transit
                                    </span>
                                  </c:when>
                                  <c:when test="${o.status == 'CONFIRMED'}">
                                    <span style="background:#e0f2fe; color:#0369a1; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                      <i class="bi bi-clipboard-check-fill"></i> Confirmed
                                    </span>
                                  </c:when>
                                  <c:when test="${o.status == 'CANCELLED'}">
                                    <span style="background:#fee2e2; color:#b91c1c; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                      <i class="bi bi-x-circle-fill"></i> Cancelled
                                    </span>
                                  </c:when>
                                  <c:otherwise>
                                    <span style="background:#fef3c7; color:#b45309; padding:6px 14px; border-radius:20px; font-weight:800; font-size:0.75rem; display:inline-flex; align-items:center; gap:4px;">
                                      <i class="bi bi-box-seam-fill"></i> ${o.status}
                                    </span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td id="orderStatusCell_${o.id}" style="text-align:center;">
                                <c:set var="curr" value="${o.status}" />
                                <c:if test="${curr != 'DELIVERED' && curr != 'CANCELLED'}">
                                  <form action="${pageContext.request.contextPath}/women-products/seller/orders/${o.id}/status"
                                    method="post" class="seller-order-form" data-order-id="${o.id}" style="display:inline-flex; align-items:center; gap:6px;">
                                    <select name="status" class="form-ctrl" style="margin-top:0; padding:6px 10px; font-size:0.8rem; width:120px; border-radius:10px;">
                                      <option value="PLACED" ${curr=='PLACED' ? 'selected' : ''}>Placed</option>
                                      <option value="CONFIRMED" ${curr=='CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                      <option value="SHIPPED" ${(curr=='SHIPPED' || curr=='IN_TRANSIT') ? 'selected' : ''}>In Transit</option>
                                      <option value="DELIVERED" ${curr=='DELIVERED' ? 'selected' : ''}>Delivered</option>
                                      <option value="CANCELLED" ${curr=='CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                    <button type="submit" style="background:var(--gradient-primary); color:#fff; border:none; padding:6px 12px; border-radius:10px; font-weight:700; font-size:0.8rem; cursor:pointer; display:flex; align-items:center; gap:4px;" title="Update Status">
                                      <i class="bi bi-arrow-repeat"></i> Update
                                    </button>
                                  </form>
                                </c:if>
                                <c:if test="${curr == 'DELIVERED' || curr == 'CANCELLED'}">
                                  <div style="display:inline-flex; align-items:center; gap:6px; background:#f8fafc; padding:6px 14px; border-radius:20px; border:1px solid #e2e8f0;">
                                    <span style="font-size:0.8rem; font-weight:700; color:var(--fdf-muted);">${curr == 'DELIVERED' ? 'Fulfilled' : 'Terminated'}</span>
                                    <i class="bi bi-lock-fill" style="opacity:0.4; font-size:0.8rem;"></i>
                                  </div>
                                </c:if>
                              </td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </c:if>
                  </div>
                </div>
              </c:if>

              <%-- ══════ EARNINGS ══════ --%>
                <c:if test="${section == 'earnings'}">
                  <div class="header-info">
                    <h1>Revenue Intelligence</h1>
                  </div>
                  <div class="stats-grid">
                    <div class="stat-box">
                      <div class="stat-icon-circle teal"><i class="bi bi-wallet2"></i></div>
                      <div class="stat-data">
                        <h3>&#8377;${totalEarnings}</h3>
                        <p>Aggregate Payout</p>
                      </div>
                    </div>
                    <div class="stat-box">
                      <div class="stat-icon-circle purple"><i class="bi bi-graph-up"></i></div>
                      <div class="stat-data">
                        <h3>${totalOrders}</h3>
                        <p>Success Transactions</p>
                      </div>
                    </div>
                    <div class="stat-box">
                      <div class="stat-icon-circle pink"><i class="bi bi-stars"></i></div>
                      <div class="stat-data">
                        <h3>${seller.rating} / 5.0</h3>
                        <p>Quality Score</p>
                      </div>
                    </div>
                    <div class="stat-box">
                      <div class="stat-icon-circle gold"><i class="bi bi-shield-check"></i></div>
                      <div class="stat-data">
                        <h3>Verified</h3>
                        <p>Partner Integrity</p>
                      </div>
                    </div>
                  </div>

                  <div class="fdf-section">
                    <div class="fdf-section-header">
                      <h2><i class="bi bi-journal-text"></i> Financial Log Trace</h2>
                    </div>
                    <div class="fdf-section-body" style="padding: 0;">
                      <c:if test="${not empty orders}">
                        <table class="premium-table">
                          <thead>
                            <tr>
                              <th>Transaction Hash</th>
                              <th>Date Pool</th>
                              <th>Product Item</th>
                              <th>Process</th>
                              <th>Status</th>
                              <th style="text-align:right">Settled Amount</th>
                            </tr>
                          </thead>
                          <tbody>
                            <c:forEach var="o" items="${orders}">
                              <c:if test="${o.status != 'CANCELLED'}">
                                <tr>
                                  <td style="font-family:monospace; font-size:0.8rem;">REF-${o.id}</td>
                                  <td>${o.orderTime}</td>
                                  <td style="font-weight: 700;">${o.product.name}</td>
                                  <td>${o.paymentMethod}</td>
                                  <td><span class="fdf-badge badge-${o.status}">${o.status}</span></td>
                                  <td style="text-align:right; font-weight:900; color: #16a34a;">&#8377;${o.totalPrice}
                                  </td>
                                </tr>
                              </c:if>
                            </c:forEach>
                          </tbody>
                        </table>
                      </c:if>
                    </div>
                  </div>
                </c:if>

                <%-- ══════ EXCHANGES ══════ --%>
                  <c:if test="${section == 'exchanges'}">
                    <div class="header-info">
                      <h1>Exchange Management</h1>
                    </div>
                    <div class="fdf-section">
                      <div class="fdf-section-body" style="padding: 0;">
                        <c:set var="hasExchanges" value="false" />
                        <c:forEach var="r" items="${returns}">
                          <c:if test="${r.type == 'EXCHANGE'}">
                            <c:set var="hasExchanges" value="true" />
                          </c:if>
                        </c:forEach>

                        <c:if test="${!hasExchanges}">
                          <div style="padding: 80px; text-align: center; color: var(--fdf-muted);"><i
                              class="bi bi-arrow-left-right"
                              style="font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.3;"></i> No active
                            exchange requests.</div>
                        </c:if>
                        <c:if test="${hasExchanges}">
                          <table class="premium-table">
                            <thead>
                              <tr>
                                <th>Request Info</th>
                                <th>Customer</th>
                                <th>Product</th>
                                <th>Reason</th>
                                <th>Details/Proof</th>
                                <th>Status</th>
                                <th>Action</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="r" items="${returns}">
                                <c:if test="${r.type == 'EXCHANGE'}">
                                  <tr>
                                    <td>
                                      <div style="font-weight:800;">#EXC-${r.id}</div>
                                      <div style="font-size:0.7rem; opacity:0.6;">${r.requestTime}</div>
                                    </td>
                                    <td>
                                      <div style="font-weight:800;">${r.order.user.fullName}</div>
                                      <div style="font-size:0.7rem; opacity:0.6;">${r.order.user.email}</div>
                                    </td>
                                    <td>${r.order.product.name}</td>
                                    <td>
                                      <div style="font-size:0.85rem; font-weight:700;">${r.reason}</div>
                                    </td>
                                    <td>
                                      <div style="font-size:0.75rem; max-width:200px; margin-bottom:8px;">${r.comments}
                                      </div>
                                      <c:if test="${not empty r.imagePath}"><a
                                          href="${pageContext.request.contextPath}${r.imagePath}" target="_blank"
                                          style="color:var(--brand-pink); font-size:0.75rem; font-weight:700;">View
                                          Proof Image</a></c:if>
                                    </td>
                                    <td><span class="fdf-badge badge-${r.status}">${r.status}</span></td>
                                    <td>
                                      <c:set var="rs" value="${r.status}" />
                                      <c:if test="${rs != 'COMPLETED' && rs != 'REJECTED'}">
                                        <form
                                          action="${pageContext.request.contextPath}/women-products/seller/returns/${r.id}/status"
                                          method="post" style="display:flex; gap:8px;">
                                          <input type="hidden" name="section" value="exchanges">
                                          <select name="status" class="form-ctrl"
                                            style="margin-top:0; padding:8px 12px; font-size:0.85rem; width:120px;">
                                            <option value="PENDING" ${rs=='PENDING' ?'selected':''} ${rs !='PENDING'
                                              ? 'disabled' : '' }>Pending</option>
                                            <option value="APPROVED" ${rs=='APPROVED' ?'selected':''} ${(rs !='PENDING'
                                              && rs !='APPROVED' ) ? 'disabled' : '' }>Approve</option>
                                            <option value="REJECTED" ${rs=='REJECTED' ?'selected':''}>Reject</option>
                                            <option value="COMPLETED" ${rs=='COMPLETED' ?'selected':''}>Completed
                                            </option>
                                          </select>
                                          <button type="submit"
                                            style="background:var(--brand-purple); color:#fff; border:none; width:34px; height:34px; border-radius:10px; cursor:pointer;"><i
                                              class="bi bi-save-fill"></i></button>
                                        </form>
                                      </c:if>
                                      <c:if test="${rs == 'COMPLETED' || rs == 'REJECTED'}">
                                        <div style="display:flex; align-items:center; gap:8px; padding-left:12px;">
                                          <span style="font-size:0.85rem; font-weight:700; color:var(--fdf-muted);">${rs
                                            == 'COMPLETED' ? 'Settled' : 'Closed'}</span>
                                          <i class="bi bi-lock-fill" style="opacity:0.3;"></i>
                                        </div>
                                      </c:if>
                                    </td>
                                  </tr>
                                </c:if>
                              </c:forEach>
                            </tbody>
                          </table>
                        </c:if>
                      </div>
                    </div>
                  </c:if>

                  <%-- ══════ REFUNDS ══════ --%>
                    <c:if test="${section == 'refunds'}">
                      <div class="header-info">
                        <h1>Refund Processing</h1>
                      </div>
                      <div class="fdf-section">
                        <div class="fdf-section-body" style="padding: 0;">
                          <c:set var="hasRefunds" value="false" />
                          <c:forEach var="r" items="${returns}">
                            <c:if test="${r.type == 'REFUND' || r.type == 'RETURN'}">
                              <c:set var="hasRefunds" value="true" />
                            </c:if>
                          </c:forEach>

                          <c:if test="${!hasRefunds}">
                            <div style="padding: 80px; text-align: center; color: var(--fdf-muted);"><i
                                class="bi bi-currency-rupee"
                                style="font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.3;"></i> No
                              active refund requests.</div>
                          </c:if>
                          <c:if test="${hasRefunds}">
                            <table class="premium-table">
                              <thead>
                                <tr>
                                  <th>Request Info</th>
                                  <th>Customer</th>
                                  <th>Product</th>
                                  <th>Amount</th>
                                  <th>Bank Details</th>
                                  <th>Status</th>
                                  <th>Action</th>
                                </tr>
                              </thead>
                              <tbody>
                                <c:forEach var="r" items="${returns}">
                                  <c:if test="${r.type == 'REFUND' || r.type == 'RETURN'}">
                                    <tr>
                                      <td>
                                        <div style="font-weight:800;">#REF-${r.id}</div>
                                        <div style="font-size:0.7rem; opacity:0.6;">${r.requestTime}</div>
                                      </td>
                                      <td>
                                        <div style="font-weight:800;">${r.order.user.fullName}</div>
                                        <div style="font-size:0.7rem; opacity:0.6;">${r.order.user.email}</div>
                                      </td>
                                      <td>${r.order.product.name}</td>
                                      <td><span
                                          style="font-weight:900; color:#16a34a;">&#8377;${r.order.totalPrice}</span>
                                      </td>
                                      <td>
                                        <div
                                          style="font-size:0.75rem; background:#f0f9ff; padding:10px; border-radius:12px; border:1px solid #e0f2fe; color:#0369a1;">
                                          <strong>Details:</strong><br>${r.bankDetails}
                                        </div>
                                      </td>
                                      <td><span class="fdf-badge badge-${r.status}">${r.status}</span></td>
                                      <td>
                                        <c:set var="rs" value="${r.status}" />
                                        <c:if test="${rs != 'COMPLETED' && rs != 'REJECTED'}">
                                          <form
                                            action="${pageContext.request.contextPath}/women-products/seller/returns/${r.id}/status"
                                            method="post" style="display:flex; gap:8px;">
                                            <input type="hidden" name="section" value="refunds">
                                            <select name="status" class="form-ctrl"
                                              style="margin-top:0; padding:8px 12px; font-size:0.85rem; width:120px;">
                                              <option value="PENDING" ${rs=='PENDING' ?'selected':''} ${rs !='PENDING'
                                                ? 'disabled' : '' }>Pending</option>
                                              <option value="APPROVED" ${rs=='APPROVED' ?'selected':''} ${(rs
                                                !='PENDING' && rs !='APPROVED' ) ? 'disabled' : '' }>Approve</option>
                                              <option value="REJECTED" ${rs=='REJECTED' ?'selected':''}>Reject</option>
                                              <option value="COMPLETED" ${rs=='COMPLETED' ?'selected':''}>Refunded
                                              </option>
                                            </select>
                                            <button type="submit"
                                              style="background:var(--brand-purple); color:#fff; border:none; width:34px; height:34px; border-radius:10px; cursor:pointer;"><i
                                                class="bi bi-save-fill"></i></button>
                                          </form>
                                        </c:if>
                                        <c:if test="${rs == 'COMPLETED' || rs == 'REJECTED'}">
                                          <div style="display:flex; align-items:center; gap:8px; padding-left:12px;">
                                            <span
                                              style="font-size:0.85rem; font-weight:700; color:var(--fdf-muted);">${rs
                                              == 'COMPLETED' ? 'Disbursed' : 'Closed'}</span>
                                            <i class="bi bi-lock-fill" style="opacity:0.3;"></i>
                                          </div>
                                        </c:if>
                                      </td>
                                    </tr>
                                  </c:if>
                                </c:forEach>
                              </tbody>
                            </table>
                          </c:if>
                        </div>
                      </div>
                    </c:if>

                    <%-- ══════ PROFILE ══════ --%>
                      <c:if test="${section == 'profile'}">
                        <div class="header-info" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom:24px;">
                          <div>
                            <h1 style="margin:0; font-weight:800;">Business & Service Profile</h1>
                            <p style="margin:4px 0 0 0; color:var(--fdf-muted); font-size:0.9rem;">Manage your business identity, professional qualifications, availability and contact details.</p>
                          </div>
                          <button class="btn-fdf-action" onclick="openProfileEditModal()" style="display:flex; align-items:center; gap:8px; padding:12px 24px; font-weight:800; font-size:0.95rem;">
                            <i class="bi bi-pencil-square"></i> Edit Profile
                          </button>
                        </div>

            <%-- Profile Completion Banner --%>
            <c:set var="completedCount" value="0" />
            <c:if test="${not empty seller.fullName}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.businessName}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.profilePhotoPath}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.phone}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.email}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.address}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.serviceArea}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.description}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.qualification}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.experience}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.availableDays}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.workingHoursFrom || not empty seller.workingHoursTo}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>
            <c:if test="${not empty seller.languagesSpoken}"><c:set var="completedCount" value="${completedCount + 1}" /></c:if>

            <fmt:formatNumber value="${completedCount * 100 / 13}" maxFractionDigits="0" var="profilePercent" />

            <div class="fdf-section" style="margin-bottom: 24px; background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); color: #fff; padding: 24px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.1);">
              <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                <div>
                  <h3 style="margin:0; font-weight:800; font-size:1.2rem; color:#fff;"><i class="bi bi-speedometer2" style="color:var(--brand-pink);"></i> Profile Completion</h3>
                  <p style="margin:5px 0 0 0; font-size:0.85rem; opacity:0.8;">Complete all profile information to build customer trust and search visibility.</p>
                </div>
                <div style="background: rgba(255,255,255,0.15); padding: 8px 16px; border-radius: 12px; font-size: 1.3rem; font-weight: 900; color: #38bdf8;">
                  ${profilePercent}%
                </div>
              </div>
              <div style="width: 100%; background: rgba(255,255,255,0.2); height: 12px; border-radius: 6px; overflow: hidden; margin-bottom: 12px;">
                <div style="width: ${profilePercent}%; background: linear-gradient(90deg, #ec4899 0%, #8b5cf6 100%); height: 100%; border-radius: 6px; transition: width 0.5s ease;"></div>
              </div>
              <div style="font-size: 0.8rem; opacity: 0.9; display: flex; gap: 15px; flex-wrap: wrap;">
                <span><i class="bi bi-check-circle-fill" style="color:#4ade80;"></i> ${completedCount} of 13 fields completed</span>
                <c:if test="${profilePercent < 100}">
                  <span style="color: #fca5a5;"><i class="bi bi-exclamation-triangle-fill"></i> Complete remaining fields for 100% profile score</span>
                </c:if>
              </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 24px;">
              <%-- Profile Summary Card --%>
                <div class="fdf-section" style="height: fit-content;">
                  <div class="fdf-section-body" style="text-align: center; padding: 30px;">
                    <div style="position: relative; width: 120px; height: 120px; margin: 0 auto 20px auto;">
                      <c:choose>
                        <c:when test="${not empty seller.profilePhotoPath}">
                          <img src="${pageContext.request.contextPath}${seller.profilePhotoPath}" alt="Logo" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 4px solid var(--brand-pink); box-shadow: var(--shadow-md);">
                        </c:when>
                        <c:otherwise>
                          <div style="width: 120px; height: 120px; border-radius: 50%; background: var(--gradient-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 40px; font-weight: 800; border: 4px solid #fff; box-shadow: var(--shadow-md);">
                            ${not empty seller.businessName ? seller.businessName.substring(0,1) : 'S'}
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <h2 style="font-weight: 800; color: var(--brand-purple-dark); margin-bottom: 15px;">${seller.businessName}</h2>

                    <div style="display: inline-flex; align-items: center; gap: 6px; padding: 6px 16px; border-radius: 20px; background: #ecfdf5; color: #059669; font-weight: 700; font-size: 0.85rem; margin-bottom: 20px;">
                      <i class="bi bi-patch-check-fill"></i> ${seller.verificationStatus}
                    </div>

                    <div style="padding-top: 20px; border-top: 1px solid var(--fdf-border); display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                      <div style="background: #fafafa; padding: 12px; border-radius: 12px;">
                        <div style="font-size: 1.2rem; font-weight: 900; color: var(--brand-purple-dark);">${totalProducts}</div>
                        <div style="font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: var(--fdf-muted);">Products</div>
                      </div>
                      <div style="background: #fafafa; padding: 12px; border-radius: 12px;">
                        <div style="font-size: 1.2rem; font-weight: 900; color: var(--brand-purple-dark);">${totalOrders}</div>
                        <div style="font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: var(--fdf-muted);">Orders</div>
                      </div>
                    </div>
                  </div>
                </div>

              <%-- Detailed Info Sections --%>
                <div>
                  <%-- 1. Profile Information --%>
                  <div class="fdf-section" style="margin-bottom: 20px;">
                    <div class="fdf-section-header">
                      <h2><i class="bi bi-person-badge-fill"></i> Profile Information</h2>
                    </div>
                    <div class="fdf-section-body">
                      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Full Name</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${seller.fullName}</div>
                        </div>
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Business Name</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${seller.businessName}</div>
                        </div>
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Service Area</label>
                          <div style="font-size: 1rem; font-weight: 600; color: var(--brand-purple-dark); margin-top: 4px;">${not empty seller.serviceArea ? seller.serviceArea : 'N/A'}</div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <%-- 2. Contact Information --%>
                  <div class="fdf-section" style="margin-bottom: 20px;">
                    <div class="fdf-section-header">
                      <h2><i class="bi bi-geo-alt-fill"></i> Contact Information</h2>
                    </div>
                    <div class="fdf-section-body">
                      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Phone Number</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${seller.phone}</div>
                        </div>
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Email Address</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${seller.email}</div>
                        </div>
                      </div>
                      <div style="margin-bottom: 15px;">
                        <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Business Address</label>
                        <div style="font-size: 0.95rem; font-weight: 500; color: var(--brand-purple-dark); margin-top: 4px; line-height: 1.5;">${seller.address}</div>
                      </div>
                      <div>
                        <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Business Description</label>
                        <div style="font-size: 0.95rem; font-weight: 500; color: var(--brand-purple-dark); margin-top: 4px; line-height: 1.5;">${not empty seller.description ? seller.description : 'No description provided.'}</div>
                      </div>
                    </div>
                  </div>

                  <%-- 3. Professional Information --%>
                  <div class="fdf-section" style="margin-bottom: 20px;">
                    <div class="fdf-section-header">
                      <h2><i class="bi bi-award-fill"></i> Professional Information</h2>
                    </div>
                    <div class="fdf-section-body">
                      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 15px;">
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Years of Experience</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${not empty seller.experience ? seller.experience : 'N/A'}</div>
                        </div>
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Languages Spoken</label>
                          <div style="font-size: 1rem; font-weight: 600; color: var(--brand-purple-dark); margin-top: 4px;">${not empty seller.languagesSpoken ? seller.languagesSpoken : 'N/A'}</div>
                        </div>
                      </div>
                      <div>
                        <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Qualification / Certification</label>
                        <div style="font-size: 0.95rem; font-weight: 500; color: var(--brand-purple-dark); margin-top: 4px; line-height: 1.5;">${not empty seller.qualification ? seller.qualification : 'N/A'}</div>
                      </div>
                    </div>
                  </div>

                  <%-- 4. Availability --%>
                  <div class="fdf-section">
                    <div class="fdf-section-header">
                      <h2><i class="bi bi-clock-history"></i> Availability & Working Hours</h2>
                    </div>
                    <div class="fdf-section-body">
                      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Available Days</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">${not empty seller.availableDays ? seller.availableDays : 'N/A'}</div>
                        </div>
                        <div>
                          <label style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: var(--fdf-muted);">Working Hours</label>
                          <div style="font-size: 1rem; font-weight: 700; color: var(--brand-purple-dark); margin-top: 4px;">
                            <c:choose>
                              <c:when test="${not empty seller.workingHoursFrom || not empty seller.workingHoursTo}">
                                ${seller.workingHoursFrom} - ${seller.workingHoursTo}
                              </c:when>
                              <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
            </div>
          </c:if>

      <%-- Edit Profile Modal --%>
        <div id="profileEditModal" class="fdf-modal">
          <div class="fdf-modal-content" style="max-width: 750px; max-height: 90vh; overflow-y: auto;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; border-bottom:1px solid #eee; padding-bottom:15px;">
              <h2 style="font-family:'Montserrat',sans-serif; font-weight:900; margin:0;"><i class="bi bi-person-gear"
                  style="color:var(--brand-pink)"></i> Edit Profile</h2>
              <button onclick="document.getElementById('profileEditModal').style.display='none'"
                style="background:none; border:none; font-size:24px; opacity:0.3; cursor:pointer;"><i
                  class="bi bi-x-circle"></i></button>
            </div>
<<<<<<< HEAD

            <form action="${pageContext.request.contextPath}/women-products/seller/profile/update" method="post" enctype="multipart/form-data">
              <%-- Profile Photo Upload & Preview --%>
              <div class="fdf-form-group" style="margin-bottom: 20px; text-align: center; background: #fafafa; padding: 20px; border-radius: 14px; border: 1px dashed #ccc;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase; display:block; margin-bottom:10px;">Profile Photo / Business Logo</label>
                <div style="margin-bottom: 10px;">
                  <img id="photoPreview" src="${not empty seller.profilePhotoPath ? pageContext.request.contextPath.concat(seller.profilePhotoPath) : ''}" style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; ${empty seller.profilePhotoPath ? 'display:none;' : ''} border: 2px solid var(--brand-pink);">
                </div>
                <input type="file" name="profilePhoto" accept="image/png, image/jpeg, image/jpg, image/webp" class="form-ctrl" onchange="previewProfilePhoto(this)">
                <small style="color: #666; font-size: 0.75rem; margin-top: 5px; display: block;">Supported formats: JPG, JPEG, PNG, WEBP</small>
=======
            <form action="${pageContext.request.contextPath}/women-products/seller/profile/update" method="post">
              <div class="fdf-form-group" style="margin-bottom: 15px;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Full Name</label>
                <input type="text" name="fullName" class="form-ctrl" value="${seller.fullName}" required pattern="[A-Za-z\s]{3,50}" title="Must contain only letters and spaces, 3-50 characters">
>>>>>>> 7d4c1bad75957ac7d540688a80cf2ca8a96fbb96
              </div>

              <%-- Basic Info --%>
              <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px; margin-bottom:15px;">
                <div>
<<<<<<< HEAD
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Full Name *</label>
                  <input type="text" name="fullName" class="form-ctrl" value="${seller.fullName}" required>
                </div>
                <div>
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business Name *</label>
                  <input type="text" name="businessName" class="form-ctrl" value="${seller.businessName}" required>
=======
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business Name</label>
                  <input type="text" name="businessName" class="form-ctrl" value="${seller.businessName}" required minlength="3" maxlength="100">
>>>>>>> 7d4c1bad75957ac7d540688a80cf2ca8a96fbb96
                </div>
              </div>

              <div class="fdf-form-group" style="margin-bottom:15px;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Service Area</label>
                <input type="text" name="serviceArea" class="form-ctrl" value="${seller.serviceArea}" placeholder="e.g. Hyderabad, Secunderabad">
              </div>

              <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px; margin-bottom:15px;">
                <div>
<<<<<<< HEAD
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Contact Phone *</label>
                  <input type="tel" name="phone" class="form-ctrl" value="${seller.phone}" required>
=======
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Contact Phone</label>
                  <input type="tel" name="phone" class="form-ctrl" value="${seller.phone}" required pattern="[6-9][0-9]{9}" maxlength="10" title="Valid 10-digit mobile number">
>>>>>>> 7d4c1bad75957ac7d540688a80cf2ca8a96fbb96
                </div>
                <div>
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Years of Experience</label>
                  <select name="experience" class="form-ctrl">
                    <option value="">-- Select Experience --</option>
                    <option value="Less than 1 year" ${seller.experience == 'Less than 1 year' ? 'selected' : ''}>Less than 1 year</option>
                    <option value="1 year" ${seller.experience == '1 year' ? 'selected' : ''}>1 year</option>
                    <option value="2 years" ${seller.experience == '2 years' ? 'selected' : ''}>2 years</option>
                    <option value="3 years" ${seller.experience == '3 years' ? 'selected' : ''}>3 years</option>
                    <option value="4 years" ${seller.experience == '4 years' ? 'selected' : ''}>4 years</option>
                    <option value="5 years" ${seller.experience == '5 years' ? 'selected' : ''}>5 years</option>
                    <option value="6 years" ${seller.experience == '6 years' ? 'selected' : ''}>6 years</option>
                    <option value="7 years" ${seller.experience == '7 years' ? 'selected' : ''}>7 years</option>
                    <option value="8 years" ${seller.experience == '8 years' ? 'selected' : ''}>8 years</option>
                    <option value="9 years" ${seller.experience == '9 years' ? 'selected' : ''}>9 years</option>
                    <option value="10 years" ${seller.experience == '10 years' ? 'selected' : ''}>10 years</option>
                    <option value="11–15 years" ${seller.experience == '11–15 years' ? 'selected' : ''}>11–15 years</option>
                    <option value="16–20 years" ${seller.experience == '16–20 years' ? 'selected' : ''}>16–20 years</option>
                    <option value="20+ years" ${seller.experience == '20+ years' ? 'selected' : ''}>20+ years</option>
                  </select>
                </div>
              </div>

              <div class="fdf-form-group" style="margin-bottom: 15px;">
<<<<<<< HEAD
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business Address *</label>
                <textarea name="address" class="form-ctrl" rows="2" required>${seller.address}</textarea>
              </div>

              <div class="fdf-form-group" style="margin-bottom: 15px;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Qualification / Certification</label>
                <textarea name="qualification" class="form-ctrl" rows="2" placeholder="e.g. Certified Cosmetologist, Skincare & Haircare Specialist, Diploma in Beauty & Wellness">${seller.qualification}</textarea>
=======
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business Address</label>
                <textarea name="address" class="form-ctrl" rows="2" required minlength="10" maxlength="255">${seller.address}</textarea>
              </div>
              <div class="fdf-form-group" style="margin-bottom: 30px;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business
                  Description</label>
                <textarea name="description" class="form-ctrl" rows="3" maxlength="500">${seller.description}</textarea>
>>>>>>> 7d4c1bad75957ac7d540688a80cf2ca8a96fbb96
              </div>

              <div class="fdf-form-group" style="margin-bottom: 15px;">
                <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Business Description</label>
                <textarea name="description" class="form-ctrl" rows="2">${seller.description}</textarea>
              </div>

              <%-- Available Days Multi-Select --%>
              <div class="fdf-form-group" style="margin-bottom: 15px; background: #fafafa; padding: 15px; border-radius: 12px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase; margin:0;">Available Days</label>
                  <div>
                    <button type="button" onclick="toggleAllDays(true)" style="background:none; border:none; color:var(--brand-pink); font-size:0.75rem; font-weight:700; cursor:pointer;">Select All</button> |
                    <button type="button" onclick="toggleAllDays(false)" style="background:none; border:none; color:#666; font-size:0.75rem; font-weight:700; cursor:pointer;">Clear All</button>
                  </div>
                </div>
                <input type="hidden" name="availableDays" id="availableDaysInput" value="${seller.availableDays}">
                <div style="display:flex; flex-wrap:wrap; gap:10px;">
                  <c:forTokens items="Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday" delims="," var="day">
                    <label style="font-size:0.8rem; font-weight:600; background:#fff; padding:6px 12px; border-radius:8px; border:1px solid #ddd; cursor:pointer; display:flex; align-items:center; gap:5px;">
                      <input type="checkbox" class="day-checkbox" value="${day}" onchange="syncAvailableDays()" ${not empty seller.availableDays && seller.availableDays.contains(day) ? 'checked' : ''}> ${day}
                    </label>
                  </c:forTokens>
                </div>
              </div>

              <%-- Working Hours --%>
              <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px; margin-bottom:15px;">
                <div>
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Working Hours (From)</label>
                  <input type="time" name="workingHoursFrom" class="form-ctrl" value="${seller.workingHoursFrom}">
                </div>
                <div>
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase;">Working Hours (To)</label>
                  <input type="time" name="workingHoursTo" class="form-ctrl" value="${seller.workingHoursTo}">
                </div>
              </div>

              <%-- Languages Spoken Multi-Select --%>
              <div class="fdf-form-group" style="margin-bottom: 20px; background: #fafafa; padding: 15px; border-radius: 12px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                  <label style="font-weight:700; font-size:0.85rem; text-transform:uppercase; margin:0;">Languages Spoken</label>
                  <div>
                    <button type="button" onclick="toggleAllLanguages(true)" style="background:none; border:none; color:var(--brand-pink); font-size:0.75rem; font-weight:700; cursor:pointer;">Select All</button> |
                    <button type="button" onclick="toggleAllLanguages(false)" style="background:none; border:none; color:#666; font-size:0.75rem; font-weight:700; cursor:pointer;">Clear All</button>
                  </div>
                </div>
                <input type="hidden" name="languagesSpoken" id="languagesSpokenInput" value="${seller.languagesSpoken}">
                <div style="display:flex; flex-wrap:wrap; gap:8px; max-height:120px; overflow-y:auto;">
                  <c:forTokens items="English,Hindi,Telugu,Tamil,Kannada,Malayalam,Marathi,Bengali,Other" delims="," var="lang">
                    <label style="font-size:0.75rem; font-weight:600; background:#fff; padding:4px 10px; border-radius:6px; border:1px solid #ddd; cursor:pointer; display:flex; align-items:center; gap:4px;">
                      <input type="checkbox" class="lang-checkbox" value="${lang}" onchange="syncLanguagesSpoken()" ${not empty seller.languagesSpoken && seller.languagesSpoken.contains(lang) ? 'checked' : ''}> ${lang}
                    </label>
                  </c:forTokens>
                </div>
              </div>

              <button type="submit" class="btn-fdf-action" style="width:100%; padding: 15px; border-radius: 14px; font-weight:800;">Save Profile Changes</button>
            </form>
          </div>
        </div>

        <script>
          function previewProfilePhoto(input) {
            if (input.files && input.files[0]) {
              const reader = new FileReader();
              reader.onload = function(e) {
                const preview = document.getElementById('photoPreview');
                preview.src = e.target.result;
                preview.style.display = 'block';
              }
              reader.readAsDataURL(input.files[0]);
            }
          }

          function syncAvailableDays() {
            const checked = Array.from(document.querySelectorAll('.day-checkbox:checked')).map(cb => cb.value);
            document.getElementById('availableDaysInput').value = checked.join(', ');
          }

          function toggleAllDays(select) {
            document.querySelectorAll('.day-checkbox').forEach(cb => cb.checked = select);
            syncAvailableDays();
          }

          function syncLanguagesSpoken() {
            const checked = Array.from(document.querySelectorAll('.lang-checkbox:checked')).map(cb => cb.value);
            document.getElementById('languagesSpokenInput').value = checked.join(', ');
          }

          function toggleAllLanguages(select) {
            document.querySelectorAll('.lang-checkbox').forEach(cb => cb.checked = select);
            syncLanguagesSpoken();
          }
        </script>

        <%-- ══════ REVIEWS ══════ --%>
          <c:if test="${section == 'reviews'}">
            <div class="header-info" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom:24px; width:100%;">
              <div>
                <h1 style="margin:0; font-weight:800;">Customer Feedback</h1>
                <p style="margin:4px 0 0 0; color:var(--fdf-muted); font-size:0.9rem;">View rating history, customer comments, and product impact reviews.</p>
              </div>
              <div
                style="background: #fff; padding: 10px 20px; border-radius: 14px; border: 1px solid var(--fdf-border); display: flex; align-items: center; gap: 10px; box-shadow: var(--shadow-sm);">
                <span style="font-weight: 800; color: var(--brand-purple-dark);">Aggregate Rating:</span>
                <span style="color: #ffca08; font-size: 1.1rem; font-weight: 900;">
                  <i class="bi bi-star-fill"></i> ${seller.rating} / 5.0
                </span>
              </div>
            </div>

            <div class="fdf-section">
              <div class="fdf-section-header">
                <h2><i class="bi bi-chat-square-text-fill"></i> All Reviews</h2>
              </div>
              <div class="fdf-section-body">
                <c:set var="hasReviews" value="false" />
                <c:forEach var="o" items="${orders}">
                  <c:if test="${not empty o.rating}">
                    <c:set var="hasReviews" value="true" />
                    <div
                      style="padding: 24px; border-radius: 20px; background: #fafafa; margin-bottom: 20px; border: 1px solid #eee; transition: 0.3s;"
                      onmouseover="this.style.background='#fff'; this.style.boxShadow='var(--shadow-md)';"
                      onmouseout="this.style.background='#fafafa'; this.style.boxShadow='none';">
                      <div
                        style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                        <div style="display: flex; align-items: center; gap: 14px;">
                          <div
                            style="width: 48px; height: 48px; border-radius: 16px; background: var(--gradient-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px;">
                            ${not empty o.user.fullName ? o.user.fullName.substring(0,1) : 'U'}
                          </div>
                          <div>
                            <div style="font-weight: 800; font-size: 1rem; color: var(--brand-purple-darker);">
                              ${o.user.fullName}</div>
                            <div style="font-size: 0.8rem; color: var(--fdf-muted); font-weight: 500;">Order #${o.id} •
                              ${o.orderTime}</div>
                          </div>
                        </div>
                        <div
                          style="background: #fff; padding: 6px 12px; border-radius: 10px; border: 1px solid #eee; color: #ffca08; font-size: 0.9rem; font-weight: 800; display: flex; align-items: center; gap: 5px;">
                          <i class="bi bi-star-fill"></i> ${o.rating}.0
                        </div>
                      </div>

                      <div
                        style="background: #fff; padding: 20px; border-radius: 14px; border-left: 4px solid var(--brand-pink); font-size: 0.95rem; color: var(--fdf-text); line-height: 1.6; margin-bottom: 15px; font-style: italic;">
                        "${o.review}"
                      </div>

                      <div
                        style="display: flex; align-items: center; gap: 10px; padding-top: 10px; border-top: 1px solid #f0f0f0;">
                        <div
                          style="font-size: 0.8rem; font-weight: 700; color: var(--fdf-muted); text-transform: uppercase; letter-spacing: 0.5px;">
                          Product Impact:</div>
                        <div style="font-size: 0.9rem; font-weight: 700; color: var(--brand-pink);">${o.product.name}
                        </div>
                      </div>
                    </div>
                  </c:if>
                </c:forEach>

                <c:if test="${!hasReviews}">
                  <div style="text-align: center; padding: 100px 40px; color: var(--fdf-muted);">
                    <i class="bi bi-chat-square-dots"
                      style="font-size: 64px; display: block; margin-bottom: 20px; opacity: 0.2;"></i>
                    <h3 style="font-weight: 800; color: var(--brand-purple-dark);">No Reviews Yet</h3>
                    <p style="font-size: 0.95rem;">Encourage your customers to leave feedback after their purchase!</p>
                  </div>
                </c:if>
              </div>
            </div>
          </c:if>
          </div>

          <script>
            function openAddModal() {
              const modal = document.getElementById('productModal');
              const form = document.getElementById('productForm');
              const title = document.getElementById('modalTitle');

              title.innerHTML = '<i class="bi bi-rocket-takeoff-fill" style="color:var(--brand-pink)"></i> Catalog Deployment';
              form.action = '${pageContext.request.contextPath}/women-products/seller/products/add';
              form.reset();

              const idInput = document.getElementById('editProductId');
              if (idInput) idInput.value = '';

              // Set defaults
              form.querySelector('[name="active"]').checked = true;
              form.querySelector('[name="trackInventory"]').checked = true;
              form.querySelector('[name="featured"]').checked = false;
              form.querySelector('[name="images"]').setAttribute('required', 'required');

              modal.style.display = 'flex';
            }

            function openEditModal(p) {
              if (!p || !p.id) {
                alert("Error: Product ID is missing.");
                return;
              }
              const modal = document.getElementById('productModal');
              const form = document.getElementById('productForm');
              const title = document.getElementById('modalTitle');

              title.innerHTML = '<i class="bi bi-pencil-square" style="color:var(--brand-pink)"></i> Update Product Trace';
              form.action = '${pageContext.request.contextPath}/women-products/seller/products/' + p.id + '/edit';
              form.querySelector('[name="images"]').removeAttribute('required');

              const idInput = document.getElementById('editProductId');
              if (idInput) idInput.value = p.id;

              // Fill fields
              form.querySelector('[name="name"]').value = p.name || '';
              form.querySelector('[name="brand"]').value = p.brand || '';
              form.querySelector('[name="description"]').value = p.description || '';
              form.querySelector('[name="fullDescription"]').value = p.fullDescription || '';
              form.querySelector('[name="price"]').value = p.price || '';
              form.querySelector('[name="originalPrice"]').value = p.originalPrice || '';
              form.querySelector('[name="offerBadge"]').value = p.offerBadge || '';
              form.querySelector('[name="stock"]').value = p.stock || '';
              form.querySelector('[name="lowStockAlertLevel"]').value = p.lowStockAlertLevel || 5;
              form.querySelector('[name="sku"]').value = p.sku || '';
              form.querySelector('[name="category"]').value = p.category || '';
              form.querySelector('[name="weightSize"]').value = p.weightSize || '';
              form.querySelector('[name="manufacturer"]').value = p.manufacturer || '';
              form.querySelector('[name="ingredients"]').value = p.ingredients || '';
              form.querySelector('[name="benefits"]').value = p.benefits || '';
              form.querySelector('[name="usageInstructions"]').value = p.usageInstructions || '';
              form.querySelector('[name="tags"]').value = p.tags || '';

              form.querySelector('[name="active"]').checked = p.active;
              form.querySelector('[name="featured"]').checked = p.featured;
              form.querySelector('[name="trackInventory"]').checked = p.trackInventory;

              modal.style.display = 'flex';
            }

            function openProfileEditModal() {
              document.getElementById('profileEditModal').style.display = 'flex';
            }

            // Close modal on outside click
            window.onclick = function (event) {
              const pModal = document.getElementById('productModal');
              const sModal = document.getElementById('profileEditModal');
              if (event.target == pModal) {
                pModal.style.display = "none";
              }
              if (event.target == sModal) {
                sModal.style.display = "none";
              }
            }

            function toggleMobileSidebar() {
              document.querySelector('.fdf-sidebar').classList.toggle('show');
              document.querySelector('.sidebar-overlay').classList.toggle('show');
            }

            function calculateAutoOfferBadge() {
              const priceInput = document.querySelector('#productForm [name="price"]');
              const mrpInput = document.querySelector('#productForm [name="originalPrice"]');
              const offerInput = document.querySelector('#productForm [name="offerBadge"]');

              if (!priceInput || !mrpInput || !offerInput) return;

              const price = parseFloat(priceInput.value);
              const mrp = parseFloat(mrpInput.value);

              if (!isNaN(price) && !isNaN(mrp) && mrp > price && price > 0) {
                const discount = Math.round(((mrp - price) / mrp) * 100);
                if (discount > 0) {
                  offerInput.value = discount + '% OFF';
                }
              } else if (isNaN(mrp) || mrp <= price) {
                if (offerInput.value && offerInput.value.endsWith('% OFF')) {
                  offerInput.value = '';
                }
              }
            }

            document.addEventListener("DOMContentLoaded", function() {
              const pForm = document.getElementById('productForm');
              if (pForm) {
                pForm.addEventListener('submit', function() {
                  const idVal = document.getElementById('editProductId') ? document.getElementById('editProductId').value : '';
                  if (idVal && (!this.action || this.action.includes('//edit') || (!this.action.includes('/add') && !this.action.includes('/' + idVal + '/edit')))) {
                    this.action = '${pageContext.request.contextPath}/women-products/seller/products/' + idVal + '/edit';
                  }
                });

                const priceInput = pForm.querySelector('[name="price"]');
                const mrpInput = pForm.querySelector('[name="originalPrice"]');
                if (priceInput) priceInput.addEventListener('input', calculateAutoOfferBadge);
                if (mrpInput) mrpInput.addEventListener('input', calculateAutoOfferBadge);
              }

              document.querySelectorAll('.edit-product-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                  const p = {
                    id: this.getAttribute('data-id'),
                    name: this.getAttribute('data-name'),
                    brand: this.getAttribute('data-brand'),
                    description: this.getAttribute('data-description'),
                    fullDescription: this.getAttribute('data-fullDescription'),
                    price: this.getAttribute('data-price'),
                    originalPrice: this.getAttribute('data-originalPrice'),
<<<<<<< HEAD
                    offerBadge: this.getAttribute('data-offerbadge') || this.getAttribute('data-offer-badge'),
=======
                    offerBadge: this.getAttribute('data-offerBadge'),
>>>>>>> 7d4c1bad75957ac7d540688a80cf2ca8a96fbb96
                    stock: this.getAttribute('data-stock'),
                    lowStockAlertLevel: this.getAttribute('data-lowStockAlertLevel'),
                    sku: this.getAttribute('data-sku'),
                    category: this.getAttribute('data-category'),
                    weightSize: this.getAttribute('data-weightSize'),
                    manufacturer: this.getAttribute('data-manufacturer'),
                    ingredients: this.getAttribute('data-ingredients'),
                    benefits: this.getAttribute('data-benefits'),
                    usageInstructions: this.getAttribute('data-usageInstructions'),
                    tags: this.getAttribute('data-tags'),
                    active: this.getAttribute('data-active') === 'true',
                    featured: this.getAttribute('data-featured') === 'true',
                    trackInventory: this.getAttribute('data-trackInventory') === 'true'
                  };
                  if (!p.id) {
                    alert("Error: Product ID is missing.");
                    return;
                  }
                  openEditModal(p);
                });
              });

              // Dynamic AJAX Order Status Update
              document.querySelectorAll('.seller-order-form').forEach(form => {
                form.addEventListener('submit', function(e) {
                  e.preventDefault();
                  const orderId = this.getAttribute('data-order-id');
                  const selectEl = this.querySelector('select[name="status"]');
                  const newStatus = selectEl.value;
                  const btn = this.querySelector('button[type="submit"]');

                  if (btn) btn.disabled = true;

                  const formData = new URLSearchParams();
                  formData.append('status', newStatus);

                  fetch('${pageContext.request.contextPath}/women-products/seller/orders/' + orderId + '/status/ajax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                  })
                  .then(res => res.json())
                  .then(data => {
                    if (btn) btn.disabled = false;
                    if (data.status === 'SUCCESS') {
                      // Dynamically update status badge cell in table
                      const row = form.closest('tr');
                      if (row) {
                        const badgeSpan = row.querySelector('.fdf-badge');
                        if (badgeSpan) {
                          badgeSpan.className = 'fdf-badge badge-' + data.newStatus;
                          badgeSpan.textContent = data.newStatus;
                        }
                      }
                      if (data.newStatus === 'DELIVERED' || data.newStatus === 'CANCELLED') {
                        const cell = document.getElementById('orderStatusCell_' + orderId);
                        if (cell) {
                          const text = data.newStatus === 'DELIVERED' ? 'Fulfilled' : 'Terminated';
                          cell.innerHTML = '<div style="display:flex; align-items:center; gap:8px; padding-left:12px;"><span style="font-size:0.85rem; font-weight:700; color:var(--fdf-muted);">' + text + '</span><i class="bi bi-lock-fill" style="opacity:0.3;"></i></div>';
                        }
                      }
                    } else {
                      alert('Failed to update status: ' + (data.message || 'Error'));
                    }
                  })
                  .catch(err => {
                    if (btn) btn.disabled = false;
                    // Fallback to normal form submission if needed
                    form.submit();
                  });
                });
              });
            });
          </script>
    </body>

    </html>
