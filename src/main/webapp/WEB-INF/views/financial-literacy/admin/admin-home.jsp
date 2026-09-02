<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Financial Educator Dashboard - Fight D Fear Admin</title>

    <!-- Bootstrap 5 & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Shared Admin Portal Light Shell Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
    
    <style>
        body.ap-page { margin: 0; }
        .topbar { display: none !important; }
        .layout { display: flex; min-height: 100vh; }
        .main { flex: 1; min-width: 0; background: var(--ap-bg); }
        
        .fl-item-card {
            background: #fff;
            border-radius: 14px;
            border: 1px solid var(--ap-border);
            padding: 18px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(15,23,42,0.03);
        }
        .fl-item-card:hover {
            border-color: #CBD5E1;
            box-shadow: 0 10px 25px rgba(15,23,42,0.06);
            transform: translateY(-2px);
        }
        .fl-item-title {
            font-family: 'Outfit', 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.05rem;
            color: var(--ap-text);
            margin-bottom: 8px;
            line-height: 1.35;
        }
        .fl-item-meta {
            font-size: 0.84rem;
            color: var(--ap-muted);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .fl-item-meta i {
            color: var(--ap-accent);
            width: 16px;
        }
        .fl-item-desc {
            font-size: 0.86rem;
            color: #475569;
            margin-top: 8px;
            margin-bottom: 14px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .btn-ap-coral {
            background: var(--ap-accent);
            color: #fff;
            border: none;
            padding: 8px 18px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.88rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .btn-ap-coral:hover {
            background: #E02B4C;
            color: #fff;
            transform: translateY(-1px);
        }
    </style>
</head>
<body class="ap-page">

<c:set var="totalVid" value="${videoCount != null ? videoCount : 0}"/>
<c:set var="totalLive" value="${liveCount != null ? liveCount : 0}"/>
<c:set var="totalWork" value="${workshopCount != null ? workshopCount : 0}"/>
<c:set var="totalUp" value="${upcomingCount != null ? upcomingCount : 0}"/>

<div class="layout">
    <!-- Sidebar -->
    <%@ include file="/WEB-INF/views/globalAdminMenu.jsp" %>

    <!-- Main Content -->
    <main class="main">
        <!-- Shared Doctor Verification Style Topbar -->
        <div class="ap-topbar">
            <div class="ap-topbar-left">
                <button type="button" class="mobile-toggle" id="sidebarToggle" aria-label="Open menu"><i class="fas fa-bars"></i></button>
                <div class="ap-search" style="max-width:380px;">
                    <i class="fas fa-search"></i>
                    <input type="search" id="apHeaderSearch" placeholder="Search videos, sessions, workshops..." aria-label="Search">
                    <span class="ap-kbd">Ctrl + K</span>
                </div>
            </div>
            <div class="ap-topbar-right" style="display:flex;align-items:center;gap:10px;">
                <a class="ap-bell" href="${pageContext.request.contextPath}/admin/contact-messages" title="Notifications">
                    <i class="fas fa-bell"></i>
                    <span class="dot ${side_unreadContactMessages > 0 ? 'show' : ''}">${side_unreadContactMessages}</span>
                </a>
                <a class="ap-profile" href="${pageContext.request.contextPath}/admin/profile/${admin.id}">
                    <span class="ap-avatar">
                        <c:choose>
                            <c:when test="${not empty admin.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${admin.profilePhoto}" alt="">
                            </c:when>
                            <c:otherwise>${fn:substring(admin.name,0,1)}</c:otherwise>
                        </c:choose>
                    </span>
                    <span>
                        <div class="name"><c:out value="${admin.name}"/></div>
                        <div class="role">Super Admin</div>
                    </span>
                </a>
            </div>
        </div>

        <div class="ap-main-inner">
            <!-- Breadcrumb -->
            <nav class="ap-crumb">
                <a href="${pageContext.request.contextPath}/admin/adminDashboard">Dashboard</a>
                <span class="sep">&gt;</span>
                <a href="${pageContext.request.contextPath}/financial-literacy/admin">Financial Literacy</a>
                <span class="sep">&gt;</span>
                <span>Overview</span>
            </nav>

            <!-- Page Header with Circular Accent Badge -->
            <div class="ap-page-head">
                <div class="ap-page-ico"><i class="fas fa-wallet"></i></div>
                <div>
                    <h1>Financial Educator Dashboard</h1>
                    <p>Manage personal finance videos, live virtual sessions, offline workshops, and registrations</p>
                </div>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show mb-3" style="border-radius:12px;" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show mb-3" style="border-radius:12px;" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Statistic Cards Grid (Matching Doctor Verification) -->
            <div class="ap-stats">
                <div class="ap-stat blue">
                    <div class="ico"><i class="fas fa-video"></i></div>
                    <div class="val">${totalVid}</div>
                    <div class="lbl">Recorded Videos</div>
                    <div class="sub">Available library</div>
                </div>
                <div class="ap-stat purple">
                    <div class="ico"><i class="fas fa-broadcast-tower"></i></div>
                    <div class="val">${totalLive}</div>
                    <div class="lbl">Live Sessions</div>
                    <div class="sub">Virtual classes</div>
                </div>
                <div class="ap-stat green">
                    <div class="ico"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="val">${totalWork}</div>
                    <div class="lbl">Offline Workshops</div>
                    <div class="sub">In-person events</div>
                </div>
                <div class="ap-stat rose">
                    <div class="ico"><i class="fas fa-calendar-alt"></i></div>
                    <div class="val">${totalUp}</div>
                    <div class="lbl">Upcoming Sessions</div>
                    <div class="sub">Scheduled ahead</div>
                </div>
            </div>

            <!-- Dynamic Search & Category Filter Bar -->
            <div class="ap-panel p-3 mb-4" style="background:#fff;">
                <div class="row g-2 align-items-center">
                    <div class="col-12 col-md-6">
                        <div class="ap-search w-100" style="max-width:100%;">
                            <i class="fas fa-search"></i>
                            <input type="search" id="flAdminSearchInput" placeholder="Search by title, speaker, location or description..." aria-label="Search">
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <select id="flCategoryFilterSelect" class="form-select rounded-3" style="border-color:var(--ap-border); font-size:0.88rem; padding:9px 14px;">
                            <option value="">All Categories</option>
                            <option value="Saving">Saving</option>
                            <option value="Investing">Investing</option>
                            <option value="Loans">Loans</option>
                            <option value="Banking">Banking</option>
                            <option value="Insurance">Insurance</option>
                            <option value="Government Schemes">Government Schemes</option>
                            <option value="Others">Others</option>
                        </select>
                    </div>
                    <div class="col-12 col-md-2">
                        <button type="button" id="flSearchClearBtn" class="btn btn-outline-secondary w-100 rounded-3" style="padding:9px; font-size:0.88rem; font-weight:600;">
                            <i class="fas fa-redo me-1"></i> Reset
                        </button>
                    </div>
                </div>
            </div>

            <!-- 1. Recorded Videos Section -->
            <div class="ap-panel p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <h3 class="m-0 fs-5 fw-bold" style="color:var(--ap-text);"><i class="fas fa-play-circle me-2 text-danger"></i>Recorded Videos</h3>
                    <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="btn-ap-coral">
                        <i class="fas fa-plus"></i> Add Recorded Video
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty videos}">
                        <div class="row g-3" id="videoCardsGrid">
                            <c:forEach var="video" items="${videos}">
                                <c:set var="vCat" value="${video.category eq 'Others' and not empty video.customCategory ? video.customCategory : video.category}"/>
                                <div class="col-12 col-md-6 col-lg-4 fl-video-item" data-category="${vCat}">
                                    <div class="fl-item-card">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="badge bg-danger-subtle text-danger px-3 py-1 rounded-pill small fw-bold">
                                                    ${vCat}
                                                </span>
                                                <i class="fas fa-film text-muted"></i>
                                            </div>
                                            <div class="fl-item-title">${video.title}</div>
                                            <p class="fl-item-desc">${video.description}</p>
                                        </div>

                                        <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                            <c:choose>
                                                <c:when test="${empty video.videoUrl}">
                                                    <span class="btn btn-sm btn-light text-muted disabled"><i class="fas fa-video-slash me-1"></i> No URL</span>
                                                </c:when>
                                                <c:when test="${not fn:startsWith(video.videoUrl, 'http')}">
                                                    <a href="${pageContext.request.contextPath}${fn:startsWith(video.videoUrl, '/') ? '' : '/'}${video.videoUrl}" target="_blank" class="btn btn-sm btn-outline-danger rounded-pill fw-semibold">
                                                        <i class="fas fa-play me-1"></i> Watch
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${video.videoUrl}" target="_blank" class="btn btn-sm btn-outline-danger rounded-pill fw-semibold">
                                                        <i class="fas fa-play me-1"></i> Watch
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="d-flex gap-1">
                                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-video/${video.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Video">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-video/${video.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this recorded video?');">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Video">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div id="videoFilterEmpty" class="text-center py-4" style="display:none;">
                            <i class="fas fa-search fa-2x text-muted mb-2"></i>
                            <p class="text-muted fw-semibold mb-0">No recorded videos match your search/filter criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 rounded-3 style="background:#f8fafc; border:2px dashed #cbd5e1;">
                            <i class="fas fa-video fa-3x text-muted mb-3"></i>
                            <p class="text-muted fw-semibold mb-2">No recorded videos added yet</p>
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-video" class="btn-ap-coral btn-sm">
                                <i class="fas fa-plus me-1"></i> Add Recorded Video
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 2. Live Sessions Section -->
            <div class="ap-panel p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <h3 class="m-0 fs-5 fw-bold" style="color:var(--ap-text);"><i class="fas fa-broadcast-tower me-2 text-danger"></i>Live Sessions</h3>
                    <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="btn-ap-coral">
                        <i class="fas fa-plus"></i> Add Live Session
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty liveSessions}">
                        <div class="row g-3" id="sessionCardsGrid">
                            <c:forEach var="session" items="${liveSessions}">
                                <c:set var="sCat" value="${session.category eq 'Others' and not empty session.customCategory ? session.customCategory : session.category}"/>
                                <div class="col-12 col-md-6 col-lg-4 fl-session-item" data-category="${sCat}">
                                    <div class="fl-item-card">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="badge bg-secondary-subtle text-secondary px-3 py-1 rounded-pill small fw-bold">
                                                    ${sCat}
                                                </span>
                                                <c:choose>
                                                    <c:when test="${session.sessionStatus eq 'LIVE NOW'}">
                                                        <span class="badge bg-danger text-white px-2 py-1 rounded-pill small"><i class="fas fa-circle me-1 blink"></i> Live Now</span>
                                                    </c:when>
                                                    <c:when test="${session.sessionStatus eq 'COMPLETED'}">
                                                        <span class="badge bg-secondary text-white px-2 py-1 rounded-pill small"><i class="fas fa-check-circle me-1"></i> Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded-pill small"><i class="fas fa-calendar-alt me-1"></i> Upcoming</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="fl-item-title">${session.title}</div>
                                            
                                            <div class="fl-item-meta">
                                                <i class="fas fa-user-tie"></i>
                                                <span><strong>Speaker:</strong> ${session.speaker}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-calendar-day"></i>
                                                <span>${session.formattedDate != null ? session.formattedDate : session.date}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-clock"></i>
                                                <span>${session.formattedTime != null ? session.formattedTime : session.time}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-chair"></i>
                                                <span class="text-success fw-bold">${session.seatsLeft} seats available</span>
                                                <span class="text-muted small">(${session.seats} total)</span>
                                            </div>
                                        </div>

                                        <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                            <a href="${pageContext.request.contextPath}/financial-literacy/live-session/${session.id}" class="btn btn-sm btn-outline-danger rounded-pill fw-semibold">
                                                <i class="fas fa-eye me-1"></i> View Session
                                            </a>

                                            <div class="d-flex gap-1">
                                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-live-session/${session.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Session">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-live-session/${session.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this live session?');">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Session">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div id="sessionFilterEmpty" class="text-center py-4" style="display:none;">
                            <i class="fas fa-search fa-2x text-muted mb-2"></i>
                            <p class="text-muted fw-semibold mb-0">No live sessions match your search/filter criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 rounded-3" style="background:#f8fafc; border:2px dashed #cbd5e1;">
                            <i class="fas fa-calendar-check fa-3x text-muted mb-3"></i>
                            <p class="text-muted fw-semibold mb-2">No live sessions added yet</p>
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session" class="btn-ap-coral btn-sm">
                                <i class="fas fa-plus me-1"></i> Add Live Session
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 3. Offline Workshops Section -->
            <div class="ap-panel p-4 mb-4">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
                    <h3 class="m-0 fs-5 fw-bold" style="color:var(--ap-text);"><i class="fas fa-map-marker-alt me-2 text-danger"></i>Offline Workshops</h3>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="btn-ap-coral">
                            <i class="fas fa-plus"></i> Add Workshop
                        </a>
                        <a href="${pageContext.request.contextPath}/financial-literacy/admin/registrations" class="btn btn-dark rounded-pill fw-semibold" style="padding:8px 18px; font-size:0.88rem;">
                            <i class="fas fa-users me-1"></i> View Registrations
                        </a>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty workshops}">
                        <div class="row g-3" id="workshopCardsGrid">
                            <c:forEach var="workshop" items="${workshops}">
                                <div class="col-12 col-md-6 col-lg-4 fl-workshop-item" data-category="${workshop.category}">
                                    <div class="fl-item-card">
                                        <div>
                                            <div class="d-flex align-items-center justify-content-between mb-2">
                                                <span class="badge bg-secondary-subtle text-secondary px-3 py-1 rounded-pill small fw-bold">
                                                    ${workshop.category}
                                                </span>
                                                <span class="badge bg-warning-subtle text-warning-emphasis px-2 py-1 rounded-pill small">
                                                    <i class="fas fa-map-pin me-1"></i> Offline
                                                </span>
                                            </div>

                                            <div class="fl-item-title">${workshop.title}</div>
                                            
                                            <div class="fl-item-meta">
                                                <i class="fas fa-location-dot"></i>
                                                <span>${workshop.city != null ? workshop.city : workshop.venue}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-calendar-day"></i>
                                                <span>${workshop.date}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-clock"></i>
                                                <span>${workshop.time}</span>
                                            </div>
                                            <div class="fl-item-meta">
                                                <i class="fas fa-chair"></i>
                                                <span class="text-success fw-bold">${workshop.seatsLeft != null ? workshop.seatsLeft : workshop.seats} seats available</span>
                                            </div>
                                        </div>

                                        <div class="pt-3 border-top d-flex align-items-center justify-content-between gap-2">
                                            <a href="${pageContext.request.contextPath}/financial-literacy/workshop/${workshop.id}" class="btn btn-sm btn-outline-danger rounded-pill fw-semibold">
                                                <i class="fas fa-eye me-1"></i> View Details
                                            </a>

                                            <div class="d-flex gap-1">
                                                <a href="${pageContext.request.contextPath}/financial-literacy/admin/edit-workshop/${workshop.id}" class="btn btn-sm btn-outline-warning rounded-pill" title="Edit Workshop">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <form action="${pageContext.request.contextPath}/financial-literacy/admin/delete-workshop/${workshop.id}" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this offline workshop?');">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Delete Workshop">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div id="workshopFilterEmpty" class="text-center py-4" style="display:none;">
                            <i class="fas fa-search fa-2x text-muted mb-2"></i>
                            <p class="text-muted fw-semibold mb-0">No workshops match your search/filter criteria.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 rounded-3" style="background:#f8fafc; border:2px dashed #cbd5e1;">
                            <i class="fas fa-map-marker-alt fa-3x text-muted mb-3"></i>
                            <p class="text-muted fw-semibold mb-2">No workshops added yet</p>
                            <a href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop" class="btn-ap-coral btn-sm">
                                <i class="fas fa-plus me-1"></i> Add Workshop
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </main>
</div>

<!-- Dynamic Search & Filtering Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('flAdminSearchInput');
        const headerSearch = document.getElementById('apHeaderSearch');
        const categorySelect = document.getElementById('flCategoryFilterSelect');
        const clearBtn = document.getElementById('flSearchClearBtn');

        function filterContent() {
            const query = ((searchInput ? searchInput.value : '') || (headerSearch ? headerSearch.value : '')).toLowerCase().trim();
            const selectedCat = categorySelect ? categorySelect.value.toLowerCase().trim() : '';

            // Filter Video Cards
            let visibleVideos = 0;
            document.querySelectorAll('.fl-video-item').forEach(card => {
                const text = card.textContent.toLowerCase();
                const cat = (card.getAttribute('data-category') || '').toLowerCase();
                const matchesQuery = !query || text.includes(query);
                const matchesCat = !selectedCat || cat.includes(selectedCat) || (selectedCat === 'others' && cat === 'others');
                if (matchesQuery && matchesCat) {
                    card.style.display = 'block';
                    visibleVideos++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Filter Live Sessions
            let visibleSessions = 0;
            document.querySelectorAll('.fl-session-item').forEach(card => {
                const text = card.textContent.toLowerCase();
                const cat = (card.getAttribute('data-category') || '').toLowerCase();
                const matchesQuery = !query || text.includes(query);
                const matchesCat = !selectedCat || cat.includes(selectedCat) || (selectedCat === 'others' && cat === 'others');
                if (matchesQuery && matchesCat) {
                    card.style.display = 'block';
                    visibleSessions++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Filter Workshops
            let visibleWorkshops = 0;
            document.querySelectorAll('.fl-workshop-item').forEach(card => {
                const text = card.textContent.toLowerCase();
                const cat = (card.getAttribute('data-category') || '').toLowerCase();
                const matchesQuery = !query || text.includes(query);
                const matchesCat = !selectedCat || cat.includes(selectedCat) || (selectedCat === 'others' && cat === 'others');
                if (matchesQuery && matchesCat) {
                    card.style.display = 'block';
                    visibleWorkshops++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Update Empty State indicators if filtered
            const videoEmpty = document.getElementById('videoFilterEmpty');
            if (videoEmpty) videoEmpty.style.display = (visibleVideos === 0) ? 'block' : 'none';
            
            const sessionEmpty = document.getElementById('sessionFilterEmpty');
            if (sessionEmpty) sessionEmpty.style.display = (visibleSessions === 0) ? 'block' : 'none';

            const workshopEmpty = document.getElementById('workshopFilterEmpty');
            if (workshopEmpty) workshopEmpty.style.display = (visibleWorkshops === 0) ? 'block' : 'none';
        }

        if (searchInput) searchInput.addEventListener('input', filterContent);
        if (headerSearch) headerSearch.addEventListener('input', filterContent);
        if (categorySelect) categorySelect.addEventListener('change', filterContent);
        if (clearBtn) {
            clearBtn.addEventListener('click', function() {
                if (searchInput) searchInput.value = '';
                if (headerSearch) headerSearch.value = '';
                if (categorySelect) categorySelect.value = '';
                filterContent();
            });
        }
    });
</script>
</body>
</html>