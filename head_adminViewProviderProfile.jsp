<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty provider.fullName ? provider.fullName : 'Service Partner'} — Application Review | Fight D Fear Admin</title>
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
    background: rgba(255,255,255,0.12) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.28) !important;
    border-radius: 8px !important; padding: 6px 14px !important; font-size: 0.85rem !important; font-weight: 600 !important; text-decoration: none !important;
  }
  .mobile-toggle { display: none; background: none; border: none; color: #fff; font-size: 1.2rem; cursor: pointer; padding: 6px; margin-right: 8px; }

  .layout { display: flex; min-height: calc(100vh - 58px); }
  .sidebar {
    width: var(--sidebar-w) !important; background: #fff !important; border-right: 1px solid var(--border) !important;
    position: sticky !important; top: 58px !important; height: calc(100vh - 58px) !important; padding: 14px 12px !important; overflow-y: auto !important; flex-shrink: 0 !important;
  }
  .sidebar .brand { font-size: 0.9rem !important; font-weight: 700 !important; color: var(--navy) !important; padding: 10px 15px !important; text-transform: uppercase !important; letter-spacing: 1px !important; }
  .sidebar .sectionTitle { font-size: 0.7rem !important; font-weight: 700 !important; color: #94a3b8 !important; text-transform: uppercase !important; letter-spacing: 0.05em !important; margin: 20px 15px 8px !important; }
  .sidebar .navlink {
    display: flex !important; align-items: center !important; gap: 12px !important; padding: 10px 15px !important; border-radius: 12px !important;
    color: #4b5563 !important; text-decoration: none !important; font-weight: 500 !important; font-size: 0.9rem !important; margin-bottom: 2px !important;
  }
  .sidebar .navlink i { width: 20px !important; text-align: center !important; color: var(--primary) !important; }
  .sidebar .navlink:hover { background: var(--rose-soft) !important; color: var(--navy) !important; }
  .sidebar .navlink.active { background: var(--primary) !important; color: #fff !important; font-weight: 600 !important; }
  .sidebar .navlink.active i { color: #fff !important; }

  .main { flex: 1; min-width: 0; padding: 24px 20px 56px !important; background: var(--bg) !important; }
  .mainInner { max-width: 1100px; margin: 0 auto; }

  .pg-header {
    display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px;
  }
  .pg-header h4 { font-family: 'Outfit', sans-serif; font-size: 1.45rem; font-weight: 800; color: var(--navy); margin: 0; }
  .pg-header p { font-size: 0.9rem; color: var(--text-muted); margin: 4px 0 0; }
  .btn-back {
    display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px;
    background: #fff; border: 1px solid var(--border); color: var(--navy); font-weight: 600;
    font-size: 0.88rem; text-decoration: none; transition: all 0.2s;
  }
  .btn-back:hover { background: var(--rose-soft); color: var(--primary); border-color: #FECDD3; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--text-muted);
    font-weight: 600; font-size: 0.9rem; text-decoration: none; margin-bottom: 16px;
  }
  .back-nav:hover { color: var(--primary); }

  .header-card {
    background: #FFFFFF;
    border: 1px solid var(--rose-soft);
    border-radius: 20px; padding: 28px; color: var(--navy); margin-bottom: 22px;
    position: relative; overflow: hidden;
    box-shadow: 0 4px 20px rgba(244, 63, 94, 0.06);
  }
  .header-card::after {
    content: ''; position: absolute; right: -40px; top: -40px;
    width: 180px; height: 180px; background: rgba(244, 63, 94, 0.05);
    border-radius: 50%; pointer-events: none;
  }
  .avatar-box {
    width: 112px; height: 112px; border-radius: 20px;
    border: 3px solid #FECDD3; overflow: hidden; background: var(--rose-soft); flex-shrink: 0;
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .header-card h1 { font-family: 'Outfit', sans-serif; font-size: 1.55rem; font-weight: 800; margin: 0; color: var(--navy); }
  .progress-wrap { background: var(--rose-soft); border-radius: 50px; height: 10px; overflow: hidden; margin-top: 8px; border: 1px solid #FECDD3; }
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
  .btn-changes:hover { background: #d97706; color: #fff; }
  .btn-reject {
    background: #dc2626; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px;
  }
  .btn-reject:hover { background: #b91c1c; color: #fff; }

  @media (max-width: 992px) {
    .mobile-toggle { display: block !important; }
    .layout { flex-direction: column !important; }
    .sidebar {
      position: fixed !important; left: -100% !important; top: 0 !important; z-index: 2000 !important; width: 280px !important; height: 100vh !important;
      transition: left 0.3s ease !important; box-shadow: 10px 0 30px rgba(0,0,0,0.18) !important;
    }
    .sidebar.active { left: 0 !important; }
  }

  @media (max-width: 768px) {
    html, body { max-width: 100vw !important; width: 100% !important; overflow-x: hidden !important; }
    .layout, .main, .mainInner { width: 100% !important; max-width: 100vw !important; box-sizing: border-box !important; overflow-x: hidden !important; }
    .main { padding: 16px 12px 40px !important; min-width: 0 !important; }
    .mainInner { padding: 0 !important; }
    .topbar { padding: 0 12px !important; gap: 8px; }
    .topbar .brand span { font-size: 0.9rem; }
    .pg-header { flex-direction: column !important; align-items: flex-start !important; gap: 10px !important; }
    .pg-header h4 { font-size: 1.1rem !important; }
    .header-card { padding: 18px 14px !important; border-radius: 14px !important; }
    .header-card > .d-flex { flex-direction: column !important; align-items: flex-start !important; gap: 14px !important; }
    .avatar-box { width: 80px !important; height: 80px !important; border-radius: 14px !important; }
    .header-card h1 { font-size: 1.25rem !important; }
    .review-card { padding: 16px 14px !important; border-radius: 14px !important; }
    .info-grid { grid-template-columns: 1fr !important; gap: 12px !important; }
    .action-bar { justify-content: stretch !important; }
    .action-bar form, .btn-verify, .btn-changes, .btn-reject { width: 100% !important; justify-content: center !important; }
  }
</style>
</head>
<body>

<c:set var="statusKey" value="${provider.partnerProfileStatus != null ? provider.partnerProfileStatus.name() : (provider.verificationStatus != null ? provider.verificationStatus.name() : 'PENDING')}"/>
<c:set var="pct" value="${provider.profileCompletionPct != null ? provider.profileCompletionPct : 0}"/>
<c:set var="categoryName" value="${provider.category != null ? provider.category.displayName : 'Women Lawyer'}"/>

<c:set var="photoPath" value="${not empty provider.profilePhoto ? provider.profilePhoto : provider.profileImageUrl}"/>
<c:set var="photoOk" value="${not empty photoPath && photoPath != 'web-pending' && photoPath != 'mobile-pending'}"/>

<c:set var="idDocPath" value="${provider.identityDocumentPath}"/>
<c:set var="idDocOk" value="${not empty idDocPath && idDocPath != 'web-pending' && idDocPath != 'mobile-pending'}"/>

<c:set var="chamberPath" value="${provider.galleryPhotos}"/>
<c:set var="chamberOk" value="${not empty chamberPath && chamberPath != 'web-pending' && chamberPath != 'mobile-pending'}"/>

<!-- Topbar -->
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
    <span class="badge bg-light text-dark fw-bold px-3 py-2 d-none d-sm-inline">
      ${categoryName} Review
    </span>
    <a href="${pageContext.request.contextPath}/admin/logout" class="btn-logout">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>
</div>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="mainInner">

      <div class="pg-header">
        <div>
          <h4>${categoryName} Application</h4>
          <p>Full cross-check verification details before decision</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pending-providers<c:if test="${not empty provider.category}">?category=${provider.category.name()}</c:if>" class="btn-back">
          <i class="fas fa-arrow-left me-1"></i> Back to Queue
        </a>
      </div>

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

      <a href="${pageContext.request.contextPath}/admin/pending-providers<c:if test="${not empty provider.category}">?category=${provider.category.name()}</c:if>" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Service Partners
      </a>

      <!-- Header Card -->
      <div class="header-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
            <c:choose>
              <c:when test="${photoOk}">
                <c:set var="finalPhotoUrl" value="${photoPath}"/>
                <c:if test="${not fn:startsWith(photoPath, 'http') and not fn:startsWith(photoPath, '/')}">
                  <c:set var="finalPhotoUrl" value="${pageContext.request.contextPath}/uploads/${photoPath}"/>
                </c:if>
                <c:if test="${fn:startsWith(photoPath, '/')}">
                  <c:set var="finalPhotoUrl" value="${pageContext.request.contextPath}${photoPath}"/>
                </c:if>
                <img src="${finalPhotoUrl}" alt="${provider.fullName}">
              </c:when>
              <c:otherwise>
                <div class="w-100 h-100 d-flex align-items-center justify-content-center" style="background: var(--rose-soft);">
                  <i class="fas fa-gavel" style="font-size:2.6rem;color:var(--primary);"></i>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="flex-grow-1" style="position:relative;z-index:1;">
            <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
              <h1>${not empty provider.fullName ? provider.fullName : 'Unnamed Provider'}</h1>
              <span class="badge-status-lg status-${statusKey}">
                <c:choose>
                  <c:when test="${statusKey == 'APPROVED'}"><i class="fas fa-check-circle"></i> Approved</c:when>
                  <c:when test="${statusKey == 'VERIFIED'}"><i class="fas fa-check-circle"></i> Verified</c:when>
                  <c:when test="${statusKey == 'CHANGES_REQUESTED'}"><i class="fas fa-edit"></i> Changes Requested</c:when>
                  <c:when test="${statusKey == 'REJECTED'}"><i class="fas fa-times-circle"></i> Rejected</c:when>
                  <c:when test="${statusKey == 'REGISTERED'}"><i class="fas fa-user-check"></i> Registered</c:when>
                  <c:otherwise><i class="fas fa-clock"></i> Pending Admin Approval</c:otherwise>
                </c:choose>
              </span>
            </div>
            <div class="d-flex flex-wrap gap-3 gap-md-4 text-muted small mb-3">
              <div>
                <i class="bi bi-envelope-fill text-danger"></i>
                <c:choose>
                  <c:when test="${not empty provider.email}"><a href="mailto:${provider.email}" class="text-dark text-decoration-none fw-semibold">${provider.email}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill text-danger"></i>
                <c:choose>
                  <c:when test="${not empty provider.phone}"><a href="tel:${provider.phone}" class="text-dark text-decoration-none fw-semibold">${provider.phone}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
              <c:if test="${not empty provider.whatsappNumber}">
                <div>
                  <i class="bi bi-whatsapp text-success"></i>
                  <a href="https://wa.me/${provider.whatsappNumber}" target="_blank" class="text-dark text-decoration-none fw-semibold">${provider.whatsappNumber}</a>
                </div>
              </c:if>
              <div>
                <i class="fas fa-tag text-danger"></i>
                <span class="text-dark fw-semibold">${categoryName}</span>
              </div>
            </div>
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold text-dark mb-1">
                <span>Profile Completion</span>
                <span class="text-danger">${pct}%</span>
              </div>
              <div class="progress-wrap">
                <div class="progress-bar-fill" style="width:${pct}%;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Section 1: Personal Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-person-badge-fill"></i>
          <h3>1. Personal & Contact Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Full Name</span>
            <span class="info-field-value">${not empty provider.fullName ? provider.fullName : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Email</span>
            <span class="info-field-value">${not empty provider.email ? provider.email : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Phone</span>
            <span class="info-field-value">${not empty provider.phone ? provider.phone : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">WhatsApp Number</span>
            <span class="info-field-value">${not empty provider.whatsappNumber ? provider.whatsappNumber : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Category</span>
            <span class="info-field-value">${categoryName}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Designation / Title</span>
            <span class="info-field-value">${not empty provider.designation ? provider.designation : 'Advocate'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Languages Known</span>
            <span class="info-field-value">${not empty provider.languages ? provider.languages : 'Not provided'}</span>
          </div>
        </div>
      </div>

      <!-- Section 2: Professional & Legal Details -->
      <div class="review-card">
        <div class="section-header">
          <i class="fas fa-balance-scale"></i>
          <h3>2. Professional & Legal Credentials</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Bar Council / Enrollment ID</span>
            <span class="info-field-value">${not empty provider.barCouncilId ? provider.barCouncilId : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Years of Experience</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${provider.experienceYears != null}">${provider.experienceYears} Years</c:when>
                <c:when test="${not empty provider.experience}">${provider.experience}</c:when>
                <c:otherwise>0 Years</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Consultation Fee</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${provider.consultationFee != null && provider.consultationFee > 0}">₹<fmt:formatNumber value="${provider.consultationFee}" maxFractionDigits="0"/></c:when>
                <c:otherwise>Not set</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Service Mode</span>
            <span class="info-field-value">${not empty provider.serviceMode ? provider.serviceMode : (not empty provider.consultationMode ? provider.consultationMode : 'Online / Offline')}</span>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Practice Areas / Specializations</span>
            <c:choose>
              <c:when test="${not empty provider.practiceAreas}">
                <div class="mt-1">
                  <c:forEach var="area" items="${fn:split(provider.practiceAreas, ',')}">
                    <span class="tag-pill">${fn:trim(area)}</span>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Who They Serve / Audience</span>
            <c:choose>
              <c:when test="${not empty provider.audience}">
                <div class="mt-1">
                  <c:forEach var="aud" items="${fn:split(provider.audience, ',')}">
                    <span class="tag-pill">${fn:trim(aud)}</span>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Chamber Facilities</span>
            <c:choose>
              <c:when test="${not empty provider.facilities}">
                <div class="mt-1">
                  <c:forEach var="fac" items="${fn:split(provider.facilities, ',')}">
                    <span class="tag-pill" style="background:#ECFDF5; color:#065F46; border-color:#A7F3D0;"><i class="bi bi-check2"></i> ${fn:trim(fac)}</span>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- Section 3: Chamber Address & Location -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-geo-alt-fill"></i>
          <h3>3. Chamber Location & Address</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Chamber / Office Address</span>
            <span class="info-field-value">${not empty provider.address ? provider.address : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">City</span>
            <span class="info-field-value">${not empty provider.city ? provider.city : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">State</span>
            <span class="info-field-value">${not empty provider.state ? provider.state : 'Not provided'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Country</span>
            <span class="info-field-value">${not empty provider.country ? provider.country : 'India'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Pincode</span>
            <span class="info-field-value">${not empty provider.pincode ? provider.pincode : 'Not provided'}</span>
          </div>
        </div>
      </div>

      <!-- Section 4: Timings & Operating Days -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clock-fill"></i>
          <h3>4. Operating Days & Hours</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Operating Days</span>
            <span class="info-field-value">${not empty provider.openDays ? provider.openDays : (not empty provider.availableDays ? provider.availableDays : 'Not provided')}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Working Hours</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${not empty provider.openTime && not empty provider.closeTime}">
                  ${provider.openTime} – ${provider.closeTime}
                </c:when>
                <c:when test="${not empty provider.workingHoursFrom && not empty provider.workingHoursTo}">
                  ${provider.workingHoursFrom} – ${provider.workingHoursTo}
                </c:when>
                <c:otherwise>Not provided</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Consultation Duration</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${provider.durationMinutes != null}">${provider.durationMinutes} Minutes</c:when>
                <c:otherwise>60 Minutes</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Buffer Time</span>
            <span class="info-field-value">
              <c:choose>
                <c:when test="${provider.bufferMinutes != null}">${provider.bufferMinutes} Minutes</c:when>
                <c:otherwise>15 Minutes</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>
      </div>

      <!-- Section 5: Bank & Payout Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-bank2"></i>
          <h3>5. Bank & Payout Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">UPI ID</span>
            <span class="info-field-value">${not empty provider.upiId ? provider.upiId : 'Not provided'}</span>
          </div>
          <c:choose>
            <c:when test="${not empty provider.bankDetails && fn:contains(provider.bankDetails, '|')}">
              <c:forEach var="part" items="${fn:split(provider.bankDetails, '|')}">
                <div class="info-field">
                  <span class="info-field-label">${fn:trim(fn:substringBefore(part, ':'))}</span>
                  <span class="info-field-value">${fn:trim(fn:substringAfter(part, ':'))}</span>
                </div>
              </c:forEach>
            </c:when>
            <c:when test="${not empty provider.bankDetails}">
              <div class="info-field span-all">
                <span class="info-field-label">Bank Account Details</span>
                <span class="info-field-value" style="white-space:pre-wrap;">${provider.bankDetails}</span>
              </div>
            </c:when>
            <c:otherwise>
              <div class="info-field span-all">
                <span class="empty-text">No bank details provided.</span>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- Section 6: About / Bio -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-chat-quote-fill"></i>
          <h3>6. Professional Bio / Description</h3>
        </div>
        <c:choose>
          <c:when test="${not empty provider.bio}"><div class="bio-box"><c:out value="${provider.bio}"/></div></c:when>
          <c:when test="${not empty provider.description}"><div class="bio-box"><c:out value="${provider.description}"/></div></c:when>
          <c:otherwise><span class="empty-text">No bio provided.</span></c:otherwise>
        </c:choose>
      </div>

      <!-- Section 7: Documents & Chamber Photos -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-earmark-check-fill"></i>
          <h3>7. Verification Documents & Photos</h3>
        </div>
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-image"></i></div>
          <div>
            <div class="info-field-label">Profile Photo</div>
            <c:choose>
              <c:when test="${photoOk}">
                <c:set var="finalPhotoUrl" value="${photoPath}"/>
                <c:if test="${not fn:startsWith(photoPath, 'http') and not fn:startsWith(photoPath, '/')}">
                  <c:set var="finalPhotoUrl" value="${pageContext.request.contextPath}/uploads/${photoPath}"/>
                </c:if>
                <c:if test="${fn:startsWith(photoPath, '/')}">
                  <c:set var="finalPhotoUrl" value="${pageContext.request.contextPath}${photoPath}"/>
                </c:if>
                <a href="${finalPhotoUrl}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View Profile Photo</a>
              </c:when>
              <c:otherwise><span class="empty-text">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div>
            <div class="info-field-label">Bar Council / Identity Proof Document</div>
            <c:choose>
              <c:when test="${idDocOk}">
                <c:set var="finalDocUrl" value="${idDocPath}"/>
                <c:if test="${not fn:startsWith(idDocPath, 'http') and not fn:startsWith(idDocPath, '/')}">
                  <c:set var="finalDocUrl" value="${pageContext.request.contextPath}/uploads/${idDocPath}"/>
                </c:if>
                <c:if test="${fn:startsWith(idDocPath, '/')}">
                  <c:set var="finalDocUrl" value="${pageContext.request.contextPath}${idDocPath}"/>
                </c:if>
                <a href="${finalDocUrl}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View Identity Document</a>
              </c:when>
              <c:otherwise><span class="empty-text">Not uploaded / Pending</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="doc-row mb-0">
          <div class="doc-icon"><i class="bi bi-building"></i></div>
          <div>
            <div class="info-field-label">Chamber / Office Photo</div>
            <c:choose>
              <c:when test="${chamberOk}">
                <c:set var="finalChamberUrl" value="${chamberPath}"/>
                <c:if test="${not fn:startsWith(chamberPath, 'http') and not fn:startsWith(chamberPath, '/')}">
                  <c:set var="finalChamberUrl" value="${pageContext.request.contextPath}/uploads/${chamberPath}"/>
                </c:if>
                <c:if test="${fn:startsWith(chamberPath, '/')}">
                  <c:set var="finalChamberUrl" value="${pageContext.request.contextPath}${chamberPath}"/>
                </c:if>
                <a href="${finalChamberUrl}" target="_blank" class="doc-link"><i class="fas fa-external-link-alt"></i> View Chamber Photo</a>
              </c:when>
              <c:otherwise><span class="empty-text">Not uploaded</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- Section 8: Admin Decision Panel -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-gavel"></i>
          <h3>8. Administrator Decision</h3>
        </div>

        <div class="mb-3">
          <div class="info-field-label mb-2">Current Application Status</div>
          <span class="badge-status-lg status-${statusKey}">
            <c:choose>
              <c:when test="${statusKey == 'APPROVED'}"><i class="fas fa-check-circle"></i> Approved & Verified</c:when>
              <c:when test="${statusKey == 'VERIFIED'}"><i class="fas fa-check-circle"></i> Approved & Verified</c:when>
              <c:when test="${statusKey == 'CHANGES_REQUESTED'}"><i class="fas fa-edit"></i> Changes Requested</c:when>
              <c:when test="${statusKey == 'REJECTED'}"><i class="fas fa-times-circle"></i> Application Rejected</c:when>
              <c:when test="${statusKey == 'REGISTERED'}"><i class="fas fa-user-check"></i> Registered</c:when>
              <c:otherwise><i class="fas fa-clock"></i> Pending Admin Verification</c:otherwise>
            </c:choose>
          </span>

          <c:if test="${not empty provider.changesRequestedNote}">
            <div class="mt-2 text-warning small p-2 rounded" style="background:#FFFBEB; border:1px solid #FDE68A;">
              <strong>Changes requested:</strong> <c:out value="${provider.changesRequestedNote}"/>
            </div>
          </c:if>
          <c:if test="${not empty provider.rejectionReason}">
            <div class="mt-2 text-danger small p-2 rounded" style="background:#FEF2F2; border:1px solid #FECACA;">
              <strong>Rejection reason:</strong> <c:out value="${provider.rejectionReason}"/>
            </div>
          </c:if>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Decision notes / comments</label>
          <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the provider (required for reject / request changes)"></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Request-change reasons (optional)</label>
          <div class="d-flex flex-wrap gap-2 reason-checks">
            <label><input type="checkbox" class="reason-box" value="Bar Council ID Proof"> Bar Council ID Proof</label>
            <label><input type="checkbox" class="reason-box" value="Chamber Address & Location"> Chamber Address</label>
            <label><input type="checkbox" class="reason-box" value="Practice Areas"> Practice Areas</label>
            <label><input type="checkbox" class="reason-box" value="Consultation Fee & Hours"> Fee & Timings</label>
            <label><input type="checkbox" class="reason-box" value="Bank Details"> Bank Details</label>
            <label><input type="checkbox" class="reason-box" value="Profile Photo"> Profile Photo</label>
          </div>
        </div>

        <div class="action-bar">
          <c:if test="${statusKey != 'APPROVED' && statusKey != 'VERIFIED'}">
            <form id="approveForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/verify" method="post" class="m-0">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <button type="submit" class="btn-verify" onclick="return confirm('Are you sure you want to approve and verify this provider?');">
                <i class="fas fa-check-circle"></i> Approve & Verify
              </button>
            </form>
          </c:if>

          <c:if test="${statusKey != 'REJECTED' && statusKey != 'SUSPENDED'}">
            <form id="changesForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/request-changes" method="post" class="m-0">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <input type="hidden" name="note" id="changesNote">
              <button type="submit" class="btn-changes" onclick="
                const noteVal = document.getElementById('decisionNotes').value.trim();
                const checked = Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                const combined = checked ? (noteVal ? noteVal + ' (Reasons: ' + checked + ')' : 'Please review: ' + checked) : noteVal;
                if(!combined) { alert('Please enter decision notes or select reasons for requesting changes.'); return false; }
                document.getElementById('changesNote').value = combined;
              ">
                <i class="fas fa-edit"></i> Request Changes
              </button>
            </form>
          </c:if>

          <c:if test="${statusKey != 'REJECTED'}">
            <form id="rejectForm" action="${pageContext.request.contextPath}/admin/providers/${provider.id}/reject" method="post" class="m-0"
                  onsubmit="return confirm('Are you sure you want to reject this provider application?')">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <input type="hidden" name="reason" id="rejectReason">
              <button type="submit" class="btn-reject" onclick="
                const noteVal = document.getElementById('decisionNotes').value.trim();
                const checked = Array.from(document.querySelectorAll('.reason-box:checked')).map(e=>e.value).join(', ');
                const combined = checked ? (noteVal ? noteVal + ' (Reasons: ' + checked + ')' : 'Rejected due to: ' + checked) : noteVal;
                if(!combined) { alert('Please enter a rejection reason or select reasons.'); return false; }
                document.getElementById('rejectReason').value = combined;
              ">
                <i class="fas fa-times-circle"></i> Reject
              </button>
            </form>
          </c:if>
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
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
