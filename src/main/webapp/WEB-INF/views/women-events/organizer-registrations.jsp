<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Registrations — Women Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
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
    body { font-family: 'Outfit', sans-serif; background: var(--background); color: var(--text-dark); display:flex; min-height:100vh; }
    .sidebar { width:220px; min-width:220px; background: var(--primary); color:#fff; display:flex; flex-direction:column; position:fixed; top:0; left:0; bottom:0; z-index:100; overflow-y:auto; }
    .sidebar-brand { display:flex; align-items:center; gap:10px; padding:22px 20px 18px; border-bottom:1px solid rgba(255,255,255,0.08); font-size:1.05rem; font-weight:800; color:#fff; }
    .sidebar-brand .brand-icon { width:36px; height:36px; background: var(--accent); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; }
    .sidebar-nav { flex:1; padding:12px 10px; }
    .nav-label { font-size:0.68rem; font-weight:700; color:rgba(255,255,255,0.35); letter-spacing:1px; text-transform:uppercase; padding:14px 10px 6px; }
    .nav-item { display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; color:rgba(255,255,255,0.7); text-decoration:none; font-size:0.9rem; font-weight:600; transition:all 0.2s; margin-bottom:2px; }
    .nav-item:hover { background:rgba(255,255,255,0.08); color:#fff; }
    .nav-item.active { background: var(--accent); color:#fff; }
    .sidebar-user { padding:14px 16px; border-top:1px solid rgba(255,255,255,0.08); display:flex; align-items:center; gap:10px; }
    .user-avatar-sm { width:34px; height:34px; border-radius:50%; background:linear-gradient(135deg, var(--accent-dark), var(--accent)); display:flex; align-items:center; justify-content:center; font-size:0.9rem; font-weight:700; color:#fff; flex-shrink:0; }
    .user-info-sm .name { font-size:0.85rem; font-weight:700; color:#fff; }
    .user-info-sm .role { font-size:0.72rem; color:rgba(255,255,255,0.5); }
    .main-wrapper { margin-left:220px; flex:1; display:flex; flex-direction:column; }
    .topbar { background: var(--card-bg); padding:14px 28px; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid var(--border); position:sticky; top:0; z-index:50; }
    .topbar h2 { font-size:1.1rem; font-weight:800; color: var(--primary); }
    .topbar p { font-size:0.8rem; color: var(--text-gray); margin-top:1px; }
    .topbar-right { display:flex; align-items:center; gap:14px; }
    .topbar-avatar { width:38px; height:38px; border-radius:50%; background:linear-gradient(135deg, var(--accent-dark), var(--accent)); display:flex; align-items:center; justify-content:center; font-weight:800; color:#fff; font-size:0.9rem; }
    .back-btn { border:1.5px solid var(--border); background: var(--card-bg); color: var(--text-gray); border-radius:10px; padding:8px 16px; font-family:'Outfit',sans-serif; font-weight:600; font-size:0.85rem; text-decoration:none; display:flex; align-items:center; gap:6px; }
    .back-btn:hover { border-color: var(--accent); color: var(--accent); }
    .page-content { padding:24px 28px; flex:1; }
    .card { background: var(--card-bg); border-radius:16px; box-shadow:0 2px 12px rgba(30,27,74,0.06); overflow:hidden; }
    .card-header { padding:16px 22px; border-bottom:1px solid var(--soft-pink); display:flex; align-items:center; justify-content:space-between; }
    .card-title { font-size:1rem; font-weight:800; color: var(--primary); display:flex; align-items:center; gap:8px; }
    .search-wrap { position:relative; }
    .search-wrap i { position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#aaa; }
    .search-input { border:1.5px solid var(--border); border-radius:10px; padding:8px 14px 8px 36px; font-family:'Outfit',sans-serif; font-size:0.85rem; outline:none; width:200px; background:#fff; }
    .search-input:focus { border-color: var(--accent); box-shadow:0 0 0 3px rgba(244,63,94,0.1); }
    table { width:100%; border-collapse:collapse; }
    th { padding:11px 16px; text-align:left; font-size:0.75rem; font-weight:700; color: var(--text-gray); text-transform:uppercase; letter-spacing:0.5px; background: var(--light-pink); }
    td { padding:13px 16px; border-top:1px solid var(--soft-pink); font-size:0.875rem; vertical-align:middle; }
    tr:hover td { background: var(--light-pink); }
    .user-cell { display:flex; align-items:center; gap:10px; }
    .u-avatar { width:34px; height:34px; border-radius:50%; background:linear-gradient(135deg, var(--accent-dark), var(--accent)); display:flex; align-items:center; justify-content:center; color:#fff; font-weight:700; font-size:0.85rem; flex-shrink:0; }
    .status-pill { border-radius:20px; padding:4px 12px; font-size:0.72rem; font-weight:700; display:inline-block; }
    .st-REGISTERED { background:#dcfce7; color:#15803d; }
    .st-ATTENDED   { background:#dbeafe; color:#1d4ed8; }
    .st-CANCELLED  { background:#ffe4e6; color:#9f1239; }
    .empty-state { text-align:center; padding:60px 20px; color:#aaa; }
    .empty-state i { font-size:3rem; color: var(--soft-pink); display:block; margin-bottom:12px; }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-calendar-event-fill"></i></div>
        <span>Women Event<br>Organizer</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Main</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item"><i class="bi bi-speedometer2"></i><span>Dashboard</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/my-events" class="nav-item"><i class="bi bi-calendar3"></i><span>My Events</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/create" class="nav-item"><i class="bi bi-plus-circle-fill"></i><span>Create Event</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/registrations" class="nav-item active"><i class="bi bi-people-fill"></i><span>Registrations</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item"><i class="bi bi-bar-chart-fill"></i><span>Event Analytics</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item"><i class="bi bi-chat-dots-fill"></i><span>Messages</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/notifications" class="nav-item"><i class="bi bi-bell-fill"></i><span>Notifications</span></a>
        <div class="nav-label">Account</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion" class="nav-item"><i class="bi bi-person-circle"></i><span>Profile Completion</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/settings" class="nav-item"><i class="bi bi-gear-fill"></i><span>Settings</span></a>
        <a href="${pageContext.request.contextPath}/women-events/host/logout" class="nav-item"><i class="bi bi-box-arrow-right"></i><span>Logout</span></a>
    </nav>
    <div class="sidebar-user">
        <div class="user-avatar-sm">${fn:substring(host.fullName, 0, 1)}</div>
        <div class="user-info-sm">
            <div class="name">${host.fullName}</div>
            <div class="role">${host.organizerType}</div>
        </div>
    </div>
</aside>

<div class="main-wrapper">
    <div class="topbar">
        <div>
            <h2>Registrations</h2>
            <p>All users who have registered for your events.</p>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="back-btn"><i class="bi bi-arrow-left"></i> Dashboard</a>
            <div class="topbar-avatar">${fn:substring(host.fullName, 0, 1)}</div>
        </div>
    </div>

    <div class="page-content">
        <div class="card">
            <div class="card-header">
                <div class="card-title"><i class="bi bi-people-fill"></i> All Registrations
                    <span style="background:var(--soft-pink);color:var(--accent);border-radius:12px;padding:2px 10px;font-size:0.75rem;">${fn:length(allRegistrations)}</span>
                </div>
                <div class="search-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" class="search-input" placeholder="Search..." id="regSearch" onkeyup="filterRegs()"/>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty allRegistrations}">
                    <div style="overflow-x:auto;">
                        <table id="regTable">
                            <thead>
                                <tr>
                                    <th>Attendee</th>
                                    <th>Event</th>
                                    <th>Registered On</th>
                                    <th>Ticket Code</th>
                                    <th>Status</th>
                                    <th>Checked In</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reg" items="${allRegistrations}">
                                    <tr data-search="${fn:toLowerCase(reg.user.fullName)} ${fn:toLowerCase(reg.event.name)}">
                                        <td>
                                            <div class="user-cell">
                                                <div class="u-avatar">${fn:substring(reg.user.fullName, 0, 1)}</div>
                                                <div>
                                                    <div style="font-weight:700;font-size:0.87rem;">${reg.user.fullName}</div>
                                                    <div style="font-size:0.73rem;color:#aaa;">${reg.user.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight:700;font-size:0.87rem;color:var(--primary);">${reg.event.name}</div>
                                            <div style="font-size:0.73rem;color:#aaa;">${reg.event.city}</div>
                                        </td>
                                        <td style="font-size:0.83rem;color:#555;">${reg.registeredAt}</td>
                                        <td><code style="background:var(--light-pink);color:var(--accent);padding:3px 8px;border-radius:6px;font-size:0.8rem;">${reg.ticketCode}</code></td>
                                        <td><span class="status-pill st-${reg.status}">${reg.status}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reg.checkedIn}"><span style="color:#16a34a;font-weight:700;font-size:0.82rem;"><i class="bi bi-check-circle-fill"></i> Yes</span></c:when>
                                                <c:otherwise><span style="color:#aaa;font-size:0.82rem;">No</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-people"></i>
                        <h5 style="font-weight:700;color:#555;margin-bottom:8px;">No registrations yet</h5>
                        <p>When users register for your events, they'll appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
function filterRegs() {
    const q = document.getElementById('regSearch').value.toLowerCase();
    document.querySelectorAll('#regTable tbody tr').forEach(r => {
        r.style.display = !q || r.dataset.search.includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
