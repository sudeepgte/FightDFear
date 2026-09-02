<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>
    <c:choose>
        <c:when test="${selectedCategory == 'WOMEN_PRODUCTS'}">Women Products Verification - Fight D Fear Admin</c:when>
        <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Women Lawyer Verification - Fight D Fear Admin</c:when>
        <c:when test="${selectedCategory == 'FITNESS_ZUMBA'}">Fitness & Zumba Verification - Fight D Fear Admin</c:when>
        <c:otherwise>Service Partner Verification - Fight D Fear Admin</c:otherwise>
    </c:choose>
  </title>
  
  <!-- Bootstrap 5 & FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <!-- Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <!-- Shared Admin Portal Stylesheet (Doctor Verification Theme) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  
  <style>
    * { box-sizing: border-box; }
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; overflow: hidden; width: 100vw; max-width: 100%; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg, #F8FAFC); overflow-x: hidden; }
    .dv-actions { display: flex; gap: 6px; align-items: center; }
    .dv-more {
      width: 34px; height: 34px; border-radius: 9px; border: 1px solid var(--ap-border, #E2E8F0);
      background: #fff; color: var(--ap-muted, #64748B); display: inline-flex; align-items: center; justify-content: center;
      text-decoration: none !important;
      transition: all 0.2s;
    }
    .dv-more:hover { color: var(--ap-accent, #F43F5E); border-color: #FDA4AF; }
    .dv-bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px; }
    @media (max-width: 992px) { .dv-bottom-grid { grid-template-columns: 1fr; } }
    
    /* Action Buttons */
    .btn-approve-sm {
      background-color: #16A34A;
      color: white;
      padding: 5px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
    }
    .btn-approve-sm:hover { background-color: #15803D; color: white; transform: translateY(-1px); }

    .btn-reject-sm {
      background-color: #DC2626;
      color: white;
      padding: 5px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
    }
    .btn-reject-sm:hover { background-color: #B91C1C; color: white; transform: translateY(-1px); }

    .btn-view-doc {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      background: #FFF1F3; 
      color: #F43F5E; 
      border: 1px solid #FFE4E6;
      padding: 5px 12px; 
      border-radius: 8px; 
      font-size: 0.8rem; 
      font-weight: 700;
      text-decoration: none !important; 
      transition: all 0.2s ease;
    }
    .btn-view-doc:hover { background: #F43F5E; color: #fff; border-color: #F43F5E; }

    /* Interactive Row Hover */
    .lawyer-row { cursor: pointer; transition: background-color 0.15s ease; }
    .lawyer-row:hover { background-color: #FFF7F8 !important; }
    .lawyer-row.selected { background-color: #FFF1F3 !important; }

    /* Mobile Provider Card */
    .fl-mobile-card {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 14px;
      padding: 16px;
      margin-bottom: 14px;
      box-shadow: 0 1px 3px rgba(15,23,42,.03);
    }
    .fl-mobile-label {
      font-size: 0.72rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.03em;
      color: #64748B;
      margin-bottom: 2px;
    }
    .fl-mobile-val {
      font-size: 0.88rem;
      color: #0F172A;
      margin-bottom: 8px;
      word-break: break-word;
    }

    /* Global Layout Fixes */
    .ap-split, .dv-bottom-grid { width: 100%; box-sizing: border-box; }
    .ap-panel { width: 100%; box-sizing: border-box; }
    .ap-table-wrap, .table-responsive { width: 100%; overflow-x: auto; box-sizing: border-box; -webkit-overflow-scrolling: touch; }
    .table, .ap-table { min-width: 600px; }

    /* ==========================================
       TABLET & MOBILE RESPONSIVE
       ========================================== */
    @media (max-width: 992px) {
      .ap-main-inner { padding: 16px; width: 100%; box-sizing: border-box; overflow-x: hidden; }
      .ap-filter-row { flex-direction: row; flex-wrap: wrap; align-items: center; width: 100%; padding: 12px; box-sizing: border-box; }
      .ap-filter-row .grow { flex: 1 1 100%; min-width: 100% !important; }
      .ap-filter-row > div:not(.grow) { flex: 1 1 45%; min-width: 0 !important; max-width: 50%; overflow: hidden; }
      .ap-filter-row .ap-input, .ap-filter-row .ap-select { width: 100%; max-width: 100%; box-sizing: border-box; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; }
      .ap-filter-row .ap-btn { flex: 1 1 auto; width: auto; justify-content: center; }
      .mobile-back-btn { display: inline-flex !important; }
      .ap-tabs { flex-wrap: nowrap; overflow-x: auto; padding-bottom: 5px; -webkit-overflow-scrolling: touch; }
    }

    @media (max-width: 480px) {
      body { overflow-x: hidden; width: 100%; margin: 0; padding: 0; }
      .ap-topbar { padding: 10px 16px; flex-wrap: wrap; gap: 10px; width: 100%; box-sizing: border-box; }
      .ap-search { width: 100%; max-width: none !important; }
      .ap-page-head { flex-direction: column; align-items: flex-start; gap: 12px; }
      .dv-bottom-grid { display: flex; flex-direction: column; }
      .fl-mobile-card { width: 100%; padding: 12px; }
      .dv-actions { flex-direction: column; width: 100%; gap: 8px; }
      .dv-actions .btn-approve-sm, .dv-actions .btn-reject-sm, .dv-actions .btn-view-doc { width: 100%; text-align: center; justify-content: center; }
    }
  </style>
</head>
<body class="ap-page">

<!-- Dynamic Counts Setup -->
<c:set var="activeFilter" value="${empty param.filter ? 'pending' : param.filter}"/>
<c:set var="pendingCount" value="${not empty pending ? fn:length(pending) : 0}"/>
<c:set var="approvedCount" value="${not empty verified ? fn:length(verified) : 0}"/>
<c:set var="rejectedCount" value="${not empty rejected ? fn:length(rejected) : 0}"/>
<c:set var="reverificationCount" value="0"/>
<c:set var="changesRequestedCount" value="0"/>
<c:set var="totalLawyers" value="${pendingCount + approvedCount + rejectedCount}"/>

<!-- Strict non-empty Search Query detection -->
<c:set var="rawQ" value="${param.q}"/>
<c:set var="searchQuery" value="${not empty rawQ ? fn:trim(rawQ) : ''}"/>

<!-- Select active list based on activeFilter or search parameter q -->
<c:choose>
  <c:when test="${not empty searchQuery}">
    <c:set var="activeList" value="${pending}"/>
  </c:when>
  <c:when test="${activeFilter == 'approved'}"><c:set var="activeList" value="${verified}"/></c:when>
  <c:when test="${activeFilter == 'rejected'}"><c:set var="activeList" value="${rejected}"/></c:when>
  <c:when test="${activeFilter == 'all'}"><c:set var="activeList" value="${verified}"/></c:when>
  <c:otherwise><c:set var="activeList" value="${pending}"/></c:otherwise>
</c:choose>

<!-- Sidebar Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="layout">
  <!-- Shared Navigation Sidebar -->
  <%@ include file="globalAdminMenu.jsp" %>

  <!-- Main Content Dashboard -->
  <main class="main w-100">
    <!-- Topbar Header -->
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:360px;">
          <i class="fas fa-search"></i>
          <input type="search" id="apHeaderSearch" placeholder="Search anything... Ctrl + K" aria-label="Search">
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
      <!-- Breadcrumbs -->
      <nav class="ap-crumb">
        <a href="javascript:history.back()" class="mobile-back-btn d-md-none" style="display: none; color: var(--ap-accent, #F43F5E); font-weight: bold; margin-right: 8px;">
          <i class="fas fa-arrow-left"></i>
        </a>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_LAWYER">Service Partners</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Women Lawyer Verification</c:when>
            <c:otherwise>Provider Verification</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <!-- Page Header -->
      <div class="ap-page-head">
        <div class="ap-page-ico">
          <c:choose>
            <c:when test="${selectedCategory == 'WOMEN_LAWYER'}"><i class="fas fa-gavel"></i></c:when>
            <c:otherwise><i class="fas fa-store"></i></c:otherwise>
          </c:choose>
        </div>
        <div>
          <h1>
            <c:choose>
                <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Women Lawyer Verification</c:when>
                <c:otherwise>Service Partner Verification</c:otherwise>
            </c:choose>
          </h1>
          <p>
            <c:choose>
              <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Review and verify women lawyer profiles before they appear on the platform</c:when>
              <c:otherwise>Review and verify service partners registered from mobile / web</c:otherwise>
            </c:choose>
          </p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show mb-3" style="border-radius:12px;" role="alert">
          <i class="fas fa-info-circle me-2"></i> <c:out value="${message}"/>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>

      <!-- 6 Statistic Cards Grid -->
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
          <div class="sub">
            <c:choose>
              <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Verified lawyers</c:when>
              <c:otherwise>Verified providers</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${rejectedCount}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not approved</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-gavel"></i></div>
          <div class="val">${totalLawyers}</div>
          <div class="lbl">
            <c:choose>
              <c:when test="${selectedCategory == 'WOMEN_LAWYER'}">Total Lawyers</c:when>
              <c:otherwise>Total Partners</c:otherwise>
            </c:choose>
          </div>
          <div class="sub">Across queues</div>
        </div>
      </div>

      <!-- Horizontal Search and Filter Bar -->
      <form method="get" action="${pageContext.request.contextPath}/admin/pending-providers" class="ap-filter-row" id="lawyerFilterForm">
        <input type="hidden" name="category" value="${selectedCategory}">
        <div class="grow">
          <input type="text" id="lawyerSearchInput" name="q" class="ap-input"
                 placeholder="Search by name, email, phone, practice areas, bar ID or location..."
                 value="${not empty searchQuery ? searchQuery : ''}">
        </div>
        <div style="min-width:180px;">
          <select id="specClientFilter" class="ap-select" aria-label="Practice areas filter">
            <option value="">All Categories</option>
          </select>
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
            <option value="all" ${activeFilter == 'all' ? 'selected' : ''}>All (search scope)</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <c:if test="${not empty searchQuery}">
          <a href="${pageContext.request.contextPath}/admin/pending-providers?category=${selectedCategory}" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
        </c:if>
      </form>

      <!-- Main Split Section (Table + Preview Panel) -->
      <div class="ap-split">
        <section class="ap-panel">
          <!-- Status Tabs -->
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' && empty searchQuery ? 'active' : ''}" href="?category=${selectedCategory}&filter=pending">Pending (${pendingCount})</a>
            <a class="ap-tab ${activeFilter == 'reverification' ? 'active' : ''}" href="?category=${selectedCategory}&filter=reverification">Re-verification (${reverificationCount})</a>
            <a class="ap-tab ${activeFilter == 'changes_requested' ? 'active' : ''}" href="?category=${selectedCategory}&filter=changes_requested">Changes Requested (${changesRequestedCount})</a>
            <a class="ap-tab ${activeFilter == 'approved' && empty searchQuery ? 'active' : ''}" href="?category=${selectedCategory}&filter=approved">Approved (${approvedCount})</a>
            <a class="ap-tab ${activeFilter == 'rejected' && empty searchQuery ? 'active' : ''}" href="?category=${selectedCategory}&filter=rejected">Rejected (${rejectedCount})</a>
          </div>

          <c:if test="${not empty searchQuery}">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${searchQuery}"/></strong>"
            </div>
          </c:if>

          <!-- Desktop Table View -->
          <div class="ap-table-wrap d-none d-md-block">
            <table class="ap-table" id="lawyerQueueTable">
              <thead>
                <tr>
                  <th>Lawyer</th>
                  <th>Practice Areas</th>
                  <th>Location</th>
                  <th>Exp / Fee</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeList}">
                  <c:forEach var="p" items="${activeList}" varStatus="st">
                    <tr class="lawyer-row ${st.first ? 'selected' : ''}"
                        data-id="${p.id}"
                        data-name="<c:out value='${p.fullName}'/>"
                        data-email="<c:out value='${p.email}'/>"
                        data-phone="<c:out value='${p.phone}'/>"
                        data-category="<c:out value='${p.category}'/>"
                        data-location="<c:out value='${p.locationText}'/>"
                        data-practice="<c:out value='${p.practiceAreas}'/>"
                        data-barid="<c:out value='${p.barCouncilId}'/>"
                        data-exp="${p.experienceYears}"
                        data-fee="${p.consultationFee}"
                        data-bio="<c:out value='${p.description}'/>"
                        data-iddoc="<c:out value='${p.identityDocumentPath}'/>"
                        data-status="<c:out value='${p.verificationStatus}'/>">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            ${fn:substring(p.fullName,0,1)}
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${p.fullName}'/>"><c:out value="${p.fullName}"/></div>
                            <div class="meta" title="<c:out value='${p.email}'/>"><c:out value="${p.email}"/></div>
                            <div class="meta"><c:out value="${not empty p.phone ? p.phone : '-'}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${p.practiceAreas}'/>"><c:out value="${not empty p.practiceAreas ? p.practiceAreas : '-'}"/></span>
                        <div class="ap-muted" style="font-size:0.78rem;">Bar ID: <c:out value="${not empty p.barCouncilId ? p.barCouncilId : '-'}"/></div>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${p.locationText}'/>"><c:out value="${not empty p.locationText ? p.locationText : '-'}"/></span>
                      </td>
                      <td>
                        <div style="font-size:0.84rem;font-weight:600;">${p.experienceYears != null ? p.experienceYears : '-'} yrs</div>
                        <div class="ap-muted" style="font-size:0.78rem;">${p.consultationFee != null ? 'Rs '.concat(p.consultationFee) : '-'}</div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${p.verificationStatus == 'VERIFIED' || p.verificationStatus == 'APPROVED'}">
                            <span class="ap-badge ap-badge-approved">VERIFIED</span>
                          </c:when>
                          <c:when test="${p.verificationStatus == 'REJECTED'}">
                            <span class="ap-badge ap-badge-rejected">REJECTED</span>
                          </c:when>
                          <c:otherwise>
                            <span class="ap-badge ap-badge-pending">PENDING</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="dv-actions">
                          <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0 p-0">
                            <button class="btn-approve-sm" type="submit" title="Verify"><i class="fas fa-check"></i></button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/reject" method="post" class="m-0 p-0">
                            <button class="btn-reject-sm" type="submit" title="Reject"><i class="fas fa-times"></i></button>
                          </form>
                          <c:if test="${not empty p.identityDocumentPath && p.identityDocumentPath != 'web-pending'}">
                            <a class="btn-view-doc" href="${pageContext.request.contextPath}${p.identityDocumentPath}" target="_blank" title="View Document"><i class="fas fa-id-card"></i> ID</a>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="6">
                      <div class="ap-empty py-5">
                        <i class="fas fa-inbox fa-2x mb-2 d-block text-secondary" style="opacity:.35;"></i>
                        No lawyers in this queue.
                      </div>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>

          <!-- Mobile Cards View (< 768px) -->
          <div class="p-3 d-block d-md-none">
            <c:choose>
              <c:when test="${not empty activeList}">
                <c:forEach var="p" items="${activeList}">
                  <div class="fl-mobile-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                      <h6 class="fw-bold mb-0 text-dark" style="font-size:1rem;">${p.fullName}</h6>
                      <c:choose>
                        <c:when test="${p.verificationStatus == 'VERIFIED' || p.verificationStatus == 'APPROVED'}">
                          <span class="ap-badge ap-badge-approved">VERIFIED</span>
                        </c:when>
                        <c:when test="${p.verificationStatus == 'REJECTED'}">
                          <span class="ap-badge ap-badge-rejected">REJECTED</span>
                        </c:when>
                        <c:otherwise>
                          <span class="ap-badge ap-badge-pending">PENDING</span>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <div class="fl-mobile-label">Contact Details</div>
                    <div class="fl-mobile-val">
                      <i class="fas fa-envelope me-1 text-muted"></i> ${p.email}<br>
                      <i class="fas fa-phone me-1 text-muted"></i> ${p.phone}
                    </div>

                    <div class="row g-2 mb-2">
                      <div class="col-6">
                        <div class="fl-mobile-label">Location</div>
                        <div class="fl-mobile-val mb-0">${p.locationText}</div>
                      </div>
                      <div class="col-6">
                        <div class="fl-mobile-label">Category</div>
                        <div class="fl-mobile-val mb-0"><span class="badge bg-light text-dark border">${p.category}</span></div>
                      </div>
                    </div>

                    <div class="p-2.5 mb-2 rounded bg-light border" style="font-size:0.84rem;">
                      <div class="mb-1"><strong>Practice Areas:</strong> ${empty p.practiceAreas ? '—' : p.practiceAreas}</div>
                      <div class="mb-1"><strong>Bar ID:</strong> ${empty p.barCouncilId ? '—' : p.barCouncilId}</div>
                      <div class="mb-1">
                        <strong>Experience / Fee:</strong> 
                        ${p.experienceYears != null ? p.experienceYears : '—'} yrs / Rs ${p.consultationFee != null ? p.consultationFee : '—'}
                      </div>
                      <div><strong>Bio:</strong> ${empty p.description ? '—' : p.description}</div>
                    </div>

                    <div class="d-flex align-items-center justify-content-between pt-2 border-top gap-2">
                      <div>
                        <c:choose>
                            <c:when test="${not empty p.identityDocumentPath && p.identityDocumentPath != 'web-pending'}">
                                <a href="${pageContext.request.contextPath}${p.identityDocumentPath}" target="_blank" class="btn-view-doc py-1 px-3">
                                  <i class="fas fa-id-card me-1"></i> View ID
                                </a>
                            </c:when>
                            <c:otherwise><span class="text-muted small">No ID</span></c:otherwise>
                        </c:choose>
                      </div>

                      <div class="d-flex align-items-center gap-2">
                          <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/verify" method="post" class="m-0 p-0">
                              <button class="btn-approve-sm py-1 px-3" type="submit" title="Verify"><i class="fas fa-check me-1"></i> Approve</button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin/providers/${p.id}/reject" method="post" class="m-0 p-0">
                              <button class="btn-reject-sm py-1 px-3" type="submit" title="Reject"><i class="fas fa-times me-1"></i> Reject</button>
                          </form>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="ap-empty py-5 text-center">
                  <i class="fas fa-inbox fa-2x mb-2 d-block text-secondary" style="opacity:0.35;"></i>
                  <p class="mb-0 fw-medium text-secondary">No lawyers in this queue.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </section>

        <!-- Right Side Preview Panel -->
        <aside class="ap-panel ap-preview" id="lawyerPreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;padding:40px 10px;">Select a lawyer to preview</div>
            <div id="previewBody">
              <div class="hero mb-3">
                <span class="av" id="pvAv" style="width:48px;height:48px;font-size:1.2rem;background:#FFF1F3;color:#F43F5E;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:700;">L</span>
                <div style="min-width:0;flex:1;">
                  <h3 id="pvName" style="font-size:1.1rem;font-weight:800;color:#0F172A;margin-bottom:2px;">-</h3>
                  <div style="margin:4px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line small text-muted" id="pvEmail">-</div>
                  <div class="line small text-muted" id="pvPhone">-</div>
                </div>
              </div>

              <div class="p-3 rounded bg-light border mb-3" style="font-size:0.84rem;">
                <div class="mb-1"><strong>Practice Areas:</strong> <span id="pvPractice">-</span></div>
                <div class="mb-1"><strong>Bar ID:</strong> <span id="pvBarId">-</span></div>
                <div class="mb-1"><strong>Experience / Fee:</strong> <span id="pvExpFee">-</span></div>
                <div class="mb-1"><strong>Location:</strong> <span id="pvLocation">-</span></div>
                <div><strong>Bio:</strong> <span id="pvBio">-</span></div>
              </div>

              <div class="mb-3" id="pvDocWrap">
                <a id="pvIdDocBtn" class="btn-view-doc w-100 justify-content-center py-2" href="#" target="_blank">
                  <i class="fas fa-id-card me-1"></i> View Identity Document
                </a>
              </div>

              <div class="d-flex gap-2">
                <form id="pvApproveForm" action="#" method="post" class="flex-grow-1">
                  <button type="submit" class="btn-approve-sm w-100 py-2 fs-6"><i class="fas fa-check me-1"></i> Approve</button>
                </form>
                <form id="pvRejectForm" action="#" method="post" class="flex-grow-1">
                  <button type="submit" class="btn-reject-sm w-100 py-2 fs-6"><i class="fas fa-times me-1"></i> Reject</button>
                </form>
              </div>
            </div>
          </div>
        </aside>
      </div>

      <!-- Lower Dashboard Section: Verified Lawyers & Rejected Lawyers Cards -->
      <div class="dv-bottom-grid">
        <!-- Card 1: Verified / Approved Lawyers -->
        <section class="ap-panel">
          <div class="ap-panel-hd d-flex align-items-center justify-content-between p-3 border-bottom" style="background:#FFF1F3;">
            <div class="d-flex align-items-center gap-2">
              <i class="fas fa-check-circle text-success fs-5"></i>
              <h2 class="fs-6 fw-bold mb-0 text-dark">Approved / Verified Lawyers (${approvedCount})</h2>
            </div>
            <a href="?category=${selectedCategory}&filter=approved" style="color:var(--ap-accent, #F43F5E);font-size:0.82rem;font-weight:700;text-decoration:none;">View in Queue</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:100%;">
              <thead>
                <tr><th>Lawyer</th><th>Category / Practice</th><th>Status</th><th>Action</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty verified}">
                    <c:forEach var="p" items="${verified}">
                      <tr>
                        <td>
                          <div style="font-weight:700;color:#0F172A;"><c:out value="${p.fullName}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${p.email}"/></div>
                        </td>
                        <td>
                          <span class="ap-clip" style="max-width:200px;" title="<c:out value='${p.practiceAreas}'/>">
                            <c:out value="${not empty p.practiceAreas ? p.practiceAreas : p.category}"/>
                          </span>
                        </td>
                        <td><span class="ap-badge ap-badge-approved">VERIFIED</span></td>
                        <td>
                          <c:if test="${not empty p.identityDocumentPath && p.identityDocumentPath != 'web-pending'}">
                            <a class="btn-view-doc py-1 px-2 fs-7" href="${pageContext.request.contextPath}${p.identityDocumentPath}" target="_blank">
                              <i class="fas fa-id-card"></i> Doc
                            </a>
                          </c:if>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="4"><div class="ap-empty py-4 text-center text-muted">No verified lawyers yet.</div></td></tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <!-- Card 2: Rejected Lawyers -->
        <section class="ap-panel">
          <div class="ap-panel-hd d-flex align-items-center justify-content-between p-3 border-bottom" style="background:#FFF1F3;">
            <div class="d-flex align-items-center gap-2">
              <i class="fas fa-times-circle text-danger fs-5"></i>
              <h2 class="fs-6 fw-bold mb-0 text-dark">Rejected Lawyers (${rejectedCount})</h2>
            </div>
            <a href="?category=${selectedCategory}&filter=rejected" style="color:var(--ap-accent, #F43F5E);font-size:0.82rem;font-weight:700;text-decoration:none;">View in Queue</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:100%;">
              <thead>
                <tr><th>Lawyer</th><th>Category</th><th>Status</th></tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${not empty rejected}">
                    <c:forEach var="p" items="${rejected}">
                      <tr>
                        <td>
                          <div style="font-weight:700;color:#0F172A;"><c:out value="${p.fullName}"/></div>
                          <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${p.email}"/></div>
                        </td>
                        <td><span class="badge bg-light text-dark border">${p.category}</span></td>
                        <td><span class="ap-badge ap-badge-rejected">REJECTED</span></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr><td colspan="3"><div class="ap-empty py-4 text-center text-muted">No rejected lawyers.</div></td></tr>
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

<!-- Interactive Selection Script -->
<script>
(function () {
  var ctx = '${pageContext.request.contextPath}';
  var rows = Array.prototype.slice.call(document.querySelectorAll('.lawyer-row'));
  var specSelect = document.getElementById('specClientFilter');
  var specs = {};

  rows.forEach(function (r) {
    var s = (r.getAttribute('data-practice') || '').trim();
    if (s) {
      s.split(',').forEach(function(item) {
        var trimmed = item.trim();
        if (trimmed) specs[trimmed] = true;
      });
    }
  });

  Object.keys(specs).sort().forEach(function (s) {
    var opt = document.createElement('option');
    opt.value = s;
    opt.textContent = s;
    specSelect.appendChild(opt);
  });

  function fillPreview(row) {
    if (!row) {
      document.getElementById('previewBody').style.display = 'none';
      document.getElementById('previewEmpty').style.display = 'block';
      return;
    }
    document.getElementById('previewBody').style.display = 'block';
    document.getElementById('previewEmpty').style.display = 'none';

    var id = row.getAttribute('data-id');
    var name = row.getAttribute('data-name') || '-';
    var email = row.getAttribute('data-email') || '-';
    var phone = row.getAttribute('data-phone') || '-';
    var practice = row.getAttribute('data-practice') || '-';
    var barid = row.getAttribute('data-barid') || '-';
    var exp = row.getAttribute('data-exp') || '-';
    var fee = row.getAttribute('data-fee') || '-';
    var location = row.getAttribute('data-location') || '-';
    var bio = row.getAttribute('data-bio') || '-';
    var iddoc = row.getAttribute('data-iddoc') || '';
    var status = row.getAttribute('data-status') || 'PENDING';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone;
    document.getElementById('pvPractice').textContent = practice;
    document.getElementById('pvBarId').textContent = barid;
    document.getElementById('pvExpFee').textContent = (exp !== '-' ? (exp + ' yrs') : '-') + ' / ' + (fee !== '-' ? ('Rs ' + fee) : '-');
    document.getElementById('pvLocation').textContent = location;
    document.getElementById('pvBio').textContent = bio;
    document.getElementById('pvStatus').textContent = status;
    document.getElementById('pvAv').textContent = (name || 'L').charAt(0).toUpperCase();

    var docBtn = document.getElementById('pvIdDocBtn');
    if (iddoc && iddoc !== '' && iddoc !== 'web-pending') {
      docBtn.style.display = 'inline-flex';
      docBtn.href = ctx + iddoc;
    } else {
      docBtn.style.display = 'none';
    }

    document.getElementById('pvApproveForm').action = ctx + '/admin/providers/' + id + '/verify';
    document.getElementById('pvRejectForm').action = ctx + '/admin/providers/' + id + '/reject';
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
      var s = (r.getAttribute('data-practice') || '').toLowerCase();
      r.style.display = (!val || s.indexOf(val) !== -1) ? '' : 'none';
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
        if (q) window.location.href = ctx + '/admin/pending-providers?category=${selectedCategory}&q=' + encodeURIComponent(q);
      }
    });
  }
})();
</script>
</body>
</html>
