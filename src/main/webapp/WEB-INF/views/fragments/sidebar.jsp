<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="currentUri" value="${empty requestScope['javax.servlet.forward.request_uri'] ? pageContext.request.requestURI : requestScope['javax.servlet.forward.request_uri']}" />
<c:set var="sidebarUserId" value="${not empty user ? user.id : (not empty currentUser ? currentUser.id : (not empty sessionScope.user ? sessionScope.user.id : ''))}" />

<style>
    /* === Sidebar Layout CSS === */
    #wrapper {
        display: flex;
        width: 100%;
        align-items: stretch;
        margin-top: 80px;
    }
    
    /* Premium light sidebar (Fitness / Martial Arts dashboard parity) */
        #sidebar-wrapper {
        min-width: 260px;
        max-width: 260px;
        padding: 25px 30px;
        background: #F8FAFC !important;
        transition: transform 0.3s ease !important;
    }
    .sidebar-mobile-toggle { display: none !important; }
    #sidebar-wrapper .close-sidebar { display: none !important; }

    @media (max-width: 1200px) {
        #wrapper {
            flex-direction: column !important;
            margin-top: 72px;
        }
        #sidebar-wrapper {

            min-width: 100% !important;
            max-width: 100% !important;
            position: fixed !important;
            top: 72px !important;
            bottom: 0 !important;
            left: 0 !important;
            right: 0 !important;
            border-radius: 0 !important;
            background: #ffffff !important;
            z-index: 1040 !important;
            padding: 20px 15px 100px !important;
            overflow-y: auto !important;
            
            /* Fullscreen overlay hide logic */
            transform: translateY(-150%) !important; /* Slides down from top */
            opacity: 0;
            visibility: hidden;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1) !important;
            box-shadow: none !important;
        }
        #sidebar-wrapper.sidebar-open {
            transform: translateY(0) !important;
            opacity: 1;
            visibility: visible;
        }
        #sidebar-wrapper .list-group {
            display: flex !important;
            flex-direction: column !important;
            gap: 4px !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        .sidebar-list-group-item {

            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 80vw !important;
            max-width: 320px !important;
            height: 100vh !important;
            background: #fff !important;
            z-index: 1050 !important;
            padding: 20px !important;
            transform: translateX(-100%) !important;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1) !important;
            overflow-y: auto !important;
        }
        #sidebar-wrapper.sidebar-open { transform: translateX(0) !important; }
        .sidebar-mobile-toggle {
            display: flex !important;
            width: 100%;
            margin: 0;
            padding: 10px 16px;
            border: none;
            border-bottom: 1px solid #E2E8F0;
            border-radius: 0;
            background: #FFF1F2;
            color: #0F172A;
            font-size: 14px;
            font-weight: 600;
        }
        #sidebar-wrapper .list-group { margin-top: 40px !important; }
        #sidebar-wrapper .close-sidebar { display: block !important; position: absolute; top: 15px; right: 15px; font-size: 24px; cursor: pointer; color: #0F172A; }
        #page-content-wrapper {
            margin-left: 0 !important;
            padding: 0 !important;
            width: 100% !important;
        }
    }
        .sidebar-heading {
            padding: 8px 15px 10px !important;
            font-size: 1rem !important;
        }
        
        
                .sidebar-list-group-item {

            width: 100% !important;
            padding: 14px 20px !important;
            border-radius: 8px !important;
            background: transparent !important;
            font-size: 14px !important;
            display: flex !important;
            align-items: center !important;
            white-space: normal !important;
            color: #64748b !important;
            font-weight: 600 !important;
            text-decoration: none !important;
            transition: all 0.2s ease !important;
            position: relative !important;
            margin-bottom: 4px !important;
            border: none !important;
        }
        .sidebar-list-group-item i {
            margin-right: 14px !important;
            font-size: 1.1rem !important;
            width: 20px !important;
            text-align: center !important;
        }
        .sidebar-list-group-item:hover {
            color: #0f172a !important;
            background: #f1f5f9 !important;
        }
        .sidebar-list-group-item.active {
            color: #f43f5e !important;
            background: #fff1f2 !important;
        }
        .sidebar-list-group-item.active::before {
            content: '' !important;
            position: absolute !important;
            left: 0 !important;
            top: 50% !important;
            transform: translateY(-50%) !important;
            height: 70% !important;
            width: 4px !important;
            background: #f43f5e !important;
            border-radius: 0 4px 4px 0 !important;
            display: block !important;
        }
        .sidebar-logout-item { margin-top: 8px !important; color: #f43f5e !important; }
        #page-content-wrapper {
            margin-left: 0 !important;
            padding: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box !important;
        }
    }

    @media (max-width: 430px) {
        #wrapper {
            margin-top: 68px;
        }
        #sidebar-wrapper {
            top: 68px !important;
        }
        .sidebar-list-group-item {
            font-size: 13px !important;
            padding: 11px 12px !important;
        }
        #page-content-wrapper { padding: 0 !important; }
    }
</style>

<!-- Sidebar Toggle (Mobile) -->
<button type="button" class="sidebar-mobile-toggle" id="sidebarMobileToggle">
    <span><i class="bi bi-list me-2"></i> Menu</span> <i class="bi bi-chevron-down" id="sidebarToggleIcon" style="margin-left: auto;"></i>
</button>

<!-- Sidebar -->
<div id="sidebar-wrapper">
<i class="bi bi-x-lg close-sidebar" style="display:none;" onclick="document.getElementById('sidebar-wrapper').classList.remove('sidebar-open')"></i>
    
    <c:set var="isWorkerPortal" value="${isWorkerDashboard || fn:contains(currentUri, '/women-jobs/') || fn:contains(pageContext.request.requestURI, 'worker-profile') || fn:contains(pageContext.request.requestURI, 'worker-dashboard')}" />
    <div class="list-group list-group-flush mt-1" id="sidebarNavList">
        <c:choose>
            <c:when test="${isWorkerPortal}">
                <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="sidebar-list-group-item ${fn:contains(currentUri,'/women-jobs/dashboard') ? 'active' : ''}">
                    <i class="bi bi-briefcase-fill"></i> Job Bookings
                </a>
                <a href="${pageContext.request.contextPath}/women-jobs/profile" class="sidebar-list-group-item ${fn:contains(currentUri,'/women-jobs/profile') ? 'active' : ''}">
                    <i class="bi bi-person-gear"></i> My Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="sidebar-list-group-item sidebar-logout-item">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/users/dashboard" class="sidebar-list-group-item ${fn:contains(currentUri,'/users/dashboard') ? 'active' : ''}">
                    <i class="bi bi-house-door"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/chat/users" class="sidebar-list-group-item ${fn:contains(pageContext.request.requestURI, '/chat/') ? 'active' : ''}">
                    <i class="bi bi-chat-dots"></i> Chat
                </a>
                <a href="${pageContext.request.contextPath}/creator-hub" class="sidebar-list-group-item ${fn:contains(currentUri,'/creator-hub') ? 'active' : ''}">
                    <i class="bi bi-camera-reels"></i> Creator Hub
                </a>
                <c:if test="${isWorker || sessionScope.isWorker}">
                    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="sidebar-list-group-item ${fn:contains(currentUri,'/women-jobs/dashboard') ? 'active' : ''}">
                        <i class="bi bi-briefcase-fill"></i> Job Bookings
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/sos/dashboard" class="sidebar-list-group-item ${fn:contains(currentUri,'/sos') ? 'active' : ''}">
                    <i class="bi bi-exclamation-triangle"></i> SOS Emergency
                </a>
                <a href="${pageContext.request.contextPath}/users/profile/${sidebarUserId}" class="sidebar-list-group-item ${fn:contains(currentUri,'/users/profile') ? 'active' : ''}">
                    <i class="bi bi-person-badge"></i> Your Profile
                </a>
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="sidebar-list-group-item ${fn:contains(currentUri,'/centres') ? 'active' : ''}">
                    <i class="bi bi-shield-check"></i> Martial Arts Centres
                </a>
                <a href="${pageContext.request.contextPath}/video/allVideos" class="sidebar-list-group-item ${fn:contains(currentUri,'/video/allVideos') ? 'active' : ''}">
                    <i class="bi bi-play-circle"></i> View Videos
                </a>

                <a href="${pageContext.request.contextPath}/index/templates" class="sidebar-list-group-item ${fn:contains(currentUri,'/templates') ? 'active' : ''}">
                    <i class="bi bi-stars"></i> Glow Space
                </a>

                <a href="${pageContext.request.contextPath}/video/reels" class="sidebar-list-group-item ${fn:contains(currentUri,'/reels') ? 'active' : ''}">
                    <i class="bi bi-camera-video"></i> Reels
                </a>
                <a href="${pageContext.request.contextPath}/users/wallet" class="sidebar-list-group-item ${fn:contains(currentUri,'/wallet') ? 'active' : ''}">
                    <i class="bi bi-wallet2"></i> My Wallet
                </a>
                <a href="${pageContext.request.contextPath}/doctors/list" class="sidebar-list-group-item ${fn:contains(currentUri,'/doctors') ? 'active' : ''}">
                    <i class="bi bi-heart-pulse"></i> Women Doctors
                </a>
                <a href="${pageContext.request.contextPath}/marketplace" class="sidebar-list-group-item ${fn:contains(currentUri, '/marketplace') && (empty requestScope['javax.servlet.forward.query_string'] || !fn:contains(requestScope['javax.servlet.forward.query_string'], 'category=')) && !fn:contains(currentUri, '/marketplace/earn') ? 'active' : ''}">
                    <i class="bi bi-shop"></i> Women Marketplace
                </a>
                <a href="${pageContext.request.contextPath}/financial-literacy" class="sidebar-list-group-item ${fn:contains(currentUri,'/financial-literacy') ? 'active' : ''}">
                    <i class="bi bi-book"></i> Financial Literacy Hub
                </a>
                <c:if test="${not empty loggedEntrepreneur}">
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-list-group-item fw-bold">
                        <i class="bi bi-briefcase"></i> Entrepreneur Portal
                    </a>
                </c:if>
                <c:if test="${not empty loggedInvestor}">
                    <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-list-group-item fw-bold">
                        <i class="bi bi-wallet2"></i> Investor Portal
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/marketplace/list?category=WOMEN_LAWYER" class="sidebar-list-group-item ${not empty requestScope['javax.servlet.forward.query_string'] && fn:contains(requestScope['javax.servlet.forward.query_string'], 'WOMEN_LAWYER') ? 'active' : ''}">
                    <i class="bi bi-briefcase"></i> Women Lawyers
                </a>
                <a href="${pageContext.request.contextPath}/fitness" class="sidebar-list-group-item ${fn:contains(currentUri,'/fitness') ? 'active' : ''}">
                    <i class="bi bi-activity"></i> Fitness & Wellness
                </a>
                <a href="${pageContext.request.contextPath}/women-events" class="sidebar-list-group-item ${fn:contains(currentUri,'/women-events') ? 'active' : ''}">
                    <i class="bi bi-calendar-event"></i> Women Events
                </a>
                <a href="${pageContext.request.contextPath}/marketplace/earn" class="sidebar-list-group-item ${fn:contains(currentUri,'/marketplace/earn') ? 'active' : ''}">
                    <i class="bi bi-briefcase-fill"></i> Women Jobs
                </a>
                <a href="${pageContext.request.contextPath}/women-products" class="sidebar-list-group-item ${fn:contains(currentUri,'/women-products') ? 'active' : ''}">
                    <i class="bi bi-bag-heart"></i> Women Products
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="sidebar-list-group-item sidebar-logout-item">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var sidebar = document.getElementById("sidebar-wrapper");

        
        // Listen to the new global sidebar toggle in the top-left header
        var globalToggleBtn = document.getElementById("globalSidebarToggle");
        if (globalToggleBtn && sidebar) {
            globalToggleBtn.addEventListener("click", function() {

        var toggleBtn = document.getElementById("sidebarMobileToggle");
        var toggleIcon = document.getElementById("sidebarToggleIcon");

        if (toggleBtn && sidebar) {
                        toggleBtn.addEventListener("click", function(e) {
                e.stopPropagation();

                var isOpen = sidebar.classList.toggle("sidebar-open");
                
                // Toggle the icon visually
                if (isOpen) {
                    globalToggleBtn.classList.remove("bi-list");
                    globalToggleBtn.classList.add("bi-x");
                } else {
                    globalToggleBtn.classList.remove("bi-x");
                    globalToggleBtn.classList.add("bi-list");
                }
            });
            document.addEventListener("click", function(e) {
                if (sidebar.classList.contains("sidebar-open") && !sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
                    sidebar.classList.remove("sidebar-open");
                    toggleBtn.setAttribute("aria-expanded", "false");
                    if (toggleIcon) {
                        toggleIcon.classList.add("bi-chevron-down");
                        toggleIcon.classList.remove("bi-chevron-up");
                    }
                }
            });}

        var content = document.getElementById("page-content-wrapper");
        if(content && !document.getElementById("global-back-btn") && content.dataset.skipGlobalBack !== "true") {
            var backBtn = document.createElement("div");
            backBtn.id = "global-back-btn";
            backBtn.style.marginBottom = "20px";
            backBtn.innerHTML = '<a href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-sm" style="background: white; border: 1px solid #ddd; color: #1e1b4b; font-weight: 600; padding: 6px 15px; border-radius: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);"><i class="bi bi-arrow-left"></i> Go Back</a>';
            content.insertBefore(backBtn, content.firstChild);
        }
    });
</script>




















