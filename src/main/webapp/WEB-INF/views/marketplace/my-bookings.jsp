<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Bookings | Marketplace</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- SockJS & Stomp -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #fffcfd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: #333;
            min-height: 100vh;
        }

        .header-bg {
            background: linear-gradient(135deg, var(--m-purple) 0%, #4a1e38 100%);
            padding: 50px 0;
            color: white;
            margin-bottom: 40px;
        }

        .booking-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(124, 45, 94, 0.05);
            border: 1px solid rgba(0,0,0,0.05);
        }

        .table thead th {
            background: #fdf2f8;
            color: var(--m-purple);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.75rem;
            border: none;
            padding: 15px;
        }

        .status-pill {
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 800;
        }

        .status-PENDING { background: #fff9db; color: #f59f00; }
        .status-CONFIRMED { background: #ebfbee; color: #37b24d; }
        .status-COMPLETED { background: #e7f5ff; color: #228be6; }
        .status-CANCELLED { background: #fff5f5; color: #fa5252; }

        .nav-tabs-custom {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        .nav-tabs-custom a {
            text-decoration: none;
            color: #888;
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 12px;
            transition: 0.3s;
        }

        .nav-tabs-custom a.active {
            color: var(--m-purple);
            background: #fdf2f8;
        }

        /* Communication Modals */
        .comm-modal {
            background: rgba(0, 0, 0, 0.8) !important;
            backdrop-filter: blur(10px);
        }
        .comm-content {
            background: #fff !important;
            border: 1px solid rgba(0,0,0,0.1) !important;
            border-radius: 24px !important;
            overflow: hidden;
        }
        .chat-area {
            height: 400px;
            overflow-y: auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            background: #f8f9fa;
        }
        .chat-msg {
            max-width: 80%;
            padding: 10px 15px;
            border-radius: 18px;
            font-size: 0.9rem;
        }
        .chat-msg.sent {
            align-self: flex-end;
            background: var(--m-purple);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .chat-msg.received {
            align-self: flex-start;
            background: #e9ecef;
            color: #333;
            border-bottom-left-radius: 4px;
        }
        .video-container {
            position: relative;
            width: 100%;
            aspect-ratio: 16/9;
            background: #000;
            border-radius: 12px;
            overflow: hidden;
        }
        #remoteVideo {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        #localVideo {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 30%;
            aspect-ratio: 16/9;
            background: #222;
            border: 2px solid var(--m-pink);
            border-radius: 8px;
            z-index: 10;
            object-fit: cover;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="header-bg">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-900 m-0">My Marketplace</h1>
                <p class="m-0 opacity-75">Track your personal sessions and class enrollments.</p>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="nav-tabs-custom">
            <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="active">Personal Sessions</a>
            <a href="${pageContext.request.contextPath}/marketplace/my-classes">Joined Classes</a>
        </div>

        <div class="booking-card">
            <c:if test="${empty bookings}">
                <div class="text-center py-5">
                    <i class="bi bi-calendar-x display-1 text-muted opacity-25"></i>
                    <h4 class="mt-4 text-muted">No personal sessions booked yet.</h4>
                    <p class="text-muted">Browse the marketplace to find experts for one-on-one help.</p>
                    <a href="${pageContext.request.contextPath}/marketplace" class="btn btn-primary mt-3 px-4">Browse Marketplace</a>
                </div>
            </c:if>

            <c:if test="${not empty bookings}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Provider</th>
                                <th>Category</th>
                                <th>Scheduled Time</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>
                                        <div class="fw-800 color-m-purple">${b.provider.fullName}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark">${b.provider.category}</span>
                                    </td>
                                    <td>
                                        <div class="small fw-600">${b.requestedTime}</div>
                                    </td>
                                    <td>
                                        <span class="status-pill status-${b.status}">${b.status}</span>
                                    </td>
                                    <td>
                                        <c:if test="${b.status.name() == 'CONFIRMED'}">
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="openChat(${b.id}, '${b.provider.fullName}')">
                                                    <i class="bi bi-chat-dots-fill"></i> Chat
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="startVideoCall(${b.id}, '${b.provider.fullName}')">
                                                    <i class="bi bi-camera-video-fill"></i> Video
                                                </button>
                                            </div>
                                        </c:if>
                                        <c:if test="${b.status.name() != 'CONFIRMED'}">
                                            <span class="text-muted small">Available when confirmed</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
        <h4 class="fw-bold mt-5 mb-3" style="color: var(--m-purple);"><i class="fas fa-briefcase"></i> Booked Workers</h4>
        <div class="booking-card">
            <c:if test="${empty workerBookings}">
                <div class="text-center py-4">
                    <p class="text-muted">You haven't booked any verified workers yet.</p>
                </div>
            </c:if>
            <c:if test="${not empty workerBookings}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Worker</th>
                                <th>Category</th>
                                <th>Scheduled Time</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="wb" items="${workerBookings}">
                                <tr>
                                    <td>
                                        <div class="fw-800 color-m-purple">${wb.jobApplication.user.fullName}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark">${wb.jobApplication.jobSubCategory}</span>
                                    </td>
                                    <td>
                                        <div class="small fw-600 mb-1"><i class="far fa-calendar-alt text-muted"></i> ${wb.bookingDate}</div>
                                        <div class="badge bg-light text-dark border">
                                            <c:if test="${wb.hours != null}"><strong>Hours:</strong> ${wb.hours}</c:if>
                                            <c:if test="${wb.hours == null}"><strong>Custom Offer</strong></c:if>
                                        </div>
                                        <div class="badge bg-success-subtle text-success border border-success-subtle mt-1">
                                            <strong>Total:</strong> &#8377;${wb.totalAmount != null ? wb.totalAmount : 0.0}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-pill status-${wb.status}">${wb.status}</span>
                                    </td>
                                    <td>
                                        <c:if test="${wb.status == 'ACCEPTED' || wb.status == 'COMPLETED'}">
                                            <div class="d-flex gap-2 align-items-center">
                                                <a href="${pageContext.request.contextPath}/chat/window/${wb.jobApplication.user.id}" class="btn btn-sm btn-outline-primary rounded-pill"><i class="fas fa-comment-dots"></i> Chat</a>
                                                <form action="${pageContext.request.contextPath}/marketplace/worker-booking/${wb.id}/pay" method="POST" class="m-0">
                                                    <button type="submit" class="btn btn-sm btn-success rounded-pill px-3"><i class="fas fa-credit-card"></i> Pay</button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${wb.status != 'ACCEPTED' && wb.status != 'PAID' && wb.status != 'COMPLETED'}">
                                            <span class="text-muted small">-</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Chat Modal -->
    <div class="modal fade comm-modal" id="chatModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content comm-content">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-700" id="chatPartnerName">Chat</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div id="chatArea" class="chat-area"></div>
                    <div class="p-4 pt-0">
                        <div class="input-group">
                            <input type="text" id="chatInput" class="form-control" placeholder="Type a message..." style="border-radius: 12px 0 0 12px; border: 1px solid #ddd;">
                            <button class="btn btn-primary px-4" onclick="sendMessage()" style="border-radius: 0 12px 12px 0; background: var(--m-purple); border: none;">
                                <i class="bi bi-send-fill"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Video Modal -->
    <div class="modal fade comm-modal" id="videoModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content comm-content">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="modal-title fw-700">Video Call: <span id="videoPartnerName"></span></h5>
                    <div class="ms-auto me-3 fw-600 color-m-pink" id="callTimer">00:00</div>
                    <button type="button" class="btn-close" onclick="endCall()"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="video-container mb-4">
                        <video id="remoteVideo" autoplay playsinline></video>
                        <video id="localVideo" autoplay playsinline muted></video>
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <button id="muteBtn" class="btn btn-outline-secondary rounded-pill p-3" onclick="toggleMute()" title="Toggle Mute">
                            <i class="bi bi-mic-fill"></i>
                        </button>
                        <button id="videoBtn" class="btn btn-outline-secondary rounded-pill p-3" onclick="toggleVideo()" title="Toggle Video">
                            <i class="bi bi-camera-video-fill"></i>
                        </button>
                        <button class="btn btn-danger rounded-pill px-5 py-3 fw-700" onclick="endCall()">
                            <i class="bi bi-telephone-x-fill me-2"></i> End Call
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = '${pageContext.request.contextPath}';
        let stompClient = null;
        let currentBookingId = null;
        let localStream = null;
        let peerConnection = null;
        let callTimerInterval = null;
        let secondsElapsed = 0;
        let isMuted = false;
        let isVideoOff = false;
        let iceCandidatesQueue = [];
        const config = { 
            iceServers: [
                { urls: 'stun:stun.l.google.com:19302' },
                { urls: 'stun:stun1.l.google.com:19302' }
            ] 
        };

        function initWebSocket(bookingId) {
            if (stompClient && currentBookingId === bookingId) return;
            
            // Allow multiple listeners or just ensure we don't disconnect if we need to listen for calls
            // if (stompClient) stompClient.disconnect();
            
            currentBookingId = bookingId;

            const socket = new SockJS(ctx + '/ws-chat');
            const client = Stomp.over(socket);
            client.debug = null;

            client.connect({}, () => {
                stompClient = client;
                client.subscribe('/topic/marketplace-chat/' + bookingId, (payload) => {
                    const msg = JSON.parse(payload.body);
                    handleIncomingMessage(msg, bookingId);
                });
            });
        }

        function handleIncomingMessage(msg, bookingId) {
            if (msg.type === 'CHAT') {
                if (currentBookingId === bookingId) {
                    appendChatMessage(msg.content, msg.senderRole === 'USER' ? 'sent' : 'received');
                }
            } else if (msg.type === 'SIGNAL_OFFER') {
                currentBookingId = bookingId;
                handleOffer(msg.content);
            } else if (msg.type === 'SIGNAL_ANSWER') {
                handleAnswer(msg.content);
            } else if (msg.type === 'SIGNAL_ICE') {
                handleIceCandidate(msg.content);
            } else if (msg.type === 'END_CALL') {
                closeVideoModal();
            }
        }

        function openChat(bookingId, partnerName) {
            document.getElementById('chatPartnerName').innerText = partnerName;
            document.getElementById('chatArea').innerHTML = '';
            initWebSocket(bookingId);
            
            // Load history
            fetch(ctx + '/marketplace/chat-history/' + bookingId)
                .then(res => res.json())
                .then(history => {
                    history.forEach(msg => {
                        appendChatMessage(msg.content, msg.senderRole === 'USER' ? 'sent' : 'received');
                    });
                    new bootstrap.Modal(document.getElementById('chatModal')).show();
                });
        }

        // Initialize all confirmed bookings on load
        document.addEventListener('DOMContentLoaded', () => {
            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.status.name() == 'CONFIRMED'}">
                    initWebSocket(${b.id});
                </c:if>
            </c:forEach>
        });

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content || !stompClient) return;

            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'CHAT',
                content: content,
                senderRole: 'USER'
            }));
            input.value = '';
        }

        function appendChatMessage(content, type) {
            const div = document.createElement('div');
            div.className = 'chat-msg ' + type;
            div.innerText = content;
            const area = document.getElementById('chatArea');
            area.appendChild(div);
            area.scrollTop = area.scrollHeight;
        }

        async function startVideoCall(bookingId, partnerName) {
            document.getElementById('videoPartnerName').innerText = partnerName;
            initWebSocket(bookingId);
            const modal = new bootstrap.Modal(document.getElementById('videoModal'));
            modal.show();

            try {
                localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                document.getElementById('localVideo').srcObject = localStream;
                
                if (peerConnection) peerConnection.close();
                createPeerConnection();
                localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));

                const offer = await peerConnection.createOffer();
                await peerConnection.setLocalDescription(offer);
                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                    type: 'SIGNAL_OFFER', content: JSON.stringify(offer)
                }));
            } catch (err) {
                console.error('Call failed', err);
                alert('Could not access camera/microphone. Please ensure you have granted permissions.');
                modal.hide();
            }
        }

        function createPeerConnection() {
            peerConnection = new RTCPeerConnection(config);
            iceCandidatesQueue = [];

            peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                        type: 'SIGNAL_ICE', content: JSON.stringify(event.candidate)
                    }));
                }
            };
            peerConnection.ontrack = (event) => {
                const remoteVideo = document.getElementById('remoteVideo');
                if (event.streams && event.streams[0]) {
                    remoteVideo.srcObject = event.streams[0];
                } else {
                    let remoteStream = remoteVideo.srcObject;
                    if (!remoteStream) {
                        remoteStream = new MediaStream();
                        remoteVideo.srcObject = remoteStream;
                    }
                    remoteStream.addTrack(event.track);
                }
                remoteVideo.play().catch(e => console.warn("Auto-play blocked", e));
            };
            peerConnection.onconnectionstatechange = () => {
                if (peerConnection.connectionState === 'connected') {
                    startTimer();
                }
            };
        }

        async function handleOffer(content) {
            if (peerConnection) peerConnection.close();
            createPeerConnection();
            
            const offer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(offer));
            
            // Process queued candidates
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }

            if (!localStream) {
                try {
                    localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                    document.getElementById('localVideo').srcObject = localStream;
                    localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));
                    new bootstrap.Modal(document.getElementById('videoModal')).show();
                } catch (err) {
                    console.error('Failed to get media', err);
                }
            }

            const answer = await peerConnection.createAnswer();
            await peerConnection.setLocalDescription(answer);
            stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                type: 'SIGNAL_ANSWER', content: JSON.stringify(answer)
            }));
        }

        async function handleAnswer(content) {
            const answer = JSON.parse(content);
            await peerConnection.setRemoteDescription(new RTCSessionDescription(answer));
            
            // Process queued candidates
            while (iceCandidatesQueue.length > 0) {
                const candidate = iceCandidatesQueue.shift();
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            }
        }

        async function handleIceCandidate(content) {
            const candidate = JSON.parse(content);
            if (peerConnection && peerConnection.remoteDescription) {
                await peerConnection.addIceCandidate(new RTCIceCandidate(candidate));
            } else {
                iceCandidatesQueue.push(candidate);
            }
        }

        function toggleMute() {
            if (localStream) {
                isMuted = !isMuted;
                localStream.getAudioTracks().forEach(track => track.enabled = !isMuted);
                const btn = document.getElementById('muteBtn');
                btn.innerHTML = isMuted ? '<i class="bi bi-mic-mute-fill text-danger"></i>' : '<i class="bi bi-mic-fill"></i>';
                btn.classList.toggle('btn-outline-danger', isMuted);
            }
        }

        function toggleVideo() {
            if (localStream) {
                isVideoOff = !isVideoOff;
                localStream.getVideoTracks().forEach(track => track.enabled = !isVideoOff);
                const btn = document.getElementById('videoBtn');
                btn.innerHTML = isVideoOff ? '<i class="bi bi-camera-video-off-fill text-danger"></i>' : '<i class="bi bi-camera-video-fill"></i>';
                btn.classList.toggle('btn-outline-danger', isVideoOff);
            }
        }

        function startTimer() {
            if (callTimerInterval) return;
            secondsElapsed = 0;
            const timerEl = document.getElementById('callTimer');
            callTimerInterval = setInterval(() => {
                secondsElapsed++;
                const mins = Math.floor(secondsElapsed / 60).toString().padStart(2, '0');
                const secs = (secondsElapsed % 60).toString().padStart(2, '0');
                timerEl.innerText = mins + ':' + secs;
            }, 1000);
        }

        function endCall() {
            if (stompClient) stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({ type: 'END_CALL' }));
            closeVideoModal();
        }

        function closeVideoModal() {
            if (localStream) localStream.getTracks().forEach(track => track.stop());
            localStream = null;
            if (peerConnection) peerConnection.close();
            peerConnection = null;
            if (callTimerInterval) {
                clearInterval(callTimerInterval);
                callTimerInterval = null;
            }
            document.getElementById('callTimer').innerText = '00:00';
            // Reset buttons
            isMuted = false;
            isVideoOff = false;
            document.getElementById('muteBtn').innerHTML = '<i class="bi bi-mic-fill"></i>';
            document.getElementById('muteBtn').classList.remove('btn-outline-danger');
            document.getElementById('videoBtn').innerHTML = '<i class="bi bi-camera-video-fill"></i>';
            document.getElementById('videoBtn').classList.remove('btn-outline-danger');

            bootstrap.Modal.getInstance(document.getElementById('videoModal')).hide();
        }
    </script>
</body>
</html>

