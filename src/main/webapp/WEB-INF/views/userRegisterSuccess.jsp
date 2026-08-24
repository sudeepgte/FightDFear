<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --border-color: #E2E8F0;
            --rose-soft: #FFE4E6;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
        }
        .card {
            width: 100%;
            max-width: 440px;
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 32px 28px;
            box-shadow: 0 8px 30px rgba(15, 23, 42, 0.06);
            text-align: center;
        }
        .icon-wrap {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--rose-soft);
            color: var(--primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 16px;
        }
        h1 { font-size: 1.45rem; font-weight: 800; margin-bottom: 8px; }
        .sub { color: var(--text-gray); font-size: 0.92rem; margin-bottom: 22px; line-height: 1.5; }
        .preview {
            text-align: left;
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 16px;
            margin-bottom: 22px;
        }
        .preview .label {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: var(--text-gray);
            margin-bottom: 2px;
        }
        .preview .value {
            font-weight: 700;
            margin-bottom: 12px;
            word-break: break-word;
        }
        .preview .value:last-child { margin-bottom: 0; }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            text-decoration: none;
            font-family: inherit;
        }
        .btn:hover { background: var(--primary-hover); color: #fff; }
        .note { margin-top: 14px; font-size: 0.8rem; color: var(--text-gray); }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-wrap"><i class="bi bi-check-lg"></i></div>
        <h1>Registration successful</h1>
        <p class="sub">Your account is ready. Continue to sign in with the email you registered.</p>

        <div class="preview">
            <div class="label">Name</div>
            <div class="value"><c:out value="${regName}"/></div>
            <div class="label">Email</div>
            <div class="value"><c:out value="${regEmail}"/></div>
            <div class="label">Phone</div>
            <div class="value"><c:out value="${regPhone}"/></div>
        </div>

        <a class="btn" href="${pageContext.request.contextPath}/login">
            Continue to Login <i class="bi bi-arrow-right"></i>
        </a>
        <p class="note">Your email (and password for this browser session) will be ready on the login form.</p>
    </div>
</body>
</html>
