<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
>>>>>>> 16cf85ce996ab1a16542e394dc5bd4bcae6a13f5
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Complete Doctor Profile &mdash; Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <title>Complete Doctor Profile — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;

            --navy: #1E1B4B;

            --rose-soft: #FFF1F2;
            --rose-border: #FECDD3;
            --navy: #1E293B;

            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;

        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-page); color: var(--navy); }
        
        /* Top Navigation */
        .top-nav {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 24px;

            --success: #16A34A;
            --error: #DC2626;
            --error-bg: #FEF2F2;
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
            background: #fff;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;

            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;

            z-index: 100;
        }
        .brand { display: flex; align-items: center; gap: 10px; font-weight: 800; font-size: 1.15rem; color: var(--navy); text-decoration: none; }
        .brand img { height: 32px; width: 32px; border-radius: 8px; }
        .actions { display: flex; gap: 12px; align-items: center; }
        
        .btn { padding: 8px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem; cursor: pointer; transition: 0.2s; border: none; text-decoration: none; }
        .btn-outline { background: transparent; color: var(--navy); border: 1px solid var(--border-color); }
        .btn-outline:hover { background: #f1f5f9; }
        .btn-primary { background: var(--navy); color: #fff; }
        .btn-primary:hover { background: #312e81; }
        
        /* Layout */
        .layout { display: flex; gap: 30px; max-width: 1200px; margin: 30px auto; padding: 0 20px; align-items: flex-start; }
        .main-col { flex: 1; }
        .side-col { width: 380px; position: sticky; top: 90px; }
        
        /* Progress Box */
        .progress-box { background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border-color); padding: 20px; margin-bottom: 24px; }
        .progress-header { display: flex; justify-content: space-between; font-weight: 800; margin-bottom: 12px; }
        .progress-bar-bg { height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden; margin-bottom: 15px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: ${profileCompletion}%; transition: 1s ease-out; }
        .badge { background: #e2e8f0; color: #475569; padding: 4px 10px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; }
        
        /* Form Sections */
        .form-section { background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; margin-bottom: 24px; }
        .form-section h3 { font-size: 1.1rem; font-weight: 800; margin-bottom: 20px; color: var(--navy); }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; margin-bottom: 6px; color: var(--navy); }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 8px; font-family: inherit; font-size: 0.95rem; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(244,63,94,0.1); }
        
        /* Submit area */
        .submit-area { background: var(--primary); color: white; padding: 16px; border-radius: 12px; text-align: center; font-weight: 700; cursor: pointer; border: none; width: 100%; font-size: 1.05rem; box-shadow: 0 4px 15px rgba(244,63,94,0.3); transition: 0.2s; }
        .submit-area:hover { background: var(--primary-hover); transform: translateY(-2px); }
        
        /* Live Preview Card */
        .preview-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border-color); overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .preview-header { background: var(--navy); color: white; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }
        .preview-header span.tag { background: var(--primary); font-size: 0.7rem; font-weight: 800; padding: 4px 10px; border-radius: 50px; }
        .preview-body { padding: 24px; }
        .avatar { width: 80px; height: 80px; border-radius: 20px; background: #FFE4E6; color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 800; margin-bottom: 16px; }
        .p-name { font-size: 1.4rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; }
        .p-subtitle { color: var(--text-gray); font-size: 0.9rem; margin-bottom: 16px; font-weight: 500; }
        .p-badge { background: #F0FDF4; color: #16A34A; display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 50px; font-size: 0.75rem; font-weight: 700; margin-bottom: 20px; }
        
        .p-box { background: var(--bg-page); border: 1px solid var(--border-color); border-radius: 8px; padding: 12px; margin-bottom: 16px; }
        .p-box-title { font-size: 0.75rem; font-weight: 700; color: var(--text-gray); text-transform: uppercase; margin-bottom: 4px; }
        .p-box-value { font-weight: 600; color: var(--navy); font-size: 0.95rem; }
        
        .info-note { font-size: 0.8rem; color: var(--text-gray); display: flex; align-items: center; gap: 6px; }
        
        @media (max-width: 900px) {
            .layout { flex-direction: column; }
            .side-col { width: 100%; position: relative; top: 0; }

            z-index: 50;
            gap: 12px;
            flex-wrap: wrap;
        }
        .header-brand {
            display: flex; align-items: center; gap: 10px;
            font-size: 1.1rem; font-weight: 800; color: var(--navy); text-decoration: none;
        }
        .header-brand i { color: var(--primary); }
        .header-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .btn-skip, .btn-header-save, .btn-primary, .btn-ghost {
            border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            padding: 8px 16px; cursor: pointer; font-family: inherit; text-decoration: none;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
        }
        .btn-skip {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-skip:hover { background: var(--bg-page); }
        .btn-header-save, .btn-primary {
            border: none; background: var(--primary); color: #fff;
        }
        .btn-header-save:hover, .btn-primary:hover { background: var(--primary-hover); }
        .btn-ghost {
            border: 1px solid var(--border-color); background: #fff; color: var(--navy);
        }
        .btn-ghost:hover { background: var(--bg-page); }
        .main-container {
            flex: 1; max-width: 920px; width: 100%; margin: 24px auto 40px; padding: 0 16px;
        }
        .status-card {
            background: var(--rose-soft);
            border: 1px solid var(--rose-border);
            border-radius: 16px;
            padding: 18px 20px;
            margin-bottom: 20px;
            display: flex;
            gap: 18px;
            align-items: center;
            flex-wrap: wrap;
        }
        .pct-ring {
            width: 72px; height: 72px; border-radius: 50%;
            background: conic-gradient(var(--primary) calc(${profileCompletionPct} * 1%), #fecdd3 0);
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .pct-inner {
            width: 56px; height: 56px; border-radius: 50%; background: #fff;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.95rem; color: var(--navy);
        }
        .status-card h1 { font-size: 1.15rem; font-weight: 800; margin-bottom: 4px; }
        .status-card p { font-size: 0.88rem; color: var(--text-gray); line-height: 1.45; }
        .missing-list {
            margin-top: 10px; font-size: 0.82rem; color: var(--text-gray);
        }
        .missing-list span {
            display: inline-block; background: #fff; border: 1px solid var(--rose-border);
            border-radius: 999px; padding: 3px 10px; margin: 3px 4px 0 0;
        }
        .form-card, .preview-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 0.95rem; font-weight: 800; color: var(--primary);
            margin: 8px 0 16px; padding-bottom: 8px;
            border-bottom: 1px solid var(--rose-border);
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px 16px;
            margin-bottom: 8px;
        }
        .field.full { grid-column: 1 / -1; }
        .field label {
            display: block; font-size: 0.8rem; font-weight: 600; margin-bottom: 5px;
        }
        .field label .req { color: var(--primary); }
        .field input, .field select, .field textarea {
            width: 100%; padding: 11px 12px;
            border: 1px solid var(--border-color); border-radius: 10px;
            font-size: 0.92rem; font-family: inherit; background: #fff; color: var(--navy);
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }
        .field input:disabled { opacity: 0.65; background: #f8fafc; }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 4px; }
        .day-toggles, .mode-toggles {
            display: flex; flex-wrap: wrap; gap: 8px;
        }
        .chip {
            display: inline-flex; align-items: center; gap: 6px;
            border: 1px solid var(--border-color); border-radius: 999px;
            padding: 7px 12px; font-size: 0.82rem; font-weight: 600; cursor: pointer;
            background: #fff; user-select: none;
        }
        .chip input { accent-color: var(--primary); }
        .chip:has(input:checked) {
            background: var(--rose-soft); border-color: var(--primary); color: var(--primary);
        }
        .switch-row {
            display: flex; align-items: center; gap: 10px; font-size: 0.9rem; font-weight: 600;
        }
        .alert {
            padding: 12px 14px; border-radius: 10px; font-size: 0.88rem; font-weight: 600; margin-bottom: 16px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #fecaca; }
        .alert-ok { background: #F0FDF4; color: var(--success); border: 1px solid #bbf7d0; }
        .actions {
            display: flex; gap: 12px; flex-wrap: wrap; margin-top: 20px;
            border-top: 1px solid var(--border-color); padding-top: 18px;
        }
        .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip {
            flex: 1; min-width: 140px; padding: 12px 18px; font-size: 0.95rem;
        }
        .preview-row {
            display: flex; justify-content: space-between; gap: 12px;
            padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 0.9rem;
        }
        .preview-row:last-child { border-bottom: none; }
        .preview-row .k { color: var(--text-gray); }
        .preview-row .v { font-weight: 700; text-align: right; word-break: break-word; }
        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .status-card { flex-direction: column; align-items: flex-start; }
        }
        @media (max-width: 430px) {
            .app-header { padding: 12px 14px; }
            .form-card, .preview-card { padding: 18px 14px; }
            .actions .btn-primary, .actions .btn-ghost, .actions .btn-skip { min-width: 100%; }

        }
    </style>
</head>
<body>

    
    <form action="${pageContext.request.contextPath}/doctors/profile-completion" method="post" enctype="multipart/form-data" id="profileForm">
        <!-- Top Navigation -->
        <header class="top-nav">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"> Fight D Fear
            </a>
            <div class="actions">
                
                <button type="submit" name="action" value="skip" class="btn btn-outline" formnovalidate>Skip for now</button>
                <button type="submit" name="action" value="save" class="btn btn-primary">Save Profile</button>
            </div>
        </header>

        <div class="layout">
            <!-- Main Content Form -->
            <div class="main-col">
                <div class="progress-box">
                    <div class="progress-header">
                        <span>Profile Completion: ${profileCompletion}%</span>
                        <span class="badge">REGISTERED</span>
                    </div>
                    <div class="progress-bar-bg"><div class="progress-bar-fill"></div></div>
                    <p style="font-size: 0.85rem; color: var(--text-gray);">Complete all required sections below to build your public directory profile.</p>
                </div>
                
                <button type="submit" name="action" value="save" class="submit-area mb-4" style="margin-bottom: 24px;">
                    <i class="bi bi-cloud-arrow-up"></i> Save & View Dashboard
                </button>

                <div class="form-section">
                    <h3>1. Doctor Identity</h3>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="fullName" class="form-control" value="${doctor.fullName}" required oninput="document.getElementById('prevName').innerText = this.value || 'Doctor Name'">
                        </div>
                        <div class="form-group">
                            <label>Gender *</label>
                            <select name="gender" class="form-control" required>
                                <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Mobile Number *</label>
                            <input type="tel" name="phone" class="form-control" value="${doctor.phone}" required>
                        </div>
                        <div class="form-group">
                            <label>Profile Image (Optional)</label>
                            <input type="file" name="profilePhoto" class="form-control" accept="image/*">

    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/doctors/dashboard">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear"
                 style="height:32px;width:32px;border-radius:8px;object-fit:cover;">
            Fight D Fear
        </a>
        <div class="header-actions">
            <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
            <button type="button" class="btn-header-save" id="headerReviewBtn">Review &amp; Save</button>
        </div>
    </header>

    <main class="main-container">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-ok">${message}</div>
        </c:if>

        <div class="status-card">
            <div class="pct-ring"><div class="pct-inner">${profileCompletionPct}%</div></div>
            <div style="flex:1;min-width:200px;">
                <h1>Complete Doctor Profile</h1>
                <p><strong>${statusLabel}</strong> — ${nextStepGuidance}</p>
                <c:if test="${not empty missingItems}">
                    <div class="missing-list">
                        <c:forEach var="m" items="${missingItems}">
                            <span>${m}</span>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- EDIT -->
        <div id="editPanel">
            <form id="profileForm" action="${pageContext.request.contextPath}/doctors/profile-completion" method="post" enctype="multipart/form-data">
                <div class="form-card">
                    <div class="section-title">1. Personal Information</div>
                    <div class="grid">
                        <div class="field">
                            <label>Doctor name <span class="req">*</span></label>
                            <input type="text" name="fullName" id="fullName" value="${doctor.fullName}" required>
                        </div>
                        <div class="field">
                            <label>Email (read-only)</label>
                            <input type="email" value="${doctor.email}" disabled>
                        </div>
                        <div class="field">
                            <label>Phone <span class="req">*</span></label>
                            <input type="tel" name="phone" id="phone" value="${doctor.phone}" pattern="[0-9]{10}" maxlength="10" required>
                        </div>
                        <div class="field">
                            <label>Gender</label>
                            <select name="gender" id="gender">
                                <option value="FEMALE" ${doctor.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                <option value="MALE" ${doctor.gender == 'MALE' ? 'selected' : ''}>Male</option>
                                <option value="OTHER" ${doctor.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        <div class="field full">
                            <label>Profile photo</label>
                            <input type="file" name="profilePhoto" accept="image/jpeg,image/png,application/pdf">
                            <div class="hint">JPG / PNG / PDF, max 5 MB. <c:if test="${not empty doctor.profilePhotoPath}">Current file on file.</c:if></div>

                        </div>
                    </div>
                </div>

 HEAD
                <div class="form-section">
                    <h3>2. Professional Details</h3>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Specialization *</label>
                            <input type="text" name="specialization" class="form-control" value="${doctor.specialization}" placeholder="e.g. Gynecologist, Psychologist" required oninput="document.getElementById('prevSpec').innerText = this.value || 'Specialist'">
                        </div>
                        <div class="form-group">
                            <label>Experience (Years) *</label>
                            <input type="number" name="experienceYears" class="form-control" value="${doctor.experienceYears}" placeholder="e.g. 8" required oninput="document.getElementById('prevExp').innerText = (this.value ? this.value + ' Years Experience' : 'Experience')">
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Medical Reg Number *</label>
                            <input type="text" name="medicalRegNumber" class="form-control" value="${doctor.medicalRegNumber}" placeholder="e.g. MED-12345" required>
                        </div>
                        <div class="form-group">
                            <label>Highest Qualification *</label>
                            <input type="text" name="qualification" class="form-control" value="${doctor.qualification}" placeholder="e.g. MBBS, MD" required oninput="document.getElementById('prevQual').innerText = this.value || 'Qualification'">
                        </div>
                    </div>
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Current Hospital / Clinic</label>
                            <input type="text" name="hospitalName" class="form-control" value="${doctor.hospitalName}" placeholder="e.g. City Care Hospital">
                        </div>
                        <div class="form-group">
                            <label>Base Consultation Fee (&#8377;) *</label>
                            <input type="number" name="consultationFee" class="form-control" value="${doctor.consultationFee}" placeholder="500" required oninput="document.getElementById('prevFee').innerText = '&#8377;' + (this.value || '0')">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Medical License Document (PDF/Image)</label>
                        <input type="file" name="medicalLicense" class="form-control" accept="image/*,.pdf">
                    </div>
                </div>
            </div>

            <!-- Sidebar Live Preview -->
            <div class="side-col">
                <div class="preview-card">
                    <div class="preview-header">
                        <span class="tag"><i class="bi bi-circle-fill" style="font-size: 8px; margin-right: 4px;"></i> LIVE PREVIEW</span>
                        <span style="font-size: 0.75rem; font-weight: 700;">DOCTOR PROFILE</span>
                    </div>
                    <div class="preview-body">
                        <div class="avatar">
                            <c:choose>
                                <c:when test="${not empty doctor.profilePhotoPath}">
                                    <img src="${pageContext.request.contextPath}" style="width: 100%; height: 100%; border-radius: 20px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    ${not empty doctor.fullName ? doctor.fullName.substring(0,1) : 'D'}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="p-name" id="prevName">${not empty doctor.fullName ? doctor.fullName : 'Doctor Name'}</div>
                        <div class="p-subtitle" id="prevSpec">${not empty doctor.specialization ? doctor.specialization : 'Specialist'}</div>
                        <div class="p-badge"><i class="bi bi-patch-check-fill"></i> Verified Professional</div>
                        
                        <div class="p-box">
                            <div class="p-box-title">Qualification & Experience</div>
                            <div class="p-box-value"><span id="prevQual">${not empty doctor.qualification ? doctor.qualification : 'Qualification'}</span> &bull; <span id="prevExp">${not empty doctor.experienceYears ? doctor.experienceYears : '0'} Years Experience</span></div>
                        </div>
                        
                        <div class="p-box">
                            <div class="p-box-title">Consultation Fee</div>
                            <div class="p-box-value" id="prevFee" style="color: var(--primary);">&#8377;${not empty doctor.consultationFee ? doctor.consultationFee : '500'}</div>
                        </div>
                        
                        <div class="info-note mt-3">
                            <i class="bi bi-info-circle"></i> Public client preview &bull; Updates live as you type
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>



                <div class="form-card">
                    <div class="section-title">2. Professional Information</div>
                    <div class="grid">
                        <div class="field">
                            <label>Specialization <span class="req">*</span></label>
                            <input type="text" name="specialization" id="specialization" value="${doctor.specialization != null ? doctor.specialization : ''}" placeholder="e.g. Gynecologist">
                        </div>
                        <div class="field">
                            <label>Qualification <span class="req">*</span></label>
                            <input type="text" name="qualification" id="qualification" value="${doctor.qualification != null ? doctor.qualification : ''}" placeholder="e.g. MBBS, MD">
                        </div>
                        <div class="field">
                            <label>Medical registration number <span class="req">*</span></label>
                            <input type="text" name="medicalRegNumber" id="medicalRegNumber" value="${doctor.medicalRegNumber != null ? doctor.medicalRegNumber : ''}">
                        </div>
                        <div class="field">
                            <label>Years of experience <span class="req">*</span></label>
                            <input type="number" name="experienceYears" id="experienceYears" min="0" max="50" value="${doctor.experienceYears != null ? doctor.experienceYears : ''}">
                        </div>
                        <div class="field full">
                            <label>Languages <span class="req">*</span></label>
                            <input type="text" name="languages" id="languages" value="${doctor.languages != null ? doctor.languages : ''}" placeholder="e.g. English, Hindi">
                        </div>
                        <div class="field full">
                            <label>Services offered</label>
                            <input type="text" name="services" id="services" value="${doctor.services != null ? doctor.services : ''}" placeholder="Optional, comma-separated">
                        </div>
                        <div class="field full">
                            <label>Bio</label>
                            <textarea name="bio" id="bio" rows="3">${doctor.bio != null ? doctor.bio : ''}</textarea>
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="section-title">3. Practice / Address</div>
                    <div class="grid">
                        <div class="field full">
                            <label>Hospital / clinic name <span class="req">*</span></label>
                            <input type="text" name="hospitalName" id="hospitalName" value="${doctor.hospitalName != null ? doctor.hospitalName : ''}">
                        </div>
                        <div class="field full">
                            <label>Clinic address <span class="req">*</span></label>
                            <textarea name="clinicAddress" id="clinicAddress" rows="2">${doctor.clinicAddress != null ? doctor.clinicAddress : ''}</textarea>
                        </div>
                        <div class="field">
                            <label>City <span class="req">*</span></label>
                            <input type="text" name="city" id="city" value="${doctor.city != null ? doctor.city : ''}">
                        </div>
                        <div class="field">
                            <label>State <span class="req">*</span></label>
                            <input type="text" name="state" id="state" value="${doctor.state != null ? doctor.state : ''}">
                        </div>
                        <div class="field">
                            <label>Pincode <span class="req">*</span></label>
                            <input type="text" name="pincode" id="pincode" value="${doctor.pincode != null ? doctor.pincode : ''}" maxlength="6" pattern="\d{6}">
                        </div>
                        <div class="field">
                            <label>Google Maps location</label>
                            <input type="url" name="googleMapLocation" id="googleMapLocation" value="${doctor.googleMapLocation != null ? doctor.googleMapLocation : ''}" placeholder="https://maps.google.com/...">
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="section-title">4. Consultation &amp; Availability</div>
                    <div class="grid">
                        <div class="field full">
                            <label>Consultation modes <span class="req">*</span></label>
                            <div class="mode-toggles">
                                <c:set var="modes" value="${doctor.consultationModes != null ? doctor.consultationModes : (doctor.consultationType != null ? doctor.consultationType.name() : '')}" />
                                <label class="chip"><input type="checkbox" name="consultationModes" value="CLINIC" ${fn:contains(modes, 'CLINIC') || fn:contains(modes, 'OFFLINE') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Clinic</label>
                                <label class="chip"><input type="checkbox" name="consultationModes" value="VIDEO" ${fn:contains(modes, 'VIDEO') || fn:contains(modes, 'BOTH') ? 'checked' : ''}> Video</label>
                                <label class="chip"><input type="checkbox" name="consultationModes" value="ONLINE" ${fn:contains(modes, 'ONLINE') ? 'checked' : ''}> Online / Chat</label>
                            </div>
                        </div>
                        <div class="field full">
                            <label>Available days <span class="req">*</span></label>
                            <div class="day-toggles">
                                <c:set var="days" value="${doctor.availableDays != null ? doctor.availableDays : ''}" />
                                <label class="chip"><input type="checkbox" name="availableDays" value="MONDAY" ${fn:contains(days, 'MONDAY') ? 'checked' : ''}> Mon</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="TUESDAY" ${fn:contains(days, 'TUESDAY') ? 'checked' : ''}> Tue</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="WEDNESDAY" ${fn:contains(days, 'WEDNESDAY') ? 'checked' : ''}> Wed</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="THURSDAY" ${fn:contains(days, 'THURSDAY') ? 'checked' : ''}> Thu</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="FRIDAY" ${fn:contains(days, 'FRIDAY') ? 'checked' : ''}> Fri</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="SATURDAY" ${fn:contains(days, 'SATURDAY') ? 'checked' : ''}> Sat</label>
                                <label class="chip"><input type="checkbox" name="availableDays" value="SUNDAY" ${fn:contains(days, 'SUNDAY') ? 'checked' : ''}> Sun</label>
                            </div>
                        </div>
                        <div class="field">
                            <label>Start time <span class="req">*</span></label>
                            <input type="time" name="startTime" id="startTime" value="${doctor.startTime != null ? doctor.startTime : '09:00'}">
                        </div>
                        <div class="field">
                            <label>End time</label>
                            <input type="time" name="endTime" id="endTime" value="${doctor.endTime != null ? doctor.endTime : '18:00'}">
                        </div>
                        <div class="field full">
                            <label class="switch-row">
                                <input type="checkbox" name="emergencyAvailable" value="yes" ${doctor.emergencyAvailable != null && doctor.emergencyAvailable ? 'checked' : ''}>
                                Emergency / instant consult available
                            </label>
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="section-title">5. Fees &amp; Payout</div>
                    <div class="grid">
                        <div class="field">
                            <label>Consultation fee (₹) <span class="req">*</span></label>
                            <input type="number" name="consultationFee" id="consultationFee" min="0" step="1" value="${doctor.consultationFee != null ? doctor.consultationFee : ''}">
                        </div>
                        <div class="field">
                            <label>Video fee (₹)</label>
                            <input type="number" name="videoFee" id="videoFee" min="0" step="1" value="${doctor.videoFee != null ? doctor.videoFee : ''}">
                        </div>
                        <div class="field">
                            <label>Call fee (₹)</label>
                            <input type="number" name="callFee" id="callFee" min="0" step="1" value="${doctor.callFee != null ? doctor.callFee : ''}">
                        </div>
                        <div class="field">
                            <label>Chat fee (₹)</label>
                            <input type="number" name="chatFee" id="chatFee" min="0" step="1" value="${doctor.chatFee != null ? doctor.chatFee : ''}">
                        </div>
                        <div class="field">
                            <label>UPI ID</label>
                            <input type="text" name="upiId" id="upiId" value="${doctor.upiId != null ? doctor.upiId : ''}" placeholder="username@bank">
                        </div>
                        <div class="field">
                            <label>Bank details</label>
                            <input type="text" name="bankDetails" id="bankDetails" value="${doctor.bankDetails != null ? doctor.bankDetails : ''}">
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="section-title">6. Documents (optional for save)</div>
                    <p class="hint" style="margin-bottom:14px;">JPG, PNG or PDF up to 5 MB. Existing uploads are kept if you do not replace them.</p>
                    <div class="grid">
                        <div class="field">
                            <label>Government ID</label>
                            <input type="file" name="idProof" accept="image/jpeg,image/png,application/pdf">
                            <div class="hint"><c:choose><c:when test="${not empty doctor.idProofPath || not empty doctor.identityDocumentPath}">Uploaded</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                        </div>
                        <div class="field">
                            <label>Medical license</label>
                            <input type="file" name="medicalLicense" accept="image/jpeg,image/png,application/pdf">
                            <div class="hint"><c:choose><c:when test="${not empty doctor.medicalLicensePath}">Uploaded</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                        </div>
                        <div class="field">
                            <label>Medical registration certificate</label>
                            <input type="file" name="degreeCertificate" accept="image/jpeg,image/png,application/pdf">
                            <div class="hint"><c:choose><c:when test="${not empty doctor.degreeCertificatePath}">Uploaded</c:when><c:otherwise>Not uploaded</c:otherwise></c:choose></div>
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <a class="btn-skip" href="${pageContext.request.contextPath}/doctors/profile-completion/skip">Skip for now</a>
                    <button type="button" class="btn-primary" id="reviewBtn">Review profile</button>
                </div>
            </form>
        </div>

        <!-- PREVIEW -->
        <div id="previewPanel" style="display:none;">
            <div class="preview-card">
                <h2 style="font-size:1.2rem;font-weight:800;margin-bottom:6px;">Profile Review</h2>
                <p style="color:var(--text-gray);font-size:0.9rem;margin-bottom:12px;">Confirm your details before saving.</p>

                <div class="section-title">Personal Information</div>
                <div class="preview-row"><span class="k">Name</span><span class="v" id="pvFullName">—</span></div>
                <div class="preview-row"><span class="k">Email</span><span class="v">${doctor.email}</span></div>
                <div class="preview-row"><span class="k">Phone</span><span class="v" id="pvPhone">—</span></div>
                <div class="preview-row"><span class="k">Gender</span><span class="v" id="pvGender">—</span></div>

                <div class="section-title">Professional Information</div>
                <div class="preview-row"><span class="k">Specialization</span><span class="v" id="pvSpec">—</span></div>
                <div class="preview-row"><span class="k">Qualification</span><span class="v" id="pvQual">—</span></div>
                <div class="preview-row"><span class="k">Experience</span><span class="v" id="pvExp">—</span></div>
                <div class="preview-row"><span class="k">Medical Reg No.</span><span class="v" id="pvReg">—</span></div>
                <div class="preview-row"><span class="k">Languages</span><span class="v" id="pvLang">—</span></div>

                <div class="section-title">Practice / Address</div>
                <div class="preview-row"><span class="k">Hospital / Clinic</span><span class="v" id="pvHospital">—</span></div>
                <div class="preview-row"><span class="k">Address</span><span class="v" id="pvAddress">—</span></div>
                <div class="preview-row"><span class="k">City / State / Pin</span><span class="v" id="pvLocation">—</span></div>

                <div class="section-title">Availability &amp; Fees</div>
                <div class="preview-row"><span class="k">Modes</span><span class="v" id="pvModes">—</span></div>
                <div class="preview-row"><span class="k">Days / Hours</span><span class="v" id="pvAvail">—</span></div>
                <div class="preview-row"><span class="k">Consultation fee</span><span class="v" id="pvFee">—</span></div>

                <div class="section-title">Documents</div>
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
            function showPreview() {
                if (!val('fullName')) {
                    alert('Doctor name is required.');
                    return;
                }
                const phone = val('phone');
                if (phone && !/^\d{10}$/.test(phone)) {
                    alert('Phone number must be exactly 10 digits.');
                    return;
                }
                const pin = val('pincode');
                if (pin && !/^\d{6}$/.test(pin)) {
                    alert('Pincode must be exactly 6 digits.');
                    return;
                }
                const exp = val('experienceYears');
                if (exp !== '' && (Number(exp) < 0 || Number(exp) > 50)) {
                    alert('Years of experience must be between 0 and 50.');
                    return;
                }

                document.getElementById('pvFullName').textContent = val('fullName') || '—';
                document.getElementById('pvPhone').textContent = phone || '—';
                document.getElementById('pvGender').textContent = val('gender') || '—';
                document.getElementById('pvSpec').textContent = val('specialization') || '—';
                document.getElementById('pvQual').textContent = val('qualification') || '—';
                document.getElementById('pvExp').textContent = exp !== '' ? exp + ' years' : '—';
                document.getElementById('pvReg').textContent = val('medicalRegNumber') || '—';
                document.getElementById('pvLang').textContent = val('languages') || '—';
                document.getElementById('pvHospital').textContent = val('hospitalName') || '—';
                document.getElementById('pvAddress').textContent = val('clinicAddress') || '—';
                document.getElementById('pvLocation').textContent =
                    [val('city'), val('state'), val('pincode')].filter(Boolean).join(', ') || '—';
                document.getElementById('pvModes').textContent = checkedValues('consultationModes').join(', ') || '—';
                document.getElementById('pvAvail').textContent =
                    (checkedValues('availableDays').join(', ') || '—') +
                    ' · ' + (val('startTime') || '—') + '–' + (val('endTime') || '—');
                document.getElementById('pvFee').textContent =
                    val('consultationFee') !== '' ? '₹' + val('consultationFee') : '—';

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
                saving = true;
                confirmSaveBtn.disabled = true;
                confirmSaveBtn.textContent = 'Saving...';
                form.submit();
            });
        })();
    </script>
</body>
</html>

