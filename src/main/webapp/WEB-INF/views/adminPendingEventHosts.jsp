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
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  :root {
    --we-navy: #0F172A;
    --we-accent: #F43F5E;
    --we-bg: #F8FAFC;
    --we-card: #FFFFFF;
    --we-muted: #64748B;
    --we-border: #E2E8F0;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family:'Outfit',sans-serif; margin:0; background:var(--we-bg); color:var(--we-navy); }
  .topbar {
    background: var(--we-navy); color:#fff; padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000;
  }
  .topbar .brand { font-size:1.05rem; font-weight:700; }
  .topbar .btn-logout {
    background:rgba(255,255,255,0.12); color:#fff; border:1px solid rgba(255,255,255,0.25);
    border-radius:8px; padding:6px 14px; font-size:0.85rem; font-weight:600; text-decoration:none;
  }
  .layout { display:flex; min-height:calc(100vh - 58px); }
  .main { flex:1; padding:24px; min-width:0; }
  .pg-header h4 { font-weight:800; color:var(--we-navy); margin:0 0 4px; font-size:1.25rem; }
  .pg-header p { color:var(--we-muted); margin:0 0 20px; font-size:0.9rem; }
  .card-table {
    background:var(--we-card); border-radius:16px; overflow:hidden; margin-bottom:22px;
    box-shadow:0 4px 20px rgba(15,23,42,0.05); border:1px solid var(--we-border);
  }
  .card-table-header {
    padding:14px 18px; font-weight:700; border-bottom:1px solid var(--we-border);
    display:flex; align-items:center; gap:8px; background:#fff;
  }
  .table-scroll { overflow-x: auto; }
  .we-data-table { width: 100%; min-width: 1080px; table-layout: fixed; border-collapse: collapse; margin: 0; }
  .we-data-table th {
    font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.04em;
    color: var(--we-muted); font-weight: 700; padding: 12px 14px; background: #F8FAFC;
    border-bottom: 1px solid var(--we-border); white-space: nowrap;
  }
  .we-data-table td {
    padding: 12px 14px; border-bottom: 1px solid #F1F5F9; vertical-align: middle;
    font-size: 0.88rem; overflow: hidden;
  }
  .we-data-table tr:last-child td { border-bottom: none; }
  .col-applicant { width: 180px; }
  .col-org { width: 150px; }
  .col-type { width: 110px; }
  .col-loc { width: 120px; }
  .col-cats { width: 140px; }
  .col-contact { width: 120px; }
  .col-bio { width: 200px; }
  .col-status { width: 130px; }
  .col-action { width: 110px; }
  .clip, .bio-clip {
    display: block;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #475569;
    font-size: 0.82rem;
  }
  .muted { color: var(--we-muted); }
  .badge-pending { background:#FEF3C7; color:#92400E; }
  .badge-verified { background:#DCFCE7; color:#166534; }
  .badge-rejected { background:#FEE2E2; color:#991B1B; }
  .badge-incomplete { background:#F1F5F9; color:#475569; }
  .btn-approve { background:#DCFCE7; color:#166534; border:1px solid #86EFAC; border-radius:999px; padding:5px 12px; font-size:0.78rem; font-weight:700; }
  .btn-reject { background:#FEE2E2; color:#991B1B; border:1px solid #FECACA; border-radius:999px; padding:5px 12px; font-size:0.78rem; font-weight:700; }
  .btn-profile, .btn-preview {
    background: #FFF1F2; color: #BE123C; border: 1px solid #FECDD3;
    border-radius: 999px; padding: 5px 12px; font-size: 0.78rem; font-weight: 700;
    text-decoration: none; display: inline-flex; align-items: center; gap: 6px; cursor: pointer;
  }
  .btn-profile:hover, .btn-preview:hover { background: #FFE4E6; color: #9F1239; }
  .empty-cell { text-align:center; color:var(--we-muted); padding: 28px 16px !important; }
  .we-modal-overlay {
    display:none; position:fixed; inset:0; background:rgba(15,23,42,.45); z-index:2000;
    align-items:center; justify-content:center; padding:20px;
  }
  .we-modal-overlay.open { display:flex; }
  .we-modal {
    background:#fff; border-radius:18px; width:100%; max-width:640px; max-height:90vh;
    overflow:auto; box-shadow:0 24px 64px rgba(15,23,42,.2);
  }
  .we-modal-header { padding:20px 22px 12px; border-bottom:1px solid var(--we-border); display:flex; justify-content:space-between; gap:12px; }
  .we-modal-header h3 { margin:0; font-size:1.1rem; font-weight:800; }
  .we-modal-body { padding:18px 22px 22px; }
  .pv-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:12px; }
  .pv-item label { display:block; font-size:0.7rem; font-weight:700; text-transform:uppercase; letter-spacing:.04em; color:var(--we-muted); }
  .pv-item span, .pv-item p { font-size:0.9rem; font-weight:600; color:var(--we-navy); margin:0; word-break:break-word; }
  .pv-desc { grid-column: 1 / -1; }
  .pv-desc p { font-weight:500; white-space:pre-wrap; }
  @media (max-width: 900px) {
    .layout { flex-direction: column; }
    .pv-grid { grid-template-columns: 1fr; }
  }
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
        <h4>Event Organizer Verification</h4>
        <p>Review host applications, inspect full profiles, then approve events they create.</p>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-4" style="border-radius:10px;">
          <i class="fas fa-info-circle me-1"></i> ${message}
        </div>
      </c:if>

      <div class="card-table">
        <div class="card-table-header">
          Pending Event Organizers
          <span class="badge rounded-pill" style="background:#FEE2E2;color:#BE123C;">${fn:length(pending)}</span>
        </div>
        <div class="table-scroll">
          <table class="we-data-table">
            <thead>
              <tr>
                <th class="col-applicant">Applicant</th>
                <th class="col-org">Organization</th>
                <th class="col-type">Type</th>
                <th class="col-loc">Location</th>
                <th class="col-cats">Categories</th>
                <th class="col-contact">Contact</th>
                <th class="col-bio">Bio</th>
                <th class="col-status">Status</th>
                <th class="col-action">Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty pending}">
                  <c:forEach var="h" items="${pending}">
                    <tr>
                      <td class="col-applicant">
                        <div class="fw-bold clip" title="<c:out value='${h.fullName}'/>"><c:out value="${h.fullName}"/></div>
                        <div class="clip muted" title="<c:out value='${h.email}'/>"><c:out value="${h.email}"/></div>
                      </td>
                      <td class="col-org"><span class="clip" title="<c:out value='${h.organizerName}'/>"><c:out value="${empty h.organizerName ? '—' : h.organizerName}"/></span></td>
                      <td class="col-type"><span class="clip"><c:out value="${empty h.organizerType ? '—' : h.organizerType}"/></span></td>
                      <td class="col-loc">
                        <span class="clip">
                          <c:choose>
                            <c:when test="${not empty h.city}"><c:out value="${h.city}"/><c:if test="${not empty h.state}">, <c:out value="${h.state}"/></c:if></c:when>
                            <c:otherwise>Not provided</c:otherwise>
                          </c:choose>
                        </span>
                      </td>
                      <td class="col-cats"><span class="clip" title="<c:out value='${h.eventCategories}'/>"><c:out value="${empty h.eventCategories ? 'Not provided' : h.eventCategories}"/></span></td>
                      <td class="col-contact"><span class="clip"><c:out value="${empty h.hostContact ? h.phone : h.hostContact}"/></span></td>
                      <td class="col-bio">
                        <c:choose>
                          <c:when test="${empty h.hostBio}"><span class="muted">Not provided</span></c:when>
                          <c:otherwise>
                            <span class="bio-clip" title="<c:out value='${h.hostBio}'/>"><c:out value="${h.hostBio}"/></span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="col-status">
                        <span class="badge badge-pending"><c:out value="${h.partnerProfileStatus != null ? h.partnerProfileStatus : h.verificationStatus}"/></span>
                      </td>
                      <td class="col-action">
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">
                          Review
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="9" class="empty-cell">No pending event organizer applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          Pending Events
          <span class="badge rounded-pill" style="background:#FEF3C7;color:#92400E;">${fn:length(pendingEvents)}</span>
        </div>
        <div class="table-scroll">
          <table class="we-data-table" style="min-width:980px;">
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
                      <td><span class="clip" title="<c:out value='${e.name}'/>"><c:out value="${e.name}"/></span></td>
                      <td><c:out value="${e.category}"/></td>
                      <td><c:out value="${e.eventDate}"/></td>
                      <td><span class="clip"><c:out value="${e.venue}"/>, <c:out value="${e.city}"/></span></td>
                      <td><span class="clip"><c:out value="${e.organizerName}"/></span></td>
                      <td>
                        <c:choose>
                          <c:when test="${e.free}">Free</c:when>
                          <c:otherwise>₹<c:out value="${e.entryFee}"/></c:otherwise>
                        </c:choose>
                      </td>
                      <td><span class="badge badge-pending"><c:out value="${e.status}"/></span></td>
                      <td>
                        <div class="d-flex gap-1 flex-wrap">
                          <button type="button" class="btn-preview" onclick="openEventPreview('p${e.id}')">Preview</button>
                          <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/approve" method="post">
                            <button type="submit" class="btn-approve">Approve</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/reject" method="post">
                            <button type="submit" class="btn-reject">Reject</button>
                          </form>
                        </div>
                        <div id="ev-p${e.id}" class="d-none">
                          <div class="pv-grid">
                            <div class="pv-item"><label>Title</label><span><c:out value="${e.name}"/></span></div>
                            <div class="pv-item"><label>Category</label><span><c:out value="${e.category}"/></span></div>
                            <div class="pv-item"><label>Date</label><span><c:out value="${empty e.eventDate ? 'Not provided' : e.eventDate}"/></span></div>
                            <div class="pv-item"><label>Time</label><span><c:out value="${empty e.eventTime ? 'Not provided' : e.eventTime}"/></span></div>
                            <div class="pv-item"><label>Venue</label><span><c:out value="${empty e.venue ? 'Not provided' : e.venue}"/></span></div>
                            <div class="pv-item"><label>City</label><span><c:out value="${empty e.city ? 'Not provided' : e.city}"/></span></div>
                            <div class="pv-item"><label>Organizer</label><span><c:out value="${empty e.organizerName ? 'Not provided' : e.organizerName}"/></span></div>
                            <div class="pv-item"><label>Organizer type</label><span><c:out value="${empty e.organizerType ? 'Not provided' : e.organizerType}"/></span></div>
                            <div class="pv-item"><label>Capacity</label><span><c:out value="${e.maxParticipants != null ? e.maxParticipants : 'Not provided'}"/></span></div>
                            <div class="pv-item"><label>Fee</label><span><c:choose><c:when test="${e.free}">Free</c:when><c:otherwise>₹<c:out value="${e.entryFee}"/></c:otherwise></c:choose></span></div>
                            <div class="pv-item"><label>Contact</label><span><c:out value="${empty e.contactInfo ? 'Not provided' : e.contactInfo}"/></span></div>
                            <div class="pv-item"><label>Maps</label><span><c:out value="${empty e.mapsLocation ? 'Not provided' : e.mapsLocation}"/></span></div>
                            <div class="pv-item"><label>Virtual</label><span><c:out value="${e.virtual ? 'Yes' : 'No'}"/></span></div>
                            <div class="pv-item"><label>Status</label><span><c:out value="${e.status}"/></span></div>
                            <div class="pv-item pv-desc"><label>Description</label><p><c:out value="${empty e.description ? 'Not provided' : e.description}"/></p></div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="8" class="empty-cell">No pending events.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">
          Approved Events
          <span class="badge rounded-pill" style="background:#DCFCE7;color:#166534;">${fn:length(approvedEvents)}</span>
        </div>
        <div class="table-scroll">
          <table class="we-data-table" style="min-width:860px;">
            <thead>
              <tr>
                <th>Event</th>
                <th>Date</th>
                <th>City</th>
                <th>Organizer</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty approvedEvents}">
                  <c:forEach var="e" items="${approvedEvents}">
                    <tr>
                      <td><span class="clip" title="<c:out value='${e.name}'/>"><c:out value="${e.name}"/></span></td>
                      <td><c:out value="${e.eventDate}"/></td>
                      <td><c:out value="${e.city}"/></td>
                      <td><span class="clip"><c:out value="${e.organizerName}"/></span></td>
                      <td><span class="badge badge-verified"><c:out value="${e.status}"/></span></td>
                      <td>
                        <button type="button" class="btn-preview" onclick="openEventPreview('a${e.id}')">Preview</button>
                        <div id="ev-a${e.id}" class="d-none">
                          <div class="pv-grid">
                            <div class="pv-item"><label>Title</label><span><c:out value="${e.name}"/></span></div>
                            <div class="pv-item"><label>Category</label><span><c:out value="${e.category}"/></span></div>
                            <div class="pv-item"><label>Date / time</label><span><c:out value="${e.eventDate}"/> <c:out value="${e.eventTime}"/></span></div>
                            <div class="pv-item"><label>Venue</label><span><c:out value="${e.venue}"/>, <c:out value="${e.city}"/></span></div>
                            <div class="pv-item"><label>Organizer</label><span><c:out value="${e.organizerName}"/></span></div>
                            <div class="pv-item"><label>Fee</label><span><c:choose><c:when test="${e.free}">Free</c:when><c:otherwise>₹<c:out value="${e.entryFee}"/></c:otherwise></c:choose></span></div>
                            <div class="pv-item pv-desc"><label>Description</label><p><c:out value="${empty e.description ? 'Not provided' : e.description}"/></p></div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="6" class="empty-cell">No approved events yet.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">Verified Event Organizers</div>
        <div class="table-scroll">
          <table class="we-data-table" style="min-width:820px;">
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
                      <td><span class="clip fw-bold"><c:out value="${h.fullName}"/></span></td>
                      <td><span class="clip"><c:out value="${h.organizerName}"/></span></td>
                      <td><span class="clip"><c:out value="${h.email}"/></span></td>
                      <td><c:out value="${h.organizerType}"/></td>
                      <td><c:out value="${empty h.city ? 'Not provided' : h.city}"/></td>
                      <td><span class="badge badge-verified"><c:out value="${h.verificationStatus}"/></span></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">Profile</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7" class="empty-cell">No verified organizers yet.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card-table">
        <div class="card-table-header">Rejected Event Organizers</div>
        <div class="table-scroll">
          <table class="we-data-table" style="min-width:640px;">
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
                      <td class="fw-bold"><c:out value="${h.fullName}"/></td>
                      <td><span class="clip"><c:out value="${h.organizerName}"/></span></td>
                      <td><span class="clip"><c:out value="${h.email}"/></span></td>
                      <td><span class="badge badge-rejected"><c:out value="${h.verificationStatus}"/></span></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" class="btn-profile">Profile</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="5" class="empty-cell">No rejected applications.</td></tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <p class="text-muted small">
        Event list with feature / delete:
        <a href="${pageContext.request.contextPath}/women-events/admin/list">Women Events admin list</a>
      </p>
    </main>
  </div>

  <div class="we-modal-overlay" id="eventPreviewOverlay" onclick="if(event.target===this)closeEventPreview()">
    <div class="we-modal" role="dialog" aria-modal="true" aria-labelledby="epTitle">
      <div class="we-modal-header">
        <h3 id="epTitle">Event preview</h3>
        <button type="button" class="btn-preview" onclick="closeEventPreview()">Close</button>
      </div>
      <div class="we-modal-body" id="epBody"></div>
    </div>
  </div>
  <script>
    function openEventPreview(key) {
      const src = document.getElementById('ev-' + key);
      if (!src) return;
      document.getElementById('epBody').innerHTML = src.innerHTML;
      document.getElementById('eventPreviewOverlay').classList.add('open');
    }
    function closeEventPreview() {
      document.getElementById('eventPreviewOverlay').classList.remove('open');
    }
  </script>
</body>
</html>
