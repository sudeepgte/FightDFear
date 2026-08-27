<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Job Profile | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-jobs-portal.css">
    <style>
        /* Profile-page only — does not load on dashboard/earnings */
        body.wj-profile-page {
            background: #F8FAFC;
            display: block;
        }
        body.wj-profile-page .wj-main { margin-left: 0; }
        body.wj-profile-page .wj-topbar {
            background: #FFFFFF;
            border-bottom: 1px solid #E2E8F0;
            padding: 20px 32px;
            box-shadow: 0 1px 0 rgba(30, 27, 75, 0.04);
        }
        body.wj-profile-page .wj-topbar h1 {
            font-size: 1.45rem;
            font-weight: 800;
            color: #1E1B4B;
            letter-spacing: -0.4px;
        }
        body.wj-profile-page .wj-topbar p {
            font-size: 0.9rem;
            color: #64748B;
            margin-top: 4px;
        }
        body.wj-profile-page .btn-skip {
            padding: 10px 18px;
            border: 1px solid #E2E8F0;
            background: #FFFFFF;
            color: #1E1B4B;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 42px;
            white-space: nowrap;
        }
        body.wj-profile-page .btn-skip:hover { background: #F8FAFC; color: #F43F5E; border-color: #F43F5E; }
        body.wj-profile-page .wj-content {
            max-width: 920px;
            margin: 0 auto;
            padding: 28px 24px 56px;
            width: 100%;
        }
        body.wj-profile-page .wj-card {
            border-radius: 20px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 10px 32px rgba(30, 27, 75, 0.06);
        }
        body.wj-profile-page .wj-card-b.padded { padding: 28px 32px 32px; }
        body.wj-profile-page .wj-progress { display: flex; gap: 10px; margin-bottom: 18px; }
        body.wj-profile-page .wj-progress span {
            flex: 1; height: 8px; border-radius: 99px; background: #E2E8F0;
        }
        body.wj-profile-page .wj-progress span.on { background: #F43F5E; }
        body.wj-profile-page .wj-step-title {
            font-size: 0.78rem;
            font-weight: 700;
            color: #1E1B4B;
            margin-bottom: 22px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        body.wj-profile-page .wj-row { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 20px; }
        body.wj-profile-page .wj-row .full { grid-column: 1 / -1; }
        body.wj-profile-page .wj-field { margin-bottom: 0; }
        body.wj-profile-page .wj-label { margin-bottom: 8px; font-weight: 600; }
        body.wj-profile-page .wj-input,
        body.wj-profile-page .wj-textarea {
            border-radius: 12px;
            border: 1px solid #E2E8F0;
            padding: 13px 14px;
        }
        body.wj-profile-page .wj-textarea { min-height: 108px; resize: vertical; }
        body.wj-profile-page .wj-nav-btns {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 28px;
            flex-wrap: wrap;
        }
        body.wj-profile-page .wj-btn,
        body.wj-profile-page .btn-save {
            height: 44px;
            min-width: 120px;
            padding: 0 22px;
            border-radius: 12px;
            font-weight: 700;
        }
        body.wj-profile-page #btnProfileNext {
            background: #F43F5E;
            color: #fff;
            border: none;
        }
        body.wj-profile-page #btnProfileNext:hover { background: #E11D48; color: #fff; }
        body.wj-profile-page #btnProfileBack {
            background: #FFFFFF;
            color: #1E1B4B;
            border: 1px solid #E2E8F0;
        }
        body.wj-profile-page .btn-save {
            background-color: #F43F5E;
            color: white;
            border: none;
            font-family: inherit;
        }
        body.wj-profile-page .btn-save:hover { background-color: #E11D48; color: white; }
        @media (max-width: 640px) {
            body.wj-profile-page .wj-row { grid-template-columns: 1fr; }
            body.wj-profile-page .wj-topbar { padding: 16px; flex-wrap: wrap; }
            body.wj-profile-page .wj-card-b.padded { padding: 20px 16px 24px; }
            body.wj-profile-page .wj-nav-btns { flex-direction: column; align-items: stretch; }
            body.wj-profile-page .wj-nav-btns > div { margin-left: 0 !important; width: 100%; }
            body.wj-profile-page .wj-nav-btns .wj-btn,
            body.wj-profile-page .wj-nav-btns .btn-save,
            body.wj-profile-page .wj-nav-btns .btn-skip { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body class="wj-page wj-profile-page">
<main class="wj-main">
  <header class="wj-topbar">
    <div>
        <h1>Complete your profile</h1>
        <p>Add professional details so clients can book you with confidence</p>
    </div>
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="btn-skip">Skip for now</a>
  </header>

  <div class="wj-content">
    <c:if test="${not empty success}">
        <div class="wj-alert wj-alert-ok"><i class="fas fa-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="wj-alert wj-alert-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>
    <div id="js-profile-error" class="wj-alert wj-alert-err" style="display:none;">
        <i class="fas fa-exclamation-circle"></i> <span id="js-profile-error-msg"></span>
    </div>

    <div class="wj-card">
        <div class="wj-card-b padded">
            <div class="wj-progress" id="profileProgress">
                <span class="on"></span><span></span><span></span><span></span>
            </div>
            <p class="wj-step-title" id="stepLabel">Step 1 of 4 — Professional intro</p>

            <form action="${pageContext.request.contextPath}/women-jobs/profile" method="post" id="workerProfileForm">

                <div class="wj-step" data-step="1">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">Full Name (Read-Only)</label>
                            <input type="text" class="wj-input" value="${workerApp.user.fullName}" readonly style="background:#F8FAFC;">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Email Address (Read-Only)</label>
                            <input type="text" class="wj-input" value="${workerApp.user.email}" readonly style="background:#F8FAFC;">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Designation / Title</label>
                            <input type="text" name="designation" class="wj-input" placeholder="e.g. Senior Baby Care Specialist" value="${workerApp.designation}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Years of Experience</label>
                            <input type="number" name="yearsExperience" class="wj-input" min="0" max="50" placeholder="e.g. 5" value="${workerApp.yearsExperience}">
                        </div>
                        <div class="wj-field full">
                            <label class="wj-label">Brief Professional Bio</label>
                            <textarea name="bio" class="wj-textarea" rows="3" placeholder="Tell clients about your work style, background, or child-care philosophy...">${workerApp.bio}</textarea>
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="2" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">WhatsApp Number</label>
                            <input type="text" name="whatsappNumber" class="wj-input" placeholder="e.g. 9876543210" value="${workerApp.whatsappNumber}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Hourly Rate (₹)</label>
                            <input type="number" name="hourlyRate" class="wj-input" min="1" step="0.01" value="${workerApp.hourlyRate}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Languages Spoken</label>
                            <input type="text" name="languages" class="wj-input" placeholder="e.g. English, Hindi, Punjabi" value="${workerApp.languages}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Skills / Services Offered</label>
                            <input type="text" name="skills" class="wj-input" placeholder="e.g. CPR, Newborn Care, Cooking, Tutoring" value="${workerApp.skills}">
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="3" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">Full Address / Street Location</label>
                            <input type="text" name="address" class="wj-input" placeholder="Flat, Street, Area info" value="${workerApp.address}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">City</label>
                            <input type="text" name="city" class="wj-input" placeholder="City" value="${workerApp.city}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">State</label>
                            <input type="text" name="state" class="wj-input" placeholder="State" value="${workerApp.state}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Pincode</label>
                            <input type="text" name="pincode" class="wj-input" placeholder="6-digit Pincode" value="${workerApp.pincode}">
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="4" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">UPI ID for Payouts</label>
                            <input type="text" name="upiId" class="wj-input" placeholder="e.g. upi-handle@bank" value="${workerApp.upiId}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Bank Account / IFSC Details (Alternative)</label>
                            <input type="text" name="bankDetails" class="wj-input" placeholder="Bank Name, A/C No, IFSC" value="${workerApp.bankDetails}">
                        </div>
                    </div>
                </div>

                <div class="wj-nav-btns">
                    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="btn-skip">Skip for now</a>
                    <button type="button" class="wj-btn wj-btn-ghost" id="btnProfileBack" style="display:none;">Back</button>
                    <div style="margin-left:auto;display:flex;gap:10px;align-items:center;">
                        <button type="button" class="wj-btn wj-btn-navy" id="btnProfileNext">Next</button>
                        <button type="submit" class="btn btn-save" id="btnProfileSave" style="display:none;"><i class="fas fa-save me-2"></i> Save Profile Details</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
  </div>
</main>

<div class="modal fade" id="otpConfirmModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="otpConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header bg-light" style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                <h5 class="modal-title fw-bold" id="otpConfirmModalLabel" style="color: #1E1B4B;"><i class="fas fa-user-shield me-2"></i> Security Verification</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <p class="text-muted small mb-4">
                    To save your profile changes, please verify your identity. A 6-digit OTP code has been sent to your registered email: <strong>${workerApp.user.email}</strong>
                </p>
                <div class="mb-3">
                    <input type="text" id="confirmOtpCode" class="form-control text-center fs-4 fw-bold letter-spacing-lg" placeholder="000000" maxlength="6" style="letter-spacing: 5px;" required>
                    <div id="otpModalError" class="text-danger small mt-2 d-none"></div>
                    <div id="otpModalSuccess" class="text-success small mt-2 d-none"></div>
                </div>
                <div class="mt-3">
                    <p class="text-muted small mb-0">
                        Didn't receive the OTP? <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" id="resendOtpBtn" style="color: #F43F5E;">Resend OTP</button>
                    </p>
                </div>
            </div>
            <div class="modal-footer" style="border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;">
                <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-save rounded-pill px-4" id="btnVerifyAndSubmit">Verify & Save</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const profileForm = document.querySelector('form[action$="/profile"]');
    let isProfileOtpVerified = false;
    let otpModalInstance = null;

    if (profileForm) {
        profileForm.addEventListener('submit', function(e) {
            var errBox = document.getElementById('js-profile-error');
            var errMsg = document.getElementById('js-profile-error-msg');
            errBox.style.display = 'none';
            var years = (profileForm.yearsExperience.value || '').trim();
            if (years !== '') {
                var y = parseInt(years, 10);
                if (isNaN(y) || y < 0 || y > 50) {
                    e.preventDefault();
                    errMsg.textContent = 'Years of Experience must be between 0 and 50.';
                    errBox.style.display = 'flex';
                    return;
                }
            }
            var rate = (profileForm.hourlyRate.value || '').trim();
            if (rate !== '') {
                var r = parseFloat(rate);
                if (isNaN(r) || r <= 0) {
                    e.preventDefault();
                    errMsg.textContent = 'Hourly rate must be greater than zero.';
                    errBox.style.display = 'flex';
                    return;
                }
            }
            var wa = (profileForm.whatsappNumber.value || '').trim();
            if (wa !== '' && !/^\d{10}$/.test(wa)) {
                e.preventDefault();
                errMsg.textContent = 'WhatsApp number must be exactly 10 digits.';
                errBox.style.display = 'flex';
                return;
            }
            var pin = (profileForm.pincode.value || '').trim();
            if (pin !== '' && !/^\d{6}$/.test(pin)) {
                e.preventDefault();
                errMsg.textContent = 'Pincode must be exactly 6 digits.';
                errBox.style.display = 'flex';
                return;
            }
            if (!isProfileOtpVerified) {
                e.preventDefault();
                sendProfileOtp();
                if (!otpModalInstance) {
                    otpModalInstance = new bootstrap.Modal(document.getElementById('otpConfirmModal'));
                }
                otpModalInstance.show();
            }
        });
    }

    function sendProfileOtp() {
        const errorDiv = document.getElementById('otpModalError');
        const successDiv = document.getElementById('otpModalSuccess');
        errorDiv.classList.add('d-none');
        successDiv.classList.add('d-none');

        const formData = new FormData();
        fetch('${pageContext.request.contextPath}/women-jobs/profile/send-otp', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                successDiv.innerText = "A new OTP code has been sent.";
                successDiv.classList.remove('d-none');
            } else {
                errorDiv.innerText = "Error sending OTP: " + data.message;
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(err => {
            errorDiv.innerText = "Network error. Please try again.";
            errorDiv.classList.remove('d-none');
        });
    }

    document.getElementById('resendOtpBtn').addEventListener('click', function(e) {
        e.preventDefault();
        sendProfileOtp();
    });

    document.getElementById('btnVerifyAndSubmit').addEventListener('click', function() {
        const otpCode = document.getElementById('confirmOtpCode').value.trim();
        const errorDiv = document.getElementById('otpModalError');
        const successDiv = document.getElementById('otpModalSuccess');

        errorDiv.classList.add('d-none');
        successDiv.classList.add('d-none');

        if (otpCode.length !== 6 || !/^\d+$/.test(otpCode)) {
            errorDiv.innerText = "Please enter a valid 6-digit OTP code.";
            errorDiv.classList.remove('d-none');
            return;
        }

        const formData = new FormData();
        formData.append('otp', otpCode);

        fetch('${pageContext.request.contextPath}/women-jobs/profile/verify-otp', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                isProfileOtpVerified = true;
                if (otpModalInstance) {
                    otpModalInstance.hide();
                }
                profileForm.submit();
            } else {
                errorDiv.innerText = data.message || "Invalid or expired OTP.";
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(err => {
            errorDiv.innerText = "Verification failed. Please try again.";
            errorDiv.classList.remove('d-none');
        });
    });

    var labels = [
        'Step 1 of 4 — Professional intro',
        'Step 2 of 4 — Service details',
        'Step 3 of 4 — Location address',
        'Step 4 of 4 — Payout info'
    ];
    var step = 1;
    function renderStep() {
        document.querySelectorAll('.wj-step').forEach(function(el) {
            el.style.display = String(el.getAttribute('data-step')) === String(step) ? 'block' : 'none';
        });
        document.querySelectorAll('#profileProgress span').forEach(function(el, i) {
            el.classList.toggle('on', i < step);
        });
        document.getElementById('stepLabel').textContent = labels[step - 1];
        document.getElementById('btnProfileBack').style.display = step === 1 ? 'none' : 'inline-flex';
        document.getElementById('btnProfileNext').style.display = step === 4 ? 'none' : 'inline-flex';
        document.getElementById('btnProfileSave').style.display = step === 4 ? 'inline-flex' : 'none';
    }
    document.getElementById('btnProfileNext').addEventListener('click', function() {
        if (step < 4) { step++; renderStep(); }
    });
    document.getElementById('btnProfileBack').addEventListener('click', function() {
        if (step > 1) { step--; renderStep(); }
    });
    renderStep();
});
</script>
</body>
</html>
