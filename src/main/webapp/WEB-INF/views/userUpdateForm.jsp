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

        .form-control,
        .form-select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 0.95rem;
            color: var(--fdf-text);
            background: #fff;
        }
        .form-control:focus,
        .form-select:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-control[readonly] {
            background: #f8f9fc;
            color: var(--fdf-muted);
        }

        input[type="file"].form-control {
            padding: 8px 12px;
        }
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

        .form-check {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px 14px;
            background: #faf7fb;
            border-radius: 12px;
            border: 1px solid var(--fdf-border);
        }
        .form-check-input {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            flex-shrink: 0;
            accent-color: var(--brand-pink);
        }
        .form-check-label {
            font-size: 0.9rem;
            color: var(--fdf-text);
            line-height: 1.45;
        }

        .btn-save {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 14px;
            background: var(--gradient-primary);
            color: #fff;
            font-weight: 700;
            font-size: 1rem;
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.25);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(244, 63, 94, 0.35);
            color: #fff;
        }

        .btn-cancel {
            display: block;
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: 2px solid var(--fdf-border);
            border-radius: 14px;
            background: #fff;
            color: var(--brand-purple);
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            border-color: var(--brand-purple);
            background: rgba(30, 27, 75, 0.04);
            color: var(--brand-purple);
        }

        .field-group {
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {
            #wrapper {
                flex-direction: column !important;
                margin-top: 68px !important;
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 12px 10px !important;
                width: 100% !important;
            }
            .update-page {
                padding: 8px 4px 32px;
            }
            .update-card {
                padding: 22px 16px;
                border-radius: 16px;
            }
            .update-title {
                font-size: 1.4rem;
            }
            .update-back-btn {
                width: 100%;
                justify-content: center;
                margin-bottom: 16px;
            }
        }

        @media (max-width: 430px) {
            .update-title {
                font-size: 1.25rem;
            }
            .form-control,
            .form-select {
                font-size: 16px;
            }
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
                <i class="bi bi-arrow-left"></i>
                Back to Profile
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

                    <div class="field-group">
                        <label class="form-label" for="name">Full Name</label>
                        <input type="text" name="name" id="name" class="form-control"
                               value="${user.fullName}" placeholder="Enter your full name" required
                               oninput="syncPreview()">
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input type="email" name="email" id="email" class="form-control"
                               value="${user.email}" readonly>
                        <div class="small text-muted mt-1">Email changes require OTP verification (not available in this step).</div>
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" name="phone" id="phone" class="form-control"
                               value="${user.phoneNumber}" placeholder="10-digit phone number"
                               pattern="[0-9]{10}" maxlength="10" minlength="10"
                               oninput="this.value=this.value.replace(/[^0-9]/g,''); syncPreview();" required>
                    </div>

                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <div class="field-group mb-0">
                                <label class="form-label" for="dob">Date of Birth</label>
                                <input type="date" id="dob" name="dob" class="form-control"
                                       value="${user.dob}" required onchange="syncPreview()">
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="field-group mb-0">
                                <label class="form-label" for="ageDisplay">Age</label>
                                <input type="number" id="ageDisplay" class="form-control"
                                       value="${user.age}" placeholder="Auto from DOB"
                                       min="0" max="120" readonly tabindex="-1">
                            </div>
                        </div>
                    </div>

                    <div class="field-group mt-3">
                        <label class="form-label" for="gender">Gender</label>
                        <select name="gender" id="gender" class="form-select" onchange="syncPreview()">
                            <option value="">Prefer not to say</option>
                            <option value="MALE"   ${user.gender eq 'MALE'   ? 'selected' : ''}>Male</option>
                            <option value="FEMALE" ${user.gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                            <option value="OTHER"  ${user.gender eq 'OTHER'  ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="address">Home Address</label>
                        <input type="text" name="address" id="address" class="form-control"
                               value="${user.homeAddress}" placeholder="Enter your address" required
                               oninput="syncPreview()">
                    </div>

                    <hr class="section-divider">

                    <div class="field-group">
                        <label class="form-label" for="identityFile">Identity Document (optional)</label>
                        <input type="file" name="identityFile" id="identityFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="image">Profile Photo</label>
                        <input type="file" name="image" id="image" class="form-control" accept="image/*" onchange="previewPhoto(this)">
                    </div>

                    <hr class="section-divider">

                    <div class="field-group mb-0">
                        <div class="form-check">
                            <input type="checkbox" name="isPrivate" class="form-check-input" id="isPrivate"
                                   ${user['private'] ? 'checked' : ''}>
                            <label class="form-check-label" for="isPrivate">
                                Private Account — only followers can see my reels
                            </label>
                        </div>
                    </div>

                    <!-- Preview card -->
                    <div id="profilePreviewCard" class="mt-4 p-4 rounded-4" style="background:#F8FAFC; border:1px solid #E2E8F0; display:none;">
                        <div class="fw-bold mb-3" style="color:#0F172A;"><i class="bi bi-eye me-1" style="color:#F43F5E;"></i> Profile Preview</div>
                        <div class="d-flex gap-3 align-items-center mb-3">
                            <img id="previewAvatar" src="${not empty user.profilePhoto ? user.profilePhoto : ''}" alt=""
                                 style="width:64px;height:64px;border-radius:50%;object-fit:cover;background:#FFE4E6; ${empty user.profilePhoto ? 'display:none;' : ''}">
                            <div id="previewAvatarFallback" style="width:64px;height:64px;border-radius:50%;background:#FFE4E6;color:#F43F5E;display:${empty user.profilePhoto ? 'flex' : 'none'};align-items:center;justify-content:center;font-weight:800;">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <div class="fw-bold" id="previewName" style="color:#0F172A;">${user.fullName}</div>
                                <div class="small text-muted" id="previewEmail">${user.email}</div>
                            </div>
                        </div>
                        <div class="small mb-1"><strong>Phone:</strong> <span id="previewPhone">${user.phoneNumber}</span></div>
                        <div class="small mb-1"><strong>DOB:</strong> <span id="previewDob">${user.dob}</span></div>
                        <div class="small mb-1"><strong>Gender:</strong> <span id="previewGender">${user.gender}</span></div>
                        <div class="small mb-3"><strong>Address:</strong> <span id="previewAddress">${user.homeAddress}</span></div>
                        <div class="d-flex gap-2 flex-wrap">
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
    el = document.getElementById('previewAddress'); if (el) el.textContent = document.getElementById('address').value || '—';
}
function showPreview() {
    if (!document.getElementById('profileUpdateForm').reportValidity()) return;
    syncPreview();
    document.getElementById('profilePreviewCard').style.display = 'block';
    document.getElementById('btn-preview').style.display = 'none';
    document.getElementById('profilePreviewCard').scrollIntoView({ behavior: 'smooth', block: 'center' });
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
    if (!input.files || !input.files[0]) return;
    var url = URL.createObjectURL(input.files[0]);
    var img = document.getElementById('previewAvatar');
    var fb = document.getElementById('previewAvatarFallback');
    img.src = url;
    img.style.display = 'block';
    fb.style.display = 'none';
}
document.addEventListener('DOMContentLoaded', function() {
    var dob = document.getElementById('dob');
    var ageDisplay = document.getElementById('ageDisplay');
    if (!dob || !ageDisplay) return;

    var today = new Date();
    var maxDob = today;
    var minDob = new Date(today.getFullYear() - 100, today.getMonth(), today.getDate());
    var fmt = function(d) { return d.toISOString().split('T')[0]; };
    dob.setAttribute('max', fmt(maxDob));
    dob.setAttribute('min', fmt(minDob));

    function syncAge() {
        if (!dob.value) return;
        var birthDate = new Date(dob.value + 'T00:00:00');
        var now = new Date();
        var computedAge = now.getFullYear() - birthDate.getFullYear();
        var m = now.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && now.getDate() < birthDate.getDate())) computedAge--;
        ageDisplay.value = computedAge;
        syncPreview();
    }

    dob.addEventListener('change', syncAge);
    syncAge();
});
</script>

</body>
</html>
