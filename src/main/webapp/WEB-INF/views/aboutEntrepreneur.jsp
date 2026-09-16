<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><c:out value="${entrepreneur.fullName}"/> � Entrepreneur Profile Review | Fight D Fear Admin</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
<style>
  :root {
    /* 10% ACCENT */
    --ap-accent: #F43F5E;
    --ap-accent-hover: #E11D48;
    --ap-accent-soft: #FFF1F2;
    --ap-accent-surface: #FFF5F6;
    --ap-accent-border: #FECDD3;
    --ap-accent-text: #BE123C;
=======
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title><c:out value="${entrepreneur.fullName}"/> — Entrepreneur Profile Review | Fight D Fear Admin</title>

    /* 60% PRIMARY SURFACE */
    --ap-bg: #F8FAFC;
    --ap-card: #FFFFFF;

    /* 30% SECONDARY STRUCTURE */
    --ap-border: #E2E8F0;
    --ap-border-subtle: #F1F5F9;

    /* TEXT */
    --ap-text: #0F172A;
    --ap-navy: #0F172A;
    --ap-navy-mid: #1E293B;
    --ap-muted: #64748B;
    --sidebar-w: 272px;
  }
  * { box-sizing: border-box; }
  body.ap-page {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    background: var(--ap-bg);
    color: var(--ap-text);
  }
  .topbar { display: none !important; }
  .layout { display: flex; min-height: 100vh; }
  .main { flex: 1; min-width: 0; background: var(--ap-bg); }
  .review-container { max-width: 1100px; margin: 0 auto; padding: 22px 24px 60px; }

  /* NAVIGATION & CRUMB */
  .back-nav {
    display: inline-flex; align-items: center; gap: 8px; color: var(--ap-muted);
    font-weight: 600; font-size: 0.88rem; text-decoration: none; margin-bottom: 16px;
    transition: color 0.2s;
  }
  .back-nav:hover { color: var(--ap-accent); }

  /* 60/30/10 HERO PROFILE HEADER CARD */
  .hero-profile-card {
    background: #FFFFFF;
    border: 1px solid var(--ap-accent-border);
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 22px;
    box-shadow: 0 4px 20px rgba(244, 63, 94, 0.06);
    position: relative;
    overflow: hidden;
  }
  .hero-profile-card::after {
    content: ''; position: absolute; right: -40px; top: -40px;
    width: 180px; height: 180px; background: rgba(244, 63, 94, 0.05);
    border-radius: 50%; pointer-events: none;
  }

  .avatar-box {
    width: 112px; height: 112px; border-radius: 20px;
    border: 3px solid var(--ap-accent-border); overflow: hidden;
    background: var(--ap-accent-soft); flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
  }
  .avatar-box img { width: 100%; height: 100%; object-fit: cover; }
  .hero-profile-card h1 {
    font-family: 'Outfit', sans-serif; font-size: 1.6rem; font-weight: 800;
    margin: 0; color: var(--ap-navy);
  }

  .progress-wrap {
    background: var(--ap-accent-soft);
    border-radius: 50px; height: 10px; overflow: hidden; margin-top: 6px;
    border: 1px solid var(--ap-accent-border);
  }
  .progress-bar-fill {
    background: linear-gradient(90deg, #F43F5E, #FB7185);
    height: 100%; border-radius: 50px;
    transition: width 0.4s ease;
  }

  /* BADGES & STATUS PILLS */
  .badge-status-lg {
    padding: 6px 14px; border-radius: 50px; font-size: 0.78rem; font-weight: 700;
    display: inline-flex; align-items: center; gap: 6px;
  }
  .status-APPROVED, .status-VERIFIED { background: #DCFCE7; color: #166534; border: 1px solid #BBF7D0; }
  .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A; }
  .status-READY_FOR_VERIFICATION { background: var(--ap-accent-soft); color: var(--ap-accent-text); border: 1px solid var(--ap-accent-border); }
  .status-CHANGES_REQUESTED { background: #FFEDD5; color: #9A3412; border: 1px solid #FED7AA; }
  .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; }
  .status-REJECTED, .status-SUSPENDED { background: #FEE2E2; color: #991B1B; border: 1px solid #FECACA; }

  /* STRUCTURED REVIEW CARDS (60% Card Surface, 30% Structure) */
  .review-card {
    background: #FFFFFF; border-radius: 16px; border: 1px solid var(--ap-border);
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04); padding: 22px 26px; margin-bottom: 20px;
  }
  .section-header {
    display: flex; align-items: center; gap: 12px; margin-bottom: 18px;
    padding-bottom: 12px; border-bottom: 1px solid var(--ap-border);
  }
  .section-header i {
    width: 36px; height: 36px; border-radius: 10px; background: var(--ap-accent-soft);
    color: var(--ap-accent); font-size: 1.15rem; display: inline-flex;
    align-items: center; justify-content: center; flex-shrink: 0;
  }
  .section-header h3 {
    font-family: 'Outfit', sans-serif; font-size: 1.08rem; font-weight: 700;
    color: var(--ap-navy); margin: 0;
  }

  /* INFO GRID */
  .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
  .info-field { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
  .info-field.span-all { grid-column: 1 / -1; }
  .info-field-label {
    font-size: 0.74rem; font-weight: 700; text-transform: uppercase;
    letter-spacing: 0.55px; color: var(--ap-muted);
  }
  .info-field-value { font-size: 0.95rem; font-weight: 600; color: var(--ap-navy-mid); word-break: break-word; }
  .empty-text { color: var(--ap-muted); font-style: italic; font-weight: 500; font-size: 0.88rem; }

  /* 30% SECONDARY STRUCTURE ELEMENTS */
  .bio-box {
    background: var(--ap-accent-surface); border: 1px solid var(--ap-accent-border); border-radius: 12px;
    padding: 14px 16px; font-size: 0.94rem; line-height: 1.65; color: var(--ap-navy-mid);
  }
  .tag-pill {
    display: inline-flex; align-items: center; background: var(--ap-accent-soft); color: var(--ap-accent-text);
    padding: 5px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;
    margin: 0 6px 6px 0; border: 1px solid var(--ap-accent-border);
  }
  .tag-pill.neutral {
    background: #F8FAFC; color: #475569; border-color: var(--ap-border);
  }
  .tag-pill.success {
    background: #DCFCE7; color: #166534; border-color: #BBF7D0;
  }

  .doc-row {
    display: flex; align-items: center; gap: 14px; padding: 14px 16px;
    border: 1px solid var(--ap-accent-border); border-radius: 12px; background: var(--ap-accent-surface); margin-bottom: 10px;
  }
  .doc-icon {
    width: 46px; height: 46px; border-radius: 10px; background: var(--ap-accent-soft); color: var(--ap-accent);
    display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0;
  }
  .doc-link { color: var(--ap-accent); font-weight: 700; text-decoration: none; }
  .doc-link:hover { text-decoration: underline; color: var(--ap-accent-hover); }

  .batch-row {
    display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap;
    padding: 14px 16px; border: 1px solid var(--ap-border); border-radius: 12px; margin-bottom: 10px; background: #FAFAFC;
  }
  .batch-row:last-child { margin-bottom: 0; }

  .gallery-grid {
    display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px;
  }
  .gallery-item {
    aspect-ratio: 1; border-radius: 12px; overflow: hidden; border: 1px solid var(--ap-border); cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  .gallery-item:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.08); border-color: var(--ap-accent-border); }
  .gallery-item img { width: 100%; height: 100%; object-fit: cover; }

  /* REASON CHECKS */
  .reason-checks label {
    display: inline-flex; align-items: center; gap: 6px; background: #F8FAFC;
    border: 1px solid var(--ap-border); border-radius: 999px; padding: 6px 14px; font-size: 0.82rem; font-weight: 600;
    cursor: pointer; transition: all 0.2s; color: var(--ap-navy-mid);
  }
  .reason-checks label:hover { background: var(--ap-accent-soft); border-color: var(--ap-accent-border); color: var(--ap-accent-text); }
  .reason-checks input { accent-color: var(--ap-accent); }

  /* ACTION BUTTONS */
  .action-bar {
    display: flex; justify-content: flex-end; gap: 10px; flex-wrap: wrap;
    padding-top: 18px; border-top: 1px solid var(--ap-border);
  }
  .btn-verify {
    background: #059669; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-verify:hover { background: #047857; color: #fff; }
  .btn-changes {
    background: #F59E0B; color: #1F2937; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-changes:hover { background: #D97706; color: #1F2937; }
  .btn-reject {
    background: #DC2626; color: #fff; border: none; border-radius: 10px;
    padding: 12px 24px; font-size: 0.95rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 8px; transition: background 0.2s;
  }
  .btn-reject:hover { background: #B91C1C; color: #fff; }
  .btn-delete-acc {
    background: #FFFFFF; color: #DC2626; border: 1.5px solid #DC2626; border-radius: 10px;
    padding: 10px 18px; font-size: 0.88rem; font-weight: 700; cursor: pointer;
    display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s;
  }
  .btn-delete-acc:hover { background: #FEE2E2; color: #991B1B; }

  .missing-list { margin: 0; padding-left: 1.15rem; color: var(--ap-muted); font-size: 0.9rem; }
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
    .review-container { padding: 16px 14px 40px; }
    .hero-profile-card { padding: 20px 16px; }
    .review-card { padding: 18px 14px; }
    .info-grid { grid-template-columns: 1fr; }
    .action-bar { justify-content: stretch; }
    .action-bar form, .action-bar button { width: 100%; }
    .btn-verify, .btn-reject, .btn-changes { width: 100%; justify-content: center; }
    .avatar-box { width: 88px; height: 88px; }
  }
    /* Action Buttons Match Target Theme */
    .action-buttons-container {
        display: flex;
        gap: 16px;
        flex-wrap: wrap;
    }
    .btn-action-approve, .btn-action-changes, .btn-action-reject {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 12px 24px;
        font-family: 'Poppins', sans-serif;
        font-weight: 700;
        font-size: 1.05rem;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: opacity 0.2s, transform 0.1s;
    }
    .btn-action-approve:hover, .btn-action-changes:hover, .btn-action-reject:hover {
        opacity: 0.9;
        transform: translateY(-1px);
    }
    .btn-action-approve {
        background: #0FA958;
        color: white;
    }
    .btn-action-changes {
        background: #F59E0B;
        color: #0F172A;
    }
    .btn-action-reject {
        background: #DE2828;
        color: white;
    }
</style>
</head>
<body class="ap-page">

    
    <div class="layout">
      <%@ include file="globalAdminMenu.jsp" %>
      <main class="main">
        <div class="ap-topbar">
          <div class="ap-topbar-left">
            <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
            <div class="ap-search" style="max-width:360px;">
              <i class="fas fa-search"></i>
              <input type="search" placeholder="Search anything..." aria-label="Search" readonly
                     onclick="window.location.href='${pageContext.request.contextPath}/admin/martialManagement'">
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

        <div class="review-container">

                <!-- 60/30/10 HERO PROFILE HEADER CARD -->
        <div class="hero-profile-card">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="${not empty entrepreneur.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${entrepreneur.profilePhoto}" alt="<c:out value='${entrepreneur.fullName}'/>">
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-person-circle" style="font-size:3.5rem; color:var(--ap-accent);"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1" style="position:relative; z-index:1;">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
                        <h1><c:out value="${entrepreneur.fullName}"/></h1>
                        <c:set var="statusKey" value="${entrepreneur.partnerProfileStatus != null ? entrepreneur.partnerProfileStatus : 'REGISTERED'}"/>
                        <span class="badge-status-lg status-${statusKey}">
                            <i class="bi ${statusKey == 'APPROVED' ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            ${statusKey}
                        </span>
                    </div>

                    <div class="d-flex flex-wrap gap-3 gap-md-4 small mb-3" style="color:var(--ap-muted);">
                        <div><i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i> <a href="mailto:${entrepreneur.email}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="${entrepreneur.email}"/></a></div>
                        <div><i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i> <a href="tel:${entrepreneur.phone}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="${entrepreneur.phone}"/></a></div>
                        <div><i class="bi bi-building me-1" style="color:var(--ap-accent);"></i> <strong style="color:var(--ap-navy-mid);">Business:</strong> <c:out value="${not empty entrepreneur.businessName ? entrepreneur.businessName : 'Not specified'}"/></div>
                        <div><i class="bi bi-geo-alt-fill me-1" style="color:var(--ap-accent);"></i> <span class="fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="${not empty entrepreneur.city ? entrepreneur.city : entrepreneur.businessLocation}"/></span></div>
                    </div>

                    <!-- Profile Completion -->
                    <div style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold mb-1" style="color:var(--ap-navy-mid);">
                            <span>Profile Completion</span>
                            <span style="color:var(--ap-accent); font-weight:800;"><c:out value="${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>%</span>
                        </div>
                        <div class="progress-wrap">
                            <c:set var="pctVal" value="${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>
                            <div class="progress-bar-fill" style="width: ${pctVal}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. PERSONAL IDENTITY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-person-vcard-fill"></i>
                <h3>1. Entrepreneur Personal Identity</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Full Name</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.fullName ? entrepreneur.fullName : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Official Email</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.email ? entrepreneur.email : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Primary Phone</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.phone ? entrepreneur.phone : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">WhatsApp Helpline</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.whatsappNumber ? entrepreneur.whatsappNumber : 'Same as phone'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Date of Birth</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.dob ? entrepreneur.dob : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Gender</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.gender ? entrepreneur.gender : 'Not specified'}"/></span>
                </div>
            </div>
        </div>

        <!-- 2. BUSINESS OVERVIEW -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-briefcase-fill"></i>
                <h3>2. Business & Enterprise Overview</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Business / Venture Name</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessName ? entrepreneur.businessName : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Business Category</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessCategory ? entrepreneur.businessCategory : 'Not specified'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Business Location / Address</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessLocation ? entrepreneur.businessLocation : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">City</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.city ? entrepreneur.city : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">State</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.state ? entrepreneur.state : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Postal Pincode</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.pincode ? entrepreneur.pincode : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 3. FINANCIALS & INVESTMENT NEEDED -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-cash-stack"></i>
                <h3>3. Funding Required & Financial Projections</h3>
            </div>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Investment / Capital Needed</span>
                        <div class="h4 fw-bold text-success mb-0 mt-1">₹<c:out value="${entrepreneur.investmentNeeded != null ? entrepreneur.investmentNeeded : 0}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Expected Monthly Revenue</span>
                        <div class="h4 fw-bold text-primary mb-0 mt-1">₹<c:out value="${entrepreneur.expectedMonthlyIncome != null ? entrepreneur.expectedMonthlyIncome : 0}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Business Experience</span>
                        <div class="h4 fw-bold text-dark mb-0 mt-1"><c:out value="${entrepreneur.businessExperience != null ? entrepreneur.businessExperience : 0}"/> <small class="fs-6 fw-normal text-muted">Years</small></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. AADHAAR IDENTITY PROOF -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-shield-lock-fill"></i>
                <h3>4. Aadhaar Identity Verification</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Aadhaar Number (Encrypted / Verified)</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.aadhaarNumber ? entrepreneur.aadhaarNumber : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 5. BUSINESS DESCRIPTION & PITCH -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-journal-text"></i>
                <h3>5. Business Description & Pitch Overview</h3>
            </div>
            <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.95rem; line-height: 1.6;">
                <c:choose>
                    <c:when test="${not empty entrepreneur.businessDescription}">
                        <c:out value="${entrepreneur.businessDescription}"/>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No detailed pitch description provided yet.</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 6. BANK & SETTLEMENT DETAILS -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-bank"></i>
                <h3>6. Payment Settlement & Bank Details</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">UPI Identifier</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.upiId ? entrepreneur.upiId : 'Not provided'}"/></span>
                </div>
                <div class="info-field" style="grid-column: 1 / -1;">
                    <span class="info-field-label">Bank Account / IFSC Details</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.bankDetails ? entrepreneur.bankDetails : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 7. AUDIT TRAIL & FEEDBACK -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-clipboard-check-fill"></i>
                <h3>7. Verification Audit Trail & Admin Feedback</h3>
            </div>
            <div class="info-grid mb-3">
                <div class="info-field">
                    <span class="info-field-label">Current Status</span>
                    <span class="info-field-value">
                        <span class="badge-status-lg status-${statusKey}">
                            ${statusKey}
                        </span>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Verification Status</span>
                    <span class="info-field-value"><c:out value="${entrepreneur.verificationStatus != null ? entrepreneur.verificationStatus : 'PENDING'}"/></span>
                </div>
            </div>

            <c:if test="${not empty entrepreneur.rejectionReason}">
                <div class="alert alert-danger rounded-3 mt-3">
                    <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection Reason on Record:</strong>
                    <div class="mt-1"><c:out value="${entrepreneur.rejectionReason}"/></div>
                </div>
            </c:if>

            <c:if test="${not empty entrepreneur.changesRequestedNote}">
                <div class="alert alert-warning rounded-3 mt-3">
                    <strong><i class="bi bi-pencil-square me-1"></i> Changes Requested Note on Record:</strong>
                    <div class="mt-1"><c:out value="${entrepreneur.changesRequestedNote}"/></div>
                </div>
            </c:if>
        </div>


                <!-- ADMIN ACTION BUTTONS -->
        <div class="action-buttons-container">
            <!-- Approve -->
            <c:if test="${entrepreneur.partnerProfileStatus != 'APPROVED'}">
            <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/approve" method="post" class="m-0">
                <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this entrepreneur for platform access?');">
                    <i class="bi bi-check-circle-fill me-1"></i> Approve Entrepreneur

        <!-- STICKY ACTION DOCK -->
        <div class="action-dock">
            <div>
                <span class="small text-white-50 d-block">Admin Decision Workflow</span>
                <strong class="text-white"><c:out value="${entrepreneur.fullName}"/></strong>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <!-- Approve -->
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/approve" method="post" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this entrepreneur for platform access?');">
                        <i class="bi bi-check-lg me-1"></i> Approve Entrepreneur
                    </button>
                </form>

                <!-- Request Changes Modal Trigger -->
                <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#requestChangesModal">
                    <i class="bi bi-pencil me-1"></i> Request Changes

                </button>
            </form>
            </c:if>

            <!-- Request Changes -->
            <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#requestChangesModal">
                <i class="bi bi-pencil-square me-1"></i> Request Changes
            </button>

            <!-- Reject -->
            <button type="button" class="btn-action-reject" data-bs-toggle="modal" data-bs-target="#rejectModal">
                <i class="bi bi-x-circle-fill me-1"></i> Reject Application
            </button>
        </div>

    </div>

    <!-- REQUEST CHANGES MODAL -->
    <div class="modal fade" id="requestChangesModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/request-changes" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i> Request Profile Changes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide specific feedback explaining what needs to be updated before approval.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Feedback Note</label>
                            <textarea name="note" class="form-control" rows="4" placeholder="e.g., Please enter a valid Aadhaar number and expand your business pitch..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark">Send Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- REJECT MODAL -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/reject" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-x-octagon me-2"></i> Reject Application</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide the reason for rejecting this entrepreneur profile.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rejection Reason</label>
                            <textarea name="reason" class="form-control" rows="4" placeholder="e.g., Incomplete documentation or invalid credentials..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger fw-bold">Confirm Rejection</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</div></main></div></body>

    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>

</html>







