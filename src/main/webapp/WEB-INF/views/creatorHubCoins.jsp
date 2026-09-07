<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creator Hub - Feed</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
        * { box-sizing: border-box; font-family: 'Outfit', sans-serif; margin: 0; padding: 0; }
        body { background: var(--bg); color: var(--text); overflow-y: scroll; overflow-x: hidden; width: 100%; }
        a { text-decoration: none; color: inherit; }

        @media (max-width: 768px) { .page-wrapper { padding: 10px 0 !important; gap: 10px !important; } } .page-wrapper {
            max-width: 1536px;
            margin: 0 auto;
            padding: 20px;
            display: flex; flex-direction: column; align-items: center; gap: 20px; width: 100%;
        }

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

        /* ── CENTER FEED ── */
        .feed-container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* ── STORIES ROW ── */
        .stories-box {
            background: var(--card);
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 16px;
            display: flex;
            gap: 16px;
            overflow-x: auto;
            scrollbar-width: none;
        }
        .stories-box::-webkit-scrollbar { display: none; }
        .story-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            width: 72px;
            flex-shrink: 0;
        }
        .story-ring {
            width: 64px; height: 64px;
            border-radius: 50%;
            padding: 3px;
            background: linear-gradient(45deg, #f9ce34, #ee2a7b, #6228d7);
            display: flex; align-items: center; justify-content: center;
        }
        .story-ring img {
            width: 100%; height: 100%;
            border-radius: 50%;
            border: 2px solid var(--card);
            object-fit: cover;
        }
        .story-name { font-size: 11px; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%; }

        /* ── FEED POST CARD ── */
        .feed-post {
            background: var(--card);
            border-radius: 16px;
            border: 1px solid var(--border);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .fp-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 16px;
        }
        .fp-user { display: flex; align-items: center; gap: 10px; font-weight: 600; font-size: 14px; }
        .fp-user img { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; }
        .fp-media {
            width: 100%;
            max-height: 700px;
            background: #000;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .fp-media img, .fp-media video {
            width: 100%;
            max-height: 700px;
            object-fit: contain;
        }
        .fp-actions {
            padding: 12px 16px 8px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 24px;
        }
        .fp-actions-left { display: flex; gap: 16px; }
        .fp-actions i { cursor: pointer; transition: .2s; }
        .fp-actions i:hover { color: var(--sub); }
        .fp-likes { padding: 0 16px; font-weight: 600; font-size: 14px; margin-bottom: 6px; }
        .fp-caption { padding: 0 16px 16px; font-size: 14px; }
        
        .empty-feed { text-align: center; padding: 40px 20px; color: var(--sub); }
        .empty-feed i { font-size: 40px; margin-bottom: 16px; opacity: 0.5; }
    .stats-grid { display:grid; grid-template-columns:repeat(3, 1fr); gap:20px; width:100%; max-width:800px; } @media (max-width: 768px) { .stats-grid { grid-template-columns: 1fr; } .coins-container { padding: 20px !important; } } </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        <div id="page-content-wrapper" style="padding: 0; min-height: 100vh; background: var(--bg); flex: 1; min-width: 0; width: auto;" data-skip-global-back="true">
<!-- Header -->
    <style>
@media (max-width: 1200px) {
    .ch-sub-header {
        justify-content: flex-start !important;
        overflow-x: auto !important;
        white-space: nowrap !important;
        gap: 15px !important;
        padding: 0 16px !important;
        scrollbar-width: none;
    }
    .ch-sub-header::-webkit-scrollbar { display: none; }
    .ch-sub-header > div { flex-shrink: 0 !important; }
    .desktop-only { display: none !important; }
}
.stats-grid { display:grid; grid-template-columns:repeat(3, 1fr); gap:20px; width:100%; max-width:800px; } @media (max-width: 768px) { .stats-grid { grid-template-columns: 1fr; } .coins-container { padding: 20px !important; } } </style>
        <header class="ch-sub-header" style="position:sticky; top:80px; width:100%; height:60px; background:#fff; border-bottom:1px solid var(--border); z-index:100; display:flex; align-items:center; justify-content:space-between; padding:0 20px;">
        <div style="font-weight:700; font-size:20px; color:var(--accent); display:flex; align-items:center; gap:12px;"><span><i class="fa-solid fa-clapperboard"></i> Creator Hub</span></div>
                <div style="display:flex; align-items:center; gap:8px;">
            <a href="${pageContext.request.contextPath}/creator-hub/profile" title="Profile" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-regular fa-user"></i> <span class="desktop-only">Profile</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/feed" title="CreatorHub" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-solid fa-clapperboard"></i> <span class="desktop-only">CreatorHub</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/chat" title="Chat" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-regular fa-comment-dots"></i> <span class="desktop-only">Chat</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/coins" title="Coins" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-solid fa-coins"></i> <span class="desktop-only">Coins</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/dashboard" title="Settings" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-solid fa-gear"></i> <span class="desktop-only">Settings</span></a>
            <a href="${pageContext.request.contextPath}/logout" title="Logout" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--accent); text-decoration:none;"><i class="fa-solid fa-arrow-right-from-bracket"></i> <span class="desktop-only">Logout</span></a>
        </div>
    </header>

    <div class="page-wrapper">
        <!-- LEFT SIDEBAR -->
        <div class="left-sidebar desktop-sidebar" style="display:none;">
            <a href="${pageContext.request.contextPath}/creator-hub/profile" class="ls-item">
                <i class="fa-regular fa-user"></i> Profile
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/feed" class="ls-item">
                <i class="fa-solid fa-clapperboard"></i> CreatorHub
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/chat" class="ls-item"><i class="fa-regular fa-comment-dots"></i> Chat
                
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/coins" class="ls-item active"><i class="fa-solid fa-coins"></i> Coins
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


                <!-- RIGHT COIN DASHBOARD -->
        <div class="coins-container" style="width:100%; max-width:1000px; flex:1; background:var(--card); border:1px solid var(--border); border-radius:var(--radius-lg); padding:40px; display:flex; flex-direction:column; align-items:center; min-height:calc(100vh - 120px);">
            
            <!-- Header -->
            <div style="text-align:center; margin-bottom:40px;">
                <div style="width:100px; height:100px; background:linear-gradient(135deg, #FFD700, #FDB931); border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 20px; box-shadow:0 10px 20px rgba(255,215,0,0.3);">
                    <i class="fa-solid fa-coins" style="font-size:48px; color:#fff;"></i>
                </div>
                <h1 style="font-size:36px; margin:0 0 10px; color:var(--dark);">Total Coins</h1>
                <div style="font-size:48px; font-weight:800; color:var(--accent); text-shadow:0 2px 4px rgba(244,63,94,0.1);">${totalCoins}</div>
                <p style="color:var(--sub); font-size:16px;">Earn more coins by getting likes, views, and followers!</p>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                
                <!-- Likes Stats -->
                <div style="background:var(--bg); border:1px solid var(--border); border-radius:16px; padding:24px; text-align:center; transition:transform 0.2s;">
                    <i class="fa-solid fa-heart" style="font-size:32px; color:#F43F5E; margin-bottom:16px;"></i>
                    <h3 style="font-size:18px; margin:0 0 8px; color:var(--dark);">Likes</h3>
                    <div style="font-size:24px; font-weight:700; margin-bottom:12px;">${totalLikes}</div>
                    <div style="background:rgba(244,63,94,0.1); color:#F43F5E; padding:8px 16px; border-radius:20px; font-weight:600; display:inline-block;">
                        +${likesCoins} Coins
                    </div>
                </div>

                <!-- Views Stats -->
                <div style="background:var(--bg); border:1px solid var(--border); border-radius:16px; padding:24px; text-align:center; transition:transform 0.2s;">
                    <i class="fa-solid fa-eye" style="font-size:32px; color:#3B82F6; margin-bottom:16px;"></i>
                    <h3 style="font-size:18px; margin:0 0 8px; color:var(--dark);">Views</h3>
                    <div style="font-size:24px; font-weight:700; margin-bottom:12px;">${totalViews}</div>
                    <div style="background:rgba(59,130,246,0.1); color:#3B82F6; padding:8px 16px; border-radius:20px; font-weight:600; display:inline-block;">
                        +${viewsCoins} Coins
                    </div>
                </div>

                <!-- Followers Stats -->
                <div style="background:var(--bg); border:1px solid var(--border); border-radius:16px; padding:24px; text-align:center; transition:transform 0.2s;">
                    <i class="fa-solid fa-users" style="font-size:32px; color:#10B981; margin-bottom:16px;"></i>
                    <h3 style="font-size:18px; margin:0 0 8px; color:var(--dark);">Followers</h3>
                    <div style="font-size:24px; font-weight:700; margin-bottom:12px;">${totalFollowers}</div>
                    <div style="background:rgba(16,185,129,0.1); color:#10B981; padding:8px 16px; border-radius:20px; font-weight:600; display:inline-block;">
                        +${followersCoins} Coins
                    </div>
                </div>

            </div>
            
            <div style="margin-top:40px; padding:20px; background:var(--bg); border-radius:12px; border:1px dashed var(--border); width:100%; max-width:800px; text-align:center; color:var(--sub);">
                <i class="fa-solid fa-circle-info" style="margin-right:8px;"></i>
                <strong>Coin Rules:</strong> 1 Like = 1 Coin &bull; 10 Views = 1 Coin &bull; 1 Follower = 5 Coins
            </div>
            
        </div>
    </div>
        </div>
    </div>
</body>
</html>




















