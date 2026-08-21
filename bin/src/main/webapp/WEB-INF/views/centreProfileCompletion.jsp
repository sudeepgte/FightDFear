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
            max-width: 760px;
            width: 100%;
            margin: 20px auto 40px;
            padding: 0 16px;
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
            <p style="font-size: 0.8rem; color: var(--text-gray);">
                Complete all required sections below. Once your profile reaches required completeness, you can submit for Admin verification.
            </p>
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
                    <input type="text" name="name" class="form-input" value="<c:out value='${center.name}'/>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.2 Centre type *</label>
                        <select name="centreType" class="form-select">
                            <option value="Academy">Academy</option>
                            <option value="Dojo">Dojo</option>
                            <option value="Training hall">Training hall</option>
                            <option value="Home studio">Home studio</option>
                            <option value="Community hall">Community hall</option>
                            <option value="Outdoor">Outdoor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.3 Owner / manager *</label>
                        <input type="text" name="contactPerson" class="form-input" value="<c:out value='${center.contactPerson}'/>" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.4 Designation</label>
                        <select name="designation" class="form-select">
                            <option value="Owner">Owner</option>
                            <option value="Head coach">Head coach</option>
                            <option value="Manager">Manager</option>
                            <option value="Instructor">Instructor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.5 Official phone *</label>
                        <input type="tel" name="phone" class="form-input" value="<c:out value='${center.phone}'/>" maxlength="10" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.6 WhatsApp</label>
                        <input type="tel" name="whatsappNumber" class="form-input" placeholder="10-digit WhatsApp number" maxlength="10">
                    </div>
                    <div class="form-group">
                        <label>1.7 Year started</label>
                        <input type="number" name="yearStarted" class="form-input" placeholder="e.g. 2018" maxlength="4">
                    </div>
                </div>

                <div class="form-group">
                    <label>1.8 Affiliation</label>
                    <select name="affiliation" class="form-select">
                        <option value="None">None</option>
                        <option value="WKF">WKF (World Karate Federation)</option>
                        <option value="ITF">ITF (International Taekwondo Federation)</option>
                        <option value="Shotokan">Shotokan</option>
                        <option value="National body">National body</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <!-- Section 2: Location -->
            <div class="section-card">
                <div class="section-header">2. Location</div>
                <div class="form-group">
                    <label>2.1 Hall / landmark / address *</label>
                    <input type="text" name="location" class="form-input" value="<c:out value='${center.location}'/>" placeholder="Building name, street, landmark" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>2.3 City *</label>
                        <input type="text" name="city" class="form-input" placeholder="City" required>
                    </div>
                    <div class="form-group">
                        <label>2.4 State *</label>
                        <select name="state" class="form-select" required>
                            <option value="Karnataka" selected>Karnataka</option>
                            <option value="Maharashtra">Maharashtra</option>
                            <option value="Delhi">Delhi</option>
                            <option value="Tamil Nadu">Tamil Nadu</option>
                            <option value="Telangana">Telangana</option>
                            <option value="Andhra Pradesh">Andhra Pradesh</option>
                            <option value="Kerala">Kerala</option>
                            <option value="Gujarat">Gujarat</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>2.5 Pincode *</label>
                        <input type="text" name="pincode" class="form-input" placeholder="6-digit Pincode" maxlength="6" required>
                    </div>
                    <div class="form-group">
                        <label>2.6 Google Maps location link</label>
                        <input type="url" name="mapLink" class="form-input" placeholder="https://maps.app.goo.gl/...">
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
                            <input type="checkbox" name="styles" value="${style}">
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
                            <input type="checkbox" name="audience" value="${aud}">
                            <span class="chip-label">${aud}</span>
                        </label>
                    </c:forEach>
                </div>

                <div class="toggle-row">
                    <span class="toggle-label">4.2 Women-only batches</span>
                    <label class="toggle-switch">
                        <input type="checkbox" name="womenOnly" value="true">
                        <span class="slider"></span>
                    </label>
                </div>

                <div class="toggle-row">
                    <span class="toggle-label">4.3 Female instructor available</span>
                    <label class="toggle-switch">
                        <input type="checkbox" name="femaleInstructor" value="true">
                        <span class="slider"></span>
                    </label>
                </div>

                <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy); margin-top: 14px; display: block;">4.4 Age groups</label>
                <div class="chips-container">
                    <c:forEach var="age" items="${['Kids 6–12', 'Teens 13–17', 'Adults 18+', '40+']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="ageGroups" value="${age}">
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
                            <input type="checkbox" name="facilities" value="${fac}">
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
                            <input type="checkbox" name="availableDays" value="${day}">
                            <span class="chip-label">${day.substring(0, 3)}</span>
                        </label>
                    </c:forEach>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>6.2 Open time *</label>
                        <input type="time" name="openTime" class="form-input" value="06:00" required>
                    </div>
                    <div class="form-group">
                        <label>6.3 Close time *</label>
                        <input type="time" name="closeTime" class="form-input" value="21:00" required>
                    </div>
                </div>
            </div>

            <!-- Section 7: About the Centre -->
            <div class="section-card">
                <div class="section-header">7. About the centre</div>
                <div class="form-group">
                    <label>7.1 About the centre *</label>
                    <textarea name="about" class="form-textarea" rows="4" placeholder="Describe your training ethos, instructors, and environment..."><c:out value="${center.about}"/></textarea>
                </div>
                <div class="form-group">
                    <label>7.2 How we teach *</label>
                    <textarea name="howWeTeach" class="form-textarea" rows="3" placeholder="Explain your teaching methodology, step-by-step progress..."><c:out value="${center.howWeTeach}"/></textarea>
                </div>
                <label style="font-size: 0.82rem; font-weight: 600; color: var(--navy);">7.3 What we offer *</label>
                <div class="chips-container">
                    <c:forEach var="offer" items="${['Regular class', 'Trial class', 'Belt grading', 'Workshops', 'Self-defence crash course']}">
                        <label class="chip-checkbox">
                            <input type="checkbox" name="offers" value="${offer}">
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
                    <input type="text" name="upiId" class="form-input" placeholder="centre@upi">
                </div>
                <div class="form-group">
                    <label>9.2 Bank details</label>
                    <textarea name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, Bank, IFSC Code"></textarea>
                </div>
            </div>

            <!-- Section 10: Documents (Optional) -->
            <div class="section-card">
                <div class="section-header">10. Documents & Certificates</div>
                <div class="form-group">
                    <label>10.1 Profile Photo (Logo / Main image)</label>
                    <input type="file" name="profilePhotoFile" class="form-input" accept="image/*">
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
                    <input type="file" name="galleryFiles" class="form-input" accept="image/*" multiple>
                </div>
            </div>

            <div class="bottom-actions">
                <button type="submit" class="btn-bottom-save">Save Profile Details</button>
            </div>
        </form>

    </main>

</body>
</html>
