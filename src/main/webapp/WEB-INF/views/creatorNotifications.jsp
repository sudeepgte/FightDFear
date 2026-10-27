<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Creator Notifications — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
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
            --shadow:      0 4px 16px rgba(0,0,0,.04);
        }
        
        body {
            font-family: 'Outfit', 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--dark);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        a { text-decoration: none; color: inherit; }

        /* ── SUB HEADER ── */
        .ch-sub-header {
            position: sticky; top: 80px; width: 100%; height: 60px;
            background: #fff; border-bottom: 1px solid var(--border);
            z-index: 100; display: flex; align-items: center; justify-content: space-between;
            padding: 0 24px;
        }

        .icon-btn {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: var(--bg); color: var(--dark);
            border: 1px solid var(--border); cursor: pointer;
            font-size: 15px; transition: all .2s; position: relative;
        }
        .icon-btn:hover { background: var(--accent-soft); border-color: var(--accent); color: var(--accent); }

        /* ── LAYOUT GRID ── */
        .page-wrapper {
            width: 100%;
            max-width: 860px;
            margin: 0 auto;
            padding: 24px 20px 60px;
        }

        /* ── FILTER TABS ── */
        .notif-tabs {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            overflow-x: auto;
            padding-bottom: 4px;
            scrollbar-width: none;
        }
        .notif-tabs::-webkit-scrollbar { display: none; }

        .notif-tab {
            padding: 8px 18px;
            border-radius: 20px;
            background: var(--card);
            border: 1px solid var(--border);
            font-size: 13px;
            font-weight: 600;
            color: var(--sub);
            cursor: pointer;
            transition: all .2s;
            white-space: nowrap;
        }
        .notif-tab:hover {
            border-color: var(--accent);
            color: var(--accent);
        }
        .notif-tab.active {
            background: var(--accent);
            color: #fff;
            border-color: var(--accent);
            box-shadow: 0 2px 8px rgba(244,63,94,.25);
        }

        /* ── CARDS ── */
        .card-box {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            overflow: hidden;
            padding: 24px;
        }

        .card-header-row {
            padding-bottom: 16px;
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid var(--border);
            margin-bottom: 20px;
        }
        .card-header-row h2 {
            font-size: 18px; font-weight: 700; color: var(--dark); margin: 0;
            display: flex; align-items: center; gap: 8px;
        }

        .notif-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: all .2s ease;
        }
        .notif-card:hover {
            border-color: var(--accent-mid);
            background: #FAFAFC;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,0,0,.03);
        }
        .notif-card.unread {
            border-left: 4px solid var(--accent);
            background: #FFFBFB;
        }

        .notif-left {
            display: flex;
            align-items: center;
            gap: 16px;
            flex: 1;
            min-width: 0;
        }

        .avatar-wrap {
            position: relative;
            width: 48px;
            height: 48px;
            flex-shrink: 0;
        }
        .avatar-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,.08);
        }
        .type-badge {
            position: absolute;
            bottom: -2px;
            right: -2px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            color: #fff;
            border: 2px solid #fff;
        }
        .badge-like { background: #F43F5E; }
        .badge-comment { background: #0EA5E9; }
        .badge-follow { background: #8B5CF6; }
        .badge-chat { background: #10B981; }
        .badge-default { background: #64748B; }

        .notif-content {
            flex: 1;
            min-width: 0;
        }
        .notif-text {
            font-size: 14px;
            color: var(--dark);
            line-height: 1.45;
            margin-bottom: 3px;
            word-break: break-word;
        }
        .notif-time {
            font-size: 12px;
            color: var(--sub);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .notif-action-btn {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            background: var(--bg);
            border: 1px solid var(--border);
            color: var(--dark);
            cursor: pointer;
            transition: all .2s;
            white-space: nowrap;
            flex-shrink: 0;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .notif-action-btn:hover {
            background: var(--accent-soft);
            color: var(--accent);
            border-color: var(--accent);
        }

        .mark-read-btn {
            font-size: 13px;
            font-weight: 600;
            color: var(--sub);
            cursor: pointer;
            background: none;
            border: none;
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 4px 8px;
            border-radius: 8px;
            transition: all .2s;
        }
        .mark-read-btn:hover {
            color: var(--accent);
            background: var(--accent-soft);
        }

        @media (max-width: 768px) {
            .page-wrapper { padding: 12px 10px 40px; }
            .notif-card { flex-direction: column; align-items: flex-start; gap: 10px; padding: 14px; }
            .notif-action-btn { align-self: flex-end; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="padding: 0; min-height: 100vh; background: var(--bg); flex: 1; min-width: 0; width: 100%;" data-skip-global-back="true">
        
        <!-- TOP SUB HEADER -->
        <header class="ch-sub-header">
            <div style="font-weight:700; font-size:18px; color:var(--accent); display:flex; align-items:center; gap:10px;">
                <i class="fa-solid fa-clapperboard"></i> <span>Creator Hub</span>
            </div>
            <div style="display:flex; align-items:center; gap:8px;">
                <a href="${pageContext.request.contextPath}/creator-hub/profile" title="Profile" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--dark); text-decoration:none;"><i class="fa-regular fa-user"></i> <span class="d-none d-sm-inline">Profile</span></a>
                <a href="${pageContext.request.contextPath}/creator-hub/feed" title="CreatorHub" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--dark); text-decoration:none;"><i class="fa-solid fa-clapperboard"></i> <span class="d-none d-sm-inline">CreatorHub</span></a>
                <a href="${pageContext.request.contextPath}/creator-hub/chat" title="Chat" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--dark); text-decoration:none;"><i class="fa-regular fa-comment-dots"></i> <span class="d-none d-sm-inline">Chat</span></a>
                <a href="${pageContext.request.contextPath}/creator-hub/notifications" title="Notifications" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--accent); text-decoration:none;"><i class="fa-solid fa-bell"></i> <span class="d-none d-sm-inline">Notifications</span></a>
                <a href="${pageContext.request.contextPath}/creator-hub/dashboard" title="Settings" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--dark); text-decoration:none;"><i class="fa-solid fa-gear"></i> <span class="d-none d-sm-inline">Settings</span></a>
            </div>
        </header>

        <div class="page-wrapper">
            <!-- Filter Tabs -->
            <div class="notif-tabs">
                <button type="button" class="notif-tab active" onclick="filterNotifs('ALL', this)">All Activity</button>
                <button type="button" class="notif-tab" onclick="filterNotifs('FOLLOW', this)">Follows</button>
                <button type="button" class="notif-tab" onclick="filterNotifs('ENGAGEMENT', this)">Likes & Comments</button>
                <button type="button" class="notif-tab" onclick="filterNotifs('CHAT', this)">Messages</button>
            </div>

            <div class="card-box" data-aos="fade-up">
                
                <div class="card-header-row">
                    <h2><i class="fa-regular fa-bell text-danger"></i> Recent Activity</h2>
                    <c:if test="${not empty notifications}">
                        <button type="button" class="mark-read-btn" onclick="markAllAsRead()">
                            <i class="fa-solid fa-check-double"></i> Mark all read
                        </button>
                    </c:if>
                </div>
                
                <c:if test="${empty notifications}">
                    <div class="text-center py-5 text-muted" id="emptyNotifBox">
                        <i class="fa-regular fa-bell-slash display-4 mb-3 d-block" style="opacity:0.4;"></i>
                        <h5 class="fw-bold text-dark">No recent activity</h5>
                        <p class="mb-0 text-secondary" style="font-size:14px;">When people interact with your profile or posts, their activity will show up here.</p>
                    </div>
                </c:if>

                <div id="notifListContainer">
                    <c:forEach var="n" items="${notifications}">
                        <div class="notif-card ${!n.read ? 'unread' : ''}" 
                             data-type="${n.type}"
                             id="notif-item-${n.id}">
                            
                            <div class="notif-left">
                                <div class="avatar-wrap">
                                    <c:choose>
                                        <c:when test="${not empty n.sender and not empty n.sender.profilePhoto}">
                                            <img src="${n.sender.profilePhoto}" class="avatar-img" alt="${n.sender.fullName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" class="avatar-img" alt="User">
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Type badge -->
                                    <c:choose>
                                        <c:when test="${n.type eq 'LIKE'}">
                                            <span class="type-badge badge-like"><i class="fa-solid fa-heart"></i></span>
                                        </c:when>
                                        <c:when test="${n.type eq 'COMMENT'}">
                                            <span class="type-badge badge-comment"><i class="fa-solid fa-comment"></i></span>
                                        </c:when>
                                        <c:when test="${n.type eq 'FOLLOW'}">
                                            <span class="type-badge badge-follow"><i class="fa-solid fa-user-plus"></i></span>
                                        </c:when>
                                        <c:when test="${n.type eq 'CHAT_MESSAGE'}">
                                            <span class="type-badge badge-chat"><i class="fa-solid fa-envelope"></i></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="type-badge badge-default"><i class="fa-solid fa-circle-info"></i></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="notif-content">
                                    <p class="notif-text">
                                        ${n.message}
                                    </p>
                                    <span class="notif-time">
                                        <i class="fa-regular fa-clock" style="font-size:11px;"></i>
                                        ${n.createdAt}
                                    </span>
                                </div>
                            </div>

                            <!-- Contextual Action Button -->
                            <c:choose>
                                <c:when test="${n.type eq 'FOLLOW' and not empty n.sender}">
                                    <a href="${pageContext.request.contextPath}/creator-hub/creator/${n.sender.id}" class="notif-action-btn">
                                        <i class="fa-regular fa-user"></i> View Profile
                                    </a>
                                </c:when>
                                <c:when test="${(n.type eq 'LIKE' or n.type eq 'COMMENT')}">
                                    <a href="${pageContext.request.contextPath}/creator-hub/feed" class="notif-action-btn">
                                        <i class="fa-solid fa-play"></i> View Post
                                    </a>
                                </c:when>
                                <c:when test="${n.type eq 'CHAT_MESSAGE' and not empty n.sender}">
                                    <a href="${pageContext.request.contextPath}/creator-hub/chat?peerId=${n.sender.id}" class="notif-action-btn">
                                        <i class="fa-regular fa-comment-dots"></i> Reply
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/creator-hub/feed" class="notif-action-btn">
                                        <i class="fa-solid fa-arrow-right"></i> Open
                                    </a>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </c:forEach>
                </div>

                <div id="noFilterMatch" class="text-center py-4 text-muted" style="display:none;">
                    <i class="fa-regular fa-folder-open display-5 mb-2 d-block" style="opacity:0.35;"></i>
                    <p class="mb-0">No activity matching this filter.</p>
                </div>

            </div>
        </div>

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 600,
        easing: 'ease-in-out',
        once: true
    });

    function filterNotifs(category, tabBtn) {
        document.querySelectorAll('.notif-tab').forEach(t => t.classList.remove('active'));
        tabBtn.classList.add('active');

        const items = document.querySelectorAll('.notif-card');
        let visibleCount = 0;

        items.forEach(item => {
            const type = item.getAttribute('data-type');
            let show = false;

            if (category === 'ALL') {
                show = true;
            } else if (category === 'FOLLOW' && type === 'FOLLOW') {
                show = true;
            } else if (category === 'ENGAGEMENT' && (type === 'LIKE' || type === 'COMMENT')) {
                show = true;
            } else if (category === 'CHAT' && type === 'CHAT_MESSAGE') {
                show = true;
            }

            if (show) {
                item.style.display = 'flex';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        const noMatch = document.getElementById('noFilterMatch');
        if (noMatch) {
            noMatch.style.display = (visibleCount === 0 && items.length > 0) ? 'block' : 'none';
        }
    }

    function markAllAsRead() {
        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
        const headers = {};
        if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

        fetch('${pageContext.request.contextPath}/creator-hub/notifications/mark-all-read', {
            method: 'POST',
            headers: headers
        })
        .then(() => {
            document.querySelectorAll('.notif-card.unread').forEach(el => el.classList.remove('unread'));
            const btn = document.querySelector('.mark-read-btn');
            if (btn) btn.innerHTML = '<i class="fa-solid fa-check text-success"></i> All read';
        })
        .catch(console.error);
    }
</script>

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
