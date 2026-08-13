<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* ============================================
       UNIVERSAL HEADER CSS
       ============================================ */
    :root {
        --uh-purple: #1e1b4b; /* Deep Navy */
        --uh-purple-light: #312e81; /* Light Navy */
        --uh-coral: #f43f5e; /* Rose Pink */
        --uh-gradient: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --primary-coral: #f43f5e;
    }

    .header {
        position: fixed !important;
        top: 0;
        left: 0;
        right: 0;
        background: var(--uh-purple) !important;
        border-bottom: 2px solid rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(8px);
        padding: 15px 0;
        transition: all 0.5s;
        z-index: 1050 !important;
    }

    .header .logo h1 {
        font-size: 30px !important;
        margin: 0;
        font-weight: 700;
        letter-spacing: 2px;
        background: var(--uh-gradient) !important;
        -webkit-background-clip: text !important;
        -webkit-text-fill-color: transparent !important;
        background-clip: text !important;
    }

    .header .btn-getstarted {
        background: var(--uh-gradient) !important;
        border: none !important;
        color: #fff !important;
        font-size: 14px !important;
        padding: 8px 25px !important;
        margin: 0 0 0 30px !important;
        border-radius: 50px !important;
        transition: 0.3s;
        text-decoration: none !important;
        font-weight: 600;
    }
    
    .header .btn-getstarted:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }

    @media (min-width: 1200px) {
        .navmenu {
            padding: 0;
        }
        .navmenu ul {
            margin: 0;
            padding: 0;
            display: flex;
            list-style: none;
            align-items: center;
        }
        .navmenu li {
            position: relative;
        }
        .navmenu a, .navmenu a:focus {
            color: rgba(255, 255, 255, 0.92) !important;
            font-weight: 600 !important;
            padding: 18px 15px !important;
            font-size: 16px !important;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: space-between;
            white-space: nowrap;
            transition: 0.3s;
            text-decoration: none !important;
            position: relative;
        }
        .navmenu a::after {
            content: '';
            position: absolute;
            bottom: 12px;
            left: 15px;
            width: 0%;
            height: 2px;
            background: var(--uh-gradient);
            transition: width 0.3s ease;
        }
        .navmenu a:hover::after, .navmenu .active::after {
            width: calc(100% - 30px);
        }
        .navmenu a:hover, .navmenu .active {
            color: var(--uh-coral) !important;
            text-shadow: none;
        }
    }

    .header-profile-img {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid var(--uh-purple-light);
        transition: all 0.4s cubic-bezier(0.34, 1.2, 0.64, 1);
        cursor: pointer;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    }
    .header-profile-img:hover {
        transform: scale(1.15) rotate(5deg);
        border-color: var(--uh-coral);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
    }



    .mobile-nav-toggle {
        color: white !important;
        font-size: 28px;
        cursor: pointer;
        line-height: 0;
        transition: 0.5s;
        margin-left: 10px;
    }

    /* Mobile Navigation Drawer styles */
    @media (max-width: 1199px) {
        .header {
            padding: 10px 0 !important;
        }
        .header .container-fluid.container-xl {
            display: flex !important;
            flex-wrap: nowrap !important;
            align-items: center !important;
            justify-content: flex-start !important;
            gap: 8px;
            padding-left: 12px !important;
            padding-right: 12px !important;
        }
        .header .logo.me-auto {
            flex: 1 1 auto;
            min-width: 0;
            margin-right: auto !important;
        }
        .header .logo h1 {
            font-size: 18px !important;
            letter-spacing: 0.5px !important;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .header .navmenu {
            flex: 0 0 auto;
            margin-left: 0 !important;
        }
        .header .container-fluid > a.ms-3 {
            flex: 0 0 auto;
            margin-left: 8px !important;
        }
        .header-profile-img {
            width: 36px;
            height: 36px;
        }
        .mobile-nav-toggle {
            display: block !important;
            margin-left: 0 !important;
            padding: 4px;
            z-index: 10002;
            position: relative;
        }
        .navmenu ul {
            display: none !important;
            position: fixed;
            top: 64px;
            right: 12px;
            left: 12px;
            bottom: auto;
            max-height: calc(100dvh - 80px);
            padding: 12px;
            margin: 0;
            border-radius: 14px;
            background: rgba(30, 27, 75, 0.98);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.12);
            list-style: none;
            overflow-y: auto;
            -webkit-overflow-scrolling: touch;
            z-index: 10001;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.35);
            flex-direction: column !important;
            align-items: stretch !important;
            gap: 4px;
        }
        .navmenu ul li {
            margin-bottom: 0;
            width: 100%;
        }
        .navmenu ul li a {
            display: flex !important;
            align-items: center;
            padding: 12px 16px !important;
            font-size: 15px !important;
            color: rgba(255, 255, 255, 0.92) !important;
            border-radius: 10px;
            transition: all 0.3s;
            white-space: normal !important;
        }
        .navmenu ul li a:hover,
        .navmenu ul li a.active {
            background: rgba(244, 63, 94, 0.18) !important;
            color: #f43f5e !important;
        }
        .mobile-nav-active {
            overflow: hidden;
        }
        .mobile-nav-active .navmenu {
            position: fixed;
            inset: 0;
            z-index: 10000;
            background: rgba(10, 8, 30, 0.55);
        }
        .mobile-nav-active .navmenu ul {
            display: flex !important;
        }
    }

    @media (max-width: 480px) {
        .header .logo h1 {
            font-size: 16px !important;
        }
        .header-profile-img {
            width: 32px;
            height: 32px;
        }
        .mobile-nav-toggle {
            font-size: 24px !important;
        }
    }
</style>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<!-- ======= Header ======= -->
<header id="header" class="header d-flex align-items-center fixed-top">
  <div class="container-fluid container-xl d-flex align-items-center">
    <a href="${pageContext.request.contextPath}${not empty sessionScope.loggedTrainer ? '/fitness/trainer/dashboard' : (not empty sessionScope.loggedDoctor ? '/doctors/dashboard' : '/users/dashboard')}" class="logo me-auto" style="text-decoration: none;"><h1>Fight D Fear</h1></a>
    <nav id="navmenu" class="navmenu">
      <ul>
        <c:choose>
            <c:when test="${not empty sessionScope.loggedTrainer}">
                <li><a href="${pageContext.request.contextPath}/fitness/trainer/dashboard">Dashboard</a></li>
                <!-- Notification Bell for Broadcasts -->
                <li>
                    <a href="#" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()" style="display: flex; align-items: center; color: white !important;">
                        <div style="position: relative; display: inline-block;">
                            <i class="fas fa-bell fs-5"></i>
                            <c:if test="${unreadBroadcastCount > 0}">
                                <span id="broadcastBadge" class="position-absolute badge rounded-pill bg-danger" 
                                      style="font-size: 0.65rem; top: -5px; right: -10px; padding: 3px 6px;">
                                    ${unreadBroadcastCount}
                                </span>
                            </c:if>
                        </div>
                    </a>
                </li>
                <li><a href="${pageContext.request.contextPath}/fitness/trainer/dashboard">${sessionScope.loggedTrainer.fullName} (Coach)</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/users/wallet">Wallet 💰</a></li>
                
                <!-- Notification Bell for Broadcasts -->
                <li>
                    <a href="#" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()" style="display: flex; align-items: center; color: white !important;">
                        <div style="position: relative; display: inline-block;">
                            <i class="fas fa-bell fs-5"></i>
                            <c:if test="${unreadBroadcastCount > 0}">
                                <span id="broadcastBadge" class="position-absolute badge rounded-pill bg-danger" 
                                      style="font-size: 0.65rem; top: -5px; right: -10px; padding: 3px 6px;">
                                    ${unreadBroadcastCount}
                                </span>
                            </c:if>
                        </div>
                    </a>
                </li>
                
                <li><a href="${pageContext.request.contextPath}/users/profile/${user.id}">${user.fullName}</a></li>
            </c:otherwise>
        </c:choose>
      </ul>
      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
    </nav>
    <c:choose>
        <c:when test="${not empty sessionScope.loggedTrainer}">
            <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="ms-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedTrainer.profilePhotoPath}">
                        <img src="${sessionScope.loggedTrainer.profilePhotoPath}" alt="Profile" class="header-profile-img">
                    </c:when>
                    <c:otherwise>
                        <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2" alt="Profile" class="header-profile-img">
                    </c:otherwise>
                </c:choose>
            </a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="ms-3">
                <c:choose>
                    <c:when test="${not empty user.profilePhoto}">
                        <img src="${pageContext.request.contextPath}${user.profilePhoto}" alt="Profile" class="header-profile-img">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/img/default-profile.png" alt="Profile" class="header-profile-img">
                    </c:otherwise>
                </c:choose>
            </a>
        </c:otherwise>
    </c:choose>
  </div>
</header>

<!-- Global Incoming Call Modal -->
<div class="modal fade" id="globalIncomingCallModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" style="z-index: 2000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content text-center p-4 border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-body">
                <div class="mb-3">
                    <i id="globalCallIcon" class="bi bi-shield-check text-primary" style="font-size: 3.5rem; animation: call-bounce 1s infinite;"></i>
                </div>
                <h4 id="globalCallerName" class="fw-bold mb-2">Fight D Fear Incoming Call...</h4>
                <p id="globalCallTypeLabel" class="text-muted">Voice Call</p>
                <div class="d-flex justify-content-center gap-3 mt-4">
                    <button type="button" class="btn btn-success btn-lg rounded-pill px-4 py-2" id="globalAcceptCallBtn">
                        <i class="bi bi-telephone-fill me-2"></i> Accept
                    </button>
                    <button type="button" class="btn btn-danger btn-lg rounded-pill px-4 py-2" id="globalDeclineCallBtn">
                        <i class="bi bi-telephone-x-fill me-2"></i> Decline
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Global Ringtone Audio -->
<audio id="globalRingtoneAudio" loop preload="auto">
    <source src="https://assets.mixkit.co/active_storage/sfx/2358/2358-preview.mp3" type="audio/mpeg">
</audio>

<style>
    @keyframes call-bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
    }
    @media (max-width: 576px) {
        .header .logo h1 {
            font-size: 20px !important;
            letter-spacing: 0.5px !important;
        }
    }
</style>

<c:if test="${not empty sessionScope.user}">
    <!-- Global WebSocket Signaling Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    
    <script>
        (function() {
            window.__APP_CTX__ = "${pageContext.request.contextPath}";
            const ctx = window.__APP_CTX__;
            const userId = "${sessionScope.user.id}";
            const isVerified = "${sessionScope.user.verificationStatus == 'VERIFIED'}";
            
            let globalStompClient = null;
            let currentGlobalCallInfo = null;
            const globalRingtone = document.getElementById('globalRingtoneAudio');

            function connectGlobalWS() {
                const socket = new SockJS(ctx + '/ws-chat');
                globalStompClient = Stomp.over(socket);
                globalStompClient.debug = null;

                globalStompClient.connect({}, function () {
                    // Subscribe to global call notifications
                    globalStompClient.subscribe("/topic/calls/" + userId, function (response) {
                        const callInfo = JSON.parse(response.body);
                        if (callInfo.type === 'INCOMING_CALL') {
                            handleGlobalIncomingCall(callInfo);
                        } else if (callInfo.type === 'HANGUP' || callInfo.type === 'DECLINED') {
                            stopGlobalRingtone();
                            const modal = bootstrap.Modal.getInstance(document.getElementById('globalIncomingCallModal'));
                            if (modal) modal.hide();
                        }
                    });
                }, function() {
                    // Auto-reconnect
                    setTimeout(connectGlobalWS, 5000);
                });
            }

            function handleGlobalIncomingCall(callInfo) {
                // Don't show modal if we're already on a call page (optional, but good for UX)
                if (window.location.pathname.includes('/chat/call/') || window.location.pathname.includes('/chat/video-call/')) {
                    return;
                }

                currentGlobalCallInfo = callInfo;
                document.getElementById('globalCallerName').innerText = callInfo.fromName + " is calling...";
                document.getElementById('globalCallTypeLabel').innerText = callInfo.audioOnly ? "Voice Call" : "Video Call";
                
                const icon = document.getElementById('globalCallIcon');
                icon.className = callInfo.audioOnly ? "bi bi-telephone-inbound-fill text-success" : "bi bi-camera-video-fill text-primary";
                
                playGlobalRingtone();
                
                const modal = new bootstrap.Modal(document.getElementById('globalIncomingCallModal'));
                modal.show();
            }

            function playGlobalRingtone() {
                if (globalRingtone) {
                    globalRingtone.currentTime = 0;
                    globalRingtone.play().catch(e => console.log("Global audio play blocked, waiting for interaction."));
                }
            }

            function stopGlobalRingtone() {
                if (globalRingtone) {
                    globalRingtone.pause();
                    globalRingtone.currentTime = 0;
                }
            }

            document.getElementById('globalAcceptCallBtn').addEventListener('click', function() {
                if (currentGlobalCallInfo) {
                    stopGlobalRingtone();
                    const callUrl = currentGlobalCallInfo.audioOnly ? 
                        ctx + '/chat/call/' + currentGlobalCallInfo.fromId :
                        ctx + '/chat/video-call/' + currentGlobalCallInfo.fromId;
                    
                    window.open(callUrl, '_blank', 'width=1200,height=800');
                    
                    const modal = bootstrap.Modal.getInstance(document.getElementById('globalIncomingCallModal'));
                    if (modal) modal.hide();
                }
            });

            document.getElementById('globalDeclineCallBtn').addEventListener('click', function() {
                if (currentGlobalCallInfo && globalStompClient) {
                    stopGlobalRingtone();
                    globalStompClient.send("/app/webrtc.signal", {}, JSON.stringify({
                        type: 'DECLINED',
                        senderId: userId,
                        receiverId: currentGlobalCallInfo.fromId
                    }));
                    
                    const modal = bootstrap.Modal.getInstance(document.getElementById('globalIncomingCallModal'));
                    if (modal) modal.hide();
                }
            });

            // Start global listener
            if (userId) {
                connectGlobalWS();
            }

            // 1. Background Location Update (every 2 minutes)
            function updateLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(pos => {
                        fetch(ctx + '/livelocation/save', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                latitude: pos.coords.latitude,
                                longitude: pos.coords.longitude,
                                userId: userId
                            })
                        }).catch(e => console.warn('Bg location update failed'));
                    }, null, { enableHighAccuracy: false, timeout: 5000 });
                }
            }
            
            // Only update location if logged in
            if (userId) {
                setInterval(updateLocation, 120000); 
                updateLocation(); 
            }

            // 2. SOS Alert Polling for Volunteers
            if (isVerified === "true") {
                const script = document.createElement('script');
                script.src = ctx + "/resources/js/volunteerNotification.js";
                document.head.appendChild(script);
            }
        })();
    </script>
</c:if>

<script>
  document.addEventListener('DOMContentLoaded', function() {
      const toggleBtn = document.querySelector('.mobile-nav-toggle');
      const navmenu = document.querySelector('.navmenu');
      if (toggleBtn) {
          toggleBtn.addEventListener('click', function(e) {
              e.stopPropagation();
              const body = document.querySelector('body');
              body.classList.toggle('mobile-nav-active');
              toggleBtn.classList.toggle('bi-list');
              toggleBtn.classList.toggle('bi-x');
          });
      }
      if (navmenu) {
          navmenu.addEventListener('click', function(e) {
              if (e.target === navmenu) {
                  document.body.classList.remove('mobile-nav-active');
                  if (toggleBtn) {
                      toggleBtn.classList.add('bi-list');
                      toggleBtn.classList.remove('bi-x');
                  }
              }
          });
      }
  });
</script>
