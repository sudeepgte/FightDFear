<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Creator Hub - Feed</title>
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
        body { background: var(--bg); color: var(--text); overflow-y: scroll; }
        a { text-decoration: none; color: inherit; }

        .page-wrapper {
            max-width: 1536px;
            margin: 0 auto;
            padding: 80px 20px 40px;
            display: grid;
            grid-template-columns: 240px 1fr;
            gap: 20px;
            align-items: start;
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
    </style>
</head>
<body>
    
    <!-- Header -->
    <header style="position:fixed; top:0; width:100%; height:60px; background:#fff; border-bottom:1px solid var(--border); z-index:100; display:flex; align-items:center; justify-content:space-between; padding:0 20px;">
        <div style="font-weight:700; font-size:20px; color:var(--accent);">
            <i class="fa-solid fa-fire"></i> Fight D Fear
        </div>
        <div style="display:flex; align-items:center; gap:20px;">
            <a href="${pageContext.request.contextPath}/"><i class="fa-solid fa-house" style="font-size:18px; color:var(--text);"></i></a>
            <img src="${not empty currentUser.profilePhoto ? currentUser.profilePhoto : pageContext.request.contextPath += '/assets/img/default-avatar.png'}" style="width:32px; height:32px; border-radius:50%; object-fit:cover;">
        </div>
    </header>

    <div class="page-wrapper">
        <!-- LEFT SIDEBAR -->
        <div class="left-sidebar desktop-sidebar">
            <a href="${pageContext.request.contextPath}/creator-hub/profile" class="ls-item">
                <i class="fa-regular fa-user"></i> Profile
            </a>
            <a href="${pageContext.request.contextPath}/creator-hub/feed" class="ls-item active">
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

        <!-- CENTER FEED -->
        <div class="feed-container">
            <!-- STORIES -->
            <c:if test="${not empty storiesByUser}">
                <div class="stories-box">
                    <c:forEach var="entry" items="${storiesByUser}">
                        <div class="story-item" onclick="viewStory('${entry.value[0].id}', '${entry.key.creatorHandle}', '${not empty entry.key.profilePhoto ? entry.key.profilePhoto : ''}', '${entry.value[0].mediaPath}')">
                            <div class="story-ring">
                                <img src="${not empty entry.key.profilePhoto ? entry.key.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}">
                            </div>
                            <div class="story-name">${entry.key.creatorHandle}</div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- FEED POSTS -->
            <c:if test="${empty feedContent}">
                <div class="empty-feed">
                    <i class="fa-solid fa-camera"></i>
                    <h3>No Posts Yet</h3>
                    <p>Follow creators to see their photos and videos.</p>
                </div>
            </c:if>
            <c:forEach var="item" items="${feedContent}">
                <div class="feed-post">
                    <!-- Header -->
                    <div class="fp-header">
                        <div class="fp-user">
                            <img src="${not empty item.user.profilePhoto ? item.user.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}">
                            ${not empty item.user.creatorHandle ? item.user.creatorHandle : item.user.fullName}
                        </div>
                        <c:if test="${item.user.id == currentUser.id}">
                            <i class="fa-solid fa-trash" style="color:var(--accent); cursor:pointer;" onclick="deleteFeedPost(${item.id})" title="Delete Post"></i>
                        </c:if>
                    </div>
                    
                    <!-- Media -->
                    <div class="fp-media">
                        <c:set var="mUrl" value="${fn:startsWith(item.videoPath,'http') ? item.videoPath : pageContext.request.contextPath.concat(item.videoPath)}"/>
                        <c:choose>
                            <c:when test="${fn:endsWith(fn:toLowerCase(item.videoPath), '.mp4')}">
                                <video src="${mUrl}" controls playsinline></video>
                            </c:when>
                            <c:otherwise>
                                <img src="${not empty item.thumbnailPath ? item.thumbnailPath : mUrl}" alt="Post Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Actions -->
                    <div class="fp-actions">
                        <div class="fp-actions-left">
                            <i id="like-icon-${item.id}" 
                               class="${item.likedByCurrentUser ? 'fa-solid' : 'fa-regular'} fa-heart" 
                               style="${item.likedByCurrentUser ? 'color:var(--accent);' : ''} cursor:pointer;"
                               onclick="toggleLike(${item.id}, this)"></i>
                            <i class="fa-regular fa-comment" style="cursor:pointer;" onclick="openComments(${item.id})"></i>
                            <i class="fa-regular fa-paper-plane" style="cursor:pointer;" onclick="sharePost(${item.id})"></i>
                        </div>
                        <c:set var="bkKey" value="bookmarked_${item.id}"/>
                        <c:set var="isBk" value="${requestScope[bkKey] != null ? requestScope[bkKey] : false}"/>
                        <i id="save-icon-${item.id}"
                           class="${isBk ? 'fa-solid' : 'fa-regular'} fa-bookmark"
                           style="${isBk ? 'color:var(--dark);' : ''} cursor:pointer;"
                           onclick="toggleSave(${item.id}, this)"></i>
                    </div>
                    
                    <!-- Likes & Caption -->
                    <div class="fp-likes" id="like-count-${item.id}">${item.likeCount} likes</div>
                    <c:if test="${not empty item.title or not empty item.description}">
                        <div class="fp-caption">
                            <strong>${not empty item.user.creatorHandle ? item.user.creatorHandle : item.user.fullName}</strong> 
                            ${item.title} ${not empty item.description ? item.description : ''}
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <!-- STORY VIEWER MODAL -->
    <div id="storyViewer" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.9); z-index:10000; align-items:center; justify-content:center; flex-direction:column;">
        <div style="position:absolute; top:20px; right:20px; color:white; font-size:28px; cursor:pointer; z-index:10;" onclick="document.getElementById('storyViewer').style.display='none'"><i class="fa-solid fa-times"></i></div>
        <div style="position:absolute; top:20px; left:20px; display:flex; align-items:center; gap:12px; color:white; z-index:10;">
            <img id="storyViewerAvatar" src="" style="width:40px; height:40px; border-radius:50%; object-fit:cover; border:2px solid white;">
            <span id="storyViewerName" style="font-weight:700; font-size:16px;"></span>
        </div>
        <img id="storyViewerImg" src="" style="max-width:90%; max-height:80vh; border-radius:12px; object-fit:contain;">
    </div>

    <script>
        function viewStory(storyId, handle, avatar, mediaUrl) {
            document.getElementById('storyViewerName').innerText = handle;
            document.getElementById('storyViewerAvatar').src = avatar || '${pageContext.request.contextPath}/assets/img/default-avatar.png';
            document.getElementById('storyViewerImg').src = mediaUrl;
            document.getElementById('storyViewer').style.display = 'flex';
            
            // Record the view in the backend
            if (storyId) {
                fetch('${pageContext.request.contextPath}/creator-hub/story/' + storyId + '/view', { method: 'POST' }).catch(console.error);
            }
        }

        function deleteFeedPost(id) {
            if(!confirm("Delete this post/reel?")) return;
            fetch('${pageContext.request.contextPath}/creator-hub/post/' + id, { method: 'DELETE' })
            .then(r => r.json()).then(res => { if(res.success) window.location.reload(); });
        }
        
        function toggleLike(id, iconEl) {
            let fd = new FormData();
            fd.append('videoId', id);
            fetch('${pageContext.request.contextPath}/video/like', { method: 'POST', body: fd })
            .then(r => r.json())
            .then(res => {
                if(res.liked !== undefined) {
                    iconEl.className = (res.liked ? 'fa-solid' : 'fa-regular') + ' fa-heart';
                    iconEl.style.color = res.liked ? 'var(--accent)' : '';
                    const countEl = document.getElementById('like-count-' + id);
                    if(countEl) countEl.innerText = res.likeCount + ' likes';
                }
            });
        }

        function toggleSave(id, iconEl) {
            let fd = new FormData();
            fd.append('videoId', id);
            fetch('${pageContext.request.contextPath}/creator-hub/video/bookmark', { method: 'POST', body: fd })
            .then(r => r.json())
            .then(res => {
                if(res.bookmarked !== undefined) {
                    iconEl.className = (res.bookmarked ? 'fa-solid' : 'fa-regular') + ' fa-bookmark';
                    iconEl.style.color = res.bookmarked ? 'var(--dark)' : '';
                }
            });
        }

        function sharePost(id) {
            const url = window.location.origin + '${pageContext.request.contextPath}/video/' + id;
            if(navigator.share) {
                navigator.share({ title: 'Check this out!', url: url });
            } else {
                navigator.clipboard.writeText(url).then(() => alert('Link copied to clipboard!'));
            }
        }

        /* ── COMMENTS ── */
        let currentCommentVideoId = null;
        let replyToParentId = null;

        function openComments(id) {
            currentCommentVideoId = id;
            replyToParentId = null;
            document.getElementById('commentsModal').style.display = 'flex';
            document.getElementById('commentsList').innerHTML = '<div style="text-align:center;padding:20px;">Loading...</div>';
            
            fetch('${pageContext.request.contextPath}/creator-hub/comments-api?videoId=' + id)
            .then(r => r.json())
            .then(data => {
                const list = document.getElementById('commentsList');
                list.innerHTML = '';
                if(data.length === 0) {
                    list.innerHTML = '<div style="text-align:center;padding:20px;color:var(--sub);">No comments yet. Be the first!</div>';
                    return;
                }
                data.forEach(c => {
                    const div = document.createElement('div');
                    div.style.cssText = 'display:flex;gap:12px;margin-bottom:16px;';
                    div.innerHTML = '<img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" style="width:36px;height:36px;border-radius:50%;object-fit:cover;">'
                        + '<div><div style="font-size:14px;"><strong>' + (c.username||'User') + '</strong> ' + c.text + '</div>'
                        + '<div style="font-size:12px;color:var(--sub);margin-top:4px;cursor:pointer;" onclick="setReply(' + c.id + ',\'' + (c.username||'User') + '\')">Reply</div>';
                    // Render replies
                    if(c.replies && c.replies.length > 0) {
                        c.replies.forEach(r => {
                            div.innerHTML += '<div style="display:flex;gap:10px;margin-top:10px;margin-left:20px;"><img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" style="width:28px;height:28px;border-radius:50%;"><div style="font-size:13px;"><strong>' + (r.username||'User') + '</strong> ' + r.text + '</div></div>';
                        });
                    }
                    div.innerHTML += '</div>';
                    list.appendChild(div);
                });
            });
        }

        function closeComments() { document.getElementById('commentsModal').style.display = 'none'; }

        function setReply(commentId, userName) {
            replyToParentId = commentId;
            const input = document.getElementById('commentInput');
            input.value = '@' + userName + ' ';
            input.focus();
        }

        function insertEmoji(emoji) { document.getElementById('commentInput').value += emoji; }

        function submitComment() {
            const input = document.getElementById('commentInput');
            const text = input.value.trim();
            if(!text) return;
            let fd = new FormData();
            fd.append('videoId', currentCommentVideoId);
            fd.append('commentText', text);
            if(replyToParentId) fd.append('parentId', replyToParentId);
            fetch('${pageContext.request.contextPath}/video/comment', { method: 'POST', body: fd })
            .then(r => r.json())
            .then(() => { input.value = ''; replyToParentId = null; openComments(currentCommentVideoId); });
        }

        function toggleChatPanel() { window.location.href = '${pageContext.request.contextPath}/creator-hub/chat'; }
        function toggleNotifPanel() {}
    </script>

    <!-- COMMENTS MODAL -->
    <div id="commentsModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:10000; align-items:flex-end; justify-content:center;">
        <div style="width:100%; max-width:600px; height:70vh; background:var(--card); border-radius:24px 24px 0 0; display:flex; flex-direction:column; overflow:hidden; animation: slideUp 0.3s ease-out;">
            <div style="padding:16px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center;">
                <h3 style="margin:0; font-size:18px;">Comments</h3>
                <i class="fa-solid fa-times" style="font-size:20px; cursor:pointer;" onclick="closeComments()"></i>
            </div>
            <div id="commentsList" style="flex:1; overflow-y:auto; padding:20px;"></div>
            <div style="border-top:1px solid var(--border); padding:12px 16px;">
                <div style="display:flex; gap:10px; margin-bottom:8px; font-size:20px; cursor:pointer;">
                    <span onclick="insertEmoji('😂')">😂</span><span onclick="insertEmoji('😍')">😍</span><span onclick="insertEmoji('🔥')">🔥</span><span onclick="insertEmoji('👏')">👏</span><span onclick="insertEmoji('😢')">😢</span><span onclick="insertEmoji('🎉')">🎉</span><span onclick="insertEmoji('❤️')">❤️</span><span onclick="insertEmoji('👍')">👍</span>
                </div>
                <div style="display:flex; gap:12px; align-items:center;">
                    <img src="${not empty currentUser.profilePhoto ? currentUser.profilePhoto : pageContext.request.contextPath.concat('/assets/img/default-avatar.png')}" style="width:36px;height:36px;border-radius:50%;object-fit:cover;">
                    <input type="text" id="commentInput" placeholder="Add a comment..." style="flex:1; border:none; outline:none; background:var(--bg); padding:10px 16px; border-radius:20px; font-size:14px;" onkeypress="if(event.key==='Enter') submitComment()">
                    <i class="fa-solid fa-paper-plane" style="color:var(--accent); font-size:20px; cursor:pointer;" onclick="submitComment()"></i>
                </div>
            </div>
        </div>
    </div>
    <style>@keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }</style>
</body>
</html>

