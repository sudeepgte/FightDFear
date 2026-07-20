<%@ page language="java" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<aside class="sidebar">

    <!-- MOBILE HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3 d-lg-none">

        <div class="brand mb-0">
            Admin Menu
        </div>

        <button type="button"
                class="btn-close"
                id="closeSidebar"
                aria-label="Close">
        </button>

    </div>

    <!-- DESKTOP HEADER -->
    <div class="brand d-none d-lg-block">
        Admin Menu
    </div>

    <!-- DASHBOARD -->
    <div class="sectionTitle">
        Dashboard
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'adminDashboard') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/adminDashboard">

        <i class="fas fa-home"></i>
        Home

    </a>



    <a class="navlink ${fn:contains(pageContext.request.requestURI,'buddy-management') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/buddy-management">

        <i class="fas fa-user-friends"></i>
        Buddy Oversight

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'safety-points') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/safety-points">

        <i class="fas fa-shield-alt"></i>
        Safety Verification

    </a>

    <!-- COMMUNICATION -->
    <div class="sectionTitle">
        Communication
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'contact-messages') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/contact-messages">

        <i class="fas fa-envelope"></i>
        Contact Messages

        <c:if test="${side_unreadContactMessages > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_unreadContactMessages}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'broadcast') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/broadcast">

        <i class="fas fa-bullhorn"></i>
        Broadcast Center

    </a>

    <!-- ANALYTICS -->
    <div class="sectionTitle">
        Analytics
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'reports') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/reports">

        <i class="fas fa-chart-bar"></i>
        Reports & Exports

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'investment-revenue') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/investment-revenue">

        <i class="fas fa-dollar-sign"></i>
        Platform Revenue

    </a>

    <!-- MODERATION -->
    <div class="sectionTitle">
        Moderation
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'sos') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/sos">

        <i class="fas fa-broadcast-tower" style="color:#ff3b3b;"></i>
        SOS Monitoring

        <span class="badge rounded-pill bg-danger ms-auto"
              id="sosSideBadge"
              style="display:none;">

            LIVE

        </span>

    </a>



    <a class="navlink ${fn:contains(pageContext.request.requestURI,'reported-videos') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/reported-videos">

        <i class="fas fa-flag"></i>
        Reported Videos

    </a>

    <a class="navlink"
       href="${pageContext.request.contextPath}/admin/adminDashboard#creatorHubTabs">

        <i class="fas fa-video text-warning"></i>
        Creator Hub Oversight

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'questions') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/qna/admin/questions">

        <i class="fas fa-question-circle"></i>
        Q&amp;A Panel

    </a>

    <!-- APPROVALS -->
    <div class="sectionTitle">
        Approvals
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-proposals') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-proposals">

        <i class="fas fa-hand-holding-usd"></i>
        Proposal Verifications

        <c:if test="${side_pendingProposals > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingProposals}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'martialManagement') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/martialManagement">

        <i class="fas fa-dumbbell"></i>
        Martial Arts Centres

        <c:if test="${side_pendingCentres > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingCentres}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-suggestions') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-suggestions">

        <i class="fas fa-users"></i>
        Volunteer Suggestions

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'users') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/users">

        <i class="fas fa-users-cog"></i>
        User Management

        <c:if test="${side_pendingUsers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingUsers}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'salons') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/salons">

        <i class="fas fa-cut"></i>
        Salon Verification

        <c:if test="${side_pendingSalons > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingSalons}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'stylists') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/stylists">

        <i class="fas fa-user-tie"></i>
        Stylist Verification

        <c:if test="${side_pendingStylists > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingStylists}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-doctors') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-doctors">

        <i class="fas fa-user-md"></i>
        Doctor Verification

        <c:if test="${side_pendingDoctors > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingDoctors}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-providers') && param.category == 'WOMEN_LAWYER' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_LAWYER">

        <i class="fas fa-gavel"></i>
        Women Lawyer

        <c:if test="${side_pendingLawyers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingLawyers}
            </span>
        </c:if>

    </a>

    <a class="navlink"
       href="${pageContext.request.contextPath}/admin/adminDashboard#fitnessOversightTabs">

        <i class="fas fa-running text-success"></i>
        Fitness &amp; Wellness

        <c:if test="${side_pendingTrainers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingTrainers}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-providers') && empty param.category ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-providers">

        <i class="fas fa-store"></i>
        Marketplace Providers

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'WOMEN_PRODUCTS') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_PRODUCTS">

        <i class="fas fa-shopping-bag"></i>
        Women Services

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-sellers') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-sellers">

        <i class="fas fa-shopping-cart"></i>
        Product Sellers

        <c:if test="${side_pendingSellers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingSellers}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'women-product-orders') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/women-product-orders">

        <i class="fas fa-box"></i>
        Product Orders

    </a>


    <!-- FINANCIAL LITERACY -->
    <div class="sectionTitle">
        Financial Literacy
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'financial-literacy/admin') && !fn:contains(pageContext.request.requestURI,'add-') && !fn:contains(pageContext.request.requestURI,'registrations') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin">

        <i class="fas fa-book"></i>
        Home

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-video') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-video">

        <i class="fas fa-plus-circle"></i>
        Add Video

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-live-session') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session">

        <i class="fas fa-video"></i>
        Add Live Session

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-workshop') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop">

        <i class="fas fa-calendar-check"></i>
        Add Workshop

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'registrations') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/registrations">

        <i class="fas fa-users"></i>
        View Registrations

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'job-applications') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/job-applications">

        <i class="fas fa-briefcase"></i>
        Job Applications


    </a>

    <!-- CONTENT -->
    <div class="sectionTitle">
        Content
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'videoManagement') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/video/videoManagement">

        <i class="fas fa-video"></i>
        Video Library

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'videos') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/videos">

        <i class="fas fa-film"></i>
        Reels Rewards

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'user-reels') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/user-reels">

        <i class="fas fa-mobile-alt"></i>
        User Reels Management

    </a>

    <!-- ACCOUNT -->
    <div class="sectionTitle">
        Account
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'profile') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/profile/${admin.id}">

        <i class="fas fa-user"></i>
        Profile

    </a>

    <a class="navlink"
       href="${pageContext.request.contextPath}/admin/logout">

        <i class="fas fa-sign-out-alt"></i>
        Logout

    </a>

</aside>

<style>
    /* ========================================================
       PREMIUM ROSE-NAVY SIDEBAR & LAYOUT THEMING
       ======================================================== */
    :root {
        --admin-navy: #1e1b4b;
        --admin-navy-light: #312e81;
        --admin-rose: #f43f5e;
        --admin-rose-hover: #e11d48;
        --admin-bg: #f8fafc;
        --admin-border: rgba(255, 255, 255, 0.08);
    }
    
    body {
        background: var(--admin-bg) !important;
        color: #0f172a !important;
    }
    
    .topbar {
        background: var(--admin-navy) !important;
        border-bottom: 1px solid var(--admin-border) !important;
        height: 58px !important;
        display: flex !important;
        align-items: center !important;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08) !important;
    }
    
    .topbar .title {
        color: #fff !important;
        font-weight: 700 !important;
    }
    
    .topbar .btn-logout, .topbar .btn-light {
        border-radius: 20px !important;
        background: rgba(255,255,255,0.1) !important;
        border: 1px solid rgba(255,255,255,0.2) !important;
        color: #fff !important;
        font-weight: 600 !important;
        padding: 5px 15px !important;
        transition: all 0.3s !important;
    }
    
    .topbar .btn-logout:hover, .topbar .btn-light:hover {
        background: var(--admin-rose) !important;
        border-color: var(--admin-rose) !important;
    }

    .layout {
        display: flex !important;
        min-height: calc(100vh - 58px) !important;
    }

    .sidebar {
        width: 272px !important;
        background: var(--admin-navy) !important;
        border-right: 1px solid var(--admin-border) !important;
        position: sticky !important;
        top: 58px !important;
        height: calc(100vh - 58px) !important;
        padding: 20px 14px !important;
        overflow-y: auto !important;
        flex-shrink: 0 !important;
        z-index: 1000 !important;
        transition: all 0.3s ease !important;
        display: flex !important;
        flex-direction: column !important;
        box-shadow: 4px 0 15px rgba(0, 0, 0, 0.05) !important;
    }
    
    .sidebar .brand {
        font-size: 1.1rem !important;
        font-weight: 800 !important;
        color: #fff !important;
        background: linear-gradient(135deg, #fb7185, var(--admin-rose)) !important;
        -webkit-background-clip: text !important;
        -webkit-text-fill-color: transparent !important;
        background-clip: text !important;
        padding: 10px 15px !important;
        border-bottom: 1px solid var(--admin-border) !important;
        margin-bottom: 15px !important;
    }
    
    .sidebar .sectionTitle {
        font-size: 0.72rem !important;
        font-weight: 700 !important;
        color: #94a3b8 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.06em !important;
        margin: 18px 15px 8px !important;
    }
    
    .sidebar a.navlink {
        display: flex !important;
        align-items: center !important;
        gap: 12px !important;
        padding: 10px 15px !important;
        border-radius: 10px !important;
        color: #cbd5e1 !important;
        text-decoration: none !important;
        font-weight: 500 !important;
        font-size: 0.9rem !important;
        transition: all 0.25s !important;
        margin-bottom: 2px !important;
    }
    
    .sidebar a.navlink i {
        width: 20px !important;
        text-align: center !important;
        color: var(--admin-rose) !important;
        font-size: 1rem !important;
        transition: transform 0.25s !important;
    }
    
    .sidebar a.navlink:hover {
        background: rgba(244, 63, 94, 0.08) !important;
        color: #fff !important;
        padding-left: 20px !important;
    }
    
    .sidebar a.navlink:hover i {
        transform: scale(1.1) !important;
    }
    
    .sidebar a.navlink.active {
        background: var(--admin-rose) !important;
        color: #fff !important;
        font-weight: 600 !important;
        box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3) !important;
    }
    
    .sidebar a.navlink.active i {
        color: #fff !important;
    }
    
    .main {
        padding: 24px 20px 40px !important;
        background: var(--admin-bg) !important;
    }
    
    .sidebar-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(15, 23, 42, 0.6);
        backdrop-filter: blur(4px);
        z-index: 1500;
        transition: all 0.3s ease;
    }
    
    .sidebar-overlay.active {
        display: block !important;
    }
    
    .mobile-toggle {
        background: none !important;
        border: none !important;
        color: #fff !important;
        font-size: 1.3rem !important;
        cursor: pointer !important;
        padding: 6px 12px !important;
        margin-right: 10px !important;
        display: none !important;
        transition: transform 0.2s !important;
    }
    .mobile-toggle:hover {
        transform: scale(1.1) !important;
    }

    /* Responsive Queries */
    @media (max-width: 992px) {
        .mobile-toggle {
            display: block !important;
        }
        .sidebar {
            position: fixed !important;
            left: -280px !important;
            top: 0 !important;
            bottom: 0 !important;
            height: 100vh !important;
            width: 280px !important;
            z-index: 2000 !important;
            background: var(--admin-navy) !important;
            box-shadow: 10px 0 30px rgba(0, 0, 0, 0.25) !important;
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
        }
        .sidebar.active {
            left: 0 !important;
        }
    }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
      // 1. Auto inject hamburger button if not present
      const topbar = document.querySelector('.topbar');
      if (topbar) {
          let toggleBtn = topbar.querySelector('.mobile-toggle') || document.getElementById('sidebarToggle');
          if (!toggleBtn) {
              toggleBtn = document.createElement('button');
              toggleBtn.className = 'mobile-toggle';
              toggleBtn.id = 'sidebarToggle';
              toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
              
              // Prepend inside the first container or wrap in topbar
              const wrap = topbar.querySelector('.wrap') || topbar.querySelector('.container') || topbar;
              if (wrap) {
                  wrap.insertBefore(toggleBtn, wrap.firstChild);
              }
          }
      }
      
      // 2. Auto inject sidebar overlay if not present
      let overlay = document.querySelector('.sidebar-overlay') || document.getElementById('sidebarOverlay');
      if (!overlay) {
          overlay = document.createElement('div');
          overlay.className = 'sidebar-overlay';
          overlay.id = 'sidebarOverlay';
          document.body.appendChild(overlay);
      }
      
      // 3. Connect click events
      const toggle = document.querySelector('.mobile-toggle') || document.getElementById('sidebarToggle');
      const sidebar = document.querySelector('.sidebar');
      const closeBtn = document.getElementById('closeSidebar');
      
      if (toggle && sidebar && overlay) {
          toggle.addEventListener('click', function(e) {
              e.preventDefault();
              sidebar.classList.add('active');
              overlay.classList.add('active');
          });
          
          overlay.addEventListener('click', function() {
              sidebar.classList.remove('active');
              overlay.classList.remove('active');
          });
          
          if (closeBtn) {
              closeBtn.addEventListener('click', function() {
                  sidebar.classList.remove('active');
                  overlay.classList.remove('active');
              });
          }
      }
  });
</script>
