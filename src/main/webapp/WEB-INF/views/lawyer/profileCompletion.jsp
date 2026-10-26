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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --navy: #1E1B4B;
            --border: #E2E8F0;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background: var(--bg); color: var(--navy); display: flex; flex-direction: column; min-height: 100vh; }

        /* Top Bar */
        .topbar { background: var(--card-bg); padding: 14px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 50; }
        .brand { font-size: 1.25rem; font-weight: 800; color: var(--navy); display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .brand i { color: var(--primary); font-size: 1.5rem; }
        .topbar-actions { display: flex; gap: 12px; }
        .btn-skip { background: transparent; color: var(--navy); padding: 10px 20px; border: 1px solid var(--border); border-radius: 20px; font-weight: 600; cursor: pointer; text-decoration: none; transition: 0.2s; }
        .btn-skip:hover { background: #f1f5f9; }
        .btn-save { background: var(--primary); color: white; padding: 10px 20px; border: none; border-radius: 20px; font-weight: 600; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; text-decoration: none;}
        .btn-save:hover { background: var(--primary-hover); }

        /* Main Container */
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; width: 100%; }

        /* Left Side: Form */
        .form-section { background: var(--card-bg); border-radius: 16px; padding: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.02); border: 1px solid var(--border); }
        .progress-box { margin-bottom: 24px; }
        .progress-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .progress-header h2 { font-size: 1.15rem; font-weight: 800; }
        .status-badge { background: #e2e8f0; color: var(--secondary); font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 6px; text-transform: uppercase; }
        
        .progress-bar-bg { width: 100%; height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden; margin-bottom: 12px; }
        .progress-bar-fill { height: 100%; background: var(--primary); width: ${lawyer.profileCompletionPct != null ? lawyer.profileCompletionPct : 0}%; transition: 0.3s; }
        .progress-text { font-size: 0.85rem; color: var(--secondary); margin-bottom: 12px; }
        
        .steps { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 24px; }
        .step-badge { font-size: 0.75rem; font-weight: 600; color: var(--warning-text); background: var(--warning-bg); border: 1px solid #fed7aa; padding: 4px 10px; border-radius: 20px; display: flex; align-items: center; gap: 4px; }
        
        .btn-submit-admin { width: 100%; background: var(--primary); color: white; padding: 14px; border: none; border-radius: 12px; font-weight: 700; font-size: 1rem; cursor: pointer; transition: 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; margin-bottom: 30px; }
        .btn-submit-admin:hover { background: var(--primary-hover); }

        .section-title { font-size: 1.1rem; font-weight: 800; color: var(--navy); margin-top: 30px; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; padding-bottom: 10px; border-bottom: 1px solid var(--border); }
        .section-title:first-of-type { margin-top: 0; }
        
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: span 2; }
        .form-label { font-size: 0.85rem; font-weight: 600; color: var(--navy); }
        .form-input { padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; transition: 0.3s; }
        .form-input:focus { outline: none; border-color: var(--primary); }
        .form-select { padding: 12px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: inherit; font-size: 0.9rem; background: white; cursor: pointer; }
        .form-file { padding: 8px; border: 1px dashed var(--border); border-radius: 8px; background: #f8fafc; cursor: pointer; font-size: 0.85rem;}

        /* Right Side: Preview */
        .preview-section { position: sticky; top: 90px; }
        .preview-card { background: var(--card-bg); border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; }
        .preview-header { background: var(--navy); padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; }
        .live-badge { background: var(--primary); color: white; font-size: 0.7rem; font-weight: 800; padding: 4px 8px; border-radius: 12px; display: flex; align-items: center; gap: 4px; }
        .preview-header span { color: white; font-size: 0.75rem; font-weight: 600; letter-spacing: 1px; }
        
        .preview-body { padding: 24px; }
        .prev-avatar { width: 70px; height: 70px; border-radius: 16px; background: #ffe4e6; color: var(--primary); font-size: 2rem; font-weight: 800; display: flex; justify-content: center; align-items: center; margin-bottom: 16px; }
        .prev-name { font-size: 1.25rem; font-weight: 800; color: var(--navy); margin-bottom: 4px; display: flex; align-items: center; gap: 6px; }
        .prev-name i { color: var(--success-text); font-size: 1rem; }
        .prev-role { font-size: 0.85rem; font-weight: 600; color: var(--primary); margin-bottom: 4px; }
        .prev-location { font-size: 0.8rem; color: var(--secondary); display: flex; align-items: center; gap: 4px; margin-bottom: 20px; }
        
        .prev-box { background: var(--bg); border-radius: 10px; padding: 12px; margin-bottom: 16px; }
        .prev-box-title { font-size: 0.7rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-bottom: 4px; }
        .prev-box-val { font-size: 0.9rem; font-weight: 600; color: var(--navy); }
        
        .prev-section-title { font-size: 0.8rem; font-weight: 700; color: var(--secondary); text-transform: uppercase; margin-top: 20px; margin-bottom: 8px; }
        .prev-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .prev-tag { background: #ffe4e6; color: var(--primary); padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .prev-desc { font-size: 0.85rem; color: var(--navy); line-height: 1.5; margin-top: 10px; }
        .prev-footer { margin-top: 16px; font-size: 0.75rem; color: var(--secondary); display: flex; align-items: center; gap: 4px; }

        @media (max-width: 992px) {
            .container { grid-template-columns: 1fr; }
            .preview-section { display: none; }
        }
        
        /* ==========================================
           WOMEN LAWYER MOBILE RESPONSIVE
           ========================================== */
        @media (max-width: 768px) {
            body { overflow-x: hidden; width: 100%; margin: 0; padding: 0; }
            .topbar { padding: 12px 16px; flex-direction: column; gap: 12px; align-items: stretch; width: 100%; box-sizing: border-box; }
            .topbar-actions { width: 100%; display: flex; justify-content: space-between; gap: 8px; flex-wrap: wrap; }
            .btn-skip, .btn-save { flex: 1; text-align: center; justify-content: center; padding: 10px 0; min-width: 120px; }
            .container { margin: 16px auto; padding: 0 16px; width: 100%; max-width: 100%; box-sizing: border-box; display: block; }
            .form-section { padding: 16px 16px 150px 16px; width: 100%; box-sizing: border-box; overflow: hidden; }
            .form-grid { display: flex; flex-direction: column; gap: 16px; width: 100%; }
            input.form-input, select.form-select, textarea.form-input { width: 100%; box-sizing: border-box; }
            .progress-header { flex-direction: column; align-items: flex-start; gap: 8px; }
            .progress-header h2 { font-size: 1rem; word-break: break-word; white-space: normal; margin: 0; }
            .progress-text { word-break: break-word; white-space: normal; }
        }
    </style>
</head>
<body>

    <form id="profileForm" action="${pageContext.request.contextPath}/lawyer/profile-completion/save${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </c:if>
        <!-- Top Bar -->
        <header class="topbar">
            <a href="${pageContext.request.contextPath}/" class="brand" style="text-decoration:none; display: flex; align-items: center; gap: 10px;">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="FightDFear Logo" style="height:45px; width:auto; filter:drop-shadow(0 2px 8px rgba(243, 63, 94, 0.15));">
                <span style="font-size: 1.25rem; font-weight: 800; color: #1a1a2e; margin: 0; padding: 0;">Fight D Fear</span>
            </a>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/lawyer/dashboard" class="btn-skip">Skip for now</a>
                <button type="submit" class="btn-save">Save Profile</button>
            </div>
        </header>

        <div class="container">
            <!-- Left Form -->
            <div class="form-section">
                <div class="progress-box">
                    <div class="progress-header">
                        <h2 id="progress-text-h2">Profile Completion: 0%</h2>
                        <span class="status-badge">${lawyer.partnerProfileStatus != null ? lawyer.partnerProfileStatus : 'REGISTERED'}</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" id="progress-bar-fill" style="width: 0%;"></div>
                    </div>
                    <p class="progress-text" id="progress-desc-text">Complete all required sections below to submit your profile for Admin verification.</p>
                </div>

                <c:if test="${lawyer.partnerProfileStatus == 'REGISTERED' || empty lawyer.partnerProfileStatus}">
                    <button type="submit" name="submitForVerification" value="true" class="btn-submit-admin" id="btnSubmitAdmin" onclick="return confirm('Save and submit for verification?');" style="display:none;">
                        <i class="bi bi-send-fill"></i> Submit for Admin Verification
                    </button>
                </c:if>

                <h3 class="section-title">1. Lawyer Identity</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Full name *</label>
                        <input type="text" name="fullName" class="form-input" value="${lawyer.fullName}" required oninput="updatePreview('prevName', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Designation</label>
                        <input type="text" name="designation" class="form-input" value="${lawyer.designation != null ? lawyer.designation : 'Advocate'}" oninput="updatePreview('prevRole', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Official phone *</label>
                        <input type="tel" name="phone" class="form-input" value="${lawyer.phone}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">WhatsApp Number</label>
                        <input type="tel" name="whatsappNumber" class="form-input" value="${lawyer.whatsappNumber}" placeholder="WhatsApp No.">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Years of Experience</label>
                        <input type="number" name="experienceYears" class="form-input" value="${lawyer.experienceYears}" placeholder="e.g. 8">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Bar Council ID *</label>
                        <input type="text" name="barCouncilId" class="form-input" value="${lawyer.barCouncilId}" placeholder="e.g. MAH/1234/2020" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Languages Spoken</label>
                        <input type="text" name="languages" class="form-input" value="${lawyer.languages}" placeholder="English, Hindi, Marathi">
                    </div>
                    <div class="form-group full" style="border: 1px solid #FECDD3; background: #FFF5F7; border-radius: 12px; padding: 14px; margin-top: 6px;">
                        <label class="form-label" style="color: var(--primary); font-weight: 700;">
                            <i class="bi bi-camera-fill me-1"></i> Advocate Profile Photo
                        </label>
                        <div style="display:flex; align-items:center; gap:16px; flex-wrap:wrap;">
                            <div style="position:relative; width:70px; height:70px; flex-shrink:0;">
                                <c:choose>
                                    <c:when test="${not empty lawyer.profilePhoto}">
                                        <img id="lawyerPhotoPreview" src="${pageContext.request.contextPath}${lawyer.profilePhoto}" 
                                             alt="Profile Photo" style="width:70px; height:70px; border-radius:14px; object-fit:cover; border:2px solid var(--primary);">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="lawyerPhotoPreview" src="" alt="Profile Photo" 
                                             style="display:none; width:70px; height:70px; border-radius:14px; object-fit:cover; border:2px solid var(--primary);">
                                        <div id="lawyerPhotoFallback" style="width:70px; height:70px; border-radius:14px; background:#FFE4E6; color:var(--primary); font-size:1.8rem; font-weight:800; display:flex; align-items:center; justify-content:center;">
                                            ${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1).toUpperCase()}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="flex:1; min-width:200px;">
                                <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                    <label for="lawyerPhotoInput" style="background:var(--primary); color:white; padding:6px 14px; border-radius:8px; font-size:0.82rem; font-weight:700; cursor:pointer; margin:0; display:inline-flex; align-items:center; gap:6px;">
                                        <i class="bi bi-upload"></i> Upload Photo
                                    </label>
                                    <input type="file" id="lawyerPhotoInput" name="profilePhoto" accept="image/*" style="display:none;" onchange="previewLawyerPhoto(this)">
                                    <button type="button" id="btnClearLawyerPhoto" onclick="clearLawyerPhoto()" style="display:none; background:white; border:1px solid var(--border); color:var(--secondary); padding:6px 12px; border-radius:8px; font-size:0.8rem; cursor:pointer;">
                                        <i class="bi bi-x"></i> Clear
                                    </button>
                                </div>
                                <small style="display:block; margin-top:6px; font-size:0.75rem; color:var(--secondary);">JPG, PNG or WebP. A professional headshot builds client confidence.</small>
                            </div>
                        </div>
                    </div>
                </div>

                <h3 class="section-title">2. Professional Details</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Practice Areas / Specialization</label>
                        <input type="text" name="practiceAreas" class="form-input" value="${lawyer.practiceAreas}" placeholder="e.g. Family Law, Domestic Violence, Property Law" oninput="updateTagsPreview('prevPractice', this.value)">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Bio / About</label>
                        <textarea name="bio" class="form-input" rows="4" placeholder="Brief professional background..." oninput="updatePreview('prevBio', this.value)">${lawyer.bio}</textarea>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Who they serve</label>
                        <input type="text" name="audience" class="form-input" value="${lawyer.audience}" placeholder="e.g. Women, Children, Organizations">
                    </div>
                </div>

                <h3 class="section-title">3. Chamber Details & Location</h3>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Chamber Address</label>
                        <textarea name="address" class="form-input" rows="2" placeholder="Full address of your chamber/office">${lawyer.address}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">City</label>
                        <input type="text" name="city" class="form-input" value="${lawyer.city}" oninput="updatePreview('prevCity', this.value)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">State</label>
                        <input type="text" name="state" class="form-input" value="${lawyer.state}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Pincode</label>
                        <input type="text" name="pincode" class="form-input" value="${lawyer.pincode}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Chamber Photo</label>
                        <div style="display:flex; align-items:center; gap:8px;">
                            <input type="file" name="chamberPhoto" class="form-file" accept="image/*" style="flex:1;">
                            <c:if test="${not empty lawyer.galleryPhotos}">
                                <span style="font-size:0.75rem; color:var(--success-text); white-space:nowrap;"><i class="bi bi-check-circle-fill"></i> Uploaded</span>
                            </c:if>
                        </div>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Chamber Facilities</label>
                        <input type="text" name="facilities" class="form-input" value="${lawyer.facilities}" placeholder="e.g. Waiting Room, Washroom, Wheelchair Access">
                    </div>
                </div>

                <h3 class="section-title">4. Availability & Service</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Operating Days</label>
                        <input type="text" name="openDays" class="form-input" value="${lawyer.openDays}" placeholder="e.g. Mon-Sat">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Service Mode</label>
                        <select name="serviceMode" class="form-select">
                            <option value="Online" ${lawyer.serviceMode == 'Online' ? 'selected' : ''}>Online / Video Call</option>
                            <option value="Offline" ${lawyer.serviceMode == 'Offline' ? 'selected' : ''}>Offline / In Person</option>
                            <option value="Both" ${lawyer.serviceMode == 'Both' ? 'selected' : ''}>Both (Online & Offline)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Consultation Mode</label>
                        <input type="text" name="consultationMode" class="form-input" value="${lawyer.consultationMode}" placeholder="e.g. Chat, Video, Audio">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Open Time</label>
                        <input type="time" name="openTime" class="form-input" value="${lawyer.openTime}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Close Time</label>
                        <input type="time" name="closeTime" class="form-input" value="${lawyer.closeTime}">
                    </div>
                </div>

                <h3 class="section-title">5. Fees & Payment</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Consultation Fee (₹)</label>
                        <input type="number" name="consultationFee" class="form-input" value="${lawyer.consultationFee}" placeholder="Amount per session">
                    </div>
                    <div class="form-group">
                        <label class="form-label">UPI ID</label>
                        <input type="text" name="upiId" id="inputUpiId" class="form-input" value="${lawyer.upiId}" placeholder="yourname@upi">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Account Holder Name *</label>
                        <input type="text" id="bankAccountHolder" name="bankAccountHolder" class="form-input" placeholder="Name as in Bank passbook">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Bank Name *</label>
                        <input type="text" id="bankName" name="bankName" class="form-input" placeholder="e.g. State Bank of India, HDFC Bank">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Account Number *</label>
                        <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Enter bank account number" maxlength="20">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Re-enter Account Number *</label>
                        <input type="text" id="confirmAccountNumber" class="form-input" placeholder="Confirm bank account number" maxlength="20">
                        <small id="accMismatchMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Account numbers do not match
                        </small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">IFSC Code *</label>
                        <input type="text" id="bankIfsc" name="bankIfsc" class="form-input" placeholder="e.g. SBIN0001234" maxlength="11" style="text-transform: uppercase;">
                        <small id="ifscFormatMsg" style="color: #DC2626; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 4px;">
                            <i class="bi bi-exclamation-circle-fill"></i> Invalid IFSC format (e.g. SBIN0001234)
                        </small>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Branch Name</label>
                        <input type="text" id="bankBranch" name="bankBranch" class="form-input" placeholder="e.g. High Court Branch">
                    </div>

                    <!-- Hidden serialized bankDetails for DB compatibility -->
                    <input type="hidden" id="bankDetails" name="bankDetails" value="${lawyer.bankDetails}">
                </div>
            </div>

            <!-- Right Preview -->
            <div class="preview-section">
                <div class="preview-card">
                    <div class="preview-header">
                        <div class="live-badge"><span style="width:6px;height:6px;background:white;border-radius:50%;"></span> LIVE PREVIEW</div>
                        <span>LAWYER PROFILE</span>
                    </div>
                    <div class="preview-body">
                        <div class="prev-avatar">
                            <span id="prevInitials">${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1)}</span>
                        </div>
                        <div class="prev-name">
                            <span id="prevName">${empty lawyer.fullName ? 'Advocate Name' : lawyer.fullName}</span> <i class="bi bi-check-circle-fill"></i>
                        </div>
                        <div class="prev-role" id="prevRole">${empty lawyer.designation ? 'Advocate' : lawyer.designation}</div>
                        <div class="prev-location"><i class="bi bi-geo-alt-fill"></i> <span id="prevCity">${empty lawyer.city ? 'City' : lawyer.city}</span>, <span id="prevState">${empty lawyer.state ? 'State' : lawyer.state}</span></div>

                        <div class="prev-box" style="display:flex; justify-content:space-between;">
                            <div>
                                <div class="prev-box-title">Operating Timings</div>
                                <div class="prev-box-val">09:00 - 18:00</div>
                            </div>
                            <div style="text-align:right;">
                                <div class="prev-box-title">Service Type</div>
                                <div class="prev-box-val">Consultation</div>
                            </div>
                        </div>

                        <div class="prev-section-title">Practice Areas</div>
                        <div class="prev-tags" id="prevPractice">
                            <div class="prev-tag">Family Law</div>
                            <div class="prev-tag">Domestic Violence</div>
                        </div>

                        <div class="prev-section-title">About Lawyer</div>
                        <div class="prev-desc" id="prevBio">
                            ${empty lawyer.bio ? 'Professional lawyer dedicated to women\'s legal empowerment, guidance, and justice.' : lawyer.bio}
                        </div>

                        <div class="prev-footer">
                            <i class="bi bi-shield-lock-fill"></i> Public client preview • Updates live as you type
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
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

                    // Update live preview avatar on the right side
                    const prevAvatar = document.querySelector('.prev-avatar');
                    if (prevAvatar) {
                        prevAvatar.innerHTML = '<img src="' + e.target.result + '" style="width:70px; height:70px; border-radius:16px; object-fit:cover;">';
                    }
                    if (typeof calculateCompletion === 'function') calculateCompletion();
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
                const prevAvatar = document.querySelector('.prev-avatar');
                if (prevAvatar) {
                    const initial = "${empty lawyer.fullName ? 'L' : lawyer.fullName.substring(0,1)}";
                    prevAvatar.innerHTML = '<span id="prevInitials">' + initial + '</span>';
                }
            }
            if (typeof calculateCompletion === 'function') calculateCompletion();
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
            const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
            const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();
            const branch = document.getElementById('bankBranch')?.value.trim() || '';

            const ifscInput = document.getElementById('bankIfsc');
            if (ifscInput && ifscInput.value !== ifsc) ifscInput.value = ifsc;

            const mismatchEl = document.getElementById('accMismatchMsg');
            if (mismatchEl) {
                if (acc && confirmAcc && acc !== confirmAcc) {
                    mismatchEl.style.display = 'block';
                } else {
                    mismatchEl.style.display = 'none';
                }
            }

            const ifscMsg = document.getElementById('ifscFormatMsg');
            if (ifscMsg) {
                if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                    ifscMsg.style.display = 'block';
                } else {
                    ifscMsg.style.display = 'none';
                }
            }

            const hidden = document.getElementById('bankDetails');
            if (hidden) {
                if (acc || holder || bName) {
                    hidden.value = "Account Holder: " + holder + " | Bank: " + bName + " | A/C: " + acc + " | IFSC: " + ifsc + " | Branch: " + branch;
                }
            }
        }

        function calculateCompletion() {
            const fields = document.querySelectorAll('#profileForm .form-input, #profileForm .form-select');
            let filled = 0;
            let total = fields.length;
            fields.forEach(f => {
                if(f.value && f.value.trim() !== '') filled++;
            });

            // Include photo
            const hasPhoto = "${lawyer.profilePhoto}" !== "" || (document.getElementById('lawyerPhotoInput')?.files?.length > 0);
            if (hasPhoto) filled++;
            total++;

            let pct = Math.min(100, Math.round((filled / total) * 100));
            document.getElementById('progress-text-h2').textContent = 'Profile Completion: ' + pct + '%';
            document.getElementById('progress-bar-fill').style.width = pct + '%';

            const submitBtn = document.getElementById('btnSubmitAdmin');
            const descText = document.getElementById('progress-desc-text');
            const badge = document.querySelector('.status-badge');
            
            if(pct >= 100) {
                descText.textContent = "Profile 100% complete. You can now submit it for admin verification.";
                if(submitBtn) submitBtn.style.display = 'flex';
                if(badge && (badge.textContent.trim() === 'INCOMPLETE' || badge.textContent.trim() === 'REGISTERED')) {
                    badge.textContent = 'READY TO SUBMIT';
                }
            } else {
                descText.textContent = "Update your profile to 100% to submit for verification.";
                if(submitBtn) submitBtn.style.display = 'none';
                if(badge) badge.textContent = 'INCOMPLETE';
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            parseExistingBankDetails();

            ['bankAccountHolder', 'bankName', 'bankAccountNumber', 'confirmAccountNumber', 'bankIfsc', 'bankBranch'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', syncBankDetails);
                    el.addEventListener('blur', syncBankDetails);
                }
            });

            const form = document.getElementById('profileForm');
            if (form) {
                form.addEventListener('submit', function(e) {
                    syncBankDetails();
                    const acc = document.getElementById('bankAccountNumber')?.value.trim() || '';
                    const confirmAcc = document.getElementById('confirmAccountNumber')?.value.trim() || '';
                    const ifsc = (document.getElementById('bankIfsc')?.value.trim() || '').toUpperCase();

                    if (acc && confirmAcc && acc !== confirmAcc) {
                        e.preventDefault();
                        alert('Bank account numbers do not match. Please verify and correct.');
                        document.getElementById('confirmAccountNumber')?.focus();
                        return;
                    }

                    if (ifsc && !/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
                        e.preventDefault();
                        alert('Please enter a valid 11-character IFSC code (e.g. SBIN0001234).');
                        document.getElementById('bankIfsc')?.focus();
                        return;
                    }
                });
            }

            document.querySelectorAll('#profileForm input, #profileForm textarea, #profileForm select').forEach(f => {
                f.addEventListener('input', calculateCompletion);
                f.addEventListener('change', calculateCompletion);
            });
            calculateCompletion();
        });

        function updatePreview(id, value) {
            document.getElementById(id).textContent = value || (id === 'prevName' ? 'Advocate Name' : (id === 'prevRole' ? 'Advocate' : (id === 'prevCity' ? 'City' : '')));
            if(id === 'prevName' && value.length > 0) {
                const initials = document.getElementById('prevInitials');
                if (initials) initials.textContent = value.charAt(0).toUpperCase();
            }
        }
        function updateTagsPreview(id, value) {
            const container = document.getElementById(id);
            container.innerHTML = '';
            if(!value) {
                container.innerHTML = '<div class="prev-tag">Family Law</div>';
                return;
            }
            const parts = value.split(',');
            parts.forEach(p => {
                const trimmed = p.trim();
                if(trimmed) {
                    const tag = document.createElement('div');
                    tag.className = 'prev-tag';
                    tag.textContent = trimmed;
                    container.appendChild(tag);
                }
            });
        }
    </script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
