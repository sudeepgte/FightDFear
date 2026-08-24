<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Dashboard | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f9fc;
            --fdf-burgundy: #2d0b20;
            --fdf-burgundy-dark: #1f0615;
            --fdf-pink: #db2777;
            --fdf-pink-light: #fbcfe8;
            --fdf-rose: #f43f5e;
            --fdf-lavender: #f3e8ff;
            --fdf-text-dark: #1e1b4b;
            --fdf-text-muted: #64748b;
            --fdf-border: #f1e9f0;
            --card-shadow: 0 10px 30px rgba(79, 70, 229, 0.04);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--fdf-text-dark);
            margin: 0;
            overflow-x: hidden;
        }

        /* Scrollbar styling */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(30, 27, 75, 0.1); border-radius: 10px; }

        /* Unified Premium Sidebar */
        .sidebar {
            background: linear-gradient(180deg, var(--fdf-burgundy) 0%, var(--fdf-burgundy-dark) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
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
            color: white;
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
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 4px;
            transition: all 0.2s ease;
            font-weight: 500;
            font-size: 0.88rem;
        }

        .nav-link-custom:hover {
            background: rgba(255,255,255,0.05);
            color: white;
            transform: translateX(4px);
        }

        .nav-link-custom.active {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(219, 39, 119, 0.25);
            font-weight: 600;
        }

        .nav-link-custom i {
            font-size: 1.15rem;
        }

        /* Upgrade card in sidebar */
        .upgrade-card {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 16px;
            margin: 20px 16px;
            font-size: 0.8rem;
        }
        .upgrade-card h6 {
            color: white;
            font-weight: 700;
            font-size: 0.85rem;
            margin-bottom: 8px;
        }
        .upgrade-card ul {
            list-style: none;
            padding: 0;
            margin: 0 0 12px 0;
            color: rgba(255,255,255,0.5);
        }
        .upgrade-card ul li {
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .upgrade-card ul li::before {
            content: "•";
            color: var(--fdf-pink);
            font-weight: bold;
        }
        .btn-upgrade {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            border: none;
            padding: 8px;
            width: 100%;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.8rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-upgrade:hover {
            filter: brightness(1.1);
        }

        /* Main Content */
        .main-content {
            padding: 24px 32px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                z-index: 1000;
                box-shadow: 10px 0 35px rgba(0,0,0,0.05);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        /* Custom Header Styling */
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;

            /* Confine Bootstrap stretched-link hit areas to each card (not the whole page). */
            position: relative;
            z-index: 1;

            margin-bottom: 30px;
            gap: 20px;

        }

        .header-title-box h2 {
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--fdf-text-dark);
            margin: 0;
        }
        .header-title-box p {
            color: var(--fdf-text-muted);
            margin: 4px 0 0 0;
            font-size: 0.9rem;
        }

        .search-bar-wrapper {
            position: relative;
            max-width: 400px;
            flex: 1;
        }
        .search-bar-wrapper input {
            width: 100%;
            padding: 12px 20px 12px 48px;
            border: 1px solid var(--fdf-border);
            border-radius: 14px;
            background: white;
            font-size: 0.88rem;
            outline: none;
            transition: 0.2s;
        }
        .search-bar-wrapper input:focus {
            border-color: var(--fdf-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05);
        }
        .search-bar-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--fdf-text-muted);
            font-size: 1rem;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-pink-gradient {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 6px 15px rgba(219, 39, 119, 0.15);
            transition: 0.2s;
        }
        .btn-pink-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(219, 39, 119, 0.25);
            color: white;
        }

        .icon-btn-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: white;
            border: 1px solid var(--fdf-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: var(--fdf-text-dark);
            position: relative;
            cursor: pointer;
            transition: 0.2s;
        }
        .icon-btn-circle:hover {
            background: #fafafc;
            border-color: #e5dbe4;
        }
        .icon-btn-circle .badge-dot {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 14px;
            height: 14px;
            background-color: var(--fdf-pink);
            border-radius: 50%;
            border: 2px solid white;
            color: white;
            font-size: 0.6rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            background: white;
            border: 1px solid var(--fdf-border);
            padding: 6px 16px 6px 6px;
            border-radius: 50px;
            cursor: pointer;
        }
        .profile-btn img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }
        .profile-btn .info {
            text-align: left;
        }
        .profile-btn .info h6 {
            margin: 0;
            font-size: 0.85rem;
            font-weight: 700;
        }
        .profile-btn .info span {
            font-size: 0.72rem;
            color: var(--fdf-text-muted);
            display: block;
        }

        /* Sub-Header Row */
        .subheader-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        .date-picker-custom {
            background: white;
            border: 1px solid var(--fdf-border);
            padding: 8px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--fdf-text-dark);
        }

        .status-badge {
            background: white;
            border: 1px solid var(--fdf-border);
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.82rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .status-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
        }

        /* KPI Cards */
        .kpi-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 30px rgba(30, 27, 75, 0.05);
        }
        .kpi-icon-box {
            width: 50px;
            height: 50px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }
        .kpi-content h3 {
            font-size: 1.6rem;
            font-weight: 800;
            margin: 6px 0;
            color: var(--fdf-text-dark);
        }
        .kpi-content span {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--fdf-text-muted);
        }
        .kpi-trend {
            font-size: 0.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .kpi-trend.up { color: #10b981; }
        .kpi-trend.down { color: #ef4444; }

        /* Premium Colors for KPIs */
        .kpi-pink { background-color: #fdf2f8; color: var(--fdf-pink); }
        .kpi-green { background-color: #ecfdf5; color: #10b981; }
        .kpi-orange { background-color: #fff7ed; color: #f97316; }
        .kpi-purple { background-color: #faf5ff; color: #a855f7; }
        .kpi-blue { background-color: #eff6ff; color: #3b82f6; }

        /* Dashboard Sections Layout */
        .premium-card {
            background: white;
            border-radius: 28px;
            border: 1px solid rgba(241, 233, 240, 0.6);
            box-shadow: 0 12px 40px rgba(30, 27, 75, 0.03);
            padding: 28px;
            height: 100%;
            transition: all 0.3s ease;
        }
        .premium-card:hover {
            box-shadow: 0 16px 50px rgba(30, 27, 75, 0.05);
            transform: translateY(-2px);
        }

        .card-header-custom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .card-header-custom h5 {
            font-weight: 800;
            font-size: 1.1rem;
            margin: 0;
            color: var(--fdf-text-dark);
            font-family: 'Montserrat', sans-serif;
        }
        .card-header-custom .view-all {
            font-size: 0.8rem;
            color: var(--fdf-pink);
            font-weight: 700;
            text-decoration: none;
        }

        /* Services Grid on Dashboard */
        .service-tabs {
            display: flex;
            gap: 8px;
            background: #faf7f9;
            padding: 4px;
            border-radius: 12px;
            margin-bottom: 20px;
        }
        .service-tab {
            flex: 1;
            text-align: center;
            padding: 8px;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--fdf-text-muted);
            border-radius: 8px;
            cursor: pointer;
            transition: 0.2s;
            border: none;
            background: transparent;
        }
        .service-tab.active {
            background: white;
            color: var(--fdf-pink);
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(105px, 1fr));
            gap: 16px;
        }
        .service-cat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            background: #fafafc;
            border: 1px solid #f6f0f5;
            padding: 16px;
            border-radius: 16px;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .service-cat-item:hover {
            background: #fff;
            border-color: var(--fdf-pink-light);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(219,39,119,0.03);
        }
        .service-cat-item .icon-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #fdf2f8;
            color: var(--fdf-pink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 10px;
        }
        .service-cat-item h6 {
            font-weight: 700;
            font-size: 0.8rem;
            margin: 0 0 4px 0;
            color: var(--fdf-text-dark);
            width: 100%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .service-cat-item span {
            font-size: 0.72rem;
            color: var(--fdf-text-muted);
            background: rgba(0,0,0,0.03);
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
        }

        /* Today's Schedule Timeline */
        .timeline-wrapper {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .timeline-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            border-radius: 14px;
            background: #fafafc;
            border: 1px solid #f6f0f5;
        }
        .timeline-time {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--fdf-pink);
            white-space: nowrap;
        }
        .timeline-info {
            flex: 1;
            margin: 0 16px;
        }
        .timeline-info h6 {
            margin: 0 0 2px 0;
            font-size: 0.85rem;
            font-weight: 700;
        }
        .timeline-info span {
            font-size: 0.75rem;
            color: var(--fdf-text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .timeline-status {
            font-size: 0.72rem;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 50px;
        }
        .status-confirmed { background: #e6fcf5; color: #0ca678; }
        .status-inprogress { background: #e7f5ff; color: #1c7ed6; }
        .status-walkin { background: #f3f0ff; color: #7048e8; }

        /* Business Overview Charts */
        .revenue-chart-box {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            height: 120px;
            margin-top: 15px;
            padding: 0 10px;
        }
        .chart-bar {
            width: 14px;
            background: linear-gradient(180deg, var(--fdf-pink-light) 0%, var(--fdf-pink) 100%);
            border-radius: 6px;
            transition: height 0.5s ease;
            position: relative;
            cursor: pointer;
        }
        .chart-bar:hover {
            filter: brightness(1.05);
        }
        .chart-bar::after {
            content: attr(data-val);
            position: absolute;
            top: -24px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.65rem;
            font-weight: 700;
            color: var(--fdf-text-dark);
            opacity: 0;
            transition: 0.2s;
        }
        .chart-bar:hover::after {
            opacity: 1;
        }
        .chart-label {
            font-size: 0.68rem;
            color: var(--fdf-text-muted);
            text-align: center;
            margin-top: 6px;
            font-weight: 500;
        }

        .chart-donut-wrapper {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto;
        }
        .donut-legend {
            list-style: none;
            padding: 0;
            margin: 0;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--fdf-text-muted);
        }
        .donut-legend li {
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .legend-color {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        /* Anti-Gravity Wellness Banner */
        .anti-gravity-banner {
            background: linear-gradient(90deg, #fdf2f8 0%, #fae8ff 100%);
            border: 1px solid var(--fdf-pink-light);
            border-radius: 24px;
            padding: 24px;
            margin-top: 30px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(219, 39, 119, 0.05);
        }
        .ag-left {
            display: flex;
            align-items: center;
            gap: 24px;
            flex: 1.2;
        }
        .ag-img {
            width: 150px;
            height: 100px;
            border-radius: 16px;
            object-fit: cover;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .ag-content h4 {
            font-weight: 900;
            font-size: 1.3rem;
            color: var(--fdf-burgundy);
            margin: 0 0 6px 0;
            letter-spacing: 0.5px;
        }
        .ag-content h4 span {
            font-size: 0.72rem;
            background: var(--fdf-pink);
            color: white;
            padding: 3px 10px;
            border-radius: 50px;
            font-weight: 700;
            vertical-align: middle;
            margin-left: 10px;
        }
        .ag-content p {
            margin: 0 0 16px 0;
            font-size: 0.88rem;
            color: var(--fdf-text-muted);
            max-width: 480px;
        }
        .ag-right {
            display: flex;
            flex-direction: column;
            gap: 12px;
            flex: 1;
        }
        .benefits-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 4px;
        }
        .benefit-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--fdf-burgundy);
        }
        .benefit-item i {
            color: var(--fdf-pink);
            font-size: 1rem;
        }

        /* Quick Actions */
        .qa-row {
            display: flex;
            gap: 16px;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-bottom: 30px;
        }
        .qa-btn {
            background: white;
            border: 1px solid var(--fdf-border);
            padding: 14px 20px;
            border-radius: 16px;
            font-weight: 700;
            font-size: 0.85rem;
            color: var(--fdf-text-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: var(--card-shadow);
            white-space: nowrap;
            transition: all 0.2s ease;
        }
        .qa-btn:hover {
            border-color: var(--fdf-pink-light);
            color: var(--fdf-pink);
            transform: translateY(-2px);
        }
        .qa-btn i {
            font-size: 1.1rem;
            color: var(--fdf-pink);
        }

        /* Tables & Lists */
        .custom-table {
            width: 100%;
            margin-bottom: 0;
        }
        .custom-table th {
            background: #fafafc !important;
            border-bottom: 1px solid var(--fdf-border) !important;
            color: var(--fdf-text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 800;
            letter-spacing: 0.5px;
            padding: 12px 16px;
        }
        .custom-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--fdf-border);
            font-size: 0.85rem;
            vertical-align: middle;
        }
        .avatar-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .avatar-info img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }
        .avatar-info h6 {
            margin: 0;
            font-size: 0.85rem;
            font-weight: 700;
        }

        /* Top Services List */
        .top-services-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .top-service-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafafc;
            border: 1px solid #f6f0f5;
            padding: 12px 16px;
            border-radius: 14px;
        }
        .top-service-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .top-service-rank {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #fdf2f8;
            color: var(--fdf-pink);
            font-size: 0.78rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .top-service-name {
            font-weight: 700;
            font-size: 0.85rem;
        }
        .top-service-bookings {
            font-size: 0.8rem;
            color: var(--fdf-text-muted);
            font-weight: 600;
        }

        /* Reviews List */
        .reviews-wrapper {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }
        .review-item {
            border-bottom: 1px solid var(--fdf-border);
            padding-bottom: 14px;
        }
        .review-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .review-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 6px;
        }
        .review-author {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .review-author img {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            object-fit: cover;
        }
        .review-author h6 {
            margin: 0;
            font-size: 0.82rem;
            font-weight: 700;
        }
        .stars-box {
            color: #f59e0b;
            font-size: 0.8rem;
        }
        .review-text {
            font-size: 0.8rem;
            color: var(--fdf-text-muted);
            margin: 0 0 4px 0;
            line-height: 1.5;
        }
        .review-time {
            font-size: 0.7rem;
            color: var(--fdf-text-muted);
            display: block;
        }

        /* Bottom Summary Bar */
        .bottom-summary-bar {
            background: white;
            border-radius: 20px;
            border: 1px solid var(--fdf-border);
            padding: 20px 24px;
            margin-top: 30px;
            box-shadow: var(--card-shadow);
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 20px;
        }
        .summary-item {
            border-right: 1px solid var(--fdf-border);
            padding-right: 15px;
        }
        .summary-item:last-child {
            border-right: none;
            padding-right: 0;
        }
        .summary-item span {
            font-size: 0.72rem;
            color: var(--fdf-text-muted);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .summary-item h5 {
            font-weight: 800;
            font-size: 1.1rem;
            margin: 4px 0 0 0;
            color: var(--fdf-text-dark);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Mobile Header */
        .mobile-header {
            background: var(--fdf-burgundy);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
        }
        /* Offer Cards */
        .offer-card { background: white; border-radius: 24px; padding: 25px; border: 1px solid var(--fdf-border); transition: all 0.3s ease; height: 100%; position: relative; display: flex; flex-direction: column; }
        .offer-card:hover { transform: translateY(-4px); box-shadow: 0 15px 30px rgba(0,0,0,0.05); }
        .offer-status { position: absolute; top: 20px; right: 20px; padding: 5px 15px; border-radius: 50px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }
        .status-Active { background: rgba(32, 201, 151, 0.15); color: #20c997; }
        .status-Scheduled { background: rgba(13, 110, 253, 0.15); color: #0d6efd; }
        .status-Expired { background: rgba(108, 117, 125, 0.15); color: #6c757d; }
        .status-Paused { background: rgba(255, 193, 7, 0.15); color: #ffc107; }
        .offer-title { font-weight: 800; color: var(--brand-purple-darker); margin-bottom: 5px; padding-right: 90px; font-size: 1.25rem; }
        .offer-type { font-size: 0.85rem; color: var(--brand-purple); font-weight: 700; text-transform: uppercase; margin-bottom: 15px; }
        .offer-desc { color: #6c757d; font-size: 0.9rem; margin-bottom: 15px; flex-grow: 1; }
        .price-tag { background: #f8f5ff; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .price-label { font-size: 0.8rem; color: #6c757d; font-weight: 600; }
        .strike-price { text-decoration: line-through; color: #888; font-size: 0.9rem; font-weight: 600; }
        .final-price { color: #157347; font-weight: 800; font-size: 1.2rem; }
        .usage-stats { display: flex; justify-content: space-between; border-top: 1px dashed #eee; padding-top: 15px; margin-bottom: 15px; font-size: 0.85rem; }
        .usage-stat-val { font-weight: 700; color: #333; }
        .offer-actions { display: flex; gap: 8px; }
        .btn-action { flex: 1; padding: 8px; border-radius: 10px; font-weight: 600; border: none; font-size: 0.9rem; transition: all 0.2s; }
        .btn-pause { background: rgba(255, 193, 7, 0.1); color: #d39e00; }
        .btn-pause:hover { background: #ffc107; color: white; }
        .btn-resume { background: rgba(32, 201, 151, 0.1); color: #20c997; }
        .btn-resume:hover { background: #20c997; color: white; }
        .btn-archive { background: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .btn-archive:hover { background: #dc3545; color: white; }

        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #fdf2f8 0%, #f3e8ff 50%, #eff6ff 100%);
            border-radius: 24px;
            padding: 32px 36px;
            margin-bottom: 28px;
            border: 1px solid rgba(241, 233, 240, 0.6);
            box-shadow: 0 8px 30px rgba(219, 39, 119, 0.04);
        }
        .welcome-banner h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.6rem;
            color: var(--fdf-text-dark);
            margin: 0 0 6px 0;
        }
        .welcome-banner p {
            color: var(--fdf-text-muted);
            margin: 0;
            font-size: 0.92rem;
        }

        /* Stat Cards */
        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--fdf-border);
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            color: var(--fdf-text-dark);
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 35px rgba(30, 27, 75, 0.06);
        }

        /* Icon Boxes */
        .icon-box {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 16px;
        }
        .bg-glass-purple {
            background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);
            color: #7c3aed;
        }
        .bg-glass-pink {
            background: linear-gradient(135deg, #fce7f3 0%, #fbcfe8 100%);
            color: var(--fdf-pink);
        }
        .bg-glass-gold {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            color: #d97706;
        }

        /* Card Content */
        .card-title-custom {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1rem;
            margin: 0 0 6px 0;
            color: var(--fdf-text-dark);
        }
        .card-desc {
            font-size: 0.82rem;
            color: var(--fdf-text-muted);
            margin: 0 0 16px 0;
            line-height: 1.5;
        }

        /* Action Buttons */
        .btn-purple {
            background: linear-gradient(90deg, #7c3aed 0%, #6d28d9 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.82rem;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(124, 58, 237, 0.2);
        }
        .btn-purple:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(124, 58, 237, 0.3);
            color: white;
        }
        .btn-add-new {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            border: none;
            padding: 8px 16px;
            font-weight: 700;
            font-size: 0.82rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-add-new:hover {
            filter: brightness(1.1);
            color: white;
        }

        /* Mobile responsive fixes */
        @media (max-width: 768px) {
            .main-content {
                padding: 16px;
            }
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
                justify-content: flex-start;
                flex-wrap: wrap;
            }
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .summary-item {
                border-right: none;
                border-bottom: 1px solid var(--fdf-border);
                padding: 10px 0;
            }
            .anti-gravity-banner {
                flex-direction: column;
            }
            .kpi-card {
                padding: 16px;
            }
            .welcome-banner {
                padding: 24px;
            }
            .welcome-banner h2 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold d-flex align-items-center gap-2" style="font-family:'Montserrat';"><i class="bi bi-gender-female"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 1.8rem;"></i>
        </button>
    </div>

    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="sidebar-brand-wrapper">
            <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
                <i class="bi bi-gender-female"></i>
                <span>${empty salon.name ? 'Priya Beauty & Wellness' : salon.name}</span>
            </a>
            <div class="subtitle">Women's Salon • Beauty • Wellness • Hair Styling</div>
        </div>

        <div class="nav-container">
            <nav class="nav flex-column">
                <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salons/dashboard">
                    <i class="bi bi-grid-1x2"></i>
                    <span>Dashboard</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Salon Profile</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                    <i class="bi bi-calendar-check"></i>
                    <span>Appointments</span>
                </a>
                <a class="nav-link-custom" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal">
                    <i class="bi bi-calendar3"></i>
                    <span>Calendar</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                    <i class="bi bi-magic"></i>
                    <span>Services</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists">
                    <i class="bi bi-people"></i>
                    <span>Staff / Stylists</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients">
                    <i class="bi bi-people-fill"></i>
                    <span>Clients</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages">
                    <i class="bi bi-box-seam"></i>
                    <span>Packages & Memberships</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
                    <i class="bi bi-percent"></i>
                    <span>Offers & Discounts</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/billing">
                    <i class="bi bi-receipt"></i>
                    <span>Billing & Invoices</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/payments">
                    <i class="bi bi-credit-card-2-front"></i>
                    <span>Payments & Payouts</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/inventory">
                    <i class="bi bi-box"></i>
                    <span>Inventory</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                    <i class="bi bi-star-half"></i>
                    <span>Reviews & Feedback</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/analytics">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports & Analytics</span>
                </a>

                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/settings">
                    <i class="bi bi-sliders"></i>
                    <span>Settings</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/support">
                    <i class="bi bi-question-circle"></i>
                    <span>Help & Support</span>
                </a>
                <a class="nav-link-custom text-danger mt-3" href="${pageContext.request.contextPath}/salons/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </nav>
        </div>


    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid p-0">
            

            <div class="welcome-banner">
                <h2>Hello, <c:out value="${salon.name}"/>!</h2>
                <p>Welcome back to your partner dashboard. Here's what's happening today.</p>
            </div>

            <div class="row g-4 mb-5">
                <!-- Bookings -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-purple">
                                <i class="bi bi-calendar2-week"></i>
                            </div>
                            <h5 class="card-title-custom">Bookings</h5>
                            <p class="card-desc">Review and manage your incoming customer appointments.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/booking/list" class="btn-purple">View All Bookings</a>
                    </div>
                </div>

                <!-- Services -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-pink">
                                <i class="bi bi-flower1"></i>
                            </div>
                            <h5 class="card-title-custom">Services</h5>
                            <p class="card-desc">Update your service menu, pricing, and specialized treatments.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn-purple">Manage Services</a>
                    </div>
                </div>

                <!-- Profile -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-gold">
                                <i class="bi bi-shop"></i>
                            </div>
                            <h5 class="card-title-custom">Salon Profile</h5>
                            <p class="card-desc">Keep your salon profile updated for better visibility.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salons/profile" class="btn-purple">Edit Profile</a>
                    </div>
                </div>

                <!-- Offers -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div>
                            <div class="icon-box bg-glass-pink">
                                <i class="bi bi-tag"></i>
                            </div>
                            <h5 class="card-title-custom">Offers</h5>
                            <p class="card-desc">Create and manage exclusive offers and discounts.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}" class="btn-purple">View Offers</a>
                    </div>
                </div>
            </div>

            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div class="header-title-box">
                    <h2>Welcome back, ${sessionScope.loggedSalon.name}! ✨</h2>
                    <p>Manage your beauty, wellness in one place.</p>
                </div>
                
                <div class="search-bar-wrapper d-none d-md-block">
                    <i class="bi bi-search"></i>
                    <input type="text" placeholder="Search appointments, clients, services...">
                </div>

                <div class="header-actions">
                    <button class="btn-pink-gradient" onclick="location.href='${pageContext.request.contextPath}/booking/list'">
                        <i class="bi bi-plus-circle-fill"></i>
                        <span>New Appointment</span>
                    </button>
                    
                    <div class="dropdown">
                        <div class="icon-btn-circle" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;" id="notifDropdownToggle" onclick="markNotificationsRead()">
                            <i class="bi bi-bell"></i>
                            <span class="badge-dot" id="notif-badge" style="display:none;">0</span>
                        </div>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="notifDropdownToggle" style="width: 320px; max-height: 400px; overflow-y: auto;" id="notifDropdownList">
                            <li><h6 class="dropdown-header">Recent Notifications</h6></li>
                            <li id="empty-notif" class="text-center p-3 text-muted" style="display: none;">No new notifications</li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-center text-primary" href="${pageContext.request.contextPath}/salon/notifications">View All</a></li>
                        </ul>
                    </div>

                    <div class="icon-btn-circle" onclick="location.href='${pageContext.request.contextPath}/salon/messages'" style="cursor:pointer;">
                        <i class="bi bi-chat-right-text"></i>
                        <span class="badge-dot" id="msg-badge" style="display:none;">0</span>
                    </div>

                    <div class="profile-btn d-none d-sm-flex" onclick="location.href='${pageContext.request.contextPath}/salons/profile'">
                        <img src="${not empty salon.profileImageUrl ? pageContext.request.contextPath.concat(salon.profileImageUrl) : pageContext.request.contextPath.concat('/assets/images/img6.jpg')}" alt="Owner" onerror="this.src='https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=60'">
                        <div class="info">
                            <h6>${empty salon.name ? 'Owner' : salon.name}</h6>
                            <span>Owner</span>
                        </div>
                    </div>
                </div>
            </div>

            <h4 class="fw-bold mb-4">Quick Actions</h4>
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/salon/addService" class="stat-card p-3 flex-row align-items-center gap-3 text-decoration-none text-dark fw-semibold">
                        <div class="icon-box bg-glass-purple mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-plus-lg"></i>
                        </div>
                        <span>Add New Service</span>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salon.id}" class="stat-card p-3 flex-row align-items-center gap-3 text-decoration-none text-dark fw-semibold">
                        <div class="icon-box bg-glass-gold mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-tag"></i>
                        </div>
                        <span>Create New Offer</span>
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/salon/treatments/add" class="stat-card p-3 flex-row align-items-center gap-3 text-decoration-none text-dark fw-semibold">
                        <div class="icon-box bg-glass-pink mb-0" style="width: 45px; height: 45px; font-size: 1.1rem;">
                            <i class="bi bi-droplet"></i>
                        </div>
                        <span>Add Treatment</span>
                    </a>
                </div>
            </div>

            <!-- Subheader Details Row -->
            <div class="subheader-row">
                <div class="date-picker-custom">
                    <i class="bi bi-calendar-event"></i>
                    <span>${empty todayDate ? '10 May 2026, Saturday' : todayDate}</span>
                </div>
                
                <div class="status-badge">
                    <span class="status-indicator"></span>
                    <span>Salon Status: OPEN</span>
                    <span style="font-size:0.7rem; color:var(--fdf-text-muted); font-weight:600; margin-left:4px;">(Hours: ${todayHours})</span>
                </div>
            </div>

            <!-- KPI Row -->
            <div class="row g-4 mb-4">
                <div class="col-xl-2 col-md-4 col-sm-6">
                    <div class="kpi-card">
                        <div class="kpi-content">
                            <span>Today's Appts</span>
                            <h3>${todayApptsCount}</h3>
                            <div class="kpi-trend up"><i class="bi bi-arrow-up-short"></i> Live</div>
                        </div>
                        <div class="kpi-icon-box kpi-pink">
                            <i class="bi bi-calendar3"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-md-4 col-sm-6">
                    <div class="kpi-card">
                        <div class="kpi-content">
                            <span>Completed</span>
                            <h3>${completedApptsCount}</h3>
                            <div class="kpi-trend up"><i class="bi bi-arrow-up-short"></i> Live</div>
                        </div>
                        <div class="kpi-icon-box kpi-green">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-4 col-sm-6">
                    <div class="kpi-card">
                        <div class="kpi-content">
                            <span>Today's Revenue</span>
                            <h3>₹${todayRevenue}</h3>
                            <div class="kpi-trend up"><i class="bi bi-arrow-up-short"></i> Live</div>
                        </div>
                        <div class="kpi-icon-box kpi-orange">
                            <i class="bi bi-currency-rupee"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-md-6 col-sm-6">
                    <div class="kpi-card">
                        <div class="kpi-content">
                            <span>Total Bookings</span>
                            <h3>${totalBookingsCount}</h3>
                            <div class="kpi-trend up"><i class="bi bi-arrow-up-short"></i> Live</div>
                        </div>
                        <div class="kpi-icon-box kpi-purple">
                            <i class="bi bi-person-plus"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6 col-sm-12">
                    <div class="kpi-card">
                        <div class="kpi-content">
                            <span>Average Rating</span>
                            <h3>${averageRating} ★</h3>
                            <div class="kpi-trend" style="color: #f59e0b; font-weight:700;">Based on ${totalReviews} reviews</div>
                        </div>
                        <div class="kpi-icon-box kpi-blue">
                            <i class="bi bi-star"></i>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Main Interactive Row 1 -->
            <div class="row g-4 mb-4">
                <!-- Our Services Card -->
                <div class="col-xl-5 col-lg-6">
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Our Services</h5>
                            <a href="${pageContext.request.contextPath}/salon/viewServices" class="view-all">View All</a>
                        </div>
                        
                        <div class="service-tabs">
                            <button class="service-tab active" data-filter="All">All</button>
                            <button class="service-tab" data-filter="Beauty">Beauty</button>
                            <button class="service-tab" data-filter="Wellness">Wellness</button>
                            <button class="service-tab" data-filter="Hair Stylist">Hair Stylist</button>
                        </div>

                        <div class="services-grid" id="categoryGrid">
                            <c:choose>
                                <c:when test="${not empty categorySummaries}">
                                    <c:forEach items="${categorySummaries}" var="catSummary">
                                        <div class="service-cat-item" data-supercat="${catSummary.superCategory}">
                                            <div class="icon-circle"><i class="bi ${catSummary.iconClass}"></i></div>
                                            <h6>${catSummary.name}</h6>
                                            <span>${catSummary.count} Services</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="service-cat-item" data-supercat="Hair Stylist" data-bs-toggle="modal" data-bs-target="#hairServicesModal">
                                        <div class="icon-circle"><i class="bi bi-scissors"></i></div>
                                        <h6>Hair</h6>
                                        <span>12 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Beauty" data-bs-toggle="modal" data-bs-target="#skinServicesModal">
                                        <div class="icon-circle"><i class="bi bi-droplet"></i></div>
                                        <h6>Skin</h6>
                                        <span>10 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Beauty" data-bs-toggle="modal" data-bs-target="#makeupServicesModal">
                                        <div class="icon-circle"><i class="bi bi-magic"></i></div>
                                        <h6>Makeup</h6>
                                        <span>8 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Beauty" data-bs-toggle="modal" data-bs-target="#bridalServicesModal">
                                        <div class="icon-circle"><i class="bi bi-heart"></i></div>
                                        <h6>Bridal</h6>
                                        <span>6 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Beauty" data-bs-toggle="modal" data-bs-target="#nailsServicesModal">
                                        <div class="icon-circle"><i class="bi bi-hand-index-thumb"></i></div>
                                        <h6>Nails</h6>
                                        <span>8 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Beauty" data-bs-toggle="modal" data-bs-target="#hairRemovalServicesModal">
                                        <div class="icon-circle"><i class="bi bi-bandaid"></i></div>
                                        <h6>Hair Removal</h6>
                                        <span>6 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Wellness" data-bs-toggle="modal" data-bs-target="#bodySpaServicesModal">
                                        <div class="icon-circle"><i class="bi bi-flower1"></i></div>
                                        <h6>Body Spa</h6>
                                        <span>6 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Wellness" data-bs-toggle="modal" data-bs-target="#facialsServicesModal">
                                        <div class="icon-circle"><i class="bi bi-emoji-smile"></i></div>
                                        <h6>Facials</h6>
                                        <span>7 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="Wellness" data-bs-toggle="modal" data-bs-target="#massageServicesModal">
                                        <div class="icon-circle"><i class="bi bi-person-arms-up"></i></div>
                                        <h6>Massage</h6>
                                        <span>5 Services</span>
                                    </div>
                                    <div class="service-cat-item" data-supercat="All" data-bs-toggle="modal" data-bs-target="#otherServicesModal">
                                        <div class="icon-circle"><i class="bi bi-three-dots"></i></div>
                                        <h6>Other Services</h6>
                                        <span>4 Services</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Right Side Stacked (Schedule & Overview) -->
                <div class="col-xl-7 col-lg-6 d-flex flex-column" style="gap: 1.5rem;">
                    
                    <!-- Today's Schedule Card -->
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Today's Schedule</h5>
                            <a href="${pageContext.request.contextPath}/booking/list" class="view-all">View Calendar</a>
                        </div>

                        <div class="timeline-wrapper">
                            <c:choose>
                                <c:when test="${not empty todayBookings}">
                                    <c:forEach items="${todayBookings}" var="bkg" end="5">
                                        <div class="timeline-item">
                                            <div class="timeline-time">
                                                ${bkg.preferredTime}
                                            </div>
                                            <div class="timeline-info">
                                                <h6>${not empty bkg.user.fullName ? bkg.user.fullName : 'Client'}</h6>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${bkg.service != null}">${bkg.service.name}</c:when>
                                                        <c:when test="${bkg.treatment != null}">${bkg.treatment.serviceName}</c:when>
                                                        <c:otherwise>Service</c:otherwise>
                                                    </c:choose>
                                                    • ${bkg.bookingType}
                                                </span>
                                            </div>
                                            <c:choose>
                                                <c:when test="${bkg.status == 'COMPLETED'}">
                                                    <span class="timeline-status status-confirmed" style="background:#e6fcf5;color:#0ca678;">Completed</span>
                                                </c:when>
                                                <c:when test="${bkg.status == 'CONFIRMED'}">
                                                    <span class="timeline-status status-inprogress" style="background:#e7f5ff;color:#1c7ed6;">Confirmed</span>
                                                </c:when>
                                                <c:when test="${bkg.status == 'REJECTED' or bkg.status == 'CANCELLED'}">
                                                    <span class="timeline-status" style="background:#fff5f5;color:#ef4444;">${bkg.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="timeline-status status-walkin" style="background:#fdf2f8;color:#db2777;">Pending</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-3">No appointments scheduled today.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Business Overview / Charts Card -->
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Business Overview</h5>
                            <span class="view-all text-muted" style="cursor:pointer;">This Week <i class="bi bi-chevron-down"></i></span>
                        </div>
                        
                        <div class="mb-4">
                            <span style="font-size:0.75rem; color:var(--fdf-text-muted); font-weight:600;">REVENUE</span>
                            <h4 style="font-weight:800; color:var(--fdf-pink); margin-top:2px;">₹${weekRevenue} <span style="font-size:0.75rem; color:#10b981; font-weight:700; margin-left:6px;"><i class="bi bi-arrow-up"></i> This Week</span></h4>
                            
                            <!-- Custom SVG Line Chart representation -->
                            <div class="revenue-chart-box">
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[0]}%;" data-val="₹${dailyRevenue[0]}"><div class="chart-label">Mon</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[1]}%;" data-val="₹${dailyRevenue[1]}"><div class="chart-label">Tue</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[2]}%;" data-val="₹${dailyRevenue[2]}"><div class="chart-label">Wed</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[3]}%;" data-val="₹${dailyRevenue[3]}"><div class="chart-label">Thu</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[4]}%;" data-val="₹${dailyRevenue[4]}"><div class="chart-label">Fri</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[5]}%;" data-val="₹${dailyRevenue[5]}"><div class="chart-label">Sat</div></div>
                                <div class="chart-bar" style="height: ${dailyRevenueHeights[6]}%;" data-val="₹${dailyRevenue[6]}"><div class="chart-label">Sun</div></div>
                            </div>
                        </div>

                        <hr style="border-color: var(--fdf-border); margin: 20px 0;">

                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span style="font-size:0.75rem; color:var(--fdf-text-muted); font-weight:600;">APPOINTMENTS</span>
                                <h4 style="font-weight:800; margin-top:2px; font-size:1.4rem;">${weekTotalAppts}</h4>
                                <ul class="donut-legend mt-2">
                                    <li><span class="legend-color" style="background:#10b981;"></span> Completed (${weekCompletedAppts})</li>
                                    <li><span class="legend-color" style="background:#3b82f6;"></span> Pending (${weekPendingAppts})</li>
                                    <li><span class="legend-color" style="background:#ef4444;"></span> Others (${weekOtherAppts})</li>
                                </ul>
                            </div>
                            <div class="chart-donut-wrapper d-flex align-items-center justify-content-center">
                                <svg width="100" height="100" viewBox="0 0 42 42" class="donut">
                                    <circle class="donut-hole" cx="21" cy="21" r="15.91549430918954" fill="#fff"></circle>
                                    <circle class="donut-ring" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#f1f5f9" stroke-width="4"></circle>
                                    <c:if test="${weekTotalAppts == 0}">
                                    	<circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#cbd5e1" stroke-width="4" stroke-dasharray="100 0" stroke-dashoffset="0"></circle>
                                    </c:if>
                                    <c:if test="${weekTotalAppts > 0}">
                                        <circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#10b981" stroke-width="4" stroke-dasharray="${cPct} ${100 - cPct}" stroke-dashoffset="${offsetCompleted}"></circle>
                                        <circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#3b82f6" stroke-width="4" stroke-dasharray="${pPct} ${100 - pPct}" stroke-dashoffset="${offsetPending}"></circle>
                                        <circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#ef4444" stroke-width="4" stroke-dasharray="${oPct} ${100 - oPct}" stroke-dashoffset="${offsetOther}"></circle>
                                    </c:if>
                                    <g class="chart-text">
                                        <text x="50%" y="54%" class="chart-number" text-anchor="middle" font-size="6" font-weight="800" fill="var(--fdf-text-dark)">${weekTotalAppts}</text>
                                    </g>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Special Offers Section -->
            <c:choose>
                <c:when test="${not empty salonOffers}">
                    <div class="d-flex align-items-center justify-content-between mb-3 mt-4">
                        <h5 class="fw-bold mb-0" style="font-family:'Montserrat'; font-size:1.05rem;">Special Offers</h5>
                        <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salon.id}" class="btn-add-new px-3 py-1" style="font-size:0.85rem; border-radius: 8px;">
                            <i class="bi bi-plus-lg"></i> Create Offer
                        </a>
                    </div>
                    <div class="row g-4 mb-4">
                        <c:forEach var="offer" items="${salonOffers}">
                            <div class="col-xl-4 col-md-6">
                                <div class="offer-card">
                                    <c:set var="status" value="${offer.dynamicStatus}" />
                                    <div class="offer-status status-${status}">${status}</div>
                                    
                                    <h4 class="offer-title">${offer.title}</h4>
                                    <div class="offer-type"><i class="bi bi-tag-fill me-1"></i> ${offer.offerType}</div>
                                    
                                    <p class="offer-desc">${offer.description}</p>
                                    
                                    <div class="price-tag">
                                        <div>
                                            <div class="price-label">Original</div>
                                            <div class="strike-price">₹${offer.originalPrice}</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="price-label">Offer Price</div>
                                            <div class="final-price">₹${offer.discountedPrice > 0 ? offer.discountedPrice : offer.originalPrice}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="usage-stats">
                                        <div><i class="bi bi-calendar-event me-1"></i> Valid: <span class="usage-stat-val">${offer.startDate} to ${offer.endDate}</span></div>
                                    </div>
                                    <div class="usage-stats">
                                        <div><i class="bi bi-person-check me-1"></i> Used: <span class="usage-stat-val">${offer.usageCount} times</span></div>
                                        <c:if test="${offer.totalUsageLimit > 0}">
                                            <div>Limit: <span class="usage-stat-val">${offer.totalUsageLimit}</span></div>
                                        </c:if>
                                    </div>
        
                                    <div class="offer-actions mt-auto pt-3">
                                        <c:choose>
                                            <c:when test="${status == 'Paused'}">
                                                <form action="${pageContext.request.contextPath}/salon/updateOfferStatus" method="POST" class="m-0 flex-grow-1">
                                                    <input type="hidden" name="offerId" value="${offer.id}">
                                                    <input type="hidden" name="salonId" value="${salon.id}">
                                                    <input type="hidden" name="status" value="Resume">
                                                    <input type="hidden" name="redirect" value="/salons/dashboard">
                                                    <button type="submit" class="btn-action btn-resume w-100"><i class="bi bi-play-circle me-1"></i> Resume</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/salon/updateOfferStatus" method="POST" class="m-0 flex-grow-1">
                                                    <input type="hidden" name="offerId" value="${offer.id}">
                                                    <input type="hidden" name="salonId" value="${salon.id}">
                                                    <input type="hidden" name="status" value="Paused">
                                                    <input type="hidden" name="redirect" value="/salons/dashboard">
                                                    <button type="submit" class="btn-action btn-pause w-100" ${status == 'Expired' ? 'disabled' : ''}><i class="bi bi-pause-circle me-1"></i> Pause</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                        <form action="${pageContext.request.contextPath}/salon/deleteOffer" method="POST" class="m-0 flex-grow-1" onsubmit="return confirm('Are you sure you want to delete this offer?');">
                                            <input type="hidden" name="offerId" value="${offer.id}">
                                            <input type="hidden" name="salonId" value="${salon.id}">
                                            <input type="hidden" name="redirect" value="/salons/dashboard">
                                            <button type="submit" class="btn-action btn-archive w-100"><i class="bi bi-trash me-1"></i> Delete</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Special Offers Banner (Empty State) -->
                    <div class="anti-gravity-banner" style="background: linear-gradient(135deg, #fff1f2 0%, #fce7f3 100%); border-color: #fbcfe8;">
                        <div class="ag-left">
                            <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=300&auto=format&fit=crop&q=60" alt="Special Offers" class="ag-img" style="border-radius: 16px;">
                            <div class="ag-content">
                                <h4 style="color: var(--fdf-text-dark);">SPECIAL OFFERS <span style="background: var(--fdf-pink); color: white;">Boost Your Sales!</span></h4>
                                <p style="color: var(--fdf-text-muted);">Create and promote exclusive packages and discounts. Salons with active offers see a 34% increase in online bookings.</p>
                                <button class="btn-pink-gradient py-2 px-4" style="box-shadow:none; font-size:0.82rem;" onclick="location.href='${pageContext.request.contextPath}/salon/addOffer?salonId=${salon.id}'">Create New Offer</button>
                            </div>
                        </div>
                        <div class="ag-right">
                            <div class="benefits-grid">
                                <div class="benefit-item" style="color:#db2777;"><i class="bi bi-graph-up-arrow"></i> Increase Bookings</div>
                                <div class="benefit-item" style="color:#db2777;"><i class="bi bi-people-fill"></i> Attract New Clients</div>
                                <div class="benefit-item" style="color:#db2777;"><i class="bi bi-calendar-check-fill"></i> Fill Empty Slots</div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Quick Actions -->
            <h5 class="fw-bold mb-3" style="font-family:'Montserrat'; font-size:1.05rem;">Quick Actions</h5>
            <div class="qa-row">
                <a href="${pageContext.request.contextPath}/booking/list" class="qa-btn">
                    <i class="bi bi-plus-circle"></i> Add Appointment
                </a>
                <a href="#addWalkin" class="qa-btn" onclick="alert('Initializing Walk-in booking modal...')">
                    <i class="bi bi-person-plus"></i> Add Walk-in
                </a>
                <a href="${pageContext.request.contextPath}/salon/addService" class="qa-btn">
                    <i class="bi bi-plus-square"></i> Add Service
                </a>
                <a href="${pageContext.request.contextPath}/salon/loyalty" class="qa-btn">
                    <i class="bi bi-gift"></i> Loyalty Settings
                </a>
                <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salon.id}" class="qa-btn">
                    <i class="bi bi-tag"></i> Add Offer
                </a>
                <a href="${pageContext.request.contextPath}/salon/billing" class="qa-btn">
                    <i class="bi bi-file-earmark-spreadsheet"></i> Generate Invoice
                </a>
                <a href="${pageContext.request.contextPath}/salon/payments" class="qa-btn">
                    <i class="bi bi-cash-stack"></i> Add Expense
                </a>
            </div>

            <!-- Main Row 2 (Recent Table, Top Services, Reviews) -->
            <div class="row g-4">
                <!-- Recent Appointments Card -->
                <div class="col-xl-5 col-lg-12">
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Recent Appointments</h5>
                            <a href="${pageContext.request.contextPath}/booking/list" class="view-all">View All</a>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table custom-table">
                                <thead>
                                    <tr>
                                        <th>Client</th>
                                        <th>Service</th>
                                        <th>Date & Time</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentBookings1}">
                                            <c:forEach items="${recentBookings1}" var="b" end="4">
                                                <tr>
                                                    <td>
                                                        <div class="avatar-info">
                                                            <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                                            <h6>${not empty b.user.fullName ? b.user.fullName : 'Client'}</h6>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${b.service != null}">${b.service.name}</c:when>
                                                            <c:when test="${b.treatment != null}">${b.treatment.serviceName}</c:when>
                                                            <c:otherwise>Service</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${b.bookingDate}, ${b.preferredTime}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${b.status == 'COMPLETED'}">
                                                                <span class="timeline-status status-confirmed" style="background:#e6fcf5;color:#0ca678;">Completed</span>
                                                            </c:when>
                                                            <c:when test="${b.status == 'CONFIRMED'}">
                                                                <span class="timeline-status status-inprogress" style="background:#e7f5ff;color:#1c7ed6;">Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${b.status == 'REJECTED' or b.status == 'CANCELLED'}">
                                                                <span class="timeline-status" style="background:#fff5f5;color:#ef4444;">${b.status}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="timeline-status status-walkin" style="background:#fdf2f8;color:#db2777;">Pending</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="4" class="text-center text-muted">No appointments yet.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Top Services Card -->
                <div class="col-xl-3 col-md-6">
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Top Services</h5>
                            <span class="view-all text-muted" style="cursor:pointer;">This Month <i class="bi bi-chevron-down"></i></span>
                        </div>

                        <div class="top-services-list">
                            <c:choose>
                                <c:when test="${not empty topServices}">
                                    <c:forEach items="${topServices}" var="ts" varStatus="status" end="4">
                                        <div class="top-service-item">
                                            <div class="top-service-left">
                                                <div class="top-service-rank">${status.count}</div>
                                                <span class="top-service-name">${ts[0]}</span>
                                            </div>
                                            <span class="top-service-bookings">${ts[1]} Bookings</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted p-3">
                                        <small>No top services found yet.</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Recent Reviews Card -->
                <div class="col-xl-4 col-md-6">
                    <div class="premium-card">
                        <div class="card-header-custom">
                            <h5>Recent Reviews</h5>
                            <a href="${pageContext.request.contextPath}/salon/reviews/list" class="view-all">View All</a>
                        </div>

                        <div class="reviews-wrapper">
                            <c:choose>
                                <c:when test="${not empty recentReviews}">
                                    <c:forEach items="${recentReviews}" var="rev" end="2">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <div class="review-author">
                                                    <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="User" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                                    <h6>${rev.user != null ? rev.user.name : 'Client'}</h6>
                                                </div>
                                                <div class="stars-box">
                                                    <c:forEach begin="1" end="${rev.rating}">
                                                        <i class="bi bi-star-fill"></i>
                                                    </c:forEach>
                                                    <c:forEach begin="${rev.rating + 1}" end="5">
                                                        <i class="bi bi-star"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <p class="review-text">"${rev.comment}"</p>
                                            <span class="review-time">${rev.createdAt.toLocalDate().toString()}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-3">No reviews yet.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Summary Bar -->
            <div class="bottom-summary-bar">
                <div class="summary-grid">
                    <div class="summary-item">
                        <span>Total Customers</span>
                        <h5>1,248 <span style="font-size:0.75rem; color:#10b981; font-weight:700;"><i class="bi bi-arrow-up"></i> 18%</span></h5>
                    </div>
                    <div class="summary-item">
                        <span>Memberships Sold</span>
                        <h5>186 <span style="font-size:0.75rem; color:#10b981; font-weight:700;"><i class="bi bi-arrow-up"></i> 12%</span></h5>
                    </div>
                    <div class="summary-item">
                        <span>Total Services</span>
                        <h5>${servicesCount != null ? servicesCount : 0} <span style="font-size:0.75rem; color:#10b981; font-weight:700;">Active</span></h5>
                    </div>
                    <div class="summary-item">
                        <span>Low Stock Items</span>
                        <h5 style="color:#ef4444;">8 <span style="font-size:0.72rem; color:#f97316; font-weight:600; text-transform:none;">(Need Attention)</span></h5>
                    </div>
                    <div class="summary-item">
                        <span>Total Staff</span>
                        <h5>${staffCount != null ? staffCount : 6} <span style="font-size:0.72rem; color:#10b981; font-weight:600;">(Active)</span></h5>
                    </div>
                    <div class="summary-item">
                        <span>Salon Status</span>
                        <h5 class="text-success">OPEN <span style="font-size:0.72rem; color:var(--fdf-text-muted); font-weight:600; text-transform:none;">(Closes 9PM)</span></h5>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Hair Services Modal -->
    <div class="modal fade" id="hairServicesModal" tabindex="-1" aria-labelledby="hairServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="hairServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-scissors" style="color: var(--fdf-pink);"></i> Hair Services (12)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Haircut</h6><span class="text-muted" style="font-size: 0.8rem;">₹499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hair Spa</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hair Coloring</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Highlights</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Keratin Treatment</h6><span class="text-muted" style="font-size: 0.8rem;">₹2999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hair Rebonding</h6><span class="text-muted" style="font-size: 0.8rem;">₹3499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Root Touch Up</h6><span class="text-muted" style="font-size: 0.8rem;">₹699 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Blow Dry</h6><span class="text-muted" style="font-size: 0.8rem;">₹399 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hair Wash</h6><span class="text-muted" style="font-size: 0.8rem;">₹299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hair Styling</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Deep Conditioning</h6><span class="text-muted" style="font-size: 0.8rem;">₹899 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Scalp Treatment</h6><span class="text-muted" style="font-size: 0.8rem;">₹1299 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Skin Services Modal -->
    <div class="modal fade" id="skinServicesModal" tabindex="-1" aria-labelledby="skinServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="skinServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-droplet" style="color: var(--fdf-pink);"></i> Skin Services (10)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Skin Brightening</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Anti-Aging</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Acne Treatment</h6><span class="text-muted" style="font-size: 0.8rem;">₹1299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Pigmentation</h6><span class="text-muted" style="font-size: 0.8rem;">₹1799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Face Clean Up</h6><span class="text-muted" style="font-size: 0.8rem;">₹599 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Skin Polishing</h6><span class="text-muted" style="font-size: 0.8rem;">₹1599 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Microdermabrasion</h6><span class="text-muted" style="font-size: 0.8rem;">₹2499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hydration</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Face Bleach</h6><span class="text-muted" style="font-size: 0.8rem;">₹399 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Tan Removal</h6><span class="text-muted" style="font-size: 0.8rem;">₹699 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Makeup Services Modal -->
    <div class="modal fade" id="makeupServicesModal" tabindex="-1" aria-labelledby="makeupServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="makeupServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-magic" style="color: var(--fdf-pink);"></i> Makeup Services (8)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Party Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Engagement Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹3999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Airbrush Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹4999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">HD Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹3499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Eye Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Light Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Saree Draping</h6><span class="text-muted" style="font-size: 0.8rem;">₹499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Hairstyling</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bridal Services Modal -->
    <div class="modal fade" id="bridalServicesModal" tabindex="-1" aria-labelledby="bridalServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="bridalServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-heart" style="color: var(--fdf-pink);"></i> Bridal Services (6)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Bridal Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹8999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Pre-Bridal Package</h6><span class="text-muted" style="font-size: 0.8rem;">₹5999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Bridal Mehendi</h6><span class="text-muted" style="font-size: 0.8rem;">₹2999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Haldi Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹3499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Reception Makeup</h6><span class="text-muted" style="font-size: 0.8rem;">₹6999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Bridal Hair</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Nails Services Modal -->
    <div class="modal fade" id="nailsServicesModal" tabindex="-1" aria-labelledby="nailsServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="nailsServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-hand-index-thumb" style="color: var(--fdf-pink);"></i> Nails Services (8)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Gel Polish</h6><span class="text-muted" style="font-size: 0.8rem;">₹699 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Nail Extension</h6><span class="text-muted" style="font-size: 0.8rem;">₹1299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Nail Art</h6><span class="text-muted" style="font-size: 0.8rem;">₹299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Acrylic Nails</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">French Manicure</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Classic Manicure</h6><span class="text-muted" style="font-size: 0.8rem;">₹499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Classic Pedicure</h6><span class="text-muted" style="font-size: 0.8rem;">₹599 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Spa Pedicure</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Hair Removal Services Modal -->
    <div class="modal fade" id="hairRemovalServicesModal" tabindex="-1" aria-labelledby="hairRemovalServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="hairRemovalServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-bandaid" style="color: var(--fdf-pink);"></i> Hair Removal Services (6)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Full Body Wax</h6><span class="text-muted" style="font-size: 0.8rem;">₹1299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Honey Wax</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Chocolate Wax</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Rica Wax</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Threading (Eyebrows)</h6><span class="text-muted" style="font-size: 0.8rem;">₹49 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Threading (Upper Lip)</h6><span class="text-muted" style="font-size: 0.8rem;">₹39 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Body Spa Services Modal -->
    <div class="modal fade" id="bodySpaServicesModal" tabindex="-1" aria-labelledby="bodySpaServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="bodySpaServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-flower1" style="color: var(--fdf-pink);"></i> Body Spa Services (6)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Body Scrub</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Body Polishing</h6><span class="text-muted" style="font-size: 0.8rem;">₹2499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Deep Tissue Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Swedish Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹1799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Aromatherapy</h6><span class="text-muted" style="font-size: 0.8rem;">₹1899 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Back Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹899 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Facials Services Modal -->
    <div class="modal fade" id="facialsServicesModal" tabindex="-1" aria-labelledby="facialsServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="facialsServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-emoji-smile" style="color: var(--fdf-pink);"></i> Facials Services (7)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Fruit Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Gold Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹1299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Diamond Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹1499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Pearl Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹1199 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">O3+ Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Lotus Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹899 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Anti-Tan Facial</h6><span class="text-muted" style="font-size: 0.8rem;">₹1099 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Massage Services Modal -->
    <div class="modal fade" id="massageServicesModal" tabindex="-1" aria-labelledby="massageServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="massageServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-person-arms-up" style="color: var(--fdf-pink);"></i> Massage Services (5)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Head Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹399 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Foot Reflexology</h6><span class="text-muted" style="font-size: 0.8rem;">₹799 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Neck & Shoulder</h6><span class="text-muted" style="font-size: 0.8rem;">₹499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Back Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹899 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Full Body Massage</h6><span class="text-muted" style="font-size: 0.8rem;">₹1999 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Other Services Modal -->
    <div class="modal fade" id="otherServicesModal" tabindex="-1" aria-labelledby="otherServicesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="otherServicesModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-three-dots" style="color: var(--fdf-pink);"></i> Other Services (4)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc;">
                    <div class="row g-3">
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Saree Draping</h6><span class="text-muted" style="font-size: 0.8rem;">₹499 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Mehendi</h6><span class="text-muted" style="font-size: 0.8rem;">₹999 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Ear Piercing</h6><span class="text-muted" style="font-size: 0.8rem;">₹299 onwards</span></div></div>
                        <div class="col-md-4 col-sm-6"><div class="p-3 bg-white rounded-3 border" style="text-align: center; cursor: pointer;"><h6 class="mb-1 fw-bold">Consultation</h6><span class="text-muted" style="font-size: 0.8rem;">₹199 onwards</span></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Calendar Modal -->
    <div class="modal fade" id="calendarModal" tabindex="-1" aria-labelledby="calendarModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.1);">
                <div class="modal-header" style="border-bottom: 1px solid var(--fdf-border); padding: 20px 24px;">
                    <h5 class="modal-title fw-bold" id="calendarModalLabel" style="color: var(--fdf-text-dark); font-family: 'Montserrat', sans-serif;"><i class="bi bi-calendar3" style="color: var(--fdf-pink);"></i> Booking Calendar</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding: 24px; background: #fafafc; min-height: 600px;">
                    <div id="bookingCalendar"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- FullCalendar -->
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
    <!-- SockJS and STOMP for Real-Time WebSockets -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const tabs = document.querySelectorAll(".service-tab");
            const items = document.querySelectorAll(".service-cat-item");
            
            tabs.forEach(tab => {
                tab.addEventListener("click", () => {
                    tabs.forEach(t => t.classList.remove("active"));
                    tab.classList.add("active");
                    
                    const filter = tab.dataset.filter;
                    items.forEach(item => {
                        if (filter === "all" || item.dataset.category === filter) {
                            item.style.display = "block";
                        } else {
                            item.style.display = "none";
                        }
                    });
                });
            });
            
            // Calendar Initialization
            var calendarEl = document.getElementById('bookingCalendar');
            var eventsData = ${calendarEventsJson != null ? calendarEventsJson : "[]"};
            
            var calendar = new FullCalendar.Calendar(calendarEl, {
              initialView: 'dayGridMonth',
              headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
              },
              events: eventsData,
              eventTimeFormat: {
                hour: 'numeric',
                minute: '2-digit',
                meridiem: 'short'
              }
            });
            
            // Render calendar only when modal is shown to fix sizing issues
            const calendarModal = document.getElementById('calendarModal');
            if (calendarModal) {
                calendarModal.addEventListener('shown.bs.modal', function () {
                    calendar.render();
                });
            }
        });
    </script>
    
    <!-- Custom Toast Notification Container -->
    <div id="customToastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 9999; margin-top: 20px; transition: transform 0.3s ease-in-out, opacity 0.3s; transform: translateX(100%); opacity: 0;">
        <div class="toast align-items-center text-white bg-primary border-0 shadow-lg d-block" style="width: 350px; border-radius: 12px;">
            <div class="d-flex">
                <div class="toast-body d-flex align-items-center gap-3 p-3 w-100">
                    <i class="bi bi-bell-fill fs-3 text-warning"></i>
                    <div style="flex: 1;">
                        <strong class="me-auto d-block" id="toastTitle" style="font-size: 1rem; margin-bottom: 2px;">New Notification</strong>
                        <div id="toastMessage" style="font-size: 0.85rem; opacity: 0.9;"></div>
                    </div>
                    <button type="button" class="btn-close btn-close-white ms-2" onclick="hideCustomToast()" aria-label="Close"></button>
                </div>
            </div>
        </div>
    </div>

    <script>
        let toastTimeout;
        let stompClient = null;

        function showCustomToast(title, message) {
            $('#toastTitle').text(title);
            $('#toastMessage').text(message);
            const container = $('#customToastContainer');
            container.css({ 'transform': 'translateX(0)', 'opacity': '1' });
            
            clearTimeout(toastTimeout);
            toastTimeout = setTimeout(hideCustomToast, 5000);
        }
        
        function hideCustomToast() {
            $('#customToastContainer').css({ 'transform': 'translateX(100%)', 'opacity': '0' });
        }

        function fetchBadgeCounts() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/salon/badges/counts',
                method: 'GET',
                success: function(data) {
                    if (data.notifications > 0) {
                        $('#notif-badge').text(data.notifications).show();
                    } else {
                        $('#notif-badge').hide();
                    }
                    
                    if (data.messages > 0) {
                        $('#msg-badge').text(data.messages).show();
                    } else {
                        $('#msg-badge').hide();
                    }
                }
            });
        }

        function updateNotificationDropdown(notifications) {
            const list = $('#notifDropdownList');
            list.find('.notif-item').remove();
            
            if (notifications && notifications.length > 0) {
                $('#empty-notif').hide();
                notifications.slice(0, 5).forEach(n => {
                    const bgClass = n.read ? '' : 'bg-light';
                    const time = new Date(n.timestamp).toLocaleString();
                    const li = `<li class="notif-item">
                        <a class="dropdown-item py-2 px-3 \${bgClass}" href="${pageContext.request.contextPath}/salon/notifications">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1 text-dark fw-bold" style="font-size: 0.9rem;">\${n.title}</h6>
                                <small class="text-muted" style="font-size: 0.7rem;">\${time}</small>
                            </div>
                            <p class="mb-1 text-muted text-wrap" style="font-size: 0.8rem; white-space: normal;">\${n.message}</p>
                        </a>
                    </li>`;
                    $(li).insertAfter('#empty-notif');
                });
            } else {
                $('#empty-notif').show();
            }
        }

        $(document).ready(function() {
            // Initial fetch of badge counts
            fetchBadgeCounts();
            
            // Connect to STOMP for true real-time push notifications
            const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.debug = null; // Disable debug logging
            
            stompClient.connect({}, function (frame) {
                console.log('Connected to real-time notifications');
                const salonId = '${sessionScope.loggedSalon.id}';
                
                // Subscribe to notifications topic
                stompClient.subscribe('/topic/salon/notifications/' + salonId, function (message) {
                    const notif = JSON.parse(message.body);
                    console.log("New real-time notification!", notif);
                    
                    // Show toast popup immediately!
                    showCustomToast(notif.title, notif.message);
                    
                    // Update the badge counts
                    fetchBadgeCounts();
                    
                    // If dropdown was opened, refresh it
                    if ($('#notifDropdownList').is(':visible')) {
                        $('#notifDropdownToggle').trigger('click');
                    }
                });
            }, function(error) {
                console.error('STOMP connection error:', error);
                // Fallback to polling if websocket fails
                setInterval(fetchBadgeCounts, 15000);
            });

            // Fetch recent notifications when dropdown is opened
            $('#notifDropdownToggle').on('click', function() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/salon/notifications',
                    method: 'GET',
                    success: function(notifications) {
                        updateNotificationDropdown(notifications);
                    }
                });
            });
        });

        function markNotificationsRead() {
            if ($('#notif-badge').is(':visible')) {
                $.post('${pageContext.request.contextPath}/api/salon/notifications/mark-read', function() {
                    $('#notif-badge').hide();
                    lastNotifCount = 0; // reset local tracker
                });
            }
        }
    </script>
</body>
</html>

