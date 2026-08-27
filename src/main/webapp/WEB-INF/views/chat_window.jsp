<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chat with ${not empty receiver.fullName ? receiver.fullName : receiver.email} — Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">

    <style>
        :root {
            --fdf-rose: #F43F5E;
            --fdf-rose-dark: #E11D48;
            --fdf-rose-soft: #FFF1F2;
            --fdf-rose-light: #FFE4E6;
            --fdf-navy: #0F172A;
            --fdf-muted: #64748B;
            --fdf-border: #E2E8F0;
            --fdf-bg: #F8FAFC;
            --fdf-white: #FFFFFF;
        }

        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            font-family: 'Poppins', sans-serif;
            background: var(--fdf-bg);
            color: var(--fdf-navy);
        }

        /* Dashboard sidebar + full-height chat pane */
        #page-content-wrapper.chat-page {
            padding: 0 !important;
            margin-left: 260px;
            height: calc(100vh - 80px);
            min-height: calc(100vh - 80px);
            overflow: hidden;
            background: var(--fdf-bg) !important;
        }

        .chat-shell {
            height: 100%;
            min-height: calc(100vh - 80px);
            display: flex;
            flex-direction: column;
            background: var(--fdf-white);
        }

        .chat-topbar {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 20px;
            background: var(--fdf-rose-soft);
            border-bottom: 1px solid var(--fdf-rose-light);
        }

        .chat-topbar-left {
            display: flex;
            align-items: center;
            gap: 14px;
            min-width: 0;
        }

        .chat-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--fdf-white);
            border: 1px solid var(--fdf-border);
            color: var(--fdf-navy);
            text-decoration: none;
            flex-shrink: 0;
            transition: border-color 0.2s, color 0.2s;
        }
        .chat-back:hover {
            border-color: var(--fdf-rose);
            color: var(--fdf-rose);
        }

        .chat-peer-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--fdf-rose-light);
            flex-shrink: 0;
        }

        .chat-peer-info h4 {
            margin: 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--fdf-navy);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .chat-peer-info span {
            font-size: 0.78rem;
            color: var(--fdf-muted);
        }

        .call-actions {
            display: flex;
            gap: 8px;
            flex-shrink: 0;
        }

        .btn-call {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--fdf-white);
            border: 1px solid var(--fdf-rose-light);
            color: var(--fdf-rose);
            text-decoration: none;
            transition: background 0.2s, color 0.2s, border-color 0.2s;
        }
        .btn-call:hover {
            background: var(--fdf-rose);
            border-color: var(--fdf-rose);
            color: #fff;
        }

        .chat-box {
            flex: 1;
            overflow-y: auto;
            padding: 20px 16px;
            background: var(--fdf-bg);
        }

        .chat-box::-webkit-scrollbar { width: 6px; }
        .chat-box::-webkit-scrollbar-track { background: transparent; }
        .chat-box::-webkit-scrollbar-thumb {
            background: var(--fdf-rose-light);
            border-radius: 10px;
        }
        .chat-box::-webkit-scrollbar-thumb:hover { background: var(--fdf-rose); }

        .chat-shell .message-sent,
        .chat-shell .message-received {
            font-family: 'Poppins', 'Segoe UI Emoji', 'Apple Color Emoji', 'Noto Color Emoji', sans-serif;
            word-break: break-word;
        }

        .chat-shell .message-sent {
            background: var(--fdf-rose) !important;
            color: #fff !important;
            padding: 10px 14px;
            border-radius: 18px 18px 4px 18px;
            max-width: 72%;
            font-size: 0.95rem;
            line-height: 1.45;
            box-shadow: 0 2px 8px rgba(244, 63, 94, 0.15);
            border: none !important;
        }

        .chat-shell .message-received {
            background: var(--fdf-white) !important;
            color: var(--fdf-navy) !important;
            padding: 10px 14px;
            border-radius: 18px 18px 18px 4px;
            max-width: 72%;
            font-size: 0.95rem;
            line-height: 1.45;
            border: 1px solid var(--fdf-rose-light) !important;
        }

        .chat-shell .msg-time {
            display: block;
            font-size: 0.68rem;
            opacity: 0.75;
            margin-top: 4px;
        }

        .chat-shell .message-sent .msg-time {
            text-align: right;
            color: rgba(255, 255, 255, 0.9) !important;
        }
        .chat-shell .message-received .msg-time {
            text-align: left;
            color: var(--fdf-muted) !important;
        }

        .chat-shell .tick {
            font-size: 0.7rem;
            opacity: 0.85;
            margin-left: 4px;
            color: rgba(255, 255, 255, 0.95) !important;
        }
        .chat-shell .tick.read { opacity: 1; }

        video {
            max-width: 240px;
            border-radius: 12px;
            margin-top: 6px;
            display: block;
        }

        .chat-input-bar {
            flex-shrink: 0;
            display: flex;
            gap: 10px;
            align-items: center;
            padding: 14px 16px 18px;
            background: var(--fdf-white);
            border-top: 1px solid var(--fdf-border);
            position: relative;
            z-index: 50;
            overflow: visible;
        }

        .chat-input-wrap {
            position: relative;
            flex: 1;
            display: flex;
            gap: 8px;
            align-items: center;
            overflow: visible;
        }

        .btn-emoji {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--fdf-rose-soft);
            border: 1px solid var(--fdf-rose-light);
            color: var(--fdf-muted);
            cursor: pointer;
            flex-shrink: 0;
        }
        .btn-emoji:hover { color: var(--fdf-rose); border-color: var(--fdf-rose); }

        .chat-input-bar input[type="text"] {
            flex: 1;
            border: 1px solid var(--fdf-border);
            border-radius: 999px;
            padding: 12px 18px;
            font-size: 1.05rem;
            background: var(--fdf-bg);
            color: var(--fdf-navy);
            font-family: 'Poppins', 'Segoe UI Emoji', 'Apple Color Emoji', 'Noto Color Emoji', sans-serif;
        }
        .chat-input-bar input[type="text"]:focus {
            outline: none;
            border-color: var(--fdf-rose);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
            background: var(--fdf-white);
        }

        .btn-send {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--fdf-rose);
            border: none;
            color: #fff;
            flex-shrink: 0;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-send:hover {
            background: var(--fdf-rose-dark);
            transform: scale(1.04);
        }

        /* Fixed picker — escapes overflow:hidden on page wrapper */
        .emoji-picker {
            position: fixed;
            display: none;
            flex-wrap: wrap;
            gap: 4px;
            max-width: 300px;
            padding: 12px;
            background: var(--fdf-white);
            border: 1px solid var(--fdf-border);
            border-radius: 14px;
            box-shadow: 0 8px 28px rgba(15, 23, 42, 0.14);
            z-index: 5000;
        }
        .emoji-picker.show { display: flex; }

        .emoji-btn {
            background: none;
            border: none;
            font-size: 24px;
            line-height: 1;
            cursor: pointer;
            padding: 4px 6px;
            border-radius: 8px;
            font-family: 'Segoe UI Emoji', 'Apple Color Emoji', 'Noto Color Emoji', sans-serif;
        }
        .emoji-btn:hover { background: var(--fdf-rose-soft); }

        .chat-toast {
            position: fixed;
            top: 88px;
            right: 16px;
            z-index: 9999;
            min-width: 280px;
            background: var(--fdf-white);
            border: 1px solid var(--fdf-rose-light);
            border-left: 4px solid var(--fdf-rose);
            border-radius: 14px;
            padding: 14px 16px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);
            display: none;
        }
        .chat-toast a {
            color: var(--fdf-rose);
            font-weight: 600;
            text-decoration: none;
        }

        .empty-chat-hint {
            text-align: center;
            padding: 48px 20px;
            color: var(--fdf-muted);
        }
        .empty-chat-hint i {
            font-size: 2.5rem;
            color: var(--fdf-rose-light);
            display: block;
            margin-bottom: 12px;
        }

        @media (max-width: 768px) {
            #page-content-wrapper.chat-page {
                margin-left: 0 !important;
                height: auto;
                min-height: calc(100vh - 72px);
            }
            .chat-shell { min-height: calc(100vh - 72px); }
            .chat-topbar { padding: 12px 14px; }
            .chat-shell .message-sent,
            .chat-shell .message-received { max-width: 85%; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper" class="chat-page" data-skip-global-back="true">

<div class="chat-shell">

    <div class="chat-topbar">
        <div class="chat-topbar-left">
            <a href="${pageContext.request.contextPath}/chat/users" class="chat-back" title="Back to chats">
                <i class="bi bi-arrow-left"></i>
            </a>
            <img src="${pageContext.request.contextPath}${not empty receiver.profilePhoto ? receiver.profilePhoto : '/assets/img/default-profile.png'}"
                 alt="" class="chat-peer-avatar">
            <div class="chat-peer-info">
                <h4>
                    <i class="bi bi-shield-check me-1" style="color:var(--fdf-rose);"></i>
                    ${not empty receiver.fullName ? receiver.fullName : receiver.email}
                </h4>
                <span>Secure chat</span>
            </div>
        </div>
        <div class="call-actions">
            <a href="${pageContext.request.contextPath}/chat/call/${receiver.id}?notify=true"
               class="btn-call" title="Voice call" target="_blank">
                <i class="bi bi-telephone-fill"></i>
            </a>
            <a href="${pageContext.request.contextPath}/chat/video-call/${receiver.id}?notify=true"
               class="btn-call" title="Video call" target="_blank">
                <i class="bi bi-camera-video-fill"></i>
            </a>
        </div>
    </div>

    <div id="chatBox" class="chat-box">
        <c:choose>
            <c:when test="${empty messages}">
                <div class="empty-chat-hint">
                    <i class="bi bi-chat-heart"></i>
                    <p class="mb-0">Say hello to start the conversation.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="msg" items="${messages}">
                    <c:choose>
                        <c:when test="${msg.sender.id == sessionScope.user.id}">
                            <div class="d-flex justify-content-end mb-3">
                                <div class="message-sent">
                                    <c:if test="${not empty msg.message}"><c:out value="${msg.message}"/></c:if>
                                    <c:if test="${not empty msg.videoUrl}">
                                        <video controls>
                                            <source src="${pageContext.request.contextPath}${msg.videoUrl}" type="video/mp4">
                                        </video>
                                    </c:if>
                                    <c:if test="${not empty msg.timestamp}">
                                        <span class="msg-time">${msg.timestamp.toString().replace('T', ' ').substring(0,16)}</span>
                                    </c:if>
                                    <span class="tick ${msg.readStatus ? 'read' : ''}">✔✔</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex justify-content-start mb-3">
                                <div class="message-received">
                                    <c:if test="${not empty msg.message}"><c:out value="${msg.message}"/></c:if>
                                    <c:if test="${not empty msg.videoUrl}">
                                        <video controls>
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
            </c:otherwise>
        </c:choose>
    </div>

    <form id="chatForm" class="chat-input-bar">
        <input type="hidden" id="receiverId" value="${receiver.id}">
        <div class="chat-input-wrap">
            <button type="button" class="btn-emoji" id="emojiToggleBtn" title="Add emoji" aria-expanded="false" aria-controls="emojiPicker">
                <i class="bi bi-emoji-smile"></i>
            </button>
            <input type="text" id="message" placeholder="Type a message..." autocomplete="off">
        </div>
        <button class="btn-send" type="submit" title="Send">
            <i class="bi bi-send-fill"></i>
        </button>
    </form>
</div>

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Emoji picker (fixed, outside overflow containers) -->
<div id="emojiPicker" class="emoji-picker" role="listbox" aria-label="Emoji picker"></div>

<div id="chatToast" class="chat-toast" role="alert">
    <div class="fw-semibold mb-1" style="color:var(--fdf-navy);">
        <i class="bi bi-chat-dots-fill me-1" style="color:var(--fdf-rose);"></i> New message
    </div>
    <div id="chatToastBody" class="small mb-2" style="color:var(--fdf-muted);"></div>
    <a id="chatToastLink" href="#">Open chat →</a>
</div>

<div class="modal fade" id="incomingCallModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0" style="border-radius:18px;">
            <div class="modal-body text-center p-4">
                <div class="mb-3">
                    <i id="callIcon" class="bi bi-telephone-inbound-fill" style="font-size:3rem;color:var(--fdf-rose);"></i>
                </div>
                <h4 id="callerName" class="fw-bold" style="color:var(--fdf-navy);">Incoming call…</h4>
                <p id="callTypeLabel" class="text-muted">Voice call</p>
                <div class="d-flex justify-content-center gap-3 mt-4">
                    <button type="button" class="btn btn-success btn-lg rounded-pill px-4" id="acceptCallBtn">
                        <i class="bi bi-telephone-fill me-2"></i> Accept
                    </button>
                    <button type="button" class="btn btn-danger btn-lg rounded-pill px-4" id="declineCallBtn">
                        <i class="bi bi-telephone-x-fill me-2"></i> Decline
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<audio id="ringtoneAudio" loop preload="auto">
    <source src="https://assets.mixkit.co/active_storage/sfx/2358/2358-preview.mp3" type="audio/mpeg">
</audio>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script>
    const chatCtx = '${pageContext.request.contextPath}';
    let stompClient = null;
    const userId = ${sessionScope.user.id};
    let currentCallInfo = null;
    const ringtone = document.getElementById('ringtoneAudio');
    let lastPollSince = new Date().toISOString().slice(0, 19);

    function connect() {
        const socket = new SockJS(chatCtx + '/ws-chat');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function () {
            stompClient.subscribe("/topic/messages/" + userId, function (response) {
                try {
                    displayMessage(JSON.parse(response.body));
                } catch (e) { /* ignore malformed frame */ }
            });

            stompClient.subscribe("/topic/calls/" + userId, function (response) {
                const callInfo = JSON.parse(response.body);
                if (callInfo.type === 'INCOMING_CALL') {
                    handleIncomingCall(callInfo);
                } else if (callInfo.type === 'HANGUP' || callInfo.type === 'DECLINED') {
                    stopRingtone();
                    const modal = bootstrap.Modal.getInstance(document.getElementById('incomingCallModal'));
                    if (modal) modal.hide();
                }
            });
        }, function () {
            setTimeout(connect, 5000);
        });
    }

    function pollMessages() {
        const receiverId = document.getElementById("receiverId").value;
        fetch(chatCtx + '/chat/messages-since/' + receiverId + '?since=' + encodeURIComponent(lastPollSince), {
            credentials: 'same-origin',
            headers: { 'Accept': 'application/json; charset=UTF-8' }
        })
            .then(function (r) {
                if (!r.ok) return null;
                return r.json();
            })
            .then(function (data) {
                if (!data || !data.success || !data.messages) return;
                data.messages.forEach(function (m) {
                    displayMessage(m);
                    if (m.timestamp && m.timestamp > lastPollSince) {
                        lastPollSince = m.timestamp.length > 19 ? m.timestamp.slice(0, 19) : m.timestamp;
                    }
                });
            })
            .catch(function () {});
    }

    function sendViaWebSocket(receiverId, text) {
        if (stompClient && stompClient.connected) {
            stompClient.send("/app/chat.send", {}, JSON.stringify({
                sender: { id: userId },
                receiver: { id: receiverId },
                message: text
            }));
            return true;
        }
        return false;
    }

    function handleIncomingCall(callInfo) {
        currentCallInfo = callInfo;
        document.getElementById('callerName').innerText = callInfo.fromName + " is calling…";
        document.getElementById('callTypeLabel').innerText = callInfo.audioOnly ? "Voice call" : "Video call";

        const icon = document.getElementById('callIcon');
        icon.className = callInfo.audioOnly
            ? "bi bi-telephone-inbound-fill"
            : "bi bi-camera-video-fill";
        icon.style.color = "var(--fdf-rose)";

        playRingtone();
        new bootstrap.Modal(document.getElementById('incomingCallModal')).show();
    }

    function playRingtone() {
        ringtone.currentTime = 0;
        ringtone.play().catch(function () {});
    }

    function stopRingtone() {
        ringtone.pause();
        ringtone.currentTime = 0;
    }

    document.getElementById('acceptCallBtn').addEventListener('click', function () {
        if (!currentCallInfo) return;
        stopRingtone();
        const callUrl = currentCallInfo.audioOnly
            ? '${pageContext.request.contextPath}/chat/call/' + currentCallInfo.fromId
            : '${pageContext.request.contextPath}/chat/video-call/' + currentCallInfo.fromId;
        window.open(callUrl, '_blank', 'width=1000,height=700');
        bootstrap.Modal.getInstance(document.getElementById('incomingCallModal')).hide();
    });

    document.getElementById('declineCallBtn').addEventListener('click', function () {
        if (!currentCallInfo || !stompClient) return;
        stopRingtone();
        stompClient.send("/app/webrtc.signal", {}, JSON.stringify({
            type: 'DECLINED',
            senderId: userId,
            receiverId: currentCallInfo.fromId
        }));
        bootstrap.Modal.getInstance(document.getElementById('incomingCallModal')).hide();
    });

    function sendMessage() {
        const messageInput = document.getElementById("message");
        const text = messageInput.value.trim();
        if (!text) return;

        const receiverId = document.getElementById("receiverId").value;
        const clientKey = "pending-" + Date.now();

        displayMessage({
            clientKey: clientKey,
            sender: { id: userId },
            receiver: { id: receiverId },
            message: text,
            timestamp: new Date().toISOString(),
            readStatus: false
        });

        messageInput.value = "";
        closeEmojiPicker();

        fetch(chatCtx + '/chat/send-message', {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ receiverId: Number(receiverId), message: text })
        })
            .then(function (r) {
                return r.json().then(function (data) {
                    return { ok: r.ok, status: r.status, data: data };
                }).catch(function () {
                    return { ok: false, status: r.status, data: { error: 'Server error (' + r.status + ')' } };
                });
            })
            .then(function (result) {
                if (result.ok && result.data && result.data.success && result.data.message) {
                    displayMessage(result.data.message);
                    if (result.data.message.timestamp) {
                        lastPollSince = result.data.message.timestamp.length > 19
                            ? result.data.message.timestamp.slice(0, 19)
                            : result.data.message.timestamp;
                    }
                    return;
                }
                /* Fallback: deliver over WebSocket if HTTP route unavailable */
                if (result.status === 404 || result.status === 405 || result.status === 502) {
                    if (sendViaWebSocket(receiverId, text)) {
                        return;
                    }
                }
                const err = (result.data && (result.data.error || result.data.message))
                    || ('Could not send message (HTTP ' + result.status + '). Restart the app and try again.');
                if (String(err).toLowerCase() !== 'not found') {
                    alert(err);
                } else {
                    if (!sendViaWebSocket(receiverId, text)) {
                        alert('Chat send failed. Please restart the application and try again.');
                    }
                }
            })
            .catch(function () {
                if (!sendViaWebSocket(receiverId, text)) {
                    alert('Could not send message. Check your connection and try again.');
                }
            });
    }

    function formatMsgTime(ts) {
        if (!ts) return '';
        let d;
        if (Array.isArray(ts)) {
            d = new Date(ts[0], ts[1] - 1, ts[2], ts[3], ts[4], ts.length > 5 ? ts[5] : 0);
        } else {
            d = new Date(ts);
        }
        return !isNaN(d.getTime())
            ? d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
            : ts;
    }

    let toastTimer = null;
    function showChatToast(msg) {
        const toast = document.getElementById('chatToast');
        const senderName = msg.sender && msg.sender.fullName ? msg.sender.fullName : 'Someone';
        const preview = msg.message ? msg.message.substring(0, 80) : 'Sent you a message';
        document.getElementById('chatToastBody').textContent = senderName + ': ' + preview;
        document.getElementById('chatToastLink').href = '${pageContext.request.contextPath}/chat/window/' + msg.sender.id;
        toast.style.display = 'block';
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { toast.style.display = 'none'; }, 8000);
    }

    function displayMessage(msg) {
        const currentReceiverId = Number(document.getElementById("receiverId").value);
        const isSender = Number(msg.sender && msg.sender.id) === Number(userId) || Number(msg.sender) === Number(userId);

        if (!isSender && Number(msg.sender && msg.sender.id) !== currentReceiverId) {
            showChatToast(msg);
            return;
        }

        const chatBox = document.getElementById("chatBox");

        /* Skip duplicate when WebSocket echoes a message we already showed */
        if (msg.id && chatBox.querySelector('[data-msg-id="' + msg.id + '"]')) {
            return;
        }
        /* Merge WebSocket echo into the optimistic bubble we already showed */
        if (isSender && msg.id) {
            const pending = chatBox.querySelector('.message-sent[data-client-key]');
            if (pending) {
                pending.setAttribute('data-msg-id', msg.id);
                pending.removeAttribute('data-client-key');
                return;
            }
        }

        const hint = chatBox.querySelector('.empty-chat-hint');
        if (hint) hint.remove();

        const wrapper = document.createElement("div");
        wrapper.classList.add("mb-3", "d-flex", isSender ? "justify-content-end" : "justify-content-start");

        const bubble = document.createElement("div");
        bubble.classList.add(isSender ? "message-sent" : "message-received");
        if (msg.id) bubble.setAttribute('data-msg-id', msg.id);
        if (isSender && msg.clientKey) {
            bubble.setAttribute('data-client-key', msg.clientKey);
        }

        if (msg.message) {
            const textSpan = document.createElement('span');
            textSpan.className = 'msg-text';
            textSpan.textContent = msg.message;
            bubble.appendChild(textSpan);
        }

        if (msg.videoUrl) {
            const video = document.createElement("video");
            video.src = "${pageContext.request.contextPath}" + msg.videoUrl;
            video.controls = true;
            bubble.appendChild(video);
        }

        if (msg.timestamp) {
            const timeEl = document.createElement("span");
            timeEl.className = "msg-time";
            timeEl.textContent = formatMsgTime(msg.timestamp);
            bubble.appendChild(timeEl);
        }

        if (isSender) {
            const tickEl = document.createElement("span");
            tickEl.className = "tick" + (msg.readStatus ? " read" : "");
            tickEl.textContent = " ✔✔";
            bubble.appendChild(tickEl);
        }

        wrapper.appendChild(bubble);
        chatBox.appendChild(wrapper);
        chatBox.scrollTop = chatBox.scrollHeight;

        if (msg.timestamp) {
            const ts = String(msg.timestamp).length > 19
                ? String(msg.timestamp).slice(0, 19)
                : String(msg.timestamp);
            if (ts > lastPollSince) {
                lastPollSince = ts;
            }
        }
    }

    const EMOJIS = ['😀','😂','😍','🥰','😊','😢','😡','👍','👎','🙏','💪','❤️','🔥','✨','🎉','😎','🤔','👋','💯','🌸','😘','🤗','😭','🥺','💕','🌹','⭐','✅','❌','🙌'];
    const emojiPicker = document.getElementById('emojiPicker');
    const emojiToggleBtn = document.getElementById('emojiToggleBtn');
    const messageInput = document.getElementById('message');

    function positionEmojiPicker() {
        if (!emojiToggleBtn || !emojiPicker) return;
        const rect = emojiToggleBtn.getBoundingClientRect();
        const pickerWidth = 300;
        let left = rect.left;
        if (left + pickerWidth > window.innerWidth - 12) {
            left = window.innerWidth - pickerWidth - 12;
        }
        emojiPicker.style.left = Math.max(12, left) + 'px';
        emojiPicker.style.bottom = (window.innerHeight - rect.top + 10) + 'px';
    }

    function closeEmojiPicker() {
        if (!emojiPicker) return;
        emojiPicker.classList.remove('show');
        if (emojiToggleBtn) emojiToggleBtn.setAttribute('aria-expanded', 'false');
    }

    function openEmojiPicker() {
        if (!emojiPicker) return;
        positionEmojiPicker();
        emojiPicker.classList.add('show');
        if (emojiToggleBtn) emojiToggleBtn.setAttribute('aria-expanded', 'true');
    }

    function insertEmoji(emoji) {
        if (!messageInput) return;
        const start = messageInput.selectionStart != null ? messageInput.selectionStart : messageInput.value.length;
        const end = messageInput.selectionEnd != null ? messageInput.selectionEnd : messageInput.value.length;
        const before = messageInput.value.substring(0, start);
        const after = messageInput.value.substring(end);
        messageInput.value = before + emoji + after;
        const cursor = start + emoji.length;
        messageInput.focus();
        if (messageInput.setSelectionRange) {
            messageInput.setSelectionRange(cursor, cursor);
        }
        closeEmojiPicker();
    }

    if (emojiPicker) {
        EMOJIS.forEach(function (emoji) {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'emoji-btn';
            btn.setAttribute('role', 'option');
            btn.setAttribute('aria-label', 'Insert emoji');
            btn.textContent = emoji;
            btn.addEventListener('mousedown', function (e) {
                e.preventDefault(); /* keep focus on input */
            });
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                insertEmoji(emoji);
            });
            emojiPicker.appendChild(btn);
        });
    }

    if (emojiToggleBtn) {
        emojiToggleBtn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (emojiPicker && emojiPicker.classList.contains('show')) {
                closeEmojiPicker();
            } else {
                openEmojiPicker();
            }
        });
    }

    document.addEventListener('click', function (e) {
        if (!e.target.closest('#emojiPicker') && !e.target.closest('#emojiToggleBtn')) {
            closeEmojiPicker();
        }
    });

    window.addEventListener('resize', function () {
        if (emojiPicker && emojiPicker.classList.contains('show')) {
            positionEmojiPicker();
        }
    });

    document.getElementById("chatForm").addEventListener("submit", function (e) {
        e.preventDefault();
        if (!messageInput || !messageInput.value.trim()) {
            return;
        }
        sendMessage();
    });

    connect();
    pollMessages();
    setInterval(pollMessages, 3000);

    (function scrollToBottom() {
        const chatBox = document.getElementById('chatBox');
        chatBox.scrollTop = chatBox.scrollHeight;
    })();
</script>

</body>
</html>
