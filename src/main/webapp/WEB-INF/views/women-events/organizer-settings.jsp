<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Settings — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css"/>
    <style>
        .org-alert {
            padding: 12px 14px; border-radius: 10px; font-size: 0.85rem;
            margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
        }
        .org-alert-success { background: #F0FDF4; border: 1px solid #BBF7D0; color: #166534; }
        .org-alert-error { background: #FEF2F2; border: 1px solid #FECACA; color: #B91C1C; }

        .settings-card { margin-bottom: 18px; }
        .settings-card-header {
            padding: 16px 20px; border-bottom: 1px solid var(--fdf-border);
            display: flex; align-items: center; gap: 10px;
        }
        .settings-card-header h3 {
            font-size: 1rem; font-weight: 800; color: var(--fdf-navy); margin: 0;
        }
        .settings-icon {
            width: 36px; height: 36px; border-radius: 10px;
            background: var(--fdf-rose-soft); color: var(--fdf-accent);
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .settings-icon.danger { background: #FEF2F2; color: #DC2626; }
        .settings-card-body { padding: 20px; }

        .info-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 0; border-bottom: 1px solid var(--fdf-border); font-size: 0.88rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-row .label { font-weight: 600; color: var(--fdf-text-muted); }
        .info-row .value { color: var(--fdf-navy); font-weight: 700; text-align: right; }

        .org-btn-danger {
            background: var(--fdf-white); color: #DC2626;
            border: 1px solid #FECACA; border-radius: 10px; padding: 10px 20px;
            font-family: inherit; font-weight: 700; font-size: 0.88rem;
            display: inline-flex; align-items: center; gap: 6px;
            text-decoration: none; cursor: pointer; transition: all 0.2s;
        }
        .org-btn-danger:hover { background: #FEF2F2; border-color: #DC2626; color: #DC2626; }

        .danger-note { font-size: 0.85rem; color: var(--fdf-text-muted); margin-bottom: 16px; }
    </style>
</head>
<body class="org-hub">

<%@ include file="../fragments/organizer-sidebar.jsp" %>

<div class="org-main-wrapper">
    <div class="org-topbar">
        <div class="org-topbar-left">
            <h2>Settings</h2>
            <p>Manage your account and security preferences.</p>
        </div>
        <div class="org-topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="org-btn-secondary">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="org-page-content org-page-content--narrow">
        <c:if test="${not empty success}">
            <div class="org-alert org-alert-success">
                <i class="bi bi-check-circle-fill"></i><c:out value="${success}"/>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="org-alert org-alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i><c:out value="${error}"/>
            </div>
        </c:if>

        <div class="org-card settings-card">
            <div class="settings-card-header">
                <div class="settings-icon"><i class="bi bi-person-badge"></i></div>
                <h3>Account Information</h3>
            </div>
            <div class="settings-card-body">
                <div class="info-row"><span class="label">Full Name</span><span class="value"><c:out value="${host.fullName}"/></span></div>
                <div class="info-row"><span class="label">Email</span><span class="value"><c:out value="${host.email}"/></span></div>
                <div class="info-row"><span class="label">Phone</span><span class="value"><c:out value="${host.phone}"/></span></div>
                <div class="info-row"><span class="label">Organization</span><span class="value"><c:out value="${host.organizerName}"/></span></div>
                <div class="info-row"><span class="label">Organizer Type</span><span class="value"><c:out value="${host.organizerType}"/></span></div>
                <div class="info-row">
                    <span class="label">Verification Status</span>
                    <span class="value">
                        <c:choose>
                            <c:when test="${host.verificationStatus == 'VERIFIED'}">
                                <span class="org-status-pill ok">Verified</span>
                            </c:when>
                            <c:otherwise>
                                <span class="org-status-pill wait"><c:out value="${host.verificationStatus}"/></span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div style="margin-top:16px;">
                    <a href="${pageContext.request.contextPath}/women-events/organizer/profile-completion" class="org-btn-primary">
                        <i class="bi bi-pencil"></i> Edit Profile
                    </a>
                </div>
            </div>
        </div>

        <div class="org-card settings-card">
            <div class="settings-card-header">
                <div class="settings-icon"><i class="bi bi-shield-lock"></i></div>
                <h3>Change Password</h3>
            </div>
            <div class="settings-card-body">
                <form method="post" action="${pageContext.request.contextPath}/women-events/organizer/settings/change-password">
                    <div class="org-form-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" class="org-form-input" required placeholder="Enter current password"/>
                    </div>
                    <div class="org-form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" class="org-form-input" required placeholder="Enter new password (min 8 chars)" minlength="8"/>
                    </div>
                    <div class="org-form-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="org-form-input" required placeholder="Repeat new password"/>
                    </div>
                    <button type="submit" class="org-btn-primary"><i class="bi bi-key"></i> Update Password</button>
                </form>
            </div>
        </div>

        <div class="org-card settings-card">
            <div class="settings-card-header">
                <div class="settings-icon danger"><i class="bi bi-exclamation-triangle"></i></div>
                <h3>Danger Zone</h3>
            </div>
            <div class="settings-card-body">
                <p class="danger-note">Logging out will end your current session. All unsaved changes will be lost.</p>
                <a href="${pageContext.request.contextPath}/women-events/host/logout" class="org-btn-danger">
                    <i class="bi bi-box-arrow-right"></i> Logout Now
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
