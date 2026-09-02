<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${not empty salon.name ? salon.name : 'Salon'} - Application Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  body.ap-page { margin: 0; }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  .mainInner { max-width: 1100px; margin: 0 auto; padding: 22px 24px 48px; }

  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    text-decoration: none; font-weight: 600; font-size: 0.88rem; margin-bottom: 14px;
  }
  .back-nav:hover { color: var(--ap-accent); }

  .header-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 18px; box-shadow: var(--ap-shadow);
  }
  .header-card h1 { margin: 0; font-size: 1.45rem; font-weight: 800; color: var(--ap-text); font-family: Outfit, Poppins, sans-serif; }
  .header-card .contact-line { color: var(--ap-muted); font-size: 0.88rem; }
  .header-card .contact-line a { color: var(--ap-text); text-decoration: none; font-weight: 600; }
  .avatar-box {
    width: 96px; height: 96px; border-radius: 12px; overflow: hidden; flex-shrink: 0;
    border: 3px solid #FFE4E6; background: var(--ap-accent-soft);
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .progress-wrap { height: 8px; background: #F1F5F9; border-radius: 999px; overflow: hidden; }
  .progress-bar-fill { height: 100%; background: var(--ap-accent); border-radius: 999px; }

  .review-card {
    background: var(--ap-card); border: 1px solid var(--ap-border); border-radius: 16px;
    padding: 22px; margin-bottom: 16px; box-shadow: var(--ap-shadow);
  }
  .section-header {
    display: flex; align-items: center; gap: 10px; margin-bottom: 16px;
    padding-bottom: 12px; border-bottom: 1px solid var(--ap-border);
  }
  .section-header i {
    width: 34px; height: 34px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: inline-flex; align-items: center; justify-content: center;
  }
  .section-header h3 { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--ap-text); }

  .info-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: 14px 18px; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    display: block; font-size: 0.72rem; font-weight: 700; color: var(--ap-muted);
    text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px;
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-text); word-break: break-word; }
  .empty-text { color: #94A3B8; font-size: 0.88rem; font-style: italic; }

  .badge-status-lg {
    display: inline-flex; align-items: center; padding: 6px 12px; border-radius: 999px;
    font-size: 0.75rem; font-weight: 800; letter-spacing: 0.02em;
  }
  .status-APPROVED, .status-VERIFIED { background: var(--ap-success-bg); color: var(--ap-success); }
  .status-REJECTED { background: var(--ap-danger-bg); color: var(--ap-danger); }
  .status-CHANGES_REQUESTED { background: #FFEDD5; color: #C2410C; }
  .status-PROFILE_INCOMPLETE, .status-PENDING, .status-PENDING_ADMIN_APPROVAL,
  .status-READY_FOR_VERIFICATION, .status-REGISTERED { background: #FEF3C7; color: #B45309; }

  .tag-pill {
    display: inline-flex; padding: 4px 10px; border-radius: 999px; background: #F8FAFC;
    border: 1px solid var(--ap-border); font-size: 0.78rem; font-weight: 600; margin: 0 6px 6px 0; color: #334155;
  }
  .fee-tile {
    border: 1px solid var(--ap-border); border-radius: 12px; padding: 12px; background: #FCFCFD; height: 100%;
  }
  .fee-tile .amt { font-size: 1.1rem; font-weight: 800; color: var(--ap-text); }

  .doc-row {
    display: flex; align-items: center; gap: 12px; padding: 12px; border: 1px solid var(--ap-border);
    border-radius: 12px; margin-bottom: 10px; background: #fff;
  }
  .doc-icon {
    width: 40px; height: 40px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0;
  }
  .doc-link { color: var(--ap-accent); font-weight: 700; text-decoration: none; font-size: 0.86rem; }
  .doc-link:hover { text-decoration: underline; }
  .warn-mobile { color: #B45309; font-size: 0.82rem; font-weight: 600; }

  .history-table th { font-size: 0.72rem; color: var(--ap-muted); text-transform: uppercase; }
  .history-table td { font-size: 0.84rem; vertical-align: top; }

  .action-bar { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }
  .btn-verify, .btn-reject, .btn-changes {
    border: 0; border-radius: 10px; padding: 12px 22px; font-weight: 700; font-size: 0.9rem;
    display: inline-flex; align-items: center; gap: 8px; cursor: pointer;
  }
  .btn-verify { background: var(--ap-success); color: #fff; }
  .btn-changes { background: var(--ap-warn); color: #fff; }
  .btn-reject { background: var(--ap-danger); color: #fff; }
  .reason-checks label {
    display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--ap-border);
    border-radius: 999px; padding: 6px 12px; font-size: 0.82rem; background: #fff; cursor: pointer;
  }

  @media (max-width: 768px) {
    .mainInner { padding: 16px 14px 40px; }
    .info-grid { grid-template-columns: 1fr; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .btn-changes { width: 100%; justify-content: center; }
  }
</style>
</head>
<body class="ap-page">

<c:set var="displayName" value="${salon.name}"/>
<c:set var="displayEmail" value="${salon.email}"/>
<c:set var="displayPhone" value="${salon.phone}"/>
<c:set var="photoPath" value="${salon.profileImageUrl}"/>
<c:set var="photoOk" value="${not empty photoPath and photoPath != 'mobile-pending' and not fn:startsWith(photoPath, 'mobile:')}"/>
<c:set var="pct" value="${salon.profileCompletionPct != null ? salon.profileCompletionPct : 100}"/>
<c:set var="statusKey" value="${not empty salon.partnerProfileStatus ? salon.partnerProfileStatus : (salon.approved ? 'APPROVED' : 'PENDING_ADMIN_APPROVAL')}"/>
<c:set var="displayStatus" value="${statusKey}"/>

<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>

  <main class="main">
    <div class="ap-topbar">
      <div class="ap-topbar-left">
        <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
        <div class="ap-search" style="max-width:320px;">
          <i class="fas fa-search"></i>
          <input type="search" placeholder="Search anything..." aria-label="Search" readonly
                 onclick="window.location.href='${pageContext.request.contextPath}/admin/salons'">
          <span class="ap-kbd">Ctrl + K</span>
        </div>
      </div>
      <div style="display:flex;align-items:center;gap:10px;">
        <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
          <i class="fas fa-bell"></i>
          <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
        </a>
        <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
          <span class="ap-avatar">${fn:substring(admin.name,0,1)}</span>
          <span>
            <div class="name"><c:out value="${admin.name}"/></div>
            <div class="role">Super Admin</div>
          </span>
        </a>
      </div>
    </div>

    <div class="mainInner">
      <nav class="ap-crumb">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
        <span class="sep">&gt;</span>
        <a href="${pageContext.request.contextPath}/admin/salons">Beauty and Wellness</a>
        <span class="sep">&gt;</span>
        <span>Review</span>
      </nav>

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

      <a href="${pageContext.request.contextPath}/admin/salons" class="back-nav">
        <i class="bi bi-arrow-left"></i> Back to Queue
      </a>

      <!-- 1. Applicant header -->
      <div class="header-card">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
          <div class="avatar-box">
            <c:choose>
              <c:when test="${photoOk}">
                <img src="${fn:startsWith(photoPath, 'http') ? photoPath : pageContext.request.contextPath.concat(photoPath)}" alt="${displayName}">
              </c:when>
              <c:otherwise>
                <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light">
                  <i class="bi bi-shop" style="font-size:2.6rem;color:#94a3b8;"></i>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="flex-grow-1" style="position:relative;z-index:1;">
            <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
              <h1>${not empty displayName ? displayName : 'Unnamed salon'}</h1>
              <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
            </div>
            <div class="d-flex flex-wrap gap-3 gap-md-4 contact-line small mb-3">
              <div>
                <i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty displayEmail}"><a href="mailto:${displayEmail}" class="text-decoration-none">${displayEmail}</a></c:when>
                  <c:otherwise>No email</c:otherwise>
                </c:choose>
              </div>
              <div>
                <i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i>
                <c:choose>
                  <c:when test="${not empty displayPhone}"><a href="tel:${displayPhone}" class="text-decoration-none">${displayPhone}</a></c:when>
                  <c:otherwise>No phone</c:otherwise>
                </c:choose>
              </div>
            </div>
            <div style="max-width:480px;">
              <div class="d-flex justify-content-between small fw-bold mb-1">
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

      <!-- 2. Personal Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-building"></i>
          <h3>1. Business Information</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Business name</span>
            <span class="info-field-value">${not empty displayName ? displayName : ''}</span>
            <c:if test="${empty displayName}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Email</span>
            <span class="info-field-value">${not empty displayEmail ? displayEmail : ''}</span>
            <c:if test="${empty displayEmail}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Phone</span>
            <span class="info-field-value">${not empty displayPhone ? displayPhone : ''}</span>
            <c:if test="${empty displayPhone}"><span class="empty-text">Not provided</span></c:if>
          </div>
          <div class="info-field">
            <span class="info-field-label">Established Year</span>
            <c:choose>
              <c:when test="${not empty salon.establishedYear}"><span class="info-field-value">${salon.establishedYear}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Business Bio</span>
            <div class="bio-box mt-1">
              <c:choose>
                <c:when test="${not empty salon.bio}">${salon.bio}</c:when>
                <c:otherwise><span class="empty-text">No bio provided.</span></c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- 3. Professional Information -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-star-fill"></i>
          <h3>2. Features & Setup</h3>
        </div>
        <div class="info-grid">
          <div class="info-field">
            <span class="info-field-label">Salon Category</span>
            <c:choose>
              <c:when test="${not empty salon.salonCategory}"><span class="info-field-value">${salon.salonCategory}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Women Only</span>
            <span class="info-field-value">${salon.isWomenOnly ? 'Yes' : 'No'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Eco-Friendly</span>
            <span class="info-field-value">${salon.isEcoFriendly ? 'Yes' : 'No'}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Certified</span>
            <span class="info-field-value">${salon.isCertified ? 'Yes' : 'No'}</span>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Categories Offered</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty salon.categoriesOffered}">
                  <c:forEach var="cat" items="${fn:split(salon.categoriesOffered, ',')}">
                    <span class="tag-pill">${fn:trim(cat)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Facilities</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty salon.facilities}">
                  <c:forEach var="fac" items="${fn:split(salon.facilities, ',')}">
                    <span class="tag-pill">${fn:trim(fac)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>

      <!-- 4. Practice / Address -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-geo-alt-fill"></i>
          <h3>3. Address / Location</h3>
        </div>
        <div class="info-grid">
          <div class="info-field span-all">
            <span class="info-field-label">Address</span>
            <c:choose>
              <c:when test="${not empty salon.address}"><span class="info-field-value">${salon.address}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">City</span>
            <c:choose>
              <c:when test="${not empty salon.city}"><span class="info-field-value">${salon.city}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">State</span>
            <c:choose>
              <c:when test="${not empty salon.state}"><span class="info-field-value">${salon.state}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field">
            <span class="info-field-label">Pincode</span>
            <c:choose>
              <c:when test="${not empty salon.pincode}"><span class="info-field-value">${salon.pincode}</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 5. Consultation & Availability -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clock-fill"></i>
          <h3>4. Schedule & Availability</h3>
        </div>
        <div class="info-grid mb-3">
          <div class="info-field span-all">
            <span class="info-field-label">Working Hours</span>
            <c:choose>
              <c:when test="${not empty salon.availabilityHours}">
                <span class="info-field-value">${salon.availabilityHours}</span>
              </c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
          <div class="info-field span-all">
            <span class="info-field-label">Open Days</span>
            <div class="mt-1">
              <c:choose>
                <c:when test="${not empty salon.openDays}">
                  <c:forEach var="day" items="${fn:split(salon.openDays, ',')}">
                    <span class="tag-pill">${fn:trim(day)}</span>
                  </c:forEach>
                </c:when>
                <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="info-field">
            <span class="info-field-label">Door Service Available</span>
            <c:choose>
              <c:when test="${salon.doorService == true}"><span class="badge bg-success">Yes</span></c:when>
              <c:when test="${salon.doorService == false}"><span class="badge bg-secondary">No</span></c:when>
              <c:otherwise><span class="empty-text">Not provided</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 6. Documents -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-file-earmark-medical-fill"></i>
          <h3>5. Documents</h3>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-shop"></i></div>
          <div>
            <div class="info-field-label">Profile Image</div>
            <c:choose>
              <c:when test="${empty salon.profileImageUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.profileImageUrl, 'http') ? salon.profileImageUrl : pageContext.request.contextPath.concat(salon.profileImageUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View image
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div>
            <div class="info-field-label">Business Registration</div>
            <c:choose>
              <c:when test="${empty salon.businessRegistrationUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.businessRegistrationUrl, 'http') ? salon.businessRegistrationUrl : pageContext.request.contextPath.concat(salon.businessRegistrationUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View registration
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-award"></i></div>
          <div>
            <div class="info-field-label">Salon License</div>
            <c:choose>
              <c:when test="${empty salon.salonLicenseUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.salonLicenseUrl, 'http') ? salon.salonLicenseUrl : pageContext.request.contextPath.concat(salon.salonLicenseUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View license
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-shield-check"></i></div>
          <div>
            <div class="info-field-label">Hygiene Certificate</div>
            <c:choose>
              <c:when test="${empty salon.hygieneCertificateUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.hygieneCertificateUrl, 'http') ? salon.hygieneCertificateUrl : pageContext.request.contextPath.concat(salon.hygieneCertificateUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View certificate
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-fire"></i></div>
          <div>
            <div class="info-field-label">Fire Safety Document</div>
            <c:choose>
              <c:when test="${empty salon.fireSafetyUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.fireSafetyUrl, 'http') ? salon.fireSafetyUrl : pageContext.request.contextPath.concat(salon.fireSafetyUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View document
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
        
        <div class="doc-row">
          <div class="doc-icon"><i class="bi bi-receipt"></i></div>
          <div>
            <div class="info-field-label">GST Certificate</div>
            <c:choose>
              <c:when test="${empty salon.gstCertificateUrl}"><div class="empty-text">Not uploaded</div></c:when>
              <c:otherwise>
                <a class="doc-link" href="${fn:startsWith(salon.gstCertificateUrl, 'http') ? salon.gstCertificateUrl : pageContext.request.contextPath.concat(salon.gstCertificateUrl)}" target="_blank" rel="noopener">
                  <i class="bi bi-box-arrow-up-right me-1"></i> View certificate
                </a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <!-- 7. Application / Audit -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-clipboard-check-fill"></i>
          <h3>6. Application / Audit</h3>
        </div>
        <div class="info-grid mb-3">
          <div class="info-field">
            <span class="info-field-label">Status</span>
            <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
          </div>
          <div class="info-field">
            <span class="info-field-label">Submitted for verification</span>
            <c:choose>
              <c:when test="${salon.submittedForVerificationAt != null}">
                <span class="info-field-value">${salon.submittedForVerificationAt}</span>
              </c:when>
              <c:otherwise><span class="empty-text">Not recorded</span></c:otherwise>
            </c:choose>
          </div>
        </div>

        <c:if test="${not empty salon.rejectionReason}">
          <div class="alert alert-danger rounded-3">
            <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection reason:</strong>
            <div class="mt-1">${salon.rejectionReason}</div>
          </div>
        </c:if>
        <c:if test="${not empty salon.changesRequestedNote}">
          <div class="alert alert-warning rounded-3">
            <strong><i class="bi bi-pencil-square me-1"></i> Changes requested:</strong>
            <div class="mt-1">${salon.changesRequestedNote}</div>
          </div>
        </c:if>
      </div>

      <!-- 8. Admin Decision -->
      <div class="review-card">
        <div class="section-header">
          <i class="bi bi-gavel"></i>
          <h3>7. Admin Decision</h3>
        </div>
        <div class="mb-3">
          <span class="badge-status-lg status-${statusKey}">${displayStatus}</span>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Decision notes / comments</label>
          <textarea id="decisionNotes" class="form-control" rows="3" placeholder="Add comments for the salon (required for reject / request changes)"></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold">Request-change reasons (optional checkboxes)</label>
          <div class="d-flex flex-wrap gap-2 reason-checks">
            <label><input type="checkbox" class="reason-box" value="Business information"> Business information</label>
            <label><input type="checkbox" class="reason-box" value="Facilities setup"> Facilities setup</label>
            <label><input type="checkbox" class="reason-box" value="Address details"> Address details</label>
            <label><input type="checkbox" class="reason-box" value="Documents"> Documents</label>
            <label><input type="checkbox" class="reason-box" value="Availability"> Availability</label>
          </div>
        </div>

        <div class="action-bar">
          <form id="approveForm" action="${pageContext.request.contextPath}/admin/salons/${salon.id}/approve" method="post" class="m-0 p-0">
            <input type="hidden" name="notes" id="approveNotes">
            <button type="submit" class="btn-verify" onclick="document.getElementById('approveNotes').value=document.getElementById('decisionNotes').value;">
              <i class="fas fa-check-circle"></i> Approve
            </button>
          </form>

          <form id="rejectForm" action="${pageContext.request.contextPath}/admin/salons/${salon.id}/reject" method="post" class="m-0 p-0"
                onsubmit="return confirm('Reject this salon?')">
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

</body>
</html>div>

</body>
</html>
