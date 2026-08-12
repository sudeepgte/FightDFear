<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Organizer Dashboard — Women Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
    :root {
        --primary:      #1E1B4A;
        --primary-light:#2B275F;
        --accent:       #F43F5E;
        --accent-dark:  #E82A50;
        --background:   #FEF0EF;
        --card-bg:      #FFFFFF;
        --soft-pink:    #FEDBDF;
        --light-pink:   #FFF3F4;
        --text-dark:    #1E1B4A;
        --text-gray:    #6B7280;
        --border:       #E5E7EB;
    }

    *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
    body { font-family: 'Outfit', sans-serif; background: var(--background); color: var(--text-dark); display:flex; min-height:100vh; overflow-x:hidden; }

    /* ── SIDEBAR ── */
    .sidebar {
        width: 220px; min-width:220px;
        background: var(--primary);
        color: #fff;
        display: flex;
        flex-direction: column;
        padding: 0;
        position: fixed;
        top:0; left:0; bottom:0;
        z-index: 100;
        overflow-y: auto;
    }
    .sidebar-brand {
        display: flex; align-items: center; gap: 10px;
        padding: 22px 20px 18px;
        border-bottom: 1px solid rgba(255,255,255,0.08);
        font-size: 1.05rem; font-weight: 800; color: #fff;
    }
    .sidebar-brand .brand-icon {
        width: 36px; height: 36px; background: var(--accent);
        border-radius: 10px; display: flex; align-items:center; justify-content:center;
        font-size: 1.1rem;
    }
    .sidebar-nav { flex:1; padding: 12px 10px; }
    .nav-label { font-size: 0.68rem; font-weight: 700; color: rgba(255,255,255,0.35);
        letter-spacing: 1px; text-transform: uppercase; padding: 14px 10px 6px; }
    .nav-item {
        display: flex; align-items: center; gap: 10px;
        padding: 10px 12px; border-radius: 10px;
        color: rgba(255,255,255,0.7); text-decoration: none;
        font-size: 0.9rem; font-weight: 600;
        transition: all 0.2s; margin-bottom: 2px;
        position: relative;
    }
    .nav-item:hover { background: rgba(255,255,255,0.08); color:#fff; }
    .nav-item.active { background: var(--accent); color:#fff; }
    .nav-item .nav-badge {
        margin-left: auto; background: var(--accent-dark); color:#fff;
        font-size:0.65rem; font-weight:700; padding:2px 6px; border-radius:20px;
    }
    .sidebar-user {
        padding: 14px 16px;
        border-top: 1px solid rgba(255,255,255,0.08);
        display: flex; align-items: center; gap: 10px;
    }
    .user-avatar-sm {
        width: 34px; height: 34px; border-radius: 50%;
        background: linear-gradient(135deg, var(--accent-dark), var(--accent));
        display: flex; align-items:center; justify-content:center;
        font-size:0.9rem; font-weight:700; color:#fff; flex-shrink:0;
    }
    .user-info-sm .name { font-size:0.85rem; font-weight:700; color:#fff; }
    .user-info-sm .role { font-size:0.72rem; color:rgba(255,255,255,0.5); }

    /* ── MAIN ── */
    .main-wrapper { margin-left: 220px; flex:1; display:flex; flex-direction:column; min-height:100vh; }

    /* Top bar */
    .topbar {
        background: var(--card-bg); padding: 14px 28px;
        display: flex; align-items: center; justify-content: space-between;
        border-bottom: 1px solid var(--border); position: sticky; top:0; z-index:50;
    }
    .topbar-left h2 { font-size:1.1rem; font-weight:800; color: var(--primary); }
    .topbar-left p { font-size:0.8rem; color: var(--text-gray); margin-top:1px; }
    .topbar-right { display:flex; align-items:center; gap:14px; }
    .topbar-icon-btn {
        width:38px; height:38px; border-radius:50%; border:1.5px solid var(--border);
        background: var(--card-bg); display:flex; align-items:center; justify-content:center;
        cursor:pointer; font-size:1rem; color: var(--text-gray); position:relative; transition:background 0.2s;
    }
    .topbar-icon-btn:hover { background: var(--light-pink); }
    .notif-dot { position:absolute; top:4px; right:4px; width:8px; height:8px;
        background: var(--accent); border-radius:50%; border:2px solid #fff; }
    .topbar-avatar {
        width:38px; height:38px; border-radius:50%;
        background: linear-gradient(135deg, var(--accent-dark), var(--accent));
        display:flex; align-items:center; justify-content:center;
        font-weight:800; color:#fff; font-size:0.9rem; cursor:pointer;
    }
    .create-event-btn {
        background: var(--accent); color:#fff; border:none; border-radius:10px;
        padding: 9px 18px; font-family:'Outfit',sans-serif; font-weight:700;
        font-size:0.88rem; display:flex; align-items:center; gap:6px;
        text-decoration:none; cursor:pointer; transition:all 0.2s;
    }
    .create-event-btn:hover { background: var(--accent-dark); color:#fff; transform:translateY(-1px); box-shadow:0 4px 15px rgba(244,63,94,0.35); }

    /* Page content */
    .page-content { padding: 24px 28px; flex:1; }

    /* Welcome hero */
    .welcome-banner {
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 60%, var(--accent-dark) 100%);
        border-radius: 18px; padding: 28px 32px; color:#fff;
        display:flex; align-items:center; justify-content:space-between; margin-bottom:22px;
        position:relative; overflow:hidden;
    }
    .welcome-banner::after {
        content:''; position:absolute; right:-60px; top:-60px;
        width:250px; height:250px; border-radius:50%;
        background:rgba(255,255,255,0.05);
    }
    .welcome-banner::before {
        content:''; position:absolute; right:60px; bottom:-80px;
        width:180px; height:180px; border-radius:50%;
        background:rgba(255,255,255,0.04);
    }
    .welcome-text h1 { font-size:1.55rem; font-weight:800; margin-bottom:4px; }
    .welcome-text p { font-size:0.88rem; opacity:0.8; }

    /* Stat cards */
    .stats-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:22px; }
    .stat-card {
        background: var(--card-bg); border-radius:16px; padding:20px 22px;
        box-shadow:0 2px 12px rgba(30,27,74,0.06); display:flex; align-items:center; gap:16px;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .stat-card:hover { transform:translateY(-3px); box-shadow:0 8px 24px rgba(30,27,74,0.1); }
    .stat-icon-wrap {
        width:52px; height:52px; border-radius:14px;
        display:flex; align-items:center; justify-content:center; font-size:1.5rem; flex-shrink:0;
    }
    .stat-info .label { font-size:0.78rem; color: var(--text-gray); font-weight:600; text-transform:uppercase; letter-spacing:0.4px; }
    .stat-info .number { font-size:1.9rem; font-weight:800; line-height:1.1; margin:2px 0; }
    .stat-info .trend { font-size:0.75rem; font-weight:600; }
    .trend-up { color:#16a34a; }
    .trend-down { color:#dc2626; }

    /* Content grid */
    .content-grid { display:grid; grid-template-columns: 1fr 300px; gap:20px; margin-bottom:22px; }

    /* Events table card */
    .card {
        background: var(--card-bg); border-radius:16px;
        box-shadow:0 2px 12px rgba(30,27,74,0.06); overflow:hidden;
    }
    .card-header {
        padding:16px 20px; display:flex; align-items:center; justify-content:space-between;
        border-bottom:1px solid var(--soft-pink);
    }
    .card-title { font-size:1rem; font-weight:800; color: var(--primary); display:flex; align-items:center; gap:8px; }
    .view-all-link { font-size:0.8rem; font-weight:600; color: var(--accent); text-decoration:none; }
    .view-all-link:hover { text-decoration:underline; }

    /* Search + filter toolbar */
    .table-toolbar {
        padding:12px 20px; display:flex; align-items:center; gap:10px;
        border-bottom:1px solid var(--soft-pink);
    }
    .search-input {
        flex:1; border:1.5px solid var(--border); border-radius:10px;
        padding:8px 14px 8px 36px; font-family:'Outfit',sans-serif;
        font-size:0.85rem; outline:none; background:#fafafa;
        transition:border-color 0.2s;
    }
    .search-input:focus { border-color: var(--accent); }
    .search-wrap { position:relative; flex:1; }
    .search-wrap i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#aaa; font-size:0.9rem; }
    .filter-select {
        border:1.5px solid var(--border); border-radius:10px;
        padding:8px 12px; font-family:'Outfit',sans-serif; font-size:0.82rem;
        outline:none; background:#fafafa; color: var(--text-gray); cursor:pointer;
    }

    /* Table */
    .events-table-wrap { overflow-x:auto; }
    .events-table-wrap table { width:100%; border-collapse:collapse; }
    .events-table-wrap thead tr { background: var(--light-pink); }
    .events-table-wrap th {
        padding:11px 16px; text-align:left; font-size:0.75rem;
        font-weight:700; color: var(--text-gray); text-transform:uppercase; letter-spacing:0.5px;
    }
    .events-table-wrap td {
        padding:13px 16px; border-top:1px solid var(--soft-pink);
        font-size:0.875rem; vertical-align:middle;
    }
    .events-table-wrap tr:hover td { background: var(--light-pink); }

    .event-thumb {
        width:40px; height:40px; border-radius:10px;
        background:linear-gradient(135deg, var(--accent-dark), var(--accent));
        display:flex; align-items:center; justify-content:center;
        font-size:1rem; color:#fff; flex-shrink:0;
    }
    .event-name-cell { display:flex; align-items:center; gap:10px; }
    .event-name-main { font-weight:700; font-size:0.88rem; color: var(--primary); }
    .event-name-sub { font-size:0.73rem; color:#aaa; }

    .status-pill {
        border-radius:20px; padding:4px 12px; font-size:0.72rem; font-weight:700;
        display:inline-block; white-space:nowrap;
    }
    .status-APPROVED { background:#dcfce7; color:#15803d; }
    .status-PENDING  { background:#fef9c3; color:#92400e; }
    .status-REJECTED { background:#ffe4e6; color:#9f1239; }

    .action-btns { display:flex; gap:6px; }
    .action-btn {
        width:30px; height:30px; border-radius:8px; border:1.5px solid var(--border);
        background: var(--card-bg); display:flex; align-items:center; justify-content:center;
        font-size:0.85rem; color: var(--text-gray); cursor:pointer; text-decoration:none;
        transition:all 0.2s;
    }
    .action-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--light-pink); }

    /* Empty state */
    .empty-state { text-align:center; padding:48px 20px; color:#aaa; }
    .empty-state i { font-size:2.8rem; color: var(--soft-pink); display:block; margin-bottom:12px; }
    .empty-state h5 { font-weight:700; color: var(--text-gray); margin-bottom:8px; }
    .create-btn-empty {
        background:linear-gradient(135deg, var(--accent-dark), var(--accent)); color:#fff; border:none;
        border-radius:12px; padding:10px 22px; font-family:'Outfit',sans-serif;
        font-weight:700; font-size:0.9rem; text-decoration:none;
        display:inline-flex; align-items:center; gap:6px; margin-top:10px;
        transition:all 0.2s;
    }

    /* Recent Registrations panel */
    .reg-item {
        display:flex; align-items:center; gap:12px;
        padding:12px 20px; border-bottom:1px solid var(--soft-pink);
        transition:background 0.15s;
    }
    .reg-item:last-child { border-bottom:none; }
    .reg-item:hover { background: var(--light-pink); }
    .reg-avatar {
        width:38px; height:38px; border-radius:50%; flex-shrink:0;
        display:flex; align-items:center; justify-content:center;
        font-weight:700; font-size:0.88rem; color:#fff;
    }
    .reg-info .reg-name { font-size:0.85rem; font-weight:700; color: var(--primary); }
    .reg-info .reg-event { font-size:0.73rem; color: var(--text-gray); }
    .reg-meta { margin-left:auto; text-align:right; }
    .reg-date { font-size:0.72rem; color:#aaa; }
    .reg-status { font-size:0.68rem; font-weight:700; padding:2px 8px; border-radius:20px; margin-top:3px; display:inline-block; }
    .reg-status.confirmed { background:#dcfce7; color:#15803d; }
    .reg-status.pending   { background:#fef9c3; color:#92400e; }

    /* Bottom analytics grid */
    .analytics-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
    .perf-stats { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; padding:16px 20px; }
    .perf-stat-item { text-align:center; }
    .perf-stat-icon { font-size:1.4rem; margin-bottom:6px; }
    .perf-stat-num { font-size:1.25rem; font-weight:800; color: var(--primary); }
    .perf-stat-label { font-size:0.72rem; color: var(--text-gray); font-weight:600; }
    .chart-wrap { padding:16px 20px; }

    /* Alerts */
    .alert-banner { margin-bottom:16px; }

    @media (max-width:1100px) {
        .stats-grid { grid-template-columns:repeat(2,1fr); }
        .content-grid { grid-template-columns:1fr; }
        .analytics-grid { grid-template-columns:1fr; }
    }
    @media (max-width:768px) {
        .sidebar { width:64px; min-width:64px; }
        .sidebar-brand span, .nav-item span, .nav-badge, .user-info-sm, .nav-label { display:none; }
        .sidebar-brand { padding:16px 14px; }
        .nav-item { justify-content:center; }
        .main-wrapper { margin-left:64px; }
        .stats-grid { grid-template-columns:1fr 1fr; }
    }
    </style>
</head>
<body>

<!-- ═══════════════════ SIDEBAR ═══════════════════ -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-calendar-event-fill"></i></div>
        <span>Event<br>Organizer</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Main</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item active">
            <i class="bi bi-speedometer2"></i><span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/my-events" class="nav-item">
            <i class="bi bi-calendar3"></i><span>My Events</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="nav-item">
            <i class="bi bi-plus-circle-fill"></i><span>Create Event</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/registrations" class="nav-item">
            <i class="bi bi-people-fill"></i><span>Registrations</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-bar-chart-fill"></i><span>Event Analytics</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item">
            <i class="bi bi-chat-dots-fill"></i><span>Messages</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/notifications" class="nav-item">
            <i class="bi bi-bell-fill"></i><span>Notifications</span>
            <span class="nav-badge">${newNotifCount > 0 ? newNotifCount : ''}</span>
        </a>
        <div class="nav-label">Account</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/edit-profile" class="nav-item">
            <i class="bi bi-person-circle"></i><span>Edit Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/settings" class="nav-item">
            <i class="bi bi-gear-fill"></i><span>Settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/women-events/host/logout" class="nav-item">
            <i class="bi bi-box-arrow-right"></i><span>Logout</span>
        </a>
    </nav>
    <div class="sidebar-user">
        <div class="user-avatar-sm">${fn:substring(host.fullName, 0, 1)}</div>
        <div class="user-info-sm">
            <div class="name">${host.fullName}</div>
            <div class="role">${host.organizerType}</div>
        </div>
    </div>
</aside>

<!-- ═══════════════════ MAIN WRAPPER ═══════════════════ -->
<div class="main-wrapper">

    <!-- TOP BAR -->
    <div class="topbar">
        <div class="topbar-left">
            <h2>Welcome back, ${host.fullName}! 👋</h2>
            <p>Here's what's happening with your events today.</p>
        </div>
        <div class="topbar-right">
            <div class="topbar-icon-btn">
                <i class="bi bi-bell-fill"></i>
                <span class="notif-dot"></span>
            </div>
            <div class="topbar-avatar">${fn:substring(host.fullName, 0, 1)}</div>
            <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="create-event-btn">
                <i class="bi bi-plus-lg"></i>Create Event
            </a>
        </div>
    </div>

    <!-- PAGE CONTENT -->
    <div class="page-content">

        <!-- Alert banner -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show alert-banner rounded-3">
                <i class="bi bi-check-circle-fill me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- STATS ROW -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon-wrap" style="background:#ede9fe;">
                    <i class="bi bi-calendar-fill" style="color:#6d28d9;"></i>
                </div>
                <div class="stat-info">
                    <div class="label">Total Events</div>
                    <div class="number" style="color:#1e1b4b;">${fn:length(myEvents)}</div>
                    <div class="trend trend-up"><i class="bi bi-arrow-up-right"></i> 20% this month</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-wrap" style="background:#dcfce7;">
                    <i class="bi bi-check-circle-fill" style="color:#16a34a;"></i>
                </div>
                <div class="stat-info">
                    <div class="label">Approved Events</div>
                    <div class="number" style="color:#16a34a;">${approvedCount}</div>
                    <div class="trend trend-up"><i class="bi bi-arrow-up-right"></i> 15% this month</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-wrap" style="background:#fef9c3;">
                    <i class="bi bi-hourglass-split" style="color:#d97706;"></i>
                </div>
                <div class="stat-info">
                    <div class="label">Pending Events</div>
                    <div class="number" style="color:#d97706;">${pendingCount}</div>
                    <div class="trend trend-down"><i class="bi bi-arrow-down-right"></i> 5% this month</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-wrap" style="background:#dbeafe;">
                    <i class="bi bi-people-fill" style="color:#2563eb;"></i>
                </div>
                <div class="stat-info">
                    <div class="label">Total Registrations</div>
                    <div class="number" style="color:#2563eb;">${totalRegistrations}</div>
                    <div class="trend trend-up"><i class="bi bi-arrow-up-right"></i> 18% this month</div>
                </div>
            </div>
        </div>

        <!-- CONTENT GRID: Events Table + Recent Registrations -->
        <div class="content-grid">

            <!-- My Events table -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="bi bi-calendar3"></i> My Events</div>
                    <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="view-all-link">View All Events</a>
                </div>
                <div class="table-toolbar">
                    <div class="search-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text" class="search-input" placeholder="Search events..." id="eventSearch" onkeyup="filterEvents()"/>
                    </div>
                    <select class="filter-select" id="statusFilter" onchange="filterEvents()">
                        <option value="">All Status</option>
                        <option value="APPROVED">Approved</option>
                        <option value="PENDING">Pending</option>
                        <option value="REJECTED">Rejected</option>
                    </select>
                    <select class="filter-select">
                        <option>All Events</option>
                    </select>
                </div>
                <c:choose>
                    <c:when test="${not empty myEvents}">
                        <div class="events-table-wrap">
                            <table id="eventsTable">
                                <thead>
                                    <tr>
                                        <th>Event Name</th>
                                        <th>Date</th>
                                        <th>Location</th>
                                        <th>Status</th>
                                        <th>Registrations</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ev" items="${myEvents}">
                                        <tr data-name="${fn:toLowerCase(ev.name)}" data-status="${ev.status}">
                                            <td>
                                                <div class="event-name-cell">
                                                    <div class="event-thumb"><i class="bi bi-calendar-event-fill"></i></div>
                                                    <div>
                                                        <div class="event-name-main">${ev.name}</div>
                                                        <div class="event-name-sub">${ev.category.displayName}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="font-size:0.83rem; color:#555; font-weight:600;">${ev.eventDate}</div>
                                            </td>
                                            <td>
                                                <div style="font-size:0.83rem; color:#555;">${ev.city}</div>
                                                <div style="font-size:0.72rem; color:#aaa;">${ev.venue}</div>
                                            </td>
                                            <td><span class="status-pill status-${ev.status}">${ev.status}</span></td>
                                            <td>
                                                <div style="font-size:0.85rem; font-weight:700; color:#1e1b4b;">
                                                    <c:choose>
                                                        <c:when test="${ev.free}"><span style="color:#16a34a;">FREE</span></c:when>
                                                        <c:otherwise>₹${ev.entryFee}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${pageContext.request.contextPath}/women-events/${ev.id}" class="action-btn" title="View"><i class="bi bi-eye-fill"></i></a>
                                                    <c:if test="${ev.status == 'APPROVED'}">
                                                        <a href="${pageContext.request.contextPath}/women-events/organizer/${ev.id}/attendees" class="action-btn" title="Attendees"><i class="bi bi-people-fill"></i></a>
                                                    </c:if>
                                                    <button class="action-btn" title="More"><i class="bi bi-three-dots-vertical"></i></button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-calendar-x"></i>
                            <h5>No events created yet</h5>
                            <p>Create your first event and reach thousands of women!</p>
                            <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="create-btn-empty">
                                <i class="bi bi-plus-circle-fill"></i>Create Your First Event
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Recent Registrations -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="bi bi-clock-history"></i> Recent Registrations</div>
                    <a href="#" class="view-all-link">View All</a>
                </div>
                <c:choose>
                    <c:when test="${not empty recentRegistrations}">
                        <c:forEach var="reg" items="${recentRegistrations}">
                            <div class="reg-item">
                                <div class="reg-avatar" style="background:linear-gradient(135deg,#6d28d9,#a855f7);">
                                    ${fn:substring(reg.user.fullName, 0, 1)}
                                </div>
                                <div class="reg-info">
                                    <div class="reg-name">${reg.user.fullName}</div>
                                    <div class="reg-event">${reg.event.name}</div>
                                </div>
                                <div class="reg-meta">
                                    <div class="reg-date">${reg.registeredAt}</div>
                                    <span class="reg-status ${reg.status == 'CANCELLED' ? 'pending' : 'confirmed'}">${reg.status}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Sample placeholder registrations for display -->
                        <div class="reg-item">
                            <div class="reg-avatar" style="background:linear-gradient(135deg,#6d28d9,#a855f7);">A</div>
                            <div class="reg-info">
                                <div class="reg-name">Anjali Rao</div>
                                <div class="reg-event">Women's Wellness Workshop</div>
                            </div>
                            <div class="reg-meta">
                                <div class="reg-date">20 Aug 2024</div>
                                <span class="reg-status confirmed">Confirmed</span>
                            </div>
                        </div>
                        <div class="reg-item">
                            <div class="reg-avatar" style="background:linear-gradient(135deg,#0ea5e9,#6d28d9);">S</div>
                            <div class="reg-info">
                                <div class="reg-name">Sneha Kumari</div>
                                <div class="reg-event">Women's Wellness Workshop</div>
                            </div>
                            <div class="reg-meta">
                                <div class="reg-date">20 Aug 2024</div>
                                <span class="reg-status confirmed">Confirmed</span>
                            </div>
                        </div>
                        <div class="reg-item">
                            <div class="reg-avatar" style="background:linear-gradient(135deg,#f59e0b,#ef4444);">P</div>
                            <div class="reg-info">
                                <div class="reg-name">Priyanka Das</div>
                                <div class="reg-event">Startup &amp; Networking Meetup</div>
                            </div>
                            <div class="reg-meta">
                                <div class="reg-date">25 Aug 2024</div>
                                <span class="reg-status pending">Pending</span>
                            </div>
                        </div>
                        <div class="reg-item">
                            <div class="reg-avatar" style="background:linear-gradient(135deg,#10b981,#059669);">M</div>
                            <div class="reg-info">
                                <div class="reg-name">Meera Iyer</div>
                                <div class="reg-event">Yoga &amp; Mindfulness Session</div>
                            </div>
                            <div class="reg-meta">
                                <div class="reg-date">02 Sep 2024</div>
                                <span class="reg-status confirmed">Confirmed</span>
                            </div>
                        </div>
                        <div class="reg-item">
                            <div class="reg-avatar" style="background:linear-gradient(135deg,#ec4899,#a855f7);">K</div>
                            <div class="reg-info">
                                <div class="reg-name">Kavya Nair</div>
                                <div class="reg-event">Yoga &amp; Mindfulness Session</div>
                            </div>
                            <div class="reg-meta">
                                <div class="reg-date">02 Sep 2024</div>
                                <span class="reg-status pending">Pending</span>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- ANALYTICS GRID -->
        <div class="analytics-grid">
            <!-- Event Performance -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="bi bi-graph-up-arrow"></i> Event Performance <span style="font-weight:400;font-size:0.8rem;color:#aaa;">(This Month)</span></div>
                    <select class="filter-select" style="font-size:0.78rem; padding:5px 10px;">
                        <option>This Month</option>
                        <option>Last Month</option>
                        <option>This Year</option>
                    </select>
                </div>
                <div class="perf-stats">
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-people-fill" style="color:#6d28d9;"></i></div>
                        <div class="perf-stat-num">${totalRegistrations}</div>
                        <div class="perf-stat-label">Total Registrations</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-person-check-fill" style="color:#16a34a;"></i></div>
                        <div class="perf-stat-num">72%</div>
                        <div class="perf-stat-label">Seat Occupancy</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-eye-fill" style="color:#0ea5e9;"></i></div>
                        <div class="perf-stat-num">1,456</div>
                        <div class="perf-stat-label">Event Views</div>
                    </div>
                    <div class="perf-stat-item">
                        <div class="perf-stat-icon"><i class="bi bi-x-circle-fill" style="color:#ef4444;"></i></div>
                        <div class="perf-stat-num">24</div>
                        <div class="perf-stat-label">Cancelled</div>
                    </div>
                </div>
            </div>

            <!-- Registrations Overview chart -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="bi bi-bar-chart-line-fill"></i> Registrations Overview</div>
                    <select class="filter-select" style="font-size:0.78rem; padding:5px 10px;">
                        <option>This Month</option>
                        <option>Last Month</option>
                    </select>
                </div>
                <div class="chart-wrap">
                    <canvas id="regChart" height="130"></canvas>
                </div>
            </div>
        </div>

    </div><!-- end page-content -->
</div><!-- end main-wrapper -->

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
/* Search/filter table */
function filterEvents() {
    const q = document.getElementById('eventSearch').value.toLowerCase();
    const status = document.getElementById('statusFilter').value;
    const rows = document.querySelectorAll('#eventsTable tbody tr');
    rows.forEach(r => {
        const nameMatch = !q || r.dataset.name.includes(q);
        const statusMatch = !status || r.dataset.status === status;
        r.style.display = (nameMatch && statusMatch) ? '' : 'none';
    });
}

/* Registrations chart */
const ctx = document.getElementById('regChart');
if (ctx) {
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['1 Aug','8 Aug','15 Aug','22 Aug','29 Aug'],
            datasets: [{
                label: 'Registrations',
                data: [20, 55, 40, 80, 110],
                borderColor: '#6d28d9',
                backgroundColor: 'rgba(109,40,217,0.1)',
                borderWidth: 2.5,
                pointRadius: 4,
                pointBackgroundColor: '#6d28d9',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color:'rgba(0,0,0,0.04)' },
                     ticks: { font: { size:11, family:'Outfit' } } },
                x: { grid: { display:false },
                     ticks: { font: { size:11, family:'Outfit' } } }
            }
        }
    });
}
</script>
</body>
</html>
