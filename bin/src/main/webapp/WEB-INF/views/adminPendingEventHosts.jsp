<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Event Organizer Verification — Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --maroon: #1e1b4b;
    --maroon-pale: #f8fafc;
    --maroon-border: rgba(30, 27, 75, 0.12);
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Poppins',sans-serif; margin:0; background:var(--maroon-pale); color:#1a1a2e; }
  .topbar {
    background: var(--maroon); color:#fff; padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
  }
  .topbar .brand { font-size:1.1rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.15); color:#fff; border:1px solid rgba(255,255,255,0.3);
    border-radius:7px; padding:5px 16px; font-size:0.85rem; font-weight:600; text-decoration:none;
  }
  .layout { display:flex; min-height:calc(100vh - 58px); }
  .sidebar {
    width: var(--sidebar-w); background:#fff; border-right:1px solid var(--maroon-border);
    position:sticky; top:58px; height:calc(100vh - 58px); padding:14px 12px; overflow-y:auto; flex-shrink:0;
  }
  .main { flex:1; padding:24px; min-width:0; }
  .pg-header h4 { font-weight:700; color:var(--maroon); margin:0 0 4px; }
  .pg-header p { color:#64748b; margin:0 0 18px; font-size:0.92rem; }
  .card-table {
    background:#fff; border-radius:16px; overflow:hidden; margin-bottom:22px;
    box-shadow:0 6px 20px rgba(125,42,90,0.08); border:1px solid var(--maroon-border);
  }
  .card-table-header {
    padding:14px 18px; font-weight:700; border-bottom:1px solid #f1f5f9;
    display:flex; align-items:center; gap:8px;
  }
  .table { margin:0; }
  .table th { font-size:0.78rem; text-transform:uppercase; color:#94a3b8; font-weight:700; }
  .badge-pending { background:#fef9c3; color:#854d0e; }
  .badge-verified { background:#dcfce7; color:#166534; }
  .badge-rejected { background:#ffe4e6; color:#9f1239; }
  .btn-approve { background:#dcfce7; color:#166534; border:1.5px solid #166534; border-radius:20px; padding:5px 14px; font-size:0.8rem; font-weight:700; }
  .btn-reject { background:#ffe4e6; color:#9f1239; border:1.5px solid #9f1239; border-radius:20px; padding:5px 14px; font-size:0.8rem; font-weight:700; }
  .bio-clip { max-width:240px; white-space:normal; word-break:break-word; font-size:0.82rem; color:#555; }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><i class="fas fa-shield-alt me-2"></i>Fight D Fear Admin</div>
    <a class="btn-logout" href="${pageContext.request.contextPath}/admin/logout">Logout</a>
  </div>

  <div class="layout">
    <%@ include file="globalAdminMenu.jsp" %>

    <main class="main">
      <div class="pg-header">
        <h4><i class="fas fa-calendar-check me-2"></i>Event Organizer Verification</h4>
        <p>Approve Event Hosts registered from mobile / web, then approve their events</p>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-4" style="border-radius:10px;">
          <i class="fas fa-info-circle me-1"></i> ${message}
        </div>
      </c:if>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-clock text-warning"></i> Pending Event Organizers
          <span class="badge rounded-pill bg-danger ms-2">${fn:length(pending)}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Applicant</th>
                <th>Organization</th>
                <th>Type</th>
                <th>Location</th>
                <th>Categories</th>
                <th>Contact</th>
                <th>Bio</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty pending}">
                  <c:forEach var="h" items="${pending}">
                    <tr>
                      <td>
                        <div class="fw-bold">${h.fullName}</div>
                        <div class="text-muted small">${h.email}</div>
                      </td>
                      <td class="fw-semibold">${h.organizerName}</td>
                      <td><span class="badge bg-light text-dark border">${h.organizerType}</span></td>
                      <td>
                        <c:choose>
                          <c:when test="${not empty h.city}">${h.city}<c:if test="${not empty h.state}">, ${h.state}</c:if></c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td class="small">${empty h.eventCategories ? '—' : h.eventCategories}</td>
                      <td>${empty h.hostContact ? h.phone : h.hostContact}</td>
                      <td><div class="bio-clip">${h.hostBio}</div></td>
                      <td><span class="badge badge-pending">${h.verificationStatus}</span></td>
                      <td>
                        <div class="d-flex gap-1 flex-wrap">
                          <form action="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/approve" method="post">
                            <button type="submit" class="btn-approve">Approve</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/reject" method="post">
                            <button type="submit" class="btn-reject">Reject</button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="9" class="text-center text-muted py-4">No pending event organizer applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-calendar-day text-warning"></i> Pending Events (after host creates an event)
          <span class="badge rounded-pill bg-warning text-dark ms-2">${fn:length(pendingEvents)}</span>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Event</th>
                <th>Category</th>
                <th>Date</th>
                <th>Venue / City</th>
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
                      <td class="fw-bold">${e.name}</td>
                      <td><span class="badge bg-light text-dark border">${e.category}</span></td>
                      <td>${e.eventDate}</td>
                      <td>${e.venue}, ${e.city}</td>
                      <td>${e.organizerName}</td>
                      <td>₹${e.entryFee}</td>
                      <td><span class="badge badge-pending">${e.status}</span></td>
                      <td>
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
          <i class="fas fa-check-circle text-success"></i> Verified Event Organizers
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Name</th>
                <th>Organization</th>
                <th>Email</th>
                <th>Type</th>
                <th>Location</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty verified}">
                  <c:forEach var="h" items="${verified}">
                    <tr>
                      <td class="fw-bold">${h.fullName}</td>
                      <td>${h.organizerName}</td>
                      <td>${h.email}</td>
                      <td>${h.organizerType}</td>
                      <td>${empty h.city ? '—' : h.city}</td>
                      <td><span class="badge badge-verified">${h.verificationStatus}</span></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="6" class="text-center text-muted py-4">No verified organizers yet.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          <i class="fas fa-times-circle text-danger"></i> Rejected Event Organizers
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Name</th>
                <th>Organization</th>
                <th>Email</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty rejected}">
                  <c:forEach var="h" items="${rejected}">
                    <tr>
                      <td class="fw-bold">${h.fullName}</td>
                      <td>${h.organizerName}</td>
                      <td>${h.email}</td>
                      <td><span class="badge badge-rejected">${h.verificationStatus}</span></td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="4" class="text-center text-muted py-4">No rejected applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <p class="text-muted small">
        Legacy page also available:
        <a href="${pageContext.request.contextPath}/women-events/admin/list">Women Events admin list</a>
      </p>
    </main>
  </div>
</body>
</html>
