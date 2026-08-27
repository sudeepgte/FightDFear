<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Video Gallery — Fight D Fear</title>

    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

    <style>
        :root {
            --fdf-surface: #FFFFFF;
            --fdf-bg: #F8FAFC;
            --fdf-secondary: #FFF1F2;
            --fdf-accent: #F43F5E;
            --fdf-accent-hover: #E11D48;
            --fdf-text: #0F172A;
            --fdf-muted: #64748B;
            --fdf-border: #E2E8F0;
            --fdf-shadow-sm: 0 1px 3px rgba(15, 23, 42, 0.06), 0 1px 2px rgba(15, 23, 42, 0.04);
            --fdf-shadow-md: 0 4px 14px rgba(15, 23, 42, 0.08);
            --fdf-shadow-lg: 0 10px 28px rgba(15, 23, 42, 0.10);
            --fdf-radius: 13px;
        }

        /* Themed scrollbars — page + horizontal filters */
        html {
            scrollbar-width: thin;
            scrollbar-color: var(--fdf-accent) var(--fdf-bg);
        }
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: var(--fdf-bg);
        }
        ::-webkit-scrollbar-thumb {
            background: var(--fdf-accent);
            border-radius: 999px;
            border: 2px solid var(--fdf-bg);
        }
        ::-webkit-scrollbar-thumb:hover {
            background: var(--fdf-accent-hover);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--fdf-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        #page-content-wrapper {
            min-height: 100vh;
            overflow-x: hidden;
            padding-bottom: 48px;
        }

        /* Header */
        .glow-header {
            padding: 56px 24px 36px;
            text-align: center;
            background: var(--fdf-surface);
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: var(--fdf-text);
            margin-bottom: 10px;
            letter-spacing: -0.02em;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 0.9375rem;
            max-width: 640px;
            margin: 0 auto;
            line-height: 1.65;
        }

        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 16px 28px;
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
        }
        .top-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 18px;
            border-radius: 999px;
            font-size: 0.8125rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            white-space: nowrap;
        }
        .top-btn-secondary {
            background: var(--fdf-surface);
            border: 1px solid var(--fdf-border);
            color: var(--fdf-text);
            box-shadow: var(--fdf-shadow-sm);
        }
        .top-btn-secondary:hover {
            background: var(--fdf-secondary);
            border-color: rgba(244, 63, 94, 0.35);
            color: var(--fdf-accent);
        }
        .top-btn-primary {
            background: var(--fdf-accent);
            border: 1px solid var(--fdf-accent);
            color: #fff;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.28);
        }
        .top-btn-primary:hover {
            background: var(--fdf-accent-hover);
            border-color: var(--fdf-accent-hover);
            color: #fff;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(244, 63, 94, 0.32);
        }

        /* Category filters */
        .category-filter-row {
            display: flex;
            align-items: center;
            gap: 8px;
            max-width: 860px;
            margin: 22px auto 0;
            min-width: 0;
            width: 100%;
            padding: 0 8px;
        }
        .category-filter-row .cat-scroll-btn {
            flex-shrink: 0;
            width: 34px;
            height: 34px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--fdf-border);
            background: var(--fdf-surface);
            color: var(--fdf-muted);
            border-radius: 50%;
            transition: all 0.2s ease;
        }
        .category-filter-row .cat-scroll-btn:hover {
            background: var(--fdf-secondary);
            border-color: rgba(244, 63, 94, 0.35);
            color: var(--fdf-accent);
        }
        .cat-scroll-container {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
            gap: 8px;
            overflow-x: auto;
            overflow-y: hidden;
            -webkit-overflow-scrolling: touch;
            scroll-behavior: smooth;
            padding-bottom: 6px;
            min-width: 0;
            flex: 1 1 auto;
            scrollbar-width: thin;
            scrollbar-color: var(--fdf-accent) var(--fdf-secondary);
        }
        .cat-scroll-container::-webkit-scrollbar {
            height: 5px;
        }
        .cat-scroll-container::-webkit-scrollbar-track {
            background: var(--fdf-secondary);
            border-radius: 999px;
        }
        .cat-scroll-container::-webkit-scrollbar-thumb {
            background: var(--fdf-accent);
            border-radius: 999px;
        }
        .btn-cat-pill {
            padding: 8px 18px;
            border-radius: 999px;
            background: var(--fdf-surface);
            border: 1px solid var(--fdf-border);
            color: var(--fdf-text);
            font-size: 0.8125rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            flex-shrink: 0;
            white-space: nowrap;
            line-height: 1.3;
        }
        .btn-cat-pill:hover {
            background: var(--fdf-secondary);
            border-color: rgba(244, 63, 94, 0.35);
            color: var(--fdf-accent);
        }
        .btn-cat-pill.active {
            background: var(--fdf-accent);
            color: #fff;
            border-color: var(--fdf-accent);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.22);
        }
        .btn-cat-pill.active:hover {
            background: var(--fdf-accent-hover);
            border-color: var(--fdf-accent-hover);
            color: #fff;
        }

        /* Video grid */
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 24px;
            padding: 36px 24px 12px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .v-card {
            background: var(--fdf-surface);
            border: 1px solid var(--fdf-border);
            border-radius: var(--fdf-radius);
            overflow: hidden;
            transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
            box-shadow: var(--fdf-shadow-sm);
            display: flex;
            flex-direction: column;
        }
        .v-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--fdf-shadow-lg);
            border-color: rgba(244, 63, 94, 0.4);
        }
        .v-thumb {
            position: relative;
            height: 200px;
            background: #000;
            overflow: hidden;
        }
        .v-thumb video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .v-overlay {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.28);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.2s ease, opacity 0.2s ease;
        }
        .v-card:hover .v-overlay {
            background: rgba(15, 23, 42, 0.38);
        }
        .play-btn-icon {
            width: 56px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: #fff;
            background: rgba(244, 63, 94, 0.92);
            border-radius: 50%;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.25);
            transition: transform 0.2s ease, background 0.2s ease;
        }
        .v-overlay:hover .play-btn-icon {
            transform: scale(1.06);
            background: var(--fdf-accent);
        }
        .v-body {
            padding: 18px 20px 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .v-category {
            font-size: 0.6875rem;
            font-weight: 700;
            color: var(--fdf-accent);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 6px;
        }
        .v-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--fdf-text);
            line-height: 1.45;
            margin-bottom: 12px;
        }
        .v-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid var(--fdf-border);
            font-size: 0.75rem;
            color: var(--fdf-muted);
            margin-top: auto;
            gap: 8px;
        }
        .v-footer i {
            color: var(--fdf-accent);
            margin-right: 3px;
        }

        /* Empty state */
        .empty-videos {
            grid-column: 1 / -1;
            text-align: center;
            padding: 56px 24px;
            background: var(--fdf-surface);
            border: 1px solid var(--fdf-border);
            border-radius: var(--fdf-radius);
            box-shadow: var(--fdf-shadow-sm);
        }
        .empty-videos i {
            font-size: 3rem;
            color: var(--fdf-accent);
            opacity: 0.55;
            display: block;
            margin-bottom: 12px;
        }
        .empty-videos h5 {
            color: var(--fdf-text);
            font-weight: 600;
            margin-bottom: 12px;
        }
        .btn-fdf-outline {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 9px 20px;
            border-radius: 999px;
            background: var(--fdf-surface);
            border: 1px solid var(--fdf-border);
            color: var(--fdf-text);
            font-size: 0.8125rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-fdf-outline:hover {
            background: var(--fdf-secondary);
            border-color: rgba(244, 63, 94, 0.35);
            color: var(--fdf-accent);
        }

        @media (max-width: 768px) {
            .glow-header { padding: 88px 16px 28px; }
            .top-bar {
                position: absolute;
                top: 0;
                left: 0;
                justify-content: center;
                padding: 12px 16px;
                flex-wrap: wrap;
            }
            .glow-header h1 { font-size: 1.625rem; }
            .video-grid {
                grid-template-columns: 1fr;
                gap: 18px;
                padding: 24px 16px 8px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper">

        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/video/allReels" class="top-btn top-btn-secondary">
                    <i class="bi bi-camera-reels"></i> Reels Gallery
                </a>
                <a href="${pageContext.request.contextPath}/video/uploadVideo" class="top-btn top-btn-primary">
                    <i class="bi bi-cloud-arrow-up"></i> Upload Video
                </a>
            </div>

            <h1>Video Gallery</h1>
            <p>Empowering tutorials, lectures, and physical trainings. Filter by category, learn from certified experts, and keep track of your wellness training.</p>

            <div class="category-filter-row">
                <button type="button" class="cat-scroll-btn" onclick="scrollVideoCat(-1)" aria-label="Scroll categories left">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container" id="videoCatScroll">
                    <a href="${pageContext.request.contextPath}/video/allVideos" class="btn-cat-pill ${empty param.category ? 'active' : ''}">
                        <i class="bi bi-grid-fill"></i> All Categories
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/video/allVideos?category=${cat}" class="btn-cat-pill ${param.category == cat ? 'active' : ''}">
                            <c:out value="${cat}"/>
                        </a>
                    </c:forEach>
                </div>
                <button type="button" class="cat-scroll-btn" onclick="scrollVideoCat(1)" aria-label="Scroll categories right">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="video-grid">
            <c:forEach var="video" items="${videos}">
                <div class="v-card" data-aos="fade-up">
                    <div class="v-thumb">
                        <video id="vid-${video.id}" poster="${pageContext.request.contextPath}/assets/img/video-placeholder.jpg">
                            <source src="${pageContext.request.contextPath}${video.filePath}" type="video/mp4">
                        </video>
                        <div class="v-overlay" onclick="togglePlay('vid-${video.id}')">
                            <span class="play-btn-icon"><i class="bi bi-play-fill"></i></span>
                        </div>
                    </div>
                    <div class="v-body">
                        <div class="v-category">${video.category}</div>
                        <h3 class="v-title">${video.title}</h3>
                        <div class="v-footer">
                            <span><i class="bi bi-eye"></i> ${video.views} Views</span>
                            <span><i class="bi bi-calendar-event"></i> <fmt:formatDate value="${video.uploadDate}" pattern="MMM dd, yyyy"/></span>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty videos}">
                <div class="empty-videos">
                    <i class="bi bi-camera-video-off"></i>
                    <h5>No videos found in this category.</h5>
                    <a href="${pageContext.request.contextPath}/video/allVideos" class="btn-fdf-outline">View All Videos</a>
                </div>
            </c:if>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({ duration: 700, easing: 'ease-in-out', once: true });

    function togglePlay(id) {
        const video = document.getElementById(id);
        const card = video.closest('.v-card');
        const overlay = card.querySelector('.v-overlay');
        const icon = overlay.querySelector('i');

        if (video.paused) {
            document.querySelectorAll('video').forEach(v => {
                if (v.id !== id) {
                    v.pause();
                    const otherCard = v.closest('.v-card');
                    if (otherCard) {
                        const otherOverlay = otherCard.querySelector('.v-overlay');
                        otherOverlay.style.opacity = '1';
                        otherOverlay.querySelector('i').className = 'bi bi-play-fill';
                    }
                }
            });
            video.play();
            overlay.style.opacity = '0';
            icon.className = 'bi bi-pause-fill';
        } else {
            video.pause();
            overlay.style.opacity = '1';
            icon.className = 'bi bi-play-fill';
        }
        video.controls = !video.paused;
    }

    document.querySelectorAll('.v-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            const video = this.querySelector('video');
            const overlay = this.querySelector('.v-overlay');
            if (video && !video.paused) overlay.style.opacity = '1';
        });
        card.addEventListener('mouseleave', function() {
            const video = this.querySelector('video');
            const overlay = this.querySelector('.v-overlay');
            if (video && !video.paused) overlay.style.opacity = '0';
        });
    });

    function scrollVideoCat(direction) {
        const container = document.getElementById('videoCatScroll');
        if (!container) return;
        const step = Math.max(container.clientWidth * 0.65, 180);
        container.scrollBy({ left: direction * step, behavior: 'smooth' });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const container = document.getElementById('videoCatScroll');
        if (!container) return;
        const activePill = container.querySelector('.btn-cat-pill.active');
        if (!activePill) return;
        const pills = [...container.querySelectorAll('.btn-cat-pill')];
        const activeIndex = pills.indexOf(activePill);
        if (activeIndex <= 0) {
            container.scrollLeft = 0;
        } else if (activeIndex >= pills.length - 1) {
            container.scrollLeft = Math.max(0, container.scrollWidth - container.clientWidth);
        } else {
            const pillLeft = activePill.offsetLeft;
            const pillWidth = activePill.offsetWidth;
            const viewWidth = container.clientWidth;
            container.scrollLeft = Math.max(0, pillLeft - (viewWidth / 2) + (pillWidth / 2));
        }
    });
</script>

</body>
</html>
