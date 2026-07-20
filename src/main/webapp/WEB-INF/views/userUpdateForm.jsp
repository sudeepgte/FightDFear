<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile | Fight D Fear</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --mulberry:      #1e1b4b;
            --mulberry-light:#312e81;
            --hot-rose:      #f43f5e;
            --hot-rose-dark: #1e1b4b;
            --teal:          #20c997;
            --gold:          #ffd700;
            --dark-bg:       #0d0d1a;
            --card-bg:       rgba(255,255,255,0.04);
            --glass-border:  rgba(219,39,119,0.35);
            --gradient:      linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            --glow:          0 0 22px rgba(219,39,119,0.45);
            --shadow-md:     0 20px 50px rgba(0,0,0,0.45);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            background: var(--dark-bg);
            font-family: 'Outfit', sans-serif;
            color: #f0e0ec;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 16px;
            position: relative;
            overflow-x: hidden;
        }

        /* ── animated background blobs ── */
        body::before, body::after {
            content: '';
            position: fixed;
            border-radius: 50%;
            filter: blur(90px);
            opacity: 0.18;
            pointer-events: none;
            animation: blobDrift 12s ease-in-out infinite alternate;
        }
        body::before {
            width: 520px; height: 520px;
            background: var(--mulberry);
            top: -120px; left: -140px;
        }
        body::after {
            width: 440px; height: 440px;
            background: var(--hot-rose);
            bottom: -100px; right: -100px;
            animation-delay: -6s;
        }
        @keyframes blobDrift {
            from { transform: translate(0,0) scale(1); }
            to   { transform: translate(40px,30px) scale(1.08); }
        }

        /* ── page wrapper ── */
        .page-wrapper {
            width: 100%;
            max-width: 560px;
            position: relative;
            z-index: 10;
        }

        /* ── brand header ── */
        .brand-header {
            text-align: center;
            margin-bottom: 10px;
        }
        .brand-logo {
            font-size: 2rem;
            font-weight: 800;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.5px;
        }
        .brand-sub {
            font-size: 0.85rem;
            color: rgba(240,224,236,0.55);
            margin-top: 2px;
        }

        /* ── glass card ── */
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border-radius: 24px;
            border: 1.5px solid var(--glass-border);
            box-shadow: var(--shadow-md), var(--glow);
            padding: 40px 36px 36px;
            animation: fadeUp 0.55s cubic-bezier(0.22,1,0.36,1) both;
            position: relative;
            overflow: hidden;
        }
        /* top accent line */
        .glass-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: var(--gradient);
            border-radius: 24px 24px 0 0;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(28px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── card title ── */
        .card-title {
            font-size: 1.65rem;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 28px;
        }

        /* ── form labels ── */
        .form-label {
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.6px;
            text-transform: uppercase;
            color: rgba(240,224,236,0.7);
            margin-bottom: 6px;
            display: block;
        }

        /* ── inputs & selects ── */
        .form-control,
        .form-select {
            background: rgba(255,255,255,0.06) !important;
            border: 1.5px solid rgba(219,39,119,0.28) !important;
            border-radius: 12px !important;
            color: #f0e0ec !important;
            padding: 11px 14px !important;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
        }
        .form-control::placeholder { color: rgba(240,224,236,0.35); }
        .form-control:focus,
        .form-select:focus {
            border-color: var(--hot-rose) !important;
            box-shadow: 0 0 0 3px rgba(219,39,119,0.2) !important;
            background: rgba(255,255,255,0.09) !important;
            outline: none;
        }
        select.form-control option { background: #1a0d1a; color: #f0e0ec; }

        /* file input */
        input[type="file"].form-control {
            padding: 8px 14px !important;
        }
        input[type="file"]::file-selector-button {
            background: var(--gradient);
            border: none;
            border-radius: 8px;
            color: #fff;
            padding: 5px 14px;
            font-family: 'Outfit', sans-serif;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
            transition: opacity 0.2s;
        }
        input[type="file"]::file-selector-button:hover { opacity: 0.85; }

        /* ── divider ── */
        .section-divider {
            border: none;
            border-top: 1px solid rgba(219,39,119,0.2);
            margin: 20px 0;
        }

        /* ── privacy toggle ── */
        .form-check { display: flex; align-items: center; gap: 10px; }
        .form-check-input {
            width: 18px; height: 18px;
            border-radius: 5px !important;
            border: 2px solid rgba(219,39,119,0.4) !important;
            background: rgba(255,255,255,0.06) !important;
            cursor: pointer;
            accent-color: var(--hot-rose);
        }
        .form-check-input:checked {
            background-color: var(--hot-rose) !important;
            border-color: var(--hot-rose) !important;
        }
        .form-check-label {
            font-size: 0.88rem;
            color: rgba(240,224,236,0.65);
            cursor: pointer;
        }

        /* ── buttons ── */
        .btn-brand {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 14px;
            background: var(--gradient);
            color: #fff;
            font-family: 'Outfit', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 0.3px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 6px 24px rgba(219,39,119,0.4);
            text-decoration: none;
            display: block;
            text-align: center;
        }
        .btn-brand:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 32px rgba(219,39,119,0.55);
            color: #fff;
        }
        .btn-brand:active { transform: translateY(0); }

        /* ripple */
        .btn-brand::after {
            content: '';
            position: absolute;
            top: 50%; left: 50%;
            width: 0; height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            transform: translate(-50%,-50%);
            transition: width 0.5s, height 0.5s, opacity 0.5s;
            opacity: 0;
        }
        .btn-brand:active::after {
            width: 300px; height: 300px; opacity: 0;
        }

        .btn-ghost {
            width: 100%;
            padding: 12px;
            border: 1.5px solid rgba(219,39,119,0.4);
            border-radius: 14px;
            background: transparent;
            color: rgba(240,224,236,0.75);
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.25s;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-top: 10px;
        }
        .btn-ghost:hover {
            border-color: var(--hot-rose);
            color: var(--hot-rose);
            background: rgba(219,39,119,0.08);
        }

        /* ── field group spacing ── */
        .field-group { margin-bottom: 18px; }

        /* ── responsive ── */
        @media (max-width: 500px) {
            .glass-card { padding: 28px 20px 24px; }
            .card-title  { font-size: 1.35rem; }
        }
    </style>
</head>
<body>

<div class="page-wrapper">
    <div class="brand-header mb-4">
        <div class="brand-logo">Fight D Fear</div>
        <div class="brand-sub">Women Safety &amp; Empowerment Platform</div>
    </div>

    <div class="glass-card">
        <h2 class="card-title">Update Profile</h2>

        <form action="${pageContext.request.contextPath}/users/update/${user.id}" method="post" enctype="multipart/form-data">

            <!-- Name -->
            <div class="field-group">
                <label class="form-label">Full Name</label>
                <input type="text" name="name" id="name" class="form-control"
                       value="${user.fullName}" placeholder="Enter your full name" required>
            </div>

            <!-- Email -->
            <div class="field-group">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" id="email" class="form-control"
                       value="${user.email}" placeholder="Enter your email" required>
            </div>

            <!-- Phone -->
            <div class="field-group">
                <label class="form-label">Phone Number</label>
                <input type="tel" name="phone" id="phone" class="form-control"
                       value="${user.phoneNumber}" placeholder="10-digit phone number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
            </div>

            <!-- Age & Gender row -->
            <div class="row g-3 mb-0">
                <div class="col-6">
                    <div class="field-group">
                        <label class="form-label" for="age">Age</label>
                        <input type="number" id="age" name="age" class="form-control"
                               value="${user.age}" placeholder="Age" min="1" max="120" required>
                    </div>
                </div>
                <div class="col-6">
                    <div class="field-group">
                        <label class="form-label" for="gender">Gender</label>
                        <select name="gender" id="gender" class="form-control" required>
                            <option value="MALE"   ${user.gender eq 'MALE'   ? 'selected' : ''}>Male</option>
                            <option value="FEMALE" ${user.gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                            <option value="OTHER"  ${user.gender eq 'OTHER'  ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Address -->
            <div class="field-group">
                <label class="form-label">Home Address</label>
                <input type="text" name="address" id="address" class="form-control"
                       value="${user.homeAddress}" placeholder="Enter your address" required>
            </div>

            <hr class="section-divider">

            <!-- Identity Doc -->
            <div class="field-group">
                <label class="form-label">Identity Document</label>
                <input type="file" name="identityFile" id="identityFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
            </div>

            <!-- Profile Photo -->
            <div class="field-group">
                <label class="form-label">Profile Photo</label>
                <input type="file" name="image" id="image" class="form-control" accept="image/*">
            </div>

            <hr class="section-divider">

            <!-- Privacy Toggle -->
            <div class="field-group form-check">
                <input type="checkbox" name="isPrivate" class="form-check-input" id="isPrivate"
                       ${user['private'] ? 'checked' : ''}>
                <label class="form-check-label" for="isPrivate">
                    Private Account &mdash; only followers can see my reels
                </label>
            </div>

            <!-- Submit -->
            <button type="submit" id="btn-update" class="btn-brand mt-3">Save Changes</button>
        </form>

        <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="btn-ghost" id="btn-cancel">Cancel</a>
    </div>
</div>

</body>
</html>

