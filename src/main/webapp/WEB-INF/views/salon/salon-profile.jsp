<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Profile | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --rose-soft: #FFF1F2;
            --rose-light: #FFE4E6;
            --rose-border: #FECDD3;
            --navy: #0F172A;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --shadow-card: 0 4px 20px rgba(0, 0, 0, 0.03);

            --sidebar-width: 0px;
            --dashboard-bg: #F8FAFC;
            --fdf-burgundy: #0F172A;
            --fdf-pink: #F43F5E;
            --fdf-pink-light: #FFE4E6;
            --fdf-rose: #E11D48;
            --fdf-text-dark: #0F172A;
            --fdf-text-muted: #64748B;
            --fdf-border: #E2E8F0;
            --brand-pink: #F43F5E;
            --brand-pink-light: #FFE4E6;
            --text-dark: #0F172A;
            --text-muted: #64748B;
            --bg-color: #F8FAFC;
        }

        html, body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-page);
            color: var(--navy);
            margin: 0;
            padding: 0;
            width: 100%;
            max-width: 100vw;
            overflow-x: hidden;
        }
        
        *, *::before, *::after {
            box-sizing: border-box;
        }

        /* App Header matching Doctor completion page */
        .app-header {
            background: #FFFFFF;
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 100;
            gap: 12px;
            flex-wrap: wrap;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
            font-size: 1.1rem;
        }
        .header-brand img {
            height: 44px;
            width: 44px;
            border-radius: 10px;
            object-fit: cover;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn-skip {
            padding: 8px 16px;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-skip:hover {
            background: var(--bg-page);
        }
        .btn-header-save {
            padding: 8px 20px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-header-save:hover {
            background: var(--primary-hover);
        }

        .main-content {
            margin-left: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            padding: 20px clamp(16px, 2.5vw, 32px) 80px !important;
            box-sizing: border-box !important;
            min-height: 100vh;
        }

        /* Hero Section */
        .hero-section {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }
        .hero-top-row { display: flex; gap: 30px; margin-bottom: 20px; }
        
        .hero-info-box { width: 35%; display: flex; gap: 20px; align-items: flex-start; }
        .logo-container { position: relative; width: 130px; height: 130px; flex-shrink: 0; }
        .logo-img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; box-shadow: 0 4px 14px rgba(0,0,0,0.08); border: 2px solid #FFFFFF; }
        .cam-icon { position: absolute; bottom: 0; right: 0; background: white; width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 8px rgba(0,0,0,0.15); color: var(--navy); cursor: pointer; font-size: 1.1rem; border: 1px solid var(--border-color); }
        
        .info-details { padding-top: 5px; }
        .info-details h3 { font-size: 1.35rem; font-weight: 800; margin-bottom: 5px; display: flex; align-items: center; gap: 6px; color: var(--navy); }
        .verified-badge { color: var(--primary); font-size: 1.1rem; }
        .subtitle { font-size: 0.8rem; color: var(--text-gray); margin-bottom: 12px; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; font-weight: 600; }
        .women-pill { color: var(--primary); font-weight: 700; background: var(--rose-soft); border: 1px solid var(--rose-border); padding: 2px 10px; border-radius: 999px; font-size: 0.75rem; }
        
        .contact-list { list-style: none; padding: 0; margin: 0; font-size: 0.84rem; color: var(--navy); font-weight: 600; }
        .contact-list li { margin-bottom: 6px; display: flex; align-items: flex-start; gap: 10px; }
        .contact-list i { color: var(--primary); font-size: 0.95rem; margin-top: 2px; }
        .contact-list .text-muted { font-weight: 500; font-size: 0.8rem; color: var(--text-gray) !important; }
        
        /* Right: Cover & Photos */
        .hero-photos-box { width: 65%; display: flex; flex-direction: column; gap: 12px; }
        .cover-img-container { position: relative; width: 100%; height: 130px; border-radius: 14px; overflow: hidden; border: 1px solid var(--border-color); }
        .cover-img { width: 100%; height: 100%; object-fit: cover; }
        
        .thumb-row { display: flex; gap: 10px; align-items: center; overflow-x: auto; padding-bottom: 5px; }
        .thumb-img { width: 64px; height: 64px; border-radius: 10px; object-fit: cover; flex-shrink: 0; border: 1px solid var(--border-color); }
        .btn-add-photo { height: 64px; border: 1px dashed var(--rose-border); border-radius: 10px; background: var(--rose-soft); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.82rem; cursor: pointer; padding: 0 16px; flex-shrink: 0; gap: 8px; white-space: nowrap; }

        .hero-bottom-actions { display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid var(--border-color); }
        .rating-box { display: flex; align-items: center; gap: 15px; font-size: 0.88rem; font-weight: 700; color: var(--navy); }
        .rating-box .star { color: #f59e0b; font-size: 1.1rem; }
        .rating-box .open-status { color: #16a34a; background: #F0FDF4; border: 1px solid #BBF7D0; padding: 2px 10px; border-radius: 999px; font-size: 0.75rem; }
        .action-btns { display: flex; gap: 10px; }
        .btn-edit { border: 1px solid var(--border-color); color: var(--navy); background: white; padding: 8px 18px; border-radius: 10px; font-weight: 700; font-size: 0.84rem; display: flex; align-items: center; gap: 6px; cursor: pointer; }
        .btn-preview { background-color: var(--primary); color: white; border: none; padding: 8px 18px; border-radius: 10px; font-weight: 700; font-size: 0.84rem; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25); text-decoration: none; }
        .btn-preview:hover { background-color: var(--primary-hover); color: white; }

        /* Profile Tracker / Completion Bar matching Doctor */
        .profile-tracker {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }
        .pt-left { display: flex; align-items: center; gap: 20px; width: 25%; }
        .pt-circle-wrap { position: relative; width: 68px; height: 68px; border-radius: 50%; background: #f0f0f0; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .pt-circle-inner { width: 56px; height: 56px; border-radius: 50%; background: white; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: 800; color: var(--navy); position: absolute; }
        .pt-text h4 { font-size: 1rem; font-weight: 800; margin: 0 0 4px 0; color: var(--navy); }
        .pt-text p { font-size: 0.8rem; color: var(--text-gray); margin: 0; line-height: 1.35; }
        
        .pt-steps { flex-grow: 1; display: flex; justify-content: space-between; position: relative; --progress: 0%; }
        .pt-steps::before { content: ""; position: absolute; top: 12px; left: 20px; right: 20px; height: 2px; background: linear-gradient(to right, var(--primary) var(--progress), var(--rose-light) var(--progress)); z-index: 1; }
        .pt-step { position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 6px; width: 70px; }
        .pt-icon { width: 26px; height: 26px; border-radius: 50%; background: white; border: 2px solid var(--border-color); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; color: var(--text-gray); }
        .pt-step.done .pt-icon { border-color: var(--primary); color: white; background: var(--primary); }
        .pt-label { font-size: 0.7rem; font-weight: 700; color: var(--navy); text-align: center; line-height: 1.25; }
        .pt-status { font-size: 0.65rem; color: var(--text-gray); font-weight: 600; }
        .pt-step.done .pt-status { color: var(--success); }
        
        .btn-visibility { background: white; border: 1px solid var(--rose-border); color: var(--primary); padding: 8px 16px; border-radius: 999px; font-weight: 700; font-size: 0.8rem; text-decoration: none; display: flex; align-items: center; gap: 8px; white-space: nowrap; transition: 0.2s;}
        .btn-visibility:hover { background: var(--rose-soft); color: var(--primary); }

        /* Tabs Navigation Bar */
        .custom-tabs {
            display: flex;
            gap: 10px;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 24px;
            overflow-x: auto;
            padding: 8px 0;
            background: var(--bg-page);
            position: sticky;
            top: 70px;
            z-index: 40;
            -webkit-overflow-scrolling: touch;
        }
        .custom-tab {
            text-decoration: none;
            padding: 10px 18px;
            color: var(--text-gray);
            font-weight: 700;
            font-size: 0.88rem;
            border-radius: 999px;
            border: 1px solid transparent;
            background: transparent;
            white-space: nowrap;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .custom-tab:hover {
            color: var(--primary);
            background: var(--rose-soft);
        }
        .custom-tab.active {
            color: var(--primary);
            background: var(--rose-soft);
            border-color: var(--rose-border);
        }

        .tab-pane {
            display: block !important;
            margin-bottom: 24px;
            scroll-margin-top: 130px;
        }

        /* Custom Multi-Select Dropdowns matching Doctor Profile Completion */
        .fdf-multiselect {
            position: relative;
            width: 100%;
        }
        .fdf-multiselect-trigger {
            min-height: 44px;
            padding: 6px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            background: #FFFFFF;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        .fdf-multiselect-trigger:hover {
            border-color: #cbd5e1;
        }
        .fdf-multiselect-trigger:focus, .fdf-multiselect.open .fdf-multiselect-trigger {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
            outline: none;
        }
        .fdf-multiselect-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            align-items: center;
            flex: 1;
        }
        .fdf-multiselect-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--rose-light);
            color: var(--primary);
            border: 1px solid rgba(244, 63, 94, 0.25);
            border-radius: 6px;
            padding: 3px 8px;
            font-size: 0.82rem;
            font-weight: 600;
        }
        .fdf-multiselect-chip-remove {
            cursor: pointer;
            font-size: 1.1rem;
            line-height: 0.8;
            color: var(--primary);
            opacity: 0.7;
            transition: opacity 0.15s;
        }
        .fdf-multiselect-chip-remove:hover {
            opacity: 1;
        }
        .fdf-multiselect-placeholder {
            color: #94a3b8;
            font-size: 0.88rem;
            user-select: none;
        }
        .fdf-multiselect-dropdown {
            position: absolute;
            top: calc(100% + 4px);
            left: 0;
            right: 0;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            z-index: 1000;
            display: none;
            flex-direction: column;
            overflow: hidden;
        }
        .fdf-multiselect.open .fdf-multiselect-dropdown {
            display: flex;
        }
        .fdf-multiselect-search-wrap {
            padding: 8px 10px;
            border-bottom: 1px solid #f1f5f9;
            background: #f8fafc;
        }
        .fdf-multiselect-search {
            width: 100%;
            padding: 7px 10px;
            font-size: 0.85rem;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            outline: none;
            box-sizing: border-box;
        }
        .fdf-multiselect-search:focus {
            border-color: var(--primary);
        }
        .fdf-multiselect-list {
            max-height: 200px;
            overflow-y: auto;
            padding: 4px 0;
        }
        .fdf-multiselect-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 14px;
            font-size: 0.88rem;
            color: var(--navy);
            cursor: pointer;
            transition: background 0.15s;
            user-select: none;
        }
        .fdf-multiselect-item:hover {
            background: #fff1f2;
        }
        .fdf-multiselect-item input[type="checkbox"] {
            accent-color: var(--primary);
            width: 16px;
            height: 16px;
            cursor: pointer;
        }
        .fdf-multiselect-custom-wrap {
            display: flex;
            gap: 6px;
            padding: 8px 10px;
            border-top: 1px solid #f1f5f9;
            background: #f8fafc;
        }
        .fdf-multiselect-custom-input {
            flex: 1;
            padding: 6px 10px;
            font-size: 0.82rem;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            outline: none;
        }
        .fdf-multiselect-custom-input:focus {
            border-color: var(--primary);
        }
        .fdf-multiselect-custom-btn {
            padding: 6px 12px;
            font-size: 0.82rem;
            font-weight: 700;
            background: var(--navy);
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.15s;
        }
        .fdf-multiselect-custom-btn:hover {
            background: #0f172a;
        }

        /* Document Status Wrap matching Doctor Profile Completion */
        .doc-file-input {
            width: 100%;
            box-sizing: border-box;
            font-size: 0.85rem;
            cursor: pointer;
        }
        .doc-status-wrap {
            padding: 10px 14px;
            border-radius: 10px;
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
        }
        .doc-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
            margin-bottom: 6px;
        }
        .doc-badge.uploaded {
            background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0;
        }
        .doc-badge.selected {
            background: #EFF6FF; color: #1D4ED8; border: 1px solid #BFDBFE;
        }
        .doc-badge.not-uploaded {
            background: #F1F5F9; color: #64748B; border: 1px solid #CBD5E1;
        }
        .doc-preview-box {
            margin-top: 4px;
        }
        .doc-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
        }
        .doc-link:hover { text-decoration: underline; color: var(--navy); }

        /* Form Cards & Input Controls */
        .form-section {
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: clamp(20px, 2.5vw, 28px);
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }
        .section-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
        .section-header i { background: var(--rose-soft); color: var(--primary); width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        .section-header h4 { font-size: 1rem; font-weight: 800; margin: 0; color: var(--navy); }

        .f-group { margin-bottom: 16px; }
        .f-label { display: block; font-weight: 700; margin-bottom: 6px; color: var(--navy); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.4px; }
        .f-label .req { color: var(--primary); }

        .f-control { width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 0.88rem; color: var(--navy); background: white; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit;}
        .f-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.15); }
        select.f-control { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23666' class='bi bi-chevron-down' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 12px center; padding-right: 32px; }

        .f-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .f-row-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }

        .top-header { display: none !important; }
        .bottom-action-bar { display: none !important; }

        /* Responsive Breakpoints */
        @media (max-width: 991px) {
            .app-header {
                padding: 12px 16px;
                gap: 10px;
            }
            .header-brand {
                font-size: 1rem;
            }
            .header-actions {
                width: 100%;
                justify-content: space-between;
                flex-wrap: wrap;
            }
            .main-content {
                padding: 16px 12px 120px 12px !important;
                margin-left: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
            }
            .hero-top-row {
                flex-direction: column !important;
                gap: 16px !important;
            }
            .hero-info-box, .hero-photos-box {
                width: 100% !important;
            }
            .form-grid-3col, .form-grid-2col, .f-row-2, .f-row-3 {
                grid-template-columns: 1fr !important;
            }
            .profile-tracker {
                flex-direction: column;
                align-items: flex-start;
                padding: 16px;
            }
            .pt-left {
                width: 100%;
            }
            .pt-steps {
                width: 100%;
                flex-wrap: wrap;
                gap: 12px;
            }
            .pt-step {
                width: calc(50% - 12px);
            }
            .pt-steps::before {
                display: none;
            }
        }
    </style>

    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        .app-header {
            background: white;
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border-color, #E2E8F0);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            color: var(--fdf-burgundy, #2d0b20);
            text-decoration: none;
            font-size: 1.1rem;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .btn-skip {
            padding: 8px 16px;
            background: transparent;
            border: 1px solid var(--fdf-border, #E2E8F0);
            color: var(--fdf-text-muted, #64748b);
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
        }
        .btn-header-save {
            padding: 8px 20px;
            background: var(--fdf-pink, #db2777);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
        }
        .main-content { margin-left: 0 !important; padding: 25px max(35px, calc((100vw - 1200px)/2)) 80px !important; }
        .bottom-action-bar { left: 0 !important; }
        
        /* Hide existing top header and bottom save bar since we have the top header */
        .top-header { display: none !important; }

        .bottom-action-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: #ffffff;
            padding: 12px 24px;
            border-top: 1px solid #e2e8f0;
            box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.08);
            display: flex !important;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            z-index: 1000;
        }

        /* Modal Overlay & Card Styling (Doctor Parity) */
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 9999; padding: 16px;
        }
        .review-modal-card {
            background: #FFFFFF; border-radius: 20px; max-width: 800px; width: 100%;
            max-height: 92vh; display: flex; flex-direction: column; padding: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        .review-modal-body {
            overflow-y: auto; padding-right: 6px; margin: 12px 0 16px; flex: 1;
        }
        .review-section-block {
            background: #F8FAFC; border: 1px solid #E2E8F0;
            border-radius: 12px; padding: 14px 16px; margin-bottom: 14px;
        }
        .review-section-title {
            font-size: 0.95rem; font-weight: 800; color: #0f172a; margin-bottom: 10px;
            display: flex; align-items: center; gap: 8px; border-bottom: 1px solid #E2E8F0;
            padding-bottom: 6px;
        }
        .review-section-title .num {
            display: inline-flex; align-items: center; justify-content: center;
            width: 22px; height: 22px; border-radius: 50%; background: var(--fdf-pink, #db2777);
            color: #fff; font-size: 0.75rem; font-weight: 700;
        }
        .review-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 10px 14px;
        }
        .review-item {
            display: flex; flex-direction: column; gap: 2px;
        }
        .review-item.full {
            grid-column: 1 / -1;
        }
        .review-item-label {
            font-size: 0.75rem; text-transform: uppercase; font-weight: 700;
            color: #64748b; letter-spacing: 0.5px;
        }
        .review-item-value {
            font-size: 0.9rem; font-weight: 600; color: #0f172a; word-break: break-word;
        }
        .review-modal-actions {
            display: flex; align-items: center; justify-content: flex-end;
            gap: 10px; padding-top: 14px; border-top: 1px solid #E2E8F0; flex-wrap: wrap;
        }
        .modal-header {
            display: flex; align-items: center; gap: 12px; margin-bottom: 16px;
        }
        .modal-header .icon-wrap {
            width: 40px; height: 40px; border-radius: 10px;
            background: #fce7f3; color: var(--fdf-pink, #db2777);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; flex-shrink: 0;
        }
        .btn-close-modal {
            background: transparent; border: none; font-size: 1.5rem; line-height: 1;
            color: #64748b; cursor: pointer; padding: 4px; border-radius: 8px;
            transition: color 0.15s, background 0.15s; margin-left: auto;
        }
        .btn-close-modal:hover { color: #0f172a; background: #F1F5F9; }
        .btn-modal-cancel {
            padding: 10px 18px; border-radius: 10px; border: 1px solid #cbd5e1;
            background: #F1F5F9; color: #0f172a; font-weight: 700; font-size: 0.88rem; cursor: pointer;
        }
        .btn-modal-confirm {
            padding: 10px 20px; border-radius: 10px; border: none;
            background: var(--fdf-pink, #db2777); color: #FFFFFF; font-weight: 700; font-size: 0.88rem;
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-modal-confirm:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn-secondary-modal {
            padding: 9px 14px; border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            border: 1px solid #cbd5e1; background: #F1F5F9; color: #0f172a;
            cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none;
        }
        .btn-secondary-modal:hover { background: #E2E8F0; color: #0f172a; }
        
        /* Mobile Responsive Adjustments */
        @media (max-width: 991px) {
            .app-header {
                padding: 12px;
                flex-wrap: wrap;
                gap: 10px;
            }
            .header-brand {
                font-size: 1rem;
            }
            .header-actions {
                width: 100%;
                justify-content: space-between;
            }
            .main-content {
                padding: 12px 12px 120px 12px !important;
                width: 100%;
                overflow-x: hidden;
            }
            .hero-top-row {
                flex-direction: column;
                gap: 15px;
            }
            .hero-info-box {
                width: 100%;
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .hero-photos-box {
                width: 100%;
            }
            .logo-container {
                width: 100px;
                height: 100px;
            }
            .subtitle, .contact-list li {
                justify-content: center;
            }
            .hero-bottom-actions {
                flex-direction: column;
                gap: 15px;
                align-items: center;
            }
            .rating-box {
                flex-wrap: wrap;
                justify-content: center;
            }
            .action-btns {
                flex-wrap: wrap;
                justify-content: center;
                width: 100%;
            }
            .action-btns .btn-edit, .action-btns .btn-preview {
                flex: 1;
                justify-content: center;
                text-align: center;
            }
            
            .form-grid-3col, .f-row-2, .f-row-3 {
                grid-template-columns: 1fr;
            }
            
            .profile-tracker {
                flex-direction: column;
                align-items: flex-start;
                padding: 16px;
            }
            .pt-left {
                width: 100%;
                flex-direction: column;
                align-items: flex-start;
            }
            .pt-steps {
                flex-wrap: wrap;
                gap: 15px;
                width: 100%;
            }
            .pt-step {
                width: calc(50% - 15px);
                align-items: flex-start;
                text-align: left;
            }
            .pt-steps::before {
                display: none;
            }
            .pt-label {
                text-align: left;
            }
        }
    </style>
</head>
<body>

    <!-- Header with Mobile Parity Actions -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" 
style="height: 44px; width: 44px; border-radius: 10px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/" class="btn-skip" style="margin-right:6px;"><i class="bi bi-house-door"></i> Home</a>
            <a href="${pageContext.request.contextPath}/salon/salon-dashboard" class="btn-skip" style="margin-right:6px;"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/salon/salon-dashboard" class="btn-skip" style="margin-right:6px;">Skip for now</a>
            <button type="button" class="btn-header-preview" id="btnHeaderPreview" onclick="openSalonPreviewModal()" style="padding:8px 16px; background:#f1f5f9; border:1px solid #cbd5e1; color:#334155; border-radius:8px; font-size:0.85rem; font-weight:700; cursor:pointer; margin-right:6px;"><i class="bi bi-eye"></i> Preview Profile</button>
            <button type="button" class="btn-header-save" id="btnHeaderSave" onclick="handleProfileSave(event)">Save Profile</button>
        </div>
    </header>


    <!-- Sidebar -->
    

    
    <!-- Main Content Area -->
    <div class="main-content">
        <form id="profileForm" action="${pageContext.request.contextPath}/salons/updateProfile${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" onsubmit="return handleProfileSave(event)" novalidate>
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <input type="hidden" name="id" value="${salon.id}">
            
            <!-- Top Header -->
            <div class="top-header">
                <div class="header-title">
                    <h2>Salon Profile</h2>
                    <p>Manage your salon information and business details</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm text-decoration-none me-1"><i class="bi bi-house-door"></i> Home</a>
                    <a href="${pageContext.request.contextPath}/salon/salon-dashboard" class="btn btn-outline-secondary btn-sm text-decoration-none me-1"><i class="bi bi-arrow-left"></i> Dashboard</a>
                    <button type="button" class="btn-preview" onclick="openSalonPreviewModal()" style="padding:6px 14px; background:#f1f5f9; border:1px solid #cbd5e1; color:#334155; border-radius:8px; font-size:0.85rem; font-weight:700; cursor:pointer;"><i class="bi bi-eye"></i> Preview Profile</button>
                    
                    <!-- Notifications Dropdown -->
                    <div class="dropdown">
                        <div class="bell-icon" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;"><i class="bi bi-bell"></i><div class="bell-badge" id="notifBadge">0</div></div>
                        <ul class="dropdown-menu dropdown-menu-end" style="width: 280px; padding: 0;" id="notifList">
                            <li class="p-2 border-bottom fw-bold text-center">Notifications</li>
                            <li><a class="dropdown-item text-center text-pink py-2" href="#">View All Notifications</a></li>
                        </ul>
                    </div>

                    <!-- Messages Dropdown -->
                    <div class="dropdown">
                        <div class="bell-icon" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;"><i class="bi bi-chat-dots"></i><div class="bell-badge" id="chatBadge" style="display:none;">0</div></div>
                        <ul class="dropdown-menu dropdown-menu-end" style="width: 280px; padding: 0;" id="chatList">
                            <li class="p-2 border-bottom fw-bold text-center">Messages</li>
                            <li><a class="dropdown-item text-center text-pink py-2" href="#">View All Messages</a></li>
                        </ul>
                    </div>

                    <!-- Profile Dropdown -->
                    <div class="dropdown">
                        <div class="profile-badge ms-2" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;">
                            <c:choose>
                                <c:when test="${not empty salon.profileImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" alt="Owner">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${salon.name}&background=ec1868&color=fff" alt="Owner">
                                </c:otherwise>
                            </c:choose>
                            <div class="d-flex flex-column lh-1">
                                <span class="fw-bold text-dark" style="font-size:0.8rem">${salon.name}</span>
                                <span class="text-muted" style="font-size:0.65rem">Owner</span>
                            </div>
                        </div>
                        <ul class="dropdown-menu dropdown-menu-end mt-2">
                            <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> My Account</a></li>
                            <li><a class="dropdown-item" href="#"><i class="bi bi-gear"></i> Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/salons/logout"><i class="bi bi-box-arrow-right text-danger"></i> Sign Out</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Hero Section -->
            <div class="hero-section">
                <div class="hero-top-row">
                    <!-- Left Info -->
                    <div class="hero-info-box">
                        <div class="logo-container">
                            <c:choose>
                                <c:when test="${not empty salon.profileImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" class="logo-img" alt="Logo" id="profileImgPreview">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${salon.name}&background=1a1a2e&color=fff" class="logo-img" alt="Logo" id="profileImgPreview">
                                </c:otherwise>
                            </c:choose>
                            <div class="cam-icon" onclick="document.getElementById('profileImageInput').click()"><i class="bi bi-camera"></i></div>
                            <input type="file" name="profileImage" accept="image/*" style="display:none;" id="profileImageInput" onchange="previewImage(this, 'profileImgPreview')">
                        </div>
                        <div class="info-details">
                            <h3>${salon.name} <i class="bi bi-patch-check-fill verified-badge"></i></h3>
                            <div class="subtitle">
                                ${not empty salon.salonCategory ? salon.salonCategory : "Women's Beauty • Wellness • Hair Styling"}
                                <c:if test="${salon.isWomenOnly}"><span class="women-pill">Women Only Salon</span></c:if>
                            </div>
                            <ul class="contact-list">
                                <li><i class="bi bi-telephone"></i> ${not empty salon.phone ? salon.phone : "+91 98765 43210"}</li>
                                <li><i class="bi bi-envelope"></i> ${not empty salon.email ? salon.email : "info@salon.com"}</li>
                                <li><i class="bi bi-globe"></i> ${not empty salon.website ? salon.website : "www.salon.com"}</li>
                                <li><i class="bi bi-geo-alt"></i> <span class="text-muted">${salon.address}, ${salon.city}, ${salon.state} - ${salon.pincode}</span></li>
                            </ul>
                        </div>
                    </div>

                    <!-- Right Photos -->
                    <div class="hero-photos-box">
                        <div class="cover-img-container">
                            <c:choose>
                                <c:when test="${not empty salon.coverImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.coverImageUrl}" class="cover-img" alt="Cover" id="coverImgPreview">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1200&q=80" class="cover-img" alt="Cover Default" id="coverImgPreview">
                                </c:otherwise>
                            </c:choose>
                            <div class="cam-icon" style="bottom: 15px; right: 15px;" onclick="document.getElementById('coverImageInput').click()"><i class="bi bi-camera"></i></div>
                            <input type="file" name="coverImage" accept="image/*" style="display:none;" id="coverImageInput" onchange="previewImage(this, 'coverImgPreview')">
                        </div>
                        <div class="thumb-row" id="interiorImagesPreviewContainer">
                            <c:choose>
                                <c:when test="${empty interiorImagesList}">
                                    <div class="text-muted" style="font-size:0.75rem; padding: 20px;" id="noInteriorText">No interior photos uploaded yet.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="imgUrl" items="${interiorImagesList}">
                                        <img src="${pageContext.request.contextPath}${imgUrl}" class="thumb-img">
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            <div class="btn-add-photo" onclick="document.getElementById('interiorImageInput').click()"><i class="bi bi-plus text-pink fs-5"></i> Add More Photos</div>
                            <input type="file" name="interiorImages" accept="image/*" multiple style="display:none;" id="interiorImageInput" onchange="previewMultipleImages(this, 'interiorImagesPreviewContainer')">
                        </div>
                    </div>
                </div>
                
                <div class="hero-bottom-actions">
                    <div class="rating-box">
                        <i class="bi bi-star-fill star"></i> ${not empty salon.averageRating ? salon.averageRating : '0.0'} (0 Reviews) &nbsp;&nbsp;&nbsp;
                        <span class="open-status">${salon.currentStatus}</span> 
                        
                        <div class="dropdown d-inline-block ms-2">
                            <span class="text-muted dropdown-toggle" data-bs-toggle="dropdown" style="cursor:pointer;">
                                <i class="bi bi-clock"></i> Timings
                            </span>
                            <div class="dropdown-menu p-3 shadow-sm" style="min-width: 220px; font-size:0.9rem;">
                                <h6 class="dropdown-header px-0 text-dark border-bottom pb-2 mb-2">Weekly Timings</h6>
                                <div class="d-flex justify-content-between mb-1"><span>Mon:</span> <span class="fw-medium">${not empty salonHoursDisplay['monday'] ? salonHoursDisplay['monday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Tue:</span> <span class="fw-medium">${not empty salonHoursDisplay['tuesday'] ? salonHoursDisplay['tuesday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Wed:</span> <span class="fw-medium">${not empty salonHoursDisplay['wednesday'] ? salonHoursDisplay['wednesday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Thu:</span> <span class="fw-medium">${not empty salonHoursDisplay['thursday'] ? salonHoursDisplay['thursday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Fri:</span> <span class="fw-medium">${not empty salonHoursDisplay['friday'] ? salonHoursDisplay['friday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Sat:</span> <span class="fw-medium">${not empty salonHoursDisplay['saturday'] ? salonHoursDisplay['saturday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Sun:</span> <span class="fw-medium">${not empty salonHoursDisplay['sunday'] ? salonHoursDisplay['sunday'] : 'Not set'}</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="action-btns">
                        <button type="button" class="btn-edit" id="btnEditProfile" onclick="openEditMode()"><i class="bi bi-pencil"></i> Edit Profile</button>
                        <button type="button" class="btn-preview" onclick="openSalonPreviewModal()" style="padding:8px 18px; background:#f1f5f9; border:1px solid #cbd5e1; color:#334155; border-radius:8px; font-size:0.88rem; font-weight:700; cursor:pointer;"><i class="bi bi-eye"></i> Preview Profile</button>
                    </div>
                </div>
            </div>

            <!-- Profile Completion Tracker -->
            <div class="profile-tracker">
                <div class="pt-left">
                    <div class="pt-circle-wrap" id="ptCircleWrap" style="background: conic-gradient(var(--brand-pink) ${completionPercentage}%, #f0f0f0 0);">
                        <div class="pt-circle-inner" id="ptCircleInner">${completionPercentage}%</div>
                    </div>
                    <div class="pt-text">
                        <h4>Profile Completion</h4>
                        <p>Great! Keep going to make your salon profile even stronger.</p>
                    </div>
                </div>
                
                <div class="pt-steps" id="ptStepsBar" style="--progress: ${completionPercentage}%;">
                    <div class="pt-step ${stepBasicInfo ? 'done' : ''}" id="stepBasicInfo" onclick="openEditMode('tab-business')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Basic<br>Information</div>
                        <div class="pt-status" id="statusBasicInfo">${stepBasicInfo ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepSalonDetails ? 'done' : ''}" id="stepSalonDetails" onclick="openEditMode('tab-details')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Salon<br>Details</div>
                        <div class="pt-status" id="statusSalonDetails">${stepSalonDetails ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepServices ? 'done' : ''}" id="stepServices" onclick="openEditMode('tab-services')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Services<br>Offered</div>
                        <div class="pt-status" id="statusServices">${stepServices ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepPhotos ? 'done' : ''}" id="stepPhotos" onclick="window.scrollTo({top:0, behavior:'smooth'})" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Photos</div>
                        <div class="pt-status" id="statusPhotos">${stepPhotos ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepFacilities ? 'done' : ''}" id="stepFacilities" onclick="openEditMode('tab-facilities')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Facilities &<br>Amenities</div>
                        <div class="pt-status" id="statusFacilities">${stepFacilities ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepDocs ? 'done' : ''}" id="stepDocs" onclick="openEditMode('tab-documents')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Documents</div>
                        <div class="pt-status" id="statusDocs">${docsCount}/${docsTotal} Completed</div>
                    </div>
                    <div class="pt-step ${stepSocial ? 'done' : ''}" id="stepSocial" onclick="openEditMode('tab-social')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Social<br>Media</div>
                        <div class="pt-status" id="statusSocial">${socialCount}/${socialTotal} Completed</div>
                    </div>
                </div>
                
                <a href="javascript:void(0)" onclick="openEditMode()" class="btn-visibility">Increase Visibility <i class="bi bi-arrow-right"></i></a>
            </div>

            <!-- Tabs Navigation -->
            <div class="custom-tabs" id="profileTabs">
                <a href="#" class="custom-tab active" data-target="tab-business">Business Information</a>
                <a href="#" class="custom-tab" data-target="tab-details">Salon Details</a>
                <a href="#" class="custom-tab" data-target="tab-facilities">Facilities &amp; Amenities</a>
                <a href="#" class="custom-tab" data-target="tab-documents">Documents</a>
                <a href="#" class="custom-tab" data-target="tab-social">Social Media</a>
            </div>

            <!-- All Sections Container -->
            <div id="editableSections">
                
                <!-- Tab Content Area -->
                <div class="tab-content-container">
                
                <!-- Tab: Business Info -->
                <div class="tab-pane active" id="tab-business">
                    <div class="form-grid-2col">
                        <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-journal-text"></i>
                        <h4>Basic Information</h4>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="salonName">Salon Name <span class="req">*</span></label>
                            <input type="text" class="f-control" id="salonName" name="name" value="${salon.name}" placeholder="e.g. Aura Beauty Lounge" maxlength="150" required>
                            <div class="error-msg" id="err-name"><i class="bi bi-exclamation-circle-fill"></i> Salon name is required (at least 3 characters).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonType">Business Type <span class="req">*</span></label>
                            <select class="f-control" name="salonType" id="salonType" required>
                                <option value="">-- Select Business Type --</option>
                                <option value="Beauty, Wellness & Hair Salon" ${salon.salonType == 'Beauty, Wellness & Hair Salon' or (empty salon.salonType and salon.salonCategory == 'Beauty, Wellness & Hair Salon') ? 'selected' : ''}>Beauty, Wellness & Hair Salon</option>
                                <option value="Hair Salon" ${salon.salonType == 'Hair Salon' ? 'selected' : ''}>Hair Salon</option>
                                <option value="Beauty Parlour" ${salon.salonType == 'Beauty Parlour' ? 'selected' : ''}>Beauty Parlour</option>
                                <option value="Unisex Salon" ${salon.salonType == 'Unisex Salon' ? 'selected' : ''}>Unisex Salon</option>
                                <option value="Bridal & Makeup Studio" ${salon.salonType == 'Bridal & Makeup Studio' ? 'selected' : ''}>Bridal & Makeup Studio</option>
                                <option value="Spa & Wellness Centre" ${salon.salonType == 'Spa & Wellness Centre' ? 'selected' : ''}>Spa & Wellness Centre</option>
                                <option value="Nail Studio & Bar" ${salon.salonType == 'Nail Studio & Bar' ? 'selected' : ''}>Nail Studio & Bar</option>
                                <option value="Skin Clinic & Aesthetics" ${salon.salonType == 'Skin Clinic & Aesthetics' ? 'selected' : ''}>Skin Clinic & Aesthetics</option>
                                <option value="Ayurvedic & Natural Care" ${salon.salonType == 'Ayurvedic & Natural Care' ? 'selected' : ''}>Ayurvedic & Natural Care</option>
                                <c:if test="${not empty salon.salonType and salon.salonType != 'Beauty, Wellness & Hair Salon' and salon.salonType != 'Hair Salon' and salon.salonType != 'Beauty Parlour' and salon.salonType != 'Unisex Salon' and salon.salonType != 'Bridal & Makeup Studio' and salon.salonType != 'Spa & Wellness Centre' and salon.salonType != 'Nail Studio & Bar' and salon.salonType != 'Skin Clinic & Aesthetics' and salon.salonType != 'Ayurvedic & Natural Care'}">
                                    <option value="${salon.salonType}" selected>${salon.salonType}</option>
                                </c:if>
                            </select>
                            <div class="error-msg" id="err-salonType"><i class="bi bi-exclamation-circle-fill"></i> Please select a business type.</div>
                        </div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonTagline">Tagline / Motto</label>
                        <input type="text" class="f-control" id="salonTagline" name="salonTagline" value="${salon.salonTagline}" placeholder="Enhancing Beauty, Elevating Confidence" maxlength="255">
                        <div class="field-hint"><i class="bi bi-info-circle"></i> Short memorable slogan displayed on your public profile</div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="businessRegistrationNo">Business Registration No.</label>
                            <input type="text" class="f-control" id="businessRegistrationNo" name="businessRegistrationNo" value="${salon.businessRegistrationNo}" placeholder="e.g. KA03AB1234C" maxlength="50">
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="gstNumber">GST Number (Optional)</label>
                            <input type="text" class="f-control" id="gstNumber" name="gstNumber" value="${salon.gstNumber}" placeholder="29ABCDE1234F1Z5" maxlength="15" style="text-transform:uppercase;">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 15-character Goods and Services Tax ID</div>
                            <div class="error-msg" id="err-gstNumber"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid 15-character GST format (e.g. 29ABCDE1234F1Z5).</div>
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="establishedYear">Established Year</label>
                            <input type="text" inputmode="numeric" class="f-control" id="establishedYear" name="establishedYear" value="${salon.establishedYear}" placeholder="e.g. 2018" maxlength="4" autocomplete="off">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 4-digit year (1900 - 2026)</div>
                            <div class="error-msg" id="err-establishedYear"><i class="bi bi-exclamation-circle-fill"></i> Enter a valid 4-digit year between 1900 and 2026.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonCategory">Salon Category <span class="req">*</span></label>
                            <select class="f-control" name="salonCategory" id="salonCategory" required>
                                <option value="">-- Select Category --</option>
                                <option value="Premium Salon" ${salon.salonCategory == 'Premium Salon' ? 'selected' : ''}>Premium Salon</option>
                                <option value="Luxury Salon" ${salon.salonCategory == 'Luxury Salon' ? 'selected' : ''}>Luxury Salon</option>
                                <option value="Standard Salon" ${salon.salonCategory == 'Standard Salon' ? 'selected' : ''}>Standard Salon</option>
                                <option value="Boutique Salon" ${salon.salonCategory == 'Boutique Salon' ? 'selected' : ''}>Boutique Salon</option>
                                <option value="Budget / Economy Salon" ${salon.salonCategory == 'Budget / Economy Salon' ? 'selected' : ''}>Budget / Economy Salon</option>
                                <option value="Family Salon" ${salon.salonCategory == 'Family Salon' ? 'selected' : ''}>Family Salon</option>
                                <option value="Unisex Salon" ${salon.salonCategory == 'Unisex Salon' ? 'selected' : ''}>Unisex Salon</option>
                                <option value="Bridal & Event Studio" ${salon.salonCategory == 'Bridal & Event Studio' ? 'selected' : ''}>Bridal & Event Studio</option>
                                <option value="Organic & Eco-Friendly Salon" ${salon.salonCategory == 'Organic & Eco-Friendly Salon' ? 'selected' : ''}>Organic & Eco-Friendly Salon</option>
                                <option value="Express Salon" ${salon.salonCategory == 'Express Salon' ? 'selected' : ''}>Express Salon</option>
                                <c:if test="${not empty salon.salonCategory and salon.salonCategory != 'Premium Salon' and salon.salonCategory != 'Luxury Salon' and salon.salonCategory != 'Standard Salon' and salon.salonCategory != 'Boutique Salon' and salon.salonCategory != 'Budget / Economy Salon' and salon.salonCategory != 'Family Salon' and salon.salonCategory != 'Unisex Salon' and salon.salonCategory != 'Bridal & Event Studio' and salon.salonCategory != 'Organic & Eco-Friendly Salon' and salon.salonCategory != 'Express Salon'}">
                                    <option value="${salon.salonCategory}" selected>${salon.salonCategory}</option>
                                </c:if>
                            </select>
                            <div class="error-msg" id="err-salonCategory"><i class="bi bi-exclamation-circle-fill"></i> Please select a salon category.</div>
                        </div>
                        <div class="f-group text-end">
                            <label class="f-label">Women Only Salon</label>
                            <div class="toggle-switch justify-content-end pt-1">
                                <label class="switch" for="isWomenOnlySwitch">
                                    <input type="checkbox" id="isWomenOnlySwitch" name="isWomenOnly" value="true" ${salon.isWomenOnly ? 'checked' : ''}>
                                    <span class="slider"></span>
                                </label>
                                <span style="font-size:0.75rem; font-weight:500;">Yes</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="f-group mt-2">
                        <label class="f-label" for="salonBio">Description <span class="req">*</span></label>
                        <textarea class="f-control" id="salonBio" name="bio" rows="4" placeholder="Enter salon description, specialty services, ambiance, hygiene promises..." maxlength="2000" required>${salon.bio}</textarea>
                        <div class="d-flex justify-content-between align-items-center mt-1">
                            <div class="error-msg" id="err-bio"><i class="bi bi-exclamation-circle-fill"></i> Description is required (at least 10 characters).</div>
                            <div class="char-count" id="bioCharCount">0 / 2000</div>
                        </div>
                    </div>
                </div>
                
                <!-- Col 2: Contact Info -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-person-lines-fill"></i>
                        <h4>Contact Information</h4>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonPhone">Phone Number <span class="req">*</span></label>
                        <input type="tel" inputmode="numeric" class="f-control" id="salonPhone" name="phone" value="${salon.phone}" placeholder="10-digit mobile number" maxlength="10" autocomplete="tel" required>
                        <div class="field-hint"><i class="bi bi-info-circle"></i> 10 digits starting with 6, 7, 8, or 9</div>
                        <div class="error-msg" id="err-phone"><i class="bi bi-exclamation-circle-fill"></i> Valid 10-digit phone number starting with 6-9 is required.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="alternateNumber">Alternate Number</label>
                        <input type="tel" inputmode="numeric" class="f-control" id="alternateNumber" name="alternateNumber" value="${salon.alternateNumber}" placeholder="Optional 10-digit mobile number" maxlength="10" autocomplete="tel">
                        <div class="field-hint"><i class="bi bi-info-circle"></i> Optional secondary phone (must differ from primary phone)</div>
                        <div class="error-msg" id="err-alternateNumber"><i class="bi bi-exclamation-circle-fill"></i> Alternate number must be 10 digits and distinct from primary phone.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonEmail">Email Address <span class="req">*</span></label>
                        <input type="email" class="f-control" id="salonEmail" name="email" value="${salon.email}" placeholder="contact@salon.com" maxlength="100" autocomplete="email" required>
                        <div class="error-msg" id="err-email"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid email address.</div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label" for="salonAddress">Full Address <span class="req">*</span></label>
                        <textarea class="f-control" id="salonAddress" name="address" rows="3" placeholder="Door / Building No, Street, Area / Locality..." maxlength="500" required>${salon.address}</textarea>
                        <div class="error-msg" id="err-address"><i class="bi bi-exclamation-circle-fill"></i> Full address is required (at least 5 characters).</div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="stateSelect">State <span class="req">*</span></label>
                            <select class="f-control" name="state" id="stateSelect" required>
                                <option value="">-- Select State --</option>
                            </select>
                            <div class="cascade-info"><i class="bi bi-info-circle"></i> Updates districts</div>
                            <div class="error-msg" id="err-state"><i class="bi bi-exclamation-circle-fill"></i> State is required.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="districtSelect">District / City <span class="req">*</span></label>
                            <select class="f-control" id="districtSelect" required>
                                <option value="">-- Select State First --</option>
                            </select>
                            <div class="cascade-info"><i class="bi bi-check-circle"></i> Filters to chosen state</div>
                            <div class="error-msg" id="err-city"><i class="bi bi-exclamation-circle-fill"></i> District / City is required.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonPincode">Pincode <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="salonPincode" name="pincode" value="${salon.pincode}" placeholder="6-digit Pincode" maxlength="6" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> 6 digits postal code</div>
                            <div class="error-msg" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i> Valid 6-digit pincode is required.</div>
                        </div>
                    </div>

                    <div class="f-group mt-2" id="customCityGroup" style="display:none;">
                        <label class="f-label" for="customCityInput">Custom City / Town Name <span class="req">*</span></label>
                        <input type="text" id="customCityInput" class="f-control" placeholder="Type city or town name" maxlength="60">
                        <div class="error-msg" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i> Please enter your city or town name.</div>
                    </div>

                    <!-- Hidden input submitted as the official city param -->
                    <input type="hidden" name="city" id="inputCity" value="${salon.city}">
                    
                    <div class="f-group mt-2">
                        <label class="f-label" for="salonLandmark">Landmark</label>
                        <input type="text" class="f-control" id="salonLandmark" name="landmark" value="${salon.landmark}" placeholder="Near Metro Station, Opposite Central Mall" maxlength="200">
                    </div>
                </div>

                </div>
                </div> <!-- End Tab Business -->

                <!-- Tab: Salon Details -->
                <div class="tab-pane" id="tab-details">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-gem"></i>
                        <h4>Salon Information</h4>
                    </div>
                    
                    <!-- Weekly Operating Hours Grid -->
                    <div class="section-header mt-4 mb-3">
                        <i class="bi bi-clock"></i>
                        <h4>Weekly Operating Hours</h4>
                    </div>
                    <style>
                        .hours-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; background: #fff; padding: 10px; border: 1px solid #e9ecef; border-radius: 8px; flex-wrap: wrap; gap: 10px; }
                        .hours-day { width: 90px; font-weight: 500; font-size: 0.95rem; }
                        .hours-inputs { display: flex; align-items: center; gap: 10px; flex-grow: 1; flex-wrap: wrap; }
                        .hours-input { padding: 6px; border: 1px solid #d1d5db; border-radius: 4px; max-width: 110px; width: 100%; font-size: 0.85rem; }
                        .hours-closed { display: flex; align-items: center; gap: 5px; font-size: 0.85rem; white-space: nowrap; }
                        @media (max-width: 767px) {
                            .hours-day { width: 100%; }
                        }
                    </style>
                    <div class="hours-grid">
                        <c:forEach var="day" items="monday,tuesday,wednesday,thursday,friday,saturday,sunday">
                            <div class="hours-row">
                                <div class="hours-day" style="text-transform: capitalize;">${day}</div>
                                <div class="hours-inputs">
                                    <input type="time" class="hours-input" id="hours_${day}_open" name="hours_${day}_open" value="${fn:split(salonHours[day], ' - ')[0]}">
                                    <span>to</span>
                                    <input type="time" class="hours-input" id="hours_${day}_close" name="hours_${day}_close" value="${fn:split(salonHours[day], ' - ')[1]}">
                                </div>
                                <div class="hours-closed">
                                    <input type="checkbox" id="hours_${day}_closed" name="hours_${day}_closed" value="true" ${salonHours[day] == 'Closed' ? 'checked' : ''}> Closed
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="field-hint mb-3"><i class="bi bi-info-circle"></i> Set standard daily operating opening and closing timings, or check Closed for rest days</div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="totalChairs">Total Chairs / Stations <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="totalChairs" name="totalChairs" value="${not empty salon.totalChairs ? salon.totalChairs : 12}" placeholder="e.g. 12" maxlength="3" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Active styling or cutting stations (1–500)</div>
                            <div class="error-msg" id="err-totalChairs"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of chairs (1 to 500).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="treatmentRooms">Total Treatment Rooms</label>
                            <input type="text" inputmode="numeric" class="f-control" id="treatmentRooms" name="treatmentRooms" value="${not empty salon.treatmentRooms ? salon.treatmentRooms : 4}" placeholder="e.g. 4" maxlength="3">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Private therapy, facial, or spa rooms (0–100)</div>
                            <div class="error-msg" id="err-treatmentRooms"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of rooms (0 to 100).</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasReceptionArea">Reception Area</label>
                            <select class="f-control" id="hasReceptionArea" name="hasReceptionArea">
                                <option value="true" ${salon.hasReceptionArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasReceptionArea ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Dedicated desk for customer greetings & billing</div>
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label" for="hasWaitingArea">Waiting Area</label>
                            <select class="f-control" id="hasWaitingArea" name="hasWaitingArea">
                                <option value="true" ${salon.hasWaitingArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWaitingArea ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Comfortable seated lounge for waiting guests</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasParking">Parking Facility</label>
                            <select class="f-control" id="hasParking" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Customer parking space or valet support</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="washrooms">Washrooms</label>
                            <input type="text" inputmode="numeric" class="f-control" id="washrooms" name="washrooms" value="${not empty salon.washrooms ? salon.washrooms : 2}" placeholder="e.g. 2" maxlength="2">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Clean restroom facilities for customers (0–50)</div>
                            <div class="error-msg" id="err-washrooms"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid number of washrooms (0 to 50).</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="salonSizeSqFt">Salon Size (sq.ft) <span class="req">*</span></label>
                            <input type="text" inputmode="numeric" class="f-control" id="salonSizeSqFt" name="salonSizeSqFt" value="${not empty salon.salonSizeSqFt ? salon.salonSizeSqFt : 1500}" placeholder="e.g. 1500" maxlength="5" required>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Total carpet / floor area in square feet (50–50,000)</div>
                            <div class="error-msg" id="err-salonSizeSqFt"><i class="bi bi-exclamation-circle-fill"></i> Please enter an area between 50 and 50,000 sq.ft.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="salonLicenseNo">Salon License No.</label>
                            <input type="text" class="f-control" id="salonLicenseNo" name="salonLicenseNo" value="${salon.salonLicenseNo}" placeholder="e.g. BBMP/2020/12345" maxlength="50">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Municipal trade or health license reference number</div>
                            <div class="error-msg" id="err-salonLicenseNo"><i class="bi bi-exclamation-circle-fill"></i> License number cannot exceed 50 characters.</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label" for="hygieneStandard">Hygiene Standard</label>
                            <select class="f-control" id="hygieneStandard" name="hygieneStandard">
                                <option value="Premium" ${salon.hygieneStandard == 'Premium' ? 'selected' : ''}>Premium (Hospital-grade sterilization)</option>
                                <option value="Standard" ${salon.hygieneStandard == 'Standard' ? 'selected' : ''}>Standard (Regular sanitization)</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Sanitation protocol and hygiene level followed</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Languages Spoken</label>
                            <input type="hidden" name="languagesSpoken" id="languagesSpoken" value="${salon.languagesSpoken}">
                            <div class="fdf-multiselect" id="languagesMultiselect" tabindex="0">
                                <div class="fdf-multiselect-trigger">
                                    <div class="fdf-multiselect-chips" id="languagesChips">
                                        <span class="fdf-multiselect-placeholder">Select or type languages spoken...</span>
                                    </div>
                                    <i class="bi bi-chevron-down" style="color:var(--text-gray);font-size:0.85rem;margin-left:8px;"></i>
                                </div>
                                <div class="fdf-multiselect-dropdown">
                                    <div class="fdf-multiselect-search-wrap">
                                        <input type="text" class="fdf-multiselect-search" placeholder="Search language...">
                                    </div>
                                    <div class="fdf-multiselect-list"></div>
                                    <div class="fdf-multiselect-custom-wrap">
                                        <input type="text" class="fdf-multiselect-custom-input" placeholder="Other language...">
                                        <button type="button" class="fdf-multiselect-custom-btn">+ Add</button>
                                    </div>
                                </div>
                            </div>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Select or type languages spoken by styling &amp; front-desk staff</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Details -->

                <div class="tab-pane" id="tab-facilities">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-star"></i>
                        <h4>Facilities & Amenities</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label" for="hasAc">Air Conditioning (AC)</label>
                            <select class="f-control" id="hasAc" name="hasAc">
                                <option value="true" ${salon.hasAc ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasAc ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Fully air-conditioned styling space and treatment rooms</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasWifi">Free Wi-Fi</label>
                            <select class="f-control" id="hasWifi" name="hasWifi">
                                <option value="true" ${salon.hasWifi ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWifi ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> High-speed internet access available for customers</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="hasParkingFacility">Customer Parking</label>
                            <select class="f-control" id="hasParkingFacility" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Dedicated 2-wheeler or 4-wheeler parking on premises</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="hasPowerBackup">Power Backup</label>
                            <select class="f-control" id="hasPowerBackup" name="hasPowerBackup">
                                <option value="true" ${salon.hasPowerBackup ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasPowerBackup ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Inverter or generator backup to avoid service interruptions</div>
                        </div>
                    </div>

                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="isWheelchairAccessible">Wheelchair Accessible</label>
                            <select class="f-control" id="isWheelchairAccessible" name="isWheelchairAccessible">
                                <option value="true" ${salon.isWheelchairAccessible ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.isWheelchairAccessible ? 'selected' : ''}>No</option>
                            </select>
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Ramp or ground floor access for differently abled guests</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Facilities -->
                
                <!-- Tab: Social Media -->
                <div class="tab-pane" id="tab-social">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-share"></i>
                        <h4>Social Media Links</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label" for="socialInstagram"><i class="bi bi-instagram text-pink"></i> Instagram Username or URL</label>
                            <input type="text" class="f-control" id="socialInstagram" name="socialInstagram" placeholder="@beautysalon or instagram.com/salon" maxlength="100">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> e.g. @aurasalon or https://instagram.com/aurasalon</div>
                            <div class="error-msg" id="err-socialInstagram"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid Instagram handle or URL.</div>
                        </div>
                        <div class="f-group">
                            <label class="f-label" for="socialFacebook"><i class="bi bi-facebook text-primary"></i> Facebook Page or URL</label>
                            <input type="text" class="f-control" id="socialFacebook" name="socialFacebook" placeholder="facebook.com/beautysalon" maxlength="150">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> e.g. facebook.com/aurasalon</div>
                            <div class="error-msg" id="err-socialFacebook"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid Facebook URL or handle.</div>
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label" for="socialWebsite"><i class="bi bi-globe"></i> Website Link</label>
                            <input type="url" class="f-control" id="socialWebsite" name="socialWebsite" placeholder="https://www.mysalon.com" maxlength="200">
                            <div class="field-hint"><i class="bi bi-info-circle"></i> Official salon website (https://...)</div>
                            <div class="error-msg" id="err-socialWebsite"><i class="bi bi-exclamation-circle-fill"></i> Please enter a valid website URL starting with http:// or https://.</div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Social Media -->

                <!-- Tab: Documents -->
                <div class="tab-pane" id="tab-documents">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-file-earmark-pdf"></i>
                        <h4>Verification Documents (Optional)</h4>
                    </div>
                    <div class="field-hint mb-3"><i class="bi bi-info-circle"></i> JPG, PNG or PDF up to 5 MB. Existing uploads are kept if you do not replace them.</div>

                    <div class="f-row-2">
                        <!-- Doc 1: Business Registration -->
                        <div class="f-group">
                            <label class="f-label">Business Registration Certificate</label>
                            <input type="file" name="businessRegistration" id="fileBus" accept="image/jpeg,image/png,application/pdf" class="f-control doc-file-input">
                            <c:set var="docBus" value="${salon.businessRegistrationUrl}" />
                            <div class="doc-status-wrap mt-2">
                                <c:choose>
                                    <c:when test="${not empty docBus}">
                                        <div class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                        <div class="doc-preview-box">
                                            <a href="${pageContext.request.contextPath}${docBus}" target="_blank" class="doc-link">
                                                <i class="bi bi-box-arrow-up-right"></i> View Document
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Doc 2: Salon License -->
                        <div class="f-group">
                            <label class="f-label">Salon Trade License</label>
                            <input type="file" name="salonLicense" id="fileLic" accept="image/jpeg,image/png,application/pdf" class="f-control doc-file-input">
                            <c:set var="docLic" value="${salon.salonLicenseUrl}" />
                            <div class="doc-status-wrap mt-2">
                                <c:choose>
                                    <c:when test="${not empty docLic}">
                                        <div class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                        <div class="doc-preview-box">
                                            <a href="${pageContext.request.contextPath}${docLic}" target="_blank" class="doc-link">
                                                <i class="bi bi-box-arrow-up-right"></i> View Document
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Doc 3: GST Certificate -->
                        <div class="f-group">
                            <label class="f-label">GST Certificate (Optional)</label>
                            <input type="file" name="gstCertificate" id="fileGst" accept="image/jpeg,image/png,application/pdf" class="f-control doc-file-input">
                            <c:set var="docGst" value="${salon.gstCertificateUrl}" />
                            <div class="doc-status-wrap mt-2">
                                <c:choose>
                                    <c:when test="${not empty docGst}">
                                        <div class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                        <div class="doc-preview-box">
                                            <a href="${pageContext.request.contextPath}${docGst}" target="_blank" class="doc-link">
                                                <i class="bi bi-box-arrow-up-right"></i> View Document
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Doc 4: Hygiene Certificate -->
                        <div class="f-group">
                            <label class="f-label">Hygiene &amp; Safety Certificate</label>
                            <input type="file" name="hygieneCertificate" id="fileHyg" accept="image/jpeg,image/png,application/pdf" class="f-control doc-file-input">
                            <c:set var="docHyg" value="${salon.hygieneCertificateUrl}" />
                            <div class="doc-status-wrap mt-2">
                                <c:choose>
                                    <c:when test="${not empty docHyg}">
                                        <div class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                        <div class="doc-preview-box">
                                            <a href="${pageContext.request.contextPath}${docHyg}" target="_blank" class="doc-link">
                                                <i class="bi bi-box-arrow-up-right"></i> View Document
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Doc 5: Fire Safety NOC -->
                        <div class="f-group">
                            <label class="f-label">Fire Safety Certificate / NOC</label>
                            <input type="file" name="fireSafety" id="fileFire" accept="image/jpeg,image/png,application/pdf" class="f-control doc-file-input">
                            <c:set var="docFire" value="${salon.fireSafetyUrl}" />
                            <div class="doc-status-wrap mt-2">
                                <c:choose>
                                    <c:when test="${not empty docFire}">
                                        <div class="doc-badge uploaded"><i class="bi bi-check-circle-fill"></i> Uploaded</div>
                                        <div class="doc-preview-box">
                                            <a href="${pageContext.request.contextPath}${docFire}" target="_blank" class="doc-link">
                                                <i class="bi bi-box-arrow-up-right"></i> View Document
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Documents -->
                </div> <!-- End Tab Content Container -->

                <!-- Fixed Bottom Action Bar (Single Set of Action Buttons) -->
                <div class="bottom-action-bar">
                    <button type="button" class="btn-preview-bottom" id="btnBottomPreview" onclick="openSalonPreviewModal()" style="padding:10px 20px; border-radius:10px; font-weight:700; background:#f1f5f9; border:1px solid #cbd5e1; color:#334155; cursor:pointer; display:inline-flex; align-items:center; gap:8px;">
                        <i class="bi bi-eye"></i> Preview Profile
                    </button>
                    <button type="submit" class="btn-save-bottom" id="btnBottomSave" onclick="handleProfileSave(event)" style="padding:10px 24px; border-radius:10px; font-weight:700; background:var(--fdf-pink, #db2777); color:white; border:none; cursor:pointer; display:inline-flex; align-items:center; gap:8px;">
                        <i class="bi bi-check2-circle"></i> Save Profile
                    </button>
                </div>
            </div> <!-- End editableSections wrapper -->
            
        </form>
    </div>


    <!-- Toast notification container -->
    <div id="validationToast" class="validation-alert-toast">
        <i class="bi bi-exclamation-triangle-fill fs-5"></i>
        <span id="validationToastMsg">Please fill all required fields correctly before saving.</span>
    </div>

    <!-- Bootstrap JS for dropdowns -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function openEditMode(tabId) {
            const targetId = tabId || 'tab-business';
            const targetEl = document.getElementById(targetId);
            if (targetEl) {
                targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }

        function previewImage(input, imgId) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(imgId).src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        const interiorImagesDataTransfer = new DataTransfer();

        function previewMultipleImages(input, containerId) {
            var container = document.getElementById(containerId);
            if (input.files && input.files.length > 0) {
                
                // Accumulate newly selected files
                for (let i = 0; i < input.files.length; i++) {
                    if (interiorImagesDataTransfer.items.length < 10) {
                        interiorImagesDataTransfer.items.add(input.files[i]);
                    } else {
                        alert("You can only upload a maximum of 10 photos. Any extras were ignored.");
                        break;
                    }
                }
                
                // Overwrite the input's files with our accumulated list so the form submits all of them
                input.files = interiorImagesDataTransfer.files;

                var noText = document.getElementById('noInteriorText');
                if (noText) noText.style.display = 'none';
                
                // Remove existing image previews
                var existingImages = container.querySelectorAll('.thumb-img');
                existingImages.forEach(img => img.remove());

                // Read and preview each accumulated file
                for (var i = 0; i < input.files.length; i++) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        var img = document.createElement("img");
                        img.src = e.target.result;
                        img.className = "thumb-img";
                        
                        // Insert the image before the "Add More Photos" button
                        var addBtn = container.querySelector('.btn-add-photo');
                        container.insertBefore(img, addBtn);
                    }
                    reader.readAsDataURL(input.files[i]);
                }
            }
        }

        // Tab Smooth Scroll & ScrollSpy Logic
        document.addEventListener("DOMContentLoaded", function() {
            const tabs = document.querySelectorAll("#profileTabs .custom-tab[data-target]");
            const panes = document.querySelectorAll(".tab-pane");

            tabs.forEach(tab => {
                tab.addEventListener("click", function(e) {
                    e.preventDefault();
                    
                    tabs.forEach(t => t.classList.remove("active"));
                    this.classList.add("active");

                    const targetId = this.getAttribute("data-target");
                    const targetEl = document.getElementById(targetId);
                    if (targetEl) {
                        targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                });
            });

            // ScrollSpy: highlight active tab pill as user scrolls
            window.addEventListener("scroll", function() {
                let current = "";
                panes.forEach(pane => {
                    const paneTop = pane.offsetTop - 140;
                    if (window.scrollY >= paneTop) {
                        current = pane.getAttribute("id");
                    }
                });
                if (current) {
                    tabs.forEach(tab => {
                        tab.classList.remove("active");
                        if (tab.getAttribute("data-target") === current) {
                            tab.classList.add("active");
                        }
                    });
                }
            }, { passive: true });

        });
    </script>

    <!-- Real-time WebSocket Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var salonId = ${salon.id};
            var contextPath = '${pageContext.request.contextPath}';
            
            var socket = new SockJS(contextPath + '/ws-chat');
            var stompClient = Stomp.over(socket);
            stompClient.debug = null; // disable debug logs
            
            stompClient.connect({}, function (frame) {
                // Subscribe to notifications
                stompClient.subscribe('/topic/salon/notifications/' + salonId, function (message) {
                    var notif = JSON.parse(message.body);
                    addNotification(notif);
                });
                
                // Subscribe to chat
                stompClient.subscribe('/topic/salon/chat/' + salonId, function (message) {
                    var chat = JSON.parse(message.body);
                    addChatMessage(chat);
                });
            });
            
            function addNotification(notif) {
                var badge = document.getElementById('notifBadge');
                badge.innerText = parseInt(badge.innerText || 0) + 1;
                badge.style.display = 'flex';
                
                var list = document.getElementById('notifList');
                var li = document.createElement('li');
                li.innerHTML = '<div class="notif-item"><div class="n-title">' + notif.title + '</div><div class="n-desc">' + notif.message + '</div></div>';
                list.insertBefore(li, list.children[1]);
            }
            
            function addChatMessage(chat) {
                var badge = document.getElementById('chatBadge');
                badge.innerText = parseInt(badge.innerText || 0) + 1;
                badge.style.display = 'flex';
                
                var list = document.getElementById('chatList');
                var li = document.createElement('li');
                var senderName = chat.senderRole === 'USER' ? (chat.user ? chat.user.name : 'User') : chat.senderRole;
                li.innerHTML = '<div class="notif-item"><div class="n-title">' + senderName + '</div><div class="n-desc">' + chat.message + '</div></div>';
                list.insertBefore(li, list.children[1]);
            }
            
            // Load initial via AJAX
            fetch(contextPath + '/api/salon/notifications')
                .then(r => r.json())
                .then(data => {
                    var badge = document.getElementById('notifBadge');
                    var unread = data.filter(n => !n.read).length;
                    if(unread > 0) {
                        badge.innerText = unread;
                        badge.style.display = 'flex';
                    } else {
                        badge.style.display = 'none';
                    }
                    
                    var list = document.getElementById('notifList');
                    data.slice(0, 5).forEach(n => {
                        var li = document.createElement('li');
                        li.innerHTML = '<div class="notif-item"><div class="n-title">' + n.title + '</div><div class="n-desc">' + n.message + '</div></div>';
                        list.insertBefore(li, list.children[1]);
                    });
                });
                
            fetch(contextPath + '/api/salon/chat')
                .then(r => r.json())
                .then(data => {
                    var badge = document.getElementById('chatBadge');
                    var unread = data.filter(c => !c.read).length;
                    if (unread > 0) {
                        badge.innerText = unread;
                        badge.style.display = 'flex';
                    } else {
                        badge.style.display = 'none';
                    }
                    
                    var list = document.getElementById('chatList');
                    data.slice(0, 5).reverse().forEach(chat => {
                        var li = document.createElement('li');
                        var senderName = chat.senderRole === 'USER' ? (chat.user ? chat.user.name : 'User') : chat.senderRole;
                        li.innerHTML = '<div class="notif-item"><div class="n-title">' + senderName + '</div><div class="n-desc">' + chat.message + '</div></div>';
                        list.insertBefore(li, list.children[1]);
                    });
                });
                
            // Click to mark notifs read
            document.querySelector('#notifBadge').parentElement.addEventListener('click', function() {
                var badge = document.getElementById('notifBadge');
                if (badge.innerText !== '0' && badge.style.display !== 'none') {
                    fetch(contextPath + '/api/salon/notifications/mark-read', {method: 'POST'})
                        .then(() => {
                            badge.innerText = '0';
                            badge.style.display = 'none';
                        });
                }
            });
        });
    </script>

    <!-- Enhanced Location Selectors & Strict Live Validation -->
    <script>
        const savedState = "${salon.state}";
        const savedCity = "${salon.city}";
        // Initial Server-Rendered State for Accurate Completion Sync
        const hasExistingServices = ${stepServices ? 'true' : 'false'};
        const hasExistingProfilePhoto = ${(not empty salon.profileImageUrl and not fn:contains(salon.profileImageUrl, 'ui-avatars')) ? 'true' : 'false'};
        const hasExistingCover = ${(not empty salon.coverImageUrl or (not empty salon.interiorImagesJson and salon.interiorImagesJson != '[]')) ? 'true' : 'false'};
        const hasExistingFacilities = ${(salon.hasAc or salon.hasWifi or salon.hasParking or salon.hasPowerBackup or salon.isWheelchairAccessible) ? 'true' : 'false'};
        const initialDocsCount = ${docsCount};
        const initialSocialCount = ${socialCount};


        const locationData = {
            "India": {
                "Andhra Pradesh": ["Ananthapuramu", "Chittoor", "East Godavari", "Eluru", "Guntur", "Kakinada", "Krishna", "Kurnool", "NTR", "Palnadu", "Prakasam", "Srikakulam", "Sri Potti Sriramulu Nellore", "Tirupati", "Visakhapatnam", "Vizianagaram", "West Godavari", "YSR Kadapa", "Other"],
                "Arunachal Pradesh": ["Itanagar", "Tawang", "West Kameng", "East Kameng", "Papum Pare", "Kurung Kumey", "Kra Daadi", "Lower Subansiri", "Upper Subansiri", "West Siang", "East Siang", "Siang", "Upper Siang", "Lower Siang", "Lower Dibang Valley", "Dibang Valley", "Anjaw", "Lohit", "Namsai", "Changlang", "Tirap", "Longding", "Other"],
                "Assam": ["Guwahati (Kamrup Metro)", "Kamrup", "Dibrugarh", "Silchar (Cachar)", "Jorhat", "Nagaon", "Tinsukia", "Tezpur (Sonitpur)", "Barpeta", "Dhubri", "Goalpara", "Golaghat", "Hailakandi", "Karimganj", "Kokrajhar", "Lakhimpur", "Morigaon", "Nalbari", "Sivasagar", "Bongaigaon", "Other"],
                "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif (Nalanda)", "Arrah (Bhojpur)", "Begusarai", "Katihar", "Munger", "Chhapra (Saran)", "Danapur", "Saharsa", "Sasaram (Rohtas)", "Hajipur (Vaishali)", "Dehri", "Siwan", "Motihari (East Champaran)", "Bettiah (West Champaran)", "Other"],
                "Chhattisgarh": ["Raipur", "Bhilai (Durg)", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur (Bastar)", "Ambikapur (Surguja)", "Raigarh", "Dhamtari", "Mahasamund", "Kanker", "Kawardha (Kabirdham)", "Janjgir-Champa", "Other"],
                "Goa": ["North Goa", "South Goa", "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Other"],
                "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar", "Junagadh", "Anand", "Navsari", "Morbi", "Nadiad (Kheda)", "Surendranagar", "Bharuch", "Mehsana", "Bhuj (Kutch)", "Porbandar", "Palanpur (Banaskantha)", "Valsad", "Vapi", "Other"],
                "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", "Karnal", "Sonipat", "Panchkula", "Bhiwani", "Sirsa", "Bahadurgarh (Jhajjar)", "Jind", "Thanesar (Kurukshetra)", "Kaithal", "Rewari", "Palwal", "Other"],
                "Himachal Pradesh": ["Shimla", "Dharamshala (Kangra)", "Mandi", "Solan", "Kullu", "Hamirpur", "Una", "Bilaspur", "Chamba", "Sirmaur (Nahan)", "Kinnaur", "Lahaul and Spiti", "Other"],
                "Jharkhand": ["Ranchi", "Jamshedpur (East Singhbhum)", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Giridih", "Ramgarh", "Medininagar (Palamu)", "Dumka", "Chaibasa (West Singhbhum)", "Other"],
                "Karnataka": ["Bengaluru Urban", "Bengaluru Rural", "Mysuru", "Hubballi-Dharwad", "Mangaluru (Dakshina Kannada)", "Belagavi", "Kalaburagi (Gulbarga)", "Davanagere", "Ballari", "Vijayapura (Bijapur)", "Shivamogga (Shimoga)", "Tumakuru", "Bidar", "Raichur", "Udupi", "Hassan", "Mandya", "Chikkamagaluru", "Bagalkote", "Gadag", "Kolar", "Chitradurga", "Other"],
                "Kerala": ["Thiruvananthapuram", "Ernakulam (Kochi)", "Kozhikode", "Thrissur", "Kollam", "Palakkad", "Malappuram", "Kannur", "Kottayam", "Alappuzha", "Kasaragod", "Pathanamthitta", "Idukki", "Wayanad", "Other"],
                "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna", "Ratlam", "Rewa", "Katni", "Singrauli", "Burhanpur", "Khandwa", "Bhind", "Chhindwara", "Guna", "Shivpuri", "Vidisha", "Damoh", "Other"],
                "Maharashtra": ["Mumbai City", "Mumbai Suburban", "Pune", "Nagpur", "Thane", "Nashik", "Chhatrapati Sambhajinagar (Aurangabad)", "Solapur", "Kolhapur", "Amravati", "Navi Mumbai", "Nanded", "Jalgaon", "Akola", "Latur", "Dhule", "Ahmednagar", "Chandrapur", "Parbhani", "Jalna", "Raigad", "Satara", "Sangli", "Wardha", "Other"],
                "Manipur": ["Imphal West", "Imphal East", "Thoubal", "Bishnupur", "Churachandpur", "Ukhrul", "Senapati", "Tamenglong", "Chandel", "Kangpokpi", "Other"],
                "Meghalaya": ["Shillong (East Khasi Hills)", "West Khasi Hills", "South West Khasi Hills", "Ri-Bhoi", "Tura (West Garo Hills)", "East Garo Hills", "South Garo Hills", "North Garo Hills", "Jowai (West Jaintia Hills)", "East Jaintia Hills", "Other"],
                "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Kolasib", "Serchhip", "Lawngtlai", "Mamit", "Saiha", "Other"],
                "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Zunheboto", "Mon", "Phek", "Chumoukedima", "Niuland", "Other"],
                "Odisha": ["Bhubaneswar (Khurda)", "Cuttack", "Rourkela (Sundargarh)", "Berhampur (Ganjam)", "Sambalpur", "Puri", "Balasore", "Bhadrak", "Baripada (Mayurbhanj)", "Jharsuguda", "Jeypore (Koraput)", "Angul", "Bargarh", "Balangir", "Kendujhar", "Other"],
                "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "SAS Nagar (Mohali)", "Hoshiarpur", "Pathankot", "Moga", "Abohar (Fazilka)", "Batala (Gurdaspur)", "Khanna", "Firozpur", "Kapurthala", "Sangrur", "Barnala", "Faridkot", "Rupnagar", "Other"],
                "Rajasthan": ["Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Bharatpur", "Sikar", "Pali", "Sri Ganganagar", "Hanumangarh", "Tonk", "Kishangarh", "Beawar", "Jhunjhunu", "Chittorgarh", "Barmer", "Nagaur", "Other"],
                "Sikkim": ["Gangtok (East Sikkim)", "Namchi (South Sikkim)", "Gyalshing (West Sikkim)", "Mangan (North Sikkim)", "Pakyong", "Soreng", "Other"],
                "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Ranipet", "Vellore", "Erode", "Thoothukudi", "Dindigul", "Thanjavur", "Hosur (Krishnagiri)", "Nagercoil (Kanyakumari)", "Kanchipuram", "Kumarapalayam", "Karaikkudi", "Neyveli", "Cuddalore", "Other"],
                "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam (Peddapalli)", "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet", "Miryalaguda", "Siddipet", "Mancherial", "Rangareddy", "Medchal-Malkajgiri", "Sangareddy", "Other"],
                "Tripura": ["Agartala (West Tripura)", "Dharmanagar (North Tripura)", "Udaipur (Gomati)", "Kailashahar (Unakoti)", "Belonia (South Tripura)", "Khowai", "Ambassa (Dhalai)", "Sepahijala", "Other"],
                "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj (Allahabad)", "Gautam Buddha Nagar (Noida / Greater Noida)", "Ghaziabad", "Meerut", "Bareilly", "Aligarh", "Moradabad", "Saharanpur", "Gorakhpur", "Firozabad", "Jhansi", "Muzaffarnagar", "Mathura", "Ayodhya", "Budaun", "Rampur", "Shahjahanpur", "Farrukhabad", "Other"],
                "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani (Nainital)", "Rudraprayag", "Kashipur (Udham Singh Nagar)", "Rishikesh", "Pithoragarh", "Almora", "Tehri Garhwal", "Pauri Garhwal", "Chamoli", "Uttarkashi", "Other"],
                "West Bengal": ["Kolkata", "Howrah", "North 24 Parganas", "South 24 Parganas", "Hooghly", "Durgapur (Paschim Bardhaman)", "Asansol", "Siliguri (Darjeeling)", "Bardhaman", "Malda", "Baharampur (Murshidabad)", "Habra", "Kharagpur (Paschim Medinipur)", "Shantipur (Nadia)", "Dankuni", "Jalpaiguri", "Cooch Behar", "Purulia", "Bankura", "Other"],
                "Andaman and Nicobar Islands": ["Port Blair (South Andaman)", "North and Middle Andaman", "Nicobar", "Other"],
                "Chandigarh": ["Chandigarh", "Other"],
                "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa", "Other"],
                "Delhi": ["Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North East Delhi", "North West Delhi", "Shahdara", "South Delhi", "South East Delhi", "South West Delhi", "West Delhi", "Other"],
                "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua", "Udhampur", "Budgam", "Pulwama", "Kupwara", "Poonch", "Rajouri", "Other"],
                "Ladakh": ["Leh", "Kargil", "Other"],
                "Lakshadweep": ["Kavaratti", "Agatti", "Andrott", "Minicoy", "Other"],
                "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam", "Other"]
            }
        };

        function setStatus(id, errId, isInvalid, customMsg) {
            const input = document.getElementById(id);
            const errEl = document.getElementById(errId);
            if (input) {
                if (isInvalid) {
                    input.classList.add('is-invalid');
                    input.classList.remove('is-valid');
                } else {
                    input.classList.remove('is-invalid');
                    if (input.value && input.value.trim().length > 0) {
                        input.classList.add('is-valid');
                    } else {
                        input.classList.remove('is-valid');
                    }
                }
            }
            if (errEl) {
                if (customMsg) errEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + customMsg;
                if (isInvalid) errEl.classList.add('show');
                else errEl.classList.remove('show');
            }
            return !isInvalid;
        }

        function val(id) {
            const el = document.getElementById(id);
            return el ? el.value.trim() : '';
        }

        // Field-specific validation functions
        function validateSalonName(strict) {
            const v = val('salonName');
            if (!v) return setStatus('salonName', 'err-name', strict, 'Salon name is required.');
            if (v.length < 3) return setStatus('salonName', 'err-name', true, 'Salon name must be at least 3 characters.');
            if (v.length > 150) return setStatus('salonName', 'err-name', true, 'Salon name cannot exceed 150 characters.');
            return setStatus('salonName', 'err-name', false);
        }

        function validateSalonType(strict) {
            const v = val('salonType');
            if (!v) return setStatus('salonType', 'err-salonType', strict, 'Please select a business type.');
            return setStatus('salonType', 'err-salonType', false);
        }

        function validateSalonCategory(strict) {
            const v = val('salonCategory');
            if (!v) return setStatus('salonCategory', 'err-salonCategory', strict, 'Please select a salon category.');
            return setStatus('salonCategory', 'err-salonCategory', false);
        }

        function validateEstablishedYear(strict) {
            const v = val('establishedYear');
            if (!v) {
                return setStatus('establishedYear', 'err-establishedYear', false);
            }
            if (!/^\d{4}$/.test(v)) {
                return setStatus('establishedYear', 'err-establishedYear', true, 'Established year must be exactly 4 digits.');
            }
            const y = parseInt(v, 10);
            const currentYear = new Date().getFullYear();
            if (y < 1900 || y > currentYear) {
                return setStatus('establishedYear', 'err-establishedYear', true, 'Year must be between 1900 and ' + currentYear + '.');
            }
            return setStatus('establishedYear', 'err-establishedYear', false);
        }

        function validateGstNumber(strict) {
            const v = val('gstNumber');
            if (!v) return setStatus('gstNumber', 'err-gstNumber', false);
            const gstRegex = /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/;
            if (!gstRegex.test(v)) {
                return setStatus('gstNumber', 'err-gstNumber', true, 'Please enter a valid 15-character GSTIN (e.g. 29ABCDE1234F1Z5).');
            }
            return setStatus('gstNumber', 'err-gstNumber', false);
        }

        function validateSalonBio(strict) {
            const v = val('salonBio');
            if (!v) return setStatus('salonBio', 'err-bio', strict, 'Salon description is required.');
            if (v.length < 10) return setStatus('salonBio', 'err-bio', true, 'Description must be at least 10 characters.');
            if (v.length > 2000) return setStatus('salonBio', 'err-bio', true, 'Description cannot exceed 2000 characters.');
            return setStatus('salonBio', 'err-bio', false);
        }

        function validateSalonPhone(strict) {
            const v = val('salonPhone');
            if (!v) return setStatus('salonPhone', 'err-phone', strict, 'Phone number is required.');
            if (!/^[6-9]\d{9}$/.test(v)) {
                return setStatus('salonPhone', 'err-phone', true, 'Phone number must be exactly 10 digits starting with 6, 7, 8, or 9.');
            }
            return setStatus('salonPhone', 'err-phone', false);
        }

        function validateAlternateNumber(strict) {
            const v = val('alternateNumber');
            if (!v) return setStatus('alternateNumber', 'err-alternateNumber', false);
            if (!/^[6-9]\d{9}$/.test(v)) {
                return setStatus('alternateNumber', 'err-alternateNumber', true, 'Alternate number must be exactly 10 digits starting with 6-9.');
            }
            const primary = val('salonPhone');
            if (primary && v === primary) {
                return setStatus('alternateNumber', 'err-alternateNumber', true, 'Alternate number cannot be identical to primary phone.');
            }
            return setStatus('alternateNumber', 'err-alternateNumber', false);
        }

        function validateSalonEmail(strict) {
            const v = val('salonEmail');
            if (!v) return setStatus('salonEmail', 'err-email', strict, 'Email address is required.');
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(v)) {
                return setStatus('salonEmail', 'err-email', true, 'Please enter a valid email address.');
            }
            return setStatus('salonEmail', 'err-email', false);
        }

        function validateSalonAddress(strict) {
            const v = val('salonAddress');
            if (!v) return setStatus('salonAddress', 'err-address', strict, 'Full address is required.');
            if (v.length < 5) return setStatus('salonAddress', 'err-address', true, 'Address must be at least 5 characters.');
            return setStatus('salonAddress', 'err-address', false);
        }

        function validateSalonState(strict) {
            const v = val('stateSelect');
            if (!v) return setStatus('stateSelect', 'err-state', strict, 'State is required.');
            return setStatus('stateSelect', 'err-state', false);
        }

        function validateSalonCity(strict) {
            const dist = val('districtSelect');
            if (!dist) return setStatus('districtSelect', 'err-city', strict, 'District / City is required.');
            if (dist === 'Other') {
                const custom = val('customCityInput');
                if (!custom || custom.length < 2) {
                    setStatus('customCityInput', 'err-customCity', true, 'Please enter your city/town name (at least 2 characters).');
                    return false;
                }
                setStatus('customCityInput', 'err-customCity', false);
            }
            return setStatus('districtSelect', 'err-city', false);
        }


        // Validation functions for Tab: Salon Details
        function validateTotalChairs(strict) {
            const v = val('totalChairs');
            if (!v) return setStatus('totalChairs', 'err-totalChairs', strict, 'Total chairs is required.');
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 1 || n > 500) {
                return setStatus('totalChairs', 'err-totalChairs', true, 'Total chairs must be between 1 and 500.');
            }
            return setStatus('totalChairs', 'err-totalChairs', false);
        }

        function validateTreatmentRooms(strict) {
            const v = val('treatmentRooms');
            if (!v) return setStatus('treatmentRooms', 'err-treatmentRooms', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 0 || n > 100) {
                return setStatus('treatmentRooms', 'err-treatmentRooms', true, 'Treatment rooms must be between 0 and 100.');
            }
            return setStatus('treatmentRooms', 'err-treatmentRooms', false);
        }

        function validateWashrooms(strict) {
            const v = val('washrooms');
            if (!v) return setStatus('washrooms', 'err-washrooms', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 0 || n > 50) {
                return setStatus('washrooms', 'err-washrooms', true, 'Washrooms must be between 0 and 50.');
            }
            return setStatus('washrooms', 'err-washrooms', false);
        }

        function validateSalonSize(strict) {
            const v = val('salonSizeSqFt');
            if (!v) return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', strict, 'Salon size is required.');
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 50 || n > 50000) {
                return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', true, 'Salon size must be between 50 and 50,000 sq.ft.');
            }
            return setStatus('salonSizeSqFt', 'err-salonSizeSqFt', false);
        }

        function validateSalonLicenseNo(strict) {
            const v = val('salonLicenseNo');
            if (!v) return setStatus('salonLicenseNo', 'err-salonLicenseNo', false);
            if (v.length > 50) return setStatus('salonLicenseNo', 'err-salonLicenseNo', true, 'License number cannot exceed 50 characters.');
            return setStatus('salonLicenseNo', 'err-salonLicenseNo', false);
        }

        function validateLanguagesSpoken(strict) {
            const v = val('languagesSpoken');
            if (!v) return setStatus('languagesSpoken', 'err-languagesSpoken', false);
            if (v.length > 150) return setStatus('languagesSpoken', 'err-languagesSpoken', true, 'Languages list cannot exceed 150 characters.');
            return setStatus('languagesSpoken', 'err-languagesSpoken', false);
        }

        function validateServiceName(strict) {
            const v = val('serviceName');
            if (!v) return setStatus('serviceName', 'err-serviceName', false);
            if (v.length < 2) return setStatus('serviceName', 'err-serviceName', true, 'Service name must be at least 2 characters.');
            return setStatus('serviceName', 'err-serviceName', false);
        }

        function validateServicePrice(strict) {
            const v = val('servicePrice');
            if (!v) return setStatus('servicePrice', 'err-servicePrice', false);
            const n = parseFloat(v);
            if (isNaN(n) || n < 0) return setStatus('servicePrice', 'err-servicePrice', true, 'Enter a valid price (₹ 0 or more).');
            return setStatus('servicePrice', 'err-servicePrice', false);
        }

        function validateServiceDuration(strict) {
            const v = val('serviceDuration');
            if (!v) return setStatus('serviceDuration', 'err-serviceDuration', false);
            const n = parseInt(v, 10);
            if (isNaN(n) || n < 5 || n > 480) return setStatus('serviceDuration', 'err-serviceDuration', true, 'Duration must be between 5 and 480 minutes.');
            return setStatus('serviceDuration', 'err-serviceDuration', false);
        }

        function validateSocialInstagram(strict) {
            const v = val('socialInstagram');
            if (!v) return setStatus('socialInstagram', 'err-socialInstagram', false);
            if (v.length > 100) return setStatus('socialInstagram', 'err-socialInstagram', true, 'Instagram handle too long.');
            return setStatus('socialInstagram', 'err-socialInstagram', false);
        }

        function validateSocialFacebook(strict) {
            const v = val('socialFacebook');
            if (!v) return setStatus('socialFacebook', 'err-socialFacebook', false);
            if (v.length > 150) return setStatus('socialFacebook', 'err-socialFacebook', true, 'Facebook URL or handle too long.');
            return setStatus('socialFacebook', 'err-socialFacebook', false);
        }

        function validateSocialWebsite(strict) {
            const v = val('socialWebsite');
            if (!v) return setStatus('socialWebsite', 'err-socialWebsite', false);
            if (!/^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/\S*)?$/i.test(v)) {
                return setStatus('socialWebsite', 'err-socialWebsite', true, 'Please enter a valid URL (e.g. https://www.salon.com).');
            }
            return setStatus('socialWebsite', 'err-socialWebsite', false);
        }

        function validateSalonPincode(strict) {
            const v = val('salonPincode');
            if (!v) return setStatus('salonPincode', 'err-pincode', strict, 'Pincode is required.');
            if (!/^\d{6}$/.test(v)) return setStatus('salonPincode', 'err-pincode', true, 'Pincode must be exactly 6 digits.');
            return setStatus('salonPincode', 'err-pincode', false);
        }

        // Dynamic progress calculation (20 milestones, 5% each = 100%)
        function updateStepStatus(stepId, statusId, isDone, customText) {
            const stepEl = document.getElementById(stepId);
            const statusEl = document.getElementById(statusId);
            if (stepEl) {
                if (isDone) stepEl.classList.add('done');
                else stepEl.classList.remove('done');
            }
            if (statusEl) {
                statusEl.textContent = customText ? customText : (isDone ? 'Completed' : 'Pending');
            }
        }

        function recalculateSalonProgress() {
            let filled = 0;
            const total = 19;

            // 1. Salon Name (>= 3 chars)
            const hasName = val('salonName').length >= 3;
            if (hasName) filled++;

            // 2. Business Type
            const hasType = val('salonType') !== '' || val('salonCategory') !== '';
            if (hasType) filled++;

            // 3. Description / Bio (>= 10 chars)
            const hasBio = val('salonBio').length >= 10;
            if (hasBio) filled++;

            // 4. Official Phone (10 digits starting with 6-9)
            const hasPhone = /^[6-9]\d{9}$/.test(val('salonPhone'));
            if (hasPhone) filled++;

            // 5. Official Email (valid email format)
            const hasEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val('salonEmail'));
            if (hasEmail) filled++;

            // 6. Full Address (>= 5 chars)
            const hasAddress = val('salonAddress').length >= 5;
            if (hasAddress) filled++;

            // 7. State
            const hasState = val('stateSelect') !== '';
            if (hasState) filled++;

            // 8. District / City
            const dist = val('districtSelect');
            const customCity = val('customCityInput');
            const cityVal = (dist && dist !== 'Other') ? dist : (customCity || val('inputCity'));
            const hasCity = cityVal !== '';
            if (hasCity) filled++;

            const hasPincode = /^\d{6}$/.test(val('salonPincode'));

            // Step 1: Basic Info Done Flag
            const basicDone = hasName && hasType && hasBio && hasPhone && hasAddress && hasState && hasCity && hasPincode;
            updateStepStatus('stepBasicInfo', 'statusBasicInfo', basicDone);

            // 9. Salon Category
            const hasCategory = val('salonCategory') !== '';
            if (hasCategory) filled++;

            // 10. Established Year (valid 4-digit year 1900-currentYear)
            const yearVal = parseInt(val('establishedYear'), 10);
            const currentYear = new Date().getFullYear();
            const hasYear = !isNaN(yearVal) && yearVal >= 1900 && yearVal <= currentYear;
            if (hasYear) filled++;

            // 11. Total Chairs / Stations (>= 1)
            const chairsVal = parseInt(val('totalChairs'), 10);
            const hasChairs = !isNaN(chairsVal) && chairsVal >= 1 && chairsVal <= 500;
            if (hasChairs) filled++;

            // 12. Salon Size (>= 50 sq.ft)
            const sizeVal = parseInt(val('salonSizeSqFt'), 10);
            const hasSize = !isNaN(sizeVal) && sizeVal >= 50 && sizeVal <= 50000;
            if (hasSize) filled++;

            // 13. Languages Spoken
            const hasLang = val('languagesSpoken').trim().length > 0;
            if (hasLang) filled++;

            // Step 2: Salon Details Done Flag
            const detailsDone = hasCategory && hasChairs && hasSize && hasLang;
            updateStepStatus('stepSalonDetails', 'statusSalonDetails', detailsDone);

            // 14. Profile Photo / Logo
            const profileInput = document.getElementById('profileImageInput');
            const hasUploadedProfile = profileInput && profileInput.files && profileInput.files.length > 0;
            const hasProfileImg = hasUploadedProfile || hasExistingProfilePhoto;
            if (hasProfileImg) filled++;

            // 15. Cover Photo / Interior Photos
            const coverInput = document.getElementById('coverImageInput');
            const interiorInput = document.getElementById('interiorImageInput');
            const hasUploadedCover = (coverInput && coverInput.files && coverInput.files.length > 0) ||
                                     (interiorInput && interiorInput.files && interiorInput.files.length > 0);
            const hasCoverImg = hasUploadedCover || hasExistingCover;
            if (hasCoverImg) filled++;

            // Step 4: Photos Done Flag
            const photosDone = hasProfileImg || hasCoverImg;
            updateStepStatus('stepPhotos', 'statusPhotos', photosDone);

            // 16. Facilities & Amenities
            const hasFacilities = val('hasAc') === 'true' || val('hasWifi') === 'true' ||
                                  val('hasParkingFacility') === 'true' || val('hasPowerBackup') === 'true' ||
                                  val('isWheelchairAccessible') === 'true' ||
                                  hasExistingFacilities;
            if (hasFacilities) filled++;
            updateStepStatus('stepFacilities', 'statusFacilities', hasFacilities);

            // 17 & 18. Documents (up to 5)
            let uploadedDocs = 0;
            ['fileBus', 'fileLic', 'fileGst', 'fileHyg', 'fileFire'].forEach(id => {
                const inp = document.getElementById(id);
                if (inp && inp.files && inp.files.length > 0) uploadedDocs++;
            });
            const totalDocsCount = Math.min(5, initialDocsCount + uploadedDocs);
            if (totalDocsCount >= 1) filled++;
            if (totalDocsCount >= 2) filled++;
            updateStepStatus('stepDocs', 'statusDocs', totalDocsCount > 0, totalDocsCount + '/5 Completed');

            // 19. Social Media (up to 3)
            let typedSocial = 0;
            if (val('socialInstagram') !== '') typedSocial++;
            if (val('socialFacebook') !== '') typedSocial++;
            if (val('socialWebsite') !== '') typedSocial++;
            const totalSocialCount = Math.max(typedSocial, initialSocialCount);
            if (totalSocialCount > 0) filled++;
            updateStepStatus('stepSocial', 'statusSocial', totalSocialCount > 0, Math.min(3, totalSocialCount) + '/3 Completed');

            // Accurate Percentage: 19 milestones
            const pct = Math.min(100, Math.round((100 * filled) / total));

            // Update UI elements
            const circleInner = document.getElementById('ptCircleInner');
            const circleWrap = document.getElementById('ptCircleWrap');
            if (circleInner) circleInner.textContent = pct + '%';
            if (circleWrap) circleWrap.style.background = 'conic-gradient(var(--brand-pink) ' + pct + '%, #f0f0f0 0)';

            const stepsBar = document.getElementById('ptStepsBar');
            if (stepsBar) stepsBar.style.setProperty('--progress', pct + '%');
        }

        // Cascading State & District Setup
        function initLocationSelectors() {
            const stateSelect = document.getElementById('stateSelect');
            const districtSelect = document.getElementById('districtSelect');
            const customCityGroup = document.getElementById('customCityGroup');
            const customCityInput = document.getElementById('customCityInput');
            const cityInput = document.getElementById('inputCity');

            const indiaStates = locationData["India"] || {};
            const stateNames = Object.keys(indiaStates).sort();

            stateSelect.innerHTML = '<option value="">-- Select State --</option>';
            stateNames.forEach(st => {
                const opt = document.createElement('option');
                opt.value = st;
                opt.textContent = st;
                if (savedState && (st.toLowerCase() === savedState.toLowerCase().trim())) {
                    opt.selected = true;
                }
                stateSelect.appendChild(opt);
            });

            function populateDistricts(selectedState, selectedDistrict) {
                districtSelect.innerHTML = '<option value="">-- Select District / City --</option>';
                if (!selectedState) {
                    districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    return;
                }

                const districts = indiaStates[selectedState] || ["Other"];
                const targetCity = selectedDistrict || savedCity || '';
                let matched = false;

                districts.forEach(dist => {
                    const opt = document.createElement('option');
                    opt.value = dist;
                    opt.textContent = dist;
                    if (targetCity && dist.toLowerCase() === targetCity.toLowerCase().trim()) {
                        opt.selected = true;
                        matched = true;
                    }
                    districtSelect.appendChild(opt);
                });

                if (targetCity && !matched && targetCity !== "Other") {
                    districtSelect.value = "Other";
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.value = targetCity;
                    if (cityInput) cityInput.value = targetCity;
                } else if (districtSelect.value === "Other") {
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (cityInput && customCityInput) cityInput.value = customCityInput.value.trim();
                } else {
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    if (cityInput) cityInput.value = districtSelect.value;
                }
            }

            if (stateSelect.value) {
                populateDistricts(stateSelect.value, savedCity);
            }

            stateSelect.addEventListener('change', function () {
                validateSalonState(true);
                populateDistricts(this.value, '');
                validateSalonCity(false);
                recalculateSalonProgress();
            });

            districtSelect.addEventListener('change', function () {
                if (this.value === 'Other') {
                    if (customCityGroup) customCityGroup.style.display = 'block';
                    if (customCityInput) customCityInput.focus();
                    if (cityInput && customCityInput) cityInput.value = customCityInput.value.trim();
                } else {
                    if (customCityGroup) customCityGroup.style.display = 'none';
                    if (cityInput) cityInput.value = this.value;
                }
                validateSalonCity(true);
                recalculateSalonProgress();
            });

            if (customCityInput) {
                customCityInput.addEventListener('input', function () {
                    if (districtSelect.value === 'Other' && cityInput) {
                        cityInput.value = this.value.trim();
                    }
                    validateSalonCity(true);
                    recalculateSalonProgress();
                });
            }

            // Reusable Multiselect Component Engine
            function initMultiSelect(config) {
                const container = document.getElementById(config.containerId);
                if (!container) return;
                const hiddenInput = document.getElementById(config.hiddenInputId);
                const chipsContainer = document.getElementById(config.chipsId);
                const trigger = container.querySelector('.fdf-multiselect-trigger');
                const searchInput = container.querySelector('.fdf-multiselect-search');
                const listContainer = container.querySelector('.fdf-multiselect-list');
                const customInput = container.querySelector('.fdf-multiselect-custom-input');
                const customBtn = container.querySelector('.fdf-multiselect-custom-btn');

                let allOptions = [...config.options];
                let selectedValues = [];

                if (hiddenInput && hiddenInput.value) {
                    selectedValues = hiddenInput.value.split(',')
                        .map(s => s.trim())
                        .filter(Boolean);
                    selectedValues.forEach(v => {
                        if (!allOptions.includes(v)) allOptions.push(v);
                    });
                }

                function syncValue() {
                    if (hiddenInput) {
                        hiddenInput.value = selectedValues.join(', ');
                        hiddenInput.dispatchEvent(new Event('input', { bubbles: true }));
                        hiddenInput.dispatchEvent(new Event('change', { bubbles: true }));
                    }
                    renderChips();
                    renderList(searchInput ? searchInput.value : '');
                }

                function renderChips() {
                    if (!chipsContainer) return;
                    chipsContainer.innerHTML = '';
                    if (selectedValues.length === 0) {
                        const placeholder = document.createElement('span');
                        placeholder.className = 'fdf-multiselect-placeholder';
                        placeholder.textContent = config.placeholder || 'Select...';
                        chipsContainer.appendChild(placeholder);
                        return;
                    }

                    selectedValues.forEach(val => {
                        const chip = document.createElement('span');
                        chip.className = 'fdf-multiselect-chip';
                        chip.textContent = val;

                        const removeBtn = document.createElement('span');
                        removeBtn.className = 'fdf-multiselect-chip-remove';
                        removeBtn.innerHTML = '&times;';
                        removeBtn.title = 'Remove ' + val;
                        removeBtn.addEventListener('click', (e) => {
                            e.stopPropagation();
                            selectedValues = selectedValues.filter(x => x !== val);
                            syncValue();
                        });

                        chip.appendChild(removeBtn);
                        chipsContainer.appendChild(chip);
                    });
                }

                function renderList(query) {
                    if (!listContainer) return;
                    listContainer.innerHTML = '';
                    const q = (query || '').toLowerCase().trim();
                    const filtered = allOptions.filter(opt => opt.toLowerCase().includes(q));

                    if (filtered.length === 0) {
                        const empty = document.createElement('div');
                        empty.style.padding = '8px 14px';
                        empty.style.fontSize = '0.85rem';
                        empty.style.color = '#94a3b8';
                        empty.textContent = 'No matching options';
                        listContainer.appendChild(empty);
                        return;
                    }

                    filtered.forEach(opt => {
                        const item = document.createElement('label');
                        item.className = 'fdf-multiselect-item';

                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.checked = selectedValues.includes(opt);
                        checkbox.addEventListener('change', () => {
                            if (checkbox.checked) {
                                if (!selectedValues.includes(opt)) selectedValues.push(opt);
                            } else {
                                selectedValues = selectedValues.filter(x => x !== opt);
                            }
                            syncValue();
                        });

                        const text = document.createElement('span');
                        text.textContent = opt;

                        item.appendChild(checkbox);
                        item.appendChild(text);
                        listContainer.appendChild(item);
                    });
                }

                function addCustomOption() {
                    if (!customInput) return;
                    const val = customInput.value.trim();
                    if (!val) return;
                    if (!allOptions.includes(val)) allOptions.push(val);
                    if (!selectedValues.includes(val)) selectedValues.push(val);
                    customInput.value = '';
                    syncValue();
                }

                if (customBtn) {
                    customBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        addCustomOption();
                    });
                }
                if (customInput) {
                    customInput.addEventListener('keydown', (e) => {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            e.stopPropagation();
                            addCustomOption();
                        }
                    });
                }

                if (searchInput) {
                    searchInput.addEventListener('input', () => {
                        renderList(searchInput.value);
                    });
                    searchInput.addEventListener('click', (e) => e.stopPropagation());
                }

                if (trigger) {
                    trigger.addEventListener('click', (e) => {
                        const isOpen = container.classList.contains('open');
                        document.querySelectorAll('.fdf-multiselect.open').forEach(el => {
                            if (el !== container) el.classList.remove('open');
                        });
                        container.classList.toggle('open', !isOpen);
                        if (!isOpen && searchInput) {
                            setTimeout(() => searchInput.focus(), 50);
                        }
                    });
                }

                renderChips();
                renderList('');
            }

            document.addEventListener('click', function(e) {
                document.querySelectorAll('.fdf-multiselect.open').forEach(function(el) {
                    if (!el.contains(e.target)) {
                        el.classList.remove('open');
                    }
                });
            });

            // Languages Multiselect Component Initialization
            initMultiSelect({
                containerId: 'languagesMultiselect',
                hiddenInputId: 'languagesSpoken',
                chipsId: 'languagesChips',
                options: ['English', 'Hindi', 'Kannada', 'Tamil', 'Telugu', 'Malayalam', 'Marathi', 'Gujarati', 'Bengali', 'Punjabi', 'Urdu', 'French', 'German', 'Spanish'],
                placeholder: 'Select or type languages spoken...'
            });

            // Dynamic Document File Selection Feedback Handler
            document.querySelectorAll('.doc-file-input').forEach(function(input) {
                input.addEventListener('change', function() {
                    const wrap = this.closest('.f-group') ? this.closest('.f-group').querySelector('.doc-status-wrap') : null;
                    if (!wrap) return;

                    if (this.files && this.files.length > 0) {
                        const file = this.files[0];
                        const fileName = file.name;
                        wrap.innerHTML = '<div class="doc-badge selected"><i class="bi bi-file-earmark-check-fill"></i> Selected: <strong>' + fileName + '</strong></div><div class="doc-preview-box"><span class="doc-file-info" style="font-size:0.8rem; color:#1d4ed8; font-weight:600;"><i class="bi bi-paperclip me-1"></i> Ready to upload on Save</span></div>';
                    } else {
                        wrap.innerHTML = '<div class="doc-badge not-uploaded"><i class="bi bi-dash-circle"></i> Not uploaded</div>';
                    }
                    if (typeof recalculateSalonProgress === 'function') {
                        recalculateSalonProgress();
                    }
                });
            });
        }

        // Master Save Validation Handler
        function handleProfileSave(e) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }

            // Sync city input before validation
            const dist = val('districtSelect');
            const cityInput = document.getElementById('inputCity');
            if (dist === 'Other') {
                if (cityInput) cityInput.value = val('customCityInput');
            } else if (dist) {
                if (cityInput) cityInput.value = dist;
            }

            const isNameValid = validateSalonName(true);
            const isTypeValid = validateSalonType(true);
            const isCategoryValid = validateSalonCategory(true);
            const isYearValid = validateEstablishedYear(true);
            const isGstValid = validateGstNumber(true);
            const isBioValid = validateSalonBio(true);
            const isPhoneValid = validateSalonPhone(true);
            const isAltValid = validateAlternateNumber(true);
            const isEmailValid = validateSalonEmail(true);
            const isAddressValid = validateSalonAddress(true);
            const isStateValid = validateSalonState(true);
            const isCityValid = validateSalonCity(true);
            const isPincodeValid = validateSalonPincode(true);

            // Tab: Salon Details Validations
            const isChairsValid = validateTotalChairs(true);
            const isRoomsValid = validateTreatmentRooms(true);
            const isWashroomsValid = validateWashrooms(true);
            const isSizeValid = validateSalonSize(true);
            const isLicValid = validateSalonLicenseNo(true);
            const isLangValid = validateLanguagesSpoken(true);

            // Optional Services & Social validations
            const isSvcNameValid = validateServiceName(true);
            const isSvcPriceValid = validateServicePrice(true);
            const isSvcDurValid = validateServiceDuration(true);
            const isInstaValid = validateSocialInstagram(true);
            const isFbValid = validateSocialFacebook(true);
            const isWebValid = validateSocialWebsite(true);

            const allValid = isNameValid && isTypeValid && isCategoryValid && isYearValid &&
                             isGstValid && isBioValid && isPhoneValid && isAltValid &&
                             isEmailValid && isAddressValid && isStateValid && isCityValid && isPincodeValid &&
                             isChairsValid && isRoomsValid && isWashroomsValid && isSizeValid && isLicValid && isLangValid &&
                             isSvcNameValid && isSvcPriceValid && isSvcDurValid && isInstaValid && isFbValid && isWebValid;

            if (!allValid) {
                const firstInvalid = document.querySelector('.f-control.is-invalid, select.is-invalid, textarea.is-invalid');
                if (firstInvalid) {
                    // Switch to tab containing invalid field
                    const parentPane = firstInvalid.closest('.tab-pane');
                    if (parentPane && parentPane.id) {
                        const tabBtn = document.querySelector('.custom-tab[data-target="' + parentPane.id + '"]');
                        if (tabBtn) tabBtn.click();
                    }
                    setTimeout(() => {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstInvalid.focus();
                    }, 100);
                }

                const toast = document.getElementById('validationToast');
                if (toast) {
                    toast.style.display = 'flex';
                    setTimeout(() => { toast.style.display = 'none'; }, 4000);
                }
                return false;
            }

            // Ensure editable section is displayed so backend accepts the fields
            const editSec = document.getElementById('editableSections');
            if (editSec) editSec.style.display = 'block';

            document.getElementById('profileForm').submit();
            return true;
        }

        // DOM Initialization
        document.addEventListener("DOMContentLoaded", function () {
            initLocationSelectors();

            // Bio char count
            const bioArea = document.getElementById('salonBio');
            const bioCounter = document.getElementById('bioCharCount');
            if (bioArea && bioCounter) {
                const updateBioCount = () => {
                    bioCounter.textContent = bioArea.value.length + ' / 2000';
                };
                bioArea.addEventListener('input', () => {
                    updateBioCount();
                    validateSalonBio(false);
                    recalculateSalonProgress();
                });
                updateBioCount();
            }

            // Strict numeric filters for details
            const chairsEl = document.getElementById('totalChairs');
            if (chairsEl) {
                chairsEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 3);
                    validateTotalChairs(false);
                    recalculateSalonProgress();
                });
                chairsEl.addEventListener('blur', () => validateTotalChairs(true));
            }

            const roomsEl = document.getElementById('treatmentRooms');
            if (roomsEl) {
                roomsEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 3);
                    validateTreatmentRooms(false);
                });
                roomsEl.addEventListener('blur', () => validateTreatmentRooms(true));
            }

            const washEl = document.getElementById('washrooms');
            if (washEl) {
                washEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 2);
                    validateWashrooms(false);
                });
                washEl.addEventListener('blur', () => validateWashrooms(true));
            }

            const sizeEl = document.getElementById('salonSizeSqFt');
            if (sizeEl) {
                sizeEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 5);
                    validateSalonSize(false);
                    recalculateSalonProgress();
                });
                sizeEl.addEventListener('blur', () => validateSalonSize(true));
            }

            const svcPriceEl = document.getElementById('servicePrice');
            if (svcPriceEl) {
                svcPriceEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 6);
                    validateServicePrice(false);
                });
                svcPriceEl.addEventListener('blur', () => validateServicePrice(true));
            }

            const svcDurEl = document.getElementById('serviceDuration');
            if (svcDurEl) {
                svcDurEl.addEventListener('input', function() {
                    this.value = this.value.replace(/\D/g, '').slice(0, 3);
                    validateServiceDuration(false);
                });
                svcDurEl.addEventListener('blur', () => validateServiceDuration(true));
            }

            const svcNameEl = document.getElementById('serviceName');
            if (svcNameEl) {
                svcNameEl.addEventListener('input', () => validateServiceName(false));
                svcNameEl.addEventListener('blur', () => validateServiceName(true));
            }

            const licEl = document.getElementById('salonLicenseNo');
            if (licEl) {
                licEl.addEventListener('input', () => validateSalonLicenseNo(false));
                licEl.addEventListener('blur', () => validateSalonLicenseNo(true));
            }

            const langEl = document.getElementById('languagesSpoken');
            if (langEl) {
                langEl.addEventListener('input', () => validateLanguagesSpoken(false));
                langEl.addEventListener('blur', () => validateLanguagesSpoken(true));
            }

            const instaEl = document.getElementById('socialInstagram');
            if (instaEl) {
                instaEl.addEventListener('input', () => validateSocialInstagram(false));
                instaEl.addEventListener('blur', () => validateSocialInstagram(true));
            }

            const fbEl = document.getElementById('socialFacebook');
            if (fbEl) {
                fbEl.addEventListener('input', () => validateSocialFacebook(false));
                fbEl.addEventListener('blur', () => validateSocialFacebook(true));
            }

            const webEl = document.getElementById('socialWebsite');
            if (webEl) {
                webEl.addEventListener('input', () => validateSocialWebsite(false));
                webEl.addEventListener('blur', () => validateSocialWebsite(true));
            }

            // Strict numeric filters
            const phoneEl = document.getElementById('salonPhone');
            if (phoneEl) {
                phoneEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                    validateSalonPhone(false);
                    if (val('alternateNumber')) validateAlternateNumber(false);
                    recalculateSalonProgress();
                });
                phoneEl.addEventListener('blur', () => validateSalonPhone(true));
            }

            const altPhoneEl = document.getElementById('alternateNumber');
            if (altPhoneEl) {
                altPhoneEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\D/g, '').slice(0, 10);
                    validateAlternateNumber(false);
                    recalculateSalonProgress();
                });
                altPhoneEl.addEventListener('blur', () => validateAlternateNumber(true));
            }

            const pincodeEl = document.getElementById('salonPincode');
            if (pincodeEl) {
                pincodeEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\D/g, '').slice(0, 6);
                    validateSalonPincode(false);
                    recalculateSalonProgress();
                });
                pincodeEl.addEventListener('blur', () => validateSalonPincode(true));
            }

            const yearEl = document.getElementById('establishedYear');
            if (yearEl) {
                yearEl.addEventListener('input', function () {
                    this.value = this.value.replace(/\D/g, '').slice(0, 4);
                    validateEstablishedYear(false);
                    recalculateSalonProgress();
                });
                yearEl.addEventListener('blur', () => validateEstablishedYear(true));
            }

            const gstEl = document.getElementById('gstNumber');
            if (gstEl) {
                gstEl.addEventListener('input', function () {
                    this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(0, 15);
                    validateGstNumber(false);
                });
                gstEl.addEventListener('blur', () => validateGstNumber(true));
            }

            // Bind other fields
            const nameEl = document.getElementById('salonName');
            if (nameEl) {
                nameEl.addEventListener('input', () => { validateSalonName(false); recalculateSalonProgress(); });
                nameEl.addEventListener('blur', () => validateSalonName(true));
            }

            const typeEl = document.getElementById('salonType');
            if (typeEl) {
                typeEl.addEventListener('change', () => { validateSalonType(true); recalculateSalonProgress(); });
            }

            const catEl = document.getElementById('salonCategory');
            if (catEl) {
                catEl.addEventListener('change', () => { validateSalonCategory(true); recalculateSalonProgress(); });
            }

            const emailEl = document.getElementById('salonEmail');
            if (emailEl) {
                emailEl.addEventListener('input', () => { validateSalonEmail(false); recalculateSalonProgress(); });
                emailEl.addEventListener('blur', () => validateSalonEmail(true));
            }

            const addrEl = document.getElementById('salonAddress');
            if (addrEl) {
                addrEl.addEventListener('input', () => { validateSalonAddress(false); recalculateSalonProgress(); });
                addrEl.addEventListener('blur', () => validateSalonAddress(true));
            }

            recalculateSalonProgress();
        });

        function openSalonPreviewModal() {
            function val(idOrName) {
                const el = document.getElementById(idOrName) || document.querySelector('[name="' + idOrName + '"]');
                return el ? el.value.trim() : '';
            }
            function checked(idOrName) {
                const el = document.getElementById(idOrName) || document.querySelector('[name="' + idOrName + '"]');
                return el && el.checked ? 'Yes' : 'No';
            }
            function prefVal(name, defaultVal) {
                const el = document.querySelector('[name="' + name + '"]');
                return el ? el.value : (defaultVal || '—');
            }

            // Hero Photos & Title
            const nameVal = val('salonName') || val('name') || '${salon.name}' || 'Your Salon Name';
            const pvHeroName = document.getElementById('pvHeroName');
            if (pvHeroName) pvHeroName.textContent = nameVal;
            const pvSalonName = document.getElementById('pvSalonName');
            if (pvSalonName) pvSalonName.textContent = nameVal;

            const catVal = val('salonCategory') || '${salon.salonCategory}' || 'Category Not Set';
            const pvHeroCategory = document.getElementById('pvHeroCategory');
            if (pvHeroCategory) pvHeroCategory.textContent = catVal;
            const pvSalonCategory = document.getElementById('pvSalonCategory');
            if (pvSalonCategory) pvSalonCategory.textContent = catVal;

            const typeVal = val('salonType') || '${salon.salonType}' || 'Unisex';
            const pvHeroType = document.getElementById('pvHeroType');
            if (pvHeroType) pvHeroType.textContent = typeVal;
            const pvSalonType = document.getElementById('pvSalonType');
            if (pvSalonType) pvSalonType.textContent = typeVal;

            const statusVal = val('currentStatus') || '${salon.currentStatus}' || 'Active';
            const pvHeroStatus = document.getElementById('pvHeroStatus');
            if (pvHeroStatus) pvHeroStatus.textContent = statusVal;
            const pvCurrentStatus = document.getElementById('pvCurrentStatus');
            if (pvCurrentStatus) pvCurrentStatus.textContent = statusVal;

            // Profile & Cover Image Previews
            const logoImg = document.getElementById('logoPreview');
            const pvLogoImg = document.getElementById('pvProfileImage');
            if (logoImg && logoImg.src && pvLogoImg) {
                pvLogoImg.src = logoImg.src;
            }

            const coverImg = document.getElementById('coverPreview');
            const pvCoverBanner = document.getElementById('pvCoverBanner');
            if (coverImg && coverImg.src && pvCoverBanner) {
                pvCoverBanner.style.backgroundImage = 'url("' + coverImg.src + '")';
            }

            // Basic & Business Overview
            document.getElementById('pvEstablishedYear').textContent = val('establishedYear') || '${salon.establishedYear}' || '—';
            const wOnly = document.getElementById('isWomenOnly');
            const isWOnly = (wOnly && wOnly.checked) || prefVal('isWomenOnly') === 'true' || '${salon.isWomenOnly}' === 'true';
            document.getElementById('pvWomenOnly').textContent = isWOnly ? 'Yes' : 'No';
            document.getElementById('pvBio').textContent = val('bio') || '${salon.bio}' || 'No description provided yet.';

            // Contact & Location
            document.getElementById('pvEmail').textContent = val('email') || '${salon.email}' || '—';
            document.getElementById('pvPhone').textContent = val('phone') || '${salon.phone}' || '—';
            document.getElementById('pvAltPhone').textContent = val('alternateNumber') || '${salon.alternateNumber}' || '—';
            document.getElementById('pvWebsite').textContent = val('website') || '${salon.website}' || '—';
            document.getElementById('pvAddress').textContent = val('address') || '${salon.address}' || '—';

            const distVal = val('districtSelect');
            const customCity = val('customCityInput');
            const city = (distVal && distVal !== 'Other') ? distVal : (customCity || val('city') || '${salon.city}');
            const state = val('stateSelect') || val('state') || '${salon.state}';
            const pincode = val('pincode') || '${salon.pincode}';
            document.getElementById('pvLocation').textContent = [city, state, pincode].filter(Boolean).join(', ') || '—';
            document.getElementById('pvLandmark').textContent = val('landmark') || '${salon.landmark}' || '—';

            // Operating Hours Schedule
            const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
            const hoursListHtml = days.map(day => {
                const dayCap = day.charAt(0).toUpperCase() + day.slice(1);
                const isClosed = document.getElementById('hours_' + day + '_closed')?.checked;
                const openTime = val('hours_' + day + '_open');
                const closeTime = val('hours_' + day + '_close');
                let timeStr = 'Not set';
                if (isClosed) {
                    timeStr = '<span style="color:#ef4444;font-weight:700;">Closed</span>';
                } else if (openTime && closeTime) {
                    timeStr = openTime + ' - ' + closeTime;
                }
                return '<div style="display:flex;justify-content:space-between;padding:4px 0;border-bottom:1px dashed #e2e8f0;font-size:0.85rem;"><span style="font-weight:600;color:#334155;">' + dayCap + '</span><span style="color:#0f172a;font-weight:700;">' + timeStr + '</span></div>';
            }).join('');
            document.getElementById('pvOperatingHours').innerHTML = hoursListHtml;

            // Facilities & Capacity
            const sizeSq = val('salonSizeSqFt') || '${salon.salonSizeSqFt}';
            document.getElementById('pvSizeSqFt').textContent = sizeSq ? sizeSq + ' Sq Ft' : '—';
            document.getElementById('pvTotalChairs').textContent = val('totalChairs') || '${salon.totalChairs}' || '—';
            document.getElementById('pvTreatmentRooms').textContent = val('treatmentRooms') || '${salon.treatmentRooms}' || '—';
            document.getElementById('pvWashrooms').textContent = val('washrooms') || '${salon.washrooms}' || '—';
            document.getElementById('pvTotalFloors').textContent = val('totalFloors') || '${salon.totalFloors}' || '—';
            document.getElementById('pvHygieneStandard').textContent = val('hygieneStandard') || '${salon.hygieneStandard}' || '—';

            const amenities = [];
            if (checked('hasAc') === 'Yes' || prefVal('hasAc') === 'true' || val('hasAc') === 'true') amenities.push('Air Conditioning');
            if (checked('hasWifi') === 'Yes' || prefVal('hasWifi') === 'true' || val('hasWifi') === 'true') amenities.push('Wi-Fi');
            if (checked('hasParking') === 'Yes' || prefVal('hasParking') === 'true' || val('hasParking') === 'true' || val('hasParkingFacility') === 'true') amenities.push('Parking Space');
            if (checked('hasPowerBackup') === 'Yes' || prefVal('hasPowerBackup') === 'true' || val('hasPowerBackup') === 'true') amenities.push('Power Backup');
            if (checked('isWheelchairAccessible') === 'Yes' || prefVal('isWheelchairAccessible') === 'true' || val('isWheelchairAccessible') === 'true' || '${salon.isWheelchairAccessible}' === 'true') amenities.push('Wheelchair Accessible');
            if (checked('hasReceptionArea') === 'Yes' || prefVal('hasReceptionArea') === 'true') amenities.push('Reception Area');
            if (checked('hasWaitingArea') === 'Yes' || prefVal('hasWaitingArea') === 'true') amenities.push('Waiting Area');
            document.getElementById('pvAmenities').textContent = amenities.length > 0 ? amenities.join(' · ') : 'None specified';

            // Social Media Links
            const socials = [];
            const insta = val('socialInstagram');
            if (insta) socials.push('Instagram: ' + insta);
            const fb = val('socialFacebook');
            if (fb) socials.push('Facebook: ' + fb);
            const socWeb = val('socialWebsite');
            if (socWeb) socials.push('Website: ' + socWeb);
            document.getElementById('pvSocialLinks').textContent = socials.length > 0 ? socials.join(' | ') : 'None added';

            // Documents Status
            document.getElementById('pvBusinessRegNo').textContent = val('businessRegistrationNo') || '${salon.businessRegistrationNo}' || '—';
            document.getElementById('pvGstNumber').textContent = val('gstNumber') || '${salon.gstNumber}' || '—';
            document.getElementById('pvLicenseNo').textContent = val('salonLicenseNo') || '${salon.salonLicenseNo}' || '—';

            function docStatusLabel(fileId, existingPath) {
                const fileInput = document.getElementById(fileId);
                if (fileInput && fileInput.files && fileInput.files.length > 0) {
                    return '<span style="color:#059669;font-weight:700;"><i class="bi bi-file-earmark-check-fill"></i> Selected: ' + fileInput.files[0].name + '</span>';
                }
                if (existingPath && existingPath.trim() !== '') {
                    return '<span style="color:#2563eb;font-weight:700;"><i class="bi bi-check-circle-fill"></i> Uploaded (On File)</span>';
                }
                return '<span style="color:#94a3b8;"><i class="bi bi-dash-circle"></i> Not Uploaded</span>';
            }

            document.getElementById('pvDocBusinessReg').innerHTML = docStatusLabel('fileReg', '${salon.businessRegistrationUrl}');
            document.getElementById('pvDocLicense').innerHTML = docStatusLabel('fileLic', '${salon.salonLicenseUrl}');
            document.getElementById('pvDocFireSafety').innerHTML = docStatusLabel('fileFire', '${salon.fireSafetyUrl}');
            document.getElementById('pvDocGstCert').innerHTML = docStatusLabel('fileGst', '${salon.gstCertificateUrl}');
            document.getElementById('pvDocHygieneCert').innerHTML = docStatusLabel('fileHyg', '${salon.hygieneCertificateUrl}');

            const modal = document.getElementById('salonPreviewModal');
            if (modal) modal.style.display = 'flex';
        }

        function closeSalonPreviewModal() {
            const modal = document.getElementById('salonPreviewModal');
            if (modal) modal.style.display = 'none';
        }

        document.addEventListener('DOMContentLoaded', function() {
            const modal = document.getElementById('salonPreviewModal');
            if (modal) {
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) closeSalonPreviewModal();
                });
            }
        });
    </script>

    <!-- Salon Profile Preview Modal -->
    <div id="salonPreviewModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="previewModalTitle" style="display:none;">
        <div class="review-modal-card">
            <div class="modal-header" style="border-bottom:1px solid #e2e8f0; padding-bottom:12px; margin-bottom:14px;">
                <div class="icon-wrap"><i class="bi bi-shop"></i></div>
                <div style="flex: 1;">
                    <h3 id="previewModalTitle" style="font-size:1.18rem;font-weight:800;color:#0f172a;margin:0;">Live Salon Profile Preview</h3>
                    <p style="font-size:0.83rem;color:#64748b;margin:2px 0 0;">Complete snapshot of your salon profile as seen by customers.</p>
                </div>
                <button type="button" class="btn-close-modal" id="btnClosePreviewModal" onclick="closeSalonPreviewModal()" aria-label="Close modal">&times;</button>
            </div>

            <div class="review-modal-body">
                <!-- Top Hero Card Preview -->
                <div style="position:relative; background:#1e293b; border-radius:14px; overflow:hidden; margin-bottom:16px; color:#fff;">
                    <div id="pvCoverBanner" style="height:120px; background-size:cover; background-position:center; background-image:url('${not empty salon.coverImageUrl ? pageContext.request.contextPath.concat(salon.coverImageUrl) : "https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1200&q=80"}');"></div>
                    <div style="padding:16px; display:flex; align-items:center; gap:16px; flex-wrap:wrap; margin-top:-35px;">
                        <img id="pvProfileImage" src="${not empty salon.profileImageUrl ? pageContext.request.contextPath.concat(salon.profileImageUrl) : "https://ui-avatars.com/api/?name=".concat(salon.name).concat("&background=db2777&color=fff")}" alt="Profile Photo" style="width:70px; height:70px; border-radius:50%; object-fit:cover; border:3px solid #fff; background:#fff; flex-shrink:0;">
                        <div style="flex:1; min-width:180px;">
                            <h4 id="pvHeroName" style="font-size:1.1rem; font-weight:800; margin:0 0 4px 0; color:#fff;">${salon.name}</h4>
                            <div style="display:flex; gap:6px; flex-wrap:wrap;">
                                <span id="pvHeroCategory" class="badge" style="background:#db2777; color:#fff; font-size:0.75rem; font-weight:700;">${salon.salonCategory}</span>
                                <span id="pvHeroType" class="badge" style="background:#3b82f6; color:#fff; font-size:0.75rem; font-weight:700;">${salon.salonType}</span>
                                <span id="pvHeroStatus" class="badge" style="background:#10b981; color:#fff; font-size:0.75rem; font-weight:700;">${salon.currentStatus}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section 1: Overview -->
                <div class="review-section-block">
                    <div class="review-section-title"><span class="num">1</span> Salon Overview &amp; Bio</div>
                    <div class="review-grid">
                        <div class="review-item"><span class="review-item-label">Salon Name</span><span class="review-item-value" id="pvSalonName">—</span></div>
                        <div class="review-item"><span class="review-item-label">Category</span><span class="review-item-value" id="pvSalonCategory">—</span></div>
                        <div class="review-item"><span class="review-item-label">Salon Type</span><span class="review-item-value" id="pvSalonType">—</span></div>
                        <div class="review-item"><span class="review-item-label">Established Year</span><span class="review-item-value" id="pvEstablishedYear">—</span></div>
                        <div class="review-item"><span class="review-item-label">Operating Status</span><span class="review-item-value" id="pvCurrentStatus">—</span></div>
                        <div class="review-item"><span class="review-item-label">Women Only Salon</span><span class="review-item-value" id="pvWomenOnly">—</span></div>
                        <div class="review-item full"><span class="review-item-label">Overview &amp; Bio</span><span class="review-item-value" id="pvBio">—</span></div>
                    </div>
                </div>

                <!-- Section 2: Contact & Address -->
                <div class="review-section-block">
                    <div class="review-section-title"><span class="num">2</span> Contact &amp; Location</div>
                    <div class="review-grid">
                        <div class="review-item"><span class="review-item-label">Email Address</span><span class="review-item-value" id="pvEmail">—</span></div>
                        <div class="review-item"><span class="review-item-label">Phone Number</span><span class="review-item-value" id="pvPhone">—</span></div>
                        <div class="review-item"><span class="review-item-label">Alternate Phone</span><span class="review-item-value" id="pvAltPhone">—</span></div>
                        <div class="review-item"><span class="review-item-label">Website</span><span class="review-item-value" id="pvWebsite">—</span></div>
                        <div class="review-item full"><span class="review-item-label">Address</span><span class="review-item-value" id="pvAddress">—</span></div>
                        <div class="review-item"><span class="review-item-label">City / State / Pincode</span><span class="review-item-value" id="pvLocation">—</span></div>
                        <div class="review-item"><span class="review-item-label">Landmark</span><span class="review-item-value" id="pvLandmark">—</span></div>
                    </div>
                </div>

                <!-- Section 3: Daily Operating Hours -->
                <div class="review-section-block">
                    <div class="review-section-title"><span class="num">3</span> Daily Operating Hours (Mon – Sun)</div>
                    <div id="pvOperatingHours" style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:8px;">
                        <!-- Dynamically generated per day -->
                    </div>
                </div>

                <!-- Section 4: Facilities & Capacity -->
                <div class="review-section-block">
                    <div class="review-section-title"><span class="num">4</span> Facilities, Capacity &amp; Amenities</div>
                    <div class="review-grid">
                        <div class="review-item"><span class="review-item-label">Salon Size</span><span class="review-item-value" id="pvSizeSqFt">—</span></div>
                        <div class="review-item"><span class="review-item-label">Total Styling Chairs</span><span class="review-item-value" id="pvTotalChairs">—</span></div>
                        <div class="review-item"><span class="review-item-label">Treatment Rooms</span><span class="review-item-value" id="pvTreatmentRooms">—</span></div>
                        <div class="review-item"><span class="review-item-label">Washrooms</span><span class="review-item-value" id="pvWashrooms">—</span></div>
                        <div class="review-item"><span class="review-item-label">Total Floors</span><span class="review-item-value" id="pvTotalFloors">—</span></div>
                        <div class="review-item"><span class="review-item-label">Hygiene Rating</span><span class="review-item-value" id="pvHygieneStandard">—</span></div>
                        <div class="review-item full"><span class="review-item-label">Amenities &amp; Features</span><span class="review-item-value" id="pvAmenities">—</span></div>
                    </div>
                </div>

                <!-- Section 5: Social & Verification Documents -->
                <div class="review-section-block">
                    <div class="review-section-title"><span class="num">5</span> Verification Documents &amp; Social Links</div>
                    <div class="review-grid">
                        <div class="review-item full"><span class="review-item-label">Social Media Handles</span><span class="review-item-value" id="pvSocialLinks">—</span></div>
                        <div class="review-item"><span class="review-item-label">Business Reg No.</span><span class="review-item-value" id="pvBusinessRegNo">—</span></div>
                        <div class="review-item"><span class="review-item-label">Business Reg Document</span><span class="review-item-value" id="pvDocBusinessReg">—</span></div>
                        <div class="review-item"><span class="review-item-label">GST Number</span><span class="review-item-value" id="pvGstNumber">—</span></div>
                        <div class="review-item"><span class="review-item-label">GST Certificate</span><span class="review-item-value" id="pvDocGstCert">—</span></div>
                        <div class="review-item"><span class="review-item-label">License Number</span><span class="review-item-value" id="pvLicenseNo">—</span></div>
                        <div class="review-item"><span class="review-item-label">Salon License Document</span><span class="review-item-value" id="pvDocLicense">—</span></div>
                        <div class="review-item"><span class="review-item-label">Fire Safety NOC</span><span class="review-item-value" id="pvDocFireSafety">—</span></div>
                        <div class="review-item"><span class="review-item-label">Hygiene Certificate</span><span class="review-item-value" id="pvDocHygieneCert">—</span></div>
                    </div>
                </div>
            </div>

            <div class="review-modal-actions">
                <button type="button" class="btn-modal-cancel" id="btnClosePreviewModalBtn" onclick="closeSalonPreviewModal()"><i class="bi bi-pencil"></i> Back &amp; Edit</button>
                <button type="button" class="btn-modal-confirm" id="modalSaveProfileBtn" onclick="closeSalonPreviewModal(); handleProfileSave(event);"><i class="bi bi-check2-circle"></i> Save Profile</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>



