<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Fitness &amp; Wellness Platform — Fight D Fear</title>
    
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
        .cat-scroll-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
            overflow-x: auto;
            white-space: nowrap;
            padding-bottom: 8px;
            scrollbar-width: none;
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
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        /* Filter Form styling */
        .filter-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }
        .filter-card label {
            font-size: 12px;
            font-weight: 700;
            color: var(--brand-purple);
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        .filter-card input, .filter-card select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 14px;
        }

        /* Trainers Grid */
        .trainers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 25px;
            padding: 40px 0;
        }
        .trainer-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .trainer-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .trainer-card-top {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }
        .trainer-avatar {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff5f7;
            border: 3px solid var(--brand-pink-light);
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .trainer-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .trainer-name {
            font-size: 17px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 4px;
        }
        .rating-badge {
            background: #fffbeb;
            color: #d97706;
            border-radius: 8px;
            padding: 2px 8px;
            font-weight: 700;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .trainer-info-row {
            font-size: 13px;
            color: var(--fdf-muted);
            margin-bottom: 6px;
        }
        .spec-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 20px;
            flex-grow: 1;
        }
        .spec-tag {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            background: #f3f4f6;
            color: #4b5563;
        }
        .trainer-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 16px;
            border-top: 1px dashed var(--fdf-border);
            margin-top: auto;
        }
        .fee-label {
            font-size: 11px;
            color: var(--fdf-muted);
            text-transform: uppercase;
        }
        .fee-value {
            font-size: 18px;
            font-weight: 800;
            color: var(--brand-pink);
        }
        .btn-trainer-view {
            padding: 8px 18px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            color: #fff;
            background: var(--gradient-primary);
            transition: all 0.2s;
            text-decoration: none !important;
        }
        .btn-trainer-view:hover {
            filter: brightness(1.1);
            color: #fff;
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
                padding: 10px 15px;
            }
            .trainers-grid {
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
                <a href="${pageContext.request.contextPath}/users/dashboard" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-house-door"></i> Home
                </a>
                <a href="${pageContext.request.contextPath}/fitness/bookings" class="top-btn">
                    <i class="bi bi-calendar-check"></i> My Bookings
                </a>
                <a href="${pageContext.request.contextPath}/fitness/trainer/register" class="top-btn">
                    <i class="bi bi-person-plus"></i> Trainer Signup
                </a>
            </div>
            
            <h1>Fitness &amp; Wellness</h1>
            <p>Connect with verified female fitness mentors, yoga mentors, zumba guides, and home workout trainers customized to your fitness timeline.</p>
            
            <!-- Category Scroll -->
            <div class="d-flex align-items-center justify-content-center mt-3" style="max-width: 800px; margin: 0 auto;">
                <button class="btn btn-sm btn-outline-secondary rounded-circle me-2" onclick="scrollCatLeft(this)">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container flex-grow-1" style="margin-top: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                    <a href="${pageContext.request.contextPath}/fitness" class="btn-cat-pill ${empty selectedCategory ? 'active' : ''}">
                        <i class="bi bi-grid-fill"></i> All Specializations
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/fitness?category=${cat}" class="btn-cat-pill ${selectedCategory eq cat ? 'active' : ''}">
                            ${cat}
                        </a>
                    </c:forEach>
                </div>
                <button class="btn btn-sm btn-outline-secondary rounded-circle ms-2" onclick="scrollCatRight(this)">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="container my-4 px-4">
            <c:if test="${not empty success}">
                <div class="alert alert-success rounded-4 border-0 shadow-sm alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Search and Filter Form -->
            <form method="GET" action="${pageContext.request.contextPath}/fitness" class="filter-card mt-3">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">Search Trainer Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control bg-light border-0" value="${search}" placeholder="Trainer Name...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Maximum Session Fee</label>
                        <input type="number" name="maxPrice" class="form-control bg-light border-0" value="${maxPrice}" placeholder="e.g. 500 Rs">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Minimum Rating</label>
                        <select name="minRating" class="form-select bg-light border-0">
                            <option value="">Any Rating</option>
                            <option value="4.0" ${minRating eq 4.0 ? 'selected' : ''}>4.0+ Stars</option>
                            <option value="4.5" ${minRating eq 4.5 ? 'selected' : ''}>4.5+ Stars</option>
                        </select>
                    </div>
                    <input type="hidden" name="category" value="${selectedCategory}">
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-trainer-view py-2.5">Apply Filters</button>
                    </div>
                </div>
            </form>

            <!-- Active Mentors Grid -->
            <div class="trainers-grid">
                <c:forEach var="t" items="${trainers}">
                    <div class="col-12" style="display: contents;">
                        <div class="trainer-card" data-aos="fade-up">
                            <div class="trainer-card-top">
                                <div class="trainer-avatar">
                                    <img src="${not empty t.profilePhotoPath ? t.profilePhotoPath : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'}" alt="${t.fullName}">
                                </div>
                                <div>
                                    <h5 class="trainer-name">${t.fullName}</h5>
                                    <span class="rating-badge">
                                        <i class="bi bi-star-fill"></i> ${t.rating > 0 ? t.rating : 'New'}
                                    </span>
                                </div>
                            </div>
                            
                            <div class="trainer-info-row">
                                <i class="bi bi-briefcase me-2"></i> Experience: <strong>${t.experience} Years</strong>
                            </div>
                            <div class="trainer-info-row mb-3">
                                <i class="bi bi-clock me-2"></i> Available Timings: <strong>${t.availableTimings}</strong>
                            </div>

                            <div class="spec-tags">
                                <c:forEach var="spec" items="${t.specializations.split(',')}">
                                    <span class="spec-tag">${spec}</span>
                                </c:forEach>
                            </div>

                            <div class="trainer-footer">
                                <div>
                                    <div class="fee-label">Session Fee</div>
                                    <div class="fee-value">₹${t.sessionFees}<small class="text-muted" style="font-size: 11px;">/class</small></div>
                                </div>
                                <a href="${pageContext.request.contextPath}/fitness/trainer/${t.id}" class="btn-trainer-view">View Profile</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty trainers}">
                    <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                        <i class="bi bi-emoji-smile display-3 mb-3"></i>
                        <h5>No trainers found matching your filters.</h5>
                        <p class="small mb-0">Try clearing your search keyword or selecting a different specialization.</p>
                    </div>
                </c:if>
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
