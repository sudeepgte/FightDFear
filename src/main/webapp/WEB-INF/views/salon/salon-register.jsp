<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Registration - Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
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
            --warning: #C2410C;
            --warning-bg: #FFF7ED;
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

        /* Top Bar */
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

        .header-brand i {
            color: var(--primary);
            font-size: 1.3rem;
        }

        .header-links a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            transition: color 0.2s;
        }

        .header-links a:hover {
            color: var(--primary);
        }

        /* Main Container */
        .main-container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 28px auto 40px;
            padding: 0 16px;
        }

        /* Info Card */
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
            margin-bottom: 8px;
        }

        .info-banner .subtext {
            font-size: 0.8rem;
            color: rgba(30, 27, 75, 0.75);
            margin-bottom: 0;
        }

        /* Form Card */
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
            transition: all 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .password-field .form-input {
            padding-right: 42px;
        }

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

        .password-toggle-btn:hover {
            color: var(--navy);
        }

        .pass-strength {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 6px;
        }

        .strength-bars {
            display: flex;
            gap: 4px;
            flex: 1;
            height: 4px;
        }

        .strength-bar {
            flex: 1;
            background: #E2E8F0;
            border-radius: 2px;
        }

        .strength-text {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-gray);
        }

        .terms-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 16px 0 20px;
            font-size: 0.85rem;
            color: var(--navy);
            cursor: pointer;
        }

        .terms-row input[type="checkbox"] {
            margin-top: 2px;
            width: 16px;
            height: 16px;
            accent-color: var(--primary);
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
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover:not(:disabled) {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-submit:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
        }

        .login-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .login-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
        }

        .login-footer a:hover {
            text-decoration: underline;
        }

        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-error {
            background: var(--error-bg);
            border: 1px solid #FECACA;
            color: var(--error);
        }

        .alert-success {
            background: var(--success-bg);
            border: 1px solid #BBF7D0;
            color: var(--success);
        }
    </style>
</head>
<body>

    <!-- App Header -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/32'"> Fight D Fear
        </a>
        <div class="header-links">
            <a href="${pageContext.request.contextPath}/salons/login">Sign in</a>
        </div>
    </header>

    <!-- Main Container -->
    <main class="main-container">

        <!-- Info Card -->
        <div class="info-banner">
            <h2>Salon Partner Registration</h2>
            <p>Join our beauty and wellness ecosystem.</p>
            <p class="subtext">Empowering Women's Safety Through Technology. Your safety is our mission.</p>
        </div>

        <!-- Form Card -->
        <div class="form-card">
            <div id="jsAlert" style="display: none;"></div>

            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <i class="bi bi-exclamation-circle-fill"></i> ${error}
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                </div>
            </c:if>

            <form id="regForm" action="${pageContext.request.contextPath}/salons/register" method="post">
                
                <div class="form-group">
                    <label for="salonName">Salon Name *</label>
                    <input type="text" id="salonName" name="name" class="form-input" placeholder="e.g. Radiance Wellness Hub" required>
                </div>

                <div class="form-group">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="e.g. radiance_hub" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" class="form-input" placeholder="e.g. 9876543210" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" class="form-input" placeholder="e.g. contact@radiance.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="password" name="password" class="form-input" placeholder="Min 6 chars with number & special char" required oninput="evaluatePasswordStrength(this.value)">
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('password', this)" aria-label="Toggle password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="pass-strength">
                        <div class="strength-bars">
                            <div class="strength-bar" id="str1"></div>
                            <div class="strength-bar" id="str2"></div>
                            <div class="strength-bar" id="str3"></div>
                            <div class="strength-bar" id="str4"></div>
                        </div>
                        <span class="strength-text" id="strLabel">Weak</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <div class="input-wrapper password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Re-enter password" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePassVisibility('confirmPassword', this)" aria-label="Toggle confirm password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <label class="terms-row">
                    <input type="checkbox" id="termsCheck" required>
                    <span>I accept the <strong>Terms & Privacy Policy</strong></span>
                </label>

                <button type="button" class="btn-submit" onclick="submitRegistration()">
                    Register Salon Partner <i class="bi bi-arrow-right"></i>
                </button>
            </form>

            <div class="login-footer">
                Already a partner? <a href="${pageContext.request.contextPath}/salons/login">Log In Now</a>
            </div>
        </div>
    </main>

    <!-- Script Logic -->
    <script>
        function showAlert(msg, isError = true) {
            const el = document.getElementById('jsAlert');
            el.className = 'alert-box ' + (isError ? 'alert-error' : 'alert-success');
            el.innerHTML = '<i class="bi ' + (isError ? 'bi-exclamation-circle-fill' : 'bi-check-circle-fill') + '"></i> ' + msg;
            el.style.display = 'flex';
            window.scrollTo({ top: el.offsetTop - 80, behavior: 'smooth' });
        }

        function togglePassVisibility(id, btn) {
            const input = document.getElementById(id);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        function evaluatePasswordStrength(p) {
            let score = 0;
            if (p.length >= 6) score++;
            if (p.length >= 10) score++;
            if (/[0-9]/.test(p)) score++;
            if (/[!@#$%^&*(),.?":{}|<>]/.test(p)) score++;

            const colors = ['#E2E8F0', '#EF4444', '#F97316', '#84CC16', '#22C55E'];
            const labels = ['Weak', 'Weak', 'Fair', 'Good', 'Strong'];

            for (let i = 1; i <= 4; i++) {
                const bar = document.getElementById('str' + i);
                bar.style.backgroundColor = (i <= score) ? colors[score] : '#E2E8F0';
            }
            document.getElementById('strLabel').textContent = labels[score];
        }

        function submitRegistration() {
            const termsCheck = document.getElementById('termsCheck');
            if (!termsCheck.checked) {
                showAlert('You must accept the terms and privacy policy.');
                return;
            }

            const p = document.getElementById('password').value;
            const cp = document.getElementById('confirmPassword').value;
            if (p !== cp) {
                showAlert('Passwords do not match.');
                return;
            }

            document.getElementById('regForm').submit();
        }
    </script>
</body>
</html>