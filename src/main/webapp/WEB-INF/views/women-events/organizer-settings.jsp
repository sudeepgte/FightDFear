<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Settings — Women Events</title>
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
    .settings-card { background: var(--card-bg); border-radius:16px; box-shadow:0 2px 12px rgba(30,27,74,0.06); overflow:hidden; margin-bottom:20px; }
    .card-header { padding:16px 22px; border-bottom:1px solid var(--soft-pink); display:flex; align-items:center; gap:10px; }
    .card-header h3 { font-size:1rem; font-weight:800; color: var(--primary); }
    .header-icon { width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1rem; flex-shrink:0; }
    .card-body { padding:22px; }
    .fg { margin-bottom:14px; }
    .fg label { display:block; font-weight:700; font-size:0.78rem; color: var(--text-gray); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.4px; }
    .fg input { width:100%; border:1.5px solid var(--border); border-radius:10px; padding:10px 14px; font-family:'Outfit',sans-serif; font-size:0.9rem; outline:none; transition:border-color 0.2s; background:#fafafa; color: var(--text-dark); }
    .fg input:focus { border-color: var(--accent); background: var(--card-bg); box-shadow:0 0 0 3px rgba(244,63,94,0.1); }
    .save-btn { background:linear-gradient(135deg, var(--accent-dark), var(--accent)); color:#fff; border:none; border-radius:10px; padding:11px 24px; font-family:'Outfit',sans-serif; font-weight:700; font-size:0.92rem; cursor:pointer; display:inline-flex; align-items:center; gap:6px; transition:all 0.2s; text-decoration:none; }
    .save-btn:hover { transform:translateY(-1px); box-shadow:0 4px 14px rgba(244,63,94,0.3); color:#fff; }
    .danger-btn { background: var(--card-bg); color:#dc2626; border:1.5px solid #fecaca; border-radius:10px; padding:11px 24px; font-family:'Outfit',sans-serif; font-weight:700; font-size:0.92rem; cursor:pointer; display:inline-flex; align-items:center; gap:6px; transition:all 0.2s; text-decoration:none; }
    .danger-btn:hover { background:#fef2f2; border-color:#dc2626; }
    .info-row { display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid #f5f5f5; font-size:0.88rem; }
    .info-row:last-child { border-bottom:none; }
    .info-row .label { font-weight:600; color: var(--text-gray); }
    .info-row .value { color: var(--primary); font-weight:700; }
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
        <a href="${pageContext.request.contextPath}/women-events/organizer/notifications" class="nav-item"><i class="bi bi-bell-fill"></i><span>Notifications</span></a>
        <div class="nav-label">Account</div>
        <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion" class="nav-item"><i class="bi bi-person-circle"></i><span>Profile Completion</span></a>
        <a href="${pageContext.request.contextPath}/women-events/organizer/settings" class="nav-item active"><i class="bi bi-gear-fill"></i><span>Settings</span></a>
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
            <h2>Settings</h2>
            <p>Manage your account and security preferences.</p>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="back-btn"><i class="bi bi-arrow-left"></i> Dashboard</a>
            <div class="topbar-avatar">${fn:substring(host.fullName, 0, 1)}</div>
        </div>
    </div>

    <div class="page-content">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show mb-3 rounded-3">
                <i class="bi bi-check-circle-fill me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-3 rounded-3">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Account Info -->
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon" style="background:var(--light-pink);"><i class="bi bi-person-badge-fill" style="color:var(--accent);"></i></div>
                <h3>Account Information</h3>
            </div>
            <div class="card-body">
                <div class="info-row"><span class="label">Full Name</span><span class="value">${host.fullName}</span></div>
                <div class="info-row"><span class="label">Email</span><span class="value">${host.email}</span></div>
                <div class="info-row"><span class="label">Phone</span><span class="value">${host.phone}</span></div>
                <div class="info-row"><span class="label">Organization</span><span class="value">${host.organizerName}</span></div>
                <div class="info-row"><span class="label">Organizer Type</span><span class="value">${host.organizerType}</span></div>
                <div class="info-row"><span class="label">Verification Status</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${host.verificationStatus.name() == 'VERIFIED'}">
                                <span style="background:#dcfce7;color:#15803d;border-radius:12px;padding:3px 10px;font-size:0.78rem;">VERIFIED</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background:#fef9c3;color:#92400e;border-radius:12px;padding:3px 10px;font-size:0.78rem;">${host.verificationStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div style="margin-top:16px;">
                    <a href="${pageContext.request.contextPath}/women-events/organizer/edit-profile" class="save-btn"><i class="bi bi-pencil-fill"></i> Edit Profile</a>
                </div>
            </div>
        </div>

        <!-- Change Password -->
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon" style="background:#dbeafe;"><i class="bi bi-shield-lock-fill" style="color:#2563eb;"></i></div>
                <h3>Change Password</h3>
            </div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/women-events/organizer/settings/change-password">
                    <div class="fg">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required placeholder="Enter current password"/>
                    </div>
                    <div class="fg">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required placeholder="Enter new password (min 8 chars)" minlength="8"/>
                    </div>
                    <div class="fg">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required placeholder="Repeat new password"/>
                    </div>
                    <button type="submit" class="save-btn"><i class="bi bi-key-fill"></i> Update Password</button>
                </form>
            </div>
        </div>

        <!-- Danger Zone -->
        <div class="settings-card">
            <div class="card-header">
                <div class="header-icon" style="background:#fef2f2;"><i class="bi bi-exclamation-triangle-fill" style="color:#dc2626;"></i></div>
                <h3>Danger Zone</h3>
            </div>
            <div class="card-body">
                <p style="font-size:0.85rem;color:#555;margin-bottom:16px;">Logging out will end your current session. All unsaved changes will be lost.</p>
                <a href="${pageContext.request.contextPath}/women-events/host/logout" class="danger-btn"><i class="bi bi-box-arrow-right"></i> Logout Now</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
