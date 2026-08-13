<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        :root {
            --brand-purple: #1e1b4b;
            --brand-purple-dark: #1e1b4b;
            --brand-purple-darker: #3F1430;
            --brand-pink: #f43f5e;
            --fdf-border: #f1f3f5;
            --fdf-text: #1e293b;
            --fdf-muted: #64748b;
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --error-red: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            background: #fffcfd;
            color: var(--fdf-text);
        }

        .auth-container {
            flex: 1;
            display: flex;
            width: 100%;
        }

        .visual-panel {
            flex: 1;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 80px;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .visual-panel::before {
            content: '';
            position: absolute;
            top: -120px;
            right: -120px;
            width: 320px;
            height: 320px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
        }

        .visual-panel::after {
            content: '';
            position: absolute;
            bottom: -160px;
            left: -80px;
            width: 420px;
            height: 420px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.04);
        }

        .visual-panel .content { position: relative; z-index: 2; }
        .brand-logo {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .brand-logo i { font-size: 2.22rem; opacity: 0.9; }
        .brand-tagline {
            font-size: 1.15rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 380px;
            line-height: 1.7;
            margin-bottom: 40px;
        }

        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 15px; font-weight: 400; font-size: 0.95rem; }
        .feat-icon {
            width: 40px; height: 40px; background: rgba(255,255,255,0.15);
            display: flex; align-items: center; justify-content: center;
            border-radius: 12px; font-size: 1.1rem; flex-shrink: 0;
        }

        .form-panel {
            flex: 1.2;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 60px;
            background: #fff;
        }
        .register-card { width: 100%; max-width: 480px; }
        .register-card h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 2.2rem;
            font-weight: 900;
            color: var(--brand-purple-darker);
            margin-bottom: 12px;
            border-left: 6px solid var(--brand-pink);
            padding-left: 20px;
            line-height: 1.1;
        }
        .register-card .subtitle {
            color: var(--fdf-muted);
            font-size: 1rem;
            margin-bottom: 32px;
            padding-left: 26px;
        }

        .fdf-form-group { margin-bottom: 22px; }
        .fdf-form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 800;
            color: var(--brand-purple-dark);
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .required-star { color: var(--error-red); }

        .input-wrapper { position: relative; }
        .input-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--brand-purple);
            opacity: 0.5;
            font-size: 1.1rem;
        }
        .fdf-input {
            width: 100%;
            padding: 15px 15px 15px 50px;
            border: 2px solid var(--fdf-border);
            border-radius: 16px;
            background: #f8fafc;
            outline: none;
            transition: 0.3s;
            font-family: inherit;
            font-weight: 500;
            font-size: 0.95rem;
        }
        .fdf-input:focus {
            border-color: var(--brand-pink);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05);
        }

        .password-input-wrap { position: relative; }
        .password-input-wrap .fdf-input { padding-right: 48px; }
        .password-toggle-btn {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: #64748b;
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }

        .field-hint {
            font-size: 0.72rem;
            color: var(--fdf-muted);
            margin-top: 8px;
            line-height: 1.5;
            padding-left: 4px;
        }

        .btn-fdf-register {
            width: 100%;
            padding: 18px;
            background: var(--gradient-primary);
            color: #fff;
            border: none;
            border-radius: 18px;
            font-size: 1.1rem;
            font-weight: 800;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            box-shadow: 0 10px 25px rgba(124, 45, 94, 0.25);
            margin-top: 10px;
        }
        .btn-fdf-register:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
            box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
        }

        .footer-links {
            text-align: center;
            margin-top: 28px;
            font-size: 0.95rem;
            color: var(--fdf-muted);
            border-top: 1px solid #f3f4f6;
            padding-top: 22px;
        }
        .footer-links a {
            color: var(--brand-pink);
            text-decoration: none;
            font-weight: 800;
        }

        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: var(--fdf-muted);
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 600;
            margin-bottom: 25px;
            transition: 0.3s;
        }
        .back-home:hover { color: var(--brand-purple); }

        .alert {
            background: #fef2f2;
            color: #b91c1c;
            padding: 15px 20px;
            border-radius: 14px;
            font-size: 0.9rem;
            margin-bottom: 22px;
            font-weight: 600;
            border: 1px solid #fee2e2;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        @media (max-width: 992px) {
            body { flex-direction: column; }
            .visual-panel {
                min-height: 30vh;
                padding: 50px 30px;
                text-align: center;
            }
            .feature-list { display: none; }
            .brand-tagline { margin: 0 auto; font-size: 1rem; }
            .form-panel {
                padding: 40px 20px;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
            }
            .register-card h2 { font-size: 1.8rem; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .register-card h2 { font-size: 1.5rem; padding-left: 15px; }
            .fdf-input { padding: 12px 15px 12px 45px; border-radius: 12px; }
            .btn-fdf-register { padding: 16px; border-radius: 14px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <!-- Left visual panel -->
        <div class="visual-panel">
            <div class="content">
                <div class="brand-logo"><i class="bi bi-shield-lock-fill"></i> Fight D Fear</div>
                <p class="brand-tagline">Create an administrator account to manage users, providers, SOS alerts, and platform settings.</p>
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-person-plus-fill"></i></span> Secure Admin Onboarding</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-check"></i></span> Role-Based Access Control</li>
                    <li><span class="feat-icon"><i class="bi bi-gear-fill"></i></span> Full Platform Management</li>
                    <li><span class="feat-icon"><i class="bi bi-database-fill-check"></i></span> Verified Data Administration</li>
                </ul>
            </div>
        </div>

        <!-- Right form panel -->
        <div class="form-panel">
            <div class="register-card">
                <a href="${pageContext.request.contextPath}/index.html" class="back-home">
                    <i class="bi bi-arrow-left"></i> Return Home
                </a>

                <h2>Create Admin 🛡️</h2>
                <p class="subtitle">Register a new administrator account</p>

                <c:if test="${not empty error}">
                    <div class="alert"><i class="bi bi-exclamation-octagon-fill"></i> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/registerAdmin" method="post" id="adminRegisterForm">
                    <div class="fdf-form-group">
                        <label for="name">Admin Username <span class="required-star">*</span></label>
                        <div class="input-wrapper">
                            <i class="bi bi-person"></i>
                            <input type="text" id="name" name="name" class="fdf-input"
                                   placeholder="Enter admin username" minlength="3" maxlength="20" required
                                   oninput="this.value=this.value.slice(0,20).replace(/[^a-zA-Z0-9._\-\s]/g,'')">
                        </div>
                        <div class="field-hint">3–20 characters maximum.</div>
                    </div>

                    <div class="fdf-form-group">
                        <label for="email">Admin Email <span class="required-star">*</span></label>
                        <div class="input-wrapper">
                            <i class="bi bi-envelope"></i>
                            <input type="email" id="email" name="email" class="fdf-input"
                                   placeholder="admin@example.com"
                                   pattern="[a-zA-Z0-9._+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}" required>
                        </div>
                    </div>

                    <div class="fdf-form-group">
                        <label for="password">Password <span class="required-star">*</span></label>
                        <div class="input-wrapper password-input-wrap">
                            <i class="bi bi-lock"></i>
                            <input type="password" id="password" name="password" class="fdf-input"
                                   placeholder="••••••••"
                                   pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&amp;*]).{8,}"
                                   title="At least 8 characters with uppercase, lowercase, number, and special character"
                                   required autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="password" aria-label="Show password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="field-hint"><strong>Password must be at least 8 characters</strong> and include uppercase, lowercase, a number, and a special character.</div>
                    </div>

                    <div class="fdf-form-group">
                        <label for="confirmPassword">Confirm Password <span class="required-star">*</span></label>
                        <div class="input-wrapper password-input-wrap">
                            <i class="bi bi-lock-fill"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="fdf-input"
                                   placeholder="••••••••" required autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="confirmPassword" aria-label="Show confirm password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="error-feedback" id="confirmPasswordError" style="display:none;color:#b91c1c;font-size:0.8rem;margin-top:6px;">Passwords do not match.</div>
                    </div>

                    <button type="submit" class="btn-fdf-register">
                        Create Admin Account <i class="bi bi-arrow-right"></i>
                    </button>
                </form>

                <div class="footer-links">
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
