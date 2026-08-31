<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Profile | Fight D Fear</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">

    <!-- 🎨 Custom CSS -->
    <style>
    :root {
        --primary-purple: #F8FAFC;
        --primary-purple-light: #F43F5E;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: #FFFFFF;
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
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

    /* ===== Nav Item Theme Color (desktop only) ===== */
    @media (min-width: 1200px) {
        #navmenu ul li a[href*="/chat/users"],
        #navmenu ul li a[href*="/user/bookings"],
        #navmenu ul li a[href*="/users/wallet"] {
            background: none !important;
            color: #f43f5e !important;
            padding: 5px 14px !important;
            border-radius: 0 !important;
            font-weight: 700 !important;
            box-shadow: none !important;
            letter-spacing: 0.3px;
        }
    }
    
    #ftco-navbar {
        background-color: var(--primary-purple) !important;
        box-shadow: var(--shadow-sm);
    }

    #ftco-navbar .navbar-brand,
    #ftco-navbar .navbar-brand span {
        color: #ffffff !important;
        font-weight: 700;
    }

    #ftco-navbar .nav-link {
        color: #ffffff !important;
        font-size: 1.2rem !important;
        font-weight: 500;
        letter-spacing: 0.5px;
        padding: 10px 18px !important;
        transition: all 0.3s ease;
    }

    #ftco-navbar .nav-link:hover,
    #ftco-navbar .nav-item.active .nav-link {
        color: var(--primary-gold) !important;
        transform: scale(1.05);
        background-color: rgba(255,255,255,0.05);
        border-radius: 8px;
    }

    #ftco-navbar .navbar-toggler {
        border-color: #ffffff;
    }
    #ftco-navbar .navbar-toggler-icon,
    #ftco-navbar .oi-menu {
        color: #ffffff;
    }

    .hero-section::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(244, 63, 94, 0.05);
        z-index: 1;
    }

    .hero-section .container {
        position: relative;
        z-index: 2;
        padding-top: 100px;
    }

    .hero-section h1 {
        font-size: 2.8rem;
        font-weight: 700;
        margin-bottom: 20px;
        font-family: 'Playfair Display', serif;
        color: #fff;
        text-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }

    .hero-section p {
        font-size: 1.2rem;
        color: #f8f9fa;
        margin-bottom: 35px;
        max-width: 650px;
        margin-left: auto;
        margin-right: auto;
        text-shadow: 0 1px 4px rgba(0,0,0,0.3);
    }

    .hero-section a.btn-primary {
        background-color: var(--primary-purple-light);
        border-color: var(--primary-purple-light);
        transition: all 0.3s ease;
        font-weight: 600;
        box-shadow: var(--shadow-sm);
    }
    .hero-section a.btn-primary:hover {
        background-color: var(--primary-purple);
        border-color: var(--primary-purple);
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .hero-section a.btn-outline-light:hover {
        background-color: #fff;
        color: var(--primary-purple-light) !important;
        transform: translateY(-2px);
    }

    .coin-box {
        background: rgba(255, 215, 0, 0.2);
        border: 1px solid var(--primary-gold);
        padding: 12px;
        border-radius: 8px;
        font-size: 18px;
        font-weight: bold;
        color: #b87c00;
        box-shadow: var(--shadow-sm);
    }

    @media (max-width: 768px) {
        #ftco-navbar .nav-link {
            font-size: 1rem !important;
            padding: 8px 12px !important;
        }
        .hero-section h1 {
            font-size: 2rem;
        }
        .hero-section p {
            font-size: 1rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for hero content */
    .hero-section h1 {
        animation: fadeInUp 0.8s ease-out forwards;
    }
    .hero-section p {
        animation: fadeInUp 0.8s ease-out 0.15s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }
    .hero-section a.btn-primary,
    .hero-section a.btn-outline-light {
        animation: fadeInUp 0.8s ease-out 0.3s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Button ripple effect on click (micro-interaction) */
    .hero-section a.btn-primary,
    .hero-section a.btn-outline-light {
        position: relative;
        overflow: hidden;
    }
    .hero-section a.btn-primary::after,
    .hero-section a.btn-outline-light::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .hero-section a.btn-primary:active::after,
    .hero-section a.btn-outline-light:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    #ftco-navbar .nav-link:focus-visible,
    .hero-section a:focus-visible,
    .coin-box:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 8px;
    }

    /* 4. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Coin box hover effect */
    .coin-box {
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .coin-box:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
    }

    /* 6. Navbar brand hover effect */
    #ftco-navbar .navbar-brand:hover {
        text-shadow: 0 0 6px rgba(255,215,0,0.5);
        transition: text-shadow 0.2s;
    }

    /* 7. Responsive touch improvements */
    @media (max-width: 991px) {
        .user-split-section .row {
            flex-direction: column;
        }
        .user-bg-left {
            padding: 40px 20px !important;
            min-height: auto !important;
            background: var(--gradient-primary) !important;
        }
        .user-details-side {
            padding: 20px !important;
        }
        .user-details {
            padding: 20px !important;
            width: 100%;
        }
        .hero-section h1 {
            font-size: 2rem;
        }
        .hero-section p {
            font-size: 1rem;
        }
        /* Fix: Don't make profile image 300px on mobile */
        .user-bg-left img {
            width: 130px !important;
            height: 130px !important;
            margin-bottom: 20px !important;
        }
        .instagram-stats {
            gap: 20px !important;
            justify-content: center !important;
        }
    }

    @media (max-width: 480px) {
        .hero-section h1 {
            font-size: 1.6rem;
        }
        .hero-section p {
            font-size: 0.9rem;
            padding: 0 15px;
        }
        .hero-section a.btn-primary,
        .hero-section a.btn-outline-light {
            padding: 8px 16px;
            font-size: 0.9rem;
        }
        .coin-box {
            font-size: 14px;
            padding: 8px;
        }
        .instagram-stats {
            gap: 15px !important;
            justify-content: space-around;
        }
        .user-details h2 {
            font-size: 1.5rem;
        }
    }

    /* 8. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .coin-box.skeleton {
        background: linear-gradient(90deg, #e0e0e0 25%, #d0d0d0 50%, #e0e0e0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
    .profile-back-btn {
        background: #fff;
        color: var(--primary-purple) !important;
        border: 2px solid var(--primary-purple);
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
        transition: all 0.25s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }
    .profile-back-btn:hover {
        background: rgba(30, 27, 75, 0.08);
        color: var(--primary-purple) !important;
        border-color: var(--brand-pink);
        transform: translateY(-1px);
    }

    .profile-back-btn .back-label-short {
        display: none;
    }

    /* Profile page layout */
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
                <c:set var="userPUrl" value="${user.profilePhoto}" />
                <c:choose>
                    <c:when test="${not empty userPUrl}">
                        <c:if test="${not fn:startsWith(userPUrl, 'http') and not fn:startsWith(userPUrl, '/')}">
                            <c:set var="userPUrl" value="/uploads/${userPUrl}" />
                        </c:if>
                        <c:if test="${not fn:startsWith(userPUrl, 'http')}">
                            <c:set var="userPUrl" value="${pageContext.request.contextPath}${userPUrl}" />
                        </c:if>
                        <img src="${userPUrl}"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/default-profile.png';"
                             alt="Profile" class="profile-avatar">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/img/default-profile.png" alt="Profile" class="profile-avatar">
                    </c:otherwise>
                </c:choose>
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


  

<!-- Scripts -->
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery-migrate-3.0.1.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/popper.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/bootstrap.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.easing.1.3.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.waypoints.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.stellar.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/owl.carousel.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.magnific-popup.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/aos.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.animateNumber.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/bootstrap-datepicker.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/jquery.timepicker.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/scrollax.min.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/google-map.js"></script>
					  	<script src="${pageContext.request.contextPath}/beauty/js/main.js"></script>

</body>
					  </html>







<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>

