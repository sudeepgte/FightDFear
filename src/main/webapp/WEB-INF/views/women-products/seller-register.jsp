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
        .file-input { padding: 10px; }
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

        <div class="form-card">
            <c:if test="${not empty success}">
                <div class="alert-box alert-success">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>
                        ${success}
                        <div style="margin-top:8px;"><a href="${pageContext.request.contextPath}/women-products/seller/login" style="color:#16A34A; font-weight:800;">Go to Seller Login</a></div>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert-box alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/women-products/seller/register" enctype="multipart/form-data" id="sellerForm" novalidate>
                <div class="row-2">
                    <div class="form-group">
                        <label for="fullName">Owner / contact name *</label>
                        <input class="form-input" type="text" name="fullName" id="fullName" maxlength="80" required
                               pattern="[A-Za-z][A-Za-z .'-]{1,79}" placeholder="Your full name">
                    </div>
                    <div class="form-group">
                        <label for="businessName">Shop / business name *</label>
                        <input class="form-input" type="text" name="businessName" id="businessName" maxlength="100" required placeholder="Shop name">
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
                               placeholder="10-digit mobile" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
                    </div>
                </div>
                <div class="row-2">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <div class="input-wrapper password-field">
                            <input class="form-input" type="password" name="password" id="password" required placeholder="Create a password">
                            <button type="button" class="password-toggle-btn" data-target="password" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                        </div>
                        <div class="hint">At least 6 characters, with a number and a special character.</div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm password *</label>
                        <div class="input-wrapper password-field">
                            <input class="form-input" type="password" name="confirmPassword" id="confirmPassword" required placeholder="Re-enter password">
                            <button type="button" class="password-toggle-btn" data-target="confirmPassword" aria-label="Show password"><i class="bi bi-eye-slash"></i></button>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="address">Address *</label>
                    <input class="form-input" type="text" name="address" id="address" required minlength="10" maxlength="1000" placeholder="Shop / warehouse address">
                </div>
                <div class="form-group">
                    <label for="city">City</label>
                    <input class="form-input" type="text" name="city" id="city" maxlength="80" placeholder="City (optional)">
                </div>
                <div class="row-2">
                    <div class="form-group">
                        <label for="profilePhoto">Profile photo *</label>
                        <input class="form-input file-input" type="file" name="profilePhoto" id="profilePhoto" accept="image/*" required>
                    </div>
                    <div class="form-group">
                        <label for="identityDoc">ID / document *</label>
                        <input class="form-input file-input" type="file" name="identityDoc" id="identityDoc" accept="image/*,.pdf" required>
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
        document.getElementById('sellerForm').addEventListener('submit', function (e) {
            var phone = document.getElementById('phone').value.trim();
            var pass = document.getElementById('password').value;
            var confirm = document.getElementById('confirmPassword').value;
            if (!/^[6-9]\d{9}$/.test(phone)) {
                e.preventDefault();
                alert('Enter a valid 10-digit Indian mobile number.');
                return;
            }
            if (pass !== confirm) {
                e.preventDefault();
                alert('Passwords do not match.');
            }
        });
    </script>
</body>
</html>
