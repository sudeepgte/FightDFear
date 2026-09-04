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
            --martial-rose: #f43f5e;
            --martial-rose-dark: #e11d48;
            --martial-rose-light: #ffe4e6;
            --martial-rose-soft: #fff1f2;
            --martial-text: #0f172a;
            --martial-muted: #64748b;
            --martial-border: #e2e8f0;
            --martial-border-light: #f1f5f9;
            --martial-bg: #f8fafc;
            --martial-white: #ffffff;
            --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.03);
            --shadow-hover: 0 8px 24px rgba(244, 63, 94, 0.08);

            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #0F172A;
            --navy-light: #1E293B;
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
            background: var(--martial-bg);
            color: var(--martial-text);
            min-height: 100vh;
            display: flex;
        }

        /* Clean Light Sidebar matching Fitness — future-proof flex column */
        .sidebar {
            width: 240px;
            background: var(--martial-white);
            color: var(--martial-text);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            max-height: 100vh;
            z-index: 1000;
            border-right: 1px solid var(--martial-border);
            box-shadow: 2px 0 12px rgba(0,0,0,0.02);
            transition: all 0.3s ease-in-out;
            overflow: hidden;
        }

        .sidebar-brand {
            padding: 20px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.05rem;
            font-weight: 800;
            border-bottom: 1px solid var(--martial-border);
            text-decoration: none;
            color: var(--martial-text);
            flex-shrink: 0;
        }

        .sidebar-brand i {
            color: var(--martial-rose);
            font-size: 1.3rem;
        }

        /* Scrolls when many / future nav items are added */
        .sidebar-nav {
            flex: 1 1 auto;
            min-height: 0;
            overflow-y: auto;
            overflow-x: hidden;
            padding: 14px 10px;
            display: flex;
            flex-direction: column;
            gap: 4px;
            -webkit-overflow-scrolling: touch;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            color: var(--martial-muted);
            text-decoration: none;
            border-radius: 10px;
            font-size: 0.88rem;
            font-weight: 600;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
            flex-shrink: 0;
        }

        .nav-item i {
            font-size: 1.1rem;
            width: 22px;
            text-align: center;
            color: #94a3b8;
            transition: color 0.2s ease;
        }

        .nav-item:hover {
            color: var(--martial-rose-dark);
            background: var(--martial-rose-soft);
        }

        .nav-item:hover i {
            color: var(--martial-rose);
        }

        .nav-item.active {
            color: var(--martial-rose-dark);
            background: var(--martial-rose-light);
            font-weight: 700;
            box-shadow: none;
        }

        .nav-item.active i {
            color: var(--martial-rose);
        }

        /* Decorative illustration — shrinks/hides before nav is compromised */
        .sidebar-illustration {
            flex: 0 1 auto;
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding: 0;
            min-height: 0;
            max-height: 200px;
            overflow: hidden;
            pointer-events: none;
        }

        .sidebar-illustration img {
            width: clamp(120px, 80%, 180px);
            height: auto;
            max-height: 180px;
            object-fit: cover;
            display: block;
            user-select: none;
            margin-bottom: -15px; /* pull down if image has bottom padding */
        }

        .sidebar-footer {
            padding: 14px;
            border-top: 1px solid var(--martial-border);
            flex-shrink: 0;
            background: var(--martial-white);
        }

        .btn-logout {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            color: #EF4444;
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 600;
            border-radius: 10px;
            transition: background 0.2s;
        }

        .btn-logout:hover {
            background: #FEF2F2;
        }

        /* Main Content Wrapper */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            margin-left: 240px;
            min-height: 100vh;
            overflow-y: auto;
        }

        /* Top Header */
        .topbar {
            background: var(--martial-white);
            border-bottom: 1px solid var(--martial-border);
            padding: 16px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 30;
        }

        .topbar-greeting h1 {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--martial-text);
            margin: 0;
            letter-spacing: -0.3px;
        }

        .topbar-greeting p {
            font-size: 0.86rem;
            color: var(--martial-muted);
            font-weight: 500;
            margin-top: 2px;
            margin-bottom: 0;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .btn-header-cta {
            padding: 9px 18px;
            background: var(--martial-rose);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
            text-decoration: none;
        }

        .btn-header-cta:hover {
            background: var(--martial-rose-dark);
            color: #FFFFFF;
            transform: translateY(-1px);
        }

        /* Mobile Responsiveness */
        .mobile-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 1.6rem;
            color: var(--martial-text);
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.4);
            z-index: 990;
            backdrop-filter: blur(2px);
            transition: opacity 0.3s;
        }

        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(-100%);
                width: 260px;
            }
            .sidebar.show {
                transform: translateX(0);
                box-shadow: 4px 0 24px rgba(0,0,0,0.1);
            }
            .sidebar-overlay.show {
                display: block;
            }
            .main-wrapper {
                margin-left: 0;
            }
            .mobile-toggle {
                display: block;
            }
            .content-container {
                padding: 16px 16px 80px;
            }
            .topbar {
                padding: 14px 16px;
            }
            .topbar-greeting h1 {
                font-size: 1.15rem;
            }
            .topbar-greeting p {
                display: none;
            }
            .sidebar-illustration {
                display: none !important;
            }
            .btn-edit-profile span {
                display: none;
            }
            .stat-cards-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .stat-cards-grid {
                grid-template-columns: 1fr;
            }
            .centre-card {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
            }
            .centre-card-left {
                flex-direction: column;
            }
            .batch-actions-bar {
                flex-direction: column;
                align-items: stretch;
            }
            .batch-actions-bar button {
                width: 100%;
                justify-content: center;
            }
        }

        .content-container {
            padding: 26px 32px 60px;
            max-width: 1240px;
            width: 100%;
        }

        .tab-section {
            display: none;
        }

        .tab-section.active {
            display: block;
            animation: fadeInTab 0.2s ease-in-out;
        }

        @keyframes fadeInTab {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Centre Profile Summary Card Matching Fitness */
        .centre-card {
            background: var(--martial-white);
            border: 1px solid var(--martial-border);
            border-radius: 18px;
            padding: 22px 26px;
            margin-bottom: 22px;
            box-shadow: var(--shadow-card);
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
            width: 76px;
            height: 76px;
            border-radius: 16px;
            background: var(--martial-rose-light);
            color: var(--martial-rose);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.9rem;
            font-weight: 800;
            overflow: hidden;
            flex-shrink: 0;
            border: 2px solid #FECDD3;
        }

        .centre-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .centre-info h2 {
            font-size: 1.28rem;
            font-weight: 800;
            color: var(--martial-text);
            margin-bottom: 4px;
            letter-spacing: -0.2px;
        }

        .centre-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.84rem;
            color: var(--martial-muted);
            flex-wrap: wrap;
        }

        .pill-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.74rem;
            font-weight: 700;
        }

        .pill-verified { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
        .pill-pending { background: #FEF3C7; color: #92400E; border: 1px solid #FDE68A; }
        .pill-changes { background: #FFF7ED; color: #C2410C; border: 1px solid #FED7AA; }

        .btn-edit-profile {
            padding: 8px 16px;
            border: 1px solid var(--martial-border);
            background: var(--martial-white);
            color: var(--martial-text);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .btn-edit-profile:hover {
            border-color: var(--martial-rose);
            color: var(--martial-rose-dark);
            background: var(--martial-rose-soft);
        }

        /* Profile Completion Warning Card */
        .completion-banner {
            background: var(--martial-white);
            border: 1px solid #FECDD3;
            border-radius: 16px;
            padding: 20px 24px;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.04);
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

        /* Unified Stat Cards Grid Matching Fitness (No Rainbow Colors) */
        .stat-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }

        .stat-card-unified {
            background: var(--martial-white);
            border: 1px solid var(--martial-border);
            border-radius: 16px;
            padding: 20px 22px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 10px;
            box-shadow: var(--shadow-card);
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
            min-height: 125px;
            color: var(--martial-text);
        }

        .stat-card-unified:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-hover);
            border-color: #FECDD3;
        }

        .stat-card-label {
            font-size: 0.74rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--martial-muted);
        }

        .stat-card-value {
            font-size: 1.85rem;
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.5px;
            color: var(--martial-text);
        }

        .stat-card-icon-badge {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: var(--martial-rose-light);
            color: var(--martial-rose);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .stat-card-footer {
            font-size: 0.76rem;
            color: #94A3B8;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
            margin-top: 4px;
        }

        /* Clean Quick Actions Toolbar matching Fitness */
        .quick-actions-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .btn-quick-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 18px;
            border-radius: 999px;
            font-size: 0.84rem;
            font-weight: 600;
            background: var(--martial-white);
            border: 1px solid var(--martial-border);
            color: var(--martial-text);
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
        }

        .btn-quick-pill:hover {
            border-color: var(--martial-rose);
            color: var(--martial-rose-dark);
            background: var(--martial-rose-soft);
            transform: translateY(-1px);
        }

        .btn-quick-pill i {
            color: var(--martial-rose);
            font-size: 0.95rem;
        }

        .btn-quick-pill.primary {
            background: var(--martial-rose);
            color: #FFFFFF;
            border-color: var(--martial-rose);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }

        .btn-quick-pill.primary i {
            color: #FFFFFF;
        }

        .btn-quick-pill.primary:hover {
            background: var(--martial-rose-dark);
            border-color: var(--martial-rose-dark);
            color: #FFFFFF;
        }

        /* Standardized Action Button matching 10% Accent */
        .btn-quick-add {
            background: var(--primary);
            color: #FFFFFF;
            border: 1px solid var(--primary);
            padding: 9px 18px;
            border-radius: 999px;
            font-size: 0.84rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }
        .btn-quick-add i {
            color: #FFFFFF;
        }
        .btn-quick-add:hover {
            background: var(--primary-hover);
            border-color: var(--primary-hover);
            color: #FFFFFF;
            transform: translateY(-1px);
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
            background: var(--primary);
            color: #FFFFFF;
            border-color: var(--primary);
        }

        /* —— Trainee Attendance & Session Marking —— */
        .att-subnav {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            background: #F1F5F9;
            padding: 4px;
            border-radius: 12px;
            width: fit-content;
        }
        .att-subnav-btn {
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 0.84rem;
            font-weight: 700;
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            transition: all 0.2s;
            font-family: inherit;
        }
        .att-subnav-btn.active {
            background: #FFFFFF;
            color: var(--navy);
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .attendance-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }
        .att-stat-card {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 16px;
            text-align: center;
        }
        .att-stat-val {
            font-size: 1.5rem;
            font-weight: 800;
            display: block;
            color: var(--navy);
        }
        .att-stat-lbl {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 2px;
            display: block;
        }
        .btn-status-group {
            display: inline-flex;
            gap: 4px;
            background: #F8FAFC;
            padding: 3px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
        }
        .btn-status {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            border: none;
            font-weight: 800;
            font-size: 0.82rem;
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: transparent;
            color: var(--text-gray);
        }
        .btn-status.btn-p:hover { background: #DCFCE7; color: #166534; }
        .btn-status.btn-a:hover { background: #FEE2E2; color: #991B1B; }
        .btn-status.btn-l:hover { background: #FEF3C7; color: #92400E; }
        .btn-status.btn-e:hover { background: #E0F2FE; color: #075985; }
        .btn-status.btn-p.active { background: #16A34A; color: #FFFFFF; box-shadow: 0 2px 6px rgba(22,163,74,0.35); }
        .btn-status.btn-a.active { background: #DC2626; color: #FFFFFF; box-shadow: 0 2px 6px rgba(220,38,38,0.35); }
        .btn-status.btn-l.active { background: #D97706; color: #FFFFFF; box-shadow: 0 2px 6px rgba(217,119,6,0.35); }
        .btn-status.btn-e.active { background: #0284C7; color: #FFFFFF; box-shadow: 0 2px 6px rgba(2,132,199,0.35); }

        .circular-chart { display: block; margin: 0 auto; max-width: 40px; max-height: 40px; }
        .circle-bg { fill: none; stroke: #E2E8F0; stroke-width: 3.8; }
        .circle { fill: none; stroke-width: 3.8; stroke-linecap: round; }
        .circle.present { stroke: #16A34A; }
        .circle.absent { stroke: #DC2626; }
        .percentage { fill: var(--navy); font-size: 0.5em; text-anchor: middle; font-weight: 800; font-family: inherit; }

        /* —— Live Classes & Past Sessions —— */
        .live-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
            margin-top: 16px;
        }
        .live-card {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 22px;
            display: flex;
            flex-direction: column;
            transition: all 0.25s ease;
            box-shadow: var(--shadow-card);
        }
        .live-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.06);
        }
        .live-card-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .live-card-badge.upcoming { background: #DBEAFE; color: #1E40AF; }
        .live-card-badge.live { background: #FEE2E2; color: #DC2626; animation: livePulse 2s infinite; }
        .live-card-badge.completed { background: #DCFCE7; color: #166534; }
        @keyframes livePulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.75; transform: scale(1.03); }
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
            background: #FFFFFF;
            color: var(--navy);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
            border-bottom: 1px solid var(--border-color);
            border-radius: 20px 20px 0 0;
        }
        .modal-header-custom h3 {
            font-size: 1.15rem;
            font-weight: 800;
            margin: 0;
        }
        .btn-modal-close {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            color: var(--text-gray);
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-modal-close:hover {
            background: #F1F5F9;
            color: var(--navy);
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

        /* —— Review Application (Students / Trainees) —— */
        .review-app-shell { display: none; }
        .review-app-shell.is-open { display: block; }
        .students-list-shell.is-hidden { display: none !important; }

        .review-app-top {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 22px;
        }
        .review-back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--martial-rose);
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            margin-bottom: 10px;
            font-family: inherit;
        }
        .review-back-link:hover { color: var(--martial-rose-dark); }
        .review-app-title {
            font-size: 1.55rem;
            font-weight: 800;
            color: var(--navy);
            margin: 0 0 6px;
            letter-spacing: -0.02em;
        }
        .review-app-sub {
            color: var(--text-gray);
            font-size: 0.92rem;
            margin: 0;
            max-width: 420px;
            line-height: 1.45;
        }
        .review-app-id {
            display: inline-flex;
            align-items: center;
            background: var(--martial-rose-soft);
            color: var(--martial-rose);
            border: 1px solid #FECDD3;
            border-radius: 999px;
            padding: 8px 14px;
            font-size: 0.78rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .review-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: var(--shadow-card);
            padding: 22px 24px;
            margin-bottom: 16px;
        }
        .review-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
            font-weight: 800;
            color: var(--navy);
            margin: 0 0 18px;
        }
        .review-card-title .ri {
            width: 32px;
            height: 32px;
            border-radius: 10px;
            background: var(--martial-rose-soft);
            color: var(--martial-rose);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            flex-shrink: 0;
        }

        .review-student-layout {
            display: flex;
            gap: 28px;
            align-items: flex-start;
        }
        .review-photo {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #fff;
            box-shadow: 0 0 0 2px #FECDD3;
            flex-shrink: 0;
            background: var(--martial-rose-soft);
        }
        .review-photo-fallback {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background: var(--martial-rose-soft);
            color: var(--martial-rose);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            flex-shrink: 0;
            border: 3px solid #fff;
            box-shadow: 0 0 0 2px #FECDD3;
        }
        .review-field-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 28px;
            flex: 1;
            min-width: 0;
        }
        .review-field-grid.cols-2 { grid-template-columns: 1fr 1fr; }
        .review-field label {
            display: block;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-gray);
            margin-bottom: 3px;
        }
        .review-field .val {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--navy);
            word-break: break-word;
            line-height: 1.35;
        }

        .review-two-col {
            display: grid;
            grid-template-columns: 1.35fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        .review-two-col > .review-card { margin-bottom: 0; height: 100%; }

        .review-fee-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 0.92rem;
            color: var(--navy);
            border-bottom: 1px solid var(--martial-border-light);
        }
        .review-fee-row span:last-child { font-weight: 700; }
        .review-fee-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
            padding: 14px 16px;
            background: var(--martial-rose-soft);
            border-radius: 12px;
            font-weight: 800;
            color: var(--navy);
            font-size: 0.95rem;
        }
        .review-fee-note {
            margin-top: 14px;
            padding: 12px 14px;
            background: #FFFBEB;
            border: 1px solid #FDE68A;
            border-radius: 10px;
            color: #92400E;
            font-size: 0.82rem;
            font-weight: 600;
            line-height: 1.4;
        }

        .review-goals-text {
            color: var(--navy);
            font-size: 0.95rem;
            line-height: 1.55;
            margin: 0;
            white-space: pre-wrap;
        }
        .review-goals-empty {
            color: var(--text-gray);
            font-size: 0.92rem;
            font-style: italic;
            margin: 0;
        }

        .review-pay-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px 28px;
        }
        .review-status-pill {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.02em;
        }
        .review-status-pill.pending { background: #FEF3C7; color: #92400E; }
        .review-status-pill.approved,
        .review-status-pill.in_progress,
        .review-status-pill.paid { background: #DCFCE7; color: #166534; }
        .review-status-pill.rejected { background: #FEE2E2; color: #991B1B; }

        .review-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 8px;
            padding-top: 8px;
        }
        .btn-review-close {
            background: #fff;
            border: 1px solid var(--border-color);
            color: var(--navy);
            border-radius: 10px;
            padding: 10px 18px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-review-close:hover { background: #F8FAFC; }
        .btn-review-reject {
            background: #fff;
            border: 1.5px solid var(--martial-rose);
            color: var(--martial-rose);
            border-radius: 10px;
            padding: 10px 18px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-review-reject:hover { background: var(--martial-rose-soft); }
        .btn-review-approve {
            background: var(--navy);
            border: 1.5px solid var(--navy);
            color: #fff;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-review-approve:hover { background: var(--navy-light); }

        /* —— Responsive Grids and Media Queries —— */
        .att-filter-grid {
            display: grid;
            grid-template-columns: 1fr 220px auto;
            gap: 16px;
            align-items: end;
        }

        @media (max-width: 991px) {
            .review-two-col { grid-template-columns: 1fr; }
            .att-filter-grid { grid-template-columns: 1fr 1fr; }
            .att-filter-grid > div:last-child { grid-column: 1 / -1; }
            .att-filter-grid > div:last-child button { width: 100%; justify-content: center; }
        }

        @media (max-width: 768px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
                padding: 14px 16px;
            }
            .topbar > div:last-child {
                width: 100%;
                justify-content: space-between;
            }
            .welcome-banner {
                flex-direction: column;
                align-items: flex-start;
                gap: 14px;
                text-align: left;
            }
            .welcome-banner .btn-quick-add {
                width: 100%;
                justify-content: center;
            }
            .quick-actions-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
            }
            .btn-quick-pill {
                flex: 1 1 calc(50% - 8px);
                justify-content: center;
                text-align: center;
            }
            .stat-cards-grid {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 12px;
            }
            .attendance-summary-grid {
                grid-template-columns: repeat(2, 1fr) !important;
                gap: 10px;
            }
            .att-filter-grid {
                grid-template-columns: 1fr;
            }
            .att-subnav {
                width: 100%;
            }
            .att-subnav-btn {
                flex: 1;
                text-align: center;
                justify-content: center;
            }
            .live-cards-grid {
                grid-template-columns: 1fr;
            }
            .panel-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .panel-header button,
            .panel-header a {
                width: 100%;
                justify-content: center;
            }
            .content-panel {
                padding: 16px;
                border-radius: 14px;
            }
        }

        @media (max-width: 640px) {
            .main-wrapper {
                padding: 12px 10px;
            }
            .btn-quick-pill {
                flex: 1 1 100%;
            }
            .stat-cards-grid {
                grid-template-columns: 1fr !important;
            }
            .attendance-summary-grid {
                grid-template-columns: 1fr !important;
            }
            .review-student-layout { flex-direction: column; align-items: center; text-align: left; }
            .review-field-grid,
            .review-field-grid.cols-2,
            .review-pay-grid { grid-template-columns: 1fr; }
            .review-actions { justify-content: stretch; }
            .review-actions button { width: 100%; }
            .review-app-title { font-size: 1.3rem; }
            .form-grid-2 { grid-template-columns: 1fr !important; }
            .modal-window {
                width: 95%;
                margin: 8px;
                max-height: 92vh;
            }
            .modal-header-custom,
            .modal-body-custom,
            .modal-footer-custom {
                padding: 14px 16px;
            }
            .modal-footer-custom {
                flex-direction: column-reverse;
                gap: 8px;
            }
            .modal-footer-custom button {
                width: 100%;
                justify-content: center;
            }
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
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
            background: #FFFFFF;
            color: var(--navy);
            font-family: inherit;
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
                left: -280px;
                width: 280px;
                height: 100vh;
                max-height: 100vh;
                top: 0;
                z-index: 1060;
                transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }
            .sidebar.show, .sidebar.open { left: 0; }
            .sidebar-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background: rgba(15, 13, 38, 0.5);
                backdrop-filter: blur(2px);
                z-index: 1055;
            }
            .sidebar-overlay.show, .sidebar-overlay.open {
                display: block;
            }
            .sidebar-illustration img {
                width: clamp(90px, 55%, 130px);
                max-height: 120px;
            }
        }

        /* Short viewports: shrink illustration further, never block nav/sign-out */
        @media (max-height: 720px) {
            .sidebar-illustration {
                max-height: 110px;
                padding: 6px 12px;
            }
            .sidebar-illustration img {
                max-height: 96px;
                width: clamp(90px, 55%, 130px);
            }
        }

        @media (max-height: 580px) {
            .sidebar-illustration {
                display: none;
            }
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header">
        <div style="font-weight: 800; font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 28px; width: 28px; border-radius: 6px; object-fit: cover;"> Fight D Fear
        </div>
        <button onclick="toggleSidebar()" style="background:transparent;border:none;color:white;font-size:1.5rem;cursor:pointer;display:flex;align-items:center;">
            <i class="bi bi-list"></i>
        </button>
    </div>

    <!-- Mobile Sidebar Overlay -->
    <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

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
                <i class="bi bi-clipboard-check-fill"></i> Attendance Tracking
            </button>
            <button class="nav-item" onclick="switchTab('grading', this)">
                <i class="bi bi-award-fill"></i> Belt Grading & Skills
            </button>
            <button class="nav-item" onclick="switchTab('instructors', this)">
                <i class="bi bi-person-badge-fill"></i> Instructor Staff
            </button>
            <button class="nav-item" onclick="switchTab('live', this)">
                <i class="bi bi-camera-video-fill"></i> Live Classes
            </button>
            <button class="nav-item" onclick="switchTab('past-sessions', this)">
                <i class="bi bi-clock-history"></i> Past Sessions
            </button>
            <button class="nav-item" onclick="switchTab('finance', this)">
                <i class="bi bi-wallet2"></i> Finance & Payouts
            </button>
            <button class="nav-item" onclick="switchTab('profile', this)">
                <i class="bi bi-gear-fill"></i> Centre Settings
            </button>
        </div>

        <div class="sidebar-illustration" aria-hidden="true">
            <img src="${pageContext.request.contextPath}/assets/img/centre/sidebar-illustration.png"
                 alt=""
                 width="160"
                 height="160"
                 loading="lazy"
                 decoding="async">
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
            <div style="display:flex; align-items:center; gap:14px;">
                <button class="mobile-toggle" onclick="toggleSidebar()">
                    <i class="bi bi-list"></i>
                </button>
                <div class="topbar-greeting">
                    <%
                        int currentHour = java.time.LocalTime.now().getHour();
                        String martialGreeting = "Good morning";
                        if (currentHour >= 12 && currentHour < 17) {
                            martialGreeting = "Good afternoon";
                        } else if (currentHour >= 17 || currentHour < 5) {
                            martialGreeting = "Good evening";
                        }
                        request.setAttribute("martialGreeting", martialGreeting);
                    %>
                    <h1>${martialGreeting}, <c:out value="${not empty loggedCentre.contactPerson ? loggedCentre.contactPerson : loggedCentre.name}"/> 👋</h1>
                    <p>Manage your martial arts programs, batch schedules, and student progress</p>
                </div>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-edit-profile">
                    <i class="bi bi-person-gear"></i> <span>Complete Profile</span>
                </a>
            </div>
        </header>

        <!-- Content Area -->
        <div class="content-container">

            <!-- Tab 1: Overview Workspace -->
            <div id="tab-overview" class="tab-section active">

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
                <c:if test="${not loggedCentre.approved || (loggedCentre.profileCompletionPct != null && loggedCentre.profileCompletionPct < 100)}">
                    <div class="completion-banner">
                        <div class="completion-banner-left">
                            <div class="completion-header">
                                <span>Centre Profile Completion</span>
                                <span style="color: var(--primary); font-weight: 800;">${loggedCentre.profileCompletionPct != null ? loggedCentre.profileCompletionPct : 0}%</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill" style="width: ${loggedCentre.profileCompletionPct != null ? loggedCentre.profileCompletionPct : 0}%;"></div>
                            </div>
                            <p style="font-size: 0.82rem; color: var(--text-gray); margin-bottom: 8px;">
                                <c:choose>
                                    <c:when test="${loggedCentre.centreProfileStatus == 'CHANGES_REQUESTED'}">
                                        <strong style="color: var(--warning);">Admin Feedback:</strong> <c:out value="${not empty loggedCentre.changesRequestedNote ? loggedCentre.changesRequestedNote : loggedCentre.rejectionReason}"/>
                                    </c:when>
                                    <c:otherwise>
                                        Complete these sections to improve discovery, student trust, and get verified:
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <div class="d-flex flex-wrap gap-1 mt-1">
                                <c:if test="${empty loggedCentre.about}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Add Description</span></c:if>
                                <c:if test="${empty loggedCentre.openTime or empty loggedCentre.closeTime}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Set Hours</span></c:if>
                                <c:if test="${empty loggedCentre.profilePhoto}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Upload Logo</span></c:if>
                                <c:if test="${empty loggedCentre.galleryPhotos or loggedCentre.galleryPhotos.size() == 0}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Upload Gallery</span></c:if>
                                <c:if test="${empty loggedCentre.stylesTaught}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Select Styles</span></c:if>
                                <c:if test="${empty loggedCentre.facilities}"><span class="badge" style="background:#FFE4E6;color:#E11D48;border:1px solid #FECDD3;font-size:0.75rem;padding:4px 8px;border-radius:6px;">&bull; Add Amenities</span></c:if>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/centres/profile-completion" class="btn-quick-add" style="white-space: nowrap;">
                            <i class="bi bi-arrow-right-circle-fill"></i> Complete Profile &rarr;
                        </a>
                    </div>
                </c:if>

                <!-- Clean Quick Actions Toolbar matching Fitness -->
                <div class="quick-actions-bar">
                    <button type="button" class="btn-quick-pill primary" onclick="switchTab('batches'); openCreateBatchModal();">
                        <i class="bi bi-plus-circle-fill"></i> Create Batch
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('attendance');">
                        <i class="bi bi-clipboard-check-fill"></i> Trainee Attendance
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('live'); openCreateLiveClassModal();">
                        <i class="bi bi-camera-video-fill"></i> Create Live Class
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('past-sessions');">
                        <i class="bi bi-clock-history"></i> Past Sessions
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('students');">
                        <i class="bi bi-people-fill"></i> Manage Students
                    </button>
                    <button type="button" class="btn-quick-pill" onclick="switchTab('grading');">
                        <i class="bi bi-award-fill"></i> Belt Grading
                    </button>
                </div>

                <!-- 4 Unified Stat Cards Grid Matching Fitness (No Rainbow Colors) -->
                <div class="stat-cards-grid">
                    <div class="stat-card-unified">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="stat-card-label">Enrolled Students</span>
                            <div class="stat-card-icon-badge"><i class="bi bi-people-fill"></i></div>
                        </div>
                        <div>
                            <div class="stat-card-value">${enrolledUsersCount != null ? enrolledUsersCount : 0}</div>
                            <div class="stat-card-footer"><i class="bi bi-check-circle-fill text-success me-1"></i> Active trainees</div>
                        </div>
                    </div>

                    <div class="stat-card-unified">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="stat-card-label">Active Batches</span>
                            <div class="stat-card-icon-badge"><i class="bi bi-layers-fill"></i></div>
                        </div>
                        <div>
                            <div class="stat-card-value">${batches != null ? batches.size() : 0}</div>
                            <div class="stat-card-footer"><i class="bi bi-activity text-danger me-1"></i> Ongoing programs</div>
                        </div>
                    </div>

                    <div class="stat-card-unified">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="stat-card-label">Today's Classes</span>
                            <div class="stat-card-icon-badge"><i class="bi bi-calendar-check-fill"></i></div>
                        </div>
                        <div>
                            <div class="stat-card-value">${todayClassesCount != null ? todayClassesCount : (batches != null && batches.size() > 0 ? 1 : 0)}</div>
                            <div class="stat-card-footer"><i class="bi bi-clock-history me-1"></i> Scheduled today</div>
                        </div>
                    </div>

                    <div class="stat-card-unified">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="stat-card-label">Monthly Revenue</span>
                            <div class="stat-card-icon-badge"><i class="bi bi-wallet2"></i></div>
                        </div>
                        <div>
                            <div class="stat-card-value">₹${totalRevenue != null ? totalRevenue : '0'}</div>
                            <div class="stat-card-footer"><i class="bi bi-arrow-up-right text-success me-1"></i> Current month</div>
                        </div>
                    </div>
                </div>

                <!-- Today's Schedule Content Panel -->
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
                    <div class="programs-bar" id="disciplineFilterBar">
                        <span style="font-size: 0.8rem; font-weight: 700; color: var(--text-gray); text-transform: uppercase;">Centre Disciplines:</span>
                        <div class="discipline-chip active" data-style="" onclick="filterBatchesByStyle('', this)">
                            <i class="bi bi-check2"></i> All
                        </div>
                        <c:if test="${not empty loggedCentre.stylesTaught}">
                            <c:forEach var="style" items="${fn:split(loggedCentre.stylesTaught, ',')}">
                                <div class="discipline-chip" data-style="${fn:trim(style)}" onclick="filterBatchesByStyle('${fn:trim(style)}', this)">
                                    <i class="bi bi-shield-shaded text-danger"></i> ${fn:trim(style)}
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>
                    <div id="disciplineEmptyMsg" style="display:none; text-align:center; padding:24px; color:var(--text-gray);">
                        No programs or batches available for this discipline.
                    </div>

                    <!-- Batch Cards Grid View -->
                    <c:choose>
                        <c:when test="${not empty batches}">
                            <div class="batch-grid" id="batchCardsContainer">
                                <c:forEach var="batch" items="${batches}">
                                    <div class="batch-card" data-style="${batch.style != null ? batch.style : ''}">
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
                    <div id="studentsListShell" class="students-list-shell">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-people-fill text-danger"></i> Students / Trainees</div>
                    </div>
                    <div class="d-flex flex-wrap gap-2 mb-3" id="studentStatusTabs">
                        <button type="button" class="btn btn-sm rounded-pill active" data-student-filter="PENDING" onclick="filterStudentRows('PENDING', this)" style="background:#FFF1F2;color:#F43F5E;border:1px solid #FECDD3;">Pending Applications</button>
                        <button type="button" class="btn btn-sm rounded-pill" data-student-filter="ACTIVE" onclick="filterStudentRows('ACTIVE', this)" style="background:#fff;border:1px solid #E2E8F0;">Active Students</button>
                        <button type="button" class="btn btn-sm rounded-pill" data-student-filter="REJECTED" onclick="filterStudentRows('REJECTED', this)" style="background:#fff;border:1px solid #E2E8F0;">Rejected</button>
                        <button type="button" class="btn btn-sm rounded-pill" data-student-filter="ALL" onclick="filterStudentRows('ALL', this)" style="background:#fff;border:1px solid #E2E8F0;">All</button>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Batch</th>
                                <th>Application Status</th>
                                <th>Payment</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="enroll" items="${enrollments}">
                                <c:set var="appFee" value="${enroll.batch != null && enroll.batch.fee != null ? enroll.batch.fee : 0}"/>
                                <c:set var="admFee" value="${enroll.batch != null && enroll.batch.admissionFee != null ? enroll.batch.admissionFee : 0}"/>
                                <tr class="student-row"
                                    data-status="${enroll.status != null ? enroll.status : 'PENDING'}"
                                    data-payment="${enroll.paymentStatus != null ? enroll.paymentStatus : 'PENDING'}"
                                    data-enroll-id="${enroll.id}"
                                    id="student-row-${enroll.id}">
                                    <td>
                                        <strong><c:out value="${enroll.fullName != null ? enroll.fullName : (enroll.user.fullName != null ? enroll.user.fullName : enroll.user.name)}"/></strong>
                                        <div class="small text-muted"><c:out value="${enroll.email != null ? enroll.email : enroll.user.email}"/></div>
                                        <div class="small text-muted"><c:out value="${enroll.phoneNumber != null ? enroll.phoneNumber : ''}"/></div>
                                    </td>
                                    <td>
                                        <c:out value="${enroll.batch != null ? enroll.batch.name : 'General Enrollment'}"/>
                                        <div class="small text-muted"><c:out value="${enroll.batch != null ? enroll.batch.style : ''}"/></div>
                                    </td>
                                    <td><span class="badge-status"><c:out value="${enroll.status != null ? enroll.status : 'PENDING'}"/></span></td>
                                    <td><span class="badge-status"><c:out value="${enroll.paymentStatus != null ? enroll.paymentStatus : 'PENDING'}"/></span></td>
                                    <td style="white-space:nowrap;">
                                        <button type="button" class="btn-card-action" onclick="openEnrollmentReview(${enroll.id})">
                                            <i class="bi bi-eye"></i> View / Review
                                        </button>
                                        <c:if test="${enroll.status == 'PENDING'}">
                                            <button type="button" class="btn-card-action primary" onclick="updateEnrollmentStatus(${enroll.id}, 'APPROVED')">Approve</button>
                                            <button type="button" class="btn-card-action danger" onclick="updateEnrollmentStatus(${enroll.id}, 'REJECTED')">Reject</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty enrollments}">
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:24px;color:var(--text-gray);">
                                        No pending applications.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                    </div><!-- /studentsListShell -->

                    <!-- Structured Review Application (inline, matches Centre Hub reference) -->
                    <div id="enrollmentReviewShell" class="review-app-shell">
                        <div id="enrollmentReviewBody"></div>
                        <div id="enrollmentReviewActions" class="review-actions" style="display:none;">
                            <button type="button" class="btn-review-close" onclick="closeEnrollmentReview()">Close</button>
                            <button type="button" id="reviewRejectBtn" class="btn-review-reject" onclick="rejectFromReview()">Reject Application</button>
                            <button type="button" id="reviewApproveBtn" class="btn-review-approve" onclick="approveFromReview()">Approve Application</button>
                        </div>
                    </div>

                    <!-- Hidden structured review sources (real enrollment data) -->
                    <c:forEach var="enroll" items="${enrollments}">
                        <c:set var="appFee" value="${enroll.batch != null && enroll.batch.fee != null ? enroll.batch.fee : 0}"/>
                        <c:set var="admFee" value="${enroll.batch != null && enroll.batch.admissionFee != null ? enroll.batch.admissionFee : 0}"/>
                        <c:set var="totalFee" value="${appFee + admFee}"/>
                        <c:set var="displayName" value="${enroll.fullName != null ? enroll.fullName : (enroll.user.fullName != null ? enroll.user.fullName : enroll.user.name)}"/>
                        <c:set var="displayEmail" value="${enroll.email != null ? enroll.email : enroll.user.email}"/>
                        <c:set var="appStatus" value="${enroll.status != null ? enroll.status : 'PENDING'}"/>
                        <c:set var="payStatus" value="${enroll.paymentStatus != null ? enroll.paymentStatus : 'PENDING'}"/>
                        <c:set var="batchCap" value="${enroll.batch != null ? enroll.batch.capacity : null}"/>
                        <c:set var="occupiedSeats" value="0"/>
                        <c:if test="${enroll.batch != null && batchCap != null}">
                            <c:forEach var="e2" items="${enrollments}">
                                <c:if test="${e2.batch != null && e2.batch.id == enroll.batch.id && e2.status != 'REJECTED'}">
                                    <c:set var="occupiedSeats" value="${occupiedSeats + 1}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <c:set var="seatsLeft" value="${batchCap != null ? (batchCap - occupiedSeats) : null}"/>
                        <c:set var="appIdLabel" value="APP-${enroll.id}"/>

                        <div id="enrollment-review-${enroll.id}" class="enrollment-review-source" style="display:none;"
                             data-status="${appStatus}"
                             data-app-id="${appIdLabel}">
                            <div class="review-app-top">
                                <div>
                                    <button type="button" class="review-back-link" onclick="closeEnrollmentReview()">
                                        <i class="bi bi-arrow-left"></i> Back to Students / Trainees
                                    </button>
                                    <h2 class="review-app-title">Review Application</h2>
                                    <p class="review-app-sub">Carefully review the student's application before approving or rejecting.</p>
                                </div>
                                <span class="review-app-id">Application ID: <c:out value="${appIdLabel}"/></span>
                            </div>

                            <!-- 1. Student Information -->
                            <div class="review-card">
                                <h3 class="review-card-title"><span class="ri"><i class="bi bi-person"></i></span> 1. Student Information</h3>
                                <div class="review-student-layout">
                                    <c:choose>
                                        <c:when test="${enroll.user != null && not empty enroll.user.profilePhoto}">
                                            <img class="review-photo" src="${pageContext.request.contextPath}${enroll.user.profilePhoto}" alt="Profile photo">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="review-photo-fallback" aria-hidden="true"><i class="bi bi-person"></i></div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="review-field-grid">
                                        <div class="review-field">
                                            <label>Full Name</label>
                                            <div class="val"><c:out value="${displayName}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Email</label>
                                            <div class="val"><c:out value="${not empty displayEmail ? displayEmail : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Phone</label>
                                            <div class="val"><c:out value="${not empty enroll.phoneNumber ? enroll.phoneNumber : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Date of Birth</label>
                                            <div class="val">
                                                <c:choose>
                                                    <c:when test="${enroll.dob != null}">
                                                        <c:out value="${enroll.dob}"/>
                                                        <c:if test="${enroll.age != null}"> (<c:out value="${enroll.age}"/> Yrs)</c:if>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="review-field">
                                            <label>Gender</label>
                                            <div class="val"><c:out value="${not empty enroll.gender ? enroll.gender : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Emergency Contact</label>
                                            <div class="val"><c:out value="${not empty enroll.emergencyContactName ? enroll.emergencyContactName : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Address</label>
                                            <div class="val"><c:out value="${not empty enroll.residentialAddress ? enroll.residentialAddress : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Registration Date</label>
                                            <div class="val"><c:out value="${enroll.enrolledAt != null ? enroll.enrolledAt : '—'}"/></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2 + 3. Enrollment + Fees -->
                            <div class="review-two-col">
                                <div class="review-card">
                                    <h3 class="review-card-title"><span class="ri"><i class="bi bi-journal-text"></i></span> 2. Enrollment Details</h3>
                                    <div class="review-field-grid cols-2">
                                        <div class="review-field">
                                            <label>Centre</label>
                                            <div class="val"><c:out value="${enroll.center != null ? enroll.center.name : loggedCentre.name}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Discipline</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.style ? enroll.batch.style : (enroll.martialArtsType != null ? enroll.martialArtsType.name : '—')}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Batch</label>
                                            <div class="val"><c:out value="${enroll.batch != null ? enroll.batch.name : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Level</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.skillLevel ? enroll.batch.skillLevel : (not empty enroll.skillLevel ? enroll.skillLevel : '—')}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Coach / Instructor</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.instructor ? enroll.batch.instructor : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Days</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.availableDays ? enroll.batch.availableDays : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Time</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.timeSlot ? enroll.batch.timeSlot : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Mode</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.batchType ? enroll.batch.batchType : '—'}"/></div>
                                        </div>
                                        <div class="review-field">
                                            <label>Age Group</label>
                                            <div class="val"><c:out value="${enroll.batch != null && not empty enroll.batch.ageGroup ? enroll.batch.ageGroup : '—'}"/></div>
                                        </div>
                                        <c:if test="${batchCap != null}">
                                            <div class="review-field">
                                                <label>Seats Remaining</label>
                                                <div class="val"><c:out value="${seatsLeft}"/> / <c:out value="${batchCap}"/></div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="review-card">
                                    <h3 class="review-card-title"><span class="ri"><i class="bi bi-cash-stack"></i></span> 3. Fee Details</h3>
                                    <div class="review-fee-row">
                                        <span>Monthly Tuition</span>
                                        <span>₹ <fmt:formatNumber value="${appFee}" minFractionDigits="0" maxFractionDigits="2"/></span>
                                    </div>
                                    <div class="review-fee-row">
                                        <span>Admission Fee</span>
                                        <span>₹ <fmt:formatNumber value="${admFee}" minFractionDigits="0" maxFractionDigits="2"/></span>
                                    </div>
                                    <div class="review-fee-total">
                                        <span>Total Applicable Fee</span>
                                        <span>₹ <fmt:formatNumber value="${totalFee}" minFractionDigits="0" maxFractionDigits="2"/></span>
                                    </div>
                                    <div class="review-fee-note">Note: Payment will be collected only after approval.</div>
                                </div>
                            </div>

                            <!-- 4. Goals -->
                            <div class="review-card">
                                <h3 class="review-card-title"><span class="ri"><i class="bi bi-bullseye"></i></span> 4. Applicant's Goals</h3>
                                <c:choose>
                                    <c:when test="${not empty enroll.trainingGoal || not empty enroll.motivation || not empty enroll.skillLevel}">
                                        <c:if test="${not empty enroll.skillLevel}">
                                            <div class="review-field" style="margin-bottom:12px;">
                                                <label>Experience / Level</label>
                                                <div class="val"><c:out value="${enroll.skillLevel}"/></div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty enroll.trainingGoal}">
                                            <p class="review-goals-text"><c:out value="${enroll.trainingGoal}"/></p>
                                        </c:if>
                                        <c:if test="${not empty enroll.motivation}">
                                            <p class="review-goals-text" style="${not empty enroll.trainingGoal ? 'margin-top:10px;' : ''}"><c:out value="${enroll.motivation}"/></p>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="review-goals-empty">No goals or additional information provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 5. Payment Status -->
                            <div class="review-card">
                                <h3 class="review-card-title"><span class="ri"><i class="bi bi-credit-card"></i></span> 5. Payment Status</h3>
                                <div class="review-pay-grid">
                                    <div class="review-field">
                                        <label>Application Status</label>
                                        <div class="val">
                                            <span class="review-status-pill ${fn:toLowerCase(appStatus)}"><c:out value="${appStatus}"/></span>
                                        </div>
                                    </div>
                                    <div class="review-field">
                                        <label>Current Payment Status</label>
                                        <div class="val">
                                            <span class="review-status-pill ${fn:toLowerCase(payStatus)}"><c:out value="${payStatus}"/></span>
                                        </div>
                                    </div>
                                    <div class="review-field">
                                        <label>Payment Method</label>
                                        <div class="val">
                                            <c:choose>
                                                <c:when test="${payStatus == 'PAID' && not empty enroll.razorpayPaymentId}">Razorpay</c:when>
                                                <c:when test="${payStatus == 'PAID'}">Paid</c:when>
                                                <c:otherwise>Not Applied</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${enroll.amountPaid != null}">
                                        <div class="review-field">
                                            <label>Amount Paid</label>
                                            <div class="val">₹ <fmt:formatNumber value="${enroll.amountPaid}" minFractionDigits="0" maxFractionDigits="2"/></div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Tab 4: Trainee Attendance Tracking -->
            <div id="tab-attendance" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header" style="flex-wrap:wrap; gap:12px;">
                        <div>
                            <div class="panel-title"><i class="bi bi-clipboard-check-fill text-danger"></i> Trainee Attendance Hub</div>
                            <p style="font-size:0.85rem; color:var(--text-gray); margin:4px 0 0 0;">Manage daily check-ins, record session attendance, and generate live QR codes.</p>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <button type="button" class="btn-quick-add" onclick="saveAttendance()" id="btnSaveAttendanceTop">
                                <i class="bi bi-cloud-arrow-up-fill me-1"></i> Save Attendance
                            </button>
                        </div>
                    </div>

                    <!-- Sub-Nav Pill Switcher -->
                    <div class="att-subnav">
                        <button type="button" class="att-subnav-btn active" id="btnSubnavRoster" onclick="switchAttendanceView('roster', this)">
                            <i class="bi bi-person-check-fill me-1"></i> Daily Roster & Marking
                        </button>
                        <button type="button" class="att-subnav-btn" id="btnSubnavQr" onclick="switchAttendanceView('qr', this)">
                            <i class="bi bi-qr-code-scan me-1"></i> Dynamic QR Engine
                        </button>
                    </div>

                    <!-- Sub-View 1: Daily Roster & Marking -->
                    <div id="attViewRoster">
                        <!-- Session & Date Filter Bar -->
                        <div style="background: var(--bg-page); padding: 18px 20px; border-radius: 16px; border: 1px solid var(--border-color); margin-bottom: 24px;">
                            <div class="att-filter-grid">
                                <div>
                                    <label style="display:block; font-size: 0.8rem; font-weight: 700; color: var(--navy); margin-bottom: 6px; text-transform:uppercase;">Select Batch / Online Session *</label>
                                    <select id="attSessionSelect" class="form-input-custom" onchange="loadAttendanceTrainees()" style="background:white;">
                                        <option value="">Choose a batch or session...</option>
                                    </select>
                                </div>
                                <div>
                                    <label style="display:block; font-size: 0.8rem; font-weight: 700; color: var(--navy); margin-bottom: 6px; text-transform:uppercase;">Attendance Date</label>
                                    <input type="date" id="attDateInput" class="form-input-custom" value="<%= java.time.LocalDate.now() %>" onchange="loadAttendanceSessions()" style="background:white;">
                                </div>
                                <div>
                                    <button type="button" class="btn-card-action" onclick="loadAttendanceSessions()" style="height: 42px; padding: 0 16px;">
                                        <i class="bi bi-arrow-clockwise me-1"></i> Refresh
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Active Attendance Workspace (Shown when session selected) -->
                        <div id="attActiveWorkspace" style="display:none;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px;">
                                <div id="attModeDisplay"></div>
                                <div style="font-size: 0.85rem; color: var(--text-gray); font-weight: 600;">
                                    <span class="badge" style="background:#DCFCE7; color:#166534; font-weight:700;">P = Present</span>
                                    <span class="badge" style="background:#FEE2E2; color:#991B1B; font-weight:700;">A = Absent</span>
                                    <span class="badge" style="background:#FEF3C7; color:#92400E; font-weight:700;">L = Late</span>
                                    <span class="badge" style="background:#E0F2FE; color:#075985; font-weight:700;">E = Excused</span>
                                </div>
                            </div>

                            <!-- 4 Summary Stats -->
                            <div class="attendance-summary-grid">
                                <div class="att-stat-card">
                                    <span class="att-stat-val" id="attTotalTrainees">0</span>
                                    <span class="att-stat-lbl">Total Trainees</span>
                                </div>
                                <div class="att-stat-card">
                                    <span class="att-stat-val text-success" id="attPresentCount">0</span>
                                    <span class="att-stat-lbl" style="color:#16A34A;">Present</span>
                                </div>
                                <div class="att-stat-card">
                                    <span class="att-stat-val text-danger" id="attAbsentCount">0</span>
                                    <span class="att-stat-lbl" style="color:#DC2626;">Absent</span>
                                </div>
                                <div class="att-stat-card">
                                    <span class="att-stat-val text-warning" id="attLateCount">0</span>
                                    <span class="att-stat-lbl" style="color:#D97706;">Late / Excused</span>
                                </div>
                            </div>

                            <!-- Trainee Table -->
                            <div class="table-responsive-custom">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Trainee Details</th>
                                            <th>Attendance Rate</th>
                                            <th>Status Marking</th>
                                            <th>Trainer Notes</th>
                                        </tr>
                                    </thead>
                                    <tbody id="attTraineeListBody">
                                        <!-- Loaded dynamically -->
                                    </tbody>
                                </table>
                            </div>

                            <!-- Bottom Save Bar -->
                            <div style="display: flex; justify-content: flex-end; margin-top: 20px;">
                                <button type="button" class="btn-quick-add" onclick="saveAttendance()">
                                    <i class="bi bi-cloud-arrow-up-fill me-1"></i> Save Attendance Records
                                </button>
                            </div>
                        </div>

                        <!-- No Session Selected Placeholder -->
                        <div id="attNoSessionState" class="empty-box">
                            <i class="bi bi-calendar2-week"></i>
                            <h4>Select a Session to Start Marking Attendance</h4>
                            <p>Pick an offline batch or live online class from the dropdown above to view student rosters and mark attendance.</p>
                        </div>
                    </div>

                    <!-- Sub-View 2: Dynamic QR Engine -->
                    <div id="attViewQr" style="display:none;">
                        <!-- Generator Form -->
                        <div style="background: var(--bg-page); padding: 20px; border-radius: 16px; border: 1px solid var(--border-color); margin-bottom: 24px;">
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; align-items: end;">
                                <div>
                                    <label style="display:block; font-size: 0.85rem; font-weight: 700; color: var(--navy); margin-bottom: 6px;">Select Training Batch *</label>
                                    <select id="qrBatchSelect" class="form-input-custom" style="background:white;">
                                        <c:forEach var="b" items="${batches}">
                                            <option value="${b.id}">${b.name} (${b.style} · ${b.timeSlot})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label style="display:block; font-size: 0.85rem; font-weight: 700; color: var(--navy); margin-bottom: 6px;">Validity Window</label>
                                    <select id="qrDurationSelect" class="form-input-custom" style="background:white;">
                                        <option value="15">15 Minutes (Standard Class Start)</option>
                                        <option value="30">30 Minutes</option>
                                        <option value="60">60 Minutes (Full Class Duration)</option>
                                    </select>
                                </div>
                                <div>
                                    <button type="button" class="btn-quick-add" onclick="generateQrSession()" style="width: 100%; justify-content: center;">
                                        <i class="bi bi-qr-code"></i> Generate Active Session QR
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Active QR Display Area -->
                        <div id="activeQrContainer" style="display: none; background: #FFFFFF; border: 2px solid var(--primary); border-radius: 20px; padding: 32px 24px; text-align: center; max-width: 520px; margin: 0 auto; box-shadow: 0 10px 30px rgba(244,63,94,0.1);">
                            <span class="badge-custom badge-approved" style="margin-bottom: 12px; display: inline-block;">
                                <i class="bi bi-broadcast me-1"></i> Live QR Session Active
                            </span>
                            <h3 id="qrBatchName" style="font-size: 1.2rem; font-weight: 800; color: var(--navy); margin-bottom: 4px;"></h3>
                            <p style="font-size: 0.85rem; color: var(--text-gray); margin-bottom: 20px;">Students can scan this QR code using the Fight D Fear mobile app or enter the code to mark attendance.</p>
                            
                            <div style="background: #FFFFFF; padding: 16px; border-radius: 16px; display: inline-block; box-shadow: 0 4px 16px rgba(0,0,0,0.06); border: 1px solid var(--border-color); margin-bottom: 16px;">
                                <img id="qrCodeImage" src="" alt="Session QR Code" style="width: 200px; height: 200px; display: block;">
                            </div>

                            <div style="margin-bottom: 20px;">
                                <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-gray); text-transform: uppercase;">Session Check-in Code:</span>
                                <div id="qrTokenDisplay" style="font-family: monospace; font-size: 1.3rem; font-weight: 800; color: var(--primary); letter-spacing: 2px; margin-top: 4px;"></div>
                            </div>

                            <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                <button type="button" class="btn-card-action" onclick="generateQrSession()">
                                    <i class="bi bi-arrow-clockwise me-1"></i> Refresh QR
                                </button>
                                <button type="button" class="btn-card-action danger" onclick="closeActiveQrSession()" style="background:#DC2626;color:white;">
                                    <i class="bi bi-stop-circle me-1"></i> End Session
                                </button>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Tab 5: Belt Grading & Skill Assessments -->
            <div id="tab-grading" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-award-fill text-danger"></i> Belt Grading & Skill Assessments</div>
                        <button class="btn-quick-add" onclick="openScheduleGradingModal()">
                            <i class="bi bi-calendar-plus me-1"></i> Schedule Belt Exam
                        </button>
                    </div>

                    <div style="margin-bottom: 24px; color: var(--text-gray); font-size: 0.9rem;">
                        Evaluate student forms, katas, striking, grappling, and sparring. Submitting a passed assessment promotes the trainee's official belt rank and generates a digital certificate.
                    </div>

                    <!-- Grading Table -->
                    <div class="table-responsive-custom">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Discipline</th>
                                    <th>Rank Target</th>
                                    <th>Scheduled / Exam Date</th>
                                    <th>Overall Score</th>
                                    <th>Status</th>
                                    <th style="text-align:right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="gradingTableBody">
                                <tr><td colspan="7" style="text-align:center; padding: 24px; color: var(--text-gray);">Loading grading assessments...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Tab 6: Instructor Staff -->
            <div id="tab-instructors" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div class="panel-title"><i class="bi bi-person-badge-fill text-danger"></i> Instructor Staff Roster</div>
                        <button class="btn-quick-add" onclick="openAddInstructorModal()">
                            <i class="bi bi-person-plus me-1"></i> Add Instructor
                        </button>
                    </div>
                    
                    <div id="instructorGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; margin-top: 16px;">
                        <!-- Injected via JavaScript -->
                    </div>
                </div>
            </div>

            <!-- Tab 7: Live Classes -->
            <div id="tab-live" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div>
                            <div class="panel-title"><i class="bi bi-camera-video-fill text-danger"></i> Virtual Dojo — Live Classes</div>
                            <p style="font-size:0.85rem; color:var(--text-gray); margin:4px 0 0 0;">Schedule, host, and conduct live remote martial arts and self-defense sessions.</p>
                        </div>
                        <button type="button" class="btn-quick-add" onclick="openCreateLiveClassModal()">
                            <i class="bi bi-plus-circle-fill me-1"></i> Schedule Live Class
                        </button>
                    </div>

                    <!-- Live Classes Grid -->
                    <div class="live-cards-grid" id="liveClassesGridContainer">
                        <c:set var="hasLiveClasses" value="false" />
                        <c:forEach var="oc" items="${onlineClasses}">
                            <c:if test="${oc.status == 'UPCOMING' || oc.status == 'LIVE'}">
                                <c:set var="hasLiveClasses" value="true" />
                                <div class="live-card">
                                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                                        <span class="live-card-badge ${oc.status == 'LIVE' ? 'live' : 'upcoming'}">
                                            <i class="bi ${oc.status == 'LIVE' ? 'bi-broadcast' : 'bi-clock-history'}"></i> ${oc.status}
                                        </span>
                                        <div style="display:flex; align-items:center; gap:8px;">
                                            <span style="font-size:0.8rem; font-weight:700; color:var(--text-gray);">${oc.date}</span>
                                            <button type="button" class="btn-card-action danger" onclick="deleteLiveClass(${oc.id})" title="Delete Class" style="padding:4px 8px;">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <h4 style="font-size:1.1rem; font-weight:800; color:var(--navy); margin:0 0 4px;">${oc.title}</h4>
                                    <div style="font-size:0.82rem; color:var(--primary); font-weight:700; margin-bottom:12px;">
                                        ${oc.martialArtType} · <c:out value="${oc.batch != null ? oc.batch.name : 'All Batches'}"/>
                                    </div>
                                    
                                    <div style="display:flex; flex-direction:column; gap:6px; margin-bottom:16px; font-size:0.85rem; color:var(--text-gray);">
                                        <div><i class="bi bi-clock me-2 text-danger"></i> ${oc.startTime} - ${oc.endTime}</div>
                                        <div><i class="bi bi-tag me-2 text-muted"></i> ${not empty oc.sessionType ? oc.sessionType : 'Group Session'}</div>
                                        <div><i class="bi bi-people me-2 text-muted"></i> Max Trainees: ${oc.maxStudents}</div>
                                    </div>

                                    <c:if test="${not empty oc.notes}">
                                        <div style="background:#F8FAFC; border:1px solid var(--border-color); border-radius:10px; padding:10px; font-size:0.8rem; color:var(--text-gray); margin-bottom:16px;">
                                            <i class="bi bi-info-circle text-primary me-1"></i> ${oc.notes}
                                        </div>
                                    </c:if>

                                    <div style="margin-top:auto; display:flex; flex-direction:column; gap:8px;">
                                        <c:if test="${oc.status == 'UPCOMING'}">
                                            <button type="button" class="btn-quick-add" onclick="startLiveClass(${oc.id})" style="width:100%; justify-content:center;">
                                                <i class="bi bi-play-circle-fill me-1"></i> Start Live Class
                                            </button>
                                        </c:if>
                                        <c:if test="${oc.status == 'LIVE'}">
                                            <a href="${oc.meetingLink}" target="_blank" class="btn-card-action primary" style="width:100%; justify-content:center; padding:10px; font-size:0.88rem;">
                                                <i class="bi bi-box-arrow-up-right me-1"></i> Join Meeting Room
                                            </a>
                                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px;">
                                                <button type="button" class="btn-card-action" onclick="openLiveControlPanel(${oc.id}, '${oc.title}')" style="justify-content:center;">
                                                    <i class="bi bi-people-fill me-1"></i> Control Room
                                                </button>
                                                <button type="button" class="btn-card-action danger" onclick="endLiveClass(${oc.id})" style="justify-content:center;">
                                                    <i class="bi bi-stop-circle-fill me-1"></i> End Session
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <c:if test="${not hasLiveClasses}">
                        <div class="empty-box" style="margin-top:20px;">
                            <i class="bi bi-camera-video"></i>
                            <h4>No Live Classes Scheduled</h4>
                            <p>Host online training sessions for women safety and remote martial arts education.</p>
                            <button type="button" class="btn-quick-add" onclick="openCreateLiveClassModal()">
                                <i class="bi bi-plus-circle-fill me-1"></i> Schedule Your First Class
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Tab 8: Past Sessions & Recordings -->
            <div id="tab-past-sessions" class="tab-section">
                <div class="content-panel">
                    <div class="panel-header">
                        <div>
                            <div class="panel-title"><i class="bi bi-clock-history text-danger"></i> Past Sessions & Recordings</div>
                            <p style="font-size:0.85rem; color:var(--text-gray); margin:4px 0 0 0;">View completed training sessions, attendance records, and upload video links for students.</p>
                        </div>
                    </div>

                    <!-- Past Sessions Grid -->
                    <div class="live-cards-grid" id="pastSessionsGridContainer">
                        <c:set var="hasCompletedClasses" value="false" />
                        <c:forEach var="oc" items="${onlineClasses}">
                            <c:if test="${oc.status == 'COMPLETED'}">
                                <c:set var="hasCompletedClasses" value="true" />
                                <div class="live-card">
                                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">
                                        <span class="live-card-badge completed">
                                            <i class="bi bi-check-circle-fill"></i> Completed
                                        </span>
                                        <span style="font-size:0.8rem; font-weight:700; color:var(--text-gray);">${oc.date}</span>
                                    </div>
                                    <h4 style="font-size:1.1rem; font-weight:800; color:var(--navy); margin:0 0 4px;">${oc.title}</h4>
                                    <div style="font-size:0.82rem; color:var(--primary); font-weight:700; margin-bottom:12px;">
                                        ${oc.martialArtType} · <c:out value="${oc.batch != null ? oc.batch.name : 'Batch Session'}"/>
                                    </div>

                                    <div style="display:flex; flex-direction:column; gap:6px; margin-bottom:16px; font-size:0.85rem; color:var(--text-gray);">
                                        <div><i class="bi bi-clock me-2 text-muted"></i> ${oc.startTime} - ${oc.endTime}</div>
                                        <div><i class="bi bi-people me-2 text-muted"></i> Max Students: ${oc.maxStudents}</div>
                                        <c:if test="${not empty oc.recordingLink}">
                                            <div><i class="bi bi-link-45deg me-2 text-success"></i> <a href="${oc.recordingLink}" target="_blank" style="color:var(--primary); font-weight:600; text-decoration:none;">View Recording URL &rarr;</a></div>
                                        </c:if>
                                    </div>

                                    <div style="margin-top:auto; display:flex; gap:8px;">
                                        <button type="button" class="btn-card-action primary" onclick="openUploadRecordingModal(${oc.id}, '${oc.recordingLink}')" style="width:100%; justify-content:center; padding:10px;">
                                            <i class="bi bi-cloud-upload-fill me-1"></i> ${empty oc.recordingLink ? 'Upload Recording Link' : 'Update Recording Link'}
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <c:if test="${not hasCompletedClasses}">
                        <div class="empty-box" style="margin-top:20px;">
                            <i class="bi bi-journal-check"></i>
                            <h4>No Completed Sessions Recorded Yet</h4>
                            <p>When you finish live classes or sessions, they will automatically appear here with student attendance history and video recordings.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Tab 8: Finance -->
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

            <!-- Tab 9: Profile -->
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
                                <option value="Women Only (All Ages)">Women Only (All Ages)</option>
                                <option value="Girls (5-12)">Girls (5-12)</option>
                                <option value="Teen Girls (13-18)">Teen Girls (13-18)</option>
                                <option value="Adult Women (18+)">Adult Women (18+)</option>
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
                <button type="button" class="btn-quick-add" onclick="closeBatchDetailsModal()">Close</button>
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
    <!-- SCHEDULE BELT GRADING MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="scheduleGradingOverlay">
        <div class="modal-window" style="max-width: 540px;">
            <div class="modal-header-custom">
                <h3><i class="bi bi-calendar-plus me-2"></i> Schedule Belt Examination</h3>
                <button type="button" class="btn-modal-close" onclick="closeScheduleGradingModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="scheduleGradingForm" onsubmit="handleScheduleGradingSubmit(event)">
                <div class="modal-body-custom">
                    <div class="form-group-custom">
                        <label class="form-label-custom">Select Student / Trainee *</label>
                        <select id="gradStudentSelect" class="form-input-custom" required>
                            <c:forEach var="e" items="${enrollments}">
                                <c:if test="${e.user != null}">
                                    <option value="${e.user.id}">${not empty e.fullName ? e.fullName : e.user.fullName} (${e.batch != null ? e.batch.name : 'Enrolled'}) · Current: ${not empty e.currentBelt ? e.currentBelt : 'White'}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Discipline / Style *</label>
                            <select id="gradDisciplineSelect" class="form-input-custom" required>
                                <option value="Karate">Karate</option>
                                <option value="Taekwondo">Taekwondo</option>
                                <option value="Judo">Judo</option>
                                <option value="Boxing">Boxing</option>
                                <option value="MMA">MMA</option>
                                <option value="Kickboxing">Kickboxing</option>
                                <option value="Self-Defence">Self-Defence / Krav Maga</option>
                                <option value="Kung Fu">Kung Fu</option>
                                <option value="Kalaripayattu">Kalaripayattu</option>
                                <option value="Other">Other Martial Art</option>
                            </select>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Target Belt Rank *</label>
                            <select id="gradTargetBelt" class="form-input-custom" required>
                                <option value="Yellow">Yellow Belt</option>
                                <option value="Orange">Orange Belt</option>
                                <option value="Green">Green Belt</option>
                                <option value="Blue">Blue Belt</option>
                                <option value="Purple">Purple Belt</option>
                                <option value="Brown">Brown Belt</option>
                                <option value="Red">Red Belt</option>
                                <option value="Black">Black Belt (1st Dan)</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Examination Date *</label>
                            <input type="date" id="gradDate" class="form-input-custom" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Examiner / Master Trainer</label>
                            <input type="text" id="gradTrainer" class="form-input-custom" value="${not empty loggedCentre.contactPerson ? loggedCentre.contactPerson : loggedCentre.name}" placeholder="Trainer Name">
                        </div>
                    </div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeScheduleGradingModal()">Cancel</button>
                    <button type="submit" id="btnSubmitScheduleGrading" class="btn-quick-add">
                        <i class="bi bi-check-circle-fill"></i> Schedule Examination
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- CONDUCT & SCORE ASSESSMENT MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="scoreGradingOverlay">
        <div class="modal-window" style="max-width: 620px;">
            <div class="modal-header-custom">
                <h3 id="scoreModalTitle"><i class="bi bi-award me-2"></i> Grade Student Technique</h3>
                <button type="button" class="btn-modal-close" onclick="closeScoreGradingModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="scoreGradingForm" onsubmit="handleScoreGradingSubmit(event)">
                <div class="modal-body-custom">
                    <input type="hidden" id="scoreAssessmentId">
                    <div id="scoreCriteriaContainer" style="display: flex; flex-direction: column; gap: 14px; margin-bottom: 20px;">
                        <!-- Injected discipline-specific sliders -->
                    </div>
                    <div class="form-group-custom">
                        <label class="form-label-custom">Examiner Feedback / Technique Remarks</label>
                        <textarea id="scoreRemarks" class="form-input-custom" rows="2" placeholder="e.g. Excellent kata precision; work on hip rotation during roundhouse kicks."></textarea>
                    </div>
                    <div style="background: #F8FAFC; padding: 14px; border-radius: 10px; border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <span style="font-weight: 700; color: var(--navy); font-size: 0.9rem; display:block;">Instant Promotion & Certificate</span>
                            <span style="font-size: 0.78rem; color: var(--text-gray);">If score is ≥ 60%, automatically promote student and issue digital certificate.</span>
                        </div>
                        <input type="checkbox" id="scoreAutoPromote" checked style="width: 18px; height: 18px; accent-color: var(--primary);">
                    </div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeScoreGradingModal()">Cancel</button>
                    <button type="submit" id="btnSubmitScore" class="btn-quick-add">
                        <i class="bi bi-award-fill"></i> Submit Assessment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- ADD INSTRUCTOR MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="addInstructorOverlay">
        <div class="modal-window" style="max-width: 500px;">
            <div class="modal-header-custom">
                <h3><i class="bi bi-person-plus me-2"></i> Add Instructor Staff</h3>
                <button type="button" class="btn-modal-close" onclick="closeAddInstructorModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="addInstructorForm" onsubmit="handleAddInstructorSubmit(event)">
                <div class="modal-body-custom">
                    <div class="form-group-custom">
                        <label class="form-label-custom">Instructor Full Name *</label>
                        <input type="text" id="instName" class="form-input-custom" placeholder="e.g. Sensei Rahul Sharma" required>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Designation *</label>
                            <input type="text" id="instDesignation" class="form-input-custom" placeholder="e.g. Chief Instructor / Black Belt Coach" value="Instructor" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Experience</label>
                            <input type="text" id="instExp" class="form-input-custom" placeholder="e.g. 5+ years" value="3+ years">
                        </div>
                    </div>
                    <div class="form-group-custom">
                        <label class="form-label-custom">Specialization / Core Style</label>
                        <input type="text" id="instSpec" class="form-input-custom" placeholder="e.g. Kumite, Katas & Self-Defense" value="General Martial Arts">
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Phone Number</label>
                            <input type="tel" id="instPhone" class="form-input-custom" placeholder="10 digits">
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Email Address</label>
                            <input type="email" id="instEmail" class="form-input-custom" placeholder="coach@example.com">
                        </div>
                    </div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeAddInstructorModal()">Cancel</button>
                    <button type="submit" id="btnSubmitInst" class="btn-quick-add">
                        <i class="bi bi-check-circle-fill"></i> Save Instructor
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- SCHEDULE LIVE CLASS MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="createLiveClassModalOverlay">
        <div class="modal-window" style="max-width: 620px;">
            <div class="modal-header-custom">
                <h3><i class="bi bi-camera-video me-2"></i> Schedule Live Training Session</h3>
                <button type="button" class="btn-modal-close" onclick="closeCreateLiveClassModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="createLiveClassForm" onsubmit="handleCreateLiveClassSubmit(event)">
                <div class="modal-body-custom">
                    <div class="form-group-custom">
                        <label class="form-label-custom">Class Title *</label>
                        <input type="text" id="liveTitle" class="form-input-custom" placeholder="e.g. Morning Kickboxing Essentials" required>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Associated Batch *</label>
                            <select id="liveBatchSelect" class="form-input-custom" required>
                                <c:forEach var="b" items="${batches}">
                                    <option value="${b.id}">${b.name} (${b.style})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Session Type *</label>
                            <select id="liveSessionType" class="form-input-custom" required>
                                <option value="Group Session">Group Session</option>
                                <option value="Personal 1-to-1 Session">Personal 1-to-1 Session</option>
                                <option value="Webinar / Workshop">Webinar / Workshop</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Martial Art Type *</label>
                            <input type="text" id="liveMartialArtType" class="form-input-custom" placeholder="e.g. Karate / Self-Defense" value="Karate" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Session Date *</label>
                            <input type="date" id="liveDate" class="form-input-custom" value="<%= java.time.LocalDate.now() %>" required>
                        </div>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Start Time *</label>
                            <input type="time" id="liveStartTime" class="form-input-custom" value="18:00" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">End Time *</label>
                            <input type="time" id="liveEndTime" class="form-input-custom" value="19:00" required>
                        </div>
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group-custom">
                            <label class="form-label-custom">Jitsi / Meeting Link *</label>
                            <input type="url" id="liveMeetingLink" class="form-input-custom" placeholder="https://meet.jit.si/..." value="https://meet.jit.si/FightDFear-Live-<%= System.currentTimeMillis() %>" required>
                        </div>
                        <div class="form-group-custom">
                            <label class="form-label-custom">Max Trainees *</label>
                            <input type="number" id="liveMaxStudents" class="form-input-custom" value="20" min="1" max="100" required>
                        </div>
                    </div>
                    <div class="form-group-custom">
                        <label class="form-label-custom">Session Notes (Equipment, Dress Code etc.)</label>
                        <textarea id="liveNotes" class="form-input-custom" rows="2" placeholder="e.g. Please bring your hand wraps and water bottle."></textarea>
                    </div>
                    <div class="form-group-custom">
                        <label class="form-label-custom">Description</label>
                        <textarea id="liveDescription" class="form-input-custom" rows="2" placeholder="Provide overview or workout plan for trainees..."></textarea>
                    </div>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeCreateLiveClassModal()">Cancel</button>
                    <button type="submit" id="btnSubmitLiveClass" class="btn-quick-add">
                        <i class="bi bi-broadcast me-1"></i> Schedule Live Session
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- LIVE SESSION CONTROL ROOM MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="liveControlPanelOverlay">
        <div class="modal-window" style="max-width: 600px;">
            <div class="modal-header-custom">
                <h3><i class="bi bi-sliders me-2"></i> Live Control Room: <span id="ctrlSessionTitle" style="color:var(--primary);"></span></h3>
                <button type="button" class="btn-modal-close" onclick="closeLiveControlPanel()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div class="modal-body-custom">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                    <span style="font-weight:700; font-size:0.9rem; color:var(--navy);">Connected Trainees</span>
                    <span id="ctrlTraineeCountBadge" class="badge" style="background:#DCFCE7; color:#166534; font-weight:700;">0 Online</span>
                </div>
                <div id="ctrlJoinedTraineeList" style="max-height: 280px; overflow-y: auto; border: 1px solid var(--border-color); border-radius: 12px; padding: 8px; background: #F8FAFC; margin-bottom: 20px;">
                    <div style="text-align: center; padding: 24px; color: var(--text-gray);">Checking live trainees...</div>
                </div>

                <div style="background:#FFFFFF; border:1px solid var(--border-color); border-radius:12px; padding:16px;">
                    <span style="font-weight:700; font-size:0.85rem; color:var(--navy); display:block; margin-bottom:10px;">Quick Session Actions</span>
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                        <button type="button" class="btn-card-action" onclick="alert('All remote student audio muted.');">
                            <i class="bi bi-mic-mute-fill text-danger me-1"></i> Mute All
                        </button>
                        <button type="button" class="btn-card-action" onclick="alert('Session recording started.');">
                            <i class="bi bi-record-circle-fill text-danger me-1"></i> Start Recording
                        </button>
                    </div>
                </div>
            </div>
            <div class="modal-footer-custom">
                <button type="button" class="btn-card-action" onclick="closeLiveControlPanel()">Close Window</button>
                <button type="button" id="ctrlEndSessionBtn" class="btn-card-action danger" style="background:#DC2626; color:white;">
                    <i class="bi bi-stop-circle-fill me-1"></i> End Live Session
                </button>
            </div>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- UPLOAD SESSION RECORDING MODAL -->
    <!-- ========================================================================= -->
    <div class="modal-overlay" id="uploadRecordingOverlay">
        <div class="modal-window" style="max-width: 480px;">
            <div class="modal-header-custom">
                <h3><i class="bi bi-cloud-arrow-up me-2"></i> Session Recording URL</h3>
                <button type="button" class="btn-modal-close" onclick="closeUploadRecordingModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <form id="uploadRecordingForm" onsubmit="handleUploadRecordingSubmit(event)">
                <div class="modal-body-custom">
                    <input type="hidden" id="recClassId">
                    <div class="form-group-custom">
                        <label class="form-label-custom">Recording URL (YouTube / Google Drive / Vimeo) *</label>
                        <input type="url" id="recLinkInput" class="form-input-custom" placeholder="https://youtube.com/watch?v=... or https://drive.google.com/..." required>
                    </div>
                    <p style="font-size:0.8rem; color:var(--text-gray); margin-bottom:0;">
                        Trainees who were enrolled or missed the session will be able to watch this recorded class on their martial arts portal.
                    </p>
                </div>
                <div class="modal-footer-custom">
                    <button type="button" class="btn-card-action" onclick="closeUploadRecordingModal()">Cancel</button>
                    <button type="submit" id="btnSubmitRec" class="btn-quick-add">
                        <i class="bi bi-check-circle-fill me-1"></i> Save Recording
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================================================= -->
    <!-- JAVASCRIPT: TAB, QR, BELT GRADING & STAFF CONTROLLERS -->
    <!-- ========================================================================= -->
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const batchesData = ${not empty batchesJson ? batchesJson : '[]'};

        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('show');
            document.querySelector('.sidebar-overlay').classList.toggle('show');
        }

        function switchTab(tabId, btn) {
            document.querySelectorAll('.tab-section').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));

            const target = document.getElementById('tab-' + tabId);
            if (target) target.classList.add('active');

            if (btn && btn.classList.contains('nav-item')) {
                btn.classList.add('active');
            } else {
                const matchingNav = Array.from(document.querySelectorAll('.sidebar-nav .nav-item')).find(el => {
                    const oc = el.getAttribute('onclick');
                    return oc && oc.includes("'" + tabId + "'");
                });
                if (matchingNav) matchingNav.classList.add('active');
            }

            if (window.innerWidth <= 900) {
                const sidebar = document.querySelector('.sidebar');
                const overlay = document.querySelector('.sidebar-overlay');
                if (sidebar) sidebar.classList.remove('show', 'open');
                if (overlay) overlay.classList.remove('show', 'open');
            }

            if (tabId === 'attendance') {
                loadAttendanceSessions();
            } else if (tabId === 'grading') {
                loadGradingAssessments();
            } else if (tabId === 'instructors') {
                loadInstructors();
            }
        }

        // ==========================================
        // DYNAMIC QR ATTENDANCE
        // ==========================================
        let currentQrSessionId = null;

        function normalizeStyleToken(value) {
            return (value || '').toLowerCase().replace(/[^a-z0-9]/g, '');
        }

        function filterBatchesByStyle(style, chipEl) {
            document.querySelectorAll('#disciplineFilterBar .discipline-chip').forEach(c => c.classList.remove('active'));
            if (chipEl) chipEl.classList.add('active');
            else {
                const match = Array.from(document.querySelectorAll('#disciplineFilterBar .discipline-chip'))
                    .find(c => (c.getAttribute('data-style') || '') === (style || ''));
                if (match) match.classList.add('active');
            }
            const selected = normalizeStyleToken(style);
            const cards = document.querySelectorAll('#batchCardsContainer .batch-card');
            let visible = 0;
            cards.forEach(card => {
                const cardStyle = normalizeStyleToken(card.getAttribute('data-style'));
                const show = !selected || (cardStyle.length > 0 && cardStyle === selected);
                card.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            const emptyMsg = document.getElementById('disciplineEmptyMsg');
            const grid = document.getElementById('batchCardsContainer');
            if (emptyMsg) emptyMsg.style.display = (cards.length > 0 && visible === 0) ? 'block' : 'none';
            if (grid) grid.style.display = (visible === 0 && selected) ? 'none' : '';
        }

        let currentReviewEnrollmentId = null;

        function openEnrollmentReview(enrollmentId) {
            currentReviewEnrollmentId = enrollmentId;
            const source = document.getElementById('enrollment-review-' + enrollmentId);
            const body = document.getElementById('enrollmentReviewBody');
            const actions = document.getElementById('enrollmentReviewActions');
            const listShell = document.getElementById('studentsListShell');
            const reviewShell = document.getElementById('enrollmentReviewShell');
            if (!source || !body || !reviewShell) {
                alert('Application details not available.');
                return;
            }
            body.innerHTML = source.innerHTML;
            const status = (source.getAttribute('data-status') || '').toUpperCase();
            if (actions) {
                actions.style.display = 'flex';
                const rejectBtn = document.getElementById('reviewRejectBtn');
                const approveBtn = document.getElementById('reviewApproveBtn');
                const showDecide = status === 'PENDING';
                if (rejectBtn) rejectBtn.style.display = showDecide ? '' : 'none';
                if (approveBtn) approveBtn.style.display = showDecide ? '' : 'none';
            }
            if (listShell) listShell.classList.add('is-hidden');
            reviewShell.classList.add('is-open');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function closeEnrollmentReview() {
            const listShell = document.getElementById('studentsListShell');
            const reviewShell = document.getElementById('enrollmentReviewShell');
            const body = document.getElementById('enrollmentReviewBody');
            const actions = document.getElementById('enrollmentReviewActions');
            if (reviewShell) reviewShell.classList.remove('is-open');
            if (listShell) listShell.classList.remove('is-hidden');
            if (body) body.innerHTML = '';
            if (actions) actions.style.display = 'none';
            currentReviewEnrollmentId = null;
        }

        function approveFromReview() {
            if (currentReviewEnrollmentId == null) return;
            updateEnrollmentStatus(currentReviewEnrollmentId, 'APPROVED');
        }

        function rejectFromReview() {
            if (currentReviewEnrollmentId == null) return;
            updateEnrollmentStatus(currentReviewEnrollmentId, 'REJECTED');
        }

        function filterStudentRows(filter, btn) {
            document.querySelectorAll('#studentStatusTabs .btn').forEach(b => {
                b.style.background = '#fff';
                b.style.color = '#0F172A';
                b.style.border = '1px solid #E2E8F0';
                b.classList.remove('active');
            });
            if (btn) {
                btn.style.background = '#FFF1F2';
                btn.style.color = '#F43F5E';
                btn.style.border = '1px solid #FECDD3';
                btn.classList.add('active');
            }
            document.querySelectorAll('.student-row').forEach(row => {
                const st = (row.getAttribute('data-status') || '').toUpperCase();
                const pay = (row.getAttribute('data-payment') || '').toUpperCase();
                let show = true;
                if (filter === 'PENDING') show = st === 'PENDING';
                else if (filter === 'REJECTED') show = st === 'REJECTED';
                else if (filter === 'ACTIVE') show = (st === 'APPROVED' || st === 'IN_PROGRESS') && (pay === 'PAID' || st === 'IN_PROGRESS');
                else if (filter === 'ALL') show = true;
                row.style.display = show ? '' : 'none';
            });
        }

        async function updateEnrollmentStatus(enrollmentId, status) {
            if (!confirm(status === 'APPROVED' ? 'Approve this application?' : 'Reject this application?')) return;
            try {
                const res = await fetch('${pageContext.request.contextPath}/enrollment/api/' + enrollmentId + '/status', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ status: status })
                });
                const data = await res.json();
                if (!res.ok || data.success === false) {
                    alert(data.error || 'Could not update status');
                    return;
                }
                location.reload();
            } catch (e) {
                alert('Network error updating status');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            filterStudentRows('PENDING', document.querySelector('#studentStatusTabs .btn.active'));
        });

        function generateQrSession() {
            const batchId = document.getElementById('qrBatchSelect').value;
            const duration = document.getElementById('qrDurationSelect').value;
            if (!batchId) { alert('Please select a batch first'); return; }

            fetch(contextPath + '/centres/api/qr-session', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ batchId: batchId, duration: duration })
            })
            .then(r => r.json())
            .then(res => {
                if (res.success) {
                    currentQrSessionId = res.sessionId;
                    document.getElementById('activeQrContainer').style.display = 'block';
                    document.getElementById('qrBatchName').innerText = res.batchName + ' (' + res.sessionDate + ')';
                    document.getElementById('qrTokenDisplay').innerText = res.token;
                    
                    const qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + encodeURIComponent(res.token);
                    document.getElementById('qrCodeImage').src = qrUrl;
                    window.scrollTo({ top: document.getElementById('activeQrContainer').offsetTop - 60, behavior: 'smooth' });
                } else {
                    alert(res.error || 'Failed to start QR session');
                }
            })
            .catch(err => alert('QR request error: ' + err));
        }

        function closeActiveQrSession() {
            if (!currentQrSessionId) return;
            fetch(contextPath + '/centres/api/qr-session/' + currentQrSessionId + '/close', { method: 'POST' })
                .then(r => r.json())
                .then(res => {
                    alert(res.message || 'QR session closed');
                    document.getElementById('activeQrContainer').style.display = 'none';
                    currentQrSessionId = null;
                });
        }

        // ==========================================
        // BELT GRADING & SKILL ASSESSMENTS
        // ==========================================
        function loadGradingAssessments() {
            fetch(contextPath + '/centres/api/gradings')
                .then(r => r.json())
                .then(res => {
                    const tbody = document.getElementById('gradingTableBody');
                    if (!res.success || !res.gradings || res.gradings.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:24px; color:var(--text-gray);"><i class="bi bi-info-circle me-1"></i> No belt grading examinations scheduled yet. Click <strong>Schedule Belt Exam</strong> to evaluate a trainee.</td></tr>';
                        return;
                    }

                    let html = '';
                    res.gradings.forEach(g => {
                        const statusClass = g.status === 'PROMOTED' ? 'badge-approved' : (g.status === 'PASSED' ? 'badge-approved' : (g.status === 'FAILED' ? 'badge-rejected' : 'badge-pending'));
                        html += '<tr>' +
                            '<td><strong>' + (g.studentName || 'Student') + '</strong></td>' +
                            '<td>' + (g.discipline || 'Martial Arts') + '</td>' +
                            '<td><span style="font-weight:700; color:var(--primary);">' + (g.targetBelt || 'Yellow') + ' Belt</span> <span style="font-size:0.75rem; color:var(--text-gray);">(from ' + (g.previousBelt || 'White') + ')</span></td>' +
                            '<td>' + (g.assessmentDate || g.scheduledDate || 'Scheduled') + '</td>' +
                            '<td>' + (g.overallScore != null ? '<strong>' + g.overallScore + '/100</strong>' : '—') + '</td>' +
                            '<td><span class="badge-custom ' + statusClass + '">' + g.status + '</span></td>' +
                            '<td style="text-align:right;">';
                        
                        if (g.status === 'SCHEDULED') {
                            html += '<button class="btn-card-action primary" onclick="openScoreGradingModal(' + g.id + ', \'' + g.discipline + '\', \'' + g.studentName + '\')"><i class="bi bi-pencil-square"></i> Grade</button>';
                        } else if (g.status === 'PASSED') {
                            html += '<button class="btn-card-action primary" onclick="approvePromotion(' + g.id + ')"><i class="bi bi-check-circle"></i> Approve Promotion</button>';
                        } else if (g.status === 'PROMOTED' && g.certificatePath) {
                            html += '<span class="badge-custom badge-approved"><i class="bi bi-award-fill me-1"></i> Certified</span>';
                        }
                        html += '</td></tr>';
                    });
                    tbody.innerHTML = html;
                })
                .catch(() => {
                    document.getElementById('gradingTableBody').innerHTML = '<tr><td colspan="7" style="text-align:center; color:var(--error); padding:20px;">Could not load assessments</td></tr>';
                });
        }

        function openScheduleGradingModal() {
            document.getElementById('gradDate').value = new Date().toISOString().split('T')[0];
            document.getElementById('scheduleGradingOverlay').classList.add('open');
        }

        function closeScheduleGradingModal() {
            document.getElementById('scheduleGradingOverlay').classList.remove('open');
        }

        function handleScheduleGradingSubmit(e) {
            e.preventDefault();
            const payload = {
                studentId: document.getElementById('gradStudentSelect').value,
                discipline: document.getElementById('gradDisciplineSelect').value,
                targetBelt: document.getElementById('gradTargetBelt').value,
                scheduledDate: document.getElementById('gradDate').value,
                trainerName: document.getElementById('gradTrainer').value.trim()
            };

            fetch(contextPath + '/centres/api/gradings/schedule', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
            .then(r => r.json())
            .then(res => {
                if (res.success) {
                    closeScheduleGradingModal();
                    loadGradingAssessments();
                    alert('Belt grading exam scheduled successfully!');
                } else {
                    alert(res.error || 'Failed to schedule');
                }
            });
        }

        function openScoreGradingModal(id, discipline, studentName) {
            document.getElementById('scoreAssessmentId').value = id;
            document.getElementById('scoreModalTitle').innerHTML = '<i class="bi bi-award me-2"></i> Grade ' + studentName + ' (' + discipline + ')';
            
            fetch(contextPath + '/centres/api/grading/criteria?discipline=' + encodeURIComponent(discipline))
                .then(r => r.json())
                .then(res => {
                    const container = document.getElementById('scoreCriteriaContainer');
                    let html = '';
                    const criteria = res.criteria || ['Stance', 'Technique', 'Execution', 'Conditioning', 'Discipline'];
                    criteria.forEach((c, idx) => {
                        const safeId = 'crit_' + idx;
                        html += '<div>' +
                            '<div style="display:flex; justify-content:space-between; font-size:0.85rem; font-weight:700; color:var(--navy); margin-bottom:4px;">' +
                            '<span>' + c + '</span>' +
                            '<span id="val_' + safeId + '" style="color:var(--primary); font-weight:800;">80/100</span>' +
                            '</div>' +
                            '<input type="range" id="' + safeId + '" data-name="' + c + '" min="0" max="100" value="80" style="width:100%; accent-color:var(--primary);" oninput="document.getElementById(\'val_' + safeId + '\').innerText = this.value + \'/100\'">' +
                            '</div>';
                    });
                    container.innerHTML = html;
                    document.getElementById('scoreGradingOverlay').classList.add('open');
                });
        }

        function closeScoreGradingModal() {
            document.getElementById('scoreGradingOverlay').classList.remove('open');
        }

        function handleScoreGradingSubmit(e) {
            e.preventDefault();
            const id = document.getElementById('scoreAssessmentId').value;
            const scores = {};
            document.querySelectorAll('#scoreCriteriaContainer input[type="range"]').forEach(input => {
                scores[input.getAttribute('data-name')] = parseInt(input.value);
            });

            const payload = {
                scores: scores,
                remarks: document.getElementById('scoreRemarks').value.trim(),
                autoPromote: document.getElementById('scoreAutoPromote').checked
            };

            fetch(contextPath + '/centres/api/gradings/' + id + '/score', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
            .then(r => r.json())
            .then(res => {
                if (res.success) {
                    closeScoreGradingModal();
                    loadGradingAssessments();
                    alert(res.message);
                } else {
                    alert(res.error || 'Failed to submit score');
                }
            });
        }

        function approvePromotion(id) {
            if (confirm('Approve promotion and issue official digital Belt Promotion Certificate?')) {
                fetch(contextPath + '/centres/api/gradings/' + id + '/promote', { method: 'POST' })
                    .then(r => r.json())
                    .then(res => {
                        if (res.success) {
                            loadGradingAssessments();
                            alert(res.message);
                        } else {
                            alert(res.error || 'Approval failed');
                        }
                    });
            }
        }

        // ==========================================
        // INSTRUCTOR STAFF ROSTER
        // ==========================================
        function loadInstructors() {
            fetch(contextPath + '/centres/api/instructors')
                .then(r => r.json())
                .then(res => {
                    const grid = document.getElementById('instructorGrid');
                    if (!res.success || !res.instructors || res.instructors.length === 0) {
                        grid.innerHTML = '<div style="grid-column: 1 / -1; text-align:center; padding:32px; background:var(--bg-page); border-radius:16px; color:var(--text-gray);">' +
                            '<i class="bi bi-person-badge" style="font-size:2rem; display:block; margin-bottom:8px;"></i> No additional assistant instructors registered yet.<br>Click <strong>Add Instructor</strong> to build your coaching staff.</div>';
                        return;
                    }

                    let html = '';
                    res.instructors.forEach(inst => {
                        html += '<div style="background:white; border:1px solid var(--border-color); border-radius:16px; padding:20px; box-shadow:0 4px 12px rgba(0,0,0,0.02);">' +
                            '<div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:10px;">' +
                            '<div><h4 style="font-size:1rem; font-weight:800; color:var(--navy); margin-bottom:2px;">' + inst.name + '</h4>' +
                            '<span style="font-size:0.8rem; font-weight:700; color:var(--primary);">' + (inst.designation || 'Instructor') + '</span></div>' +
                            '<button class="btn-card-action danger" onclick="removeInstructor(' + inst.id + ')" style="padding:4px 8px; font-size:0.75rem;"><i class="bi bi-trash"></i></button>' +
                            '</div>' +
                            '<div style="font-size:0.82rem; color:var(--text-gray); line-height:1.5;">' +
                            '<div><strong>Specialization:</strong> ' + (inst.specialization || 'General') + '</div>' +
                            '<div><strong>Experience:</strong> ' + (inst.experienceYears || '1+ yrs') + '</div>' +
                            (inst.phone ? '<div><strong>Phone:</strong> ' + inst.phone + '</div>' : '') +
                            (inst.email ? '<div><strong>Email:</strong> ' + inst.email + '</div>' : '') +
                            '</div></div>';
                    });
                    grid.innerHTML = html;
                });
        }

        function openAddInstructorModal() {
            document.getElementById('addInstructorOverlay').classList.add('open');
        }

        function closeAddInstructorModal() {
            document.getElementById('addInstructorOverlay').classList.remove('open');
        }

        function handleAddInstructorSubmit(e) {
            e.preventDefault();
            const payload = {
                name: document.getElementById('instName').value.trim(),
                designation: document.getElementById('instDesignation').value.trim(),
                experienceYears: document.getElementById('instExp').value.trim(),
                specialization: document.getElementById('instSpec').value.trim(),
                phone: document.getElementById('instPhone').value.trim(),
                email: document.getElementById('instEmail').value.trim()
            };

            fetch(contextPath + '/centres/api/instructors', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
            .then(r => r.json())
            .then(res => {
                if (res.success) {
                    closeAddInstructorModal();
                    loadInstructors();
                    alert('Instructor added successfully!');
                } else {
                    alert(res.error || 'Failed to add instructor');
                }
            });
        }

        function removeInstructor(id) {
            if (confirm('Remove instructor from your centre roster?')) {
                fetch(contextPath + '/centres/api/instructors/' + id, { method: 'DELETE' })
                    .then(r => r.json())
                    .then(res => {
                        if (res.success) {
                            loadInstructors();
                        } else {
                            alert(res.error || 'Failed to remove');
                        }
                    });
            }
        }

        // ==========================================
        // BATCH MANAGEMENT CONTROLLER
        // ==========================================
        function openAddBatchModal() {
            document.getElementById('batchForm').reset();
            document.getElementById('batchId').value = '';
            document.getElementById('batchModalTitle').innerHTML = '<i class="bi bi-plus-circle me-2"></i> Create Martial Arts Batch';
            document.getElementById('btnSubmitBatch').innerHTML = '<i class="bi bi-check-circle-fill"></i> Save / Create Batch';
            document.getElementById('btnSubmitBatch').disabled = false;
            setDayChipsFromCSV('Mon,Tue,Wed,Thu,Fri');
            document.getElementById('batchModalOverlay').classList.add('open');
        }

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

        function handleBatchFormSubmit(e) {
            e.preventDefault();
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
                    window.location.reload();
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

        function openBatchDetailsModal(id) {
            fetch(contextPath + '/centres/batches/details/' + id)
                .then(r => r.json())
                .then(res => {
                    if (!res.success) {
                        alert(res.message || 'Unable to load batch');
                        return;
                    }
                    const b = res.batch;
                    document.getElementById('detailBatchName').innerHTML = '<i class="bi bi-shield-fill me-2" style="color: var(--primary);"></i> ' + (b.name || 'Batch Details');
                    
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

        // ==========================================
        // TRAINEE ATTENDANCE ENGINE (PARITY WITH ATTENDANCE MODULE)
        // ==========================================
        let currentAttendanceTrainees = [];
        let currentSessionData = {};

        function switchAttendanceView(view, btn) {
            document.querySelectorAll('.att-subnav-btn').forEach(b => b.classList.remove('active'));
            if (btn) btn.classList.add('active');
            
            const rosterView = document.getElementById('attViewRoster');
            const qrView = document.getElementById('attViewQr');
            const saveBtnTop = document.getElementById('btnSaveAttendanceTop');

            if (view === 'roster') {
                rosterView.style.display = 'block';
                qrView.style.display = 'none';
                if (saveBtnTop) saveBtnTop.style.display = 'inline-flex';
                loadAttendanceSessions();
            } else {
                rosterView.style.display = 'none';
                qrView.style.display = 'block';
                if (saveBtnTop) saveBtnTop.style.display = 'none';
            }
        }

        async function loadAttendanceSessions() {
            const dateInput = document.getElementById('attDateInput');
            const date = dateInput ? dateInput.value : '<%= java.time.LocalDate.now() %>';
            const select = document.getElementById('attSessionSelect');
            if (!select) return;
            const currentValue = select.value;

            try {
                const res = await fetch(contextPath + '/api/attendance/sessions?date=' + date);
                const data = await res.json();

                select.innerHTML = '<option value="">Choose a batch or session...</option>';

                // 1. Add Batches
                if (data.batches && data.batches.length > 0) {
                    const group = document.createElement('optgroup');
                    group.label = "OFFLINE DOJO BATCHES";
                    data.batches.forEach(b => {
                        const opt = document.createElement('option');
                        opt.value = 'BATCH:' + b.id;
                        opt.textContent = b.name + ' (' + b.time + ')';
                        group.appendChild(opt);
                    });
                    select.appendChild(group);
                }

                // 2. Add Online Classes
                if (data.classes && data.classes.length > 0) {
                    const group = document.createElement('optgroup');
                    group.label = "ONLINE LIVE CLASSES";
                    data.classes.forEach(c => {
                        const opt = document.createElement('option');
                        opt.value = 'ONLINE:' + c.id;
                        opt.textContent = c.name + ' (' + c.time + ')';
                        group.appendChild(opt);
                    });
                    select.appendChild(group);
                }

                if (currentValue) {
                    select.value = currentValue;
                }
                loadAttendanceTrainees();
            } catch (err) {
                console.error('Failed to load attendance sessions:', err);
            }
        }

        async function loadAttendanceTrainees() {
            const sessionSelect = document.getElementById('attSessionSelect');
            if (!sessionSelect) return;
            const sessionVal = sessionSelect.value;
            const dateInput = document.getElementById('attDateInput');
            const date = dateInput ? dateInput.value : '<%= java.time.LocalDate.now() %>';

            const activeWs = document.getElementById('attActiveWorkspace');
            const noSessionState = document.getElementById('attNoSessionState');

            if (!sessionVal) {
                if (activeWs) activeWs.style.display = 'none';
                if (noSessionState) noSessionState.style.display = 'block';
                return;
            }

            const [type, id] = sessionVal.split(':');
            currentSessionData = { type, id, date };

            if (activeWs) activeWs.style.display = 'block';
            if (noSessionState) noSessionState.style.display = 'none';

            const modeDisplay = document.getElementById('attModeDisplay');
            if (modeDisplay) {
                const isOnline = type === 'ONLINE';
                modeDisplay.innerHTML = '<span class="badge-custom ' + (isOnline ? 'badge-approved' : 'badge-completed') + '" style="font-size:0.82rem; font-weight:800;">' +
                    '<i class="bi ' + (isOnline ? 'bi-camera-video-fill' : 'bi-building-fill') + ' me-1"></i> ' + type + ' SESSION ATTENDANCE' +
                    '</span>';
            }

            try {
                const res = await fetch(contextPath + '/api/attendance/trainees?type=' + type + '&id=' + id + '&date=' + date);
                currentAttendanceTrainees = await res.json();
                renderAttendanceTrainees();
            } catch (err) {
                console.error('Failed to load attendance trainees:', err);
            }
        }

        function renderAttendanceTrainees() {
            const listBody = document.getElementById('attTraineeListBody');
            if (!listBody) return;
            listBody.innerHTML = '';

            let p = 0, a = 0, l = 0;

            if (currentAttendanceTrainees.length === 0) {
                listBody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:30px; color:var(--text-gray);"><i class="bi bi-people me-2"></i>No trainees currently registered in this session.</td></tr>';
                document.getElementById('attTotalTrainees').textContent = '0';
                document.getElementById('attPresentCount').textContent = '0';
                document.getElementById('attAbsentCount').textContent = '0';
                document.getElementById('attLateCount').textContent = '0';
                return;
            }

            currentAttendanceTrainees.forEach(t => {
                if (t.status === 'PRESENT') p++;
                else if (t.status === 'ABSENT') a++;
                else if (t.status === 'LATE' || t.status === 'EXCUSED') l++;

                const row = document.createElement('tr');
                const pct = t.percentage != null ? t.percentage : 0;
                const strokeDash = pct + ', 100';
                const initial = (t.name && t.name.length > 0) ? t.name.charAt(0).toUpperCase() : 'T';

                row.innerHTML = 
                    '<td>' +
                        '<div style="display:flex; align-items:center; gap:12px;">' +
                            '<div style="width:38px; height:38px; border-radius:10px; background:var(--martial-rose-soft); color:var(--primary); display:flex; align-items:center; justify-content:center; font-weight:800; font-size:1rem; flex-shrink:0;">' + initial + '</div>' +
                            '<div>' +
                                '<div style="font-weight:700; color:var(--navy); font-size:0.92rem;">' + (t.name || 'Trainee') + '</div>' +
                                '<div style="color:var(--text-gray); font-size:0.75rem;">' + (t.email || '') + '</div>' +
                            '</div>' +
                        '</div>' +
                    '</td>' +
                    '<td>' +
                        '<div style="display:flex; align-items:center; gap:10px;">' +
                            '<div style="width:36px; height:36px; position:relative;">' +
                                '<svg viewBox="0 0 36 36" class="circular-chart">' +
                                    '<path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />' +
                                    '<path class="circle present" stroke-dasharray="' + strokeDash + '" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />' +
                                    '<text x="18" y="20.35" class="percentage">' + pct + '%</text>' +
                                '</svg>' +
                            '</div>' +
                            '<span style="font-size:0.8rem; font-weight:700; color:var(--text-gray);">' + pct + '% Rate</span>' +
                        '</div>' +
                    '</td>' +
                    '<td>' +
                        '<div class="btn-status-group">' +
                            '<button type="button" class="btn-status btn-p ' + (t.status === 'PRESENT' ? 'active' : '') + '" onclick="setAttendanceStatus(' + t.id + ', \'PRESENT\')" title="Mark Present">P</button>' +
                            '<button type="button" class="btn-status btn-a ' + (t.status === 'ABSENT' ? 'active' : '') + '" onclick="setAttendanceStatus(' + t.id + ', \'ABSENT\')" title="Mark Absent">A</button>' +
                            '<button type="button" class="btn-status btn-l ' + (t.status === 'LATE' ? 'active' : '') + '" onclick="setAttendanceStatus(' + t.id + ', \'LATE\')" title="Mark Late">L</button>' +
                            '<button type="button" class="btn-status btn-e ' + (t.status === 'EXCUSED' ? 'active' : '') + '" onclick="setAttendanceStatus(' + t.id + ', \'EXCUSED\')" title="Mark Excused">E</button>' +
                        '</div>' +
                    '</td>' +
                    '<td>' +
                        '<input type="text" class="form-input-custom" style="padding:6px 10px; font-size:0.82rem;" placeholder="Remarks (optional)..." value="' + (t.notes || '') + '" onchange="setAttendanceNotes(' + t.id + ', this.value)">' +
                    '</td>';

                listBody.appendChild(row);
            });

            document.getElementById('attTotalTrainees').textContent = currentAttendanceTrainees.length;
            document.getElementById('attPresentCount').textContent = p;
            document.getElementById('attAbsentCount').textContent = a;
            document.getElementById('attLateCount').textContent = l;
        }

        function setAttendanceStatus(traineeId, status) {
            const trainee = currentAttendanceTrainees.find(t => t.id === traineeId);
            if (trainee) {
                trainee.status = status;
                renderAttendanceTrainees();
            }
        }

        function setAttendanceNotes(traineeId, notes) {
            const trainee = currentAttendanceTrainees.find(t => t.id === traineeId);
            if (trainee) {
                trainee.notes = notes;
            }
        }

        async function saveAttendance() {
            if (!currentSessionData.id) {
                alert('Please select a session or batch first.');
                return;
            }

            const payload = {
                type: currentSessionData.type,
                id: currentSessionData.id,
                date: currentSessionData.date,
                trainees: currentAttendanceTrainees.map(t => ({
                    userId: t.id,
                    status: (t.status === 'PENDING' || !t.status) ? 'ABSENT' : t.status,
                    notes: t.notes || ''
                }))
            };

            const btn = document.getElementById('btnSaveAttendanceTop');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving...';
            }

            try {
                const res = await fetch(contextPath + '/api/attendance/save', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (res.ok) {
                    alert('Attendance marked and saved successfully!');
                    loadAttendanceTrainees();
                } else {
                    const err = await res.text();
                    alert('Error saving attendance: ' + err);
                }
            } catch (err) {
                console.error('Save attendance error:', err);
                alert('Connection error. Please try again.');
            } finally {
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-cloud-arrow-up-fill me-1"></i> Save Attendance';
                }
            }
        }

        // ==========================================
        // VIRTUAL DOJO & LIVE CLASSES WORKSPACE
        // ==========================================
        function openCreateLiveClassModal() {
            document.getElementById('createLiveClassModalOverlay').classList.add('open');
        }

        function closeCreateLiveClassModal() {
            document.getElementById('createLiveClassModalOverlay').classList.remove('open');
            document.getElementById('createLiveClassForm').reset();
        }

        async function handleCreateLiveClassSubmit(e) {
            e.preventDefault();
            const btn = document.getElementById('btnSubmitLiveClass');
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Scheduling...';

            const payload = {
                title: document.getElementById('liveTitle').value,
                batchId: document.getElementById('liveBatchSelect').value,
                sessionType: document.getElementById('liveSessionType').value,
                martialArtType: document.getElementById('liveMartialArtType').value,
                date: document.getElementById('liveDate').value,
                startTime: document.getElementById('liveStartTime').value,
                endTime: document.getElementById('liveEndTime').value,
                meetingLink: document.getElementById('liveMeetingLink').value,
                maxStudents: parseInt(document.getElementById('liveMaxStudents').value) || 25,
                notes: document.getElementById('liveNotes').value,
                description: document.getElementById('liveDescription').value
            };

            try {
                const res = await fetch(contextPath + '/online-class/create', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (res.ok) {
                    alert('Live class scheduled successfully!');
                    closeCreateLiveClassModal();
                    window.location.reload();
                } else {
                    const err = await res.json();
                    alert(err.message || 'Error creating live class');
                }
            } catch (err) {
                alert('Request failed: ' + err);
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-broadcast me-1"></i> Schedule Live Session';
            }
        }

        async function startLiveClass(id) {
            if (!confirm('Start this class and go live now? Trainees will be able to join the room.')) return;
            try {
                const res = await fetch(contextPath + '/online-class/start/' + id, { method: 'POST' });
                if (res.ok) {
                    const data = await res.json();
                    if (data.meetingLink) window.open(data.meetingLink, '_blank');
                    window.location.reload();
                } else {
                    alert('Could not start live class.');
                }
            } catch (err) {
                alert('Connection error: ' + err);
            }
        }

        async function endLiveClass(id) {
            if (!confirm('End this live session? Attendance will be automatically recorded for all joined trainees.')) return;
            try {
                const res = await fetch(contextPath + '/online-class/end/' + id, { method: 'POST' });
                if (res.ok) {
                    alert('Session ended and attendance finalized!');
                    window.location.reload();
                } else {
                    alert('Error ending session.');
                }
            } catch (err) {
                alert('Connection error: ' + err);
            }
        }

        async function deleteLiveClass(id) {
            if (!confirm('Are you sure you want to delete this live class? This cannot be undone.')) return;
            try {
                const res = await fetch(contextPath + '/online-class/delete/' + id, { method: 'DELETE' });
                if (res.ok) {
                    alert('Class deleted successfully.');
                    window.location.reload();
                } else {
                    const data = await res.json();
                    alert(data.message || 'Error deleting class.');
                }
            } catch (err) {
                alert('Network error: ' + err);
            }
        }

        let liveControlPollInterval = null;
        function openLiveControlPanel(classId, title) {
            document.getElementById('ctrlSessionTitle').innerText = title;
            document.getElementById('ctrlEndSessionBtn').onclick = () => endLiveClass(classId);
            document.getElementById('liveControlPanelOverlay').classList.add('open');

            fetchJoinedTrainees(classId);
            liveControlPollInterval = setInterval(() => fetchJoinedTrainees(classId), 5000);
        }

        function closeLiveControlPanel() {
            document.getElementById('liveControlPanelOverlay').classList.remove('open');
            if (liveControlPollInterval) {
                clearInterval(liveControlPollInterval);
                liveControlPollInterval = null;
            }
        }

        async function fetchJoinedTrainees(classId) {
            try {
                const res = await fetch(contextPath + '/online-class/' + classId + '/joined-trainees');
                const joined = await res.json();

                const listDiv = document.getElementById('ctrlJoinedTraineeList');
                const countBadge = document.getElementById('ctrlTraineeCountBadge');

                if (countBadge) countBadge.innerText = (joined ? joined.length : 0) + ' Online';

                if (!joined || joined.length === 0) {
                    listDiv.innerHTML = '<div style="padding:24px; text-align:center; color:var(--text-gray);"><i class="bi bi-person-x me-2"></i>No trainees have joined the live room yet.</div>';
                    return;
                }

                listDiv.innerHTML = joined.map(t => 
                    '<div style="display:flex; justify-content:space-between; align-items:center; padding:10px 14px; background:#fff; border-radius:10px; margin-bottom:8px; border:1px solid var(--border-color);">' +
                        '<div style="display:flex; align-items:center; gap:10px;">' +
                            '<span style="width:10px; height:10px; border-radius:50%; background:#16A34A; display:inline-block;"></span>' +
                            '<div><strong style="font-size:0.88rem; color:var(--navy);">' + (t.fullName || 'Trainee #' + t.traineeId) + '</strong></div>' +
                        '</div>' +
                        '<span class="badge" style="background:#DCFCE7; color:#166534; font-weight:700; font-size:0.75rem;">CONNECTED</span>' +
                    '</div>'
                ).join('');
            } catch (err) {
                console.error('Fetch joined trainees error:', err);
            }
        }

        // ==========================================
        // PAST SESSIONS & RECORDINGS
        // ==========================================
        function openUploadRecordingModal(classId, currentLink) {
            document.getElementById('recClassId').value = classId;
            document.getElementById('recLinkInput').value = (currentLink && currentLink !== 'null') ? currentLink : '';
            document.getElementById('uploadRecordingOverlay').classList.add('open');
        }

        function closeUploadRecordingModal() {
            document.getElementById('uploadRecordingOverlay').classList.remove('open');
        }

        async function handleUploadRecordingSubmit(e) {
            e.preventDefault();
            const classId = document.getElementById('recClassId').value;
            const link = document.getElementById('recLinkInput').value;
            const btn = document.getElementById('btnSubmitRec');
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving...';

            try {
                const res = await fetch(contextPath + '/online-class/upload-recording/' + classId, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ recordingLink: link })
                });

                if (res.ok) {
                    alert('Session recording link saved successfully!');
                    closeUploadRecordingModal();
                    window.location.reload();
                } else {
                    alert('Error saving recording link');
                }
            } catch (err) {
                alert('Request failed: ' + err);
            } finally {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i> Save Recording';
            }
        }

        // ==========================================
        // AUTO-ROUTER ON PAGE LOAD (Tab from URL or param)
        // ==========================================
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const tabParam = urlParams.get('tab') || '${currentTab}';
            if (tabParam && tabParam !== 'dashboard' && tabParam !== 'overview') {
                const normalizedTab = tabParam === 'live-classes' ? 'live' : tabParam;
                switchTab(normalizedTab);
            }
        });
    </script>
</body>
</html>
