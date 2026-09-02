<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Recorded Video Details — Financial Literacy</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
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
            --fl-shadow: 0 15px 35px rgba(30, 27, 75, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #F8FAFC;
            color: #333;
            min-height: 100vh;
            padding-top: 0 !important;
        }

        #wrapper, #page-content-wrapper {
            width: 100% !important;
            max-width: 100vw !important;
            box-sizing: border-box !important;
        }

        /* Hero Header */
        .details-hero {
            background: #FFFFFF;
            padding: 24px 28px;
            color: #0F172A;
            border: 1px solid #E2E8F0;
            border-radius: 20px;
            position: relative;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }

        .details-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            color: #0B1736;
            margin-top: 10px;
            margin-bottom: 10px;
            line-height: 1.3;
        }

        /* Section Card */
        .section-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid #E2E8F0;
        }

        .section-card h3 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: #0B1736;
            margin-bottom: 18px;
        }

        /* Video Container */
        .video-container {
            background: #000;
            border-radius: 16px;
            aspect-ratio: 16/9;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .video-container .placeholder {
            color: white;
            text-align: center;
            font-size: 3.5rem;
        }

        @media (max-width: 768px) {
            .details-hero { 
                padding: 16px 14px !important; 
                border-radius: 16px !important;
            }
            .details-hero h1 { font-size: 1.3rem !important; word-break: break-word; }
            .section-card {
                padding: 16px 12px !important;
                border-radius: 16px !important;
                margin-bottom: 16px !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }
            .section-card h3 { font-size: 1.15rem !important; }
        }

        /* 📱 Global Mobile Fixes */
        html, body {
            overflow-x: hidden !important;
            width: 100% !important;
            max-width: 100vw !important;
            box-sizing: border-box !important;
            position: relative;
        }
        .btn-back-theme {
            background-color: #1E1B4B !important;
            color: #FFFFFF !important;
            border: 1px solid #1E1B4B !important;
            padding: 7px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.88rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none !important;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(30, 27, 75, 0.15);
        }

        .btn-back-theme:hover {
            background-color: #F43F5E !important;
            border-color: #F43F5E !important;
            color: #FFFFFF !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.25);
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- User Dashboard Shell Wrapper -->
<div id="wrapper">
    <!-- User Dashboard Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden; padding-top: 10px !important;">
        
        <!-- Breadcrumb Navigation -->
        <nav class="ap-crumb mb-3" style="font-size: 0.88rem; font-weight: 600; color: #64748B;">
            <a href="${pageContext.request.contextPath}/users/dashboard" style="color: #64748B; text-decoration: none;">Dashboard</a>
            <span class="mx-2">&gt;</span>
            <a href="${pageContext.request.contextPath}/financial-literacy" style="color: #64748B; text-decoration: none;">Financial Literacy Hub</a>
            <span class="mx-2">&gt;</span>
            <span style="color: #F43F5E;">Recorded Videos</span>
        </nav>

        <!-- Hero Header -->
        <header class="details-hero mb-4">
            <div class="container-fluid position-relative p-0">
                <a href="${pageContext.request.contextPath}/financial-literacy" class="btn-back-theme mb-3">
                    <i class="fas fa-arrow-left me-1"></i> Back
                </a>

                <div class="d-flex flex-wrap align-items-center gap-2 mb-2" id="videoBadges">
                    <c:if test="${video != null}">
                        <span class="badge text-white px-3 py-2 rounded-pill fw-bold" style="background: #1e1b4b;">
                            <i class="fas fa-tag me-1 text-warning"></i> ${video.category}
                        </span>
                    </c:if>
                </div>

                <h1 id="videoTitle">${video != null ? video.title : 'Video Not Found'}</h1>
            </div>
        </header>

        <main class="container-fluid p-0 mb-5">
            <!-- Video Player -->
            <div class="section-card">
                <div class="video-container">
                    <c:choose>
                        <c:when test="${video == null || empty video.videoUrl}">
                            <div class="placeholder">
                                <i class="fas fa-play-circle"></i>
                                <p class="mt-3 fs-5">Video not available</p>
                            </div>
                        </c:when>
                        <c:when test="${not empty video.embedUrl and fn:startsWith(video.embedUrl, 'http')}">
                            <iframe width="100%" height="100%" src="${video.embedUrl}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen style="border-radius: 16px;"></iframe>
                        </c:when>
                        <c:otherwise>
                            <video controls width="100%" height="100%" style="border-radius: 16px; object-fit: contain;">
                                <source src="${pageContext.request.contextPath}${fn:startsWith(video.videoUrl, '/') ? '' : '/'}${video.videoUrl}" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </c:otherwise>
                    </c:choose>
                </div>
                <p id="videoDescription" class="text-secondary fs-6 mb-0">${video != null ? video.description : ''}</p>
            </div>

            <!-- Learning Path -->
            <div class="section-card">
                <h3><i class="fas fa-route me-2" style="color: var(--fl-pink);"></i>Learning Path</h3>
                <div id="learningPath">
                    <ol class="list-group list-group-numbered">
                        <c:if test="${video != null}">
                            <li class="list-group-item d-flex justify-content-between align-items-start active bg-light border-primary rounded-3">
                                <div class="ms-2 me-auto">
                                    <div class="fw-bold" style="color: #1e1b4b">${video.title}</div>
                                </div>
                                <i class="fas fa-check-circle text-primary fs-5"></i>
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
                                    <a href="${pageContext.request.contextPath}/financial-literacy/video/${v.id}" class="card text-decoration-none h-100 shadow-sm" style="border: 1px solid #E2E8F0; border-radius: 16px;">
                                        <div class="card-body">
                                            <h5 class="card-title fw-bold" style="color: #1e1b4b">${v.title}</h5>
                                            <p class="card-text text-muted mb-0 small"><i class="fas fa-tag me-1 text-danger"></i> ${v.category}</p>
                                        </div>
                                    </a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>