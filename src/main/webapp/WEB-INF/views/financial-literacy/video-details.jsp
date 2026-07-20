<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Video Details</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;90&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --fl-purple: #1e1b4b;
            --fl-pink: #f43f5e;
            --fl-gold: #ffd700;
            --fl-bg: #f8fafc;
            --fl-shadow: 0 15px 35px rgba(30, 27, 75, 0.1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--fl-bg);
            color: #333;
            min-height: 100vh;
        }

        /* Hero Header */
        .details-hero {
            background: linear-gradient(135deg, var(--fl-purple) 0%, var(--fl-pink) 100%);
            padding: 60px 0 80px;
            color: white;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
            position: relative;
            overflow: hidden;
        }

        .details-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png');
            opacity: 0.1;
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--fl-shadow);
            border: 1px solid rgba(30, 27, 75, 0.05);
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--fl-purple);
            margin-bottom: 20px;
        }

        /* Video Container */
        .video-container {
            background: #000;
            border-radius: 20px;
            aspect-ratio: 16/9;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            overflow: hidden;
        }

        .video-container .placeholder {
            color: white;
            text-align: center;
            font-size: 4rem;
        }

        /* Badge List */
        .badge-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .badge-item {
            background: rgba(30, 27, 75, 0.1);
            color: var(--fl-purple);
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
        }

        /* Back Button */
        .back-btn {
            position: absolute;
            top: 30px;
            left: 30px;
            color: white;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0.8;
            transition: 0.3s;
            z-index: 100;
        }

        .back-btn:hover {
            opacity: 1;
            transform: translateX(-5px);
        }

        @media (max-width: 768px) {
            .details-hero h1 { font-size: 1.8rem; }
            .details-hero { 
                padding: 60px 15px 80px; 
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
            }
        }

        /* 📱 Global Mobile Fixes */
        html, body {
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }
        .container {
            padding-left: 20px !important;
            padding-right: 20px !important;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <header class="details-hero">
        <a href="${pageContext.request.contextPath}/financial-literacy" class="back-btn">
            <i class="bi bi-arrow-left"></i> Back to Hub
        </a>
        <div class="container text-center">
            <div class="badge-list justify-content-center" id="videoBadges">
                <c:if test="${video != null}">
                    <span class="badge-item">${video.category}</span>
                    <span class="badge-item">${video.level}</span>
                    <span class="badge-item">${video.duration}</span>
                </c:if>
            </div>
            <h1 id="videoTitle">${video != null ? video.title : 'Video Not Found'}</h1>
        </div>
    </header>

    <main class="container mt-5 mb-5">
        <!-- Video Player -->
        <div class="section-card">
            <div class="video-container">
                <c:if test="${video != null && video.embedUrl != null && !video.embedUrl.isEmpty()}">
                    <iframe width="100%" height="100%" src="${video.embedUrl}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen style="border-radius: 20px;"></iframe>
                </c:if>
                <c:if test="${video == null || video.embedUrl == null || video.embedUrl.isEmpty()}">
                    <div class="placeholder">
                        <i class="fas fa-play-circle"></i>
                        <p class="mt-3 fs-5">Video not available</p>
                    </div>
                </c:if>
            </div>
            <p id="videoDescription" class="text-muted">${video != null ? video.description : ''}</p>
        </div>

        <!-- Learning Path -->
        <div class="section-card">
            <h3><i class="fas fa-route me-2" style="color: var(--fl-pink);"></i>Learning Path</h3>
            <div id="learningPath">
                <ol class="list-group list-group-numbered">
                    <c:if test="${video != null}">
                        <li class="list-group-item d-flex justify-content-between align-items-start active bg-light border-primary">
                            <div class="ms-2 me-auto">
                                <div class="fw-bold" style="color: #1e1b4b">${video.title}</div>
                            </div>
                            <i class="fas fa-check-circle text-primary"></i>
                        </li>
                    </c:if>
                </ol>
            </div>
        </div>

        <!-- Related Videos -->
        <div class="section-card">
            <h3><i class="fas fa-link me-2" style="color: var(--fl-pink);"></i>Related Videos</h3>
            <div id="relatedVideos">
                <div class="row g-3">
                    <c:forEach var="v" items="${videos}" begin="0" end="3">
                        <c:if test="${video != null && v.id != video.id}">
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/financial-literacy/video/${v.id}" class="card text-decoration-none" style="border: 1px solid rgba(30,27,75,0.1); border-radius: 15px;">
                                    <div class="card-body">
                                        <h5 class="card-title" style="color: #1e1b4b">${v.title}</h5>
                                        <p class="card-text text-muted">${v.category} • ${v.duration}</p>
                                    </div>
                                </a>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>