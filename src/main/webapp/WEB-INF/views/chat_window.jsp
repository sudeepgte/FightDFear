<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <title>Chat with ${receiver.fullName}</title>

            <!-- Bootstrap -->
            <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap"
                rel="stylesheet">
            <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap"
                rel="stylesheet">

            <!-- Icons & CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"
                rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

            <style>
                /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
                body {
                    background: #f5f5f5;
                }

                .chat-container {
                    max-width: 800px;
                    margin: 30px auto;
                    background: white;
                    border-radius: 10px;
                    padding: 15px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                .chat-header {
                    border-bottom: 1px solid #ddd;
                    padding-bottom: 10px;
                    margin-bottom: 10px;
                }

                .chat-box {
                    height: 400px;
                    overflow-y: auto;
                    padding: 10px;
                    background: #fafafa;
                }

                .message-sent {
                    background: #0d6efd;
                    color: white;
                    padding: 8px 12px;
                    border-radius: 10px;
                    max-width: 70%;
                }

                .message-received {
                    background: #e4e6eb;
                    color: black;
                    padding: 8px 12px;
                    border-radius: 10px;
                    max-width: 70%;
                }

                video {
                    max-width: 250px;
                    border-radius: 10px;
                    margin-top: 5px;
                    display: block;
                }

                .chat-input {
                    display: flex;
                    gap: 10px;
                    margin-top: 10px;
                }

                /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

                /* 1. Root variables for brand colors (optional, not used in original styles) */
                :root {
                    --primary-purple: #1e1b4b;
                    --primary-purple-light: #312e81;
                    --primary-coral: #f43f5e;
                    --primary-coral-dark: #1e1b4b;
                    --primary-teal: #20c997;
                    --primary-gold: #ffd700;
                    --dark-bg: #0f0f1a;
                    --light-bg: #fffcfd;
                    --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
                    --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
                    --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
                }

                /* 2. Smooth fade-in animation for the chat container */
                .chat-container {
                    animation: fadeSlideUp 0.4s ease-out forwards;
                }

                @keyframes fadeSlideUp {
                    from {
                        opacity: 0;
                        transform: translateY(15px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                /* 3. Chat box custom scrollbar (matches brand purple) */
                .chat-box::-webkit-scrollbar {
                    width: 6px;
                }

                .chat-box::-webkit-scrollbar-track {
                    background: #e0e0e0;
                    border-radius: 10px;
                }

                .chat-box::-webkit-scrollbar-thumb {
                    background: #312e81;
                    border-radius: 10px;
                }

                .chat-box::-webkit-scrollbar-thumb:hover {
                    background: #1e1b4b;
                }

                /* 4. Message hover effect (subtle scale) */
                .message-sent,
                .message-received {
                    transition: transform 0.2s ease;
                }

                .message-sent:hover,
                .message-received:hover {
                    transform: scale(1.02);
                }

                /* 5. Video thumbnail hover effect */
                video {
                    transition: transform 0.2s, box-shadow 0.2s;
                    cursor: pointer;
                }

                video:hover {
                    transform: scale(1.02);
                    box-shadow: var(--shadow-sm);
                }

                /* 6. Focus outline for accessibility (if inputs added later) */
                .chat-input input:focus-visible,
                .chat-input button:focus-visible {
                    outline: 3px solid var(--primary-gold, #ffd700);
                    outline-offset: 2px;
                    border-radius: 8px;
                }

                /* 7. Responsive improvements for mobile */
    /* 7. Responsive improvements for mobile */
    @media (max-width: 1200px) {
        html, body {
            margin: 0 !important;
            padding: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            overflow-x: hidden !important;
            position: relative !important;
        }
        .header {
            border-radius: 0 !important;
            margin: 0 !important;
            border: none !important;
            padding: 8px 0 !important;
            position: fixed !important;
            top: 0;
            left: 0 !important;
            right: 0 !important;
            width: 100% !important;
            z-index: 1001 !important;
            height: 60px !important;
            overflow: hidden !important;
        }
        .chat-container {
            position: fixed !important;
            top: 60px !important;
            bottom: 0 !important;
            left: 0 !important;
            right: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
            border: none !important;
            border-radius: 0 !important;
            box-shadow: none !important;
            z-index: 1000 !important;
            background: #fff !important;
            display: flex !important;
            flex-direction: column !important;
            overflow: hidden !important;
        }
        .chat-header {
            padding: 15px 18px !important;
            margin: 0 !important;
            font-size: 18px !important;
            font-weight: 700 !important;
            background: #fdfdfd;
            border-bottom: 1px solid #eee !important;
            flex-shrink: 0;
            color: var(--brand-purple-dark) !important;
        }
        .chat-box {
            padding: 20px 12px !important;
            background: #fff !important;
            flex: 1 !important;
            overflow-y: auto !important;
            margin-bottom: 0 !important;
        }
        .chat-input {
            position: sticky !important;
            bottom: 0 !important;
            width: 100% !important;
            background: #fcfcfc !important;
            padding: 12px 15px 30px !important; 
            border-top: 1px solid #ddd !important;
            z-index: 1002 !important;
            display: flex !important;
            gap: 10px !important;
            flex-shrink: 0;
            box-shadow: 0 -5px 15px rgba(0,0,0,0.05) !important;
        }
        .chat-input input {
            font-size: 17px !important; 
            padding: 14px 20px !important;
            border-radius: 25px !important;
            background: #fff !important;
            border: 1px solid #ccc !important;
            flex: 1;
            color: #333 !important;
        }
        .chat-input button {
            width: 48px !important;
            height: 48px !important;
            border-radius: 50% !important;
            display: flex !important;
            align-items: center;
            justify-content: center;
            padding: 0 !important;
            background: var(--gradient-primary, #1e1b4b) !important;
            border: none !important;
            color: #fff !important;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1) !important;
        }
        .message-sent, .message-received {
            max-width: 85% !important;
            margin-bottom: 15px !important;
            border-radius: 20px !important;
            padding: 12px 18px !important;
            font-size: 17px !important; 
            line-height: 1.4 !important;
        }
        .footer {
            display: none !important;
        }
    }    /* 8. Loading skeleton ready (optional – does nothing by default) */
                @keyframes shimmer {
                    0% {
                        background-position: -200% 0;
                    }

                    100% {
                        background-position: 200% 0;
                    }
                }

                .chat-container.skeleton {
                    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
                    background-size: 200% 100%;
                    animation: shimmer 1.5s infinite;
                    pointer-events: none;
                }
            </style>
        </head>

        <body>

            <header id="header" class="header d-flex align-items-center sticky-top">
                <div class="container-fluid container-xl d-flex align-items-center">
                    <a href="${pageContext.request.contextPath}/users/dashboard" class="logo me-auto">
                        <h1>Fight D Fear</h1>
                    </a>
                    <nav id="navmenu" class="navmenu">
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/chat/users">Chat</a></li>
                            <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
                            <li><a href="${pageContext.request.contextPath}/users/wallet">Wallet 💰</a></li>
                            <li><a href="${pageContext.request.contextPath}/users/dashboard" class="btn-dashboard"><i
                                        class="fas fa-th-large"></i> Back to Dashboard</a></li>
                            <li class="nav-profile">
                                <a href="${pageContext.request.contextPath}/users/profile/${user.id}"
                                    class="d-flex align-items-center">
                                    <img src="${pageContext.request.contextPath}${not empty user.profilePhoto ? user.profilePhoto : '/images/default-profile.png'}"
                                        alt="Profile" class="rounded-circle"
                                        style="width: 35px; height: 35px; object-fit: cover; border: 2px solid var(--brand-pink);">
                                    <span class="ms-2 d-none d-lg-inline text-white">${user.fullName}</span>
                                </a>
                            </li>
                        </ul>
                        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
                    </nav>
                    <a class="btn-getstarted" href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </header>
            <div class="chat-container fdf-card-soft">

                <div class="chat-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="bi bi-shield-check"></i>
                        Chat with ${not empty receiver.fullName ? receiver.fullName : receiver.email}
                    </h4>
                    <div class="call-actions d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/chat/call/${receiver.id}?notify=true" class="btn btn-outline-success btn-sm rounded-circle" title="Voice Call" target="_blank">
                            <i class="bi bi-telephone-fill"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/chat/video-call/${receiver.id}?notify=true" class="btn btn-outline-primary btn-sm rounded-circle" title="Video Call" target="_blank">
                            <i class="bi bi-camera-video-fill"></i>
                        </a>
                    </div>
                </div>

                <!-- CHAT HISTORY -->
                <div id="chatBox" class="chat-box">

                    <c:forEach var="msg" items="${messages}">
                        <c:choose>


                            <c:when test="${msg.sender.id == sessionScope.user.id}">
                                <div class="d-flex justify-content-end mb-2">
                                    <div class="message-sent">

                                        <c:if test="${not empty msg.message}">
                                            ${msg.message}
                                        </c:if>

                                        <c:if test="${not empty msg.videoUrl}">
                                            <video controls>
                                                <source src="${pageContext.request.contextPath}${msg.videoUrl}"
                                                    type="video/mp4">
                                            </video>
                                        </c:if>

                                        <span class="tick ${msg.readStatus ? 'read' : ''}">
                                            ✔✔
                                        </span>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="d-flex justify-content-start mb-2">
                                    <div class="message-received">

                                        <c:if test="${not empty msg.message}">
                                            ${msg.message}
                                        </c:if>

                                        <c:if test="${not empty msg.videoUrl}">
                                            <video controls>
                                                <source src="${pageContext.request.contextPath}${msg.videoUrl}"
                                                    type="video/mp4">
                                            </video>
                                        </c:if>


                                    </div>
                                </div>
                            </c:otherwise>

                        </c:choose>
                    </c:forEach>

                </div>

                <!-- INPUT -->
                <form id="chatForm" class="chat-input">
                    <input type="hidden" id="receiverId" value="${receiver.id}">
                    <input type="text" id="message" class="form-control" placeholder="Type a message..." required>
                    <button class="btn btn-primary">
                        <i class="bi bi-send"></i>
                    </button>
                </form>

            </div>

            <!-- Incoming Call Modal -->
            <div class="modal fade" id="incomingCallModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content text-center p-4">
                        <div class="modal-body">
                            <div class="mb-3">
                                <i id="callIcon" class="bi bi-telephone-inbound-fill text-primary" style="font-size: 3rem;"></i>
                            </div>
                            <h4 id="callerName">Incoming Call...</h4>
                            <p id="callTypeLabel">Voice Call</p>
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

            <!-- Ringtone Audio -->
            <audio id="ringtoneAudio" loop>
                <source src="https://assets.mixkit.co/active_storage/sfx/2358/2358-preview.mp3" type="audio/mpeg">
            </audio>

            <!-- SOCKET LIBRARIES -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

            <script>
                let stompClient = null;
                const userId = ${ sessionScope.user.id };
                let currentCallInfo = null;
                const ringtone = document.getElementById('ringtoneAudio');

                function connect() {
                    const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
                    stompClient = Stomp.over(socket);

                    stompClient.connect({}, function () {
                        // Subscribe to messages
                        stompClient.subscribe("/topic/messages/" + userId, function (response) {
                            const msg = JSON.parse(response.body);
                            displayMessage(msg);
                        });

                        // 🔴 Subscribe to calls
                        stompClient.subscribe("/topic/calls/" + userId, function (response) {
                            const callInfo = JSON.parse(response.body);
                            if (callInfo.type === 'INCOMING_CALL') {
                                handleIncomingCall(callInfo);
                            } else if (callInfo.type === 'HANGUP' || callInfo.type === 'DECLINED') {
                                stopRingtone();
                                const modalElement = document.getElementById('incomingCallModal');
                                const modal = bootstrap.Modal.getInstance(modalElement);
                                if (modal) modal.hide();
                            }
                        });
                    });
                }

                function handleIncomingCall(callInfo) {
                    currentCallInfo = callInfo;
                    document.getElementById('callerName').innerText = callInfo.fromName + " is calling...";
                    document.getElementById('callTypeLabel').innerText = callInfo.audioOnly ? "Voice Call" : "Video Call";
                    
                    const icon = document.getElementById('callIcon');
                    icon.className = callInfo.audioOnly ? "bi bi-telephone-inbound-fill text-success" : "bi bi-camera-video-fill text-primary";
                    
                    playRingtone();
                    
                    const modal = new bootstrap.Modal(document.getElementById('incomingCallModal'));
                    modal.show();
                }

                function playRingtone() {
                    ringtone.currentTime = 0;
                    ringtone.play().catch(e => console.log("Audio play failed:", e));
                }

                function stopRingtone() {
                    ringtone.pause();
                    ringtone.currentTime = 0;
                }

                document.getElementById('acceptCallBtn').addEventListener('click', function() {
                    if (currentCallInfo) {
                        stopRingtone();
                        const callUrl = currentCallInfo.audioOnly ? 
                            '${pageContext.request.contextPath}/chat/call/' + currentCallInfo.fromId :
                            '${pageContext.request.contextPath}/chat/video-call/' + currentCallInfo.fromId;
                        
                        // Open call in new window
                        window.open(callUrl, '_blank', 'width=1000,height=700');
                        
                        // Hide modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('incomingCallModal'));
                        modal.hide();
                    }
                });

                document.getElementById('declineCallBtn').addEventListener('click', function() {
                    if (currentCallInfo && stompClient) {
                        stopRingtone();
                        // Send decline signal to caller
                        stompClient.send("/app/webrtc.signal", {}, JSON.stringify({
                            type: 'DECLINED',
                            senderId: userId,
                            receiverId: currentCallInfo.fromId
                        }));
                        
                        const modal = bootstrap.Modal.getInstance(document.getElementById('incomingCallModal'));
                        modal.hide();
                    }
                });

                function sendMessage() {
                    const messageInput = document.getElementById("message");
                    const text = messageInput.value.trim();
                    if (!text) return;

                    const chatMessage = {
                        sender: { id: userId },
                        receiver: { id: document.getElementById("receiverId").value },
                        message: text
                    };

                    stompClient.send("/app/chat.send", {}, JSON.stringify(chatMessage));
                    messageInput.value = "";
                }

                function displayMessage(msg) {
                    const chatBox = document.getElementById("chatBox");

                    const wrapper = document.createElement("div");
                    wrapper.classList.add("mb-2", "d-flex");

                    const bubble = document.createElement("div");

                    if (Number(msg.sender.id) === Number(userId)) {
                        wrapper.classList.add("justify-content-end");
                        bubble.classList.add("message-sent");
                    } else {
                        wrapper.classList.add("justify-content-start");
                        bubble.classList.add("message-received");
                    }

                    if (msg.message) {
                        bubble.appendChild(document.createTextNode(msg.message));
                    }

                    if (msg.videoUrl) {
                        const video = document.createElement("video");
                        video.src = "${pageContext.request.contextPath}" + msg.videoUrl;

                        video.controls = true;
                        bubble.appendChild(video);
                    }

                    wrapper.appendChild(bubble);
                    chatBox.appendChild(wrapper);
                    chatBox.scrollTop = chatBox.scrollHeight;
                }

                document.getElementById("chatForm").addEventListener("submit", function (e) {
                    e.preventDefault();
                    sendMessage();
                });

                connect();
            </script>

            <footer id="footer" class="footer position-relative">



                <div class="container footer-top">
                    <div class="row gy-4">
                        <div class="col-lg-4 col-md-6 footer-about">
                            <a href="index.html" class="d-flex align-items-center">
                                <span class="sitename">Fight D Fear</span>
                            </a>

                            <div class="pt-3">
                                <p class="fw-semibold">Our Values</p>
                                <p>Awareness • Safety • Equality • Empowerment</p>
                                <p class="mt-2">Building a safer tomorrow, together.</p>
                            </div>
                        </div>
                        <div class="col-lg-2 col-md-3 footer-links">
                            <h4>Useful Links</h4>
                            <ul>
                                <li><i class="bi bi-chevron-right"></i> <a href="index.html#hero">Home</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a href="index.html#about">About us</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a href="index.html#services">Services</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a
                                        href="${pageContext.request.contextPath}/terms">Terms</a></li>
                            </ul>

                            </a>
                        </div>

                        <div class="col-lg-2 col-md-3 footer-links">
                            <h4>Our Services</h4>
                            <ul>
                                <li><i class="bi bi-chevron-right"></i> <a href="#">Emergency Assistance</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a href="#">Safety Education</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a href="#">Self-defense Training</a></li>
                                <li><i class="bi bi-chevron-right"></i> <a href="#">Community Support</a></li>
                            </ul>
                        </div>

                        <div class="col-lg-4 col-md-12">
                            <h4>Follow Us</h4>
                            <p>Stay connected with us for safety updates, resources, and tips. Empower yourself and
                                others!</p>
                            <div class="social-links d-flex">
                                <a href=""><i class="bi bi-twitter"></i></a>
                                <a href=""><i class="bi bi-facebook"></i></a>
                                <a href=""><i class="bi bi-instagram"></i></a>
                                <a href=""><i class="bi bi-linkedin"></i></a>
                            </div>
                        </div>


                    </div>
                </div>

                <div class="container copyright text-center mt-4">
                    <p>© Copyright <strong class="px-1 sitename">Fight D Fear</strong> All Rights Reserved</p>
                    <div class="credits">
                        <!-- All the links in the footer should remain intact. -->
                        <!-- You can delete the links only if you've purchased the pro version. -->
                        <!-- Licensing information: https://bootstrapmade.com/license/ -->
                        <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
                        <!--  Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> -->
                    </div>
                </div>

            </footer>


            <script
                src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>


        </body>

        </html>
