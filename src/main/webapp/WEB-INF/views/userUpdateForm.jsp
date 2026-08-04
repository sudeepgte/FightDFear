<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Update Profile | Fight D Fear</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--light-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        .update-page {
            max-width: 720px;
            margin: 0 auto;
            padding: 16px 12px 40px;
        }

        .update-back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #fff;
            color: var(--brand-purple) !important;
            border: 2px solid var(--brand-purple);
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s ease;
            margin-bottom: 20px;
        }
        .update-back-btn:hover {
            background: rgba(30, 27, 75, 0.06);
            border-color: var(--brand-pink);
            color: var(--brand-purple) !important;
        }

        .update-card {
            background: #fff;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
            padding: 28px 24px;
        }

        .update-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.75rem;
            font-weight: 800;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 6px;
        }

        .update-subtitle {
            color: var(--fdf-muted);
            font-size: 0.92rem;
            margin-bottom: 24px;
        }

        .form-label {
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.4px;
            text-transform: uppercase;
            color: var(--brand-purple);
            margin-bottom: 6px;
        }

        .form-control,
        .form-select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 11px 14px;
            font-size: 0.95rem;
            color: var(--fdf-text);
            background: #fff;
        }
        .form-control:focus,
        .form-select:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-control[readonly] {
            background: #f8f9fc;
            color: var(--fdf-muted);
        }

        input[type="file"].form-control {
            padding: 8px 12px;
        }
        input[type="file"]::file-selector-button {
            background: var(--gradient-primary);
            border: none;
            border-radius: 8px;
            color: #fff;
            padding: 6px 14px;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
        }

        .section-divider {
            border: none;
            border-top: 1px dashed var(--fdf-border);
            margin: 22px 0;
        }

        .form-check {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px 14px;
            background: #faf7fb;
            border-radius: 12px;
            border: 1px solid var(--fdf-border);
        }
        .form-check-input {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            flex-shrink: 0;
            accent-color: var(--brand-pink);
        }
        .form-check-label {
            font-size: 0.9rem;
            color: var(--fdf-text);
            line-height: 1.45;
        }

        .btn-save {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 14px;
            background: var(--gradient-primary);
            color: #fff;
            font-weight: 700;
            font-size: 1rem;
            box-shadow: 0 6px 20px rgba(244, 63, 94, 0.25);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(244, 63, 94, 0.35);
            color: #fff;
        }

        .btn-cancel {
            display: block;
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: 2px solid var(--fdf-border);
            border-radius: 14px;
            background: #fff;
            color: var(--brand-purple);
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-cancel:hover {
            border-color: var(--brand-purple);
            background: rgba(30, 27, 75, 0.04);
            color: var(--brand-purple);
        }

        .field-group {
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {
            #wrapper {
                flex-direction: column !important;
                margin-top: 68px !important;
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 12px 10px !important;
                width: 100% !important;
            }
            .update-page {
                padding: 8px 4px 32px;
            }
            .update-card {
                padding: 22px 16px;
                border-radius: 16px;
            }
            .update-title {
                font-size: 1.4rem;
            }
            .update-back-btn {
                width: 100%;
                justify-content: center;
                margin-bottom: 16px;
            }
        }

        @media (max-width: 430px) {
            .update-title {
                font-size: 1.25rem;
            }
            .form-control,
            .form-select {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper" data-skip-global-back="true" style="min-height: 100vh; overflow-x: hidden;">
        <div class="update-page">
            <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="update-back-btn">
                <i class="bi bi-arrow-left"></i>
                Back to Profile
            </a>

            <div class="update-card">
                <h1 class="update-title">Update Profile</h1>
                <p class="update-subtitle">Keep your account details up to date for a safer experience.</p>

                <form action="${pageContext.request.contextPath}/users/update/${user.id}" method="post" enctype="multipart/form-data">
                    <div class="field-group">
                        <label class="form-label" for="name">Full Name</label>
                        <input type="text" name="name" id="name" class="form-control"
                               value="${user.fullName}" placeholder="Enter your full name" required>
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input type="email" name="email" id="email" class="form-control"
                               value="${user.email}" placeholder="Enter your email" required>
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" name="phone" id="phone" class="form-control"
                               value="${user.phoneNumber}" placeholder="10-digit phone number"
                               pattern="[0-9]{10}" maxlength="10" minlength="10"
                               oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                    </div>

                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <div class="field-group mb-0">
                                <label class="form-label" for="dob">Date of Birth</label>
                                <input type="date" id="dob" name="dob" class="form-control"
                                       value="${user.dob}" required>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="field-group mb-0">
                                <label class="form-label" for="ageDisplay">Age</label>
                                <input type="number" id="ageDisplay" class="form-control"
                                       value="${user.age}" placeholder="Auto from DOB"
                                       min="18" max="100" readonly tabindex="-1">
                            </div>
                        </div>
                    </div>

                    <div class="field-group mt-3">
                        <label class="form-label" for="gender">Gender</label>
                        <select name="gender" id="gender" class="form-select" required>
                            <option value="MALE"   ${user.gender eq 'MALE'   ? 'selected' : ''}>Male</option>
                            <option value="FEMALE" ${user.gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                            <option value="OTHER"  ${user.gender eq 'OTHER'  ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="address">Home Address</label>
                        <input type="text" name="address" id="address" class="form-control"
                               value="${user.homeAddress}" placeholder="Enter your address" required>
                    </div>

                    <hr class="section-divider">

                    <div class="field-group">
                        <label class="form-label" for="identityFile">Identity Document</label>
                        <input type="file" name="identityFile" id="identityFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                    </div>

                    <div class="field-group">
                        <label class="form-label" for="image">Profile Photo</label>
                        <input type="file" name="image" id="image" class="form-control" accept="image/*">
                    </div>

                    <hr class="section-divider">

                    <div class="field-group mb-0">
                        <div class="form-check">
                            <input type="checkbox" name="isPrivate" class="form-check-input" id="isPrivate"
                                   ${user['private'] ? 'checked' : ''}>
                            <label class="form-check-label" for="isPrivate">
                                Private Account — only followers can see my reels
                            </label>
                        </div>
                    </div>

                    <button type="submit" id="btn-update" class="btn-save mt-4">Save Changes</button>
                </form>

                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="btn-cancel" id="btn-cancel">Cancel</a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var dob = document.getElementById('dob');
    var ageDisplay = document.getElementById('ageDisplay');
    if (!dob || !ageDisplay) return;

    var today = new Date();
    var maxDob = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
    var minDob = new Date(today.getFullYear() - 100, today.getMonth(), today.getDate());
    var fmt = function(d) { return d.toISOString().split('T')[0]; };
    dob.setAttribute('max', fmt(maxDob));
    dob.setAttribute('min', fmt(minDob));

    function syncAge() {
        if (!dob.value) return;
        var birthDate = new Date(dob.value + 'T00:00:00');
        var now = new Date();
        var computedAge = now.getFullYear() - birthDate.getFullYear();
        var m = now.getMonth() - birthDate.getMonth();
        if (m < 0 || (m === 0 && now.getDate() < birthDate.getDate())) computedAge--;
        ageDisplay.value = computedAge;
    }

    dob.addEventListener('change', syncAge);
    syncAge();
});
</script>

</body>
</html>
