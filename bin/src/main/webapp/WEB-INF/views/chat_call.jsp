<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${audioOnly ? 'Voice' : 'Video'} Call — ${receiver.fullName}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap">
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body,html{height:100%;overflow:hidden;background:#0f0a1e;font-family:'Poppins',sans-serif;color:#fff}
    
    .call-container {
      position: relative;
      width: 100%;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .call-header{
      height: 60px;
      background: rgba(0,0,0,0.6);
      backdrop-filter: blur(10px);
      display:flex;
      align-items:center;
      justify-content:space-between;
      padding:0 20px;
      z-index:100;
    }

    .brand{font-size:18px;font-weight:800;color:#ffd700;display:flex;align-items:center;gap:8px}
    .call-info{display:flex;align-items:center;gap:15px}
    .call-info .name{font-weight:600;font-size:16px}
    .badge{padding:4px 12px;border-radius:20px;font-size:12px;font-weight:700;display:flex;align-items:center;gap:5px}
    .badge.video{background:rgba(74,144,217,0.2);color:#4a90d9}
    .badge.voice{background:rgba(32,201,151,0.2);color:#20c997}

    .video-grid {
      flex: 1;
      position: relative;
      background: #000;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    #remoteVideo {
      width: 100%;
      height: 100%;
      object-fit: cover;
      background: #1a1a2e;
    }

    #localVideo {
      position: absolute;
      top: 20px;
      right: 20px;
      width: 240px;
      height: 180px;
      border-radius: 12px;
      object-fit: cover;
      border: 2px solid rgba(255,255,255,0.2);
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      background: #000;
      z-index: 10;
      transform: scaleX(-1);
    }

    .audio-only-avatar {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }

    .avatar-circle {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      background: var(--gradient-primary, linear-gradient(135deg, #1e1b4b, #f43f5e));
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 60px;
      margin-bottom: 20px;
      box-shadow: 0 0 30px rgba(219, 39, 119, 0.4);
      animation: pulse 2s infinite;
    }

    @keyframes pulse {
      0% { box-shadow: 0 0 0 0 rgba(219, 39, 119, 0.4); }
      70% { box-shadow: 0 0 0 20px rgba(219, 39, 119, 0); }
      100% { box-shadow: 0 0 0 0 rgba(219, 39, 119, 0); }
    }

    .call-controls {
      position: absolute;
      bottom: 40px;
      left: 50%;
      transform: translateX(-50%);
      display: flex;
      gap: 20px;
      z-index: 100;
      background: rgba(0,0,0,0.5);
      padding: 15px 30px;
      border-radius: 50px;
      backdrop-filter: blur(10px);
    }

    .control-btn {
      width: 55px;
      height: 55px;
      border-radius: 50%;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      cursor: pointer;
      transition: all 0.3s;
      color: #fff;
    }

    .btn-mute { background: rgba(255,255,255,0.15); }
    .btn-mute.active { background: #ff4757; }
    
    .btn-video { background: rgba(255,255,255,0.15); }
    .btn-video.active { background: #ff4757; }

    .btn-hangup {
      background: #ff4757;
      width: 65px;
      height: 65px;
      font-size: 28px;
    }
    .btn-hangup:hover { background: #ff2e44; transform: scale(1.1); }

    .status-msg {
      position: absolute;
      top: 80px;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(0,0,0,0.6);
      padding: 8px 20px;
      border-radius: 20px;
      font-size: 14px;
      z-index: 100;
    }
  </style>
</head>
<body>
  <div class="call-container">
    <div class="call-header">
      <div class="brand"><i class="bi bi-shield-check"></i> Fight D Fear</div>
      <div class="call-info">
        <span class="name">${receiver.fullName}</span>
        <span class="badge ${audioOnly ? 'voice' : 'video'}">
          <i class="bi ${audioOnly ? 'bi-telephone-fill' : 'bi-camera-video-fill'}"></i>
          ${audioOnly ? 'Voice Call' : 'Video Call'}
        </span>
      </div>
      <div></div> <!-- Spacer -->
    </div>

    <div class="video-grid">
      <video id="remoteVideo" autoplay playsinline></video>
      <video id="localVideo" autoplay playsinline muted></video>
      
      <c:if test="${audioOnly}">
        <div class="audio-only-avatar">
          <div class="avatar-circle">
            ${receiver.fullName.substring(0,1).toUpperCase()}
          </div>
          <h3>${receiver.fullName}</h3>
          <p id="callDuration">00:00</p>
        </div>
      </c:if>
    </div>

    <div id="statusMessage" class="status-msg">Connecting...</div>

    <div class="call-controls">
      <button id="resyncBtn" class="control-btn btn-mute" title="Re-sync Connection" style="background: rgba(255,255,255,0.15);">
        <i class="bi bi-arrow-clockwise"></i>
      </button>

      <button id="muteBtn" class="control-btn btn-mute" title="Mute/Unmute">
        <i class="bi bi-mic-fill"></i>
      </button>
      
      <c:if test="${!audioOnly}">
        <button id="videoBtn" class="control-btn btn-video" title="Toggle Video">
          <i class="bi bi-camera-video-fill"></i>
        </button>
      </c:if>

      <button id="hangupBtn" class="control-btn btn-hangup" title="End Call">
        <i class="bi bi-telephone-x-fill"></i>
      </button>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  
  <script>
    const receiverId = ${receiver.id};
    const senderId = ${sessionScope.user.id};
    const audioOnly = ${audioOnly};
    const contextPath = '${pageContext.request.contextPath}';
    
    let localStream = null;
    let peerConnection = null;
    let stompClient = null;
    let isMuted = false;
    let isVideoOff = false;
    let iceCandidatesQueue = [];
    let isMakingOffer = false;
    let isIgnoringOffer = false;
    let isSettingRemoteDescription = false;

    const iceConfig = {
      iceServers: [
        { urls: 'stun:stun.l.google.com:19302' },
        { urls: 'stun:stun1.l.google.com:19302' },
        { urls: 'stun:stun2.l.google.com:19302' },
        { urls: 'stun:stun3.l.google.com:19302' },
        { urls: 'stun:stun4.l.google.com:19302' }
      ]
    };

    async function init() {
      try {
        updateStatus('Requesting camera/mic access...');
        const constraints = {
          audio: {
            echoCancellation: true,
            noiseSuppression: true,
            autoGainControl: true
          },
          video: audioOnly ? false : {
            width: { ideal: 1280 },
            height: { ideal: 720 },
            frameRate: { ideal: 30 }
          }
        };

        localStream = await navigator.mediaDevices.getUserMedia(constraints);
        const localVideo = document.getElementById('localVideo');
        localVideo.srcObject = localStream;
        localVideo.onloadedmetadata = () => localVideo.play();

        if (audioOnly) {
          localVideo.style.display = 'none';
        }

        connectWebSocket();
      } catch (err) {
        console.error('Error accessing media devices:', err);
        updateStatus('Error: ' + err.message);
      }
    }

    function connectWebSocket() {
      const socket = new SockJS(contextPath + '/ws-chat');
      stompClient = Stomp.over(socket);
      stompClient.debug = null;

      stompClient.connect({}, () => {
        updateStatus('Connected to server. Waiting for peer...');
        
        stompClient.subscribe('/topic/calls/' + senderId, (payload) => {
          const data = JSON.parse(payload.body);
          handleSignalingData(data);
        });

        // 🟢 Tell the other side we have joined
        sendSignal({ type: 'JOINED' });
      });
    }

    function sendSignal(data) {
      if (stompClient && stompClient.connected) {
        stompClient.send("/app/webrtc.signal", {}, JSON.stringify({
          ...data,
          senderId: senderId,
          receiverId: receiverId
        }));
      }
    }

    async function handleSignalingData(data) {
      try {
        if (data.type === 'JOINED') {
          console.log("Peer joined the room");
          const urlParams = new URLSearchParams(window.location.search);
          if (urlParams.get('notify') === 'true') {
            // I am the initiator, other side just joined, let's start!
            updateStatus('Peer joined. Starting handshake...');
            createOffer();
          } else {
            // I am the receiver, initiator just joined (or rejoined), let's say hi back
            // so they know I'm ready for their offer
            sendSignal({ type: 'READY_TO_RECEIVE' });
          }
        } else if (data.type === 'READY_TO_RECEIVE') {
          const urlParams = new URLSearchParams(window.location.search);
          if (urlParams.get('notify') === 'true') {
            updateStatus('Peer is ready. Starting handshake...');
            createOffer();
          }
        } else if (data.type === 'OFFER') {
          await handleOffer(data.offer);
        } else if (data.type === 'ANSWER') {
          await handleAnswer(data.answer);
        } else if (data.type === 'CANDIDATE') {
          await handleCandidate(data.candidate);
        } else if (data.type === 'HANGUP') {
          updateStatus('Call ended');
          setTimeout(closeCall, 1000);
        } else if (data.type === 'DECLINED') {
          updateStatus('Call declined');
          setTimeout(closeCall, 1500);
        } else if (data.type === 'RESYNC') {
          console.log("Peer requested RESYNC");
          createOffer();
        }
      } catch (err) {
        console.error("Signaling error:", err);
      }
    }

    function createPeerConnection() {
      if (peerConnection) return;

      console.log("Creating RTCPeerConnection");
      peerConnection = new RTCPeerConnection(iceConfig);

      localStream.getTracks().forEach(track => {
        peerConnection.addTrack(track, localStream);
      });

      peerConnection.ontrack = ({streams: [stream]}) => {
        console.log("Remote track received");
        const remoteVideo = document.getElementById('remoteVideo');
        if (remoteVideo.srcObject !== stream) {
          remoteVideo.srcObject = stream;
          remoteVideo.onloadedmetadata = () => remoteVideo.play();
        }
        updateStatus('Connected');
        startTimer();
      };

      peerConnection.onicecandidate = ({candidate}) => {
        if (candidate) {
          sendSignal({ type: 'CANDIDATE', candidate: candidate });
        }
      };

      peerConnection.oniceconnectionstatechange = () => {
        console.log("ICE state:", peerConnection.iceConnectionState);
        if (peerConnection.iceConnectionState === 'failed') {
          peerConnection.restartIce();
        }
      };

      peerConnection.onconnectionstatechange = () => {
        console.log("Connection state:", peerConnection.connectionState);
        if (peerConnection.connectionState === 'connected') {
          updateStatus('Connected');
          startTimer();
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
        if (peerConnection.signalingState !== "stable") return;
        await peerConnection.setLocalDescription(offer);
        sendSignal({ type: 'OFFER', offer: peerConnection.localDescription });
      } catch (err) {
        console.error("Offer error:", err);
      } finally {
        isMakingOffer = false;
      }
    }

    async function handleOffer(offer) {
      try {
        const offerCollision = (isMakingOffer || peerConnection?.signalingState !== "stable");
        isIgnoringOffer = !offerCollision && false; // We don't ignore for now, just handle collision if needed

        if (isIgnoringOffer) return;

        createPeerConnection();
        isSettingRemoteDescription = true;
        await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
        isSettingRemoteDescription = false;

        // Process queued candidates
        while (iceCandidatesQueue.length > 0) {
          const candidate = iceCandidatesQueue.shift();
          await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
        }

        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        sendSignal({ type: 'ANSWER', answer: peerConnection.localDescription });
      } catch (err) {
        console.error("Handle offer error:", err);
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
        console.error("Handle answer error:", err);
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
        if (!isIgnoringOffer) {
          console.error("Candidate error:", err);
        }
      }
    }

    function updateStatus(msg) {
      document.getElementById('statusMessage').innerText = msg;
    }

    // Controls
    document.getElementById('muteBtn').onclick = () => {
      isMuted = !isMuted;
      localStream.getAudioTracks().forEach(t => t.enabled = !isMuted);
      document.getElementById('muteBtn').classList.toggle('active', isMuted);
      document.getElementById('muteBtn').innerHTML = isMuted ?
        '<i class="bi bi-mic-mute-fill"></i>' : '<i class="bi bi-mic-fill"></i>';
    };

    if (!audioOnly) {
      document.getElementById('videoBtn').onclick = () => {
        isVideoOff = !isVideoOff;
        localStream.getVideoTracks().forEach(t => t.enabled = !isVideoOff);
        document.getElementById('videoBtn').classList.toggle('active', isVideoOff);
        document.getElementById('videoBtn').innerHTML = isVideoOff ?
          '<i class="bi bi-camera-video-off-fill"></i>' : '<i class="bi bi-camera-video-fill"></i>';
      };
    }

    document.getElementById('resyncBtn').onclick = () => {
      updateStatus('Re-syncing...');
      sendSignal({ type: 'RESYNC' });
      createOffer();
    };

    document.getElementById('hangupBtn').onclick = () => {
      sendSignal({ type: 'HANGUP' });
      closeCall();
    };

    function closeCall() {
      if (localStream) localStream.getTracks().forEach(t => t.stop());
      if (peerConnection) {
        peerConnection.ontrack = null;
        peerConnection.onicecandidate = null;
        peerConnection.close();
      }
      window.close();
    }

    let startTime;
    let timerStarted = false;
    function startTimer() {
      if (timerStarted) return;
      timerStarted = true;
      startTime = Date.now();
      setInterval(() => {
        const delta = Date.now() - startTime;
        const mins = Math.floor(delta / 60000).toString().padStart(2, '0');
        const secs = Math.floor((delta % 60000) / 1000).toString().padStart(2, '0');
        const durationEl = document.getElementById('callDuration');
        if (durationEl) durationEl.innerText = mins + ':' + secs;
      }, 1000);
    }

    window.onbeforeunload = () => {
      sendSignal({ type: 'HANGUP' });
    };

    init();
  </script>
</body>
</html>
