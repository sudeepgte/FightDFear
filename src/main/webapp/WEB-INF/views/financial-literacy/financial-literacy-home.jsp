<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Financial Literacy Hub — Fight D Fear</title>
    
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

        /* Section layout */
        .fl-container {
            max-width: 1000px;
            margin: 40px auto 60px;
            padding: 0 15px;
        }
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-sm);
        }
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
        }
        .section-header h2 {
            font-size: 20px;
            font-weight: 800;
            color: var(--brand-purple);
            margin: 0;
        }
        .section-icon {
            font-size: 20px;
            color: var(--brand-pink);
        }

        /* Category pills scroll */
        .category-pills {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            scrollbar-width: none;
            margin-bottom: 25px;
            padding-bottom: 8px;
            width: 100%;
        }
        .category-pills::-webkit-scrollbar {
            display: none;
        }
        .category-pill {
            background: #fff;
            color: var(--fdf-muted);
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s;
        }
        .category-pill:hover, .category-pill.active {
            background: var(--gradient-primary);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 10px rgba(244,63,94,0.15);
        }

        /* Item layout */
        .item-card {
            background: #fafafb;
            border: 1px solid var(--fdf-border);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 15px;
            display: flex;
            gap: 20px;
            align-items: flex-start;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none !important;
            color: inherit;
        }
        .item-card:hover {
            background: #fff;
            transform: translateX(4px);
            box-shadow: var(--shadow-sm);
            border-color: var(--brand-pink-light);
        }
        .item-thumbnail {
            width: 140px;
            height: 95px;
            border-radius: 12px;
            background: #fff5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: var(--brand-pink);
            flex-shrink: 0;
            overflow: hidden;
            border: 1px solid var(--fdf-border);
        }
        .item-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .item-content {
            flex: 1;
        }
        .item-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 6px;
        }
        .item-description {
            color: var(--fdf-muted);
            font-size: 13px;
            line-height: 1.5;
            margin-bottom: 10px;
        }
        .item-meta {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .meta-tag {
            background: #f3f4f6;
            color: #4b5563;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
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
            .item-card {
                flex-direction: column;
            }
            .item-thumbnail {
                width: 100%;
                height: 160px;
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
            
            <h1>Financial Literacy Hub</h1>
            <p>Master your personal finances, investments, savings, and banking programs. Learn through expert videos, interactive virtual classes, or localized workshops.</p>
        </div>

        <div class="fl-container">
            <c:if test="${param.registrationSuccess}">
                <div class="alert alert-success rounded-4 border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Registration submitted successfully! Waiting for admin approval.
                </div>
            </c:if>

            <!-- Recorded Videos Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-play-btn-fill section-icon"></i>
                    <h2>Recorded Videos</h2>
                </div>

                <div class="d-flex align-items-center mb-4">
                    <button class="btn btn-sm btn-outline-secondary rounded-circle me-2" onclick="scrollCatLeft(this)">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <div class="category-pills flex-grow-1" id="videoCategories" style="margin-bottom: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                        <span class="category-pill active" data-category="all">All</span>
                        <span class="category-pill" data-category="saving">Saving</span>
                        <span class="category-pill" data-category="investing">Investing</span>
                        <span class="category-pill" data-category="loans">Loans</span>
                        <span class="category-pill" data-category="banking">Banking</span>
                        <span class="category-pill" data-category="insurance">Insurance</span>
                        <span class="category-pill" data-category="government">Government Schemes</span>
                    </div>
                    <button class="btn btn-sm btn-outline-secondary rounded-circle ms-2" onclick="scrollCatRight(this)">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>

                <div id="videosContainer">
                    <c:forEach var="video" items="${videos}">
                        <a href="${pageContext.request.contextPath}/financial-literacy/video/${video.id}" class="item-card" data-category="${video.category}">
                            <div class="item-thumbnail">
                                <i class="bi bi-play-circle-fill"></i>
                            </div>
                            <div class="item-content">
                                <h3 class="item-title">${video.title}</h3>
                                <p class="item-description">${video.description}</p>
                                <div class="item-meta">
                                    <span class="meta-tag"><i class="bi bi-tag"></i> ${video.category}</span>
                                    <span class="meta-tag"><i class="bi bi-clock"></i> ${video.duration}</span>
                                    <span class="meta-tag"><i class="bi bi-award"></i> ${video.level}</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Live Virtual Sessions Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-laptop section-icon"></i>
                    <h2>Live Virtual Sessions</h2>
                </div>

                <div id="liveSessionsContainer">
                    <c:forEach var="session" items="${liveSessions}">
                        <a href="${pageContext.request.contextPath}/financial-literacy/live-session/${session.id}" class="item-card">
                            <div class="item-thumbnail">
                                <i class="bi bi-calendar-event-fill"></i>
                            </div>
                            <div class="item-content">
                                <h3 class="item-title">${session.title}</h3>
                                <p class="item-description">${session.description}</p>
                                <div class="item-meta">
                                    <span class="meta-tag"><i class="bi bi-person-badge"></i> Speaker: ${session.speaker}</span>
                                    <span class="meta-tag"><i class="bi bi-calendar3"></i> ${session.date}</span>
                                    <span class="meta-tag"><i class="bi bi-clock"></i> ${session.time}</span>
                                    <span class="meta-tag"><i class="bi bi-people"></i> ${session.seats} Seats</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Offline Workshops Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-geo-alt-fill section-icon"></i>
                    <h2>Offline Workshops</h2>
                </div>

                <div id="workshopsContainer">
                    <c:forEach var="workshop" items="${workshops}">
                        <a href="${pageContext.request.contextPath}/financial-literacy/workshop/${workshop.id}" class="item-card">
                            <div class="item-thumbnail">
                                <i class="bi bi-building-fill"></i>
                            </div>
                            <div class="item-content">
                                <h3 class="item-title">${workshop.title}</h3>
                                <p class="item-description">${workshop.description}</p>
                                <div class="item-meta">
                                    <span class="meta-tag"><i class="bi bi-geo-alt"></i> ${workshop.city}</span>
                                    <span class="meta-tag"><i class="bi bi-calendar3"></i> ${workshop.date}</span>
                                    <span class="meta-tag"><i class="bi bi-clock"></i> ${workshop.time}</span>
                                    <span class="meta-tag"><i class="bi bi-people"></i> ${workshop.seats} Seats</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
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

    document.addEventListener('DOMContentLoaded', function() {
        // Video category filtering
        const categoryPills = document.querySelectorAll('#videoCategories .category-pill');
        const videoCards = document.querySelectorAll('#videosContainer .item-card');

        categoryPills.forEach(pill => {
            pill.addEventListener('click', function() {
                // Update active pill
                categoryPills.forEach(p => p.classList.remove('active'));
                this.classList.add('active');

                // Filter videos
                const category = this.getAttribute('data-category');
                videoCards.forEach(card => {
                    const cardCategory = card.getAttribute('data-category');
                    if (category === 'all' || cardCategory === category) {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    });

    function scrollCatLeft(btn) {
        const container = btn.nextElementSibling;
        container.scrollBy({ left: -200, behavior: 'smooth' });
    }
    function scrollCatRight(btn) {
        const container = btn.previousElementSibling;
        container.scrollBy({ left: 200, behavior: 'smooth' });
    }
</script>

</body>
</html>
