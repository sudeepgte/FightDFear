<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <title>${audioOnly ? 'Voice' : 'Video'} Call — ${peerName}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      height: 100dvh;
      overflow: hidden;
      background: #0B1120;
      color: #fff;
      font-family: 'Inter', sans-serif;
    }
    
    .call-container {
      position: relative;
      width: 100%;
      height: 100%;
      height: 100dvh;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .call-header {
      height: 60px;
      background: rgba(15, 23, 42, 0.85);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 20px;
      z-index: 100;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }

    .call-header .brand {
      font-size: 16px;
      font-weight: 800;
      color: #F43F5E;
      display: flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
    }

    .call-info {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .call-info .peer-meta {
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .call-info .peer-name {
      font-weight: 700;
      font-size: 14px;
      color: #F8FAFC;
    }

    .call-info .peer-role {
      font-size: 11px;
      color: #94A3B8;
    }

    .call-info .badge {
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 5px;
    }

    .badge.video { background: rgba(244, 63, 94, 0.2); color: #FB7185; border: 1px solid rgba(244, 63, 94, 0.3); }
    .badge.voice { background: rgba(22, 163, 74, 0.2); color: #4ADE80; border: 1px solid rgba(22, 163, 74, 0.3); }

    .video-viewport {
      flex: 1;
      position: relative;
      background: radial-gradient(circle at center, #1E293B 0%, #0F172A 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      min-height: 0;
    }

    #remoteVideo {
      width: 100%;
      height: 100%;
      object-fit: cover;
      background: transparent;
    }

    #localVideo {
      position: absolute;
      top: 18px;
      right: 18px;
      width: 200px;
      aspect-ratio: 4/3;
      border-radius: 14px;
      object-fit: cover;
      border: 2px solid rgba(255, 255, 255, 0.25);
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
      background: #000;
      z-index: 10;
      transform: scaleX(-1);
      transition: all 0.25s ease;
    }

    .voice-avatar-wrap {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
      z-index: 5;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .avatar-pulse {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      background: linear-gradient(135deg, #E11D48, #F43F5E);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 46px;
      font-weight: 800;
      color: #fff;
      margin-bottom: 18px;
      box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.4);
      animation: pulseGlow 2.2s infinite;
    }

    @keyframes pulseGlow {
      0% { box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.6); }
      70% { box-shadow: 0 0 0 24px rgba(244, 63, 94, 0); }
      100% { box-shadow: 0 0 0 0 rgba(244, 63, 94, 0); }
    }

    .voice-avatar-wrap h3 {
      font-size: 1.25rem;
      font-weight: 700;
      margin-bottom: 4px;
      color: #fff;
    }

    .voice-avatar-wrap .role-tag {
      font-size: 0.82rem;
      color: #94A3B8;
      margin-bottom: 10px;
    }

    .call-timer-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: rgba(255, 255, 255, 0.1);
      padding: 5px 14px;
      border-radius: 999px;
      font-size: 0.88rem;
      font-weight: 700;
      letter-spacing: 0.5px;
      color: #E2E8F0;
    }

    .status-toast {
      position: absolute;
      top: 18px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(15, 23, 42, 0.85);
      border: 1px solid rgba(255, 255, 255, 0.12);
      padding: 8px 18px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 600;
      z-index: 20;
      display: flex;
      align-items: center;
      gap: 8px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }
    .status-toast .dot {
      width: 8px; height: 8px; border-radius: 50%; background: #38BDF8;
      box-shadow: 0 0 8px #38BDF8;
    }
    .status-toast.connected .dot { background: #10B981; box-shadow: 0 0 8px #10B981; }
    .status-toast.error .dot { background: #EF4444; box-shadow: 0 0 8px #EF4444; }

    .call-controls {
      position: absolute;
      bottom: 28px;
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      align-items: center;
      gap: 16px;
      z-index: 100;
      background: rgba(15, 23, 42, 0.75);
      padding: 12px 24px;
      border-radius: 999px;
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      border: 1px solid rgba(255, 255, 255, 0.12);
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
    }

    .ctrl-btn {
      width: 52px;
      height: 52px;
      border-radius: 50%;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      cursor: pointer;
      transition: all 0.2s ease;
      color: #fff;
      background: rgba(255, 255, 255, 0.15);
    }
    .ctrl-btn:hover {
      background: rgba(255, 255, 255, 0.25);
      transform: translateY(-2px);
    }
    .ctrl-btn.active {
      background: #EF4444 !important;
      color: #fff !important;
    }
    .ctrl-btn.hangup {
      background: #E11D48;
      width: 60px;
      height: 60px;
      font-size: 26px;
    }
    .ctrl-btn.hangup:hover {
      background: #BE123C;
      transform: scale(1.06);
    }

    /* Responsive adjustments for phones and tablets */
    @media (max-width: 768px) {
      .call-header { padding: 0 14px; height: 54px; }
      .call-header .brand span { display: none; }
      .call-info .peer-name { font-size: 13px; max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
      #localVideo {
        top: 12px;
        right: 12px;
        width: 120px;
        border-radius: 10px;
      }
      .call-controls {
        bottom: calc(18px + env(safe-area-inset-bottom, 0px));
        padding: 10px 18px;
        gap: 12px;
      }
      .ctrl-btn { width: 44px; height: 44px; font-size: 18px; }
      .ctrl-btn.hangup { width: 52px; height: 52px; font-size: 22px; }
      .avatar-pulse { width: 96px; height: 96px; font-size: 36px; }
    }
    @media (max-width: 420px) {
      #localVideo { width: 100px; }
      .call-controls { gap: 8px; padding: 8px 14px; }
      .ctrl-btn { width: 40px; height: 40px; font-size: 16px; }
      .ctrl-btn.hangup { width: 48px; height: 48px; font-size: 20px; }
    }
  </style>
</head>
<body>
  <div class="call-container">
    <div class="call-header">
      <a href="${pageContext.request.contextPath}/" class="brand">
        <i class="bi bi-shield-heart-fill"></i>
        <span>Fight D Fear</span>
      </a>

      <div class="call-info">
        <div class="peer-meta">
          <span class="peer-name">${peerName}</span>
          <span class="peer-role">${peerRole}</span>
        </div>
        <span class="badge ${audioOnly ? 'voice' : 'video'}">
          <i class="bi ${audioOnly ? 'bi-telephone-fill' : 'bi-camera-video-fill'}"></i>
          ${audioOnly ? 'Voice' : 'Video'}
        </span>
      </div>

      <button type="button" class="ctrl-btn hangup" style="width:36px;height:36px;font-size:16px;" onclick="closeCall()" title="Leave">
        <i class="bi bi-x-lg"></i>
      </button>
    </div>

    <div class="video-viewport">
      <video id="remoteVideo" autoplay playsinline></video>
      <video id="localVideo" autoplay playsinline muted></video>

      <c:if test="${audioOnly}">
        <div class="voice-avatar-wrap">
          <div class="avatar-pulse">
            ${not empty peerName ? peerName.substring(0, 1).toUpperCase() : 'D'}
          </div>
          <h3>${peerName}</h3>
          <div class="role-tag">${peerRole} Consultation</div>
          <div class="call-timer-badge">
            <i class="bi bi-stopwatch"></i>
            <span id="callDuration">00:00</span>
          </div>
        </div>
      </c:if>

      <div id="statusToast" class="status-toast">
        <span class="dot"></span>
        <span id="statusMessage">Connecting to secure consultation...</span>
      </div>
    </div>

    <div class="call-controls">
      <button id="resyncBtn" class="ctrl-btn" title="Re-sync WebRTC connection">
        <i class="bi bi-arrow-clockwise"></i>
      </button>

      <button id="muteBtn" class="ctrl-btn" title="Mute/Unmute Mic">
        <i class="bi bi-mic-fill"></i>
      </button>

      <c:if test="${!audioOnly}">
        <button id="videoBtn" class="ctrl-btn" title="Camera On/Off">
          <i class="bi bi-camera-video-fill"></i>
        </button>
      </c:if>

      <button id="hangupBtn" class="ctrl-btn hangup" title="End Consultation">
        <i class="bi bi-telephone-x-fill"></i>
      </button>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

  <script>
    const myId = ${myId};
    const myRole = '${myRole}';
    const targetId = ${targetId};
    const roomName = '${roomName}';
    const audioOnly = ${audioOnly};
    const contextPath = '${pageContext.request.contextPath}';

    let localStream = null;
    let peerConnection = null;
    let stompClient = null;
    let isMuted = false;
    let isVideoOff = false;
    let iceCandidatesQueue = [];
    let isMakingOffer = false;
    let isSettingRemoteDescription = false;
    let timerStarted = false;
    let timerInterval = null;

    const iceConfig = {
      iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
        { urls: 'stun:stun1.l.google.com:19302' },
        { urls: 'stun:stun2.l.google.com:19302' },
        { urls: 'stun:stun3.l.google.com:19302' },
        { urls: 'stun:stun4.l.google.com:19302' }
      ]
    };

    function updateStatus(msg, type) {
      const toast = document.getElementById('statusToast');
      const text = document.getElementById('statusMessage');
      if (text) text.textContent = msg;
      if (toast) {
        toast.className = 'status-toast' + (type ? ' ' + type : '');
      }
    }

    async function initMedia() {
      try {
        updateStatus('Accessing media devices...');
        const constraints = {
          audio: {
            echoCancellation: true,
            noiseSuppression: true,
            autoGainControl: true
          },
          video: audioOnly ? false : {
            width: { ideal: 1280 },
            height: { ideal: 720 },
            facingMode: 'user'
          }
        };

        localStream = await navigator.mediaDevices.getUserMedia(constraints);
        const localVideo = document.getElementById('localVideo');
        if (localVideo) {
          if (audioOnly) {
            localVideo.style.display = 'none';
          } else {
            localVideo.srcObject = localStream;
            localVideo.onloadedmetadata = () => localVideo.play().catch(e => console.log('play local err:', e));
          }
        }
        connectWebSocket();
      } catch (err) {
        console.error('Media devices error:', err);
        updateStatus('Media error: ' + (err.message || 'Permission denied'), 'error');
      }
    }

    function connectWebSocket() {
      updateStatus('Connecting signaling server...');
      const socket = new SockJS(contextPath + '/ws-chat');
      stompClient = Stomp.over(socket);
      stompClient.debug = null;

      stompClient.connect({}, function () {
        updateStatus('Waiting for ' + '${peerName}' + '...');
        stompClient.subscribe('/topic/calls/' + myId, function (payload) {
          try {
            const data = JSON.parse(payload.body);
            handleSignalingData(data);
          } catch (e) {
            console.error('Signaling parse error:', e);
          }
        });

        // Announce join
        sendSignal({ type: 'JOINED', roomName: roomName });
      }, function (err) {
        console.error('STOMP connection error:', err);
        updateStatus('Signaling disconnected, retrying...', 'error');
        setTimeout(connectWebSocket, 4000);
      });
    }

    function sendSignal(data) {
      if (stompClient && stompClient.connected) {
        stompClient.send("/app/webrtc.signal", {}, JSON.stringify({
          ...data,
          senderId: myId,
          receiverId: targetId,
          roomName: roomName
        }));
      }
    }

    async function handleSignalingData(data) {
      if (!data || !data.type) return;
      if (data.roomName && data.roomName !== roomName) {
        return;
      }

      console.log('Received signal:', data.type);
      try {
        if (data.type === 'JOINED') {
          updateStatus('${peerName} joined. Connecting...', 'connected');
          createOffer();
        } else if (data.type === 'READY_TO_RECEIVE') {
          createOffer();
        } else if (data.type === 'OFFER') {
          await handleOffer(data.offer);
        } else if (data.type === 'ANSWER') {
          await handleAnswer(data.answer);
        } else if (data.type === 'CANDIDATE') {
          await handleCandidate(data.candidate);
        } else if (data.type === 'RESYNC') {
          createOffer();
        } else if (data.type === 'DECLINED') {
          updateStatus('Call was declined', 'error');
          setTimeout(closeCall, 1500);
        } else if (data.type === 'HANGUP') {
          updateStatus('Consultation ended', 'connected');
          setTimeout(closeCall, 1000);
        }
      } catch (e) {
        console.error('Handle signal error:', e);
      }
    }

    function createPeerConnection() {
      if (peerConnection) return;
      peerConnection = new RTCPeerConnection(iceConfig);

      if (localStream) {
        localStream.getTracks().forEach(track => {
          peerConnection.addTrack(track, localStream);
        });
      }

      peerConnection.ontrack = function (e) {
        const remoteVideo = document.getElementById('remoteVideo');
        if (remoteVideo && e.streams && e.streams[0]) {
          if (remoteVideo.srcObject !== e.streams[0]) {
            remoteVideo.srcObject = e.streams[0];
            remoteVideo.onloadedmetadata = () => remoteVideo.play().catch(err => console.log('remote play err:', err));
          }
        }
        updateStatus('Connected', 'connected');
        startTimer();
      };

      peerConnection.onicecandidate = function (e) {
        if (e.candidate) {
          sendSignal({ type: 'CANDIDATE', candidate: e.candidate });
        }
      };

      peerConnection.onconnectionstatechange = function () {
        if (!peerConnection) return;
        const state = peerConnection.connectionState;
        if (state === 'connected') {
          updateStatus('Connected', 'connected');
          startTimer();
        } else if (state === 'disconnected' || state === 'failed') {
          updateStatus('Reconnecting...', 'error');
          if (peerConnection.restartIce) peerConnection.restartIce();
        }
      };
    }

    async function createOffer() {
      try {
        isMakingOffer = true;
        createPeerConnection();
        const offer = await peerConnection.createOffer({
          offerToReceiveAudio: true,
          offerToReceiveVideo: !audioOnly
        });
        if (peerConnection.signalingState !== 'stable') return;
        await peerConnection.setLocalDescription(offer);
        sendSignal({ type: 'OFFER', offer: peerConnection.localDescription });
      } catch (err) {
        console.error('Offer creation error:', err);
      } finally {
        isMakingOffer = false;
      }
    }

    async function handleOffer(offer) {
      try {
        createPeerConnection();
        isSettingRemoteDescription = true;
        await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
        isSettingRemoteDescription = false;

        while (iceCandidatesQueue.length > 0) {
          const candidate = iceCandidatesQueue.shift();
          await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
        }

        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        sendSignal({ type: 'ANSWER', answer: peerConnection.localDescription });
      } catch (err) {
        console.error('Handle offer error:', err);
      }
    }

    async function handleAnswer(answer) {
      try {
        if (!peerConnection) return;
        await peerConnection.setRemoteDescription(new RTCSessionDescription(answer));
        while (iceCandidatesQueue.length > 0) {
          const candidate = iceCandidatesQueue.shift();
          await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
        }
      } catch (err) {
        console.error('Handle answer error:', err);
      }
    }

    async function handleCandidate(candidate) {
      try {
        if (!peerConnection || isSettingRemoteDescription || !peerConnection.remoteDescription) {
          iceCandidatesQueue.push(candidate);
        } else {
          await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
        }
      } catch (err) {
        console.error('Candidate error:', err);
      }
    }

    // Call controls
    document.getElementById('muteBtn').onclick = function () {
      if (!localStream) return;
      isMuted = !isMuted;
      localStream.getAudioTracks().forEach(t => t.enabled = !isMuted);
      this.classList.toggle('active', isMuted);
      this.innerHTML = isMuted ? '<i class="bi bi-mic-mute-fill"></i>' : '<i class="bi bi-mic-fill"></i>';
    };

    const videoBtn = document.getElementById('videoBtn');
    if (videoBtn) {
      videoBtn.onclick = function () {
        if (!localStream) return;
        isVideoOff = !isVideoOff;
        localStream.getVideoTracks().forEach(t => t.enabled = !isVideoOff);
        this.classList.toggle('active', isVideoOff);
        this.innerHTML = isVideoOff ? '<i class="bi bi-camera-video-off-fill"></i>' : '<i class="bi bi-camera-video-fill"></i>';
      };
    }

    document.getElementById('resyncBtn').onclick = function () {
      updateStatus('Re-syncing connection...');
      sendSignal({ type: 'RESYNC' });
      createOffer();
    };

    document.getElementById('hangupBtn').onclick = function () {
      sendSignal({ type: 'HANGUP' });
      closeCall();
    };

    function startTimer() {
      if (timerStarted) return;
      timerStarted = true;
      const startTime = Date.now();
      timerInterval = setInterval(function () {
        const delta = Date.now() - startTime;
        const mins = Math.floor(delta / 60000).toString().padStart(2, '0');
        const secs = Math.floor((delta % 60000) / 1000).toString().padStart(2, '0');
        const el = document.getElementById('callDuration');
        if (el) el.textContent = mins + ':' + secs;
      }, 1000);
    }

    function closeCall() {
      if (timerInterval) clearInterval(timerInterval);
      if (localStream) {
        localStream.getTracks().forEach(t => t.stop());
      }
      if (peerConnection) {
        peerConnection.ontrack = null;
        peerConnection.onicecandidate = null;
        peerConnection.close();
      }
      if (stompClient && stompClient.connected) {
        try { stompClient.disconnect(); } catch (e) {}
      }
      window.close();
      if (window.opener) {
        // Opener exists, close popup
      } else {
        const backUrl = myRole === 'DOCTOR' ?
          contextPath + '/doctors/dashboard?section=chats' :
          contextPath + '/doctors/view/${doctor.id}';
        window.location.href = backUrl;
      }
    }

    window.onbeforeunload = function () {
      sendSignal({ type: 'HANGUP' });
    };

    initMedia();
  </script>
  <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
