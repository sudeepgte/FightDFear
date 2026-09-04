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
            <a href="${pageContext.request.contextPath}/creator-hub/chat" class="ls-item active">
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


        <!-- RIGHT CHAT AREA (WhatsApp Style) -->
        <div class="chat-container" style="width:100%; max-width:1200px; flex:1; background:var(--card); border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; display:flex; height:calc(100vh - 120px); position:sticky; top:80px;">
            
            <!-- Chat Sidebar (Users List) -->
            <div style="width:320px; border-right:1px solid var(--border); display:flex; flex-direction:column; background:var(--bg);">
                <div style="padding:15px; border-bottom:1px solid var(--border);">
                    <h3 style="margin:0 0 10px 0; font-size:18px;">Messages</h3>
                    <div style="position:relative;">
                        <i class="fa-solid fa-search" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:var(--sub);"></i>
                        <input type="text" id="userSearch" placeholder="Search friends..." onkeyup="filterUsers()" style="width:100%; padding:10px 10px 10px 35px; border-radius:20px; border:none; background:var(--card); outline:none;">
                    </div>
                </div>
                <div id="chatUsersList" style="flex:1; overflow-y:auto; padding:10px;">
                    <c:if test="${empty chatUsers}">
                        <div style="text-align:center; padding:20px; color:var(--sub);">No friends found. Follow some creators!</div>
                    </c:if>
                    <c:forEach var="friend" items="${chatUsers}">
                        <div class="chat-user-item" onclick="openChatWith(${friend.id}, '${friend.fullName}', '${not empty friend.profilePhoto ? friend.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}')" data-name="${fn:toLowerCase(friend.fullName)}" style="display:flex; align-items:center; padding:12px; border-radius:12px; cursor:pointer; transition:background 0.2s; margin-bottom:5px;">
                            <img src="${not empty friend.profilePhoto ? friend.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/default-avatar.png';" style="width:45px; height:45px; border-radius:50%; object-fit:cover; margin-right:12px;">
                            <div style="flex:1;">
                                <div style="font-weight:600; font-size:15px; color:var(--text);">${friend.fullName}</div>
                                <div style="font-size:13px; color:var(--sub);">Tap to chat</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Chat Main Window -->
            <div style="flex:1; min-width:400px; display:flex; flex-direction:column; background:var(--card); position:relative;">
                <!-- Placeholder when no user selected -->
                <div id="chatPlaceholder" style="position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center; color:var(--sub); z-index:10; background:var(--card);">
                    <i class="fa-regular fa-paper-plane" style="font-size:64px; margin-bottom:20px; opacity:0.3;"></i>
                    <h2>Your Messages</h2>
                    <p>Select a friend from the left to start chatting.</p>
                </div>

                <!-- Active Chat Interface -->
                <div id="activeChat" style="display:none; flex:1; flex-direction:column; min-height:0;">
                    <div style="padding:15px 20px; border-bottom:1px solid var(--border); display:flex; align-items:center; justify-content:space-between; background:var(--bg);">
                        <div style="display:flex; align-items:center;">
                            <img id="chatHeaderImg" src="" style="width:40px; height:40px; border-radius:50%; object-fit:cover; margin-right:15px;">
                            <h3 id="chatHeaderName" style="margin:0; font-size:16px;">User Name</h3>
                        </div>
                        <div style="display:flex; gap:15px; color:var(--accent); font-size:18px; cursor:pointer;">
                            <i class="fa-solid fa-phone" onclick="startCall()"></i>
                            <i class="fa-solid fa-video" onclick="startVideoCall()"></i>
                        </div>
                    </div>
                    
                    <div id="chatMessagesArea" style="flex:1; overflow-y:auto; padding:20px; display:flex; flex-direction:column; gap:10px; min-height:0;">
                    </div>

                    <div style="padding:15px; border-top:1px solid var(--border); background:var(--bg); display:flex; align-items:center; gap:12px; position:relative;">
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
                        <button onclick="sendChatMessage()" style="width:45px; height:45px; border-radius:50%; border:none; background:var(--accent); color:white; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:opacity 0.2s;">
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
    
    <style>
        .chat-user-item:hover { background:var(--border) !important; }
        .chat-user-item.active { background:var(--border) !important; }
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
    @media (max-width: 768px) { .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 400px; } } </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
        let currentPeerId = null;
        let chatInterval = null;
        let stompClient = null;
        const myId = ${currentUser.id};

        document.addEventListener('DOMContentLoaded', () => {
            if (localStorage.getItem('chatDarkMode') === 'true') {
                document.body.classList.add('dark-mode');
            }
            
            const savedPeer = sessionStorage.getItem('activeChatPeerId');
            if (savedPeer) {
                const userEl = document.querySelector(`.chat-user-item[onclick*="openChatWith(${savedPeer}"]`);
                if (userEl) userEl.click();
            }

            connectSTOMP();
        });

        function toggleTheme() {
            document.body.classList.toggle('dark-mode');
            localStorage.setItem('chatDarkMode', document.body.classList.contains('dark-mode'));
        }

        function connectSTOMP() {
            const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;
            stompClient.connect({}, function () {
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
                    
                    if (currentPeerId && (msg.senderId == currentPeerId || (msg.sender && msg.sender.id == currentPeerId))) {
                        appendMessage(msg, false);
                        fetch('${pageContext.request.contextPath}/api/chat/messages?peerId=' + currentPeerId).catch(()=>{});
                    }
                });
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
            fetch('${pageContext.request.contextPath}/api/chat/delete/' + msgId + '?type=' + type, { method: 'POST' })
            .then(r => r.json())
            .then(data => { 
                if (data.success) { 
                    const el = document.getElementById('msg-'+msgId);
                    if (el) {
                        if (type === 'me') {
                            el.style.display = 'none';
                        } else {
                            // The stomp handler will also do this, but we do it optimistically for the sender
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
            
            fetch('${pageContext.request.contextPath}/api/chat/upload', {
                method: 'POST',
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
                if(el.getAttribute('data-name').includes(val)) el.style.display = 'flex';
                else el.style.display = 'none';
            });
        }

        function openChatWith(peerId, name, photoUrl) {
            currentPeerId = peerId;
            sessionStorage.setItem('activeChatPeerId', peerId);
            
            document.getElementById('chatPlaceholder').style.display = 'none';
            document.getElementById('activeChat').style.display = 'flex';
            document.getElementById('chatHeaderName').innerText = name;
            document.getElementById('chatHeaderImg').src = photoUrl;
            
            document.querySelectorAll('.chat-user-item').forEach(el => el.classList.remove('active'));
            event.currentTarget.classList.add('active');

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
                area.innerHTML = '<div style="text-align:center;padding:40px;color:var(--sub);">Say hi! 👋</div>';
                return;
            }
            msgs.forEach(m => {
                const senderId = m.senderId || (m.sender ? m.sender.id : null);
                const isMine = (senderId == myId);
                appendMessage(m, isMine, area, false);
            });
            area.scrollTop = area.scrollHeight;
        }

        function appendMessage(msg, isMine, area = document.getElementById('chatMessagesArea'), scroll = true) {
            if (area.innerHTML.includes('Say hi!')) area.innerHTML = '';
            
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
                    status = '<span style="color:var(--sub)"><i class="fa-solid fa-check"></i></span>';
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
            
            fetch('${pageContext.request.contextPath}/api/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ peerId: currentPeerId, message: txt })
            }).then(r => r.json()).then(data => {
                if(data.success && data.message) {
                    appendMessage(data.message, true);
                }
            }).catch(() => {});
        }

        function toggleEmoji() {
            const ep = document.getElementById('emojiPicker');
            ep.style.display = ep.style.display === 'flex' ? 'none' : 'flex';
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
    <style>@keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }@media (max-width: 768px) { .chat-container { border-radius: 0 !important; border-left: none !important; border-right: none !important; flex-direction: column !important; height: auto !important; position: static !important; } .chat-container > div:first-child { width: 100% !important; border-right: none !important; border-bottom: 1px solid var(--border) !important; max-height: 400px; } } </style>
        </div>
    </div>
</body>
</html>





















