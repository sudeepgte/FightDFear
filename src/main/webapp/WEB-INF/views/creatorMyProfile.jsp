<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile — ${currentUser.fullName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --accent:      #F43F5E;
            --accent-soft: rgba(244,63,94,.08);
            --accent-mid:  rgba(244,63,94,.15);
            --sub:         #64748B;
            --bg:          #F8FAFC;
            --card:        #FFFFFF;
            --border:      #E2E8F0;
            --dark:        #0F172A;
            --success:     #16A34A;
            --success-bg:  #F0FDF4;
            --radius-lg:   20px;
            --radius-md:   14px;
            --radius-sm:   8px;
            --shadow:      0 2px 12px rgba(0,0,0,.06);
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body {
            background: var(--bg);
            color: var(--dark);
            font-family: 'Inter', sans-serif;
            -webkit-font-smoothing: antialiased;
            padding-bottom: 80px;
        }
        a { text-decoration: none; color: inherit; }

        /* ── TOP NAV ── */
        .top-nav {
            position: sticky; top: 80px; z-index: 200;
            background: var(--card);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between; padding: 0 24px; height: 60px;
        }
        .top-nav .brand { font-size: 17px; font-weight: 700; color: var(--accent); display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
        .top-nav .nav-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
        .icon-btn {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: var(--bg); color: var(--dark);
            border: 1px solid var(--border); cursor: pointer;
            font-size: 15px; transition: all .2s; position: relative;
        }
        .icon-btn:hover { background: var(--accent-soft); border-color: var(--accent); color: var(--accent); }
        .notif-badge {
            position: absolute; top: -4px; right: -4px;
            background: var(--accent); color: #fff;
            font-size: 10px; font-weight: 700; padding: 2px 5px;
            border-radius: 20px; min-width: 18px; text-align: center;
        }

        /* ── LAYOUT GRID ── */
        .page-wrapper {
            max-width: 1536px; /* Use full space */
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 32px;
            padding: 24px 40px;
        }
        @media (max-width: 1200px) {
            .page-wrapper { grid-template-columns: 1fr; padding: 20px; }
            .right-sidebar { display: none; }
        }
                @media (max-width: 1200px) { .top-nav {
                justify-content: flex-start;
                overflow-x: auto;
                white-space: nowrap;
                padding: 0 16px;
                gap: 15px;
                scrollbar-width: none;
            }
            .top-nav::-webkit-scrollbar { display: none; }
            .top-nav .brand { flex-shrink: 0; white-space: nowrap; }
            .top-nav .nav-actions { flex-shrink: 0; gap: 8px; }
            .top-nav .nav-actions a.icon-btn { padding: 0 10px !important; }
        }
        @media (max-width: 768px) {
            .page-wrapper { grid-template-columns: 1fr; padding: 12px 12px 90px; gap: 14px; }
            .desktop-sidebar { display: none; }
            .left-sidebar { display: none; }
        }

        /* ── CARDS ── */
        .card-box {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .card-box + .card-box { margin-top: 18px; }
        .card-header-row {
            padding: 18px 20px 14px;
            font-size: 15px; font-weight: 700;
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-header-row .see-all { font-size: 13px; font-weight: 600; color: var(--accent); }

        /* ── LEFT SIDEBAR ── */
        .left-sidebar { 
            display: flex; flex-direction: column; gap: 6px; 
            position: sticky; top: 84px; 
            height: calc(100vh - 100px);
            overflow-y: auto;
            padding-right: 10px;
        }
        /* Custom scrollbar for sidebar */
        .left-sidebar::-webkit-scrollbar { width: 4px; }
        .left-sidebar::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }
        .ls-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 18px; border-radius: var(--radius-md);
            font-size: 15px; font-weight: 600; color: var(--sub);
            transition: all .2s; cursor: pointer;
        }
        .ls-item i { font-size: 20px; width: 24px; text-align: center; }
        .ls-item:hover { background: var(--card); color: var(--dark); box-shadow: 0 2px 8px rgba(0,0,0,.04); }
        .ls-item.active { background: var(--accent-soft); color: var(--accent); }
        .ls-badge { background: var(--accent); color: #fff; font-size: 11px; padding: 2px 6px; border-radius: 12px; margin-left: auto; }

        /* ── PROFILE HEADER CARD ── */
        .profile-top {
            padding: 28px 24px 20px;
            display: flex; gap: 20px;
        }
        .avatar-wrap { position: relative; flex-shrink: 0; }
        .avatar-img {
            width: 110px; height: 110px; border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--accent);
            padding: 2px; background: var(--card);
        }
        .cam-btn {
            position: absolute; bottom: 2px; right: 2px;
            width: 30px; height: 30px; border-radius: 50%;
            background: var(--accent); color: #fff; font-size: 12px;
            display: flex; align-items: center; justify-content: center;
            border: 2px solid var(--card); cursor: pointer; transition: transform .2s;
        }
        .cam-btn:hover { transform: scale(1.1); }
        .profile-info { flex: 1; min-width: 0; }
        .name-row {
            font-size: 22px; font-weight: 800;
            display: flex; align-items: center; gap: 8px; margin-bottom: 3px;
            flex-wrap: wrap;
        }
        .verified-icon { color: var(--success); font-size: 17px; }
        .handle { color: var(--sub); font-size: 14px; margin-bottom: 6px; }
        .bio-txt { font-size: 14px; line-height: 1.6; margin-bottom: 6px; color: #334155; }
        .location-row {
            font-size: 13px; color: var(--sub);
            display: flex; align-items: center; gap: 5px; margin-bottom: 14px;
        }
        .edit-btn {
            display: inline-flex; align-items: center; gap: 6px;
            background: var(--accent-soft); color: var(--accent);
            border: 1px solid rgba(244,63,94,.25);
            padding: 7px 18px; border-radius: 24px;
            font-size: 13px; font-weight: 600; transition: all .2s;
        }
        .edit-btn:hover { background: var(--accent-mid); }

        /* ── STATS ── */
        .stats-row {
            display: grid; grid-template-columns: repeat(4,1fr);
            border-top: 1px solid var(--border);
        }
        .stat-cell {
            padding: 16px 8px; text-align: center; cursor: pointer;
            transition: background .2s;
            border-right: 1px solid var(--border);
        }
        .stat-cell:last-child { border-right: none; }
        .stat-cell:hover { background: var(--accent-soft); }
        .stat-icon { color: var(--accent); font-size: 18px; margin-bottom: 6px; }
        .stat-num { font-size: 20px; font-weight: 800; line-height: 1; margin-bottom: 4px; }
        .stat-lbl { font-size: 11px; color: var(--sub); font-weight: 500; }

        /* ── HIGHLIGHTS ── */
        .highlights-row {
            display: flex; gap: 14px; overflow-x: auto;
            padding: 16px 20px; scrollbar-width: none;
        }
        .highlights-row::-webkit-scrollbar { display: none; }
        .hl-item { display: flex; flex-direction: column; align-items: center; min-width: 64px; cursor: pointer; }
        .hl-ring {
            width: 64px; height: 64px; border-radius: 50%;
            border: 2px solid var(--border); overflow: hidden;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 6px; box-shadow: var(--shadow);
            background: var(--bg);
        }
        .hl-ring img, .hl-ring video { width: 100%; height: 100%; object-fit: cover; }
        .hl-ring.new-hl { border: 2px dashed var(--sub); background: transparent; color: var(--accent); font-size: 22px; }
        .hl-name { font-size: 11px; font-weight: 600; color: var(--dark); text-align: center; max-width: 64px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        /* ── CONTENT TABS ── */
        .tabs-row {
            display: flex; border-bottom: 1px solid var(--border);
        }
        .tab-btn {
            flex: 1; padding: 14px 0; text-align: center;
            font-size: 13px; font-weight: 600; color: var(--sub);
            border-bottom: 2px solid transparent; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 5px;
            transition: all .2s;
        }
        .tab-btn.active { color: var(--accent); border-bottom-color: var(--accent); }

        /* ── POST GRID ── */
        .post-grid { display: none; }
        .post-grid.active { display: grid; grid-template-columns: repeat(3,1fr); gap: 2px; }
        .grid-cell {
            aspect-ratio: 1; position: relative; cursor: pointer;
            background: #E2E8F0; overflow: hidden;
        }
        .grid-cell img, .grid-cell video {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .3s;
        }
        .grid-cell:hover img, .grid-cell:hover video { transform: scale(1.05); }
        .grid-cell .cell-badge {
            position: absolute; top: 6px; right: 6px;
            color: #fff; font-size: 13px;
            filter: drop-shadow(0 1px 3px rgba(0,0,0,.6));
        }
        .grid-cell:hover .cell-overlay {
            opacity: 1;
        }
        .cell-overlay {
            position: absolute; inset: 0;
            background: rgba(244,63,94,.45);
            opacity: 0; transition: opacity .2s;
            display: flex; align-items: center; justify-content: center;
            gap: 16px; color: #fff; font-size: 13px; font-weight: 700;
        }
        .cell-overlay span { display: flex; align-items: center; gap: 5px; }

        /* ── EMPTY STATE ── */
        .empty-state { display: none; padding: 50px 20px; text-align: center; }
        .empty-state.active { display: block; }
        .empty-state i { font-size: 44px; opacity: .35; color: var(--sub); margin-bottom: 14px; }
        .empty-state h5 { font-size: 17px; font-weight: 700; margin-bottom: 6px; }
        .empty-state p { font-size: 13px; color: var(--sub); }

        /* ── SIDEBAR SECTION TITLE ── */
        .s-title { font-size: 14px; font-weight: 700; padding: 16px 18px 10px; display: flex; align-items: center; justify-content: space-between; }
        .s-title a { font-size: 12px; color: var(--accent); font-weight: 600; }

        /* ── SUGGESTION CARD ── */
        .suggest-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 18px;
            transition: background .15s;
        }
        .suggest-item:hover { background: var(--bg); }
        .suggest-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            object-fit: cover; border: 2px solid var(--border); flex-shrink: 0;
        }
        .suggest-info { flex: 1; min-width: 0; }
        .suggest-name { font-size: 13px; font-weight: 600; truncate: 1; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .suggest-sub { font-size: 11px; color: var(--sub); }
        .follow-btn {
            font-size: 12px; font-weight: 700; padding: 5px 13px;
            border-radius: 20px; border: none; cursor: pointer;
            background: var(--accent); color: #fff; transition: all .2s;
            white-space: nowrap; flex-shrink: 0;
        }
        .follow-btn:hover { opacity: .85; }
        .follow-btn.following { background: var(--bg); color: var(--accent); border: 1px solid var(--accent); }

        /* ── NOTIFICATION ITEM ── */
        .notif-item {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 18px; border-bottom: 1px solid var(--border);
            transition: background .15s; cursor: pointer;
        }
        .notif-item:last-child { border-bottom: none; }
        .notif-item:hover { background: var(--bg); }
        .notif-item.unread { background: #FFF1F3; }
        .notif-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            object-fit: cover; flex-shrink: 0;
        }
        .notif-type-icon {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; flex-shrink: 0; background: var(--accent-soft); color: var(--accent);
        }
        .notif-msg { font-size: 13px; line-height: 1.4; flex: 1; }
        .notif-msg strong { color: var(--accent); }
        .notif-time { font-size: 11px; color: var(--sub); white-space: nowrap; margin-top: 3px; }
        .notif-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--accent); margin-top: 5px; flex-shrink: 0; }

        /* ── CHAT ── */
        .chat-panel {
            position: fixed; bottom: 0; right: 0;
            width: 340px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px 16px 0 0;
            box-shadow: 0 -4px 20px rgba(0,0,0,.1);
            z-index: 300;
            transition: height .3s ease;
            height: 52px; /* collapsed by default */
            overflow: hidden;
            display: flex; flex-direction: column;
        }
        .chat-panel.open { height: 480px; }
        .chat-header {
            padding: 14px 16px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 10px; cursor: pointer;
            background: var(--card); flex-shrink: 0;
        }
        .chat-header-title { font-size: 14px; font-weight: 700; flex: 1; }
        .chat-header-badge {
            background: var(--accent); color: #fff;
            font-size: 11px; font-weight: 700; padding: 2px 7px;
            border-radius: 20px;
        }
        .chat-friends-list {
            flex: 1; overflow-y: auto; display: none; flex-direction: column;
        }
        .chat-panel.open .chat-friends-list { display: flex; }
        .chat-friend-item {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 16px; cursor: pointer; transition: background .15s;
        }
        .chat-friend-item:hover { background: var(--bg); }
        .friend-avatar {
            width: 42px; height: 42px; border-radius: 50%;
            object-fit: cover; position: relative; flex-shrink: 0;
        }
        .online-dot {
            width: 10px; height: 10px; border-radius: 50%;
            background: #22c55e; border: 2px solid var(--card);
            position: absolute; bottom: 1px; right: 1px;
        }
        .friend-name { font-size: 13px; font-weight: 600; }
        .friend-sub { font-size: 11px; color: var(--sub); }
        .chat-window {
            position: fixed; bottom: 0; right: 350px;
            width: 320px; height: 450px;
            background: var(--card); border: 1px solid var(--border);
            border-radius: 16px 16px 0 0;
            box-shadow: 0 -4px 20px rgba(0,0,0,.1);
            z-index: 299; display: none; flex-direction: column;
        }
        .chat-window.open { display: flex; }
        .chat-win-header {
            padding: 12px 14px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 8px; flex-shrink: 0;
        }
        .chat-win-avatar { width: 34px; height: 34px; border-radius: 50%; object-fit: cover; }
        .chat-win-name { font-size: 13px; font-weight: 700; flex: 1; }
        .chat-messages { flex: 1; overflow-y: auto; padding: 14px; display: flex; flex-direction: column; gap: 8px; }
        .msg-bubble {
            max-width: 80%; padding: 9px 13px;
            border-radius: 16px; font-size: 13px; line-height: 1.4;
            word-break: break-word;
        }
        .msg-bubble.mine {
            background: var(--accent); color: #fff; align-self: flex-end;
            border-radius: 16px 16px 4px 16px;
        }
        .msg-bubble.theirs {
            background: var(--bg); color: var(--dark); align-self: flex-start;
            border-radius: 16px 16px 16px 4px;
        }
        .chat-input-row {
            padding: 10px 12px; border-top: 1px solid var(--border);
            display: flex; gap: 8px; flex-shrink: 0;
        }
        .chat-input {
            flex: 1; border: 1px solid var(--border); border-radius: 24px;
            padding: 8px 14px; font-size: 13px; outline: none;
            background: var(--bg);
        }
        .chat-input:focus { border-color: var(--accent); }
        .send-btn {
            width: 36px; height: 36px; border-radius: 50%;
            background: var(--accent); color: #fff; border: none;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 14px; transition: transform .2s;
        }
        .send-btn:hover { transform: scale(1.1); }

        /* ── NOTIFICATION PANEL ── */
        .notif-panel {
            position: fixed; top: 60px; right: 20px;
            width: 360px; max-height: 500px;
            background: var(--card); border: 1px solid var(--border);
            border-radius: var(--radius-lg); box-shadow: 0 8px 30px rgba(0,0,0,.12);
            z-index: 250; display: none; flex-direction: column;
            overflow: hidden;
        }
        .notif-panel.open { display: flex; }
        .notif-panel-header {
            padding: 16px 18px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            font-size: 15px; font-weight: 700;
        }
        .notif-panel-body { overflow-y: auto; max-height: 420px; }
        .mark-read-btn { font-size: 12px; color: var(--accent); cursor: pointer; font-weight: 600; }

        /* ── BOTTOM NAV (mobile) ── */
        .bottom-nav {
            position: fixed; bottom: 0; left: 0; width: 100%;
            background: var(--card); border-top: 1px solid var(--border);
            display: none; justify-content: space-around; align-items: center;
            padding: 10px 0 14px; z-index: 200;
        }
        @media (max-width: 768px) { .bottom-nav { display: flex; } }
        .bn-link {
            display: flex; flex-direction: column; align-items: center;
            color: var(--sub); font-size: 10px; font-weight: 600; gap: 3px;
        }
        .bn-link i { font-size: 20px; }
        .bn-link.active { color: var(--accent); }
        .bn-add {
            width: 48px; height: 48px; border-radius: 50%;
            background: var(--accent); color: #fff; margin-top: -8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; box-shadow: 0 4px 12px rgba(244,63,94,.4);
        }

        /* ── MISC UTILITIES ── */
        .separator { height: 1px; background: var(--border); margin: 0 18px; }
        .desktop-only { display: block; }
        @media (max-width: 576px) {
            .desktop-only { display: none !important; }
            .profile-top { flex-direction: column; align-items: center; text-align: center; }
            .stats-row { grid-template-columns: repeat(2,1fr); }
            .stat-cell:nth-child(2) { border-right: 1px solid var(--border); }
            .stat-cell:nth-child(3), .stat-cell:nth-child(4) { border-top: 1px solid var(--border); }
            .name-row { justify-content: center; }
            .location-row { justify-content: center; }
            .chat-panel { width: 100%; border-radius: 0; }
            .chat-window { width: 100%; right: 0; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="padding: 0; min-height: 100vh; background: var(--bg); flex: 1; min-width: 0; width: auto;" data-skip-global-back="true">

<!-- ══════════════════ TOP NAV ══════════════════ -->
<nav class="top-nav">
    <a href="${pageContext.request.contextPath}/creator-hub" class="brand">
        <i class="fa-solid fa-clapperboard"></i> Creator Hub
    </a>
    
    <!-- Search Bar -->
    <div style="flex:1; max-width:400px; margin:0 24px; position:relative;" class="desktop-only">
        <i class="fa-solid fa-magnifying-glass" style="position:absolute; left:16px; top:50%; transform:translateY(-50%); color:var(--sub); font-size:14px;"></i>
        <input type="text" placeholder="Search creators, reels, posts..." style="width:100%; background:var(--bg); border:1px solid var(--border); padding:10px 16px 10px 40px; border-radius:24px; outline:none; font-size:14px;">
        <span style="position:absolute; right:16px; top:50%; transform:translateY(-50%); color:var(--sub); font-size:12px; background:#fff; padding:2px 6px; border-radius:6px; border:1px solid var(--border);">⌘K</span>
    </div>

    <div class="nav-actions" style="gap: 8px;">
        <a href="${pageContext.request.contextPath}/creator-hub/profile" class="icon-btn" title="Profile" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-regular fa-user"></i> <span class="desktop-only">Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/feed" class="icon-btn" title="CreatorHub" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-clapperboard"></i> <span class="desktop-only">CreatorHub</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/chat" class="icon-btn" title="Chat" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-regular fa-comment-dots"></i> <span class="desktop-only">Chat</span>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/coins" class="icon-btn" title="Coins" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-coins"></i> <span class="desktop-only">Coins</span>
        </a>
        <div class="icon-btn" id="notifToggleBtn" onclick="toggleNotifPanel()" title="Notifications" >
            <i class="fa-regular fa-bell"></i> 
            <c:if test="${unreadNotifCount > 0}">
                <span class="notif-badge">${unreadNotifCount}</span>
            </c:if>
        </div>
        <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="icon-btn" title="Settings" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px;">
            <i class="fa-solid fa-gear"></i> <span class="desktop-only">Settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="icon-btn" title="Logout" style="width:auto; padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; gap:6px; color:var(--accent); border-color:var(--accent);">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> <span class="desktop-only">Logout</span>
        </a>
    </div>
</nav>

<!-- ══════════════════ NOTIFICATION PANEL ══════════════════ -->
<div class="notif-panel" id="notifPanel">
    <div class="notif-panel-header">
        <span>Notifications</span>
        <span class="mark-read-btn" onclick="markAllRead()">Mark all read</span>
    </div>
    <div class="notif-panel-body">
        <c:choose>
            <c:when test="${empty recentNotifications}">
                <div class="empty-state active" style="padding: 30px 20px;">
                    <i class="fa-regular fa-bell"></i>
                    <h5>All clear!</h5>
                    <p>No notifications yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${recentNotifications}">
                    <div class="notif-item ${n.read ? '' : 'unread'}" id="notif-${n.id}">
                        <c:choose>
                            <c:when test="${not empty n.sender and not empty n.sender.profilePhoto}">
                                <img src="${n.sender.profilePhoto}" class="notif-avatar" alt="">
                            </c:when>
                            <c:otherwise>
                                <div class="notif-type-icon">
                                    <c:choose>
                                        <c:when test="${n.type eq 'LIKE'}"><i class="fa-solid fa-heart"></i></c:when>
                                        <c:when test="${n.type eq 'COMMENT'}"><i class="fa-regular fa-comment"></i></c:when>
                                        <c:when test="${n.type eq 'FOLLOW'}"><i class="fa-solid fa-user-plus"></i></c:when>
                                        <c:when test="${n.type eq 'MONEY_RECEIVED'}"><i class="fa-solid fa-coins"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-bell"></i></c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div style="flex:1; min-width:0;">
                            <div class="notif-msg">
                                <c:if test="${not empty n.sender}"><strong>${n.sender.fullName}</strong> </c:if>
                                ${n.message}
                            </div>
                            <div class="notif-time">${n.createdAt}</div>
                        </div>
                        <c:if test="${not n.read}"><div class="notif-dot"></div></c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ══════════════════ MAIN PAGE GRID ══════════════════ -->
<div class="page-wrapper">

    <!-- ━━━━━━━━━ LEFT SIDEBAR ━━━━━━━━━ -->
    <div class="left-sidebar desktop-sidebar" style="display:none;">
        <a href="${pageContext.request.contextPath}/creator-hub/profile" class="ls-item active">
            <i class="fa-regular fa-user"></i> Profile
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/feed" class="ls-item">
            <i class="fa-solid fa-clapperboard"></i> CreatorHub
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/chat" class="ls-item">
            <i class="fa-regular fa-comment-dots"></i> Chat
            
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/coins" class="ls-item">
            <i class="fa-solid fa-coins"></i> Coins
        </a>
        <a href="#" onclick="toggleNotifPanel()" class="ls-item">
            <i class="fa-regular fa-bell"></i> Notifications
            <c:if test="${unreadNotifCount > 0}"><span class="ls-badge">${unreadNotifCount}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="ls-item">
            <i class="fa-solid fa-gear"></i> Settings
        </a>
        <div style="margin:20px 0;"></div>
        <a href="${pageContext.request.contextPath}/logout" class="ls-item">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
    </div>

    <!-- ━━━━━━━━━ CENTER: PROFILE ━━━━━━━━━ -->
    <div>

        <!-- Profile Header Card -->
        <div class="card-box">
            <div class="profile-top">
                <!-- Avatar with Story Ring -->
                <div class="avatar-wrap">
                    <%-- Story ring: gradient if has stories, plain if not --%>
                    <div id="avatarRingWrapper" class="avatar-story-ring ${not empty myStories ? 'has-story' : ''}"
                         onclick="${not empty myStories ? 'openMyStoryViewer()' : 'document.getElementById(\'picUpload\').click()'}"
                         title="${not empty myStories ? 'View your stories' : 'Change profile photo'}" style="cursor:pointer;">
                        <c:choose>
                            <c:when test="${not empty currentUser.profilePhoto}">
                                <img src="${currentUser.profilePhoto}" class="avatar-img" alt="Avatar" id="avatarImg" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" class="avatar-img" alt="Avatar" id="avatarImg">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="cam-btn" onclick="document.getElementById('picUpload').click()" title="Change photo">
                        <i class="fa-solid fa-camera"></i>
                    </div>
                    <input type="file" id="picUpload" style="display:none;" accept="image/*" onchange="uploadPic(this)">
                </div>
                <div class="profile-info">
                    <div class="name-row">
                        ${currentUser.fullName}
                        <c:if test="${currentUser.verifiedCreator}">
                            <i class="fa-solid fa-circle-check verified-icon" title="Verified Creator"></i>
                        </c:if>
                    </div>
                    <div class="handle">
                        @<c:choose>
                            <c:when test="${not empty currentUser.creatorHandle}">${currentUser.creatorHandle}</c:when>
                            <c:otherwise>${fn:toLowerCase(fn:replace(currentUser.fullName,' ',''))}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="bio-txt">
                        ${not empty currentUser.creatorBio ? currentUser.creatorBio : 'Dreamer | Creator | Explorer ✨'}
                    </div>
                    <div class="location-row">
                        <i class="fa-solid fa-location-dot"></i>
                        <c:choose>
                            <c:when test="${not empty currentUser.creatorCity}">${currentUser.creatorCity}<c:if test="${not empty currentUser.creatorState}">, ${currentUser.creatorState}</c:if></c:when>
                            <c:when test="${not empty currentUser.homeAddress}">${currentUser.homeAddress}</c:when>
                            <c:otherwise>India</c:otherwise>
                        </c:choose>
                    </div>
                    <div style="display:flex; gap:10px; flex-wrap:wrap;">
                        <button onclick="openEditProfileModal()" class="edit-btn" style="border:1px solid rgba(244,63,94,.25); cursor:pointer;">
                            <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                        </button>
                        <button onclick="openAddStoryModal()" class="edit-btn" style="cursor:pointer;">
                            <i class="fa-solid fa-plus"></i> Add Story
                        </button>
                    </div>
                </div>
            </div>

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-cell" onclick="switchTab('posts')">
                    <div class="stat-icon"><i class="fa-solid fa-border-all"></i></div>
                    <div class="stat-num" data-val="${postsCount}">0</div>
                    <div class="stat-lbl">Posts</div>
                </div>
                <div class="stat-cell">
                    <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                    <div class="stat-num" data-val="${followersCount}">0</div>
                    <div class="stat-lbl">Followers</div>
                </div>
                <div class="stat-cell">
                    <div class="stat-icon"><i class="fa-solid fa-user-check"></i></div>
                    <div class="stat-num" data-val="${followingCount}">0</div>
                    <div class="stat-lbl">Following</div>
                </div>
                <div class="stat-cell" onclick="switchTab('saved')">
                    <div class="stat-icon"><i class="fa-regular fa-bookmark"></i></div>
                    <div class="stat-num" data-val="${savedCount}">0</div>
                    <div class="stat-lbl">Saved</div>
                </div>
            </div>
        </div>

        <!-- Highlights / Stories -->
        <div class="card-box" style="margin-top:18px;">
            <div class="highlights-row" id="highlightsRow">
                <!-- NEW POST/REEL -->
                <div class="hl-item" onclick="window.location='${pageContext.request.contextPath}/creator-hub/upload'">
                    <div class="hl-ring new-hl" style="border-style:dashed; color:var(--sub);"><i class="fa-solid fa-plus"></i></div>
                    <div class="hl-name">New Post</div>
                </div>
                <!-- MY STORIES from server -->
                <c:forEach var="story" items="${myStories}" varStatus="vs">
                    <div class="hl-item" onclick="openStoryViewer([<c:forEach var="s2" items="${myStories}" varStatus="vs2">{id:${s2.id},mediaPath:'${s2.mediaPath}',fileType:'${s2.fileType}',caption:'${fn:replace(s2.caption,"'","\\'")}',uploadTime:'${s2.uploadTime}',viewCount:${s2.viewCount}}<c:if test="${!vs2.last}">,</c:if></c:forEach>], ${vs.index})">
                        <div class="hl-ring story-ring-active">
                            <c:choose>
                                <c:when test="${story.fileType eq 'VIDEO'}">
                                    <video src="${story.mediaPath}" muted playsinline></video>
                                </c:when>
                                <c:otherwise>
                                    <img src="${story.mediaPath}" alt="Story">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="hl-name">${not empty story.caption ? story.caption : 'Story'}</div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ─── STORY VIEWER MODAL ─── -->
        <div id="storyViewerModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:#000; z-index:10000; align-items:center; justify-content:center;">
            <i class="fa-solid fa-times" style="position:absolute; top:20px; right:20px; color:#fff; font-size:24px; cursor:pointer; z-index:10001;" onclick="closeStoryViewer()"></i>
            
            <div class="story-window" style="position:relative; width:100%; max-width:400px; height:100%; max-height:800px; background:#111; display:flex; flex-direction:column;">
                
                <!-- Progress Bars -->
                <div id="storyProgressBars" style="display:flex; gap:4px; padding:12px; position:absolute; top:0; left:0; right:0; z-index:2;"></div>
                
                <!-- Header -->
                <div style="position:absolute; top:24px; left:12px; right:12px; display:flex; align-items:center; justify-content:space-between; z-index:2;">
                    <div style="display:flex; align-items:center; gap:8px;">
                        <img src="${not empty currentUser.profilePhoto ? currentUser.profilePhoto : pageContext.request.contextPath += '/assets/img/default-avatar.png'}" style="width:32px;height:32px;border-radius:50%;object-fit:cover;border:1px solid #fff;">
                        <div style="color:#fff; font-size:13px; font-weight:600; text-shadow:0 1px 3px rgba(0,0,0,0.5);">
                            ${currentUser.creatorHandle} <span id="storyTime" style="opacity:0.8; font-weight:400; margin-left:6px; font-size:12px;"></span>
                        </div>
                    </div>
                </div>

                <!-- Media -->
                <div id="storyMediaContainer" style="flex:1; display:flex; align-items:center; justify-content:center; position:relative; overflow:hidden;"></div>
                
                <!-- Navigation Zones -->
                <div style="position:absolute; top:0; bottom:0; left:0; width:30%; z-index:3; cursor:pointer;" onclick="prevStory()"></div>
                <div style="position:absolute; top:0; bottom:0; right:0; width:30%; z-index:3; cursor:pointer;" onclick="nextStory()"></div>

                <!-- Footer: Caption, Views, and Reply -->
                <div style="position:absolute; bottom:0; left:0; right:0; padding:20px 16px; background:linear-gradient(transparent, rgba(0,0,0,0.8)); z-index:10; display:flex; flex-direction:column; gap:12px;">
                    <div id="storyCaption" style="color:#fff; font-size:14px; text-shadow:0 1px 3px rgba(0,0,0,0.5);"></div>
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <div style="color:#fff; font-size:12px; cursor:pointer; opacity:0.9; font-weight:600; display:flex; align-items:center; gap:6px;">
                            <i class="fa-solid fa-eye"></i> <span id="storyViewCount"></span> Views
                        </div>
                    </div>
                    <!-- Reply Box -->
                    <div style="display:flex; align-items:center; gap:10px; border:1px solid rgba(255,255,255,0.4); border-radius:24px; padding:8px 16px; background:rgba(0,0,0,0.3);">
                        <input type="text" placeholder="Reply to story..." style="flex:1; background:transparent; border:none; color:#fff; outline:none; font-size:14px;" onclick="event.stopPropagation()">
                        <i class="fa-regular fa-face-smile" style="color:#fff; font-size:18px; cursor:pointer;" onclick="event.stopPropagation()"></i>
                        <i class="fa-solid fa-paper-plane" style="color:#fff; font-size:16px; cursor:pointer;" onclick="event.stopPropagation()"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- ─── ADD STORY MODAL ─── -->
        <div id="addStoryModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.6); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; width:90%; max-width:400px; border-radius:12px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,0.2);">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                    <h3 style="font-size:16px; font-weight:700; margin:0;">Create Story</h3>
                    <i class="fa-solid fa-times" style="cursor:pointer; font-size:18px; color:var(--sub);" onclick="closeAddStoryModal()"></i>
                </div>
                <form id="storyUploadForm" onsubmit="submitStory(event)">
                    <div style="border:2px dashed var(--border); border-radius:8px; padding:30px; text-align:center; margin-bottom:16px; cursor:pointer;" onclick="document.getElementById('storyFileInput').click()">
                        <i class="fa-solid fa-cloud-arrow-up" style="font-size:32px; color:var(--accent); margin-bottom:10px;"></i>
                        <div style="font-size:14px; font-weight:600;">Tap to select Image or Video</div>
                        <input type="file" id="storyFileInput" accept="image/*,video/*" style="display:none;" onchange="previewStoryMedia(this)" required>
                    </div>
                    <div id="storyPreviewWrapper" style="display:none; margin-bottom:16px; border-radius:8px; overflow:hidden; max-height:200px; background:#000; text-align:center;">
                    </div>
                    <div style="margin-bottom:16px;">
                        <input type="text" id="storyCaptionInput" placeholder="Add a caption... (optional)" style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; font-size:14px; outline:none;">
                    </div>
                    <button type="submit" id="storySubmitBtn" style="width:100%; background:var(--accent); color:#fff; border:none; padding:12px; border-radius:8px; font-weight:700; cursor:pointer; font-size:14px;">Share to Story</button>
                </form>
            </div>
        </div>


        <!-- ─── EDIT PROFILE MODAL ─── -->
        <div id="editProfileModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.6); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; width:90%; max-width:450px; border-radius:12px; padding:24px; box-shadow:0 10px 30px rgba(0,0,0,0.2);">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 style="font-size:18px; font-weight:700; margin:0;">Edit Profile</h3>
                    <i class="fa-solid fa-times" style="cursor:pointer; font-size:18px; color:var(--sub);" onclick="closeEditProfileModal()"></i>
                </div>
                <form id="editProfileForm" onsubmit="submitEditProfile(event)">
                    <div style="margin-bottom:12px;">
                        <label style="font-size:13px; font-weight:600; color:var(--sub);">Full Name</label>
                        <input type="text" id="editFullName" value="${currentUser.fullName}" style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; font-size:14px; outline:none;" required>
                    </div>
                    <div style="margin-bottom:12px;">
                        <label style="font-size:13px; font-weight:600; color:var(--sub);">Username / Handle</label>
                        <input type="text" id="editHandle" value="${currentUser.creatorHandle}" style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; font-size:14px; outline:none;" required>
                    </div>
                    <div style="margin-bottom:12px;">
                        <label style="font-size:13px; font-weight:600; color:var(--sub);">Bio</label>
                        <textarea id="editBio" rows="3" style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; font-size:14px; outline:none; resize:none;">${currentUser.creatorBio}</textarea>
                    </div>
                    <div style="margin-bottom:20px; display:flex; gap:12px;">
                        <div style="flex:1;">
                            <label style="font-size:13px; font-weight:600; color:var(--sub);">City</label>
                            <input type="text" id="editCity" value="${currentUser.creatorCity}" style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; font-size:14px; outline:none;">
                        </div>
                    </div>
                    <button type="submit" id="editSubmitBtn" style="width:100%; background:var(--accent); color:#fff; border:none; padding:12px; border-radius:8px; font-weight:700; cursor:pointer; font-size:14px;">Save Changes</button>
                </form>
            </div>
        </div>

        <!-- ─── STORY VIEWERS MODAL ─── -->
        <div id="viewersModal" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.6); z-index:10001; align-items:center; justify-content:center;">
            <div style="background:#fff; width:90%; max-width:360px; border-radius:12px; padding:20px; box-shadow:0 10px 30px rgba(0,0,0,0.2); max-height:80vh; display:flex; flex-direction:column;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                    <h3 style="font-size:16px; font-weight:700; margin:0;">Story Viewers</h3>
                    <i class="fa-solid fa-times" style="cursor:pointer; font-size:18px; color:var(--sub);" onclick="closeViewersModal()"></i>
                </div>
                <div id="viewersList" style="overflow-y:auto; flex:1;"></div>
            </div>
        </div>

        <!-- Content Tabs + Grid -->
        <div class="card-box" style="margin-top:18px;">
            <div class="tabs-row">
                <div class="tab-btn active" data-tab="posts" onclick="switchTab('posts')">
                    <i class="fa-solid fa-border-all"></i> Posts
                </div>
                <div class="tab-btn" data-tab="reels" onclick="switchTab('reels')">
                    <i class="fa-solid fa-clapperboard"></i> Reels
                </div>
                <div class="tab-btn" data-tab="saved" onclick="switchTab('saved')">
                    <i class="fa-regular fa-bookmark"></i> Saved
                </div>
                <div class="tab-btn" data-tab="tagged" onclick="switchTab('tagged')">
                    <i class="fa-regular fa-address-book"></i> Tagged
                </div>
            </div>

            <!-- POSTS -->
            <div class="post-grid active" id="grid-posts">
                <c:forEach var="post" items="${posts}">
                    <div class="grid-cell" onclick="openPost(${post.id})">
                        <c:set var="mUrl" value="${fn:startsWith(post.videoPath,'http') ? post.videoPath : pageContext.request.contextPath.concat(post.videoPath)}"/>
                        <img src="${not empty post.thumbnailPath ? post.thumbnailPath : mUrl}" alt="post" loading="lazy">
                        <div class="cell-overlay">
                            <span><i class="fa-solid fa-heart"></i> ${post.likeCount}</span>
                            <span><i class="fa-regular fa-comment"></i></span>
                        </div>
                        <c:if test="${not empty post.location}"><i class="fa-solid fa-location-dot cell-badge"></i></c:if>
                    </div>
                </c:forEach>
            </div>
            <div class="empty-state" id="empty-posts">
                <i class="fa-regular fa-image"></i>
                <h5>No Posts Yet</h5>
                <p>Share your first moment with your followers.</p>
            </div>

            <!-- REELS -->
            <div class="post-grid" id="grid-reels">
                <c:forEach var="reel" items="${reels}">
                    <div class="grid-cell" onclick="openPost(${reel.id})">
                        <c:set var="rUrl" value="${fn:startsWith(reel.videoPath,'http') ? reel.videoPath : pageContext.request.contextPath.concat(reel.videoPath)}"/>
                        <video src="${rUrl}" muted></video>
                        <div class="cell-overlay">
                            <span><i class="fa-solid fa-heart"></i> ${reel.likeCount}</span>
                        </div>
                        <i class="fa-solid fa-play cell-badge"></i>
                    </div>
                </c:forEach>
            </div>
            <div class="empty-state" id="empty-reels">
                <i class="fa-solid fa-clapperboard"></i>
                <h5>No Reels Yet</h5>
                <p>Create short, engaging videos to grow your audience.</p>
            </div>

            <!-- SAVED -->
            <div class="post-grid" id="grid-saved">
                <c:forEach var="sv" items="${savedPosts}">
                    <div class="grid-cell" onclick="openPost(${sv.id})">
                        <c:set var="sUrl" value="${fn:startsWith(sv.videoPath,'http') ? sv.videoPath : pageContext.request.contextPath.concat(sv.videoPath)}"/>
                        <c:choose>
                            <c:when test="${sv.fileType eq 'VIDEO'}">
                                <video src="${sUrl}" muted></video>
                                <i class="fa-solid fa-play cell-badge"></i>
                            </c:when>
                            <c:otherwise>
                                <img src="${not empty sv.thumbnailPath ? sv.thumbnailPath : sUrl}" alt="saved" loading="lazy">
                            </c:otherwise>
                        </c:choose>
                        <div class="cell-overlay">
                            <span><i class="fa-solid fa-heart"></i> ${sv.likeCount}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="empty-state" id="empty-saved">
                <i class="fa-regular fa-bookmark"></i>
                <h5>No Saved Content</h5>
                <p>Bookmark posts and reels to find them here.</p>
            </div>

            <!-- TAGGED -->
            <div class="post-grid" id="grid-tagged"></div>
            <div class="empty-state" id="empty-tagged">
                <i class="fa-regular fa-id-badge"></i>
                <h5>No Tagged Posts</h5>
                <p>Posts where you're tagged will appear here.</p>
            </div>
        </div>

    </div><!-- /center -->

    <!-- ━━━━━━━━━ MIDDLE SIDEBAR: Suggestions ━━━━━━━━━ -->
    <div class="desktop-sidebar">

        <!-- People You May Know -->
        <div class="card-box">
            <div class="s-title">
                <span><i class="fa-solid fa-user-plus" style="color:var(--accent);margin-right:6px;"></i> People You May Know</span>
                <a href="${pageContext.request.contextPath}/creator-hub/feed">See all</a>
            </div>
            <c:choose>
                <c:when test="${empty suggestedUsers}">
                    <div style="padding:20px 18px;font-size:13px;color:var(--sub);text-align:center;">No suggestions right now.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="su" items="${suggestedUsers}">
                        <div class="suggest-item">
                            <c:choose>
                                <c:when test="${not empty su.profilePhoto}">
                                    <img src="${su.profilePhoto}" class="suggest-avatar" alt="${su.fullName}" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" class="suggest-avatar" alt="${su.fullName}">
                                </c:otherwise>
                            </c:choose>
                            <div class="suggest-info">
                                <div class="suggest-name">${su.fullName}</div>
                                <div class="suggest-sub">
                                    <c:choose>
                                        <c:when test="${su.verifiedCreator}"><i class="fa-solid fa-circle-check" style="color:var(--success);font-size:10px;"></i> Verified</c:when>
                                        <c:when test="${not empty su.creatorCategory}">${su.creatorCategory}</c:when>
                                        <c:otherwise>Member</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <button class="follow-btn" id="follow-btn-${su.id}" onclick="toggleFollow(${su.id}, this)">
                                Follow
                            </button>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Following / Friends -->
        <div class="card-box">
            <div class="s-title">
                <span><i class="fa-solid fa-users" style="color:var(--accent);margin-right:6px;"></i> Following</span>
                <span style="font-size:12px;color:var(--sub);">${followingCount}</span>
            </div>
            <c:if test="${empty followingList}">
                <div style="padding:16px 18px;font-size:13px;color:var(--sub);">You haven't followed anyone yet.</div>
            </c:if>
            <c:forEach var="friend" items="${followingList}">
                <div class="suggest-item">
                    <c:choose>
                        <c:when test="${not empty friend.profilePhoto}">
                            <img src="${friend.profilePhoto}" class="suggest-avatar" alt="${friend.fullName}" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" class="suggest-avatar" alt="${friend.fullName}">
                        </c:otherwise>
                    </c:choose>
                    <div class="suggest-info">
                        <div class="suggest-name">${friend.fullName}</div>
                        <div class="suggest-sub">Following</div>
                    </div>
                    <button class="follow-btn following" onclick="openChat(${friend.id}, '${friend.fullName}', '${not empty friend.profilePhoto ? friend.profilePhoto : ''}')">
                        <i class="fa-regular fa-comment-dots"></i>
                    </button>
                </div>
            </c:forEach>
        </div>

        <!-- Notifications / Recent Activity -->
        <div class="card-box">
            <div class="s-title">
                <span><i class="fa-regular fa-bell" style="color:var(--accent);margin-right:6px;"></i> Recent Activity</span>
                <a href="${pageContext.request.contextPath}/creator-hub/notifications">See all</a>
            </div>
            <c:choose>
                <c:when test="${empty recentNotifications}">
                    <div style="padding:20px 18px;font-size:13px;color:var(--sub);text-align:center;">No activity yet.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${recentNotifications}">
                        <div class="notif-item ${n.read ? '' : 'unread'}">
                            <c:choose>
                                <c:when test="${not empty n.sender and not empty n.sender.profilePhoto}">
                                    <img src="${n.sender.profilePhoto}" class="notif-avatar" alt="">
                                </c:when>
                                <c:otherwise>
                                    <div class="notif-type-icon">
                                        <c:choose>
                                            <c:when test="${n.type eq 'LIKE'}"><i class="fa-solid fa-heart"></i></c:when>
                                            <c:when test="${n.type eq 'COMMENT'}"><i class="fa-regular fa-comment"></i></c:when>
                                            <c:when test="${n.type eq 'FOLLOW'}"><i class="fa-solid fa-user-plus"></i></c:when>
                                            <c:otherwise><i class="fa-solid fa-bell"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div style="flex:1;min-width:0;">
                                <div class="notif-msg">
                                    <c:if test="${not empty n.sender}"><strong>${n.sender.fullName}</strong> </c:if>
                                    ${fn:length(n.message) > 50 ? fn:substring(n.message, 0, 50).concat('…') : n.message}
                                </div>
                            </div>
                            <c:if test="${not n.read}"><div class="notif-dot"></div></c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div><!-- /right sidebar -->

</div><!-- /page-wrapper -->

    
    
        
        
    </div>
</div>

<!-- ══════════════════ MOBILE BOTTOM NAV ══════════════════ -->
<div class="bottom-nav">
    <a href="${pageContext.request.contextPath}/" class="bn-link">
        <i class="fa-solid fa-house"></i><span>Home</span>
    </a>
    <a href="${pageContext.request.contextPath}/creator-hub/feed" class="bn-link">
        <i class="fa-solid fa-clapperboard"></i><span>Feed</span>
    </a>
    <a href="${pageContext.request.contextPath}/creator-hub/upload" class="bn-add">
        <i class="fa-solid fa-plus"></i>
    </a>
    <div class="bn-link" onclick="toggleNotifPanel()">
        <i class="fa-regular fa-bell"></i><span>Alerts</span>
    </div>
    <div class="bn-link" onclick="window.location.href='${pageContext.request.contextPath}/creator-hub/chat'">
        <i class="fa-regular fa-comment-dots"></i><span>Chat</span>
    </div>
</div>


<script>
    // ── Number formatting ──────────────────────────────
    function fmt(n) {
        n = parseInt(n)||0;
        if (n>=1000000) return (n/1000000).toFixed(1).replace(/\.0$/,'')+'M';
        if (n>=1000) return (n/1000).toFixed(1).replace(/\.0$/,'')+'K';
        return ''+n;
    }
    document.querySelectorAll('.stat-num').forEach(el => {
        el.textContent = fmt(el.dataset.val);
    });

    // ── Tab switching ─────────────────────────────────
    function switchTab(tabId) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelector('.tab-btn[data-tab="'+tabId+'"]').classList.add('active');
        document.querySelectorAll('.post-grid, .empty-state').forEach(el => el.classList.remove('active'));
        const grid = document.getElementById('grid-'+tabId);
        const emp  = document.getElementById('empty-'+tabId);
        if (grid && grid.children.length > 0) grid.classList.add('active');
        else if (emp) emp.classList.add('active');
    }
    // Initialize first tab
    switchTab('posts');

    // ── Open post ─────────────────────────────────────
    function openPost(id) {
        window.location = '${pageContext.request.contextPath}/creator-hub/feed#post-'+id;
    }

    // ── Profile photo upload ──────────────────────────
    function uploadPic(input) {
        if (!input.files || !input.files[0]) return;
        
        // Show immediate preview
        const r = new FileReader();
        r.onload = e => document.getElementById('avatarImg').src = e.target.result;
        r.readAsDataURL(input.files[0]);

        // Send to backend
        const fd = new FormData();
        fd.append("file", input.files[0]);
        fetch('${pageContext.request.contextPath}/creator-hub/profile/upload-photo', {
            method: 'POST',
            body: fd
        })
        .then(res => res.json())
        .then(data => {
            if(!data.success) alert("Failed to save profile photo: " + (data.error || ""));
        })
        .catch(err => {
            console.error("Photo upload error:", err);
            alert("Error uploading photo.");
        });
    }

    // ── Story Viewer ──────────────────────────────────
    let storyList = [];
    let currentStoryIdx = 0;
    let storyTimer;

    // Optional: easily open just user's own stories (used by clicking avatar ring)
    function openMyStoryViewer() {
        fetch('${pageContext.request.contextPath}/creator-hub/story/my')
            .then(r => r.json())
            .then(data => {
                if (data && data.length > 0) openStoryViewer(data, 0);
            })
            .catch(console.error);
    }

    function openStoryViewer(stories, startIdx) {
        if (!stories || stories.length === 0) return;
        storyList = stories;
        currentStoryIdx = startIdx || 0;
        
        const modal = document.getElementById('storyViewerModal');
        modal.style.display = 'flex';
        renderStory();
    }

    function closeStoryViewer() {
        document.getElementById('storyViewerModal').style.display = 'none';
        clearTimeout(storyTimer);
        const container = document.getElementById('storyMediaContainer');
        container.innerHTML = '';
    }

    function renderStory() {
        if (currentStoryIdx >= storyList.length || currentStoryIdx < 0) {
            closeStoryViewer();
            return;
        }

        clearTimeout(storyTimer);
        const s = storyList[currentStoryIdx];
        
        // Setup Progress Bars
        const pbContainer = document.getElementById('storyProgressBars');
        pbContainer.innerHTML = '';
        storyList.forEach((_, i) => {
            const bar = document.createElement('div');
            bar.style.flex = "1";
            bar.style.height = "2px";
            bar.style.background = (i < currentStoryIdx) ? "#fff" : "rgba(255,255,255,0.3)";
            bar.style.borderRadius = "2px";
            if (i === currentStoryIdx) {
                bar.innerHTML = '<div id="activeProgressBar" style="width:0%; height:100%; background:#fff; transition:width linear;"></div>';
            }
            pbContainer.appendChild(bar);
        });

        // Setup Caption & Viewers
        document.getElementById('storyCaption').textContent = s.caption || '';
        document.getElementById('storyViewCount').textContent = s.viewCount || 0;
        document.getElementById('storyViewCount').parentElement.onclick = () => openViewersModal(s.id);
        
        // Setup Date & Delete
        const d = new Date(s.uploadTime);
        const diff = Math.floor((new Date() - d) / (1000 * 60 * 60));
        document.getElementById('storyTime').innerHTML = (diff > 0 ? (diff + 'h') : 'Just now') + 
            ' &nbsp; <i class="fa-solid fa-trash" style="cursor:pointer;color:#ff4d4f;" onclick="deleteStory(' + s.id + ', event)" title="Delete Story"></i>';

        // Setup Media
        const container = document.getElementById('storyMediaContainer');
        container.innerHTML = '';
        if (s.fileType === 'VIDEO') {
            const v = document.createElement('video');
            v.src = '${pageContext.request.contextPath}' + s.mediaPath;
            v.style.width = '100%'; v.style.height = '100%'; v.style.objectFit = 'contain';
            v.autoplay = true; v.playsInline = true;
            v.onended = nextStory;
            v.onplay = () => {
                const activeBar = document.getElementById('activeProgressBar');
                if (activeBar && v.duration) {
                    activeBar.style.transitionDuration = v.duration + 's';
                    activeBar.style.width = '100%';
                }
            };
            container.appendChild(v);
        } else {
            const img = document.createElement('img');
            img.src = '${pageContext.request.contextPath}' + s.mediaPath;
            img.style.width = '100%'; img.style.height = '100%'; img.style.objectFit = 'contain';
            container.appendChild(img);
            
            // Image duration = 5s
            requestAnimationFrame(() => {
                const activeBar = document.getElementById('activeProgressBar');
                if(activeBar) {
                    activeBar.style.transitionDuration = '5s';
                    activeBar.style.width = '100%';
                }
            });
            storyTimer = setTimeout(nextStory, 5000);
        }

        // Notify backend of view
        fetch('${pageContext.request.contextPath}/creator-hub/story/' + s.id + '/view', { method:'POST' }).catch(console.error);
    }

    function deleteStory(id, event) {
        event.stopPropagation();
        if(!confirm("Are you sure you want to delete this story?")) return;
        fetch('${pageContext.request.contextPath}/creator-hub/story/' + id, { method: 'DELETE' })
        .then(r => r.json())
        .then(res => {
            if(res.success) window.location.reload();
        });
    }

    function deletePost(id, event) {
        event.stopPropagation();
        if(!confirm("Are you sure you want to delete this post/reel?")) return;
        fetch('${pageContext.request.contextPath}/creator-hub/post/' + id, { method: 'DELETE' })
        .then(r => r.json())
        .then(res => {
            if(res.success) window.location.reload();
        });
    }

    function openViewersModal(storyId) {
        clearTimeout(storyTimer); // pause story
        fetch('${pageContext.request.contextPath}/creator-hub/story/' + storyId + '/viewers')
        .then(r => r.json())
        .then(viewers => {
            const list = document.getElementById('viewersList');
            list.innerHTML = '';
            if(!viewers || viewers.length===0) {
                list.innerHTML = '<div style="text-align:center;color:var(--sub);font-size:13px;padding:20px;">No viewers yet.</div>';
            } else {
                viewers.forEach(v => {
                    list.innerHTML += '<div style="display:flex; align-items:center; gap:10px; padding:10px 0; border-bottom:1px solid var(--border);">' + '<img src="' + (v.avatar ? v.avatar : "${pageContext.request.contextPath}/assets/img/default-avatar.png") + '" style="width:36px;height:36px;border-radius:50%;object-fit:cover;">' + '<div style="font-size:14px;font-weight:600;">' + v.name + '</div></div>';
                });
            }
            document.getElementById('viewersModal').style.display = 'flex';
        });
    }

    function closeViewersModal() {
        document.getElementById('viewersModal').style.display = 'none';
        storyTimer = setTimeout(nextStory, 5000); // resume
    }

    // ── Edit Profile ─────────────────────────────────
    function openEditProfileModal() {
        document.getElementById('editProfileModal').style.display = 'flex';
    }
    function closeEditProfileModal() {
        document.getElementById('editProfileModal').style.display = 'none';
    }
    function submitEditProfile(e) {
        e.preventDefault();
        const fd = new FormData();
        fd.append('fullName', document.getElementById('editFullName').value.trim());
        fd.append('creatorHandle', document.getElementById('editHandle').value.trim());
        fd.append('creatorBio', document.getElementById('editBio').value.trim());
        fd.append('creatorCity', document.getElementById('editCity').value.trim());

        fetch('${pageContext.request.contextPath}/creator-hub/profile/edit', {
            method: 'POST', body: fd
        }).then(r=>r.json()).then(res=>{
            if(res.success) window.location.reload();
        });
    }

    function nextStory() {
        if(currentStoryIdx < storyList.length - 1) {
            currentStoryIdx++;
            renderStory();
        } else {
            closeStoryViewer();
        }
    }

    function prevStory() {
        if(currentStoryIdx > 0) {
            currentStoryIdx--;
            renderStory();
        }
    }

    // ── Story Upload Modal ────────────────────────────
    let selectedStoryFile = null;

    function openAddStoryModal() {
        document.getElementById('addStoryModal').style.display = 'flex';
        document.getElementById('storyUploadForm').reset();
        document.getElementById('storyPreviewWrapper').style.display = 'none';
        document.getElementById('storyPreviewWrapper').innerHTML = '';
        selectedStoryFile = null;
    }
    
    function closeAddStoryModal() {
        document.getElementById('addStoryModal').style.display = 'none';
    }

    function previewStoryMedia(input) {
        if(!input.files || !input.files[0]) return;
        selectedStoryFile = input.files[0];
        const wrapper = document.getElementById('storyPreviewWrapper');
        wrapper.style.display = 'block';
        wrapper.innerHTML = '';

        if(selectedStoryFile.type.startsWith('video/')) {
            const v = document.createElement('video');
            v.src = URL.createObjectURL(selectedStoryFile);
            v.controls = true; v.style.width = '100%'; v.style.maxHeight = '200px'; v.style.objectFit = 'contain';
            wrapper.appendChild(v);
        } else {
            const img = document.createElement('img');
            img.src = URL.createObjectURL(selectedStoryFile);
            img.style.width = '100%'; img.style.maxHeight = '200px'; img.style.objectFit = 'contain';
            wrapper.appendChild(img);
        }
    }

    function submitStory(e) {
        e.preventDefault();
        if(!selectedStoryFile) return alert('Please select a file.');

        const btn = document.getElementById('storySubmitBtn');
        btn.textContent = 'Uploading...';
        btn.disabled = true;

        const fd = new FormData();
        fd.append("file", selectedStoryFile);
        fd.append("caption", document.getElementById('storyCaptionInput').value.trim());

        fetch('${pageContext.request.contextPath}/creator-hub/story/upload', {
            method: 'POST',
            body: fd
        })
        .then(r => r.json())
        .then(data => {
            btn.textContent = 'Share to Story';
            btn.disabled = false;
            if(data.success) {
                closeAddStoryModal();
                // Refresh page to show new story in highlights
                window.location.reload();
            } else {
                alert("Upload failed: " + (data.error || ""));
            }
        })
        .catch(err => {
            console.error(err);
            btn.textContent = 'Share to Story';
            btn.disabled = false;
            alert("Error uploading story.");
        });
    }

    // ── Follow / Unfollow ─────────────────────────────
    function toggleFollow(userId, btn) {
        const isFollowing = btn.classList.contains('following');
        const url = isFollowing
            ? '${pageContext.request.contextPath}/creator-hub/creator/unfollow/'+userId
            : '${pageContext.request.contextPath}/creator-hub/creator/follow/'+userId;
        fetch(url, { method: 'POST', headers: { 'X-Requested-With':'XMLHttpRequest' } })
            .then(r => {
                if (r.ok) {
                    if (isFollowing) {
                        btn.classList.remove('following');
                        btn.textContent = 'Follow';
                    } else {
                        btn.classList.add('following');
                        btn.textContent = 'Following';
                    }
                }
            })
            .catch(() => {
                // fallback: redirect
                window.location = url;
            });
    }

    // ── Notification Panel ───────────────────────────
          function toggleNotifPanel() {
          const panel = document.getElementById('notifPanel');
          panel.classList.toggle('open');
          if (panel.classList.contains('open')) {
              markAllRead();
          }
      }
    function markAllRead() {
        fetch('${pageContext.request.contextPath}/creator-hub/notifications/mark-all-read', { method: 'POST' })
            .then(() => {
                document.querySelectorAll('.notif-item.unread').forEach(el => el.classList.remove('unread'));
                document.querySelectorAll('.notif-dot').forEach(el => el.remove());
                const badge = document.querySelector('#notifToggleBtn .notif-badge');
                if (badge) badge.remove();
            });
    }
    // Close notification panel on outside click
    document.addEventListener('click', e => {
        const panel = document.getElementById('notifPanel');
        const btn = document.getElementById('notifToggleBtn');
        if (panel && panel.classList.contains('open') && !panel.contains(e.target) && !btn.contains(e.target)) {
            panel.classList.remove('open');
        }
    });

    // Chat is now a dedicated page - redirect all chat actions
    function toggleChatPanel() { window.location.href = '${pageContext.request.contextPath}/creator-hub/chat'; }
    function openChat(userId, name, avatar) { window.location.href = '${pageContext.request.contextPath}/creator-hub/chat'; }
    function closeChat() {}
    function loadMessages() {}
    function sendMessage() {}
</script>

        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>















