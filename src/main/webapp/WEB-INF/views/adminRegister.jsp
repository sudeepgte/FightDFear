<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration — Fight D Fear</title>
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
        .info-banner h2 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .info-banner p {
            font-size: 0.9rem;
            color: var(--navy);
            line-height: 1.45;
            margin: 0;
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .form-input, .form-select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            background: #fff;
            color: var(--navy);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .password-field {
            position: relative;
        }
        .password-field .form-input {
            padding-right: 48px;
        }
        .password-toggle-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: transparent;
            color: var(--text-gray);
            cursor: pointer;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            padding: 0;
        }
        .password-toggle-btn:hover,
        .password-toggle-btn:focus {
            color: var(--primary);
            outline: none;
            background: var(--rose-soft);
        }
        .password-toggle-btn i { font-size: 1.1rem; pointer-events: none; }
        .hint { font-size: 0.75rem; color: var(--text-gray); margin-top: 5px; }
        .row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            margin-top: 8px;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-primary:disabled { background: #cbd5e1; cursor: not-allowed; transform: none; }
        .alert {
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.9rem;
            margin-bottom: 16px;
        }
        .alert-error { background: var(--error-bg); color: var(--error); border: 1px solid #FECACA; }
        .alert-ok { background: var(--success-bg); color: var(--success); border: 1px solid #BBF7D0; }
        .footer-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }
        .footer-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
        @media (max-width: 600px) {
            .row-2 { grid-template-columns: 1fr; }
            .form-card { padding: 22px 16px; }
        }
    </style>
</head>
<body>
    <header class="app-header">
        <a class="header-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-heart-fill"></i> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/admin/loginAdmin">Sign in</a>
        </div>
    </header>

    <div class="main-container">
        <div class="info-banner">
            <h2>Create an Admin account</h2>
            <p>Register an administrator account to manage users, providers, SOS alerts, and platform settings.</p>
        </div>

        <div class="form-card">
            <c:if test="${not empty error}">
                <div class="alert alert-error" id="serverError"><i class="bi bi-exclamation-circle me-1"></i> ${error}</div>
            </c:if>
            <div class="alert alert-error" id="formError" style="display:none;"></div>

            <form action="${pageContext.request.contextPath}/admin/registerAdmin" method="post" id="adminRegisterForm">
                <div class="form-group">
                    <label>Admin Username *</label>
                    <input type="text" name="name" id="name" class="form-input" required 
                           minlength="3" maxlength="20" placeholder="Enter admin username"
                           oninput="this.value=this.value.slice(0,20).replace(/[^a-zA-Z0-9._\-\s]/g,'')">
                    <div class="hint">3-20 characters maximum.</div>
                </div>

                <div class="form-group">
                    <label>Admin Email *</label>
                    <input type="email" name="email" id="email" class="form-input" required 
                           placeholder="admin@example.com" pattern="[a-zA-Z0-9._+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}">
                </div>

                <div class="row-2">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <div class="password-field">
                            <input type="password" name="password" id="password" class="form-input" required autocomplete="new-password"
                                   pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}">
                            <button type="button" class="password-toggle-btn" data-toggle-password="password"
                                    aria-label="Show password" title="Show password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div class="hint"><strong>At least 8 characters</strong> with uppercase, lowercase, a number, and a special character.</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password *</label>
                        <div class="password-field">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" required autocomplete="new-password">
                            <button type="button" class="password-toggle-btn" data-toggle-password="confirmPassword"
                                    aria-label="Show confirm password" title="Show confirm password" aria-pressed="false">
                                <i class="bi bi-eye" aria-hidden="true"></i>
                            </button>
                        </div>
                        <div id="confirmPasswordError" style="display:none;color:#b91c1c;font-size:0.8rem;margin-top:6px;">Passwords do not match.</div>
                    </div>
                </div>

                <button type="submit" class="btn-primary" id="btnSubmit">Create Admin Account</button>
            </form>

            <p class="footer-link">Already have an account? <a href="${pageContext.request.contextPath}/admin/loginAdmin">Sign in</a></p>
        </div>
    </div>

<script>
(function () {
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

    document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var id = btn.getAttribute('data-toggle-password');
            var input = document.getElementById(id);
            if (!input) return;
            var show = input.type === 'password';
            input.type = show ? 'text' : 'password';
            btn.setAttribute('aria-pressed', show ? 'true' : 'false');
            btn.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
            btn.setAttribute('title', show ? 'Hide password' : 'Show password');
            var icon = btn.querySelector('i');
            if (icon) icon.className = show ? 'bi bi-eye-slash' : 'bi bi-eye';
        });
    });
})();
</script>
</body>
</html>
