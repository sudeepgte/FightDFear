<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
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
            --accent:      #F43F5E;
            --accent-soft: rgba(244,63,94,.08);
            --accent-mid:  rgba(244,63,94,.15);
            --sub:         #64748B;
            --bg:          #F8FAFC;
            --card:        #FFFFFF;
            --border:      #E2E8F0;
            --dark:        #0F172A;
            --success:     #16A34A;
            --success-bg:  #F0FDF4;
            --radius-lg:   20px;
            --radius-md:   14px;
            --radius-sm:   8px;
            --shadow:      0 2px 12px rgba(0,0,0,.06);
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--dark);
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        a { text-decoration: none; color: inherit; }

        /* ── TOP NAV ── */
        .top-nav {
            width: 100%;
            position: sticky; top: 80px; z-index: 200;
            background: var(--card);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between; padding: 0 24px; height: 60px;
        }
        .top-nav .brand { font-size: 17px; font-weight: 700; color: var(--accent); display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
        .top-nav .nav-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
        .icon-btn {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: var(--bg); color: var(--dark);
            border: 1px solid var(--border); cursor: pointer;
            font-size: 15px; transition: all .2s; position: relative;
        }
        .icon-btn:hover { background: var(--accent-soft); border-color: var(--accent); color: var(--accent); }

        /* ── LAYOUT GRID ── */
        .page-wrapper {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr;
            gap: 32px;
            padding: 24px 40px;
        }

        /* ── CARDS ── */
        .card-box {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            overflow: hidden;
            padding: 20px;
        }
        .card-header-row {
            padding: 10px 10px 20px;
            font-size: 18px; font-weight: 700;
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid var(--border);
            margin-bottom: 20px;
        }

        .notif-item {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 15px 20px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all .2s;
        }
        .notif-item:hover {
            background: var(--bg);
            border-color: var(--accent-soft);
            box-shadow: var(--shadow);
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
        .icon-like { background: var(--accent-soft); color: var(--accent); }
        .icon-comment { background: rgba(14, 165, 233, 0.1); color: #0ea5e9; }
        .icon-follow { background: rgba(139, 92, 246, 0.1); color: #8b5cf6; }
        .icon-money { background: rgba(234, 179, 8, 0.1); color: #eab308; }
        .icon-system { background: var(--bg); color: var(--sub); }

        @media (max-width: 768px) {
            .page-wrapper { padding: 12px; }
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
    <div id="page-content-wrapper" style="padding: 0; min-height: 100vh; background: var(--bg); flex: 1; min-width: 0; width: 100%;" data-skip-global-back="true">
        
        <!-- TOP NAV -->
        <nav class="top-nav">
            <div class="brand">Notifications</div>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/creator-hub" class="icon-btn" title="Back to Hub">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
            </div>
        </nav>

        <div class="page-wrapper">
            <div class="card-box" data-aos="fade-up">
                
                <div class="card-header-row">
                    <span>Recent Activity</span>
                </div>
                
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

<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
