<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Notifications — Women Events</title>
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
    .page-content { padding:24px 28px; flex:1; max-width:780px; }
    .notif-card { background: var(--card-bg); border-radius:16px; box-shadow:0 2px 12px rgba(30,27,74,0.06); overflow:hidden; }
    .notif-header { padding:16px 22px; border-bottom:1px solid var(--soft-pink); display:flex; align-items:center; justify-content:space-between; }
    .notif-title { font-size:1rem; font-weight:800; color: var(--primary); display:flex; align-items:center; gap:8px; }
    .notif-item { display:flex; align-items:center; gap:14px; padding:14px 22px; border-bottom:1px solid var(--soft-pink); transition:background 0.15s; }
    .notif-item:last-child { border-bottom:none; }
    .notif-item:hover { background: var(--light-pink); }
    .notif-icon { width:42px; height:42px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:1.1rem; flex-shrink:0; }
    .notif-body { flex:1; }
    .notif-msg { font-size:0.88rem; font-weight:600; color: var(--primary); }
    .notif-event { font-size:0.78rem; color: var(--text-gray); margin-top:2px; }
    .notif-time { font-size:0.75rem; color:#aaa; white-space:nowrap; }
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
        <a href="${pageContext.request.contextPath}/women-events/organizer/registrations" class="nav-item"><i class="bi bi-people-fill"></i><span>Registrations</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item"><i class="bi bi-bar-chart-fill"></i><span>Event Analytics</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="nav-item"><i class="bi bi-chat-dots-fill"></i><span>Messages</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/notifications" class="nav-item active"><i class="bi bi-bell-fill"></i><span>Notifications</span></a>
        <div class="nav-label">Account</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/edit-profile" class="nav-item"><i class="bi bi-person-circle"></i><span>Edit Profile</span></a>
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
            <h2>Notifications</h2>
            <p>New event registrations and activity alerts.</p>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="back-btn"><i class="bi bi-arrow-left"></i> Dashboard</a>
            <div class="topbar-avatar">${fn:substring(host.fullName, 0, 1)}</div>
        </div>
    </div>

    <div class="page-content">
        <div class="notif-card">
            <div class="notif-header">
                <div class="notif-title">
                    <i class="bi bi-bell-fill" style="color:var(--accent);"></i> Recent Activity
                    <span style="background:var(--soft-pink);color:var(--accent);border-radius:12px;padding:2px 10px;font-size:0.75rem;">${fn:length(notifications)}</span>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach var="reg" items="${notifications}">
                        <div class="notif-item">
                            <div class="notif-icon" style="background:linear-gradient(135deg, var(--accent-dark), var(--accent));">
                                <i class="bi bi-person-fill" style="color:#fff;"></i>
                            </div>
                            <div class="notif-body">
                                <div class="notif-msg">
                                    <span style="color:var(--accent);">${reg.user.fullName}</span>
                                    <c:choose>
                                        <c:when test="${reg.status == 'CANCELLED'}"> cancelled their registration for</c:when>
                                        <c:when test="${reg.status == 'ATTENDED'}"> attended</c:when>
                                        <c:otherwise> registered for</c:otherwise>
                                    </c:choose>
                                    <strong> ${reg.event.name}</strong>
                                </div>
                                <div class="notif-event">
                                    <i class="bi bi-ticket-perforated-fill" style="color:var(--accent-dark);"></i> Ticket: ${reg.ticketCode}
                                    &nbsp;·&nbsp;
                                    <i class="bi bi-geo-alt-fill" style="color:var(--accent);"></i> ${reg.event.city}
                                </div>
                            </div>
                            <div class="notif-time">${reg.registeredAt}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="bi bi-bell-slash"></i>
                        <h5 style="font-weight:700;color:#555;margin-bottom:8px;">No notifications yet</h5>
                        <p>When users register for your events, notifications will appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
