<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Video Gallery — Fight D Fear</title>
    
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

        /* Category Scroll Bar */
        .category-filter-row {
            display: flex;
            align-items: center;
            gap: 8px;
            max-width: 800px;
            margin: 24px auto 0;
            min-width: 0;
            width: 100%;
            padding: 0 10px;
            text-align: left;
        }
        .category-filter-row .cat-scroll-btn {
            flex-shrink: 0;
            width: 34px;
            height: 34px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .cat-scroll-container {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
            gap: 10px;
            margin-top: 0;
            overflow-x: auto;
            overflow-y: hidden;
            -webkit-overflow-scrolling: touch;
            scroll-behavior: smooth;
            padding-bottom: 8px;
            min-width: 0;
            flex: 1 1 auto;
            scrollbar-width: none;
            justify-content: flex-start;
            text-align: left;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .btn-cat-pill {
            padding: 8px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            flex-shrink: 0;
            white-space: nowrap;
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        /* Video cards styling */
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .v-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .v-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
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
            background: rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .play-btn-icon {
            font-size: 3.5rem;
            color: #fff;
            filter: drop-shadow(0 4px 10px rgba(0,0,0,0.3));
        }
        .v-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .v-category {
            font-size: 10px;
            font-weight: 800;
            color: var(--brand-pink);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
        }
        .v-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--brand-purple);
            line-height: 1.4;
            margin-bottom: 12px;
        }
        .v-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 14px;
            border-top: 1px dashed var(--fdf-border);
            font-size: 12px;
            color: var(--fdf-muted);
            margin-top: auto;
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
            .cat-scroll-container {
                justify-content: flex-start;
                padding: 4px 0 10px;
            }
            .video-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px 15px;
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
                <a href="${pageContext.request.contextPath}/video/allReels" class="top-btn">
                    <i class="bi bi-camera-reels"></i> Reels Gallery
                </a>
                <a href="${pageContext.request.contextPath}/video/uploadVideo" class="top-btn">
                    <i class="bi bi-cloud-arrow-up"></i> Upload Video
                </a>
            </div>
            
            <h1>Video Gallery</h1>
            <p>Empowering tutorials, lectures, and physical trainings. Filter by category, learn from certified experts, and keep track of your wellness training.</p>
            
            <!-- Category Scroll Bar -->
            <div class="category-filter-row">
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollVideoCat(-1)" aria-label="Scroll categories left">
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
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollVideoCat(1)" aria-label="Scroll categories right">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <!-- Videos Grid -->
        <div class="video-grid">
            <c:forEach var="video" items="${videos}" varStatus="status">
                <div class="col-12" style="display: contents;">
                    <div class="v-card" data-aos="fade-up">
                        <div class="v-thumb">
                            <video id="vid-${video.id}" poster="${pageContext.request.contextPath}/assets/img/video-placeholder.jpg">
                                <source src="${pageContext.request.contextPath}${video.filePath}" type="video/mp4">
                            </video>
                            <div class="v-overlay" onclick="togglePlay('vid-${video.id}')">
                                <i class="bi bi-play-fill play-btn-icon"></i>
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
                </div>
            </c:forEach>

            <c:if test="${empty videos}">
                <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                    <i class="bi bi-camera-video-off display-3 mb-3"></i>
                    <h5>No videos found in this category.</h5>
                    <a href="${pageContext.request.contextPath}/video/allVideos" class="btn btn-outline-primary rounded-pill px-4 mt-2">View All Videos</a>
                </div>
            </c:if>
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

    function togglePlay(id) {
        const video = document.getElementById(id);
        const card = video.closest('.v-card');
        const overlay = card.querySelector('.v-overlay');
        const icon = overlay.querySelector('i');

        if (video.paused) {
            // Pause all other videos first
            document.querySelectorAll('video').forEach(v => {
                if (v.id !== id) {
                    v.pause();
                    const otherCard = v.closest('.v-card');
                    if (otherCard) {
                        const otherOverlay = otherCard.querySelector('.v-overlay');
                        otherOverlay.style.opacity = '1';
                        otherOverlay.querySelector('i').className = 'bi bi-play-fill play-btn-icon';
                    }
                }
            });

            video.play();
            overlay.style.opacity = '0';
            icon.className = 'bi bi-pause-fill play-btn-icon';
        } else {
            video.pause();
            overlay.style.opacity = '1';
            icon.className = 'bi bi-play-fill play-btn-icon';
        }
        
        video.controls = !video.paused;
    }

    // Hover overlay trigger for playing videos
    document.querySelectorAll('.v-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            const video = this.querySelector('video');
            const overlay = this.querySelector('.v-overlay');
            if (video && !video.paused) {
                overlay.style.opacity = '1';
            }
        });
        card.addEventListener('mouseleave', function() {
            const video = this.querySelector('video');
            const overlay = this.querySelector('.v-overlay');
            if (video && !video.paused) {
                overlay.style.opacity = '0';
            }
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
        if (activePill) {
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
        }
    });
</script>

</body>
</html>
