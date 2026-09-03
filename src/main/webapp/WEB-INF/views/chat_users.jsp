<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chat with Friends — Fight D Fear</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/chat-users-theme.css" rel="stylesheet">
    <style>
        body.fdf-page-chats .friends-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
        }
        body.fdf-page-chats .friend-card {
            background: linear-gradient(160deg, #FFFFFF 0%, #FFF1F2 100%);
            border: 1px solid #FECDD3;
            border-radius: 20px;
            padding: 28px 22px;
            text-align: center;
            transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
            box-shadow: 0 4px 16px rgba(244, 63, 94, 0.06);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none !important;
            color: #0F172A !important;
        }
        body.fdf-page-chats .friend-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 32px rgba(244, 63, 94, 0.12);
            border-color: #F43F5E;
            color: #0F172A !important;
        }
        body.fdf-page-chats .friend-avatar {
            width: 84px;
            height: 84px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #FFF1F2;
            border: 3px solid #FECDD3;
            margin-bottom: 14px;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.08);
        }
        body.fdf-page-chats .friend-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        body.fdf-page-chats .friend-name {
            font-size: 16px;
            font-weight: 800;
            color: #0F172A !important;
            margin-bottom: 14px;
        }
        body.fdf-page-chats .friend-role {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: #F43F5E;
            margin-bottom: 6px;
        }
        body.fdf-page-chats .btn-chat-open {
            padding: 8px 20px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            color: #fff;
            background: #F43F5E;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.28);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        body.fdf-page-chats .friend-card:hover .btn-chat-open {
            background: #E11D48;
        }
        body.fdf-page-chats .chat-empty { grid-column: 1 / -1; }
        body.fdf-page-chats .chat-toast {
            position: fixed;
            top: 90px;
            right: 20px;
            z-index: 9999;
            min-width: 280px;
            background: #fff;
            border: 1px solid #FECDD3;
            border-left: 4px solid #F43F5E;
            border-radius: 12px;
            padding: 14px 16px;
            box-shadow: 0 12px 32px rgba(244, 63, 94, 0.12);
            display: none;
        }
        body.fdf-page-chats .chat-toast.show { display: block; }
        body.fdf-page-chats .chat-toast a { color: #F43F5E; font-weight: 700; text-decoration: none; }
        @media (max-width: 768px) {
            body.fdf-page-chats .friends-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body class="fdf-page-shell fdf-page-chats">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper">
        <main class="fdf-page-main">
            <header class="fdf-page-header">
                <div>
                    <h1 class="fdf-page-title">My Active Chats</h1>
                    <p class="fdf-page-subtitle">Access your ongoing conversations with friends and medical professionals.</p>
                </div>
                <a href="${pageContext.request.contextPath}/users/dashboard" class="fdf-nav-btn">
                    <i class="bi bi-house-door"></i> Home
                </a>
            </header>

            <div class="friends-grid">
                <%
                    org.springframework.context.ApplicationContext ctx =
                        org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext(application);
                    in.sp.main.Entities.User currentUser = (in.sp.main.Entities.User) session.getAttribute("user");

                    if (currentUser != null && request.getAttribute("doctors") == null) {
                        try {
                            javax.sql.DataSource ds = ctx.getBean(javax.sql.DataSource.class);
                            java.util.List doctors = new java.util.ArrayList();
                            java.util.List usersList = new java.util.ArrayList();

                            try (java.sql.Connection conn = ds.getConnection()) {
                                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                                    "SELECT DISTINCT d.* FROM doctors d INNER JOIN doctor_chat_messages m ON d.id = m.doctor_id WHERE m.user_id = ?")) {
                                    ps.setLong(1, currentUser.getId());
                                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                                        while (rs.next()) {
                                            in.sp.main.Entities.Doctor d = new in.sp.main.Entities.Doctor();
                                            d.setId(rs.getLong("id"));
                                            d.setFullName(rs.getString("full_name"));
                                            d.setProfilePhotoPath(rs.getString("profile_photo_path"));
                                            doctors.add(d);
                                        }
                                    }
                                }

                                try (java.sql.PreparedStatement ps = conn.prepareStatement(
                                    "SELECT DISTINCT u.*, " +
                                    "COALESCE(u.profile_photo, (SELECT profile_image_url FROM job_application ja WHERE ja.user_id = u.id AND profile_image_url IS NOT NULL ORDER BY applied_at DESC LIMIT 1), (SELECT profile_photo FROM service_providers sp WHERE sp.user_id = u.id AND profile_photo IS NOT NULL LIMIT 1)) AS resolved_photo " +
                                    "FROM user u INNER JOIN chat_message m ON (u.id = m.sender_id OR u.id = m.receiver_id) WHERE (m.sender_id = ? OR m.receiver_id = ?) AND u.id != ?")) {
                                    ps.setLong(1, currentUser.getId());
                                    ps.setLong(2, currentUser.getId());
                                    ps.setLong(3, currentUser.getId());
                                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                                        while (rs.next()) {
                                            in.sp.main.Entities.User u = new in.sp.main.Entities.User();
                                            u.setId(rs.getLong("id"));
                                            u.setFullName(rs.getString("full_name"));
                                            u.setEmail(rs.getString("email"));
                                            u.setProfilePhoto(rs.getString("resolved_photo"));
                                            usersList.add(u);
                                        }
                                    }
                                }
                            }
                            request.setAttribute("doctors", doctors);
                            request.setAttribute("users", usersList);
                        } catch(Exception e) {
                            e.printStackTrace();
                        }
                    }
                %>

                <c:forEach var="doc" items="${doctors}">
                    <a href="${pageContext.request.contextPath}/doctors/chat/${doc.id}" class="friend-card" data-aos="fade-up">
                        <div class="friend-avatar">
                            <c:set var="docPp" value="${doc.profilePhotoPath}" />
                            <c:if test="${empty docPp}">
                                <c:set var="docPp" value="/assets/img/logo.png" />
                            </c:if>
                            <c:if test="${not empty docPp and not docPp.startsWith('/') and not docPp.startsWith('http')}">
                                <c:set var="docPp" value="/uploads/${docPp}" />
                            </c:if>
                            <img src="${pageContext.request.contextPath}${docPp}"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/logo.png';"
                                 alt="Dr. ${doc.fullName}">
                        </div>
                        <div class="friend-role">Doctor</div>
                        <div class="friend-name">Dr. ${doc.fullName}</div>
                        <span class="btn-chat-open">
                            <i class="bi bi-chat-fill"></i> Open Chat
                        </span>
                    </a>
                </c:forEach>

                <c:forEach var="chatUser" items="${users}">
                    <a href="${pageContext.request.contextPath}/chat/window/${chatUser.id}" class="friend-card" data-aos="fade-up">
                        <div class="friend-avatar">
                            <c:set var="userPp" value="${chatUser.profilePhoto}" />
                            <c:if test="${empty userPp}">
                                <c:set var="userPp" value="/assets/img/logo.png" />
                            </c:if>
                            <c:if test="${not empty userPp and not userPp.startsWith('/') and not userPp.startsWith('http')}">
                                <c:set var="userPp" value="/${userPp}" />
                            </c:if>
                            <img src="${pageContext.request.contextPath}${userPp}"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/logo.png';"
                                 alt="${chatUser.fullName}">
                        </div>
                        <div class="friend-name">${not empty chatUser.fullName ? chatUser.fullName : chatUser.email}</div>
                        <span class="btn-chat-open">
                            <i class="bi bi-chat-fill"></i> Open Chat
                        </span>
                    </a>
                </c:forEach>

                <c:if test="${empty users and empty doctors}">
                    <div class="fdf-empty-state chat-empty">
                        <i class="bi bi-chat-dots display-6 mb-3 d-block"></i>
                        <p class="mb-0">You don't have any active chats right now.</p>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<div id="chatToast" class="chat-toast" role="alert">
    <div class="fw-bold mb-1"><i class="bi bi-chat-dots-fill me-1"></i> New Message</div>
    <div id="chatToastBody" class="small fdf-muted mb-2"></div>
    <a id="chatToastLink" href="#">Open Chat →</a>
</div>

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
