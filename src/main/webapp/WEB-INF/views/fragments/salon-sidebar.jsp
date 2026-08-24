<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="sid" value="${not empty salonId ? salonId : (not empty salon ? salon.id : (not empty sessionScope.loggedSalon ? sessionScope.loggedSalon.id : ''))}" />

<style>
    :root {
        --sidebar-width: 280px;
        --fdf-burgundy: #2d0b20;
        --fdf-burgundy-dark: #1f0615;
        --fdf-pink: #db2777;
        --fdf-pink-light: #fbcfe8;
        --fdf-rose: #f43f5e;
        --fdf-text-dark: #1e1b4b;
        --fdf-text-muted: #64748b;
        --fdf-border: #f1e9f0;
    }

    .sidebar {
        background: linear-gradient(180deg, var(--fdf-burgundy) 0%, var(--fdf-burgundy-dark) 100%) !important;
        color: white;
        display: flex;
        flex-direction: column;
        border-right: 1px solid rgba(255, 255, 255, 0.05);
        padding: 0 !important;
    }

    .sidebar-brand-wrapper {
        padding: 24px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        margin-bottom: 20px;
    }

    .sidebar-brand {
        font-family: 'Montserrat', sans-serif;
        font-weight: 800;
        font-size: 1.15rem;
        color: white !important;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .sidebar-brand i {
        color: var(--fdf-pink);
        font-size: 1.5rem;
    }

    .sidebar-brand-wrapper .subtitle {
        font-size: 0.72rem;
        color: rgba(255,255,255,0.4);
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
        color: rgba(255,255,255,0.65) !important;
        text-decoration: none;
        border-radius: 12px;
        margin-bottom: 4px;
        transition: all 0.2s ease;
        font-weight: 500;
        font-size: 0.88rem;
    }

    .nav-link-custom:hover {
        background: rgba(255,255,255,0.05);
        color: white !important;
        transform: translateX(4px);
    }

    .nav-link-custom.active {
        background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%) !important;
        color: white !important;
        box-shadow: 0 4px 15px rgba(219, 39, 119, 0.25);
        font-weight: 600;
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
            box-shadow: 10px 0 35px rgba(0,0,0,0.05);
        }
    }
</style>

<div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
    <div class="sidebar-brand-wrapper">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
            <i class="bi bi-gender-female"></i>
            <span>${not empty salon.name ? salon.name : (not empty sessionScope.loggedSalon.name ? sessionScope.loggedSalon.name : 'Priya Beauty & Wellness')}</span>
        </a>
        <div class="subtitle">Women's Salon &bull; Beauty &bull; Wellness &bull; Hair Styling</div>
    </div>

    <div class="nav-container">
        <nav class="nav flex-column">
            <a class="nav-link-custom ${param.activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/salons/dashboard">
                <i class="bi bi-grid-1x2"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/salons/profile">
                <i class="bi bi-shop"></i>
                <span>Salon Profile</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'appointments' ? 'active' : ''}" href="${pageContext.request.contextPath}/booking/list">
                <i class="bi bi-calendar-check"></i>
                <span>Appointments</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'calendar' ? 'active' : ''}" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal">
                <i class="bi bi-calendar3"></i>
                <span>Calendar</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'services' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Services</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'staff' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/stylists">
                <i class="bi bi-people"></i>
                <span>Staff / Stylists</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'clients' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/clients">
                <i class="bi bi-people-fill"></i>
                <span>Clients</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'packages' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/packages">
                <i class="bi bi-box-seam"></i>
                <span>Packages &amp; Memberships</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'offers' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sid}">
                <i class="bi bi-percent"></i>
                <span>Offers &amp; Discounts</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'billing' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/billing">
                <i class="bi bi-receipt"></i>
                <span>Billing &amp; Invoices</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/payments">
                <i class="bi bi-credit-card-2-front"></i>
                <span>Payments &amp; Payouts</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/inventory">
                <i class="bi bi-box"></i>
                <span>Inventory</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/reviews/list">
                <i class="bi bi-star-half"></i>
                <span>Reviews &amp; Feedback</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/analytics">
                <i class="bi bi-bar-chart-line"></i>
                <span>Reports &amp; Analytics</span>
            </a>

            <a class="nav-link-custom ${param.activeNav == 'settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/settings">
                <i class="bi bi-sliders"></i>
                <span>Settings</span>
            </a>
            <a class="nav-link-custom ${param.activeNav == 'support' ? 'active' : ''}" href="${pageContext.request.contextPath}/salon/support">
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
