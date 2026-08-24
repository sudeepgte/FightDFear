<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Job Profile | Rubick FightDFire</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #f8f9fa;
        }
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--m-bg);
            color: #333;
        }
        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            border: none;
            margin-bottom: 30px;
        }
        .form-label {
            font-weight: 600;
            color: #4b5563;
            font-size: 0.9rem;
        }
        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px;
            border: 2px solid #f3e8ef;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--m-purple);
            box-shadow: none;
        }
        .btn-save {
            background-color: var(--m-purple);
            color: white;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
        }
        .btn-save:hover {
            background-color: var(--m-pink);
            color: white;
        }
    </style>
</head>
<body class="dd-page">
<div class="dd-overlay" id="overlay" onclick="toggleSidebar()"></div>

<%-- ═══ SIDEBAR ═══ --%>
<aside class="dd-sidebar" id="sidebar">
  <div class="dd-sidebar-brand">
    <div class="brand-icon"><i class="bi bi-briefcase"></i></div>
    <div class="brand-text">Fight D Fear<small>Worker Portal</small></div>
  </div>
  <div class="dd-sidebar-profile">
    <div class="avatar-placeholder">${user.fullName.charAt(0)}</div>
    <div class="profile-info">
      <div class="name">${user.fullName}</div>
      <div class="spec">${not empty workerApp.designation ? workerApp.designation : workerApp.jobCategory}</div>
    </div>
    <div class="status-dot"></div>
  </div>
  <nav class="dd-sidebar-nav">
    <div class="dd-nav-label">Main</div>
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="dd-nav-item">
      <i class="bi bi-grid-1x2"></i> Dashboard
    </a>
    <div class="dd-nav-label">Management</div>
    <a href="${pageContext.request.contextPath}/women-jobs/profile" class="dd-nav-item active">
      <i class="bi bi-person"></i> My Profile
    </a>
    <a href="${pageContext.request.contextPath}/women-jobs/earnings" class="dd-nav-item">
      <i class="bi bi-wallet2"></i> Earnings
    </a>
  </nav>
  <div class="dd-sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout" class="dd-nav-item" style="color:rgba(255,107,107,0.8)">
      <i class="bi bi-box-arrow-left"></i> Logout
    </a>
  </div>
</aside>

<%-- ═══ MAIN ═══ --%>
<main class="dd-main">
  <header class="dd-topbar">
    <div class="dd-topbar-left">
      <button class="dd-hamburger" onclick="toggleSidebar()"><i class="bi bi-list"></i></button>
      <div>
        <h1>My Profile</h1>
        <div class="breadcrumb-text">Manage your professional information</div>
      </div>
    </div>
    <div class="dd-topbar-right">
      <a href="${pageContext.request.contextPath}/users/dashboard" class="dd-nav-item" style="color: var(--dd-text); border: 1px solid var(--dd-border); border-radius: 12px; padding: 8px 16px; font-weight: 600; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; gap: 8px;">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
      </a>
    </div>
  </header>

  <div class="dd-content">
<div class="container" style="max-width: 1000px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1" style="color: var(--m-purple);"><i class="fas fa-user-cog"></i> My Job Profile</h2>
            <p class="text-muted small mb-0">Provide extra details to complete your verification and attract more clients</p>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="profile-card">
        <form action="${pageContext.request.contextPath}/women-jobs/profile" method="post">
            
            <!-- Section 1: Profile Summary -->
            <h4 class="fw-bold mb-3 pb-2 border-bottom" style="color: var(--m-purple);"><i class="fas fa-address-card me-2"></i> Professional Intro</h4>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label">Full Name (Read-Only)</label>
                    <input type="text" class="form-control bg-light" value="${workerApp.user.fullName}" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email Address (Read-Only)</label>
                    <input type="text" class="form-control bg-light" value="${workerApp.user.email}" readonly>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Designation / Title</label>
                    <input type="text" name="designation" class="form-control" placeholder="e.g. Senior Baby Care Specialist" value="${workerApp.designation}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Years of Experience</label>
                    <input type="number" name="yearsExperience" class="form-control" min="0" max="50" placeholder="e.g. 5" value="${workerApp.yearsExperience}">
                </div>
                <div class="col-12">
                    <label class="form-label">Brief Professional Bio</label>
                    <textarea name="bio" class="form-control" rows="3" placeholder="Tell clients about your work style, background, or child-care philosophy...">${workerApp.bio}</textarea>
                </div>
            </div>

            <!-- Section 2: Contact & Service Settings -->
            <h4 class="fw-bold mb-3 pb-2 border-bottom" style="color: var(--m-purple);"><i class="fas fa-sliders-h me-2"></i> Service Details</h4>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label">WhatsApp Number</label>
                    <input type="text" name="whatsappNumber" class="form-control" placeholder="e.g. 9876543210" value="${workerApp.whatsappNumber}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Hourly Rate (₹)</label>
                    <input type="number" name="hourlyRate" class="form-control" min="1" step="0.01" value="${workerApp.hourlyRate}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Languages Spoken</label>
                    <input type="text" name="languages" class="form-control" placeholder="e.g. English, Hindi, Punjabi" value="${workerApp.languages}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Skills / Services Offered</label>
                    <input type="text" name="skills" class="form-control" placeholder="e.g. CPR, Newborn Care, Cooking, Tutoring" value="${workerApp.skills}">
                </div>
            </div>

            <!-- Section 3: Location Details -->
            <h4 class="fw-bold mb-3 pb-2 border-bottom" style="color: var(--m-purple);"><i class="fas fa-map-marker-alt me-2"></i> Location Address</h4>
            <div class="row g-3 mb-4">
                <div class="col-12">
                    <label class="form-label">Full Address / Street Location</label>
                    <input type="text" name="address" class="form-control" placeholder="Flat, Street, Area info" value="${workerApp.address}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">City</label>
                    <input type="text" name="city" class="form-control" placeholder="City" value="${workerApp.city}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">State</label>
                    <input type="text" name="state" class="form-control" placeholder="State" value="${workerApp.state}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Pincode</label>
                    <input type="text" name="pincode" class="form-control" placeholder="6-digit Pincode" value="${workerApp.pincode}">
                </div>
            </div>

            <!-- Section 4: Bank Details -->
            <h4 class="fw-bold mb-3 pb-2 border-bottom" style="color: var(--m-purple);"><i class="fas fa-wallet me-2"></i> Payout Info</h4>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label">UPI ID for Payouts</label>
                    <input type="text" name="upiId" class="form-control" placeholder="e.g. upi-handle@bank" value="${workerApp.upiId}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Bank Account / IFSC Details (Alternative)</label>
                    <input type="text" name="bankDetails" class="form-control" placeholder="Bank Name, A/C No, IFSC" value="${workerApp.bankDetails}">
                </div>
            </div>

            <div class="text-end pt-3">
                <button type="submit" class="btn btn-save"><i class="fas fa-save me-2"></i> Save Profile Details</button>
            </div>
        </form>
    </div>
</div>

<!-- OTP Verification Modal -->
<div class="modal fade" id="otpConfirmModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="otpConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header bg-light" style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                <h5 class="modal-title fw-bold" id="otpConfirmModalLabel" style="color: var(--m-purple);"><i class="fas fa-user-shield me-2"></i> Security Verification</h5>
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
                        Didn't receive the OTP? <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" id="resendOtpBtn" style="color: var(--m-pink);">Resend OTP</button>
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
            if (!isProfileOtpVerified) {
                e.preventDefault();
                
                // Show loading/trigger send OTP
                sendProfileOtp();

                // Instantiate and show Modal
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
                // Submit the form
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
});
</script>
    </div><!-- /.container -->
  </div><!-- /.dd-content -->
</main>
<script>
    function toggleSidebar() {
        var sidebar = document.getElementById('sidebar');
        var overlay = document.getElementById('overlay');
        if (sidebar && overlay) {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('active');
        }
    }
</script>
</body>
</html>
