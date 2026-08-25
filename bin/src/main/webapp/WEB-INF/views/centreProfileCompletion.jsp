<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Centre Profile — Fight D Fear</title>
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

        /* Top Bar */
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

        .btn-skip:hover {
            background: var(--bg-page);
        }

        .btn-header-save {
            padding: 8px 16px;
            background: var(--navy);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-header-save:hover {
            background: #110E38;
        }

        .main-container {
            flex: 1;
            max-width: 1260px;
            width: 100%;
            margin: 24px auto 40px;
            padding: 0 20px;
        }

        .profile-layout-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 420px;
            gap: 28px;
            align-items: start;
        }

        @media (max-width: 991px) {
            .profile-layout-grid {
                grid-template-columns: 1fr;
            }
            .preview-column {
                order: 2;
                margin-top: 10px;
            }
        }

        /* Live Centre Preview Card Styles */
        .preview-sticky-wrap {
            position: sticky;
            top: 80px;
            z-index: 20;
        }

        .live-preview-card {
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid #FECDD3;
            box-shadow: 0 10px 30px rgba(30, 27, 75, 0.08);
            overflow: hidden;
        }

        .preview-banner-header {
            background: linear-gradient(135deg, #1E1B4B 0%, #2D2960 100%);
            color: #FFFFFF;
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .preview-badge-live {
            background: var(--primary);
            color: #FFFFFF;
            font-size: 0.68rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .preview-body {
            padding: 22px 20px;
        }

        .preview-avatar-box {
            position: relative;
            width: 76px;
            height: 76px;
            border-radius: 16px;
            overflow: hidden;
            flex-shrink: 0;
            background: var(--rose-soft);
            border: 2px solid #FECDD3;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.12);
        }

        .preview-avatar-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .preview-avatar-fallback {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--rose-soft);
        }

        .preview-chip {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            background: #FFE4E6;
            color: #E11D48;
            margin-right: 4px;
            margin-bottom: 4px;
        }

        .preview-meta-row {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            background: #F8FAFC;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            margin-bottom: 8px;
            font-size: 0.82rem;
        }

        .preview-meta-row i {
            color: var(--primary);
            font-size: 0.95rem;
        }


        /* Profile Completion Card Matching Mobile */
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

        .missing-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 10px;
        }

        .chip-missing {
            font-size: 0.75rem;
            font-weight: 600;
            background: var(--warning-bg);
            color: var(--warning);
            padding: 4px 8px;
            border-radius: 6px;
            border: 1px solid #FED7AA;
        }

        /* Admin Feedback Banner */
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

        .feedback-banner i {
            color: #D97706;
            font-size: 1.3rem;
            margin-top: 2px;
        }

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

        /* Submit Action Bar */
        .submit-bar {
            margin-bottom: 20px;
        }

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

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--primary-hover);
        }

        .btn-submit-verification:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748B;
        }

        /* Numbered Section Cards Matching Mobile */
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

        .form-group {
            margin-bottom: 14px;
        }

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
            .form-row { grid-template-columns: 1fr; }
        }

        /* Chips Grid */
        .chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 6px;
        }

        .chip-checkbox {
            position: relative;
            cursor: pointer;
            user-select: none;
        }

        .chip-checkbox input {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

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
        }

        .chip-checkbox input:checked + .chip-label {
            background: #FFE4E6;
            border-color: var(--primary);
            color: var(--primary);
        }

        /* Switches / Toggles */
        .toggle-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #F1F5F9;
        }

        .toggle-row:last-child { border-bottom: none; }

        .toggle-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 44px;
            height: 24px;
        }

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

        /* Save Button at Bottom */
        .bottom-actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
        }

        .btn-bottom-save {
            flex: 1;
            padding: 14px;
            background: var(--navy);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-bottom-save:hover {
            background: #110E38;
        }
    </style>
</head>
<body>

    <!-- Header with Mobile Parity Actions -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/centres/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/centres/dashboard" class="btn-skip">Skip for now</a>
            <button type="button" class="btn-header-save" onclick="document.getElementById('profileForm').submit()">Save Profile</button>
        </div>
    </header>

    <main class="main-container">
        <div class="profile-layout-grid">
            <!-- LEFT: 11 Form Sections Column -->
            <div class="form-column">
                <!-- Dynamic Profile Completion Progress Card -->
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <span class="progress-title">Profile Completion: <span id="pctText">${center.profileCompletionPct != null ? center.profileCompletionPct : 0}%</span></span>
                        <c:choose>
                            <c:when test="${center.centreProfileStatus == 'APPROVED' || center.approved}">
                                <span class="status-badge badge-approved">Approved</span>
                            </c:when>
                            <c:when test="${center.centreProfileStatus == 'CHANGES_REQUESTED'}">
                                <span class="status-badge badge-changes">Changes Requested</span>
                            </c:when>
                            <c:when test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                <span class="status-badge badge-pending">Under Review</span>
                            </c:when>
                            <c:when test="${center.centreProfileStatus == 'REJECTED'}">
                                <span class="status-badge badge-rejected">Rejected</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-registered">Registered</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" style="width: ${center.profileCompletionPct != null ? center.profileCompletionPct : 0}%;"></div>
                    </div>
                    <p style="font-size: 0.8rem; color: var(--text-gray); margin-bottom: 8px;">
                        Complete all required sections below to submit your centre for Admin verification.
                    </p>

                    <!-- Real Dynamic Missing Profile Items -->
                    <c:if test="${center.profileCompletionPct == null || center.profileCompletionPct < 100}">
                        <div class="missing-chips">
                            <c:if test="${empty center.about}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Add Description</span></c:if>
                            <c:if test="${empty center.openTime or empty center.closeTime}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Set Hours</span></c:if>
                            <c:if test="${empty center.profilePhoto}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Upload Logo</span></c:if>
                            <c:if test="${empty center.galleryPhotos or center.galleryPhotos.size() == 0}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Upload Gallery</span></c:if>
                            <c:if test="${empty center.stylesTaught}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Select Styles</span></c:if>
                            <c:if test="${empty center.facilities}"><span class="chip-missing"><i class="bi bi-exclamation-circle me-1"></i> Add Amenities</span></c:if>
                        </div>
                    </c:if>
                </div>

                <!-- Admin Feedback Banner (for Changes Requested / Rejection) -->
                <c:if test="${not empty center.rejectionReason or not empty center.changesRequestedNote}">
                    <div class="feedback-banner">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <div class="feedback-content">
                            <h4>Admin Feedback</h4>
                            <p><c:out value="${not empty center.changesRequestedNote ? center.changesRequestedNote : center.rejectionReason}"/></p>
                        </div>
                    </div>
                </c:if>

                <!-- Submit for Verification Bar -->
                <div class="submit-bar">
                    <form action="${pageContext.request.contextPath}/centres/submitVerification" method="post">
                        <button type="submit" class="btn-submit-verification" 
                                <c:if test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${center.centreProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Submitted — Pending Admin Review
                                </c:when>
                                <c:when test="${center.centreProfileStatus == 'APPROVED'}">
                                    <i class="bi bi-patch-check-fill"></i> Profile Approved
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-send-check-fill"></i> Submit for Admin Verification
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </div>

                <!-- Section Forms Form Container -->
                <form id="profileForm" action="${pageContext.request.contextPath}/centres/updateProfile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${center.id}">

                    <!-- Section 1: Centre Identity -->
                    <div class="section-card">
                        <div class="section-header">1. Centre identity</div>
                        
                        <div class="form-group">
                            <label>1.1 Centre name *</label>
                            <input type="text" name="name" id="inputName" class="form-input" value="<c:out value='${center.name}'/>" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>1.2 Centre type *</label>
                                <select name="centreType" id="inputCentreType" class="form-select">
                                    <option value="Academy" ${center.centreType == 'Academy' ? 'selected' : ''}>Academy</option>
                                    <option value="Dojo" ${center.centreType == 'Dojo' ? 'selected' : ''}>Dojo</option>
                                    <option value="Training hall" ${center.centreType == 'Training hall' ? 'selected' : ''}>Training hall</option>
                                    <option value="Home studio" ${center.centreType == 'Home studio' ? 'selected' : ''}>Home studio</option>
                                    <option value="Community hall" ${center.centreType == 'Community hall' ? 'selected' : ''}>Community hall</option>
                                    <option value="Outdoor" ${center.centreType == 'Outdoor' ? 'selected' : ''}>Outdoor</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>1.3 Owner / manager *</label>
                                <input type="text" name="contactPerson" id="inputContactPerson" class="form-input" value="<c:out value='${center.contactPerson}'/>" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>1.4 Designation</label>
                                <select name="designation" id="inputDesignation" class="form-select">
                                    <option value="Owner" ${center.designation == 'Owner' ? 'selected' : ''}>Owner</option>
                                    <option value="Head coach" ${center.designation == 'Head coach' ? 'selected' : ''}>Head coach</option>
                                    <option value="Manager" ${center.designation == 'Manager' ? 'selected' : ''}>Manager</option>
                                    <option value="Instructor" ${center.designation == 'Instructor' ? 'selected' : ''}>Instructor</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>1.5 Official phone *</label>
                                <input type="tel" name="phone" class="form-input" value="<c:out value='${center.phoneNumber}'/>" maxlength="10" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>1.6 WhatsApp</label>
                                <input type="tel" name="whatsappNumber" class="form-input" value="<c:out value='${center.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                            </div>
                            <div class="form-group">
                                <label>1.7 Year started</label>
                                <input type="number" name="yearStarted" class="form-input" value="${center.yearStarted}" placeholder="e.g. 2018" maxlength="4">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>1.8 Affiliation</label>
                            <select name="affiliation" class="form-select">
                                <option value="None" ${center.affiliation == 'None' ? 'selected' : ''}>None</option>
                                <option value="WKF" ${center.affiliation == 'WKF' ? 'selected' : ''}>WKF (World Karate Federation)</option>
                                <option value="ITF" ${center.affiliation == 'ITF' ? 'selected' : ''}>ITF (International Taekwondo Federation)</option>
                                <option value="Shotokan" ${center.affiliation == 'Shotokan' ? 'selected' : ''}>Shotokan</option>
                                <option value="National body" ${center.affiliation == 'National body' ? 'selected' : ''}>National body</option>
                                <option value="Other" ${center.affiliation == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>

                    <!-- Section 2: Location -->
                    <div class="section-card">
                        <div class="section-header">2. Location</div>
                        <div class="form-group">
                            <label>2.1 Hall / landmark / address *</label>
                            <input type="text" name="location" id="inputLocation" class="form-input" value="<c:out value='${center.location}'/>" placeholder="Building name, street, landmark" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>2.3 City *</label>
                                <input type="text" name="city" id="inputCity" class="form-input" value="<c:out value='${center.city}'/>" placeholder="City" required>
                            </div>
                            <div class="form-group">
                                <label>2.4 State *</label>
                                <select name="state" id="inputState" class="form-select" required>
                                    <option value="Karnataka" ${center.state == 'Karnataka' ? 'selected' : ''}>Karnataka</option>
                                    <option value="Maharashtra" ${center.state == 'Maharashtra' ? 'selected' : ''}>Maharashtra</option>
                                    <option value="Delhi" ${center.state == 'Delhi' ? 'selected' : ''}>Delhi</option>
                                    <option value="Tamil Nadu" ${center.state == 'Tamil Nadu' ? 'selected' : ''}>Tamil Nadu</option>
                                    <option value="Telangana" ${center.state == 'Telangana' ? 'selected' : ''}>Telangana</option>
                                    <option value="Andhra Pradesh" ${center.state == 'Andhra Pradesh' ? 'selected' : ''}>Andhra Pradesh</option>
                                    <option value="Kerala" ${center.state == 'Kerala' ? 'selected' : ''}>Kerala</option>
                                    <option value="Gujarat" ${center.state == 'Gujarat' ? 'selected' : ''}>Gujarat</option>
                                    <option value="Other" ${center.state == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>2.5 Pincode *</label>
                                <input type="text" name="pincode" class="form-input" value="<c:out value='${center.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required>
                            </div>
                            <div class="form-group">
                                <label>2.6 Google Maps location link</label>
                                <input type="url" name="mapLink" class="form-input" value="<c:out value='${center.googleMapLocation}'/>" placeholder="https://maps.app.goo.gl/...">
                            </div>
                        </div>
                    </div>

                    <!-- Section 3: Styles Taught -->
                    <div class="section-card">
                        <div class="section-header">3. Styles taught *</div>
                        <p style="font-size: 0.8rem; color: var(--text-gray); margin-bottom: 8px;">Select all martial arts programs offered at your centre:</p>
                        <div class="chips-container">
                            <c:forEach var="style" items="${['Karate', 'Taekwondo', 'Judo', 'Kung Fu', 'Self-Defence', 'MMA', 'Boxing', 'Kickboxing', 'Muay Thai', 'Krav Maga', 'Aikido', 'Kalaripayattu', 'Wrestling', 'Jiu-Jitsu']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="styles" class="style-checkbox" value="${style}" ${center.stylesTaught != null && center.stylesTaught.contains(style) ? 'checked' : ''}>
                                    <span class="chip-label">${style}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 4: Who Can Join -->
                    <div class="section-card">
                        <div class="section-header">4. Who can join</div>
                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">4.1 Target Audience *</label>
                        <div class="chips-container" style="margin-bottom: 16px;">
                            <c:forEach var="aud" items="${['Women', 'Girls (under 16)', 'Mixed', 'Men']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="audience" class="aud-checkbox" value="${aud}" ${center.audience != null && center.audience.contains(aud) ? 'checked' : ''}>
                                    <span class="chip-label">${aud}</span>
                                </label>
                            </c:forEach>
                        </div>

                        <div class="toggle-row">
                            <span class="toggle-label">4.2 Women-only batches</span>
                            <label class="toggle-switch">
                                <input type="checkbox" name="womenOnly" id="inputWomenOnly" value="true" ${center.womenOnlyBatches == true ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="toggle-row">
                            <span class="toggle-label">4.3 Female instructor available</span>
                            <label class="toggle-switch">
                                <input type="checkbox" name="femaleInstructor" id="inputFemaleInstructor" value="true" ${center.femaleInstructor == true ? 'checked' : ''}>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy); margin-top: 14px; display: block;">4.4 Age groups</label>
                        <div class="chips-container">
                            <c:forEach var="age" items="${['Kids 6–12', 'Teens 13–17', 'Adults 18+', '40+']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="ageGroups" value="${age}" ${center.ageGroups != null && center.ageGroups.contains(age) ? 'checked' : ''}>
                                    <span class="chip-label">${age}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 5: Facilities -->
                    <div class="section-card">
                        <div class="section-header">5. Facilities & Amenities</div>
                        <div class="chips-container">
                            <c:forEach var="fac" items="${['Mats', 'Changing room', 'Washroom', 'Drinking water', 'CCTV', 'First-aid', 'Parking', 'AC', 'Women-only hours', 'Beginner-friendly']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="facilities" class="fac-checkbox" value="${fac}" ${center.facilities != null && center.facilities.contains(fac) ? 'checked' : ''}>
                                    <span class="chip-label">${fac}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 6: Hours & Calendar -->
                    <div class="section-card">
                        <div class="section-header">6. Hours & calendar</div>
                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">6.1 Open days *</label>
                        <div class="chips-container" style="margin-bottom: 14px;">
                            <c:forEach var="day" items="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="availableDays" class="day-checkbox" value="${day}">
                                    <span class="chip-label">${day.substring(0, 3)}</span>
                                </label>
                            </c:forEach>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>6.2 Open time *</label>
                                <input type="time" name="openTime" id="inputOpenTime" class="form-input" value="${center.openTime != null ? center.openTime : '06:00'}" required>
                            </div>
                            <div class="form-group">
                                <label>6.3 Close time *</label>
                                <input type="time" name="closeTime" id="inputCloseTime" class="form-input" value="${center.closeTime != null ? center.closeTime : '21:00'}" required>
                            </div>
                        </div>
                    </div>

                    <!-- Section 7: About the Centre -->
                    <div class="section-card">
                        <div class="section-header">7. About the centre</div>
                        <div class="form-group">
                            <label>7.1 About the centre *</label>
                            <textarea name="about" id="inputAbout" class="form-textarea" rows="4" placeholder="Describe your training ethos, instructors, and environment..."><c:out value="${center.about}"/></textarea>
                        </div>
                        <div class="form-group">
                            <label>7.2 How we teach *</label>
                            <textarea name="howWeTeach" class="form-textarea" rows="3" placeholder="Explain your teaching methodology, step-by-step progress..."><c:out value="${center.howWeTeach}"/></textarea>
                        </div>
                        <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">7.3 What we offer *</label>
                        <div class="chips-container">
                            <c:forEach var="offer" items="${['Regular class', 'Trial class', 'Belt grading', 'Workshops', 'Self-defence crash course']}">
                                <label class="chip-checkbox">
                                    <input type="checkbox" name="offers" value="${offer}" ${center.whatWeOffer != null && center.whatWeOffer.contains(offer) ? 'checked' : ''}>
                                    <span class="chip-label">${offer}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Section 9: Payout & Finance -->
                    <div class="section-card">
                        <div class="section-header">9. Payout details</div>
                        <div class="form-group">
                            <label>9.1 UPI ID (for direct payout)</label>
                            <input type="text" name="upiId" class="form-input" value="<c:out value='${center.upiId}'/>" placeholder="centre@upi">
                        </div>
                        <div class="form-group">
                            <label>9.2 Bank details</label>
                            <textarea name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, Bank, IFSC Code"><c:out value="${center.bankDetails}"/></textarea>
                        </div>
                    </div>

                    <!-- Section 10: Documents (Optional) -->
                    <div class="section-card">
                        <div class="section-header">10. Documents & Certificates</div>
                        <div class="form-group">
                            <label>10.1 Profile Photo (Logo / Main image)</label>
                            <input type="file" name="profilePhotoFile" id="inputProfilePhoto" class="form-input" accept="image/*" onchange="previewSelectedPhoto(this)">
                        </div>
                        <div class="form-group">
                            <label>10.2 Trainer Certificate / Registration Proof</label>
                            <input type="file" name="certificateFile" class="form-input" accept=".pdf,image/*">
                        </div>
                    </div>

                    <!-- Section 11: Centre Gallery Photos -->
                    <div class="section-card">
                        <div class="section-header">11. Centre photos</div>
                        <div class="form-group">
                            <label>11.1 Gallery Photos (Dojo, mats, training equipment)</label>
                            <input type="file" name="galleryFiles" id="inputGalleryFiles" class="form-input" accept="image/*" multiple onchange="previewSelectedGallery(this)">
                        </div>
                    </div>

                    <div class="bottom-actions">
                        <button type="submit" class="btn-bottom-save">Save Profile Details</button>
                    </div>
                </form>
            </div>

            <!-- RIGHT: Live Centre Profile Preview Column -->
            <div class="preview-column">
                <div class="preview-sticky-wrap">
                    <div class="live-preview-card">
                        <div class="preview-banner-header">
                            <div class="d-flex align-items-center gap-2">
                                <span class="preview-badge-live"><i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> LIVE PREVIEW</span>
                            </div>
                            <span style="font-size: 0.75rem; font-weight: 700; color: #CBD5E1;">CENTRE PROFILE</span>
                        </div>
                        <div class="preview-body">
                            <!-- Avatar & Centre Identity -->
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="preview-avatar-box">
                                    <c:choose>
                                        <c:when test="${not empty center.profilePhoto}">
                                            <img id="previewPhotoImg" src="${pageContext.request.contextPath}${center.profilePhoto}" class="preview-avatar-img" alt="Centre Logo">
                                            <div id="previewPhotoFallback" class="preview-avatar-fallback d-none" style="display:none;">
                                                <c:out value="${not empty center.name ? center.name.substring(0,1).toUpperCase() : 'M'}"/>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="previewPhotoFallback" class="preview-avatar-fallback">
                                                <c:out value="${not empty center.name ? center.name.substring(0,1).toUpperCase() : 'M'}"/>
                                            </div>
                                            <img id="previewPhotoImg" src="" class="preview-avatar-img d-none" alt="Centre Logo" style="display:none;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="flex: 1; min-width: 0;">
                                    <div class="d-flex align-items-center gap-1">
                                        <h5 id="previewName" class="fw-bold mb-0 text-truncate" style="color: var(--navy); font-size: 1.1rem;">
                                            <c:out value="${not empty center.name ? center.name : 'Centre Name'}"/>
                                        </h5>
                                        <i class="bi bi-patch-check-fill" style="color: #10B981; font-size: 1rem;" title="Verified Martial Arts Centre"></i>
                                    </div>
                                    <p class="small mb-1 text-truncate" style="color: var(--primary); font-weight: 700;">
                                        <span id="previewContact">${not empty center.contactPerson ? center.contactPerson : 'Head Coach'}</span>
                                        <small class="text-muted fw-normal">&bull; <span id="previewDesignation">${not empty center.designation ? center.designation : 'Instructor'}</span></small>
                                    </p>
                                    <div class="text-muted" style="font-size: 0.75rem;">
                                        <i class="bi bi-geo-alt-fill me-1" style="color: var(--primary) !important;"></i>
                                        <span id="previewCity">${not empty center.city ? center.city : 'City'}</span>, <span id="previewState">${not empty center.state ? center.state : 'State'}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Operating Hours & Type Highlight -->
                            <div class="preview-meta-row justify-content-between">
                                <div>
                                    <span class="text-muted small d-block">Operating Timings</span>
                                    <strong id="previewHours" style="color: var(--navy); font-size: 0.88rem;">${center.openTime != null ? center.openTime : '06:00'} - ${center.closeTime != null ? center.closeTime : '21:00'}</strong>
                                </div>
                                <div class="text-end">
                                    <span class="text-muted small d-block">Centre Type</span>
                                    <strong id="previewTypeBadge" style="color: var(--navy); font-size: 0.88rem;">${not empty center.centreType ? center.centreType : 'Academy'}</strong>
                                </div>
                            </div>

                            <!-- Highlights & Badges -->
                            <div class="preview-meta-row">
                                <i class="bi bi-shield-check"></i>
                                <div>
                                    <span class="text-muted d-block" style="font-size: 0.72rem;">Training Environment</span>
                                    <span id="previewWomenOnlyBadge" class="badge bg-light border text-dark ms-1" style="font-size: 0.68rem; ${center.womenOnlyBatches == true ? '' : 'display:none;'}">
                                        <i class="bi bi-gender-female text-danger me-1"></i> Women-Only Batches
                                    </span>
                                    <span id="previewFemaleInstBadge" class="badge bg-light border text-dark ms-1" style="font-size: 0.68rem; ${center.femaleInstructor == true ? '' : 'display:none;'}">
                                        <i class="bi bi-person-check-fill text-success me-1"></i> Female Instructor
                                    </span>
                                </div>
                            </div>

                            <!-- Martial Arts Programs / Styles -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Programs &amp; Styles</span>
                                <div id="previewStylesContainer" class="d-flex flex-wrap">
                                    <c:choose>
                                        <c:when test="${not empty center.stylesTaught}">
                                            <c:forEach var="st" items="${center.stylesTaught.split(',')}">
                                                <span class="preview-chip">${st.trim()}</span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="preview-chip">Karate</span>
                                            <span class="preview-chip">Self-Defence</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Target Audience -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Who Can Join</span>
                                <div id="previewAudienceContainer" class="d-flex flex-wrap">
                                    <c:choose>
                                        <c:when test="${not empty center.audience}">
                                            <c:forEach var="aud" items="${center.audience.split(',')}">
                                                <span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">${aud.trim()}</span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">Women &amp; Girls</span>
                                            <span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">Beginners</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- About / Ethos -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">About Centre</span>
                                <p id="previewAboutText" class="small text-muted mb-0" style="line-height: 1.4; max-height: 80px; overflow-y: auto;">
                                    ${not empty center.about ? center.about : 'Professional martial arts academy dedicated to self-defense empowerment, disciplined belt grading, and structured physical fitness.'}
                                </p>
                            </div>

                            <!-- Facilities & Amenities -->
                            <div id="previewFacilitiesWrap" class="mb-3" style="${not empty center.facilities ? '' : 'display:none;'}">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Dojo Facilities</span>
                                <div id="previewFacilitiesContainer" class="d-flex flex-wrap">
                                    <c:if test="${not empty center.facilities}">
                                        <c:forEach var="fac" items="${center.facilities.split(',')}">
                                            <span class="badge bg-white border text-secondary me-1 mb-1" style="font-size: 0.7rem;"><i class="bi bi-check-circle text-success me-1"></i>${fac.trim()}</span>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Gallery Thumbnails Strip -->
                            <div id="previewGalleryWrap" class="mb-2" style="${not empty center.galleryPhotos and center.galleryPhotos.size() > 0 ? '' : 'display:none;'}">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Dojo Photos</span>
                                <div id="previewGalleryContainer" class="d-flex flex-wrap gap-2">
                                    <c:forEach var="photo" items="${center.galleryPhotos}">
                                        <img src="${pageContext.request.contextPath}${photo}" style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover; border: 1px solid #FECDD3;" alt="Dojo Photo">
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="mt-3 pt-3 border-top text-center">
                                <small class="text-muted"><i class="bi bi-shield-lock-fill text-success me-1"></i> Public client preview &bull; Updates live as you type</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Real-Time Martial Arts Live-Sync Engine -->
    <script>
        function bindMartialArtsLivePreview() {
            const inputName = document.getElementById('inputName');
            const inputCentreType = document.getElementById('inputCentreType');
            const inputContactPerson = document.getElementById('inputContactPerson');
            const inputDesignation = document.getElementById('inputDesignation');
            const inputCity = document.getElementById('inputCity');
            const inputState = document.getElementById('inputState');
            const inputOpenTime = document.getElementById('inputOpenTime');
            const inputCloseTime = document.getElementById('inputCloseTime');
            const inputAbout = document.getElementById('inputAbout');
            const inputWomenOnly = document.getElementById('inputWomenOnly');
            const inputFemaleInstructor = document.getElementById('inputFemaleInstructor');

            if (inputName) {
                inputName.addEventListener('input', function() {
                    document.getElementById('previewName').textContent = this.value.trim() || 'Centre Name';
                    const fallback = document.getElementById('previewPhotoFallback');
                    if (fallback) fallback.textContent = (this.value.trim() || 'M').charAt(0).toUpperCase();
                });
            }

            if (inputCentreType) {
                inputCentreType.addEventListener('change', function() {
                    document.getElementById('previewTypeBadge').textContent = this.value || 'Academy';
                });
            }

            if (inputContactPerson) {
                inputContactPerson.addEventListener('input', function() {
                    document.getElementById('previewContact').textContent = this.value.trim() || 'Head Coach';
                });
            }

            if (inputDesignation) {
                inputDesignation.addEventListener('change', function() {
                    document.getElementById('previewDesignation').textContent = this.value || 'Instructor';
                });
            }

            if (inputCity) {
                inputCity.addEventListener('input', function() {
                    document.getElementById('previewCity').textContent = this.value.trim() || 'City';
                });
            }

            if (inputState) {
                inputState.addEventListener('change', function() {
                    document.getElementById('previewState').textContent = this.value || 'State';
                });
            }

            function updateHours() {
                const open = inputOpenTime ? inputOpenTime.value : '06:00';
                const close = inputCloseTime ? inputCloseTime.value : '21:00';
                document.getElementById('previewHours').textContent = open + ' - ' + close;
            }

            if (inputOpenTime) inputOpenTime.addEventListener('input', updateHours);
            if (inputCloseTime) inputCloseTime.addEventListener('input', updateHours);

            if (inputAbout) {
                inputAbout.addEventListener('input', function() {
                    document.getElementById('previewAboutText').textContent = this.value.trim() || 'Professional martial arts academy dedicated to self-defense empowerment, disciplined belt grading, and structured physical fitness.';
                });
            }

            if (inputWomenOnly) {
                inputWomenOnly.addEventListener('change', function() {
                    document.getElementById('previewWomenOnlyBadge').style.display = this.checked ? 'inline-block' : 'none';
                });
            }

            if (inputFemaleInstructor) {
                inputFemaleInstructor.addEventListener('change', function() {
                    document.getElementById('previewFemaleInstBadge').style.display = this.checked ? 'inline-block' : 'none';
                });
            }

            // Styles Checkboxes
            document.querySelectorAll('.style-checkbox').forEach(function(cb) {
                cb.addEventListener('change', function() {
                    const container = document.getElementById('previewStylesContainer');
                    const checked = Array.from(document.querySelectorAll('.style-checkbox:checked')).map(c => c.value);
                    container.innerHTML = '';
                    if (checked.length === 0) {
                        container.innerHTML = '<span class="preview-chip">Martial Arts</span>';
                    } else {
                        checked.forEach(function(val) {
                            const span = document.createElement('span');
                            span.className = 'preview-chip';
                            span.textContent = val;
                            container.appendChild(span);
                        });
                    }
                });
            });

            // Target Audience Checkboxes
            document.querySelectorAll('.aud-checkbox').forEach(function(cb) {
                cb.addEventListener('change', function() {
                    const container = document.getElementById('previewAudienceContainer');
                    const checked = Array.from(document.querySelectorAll('.aud-checkbox:checked')).map(c => c.value);
                    container.innerHTML = '';
                    if (checked.length === 0) {
                        container.innerHTML = '<span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">All Students</span>';
                    } else {
                        checked.forEach(function(val) {
                            const span = document.createElement('span');
                            span.className = 'badge bg-light border text-dark me-1 mb-1';
                            span.style.fontSize = '0.72rem';
                            span.textContent = val;
                            container.appendChild(span);
                        });
                    }
                });
            });

            // Facilities Checkboxes
            document.querySelectorAll('.fac-checkbox').forEach(function(cb) {
                cb.addEventListener('change', function() {
                    const wrap = document.getElementById('previewFacilitiesWrap');
                    const container = document.getElementById('previewFacilitiesContainer');
                    const checked = Array.from(document.querySelectorAll('.fac-checkbox:checked')).map(c => c.value);
                    container.innerHTML = '';
                    if (checked.length === 0) {
                        wrap.style.display = 'none';
                    } else {
                        wrap.style.display = 'block';
                        checked.forEach(function(val) {
                            const span = document.createElement('span');
                            span.className = 'badge bg-white border text-secondary me-1 mb-1';
                            span.style.fontSize = '0.7rem';
                            span.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>' + val;
                            container.appendChild(span);
                        });
                    }
                });
            });
        }

        function previewSelectedPhoto(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.getElementById('previewPhotoImg');
                    const fallback = document.getElementById('previewPhotoFallback');
                    if (img) {
                        img.src = e.target.result;
                        img.classList.remove('d-none');
                        img.style.display = 'block';
                    }
                    if (fallback) {
                        fallback.classList.add('d-none');
                        fallback.style.display = 'none';
                    }
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewSelectedGallery(input) {
            const wrap = document.getElementById('previewGalleryWrap');
            const container = document.getElementById('previewGalleryContainer');
            if (input.files && input.files.length > 0) {
                container.innerHTML = '';
                wrap.style.display = 'block';
                Array.from(input.files).slice(0, 5).forEach(function(file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.style.cssText = 'width: 50px; height: 50px; border-radius: 8px; object-fit: cover; border: 1px solid #FECDD3;';
                        container.appendChild(img);
                    };
                    reader.readAsDataURL(file);
                });
            }
        }

        document.addEventListener('DOMContentLoaded', bindMartialArtsLivePreview);
    </script>

</body>
</html>
