<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Chat with Dr. ${doctor.fullName} — SafeHer</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap">
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:'Poppins',sans-serif;background:#0f0a1e;height:100vh;display:flex;flex-direction:column;color:#fff}
    .ch-header{background:linear-gradient(135deg,#1e1b4b,rgba(255, 255, 255, 0.05));padding:14px 20px;display:flex;align-items:center;gap:14px;border-bottom:1px solid rgba(255,255,255,0.06)}
    .ch-back{width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,0.08);display:flex;align-items:center;justify-content:center;color:#fff;text-decoration:none;font-size:16px}
    .ch-avatar{width:42px;height:42px;border-radius:50%;background:linear-gradient(135deg,#1e1b4b,#312e81,#f43f5e);display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:800;color:#fff;flex-shrink:0}
    .ch-doc-info h3{font-size:14px;font-weight:700;margin:0}
    .ch-doc-info p{font-size:11px;color:rgba(255,255,255,0.5);margin:0}
    .ch-actions{margin-left:auto;display:flex;gap:8px}
    .ch-act{width:36px;height:36px;border-radius:10px;border:none;display:flex;align-items:center;justify-content:center;font-size:16px;cursor:pointer;text-decoration:none;transition:all 0.2s}
    .ch-act.call{background:rgba(32,201,151,0.15);color:#20c997}
    .ch-act.video{background:rgba(74,144,217,0.15);color:#4a90d9}
    .ch-act:hover{transform:scale(1.1)}
    .ch-messages{flex:1;overflow-y:auto;padding:20px;display:flex;flex-direction:column;gap:8px}
    .ch-msg{max-width:75%;padding:10px 16px;border-radius:16px;font-size:13px;line-height:1.5;animation:fadeIn 0.3s}
    .ch-msg.sent{align-self:flex-end;background:linear-gradient(135deg,#312e81,#1e1b4b);color:#fff;border-bottom-right-radius:4px}
    .ch-msg.received{align-self:flex-start;background:rgba(255,255,255,0.08);color:#e0e0e0;border-bottom-left-radius:4px}
    .ch-msg .time{font-size:9px;opacity:0.5;margin-top:4px;display:block}
    .ch-input-area{padding:12px 16px;background:#1e1b4b;border-top:1px solid rgba(255,255,255,0.06);display:flex;gap:10px;align-items:center}
    .ch-input-area input{flex:1;padding:12px 18px;border:2px solid rgba(123,44,191,0.2);border-radius:999px;background:rgba(255,255,255,0.05);color:#fff;font-size:13px;font-family:'Poppins',sans-serif;outline:none}
    .ch-input-area input:focus{border-color:#312e81}
    .ch-input-area input::placeholder{color:rgba(255,255,255,0.3)}
    .ch-send{width:44px;height:44px;border-radius:50%;border:none;background:linear-gradient(135deg,#312e81,#f43f5e);color:#fff;font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.2s}
    .ch-send:hover{transform:scale(1.1);box-shadow:0 4px 16px rgba(123,44,191,0.4)}
    .ch-empty{text-align:center;margin:auto;color:rgba(255,255,255,0.3)}
    .ch-empty i{font-size:48px;display:block;margin-bottom:8px}
    @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
  </style>
</head>
<body>
  <div class="ch-header">
    <c:choose>
      <c:when test="${senderType == 'USER'}">
        <a href="${pageContext.request.contextPath}/doctors/view/${doctor.id}" class="ch-back"><i class="bi bi-arrow-left"></i></a>
        <div class="ch-avatar">${doctor.fullName.charAt(0)}</div>
        <div class="ch-doc-info">
          <h3>Dr. ${doctor.fullName}</h3>
          <p>${doctor.specialization} • <span style="color:#20c997">● Online</span></p>
        </div>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/doctors/dashboard?section=chats" class="ch-back"><i class="bi bi-arrow-left"></i></a>
        <div class="ch-avatar">${targetUserName != null ? targetUserName.charAt(0) : 'U'}</div>
        <div class="ch-doc-info">
          <h3>${targetUserName}</h3>
          <p>Patient • <span style="color:#20c997">● Online</span></p>
        </div>
      </c:otherwise>
    </c:choose>
    <div class="ch-actions">
      <c:set var="callUrl" value="${pageContext.request.contextPath}/doctors/voice-call/${doctor.id}" />
      <c:set var="videoUrl" value="${pageContext.request.contextPath}/doctors/video-call/${doctor.id}" />
      <c:if test="${not empty targetUserId}">
        <c:set var="callUrl" value="${callUrl}?userId=${targetUserId}" />
        <c:set var="videoUrl" value="${videoUrl}?userId=${targetUserId}" />
      </c:if>
      <a href="${callUrl}" class="ch-act call" target="_blank"><i class="bi bi-telephone-fill"></i></a>
      <a href="${videoUrl}" class="ch-act video" target="_blank"><i class="bi bi-camera-video-fill"></i></a>
    </div>
  </div>

  <div class="ch-messages" id="chatMessages">
    <c:if test="${empty chatHistory}">
      <div class="ch-empty"><i class="bi bi-chat-heart"></i><p>Start your conversation with Dr. ${doctor.fullName}</p></div>
    </c:if>
    <c:forEach var="m" items="${chatHistory}">
      <div class="ch-msg ${m.senderType == senderType ? 'sent' : 'received'}">
        ${m.message}
        <span class="time">${m.timestamp}</span>
      </div>
    </c:forEach>
  </div>

  <div class="ch-input-area">
    <input type="text" id="msgInput" placeholder="Type a message..." onkeypress="if(event.key==='Enter')sendMsg()">
    <button class="ch-send" onclick="sendMsg()"><i class="bi bi-send-fill"></i></button>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script>
    const doctorId = ${doctor.id};
    const senderType = '${senderType}';
    const currentUser = '${currentUser}';
    const targetUserId = '${targetUserId != null ? targetUserId : ""}';
    const ctx = '${pageContext.request.contextPath}';
    const chatBox = document.getElementById('chatMessages');

    // WebSocket connection
    const socket = new SockJS(ctx + '/ws-chat');
    const stompClient = Stomp.over(socket);
    stompClient.debug = null; // silence logs
    stompClient.connect({}, function() {
      stompClient.subscribe('/topic/doctor-chat/' + doctorId, function(payload) {
        const msg = JSON.parse(payload.body);
        
        // Ensure the message is for the current conversation
        if (targetUserId && msg.userId && msg.userId != targetUserId) return;
        
        appendMsg(msg.message, msg.senderType === senderType ? 'sent' : 'received');
      });
    });

    function sendMsg() {
      const input = document.getElementById('msgInput');
      const text = input.value.trim();
      if (!text) return;
      input.value = '';

      // Clear empty state
      const empty = chatBox.querySelector('.ch-empty');
      if (empty) empty.remove();

      fetch(ctx + '/doctors/chat/send', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'doctorId=' + doctorId + '&message=' + encodeURIComponent(text) + '&senderType=' + senderType + (targetUserId ? '&userId=' + targetUserId : '')
      });
    }

    function appendMsg(text, type) {
      const div = document.createElement('div');
      div.className = 'ch-msg ' + type;
      div.innerHTML = text + '<span class="time">Just now</span>';
      chatBox.appendChild(div);
      chatBox.scrollTop = chatBox.scrollHeight;
    }

    // Auto scroll
    chatBox.scrollTop = chatBox.scrollHeight;
  </script>
</body>
</html>

