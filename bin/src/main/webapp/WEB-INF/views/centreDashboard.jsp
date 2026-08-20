<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Centre Management Hub — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --navy-light: #2D2960;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --warning: #C2410C;
            --warning-bg: #FFF7ED;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-page);
            color: var(--navy);
            min-height: 100vh;
            display: flex;
        }

        /* Sidebar Navigation */
        .sidebar {
            width: 260px;
            background: var(--navy);
            color: #FFFFFF;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            position: sticky;
            top: 0;
            height: 100vh;
            z-index: 40;
            transition: all 0.3s ease;
        }

        .sidebar-brand {
            padding: 22px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.15rem;
            font-weight: 800;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            text-decoration: none;
            color: #FFFFFF;
        }

        .sidebar-brand i {
            color: var(--primary);
            font-size: 1.4rem;
        }

        .sidebar-nav {
            flex: 1;
            padding: 16px 12px;
            display: flex;
            flex-direction: column;
            gap: 4px;
            overflow-y: auto;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            color: #94A3B8;
            text-decoration: none;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
        }

        .nav-item i {
            font-size: 1.15rem;
            width: 20px;
            text-align: center;
        }

        .nav-item:hover {
            color: #FFFFFF;
            background: rgba(255,255,255,0.06);
        }

        .nav-item.active {
            color: #FFFFFF;
            background: var(--primary);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.3);
        }

        .sidebar-footer {
            padding: 16px 14px;
            border-top: 1px solid rgba(255,255,255,0.08);
        }

        .btn-logout {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            color: #EF4444;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            border-radius: 10px;
            transition: background 0.2s;
        }

        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.1);
        }

        /* Main Content */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            overflow-y: auto;
        }

        /* Top Header */
        .topbar {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 30;
        }

        .topbar-greeting h1 {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--navy);
        }

        .topbar-greeting p {
            font-size: 0.85rem;
            color: var(--text-gray);
            font-weight: 500;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-quick-add {
            padding: 9px 18px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            box-shadow: 0 2px 10px rgba(244, 63, 94, 0.25);
            text-decoration: none;
        }

        .btn-quick-add:hover {
            background: var(--primary-hover);
        }

        .content-container {
            padding: 24px 28px 60px;
            max-width: 1200px;
            width: 100%;
        }

        /* Centre Profile Summary Card Matching Mobile */
        .centre-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 22px 24px;
            margin-bottom: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        .centre-card-left {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .centre-avatar {
            width: 80px;
            height: 80px;
            border-radius: 16px;
            background: var(--rose-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 800;
            overflow: hidden;
            flex-shrink: 0;
        }

        .centre-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .centre-info h2 {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 4px;
        }

        .centre-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.85rem;
            color: var(--text-gray);
            flex-wrap: wrap;
        }

        .pill-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .pill-verified { background: var(--success-bg); color: var(--success); border: 1px solid #BBF7D0; }
        .pill-pending { background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A; }
        .pill-changes { background: var(--warning-bg); color: var(--warning); border: 1px solid #FED7AA; }

        .btn-edit-profile {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-edit-profile:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Profile Completion Warning Card */
        .completion-banner {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 18px 22px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .completion-banner-left {
            flex: 1;
            min-width: 260px;
        }

        .completion-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 0.9rem;
            font-weight: 700;
        }

        .progress-bar-bg {
            height: 8px;
            background: #E2E8F0;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 8px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 4px;
        }

        /* 8 Metric Tiles Grid Matching Mobile */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        @media (max-width: 1024px) {
            .metrics-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .metrics-grid { grid-template-columns: 1fr; }
        }

        .metric-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 18px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .metric-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .metric-icon-wrap {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        .metric-val {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--navy);
        }

        .metric-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-gray);
        }

        /* Tab Content Section */
        .tab-section {
            display: none;
        }

        .tab-section.active {
            display: block;
        }

        /* Tables & Content Panels */
        .content-panel {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 22px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
        }

        .panel-title {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.88rem;
        }

        .data-table th {
            text-align: left;
            padding: 12px 14px;
            background: #F8FAFC;
            color: var(--text-gray);
            font-weight: 600;
            border-bottom: 1px solid var(--border-color);
        }

        .data-table td {
            padding: 14px;
            border-bottom: 1px solid var(--border-color);
            color: var(--navy);
            vertical-align: middle;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .badge-status {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
        }        .badge-active { background: var(--success-bg); color: var(--success); }
        .badge-offline { background: #E2E8F0; color: #475569; }
        .badge-online { background: #DBEAFE; color: #1D4ED8; }

        /* Status Pills */
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        .status-pill-Active { background: #DCFCE7; color: #15803D; border: 1px solid #BBF7D0; }
        .status-pill-Upcoming { background: #FEF3C7; color: #B45309; border: 1px solid #FDE68A; }
        .status-pill-Full { background: #FEE2E2; color: #B91C1C; border: 1px solid #FECACA; }
        .status-pill-Closed { background: #F1F5F9; color: #64748B; border: 1px solid #CBD5E1; }

        /* Programs Disciplines Bar */
        .programs-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            padding: 14px 18px;
            background: #F8FAFC;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            margin-bottom: 20px;
        }
        .discipline-chip {
            padding: 6px 14px;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--navy);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            cursor: pointer;
        }
        .discipline-chip:hover, .discipline-chip.active {
            background: var(--navy);
            color: #FFFFFF;
            border-color: var(--navy);
        }

        /* Batch Cards Grid */
        .batch-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 18px;
            margin-bottom: 20px;
        }
        .batch-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
        }
        .batch-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(30, 27, 75, 0.08);
        }
        .batch-card-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
        }
        .batch-style-badge {
            background: #FFE4E6;
            color: #E11D48;
            font-size: 0.75rem;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 8px;
            display: inline-block;
            margin-bottom: 6px;
        }
        .batch-title {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin: 0;
            line-height: 1.3;
        }
        .batch-meta-row {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.82rem;
            color: var(--text-gray);
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .batch-schedule-box {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 12px;
            margin-bottom: 14px;
            font-size: 0.84rem;
        }
        .batch-schedule-box strong {
            color: var(--navy);
        }
        .batch-pricing-row {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            padding-top: 10px;
            border-top: 1px dashed var(--border-color);
            margin-bottom: 14px;
        }
        .batch-price {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--success);
        }
        .batch-actions-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn-card-action {
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 700;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            text-decoration: none;
        }
        .btn-card-action:hover {
            background: #F1F5F9;
            border-color: #CBD5E1;
        }
        .btn-card-action.primary {
            background: var(--navy);
            color: #FFFFFF;
            border-color: var(--navy);
        }
        .btn-card-action.primary:hover {
            background: #2D2960;
        }
        .btn-card-action.danger {
            color: #DC2626;
            border-color: #FECACA;
        }
        .btn-card-action.danger:hover {
            background: #FEF2F2;
        }

        /* Day Chips Multi-selector */
        .day-chips-wrap {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 6px;
        }
        .day-toggle-chip {
            padding: 8px 14px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            background: #F8FAFC;
            color: var(--text-gray);
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            user-select: none;
        }
        .day-toggle-chip.selected {
            background: var(--navy);
            color: #FFFFFF;
            border-color: var(--navy);
        }

        /* Custom Modal Backdrop */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 13, 38, 0.65);
            backdrop-filter: blur(4px);
            z-index: 1050;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
            overflow-y: auto;
        }
        .modal-overlay.open {
            display: flex;
        }
        .modal-window {
            background: #FFFFFF;
            border-radius: 20px;
            width: 100%;
            max-width: 680px;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            animation: modalFadeUp 0.3s ease-out;
        }
        .modal-window form {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
            overflow: hidden;
            margin: 0;
        }
        @keyframes modalFadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-header-custom {
            padding: 18px 24px;
            background: var(--navy);
            color: #FFFFFF;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }
        .modal-header-custom h3 {
            font-size: 1.15rem;
            font-weight: 800;
            margin: 0;
        }
        .btn-modal-close {
            background: rgba(255,255,255,0.15);
            border: none;
            color: #FFFFFF;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-modal-close:hover {
            background: rgba(255,255,255,0.3);
        }
        .modal-body-custom {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
            min-height: 0;
        }
        .modal-footer-custom {
            padding: 16px 24px;
            border-top: 1px solid var(--border-color);
            background: #F8FAFC;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-shrink: 0;
            position: sticky;
            bottom: 0;
            z-index: 10;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media (max-width: 600px) {
            .form-grid-2 { grid-template-columns: 1fr; }
        }
        .form-group-custom {
            margin-bottom: 16px;
        }
        .form-label-custom {
            display: block;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--navy);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        .form-input-custom {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--navy);
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input-custom:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.15);
        }

        /* Empty State */
        .empty-box {
            text-align: center;
            padding: 48px 24px;
            background: #F8FAFC;
            border-radius: 16px;
            border: 2px dashed var(--border-color);
            margin: 16px 0;
        }
        .empty-box i {
            font-size: 3rem;
            color: #94A3B8;
            margin-bottom: 12px;
            display: inline-block;
        }
        .empty-box h4 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .empty-box p {
            font-size: 0.88rem;
            color: var(--text-gray);
            max-width: 440px;
            margin: 0 auto 20px;
        }

        /* Responsive Sidebar Toggle for Mobile */
        .mobile-header {
            display: none;
            padding: 12px 16px;
            background: var(--navy);
            color: white;
            justify-content: space-between;
            align-items: center;
        }

        @media (max-width: 900px) {
            body { flex-direction: column; }
            .mobile-header { display: flex; }
            .sidebar {
                position: fixed;
                left: -260px;
                height: 100vh;
                top: 0;
            }
            .sidebar.open { left: 0; }
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header">
        <div style="font-weight: 800; font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 28px; width: 28px; border-radius: 6px; object-fit: cover;"> Fight D Fear
        </div>
        <button onclick="document.querySelector('.sidebar').classList.toggle('open')" style="background:transparent;border:none;color:white;font-size:1.4rem;">
            <i class="bi bi-list"></i>
        </button>
    </div>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/centres/dashboard" class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Centre Hub
        </a>

        <div class="sidebar-nav">
            <button class="nav-item active" onclick="switchTab('overview', this)">
                <i class="bi bi-grid-1x2-fill"></i> Overview
            </button>
            <button class="nav-item" onclick="switchTab('batches', this)">
                <i class="bi bi-layers-fill"></i> Programs & Batches
            </button>
            <button class="nav-item" onclick="switchTab('students', this)">
                <i class="bi bi-people-fill"></i> Students / Trainees
            </button>
            <button class="nav-item" onclick="switchTab('attendance', this)">
                <i class="bi bi-qr-code-scan"></i> QR Attendance
            </button>
            <button class="nav-item" onclick="switchTab('live', this)">
                <i class="bi bi-camera-video-fill"></i> Live Training
            </button>
            <button class="nav-item" onclick="switchTab('finance', this)">
                <i class="bi bi-wallet2"></i> Finance & Payouts
            </button>
            <button class="nav-item" onclick="switchTab('profile', this)">
                <i class="bi bi-gear-fill"></i> Centre Settings
            </button>
        </div>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/centres/logout" class="btn-logout">
                <i class="bi bi-box-arrow-right"></i> Sign Out
            </a>
        </div>
    </aside>

    <!-- Main Wrapper -->
    <div class="main-wrapper">

        <!-- Top Header -->
        <header class="topbar">
            <div class="topbar-greeting">
                <h1>Welcome back, <c:out value="${not empty loggedCentre.contactPerson ? loggedCentre.contactPerson : loggedCentre.name}"/> 👋</h1>
                <p>Manage your martial arts programs, batch schedules, and student progress</p>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-edit-profile">
                    <i class="bi bi-person-gear"></i> Complete Profile
                </a>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-container">

            <!-- Centre Profile Summary Card Matching Mobile -->
            <div class="centre-card">
                <div class="centre-card-left">
                    <div class="centre-avatar">
                        <c:choose>
                            <c:when test="${not empty loggedCentre.profilePhoto}">
                                <img src="${pageContext.request.contextPath}${loggedCentre.profilePhoto}" alt="Logo">
                            </c:when>
                            <c:otherwise>
                                ${loggedCentre.name.substring(0,1).toUpperCase()}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="centre-info">
                        <h2><c:out value="${loggedCentre.name}"/></h2>
                        <div class="centre-meta">
                            <span><i class="bi bi-geo-alt-fill text-danger"></i> <c:out value="${not empty loggedCentre.location ? loggedCentre.location : 'Location not set'}"/></span>
                            <span><i class="bi bi-telephone-fill text-success"></i> <c:out value="${loggedCentre.phoneNumber}"/></span>
                            <span><i class="bi bi-star-fill text-warning"></i> 4.8 Rating</span>
                            <c:choose>
                                <c:when test="${loggedCentre.approved}">
                                    <span class="pill-badge pill-verified"><i class="bi bi-patch-check-fill"></i> Verified Centre</span>
                                </c:when>
                                <c:when test="${loggedCentre.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <span class="pill-badge pill-pending"><i class="bi bi-clock-history"></i> Under Admin Review</span>
                                </c:when>
                                <c:when test="${loggedCentre.centreProfileStatus == 'CHANGES_REQUESTED'}">
                                    <span class="pill-badge pill-changes"><i class="bi bi-exclamation-triangle-fill"></i> Action Required</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="pill-badge pill-pending">Verification Required</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-edit-profile">
                        <i class="bi bi-pencil-square"></i> Edit Profile
                    </a>
                </div>
            </div>

            <!-- Profile Completion Banner (When unapproved / incomplete) -->
            <c:if test="${not loggedCentre.approved}">
                <div class="completion-banner">
                    <div class="completion-banner-left">
                        <div class="completion-header">
                            <span>Profile Completion Status</span>
                            <span style="color: var(--primary);">${loggedCentre.profileCompletionPct != null ? loggedCentre.profileCompletionPct : 0}%</span>
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style="width: ${loggedCentre.profileCompletionPct != null ? loggedCentre.profileCompletionPct : 0}%;"></div>
                        </div>
                        <p style="font-size: 0.8rem; color: var(--text-gray);">
                            <c:choose>
                                <c:when test="${loggedCentre.centreProfileStatus == 'CHANGES_REQUESTED'}">
                                    <strong style="color: var(--warning);">Admin Note:</strong> <c:out value="${loggedCentre.rejectionReason}"/>
                                </c:when>
                                <c:otherwise>
                                    Complete required profile information to submit your centre for Admin approval and unlock batch creation.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-quick-add">
                        <i class="bi bi-arrow-right-circle-fill"></i> Complete Profile Now
                    </a>
                </div>
            </c:if>

            <!-- 8 Key Metrics Grid -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Enrolled Students</span>
                        <div class="metric-icon-wrap" style="background:#FFE4E6;color:#F43F5E;"><i class="bi bi-people-fill"></i></div>
                    </div>
                    <div class="metric-val">${enrolledUsersCount != null ? enrolledUsersCount : 0}</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Active Batches</span>
                        <div class="metric-icon-wrap" style="background:#F3E8FF;color:#9333EA;"><i class="bi bi-layers-fill"></i></div>
                    </div>
                    <div class="metric-val">${batches != null ? batches.size() : 0}</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Today's Classes</span>
                        <div class="metric-icon-wrap" style="background:#FFEDD5;color:#EA580C;"><i class="bi bi-calendar-check-fill"></i></div>
                    </div>
                    <div class="metric-val">${todayClassesCount != null ? todayClassesCount : 1}</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Monthly Revenue</span>
                        <div class="metric-icon-wrap" style="background:#DCFCE7;color:#16A34A;"><i class="bi bi-wallet2"></i></div>
                    </div>
                    <div class="metric-val">₹${totalRevenue != null ? totalRevenue : '0'}</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Avg Attendance</span>
                        <div class="metric-icon-wrap" style="background:#E0E7FF;color:#4F46E5;"><i class="bi bi-person-check-fill"></i></div>
                    </div>
                    <div class="metric-val">94%</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Live Sessions</span>
                        <div class="metric-icon-wrap" style="background:#DBEAFE;color:#2563EB;"><i class="bi bi-camera-video-fill"></i></div>
                    </div>
                    <div class="metric-val">Online</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Centre Rating</span>
                        <div class="metric-icon-wrap" style="background:#FEF3C7;color:#D97706;"><i class="bi bi-star-fill"></i></div>
                    </div>
                    <div class="metric-val">4.8 ★</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-label">Status</span>
                        <div class="metric-icon-wrap" style="background:#FFE4E6;color:#F43F5E;"><i class="bi bi-shield-check"></i></div>
                    </div>
                    <div class="metric-val" style="font-size: 1.1rem; text-transform: uppercase;">
                        ${loggedCentre.centreProfileStatus != null ? loggedCentre.centreProfileStatus : 'Active'}
                    </div>
                </div>
            </div>

            <!-- Tab 1: Overview -->
            <div id="tab-overview" class="tab-section active">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-calendar-event text-danger"></i> Today's Schedule & Programs</div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Program / Batch</th>
                                <th>Style</th>
                                <th>Schedule</th>
                                <th>Days</th>
                                <th>Mode</th>
                                <th>Capacity</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="batch" items="${batches}">
                                <tr>
                                    <td><strong><c:out value="${batch.name}"/></strong></td>
                                    <td><span class="batch-style-badge"><c:out value="${batch.style}"/></span></td>
                                    <td><c:out value="${batch.timeSlot}"/></td>
                                    <td><span class="badge-status badge-offline"><c:out value="${batch.availableDays}"/></span></td>
                                    <td><span class="badge-status ${batch.batchType == 'Online' ? 'badge-online' : 'badge-offline'}"><c:out value="${batch.batchType != null ? batch.batchType : 'Offline'}"/></span></td>
                                    <td><c:out value="${batch.capacity != null ? batch.capacity : 20}"/> seats</td>
                                    <td><span class="status-pill status-pill-${batch.status != null ? batch.status : 'Active'}"><c:out value="${batch.status != null ? batch.status : 'Active'}"/></span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty batches}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 24px; color: var(--text-gray);">
                                        No active batches found. Complete your profile verification to add training programs.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Tab 2: Programs & Batches -->
            <div id="tab-batches" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div>
                            <div class="panel-title"><i class="bi bi-layers-fill text-danger"></i> Martial Arts Programs & Batches</div>
                            <span style="font-size: 0.82rem; color: var(--text-gray);">Manage curriculum disciplines, scheduled training batches, seat limits, and fee packages</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <c:choose>
                                <c:when test="${loggedCentre.approved}">
                                    <button type="button" class="btn-quick-add" onclick="openAddBatchModal()">
                                        <i class="bi bi-plus-circle-fill"></i> Add Program / Batch
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-quick-add" disabled style="background:#CBD5E1;cursor:not-allowed;box-shadow:none;" title="Approval required by Admin before creating batches">
                                        <i class="bi bi-lock-fill"></i> Add Batch (Approval Required)
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Disciplines / Programs Overview Bar -->
                    <div class="programs-bar">
                        <span style="font-size: 0.8rem; font-weight: 700; color: var(--text-gray); text-transform: uppercase;">Centre Disciplines:</span>
                        <c:choose>
                            <c:when test="${not empty loggedCentre.stylesTaught}">
                                <c:forEach var="style" items="${fn:split(loggedCentre.stylesTaught, ',')}">
                                    <div class="discipline-chip" onclick="filterBatchesByStyle('${fn:trim(style)}')">
                                        <i class="bi bi-shield-shaded text-danger"></i> ${fn:trim(style)}
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="discipline-chip active"><i class="bi bi-check2"></i> All Martial Arts Styles</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Batch Cards Grid View -->
                    <c:choose>
                        <c:when test="${not empty batches}">
                            <div class="batch-grid" id="batchCardsContainer">
                                <c:forEach var="batch" items="${batches}">
                                    <div class="batch-card" data-style="${batch.style}">
                                        <div>
                                            <div class="batch-card-header">
                                                <div>
                                                    <span class="batch-style-badge">${batch.style}</span>
                                                    <h4 class="batch-title">${batch.name}</h4>
                                                </div>
                                                <span class="status-pill status-pill-${batch.status != null ? batch.status : 'Active'}">
                                                    ${batch.status != null ? batch.status : 'Active'}
                                                </span>
                                            </div>

                                            <div class="batch-meta-row">
                                                <span><i class="bi bi-person-fill text-muted"></i> <strong>Coach:</strong> ${not empty batch.instructor ? batch.instructor : loggedCentre.contactPerson}</span>
                                                <span><i class="bi bi-award-fill text-muted"></i> ${not empty batch.skillLevel ? batch.skillLevel : 'All Levels'}</span>
                                                <span><i class="bi bi-people-fill text-muted"></i> ${not empty batch.ageGroup ? batch.ageGroup : 'All Ages'}</span>
                                                <span class="badge-status ${batch.batchType == 'Online' ? 'badge-online' : 'badge-offline'}">${batch.batchType != null ? batch.batchType : 'Offline'}</span>
                                            </div>

                                            <div class="batch-schedule-box">
                                                <div style="display:flex; justify-content:space-between; margin-bottom:4px;">
                                                    <span><i class="bi bi-calendar3 me-1 text-danger"></i> <strong>${batch.availableDays}</strong></span>
                                                    <span><i class="bi bi-clock me-1 text-primary"></i> ${batch.timeSlot}</span>
                                                </div>
                                                <div style="font-size:0.78rem; color:var(--text-gray); display:flex; justify-content:space-between;">
                                                    <span>Capacity: ${batch.capacity != null ? batch.capacity : 20} seats</span>
                                                    <span>Enrolled: <strong>${enrolledCountByBatch[batch.id] != null ? enrolledCountByBatch[batch.id] : 0}</strong> trainees</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div>
                                            <div class="batch-pricing-row">
                                                <div>
                                                    <span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">MONTHLY TUITION</span>
                                                    <span class="batch-price">₹${batch.fee != null ? batch.fee : 0}</span>
                                                </div>
                                                <c:if test="${batch.admissionFee != null && batch.admissionFee > 0}">
                                                    <div style="text-align:right;">
                                                        <span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">ADMISSION FEE</span>
                                                        <span style="font-size:0.95rem; font-weight:700; color:var(--navy);">₹${batch.admissionFee}</span>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <div class="batch-actions-bar">
                                                <button type="button" class="btn-card-action primary" onclick="openEditBatchModal('${batch.id}')">
                                                    <i class="bi bi-pencil-square"></i> Edit
                                                </button>
                                                <button type="button" class="btn-card-action" onclick="openBatchDetailsModal('${batch.id}')">
                                                    <i class="bi bi-eye"></i> Details
                                                </button>
                                                <button type="button" class="btn-card-action" onclick="toggleBatchStatus('${batch.id}', '${batch.status}')">
                                                    <i class="bi bi-toggle-on"></i> Status
                                                </button>
                                                <button type="button" class="btn-card-action danger" onclick="confirmDeleteBatch('${batch.id}', '${batch.name}')">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-box">
                                <i class="bi bi-layers"></i>
                                <h4>No programs or batches yet</h4>
                                <p>Create your first Martial Arts program or batch to start accepting students, scheduling workouts, and managing attendance.</p>
                                <c:choose>
                                    <c:when test="${loggedCentre.approved}">
                                        <button type="button" class="btn-quick-add" style="margin: 0 auto;" onclick="openAddBatchModal()">
                                            <i class="bi bi-plus-circle-fill"></i> + Create Your First Batch
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-quick-add" style="margin: 0 auto; display:inline-flex;">
                                            <i class="bi bi-person-gear"></i> Complete Verification First
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Tab 3: Students -->
            <div id="tab-students" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-people-fill text-danger"></i> Enrolled Trainees & Members</div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Contact</th>
                                <th>Enrolled Batch</th>
                                <th>Payment Status</th>
                                <th>Progress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enroll" items="${enrollments}">
                                <tr>
                                    <td><strong><c:out value="${enroll.user.fullName != null ? enroll.user.fullName : enroll.user.name}"/></strong></td>
                                    <td><c:out value="${enroll.user.email}"/></td>
                                    <td><c:out value="${enroll.batch != null ? enroll.batch.name : 'General Enrollment'}"/></td>
                                    <td><span class="badge-status badge-active"><c:out value="${enroll.paymentStatus != null ? enroll.paymentStatus : 'PAID'}"/></span></td>
                                    <td><span class="badge-status badge-active"><c:out value="${enroll.status != null ? enroll.status : 'In Training'}"/></span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty enrollments}">
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:24px;color:var(--text-gray);">
                                        No trainees enrolled yet. Trainees who enroll from the user app will appear here.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Tab 4: Attendance -->
            <div id="tab-attendance" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-qr-code-scan text-danger"></i> QR Attendance & Daily Session Log</div>
                    </div>
                    <div style="text-align: center; padding: 32px 16px;">
                        <div style="width: 120px; height: 120px; margin: 0 auto 16px; background: var(--bg-page); border: 2px dashed var(--primary); border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 3rem; color: var(--primary);">
                            <i class="bi bi-qr-code"></i>
                        </div>
                        <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--navy); margin-bottom: 6px;">Daily QR Attendance Ready</h3>
                        <p style="font-size: 0.85rem; color: var(--text-gray); max-width: 420px; margin: 0 auto 16px;">Generate real-time QR code at class start for contactless trainee scanning and verified attendance logs.</p>
                        <button class="btn-quick-add" style="margin: 0 auto;">Generate Session QR</button>
                    </div>
                </div>
            </div>

            <!-- Tab 5: Live Classes -->
            <div id="tab-live" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-camera-video-fill text-danger"></i> Online Self-Defense Classes</div>
                    </div>
                    <p style="color: var(--text-gray); font-size: 0.9rem;">Host live interactive webinars and virtual training sessions for women safety and self-defense education.</p>
                </div>
            </div>

            <!-- Tab 6: Finance -->
            <div id="tab-finance" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-wallet2 text-danger"></i> Centre Payouts & Wallet</div>
                    </div>
                    <div style="display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 20px;">
                        <div style="flex: 1; min-width: 240px; background: var(--bg-page); padding: 18px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <span style="font-size: 0.85rem; color: var(--text-gray); font-weight: 600;">Available Balance</span>
                            <div style="font-size: 1.8rem; font-weight: 800; color: var(--navy); margin-top: 4px;">₹${totalEarnings != null ? totalEarnings : 0}</div>
                        </div>
                        <div style="flex: 1; min-width: 240px; background: var(--bg-page); padding: 18px; border-radius: 12px; border: 1px solid var(--border-color);">
                            <span style="font-size: 0.85rem; color: var(--text-gray); font-weight: 600;">UPI Payout ID</span>
                            <div style="font-size: 1.1rem; font-weight: 700; color: var(--navy); margin-top: 8px;">
                                <c:out value="${not empty loggedCentre.upiId ? loggedCentre.upiId : 'Not Configured'}"/>
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-quick-add" style="display:inline-flex;">
                        Update Payout Details
                    </a>
                </div>
            </div>

            <!-- Tab 7: Profile -->
            <div id="tab-profile" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-gear-fill text-danger"></i> Centre Details & Settings</div>
                    </div>
                    <p style="color: var(--text-gray); font-size: 0.9rem; margin-bottom: 16px;">Manage your operating hours, training styles, facility photos, and official documents.</p>
                    <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-quick-add" style="display:inline-flex;">
                        Open Full Profile Editor
                    </a>
                </div>
            </div>

        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- ADD / EDIT BATCH MODAL (Parity with Mobile _BatchesTab) -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="batchModalOverlay">
        <div class="modal-window">
            <div class="modal-header-custom">
                <h3 id="batchModalTitle"><i class="bi bi-plus-circle me-2"></i> Create Martial Arts Batch</h3>
                <button type="button" class="btn-modal-close" onclick="closeBatchModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="batchForm" onsubmit="handleBatchFormSubmit(event)">
                <div class="modal-body-custom">
                    <input type="hidden" id="batchId" name="id">

                    <!-- Discipline / Style Selection -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">Martial Arts Discipline / Style *</label>
                        <select id="batchStyle" name="style" class="form-input-custom" required>
                            <option value="Karate">Karate</option>
                            <option value="Taekwondo">Taekwondo</option>
                            <option value="Krav Maga">Krav Maga</option>
                            <option value="Self-Defence">Self-Defence</option>
                            <option value="Boxing">Boxing</option>
                            <option value="Kickboxing">Kickboxing</option>
                            <option value="Jiu-Jitsu">Jiu-Jitsu</option>
                            <option value="Muay Thai">Muay Thai</option>
                            <option value="Kung Fu">Kung Fu</option>
                            <option value="MMA">MMA</option>
                            <option value="Judo">Judo</option>
                            <option value="Kalari / Indian Martial Arts">Kalari / Indian Martial Arts</option>
                            <option value="Women-Only Self-Defense">Women-Only Self-Defense</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <!-- Batch Name & Instructor -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Batch / Program Name *</label>
                            <input type="text" id="batchName" name="name" class="form-input-custom" placeholder="e.g. Karate Beginner - Evening" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Head Instructor *</label>
                            <input type="text" id="batchInstructor" name="instructor" class="form-input-custom" value="${not empty loggedCentre.contactPerson ? loggedCentre.contactPerson : ''}" placeholder="e.g. Master Rajesh" required>
                        </div>
                    </div>

                    <!-- Available Days Selector -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">Operating Days * (Select all that apply)</label>
                        <div class="day-chips-wrap">
                            <div class="day-toggle-chip selected" data-day="Mon" onclick="toggleDayChip(this)">Mon</div>
                            <div class="day-toggle-chip selected" data-day="Tue" onclick="toggleDayChip(this)">Tue</div>
                            <div class="day-toggle-chip selected" data-day="Wed" onclick="toggleDayChip(this)">Wed</div>
                            <div class="day-toggle-chip selected" data-day="Thu" onclick="toggleDayChip(this)">Thu</div>
                            <div class="day-toggle-chip selected" data-day="Fri" onclick="toggleDayChip(this)">Fri</div>
                            <div class="day-toggle-chip" data-day="Sat" onclick="toggleDayChip(this)">Sat</div>
                            <div class="day-toggle-chip" data-day="Sun" onclick="toggleDayChip(this)">Sun</div>
                        </div>
                        <input type="hidden" id="batchAvailableDays" name="availableDays" value="Mon,Tue,Wed,Thu,Fri">
                    </div>

                    <!-- Timings: Start & End Time -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Start Time *</label>
                            <input type="text" id="batchStartTime" class="form-input-custom" value="6:00 PM" placeholder="e.g. 6:00 PM" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">End Time *</label>
                            <input type="text" id="batchEndTime" class="form-input-custom" value="7:00 PM" placeholder="e.g. 7:00 PM" required>
                        </div>
                    </div>

                    <!-- Pricing: Monthly Fee & Admission Fee -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Monthly Fee (₹) *</label>
                            <input type="number" id="batchFee" name="fee" class="form-input-custom" min="0" step="50" value="1500" placeholder="e.g. 1500" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">One-Time Admission Fee (₹)</label>
                            <input type="number" id="batchAdmissionFee" name="admissionFee" class="form-input-custom" min="0" step="50" value="500" placeholder="e.g. 500">
                        </div>
                    </div>

                    <!-- Capacity, Age Group & Skill Level -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Max Student Capacity (5-100) *</label>
                            <input type="number" id="batchCapacity" name="capacity" class="form-input-custom" min="5" max="100" value="20" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Skill Level</label>
                            <select id="batchSkillLevel" name="skillLevel" class="form-input-custom">
                                <option value="All Levels">All Levels</option>
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate">Intermediate</option>
                                <option value="Advanced / Black Belt">Advanced / Black Belt</option>
                            </select>
                        </div>
                    </div>

                    <!-- Age Group & Mode -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Target Age Group</label>
                            <select id="batchAgeGroup" name="ageGroup" class="form-input-custom">
                                <option value="All Ages">All Ages</option>
                                <option value="Kids (5-12)">Kids (5-12)</option>
                                <option value="Teens (13-18)">Teens (13-18)</option>
                                <option value="Adults (18+)">Adults (18+)</option>
                                <option value="Women Only">Women Only</option>
                            </select>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Training Mode</label>
                            <select id="batchType" name="batchType" class="form-input-custom">
                                <option value="Offline">Offline (At Centre)</option>
                                <option value="Online">Online (Live Virtual)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Trial Option & Status -->
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Free Trial Session</label>
                            <select id="batchTrialType" name="trialType" class="form-input-custom">
                                <option value="Free Demo Session">1 Free Demo Session Offered</option>
                                <option value="None">No Free Trial</option>
                            </select>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Initial Status</label>
                            <select id="batchStatus" name="status" class="form-input-custom">
                                <option value="Active">Active</option>
                                <option value="Upcoming">Upcoming</option>
                                <option value="Full">Full</option>
                                <option value="Closed">Closed</option>
                            </select>
                        </div>
                    </div>

                    <!-- Location / Premises details -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">Hall / Dojo Room / Location Details</label>
                        <input type="text" id="batchLocation" name="location" class="form-input-custom" placeholder="e.g. Main Dojo Hall A, 2nd Floor">
                    </div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeBatchModal()">Cancel</button>
                    <button type="submit" id="btnSubmitBatch" class="btn-quick-add">
                        <i class="bi bi-check-circle-fill"></i> Save Batch
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- BATCH DETAILS INSPECTION MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="batchDetailsOverlay">
        <div class="modal-window">
            <div class="modal-header-custom">
                <h3 id="detailBatchName"><i class="bi bi-info-circle me-2"></i> Batch Details</h3>
                <button type="button" class="btn-modal-close" onclick="closeBatchDetailsModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div class="modal-body-custom" id="batchDetailBody">
                <!-- Dynamically injected details -->
            </div>
            <div class="modal-footer-custom">
                <button type="button" class="btn-card-action primary" onclick="closeBatchDetailsModal()">Close</button>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- DELETE CONFIRMATION MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="deleteConfirmOverlay">
        <div class="modal-window" style="max-width: 480px;">
            <div class="modal-header-custom" style="background:#EF4444;">
                <h3><i class="bi bi-exclamation-triangle-fill me-2"></i> Delete / Close Batch</h3>
                <button type="button" class="btn-modal-close" onclick="closeDeleteModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div class="modal-body-custom">
                <p id="deletePromptText" style="font-size: 0.95rem; color: var(--navy); margin-bottom: 12px;">
                    Are you sure you want to remove this batch?
                </p>
                <div style="font-size: 0.82rem; color: var(--text-gray); background: #F8FAFC; padding: 12px; border-radius: 8px; border: 1px solid var(--border-color);">
                    <i class="bi bi-shield-lock-fill text-warning me-1"></i> If trainees are already enrolled, the batch will be archived and set to <strong>Closed</strong> to protect student records.
                </div>
            </div>
            <div class="modal-footer-custom">
                <button type="button" class="btn-card-action" onclick="closeDeleteModal()">Cancel</button>
                <button type="button" id="btnConfirmDelete" class="btn-card-action danger" style="background:#DC2626;color:white;">
                    <i class="bi bi-trash-fill"></i> Confirm Action
                </button>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- JAVASCRIPT: TAB & BATCH MANAGEMENT CONTROLLER -->
    <!-- ========================================================================= -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const batchesData = ${not empty batchesJson ? batchesJson : '[]'};

        function switchTab(tabId, btn) {
            document.querySelectorAll('.tab-section').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));

            const target = document.getElementById('tab-' + tabId);
            if (target) {
                target.classList.add('active');
            }
            if (btn) {
                btn.classList.add('active');
            }
        }

        // Filter batches by style chip
        function filterBatchesByStyle(style) {
            document.querySelectorAll('.discipline-chip').forEach(c => c.classList.remove('active'));
            event.currentTarget.classList.add('active');
            document.querySelectorAll('.batch-card').forEach(card => {
                const cardStyle = card.getAttribute('data-style');
                if (!style || style === 'All' || cardStyle.toLowerCase().includes(style.toLowerCase())) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        // Day chip toggle
        function toggleDayChip(el) {
            el.classList.toggle('selected');
            updateSelectedDaysInput();
        }

        function updateSelectedDaysInput() {
            const selected = [];
            document.querySelectorAll('.day-toggle-chip.selected').forEach(chip => {
                selected.push(chip.getAttribute('data-day'));
            });
            document.getElementById('batchAvailableDays').value = selected.join(',');
        }

        function setDayChipsFromCSV(csv) {
            const days = (csv || '').split(',').map(d => d.trim().substring(0,3).toLowerCase());
            document.querySelectorAll('.day-toggle-chip').forEach(chip => {
                const dayCode = chip.getAttribute('data-day').toLowerCase();
                if (days.includes(dayCode)) {
                    chip.classList.add('selected');
                } else {
                    chip.classList.remove('selected');
                }
            });
            updateSelectedDaysInput();
        }

        // Open Add Modal
        function openAddBatchModal() {
            document.getElementById('batchForm').reset();
            document.getElementById('batchId').value = '';
            document.getElementById('batchModalTitle').innerHTML = '<i class="bi bi-plus-circle me-2"></i> Create Martial Arts Batch';
            document.getElementById('btnSubmitBatch').innerHTML = '<i class="bi bi-check-circle-fill"></i> Save / Create Batch';
            document.getElementById('btnSubmitBatch').disabled = false;
            setDayChipsFromCSV('Mon,Tue,Wed,Thu,Fri');
            document.getElementById('batchModalOverlay').classList.add('open');
        }

        // Open Edit Modal
        function openEditBatchModal(id) {
            fetch(contextPath + '/centres/batches/details/' + id)
                .then(r => r.json())
                .then(res => {
                    if (!res.success) {
                        alert(res.message || 'Unable to load batch details');
                        return;
                    }
                    const b = res.batch;
                    document.getElementById('batchId').value = b.id;
                    document.getElementById('batchStyle').value = b.style || 'Karate';
                    document.getElementById('batchName').value = b.name || '';
                    document.getElementById('batchInstructor').value = b.instructor || '';
                    
                    // Parse timeslot
                    if (b.timeSlot && b.timeSlot.includes('-')) {
                        const parts = b.timeSlot.split('-');
                        document.getElementById('batchStartTime').value = parts[0].trim();
                        document.getElementById('batchEndTime').value = parts[1].trim();
                    }
                    
                    document.getElementById('batchFee').value = b.fee || 0;
                    document.getElementById('batchAdmissionFee').value = b.admissionFee || 0;
                    document.getElementById('batchCapacity').value = b.capacity || 20;
                    document.getElementById('batchSkillLevel').value = b.skillLevel || 'All Levels';
                    document.getElementById('batchAgeGroup').value = b.ageGroup || 'All Ages';
                    document.getElementById('batchType').value = b.batchType || 'Offline';
                    document.getElementById('batchTrialType').value = b.trialType || 'Free Demo Session';
                    document.getElementById('batchStatus').value = b.status || 'Active';
                    document.getElementById('batchLocation').value = b.location || '';
                    
                    setDayChipsFromCSV(b.availableDays);

                    document.getElementById('batchModalTitle').innerHTML = '<i class="bi bi-pencil-square me-2"></i> Edit Martial Arts Batch';
                    document.getElementById('btnSubmitBatch').innerHTML = '<i class="bi bi-check-circle-fill"></i> Update Batch';
                    document.getElementById('btnSubmitBatch').disabled = false;
                    document.getElementById('batchModalOverlay').classList.add('open');
                })
                .catch(err => alert('Network error: ' + err));
        }

        function closeBatchModal() {
            document.getElementById('batchModalOverlay').classList.remove('open');
        }

        // Save / Update Batch AJAX
        function handleBatchFormSubmit(e) {
            e.preventDefault();
            const form = document.getElementById('batchForm');
            const startTime = document.getElementById('batchStartTime').value.trim();
            const endTime = document.getElementById('batchEndTime').value.trim();
            const timeSlot = startTime + ' - ' + endTime;

            const name = document.getElementById('batchName').value.trim();
            const instructor = document.getElementById('batchInstructor').value.trim();
            const availableDays = document.getElementById('batchAvailableDays').value.trim();
            const fee = parseFloat(document.getElementById('batchFee').value);
            const capacity = parseInt(document.getElementById('batchCapacity').value);

            if (!name) { alert('Please enter a batch/program name.'); return; }
            if (!instructor) { alert('Please enter the head instructor name.'); return; }
            if (!availableDays) { alert('Please select at least one operating day.'); return; }
            if (isNaN(fee) || fee < 0) { alert('Please enter a valid monthly fee.'); return; }
            if (isNaN(capacity) || capacity < 5) { alert('Please specify a capacity of at least 5 students.'); return; }

            const payload = {
                id: document.getElementById('batchId').value ? parseInt(document.getElementById('batchId').value) : null,
                name: name,
                style: document.getElementById('batchStyle').value,
                instructor: instructor,
                availableDays: availableDays,
                timeSlot: timeSlot,
                fee: fee,
                admissionFee: parseFloat(document.getElementById('batchAdmissionFee').value || '0'),
                capacity: capacity,
                skillLevel: document.getElementById('batchSkillLevel').value,
                ageGroup: document.getElementById('batchAgeGroup').value,
                batchType: document.getElementById('batchType').value,
                trialType: document.getElementById('batchTrialType').value,
                status: document.getElementById('batchStatus').value,
                location: document.getElementById('batchLocation').value.trim(),
                durationMinutes: 60,
                bufferMinutes: 10
            };

            const btn = document.getElementById('btnSubmitBatch');
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving...';

            fetch(contextPath + '/centres/batches/create', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
            .then(r => r.json())
            .then(res => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check-circle-fill"></i> Save / Create Batch';
                if (res.success) {
                    closeBatchModal();
                    // Show notification with '+ Add Another Batch' option
                    const banner = document.getElementById('batchSuccessBanner');
                    if (banner) {
                        banner.style.display = 'flex';
                        banner.innerHTML = '<div><i class="bi bi-check-circle-fill text-success me-2"></i> Batch <strong>' + name + '</strong> saved successfully!</div>' +
                            '<button type="button" class="btn-card-action primary" onclick="openAddBatchModal()"><i class="bi bi-plus-circle"></i> + Add Another Batch</button>';
                    }
                    setTimeout(() => { window.location.reload(); }, 600);
                } else {
                    alert(res.message || 'Failed to save batch');
                }
            })
            .catch(err => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check-circle-fill"></i> Save / Create Batch';
                alert('Request failed: ' + err);
            });
        }

        // Open Batch Details Modal
        function openBatchDetailsModal(id) {
            fetch(contextPath + '/centres/batches/details/' + id)
                .then(r => r.json())
                .then(res => {
                    if (!res.success) {
                        alert(res.message || 'Unable to load batch');
                        return;
                    }
                    const b = res.batch;
                    document.getElementById('detailBatchName').innerHTML = '<i class="bi bi-shield-fill text-danger me-2"></i> ' + (b.name || 'Batch Details');
                    
                    let html = '<div class="info-grid" style="display:grid; grid-template-columns:1fr 1fr; gap:14px;">' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">DISCIPLINE / STYLE</span><strong>' + b.style + '</strong></div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">STATUS</span><span class="status-pill status-pill-' + (b.status || 'Active') + '">' + (b.status || 'Active') + '</span></div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">INSTRUCTOR</span>' + (b.instructor || 'Centre Coach') + '</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">SCHEDULE</span>' + b.availableDays + ' (' + b.timeSlot + ')</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">CAPACITY</span>' + (b.capacity || 20) + ' seats (' + (res.enrolledCount || 0) + ' enrolled)</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">SKILL & AGE</span>' + (b.skillLevel || 'All Levels') + ' / ' + (b.ageGroup || 'All Ages') + '</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">MONTHLY FEE</span><strong style="color:var(--success); font-size:1.1rem;">₹' + (b.fee || 0) + '</strong></div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">ADMISSION FEE</span>₹' + (b.admissionFee || 0) + '</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">TRAINING MODE</span>' + (b.batchType || 'Offline') + '</div>' +
                        '<div><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">FREE TRIAL</span>' + (b.trialType || 'None') + '</div>' +
                        '<div style="grid-column: 1 / -1;"><span style="font-size:0.75rem; color:var(--text-gray); font-weight:700; display:block;">LOCATION DETAILS</span>' + (b.location || 'Centre Dojo Premises') + '</div>' +
                        '</div>';

                    document.getElementById('batchDetailBody').innerHTML = html;
                    document.getElementById('batchDetailsOverlay').classList.add('open');
                });
        }

        function closeBatchDetailsModal() {
            document.getElementById('batchDetailsOverlay').classList.remove('open');
        }

        // Toggle Status
        function toggleBatchStatus(id, currentStatus) {
            const nextStatus = currentStatus === 'Active' ? 'Closed' : 'Active';
            if (confirm('Change batch status to ' + nextStatus + '?')) {
                fetch(contextPath + '/centres/batches/status/' + id + '?status=' + nextStatus, { method: 'POST' })
                    .then(r => r.json())
                    .then(res => {
                        if (res.success) {
                            window.location.reload();
                        } else {
                            alert(res.message || 'Could not change status');
                        }
                    });
            }
        }

        // Delete Batch Dialog
        let activeDeleteId = null;
        function confirmDeleteBatch(id, name) {
            activeDeleteId = id;
            document.getElementById('deletePromptText').innerText = 'Are you sure you want to remove batch "' + name + '"?';
            document.getElementById('deleteConfirmOverlay').classList.add('open');
        }

        function closeDeleteModal() {
            document.getElementById('deleteConfirmOverlay').classList.remove('open');
            activeDeleteId = null;
        }

        document.getElementById('btnConfirmDelete').addEventListener('click', function() {
            if (!activeDeleteId) return;
            fetch(contextPath + '/centres/batches/delete/' + activeDeleteId, { method: 'POST' })
                .then(r => r.json())
                .then(res => {
                    closeDeleteModal();
                    if (res.success) {
                        alert(res.message || 'Batch updated');
                        window.location.reload();
                    } else {
                        alert(res.message || 'Could not delete batch');
                    }
                })
                .catch(err => alert('Request failed: ' + err));
        });
    </script>
</body>
</html>
