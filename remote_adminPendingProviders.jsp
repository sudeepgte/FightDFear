<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Service Partner Verification - Fight D Fear Admin</title>
  
  <!-- Bootstrap 5 & FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <!-- Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <!-- Shared Admin Portal Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  
  <style>
    * { box-sizing: border-box; }
    body.ap-page { margin: 0; font-family: 'Outfit', 'Poppins', system-ui, sans-serif; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; overflow: hidden; width: 100vw; max-width: 100%; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg, #F8FAFC); overflow-x: hidden; }

    /* Summary Stats Grid (6 Cards) */
    .ap-stats {
      display: grid;
      grid-template-columns: repeat(6, minmax(0, 1fr));
      gap: 16px;
      margin-bottom: 24px;
    }
    @media (max-width: 1280px) {
      .ap-stats { grid-template-columns: repeat(3, minmax(0, 1fr)); }
    }
    @media (max-width: 768px) {
      .ap-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }
    @media (max-width: 480px) {
      .ap-stats { grid-template-columns: 1fr; }
    }

    /* Actions styling - Martial Arts reference */
    .dv-actions, .ma-actions { display: flex; gap: 6px; align-items: center; flex-wrap: wrap; }
    .ma-actions form { margin: 0; }
    .btn-approve { background: var(--ap-success, #16A34A); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 5px; }
    .btn-approve:hover { background: #15803D; color: #fff; }
    .btn-reject, .btn-revoke { background: var(--ap-danger, #DC2626); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 5px; }
    .btn-reject:hover, .btn-revoke:hover { background: #B91C1C; color: #fff; }
    .dv-more {
      width: 34px; height: 34px; border-radius: 9px; border: 1px solid var(--ap-border, #E2E8F0);
      background: #fff; color: var(--ap-muted, #64748B); display: inline-flex; align-items: center; justify-content: center;
      text-decoration: none;
    }
    .dv-more:hover { color: var(--ap-accent, #F43F5E); border-color: #FDA4AF; }
    
    .btn-approve-sm {
      background-color: #16A34A;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }
    .btn-approve-sm:hover { background-color: #15803D; color: white; transform: translateY(-1px); }

    .btn-changes-sm {
      background-color: #8B5CF6;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }
    .btn-changes-sm:hover { background-color: #7C3AED; color: white; transform: translateY(-1px); }

    .btn-reject-sm {
      background-color: #DC2626;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }
    .btn-reject-sm:hover { background-color: #B91C1C; color: white; transform: translateY(-1px); }

    .btn-view-profile {
      background-color: #3B82F6;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      transition: all 0.2s;
      text-decoration: none !important;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
    }
    .btn-view-profile:hover { background-color: #2563EB; color: white; transform: translateY(-1px); }

    .btn-view-doc {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      background: #FFF1F3; 
      color: #F43F5E; 
      border: 1px solid #FFE4E6;
      padding: 6px 12px; 
      border-radius: 8px; 
      font-size: 0.8rem; 
      font-weight: 700;
      text-decoration: none !important; 
      transition: all 0.2s ease;
    }
    .btn-view-doc:hover { background: #F43F5E; color: #fff; border-color: #F43F5E; }

    /* Status Badges */
    .ap-badge-reverify { background: #DBEAFE; color: #1E40AF; }
    .ap-badge-changes { background: #F3E8FF; color: #6B21A8; }

    /* Interactive Row Hover */
    .provider-row { cursor: pointer; transition: background-color 0.15s ease; }
    .provider-row:hover { background-color: #FFF7F8 !important; }
    .provider-row.selected { background-color: #FFF1F3 !important; }

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

    /* Layout Structure */
    .ap-split { display: grid; grid-template-columns: 1fr 340px; gap: 20px; width: 100%; box-sizing: border-box; }
    @media (max-width: 1100px) {
      .ap-split { grid-template-columns: 1fr; }
    }
    .ap-panel { width: 100%; box-sizing: border-box; }
    .ap-table-wrap { width: 100%; overflow-x: auto; box-sizing: border-box; -webkit-overflow-scrolling: touch; }
    .ap-table { min-width: 780px; }

    /* Responsive Filter */
    @media (max-width: 992px) {
      .ap-main-inner { padding: 16px; width: 100%; box-sizing: border-box; overflow-x: hidden; }
      .ap-filter-row { flex-direction: row; flex-wrap: wrap; align-items: center; width: 100%; padding: 12px; box-sizing: border-box; gap: 10px; }
      .ap-filter-row .grow { flex: 1 1 100%; min-width: 100% !important; }
      .ap-filter-row > div:not(.grow) { flex: 1 1 45%; min-width: 0 !important; max-width: 50%; }
      .ap-filter-row .ap-input, .ap-filter-row .ap-select { width: 100%; max-width: 100%; box-sizing: border-box; }
      .ap-filter-row .ap-btn { flex: 1 1 auto; width: auto; justify-content: center; }
      .ap-tabs { flex-wrap: nowrap; overflow-x: auto; padding-bottom: 5px; -webkit-overflow-scrolling: touch; }
    }
  </style>
</head>
<body class="ap-page">

<c:set var="activeFilter" value="${empty activeFilter ? (empty param.filter ? 'pending' : param.filter) : activeFilter}"/>
<c:set var="pCount" value="${not empty pendingCount ? pendingCount : 0}"/>
<c:set var="rvCount" value="${not empty reverificationCount ? reverificationCount : 0}"/>
<c:set var="crCount" value="${not empty changesRequestedCount ? changesRequestedCount : 0}"/>
<c:set var="apCount" value="${not empty approvedCount ? approvedCount : 0}"/>
<c:set var="rjCount" value="${not empty rejectedCount ? rejectedCount : 0}"/>
<c:set var="totCount" value="${not empty totalPartnersCount ? totalPartnersCount : (pCount + rvCount + crCount + apCount + rjCount)}"/>

<!-- Sidebar Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="layout">
  <!-- Shared Navigation Sidebar -->
  <%@ include file="src/main/webapp/WEB-INF/views/globalAdminMenu.jsp" %>

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
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=&q=&filter=pending">Marketplace Providers</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeFilter == 'approved'}">Approved Partners</c:when>
            <c:when test="${activeFilter == 'reverification'}">Re-verification Queue</c:when>
            <c:when test="${activeFilter == 'changes_requested'}">Changes Requested</c:when>
            <c:when test="${activeFilter == 'rejected'}">Rejected Partners</c:when>
            <c:otherwise>Pending Verification</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <!-- Page Header -->
      <div class="ap-page-head">
        <div class="ap-page-ico">
          <i class="fas fa-store"></i>
        </div>
        <div>
          <h1>Service Partner Verification</h1>
          <p>Review provider registration applications, inspect credentials, and manage approval queues</p>
        </div>
      </div>

      <!-- Flash Messages -->
      <c:if test="${not empty message}">
        <div class="alert alert-info alert-dismissible fade show mb-3" style="border-radius:12px;" role="alert">
          <i class="fas fa-info-circle me-2"></i> <c:out value="${message}"/>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-3" style="border-radius:12px;" role="alert">
          <i class="fas fa-exclamation-triangle me-2"></i> <c:out value="${error}"/>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>

      <!-- 6 Statistic Cards Grid (Live Backend Counts) -->
      <div class="ap-stats">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pCount}</div>
          <div class="lbl">Pending</div>
          <div class="sub">Requires review</div>
        </div>
        <div class="ap-stat blue">
          <div class="ico"><i class="fas fa-sync"></i></div>
          <div class="val">${rvCount}</div>
          <div class="lbl">Re-verification</div>
          <div class="sub">Needs attention</div>
        </div>
        <div class="ap-stat purple">
          <div class="ico"><i class="fas fa-edit"></i></div>
          <div class="val">${crCount}</div>
          <div class="lbl">Changes Requested</div>
          <div class="sub">Awaiting response</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${apCount}</div>
          <div class="lbl">Approved</div>
          <div class="sub">Verified partners</div>
        </div>
        <div class="ap-stat rose">
          <div class="ico"><i class="fas fa-times-circle"></i></div>
          <div class="val">${rjCount}</div>
          <div class="lbl">Rejected</div>
          <div class="sub">Not approved</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-users"></i></div>
          <div class="val">${totCount}</div>
          <div class="lbl">Total Partners</div>
          <div class="sub">Across all queues</div>
        </div>
      </div>

      <!-- Horizontal Search and Filter Bar -->
      <form method="get" action="${pageContext.request.contextPath}/admin/pending-providers" class="ap-filter-row" id="providerFilterForm">
        <div class="grow">
          <input type="text" id="providerSearchInput" name="q" class="ap-input"
                 placeholder="Search by provider name, email, phone, category, location..."
                 value="<c:out value='${searchQuery}'/>">
        </div>
        <div style="min-width:200px;">
          <select name="category" class="ap-select" aria-label="Service Category">
            <option value="">All Categories</option>
            <c:forEach items="${providerCategories}" var="cat">
              <option value="${cat.name()}" ${selectedCategoryCode eq cat.name() ? 'selected' : ''}>
                ${cat.displayName}
              </option>
            </c:forEach>
          </select>
        </div>
        <div style="min-width:180px;">
          <select name="filter" class="ap-select" aria-label="Verification Queue">
            <option value="pending" ${activeFilter == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="reverification" ${activeFilter == 'reverification' ? 'selected' : ''}>Re-verification</option>
            <option value="changes_requested" ${activeFilter == 'changes_requested' ? 'selected' : ''}>Changes requested</option>
            <option value="approved" ${activeFilter == 'approved' ? 'selected' : ''}>Approved</option>
            <option value="rejected" ${activeFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
            <option value="all" ${activeFilter == 'all' ? 'selected' : ''}>All (search scope)</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=&q=&filter=pending" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
      </form>

      <!-- Main Split Section (Table + Live Preview Panel) -->
      <div class="ap-split">
        <section class="ap-panel">
          <!-- Status Tabs -->
          <div class="ap-tabs">
            <a class="ap-tab ${activeFilter == 'pending' ? 'active' : ''}" 
               href="?category=${selectedCategoryCode}&q=${fn:escapeXml(searchQuery)}&filter=pending">
               Pending (${pCount})
            </a>
            <a class="ap-tab ${activeFilter == 'reverification' ? 'active' : ''}" 
               href="?category=${selectedCategoryCode}&q=${fn:escapeXml(searchQuery)}&filter=reverification">
               Re-verification (${rvCount})
            </a>
            <a class="ap-tab ${activeFilter == 'changes_requested' ? 'active' : ''}" 
               href="?category=${selectedCategoryCode}&q=${fn:escapeXml(searchQuery)}&filter=changes_requested">
               Changes Requested (${crCount})
            </a>
            <a class="ap-tab ${activeFilter == 'approved' ? 'active' : ''}" 
               href="?category=${selectedCategoryCode}&q=${fn:escapeXml(searchQuery)}&filter=approved">
               Approved (${apCount})
            </a>
            <a class="ap-tab ${activeFilter == 'rejected' ? 'active' : ''}" 
               href="?category=${selectedCategoryCode}&q=${fn:escapeXml(searchQuery)}&filter=rejected">
               Rejected (${rjCount})
            </a>
          </div>

          <c:if test="${not empty searchQuery}">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Showing results for "<strong><c:out value="${searchQuery}"/></strong>"
            </div>
          </c:if>

          <!-- Desktop Table View -->
          <div class="ap-table-wrap d-none d-md-block">
            <table class="ap-table" id="providerQueueTable">
              <thead>
                <tr>
                  <th>Provider</th>
                  <th>Service Category</th>
                  <th>Location</th>
                  <th>Contact Details</th>
                  <th>Profile Completion</th>
                  <th>Submitted Date</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty providers}">
                  <c:forEach var="p" items="${providers}" varStatus="st">
                    <c:set var="vStat" value="${p.verificationStatus}"/>
                    <c:set var="pStat" value="${p.partnerProfileStatus}"/>
                    <c:set var="catDisplay" value="${not empty p.category ? p.category.displayName : '-'}"/>
                    <c:set var="locDisplay" value="${not empty p.locationText ? p.locationText : (not empty p.city ? p.city : '-')}"/>
                    <c:set var="pct" value="${not empty p.profileCompletionPct ? p.profileCompletionPct : 0}"/>
                    
                    <tr class="provider-row ${st.first ? 'selected' : ''}"
                        data-id="${p.id}"
                        data-name="<c:out value='${p.fullName}'/>"
                        data-email="<c:out value='${p.email}'/>"
                        data-phone="<c:out value='${p.phone}'/>"
                        data-category="<c:out value='${catDisplay}'/>"
                        data-business="<c:out value='${p.businessName}'/>"
                        data-location="<c:out value='${locDisplay}'/>"
                        data-pct="${pct}"
                        data-bio="<c:out value='${not empty p.description ? p.description : p.bio}'/>"
                        data-qualification="<c:out value='${p.qualification}'/>"
                        data-experience="<c:out value='${not empty p.experience ? p.experience : (not empty p.experienceYears ? p.experienceYears.toString().concat(" Years") : "-")}'/>"
                        data-fee="<c:out value='${not empty p.consultationFee ? "₹".concat(p.consultationFee.toString()) : "-"}'/>"
                        data-days="<c:out value='${not empty p.availableDays ? p.availableDays : p.openDays}'/>"
                        data-hours="<c:out value='${not empty p.workingHoursFrom ? p.workingHoursFrom.concat(" - ").concat(p.workingHoursTo) : "-"}'/>"
                        data-languages="<c:out value='${not empty p.languagesSpoken ? p.languagesSpoken : p.languages}'/>"
                        data-submitted="<c:out value='${not empty p.submittedForVerificationAt ? p.submittedForVerificationAt : "-"}'/>"
                        data-iddoc="<c:out value='${p.identityDocumentPath}'/>"
                        data-photo="<c:out value='${p.profilePhoto}'/>"
                        data-changesnote="<c:out value='${p.changesRequestedNote}'/>"
                        data-rejectionreason="<c:out value='${p.rejectionReason}'/>"
                        data-reviewedby="<c:out value='${p.reviewedByAdminName}'/>"
                        data-reviewedat="<c:out value='${p.reviewedAt}'/>"
                        data-status="<c:out value='${vStat}'/>"
                        data-pstatus="<c:out value='${pStat}'/>">
                      <td>
                        <div class="ap-doc">
                          <span class="av">
                            <c:choose>
                              <c:when test="${not empty p.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${p.profilePhoto}" alt="">
                              </c:when>
                              <c:otherwise>${not empty p.fullName ? fn:substring(p.fullName,0,1) : 'P'}</c:otherwise>
                            </c:choose>
                          </span>
                          <span style="min-width:0;">
                            <div class="nm" title="<c:out value='${p.fullName}'/>"><c:out value="${p.fullName}"/></div>
                            <div class="meta" title="<c:out value='${p.email}'/>"><c:out value="${p.email}"/></div>
                          </span>
                        </div>
                      </td>
                      <td>
                        <span class="badge bg-light text-dark border"><c:out value="${catDisplay}"/></span>
                        <c:if test="${not empty p.businessName}">
                          <div class="ap-muted" style="font-size:0.75rem;margin-top:2px;"><c:out value="${p.businessName}"/></div>
                        </c:if>
                      </td>
                      <td>
                        <span class="ap-clip" title="<c:out value='${locDisplay}'/>"><c:out value="${locDisplay}"/></span>
                      </td>
                      <td>
                        <div style="font-size:0.84rem;font-weight:600;"><c:out value="${not empty p.phone ? p.phone : '-'}"/></div>
                      </td>
                      <td>
                        <div style="display:flex;align-items:center;gap:6px;">
                          <div class="progress" style="height:6px;width:60px;background:#E2E8F0;border-radius:4px;">
                            <div class="progress-bar ${pct == 100 ? 'bg-success' : 'bg-primary'}" style="width:${pct}%;"></div>
                          </div>
                          <span style="font-size:0.78rem;font-weight:700;">${pct}%</span>
                        </div>
                      </td>
                      <td>
                        <div class="ap-muted" style="font-size:0.8rem;">
                          <c:choose>
                            <c:when test="${not empty p.submittedForVerificationAt}">${fn:substring(p.submittedForVerificationAt.toString(), 0, 10)}</c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${vStat == 'VERIFIED' || vStat == 'APPROVED' || pStat == 'APPROVED'}">
                            <span class="ap-badge ap-badge-approved">APPROVED</span>
                          </c:when>
                          <c:when test="${vStat == 'RE_VERIFICATION' || pStat == 'READY_FOR_VERIFICATION'}">
                            <span class="ap-badge ap-badge-reverify">RE-VERIFICATION</span>
                          </c:when>
                          <c:when test="${vStat == 'CHANGES_REQUESTED' || pStat == 'CHANGES_REQUESTED'}">
                            <span class="ap-badge ap-badge-changes">CHANGES_REQUESTED</span>
                          </c:when>
                          <c:when test="${vStat == 'REJECTED' || pStat == 'REJECTED'}">
                            <span class="ap-badge ap-badge-rejected">REJECTED</span>
                          </c:when>
                          <c:otherwise>
                            <span class="ap-badge ap-badge-pending">PENDING</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td onclick="event.stopPropagation();">
                        <div class="ma-actions">
                          <a class="ap-btn-view" href="${pageContext.request.contextPath}/admin/provider/view/${p.id}?category=${selectedCategoryCode}&filter=${activeFilter}&q=${fn:escapeXml(searchQuery)}"><i class="fas fa-eye"></i> View</a>
                          <a class="dv-more" href="${pageContext.request.contextPath}/admin/provider/view/${p.id}?category=${selectedCategoryCode}&filter=${activeFilter}&q=${fn:escapeXml(searchQuery)}" title="Profile"><i class="fas fa-ellipsis-v"></i></a>
                          <c:choose>
                            <c:when test="${vStat == 'VERIFIED' || vStat == 'APPROVED' || pStat == 'APPROVED'}">
                              <button type="button" class="btn-revoke" onclick="openRejectModal('${p.id}', '${fn:escapeXml(p.fullName)}')">
                                <i class="fas fa-ban"></i> Revoke
                              </button>
                            </c:when>
                            <c:otherwise>
                              <button type="button" class="btn-approve" onclick="openApproveModal('${p.id}', '${fn:escapeXml(p.fullName)}')">
                                <i class="fas fa-check"></i> Approve
                              </button>
                              <button type="button" class="btn-reject" onclick="openRejectModal('${p.id}', '${fn:escapeXml(p.fullName)}')">
                                <i class="fas fa-times"></i> Reject
                              </button>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8">
                      <div class="ap-empty py-5 text-center">
                        <i class="fas fa-inbox fa-2x mb-2 d-block text-secondary" style="opacity:.35;"></i>
                        No service partners found in this queue.
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
              <c:when test="${not empty providers}">
                <c:forEach var="p" items="${providers}">
                  <c:set var="vStat" value="${p.verificationStatus}"/>
                  <c:set var="pStat" value="${p.partnerProfileStatus}"/>
                  <div class="fl-mobile-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                      <h6 class="fw-bold mb-0 text-dark" style="font-size:1rem;"><c:out value="${p.fullName}"/></h6>
                      <c:choose>
                        <c:when test="${vStat == 'VERIFIED' || vStat == 'APPROVED' || pStat == 'APPROVED'}">
                          <span class="ap-badge ap-badge-approved">APPROVED</span>
                        </c:when>
                        <c:when test="${vStat == 'RE_VERIFICATION' || pStat == 'READY_FOR_VERIFICATION'}">
                          <span class="ap-badge ap-badge-reverify">RE-VERIFICATION</span>
                        </c:when>
                        <c:when test="${vStat == 'CHANGES_REQUESTED' || pStat == 'CHANGES_REQUESTED'}">
                          <span class="ap-badge ap-badge-changes">CHANGES_REQUESTED</span>
                        </c:when>
                        <c:when test="${vStat == 'REJECTED' || pStat == 'REJECTED'}">
                          <span class="ap-badge ap-badge-rejected">REJECTED</span>
                        </c:when>
                        <c:otherwise>
                          <span class="ap-badge ap-badge-pending">PENDING</span>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <div class="fl-mobile-label">Contact Details</div>
                    <div class="fl-mobile-val">
                      <i class="fas fa-envelope me-1 text-muted"></i> <c:out value="${p.email}"/><br>
                      <i class="fas fa-phone me-1 text-muted"></i> <c:out value="${p.phone}"/>
                    </div>

                    <div class="row g-2 mb-2">
                      <div class="col-6">
                        <div class="fl-mobile-label">Location</div>
                        <div class="fl-mobile-val mb-0"><c:out value="${not empty p.locationText ? p.locationText : '-'}"/></div>
                      </div>
                      <div class="col-6">
                        <div class="fl-mobile-label">Category</div>
                        <div class="fl-mobile-val mb-0"><span class="badge bg-light text-dark border"><c:out value="${not empty p.category ? p.category.displayName : '-'}"/></span></div>
                      </div>
                    </div>

                    <div class="p-2.5 mb-2 rounded bg-light border" style="font-size:0.84rem;">
                      <c:if test="${not empty p.businessName}"><div class="mb-1"><strong>Business:</strong> <c:out value="${p.businessName}"/></div></c:if>
                      <div class="mb-1"><strong>Profile Completion:</strong> ${not empty p.profileCompletionPct ? p.profileCompletionPct : 0}%</div>
                      <c:if test="${not empty p.qualification}"><div class="mb-1"><strong>Qualification:</strong> <c:out value="${p.qualification}"/></div></c:if>
                      <c:if test="${not empty p.experience}"><div class="mb-1"><strong>Experience:</strong> <c:out value="${p.experience}"/></div></c:if>
                      <c:if test="${not empty p.description}"><div class="mb-1"><strong>Bio:</strong> <c:out value="${p.description}"/></div></c:if>
                    </div>

                    <div class="d-flex align-items-center justify-content-between pt-2 border-top gap-2 flex-wrap">
                      <div>
                        <c:if test="${not empty p.identityDocumentPath && p.identityDocumentPath != 'web-pending'}">
                          <a href="${pageContext.request.contextPath}${p.identityDocumentPath}" target="_blank" class="btn-view-doc py-1 px-3">
                            <i class="fas fa-id-card me-1"></i> View ID
                          </a>
                        </c:if>
                      </div>

                      <div class="d-flex align-items-center gap-2">
                        <a class="btn-view-profile py-1 px-3" href="${pageContext.request.contextPath}/admin/providers/${p.id}/profile?category=${selectedCategoryCode}&filter=${activeFilter}&q=${fn:escapeXml(searchQuery)}" title="View Profile"><i class="fas fa-eye me-1"></i> View</a>
                        <c:if test="${vStat != 'VERIFIED' && vStat != 'APPROVED' && pStat != 'APPROVED'}">
                          <button class="btn-approve-sm py-1 px-3" type="button" onclick="openApproveModal('${p.id}', '${fn:escapeXml(p.fullName)}')"><i class="fas fa-check me-1"></i> Approve</button>
                        </c:if>
                        <button class="btn-changes-sm py-1 px-3" type="button" onclick="openChangesModal('${p.id}', '${fn:escapeXml(p.fullName)}')"><i class="fas fa-edit me-1"></i> Changes</button>
                        <c:if test="${vStat != 'REJECTED' && pStat != 'REJECTED'}">
                          <button class="btn-reject-sm py-1 px-3" type="button" onclick="openRejectModal('${p.id}', '${fn:escapeXml(p.fullName)}')"><i class="fas fa-times me-1"></i> Reject</button>
                        </c:if>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div class="ap-empty py-5 text-center">
                  <i class="fas fa-inbox fa-2x mb-2 d-block text-secondary" style="opacity:0.35;"></i>
                  <p class="mb-0 fw-medium text-secondary">No service partners found in this queue.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </section>

        <!-- Right Side Live Preview Panel -->
        <aside class="ap-panel ap-preview" id="providerPreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;padding:40px 10px;">Select a provider to preview</div>
            <div id="previewBody">
              <div class="hero mb-3">
                <span class="av" id="pvAv" style="width:48px;height:48px;font-size:1.2rem;background:#FFF1F3;color:#F43F5E;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;font-weight:700;">P</span>
                <div style="min-width:0;flex:1;">
                  <h3 id="pvName" style="font-size:1.1rem;font-weight:800;color:#0F172A;margin-bottom:2px;">-</h3>
                  <div style="margin:4px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line small text-muted" id="pvEmail">-</div>
                  <div class="line small text-muted" id="pvPhone">-</div>
                </div>
              </div>

              <div class="p-3 rounded bg-light border mb-3" style="font-size:0.84rem;">
                <div class="mb-1"><strong>Category:</strong> <span id="pvCategory">-</span></div>
                <div class="mb-1" id="pvBusinessWrap"><strong>Business:</strong> <span id="pvBusiness">-</span></div>
                <div class="mb-1"><strong>Location:</strong> <span id="pvLocation">-</span></div>
                <div class="mb-1"><strong>Profile Completion:</strong> <span id="pvPct">-</span></div>
                <div class="mb-1" id="pvQualWrap"><strong>Qualifications:</strong> <span id="pvQualification">-</span></div>
                <div class="mb-1" id="pvExpWrap"><strong>Experience / Fee:</strong> <span id="pvExpFee">-</span></div>
                <div class="mb-1" id="pvScheduleWrap"><strong>Availability:</strong> <span id="pvSchedule">-</span></div>
                <div class="mb-1" id="pvLangWrap"><strong>Languages:</strong> <span id="pvLanguages">-</span></div>
                <div class="mb-1"><strong>Submitted:</strong> <span id="pvSubmitted">-</span></div>
                <div><strong>Bio:</strong> <span id="pvBio">-</span></div>
              </div>

              <!-- Previous Feedback / Audit -->
              <div id="pvChangesAlert" class="alert alert-warning py-2 px-3 small mb-2" style="display:none;border-radius:8px;">
                <strong><i class="fas fa-edit me-1"></i> Changes Requested:</strong> <span id="pvChangesText"></span>
              </div>
              <div id="pvRejectAlert" class="alert alert-danger py-2 px-3 small mb-2" style="display:none;border-radius:8px;">
                <strong><i class="fas fa-times-circle me-1"></i> Rejection Reason:</strong> <span id="pvRejectText"></span>
              </div>
              <div id="pvReviewAudit" class="small text-muted mb-3" style="display:none;">
                <i class="fas fa-user-shield me-1"></i> Reviewed by <span id="pvReviewedBy">-</span> on <span id="pvReviewedAt">-</span>
              </div>

              <div class="mb-3" id="pvDocWrap">
                <a id="pvIdDocBtn" class="btn-view-doc w-100 justify-content-center py-2" href="#" target="_blank">
                  <i class="fas fa-id-card me-1"></i> View Identity Document
                </a>
              </div>

              <div class="d-flex flex-column gap-2">
                <a id="pvViewProfileBtn" class="btn-view-profile w-100 py-2 justify-content-center" href="#">
                  <i class="fas fa-eye me-1"></i> View Full Application
                </a>
                <div class="d-flex gap-2">
                  <button id="pvApproveBtn" type="button" class="btn-approve-sm flex-grow-1 py-2 justify-content-center" onclick="handlePvApprove()">
                    <i class="fas fa-check me-1"></i> Approve
                  </button>
                  <button id="pvChangesBtn" type="button" class="btn-changes-sm flex-grow-1 py-2 justify-content-center" onclick="handlePvChanges()">
                    <i class="fas fa-edit me-1"></i> Changes
                  </button>
                  <button id="pvRejectBtn" type="button" class="btn-reject-sm flex-grow-1 py-2 justify-content-center" onclick="handlePvReject()">
                    <i class="fas fa-times me-1"></i> Reject
                  </button>
                </div>
              </div>
            </div>
          </div>
        </aside>
      </div>

    </div>
  </main>
</div>

<!-- ================= MODALS FOR ADMIN ACTIONS ================= -->

<!-- 1. Approve Confirmation Modal -->
<div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 10px 30px rgba(0,0,0,0.1);">
      <form id="modalApproveForm" method="post" action="">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="category" value="${selectedCategoryCode}"/>
        <input type="hidden" name="filter" value="${activeFilter}"/>
        <input type="hidden" name="q" value="${fn:escapeXml(searchQuery)}"/>
        <div class="modal-header border-0 pb-0">
          <h5 class="modal-title fw-bold" id="approveModalLabel"><i class="fas fa-check-circle text-success me-2"></i> Confirm Provider Approval</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body py-3">
          <p class="mb-2">Are you sure you want to verify and approve provider <strong id="approveModalName"></strong>?</p>
          <div class="alert alert-success py-2 small mb-0">
            <i class="fas fa-info-circle me-1"></i> After approval, this provider will be visible on the public marketplace, authorized to publish services, and accept bookings.
          </div>
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold"><i class="fas fa-check me-1"></i> Approve &amp; Activate</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 2. Request Changes Modal -->
<div class="modal fade" id="changesModal" tabindex="-1" aria-labelledby="changesModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 10px 30px rgba(0,0,0,0.1);">
      <form id="modalChangesForm" method="post" action="" onsubmit="return validateChangesForm()">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="category" value="${selectedCategoryCode}"/>
        <input type="hidden" name="filter" value="${activeFilter}"/>
        <input type="hidden" name="q" value="${fn:escapeXml(searchQuery)}"/>
        <div class="modal-header border-0 pb-0">
          <h5 class="modal-title fw-bold" id="changesModalLabel"><i class="fas fa-edit text-purple me-2" style="color:#8B5CF6;"></i> Request Corrections / Updates</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body py-3">
          <p class="mb-2">Request corrections from <strong id="changesModalName"></strong>:</p>
          <div class="mb-3">
            <label for="changesModalNote" class="form-label fw-bold small">Explanation &amp; Required Changes *</label>
            <textarea class="form-control" id="changesModalNote" name="note" rows="3" placeholder="Explain clearly what the provider needs to update or supply..." required></textarea>
          </div>
          <div class="alert alert-warning py-2 small mb-0">
            <i class="fas fa-info-circle me-1"></i> The provider will receive this feedback upon login and be required to update their profile and resubmit for re-verification.
          </div>
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn rounded-pill px-4 fw-bold text-white" style="background:#8B5CF6;"><i class="fas fa-paper-plane me-1"></i> Submit Request</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 3. Reject Confirmation Modal -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:16px;border:none;box-shadow:0 10px 30px rgba(0,0,0,0.1);">
      <form id="modalRejectForm" method="post" action="" onsubmit="return validateRejectForm()">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="category" value="${selectedCategoryCode}"/>
        <input type="hidden" name="filter" value="${activeFilter}"/>
        <input type="hidden" name="q" value="${fn:escapeXml(searchQuery)}"/>
        <div class="modal-header border-0 pb-0">
          <h5 class="modal-title fw-bold text-danger" id="rejectModalLabel"><i class="fas fa-times-circle me-2"></i> Reject Provider Application</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body py-3">
          <p class="mb-2">Reject application for <strong id="rejectModalName"></strong>:</p>
          <div class="mb-3">
            <label for="rejectModalReason" class="form-label fw-bold small">Rejection Reason *</label>
            <textarea class="form-control" id="rejectModalReason" name="reason" rows="3" placeholder="Provide a meaningful reason for rejecting this application..." required></textarea>
          </div>
          <div class="alert alert-danger py-2 small mb-0">
            <i class="fas fa-exclamation-triangle me-1"></i> This will mark the application as Rejected and record your reviewer identity and timestamp.
          </div>
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold"><i class="fas fa-ban me-1"></i> Reject Application</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Interactive Selection Script -->
<script>
(function () {
  var ctx = '${pageContext.request.contextPath}';
  var rows = Array.prototype.slice.call(document.querySelectorAll('.provider-row'));
  var currentSelectedRow = null;

  function fillPreview(row) {
    if (!row) {
      document.getElementById('previewBody').style.display = 'none';
      document.getElementById('previewEmpty').style.display = 'block';
      currentSelectedRow = null;
      return;
    }
    currentSelectedRow = row;
    document.getElementById('previewBody').style.display = 'block';
    document.getElementById('previewEmpty').style.display = 'none';

    var id = row.getAttribute('data-id');
    var name = row.getAttribute('data-name') || '-';
    var email = row.getAttribute('data-email') || '-';
    var phone = row.getAttribute('data-phone') || '-';
    var category = row.getAttribute('data-category') || '-';
    var business = row.getAttribute('data-business') || '';
    var location = row.getAttribute('data-location') || '-';
    var pct = row.getAttribute('data-pct') || '0';
    var bio = row.getAttribute('data-bio') || '-';
    var qualification = row.getAttribute('data-qualification') || '';
    var experience = row.getAttribute('data-experience') || '';
    var fee = row.getAttribute('data-fee') || '';
    var days = row.getAttribute('data-days') || '';
    var hours = row.getAttribute('data-hours') || '';
    var languages = row.getAttribute('data-languages') || '';
    var submitted = row.getAttribute('data-submitted') || '-';
    var iddoc = row.getAttribute('data-iddoc') || '';
    var status = row.getAttribute('data-status') || 'PENDING';
    var pstatus = row.getAttribute('data-pstatus') || '';
    var changesNote = row.getAttribute('data-changesnote') || '';
    var rejectReason = row.getAttribute('data-rejectionreason') || '';
    var reviewedBy = row.getAttribute('data-reviewedby') || '';
    var reviewedAt = row.getAttribute('data-reviewedat') || '';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email;
    document.getElementById('pvPhone').textContent = phone;
    document.getElementById('pvCategory').textContent = category;
    document.getElementById('pvLocation').textContent = location;
    document.getElementById('pvPct').textContent = pct + '%';
    document.getElementById('pvSubmitted').textContent = submitted;
    document.getElementById('pvBio').textContent = bio;
    document.getElementById('pvAv').textContent = (name || 'P').charAt(0).toUpperCase();

    // Business
    var bWrap = document.getElementById('pvBusinessWrap');
    if (business && business.trim()) {
      bWrap.style.display = 'block';
      document.getElementById('pvBusiness').textContent = business;
    } else {
      bWrap.style.display = 'none';
    }

    // Qualification
    var qWrap = document.getElementById('pvQualWrap');
    if (qualification && qualification.trim()) {
      qWrap.style.display = 'block';
      document.getElementById('pvQualification').textContent = qualification;
    } else {
      qWrap.style.display = 'none';
    }

    // Experience / Fee
    var efWrap = document.getElementById('pvExpWrap');
    if ((experience && experience !== '-') || (fee && fee !== '-')) {
      efWrap.style.display = 'block';
      document.getElementById('pvExpFee').textContent = (experience || '-') + ' / ' + (fee || '-');
    } else {
      efWrap.style.display = 'none';
    }

    // Schedule
    var scWrap = document.getElementById('pvScheduleWrap');
    if ((days && days.trim()) || (hours && hours !== '-')) {
      scWrap.style.display = 'block';
      document.getElementById('pvSchedule').textContent = (days ? days + ' ' : '') + (hours && hours !== '-' ? '(' + hours + ')' : '');
    } else {
      scWrap.style.display = 'none';
    }

    // Languages
    var lgWrap = document.getElementById('pvLangWrap');
    if (languages && languages.trim()) {
      lgWrap.style.display = 'block';
      document.getElementById('pvLanguages').textContent = languages;
    } else {
      lgWrap.style.display = 'none';
    }

    // Status badge styling
    var stBadge = document.getElementById('pvStatus');
    stBadge.className = 'ap-badge';
    if (status === 'VERIFIED' || status === 'APPROVED' || pstatus === 'APPROVED') {
      stBadge.classList.add('ap-badge-approved');
      stBadge.textContent = 'APPROVED';
    } else if (status === 'RE_VERIFICATION' || pstatus === 'READY_FOR_VERIFICATION') {
      stBadge.classList.add('ap-badge-reverify');
      stBadge.textContent = 'RE-VERIFICATION';
    } else if (status === 'CHANGES_REQUESTED' || pstatus === 'CHANGES_REQUESTED') {
      stBadge.classList.add('ap-badge-changes');
      stBadge.textContent = 'CHANGES_REQUESTED';
    } else if (status === 'REJECTED' || pstatus === 'REJECTED') {
      stBadge.classList.add('ap-badge-rejected');
      stBadge.textContent = 'REJECTED';
    } else {
      stBadge.classList.add('ap-badge-pending');
      stBadge.textContent = 'PENDING';
    }

    // Feedback alerts
    var chAlert = document.getElementById('pvChangesAlert');
    if (changesNote && changesNote.trim()) {
      chAlert.style.display = 'block';
      document.getElementById('pvChangesText').textContent = changesNote;
    } else {
      chAlert.style.display = 'none';
    }

    var rjAlert = document.getElementById('pvRejectAlert');
    if (rejectReason && rejectReason.trim()) {
      rjAlert.style.display = 'block';
      document.getElementById('pvRejectText').textContent = rejectReason;
    } else {
      rjAlert.style.display = 'none';
    }

    // Review audit
    var rAudit = document.getElementById('pvReviewAudit');
    if (reviewedBy && reviewedBy.trim()) {
      rAudit.style.display = 'block';
      document.getElementById('pvReviewedBy').textContent = reviewedBy;
      document.getElementById('pvReviewedAt').textContent = reviewedAt || '';
    } else {
      rAudit.style.display = 'none';
    }

    // Doc link
    var docBtn = document.getElementById('pvIdDocBtn');
    if (iddoc && iddoc !== '' && iddoc !== 'web-pending') {
      docBtn.style.display = 'inline-flex';
      docBtn.href = ctx + iddoc;
    } else {
      docBtn.style.display = 'none';
    }

    // Action button visibility
    var isAppr = (status === 'VERIFIED' || status === 'APPROVED' || pstatus === 'APPROVED');
    var isRj = (status === 'REJECTED' || pstatus === 'REJECTED');
    document.getElementById('pvApproveBtn').style.display = isAppr ? 'none' : 'inline-flex';
    document.getElementById('pvRejectBtn').style.display = isRj ? 'none' : 'inline-flex';

    // View Profile link
    var catParam = '${selectedCategoryCode}';
    var fltParam = '${activeFilter}';
    var qParam = encodeURIComponent('${searchQuery}');
    document.getElementById('pvViewProfileBtn').href = ctx + '/admin/providers/' + id + '/profile?category=' + catParam + '&filter=' + fltParam + '&q=' + qParam;
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

  // Expose global modal triggers
  window.openApproveModal = function(id, name) {
    document.getElementById('approveModalName').textContent = name;
    document.getElementById('modalApproveForm').action = ctx + '/admin/providers/' + id + '/verify';
    var m = new bootstrap.Modal(document.getElementById('approveModal'));
    m.show();
  };

  window.openChangesModal = function(id, name) {
    document.getElementById('changesModalName').textContent = name;
    document.getElementById('changesModalNote').value = '';
    document.getElementById('modalChangesForm').action = ctx + '/admin/providers/' + id + '/request-changes';
    var m = new bootstrap.Modal(document.getElementById('changesModal'));
    m.show();
  };

  window.openRejectModal = function(id, name) {
    document.getElementById('rejectModalName').textContent = name;
    document.getElementById('rejectModalReason').value = '';
    document.getElementById('modalRejectForm').action = ctx + '/admin/providers/' + id + '/reject';
    var m = new bootstrap.Modal(document.getElementById('rejectModal'));
    m.show();
  };

  window.handlePvApprove = function() {
    if (currentSelectedRow) {
      openApproveModal(currentSelectedRow.getAttribute('data-id'), currentSelectedRow.getAttribute('data-name'));
    }
  };

  window.handlePvChanges = function() {
    if (currentSelectedRow) {
      openChangesModal(currentSelectedRow.getAttribute('data-id'), currentSelectedRow.getAttribute('data-name'));
    }
  };

  window.handlePvReject = function() {
    if (currentSelectedRow) {
      openRejectModal(currentSelectedRow.getAttribute('data-id'), currentSelectedRow.getAttribute('data-name'));
    }
  };

  window.validateChangesForm = function() {
    var val = document.getElementById('changesModalNote').value.trim();
    if (!val) {
      alert('Please provide instructions/notes explaining what changes are needed.');
      return false;
    }
    return true;
  };

  window.validateRejectForm = function() {
    var val = document.getElementById('rejectModalReason').value.trim();
    if (!val) {
      alert('Please provide a reason for rejecting the application.');
      return false;
    }
    return true;
  };

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
        if (q) window.location.href = ctx + '/admin/pending-providers?category=${selectedCategoryCode}&q=' + encodeURIComponent(q) + '&filter=${activeFilter}';
      }
    });
  }
})();
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
