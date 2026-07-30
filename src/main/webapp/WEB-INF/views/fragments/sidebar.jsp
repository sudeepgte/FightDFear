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
    
    /* Curved sidebar */
    #sidebar-wrapper {
        min-width: 260px;
        max-width: 260px;
        background: #1e1b4b; /* var(--primary-purple) */
        color: white;
        transition: all 0.3s ease-in-out;
        z-index: 1000;
        position: fixed;
        top: 80px; 
        bottom: 0;
        overflow-y: auto;
        overflow-x: hidden;
        -webkit-overflow-scrolling: touch;
        padding-bottom: 40px;
        border-top-right-radius: 40px;
        padding-top: 20px;
        box-shadow: 10px 0 20px rgba(0,0,0,0.05);
    }

    #sidebar-wrapper .list-group {
        padding-bottom: 80px;
    }
    
    #sidebar-wrapper::-webkit-scrollbar { width: 4px; }
    #sidebar-wrapper::-webkit-scrollbar-thumb { background-color: #312e81; border-radius: 10px; }
    
    .sidebar-heading {
        padding: 10px 25px 25px;
        font-size: 1.1rem;
        font-weight: 700;
        color: white;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .sidebar-list-group-item {
        background: transparent;
        color: rgba(255, 255, 255, 0.7);
        border: none;
        padding: 12px 25px;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 15px;
        position: relative;
        text-decoration: none;
    }
    .sidebar-list-group-item i { font-size: 1.1rem; width: 20px; text-align: center; }
    .sidebar-list-group-item:hover, .sidebar-list-group-item.active {
        color: white;
        background: transparent;
    }
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

    #page-content-wrapper {
        flex: 1;
        margin-left: 260px;
        min-width: 0;
        display: flex;
        flex-direction: column;
        padding: 25px 30px;
        background: #f4f6fa !important;
    }
    
    @media (max-width: 768px) {
        #wrapper {
            flex-direction: column !important;
        }
        #sidebar-wrapper {
            min-width: 100% !important;
            max-width: 100% !important;
            position: relative !important;
            top: 0 !important;
            bottom: auto !important;
            border-top-right-radius: 0 !important;
            border-bottom-left-radius: 20px !important;
            border-bottom-right-radius: 20px !important;
            padding: 15px !important;
            height: auto !important;
            box-shadow: none !important;
        }
        #page-content-wrapper {
            margin-left: 0 !important;
            padding: 15px !important;
        }
        .list-group {
            flex-direction: row !important;
            flex-wrap: wrap !important;
            gap: 8px !important;
            margin-top: 10px !important;
        }
        .sidebar-list-group-item {
            padding: 8px 12px !important;
            border-radius: 30px !important;
            background: rgba(255, 255, 255, 0.05) !important;
            font-size: 13px !important;
            display: inline-flex !important;
            white-space: nowrap !important;
        }
        .sidebar-list-group-item::before {
            display: none !important;
        }
        .sidebar-list-group-item:hover, .sidebar-list-group-item.active {
            background: #f43f5e !important;
            color: white !important;
        }
    }
</style>

<!-- Sidebar -->
<div id="sidebar-wrapper">
    <div class="sidebar-heading">
        <i class="bi bi-layers-half"></i> Rubick <span style="font-weight: 400; font-size: 0.9rem;">FightDFire</span>
    </div>
    <div class="list-group list-group-flush mt-3">
        <a href="${pageContext.request.contextPath}/users/dashboard" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/users/dashboard') ? 'active' : ''}">
            <i class="bi bi-house-door"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/creator-hub" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/creator-hub') ? 'active' : ''}">
            <i class="bi bi-camera-reels"></i> Creator Hub
        </a>
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
        <a href="${pageContext.request.contextPath}/marketplace" class="sidebar-list-group-item ${fn:contains(requestScope['javax.servlet.forward.request_uri'], '/marketplace') && (empty requestScope['javax.servlet.forward.query_string'] || !fn:contains(requestScope['javax.servlet.forward.query_string'], 'category=')) ? 'active' : ''}">
            <i class="bi bi-shop"></i> Women Marketplace
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
        <a href="${pageContext.request.contextPath}/women-products" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/women-products') ? 'active' : ''}">
            <i class="bi bi-bag-heart"></i> Women Products
        </a>
        <a href="${pageContext.request.contextPath}/journey" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/journey') ? 'active' : ''}">
            <i class="bi bi-pin-map"></i> Journey Safety Tracker
        </a>
        <a href="${pageContext.request.contextPath}/reminders" class="sidebar-list-group-item ${requestScope['javax.servlet.forward.request_uri'].contains('/reminders') ? 'active' : ''}">
            <i class="bi bi-alarm"></i> Routine Reminders
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-list-group-item" style="color: #f43f5e; margin-top: 15px; border-top: 1px solid rgba(255,255,255,0.1);">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var content = document.getElementById("page-content-wrapper");
        if(content && !document.getElementById("global-back-btn") && content.dataset.skipGlobalBack !== "true") {
            var backBtn = document.createElement("div");
            backBtn.id = "global-back-btn";
            backBtn.style.marginBottom = "20px";
            backBtn.innerHTML = '<a href="javascript:history.back()" class="btn btn-sm" style="background: white; border: 1px solid #ddd; color: #1e1b4b; font-weight: 600; padding: 6px 15px; border-radius: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);"><i class="bi bi-arrow-left"></i> Go Back</a>';
            content.insertBefore(backBtn, content.firstChild);
        }
    });
</script>
