<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="sid" value="${not empty salonId ? salonId : (not empty salon ? salon.id : (not empty sessionScope.loggedSalon ? sessionScope.loggedSalon.id : ''))}" />

<style>
    :root {
        --sidebar-width: 280px;
        --primary: #F43F5E;
        --primary-light: #FFE4E6;
        --navy: #1E1B4B;
        --text-gray: #64748B;
        --bg-page: #F8FAFC;
        --card-bg: #FFFFFF;
        --border-color: #E2E8F0;
    }

    .sidebar {
        background: var(--card-bg) !important;
        display: flex;
        flex-direction: column;
        border-right: 1px solid var(--border-color);
        padding: 0 !important;
    }

    .sidebar-brand-wrapper {
        padding: 24px;
        border-bottom: 1px solid var(--border-color);
        margin-bottom: 20px;
    }

    .sidebar-brand {
        font-family: 'Montserrat', sans-serif;
        font-weight: 800;
        font-size: 1.15rem;
        color: var(--navy) !important;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .sidebar-brand i {
        color: var(--primary);
        font-size: 1.5rem;
    }

    .sidebar-brand-wrapper .subtitle {
        font-size: 0.72rem;
        color: var(--text-gray);
        margin-top: 4px;
        font-weight: 500;
        letter-spacing: 0.5px;
    }

    .nav-container {
        flex: 1;
        padding: 0 16px;
        overflow-y: auto;
    }

    .nav-link-custom {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 11px 16px;
        color: var(--text-gray) !important;
        text-decoration: none;
        border-radius: 12px;
        margin-bottom: 4px;
        transition: all 0.2s ease;
        font-weight: 600;
        font-size: 0.88rem;
    }

    .nav-link-custom:hover {
        background: var(--bg-page);
        color: var(--navy) !important;
        transform: translateX(4px);
    }

    .nav-link-custom.active {
        background: var(--primary-light) !important;
        color: var(--primary) !important;
        font-weight: 700;
        border-left: 4px solid var(--primary);
        padding-left: 12px;
    }

    .nav-link-custom i {
        font-size: 1.15rem;
    }

    @media (min-width: 992px) {
        .sidebar {
            width: var(--sidebar-width) !important;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1000;
            box-shadow: 2px 0 15px rgba(0,0,0,0.03);
        }
    }
</style>

<div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
    <div class="sidebar-brand-wrapper">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;">
            <span>${not empty salon.name ? salon.name : (not empty sessionScope.loggedSalon.name ? sessionScope.loggedSalon.name : 'Priya Beauty & Wellness')}</span>
        </a>
        <div class="subtitle">Beauty &bull; Wellness</div>
    </div>

    <div class="nav-container">
        <nav class="nav flex-column">
            <a class="nav-link-custom ${param.activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/salons/dashboard">
                <i class="bi bi-grid-1x2"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'appointments' ? 'active' : ''}" href="${pageContext.request.contextPath}/booking/list" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-calendar-check"></i>
                <span>Appointments</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'calendar' ? 'active' : ''}" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-calendar3"></i>
                <span>Calendar</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'services' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/viewServices" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-magic"></i>
                <span>Services</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'staff' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/stylists" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-people"></i>
                <span>Staff / Stylists</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'clients' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/clients" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-people-fill"></i>
                <span>Clients</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'packages' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/packages" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-box-seam"></i>
                <span>Packages &amp; Memberships</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'offers' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sid}" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-percent"></i>
                <span>Offers &amp; Discounts</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'billing' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/billing" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-receipt"></i>
                <span>Billing &amp; Invoices</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/payments" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-credit-card-2-front"></i>
                <span>Payments &amp; Payouts</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/inventory" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-box"></i>
                <span>Inventory</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/reviews/list" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-star-half"></i>
                <span>Reviews &amp; Feedback</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/analytics" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-bar-chart-line"></i>
                <span>Reports &amp; Analytics</span>
            </a>

            <a class="nav-link-custom ${param.activeNav == 'settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/settings" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-sliders"></i>
                <span>Settings</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'support' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/support" onclick="return checkApproval(event, ${sessionScope.loggedSalon.approved})">
                <i class="bi bi-question-circle"></i>
                <span>Help &amp; Support</span>
            </a>
            <a class="nav-link-custom text-danger mt-3" href="${pageContext.request.contextPath}/salons/logout">
                <i class="bi bi-box-arrow-left"></i>
                <span>Sign Out</span>
            </a>
        </nav>
    </div>
</div>

<script>
    function checkApproval(event, isApproved) {
        if (!isApproved) {
            event.preventDefault();
            alert('Your profile is pending admin approval. You cannot access this feature yet.');
            return false;
        }
        return true;
    }
</script>
