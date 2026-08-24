<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
        background: #ffffff;
        color: #0F172A;
        transition: all 0.3s ease-in-out;
        z-index: 1000;
        position: fixed;
        top: 80px; 
        bottom: 0;
        overflow-y: auto;
        overflow-x: hidden;
        -webkit-overflow-scrolling: touch;
        padding-bottom: 40px;
        border-top-right-radius: 24px;
        border-right: 1px solid #E2E8F0;
        padding-top: 20px;
        box-shadow: 2px 0 12px rgba(0,0,0,0.03);
    }

    #sidebar-wrapper .list-group {
        padding-bottom: 80px;
    }
    
    #sidebar-wrapper::-webkit-scrollbar { width: 4px; }
    #sidebar-wrapper::-webkit-scrollbar-thumb { background-color: #E2E8F0; border-radius: 10px; }
    
    .sidebar-heading {
        padding: 10px 25px 25px;
        font-size: 1.05rem;
        font-weight: 800;
        color: #0F172A;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .sidebar-heading i { color: #F43F5E; }
    
    .sidebar-list-group-item {
        background: transparent;
        color: #64748B;
        border: none;
        padding: 12px 25px;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 15px;
        position: relative;
        text-decoration: none;
        cursor: pointer;
        pointer-events: auto;
    }
    .sidebar-list-group-item i { font-size: 1.1rem; width: 20px; text-align: center; color: #94A3B8; }
    .sidebar-list-group-item:hover, .sidebar-list-group-item.active {
        color: #F43F5E;
        background: #FFF1F2;
    }
    .sidebar-list-group-item:hover i, .sidebar-list-group-item.active i { color: #F43F5E; }
    .sidebar-list-group-item:hover::before, .sidebar-list-group-item.active::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        height: 70%;
        width: 4px;
        background: #f43f5e;
        border-radius: 0 4px 4px 0;
    }

    .sidebar-logout-item {
        color: #f43f5e;
        margin-top: 15px;
        border-top: 1px solid #E2E8F0;
    }

    .sidebar-mobile-toggle {
        display: none;
        width: calc(100% - 30px);
        margin: 12px 15px 12px;
        padding: 10px 16px;
        border: 1px solid #E2E8F0;
        border-radius: 12px;
        background: #FFF1F2;
        color: #0F172A;
        font-size: 14px;
        font-weight: 600;
        align-items: center;
        justify-content: space-between;
        cursor: pointer;
    }

    #page-content-wrapper {
        flex: 1;
        margin-left: 260px;
        min-width: 0;
        display: flex;
        flex-direction: column;
        padding: 25px 30px;
        background: #F8FAFC !important;
    }
    
    @media (max-width: 768px) {
        #wrapper {
            flex-direction: column !important;
            margin-top: 72px;
        }
        #sidebar-wrapper {
            min-width: 100% !important;
            max-width: 100% !important;
            position: relative !important;
            top: 0 !important;
            bottom: auto !important;
            left: 0 !important;
            right: 0 !important;
            border-top-right-radius: 0 !important;
            border-bottom-left-radius: 16px !important;
            border-bottom-right-radius: 16px !important;
            padding: 12px 0 10px !important;
            height: auto !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08) !important;
        }
        .sidebar-heading {
            padding: 8px 15px 10px !important;
            font-size: 1rem !important;
        }
        .sidebar-mobile-toggle {
            display: flex;
        }
        #sidebar-wrapper:not(.sidebar-open) .list-group {
            display: none !important;
        }
        #sidebar-wrapper.sidebar-open .list-group {
            display: flex !important;
            flex-direction: column !important;
            flex-wrap: nowrap !important;
            gap: 0 !important;
            margin-top: 0 !important;
            padding: 0 10px 10px !important;
            max-height: 60vh;
            overflow-y: auto;
            -webkit-overflow-scrolling: touch;
        }
        .sidebar-list-group-item {
            width: 100% !important;
            padding: 12px 14px !important;
            border-radius: 10px !important;
            background: transparent !important;
            font-size: 14px !important;
            display: flex !important;
            white-space: normal !important;
            min-height: 44px;
        }
        .sidebar-list-group-item::before {
            display: none !important;
        }
        .sidebar-list-group-item:hover,
        .sidebar-list-group-item.active {
            background: rgba(244, 63, 94, 0.15) !important;
            color: #fff !important;
        }
        .sidebar-logout-item {
            margin-top: 8px !important;
            padding-top: 14px !important;
        }
        #page-content-wrapper {
            margin-left: 0 !important;
            padding: 14px 12px !important;
            width: 100% !important;
            max-width: 100% !important;
            box-sizing: border-box !important;
        }
    }

    @media (max-width: 430px) {
        #wrapper {
            margin-top: 68px;
        }
        .sidebar-list-group-item {
            font-size: 13px !important;
            padding: 11px 12px !important;
        }
        #page-content-wrapper {
            padding: 12px 10px !important;
        }
    }
</style>

<!-- Sidebar -->
<div id="sidebar-wrapper">
    <button type="button" class="sidebar-mobile-toggle" id="sidebarMobileToggle" aria-expanded="false" aria-controls="sidebarNavList">
        <span><i class="bi bi-list me-2"></i> Menu</span>
        <i class="bi bi-chevron-down" id="sidebarToggleIcon"></i>
    </button>
    <div class="list-group list-group-flush mt-1" id="sidebarNavList">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/users/dashboard') ? 'active' : ''}">
            <i class="bi bi-house-door"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/chat/users" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/chat/users') ? 'active' : ''}">
            <i class="bi bi-chat-dots"></i> Chat
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/creator-hub') ? 'active' : ''}">
            <i class="bi bi-camera-reels"></i> Creator Hub
        </a>
        <c:if test="${isWorker}">
            <a href="${pageContext.request.contextPath}/marketplace/worker-bookings" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/worker-bookings') ? 'active' : ''}">
                <i class="bi bi-briefcase-fill"></i> Job Bookings
            </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/sos/dashboard" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/sos') ? 'active' : ''}">
            <i class="bi bi-exclamation-triangle"></i> SOS Emergency
        </a>
        <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/users/profile') ? 'active' : ''}">
            <i class="bi bi-person-badge"></i> Your Profile
        </a>
        <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/centres') ? 'active' : ''}">
            <i class="bi bi-shield-check"></i> Martial Arts Centres
        </a>
        <a href="${pageContext.request.contextPath}/video/allVideos" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/video/allVideos') ? 'active' : ''}">
            <i class="bi bi-play-circle"></i> View Videos
        </a>

        <a href="${pageContext.request.contextPath}/index/templates" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/templates') ? 'active' : ''}">
            <i class="bi bi-stars"></i> Glow Space
        </a>

        <a href="${pageContext.request.contextPath}/video/reels" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/reels') ? 'active' : ''}">
            <i class="bi bi-camera-video"></i> Reels
        </a>
        <a href="${pageContext.request.contextPath}/users/wallet" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/wallet') ? 'active' : ''}">
            <i class="bi bi-wallet2"></i> My Wallet
        </a>
        <a href="${pageContext.request.contextPath}/buddy" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/buddy') ? 'active' : ''}">
            <i class="bi bi-person-walking"></i> Buddy Mode
        </a>
        <a href="${pageContext.request.contextPath}/doctors/list" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/doctors') ? 'active' : ''}">
            <i class="bi bi-heart-pulse"></i> Women Doctors
        </a>
        <a href="${pageContext.request.contextPath}/marketplace" class="sidebar-list-group-item ${fn:contains(requestScope['javax.servlet.forward.request_uri'], '/marketplace') && (empty requestScope['javax.servlet.forward.query_string'] || !fn:contains(requestScope['javax.servlet.forward.query_string'], 'category=')) && !fn:contains(requestScope['javax.servlet.forward.request_uri'], '/marketplace/earn') ? 'active' : ''}">
            <i class="bi bi-shop"></i> Women Marketplace
        </a>
        <a href="${pageContext.request.contextPath}/financial-literacy" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/financial-literacy') ? 'active' : ''}">
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
        <a href="${pageContext.request.contextPath}/fitness" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/fitness') ? 'active' : ''}">
            <i class="bi bi-activity"></i> Fitness & Wellness
        </a>
        <a href="${pageContext.request.contextPath}/women-events" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/women-events') ? 'active' : ''}">
            <i class="bi bi-calendar-event"></i> Women Events
        </a>
        <a href="${pageContext.request.contextPath}/marketplace/earn" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/marketplace/earn') ? 'active' : ''}">
            <i class="bi bi-briefcase-fill"></i> Women Jobs
        </a>
        <a href="${pageContext.request.contextPath}/women-products" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/women-products') ? 'active' : ''}">
            <i class="bi bi-bag-heart"></i> Women Products
        </a>
        <a href="${pageContext.request.contextPath}/journey" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/journey') ? 'active' : ''}">
            <i class="bi bi-pin-map"></i> Journey Safety Tracker
        </a>
        <a href="${pageContext.request.contextPath}/reminders" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/reminders') ? 'active' : ''}">
            <i class="bi bi-alarm"></i> Routine Reminders
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-list-group-item sidebar-logout-item">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var sidebar = document.getElementById("sidebar-wrapper");
        var toggleBtn = document.getElementById("sidebarMobileToggle");
        var toggleIcon = document.getElementById("sidebarToggleIcon");

        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function() {
                var isOpen = sidebar.classList.toggle("sidebar-open");
                toggleBtn.setAttribute("aria-expanded", isOpen ? "true" : "false");
                if (toggleIcon) {
                    toggleIcon.classList.toggle("bi-chevron-down", !isOpen);
                    toggleIcon.classList.toggle("bi-chevron-up", isOpen);
                }
            });
        }

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
