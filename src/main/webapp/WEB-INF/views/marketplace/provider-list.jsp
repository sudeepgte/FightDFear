<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Find Your Right Lawyer | LexAssist</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
    
    <style>
        :root {
            --primary: #F43F5E;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card: #FFFFFF;
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            --text-main: #0F172A;
            --border: #E2E8F0;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text-main);
            padding-bottom: 80px; /* Space for bottom nav */
        }

        .container {
            padding: 0 20px;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Top Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            background: var(--bg);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--primary);
            font-weight: 700;
            font-size: 1.1rem;
        }
        .header-logo span {
            color: var(--text-main);
            font-size: 0.75rem;
            font-weight: 400;
            display: block;
        }

        /* Hero Section */
        .hero {
            padding: 10px 0 20px 0;
        }
        .hero h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 5px;
        }
        .hero p {
            color: var(--primary);
            font-size: 0.9rem;
            margin-bottom: 20px;
        }

        body.mp-list-page .location-tag {
            font-size: 0.85rem;
            color: var(--m-muted);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        body.mp-list-page .provider-name {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--m-navy);
            margin-bottom: 5px;
        }
        body.mp-list-page .provider-desc {
            font-size: 0.9rem;
            color: var(--m-muted);
            margin-bottom: 20px;
        }
        body.mp-list-page .btn-view {
            margin-top: auto;
            background: var(--m-rose);
            color: #fff;
            border: none;
            padding: 10px 16px;
            min-height: 42px;
            border-radius: 12px;
        }


        /* Search & Filters */
        .search-box {
            display: flex;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 5px;
            margin-bottom: 15px;
        }
        .search-input {
            flex: 1;
            border: none;
            padding: 10px 15px;
            outline: none;
            background: transparent;
            font-size: 0.9rem;
        }
        .search-btn {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            width: 44px;
            height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .filter-row {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }
        .location-selector {
            flex: 1;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-main);
        }
        .location-selector i {
            color: var(--primary);
        }
        .filter-btn {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-main);
            cursor: pointer;
        }

        /* Practice Areas */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
        }
        .view-all {
            color: var(--primary);
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
        }

        .practice-areas {
            display: flex;
            gap: 15px;
            overflow-x: auto;
            padding-bottom: 10px;
            scrollbar-width: none;
            margin-bottom: 30px;
        }
        .practice-areas::-webkit-scrollbar {
            display: none;
        }
        .practice-card {
            min-width: 110px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 15px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        .practice-icon {
            color: var(--primary);
            font-size: 1.5rem;
        }
        .practice-name {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-main);
            line-height: 1.2;
        }
        .practice-count {
            font-size: 0.7rem;
            color: var(--secondary);
        }

        /* Lawyer Cards */
        .lawyer-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
        }
        .promoted-badge {
            position: absolute;
            top: -10px;
            left: 20px;
            background: var(--primary);
            color: white;
            font-size: 0.7rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }
        .favorite-btn {
            color: var(--secondary);
            font-size: 1.2rem;
            cursor: pointer;
            margin-bottom: 5px;
        }
        .lawyer-header {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            align-items: flex-start;
        }
        .lawyer-photo {
            width: 70px;
            height: 70px;
            border-radius: 12px;
            object-fit: cover;
            background: #E2E8F0;
        }
        .lawyer-info {
            flex: 1;
        }
        .price-availability-col {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-left: auto;
            text-align: right;
            padding-top: 5px;
        }
        .lawyer-name {
            font-size: 1.1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 2px;
        }
        .verified-icon {
            color: var(--success-text);
            font-size: 0.9rem;
        }
        .lawyer-designation {
            font-size: 0.8rem;
            color: var(--secondary);
            margin-bottom: 8px;
        }
        .lawyer-meta {
            font-size: 0.75rem;
            color: var(--secondary);
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 4px;
        }
        .lawyer-meta i.star {
            color: #F59E0B;
        }
        .price-box {
            text-align: right;
        }
        .price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-main);
        }
        .price-label {
            font-size: 0.7rem;
            color: var(--secondary);
        }
        .availability {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--success-text);
        }
        .tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        .tag {
            background: var(--bg);
            color: var(--secondary);
            font-size: 0.75rem;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 500;
        }
        .card-actions {
            display: flex;
            gap: 10px;
        }
        .btn-secondary, .btn-primary-action {
            flex: 1;
            padding: 12px;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-secondary {
            background: var(--card);
            border: 1px solid var(--primary);
            color: var(--primary);
        }
        .btn-primary-action {
            background: var(--primary);
            border: 1px solid var(--primary);
            color: white;
        }

        /* Bottom Nav */
        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: var(--card);
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: space-around;
            padding: 12px 0 20px 0;
            z-index: 100;
        }
        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            color: var(--secondary);
            text-decoration: none;
            font-size: 0.7rem;
            font-weight: 500;
        }
        .nav-item i {
            font-size: 1.3rem;
        }
        .nav-item.active {
            color: var(--primary);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }
        .empty-state i {
            font-size: 4rem;
            color: var(--secondary);
            opacity: 0.3;
            margin-bottom: 15px;
        }
        .empty-state h3 {
            font-size: 1.2rem;
            color: var(--text-main);
            margin-bottom: 8px;
        }
        .empty-state p {
            font-size: 0.9rem;
            color: var(--secondary);
        }
        /* Bottom Mobile Nav */
        .bottom-nav {
            background: white;
            display: flex;
            justify-content: space-around;
            padding: 20px 0;
            border-top: 1px solid var(--border);
            margin-top: 40px;
            border-radius: 20px;
        }
        .bottom-nav .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--secondary);
            font-size: 0.85rem;
            font-weight: 500;
            gap: 6px;
        }
        .bottom-nav .nav-item i {
            font-size: 1.5rem;
            line-height: 1;
        }
        .bottom-nav .nav-item.active {
            color: var(--primary);
        }
        .bottom-nav .nav-item.active i {
            text-shadow: 0 0 1px var(--primary);
        }

        /* Adjust wrapper for bottom nav */
        #page-content-wrapper { padding-bottom: 30px !important; }

    </style>
</head>
<body>
    <style>
        /* Override sidebar layout to remove top gap since header is removed */
        #wrapper {
            margin-top: 0 !important;
        }
        #sidebar-wrapper {
            top: 0 !important;
        }
    </style>
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden; padding-bottom: 80px; background-color: var(--bg);">

    <div class="container-fluid" style="padding: 20px 40px;">

        <!-- Hero -->
        <section class="hero">
            <h1>Find the Right Lawyer</h1>
            <p>Trusted legal support, when you need it.</p>

            <div class="search-box">
                <i class="bi bi-search" style="padding:12px 10px; color:var(--secondary);"></i>
                <input type="text" class="search-input" placeholder="Search by name or practice area">
                <button class="search-btn"><i class="bi bi-search"></i></button>
            </div>

            <div class="filter-row">
                <div class="location-selector" style="display:flex; align-items:center;">
                    <i class="bi bi-geo-alt-fill" style="margin-right:8px; color:var(--primary);"></i>
                    <select id="locationSelect" style="background:transparent; border:none; outline:none; font-weight:600; font-size:0.9rem; color:#000; width:100%; cursor:pointer;">
                        <option value="all">All Locations</option>
                        <option value="Maharashtra">Maharashtra</option>
                        <option value="Karnataka">Karnataka</option>
                        <option value="Delhi">Delhi</option>
                        <option value="Tamil Nadu">Tamil Nadu</option>
                        <option value="Gujarat">Gujarat</option>
                        <option value="Telangana">Telangana</option>
                        <option value="Uttar Pradesh">Uttar Pradesh</option>
                        <option value="West Bengal">West Bengal</option>
                        <option value="Rajasthan">Rajasthan</option>
                        <option value="Kerala">Kerala</option>
                        <option value="Mumbai">Mumbai</option>
                        <option value="Bangalore">Bangalore</option>
                    </select>
                </div>
                <div class="dropdown">
                    <div class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;">
                        <i class="bi bi-filter"></i> Filter
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow" style="border-radius:12px; padding:10px;">
                        <li><a class="dropdown-item sort-opt" href="#" data-sort="rating">Highest Rating</a></li>
                        <li><a class="dropdown-item sort-opt" href="#" data-sort="experience">Most Experience</a></li>
                        <li><a class="dropdown-item sort-opt" href="#" data-sort="fee">Lowest Fee</a></li>
                    </ul>
                </div>
            </div>
        </section>

        <!-- Practice Areas (Dynamic) -->
        <div class="section-header">
            <div class="section-title">Practice Areas</div>
            <a href="#" class="view-all" onclick="document.querySelector('.practice-areas').style.flexWrap = 'wrap'; return false;">View all</a>
        </div>
        <%
            java.util.Map<String, Integer> areaCounts = new java.util.HashMap<String, Integer>();
            // Pre-populate with standard categories so the UI always looks full
            areaCounts.put("Family Law", 0);
            areaCounts.put("Criminal Law", 0);
            areaCounts.put("Property Law", 0);
            areaCounts.put("Corporate Law", 0);
            areaCounts.put("Civil Law", 0);
            areaCounts.put("Cyber Law", 0);
            
            Object obj = request.getAttribute("providers");
            if (obj instanceof java.util.List) {
                java.util.List list = (java.util.List) obj;
                for (Object pObj : list) {
                    try {
                        in.sp.main.Entities.ServiceProvider p = (in.sp.main.Entities.ServiceProvider) pObj;
                        String areas = p.getPracticeAreas();
                        if (areas != null && !areas.trim().isEmpty()) {
                            for (String a : areas.split(",")) {
                                a = a.trim();
                                if (!a.isEmpty()) {
                                    // Capitalize first letter to match defaults if possible, or just add
                                    String normalized = a.substring(0, 1).toUpperCase() + a.substring(1).toLowerCase();
                                    // Find if it exists case-insensitive to avoid duplicates
                                    String matchedKey = normalized;
                                    for (String key : areaCounts.keySet()) {
                                        if (key.equalsIgnoreCase(a)) {
                                            matchedKey = key;
                                            break;
                                        }
                                    }
                                    areaCounts.put(matchedKey, areaCounts.getOrDefault(matchedKey, 0) + 1);
                                }
                            }
                        }
                    } catch (Exception e) {}
                }
            }
            java.util.List<java.util.Map.Entry<String, Integer>> sortedAreas = new java.util.ArrayList<java.util.Map.Entry<String, Integer>>(areaCounts.entrySet());
            sortedAreas.sort(new java.util.Comparator<java.util.Map.Entry<String, Integer>>() {
                public int compare(java.util.Map.Entry<String, Integer> e1, java.util.Map.Entry<String, Integer> e2) {
                    return e2.getValue().compareTo(e1.getValue());
                }
            });
            request.setAttribute("topAreas", sortedAreas);
        %>
        <div class="practice-areas">
            <c:choose>
                <c:when test="${not empty topAreas}">
                    <c:forEach var="entry" items="${topAreas}">
                        <div class="practice-card filter-area-card" onclick="document.querySelector('.search-input').value = '${entry.key}'; document.querySelector('.search-input').dispatchEvent(new Event('input'));" style="cursor:pointer;">
                            <c:choose>
                                <c:when test="${fn:containsIgnoreCase(entry.key, 'Family') or fn:containsIgnoreCase(entry.key, 'Divorce')}"><i class="bi bi-people practice-icon"></i></c:when>
                                <c:when test="${fn:containsIgnoreCase(entry.key, 'Criminal')}"><i class="bi bi-hammer practice-icon"></i></c:when>
                                <c:when test="${fn:containsIgnoreCase(entry.key, 'Property')}"><i class="bi bi-house practice-icon"></i></c:when>
                                <c:when test="${fn:containsIgnoreCase(entry.key, 'Corporate')}"><i class="bi bi-briefcase practice-icon"></i></c:when>
                                <c:otherwise><i class="bi bi-book practice-icon"></i></c:otherwise>
                            </c:choose>
                            <div class="practice-name">${entry.key}</div>
                            <div class="practice-count">${entry.value} Lawyers</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="practice-card">
                        <i class="bi bi-people practice-icon"></i>
                        <div class="practice-name">Family Law</div>
                        <div class="practice-count">0 Lawyers</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Lawyer List -->
        <div class="empty-state" style="display: ${empty providers ? 'block' : 'none'};">
            <i class="bi bi-search"></i>
            <h3>No lawyers found</h3>
            <p>Try changing your search or filters.</p>
        </div>

        <c:forEach var="lawyer" items="${providers}">
            <div class="lawyer-card" data-rating="${empty lawyer.rating ? 0 : lawyer.rating}" data-experience="${empty lawyer.experienceYears ? 0 : lawyer.experienceYears}" data-fee="${empty lawyer.consultationFee ? 999999 : lawyer.consultationFee}">
                
                <div class="lawyer-header">
                    <c:choose>
                        <c:when test="${not empty lawyer.profilePhoto}">
                            <c:set var="pUrl" value="${lawyer.profilePhoto}" />
                            <c:if test="${not fn:startsWith(pUrl, 'http') and not fn:startsWith(pUrl, '/')}">
                                <c:set var="pUrl" value="/uploads/${pUrl}" />
                            </c:if>
                            <c:if test="${not fn:startsWith(pUrl, 'http')}">
                                <c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" />
                            </c:if>
                            <img src="${pUrl}" class="lawyer-photo" alt="Photo">
                        </c:when>
                        <c:otherwise>
                            <div class="lawyer-photo" style="display:flex; align-items:center; justify-content:center; color:var(--primary); font-size:1.5rem; font-weight:700;">
                                ${fn:substring(not empty lawyer.fullName ? lawyer.fullName : 'L', 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="lawyer-info">
                        <div class="lawyer-name">
                            ${lawyer.fullName}
                        </div>
                        <div class="lawyer-designation">${not empty lawyer.designation ? lawyer.designation : lawyer.category.displayName}</div>
                        
                        <div class="lawyer-meta">
                            <c:if test="${lawyer.rating > 0}">
                                <span><i class="bi bi-star-fill star"></i> ${lawyer.rating} (0)</span>
                                <span>&bull;</span>
                            </c:if>
                            <c:if test="${not empty lawyer.experienceYears}">
                                <span>${lawyer.experienceYears}+ Years Exp.</span>
                            </c:if>
                        </div>
                        <div class="lawyer-meta" style="margin-top:2px;">
                            <i class="bi bi-geo-alt"></i> 
                            <c:choose>
                                <c:when test="${not empty lawyer.city}">
                                    ${lawyer.city}<c:if test="${not empty lawyer.state}">, ${lawyer.state}</c:if>
                                </c:when>
                                <c:otherwise>
                                    ${lawyer.locationText}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="price-availability-col">
                        <i class="bi bi-heart favorite-btn"></i>
                        <div class="price-box">
                            <div class="price">₹${not empty lawyer.consultationFee ? lawyer.consultationFee : '1,500'}</div>
                            <div class="price-label">Starting Fee</div>
                        </div>
                        <div class="availability" style="margin-top: 10px;">
                            Available Today
                        </div>
                    </div>
                </div>

                <div class="tags">
                    <!-- Dynamic Practice Areas Tags -->
                    <c:choose>
                        <c:when test="${not empty lawyer.practiceAreas}">
                            <c:forEach var="tag" items="${fn:split(lawyer.practiceAreas, ',')}">
                                <div class="tag">${fn:trim(tag)}</div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="tag">Family Law</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/marketplace/view/${lawyer.id}" class="btn-secondary">View Profile</a>
                    <a href="${pageContext.request.contextPath}/marketplace/view/${lawyer.id}" class="btn-secondary">Write Review</a>
                    <a href="${pageContext.request.contextPath}/marketplace/view/${lawyer.id}" class="btn-primary-action">Book Now</a>
                </div>
            </div>
        </c:forEach>

    </div>

    </div>
    </div>
</div>

<!-- Bottom Mobile Nav -->
<c:set var="navUserId" value="${not empty user ? user.id : (not empty sessionScope.user ? sessionScope.user.id : '')}" />
<div class="bottom-nav">
    <a href="${pageContext.request.contextPath}/users/dashboard" class="nav-item">
        <i class="bi bi-house-door-fill"></i>
        <span>Home</span>
    </a>
    <a href="${pageContext.request.contextPath}/marketplace/list?category=WOMEN_LAWYER" class="nav-item active">
        <i class="bi bi-people-fill"></i>
        <span>Lawyers</span>
    </a>
    <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="nav-item">
        <i class="bi bi-calendar-event"></i>
        <span>Appointments</span>
    </a>
    <a href="${pageContext.request.contextPath}/users/profile/${navUserId}" class="nav-item">
        <i class="bi bi-person"></i>
        <span>Profile</span>
    </a>
</div>



    <!-- Dynamic Filter and Search Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 1. Search Functionality
            const searchInput = document.querySelector('.search-input');
            const lawyerCards = document.querySelectorAll('.lawyer-card');
            const emptyState = document.querySelector('.empty-state');

            function filterLawyers() {
                const query = searchInput.value.toLowerCase();
                const selectedLocation = document.getElementById('locationSelect').value.toLowerCase();
                let visibleCount = 0;

                lawyerCards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    const cityAttr = card.getAttribute('data-city');
                    const city = cityAttr ? cityAttr.toLowerCase() : '';
                    
                    const matchesSearch = text.includes(query);
                    const matchesLocation = selectedLocation === 'all' || city.includes(selectedLocation);

                    if (matchesSearch && matchesLocation) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                if (emptyState) {
                    emptyState.style.display = visibleCount === 0 ? 'block' : 'none';
                }
            }

            searchInput.addEventListener('input', filterLawyers);

            // 2. Setup Location Filtering
            lawyerCards.forEach(card => {
                const geoIcon = card.querySelector('.lawyer-meta i.bi-geo-alt');
                if (geoIcon && geoIcon.parentElement) {
                    const locationText = geoIcon.parentElement.textContent.trim();
                    if (locationText) {
                        card.setAttribute('data-city', locationText); // Store for easy filtering
                    }
                }
            });
            
            document.getElementById('locationSelect').addEventListener('change', filterLawyers);

            // 3. View All Practice Areas
            const viewAllBtn = document.querySelector('.view-all');
            const practiceAreasContainer = document.querySelector('.practice-areas');
            viewAllBtn.addEventListener('click', function(e) {
                e.preventDefault();
                if (practiceAreasContainer.style.flexWrap === 'wrap') {
                    practiceAreasContainer.style.flexWrap = 'nowrap';
                    practiceAreasContainer.style.overflowX = 'auto';
                    viewAllBtn.textContent = 'View all';
                } else {
                    practiceAreasContainer.style.flexWrap = 'wrap';
                    practiceAreasContainer.style.overflowX = 'visible';
                    viewAllBtn.textContent = 'Show less';
                }
            });

            // 4. Filter / Sort Logic
            const sortOpts = document.querySelectorAll('.sort-opt');
            const filterBtn = document.querySelector('.filter-btn');
            
            sortOpts.forEach(opt => {
                opt.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Update button text
                    const optText = this.textContent;
                    filterBtn.innerHTML = `<i class="bi bi-filter"></i> ${optText}`;

                    const sortType = this.getAttribute('data-sort');
                    const cardsArray = Array.from(lawyerCards);
                    
                    cardsArray.sort((a, b) => {
                        const valA = parseFloat(a.getAttribute(`data-${sortType}`)) || 0;
                        const valB = parseFloat(b.getAttribute(`data-${sortType}`)) || 0;
                        
                        if (sortType === 'fee') {
                            return valA - valB; // Lowest fee first
                        } else {
                            return valB - valA; // Highest rating/exp first
                        }
                    });
                    
                    // Re-append in sorted order (only if they aren't the empty state or other divs)
                    cardsArray.forEach(card => {
                        // Find the card's parent and append it to the end
                        card.parentNode.appendChild(card);
                    });
                });
            });
        });
    </script>

    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
