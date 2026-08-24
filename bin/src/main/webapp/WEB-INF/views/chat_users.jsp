<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chat with Friends — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
            margin-bottom: 40px;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top Bar navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--brand-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--brand-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Friend Grid */
        .friends-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 25px;
            padding: 20px;
            max-width: 1000px;
            margin: 0 auto 60px;
        }
        .friend-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 30px 24px;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none !important;
        }
        .friend-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .friend-avatar {
            width: 85px;
            height: 85px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff5f7;
            border: 3px solid var(--brand-pink-light);
            margin-bottom: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .friend-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .friend-name {
            font-size: 16px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 14px;
        }
        .btn-chat-open {
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            color: #fff;
            background: var(--gradient-primary);
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-chat-open:hover {
            filter: brightness(1.1);
        }

        .chat-toast {
            position: fixed;
            top: 90px;
            right: 20px;
            z-index: 9999;
            min-width: 280px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-left: 4px solid var(--brand-pink);
            border-radius: 12px;
            padding: 14px 16px;
            box-shadow: var(--shadow-lg);
            display: none;
            animation: slideIn 0.3s ease;
        }
        .chat-toast.show { display: block; }
        .chat-toast a { color: var(--brand-purple); font-weight: 700; text-decoration: none; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
            .friends-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-house-door"></i> Home
                </a>
            </div>
            
            <h1>Chat with Friends</h1>
            <p>Connect with your mutual connections. Safe, secure, and direct communication channels.</p>
        </div>

        <!-- Friends Grid -->
        <div class="friends-grid">
            <c:forEach var="chatUser" items="${users}">
                <a href="${pageContext.request.contextPath}/chat/window/${chatUser.id}" class="friend-card" data-aos="fade-up">
                    <div class="friend-avatar">
                        <img src="${pageContext.request.contextPath}${chatUser.profilePhoto}"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                             alt="${chatUser.fullName}">
                    </div>
                    <div class="friend-name">${not empty chatUser.fullName ? chatUser.fullName : chatUser.email}</div>
                    <span class="btn-chat-open">
                        <i class="bi bi-chat-fill"></i> Open Chat
                    </span>
                </a>
            </c:forEach>
            
            <c:if test="${empty users}">
                <div class="col-12 text-center py-5 text-muted">
                    <i class="bi bi-people-fill display-3 mb-3"></i>
                    <p class="fs-5">No mutual connections found yet. Start connecting in the Creator Hub!</p>
                    <a href="${pageContext.request.contextPath}/creator-hub" class="btn btn-primary rounded-pill px-4 mt-2" style="background: var(--brand-purple); border: none;">Go to Creator Hub</a>
                </div>
            </c:if>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<div id="chatToast" class="chat-toast" role="alert">
    <div class="fw-bold mb-1"><i class="bi bi-chat-dots-fill text-primary me-1"></i> New Message</div>
    <div id="chatToastBody" class="small text-muted mb-2"></div>
    <a id="chatToastLink" href="#">Open Chat →</a>
</div>

<!-- Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });

    (function initChatNotifications() {
        const currentUserId = ${sessionScope.user.id};
        const ctx = '${pageContext.request.contextPath}';
        let toastTimer = null;

        function showChatToast(msg) {
            const toast = document.getElementById('chatToast');
            const senderName = msg.sender && msg.sender.fullName ? msg.sender.fullName : 'Someone';
            const preview = msg.message ? msg.message.substring(0, 80) : 'Sent you a message';
            document.getElementById('chatToastBody').textContent = senderName + ': ' + preview;
            document.getElementById('chatToastLink').href = ctx + '/chat/window/' + msg.sender.id;
            toast.classList.add('show');
            clearTimeout(toastTimer);
            toastTimer = setTimeout(() => toast.classList.remove('show'), 8000);
        }

        const socket = new SockJS(ctx + '/ws-chat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null;
        stompClient.connect({}, function () {
            stompClient.subscribe('/topic/messages/' + currentUserId, function (response) {
                const msg = JSON.parse(response.body);
                if (Number(msg.sender.id) !== Number(currentUserId)) {
                    showChatToast(msg);
                }
            });
        });
    })();
</script>

</body>
</html>
