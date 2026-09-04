<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Doctor Profile — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { overflow-x: hidden; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }
        .app-header {
            background: #fff;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
            gap: 12px;
            flex-wrap: wrap;
        }
        .header-brand {
            display: flex; align-items: center; gap: 10px;
            font-size: 1.1rem; font-weight: 800; color: var(--navy); text-decoration: none;
        }
        .header-brand img {
            height: 32px; width: 32px; border-radius: 8px; object-fit: cover;
        }
        .header-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .btn-skip, .btn-header-save, .btn-primary, .btn-ghost {
            border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            padding: 8px 16px; cursor: pointer; font-family: inherit; text-decoration: none;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
            transition: background 0.2s, opacity 0.2s;
        }
        .btn-skip {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-skip:hover { background: var(--bg-page); }
        .btn-header-save, .btn-primary {
            border: none; background: var(--primary); color: #fff;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }
        .btn-header-save:hover, .btn-primary:hover { background: var(--primary-hover); }
        .btn-header-save:disabled, .btn-primary:disabled, .btn-ghost:disabled {
            opacity: 0.65; cursor: not-allowed; box-shadow: none;
        }
        .btn-ghost {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-ghost:hover { background: var(--bg-page); }
        .main-container {
            flex: 1; max-width: 1260px; width: 100%; margin: 24px auto 40px; padding: 0 20px;
        }
        .profile-layout-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 380px;
            gap: 28px;
            align-items: start;
        }
        .profile-progress-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: var(--shadow-card);
        }
        .progress-header {
            display: flex; justify-content: space-between; align-items: center;
            gap: 12px; flex-wrap: wrap; margin-bottom: 10px;
        }
        .progress-title { font-size: 1rem; font-weight: 800; color: var(--navy); }
        .progress-pct {
            font-size: 0.85rem; font-weight: 800; color: var(--primary);
            background: var(--rose-soft); border: 1px solid var(--rose-border);
            padding: 4px 12px; border-radius: 999px;
        }
        .progress-bar-container {
            height: 8px; background: #E2E8F0; border-radius: 4px; overflow: hidden; margin-bottom: 12px;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 4px;
            width: ${profileCompletionPct}%;
            transition: width 0.3s ease;
        }
        .progress-guidance {
            font-size: 0.88rem; color: var(--text-gray); line-height: 1.45;
        }
        .progress-guidance strong { color: var(--navy); }
        .missing-list {
            margin-top: 10px; display: flex; flex-wrap: wrap; gap: 6px;
        }
        .missing-list span {
            display: inline-block; font-size: 0.75rem; font-weight: 600;
            background: #FFF7ED; color: #C2410C; border: 1px solid #FED7AA;
            border-radius: 6px; padding: 4px 8px;
        }
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: var(--shadow-card);
        }
        .section-title {
            font-size: 1.05rem; font-weight: 800; color: var(--navy);
            margin-bottom: 16px; display: flex; align-items: center; gap: 8px;
        }
        .section-title .num {
            display: inline-flex; align-items: center; justify-content: center;
            width: 26px; height: 26px; border-radius: 8px;
            background: var(--rose-light); color: var(--primary);
            font-size: 0.78rem; font-weight: 800; flex-shrink: 0;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px 16px;
            margin-bottom: 8px;
        }
        .field.full { grid-column: 1 / -1; }
        .field label {
            display: block; font-size: 0.82rem; font-weight: 600; margin-bottom: 6px; color: var(--navy);
        }
        .field label .req { color: var(--primary); }
        .field input, .field select, .field textarea {
            width: 100%; padding: 11px 12px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.92rem; font-family: inherit; background: #fff; color: var(--navy);
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .field input:disabled { opacity: 0.65; background: #f8fafc; }
        .field input.is-invalid,
        .field select.is-invalid,
        .field textarea.is-invalid {
            border-color: var(--error);
            background: var(--error-bg);
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.08);
        }
        .error-msg {
            display: none;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--error);
            margin-top: 5px;
        }
        .error-msg.show { display: block; }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 4px; }
        .day-toggles, .mode-toggles {
            display: flex; flex-wrap: wrap; gap: 8px;
        }
        .chip {
            display: inline-flex; align-items: center; gap: 6px;
            border: 1px solid var(--border-color); border-radius: 8px;
            padding: 7px 12px; font-size: 0.82rem; font-weight: 600; cursor: pointer;
            background: #F1F5F9; color: #475569; user-select: none;
            transition: all 0.2s;
        }
        .chip input { accent-color: var(--primary); }
        .chip:has(input:checked) {
            background: var(--rose-light); border-color: var(--primary); color: var(--primary);
        }
        .mode-toggles.is-invalid,
        .day-toggles.is-invalid {
            outline: 2px solid rgba(220, 38, 38, 0.35);
            outline-offset: 4px;
            border-radius: 10px;
        }
        .switch-row {
            display: flex; align-items: center; gap: 10px; font-size: 0.9rem; font-weight: 600;
        }
        .alert {
            padding: 12px 14px; border-radius: 12px; font-size: 0.88rem; font-weight: 600; margin-bottom: 16px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #fecaca; }
        .alert-ok { background: var(--success-bg); color: var(--success); border: 1px solid #bbf7d0; }
        .actions {
            display: flex; gap: 12px; flex-wrap: wrap; margin-top: 20px;
            border-top: 1px solid var(--border-color); padding-top: 18px;
        }
        .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip {
            flex: 1; min-width: 140px; padding: 12px 18px; font-size: 0.95rem;
        }
        .preview-sticky-wrap {
            position: sticky; top: 80px; z-index: 20;
        }
        .live-preview-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--rose-border);
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            overflow: hidden;
        }
        .preview-banner-header {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            color: #fff; padding: 16px 20px;
            display: flex; justify-content: space-between; align-items: center; gap: 10px;
        }
        .preview-banner-header h3 { font-size: 0.95rem; font-weight: 800; }
        .preview-badge-live {
            background: var(--primary); color: #fff;
            font-size: 0.68rem; font-weight: 800; text-transform: uppercase;
            letter-spacing: 0.8px; padding: 4px 10px; border-radius: 20px;
        }
        .preview-body { padding: 20px; }
        .preview-row {
            display: flex; justify-content: space-between; gap: 12px;
            padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 0.88rem;
        }
        .preview-row:last-child { border-bottom: none; }
        .preview-row .k { color: var(--text-gray); flex-shrink: 0; }
        .preview-row .v { font-weight: 700; text-align: right; word-break: break-word; }
        .preview-meta-row {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 12px; background: var(--bg-page);
            border-radius: 10px; border: 1px solid var(--border-color);
            margin-bottom: 8px; font-size: 0.82rem;
        }
        .preview-meta-row i { color: var(--primary); }
        .form-card, .preview-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-card);
        }
        @media (max-width: 991px) {
            .profile-layout-grid { grid-template-columns: 1fr; }
            .preview-column { order: -1; }
            .preview-sticky-wrap { position: static; }
        }
        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .main-container { padding: 0 16px; }
        }
        @media (max-width: 600px) {
            .app-header { padding: 12px 14px; }
            .section-card, .form-card, .preview-card { padding: 16px 14px; }
            .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip { min-width: 100%; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/doctors/dashboard">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            Fight D Fear
        </a>
        <div class="header-actions">
            <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
            <button type="button" class="btn-header-save" id="headerReviewBtn">Review profile</button>
        </div>
    </header>

    <main class="main-container">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-ok">${message}</div>
        </c:if>

        <div class="profile-layout-grid">
            <div class="form-column">
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <span class="progress-title">Profile Completion</span>
                        <span class="progress-pct">${profileCompletionPct}%</span>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill"></div>
                    </div>
                    <p class="progress-guidance"><strong>${statusLabel}</strong> — ${nextStepGuidance}</p>
                    <c:if test="${not empty missingItems}">
                        <div class="missing-list">
                            <c:forEach var="m" items="${missingItems}">
                                <span><i class="bi bi-exclamation-circle"></i> ${m}</span>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <!-- EDIT -->
                <div id="editPanel">
                    <form id="profileForm" action="${pageContext.request.contextPath}/doctors/profile-completion" method="post" enctype="multipart/form-data" novalidate>
                        <!-- 1. Professional Information -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">1</span> Professional Information</div>
                            <div class="grid">
                                <div class="field">
                                    <label>Doctor name <span class="req">*</span></label>
                                    <input type="text" name="fullName" id="fullName" value="${doctor.fullName}" required>
                                    <div class="error-msg" id="err-fullName">Doctor name is required.</div>
                                </div>
                                <div class="field">
                                    <label>Email (read-only)</label>
                                    <input type="email" value="${doctor.email}" disabled>
                                </div>
                                <div class="field">
                                    <label>Phone</label>
                                    <input type="tel" name="phone" id="phone" value="${doctor.phone}" pattern="[0-9]{10}" maxlength="10">
                                    <div class="error-msg" id="err-phone">Phone must be exactly 10 digits.</div>
                                </div>
                                <div class="field">
                                    <label>Gender</label>
                                    <select name="gender" id="gender">
                                        <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                        <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                                        <option value="OTHER" ${doctor.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Specialization <span class="req">*</span></label>
                                    <input type="text" name="specialization" id="specialization" value="${doctor.specialization != null ? doctor.specialization : ''}" placeholder="e.g. Gynecologist" maxlength="80">
                                    <div class="error-msg" id="err-specialization">Specialization is required.</div>
                                </div>
                                <div class="field">
                                    <label>Qualification <span class="req">*</span></label>
                                    <input type="text" name="qualification" id="qualification" value="${doctor.qualification != null ? doctor.qualification : ''}" placeholder="e.g. MBBS, MD" maxlength="120">
                                    <div class="error-msg" id="err-qualification">Qualification is required.</div>
                                </div>
                                <div class="field">
                                    <label>Medical registration number <span class="req">*</span></label>
                                    <input type="text" name="medicalRegNumber" id="medicalRegNumber" value="${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : ''}" maxlength="60">
                                    <div class="error-msg" id="err-medicalRegNumber">Medical registration number is required.</div>
                                </div>
                                <div class="field">
                                    <label>Years of experience <span class="req">*</span></label>
                                    <input type="number" name="experienceYears" id="experienceYears" min="0" max="50" value="${doctor.experienceYears != null ? doctor.experienceYears : ''}">
                                    <div class="error-msg" id="err-experienceYears">Enter experience between 0 and 50 years.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 2. Clinic / Hospital -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">2</span> Clinic / Hospital</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Hospital / clinic name <span class="req">*</span></label>
                                    <input type="text" name="hospitalName" id="hospitalName" value="${doctor.hospitalName != null ? doctor.hospitalName : ''}" maxlength="120">
                                    <div class="error-msg" id="err-hospitalName">Hospital / clinic name is required.</div>
                                </div>
                                <div class="field full">
                                    <label>Clinic address <span class="req">*</span></label>
                                    <textarea name="clinicAddress" id="clinicAddress" rows="2" maxlength="300">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea>
                                    <div class="error-msg" id="err-clinicAddress">Clinic address is required.</div>
                                </div>
                                <div class="field">
                                    <label>City <span class="req">*</span></label>
                                    <input type="text" name="city" id="city" value="${doctor.city != null ? doctor.city : ''}" maxlength="60">
                                    <div class="error-msg" id="err-city">City is required.</div>
                                </div>
                                <div class="field">
                                    <label>State <span class="req">*</span></label>
                                    <input type="text" name="state" id="state" value="${doctor.state != null ? doctor.state : ''}" maxlength="60">
                                    <div class="error-msg" id="err-state">State is required.</div>
                                </div>
                                <div class="field">
                                    <label>Pincode <span class="req">*</span></label>
                                    <input type="text" name="pincode" id="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6" pattern="\d{6}" inputmode="numeric">
                                    <div class="error-msg" id="err-pincode">Enter a valid 6-digit pincode.</div>
                                </div>
                                <div class="field">
                                    <label>Google Maps location</label>
                                    <input type="url" name="googleMapLocation" id="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}" placeholder="https://maps.google.com/...">
                                    <div class="error-msg" id="err-googleMapLocation">Enter a valid URL starting with http:// or https://.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 3. Consultation Modes -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">3</span> Consultation Modes</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Select the ways patients can consult you <span class="req">*</span></label>
                                    <div class="mode-toggles" id="modeToggles">
                                        <c:set var="modes" value="${doctor.consultationModes != null ? doctor.consultationModes : (doctor.consultationType != null ? doctor.consultationType.name() : '')}" />
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="CLINIC" ${fn:contains(modes, 'CLINIC') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Clinic</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="VIDEO" ${fn:contains(modes, 'VIDEO') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Video</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="ONLINE" ${fn:contains(modes, 'ONLINE') ? 'checked' : ''}> Online / Chat</label>
                                        <label class="chip"><input type="checkbox" name="consultationModes" value="OFFLINE" ${fn:contains(modes, 'OFFLINE') ? 'checked' : ''}> Offline</label>
                                    </div>
                                    <div class="error-msg" id="err-consultationModes">Select at least one consultation mode to submit for verification.</div>
                                    <div class="hint">Optional when saving a draft; required when submitting for verification.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 4. Availability -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">4</span> Availability</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Available days <span class="req">*</span></label>
                                    <div class="day-toggles" id="dayToggles">
                                        <c:set var="days" value="${doctor.availableDays != null ? doctor.availableDays : ''}" />
                                        <label class="chip"><input type="checkbox" name="availableDays" value="MONDAY" ${fn:contains(days, 'MONDAY') ? 'checked' : ''}> Mon</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="TUESDAY" ${fn:contains(days, 'TUESDAY') ? 'checked' : ''}> Tue</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="WEDNESDAY" ${fn:contains(days, 'WEDNESDAY') ? 'checked' : ''}> Wed</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="THURSDAY" ${fn:contains(days, 'THURSDAY') ? 'checked' : ''}> Thu</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="FRIDAY" ${fn:contains(days, 'FRIDAY') ? 'checked' : ''}> Fri</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="SATURDAY" ${fn:contains(days, 'SATURDAY') ? 'checked' : ''}> Sat</label>
                                        <label class="chip"><input type="checkbox" name="availableDays" value="SUNDAY" ${fn:contains(days, 'SUNDAY') ? 'checked' : ''}> Sun</label>
                                    </div>
                                    <div class="error-msg" id="err-availableDays">Select at least one available day to submit for verification.</div>
                                    <div class="hint">Optional when saving a draft; required when submitting for verification.</div>
                                </div>
                                <div class="field">
                                    <label>Start time <span class="req">*</span></label>
                                    <input type="time" name="startTime" id="startTime" value="${doctor.startTime != null ? doctor.startTime : '09:00'}">
                                    <div class="error-msg" id="err-startTime">Start time is required.</div>
                                </div>
                                <div class="field">
                                    <label>End time <span class="req">*</span></label>
                                    <input type="time" name="endTime" id="endTime" value="${doctor.endTime != null ? doctor.endTime : '18:00'}">
                                    <div class="error-msg" id="err-endTime">End time must be after start time.</div>
                                </div>
                                <div class="field">
                                    <label>Slot duration (minutes)</label>
                                    <select name="slotDurationMinutes" id="slotDurationMinutes">
                                        <c:set var="slotDur" value="${doctor.slotDurationMinutes != null ? doctor.slotDurationMinutes : 30}" />
                                        <option value="15" ${slotDur == 15 ? 'selected' : ''}>15</option>
                                        <option value="20" ${slotDur == 20 ? 'selected' : ''}>20</option>
                                        <option value="30" ${slotDur == 30 ? 'selected' : ''}>30</option>
                                        <option value="45" ${slotDur == 45 ? 'selected' : ''}>45</option>
                                        <option value="60" ${slotDur == 60 ? 'selected' : ''}>60</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Buffer between patients (minutes)</label>
                                    <select name="bufferMinutes" id="bufferMinutes">
                                        <c:set var="bufMin" value="${doctor.bufferMinutes != null ? doctor.bufferMinutes : 0}" />
                                        <option value="0" ${bufMin == 0 ? 'selected' : ''}>0</option>
                                        <option value="5" ${bufMin == 5 ? 'selected' : ''}>5</option>
                                        <option value="10" ${bufMin == 10 ? 'selected' : ''}>10</option>
                                        <option value="15" ${bufMin == 15 ? 'selected' : ''}>15</option>
                                    </select>
                                </div>
                                <div class="field">
                                    <label>Break start</label>
                                    <input type="time" name="breakStart" id="breakStart" value="${doctor.breakStart != null ? doctor.breakStart : ''}">
                                </div>
                                <div class="field">
                                    <label>Break end</label>
                                    <input type="time" name="breakEnd" id="breakEnd" value="${doctor.breakEnd != null ? doctor.breakEnd : ''}">
                                    <div class="error-msg" id="err-breakEnd">Provide a valid break window.</div>
                                </div>
                                <div class="field full">
                                    <label>Blocked dates</label>
                                    <input type="text" name="blockedDates" id="blockedDates" value="${doctor.blockedDates != null ? doctor.blockedDates : ''}" placeholder="e.g. 2026-09-01, 2026-09-15">
                                    <div class="hint">Comma-separated YYYY-MM-DD dates you are unavailable.</div>
                                </div>
                                <div class="field full">
                                    <label class="switch-row">
                                        <input type="checkbox" name="autoConfirm" value="yes" ${doctor.autoConfirm != null && doctor.autoConfirm ? 'checked' : ''}>
                                        Auto-confirm bookings (off = you accept each request)
                                    </label>
                                </div>
                                <div class="field full">
                                    <label class="switch-row">
                                        <input type="checkbox" name="emergencyAvailable" value="yes" ${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'checked' : ''}>
                                        Emergency / instant consult available
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- 5. Languages -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">5</span> Languages</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Languages you consult in <span class="req">*</span></label>
                                    <input type="text" name="languages" id="languages" value="${doctor.languages != null ? doctor.languages : ''}" placeholder="e.g. English, Hindi" maxlength="120">
                                    <div class="error-msg" id="err-languages">Enter at least one language.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 6. Services offered -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">6</span> Services offered</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Services patients can book</label>
                                    <input type="text" name="services" id="services" value="${doctor.services != null ? doctor.services : ''}" placeholder="Optional, comma-separated">
                                </div>
                            </div>
                        </div>

                        <!-- 7. Fees -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">7</span> Fees</div>
                            <div class="grid">
                                <div class="field">
                                    <label>Consultation fee (₹) <span class="req">*</span></label>
                                    <input type="number" name="consultationFee" id="consultationFee" min="0" step="1" value="${doctor.consultationFee != null ? doctor.consultationFee : ''}">
                                    <div class="error-msg" id="err-consultationFee">Enter a consultation fee of 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Chat fee (₹)</label>
                                    <input type="number" name="chatFee" id="chatFee" min="0" step="1" value="${doctor.chatFee != null ? doctor.chatFee : ''}">
                                    <div class="error-msg" id="err-chatFee">Chat fee must be 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Call fee (₹)</label>
                                    <input type="number" name="callFee" id="callFee" min="0" step="1" value="${doctor.callFee != null ? doctor.callFee : ''}">
                                    <div class="error-msg" id="err-callFee">Call fee must be 0 or greater.</div>
                                </div>
                                <div class="field">
                                    <label>Video fee (₹)</label>
                                    <input type="number" name="videoFee" id="videoFee" min="0" step="1" value="${doctor.videoFee != null ? doctor.videoFee : ''}">
                                    <div class="error-msg" id="err-videoFee">Video fee must be 0 or greater.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 8. About you / Bio -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">8</span> About you / Bio</div>
                            <div class="grid">
                                <div class="field full">
                                    <label>Bio</label>
                                    <textarea name="bio" id="bio" rows="4" maxlength="2000" placeholder="Short professional bio for patients">${doctor.bio != null ? doctor.bio : ''}</textarea>
                                    <div class="error-msg" id="err-bio">Bio must be 2000 characters or fewer.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 9. Payout -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">9</span> Payout</div>
                            <div class="grid">
                                <div class="field">
                                    <label>UPI ID</label>
                                    <input type="text" name="upiId" id="upiId" value="${doctor.upiId != null ? doctor.upiId : ''}" placeholder="name@upi" maxlength="80">
                                    <div class="error-msg" id="err-upiId">Enter a valid UPI ID (e.g. name@upi).</div>
                                </div>
                                <div class="field">
                                    <label>Bank details</label>
                                    <input type="text" name="bankDetails" id="bankDetails" value="${doctor.bankDetails != null ? doctor.bankDetails : ''}" placeholder="Account name, number, IFSC">
                                </div>
                                <div class="field full">
                                    <div class="hint">Earnings stay in your wallet until you request a withdraw from the dashboard.</div>
                                </div>
                            </div>
                        </div>

                        <!-- 10. Documents -->
                        <div class="section-card">
                            <div class="section-title"><span class="num">10</span> Documents (optional)</div>
                            <p class="hint" style="margin-bottom:14px;">JPG, PNG or PDF up to 5 MB. Existing uploads are kept if you do not replace them.</p>
                            <div class="grid">
                                <div class="field">
                                    <label>Profile photo</label>
                                    <input type="file" name="profilePhoto" id="profilePhoto" accept="image/jpeg,image/png,application/pdf">
                                    <div class="error-msg" id="err-profilePhoto">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <div class="hint"><c:choose><c:when test="${not empty doctor.profilePhotoPath}">On file</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                                </div>
                                <div class="field">
                                    <label>Government ID</label>
                                    <input type="file" name="idProof" id="idProof" accept="image/jpeg,image/png,application/pdf">
                                    <div class="error-msg" id="err-idProof">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <div class="hint"><c:choose><c:when test="${not empty doctor.idProofPath || not empty doctor.identityDocumentPath}">On file</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                                </div>
                                <div class="field">
                                    <label>Medical registration certificate</label>
                                    <input type="file" name="degreeCertificate" id="degreeCertificate" accept="image/jpeg,image/png,application/pdf">
                                    <div class="error-msg" id="err-degreeCertificate">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <div class="hint"><c:choose><c:when test="${not empty doctor.degreeCertificatePath}">On file</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                                </div>
                                <div class="field">
                                    <label>Medical license</label>
                                    <input type="file" name="medicalLicense" id="medicalLicense" accept="image/jpeg,image/png,application/pdf">
                                    <div class="error-msg" id="err-medicalLicense">Use JPG, PNG or PDF up to 5 MB.</div>
                                    <div class="hint"><c:choose><c:when test="${not empty doctor.medicalLicensePath}">On file</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                                </div>
                            </div>
                        </div>

                        <!-- 11. Review & Submit -->
                        <div class="section-card" id="reviewSubmitSection">
                            <div class="section-title"><span class="num">11</span> Review &amp; Submit</div>
                            <p style="color:var(--text-gray);font-size:0.9rem;margin:0 0 12px;line-height:1.45;">
                                Use <strong>Review profile</strong> to confirm what you entered. Save first, then submit for verification when ready.
                            </p>
                            <div class="preview-row"><span class="k">Completion</span><span class="v">${profileCompletionPct}%</span></div>
                            <div class="preview-row"><span class="k">Status</span><span class="v">${statusLabel}</span></div>
                            <div class="preview-row"><span class="k">Next step</span><span class="v" style="font-weight:600;text-align:right;">${nextStepGuidance}</span></div>
                            <c:if test="${not empty missingItems}">
                                <div class="missing-list" style="margin:12px 0 4px;">
                                    <c:forEach var="m" items="${missingItems}">
                                        <span>${m}</span>
                                    </c:forEach>
                                </div>
                                <p style="font-size:0.82rem;color:#B45309;margin:8px 0 0;font-weight:600;">Fill the missing items above, save, then return here to submit.</p>
                            </c:if>
                            <input type="hidden" name="intent" id="profileIntent" value="">
                            <div class="actions" style="border-top:none;padding-top:12px;margin-top:8px;">
                                <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
                                <button type="button" class="btn-ghost" id="reviewBtn">Review profile</button>
                                <button type="submit" class="btn-primary" id="submitVerifyBtn">
                                    Save &amp; Submit for verification
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- PREVIEW -->
                <div id="previewPanel" style="display:none;">
                    <div class="preview-card">
                        <h2 style="font-size:1.2rem;font-weight:800;margin-bottom:6px;">11. Review &amp; Submit</h2>
                        <p style="color:var(--text-gray);font-size:0.9rem;margin-bottom:12px;">Confirm your details before saving. ${statusLabel} — ${nextStepGuidance}</p>

                        <div class="section-title"><span class="num">1</span> Professional Information</div>
                        <div class="preview-row"><span class="k">Name</span><span class="v" id="pvFullName">—</span></div>
                        <div class="preview-row"><span class="k">Email</span><span class="v">${doctor.email}</span></div>
                        <div class="preview-row"><span class="k">Phone</span><span class="v" id="pvPhone">—</span></div>
                        <div class="preview-row"><span class="k">Gender</span><span class="v" id="pvGender">—</span></div>
                        <div class="preview-row"><span class="k">Specialization</span><span class="v" id="pvSpec">—</span></div>
                        <div class="preview-row"><span class="k">Qualification</span><span class="v" id="pvQual">—</span></div>
                        <div class="preview-row"><span class="k">Experience</span><span class="v" id="pvExp">—</span></div>
                        <div class="preview-row"><span class="k">Medical Reg No.</span><span class="v" id="pvReg">—</span></div>

                        <div class="section-title"><span class="num">2</span> Clinic / Hospital</div>
                        <div class="preview-row"><span class="k">Hospital / Clinic</span><span class="v" id="pvHospital">—</span></div>
                        <div class="preview-row"><span class="k">Address</span><span class="v" id="pvAddress">—</span></div>
                        <div class="preview-row"><span class="k">City / State / Pin</span><span class="v" id="pvLocation">—</span></div>
                        <div class="preview-row"><span class="k">Maps</span><span class="v" id="pvMap">—</span></div>

                        <div class="section-title"><span class="num">3</span> Consultation Modes</div>
                        <div class="preview-row"><span class="k">Modes</span><span class="v" id="pvModes">—</span></div>

                        <div class="section-title"><span class="num">4</span> Availability</div>
                        <div class="preview-row"><span class="k">Days / Hours</span><span class="v" id="pvAvail">—</span></div>
                        <div class="preview-row"><span class="k">Slot / Buffer</span><span class="v" id="pvSlot">—</span></div>
                        <div class="preview-row"><span class="k">Break</span><span class="v" id="pvBreak">—</span></div>
                        <div class="preview-row"><span class="k">Blocked dates</span><span class="v" id="pvBlocked">—</span></div>
                        <div class="preview-row"><span class="k">Auto-confirm</span><span class="v" id="pvAuto">—</span></div>
                        <div class="preview-row"><span class="k">Emergency</span><span class="v" id="pvEmerg">—</span></div>

                        <div class="section-title"><span class="num">5</span> Languages</div>
                        <div class="preview-row"><span class="k">Languages</span><span class="v" id="pvLang">—</span></div>

                        <div class="section-title"><span class="num">6</span> Services offered</div>
                        <div class="preview-row"><span class="k">Services</span><span class="v" id="pvServices">—</span></div>

                        <div class="section-title"><span class="num">7</span> Fees</div>
                        <div class="preview-row"><span class="k">Consultation</span><span class="v" id="pvFee">—</span></div>
                        <div class="preview-row"><span class="k">Chat / Call / Video</span><span class="v" id="pvOtherFees">—</span></div>

                        <div class="section-title"><span class="num">8</span> About you</div>
                        <div class="preview-row"><span class="k">Bio</span><span class="v" id="pvBio">—</span></div>

                        <div class="section-title"><span class="num">9</span> Payout</div>
                        <div class="preview-row"><span class="k">UPI</span><span class="v" id="pvUpi">—</span></div>
                        <div class="preview-row"><span class="k">Bank</span><span class="v" id="pvBank">—</span></div>

                        <div class="section-title"><span class="num">10</span> Documents</div>
                        <div class="preview-row"><span class="k">Profile photo</span><span class="v" id="pvPhotoDoc">—</span></div>
                        <div class="preview-row"><span class="k">Government ID</span><span class="v" id="pvIdDoc">—</span></div>
                        <div class="preview-row"><span class="k">Medical license</span><span class="v" id="pvLicDoc">—</span></div>
                        <div class="preview-row"><span class="k">Registration certificate</span><span class="v" id="pvCertDoc">—</span></div>

                        <div class="actions">
                            <button type="button" class="btn-ghost" id="backEditBtn">Back &amp; Edit</button>
                            <button type="button" class="btn-primary" id="confirmSaveBtn">Confirm &amp; Save</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="preview-column">
                <div class="preview-sticky-wrap">
                    <div class="live-preview-card">
                        <div class="preview-banner-header">
                            <h3>Live preview</h3>
                            <span class="preview-badge-live">Live</span>
                        </div>
                        <div class="preview-body">
                            <div class="preview-meta-row"><i class="bi bi-person-badge"></i> <span id="lpName">${doctor.fullName}</span></div>
                            <div class="preview-meta-row"><i class="bi bi-stethoscope"></i> <span id="lpSpec">${doctor.specialization != null ? doctor.specialization : 'Specialization'}</span></div>
                            <div class="preview-meta-row"><i class="bi bi-geo-alt"></i> <span id="lpCity">${doctor.city != null ? doctor.city : 'City'}</span></div>
                            <div class="preview-meta-row"><i class="bi bi-currency-rupee"></i> <span id="lpFee"><c:choose><c:when test="${doctor.consultationFee != null}">₹${doctor.consultationFee}</c:when><c:otherwise>Fee</c:otherwise></c:choose></span></div>
                            <div class="preview-row" style="margin-top:8px;"><span class="k">Completion</span><span class="v">${profileCompletionPct}%</span></div>
                            <div class="preview-row"><span class="k">Status</span><span class="v">${statusLabel}</span></div>
                            <div class="preview-row"><span class="k">Modes</span><span class="v" id="lpModes">—</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        (function () {
            const form = document.getElementById('profileForm');
            const editPanel = document.getElementById('editPanel');
            const previewPanel = document.getElementById('previewPanel');
            const reviewBtn = document.getElementById('reviewBtn');
            const headerReviewBtn = document.getElementById('headerReviewBtn');
            const backEditBtn = document.getElementById('backEditBtn');
            const confirmSaveBtn = document.getElementById('confirmSaveBtn');
            const submitVerifyBtn = document.getElementById('submitVerifyBtn');
            let saving = false;

            function val(id) {
                const el = document.getElementById(id);
                return el ? (el.value || '').trim() : '';
            }
            function checkedValues(name) {
                return Array.from(document.querySelectorAll('input[name="' + name + '"]:checked')).map(e => e.value);
            }
            function fileLabel(inputName, existingLabel) {
                const input = form.querySelector('input[name="' + inputName + '"]');
                if (input && input.files && input.files.length > 0) return 'New file selected';
                return existingLabel;
            }
            function setInvalid(id, invalid, msg) {
                const el = document.getElementById(id);
                const err = document.getElementById('err-' + id);
                if (el) el.classList.toggle('is-invalid', !!invalid);
                if (err) {
                    if (msg) err.textContent = msg;
                    err.classList.toggle('show', !!invalid);
                }
            }
            function clearModeError() {
                const wrap = document.getElementById('modeToggles');
                const err = document.getElementById('err-consultationModes');
                if (wrap) wrap.classList.remove('is-invalid');
                if (err) err.classList.remove('show');
            }
            function setModeError(show) {
                const wrap = document.getElementById('modeToggles');
                const err = document.getElementById('err-consultationModes');
                if (wrap) wrap.classList.toggle('is-invalid', !!show);
                if (err) err.classList.toggle('show', !!show);
            }
            function setDaysError(show) {
                const wrap = document.getElementById('dayToggles');
                const err = document.getElementById('err-availableDays');
                if (wrap) wrap.classList.toggle('is-invalid', !!show);
                if (err) err.classList.toggle('show', !!show);
            }
            function isNonNegFee(v) {
                return v === '' || (!Number.isNaN(Number(v)) && Number(v) >= 0);
            }
            function mark(id, bad, msg, state) {
                setInvalid(id, bad, msg);
                if (bad) {
                    state.ok = false;
                    state.firstInvalid = state.firstInvalid || document.getElementById(id);
                }
            }

            /**
             * @param {'draft'|'verify'} mode
             * draft = save progress (format checks + fullName)
             * verify = submit for verification (all required business fields)
             */
            function validateKeyFields(mode) {
                const strict = mode === 'verify';
                const state = { ok: true, firstInvalid: null };

                const name = val('fullName');
                mark('fullName', !name || name.length < 2, name ? 'Enter at least 2 characters.' : 'Doctor name is required.', state);
                if (name && name.length > 80) mark('fullName', true, 'Name must be 80 characters or fewer.', state);

                const phone = val('phone');
                if (phone !== '') {
                    mark('phone', !/^\d{10}$/.test(phone), 'Enter a valid 10-digit mobile number.', state);
                } else if (strict) {
                    mark('phone', true, 'Phone is required for verification.', state);
                } else {
                    setInvalid('phone', false);
                }

                const spec = val('specialization');
                if (strict) mark('specialization', !spec, 'Specialization is required.', state);
                else setInvalid('specialization', false);

                const qual = val('qualification');
                if (strict) mark('qualification', !qual, 'Qualification is required.', state);
                else setInvalid('qualification', false);

                const reg = val('medicalRegNumber');
                if (strict) mark('medicalRegNumber', !reg, 'Medical registration number is required.', state);
                else setInvalid('medicalRegNumber', false);

                const exp = val('experienceYears');
                if (strict && exp === '') {
                    mark('experienceYears', true, 'Years of experience is required.', state);
                } else if (exp !== '') {
                    const n = Number(exp);
                    mark('experienceYears', Number.isNaN(n) || n < 0 || n > 50, 'Enter experience between 0 and 50 years.', state);
                } else {
                    setInvalid('experienceYears', false);
                }

                const hospital = val('hospitalName');
                if (strict) mark('hospitalName', !hospital, 'Hospital / clinic name is required.', state);
                else setInvalid('hospitalName', false);

                const address = val('clinicAddress');
                if (strict) mark('clinicAddress', !address || address.length < 5, 'Enter a complete clinic address.', state);
                else setInvalid('clinicAddress', false);

                const city = val('city');
                if (strict) mark('city', !city, 'City is required.', state);
                else setInvalid('city', false);

                const st = val('state');
                if (strict) mark('state', !st, 'State is required.', state);
                else setInvalid('state', false);

                const pin = val('pincode');
                if (strict && pin === '') {
                    mark('pincode', true, 'Pincode is required.', state);
                } else if (pin !== '') {
                    mark('pincode', !/^\d{6}$/.test(pin), 'Enter a valid 6-digit pincode.', state);
                } else {
                    setInvalid('pincode', false);
                }

                const mapUrl = val('googleMapLocation');
                if (mapUrl !== '') {
                    mark('googleMapLocation', !/^https?:\/\/.+/i.test(mapUrl), 'Enter a valid URL starting with http:// or https://.', state);
                } else {
                    setInvalid('googleMapLocation', false);
                }

                if (strict) {
                    const modesOk = checkedValues('consultationModes').length > 0;
                    setModeError(!modesOk);
                    if (!modesOk) {
                        state.ok = false;
                        state.firstInvalid = state.firstInvalid || document.getElementById('modeToggles');
                    }
                    const daysOk = checkedValues('availableDays').length > 0;
                    setDaysError(!daysOk);
                    if (!daysOk) {
                        state.ok = false;
                        state.firstInvalid = state.firstInvalid || document.getElementById('dayToggles');
                    }
                } else {
                    clearModeError();
                    setDaysError(false);
                }

                const start = val('startTime');
                const end = val('endTime');
                if (strict && !start) mark('startTime', true, 'Start time is required.', state);
                else setInvalid('startTime', false);
                if (start && end && end <= start) {
                    mark('endTime', true, 'End time must be after start time.', state);
                } else if (strict && !end) {
                    mark('endTime', true, 'End time is required.', state);
                } else {
                    setInvalid('endTime', false);
                }

                const breakStart = val('breakStart');
                const breakEnd = val('breakEnd');
                if ((breakStart && !breakEnd) || (!breakStart && breakEnd)) {
                    mark('breakEnd', true, 'Provide both break start and break end, or leave both empty.', state);
                } else if (breakStart && breakEnd && breakEnd <= breakStart) {
                    mark('breakEnd', true, 'Break end must be after break start.', state);
                } else {
                    setInvalid('breakEnd', false);
                }

                const langs = val('languages');
                if (strict) mark('languages', !langs, 'Enter at least one language.', state);
                else setInvalid('languages', false);

                const fee = val('consultationFee');
                if (strict && fee === '') {
                    mark('consultationFee', true, 'Consultation fee is required.', state);
                } else if (fee !== '') {
                    mark('consultationFee', !isNonNegFee(fee), 'Enter a consultation fee of 0 or greater.', state);
                } else {
                    setInvalid('consultationFee', false);
                }
                ['chatFee', 'callFee', 'videoFee'].forEach(function (id) {
                    const v = val(id);
                    if (v !== '' && !isNonNegFee(v)) mark(id, true, 'Fee must be 0 or greater.', state);
                    else setInvalid(id, false);
                });

                const bio = val('bio');
                if (bio.length > 2000) mark('bio', true, 'Bio must be 2000 characters or fewer.', state);
                else setInvalid('bio', false);

                const upi = val('upiId');
                if (upi !== '' && !/^[\w.\-]{2,}@[a-zA-Z]{2,}$/.test(upi)) {
                    mark('upiId', true, 'Enter a valid UPI ID (e.g. name@upi).', state);
                } else {
                    setInvalid('upiId', false);
                }

                const maxBytes = 5 * 1024 * 1024;
                const allowed = /^(image\/jpeg|image\/png|application\/pdf)$/i;
                ['profilePhoto', 'idProof', 'degreeCertificate', 'medicalLicense'].forEach(function (id) {
                    const input = document.getElementById(id);
                    if (!input || !input.files || !input.files.length) {
                        setInvalid(id, false);
                        return;
                    }
                    const f = input.files[0];
                    const badType = f.type && !allowed.test(f.type);
                    const badSize = f.size > maxBytes;
                    mark(id, badType || badSize, 'Use JPG, PNG or PDF up to 5 MB.', state);
                });

                if (state.firstInvalid && state.firstInvalid.scrollIntoView) {
                    state.firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return state.ok;
            }

            function updateLivePreview() {
                const setText = (id, text) => {
                    const el = document.getElementById(id);
                    if (el) el.textContent = text || '—';
                };
                setText('lpName', val('fullName') || 'Doctor name');
                setText('lpSpec', val('specialization') || 'Specialization');
                setText('lpCity', [val('city'), val('state')].filter(Boolean).join(', ') || 'City');
                const fee = val('consultationFee');
                setText('lpFee', fee !== '' ? '₹' + fee : 'Fee');
                setText('lpModes', checkedValues('consultationModes').join(', ') || '—');
            }

            ['fullName', 'specialization', 'city', 'state', 'consultationFee'].forEach(function (id) {
                const el = document.getElementById(id);
                if (el) el.addEventListener('input', updateLivePreview);
            });
            document.querySelectorAll('input[name="consultationModes"]').forEach(function (el) {
                el.addEventListener('change', function () {
                    clearModeError();
                    updateLivePreview();
                });
            });

            function bindBlur(id, checkFn) {
                const el = document.getElementById(id);
                if (!el) return;
                el.addEventListener('blur', function () {
                    checkFn();
                });
                el.addEventListener('input', function () {
                    if (el.classList.contains('is-invalid')) checkFn();
                });
            }
            bindBlur('fullName', function () {
                const name = val('fullName');
                setInvalid('fullName', !name || name.length < 2, name ? 'Enter at least 2 characters.' : 'Doctor name is required.');
            });
            bindBlur('phone', function () {
                const phone = val('phone');
                setInvalid('phone', phone !== '' && !/^\d{10}$/.test(phone), 'Enter a valid 10-digit mobile number.');
            });
            bindBlur('pincode', function () {
                const pin = val('pincode');
                setInvalid('pincode', pin !== '' && !/^\d{6}$/.test(pin), 'Enter a valid 6-digit pincode.');
            });
            bindBlur('experienceYears', function () {
                const exp = val('experienceYears');
                setInvalid('experienceYears', exp !== '' && (Number(exp) < 0 || Number(exp) > 50 || Number.isNaN(Number(exp))), 'Enter experience between 0 and 50 years.');
            });
            bindBlur('consultationFee', function () {
                const fee = val('consultationFee');
                setInvalid('consultationFee', fee !== '' && !isNonNegFee(fee), 'Enter a consultation fee of 0 or greater.');
            });
            bindBlur('googleMapLocation', function () {
                const mapUrl = val('googleMapLocation');
                setInvalid('googleMapLocation', mapUrl !== '' && !/^https?:\/\/.+/i.test(mapUrl), 'Enter a valid URL starting with http:// or https://.');
            });
            bindBlur('upiId', function () {
                const upi = val('upiId');
                setInvalid('upiId', upi !== '' && !/^[\w.\-]{2,}@[a-zA-Z]{2,}$/.test(upi), 'Enter a valid UPI ID (e.g. name@upi).');
            });
            ['chatFee', 'callFee', 'videoFee'].forEach(function (id) {
                bindBlur(id, function () {
                    const v = val(id);
                    setInvalid(id, v !== '' && !isNonNegFee(v), 'Fee must be 0 or greater.');
                });
            });
            document.querySelectorAll('input[name="availableDays"]').forEach(function (el) {
                el.addEventListener('change', function () { setDaysError(false); });
            });

            function showPreview() {
                if (!validateKeyFields('draft')) return;

                function checked(name) {
                    const el = form.querySelector('input[name="' + name + '"]');
                    return el && el.checked ? 'Yes' : 'No';
                }
                const phone = val('phone');
                const exp = val('experienceYears');

                document.getElementById('pvFullName').textContent = val('fullName') || '—';
                document.getElementById('pvPhone').textContent = phone || '—';
                document.getElementById('pvGender').textContent = val('gender') || '—';
                document.getElementById('pvSpec').textContent = val('specialization') || '—';
                document.getElementById('pvQual').textContent = val('qualification') || '—';
                document.getElementById('pvExp').textContent = exp !== '' ? exp + ' years' : '—';
                document.getElementById('pvReg').textContent = val('medicalRegNumber') || '—';
                document.getElementById('pvHospital').textContent = val('hospitalName') || '—';
                document.getElementById('pvAddress').textContent = val('clinicAddress') || '—';
                document.getElementById('pvLocation').textContent =
                    [val('city'), val('state'), val('pincode')].filter(Boolean).join(', ') || '—';
                document.getElementById('pvMap').textContent = val('googleMapLocation') || '—';
                document.getElementById('pvModes').textContent = checkedValues('consultationModes').join(', ') || '—';
                document.getElementById('pvAvail').textContent =
                    (checkedValues('availableDays').join(', ') || '—') +
                    ' · ' + (val('startTime') || '—') + '–' + (val('endTime') || '—');
                document.getElementById('pvSlot').textContent =
                    (val('slotDurationMinutes') || '—') + ' min slot · ' + (val('bufferMinutes') || '0') + ' min buffer';
                document.getElementById('pvBreak').textContent =
                    (val('breakStart') || '—') + '–' + (val('breakEnd') || '—');
                document.getElementById('pvBlocked').textContent = val('blockedDates') || '—';
                document.getElementById('pvAuto').textContent = checked('autoConfirm');
                document.getElementById('pvEmerg').textContent = checked('emergencyAvailable');
                document.getElementById('pvLang').textContent = val('languages') || '—';
                document.getElementById('pvServices').textContent = val('services') || '—';
                document.getElementById('pvFee').textContent =
                    val('consultationFee') !== '' ? '₹' + val('consultationFee') : '—';
                document.getElementById('pvOtherFees').textContent = [
                    val('chatFee') !== '' ? 'Chat ₹' + val('chatFee') : null,
                    val('callFee') !== '' ? 'Call ₹' + val('callFee') : null,
                    val('videoFee') !== '' ? 'Video ₹' + val('videoFee') : null
                ].filter(Boolean).join(' · ') || '—';
                document.getElementById('pvBio').textContent = val('bio') || '—';
                document.getElementById('pvUpi').textContent = val('upiId') || '—';
                document.getElementById('pvBank').textContent = val('bankDetails') || '—';

                document.getElementById('pvPhotoDoc').textContent =
                    fileLabel('profilePhoto', '${not empty doctor.profilePhotoPath ? "On file" : "Not uploaded"}');
                document.getElementById('pvIdDoc').textContent =
                    fileLabel('idProof', '${(not empty doctor.idProofPath or not empty doctor.identityDocumentPath) ? "On file" : "Not uploaded"}');
                document.getElementById('pvLicDoc').textContent =
                    fileLabel('medicalLicense', '${not empty doctor.medicalLicensePath ? "On file" : "Not uploaded"}');
                document.getElementById('pvCertDoc').textContent =
                    fileLabel('degreeCertificate', '${not empty doctor.degreeCertificatePath ? "On file" : "Not uploaded"}');

                editPanel.style.display = 'none';
                previewPanel.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }

            reviewBtn.addEventListener('click', showPreview);
            headerReviewBtn.addEventListener('click', showPreview);
            backEditBtn.addEventListener('click', () => {
                previewPanel.style.display = 'none';
                editPanel.style.display = 'block';
                saving = false;
                confirmSaveBtn.disabled = false;
                confirmSaveBtn.textContent = 'Confirm & Save';
            });
            confirmSaveBtn.addEventListener('click', () => {
                if (saving) return;
                if (!validateKeyFields('draft')) {
                    previewPanel.style.display = 'none';
                    editPanel.style.display = 'block';
                    return;
                }
                var intentField = document.getElementById('profileIntent');
                if (intentField) intentField.value = '';
                saving = true;
                confirmSaveBtn.disabled = true;
                confirmSaveBtn.textContent = 'Saving...';
                form.submit();
            });

            if (submitVerifyBtn) {
                submitVerifyBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    if (saving) return;
                    if (!validateKeyFields('verify')) {
                        previewPanel.style.display = 'none';
                        editPanel.style.display = 'block';
                        return;
                    }
                    var intentField = document.getElementById('profileIntent');
                    if (intentField) intentField.value = 'submitVerification';
                    saving = true;
                    submitVerifyBtn.textContent = 'Submitting...';
                    form.submit();
                });
            }

            form.addEventListener('submit', function (e) {
                if (!validateKeyFields('draft')) {
                    e.preventDefault();
                    saving = false;
                    return;
                }
            });

            updateLivePreview();
        })();
    </script>
</body>
</html>
