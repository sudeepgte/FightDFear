<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
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

        /* Live Profile Preview Card Styling */
        .preview-sticky-wrap {
            position: sticky;
            top: 80px;
            z-index: 20;
        }

        .live-preview-card {
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid #FECDD3;
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.08);
            overflow: hidden;
        }

        .preview-banner-header {
            background: linear-gradient(135deg, #FFE4E6 0%, #FFF1F2 100%);
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #FECDD3;
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
            padding: 24px 20px;
        }

        .preview-avatar-box {
            position: relative;
            width: 80px;
            height: 80px;
            margin-bottom: 12px;
        }

        .preview-avatar-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #FECDD3;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.12);
        }

        .preview-avatar-fallback {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--rose-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            border: 3px solid #FECDD3;
        }

        .preview-chip {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            background: #FFF1F2;
            color: #E11D48;
            border: 1px solid #FECDD3;
            margin-right: 4px;
            margin-bottom: 4px;
        }

        .preview-meta-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 12px;
            background: #F8FAFC;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            margin-bottom: 8px;
            font-size: 0.82rem;
        }

        .preview-meta-row i {
            color: var(--primary);
            font-size: 1rem;
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
            .form-row { grid-template-columns: 1fr; }
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
        <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear Coach Studio
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/fitness/trainer/dashboard" class="btn-skip">Skip for now</a>
            <button type="button" class="btn-header-save" onclick="document.getElementById('trainerProfileForm').submit()">Save Profile</button>
        </div>
    </header>



    <main class="main-container">
        <div class="profile-layout-grid">
            <!-- LEFT: 11 Form Sections Column -->
            <div class="form-column">
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
                    <form action="${pageContext.request.contextPath}/fitness/trainer/submitVerification" method="post">
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

                <form id="trainerProfileForm" action="${pageContext.request.contextPath}/fitness/trainer/updateProfile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${trainer.id}">

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
                            <input type="text" name="upiId" class="form-input" value="<c:out value='${trainer.upiId}'/>" placeholder="coach@upi">
                        </div>
                        <div class="form-group">
                            <label>9.2 Bank details</label>
                            <textarea name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, IFSC"><c:out value="${trainer.bankDetails}"/></textarea>
                        </div>
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
                        <button type="submit" class="btn-bottom-save">Save Coach Profile</button>
                    </div>
                </form>
            </div>

            <!-- RIGHT: Profile Live Preview Column -->
            <div class="preview-column">
                <div class="preview-sticky-wrap">
                    <div class="live-preview-card">
                        <div class="preview-banner-header">
                            <div class="d-flex align-items-center gap-2">
                                <span class="preview-badge-live"><i class="bi bi-circle-fill" style="font-size: 0.45rem;"></i> LIVE PREVIEW</span>
                            </div>
                            <span style="font-size: 0.75rem; font-weight: 700; color: var(--navy); opacity: 0.7;">STUDIO PROFILE</span>
                        </div>
                        <div class="preview-body">
                            <!-- Avatar & Basic Details -->
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="preview-avatar-box">
                                    <c:choose>
                                        <c:when test="${not empty trainer.profilePhotoPath}">
                                            <img id="previewPhoto" src="${trainer.profilePhotoPath}" class="preview-avatar-img" alt="Trainer Profile">
                                            <div id="previewPhotoFallback" class="preview-avatar-fallback d-none" style="display:none;">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div id="previewPhotoFallback" class="preview-avatar-fallback">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <img id="previewPhoto" src="" class="preview-avatar-img d-none" alt="Trainer Profile" style="display:none;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div style="flex: 1; min-width: 0;">
                                    <div class="d-flex align-items-center gap-1">
                                        <h5 id="previewFullName" class="fw-bold mb-0 text-truncate" style="color: var(--navy); font-size: 1.05rem;">
                                            ${not empty trainer.fullName ? trainer.fullName : 'Trainer Name'}
                                        </h5>
                                        <i class="bi bi-patch-check-fill" style="color: #10B981; font-size: 1rem;" title="Verified Coach"></i>
                                    </div>
                                    <p id="previewDesignation" class="small mb-1 text-truncate" style="color: var(--primary); font-weight: 600;">
                                        ${not empty trainer.designation ? trainer.designation : 'Certified Fitness Coach'}
                                    </p>
                                    <div id="previewMetaLocation" class="text-muted" style="font-size: 0.75rem;">
                                        <i class="bi bi-geo-alt-fill me-1" style="color: var(--primary) !important;"></i>
                                        <span id="previewCity">${not empty trainer.city ? trainer.city : 'City'}</span>, <span id="previewState">${not empty trainer.state ? trainer.state : 'State'}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Pricing & Experience Highlight -->
                            <div class="preview-meta-row justify-content-between">
                                <div>
                                    <span class="text-muted small d-block">Session Fee</span>
                                    <strong id="previewFee" style="color: var(--navy); font-size: 0.95rem;">₹${trainer.typicalPrice != null ? trainer.typicalPrice : (trainer.sessionFees != null ? trainer.sessionFees : 300)}</strong> <small class="text-muted">/ <span id="previewDuration">${trainer.durationMinutes != null ? trainer.durationMinutes : 60}</span>m</small>
                                </div>
                                <div class="text-end">
                                    <span class="text-muted small d-block">Experience</span>
                                    <strong id="previewExp" style="color: var(--navy); font-size: 0.95rem;">${trainer.experience != null ? trainer.experience : 1} Years</strong>
                                </div>
                            </div>

                            <!-- Session Mode & Doorstep -->
                            <div class="preview-meta-row">
                                <i class="bi bi-broadcast"></i>
                                <div>
                                    <span class="text-muted d-block" style="font-size: 0.72rem;">Training Mode &amp; Delivery</span>
                                    <span id="previewMode" class="fw-semibold" style="color: var(--navy);">${not empty trainer.sessionMode ? trainer.sessionMode : 'In-Person Studio'}</span>
                                    <span id="previewDoorstepBadge" class="badge bg-light border text-dark ms-1" style="font-size: 0.68rem; ${trainer.doorService == true ? '' : 'display:none;'}">
                                        <i class="bi bi-house-door-fill text-danger me-1" style="color: var(--primary) !important;"></i> Doorstep
                                    </span>
                                </div>
                            </div>

                            <!-- Specializations -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Specializations</span>
                                <div id="previewSpecsContainer" class="d-flex flex-wrap">
                                    <c:choose>
                                        <c:when test="${not empty trainer.specializations}">
                                            <c:forEach var="spec" items="${trainer.specializations}">
                                                <span class="preview-chip">${spec}</span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="preview-chip">Weight Loss</span>
                                            <span class="preview-chip">Strength Training</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Target Audience -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Target Audience</span>
                                <div id="previewAudienceContainer" class="d-flex flex-wrap">
                                    <c:choose>
                                        <c:when test="${not empty trainer.audience}">
                                            <c:forEach var="aud" items="${trainer.audience}">
                                                <span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">${aud}</span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">All Fitness Levels</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- About / Bio Snippet -->
                            <div class="mb-3">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">About Coach</span>
                                <p id="previewBioText" class="small text-muted mb-0" style="line-height: 1.4; max-height: 80px; overflow-y: auto;">
                                    ${not empty trainer.bio ? trainer.bio : 'Personalized coaching philosophy, nutrition guidance, and progressive workout regimens designed for guaranteed client transformation.'}
                                </p>
                            </div>

                            <!-- Studio Facilities -->
                            <div id="previewFacilitiesWrap" class="mb-2" style="${not empty trainer.facilities ? '' : 'display:none;'}">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Studio Amenities</span>
                                <div id="previewFacilitiesContainer" class="d-flex flex-wrap">
                                    <c:forEach var="fac" items="${trainer.facilities}">
                                        <span class="badge bg-white border text-secondary me-1 mb-1" style="font-size: 0.7rem;"><i class="bi bi-check-circle text-success me-1"></i>${fac}</span>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Studio Gallery Preview Thumbnails -->
                            <div id="previewGalleryWrap" class="mb-2" style="display:none;">
                                <span class="d-block mb-1 text-muted" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Gallery Thumbnails</span>
                                <div id="previewGalleryContainer" class="d-flex flex-wrap gap-2"></div>
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

    <!-- Real-time Profile Live-Sync Engine -->
    <script>
        function bindLivePreview() {
            const inputFullName = document.getElementById('inputFullName');
            const inputDesignation = document.getElementById('inputDesignation');
            const inputExperience = document.getElementById('inputExperience');
            const inputCity = document.getElementById('inputCity');
            const inputState = document.getElementById('inputState');
            const inputBio = document.getElementById('inputBio');
            const inputSessionMode = document.getElementById('inputSessionMode');
            const inputSessionDuration = document.getElementById('inputSessionDuration');
            const inputSessionFees = document.getElementById('inputSessionFees');
            const inputDoorstep = document.getElementById('inputDoorstep');

            if (inputFullName) {
                inputFullName.addEventListener('input', function() {
                    document.getElementById('previewFullName').textContent = this.value.trim() || 'Trainer Name';
                });
            }

            if (inputDesignation) {
                inputDesignation.addEventListener('change', function() {
                    document.getElementById('previewDesignation').textContent = this.value || 'Certified Fitness Coach';
                });
            }

            if (inputExperience) {
                inputExperience.addEventListener('input', function() {
                    document.getElementById('previewExp').textContent = (this.value || '1') + ' Years';
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

            if (inputBio) {
                inputBio.addEventListener('input', function() {
                    document.getElementById('previewBioText').textContent = this.value.trim() || 'Personalized coaching philosophy, nutrition guidance, and progressive workout regimens.';
                });
            }

            if (inputSessionMode) {
                inputSessionMode.addEventListener('change', function() {
                    document.getElementById('previewMode').textContent = this.value || 'In-Person Studio';
                });
            }

            if (inputSessionDuration) {
                inputSessionDuration.addEventListener('change', function() {
                    document.getElementById('previewDuration').textContent = this.value || '60';
                });
            }

            if (inputSessionFees) {
                inputSessionFees.addEventListener('input', function() {
                    document.getElementById('previewFee').textContent = '₹' + (this.value || '0');
                });
            }

            if (inputDoorstep) {
                inputDoorstep.addEventListener('change', function() {
                    document.getElementById('previewDoorstepBadge').style.display = this.checked ? 'inline-block' : 'none';
                });
            }

            // Specialization Checkboxes
            document.querySelectorAll('.spec-checkbox').forEach(function(cb) {
                cb.addEventListener('change', function() {
                    const container = document.getElementById('previewSpecsContainer');
                    const checked = Array.from(document.querySelectorAll('.spec-checkbox:checked')).map(c => c.value);
                    container.innerHTML = '';
                    if (checked.length === 0) {
                        container.innerHTML = '<span class="preview-chip">General Fitness</span>';
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
                        container.innerHTML = '<span class="badge bg-light border text-dark me-1 mb-1" style="font-size: 0.72rem;">All Fitness Levels</span>';
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

            // Studio Facilities Checkboxes
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
                    const img = document.getElementById('previewPhoto');
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
                Array.from(input.files).slice(0, 4).forEach(function(file) {
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

        document.addEventListener('DOMContentLoaded', bindLivePreview);
    </script>


</body>
</html>
