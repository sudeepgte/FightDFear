<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Complete Lawyer Profile | Fight D Fear</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --navy: #1E1B4B;
            --border: #E2E8F0;
            --border-focus: #F43F5E;
            --success: #10B981;
            --success-bg: #ECFDF5;
            --error: #EF4444;
            --error-bg: #FEF2F2;
            --warning: #F59E0B;
            --warning-bg: #FFFBEB;
            --shadow-sm: 0 1px 3px rgba(15, 23, 42, 0.05);
            --shadow-md: 0 4px 14px rgba(15, 23, 42, 0.08);
            --shadow-lg: 0 12px 30px rgba(15, 23, 42, 0.12);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--navy); display: flex; flex-direction: column; min-height: 100vh; }

        /* Top Bar */
        .topbar { background: var(--card-bg); padding: 14px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 100; box-shadow: var(--shadow-sm); }
        .brand { font-size: 1.25rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .brand img { height: 44px; width: auto; }
        .brand-text { font-size: 1.25rem; font-weight: 800; color: var(--navy); }
        .brand-tag { background: #FFE4E6; color: var(--primary); font-size: 0.72rem; font-weight: 700; padding: 3px 8px; border-radius: 6px; letter-spacing: 0.5px; border: 1px solid #FECDD3; }

        .topbar-actions { display: flex; gap: 12px; align-items: center; }
        .btn-skip { background: transparent; color: var(--secondary); padding: 9px 18px; border: 1px solid var(--border); border-radius: 10px; font-weight: 600; font-size: 0.88rem; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .btn-skip:hover { background: #F1F5F9; color: var(--navy); }
        .btn-save { background: var(--primary); color: white; padding: 10px 22px; border: none; border-radius: 10px; font-weight: 700; font-size: 0.9rem; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25); }
        .btn-save:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* Main Container */
        .container { max-width: 1260px; margin: 28px auto; padding: 0 20px; display: grid; grid-template-columns: 1.6fr 1fr; gap: 32px; width: 100%; }

        /* Form Card */
        .form-section { background: var(--card-bg); border-radius: 20px; padding: 34px; box-shadow: var(--shadow-sm); border: 1px solid var(--border); }

        /* Progress Header */
        .progress-box { background: #FFF5F7; border-radius: 16px; padding: 20px 24px; margin-bottom: 28px; border: 1px solid #FECDD3; }
        .progress-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .progress-header h2 { font-size: 1.15rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 8px; }
        .status-badge { background: #FFE4E6; color: var(--primary); font-size: 0.72rem; font-weight: 800; padding: 5px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 0.6px; border: 1px solid #FECDD3; }
        .status-badge.ready { background: #ECFDF5; color: #047857; border-color: #A7F3D0; }
        
        .progress-bar-bg { width: 100%; height: 9px; background: #E2E8F0; border-radius: 10px; overflow: hidden; margin-bottom: 10px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: 0%; transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
        .progress-text { font-size: 0.84rem; color: var(--secondary); font-weight: 500; }

        /* Validation Alert Summary Box */
        .alert-summary { display: none; background: #FEF2F2; border: 1.5px solid #FCA5A5; border-radius: 14px; padding: 18px 20px; margin-bottom: 26px; animation: slideDown 0.3s ease; }
        .alert-summary-header { display: flex; align-items: center; gap: 10px; color: #991B1B; font-weight: 800; font-size: 0.95rem; margin-bottom: 8px; }
        .alert-summary-header i { font-size: 1.25rem; color: #DC2626; }
        .alert-summary ul { list-style: none; padding-left: 0; margin: 0; display: flex; flex-direction: column; gap: 6px; }
        .alert-summary li { font-size: 0.85rem; color: #B91C1C; display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 3px 6px; border-radius: 6px; transition: 0.15s; }
        .alert-summary li:hover { background: #FEE2E2; text-decoration: underline; }
        .alert-summary li i { font-size: 0.8rem; }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Submit Button */
        .btn-submit-admin { width: 100%; background: var(--primary); color: white; padding: 15px; border: none; border-radius: 14px; font-weight: 800; font-size: 1rem; cursor: pointer; transition: 0.2s; display: none; align-items: center; justify-content: center; gap: 10px; margin-bottom: 30px; box-shadow: 0 4px 14px rgba(244, 63, 94, 0.3); }
        .btn-submit-admin:hover { background: var(--primary-hover); transform: translateY(-1px); box-shadow: 0 6px 18px rgba(244, 63, 94, 0.4); }

        /* Sections */
        .section-header { margin-top: 32px; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #F1F5F9; display: flex; justify-content: space-between; align-items: center; }
        .section-header:first-of-type { margin-top: 0; }
        .section-title { font-size: 1.05rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 10px; }
        .section-step { background: #FFE4E6; color: var(--primary); font-size: 0.75rem; font-weight: 800; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; border: 1px solid #FECDD3; }

        /* Form Grid */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; position: relative; }
        .form-group.full { grid-column: span 2; }
        
        .form-label { font-size: 0.84rem; font-weight: 700; color: #1E293B; display: flex; justify-content: space-between; align-items: center; }
        .form-label .req { color: var(--primary); margin-left: 2px; }
        .form-label .char-counter { font-size: 0.75rem; font-weight: 500; color: var(--secondary); }

        .input-wrapper { position: relative; display: flex; align-items: center; width: 100%; }
        .input-icon { position: absolute; left: 14px; color: #94A3B8; font-size: 0.95rem; pointer-events: none; transition: 0.2s; }
        
        .form-input, .form-select {
            width: 100%;
            padding: 12px 14px 12px 40px;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-family: inherit;
            font-size: 0.9rem;
            color: #0F172A;
            background: #FFFFFF;
            transition: all 0.2s ease;
            outline: none;
        }
        .form-input.no-icon, .form-select.no-icon { padding-left: 14px; }
        textarea.form-input { padding-left: 14px; resize: vertical; min-height: 85px; }

        .form-input:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.15);
        }
        .form-input:focus + .input-icon, .input-wrapper:focus-within .input-icon {
            color: var(--primary);
        }

        /* Validation States */
        .form-input.is-valid, .form-select.is-valid {
            border-color: var(--success);
            background-color: #FAFCF9;
        }
        .form-input.is-invalid, .form-select.is-invalid {
            border-color: var(--error) !important;
            background-color: #FFFDFD;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .feedback-msg { font-size: 0.77rem; font-weight: 600; margin-top: 4px; display: none; align-items: center; gap: 5px; }
        .feedback-msg.invalid { color: var(--error); display: flex; }
        .feedback-msg.valid { color: var(--success); display: flex; }

        /* Quick Chips */
        .chips-container { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
        .chip { background: #F1F5F9; color: #475569; font-size: 0.78rem; font-weight: 600; padding: 6px 12px; border-radius: 20px; cursor: pointer; border: 1px solid transparent; transition: all 0.2s; user-select: none; display: inline-flex; align-items: center; gap: 5px; }
        .chip:hover { background: #E2E8F0; color: #1E293B; }
        .chip.active { background: #FFE4E6; color: var(--primary); border-color: #FECDD3; font-weight: 700; }
        .chip.active i { display: inline-block; }
        .chip i { display: none; font-size: 0.75rem; }

        /* Cascading Helper Info */
        .cascade-info { font-size: 0.75rem; color: var(--secondary); margin-top: 3px; display: flex; align-items: center; gap: 4px; }

        /* Copy Button inside input */
        .btn-inline-action { position: absolute; right: 8px; background: #FFE4E6; border: 1px solid #FECDD3; color: var(--primary); font-size: 0.72rem; font-weight: 700; padding: 4px 10px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .btn-inline-action:hover { background: #FECDD3; }

        /* Bank Subcard */
        .bank-box { background: #F8FAFC; border: 1.5px solid #E2E8F0; border-radius: 14px; padding: 18px; grid-column: span 2; display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 6px; }
        .bank-box-title { grid-column: span 2; font-size: 0.88rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 8px; }

        /* Right Side: Live Profile Preview */
        .preview-section { position: sticky; top: 96px; height: fit-content; }
        .preview-card { background: var(--card-bg); border-radius: 20px; border: 1px solid var(--border); box-shadow: var(--shadow-md); overflow: hidden; }
        .preview-header { background: var(--navy); padding: 18px 22px; display: flex; justify-content: space-between; align-items: center; }
        .live-badge { background: var(--primary); color: white; font-size: 0.68rem; font-weight: 800; padding: 4px 9px; border-radius: 20px; display: inline-flex; align-items: center; gap: 5px; letter-spacing: 0.5px; }
        .live-dot { width: 6px; height: 6px; background: white; border-radius: 50%; animation: pulse 1.5s infinite; }
        .preview-header-title { color: #FFFFFF; font-size: 0.75rem; font-weight: 700; letter-spacing: 1px; }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.4; transform: scale(0.85); }
        }

        .preview-body { padding: 26px 24px; }
        .prev-avatar-wrap { position: relative; margin-bottom: 16px; }
        .prev-avatar { width: 72px; height: 72px; border-radius: 18px; background: #FFE4E6; color: var(--primary); font-size: 2rem; font-weight: 800; display: flex; justify-content: center; align-items: center; border: 3px solid #FFFFFF; box-shadow: 0 4px 10px rgba(0,0,0,0.06); overflow: hidden; }
        .prev-avatar img { width: 100%; height: 100%; object-fit: cover; }
        
        .prev-name { font-size: 1.25rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 6px; }
        .prev-name i { color: #10B981; font-size: 1.05rem; }
        .prev-designation { font-size: 0.86rem; font-weight: 700; color: var(--primary); margin-top: 2px; }
        .prev-bar-id { font-size: 0.75rem; font-weight: 600; color: #475569; background: #F1F5F9; padding: 3px 8px; border-radius: 6px; display: inline-block; margin-top: 6px; }
        .prev-location { font-size: 0.82rem; color: var(--secondary); display: flex; align-items: center; gap: 5px; margin-top: 10px; margin-bottom: 18px; }

        .prev-stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 18px; }
        .prev-stat-box { background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 12px; padding: 12px; }
        .prev-stat-label { font-size: 0.7rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 3px; }
        .prev-stat-val { font-size: 0.95rem; font-weight: 800; color: var(--navy); }

        .prev-section-label { font-size: 0.72rem; font-weight: 800; color: #64748B; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 16px; margin-bottom: 8px; }
        .prev-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .prev-tag { background: #FFE4E6; color: var(--primary); padding: 4px 10px; border-radius: 12px; font-size: 0.74rem; font-weight: 700; }
        
        .prev-bio { font-size: 0.83rem; color: #334155; line-height: 1.55; margin-top: 10px; background: #F8FAFC; padding: 12px; border-radius: 10px; border: 1px solid #E2E8F0; }

        .prev-footer { margin-top: 20px; padding-top: 14px; border-top: 1px solid #F1F5F9; font-size: 0.75rem; color: var(--secondary); display: flex; align-items: center; gap: 6px; justify-content: center; }

        /* Highlight pulse on element when clicked from error summary */
        @keyframes fieldHighlight {
            0% { box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.4); }
            50% { box-shadow: 0 0 0 6px rgba(239, 68, 68, 0.6); }
            100% { box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.4); }
        }
        .pulse-highlight {
            animation: fieldHighlight 0.8s ease 2;
        }

        @keyframes spin { 100% { transform: rotate(360deg); } }
        .spin { display: inline-block; animation: spin 1s linear infinite; }

        /* Mobile responsive */
        @media (max-width: 992px) {
            .container { grid-template-columns: 1fr; }
            .preview-section { display: none; }
        }
        @media (max-width: 640px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: span 1; }
            .bank-box { grid-template-columns: 1fr; }
            .bank-box-title { grid-column: span 1; }
            .topbar { padding: 12px 16px; flex-direction: column; gap: 10px; align-items: stretch; }
            .topbar-actions { justify-content: space-between; }
            .form-section { padding: 20px 16px; }
        }
    </style>
</head>
<body>

    <form id="profileForm" action="${pageContext.request.contextPath}/lawyer/profile-completion/save${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" novalidate>
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </c:if>

        <!-- Top Bar -->
        <header class="topbar">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="FightDFear Logo">
                <span class="brand-text">Fight D Fear</span>
                <span class="brand-tag"><i class="bi bi-shield-check"></i> ADVOCATE ONBOARDING</span>
            </a>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/lawyer/dashboard" class="btn-skip">Skip to Dashboard</a>
                <button type="submit" class="btn-save" id="btnSaveTop">
                    <i class="bi bi-check2-circle"></i> Save Profile
                </button>
            </div>
        </header>

        <div class="container">
            <!-- Left Form Section -->
            <div class="form-section">
                <!-- Progress Header -->
                <div class="progress-box">
                    <div class="progress-header">
                        <h2 id="progress-text-h2"><i class="bi bi-speedometer2"></i> Profile Completion: ${lawyer.profileCompletionPct != null ? lawyer.profileCompletionPct : 0}%</h2>
                        <span class="status-badge" id="statusBadge">${lawyer.partnerProfileStatus != null ? lawyer.partnerProfileStatus : 'REGISTERED'}</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" id="progress-bar-fill" style="width: ${lawyer.profileCompletionPct != null ? lawyer.profileCompletionPct : 0}%"></div>
                    </div>
                    <p class="progress-text" id="progress-desc-text">Complete all required advocate profile sections below for verification.</p>
                </div>

                <!-- Missing Fields Error Summary Card -->
                <div class="alert-summary" id="alertSummary">
                    <div class="alert-summary-header">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span id="alertSummaryTitle">Please correct the following issues before submitting:</span>
                    </div>
                    <ul id="alertSummaryList">
                        <!-- Populated dynamically via JS -->
                    </ul>
                </div>

                <c:if test="${lawyer.partnerProfileStatus == 'REGISTERED' || empty lawyer.partnerProfileStatus || lawyer.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                    <button type="submit" name="submitForVerification" value="true" class="btn-submit-admin" id="btnSubmitAdmin">
                        <i class="bi bi-send-check-fill"></i> Submit Profile for Admin Verification
                    </button>
                </c:if>

                <!-- SECTION 1: IDENTITY & ENROLLMENT -->
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-step">1</span> Advocate Identity & Enrollment
                    </div>
                </div>
                <div class="form-grid">
                    <!-- Full Name -->
                    <div class="form-group">
                        <label class="form-label" for="fullName">Full Name <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="fullName" name="fullName" class="form-input" value="${lawyer.fullName}" placeholder="e.g. Adv. Priya Sharma" required>
                            <i class="bi bi-person input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-fullName"></div>
                    </div>

                    <!-- Designation -->
                    <div class="form-group">
                        <label class="form-label" for="designation">Designation / Title</label>
                        <div class="input-wrapper">
                            <input type="text" id="designation" name="designation" class="form-input" value="${lawyer.designation != null ? lawyer.designation : ''}" placeholder="Advocate, High Court Counsel, etc.">
                            <i class="bi bi-award input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-designation"></div>
                    </div>

                    <!-- Phone Number -->
                    <div class="form-group">
                        <label class="form-label" for="phone">Official Phone <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="tel" id="phone" name="phone" class="form-input" value="${lawyer.phone}" placeholder="10-digit mobile number" maxlength="10" required>
                            <i class="bi bi-telephone input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-phone"></div>
                    </div>

                    <!-- WhatsApp Number -->
                    <div class="form-group">
                        <label class="form-label" for="whatsappNumber">WhatsApp Number</label>
                        <div class="input-wrapper">
                            <input type="tel" id="whatsappNumber" name="whatsappNumber" class="form-input" value="${lawyer.whatsappNumber}" placeholder="10-digit WhatsApp number" maxlength="10">
                            <i class="bi bi-whatsapp input-icon"></i>
                            <button type="button" class="btn-inline-action" id="btnCopyPhone">Same as Phone</button>
                        </div>
                        <div class="feedback-msg" id="msg-whatsappNumber"></div>
                    </div>

                    <!-- Bar Council Enrollment ID -->
                    <div class="form-group">
                        <label class="form-label" for="barCouncilId">Bar Council ID / Enrollment No. <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="barCouncilId" name="barCouncilId" class="form-input" value="${lawyer.barCouncilId}" placeholder="e.g. MAH/1234/2018 or D/567/2015" required style="text-transform: uppercase;">
                            <i class="bi bi-card-heading input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-barCouncilId"></div>
                    </div>

                    <!-- Years of Experience -->
                    <div class="form-group">
                        <label class="form-label" for="experienceYears">Years of Experience <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="number" id="experienceYears" name="experienceYears" class="form-input" value="${lawyer.experienceYears}" placeholder="e.g. 8" min="0" max="60" required>
                            <i class="bi bi-clock-history input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-experienceYears"></div>
                    </div>

                    <!-- Languages Spoken -->
                    <div class="form-group full">
                        <label class="form-label" for="languages">Languages Spoken <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="languages" name="languages" class="form-input" value="${lawyer.languages}" placeholder="e.g. English, Hindi, Marathi, Kannada" required>
                            <i class="bi bi-translate input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-languages"></div>
                    </div>

                    <!-- Profile Photo Upload -->
                    <div class="form-group full" style="border: 1px solid #FECDD3; background: #FFF5F7; border-radius: 14px; padding: 18px;">
                        <label class="form-label" style="color: var(--primary); font-weight: 800;">
                            <i class="bi bi-camera-fill"></i> Advocate Professional Headshot
                        </label>
                        <div style="display:flex; align-items:center; gap:18px; flex-wrap:wrap; margin-top:8px;">
                            <div style="position:relative; width:72px; height:72px; flex-shrink:0;">
                                <c:choose>
                                    <c:when test="${not empty lawyer.profilePhoto}">
                                        <img id="lawyerPhotoPreview" src="${pageContext.request.contextPath}${lawyer.profilePhoto}" 
                                             alt="Profile Photo" style="width:72px; height:72px; border-radius:16px; object-fit:cover; border:2px solid var(--primary);">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="lawyerPhotoPreview" src="" alt="Profile Photo" 
                                             style="display:none; width:72px; height:72px; border-radius:16px; object-fit:cover; border:2px solid var(--primary);">
                                        <div id="lawyerPhotoFallback" style="width:72px; height:72px; border-radius:16px; background:#FFE4E6; color:var(--primary); font-size:1.8rem; font-weight:800; display:flex; align-items:center; justify-content:center;">
                                            ${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex:1; min-width:220px;">
                                <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                    <label for="lawyerPhotoInput" style="background:var(--primary); color:white; padding:8px 16px; border-radius:10px; font-size:0.84rem; font-weight:700; cursor:pointer; display:inline-flex; align-items:center; gap:6px;">
                                        <i class="bi bi-upload"></i> Upload Photo
                                    </label>
                                    <input type="file" id="lawyerPhotoInput" name="profilePhoto" accept="image/*" style="display:none;" onchange="previewLawyerPhoto(this)">
                                    <button type="button" id="btnClearLawyerPhoto" onclick="clearLawyerPhoto()" style="display:none; background:white; border:1px solid var(--border); color:var(--secondary); padding:8px 14px; border-radius:10px; font-size:0.82rem; font-weight:600; cursor:pointer;">
                                        <i class="bi bi-x"></i> Clear
                                    </button>
                                </div>
                                <small style="display:block; margin-top:6px; font-size:0.77rem; color:var(--secondary);">JPG, PNG or WebP format. Maximum 5MB.</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION 2: SPECIALIZATIONS & BIO -->
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-step">2</span> Legal Expertise & Profile
                    </div>
                </div>
                <div class="form-grid">
                    <!-- Practice Areas -->
                    <div class="form-group full">
                        <label class="form-label" for="practiceAreas">Practice Areas / Specializations <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="practiceAreas" name="practiceAreas" class="form-input" value="${lawyer.practiceAreas}" placeholder="Click tags below or enter custom areas separated by comma" required>
                            <i class="bi bi-briefcase input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-practiceAreas"></div>
                        <div class="chips-container" id="practiceChips">
                            <span class="chip" data-val="Family & Matrimonial Law"><i class="bi bi-check2"></i> Family Law</span>
                            <span class="chip" data-val="Domestic Violence & POCSO"><i class="bi bi-check2"></i> Domestic Violence</span>
                            <span class="chip" data-val="Criminal Defense"><i class="bi bi-check2"></i> Criminal Law</span>
                            <span class="chip" data-val="Cyber Crime & IT Law"><i class="bi bi-check2"></i> Cyber Crime</span>
                            <span class="chip" data-val="Corporate & Commercial"><i class="bi bi-check2"></i> Corporate Law</span>
                            <span class="chip" data-val="Civil Litigation"><i class="bi bi-check2"></i> Civil Litigation</span>
                            <span class="chip" data-val="Property & Real Estate"><i class="bi bi-check2"></i> Property Law</span>
                            <span class="chip" data-val="Labour & Employment"><i class="bi bi-check2"></i> Labour Law</span>
                            <span class="chip" data-val="Constitutional & Writs"><i class="bi bi-check2"></i> Constitutional Law</span>
                            <span class="chip" data-val="Consumer Protection"><i class="bi bi-check2"></i> Consumer Rights</span>
                        </div>
                    </div>

                    <!-- Bio -->
                    <div class="form-group full">
                        <label class="form-label" for="bio">
                            <span>Bio / Professional Summary <span class="req">*</span></span>
                            <span class="char-counter" id="bioCounter">0 / min 25 chars</span>
                        </label>
                        <textarea id="bio" name="bio" class="form-input" rows="4" placeholder="Describe your legal experience, notable representations, courts of practice, and commitment to client justice..." required>${lawyer.bio}</textarea>
                        <div class="feedback-msg" id="msg-bio"></div>
                    </div>

                    <!-- Who they serve -->
                    <div class="form-group full">
                        <label class="form-label" for="audience">Client Focus / Target Audience</label>
                        <div class="input-wrapper">
                            <input type="text" id="audience" name="audience" class="form-input" value="${lawyer.audience}" placeholder="e.g. Women, Victims of Harassment, Working Professionals, Corporates">
                            <i class="bi bi-people input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-audience"></div>
                    </div>
                </div>

                <!-- SECTION 3: LOCATION & CHAMBER (Cascading Country -> State -> District via Free Geo API) -->
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-step">3</span> Chamber Address & Location
                    </div>
                    <span id="geoApiBadge" style="font-size:0.75rem; font-weight:700; color:var(--primary); background:#FFE4E6; border:1px solid #FECDD3; padding:4px 10px; border-radius:20px; display:inline-flex; align-items:center; gap:5px;">
                        <i class="bi bi-cloud-check-fill"></i> Free Geo API Connected
                    </span>
                </div>
                <div class="form-grid">
                    <!-- Chamber Address -->
                    <div class="form-group full">
                        <label class="form-label" for="address">Chamber / Office Address <span class="req">*</span></label>
                        <textarea id="address" name="address" class="form-input" rows="2" placeholder="Chamber/Office number, building name, street or court complex..." required>${lawyer.address}</textarea>
                        <div class="feedback-msg" id="msg-address"></div>
                    </div>

                    <!-- Country -->
                    <div class="form-group">
                        <label class="form-label" for="countrySelect">
                            <span>Country <span class="req">*</span></span>
                            <span id="countrySpinner" style="display:none; font-size:0.72rem; color:var(--primary); font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading countries...</span>
                        </label>
                        <div class="input-wrapper">
                            <select id="countrySelect" name="country" class="form-select" required>
                                <option value="India">India</option>
                                <option value="United States">United States</option>
                                <option value="United Kingdom">United Kingdom</option>
                                <option value="Canada">Canada</option>
                                <option value="Australia">Australia</option>
                                <option value="United Arab Emirates">United Arab Emirates</option>
                                <option value="Singapore">Singapore</option>
                                <option value="Other">Other</option>
                            </select>
                            <i class="bi bi-globe2 input-icon"></i>
                        </div>
                        <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting country updates state list from API</div>
                        <div class="feedback-msg" id="msg-country"></div>
                    </div>

                    <!-- State Dropdown -->
                    <div class="form-group">
                        <label class="form-label" for="stateSelect">
                            <span>State / UT <span class="req">*</span></span>
                            <span id="stateSpinner" style="display:none; font-size:0.72rem; color:var(--primary); font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading states...</span>
                        </label>
                        <div class="input-wrapper">
                            <select id="stateSelect" name="state" class="form-select" required>
                                <option value="">-- Select State --</option>
                            </select>
                            <i class="bi bi-geo-alt input-icon"></i>
                        </div>
                        <div class="cascade-info"><i class="bi bi-info-circle"></i> Selecting state updates district list from API</div>
                        <div class="feedback-msg" id="msg-state"></div>
                    </div>

                    <!-- District / City Dropdown -->
                    <div class="form-group">
                        <label class="form-label" for="districtSelect">
                            <span>District / City <span class="req">*</span></span>
                            <span id="districtSpinner" style="display:none; font-size:0.72rem; color:var(--primary); font-weight:600;"><i class="bi bi-arrow-repeat spin"></i> Loading districts...</span>
                        </label>
                        <div class="input-wrapper">
                            <select id="districtSelect" class="form-select" required>
                                <option value="">-- Select State First --</option>
                            </select>
                            <i class="bi bi-buildings input-icon"></i>
                        </div>
                        <div class="cascade-info"><i class="bi bi-check-circle"></i> Automatically filters to chosen state's districts via API</div>
                        <div class="feedback-msg" id="msg-city"></div>
                    </div>

                    <!-- Custom City Input (revealed when 'Other' is picked) -->
                    <div class="form-group" id="customCityGroup" style="display: none;">
                        <label class="form-label" for="customCityInput">Custom City / Taluk Name <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="customCityInput" class="form-input" placeholder="Type your city or town name">
                            <i class="bi bi-building-add input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-customCity"></div>
                    </div>

                    <!-- Hidden input to submit the finalized city name -->
                    <input type="hidden" id="cityInput" name="city" value="${lawyer.city}">

                    <!-- Pincode -->
                    <div class="form-group">
                        <label class="form-label" for="pincode">Postal Pincode <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="pincode" name="pincode" class="form-input" value="${lawyer.pincode}" placeholder="6-digit pincode" maxlength="6" required>
                            <i class="bi bi-pin-map input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-pincode"></div>
                    </div>

                    <!-- Chamber Facilities -->
                    <div class="form-group full">
                        <label class="form-label" for="facilities">Chamber Facilities & Infrastructure</label>
                        <div class="input-wrapper">
                            <input type="text" id="facilities" name="facilities" class="form-input" value="${lawyer.facilities}" placeholder="e.g. Private Consultation Room, Video Conference Facility, Waiting Lounge, Law Library">
                            <i class="bi bi-building-check input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-facilities"></div>
                    </div>
                </div>

                <!-- SECTION 4: SERVICE, TIMINGS & AVAILABILITY -->
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-step">4</span> Service Offerings & Availability
                    </div>
                </div>
                <div class="form-grid">
                    <!-- Operating Days -->
                    <div class="form-group">
                        <label class="form-label" for="openDays">Operating Days <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="openDays" name="openDays" class="form-input" value="${lawyer.openDays}" placeholder="e.g. Mon - Fri, Mon - Sat" required>
                            <i class="bi bi-calendar-week input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-openDays"></div>
                    </div>

                    <!-- Service Mode -->
                    <div class="form-group">
                        <label class="form-label" for="serviceMode">Service Mode <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <select id="serviceMode" name="serviceMode" class="form-select" required>
                                <option value="" ${empty lawyer.serviceMode ? 'selected' : ''}>-- Select Service Mode --</option>
                                <option value="Both" ${lawyer.serviceMode == 'Both' ? 'selected' : ''}>Both (Online & In-Person)</option>
                                <option value="Online" ${lawyer.serviceMode == 'Online' ? 'selected' : ''}>Online / Video Call Only</option>
                                <option value="Offline" ${lawyer.serviceMode == 'Offline' ? 'selected' : ''}>Offline / Chamber Only</option>
                            </select>
                            <i class="bi bi-broadcast input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-serviceMode"></div>
                    </div>

                    <!-- Consultation Duration Minutes (CRITICAL for ServiceProviderProfileService) -->
                    <div class="form-group">
                        <label class="form-label" for="durationMinutes">Consultation Duration <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <select id="durationMinutes" name="durationMinutes" class="form-select" required>
                                <option value="" ${empty lawyer.durationMinutes ? 'selected' : ''}>-- Select Duration --</option>
                                <option value="30" ${lawyer.durationMinutes == 30 ? 'selected' : ''}>30 Minutes</option>
                                <option value="45" ${lawyer.durationMinutes == 45 ? 'selected' : ''}>45 Minutes</option>
                                <option value="60" ${lawyer.durationMinutes == 60 ? 'selected' : ''}>60 Minutes (Standard)</option>
                                <option value="90" ${lawyer.durationMinutes == 90 ? 'selected' : ''}>90 Minutes</option>
                            </select>
                            <i class="bi bi-hourglass-split input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-durationMinutes"></div>
                    </div>

                    <!-- Consultation Mode Text -->
                    <div class="form-group">
                        <label class="form-label" for="consultationMode">Consultation Types <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" id="consultationMode" name="consultationMode" class="form-input" value="${lawyer.consultationMode}" placeholder="e.g. Video Call, In-Person Chamber, Telephonic" required>
                            <i class="bi bi-chat-dots input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-consultationMode"></div>
                    </div>

                    <!-- Open Time -->
                    <div class="form-group">
                        <label class="form-label" for="openTime">Chamber Open Time <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="time" id="openTime" name="openTime" class="form-input" value="${lawyer.openTime}" required>
                            <i class="bi bi-sunrise input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-openTime"></div>
                    </div>

                    <!-- Close Time -->
                    <div class="form-group">
                        <label class="form-label" for="closeTime">Chamber Close Time <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="time" id="closeTime" name="closeTime" class="form-input" value="${lawyer.closeTime}" required>
                            <i class="bi bi-sunset input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-closeTime"></div>
                    </div>
                </div>

                <!-- SECTION 5: FEES & BANK SETTLEMENT -->
                <div class="section-header">
                    <div class="section-title">
                        <span class="section-step">5</span> Consultation Fees & Payout Details
                    </div>
                </div>
                <div class="form-grid">
                    <!-- Consultation Fee -->
                    <div class="form-group">
                        <label class="form-label" for="consultationFee">Consultation Fee (₹) <span class="req">*</span></label>
                        <div class="input-wrapper">
                            <input type="number" id="consultationFee" name="consultationFee" class="form-input" value="${lawyer.consultationFee}" placeholder="Amount per session (0 for Free / Pro Bono)" min="0" required>
                            <i class="bi bi-currency-rupee input-icon"></i>
                        </div>
                        <small style="font-size:0.75rem; color:var(--secondary); margin-top:2px;">Enter 0 for pro bono legal aid.</small>
                        <div class="feedback-msg" id="msg-consultationFee"></div>
                    </div>

                    <!-- UPI ID -->
                    <div class="form-group">
                        <label class="form-label" for="upiId">Official UPI ID</label>
                        <div class="input-wrapper">
                            <input type="text" id="upiId" name="upiId" class="form-input" value="${lawyer.upiId}" placeholder="e.g. advocate@oksbi or priya@upi">
                            <i class="bi bi-qr-code input-icon"></i>
                        </div>
                        <div class="feedback-msg" id="msg-upiId"></div>
                    </div>

                    <!-- Bank Details Sub-Box -->
                    <div class="bank-box">
                        <div class="bank-box-title">
                            <i class="bi bi-bank2" style="color:var(--primary); font-size:1.1rem;"></i> Bank Account Details (for Client Booking Payouts)
                        </div>

                        <!-- Account Holder -->
                        <div class="form-group">
                            <label class="form-label" for="bankAccountHolder">Account Holder Name <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per bank passbook" required>
                                <i class="bi bi-person-badge input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-bankAccountHolder"></div>
                        </div>

                        <!-- Bank Name -->
                        <div class="form-group">
                            <label class="form-label" for="bankName">Bank Name <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. State Bank of India, HDFC Bank" required>
                                <i class="bi bi-building input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-bankName"></div>
                        </div>

                        <!-- Account Number -->
                        <div class="form-group">
                            <label class="form-label" for="bankAccountNumber">Account Number <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="password" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Enter bank account number" maxlength="18" required>
                                <i class="bi bi-123 input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-bankAccountNumber"></div>
                        </div>

                        <!-- Confirm Account Number -->
                        <div class="form-group">
                            <label class="form-label" for="confirmAccountNumber">Re-enter Account Number <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Confirm account number" maxlength="18" required>
                                <i class="bi bi-check2-circle input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-confirmAccountNumber"></div>
                        </div>

                        <!-- IFSC Code -->
                        <div class="form-group">
                            <label class="form-label" for="bankIfsc">IFSC Code <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. SBIN0001234" maxlength="11" style="text-transform: uppercase;" required>
                                <i class="bi bi-hash input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-bankIfsc"></div>
                        </div>

                        <!-- Branch Name -->
                        <div class="form-group">
                            <label class="form-label" for="bankBranch">Branch Name <span class="req">*</span></label>
                            <div class="input-wrapper">
                                <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. High Court Branch" required>
                                <i class="bi bi-geo input-icon"></i>
                            </div>
                            <div class="feedback-msg" id="msg-bankBranch"></div>
                        </div>
                    </div>

                    <!-- Hidden bankDetails serialized string for backward compatibility -->
                    <input type="hidden" id="bankDetails" name="bankDetails" value="${lawyer.bankDetails}">
                </div>

                <div style="margin-top: 36px; display: flex; justify-content: flex-end; gap: 14px;">
                    <button type="submit" class="btn-save" id="btnSaveBottom" style="padding: 14px 32px; font-size: 1rem;">
                        <i class="bi bi-shield-lock-fill"></i> Save & Continue
                    </button>
                </div>
            </div>

            <!-- Right Preview Section -->
            <div class="preview-section">
                <div class="preview-card">
                    <div class="preview-header">
                        <div class="live-badge"><span class="live-dot"></span> LIVE PREVIEW</div>
                        <span class="preview-header-title">PUBLIC CLIENT VIEW</span>
                    </div>
                    <div class="preview-body">
                        <div class="prev-avatar-wrap">
                            <div class="prev-avatar" id="prevAvatarBox">
                                <c:choose>
                                    <c:when test="${not empty lawyer.profilePhoto}">
                                        <img id="prevPhotoImg" src="${pageContext.request.contextPath}${lawyer.profilePhoto}" alt="Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <span id="prevInitials">${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1).toUpperCase()}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="prev-name">
                            <span id="prevName">${empty lawyer.fullName ? 'Advocate Name' : lawyer.fullName}</span>
                            <i class="bi bi-patch-check-fill" title="Verified Advocate Profile"></i>
                        </div>
                        <div class="prev-designation" id="prevRole">${empty lawyer.designation ? 'Advocate' : lawyer.designation}</div>
                        <div class="prev-bar-id" id="prevBarId"><i class="bi bi-card-text"></i> ${empty lawyer.barCouncilId ? 'BAR-ID: PENDING' : lawyer.barCouncilId}</div>
                        
                        <div class="prev-location">
                            <i class="bi bi-geo-alt-fill" style="color:var(--primary);"></i>
                            <span id="prevCity">${empty lawyer.city ? 'City' : lawyer.city}</span>, 
                            <span id="prevState">${empty lawyer.state ? 'State' : lawyer.state}</span>
                        </div>

                        <div class="prev-stats-grid">
                            <div class="prev-stat-box">
                                <div class="prev-stat-label">Consultation Fee</div>
                                <div class="prev-stat-val" id="prevFee">₹${lawyer.consultationFee != null ? lawyer.consultationFee : '1000'}</div>
                            </div>
                            <div class="prev-stat-box">
                                <div class="prev-stat-label">Session Duration</div>
                                <div class="prev-stat-val" id="prevDuration">${lawyer.durationMinutes != null ? lawyer.durationMinutes : '60'} mins</div>
                            </div>
                            <div class="prev-stat-box">
                                <div class="prev-stat-label">Experience</div>
                                <div class="prev-stat-val" id="prevExp">${lawyer.experienceYears != null ? lawyer.experienceYears : '0'} Years</div>
                            </div>
                            <div class="prev-stat-box">
                                <div class="prev-stat-label">Service Mode</div>
                                <div class="prev-stat-val" id="prevMode">${not empty lawyer.serviceMode ? lawyer.serviceMode : 'Both'}</div>
                            </div>
                        </div>

                        <div class="prev-section-label">Practice Areas</div>
                        <div class="prev-tags" id="prevPractice">
                            <div class="prev-tag">Family Law</div>
                            <div class="prev-tag">Domestic Violence</div>
                        </div>

                        <div class="prev-section-label">About Advocate</div>
                        <div class="prev-bio" id="prevBio">
                            ${empty lawyer.bio ? 'Dedicated legal counsel providing fearless advocacy, rights awareness, and compassionate support.' : lawyer.bio}
                        </div>

                        <div class="prev-footer">
                            <i class="bi bi-shield-shaded"></i> Verified Advocate Network • Fight D Fear
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- LOCATION DATA: Comprehensive Country -> State -> Districts Dataset -->
    <script>
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
                "Dadra and Nagar Haveli and Daman and Diu": ["Daman", "Diu", "Silvassa (Dadra and Nagar Haveli)", "Other"],
                "Delhi": ["Central Delhi", "East Delhi", "New Delhi", "North Delhi", "North East Delhi", "North West Delhi", "Shahdara", "South Delhi", "South East Delhi", "South West Delhi", "West Delhi", "Other"],
                "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Kathua", "Udhampur", "Budgam", "Pulwama", "Kupwara", "Poonch", "Rajouri", "Other"],
                "Ladakh": ["Leh", "Kargil", "Other"],
                "Lakshadweep": ["Kavaratti", "Agatti", "Andrott", "Minicoy", "Other"],
                "Puducherry": ["Puducherry", "Karaikal", "Mahe", "Yanam", "Other"]
            },
            "United States": {
                "California": ["Los Angeles", "San Francisco", "San Diego", "San Jose", "Other"],
                "New York": ["New York City", "Buffalo", "Rochester", "Albany", "Other"],
                "Texas": ["Houston", "Austin", "Dallas", "San Antonio", "Other"],
                "Florida": ["Miami", "Orlando", "Tampa", "Jacksonville", "Other"],
                "Other State": ["City / District", "Other"]
            },
            "United Kingdom": {
                "England": ["London", "Manchester", "Birmingham", "Leeds", "Other"],
                "Scotland": ["Edinburgh", "Glasgow", "Aberdeen", "Other"],
                "Wales": ["Cardiff", "Swansea", "Other"],
                "Northern Ireland": ["Belfast", "Derry", "Other"]
            },
            "Canada": {
                "Ontario": ["Toronto", "Ottawa", "Mississauga", "Other"],
                "British Columbia": ["Vancouver", "Victoria", "Surrey", "Other"],
                "Quebec": ["Montreal", "Quebec City", "Other"],
                "Alberta": ["Calgary", "Edmonton", "Other"]
            },
            "Australia": {
                "New South Wales": ["Sydney", "Newcastle", "Wollongong", "Other"],
                "Victoria": ["Melbourne", "Geelong", "Ballarat", "Other"],
                "Queensland": ["Brisbane", "Gold Coast", "Other"],
                "Western Australia": ["Perth", "Fremantle", "Other"]
            },
            "United Arab Emirates": {
                "Emirates": ["Dubai", "Abu Dhabi", "Sharjah", "Ajman", "Ras Al Khaimah", "Fujairah", "Umm Al Quwain"]
            },
            "Singapore": {
                "Singapore": ["Central Region", "East Region", "North Region", "North-East Region", "West Region"]
            },
            "Other": {
                "International Region": ["General Region / City", "Other"]
            }
        };

        // Existing Values from Backend
        const savedCountry = "${not empty lawyer.country ? lawyer.country : 'India'}";
        const savedState = "${not empty lawyer.state ? lawyer.state : ''}";
        const savedCity = "${not empty lawyer.city ? lawyer.city : ''}";

        // Free Geo API configuration (CountriesNow - https://countriesnow.space)
        const GEO_API_BASE = 'https://countriesnow.space/api/v0.1';

        // In-memory cache to prevent redundant network calls
        const geoApiCache = {
            countries: null,
            states: {},
            cities: {}
        };

        // Initialize Cascading Dropdowns with Live API + Instant Fallback
        function initLocationSelectors() {
            const countrySelect = document.getElementById('countrySelect');
            const stateSelect = document.getElementById('stateSelect');
            const districtSelect = document.getElementById('districtSelect');
            const customCityGroup = document.getElementById('customCityGroup');
            const customCityInput = document.getElementById('customCityInput');
            const cityInput = document.getElementById('cityInput');

            const countrySpinner = document.getElementById('countrySpinner');
            const stateSpinner = document.getElementById('stateSpinner');
            const districtSpinner = document.getElementById('districtSpinner');

            // 1. Pre-select saved country
            if (savedCountry) {
                countrySelect.value = savedCountry;
            }

            // Fetch all world countries from Free API in the background
            function loadWorldCountriesApi() {
                if (countrySpinner) countrySpinner.style.display = 'inline-block';
                fetch(GEO_API_BASE + '/countries/info?returns=none')
                    .then(r => r.json())
                    .then(res => {
                        if (countrySpinner) countrySpinner.style.display = 'none';
                        if (res && !res.error && Array.isArray(res.data) && res.data.length > 0) {
                            const apiCountries = res.data.map(c => c.name).filter(Boolean);
                            const currentVal = countrySelect.value || savedCountry || 'India';
                            
                            // Rebuild country options: India on top, then alphabetical
                            const allSet = new Set(['India', 'United States', 'United Kingdom', 'Canada', 'Australia', 'United Arab Emirates', 'Singapore', ...apiCountries]);
                            const sortedList = Array.from(allSet).filter(c => c !== 'India' && c !== 'Other').sort();

                            countrySelect.innerHTML = '<option value="India">India</option>';
                            sortedList.forEach(c => {
                                const opt = document.createElement('option');
                                opt.value = c;
                                opt.textContent = c;
                                if (c === currentVal) opt.selected = true;
                                countrySelect.appendChild(opt);
                            });
                            const otherOpt = document.createElement('option');
                            otherOpt.value = 'Other';
                            otherOpt.textContent = 'Other Country';
                            if (currentVal === 'Other') otherOpt.selected = true;
                            countrySelect.appendChild(otherOpt);
                        }
                    })
                    .catch(err => {
                        if (countrySpinner) countrySpinner.style.display = 'none';
                        console.warn("Geo API country load fallback to local:", err);
                    });
            }

            // Populate States: First local instant render, then live API enhancement
            function populateStates(country, selectedState = "") {
                stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';

                // Instant local dataset
                const localStatesObj = locationData[country] || locationData["Other"] || {};
                const localStateNames = Object.keys(localStatesObj).sort();

                localStateNames.forEach(st => {
                    const opt = document.createElement('option');
                    opt.value = st;
                    opt.textContent = st;
                    if (st === selectedState) opt.selected = true;
                    stateSelect.appendChild(opt);
                });

                if (selectedState && stateSelect.value === selectedState) {
                    populateDistricts(country, selectedState, savedCity);
                } else {
                    districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    customCityGroup.style.display = 'none';
                }

                // If not India, fetch additional provinces from Live Free API
                if (country !== "India") {
                    if (geoApiCache.states[country]) {
                        renderStateOptions(geoApiCache.states[country], selectedState || stateSelect.value);
                        return;
                    }

                    if (stateSpinner) stateSpinner.style.display = 'inline-block';
                    fetch(GEO_API_BASE + '/countries/states', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ country: country })
                    })
                    .then(r => r.json())
                    .then(res => {
                        if (stateSpinner) stateSpinner.style.display = 'none';
                        if (res && !res.error && res.data && Array.isArray(res.data.states) && res.data.states.length > 0) {
                            const apiStates = res.data.states.map(s => s.name).filter(Boolean);
                            const merged = Array.from(new Set([...localStateNames, ...apiStates])).sort();
                            geoApiCache.states[country] = merged;
                            renderStateOptions(merged, selectedState || stateSelect.value);
                        }
                    })
                    .catch(err => {
                        if (stateSpinner) stateSpinner.style.display = 'none';
                        console.warn("Geo API state fetch fallback:", err);
                    });
                }
            }

            function renderStateOptions(stateList, activeState) {
                const cur = activeState || stateSelect.value;
                stateSelect.innerHTML = '<option value="">-- Select State / UT --</option>';
                stateList.forEach(st => {
                    const opt = document.createElement('option');
                    opt.value = st;
                    opt.textContent = st;
                    if (st === cur) opt.selected = true;
                    stateSelect.appendChild(opt);
                });
                if (cur && stateSelect.value === cur) {
                    populateDistricts(countrySelect.value, cur, savedCity || districtSelect.value);
                }
            }

            // Populate Districts: First local instant render, then live API enhancement
            function populateDistricts(country, state, selectedDistrict = "") {
                districtSelect.innerHTML = '<option value="">-- Select District / City --</option>';

                if (!state) {
                    districtSelect.innerHTML = '<option value="">-- Select State First --</option>';
                    customCityGroup.style.display = 'none';
                    return;
                }

                // Instant local dataset
                const statesObj = locationData[country] || locationData["Other"] || {};
                const localDistricts = statesObj[state] || ["Other"];

                renderDistrictOptions(localDistricts, selectedDistrict);

                const cacheKey = country + '__' + state;
                if (geoApiCache.cities[cacheKey]) {
                    renderDistrictOptions(geoApiCache.cities[cacheKey], selectedDistrict || districtSelect.value);
                    return;
                }

                // Fetch from Live Free API in background to enrich districts/cities
                if (districtSpinner) districtSpinner.style.display = 'inline-block';
                fetch(GEO_API_BASE + '/countries/state/cities', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ country: country, state: state })
                })
                .then(r => r.json())
                .then(res => {
                    if (districtSpinner) districtSpinner.style.display = 'none';
                    if (res && !res.error && Array.isArray(res.data) && res.data.length > 0) {
                        const apiCities = res.data.filter(Boolean);
                        const merged = Array.from(new Set([...localDistricts.filter(d => d !== "Other"), ...apiCities])).sort();
                        merged.push("Other");
                        geoApiCache.cities[cacheKey] = merged;
                        renderDistrictOptions(merged, selectedDistrict || districtSelect.value);
                    }
                })
                .catch(err => {
                    if (districtSpinner) districtSpinner.style.display = 'none';
                    console.warn("Geo API city fetch fallback:", err);
                });
            }

            function renderDistrictOptions(districtList, activeDistrict) {
                const cur = activeDistrict || districtSelect.value || savedCity;
                districtSelect.innerHTML = '<option value="">-- Select District / City --</option>';
                let matched = false;

                districtList.forEach(dist => {
                    const opt = document.createElement('option');
                    opt.value = dist;
                    opt.textContent = dist;
                    if (cur && dist.toLowerCase() === cur.toLowerCase()) {
                        opt.selected = true;
                        matched = true;
                    }
                    districtSelect.appendChild(opt);
                });

                if (cur && !matched && cur !== "Other") {
                    districtSelect.value = "Other";
                    customCityGroup.style.display = 'block';
                    customCityInput.value = cur;
                    cityInput.value = cur;
                } else if (districtSelect.value === "Other") {
                    customCityGroup.style.display = 'block';
                    cityInput.value = customCityInput.value.trim();
                } else {
                    customCityGroup.style.display = 'none';
                    cityInput.value = districtSelect.value;
                }
            }

            // Country change listener
            countrySelect.addEventListener('change', () => {
                populateStates(countrySelect.value, "");
                validateField('countrySelect');
                validateField('stateSelect');
                validateField('districtSelect');
                updateLocationPreview();
            });

            // State change listener
            stateSelect.addEventListener('change', () => {
                populateDistricts(countrySelect.value, stateSelect.value, "");
                validateField('stateSelect');
                validateField('districtSelect');
                updateLocationPreview();
            });

            // District change listener
            districtSelect.addEventListener('change', () => {
                if (districtSelect.value === "Other") {
                    customCityGroup.style.display = 'block';
                    customCityInput.focus();
                    cityInput.value = customCityInput.value.trim();
                } else {
                    customCityGroup.style.display = 'none';
                    cityInput.value = districtSelect.value;
                }
                validateField('districtSelect');
                updateLocationPreview();
            });

            // Custom City input listener
            customCityInput.addEventListener('input', () => {
                cityInput.value = customCityInput.value.trim();
                validateField('districtSelect');
                updateLocationPreview();
            });

            // Initial setup & start background API population
            populateStates(countrySelect.value || savedCountry || "India", savedState);
            loadWorldCountriesApi();
        }

        function updateLocationPreview() {
            const state = document.getElementById('stateSelect')?.value || '';
            const city = document.getElementById('cityInput')?.value || '';
            const prevCity = document.getElementById('prevCity');
            const prevState = document.getElementById('prevState');
            if (prevCity) prevCity.textContent = city || 'City';
            if (prevState) prevState.textContent = state || 'State';
        }

        // ==========================================
        // REAL-TIME VALIDATION RULES & ENGINE
        // ==========================================
        const validationRules = {
            fullName: {
                req: true,
                validate: v => /^[a-zA-Z\s.']{2,70}$/.test(v.trim()),
                msg: "Full name must be 2-70 alphabetic characters (e.g. Adv. Priya Sharma)."
            },
            phone: {
                req: true,
                validate: v => /^[6-9]\d{9}$/.test(v.trim()),
                msg: "Please enter a valid 10-digit Indian mobile number starting with 6-9."
            },
            whatsappNumber: {
                req: false,
                validate: v => !v || /^[6-9]\d{9}$/.test(v.trim()),
                msg: "WhatsApp number must be a valid 10-digit mobile number."
            },
            barCouncilId: {
                req: true,
                validate: v => /^[a-zA-Z0-9/\-]{4,30}$/.test(v.trim()),
                msg: "Enter a valid Bar Council Enrollment ID (e.g. MAH/1234/2018 or D/567/2015)."
            },
            experienceYears: {
                req: true,
                validate: v => v !== "" && !isNaN(v) && Number(v) >= 0 && Number(v) <= 60,
                msg: "Years of experience must be between 0 and 60."
            },
            languages: {
                req: true,
                validate: v => v.trim().length >= 2,
                msg: "Please enter at least one language you practice in (e.g. English, Hindi)."
            },
            practiceAreas: {
                req: true,
                validate: v => v.trim().length >= 3,
                msg: "Select or type at least one practice area / specialization."
            },
            bio: {
                req: true,
                validate: v => v.trim().length >= 25,
                msg: "Bio must be at least 25 characters detailing your legal experience."
            },
            address: {
                req: true,
                validate: v => v.trim().length >= 5,
                msg: "Chamber address must be at least 5 characters."
            },
            countrySelect: {
                req: true,
                validate: v => !!v && v.trim() !== "",
                msg: "Please select your country."
            },
            stateSelect: {
                req: true,
                validate: v => !!v && v.trim() !== "",
                msg: "Please select your state."
            },
            districtSelect: {
                req: true,
                validate: () => {
                    const dist = document.getElementById('districtSelect')?.value || '';
                    if (!dist) return false;
                    if (dist === "Other") {
                        const custom = document.getElementById('customCityInput')?.value.trim() || '';
                        return custom.length >= 2;
                    }
                    return true;
                },
                msg: "Please select or type your district / city."
            },
            pincode: {
                req: true,
                validate: v => /^\d{6}$/.test(v.trim()),
                msg: "Pincode must be exactly 6 numeric digits (e.g. 400001)."
            },
            openDays: {
                req: true,
                validate: v => v.trim().length >= 3,
                msg: "Please specify operating days (e.g. Mon - Sat)."
            },
            serviceMode: {
                req: true,
                validate: v => !!v && v.trim() !== "",
                msg: "Please select a service mode."
            },
            durationMinutes: {
                req: true,
                validate: v => !!v && !isNaN(v) && Number(v) > 0,
                msg: "Please select consultation duration."
            },
            consultationMode: {
                req: true,
                validate: v => v.trim().length >= 2,
                msg: "Please enter consultation modes offered."
            },
            openTime: {
                req: true,
                validate: v => !!v && v.trim() !== "",
                msg: "Please provide chamber opening time."
            },
            closeTime: {
                req: true,
                validate: v => {
                    const open = document.getElementById('openTime')?.value || '';
                    if (!v) return false;
                    if (open && v <= open) return false;
                    return true;
                },
                msg: "Close time must be after open time."
            },
            consultationFee: {
                req: true,
                validate: v => v !== "" && !isNaN(v) && Number(v) >= 0,
                msg: "Fee must be 0 (for Pro Bono) or a positive amount in Rupees."
            },
            upiId: {
                req: false,
                validate: v => !v || /^[\w.\-_]{2,}@[a-zA-Z]{2,}$/.test(v.trim()),
                msg: "Invalid UPI ID format (e.g. name@okhdfcbank or advocate@upi)."
            },
            bankAccountHolder: {
                req: true,
                validate: v => /^[a-zA-Z\s.']{2,70}$/.test(v.trim()),
                msg: "Account holder name must be 2-70 alphabetic characters."
            },
            bankName: {
                req: true,
                validate: v => v.trim().length >= 2,
                msg: "Please enter a valid bank name (e.g. State Bank of India)."
            },
            bankAccountNumber: {
                req: true,
                validate: v => /^\d{9,18}$/.test(v.trim()),
                msg: "Bank account number must be between 9 and 18 digits."
            },
            confirmAccountNumber: {
                req: true,
                validate: v => {
                    const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
                    return v.trim() !== "" && v.trim() === acc;
                },
                msg: "Account numbers do not match."
            },
            bankIfsc: {
                req: true,
                validate: v => /^[A-Z]{4}0[A-Z0-9]{6}$/.test(v.trim().toUpperCase()),
                msg: "Invalid IFSC format (e.g. SBIN0001234 - 4 letters, 0, then 6 chars)."
            },
            bankBranch: {
                req: true,
                validate: v => v.trim().length >= 2,
                msg: "Please enter your bank branch name."
            }
        };

        function validateField(fieldId) {
            const el = document.getElementById(fieldId);
            const rule = validationRules[fieldId];
            if (!el || !rule) return true;

            const val = el.value || '';
            const msgEl = document.getElementById('msg-' + (fieldId === 'countrySelect' ? 'country' : (fieldId === 'stateSelect' ? 'state' : (fieldId === 'districtSelect' ? 'city' : fieldId))));
            
            const isValid = rule.validate(val);

            if (isValid) {
                el.classList.remove('is-invalid');
                el.classList.add('is-valid');
                if (msgEl) {
                    msgEl.className = 'feedback-msg valid';
                    msgEl.innerHTML = '<i class="bi bi-check-circle-fill"></i> Looks good!';
                }
                return true;
            } else {
                // If it's optional and blank, clear both classes
                if (!rule.req && !val.trim()) {
                    el.classList.remove('is-invalid', 'is-valid');
                    if (msgEl) msgEl.style.display = 'none';
                    return true;
                }
                el.classList.remove('is-valid');
                el.classList.add('is-invalid');
                if (msgEl) {
                    msgEl.className = 'feedback-msg invalid';
                    msgEl.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + rule.msg;
                }
                return false;
            }
        }

        // Validate all and collect errors for the Summary Alert
        function validateAllFields() {
            const errors = [];
            const fieldsToValidate = Object.keys(validationRules);

            fieldsToValidate.forEach(fieldId => {
                const el = document.getElementById(fieldId);
                const rule = validationRules[fieldId];
                if (!el || !rule) return;

                const isValid = validateField(fieldId);
                if (!isValid) {
                    let labelText = el.closest('.form-group')?.querySelector('.form-label')?.innerText?.replace('*', '').trim() || fieldId;
                    if (labelText.includes('\n')) labelText = labelText.split('\n')[0].trim();
                    errors.push({
                        fieldId: fieldId,
                        label: labelText,
                        msg: rule.msg
                    });
                }
            });

            return errors;
        }

        function displayAlertSummary(errors) {
            const summaryBox = document.getElementById('alertSummary');
            const summaryList = document.getElementById('alertSummaryList');
            const summaryTitle = document.getElementById('alertSummaryTitle');

            if (!summaryBox || !summaryList) return;

            if (errors.length === 0) {
                summaryBox.style.display = 'none';
                return;
            }

            summaryTitle.textContent = "Please resolve the following " + errors.length + " missing / invalid field(s) to continue:";
            summaryList.innerHTML = '';

            errors.forEach(err => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="bi bi-arrow-right-circle-fill"></i> <strong>' + err.label + ':</strong> ' + err.msg;
                li.onclick = () => {
                    const targetEl = document.getElementById(err.fieldId);
                    if (targetEl) {
                        targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        targetEl.focus();
                        targetEl.classList.add('pulse-highlight');
                        setTimeout(() => targetEl.classList.remove('pulse-highlight'), 1600);
                    }
                };
                summaryList.appendChild(li);
            });

            summaryBox.style.display = 'block';
            summaryBox.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        // ==========================================
        // PHOTO PREVIEW & PARSING BANK DETAILS
        // ==========================================
        function previewLawyerPhoto(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('lawyerPhotoPreview');
                    const fallback = document.getElementById('lawyerPhotoFallback');
                    const btnClear = document.getElementById('btnClearLawyerPhoto');
                    if (preview) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    if (fallback) fallback.style.display = 'none';
                    if (btnClear) btnClear.style.display = 'inline-block';

                    const prevAvatar = document.getElementById('prevAvatarBox');
                    if (prevAvatar) {
                        prevAvatar.innerHTML = '<img src="' + e.target.result + '" alt="Avatar" style="width:100%; height:100%; object-fit:cover;">';
                    }
                    calculateCompletion();
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function clearLawyerPhoto() {
            const input = document.getElementById('lawyerPhotoInput');
            const preview = document.getElementById('lawyerPhotoPreview');
            const fallback = document.getElementById('lawyerPhotoFallback');
            const btnClear = document.getElementById('btnClearLawyerPhoto');
            if (input) input.value = '';
            if (btnClear) btnClear.style.display = 'none';

            if ("${lawyer.profilePhoto}" !== "") {
                if (preview) {
                    preview.src = "${pageContext.request.contextPath}${lawyer.profilePhoto}";
                    preview.style.display = 'block';
                }
            } else {
                if (preview) preview.style.display = 'none';
                if (fallback) fallback.style.display = 'flex';
                const prevAvatar = document.getElementById('prevAvatarBox');
                if (prevAvatar) {
                    const initial = "${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1).toUpperCase()}";
                    prevAvatar.innerHTML = '<span id="prevInitials">' + initial + '</span>';
                }
            }
            calculateCompletion();
        }

        function parseExistingBankDetails() {
            const raw = (document.getElementById('bankDetails')?.value || '').trim();
            if (!raw) return;

            if (raw.includes('|')) {
                const parts = raw.split('|').map(s => s.trim());
                parts.forEach(part => {
                    const lower = part.toLowerCase();
                    if (lower.startsWith('account holder:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankAccountHolder');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('bank:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankName');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('a/c:') || lower.startsWith('account:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankAccountNumber');
                        const cel = document.getElementById('confirmAccountNumber');
                        if (el && !el.value) el.value = val;
                        if (cel && !cel.value) cel.value = val;
                    } else if (lower.startsWith('ifsc:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankIfsc');
                        if (el && !el.value) el.value = val;
                    } else if (lower.startsWith('branch:')) {
                        const val = part.substring(part.indexOf(':') + 1).trim();
                        const el = document.getElementById('bankBranch');
                        if (el && !el.value) el.value = val;
                    }
                });
            } else {
                const holder = document.getElementById('bankAccountHolder');
                if (holder && !holder.value) holder.value = raw;
            }
        }

        function syncBankDetails() {
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '';
            const bName = document.getElementById('bankName')?.value.trim() || '';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '';

            const ifscInput = document.getElementById('bankIfsc');
            if (ifscInput && ifscInput.value !== ifsc) ifscInput.value = ifsc;

            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                }
            }
        }

        // ==========================================
        // PRACTICE AREAS CHIPS & LIVE PREVIEWS
        // ==========================================
        function initPracticeChips() {
            const input = document.getElementById('practiceAreas');
            const chips = document.querySelectorAll('#practiceChips .chip');

            function syncActiveChips() {
                const currentAreas = (input.value || '').split(',').map(s => s.trim().toLowerCase());
                chips.forEach(chip => {
                    const val = chip.getAttribute('data-val').toLowerCase();
                    if (currentAreas.includes(val)) {
                        chip.classList.add('active');
                    } else {
                        chip.classList.remove('active');
                    }
                });
                updateTagsPreview(input.value);
            }

            chips.forEach(chip => {
                chip.addEventListener('click', () => {
                    const val = chip.getAttribute('data-val');
                    let current = (input.value || '').split(',').map(s => s.trim()).filter(Boolean);
                    const idx = current.findIndex(item => item.toLowerCase() === val.toLowerCase());
                    if (idx >= 0) {
                        current.splice(idx, 1);
                    } else {
                        current.push(val);
                    }
                    input.value = current.join(', ');
                    syncActiveChips();
                    validateField('practiceAreas');
                    calculateCompletion();
                });
            });

            input.addEventListener('input', () => {
                syncActiveChips();
                validateField('practiceAreas');
            });

            syncActiveChips();
        }

        function updateTagsPreview(val) {
            const container = document.getElementById('prevPractice');
            if (!container) return;
            container.innerHTML = '';
            if (!val || !val.trim()) {
                container.innerHTML = '<div class="prev-tag">Family Law</div><div class="prev-tag">Domestic Violence</div>';
                return;
            }
            const parts = val.split(',').map(s => s.trim()).filter(Boolean);
            parts.forEach(p => {
                const div = document.createElement('div');
                div.className = 'prev-tag';
                div.textContent = p;
                container.appendChild(div);
            });
        }

        // Bio counter
        function initBioCounter() {
            const bioInput = document.getElementById('bio');
            const counter = document.getElementById('bioCounter');
            const prevBio = document.getElementById('prevBio');

            function update() {
                const len = (bioInput.value || '').trim().length;
                counter.textContent = len + " / min 25 chars";
                if (len >= 25) {
                    counter.style.color = "var(--success)";
                } else {
                    counter.style.color = "var(--secondary)";
                }
                if (prevBio) {
                    prevBio.textContent = bioInput.value.trim() || 'Dedicated legal counsel providing fearless advocacy, rights awareness, and compassionate support.';
                }
            }

            bioInput.addEventListener('input', update);
            update();
        }

        // ==========================================
        // PROGRESS & COMPLETION CALCULATOR (20 Milestones @ 5% each = 100%)
        // ==========================================
        function calculateCompletion() {
            let score = 0;

            // 1. Full Name
            const name = (document.getElementById('fullName')?.value || '').trim();
            if (name.length > 0) score += 5;

            // 2. Designation
            const desig = (document.getElementById('designation')?.value || '').trim();
            if (desig.length > 0) score += 5;

            // 3. Official Phone (10 digits)
            const phone = (document.getElementById('phone')?.value || '').trim();
            if (/^\d{10}$/.test(phone)) score += 5;

            // 4. WhatsApp Number
            const wa = (document.getElementById('whatsappNumber')?.value || '').trim();
            if (wa.length > 0) score += 5;

            // 5. Bar Council ID
            const barId = (document.getElementById('barCouncilId')?.value || '').trim();
            if (barId.length > 0) score += 5;

            // 6. Experience Years
            const exp = document.getElementById('experienceYears')?.value;
            if (exp !== '' && exp !== null && parseInt(exp, 10) >= 0) score += 5;

            // 7. Languages
            const lang = (document.getElementById('languages')?.value || '').trim();
            if (lang.length > 0) score += 5;

            // 8. Headshot Photo
            const hasPhoto = "${not empty lawyer.profilePhoto and lawyer.profilePhoto != 'web-pending' and lawyer.profilePhoto != 'mobile-pending'}" === "true" || (document.getElementById('lawyerPhotoInput')?.files?.length > 0);
            if (hasPhoto) score += 5;

            // 9. Practice Areas
            const practice = (document.getElementById('practiceAreas')?.value || '').trim();
            if (practice.length > 0) score += 5;

            // 10. Bio (at least 25 characters)
            const bio = (document.getElementById('bio')?.value || '').trim();
            if (bio.length >= 25) score += 5;

            // 11. Client focus / Audience
            const aud = (document.getElementById('audience')?.value || '').trim();
            if (aud.length > 0) score += 5;

            // 12. Address
            const addr = (document.getElementById('address')?.value || '').trim();
            if (addr.length > 0) score += 5;

            // 13. State
            const state = (document.getElementById('stateSelect')?.value || '').trim();
            if (state.length > 0) score += 5;

            // 14. City / District
            const dist = (document.getElementById('districtSelect')?.value || '').trim();
            const customCity = (document.getElementById('customCityInput')?.value || '').trim();
            const cityHidden = (document.getElementById('cityInput')?.value || '').trim();
            if ((dist && dist !== 'Other') || (dist === 'Other' && customCity) || cityHidden) score += 5;

            // 15. Pincode (6 digits)
            const pin = (document.getElementById('pincode')?.value || '').trim();
            if (/^\d{6}$/.test(pin)) score += 5;

            // 16. Open Days
            const days = (document.getElementById('openDays')?.value || '').trim();
            if (days.length > 0) score += 5;

            // 17. Operating Hours (Open & Close Time)
            const openT = (document.getElementById('openTime')?.value || '').trim();
            const closeT = (document.getElementById('closeTime')?.value || '').trim();
            if (openT.length > 0 && closeT.length > 0) score += 5;

            // 18. Service Mode & Duration
            const mode = (document.getElementById('serviceMode')?.value || '').trim();
            const dur = (document.getElementById('durationMinutes')?.value || '').trim();
            if (mode.length > 0 && dur.length > 0) score += 5;

            // 19. Consultation Fee & Mode
            const fee = document.getElementById('consultationFee')?.value;
            const cMode = (document.getElementById('consultationMode')?.value || '').trim();
            if (fee !== '' && fee !== null && parseFloat(fee) >= 0 && cMode.length > 0) score += 5;

            // 20. Bank Details or UPI ID
            const acc = (document.getElementById('bankAccountNumber')?.value || '').trim();
            const ifsc = (document.getElementById('bankIfsc')?.value || '').trim();
            const upi = (document.getElementById('upiId')?.value || '').trim();
            const bankRaw = (document.getElementById('bankDetails')?.value || '').trim();
            if ((acc.length >= 8 && ifsc.length >= 4) || upi.length > 0 || bankRaw.length > 0) score += 5;

            const pct = Math.min(100, score);
            const progressH2 = document.getElementById('progress-text-h2');
            const progressBar = document.getElementById('progress-bar-fill');
            const descText = document.getElementById('progress-desc-text');
            const submitBtn = document.getElementById('btnSubmitAdmin');
            const statusBadge = document.getElementById('statusBadge');

            if (progressH2) progressH2.innerHTML = '<i class="bi bi-speedometer2"></i> Profile Completion: ' + pct + '%';
            if (progressBar) progressBar.style.width = pct + '%';

            if (pct >= 90) {
                if (descText) descText.textContent = "Profile is ready! Save and submit for Admin Verification.";
                if (submitBtn) submitBtn.style.display = 'flex';
                if (statusBadge && statusBadge.textContent.trim() !== 'APPROVED') {
                    statusBadge.textContent = 'READY TO SUBMIT';
                    statusBadge.classList.add('ready');
                }
            } else {
                if (descText) descText.textContent = "Complete all required fields (" + pct + "% done) to submit your advocate profile.";
                if (submitBtn) submitBtn.style.display = 'none';
                if (statusBadge && statusBadge.textContent.trim() !== 'APPROVED') {
                    statusBadge.textContent = 'INCOMPLETE';
                    statusBadge.classList.remove('ready');
                }
            }
        }

        // ==========================================
        // DOM READY & EVENT ATTACHMENTS
        // ==========================================
        document.addEventListener('DOMContentLoaded', () => {
            initLocationSelectors();
            parseExistingBankDetails();
            initPracticeChips();
            initBioCounter();

            // Setup real-time live preview listeners
            document.getElementById('fullName')?.addEventListener('input', function() {
                const name = this.value.trim() || 'Advocate Name';
                document.getElementById('prevName').textContent = name;
                const initial = this.value.trim() ? this.value.trim().charAt(0).toUpperCase() : 'L';
                const initialEl = document.getElementById('prevInitials');
                if (initialEl) initialEl.textContent = initial;
            });

            document.getElementById('designation')?.addEventListener('input', function() {
                document.getElementById('prevRole').textContent = this.value.trim() || 'Advocate';
            });

            document.getElementById('barCouncilId')?.addEventListener('input', function() {
                document.getElementById('prevBarId').innerHTML = '<i class="bi bi-card-text"></i> ' + (this.value.trim().toUpperCase() || 'BAR-ID: PENDING');
            });

            document.getElementById('consultationFee')?.addEventListener('input', function() {
                document.getElementById('prevFee').textContent = '₹' + (this.value !== '' ? this.value : '0');
            });

            document.getElementById('durationMinutes')?.addEventListener('change', function() {
                document.getElementById('prevDuration').textContent = this.value + ' mins';
            });

            document.getElementById('experienceYears')?.addEventListener('input', function() {
                document.getElementById('prevExp').textContent = (this.value || '0') + ' Years';
            });

            document.getElementById('serviceMode')?.addEventListener('change', function() {
                document.getElementById('prevMode').textContent = this.value;
            });

            // "Same as Phone" button for WhatsApp
            document.getElementById('btnCopyPhone')?.addEventListener('click', () => {
                const phone = document.getElementById('phone')?.value || '';
                const wa = document.getElementById('whatsappNumber');
                if (wa && phone) {
                    wa.value = phone;
                    validateField('whatsappNumber');
                    calculateCompletion();
                }
            });

            // Attach input & blur validation to all validated fields
            Object.keys(validationRules).forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', () => {
                        validateField(id);
                        if (id.startsWith('bank') || id === 'confirmAccountNumber') syncBankDetails();
                        calculateCompletion();
                    });
                    el.addEventListener('blur', () => {
                        validateField(id);
                        if (id.startsWith('bank') || id === 'confirmAccountNumber') syncBankDetails();
                    });
                    el.addEventListener('change', () => {
                        validateField(id);
                        if (id.startsWith('bank') || id === 'confirmAccountNumber') syncBankDetails();
                        calculateCompletion();
                    });
                }
            });

            // Form Submit interception
            const form = document.getElementById('profileForm');
            if (form) {
                form.addEventListener('submit', function(e) {
                    syncBankDetails();

                    // Finalize city
                    const distVal = document.getElementById('districtSelect')?.value || '';
                    if (distVal === "Other") {
                        document.getElementById('cityInput').value = document.getElementById('customCityInput')?.value.trim() || '';
                    } else {
                        document.getElementById('cityInput').value = distVal;
                    }

                    // Run comprehensive validation
                    const errors = validateAllFields();
                    if (errors.length > 0) {
                        e.preventDefault();
                        displayAlertSummary(errors);
                        return false;
                    }

                    // Clear alert summary if all good
                    displayAlertSummary([]);
                });
            }

            // Initial calculation
            calculateCompletion();
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
