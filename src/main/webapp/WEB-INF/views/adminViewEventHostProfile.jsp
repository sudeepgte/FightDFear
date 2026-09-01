<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty host.fullName ? host.fullName : 'Event Host'} — Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary: #F43F5E;
    --rose-soft: #FFF1F2;
    --bg: #F8FAFC;
    --navy: #0F172A;
    --navy-mid: #1E293B;
    --border: #E2E8F0;
    --text-muted: #64748B;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body { font-family: 'Poppins', sans-serif; margin: 0; background: var(--bg); color: var(--navy-mid); }

  .topbar {
    background: var(--navy); color: #fff; padding: 0 20px; height: 58px;
    display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 1000; border-bottom: 1px solid rgba(255,255,255,0.08);
  }
  .topbar .brand {
    color: #fff; text-decoration: none; display: flex; align-items: center; gap: 10px;
    font-size: 1.05rem; font-weight: 700; font-family: 'Outfit', sans-serif;
  }
  .topbar .brand img { height: 32px; width: 32px; border-radius: 8px; object-fit: cover; }
  .topbar .btn-logout {
    background: rgba(255,255,255,0.12); color: #fff; border: 1px solid rgba(255,255,255,0.28);
    border-radius: 8px; padding: 6px 14px; font-size: 0.85rem; font-weight: 600; text-decoration: none;
  }
  .mobile-toggle { display: none; background: none; border: none; color: #fff; font-size: 1.2rem; cursor: pointer; padding: 6px; margin-right: 8px; }

  .layout { display: flex; min-height: calc(100vh - 58px); }
  .sidebar {
    width: var(--sidebar-w); background: #fff; border-right: 1px solid var(--border);
    position: sticky; top: 58px; height: calc(100vh - 58px); padding: 14px 12px; overflow-y: auto; flex-shrink: 0;
  }
  .sidebar .brand { font-size: 0.9rem; font-weight: 700; color: var(--navy); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
  .sidebar .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
  .sidebar .navlink {
    display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
    color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; margin-bottom: 2px;
  }
  .sidebar .navlink i { width: 20px; text-align: center; color: var(--primary); }
  .sidebar .navlink:hover { background: var(--rose-soft); color: var(--navy); }
  .sidebar .navlink.active { background: var(--primary); color: #fff; font-weight: 600; }
  .sidebar .navlink.active i { color: #fff; }

  .main { flex: 1; min-width: 0; padding: 24px 20px 56px; }
  .mainInner { max-width: 1100px; margin: 0 auto; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--text-muted);
    font-weight: 600; font-size: 0.9rem; text-decoration: none; margin-bottom: 16px;
  }
  .back-nav:hover { color: var(--primary); }

  .header-card {
    background: linear-gradient(135deg, var(--navy) 0%, var(--navy-mid) 100%);
    border-radius: 20px; padding: 28px; color: #fff; margin-bottom: 22px;
    position: relative; overflow: hidden;
  }
  .header-card::after {
    content: ''; position: absolute; right: -50px; top: -50px;
    width: 200px; height: 200px; background: rgba(244, 63, 94, 0.16);
    border-radius: 50%; pointer-events: none;
  }
  .avatar-box {
    width: 112px; height: 112px; border-radius: 20px;
    border: 4px solid rgba(255,255,255,0.22); overflow: hidden; background: #fff; flex-shrink: 0;
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .header-card h1 { font-family: 'Outfit', sans-serif; font-size: 1.55rem; font-weight: 800; margin: 0; color: #fff; }
  .progress-wrap { background: rgba(255,255,255,0.16); border-radius: 50px; height: 10px; overflow: hidden; margin-top: 8px; }
  .progress-bar-fill { background: linear-gradient(90deg, var(--primary), #fb7185); height: 100%; border-radius: 50px; }

  .badge-status-lg {
    padding: 6px 14px; border-radius: 50px; font-size: 0.78rem; font-weight: 700;
    display: inline-flex; align-items: center; gap: 6px;
  }
  .status-APPROVED, .status-VERIFIED { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
  .status-READY_FOR_VERIFICATION { background: #e0f2fe; color: #075985; border: 1px solid #bae6fd; }
  .status-CHANGES_REQUESTED { background: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
  .status-REJECTED, .status-SUSPENDED { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

  .review-card {
    background: #fff; border-radius: 16px; border: 1px solid var(--border);
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04); padding: 22px 26px; margin-bottom: 20px;
  }
  .section-header {
    display: flex; align-items: center; gap: 12px; margin-bottom: 18px;
    padding-bottom: 12px; border-bottom: 1px solid var(--border);
  }
  .section-header i { color: var(--primary); font-size: 1.2rem; }
  .section-header h3 { font-family: 'Outfit', sans-serif; font-size: 1.08rem; font-weight: 700; color: var(--navy); margin: 0; }

  .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
  .info-field { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    font-size: 0.74rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.55px; color: var(--text-muted);
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--navy-mid); word-break: break-word; }
  .empty-text { color: var(--text-muted); font-style: italic; font-weight: 500; font-size: 0.9rem; }
  .bio-box {
    background: var(--rose-soft); border: 1px solid #fecdd3; border-radius: 12px;
    padding: 14px 16px; font-size: 0.94rem; line-height: 1.65; color: var(--navy-mid);
  }
  .tag-pill {
    display: inline-block; background: var(--rose-soft); color: #9f1239;
    padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;
    margin: 0 6px 6px 0; border: 1px solid #fecdd3;
  }

  .doc-row {
    display: flex; align-items: center; gap: 14px; padding: 14px 16px;
    border: 1px solid var(--border); border-radius: 12px; background: #fff; margin-bottom: 10px;
  }
  .doc-icon {
    width: 46px; height: 46px; border-radius: 10px; background: var(--rose-soft); color: var(--primary);
    display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0;
  }
  .doc-link { color: var(--primary); font-weight: 700; text-decoration: none; }
  .doc-link:hover { text-decoration: underline; }

  .reason-checks label {
    display: inline-flex; align-items: center; gap: 6px; background: var(--bg);
    border: 1px solid var(--border); border-radius: 999px; padding: 6px 12px; font-size: 0.82rem; font-weight: 600;
  }
  .reason-checks input { accent-color: var(--primary); }

  .action-bar {
    display: flex; justify-content: flex-end; gap: 10px; flex-wrap: wrap;
    padding-top: 18px; border-top: 1px solid var(--border);
  }
  .btn-verify {
    background: #059669; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .btn-verify:hover { background: #047857; color: #fff; }
  .btn-changes {
    background: #f59e0b; color: #1f2937; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .btn-reject {
    background: #dc2626; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .btn-reject:hover { background: #b91c1c; color: #fff; }

  .missing-list { margin: 0; padding-left: 1.15rem; color: var(--text-muted); font-size: 0.9rem; }
  .missing-list li { margin-bottom: 4px; }

  @media (max-width: 992px) {
    .mobile-toggle { display: block; }
    .layout { flex-direction: column; }
    .sidebar {
      position: fixed; left: -100%; top: 0; z-index: 2000; width: 280px; height: 100vh;
      transition: left 0.3s ease; box-shadow: 10px 0 30px rgba(0,0,0,0.18);
    }
    .sidebar.active { left: 0; }
  }
  @media (max-width: 768px) {
    .main { padding: 16px 12px 40px; }
    .header-card { padding: 20px 16px; }
    .review-card { padding: 18px 14px; }
    .info-grid { grid-template-columns: 1fr; }
    .action-bar { justify-content: stretch; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .btn-changes { width: 100%; justify-content: center; }
    .avatar-box { width: 88px; height: 88px; }
  }
</style>
</head>
<body>

<c:set var="statusKey" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus : 'PENDING'}"/>
<c:set var="displayStatus" value="${not empty statusLabel ? statusLabel : statusKey}"/>
<c:set var="pct" value="${host.profileCompletionPct != null ? host.profileCompletionPct : 0}"/>
<c:set var="logoPath" value="${host.logoPath}"/>
<c:set var="logoOk" value="${not empty logoPath and logoPath != 'mobile-pending' and not fn:startsWith(logoPath, 'mobile:')}"/>
<c:set var="docPath" value="${host.documentPath}"/>
<c:set var="docOk" value="${not empty docPath and docPath != 'mobile-pending' and not fn:startsWith(docPath, 'mobile:')}"/>
<c:set var="portPath" value="${host.portfolioPath}"/>
<c:set var="portOk" value="${not empty portPath and portPath != 'mobile-pending' and not fn:startsWith(portPath, 'mobile:')}"/>

<div class="topbar">
  <div class="d-flex align-items-center">
    <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu">
      <i class="fas fa-bars"></i>
    </button>
    <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="brand">
      <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
      <span>Fight D Fear Admin</span>
    </a>
  </div>
  <div class="d-flex align-items-center gap-2">
    <span class="badge bg-light text-dark fw-bold px-3 py-2 d-none d-sm-inline">Event Host Review</span>
    <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">

      <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show mb-3 rounded-4" role="alert">
          <i class="bi bi-check-circle-fill me-2"></i>${message}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mb-3 rounded-4" role="alert">
          <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </c:if>

      <a href="${pageContext.request.contextPath}/admin/pending-event-hosts" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Event Hosts
      </a>

      <div class="header-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
            <c:choose>
              <c:when test="${logoOk}">
                <img src="${fn:startsWith(logoPath, 'http') ? logoPath : pageContext.request.contextPath.concat(logoPath)}" alt="${host.fullName}">
              </c:when>
              <c:otherwise>
                <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light">
                  <i class="bi bi-calendar-heart" style="font-size:2.6rem;color:#94a3b8;"></i>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="flex-grow-1" style="position:relative;z-index:1;">
            <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
              <h1>${not empty host.fullName ? host.fullName : 'Unnamed organizer'}</h1>
              <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
            </div>
            <div class="d-flex flex-wrap gap-3 gap-md-4 text-white-50 small mb-3">
              <div>
                <i class="bi bi-envelope-fill text-white"></i>
                <c:choose>
                  <c:when test="${not empty host.email}"><a href="mailto:${host.email}" class="text-white text-decoration-none">${host.email}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill text-white"></i>
                <c:choose>
                  <c:when test="${not empty host.phone}"><a href="tel:${host.phone}" class="text-white text-decoration-none">${host.phone}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
              <c:if test="${not empty host.organizerName}">
                <div><i class="bi bi-building text-white"></i> ${host.organizerName}</div>
              </c:if>
            </div>
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold text-white mb-1">
                <span>Profile Completion</span>
                <span>${pct}%</span>
              </div>
              <div class="progress-wrap">
                <div class="progress-bar-fill" style="width:${pct}%;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-person-badge-fill"></i>
          <h3>1. Personal Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Full name</span>
            <c:choose><c:when test="${not empty host.fullName}"><span class="info-field-value">${host.fullName}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Email</span>
            <c:choose><c:when test="${not empty host.email}"><span class="info-field-value">${host.email}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Phone</span>
            <c:choose><c:when test="${not empty host.phone}"><span class="info-field-value">${host.phone}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">WhatsApp</span>
            <c:choose><c:when test="${not empty host.whatsappNumber}"><span class="info-field-value">${host.whatsappNumber}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Gender</span>
            <c:choose><c:when test="${not empty host.gender}"><span class="info-field-value">${host.gender}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Date of birth</span>
            <c:choose><c:when test="${not empty host.dateOfBirth}"><span class="info-field-value">${host.dateOfBirth}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Languages</span>
            <c:choose><c:when test="${not empty host.languages}"><span class="info-field-value">${host.languages}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-building"></i>
          <h3>2. Organization</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Organization name</span>
            <c:choose><c:when test="${not empty host.organizerName}"><span class="info-field-value">${host.organizerName}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Organizer type</span>
            <c:choose><c:when test="${not empty host.organizerType}"><span class="info-field-value">${host.organizerType}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">GST / NGO / CIN</span>
            <c:choose><c:when test="${not empty host.credentialNumber}"><span class="info-field-value">${host.credentialNumber}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Experience</span>
            <c:choose><c:when test="${host.yearsExperience != null}"><span class="info-field-value">${host.yearsExperience} years</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Awards / recognition</span>
            <c:choose><c:when test="${not empty host.awardsRecognition}"><span class="info-field-value">${host.awardsRecognition}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Events conducted</span>
            <c:choose><c:when test="${host.eventsConducted != null}"><span class="info-field-value">${host.eventsConducted}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-geo-alt-fill"></i>
          <h3>3. Location &amp; Contact</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Office address</span>
            <c:choose><c:when test="${not empty host.officeAddress}"><span class="info-field-value">${host.officeAddress}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">City / State</span>
            <c:choose>
              <c:when test="${not empty host.city}"><span class="info-field-value">${host.city}<c:if test="${not empty host.state}">, ${host.state}</c:if></span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Area / Country</span>
            <c:choose>
              <c:when test="${not empty host.area or not empty host.country}">
                <span class="info-field-value">${empty host.area ? '' : host.area}<c:if test="${not empty host.area && not empty host.country}">, </c:if>${empty host.country ? '' : host.country}</span>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Pincode</span>
            <c:choose><c:when test="${not empty host.pincode}"><span class="info-field-value">${host.pincode}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Website</span>
            <c:choose><c:when test="${not empty host.website}"><span class="info-field-value">${host.website}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Instagram</span>
            <c:choose><c:when test="${not empty host.instagram}"><span class="info-field-value">${host.instagram}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Facebook</span>
            <c:choose><c:when test="${not empty host.facebook}"><span class="info-field-value">${host.facebook}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">LinkedIn</span>
            <c:choose><c:when test="${not empty host.linkedin}"><span class="info-field-value">${host.linkedin}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">YouTube</span>
            <c:choose><c:when test="${not empty host.youtube}"><span class="info-field-value">${host.youtube}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-calendar-event-fill"></i>
          <h3>4. Events &amp; Services</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Categories</span>
            <c:choose>
              <c:when test="${not empty host.eventCategories}">
                <div>
                  <c:forEach var="cat" items="${fn:split(host.eventCategories, ',')}">
                    <span class="tag-pill">${fn:trim(cat)}</span>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Audience</span>
            <c:choose><c:when test="${not empty host.audience}"><span class="info-field-value">${host.audience}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Expected participants</span>
            <c:choose><c:when test="${host.expectedParticipants != null}"><span class="info-field-value">${host.expectedParticipants}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Session mode / ticket</span>
            <c:choose>
              <c:when test="${not empty host.sessionMode || host.typicalPrice != null}">
                <span class="info-field-value">
                  ${empty host.sessionMode ? '—' : host.sessionMode}
                  <c:if test="${host.typicalPrice != null}"> · ₹<fmt:formatNumber value="${host.typicalPrice}" maxFractionDigits="0"/></c:if>
                </span>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Open days / hours</span>
            <c:choose>
              <c:when test="${not empty host.openDays || not empty openTimeLabel}">
                <span class="info-field-value">
                  ${empty host.openDays ? '—' : host.openDays}
                  <c:if test="${not empty openTimeLabel}"><br/>${openTimeLabel}<c:if test="${not empty closeTimeLabel}"> – ${closeTimeLabel}</c:if></c:if>
                </span>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Previous event details</span>
            <c:choose><c:when test="${not empty host.previousEventDetails}"><span class="info-field-value">${host.previousEventDetails}</span></c:when><c:otherwise><span class="empty-text">Not provided</span></c:otherwise></c:choose>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-chat-quote-fill"></i>
          <h3>5. About</h3>
        </div>
        <c:choose>
          <c:when test="${not empty host.hostBio}"><div class="bio-box"><c:out value="${host.hostBio}"/></div></c:when>
          <c:otherwise><span class="empty-text">No bio provided.</span></c:otherwise>
        </c:choose>
        <c:if test="${not empty missingItems}">
          <div class="mt-3">
            <div class="info-field-label mb-2">Missing profile items</div>
            <ul class="missing-list">
              <c:forEach var="item" items="${missingItems}">
                <li><c:out value="${item}"/></li>
              </c:forEach>
            </ul>
          </div>
        </c:if>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-earmark-check-fill"></i>
          <h3>6. Documents</h3>
        </div>
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-image"></i></div>
          <div>
            <div class="info-field-label">Logo / profile image</div>
            <c:choose>
              <c:when test="${logoOk}"><a href="${pageContext.request.contextPath}${logoPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View logo</a></c:when>
              <c:otherwise><span class="empty-text">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div>
            <div class="info-field-label">Verification document</div>
            <c:choose>
              <c:when test="${docOk}"><a href="${pageContext.request.contextPath}${docPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View document</a></c:when>
              <c:otherwise><span class="empty-text">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-row mb-0">
          <div class="doc-icon"><i class="bi bi-folder2-open"></i></div>
          <div>
            <div class="info-field-label">Portfolio</div>
            <c:choose>
              <c:when test="${portOk}"><a href="${pageContext.request.contextPath}${portPath}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View portfolio</a></c:when>
              <c:otherwise><span class="empty-text">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-gavel"></i>
          <h3>7. Admin Decision</h3>
        </div>
        <div class="mb-3">
          <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
          <c:if test="${not empty host.changesRequestedNote}">
            <div class="mt-2 text-warning small"><strong>Changes requested:</strong> ${host.changesRequestedNote}</div>
          </c:if>
          <c:if test="${not empty host.rejectionReason}">
            <div class="mt-2 text-danger small"><strong>Rejection reason:</strong> ${host.rejectionReason}</div>
          </c:if>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Decision notes / comments</label>
          <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the organizer (required for reject / request changes)"></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Request-change reasons (optional)</label>
          <div class="d-flex flex-wrap gap-2 reason-checks">
            <label><input type="checkbox" class="reason-box" value="Organization details"> Organization details</label>
            <label><input type="checkbox" class="reason-box" value="Location"> Location</label>
            <label><input type="checkbox" class="reason-box" value="Documents"> Documents</label>
            <label><input type="checkbox" class="reason-box" value="Event categories"> Event categories</label>
            <label><input type="checkbox" class="reason-box" value="Pricing"> Pricing</label>
          </div>
        </div>

        <div class="action-bar">
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/approve" method="post" class="m-0 p-0">
            <input type="hidden" name="notes" id="approveNotes">
            <button type="submit" class="btn-verify" onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-check-circle"></i> Approve
            </button>
          </form>
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/request-changes" method="post" class="m-0 p-0">
            <input type="hidden" name="notes" id="changesNotes">
            <input type="hidden" name="reasons" id="changesReasons">
            <button type="submit" class="btn-changes"
                    onclick="
                      document.getElementById('changesNotes').value=document.getElementById('decisionNotes').value;
                      document.getElementById('changesReasons').value=Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                    ">
              <i class="fas fa-edit"></i> Request Changes
            </button>
          </form>
          <form action="${pageContext.request.contextPath}/admin/event-hosts/${host.id}/reject" method="post" class="m-0 p-0"
                onsubmit="return confirm('Reject this event organizer?')">
            <input type="hidden" name="notes" id="rejectNotes">
            <button type="submit" class="btn-reject" onclick="document.getElementById('rejectNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-times-circle"></i> Reject
            </button>
          </form>
        </div>
      </div>

    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  const toggle = document.getElementById('sidebarToggle');
  const sidebar = document.querySelector('.sidebar');
  if (toggle && sidebar) {
    toggle.addEventListener('click', () => sidebar.classList.toggle('active'));
  }
  const closeBtn = document.getElementById('closeSidebar');
  if (closeBtn && sidebar) {
    closeBtn.addEventListener('click', () => sidebar.classList.remove('active'));
  }
</script>
</body>
</html>
