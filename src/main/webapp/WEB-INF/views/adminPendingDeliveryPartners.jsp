<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pending Delivery Partners | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.wp-admin-wp { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; }
    body.wp-admin-wp .layout { display: flex; min-height: 100vh; }
    body.wp-admin-wp .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    body.wp-admin-wp .mainInner { max-width: 1400px; margin: 0 auto; padding: 22px 24px 48px; }
    body.wp-admin-wp .card-panel {
      background: var(--ap-card); border-radius: var(--ap-radius); box-shadow: var(--ap-shadow);
      border: 1px solid var(--ap-border); overflow: hidden;
    }
    body.wp-admin-wp .table { margin-bottom: 0; min-width: 720px; }
    body.wp-admin-wp .table thead th {
      text-align: left; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
      text-transform: uppercase; letter-spacing: 0.04em; padding: 12px 14px;
      border-bottom: 1px solid var(--ap-border); background: #FCFCFD;
    }
    body.wp-admin-wp .table tbody td { padding: 14px; border-bottom: 1px solid #F1F5F9; vertical-align: middle; font-size: 0.86rem; }
    body.wp-admin-wp .table tbody tr:hover { background: #FFF7F8; }
    body.wp-admin-wp .btn-approve { background: var(--ap-success); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; }
    body.wp-admin-wp .btn-reject { background: var(--ap-danger); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; }
    body.wp-admin-wp .btn-changes { background: var(--ap-warn); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; }
    body.wp-admin-wp .ap-input { min-width: 140px; }
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
          <input type="search" placeholder="Search anything..." aria-label="Search">
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
        <span>Delivery Partners</span>
      </nav>
      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-truck"></i></div>
        <div>
          <h1>Pending Delivery Partners</h1>
          <p>Review Join Us → Delivery Guy submissions (${pendingCount})</p>
        </div>
      </div>
      <div class="ap-stats" style="grid-template-columns: repeat(1, minmax(0, 220px));">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pendingCount}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Awaiting review</div>
        </div>
      </div>

  <c:if test="${not empty message}">
    <div class="alert alert-success">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <div class="card-panel">
    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
        <tr>
          <th>Partner</th>
          <th>Status</th>
          <th>City / Vehicle</th>
          <th>Contact</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${not empty pendingPartners}">
            <c:forEach var="d" items="${pendingPartners}">
              <tr>
                <td>
                  <span class="fw-semibold d-block">${d.fullName}</span>
                  <small class="text-muted">${d.email}</small>
                  <div class="small text-muted mt-1">${d.profileCompletionPct != null ? d.profileCompletionPct : 0}% complete</div>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${d.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                      <span class="badge bg-warning text-dark">Pending approval</span>
                    </c:when>
                    <c:when test="${d.partnerProfileStatus == 'READY_FOR_VERIFICATION'}">
                      <span class="badge bg-info text-dark">Ready to submit</span>
                    </c:when>
                    <c:when test="${d.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                      <span class="badge text-dark" style="background:#fdba74;">Changes requested</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary">${empty d.partnerProfileStatus ? 'Incomplete' : d.partnerProfileStatus}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="small">
                  <div>${empty d.city ? '—' : d.city}</div>
                  <div class="text-muted">${empty d.vehicleType ? 'No vehicle' : d.vehicleType} · ${empty d.serviceArea ? '' : d.serviceArea}</div>
                </td>
                <td class="small">${empty d.phone ? '—' : d.phone}</td>
                <td>
                  <div class="d-flex flex-wrap gap-2">
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/approve" method="post" class="m-0">
                      <button type="submit" class="btn-approve"><i class="fas fa-check me-1"></i>Approve</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/reject" method="post" class="m-0"
                          onsubmit="return confirm('Reject this delivery partner?');">
                      <input type="text" name="reason" placeholder="Reason" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-reject"><i class="fas fa-times me-1"></i>Reject</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/delivery-partners/${d.id}/request-changes" method="post" class="m-0">
                      <input type="text" name="note" placeholder="Changes note" class="form-control form-control-sm mb-1" style="min-width:140px;">
                      <button type="submit" class="btn-changes"><i class="fas fa-edit me-1"></i>Request changes</button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="5" class="py-4 text-center text-muted">
                <i class="fas fa-check-circle fa-2x mb-2 d-block" style="opacity:.4;"></i>
                No pending delivery partner requests.
              </td>
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
</body>
</html>
