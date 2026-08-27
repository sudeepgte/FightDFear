<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard &mdash; Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #F43F5E;
            --primary-light: #FFE4E6;
            --text-main: #1E1B4B;
            --text-muted: #64748B;
            --bg-page: #F8FAFC;
            --bg-card: #FFFFFF;
            --border: #E2E8F0;
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            --sidebar-width: 260px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg-page); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar */
        .sidebar { width: var(--sidebar-width); background: var(--bg-card); border-right: 1px solid var(--border); display: flex; flex-direction: column; height: 100%; position: relative; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; font-weight: 800; font-size: 1.25rem; color: var(--text-main); border-bottom: 1px solid var(--border); }
        .brand img { width: 32px; height: 32px; border-radius: 8px; }
        
        .nav-links { flex: 1; padding: 20px 16px; overflow-y: auto; display: flex; flex-direction: column; gap: 4px; }
        .nav-link { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 12px; color: var(--text-muted); font-weight: 600; text-decoration: none; transition: 0.2s; font-size: 0.95rem; }
        .nav-link i { font-size: 1.1rem; }
        .nav-link:hover { background: #f1f5f9; color: var(--text-main); }
        .nav-link.active { background: var(--primary-light); color: var(--primary); }

        .sidebar-footer { padding: 24px; text-align: center; border-top: 1px solid var(--border); position: relative; overflow: hidden; }
        .sidebar-footer img { max-width: 120px; margin: 0 auto; display: block; opacity: 0.9; }

        /* Main Content */
        .main-content { flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden; }
        
        /* Header */
        .header { background: var(--bg-card); padding: 20px 32px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        .greeting h1 { font-size: 1.4rem; font-weight: 800; margin-bottom: 4px; }
        .greeting h1 span { color: var(--primary); }
        .greeting p { color: var(--text-muted); font-size: 0.9rem; margin: 0; }
        
        .header-actions { display: flex; align-items: center; gap: 20px; }
        .icon-btn { position: relative; background: transparent; border: none; font-size: 1.3rem; color: var(--text-muted); cursor: pointer; }
        .icon-btn .badge { position: absolute; top: -4px; right: -4px; background: var(--primary); color: white; font-size: 0.65rem; font-weight: 800; padding: 2px 6px; border-radius: 50px; border: 2px solid white; }
        
        .status-dropdown { display: flex; align-items: center; gap: 8px; background: var(--bg-page); padding: 8px 16px; border-radius: 50px; font-size: 0.85rem; font-weight: 600; border: 1px solid var(--border); cursor: pointer; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; background: #10B981; }
        
        .btn-add { background: var(--primary); color: white; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem; border: none; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-add:hover { background: #E11D48; transform: translateY(-1px); }

        /* Content Area */
        .page-body { flex: 1; padding: 32px; overflow-y: auto; }
        
        /* Overview Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 24px; }
        .stat-card { background: var(--bg-card); padding: 20px; border-radius: 16px; border: 1px solid var(--border); display: flex; align-items: flex-start; gap: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.4rem; flex-shrink: 0; }
        .stat-info h4 { color: var(--text-muted); font-size: 0.8rem; font-weight: 600; margin: 0 0 4px 0; }
        .stat-info h2 { font-size: 1.6rem; font-weight: 800; margin: 0 0 4px 0; }
        .stat-info p { font-size: 0.75rem; font-weight: 600; margin: 0; color: var(--primary); }
        .stat-info p.muted { color: var(--text-muted); }

        /* Main Grid */
        .main-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; }
        
        .card { background: var(--bg-card); border-radius: 16px; border: 1px solid var(--border); padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-title { font-weight: 800; font-size: 1.1rem; display: flex; align-items: center; gap: 8px; }
        .card-link { color: var(--primary); font-size: 0.85rem; font-weight: 600; text-decoration: none; }

        /* Appointments Table */
        .appt-list { display: flex; flex-direction: column; gap: 12px; }
        .appt-item { display: grid; grid-template-columns: auto 1fr auto auto auto; gap: 16px; align-items: center; padding: 16px 0; border-bottom: 1px solid var(--border); }
        .appt-item:last-child { border-bottom: none; }
        
        .time-box { text-align: center; color: var(--primary); font-weight: 800; font-size: 0.9rem; line-height: 1.2; width: 60px; }
        .time-box span { font-size: 0.75rem; font-weight: 600; display: block; }
        
        .patient-info h4 { font-size: 0.95rem; font-weight: 700; margin: 0 0 4px 0; }
        .patient-info p { font-size: 0.8rem; color: var(--text-muted); margin: 0; }
        
        .appt-mode { font-size: 0.85rem; color: var(--text-muted); font-weight: 500; display: flex; align-items: center; gap: 6px; }
        
        .badge { padding: 4px 12px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
        .badge.upcoming { background: var(--warning-bg); color: var(--warning-text); }
        .badge.confirmed { background: var(--success-bg); color: var(--success-text); }
        .badge.completed { background: var(--success-bg); color: var(--success-text); }
        .badge.cancelled { background: var(--error-bg); color: var(--error-text); }
        
        .appt-actions form { display: inline-block; }
        .action-btn { background: #f1f5f9; border: none; width: 28px; height: 28px; border-radius: 6px; color: var(--text-muted); cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
        .action-btn:hover { background: var(--primary-light); color: var(--primary); }

        /* Quick Actions */
        .quick-actions-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .q-action-btn { background: var(--bg-page); border: 1px solid var(--border); border-radius: 12px; padding: 16px; text-align: center; color: var(--text-main); text-decoration: none; transition: 0.2s; display: flex; flex-direction: column; align-items: center; gap: 8px; font-weight: 600; font-size: 0.8rem; }
        .q-action-btn i { font-size: 1.5rem; color: var(--primary); }
        .q-action-btn:hover { border-color: var(--primary); background: var(--primary-light); }

        /* Reminders */
        .reminder-item { display: flex; align-items: flex-start; gap: 12px; padding: 12px 0; border-bottom: 1px solid var(--border); }
        .reminder-item:last-child { border-bottom: none; }
        .reminder-icon { width: 36px; height: 36px; border-radius: 8px; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .reminder-content { flex: 1; }
        .reminder-content h4 { font-size: 0.9rem; font-weight: 700; margin: 0 0 4px 0; }
        .reminder-content p { font-size: 0.8rem; color: var(--text-muted); margin: 0; }
        
        /* Verification Banner */
        .verify-banner { background: var(--warning-bg); border: 1px solid #fed7aa; border-radius: 12px; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .verify-banner.verified { background: var(--success-bg); border-color: #bbf7d0; }
        .verify-info h4 { color: var(--warning-text); font-weight: 800; font-size: 1rem; margin: 0 0 4px 0; display: flex; align-items: center; gap: 8px; }
        .verify-banner.verified .verify-info h4 { color: var(--success-text); }
        .verify-info p { color: var(--text-main); font-size: 0.85rem; margin: 0; font-weight: 500; }
        
        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 2rem; opacity: 0.5; margin-bottom: 12px; display: block; }
    </style>
=======
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Doctor Dashboard — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
  <style>
    :root {
      --primary: #F43F5E;
      --rose-soft: #FFF1F2;
      --bg-page: #F8FAFC;
      --navy: #0F172A;
      --navy-soft: #1E293B;
      --border: #E2E8F0;
    }
    body.dd-page, .dd-page { background: var(--bg-page) !important; color: var(--navy) !important; }
    .dd-sidebar {
      background: linear-gradient(180deg, var(--navy) 0%, var(--navy-soft) 100%) !important;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      max-height: 100vh;
      overflow: hidden;
    }
    .dd-sidebar-brand { border-bottom: 1px solid rgba(255, 255, 255, 0.12); }
    .dd-sidebar-nav { flex: 1 1 auto; overflow-y: auto; min-height: 0; }
    .dd-sidebar-footer { margin-top: auto; }
    .dd-main { background: var(--bg-page) !important; }
    .dd-topbar {
      background:
        radial-gradient(circle at top right, rgba(244, 63, 94, 0.12), transparent 45%),
        linear-gradient(120deg, #ffffff 0%, var(--rose-soft) 100%) !important;
      border: 1px solid var(--border);
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
      margin-bottom: 18px;
    }
    .dd-section, .dd-stat-card, .dd-chat-sidebar, .dd-chat-main, .dd-pay-method-card, .dd-profile-item {
      background: #fff !important;
      border: 1px solid var(--border) !important;
      border-radius: 14px !important;
      box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06) !important;
      color: var(--navy);
    }
    .dd-section-header, .dd-section-body, .dd-table thead th, .dd-table tbody td { color: var(--navy) !important; }
    .dd-nav-item.active {
      background: rgba(244, 63, 94, 0.14) !important;
      color: #fff !important;
      border-left: 3px solid #fff;
    }
    .dd-nav-item:hover { background: rgba(244, 63, 94, 0.2) !important; }
    .badge-count, .notif-count, .dd-notif-count-label { background: var(--primary) !important; color: #fff !important; }
    .dd-btn-save, .dd-video-btn, .dd-status-form button, .dd-btn-edit {
      background: var(--primary) !important;
      color: #fff !important;
      border: none !important;
      box-shadow: 0 8px 18px rgba(244, 63, 94, 0.24) !important;
    }
    .dd-btn-cancel { border: 1px solid var(--border) !important; }
    .dd-badge.pending { background: rgba(244, 63, 94, 0.12) !important; color: #9f1239 !important; }
    .dd-badge.confirmed, .dd-badge.completed { background: rgba(15, 23, 42, 0.08) !important; color: var(--navy) !important; }
    .dd-badge.cancelled { background: rgba(148, 163, 184, 0.2) !important; color: #475569 !important; }
    .dd-stat-icon.purple, .dd-stat-icon.gold, .dd-stat-icon.teal, .dd-stat-icon.coral {
      background: rgba(244, 63, 94, 0.12) !important;
      color: var(--primary) !important;
    }
    .dd-notif-panel, #notifDropdown {
      background: #fff !important;
      border: 1px solid var(--border) !important;
      box-shadow: 0 20px 40px rgba(15, 23, 42, 0.14) !important;
      color: var(--navy) !important;
    }
    .dd-empty { color: #64748b !important; }
    .user-avatar, .avatar-placeholder {
      background: linear-gradient(135deg, #fb7185, var(--primary)) !important;
      color: #fff !important;
    }
    .dd-chat-wrapper { height: calc(100vh - 220px) !important; min-height: 560px !important; }
    @media (max-width: 991px) {
      .dd-sidebar { max-height: none; }
      .dd-chat-wrapper { flex-direction: column; height: auto !important; min-height: 0 !important; }
      .dd-chat-sidebar { width: 100% !important; }
      .dd-chat-main { min-height: 480px; }
    }
  </style>

</head>
<body>


    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Logo">
            <div>
                Fight D Fear
                <div style="font-size: 0.7rem; color: var(--primary); font-weight: 600;">Women Safety &bull; Healthcare</div>
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

      <c:if test="${appointmentNotifCount > 0}"><span class="badge-count">${appointmentNotifCount}</span></c:if>

      <c:if test="${pendingCount > 0}"><span class="badge-count" id="sidebar-appt-badge" style="background-color: var(--dd-coral, #ff6b6b);">${pendingCount}</span></c:if>

    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats" class="dd-nav-item ${section == 'chats' ? 'active' : ''}">
      <i class="bi bi-chat-dots"></i> Chats
      <c:if test="${unreadChatCount > 0}"><span class="badge-count">${unreadChatCount}</span></c:if>
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=profile" class="dd-nav-item ${section == 'profile' ? 'active' : ''}">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=earnings" class="dd-nav-item ${section == 'earnings' ? 'active' : ''}">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=schedule" class="dd-nav-item ${section == 'schedule' ? 'active' : ''}">
      <i class="bi bi-clock"></i> Schedule
    </a>
    <a href="${pageContext.request.contextPath}/doctors/dashboard?section=prescriptions" class="dd-nav-item ${section == 'prescriptions' ? 'active' : ''}">
      <i class="bi bi-file-earmark-medical"></i> Prescriptions
    </a>
    <div class="dd-nav-label">Other</div>
    <a href="${pageContext.request.contextPath}/doctors/list" class="dd-nav-item">
      <i class="bi bi-people"></i> All Doctors
    </a>
  </nav>
  <div class="dd-sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="dd-nav-item" style="color:rgba(255,241,242,0.92)">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<%-- ═══ MAIN ═══ --%>
<main class="dd-main">
  <header class="dd-topbar">
    <div class="dd-topbar-left">
      <button class="dd-hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
      <div>
        <h1><c:choose>
          <c:when test="${section == 'appointments'}">Appointments</c:when>
          <c:when test="${section == 'profile'}">My Profile</c:when>
          <c:when test="${section == 'earnings'}">Earnings & Fees</c:when>
          <c:when test="${section == 'schedule'}">Schedule</c:when>
          <c:when test="${section == 'prescriptions'}">Prescriptions</c:when>
          <c:when test="${section == 'chats'}">Chats</c:when>
          <c:otherwise>Dashboard</c:otherwise>
        </c:choose></h1>
        <div class="breadcrumb-text">Welcome back, Dr. ${doctor.fullName}!</div>
      </div>
    </div>
    <div class="dd-topbar-right">

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

      <style>
        .notif-item:hover { background: rgba(0,0,0,0.02); }
      </style>
      <div class="notif-btn" id="bellIcon" onclick="toggleNotifications()" style="cursor: pointer; position: relative;">
        <i class="bi bi-bell"></i>
        <c:if test="${pendingCount > 0}"><span class="dot" id="bell-dot"></span></c:if>
      </div>
      
      <!-- Notifications Dropdown -->
      <div id="notifDropdown" class="dd-notif-dropdown" style="display:none; position:absolute; top:70px; right:20px; width:300px; background:var(--dd-bg, #fff); border:1px solid var(--dd-border, rgba(255,255,255,0.1)); border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,0.2); z-index:1000; overflow:hidden;">
        <div style="padding:15px; border-bottom:1px solid var(--dd-border, rgba(255,255,255,0.05)); display:flex; justify-content:space-between; align-items:center;">
          <h3 style="margin:0; font-size:14px; font-weight:700;">Notifications</h3>
          <c:if test="${pendingCount > 0}"><span class="badge" id="notif-badge" style="background:var(--dd-coral, #ff6b6b); color:#fff; font-size:10px; padding:2px 6px; border-radius:10px;">${pendingCount} New</span></c:if>
>>>>>>> 16cf85ce996ab1a16542e394dc5bd4bcae6a13f5
        </div>
        
        <nav class="nav-links">
            <a href="?section=overview" class="nav-link ${section == 'overview' || empty section ? 'active' : ''}"><i class="bi bi-house-door"></i> Dashboard</a>
            <a href="?section=appointments" class="nav-link ${section == 'appointments' ? 'active' : ''}"><i class="bi bi-calendar-event"></i> Appointments</a>
            <a href="?section=patients" class="nav-link ${section == 'patients' ? 'active' : ''}"><i class="bi bi-people"></i> Patients</a>
            <a href="?section=consultations" class="nav-link ${section == 'consultations' ? 'active' : ''}"><i class="bi bi-chat-dots"></i> Consultations</a>
            <a href="?section=prescriptions" class="nav-link ${section == 'prescriptions' ? 'active' : ''}"><i class="bi bi-file-medical"></i> Prescriptions</a>
            <a href="?section=earnings" class="nav-link ${section == 'earnings' ? 'active' : ''}"><i class="bi bi-wallet2"></i> Earnings</a>
            <a href="?section=calendar" class="nav-link ${section == 'calendar' ? 'active' : ''}"><i class="bi bi-calendar3"></i> Calendar</a>
            <a href="?section=reviews" class="nav-link ${section == 'reviews' ? 'active' : ''}"><i class="bi bi-star"></i> Reviews</a>
            <a href="?section=settings" class="nav-link ${section == 'settings' ? 'active' : ''}"><i class="bi bi-gear"></i> Settings</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="margin-top: auto;" onclick="return confirm('Are you sure you want to logout?');"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </nav>
        
        <div class="sidebar-footer">
            <img src="${pageContext.request.contextPath}/assets/img/doctor-illustration.svg" onerror="this.style.display='none'" alt="Doctor">
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <header class="header">
            <div class="greeting">
                <h1>Dr. <span>${doctor.fullName}</span></h1>
                <p>Here's an overview of your clinic today.</p>
            </div>
            <div class="header-actions">
                <!-- Notifications -->
                <div style="position:relative; display:inline-block;">
                    <button class="icon-btn" onclick="document.getElementById('notifMenu').style.display = document.getElementById('notifMenu').style.display === 'block' ? 'none' : 'block'">
                        <i class="bi bi-bell"></i>
                        <c:if test="${unreadNotifCount > 0}">
                            <span class="badge">${unreadNotifCount}</span>
                        </c:if>
                    </button>
                    <div id="notifMenu" style="display:none; position:absolute; right:0; top:45px; background:#fff; border:1px solid #e2e8f0; border-radius:12px; width:300px; box-shadow:0 10px 25px rgba(0,0,0,0.1); z-index:100;">
                        <div style="padding:16px; border-bottom:1px solid #e2e8f0; font-weight:700;">Notifications</div>
                        <div style="max-height:300px; overflow-y:auto;">
                            <c:choose>
                                <c:when test="${empty recentNotifications}">
                                    <div style="padding:16px; text-align:center; color:#64748B;">No new notifications</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="n" items="${recentNotifications}">
                                        <div style="padding:12px 16px; border-bottom:1px solid #f1f5f9; font-size:14px; ${n.readFlag ? 'color:#64748B;' : 'font-weight:600; color:#1E1B4B;'}">
                                            ${n.message}
                                            <div style="font-size:12px; color:#94a3b8; margin-top:4px;">${n.createdAt.toString().substring(0, 16)}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Online Status Toggle -->
                <form action="${pageContext.request.contextPath}/doctors/toggle-online" method="post" style="margin:0;">
                    <button type="submit" class="status-dropdown" style="background:transparent; border:1px solid var(--border); font-size:0.9rem; cursor:pointer;">
                        <span class="status-dot" style="background: ${doctor.isOnline ? '#22c55e' : '#94a3b8'};"></span> 
                        ${doctor.isOnline ? 'Available' : 'Offline'}
                    </button>
                </form>

                <!-- Add Availability Modal Trigger -->
                <button class="btn-add" onclick="document.getElementById('availabilityModal').style.display='flex'"><i class="bi bi-plus-lg"></i> Add Availability</button>
            </div>
        </header>

        <!-- Add Availability Modal -->
        <div id="availabilityModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
            <div style="background:#fff; padding:24px; border-radius:16px; width:100%; max-width:400px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 style="margin:0; font-weight:700;">Add Availability</h3>
                    <button onclick="document.getElementById('availabilityModal').style.display='none'" style="background:none; border:none; font-size:1.5rem; cursor:pointer;">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/doctors/update-availability" method="post">
                    <div style="margin-bottom:16px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">Available Days</label>
                        <input type="text" name="availableDays" value="${doctor.availableDays}" placeholder="e.g. MON,TUE,WED" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <div style="margin-bottom:16px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">Start Time</label>
                        <input type="time" name="startTime" value="${doctor.startTime}" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <div style="margin-bottom:24px;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; font-size:14px;">End Time</label>
                        <input type="time" name="endTime" value="${doctor.endTime}" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:8px;" required>
                    </div>
                    <button type="submit" class="btn-primary" style="width:100%; padding:12px; border:none; border-radius:8px; font-weight:600; cursor:pointer;">Save Availability</button>
                </form>
            </div>
        </div>

        <!-- Body -->
        <c:choose>
            <c:when test="${empty doctor.profileCompletionPct || doctor.profileCompletionPct < 100}">
                <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:60vh; text-align:center;">
                    <i class="bi bi-person-lines-fill" style="font-size: 4rem; color: #F43F5E; margin-bottom: 20px;"></i>
                    <h2 style="font-weight: 800; color: #1E1B4B; margin-bottom: 12px;">Update Profile First</h2>
                    <p style="color: #64748B; font-size: 1rem; max-width: 400px; line-height: 1.6; margin-bottom: 24px;">
                        You must complete your profile 100% to access the dashboard and continue the verification process.
                    </p>
                    <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-primary" style="text-decoration: none; display: inline-block; padding: 12px 24px; border-radius: 8px; font-weight: 600;">Complete Profile Now</a>
                </div>
            </c:when>
            <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:60vh; text-align:center;">
                    <i class="bi bi-hourglass-split" style="font-size: 4rem; color: #64748B; margin-bottom: 20px;"></i>
                    <h2 style="font-weight: 800; color: #1E1B4B; margin-bottom: 12px;">Profile Under Review</h2>
                    <p style="color: #64748B; font-size: 1rem; max-width: 400px; line-height: 1.6;">
                        Your profile has been submitted successfully and is currently being reviewed by our administration team. 
                        You will gain full access to your dashboard once approved.
                    </p>
                </div>
            </c:when>
            <c:otherwise>

        <div class="page-body">

              <div style="padding:40px 20px; text-align:center; color:var(--dd-muted, #9ca3af); font-size:13px;">
                <i class="bi bi-bell-slash" style="font-size:24px; opacity:0.5; margin-bottom:10px; display:block;"></i>
                No new notifications.
              </div>
            </c:otherwise>
          </c:choose>

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
      <div class="dd-stats">
        <div class="dd-stat-card"><div class="dd-stat-icon purple"><i class="bi bi-calendar2-check"></i></div><div class="dd-stat-info"><h3>${appointmentCount}</h3><p>Total Appointments</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon gold"><i class="bi bi-hourglass-split"></i></div><div class="dd-stat-info"><h3>${pendingCount}</h3><p>Pending</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon teal"><i class="bi bi-check-circle"></i></div><div class="dd-stat-info"><h3>${confirmedCount}</h3><p>Confirmed</p></div></div>
        <div class="dd-stat-card"><div class="dd-stat-icon coral"><i class="bi bi-currency-rupee"></i></div><div class="dd-stat-info"><h3>&#8377;${doctor.consultationFee != null ? doctor.consultationFee : 0}</h3><p>Consultation Fee</p></div></div>
      </div>
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> Recent Appointments</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}"><div class="dd-empty"><i class="bi bi-calendar-x"></i><p>No appointments yet.</p></div></c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr><th>Patient</th><th>Time</th><th>Status</th><th>Actions</th></tr></thead><tbody>
              <c:forEach var="a" items="${appointments}" begin="0" end="4">
                <tr><td><div class="dd-user-cell"><div class="user-avatar">${a.user.fullName.charAt(0)}</div><span>${a.user.fullName}</span></div></td>
                <td>${a.appointmentTime}</td>
                <td><c:choose><c:when test="${a.status=='PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when><c:when test="${a.status=='CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when><c:when test="${a.status=='COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when><c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise></c:choose></td>
                <td>
                  <div style="display:flex;gap:8px;align-items:center;">
                    <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form"><select name="status"><option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option><option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option><option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option><option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option></select><button type="submit"><i class="bi bi-check2"></i></button></form>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn" style="background:#F43F5E"><i class="bi bi-chat-dots-fill"></i></a>
                  </div>
                </td></tr>
              </c:forEach>
            </tbody></table></div>
          </c:if>
        </div>
      </div>

      <div class="dd-section" style="margin-top: 20px;">
        <div class="dd-section-header"><h2><i class="bi bi-graph-up"></i> Patient Traffic Graph</h2></div>
        <div class="dd-section-body">
          <canvas id="appointmentsChart" height="100"></canvas>
        </div>
      </div>
    </c:if>

    <%-- ══════ APPOINTMENTS SECTION ══════ --%>
    <c:if test="${section == 'appointments'}">
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-calendar-check"></i> All Appointments (${appointmentCount})</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}"><div class="dd-empty"><i class="bi bi-calendar-x"></i><p>No appointments yet.</p></div></c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr><th>Patient</th><th>Date & Time</th><th>Reason</th><th>Type</th><th>Status</th><th>Actions</th></tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <tr><td><div class="dd-user-cell"><div class="user-avatar">${a.user.fullName.charAt(0)}</div><span>${a.user.fullName}</span></div></td>
                <td>${a.appointmentTime}</td>
                <td>${a.reason != null ? a.reason : '—'}</td>
                <td><c:choose><c:when test="${a.consultationType=='VIDEO'}"><span style="color:#be123c"><i class="bi bi-camera-video"></i> Video</span></c:when><c:when test="${a.consultationType=='CLINIC'}"><span style="color:#1e293b"><i class="bi bi-hospital"></i> Clinic</span></c:when><c:otherwise><span style="color:#64748b"><i class="bi bi-chat-dots"></i> General</span></c:otherwise></c:choose></td>
                <td><c:choose><c:when test="${a.status=='PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when><c:when test="${a.status=='CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when><c:when test="${a.status=='COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when><c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise></c:choose></td>
                <td>
                  <div style="display:flex;gap:8px;align-items:center;">
                    <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post" class="dd-status-form"><select name="status"><option value="PENDING" ${a.status=='PENDING'?'selected':''}>Pending</option><option value="CONFIRMED" ${a.status=='CONFIRMED'?'selected':''}>Confirmed</option><option value="COMPLETED" ${a.status=='COMPLETED'?'selected':''}>Completed</option><option value="CANCELLED" ${a.status=='CANCELLED'?'selected':''}>Cancelled</option></select><button type="submit"><i class="bi bi-check2"></i></button></form>
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" target="_blank" class="dd-video-btn" style="background:#F43F5E"><i class="bi bi-chat-dots-fill"></i></a>
                    <c:if test="${a.consultationType=='VIDEO' && a.status=='CONFIRMED'}"><a href="${pageContext.request.contextPath}/consultation/video/${a.id}" target="_blank" class="dd-video-btn"><i class="bi bi-camera-video-fill"></i> Join</a></c:if>
                  </div>
                </td></tr>
              </c:forEach>
            </tbody></table></div>
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
          <div class="dd-chat-sidebar" style="width: 320px; background: var(--dd-bg); border: 1px solid var(--dd-border); border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
            <div style="padding: 20px; border-bottom: 1px solid var(--dd-border); background: rgba(255,255,255,0.02);">
              <h3 style="margin: 0; font-size: 16px; font-weight: 700;">Patients</h3>
              <p style="margin: 4px 0 0; font-size: 12px; color: var(--dd-muted);">Select a patient to chat</p>
            </div>

            
            <c:if test="${not empty message}">
                <div style="padding:14px 20px; border-radius:12px; background:var(--success-bg); border:1px solid #bbf7d0; color:var(--success-text); font-size:13px; font-weight:600; margin-bottom:24px; display:flex; align-items:center; gap:8px">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                </div>

            </c:if>

            <c:choose>
                <%-- ======================= OVERVIEW ======================= --%>
                <c:when test="${section == 'overview' || empty section}">
                    
                    <c:if test="${doctor.doctorProfileStatus != 'APPROVED' && (empty doctor.profileCompletionPct || doctor.profileCompletionPct < 100)}">
                        <div style="padding:16px 20px; border-radius:12px; background:var(--warning-bg); border:1px solid #fed7aa; color:var(--warning-text); margin-bottom:24px; display:flex; align-items:center; justify-content:space-between; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);">
                            <div>
                                <h4 style="margin:0 0 4px 0; font-weight:800; font-size:1.05rem;"><i class="bi bi-exclamation-triangle-fill"></i> Profile Incomplete (${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%)</h4>
                                <p style="margin:0; font-size:0.85rem; color:var(--text-main); font-weight:500;">Your profile is missing important details. Please complete it to become fully visible to patients.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-add" style="background:#C2410C;"><i class="bi bi-pencil-square"></i> Update Profile</a>

              </c:if>
              
              <c:forEach var="u" items="${chatUsers}">
                <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats&userId=${u.id}" 
                   style="display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; border-radius: 10px; margin-bottom: 5px; transition: all 0.2s; background: ${targetUserId == u.id ? 'rgba(244,63,94,0.12)' : 'transparent'}; border: 1px solid ${targetUserId == u.id ? 'rgba(244,63,94,0.32)' : 'transparent'};">
                  <div class="user-avatar" style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg,#fb7185,#F43F5E); display: flex; align-items: center; justify-content: center; font-weight: 600; color: #fff; flex-shrink: 0;">${u.fullName.charAt(0)}</div>
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
          <div class="dd-chat-main" style="flex: 1; background: var(--dd-bg); border: 1px solid var(--dd-border); border-radius: 16px; display: flex; flex-direction: column; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
            <c:choose>
              
              <c:when test="${not empty targetUserId}">
                <!-- Chat Header -->
                <div style="padding: 16px 24px; border-bottom: 1px solid var(--dd-border); display: flex; align-items: center; justify-content: space-between; background: rgba(255,255,255,0.02);">
                  <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="user-avatar" style="width: 42px; height: 42px; border-radius: 50%; background: linear-gradient(135deg,#fb7185,#F43F5E); display: flex; align-items: center; justify-content: center; font-weight: 600; color: #fff;">${targetUserName != null ? targetUserName.charAt(0) : 'U'}</div>
                    <div>
                      <h3 style="margin: 0; font-size: 16px; font-weight: 700;">${targetUserName}</h3>
                      <p style="margin: 2px 0 0; font-size: 12px; color: #20c997; display: flex; align-items: center; gap: 4px;"><span style="width: 6px; height: 6px; border-radius: 50%; background: #20c997; display: inline-block;"></span> Online</p>
                    </div>
                  </div>
                  <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}?userId=${targetUserId}" target="_blank" style="width: 36px; height: 36px; border-radius: 10px; background: rgba(32,201,151,0.1); color: #20c997; display: flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.2s;"><i class="bi bi-telephone-fill"></i></a>
                    <a href="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}?userId=${targetUserId}" target="_blank" style="width: 36px; height: 36px; border-radius: 10px; background: rgba(244,63,94,0.12); color: #be123c; display: flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.2s;"><i class="bi bi-camera-video-fill"></i></a>
                  </div>
                </div>
                
                <!-- Chat Messages -->
                <div id="chatMessages" style="flex: 1; padding: 20px 24px; overflow-y: auto; display: flex; flex-direction: column; gap: 12px; background: rgba(0,0,0,0.1);">
                  <c:if test="${empty chatHistory}">
                    <div style="margin: auto; text-align: center; color: var(--dd-muted);">
                      <i class="bi bi-chat-dots" style="font-size: 40px; margin-bottom: 10px; display: block; opacity: 0.5;"></i>
                      <p>Start conversation with ${targetUserName}</p>
                    </div>
                  </c:if>
                  <c:forEach var="m" items="${chatHistory}">
                    <div style="max-width: 75%; padding: 12px 16px; border-radius: 16px; font-size: 13px; line-height: 1.5; ${m.senderType == 'DOCTOR' ? 'align-self: flex-end; background: linear-gradient(135deg,#fb7185,#F43F5E); color: #fff; border-bottom-right-radius: 4px;' : 'align-self: flex-start; background: #f1f5f9; color: #0F172A; border-bottom-left-radius: 4px;'}">
                      ${m.message}
                      <span style="display: block; font-size: 9px; opacity: 0.6; margin-top: 4px; text-align: right;">${m.timestamp}</span>
                    </div>
                  </c:forEach>
                </div>
                
                <!-- Chat Input -->
                <div style="padding: 16px 24px; border-top: 1px solid var(--dd-border); display: flex; gap: 12px; align-items: center; background: rgba(255,255,255,0.02);">
                  <input type="text" id="msgInput" placeholder="Type your message..." style="flex: 1; padding: 14px 20px; border: 1px solid var(--dd-border); border-radius: 999px; background: #fff; color: #333; font-family: 'Poppins', sans-serif; font-size: 14px; outline: none; transition: 0.2s;" onkeypress="if(event.key==='Enter')sendMsg()" />
                  <button onclick="sendMsg()" style="width: 48px; height: 48px; border-radius: 50%; border: none; background: linear-gradient(135deg,#fb7185,#F43F5E); color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 4px 12px rgba(244,63,94,0.35); transition: 0.2s;"><i class="bi bi-send-fill" style="margin-left: 2px;"></i></button>
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
                        styles += "align-self: flex-end; background: linear-gradient(135deg,#fb7185,#F43F5E); color: #fff; border-bottom-right-radius: 4px;";
                    } else {
                        styles += "align-self: flex-start; background: #f1f3f5; color: #333; border-bottom-left-radius: 4px;";
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
                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: var(--dd-muted);">
                  <div style="width: 80px; height: 80px; border-radius: 50%; background: rgba(255,255,255,0.03); display: flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                    <i class="bi bi-chat-square-dots" style="font-size: 32px; color: #F43F5E; filter: drop-shadow(0 0 10px rgba(244,63,94,0.35));"></i>
                  </div>
                  <h3 style="font-size: 18px; font-weight: 600; color: #fff; margin: 0 0 8px;">Select a Patient</h3>
                  <p style="font-size: 14px; text-align: center; max-width: 300px;">Choose a patient from the sidebar to view your conversation or start a new message.</p>
                </div>
              </c:otherwise>
              
            </c:choose>
          </div>
          
        </div>
      </div>
    </c:if>

    <%-- ══════ PROFILE SECTION ══════ --%>
    <c:if test="${section == 'profile'}">
      <!-- VIEW -->
      <div class="dd-section" id="profileView">
        <div class="dd-section-header">
          <h2><i class="bi bi-person"></i> Comprehensive Profile</h2>
          <div style="display:flex;gap:10px;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="dd-btn-edit" style="text-decoration:none;"><i class="bi bi-pencil-square"></i> Complete / Update Profile</a>
            <button type="button" onclick="document.getElementById('profileView').style.display='none';document.getElementById('profileEdit').style.display='block';" class="dd-btn-edit"><i class="bi bi-sliders"></i> Quick Edit</button>
          </div>
        </div>
        <div class="dd-section-body padded">
          
          <!-- Profile Completion & Verification Status Card -->
          <div class="dd-profile-completion-card" style="background: #fff; border: 1px solid var(--border); border-radius: 12px; padding: 20px; margin-bottom: 25px; display: flex; align-items: center; gap: 20px;">
            <div class="completion-circle" style="width: 80px; height: 80px; border-radius: 50%; background: conic-gradient(#F43F5E ${profileCompletion}%, #e2e8f0 0); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
              <div style="width: 65px; height: 65px; border-radius: 50%; background: #1a1a1a; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 18px; color: #fff;">
                ${profileCompletion}%
              </div>
            </div>
            <div class="completion-info" style="flex-grow: 1;">
              <c:choose>
                <c:when test="${doctor.doctorProfileStatus == 'APPROVED' || doctor.verificationStatus == 'VERIFIED'}">
                  <h3 style="margin: 0 0 5px; color: #4CAF50;"><i class="bi bi-check-circle-fill"></i> Profile Approved</h3>
                  <p style="margin: 0; color: var(--dd-muted); font-size: 14px;">Your profile has been verified and approved by the admin. You can now move forward.</p>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'REJECTED' || doctor.doctorProfileStatus == 'CHANGES_REQUESTED' || doctor.verificationStatus == 'REJECTED'}">
                  <h3 style="margin: 0 0 5px; color: #F44336;"><i class="bi bi-exclamation-circle-fill"></i> Changes Required</h3>
                  <p style="margin: 0 0 5px; color: var(--dd-muted); font-size: 14px;">Your profile requires some changes before it can be approved. Please review and update the required information.</p>
                  <c:if test="${not empty doctor.rejectionReason}">
                    <div style="background: rgba(244, 67, 54, 0.1); border-left: 3px solid #F44336; padding: 10px; margin-bottom: 15px; border-radius: 4px; font-size: 13px; color: #ffcccc;">
                      <strong>Reason:</strong> ${doctor.rejectionReason}
                    </div>
                  </c:if>
                  <button onclick="document.getElementById('profileView').style.display='none';document.getElementById('profileEdit').style.display='block';" class="dd-btn-save" style="padding: 8px 20px; font-size: 14px; margin-top: 10px;">Update Profile</button>
                </c:when>
                <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                  <h3 style="margin: 0 0 5px; color: #FFC107;"><i class="bi bi-hourglass-split"></i> Profile Status: Under Verification</h3>
                  <p style="margin: 0; color: var(--dd-muted); font-size: 14px;">Your profile is currently being verified by the admin. Please wait for approval.</p>
                </c:when>
                <c:otherwise>
                  <c:choose>
                    <c:when test="${profileCompletion < 100}">
                      <h3 style="margin: 0 0 5px; color: #fff;">${profileCompletion}% Profile Completed</h3>
                      <p style="margin: 0 0 15px; color: var(--dd-muted); font-size: 14px;">Your profile is ${profileCompletion}% complete. Please update your profile to complete the remaining details to 100% before submitting it for verification.</p>
                      <button onclick="document.getElementById('profileView').style.display='none';document.getElementById('profileEdit').style.display='block';" class="dd-btn-save" style="padding: 8px 20px; font-size: 14px;">Update Profile</button>
                    </c:when>
                    <c:otherwise>
                      <h3 style="margin: 0 0 5px; color: #4CAF50;">100% Profile Completed</h3>
                      <p style="margin: 0 0 15px; color: var(--dd-muted); font-size: 14px;">Your profile is 100% complete. Please submit your application to be verified by the admin.</p>
                      <form action="${pageContext.request.contextPath}/doctors/submit-for-verification" method="post" style="margin: 0;">
                        <button type="submit" class="dd-btn-save" style="padding: 8px 20px; font-size: 14px;">Submit Profile for Verification</button>
                      </form>
                    </c:otherwise>
                  </c:choose>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Full Name</span><span class="value">${doctor.fullName}</span></div>
            <div class="dd-profile-item"><span class="label">Email</span><span class="value">${doctor.email}</span></div>
            <div class="dd-profile-item"><span class="label">Phone</span><span class="value">${doctor.phone}</span></div>
            <div class="dd-profile-item"><span class="label">Gender</span><span class="value">${doctor.gender != null ? doctor.gender : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Specialization</span><span class="value">${doctor.specialization}</span></div>
            <div class="dd-profile-item"><span class="label">Qualification</span><span class="value">${doctor.qualification != null ? doctor.qualification : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Experience</span><span class="value">${doctor.experienceYears != null ? doctor.experienceYears : '—'} years</span></div>
            <div class="dd-profile-item"><span class="label">Medical Reg No.</span><span class="value">${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Hospital</span><span class="value">${doctor.hospitalName != null ? doctor.hospitalName : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Consultation Type</span><span class="value">${doctor.consultationType != null ? doctor.consultationType : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Location</span><span class="value">${doctor.locationText != null ? doctor.locationText : '—'}</span></div>
            <div class="dd-profile-item"><span class="label">Rating</span><span class="value"><i class="bi bi-star-fill" style="color:#ffd700"></i> ${doctor.rating}</span></div>
          </div>
        </div>
      </div>
      <!-- EDIT -->
      <div class="dd-section" id="profileEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Complete Profile Setup</h2>
          <button onclick="document.getElementById('profileEdit').style.display='none';document.getElementById('profileView').style.display='block';" class="dd-btn-edit"><i class="bi bi-x-lg"></i> Cancel</button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-full-profile" method="post" enctype="multipart/form-data">
            
            <!-- STEP 1: Basic Details -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 10px; margin-bottom: 20px; color: #be123c; font-size: 16px;">1. Basic Details</h3>
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Full Name</label><input type="text" name="fullName" value="${doctor.fullName}" required minlength="3"></div>
              <div class="dd-edit-field"><label>Email (read-only)</label><input type="email" value="${doctor.email}" disabled style="opacity:0.6"></div>
              <div class="dd-edit-field"><label>Phone</label><input type="tel" name="phone" value="${doctor.phone}" required pattern="[0-9]{10}"></div>
              <div class="dd-edit-field">
                <label>Gender</label>
                <select name="gender">
                  <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                  <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                  <option value="OTHER" ${doctor.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                </select>
              </div>
              <div class="dd-edit-field full">
                <label>Profile Photo</label>
                <input type="file" name="profilePhoto" accept="image/png, image/jpeg" style="padding: 10px; border-radius: 8px; width: 100%; border: 1px solid var(--dd-border);">
              </div>
            </div>

            <!-- STEP 2: Professional Details -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 40px; margin-bottom: 20px; color: #be123c; font-size: 16px;">2. Professional Details</h3>
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Medical Reg No.</label><input type="text" name="medicalRegNumber" value="${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : ''}" required></div>
              <div class="dd-edit-field"><label>Specialization</label><input type="text" name="specialization" value="${doctor.specialization != null ? doctor.specialization : ''}" required></div>
              <div class="dd-edit-field"><label>Experience (years)</label><input type="number" name="experienceYears" value="${doctor.experienceYears != null ? doctor.experienceYears : ''}" min="0"></div>
              <div class="dd-edit-field"><label>Qualification</label><input type="text" name="qualification" value="${doctor.qualification != null ? doctor.qualification : ''}"></div>
              <div class="dd-edit-field"><label>Hospital / Clinic Name</label><input type="text" name="hospitalName" value="${doctor.hospitalName != null ? doctor.hospitalName : ''}"></div>
              <div class="dd-edit-field">
                <label>Consultation Type</label>
                <select name="consultationType">
                  <option value="ONLINE" ${doctor.consultationType == 'ONLINE' ? 'selected' : ''}>Online Only</option>
                  <option value="OFFLINE" ${doctor.consultationType == 'OFFLINE' ? 'selected' : ''}>Clinic Only</option>
                  <option value="BOTH" ${doctor.consultationType == 'BOTH' ? 'selected' : ''}>Both Online & Clinic</option>
                </select>
              </div>
            </div>

            <!-- STEP 3: Location -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 40px; margin-bottom: 20px; color: #be123c; font-size: 16px;">3. Location</h3>
            <div class="dd-edit-grid">
              <div class="dd-edit-field full"><label>Clinic Address</label><textarea name="clinicAddress" rows="2" style="width: 100%; border-radius: 8px; border: 1px solid var(--dd-border); padding: 12px; font-family: inherit; color: #333; background: #fff;">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea></div>
              <div class="dd-edit-field"><label>City</label><input type="text" name="city" value="${doctor.city != null ? doctor.city : ''}"></div>
              <div class="dd-edit-field"><label>State</label><input type="text" name="state" value="${doctor.state != null ? doctor.state : ''}"></div>
              <div class="dd-edit-field"><label>Pincode</label><input type="text" name="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6"></div>
              <div class="dd-edit-field full"><label>Google Map Link</label><input type="url" name="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}" placeholder="https://maps.google.com/..."></div>
            </div>

            <!-- STEP 4: Availability -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 40px; margin-bottom: 20px; color: #be123c; font-size: 16px;">4. Availability</h3>
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
            </div>

            <!-- STEP 5: Verification Documents -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 40px; margin-bottom: 10px; color: #be123c; font-size: 16px;">5. Verification Documents</h3>
            <p style="font-size: 13px; color: var(--dd-muted); margin-bottom: 20px;">Upload documents if needed. Existing files are kept if you don't upload new ones.</p>
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Medical License</label><input type="file" name="medicalLicense" accept=".pdf, image/*" style="padding: 10px; border-radius: 8px; width: 100%; border: 1px solid var(--dd-border);"></div>
              <div class="dd-edit-field"><label>ID Proof (Aadhar/PAN)</label><input type="file" name="idProof" accept=".pdf, image/*" style="padding: 10px; border-radius: 8px; width: 100%; border: 1px solid var(--dd-border);"></div>
              <div class="dd-edit-field"><label>Degree Certificate</label><input type="file" name="degreeCertificate" accept=".pdf, image/*" style="padding: 10px; border-radius: 8px; width: 100%; border: 1px solid var(--dd-border);"></div>
            </div>

            <!-- STEP 6: Payment Details -->
            <h3 style="border-bottom: 1px solid var(--dd-border); padding-bottom: 10px; margin-top: 40px; margin-bottom: 20px; color: #be123c; font-size: 16px;">6. Payment Details</h3>
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Consultation Fee (₹)</label><input type="number" name="consultationFee" value="${doctor.consultationFee != null ? doctor.consultationFee : '0'}" min="0"></div>
              <div class="dd-edit-field"><label>Video Fee (₹)</label><input type="number" name="videoFee" value="${doctor.videoFee != null ? doctor.videoFee : '0'}" min="0"></div>
              <div class="dd-edit-field"><label>Call Fee (₹)</label><input type="number" name="callFee" value="${doctor.callFee != null ? doctor.callFee : '0'}" min="0"></div>
              <div class="dd-edit-field"><label>Chat Fee (₹)</label><input type="number" name="chatFee" value="${doctor.chatFee != null ? doctor.chatFee : '0'}" min="0"></div>
              <div class="dd-edit-field full"><label>UPI ID</label><input type="text" name="upiId" value="${doctor.upiId != null ? doctor.upiId : ''}" placeholder="username@bank"></div>
            </div>

            <div style="margin-top:40px;display:flex;gap:15px; border-top: 1px solid var(--dd-border); padding-top: 20px;">
              <button type="submit" class="dd-btn-save" style="padding: 12px 30px; font-size: 15px; font-weight: 600;"><i class="bi bi-check-circle"></i> Save Complete Profile</button>
              <button type="button" onclick="document.getElementById('profileEdit').style.display='none';document.getElementById('profileView').style.display='block';" class="dd-btn-cancel" style="padding: 12px 30px; font-size: 15px; font-weight: 600;">Cancel</button>
            </div>
          </form>
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
            <div class="dd-profile-item"><span class="label">Emergency</span><span class="value">${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? '✅ Yes' : '❌ No'}</span></div>
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

      <div class="dd-section" id="feeBreakdownView">
        <div class="dd-section-header">
          <h2><i class="bi bi-wallet2"></i> Fee Breakdown</h2>
          <button onclick="document.getElementById('feeBreakdownView').style.display='none';document.getElementById('feeBreakdownEdit').style.display='block';" class="dd-btn-edit"><i class="bi bi-pencil-square"></i> Edit</button>

        </div>
        <div class="dd-section-body padded">
          <div class="dd-profile-grid">
            <div class="dd-profile-item"><span class="label">Consultation Fee</span><span class="value" style="color:#20c997;font-weight:700">&#8377; ${doctor.consultationFee != null ? doctor.consultationFee : '—'}</span></div>
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
      
      <!-- Fee Breakdown Edit -->
      <div class="dd-section" id="feeBreakdownEdit" style="display:none">
        <div class="dd-section-header">
          <h2><i class="bi bi-pencil-square"></i> Edit Fee Breakdown</h2>
          <button onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';" class="dd-btn-edit"><i class="bi bi-x-lg"></i> Cancel</button>
        </div>
        <div class="dd-section-body padded">
          <form action="${pageContext.request.contextPath}/doctors/update-earnings" method="post">
            <div class="dd-edit-grid">
              <div class="dd-edit-field"><label>Consultation Fee</label><input type="number" name="consultationFee" value="${doctor.consultationFee != null ? doctor.consultationFee : ''}" min="0"></div>
              <div class="dd-edit-field"><label>Chat Fee</label><input type="number" name="chatFee" value="${doctor.chatFee != null ? doctor.chatFee : ''}" min="0"></div>
              <div class="dd-edit-field"><label>Call Fee</label><input type="number" name="callFee" value="${doctor.callFee != null ? doctor.callFee : ''}" min="0"></div>
              <div class="dd-edit-field"><label>Video Fee</label><input type="number" name="videoFee" value="${doctor.videoFee != null ? doctor.videoFee : ''}" min="0"></div>
              <div class="dd-edit-field full"><label>UPI ID</label><input type="text" name="upiId" value="${doctor.upiId != null ? doctor.upiId : ''}" placeholder="e.g. yourname@upi"></div>
              <div class="dd-edit-field full"><label>Bank Details</label><textarea name="bankDetails" rows="2" placeholder="Account No, IFSC, etc.">${doctor.bankDetails != null ? doctor.bankDetails : ''}</textarea></div>
            </div>
            <div style="margin-top:20px;display:flex;gap:10px">
              <button type="submit" class="dd-btn-save"><i class="bi bi-check-circle"></i> Save Changes</button>
              <button type="button" onclick="document.getElementById('feeBreakdownEdit').style.display='none';document.getElementById('feeBreakdownView').style.display='block';" class="dd-btn-cancel">Cancel</button>
            </div>
          </form>
        </div>
      </div>

      <!-- Booking Transactions Table -->
      <div class="dd-section">
        <div class="dd-section-header"><h2><i class="bi bi-table"></i> Booking Transactions (${appointmentCount})</h2></div>
        <div class="dd-section-body">
          <c:if test="${empty appointments}">
            <div class="dd-empty"><i class="bi bi-inbox"></i><p>No bookings yet.</p></div>
          </c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr>
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
                  <td>
                    <div class="dd-user-cell">
                      <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                      <div>
                        <span style="font-weight:600">${a.user.fullName}</span>
                        <div style="font-size:11px;color:#6b7280">${a.user.email}</div>
                      </div>
                    </div>
                  </td>
                  <td>${a.appointmentTime}</td>
                  <td>${a.reason != null ? a.reason : '—'}</td>
                  <td>
                    <c:choose>
                      <c:when test="${a.consultationType == 'VIDEO'}"><span style="color:#be123c"><i class="bi bi-camera-video"></i> Video</span></c:when>
                      <c:when test="${a.consultationType == 'CLINIC'}"><span style="color:#1e293b"><i class="bi bi-hospital"></i> Clinic</span></c:when>
                      <c:otherwise><span style="color:#6b7280"><i class="bi bi-chat-dots"></i> General</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${a.status == 'PENDING'}"><span class="dd-badge pending"><span class="dot"></span> Pending</span></c:when>
                      <c:when test="${a.status == 'CONFIRMED'}"><span class="dd-badge confirmed"><span class="dot"></span> Confirmed</span></c:when>
                      <c:when test="${a.status == 'COMPLETED'}"><span class="dd-badge completed"><span class="dot"></span> Completed</span></c:when>
                      <c:otherwise><span class="dd-badge cancelled"><span class="dot"></span> Cancelled</span></c:otherwise>
                    </c:choose>
                  </td>

                  <td>
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
                  <td class="dd-payment-id">${not empty a.razorpayPaymentId ? a.razorpayPaymentId : '—'}</td>

                  <td style="font-size:13px; font-weight: 500;">
                    <c:choose>
                      <c:when test="${a.razorpayPaymentId != null}">
                        <span style="color: #20c997;"><i class="bi bi-credit-card"></i> Online</span>
                        <div style="font-size:10px;color:#6b7280;font-family:monospace;margin-top:4px;">${a.razorpayPaymentId}</div>
                      </c:when>
                      <c:otherwise>
                        <span style="color: #6b7280;"><i class="bi bi-cash"></i> Pay at Clinic</span>
                      </c:otherwise>
                    </c:choose>
                  </td>

                  <td style="text-align:right;font-weight:700;color:#20c997">
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
          <c:if test="${empty appointments}">
            <div class="dd-empty"><i class="bi bi-inbox"></i><p>No appointments found.</p></div>
          </c:if>
          <c:if test="${not empty appointments}">
            <div style="overflow-x:auto"><table class="dd-table"><thead><tr>
              <th>Patient</th>
              <th>Date & Time</th>
              <th>Status</th>
              <th>Prescription</th>
              <th>Action</th>
            </tr></thead><tbody>
              <c:forEach var="a" items="${appointments}">
                <c:if test="${a.status == 'COMPLETED'}">
                  <tr>
                    <td>
                      <div class="dd-user-cell">
                        <div class="user-avatar">${a.user.fullName.charAt(0)}</div>
                        <div>
                          <span style="font-weight:600">${a.user.fullName}</span>

                        </div>
                    </c:if>
                    
                    <!-- Stats Grid -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-calendar-check"></i></div>
                            <div class="stat-info">
                                <h4>Today's Appointments</h4>
                                <h2>${todayTotal}</h2>
                                <p>${upcomingCount} Upcoming</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-person-hearts"></i></div>
                            <div class="stat-info">
                                <h4>Total Patients</h4>
                                <h2>${totalPatients}</h2>
                                <p class="muted">All time</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-chat-dots"></i></div>
                            <div class="stat-info">
                                <h4>Consultations</h4>
                                <h2>${consultationsThisMonth}</h2>
                                <p class="muted">This Month</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                            <div class="stat-info">
                                <h4>Earnings</h4>
                                <h2>&#8377;${earningsThisMonth}</h2>
                                <p class="muted">This Month</p>
                            </div>
                        </div>
                    </div>

                    <div class="main-grid">
                        <!-- Left Column -->
                        <div class="col-left">
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-title"><i class="bi bi-calendar-day" style="color:var(--primary)"></i> Today's Appointments</div>
                                    <a href="?section=appointments" class="card-link">View Calendar <i class="bi bi-chevron-right"></i></a>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${empty todayAppointments}">
                                        <div class="empty-state">
                                            <i class="bi bi-calendar-x"></i>
                                            <p>No appointments scheduled for today.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="appt-list">
                                            <c:forEach var="a" items="${todayAppointments}">
                                                <div class="appt-item">
                                                    <div class="time-box">
                                                        <fmt:parseDate value="${a.appointmentTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedTime" type="both" />
                                                        <fmt:formatDate pattern="hh:mm" value="${parsedTime}" />
                                                        <span><fmt:formatDate pattern="a" value="${parsedTime}" /></span>
                                                    </div>
                                                    <div class="patient-info">
                                                        <h4>${a.user.fullName}</h4>
                                                        <p>${not empty a.reason ? a.reason : 'General Consultation'}</p>
                                                    </div>
                                                    <div class="appt-mode">
                                                        <c:choose>
                                                            <c:when test="${a.consultationType == 'VIDEO'}"><i class="bi bi-camera-video"></i> Video Call</c:when>
                                                            <c:when test="${a.consultationType == 'CLINIC'}"><i class="bi bi-geo-alt"></i> In Clinic</c:when>
                                                            <c:otherwise><i class="bi bi-telephone"></i> Voice Call</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <span class="badge ${a.status == 'PENDING' || a.status == 'CONFIRMED' ? 'upcoming' : a.status.toString().toLowerCase()}">
                                                            ${a.status == 'PENDING' ? 'Upcoming' : a.status == 'CONFIRMED' ? 'Confirmed' : a.status == 'COMPLETED' ? 'Completed' : 'Cancelled'}
                                                        </span>
                                                    </div>
                                                    <div class="appt-actions">
                                                        <c:if test="${a.status == 'PENDING'}">
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="CONFIRMED"><button class="action-btn" title="Confirm"><i class="bi bi-check-lg"></i></button></form>
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="CANCELLED"><button class="action-btn" title="Reject"><i class="bi bi-x-lg"></i></button></form>
                                                        </c:if>
                                                        <c:if test="${a.status == 'CONFIRMED'}">
                                                            <form action="${pageContext.request.contextPath}/doctors/appointments/${a.id}/status" method="post"><input type="hidden" name="status" value="COMPLETED"><button class="action-btn" title="Mark Completed"><i class="bi bi-check-all"></i></button></form>
                                                        </c:if>
                                                        <c:if test="${a.status != 'CANCELLED'}">
                                                            <a href="${pageContext.request.contextPath}/doctors/chat/${doctor.id}?userId=${a.user.id}" class="action-btn" target="_blank" title="Chat"><i class="bi bi-chat-dots"></i></a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div style="text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid var(--border);">
                                    <a href="?section=appointments" class="card-link" style="font-size: 0.9rem;">View All Appointments <i class="bi bi-arrow-right"></i></a>
                                </div>
                            </div>
                            
                            <!-- Verification Banner -->
                            <c:choose>
                                <c:when test="${doctor.verificationStatus == 'VERIFIED'}">
                                    <div class="verify-banner verified">
                                        <div class="verify-info">
                                            <h4><i class="bi bi-patch-check-fill"></i> Verified Doctor</h4>
                                            <p>Your medical credentials have been verified successfully.</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${doctor.doctorProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <div class="verify-banner" style="background: #F8FAFC; border-color: var(--border);">
                                        <div class="verify-info">
                                            <h4 style="color: var(--text-muted);"><i class="bi bi-hourglass-split"></i> Under Review</h4>
                                            <p>Your profile is currently under review by the admin team.</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="verify-banner">
                                        <div class="verify-info">
                                            <h4><i class="bi bi-shield-exclamation"></i> Action Required</h4>
                                            <p>Please upload your Medical Council Registration Certificate to complete your verification.</p>
                                        </div>
                                                                                <form action="${pageContext.request.contextPath}/doctors/upload-certificate" method="post" enctype="multipart/form-data" style="display:inline;">
                                            <input type="file" id="certUpload" name="certificate" style="display:none;" onchange="this.form.submit()" accept="image/*,.pdf">
                                            <button type="button" class="btn-add" onclick="document.getElementById('certUpload').click();" style="background:#F43F5E; border:none; color:white;">Upload Now</button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Right Column -->
                        <div class="col-right">
                            <!-- Profile Completion Card -->
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="card" style="text-decoration: none; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; display: block; margin-bottom: 24px;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 10px 25px rgba(0,0,0,0.05)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px -1px rgba(0, 0, 0, 0.02)';">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <div class="card-title" style="margin-bottom: 0;">Profile Status</div>
                                    <i class="bi bi-pencil-square" style="color: var(--primary); font-size: 1.1rem;"></i>
                                </div>
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                                    <div style="flex: 1; height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden;">
                                        <div style="height: 100%; background: #16A34A; width: ${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%; border-radius: 4px;"></div>
                                    </div>
                                    <div style="font-weight: 800; color: #16A34A; font-size: 0.95rem;">${empty doctor.profileCompletionPct ? 0 : doctor.profileCompletionPct}%</div>
                                </div>
                                <p style="margin: 0; font-size: 0.8rem; color: var(--text-muted); font-weight: 500;">
                                    <c:choose>
                                        <c:when test="${doctor.profileCompletionPct == 100}">Your profile is 100% completed. Click to edit.</c:when>
                                        <c:otherwise>Your profile is incomplete. Click to finish setup.</c:otherwise>
                                    </c:choose>
                                </p>
                            </a>

                            <!-- Chart Card -->
                            <div class="card">
                                <div class="card-title" style="margin-bottom: 20px;">Today's Overview</div>
                                <div style="display: flex; align-items: center; justify-content: space-between; gap: 20px;">
                                    <div style="width: 120px; height: 120px; position: relative;">
                                        <canvas id="overviewChart"></canvas>
                                        <div style="position: absolute; top:0; left:0; right:0; bottom:0; display:flex; flex-direction:column; align-items:center; justify-content:center; font-weight:800; color:var(--text-main); font-size:1.2rem;">
                                            ${todayTotal}<span style="font-size: 0.7rem; font-weight: 600; color:var(--text-muted); display:block;">Total</span>
                                        </div>
                                    </div>
                                    <div style="flex: 1; font-size: 0.85rem; font-weight: 600; display: flex; flex-direction: column; gap: 12px;">
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: var(--primary); font-size: 0.6rem; margin-right:6px;"></i> Upcoming</span> <span>${upcomingCount}</span></div>
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: #10B981; font-size: 0.6rem; margin-right:6px;"></i> Completed</span> <span>${completedCount}</span></div>
                                        <div style="display: flex; justify-content: space-between;"><span style="color: var(--text-muted);"><i class="bi bi-circle-fill" style="color: #EF4444; font-size: 0.6rem; margin-right:6px;"></i> Cancelled</span> <span>${cancelledCount}</span></div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Quick Actions -->
                            <div class="card">
                                <div class="card-title" style="margin-bottom: 16px;">Quick Actions</div>
                                <div class="quick-actions-grid">
                                    <a href="#" class="q-action-btn"><i class="bi bi-person-plus"></i> Add Patient</a>
                                    <a href="?section=prescriptions" class="q-action-btn"><i class="bi bi-journal-medical"></i> New Prescription</a>
                                    <a href="?section=consultations" class="q-action-btn"><i class="bi bi-camera-video"></i> Video Consultation</a>
                                    <a href="?section=patients" class="q-action-btn"><i class="bi bi-file-earmark-medical"></i> Patient Reports</a>
                                </div>
                            </div>

                            <!-- Reminders -->
                            <div class="card">
                                <div class="card-header" style="margin-bottom: 16px;">
                                    <div class="card-title"><i class="bi bi-bell"></i> Upcoming Reminders</div>
                                    <a href="#" class="card-link">View All</a>
                                </div>
                                
                                <div class="reminder-item">
                                    <div class="reminder-icon"><i class="bi bi-calendar2-check"></i></div>
                                    <div class="reminder-content">
                                        <h4>Team Meeting</h4>
                                        <p>Today, 4:30 PM</p>
                                    </div>
                                    <span class="badge" style="background: var(--primary-light); color: var(--primary);">In 2 hrs</span>
                                </div>
                                
                                <!-- Add dynamic reminders here later -->
                            </div>
                        </div>
                    </div>

                    <script>
                        const ctx = document.getElementById('overviewChart').getContext('2d');
                        new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Upcoming', 'Completed', 'Cancelled'],
                                datasets: [{
                                    data: [${upcomingCount}, ${completedCount}, ${cancelledCount}],
                                    backgroundColor: ['#F43F5E', '#10B981', '#EF4444'],
                                    borderWidth: 0,
                                    cutout: '75%'
                                }]
                            },
                            options: { plugins: { legend: { display: false }, tooltip: { enabled: false } }, responsive: true, maintainAspectRatio: false }
                        });
                    </script>
                </c:when>

                                <%-- ======================= OTHER MODULES ======================= --%>
                <c:when test="${section == 'patients'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-people" style="color:var(--primary)"></i> Patients</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty patients}">
                                    <p>No patients found.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="p" items="${patients}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="font-weight:700; color:#1E1B4B; margin-bottom:4px;">${p.fullName}</div>
                                                <div style="color:#64748B; font-size:14px;">${p.email} | ${p.mobileNumber}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'consultations'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-chat-dots" style="color:var(--primary)"></i> Completed Consultations</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty consultations}">
                                    <p>No completed consultations yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="c" items="${consultations}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                                                    <strong style="color:#1E1B4B;">${c.user.fullName}</strong>
                                                    <span style="font-size:14px; color:#64748B;">${c.appointmentTime.toLocalDate()}</span>
                                                </div>
                                                <div style="color:#64748B; font-size:14px;">Type: ${c.consultationType} | Status: ${c.status}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'prescriptions'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-file-medical" style="color:var(--primary)"></i> Prescriptions</h3>
                        </div>
                        <div class="card-body">
                            <div style="margin-bottom:24px; padding:16px; background:#f8fafc; border-radius:12px;">
                                <h4>Add New Prescription</h4>
                                <form action="${pageContext.request.contextPath}/doctors/appointments/addPrescription" method="post" style="display:flex; gap:12px; align-items:flex-start;">
                                    <select name="id" required style="padding:10px; border:1px solid #cbd5e1; border-radius:8px; width:200px;">
                                        <option value="">Select Appointment...</option>
                                        <c:forEach var="a" items="${appointmentsForPrescription}">
                                            <option value="${a.id}">${a.user.fullName} - ${a.appointmentTime.toLocalDate()}</option>
                                        </c:forEach>
                                    </select>
                                    <textarea name="prescriptionText" required placeholder="Type prescription details..." style="flex:1; padding:10px; border:1px solid #cbd5e1; border-radius:8px; min-height:80px;"></textarea>
                                    <button type="submit" class="btn-primary" style="padding:10px 20px; border:none; border-radius:8px; cursor:pointer;">Save</button>
                                </form>
                            </div>
                            
                            <h4>Existing Prescriptions</h4>
                            <c:choose>
                                <c:when test="${empty prescriptions}">
                                    <p>No prescriptions issued yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${prescriptions}">
                                        <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                            <div style="font-weight:700; color:#1E1B4B; margin-bottom:8px;">Patient: ${p.user.fullName} <span style="font-size:12px; color:#64748B; font-weight:normal; margin-left:8px;">(Appt: ${p.appointmentTime.toLocalDate()})</span></div>
                                            <div style="padding:12px; background:#f8fafc; border-radius:8px; font-size:14px; white-space:pre-wrap;">${p.prescriptionText}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'earnings'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-wallet2" style="color:var(--primary)"></i> Earnings</h3>
                        </div>
                        <div class="card-body">
                            <div style="padding:24px; background:linear-gradient(135deg, #4f46e5, #3b82f6); color:white; border-radius:16px; margin-bottom:24px;">
                                <div style="font-size:14px; opacity:0.9;">Total Earnings</div>
                                <div style="font-size:36px; font-weight:800; margin-top:8px;">&#8377;${totalEarnings}</div>
                            </div>
                            
                            <h4>Completed Transactions</h4>
                            <c:choose>
                                <c:when test="${empty paidAppointments}">
                                    <p>No transactions yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <table style="width:100%; border-collapse:collapse; margin-top:16px;">
                                        <thead>
                                            <tr style="text-align:left; border-bottom:2px solid #e2e8f0;">
                                                <th style="padding:12px;">Date</th>
                                                <th style="padding:12px;">Patient</th>
                                                <th style="padding:12px;">Amount</th>
                                                <th style="padding:12px;">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="a" items="${paidAppointments}">
                                                <tr style="border-bottom:1px solid #f1f5f9;">
                                                    <td style="padding:12px;">${a.appointmentTime.toLocalDate()}</td>
                                                    <td style="padding:12px; font-weight:600;">${a.user.fullName}</td>
                                                    <td style="padding:12px; font-weight:700; color:#10b981;">&#8377;${doctor.consultationFee}</td>
                                                    <td style="padding:12px;"><span style="padding:4px 8px; background:#dcfce7; color:#166534; border-radius:999px; font-size:12px; font-weight:600;">COMPLETED</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'chat'}">
                    <div class="card" style="height:600px; display:flex; flex-direction:column;">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-chat-text" style="color:var(--primary)"></i> Chat Box</h3>
                        </div>
                        <div class="card-body" style="flex:1; display:flex; padding:0; overflow:hidden;">
                            <div style="width:300px; border-right:1px solid #e2e8f0; overflow-y:auto; padding:16px;">
                                <h4 style="margin-top:0;">Conversations</h4>
                                <c:choose>
                                    <c:when test="${empty chatPatients}">
                                        <p style="color:#64748B; font-size:14px;">No patients to chat with yet.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="p" items="${chatPatients}">
                                            <a href="#" style="display:block; padding:12px; text-decoration:none; color:inherit; border-radius:8px; margin-bottom:8px; background:#f8fafc; border:1px solid transparent;">
                                                <div style="font-weight:600; color:#1E1B4B;">${p.fullName}</div>
                                                <div style="font-size:12px; color:#64748B;">Tap to view messages</div>
                                            </a>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex:1; display:flex; align-items:center; justify-content:center; flex-direction:column; background:#f8fafc;">
                                <i class="bi bi-chat-dots" style="font-size:3rem; color:#cbd5e1; margin-bottom:16px;"></i>
                                <div style="color:#94a3b8; font-weight:500;">Select a conversation to start chatting</div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'reviews'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-star" style="color:var(--primary)"></i> Patient Reviews</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty reviews}">
                                    <p>No reviews yet.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="appt-list">
                                        <c:forEach var="r" items="${reviews}">
                                            <div class="appt-item" style="padding:16px; border:1px solid #f1f5f9; border-radius:12px; margin-bottom:12px;">
                                                <div style="display:flex; justify-content:space-between; margin-bottom:8px;">
                                                    <strong style="color:#1E1B4B;">${r.user.fullName}</strong>
                                                    <span style="color:#eab308; font-weight:700;"><i class="bi bi-star-fill"></i> ${r.rating} / 5</span>
                                                </div>
                                                <div style="color:#475569; font-size:14px; line-height:1.6;">${r.comment}</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:when test="${section == 'settings'}">
                    <div class="card">
                        <div class="card-header">
                            <h3 style="margin:0;"><i class="bi bi-gear" style="color:var(--primary)"></i> Settings</h3>
                        </div>
                        <div class="card-body" style="text-align:center; padding:40px;">
                            <i class="bi bi-person-gear" style="font-size:4rem; color:#cbd5e1; margin-bottom:20px;"></i>
                            <h3>Profile Settings</h3>
                            <p style="color:#64748B; max-width:400px; margin:0 auto 24px auto;">To edit your public profile, upload new certificates, or modify your personal details, use the full Profile Completion page.</p>
                            <a href="${pageContext.request.contextPath}/doctors/profile-completion" class="btn-primary" style="text-decoration:none; padding:12px 24px; border-radius:8px; font-weight:600;">Edit Profile</a>
                        </div>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <div class="card">
                        <div class="card-header">
                            <h3 style="text-transform: capitalize; margin:0;"><i class="bi bi-app-indicator" style="color:var(--primary)"></i>  Module</h3>
                        </div>
                        <div class="card-body">
                            <p>This module is currently being built.</p>
                        </div>
                    </div>
                </c:otherwise>

            </c:choose>
        </div>

            </c:otherwise>
        </c:choose>
    </main>


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

              <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px;">
                <label style="font-size:12px;font-weight:600;color:var(--dd-muted);">Prescription / Rx</label>
                <span id="charCount" style="font-size:10px;font-weight:500;color:var(--dd-muted);">0 / 500</span>
              </div>
              <textarea name="prescriptionText" id="prescText" rows="6" maxlength="500" required placeholder="Write medicines, dosage, and instructions here..." style="width:100%;padding:10px 14px;border:2px solid var(--dd-border);border-radius:10px;font-size:13px;outline:none;font-family:'Poppins',sans-serif;resize:vertical;" oninput="document.getElementById('charCount').textContent = this.value.length + ' / 500'"></textarea>

            </div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
              <button type="button" onclick="closePrescriptionModal()" style="padding:10px 20px;border:none;border-radius:999px;background:rgba(107,114,128,0.1);color:var(--dd-muted);font-size:13px;font-weight:600;cursor:pointer;">Cancel</button>
              <button type="submit" id="prescSaveBtn" style="padding:10px 20px;border:none;border-radius:999px;background:linear-gradient(135deg,#fb7185,#F43F5E);color:#fff;font-size:13px;font-weight:700;cursor:pointer;box-shadow:0 4px 12px rgba(244,63,94,0.25);">Save Prescription</button>
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

function toggleNotifications() {
  const dropdown = document.getElementById('notifDropdown');
  if(dropdown.style.display === 'none') {
    dropdown.style.display = 'block';
  } else {
    dropdown.style.display = 'none';
  }
}

function clearNotifs() {
  const dot = document.getElementById('bell-dot');
  if(dot) dot.style.display = 'none';
  const badge = document.getElementById('notif-badge');
  if(badge) badge.style.display = 'none';
  const sidebarBadge = document.getElementById('sidebar-appt-badge');
  if(sidebarBadge) sidebarBadge.style.display = 'none';
}

document.addEventListener('click', function(event) {
  const dropdown = document.getElementById('notifDropdown');
  const bell = document.getElementById('bellIcon');
  if(dropdown && bell && !bell.contains(event.target) && !dropdown.contains(event.target)) {
    dropdown.style.display = 'none';
  }
});

document.addEventListener('DOMContentLoaded', function() {
  if ('${section}' === 'appointments') {
      clearNotifs();
  }

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

</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
>>>>>>> 16cf85ce996ab1a16542e394dc5bd4bcae6a13f5
</body>
</html>










