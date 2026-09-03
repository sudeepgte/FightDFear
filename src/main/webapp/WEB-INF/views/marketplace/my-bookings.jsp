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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">

        <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            --text-main: #0F172A;
            --border: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
        }

        .header-bg {
            background: var(--card-bg);
            padding: 50px 0;
            color: var(--text-main);
            margin-bottom: 40px;
            border-bottom: 1px solid var(--border);
        }

        .booking-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.02);
            border: 1px solid var(--border);
            width: 100%;
        }

        .table thead th {
            background: #FFE4E6;
            color: var(--primary);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.75rem;
            border: none;
            padding: 15px;
            white-space: nowrap;
        }

        .status-pill {
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 800;
        }

        .status-PENDING { background: var(--warning-bg); color: var(--warning-text); }
        .status-CONFIRMED, .status-COMPLETED, .status-ACCEPTED, .status-PAID { background: var(--success-bg); color: var(--success-text); }
        .status-CANCELLED, .status-REJECTED { background: var(--error-bg); color: var(--error-text); }

        .nav-tabs-custom {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--border);
            padding-bottom: 10px;
        }

        .nav-tabs-custom a {
            text-decoration: none;
            color: var(--secondary);
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 12px;
            transition: 0.3s;
        }

        .nav-tabs-custom a.active {
            color: var(--primary);
            background: #FFE4E6;
            border: 1px solid #FFE4E6;
        }

        /* Communication Modals */
        .comm-modal {
            background: rgba(0, 0, 0, 0.8) !important;
            backdrop-filter: blur(10px);
        }
        .comm-content {
            background: var(--card-bg) !important;
            border: 1px solid var(--border) !important;
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
            background: var(--bg);
        }
        .chat-msg {
            max-width: 80%;
            padding: 10px 15px;
            border-radius: 18px;
            font-size: 0.9rem;
        }
        .chat-msg.sent {
            align-self: flex-end;
            background: var(--primary);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .chat-msg.received {
            align-self: flex-start;
            background: #e9ecef;
            color: var(--text-main);
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
            bottom: 15px;
            right: 15px;
            width: 120px;
            height: 160px;
            background: #333;
            border-radius: 8px;
            border: 2px solid white;
            object-fit: cover;
        }
        .controls {
            display: flex;
            justify-content: center;
            gap: 15px;
            padding: 20px;
            background: #222;
        }
        .btn-control {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            background: #444;
            color: white;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-control:hover { background: #555; }
        .btn-control.end-call { background: var(--error-bg); color: var(--error-text); }
        .btn-control.end-call:hover { background: #fecaca; }
        
        .btn-outline-primary {
            color: var(--primary);
            border-color: var(--primary);
        }
        .btn-outline-primary:hover {
            background-color: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        .text-purple { color: var(--text-main); }
        .fw-800 { font-weight: 800; }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="header-bg">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h1 class="fw-900 m-0" style="color: var(--primary);">My Marketplace</h1>
                <p class="m-0 opacity-75">Track your personal sessions and class enrollments.</p>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="nav-tabs-custom">
            <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="active">Personal Sessions</a>

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
                                        <div class="fw-800 color-m-purple">
                                            <c:choose>
                                                <c:when test="${b.provider != null}">${b.provider.fullName}</c:when>
                                                <c:otherwise>Unknown provider</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark">
                                            <c:if test="${b.provider != null}">${b.provider.category}</c:if>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="small fw-600">${b.requestedTime}</div>
                                    </td>
                                    <td>
                                        <span class="status-pill status-${b.status}">${b.status}</span>
                                    </td>
                                    <td>
                                        <c:if test="${b.status == 'CONFIRMED' && b.provider != null}">
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="openChat(${b.id}, '${b.provider.fullName}')">
                                                    <i class="bi bi-chat-dots-fill"></i> Chat
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="startVideoCall(${b.id}, '${b.provider.fullName}')">
                                                    <i class="bi bi-camera-video-fill"></i> Video
                                                </button>
                                            </div>
                                        </c:if>
                                        <c:if test="${b.status != 'CONFIRMED' || b.provider == null}">
                                            <span class="text-muted small">Available when confirmed</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

        <h4 class="mt-5 mb-3 fw-bold" style="color: var(--primary);"><i class="bi bi-briefcase-fill me-2"></i> Worker Job Bookings</h4>
        <div class="booking-card">
            <c:if test="${empty workerBookings}">
                <div class="text-center py-4">
                    <i class="bi bi-briefcase text-muted opacity-25" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-muted">No worker jobs booked yet.</h5>
                </div>
            </c:if>

            <c:if test="${not empty workerBookings}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Worker Name</th>
                                <th>Job Date</th>
                                <th>Hours</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="wb" items="${workerBookings}">
                                <tr>
                                    <td>
                                        <div class="fw-800 text-dark">
                                            ${wb.jobApplication.user.fullName}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small fw-600">${wb.bookingDate.toString().replace('T', ' ')}</div>
                                    </td>
                                    <td>${wb.hours} hrs</td>
                                    <td>&#8377;${wb.totalAmount}</td>
                                    <td>
                                        <span class="status-pill status-${wb.status}">${wb.status}</span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-info rounded-pill px-3" onclick="openSimpleChat('${wb.jobApplication.user.id}', '${wb.jobApplication.user.fullName}')">
                                            <i class="bi bi-chat-dots-fill"></i> Chat
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

    </div>

    <!-- Simple Chat Modal (Worker Chat) -->
    <div class="modal fade" id="simpleChatModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow rounded-3">
                <div class="modal-header bg-light border-bottom-0">
                    <h5 class="modal-title fw-bold" style="color: #1e1b4b;"><i class="bi bi-chat-dots-fill text-info me-2"></i> Chat with <span id="simpleChatPartnerName"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="background: #f8fafc;">
                    <div id="simpleChatMessages" style="height: 250px; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; margin-bottom: 15px; padding: 10px; background: white; border-radius: 8px; border: 1px solid #e2e8f0;">
                        <div id="simpleChatEmptyState" style="text-align: center; color: #94a3b8; font-size: 0.85rem; margin-top: auto; margin-bottom: auto;">
                            Send a message to start the conversation!
                        </div>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <input type="hidden" id="simpleChatPartnerId" value="">
                        <input type="text" id="simpleChatInput" class="form-control rounded-pill" placeholder="Type a message..." style="flex: 1;" onkeypress="if(event.key === 'Enter') sendSimpleChat()">
                        <button type="button" class="btn btn-info rounded-pill text-white" onclick="sendSimpleChat()"><i class="bi bi-send-fill"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Existing Provider Chat Modal -->
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
                            <button class="btn btn-primary px-4" onclick="sendMessage()" style="border-radius: 0 12px 12px 0; background: var(--text-main); border: none;">
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

    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = '${pageContext.request.contextPath}';
        let stompClient = null;
        let subscribedBookingIds = new Set();
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

        function ensureWebSocket(callback) {
            if (stompClient && stompClient.connected) {
                if (callback) callback();
                return;
            }
            const socket = new SockJS(ctx + '/ws-chat');
            const client = Stomp.over(socket);
            client.debug = null;
            client.connect({}, () => {
                stompClient = client;
                if (callback) callback();
            }, (err) => {
                console.error('WebSocket connect failed', err);
                alert('Live chat requires an active login session. Please refresh and try again.');
            });
        }

        function subscribeBooking(bookingId) {
            ensureWebSocket(() => {
                if (subscribedBookingIds.has(bookingId)) return;
                stompClient.subscribe('/topic/marketplace-chat/' + bookingId, (payload) => {
                    const msg = JSON.parse(payload.body);
                    handleIncomingMessage(msg, bookingId);
                });
                subscribedBookingIds.add(bookingId);
                
                // Subscribe to simple chat messages
                stompClient.subscribe('/topic/messages/${user.id}', function (msg) {
                    var payload = JSON.parse(msg.body);
                    var currentChatId = document.getElementById('simpleChatPartnerId') ? document.getElementById('simpleChatPartnerId').value : null;
                    
                    if (currentChatId && payload.senderId == currentChatId) {
                        var messagesDiv = document.getElementById('simpleChatMessages');
                        var emptyState = document.getElementById('simpleChatEmptyState');
                        if(emptyState) emptyState.remove();
                        
                        var msgHtml = '<div style="align-self: flex-start; background: #e2e8f0; color: #1e293b; padding: 8px 12px; border-radius: 12px; max-width: 80%; font-size: 0.9rem;">' + payload.message + '</div>';
                        messagesDiv.insertAdjacentHTML('beforeend', msgHtml);
                        messagesDiv.scrollTop = messagesDiv.scrollHeight;
                    }
                });
            });
        }

        function openSimpleChat(partnerId, partnerName) {
            document.getElementById('simpleChatPartnerId').value = partnerId;
            document.getElementById('simpleChatPartnerName').textContent = partnerName;
            
            var messagesDiv = document.getElementById('simpleChatMessages');
            messagesDiv.innerHTML = '<div style="text-align: center; color: #94a3b8; font-size: 0.85rem; margin-top: auto; margin-bottom: auto;"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
            
            var chatModal = new bootstrap.Modal(document.getElementById('simpleChatModal'));
            chatModal.show();
            
            fetch('${pageContext.request.contextPath}/chat/messages-since/' + partnerId)
                .then(res => res.json())
                .then(data => {
                    messagesDiv.innerHTML = '';
                    if(data.success && data.messages && data.messages.length > 0) {
                        data.messages.forEach(m => {
                            var isMe = m.senderId != partnerId;
                            var msgHtml = '<div style="align-self: ' + (isMe ? 'flex-end' : 'flex-start') + '; background: ' + (isMe ? '#F43F5E' : '#e2e8f0') + '; color: ' + (isMe ? 'white' : '#1e293b') + '; padding: 8px 12px; border-radius: 12px; max-width: 80%; font-size: 0.9rem;">' + m.message + '</div>';
                            messagesDiv.insertAdjacentHTML('beforeend', msgHtml);
                        });
                    } else {
                        messagesDiv.innerHTML = '<div id="simpleChatEmptyState" style="text-align: center; color: #94a3b8; font-size: 0.85rem; margin-top: auto; margin-bottom: auto;">Send a message to start the conversation!</div>';
                    }
                    messagesDiv.scrollTop = messagesDiv.scrollHeight;
                })
                .catch(err => {
                    messagesDiv.innerHTML = '<div style="text-align: center; color: #ef4444; font-size: 0.85rem; margin-top: auto; margin-bottom: auto;">Failed to load messages</div>';
                });
        }
        
        function sendSimpleChat() {
            var input = document.getElementById('simpleChatInput');
            var msg = input.value.trim();
            if (!msg) return;
            
            var messagesDiv = document.getElementById('simpleChatMessages');
            var emptyState = document.getElementById('simpleChatEmptyState');
            if(emptyState) emptyState.remove();
            
            var msgHtml = '<div style="align-self: flex-end; background: #F43F5E; color: white; padding: 8px 12px; border-radius: 12px 12px 0 12px; max-width: 80%; font-size: 0.9rem;">' + msg + '</div>';
            messagesDiv.insertAdjacentHTML('beforeend', msgHtml);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
            
            input.value = '';
            
            var receiverId = document.getElementById('simpleChatPartnerId').value;
            fetch('${pageContext.request.contextPath}/chat/send-message', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({receiverId: receiverId, message: msg})
            }).then(res => res.json()).then(data => {
                if(!data.success) {
                    messagesDiv.insertAdjacentHTML('beforeend', '<div style="align-self: center; background: #fee2e2; color: #ef4444; padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; margin-top: 5px;">' + (data.error || 'Message could not be sent') + '</div>');
                    messagesDiv.scrollTop = messagesDiv.scrollHeight;
                }
            }).catch(err => console.error(err));
        }

        function initWebSocket(bookingId) {
            currentBookingId = bookingId;
            subscribeBooking(bookingId);
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
            currentBookingId = bookingId;
            subscribeBooking(bookingId);
            
            fetch(ctx + '/marketplace/chat-history/' + bookingId)
                .then(res => {
                    if (!res.ok) throw new Error('Failed to load chat');
                    return res.json();
                })
                .then(history => {
                    (history || []).forEach(msg => {
                        appendChatMessage(msg.content, msg.senderRole === 'USER' ? 'sent' : 'received');
                    });
                    new bootstrap.Modal(document.getElementById('chatModal')).show();
                })
                .catch(err => {
                    console.error(err);
                    alert('Could not load chat history.');
                });
        }

        document.addEventListener('DOMContentLoaded', () => {
            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.status == 'CONFIRMED'}">
                    subscribeBooking(${b.id});
                </c:if>
            </c:forEach>
        });

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content || !currentBookingId) return;
            ensureWebSocket(() => {
                stompClient.send('/app/marketplace-chat/' + currentBookingId, {}, JSON.stringify({
                    type: 'CHAT',
                    content: content
                }));
                input.value = '';
            });
        }

        function appendChatMessage(content, type) {
            const div = document.createElement('div');
            div.className = 'chat-msg ' + type;
            div.innerText = content;
            const area = document.getElementById('chatArea');
            area.appendChild(div);
            area.scrollTop = area.scrollHeight;
        }

        async function payWorkerBooking(bookingId, amount) {
            if (!amount || amount <= 0) {
                alert('Invalid payment amount.');
                return;
            }
            try {
                const res = await fetch(ctx + '/payment/create-order', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ amount: amount, type: 'WORKER_BOOKING' })
                });
                if (!res.ok) throw new Error('Order creation failed');
                const order = await res.json();
                const rzp = new Razorpay({
                    key: order.key,
                    amount: order.amount,
                    currency: 'INR',
                    name: 'Fight D Fear',
                    description: 'Worker booking payment',
                    order_id: order.orderId,
                    handler: async function (response) {
                        const verifyRes = await fetch(ctx + '/payment/verify', {
                            method: 'POST',
                            headers: {'Content-Type': 'application/json'},
                            body: JSON.stringify({
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_signature: response.razorpay_signature,
                                type: 'WORKER_BOOKING',
                                targetId: bookingId
                            })
                        });
                        if (verifyRes.ok) {
                            window.location.reload();
                        } else {
                            alert('Payment verification failed.');
                        }
                    }
                });
                rzp.open();
            } catch (e) {
                console.error(e);
                alert('Unable to start payment. Check Razorpay configuration.');
            }
        }

        async function startVideoCall(bookingId, partnerName) {
            document.getElementById('videoPartnerName').innerText = partnerName;
            currentBookingId = bookingId;
            subscribeBooking(bookingId);
            const modal = new bootstrap.Modal(document.getElementById('videoModal'));
            modal.show();

            try {
                await new Promise((resolve, reject) => {
                    ensureWebSocket(() => resolve());
                    setTimeout(() => reject(new Error('WebSocket timeout')), 8000);
                });
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
                alert('Could not start video call. Check camera permissions and login session.');
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
    </div>
</div>
</body>
</html>






