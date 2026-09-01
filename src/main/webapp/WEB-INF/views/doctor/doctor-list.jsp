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

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--border);
            position: relative;
        }
        .brand-row {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: var(--rose-soft);
            border: 1px solid #fecdd3;
            border-radius: 999px;
            padding: 8px 14px;
            margin-bottom: 12px;
        }
        .brand-row img {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            object-fit: cover;
        }
        .brand-row span {
            font-weight: 700;
            color: var(--navy);
            font-size: 14px;
        }
        .glow-header h1 {
            font-size: 2rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 10px;
            letter-spacing: -0.3px;
        }
        .glow-header p {
            color: var(--text-gray);
            font-size: 0.95rem;
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
            padding: 10px 18px;
            border-radius: 10px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--navy-soft);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--rose-soft);
            color: var(--primary);
            border-color: #fecdd3;
        }

        /* Search wrapper */
        .search-container {
            max-width: 500px;
            margin: 24px auto 0;
            position: relative;
            width: 100%;
            padding: 0 8px;
        }
        .search-box {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 8px 15px 8px 16px;
            box-shadow: var(--shadow-sm);
        }
        .search-box i {
            color: var(--primary);
            margin-right: 10px;
        }
        .search-box input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 14px;
            color: var(--navy-soft);
            font-family: inherit;
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
            -webkit-overflow-scrolling: touch;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .btn-cat-pill {
            padding: 8px 18px;
            border-radius: 10px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--navy-soft);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-family: inherit;
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--rose-soft);
            color: var(--primary);
            border-color: #fecdd3;
        }

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

<!-- Header -->


<div id="wrapper">
    <!-- Sidebar: user navigation only (doctors stay in portal chrome) -->
    <c:if test="${not viewerIsDoctor}">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    </c:if>
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">
        
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
            
            <div class="brand-row">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
                <span>Fight D Fear</span>
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
            
            <!-- Search bar -->
            <div class="search-container">
                <div class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchInput" placeholder="Search by name, specialization, or city..." oninput="filterDoctors()">
                </div>
            </div>
            
            <!-- Category Pills -->
            <div class="cat-scroll-container">
                <button class="btn-cat-pill active" onclick="filterCategory(this,'all')">
                    <i class="bi bi-grid-fill"></i> All Experts
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'Gynecologist')">
                    <i class="bi bi-gender-female"></i> Gynecologist
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'Psychologist')">
                    <i class="bi bi-brain-fill"></i> Psychologist
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'General Physician')">
                    <i class="bi bi-heart-pulse-fill"></i> General Physician
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'Dermatologist')">
                    <i class="bi bi-droplet-fill"></i> Dermatologist
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'Pediatrician')">
                    <i class="bi bi-emoji-smile-fill"></i> Pediatrician
                </button>
                <button class="btn-cat-pill" onclick="filterCategory(this,'Nutritionist')">
                    <i class="bi bi-cup-straw"></i> Nutritionist
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
                         data-loc="${d.locationText}">
                    
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

    function filterCategory(btn, cat) {
        document.querySelectorAll('.btn-cat-pill').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        activeCategory = cat;
        filterDoctors();
    }

    function filterDoctors() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        const cards = document.querySelectorAll('.doctor-card');
        let count = 0;
        
        cards.forEach(c => {
            const name = (c.dataset.name || '').toLowerCase();
            const spec = (c.dataset.spec || '').toLowerCase();
            const city = (c.dataset.city || '').toLowerCase();
            const loc = (c.dataset.loc || '').toLowerCase();
            
            const matchSearch = !q || name.includes(q) || spec.includes(q) || city.includes(q) || loc.includes(q);
            const matchCat = activeCategory === 'all' || spec.includes(activeCategory.toLowerCase());
            
            if (matchSearch && matchCat) {
                c.style.display = 'flex';
                count++;
            } else {
                c.style.display = 'none';
            }
        });
        document.getElementById('visibleCount').textContent = count;
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        filterDoctors();
    });
</script>

</body>
</html>
