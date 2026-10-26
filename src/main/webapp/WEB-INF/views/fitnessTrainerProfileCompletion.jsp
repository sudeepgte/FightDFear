<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Coach Profile — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
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
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }

        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
        }

        .header-brand i { color: var(--primary); font-size: 1.3rem; }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-skip:hover { background: var(--bg-page); }

        .btn-header-save {
            padding: 8px 18px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-header-save:hover { background: var(--primary-hover); }


        .main-container {
            flex: 1;
            max-width: 880px;
            width: 100%;
            margin: 24px auto 50px;
            padding: 0 20px;
        }

        .profile-container-wrap {
            width: 100%;
        }

        /* Review Pop-up Modal Styling */
        .review-modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.72);
            backdrop-filter: blur(6px);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-y: auto;
        }

        .review-modal-dialog {
            background: #FFFFFF;
            width: 100%;
            max-width: 820px;
            max-height: 90vh;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border: 1px solid #FECDD3;
            animation: modalFadeIn 0.25s ease-out;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }

        .review-modal-header {
            background: linear-gradient(135deg, #FFF1F2 0%, #FFE4E6 100%);
            padding: 20px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #FECDD3;
        }

        .review-modal-header h3 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        .btn-modal-close {
            background: transparent;
            border: none;
            font-size: 1.8rem;
            line-height: 1;
            color: var(--text-gray);
            cursor: pointer;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .btn-modal-close:hover {
            background: #FECDD3;
            color: var(--navy);
        }

        .review-modal-body {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .review-section-box {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 16px 20px;
        }

        .review-section-title {
            font-size: 0.85rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--primary);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .review-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 20px;
        }

        @media (max-width: 640px) {
            .review-grid-2 { grid-template-columns: 1fr; }
        }

        .review-item {
            font-size: 0.88rem;
        }

        .review-item-label {
            font-size: 0.74rem;
            color: var(--text-gray);
            font-weight: 600;
            margin-bottom: 2px;
        }

        .review-item-val {
            font-weight: 600;
            color: var(--navy);
            word-break: break-word;
        }

        .review-chip-pill {
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 16px;
            background: #FFF1F2;
            color: #E11D48;
            border: 1px solid #FECDD3;
            margin-right: 4px;
            margin-bottom: 4px;
        }

        .review-modal-footer {
            background: #FFFFFF;
            padding: 16px 24px;
            border-top: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-modal-back {
            padding: 10px 18px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.88rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-modal-back:hover {
            background: #F1F5F9;
        }

        .btn-modal-draft {
            padding: 10px 18px;
            border: 1px solid #CBD5E1;
            background: #F8FAFC;
            color: var(--navy);
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.88rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-modal-draft:hover {
            background: #E2E8F0;
        }

        .btn-modal-submit-final {
            padding: 10px 22px;
            border: none;
            background: linear-gradient(135deg, #F43F5E 0%, #E11D48 100%);
            color: #FFFFFF;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-modal-submit-final:hover {
            opacity: 0.95;
            transform: translateY(-1px);
        }


        .profile-progress-card {
            background: #FFFFFF;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .progress-title {
            font-size: 1rem;
            font-weight: 800;
            color: var(--navy);
        }

        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            text-transform: uppercase;
        }

        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-changes { background: var(--warning-bg); color: var(--warning); border: 1px solid #FFEDD5; }
        .badge-approved { background: var(--success-bg); color: var(--success); }
        .badge-rejected { background: var(--error-bg); color: var(--error); }

        .progress-bar-container {
            height: 8px;
            background: #E2E8F0;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .feedback-banner {
            background: #FFFBEB;
            border: 1px solid #FCD34D;
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 16px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .feedback-banner i { color: #D97706; font-size: 1.3rem; margin-top: 2px; }

        .feedback-content h4 {
            font-size: 0.9rem;
            font-weight: 800;
            color: #92400E;
            margin-bottom: 4px;
        }

        .feedback-content p {
            font-size: 0.85rem;
            color: #78350F;
            line-height: 1.4;
        }

        .submit-bar { margin-bottom: 20px; }

        .btn-submit-verification {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit-verification:hover:not(:disabled) { background: var(--primary-hover); }
        .btn-submit-verification:disabled { background: #CBD5E1; cursor: not-allowed; box-shadow: none; color: #64748B; }

        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .section-header {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group { margin-bottom: 14px; }

        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        @media (max-width: 600px) {
            .app-header { padding: 12px 14px; }
            .header-brand span { display: none; }
            .main-container { padding: 0 14px; margin-top: 16px; }
            .form-row { grid-template-columns: 1fr; }
            .chips-container {
                flex-direction: column;
                flex-wrap: nowrap;
                align-items: stretch;
            }
            .chip-checkbox {
                width: 100%;
                display: block;
            }
            .chip-checkbox .chip-label {
                display: block;
                width: 100%;
                text-align: center;
                padding: 12px;
                font-size: 0.95rem;
            }
        }

        .chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 6px;
        }

        .chip-checkbox { position: relative; cursor: pointer; user-select: none; }
        .chip-checkbox input { position: absolute; opacity: 0; cursor: pointer; }

        .chip-label {
            display: inline-block;
            padding: 7px 12px;
            background: #F1F5F9;
            border: 1px solid #E2E8F0;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: #475569;
            transition: all 0.2s;
            white-space: normal;
            word-break: break-word;
        }

        .chip-checkbox input:checked + .chip-label {
            background: #FFE4E6;
            border-color: var(--primary);
            color: var(--primary);
        }

        .toggle-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #F1F5F9;
        }

        .toggle-row:last-child { border-bottom: none; }
        .toggle-label { font-size: 0.85rem; font-weight: 600; color: var(--navy); }
        .toggle-switch { position: relative; display: inline-block; width: 44px; height: 24px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #CBD5E1;
            transition: .3s;
            border-radius: 24px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .3s;
            border-radius: 50%;
        }

        input:checked + .slider { background-color: var(--primary); }
        input:checked + .slider:before { transform: translateX(20px); }

        .bottom-actions { margin-top: 24px; display: flex; gap: 12px; }

        .btn-bottom-save {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-bottom-save:hover { background: var(--primary-hover); }

    </style>
</head>
<body>

    <header class="app-header">
        <div style="display: flex; align-items: center; gap: 12px;">
            <a href="javascript:history.back()" style="color: var(--navy); font-size: 1.2rem; text-decoration: none;"><i class="bi bi-arrow-left"></i></a>
            <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="header-brand">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> <span>Fight D Fear Coach Studio</span>
            </a>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="btn-skip"><i class="bi bi-arrow-left me-1"></i> Dashboard</a>
            <button type="button" class="btn-header-save" onclick="openReviewModal()"><i class="bi bi-eye me-1"></i> Review &amp; Submit</button>
        </div>
    </header>



    <main class="main-container">
        <div class="profile-container-wrap">
            <c:if test="${not empty error}">
                <div style="background:#FEF2F2; border:1px solid #FECACA; color:#DC2626; padding:12px 18px; border-radius:12px; margin-bottom:16px; font-weight:600; font-size:0.9rem; display:flex; align-items:center; gap:8px;">
                    <i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${error}"/>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="background:#F0FDF4; border:1px solid #BBF7D0; color:#16A34A; padding:12px 18px; border-radius:12px; margin-bottom:16px; font-weight:600; font-size:0.9rem; display:flex; align-items:center; gap:8px;">
                    <i class="bi bi-check-circle-fill"></i> <c:out value="${success}"/>
                </div>
            </c:if>
            <c:if test="${not empty info}">
                <div style="background:#EFF6FF; border:1px solid #BFDBFE; color:#2563EB; padding:12px 18px; border-radius:12px; margin-bottom:16px; font-weight:600; font-size:0.9rem; display:flex; align-items:center; gap:8px;">
                    <i class="bi bi-info-circle-fill"></i> <c:out value="${info}"/>
                </div>
            </c:if>
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <span class="progress-title">Coach Profile Completion: <span>${trainer.profileCompletionPct != null ? trainer.profileCompletionPct : 0}%</span></span>
                        <c:choose>
                            <c:when test="${trainer.partnerProfileStatus == 'APPROVED' || trainer.verificationStatus == 'VERIFIED'}">
                                <span class="status-badge badge-approved">Approved</span>
                            </c:when>
                            <c:when test="${trainer.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                                <span class="status-badge badge-changes">Changes Requested</span>
                            </c:when>
                            <c:when test="${trainer.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL' || trainer.verificationStatus == 'PENDING'}">
                                <span class="status-badge badge-pending">Under Review</span>
                            </c:when>
                            <c:when test="${trainer.partnerProfileStatus == 'REJECTED' || trainer.verificationStatus == 'REJECTED'}">
                                <span class="status-badge badge-rejected">Rejected</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-registered">Registered</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" style="width: ${trainer.profileCompletionPct != null ? trainer.profileCompletionPct : 0}%;"></div>
                    </div>
                    <p style="font-size: 0.8rem; color: var(--text-gray);">
                        Complete all mandatory fields to unlock booking calendar and receive client requests.
                    </p>
                </div>

                <c:if test="${not empty trainer.rejectionReason}">
                    <div class="feedback-banner">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <div class="feedback-content">
                            <h4>Admin Feedback</h4>
                            <p><c:out value="${trainer.rejectionReason}"/></p>
                        </div>
                    </div>
                </c:if>

                <div class="submit-bar">
                    <form action="${pageContext.request.contextPath}/fitness/trainer/submitVerification${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post">
                        <c:if test="${not empty _csrf}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </c:if>
                        <button type="submit" class="btn-submit-verification" 
                                <c:if test="${trainer.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${trainer.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Submitted — Pending Admin Review
                                </c:when>
                                <c:when test="${trainer.partnerProfileStatus == 'APPROVED'}">
                                    <i class="bi bi-patch-check-fill"></i> Coach Verified & Approved
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-send-check-fill"></i> Submit Coach Profile for Verification
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </div>

                <form id="trainerProfileForm" action="${pageContext.request.contextPath}/fitness/trainer/updateProfile${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>
                    <input type="hidden" name="id" value="${trainer.id}">
                    <input type="hidden" name="intent" id="formIntent" value="submitVerification">

                    <!-- Section 1: Trainer Identity -->
                    <div class="section-card">
                        <div class="section-header">1. Trainer identity</div>
                        <div class="form-group">
                            <label>1.1 Full name *</label>
                            <input type="text" name="fullName" id="inputFullName" class="form-input" value="<c:out value='${trainer.fullName}'/>" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>1.2 Designation *</label>
                                <select name="designation" id="inputDesignation" class="form-select">
                                    <option value="Certified Fitness Coach" ${trainer.designation == 'Certified Fitness Coach' ? 'selected' : ''}>Certified Fitness Coach</option>
                                    <option value="Personal Trainer" ${trainer.designation == 'Personal Trainer' ? 'selected' : ''}>Personal Trainer</option>
                                    <option value="Yoga Instructor" ${trainer.designation == 'Yoga Instructor' ? 'selected' : ''}>Yoga Instructor</option>
                                    <option value="Zumba Coach" ${trainer.designation == 'Zumba Coach' ? 'selected' : ''}>Zumba Coach</option>
                                    <option value="Strength & Conditioning Coach" ${trainer.designation == 'Strength & Conditioning Coach' ? 'selected' : ''}>Strength & Conditioning Coach</option>
                                    <option value="Nutrition & Wellness Consultant" ${trainer.designation == 'Nutrition & Wellness Consultant' ? 'selected' : ''}>Nutrition & Wellness Consultant</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>1.5 Official phone *</label>
                                <input type="tel" name="phone" class="form-input" value="<c:out value='${trainer.phone}'/>" maxlength="10" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>1.6 WhatsApp</label>
                                <input type="tel" name="whatsappNumber" class="form-input" value="<c:out value='${trainer.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                            </div>
                            <div class="form-group">
                                <label>1.7 Years of experience *</label>
                                <input type="number" name="experience" id="inputExperience" class="form-input" value="${trainer.experience != null ? trainer.experience : 1}" min="0" max="50" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>1.8 ACE / NASM / Yoga Alliance / Cert Number *</label>
                            <input type="text" name="credentialNumber" class="form-input" value="<c:out value='${trainer.credentialNumber}'/>" placeholder="Credential Registration ID" required>
                        </div>
                    </div>

                    <!-- Section 2: Location -->
                    <div class="section-card">
                        <div class="section-header">2. Location</div>
                        <div class="form-group">
                            <label>2.1 Studio / Home Address *</label>
                            <input type="text" name="address" class="form-input" value="<c:out value='${trainer.address}'/>" placeholder="Studio address or home base" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>2.3 City *</label>
                                <input type="text" name="city" id="inputCity" class="form-input" value="<c:out value='${trainer.city}'/>" placeholder="City" required>
                            </div>
                            <div class="form-group">
                                <label>2.4 State *</label>
                                <select name="state" id="inputState" class="form-select" required>
                                    <option value="Karnataka" ${trainer.state == 'Karnataka' ? 'selected' : ''}>Karnataka</option>
                                    <option value="Maharashtra" ${trainer.state == 'Maharashtra' ? 'selected' : ''}>Maharashtra</option>
                                    <option value="Delhi" ${trainer.state == 'Delhi' ? 'selected' : ''}>Delhi</option>
                                    <option value="Tamil Nadu" ${trainer.state == 'Tamil Nadu' ? 'selected' : ''}>Tamil Nadu</option>
                                    <option value="Telangana" ${trainer.state == 'Telangana' ? 'selected' : ''}>Telangana</option>
                                    <option value="Other" ${trainer.state == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>2.5 Pincode *</label>
                                <input type="text" name="pincode" class="form-input" value="<c:out value='${trainer.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required>
                            </div>
                            <div class="form-group">
                                <label>2.6 Google Maps link</label>
                                <input type="url" name="mapLink" class="form-input" placeholder="https://maps.app.goo.gl/...">
                            </div>
                        </div>
                    </div>

                    <!-- Section 3: Specializations -->
                    <div class="section-card">
                        <div class="section-header">3. Specializations & Categories *</div>
                        <div class="chips-container">
                            <c:forEach var="cat" items="${['Weight Loss', 'HIIT', 'Yoga', 'Strength Training', 'Zumba', 'Aerobics', 'Pilates', 'Self-Defense Fitness', 'Pre/Post Natal', 'Senior Fitness']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="specializations" class="spec-checkbox" value="${cat}" ${trainer.specializations != null && trainer.specializations.contains(cat) ? 'checked' : ''}>
                                    <span class="chip-label">${cat}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 4: Who I Serve -->
                    <div class="section-card">
                        <div class="section-header">4. Who I serve</div>
                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">4.1 Target Audience *</label>
                        <div class="chips-container" style="margin-bottom: 14px;">
                            <c:forEach var="aud" items="${['Women Only', 'Beginners', 'All Fitness Levels', 'Post-Rehab']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="audience" class="aud-checkbox" value="${aud}" ${trainer.audience != null && trainer.audience.contains(aud) ? 'checked' : ''}>
                                    <span class="chip-label">${aud}</span>
                                </label>
                            </c:forEach>
                        </div>
                        <div class="toggle-row">
                            <span class="toggle-label">4.2 Home / Doorstep sessions</span>
                            <label class="toggle-switch">
                                <input type="checkbox" name="doorstepService" id="inputDoorstep" value="true" ${trainer.doorService == true ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <!-- Section 5: Facilities -->
                    <div class="section-card">
                        <div class="section-header">5. Studio Amenities</div>
                        <div class="chips-container">
                            <c:forEach var="fac" items="${['Private Studio', 'Changing Room', 'Shower', 'Locker', 'AC', 'Free Weights', 'Cardio Equipment', 'Mirrors', 'Parking']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="facilities" class="fac-checkbox" value="${fac}" ${trainer.facilities != null && trainer.facilities.contains(fac) ? 'checked' : ''}>
                                    <span class="chip-label">${fac}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 6: Hours & Schedule -->
                    <div class="section-card">
                        <div class="section-header">6. Hours & calendar</div>
                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">6.1 Open days *</label>
                        <div class="chips-container" style="margin-bottom: 14px;">
                            <c:forEach var="day" items="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="availableDays" value="${day}" ${trainer.openDays != null && trainer.openDays.contains(day) ? 'checked' : ''}>
                                    <span class="chip-label">${day.substring(0, 3)}</span>
                                </label>
                            </c:forEach>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>6.2 Open time *</label>
                                <input type="time" name="openTime" class="form-input" value="${trainer.openTime != null ? trainer.openTime : '06:00'}" required>
                            </div>
                            <div class="form-group">
                                <label>6.3 Close time *</label>
                                <input type="time" name="closeTime" class="form-input" value="${trainer.closeTime != null ? trainer.closeTime : '20:00'}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Section 7: About You -->
                    <div class="section-card">
                        <div class="section-header">7. About you</div>
                        <div class="form-group">
                            <label>7.1 Bio & coaching approach *</label>
                            <textarea name="bio" id="inputBio" class="form-textarea" rows="4" placeholder="Tell your clients about your training approach, philosophy, and success stories..." required><c:out value="${trainer.bio}"/></textarea>
                        </div>
                    </div>

                    <!-- Section 8: Typical Session -->
                    <div class="section-card">
                        <div class="section-header">8. Typical session</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>8.1 Session mode *</label>
                                <select name="sessionMode" id="inputSessionMode" class="form-select">
                                    <option value="In-Person Studio" ${trainer.sessionMode == 'In-Person Studio' ? 'selected' : ''}>In-Person Studio</option>
                                    <option value="Home / Client Location" ${trainer.sessionMode == 'Home / Client Location' ? 'selected' : ''}>Home / Client Location</option>
                                    <option value="Online 1-on-1" ${trainer.sessionMode == 'Online 1-on-1' ? 'selected' : ''}>Online 1-on-1</option>
                                    <option value="Hybrid" ${trainer.sessionMode == 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>8.2 Duration *</label>
                                <select name="sessionDuration" id="inputSessionDuration" class="form-select">
                                    <option value="30" ${trainer.durationMinutes == 30 ? 'selected' : ''}>30 minutes</option>
                                    <option value="45" ${trainer.durationMinutes == 45 ? 'selected' : ''}>45 minutes</option>
                                    <option value="60" ${trainer.durationMinutes == 60 || trainer.durationMinutes == null ? 'selected' : ''}>60 minutes</option>
                                    <option value="90" ${trainer.durationMinutes == 90 ? 'selected' : ''}>90 minutes</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>8.4 Typical session fee (₹, 0 = free) *</label>
                            <input type="number" name="sessionFees" id="inputSessionFees" class="form-input" value="${trainer.typicalPrice != null ? trainer.typicalPrice : (trainer.sessionFees != null ? trainer.sessionFees : 300)}" min="0" required>
                        </div>
                    </div>

                    <!-- Section 9: Payout & UPI -->
                    <div class="section-card">
                        <div class="section-header">9. Payout details</div>
                        <div class="form-group">
                            <label>9.1 UPI ID (for receiving session payouts)</label>
                            <input type="text" name="upiId" id="inputUpiId" class="form-input" value="<c:out value='${trainer.upiId}'/>" placeholder="coach@upi">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>9.2 Account Holder Name *</label>
                                <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as per Bank records">
                            </div>
                            <div class="form-group">
                                <label>9.3 Bank Name *</label>
                                <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. HDFC Bank, ICICI Bank, SBI">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>9.4 Account Number *</label>
                                <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Enter 9 to 18 digit account number" maxlength="18" inputmode="numeric" oninput="validateAccountNumber()">
                                <small id="accInvalidMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-exclamation-circle-fill"></i> Account number must be 9 to 18 numeric digits
                                </small>
                                <small id="accValidMsg" style="color: #16A34A; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-check-circle-fill"></i> Valid account number
                                </small>
                            </div>
                            <div class="form-group">
                                <label>9.5 Re-enter Account Number *</label>
                                <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Confirm bank account number" maxlength="18" inputmode="numeric" oninput="validateAccountNumber()">
                                <small id="accMismatchMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match
                                </small>
                                <small id="accMatchSuccessMsg" style="color: #16A34A; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-check-circle-fill"></i> Account numbers match
                                </small>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>9.6 IFSC Code *</label>
                                <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. HDFC0001234" maxlength="11" style="text-transform: uppercase;" oninput="validateIfscCode()">
                                <small id="ifscFormatMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-exclamation-circle-fill"></i> Invalid IFSC format (e.g. SBIN0001234)
                                </small>
                                <small id="ifscValidMsg" style="color: #16A34A; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                                    <i class="bi bi-check-circle-fill"></i> Valid IFSC format
                                </small>
                            </div>
                            <div class="form-group">
                                <label>9.7 Branch Name</label>
                                <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. Indiranagar Branch">
                            </div>
                        </div>

                        <!-- Hidden serialized field for DB compatibility -->
                        <input type="hidden" id="bankDetails" name="bankDetails" value="<c:out value='${trainer.bankDetails}'/>">
                    </div>

                    <!-- Section 10: Documents -->
                    <div class="section-card">
                        <div class="section-header">10. Documents & Certification</div>
                        <div class="form-group">
                            <label>10.1 Profile photo (Headshot)</label>
                            <input type="file" name="profilePhotoFile" id="inputProfilePhoto" class="form-input" accept="image/*" onchange="previewSelectedPhoto(this)">
                        </div>
                        <div class="form-group">
                            <label>10.2 Certification Scan</label>
                            <input type="file" name="certificateFile" class="form-input" accept=".pdf,image/*">
                        </div>
                    </div>

                    <!-- Section 11: Studio Photos -->
                    <div class="section-card">
                        <div class="section-header">11. Studio photos</div>
                        <div class="form-group">
                            <label>11.1 Gallery / Training Photo</label>
                            <input type="file" name="galleryFiles" id="inputGalleryFiles" class="form-input" accept="image/*" multiple onchange="previewSelectedGallery(this)">
                        </div>
                    </div>

                    <div class="bottom-actions">
                        <button type="button" class="btn-bottom-save" onclick="openReviewModal()">
                            <i class="bi bi-eye-fill me-2"></i> Review Profile &amp; Submit
                        </button>
                    </div>
                </form>
        </div>
    </main>

    <!-- ====================================================
         PROFILE REVIEW POP-UP MODAL PAGE
         ==================================================== -->
    <div id="profileReviewModalBackdrop" class="review-modal-backdrop" onclick="handleReviewBackdropClick(event)">
        <div class="review-modal-dialog">
            <div class="review-modal-header">
                <h3><i class="bi bi-clipboard-check-fill" style="color: var(--primary);"></i> Review Coach Profile</h3>
                <button type="button" class="btn-modal-close" onclick="closeReviewModal()" aria-label="Close">&times;</button>
            </div>

            <div class="review-modal-body">
                <!-- Summary Header -->
                <div style="background: linear-gradient(135deg, #FFF1F2 0%, #FFFFFF 100%); border: 1px solid #FECDD3; border-radius: 16px; padding: 18px 20px; display: flex; align-items: center; gap: 16px;">
                    <div style="width: 68px; height: 68px; border-radius: 50%; overflow: hidden; border: 2px solid #FECDD3; background: #FFE4E6; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <img id="modalRevAvatarImg" src="${not empty trainer.profilePhotoPath ? trainer.profilePhotoPath : ''}" style="width: 100%; height: 100%; object-fit: cover; ${empty trainer.profilePhotoPath ? 'display:none;' : ''}">
                        <div id="modalRevAvatarFallback" style="font-size: 1.8rem; color: var(--primary); ${not empty trainer.profilePhotoPath ? 'display:none;' : ''}">
                            <i class="bi bi-person-fill"></i>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 6px;">
                            <span id="modalRevFullName">Coach Name</span>
                            <i class="bi bi-patch-check-fill text-success" title="Verified Badge"></i>
                        </div>
                        <div id="modalRevDesignation" style="font-size: 0.88rem; font-weight: 700; color: var(--primary); margin-bottom: 2px;">Certified Fitness Coach</div>
                        <div style="font-size: 0.8rem; color: var(--text-gray);">
                            <span id="modalRevExp">1 Years Exp</span> &bull; <span id="modalRevCityState">City, State</span>
                        </div>
                    </div>
                </div>

                <!-- 1. Identity & Contact Details -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-person-badge"></i> 1. Identity &amp; Contact Details</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Full Name</div><div class="review-item-val" id="revValName">—</div></div>
                        <div class="review-item"><div class="review-item-label">Designation</div><div class="review-item-val" id="revValDesig">—</div></div>
                        <div class="review-item"><div class="review-item-label">Official Phone</div><div class="review-item-val" id="revValPhone">—</div></div>
                        <div class="review-item"><div class="review-item-label">WhatsApp Number</div><div class="review-item-val" id="revValWhatsapp">—</div></div>
                        <div class="review-item"><div class="review-item-label">Experience</div><div class="review-item-val" id="revValExperience">—</div></div>
                        <div class="review-item"><div class="review-item-label">Credential / Cert Reg ID</div><div class="review-item-val" id="revValCredential">—</div></div>
                    </div>
                </div>

                <!-- 2. Location & Address -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-geo-alt"></i> 2. Studio / Location</div>
                    <div class="review-grid-2">
                        <div class="review-item" style="grid-column: 1 / -1;"><div class="review-item-label">Address</div><div class="review-item-val" id="revValAddress">—</div></div>
                        <div class="review-item"><div class="review-item-label">City &amp; State</div><div class="review-item-val" id="revValCityState">—</div></div>
                        <div class="review-item"><div class="review-item-label">Pincode</div><div class="review-item-val" id="revValPincode">—</div></div>
                    </div>
                </div>

                <!-- 3. Specializations & Audience -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-stars"></i> 3. Specializations &amp; Audience</div>
                    <div class="review-item" style="margin-bottom: 10px;">
                        <div class="review-item-label">Categories Offered</div>
                        <div id="revValSpecs" style="margin-top: 4px;">—</div>
                    </div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Target Audience</div><div id="revValAudience" style="margin-top: 4px;">—</div></div>
                        <div class="review-item"><div class="review-item-label">Doorstep / Home Sessions</div><div class="review-item-val" id="revValDoorstep">—</div></div>
                    </div>
                </div>

                <!-- 4. Schedule & Amenities -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-clock-history"></i> 4. Working Hours &amp; Amenities</div>
                    <div class="review-item" style="margin-bottom: 8px;">
                        <div class="review-item-label">Available Days</div>
                        <div id="revValDays" style="margin-top: 4px;">—</div>
                    </div>
                    <div class="review-grid-2" style="margin-bottom: 8px;">
                        <div class="review-item"><div class="review-item-label">Hours of Operation</div><div class="review-item-val" id="revValHours">—</div></div>
                        <div class="review-item"><div class="review-item-label">Session Mode &amp; Duration</div><div class="review-item-val" id="revValSessionMode">—</div></div>
                    </div>
                    <div class="review-item">
                        <div class="review-item-label">Studio Amenities</div>
                        <div id="revValFacilities" style="margin-top: 4px;">—</div>
                    </div>
                </div>

                <!-- 5. Pricing & Bio -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-cash-stack"></i> 5. Fees &amp; Coaching Bio</div>
                    <div class="review-item" style="margin-bottom: 10px;">
                        <div class="review-item-label">Session Fee</div>
                        <div class="review-item-val" id="revValFee" style="font-size: 1.05rem; color: #16A34A;">—</div>
                    </div>
                    <div class="review-item">
                        <div class="review-item-label">About / Philosophy</div>
                        <div class="review-item-val" id="revValBio" style="font-weight: 500; font-size: 0.85rem; line-height: 1.45;">—</div>
                    </div>
                </div>

                <!-- 6. Payout & Bank Verification Details -->
                <div class="review-section-box" style="border-left: 4px solid var(--primary);">
                    <div class="review-section-title"><i class="bi bi-bank"></i> 6. Payout &amp; Bank Details</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">UPI ID</div><div class="review-item-val" id="revValUpi">—</div></div>
                        <div class="review-item"><div class="review-item-label">Account Holder</div><div class="review-item-val" id="revValBankHolder">—</div></div>
                        <div class="review-item"><div class="review-item-label">Bank Name</div><div class="review-item-val" id="revValBankName">—</div></div>
                        <div class="review-item"><div class="review-item-label">Account Number</div><div class="review-item-val" id="revValBankAcc" style="letter-spacing: 1px; font-family: monospace; font-size: 0.95rem;">—</div></div>
                        <div class="review-item"><div class="review-item-label">IFSC Code</div><div class="review-item-val" id="revValBankIfsc" style="letter-spacing: 0.8px; font-family: monospace;">—</div></div>
                        <div class="review-item"><div class="review-item-label">Branch</div><div class="review-item-val" id="revValBankBranch">—</div></div>
                    </div>
                </div>

                <!-- 7. Media & Documents -->
                <div class="review-section-box">
                    <div class="review-section-title"><i class="bi bi-file-earmark-check"></i> 7. Uploaded Documents Status</div>
                    <div class="review-grid-2">
                        <div class="review-item"><div class="review-item-label">Profile Photo</div><div class="review-item-val" id="revValPhotoStatus">—</div></div>
                        <div class="review-item"><div class="review-item-label">Certificate Document</div><div class="review-item-val" id="revValCertStatus">—</div></div>
                        <div class="review-item"><div class="review-item-label">Studio Gallery Photos</div><div class="review-item-val" id="revValGalleryStatus">—</div></div>
                    </div>
                </div>
            </div>

            <!-- Modal Footer Actions -->
            <div class="review-modal-footer">
                <button type="button" class="btn-modal-back" onclick="closeReviewModal()">
                    <i class="bi bi-pencil-square me-1"></i> Edit Details
                </button>
                <button type="button" class="btn-modal-draft" onclick="submitProfileForm('saveDraft')">
                    <i class="bi bi-cloud-arrow-up me-1"></i> Save as Draft
                </button>
                <button type="button" class="btn-modal-submit-final" onclick="submitProfileForm('submitVerification')">
                    <i class="bi bi-send-check-fill me-1"></i> Confirm &amp; Submit to Dashboard
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript Engine -->
    <script>
        let selectedPhotoDataUrl = null;

        function previewSelectedPhoto(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    selectedPhotoDataUrl = e.target.result;
                    const img = document.getElementById('modalRevAvatarImg');
                    const fallback = document.getElementById('modalRevAvatarFallback');
                    if (img) {
                        img.src = selectedPhotoDataUrl;
                        img.style.display = 'block';
                    }
                    if (fallback) fallback.style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewSelectedGallery(input) {
            // Handled when user selects gallery files
        }

        function validateAccountNumber() {
            const accInput = document.getElementById('bankAccountNumber');
            const confirmInput = document.getElementById('confirmAccountNumber');
            const invalidMsg = document.getElementById('accInvalidMsg');
            const validMsg = document.getElementById('accValidMsg');
            const mismatchMsg = document.getElementById('accMismatchMsg');
            const matchSuccessMsg = document.getElementById('accMatchSuccessMsg');

            if (!accInput) return true;

            // Only allow numbers
            accInput.value = accInput.value.replace(/\D/g, '');
            if (confirmInput) confirmInput.value = confirmInput.value.replace(/\D/g, '');

            const acc = accInput.value.trim();
            const conf = confirmInput ? confirmInput.value.trim() : '';

            let isAccValid = true;
            if (acc) {
                if (!/^\d{9,18}$/.test(acc)) {
                    invalidMsg.style.display = 'block';
                    validMsg.style.display = 'none';
                    accInput.style.borderColor = '#DC2626';
                    isAccValid = false;
                } else {
                    invalidMsg.style.display = 'none';
                    validMsg.style.display = 'block';
                    accInput.style.borderColor = '#16A34A';
                }
            } else {
                invalidMsg.style.display = 'none';
                validMsg.style.display = 'none';
                accInput.style.borderColor = '';
            }

            if (confirmInput && conf) {
                if (acc !== conf) {
                    mismatchMsg.style.display = 'block';
                    matchSuccessMsg.style.display = 'none';
                    confirmInput.style.borderColor = '#DC2626';
                    isAccValid = false;
                } else {
                    mismatchMsg.style.display = 'none';
                    matchSuccessMsg.style.display = 'block';
                    confirmInput.style.borderColor = '#16A34A';
                }
            } else if (confirmInput) {
                mismatchMsg.style.display = 'none';
                matchSuccessMsg.style.display = 'none';
                confirmInput.style.borderColor = '';
                if (acc) isAccValid = false;
            }

            syncBankDetails();
            return isAccValid;
        }

        function validateIfscCode() {
            const ifscInput = document.getElementById('bankIfsc');
            const formatMsg = document.getElementById('ifscFormatMsg');
            const validMsg = document.getElementById('ifscValidMsg');
            if (!ifscInput) return true;

            ifscInput.value = ifscInput.value.toUpperCase();
            const ifsc = ifscInput.value.trim();

            if (ifsc) {
                if (!/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                    formatMsg.style.display = 'block';
                    if (validMsg) validMsg.style.display = 'none';
                    ifscInput.style.borderColor = '#DC2626';
                    return false;
                } else {
                    formatMsg.style.display = 'none';
                    if (validMsg) validMsg.style.display = 'block';
                    ifscInput.style.borderColor = '#16A34A';
                    return true;
                }
            } else {
                formatMsg.style.display = 'none';
                if (validMsg) validMsg.style.display = 'none';
                ifscInput.style.borderColor = '';
                return true;
            }
        }

        // Bank Details Pre-parsing & Synchronization
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
            validateAccountNumber();
            validateIfscCode();
        }

        function syncBankDetails() {
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '';
            const bName = document.getElementById('bankName')?.value.trim() || '';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '';

            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                }
            }
        }

        function populateReviewModal() {
            const form = document.getElementById('trainerProfileForm');
            if (!form) return;

            const name = form.querySelector('input[name="fullName"]')?.value.trim() || '—';
            const desig = form.querySelector('select[name="designation"]')?.value || '—';
            const phone = form.querySelector('input[name="phone"]')?.value.trim() || '—';
            const whatsapp = form.querySelector('input[name="whatsappNumber"]')?.value.trim() || 'Not provided';
            const exp = (form.querySelector('input[name="experience"]')?.value || '1') + ' Years';
            const cred = form.querySelector('input[name="credentialNumber"]')?.value.trim() || '—';
            const address = form.querySelector('input[name="address"]')?.value.trim() || '—';
            const city = form.querySelector('input[name="city"]')?.value.trim() || '—';
            const state = form.querySelector('select[name="state"]')?.value || '—';
            const pincode = form.querySelector('input[name="pincode"]')?.value.trim() || '—';

            document.getElementById('modalRevFullName').textContent = name;
            document.getElementById('modalRevDesignation').textContent = desig;
            document.getElementById('modalRevExp').textContent = exp;
            document.getElementById('modalRevCityState').textContent = city + ', ' + state;

            document.getElementById('revValName').textContent = name;
            document.getElementById('revValDesig').textContent = desig;
            document.getElementById('revValPhone').textContent = phone;
            document.getElementById('revValWhatsapp').textContent = whatsapp;
            document.getElementById('revValExperience').textContent = exp;
            document.getElementById('revValCredential').textContent = cred;

            document.getElementById('revValAddress').textContent = address;
            document.getElementById('revValCityState').textContent = city + ', ' + state;
            document.getElementById('revValPincode').textContent = pincode;

            // Specializations
            const specs = Array.from(form.querySelectorAll('.spec-checkbox:checked')).map(cb => cb.value);
            const specsContainer = document.getElementById('revValSpecs');
            if (specs.length > 0) {
                specsContainer.innerHTML = specs.map(s => '<span class="review-chip-pill">' + s + '</span>').join('');
            } else {
                specsContainer.textContent = 'None selected';
            }

            // Audience
            const aud = Array.from(form.querySelectorAll('.aud-checkbox:checked')).map(cb => cb.value);
            const audContainer = document.getElementById('revValAudience');
            if (aud.length > 0) {
                audContainer.innerHTML = aud.map(a => '<span class="badge bg-light border text-dark me-1">' + a + '</span>').join('');
            } else {
                audContainer.textContent = 'All Fitness Levels';
            }

            // Doorstep
            const doorstep = form.querySelector('input[name="doorstepService"]')?.checked;
            document.getElementById('revValDoorstep').textContent = doorstep ? 'Yes, Doorstep Available' : 'No';

            // Available days
            const days = Array.from(form.querySelectorAll('input[name="availableDays"]:checked')).map(cb => cb.value.substring(0, 3));
            const daysContainer = document.getElementById('revValDays');
            if (days.length > 0) {
                daysContainer.innerHTML = days.map(d => '<span class="badge bg-white border text-dark me-1">' + d + '</span>').join('');
            } else {
                daysContainer.textContent = 'Mon - Sun';
            }

            // Hours & Amenities
            const openTime = form.querySelector('input[name="openTime"]')?.value || '06:00';
            const closeTime = form.querySelector('input[name="closeTime"]')?.value || '20:00';
            document.getElementById('revValHours').textContent = openTime + ' - ' + closeTime;

            const mode = form.querySelector('select[name="sessionMode"]')?.value || 'In-Person Studio';
            const duration = form.querySelector('select[name="sessionDuration"]')?.value || '60';
            document.getElementById('revValSessionMode').textContent = mode + ' (' + duration + ' mins)';

            const facs = Array.from(form.querySelectorAll('.fac-checkbox:checked')).map(cb => cb.value);
            const facContainer = document.getElementById('revValFacilities');
            if (facs.length > 0) {
                facContainer.innerHTML = facs.map(f => '<span class="badge bg-white border text-secondary me-1"><i class="bi bi-check-circle text-success me-1"></i>' + f + '</span>').join('');
            } else {
                facContainer.textContent = 'Standard studio facilities';
            }

            // Fees & Bio
            const fees = form.querySelector('input[name="sessionFees"]')?.value || '0';
            document.getElementById('revValFee').textContent = '₹' + fees + ' per session';
            document.getElementById('revValBio').textContent = form.querySelector('textarea[name="bio"]')?.value.trim() || 'No bio provided.';

            // Banking & Payout
            const upi = form.querySelector('input[name="upiId"]')?.value.trim() || 'None';
            const holder = document.getElementById('bankAccountHolder')?.value.trim() || '—';
            const bankName = document.getElementById('bankName')?.value.trim() || '—';
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '—';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '—').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '—';

            document.getElementById('revValUpi').textContent = upi;
            document.getElementById('revValBankHolder').textContent = holder;
            document.getElementById('revValBankName').textContent = bankName;
            document.getElementById('revValBankAcc').textContent = acc !== '—' ? acc : 'Not provided';
            document.getElementById('revValBankIfsc').textContent = ifsc;
            document.getElementById('revValBankBranch').textContent = branch;

            // Uploaded Documents
            const photoFile = form.querySelector('input[name="profilePhotoFile"]')?.files[0];
            document.getElementById('revValPhotoStatus').textContent = photoFile ? ('New file: ' + photoFile.name) : ('<c:out value="${not empty trainer.profilePhotoPath ? "Profile photo on file" : "None"}"/>');

            const certFile = form.querySelector('input[name="certificateFile"]')?.files[0];
            document.getElementById('revValCertStatus').textContent = certFile ? ('New file: ' + certFile.name) : ('<c:out value="${not empty trainer.certificationsPath ? "Certification on file" : "Pending"}"/>');

            const galleryFiles = form.querySelector('input[name="galleryFiles"]')?.files;
            document.getElementById('revValGalleryStatus').textContent = (galleryFiles && galleryFiles.length > 0) ? (galleryFiles.length + ' photos selected') : ('<c:out value="${not empty trainer.galleryPhotos ? "Gallery photos on file" : "None"}"/>');
        }

        function openReviewModal() {
            const form = document.getElementById('trainerProfileForm');
            if (!form) return;

            // Standard HTML5 validity
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            // Validate phone
            const phone = form.querySelector('input[name="phone"]')?.value.trim();
            if (phone && !/^\d{10}$/.test(phone)) {
                alert('Official phone must be a valid 10-digit number.');
                form.querySelector('input[name="phone"]')?.focus();
                return;
            }

            // Validate pincode
            const pincode = form.querySelector('input[name="pincode"]')?.value.trim();
            if (pincode && !/^\d{6}$/.test(pincode)) {
                alert('Pincode must be a valid 6-digit number.');
                form.querySelector('input[name="pincode"]')?.focus();
                return;
            }

            // Validate Specializations
            const specs = form.querySelectorAll('.spec-checkbox:checked');
            if (specs.length === 0) {
                alert('Please select at least one Specialization category.');
                document.querySelector('.spec-checkbox')?.focus();
                return;
            }

            // Validate Target Audience
            const aud = form.querySelectorAll('.aud-checkbox:checked');
            if (aud.length === 0) {
                alert('Please select at least one Target Audience category.');
                document.querySelector('.aud-checkbox')?.focus();
                return;
            }

            // Validate Bank Account Number
            const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            if (acc) {
                if (!/^\d{9,18}$/.test(acc)) {
                    alert('Bank Account Number must be between 9 and 18 numeric digits.');
                    document.getElementById('bankAccountNumber')?.focus();
                    return;
                }
                if (acc !== confirmAcc) {
                    alert('Bank Account Numbers do not match. Please re-enter and confirm.');
                    document.getElementById('confirmAccountNumber')?.focus();
                    return;
                }
            }

            // Validate IFSC Code
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                alert('Please enter a valid 11-character IFSC code (e.g. SBIN0001234).');
                document.getElementById('bankIfsc')?.focus();
                return;
            }

            syncBankDetails();
            populateReviewModal();

            const backdrop = document.getElementById('profileReviewModalBackdrop');
            if (backdrop) {
                backdrop.style.display = 'flex';
                document.body.style.overflow = 'hidden';
            }
        }

        function closeReviewModal() {
            const backdrop = document.getElementById('profileReviewModalBackdrop');
            if (backdrop) {
                backdrop.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        }

        function handleReviewBackdropClick(e) {
            if (e.target.id === 'profileReviewModalBackdrop') {
                closeReviewModal();
            }
        }

        function submitProfileForm(intent) {
            const form = document.getElementById('trainerProfileForm');
            if (!form) return;
            document.getElementById('formIntent').value = intent || 'submitVerification';
            syncBankDetails();
            form.submit();
        }

        document.addEventListener('DOMContentLoaded', function() {
            parseExistingBankDetails();

            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', syncBankDetails);
                    el.addEventListener('blur', syncBankDetails);
                }
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
