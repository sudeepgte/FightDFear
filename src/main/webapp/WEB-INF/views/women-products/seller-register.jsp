<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Registration — Women Products</title>
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
        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
        }
        .header-links a:hover { color: var(--primary); }
        .main-container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 28px auto 40px;
            padding: 0 16px;
        }
        .info-banner {
            background: var(--rose-soft);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
            border: 1px solid #FECDD3;
        }
        .info-banner h2 { font-size: 1.15rem; font-weight: 800; margin-bottom: 6px; }
        .info-banner p { font-size: 0.9rem; line-height: 1.45; }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .input-wrapper { position: relative; }
        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-field .form-input { padding-right: 42px; }
        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            padding: 4px;
            font-size: 1.1rem;
        }
        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .terms-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 16px 0 20px;
            font-size: 0.85rem;
            cursor: pointer;
        }
        .terms-row input[type="checkbox"] {
            margin-top: 2px;
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
            flex-shrink: 0;
        }
        .btn-submit {
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
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        }
        .btn-submit:hover { background: var(--primary-hover); }
        .login-footer { text-align: center; margin-top: 20px; font-size: 0.9rem; color: var(--text-gray); }
        .login-footer a { color: var(--primary); text-decoration: none; font-weight: 700; }
        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: flex-start;
            gap: 8px;
        }
        .alert-error { background: var(--error-bg); border: 1px solid #FECACA; color: var(--error); }
        .alert-success { background: var(--success-bg); border: 1px solid #BBF7D0; color: var(--success); }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 4px; }
        .otp-box { background:#F8FAFC; border:1px solid var(--border-color); border-radius:12px; padding:14px; margin-bottom:18px; }
        .otp-row { display:flex; gap:8px; flex-wrap:wrap; align-items:center; }
        .otp-row input { flex:1; min-width:120px; }
        .btn-otp { padding:10px 14px; border:none; border-radius:10px; background:var(--primary); color:#fff; font-weight:700; cursor:pointer; font-family:inherit; transition: background 0.3s; }
        .btn-otp:hover:not(:disabled) { background:var(--primary-hover); }
        .btn-otp:disabled { opacity:0.5; cursor:not-allowed; }
        .otp-msg { font-size:0.82rem; margin-top:8px; font-weight:600; }
        .otp-msg.ok { color:var(--success); }
        .otp-msg.err { color:var(--error); }
        .confirm-card {
            background: var(--card-bg);
            border: 1px solid #BBF7D0;
            border-radius: 16px;
            padding: 28px 24px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .confirm-icon { width:64px;height:64px;border-radius:50%;background:var(--success-bg);color:var(--success);display:inline-flex;align-items:center;justify-content:center;font-size:1.8rem;margin-bottom:12px; }
        .confirm-card h2 { font-size:1.3rem; font-weight:800; margin-bottom:10px; }
        .confirm-list { list-style:none; text-align:left; margin:16px 0; }
        .confirm-list li { display:flex; gap:8px; margin-bottom:8px; font-weight:600; }
        .confirm-list i { color:var(--success); }
        .confirm-next { background:var(--rose-soft); border-radius:12px; padding:12px; font-size:0.88rem; font-weight:600; margin:16px 0; }
        .btn-confirm { display:inline-flex; align-items:center; gap:8px; padding:12px 22px; background:var(--primary); color:#fff; border-radius:12px; text-decoration:none; font-weight:700; }
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 100; padding: 16px;
        }
        .modal-card {
            background: #FFFFFF; border-radius: 20px; max-width: 460px; width: 100%; padding: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .modal-header { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
        .modal-header .icon-wrap {
            width: 40px; height: 40px; border-radius: 10px; background: var(--rose-soft); color: var(--primary);
            display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0;
        }
        .modal-header h3 { font-size: 1.15rem; font-weight: 800; color: var(--navy); margin: 0; }
        .modal-body {
            background: var(--bg-page); border: 1px solid var(--border-color); border-radius: 12px;
            padding: 14px; margin-bottom: 20px;
        }
        .review-row {
            display: flex; justify-content: space-between; gap: 12px; padding: 8px 0;
            border-bottom: 1px dashed var(--border-color); font-size: 0.85rem;
        }
        .review-row:last-child { border-bottom: none; }
        .review-row .label { color: var(--text-gray); font-weight: 500; }
        .review-row .value { color: var(--navy); font-weight: 700; text-align: right; word-break: break-word; }
        .modal-actions { display: flex; gap: 10px; }
        .btn-modal-cancel {
            flex: 1; padding: 12px; background: #FFFFFF; border: 1px solid var(--border-color);
            color: var(--navy); border-radius: 10px; font-size: 0.9rem; font-weight: 700; cursor: pointer; font-family: inherit;
        }
        .btn-modal-confirm {
            flex: 1.5; padding: 12px; background: var(--primary); border: none; color: #FFFFFF;
            border-radius: 10px; font-size: 0.9rem; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px; font-family: inherit;
        }
        @media (max-width: 640px) {
            .row-2 { grid-template-columns: 1fr; }
            .app-header { padding: 12px 16px; }
            .form-card { padding: 22px 16px; }
        }
    </style>
</head>
<body class="wp-auth">
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/women-products">
            <i class="bi bi-bag-heart-fill"></i> Women Products
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/women-products/seller/login">Seller login</a>
        </div>
    </header>

    <main class="main-container">
        <div class="info-banner">
            <h2>Register as a Women Products seller</h2>
            <p>Create your shop account. An admin will verify your details before you can manage products and orders.</p>
        </div>

        <c:if test="${not empty success}">
            <div class="confirm-card" id="sellerRegConfirm">
                <div class="confirm-icon"><i class="bi bi-check-lg"></i></div>
                <h2>Registration successful</h2>
                <ul class="confirm-list">
                    <li><i class="bi bi-check-circle-fill"></i> Seller account / application created</li>
                    <li><i class="bi bi-check-circle-fill"></i> ${success}</li>
                </ul>
                <div class="confirm-next">Next step: sign in now to complete your shop profile.</div>
                <a class="btn-confirm" href="${pageContext.request.contextPath}/women-products/seller/login">Continue to Seller Login <i class="bi bi-arrow-right"></i></a>
            </div>
        </c:if>

        <div class="form-card"<c:if test="${not empty success}"> style="display:none;"</c:if>>
            <c:if test="${not empty error}">
                <div class="alert-box alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/women-products/seller/register" enctype="multipart/form-data" id="sellerForm" novalidate>
                <div class="row-2">
                    <div class="form-group">
                        <label for="fullName">Owner / contact name *</label>
                        <input class="form-input" type="text" name="fullName" id="fullName" minlength="2" maxlength="50" required
                               pattern="^[A-Za-z ]+$" placeholder="Your full name">
                    </div>
                    <div class="form-group">
                        <label for="businessName">Shop / business name *</label>
                        <input class="form-input" type="text" name="businessName" id="businessName" minlength="2" maxlength="100" required
                               placeholder="Shop name">
                    </div>
                </div>
                <div class="row-2">
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input class="form-input" type="email" name="email" id="email" required placeholder="you@email.com">
                    </div>
                    <div class="form-group">
                        <label for="phone">Mobile number *</label>
                        <input class="form-input" type="tel" name="phone" id="phone" required maxlength="10" inputmode="numeric"
                               pattern="^[6-9][0-9]{9}$" placeholder="10-digit mobile" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
                    </div>
                </div>
                <div class="otp-box">
                    <label>Email OTP *</label>
                    <div class="otp-row" style="margin-top:8px;">
                        <button type="button" class="btn-otp" id="btnSendOtp">Send OTP</button>
                        <input class="form-input" type="text" id="sellerOtp" maxlength="6" inputmode="numeric" placeholder="6-digit OTP" autocomplete="one-time-code" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
                        <button type="button" class="btn-otp" id="btnVerifyOtp">Verify OTP</button>
                    </div>
                    <div class="otp-msg" id="otpMsg"></div>
                </div>
                <div class="row-2">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <div class="input-wrapper password-field">
                            <input class="form-input" type="password" name="password" id="password" required minlength="6" placeholder="Create a password">
                            <button type="button" class="password-toggle-btn" data-target="password" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                        </div>
                        <div class="hint">At least 6 characters, with a number and a special character.</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm password *</label>
                        <div class="input-wrapper password-field">
                            <input class="form-input" type="password" name="confirmPassword" id="confirmPassword" required minlength="6" placeholder="Re-enter password">
                            <button type="button" class="password-toggle-btn" data-target="confirmPassword" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="address">Address *</label>
                    <input class="form-input" type="text" name="address" id="address" required minlength="10" maxlength="250" placeholder="Shop / warehouse address">
                </div>
                <div class="form-group">
                    <label for="city">City</label>
                    <input class="form-input" type="text" name="city" id="city" minlength="2" maxlength="50" pattern="^[A-Za-z \-]+$" placeholder="City (optional)">
                </div>
                <div class="row-2">
                    <div class="form-group">
                        <label for="profilePhoto">Profile photo *</label>
                        <input class="form-input file-input" type="file" name="profilePhoto" id="profilePhoto" accept=".jpg,.jpeg,.png" required>
                    </div>
                    <div class="form-group">
                        <label for="identityDoc">ID / document *</label>
                        <input class="form-input file-input" type="file" name="identityDoc" id="identityDoc" accept=".pdf,.jpg,.jpeg,.png" required>
                    </div>
                </div>
                <label class="terms-row">
                    <input type="checkbox" name="acceptedTerms" value="true" required>
                    <span>I accept the Terms and Privacy Policy for Women Products sellers.</span>
                </label>
                <button type="submit" class="btn-submit">Create seller account</button>
            </form>
            <p class="login-footer">Already registered? <a href="${pageContext.request.contextPath}/women-products/seller/login">Sign in</a></p>
        </div>
    </main>
    <div id="confirmModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <div class="icon-wrap"><i class="bi bi-shield-lock-fill"></i></div>
                <div>
                    <h3>Confirm Details</h3>
                    <p style="font-size: 0.8rem; color: var(--text-gray); margin: 0;">Review your information before account creation</p>
                </div>
            </div>
            <div class="modal-body">
                <div class="review-row"><span class="label">Shop Name:</span><span class="value" id="revShop">—</span></div>
                <div class="review-row"><span class="label">Contact Person:</span><span class="value" id="revName">—</span></div>
                <div class="review-row"><span class="label">Mobile Number:</span><span class="value" id="revPhone">—</span></div>
                <div class="review-row"><span class="label">Email:</span><span class="value" id="revEmail">—</span></div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-modal-cancel" id="btnConfirmBack">Back / Edit</button>
                <button type="button" class="btn-modal-confirm" id="btnConfirmRegister">
                    Confirm &amp; Register <i class="bi bi-check2-circle"></i>
                </button>
            </div>
        </div>
    </div>
    <script>
        document.querySelectorAll('.password-toggle-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var input = document.getElementById(btn.getAttribute('data-target'));
                var icon = btn.querySelector('i');
                if (!input) return;
                var show = input.type === 'password';
                input.type = show ? 'text' : 'password';
                icon.className = show ? 'bi bi-eye' : 'bi bi-eye-slash';
            });
        });
        var otpVerified = false;
        var wpConfirmReady = false;
        var ctx = '${pageContext.request.contextPath}';
        var otpTimerInterval = null;

        function setOtpMsg(text, ok) {
            var el = document.getElementById('otpMsg');
            el.textContent = text;
            el.className = 'otp-msg ' + (ok ? 'ok' : 'err');
        }

        function startOtpTimer(btn) {
            var timeLeft = 60;
            btn.disabled = true;
            btn.textContent = 'Resend in ' + timeLeft + 's';
            if (otpTimerInterval) clearInterval(otpTimerInterval);
            otpTimerInterval = setInterval(function() {
                timeLeft--;
                if (timeLeft <= 0) {
                    clearInterval(otpTimerInterval);
                    btn.disabled = false;
                    btn.textContent = 'Resend OTP';
                } else {
                    btn.textContent = 'Resend in ' + timeLeft + 's';
                }
            }, 1000);
        }

        document.getElementById('btnSendOtp').addEventListener('click', function () {
            var email = document.getElementById('email').value.trim().toLowerCase();
            if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
                setOtpMsg('Please enter a valid email address.', false);
                return;
            }
            otpVerified = false;
            var btn = this;
            startOtpTimer(btn);
            
            fetch(ctx + '/women-products/seller/send-otp?email=' + encodeURIComponent(email), {
                method: 'POST'
            }).then(function (r) { return r.json(); })
              .then(function (data) {
                  var ok = !!data.success;
                  setOtpMsg(data.message || data.error || (ok ? 'OTP sent' : 'Could not send OTP'), ok);
                  if (ok) {
                      // alert('OTP sent to your email (' + email + ')! Please check your inbox or spam folder.');
                  } else {
                      clearInterval(otpTimerInterval);
                      btn.disabled = false;
                      btn.textContent = 'Send OTP';
                      if (data.error && data.error.toLowerCase().includes('already')) {
                          setOtpMsg('This email is already registered.', false);
                      }
                  }
              }).catch(function () { 
                  clearInterval(otpTimerInterval);
                  btn.disabled = false;
                  btn.textContent = 'Send OTP';
                  setOtpMsg('Could not send OTP.', false); 
              });
        });

        document.getElementById('btnVerifyOtp').addEventListener('click', function () {
            var email = document.getElementById('email').value.trim().toLowerCase();
            var otp = document.getElementById('sellerOtp').value.replace(/\D/g, '');
            if (otp.length !== 6) {
                setOtpMsg('Please enter the 6-digit OTP.', false);
                return;
            }
            fetch(ctx + '/women-products/seller/verify-otp?email=' + encodeURIComponent(email) + '&otp=' + encodeURIComponent(otp), {
                method: 'POST'
            }).then(function (r) { return r.json(); })
              .then(function (data) {
                  otpVerified = !!data.success;
                  if (otpVerified) {
                      setOtpMsg('✓ Email verified', true);
                      clearInterval(otpTimerInterval);
                      document.getElementById('btnSendOtp').disabled = true;
                      document.getElementById('btnSendOtp').textContent = 'Verified';
                  } else {
                      var errMsg = data.message || data.error || 'Invalid OTP.';
                      if (errMsg.toLowerCase().includes('expire')) {
                          errMsg = 'OTP has expired. Please request a new OTP.';
                      } else if (!data.message && !data.error) {
                          errMsg = 'Invalid OTP.';
                      }
                      setOtpMsg(errMsg, false);
                  }
              }).catch(function () { otpVerified = false; setOtpMsg('Verification failed.', false); });
        });
        document.getElementById('email').addEventListener('change', function () { otpVerified = false; });
        
        document.getElementById('sellerForm').addEventListener('submit', function (e) {
            var fullName = document.getElementById('fullName').value.trim();
            var businessName = document.getElementById('businessName').value.trim();
            var email = document.getElementById('email').value.trim();
            var phone = document.getElementById('phone').value.trim();
            var pass = document.getElementById('password').value;
            var confirm = document.getElementById('confirmPassword').value;
            var address = document.getElementById('address').value.trim();
            var city = document.getElementById('city').value.trim();
            var photo = document.getElementById('profilePhoto');
            var identity = document.getElementById('identityDoc');
            var terms = this.querySelector('[name="acceptedTerms"]');

            if (!/^[A-Za-z ]{2,50}$/.test(fullName)) {
                e.preventDefault(); alert('Please enter a valid owner name.'); return;
            }
            if (businessName.length < 2 || businessName.length > 100) {
                e.preventDefault(); alert('Please enter your shop or business name.'); return;
            }
            if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
                e.preventDefault(); alert('Please enter a valid email address.'); return;
            }
            if (!/^[6-9]\d{9}$/.test(phone)) {
                e.preventDefault(); alert('Please enter a valid 10-digit mobile number.'); return;
            }
            if (!otpVerified) {
                e.preventDefault(); alert('Please verify the email OTP before creating the account.'); return;
            }
            if (!/^(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{6,}$/.test(pass)) {
                e.preventDefault(); alert('Password must contain at least 6 characters, 1 number and 1 special character.'); return;
            }
            if (pass !== confirm) {
                e.preventDefault(); alert('Passwords do not match.'); return;
            }
            if (address.length < 10 || address.length > 250) {
                e.preventDefault(); alert('Please enter a valid shop / warehouse address.'); return;
            }
            if (city.length > 0 && !/^[A-Za-z \-]{2,50}$/.test(city)) {
                e.preventDefault(); alert('Please enter a valid city name.'); return;
            }
            if (!photo.files || photo.files.length === 0) {
                e.preventDefault(); alert('Profile photo is required.'); return;
            } else {
                var pExt = photo.files[0].name.split('.').pop().toLowerCase();
                if (!['jpg', 'jpeg', 'png'].includes(pExt)) {
                    e.preventDefault(); alert('Only JPG, JPEG and PNG files are allowed.'); return;
                }
                if (photo.files[0].size > 5 * 1024 * 1024) {
                    e.preventDefault(); alert('Profile photo must be less than 5 MB.'); return;
                }
            }
            if (!identity.files || identity.files.length === 0) {
                e.preventDefault(); alert('ID / document is required.'); return;
            } else {
                var iExt = identity.files[0].name.split('.').pop().toLowerCase();
                if (!['pdf', 'jpg', 'jpeg', 'png'].includes(iExt)) {
                    e.preventDefault(); alert('Unsupported file format.'); return;
                }
                if (identity.files[0].size > 10 * 1024 * 1024) {
                    e.preventDefault(); alert('Document must be less than 10 MB.'); return;
                }
            }
            if (!terms || !terms.checked) {
                e.preventDefault(); alert('Please accept the Terms and Privacy Policy.'); return;
            }

            document.getElementById('fullName').value = fullName;
            document.getElementById('businessName').value = businessName;
            document.getElementById('email').value = email;
            document.getElementById('phone').value = phone;
            document.getElementById('address').value = address;
            document.getElementById('city').value = city;

            if (!wpConfirmReady) {
                e.preventDefault(); // Stop submission to show confirmation modal
                document.getElementById('revShop').textContent = businessName;
                document.getElementById('revName').textContent = fullName;
                document.getElementById('revPhone').textContent = phone;
                document.getElementById('revEmail').textContent = email;
                document.getElementById('confirmModal').style.display = 'flex';
            }
            // If wpConfirmReady is true, we do NOT preventDefault, letting the form submit normally!
        });
        document.getElementById('btnConfirmBack').addEventListener('click', function () {
            document.getElementById('confirmModal').style.display = 'none';
            wpConfirmReady = false;
        });
        document.getElementById('btnConfirmRegister').addEventListener('click', function () {
            wpConfirmReady = true;
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('sellerForm').requestSubmit();
        });
    </script>
</body>
</html>
