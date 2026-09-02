<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Product Sellers Verification — Admin</title>
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
  body.wp-admin-wp .status-VERIFIED { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-PENDING { background: #FEF3C7; color: #B45309; }
  body.wp-admin-wp .status-REJECTED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .status-PLACED { background: #FEF3C7; color: #854d0e; }
  body.wp-admin-wp .status-CONFIRMED { background: var(--ap-info-bg); color: var(--ap-info); }
  body.wp-admin-wp .status-SHIPPED { background: var(--ap-info-bg); color: var(--ap-info); }
  body.wp-admin-wp .status-DELIVERED { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-CANCELLED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .status-IN-STOCK { background: var(--ap-success-bg); color: var(--ap-success); }
  body.wp-admin-wp .status-LOW-STOCK { background: #FEF3C7; color: #854d0e; }
  body.wp-admin-wp .status-OUT-OF-STOCK { background: var(--ap-danger-bg); color: var(--ap-danger); }
  body.wp-admin-wp .btn-approve { background: var(--ap-success); color: #fff; padding: 7px 12px; border: 0; border-radius: 9px; font-size: 0.8rem; font-weight: 700; }
  body.wp-admin-wp .btn-reject { background: var(--ap-danger); color: #fff; padding: 7px 12px; border: 0; border-radius: 9px; font-size: 0.8rem; font-weight: 700; }
  body.wp-admin-wp .btn-view-media, body.wp-admin-wp .btn-view-seller {
    display: inline-flex; align-items: center; gap: 6px; background: #fff; color: var(--ap-text);
    border: 1px solid var(--ap-border); padding: 7px 12px; border-radius: 9px; font-size: 0.8rem; font-weight: 600;
    text-decoration: none;
  }
  body.wp-admin-wp .btn-view-media:hover, body.wp-admin-wp .btn-view-seller:hover { border-color: #FDA4AF; color: var(--ap-accent); }
  body.wp-admin-wp .d-flex.gap-1 { gap: 8px !important; }
  body.wp-admin-wp .seller-meta { font-size: 0.78rem; color: var(--ap-muted); display: flex; flex-direction: column; gap: 2px; }
  body.wp-admin-wp .product-thumb { width: 40px; height: 40px; object-fit: cover; border-radius: 50%; }
  body.wp-admin-wp .meta-text { font-size: 0.78rem; color: var(--ap-muted); }
  @media (max-width: 700px) {
    body.wp-admin-wp .mainInner { padding: 16px 14px 40px; }
    body.wp-admin-wp .ap-stats { grid-template-columns: 1fr !important; }
  }
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
        <span>Product Sellers</span>
      </nav>
      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-shopping-bag"></i></div>
        <div>
          <h1>Women Product Sellers</h1>
          <p>Review and verify sellers offering safety and women's products</p>
        </div>
      </div>
      <div class="ap-stats" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${not empty pending ? pending.size() : 0}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Awaiting review</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${not empty verified ? verified.size() : 0}</div>
          <div class="lbl">Verified</div>
          <div class="sub">Live on shop</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${not empty rejected ? rejected.size() : 0}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not listed</div>
        </div>
      </div>

      <c:if test="${not empty message}">
          <div class="alert alert-success mb-4" style="border-radius:10px;"><i class="fas fa-check-circle me-1"></i> ${message}</div>
      </c:if>
      <c:if test="${not empty error}">
          <div class="alert alert-danger mb-4" style="border-radius:10px;"><i class="fas fa-exclamation-circle me-1"></i> ${error}</div>
      </c:if>

      <!-- Pending Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-clock text-warning"></i> Pending Sellers
          <span class="badge-count">${not empty pending ? pending.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Contact Info</th>
                      <th>Business Address</th>
                      <th>Identity Doc</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty pending}">
                      <c:forEach var="s" items="${pending}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-envelope text-muted me-1"></i> ${s.email}</span>
                                      <span><i class="fas fa-phone text-muted me-1"></i> ${s.phone}</span>
                                  </div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-map-marker-alt text-muted me-1"></i> ${s.address}</span>
                                  </div>
                              </td>
                              <td>
                                  <c:choose>
                                      <c:when test="${not empty s.identityDocPath}">
                                          <a href="${pageContext.request.contextPath}${s.identityDocPath}" target="_blank" class="btn-view-media">
                                            <i class="fas fa-id-card me-1"></i> View ID
                                          </a>
                                      </c:when>
                                      <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                  </c:choose>
                              </td>
                              <td><span class="badge-status status-PENDING"><i class="fas fa-clock me-1"></i> PENDING</span></td>
                              <td>
                                  <div class="d-flex justify-content-center align-items-center gap-1">
                                    <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-2" title="View Profile">
                                        <i class="fas fa-user"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/verify" method="post" class="m-0 p-0">
                                        <button class="btn-approve" type="submit" title="Verify"><i class="fas fa-check"></i></button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/reject" method="post" class="m-0 p-0"
                                          onsubmit="var r=prompt('Enter rejection reason (required):'); if(!r||!r.trim()){alert('Rejection reason is required.'); return false;} this.querySelector('[name=reason]').value=r.trim();">
                                        <input type="hidden" name="reason" value="">
                                        <button class="btn-reject" type="submit" title="Reject"><i class="fas fa-times"></i></button>
                                    </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="6" class="py-4 text-center text-muted"><i class="fas fa-check-circle fa-2x mb-2 d-block text-success" style="opacity:0.4;"></i>No pending sellers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace women's product partners (alternate registration path) -->
      <c:if test="${not empty pendingMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-warning"></i> Pending — Marketplace Women's Products
          <span class="badge-count">${pendingMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${pendingMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td>${p.locationText}</td>
                  <td><span class="badge-status status-PENDING">PENDING</span></td>
                  <td>
                    <div class="d-flex justify-content-center gap-1">
                      <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-2" title="View"><i class="fas fa-user"></i></a>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0"><button class="btn-approve" type="submit"><i class="fas fa-check"></i></button></form>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/reject" method="post" class="m-0"><button class="btn-reject" type="submit"><i class="fas fa-times"></i></button></form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

      <!-- Verified Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-success"></i> Verified Sellers
          <span class="badge-count" style="background:#166534;">${not empty verified ? verified.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Contact Info</th>
                      <th>Business Address</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty verified}">
                      <c:forEach var="s" items="${verified}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-envelope text-muted me-1"></i> ${s.email}</span>
                                      <span><i class="fas fa-phone text-muted me-1"></i> ${s.phone}</span>
                                  </div>
                              </td>
                              <td>
                                  <div class="seller-meta">
                                      <span><i class="fas fa-map-marker-alt text-muted me-1"></i> ${s.address}</span>
                                  </div>
                              </td>
                              <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                              <td>
                                  <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-3" title="View Profile">
                                      <i class="fas fa-user me-1"></i> View Profile
                                  </a>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="5" class="py-4 text-center text-muted">No verified sellers yet.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace verified women's product partners -->
      <c:if test="${not empty verifiedMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store text-success"></i> Verified — Marketplace Women's Products
          <span class="badge-count" style="background:#166534;">${verifiedMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${verifiedMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td>${p.locationText}</td>
                  <td><span class="badge-status status-VERIFIED"><i class="fas fa-check-circle me-1"></i> VERIFIED</span></td>
                  <td>
                    <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-3" title="View"><i class="fas fa-user me-1"></i> View Profile</a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

      <!-- Rejected Sellers Table -->
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store-alt-slash text-danger"></i> Rejected Sellers
          <span class="badge-count" style="background:#991b1b;">${not empty rejected ? rejected.size() : 0}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
              <thead>
                  <tr>
                      <th>Seller Details</th>
                      <th>Email</th>
                      <th>Status</th>
                      <th>Action</th>
                  </tr>
              </thead>
              <tbody>
              <c:choose>
                  <c:when test="${not empty rejected}">
                      <c:forEach var="s" items="${rejected}">
                          <tr>
                              <td>
                                  <div class="fw-bold text-dark">${s.fullName}</div>
                                  <div class="text-muted small"><i class="fas fa-store me-1"></i> ${s.businessName}</div>
                              </td>
                              <td>${s.email}</td>
                              <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                              <td>
                                  <div class="d-flex gap-1">
                                      <a href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" class="btn-view-media px-2" title="View Profile">
                                          <i class="fas fa-user"></i>
                                      </a>
                                      <form action="${pageContext.request.contextPath}/admin/sellers/${s.id}/verify" method="post" class="m-0 p-0">
                                          <button class="btn-approve px-3" type="submit" title="Re-verify"><i class="fas fa-undo me-1"></i> Re-verify</button>
                                      </form>
                                  </div>
                              </td>
                          </tr>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                      <tr>
                          <td colspan="4" class="py-4 text-center text-muted">No rejected sellers.</td>
                      </tr>
                  </c:otherwise>
              </c:choose>
              </tbody>
          </table>
        </div>
      </div>

      <!-- Marketplace rejected women's product partners -->
      <c:if test="${not empty rejectedMarketplace}">
      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-store-alt-slash text-danger"></i> Rejected — Marketplace Women's Products
          <span class="badge-count" style="background:#991b1b;">${rejectedMarketplace.size()}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Provider</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${rejectedMarketplace}">
                <tr>
                  <td>
                    <div class="fw-bold text-dark">${p.fullName}</div>
                    <div class="text-muted small">${p.description}</div>
                  </td>
                  <td>
                    <div class="seller-meta">
                      <span><i class="fas fa-envelope text-muted me-1"></i> ${p.email}</span>
                      <span><i class="fas fa-phone text-muted me-1"></i> ${p.phone}</span>
                    </div>
                  </td>
                  <td><span class="badge-status status-REJECTED"><i class="fas fa-times-circle me-1"></i> REJECTED</span></td>
                  <td>
                    <div class="d-flex gap-1">
                      <a href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" class="btn-view-media px-2" title="View"><i class="fas fa-user"></i></a>
                      <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0"><button class="btn-approve px-3" type="submit"><i class="fas fa-undo me-1"></i> Re-verify</button></form>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      </c:if>

    </div>
  </main>
</div>

</body>
</html>

