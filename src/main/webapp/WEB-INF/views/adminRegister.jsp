<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration - Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-portal.css">
</head>
<body class="ap-auth-body">
    <div class="ap-auth-shell">
        <div class="ap-auth-visual">
            <div style="font-weight:800;font-size:1.1rem;margin-bottom:18px;opacity:.95;">
                <i class="bi bi-shield-lock-fill"></i> Fight D Fear Admin
            </div>
            <h1>Create Admin</h1>
            <p>Register an administrator account to manage users, providers, SOS alerts, and platform settings.</p>
            <ul>
                <li><span><i class="bi bi-person-plus-fill"></i></span> Secure admin onboarding</li>
                <li><span><i class="bi bi-shield-check"></i></span> Controlled platform access</li>
                <li><span><i class="bi bi-gear-fill"></i></span> Full module management</li>
                <li><span><i class="bi bi-database-fill-check"></i></span> Verified data administration</li>
            </ul>
        </div>

        <div class="ap-auth-form">
            <div class="ap-auth-card">
                <a class="back" href="${pageContext.request.contextPath}/index.html"><i class="bi bi-arrow-left"></i> Return Home</a>
                <h2>Admin Register</h2>
                <p class="sub">Create a new administrator account</p>

                <c:if test="${not empty error}">
                    <div class="alert-err"><i class="bi bi-exclamation-octagon-fill"></i> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/registerAdmin" method="post" id="adminRegisterForm">
                    <div class="field">
                        <label for="name">Admin Username <span style="color:#DC2626;">*</span></label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-person"></i>
                            <input type="text" id="name" name="name" class="ap-input"
                                   placeholder="Enter admin username" minlength="3" maxlength="20" required
                                   oninput="this.value=this.value.slice(0,20).replace(/[^a-zA-Z0-9._\-\s]/g,'')">
                        </div>
                        <div class="hint">3-20 characters maximum.</div>
                    </div>

                    <div class="field">
                        <label for="email">Admin Email <span style="color:#DC2626;">*</span></label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-envelope"></i>
                            <input type="email" id="email" name="email" class="ap-input"
                                   placeholder="admin@example.com"
                                   pattern="[a-zA-Z0-9._+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}" required>
                        </div>
                    </div>

                    <div class="field">
                        <label for="password">Password <span style="color:#DC2626;">*</span></label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-lock"></i>
                            <input type="password" id="password" name="password" class="ap-input"
                                   placeholder="••••••••"
                                   pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&amp;*]).{8,}"
                                   title="At least 8 characters with uppercase, lowercase, number, and special character"
                                   required autocomplete="new-password" style="padding-right:44px;">
                            <button type="button" class="pw-btn" data-toggle-password="password" aria-label="Show password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="hint"><strong>At least 8 characters</strong> with uppercase, lowercase, a number, and a special character.</div>
                    </div>

                    <div class="field">
                        <label for="confirmPassword">Confirm Password <span style="color:#DC2626;">*</span></label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-lock-fill"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="ap-input"
                                   placeholder="••••••••" required autocomplete="new-password" style="padding-right:44px;">
                            <button type="button" class="pw-btn" data-toggle-password="confirmPassword" aria-label="Show confirm password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div id="confirmPasswordError" style="display:none;color:#b91c1c;font-size:0.8rem;margin-top:6px;">Passwords do not match.</div>
                    </div>

                    <button type="submit" class="ap-auth-submit">
                        Create Admin Account <i class="bi bi-arrow-right"></i>
                    </button>
                </form>

                <div class="foot">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/admin/loginAdmin">Sign in here</a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
    <script>
    (function () {
      function initToggles() {
        document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
          if (btn.dataset.bound === '1') return;
          btn.dataset.bound = '1';
          btn.addEventListener('click', function () {
            var id = btn.getAttribute('data-toggle-password');
            var input = document.getElementById(id);
            if (!input) return;
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            var icon = btn.querySelector('i');
            if (icon) {
              icon.classList.toggle('bi-eye', !show);
              icon.classList.toggle('bi-eye-slash', show);
            }
          });
        });
      }
      initToggles();

      var form = document.getElementById('adminRegisterForm');
      if (form) {
        form.addEventListener('submit', function (e) {
          var pwd = document.getElementById('password');
          var confirm = document.getElementById('confirmPassword');
          var err = document.getElementById('confirmPasswordError');
          var pwdVal = pwd ? pwd.value : '';
          var ok = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$/.test(pwdVal);
          if (!ok) {
            e.preventDefault();
            alert('Password must be at least 8 characters and include uppercase, lowercase, a number, and a special character.');
            return;
          }
          if (confirm && pwd && confirm.value !== pwd.value) {
            e.preventDefault();
            if (err) err.style.display = 'block';
            confirm.focus();
          } else if (err) {
            err.style.display = 'none';
          }
        });
      }
    })();
    </script>
</body>
</html>
