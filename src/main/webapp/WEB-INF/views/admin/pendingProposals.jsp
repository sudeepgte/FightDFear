<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Proposal Verification - Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
  <style>
    body.ap-page { margin: 0; }
    .topbar { display: none !important; }
    .layout { display: flex; min-height: 100vh; }
    .main { flex: 1; min-width: 0; background: var(--ap-bg); }

    /* ─── Summary Stats ─── */
    .pv-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 24px; }
    @media (max-width: 900px) { .pv-stats { grid-template-columns: repeat(2, 1fr); } }
    .pv-stat { background: #fff; border: 1px solid var(--ap-border); border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; }
    .pv-stat .ico { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
    .pv-stat .val { font-size: 1.55rem; font-weight: 700; line-height: 1; }
    .pv-stat .lbl { font-size: 0.78rem; color: var(--ap-muted); margin-top: 2px; }
    .pv-stat.amber .ico { background: #FFF7ED; color: #F59E0B; }
    .pv-stat.green .ico  { background: #F0FDF4; color: #22C55E; }
    .pv-stat.blue .ico   { background: #EFF6FF; color: #3B82F6; }
    .pv-stat.rose .ico   { background: #FFF1F2; color: #F43F5E; }
    .pv-stat.purple .ico { background: #FAF5FF; color: #A855F7; }

    /* ─── Tabs ─── */
    .pv-tabs { display: flex; gap: 0; border-bottom: 2px solid var(--ap-border); margin-bottom: 22px; }
    .pv-tab { padding: 12px 22px; font-size: 0.9rem; font-weight: 600; color: var(--ap-muted); cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all .2s; display: flex; align-items: center; gap: 7px; white-space: nowrap; }
    .pv-tab:hover { color: var(--ap-accent); }
    .pv-tab.active { color: var(--ap-accent); border-bottom-color: var(--ap-accent); }
    .pv-tab .badge { background: var(--ap-accent); color: #fff; border-radius: 999px; font-size: 0.7rem; padding: 1px 7px; }
    .pv-tab.amber.active { color: #F59E0B; border-bottom-color: #F59E0B; }
    .pv-tab.amber .badge { background: #F59E0B; }
    .pv-tab.green.active { color: #22C55E; border-bottom-color: #22C55E; }
    .pv-tab.green .badge { background: #22C55E; }
    .pv-tab.blue.active  { color: #3B82F6; border-bottom-color: #3B82F6; }
    .pv-tab.blue .badge  { background: #3B82F6; }
    .pv-tab.escrow.active { color: #A855F7; border-bottom-color: #A855F7; }
    .pv-tab.escrow .badge { background: #A855F7; }

    /* ─── Panel ─── */
    .pv-panel { background: #fff; border: 1px solid var(--ap-border); border-radius: 14px; overflow: hidden; }
    .pv-panel-hd { padding: 16px 20px; border-bottom: 1px solid var(--ap-border); display: flex; align-items: center; justify-content: space-between; }
    .pv-panel-hd h2 { font-size: 1rem; font-weight: 700; margin: 0; }

    /* ─── Table ─── */
    .pv-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
    .pv-table thead tr { background: #F8FAFC; }
    .pv-table th { padding: 11px 14px; text-align: left; font-weight: 600; color: var(--ap-muted); font-size: 0.78rem; text-transform: uppercase; letter-spacing: .04em; border-bottom: 1px solid var(--ap-border); }
    .pv-table td { padding: 13px 14px; border-bottom: 1px solid #F1F5F9; vertical-align: middle; }
    .pv-table tbody tr:last-child td { border-bottom: none; }
    .pv-table tbody tr:hover td { background: #FAFBFF; }

    /* ─── Badges ─── */
    .badge-pending   { background: #FFF7ED; color: #C2410C; border: 1px solid #FED7AA; }
    .badge-verified  { background: #F0FDF4; color: #15803D; border: 1px solid #BBF7D0; }
    .badge-rejected  { background: #FFF1F2; color: #BE123C; border: 1px solid #FECDD3; }
    .badge-escrow    { background: #FAF5FF; color: #7E22CE; border: 1px solid #E9D5FF; }
    .badge-released  { background: #F0F9FF; color: #0369A1; border: 1px solid #BAE6FD; }
    .pv-badge { display: inline-block; padding: 3px 10px; border-radius: 999px; font-size: 0.73rem; font-weight: 600; }

    /* ─── Action Buttons ─── */
    .pv-btn { display: inline-flex; align-items: center; gap: 5px; padding: 6px 13px; border-radius: 8px; font-size: 0.8rem; font-weight: 600; cursor: pointer; border: none; text-decoration: none; transition: all .15s; }
    .pv-btn-approve { background: #F0FDF4; color: #15803D; border: 1px solid #BBF7D0; }
    .pv-btn-approve:hover { background: #DCFCE7; color: #15803D; }
    .pv-btn-reject  { background: #FFF1F2; color: #BE123C; border: 1px solid #FECDD3; }
    .pv-btn-reject:hover  { background: #FFE4E6; color: #BE123C; }
    .pv-btn-view    { background: #F8FAFC; color: #475569; border: 1px solid var(--ap-border); }
    .pv-btn-view:hover    { background: #F1F5F9; }
    .pv-btn-release { background: #FAF5FF; color: #7E22CE; border: 1px solid #E9D5FF; }
    .pv-btn-release:hover { background: #F3E8FF; }

    /* ─── Avatar ─── */
    .pv-avatar { width: 36px; height: 36px; border-radius: 10px; object-fit: cover; flex-shrink: 0; }
    .pv-avatar-ph { width: 36px; height: 36px; border-radius: 10px; background: var(--ap-accent-light, #FFF1F2); color: var(--ap-accent, #F43F5E); display: inline-flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem; flex-shrink: 0; }
    .pv-entity { display: flex; align-items: center; gap: 10px; }
    .pv-entity-name { font-weight: 600; color: #1E293B; }
    .pv-entity-sub  { font-size: 0.76rem; color: var(--ap-muted); }

    /* ─── Escrow info card ─── */
    .escrow-info { background: #FAF5FF; border: 1px solid #E9D5FF; border-radius: 12px; padding: 14px 18px; margin-bottom: 18px; display: flex; gap: 24px; flex-wrap: wrap; }
    .escrow-info .eitem { display: flex; flex-direction: column; }
    .escrow-info .eitem .eval { font-size: 1.25rem; font-weight: 700; color: #7E22CE; }
    .escrow-info .eitem .elbl { font-size: 0.75rem; color: #9333EA; margin-top: 2px; }

    /* ─── Empty state ─── */
    .pv-empty { text-align: center; padding: 44px 20px; color: var(--ap-muted); }
    .pv-empty i { font-size: 2.2rem; opacity: .3; display: block; margin-bottom: 10px; }

    /* ─── Search bar ─── */
    .pv-search-bar { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
    .pv-search-bar input { flex: 1; min-width: 200px; }
    .pv-search-bar select { min-width: 160px; }

    /* ─── Release modal ─── */
    .pv-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.45); z-index: 9999; align-items: center; justify-content: center; }
    .pv-modal-overlay.open { display: flex; }
    .pv-modal { background: #fff; border-radius: 18px; padding: 28px; width: 100%; max-width: 440px; box-shadow: 0 25px 60px rgba(0,0,0,.18); }
    .pv-modal h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; }
    .pv-modal label { font-size: 0.84rem; font-weight: 600; display: block; margin-bottom: 5px; color: #475569; }
    .pv-modal input { width: 100%; border: 1px solid var(--ap-border); border-radius: 9px; padding: 10px 13px; font-size: 0.9rem; }
    .pv-modal-actions { display: flex; gap: 10px; margin-top: 20px; justify-content: flex-end; }

    /* ─── Tab content hidden ─── */
    .tab-content { display: none; }
    .tab-content.active { display: block; }

    .pv-detail { font-size: 0.78rem; color: var(--ap-muted); }
    .pv-bank-cell { font-size: 0.78rem; line-height: 1.6; }
    .actions-col { white-space: nowrap; }
  </style>
</head>
<body class="ap-page">

<div class="layout">
  <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

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
              <c:when test="${not empty admin.profilePhoto}"><img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt=""></c:when>
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
        <span>Platform Verification &amp; Escrow</span>
      </nav>

      <div class="ap-page-head">
        <div class="ap-page-ico"><i class="fas fa-shield-check"></i></div>
        <div>
          <h1>Platform Verification &amp; Escrow</h1>
          <p>Manage entrepreneurs, investors, pitch desks, and escrow fund releases from one place</p>
        </div>
      </div>

      <%-- Flash messages --%>
      <c:if test="${not empty message}">
        <div class="alert alert-info mb-3" style="border-radius:12px;"><i class="fas fa-info-circle me-1"></i><c:out value="${message}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-3" style="border-radius:12px;"><i class="fas fa-exclamation-triangle me-1"></i><c:out value="${error}"/></div>
      </c:if>

      <%-- Stats row --%>
      <div class="pv-stats">
        <div class="pv-stat amber">
          <div class="ico"><i class="fas fa-user-clock"></i></div>
          <div>
            <div class="val">${pendingCount}</div>
            <div class="lbl">Pending Entrepreneurs</div>
          </div>
        </div>
        <div class="pv-stat blue">
          <div class="ico"><i class="fas fa-user-tie"></i></div>
          <div>
            <c:set var="invPendingCount" value="0"/>
            <c:forEach var="inv" items="${allInvestors != null ? allInvestors : activeInvestorList}">
              <c:if test="${inv.verificationStatus == 'PENDING'}"><c:set var="invPendingCount" value="${invPendingCount + 1}"/></c:if>
            </c:forEach>
            <div class="val">${invPendingCount}</div>
            <div class="lbl">Pending Investors</div>
          </div>
        </div>
        <div class="pv-stat green">
          <div class="ico"><i class="fas fa-file-contract"></i></div>
          <div>
            <c:set var="pitchPendingCount" value="0"/>
            <c:forEach var="prop" items="${activeProposalList}">
              <c:if test="${prop.status == 'PENDING'}"><c:set var="pitchPendingCount" value="${pitchPendingCount + 1}"/></c:if>
            </c:forEach>
            <div class="val">${pitchPendingCount}</div>
            <div class="lbl">Pending Pitch Desks</div>
          </div>
        </div>
        <div class="pv-stat purple">
          <div class="ico"><i class="fas fa-vault"></i></div>
          <div>
            <div class="val">${investmentPendingCount}</div>
            <div class="lbl">Escrow Pending Releases</div>
          </div>
        </div>
      </div>

      <%-- 4-Tab Navigation --%>
      <div class="pv-tabs">
        <div class="pv-tab amber active" onclick="showTab('tab-entrepreneurs')" id="btn-tab-entrepreneurs">
          <i class="fas fa-users"></i> Entrepreneurs
          <span class="badge">${pendingCount}</span>
        </div>
        <div class="pv-tab blue" onclick="showTab('tab-investors')" id="btn-tab-investors">
          <i class="fas fa-user-tie"></i> Investors
          <span class="badge">${invPendingCount}</span>
        </div>
        <div class="pv-tab green" onclick="showTab('tab-pitchdeck')" id="btn-tab-pitchdeck">
          <i class="fas fa-file-contract"></i> Pitch Desks
          <span class="badge">${pitchPendingCount}</span>
        </div>
        <div class="pv-tab escrow" onclick="showTab('tab-escrow')" id="btn-tab-escrow">
          <i class="fas fa-vault"></i> Escrow Releases
          <span class="badge">${investmentPendingCount}</span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/proposal-chats" class="pv-tab" style="text-decoration:none; color:var(--ap-muted);">
          <i class="fas fa-comments"></i> Chat Transcripts
        </a>
      </div>

      <%-- ═══ TAB 1: ENTREPRENEURS ═══ --%>
      <div class="tab-content active" id="tab-entrepreneurs">
        <div class="pv-panel">
          <div class="pv-panel-hd">
            <h2><i class="fas fa-users me-2" style="color:#F59E0B;"></i>Entrepreneurs</h2>
            <form method="get" action="${pageContext.request.contextPath}/admin/pending-proposals" style="display:flex;gap:8px;align-items:center;">
              <input type="hidden" name="tab" value="entrepreneurs">
              <input type="text" name="q" value="${not empty q ? q : ''}" placeholder="Search name / email…" class="ap-input" style="min-width:200px;">
              <select name="filter" class="ap-select">
                <option value="pending"   ${activeFilter=='pending'   ? 'selected':''}>Pending</option>
                <option value="approved"  ${activeFilter=='approved'  ? 'selected':''}>Approved</option>
                <option value="rejected"  ${activeFilter=='rejected'  ? 'selected':''}>Rejected</option>
                <option value="all"       ${activeFilter=='all'       ? 'selected':''}>All</option>
              </select>
              <button type="submit" class="ap-btn ap-btn-primary"><i class="fas fa-filter"></i></button>
            </form>
          </div>
          <div style="overflow-x:auto;">
            <table class="pv-table">
              <thead>
                <tr>
                  <th>Entrepreneur</th>
                  <th>Business</th>
                  <th>Contact</th>
                  <th>Location</th>
                  <th>Investment Needed</th>
                  <th>Status</th>
                  <th class="actions-col">Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeList}">
                  <c:forEach var="e" items="${activeList}">
                    <tr>
                      <td>
                        <div class="pv-entity">
                          <c:choose>
                            <c:when test="${not empty e.profilePhoto}">
                              <img src="${fn:startsWith(e.profilePhoto,'http') ? e.profilePhoto : pageContext.request.contextPath.concat(e.profilePhoto)}" class="pv-avatar" alt="">
                            </c:when>
                            <c:otherwise><div class="pv-avatar-ph">${not empty e.fullName ? fn:substring(e.fullName,0,1) : '?'}</div></c:otherwise>
                          </c:choose>
                          <div>
                            <div class="pv-entity-name"><c:out value="${e.fullName}"/></div>
                            <div class="pv-entity-sub"><c:out value="${e.email}"/></div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <div style="font-weight:600;"><c:out value="${e.businessName}"/></div>
                        <div class="pv-detail"><c:out value="${e.businessCategory}"/></div>
                      </td>
                      <td class="pv-detail">
                        <div><c:out value="${e.phone}"/></div>
                        <div><c:out value="${e.whatsappNumber}"/></div>
                      </td>
                      <td class="pv-detail"><c:out value="${not empty e.city ? e.city : '-'}"/><br><c:out value="${not empty e.state ? e.state : ''}"/></td>
                      <td style="font-weight:600;color:#7C3AED;">
                        <c:out value="${e.investmentNeeded > 0 ? '₹'.concat(e.investmentNeeded) : '—'}"/>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${e.verificationStatus == 'VERIFIED'}"><span class="pv-badge badge-verified">✓ Verified</span></c:when>
                          <c:when test="${e.verificationStatus == 'REJECTED'}"><span class="pv-badge badge-rejected">✗ Rejected</span></c:when>
                          <c:when test="${e.verificationStatus == 'PENDING'}"><span class="pv-badge badge-pending">⏳ Pending</span></c:when>
                          <c:otherwise><span class="pv-badge badge-pending"><c:out value="${e.verificationStatus}"/></span></c:otherwise>
                        </c:choose>
                        <div class="pv-detail mt-1">${e.profileCompletionPct}% complete</div>
                      </td>
                      <td class="actions-col">
                        <div style="display:flex;gap:6px;flex-wrap:wrap;">
                          <a href="${pageContext.request.contextPath}/entrepreneurs/about/${e.id}" class="pv-btn pv-btn-view"><i class="fas fa-eye"></i> View</a>
                          <c:if test="${e.verificationStatus != 'VERIFIED'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/approve" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-approve" onclick="return confirm('Approve entrepreneur: ${e.fullName}?')"><i class="fas fa-check"></i> Approve</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/reject" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-reject" onclick="return confirm('Reject entrepreneur: ${e.fullName}?')"><i class="fas fa-times"></i> Reject</button>
                            </form>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7"><div class="pv-empty"><i class="fas fa-inbox"></i>No entrepreneurs found in this filter.</div></td></tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <%-- ═══ TAB 2: INVESTORS ═══ --%>
      <div class="tab-content" id="tab-investors">
        <div class="pv-panel">
          <div class="pv-panel-hd">
            <h2><i class="fas fa-user-tie me-2" style="color:#3B82F6;"></i>Investors</h2>
          </div>
          <div style="overflow-x:auto;">
            <table class="pv-table">
              <thead>
                <tr>
                  <th>Investor</th>
                  <th>Company / Designation</th>
                  <th>Contact</th>
                  <th>Location</th>
                  <th>Budget Range</th>
                  <th>Status</th>
                  <th class="actions-col">Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeInvestorList}">
                  <c:forEach var="inv" items="${activeInvestorList}">
                    <tr>
                      <td>
                        <div class="pv-entity">
                          <c:choose>
                            <c:when test="${not empty inv.profilePhoto}">
                              <img src="${fn:startsWith(inv.profilePhoto,'http') ? inv.profilePhoto : pageContext.request.contextPath.concat(inv.profilePhoto)}" class="pv-avatar" alt="">
                            </c:when>
                            <c:otherwise><div class="pv-avatar-ph">${not empty inv.fullName ? fn:substring(inv.fullName,0,1) : '?'}</div></c:otherwise>
                          </c:choose>
                          <div>
                            <div class="pv-entity-name"><c:out value="${inv.fullName}"/></div>
                            <div class="pv-entity-sub"><c:out value="${inv.email}"/></div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <div style="font-weight:600;"><c:out value="${not empty inv.companyName ? inv.companyName : '—'}"/></div>
                        <div class="pv-detail"><c:out value="${not empty inv.designation ? inv.designation : ''}"/></div>
                      </td>
                      <td class="pv-detail">
                        <div><c:out value="${inv.phone}"/></div>
                        <div><c:out value="${not empty inv.whatsappNumber ? inv.whatsappNumber : ''}"/></div>
                      </td>
                      <td class="pv-detail"><c:out value="${not empty inv.city ? inv.city : '—'}"/><br><c:out value="${not empty inv.state ? inv.state : ''}"/></td>
                      <td class="pv-detail"><c:out value="${not empty inv.budgetRange ? inv.budgetRange : '—'}"/></td>
                      <td>
                        <c:choose>
                          <c:when test="${inv.verificationStatus == 'VERIFIED'}"><span class="pv-badge badge-verified">✓ Verified</span></c:when>
                          <c:when test="${inv.verificationStatus == 'REJECTED'}"><span class="pv-badge badge-rejected">✗ Rejected</span></c:when>
                          <c:when test="${inv.verificationStatus == 'PENDING'}"><span class="pv-badge badge-pending">⏳ Pending</span></c:when>
                          <c:otherwise><span class="pv-badge badge-pending"><c:out value="${inv.verificationStatus}"/></span></c:otherwise>
                        </c:choose>
                      </td>
                      <td class="actions-col">
                        <div style="display:flex;gap:6px;flex-wrap:wrap;">
                          <a href="${pageContext.request.contextPath}/admin/investors/about/${inv.id}" class="pv-btn pv-btn-view"><i class="fas fa-eye"></i> View</a>
                          <c:if test="${inv.verificationStatus != 'VERIFIED'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/investors/${inv.id}/approve" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-approve" onclick="return confirm('Approve investor: ${inv.fullName}?')"><i class="fas fa-check"></i> Approve</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/admin/investors/${inv.id}/reject" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-reject" onclick="return confirm('Reject investor: ${inv.fullName}?')"><i class="fas fa-times"></i> Reject</button>
                            </form>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7"><div class="pv-empty"><i class="fas fa-user-slash"></i>No investors in this filter.</div></td></tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <%-- ═══ TAB 3: PITCH DESKS ═══ --%>
      <div class="tab-content" id="tab-pitchdeck">
        <div class="pv-panel">
          <div class="pv-panel-hd">
            <h2><i class="fas fa-file-contract me-2" style="color:#22C55E;"></i>Pitch Desks (Business Proposals)</h2>
            <span class="pv-detail">Only <strong>Verified</strong> pitch desks are visible to investors in the marketplace.</span>
          </div>
          <div style="overflow-x:auto;">
            <table class="pv-table">
              <thead>
                <tr>
                  <th>Proposal Title</th>
                  <th>Entrepreneur</th>
                  <th>Category / Location</th>
                  <th>Funding Needed</th>
                  <th>Raised</th>
                  <th>Status</th>
                  <th class="actions-col">Actions</th>
                </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${not empty activeProposalList}">
                  <c:forEach var="prop" items="${activeProposalList}">
                    <tr>
                      <td>
                        <div style="font-weight:600;"><c:out value="${prop.title}"/></div>
                        <div class="pv-detail"><c:out value="${not empty prop.description ? fn:substring(prop.description,0,60).concat('…') : ''}"/></div>
                      </td>
                      <td>
                        <div class="pv-entity">
                          <c:choose>
                            <c:when test="${not empty prop.entrepreneur.profilePhoto}">
                              <img src="${fn:startsWith(prop.entrepreneur.profilePhoto,'http') ? prop.entrepreneur.profilePhoto : pageContext.request.contextPath.concat(prop.entrepreneur.profilePhoto)}" class="pv-avatar" alt="">
                            </c:when>
                            <c:otherwise><div class="pv-avatar-ph">${not empty prop.entrepreneur.fullName ? fn:substring(prop.entrepreneur.fullName,0,1) : '?'}</div></c:otherwise>
                          </c:choose>
                          <div>
                            <div class="pv-entity-name"><c:out value="${prop.entrepreneur.fullName}"/></div>
                            <div class="pv-entity-sub"><c:out value="${prop.entrepreneur.email}"/></div>
                          </div>
                        </div>
                      </td>
                      <td class="pv-detail">
                        <div><c:out value="${prop.category}"/></div>
                        <div><c:out value="${prop.location}"/></div>
                      </td>
                      <td style="font-weight:700;color:#7C3AED;">
                        <c:out value="${prop.fundingNeeded > 0 ? '₹'.concat(prop.fundingNeeded) : '—'}"/>
                      </td>
                      <td style="font-weight:600;color:#15803D;">
                        <c:out value="${prop.amountRaised > 0 ? '₹'.concat(prop.amountRaised) : '₹0'}"/>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${prop.status == 'VERIFIED'}"><span class="pv-badge badge-verified">✓ Verified</span></c:when>
                          <c:when test="${prop.status == 'REJECTED'}"><span class="pv-badge badge-rejected">✗ Rejected</span></c:when>
                          <c:when test="${prop.status == 'PENDING'}"><span class="pv-badge badge-pending">⏳ Pending Review</span></c:when>
                          <c:otherwise><span class="pv-badge badge-pending"><c:out value="${prop.status}"/></span></c:otherwise>
                        </c:choose>
                      </td>
                      <td class="actions-col">
                        <div style="display:flex;gap:6px;flex-wrap:wrap;">
                          <a href="${pageContext.request.contextPath}/admin/proposals/about/${prop.id}" class="pv-btn pv-btn-view"><i class="fas fa-eye"></i> View</a>
                          <c:if test="${prop.status != 'VERIFIED'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/proposals/${prop.id}/approve" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-approve" onclick="return confirm('Approve this pitch desk?')"><i class="fas fa-check"></i> Approve</button>
                            </form>
                          </c:if>
                          <c:if test="${prop.status != 'REJECTED'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/proposals/${prop.id}/reject" style="display:inline;">
                              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                              <button type="submit" class="pv-btn pv-btn-reject" onclick="return confirm('Reject this pitch desk?')"><i class="fas fa-times"></i> Reject</button>
                            </form>
                          </c:if>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7"><div class="pv-empty"><i class="fas fa-folder-open"></i>No pitch desks in this filter.</div></td></tr>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <%-- ═══ TAB 4: ESCROW FUND RELEASES ═══ --%>
      <div class="tab-content" id="tab-escrow">

        <div class="escrow-info">
          <div class="eitem"><div class="eval">₹<fmt:formatNumber value="${escrowHeld}" maxFractionDigits="0"/></div><div class="elbl">Total Held in Escrow</div></div>
          <div class="eitem"><div class="eval">${investmentPendingCount}</div><div class="elbl">Investments Awaiting Release</div></div>
          <div class="eitem"><div class="eval">₹<fmt:formatNumber value="${escrowReleased}" maxFractionDigits="0"/></div><div class="elbl">Total Released to Entrepreneurs</div></div>
        </div>

        <div class="pv-panel">
          <div class="pv-panel-hd">
            <h2><i class="fas fa-vault me-2" style="color:#A855F7;"></i>Escrow Fund Releases</h2>
            <span class="pv-detail">Only <strong>PENDING</strong> investments are shown. Release funds to entrepreneur after verification.</span>
          </div>
          <div style="overflow-x:auto;">
            <table class="pv-table">
              <thead>
                <tr>
                  <th>Investor</th>
                  <th>Pitch Desk</th>
                  <th>Entrepreneur</th>
                  <th>Bank / UPI Details</th>
                  <th>Amount (Escrow)</th>
                  <th>Date</th>
                  <th class="actions-col">Release Action</th>
                </tr>
              </thead>
              <tbody>
              <c:set var="pendingInvCount" value="0"/>
              <c:choose>
                <c:when test="${not empty allInvestments}">
                  <c:forEach var="inv" items="${allInvestments}">
                    <c:if test="${inv.status == 'PENDING'}">
                      <c:set var="pendingInvCount" value="${pendingInvCount + 1}"/>
                      <tr>
                        <td>
                          <div class="pv-entity">
                            <c:choose>
                              <c:when test="${not empty inv.investor.profilePhoto}">
                                <img src="${fn:startsWith(inv.investor.profilePhoto,'http') ? inv.investor.profilePhoto : pageContext.request.contextPath.concat(inv.investor.profilePhoto)}" class="pv-avatar" alt="">
                              </c:when>
                              <c:otherwise><div class="pv-avatar-ph">${not empty inv.investor.fullName ? fn:substring(inv.investor.fullName,0,1) : '?'}</div></c:otherwise>
                            </c:choose>
                            <div>
                              <div class="pv-entity-name"><c:out value="${inv.investor.fullName}"/></div>
                              <div class="pv-entity-sub"><c:out value="${inv.investor.email}"/></div>
                              <c:if test="${not empty inv.razorpayPaymentId}">
                                <div class="pv-detail" title="Razorpay Payment ID"><i class="fas fa-credit-card me-1"></i><c:out value="${fn:substring(inv.razorpayPaymentId,0,18)}…"/></div>
                              </c:if>
                            </div>
                          </div>
                        </td>
                        <td>
                          <div style="font-weight:600;"><c:out value="${inv.proposal.title}"/></div>
                          <div class="pv-detail"><c:out value="${inv.proposal.category}"/></div>
                        </td>
                        <td>
                          <div class="pv-entity">
                            <c:choose>
                              <c:when test="${not empty inv.proposal.entrepreneur.profilePhoto}">
                                <img src="${fn:startsWith(inv.proposal.entrepreneur.profilePhoto,'http') ? inv.proposal.entrepreneur.profilePhoto : pageContext.request.contextPath.concat(inv.proposal.entrepreneur.profilePhoto)}" class="pv-avatar" alt="">
                              </c:when>
                              <c:otherwise><div class="pv-avatar-ph">${not empty inv.proposal.entrepreneur.fullName ? fn:substring(inv.proposal.entrepreneur.fullName,0,1) : '?'}</div></c:otherwise>
                            </c:choose>
                            <div>
                              <div class="pv-entity-name"><c:out value="${inv.proposal.entrepreneur.fullName}"/></div>
                              <div class="pv-entity-sub"><c:out value="${inv.proposal.entrepreneur.email}"/></div>
                            </div>
                          </div>
                        </td>
                        <td class="pv-bank-cell">
                          <c:choose>
                            <c:when test="${not empty inv.proposal.entrepreneur.accountNumber}">
                              <div><i class="fas fa-university me-1 text-muted"></i><strong><c:out value="${inv.proposal.entrepreneur.bankName}"/></strong></div>
                              <div>A/C: <c:out value="${inv.proposal.entrepreneur.accountNumber}"/></div>
                              <div>IFSC: <c:out value="${inv.proposal.entrepreneur.ifscCode}"/></div>
                              <c:if test="${not empty inv.proposal.entrepreneur.upiId}">
                                <div><i class="fas fa-mobile-alt me-1 text-muted"></i>UPI: <c:out value="${inv.proposal.entrepreneur.upiId}"/></div>
                              </c:if>
                            </c:when>
                            <c:when test="${not empty inv.proposal.entrepreneur.upiId}">
                              <div><i class="fas fa-mobile-alt me-1 text-muted"></i>UPI: <strong><c:out value="${inv.proposal.entrepreneur.upiId}"/></strong></div>
                            </c:when>
                            <c:when test="${not empty inv.proposal.entrepreneur.bankDetails}">
                              <div class="pv-detail"><c:out value="${inv.proposal.entrepreneur.bankDetails}"/></div>
                            </c:when>
                            <c:otherwise><span class="pv-detail text-danger">⚠ No bank details on file</span></c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <span style="font-size:1.1rem;font-weight:700;color:#7C3AED;">₹<fmt:formatNumber value="${inv.amount}" maxFractionDigits="0"/></span>
                          <div><span class="pv-badge badge-escrow">In Escrow</span></div>
                        </td>
                        <td class="pv-detail">
                          <c:out value="${inv.formattedCreatedAt}"/>
                        </td>
                        <td class="actions-col">
                          <button class="pv-btn pv-btn-release" onclick="openReleaseModal(${inv.id}, ${inv.amount}, '${inv.proposal.entrepreneur.fullName}', '${inv.investor.fullName}')">
                            <i class="fas fa-paper-plane"></i> Release Funds
                          </button>
                        </td>
                      </tr>
                    </c:if>
                  </c:forEach>
                  <c:if test="${pendingInvCount == 0}">
                    <tr><td colspan="7"><div class="pv-empty"><i class="fas fa-check-double"></i>No pending escrow releases. All investments have been processed.</div></td></tr>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <tr><td colspan="7"><div class="pv-empty"><i class="fas fa-vault"></i>No investments recorded yet.</div></td></tr>
                </c:otherwise>
              </c:choose>

              <%-- Also show completed investments for audit trail --%>
              <c:forEach var="inv" items="${allInvestments}">
                <c:if test="${inv.status == 'COMPLETED'}">
                  <tr style="opacity:0.65;">
                    <td>
                      <div class="pv-entity-name"><c:out value="${inv.investor.fullName}"/></div>
                      <div class="pv-entity-sub"><c:out value="${inv.investor.email}"/></div>
                    </td>
                    <td><c:out value="${inv.proposal.title}"/></td>
                    <td><c:out value="${inv.proposal.entrepreneur.fullName}"/></td>
                    <td class="pv-detail">Released</td>
                    <td>
                      <div style="font-weight:600;">₹<fmt:formatNumber value="${inv.amount}" maxFractionDigits="0"/></div>
                      <div class="pv-detail">Released: ₹<fmt:formatNumber value="${inv.releasedAmount != null ? inv.releasedAmount : 0}" maxFractionDigits="0"/></div>
                      <c:if test="${inv.adminAmount != null and inv.adminAmount > 0}">
                        <div class="pv-detail">Admin retained: ₹<fmt:formatNumber value="${inv.adminAmount}" maxFractionDigits="0"/></div>
                      </c:if>
                    </td>
                    <td class="pv-detail">
                      <c:out value="${inv.formattedCreatedAt}"/>
                    </td>
                    <td><span class="pv-badge badge-released">✓ Released</span></td>
                  </tr>
                </c:if>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

    </div><%-- end ap-main-inner --%>
  </main>
</div>

<%-- Release Modal --%>
<div class="pv-modal-overlay" id="releaseModalOverlay">
  <div class="pv-modal">
    <h3><i class="fas fa-paper-plane me-2" style="color:#A855F7;"></i>Release Escrow Funds</h3>
    <p style="font-size:0.85rem;color:#64748B;margin-bottom:16px;">
      Releasing funds for <strong id="releaseEntrepreneurName">—</strong> committed by investor <strong id="releaseInvestorName">—</strong>.
    </p>
    <p style="font-size:0.85rem;color:#64748B;">Total held in escrow: <strong id="releaseTotalAmount" style="color:#7C3AED;">₹0</strong></p>
    <form id="releaseForm" method="post" action="">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <label for="releasedAmount">Amount to release to Entrepreneur (₹)</label>
      <input type="number" id="releasedAmount" name="releasedAmount" step="0.01" min="0" placeholder="Enter release amount" required>
      <p style="font-size:0.75rem;color:#94A3B8;margin-top:6px;">Remaining goes to Admin account. Enter the full amount to release everything.</p>
      <div class="pv-modal-actions">
        <button type="button" class="pv-btn pv-btn-view" onclick="closeReleaseModal()">Cancel</button>
        <button type="submit" class="pv-btn pv-btn-release"><i class="fas fa-paper-plane"></i> Confirm Release</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // ── Tab switching ──
  function showTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.pv-tab').forEach(t => t.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    document.getElementById('btn-' + tabId).classList.add('active');
  }

  // ── Release modal ──
  function openReleaseModal(investmentId, amount, entrepreneurName, investorName) {
    document.getElementById('releaseEntrepreneurName').textContent = entrepreneurName;
    document.getElementById('releaseInvestorName').textContent = investorName;
    document.getElementById('releaseTotalAmount').textContent = '₹' + amount.toFixed(2);
    document.getElementById('releasedAmount').max = amount;
    document.getElementById('releasedAmount').value = amount;
    document.getElementById('releaseForm').action =
      '${pageContext.request.contextPath}/admin/investments/' + investmentId + '/release';
    document.getElementById('releaseModalOverlay').classList.add('open');
  }
  function closeReleaseModal() {
    document.getElementById('releaseModalOverlay').classList.remove('open');
  }
  document.getElementById('releaseModalOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeReleaseModal();
  });

  // ── Auto-switch tab if URL hash provided ──
  const hash = window.location.hash;
  if (hash === '#investors')   showTab('tab-investors');
  else if (hash === '#pitch')  showTab('tab-pitchdeck');
  else if (hash === '#escrow') showTab('tab-escrow');

  // ── Sidebar toggle ──
  const sidebarToggle = document.getElementById('sidebarToggle');
  if (sidebarToggle) {
    sidebarToggle.addEventListener('click', function() {
      document.querySelector('.ap-sidebar')?.classList.toggle('open');
    });
  }
</script>
</body>
</html>
