<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Edit Profile — Women Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
    *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
    body { font-family: 'Outfit', sans-serif; background: #f4f5fb; color: #1a1a2e; display:flex; min-height:100vh; }
    /* Sidebar (same as dashboard) */
    .sidebar { width:220px; min-width:220px; background:#1e1b4b; color:#fff; display:flex; flex-direction:column; position:fixed; top:0; left:0; bottom:0; z-index:100; overflow-y:auto; }
    .sidebar-brand { display:flex; align-items:center; gap:10px; padding:22px 20px 18px; border-bottom:1px solid rgba(255,255,255,0.08); font-size:1.05rem; font-weight:800; color:#fff; }
    .sidebar-brand .brand-icon { width:36px; height:36px; background:#6d28d9; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; }
    .sidebar-nav { flex:1; padding:12px 10px; }
    .nav-label { font-size:0.68rem; font-weight:700; color:rgba(255,255,255,0.35); letter-spacing:1px; text-transform:uppercase; padding:14px 10px 6px; }
    .nav-item { display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; color:rgba(255,255,255,0.7); text-decoration:none; font-size:0.9rem; font-weight:600; transition:all 0.2s; margin-bottom:2px; }
    .nav-item:hover { background:rgba(255,255,255,0.08); color:#fff; }
    .nav-item.active { background:#6d28d9; color:#fff; }
    .sidebar-user { padding:14px 16px; border-top:1px solid rgba(255,255,255,0.08); display:flex; align-items:center; gap:10px; }
    .user-avatar-sm { width:34px; height:34px; border-radius:50%; background:linear-gradient(135deg,#6d28d9,#a855f7); display:flex; align-items:center; justify-content:center; font-size:0.9rem; font-weight:700; color:#fff; flex-shrink:0; }
    .user-info-sm .name { font-size:0.85rem; font-weight:700; color:#fff; }
    .user-info-sm .role { font-size:0.72rem; color:rgba(255,255,255,0.5); }
    /* Main */
    .main-wrapper { margin-left:220px; flex:1; display:flex; flex-direction:column; }
    .topbar { background:#fff; padding:14px 28px; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid #eee; position:sticky; top:0; z-index:50; }
    .topbar h2 { font-size:1.1rem; font-weight:800; color:#1e1b4b; }
    .topbar p { font-size:0.8rem; color:#888; margin-top:1px; }
    .topbar-right { display:flex; align-items:center; gap:14px; }
    .topbar-avatar { width:38px; height:38px; border-radius:50%; background:linear-gradient(135deg,#6d28d9,#a855f7); display:flex; align-items:center; justify-content:center; font-weight:800; color:#fff; font-size:0.9rem; }
    .back-btn { border:1.5px solid #e5e7eb; background:#fff; color:#555; border-radius:10px; padding:8px 16px; font-family:'Outfit',sans-serif; font-weight:600; font-size:0.85rem; text-decoration:none; display:flex; align-items:center; gap:6px; }
    .back-btn:hover { border-color:#6d28d9; color:#6d28d9; }
    .page-content { padding:24px 28px; flex:1; }
    .form-grid { display:grid; grid-template-columns:260px 1fr; gap:20px; align-items:start; }
    .profile-card { background:#fff; border-radius:16px; box-shadow:0 2px 12px rgba(0,0,0,0.05); padding:28px; text-align:center; }
    .profile-avatar-lg { width:88px; height:88px; border-radius:50%; background:linear-gradient(135deg,#6d28d9,#a855f7); display:flex; align-items:center; justify-content:center; font-size:2rem; font-weight:800; color:#fff; margin:0 auto 14px; }
    .profile-card h3 { font-size:1rem; font-weight:800; color:#1e1b4b; }
    .profile-card p { font-size:0.82rem; color:#888; margin-top:4px; }
    .profile-badge { background:#ede9fe; color:#6d28d9; border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; display:inline-block; margin-top:10px; }
    .info-row { display:flex; align-items:center; gap:8px; font-size:0.82rem; color:#555; margin-top:10px; }
    .main-form-card { background:#fff; border-radius:16px; box-shadow:0 2px 12px rgba(0,0,0,0.05); overflow:hidden; }
    .card-header { padding:16px 22px; border-bottom:1px solid #f1f0f7; display:flex; align-items:center; gap:10px; }
    .card-header h3 { font-size:1rem; font-weight:800; color:#1e1b4b; }
    .header-icon { width:36px; height:36px; border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1rem; flex-shrink:0; }
    .card-body { padding:22px; }
    .two-col { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
    .fg { margin-bottom:14px; }
    .fg label { display:block; font-weight:700; font-size:0.78rem; color:#555; margin-bottom:6px; text-transform:uppercase; letter-spacing:0.4px; }
    .fg input, .fg select, .fg textarea { width:100%; border:1.5px solid #e5e7eb; border-radius:10px; padding:10px 14px; font-family:'Outfit',sans-serif; font-size:0.9rem; outline:none; transition:border-color 0.2s; background:#fafafa; }
    .fg input:focus, .fg select:focus, .fg textarea:focus { border-color:#6d28d9; background:#fff; box-shadow:0 0 0 3px rgba(109,40,217,0.07); }
    .fg textarea { resize:vertical; min-height:90px; }
    .section-sep { font-size:0.75rem; font-weight:800; text-transform:uppercase; letter-spacing:1px; color:#6d28d9; margin:18px 0 12px; display:flex; align-items:center; gap:8px; }
    .section-sep::after { content:''; flex:1; height:1px; background:#ede9fe; }
    .save-btn { background:#6d28d9; color:#fff; border:none; border-radius:10px; padding:11px 24px; font-family:'Outfit',sans-serif; font-weight:700; font-size:0.92rem; cursor:pointer; transition:all 0.2s; display:inline-flex; align-items:center; gap:6px; }
    .save-btn:hover { background:#5b21b6; transform:translateY(-1px); box-shadow:0 4px 14px rgba(109,40,217,0.3); }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-calendar-event-fill"></i></div>
        <span>Event<br>Organizer</span>
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
        <a href="${pageContext.request.contextPath}/women-events/organizer/edit-profile" class="nav-item active"><i class="bi bi-person-circle"></i><span>Edit Profile</span></a>
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
            <h2>Edit Profile</h2>
            <p>Update your organizer information and public details.</p>
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

        <div class="form-grid">
            <!-- Profile card -->
            <div>
                <div class="profile-card">
                    <div class="profile-avatar-lg">${fn:substring(host.fullName, 0, 1)}</div>
                    <h3>${host.fullName}</h3>
                    <p>${host.email}</p>
                    <span class="profile-badge">${host.organizerType}</span>
                    <div class="info-row" style="justify-content:center;margin-top:14px;">
                        <i class="bi bi-telephone-fill" style="color:#6d28d9;"></i> ${host.phone}
                    </div>
                    <c:if test="${not empty host.city}">
                        <div class="info-row" style="justify-content:center;">
                            <i class="bi bi-geo-alt-fill" style="color:#6d28d9;"></i> ${host.city}<c:if test="${not empty host.state}">, ${host.state}</c:if>
                        </div>
                    </c:if>
                    <c:if test="${not empty host.hostBio}">
                        <p style="margin-top:14px;font-size:0.82rem;color:#555;line-height:1.5;text-align:left;">${host.hostBio}</p>
                    </c:if>
                </div>
            </div>

            <!-- Edit form -->
            <div class="main-form-card">
                <div class="card-header">
                    <div class="header-icon" style="background:#ede9fe;"><i class="bi bi-person-fill" style="color:#6d28d9;"></i></div>
                    <h3>Personal &amp; Organizer Details</h3>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/women-events/organizer/edit-profile">
                        <div class="two-col">
                            <div class="fg">
                                <label>Full Name *</label>
                                <input type="text" name="fullName" value="${host.fullName}" required/>
                            </div>
                            <div class="fg">
                                <label>Phone *</label>
                                <input type="tel" name="phone" value="${host.phone}" required/>
                            </div>
                        </div>
                        <div class="two-col">
                            <div class="fg">
                                <label>Organization Name *</label>
                                <input type="text" name="organizerName" value="${host.organizerName}" required/>
                            </div>
                            <div class="fg">
                                <label>Organizer Type *</label>
                                <select name="organizerType" required>
                                    <c:forEach var="t" items="${'NGO,Government,College,Company,Community,Gym,Hospital,Fitness Trainer,Women Entrepreneur'.split(',')}">
                                        <option value="${t}" ${host.organizerType == t ? 'selected' : ''}>${t}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="fg">
                            <label>Bio</label>
                            <textarea name="hostBio" rows="4" placeholder="Tell attendees about your organization...">${host.hostBio}</textarea>
                        </div>

                        <div class="section-sep">Location</div>
                        <div class="two-col">
                            <div class="fg">
                                <label>City</label>
                                <input type="text" name="city" value="${host.city}" placeholder="e.g., Bangalore"/>
                            </div>
                            <div class="fg">
                                <label>State</label>
                                <input type="text" name="state" value="${host.state}" placeholder="e.g., Karnataka"/>
                            </div>
                        </div>

                        <div class="section-sep">Social Links</div>
                        <div class="two-col">
                            <div class="fg">
                                <label><i class="bi bi-globe2" style="color:#6d28d9;"></i> Website</label>
                                <input type="url" name="website" value="${host.website}" placeholder="https://yoursite.com"/>
                            </div>
                            <div class="fg">
                                <label><i class="bi bi-instagram" style="color:#e1306c;"></i> Instagram</label>
                                <input type="text" name="instagram" value="${host.instagram}" placeholder="@handle"/>
                            </div>
                            <div class="fg">
                                <label><i class="bi bi-facebook" style="color:#1877f2;"></i> Facebook</label>
                                <input type="text" name="facebook" value="${host.facebook}" placeholder="page URL or handle"/>
                            </div>
                            <div class="fg">
                                <label><i class="bi bi-linkedin" style="color:#0a66c2;"></i> LinkedIn</label>
                                <input type="text" name="linkedin" value="${host.linkedin}" placeholder="profile URL or handle"/>
                            </div>
                        </div>

                        <div style="margin-top:20px;">
                            <button type="submit" class="save-btn"><i class="bi bi-save-fill"></i> Save Profile</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
