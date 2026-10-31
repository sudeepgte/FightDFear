<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
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
    @media (max-width: 768px) { .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 400px; } } </style>
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
@media (max-width: 768px) { .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 400px; } } </style>
        <header class="ch-sub-header" style="position:sticky; top:80px; width:100%; height:60px; background:#fff; border-bottom:1px solid var(--border); z-index:100; display:flex; align-items:center; justify-content:space-between; padding:0 20px;">
        <div style="font-weight:700; font-size:20px; color:var(--accent); display:flex; align-items:center; gap:12px;"><span><i class="fa-solid fa-clapperboard"></i> Creator Hub</span></div>
                <div style="display:flex; align-items:center; gap:8px;">
            <a href="${pageContext.request.contextPath}/creator-hub/profile" title="Profile" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-regular fa-user"></i> <span class="desktop-only">Profile</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/feed" title="CreatorHub" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-solid fa-clapperboard"></i> <span class="desktop-only">CreatorHub</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/chat" title="Chat" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-regular fa-comment-dots"></i> <span class="desktop-only">Chat</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/notifications" title="Notifications" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-regular fa-bell"></i> <span class="desktop-only">Notifications</span></a>
            <a href="${pageContext.request.contextPath}/creator-hub/dashboard" title="Settings" style="padding:0 14px; border-radius:20px; font-weight:600; font-size:14px; display:flex; align-items:center; gap:6px; color:var(--text); text-decoration:none;"><i class="fa-solid fa-gear"></i> <span class="desktop-only">Settings</span></a>
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
            <a href="${pageContext.request.contextPath}/creator-hub/chat" class="ls-item active">
                <i class="fa-regular fa-comment-dots"></i> Chat
                
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/notifications" class="ls-item">
                <i class="fa-regular fa-bell"></i> Notifications
                <c:if test="${unreadNotifCount > 0}"><span class="ls-badge">${unreadNotifCount}</span></c:if>
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="ls-item">
                <i class="fa-solid fa-gear"></i> Settings
            </a>
            <div style="margin:20px 0;"></div>

        </div>


        <!-- RIGHT CHAT AREA (WhatsApp Style) -->
        <div class="chat-container" style="width:100%; max-width:1200px; flex:1; background:var(--card); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; display:flex; height:calc(100vh - 120px); position:sticky; top:80px;">
            
            <!-- Chat Sidebar (Users List) -->
            <div style="width:330px; border-right:1px solid var(--border); display:flex; flex-direction:column; background:var(--bg);">
                <div style="padding:15px; border-bottom:1px solid var(--border);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                        <h3 style="margin:0; font-size:18px; font-weight:700;">Messages</h3>
                    </div>

                    <!-- Navigation Tabs: Chats vs Message Requests -->
                    <div style="display:flex; border-bottom:1px solid var(--border); gap:8px; margin-bottom:12px;">
                        <button id="tabChatsBtn" onclick="switchSidebarTab('chats')" class="chat-tab-btn active" style="background:none; border:none; padding:8px 6px; font-size:14px; font-weight:700; color:var(--accent); border-bottom:2px solid var(--accent); cursor:pointer; display:flex; align-items:center; gap:6px;">
                            <span>Chats</span>
                            <span id="chatsCountBadge" style="background:var(--accent-soft); color:var(--accent); font-size:11px; font-weight:700; border-radius:10px; padding:2px 7px;">${fn:length(chatUsers)}</span>
                        </button>
                        <button id="tabRequestsBtn" onclick="switchSidebarTab('requests')" class="chat-tab-btn" style="background:none; border:none; padding:8px 6px; font-size:14px; font-weight:600; color:var(--sub); border-bottom:2px solid transparent; cursor:pointer; display:flex; align-items:center; gap:6px;">
                            <span>Requests</span>
                            <span id="requestsCountBadge" style="${fn:length(messageRequests) > 0 ? 'background:var(--accent); color:white;' : 'background:var(--border); color:var(--sub);'} font-size:11px; font-weight:700; border-radius:10px; padding:2px 7px;">${fn:length(messageRequests)}</span>
                        </button>
                    </div>

                    <div style="position:relative;">
                        <i class="fa-solid fa-search" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:var(--sub);"></i>
                        <input type="text" id="userSearch" placeholder="Search users..." onkeyup="filterUsers()" style="width:100%; padding:9px 10px 9px 34px; border-radius:20px; border:1px solid var(--border); background:var(--card); outline:none; font-size:13px;">
                    </div>
                </div>

                <!-- 1. Followed Users / Active Chats List -->
                <div id="chatUsersList" style="flex:1; overflow-y:auto; padding:10px;">
                    <c:if test="${empty chatUsers}">
                        <div class="empty-chat-notice" style="text-align:center; padding:30px 15px; color:var(--sub); font-size:13px;">
                            <i class="fa-regular fa-comments mb-2" style="font-size:28px; opacity:0.4;"></i>
                            <div>No conversations yet. Follow creators to start chatting!</div>
                        </div>
                    </c:if>
                    <c:forEach var="friend" items="${chatUsers}">
                        <div class="chat-user-item" onclick="openChatWith(${friend.id}, '${friend.fullName}', '${not empty friend.profilePhoto ? friend.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}', true)" data-user-id="${friend.id}" data-name="${fn:toLowerCase(friend.fullName)}" style="display:flex; align-items:center; padding:11px; border-radius:12px; cursor:pointer; transition:background 0.2s; margin-bottom:4px; position:relative;">
                            <img src="${not empty friend.profilePhoto ? friend.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';" style="width:44px; height:44px; border-radius:50%; object-fit:cover; margin-right:12px; flex-shrink:0;">
                            <div style="flex:1; min-width:0;">
                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                    <div style="font-weight:600; font-size:14px; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${friend.fullName}</div>
                                    <c:if test="${not empty unreadCounts[friend.id] && unreadCounts[friend.id] > 0}">
                                        <span class="user-unread-badge" style="background:var(--accent); color:white; font-size:11px; font-weight:700; padding:2px 7px; border-radius:10px; margin-left:6px;">${unreadCounts[friend.id]}</span>
                                    </c:if>
                                </div>
                                <div class="user-last-msg" style="font-size:12px; color:var(--sub); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">Tap to chat</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 2. Message Requests List (Unfollowed Users) -->
                <div id="messageRequestsList" style="flex:1; overflow-y:auto; padding:10px; display:none;">
                    <c:if test="${empty messageRequests}">
                        <div class="empty-chat-notice" style="text-align:center; padding:30px 15px; color:var(--sub); font-size:13px;">
                            <i class="fa-regular fa-envelope-open mb-2" style="font-size:28px; opacity:0.4;"></i>
                            <div>No message requests right now.</div>
                        </div>
                    </c:if>
                    <c:forEach var="requestUser" items="${messageRequests}">
                        <div class="chat-user-item request-item" onclick="openChatWith(${requestUser.id}, '${requestUser.fullName}', '${not empty requestUser.profilePhoto ? requestUser.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}', false)" data-user-id="${requestUser.id}" data-name="${fn:toLowerCase(requestUser.fullName)}" style="display:flex; align-items:center; padding:11px; border-radius:12px; cursor:pointer; transition:background 0.2s; margin-bottom:4px; position:relative; background:rgba(244,63,94,0.03);">
                            <img src="${not empty requestUser.profilePhoto ? requestUser.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';" style="width:44px; height:44px; border-radius:50%; object-fit:cover; margin-right:12px; border:2px solid #fecdd3; flex-shrink:0;">
                            <div style="flex:1; min-width:0;">
                                <div style="display:flex; justify-content:space-between; align-items:center;">
                                    <div style="font-weight:600; font-size:14px; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${requestUser.fullName}</div>
                                    <c:if test="${not empty unreadCounts[requestUser.id] && unreadCounts[requestUser.id] > 0}">
                                        <span class="user-unread-badge" style="background:var(--accent); color:white; font-size:11px; font-weight:700; padding:2px 7px; border-radius:10px; margin-left:6px;">${unreadCounts[requestUser.id]}</span>
                                    </c:if>
                                </div>
                                <div class="user-last-msg" style="font-size:12px; color:var(--accent); font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><i class="fa-solid fa-envelope me-1"></i>Message Request</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Chat Main Window -->
            <div id="chatMainWindow" style="flex:1; min-width:0; display:flex; flex-direction:column; background:var(--card); position:relative;">
                <!-- Placeholder when no user selected -->
                <div id="chatPlaceholder" style="position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center; color:var(--sub); z-index:10; background:var(--card);">
                    <i class="fa-regular fa-paper-plane" style="font-size:64px; margin-bottom:20px; opacity:0.3;"></i>
                    <h2>Your Messages</h2>
                    <p>Select a conversation or a message request from the left.</p>
                </div>

                <!-- Active Chat Interface -->
                <div id="activeChat" style="display:none; flex:1; flex-direction:column; min-height:0;">
                    <div style="padding:15px 20px; border-bottom:1px solid var(--border); display:flex; align-items:center; justify-content:space-between; background:var(--bg);">
                        <div style="display:flex; align-items:center; min-width:0;">
                            <img id="chatHeaderImg" src="" style="width:40px; height:40px; border-radius:50%; object-fit:cover; margin-right:15px; flex-shrink:0;">
                            <div style="min-width:0;">
                                <h3 id="chatHeaderName" style="margin:0; font-size:16px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">User Name</h3>
                                <div id="chatHeaderStatus" style="font-size:12px; color:var(--sub);">Direct Message</div>
                            </div>
                        </div>
                        <div style="display:flex; gap:15px; color:var(--accent); font-size:18px; cursor:pointer;">
                            <i class="fa-solid fa-phone" onclick="startCall()" title="Audio Call"></i>
                            <i class="fa-solid fa-video" onclick="startVideoCall()" title="Video Call"></i>
                        </div>
                    </div>

                    <!-- Message Request Warning & Accept Banner -->
                    <div id="requestBanner" style="display:none; padding:12px 20px; background:linear-gradient(90deg, rgba(244,63,94,0.12), rgba(139,92,246,0.12)); border-bottom:1px solid var(--border); align-items:center; justify-content:space-between; gap:12px;">
                        <div style="font-size:13px; color:var(--text); display:flex; align-items:center; gap:8px;">
                            <i class="fa-solid fa-shield-halved" style="color:var(--accent); font-size:16px;"></i>
                            <span><strong>Message Request:</strong> You are not following this user.</span>
                        </div>
                        <button id="btnFollowAndAccept" onclick="followAndAcceptUser()" style="background:var(--accent); color:white; border:none; padding:6px 16px; border-radius:20px; font-weight:700; font-size:12px; cursor:pointer; display:flex; align-items:center; gap:6px; box-shadow:0 2px 6px rgba(244,63,94,0.3); transition:transform 0.2s;">
                            <i class="fa-solid fa-user-plus"></i> Follow Back / Accept
                        </button>
                    </div>
                    
                    <div id="chatMessagesArea" style="flex:1; overflow-y:auto; padding:20px; display:flex; flex-direction:column; gap:10px; min-height:0;">
                    </div>

                    <div id="chatInputArea" style="padding:15px; border-top:1px solid var(--border); background:var(--bg); display:flex; align-items:center; gap:12px; position:relative;">
                        <i class="fa-regular fa-face-smile" style="font-size:24px; color:var(--sub); cursor:pointer;" onclick="togglePicker('emoji')"></i>
                        <i class="fa-solid fa-note-sticky" style="font-size:24px; color:var(--sub); cursor:pointer;" onclick="togglePicker('sticker')"></i>
                        <span style="font-size:18px; font-weight:bold; color:var(--sub); cursor:pointer;" onclick="togglePicker('gif')">GIF</span>
                        
                        <div id="mediaPicker" style="display:none; position:absolute; bottom:65px; left:10px; width:300px; background:var(--card); border:1px solid var(--border); border-radius:12px; padding:12px; box-shadow:0 5px 15px rgba(0,0,0,0.15); z-index:50; flex-direction:column;">
                            <!-- Emoji content -->
                            <div id="picker-emoji" style="display:none; flex-wrap:wrap; gap:8px; font-size:22px;">
                                <span onclick="addChatEmoji('😂')" style="cursor:pointer;">😂</span><span onclick="addChatEmoji('😍')" style="cursor:pointer;">😍</span><span onclick="addChatEmoji('🔥')" style="cursor:pointer;">🔥</span><span onclick="addChatEmoji('❤️')" style="cursor:pointer;">❤️</span><span onclick="addChatEmoji('👍')" style="cursor:pointer;">👍</span><span onclick="addChatEmoji('🤣')" style="cursor:pointer;">🤣</span><span onclick="addChatEmoji('😭')" style="cursor:pointer;">😭</span><span onclick="addChatEmoji('🥺')" style="cursor:pointer;">🥺</span><span onclick="addChatEmoji('🥰')" style="cursor:pointer;">🥰</span><span onclick="addChatEmoji('✨')" style="cursor:pointer;">✨</span><span onclick="addChatEmoji('👏')" style="cursor:pointer;">👏</span><span onclick="addChatEmoji('🙌')" style="cursor:pointer;">🙌</span>
                            </div>
                            <!-- Sticker content -->
                            <div id="picker-sticker" style="display:none; flex-wrap:wrap; gap:8px;">
                                <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f600/512.gif" width="48" style="cursor:pointer;" onclick="addChatEmoji('STICKER:https://fonts.gstatic.com/s/e/notoemoji/latest/1f600/512.gif')">
                                <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f973/512.gif" width="48" style="cursor:pointer;" onclick="addChatEmoji('STICKER:https://fonts.gstatic.com/s/e/notoemoji/latest/1f973/512.gif')">
                                <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f496/512.gif" width="48" style="cursor:pointer;" onclick="addChatEmoji('STICKER:https://fonts.gstatic.com/s/e/notoemoji/latest/1f496/512.gif')">
                                <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f60e/512.gif" width="48" style="cursor:pointer;" onclick="addChatEmoji('STICKER:https://fonts.gstatic.com/s/e/notoemoji/latest/1f60e/512.gif')">
                            </div>
                            <!-- GIF content -->
                            <div id="picker-gif" style="display:none; flex-wrap:wrap; gap:8px;">
                                <img src="https://media.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.gif" width="80" style="cursor:pointer; border-radius:4px;" onclick="addChatEmoji('STICKER:https://media.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.gif')">
                                <img src="https://media.giphy.com/media/3o7TKSjRrfIPjeiVyM/giphy.gif" width="80" style="cursor:pointer; border-radius:4px;" onclick="addChatEmoji('STICKER:https://media.giphy.com/media/3o7TKSjRrfIPjeiVyM/giphy.gif')">
                                <img src="https://media.giphy.com/media/l41YkxvU8c7J7Bba0/giphy.gif" width="80" style="cursor:pointer; border-radius:4px;" onclick="addChatEmoji('STICKER:https://media.giphy.com/media/l41YkxvU8c7J7Bba0/giphy.gif')">
                            </div>
                        </div>
                        <input type="text" id="chatInputMsg" placeholder="Type a message..." style="flex:1; padding:12px 18px; border-radius:24px; border:1px solid var(--border); background:var(--card); outline:none;" onkeypress="if(event.key==='Enter') sendChatMessage()">
                        <input type="file" id="chatFileInput" style="display:none;" accept="image/*,video/*" onchange="handleFileUpload(event)">
                        <i class="fa-solid fa-paperclip" style="color:var(--sub); cursor:pointer; font-size:20px;" onclick="triggerFileUpload()"></i>
                        <i class="fa-solid fa-moon theme-toggle" onclick="toggleTheme()"></i>
                        <button onclick="sendChatMessage()" style="flex-shrink:0; width:45px; height:45px; border-radius:50%; border:none; background:var(--accent); color:white; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:opacity 0.2s;">
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>
    
    <!-- Global Delete Modal -->
    <div id="deleteModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; flex-direction:column; align-items:center; justify-content:center;">
        <div style="background:var(--card); width:300px; border-radius:16px; padding:20px; box-shadow:0 10px 25px rgba(0,0,0,0.2); display:flex; flex-direction:column; gap:10px;">
            <h3 style="margin:0 0 10px 0; text-align:center; font-size:18px;">Delete Message</h3>
            <button id="btnDeleteForMe" style="padding:12px; border:none; border-radius:8px; background:var(--bg); color:var(--text); cursor:pointer; font-weight:600; font-size:15px; border:1px solid var(--border); transition:background 0.2s;"><i class="fa-solid fa-trash-can" style="margin-right:8px;"></i>Delete for me</button>
            <button id="btnDeleteForEveryone" style="padding:12px; border:none; border-radius:8px; background:#fef2f2; color:#dc2626; cursor:pointer; font-weight:600; font-size:15px; border:1px solid #fecaca; transition:background 0.2s;"><i class="fa-solid fa-trash-can" style="margin-right:8px;"></i>Delete for everyone</button>
            <button onclick="document.getElementById('deleteModal').style.display='none'" style="padding:12px; border:none; border-radius:8px; background:transparent; color:var(--sub); cursor:pointer; font-weight:600; font-size:15px; margin-top:5px;">Cancel</button>
        </div>
    </div>

    <!-- Floating In-Chat Toast Notification Container -->
    <div id="chatToastContainer" style="position:fixed; top:90px; right:24px; z-index:99999; display:flex; flex-direction:column; gap:10px; pointer-events:none;"></div>
    
    <style>
        .chat-user-item:hover { background:var(--border) !important; }
        .chat-user-item.active { background:var(--border) !important; }
        .chat-tab-btn { transition: all 0.2s; outline: none; }
        .chat-tab-btn:hover { color: var(--accent) !important; }
        .user-unread-badge { animation: pulseBadge 1.5s infinite; }
        @keyframes pulseBadge {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        @keyframes slideInToast {
            from { opacity: 0; transform: translateX(60px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .msg-bubble { max-width:70%; padding:10px 32px 10px 15px; border-radius:18px; font-size:14px; line-height:1.4; word-wrap:break-word; position:relative; display:flex; flex-direction:column; }
        .msg-mine { background:var(--accent); color:white; align-self:flex-end; border-bottom-right-radius:4px; }
        .msg-theirs { background:var(--bg); color:var(--text); align-self:flex-start; border-bottom-left-radius:4px; border:1px solid var(--border); }
        .msg-time { font-size:10px; margin-top:4px; opacity:0.8; align-self:flex-end; display: flex; align-items: center; gap: 4px; }
        .msg-seen { color: #A7F3D0; }
        
        body.dark-mode {
            --bg: #0F172A;
            --card: #1E293B;
            --text: #F8FAFC;
            --border: #334155;
            --sub: #94A3B8;
        }
        body { transition: background 0.3s, color 0.3s; }
        .theme-toggle { cursor:pointer; font-size: 20px; color: var(--sub); margin-right: 15px; transition: 0.2s; }
        .theme-toggle:hover { color: var(--accent); }
        
        .chat-img-preview { max-width: 100%; max-height: 300px; object-fit: cover; border-radius: 8px; margin-top: 5px; }
        @media (max-width: 768px) { 
            .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } 
            .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 380px; } 
        }
    </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
        let currentPeerId = null;
        let currentPeerName = '';
        let currentPeerPhoto = '';
        let currentIsFollowed = true;
        let chatInterval = null;
        let stompClient = null;
        const myId = ${currentUser.id};

        // Followed user IDs tracked on client
        const followingIdsSet = new Set([
            <c:forEach var="fid" items="${followingIds}" varStatus="status">
                ${fid}${!status.last ? ',' : ''}
            </c:forEach>
        ]);

        <c:choose>
            <c:when test="${not empty activePeerId}">
                const serverActivePeerId = ${activePeerId};
                const serverActivePeerName = "${activePeerUser != null ? activePeerUser.fullName : ''}";
                const serverActivePeerPhoto = "${activePeerUser != null && not empty activePeerUser.profilePhoto ? activePeerUser.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}";
            </c:when>
            <c:otherwise>
                const serverActivePeerId = null;
                const serverActivePeerName = '';
                const serverActivePeerPhoto = '';
            </c:otherwise>
        </c:choose>

        document.addEventListener('DOMContentLoaded', () => {
            if (localStorage.getItem('chatDarkMode') === 'true') {
                document.body.classList.add('dark-mode');
            }
            
            // Check if server or URL provided peerId or user
            const urlParams = new URLSearchParams(window.location.search);
            const queryPeerId = urlParams.get('peerId') || urlParams.get('user');
            const targetPeerId = serverActivePeerId || queryPeerId;

            if (targetPeerId) {
                const targetIsFollowed = followingIdsSet.has(Number(targetPeerId));
                if (!targetIsFollowed) {
                    switchSidebarTab('requests');
                } else {
                    switchSidebarTab('chats');
                }
                const existingEl = document.querySelector(`.chat-user-item[data-user-id="${targetPeerId}"]`);
                if (existingEl) {
                    existingEl.click();
                } else if (serverActivePeerName) {
                    openChatWith(targetPeerId, serverActivePeerName, serverActivePeerPhoto, targetIsFollowed);
                } else {
                    fetch('${pageContext.request.contextPath}/api/chat/user-info?userId=' + targetPeerId)
                        .then(r => r.json())
                        .then(u => {
                            if (u && u.id) {
                                openChatWith(u.id, u.fullName, u.profilePhoto || '${pageContext.request.contextPath}/assets/img/default-avatar.png', targetIsFollowed);
                            }
                        }).catch(() => {});
                }
            } else {
                const savedPeer = sessionStorage.getItem('activeChatPeerId');
                if (savedPeer) {
                    const userEl = document.querySelector(`.chat-user-item[data-user-id="${savedPeer}"]`);
                    if (userEl) userEl.click();
                }
            }

            connectSTOMP();
        });

        function toggleTheme() {
            document.body.classList.toggle('dark-mode');
            localStorage.setItem('chatDarkMode', document.body.classList.contains('dark-mode'));
        }

        function switchSidebarTab(tab) {
            const chatsList = document.getElementById('chatUsersList');
            const reqList = document.getElementById('messageRequestsList');
            const tabChats = document.getElementById('tabChatsBtn');
            const tabReqs = document.getElementById('tabRequestsBtn');
            
            if (tab === 'chats') {
                chatsList.style.display = 'block';
                reqList.style.display = 'none';
                tabChats.classList.add('active');
                tabChats.style.color = 'var(--accent)';
                tabChats.style.borderBottomColor = 'var(--accent)';
                tabReqs.classList.remove('active');
                tabReqs.style.color = 'var(--sub)';
                tabReqs.style.borderBottomColor = 'transparent';
            } else {
                chatsList.style.display = 'none';
                reqList.style.display = 'block';
                tabReqs.classList.add('active');
                tabReqs.style.color = 'var(--accent)';
                tabReqs.style.borderBottomColor = 'var(--accent)';
                tabChats.classList.remove('active');
                tabChats.style.color = 'var(--sub)';
                tabChats.style.borderBottomColor = 'transparent';
            }
        }

        let stompReconnectTimeout = null;
        function connectSTOMP() {
            try {
                const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
                stompClient = Stomp.over(socket);
                stompClient.debug = null;
                stompClient.connect({}, function () {
                    if (stompReconnectTimeout) {
                        clearTimeout(stompReconnectTimeout);
                        stompReconnectTimeout = null;
                    }
                    stompClient.subscribe("/topic/messages/" + myId, function (response) {
                        const msg = JSON.parse(response.body);
                        
                        if (msg.action === 'DELETE') {
                            const el = document.getElementById('msg-'+msg.id);
                            if (el) {
                                const timeNode = el.querySelector('.msg-time');
                                el.innerHTML = '<i style="opacity:0.6;">This message was deleted</i>';
                                if (timeNode) el.appendChild(timeNode);
                                el.onclick = null;
                                el.style.cursor = 'default';
                            }
                            return;
                        }

                        const senderId = Number(msg.senderId || (msg.sender ? msg.sender.id : null));
                        const senderName = msg.senderName || (msg.sender ? msg.sender.fullName : 'Someone');
                        const senderPhoto = msg.senderPhoto || (msg.sender && msg.sender.profilePhoto ? msg.sender.profilePhoto : '${pageContext.request.contextPath}/assets/img/default-avatar.png');
                        const text = msg.message || 'Sent an attachment';

                        // 1. If currently chatting with this user:
                        if (currentPeerId && Number(currentPeerId) === senderId) {
                            appendMessage(msg, false);
                            // Mark as read immediately on backend
                            fetch('${pageContext.request.contextPath}/api/chat/messages?peerId=' + currentPeerId).catch(()=>{});
                            return;
                        }

                        // 2. Sender is not in the active view:
                        const isFollowed = (msg.isFollowed === true) || followingIdsSet.has(senderId);

                        if (isFollowed) {
                            // Followed user: show in-chat notification & increment badge in Chats
                            showInChatToast('💬 ' + senderName, text, () => {
                                switchSidebarTab('chats');
                                openChatWith(senderId, senderName, senderPhoto, true);
                            }, true, senderPhoto);
                            incrementUnreadBadge(senderId, senderName, senderPhoto, true, text);
                        } else {
                            // Unfollowed user: Message Request!
                            showInChatToast('📩 Request from ' + senderName, text, () => {
                                switchSidebarTab('requests');
                                openChatWith(senderId, senderName, senderPhoto, false);
                            }, false, senderPhoto);
                            incrementUnreadBadge(senderId, senderName, senderPhoto, false, text);
                            incrementRequestsCount();
                        }
                    });
                }, function (err) {
                    if (!stompReconnectTimeout) {
                        stompReconnectTimeout = setTimeout(connectSTOMP, 5000);
                    }
                });
            } catch (e) {
                if (!stompReconnectTimeout) {
                    stompReconnectTimeout = setTimeout(connectSTOMP, 5000);
                }
            }
        }

        function showInChatToast(title, message, onClickAction, isFollowed = true, avatarUrl = null) {
            const container = document.getElementById('chatToastContainer');
            if (!container) return;

            const toast = document.createElement('div');
            toast.className = 'chat-toast-card';
            toast.style.cssText = 'display:flex; align-items:center; gap:12px; padding:12px 16px; border-radius:14px; background:var(--card); color:var(--text); border:1px solid ' + (isFollowed ? 'var(--accent)' : '#8b5cf6') + '; box-shadow:0 10px 30px rgba(0,0,0,0.18), 0 0 12px ' + (isFollowed ? 'rgba(244,63,94,0.25)' : 'rgba(139,92,246,0.25)') + '; cursor:pointer; min-width:280px; max-width:360px; animation:slideInToast 0.3s cubic-bezier(0.16, 1, 0.3, 1); transition:transform 0.2s, opacity 0.2s; position:relative; pointer-events:auto;';

            const imgHtml = avatarUrl 
                ? '<img src="' + avatarUrl + '" onerror="this.src=\'${pageContext.request.contextPath}/assets/img/default-avatar.png\';" style="width:40px; height:40px; border-radius:50%; object-fit:cover; flex-shrink:0;">'
                : '<div style="width:40px; height:40px; border-radius:50%; background:' + (isFollowed ? 'var(--accent-soft)' : '#ede9fe') + '; display:flex; align-items:center; justify-content:center; color:' + (isFollowed ? 'var(--accent)' : '#8b5cf6') + '; flex-shrink:0;"><i class="' + (isFollowed ? 'fa-solid fa-comment-dots' : 'fa-solid fa-envelope') + '"></i></div>';

            const previewText = message.startsWith('[IMAGE:') ? '📷 Sent a photo' : (message.length > 50 ? message.substring(0, 47) + '...' : message);

            toast.innerHTML = imgHtml + 
                '<div style="flex:1; min-width:0;">' +
                    '<div style="font-weight:700; font-size:13px; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + title + '</div>' +
                    '<div style="font-size:12px; color:var(--sub); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + previewText + '</div>' +
                '</div>' +
                '<button style="background:none; border:none; color:var(--sub); font-size:16px; cursor:pointer; padding:4px;" onclick="event.stopPropagation(); this.parentElement.remove();">&times;</button>';

            toast.onclick = function() {
                toast.remove();
                if (onClickAction) onClickAction();
            };

            container.appendChild(toast);
            setTimeout(() => {
                if (toast.parentElement) {
                    toast.style.opacity = '0';
                    toast.style.transform = 'translateY(-10px)';
                    setTimeout(() => toast.remove(), 250);
                }
            }, 6000);
        }

        function incrementUnreadBadge(userId, userName, userPhoto, isFollowed, lastMsg) {
            let listId = isFollowed ? 'chatUsersList' : 'messageRequestsList';
            let userEl = document.querySelector(`.chat-user-item[data-user-id="${userId}"]`);
            
            if (!userEl) {
                userEl = document.createElement('div');
                userEl.className = 'chat-user-item' + (!isFollowed ? ' request-item' : '');
                userEl.setAttribute('data-user-id', userId);
                userEl.setAttribute('data-name', userName.toLowerCase());
                userEl.style.cssText = 'display:flex; align-items:center; padding:11px; border-radius:12px; cursor:pointer; transition:background 0.2s; margin-bottom:4px; position:relative;' + (!isFollowed ? ' background:rgba(244,63,94,0.03);' : '');
                userEl.onclick = function() { openChatWith(userId, userName, userPhoto, isFollowed); };
                
                userEl.innerHTML = 
                    '<img src="' + userPhoto + '" onerror="this.src=\'${pageContext.request.contextPath}/assets/img/default-avatar.png\';" style="width:44px; height:44px; border-radius:50%; object-fit:cover; margin-right:12px; ' + (!isFollowed ? 'border:2px solid #fecdd3;' : '') + ' flex-shrink:0;">' +
                    '<div style="flex:1; min-width:0;">' +
                        '<div style="display:flex; justify-content:space-between; align-items:center;">' +
                            '<div style="font-weight:600; font-size:14px; color:var(--text); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + userName + '</div>' +
                            '<span class="user-unread-badge" style="background:var(--accent); color:white; font-size:11px; font-weight:700; padding:2px 7px; border-radius:10px; margin-left:6px;">1</span>' +
                        '</div>' +
                        '<div class="user-last-msg" style="font-size:12px; color:' + (isFollowed ? 'var(--sub)' : 'var(--accent)') + '; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' +
                            (isFollowed ? (lastMsg.length > 25 ? lastMsg.substring(0, 22) + '...' : lastMsg) : '<i class="fa-solid fa-envelope me-1"></i>New Request') +
                        '</div>' +
                    '</div>';

                const listContainer = document.getElementById(listId);
                if (listContainer) {
                    const emptyNotice = listContainer.querySelector('.empty-chat-notice');
                    if (emptyNotice) emptyNotice.remove();
                    listContainer.prepend(userEl);
                }
            } else {
                let badge = userEl.querySelector('.user-unread-badge');
                if (!badge) {
                    const nameRow = userEl.querySelector('div[style*="justify-content:space-between"]');
                    if (nameRow) {
                        badge = document.createElement('span');
                        badge.className = 'user-unread-badge';
                        badge.style.cssText = 'background:var(--accent); color:white; font-size:11px; font-weight:700; padding:2px 7px; border-radius:10px; margin-left:6px;';
                        badge.innerText = '1';
                        nameRow.appendChild(badge);
                    }
                } else {
                    const cur = parseInt(badge.innerText || '0', 10);
                    badge.innerText = cur + 1;
                }
                const note = userEl.querySelector('.user-last-msg');
                if (note) {
                    note.innerText = lastMsg.startsWith('[IMAGE:') ? '📷 Photo' : (lastMsg.length > 25 ? lastMsg.substring(0, 22) + '...' : lastMsg);
                }
            }
        }

        function incrementRequestsCount() {
            const badge = document.getElementById('requestsCountBadge');
            if (badge) {
                let count = parseInt(badge.innerText || '0', 10) + 1;
                badge.innerText = count;
                badge.style.background = 'var(--accent)';
                badge.style.color = 'white';
            }
        }

        function decrementRequestsCount() {
            const badge = document.getElementById('requestsCountBadge');
            if (badge) {
                let count = Math.max(0, parseInt(badge.innerText || '0', 10) - 1);
                badge.innerText = count;
                if (count === 0) {
                    badge.style.background = 'var(--border)';
                    badge.style.color = 'var(--sub)';
                }
            }
        }

        function followAndAcceptUser() {
            if (!currentPeerId) return;
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            const headers = {};
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

            const btn = document.getElementById('btnFollowAndAccept');
            if (btn) btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Following...';

            fetch('${pageContext.request.contextPath}/creator-hub/creator/follow/' + currentPeerId, {
                method: 'POST',
                headers: headers
            })
            .then(r => r.json())
            .then(data => {
                if (data.status === 'FOLLOWED') {
                    followingIdsSet.add(Number(currentPeerId));
                    currentIsFollowed = true;
                    const banner = document.getElementById('requestBanner');
                    if (banner) banner.style.display = 'none';

                    const statusNode = document.getElementById('chatHeaderStatus');
                    if (statusNode) statusNode.innerText = 'Direct Message · Following';

                    // Move from Requests list to Chats list
                    const reqItem = document.querySelector(`#messageRequestsList .chat-user-item[data-user-id="${currentPeerId}"]`);
                    if (reqItem) {
                        reqItem.classList.remove('request-item');
                        reqItem.style.background = '';
                        const img = reqItem.querySelector('img');
                        if (img) img.style.border = 'none';
                        reqItem.onclick = function() { openChatWith(currentPeerId, currentPeerName, currentPeerPhoto, true); };
                        const note = reqItem.querySelector('.user-last-msg');
                        if (note) {
                            note.style.color = 'var(--sub)';
                            note.innerHTML = 'Following · Tap to chat';
                        }
                        const chatsContainer = document.getElementById('chatUsersList');
                        const emptyNotice = chatsContainer.querySelector('.empty-chat-notice');
                        if (emptyNotice) emptyNotice.remove();
                        chatsContainer.prepend(reqItem);
                        decrementRequestsCount();
                    }
                    showInChatToast('Followed!', 'You are now following ' + currentPeerName + '. Chat moved to Chats.', null, true);
                } else {
                    if (btn) btn.innerHTML = '<i class="fa-solid fa-user-plus"></i> Follow Back / Accept';
                }
            })
            .catch(err => {
                console.error(err);
                if (btn) btn.innerHTML = '<i class="fa-solid fa-user-plus"></i> Follow Back / Accept';
            });
        }

        function togglePicker(type) {
            const picker = document.getElementById('mediaPicker');
            const sections = ['emoji', 'sticker', 'gif'];
            let anyOpen = false;
            
            sections.forEach(s => {
                const el = document.getElementById('picker-' + s);
                if (s === type) {
                    if (el.style.display === 'flex') {
                        el.style.display = 'none';
                    } else {
                        el.style.display = 'flex';
                        anyOpen = true;
                    }
                } else {
                    el.style.display = 'none';
                }
            });
            picker.style.display = anyOpen ? 'flex' : 'none';
        }
        
        function addChatEmoji(emj) {
            if (emj.startsWith('STICKER:')) {
                const url = emj.substring(8);
                sendChatMessage('[IMAGE:' + url + ']');
                document.getElementById('mediaPicker').style.display = 'none';
                return;
            }
            document.getElementById('chatInputMsg').value += emj;
            document.getElementById('mediaPicker').style.display = 'none';
        }

        function deleteMessage(msgId, type) {
            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            const headers = {};
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;

            fetch('${pageContext.request.contextPath}/api/chat/delete/' + msgId + '?type=' + type, { 
                method: 'POST',
                headers: headers
            })
            .then(r => r.json())
            .then(data => { 
                if (data.success) { 
                    const el = document.getElementById('msg-'+msgId);
                    if (el) {
                        if (type === 'me') {
                            el.style.display = 'none';
                        } else {
                            const timeNode = el.querySelector('.msg-time');
                            el.innerHTML = '<i style="opacity:0.6;">This message was deleted</i>';
                            if (timeNode) el.appendChild(timeNode);
                            el.onclick = null;
                            el.style.cursor = 'default';
                        }
                    }
                } else {
                    alert("Failed to delete message: " + (data.error || "Unknown error"));
                }
            }).catch(err => {
                alert("Network or server error while deleting: " + err);
            });
        }
        
        function triggerFileUpload() {
            document.getElementById('chatFileInput').click();
        }

        function handleFileUpload(event) {
            const file = event.target.files[0];
            if (!file) return;
            
            const formData = new FormData();
            formData.append("file", file);

            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            const headers = {};
            if (csrfToken && csrfHeader) headers[csrfHeader] = csrfToken;
            
            fetch('${pageContext.request.contextPath}/api/chat/upload', {
                method: 'POST',
                headers: headers,
                body: formData
            }).then(r => r.json()).then(data => {
                if (data.success && data.url) {
                    sendChatMessage('[IMAGE:' + data.url + ']');
                }
            }).catch(e => console.error(e));
            
            event.target.value = '';
        }

        function filterUsers() {
            const val = document.getElementById('userSearch').value.toLowerCase();
            document.querySelectorAll('.chat-user-item').forEach(el => {
                const name = (el.getAttribute('data-name') || '').toLowerCase();
                if(name.includes(val)) el.style.display = 'flex';
                else el.style.display = 'none';
            });
        }

        function openChatWith(peerId, name, photoUrl, isFollowed = null) {
            currentPeerId = Number(peerId);
            currentPeerName = name;
            currentPeerPhoto = photoUrl;

            if (isFollowed === null) {
                currentIsFollowed = followingIdsSet.has(currentPeerId);
            } else {
                currentIsFollowed = isFollowed;
            }

            sessionStorage.setItem('activeChatPeerId', currentPeerId);
            
            document.getElementById('chatPlaceholder').style.display = 'none';
            document.getElementById('activeChat').style.display = 'flex';
            document.getElementById('chatHeaderName').innerText = name;
            document.getElementById('chatHeaderImg').src = photoUrl;
            
            const statusNode = document.getElementById('chatHeaderStatus');
            const banner = document.getElementById('requestBanner');
            if (currentIsFollowed) {
                if (statusNode) statusNode.innerText = 'Direct Message · Following';
                if (banner) banner.style.display = 'none';
            } else {
                if (statusNode) statusNode.innerText = 'Message Request · Not following';
                if (banner) banner.style.display = 'flex';
            }

            document.querySelectorAll('.chat-user-item').forEach(el => el.classList.remove('active'));
            const activeUserEl = document.querySelector(`.chat-user-item[data-user-id="${currentPeerId}"]`);
            if (activeUserEl) {
                activeUserEl.classList.add('active');
                const badge = activeUserEl.querySelector('.user-unread-badge');
                if (badge) badge.remove();
            }

            loadMessages();
            if(chatInterval) clearInterval(chatInterval);
            chatInterval = setInterval(loadMessages, 5000);
        }

        function loadMessages() {
            if(!currentPeerId) return;
            fetch('${pageContext.request.contextPath}/api/chat/messages?peerId=' + currentPeerId)
            .then(r => r.json())
            .then(data => {
                if(data.success && data.messages) renderMessages(data.messages);
                else if(Array.isArray(data)) renderMessages(data);
            }).catch(() => {});
        }

        function formatTime(dtString) {
            if(!dtString) return '';
            const d = new Date(dtString);
            return d.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
        }

        function renderMessages(msgs) {
            const area = document.getElementById('chatMessagesArea');
            area.innerHTML = '';
            if(msgs.length === 0) {
                area.innerHTML = '<div style="text-align:center;padding:40px;color:var(--sub);font-size:14px;"><i class="fa-regular fa-paper-plane mb-2" style="font-size:32px;display:block;opacity:0.3;"></i>Say hi and start conversation! 👋</div>';
                return;
            }
            msgs.forEach(m => {
                const senderId = m.senderId || (m.sender ? m.sender.id : null);
                const isMine = (Number(senderId) === Number(myId));
                appendMessage(m, isMine, area, false);
            });
            area.scrollTop = area.scrollHeight;
        }

        function appendMessage(msg, isMine, area = document.getElementById('chatMessagesArea'), scroll = true) {
            if (area.innerHTML.includes('Say hi')) area.innerHTML = '';
            
            const div = document.createElement('div');
            div.id = 'msg-' + msg.id;
            div.className = 'msg-bubble ' + (isMine ? 'msg-mine' : 'msg-theirs');
            
            let contentHtml = msg.message || msg.content || '';
            if(contentHtml === '[DELETED]') {
                contentHtml = '<i style="opacity:0.6;">This message was deleted</i>';
            } else if(contentHtml && contentHtml.startsWith('[IMAGE:')) {
                const url = contentHtml.substring(7, contentHtml.length - 1);
                contentHtml = '<img src="' + url + '" class="chat-img-preview" onload="this.parentElement.parentElement.scrollTop = this.parentElement.parentElement.scrollHeight">';
            }
            
            if (msg.id && contentHtml !== '<i style="opacity:0.6;">This message was deleted</i>') {
                div.style.cursor = 'pointer';
                div.onclick = function() {
                    const modal = document.getElementById('deleteModal');
                    const btnEveryone = document.getElementById('btnDeleteForEveryone');
                    const btnMe = document.getElementById('btnDeleteForMe');
                    
                    if (isMine) {
                        btnEveryone.style.display = 'block';
                    } else {
                        btnEveryone.style.display = 'none';
                    }
                    
                    btnMe.onclick = function() {
                        deleteMessage(msg.id, 'me');
                        modal.style.display = 'none';
                    };
                    
                    btnEveryone.onclick = function() {
                        deleteMessage(msg.id, 'everyone');
                        modal.style.display = 'none';
                    };
                    
                    modal.style.display = 'flex';
                };
            }

            let status = '';
            if (isMine) {
                if(msg.readStatus) {
                    status = '<span class="msg-seen"><i class="fa-solid fa-check-double"></i></span>';
                } else {
                    status = '<span style="color:rgba(255,255,255,0.7)"><i class="fa-solid fa-check"></i></span>';
                }
            }
            
            let timeStr = '';
            let rawTime = msg.timestamp || msg.createdAt || msg.sentAt;
            if (rawTime) {
                const d = new Date(rawTime);
                timeStr = d.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            }
            
            div.innerHTML = contentHtml + '<div class="msg-time">' + timeStr + ' ' + status + '</div>';
            area.appendChild(div);
            if (scroll) area.scrollTop = area.scrollHeight;
        }

        function sendChatMessage(overrideText = null) {
            const input = document.getElementById('chatInputMsg');
            const txt = overrideText || input.value.trim();
            if(!txt || !currentPeerId) return;
            
            if (!overrideText) input.value = '';

            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
            const headers = { 'Content-Type': 'application/json' };
            if (csrfToken && csrfHeader) {
                headers[csrfHeader] = csrfToken;
            }
            
            fetch('${pageContext.request.contextPath}/api/chat/send', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify({ peerId: currentPeerId, message: txt })
            }).then(r => r.json()).then(data => {
                if(data.success && data.message) {
                    appendMessage(data.message, true);
                    const userEl = document.querySelector(`.chat-user-item[data-user-id="${currentPeerId}"]`);
                    if (userEl) {
                        const note = userEl.querySelector('.user-last-msg');
                        if (note) note.innerText = txt.startsWith('[IMAGE:') ? '📷 Photo' : (txt.length > 25 ? txt.substring(0, 22) + '...' : txt);
                    }
                } else {
                    showInChatToast('Chat Error', data.error || 'Failed to send message', null, false);
                }
            }).catch(err => {
                console.error("Failed to send message:", err);
                showInChatToast('Connection Error', 'Failed to send message. Please check connection.', null, false);
            });
        }

        function toggleEmoji() {
            const ep = document.getElementById('emojiPicker');
            if (ep) ep.style.display = ep.style.display === 'flex' ? 'none' : 'flex';
        }

        function startCall() {
            if(!currentPeerId) return;
            window.open('${pageContext.request.contextPath}/chat/call/' + currentPeerId + '?notify=true', '_blank', 'width=400,height=600');
        }
        function startVideoCall() {
            if(!currentPeerId) return;
            window.open('${pageContext.request.contextPath}/chat/video-call/' + currentPeerId + '?notify=true', '_blank', 'width=800,height=600');
        }
    
        function toggleChatPanel() { window.location.href = '${pageContext.request.contextPath}/creator-hub/chat'; }
        function toggleNotifPanel() {}
    </script>
    <style>@keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }@media (max-width: 768px) { body { padding-bottom: 80px; } .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 400px; } #chatInputArea { gap: 4px !important; padding: 8px 4px !important; flex-wrap: nowrap !important; } #chatInputMsg { min-width: 100px !important; padding: 8px 10px !important; font-size: 14px !important; } #chatInputArea > i, #chatInputArea > span { font-size: 16px !important; } .theme-toggle { display: none !important; } } @media (max-width: 480px) { .chat-container > div:first-child { max-height: 180px !important; } #chatInputArea { padding: 6px 2px !important; gap: 2px !important; } #chatInputMsg { padding: 6px 8px !important; font-size: 12px !important; } #chatInputArea > i, #chatInputArea > span { font-size: 14px !important; } .msg-bubble { max-width: 85% !important; font-size: 12px !important; padding: 8px 12px !important; } } </style>
        </div>
    </div>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>





















