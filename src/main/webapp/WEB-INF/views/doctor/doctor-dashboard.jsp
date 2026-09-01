<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Dashboard — Fight D Fear</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-tokens.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
  <style>
    :root {
      --martial-rose: #f43f5e;
      --martial-rose-dark: #e11d48;
      --martial-rose-light: #ffe4e6;
      --martial-rose-soft: #fff1f2;
      --martial-text: #0f172a;
      --martial-muted: #64748b;
      --martial-border: #e2e8f0;
      --martial-bg: #f8fafc;
      --martial-white: #ffffff;
      --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.03);
      --shadow-hover: 0 8px 24px rgba(244, 63, 94, 0.08);
      --primary: #F43F5E;
      --rose-soft: #FFF1F2;
      --bg-page: #F8FAFC;
      --navy: #0F172A;
      --navy-soft: #1E293B;
      --border: #E2E8F0;
      --sidebar-w: 240px;
      --dd-bg: #ffffff;
      --dd-border: #e2e8f0;
      --dd-muted: #64748b;
      --dd-text: #0f172a;
      --dd-coral: #f43f5e;
    }
    body.dd-page, .dd-page {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif !important;
      background: var(--martial-bg) !important;
      color: var(--martial-text) !important;
      overflow-x: hidden;
    }
    .dd-mobile-header {
      display: none;
      padding: 12px 16px;
      background: var(--martial-white);
      border-bottom: 1px solid var(--martial-border);
      justify-content: space-between;
      align-items: center;
      position: sticky;
      top: 0;
      z-index: 1100;
    }
    .dd-mobile-header .mh-brand {
      font-weight: 800; font-size: 1.05rem; color: var(--martial-text);
      display: flex; align-items: center; gap: 8px;
    }
    .dd-mobile-header .mh-brand img {
      height: 28px; width: 28px; border-radius: 6px; object-fit: cover;
    }
    .dd-mobile-header button {
      background: var(--martial-rose-soft); border: 1px solid var(--martial-rose-light);
      color: var(--martial-rose); width: 40px; height: 40px; border-radius: 10px;
      font-size: 1.25rem; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
    }
    .dd-sidebar {
      width: 240px !important;
      background: var(--martial-white) !important;
      color: var(--martial-text) !important;
      border-right: 1px solid var(--martial-border) !important;
      box-shadow: 2px 0 12px rgba(0,0,0,0.02) !important;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      max-height: 100vh;
      overflow: hidden;
      z-index: 1000;
    }
    .dd-sidebar-brand {
      border-bottom: 1px solid var(--martial-border) !important;
      padding: 20px 18px !important;
    }
    .dd-sidebar-brand .brand-text { color: var(--martial-text) !important; }
    .dd-sidebar-brand .brand-text small { color: var(--martial-muted) !important; }
    .dd-sidebar-profile {
      border-bottom: 1px solid var(--martial-border) !important;
      background: var(--martial-bg);
    }
    .dd-sidebar-profile .profile-info .name { color: var(--martial-text) !important; }
    .dd-sidebar-profile .profile-info .spec { color: var(--martial-muted) !important; }
    .dd-sidebar-profile .status-dot {
      background: #16A34A !important;
      box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.15) !important;
    }
    .dd-sidebar-nav { flex: 1 1 auto; overflow-y: auto; min-height: 0; padding: 14px 10px !important; }
    .dd-nav-label {
      color: #94a3b8 !important;
      letter-spacing: 1px;
    }
    .dd-nav-item {
      color: var(--martial-muted) !important;
      border-radius: 10px !important;
      font-weight: 600 !important;
    }
    .dd-nav-item i { color: #94a3b8 !important; }
    .dd-nav-item:hover {
      background: var(--martial-rose-soft) !important;
      color: var(--martial-rose-dark) !important;
    }
    .dd-nav-item:hover i { color: var(--martial-rose) !important; }
    .dd-nav-item.active {
      background: var(--martial-rose-light) !important;
      color: var(--martial-rose-dark) !important;
      border-left: none !important;
      box-shadow: none !important;
      font-weight: 700 !important;
    }
    .dd-nav-item.active i { color: var(--martial-rose) !important; }
    .dd-sidebar-footer {
      margin-top: auto;
      border-top: 1px solid var(--martial-border) !important;
      background: var(--martial-white);
    }
    .dd-sidebar-footer .dd-nav-item { color: #EF4444 !important; }
    .dd-sidebar-footer .dd-nav-item:hover { background: #FEF2F2 !important; }
    .dd-sidebar-footer .dd-nav-item i { color: #EF4444 !important; }
    .dd-main {
      background: var(--martial-bg) !important;
      margin-left: 240px !important;
      min-width: 0;
    }
    .dd-topbar {
      background: var(--martial-white) !important;
      border-bottom: 1px solid var(--martial-border) !important;
      border-radius: 0 !important;
      box-shadow: none !important;
      margin-bottom: 0 !important;
      position: sticky;
      top: 0;
      z-index: 30;
    }
    .dd-topbar-left h1 { color: var(--martial-text) !important; letter-spacing: -0.3px; }
    .dd-topbar-right { position: relative; }
    .dd-content { padding: 26px 32px 60px; max-width: 1240px; width: 100%; }
    .dd-section, .dd-stat-card, .dd-chat-sidebar, .dd-chat-main, .dd-pay-method-card, .dd-profile-item {
      background: #fff !important;
      border: 1px solid var(--martial-border) !important;
      border-radius: 16px !important;
      box-shadow: var(--shadow-card) !important;
      color: var(--martial-text);
    }
    .dd-stat-card {
      transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
      min-height: 110px;
    }
    .dd-stat-card:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-hover) !important;
      border-color: #FECDD3 !important;
    }
    .dd-section-header, .dd-section-body, .dd-table thead th, .dd-table tbody td { color: var(--martial-text) !important; }
    .badge-count, .notif-count, .dd-notif-count-label { background: var(--primary) !important; color: #fff !important; }
    .dd-btn-save, .dd-video-btn, .dd-status-form button {
      background: var(--primary) !important;
      color: #fff !important;
      border: none !important;
      box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25) !important;
    }
    .dd-btn-edit {
      background: var(--martial-white) !important;
      color: var(--martial-text) !important;
      border: 1px solid var(--martial-border) !important;
      box-shadow: none !important;
    }
    .dd-btn-edit:hover {
      border-color: var(--martial-rose) !important;
      color: var(--martial-rose-dark) !important;
      background: var(--martial-rose-soft) !important;
    }
    .dd-btn-cancel { border: 1px solid var(--martial-border) !important; background: #fff !important; color: var(--martial-muted) !important; }
    .dd-badge.pending { background: #FEF3C7 !important; color: #92400E !important; }
    .dd-badge.confirmed { background: #DCFCE7 !important; color: #166534 !important; }
    .dd-badge.completed { background: #F1F5F9 !important; color: #475569 !important; }
    .dd-badge.cancelled { background: #FEE2E2 !important; color: #991B1B !important; }
    .dd-stat-icon {
      width: 42px !important; height: 42px !important; border-radius: 50% !important;
      background: var(--martial-rose-light) !important;
      color: var(--martial-rose) !important;
    }
    .dd-stat-icon.purple, .dd-stat-icon.gold, .dd-stat-icon.teal, .dd-stat-icon.coral {
      background: #F1F5F9 !important;
      color: #64748B !important;
    }
    .dd-stat-card:first-child .dd-stat-icon,
    .dd-stats .dd-stat-card:nth-child(1) .dd-stat-icon {
      background: var(--martial-rose-light) !important;
      color: var(--martial-rose) !important;
    }
    .dd-notif-panel, #notifDropdown {
      background: #fff !important;
      border: 1px solid var(--martial-border) !important;
      box-shadow: 0 20px 40px rgba(15, 23, 42, 0.14) !important;
      color: var(--martial-text) !important;
    }
    .dd-empty {
      color: var(--martial-muted) !important;
      text-align: center;
      padding: 48px 24px !important;
    }
    .dd-empty i {
      font-size: 2.25rem !important;
      color: #cbd5e1 !important;
      display: block;
      margin-bottom: 12px;
    }
    .dd-empty p {
      font-size: 0.92rem !important;
      font-weight: 500;
      margin: 0;
    }
    .dd-empty .hint {
      font-size: 0.82rem; color: #94a3b8; display: block; margin-top: 8px; line-height: 1.45;
    }
    .dd-empty-cta {
      display: inline-flex; align-items: center; gap: 6px; margin-top: 16px;
      padding: 10px 18px; border-radius: 10px; background: var(--primary); color: #fff;
      font-weight: 700; font-size: 0.85rem; text-decoration: none;
      box-shadow: 0 4px 12px rgba(244,63,94,0.25);
    }
    .dd-empty-cta:hover { background: #E11D48; color: #fff; }
    .dd-empty-cta.secondary {
      background: #fff; color: var(--navy); border: 1px solid var(--martial-border);
      box-shadow: none;
    }
    .dd-complete-banner {
      background: #fff; border: 1px solid var(--martial-border); border-radius: 16px;
      padding: 18px 20px; margin-bottom: 20px; box-shadow: var(--shadow-card);
      display: flex; gap: 16px; align-items: flex-start; flex-wrap: wrap;
    }
    .dd-complete-banner .pct {
      font-size: 1.4rem; font-weight: 800; color: var(--primary);
      background: var(--martial-rose-soft); border: 1px solid #fecdd3;
      border-radius: 12px; padding: 10px 14px; min-width: 72px; text-align: center;
    }
    .dd-complete-banner .body { flex: 1; min-width: 200px; }
    .dd-complete-banner h3 { margin: 0 0 4px; font-size: 1rem; font-weight: 800; color: var(--martial-text); }
    .dd-complete-banner p { margin: 0; font-size: 0.88rem; color: var(--martial-muted); line-height: 1.45; }
    .dd-missing-chips { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }
    .dd-missing-chips span {
      font-size: 0.72rem; font-weight: 600; background: #FFF7ED; color: #C2410C;
      border: 1px solid #FED7AA; border-radius: 6px; padding: 4px 8px;
    }
    .dd-profile-hero {
      display: flex; gap: 20px; align-items: flex-start; flex-wrap: wrap;
      padding: 8px 0 20px; border-bottom: 1px solid var(--martial-border); margin-bottom: 20px;
    }
    .dd-profile-avatar {
      width: 96px; height: 96px; border-radius: 16px; object-fit: cover;
      background: var(--martial-rose-light); color: var(--martial-rose);
      display: flex; align-items: center; justify-content: center;
      font-size: 2rem; font-weight: 800; flex-shrink: 0; border: 1px solid #fecdd3;
    }
    .dd-profile-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 16px; }
    .dd-profile-hero-meta h3 { margin: 0 0 4px; font-size: 1.35rem; font-weight: 800; color: var(--martial-text); }
    .dd-profile-hero-meta .spec { color: var(--primary); font-weight: 700; font-size: 0.92rem; margin-bottom: 8px; }
    .dd-profile-hero-meta .row-meta {
      display: flex; flex-wrap: wrap; gap: 10px 16px; font-size: 0.82rem; color: var(--martial-muted);
    }
    .dd-profile-hero-meta .row-meta i { color: var(--primary); margin-right: 4px; }
    .dd-profile-section-title {
      font-size: 0.78rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px;
      color: #94a3b8; margin: 18px 0 10px;
    }
    .dd-status-pill {
      display: inline-flex; align-items: center; gap: 6px; font-size: 0.75rem; font-weight: 700;
      padding: 4px 10px; border-radius: 999px; margin-top: 8px;
    }
    .dd-status-pill.ok { background: #F0FDF4; color: #16A34A; border: 1px solid #bbf7d0; }
    .dd-status-pill.warn { background: #FFF7ED; color: #C2410C; border: 1px solid #FED7AA; }
    .dd-status-pill.pending { background: var(--martial-rose-soft); color: #9f1239; border: 1px solid #fecdd3; }
    .dd-bio-block {
      background: #F8FAFC; border: 1px solid var(--martial-border); border-radius: 12px;
      padding: 14px 16px; font-size: 0.9rem; line-height: 1.55; color: var(--martial-text);
      margin-top: 8px;
    }
    .dd-topbar-left h1 { font-size: 1.35rem; }
    .dd-topbar-left .breadcrumb-text { font-size: 0.88rem; color: var(--martial-muted); margin-top: 2px; }
    .dd-topbar-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
    .dd-btn-complete-profile {
      display: inline-flex; align-items: center; gap: 6px; padding: 8px 14px;
      border-radius: 10px; background: var(--primary); color: #fff; font-weight: 700;
      font-size: 0.82rem; text-decoration: none; box-shadow: 0 4px 12px rgba(244,63,94,0.25);
    }
    .dd-btn-complete-profile:hover { background: #E11D48; color: #fff; }
    @media (max-width: 600px) {
      .dd-profile-hero { flex-direction: column; align-items: center; text-align: center; }
      .dd-profile-hero-meta .row-meta { justify-content: center; }
      .dd-complete-banner { flex-direction: column; align-items: stretch; }
    }
    .user-avatar, .avatar-placeholder {
      background: var(--martial-rose-light) !important;
      color: var(--martial-rose) !important;
    }
    .dd-chat-wrapper { height: calc(100vh - 220px) !important; min-height: 560px !important; }
    .dd-overlay {
      display: none;
      position: fixed; inset: 0;
      background: rgba(15, 23, 42, 0.35);
      z-index: 900;
    }
    .dd-overlay.show { display: block; }
    .dd-table-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; }
    @media (max-width: 900px) {
      .dd-mobile-header { display: flex; }
      .dd-sidebar {
        transform: translateX(-110%) !important;
        transition: transform 0.3s ease;
        max-height: 100vh;
      }
      .dd-sidebar.open { transform: translateX(0) !important; }
      .dd-main { margin-left: 0 !important; }
      .dd-hamburger { display: none !important; }
      .dd-content { padding: 18px 16px 40px; }
      .dd-topbar { padding: 14px 16px !important; }
    }
    @media (max-width: 991px) {
      .dd-chat-wrapper { flex-direction: column; height: auto !important; min-height: 0 !important; }
      .dd-chat-sidebar { width: 100% !important; }
      .dd-chat-main { min-height: 480px; }
    }
    @media (max-width: 768px) {
      .dd-stats { grid-template-columns: 1fr 1fr !important; }
      .dd-table thead { display: none; }
      .dd-table, .dd-table tbody, .dd-table tr, .dd-table td {
        display: block; width: 100%;
      }
      .dd-table tr {
        background: #fff;
        border: 1px solid var(--martial-border);
        border-radius: 12px;
        padding: 12px 14px;
        margin-bottom: 12px;
        box-shadow: var(--shadow-card);
      }
      .dd-table td {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 12px;
        padding: 8px 0 !important;
        border: none !important;
        text-align: right;
      }
      .dd-table td::before {
        content: attr(data-label);
        font-weight: 700;
        font-size: 0.75rem;
        color: var(--martial-muted);
        text-align: left;
        flex-shrink: 0;
      }
      .dd-table td:last-child { justify-content: flex-end; }
    }
    @media (max-width: 480px) {
      .dd-stats { grid-template-columns: 1fr !important; }
    }
  </style>
</head>
<body class="dd-page">
<div class="dd-overlay" id="overlay" onclick="toggleSidebar()"></div>

<div class="dd-mobile-header">
  <div class="mh-brand">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
    Fight D Fear
  </div>
  <button type="button" onclick="toggleSidebar()" aria-label="Open menu"><i class="bi bi-list"></i></button>
</div>

<%-- ═══ SIDEBAR ═══ --%>
<aside class="dd-sidebar" id="sidebar">
  <div class="dd-sidebar-brand">
    <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="width:32px;height:32px;border-radius:8px;object-fit:cover;display:block;">
    <div class="brand-text">Fight D Fear<small>Doctor Portal</small></div>
  </div>
  <div class="dd-sidebar-profile">
    <div class="avatar-placeholder">${doctor.fullName.charAt(0)}</div>
    <div class="profile-info">
      <div class="name">${doctor.fullName}</div>
      <div class="spec">${doctor.specialization}</div>
    </div>
    <div class="status-dot"></div>
  </div>
  <nav class="dd-sidebar-nav">
    <div class="dd-nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=overview" class="dd-nav-item ${section == 'overview' ? 'active' : ''}">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments" class="dd-nav-item ${section == 'appointments' ? 'active' : ''}">
      <i class="bi bi-calendar-check"></i> Appointments
      <c:if test="${pendingCount > 0}"><span class="badge-count" id="sidebar-appt-badge">${pendingCount}</span></c:if>
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats" class="dd-nav-item ${section == 'chats' ? 'active' : ''}">
      <i class="bi bi-chat-dots"></i> Chats
      <c:if test="${unreadChatCount > 0}"><span class="badge-count">${unreadChatCount}</span></c:if>
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=profile" class="dd-nav-item ${section == 'profile' ? 'active' : ''}">
      <i class="bi bi-person"></i> My Profile
    </a>
    <c:if test="${profileCompletion < 100 || (doctor.doctorProfileStatus != 'APPROVED' && doctor.verificationStatus != 'VERIFIED')}">
      <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-nav-item">
        <i class="bi bi-person-gear"></i> Complete Profile
        <c:if test="${profileCompletion < 100}"><span class="badge-count">${profileCompletion}%</span></c:if>
      </a>
    </c:if>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=earnings" class="dd-nav-item ${section == 'earnings' ? 'active' : ''}">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=schedule" class="dd-nav-item ${section == 'schedule' ? 'active' : ''}">
      <i class="bi bi-clock"></i> Schedule
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=prescriptions" class="dd-nav-item ${section == 'prescriptions' ? 'active' : ''}">
      <i class="bi bi-file-earmark-medical"></i> Prescriptions
    </a>
    <div class="dd-nav-label">Network</div>
    <a href="${pageContext.request.contextPath}/doctors/list" class="dd-nav-item">
      <i class="bi bi-people"></i> Doctor Directory
    </a>
  </nav>
  <div class="dd-sidebar-footer">
    <a href="${pageContext.request.contextPath}/doctors/logout" class="dd-nav-item">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<%-- ═══ MAIN ═══ --%>
<main class="dd-main">
  <%
    int currentHour = java.time.LocalTime.now().getHour();
    String doctorGreeting = "Good morning";
    if (currentHour >= 12 && currentHour < 17) {
      doctorGreeting = "Good afternoon";
    } else if (currentHour >= 17 || currentHour < 5) {
      doctorGreeting = "Good evening";
    }
    request.setAttribute("doctorGreeting", doctorGreeting);
    request.setAttribute("todayIso", java.time.LocalDate.now().toString());
  %>
  <header class="dd-topbar">
    <div class="dd-topbar-left">
      <button class="dd-hamburger" onclick="toggleSidebar()" aria-label="Toggle menu"><i class="bi bi-list"></i></button>
      <div>
        <c:choose>
          <c:when test="${section == 'overview' || empty section}">
            <h1>${doctorGreeting}, Dr. ${doctor.fullName} &#128075;</h1>
            <div class="breadcrumb-text">Manage appointments, consultations, and your clinic profile</div>
          </c:when>
          <c:otherwise>
            <h1><c:choose>
              <c:when test="${section == 'appointments'}">Appointments</c:when>
              <c:when test="${section == 'profile'}">My Profile</c:when>
              <c:when test="${section == 'earnings'}">Earnings &amp; Fees</c:when>
              <c:when test="${section == 'schedule'}">Schedule</c:when>
              <c:when test="${section == 'prescriptions'}">Prescriptions</c:when>
              <c:when test="${section == 'chats'}">Chats</c:when>
              <c:otherwise>Dashboard</c:otherwise>
            </c:choose></h1>
            <div class="breadcrumb-text">${doctorGreeting}, Dr. ${doctor.fullName}</div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="dd-topbar-right dd-topbar-actions">
      <c:if test="${profileCompletion < 100 || (doctor.doctorProfileStatus != 'APPROVED' && doctor.verificationStatus != 'VERIFIED' && doctor.doctorProfileStatus != 'PENDING_ADMIN_APPROVAL')}">
        <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-btn-complete-profile">
          <i class="bi bi-person-gear"></i> Complete Profile
        </a>
      </c:if>
      <div class="dd-notif-wrap">
        <button type="button" class="notif-btn" id="notifToggle" aria-label="Notifications" aria-expanded="false" aria-controls="notifPanel">
          <i class="bi bi-bell"></i>
          <c:if test="${notificationCount > 0}"><span class="dot"></span><span class="notif-count">${notificationCount}</span></c:if>
        </button>
        <div class="dd-notif-panel" id="notifPanel" hidden>
          <div class="dd-notif-header">
            <strong>Notifications</strong>
            <c:if test="${notificationCount > 0}"><span class="dd-notif-count-label">${notificationCount} new</span></c:if>
          </div>
          <div class="dd-notif-list">
            <c:choose>
              <c:when test="${empty notifications}">
                <div class="dd-notif-empty">
                  <i class="bi bi-bell-slash"></i>
                  <p>No new notifications</p>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="n" items="${notifications}">
                  <a class="dd-notif-item" href="${pageContext.request.contextPath}${n.href}">
                    <span class="dd-notif-icon ${n.type}"><i class="bi ${n.icon}"></i></span>
                    <span class="dd-notif-text">
                      <span class="dd-notif-title">${n.title}</span>
                      <span class="dd-notif-body">${n.body}</span>
                    </span>
                  </a>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="dd-notif-footer">
            <a href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments">View appointments</a>
            <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats">View chats</a>
          </div>
        </div>
      </div>
    </div>
  </header>

  <div class="dd-content">
    <c:if test="${not empty message}">
      <div style="padding:14px 20px;border-radius:12px;background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.2);color:#0d9668;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:8px">
        <i class="bi bi-check-circle"></i> ${message}
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div style="padding:14px 20px;border-radius:12px;background:rgba(244,63,94,0.08);border:1px solid rgba(244,63,94,0.2);color:#be123c;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:8px">
        <i class="bi bi-exclamation-circle"></i> ${error}
      </div>
    </c:if>

    <%-- ══════ OVERVIEW SECTION ══════ --%>
    <c:if test="${section == 'overview'}">
      <c:if test="${profileCompletion < 100 || (doctor.doctorProfileStatus != 'APPROVED' && doctor.verificationStatus != 'VERIFIED')}">
        <div class="dd-complete-banner">
          <div class="pct">${profileCompletion}%</div>
          <div class="body">
            <c:choose>
              <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                <h3>Verification in progress</h3>
                <p>Your profile is with the admin for review. You can keep seeing patients once approved. Meanwhile, ensure all details stay accurate.</p>
              </c:when>
              <c:when test="${doctor.doctorProfileStatus == 'REJECTED' || doctor.doctorProfileStatus == 'CHANGES_REQUESTED' || doctor.verificationStatus == 'REJECTED'}">
                <h3>Changes required before verification</h3>
                <p>Update the missing or flagged details, then resubmit for verification.</p>
                <c:if test="${not empty doctor.rejectionReason}">
                  <p style="margin-top:8px;color:#BE123C;font-weight:600;">Reason: ${doctor.rejectionReason}</p>
                </c:if>
              </c:when>
              <c:when test="${profileCompletion < 100}">
                <h3>Complete your doctor profile</h3>
                <p>Finish the remaining sections so patients can find you and book with confidence. Next: open Complete Profile and fill what is listed below.</p>
              </c:when>
              <c:otherwise>
                <h3>Ready to submit for verification</h3>
                <p>Your profile looks complete. Submit it for admin verification to appear in the public doctor directory.</p>
              </c:otherwise>
            </c:choose>
            <c:if test="${not empty missingItems}">
              <div class="dd-missing-chips">
                <c:forEach var="m" items="${missingItems}"><span>${m}</span></c:forEach>
              </div>
            </c:if>
            <div style="margin-top:14px;display:flex;flex-wrap:wrap;gap:8px;">
              <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-empty-cta" style="margin-top:0;"><i class="bi bi-person-gear"></i> Complete Profile</a>
              <a href="${pageContext.request.contextPath}/doctors/dashboard?section=profile" class="dd-empty-cta secondary" style="margin-top:0;"><i class="bi bi-eye"></i> View Profile</a>
            </div>
          </div>
        </div>
      </c:if>

      <div class="dd-stats">
        <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-calendar2-check"></i></div><div class="dd-stat-info"><h3>${appointmentCount}</h3><p>Total Appointments</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingCount}</h3><p>Pending</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-check-circle"></i></div><div class="dd-stat-info"><h3>${confirmedCount}</h3><p>Confirmed</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-trophy"></i></div><div class="dd-stat-info"><h3>${completedCount}</h3><p>Completed</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${doctor.consultationFee != null ? doctor.consultationFee : 0}</h3><p>Consultation Fee</p></div></div>
      </div>
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-sun"></i> Today's Schedule</h2>
          <a href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments" style="font-size:0.82rem;font-weight:700;color:var(--primary);text-decoration:none;">View all</a>
        </div>
        <div class="dd-section-body" style="padding:16px;">
          <c:set var="todayShown" value="false"/>
          <c:forEach var="a" items="${appointments}">
            <c:if test="${fn:startsWith(a.appointmentTime, todayIso)}">
              <c:set var="todayShown" value="true"/>
              <div class="doc-appt-card"
                   role="button" tabindex="0"
                   onclick="openPatientPreview(this)"
                   onkeydown="if(event.key==='Enter')openPatientPreview(this)"
                   data-patient="${empty a.user.fullName ? 'Patient' : a.user.fullName}"
                   data-email="${empty a.user.email ? '' : a.user.email}"
                   data-phone="${empty a.user.phoneNumber ? '' : a.user.phoneNumber}"
                   data-age="${a.user.age != null ? a.user.age : ''}"
                   data-gender="${a.user.gender != null ? a.user.gender : ''}"
                   data-time="${a.appointmentTime}"
                   data-reason="${empty a.reason ? '' : a.reason}"
                   data-type="${a.consultationType}"
                   data-status="${a.status}"
                   data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
                   data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
                   data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
                   data-notes="${empty a.doctorNotes ? '' : a.doctorNotes}"
                   data-rx="${not empty a.prescriptionText ? '1' : ''}"
                   data-chat-url="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}"
                   data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}?userId=${a.user.id}"
                   data-video-url="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${a.user.id}"
                   data-status-url="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status"
                   data-appt-id="${a.id}">
                <div class="doc-appt-avatar">${a.user.fullName.charAt(0)}</div>
                <div class="doc-appt-body">
                  <p class="doc-appt-name">${a.user.fullName}</p>
                  <div class="doc-appt-meta">
                    <span><i class="bi bi-clock"></i> ${a.appointmentTime}</span>
                    <span><i class="bi bi-chat-text"></i> ${empty a.reason ? 'No reason provided' : a.reason}</span>
                  </div>
                </div>
                <div class="doc-appt-actions" onclick="event.stopPropagation()">
                  <c:choose>
                    <c:when test="${a.status=='PENDING'}"><span class="doc-status pending">Pending</span></c:when>
                    <c:when test="${a.status=='CONFIRMED'}"><span class="doc-status confirmed">Confirmed</span></c:when>
                    <c:when test="${a.status=='COMPLETED'}"><span class="doc-status completed">Completed</span></c:when>
                    <c:otherwise><span class="doc-status cancelled">Cancelled</span></c:otherwise>
                  </c:choose>
                  <c:choose>
                    <c:when test="${a.consultationType=='VIDEO'}"><span class="doc-type-badge video"><i class="bi bi-camera-video"></i> Video</span></c:when>
                    <c:when test="${a.consultationType=='CLINIC'}"><span class="doc-type-badge clinic"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                    <c:otherwise><span class="doc-type-badge"><i class="bi bi-chat-dots"></i> Consult</span></c:otherwise>
                  </c:choose>
                </div>
              </div>
            </c:if>
          </c:forEach>
          <c:if test="${!todayShown}">
            <div class="dd-empty">
              <i class="bi bi-calendar-heart"></i>
              <p>No appointments today</p>
              <span class="hint">New patient bookings for today will appear here.</span>
            </div>
          </c:if>
        </div>
      </div>
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> Recent Appointments</h2>
          <a href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments" style="font-size:0.82rem;font-weight:700;color:var(--primary);text-decoration:none;">View all</a>
        </div>
        <div class="dd-section-body" style="padding:16px;">
          <c:if test="${empty appointments}">
            <div class="dd-empty">
              <i class="bi bi-calendar-x"></i>
              <p>No appointments yet</p>
              <span class="hint">New patient bookings will appear here once your profile is visible and patients book a slot.</span>
              <a class="dd-empty-cta" href="${pageContext.request.contextPath}/doctors/profile-completion"><i class="bi bi-person-gear"></i> Finish profile to get booked</a>
            </div>
          </c:if>
          <c:if test="${not empty appointments}">
            <c:forEach var="a" items="${appointments}" begin="0" end="4">
              <div class="doc-appt-card"
                   role="button" tabindex="0"
                   onclick="openPatientPreview(this)"
                   onkeydown="if(event.key==='Enter')openPatientPreview(this)"
                   data-patient="${empty a.user.fullName ? 'Patient' : a.user.fullName}"
                   data-email="${empty a.user.email ? '' : a.user.email}"
                   data-phone="${empty a.user.phoneNumber ? '' : a.user.phoneNumber}"
                   data-age="${a.user.age != null ? a.user.age : ''}"
                   data-gender="${a.user.gender != null ? a.user.gender : ''}"
                   data-time="${a.appointmentTime}"
                   data-reason="${empty a.reason ? '' : a.reason}"
                   data-type="${a.consultationType}"
                   data-status="${a.status}"
                   data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
                   data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
                   data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
                   data-notes="${empty a.doctorNotes ? '' : a.doctorNotes}"
                   data-rx="${not empty a.prescriptionText ? '1' : ''}"
                   data-chat-url="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}"
                   data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}?userId=${a.user.id}"
                   data-video-url="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${a.user.id}"
                   data-status-url="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status"
                   data-appt-id="${a.id}">
                <div class="doc-appt-avatar">${a.user.fullName.charAt(0)}</div>
                <div class="doc-appt-body">
                  <p class="doc-appt-name">${a.user.fullName}</p>
                  <div class="doc-appt-meta">
                    <span><i class="bi bi-calendar3"></i> ${a.appointmentTime}</span>
                    <span><i class="bi bi-chat-text"></i> ${empty a.reason ? 'No reason given' : a.reason}</span>
                    <c:if test="${a.amountPaid != null}">
                      <span><i class="bi bi-currency-rupee"></i> &#8377;${a.amountPaid}</span>
                    </c:if>
                  </div>
                </div>
                <div class="doc-appt-actions" onclick="event.stopPropagation()">
                  <c:choose>
                    <c:when test="${a.status=='PENDING'}"><span class="doc-status pending">Pending</span></c:when>
                    <c:when test="${a.status=='CONFIRMED'}"><span class="doc-status confirmed">Confirmed</span></c:when>
                    <c:when test="${a.status=='COMPLETED'}"><span class="doc-status completed">Completed</span></c:when>
                    <c:otherwise><span class="doc-status cancelled">Cancelled</span></c:otherwise>
                  </c:choose>
                  <c:choose>
                    <c:when test="${a.consultationType=='VIDEO'}"><span class="doc-type-badge video"><i class="bi bi-camera-video"></i> Video</span></c:when>
                    <c:when test="${a.consultationType=='CLINIC'}"><span class="doc-type-badge clinic"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                    <c:otherwise><span class="doc-type-badge"><i class="bi bi-chat-dots"></i> Consult</span></c:otherwise>
                  </c:choose>
                  <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form">
                    <select name="status">
                      <option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option>
                      <option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option>
                      <option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option>
                      <option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option>
                    </select>
                    <button type="submit"><i class="bi bi-check2"></i></button>
                  </form>
                </div>
              </div>
            </c:forEach>
          </c:if>
        </div>
      </div>

      <div class="dd-section" style="margin-top: 20px;">
        <div class="dd-section-header"><h2><i class="bi bi-graph-up"></i> Patient Traffic</h2></div>
        <div class="dd-section-body">
          <c:choose>
            <c:when test="${empty appointments}">
              <div class="dd-empty">
                <i class="bi bi-bar-chart"></i>
                <p>No traffic data yet</p>
                <span class="hint">Appointment volume by time of day will show once patients start booking.</span>
              </div>
            </c:when>
            <c:otherwise>
              <canvas id="appointmentsChart" height="100"></canvas>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </c:if>

    <%-- ══════ APPOINTMENTS SECTION ══════ --%>
    <c:if test="${section == 'appointments'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> All Appointments (${appointmentCount})</h2></div>
        <div class="dd-section-body" style="padding:16px;">
          <c:if test="${empty appointments}">
            <div class="dd-empty">
              <i class="bi bi-calendar-x"></i>
              <p>No appointments yet</p>
              <span class="hint">Patient bookings appear here after they schedule a consultation with you. Confirm pending requests from this list.</span>
              <a class="dd-empty-cta" href="${pageContext.request.contextPath}/doctors/dashboard?section=schedule"><i class="bi bi-clock"></i> Check your schedule</a>
            </div>
          </c:if>
          <c:if test="${not empty appointments}">
            <c:forEach var="a" items="${appointments}">
              <div class="doc-appt-card"
                   role="button" tabindex="0"
                   onclick="openPatientPreview(this)"
                   onkeydown="if(event.key==='Enter')openPatientPreview(this)"
                   data-patient="${empty a.user.fullName ? 'Patient' : a.user.fullName}"
                   data-email="${empty a.user.email ? '' : a.user.email}"
                   data-phone="${empty a.user.phoneNumber ? '' : a.user.phoneNumber}"
                   data-age="${a.user.age != null ? a.user.age : ''}"
                   data-gender="${a.user.gender != null ? a.user.gender : ''}"
                   data-time="${a.appointmentTime}"
                   data-reason="${empty a.reason ? '' : a.reason}"
                   data-type="${a.consultationType}"
                   data-status="${a.status}"
                   data-payment="${empty a.paymentStatus ? '' : a.paymentStatus}"
                   data-amount="${a.amountPaid != null ? a.amountPaid : ''}"
                   data-receipt="${empty a.receiptNumber ? '' : a.receiptNumber}"
                   data-notes="${empty a.doctorNotes ? '' : a.doctorNotes}"
                   data-rx="${not empty a.prescriptionText ? '1' : ''}"
                   data-chat-url="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}"
                   data-call-url="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}?userId=${a.user.id}"
                   data-video-url="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${a.user.id}"
                   data-status-url="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status"
                   data-appt-id="${a.id}">
                <div class="doc-appt-avatar">${a.user.fullName.charAt(0)}</div>
                <div class="doc-appt-body">
                  <p class="doc-appt-name">${a.user.fullName}</p>
                  <div class="doc-appt-meta">
                    <span><i class="bi bi-calendar3"></i> ${a.appointmentTime}</span>
                    <span><i class="bi bi-chat-text"></i> ${empty a.reason ? 'No reason given' : a.reason}</span>
                    <c:choose>
                      <c:when test="${a.amountPaid != null}"><span><i class="bi bi-currency-rupee"></i> &#8377;${a.amountPaid}</span></c:when>
                      <c:otherwise><span><i class="bi bi-wallet2"></i> Payment pending</span></c:otherwise>
                    </c:choose>
                  </div>
                </div>
                <div class="doc-appt-actions" onclick="event.stopPropagation()">
                  <c:choose>
                    <c:when test="${a.status=='PENDING'}"><span class="doc-status pending">Pending</span></c:when>
                    <c:when test="${a.status=='CONFIRMED'}"><span class="doc-status confirmed">Confirmed</span></c:when>
                    <c:when test="${a.status=='COMPLETED'}"><span class="doc-status completed">Completed</span></c:when>
                    <c:otherwise><span class="doc-status cancelled">Cancelled</span></c:otherwise>
                  </c:choose>
                  <c:choose>
                    <c:when test="${a.consultationType=='VIDEO'}"><span class="doc-type-badge video"><i class="bi bi-camera-video"></i> Video</span></c:when>
                    <c:when test="${a.consultationType=='CLINIC'}"><span class="doc-type-badge clinic"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                    <c:otherwise><span class="doc-type-badge"><i class="bi bi-chat-dots"></i> Consult</span></c:otherwise>
                  </c:choose>
                  <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
                    <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form">
                      <select name="status">
                        <option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option>
                        <option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option>
                        <option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option>
                        <option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option>
                      </select>
                      <button type="submit"><i class="bi bi-check2"></i></button>
                    </form>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn" style="background:#F43F5E" title="Chat"><i class="bi bi-chat-dots-fill"></i></a>
                    <c:if test="${a.consultationType=='VIDEO' && a.status=='CONFIRMED'}">
                      <a href="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn"><i class="bi bi-camera-video-fill"></i> Join</a>
                    </c:if>
                  </div>
                </div>
              </div>
            </c:forEach>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ CHATS SECTION ══════ --%>
    <c:if test="${section == 'chats'}">
      <div class="dd-section" style="background: transparent; border: none; padding: 0; box-shadow: none;">
        <div class="dd-section-header" style="margin-bottom: 20px;"><h2><i class="bi bi-chat-dots"></i> My Chats</h2></div>
        
        <div class="dd-chat-wrapper" style="display: flex; gap: 20px; height: calc(100vh - 200px); min-height: 550px;">
          
          <!-- Users Sidebar -->
          <div class="dd-chat-sidebar" style="width: 320px; background: #fff; border: 1px solid var(--dd-border); border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 4px 20px rgba(15,23,42,0.04);">
            <div style="padding: 20px; border-bottom: 1px solid var(--dd-border); background: #F8FAFC;">
              <h3 style="margin: 0; font-size: 16px; font-weight: 700;">Patients</h3>
              <p style="margin: 4px 0 0; font-size: 12px; color: var(--dd-muted);">Select a patient to chat</p>
            </div>
            
            <div style="flex: 1; overflow-y: auto; padding: 10px;">
              <c:if test="${empty chatUsers}">
                <div class="dd-empty" style="padding: 36px 20px;">
                  <i class="bi bi-chat-dots"></i>
                  <p>No patient chats yet</p>
                  <span class="hint">Chats unlock after a confirmed appointment relationship with a patient.</span>
                  <a class="dd-empty-cta secondary" href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments"><i class="bi bi-calendar-check"></i> View appointments</a>
                </div>
              </c:if>
              
              <c:forEach var="u" items="${chatUsers}">
                <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats&userId=${u.id}" 
                   style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; border-radius: 10px; margin-bottom: 5px; transition: all 0.2s; background: ${targetUserId == u.id ? 'rgba(244,63,94,0.12)' : 'transparent'}; border: 1px solid ${targetUserId == u.id ? 'rgba(244,63,94,0.32)' : 'transparent'};">
                  <div class="user-avatar" style="width: 40px; height: 40px; border-radius: 50%; background: #FFE4E6; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #F43F5E; flex-shrink: 0;">${u.fullName.charAt(0)}</div>
                  <div style="flex: 1; overflow: hidden;">
                    <div style="font-weight: 600; font-size: 14px; color: ${targetUserId == u.id ? '#9f1239' : '#0F172A'}; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;">${u.fullName}</div>
                    <div style="font-size: 12px; color: var(--dd-muted);">Patient</div>
                  </div>
                  <c:if test="${targetUserId == u.id}">
                    <div style="width: 8px; height: 8px; border-radius: 50%; background: #F43F5E;"></div>
                  </c:if>
                </a>
              </c:forEach>
            </div>
          </div>
          
          <!-- Chat Window -->
          <div class="dd-chat-main" style="flex: 1; background: #fff; border: 1px solid var(--dd-border); border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 4px 20px rgba(15,23,42,0.04);">
            <c:choose>
              
              <c:when test="${not empty targetUserId}">
                <!-- Chat Header -->
                <div style="padding: 16px 24px; border-bottom: 1px solid var(--dd-border); display: flex; align-items: center; justify-content: space-between; background: #F8FAFC;">
                  <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="user-avatar" style="width: 42px; height: 42px; border-radius: 50%; background: #FFE4E6; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #F43F5E;">${targetUserName != null ? targetUserName.charAt(0) : 'U'}</div>
                    <div>
                      <h3 style="margin: 0; font-size: 16px; font-weight: 700;">${targetUserName}</h3>
                      <p style="margin: 2px 0 0; font-size: 12px; color: var(--doc-success); display: flex; align-items: center; gap: 4px;"><span style="width: 6px; height: 6px; border-radius: 50%; background: var(--doc-success); display: inline-block;"></span> Online</p>
                    </div>
                  </div>
                  <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}?userId=${targetUserId}" target="_blank" style="width: 36px; height: 36px; border-radius: 10px; background: var(--doc-success-bg); color: var(--doc-success); display: flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.2s;"><i class="bi bi-telephone-fill"></i></a>
                    <a href="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${targetUserId}" target="_blank" style="width: 36px; height: 36px; border-radius: 10px; background: var(--doc-primary-soft); color: #be123c; display: flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.2s;"><i class="bi bi-camera-video-fill"></i></a>
                  </div>
                </div>
                
                <!-- Chat Messages -->
                <div id="chatMessages" style="flex: 1; padding: 20px 24px; overflow-y: auto; display: flex; flex-direction: column; gap: 12px; background: #F8FAFC;">
                  <c:if test="${empty chatHistory}">
                    <div style="margin: auto; text-align: center; color: var(--dd-muted);">
                      <i class="bi bi-chat-dots" style="font-size: 40px; margin-bottom: 10px; display: block; opacity: 0.5;"></i>
                      <p>Start conversation with ${targetUserName}</p>
                    </div>
                  </c:if>
                  <c:forEach var="m" items="${chatHistory}">
                    <div style="max-width: 75%; padding: 12px 16px; border-radius: 16px; font-size: 13px; line-height: 1.5; ${m.senderType == 'DOCTOR' ? 'align-self: flex-end; background: var(--doc-primary); color: #fff; border-bottom-right-radius: 4px;' : 'align-self: flex-start; background: #fff; color: #0F172A; border: 1px solid var(--doc-border); border-bottom-left-radius: 4px;'}">
                      ${m.message}
                      <span style="display: block; font-size: 9px; opacity: 0.6; margin-top: 4px; text-align: right;">${m.timestamp}</span>
                    </div>
                  </c:forEach>
                </div>
                
                <!-- Chat Input -->
                <div style="padding: 16px 24px; border-top: 1px solid var(--dd-border); display: flex; gap: 12px; align-items: center; background: #fff;">
                  <input type="text" id="msgInput" placeholder="Type your message..." style="flex: 1; padding: 14px 20px; border: 1px solid var(--dd-border); border-radius: 999px; background: #fff; color: #0F172A; font-family: inherit; font-size: 14px; outline: none; transition: 0.2s;" onkeypress="if(event.key==='Enter')sendMsg()" />
                  <button onclick="sendMsg()" style="width: 48px; height: 48px; border-radius: 50%; border: none; background: var(--doc-primary); color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 4px 12px rgba(244,63,94,0.25); transition: 0.2s;"><i class="bi bi-send-fill" style="margin-left: 2px;"></i></button>
                </div>
                
                <!-- WebSocket Script -->
                <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
                <script>
                  const doctorId = ${doctor.id};
                  const senderType = 'DOCTOR';
                  const targetUserId = '${targetUserId}';
                  const ctx = '${pageContext.request.contextPath}';
                  const chatBox = document.getElementById('chatMessages');

                  const socket = new SockJS(ctx + '/ws-chat');
                  const stompClient = Stomp.over(socket);
                  stompClient.debug = null; 
                  stompClient.connect({}, function() {
                    stompClient.subscribe('/topic/doctor-chat/' + doctorId, function(payload) {
                      const msg = JSON.parse(payload.body);
                      if (msg.userId && msg.userId != targetUserId) return;
                      // Ignore echoes
                      if (msg.senderType === senderType) return;
                      appendMsg(msg.message, 'USER');
                    });
                  });

                  function sendMsg() {
                    const input = document.getElementById('msgInput');
                    const text = input.value.trim();
                    if (!text) return;
                    input.value = '';

                    const empty = chatBox.querySelector('.bi-chat-dots');
                    if (empty) empty.parentNode.remove();

                    // Immediately show in UI
                    appendMsg(text, 'DOCTOR');

                    fetch(ctx + '/doctors/chat/send', {
                      method: 'POST',
                      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                      body: 'doctorId=' + doctorId + '&message=' + encodeURIComponent(text) + '&senderType=' + senderType + '&userId=' + targetUserId
                    });
                  }

                  function appendMsg(text, type) {
                    const div = document.createElement('div');
                    let styles = "max-width: 75%; padding: 12px 16px; border-radius: 16px; font-size: 13px; line-height: 1.5; ";
                    if(type === 'DOCTOR') {
                        styles += "align-self: flex-end; background: #F43F5E; color: #fff; border-bottom-right-radius: 4px;";
                    } else {
                        styles += "align-self: flex-start; background: #fff; color: #0F172A; border: 1px solid #E2E8F0; border-bottom-left-radius: 4px;";
                    }
                    div.style.cssText = styles;
                    div.innerHTML = text + '<span style="display: block; font-size: 9px; opacity: 0.6; margin-top: 4px; text-align: right;">Just now</span>';
                    chatBox.appendChild(div);
                    chatBox.scrollTop = chatBox.scrollHeight;
                  }

                  if(chatBox) chatBox.scrollTop = chatBox.scrollHeight;
                </script>
              </c:when>
              
              <c:otherwise>
                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: var(--martial-muted, #64748b); padding: 24px;">
                  <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--martial-rose-soft, #fff1f2); display: flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                    <i class="bi bi-chat-square-dots" style="font-size: 32px; color: #F43F5E;"></i>
                  </div>
                  <h3 style="font-size: 18px; font-weight: 700; color: #0F172A; margin: 0 0 8px;">Select a Patient</h3>
                  <p style="font-size: 14px; text-align: center; max-width: 300px; color: #64748b;">Choose a patient from the sidebar to view your conversation or start a new message.</p>
                </div>
              </c:otherwise>
              
            </c:choose>
          </div>
          
        </div>
      </div>
    </c:if>

    <%-- ══════ PROFILE SECTION ══════ --%>
    <c:if test="${section == 'profile'}">
      <div class="dd-section" id="profileView">
        <div class="dd-section-header">
          <h2><i class="bi bi-person-badge"></i> Doctor Profile</h2>
          <div style="display:flex;gap:10px;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-btn-edit" style="text-decoration:none;background:var(--primary);color:#fff;border-color:var(--primary);">
              <i class="bi bi-pencil-square"></i>
              <c:choose>
                <c:when test="${profileCompletion < 100}">Complete Profile</c:when>
                <c:otherwise>Update Profile</c:otherwise>
              </c:choose>
            </a>
          </div>
        </div>
        <div class="dd-section-body padded">

          <div class="dd-profile-hero">
            <div class="dd-profile-avatar">
              <c:choose>
                <c:when test="${not empty doctor.profilePhotoPath}">
                  <img src="${pageContext.request.contextPath}${doctor.profilePhotoPath}" alt="Dr. ${doctor.fullName}">
                </c:when>
                <c:otherwise>${doctor.fullName.charAt(0)}</c:otherwise>
              </c:choose>
            </div>
            <div class="dd-profile-hero-meta">
              <h3>Dr. ${doctor.fullName}</h3>
              <div class="spec">${not empty doctor.specialization ? doctor.specialization : 'Specialization not set'}</div>
              <div class="row-meta">
                <span><i class="bi bi-mortarboard"></i> ${not empty doctor.qualification ? doctor.qualification : 'Qualification pending'}</span>
                <span><i class="bi bi-briefcase"></i> ${doctor.experienceYears != null ? doctor.experienceYears : '—'} yrs experience</span>
                <span><i class="bi bi-geo-alt"></i>
                  <c:choose>
                    <c:when test="${not empty doctor.city}">${doctor.city}<c:if test="${not empty doctor.state}">, ${doctor.state}</c:if></c:when>
                    <c:when test="${not empty doctor.locationText}">${doctor.locationText}</c:when>
                    <c:otherwise>Location not set</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <c:choose>
                <c:when test="${doctor.doctorProfileStatus == 'APPROVED' || doctor.verificationStatus == 'VERIFIED'}">
                  <span class="dd-status-pill ok"><i class="bi bi-shield-check"></i> Verified</span>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                  <span class="dd-status-pill pending"><i class="bi bi-hourglass-split"></i> Under verification</span>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'REJECTED' || doctor.doctorProfileStatus == 'CHANGES_REQUESTED' || doctor.verificationStatus == 'REJECTED'}">
                  <span class="dd-status-pill warn"><i class="bi bi-exclamation-triangle"></i> Changes required</span>
                </c:when>
                <c:otherwise>
                  <span class="dd-status-pill warn"><i class="bi bi-shield"></i> Verification required — ${profileCompletion}% complete</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="dd-profile-completion-card" style="background:#fff;border:1px solid var(--border);border-radius:12px;padding:18px;margin-bottom:8px;display:flex;align-items:center;gap:18px;flex-wrap:wrap;">
            <div class="completion-circle" style="width:72px;height:72px;border-radius:50%;background:conic-gradient(#F43F5E ${profileCompletion}%, #e2e8f0 0);display:flex;align-items:center;justify-content:center;flex-shrink:0;">
              <div style="width:58px;height:58px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:16px;color:#0F172A;">${profileCompletion}%</div>
            </div>
            <div style="flex:1;min-width:200px;">
              <c:choose>
                <c:when test="${doctor.doctorProfileStatus == 'APPROVED' || doctor.verificationStatus == 'VERIFIED'}">
                  <h3 style="margin:0 0 4px;color:#16A34A;font-size:1rem;"><i class="bi bi-check-circle-fill"></i> Profile approved</h3>
                  <p style="margin:0;color:var(--dd-muted);font-size:0.88rem;">You are verified. Keep fees, schedule, and bio up to date for patients.</p>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'REJECTED' || doctor.doctorProfileStatus == 'CHANGES_REQUESTED' || doctor.verificationStatus == 'REJECTED'}">
                  <h3 style="margin:0 0 4px;color:#DC2626;font-size:1rem;"><i class="bi bi-exclamation-circle-fill"></i> Changes required</h3>
                  <p style="margin:0 0 8px;color:var(--dd-muted);font-size:0.88rem;">Update the flagged information, then resubmit for verification.</p>
                  <c:if test="${not empty doctor.rejectionReason}">
                    <div style="background:#FEF2F2;border-left:3px solid #DC2626;padding:10px 12px;border-radius:6px;font-size:0.85rem;color:#991B1B;margin-bottom:10px;">
                      <strong>Reason:</strong> ${doctor.rejectionReason}
                    </div>
                  </c:if>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                  <h3 style="margin:0 0 4px;color:#B45309;font-size:1rem;"><i class="bi bi-hourglass-split"></i> Under verification</h3>
                  <p style="margin:0;color:var(--dd-muted);font-size:0.88rem;">Admin is reviewing your profile. You will be notified when it is approved.</p>
                </c:when>
                <c:when test="${profileCompletion < 100}">
                  <h3 style="margin:0 0 4px;color:#0F172A;font-size:1rem;">${profileCompletion}% complete</h3>
                  <p style="margin:0 0 8px;color:var(--dd-muted);font-size:0.88rem;">Finish the missing sections below, then submit for verification.</p>
                </c:when>
                <c:otherwise>
                  <h3 style="margin:0 0 4px;color:#16A34A;font-size:1rem;">100% complete — ready to submit</h3>
                  <p style="margin:0 0 10px;color:var(--dd-muted);font-size:0.88rem;">Review your details, then submit for admin verification.</p>
                  <form action="${pageContext.request.contextPath}/doctors/submit-for-verification" method="post" style="margin:0;">
                    <button type="submit" class="dd-btn-save" style="padding:8px 18px;font-size:13px;">Submit for Verification</button>
                  </form>
                </c:otherwise>
              </c:choose>
              <c:if test="${not empty missingItems}">
                <div class="dd-missing-chips" style="margin-top:10px;">
                  <c:forEach var="m" items="${missingItems}"><span>${m}</span></c:forEach>
                </div>
              </c:if>
            </div>
          </div>

          <div class="dd-profile-section-title">Professional</div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Medical Reg. No.</span><span class="value">${not empty doctor.medicalRegNumber ? doctor.medicalRegNumber : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Specialization</span><span class="value">${not empty doctor.specialization ? doctor.specialization : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Qualification</span><span class="value">${not empty doctor.qualification ? doctor.qualification : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Experience</span><span class="value">${doctor.experienceYears != null ? doctor.experienceYears : '—'} years</span></div>
          </div>

          <div class="dd-profile-section-title">Clinic / Hospital</div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Hospital / Clinic</span><span class="value">${not empty doctor.hospitalName ? doctor.hospitalName : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Address</span><span class="value">${not empty doctor.clinicAddress ? doctor.clinicAddress : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">City / State</span><span class="value">${not empty doctor.city ? doctor.city : '—'}<c:if test="${not empty doctor.state}">, ${doctor.state}</c:if></span></div>
            <div class="dd-profile-item"><span class="label">Pincode</span><span class="value">${not empty doctor.pincode ? doctor.pincode : '—'}</span></div>
          </div>

          <div class="dd-profile-section-title">Consultation &amp; availability</div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Modes</span><span class="value">${not empty doctor.consultationModes ? doctor.consultationModes : (doctor.consultationType != null ? doctor.consultationType : '—')}</span></div>
            <div class="dd-profile-item"><span class="label">Available days</span><span class="value">${not empty doctor.availableDays ? doctor.availableDays : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Hours</span><span class="value">${not empty doctor.startTime ? doctor.startTime : '—'} – ${not empty doctor.endTime ? doctor.endTime : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Emergency</span><span class="value">${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'Available' : 'Not available'}</span></div>
            <div class="dd-profile-item"><span class="label">Languages</span><span class="value">${not empty doctor.languages ? doctor.languages : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Services</span><span class="value">${not empty doctor.services ? doctor.services : '—'}</span></div>
          </div>

          <div class="dd-profile-section-title">Fees</div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Consultation</span><span class="value">&#8377; ${doctor.consultationFee != null ? doctor.consultationFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Video</span><span class="value">&#8377; ${doctor.videoFee != null ? doctor.videoFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Chat</span><span class="value">&#8377; ${doctor.chatFee != null ? doctor.chatFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Call</span><span class="value">&#8377; ${doctor.callFee != null ? doctor.callFee : '—'}</span></div>
          </div>

          <div class="dd-profile-section-title">About</div>
          <c:choose>
            <c:when test="${not empty doctor.bio}">
              <div class="dd-bio-block">${doctor.bio}</div>
            </c:when>
            <c:otherwise>
              <div class="dd-bio-block" style="color:#94a3b8;">No bio added yet. Add a short professional introduction in Complete Profile.</div>
            </c:otherwise>
          </c:choose>

          <div class="dd-profile-section-title">Account (private)</div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Email</span><span class="value">${doctor.email}</span></div>
            <div class="dd-profile-item"><span class="label">Phone</span><span class="value">${not empty doctor.phone ? doctor.phone : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Gender</span><span class="value">${doctor.gender != null ? doctor.gender : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Documents</span><span class="value">
              <c:choose>
                <c:when test="${not empty doctor.medicalLicensePath || not empty doctor.degreeCertificatePath || not empty doctor.idProofPath}">Uploaded</c:when>
                <c:otherwise>Not uploaded</c:otherwise>
              </c:choose>
            </span></div>
          </div>

          <div style="margin-top:24px;display:flex;flex-wrap:wrap;gap:10px;">
            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-btn-save" style="text-decoration:none;display:inline-flex;align-items:center;gap:6px;">
              <i class="bi bi-pencil-square"></i>
              <c:choose>
                <c:when test="${profileCompletion < 100}">Complete / Update Profile</c:when>
                <c:otherwise>Edit Profile Sections</c:otherwise>
              </c:choose>
            </a>
            <a href="${pageContext.request.contextPath}/doctors/dashboard?section=schedule" class="dd-btn-edit" style="text-decoration:none;"><i class="bi bi-clock"></i> Edit Schedule</a>
            <a href="${pageContext.request.contextPath}/doctors/dashboard?section=earnings" class="dd-btn-edit" style="text-decoration:none;"><i class="bi bi-wallet2"></i> Edit Fees</a>
          </div>
        </div>
      </div>
    </c:if>

    <%-- ══════ SCHEDULE SECTION ══════ --%>
    <c:if test="${section == 'schedule'}">
      <!-- VIEW MODE -->
      <div class="dd-section" id="scheduleView">
        <div class="dd-section-header">
          <h2><i class="bi bi-clock"></i> Schedule & Availability</h2>
          <button onclick="document.getElementById('scheduleView').style.display='none';document.getElementById('scheduleEdit').style.display='block';" class="dd-btn-edit"><i class="bi bi-pencil-square"></i> Edit</button>
        </div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Available Days</span><span class="value">${doctor.availableDays != null ? doctor.availableDays : 'Not set'}</span></div>
            <div class="dd-profile-item"><span class="label">Timing</span><span class="value">${doctor.startTime != null ? doctor.startTime : '—'} — ${doctor.endTime != null ? doctor.endTime : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Emergency</span><span class="value">${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'Available' : 'Not available'}</span></div>
            <div class="dd-profile-item"><span class="label">Clinic Address</span><span class="value">${doctor.clinicAddress != null ? doctor.clinicAddress : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">City</span><span class="value">${doctor.city != null ? doctor.city : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">State</span><span class="value">${doctor.state != null ? doctor.state : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Pincode</span><span class="value">${doctor.pincode != null ? doctor.pincode : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Google Map</span><span class="value">${doctor.googleMapLocation != null ? doctor.googleMapLocation : '—'}</span></div>
          </div>
        </div>
      </div>

      <!-- EDIT MODE -->
      <div class="dd-section" id="scheduleEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Edit Schedule</h2>
          <button onclick="document.getElementById('scheduleEdit').style.display='none';document.getElementById('scheduleView').style.display='block';" class="dd-btn-edit"><i class="bi bi-x-lg"></i> Cancel</button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-schedule" method="post">
            <div class="dd-edit-grid">
              <div class="dd-edit-field full">
                <label>Available Days</label>
                <div class="dd-day-toggles">
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="MONDAY" ${doctor.availableDays != null && doctor.availableDays.contains('MONDAY') ? 'checked' : ''}><span>Mon</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="TUESDAY" ${doctor.availableDays != null && doctor.availableDays.contains('TUESDAY') ? 'checked' : ''}><span>Tue</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="WEDNESDAY" ${doctor.availableDays != null && doctor.availableDays.contains('WEDNESDAY') ? 'checked' : ''}><span>Wed</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="THURSDAY" ${doctor.availableDays != null && doctor.availableDays.contains('THURSDAY') ? 'checked' : ''}><span>Thu</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="FRIDAY" ${doctor.availableDays != null && doctor.availableDays.contains('FRIDAY') ? 'checked' : ''}><span>Fri</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="SATURDAY" ${doctor.availableDays != null && doctor.availableDays.contains('SATURDAY') ? 'checked' : ''}><span>Sat</span></label>
                  <label class="dd-day"><input type="checkbox" name="availableDays" value="SUNDAY" ${doctor.availableDays != null && doctor.availableDays.contains('SUNDAY') ? 'checked' : ''}><span>Sun</span></label>
                </div>
              </div>
              <div class="dd-edit-field"><label>Start Time</label><input type="time" name="startTime" value="${doctor.startTime != null ? doctor.startTime : '09:00'}"></div>
              <div class="dd-edit-field"><label>End Time</label><input type="time" name="endTime" value="${doctor.endTime != null ? doctor.endTime : '18:00'}"></div>
              <div class="dd-edit-field full">
                <label>Emergency Availability</label>
                <label class="dd-switch-label"><input type="checkbox" name="emergencyAvailable" value="yes" ${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'checked' : ''}><span class="dd-switch-track"><span class="dd-switch-thumb"></span></span> Available for emergencies</label>
              </div>
              <div class="dd-edit-field full"><label>Clinic Address</label><textarea name="clinicAddress" rows="2">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea></div>
              <div class="dd-edit-field"><label>City</label><input type="text" name="city" value="${doctor.city != null ? doctor.city : ''}"></div>
              <div class="dd-edit-field"><label>State</label><input type="text" name="state" value="${doctor.state != null ? doctor.state : ''}"></div>
              <div class="dd-edit-field"><label>Pincode</label><input type="text" name="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6"></div>
              <div class="dd-edit-field"><label>Google Map Link</label><input type="url" name="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}"></div>
            </div>
            <div style="margin-top:20px;display:flex;gap:10px">
              <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Changes</button>
              <button type="button" onclick="document.getElementById('scheduleEdit').style.display='none';document.getElementById('scheduleView').style.display='block';" class="dd-btn-cancel">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </c:if>

    <%-- ══════ EARNINGS SECTION ══════ --%>
    <c:if test="${section == 'earnings'}">

      <!-- Earnings Summary Stats -->
      <div class="dd-stats">
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${totalEarnings}</h3><p>Total Earnings</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-receipt-cutoff"></i></div><div class="dd-stat-info"><h3>${paidCount}</h3><p>Paid Bookings</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-cash-stack"></i></div><div class="dd-stat-info"><h3>&#8377;${doctor.consultationFee != null ? doctor.consultationFee : 0}</h3><p>Consultation Fee</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingCount}</h3><p>Pending</p></div></div>
      </div>

      <!-- Fee Breakdown -->
      <div class="dd-section" id="feesView">
        <div class="dd-section-header">
          <h2><i class="bi bi-wallet2"></i> Fee Breakdown</h2>
          <button type="button" class="dd-btn-edit" onclick="document.getElementById('feesView').style.display='none';document.getElementById('feesEdit').style.display='block';">
            <i class="bi bi-pencil-square"></i> Edit
          </button>
        </div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Consultation Fee</span><span class="value" style="color:#0F172A;font-weight:700">&#8377; ${doctor.consultationFee != null ? doctor.consultationFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Chat Fee</span><span class="value">&#8377; ${doctor.chatFee != null ? doctor.chatFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Call Fee</span><span class="value">&#8377; ${doctor.callFee != null ? doctor.callFee : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Video Fee</span><span class="value">&#8377; ${doctor.videoFee != null ? doctor.videoFee : '—'}</span></div>
          </div>
        </div>
      </div>

      <div class="dd-section" id="feesEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Edit Fee Breakdown</h2>
          <button type="button" class="dd-btn-edit" onclick="document.getElementById('feesEdit').style.display='none';document.getElementById('feesView').style.display='block';">
            <i class="bi bi-x-lg"></i> Cancel
          </button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-fees" method="post">
            <div class="dd-edit-grid">
              <div class="dd-edit-field">
                <label>Consultation Fee (₹)</label>
                <input type="number" name="consultationFee" min="0" step="1" value="${doctor.consultationFee != null ? doctor.consultationFee : ''}" required>
              </div>
              <div class="dd-edit-field">
                <label>Chat Fee (₹)</label>
                <input type="number" name="chatFee" min="0" step="1" value="${doctor.chatFee != null ? doctor.chatFee : ''}">
              </div>
              <div class="dd-edit-field">
                <label>Call Fee (₹)</label>
                <input type="number" name="callFee" min="0" step="1" value="${doctor.callFee != null ? doctor.callFee : ''}">
              </div>
              <div class="dd-edit-field">
                <label>Video Fee (₹)</label>
                <input type="number" name="videoFee" min="0" step="1" value="${doctor.videoFee != null ? doctor.videoFee : ''}">
              </div>
              <div class="dd-edit-field">
                <label>UPI ID</label>
                <input type="text" name="upiId" maxlength="100" placeholder="doctor@upi" value="${doctor.upiId != null ? doctor.upiId : ''}">
              </div>
              <div class="dd-edit-field" style="grid-column: 1 / -1;">
                <label>Bank Details</label>
                <textarea name="bankDetails" rows="3" maxlength="500" placeholder="Account name, number, IFSC, bank name">${doctor.bankDetails != null ? doctor.bankDetails : ''}</textarea>
              </div>
            </div>
            <div style="margin-top:20px;display:flex;gap:10px">
              <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Fees</button>
              <button type="button" class="dd-btn-cancel" onclick="document.getElementById('feesEdit').style.display='none';document.getElementById('feesView').style.display='block';">Cancel</button>
            </div>
          </form>
        </div>
      </div>

      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-credit-card-2-front"></i> Payment Methods</h2></div>
        <div class="dd-section-body padded">
          <div class="dd-pay-methods">
            <div class="dd-pay-method-card">
              <div class="dd-pay-method-title"><i class="bi bi-phone"></i> UPI</div>
              <div class="dd-pay-method-value">${not empty doctor.upiId ? doctor.upiId : 'Not configured'}</div>
            </div>
            <div class="dd-pay-method-card">
              <div class="dd-pay-method-title"><i class="bi bi-bank"></i> Bank Transfer</div>
              <div class="dd-pay-method-value">${not empty doctor.bankDetails ? doctor.bankDetails : 'Not configured'}</div>
            </div>
            <div class="dd-pay-method-card">
              <div class="dd-pay-method-title"><i class="bi bi-shield-check"></i> Online Bookings</div>
              <div class="dd-pay-method-value">Razorpay (patient payments)</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Booking Transactions Table -->
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-table"></i> Booking Transactions (${appointmentCount})</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}">
            <div class="dd-empty">
              <i class="bi bi-wallet2"></i>
              <p>No earnings yet</p>
              <span class="hint">Paid consultations and clinic bookings will appear here once patients book and pay. Configure your fees in the section above.</span>
            </div>
          </c:if>
          <c:if test="${not empty appointments}">
            <div class="dd-table-wrap"><table class="dd-table"><thead><tr>
              <th>Patient</th>
              <th>Date & Time</th>
              <th>Reason</th>
              <th>Type</th>
              <th>Status</th>
              <th>Payment Method</th>
              <th>Payment ID</th>

              <th style="text-align:right">Amount</th>
            </tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <tr>
                  <td data-label="Patient">
                    <div class="dd-user-cell">
                      <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                      <div>
                        <span style="font-weight:600">${a.user.fullName}</span>
                        <div style="font-size:11px;color:#6b7280">${a.user.email}</div>
                      </div>
                    </div>
                  </td>
                  <td data-label="Date & Time">${a.appointmentTime}</td>
                  <td data-label="Reason">${a.reason != null ? a.reason : '—'}</td>
                  <td data-label="Type">
                    <c:choose>
                      <c:when test="${a.consultationType == 'VIDEO'}"><span style="color:#be123c"><i class="bi bi-camera-video"></i> Video</span></c:when>
                      <c:when test="${a.consultationType == 'CLINIC'}"><span style="color:#1e293b"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                      <c:otherwise><span style="color:#6b7280"><i class="bi bi-chat-dots"></i> General</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td data-label="Status">
                    <c:choose>
                      <c:when test="${a.status == 'PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when>
                      <c:when test="${a.status == 'CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when>
                      <c:when test="${a.status == 'COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when>
                      <c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise>
                    </c:choose>
                  </td>

                  <td data-label="Payment Method">
                    <c:choose>
                      <c:when test="${not empty a.razorpayPaymentId}">
                        <span class="dd-pay-badge online"><i class="bi bi-credit-card"></i> Razorpay</span>
                      </c:when>
                      <c:when test="${a.amountPaid != null && a.amountPaid > 0}">
                        <span class="dd-pay-badge paid"><i class="bi bi-check2-circle"></i> Paid</span>
                      </c:when>
                      <c:otherwise>
                        <span class="dd-pay-badge unpaid"><i class="bi bi-dash-circle"></i> Unpaid</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td data-label="Payment ID" class="dd-payment-id">${not empty a.razorpayPaymentId ? a.razorpayPaymentId : '—'}</td>

                  <td data-label="Channel" style="font-size:13px; font-weight: 500;">
                    <c:choose>
                      <c:when test="${a.razorpayPaymentId != null}">
                        <span style="color: #0F172A;"><i class="bi bi-credit-card"></i> Online</span>
                        <div style="font-size:10px;color:#6b7280;font-family:monospace;margin-top:4px;">${a.razorpayPaymentId}</div>
                      </c:when>
                      <c:otherwise>
                        <span style="color: #6b7280;"><i class="bi bi-cash"></i> Pay at Clinic</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td data-label="Amount" style="text-align:right;font-weight:700;color:#0F172A">
                    <c:choose>
                      <c:when test="${a.amountPaid != null && a.amountPaid > 0}">&#8377;${a.amountPaid}</c:when>
                      <c:otherwise><span style="color:#6b7280;font-weight:400">Unpaid</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
    </c:if>

    <%-- ══════ PRESCRIPTIONS SECTION ══════ --%>
    <c:if test="${section == 'prescriptions'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-file-earmark-medical"></i> Patient Prescriptions</h2></div>
        <div class="dd-section-body">
          <c:if test="${completedCount == 0}">
            <div class="dd-empty">
              <i class="bi bi-file-earmark-medical"></i>
              <p>No prescriptions to write yet</p>
              <span class="hint">After you mark an appointment as Completed, you can write or edit that patient's prescription here.</span>
              <a class="dd-empty-cta" href="${pageContext.request.contextPath}/doctors/dashboard?section=appointments"><i class="bi bi-calendar-check"></i> Go to appointments</a>
            </div>
          </c:if>
          <c:if test="${completedCount > 0}">
            <div class="dd-table-wrap"><table class="dd-table"><thead><tr>
              <th>Patient</th>
              <th>Date & Time</th>
              <th>Status</th>
              <th>Prescription</th>
              <th>Action</th>
            </tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <c:if test="${a.status == 'COMPLETED'}">
                  <tr>
                    <td data-label="Patient">
                      <div class="dd-user-cell">
                        <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                        <div>
                          <span style="font-weight:600">${a.user.fullName}</span>
                        </div>
                      </div>
                    </td>
                    <td data-label="Date & Time">${a.appointmentTime}</td>
                    <td data-label="Status"><span class="dd-badge completed"><span class="dot"></span> Completed</span></td>
                    <td data-label="Prescription">
                      <c:choose>
                        <c:when test="${not empty a.prescriptionText}"><span style="color:#16A34A;font-weight:600"><i class="bi bi-check-circle"></i> Written</span></c:when>
                        <c:otherwise><span style="color:#6b7280">Not Written</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td data-label="Action">
                      <textarea id="presc-data-${a.id}" style="display:none;" data-patient-name="<c:out value='${a.user.fullName}'/>"><c:out value="${a.prescriptionText}" /></textarea>
                      <button type="button" class="dd-btn-edit" style="font-size:12px;padding:6px 12px;" onclick="openPrescriptionModal('${a.id}')">
                        <i class="bi bi-pencil-square"></i> ${empty a.prescriptionText ? 'Write' : 'Edit'}
                      </button>
                    </td>
                  </tr>
                </c:if>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>
      
      <!-- Prescription Modal -->
      <div id="prescriptionModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:#fff;border-radius:16px;width:100%;max-width:500px;padding:24px;box-shadow:0 10px 40px rgba(0,0,0,0.2);">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
            <h3 style="margin:0;font-size:18px;font-weight:700;"><i class="bi bi-file-earmark-medical" style="color:#F43F5E"></i> Write Prescription</h3>
            <button type="button" onclick="closePrescriptionModal()" style="background:transparent;border:none;font-size:20px;cursor:pointer;color:var(--dd-muted)"><i class="bi bi-x-lg"></i></button>
          </div>
          <form id="prescriptionForm" method="post" action="">
            <div style="margin-bottom:16px;">
              <label style="display:block;font-size:12px;font-weight:600;color:var(--dd-muted);margin-bottom:6px;">Patient</label>
              <input type="text" id="prescPatientName" readonly style="width:100%;padding:10px 14px;border:2px solid var(--dd-border);border-radius:10px;font-size:13px;background:var(--dd-bg);outline:none;font-family:'Poppins',sans-serif;">
            </div>
            <div style="margin-bottom:20px;">
              <label style="display:block;font-size:12px;font-weight:600;color:var(--dd-muted);margin-bottom:6px;">Prescription / Rx</label>
              <textarea name="prescriptionText" id="prescText" rows="6" required maxlength="2000"
                        placeholder="Write medicines, dosage, and instructions here..."
                        style="width:100%;padding:10px 14px;border:2px solid var(--dd-border);border-radius:10px;font-size:13px;outline:none;font-family:'Poppins',sans-serif;resize:vertical;"></textarea>
              <div style="display:flex;justify-content:space-between;margin-top:6px;">
                <span id="prescLimitMsg" style="font-size:11px;color:#be123c;font-weight:600;display:none;">Maximum 2000 characters allowed.</span>
                <span style="font-size:11px;color:var(--dd-muted);margin-left:auto;"><span id="prescCount">0</span>/2000</span>
              </div>
            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
              <button type="button" onclick="closePrescriptionModal()" style="padding:10px 20px;border:none;border-radius:999px;background:rgba(107,114,128,0.1);color:var(--dd-muted);font-size:13px;font-weight:600;cursor:pointer;">Cancel</button>
              <button type="submit" id="prescSaveBtn" style="padding:10px 20px;border:none;border-radius:999px;background:#F43F5E;color:#fff;font-size:13px;font-weight:700;cursor:pointer;box-shadow:0 4px 12px rgba(244,63,94,0.25);">Save Prescription</button>
            </div>
          </form>
        </div>
      </div>
      <script>
      var PRESCRIPTION_MAX = 2000;
      function updatePrescCounter() {
          var ta = document.getElementById('prescText');
          var count = document.getElementById('prescCount');
          var msg = document.getElementById('prescLimitMsg');
          var btn = document.getElementById('prescSaveBtn');
          if (!ta || !count) return;
          var len = ta.value.length;
          count.textContent = len;
          if (len >= PRESCRIPTION_MAX) {
            if (msg) msg.style.display = 'inline';
            count.style.color = '#be123c';
          } else {
            if (msg) msg.style.display = 'none';
            count.style.color = '';
          }
          if (btn) btn.disabled = len === 0 || len > PRESCRIPTION_MAX;
      }
      function openPrescriptionModal(apptId) {
          var dataElem = document.getElementById('presc-data-' + apptId);
          document.getElementById('prescriptionForm').action = '${pageContext.request.contextPath}/doctors/appointments/' + apptId + '/prescription';
          document.getElementById('prescPatientName').value = dataElem.getAttribute('data-patient-name');
          document.getElementById('prescText').value = dataElem.value;
          document.getElementById('prescriptionModal').style.display = 'flex';
          updatePrescCounter();
      }
      function closePrescriptionModal() {
          document.getElementById('prescriptionModal').style.display = 'none';
      }
      document.getElementById('prescText').addEventListener('input', updatePrescCounter);
      document.getElementById('prescriptionForm').addEventListener('submit', function(e) {
          var text = document.getElementById('prescText').value.trim();
          if (!text) {
            e.preventDefault();
            alert('Prescription text is required.');
            return false;
          }
          if (text.length > PRESCRIPTION_MAX) {
            e.preventDefault();
            document.getElementById('prescLimitMsg').style.display = 'inline';
            alert('Prescription cannot exceed ' + PRESCRIPTION_MAX + ' characters.');
            return false;
          }
      });
      </script>
    </c:if>

  </div>
</main>

<script>
function toggleSidebar(){document.getElementById('sidebar').classList.toggle('open');document.getElementById('overlay').classList.toggle('show');}


(function() {
  var toggle = document.getElementById('notifToggle');
  var panel = document.getElementById('notifPanel');
  if (!toggle || !panel) return;

  function closePanel() {
    panel.hidden = true;
    toggle.setAttribute('aria-expanded', 'false');
  }

  function openPanel() {
    panel.hidden = false;
    toggle.setAttribute('aria-expanded', 'true');
  }

  toggle.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    if (panel.hidden) openPanel(); else closePanel();
  });

  document.addEventListener('click', function(e) {
    if (!panel.hidden && !panel.contains(e.target) && !toggle.contains(e.target)) {
      closePanel();
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closePanel();
  });
})();

document.addEventListener('DOMContentLoaded', function() {
  // Graph Logic
  var ctx = document.getElementById('appointmentsChart');
  if (ctx) {
      if (typeof Chart === 'undefined') {
          console.error("Chart.js failed to load!");
          return;
      }
      var rawAppointments = [
          <c:forEach var="a" items="${appointments}" varStatus="status">
              {
                  time: '${a.appointmentTime}',
                  status: '${a.status}'
              }${!status.last ? ',' : ''}
          </c:forEach>
      ];

      var buckets = {
          "00:00": 0, "04:00": 0, "08:00": 0,
          "12:00": 0, "16:00": 0, "20:00": 0
      };

      rawAppointments.forEach(function(appt) {
          var dateObj = new Date(appt.time);
          if (!isNaN(dateObj)) {
              var hour = dateObj.getHours();
              var bucket = "00:00";
              if (hour >= 4 && hour < 8) bucket = "04:00";
              else if (hour >= 8 && hour < 12) bucket = "08:00";
              else if (hour >= 12 && hour < 16) bucket = "12:00";
              else if (hour >= 16 && hour < 20) bucket = "16:00";
              else if (hour >= 20) bucket = "20:00";
              
              buckets[bucket]++;
          }
      });

      var labels = Object.keys(buckets);
      var dataValues = Object.values(buckets);
      
      // Calculate min and max for y-axis
      var maxVal = Math.max(...dataValues);
      if (maxVal < 5) maxVal = 5; // ensure there's at least some scale

      new Chart(ctx, {
          type: 'line',
          data: {
              labels: labels,
              datasets: [{
                  label: 'Patients Seen',
                  data: dataValues,
                  borderColor: '#F43F5E',
                  backgroundColor: 'rgba(244, 63, 94, 0.16)',
                  borderWidth: 2,
                  fill: true,
                  tension: 0.3,
                  pointBackgroundColor: '#F43F5E',
                  pointRadius: 4
              }]
          },
          options: {
              responsive: true,
              scales: {
                  x: { title: { display: true, text: 'Time (4 Hours Format)' } },
                  y: { 
                      min: 0, 
                      max: maxVal + 1, 
                      title: { display: true, text: 'Number of Patients' }, 
                      ticks: { stepSize: 1 } 
                  }
              }
          }
      });
  }
});

function openPatientPreview(el) {
  var overlay = document.getElementById('patientPreviewModal');
  if (!overlay || !el) return;
  var val = function(name, fallback) {
    var v = el.getAttribute(name);
    return (v && String(v).trim()) ? v : (fallback || 'Not provided');
  };
  var patient = val('data-patient', 'Patient');
  var time = val('data-time', 'Time to be confirmed');
  var reason = val('data-reason', 'Not provided');
  var type = val('data-type', 'Consult');
  var status = val('data-status', 'PENDING');
  var payment = el.getAttribute('data-payment') || '';
  var amount = el.getAttribute('data-amount') || '';
  var receipt = el.getAttribute('data-receipt') || '';
  var notes = el.getAttribute('data-notes') || '';
  var email = el.getAttribute('data-email') || '';
  var phone = el.getAttribute('data-phone') || '';
  var age = el.getAttribute('data-age') || '';
  var gender = el.getAttribute('data-gender') || '';
  var chatUrl = el.getAttribute('data-chat-url') || '';
  var videoUrl = el.getAttribute('data-video-url') || '';
  var callUrl = el.getAttribute('data-call-url') || '';
  var statusUrl = el.getAttribute('data-status-url') || '';
  var hasRx = el.getAttribute('data-rx') === '1';
  var typeLabel = type === 'VIDEO' ? 'Video consultation' : (type === 'CLINIC' ? 'Clinic visit' : (type === 'ONLINE' ? 'Online' : type));
  var payLabel = amount ? ((payment || 'Paid') + ' · ₹' + amount) : (payment || 'Payment pending');

  document.getElementById('ppAvatar').textContent = patient.charAt(0).toUpperCase();
  document.getElementById('ppName').textContent = patient;
  var nameRepeat = document.getElementById('ppNameRepeat');
  if (nameRepeat) nameRepeat.textContent = patient;
  document.getElementById('ppTime').textContent = time;
  document.getElementById('ppReason').textContent = reason;
  document.getElementById('ppType').textContent = typeLabel;
  document.getElementById('ppStatus').textContent = status;
  document.getElementById('ppStatus').className = 'doc-status ' + String(status).toLowerCase();
  document.getElementById('ppPayment').textContent = payLabel;
  document.getElementById('ppEmail').textContent = email || 'Not provided';
  document.getElementById('ppPhone').textContent = phone || 'Not provided';
  document.getElementById('ppAge').textContent = age || 'Not provided';
  document.getElementById('ppGender').textContent = gender || 'Not provided';
  document.getElementById('ppReceipt').textContent = receipt || 'Not issued';
  document.getElementById('ppNotes').textContent = notes || 'No notes yet';
  document.getElementById('ppRx').textContent = hasRx ? 'Prescription on file' : 'None yet';

  var chatBtn = document.getElementById('ppChatBtn');
  var videoBtn = document.getElementById('ppVideoBtn');
  var callBtn = document.getElementById('ppCallBtn');
  var confirmBtn = document.getElementById('ppConfirmBtn');
  var completeBtn = document.getElementById('ppCompleteBtn');
  var statusForm = document.getElementById('ppStatusForm');
  if (chatUrl) { chatBtn.href = chatUrl; chatBtn.style.display = 'inline-flex'; }
  else { chatBtn.style.display = 'none'; }
  var canJoin = String(status).toUpperCase() === 'CONFIRMED' && (type === 'VIDEO' || type === 'ONLINE');
  if (videoUrl && canJoin) { videoBtn.href = videoUrl; videoBtn.style.display = 'inline-flex'; }
  else { videoBtn.style.display = 'none'; }
  if (callUrl && canJoin) { callBtn.href = callUrl; callBtn.style.display = 'inline-flex'; }
  else { callBtn.style.display = 'none'; }
  if (statusUrl) {
    statusForm.action = statusUrl;
    confirmBtn.style.display = String(status).toUpperCase() === 'PENDING' ? 'inline-flex' : 'none';
    completeBtn.style.display = String(status).toUpperCase() === 'CONFIRMED' ? 'inline-flex' : 'none';
  } else {
    confirmBtn.style.display = 'none';
    completeBtn.style.display = 'none';
  }

  overlay.classList.add('open');
}
function closePatientPreview() {
  var overlay = document.getElementById('patientPreviewModal');
  if (overlay) overlay.classList.remove('open');
}
function submitPreviewStatus(status) {
  var form = document.getElementById('ppStatusForm');
  var input = document.getElementById('ppStatusValue');
  if (!form || !form.action || !input) return;
  input.value = status;
  form.submit();
}
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closePatientPreview();
});

</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div id="patientPreviewModal" class="doc-modal-overlay" onclick="if(event.target===this)closePatientPreview()">
  <div class="doc-modal" role="dialog" aria-modal="true" aria-labelledby="ppName">
    <div class="doc-modal-header">
      <div class="doc-appt-avatar" id="ppAvatar">P</div>
      <div>
        <h3 id="ppName">Patient</h3>
        <p>Appointment &amp; patient preview</p>
      </div>
      <button type="button" class="doc-modal-close" onclick="closePatientPreview()" aria-label="Close"><i class="bi bi-x-lg"></i></button>
    </div>
    <div class="doc-modal-body">
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">1</span> Patient information</h4>
        <div class="doc-modal-row"><span class="k">Name</span><span class="v" id="ppNameRepeat"></span></div>
        <div class="doc-modal-row"><span class="k">Age</span><span class="v" id="ppAge">Not provided</span></div>
        <div class="doc-modal-row"><span class="k">Gender</span><span class="v" id="ppGender">Not provided</span></div>
        <div class="doc-modal-row"><span class="k">Phone</span><span class="v" id="ppPhone">Not provided</span></div>
        <div class="doc-modal-row"><span class="k">Email</span><span class="v" id="ppEmail">Not provided</span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">2</span> Appointment details</h4>
        <div class="doc-modal-row"><span class="k">Date &amp; time</span><span class="v" id="ppTime">—</span></div>
        <div class="doc-modal-row"><span class="k">Consultation type</span><span class="v" id="ppType">—</span></div>
        <div class="doc-modal-row"><span class="k">Status</span><span class="v"><span id="ppStatus" class="doc-status pending">Pending</span></span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">3</span> Reason / symptoms</h4>
        <div class="doc-modal-row"><span class="k">Provided by patient</span><span class="v" id="ppReason">—</span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">4</span> Payment</h4>
        <div class="doc-modal-row"><span class="k">Payment</span><span class="v" id="ppPayment">—</span></div>
        <div class="doc-modal-row"><span class="k">Receipt</span><span class="v" id="ppReceipt">Not issued</span></div>
      </div>
      <div class="doc-review-block">
        <h4 class="doc-review-title"><span class="ri">5</span> Clinical notes</h4>
        <div class="doc-modal-row"><span class="k">Doctor notes</span><span class="v" id="ppNotes">No notes yet</span></div>
        <div class="doc-modal-row"><span class="k">Prescription</span><span class="v" id="ppRx">None yet</span></div>
      </div>
    </div>
    <div class="doc-modal-footer">
      <a id="ppChatBtn" class="doc-modal-btn primary" href="#" target="_blank"><i class="bi bi-chat-dots-fill"></i> Chat</a>
      <a id="ppCallBtn" class="doc-modal-btn success" href="#" target="_blank" style="display:none"><i class="bi bi-telephone-fill"></i> Call</a>
      <a id="ppVideoBtn" class="doc-modal-btn success" href="#" target="_blank" style="display:none"><i class="bi bi-camera-video-fill"></i> Join video</a>
      <button type="button" id="ppConfirmBtn" class="doc-modal-btn success" style="display:none" onclick="submitPreviewStatus('CONFIRMED')"><i class="bi bi-check2"></i> Confirm</button>
      <button type="button" id="ppCompleteBtn" class="doc-modal-btn primary" style="display:none" onclick="submitPreviewStatus('COMPLETED')"><i class="bi bi-check-circle"></i> Complete</button>
      <button type="button" class="doc-modal-btn secondary" onclick="closePatientPreview()">Close</button>
    </div>
    <form id="ppStatusForm" method="post" style="display:none"><input type="hidden" name="status" id="ppStatusValue"></form>
  </div>
</div>
</body>
</html>

