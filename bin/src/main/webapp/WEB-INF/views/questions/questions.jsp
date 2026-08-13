<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Q&amp;A Forum — Fight D Fear</title>
    
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

        /* Top navigation */
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

        /* Forum Content Container */
        .forum-container {
            max-width: 860px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Modern Ask Question card */
        .ask-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 40px;
        }
        .ask-card h3 {
            font-size: 18px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .ask-card h3 i {
            color: var(--brand-pink);
        }
        .form-control:focus {
            border-color: var(--brand-purple);
            box-shadow: 0 0 0 0.2rem rgba(30, 27, 75, 0.15);
        }
        .btn-submit-q {
            background: var(--gradient-primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.2s;
            width: 100%;
        }
        .btn-submit-q:hover {
            filter: brightness(1.1);
            color: #fff;
            transform: translateY(-1px);
        }

        /* Discussions styling */
        .discussion-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .discussion-title i {
            color: var(--brand-pink);
        }
        
        .question-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
        }
        .question-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .question-text {
            font-size: 15px;
            font-weight: 500;
            color: var(--fdf-text);
            margin-bottom: 12px;
            line-height: 1.5;
        }
        .question-meta {
            font-size: 12px;
            color: var(--fdf-muted);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-view-thread {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 18px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            background: #fdf2f8;
            color: var(--brand-purple);
            border: 1px solid var(--fdf-border);
            transition: all 0.2s;
        }
        .btn-view-thread:hover {
            background: var(--brand-purple);
            color: #fff;
            border-color: transparent;
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
            .forum-container { padding: 20px 15px; }
            .ask-card { padding: 20px; }
            .question-card { padding: 20px; }
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
                <a href="${pageContext.request.contextPath}/index/templates" class="top-btn">
                    <i class="bi bi-spa"></i> Glow Space Dashboard
                </a>
            </div>
            
            <h1>Q&amp;A Forum</h1>
            <p>Ask questions anonymously or connect with the community to discuss beauty treatments, salon advice, and professional stylist recommendations.</p>
        </div>

        <!-- Forum Container -->
        <div class="forum-container">
            
            <!-- Ask question form -->
            <div class="ask-card" data-aos="fade-up">
                <h3><i class="bi bi-plus-circle-fill"></i> Ask a Question</h3>
                <form action="${pageContext.request.contextPath}/qna/ask" method="post">
                    <div class="mb-3">
                        <textarea class="form-control" name="content" rows="3" placeholder="Type your beauty or salon question here..." required></textarea>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="form-control" name="displayName" placeholder="Display name (Anonymous if left blank)">
                    </div>
                    <button type="submit" class="btn-submit-q">Submit Question</button>
                </form>
            </div>

            <!-- Recent Discussions -->
            <div class="discussion-title">
                <i class="bi bi-chat-left-text-fill"></i>
                <span>Recent Discussions</span>
            </div>

            <c:forEach var="q" items="${threads}">
                <div class="question-card" data-aos="fade-up">
                    <p class="question-text"><strong>Q:</strong> ${q.content}</p>
                    <div class="question-meta">
                        <i class="bi bi-person"></i>
                        <span>Asked by ${not empty q.displayName ? q.displayName : 'Anonymous'}</span>
                        <span class="mx-1">•</span>
                        <i class="bi bi-clock"></i>
                        <span>${q.postedAt}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/qna/thread/${q.id}" class="btn-view-thread">
                        <span>View Full Thread</span>
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </c:forEach>
            
            <c:if test="${empty threads}">
                <div class="text-center text-muted py-5">
                    <i class="bi bi-chat-square-dots display-1 mb-3 text-muted"></i>
                    <h3>No discussions yet</h3>
                    <p>Be the first to submit a question to the community!</p>
                </div>
            </c:if>
            
        </div><!-- /forum-container -->

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
