<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Martial Arts Centres Management - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }
    .ma-actions { display: flex; gap: 6px; align-items: center; flex-wrap: wrap; }
    .ma-actions form { margin: 0; }
    .btn-approve { background: var(--ap-success); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; cursor: pointer; }
    .btn-reject, .btn-revoke { background: var(--ap-danger); color: #fff; border: 0; border-radius: 9px; padding: 7px 12px; font-size: 0.8rem; font-weight: 700; cursor: pointer; }
    .dv-more {
      width: 34px; height: 34px; border-radius: 9px; border: 1px solid var(--ap-border);
      background: #fff; color: var(--ap-muted); display: inline-flex; align-items: center; justify-content: center;
      text-decoration: none;
    }
    .dv-more:hover { color: var(--ap-accent); border-color: #FDA4AF; }
    .dv-bottom-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px; }
    .prog-line { font-size: 0.8rem; margin-bottom: 2px; }
    @media (max-width: 992px) { .dv-bottom-grid { grid-template-columns: 1fr; } }
  </style>
</head>
<body class="ap-page">

<%-- Derive queue lists from existing model attributes only (no backend change) --%>
<c:set var="activeQueue" value="${empty param.queue ? 'pending' : param.queue}"/>
<c:set var="pendingCount" value="${fn:length(pendingCentres)}"/>
<c:set var="approvedCount" value="${fn:length(approvedCentres)}"/>
<c:set var="changesCount" value="0"/>
<c:forEach var="cItem" items="${pendingCentres}">
  <c:if test="${cItem.centreProfileStatus == 'CHANGES_REQUESTED'}">
    <c:set var="changesCount" value="${changesCount + 1}"/>
  </c:if>
</c:forEach>
<c:set var="totalCentres" value="${pendingCount + approvedCount}"/>

<c:choose>
  <c:when test="${activeQueue == 'approved'}"><c:set var="activeList" value="${approvedCentres}"/></c:when>
  <c:when test="${activeQueue == 'changes'}">
    <%-- filtered in loop below via changesOnly flag --%>
    <c:set var="activeList" value="${pendingCentres}"/>
    <c:set var="changesOnly" value="true"/>
  </c:when>
  <c:otherwise>
    <c:set var="activeList" value="${pendingCentres}"/>
    <c:set var="changesOnly" value="false"/>
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
        <a href="${pageContext.request.contextPath}/admin/martialManagement">Martial Arts Centres</a>
        <span class="sep">&gt;</span>
        <span>
          <c:choose>
            <c:when test="${activeQueue == 'changes'}">Changes Requested</c:when>
            <c:when test="${activeQueue == 'approved'}">Approved Centres</c:when>
            <c:otherwise>Pending Centres</c:otherwise>
          </c:choose>
        </span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-fist-raised"></i></div>
        <div>
          <h1>Martial Arts Centres Management</h1>
          <p>Review partnership requests and manage approved training centres</p>
        </div>
      </div>

      <c:if test="${not empty message}">
        <div class="alert alert-info mb-3" style="border-radius:12px;"><i class="fas fa-info-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3" style="border-radius:12px;"><i class="fas fa-exclamation-triangle me-1"></i><c:out value="${error}"/></div>
      </c:if>

      <div class="ap-stats" style="grid-template-columns: repeat(4, minmax(0, 1fr));">
        <div class="ap-stat amber">
          <div class="ico"><i class="fas fa-clock"></i></div>
          <div class="val">${pendingCount}</div>
          <div class="lbl">Pending Requests</div>
          <div class="sub">Awaiting review</div>
        </div>
        <div class="ap-stat purple">
          <div class="ico"><i class="fas fa-edit"></i></div>
          <div class="val">${changesCount}</div>
          <div class="lbl">Changes Requested</div>
          <div class="sub">In pending queue</div>
        </div>
        <div class="ap-stat green">
          <div class="ico"><i class="fas fa-check-circle"></i></div>
          <div class="val">${approvedCount}</div>
          <div class="lbl">Approved Centres</div>
          <div class="sub">Live on platform</div>
        </div>
        <div class="ap-stat neutral">
          <div class="ico"><i class="fas fa-building"></i></div>
          <div class="val">${totalCentres}</div>
          <div class="lbl">Total Centres</div>
          <div class="sub">Pending + approved</div>
        </div>
      </div>

      <form method="get" action="${pageContext.request.contextPath}/admin/martialManagement" class="ap-filter-row" id="maFilterForm">
        <div class="grow">
          <input type="text" id="maSearchInput" name="q" class="ap-input"
                 placeholder="Search centre name, email, phone, location..."
                 value="${fn:escapeXml(param.q)}">
        </div>
        <div style="min-width:180px;">
          <select name="queue" class="ap-select" id="maQueueSelect" onchange="this.form.submit()">
            <option value="pending" ${activeQueue == 'pending' ? 'selected' : ''}>Pending queue</option>
            <option value="changes" ${activeQueue == 'changes' ? 'selected' : ''}>Changes requested</option>
            <option value="approved" ${activeQueue == 'approved' ? 'selected' : ''}>Approved</option>
          </select>
        </div>
        <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i> Search / Filter</button>
        <a href="${pageContext.request.contextPath}/admin/martialManagement" class="ap-btn ap-btn-ghost"><i class="fas fa-times"></i> Clear</a>
      </form>

      <div class="ap-split">
        <section class="ap-panel">
          <div class="ap-tabs">
            <a class="ap-tab ${activeQueue == 'pending' ? 'active' : ''}" href="?queue=pending">Pending (${pendingCount})</a>
            <a class="ap-tab ${activeQueue == 'changes' ? 'active' : ''}" href="?queue=changes">Changes Requested (${changesCount})</a>
            <a class="ap-tab ${activeQueue == 'approved' ? 'active' : ''}" href="?queue=approved">Approved (${approvedCount})</a>
          </div>

          <c:if test="${not empty param.q}">
            <div style="padding:12px 16px;background:#F8FAFC;border-bottom:1px solid var(--ap-border);font-size:0.86rem;color:var(--ap-muted);">
              Filtering for "<strong><c:out value="${param.q}"/></strong>" (client-side match)
            </div>
          </c:if>

          <div class="ap-table-wrap">
            <table class="ap-table" id="centreQueueTable">
              <thead>
                <tr>
                  <th>Centre</th>
                  <c:choose>
                    <c:when test="${activeQueue == 'approved'}">
                      <th>Programs / Fees</th>
                      <th>Location</th>
                      <th>Certificate</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </c:when>
                    <c:otherwise>
                      <th>Status</th>
                      <th>Programs / Fees</th>
                      <th>Location</th>
                      <th>Contact</th>
                      <th>Certificate</th>
                      <th>Actions</th>
                    </c:otherwise>
                  </c:choose>
                </tr>
              </thead>
              <tbody>
              <c:set var="renderedRows" value="0"/>
              <c:choose>
                <c:when test="${not empty activeList}">
                  <c:forEach var="centre" items="${activeList}" varStatus="st">
                    <c:set var="stKey" value="${centre.centreProfileStatus}"/>
                    <c:set var="includeRow" value="true"/>
                    <c:if test="${changesOnly && stKey != 'CHANGES_REQUESTED'}"><c:set var="includeRow" value="false"/></c:if>
                    <c:if test="${!changesOnly && activeQueue == 'pending' && stKey == 'CHANGES_REQUESTED'}">
                      <%-- keep changes rows visible in pending queue too (like doctor pending includes incomplete) --%>
                    </c:if>

                    <c:if test="${includeRow}">
                      <c:set var="renderedRows" value="${renderedRows + 1}"/>
                      <c:set var="photo" value="${centre.profilePhoto}"/>
                      <c:set var="pct" value="${centre.profileCompletionPct != null ? centre.profileCompletionPct : 0}"/>
                      <c:set var="certOk" value="${not empty centre.trainerCertificatePath}"/>
                      <c:set var="photoOk" value="${not empty photo}"/>
                      <c:set var="progText" value=""/>
                      <c:forEach var="type" items="${centre.martialArtsTypes}" varStatus="ts">
                        <c:if test="${ts.first}"><c:set var="progText" value="${type.name}"/></c:if>
                      </c:forEach>
                      <c:if test="${empty progText}">
                        <c:forEach var="batch" items="${centre.batches}" varStatus="bs">
                          <c:if test="${bs.first}"><c:set var="progText" value="${batch.name}"/></c:if>
                        </c:forEach>
                      </c:if>
                      <c:set var="feeText" value=""/>
                      <c:forEach var="type" items="${centre.martialArtsTypes}" varStatus="ts">
                        <c:if test="${ts.first}"><c:set var="feeText" value="₹${type.cost}"/></c:if>
                      </c:forEach>

                      <c:set var="statusAttr" value="${stKey}"/>
                      <c:if test="${empty statusAttr}">
                        <c:choose>
                          <c:when test="${activeQueue == 'approved'}"><c:set var="statusAttr" value="APPROVED"/></c:when>
                          <c:otherwise><c:set var="statusAttr" value="PENDING"/></c:otherwise>
                        </c:choose>
                      </c:if>
                      <tr class="centre-row ${renderedRows == 1 ? 'selected' : ''}"
                          data-id="${centre.id}"
                          data-name="<c:out value='${centre.name}'/>"
                          data-email="<c:out value='${centre.email}'/>"
                          data-phone="<c:out value='${centre.phoneNumber}'/>"
                          data-loc="<c:out value='${centre.location}'/>"
                          data-status="<c:out value='${statusAttr}'/>"
                          data-pct="${pct}"
                          data-photo="<c:out value='${photo}'/>"
                          data-photo-ok="${photoOk ? '1' : '0'}"
                          data-cert="${certOk ? '1' : '0'}"
                          data-prog="<c:out value='${progText}'/>"
                          data-fee="<c:out value='${feeText}'/>"
                          data-note="<c:out value='${centre.changesRequestedNote}'/>"
                          data-search="<c:out value='${centre.name} ${centre.email} ${centre.phoneNumber} ${centre.location} ${centre.city} ${centre.contactPerson}'/>"
                          data-approved="${activeQueue == 'approved' ? '1' : '0'}">
                        <td>
                          <div class="ap-doc">
                            <span class="av">
                              <c:choose>
                                <c:when test="${photoOk}">
                                  <img src="${pageContext.request.contextPath}${photo}" alt="">
                                </c:when>
                                <c:otherwise><i class="fas fa-building" style="font-size:0.85rem;"></i></c:otherwise>
                              </c:choose>
                            </span>
                            <span style="min-width:0;">
                              <div class="nm" title="<c:out value='${centre.name}'/>"><c:out value="${centre.name}"/></div>
                              <div class="meta" title="<c:out value='${centre.email}'/>"><c:out value="${centre.email}"/></div>
                            </span>
                          </div>
                        </td>

                        <c:choose>
                          <c:when test="${activeQueue == 'approved'}">
                            <td>
                              <c:set var="hasTypes" value="${false}"/>
                              <c:forEach var="type" items="${centre.martialArtsTypes}">
                                <c:set var="hasTypes" value="${true}"/>
                                <div class="prog-line"><strong><c:out value="${type.name}"/></strong> - ₹${type.cost}</div>
                              </c:forEach>
                              <c:if test="${!hasTypes}"><span class="ap-muted">No programs yet</span></c:if>
                            </td>
                            <td><span class="ap-clip"><c:out value="${empty centre.location ? '-' : centre.location}"/></span></td>
                            <td>
                              <c:choose>
                                <c:when test="${certOk}">
                                  <a class="ap-btn-view" target="_blank" href="${pageContext.request.contextPath}${centre.trainerCertificatePath}" onclick="event.stopPropagation();"><i class="fas fa-file-contract"></i> View</a>
                                </c:when>
                                <c:otherwise><span class="ap-muted">Optional</span></c:otherwise>
                              </c:choose>
                            </td>
                            <td><span class="ap-badge ap-badge-approved">APPROVED</span></td>
                            <td onclick="event.stopPropagation();">
                              <div class="ma-actions">
                                <a class="ap-btn-view" href="${pageContext.request.contextPath}/centres/about/${centre.id}"><i class="fas fa-eye"></i> View</a>
                                <a class="dv-more" href="${pageContext.request.contextPath}/centres/about/${centre.id}" title="Profile"><i class="fas fa-ellipsis-v"></i></a>
                                <form action="${pageContext.request.contextPath}/admin/reject/${centre.id}" method="post">
                                  <button type="submit" class="btn-revoke" onclick="return confirm('Are you sure you want to revoke approval for this centre?');">
                                    <i class="fas fa-ban"></i> Revoke
                                  </button>
                                </form>
                              </div>
                            </td>
                          </c:when>
                          <c:otherwise>
                            <td>
                              <c:choose>
                                <c:when test="${stKey == 'PENDING_ADMIN_APPROVAL'}"><span class="ap-badge ap-badge-pending">PENDING</span></c:when>
                                <c:when test="${stKey == 'READY_FOR_VERIFICATION'}"><span class="ap-badge ap-badge-reverify">READY</span></c:when>
                                <c:when test="${stKey == 'CHANGES_REQUESTED'}"><span class="ap-badge ap-badge-changes">CHANGES_REQUESTED</span></c:when>
                                <c:when test="${stKey == 'PROFILE_INCOMPLETE' || stKey == 'REGISTERED'}"><span class="ap-badge ap-badge-incomplete">PROFILE_INCOMPLETE</span></c:when>
                                <c:otherwise><span class="ap-badge ap-badge-pending"><c:out value="${empty stKey ? 'PENDING' : stKey}"/></span></c:otherwise>
                              </c:choose>
                              <div class="ap-muted" style="font-size:0.78rem;margin-top:4px;">${pct}% complete</div>
                            </td>
                            <td>
                              <c:set var="hasTypes" value="${false}"/>
                              <c:forEach var="type" items="${centre.martialArtsTypes}">
                                <c:set var="hasTypes" value="${true}"/>
                                <div class="prog-line"><strong><c:out value="${type.name}"/></strong> - ₹${type.cost}</div>
                              </c:forEach>
                              <c:forEach var="batch" items="${centre.batches}">
                                <c:set var="hasTypes" value="${true}"/>
                                <div class="prog-line">
                                  <strong><c:out value="${batch.name}"/></strong>
                                  <c:if test="${not empty batch.style}"> (<c:out value="${batch.style}"/>)</c:if>
                                  <c:if test="${batch.fee != null}"> - ₹${batch.fee}</c:if>
                                </div>
                              </c:forEach>
                              <c:if test="${!hasTypes}"><span class="ap-muted">No programs yet</span></c:if>
                            </td>
                            <td><span class="ap-clip"><c:out value="${empty centre.location ? '-' : centre.location}"/></span></td>
                            <td>
                              <div><c:out value="${empty centre.phoneNumber ? '-' : centre.phoneNumber}"/></div>
                              <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${centre.contactPerson}"/></div>
                            </td>
                            <td>
                              <c:choose>
                                <c:when test="${certOk}">
                                  <a class="ap-btn-view" target="_blank" href="${pageContext.request.contextPath}${centre.trainerCertificatePath}" onclick="event.stopPropagation();"><i class="fas fa-file-contract"></i> View</a>
                                </c:when>
                                <c:otherwise><span class="ap-muted">Optional</span></c:otherwise>
                              </c:choose>
                            </td>
                            <td onclick="event.stopPropagation();">
                              <div class="ma-actions">
                                <a class="ap-btn-view" href="${pageContext.request.contextPath}/centres/about/${centre.id}"><i class="fas fa-eye"></i> View</a>
                                <a class="dv-more" href="${pageContext.request.contextPath}/centres/about/${centre.id}" title="More"><i class="fas fa-ellipsis-v"></i></a>
                                <form action="${pageContext.request.contextPath}/admin/approve/${centre.id}" method="post">
                                  <button type="submit" class="btn-approve"><i class="fas fa-check"></i> Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/reject/${centre.id}" method="post"
                                      onsubmit="return confirm('Reject this trainer/centre registration?');">
                                  <button type="submit" class="btn-reject"><i class="fas fa-times"></i> Reject</button>
                                </form>
                              </div>
                            </td>
                          </c:otherwise>
                        </c:choose>
                      </tr>
                    </c:if>
                  </c:forEach>
                  <c:if test="${renderedRows == 0}">
                    <tr>
                      <td colspan="7"><div class="ap-empty"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No centres in this queue.</div></td>
                    </tr>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="7"><div class="ap-empty"><i class="fas fa-inbox fa-2x mb-2 d-block" style="opacity:.35;"></i>No centres in this queue.</div></td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </section>

        <aside class="ap-panel ap-preview" id="centrePreview">
          <div class="ap-panel-bd">
            <div id="previewEmpty" class="ap-empty" style="display:none;">Select a centre to preview</div>
            <div id="previewBody">
              <div class="hero">
                <span class="av" id="pvAv">C</span>
                <div style="min-width:0;">
                  <h3 id="pvName">-</h3>
                  <div style="margin:6px 0;"><span class="ap-badge ap-badge-pending" id="pvStatus">PENDING</span></div>
                  <div class="line" id="pvEmail">-</div>
                  <div class="line" id="pvPhone">-</div>
                  <div class="line" id="pvLoc">-</div>
                </div>
              </div>

              <div class="ap-progress-label">
                <span>Profile Completion</span>
                <span id="pvPctLabel">0%</span>
              </div>
              <div class="ap-progress"><span id="pvPctBar" style="width:0%"></span></div>

              <div style="font-size:0.78rem;font-weight:700;margin-bottom:8px;color:var(--ap-muted);">PROGRAMS</div>
              <div class="ap-doc-list" style="margin-bottom:12px;">
                <div class="ap-doc-item">
                  <span id="pvProg">Not provided</span>
                  <span id="pvFee" class="ap-muted">-</span>
                </div>
              </div>

              <div style="font-size:0.78rem;font-weight:700;margin-bottom:8px;color:var(--ap-muted);">CERTIFICATES</div>
              <div class="ap-doc-list">
                <div class="ap-doc-item"><span>Trainer Certificate</span><span id="pvCert" class="st-miss">Optional</span></div>
                <div class="ap-doc-item"><span>Profile Photo</span><span id="pvDocPhoto" class="st-miss">Not uploaded</span></div>
              </div>

              <div id="pvNoteWrap" style="display:none;margin:10px 0 12px;padding:10px 12px;border-radius:10px;background:#FFFBEB;border:1px solid #FDE68A;font-size:0.82rem;">
                <strong>Changes note:</strong> <span id="pvNote"></span>
              </div>

              <c:set var="firstPreviewId" value=""/>
              <c:forEach var="c0" items="${activeList}">
                <c:if test="${empty firstPreviewId}">
                  <c:choose>
                    <c:when test="${changesOnly && c0.centreProfileStatus != 'CHANGES_REQUESTED'}"></c:when>
                    <c:otherwise><c:set var="firstPreviewId" value="${c0.id}"/></c:otherwise>
                  </c:choose>
                </c:if>
              </c:forEach>
              <c:choose>
                <c:when test="${not empty firstPreviewId}">
                  <a id="pvReview" class="ap-btn ap-btn-primary" style="width:100%;justify-content:center;"
                     href="${pageContext.request.contextPath}/centres/about/${firstPreviewId}">
                    Review Application <i class="fas fa-arrow-right"></i>
                  </a>
                  <a id="pvViewAll" class="ap-btn ap-btn-ghost" style="width:100%;justify-content:center;margin-top:8px;"
                     href="${pageContext.request.contextPath}/centres/about/${firstPreviewId}">
                    View full profile
                  </a>
                </c:when>
                <c:otherwise>
                  <a id="pvReview" class="ap-btn ap-btn-primary" style="width:100%;justify-content:center;" href="#">
                    Review Application <i class="fas fa-arrow-right"></i>
                  </a>
                  <a id="pvViewAll" class="ap-btn ap-btn-ghost" style="width:100%;justify-content:center;margin-top:8px;" href="#">
                    View full profile
                  </a>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </aside>
      </div>

      <div class="dv-bottom-grid">
        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Changes Requested (${changesCount})</h2>
            <a href="?queue=changes" style="color:var(--ap-accent);font-size:0.82rem;font-weight:700;text-decoration:none;">View all</a>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Centre</th><th>Reason</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <c:set var="chgShown" value="0"/>
                <c:forEach var="centre" items="${pendingCentres}">
                  <c:if test="${centre.centreProfileStatus == 'CHANGES_REQUESTED' && chgShown < 5}">
                    <c:set var="chgShown" value="${chgShown + 1}"/>
                    <tr>
                      <td>
                        <div style="font-weight:700;"><c:out value="${centre.name}"/></div>
                        <div class="ap-muted" style="font-size:0.78rem;"><c:out value="${centre.email}"/></div>
                      </td>
                      <td><span class="ap-clip" style="max-width:220px;" title="<c:out value='${centre.changesRequestedNote}'/>"><c:out value="${not empty centre.changesRequestedNote ? centre.changesRequestedNote : '-'}"/></span></td>
                      <td><a class="ap-btn-view" href="${pageContext.request.contextPath}/centres/about/${centre.id}">Review</a></td>
                    </tr>
                  </c:if>
                </c:forEach>
                <c:if test="${chgShown == 0}">
                  <tr><td colspan="3"><div class="ap-empty">No changes requested.</div></td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </section>

        <section class="ap-panel">
          <div class="ap-panel-hd">
            <h2>Pending Re-verification (0)</h2>
          </div>
          <div class="ap-table-wrap">
            <table class="ap-table" style="min-width:520px;">
              <thead>
                <tr><th>Centre</th><th>Status</th><th>Actions</th></tr>
              </thead>
              <tbody>
                <tr><td colspan="3"><div class="ap-empty">No re-verification requests.</div></td></tr>
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
  var qParam = '${fn:escapeXml(param.q)}'.toLowerCase();
  var rows = Array.prototype.slice.call(document.querySelectorAll('.centre-row'));

  function setDoc(el, ok, optional) {
    if (optional && !ok) {
      el.textContent = 'Optional';
      el.className = 'ap-muted';
      return;
    }
    el.textContent = ok ? 'Uploaded' : 'Not uploaded';
    el.className = ok ? 'st-ok' : 'st-miss';
  }

  function badgeClass(status) {
    if (status === 'APPROVED') return 'ap-badge ap-badge-approved';
    if (status === 'REJECTED') return 'ap-badge ap-badge-rejected';
    if (status === 'CHANGES_REQUESTED') return 'ap-badge ap-badge-changes';
    if (status === 'PROFILE_INCOMPLETE' || status === 'REGISTERED') return 'ap-badge ap-badge-incomplete';
    if (status === 'READY_FOR_VERIFICATION' || status === 'READY') return 'ap-badge ap-badge-reverify';
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
    var loc = row.getAttribute('data-loc') || '-';
    var status = row.getAttribute('data-status') || 'PENDING';
    var pct = parseInt(row.getAttribute('data-pct') || '0', 10) || 0;
    var photo = row.getAttribute('data-photo') || '';
    var id = row.getAttribute('data-id');
    var photoOk = row.getAttribute('data-photo-ok') === '1';
    var certOk = row.getAttribute('data-cert') === '1';
    var prog = row.getAttribute('data-prog') || '';
    var fee = row.getAttribute('data-fee') || '';
    var note = row.getAttribute('data-note') || '';

    document.getElementById('pvName').textContent = name;
    document.getElementById('pvEmail').textContent = email || 'Not provided';
    document.getElementById('pvPhone').textContent = phone || 'Not provided';
    document.getElementById('pvLoc').textContent = loc || 'Not provided';
    var st = document.getElementById('pvStatus');
    st.textContent = status;
    st.className = badgeClass(status);
    document.getElementById('pvPctLabel').textContent = pct + '%';
    document.getElementById('pvPctBar').style.width = Math.max(0, Math.min(100, pct)) + '%';
    document.getElementById('pvProg').textContent = prog || 'Not provided';
    document.getElementById('pvFee').textContent = fee || '-';

    var av = document.getElementById('pvAv');
    if (photoOk && photo) {
      var src = photo.indexOf('http') === 0 ? photo : (ctx + photo);
      av.innerHTML = '<img src="' + src + '" alt="">';
    } else {
      av.textContent = (name || 'C').charAt(0).toUpperCase();
    }

    setDoc(document.getElementById('pvCert'), certOk, true);
    setDoc(document.getElementById('pvDocPhoto'), photoOk, false);

    var noteWrap = document.getElementById('pvNoteWrap');
    if (note && note.trim()) {
      noteWrap.style.display = 'block';
      document.getElementById('pvNote').textContent = note;
    } else {
      noteWrap.style.display = 'none';
    }

    var href = ctx + '/centres/about/' + id;
    document.getElementById('pvReview').href = href;
    document.getElementById('pvViewAll').href = href;
  }

  function applySearchFilter() {
    var q = (document.getElementById('maSearchInput').value || qParam || '').trim().toLowerCase();
    var visible = [];
    rows.forEach(function (r) {
      var hay = (r.getAttribute('data-search') || '').toLowerCase();
      var show = !q || hay.indexOf(q) !== -1;
      r.style.display = show ? '' : 'none';
      if (show) visible.push(r);
    });
    return visible;
  }

  rows.forEach(function (row) {
    row.addEventListener('click', function () {
      rows.forEach(function (r) { r.classList.remove('selected'); });
      row.classList.add('selected');
      fillPreview(row);
    });
  });

  var visible = applySearchFilter();
  if (visible.length) {
    rows.forEach(function (r) { r.classList.remove('selected'); });
    visible[0].classList.add('selected');
    fillPreview(visible[0]);
  } else {
    fillPreview(null);
  }

  var form = document.getElementById('maFilterForm');
  if (form) {
    form.addEventListener('submit', function () {
      /* allow GET navigation with queue + q */
    });
  }

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
        document.getElementById('maSearchInput').value = hs.value;
        var vis = applySearchFilter();
        if (vis.length) {
          rows.forEach(function (r) { r.classList.remove('selected'); });
          vis[0].classList.add('selected');
          fillPreview(vis[0]);
        } else fillPreview(null);
      }
    });
  }
})();
</script>
</body>
</html>
