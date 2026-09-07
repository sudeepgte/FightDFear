<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Product Sellers Verification - Admin</title>
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
<c:set var="q" value="${param.q}"/>

<c:choose>
  <c:when test="${activeFilter == 'verified'}">
    <c:set var="activeList" value="${verified}"/>
    <c:set var="activeMpList" value="${verifiedMarketplace}"/>
  </c:when>
  <c:when test="${activeFilter == 'rejected'}">
    <c:set var="activeList" value="${rejected}"/>
    <c:set var="activeMpList" value="${rejectedMarketplace}"/>
  </c:when>
  <c:otherwise>
    <c:set var="activeList" value="${pending}"/>
    <c:set var="activeMpList" value="${pendingMarketplace}"/>
  </c:otherwise>
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
        <c:set var="apAdmin" value="${empty admin ? sessionScope.admin : admin}"/>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${apAdmin.id}">
          <span class="ap-avatar">
            <c:choose>
              <c:when test="${not empty apAdmin.profilePhoto}">
                <img src="${pageContext.request.contextPath}${apAdmin.profilePhoto}" alt="">
              </c:when>
              <c:otherwise>${fn:substring(apAdmin.name,0,1)}</c:otherwise>
            </c:choose>
          </span>
          <span>
            <div class="name"><c:out value="${apAdmin.name}"/></div>
            <div class="role">Super Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="ap-main-inner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-sellers">Seller Verification</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'verified'}">Verified Sellers</c:when>
            <c:when test="${activeFilter == 'rejected'}">Rejected Sellers</c:when>
            <c:when test="${not empty q}">Search Results</c:when>
            <c:otherwise>Pending Sellers</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-shopping-bag"></i></div>
        <div>
          <h1>Women Product Sellers</h1>
          <p>Review and verify sellers offering safety and women's products</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-3" style="border-radius:12px;"><i class="fas fa-info-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3" style="border-radius:12px;"><i class="fas fa-exclamation-circle me-1"></i><c:out value="${error}"/></div>
      </c:if>

      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${(not empty pending ? pending.size() : 0) + (not empty pendingMarketplace ? pendingMarketplace.size() : 0)}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Requires review</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${(not empty verified ? verified.size() : 0) + (not empty verifiedMarketplace ? verifiedMarketplace.size() : 0)}</div>
          <div class="lbl">Verified</div>
          <div class="sub">Live on shop</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${(not empty rejected ? rejected.size() : 0) + (not empty rejectedMarketplace ? rejectedMarketplace.size() : 0)}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not listed</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/pending-sellers" class="ap-filter-row" id="sellerFilterForm">
        <div class="grow">
          <input type="text" id="sellerSearchInput" name="q" class="ap-input"
                 placeholder="Search by name, email, business name or location..."
                 value="${not empty q ? q : ''}">
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select" onchange="this.form.submit()">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="verified" ${activeFilter == 'verified' ? 'selected' : ''}>Verified</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty q}">
          <a href="${pageContext.request.contextPath}/admin/pending-sellers" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <div class="ap-split">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' && empty q ? 'active' : ''}" href="?filter=pending">Pending</a>
            <a class="ap-tab ${activeFilter == 'verified' && empty q ? 'active' : ''}" href="?filter=verified">Verified</a>
            <a class="ap-tab ${activeFilter == 'rejected' && empty q ? 'active' : ''}" href="?filter=rejected">Rejected</a>
          </div>

          <c:if test="${not empty q}">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${q}"/></strong>"
            </div>
          </c:if>

          <div class="ap-table-wrap">
            <table class="ap-table" id="sellerQueueTable">
              <thead>
                <tr>
                  <th>Seller / Provider</th>
                  <th>Business Info</th>
                  <th>Location</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:set var="hasItems" value="false" />
                
                <c:if test="${not empty activeList}">
                  <c:forEach var="s" items="${activeList}" varStatus="st">
                    <c:set var="hasItems" value="true" />
                    <c:set var="locText" value="${not empty s.city ? s.city : s.address}"/>
                    <c:if test="${not empty s.city && not empty s.state}"><c:set var="locText" value="${s.city}, ${s.state}"/></c:if>
                    
                    <tr class="seller-row ${st.first ? 'selected' : ''}"
                        data-id="${s.id}"
                        data-type="seller"
                        data-name="<c:out value='${s.fullName}'/>"
                        data-email="<c:out value='${s.email}'/>"
                        data-phone="<c:out value='${s.phone}'/>"
                        data-biz="<c:out value='${s.businessName}'/>"
                        data-cat="<c:out value='${s.category}'/>"
                        data-loc="<c:out value='${locText}'/>"
                        data-status="<c:out value='${s.verificationStatus}'/>"
                        data-photo="<c:out value='${s.profilePhotoPath}'/>"
                        data-doc="${not empty s.identityDocPath ? '1' : '0'}"
                        data-photo-ok="${not empty s.profilePhotoPath ? '1' : '0'}">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="${not empty s.profilePhotoPath}">
                                <img src="${fn:startsWith(s.profilePhotoPath,'http') ? s.profilePhotoPath : pageContext.request.contextPath.concat(s.profilePhotoPath)}" alt="">
                              </c:when>
                              <c:otherwise>${fn:substring(s.fullName,0,1)}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${s.fullName}'/>"><c:out value="${s.fullName}"/></div>
                            <div class="meta" title="<c:out value='${s.email}'/>"><c:out value="${s.email}"/></div>
                            <div class="meta"><c:out value="${not empty s.phone ? s.phone : '-'}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip fw-bold" title="<c:out value='${s.businessName}'/>"><c:out value="${not empty s.businessName ? s.businessName : '-'}"/></span>
                        <div class="ap-muted" style="font-size:0.78rem;">
                          <c:out value="${not empty s.category ? s.category : '-'}"/>
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
                          <c:when test="${s.verificationStatus == 'VERIFIED'}"><span class="ap-badge ap-badge-approved">VERIFIED</span></c:when>
                          <c:when test="${s.verificationStatus == 'REJECTED'}"><span class="ap-badge ap-badge-rejected">REJECTED</span></c:when>
                          <c:otherwise><span class="ap-badge ap-badge-pending">PENDING</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/sellers/${s.id}/profile" title="Review"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:if>

                <c:if test="${not empty activeMpList}">
                  <c:forEach var="p" items="${activeMpList}" varStatus="st">
                    <c:set var="hasItems" value="true" />
                    <tr class="seller-row"
                        data-id="${p.id}"
                        data-type="provider"
                        data-name="<c:out value='${p.fullName}'/>"
                        data-email="<c:out value='${p.email}'/>"
                        data-phone="<c:out value='${p.phone}'/>"
                        data-biz="Marketplace Provider"
                        data-cat="<c:out value='${p.category}'/>"
                        data-loc="<c:out value='${p.locationText}'/>"
                        data-status="<c:out value='${p.verificationStatus}'/>"
                        data-photo="<c:out value='${p.profilePhotoPath}'/>"
                        data-doc="${not empty p.identityDocumentPath ? '1' : '0'}"
                        data-photo-ok="${not empty p.profilePhotoPath ? '1' : '0'}">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="${not empty p.profilePhotoPath}">
                                <img src="${fn:startsWith(p.profilePhotoPath,'http') ? p.profilePhotoPath : pageContext.request.contextPath.concat(p.profilePhotoPath)}" alt="">
                              </c:when>
                              <c:otherwise>${fn:substring(p.fullName,0,1)}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${p.fullName}'/>"><c:out value="${p.fullName}"/> <span class="badge bg-secondary ms-1" style="font-size:0.6rem;">MP</span></div>
                            <div class="meta" title="<c:out value='${p.email}'/>"><c:out value="${p.email}"/></div>
                            <div class="meta"><c:out value="${not empty p.phone ? p.phone : '-'}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip fw-bold">Marketplace Provider</span>
                        <div class="ap-muted" style="font-size:0.78rem;">
                          <c:out value="${not empty p.category ? p.category : '-'}"/>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${p.locationText}'/>">
                          <c:choose>
                            <c:when test="${not empty p.locationText}"><c:out value="${p.locationText}"/></c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </span>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${p.verificationStatus == 'VERIFIED'}"><span class="ap-badge ap-badge-approved">VERIFIED</span></c:when>
                          <c:when test="${p.verificationStatus == 'REJECTED'}"><span class="ap-badge ap-badge-rejected">REJECTED</span></c:when>
                          <c:otherwise><span class="ap-badge ap-badge-pending">PENDING</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile" title="Review"><i class="fas fa-ellipsis-v"></i></a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:if>

                <c:if test="${not hasItems}">
                  <tr>
                    <td colspan="5"><div class="ap-empty"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No sellers in this queue.</div></td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>

        <aside class="ap-panel ap-preview" id="sellerPreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;">Select a seller to preview</div>
            <div id="previewBody">
              <div class="hero">
                <span class="av" id="pvAv">S</span>
                <div style="min-width:0;">
                  <h3 id="pvName">-</h3>
                  <div style="margin:6px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line fw-bold" id="pvBiz" style="color:var(--ap-accent);">-</div>
                  <div class="line" id="pvEmail">-</div>
                  <div class="line" id="pvPhone">-</div>
                  <div class="line" id="pvCat">-</div>
                </div>
              </div>

              <div style="font-size:0.78rem;font-weight:700;margin-top:20px;margin-bottom:8px;color:var(--ap-muted);">DOCUMENTS</div>
              <div class="ap-doc-list">
                <div class="ap-doc-item"><span>Profile Photo</span><span id="pvDocPhoto" class="st-miss">Not uploaded</span></div>
                <div class="ap-doc-item"><span>Identity Proof</span><span id="pvDocId" class="st-miss">Not uploaded</span></div>
              </div>

              <a id="pvReview" class="ap-btn ap-btn-primary" style="width:100%;justify-content:center;margin-top:20px;" href="#">
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
  var rows = Array.prototype.slice.call(document.querySelectorAll('.seller-row'));
  
  var qParam = '${q}';
  if (qParam) {
     var ql = qParam.toLowerCase();
     rows.forEach(function(r) {
         var txt = (r.getAttribute('data-name') + ' ' + r.getAttribute('data-email') + ' ' + r.getAttribute('data-biz') + ' ' + r.getAttribute('data-loc')).toLowerCase();
         if (txt.indexOf(ql) === -1) {
             r.style.display = 'none';
         }
     });
  }

  function setDoc(el, ok) {
    el.textContent = ok ? 'Uploaded' : 'Not uploaded';
    el.className = ok ? 'st-ok' : 'st-miss';
  }

  function badgeClass(status) {
    if (status === 'VERIFIED') return 'ap-badge ap-badge-approved';
    if (status === 'REJECTED') return 'ap-badge ap-badge-rejected';
    return 'ap-badge ap-badge-pending';
  }

  function fillPreview(row) {
    if (!row || row.style.display === 'none') {
      var visibleRows = rows.filter(function(r) { return r.style.display !== 'none'; });
      if (visibleRows.length > 0 && !row) {
          row = visibleRows[0];
          row.classList.add('selected');
      } else {
          document.getElementById('previewBody').style.display = 'none';
          document.getElementById('previewEmpty').style.display = 'block';
          return;
      }
    }
    
    document.getElementById('previewBody').style.display = 'block';
    document.getElementById('previewEmpty').style.display = 'none';

    var type = row.getAttribute('data-type');
    var name = row.getAttribute('data-name') || '-';
    var email = row.getAttribute('data-email') || '-';
    var phone = row.getAttribute('data-phone') || '-';
    var biz = row.getAttribute('data-biz') || '-';
    var cat = row.getAttribute('data-cat') || '-';
    var status = row.getAttribute('data-status') || 'PENDING';
    var photo = row.getAttribute('data-photo') || '';
    var id = row.getAttribute('data-id');
    var photoOk = row.getAttribute('data-photo-ok') === '1';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone || '-';
    document.getElementById('pvBiz').textContent = biz;
    document.getElementById('pvCat').textContent = cat;
    
    var st = document.getElementById('pvStatus');
    st.textContent = status;
    st.className = badgeClass(status);

    var av = document.getElementById('pvAv');
    if (photoOk && photo) {
      var src = photo.indexOf('http') === 0 ? photo : (ctx + photo);
      av.innerHTML = '<img src="' + src + '" alt="">';
    } else {
      av.textContent = (name || 'S').charAt(0).toUpperCase();
    }

    setDoc(document.getElementById('pvDocPhoto'), photoOk);
    setDoc(document.getElementById('pvDocId'), row.getAttribute('data-doc') === '1');

    var href = ctx + (type === 'provider' ? '/admin/providers/' : '/admin/sellers/') + id + '/profile';
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

  if (rows.length) fillPreview(rows.find(r => r.style.display !== 'none') || rows[0]);
  else fillPreview(null);

  var hs = document.getElementById('sellerSearchInput');
  if (hs) {
    document.addEventListener('keydown', function (e) {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        hs.focus();
      }
    });
    hs.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') {
      }
    });
  }
})();
</script>
</body>
</html>
