<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Creator Notifications — Fight D Fear</title>
    
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
            --accent-pink: #f43f5e;
            --accent-purple: #8b5cf6;
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
        .blob-1 { top: -100px; right: -100px; background: var(--accent-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--accent-pink); animation-delay: -5s; }
        
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
            color: var(--accent-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--accent-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Notifications card */
        .notif-container {
            max-width: 700px;
            margin: 0 auto 60px;
            padding: 0 15px;
        }
        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
        }

        .notif-item {
            background: #fafafb;
            border: 1px solid var(--fdf-border);
            border-radius: 16px;
            padding: 15px 20px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.2s;
        }
        .notif-item:hover {
            background: #ffffff;
            border-color: var(--brand-pink-light);
            box-shadow: var(--shadow-sm);
            transform: translateX(4px);
        }

        .icon-box {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }
        .icon-like { background: rgba(244, 63, 94, 0.1); color: var(--accent-pink); }
        .icon-comment { background: rgba(14, 165, 233, 0.1); color: #0ea5e9; }
        .icon-follow { background: rgba(139, 92, 246, 0.1); color: var(--accent-purple); }
        .icon-money { background: rgba(234, 179, 8, 0.1); color: #eab308; }
        .icon-system { background: #f3f4f6; color: #4b5563; }

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
                <a href="${pageContext.request.contextPath}/creator-hub" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-arrow-left"></i> Back to Hub
                </a>
            </div>
            
            <h1>Notifications</h1>
            <p>Stay updated on likes, comments, connections, and support tips from your creator audience.</p>
        </div>

        <div class="notif-container">
            <div class="glass-card" data-aos="fade-up">
                
                <c:if test="${empty notifications}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-bell-slash display-4 mb-3 d-block"></i>
                        <p class="mb-0">No new notifications at this time.</p>
                    </div>
                </c:if>

                <c:forEach var="n" items="${notifications}">
                    <div class="notif-item">
                        <c:choose>
                            <c:when test="${n.type eq 'LIKE'}">
                                <div class="icon-box icon-like"><i class="fa-solid fa-heart"></i></div>
                            </c:when>
                            <c:when test="${n.type eq 'COMMENT'}">
                                <div class="icon-box icon-comment"><i class="fa-solid fa-comment"></i></div>
                            </c:when>
                            <c:when test="${n.type eq 'FOLLOW'}">
                                <div class="icon-box icon-follow"><i class="fa-solid fa-user-plus"></i></div>
                            </c:when>
                            <c:when test="${n.type eq 'MONEY_RECEIVED'}">
                                <div class="icon-box icon-money"><i class="fa-solid fa-coins"></i></div>
                            </c:when>
                            <c:otherwise>
                                <div class="icon-box icon-system"><i class="fa-solid fa-circle-info"></i></div>
                            </c:otherwise>
                        </c:choose>

                        <div>
                            <p class="mb-1 text-dark fw-bold text-sm" style="line-height: 1.4;">${n.message}</p>
                            <span class="text-muted text-xs">${n.createdAt}</span>
                        </div>
                    </div>
                </c:forEach>

            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });
</script>

</body>
</html>
