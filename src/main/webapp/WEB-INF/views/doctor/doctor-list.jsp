<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Find Verified Doctors — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --rose-soft: #FFF1F2;
            --bg-page: #F8FAFC;
            --navy: #0F172A;
            --navy-soft: #1E293B;
            --border: #E2E8F0;
            --glow-bg: var(--bg-page);
            --card-bg: #ffffff;
            --shadow-sm: 0 4px 20px rgba(0,0,0,0.03);
            --shadow-md: 0 8px 24px rgba(244, 63, 94, 0.08);
            --shadow-lg: 0 12px 32px rgba(15, 23, 42, 0.08);
            --text-gray: #64748B;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--glow-bg);
            color: var(--navy-soft);
            overflow-x: hidden;
        }

        /* Soft atmosphere (muted — 60% surface) */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 420px; height: 420px;
            border-radius: 50%;
            filter: blur(90px);
            opacity: 0.07;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--primary); }
        .blob-2 { bottom: -150px; left: -150px; background: #94a3b8; animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        .glow-header {
            padding: 56px 24px 32px;
            text-align: center;
            background: white;
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
            position: relative;
            margin: 8px 20px 0;
        }
        .glow-header h1 {
            font-size: 38px;
            font-weight: 900;
            color: var(--primary);
            margin-bottom: 10px;
            letter-spacing: -0.4px;
        }
        .glow-header p {
            color: var(--text-gray);
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
            flex-wrap: wrap;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--navy-soft);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--primary);
            color: #fff;
            border-color: transparent;
            transform: translateY(-2px);
        }

        .category-filter-row {
            display: flex;
            align-items: center;
            gap: 8px;
            max-width: 800px;
            margin: 24px auto 0;
            min-width: 0;
            width: 100%;
            padding: 0 10px;
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
            overflow-x: auto;
            overflow-y: hidden;
            -webkit-overflow-scrolling: touch;
            scroll-behavior: smooth;
            padding-bottom: 8px;
            min-width: 0;
            flex: 1 1 auto;
            scrollbar-width: none;
            justify-content: flex-start;
        }
        .cat-scroll-container::-webkit-scrollbar { display: none; }
        .btn-cat-pill {
            padding: 8px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--text-gray);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-family: inherit;
            flex-shrink: 0;
            white-space: nowrap;
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }
        .filter-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }
        .filter-card label {
            font-size: 12px;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        .filter-card input, .filter-card select {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 14px;
            background: #f8fafc;
        }
        .btn-apply-filters {
            padding: 10px 18px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            color: #fff;
            background: var(--primary);
        }
        .btn-apply-filters:hover { filter: brightness(1.08); color: #fff; }

        /* Doctors Grid */
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .doctor-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            min-width: 0;
        }
        .doctor-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: #fecdd3;
        }
        .doctor-card-top {
            padding: 20px;
            display: flex;
            gap: 14px;
            border-bottom: 1px solid var(--border);
        }
        .doctor-avatar {
            width: 64px;
            height: 64px;
            border-radius: 14px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--rose-soft);
            font-size: 24px;
            font-weight: 800;
            color: var(--primary);
            flex-shrink: 0;
            border: 1px solid #fecdd3;
        }
        .doctor-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .doctor-info {
            flex-grow: 1;
            min-width: 0;
        }
        .doctor-spec {
            font-size: 11px;
            font-weight: 800;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 4px;
        }
        .doctor-name {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin: 2px 0 6px;
            word-break: break-word;
        }
        .doctor-loc {
            font-size: 12px;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .doctor-loc i {
            color: var(--primary);
        }
        .doctor-tags {
            padding: 14px 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            flex-grow: 1;
        }
        .doctor-tag {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 8px;
            background: #f1f5f9;
            color: #475569;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .doctor-tag.rating {
            background: #fef3c7;
            color: #d97706;
        }
        .doctor-tag.exp {
            background: #f1f5f9;
            color: var(--navy-soft);
        }
        .doctor-tag.online {
            background: #dcfce7;
            color: #16a34a;
        }
        .doctor-tag.emergency {
            background: #fee2e2;
            color: #dc2626;
        }
        .doctor-actions {
            padding: 16px 20px 20px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }
        .btn-doc-media {
            padding: 8px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            border: 1px solid var(--border);
            text-align: center;
            text-decoration: none;
            color: var(--navy-soft);
            background: #fff;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .btn-doc-media:hover {
            background: var(--primary);
            color: #fff;
            border-color: transparent;
        }
        .btn-doc-book {
            grid-column: span 3;
            padding: 10px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            border: none;
            text-align: center;
            text-decoration: none;
            color: #fff;
            background: var(--primary);
            transition: all 0.2s;
        }
        .btn-doc-book:hover {
            filter: brightness(1.1);
            color: #fff;
        }

        .empty-doctors {
            text-align: center;
            padding: 80px 20px;
            color: var(--fdf-muted);
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
            .doctors-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 20px 15px;
            }
            .doctor-card-top { padding: 15px; }
            .doctor-tags { padding: 10px 15px; }
            .doctor-actions { padding: 15px; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<c:if test="${viewerIsDoctor}">
<style>
  #wrapper { margin-top: 80px; display: block; }
  #page-content-wrapper { margin-left: 0 !important; width: 100%; }
</style>
</c:if>

<div id="wrapper">
    <!-- Sidebar: user navigation only (doctors stay in portal chrome) -->
    <c:if test="${not viewerIsDoctor}">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    </c:if>
    
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

                <c:choose>
                    <c:when test="${viewerIsDoctor}">
                        <a href="${pageContext.request.contextPath}/doctors/dashboard" class="top-btn">
                            <i class="bi bi-arrow-left"></i> Doctor Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/doctors/myAppointments?section=prescriptions" class="top-btn">
                            <i class="bi bi-file-earmark-medical"></i> My Prescriptions
                        </a>
                        <a href="${pageContext.request.contextPath}/doctors/myAppointments" class="top-btn">
                            <i class="bi bi-calendar-event"></i> My Appointments
                        </a>
                    </c:otherwise>
                </c:choose>

            </div>
            
            <c:choose>
                <c:when test="${viewerIsDoctor}">
                    <h1>Doctor Directory</h1>
                    <p>Browse other verified doctors on Fight D Fear. This is a peer directory preview — patients see a similar listing when booking care.</p>
                </c:when>
                <c:otherwise>
                    <h1>Find Your Doctor</h1>
                    <p>Connect securely with verified, expert female doctors, gynecologists, and psychologists dedicated to women's physical and mental healthcare.</p>
                </c:otherwise>
            </c:choose>
            
            <div class="category-filter-row">
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollDoctorCat(-1)" aria-label="Scroll categories left">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container" id="doctorCatScroll">
                <button type="button" class="btn-cat-pill active" onclick="filterCategory(this,'all')">
                    <i class="bi bi-grid-fill"></i> All Experts
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'Gynecologist')">
                    <i class="bi bi-gender-female"></i> Gynecologist
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'Psychologist')">
                    <i class="bi bi-brain-fill"></i> Psychologist
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'General Physician')">
                    <i class="bi bi-heart-pulse-fill"></i> General Physician
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'Dermatologist')">
                    <i class="bi bi-droplet-fill"></i> Dermatologist
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'Pediatrician')">
                    <i class="bi bi-emoji-smile-fill"></i> Pediatrician
                </button>
                <button type="button" class="btn-cat-pill" onclick="filterCategory(this,'Nutritionist')">
                    <i class="bi bi-cup-straw"></i> Nutritionist
                </button>
                </div>
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollDoctorCat(1)" aria-label="Scroll categories right">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="container mt-4">
                <div class="alert alert-success rounded-4 border-0 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${message}
                </div>
            </div>
        </c:if>

        <div class="container my-4 px-4">
            <form id="doctorFilterForm" class="filter-card" onsubmit="return applyDoctorFilters(event)">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">Search Doctor Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                            <input type="text" id="searchInput" class="form-control bg-light border-0" placeholder="Doctor Name...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Maximum Consultation Fee</label>
                        <input type="number" id="maxFeeInput" class="form-control bg-light border-0" placeholder="e.g. 500 Rs" min="0">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Minimum Rating</label>
                        <select id="minRatingInput" class="form-select bg-light border-0">
                            <option value="">Any Rating</option>
                            <option value="4.0">4.0+ Stars</option>
                            <option value="4.5">4.5+ Stars</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-apply-filters py-2">Apply Filters</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Showing count status -->
        <div class="container mt-4 px-4 text-muted small">
            <i class="bi bi-info-circle me-1"></i> Showing <span id="visibleCount" class="fw-bold text-dark">...</span> verified medical experts
        </div>

        <!-- Doctors Grid -->
        <div class="doctors-grid" id="doctorGrid">
            <c:forEach var="d" items="${doctors}">
                <c:if test="${empty sessionScope.loggedDoctor || d.id != sessionScope.loggedDoctor.id}">
                    <div class="doctor-card" data-aos="fade-up"
                         data-name="${d.fullName}" 
                         data-spec="${d.specialization}" 
                         data-city="${d.city}" 
                         data-loc="${d.locationText}"
                         data-fee="${d.consultationFee != null ? d.consultationFee : ''}"
                         data-rating="${d.rating != null ? d.rating : ''}">
                    
                    <div class="doctor-card-top">
                        <div class="doctor-avatar">
                            <c:choose>
                                <c:when test="${not empty d.profilePhotoPath}">
                                    <img src="${pageContext.request.contextPath}${d.profilePhotoPath}" alt="${d.fullName}">
                                </c:when>
                                <c:otherwise>
                                    <span>${d.fullName.charAt(0)}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="doctor-info">
                            <div class="doctor-spec">${d.specialization}</div>
                            <h3 class="doctor-name">${d.fullName}</h3>
                            <div class="doctor-loc">
                                <i class="bi bi-geo-alt-fill"></i>
                                <span>${d.locationText != null ? d.locationText : 'Location not set'}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="doctor-tags">
                        <span class="doctor-tag rating"><i class="bi bi-star-fill"></i> ${d.rating}</span>
                        <c:if test="${d.qualification != null}">
                            <span class="doctor-tag"><i class="bi bi-mortarboard"></i> ${d.qualification}</span>
                        </c:if>
                        <c:if test="${d.experienceYears != null}">
                            <span class="doctor-tag exp"><i class="bi bi-clock-history"></i> ${d.experienceYears} Years Exp</span>
                        </c:if>
                        <c:if test="${d.consultationType != null}">
                            <span class="doctor-tag online"><i class="bi bi-laptop"></i> ${d.consultationType}</span>
                        </c:if>
                        <c:if test="${d.emergencyAvailable != null && d.emergencyAvailable}">
                            <span class="doctor-tag emergency"><i class="bi bi-lightning-fill"></i> Emergency</span>
                        </c:if>
                    </div>

                    <div class="doctor-actions">
                        <a href="${pageContext.request.contextPath}/doctors/chat/${d.id}" class="btn-doc-media">
                            <i class="bi bi-chat-dots-fill"></i> Chat
                        </a>
                        <a href="${pageContext.request.contextPath}/doctors/voice-call/${d.id}" target="_blank" class="btn-doc-media">
                            <i class="bi bi-telephone-fill"></i> Call
                        </a>
                        <a href="${pageContext.request.contextPath}/doctors/video-call/${d.id}" target="_blank" class="btn-doc-media">
                            <i class="bi bi-camera-video-fill"></i> Video
                        </a>
                        <a href="${pageContext.request.contextPath}/doctors/view/${d.id}" class="btn-doc-book mt-2">
                            View Profile &amp; Book
                        </a>
                    </div>
                </div>
                </c:if>
            </c:forEach>
            
            <c:if test="${empty doctors}">
                <div class="empty-doctors col-12">
                    <i class="bi bi-clipboard-x display-1 mb-3 text-muted"></i>
                    <h3>No doctors listed</h3>
                    <p>We are currently onboarding verified doctors. Please check back shortly!</p>
                </div>
            </c:if>
        </div>

        <!-- Footer -->
        

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

<script>
    let activeCategory = 'all';

    function scrollDoctorCat(direction) {
        const container = document.getElementById('doctorCatScroll');
        if (!container) return;
        const step = Math.max(container.clientWidth * 0.65, 180);
        container.scrollBy({ left: direction * step, behavior: 'smooth' });
    }

    function filterCategory(btn, cat) {
        document.querySelectorAll('.btn-cat-pill').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        activeCategory = cat;
        filterDoctors();
    }

    function applyDoctorFilters(e) {
        if (e) e.preventDefault();
        filterDoctors();
        return false;
    }

    function filterDoctors() {
        const searchEl = document.getElementById('searchInput');
        const q = searchEl ? searchEl.value.toLowerCase() : '';
        const maxFeeRaw = (document.getElementById('maxFeeInput') || {}).value;
        const minRatingRaw = (document.getElementById('minRatingInput') || {}).value;
        const maxFee = maxFeeRaw ? parseFloat(maxFeeRaw) : null;
        const minRating = minRatingRaw ? parseFloat(minRatingRaw) : null;
        const cards = document.querySelectorAll('.doctor-card');
        let count = 0;
        
        cards.forEach(c => {
            const name = (c.dataset.name || '').toLowerCase();
            const spec = (c.dataset.spec || '').toLowerCase();
            const city = (c.dataset.city || '').toLowerCase();
            const loc = (c.dataset.loc || '').toLowerCase();
            const fee = parseFloat(c.dataset.fee);
            const rating = parseFloat(c.dataset.rating);
            
            const matchSearch = !q || name.includes(q) || spec.includes(q) || city.includes(q) || loc.includes(q);
            const matchCat = activeCategory === 'all' || spec.includes(activeCategory.toLowerCase());
            const matchFee = maxFee == null || isNaN(maxFee) || (!isNaN(fee) && fee <= maxFee);
            const matchRating = minRating == null || isNaN(minRating) || (!isNaN(rating) && rating >= minRating);
            
            if (matchSearch && matchCat && matchFee && matchRating) {
                c.style.display = 'flex';
                count++;
            } else {
                c.style.display = 'none';
            }
        });
        const countEl = document.getElementById('visibleCount');
        if (countEl) countEl.textContent = count;
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        filterDoctors();
    });
</script>

</body>
</html>
