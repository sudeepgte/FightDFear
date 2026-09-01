<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Verification - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .dv-actions { display: flex; gap: 6px; align-items: center; }
    .dv-more {
      width: 34px; height: 34px; border-radius: 9px; border: 1px solid var(--ap-border);
      background: #fff; color: var(--ap-muted); display: inline-flex; align-items: center; justify-content: center;
      text-decoration: none;
    }
    .dv-more:hover { color: var(--ap-accent); border-color: #FDA4AF; }
    .dv-bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px; }
    @media (max-width: 992px) { .dv-bottom-grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body class="ap-page">

<c:set var="activeFilter" value="${empty filter ? 'pending' : filter}"/>
<c:set var="totalDoctors" value="${pendingCount + reverificationCount + changesRequestedCount + approvedCount + rejectedCount}"/>

<c:choose>
  <c:when test="${not empty q}"><c:set var="activeList" value="${searchResults}"/></c:when>
  <c:when test="${activeFilter == 'reverification'}"><c:set var="activeList" value="${reverification}"/></c:when>
  <c:when test="${activeFilter == 'changes_requested'}"><c:set var="activeList" value="${changesRequested}"/></c:when>
  <c:when test="${activeFilter == 'approved'}"><c:set var="activeList" value="${approved}"/></c:when>
  <c:when test="${activeFilter == 'rejected'}"><c:set var="activeList" value="${rejected}"/></c:when>
  <c:when test="${activeFilter == 'all'}">
    <c:set var="activeList" value="${pending}"/>
  </c:when>
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
          <input type="search" id="apHeaderSearch" placeholder="Search anything..." aria-label="Search">
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
        <a href="${pageContext.request.contextPath}/admin/pending-doctors">Doctor Verification</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'reverification'}">Re-verification</c:when>
            <c:when test="${activeFilter == 'changes_requested'}">Changes Requested</c:when>
            <c:when test="${activeFilter == 'approved'}">Approved Doctors</c:when>
            <c:when test="${activeFilter == 'rejected'}">Rejected Doctors</c:when>
            <c:when test="${not empty q}">Search Results</c:when>
            <c:otherwise>Pending Doctors</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-user-check"></i></div>
        <div>
          <h1>Doctor Verification</h1>
          <p>Review and verify doctor profiles before they appear on the platform</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-3" style="border-radius:12px;"><i class="fas fa-info-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>

      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pendingCount}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Requires review</div>
        </div>
        <div class="ap-stat blue">
          <div class="ico"><i class="fas fa-sync"></i></div>
          <div class="val">${reverificationCount}</div>
          <div class="lbl">Re-verification</div>
          <div class="sub">Needs attention</div>
        </div>
        <div class="ap-stat purple">
          <div class="ico"><i class="fas fa-edit"></i></div>
          <div class="val">${changesRequestedCount}</div>
          <div class="lbl">Changes Requested</div>
          <div class="sub">Awaiting response</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${approvedCount}</div>
          <div class="lbl">Approved</div>
          <div class="sub">Verified doctors</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${rejectedCount}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not approved</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-user-md"></i></div>
          <div class="val">${totalDoctors}</div>
          <div class="lbl">Total Doctors</div>
          <div class="sub">Across queues</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/pending-doctors" class="ap-filter-row" id="doctorFilterForm">
        <div class="grow">
          <input type="text" id="doctorSearchInput" name="q" class="ap-input"
                 placeholder="Search by name, email, phone, specialization or location..."
                 value="${not empty q ? q : ''}">
        </div>
        <div style="min-width:180px;">
          <select id="specClientFilter" class="ap-select" aria-label="Specialization filter">
            <option value="">All Specializations</option>
          </select>
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="reverification" ${activeFilter == 'reverification' ? 'selected' : ''}>Re-verification</option>
            <option value="changes_requested" ${activeFilter == 'changes_requested' ? 'selected' : ''}>Changes Requested</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
            <option value="all" ${activeFilter == 'all' ? 'selected' : ''}>All (search scope)</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty q}">
          <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <div class="ap-split">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' && empty q ? 'active' : ''}" href="?filter=pending">Pending (${pendingCount})</a>
            <a class="ap-tab ${activeFilter == 'reverification' && empty q ? 'active' : ''}" href="?filter=reverification">Re-verification (${reverificationCount})</a>
            <a class="ap-tab ${activeFilter == 'changes_requested' && empty q ? 'active' : ''}" href="?filter=changes_requested">Changes Requested (${changesRequestedCount})</a>
            <a class="ap-tab ${activeFilter == 'approved' && empty q ? 'active' : ''}" href="?filter=approved">Approved (${approvedCount})</a>
            <a class="ap-tab ${activeFilter == 'rejected' && empty q ? 'active' : ''}" href="?filter=rejected">Rejected (${rejectedCount})</a>
          </div>

          <c:if test="${not empty q}">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${q}"/></strong>"
              <c:choose>
                <c:when test="${not empty searchResults}"> - ${fn:length(searchResults)} doctor(s)</c:when>
                <c:otherwise> - No doctors found</c:otherwise>
              </c:choose>
            </div>
          </c:if>

          <div class="ap-table-wrap">
            <table class="ap-table" id="doctorQueueTable">
              <thead>
                <tr>
                  <th>Doctor</th>
                  <th>Specialization</th>
                  <th>Location</th>
                  <th>Submitted On</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeList}">
                  <c:forEach var="d" items="${activeList}" varStatus="st">
                    <c:set var="stKey" value="${d.doctorProfileStatus}"/>
                    <c:set var="photo" value="${d.profilePhotoPath}"/>
                    <c:set var="gov" value="${not empty d.idProofPath ? d.idProofPath : d.identityDocumentPath}"/>
                    <c:set var="deg" value="${d.degreeCertificatePath}"/>
                    <c:set var="lic" value="${d.medicalLicensePath}"/>
                    <c:set var="pct" value="${d.profileCompletionPct != null ? d.profileCompletionPct : 0}"/>
                    <c:set var="locText" value="${not empty d.city ? d.city : (not empty d.locationText ? d.locationText : '')}"/>
                    <c:if test="${not empty d.city && not empty d.state}"><c:set var="locText" value="${d.city}, ${d.state}"/></c:if>
                    <c:if test="${empty d.city && not empty d.state}"><c:set var="locText" value="${d.state}"/></c:if>
                    <tr class="doctor-row ${st.first ? 'selected' : ''}"
                        data-id="${d.id}"
                        data-name="<c:out value='${d.fullName}'/>"
                        data-email="<c:out value='${d.email}'/>"
                        data-phone="<c:out value='${d.phone}'/>"
                        data-spec="<c:out value='${d.specialization}'/>"
                        data-exp="${d.experienceYears}"
                        data-loc="<c:out value='${locText}'/>"
                        data-status="<c:out value='${stKey}'/>"
                        data-pct="${pct}"
                        data-photo="<c:out value='${photo}'/>"
                        data-gov="${not empty gov ? '1' : '0'}"
                        data-deg="${not empty deg ? '1' : '0'}"
                        data-lic="${not empty lic ? '1' : '0'}"
                        data-photo-ok="${not empty photo && photo != 'mobile-pending' && !fn:startsWith(photo, 'mobile:') ? '1' : '0'}">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="${not empty photo && photo != 'mobile-pending' && !fn:startsWith(photo, 'mobile:')}">
                                <img src="${fn:startsWith(photo,'http') ? photo : pageContext.request.contextPath.concat(photo)}" alt="">
                              </c:when>
                              <c:otherwise>${fn:substring(d.fullName,0,1)}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${d.fullName}'/>"><c:out value="${d.fullName}"/></div>
                            <div class="meta" title="<c:out value='${d.email}'/>"><c:out value="${d.email}"/></div>
                            <div class="meta"><c:out value="${not empty d.phone ? d.phone : '-'}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${d.specialization}'/>"><c:out value="${not empty d.specialization ? d.specialization : '-'}"/></span>
                        <div class="ap-muted" style="font-size:0.78rem;">
                          <c:choose>
                            <c:when test="${d.experienceYears != null}">${d.experienceYears} yrs exp.</c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
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
                          <c:when test="${d.submittedForVerificationAt != null}">
                            <div style="font-size:0.84rem;">${d.submittedForVerificationAt}</div>
                          </c:when>
                          <c:otherwise><span class="ap-muted">-</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${stKey == 'APPROVED'}"><span class="ap-badge ap-badge-approved">APPROVED</span></c:when>
                          <c:when test="${stKey == 'REJECTED'}"><span class="ap-badge ap-badge-rejected">REJECTED</span></c:when>
                          <c:when test="${stKey == 'CHANGES_REQUESTED'}"><span class="ap-badge ap-badge-changes">CHANGES_REQUESTED</span></c:when>
                          <c:when test="${stKey == 'PROFILE_INCOMPLETE'}"><span class="ap-badge ap-badge-incomplete">PROFILE_INCOMPLETE</span></c:when>
                          <c:when test="${d.hasPendingReverification}"><span class="ap-badge ap-badge-reverify">RE-VERIFY</span></c:when>
                          <c:otherwise><span class="ap-badge ap-badge-pending"><c:out value="${stKey}"/></span></c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile" title="Review"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6"><div class="ap-empty"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No doctors in this queue.</div></td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <aside class="ap-panel ap-preview" id="doctorPreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;">Select a doctor to preview</div>
            <div id="previewBody">
              <div class="hero">
                <span class="av" id="pvAv">D</span>
                <div style="min-width:0;">
                  <h3 id="pvName">-</h3>
                  <div style="margin:6px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line" id="pvEmail">-</div>
                  <div class="line" id="pvPhone">-</div>
                  <div class="line" id="pvSpec">-</div>
                </div>
              </div>

              <div class="ap-progress-label">
                <span>Profile Completion</span>
                <span id="pvPctLabel">0%</span>
              </div>
              <div class="ap-progress"><span id="pvPctBar" style="width:0%"></span></div>

              <div style="font-size:0.78rem;font-weight:700;margin-bottom:8px;color:var(--ap-muted);">DOCUMENTS</div>
              <div class="ap-doc-list">
                <div class="ap-doc-item"><span>Profile Photo</span><span id="pvDocPhoto" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Government ID</span><span id="pvDocGov" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Medical Registration</span><span id="pvDocDeg" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Medical License</span><span id="pvDocLic" class="st-miss">Not uploaded</span></div>
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

      <div class="dv-bottom-grid">
        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Changes Requested (${changesRequestedCount})</h2>
            <a href="?filter=changes_requested" style="color:var(--ap-accent);font-size:0.82rem;font-weight:700;text-decoration:none;">View all</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Doctor</th><th>Reason</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty changesRequested}">
                    <c:forEach var="d" items="${changesRequested}" end="4">
                      <tr>
                        <td>
                          <div class="nm" style="font-weight:700;"><c:out value="${d.fullName}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${d.email}"/></div>
                        </td>
                        <td><span class="ap-clip" style="max-width:220px;" title="<c:out value='${d.changesRequestedNote}'/>"><c:out value="${not empty d.changesRequestedNote ? d.changesRequestedNote : '-'}"/></span></td>
                        <td><a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile">Review</a></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="3"><div class="ap-empty">No changes requested.</div></td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Pending Re-verification (${reverificationCount})</h2>
            <a href="?filter=reverification" style="color:var(--ap-accent);font-size:0.82rem;font-weight:700;text-decoration:none;">View all</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Doctor</th><th>Status</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty reverification}">
                    <c:forEach var="d" items="${reverification}" end="4">
                      <tr>
                        <td>
                          <div style="font-weight:700;"><c:out value="${d.fullName}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${d.specialization}"/></div>
                        </td>
                        <td><span class="ap-badge ap-badge-reverify">RE-VERIFY</span></td>
                        <td><a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/doctors/${d.id}/profile">Review</a></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="3"><div class="ap-empty">No re-verification requests.</div></td></tr>
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
  var rows = Array.prototype.slice.call(document.querySelectorAll('.doctor-row'));
  var specSelect = document.getElementById('specClientFilter');
  var specs = {};
  rows.forEach(function (r) {
    var s = (r.getAttribute('data-spec') || '').trim();
    if (s) specs[s] = true;
  });
  Object.keys(specs).sort().forEach(function (s) {
    var opt = document.createElement('option');
    opt.value = s;
    opt.textContent = s;
    specSelect.appendChild(opt);
  });

  function setDoc(el, ok) {
    el.textContent = ok ? 'Uploaded' : 'Not uploaded';
    el.className = ok ? 'st-ok' : 'st-miss';
  }

  function badgeClass(status) {
    if (status === 'APPROVED') return 'ap-badge ap-badge-approved';
    if (status === 'REJECTED') return 'ap-badge ap-badge-rejected';
    if (status === 'CHANGES_REQUESTED') return 'ap-badge ap-badge-changes';
    if (status === 'PROFILE_INCOMPLETE') return 'ap-badge ap-badge-incomplete';
    if (status === 'RE-VERIFY') return 'ap-badge ap-badge-reverify';
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
    var spec = row.getAttribute('data-spec') || '-';
    var exp = row.getAttribute('data-exp');
    var status = row.getAttribute('data-status') || 'PENDING';
    var pct = parseInt(row.getAttribute('data-pct') || '0', 10) || 0;
    var photo = row.getAttribute('data-photo') || '';
    var id = row.getAttribute('data-id');
    var photoOk = row.getAttribute('data-photo-ok') === '1';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone || '-';
    document.getElementById('pvSpec').textContent = spec + (exp ? (' • ' + exp + ' yrs exp.') : '');
    var st = document.getElementById('pvStatus');
    st.textContent = status;
    st.className = badgeClass(status);
    document.getElementById('pvPctLabel').textContent = pct + '%';
    document.getElementById('pvPctBar').style.width = Math.max(0, Math.min(100, pct)) + '%';

    var av = document.getElementById('pvAv');
    if (photoOk && photo) {
      var src = photo.indexOf('http') === 0 ? photo : (ctx + photo);
      av.innerHTML = '<img src="' + src + '" alt="">';
    } else {
      av.textContent = (name || 'D').charAt(0).toUpperCase();
    }

    setDoc(document.getElementById('pvDocPhoto'), photoOk);
    setDoc(document.getElementById('pvDocGov'), row.getAttribute('data-gov') === '1');
    setDoc(document.getElementById('pvDocDeg'), row.getAttribute('data-deg') === '1');
    setDoc(document.getElementById('pvDocLic'), row.getAttribute('data-lic') === '1');

    var href = ctx + '/admin/doctors/' + id + '/profile';
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

  specSelect.addEventListener('change', function () {
    var val = (specSelect.value || '').toLowerCase();
    rows.forEach(function (r) {
      var s = (r.getAttribute('data-spec') || '').toLowerCase();
      r.style.display = (!val || s === val) ? '' : 'none';
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
        if (q) window.location.href = ctx + '/admin/pending-doctors?q=' + encodeURIComponent(q);
      }
    });
  }
})();
</script>
</body>
</html>
