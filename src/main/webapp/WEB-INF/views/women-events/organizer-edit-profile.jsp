<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Host Profile — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">
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
            font-family: 'Outfit', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
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
            padding: 8px 16px;
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
            max-width: 760px;
            width: 100%;
            margin: 20px auto 40px;
            padding: 0 16px;
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
            flex: 1;
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

        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-error { background: var(--error-bg); border: 1px solid #FECACA; color: var(--error); }
        .alert-success { background: var(--success-bg); border: 1px solid #BBF7D0; color: var(--success); }
    </style>
</head>
<body>

    <header class="app-header">
        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="header-brand">
            <i class="bi bi-shield-heart-fill"></i> Fight D Fear Event Host Studio
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="btn-skip">Skip for now</a>
            <button type="button" class="btn-header-save" onclick="saveProfile()">Save Profile</button>
        </div>
    </header>

    <main class="main-container">

        <c:set var="statusStr" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus.name() : 'PROFILE_INCOMPLETE'}"/>

        <div class="profile-progress-card">
            <div class="progress-header">
                <span class="progress-title">Host Profile Completion: <span id="pctText">${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%</span></span>
                <c:choose>
                    <c:when test="${statusStr eq 'APPROVED'}">
                        <span class="status-badge badge-approved">Approved</span>
                    </c:when>
                    <c:when test="${statusStr eq 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes">Changes Requested</span>
                    </c:when>
                    <c:when test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending">Under Review</span>
                    </c:when>
                    <c:when test="${statusStr eq 'REJECTED'}">
                        <span class="status-badge badge-rejected">Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered">Registered</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="progress-bar-container">
                <div class="progress-bar-fill" id="progressBarFill" style="width: ${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%;"></div>
            </div>
            <p style="font-size: 0.8rem; color: var(--text-gray);">
                Complete all mandatory fields across 11 sections to submit your application for Admin Verification.
            </p>
        </div>

        <c:if test="${not empty host.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Feedback</h4>
                    <p><c:out value="${host.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty host.changesRequestedNote}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-circle-fill"></i>
                <div class="feedback-content">
                    <h4>Changes Requested by Admin</h4>
                    <p><c:out value="${host.changesRequestedNote}"/></p>
                </div>
            </div>
        </c:if>

        <div id="alertBox" class="alert-box alert-error" style="display: none;"></div>

        <div class="submit-bar">
            <button type="button" id="btnSubmitVerification" class="btn-submit-verification" onclick="submitForVerification()"
                    <c:if test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                <c:choose>
                    <c:when test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">
                        <i class="bi bi-clock-history"></i> Profile Submitted — Pending Admin Review
                    </c:when>
                    <c:when test="${statusStr eq 'APPROVED'}">
                        <i class="bi bi-speedometer2"></i> Host Verified & Approved — Go to Dashboard <i class="bi bi-arrow-right-short"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-send-check-fill"></i> Submit Host Profile for Verification
                    </c:otherwise>
                </c:choose>
            </button>
        </div>

        <form id="hostProfileForm" onsubmit="saveProfile(event)">
            
            <!-- Section 1: Host Identity -->
            <div class="section-card">
                <div class="section-header">1. Host Identity & Organization</div>
                <div class="form-group">
                    <label>1.1 Full name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" value="<c:out value='${host.fullName}'/>" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>1.2 Organization type *</label>
                        <select id="organizerType" name="organizerType" class="form-select" required>
                            <option value="NGO" ${host.organizerType eq 'NGO' ? 'selected' : ''}>NGO</option>
                            <option value="Company" ${host.organizerType eq 'Company' ? 'selected' : ''}>Company</option>
                            <option value="Educational Institution" ${host.organizerType eq 'Educational Institution' ? 'selected' : ''}>Educational Institution</option>
                            <option value="Government Department" ${host.organizerType eq 'Government Department' ? 'selected' : ''}>Government Department</option>
                            <option value="Community Organization" ${host.organizerType eq 'Community Organization' ? 'selected' : ''}>Community Organization</option>
                            <option value="Women Self Help Group" ${host.organizerType eq 'Women Self Help Group' ? 'selected' : ''}>Women Self Help Group</option>
                            <option value="Startup" ${host.organizerType eq 'Startup' ? 'selected' : ''}>Startup</option>
                            <option value="Fitness Organization" ${host.organizerType eq 'Fitness Organization' ? 'selected' : ''}>Fitness Organization</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.3 Official phone *</label>
                        <input type="tel" id="phone" name="phone" class="form-input" value="<c:out value='${host.phone}'/>" maxlength="10" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>1.4 Organization name *</label>
                        <input type="text" id="organizerName" name="organizerName" class="form-input" value="<c:out value='${host.organizerName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label>1.5 WhatsApp contact</label>
                        <input type="tel" id="whatsappNumber" name="whatsappNumber" class="form-input" value="<c:out value='${host.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>1.6 Reg / GST / NGO Credential Number *</label>
                        <input type="text" id="credentialNumber" name="credentialNumber" class="form-input" value="<c:out value='${host.credentialNumber}'/>" placeholder="Registration Number" required>
                    </div>
                    <div class="form-group">
                        <label>1.7 Years of experience *</label>
                        <input type="number" id="yearsExperience" name="yearsExperience" class="form-input" value="${host.yearsExperience != null ? host.yearsExperience : 1}" min="0" max="50" required>
                    </div>
                </div>
            </div>

            <!-- Section 2: Location -->
            <div class="section-card">
                <div class="section-header">2. Location</div>
                <div class="form-group">
                    <label>2.1 Street Address / Venue Base *</label>
                    <input type="text" id="address" name="address" class="form-input" value="<c:out value='${host.officeAddress}'/>" placeholder="Office / Venue address" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>2.2 City *</label>
                        <input type="text" id="city" name="city" class="form-input" value="<c:out value='${host.city}'/>" placeholder="City" required>
                    </div>
                    <div class="form-group">
                        <label>2.3 State *</label>
                        <select id="stateSelect" name="state" class="form-select" required>
                            <option value="Karnataka" ${host.state eq 'Karnataka' ? 'selected' : ''}>Karnataka</option>
                            <option value="Maharashtra" ${host.state eq 'Maharashtra' ? 'selected' : ''}>Maharashtra</option>
                            <option value="Delhi" ${host.state eq 'Delhi' ? 'selected' : ''}>Delhi</option>
                            <option value="Tamil Nadu" ${host.state eq 'Tamil Nadu' ? 'selected' : ''}>Tamil Nadu</option>
                            <option value="Telangana" ${host.state eq 'Telangana' ? 'selected' : ''}>Telangana</option>
                            <option value="Kerala" ${host.state eq 'Kerala' ? 'selected' : ''}>Kerala</option>
                            <option value="Other" ${host.state eq 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>2.4 Pincode *</label>
                        <input type="text" id="pincode" name="pincode" class="form-input" value="<c:out value='${host.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required>
                    </div>
                    <div class="form-group">
                        <label>2.5 Google Maps link</label>
                        <input type="url" id="mapsLocation" name="mapsLocation" class="form-input" value="<c:out value='${host.website}'/>" placeholder="https://maps.app.goo.gl/...">
                    </div>
                </div>
            </div>

            <!-- Section 3: Event Categories -->
            <div class="section-card">
                <div class="section-header">3. Event Categories Offered *</div>
                <div class="chips-container">
                    <c:forEach var="cat" items="${['Health & Wellness', 'Entrepreneurship & Career', 'Fitness & Sports', 'Education & Skills', 'Social & Community', 'Safety & Awareness']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" class="cb-category" value="${cat}" ${host.eventCategories != null && host.eventCategories.contains(cat) ? 'checked' : ''}>
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
                    <c:forEach var="aud" items="${['Women Only', 'College Girls', 'Working Professionals', 'Mothers & Homemakers', 'Senior Citizens']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" class="cb-audience" value="${aud}" ${host.audience != null && host.audience.contains(aud) ? 'checked' : ''}>
                            <span class="chip-label">${aud}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="toggle-row">
                    <span class="toggle-label">4.2 Doorstep / On-Site Private Sessions</span>
                    <label class="toggle-switch">
                        <input type="checkbox" id="doorService" name="doorService" value="true" ${host.doorService ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>
            </div>

            <!-- Section 5: Facilities -->
            <div class="section-card">
                <div class="section-header">5. Venue Amenities</div>
                <div class="chips-container">
                    <c:forEach var="fac" items="${['Parking', 'Wi-Fi', 'Projector / Screen', 'Air Conditioned', 'Clean Restroom', 'Refreshments', 'First Aid Kit', 'Sound System', 'Wheelchair Accessible']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" class="cb-facility" value="${fac}" ${host.facilities != null && host.facilities.contains(fac) ? 'checked' : ''}>
                            <span class="chip-label">${fac}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- Section 6: Hours & Schedule -->
            <div class="section-card">
                <div class="section-header">6. Operating Hours & Schedule</div>
                <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">6.1 Open days *</label>
                <div class="chips-container" style="margin-bottom: 14px;">
                    <c:forEach var="day" items="${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" class="cb-day" value="${day}" ${host.openDays != null && host.openDays.contains(day) ? 'checked' : ''}>
                            <span class="chip-label">${day}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>6.2 Opening time *</label>
                        <input type="time" id="openTime" name="openTime" class="form-input" value="${host.openTime != null ? host.openTime : '09:00'}" required>
                    </div>
                    <div class="form-group">
                        <label>6.3 Closing time *</label>
                        <input type="time" id="closeTime" name="closeTime" class="form-input" value="${host.closeTime != null ? host.closeTime : '18:00'}" required>
                    </div>
                </div>
            </div>

            <!-- Section 7: About Host -->
            <div class="section-card">
                <div class="section-header">7. About Organization / Bio</div>
                <div class="form-group">
                    <label>7.1 Mission & event background *</label>
                    <textarea id="hostBio" name="hostBio" class="form-textarea" rows="4" placeholder="Tell attendees about your organization, safety mission, and event experience..." required><c:out value="${host.hostBio}"/></textarea>
                </div>
            </div>

            <!-- Section 8: Offering -->
            <div class="section-card">
                <div class="section-header">8. Typical Event Offering</div>
                <div class="form-row">
                    <div class="form-group">
                        <label>8.1 Session mode *</label>
                        <select id="sessionMode" name="sessionMode" class="form-select" required>
                            <option value="In-Person" ${host.sessionMode eq 'In-Person' ? 'selected' : ''}>In-Person</option>
                            <option value="Virtual" ${host.sessionMode eq 'Virtual' ? 'selected' : ''}>Virtual / Online</option>
                            <option value="Hybrid" ${host.sessionMode eq 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>8.2 Duration (minutes) *</label>
                        <input type="number" id="durationMinutes" name="durationMinutes" class="form-input" value="${host.durationMinutes != null ? host.durationMinutes : 60}" min="15" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>8.3 Typical ticket price (₹, 0 = free) *</label>
                    <input type="number" id="typicalPrice" name="typicalPrice" class="form-input" value="${host.typicalPrice != null ? host.typicalPrice : 0}" min="0" step="0.01" required>
                </div>
            </div>

            <!-- Section 9: Payout Details -->
            <div class="section-card">
                <div class="section-header">9. Payout & Financial Details</div>
                <div class="form-group">
                    <label>9.1 UPI ID (for ticket payouts)</label>
                    <input type="text" id="upiId" name="upiId" class="form-input" value="<c:out value='${host.upiId}'/>" placeholder="org@upi">
                </div>
                <div class="form-group">
                    <label>9.2 Bank account details</label>
                    <textarea id="bankDetails" name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, IFSC"><c:out value="${host.bankDetails}"/></textarea>
                </div>
            </div>

            <!-- Section 10: Profile Photo / Logo -->
            <div class="section-card">
                <div class="section-header">10. Profile Image / Logo</div>
                <div class="form-group">
                    <label>10.1 Logo or Profile Image URL</label>
                    <input type="text" id="logoPath" name="logoPath" class="form-input" value="<c:out value='${host.logoPath}'/>" placeholder="https://example.com/logo.jpg">
                </div>
            </div>

            <!-- Section 11: Gallery Photos -->
            <div class="section-card">
                <div class="section-header">11. Event Photos Gallery</div>
                <div class="form-group">
                    <label>11.1 Gallery Image URLs (Comma-separated)</label>
                    <textarea id="galleryPhotos" name="galleryPhotos" class="form-textarea" rows="3" placeholder="https://img1.jpg, https://img2.jpg"><c:out value="${host.galleryPhotos}"/></textarea>
                </div>
            </div>

            <div class="bottom-actions">
                <button type="button" class="btn-bottom-save" onclick="saveProfile()">Save Host Profile</button>
            </div>
        </form>

    </main>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function getCheckedValues(className) {
            return Array.from(document.querySelectorAll('.' + className + ':checked')).map(cb => cb.value).join(',');
        }

        async function saveProfile(e) {
            if (e) e.preventDefault();
            const alertBox = document.getElementById('alertBox');
            alertBox.style.display = 'none';

            const payload = {
                fullName: document.getElementById('fullName').value.trim(),
                organizerType: document.getElementById('organizerType').value,
                organizerName: document.getElementById('organizerName').value.trim(),
                phone: document.getElementById('phone').value.trim(),
                credentialNumber: document.getElementById('credentialNumber').value.trim(),
                whatsappNumber: document.getElementById('whatsappNumber').value.trim(),
                yearsExperience: document.getElementById('yearsExperience').value,
                address: document.getElementById('address').value.trim(),
                city: document.getElementById('city').value.trim(),
                state: document.getElementById('stateSelect').value,
                pincode: document.getElementById('pincode').value.trim(),
                mapsLocation: document.getElementById('mapsLocation').value.trim(),
                eventCategories: getCheckedValues('cb-category'),
                audience: getCheckedValues('cb-audience'),
                doorService: document.getElementById('doorService').checked,
                facilities: getCheckedValues('cb-facility'),
                openDays: getCheckedValues('cb-day'),
                openTime: document.getElementById('openTime').value,
                closeTime: document.getElementById('closeTime').value,
                bio: document.getElementById('hostBio').value.trim(),
                sessionMode: document.getElementById('sessionMode').value,
                durationMinutes: document.getElementById('durationMinutes').value,
                typicalPrice: document.getElementById('typicalPrice').value,
                upiId: document.getElementById('upiId').value.trim(),
                bankDetails: document.getElementById('bankDetails').value.trim(),
                logoPath: document.getElementById('logoPath').value.trim(),
                galleryPhotos: document.getElementById('galleryPhotos').value.trim()
            };

            try {
                const res = await fetch(contextPath + '/api/women-events/host/profile', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                const data = await res.json();
                if (data.success) {
                    const pct = data.profileCompletionPct || 0;
                    document.getElementById('pctText').innerText = pct + '%';
                    document.getElementById('progressBarFill').style.width = pct + '%';
                    alertBox.className = 'alert-box alert-success';
                    alertBox.innerHTML = '<i class="bi bi-check-circle-fill"></i> Profile saved successfully!';
                    alertBox.style.display = 'flex';
                } else {
                    alertBox.className = 'alert-box alert-error';
                    alertBox.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + (data.error || 'Failed to save profile.');
                    alertBox.style.display = 'flex';
                }
            } catch (err) {
                alertBox.className = 'alert-box alert-error';
                alertBox.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> Network error saving profile.';
                alertBox.style.display = 'flex';
            }
        }

        async function submitForVerification() {
            const alertBox = document.getElementById('alertBox');
            alertBox.style.display = 'none';

            const statusStr = "${statusStr}";
            if (statusStr === "APPROVED") {
                window.location.href = contextPath + '/women-events/organizer/dashboard';
                return;
            }

            try {
                const res = await fetch(contextPath + '/api/women-events/host/submit-verification', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                });
                const data = await res.json();
                if (data.success) {
                    window.location.href = contextPath + '/women-events/organizer/profile-completion?submitted=true';
                } else {
                    alertBox.className = 'alert-box alert-error';
                    alertBox.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> ' + (data.error || 'Cannot submit for verification yet. Please complete all required fields.');
                    alertBox.style.display = 'flex';
                }
            } catch (err) {
                alertBox.className = 'alert-box alert-error';
                alertBox.innerHTML = '<i class="bi bi-exclamation-circle-fill"></i> Network error submitting profile.';
                alertBox.style.display = 'flex';
            }
        }
    </script>
</body>
</html>
