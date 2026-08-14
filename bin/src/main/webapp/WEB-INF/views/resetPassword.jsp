<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Reset Password - Fight The Fire</title>

  <link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css" rel="stylesheet">

  <style>
    html, body { overflow-x: hidden; width: 100%; }
    .navmenu a, .navmenu a:focus { color: #3F1430 !important; font-weight: 600; }
    .reset-section {
      padding: 80px 0 100px;
      background: linear-gradient(180deg, #fffcfd 0%, #ffffff 100%);
      min-height: calc(100vh - 200px);
    }
    .reset-card {
      max-width: 440px;
      margin: 0 auto;
      background: #fff;
      border-radius: 18px;
      padding: 2rem;
      box-shadow: 0 18px 40px rgba(124, 45, 94, 0.12);
      border: 1px solid rgba(30, 27, 75, 0.1);
    }
    .reset-card h2 {
      font-weight: 800;
      color: #3F1430;
      margin-bottom: 0.5rem;
      font-size: 1.5rem;
    }
    .reset-card .subtitle { color: #1e1b4b; margin-bottom: 1.5rem; }
    .reset-card .form-control {
      border-radius: 10px;
      border: 1px solid rgba(124, 45, 94, 0.25);
      padding: 12px 14px;
    }
    .reset-card .form-control:focus {
      border-color: #f43f5e;
      box-shadow: 0 0 0 0.2rem rgba(219, 39, 119, 0.15);
    }
    .btn-reset {
      background: linear-gradient(45deg, #1e1b4b, #f43f5e);
      color: #fff !important;
      border: 0;
      border-radius: 999px;
      font-weight: 700;
      padding: 12px 24px;
      width: 100%;
      box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
    }
    .btn-reset:hover { opacity: 0.95; color: #fff; }
    .reset-message { margin-top: 1rem; font-weight: 600; }
    .reset-message.success { color: #198754; }
    .reset-message.error { color: #dc3545; }
    @media (min-width: 992px) {
      #header .container-xl { display: flex !important; align-items: center !important; }
      .navmenu { display: flex !important; align-items: center !important; margin-right: 15px; }
      .navmenu ul { display: flex !important; align-items: center !important; margin: 0 !important; padding: 0 !important; }
    }
    .btn-qna {
      height: 44px;
      display: inline-flex !important;
      align-items: center;
      justify-content: center;
      margin: 0 12px 0 0 !important;
      padding: 0 25px !important;
      font-size: 15px !important;
      color: white;
      background-color: var(--primary-coral, #f43f5e);
      border: none;
      border-radius: 30px;
      text-decoration: none;
      font-weight: bold;
    }
    .role-dropdown { display: flex !important; align-items: center !important; position: relative; }
    .role-dropdown-btn {
      background: linear-gradient(135deg, #1e1b4b, #1e1b4b);
      color: #fff;
      border: none;
      padding: 0 25px;
      height: 44px;
      border-radius: 50px;
      font-weight: 700;
      font-size: 15px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .role-dropdown-menu {
      position: absolute;
      top: calc(100% + 10px);
      right: 0;
      min-width: 280px;
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
      opacity: 0;
      visibility: hidden;
      transform: translateY(10px);
      transition: all 0.3s ease;
      z-index: 1000;
      padding: 10px 0;
      border: 1px solid rgba(142, 68, 173, 0.1);
    }
    .role-dropdown:hover .role-dropdown-menu {
      opacity: 1;
      visibility: visible;
      transform: translateY(0);
    }
    .role-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 12px 20px;
      text-decoration: none;
      color: #333;
    }
    .role-item:hover { background: #f9f0ff; color: #6a0572; }
    .role-divider { height: 1px; background: rgba(142,68,173,0.15); margin: 4px 16px; }
    @media (max-width: 992px) {
      .header .btn-qna, .header .role-dropdown { display: none !important; }
    }
  </style>
</head>
<body class="index-page">

  <header id="header" class="header d-flex align-items-center sticky-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">
      <a href="${pageContext.request.contextPath}/" class="logo d-flex align-items-center me-auto">
        <h1 class="sitename">Fight D Fear</h1>
      </a>
      <nav id="navmenu" class="navmenu">
        <ul>
          <li><a href="${pageContext.request.contextPath}/#hero">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/#about">About</a></li>
          <li><a href="${pageContext.request.contextPath}/#services">Services</a></li>
          <li><a href="${pageContext.request.contextPath}/#contact">Contact</a></li>
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>
      <a class="btn-qna" href="${pageContext.request.contextPath}/qna">Q&amp;A</a>
      <div class="role-dropdown">
        <button class="role-dropdown-btn" type="button">Get Started <i class="bi bi-chevron-down"></i></button>
        <div class="role-dropdown-menu">
          <a href="${pageContext.request.contextPath}/login" class="role-item"><i class="bi bi-person-fill"></i> User</a>
          <div class="role-divider"></div>
          <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><i class="bi bi-shop"></i> Vendor</a>
          <div class="role-divider"></div>
          <a href="${pageContext.request.contextPath}/centres/login" class="role-item"><i class="fa-solid fa-dumbbell"></i> Centre</a>
        </div>
      </div>
    </div>
  </header>

  <main class="main">
    <section class="reset-section">
      <div class="container">
        <div class="reset-card" data-aos="fade-up">
          <h2>Reset Password</h2>
          <p class="subtitle">Account type: <strong>${userType}</strong></p>

          <c:if test="${not empty message}">
            <div class="alert alert-info reset-message" role="alert">${message}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/auth/reset-password" method="POST">
            <input type="hidden" name="token" value="${token}">
            <div class="mb-3">
              <label for="newPassword" class="form-label">New password</label>
              <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Enter new password" required>
            </div>
            <button type="submit" class="btn btn-reset">Update Password</button>
          </form>
        </div>
      </div>
    </section>
  </main>

  <footer id="footer" class="footer position-relative">
    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center">
            <span class="sitename">Fight D Fear</span>
          </a>
          <div class="pt-3">
            <p class="fw-semibold">Our Values</p>
            <p>Awareness • Safety • Equality • Empowerment</p>
            <p class="mt-2">Building a Safer Tomorrow, Together.</p>
          </div>
        </div>
        <div class="col-lg-2 col-md-3 footer-links">
          <h4>Useful Links</h4>
          <ul>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/#hero">Home</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/#about">About us</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/#services">Services</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
          </ul>
        </div>
        <div class="col-lg-2 col-md-3 footer-links">
          <h4>Our Services</h4>
          <ul>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/sos/dashboard">Emergency Assistance</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/video/allVideos">Safety Education</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Self-defense Training</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/stories">Community Support</a></li>
          </ul>
        </div>
        <div class="col-lg-4 col-md-12">
          <h4>Follow Us</h4>
          <p>Stay connected with us for safety updates, resources, and tips. Empower yourself and others!</p>
          <div class="social-links d-flex">
            <a href=""><i class="bi bi-twitter"></i></a>
            <a href=""><i class="bi bi-facebook"></i></a>
            <a href=""><i class="bi bi-instagram"></i></a>
            <a href=""><i class="bi bi-linkedin"></i></a>
          </div>
        </div>
      </div>
    </div>
    <div class="container copyright text-center mt-4">
      <p>© <span>Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> <span>All Rights Reserved</span></p>
    </div>
  </footer>

  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
  <script>
    if (typeof AOS !== 'undefined') { AOS.init(); }
  </script>
</body>
</html>

