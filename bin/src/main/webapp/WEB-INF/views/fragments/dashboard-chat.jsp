<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .ud-chat-shell {
        display: grid;
        grid-template-columns: 300px minmax(0, 1fr);
        gap: 16px;
        min-height: calc(100vh - 140px);
    }
    .ud-chat-list, .ud-chat-panel {
        background: var(--fdf-white, #FFFFFF);
        border: 1px solid var(--fdf-border, #E2E8F0);
        border-radius: var(--radius-lg, 18px);
        box-shadow: var(--shadow-card, 0 4px 20px rgba(15, 23, 42, 0.04));
        overflow: hidden;
        display: flex;
        flex-direction: column;
    }
    .ud-chat-list-head, .ud-chat-panel-head {
        padding: 16px 18px;
        background: var(--fdf-rose-soft, #FFF1F2);
        border-bottom: 1px solid var(--fdf-border, #E2E8F0);
    }
    .ud-chat-list-head h2, .ud-chat-panel-head h2 {
        margin: 0;
        font-size: 1rem;
        font-weight: 700;
        color: var(--fdf-navy, #0F172A);
    }
    .ud-chat-list-head p {
        margin: 4px 0 0;
        font-size: 0.82rem;
        color: var(--fdf-muted, #64748B);
    }
    .ud-chat-contacts {
        overflow-y: auto;
        flex: 1;
        padding: 8px;
    }
    .ud-chat-contact {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        border-radius: 12px;
        text-decoration: none;
        color: var(--fdf-navy, #0F172A);
        border: 1px solid transparent;
        transition: background 0.15s ease, border-color 0.15s ease;
    }
    .ud-chat-contact:hover {
        background: var(--fdf-rose-soft, #FFF1F2);
        color: var(--fdf-navy, #0F172A);
    }
    .ud-chat-contact.active {
        background: var(--fdf-rose-light, #FFE4E6);
        border-color: #FECDD3;
    }
    .ud-chat-avatar {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        object-fit: cover;
        background: var(--fdf-rose-soft, #FFF1F2);
        border: 2px solid var(--fdf-rose-light, #FFE4E6);
        flex-shrink: 0;
    }
    .ud-chat-contact-name {
        font-weight: 600;
        font-size: 0.92rem;
        line-height: 1.3;
    }
    .ud-chat-contact-sub {
        font-size: 0.78rem;
        color: var(--fdf-muted, #64748B);
    }
    .ud-chat-empty {
        padding: 40px 20px;
        text-align: center;
        color: var(--fdf-muted, #64748B);
    }
    .ud-chat-empty i {
        font-size: 2rem;
        color: var(--fdf-rose, #F43F5E);
        display: block;
        margin-bottom: 10px;
    }
    .ud-chat-box {
        flex: 1;
        overflow-y: auto;
        padding: 16px;
        background: var(--fdf-bg, #F8FAFC);
    }
    .ud-chat-box .message-sent {
        background: var(--fdf-rose, #F43F5E);
        color: #fff;
        padding: 10px 14px;
        border-radius: 16px 16px 4px 16px;
        max-width: 75%;
        font-size: 0.92rem;
    }
    .ud-chat-box .message-received {
        background: var(--fdf-white, #FFFFFF);
        color: var(--fdf-navy, #0F172A);
        border: 1px solid var(--fdf-border, #E2E8F0);
        padding: 10px 14px;
        border-radius: 16px 16px 16px 4px;
        max-width: 75%;
        font-size: 0.92rem;
    }
    .ud-chat-box .msg-time {
        display: block;
        font-size: 0.7rem;
        opacity: 0.75;
        margin-top: 4px;
    }
    .ud-chat-box .tick { font-size: 0.72rem; opacity: 0.85; }
    .ud-chat-box .tick.read { color: #FFE4E6; }
    .ud-chat-input-row {
        display: flex;
        gap: 10px;
        padding: 14px 16px;
        border-top: 1px solid var(--fdf-border, #E2E8F0);
        background: var(--fdf-white, #FFFFFF);
        align-items: center;
    }
    .ud-chat-input-row input[type="text"] {
        flex: 1;
        border: 1px solid var(--fdf-border, #E2E8F0);
        border-radius: 999px;
        padding: 10px 16px;
        font-size: 0.92rem;
        background: var(--fdf-bg, #F8FAFC);
        color: var(--fdf-navy, #0F172A);
    }
    .ud-chat-input-row input[type="text"]:focus {
        outline: none;
        border-color: #FECDD3;
        box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
    }
    .ud-chat-send-btn {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        border: none;
        background: var(--fdf-rose, #F43F5E);
        color: #fff;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    .ud-chat-send-btn:hover { background: var(--fdf-rose-dark, #E11D48); }
    .ud-chat-call-btn {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: 1px solid var(--fdf-border, #E2E8F0);
        background: var(--fdf-white, #FFFFFF);
        color: var(--fdf-rose, #F43F5E);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
    }
    .ud-chat-call-btn:hover {
        background: var(--fdf-rose-soft, #FFF1F2);
        color: var(--fdf-rose-dark, #E11D48);
    }
    .ud-chat-placeholder {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 40px 24px;
        text-align: center;
        color: var(--fdf-muted, #64748B);
        background: var(--fdf-bg, #F8FAFC);
    }
    .ud-chat-placeholder i {
        font-size: 2.5rem;
        color: var(--fdf-rose, #F43F5E);
        margin-bottom: 12px;
    }
    @media (max-width: 900px) {
        .ud-chat-shell { grid-template-columns: 1fr; min-height: auto; }
        .ud-chat-list { max-height: 280px; }
        .ud-chat-panel { min-height: 420px; }
    }
</style>

<div class="ud-greeting mb-3">
    <h1>Messages</h1>
    <p>Chat with your friends — stays inside your dashboard</p>
</div>

<div class="ud-chat-shell">
    <div class="ud-chat-list">
        <div class="ud-chat-list-head">
            <h2><i class="bi bi-chat-dots me-2" style="color:#F43F5E;"></i>Chats</h2>
            <p>Tap a conversation to open it here</p>
        </div>
        <div class="ud-chat-contacts">
            <c:choose>
                <c:when test="${empty chatContacts && empty chatFriends}">
                    <div class="ud-chat-empty">
                        <i class="bi bi-chat-heart"></i>
                        <div>No conversations yet</div>
                        <div class="small mt-1">Add friends from Community to start chatting.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="contact" items="${chatContacts}">
                        <a href="${pageContext.request.contextPath}/users/dashboard?view=chat&amp;peer=${contact.id}"
                           class="ud-chat-contact ${not empty chatPeer && chatPeer.id == contact.id ? 'active' : ''}">
                            <img class="ud-chat-avatar"
                                 src="${pageContext.request.contextPath}${not empty contact.profilePhoto ? contact.profilePhoto : '/assets/img/default-profile.png'}"
                                 alt="">
                            <div>
                                <div class="ud-chat-contact-name"><c:out value="${contact.fullName}"/></div>
                                <div class="ud-chat-contact-sub">Recent chat</div>
                            </div>
                        </a>
                    </c:forEach>
                    <c:forEach var="friend" items="${chatFriends}">
                        <c:if test="${empty chatContacts || !chatContacts.contains(friend)}">
                            <a href="${pageContext.request.contextPath}/users/dashboard?view=chat&amp;peer=${friend.id}"
                               class="ud-chat-contact ${not empty chatPeer && chatPeer.id == friend.id ? 'active' : ''}">
                                <img class="ud-chat-avatar"
                                     src="${pageContext.request.contextPath}${not empty friend.profilePhoto ? friend.profilePhoto : '/assets/img/default-profile.png'}"
                                     alt="">
                                <div>
                                    <div class="ud-chat-contact-name"><c:out value="${friend.fullName}"/></div>
                                    <div class="ud-chat-contact-sub">Friend</div>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="ud-chat-panel">
        <c:choose>
            <c:when test="${not empty chatPeer}">
                <div class="ud-chat-panel-head d-flex justify-content-between align-items-center">
                    <h2><i class="bi bi-shield-check me-2" style="color:#F43F5E;"></i>Chat with <c:out value="${chatPeer.fullName}"/></h2>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/chat/call/${chatPeer.id}?notify=true"
                           class="ud-chat-call-btn" title="Voice call" target="_blank">
                            <i class="bi bi-telephone-fill"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/chat/video-call/${chatPeer.id}?notify=true"
                           class="ud-chat-call-btn" title="Video call" target="_blank">
                            <i class="bi bi-camera-video-fill"></i>
                        </a>
                    </div>
                </div>
                <div id="chatBox" class="ud-chat-box">
                    <c:forEach var="msg" items="${chatMessages}">
                        <c:choose>
                            <c:when test="${msg.sender.id == user.id}">
                                <div class="d-flex justify-content-end mb-2">
                                    <div class="message-sent">
                                        <c:if test="${not empty msg.message}"><c:out value="${msg.message}"/></c:if>
                                        <c:if test="${not empty msg.videoUrl}">
                                            <video controls style="max-width:220px;border-radius:10px;margin-top:6px;display:block;">
                                                <source src="${pageContext.request.contextPath}${msg.videoUrl}" type="video/mp4">
                                            </video>
                                        </c:if>
                                        <c:if test="${not empty msg.timestamp}">
                                            <span class="msg-time">${msg.timestamp.toString().replace('T', ' ').substring(0,16)}</span>
                                        </c:if>
                                        <span class="tick ${msg.readStatus ? 'read' : ''}"> ✔✔</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex justify-content-start mb-2">
                                    <div class="message-received">
                                        <c:if test="${not empty msg.message}"><c:out value="${msg.message}"/></c:if>
                                        <c:if test="${not empty msg.videoUrl}">
                                            <video controls style="max-width:220px;border-radius:10px;margin-top:6px;display:block;">
                                                <source src="${pageContext.request.contextPath}${msg.videoUrl}" type="video/mp4">
                                            </video>
                                        </c:if>
                                        <c:if test="${not empty msg.timestamp}">
                                            <span class="msg-time">${msg.timestamp.toString().replace('T', ' ').substring(0,16)}</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <form id="chatForm" class="ud-chat-input-row">
                    <input type="hidden" id="receiverId" value="${chatPeer.id}">
                    <input type="text" id="message" placeholder="Type a message..." autocomplete="off" required>
                    <button type="submit" class="ud-chat-send-btn" aria-label="Send">
                        <i class="bi bi-send-fill"></i>
                    </button>
                </form>
            </c:when>
            <c:otherwise>
                <div class="ud-chat-placeholder">
                    <i class="bi bi-chat-left-text"></i>
                    <h3 style="color:#0F172A;font-size:1.05rem;font-weight:700;">Select a chat</h3>
                    <p class="mb-0">Choose someone from the list to start or continue a conversation.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<c:if test="${not empty chatPeer}">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard-chat.js"></script>
</c:if>
