<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Fight D Fear</title>
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
            <h1>Admin Portal</h1>
            <p>Secure access to verification queues, SOS monitoring, content moderation, and platform operations.</p>
            <ul>
                <li><span><i class="bi bi-gear-fill"></i></span> Centralized ecosystem control</li>
                <li><span><i class="bi bi-shield-check"></i></span> Verified provider management</li>
                <li><span><i class="bi bi-activity"></i></span> Real-time SOS monitoring</li>
                <li><span><i class="bi bi-database-fill-check"></i></span> Secure data administration</li>
            </ul>
        </div>

        <div class="ap-auth-form">
            <div class="ap-auth-card">
                <a class="back" href="${pageContext.request.contextPath}/index.html"><i class="bi bi-arrow-left"></i> Return Home</a>
                <h2>Welcome back</h2>
                <p class="sub">Sign in to the Fight D Fear Admin Portal</p>

                <c:if test="${not empty error}">
                    <div class="alert-err"><i class="bi bi-exclamation-octagon-fill"></i> ${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert-ok"><i class="bi bi-check-circle-fill"></i> ${success}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/loginAdmin" method="post">
                    <div class="field">
                        <label for="email">Admin Email</label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-person-badge"></i>
                            <input type="email" id="email" name="email" class="ap-input" placeholder="admin@example.com" required>
                        </div>
                    </div>
                    <div class="field">
                        <label for="adminPassword">Password</label>
                        <div class="ap-input-wrap">
                            <i class="bi bi-lock"></i>
                            <input type="password" name="password" id="adminPassword" class="ap-input" placeholder="••••••••" required style="padding-right:44px;">
                            <button type="button" class="pw-btn" data-toggle-password="adminPassword" aria-label="Show password">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>
                    <button type="submit" class="ap-auth-submit">
                        Sign In <i class="bi bi-arrow-right"></i>
                    </button>
                </form>

                <p class="foot">
                    Need an admin account?
                    <a href="${pageContext.request.contextPath}/admin/registerAdmin">Register here</a>
                </p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
    <script>
    document.addEventListener("DOMContentLoaded", function() {
      document.querySelectorAll('[data-toggle-password]').forEach(function (btn) {
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
    });
    </script>
</body>
</html>
