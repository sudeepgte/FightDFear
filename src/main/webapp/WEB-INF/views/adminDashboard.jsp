<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <!-- Purpose: load Poppins (used by this page) + Montserrat (global headings) -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
<style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        
        /* Maroon Theme Standards */
        --maroon:        #1e1b4b;
        --maroon-light:  #312e81;
        --maroon-dark:   #0b0920;
        --maroon-pale:   #f8fafc;
        --maroon-border: rgba(30, 27, 75, 0.12);
        --sidebar-w: 272px;
        
        --purple: var(--primary-purple);
        --purpleDark: var(--primary-purple-light);
    }

    body {
        font-family: 'Poppins', sans-serif;
        margin: 0;
        background: linear-gradient(180deg, var(--light-bg) 0%, #f5f5f5 100%);
        color: var(--dark-bg);
    }

    .topbar {
        background: var(--primary-purple);
        color: white;
        padding: 14px 18px;
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: var(--shadow-sm);
    }

    .topbar .wrap {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }

    .topbar .title {
        font-size: 1.25rem;
        margin: 0;
    }

    .topbar .meta {
        font-size: 0.95rem;
        opacity: 0.95;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .content {
        padding: 28px 16px 36px;
    }

    .layout {
        display: flex;
        min-height: calc(100vh - 0px);
    }

    .sidebar {
        width: var(--sidebar-w); background:#fff;
        border-right:1px solid var(--maroon-border);
        position:sticky; top:58px; height:calc(100vh - 58px);
        padding:14px 12px; overflow-y:auto; flex-shrink:0;
        transition: all 0.3s ease;
    }
    .brand { font-size: 0.9rem; font-weight: 700; color: var(--maroon); padding: 10px 15px; text-transform: uppercase; letter-spacing: 1px; }
    .sectionTitle { font-size: 0.7rem; font-weight: 700; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em; margin: 20px 15px 8px; }
    .navlink {
        display: flex; align-items: center; gap: 12px; padding: 10px 15px; border-radius: 12px;
        color: #4b5563; text-decoration: none; font-weight: 500; font-size: 0.9rem; transition: all 0.2s; margin-bottom: 2px;
    }
    .navlink i { width: 20px; text-align: center; color: var(--maroon); font-size: 1rem; }
    .navlink:hover { background: var(--maroon-pale); color: var(--maroon); padding-left: 20px; }
    .navlink.active { background: var(--maroon); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(125,42,90,0.2); }
    .navlink.active i { color: #fff; }

    .main {
        flex: 1;
        min-width: 0;
    }

    .mainInner {
        max-width: 1100px;
        margin: 0 auto;
    }

    .admin-card {
        background-color: white;
        border-radius: 14px;
        padding: 18px;
        box-shadow: var(--shadow-sm);
        margin-bottom: 20px;
        transition: transform 0.2s ease, box-shadow 0.2s;
        border: 1px solid rgba(123, 44, 191, 0.18);
        height: 100%;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .admin-card .rowTop {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 10px;
    }

    .admin-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-md);
    }

    .admin-card i {
        font-size: 2.5rem;
        color: var(--primary-purple-light);
        margin-bottom: 10px;
    }

    .btn-purple {
        background-color: var(--primary-purple);
        color: white;
        border: none;
        padding: 10px 16px;
        border-radius: 6px;
        transition: all 0.2s;
    }

    .btn-purple:hover {
        background-color: var(--primary-purple-light);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .badge-pill {
        font-size: 0.85rem;
        padding: 6px 10px;
        border-radius: 999px;
    }

    .muted {
        color: rgba(74, 14, 120, 0.6);
        font-size: 0.95rem;
        margin: 0;
    }

    @media (max-width: 992px) {
        .layout {
            flex-direction: column;
        }
        .sidebar {
            position: fixed;
            left: -100%;
            top: 0;
            bottom: 0;
            z-index: 2000;
            width: 280px;
            height: 100vh;
            transition: left 0.3s ease;
            box-shadow: 10px 0 30px rgba(0,0,0,0.2);
            background: #fff;
            padding: 20px;
        }
        .sidebar.active {
            left: 0;
        }
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 1500;
            backdrop-filter: blur(2px);
        }
        .sidebar-overlay.active {
            display: block;
        }
    }

    .mobile-toggle {
        display: none;
        background: none;
        border: none;
        color: white;
        font-size: 1.25rem;
        cursor: pointer;
        padding: 5px;
        margin-right: 15px;
        transition: transform 0.2s;
    }
    .mobile-toggle:hover { transform: scale(1.1); }
    @media (max-width: 992px) { .mobile-toggle { display: block; } }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for main content */
    .mainInner {
        animation: slideUpFade 0.4s ease-out forwards;
    }
    @keyframes slideUpFade {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Sidebar link hover effect – add icon scale and underline */
    .sidebar a.navlink {
        transition: all 0.2s cubic-bezier(0.2, 0.9, 0.4, 1.1);
    }
    .sidebar a.navlink i {
        transition: transform 0.2s;
    }
    .sidebar a.navlink:hover i {
        transform: scale(1.1);
        color: var(--primary-purple-light);
    }
    .sidebar a.navlink:hover {
        padding-left: 16px;
        background: linear-gradient(90deg, rgba(123,44,191,0.08), transparent);
    }

    /* 3. Topbar subtle gradient animation on hover */
    .topbar {
        transition: background 0.3s;
    }
    .topbar:hover {
        background: linear-gradient(135deg, var(--primary-purple), var(--primary-purple-light));
    }

    /* 4. Admin-card icon hover scaling */
    .admin-card i {
        transition: transform 0.2s;
    }
    .admin-card:hover i {
        transform: scale(1.1);
        filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1));
    }

    /* 5. Button ripple effect on click (micro-interaction) */
    .btn-purple {
        position: relative;
        overflow: hidden;
    }
    .btn-purple::after {
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
    }
    .btn-purple:active::after {
        width: 200px;
        height: 200px;
    }

    /* 6. Focus outlines for accessibility (keyboard navigation) */
    .btn-purple:focus-visible,
    .sidebar a.navlink:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 7. Custom scrollbar for sidebar and main content */
    ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
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

    /* 8. Admin-card border glow on hover */
    .admin-card {
        transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
    }
    .admin-card:hover {
        border-color: var(--primary-purple-light);
    }

    /* 9. Badge pill styling enhancement (add subtle shadow) */
    .badge-pill {
        background: rgba(123, 44, 191, 0.1);
        color: var(--primary-purple);
        font-weight: 600;
        transition: all 0.2s;
    }
    .badge-pill:hover {
        background: rgba(123, 44, 191, 0.2);
        transform: scale(1.02);
    }
    .reported-videos-link {
        cursor: pointer;
        padding: 6px 12px;
    }
    .reported-videos-link:hover {
        background: #fff !important;
        color: var(--primary-purple) !important;
    }

    /* 10. Responsive touch target improvements for mobile */
    @media (max-width: 768px) {
        .btn-purple {
            padding: 12px 20px;
            font-size: 0.9rem;
        }
        .sidebar a.navlink {
            padding: 12px 14px;
        }

        /* ── Topbar mobile ── */
        .topbar { padding: 10px 12px; }
        .topbar .title { font-size: 1rem; }
        .topbar .meta { gap: 6px; }
        .topbar .meta .badge-pill { font-size: 0.7rem; padding: 4px 8px; }

        /* ── Content padding ── */
        .content { padding: 16px 8px 24px; }

        /* ── Analytics wrapper card ── */
        .col-12.mb-4 > div { padding: 16px !important; border-radius: 14px !important; }

        /* ── Override inline-style stat grids to 3 cols on phone ── */
        .col-12.mb-4 div[style*="display:grid"] {
            grid-template-columns: repeat(3, 1fr) !important;
            gap: 8px !important;
        }
        .col-12.mb-4 div[style*="padding:18px"] {
            padding: 12px 8px !important;
            border-radius: 10px !important;
        }
        .col-12.mb-4 div[style*="font-size:1.6rem"] {
            font-size: 1.2rem !important;
        }
        .col-12.mb-4 div[style*="font-size:0.75rem"] {
            font-size: 0.65rem !important;
        }
        .col-12.mb-4 h6 {
            font-size: 0.7rem !important;
            margin-bottom: 10px !important;
        }

        /* ── Admin cards – 2 columns on phone ── */
        .row.g-3 > [class*="col-md-3"] {
            flex: 0 0 50%;
            max-width: 50%;
            padding-left: 6px;
            padding-right: 6px;
        }
        .row.g-3 { margin-left: -6px; margin-right: -6px; }

        .admin-card { 
            padding: 14px 12px; 
            border-radius: 12px;
            gap: 8px;
        }
        .admin-card .rowTop { flex-wrap: wrap; }
        .admin-card h5 { font-size: 0.85rem; line-height: 1.2; }
        .admin-card .muted { font-size: 0.72rem; }
        .admin-card i { font-size: 1.8rem; margin-bottom: 6px; }
        .admin-card .btn { 
            padding: 8px 10px; 
            font-size: 0.78rem; 
        }
        .admin-card .badge-pill { font-size: 0.65rem; padding: 3px 7px; }

        /* ── Full-width col (analytics) ── */
        .col-12.mb-4 { padding-left: 6px; padding-right: 6px; }
    }


    /* ── Very small phones (< 400px) ── */
    @media (max-width: 400px) {
        .row.g-3 > [class*="col-md-3"] {
            flex: 0 0 50%;
            max-width: 50%;
            padding-left: 4px;
            padding-right: 4px;
        }
        .admin-card { padding: 10px 8px; gap: 6px; }
        .admin-card h5 { font-size: 0.78rem; }
        .admin-card i { font-size: 1.5rem; margin-bottom: 4px; }
        .admin-card .btn { padding: 6px 8px; font-size: 0.72rem; }
        .content { padding: 10px 4px 20px; }

        /* ── Analytics stat grids shrink further ── */
        .col-12.mb-4 div[style*="display:grid"] {
            grid-template-columns: repeat(3, 1fr) !important;
            gap: 6px !important;
        }
        .col-12.mb-4 div[style*="font-size:1.6rem"] {
            font-size: 1rem !important;
        }
        .col-12.mb-4 div[style*="font-size:0.75rem"] {
            font-size: 0.58rem !important;
        }
        .col-12.mb-4 div[style*="padding:18px"] {
            padding: 8px 4px !important;
        }
        .col-12.mb-4 > div { padding: 12px 8px !important; }

        /* ── Topbar compact ── */
        .topbar .title { font-size: 0.88rem; }
        .topbar .meta .badge-pill { display: none; }
    }


    /* ── Tablets (md breakpoint) ── */
    @media (min-width: 769px) and (max-width: 992px) {
        .row.g-3 > [class*="col-md-3"] {
            flex: 0 0 33.333%;
            max-width: 33.333%;
        }
        .content { padding: 20px 12px 30px; }
    }

    /* 11. Loading skeleton ready (optional, does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .admin-card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
    /* SaaS Dashboard Card Overrides */
    div[style*="background: white"], 
    div[style*="background:white"] {
        background-color: #ffffff !important;
        border-radius: 20px !important;
        border: 1px solid rgba(30, 27, 75, 0.08) !important;
        box-shadow: 0 10px 30px rgba(0,0,0,0.02) !important;
    }
    
    div[style*="display:grid"] > div, 
    div[style*="display: grid"] > div {
        background: #ffffff !important;
        border: 1px solid rgba(30, 27, 75, 0.08) !important;
        border-radius: 16px !important;
        padding: 20px 16px !important;
        text-align: center !important;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.01) !important;
        transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1) !important;
    }
    
    div[style*="display:grid"] > div:hover, 
    div[style*="display: grid"] > div:hover {
        transform: translateY(-4px) !important;
        box-shadow: 0 12px 25px rgba(244, 63, 94, 0.08) !important;
        border-color: rgba(244, 63, 94, 0.2) !important;
    }
    
    div[style*="font-size:1.6rem"], 
    div[style*="font-size:1.2rem"] {
        font-size: 2rem !important;
        font-weight: 800 !important;
        color: var(--primary-purple) !important;
        margin-bottom: 6px !important;
    }
    
    div[style*="font-size:0.75rem"] {
        font-size: 0.78rem !important;
        color: #64748b !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
    }
    
    div[style*="color:#C53030"] { color: var(--primary-coral) !important; }
    div[style*="color:#2F855A"] { color: #10b981 !important; }
    div[style*="color:#2B6CB0"] { color: #3b82f6 !important; }
    div[style*="color:#6B46C1"] { color: var(--primary-purple-light) !important; }
    div[style*="color:#2D3748"] { color: var(--primary-purple) !important; }
    div[style*="color:#E53E3E"] { color: #ef4444 !important; }
    div[style*="color:#4A5568"] { color: #64748b !important; }
    div[style*="color:#D97706"] { color: #f59e0b !important; }
    div[style*="color:#276749"] { color: #10b981 !important; }
    div[style*="color:#7C2D5E"] { color: var(--primary-coral) !important; }
    
    h6[style*="color: #7C2D5E"], 
    h6[style*="color:#7C2D5E"] {
        color: var(--primary-purple) !important;
        font-weight: 700 !important;
        text-transform: uppercase !important;
        font-size: 0.82rem !important;
        letter-spacing: 1px !important;
    }
</style>
    
</head>
<body>

    <!-- Topbar -->
    <div class="topbar">
        <div class="container">
            <div class="wrap">
                <div class="d-flex align-items-center">
                    <button class="mobile-toggle" id="sidebarToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <p class="title mb-0">Fight D Fear Admin Dashboard</p>
                </div>
                <div class="meta">

                    <a href="${pageContext.request.contextPath}/admin/reported-videos" class="badge bg-light text-dark badge-pill text-decoration-none reported-videos-link" title="View reported videos">
                        Reported Videos: <span id="reportedVideos">-</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Sidebar Overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Content -->
    <div class="layout">
        <!-- Sidebar -->
        <%@ include file="globalAdminMenu.jsp" %>


        <!-- Main -->
        <main class="main">
            <div class="content">
                <div class="container mainInner">
                    <div class="row justify-content-center g-3">

                <!-- ── Categorized Analytics ── -->
                <div class="col-12 mb-4">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        
                        <!-- Row 1: Safety -->
                        <div class="mb-4">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-shield-alt"></i> Safety & Emergency
                            </h6>
                            <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                                <div style="background:#FFF5F5; border-radius:15px; padding:18px; border:1px solid #FED7D7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#C53030;" id="stat-activeSos">—</div>
                                    <div style="font-size:0.75rem; color:#9B2C2C; font-weight:600;">🚨 Active SOS Alerts</div>
                                </div>

                                <div style="background:#EBF8FF; border-radius:15px; padding:18px; border:1px solid #BEE3F8; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#2B6CB0;" id="stat-safeRoutes">—</div>
                                    <div style="font-size:0.75rem; color:#2C5282; font-weight:600;">📍 Verified Routes</div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 2: Partners -->
                        <div class="mb-4">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-handshake"></i> Verified Partners
                            </h6>
                            <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                                <div style="background:#FAF5FF; border-radius:15px; padding:18px; border:1px solid #E9D8FD; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#6B46C1;" id="stat-verifiedDoctors">—</div>
                                    <div style="font-size:0.75rem; color:#553C9A; font-weight:600;">👨‍⚕️ Verified Doctors</div>
                                </div>
                                <div style="background:#FAF5FF; border-radius:15px; padding:18px; border:1px solid #E9D8FD; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#6B46C1;" id="stat-verifiedSalons">—</div>
                                    <div style="font-size:0.75rem; color:#553C9A; font-weight:600;">✂️ Verified Salons</div>
                                </div>
                                <div style="background:#FAF5FF; border-radius:15px; padding:18px; border:1px solid #E9D8FD; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#6B46C1;" id="stat-verifiedStylists">—</div>
                                    <div style="font-size:0.75rem; color:#553C9A; font-weight:600;">💇 Verified Stylists</div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: Users -->
                        <div>
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-users"></i> Platform Community
                            </h6>
                            <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                                <div style="background:#EDF2F7; border-radius:15px; padding:18px; border:1px solid #E2E8F0; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#2D3748;" id="stat-totalUsers">—</div>
                                    <div style="font-size:0.75rem; color:#4A5568; font-weight:600;">👥 Total Users</div>
                                </div>
                                <div style="background:#FFF5F5; border-radius:15px; padding:18px; border:1px solid #FED7D7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#E53E3E;" id="stat-bannedUsers">—</div>
                                    <div style="font-size:0.75rem; color:#9B2C2C; font-weight:600;">🚫 Banned Accounts</div>
                                </div>
                                <div style="background:#F7FAFC; border-radius:15px; padding:18px; border:1px solid #EDF2F7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#4A5568;" id="stat-pendingUsers">—</div>
                                    <div style="font-size:0.75rem; color:#718096; font-weight:600;">🆕 New Registrations</div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 4: Entrepreneur & Investor Platform (Community) -->
                        <div class="mt-4">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-handshake"></i> Entrepreneur & Investor Community
                            </h6>
                            <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                                <div style="background:#FFFDF5; border-radius:15px; padding:18px; border:1px solid #FEF3C7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#D97706;" id="stat-totalEntrepreneurs">—</div>
                                    <div style="font-size:0.75rem; color:#92400E; font-weight:600;">👩‍💼 Total Entrepreneurs</div>
                                </div>
                                <div style="background:#FFFDF5; border-radius:15px; padding:18px; border:1px solid #FEF3C7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#D97706;" id="stat-totalInvestors">—</div>
                                    <div style="font-size:0.75rem; color:#92400E; font-weight:600;">💼 Total Investors</div>
                                </div>
                                <div style="background:#FFFDF5; border-radius:15px; padding:18px; border:1px solid #FEF3C7; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#D97706;" id="stat-totalProposals">—</div>
                                    <div style="font-size:0.75rem; color:#92400E; font-weight:600;">📈 Total Proposals</div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 5: Entrepreneur & Investor Platform (Financials) -->
                        <div class="mt-4">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-wallet"></i> Investment & Platform Revenue
                            </h6>
                            <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                                <div style="background:#F0FFF4; border-radius:15px; padding:18px; border:1px solid #C6F6D5; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#276749;" id="stat-capitalRequested">—</div>
                                    <div style="font-size:0.75rem; color:#2F855A; font-weight:600;">💰 Capital Requested</div>
                                </div>
                                <div style="background:#F0FFF4; border-radius:15px; padding:18px; border:1px solid #C6F6D5; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#276749;" id="stat-capitalInvested">—</div>
                                    <div style="font-size:0.75rem; color:#2F855A; font-weight:600;">🤝 Capital Funded</div>
                                </div>
                                <div style="background:#FAF5FF; border-radius:15px; padding:18px; border:1px solid #E9D8FD; text-align:center;">
                                    <div style="font-size:1.6rem; font-weight:700; color:#6B46C1;" id="stat-platformRevenue">—</div>
                                    <div style="font-size:0.75rem; color:#553C9A; font-weight:600;">💎 Platform Revenue</div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- ── End Categorized Analytics ── -->

                <!-- Row 6: Women Events Platform -->
                <div class="col-12 mb-4">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin: 0;">
                                <i class="bi bi-calendar-heart-fill"></i> Women Events Platform
                            </h6>
                            <a href="${pageContext.request.contextPath}/admin/pending-event-hosts"
                               class="btn btn-sm" style="background: #1e1b4b; color: #fff; border-radius: 20px; font-weight: 600;">
                                Approve Organizers / Events
                            </a>
                        </div>
                        <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:15px;">
                            <div style="background:#fdf5ff; border-radius:15px; padding:18px; border:1px solid #e9d8fd; text-align:center;">
                                <div style="font-size:1.6rem; font-weight:700; color:#1e1b4b;" id="stat-totalWomenEvents">—</div>
                                <div style="font-size:0.75rem; color:#6B46C1; font-weight:600;">🌸 Total Events</div>
                            </div>
                            <div style="background:#f0fdf4; border-radius:15px; padding:18px; border:1px solid #C6F6D5; text-align:center;">
                                <div style="font-size:1.6rem; font-weight:700; color:#276749;" id="stat-approvedWomenEvents">—</div>
                                <div style="font-size:0.75rem; color:#2F855A; font-weight:600;">✅ Approved Events</div>
                            </div>
                            <div style="background:#fffbeb; border-radius:15px; padding:18px; border:1px solid #fde68a; text-align:center;">
                                <div style="font-size:1.6rem; font-weight:700; color:#92400e;" id="stat-pendingWomenEvents">—</div>
                                <div style="font-size:0.75rem; color:#b45309; font-weight:600;">⏳ Pending Review</div>
                            </div>
                            <div style="background:#edf2f7; border-radius:15px; padding:18px; border:1px solid #cbd5e1; text-align:center;">
                                <div style="font-size:1.6rem; font-weight:700; color:#475569;" id="stat-totalEventBookings">—</div>
                                <div style="font-size:0.75rem; color:#64748b; font-weight:600;">🎟️ Ticket Bookings</div>
                            </div>
                            <div style="background:#ecfdf5; border-radius:15px; padding:18px; border:1px solid #a7f3d0; text-align:center;">
                                <div style="font-size:1.6rem; font-weight:700; color:#047857;" id="stat-totalEventTicketRevenue">—</div>
                                <div style="font-size:0.75rem; color:#065f46; font-weight:600;">💳 Ticket Revenue</div>
                            </div>
                            <div style="background:#fff7ed; border-radius:15px; padding:18px; border:1px solid #ffedd5; text-align:center; overflow: hidden;">
                                <div style="font-size:1.2rem; font-weight:700; color:#c2410c; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" id="stat-mostPopularEvent">—</div>
                                <div style="font-size:0.75rem; color:#9a3412; font-weight:600;">🏆 Popular Event</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent contact form messages -->
                <div class="col-12 mb-4">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin: 0;">
                                <i class="fas fa-envelope"></i> Recent Contact Messages
                            </h6>
                            <a href="${pageContext.request.contextPath}/admin/contact-messages" class="btn btn-sm" style="background: #1e1b4b; color: #fff; border-radius: 20px; font-weight: 600;">
                                View all
                                <c:if test="${unreadContactMessages > 0}">
                                    <span class="badge bg-danger ms-1">${unreadContactMessages} new</span>
                                </c:if>
                            </a>
                        </div>
                        <c:choose>
                            <c:when test="${not empty recentContactMessages}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" style="font-size: 0.9rem;">
                                        <thead>
                                            <tr style="color: #1e1b4b;">
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Subject</th>
                                                <th>Sent</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cm" items="${recentContactMessages}">
                                                <tr style="${cm.readByAdmin ? '' : 'background:#fff5f8;'}">
                                                    <td><strong>${cm.name}</strong></td>
                                                    <td>${cm.email}</td>
                                                    <td>${cm.subject}</td>
                                                    <td style="white-space:nowrap;">${cm.submittedAt}</td>
                                                    <td>
                                                        <c:if test="${!cm.readByAdmin}"><span class="badge bg-danger">New</span></c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mb-0 small">No contact form submissions yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Recent Entrepreneur & Investor Activity Feed -->
                <div class="col-12 mb-4">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                            <h6 style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; margin: 0;">
                                <i class="fas fa-history"></i> Recent Entrepreneur & Investor Platform Feed
                            </h6>
                            <a href="${pageContext.request.contextPath}/admin/pending-proposals" class="btn btn-sm" style="background: #1e1b4b; color: #fff; border-radius: 20px; font-weight: 600;">
                                Audit Console
                            </a>
                        </div>
                        <c:choose>
                            <c:when test="${not empty recentPlatformActivities}">
                                <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                    <table class="table table-hover align-middle mb-0" style="font-size: 0.9rem;">
                                        <thead>
                                            <tr style="color: #1e1b4b;">
                                                <th style="width: 50px;">Activity</th>
                                                <th>Description</th>
                                                <th style="width: 180px;">Time Exchanged</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="act" items="${recentPlatformActivities}">
                                                <tr>
                                                    <td class="text-center"><i class="bi ${act.icon} fs-5"></i></td>
                                                    <td>${act.desc}</td>
                                                    <td class="text-muted small">${act.time}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mb-0 small">No transactions, meetings, messages, or questions exchanged on the platform yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-envelope" style="color: #1e1b4b;"></i>
                                <h5 class="mb-1">Contact Messages</h5>
                                <p class="muted">Form submissions from site</p>
                            </div>
                            <c:if test="${unreadContactMessages > 0}">
                                <span class="badge bg-danger badge-pill">${unreadContactMessages}</span>
                            </c:if>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/contact-messages" class="btn btn-purple w-100 mt-auto">Open Inbox</a>
                    </div>
                </div>



                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-user"></i>
                                <h5 class="mb-1">Your Profile</h5>
                                <p class="muted">Manage admin account</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/profile/${admin.id}" class="btn btn-purple w-100 mt-auto">Open</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card" style="border-top: 4px solid #ff3b3b;">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-broadcast-tower" style="color: #ff3b3b;"></i>
                                <h5 class="mb-1">SOS Alerts</h5>
                                <p class="muted">Live emergency monitoring</p>
                            </div>
                            <div class="count" id="activeSosCount" style="color: #ff3b3b; font-weight: 700; font-size: 1.2rem;">0</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/sos" class="btn btn-danger w-100 mt-auto">Monitor Live</a>
                    </div>
                </div>



                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-user-friends"></i>
                                <h5 class="mb-1">Buddy Oversight</h5>
                                <p class="muted">Live journey monitoring</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/buddy-management" class="btn btn-purple w-100 mt-auto">Monitor</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-shield-alt"></i>
                                <h5 class="mb-1">Safety Verification</h5>
                                <p class="muted">Danger points & routes</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/safety-points" class="btn btn-purple w-100 mt-auto">Verify</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-cut"></i>
                                <h5 class="mb-1">Salon Verification</h5>
                                <p class="muted">Vetting beauty centers</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/salons" class="btn btn-purple w-100 mt-auto">Verify</a>
                    </div>
                </div>
                

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-users"></i>
                                <h5 class="mb-1">Volunteers</h5>
                                <p class="muted">Suggestions + management</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending suggestions">
                                <span id="pendingSuggestions">-</span>
                            </span>
                        </div>
                        <div class="d-grid gap-2 mt-auto">
                            <a href="${pageContext.request.contextPath}/admin/pending-suggestions" class="btn btn-purple w-100">Suggestions</a>
                            <a href="${pageContext.request.contextPath}/admin/volunteer-management" class="btn btn-outline-secondary w-100">Management</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-dumbbell"></i>
                                <h5 class="mb-1">Martial Arts</h5>
                                <p class="muted">Approve centres</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending centres">
                                <span id="pendingCentres">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/martialManagement" class="btn btn-purple w-100 mt-auto">Review</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-video"></i>
                                <h5 class="mb-1">Video Library</h5>
                                <p class="muted">Martial arts videos</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/video/videoManagement" class="btn btn-purple w-100 mt-auto">View All</a>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-book"></i>
                                <h5 class="mb-1">Financial Literacy</h5>
                                <p class="muted">Manage learning content</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin" class="btn btn-purple w-100 mt-auto">Manage</a>
                    </div>
                </div>

 <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-film"></i>
                                <h5 class="mb-1">Reels Rewards</h5>
                                <p class="muted">Top content scoring</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-purple w-100 mt-auto">View</a>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-mobile-alt"></i>
                                <h5 class="mb-1">User Reels Management</h5>
                                <p class="muted">Moderate user uploads</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/user-reels" class="btn btn-purple w-100 mt-auto">Moderate Reels</a>
                    </div>
                </div>

                 <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-flag"></i>
                                <h5 class="mb-1">Reported Videos</h5>
                                <p class="muted">Moderation queue</p>
                            </div>
                            <span class="badge bg-danger badge-pill" title="Reported videos">
                                <span id="reportedVideosCardCount">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/reported-videos" class="btn btn-purple w-100 mt-auto">View</a>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-question-circle"></i>
                                <h5 class="mb-1">Q&A Panel</h5>
                                <p class="muted">Moderate questions</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/qna/admin/questions" class="btn btn-purple w-100 mt-auto">Manage</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-user-md"></i>
                                <h5 class="mb-1">Doctor Verification</h5>
                                <p class="muted">Verify medical profiles</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending doctors">
                                <span id="pendingDoctorsCount">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/pending-doctors" class="btn btn-purple w-100 mt-auto">Review</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-shopping-bag"></i>
                                <h5 class="mb-1">Women Services</h5>
                                <p class="muted">Verify service providers</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending women services">
                                <span id="pendingWomenProductsCount">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_PRODUCTS" class="btn btn-purple w-100 mt-auto">Review</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-gavel"></i>
                                <h5 class="mb-1">Women Lawyers</h5>
                                <p class="muted">Review legal providers</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_LAWYER" class="btn btn-purple w-100 mt-auto">Review Lawyers</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card" style="border-top: 4px solid #10b981;">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-dumbbell" style="color: #10b981;"></i>
                                <h5 class="mb-1">Fitness &amp; Wellness</h5>
                                <p class="muted">Verify trainer profiles</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending trainers">
                                <span id="pendingTrainersCount">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/adminDashboard#fitnessOversightTabs" class="btn btn-purple w-100 mt-auto">Review Trainers</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-shopping-cart"></i>
                                <h5 class="mb-1">Women Sellers</h5>
                                <p class="muted">Verify product sellers</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/pending-sellers" class="btn btn-purple w-100 mt-auto">Review Sellers</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-box"></i>
                                <h5 class="mb-1">Product Orders</h5>
                                <p class="muted">Track orders and stock</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/women-product-orders" class="btn btn-purple w-100 mt-auto">View Orders</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-users-cog"></i>
                                <h5 class="mb-1">User Management</h5>
                                <p class="muted">Ban, unban &amp; delete users</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-purple w-100 mt-auto">Manage</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card" style="border-top: 4px solid var(--primary-coral);">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-hand-holding-usd" style="color: var(--primary-coral);"></i>
                                <h5 class="mb-1">Proposal Verifications</h5>
                                <p class="muted">Review projects & partners</p>
                            </div>
                            <span class="badge bg-warning text-dark badge-pill" title="Pending verifications">
                                <span id="pendingVerificationsCount">-</span>
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/pending-proposals" class="btn btn-purple w-100 mt-auto">Review Proposals</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card" style="border-top: 4px solid #16a34a;">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-rupee-sign" style="color: #16a34a;"></i>
                                <h5 class="mb-1">Platform Revenue</h5>
                                <p class="muted">Track commissions & fees</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/investment-revenue" class="btn btn-purple w-100 mt-auto">View Revenue</a>
                    </div>
                </div>

                <div class="col-md-3 col-sm-6">
                    <div class="admin-card">
                        <div class="rowTop">
                            <div>
                                <i class="fas fa-sign-out-alt"></i>
                                <h5 class="mb-1">Logout</h5>
                                <p class="muted">End session</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-purple w-100 mt-auto">Logout</a>
                    </div>
                </div>

                <!-- ── Women Creator Hub Oversight ── -->
                <div class="col-12 mb-4">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        <h5 class="mb-4" style="color: #1e1b4b; font-weight: 700; text-transform: uppercase; font-size: 0.95rem; letter-spacing: 1px;">
                            <i class="fas fa-shield-halved text-danger me-2"></i> Women Creator Hub Oversight
                        </h5>

                        <ul class="nav nav-tabs mb-3" id="creatorHubTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="moder-tab" data-bs-toggle="tab" data-bs-target="#moderContent" type="button" role="tab" style="color:#1e1b4b; font-weight:600;">
                                    Moderation Queue (${moderationQueue.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="reports-tab" data-bs-toggle="tab" data-bs-target="#reportsContent" type="button" role="tab" style="color:#1e1b4b; font-weight:600;">
                                    Safety Reports (${reports.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="verify-tab" data-bs-toggle="tab" data-bs-target="#verifyContent" type="button" role="tab" style="color:#1e1b4b; font-weight:600;">
                                    Creator Badges
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="payout-tab" data-bs-toggle="tab" data-bs-target="#payoutContent" type="button" role="tab" style="color:#1e1b4b; font-weight:600;">
                                    Cashouts (${cashoutRequests.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="campaign-tab" data-bs-toggle="tab" data-bs-target="#campaignContent" type="button" role="tab" style="color:#1e1b4b; font-weight:600;">
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
                                <h6 class="text-secondary mt-2">Eligible Creators (Reward Points > 100)</h6>
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
                                            <c:forEach var="c" items="${creatorsVerificationList}">
                                                <tr>
                                                    <td>${c.fullName}</td>
                                                    <td>${c.email}</td>
                                                    <td><strong class="text-warning">${c.rewardPoints}</strong></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-warning text-dark font-weight-bold" onclick="hubBadge(${c.id}, true)">Verify & Badge</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty creatorsVerificationList}">
                                                <tr><td colspan="4" class="text-muted text-center small">No pending creators eligible.</td></tr>
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

                <!-- ── Fitness & Wellness Administration ── -->
                <div class="col-12 mb-4" id="fitnessOversightTabs">
                    <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
                        <h5 class="mb-4" style="color: #10b981; font-weight: 700; text-transform: uppercase; font-size: 0.95rem; letter-spacing: 1px;">
                            <i class="fas fa-dumbbell text-success me-2"></i> Fitness &amp; Wellness Administration
                        </h5>

                        <ul class="nav nav-tabs mb-3" id="fitnessAdminTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="fit-pending-tab" data-bs-toggle="tab" data-bs-target="#fitPendingContent" type="button" role="tab" style="color:#065f46; font-weight:600;">
                                    Trainer Approvals (${pendingTrainers.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="fit-active-tab" data-bs-toggle="tab" data-bs-target="#fitActiveContent" type="button" role="tab" style="color:#065f46; font-weight:600;">
                                    Active Trainers (${activeTrainers.size()})
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="fit-stats-tab" data-bs-toggle="tab" data-bs-target="#fitStatsContent" type="button" role="tab" style="color:#065f46; font-weight:600;">
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
                                                            <td><strong class="text-warning">★ ${t.rating}</strong></td>
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
                                                                <form action="${pageContext.request.contextPath}/admin/fitness/suspend" method="POST">
                                                                    <input type="hidden" name="id" value="${t.id}">
                                                                    <input type="hidden" name="suspend" value="${!t.suspended}">
                                                                    <button type="submit" class="btn btn-sm ${t.suspended ? 'btn-success' : 'btn-outline-danger'} py-1" style="font-size:0.8rem; border-radius:15px;">
                                                                        ${t.suspended ? 'Activate' : 'Suspend'}
                                                                    </button>
                                                                </form>
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
                </div>
            </div>
        </main>
    </div>

<script>
  (function () {
    let lastSig = null;

    function setText(id, val) {
      const el = document.getElementById(id);
      if (el) el.textContent = (val == null ? "-" : String(val));
    }

    async function refresh() {
      try {
        const res = await fetch("${pageContext.request.contextPath}/admin/dashboard.meta", {
          headers: { "Accept": "application/json" }
        });
        if (!res.ok) return;
        const data = await res.json();
        if (data.error) return;

        setText("pendingCentres", data.pendingCentres);
        setText("pendingSuggestions", data.pendingSuggestions);
        setText("reportedVideos", data.reportedVideos);
        setText("reportedVideosCardCount", data.reportedVideos);
        setText("pendingDoctorsCount", data.pendingDoctors);
        setText("pendingWomenProductsCount", data.pendingWomenProducts);
        setText("pendingTrainersCount", data.pendingTrainers);

        // Safety Row
        setText("stat-activeSos", data.totalLiveSos);
        setText("stat-safeRoutes", data.verifiedRoutes);

        // Partner Row
        setText("stat-verifiedDoctors", data.totalVerifiedDoctors);
        setText("stat-verifiedSalons", data.verifiedSalons);
        setText("stat-verifiedStylists", data.verifiedStylists);

        // User Row
        setText("stat-totalUsers", data.totalUsers);
        setText("stat-bannedUsers", data.bannedUsers);
        setText("stat-pendingUsers", data.pendingUsers);

        // Entrepreneur & Investor Platform Row (Community & Financials)
        setText("stat-totalEntrepreneurs", data.totalEntrepreneursCount);
        setText("stat-totalInvestors", data.totalInvestorsCount);
        setText("stat-totalProposals", data.totalProposalsCount);
        setText("stat-capitalRequested", "₹" + Number(data.totalCapitalRequested || 0).toLocaleString());
        setText("stat-capitalInvested", "₹" + Number(data.totalCapitalInvested || 0).toLocaleString());
        setText("stat-platformRevenue", "₹" + Number(data.totalPlatformRevenue || 0).toLocaleString());

        // Women Events Platform Row
        setText("stat-totalWomenEvents",    data.totalWomenEvents);
        setText("stat-approvedWomenEvents", data.approvedWomenEvents);
        setText("stat-pendingWomenEvents",  data.pendingWomenEvents);
        setText("stat-totalEventBookings",  data.totalEventBookings);
        setText("stat-totalEventTicketRevenue", "₹" + Number(data.totalEventTicketRevenue || 0).toLocaleString());
        setText("stat-mostPopularEvent",    data.mostPopularEvent || 'None');

        // Pending verifications card badge
        setText("pendingVerificationsCount", data.pendingProposals + data.pendingEntrepreneurs + data.pendingInvestors);

        // SOS Monitoring Badge (Sidebar)
        var sideBadge = document.getElementById("sosSideBadge");
        if (sideBadge) {
            if (data.totalLiveSos > 0) {
                sideBadge.style.display = "inline-block";
                sideBadge.textContent = data.totalLiveSos;
            } else {
                sideBadge.style.display = "none";
            }
        }

        // If signature changes, we still keep it inline-updated; no reload needed.
        lastSig = data.signature;
      } catch (e) {
        // ignore transient errors
      }
    }

    // Sidebar Toggle Logic
    const toggleBtn = document.getElementById('sidebarToggle');
    const closeBtn = document.getElementById('closeSidebar');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.getElementById('sidebarOverlay');

    if(toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.add('active');
            overlay.classList.add('active');
        });
    }

    if(closeBtn) {
        closeBtn.addEventListener('click', () => {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
        });
    }

    if(overlay) {
        overlay.addEventListener('click', () => {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
        });
    }

    refresh();
    setInterval(refresh, 5000);
  })();

  // AJAX for Creator Hub Oversight Actions
  function hubAction(videoId, approve) {
      const formData = new URLSearchParams();
      formData.append('videoId', videoId);
      formData.append('approve', approve);

      fetch('${pageContext.request.contextPath}/creator-hub/admin/approve', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: formData.toString()
      })
      .then(res => res.json())
      .then(data => {
          if (data.success) {
              alert(approve ? "Approved!" : "Blocked!");
              const row = document.getElementById('hub-moder-' + videoId);
              if (row) row.remove();
          }
      });
  }

  function hubClearReport(reportId) {
      fetch('${pageContext.request.contextPath}/creator-hub/admin/delete-reported?reportId=' + reportId, { method: 'POST' })
      .then(res => res.json())
      .then(data => {
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
          .then(res => res.json())
          .then(data => {
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
      })
      .then(res => res.json())
      .then(data => {
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
      })
      .then(res => res.json())
      .then(data => {
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

      document.querySelectorAll('#creatorHubTabs .nav-link').forEach(function(link) {
        link.classList.remove('active');
      });
      document.querySelectorAll('#creatorHubTabContents .tab-pane').forEach(function(p) {
        p.classList.remove('show', 'active');
      });

      tabBtn.classList.add('active');
      pane.classList.add('show', 'active');

      const section = document.getElementById('creatorHubTabs');
      if (section) {
        section.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }

    if (hubTab === 'campaign') {
      showCreatorHubTab('campaign-tab', 'campaignContent');
    } else if (hash === '#creatorHubTabs') {
      const section = document.getElementById('creatorHubTabs');
      if (section) {
        section.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  })();
</script>

</body>
</html>


