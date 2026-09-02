<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Event Host Verification - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .eh-actions { display: flex; gap: 6px; align-items: center; flex-wrap: wrap; }
    .eh-more {
      width: 34px; height: 34px; border-radius: 9px; border: 1px solid var(--ap-border);
      background: #fff; color: var(--ap-muted); display: inline-flex; align-items: center; justify-content: center;
      text-decoration: none;
    }
    .eh-more:hover { color: var(--ap-accent); border-color: #FDA4AF; }
    .eh-bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px; }
    .ap-stat.ready .ico { background: var(--ap-accent-soft); color: var(--ap-accent); }
    .ap-stat.slate .ico { background: #F1F5F9; color: #334155; }
    .ap-table tbody tr.host-row.selected { background: #FFF1F2; }
    .ap-alert-ok {
      background: #F0FDF4; color: #15803D; border: 1px solid #BBF7D0;
      border-radius: 12px; padding: 12px 14px; margin-bottom: 16px; font-size: 0.88rem;
    }
    .ap-alert-err {
      background: #FEF2F2; color: #B91C1C; border: 1px solid #FECACA;
      border-radius: 12px; padding: 12px 14px; margin-bottom: 16px; font-size: 0.88rem;
    }
    .eh-inline-forms { display: flex; gap: 6px; flex-wrap: wrap; align-items: center; }
    .eh-inline-forms form { margin: 0; }
    @media (max-width: 992px) { .eh-bottom-grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body class="ap-page">

<c:set var="activeFilter" value="${empty filter ? 'pending' : filter}"/>
<c:set var="totalHosts" value="${pendingCount + changesRequestedCount + approvedCount + rejectedCount}"/>
<c:set var="pendingEventsCount" value="${fn:length(pendingEvents)}"/>

<c:choose>
  <c:when test="${not empty q}"><c:set var="activeList" value="${searchResults}"/></c:when>
  <c:when test="${activeFilter == 'ready'}"><c:set var="activeList" value="${ready}"/></c:when>
  <c:when test="${activeFilter == 'changes_requested'}"><c:set var="activeList" value="${changesRequested}"/></c:when>
  <c:when test="${activeFilter == 'approved'}"><c:set var="activeList" value="${approved}"/></c:when>
  <c:when test="${activeFilter == 'rejected'}"><c:set var="activeList" value="${rejected}"/></c:when>
  <c:otherwise><c:set var="activeList" value="${pending}"/></c:otherwise>
</c:choose>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:360px;">
          <i class="fas fa-search"></i>
          <input type="search" id="apHeaderSearch" placeholder="Search organizers..." aria-label="Search">
          <span class="ap-kbd">Ctrl + K</span>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
          <i class="fas fa-bell"></i>
          <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
        </a>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty admin.profilePhoto}">
                <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
              </c:when>
              <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span>
            <div class="name"><c:out value="${admin.name}"/></div>
            <div class="role">Super Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="ap-main-inner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-event-hosts">Event Host Verification</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'ready'}">Ready to Submit</c:when>
            <c:when test="${activeFilter == 'changes_requested'}">Changes Requested</c:when>
            <c:when test="${activeFilter == 'approved'}">Approved Hosts</c:when>
            <c:when test="${activeFilter == 'rejected'}">Rejected Hosts</c:when>
            <c:when test="${not empty q}">Search Results</c:when>
            <c:otherwise>Pending Hosts</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-calendar-check"></i></div>
        <div>
          <h1>Event Host Verification</h1>
          <p>Review organizer profiles before they can publish events on the platform</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="ap-alert-ok"><i class="fas fa-check-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="ap-alert-err"><i class="fas fa-exclamation-circle me-1"></i><c:out value="${error}"/></div>
      </c:if>

      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pendingCount}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Requires review</div>
        </div>
        <div class="ap-stat ready">
          <div class="ico"><i class="fas fa-file-circle-check"></i></div>
          <div class="val">${readyCount}</div>
          <div class="lbl">Ready</div>
          <div class="sub">Submitted for approval</div>
        </div>
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-edit"></i></div>
          <div class="val">${changesRequestedCount}</div>
          <div class="lbl">Changes Requested</div>
          <div class="sub">Awaiting response</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${approvedCount}</div>
          <div class="lbl">Approved</div>
          <div class="sub">Can publish events</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${rejectedCount}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not approved</div>
        </div>
        <div class="ap-stat slate">
          <div class="ico"><i class="fas fa-calendar-day"></i></div>
          <div class="val">${pendingEventsCount}</div>
          <div class="lbl">Pending Events</div>
          <div class="sub">Need listing review</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/pending-event-hosts" class="ap-filter-row" id="hostFilterForm">
        <div class="grow">
          <input type="text" id="hostSearchInput" name="q" class="ap-input"
                 placeholder="Search by name, email, phone, organization or city..."
                 value="${not empty q ? q : ''}">
        </div>
        <div style="min-width:180px;">
          <select id="typeClientFilter" class="ap-select" aria-label="Organizer type filter">
            <option value="">All organizer types</option>
          </select>
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="ready" ${activeFilter == 'ready' ? 'selected' : ''}>Ready to submit</option>
            <option value="changes_requested" ${activeFilter == 'changes_requested' ? 'selected' : ''}>Changes requested</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
            <option value="all" ${activeFilter == 'all' ? 'selected' : ''}>All (search scope)</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty q}">
          <a href="${pageContext.request.contextPath}/admin/pending-event-hosts" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <div class="ap-split">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' && empty q ? 'active' : ''}" href="?filter=pending">Pending (${pendingCount})</a>
            <a class="ap-tab ${activeFilter == 'ready' && empty q ? 'active' : ''}" href="?filter=ready">Ready (${readyCount})</a>
            <a class="ap-tab ${activeFilter == 'changes_requested' && empty q ? 'active' : ''}" href="?filter=changes_requested">Changes (${changesRequestedCount})</a>
            <a class="ap-tab ${activeFilter == 'approved' && empty q ? 'active' : ''}" href="?filter=approved">Approved (${approvedCount})</a>
            <a class="ap-tab ${activeFilter == 'rejected' && empty q ? 'active' : ''}" href="?filter=rejected">Rejected (${rejectedCount})</a>
          </div>

          <c:if test="${not empty q}">
            <div style="padding:12px 16px;background:#FFF1F2;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${q}"/></strong>"
              <c:choose>
                <c:when test="${not empty searchResults}"> — ${fn:length(searchResults)} organizer(s)</c:when>
                <c:otherwise> — No organizers found</c:otherwise>
              </c:choose>
            </div>
          </c:if>

          <div class="ap-table-wrap">
            <table class="ap-table" id="hostQueueTable">
              <thead>
                <tr>
                  <th>Organizer</th>
                  <th>Organization</th>
                  <th>Location</th>
                  <th>Submitted On</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeList}">
                  <c:forEach var="h" items="${activeList}" varStatus="st">
                    <c:set var="stKey" value="${h.partnerProfileStatus != null ? h.partnerProfileStatus : h.verificationStatus}"/>
                    <c:set var="logo" value="${h.logoPath}"/>
                    <c:set var="pct" value="${h.profileCompletionPct != null ? h.profileCompletionPct : 0}"/>
                    <c:set var="locText" value=""/>
                    <c:if test="${not empty h.city}"><c:set var="locText" value="${h.city}"/></c:if>
                    <c:if test="${not empty h.city && not empty h.state}"><c:set var="locText" value="${h.city}, ${h.state}"/></c:if>
                    <c:if test="${empty h.city && not empty h.state}"><c:set var="locText" value="${h.state}"/></c:if>
                    <tr class="host-row ${st.first ? 'selected' : ''}"
                        data-id="${h.id}"
                        data-name="<c:out value='${h.fullName}'/>"
                        data-email="<c:out value='${h.email}'/>"
                        data-phone="<c:out value='${empty h.hostContact ? h.phone : h.hostContact}'/>"
                        data-org="<c:out value='${h.organizerName}'/>"
                        data-type="<c:out value='${h.organizerType}'/>"
                        data-loc="<c:out value='${locText}'/>"
                        data-status="<c:out value='${stKey}'/>"
                        data-pct="${pct}"
                        data-logo="<c:out value='${logo}'/>"
                        data-logo-ok="${not empty logo ? '1' : '0'}"
                        data-doc="${not empty h.documentPath ? '1' : '0'}"
                        data-port="${not empty h.portfolioPath ? '1' : '0'}"
                        data-gallery="${not empty h.galleryPhotos ? '1' : '0'}">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="${not empty logo}">
                                <img src="${fn:startsWith(logo,'http') ? logo : pageContext.request.contextPath.concat(logo)}" alt="">
                              </c:when>
                              <c:otherwise>${fn:substring(h.fullName,0,1)}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${h.fullName}'/>"><c:out value="${h.fullName}"/></div>
                            <div class="meta" title="<c:out value='${h.email}'/>"><c:out value="${h.email}"/></div>
                            <div class="meta"><c:out value="${not empty h.phone ? h.phone : '-'}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${h.organizerName}'/>"><c:out value="${not empty h.organizerName ? h.organizerName : '-'}"/></span>
                        <div class="ap-muted" style="font-size:0.78rem;">
                          <c:out value="${not empty h.organizerType ? h.organizerType : '-'}"/>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${locText}'/>">
                          <c:choose>
                            <c:when test="${not empty locText}"><c:out value="${locText}"/></c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </span>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${h.submittedForVerificationAt != null}">
                            <div style="font-size:0.84rem;">${h.submittedForVerificationAt}</div>
                          </c:when>
                          <c:when test="${h.createdAt != null}">
                            <div style="font-size:0.84rem;">${h.createdAt}</div>
                          </c:when>
                          <c:otherwise><span class="ap-muted">-</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${stKey == 'APPROVED' || stKey == 'VERIFIED'}"><span class="ap-badge ap-badge-approved">APPROVED</span></c:when>
                          <c:when test="${stKey == 'REJECTED' || stKey == 'SUSPENDED'}"><span class="ap-badge ap-badge-rejected"><c:out value="${stKey}"/></span></c:when>
                          <c:when test="${stKey == 'CHANGES_REQUESTED'}"><span class="ap-badge ap-badge-changes">CHANGES_REQUESTED</span></c:when>
                          <c:when test="${stKey == 'PROFILE_INCOMPLETE' || stKey == 'REGISTERED'}"><span class="ap-badge ap-badge-incomplete"><c:out value="${stKey}"/></span></c:when>
                          <c:when test="${stKey == 'READY_FOR_VERIFICATION'}"><span class="ap-badge ap-badge-pending">READY</span></c:when>
                          <c:otherwise><span class="ap-badge ap-badge-pending"><c:out value="${stKey}"/></span></c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="eh-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="eh-more" href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile" title="Review"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6"><div class="ap-empty" style="background:#FFF1F2;border-radius:12px;margin:12px;"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No event hosts in this queue.</div></td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <aside class="ap-panel ap-preview" id="hostPreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;background:#FFF1F2;border-radius:12px;">Select an organizer to preview</div>
            <div id="previewBody">
              <div class="hero">
                <span class="av" id="pvAv">H</span>
                <div style="min-width:0;">
                  <h3 id="pvName">-</h3>
                  <div style="margin:6px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line" id="pvEmail">-</div>
                  <div class="line" id="pvPhone">-</div>
                  <div class="line" id="pvOrg">-</div>
                </div>
              </div>

              <div class="ap-progress-label">
                <span>Profile Completion</span>
                <span id="pvPctLabel">0%</span>
              </div>
              <div class="ap-progress"><span id="pvPctBar" style="width:0%"></span></div>

              <div style="font-size:0.78rem;font-weight:700;margin-bottom:8px;color:var(--ap-muted);">DOCUMENTS</div>
              <div class="ap-doc-list">
                <div class="ap-doc-item"><span>Organization logo</span><span id="pvDocLogo" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Identity document</span><span id="pvDocId" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Portfolio</span><span id="pvDocPort" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Gallery photos</span><span id="pvDocGal" class="st-miss">Not uploaded</span></div>
              </div>

              <a id="pvReview" class="ap-btn ap-btn-primary" style="width:100%;justify-content:center;" href="#">
                Review Application <i class="fas fa-arrow-right"></i>
              </a>
              <a id="pvViewAll" class="ap-btn ap-btn-ghost" style="width:100%;justify-content:center;margin-top:8px;" href="#">
                View full profile
              </a>
            </div>
          </div>
        </aside>
      </div>

      <div class="eh-bottom-grid">
        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Changes Requested (${changesRequestedCount})</h2>
            <a href="?filter=changes_requested" style="color:var(--ap-accent);font-size:0.82rem;font-weight:700;text-decoration:none;">View all</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Organizer</th><th>Reason</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty changesRequested}">
                    <c:forEach var="h" items="${changesRequested}" end="4">
                      <tr>
                        <td>
                          <div style="font-weight:700;"><c:out value="${h.fullName}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${h.email}"/></div>
                        </td>
                        <td><span class="ap-clip" style="max-width:220px;" title="<c:out value='${h.changesRequestedNote}'/>"><c:out value="${not empty h.changesRequestedNote ? h.changesRequestedNote : '-'}"/></span></td>
                        <td><a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/event-hosts/${h.id}/profile">Review</a></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="3"><div class="ap-empty" style="background:#FFF1F2;">No changes requested.</div></td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Pending Events (${pendingEventsCount})</h2>
            <a href="${pageContext.request.contextPath}/women-events/admin/list" style="color:var(--ap-accent);font-size:0.82rem;font-weight:700;text-decoration:none;">Event catalog</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Event</th><th>Status</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty pendingEvents}">
                    <c:forEach var="e" items="${pendingEvents}" end="4">
                      <tr>
                        <td>
                          <div style="font-weight:700;"><c:out value="${e.name}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${e.city}"/> · <c:out value="${e.eventDate}"/></div>
                        </td>
                        <td><span class="ap-badge ap-badge-pending"><c:out value="${e.status}"/></span></td>
                        <td onclick="event.stopPropagation();">
                          <div class="eh-inline-forms">
                            <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/approve" method="post">
                              <button type="submit" class="ap-btn ap-btn-approve" style="padding:7px 12px;font-size:0.78rem;">Approve</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/women-events/${e.id}/reject" method="post">
                              <button type="submit" class="ap-btn ap-btn-reject" style="padding:7px 12px;font-size:0.78rem;">Reject</button>
                            </form>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="3"><div class="ap-empty" style="background:#FFF1F2;">No pending events.</div></td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  </main>
</div>

<script>
(function () {
  var ctx = '${pageContext.request.contextPath}';
  var rows = Array.prototype.slice.call(document.querySelectorAll('.host-row'));
  var typeSelect = document.getElementById('typeClientFilter');
  var types = {};
  rows.forEach(function (r) {
    var t = (r.getAttribute('data-type') || '').trim();
    if (t) types[t] = true;
  });
  Object.keys(types).sort().forEach(function (t) {
    var opt = document.createElement('option');
    opt.value = t;
    opt.textContent = t;
    typeSelect.appendChild(opt);
  });

  function setDoc(el, ok) {
    el.textContent = ok ? 'Uploaded' : 'Not uploaded';
    el.className = ok ? 'st-ok' : 'st-miss';
  }

  function badgeClass(status) {
    if (status === 'APPROVED' || status === 'VERIFIED') return 'ap-badge ap-badge-approved';
    if (status === 'REJECTED' || status === 'SUSPENDED') return 'ap-badge ap-badge-rejected';
    if (status === 'CHANGES_REQUESTED') return 'ap-badge ap-badge-changes';
    if (status === 'PROFILE_INCOMPLETE' || status === 'REGISTERED') return 'ap-badge ap-badge-incomplete';
    return 'ap-badge ap-badge-pending';
  }

  function fillPreview(row) {
    if (!row) {
      document.getElementById('previewBody').style.display = 'none';
      document.getElementById('previewEmpty').style.display = 'block';
      return;
    }
    document.getElementById('previewBody').style.display = 'block';
    document.getElementById('previewEmpty').style.display = 'none';

    var name = row.getAttribute('data-name') || '-';
    var email = row.getAttribute('data-email') || '-';
    var phone = row.getAttribute('data-phone') || '-';
    var org = row.getAttribute('data-org') || '-';
    var type = row.getAttribute('data-type') || '';
    var status = row.getAttribute('data-status') || 'PENDING';
    var pct = parseInt(row.getAttribute('data-pct') || '0', 10) || 0;
    var logo = row.getAttribute('data-logo') || '';
    var id = row.getAttribute('data-id');
    var logoOk = row.getAttribute('data-logo-ok') === '1';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone || '-';
    document.getElementById('pvOrg').textContent = (org || '-') + (type ? (' · ' + type) : '');
    var st = document.getElementById('pvStatus');
    st.textContent = status;
    st.className = badgeClass(status);
    document.getElementById('pvPctLabel').textContent = pct + '%';
    document.getElementById('pvPctBar').style.width = Math.max(0, Math.min(100, pct)) + '%';

    var av = document.getElementById('pvAv');
    if (logoOk && logo) {
      var src = logo.indexOf('http') === 0 ? logo : (ctx + logo);
      av.innerHTML = '<img src="' + src + '" alt="">';
    } else {
      av.textContent = (name || 'H').charAt(0).toUpperCase();
    }

    setDoc(document.getElementById('pvDocLogo'), logoOk);
    setDoc(document.getElementById('pvDocId'), row.getAttribute('data-doc') === '1');
    setDoc(document.getElementById('pvDocPort'), row.getAttribute('data-port') === '1');
    setDoc(document.getElementById('pvDocGal'), row.getAttribute('data-gallery') === '1');

    var href = ctx + '/admin/event-hosts/' + id + '/profile';
    document.getElementById('pvReview').href = href;
    document.getElementById('pvViewAll').href = href;
  }

  rows.forEach(function (row) {
    row.addEventListener('click', function () {
      rows.forEach(function (r) { r.classList.remove('selected'); });
      row.classList.add('selected');
      fillPreview(row);
    });
  });

  if (rows.length) fillPreview(rows[0]);
  else fillPreview(null);

  typeSelect.addEventListener('change', function () {
    var val = (typeSelect.value || '').toLowerCase();
    rows.forEach(function (r) {
      var t = (r.getAttribute('data-type') || '').toLowerCase();
      r.style.display = (!val || t === val) ? '' : 'none';
    });
  });

  var hs = document.getElementById('apHeaderSearch');
  if (hs) {
    document.addEventListener('keydown', function (e) {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        hs.focus();
      }
    });
    hs.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') {
        e.preventDefault();
        var q = hs.value.trim();
        if (q) window.location.href = ctx + '/admin/pending-event-hosts?q=' + encodeURIComponent(q);
      }
    });
  }
})();
</script>
</body>
</html>
