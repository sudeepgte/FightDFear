<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Update Profile | Fight D Fear</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--light-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }
        .update-page {
            max-width: 720px;
            margin: 0 auto;
            padding: 16px 12px 40px;
        }
        .update-back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #fff;
            color: var(--brand-purple) !important;
            border: 2px solid var(--brand-purple);
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s ease;
            margin-bottom: 20px;
        }
        .update-back-btn:hover {
            background: rgba(30, 27, 75, 0.06);
            border-color: var(--brand-pink);
            color: var(--brand-purple) !important;
        }
        .update-card {
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
            padding: 28px 24px;
        }
        .update-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.75rem;
            font-weight: 800;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 6px;
        }
        .update-subtitle {
            color: var(--fdf-muted);
            font-size: 0.92rem;
            margin-bottom: 24px;
        }
        .form-label {
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            color: var(--brand-purple);
            margin-bottom: 6px;
        }
        .form-control, .form-select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 0.95rem;
            color: var(--fdf-text);
            background: #fff;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-control[readonly] {
            background: #f8f9fc;
            color: var(--fdf-muted);
        }
        input[type="file"].form-control { padding: 8px 12px; }
        input[type="file"]::file-selector-button {
            background: var(--gradient-primary);
            border: none;
            border-radius: 8px;
            color: #fff;
            padding: 6px 14px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
        }
        .section-divider {
            border: none;
            border-top: 1px dashed var(--fdf-border);
            margin: 22px 0;
        }
        .field-group { margin-bottom: 16px; }
        .btn-save {
            width: 100%;
            border: none;
            border-radius: 50px;
            padding: 14px 24px;
            font-weight: 700;
            background: var(--gradient-primary);
            color: #fff;
        }
        .btn-cancel {
            display: block;
            text-align: center;
            margin-top: 14px;
            color: var(--fdf-muted);
            text-decoration: none;
            font-weight: 600;
        }
        @media (max-width: 768px) {
            .update-card { padding: 22px 16px; border-radius: 16px; }
            .update-title { font-size: 1.4rem; }
            .update-back-btn { width: 100%; justify-content: center; margin-bottom: 16px; }
        }
        @media (max-width: 430px) {
            .update-title { font-size: 1.25rem; }
            .form-control, .form-select { font-size: 16px; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">
        <div class="update-page">
            <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="update-back-btn">
                <i class="bi bi-arrow-left"></i> Back to Profile
            </a>

            <div class="update-card">
                <h1 class="update-title">Update Profile</h1>
                <p class="update-subtitle">Edit your details, preview the card, then confirm to save.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-3">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success rounded-3">${success}</div>
                </c:if>

                <div class="mb-4 p-3 rounded-4" style="background:#FFF1F2; border:1px solid #FECDD3;">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <strong style="color:#0F172A;">Profile completion</strong>
                        <span class="fw-bold" style="color:#F43F5E;">${profileCompletionPct != null ? profileCompletionPct : 0}%</span>
                    </div>
                    <div class="progress" style="height:8px; border-radius:999px; background:#FFE4E6;">
                        <div class="progress-bar" style="width:${profileCompletionPct != null ? profileCompletionPct : 0}%; background:#F43F5E;"></div>
                    </div>
                    <c:if test="${not empty profileMissingItems}">
                        <div class="small mt-2" style="color:#64748B;">
                            Missing:
                            <c:forEach var="m" items="${profileMissingItems}" varStatus="st">${m}<c:if test="${!st.last}">, </c:if></c:forEach>
                        </div>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/users/update/${user.id}" method="post" enctype="multipart/form-data" id="profileUpdateForm">
                    <input type="hidden" name="confirmSave" id="confirmSave" value="false">

                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Personal Details</h5>

                    <div class="field-group">
                        <label class="form-label" for="name">Full Name</label>
                        <input type="text" name="name" id="name" class="form-control" value="${user.fullName}" required oninput="syncPreview()">
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input type="email" name="email" id="email" class="form-control" value="${user.email}" readonly>
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" name="phone" id="phone" class="form-control" value="${user.phoneNumber}"
                               pattern="[0-9]{10}" maxlength="10" minlength="10" required
                               oninput="this.value=this.value.replace(/[^0-9]/g,''); syncPreview();">
                    </div>
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="dob">Date of Birth</label>
                            <input type="date" id="dob" name="dob" class="form-control" value="${user.dob}" onchange="syncPreview()">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="ageDisplay">Age</label>
                            <input type="number" id="ageDisplay" class="form-control" value="${user.age}" readonly tabindex="-1">
                        </div>
                    </div>
                    <div class="field-group mt-3">
                        <label class="form-label" for="gender">Gender</label>
                        <select name="gender" id="gender" class="form-select" onchange="syncPreview()">
                            <option value="">Prefer not to say</option>
                            <option value="FEMALE" ${user.gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                            <option value="OTHER"  ${user.gender eq 'OTHER'  ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="city">City / Location</label>
                        <input type="text" name="city" id="city" class="form-control" value="${user.city}" oninput="syncPreview()">
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="preferredLanguage">Preferred Language</label>
                        <select name="preferredLanguage" id="preferredLanguage" class="form-select" onchange="syncPreview()">
                            <option value="English" ${preferredLanguage eq 'English' ? 'selected' : ''}>English</option>
                            <option value="Hindi"   ${preferredLanguage eq 'Hindi'   ? 'selected' : ''}>Hindi</option>
                            <option value="Marathi" ${preferredLanguage eq 'Marathi' ? 'selected' : ''}>Marathi</option>
                            <option value="Tamil"   ${preferredLanguage eq 'Tamil'   ? 'selected' : ''}>Tamil</option>
                            <option value="Telugu"  ${preferredLanguage eq 'Telugu'  ? 'selected' : ''}>Telugu</option>
                            <option value="Kannada" ${preferredLanguage eq 'Kannada' ? 'selected' : ''}>Kannada</option>
                            <option value="Bengali" ${preferredLanguage eq 'Bengali' ? 'selected' : ''}>Bengali</option>
                            <option value="Gujarati"${preferredLanguage eq 'Gujarati'? 'selected' : ''}>Gujarati</option>
                            <option value="Other"   ${preferredLanguage eq 'Other'   ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <hr class="section-divider">
                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Address Details</h5>
                    <div class="field-group">
                        <label class="form-label" for="address">Home Address</label>
                        <input type="text" name="address" id="address" class="form-control" value="${user.homeAddress}" oninput="syncPreview()">
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="workCollegeAddress">Work / College Address</label>
                        <input type="text" name="workCollegeAddress" id="workCollegeAddress" class="form-control" value="${user.workCollegeAddress}" oninput="syncPreview()">
                    </div>

                    <hr class="section-divider">
                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Primary Emergency Contact</h5>
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="emergencyContactName">Contact Name</label>
                            <input type="text" name="emergencyContactName" id="emergencyContactName" class="form-control"
                                   value="${not empty user.emergencyContacts ? user.emergencyContacts[0].name : ''}" oninput="syncPreview()">
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="emergencyContactPhone">Contact Phone</label>
                            <input type="tel" name="emergencyContactPhone" id="emergencyContactPhone" class="form-control"
                                   value="${not empty user.emergencyContacts ? user.emergencyContacts[0].phone : ''}"
                                   pattern="[0-9]{10}" maxlength="10" minlength="10"
                                   oninput="this.value=this.value.replace(/[^0-9]/g,''); syncPreview();">
                        </div>
                    </div>
                    <div class="field-group mt-3">
                        <label class="form-label" for="emergencyContactRelation">Relationship</label>
                        <select name="emergencyContactRelation" id="emergencyContactRelation" class="form-select" onchange="syncPreview()">
                            <option value="Mother" ${not empty user.emergencyContacts && user.emergencyContacts[0].relation eq 'Mother' ? 'selected' : ''}>Mother</option>
                            <option value="Father" ${not empty user.emergencyContacts && user.emergencyContacts[0].relation eq 'Father' ? 'selected' : ''}>Father</option>
                            <option value="Spouse" ${not empty user.emergencyContacts && user.emergencyContacts[0].relation eq 'Spouse' ? 'selected' : ''}>Spouse</option>
                            <option value="Friend" ${not empty user.emergencyContacts && user.emergencyContacts[0].relation eq 'Friend' ? 'selected' : ''}>Friend</option>
                            <option value="Other"  ${not empty user.emergencyContacts && user.emergencyContacts[0].relation eq 'Other'  ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <hr class="section-divider">
                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Medical Information (optional)</h5>
                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="bloodGroup">Blood Group</label>
                            <select name="bloodGroup" id="bloodGroup" class="form-select" onchange="syncPreview()">
                                <option value="" ${empty user.medicalDetails || empty user.medicalDetails.bloodGroup ? 'selected' : ''}>Select Blood Group</option>
                                <option value="A+"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'A+'  ? 'selected' : ''}>A+</option>
                                <option value="A-"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'A-'  ? 'selected' : ''}>A-</option>
                                <option value="B+"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'B+'  ? 'selected' : ''}>B+</option>
                                <option value="B-"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'B-'  ? 'selected' : ''}>B-</option>
                                <option value="AB+" ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'AB+' ? 'selected' : ''}>AB+</option>
                                <option value="AB-" ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'AB-' ? 'selected' : ''}>AB-</option>
                                <option value="O+"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'O+'  ? 'selected' : ''}>O+</option>
                                <option value="O-"  ${not empty user.medicalDetails && user.medicalDetails.bloodGroup eq 'O-'  ? 'selected' : ''}>O-</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-6">
                            <label class="form-label" for="allergies">Allergies</label>
                            <input type="text" name="allergies" id="allergies" class="form-control"
                                   value="${not empty user.medicalDetails ? user.medicalDetails.allergies : ''}" oninput="syncPreview()">
                        </div>
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="medicalHistory">Medical History / Conditions</label>
                        <input type="text" name="medicalHistory" id="medicalHistory" class="form-control"
                               value="${not empty user.medicalDetails ? user.medicalDetails.medicalHistory : ''}" oninput="syncPreview()">
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="medications">Active Medications</label>
                        <input type="text" name="medications" id="medications" class="form-control"
                               value="${not empty user.medicalDetails ? user.medicalDetails.medications : ''}" oninput="syncPreview()">
                    </div>

                    <hr class="section-divider">
                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Identity Docs &amp; Photo</h5>
                    <div class="field-group">
                        <label class="form-label" for="identityFile">Identity Document (optional)</label>
                        <input type="file" name="identityFile" id="identityFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>
                    <div class="field-group">
                        <label class="form-label" for="image">Profile Photo</label>
                        <input type="file" name="image" id="image" class="form-control" accept="image/*" onchange="previewPhoto(this)">
                    </div>

                    <hr class="section-divider">
                    <h5 class="mb-3" style="color: var(--brand-purple); font-weight: 700;">Safety Preferences &amp; Account Settings</h5>
                    <div class="field-group">
                        <label class="form-label" for="safetyPreferences">Notification &amp; Sharing Preferences</label>
                        <select name="safetyPreferences" id="safetyPreferences" class="form-select">
                            <option value="ALERTS_AND_LOCATION" ${user.safetyPreferences eq 'ALERTS_AND_LOCATION' ? 'selected' : ''}>Enable real-time location sharing with emergency contacts and receive danger zone alerts</option>
                            <option value="ALERTS_ONLY" ${user.safetyPreferences eq 'ALERTS_ONLY' ? 'selected' : ''}>Danger zone alerting only</option>
                            <option value="NONE" ${user.safetyPreferences eq 'NONE' ? 'selected' : ''}>Disable safety notifications</option>
                        </select>
                    </div>
                    <div class="field-group mb-0">
                        <div class="form-check">
                            <input type="checkbox" name="isPrivate" class="form-check-input" id="isPrivate"
                                   <c:if test="${user.isPrivate()}">checked</c:if>>
                            <label class="form-check-label" for="isPrivate">Private Account — only followers can see my reels</label>
                        </div>
                    </div>

                    <div id="profilePreviewCard" class="mt-4 p-4 rounded-4" style="background:#F8FAFC; border:1px solid #E2E8F0; display:none;">
                        <div class="fw-bold mb-3"><i class="bi bi-eye me-1" style="color:#F43F5E;"></i> Profile Preview</div>
                        <div class="d-flex gap-3 align-items-center mb-3">
                            <img id="previewAvatar" src="${not empty user.profilePhoto ? user.profilePhoto : ''}" alt=""
                                 style="width:64px;height:64px;border-radius:50%;object-fit:cover;background:#FFE4E6; ${empty user.profilePhoto ? 'display:none;' : ''}">
                            <div>
                                <div class="fw-bold" id="previewName">${user.fullName}</div>
                                <div class="small text-muted" id="previewEmail">${user.email}</div>
                            </div>
                        </div>
                        <div class="row g-2 mb-3 small">
                            <div class="col-6"><strong>Phone:</strong> <span id="previewPhone">${user.phoneNumber}</span></div>
                            <div class="col-6"><strong>DOB:</strong> <span id="previewDob">${user.dob}</span></div>
                            <div class="col-6"><strong>Gender:</strong> <span id="previewGender">${user.gender}</span></div>
                            <div class="col-6"><strong>City:</strong> <span id="previewCity">${user.city}</span></div>
                        </div>
                        <div class="d-flex gap-2 flex-wrap mt-3">
                            <button type="button" class="btn btn-light rounded-pill px-3" onclick="hidePreview()">Edit</button>
                            <button type="button" class="btn rounded-pill px-4 fw-bold" style="background:#F43F5E;color:#fff;" onclick="confirmAndSave()">Confirm &amp; Save</button>
                        </div>
                    </div>

                    <button type="button" id="btn-preview" class="btn-save mt-4" onclick="showPreview()">Preview changes</button>
                </form>

                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="btn-cancel" id="btn-cancel">Cancel</a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
function syncPreview() {
    var el;
    el = document.getElementById('previewName'); if (el) el.textContent = document.getElementById('name').value || '—';
    el = document.getElementById('previewPhone'); if (el) el.textContent = document.getElementById('phone').value || '—';
    el = document.getElementById('previewDob'); if (el) el.textContent = document.getElementById('dob').value || '—';
    el = document.getElementById('previewGender'); if (el) el.textContent = document.getElementById('gender').value || '—';
    el = document.getElementById('previewCity'); if (el) el.textContent = document.getElementById('city').value || '—';
}
function showPreview() {
    syncPreview();
    document.getElementById('profilePreviewCard').style.display = 'block';
    document.getElementById('btn-preview').style.display = 'none';
}
function hidePreview() {
    document.getElementById('profilePreviewCard').style.display = 'none';
    document.getElementById('btn-preview').style.display = 'block';
}
function confirmAndSave() {
    document.getElementById('confirmSave').value = 'true';
    document.getElementById('profileUpdateForm').submit();
}
function previewPhoto(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var img = document.getElementById('previewAvatar');
            if (img) { img.src = e.target.result; img.style.display = 'block'; }
        };
        reader.readAsDataURL(input.files[0]);
    }
}
document.addEventListener('DOMContentLoaded', syncPreview);
</script>
</body>
</html>
