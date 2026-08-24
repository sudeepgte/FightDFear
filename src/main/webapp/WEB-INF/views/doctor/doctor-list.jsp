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

        /* Search wrapper */
        .search-container {
            max-width: 500px;
            margin: 24px auto 0;
            position: relative;
        }
        .search-box {
            display: flex;
            align-items: center;
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-radius: 50px;
            padding: 6px 15px 6px 20px;
            box-shadow: var(--shadow-sm);
        }
        .search-box i {
            color: var(--brand-pink);
            margin-right: 10px;
        }
        .search-box input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 14px;
            color: var(--fdf-text);
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
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        /* Doctors Grid */
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 25px;
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .doctor-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
        }
        .doctor-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .doctor-card-top {
            padding: 24px;
            display: flex;
            gap: 16px;
            border-bottom: 1px dashed var(--fdf-border);
        }
        .doctor-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff5f7;
            font-size: 28px;
            font-weight: 800;
            color: var(--brand-pink);
            flex-shrink: 0;
            border: 2px solid var(--brand-pink-light);
        }
        .doctor-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .doctor-info {
            flex-grow: 1;
        }
        .doctor-spec {
            font-size: 11px;
            font-weight: 800;
            color: var(--brand-pink);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 4px;
        }
        .doctor-name {
            font-size: 17px;
            font-weight: 800;
            color: var(--brand-purple);
            margin: 2px 0 6px;
        }
        .doctor-loc {
            font-size: 12px;
            color: var(--fdf-muted);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .doctor-loc i {
            color: var(--brand-pink);
        }
        .doctor-tags {
            padding: 16px 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            flex-grow: 1;
        }
        .doctor-tag {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            background: #f3f4f6;
            color: #4b5563;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .doctor-tag.rating {
            background: #fef3c7;
            color: #d97706;
        }
        .doctor-tag.exp {
            background: #e0e7ff;
            color: #4f46e5;
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
            padding: 20px 24px 24px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }
        .btn-doc-media {
            padding: 8px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            border: 1px solid var(--fdf-border);
            text-align: center;
            text-decoration: none;
            color: var(--brand-purple);
            background: #fff;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .btn-doc-media:hover {
            background: var(--brand-purple);
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
            background: var(--gradient-primary);
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

                <a href="${pageContext.request.contextPath}/doctors/myAppointments" class="top-btn" style="background: var(--brand-purple); color: white;">
                    <i class="bi bi-file-earmark-medical"></i> My Prescriptions
                </a>
                <a href="${pageContext.request.contextPath}/doctors/myAppointments" class="top-btn">
                    <i class="bi bi-calendar-event"></i> My Appointments
                </a>

            </div>
            
            <h1>Find Your Doctor</h1>
            <p>Connect securely with verified, expert female doctors, gynecologists, and psychologists dedicated to women's physical and mental healthcare.</p>
            
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
