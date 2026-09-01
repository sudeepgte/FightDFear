<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Beauty and Wellness Verification - Fight D Fear Admin</title>
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

<c:set var="activeFilter" value="${empty param.filter ? 'pending' : param.filter}"/>

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
        <a href="${pageContext.request.contextPath}/admin/salons">Beauty and Wellness</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'approved'}">Verified Profiles</c:when>
            <c:otherwise>Pending Profiles</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico" style="background:#FCE7F3; color:#DB2777;"><i class="fas fa-spa"></i></div>
        <div>
          <h1>Beauty and Wellness</h1>
          <p>Review and verify salons and stylists before they appear on the platform</p>
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
          <div class="sub">Verified profiles</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${rejectedCount}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not approved</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-users"></i></div>
          <div class="val">${totalCount}</div>
          <div class="lbl">Total Profiles</div>
          <div class="sub">Salons & Stylists</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/salons" class="ap-filter-row" id="bwFilterForm">
        <div class="grow">
          <input type="text" id="bwSearchInput" name="q" class="ap-input"
                 placeholder="Search by name, email, phone, specialization or location..."
                 value="${not empty param.q ? param.q : ''}">
        </div>
        <div style="min-width:180px;">
          <select id="typeFilter" class="ap-select" aria-label="Type filter">
            <option value="">All Types</option>
            <option value="salon">Salon</option>
            <option value="stylist">Stylist</option>
          </select>
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="reverification" ${activeFilter == 'reverification' ? 'selected' : ''}>Re-verification</option>
            <option value="changes_requested" ${activeFilter == 'changes_requested' ? 'selected' : ''}>Changes Requested</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty param.q}">
          <a href="${pageContext.request.contextPath}/admin/salons" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <div class="ap-split">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' ? 'active' : ''}" href="?filter=pending">Pending (${pendingCount})</a>
            <a class="ap-tab ${activeFilter == 'reverification' ? 'active' : ''}" href="?filter=reverification">Re-verification (${reverificationCount})</a>
            <a class="ap-tab ${activeFilter == 'changes_requested' ? 'active' : ''}" href="?filter=changes_requested">Changes Requested (${changesRequestedCount})</a>
            <a class="ap-tab ${activeFilter == 'approved' ? 'active' : ''}" href="?filter=approved">Approved (${approvedCount})</a>
            <a class="ap-tab ${activeFilter == 'rejected' ? 'active' : ''}" href="?filter=rejected">Rejected (${rejectedCount})</a>
          </div>

          <div class="ap-table-wrap">
            <table class="ap-table" id="bwQueueTable">
              <thead>
                <tr>
                  <th>Profile</th>
                  <th>Type</th>
                  <th>Location/Specialty</th>
                  <th>Submitted On</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                  <c:forEach var="s" items="${activeSalons}">
                    <c:set var="salonStatus" value="${not empty s.partnerProfileStatus ? s.partnerProfileStatus : (s.approved ? 'APPROVED' : 'PENDING_ADMIN_APPROVAL')}" />
                    <tr class="bw-row" 
                        data-id="${s.id}" 
                        data-type="salon" 
                        data-name="<c:out value='${s.name}'/>" 
                        data-email="<c:out value='${s.email}'/>"
                        data-phone="<c:out value='${s.phone}'/>"
                        data-spec="Salon"
                        data-loc="<c:out value='${s.city}, ${s.state}'/>"
                        data-status="${salonStatus}"
                        data-photo="<c:out value='${s.profileImageUrl}'/>"
                        data-doc-reg="${not empty s.businessRegistrationUrl ? 'yes' : 'no'}"
                        data-doc-lic="${not empty s.salonLicenseUrl ? 'yes' : 'no'}"
                        data-doc-cert="${not empty s.hygieneCertificateUrl ? 'yes' : 'no'}">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                               <c:when test="${not empty s.profileImageUrl}"><img src="${s.profileImageUrl}" alt=""></c:when>
                               <c:otherwise>${fn:substring(s.name,0,1).toUpperCase()}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm"><c:out value="${s.name}"/></div>
                            <div class="meta"><c:out value="${s.email}"/></div>
                            <div class="meta"><c:out value="${s.phone}"/></div>
                          </span>
                        </div>
                      </td>
                      <td><span class="ap-badge ap-badge-changes">Salon</span></td>
                      <td>
                        <span class="ap-clip"><c:out value="${s.city}"/>, <c:out value="${s.state}"/></span>
                      </td>
                      <td><span class="ap-muted">-</span></td>
                      <td><span class="ap-badge ${salonStatus == 'APPROVED' ? 'ap-badge-approved' : (salonStatus == 'REJECTED' ? 'ap-badge-rejected' : (salonStatus == 'CHANGES_REQUESTED' ? 'ap-badge-changes' : 'ap-badge-pending'))}">${salonStatus}</span></td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/salons/${s.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/salons/${s.id}/profile"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:forEach var="st" items="${activeStylists}">
                    <c:set var="stylistStatus" value="${not empty st.partnerProfileStatus ? st.partnerProfileStatus : (st.approved ? 'APPROVED' : 'PENDING_ADMIN_APPROVAL')}" />
                    <tr class="bw-row" 
                        data-id="${st.id}" 
                        data-type="stylist" 
                        data-name="<c:out value='${st.firstName} ${st.lastName}'/>" 
                        data-email="<c:out value='${st.email}'/>"
                        data-phone="<c:out value='${st.contactNumber}'/>"
                        data-spec="<c:out value='${st.specialization}'/>"
                        data-exp="<c:out value='${st.experienceInYears}'/>"
                        data-loc="${not empty st.salon ? st.salon.city : '-'}"
                        data-status="${stylistStatus}"
                        data-photo="<c:out value='${st.profileImage}'/>"
                        data-doc-reg="na"
                        data-doc-lic="na"
                        data-doc-cert="na">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                               <c:when test="${not empty st.profileImage}"><img src="${st.profileImage}" alt=""></c:when>
                               <c:otherwise>${fn:substring(st.firstName,0,1).toUpperCase()}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm"><c:out value="${st.firstName} ${st.lastName}"/></div>
                            <div class="meta"><c:out value="${st.email}"/></div>
                            <div class="meta"><c:out value="${st.contactNumber}"/></div>
                          </span>
                        </div>
                      </td>
                      <td><span class="ap-badge ap-badge-reverify">Stylist</span></td>
                      <td>
                        <span class="ap-clip"><c:out value="${st.specialization}"/></span>
                        <div class="ap-muted" style="font-size:0.78rem;">${st.experienceInYears} Yrs Exp</div>
                      </td>
                      <td><span class="ap-muted">-</span></td>
                      <td><span class="ap-badge ${stylistStatus == 'APPROVED' ? 'ap-badge-approved' : (stylistStatus == 'REJECTED' ? 'ap-badge-rejected' : (stylistStatus == 'CHANGES_REQUESTED' ? 'ap-badge-changes' : 'ap-badge-pending'))}">${stylistStatus}</span></td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/stylists/${st.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/stylists/${st.id}/profile"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty activeSalons and empty activeStylists}">
                    <tr><td colspan="6"><div class="ap-empty"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No profiles found.</div></td></tr>
                  </c:if>
              </tbody>
            </table>
          </div>
        </section>

        <aside class="ap-panel ap-preview" id="previewPane">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;">Select a profile to preview</div>
            <div id="previewBody">
              <div class="hero">
                <span class="av" id="pvAv"></span>
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
                <span id="pvPctLabel">100%</span>
              </div>
              <div class="ap-progress"><span id="pvPctBar" style="width:100%"></span></div>

              <div style="font-size:0.78rem;font-weight:700;margin-bottom:8px;color:var(--ap-muted);">DOCUMENTS</div>
              <div class="ap-doc-list">
                <div class="ap-doc-item"><span>Profile Photo</span><span id="pvDocPhoto" style="color:var(--ap-success);font-weight:600;">Uploaded</span></div>
                <div class="ap-doc-item"><span>Business Reg.</span><span id="pvDocReg" style="color:var(--ap-danger);font-weight:600;">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Salon License</span><span id="pvDocLic" style="color:var(--ap-danger);font-weight:600;">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Hygiene Cert.</span><span id="pvDocCert" style="color:var(--ap-danger);font-weight:600;">Not uploaded</span></div>
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

    </div>
  </main>
</div>

<script>
(function () {
  var ctx = '${pageContext.request.contextPath}';
  var rows = Array.prototype.slice.call(document.querySelectorAll('.bw-row'));
  
  // Filter logic (front-end)
  var typeSelect = document.getElementById('typeFilter');
  if (typeSelect) {
    typeSelect.addEventListener('change', function () {
      var val = (typeSelect.value || '').toLowerCase();
      rows.forEach(function (r) {
        var s = (r.getAttribute('data-type') || '').toLowerCase();
        r.style.display = (!val || s === val) ? '' : 'none';
      });
    });
  }

  function badgeClass(status) {
    if (status === 'APPROVED') return 'ap-badge ap-badge-approved';
    if (status === 'REJECTED') return 'ap-badge ap-badge-rejected';
    if (status === 'CHANGES_REQUESTED') return 'ap-badge ap-badge-changes';
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
    var photo = row.getAttribute('data-photo') || '';
    var docReg = row.getAttribute('data-doc-reg') || 'no';
    var docLic = row.getAttribute('data-doc-lic') || 'no';
    var docCert = row.getAttribute('data-doc-cert') || 'no';
    var id = row.getAttribute('data-id');
    var type = row.getAttribute('data-type');

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone || '-';
    document.getElementById('pvSpec').textContent = spec + (exp ? (' • ' + exp + ' yrs exp.') : '');
    var st = document.getElementById('pvStatus');
    st.textContent = status;
    st.className = badgeClass(status);

    var av = document.getElementById('pvAv');
    if (photo && photo !== 'null') {
      var src = photo.indexOf('http') === 0 ? photo : (ctx + photo);
      av.innerHTML = '<img src="' + src + '" alt="">';
      document.getElementById('pvDocPhoto').textContent = 'Uploaded';
      document.getElementById('pvDocPhoto').style.color = 'var(--ap-success)';
    } else {
      av.textContent = (name || 'P').charAt(0).toUpperCase();
      document.getElementById('pvDocPhoto').textContent = 'Not uploaded';
      document.getElementById('pvDocPhoto').style.color = 'var(--ap-danger)';
    }
    
    var mapDoc = function(val, elId) {
      var el = document.getElementById(elId);
      if (val === 'yes') {
        el.textContent = 'Uploaded';
        el.style.color = 'var(--ap-success)';
      } else if (val === 'na') {
        el.textContent = 'N/A';
        el.style.color = 'var(--ap-muted)';
      } else {
        el.textContent = 'Not uploaded';
        el.style.color = 'var(--ap-danger)';
      }
    };
    
    mapDoc(docReg, 'pvDocReg');
    mapDoc(docLic, 'pvDocLic');
    mapDoc(docCert, 'pvDocCert');

    var baseRoute = type === 'salon' ? '/admin/salons/' : '/admin/stylists/';
    var href = ctx + baseRoute + id + '/profile';
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

  if (rows.length) {
    rows[0].classList.add('selected');
    fillPreview(rows[0]);
  } else {
    fillPreview(null);
  }

  var hs = document.getElementById('apHeaderSearch');
  var bws = document.getElementById('bwSearchInput');
  if (hs && bws) {
    hs.addEventListener('keydown', function(e) {
      if (e.key === 'Enter') {
        bws.value = hs.value;
        document.getElementById('bwFilterForm').submit();
      }
    });
  }
})();
</script>
</body>
</html>
