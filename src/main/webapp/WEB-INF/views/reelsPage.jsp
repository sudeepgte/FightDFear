<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Reels Gallery | Fight D Fear</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Montserrat:wght@800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

    <style>
        :root {
            --v-bg: #0f0f1a;
            --v-card: #1a1a2e;
            --v-accent: #f43f5e;
            --v-purple: #1e1b4b;
            --v-glass: rgba(255, 255, 255, 0.05);
            --v-glass-border: rgba(255, 255, 255, 0.1);
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--v-bg);
            color: #fff;
            overflow-x: hidden;
        }

        /* Hero Section */
        .video-hero {
            position: relative;
            height: 60vh;
            background: linear-gradient(rgba(15, 15, 26, 0.6), rgba(15, 15, 26, 1)), 
                        url('https://images.unsplash.com/photo-1552072092-7f9b8d63efcb?auto=format&fit=crop&q=80&w=2070');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .video-hero h1 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: clamp(2.5rem, 8vw, 5rem);
            text-transform: uppercase;
            letter-spacing: -2px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #fff 0%, var(--v-accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Search & Filter Bar */
        .filter-bar {
            background: var(--v-glass);
            backdrop-filter: blur(20px);
            border: 1px solid var(--v-glass-border);
            border-radius: 24px;
            padding: 20px 30px;
            margin-top: -50px;
            position: relative;
            z-index: 10;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
        }

        .category-tag {
            padding: 8px 20px;
            border-radius: 50px;
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            text-decoration: none !important;
            font-weight: 600;
            font-size: 0.9rem;
            transition: 0.3s;
            border: 1px solid transparent;
            display: inline-block;
            margin: 5px;
        }

        .category-tag:hover, .category-tag.active {
            background: var(--v-accent);
            border-color: var(--v-accent);
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(219, 39, 119, 0.3);
        }

        /* Video Card */
        .v-card {
            background: var(--v-card);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid var(--v-glass-border);
            height: 100%;
            position: relative;
        }

        .v-card:hover {
            transform: scale(1.03);
            border-color: var(--v-accent);
            box-shadow: 0 30px 60px rgba(0,0,0,0.4);
        }

        .v-thumb {
            position: relative;
            height: 400px; /* Taller for reels */
            overflow: hidden;
        }

        .v-thumb video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.5s;
        }

        .v-card:hover .v-thumb video {
            transform: scale(1.1);
        }

        .v-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 1;
            transition: 0.3s;
        }

        .v-card:hover .v-overlay {
            background: rgba(0, 0, 0, 0.2);
        }

        .play-btn-icon {
            font-size: 4rem;
            color: #fff;
            filter: drop-shadow(0 5px 15px rgba(0,0,0,0.5));
            transition: 0.3s;
        }

        .v-card:hover .play-btn-icon {
            transform: scale(1.2);
            color: var(--v-accent);
        }

        .v-body {
            padding: 20px;
        }

        .v-category {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--v-accent);
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .v-title {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 12px;
            line-height: 1.4;
            color: #fff;
        }

        .v-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.85rem;
            color: #aaa;
        }

        /* Custom Video Controls */
        video::-webkit-media-controls-panel {
            background-image: linear-gradient(transparent, rgba(0,0,0,0.8)) !important;
        }

        /* Sidebar Toggle Fix */
        .mobile-nav-toggle {
            color: #fff;
        }

        /* Dashboard Button Styling */
        .dashboard-bar {
            position: relative;
            z-index: 99;
            margin-top: 10px;
            padding-right: 15px;
        }
        .dashboard-btn {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            color: #fff !important;
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(124, 45, 94, 0.3);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            letter-spacing: 0.5px;
        }
        .dashboard-btn:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 25px rgba(124, 45, 94, 0.45);
            color: #fff !important;
        }
        .dashboard-btn i {
            font-size: 1.2rem;
            transition: transform 0.3s ease;
        }
        .dashboard-btn:hover i {
            transform: translateX(5px);
        }
    </style>
</head>
<body>

    <!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="dashboard-bar container-fluid container-xl d-flex justify-content-end gap-3">
        <a href="${pageContext.request.contextPath}/video/allVideos" class="dashboard-btn">
            Video Gallery <i class="bi bi-play-btn"></i>
        </a>
        <a href="${pageContext.request.contextPath}/video/uploadVideo" class="dashboard-btn">
            Upload Reel <i class="bi bi-cloud-arrow-up"></i>
        </a>
        <a href="${pageContext.request.contextPath}/users/dashboard" class="dashboard-btn">
            Dashboard <i class="bi bi-arrow-right"></i>
        </a>
    </div>

    <!-- Hero -->
    <section class="video-hero">
        <div class="container" data-aos="zoom-out">
            <h1>Reels Gallery</h1>
            <p class="lead opacity-75">Short, impactful stories and training moments.</p>
        </div>
    </section>

    <!-- Content -->
    <div class="container mb-5">
        <!-- Filter Bar -->
        <div class="filter-bar" data-aos="fade-up">
            <div class="row align-items-center">
                <div class="col-lg-3">
                    <h5 class="m-0 fw-800"><i class="bi bi-funnel-fill text-accent"></i> Categories</h5>
                </div>
                <div class="col-lg-9 text-lg-end mt-3 mt-lg-0">
                    <a href="${pageContext.request.contextPath}/video/allReels" class="category-tag ${empty param.category ? 'active' : ''}">All</a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/video/allReels?category=${cat}" 
                           class="category-tag ${param.category == cat ? 'active' : ''}"><c:out value="${cat}"/></a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Video Grid -->
        <div class="row g-4 mt-4">
            <c:forEach var="video" items="${videos}" varStatus="status">
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                    <div class="v-card">
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
                                <span><i class="bi bi-eye me-1"></i> ${video.views} Views</span>
                                <span><i class="bi bi-calendar-event me-1"></i> <fmt:formatDate value="${video.uploadDate}" pattern="MMM dd, yyyy"/></span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty videos}">
            <div class="text-center py-5" data-aos="fade-up">
                <i class="bi bi-camera-video-off display-1 opacity-25"></i>
                <h3 class="mt-4 opacity-50">No reels found in this category.</h3>
                <a href="${pageContext.request.contextPath}/video/allReels" class="btn btn-outline-light mt-3 rounded-pill px-4">
                    <i class="bi bi-arrow-left me-2"></i> View All Reels
                </a>
            </div>
        </c:if>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    
    <script>
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out',
            once: true,
            mirror: false
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
            
            // Show/Hide controls on play
            video.controls = !video.paused;
        }

        // Add hover effect to reveal overlay when paused
        document.querySelectorAll('.v-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                const video = this.querySelector('video');
                const overlay = this.querySelector('.v-overlay');
                if (!video.paused) {
                    overlay.style.opacity = '1';
                }
            });
            card.addEventListener('mouseleave', function() {
                const video = this.querySelector('video');
                const overlay = this.querySelector('.v-overlay');
                if (!video.paused) {
                    overlay.style.opacity = '0';
                }
            });
        });
    </script>
</body>
</html>

