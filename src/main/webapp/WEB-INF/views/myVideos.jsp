<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>My Videos & Reels</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/main.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
          rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
          rel="stylesheet">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>

        :root {
            --primary-purple: #1e1b4b;
            --primary-purple-light: #312e81;
            --primary-coral: #f43f5e;
            --light-bg: #fffcfd;
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(180deg, var(--light-bg) 0%, #f5f5f5 100%);
            margin: 0;
        }

        .my-videos-shell {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .my-videos-main {
            flex: 1;
        }

        .pageShell {
            max-width: 1100px;
            margin: 0 auto;
            padding: 28px 16px 40px;
        }

        .page-header-box {
            background: var(--gradient-primary);
            color: #fff;
            border-radius: 16px;
            padding: 22px 26px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }

        .videoCard {
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid rgba(124, 45, 94, 0.15);
            box-shadow: var(--shadow-sm);
            background: #fff;
            height: 100%;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .videoCard:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 32px rgba(124, 45, 94, 0.12);
        }

        .media-wrap {
            background: #1a1a2e;
            aspect-ratio: 9 / 16;
            max-height: 280px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .media-wrap video,
        .media-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .btn-fdf {
            background: var(--gradient-primary);
            color: #fff;
            border: none;
            border-radius: 999px;
            font-weight: 600;
            padding: 10px 20px;
        }

        .btn-fdf:hover {
            color: #fff;
            opacity: 0.95;
        }

        .empty-state {
            text-align: center;
            padding: 48px 24px;
            background: #fff;
            border-radius: 16px;
            border: 1px dashed rgba(124, 45, 94, 0.3);
        }

    </style>

</head>

<body class="my-videos-shell">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<main class="my-videos-main">

<div class="pageShell">

    <!-- HEADER -->
    <div class="page-header-box">

        <h2 class="mb-1 h4 fw-bold">
            <i class="bi bi-collection-play me-2"></i>
            My Videos & Reels
        </h2>

        <p class="mb-0 small opacity-75">
            All uploads you have posted — standard videos and reels.
        </p>

    </div>

    <!-- SUCCESS MESSAGE -->
    <c:if test="${not empty message}">
        <div class="alert alert-success">
            ${message}
        </div>
    </c:if>

    <!-- ERROR MESSAGE -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <!-- ACTION BUTTONS -->
    <div class="d-flex flex-wrap gap-2 mb-4">

        <a href="${pageContext.request.contextPath}/video/upload?isReel=false"
           class="btn btn-fdf">

            <i class="bi bi-cloud-upload"></i>
            Upload Video

        </a>

        <a href="${pageContext.request.contextPath}/video/reels"
           class="btn btn-outline-danger">

            <i class="bi bi-camera-video"></i>
            Shoot Reel

        </a>

        <a href="${pageContext.request.contextPath}/video/reels"
           class="btn btn-outline-secondary">

            <i class="bi bi-play-btn"></i>
            Watch Reels Feed

        </a>

    </div>

    <!-- VIDEOS -->
    <c:choose>

        <!-- EMPTY -->
        <c:when test="${empty videos}">

            <div class="empty-state">

                <i class="bi bi-camera-reels"
                   style="font-size:3rem; color:var(--primary-purple-light);"></i>

                <h4 class="mt-3"
                    style="color:var(--primary-purple);">

                    No uploads yet

                </h4>

                <p class="text-muted">
                    Upload a video or shoot a reel to see it here.
                </p>

                <a href="${pageContext.request.contextPath}/video/reels"
                   class="btn btn-fdf mt-2">

                    Go to Reels & Create

                </a>

            </div>

        </c:when>

        <!-- DATA -->
        <c:otherwise>

            <div class="row g-3">

                <c:forEach var="video" items="${videos}">

                    <div class="col-md-4 col-sm-6">

                        <div class="card videoCard h-100">

                            <!-- MEDIA -->
                            <div class="media-wrap">

                                <c:choose>

                                    <!-- THUMBNAIL -->
                                    <c:when test="${not empty video.thumbnailPath}">

                                        <img src="${pageContext.request.contextPath}${video.thumbnailPath}"
                                             alt="${video.title}">

                                    </c:when>

                                    <!-- IMAGE FILE -->
                                    <c:when test="${
                                        not empty video.videoPath and
                                        (
                                            fn:endsWith(video.videoPath,'.jpg') or
                                            fn:endsWith(video.videoPath,'.jpeg') or
                                            fn:endsWith(video.videoPath,'.png') or
                                            fn:endsWith(video.videoPath,'.webp')
                                        )
                                    }">

                                        <img src="${pageContext.request.contextPath}${video.videoPath}"
                                             alt="${video.title}">

                                    </c:when>

                                    <!-- VIDEO FILE -->
                                    <c:otherwise>

                                        <video controls
                                               playsinline
                                               preload="metadata"
                                               style="max-height:280px;">

                                            <source src="${pageContext.request.contextPath}${video.videoPath}"
                                                    type="video/webm">

                                            <source src="${pageContext.request.contextPath}${video.videoPath}"
                                                    type="video/mp4">

                                        </video>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                            <!-- BODY -->
                            <div class="card-body">

                                <!-- BADGES -->
                                <div class="d-flex flex-wrap gap-1 mb-2">

                                    <c:if test="${video.isReel()}">

                                        <span class="badge text-bg-primary">

                                            <i class="bi bi-camera-reels"></i>
                                            Reel

                                        </span>

                                    </c:if>

                                    <c:if test="${not video.isReel()}">

                                        <span class="badge text-bg-secondary">
                                            Video
                                        </span>

                                    </c:if>

                                    <span class="badge text-bg-light text-dark border">
                                        ${video.category}
                                    </span>

                                    <c:if test="${video.isPrivate()}">

                                        <span class="badge text-bg-dark">

                                            <i class="bi bi-lock-fill"></i>
                                            Private

                                        </span>

                                    </c:if>

                                    <c:if test="${not video.isPrivate()}">

                                        <span class="badge text-bg-success">
                                            Public
                                        </span>

                                    </c:if>

                                </div>

                                <!-- TITLE -->
                                <h5 class="card-title fs-6 fw-bold">
                                    ${video.title}
                                </h5>

                                <!-- DESCRIPTION -->
                                <p class="card-text small text-muted text-truncate">
                                    ${video.description}
                                </p>

                                <!-- STATS -->
                                <p class="small text-muted mb-2">

                                    <i class="bi bi-clock"></i>
                                    ${video.uploadTime}

                                    <br>

                                    <i class="bi bi-heart-fill text-danger"></i>

                                    <span id="like-${video.id}">
                                        ${video.likeCount}
                                    </span>

                                    &nbsp;

                                    <i class="bi bi-eye"></i>

                                    <span id="view-${video.id}">
                                        ${video.viewCount}
                                    </span>

                                </p>

                                <!-- BUTTONS -->
                                <div class="d-flex flex-wrap gap-2">

                                    <c:if test="${video.isReel()}">

                                        <a href="${pageContext.request.contextPath}/video/reels"
                                           class="btn btn-outline-primary btn-sm">

                                            View in feed

                                        </a>

                                    </c:if>

                                    <a href="${pageContext.request.contextPath}/video/comments/${video.id}"
                                       class="btn btn-outline-secondary btn-sm">

                                        <i class="bi bi-chat"></i>
                                        Comments

                                    </a>

                                    <form action="${pageContext.request.contextPath}/video/deleteUpload"
                                          method="post"
                                          class="d-inline"
                                          onsubmit="return confirm('Delete this upload permanently?');">

                                        <input type="hidden"
                                               name="videoId"
                                               value="${video.id}">

                                        <button type="submit"
                                                class="btn btn-outline-danger btn-sm">

                                            <i class="bi bi-trash"></i>
                                            Delete

                                        </button>

                                    </form>

                                </div>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:otherwise>

    </c:choose>

</div>

</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>

</html>
