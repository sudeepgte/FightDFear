<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard - Fight D Fear</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
<style>
:root {
  --ad-bg: #F8FAFC;
  --ad-card: #FFFFFF;
  --ad-text: #0F172A;
  --ad-muted: #64748B;
  --ad-border: #E2E8F0;
  --ad-accent: #F43F5E;
  --ad-accent-soft: #FFF1F2;
  --ad-success: #16A34A;
  --ad-success-bg: #DCFCE7;
  --ad-warn: #D97706;
  --ad-warn-bg: #FEF3C7;
  --ad-info: #2563EB;
  --ad-info-bg: #DBEAFE;
  --ad-shadow: 0 1px 3px rgba(15,23,42,.04), 0 8px 24px rgba(15,23,42,.04);
  --sidebar-w: 272px;
}
* { box-sizing: border-box; }
body { font-family: 'Inter', 'Outfit', sans-serif; margin: 0; background: var(--ad-bg); color: var(--ad-text); }
.layout { display: flex; min-height: 100vh; }
.main { flex: 1; min-width: 0; }
.ad-shell { padding: 22px 28px 40px; max-width: 1440px; }
.ad-topbar {
  display: flex; align-items: flex-start; justify-content: space-between; gap: 16px;
  margin-bottom: 22px; flex-wrap: wrap;
}
.ad-greet h1 { font-family: 'Outfit', sans-serif; font-size: 1.55rem; font-weight: 800; margin: 0 0 4px; letter-spacing: -0.02em; }
.ad-greet p { margin: 0; color: var(--ad-muted); font-size: 0.92rem; }
.ad-top-actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
.ad-search {
  display: flex; align-items: center; gap: 8px; background: #fff; border: 1px solid var(--ad-border);
  border-radius: 12px; padding: 10px 14px; min-width: 260px; color: var(--ad-muted); font-size: 0.88rem;
}
.ad-search input { border: 0; outline: 0; flex: 1; min-width: 0; background: transparent; font-size: 0.88rem; color: var(--ad-text); }
.ad-kbd { font-size: 0.7rem; background: #F1F5F9; border: 1px solid var(--ad-border); border-radius: 6px; padding: 2px 6px; color: #94A3B8; white-space: nowrap; }
.ad-icon-btn {
  width: 42px; height: 42px; border-radius: 12px; border: 1px solid var(--ad-border); background: #fff;
  display: inline-flex; align-items: center; justify-content: center; color: var(--ad-muted); position: relative; text-decoration: none;
}
.ad-icon-btn .dot {
  position: absolute; top: 8px; right: 8px; min-width: 16px; height: 16px; border-radius: 999px;
  background: var(--ad-accent); color: #fff; font-size: 0.62rem; font-weight: 700; display: none;
  align-items: center; justify-content: center; padding: 0 4px;
}
.ad-icon-btn .dot.on { display: inline-flex; }
.ad-profile {
  display: flex; align-items: center; gap: 10px; background: #fff; border: 1px solid var(--ad-border);
  border-radius: 14px; padding: 6px 12px 6px 6px; text-decoration: none; color: inherit;
}
.ad-avatar {
  width: 36px; height: 36px; border-radius: 50%; background: var(--ad-accent-soft); color: var(--ad-accent);
  display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.85rem; overflow: hidden;
}
.ad-avatar img { width: 100%; height: 100%; object-fit: cover; }
.ad-profile .name { font-size: 0.85rem; font-weight: 700; line-height: 1.2; }
.ad-profile .role { font-size: 0.72rem; color: var(--ad-accent); font-weight: 600; }

.kpi-row {
  display: grid; grid-template-columns: repeat(6, minmax(0, 1fr)); gap: 14px; margin-bottom: 18px;
}
.kpi-card {
  background: var(--ad-card); border: 1px solid var(--ad-border); border-radius: 16px;
  padding: 16px; box-shadow: var(--ad-shadow); min-height: 118px;
}
.kpi-icon {
  width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center;
  font-size: 0.95rem; margin-bottom: 12px;
}
.kpi-icon.rose { background: var(--ad-accent-soft); color: var(--ad-accent); }
.kpi-icon.violet { background: #F3E8FF; color: #7C3AED; }
.kpi-icon.amber { background: var(--ad-warn-bg); color: var(--ad-warn); }
.kpi-icon.green { background: var(--ad-success-bg); color: var(--ad-success); }
.kpi-icon.blue { background: var(--ad-info-bg); color: var(--ad-info); }
.kpi-icon.indigo { background: #EEF2FF; color: #4F46E5; }
.kpi-val { font-family: 'Outfit', sans-serif; font-size: 1.45rem; font-weight: 800; letter-spacing: -0.02em; line-height: 1.1; }
.kpi-title { font-size: 0.82rem; font-weight: 700; margin-top: 4px; color: var(--ad-text); }
.kpi-sub { font-size: 0.75rem; color: var(--ad-muted); margin-top: 2px; }

.grid-2 { display: grid; grid-template-columns: 1.35fr 1fr; gap: 16px; margin-bottom: 16px; }
.grid-bottom { display: grid; grid-template-columns: 1.55fr 0.9fr; gap: 16px; margin-bottom: 22px; }
.panel {
  background: var(--ad-card); border: 1px solid var(--ad-border); border-radius: 16px;
  box-shadow: var(--ad-shadow); overflow: hidden;
}
.panel-hd {
  display: flex; align-items: center; justify-content: space-between; gap: 10px;
  padding: 16px 18px; border-bottom: 1px solid var(--ad-border);
}
.panel-hd h2 { margin: 0; font-size: 1rem; font-weight: 800; font-family: 'Outfit', sans-serif; }
.panel-hd a, .panel-link {
  color: var(--ad-accent); font-size: 0.82rem; font-weight: 700; text-decoration: none; white-space: nowrap;
}
.panel-bd { padding: 16px 18px; }

.verify-grid {
  display: grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap: 10px;
}
.v-card {
  border: 1px solid var(--ad-border); border-radius: 12px; padding: 12px; background: #FCFCFD;
  text-decoration: none; color: inherit; display: block; transition: border-color .15s, background .15s;
}
.v-card:hover { border-color: #FECDD3; background: var(--ad-accent-soft); }
.v-card .top { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.v-card .ico {
  width: 28px; height: 28px; border-radius: 8px; background: #fff; border: 1px solid var(--ad-border);
  display: flex; align-items: center; justify-content: center; color: var(--ad-accent); font-size: 0.78rem;
}
.v-card .lbl { font-size: 0.78rem; font-weight: 600; color: var(--ad-muted); }
.v-card .num { font-size: 1.25rem; font-weight: 800; font-family: 'Outfit', sans-serif; }
.v-card .st { font-size: 0.72rem; color: var(--ad-warn); font-weight: 600; }
.verify-foot {
  margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--ad-border);
  display: flex; justify-content: space-between; align-items: center; gap: 8px; flex-wrap: wrap;
}
.verify-foot strong { font-size: 0.9rem; }

.activity-list { display: flex; flex-direction: column; gap: 0; max-height: 320px; overflow: auto; }
.activity-row {
  display: grid; grid-template-columns: 36px 1fr auto; gap: 10px; align-items: start;
  padding: 12px 0; border-bottom: 1px solid #F1F5F9;
}
.activity-row:last-child { border-bottom: 0; }
.activity-ico {
  width: 36px; height: 36px; border-radius: 10px; background: #F8FAFC; border: 1px solid var(--ad-border);
  display: flex; align-items: center; justify-content: center; color: var(--ad-muted); font-size: 0.85rem;
}
.activity-title { font-size: 0.86rem; font-weight: 600; color: var(--ad-text); line-height: 1.35; }
.activity-title strong { font-weight: 700; }
.activity-meta { font-size: 0.75rem; color: var(--ad-muted); margin-top: 2px; }
.badge-pill {
  display: inline-flex; align-items: center; border-radius: 999px; padding: 3px 9px;
  font-size: 0.68rem; font-weight: 700; text-transform: uppercase; letter-spacing: .02em; white-space: nowrap;
}
.badge-pending { background: var(--ad-warn-bg); color: #92400E; }
.badge-ok { background: var(--ad-success-bg); color: #166534; }
.badge-info { background: var(--ad-info-bg); color: #1D4ED8; }
.badge-rose { background: var(--ad-accent-soft); color: #BE123C; }

.queue-tabs { display: flex; gap: 4px; flex-wrap: wrap; padding: 0 18px; border-bottom: 1px solid var(--ad-border); }
.queue-tab {
  border: 0; background: transparent; padding: 12px 12px; font-size: 0.82rem; font-weight: 600;
  color: var(--ad-muted); border-bottom: 2px solid transparent; cursor: pointer;
}
.queue-tab.active { color: var(--ad-accent); border-bottom-color: var(--ad-accent); }
.queue-tab .count {
  display: inline-flex; min-width: 18px; height: 18px; padding: 0 5px; border-radius: 999px;
  background: #F1F5F9; color: var(--ad-muted); font-size: 0.68rem; align-items: center; justify-content: center; margin-left: 4px;
}
.queue-tab.active .count { background: var(--ad-accent-soft); color: var(--ad-accent); }
.table-wrap { overflow-x: auto; }
.ad-table { width: 100%; border-collapse: collapse; min-width: 720px; }
.ad-table th {
  text-align: left; font-size: 0.7rem; text-transform: uppercase; letter-spacing: .04em;
  color: #94A3B8; font-weight: 700; padding: 12px 14px; background: #F8FAFC; border-bottom: 1px solid var(--ad-border);
}
.ad-table td { padding: 12px 14px; border-bottom: 1px solid #F1F5F9; font-size: 0.86rem; vertical-align: middle; }
.ad-table .clip { max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: block; }
.applicant { display: flex; align-items: center; gap: 10px; min-width: 0; }
.applicant .av {
  width: 34px; height: 34px; border-radius: 50%; background: var(--ad-accent-soft); color: var(--ad-accent);
  display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 800; flex-shrink: 0;
}
.applicant .nm { font-weight: 700; font-size: 0.86rem; }
.applicant .em { font-size: 0.75rem; color: var(--ad-muted); }
.act-btns { display: flex; gap: 6px; }
.act-btns a, .act-btns button {
  width: 32px; height: 32px; border-radius: 8px; border: 1px solid var(--ad-border); background: #fff;
  display: inline-flex; align-items: center; justify-content: center; color: var(--ad-muted); text-decoration: none; cursor: pointer;
}
.act-btns a:hover { color: var(--ad-accent); border-color: #FECDD3; background: var(--ad-accent-soft); }
.queue-empty { padding: 28px 18px; text-align: center; color: var(--ad-muted); font-size: 0.9rem; }
.queue-empty a { color: var(--ad-accent); font-weight: 700; text-decoration: none; }

.esc-list { display: flex; flex-direction: column; gap: 10px; }
.esc-row {
  display: flex; align-items: center; justify-content: space-between; gap: 10px;
  padding: 12px 14px; border: 1px solid var(--ad-border); border-radius: 12px; background: #FCFCFD;
  text-decoration: none; color: inherit;
}
.esc-row:hover { border-color: #FECDD3; }
.esc-row .t { font-size: 0.86rem; font-weight: 700; }
.esc-row .s { font-size: 0.75rem; color: var(--ad-muted); }

.qa-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.qa-card {
  border: 1px solid var(--ad-border); border-radius: 12px; padding: 14px 12px; text-decoration: none; color: inherit;
  background: #fff; transition: border-color .15s, background .15s; min-height: 92px;
}
.qa-card:hover { border-color: #FECDD3; background: var(--ad-accent-soft); }
.qa-card .qi {
  width: 32px; height: 32px; border-radius: 9px; display: flex; align-items: center; justify-content: center;
  margin-bottom: 8px; font-size: 0.85rem;
}
.qa-card .qt { font-size: 0.84rem; font-weight: 700; }
.qa-card .qs { font-size: 0.72rem; color: var(--ad-muted); margin-top: 2px; }

.dashboard-panel {
  background: var(--ad-card); border: 1px solid var(--ad-border); border-radius: 16px;
  box-shadow: var(--ad-shadow); padding: 18px; margin-bottom: 16px;
}
.dashboard-panel-title { font-size: 1rem; font-weight: 800; margin: 0 0 12px; font-family: 'Outfit', sans-serif; }
.mobile-toggle {
  background: none; border: none; color: var(--ad-text); font-size: 1.25rem; cursor: pointer;
  padding: 6px 8px; display: none;
}
.sidebar-overlay { display: none; }
.ad-footer {
  display: flex; justify-content: space-between; gap: 12px; flex-wrap: wrap;
  color: var(--ad-muted); font-size: 0.78rem; padding: 8px 0 0;
}

@media (max-width: 1200px) {
  .kpi-row { grid-template-columns: repeat(3, minmax(0,1fr)); }
  .grid-2, .grid-bottom { grid-template-columns: 1fr; }
}
@media (max-width: 992px) {
  .mobile-toggle { display: inline-block; }
  .ad-shell { padding: 16px; }
  .verify-grid { grid-template-columns: repeat(2, minmax(0,1fr)); }
}
@media (max-width: 640px) {
  .kpi-row { grid-template-columns: repeat(2, minmax(0,1fr)); }
  .verify-grid, .qa-grid { grid-template-columns: 1fr; }
  .ad-search { min-width: 0; width: 100%; }
}
</style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>
<div class="layout">
  <%@ include file="globalAdminMenu.jsp" %>
  <main class="main">
    <div class="ad-shell">

      <div class="ad-topbar">
        <div class="d-flex align-items-start gap-2">
          <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
          <div class="ad-greet">
            <h1 id="adGreeting">Hello, <c:out value="${not empty admin.name ? admin.name : 'Admin'}"/>!</h1>
            <p>Here's what's happening on the platform today.</p>
          </div>
        </div>
        <div class="ad-top-actions">
          <label class="ad-search" title="Filter this page">
            <i class="fas fa-search"></i>
            <input type="search" id="adPageSearch" placeholder="Search anything..." autocomplete="off"/>
            <span class="ad-kbd">Ctrl + K</span>
          </label>
          <a class="ad-icon-btn" href="${pageContext.request.contextPath}/admin/contact-messages" title="Contact messages">
            <i class="fas fa-bell"></i>
            <span class="dot ${unreadContactMessages > 0 ? 'on' : ''}" id="notifDot"><c:out value="${unreadContactMessages}"/></span>
          </a>
          <a class="ad-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
            <div class="ad-avatar">
              <c:choose>
                <c:when test="${not empty admin.profilePhoto}">
                  <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt=""/>
                </c:when>
                <c:otherwise>
                  <c:out value="${fn:substring(admin.name,0,1)}"/>
                </c:otherwise>
              </c:choose>
            </div>
            <div>
              <div class="name"><c:out value="${not empty admin.name ? admin.name : 'Admin User'}"/></div>
              <div class="role">Super Admin</div>
            </div>
          </a>
        </div>
      </div>

      <div class="kpi-row" id="analyticsOverview">
        <div class="kpi-card">
          <div class="kpi-icon rose"><i class="fas fa-users"></i></div>
          <div class="kpi-val" id="stat-totalUsers">-</div>
          <div class="kpi-title">Total Users</div>
          <div class="kpi-sub">Across all modules</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon violet"><i class="fas fa-user-md"></i></div>
          <div class="kpi-val" id="stat-verifiedDoctors">-</div>
          <div class="kpi-title">Verified Doctors</div>
          <div class="kpi-sub">Approved &amp; active</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon amber"><i class="fas fa-shield-alt"></i></div>
          <div class="kpi-val" id="stat-pendingVerifications">-</div>
          <div class="kpi-title">Pending Verifications</div>
          <div class="kpi-sub">Needs review</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon green"><i class="fas fa-rupee-sign"></i></div>
          <div class="kpi-val" id="stat-platformRevenue">-</div>
          <div class="kpi-title">Platform Revenue</div>
          <div class="kpi-sub">Investment platform fees</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon blue"><i class="fas fa-flag"></i></div>
          <div class="kpi-val" id="stat-reportedItems"><c:out value="${fn:length(reports)}"/></div>
          <div class="kpi-title">Reported Items</div>
          <div class="kpi-sub">Video reports in queue</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-icon indigo"><i class="fas fa-calendar-alt"></i></div>
          <div class="kpi-val" id="stat-totalWomenEvents">-</div>
          <div class="kpi-title">Events</div>
          <div class="kpi-sub">Women Events platform</div>
        </div>
      </div>

      <div class="grid-2">
        <section class="panel">
          <div class="panel-hd">
            <h2>Verification Overview</h2>
            <a href="${pageContext.request.contextPath}/admin/pending-doctors">View All Queues -></a>
          </div>
          <div class="panel-bd">
            <div class="verify-grid">
              <a class="v-card" href="${pageContext.request.contextPath}/admin/pending-doctors">
                <div class="top"><span class="ico"><i class="fas fa-user-md"></i></span><span class="lbl">Doctor</span></div>
                <div class="num" id="ov-doctors"><c:out value="${side_pendingDoctors != null ? side_pendingDoctors : 0}"/></div>
                <div class="st">Pending</div>
              </a>
              <a class="v-card" href="${pageContext.request.contextPath}/admin/salons">
                <div class="top"><span class="ico"><i class="fas fa-cut"></i></span><span class="lbl">Salon</span></div>
                <div class="num" id="ov-salons"><c:out value="${side_pendingSalons != null ? side_pendingSalons : 0}"/></div>
                <div class="st">Pending</div>
              </a>
              <a class="v-card" href="${pageContext.request.contextPath}/admin/martialManagement">
                <div class="top"><span class="ico"><i class="fas fa-dumbbell"></i></span><span class="lbl">Martial Arts</span></div>
                <div class="num" id="ov-centres"><c:out value="${side_pendingCentres != null ? side_pendingCentres : 0}"/></div>
                <div class="st">Pending</div>
              </a>
              <a class="v-card" href="${pageContext.request.contextPath}/admin/stylists">
                <div class="top"><span class="ico"><i class="fas fa-user-tie"></i></span><span class="lbl">Stylist</span></div>
                <div class="num" id="ov-stylists"><c:out value="${side_pendingStylists != null ? side_pendingStylists : 0}"/></div>
                <div class="st">Pending</div>
              </a>
              <a class="v-card" href="${pageContext.request.contextPath}/admin/job-applications">
                <div class="top"><span class="ico"><i class="fas fa-briefcase"></i></span><span class="lbl">Women Jobs</span></div>
                <div class="num" id="ov-jobs"><c:out value="${side_pendingJobApplications != null ? side_pendingJobApplications : 0}"/></div>
                <div class="st">Pending</div>
              </a>
              <a class="v-card" href="${pageContext.request.contextPath}/admin/pending-providers">
                <div class="top"><span class="ico"><i class="fas fa-store"></i></span><span class="lbl">Service Partners</span></div>
                <div class="num" id="ov-partners"><c:out value="${side_pendingFitness != null ? side_pendingFitness : 0}"/></div>
                <div class="st">Pending</div>
              </a>
            </div>
            <div class="verify-foot">
              <div>Total Pending Verifications: <strong id="ov-total">-</strong></div>
              <a class="panel-link" href="${pageContext.request.contextPath}/admin/pending-doctors">View All Queues -></a>
            </div>
          </div>
        </section>

        <section class="panel">
          <div class="panel-hd">
            <h2>Recent Activity Feed</h2>
            <a href="${pageContext.request.contextPath}/admin/pending-proposals">View All</a>
          </div>
          <div class="panel-bd">
            <div class="activity-list">
              <c:choose>
                <c:when test="${not empty recentPlatformActivities}">
                  <c:forEach var="act" items="${recentPlatformActivities}">
                    <div class="activity-row">
                      <div class="activity-ico"><i class="bi ${act.icon} fas fa-bolt"></i></div>
                      <div>
                        <div class="activity-title">${act.desc}</div>
                        <div class="activity-meta"><c:out value="${act.time}"/></div>
                      </div>
                      <span class="badge-pill badge-info"><c:out value="${act.type}"/></span>
                    </div>
                  </c:forEach>
                </c:when>
                <c:when test="${not empty recentContactMessages}">
                  <c:forEach var="cm" items="${recentContactMessages}">
                    <div class="activity-row">
                      <div class="activity-ico"><i class="fas fa-envelope"></i></div>
                      <div>
                        <div class="activity-title"><strong><c:out value="${cm.name}"/></strong> - <c:out value="${cm.subject}"/></div>
                        <div class="activity-meta"><c:out value="${cm.email}"/></div>
                      </div>
                      <span class="badge-pill ${cm.readByAdmin ? 'badge-ok' : 'badge-rose'}"><c:out value="${cm.readByAdmin ? 'READ' : 'NEW'}"/></span>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <p class="text-muted mb-0 small">No recent platform activity yet.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </section>
      </div>

      <div class="grid-bottom">
        <section class="panel">
          <div class="panel-hd">
            <h2>Verification Queues</h2>
          </div>
          <div class="queue-tabs" role="tablist">
            <button type="button" class="queue-tab active" data-queue="doctors">Doctor Verification <span class="count" id="qt-doctors">${side_pendingDoctors != null ? side_pendingDoctors : 0}</span></button>
            <button type="button" class="queue-tab" data-queue="trainers">Fitness Trainers <span class="count" id="qt-trainers">${fn:length(pendingTrainers)}</span></button>
            <button type="button" class="queue-tab" data-queue="creators">Creators <span class="count" id="qt-creators">${fn:length(creatorsVerificationList)}</span></button>
            <button type="button" class="queue-tab" data-queue="reports">Reported <span class="count" id="qt-reports">${fn:length(reports)}</span></button>
            <button type="button" class="queue-tab" data-queue="more">More</button>
          </div>

          <div class="queue-pane" id="queue-doctors">
            <div class="queue-empty">
              Open the full doctor verification queue to review applicants, documents, and approve or request changes.
              <div class="mt-3"><a href="${pageContext.request.contextPath}/admin/pending-doctors">Open Doctor Verification -></a></div>
              <div class="text-muted small mt-2">Pending: <span id="queue-doc-count">${side_pendingDoctors != null ? side_pendingDoctors : 0}</span></div>
            </div>
          </div>

          <div class="queue-pane d-none" id="queue-trainers">
            <c:choose>
              <c:when test="${empty pendingTrainers}">
                <div class="queue-empty">No trainer applications pending. <a href="${pageContext.request.contextPath}/admin/pending-trainers">Open trainers page -></a></div>
              </c:when>
              <c:otherwise>
                <div class="table-wrap">
                  <table class="ad-table">
                    <thead><tr><th>Applicant</th><th>Specialization / Category</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                      <c:forEach var="t" items="${pendingTrainers}" varStatus="st">
                        <c:if test="${st.index < 8}">
                          <tr>
                            <td>
                              <div class="applicant">
                                <div class="av"><c:out value="${fn:substring(t.fullName,0,1)}"/></div>
                                <div style="min-width:0;">
                                  <div class="nm clip" title="<c:out value='${t.fullName}'/>"><c:out value="${t.fullName}"/></div>
                                  <div class="em clip" title="<c:out value='${t.email}'/>"><c:out value="${t.email}"/></div>
                                </div>
                              </div>
                            </td>
                            <td><span class="clip" title="<c:out value='${t.specializations}'/>"><c:out value="${empty t.specializations ? 'Not provided' : t.specializations}"/></span></td>
                            <td><span class="badge-pill badge-pending"><c:out value="${t.verificationStatus}"/></span></td>
                            <td class="act-btns">
                              <a href="${pageContext.request.contextPath}/admin/pending-trainers" title="Review"><i class="fas fa-eye"></i></a>
                              <a href="${pageContext.request.contextPath}/admin/pending-trainers" title="Open queue"><i class="fas fa-edit"></i></a>
                            </td>
                          </tr>
                        </c:if>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
                <div class="panel-bd pt-0"><a class="panel-link" href="${pageContext.request.contextPath}/admin/pending-trainers">Open full trainers queue -></a></div>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="queue-pane d-none" id="queue-creators">
            <c:choose>
              <c:when test="${empty creatorsVerificationList}">
                <div class="queue-empty">No creator applications pending. <a href="${pageContext.request.contextPath}/admin/pending-creators">Open creators page -></a></div>
              </c:when>
              <c:otherwise>
                <div class="table-wrap">
                  <table class="ad-table">
                    <thead><tr><th>Applicant</th><th>Category</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                      <c:forEach var="c" items="${creatorsVerificationList}" varStatus="st">
                        <c:if test="${st.index < 8}">
                          <tr>
                            <td>
                              <div class="applicant">
                                <div class="av"><c:out value="${fn:substring(c.fullName,0,1)}"/></div>
                                <div style="min-width:0;">
                                  <div class="nm clip"><c:out value="${c.fullName}"/></div>
                                  <div class="em clip"><c:out value="${c.email}"/></div>
                                </div>
                              </div>
                            </td>
                            <td><span class="clip"><c:out value="${empty c.creatorCategory ? '-' : c.creatorCategory}"/></span></td>
                            <td><span class="badge-pill badge-pending"><c:out value="${empty c.creatorProfileStatus ? 'INCOMPLETE' : c.creatorProfileStatus}"/></span></td>
                            <td class="act-btns">
                              <a href="${pageContext.request.contextPath}/admin/pending-creators" title="Review"><i class="fas fa-eye"></i></a>
                              <form action="${pageContext.request.contextPath}/admin/creators/${c.id}/approve" method="post" class="d-inline m-0">
                                <button type="submit" title="Approve"><i class="fas fa-check"></i></button>
                              </form>
                            </td>
                          </tr>
                        </c:if>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="queue-pane d-none" id="queue-reports">
            <c:choose>
              <c:when test="${empty reports}">
                <div class="queue-empty">No reported videos. <a href="${pageContext.request.contextPath}/admin/reported-videos">Open reports -></a></div>
              </c:when>
              <c:otherwise>
                <div class="table-wrap">
                  <table class="ad-table">
                    <thead><tr><th>Content</th><th>Reporter</th><th>Reason</th><th>Actions</th></tr></thead>
                    <tbody>
                      <c:forEach var="r" items="${reports}" varStatus="st">
                        <c:if test="${st.index < 8}">
                          <tr>
                            <td><span class="clip" title="<c:out value='${r.video.title}'/>"><c:out value="${r.video.title}"/></span></td>
                            <td><span class="clip"><c:out value="${r.reportedBy.fullName}"/></span></td>
                            <td><span class="clip"><c:out value="${r.reason}"/></span></td>
                            <td class="act-btns">
                              <a href="${pageContext.request.contextPath}/admin/reported-videos" title="Review"><i class="fas fa-eye"></i></a>
                            </td>
                          </tr>
                        </c:if>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="queue-pane d-none" id="queue-more">
            <div class="panel-bd">
              <div class="qa-grid">
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/salons"><div class="qi" style="background:#FFF1F2;color:#F43F5E;"><i class="fas fa-cut"></i></div><div class="qt">Salon Verification</div><div class="qs">Pending: ${side_pendingSalons != null ? side_pendingSalons : 0}</div></a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/stylists"><div class="qi" style="background:#EEF2FF;color:#4F46E5;"><i class="fas fa-user-tie"></i></div><div class="qt">Stylist Verification</div><div class="qs">Pending: ${side_pendingStylists != null ? side_pendingStylists : 0}</div></a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/martialManagement"><div class="qi" style="background:#FEF3C7;color:#D97706;"><i class="fas fa-dumbbell"></i></div><div class="qt">Martial Arts Centres</div><div class="qs">Pending: ${side_pendingCentres != null ? side_pendingCentres : 0}</div></a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/pending-event-hosts"><div class="qi" style="background:#DCFCE7;color:#16A34A;"><i class="fas fa-calendar-check"></i></div><div class="qt">Event Organizers</div><div class="qs">Pending: ${side_pendingEventHosts != null ? side_pendingEventHosts : 0}</div></a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/pending-sellers"><div class="qi" style="background:#DBEAFE;color:#2563EB;"><i class="fas fa-shopping-cart"></i></div><div class="qt">Product Sellers</div><div class="qs">Pending: ${side_pendingSellers != null ? side_pendingSellers : 0}</div></a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/users"><div class="qi" style="background:#F1F5F9;color:#475569;"><i class="fas fa-users-cog"></i></div><div class="qt">User Management</div><div class="qs">Pending: ${side_pendingUsers != null ? side_pendingUsers : 0}</div></a>
              </div>
            </div>
          </div>
        </section>

        <div>
          <section class="panel mb-3">
            <div class="panel-hd"><h2>Pending Escalations</h2></div>
            <div class="panel-bd">
              <div class="esc-list">
                <a class="esc-row" href="${pageContext.request.contextPath}/admin/sos">
                  <div><div class="t">Active SOS</div><div class="s">Live emergency monitoring</div></div>
                  <span class="badge-pill badge-rose" id="esc-sos">-</span>
                </a>
                <a class="esc-row" href="${pageContext.request.contextPath}/admin/pending-doctors">
                  <div><div class="t">Doctor Verifications</div><div class="s">Medical profiles awaiting review</div></div>
                  <span class="badge-pill badge-pending" id="esc-doctors">${side_pendingDoctors != null ? side_pendingDoctors : 0}</span>
                </a>
                <a class="esc-row" href="${pageContext.request.contextPath}/admin/users">
                  <div><div class="t">Incomplete / Pending Users</div><div class="s">Accounts awaiting verification</div></div>
                  <span class="badge-pill badge-info" id="esc-users">${side_pendingUsers != null ? side_pendingUsers : 0}</span>
                </a>
                <a class="esc-row" href="${pageContext.request.contextPath}/admin/reported-videos">
                  <div><div class="t">Reported Videos</div><div class="s">Content safety queue</div></div>
                  <span class="badge-pill badge-rose" id="esc-reports">${fn:length(reports)}</span>
                </a>
              </div>
            </div>
          </section>

          <section class="panel">
            <div class="panel-hd"><h2>Quick Actions</h2></div>
            <div class="panel-bd">
              <div class="qa-grid">
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/pending-doctors">
                  <div class="qi" style="background:#FFF1F2;color:#F43F5E;"><i class="fas fa-user-check"></i></div>
                  <div class="qt">Approve Doctors</div><div class="qs">Review medical profiles</div>
                </a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/users">
                  <div class="qi" style="background:#DBEAFE;color:#2563EB;"><i class="fas fa-users"></i></div>
                  <div class="qt">Manage Users</div><div class="qs">Accounts &amp; bans</div>
                </a>
                <a class="qa-card" href="${pageContext.request.contextPath}/video/videoManagement">
                  <div class="qi" style="background:#F3E8FF;color:#7C3AED;"><i class="fas fa-film"></i></div>
                  <div class="qt">Content Management</div><div class="qs">Video library</div>
                </a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/broadcast">
                  <div class="qi" style="background:#FEF3C7;color:#D97706;"><i class="fas fa-bullhorn"></i></div>
                  <div class="qt">Broadcast Message</div><div class="qs">Platform announcements</div>
                </a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/reports">
                  <div class="qi" style="background:#DCFCE7;color:#16A34A;"><i class="fas fa-chart-bar"></i></div>
                  <div class="qt">View Reports</div><div class="qs">Exports &amp; analytics</div>
                </a>
                <a class="qa-card" href="${pageContext.request.contextPath}/admin/sos">
                  <div class="qi" style="background:#FEE2E2;color:#DC2626;"><i class="fas fa-broadcast-tower"></i></div>
                  <div class="qt">SOS Control Center</div><div class="qs">Live emergency desk</div>
                </a>
              </div>
            </div>
          </section>
        </div>
      </div>

      <div class="row g-3" id="moduleOversight">

                <!-- Women Creator Hub Oversight -->
                <div class="col-12 mb-4">
                    <div class="dashboard-panel">
                        <h5 class="dashboard-panel-title mb-4" style="font-size: 1.1rem;">
                            <i class="fas fa-shield-alt text-danger me-2"></i> Women Creator Hub Oversight
                        </h5>

                        <ul class="nav nav-tabs mb-3" id="creatorHubTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="moder-tab" data-bs-toggle="tab" data-bs-target="#moderContent" type="button" role="tab" >
                                    Moderation Queue (${moderationQueue.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="reports-tab" data-bs-toggle="tab" data-bs-target="#reportsContent" type="button" role="tab" >
                                    Safety Reports (${reports.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="verify-tab" data-bs-toggle="tab" data-bs-target="#verifyContent" type="button" role="tab" >
                                    Creator Badges
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="payout-tab" data-bs-toggle="tab" data-bs-target="#payoutContent" type="button" role="tab" >
                                    Cashouts (${cashoutRequests.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="campaign-tab" data-bs-toggle="tab" data-bs-target="#campaignContent" type="button" role="tab" >
                                    Create Brand Campaign
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="creatorHubTabContents">
                            <!-- MODERATION QUEUE -->
                            <div class="tab-pane fade show active" id="moderContent" role="tabpanel">
                                <c:if test="${empty moderationQueue}">
                                    <p class="text-muted small">No items pending safety moderation.</p>
                                </c:if>
                                <c:if test="${not empty moderationQueue}">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Media</th>
                                                    <th>Creator</th>
                                                    <th>Title & Details</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="v" items="${moderationQueue}">
                                                    <tr id="hub-moder-${v.id}">
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${v.fileType eq 'VIDEO'}">
                                                                    <video src="${v.videoPath}" style="width:100px; max-height:70px; object-fit:cover;" controls muted></video>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${v.videoPath}" style="width:100px; max-height:70px; object-fit:cover;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><strong>${v.user.fullName}</strong></td>
                                                        <td>
                                                            <strong>${v.title}</strong>
                                                            <p class="text-muted text-xs mb-0">${v.description}</p>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-sm btn-success me-1" onclick="hubAction(${v.id}, true)">Approve</button>
                                                            <button class="btn btn-sm btn-danger" onclick="hubAction(${v.id}, false)">Block</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>

                            <!-- SAFETY REPORTS -->
                            <div class="tab-pane fade" id="reportsContent" role="tabpanel">
                                <c:if test="${empty reports}">
                                    <p class="text-muted small">No user safety reports submitted.</p>
                                </c:if>
                                <c:if test="${not empty reports}">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Post</th>
                                                    <th>Creator</th>
                                                    <th>Reporter</th>
                                                    <th>Reason</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${reports}">
                                                    <tr id="hub-report-${r.id}">
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${r.video.fileType eq 'VIDEO'}">
                                                                    <video src="${r.video.videoPath}" style="width:80px; max-height:60px; object-fit:cover;" controls muted></video>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${r.video.videoPath}" style="width:80px; max-height:60px; object-fit:cover;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <small class="d-block text-muted text-center">${r.video.title}</small>
                                                        </td>
                                                        <td>${r.video.user.fullName}</td>
                                                        <td>${r.reportedBy.fullName}</td>
                                                        <td><span class="text-warning font-weight-bold text-xs">${r.reason}</span></td>
                                                        <td>
                                                            <button class="btn btn-sm btn-outline-success me-1" onclick="hubClearReport(${r.id})">Clear</button>
                                                            <button class="btn btn-sm btn-danger" onclick="hubDeletePost(${r.id})">Delete Post</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>

                            <!-- CREATOR BADGES -->
                            <div class="tab-pane fade" id="verifyContent" role="tabpanel">
                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mt-2 mb-2">
                                    <h6 class="text-secondary mb-0">Pending Creator applications (Join Us)</h6>
                                    <a href="${pageContext.request.contextPath}/admin/pending-creators" class="btn btn-sm btn-outline-primary">Open full queue</a>
                                </div>
                                <div class="table-responsive mb-4">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Category / City</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${creatorsVerificationList}">
                                                <tr>
                                                    <td>${c.fullName}</td>
                                                    <td>${c.email}</td>
                                                    <td class="small">${empty c.creatorCategory ? '-' : c.creatorCategory}<br><span class="text-muted">${empty c.creatorCity ? '' : c.creatorCity}</span></td>
                                                    <td><span class="badge bg-warning text-dark">${empty c.creatorProfileStatus ? 'INCOMPLETE' : c.creatorProfileStatus}</span></td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/admin/creators/${c.id}/approve" method="post" class="d-inline">
                                                            <button type="submit" class="btn btn-sm btn-warning text-dark font-weight-bold">Approve &amp; Badge</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty creatorsVerificationList}">
                                                <tr><td colspan="5" class="text-muted text-center small">No pending creator applications.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <h6 class="text-secondary mt-2">Eligible Creators (Reward Points &gt; 100)</h6>
                                <div class="table-responsive mb-4">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Points</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${eligibleCreatorsByPoints}">
                                                <tr>
                                                    <td>${c.fullName}</td>
                                                    <td>${c.email}</td>
                                                    <td><strong class="text-warning">${c.rewardPoints}</strong></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-warning text-dark font-weight-bold" onclick="hubBadge(${c.id}, true)">Verify &amp; Badge</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty eligibleCreatorsByPoints}">
                                                <tr><td colspan="4" class="text-muted text-center small">No pending creators eligible by points.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <h6 class="text-secondary">Verified Creators</h6>
                                <div class="table-responsive">
                                    <table class="table align-middle">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${verifiedCreators}">
                                                <tr>
                                                    <td>${c.fullName} <i class="fa-solid fa-circle-check text-info"></i></td>
                                                    <td>${c.email}</td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-danger" onclick="hubBadge(${c.id}, false)">Retract</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- CASHOUTS -->
                            <div class="tab-pane fade" id="payoutContent" role="tabpanel">
                                <c:if test="${empty cashoutRequests}">
                                    <p class="text-muted small">No pending cash-out payout requests.</p>
                                </c:if>
                                <c:if test="${not empty cashoutRequests}">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Creator</th>
                                                    <th>Redeemed Points</th>
                                                    <th>Payout Amount</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="c" items="${cashoutRequests}">
                                                    <tr id="hub-cash-${c.id}">
                                                        <td>${c.creator.fullName}</td>
                                                        <td>${c.points}</td>
                                                        <td><strong class="text-success">Rs. ${c.amount}</strong></td>
                                                        <td>
                                                            <button class="btn btn-sm btn-success me-1" onclick="hubPayout(${c.id}, true)">Approve</button>
                                                            <button class="btn btn-sm btn-outline-danger" onclick="hubPayout(${c.id}, false)">Reject</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>

                            <!-- CREATE BRAND CAMPAIGN -->
                            <div class="tab-pane fade" id="campaignContent" role="tabpanel">
                                <form id="brandCampaignForm" action="${pageContext.request.contextPath}/creator-hub/admin/create-campaign" method="POST">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label text-dark small">Brand Name</label>
                                            <input type="text" name="brandName" class="form-control" placeholder="Brand Name" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label text-dark small">Campaign Title</label>
                                            <input type="text" name="campaignTitle" class="form-control" placeholder="Campaign Title" required>
                                        </div>
                                        <div class="col-12 mb-3">
                                            <label class="form-label text-dark small">Brief Requirements</label>
                                            <textarea name="description" class="form-control" rows="3" placeholder="Sponsorship description requirements..." required></textarea>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label text-dark small">Pay Rate per Post (Rs.)</label>
                                            <input type="number" name="payRate" class="form-control" placeholder="e.g. 500" required>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-purple btn-sm">Create Sponsorship Listing</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- -- Fitness & Wellness Administration -- -->
                <div class="col-12 mb-4" id="fitnessOversightTabs">
                    <div class="dashboard-panel">
                        <h5 class="dashboard-panel-title mb-4" style="font-size: 1.1rem; color: #10b981;">
                            <i class="fas fa-dumbbell text-success me-2"></i> Fitness &amp; Wellness Administration
                        </h5>

                        <ul class="nav nav-tabs mb-3" id="fitnessAdminTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="fit-pending-tab" data-bs-toggle="tab" data-bs-target="#fitPendingContent" type="button" role="tab" >
                                    Trainer Approvals (${pendingTrainers.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="fit-active-tab" data-bs-toggle="tab" data-bs-target="#fitActiveContent" type="button" role="tab" >
                                    Active Trainers (${activeTrainers.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="fit-stats-tab" data-bs-toggle="tab" data-bs-target="#fitStatsContent" type="button" role="tab" >
                                    Fitness Reports &amp; Analytics
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="fitnessAdminTabContents">
                            <!-- TRAINER APPROVALS -->
                            <div class="tab-pane fade show active" id="fitPendingContent" role="tabpanel">
                                <c:choose>
                                    <c:when test="${empty pendingTrainers}">
                                        <p class="text-muted small">No trainer verification applications pending review.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table align-middle">
                                                <thead>
                                                    <tr>
                                                        <th>Coach Name</th>
                                                        <th>Experience</th>
                                                        <th>Fees / Hour</th>
                                                        <th>Verification Certs</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="t" items="${pendingTrainers}">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <img src="${not empty t.profilePhotoPath ? t.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" style="width:40px; height:40px; border-radius:50%; object-fit:cover;">
                                                                    <div>
                                                                        <strong>${t.fullName}</strong>
                                                                        <small class="d-block text-muted">${t.email}</small>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>${t.experience} Years</td>
                                                            <td>₹${t.sessionFees}</td>
                                                            <td>
                                                                <c:if test="${not empty t.certificationsPath}">
                                                                    <a href="${t.certificationsPath}" target="_blank" class="btn btn-xs btn-outline-primary" style="font-size:0.75rem; border-radius:15px;">
                                                                        <i class="fas fa-file-pdf"></i> View Certificate
                                                                    </a>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex gap-1">
                                                                    <a href="${pageContext.request.contextPath}/admin/fitness/trainer/${t.id}" target="_blank" class="btn btn-sm btn-outline-info py-1">View Profile Fully</a>
                                                                    <form action="${pageContext.request.contextPath}/admin/fitness/verify" method="POST">
                                                                        <input type="hidden" name="id" value="${t.id}">
                                                                        <input type="hidden" name="approve" value="true">
                                                                        <button type="submit" class="btn btn-sm btn-success py-1">Approve</button>
                                                                    </form>
                                                                    <form action="${pageContext.request.contextPath}/admin/fitness/verify" method="POST">
                                                                        <input type="hidden" name="id" value="${t.id}">
                                                                        <input type="hidden" name="approve" value="false">
                                                                        <button type="submit" class="btn btn-sm btn-outline-danger py-1">Reject</button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- ACTIVE TRAINERS ROSTER -->
                            <div class="tab-pane fade" id="fitActiveContent" role="tabpanel">
                                <c:choose>
                                    <c:when test="${empty activeTrainers}">
                                        <p class="text-muted small">No verified fitness coaches listed yet.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table align-middle">
                                                <thead>
                                                    <tr>
                                                        <th>Coach Name</th>
                                                        <th>Specialities</th>
                                                        <th>Rating</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="t" items="${activeTrainers}">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <img src="${not empty t.profilePhotoPath ? t.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" style="width:40px; height:40px; border-radius:50%; object-fit:cover;">
                                                                    <div>
                                                                        <strong>${t.fullName}</strong>
                                                                        <small class="d-block text-muted">${t.email}</small>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <small class="text-success fw-bold">${t.specializations}</small>
                                                            </td>
                                                            <td><strong class="text-warning">* ${t.rating}</strong></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${t.suspended}">
                                                                        <span class="badge bg-danger">Suspended</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-success">Active</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex gap-1">
                                                                    <a href="${pageContext.request.contextPath}/admin/fitness/trainer/${t.id}" target="_blank" class="btn btn-sm btn-outline-info py-1" style="font-size:0.8rem; border-radius:15px;">View Profile Fully</a>
                                                                    <form action="${pageContext.request.contextPath}/admin/fitness/suspend" method="POST">
                                                                        <input type="hidden" name="id" value="${t.id}">
                                                                        <input type="hidden" name="suspend" value="${!t.suspended}">
                                                                        <button type="submit" class="btn btn-sm ${t.suspended ? 'btn-success' : 'btn-outline-danger'} py-1" style="font-size:0.8rem; border-radius:15px;">
                                                                            ${t.suspended ? 'Activate' : 'Suspend'}
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- FITNESS REPORTS & ANALYTICS -->
                            <div class="tab-pane fade" id="fitStatsContent" role="tabpanel">
                                <div class="row text-center mt-3 g-3">
                                    <div class="col-md-3">
                                        <div style="background:#eafaf1; padding:20px; border-radius:15px; border:1px solid #10b981;">
                                            <h4 class="fw-bold mb-0 text-success">${activeTrainers.size()}</h4>
                                            <small class="text-muted">Total Coaches Listed</small>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div style="background:#f0fdf4; padding:20px; border-radius:15px; border:1px solid #10b981;">
                                            <h4 class="fw-bold mb-0 text-success">${fitnessBookings.size()}</h4>
                                            <small class="text-muted">Session Bookings</small>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div style="background:#edfcf2; padding:20px; border-radius:15px; border:1px solid #10b981;">
                                            <c:set var="totalRev" value="0.0" />
                                            <c:forEach var="b" items="${fitnessBookings}">
                                                <c:if test="${b.paymentStatus eq 'PAID'}">
                                                    <c:set var="totalRev" value="${totalRev + b.paymentAmount}" />
                                                </c:if>
                                            </c:forEach>
                                            <h4 class="fw-bold mb-0 text-success">₹${totalRev}</h4>
                                            <small class="text-muted">Direct Session Revenue</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

      </div>

      <div class="ad-footer">
        <span>© 2026 Fight D Fear. All rights reserved.</span>
        <span>Admin Portal</span>
      </div>
    </div>
  </main>
</div>

<script>
  (function () {
    let lastSig = null;

    function setText(id, val) {
      const el = document.getElementById(id);
      if (el) el.textContent = (val == null || val === undefined ? "-" : String(val));
    }

    function greeting() {
      const h = new Date().getHours();
      const part = h < 12 ? 'Good morning' : (h < 17 ? 'Good afternoon' : 'Good evening');
      const el = document.getElementById('adGreeting');
      if (!el) return;
      let name = el.getAttribute('data-name');
      if (!name) {
        name = (el.textContent || 'Admin').replace(/^Good (morning|afternoon|evening),\s*/i, '').replace(/!$/, '').replace(/^Hello,\s*/i, '').trim() || 'Admin';
        el.setAttribute('data-name', name);
      }
      el.textContent = part + ', ' + name + '!';
    }

    async function refresh() {
      try {
        const res = await fetch("${pageContext.request.contextPath}/admin/dashboard.meta", {
          headers: { "Accept": "application/json" }
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data.error) return;

        setText("stat-totalUsers", data.totalUsers);
        setText("stat-verifiedDoctors", data.totalVerifiedDoctors);
        setText("stat-platformRevenue", "₹" + Number(data.totalPlatformRevenue || 0).toLocaleString('en-IN'));
        setText("stat-totalWomenEvents", data.totalWomenEvents);
        if (data.reportedVideos != null) setText("stat-reportedItems", data.reportedVideos);

        const pendingTotal =
          Number(data.pendingDoctors || 0) +
          Number(data.pendingCentres || 0) +
          Number(data.pendingTrainers || 0) +
          Number(data.pendingJobApplications || 0) +
          Number(data.pendingDeliveryPartners || 0) +
          Number(data.pendingCreators || 0) +
          Number(data.pendingEducators || 0) +
          Number(data.pendingUsers || 0) +
          Number(data.pendingWomenProducts || 0) +
          Number(data.pendingProposals || 0) +
          Number(data.pendingEntrepreneurs || 0) +
          Number(data.pendingInvestors || 0) +
          Number(data.pendingWomenEvents || 0);
        setText("stat-pendingVerifications", pendingTotal);
        setText("ov-total", pendingTotal);
        setText("ov-doctors", data.pendingDoctors);
        setText("ov-centres", data.pendingCentres);
        setText("ov-jobs", data.pendingJobApplications);
        setText("qt-doctors", data.pendingDoctors);
        setText("qt-trainers", data.pendingTrainers);
        setText("queue-doc-count", data.pendingDoctors);
        setText("esc-doctors", data.pendingDoctors);
        setText("esc-users", data.pendingUsers);
        setText("esc-sos", data.totalLiveSos);
        if (data.reportedVideos != null) setText("esc-reports", data.reportedVideos);

        var sideBadge = document.getElementById("sosSideBadge");
        if (sideBadge) {
            if (data.totalLiveSos > 0) {
                sideBadge.style.display = "inline-block";
                sideBadge.textContent = data.totalLiveSos;
            } else {
                sideBadge.style.display = "none";
            }
        }
        lastSig = data.signature;
      } catch (e) {}
    }

    document.querySelectorAll('.queue-tab').forEach(function(btn) {
      btn.addEventListener('click', function() {
        document.querySelectorAll('.queue-tab').forEach(function(b){ b.classList.remove('active'); });
        btn.classList.add('active');
        var key = btn.getAttribute('data-queue');
        document.querySelectorAll('.queue-pane').forEach(function(p){ p.classList.add('d-none'); });
        var pane = document.getElementById('queue-' + key);
        if (pane) pane.classList.remove('d-none');
      });
    });

    document.addEventListener('keydown', function(e) {
      if ((e.ctrlKey || e.metaKey) && (e.key === 'k' || e.key === 'K')) {
        e.preventDefault();
        var s = document.getElementById('adPageSearch');
        if (s) s.focus();
      }
    });

    const toggleBtn = document.getElementById('sidebarToggle');
    const closeBtn = document.getElementById('closeSidebar');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    if (toggleBtn && sidebar && overlay) {
        toggleBtn.addEventListener('click', () => { sidebar.classList.add('active'); overlay.classList.add('active'); });
    }
    if (closeBtn && sidebar && overlay) {
        closeBtn.addEventListener('click', () => { sidebar.classList.remove('active'); overlay.classList.remove('active'); });
    }
    if (overlay && sidebar) {
        overlay.addEventListener('click', () => { sidebar.classList.remove('active'); overlay.classList.remove('active'); });
    }

    greeting();
    refresh();
    setInterval(refresh, 5000);
  })();

  function hubAction(videoId, approve) {
      const formData = new URLSearchParams();
      formData.append('videoId', videoId);
      formData.append('approve', approve);
      fetch('${pageContext.request.contextPath}/creator-hub/admin/approve', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData.toString()
      }).then(res => res.json()).then(data => {
          if (data.success) {
              alert(approve ? "Approved!" : "Blocked!");
              const row = document.getElementById('hub-moder-' + videoId);
              if (row) row.remove();
          }
      });
  }
  function hubClearReport(reportId) {
      fetch('${pageContext.request.contextPath}/creator-hub/admin/delete-reported?reportId=' + reportId, { method: 'POST' })
      .then(res => res.json()).then(data => {
          if (data.success) {
              alert("Report cleared");
              const row = document.getElementById('hub-report-' + reportId);
              if (row) row.remove();
          }
      });
  }
  function hubDeletePost(reportId) {
      if (confirm("Delete this post permanently?")) {
          fetch('${pageContext.request.contextPath}/creator-hub/admin/delete-reported?reportId=' + reportId, { method: 'POST' })
          .then(res => res.json()).then(data => {
              if (data.success) {
                  alert("Post deleted");
                  const row = document.getElementById('hub-report-' + reportId);
                  if (row) row.remove();
              }
          });
      }
  }
  function hubBadge(creatorId, verify) {
      const formData = new URLSearchParams();
      formData.append('creatorId', creatorId);
      formData.append('verify', verify);
      fetch('${pageContext.request.contextPath}/creator-hub/admin/verify', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData.toString()
      }).then(res => res.json()).then(data => {
          if (data.success) {
              alert("Verified Badge Status Updated");
              window.location.reload();
          }
      });
  }
  function hubPayout(cashoutId, approve) {
      const formData = new URLSearchParams();
      formData.append('cashoutId', cashoutId);
      formData.append('approve', approve);
      fetch('${pageContext.request.contextPath}/creator-hub/admin/cashout', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData.toString()
      }).then(res => res.json()).then(data => {
          if (data.success) {
              alert(approve ? "Payout approved & credited!" : "Payout rejected & refunded!");
              const row = document.getElementById('hub-cash-' + cashoutId);
              if (row) row.remove();
          }
      });
  }
</script>

<script>
  (function activateCreatorHubTabFromUrl() {
    const params = new URLSearchParams(window.location.search);
    const hubTab = params.get('hubTab');
    const hash = window.location.hash;
    function showCreatorHubTab(tabButtonId, paneId) {
      const tabBtn = document.getElementById(tabButtonId);
      const pane = document.getElementById(paneId);
      if (!tabBtn || !pane) return;
      document.querySelectorAll('#creatorHubTabs .nav-link').forEach(function(link) { link.classList.remove('active'); });
      document.querySelectorAll('#creatorHubTabContents .tab-pane').forEach(function(p) { p.classList.remove('show', 'active'); });
      tabBtn.classList.add('active');
      pane.classList.add('show', 'active');
      const section = document.getElementById('creatorHubTabs');
      if (section) section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    if (hubTab === 'campaign') {
      showCreatorHubTab('campaign-tab', 'campaignContent');
    } else if (hash === '#creatorHubTabs') {
      const section = document.getElementById('creatorHubTabs');
      if (section) section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else if (hash === '#fitnessOversightTabs') {
      const section = document.getElementById('fitnessOversightTabs');
      if (section) section.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  })();
</script>

</body>
</html>

