<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Event Host Verification — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary: #F43F5E;       /* 10% accent */
    --rose-soft: #FFF1F2;
    --bg: #F8FAFC;            /* 60% surface */
    --navy: #0F172A;          /* 30% chrome */
    --navy-mid: #1E293B;
    --border: #E2E8F0;
    --text-muted: #64748B;
    --shadow-sm: 0 6px 20px rgba(15, 23, 42, 0.08);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--bg); color:var(--navy-mid); }

  .topbar {
    background: var(--navy); color:#fff;
    padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
    border-bottom: 1px solid rgba(255,255,255,0.08);
  }
  .topbar .brand {
    color: #fff; text-decoration: none;
    display: flex; align-items: center; gap: 10px;
    font-size: 1.05rem; font-weight: 700; font-family: 'Outfit', sans-serif;
  }
  .topbar .brand img { height: 32px; width: 32px; border-radius: 8px; object-fit: cover; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff;
    border:1px solid rgba(255,255,255,0.3); border-radius:8px;
    padding:6px 14px; font-size:0.85rem; font-weight:600; text-decoration:none;
  }

  .layout { display:flex; min-height:calc(100vh - 58px); }
  .sidebar {
    width: var(--sidebar-w); background:#fff;
    border-right:1px solid var(--border);
    position:sticky; top:58px; height:calc(100vh - 58px);
    padding:14px 12px; overflow-y:auto; flex-shrink:0;
  }
  .brand { font-size: 0.9rem; font-weight: 700; color: var(--navy); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; margin-bottom: 2px;
  }
  .navlink i { width: 20px; text-align: center; color: var(--primary); }
  .navlink:hover { background: var(--rose-soft); color: var(--navy); }
  .navlink.active { background: var(--primary); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(244,63,94,0.2); }
  .navlink.active i { color: #fff; }

  .main { flex:1; min-width:0; padding:28px 20px 48px; }
  .mainInner { max-width:1200px; margin:0 auto; }

  .pg-header {
    background: linear-gradient(135deg, var(--navy) 0%, var(--navy-mid) 62%, #334155 100%);
    border-radius:16px; padding:22px 28px; margin-bottom:24px;
    box-shadow:0 8px 26px rgba(15,23,42,0.22);
    display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap;
  }
  .pg-header h4 { color:#fff; font-weight:800; font-size:1.2rem; margin:0; font-family:'Outfit',sans-serif; }
  .pg-header p { color:rgba(255,255,255,0.72); margin:4px 0 0; font-size:0.85rem; }

  .stat-pills { display:flex; gap:8px; flex-wrap:wrap; }
  .stat-pill {
    background: rgba(255,255,255,0.12); color:#fff; border:1px solid rgba(255,255,255,0.18);
    border-radius:999px; padding:6px 12px; font-size:0.78rem; font-weight:700;
  }
  .stat-pill strong { color: #fda4af; }

  .card-table {
    background:#fff; border-radius:16px; overflow:hidden;
    border:1px solid var(--border); box-shadow:var(--shadow-sm);
    margin-bottom: 24px;
  }
  .card-table-header {
    background: var(--rose-soft);
    padding: 16px 20px;
    border-bottom: 1px solid var(--border);
    font-weight: 700; color: var(--navy);
    display: flex; align-items: center; gap: 8px; flex-wrap:wrap;
  }
  .card-table-header i { color: var(--primary); }

  .table { margin-bottom:0; }
  .table thead th {
    background: #F8FAFC; color:var(--navy);
    font-size:0.72rem; font-weight:700; text-transform:uppercase;
    letter-spacing:0.05em; padding:14px 16px; border:none; border-bottom:1px solid var(--border);
    text-align:left; white-space:nowrap;
  }
  .table tbody td {
    padding:14px 16px; vertical-align:middle; border-bottom:1px solid var(--border);
    font-size:0.9rem; text-align:left;
  }
  .table tbody tr:last-child td { border-bottom: none; }
  .table tbody tr:hover { background:rgba(244,63,94,0.04); }
  .cell-muted { color: var(--text-muted); font-size: 0.8rem; }
  .cell-name { font-weight:700; color:var(--navy); }
  .cell-clip { max-width: 180px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

  .badge-status {
    padding:6px 12px; border-radius:999px; font-size:0.72rem; font-weight:700;
    display:inline-block; border:1px solid transparent; white-space:nowrap;
  }
  .status-APPROVED, .status-VERIFIED { background:#d1fae5; color:#065f46; border-color:#a7f3d0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background:#fef3c7; color:#92400e; border-color:#fde68a; }
  .status-READY_FOR_VERIFICATION { background:#e0f2fe; color:#075985; border-color:#bae6fd; }
  .status-CHANGES_REQUESTED { background:#ffedd5; color:#9a3412; border-color:#fed7aa; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background:#f1f5f9; color:#475569; border-color:#cbd5e1; }
  .status-REJECTED, .status-SUSPENDED { background:#fee2e2; color:#991b1b; border-color:#fecaca; }

  .btn-approve {
    background-color: #059669; color: #fff; border: none; border-radius: 8px;
    padding: 6px 14px; font-size: 0.82rem; font-weight: 700;
  }
  .btn-approve:hover { background-color: #047857; color:#fff; }
  .btn-reject {
    background-color: #dc2626; color: #fff; border: none; border-radius: 8px;
    padding: 6px 14px; font-size: 0.82rem; font-weight: 700;
  }
  .btn-reject:hover { background-color: #b91c1c; color:#fff; }
  .btn-profile {
    display: inline-flex; align-items: center; justify-content: center; gap: 6px;
    background: #fff; color: var(--primary); border: 1px solid #fecdd3;
    padding: 6px 14px; border-radius: 8px; font-size: 0.82rem; font-weight: 700;
    text-decoration: none; white-space: nowrap;
  }
  .btn-profile:hover { background: var(--primary); color: #fff; box-shadow: 0 4px 12px rgba(244,63,94,0.2); }

  .table-responsive { width: 100%; overflow-x: auto; }
  .legacy-link { color: var(--text-muted); font-size: 0.82rem; }
  .legacy-link a { color: var(--primary); font-weight: 700; text-decoration: none; }

  @media(max-width:992px){
    .layout{flex-direction:column;}
    .sidebar{width:100%;position:relative;top:0;height:auto;border-right:none;border-bottom:1px solid var(--border);}
  }
  @media (max-width: 768px) {
    .main { padding: 16px 12px 34px; }
    .pg-header { padding: 18px 16px; }
    .table-responsive.responsive-card-table table,
    .table-responsive.responsive-card-table thead,
    .table-responsive.responsive-card-table tbody,
    .table-responsive.responsive-card-table th,
    .table-responsive.responsive-card-table td,
    .table-responsive.responsive-card-table tr { display: block; width: 100%; }
    .table-responsive.responsive-card-table thead {
      position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
      overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border: 0;
    }
    .table-responsive.responsive-card-table tbody tr {
      background: #fff; border: 1px solid var(--border); border-radius: 12px;
      margin: 12px; padding: 8px 10px;
    }
    .table-responsive.responsive-card-table tbody td {
      border: 0; display: flex; align-items: flex-start; justify-content: space-between;
      gap: 12px; padding: 8px 2px; text-align: left; border-bottom: 1px dashed #e5e7eb;
    }
    .table-responsive.responsive-card-table tbody td:last-child { border-bottom: 0; }
    .table-responsive.responsive-card-table tbody td::before {
      content: attr(data-label); color: var(--text-muted); font-size: 0.72rem;
      font-weight: 700; text-transform: uppercase; flex: 0 0 38%;
    }
    .cell-clip { max-width: 58%; white-space: normal; }
  }
</style>
</head>
<body>
<div class="topbar">
  <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
    <span>Fight D Fear Admin</span>
  </a>
  <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
    <i class="fas fa-sign-out-alt"></i> Logout
  </a>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">
      <div class="pg-header">
        <div>
          <h4><i class="fas fa-calendar-check me-2"></i>Event Host Verification</h4>
          <p>Review organizer profiles before they can publish events</p>
        </div>
        <div class="stat-pills">
          <span class="stat-pill">Pending hosts <strong>${fn:length(pending)}</strong></span>
          <span class="stat-pill">Pending events <strong>${fn:length(pendingEvents)}</strong></span>
          <span class="stat-pill">Approved <strong>${fn:length(verified)}</strong></span>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-success mb-4" style="border-radius:12px;border:1px solid #bbf7d0;">
          <i class="fas fa-check-circle me-1"></i> ${message}
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-4" style="border-radius:12px;">
          <i class="fas fa-exclamation-circle me-1"></i> ${error}
        </div>
      </c:if>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-clock"></i> Pending Event Hosts
          <span class="badge rounded-pill" style="background:var(--primary);">${fn:length(pending)}</span>
        </div>
        <div class="table-responsive responsive-card-table">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Applicant</th>
                <th>Organization</th>
                <th>Type</th>
                <th>Location</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty pending}">
                  <c:forEach var="h" items="${pending}">
                    <c:set var="st" value="${h.partnerProfileStatus != null ? h.partnerProfileStatus : h.verificationStatus}"/>
                    <tr>
                      <td data-label="Applicant">
                        <div class="cell-name">${h.fullName}</div>
                        <div class="cell-muted">${h.email}</div>
                      </td>
                      <td data-label="Organization" class="cell-clip">${empty h.organizerName ? '—' : h.organizerName}</td>
                      <td data-label="Type">${empty h.organizerType ? '—' : h.organizerType}</td>
                      <td data-label="Location">
                        <c:choose>
                          <c:when test="${not empty h.city}">${h.city}<c:if test="${not empty h.state}">, ${h.state}</c:if></c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td data-label="Contact">${empty h.hostContact ? (empty h.phone ? '—' : h.phone) : h.hostContact}</td>
                      <td data-label="Status"><span class="badge-status status-${st}">${st}</span></td>
                      <td data-label="Action">
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">
                          <i class="fas fa-user"></i> Review
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7" class="text-center text-muted py-4">No pending event host applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-calendar-day"></i> Pending Events
          <span class="badge rounded-pill bg-warning text-dark">${fn:length(pendingEvents)}</span>
        </div>
        <div class="table-responsive responsive-card-table">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Event</th>
                <th>Category</th>
                <th>Date</th>
                <th>Venue</th>
                <th>Organizer</th>
                <th>Fee</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty pendingEvents}">
                  <c:forEach var="e" items="${pendingEvents}">
                    <tr>
                      <td data-label="Event" class="cell-name">${e.name}</td>
                      <td data-label="Category">${e.category}</td>
                      <td data-label="Date">${e.eventDate}</td>
                      <td data-label="Venue">${e.venue}, ${e.city}</td>
                      <td data-label="Organizer">${e.organizerName}</td>
                      <td data-label="Fee">₹${e.entryFee}</td>
                      <td data-label="Status"><span class="badge-status status-${e.status}">${e.status}</span></td>
                      <td data-label="Action">
                        <div class="d-flex gap-1 flex-wrap">
                          <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/approve" method="post">
                            <button type="submit" class="btn-approve">Approve</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/reject" method="post">
                            <button type="submit" class="btn-reject">Reject</button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="8" class="text-center text-muted py-4">No pending events.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-check-circle"></i> Verified Event Hosts
        </div>
        <div class="table-responsive responsive-card-table">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Name</th>
                <th>Organization</th>
                <th>Email</th>
                <th>Type</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty verified}">
                  <c:forEach var="h" items="${verified}">
                    <tr>
                      <td data-label="Name" class="cell-name">${h.fullName}</td>
                      <td data-label="Organization">${h.organizerName}</td>
                      <td data-label="Email">${h.email}</td>
                      <td data-label="Type">${h.organizerType}</td>
                      <td data-label="Location">${empty h.city ? '—' : h.city}</td>
                      <td data-label="Status"><span class="badge-status status-VERIFIED">${h.verificationStatus}</span></td>
                      <td data-label="Action">
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">
                          <i class="fas fa-user"></i> Profile
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7" class="text-center text-muted py-4">No verified organizers yet.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-times-circle"></i> Rejected Event Hosts
        </div>
        <div class="table-responsive responsive-card-table">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Name</th>
                <th>Organization</th>
                <th>Email</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty rejected}">
                  <c:forEach var="h" items="${rejected}">
                    <tr>
                      <td data-label="Name" class="cell-name">${h.fullName}</td>
                      <td data-label="Organization">${h.organizerName}</td>
                      <td data-label="Email">${h.email}</td>
                      <td data-label="Status"><span class="badge-status status-REJECTED">${h.verificationStatus}</span></td>
                      <td data-label="Action">
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">
                          <i class="fas fa-user"></i> Profile
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="5" class="text-center text-muted py-4">No rejected applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <p class="legacy-link mb-0">
        Event catalog:
        <a href="${pageContext.request.contextPath}/women-events/admin/list">Women Events admin list</a>
      </p>
    </div>
  </main>
</div>
</body>
</html>
