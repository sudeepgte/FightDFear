<%@ page language="java" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<aside class="sidebar">

    <!-- MOBILE HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3 d-lg-none">

        <div class="brand mb-0">
            <div class="brand-title">Fight D Fear Admin</div>
            <div class="brand-sub">Admin Portal</div>
        </div>

        <button type="button"
                class="btn-close"
                id="closeSidebar"
                aria-label="Close">
        </button>

    </div>

    <!-- DESKTOP HEADER -->
    <div class="brand d-none d-lg-block">
        <div class="brand-title">Fight D Fear Admin</div>
        <div class="brand-sub">Admin Portal</div>
    </div>

    <!-- DASHBOARD -->
    <div class="sectionTitle">
        Dashboard
    </div>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'adminDashboard') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/adminDashboard">

        <i class="fas fa-th-large"></i>
        Dashboard

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

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-creators') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-creators">
        <i class="fas fa-user-check"></i>
        Creator Approvals
        <c:if test="${side_pendingCreators > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">${side_pendingCreators}</span>
        </c:if>
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
        Investment Platform


        <c:if test="${side_pendingProposals > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingProposals}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-event-hosts') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-event-hosts">

        <i class="fas fa-calendar-check"></i>
        Event Organizers

        <c:if test="${side_pendingEventHosts > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingEventHosts}
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

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'salons') || fn:contains(pageContext.request.requestURI,'stylists') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/salons">

        <i class="fas fa-spa"></i>
        Beauty and Wellness

        <c:if test="${(side_pendingSalons + side_pendingStylists) > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingSalons + side_pendingStylists}
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

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-trainers') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-trainers">

        <i class="fas fa-running text-success"></i>
        Fitness Trainers

        <c:if test="${side_pendingTrainers > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingTrainers}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'job-applications') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/job-applications">

        <i class="fas fa-briefcase"></i>
        Women Jobs

        <c:if test="${side_pendingJobApplications > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">
                ${side_pendingJobApplications}
            </span>
        </c:if>

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-providers') && empty param.category ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-providers">

        <i class="fas fa-store"></i>
        Service Partners

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'WOMEN_PRODUCTS') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-providers?category=WOMEN_PRODUCTS">

        <i class="fas fa-shopping-bag"></i>
        Women Products (legacy)

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

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'pending-delivery-partners') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/pending-delivery-partners">
        <i class="fas fa-motorcycle"></i>
        Delivery Partners
        <c:if test="${side_pendingDeliveryPartners > 0}">
            <span class="badge rounded-pill bg-danger ms-auto">${side_pendingDeliveryPartners}</span>
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
        Financial Educator

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-video') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-video">

        <i class="fas fa-plus-circle"></i>
        Add Recorded Video

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-live-session') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-live-session">

        <i class="fas fa-video"></i>
        Add Live Virtual Session

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'add-workshop') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/add-workshop">

        <i class="fas fa-calendar-check"></i>
        Add Offline Workshop

    </a>

    <a class="navlink ${fn:contains(pageContext.request.requestURI,'registrations') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/financial-literacy/admin/registrations">

        <i class="fas fa-users"></i>
        View Registrations

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
       LIGHT ADMIN SIDEBAR — reference portal style
       ======================================================== */
    :root {
        --admin-accent: #F43F5E;
        --admin-accent-soft: #FFF1F2;
        --admin-text: #0F172A;
        --admin-muted: #64748B;
        --admin-bg: #F8FAFC;
        --admin-card: #FFFFFF;
        --admin-border: #E2E8F0;
        --sidebar-w: 272px;
    }

    body {
        background: var(--admin-bg) !important;
        color: var(--admin-text) !important;
    }

    .topbar {
        background: var(--admin-card) !important;
        border-bottom: 1px solid var(--admin-border) !important;
        height: 64px !important;
        display: flex !important;
        align-items: center !important;
        box-shadow: none !important;
        color: var(--admin-text) !important;
    }

    .topbar .title { color: var(--admin-text) !important; font-weight: 700 !important; }
    .topbar .btn-logout, .topbar .btn-light {
        border-radius: 10px !important;
        background: var(--admin-accent-soft) !important;
        border: 1px solid #FECDD3 !important;
        color: var(--admin-accent) !important;
        font-weight: 600 !important;
        padding: 6px 14px !important;
    }

    .layout {
        display: flex !important;
        min-height: calc(100vh - 64px) !important;
    }

    .sidebar {
        width: var(--sidebar-w) !important;
        background: #FFFFFF !important;
        border-right: 1px solid var(--admin-border) !important;
        position: sticky !important;
        top: 0 !important;
        height: 100vh !important;
        padding: 18px 12px 24px !important;
        overflow-y: auto !important;
        flex-shrink: 0 !important;
        z-index: 1000 !important;
        transition: all 0.3s ease !important;
        display: flex !important;
        flex-direction: column !important;
        box-shadow: none !important;
    }

    .sidebar .brand {
        padding: 8px 12px 16px !important;
        border-bottom: 1px solid var(--admin-border) !important;
        margin-bottom: 10px !important;
        text-transform: none !important;
        letter-spacing: 0 !important;
        background: none !important;
        -webkit-text-fill-color: unset !important;
    }
    .sidebar .brand-title {
        font-size: 1rem !important;
        font-weight: 800 !important;
        color: var(--admin-text) !important;
        line-height: 1.25 !important;
    }
    .sidebar .brand-sub {
        font-size: 0.75rem !important;
        font-weight: 500 !important;
        color: var(--admin-muted) !important;
        margin-top: 2px !important;
    }

    .sidebar .sectionTitle {
        font-size: 0.68rem !important;
        font-weight: 700 !important;
        color: #94A3B8 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.06em !important;
        margin: 16px 12px 6px !important;
    }

    .sidebar a.navlink {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        padding: 9px 12px !important;
        border-radius: 10px !important;
        color: #334155 !important;
        text-decoration: none !important;
        font-weight: 500 !important;
        font-size: 0.875rem !important;
        transition: all 0.2s !important;
        margin-bottom: 2px !important;
    }

    .sidebar a.navlink i {
        width: 18px !important;
        text-align: center !important;
        color: #64748B !important;
        font-size: 0.92rem !important;
        transition: none !important;
        transform: none !important;
    }

    .sidebar a.navlink:hover {
        background: #F8FAFC !important;
        color: var(--admin-text) !important;
        padding-left: 12px !important;
    }
    .sidebar a.navlink:hover i { color: var(--admin-accent) !important; transform: none !important; }

    .sidebar a.navlink.active {
        background: var(--admin-accent-soft) !important;
        color: var(--admin-accent) !important;
        font-weight: 700 !important;
        box-shadow: none !important;
    }
    .sidebar a.navlink.active i { color: var(--admin-accent) !important; }

    .sidebar .badge {
        font-size: 0.68rem !important;
        font-weight: 700 !important;
        padding: 3px 7px !important;
    }

    .main {
        padding: 0 !important;
        background: var(--admin-bg) !important;
        min-width: 0 !important;
        flex: 1 !important;
    }

    .sidebar-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(15, 23, 42, 0.45);
        backdrop-filter: blur(2px);
        z-index: 1500;
    }
    .sidebar-overlay.active { display: block !important; }

    .mobile-toggle {
        background: none !important;
        border: none !important;
        color: var(--admin-text) !important;
        font-size: 1.25rem !important;
        cursor: pointer !important;
        padding: 6px 10px !important;
        margin-right: 8px !important;
        display: none !important;
    }

    @media (max-width: 992px) {
        .mobile-toggle { display: block !important; }
        .sidebar {
            position: fixed !important;
            left: -290px !important;
            top: 0 !important;
            bottom: 0 !important;
            height: 100vh !important;
            width: 280px !important;
            z-index: 2000 !important;
            background: #fff !important;
            box-shadow: 10px 0 30px rgba(0,0,0,0.12) !important;
            transition: left 0.3s ease !important;
        }
        .sidebar.active { left: 0 !important; }
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
