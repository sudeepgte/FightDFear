<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Profile | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <style>
        :root {
            --surface-primary: #FFFFFF;
            --surface-page: #F8FAFC;
            --surface-rose-soft: #FFF1F2;
            --surface-rose-light: #FFE4E6;
            --border-neutral: #E2E8F0;
            --text-primary: #0F172A;
            --text-secondary: #64748B;
            --accent-rose: #F43F5E;
            --accent-rose-hover: #E11D48;
        }

        body.profile-page {
            font-family: 'Poppins', sans-serif;
            background: var(--surface-page);
            color: var(--text-primary);
            overflow-x: hidden;
        }

        #page-content-wrapper.profile-full {
            margin-left: 260px;
            padding: 0 !important;
            min-height: calc(100vh - 80px);
            background: var(--surface-page);
            width: calc(100% - 260px);
        }

        .profile-fullscreen {
            display: flex;
            min-height: calc(100vh - 80px);
            width: 100%;
        }

        /* 30% — full-height rose side panel */
        .profile-side {
            width: 300px;
            min-width: 300px;
            background: var(--surface-rose-soft);
            border-right: 1px solid var(--border-neutral);
            padding: 32px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .profile-avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid var(--surface-primary);
            box-shadow: 0 10px 28px rgba(244, 63, 94, 0.2);
            margin-bottom: 16px;
        }

        .profile-side-name {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--text-primary);
            text-align: center;
        }

        .profile-side-role {
            color: var(--text-secondary);
            font-size: 0.875rem;
            margin-bottom: 24px;
        }

        .profile-coins {
            width: 100%;
            background: var(--surface-rose-light);
            border: 1px solid #FECDD3;
            border-radius: 14px;
            padding: 16px;
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-coins-num {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--accent-rose);
        }

        .profile-coins-txt {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .profile-side-actions {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: auto;
        }

        .btn-rose {
            background: var(--accent-rose);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 11px 18px;
            font-weight: 600;
            font-size: 0.875rem;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .btn-rose:hover { background: var(--accent-rose-hover); color: #fff; }

        .btn-ghost {
            background: var(--surface-primary);
            color: var(--text-primary);
            border: 1px solid var(--border-neutral);
            border-radius: 50px;
            padding: 11px 18px;
            font-weight: 600;
            font-size: 0.875rem;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .btn-ghost:hover {
            background: var(--surface-rose-light);
            color: var(--text-primary);
        }

        /* 60% — full-width main area */
        .profile-body {
            flex: 1;
            min-width: 0;
            background: var(--surface-primary);
            display: flex;
            flex-direction: column;
        }

        .profile-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 32px;
            border-bottom: 1px solid var(--border-neutral);
            background: var(--surface-primary);
        }

        .profile-topbar h1 {
            font-size: 1.5rem;
            font-weight: 800;
            margin: 0;
            color: var(--text-primary);
        }

        .profile-topbar p {
            margin: 2px 0 0;
            color: var(--text-secondary);
            font-size: 0.875rem;
        }

        .profile-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.875rem;
            padding: 8px 14px;
            border-radius: 50px;
            border: 1px solid var(--border-neutral);
            background: var(--surface-page);
        }

        .profile-back:hover {
            background: var(--surface-rose-soft);
            color: var(--text-primary);
        }

        .profile-content {
            flex: 1;
            padding: 28px 32px 40px;
            background: var(--surface-page);
        }

        /* stats — full width strip */
        .profile-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0;
            background: var(--surface-primary);
            border: 1px solid var(--border-neutral);
            border-radius: 0;
            margin-bottom: 24px;
            overflow: hidden;
        }

        .profile-stat {
            text-align: center;
            padding: 20px 16px;
            border-right: 1px solid var(--border-neutral);
            background: var(--surface-rose-soft);
        }

        .profile-stat:last-child { border-right: none; }

        .profile-stat-num {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-primary);
        }

        .profile-stat-lbl {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .profile-field {
            background: var(--surface-primary);
            border: 1px solid var(--border-neutral);
            padding: 16px 18px;
        }

        .profile-field-label {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: var(--text-secondary);
            margin-bottom: 6px;
        }

        .profile-field-label i {
            color: var(--accent-rose);
            margin-right: 6px;
        }

        .profile-field-val {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-primary);
            word-break: break-word;
        }

        .profile-field-val a {
            color: var(--accent-rose);
            text-decoration: none;
        }

        .profile-progress-block {
            background: var(--surface-primary);
            border: 1px solid var(--border-neutral);
            padding: 20px 22px;
            margin-bottom: 24px;
        }

        .profile-progress-top {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.9rem;
        }

        .profile-progress-top span:last-child {
            font-weight: 800;
            color: var(--accent-rose);
        }

        .profile-progress-track {
            height: 10px;
            background: var(--surface-rose-light);
            overflow: hidden;
        }

        .profile-progress-fill {
            height: 100%;
            background: var(--accent-rose);
        }

        .profile-footer-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            padding-top: 8px;
        }

        .btn-edit-profile {
            background: var(--accent-rose);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 12px 28px;
            font-weight: 700;
            text-decoration: none;
        }

        .btn-edit-profile:hover {
            background: var(--accent-rose-hover);
            color: #fff;
        }

        .btn-del-profile {
            background: var(--surface-primary);
            border: 1px solid #FECACA;
            color: #DC2626;
            border-radius: 50px;
            padding: 12px 28px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-del-profile:hover {
            background: #FEF2F2;
            color: #DC2626;
        }

        @media (max-width: 992px) {
            #page-content-wrapper.profile-full {
                margin-left: 0 !important;
                width: 100% !important;
            }
            .profile-fullscreen { flex-direction: column; }
            .profile-side {
                width: 100%;
                min-width: 0;
                border-right: none;
                border-bottom: 1px solid var(--border-neutral);
            }
            .profile-side-actions { margin-top: 20px; }
        }

        @media (max-width: 768px) {
            #wrapper { flex-direction: column !important; margin-top: 68px !important; }
            .profile-topbar { padding: 16px; flex-wrap: wrap; gap: 12px; }
            .profile-content { padding: 16px; }
            .profile-grid { grid-template-columns: 1fr; }
            .profile-stats { grid-template-columns: 1fr; }
            .profile-stat { border-right: none; border-bottom: 1px solid var(--border-neutral); }
            .profile-stat:last-child { border-bottom: none; }
        }
    </style>
</head>
<body class="profile-page">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" class="profile-full" data-skip-global-back="true">

        <div class="profile-fullscreen">
            <!-- 30% full-height side -->
            <aside class="profile-side">
                <img src="${pageContext.request.contextPath}${user.profilePhoto}"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/default-profile.png';"
                     alt="Profile" class="profile-avatar">
                <div class="profile-side-name">${user.fullName}</div>
                <div class="profile-side-role">Member profile</div>

                <div class="profile-coins">
                    <div class="profile-coins-num">${user.rewardPoints != null ? user.rewardPoints : 0}</div>
                    <div class="profile-coins-txt"><i class="bi bi-coin"></i> Coins earned</div>
                </div>

                <div class="profile-side-actions">
                    <a href="${pageContext.request.contextPath}/index/contact" class="btn-rose">
                        <i class="bi bi-chat-dots me-1"></i> Get in Touch
                    </a>
                    <a href="${pageContext.request.contextPath}/users/${user.id}/emergency-contacts" class="btn-ghost">
                        <i class="bi bi-telephone me-1"></i> Emergency Contacts
                    </a>
                </div>
            </aside>

            <!-- 60% full-width main -->
            <main class="profile-body">
                <div class="profile-topbar">
                    <div>
                        <h1>Hello, ${user.fullName}</h1>
                        <p>Your complete profile overview</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/users/dashboard" class="profile-back">
                        <i class="bi bi-arrow-left"></i> Dashboard
                    </a>
                </div>

                <div class="profile-content">
                    <div class="profile-stats">
                        <div class="profile-stat">
                            <div class="profile-stat-num">${postsCount != null ? postsCount : 0}</div>
                            <div class="profile-stat-lbl">Posts</div>
                        </div>
                        <div class="profile-stat">
                            <div class="profile-stat-num">${followersCount != null ? followersCount : 0}</div>
                            <div class="profile-stat-lbl">Followers</div>
                        </div>
                        <div class="profile-stat">
                            <div class="profile-stat-num">${followingCount != null ? followingCount : 0}</div>
                            <div class="profile-stat-lbl">Following</div>
                        </div>
                    </div>

                    <div class="profile-grid">
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-envelope"></i>Email</div>
                            <div class="profile-field-val">${user.email}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-phone"></i>Phone</div>
                            <div class="profile-field-val">${not empty user.phoneNumber ? user.phoneNumber : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-geo-alt"></i>Address</div>
                            <div class="profile-field-val">${not empty user.homeAddress ? user.homeAddress : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-building"></i>City</div>
                            <div class="profile-field-val">${not empty user.city ? user.city : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-calendar-event"></i>Date of birth</div>
                            <div class="profile-field-val">${not empty user.dob ? user.dob : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-person"></i>Age</div>
                            <div class="profile-field-val">${user.age != null ? user.age : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-gender-ambiguous"></i>Gender</div>
                            <div class="profile-field-val">${user.gender != null ? user.gender : '—'}</div>
                        </div>
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-hash"></i>User ID</div>
                            <div class="profile-field-val">${user.id}</div>
                        </div>
                        <c:if test="${not empty user.identityDocument && !fn:contains(user.identityDocument, 'web-member')}">
                        <div class="profile-field">
                            <div class="profile-field-label"><i class="bi bi-file-earmark"></i>ID document</div>
                            <div class="profile-field-val">
                                <a href="${pageContext.request.contextPath}${user.identityDocument}" target="_blank">View document</a>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <div class="profile-progress-block">
                        <div class="profile-progress-top">
                            <strong>Profile completion</strong>
                            <span>${completionPercentage != null ? completionPercentage : 0}%</span>
                        </div>
                        <div class="profile-progress-track">
                            <div class="profile-progress-fill" style="width:${completionPercentage != null ? completionPercentage : 0}%;"></div>
                        </div>
                    </div>

                    <div class="profile-footer-actions">
                        <a href="${pageContext.request.contextPath}/users/update/${user.id}" class="btn-edit-profile">
                            <i class="bi bi-pencil-square me-1"></i> Edit profile
                        </a>
                        <a href="${pageContext.request.contextPath}/users/delete/${user.id}" class="btn-del-profile"
                           onclick="return confirm('Are you sure you want to delete your account?');">
                            <i class="bi bi-trash me-1"></i> Delete account
                        </a>
                    </div>
                </div>
            </main>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
