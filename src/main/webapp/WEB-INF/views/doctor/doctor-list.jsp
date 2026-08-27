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
    <link href="${pageContext.request.contextPath}/assets/css/fdf-6010-pages.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/doctor-list-theme.css" rel="stylesheet">
</head>
<body class="fdf-page-shell fdf-page-doctors ${viewerIsDoctor ? 'fdf-no-sidebar' : ''}">

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

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
        <div class="dl-count-bar">
            <i class="bi bi-info-circle me-1"></i> Showing <span id="visibleCount" class="count-num">...</span> verified medical experts
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
