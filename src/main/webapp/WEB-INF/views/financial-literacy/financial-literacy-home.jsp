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
            --glow-bg: #F8FAFC;
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
            padding: 14px 20px 18px;
            text-align: center;
            background: white;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            position: relative;
            box-shadow: var(--shadow-sm);
        }
        /* Clean Minimal Header */
        .glow-header {
            padding: 14px 20px 18px;
            text-align: center;
            background: white;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            position: relative;
            box-shadow: var(--shadow-sm);
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 30px;
            font-weight: 900;
            color: #0B1736;
            background: none;
            -webkit-text-fill-color: initial;
            margin-bottom: 6px;
        }
        .glow-header p {
            color: #5B6B86;
            font-size: 13.5px;
            max-width: 750px;
            margin: 0 auto;
            line-height: 1.45;
        }

        .back-nav-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 50px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: #0B1736;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
        }
        .back-nav-btn:hover {
            background: #0B1736;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Section layout - Expanded Container */
        .fl-container {
            max-width: 1320px;
            margin: 16px auto 30px;
            padding: 0 20px;
        }

        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        .section-header h2 {
            font-size: 20px;
            font-weight: 800;
            color: #0B1736;
            margin: 0;
        }
        .section-icon {
            font-size: 20px;
            color: #FF3B5C;
        }

        /* Category pills scroll */
        .category-pills {
            display: flex;
            flex: 1 1 auto;
            min-width: 0;
            gap: 8px;
            overflow-x: auto;
            scrollbar-width: none;
            margin-bottom: 20px;
            padding-bottom: 4px;
            max-width: 100%;
            white-space: nowrap;
        }
        .category-pills::-webkit-scrollbar {
            display: none;
        }
        .category-pill {
            background: #fff;
            color: #5B6B86;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid #E2E8F0;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .category-pill:hover {
            color: #FF3B5C;
            border-color: #FF3B5C;
            background: #FFF1F3;
        }
        .category-pill.active {
            background: #FF3B5C !important;
            color: white !important;
            border-color: #FF3B5C !important;
            box-shadow: 0 4px 12px rgba(255, 59, 92, 0.35);
        }

        /* Responsive Module Card Grid */
        .hub-item-card {
            background: #fafafb;
            border: 1px solid var(--fdf-border);
            border-radius: 16px;
            padding: 18px;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s ease;
            text-decoration: none !important;
            color: inherit;
        }
        .hub-item-card:hover {
            background: #fff;
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(11, 23, 54, 0.08);
            border-color: #FF3B5C;
        }

        .hub-card-top {
            display: flex;
            gap: 14px;
            align-items: flex-start;
            margin-bottom: 14px;
        }

        .hub-thumbnail {
            width: 70px;
            height: 70px;
            border-radius: 12px;
            background: #FFF1F3;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: #FF3B5C;
            flex-shrink: 0;
            border: 1px solid #FFE4E6;
        }

        .hub-title {
            font-size: 1rem;
            font-weight: 800;
            color: #0B1736;
            margin-bottom: 4px;
            line-height: 1.3;
        }

        .hub-desc {
            color: #5B6B86;
            font-size: 0.85rem;
            line-height: 1.45;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .hub-meta-list {
            display: flex;
            flex-direction: column;
            gap: 6px;
            font-size: 0.82rem;
            color: #5B6B86;
            margin-bottom: 14px;
        }

        .hub-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .hub-meta-item i {
            color: #FF3B5C;
            width: 16px;
        }

        .text-primary {
            color: #FF3B5C !important;
        }

        .bg-purple {
            background-color: #0B1736 !important;
        }

        /* 📱 Mobile Responsiveness Overrides */
        html, body {
            width: 100% !important;
            max-width: 100vw !important;
            overflow-x: hidden !important;
            margin: 0;
            padding: 0;
            box-sizing: border-box !important;
        }

        #wrapper, #page-content-wrapper, .fl-container {
            width: 100% !important;
            max-width: 100vw !important;
            box-sizing: border-box !important;
        }

        @media (max-width: 768px) {
            .glow-header {
                padding: 16px 14px 14px !important;
                border-radius: 16px !important;
                margin: 0 8px !important;
                width: calc(100% - 16px) !important;
                box-sizing: border-box !important;
            }
            .glow-header h1 {
                font-size: 1.4rem !important;
                word-break: break-word !important;
            }
            .glow-header p {
                font-size: 0.82rem !important;
                line-height: 1.45 !important;
            }
            .fl-container {
                padding: 0 8px !important;
                margin-top: 12px !important;
                margin-bottom: 20px !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }
            .section-card {
                padding: 16px 12px !important;
                border-radius: 16px !important;
                margin-bottom: 16px !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }
            .section-header h2 {
                font-size: 1.15rem !important;
                word-break: break-word !important;
            }
            .hub-thumbnail {
                width: 52px !important;
                height: 52px !important;
                font-size: 1.4rem !important;
            }
            .hub-title {
                font-size: 0.95rem !important;
                word-break: break-word !important;
            }
            .hub-desc {
                font-size: 0.82rem !important;
            }
            .category-pills {
                margin-bottom: 0 !important;
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
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden; padding-top: 10px !important;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="container-fluid px-md-4 text-start">
                <a href="${pageContext.request.contextPath}/users/dashboard" class="back-nav-btn mb-2">
                    <i class="bi bi-arrow-left"></i> Go Back
                </a>
            </div>
            <h1>Financial Literacy Hub</h1>
            <p>Master your personal finances, investments, savings, and banking programs. Learn through expert videos, interactive virtual classes, or localized workshops.</p>
        </div>

        <div class="fl-container">
            <c:if test="${param.registrationSuccess}">
                <div class="alert alert-success rounded-4 border-0 shadow-sm mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Registration submitted successfully! Waiting for educator approval.
                </div>
            </c:if>

            <!-- 1. Recorded Videos Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-play-btn-fill section-icon"></i>
                    <h2>Recorded Videos</h2>
                </div>

                <!-- Category Filtering Bar -->
                <div class="d-flex align-items-center gap-2 mb-3">
                    <button class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 32px; height: 32px; flex-shrink: 0; display: inline-flex; align-items: center; justify-content: center;" onclick="scrollCatLeft(this)">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <div class="category-pills" id="videoCategories" style="margin-bottom: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                        <span class="category-pill active" data-category="all">All</span>
                        <span class="category-pill" data-category="Saving">Saving</span>
                        <span class="category-pill" data-category="Investing">Investing</span>
                        <span class="category-pill" data-category="Loans">Loans</span>
                        <span class="category-pill" data-category="Banking">Banking</span>
                        <span class="category-pill" data-category="Insurance">Insurance</span>
                        <span class="category-pill" data-category="Government Schemes">Government Schemes</span>
                        <span class="category-pill" data-category="Others">Others</span>
                    </div>
                    <button class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 32px; height: 32px; flex-shrink: 0; display: inline-flex; align-items: center; justify-content: center;" onclick="scrollCatRight(this)">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>

                <!-- Responsive Card Grid -->
                <div id="videosContainer" class="row g-3">
                    <c:choose>
                        <c:when test="${not empty videos}">
                            <c:forEach var="video" items="${videos}">
                                <div class="col-12 col-md-6 col-lg-4 video-card-wrapper" data-category="${video.category}" data-raw-category="${video.rawCategory}">
                                    <a href="${pageContext.request.contextPath}/financial-literacy/video/${video.id}" class="hub-item-card">
                                        <div>
                                            <div class="hub-card-top">
                                                <div class="hub-thumbnail">
                                                    <i class="bi bi-play-circle-fill"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <span class="badge bg-purple text-white px-2 py-1 rounded-pill small mb-1 fw-semibold">
                                                        ${video.category}
                                                    </span>
                                                    <h3 class="hub-title">${video.title}</h3>
                                                </div>
                                            </div>
                                            <p class="hub-desc">${video.description}</p>
                                        </div>
                                        <div class="pt-2 border-top d-flex align-items-center justify-content-between">
                                            <span class="text-primary small fw-bold"><i class="bi bi-play-fill me-1"></i> Watch Video</span>
                                            <i class="bi bi-chevron-right text-muted small"></i>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                    </c:choose>

                    <div id="noVideosEmptyState" class="col-12 text-center py-5 text-muted" style="display: <c:choose><c:when test="${empty videos}">block</c:when><c:otherwise>none</c:otherwise></c:choose>;">
                        <i class="bi bi-camera-video fs-1 text-secondary opacity-50 mb-2 d-block"></i>
                        <p class="mb-0 fw-medium fs-6">No recorded videos available yet.</p>
                    </div>
                </div>
            </div>

            <!-- 2. Live Virtual Sessions Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-laptop section-icon"></i>
                    <h2>Live Virtual Sessions</h2>
                </div>

                <div id="liveSessionsContainer" class="row g-3">
                    <c:choose>
                        <c:when test="${not empty liveSessions}">
                            <c:forEach var="session" items="${liveSessions}">
                                <div class="col-12 col-md-6 col-lg-4">
                                    <a href="${pageContext.request.contextPath}/financial-literacy/live-session/${session.id}" class="hub-item-card">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="badge bg-secondary px-2 py-1 rounded-pill small fw-semibold">
                                                    ${session.category}
                                                </span>
                                                <c:choose>
                                                    <c:when test="${session.sessionStatus eq 'LIVE NOW'}">
                                                        <span class="badge bg-danger text-white px-2 py-1 rounded-pill small"><i class="bi bi-broadcast me-1"></i> Live Now</span>
                                                    </c:when>
                                                    <c:when test="${session.sessionStatus eq 'COMPLETED'}">
                                                        <span class="badge bg-secondary text-white px-2 py-1 rounded-pill small"><i class="bi bi-check-circle me-1"></i> Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded-pill small"><i class="bi bi-calendar-event me-1"></i> Upcoming</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <h3 class="hub-title mb-2">${session.title}</h3>
                                            
                                            <div class="hub-meta-list">
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-person-badge"></i>
                                                    <span><strong>Speaker:</strong> ${session.speaker}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-calendar3"></i>
                                                    <span>${session.formattedDate != null ? session.formattedDate : session.date}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-clock"></i>
                                                    <span>${session.formattedTime != null ? session.formattedTime : session.time}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-people"></i>
                                                    <span class="text-success fw-bold">${session.seatsLeft} seats available</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="pt-2 border-top d-flex align-items-center justify-content-between">
                                            <span class="text-primary small fw-bold"><i class="bi bi-eye-fill me-1"></i> View Session</span>
                                            <i class="bi bi-chevron-right text-muted small"></i>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5 text-muted">
                                <i class="bi bi-laptop fs-1 text-secondary opacity-50 mb-2 d-block"></i>
                                <p class="mb-0 fw-medium fs-6">No live sessions available yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 3. Offline Workshops Section -->
            <div class="section-card" data-aos="fade-up">
                <div class="section-header">
                    <i class="bi bi-geo-alt-fill section-icon"></i>
                    <h2>Offline Workshops</h2>
                </div>

                <div id="workshopsContainer" class="row g-3">
                    <c:choose>
                        <c:when test="${not empty workshops}">
                            <c:forEach var="workshop" items="${workshops}">
                                <div class="col-12 col-md-6 col-lg-4">
                                    <a href="${pageContext.request.contextPath}/financial-literacy/workshop/${workshop.id}" class="hub-item-card">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="badge bg-secondary px-2 py-1 rounded-pill small fw-semibold">
                                                    ${workshop.category}
                                                </span>
                                                <span class="badge bg-warning text-dark px-2 py-1 rounded-pill small">
                                                    <i class="bi bi-geo-fill me-1"></i> Offline
                                                </span>
                                            </div>

                                            <h3 class="hub-title mb-2">${workshop.title}</h3>
                                            
                                            <div class="hub-meta-list">
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-geo-alt-fill text-danger"></i>
                                                    <span><strong>City:</strong> ${workshop.city != null ? workshop.city : workshop.venue}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-calendar3"></i>
                                                    <span>${workshop.formattedDate != null ? workshop.formattedDate : workshop.date}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-clock"></i>
                                                    <span>${workshop.formattedTime != null ? workshop.formattedTime : workshop.time}</span>
                                                </div>
                                                <div class="hub-meta-item">
                                                    <i class="bi bi-people"></i>
                                                    <span class="text-success fw-bold">${workshop.seatsLeft != null ? workshop.seatsLeft : workshop.seats} seats available</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="pt-2 border-top d-flex align-items-center justify-content-between">
                                            <span class="text-primary small fw-bold"><i class="bi bi-info-circle-fill me-1"></i> View Details</span>
                                            <i class="bi bi-chevron-right text-muted small"></i>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5 text-muted">
                                <i class="bi bi-geo-alt fs-1 text-secondary opacity-50 mb-2 d-block"></i>
                                <p class="mb-0 fw-medium fs-6">No offline workshops available yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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

    document.addEventListener('DOMContentLoaded', function() {
        const categoryPills = document.querySelectorAll('#videoCategories .category-pill');
        const videoWrappers = document.querySelectorAll('#videosContainer .video-card-wrapper');
        const emptyState = document.getElementById('noVideosEmptyState');

        function updateCategoryFilter(pill) {
            categoryPills.forEach(p => p.classList.remove('active'));
            pill.classList.add('active');

            const selectedCategory = (pill.getAttribute('data-category') || '').trim().toLowerCase();
            let visibleCount = 0;

            videoWrappers.forEach(wrapper => {
                const cardCategory = (wrapper.getAttribute('data-category') || '').trim().toLowerCase();
                const rawCategory = (wrapper.getAttribute('data-raw-category') || '').trim().toLowerCase();

                let isMatch = false;
                if (selectedCategory === 'all') {
                    isMatch = true;
                } else if (cardCategory === selectedCategory || rawCategory === selectedCategory) {
                    isMatch = true;
                } else if (selectedCategory === 'saving' && (cardCategory.includes('sav') || rawCategory.includes('sav'))) {
                    isMatch = true;
                } else if (selectedCategory === 'investing' && (cardCategory.includes('invest') || rawCategory.includes('invest'))) {
                    isMatch = true;
                } else if (selectedCategory === 'loans' && (cardCategory.includes('loan') || rawCategory.includes('loan'))) {
                    isMatch = true;
                } else if (selectedCategory === 'banking' && (cardCategory.includes('bank') || rawCategory.includes('bank'))) {
                    isMatch = true;
                } else if (selectedCategory === 'insurance' && (cardCategory.includes('insur') || rawCategory.includes('insur'))) {
                    isMatch = true;
                } else if ((selectedCategory.includes('gov') || selectedCategory.includes('government')) && (cardCategory.includes('gov') || rawCategory.includes('gov'))) {
                    isMatch = true;
                } else if (selectedCategory === 'others' && (rawCategory === 'others' || (cardCategory && !['saving','investing','loans','banking','insurance'].includes(cardCategory) && !cardCategory.includes('gov')))) {
                    isMatch = true;
                }

                if (isMatch) {
                    wrapper.style.display = 'block';
                    visibleCount++;
                } else {
                    wrapper.style.display = 'none';
                }
            });

            if (emptyState) {
                emptyState.style.display = (visibleCount === 0) ? 'block' : 'none';
            }
        }

        categoryPills.forEach(pill => {
            pill.addEventListener('click', function() {
                updateCategoryFilter(this);
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
