<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Features - Fight D Fear</title>
  
  <link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">

  <style>
    :root {
      --primary: #f43f5e;
      --primary-hover: #e11d48;
      --navy-dark: #1e1b4b;
      --navy-light: #312e81;
      --bg-light: #f8fafc;
      --text-gray: #64748b;
      --text-dark: #0f172a;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #0f172a, #1e1b4b, #312e81);
      background-size: 300% 300%;
      animation: gradientBG 15s ease infinite;
      color: #f8fafc;
      overflow-x: hidden;
      margin: 0;
      padding: 0;
    }
    
    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* ===== PREMIUM NAVBAR ===== */
    .header-nav {
      background: rgba(15, 23, 42, 0.85);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      padding: 8px 0;
      box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      position: sticky;
      top: 0;
      z-index: 1000;
      transition: all 0.3s ease;
    }
    .header-nav .container {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .brand-logo {
      height: 70px;
      transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      border-radius: 12px;
      cursor: pointer;
    }
    .brand-logo:hover {
      transform: scale(1.08) rotate(-2deg);
      box-shadow: 0 12px 30px rgba(244, 63, 94, 0.2);
    }
    .nav-link {
      color: #f8fafc;
      font-weight: 600;
      font-size: 0.95rem;
      margin: 0 8px;
      padding: 8px 16px;
      border-radius: 30px;
      transition: all 0.3s ease;
      position: relative;
    }
    .nav-link:hover, .nav-link.active {
      color: var(--primary);
      background: rgba(244, 63, 94, 0.15);
    }
    .nav-link::after {
      content: '';
      position: absolute;
      bottom: 2px;
      left: 50%;
      width: 0;
      height: 2px;
      background: var(--primary);
      transition: all 0.3s ease;
      transform: translateX(-50%);
    }
    .nav-link:hover::after, .nav-link.active::after {
      width: 60%;
    }
    .btn-outline-custom {
      border: 2px solid var(--primary);
      background: transparent;
      padding: 8px 24px;
      border-radius: 40px;
      font-weight: 600;
      font-size: 0.9rem;
      color: var(--primary);
      transition: all 0.3s ease;
    }
    .btn-outline-custom:hover {
      background: var(--primary);
      color: #fff;
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(244, 63, 94, 0.25);
    }
    .btn-primary-custom {
      background: var(--primary);
      color: #fff;
      padding: 8px 24px;
      border-radius: 40px;
      font-weight: 600;
      font-size: 0.9rem;
      border: none;
      transition: all 0.3s ease;
    }
    .btn-primary-custom:hover {
      background: var(--primary-hover);
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(244, 63, 94, 0.3);
    }
    .btn-sos {
      background: var(--primary);
      color: #fff;
      border: none;
      padding: 8px 22px;
      border-radius: 40px;
      font-weight: 700;
      font-size: 0.85rem;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s ease;
      box-shadow: 0 8px 25px rgba(244, 63, 94, 0.3);
      animation: pulseSOS 2s infinite;
    }
    .btn-sos:hover {
      background: var(--primary-hover);
      transform: translateY(-2px) scale(1.05);
      color: #fff;
    }
    @keyframes pulseSOS {
      0%, 100% { box-shadow: 0 8px 25px rgba(244, 63, 94, 0.3); }
      50% { box-shadow: 0 8px 40px rgba(244, 63, 94, 0.5); }
    }

    /* ===== FEATURES HERO ===== */
    .features-hero {
      padding: 100px 0 60px;
      text-align: center;
      position: relative;
    }
    .features-hero::after {
      content: '';
      position: absolute;
      top: -50%;
      left: 50%;
      transform: translateX(-50%);
      width: 80%;
      height: 200%;
      background: radial-gradient(circle, rgba(244, 63, 94, 0.15) 0%, transparent 70%);
      z-index: -1;
    }
    .hero-badge {
      display: inline-block;
      background: rgba(244, 63, 94, 0.1);
      backdrop-filter: blur(10px);
      padding: 8px 28px;
      border-radius: 50px;
      font-size: 0.85rem;
      color: #fb7185;
      font-weight: 700;
      border: 1px solid rgba(244, 63, 94, 0.2);
      letter-spacing: 1.5px;
      text-transform: uppercase;
      margin-bottom: 20px;
      box-shadow: 0 4px 15px rgba(244, 63, 94, 0.2);
    }
    .features-hero-title {
      font-size: 4rem;
      font-weight: 900;
      line-height: 1.2;
      margin-bottom: 20px;
      background: linear-gradient(to right, #fff, #cbd5e1);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .features-hero-title span {
      background: linear-gradient(135deg, #fb7185, #f43f5e, #e11d48);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .features-hero-desc {
      font-size: 1.2rem;
      color: #94a3b8;
      max-width: 700px;
      margin: 0 auto 40px;
      line-height: 1.8;
    }

    /* ===== GLASSMORPHISM FEATURE CARDS ===== */
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 30px;
      padding-bottom: 100px;
    }
    .feature-card {
      background: rgba(255, 255, 255, 0.03);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 24px;
      padding: 40px 30px;
      position: relative;
      overflow: hidden;
      transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      z-index: 1;
    }
    .feature-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      background: radial-gradient(circle at top right, rgba(244, 63, 94, 0.15) 0%, transparent 60%);
      opacity: 0;
      transition: opacity 0.5s ease;
      z-index: -1;
    }
    .feature-card:hover {
      transform: translateY(-15px);
      border-color: rgba(244, 63, 94, 0.4);
      box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4), 0 0 30px rgba(244, 63, 94, 0.2);
    }
    .feature-card:hover::before {
      opacity: 1;
    }
    .feature-icon-wrapper {
      width: 70px;
      height: 70px;
      background: rgba(244, 63, 94, 0.1);
      border: 1px solid rgba(244, 63, 94, 0.2);
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 28px;
      color: #fb7185;
      margin-bottom: 25px;
      transition: all 0.5s ease;
      box-shadow: inset 0 0 20px rgba(244, 63, 94, 0.1);
    }
    .feature-card:hover .feature-icon-wrapper {
      background: var(--primary);
      color: #fff;
      transform: scale(1.1) rotate(5deg);
      box-shadow: 0 10px 25px rgba(244, 63, 94, 0.4);
    }
    .feature-card h3 {
      font-size: 1.6rem;
      font-weight: 700;
      color: #fff;
      margin-bottom: 15px;
      letter-spacing: 0.5px;
    }
    .feature-card p {
      color: #94a3b8;
      font-size: 0.95rem;
      line-height: 1.7;
      margin-bottom: 25px;
    }
    .feature-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
    .feature-tags span {
      background: rgba(255, 255, 255, 0.05);
      color: #cbd5e1;
      padding: 6px 14px;
      border-radius: 8px;
      font-size: 0.8rem;
      font-weight: 600;
      border: 1px solid rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
    }
    .feature-card:hover .feature-tags span {
      border-color: rgba(244, 63, 94, 0.3);
      color: #fb7185;
      background: rgba(244, 63, 94, 0.05);
    }

    /* Abstract background shapes */
    .bg-shape {
      position: fixed;
      filter: blur(120px);
      z-index: -1;
      border-radius: 50%;
      animation: float 20s infinite alternate;
      opacity: 0.4;
    }
    .shape-1 {
      top: -10%;
      right: -10%;
      width: 600px;
      height: 600px;
      background: #312e81;
    }
    .shape-2 {
      bottom: -10%;
      left: -10%;
      width: 500px;
      height: 500px;
      background: #e11d48;
    }
    .shape-3 {
      top: 40%;
      left: 30%;
      width: 400px;
      height: 400px;
      background: #4f46e5;
    }

    @keyframes float {
      0% { transform: translate(0, 0) scale(1); }
      100% { transform: translate(50px, 50px) scale(1.2); }
    }

    /* ===== FOOTER (Adapted for Dark Mode) ===== */
    .footer {
      background: rgba(15, 23, 42, 0.9);
      backdrop-filter: blur(20px);
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding: 80px 0 30px;
      position: relative;
    }
    .footer h5 { font-size: 18px; font-weight: 700; margin-bottom: 25px; color: white; }
    .footer ul { list-style: none; padding: 0; margin: 0; }
    .footer ul li { margin-bottom: 12px; }
    .footer ul li a { color: #94a3b8; font-size: 14.5px; transition: all 0.3s; text-decoration: none; display: inline-block; }
    .footer ul li a:hover { color: var(--primary); transform: translateX(5px); }
    .footer-logo { margin-bottom: 20px; }
    .social-links a { color: white; width: 40px; height: 40px; background: rgba(255,255,255,0.05); display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; margin-right: 12px; transition: all 0.3s; text-decoration: none; }
    .social-links a:hover { background: var(--primary); transform: translateY(-5px) scale(1.1); box-shadow: 0 10px 20px rgba(244, 63, 94, 0.3); }
    .newsletter-input { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: white; padding: 12px 20px; border-radius: 8px; width: 100%; margin-bottom: 15px; transition: border-color 0.3s; }
    .newsletter-input:focus { outline: none; border-color: var(--primary); background: rgba(255,255,255,0.1); }
    .newsletter-btn { background: var(--primary); color: white; border: none; padding: 12px; width: 100%; border-radius: 8px; font-weight: 700; transition: all 0.3s; }
    .newsletter-btn:hover { background: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 10px 20px rgba(244, 63, 94, 0.2); }
    .copyright { text-align: center; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 25px; margin-top: 50px; font-size: 14px; color: #64748b; }

    @media (max-width: 768px) {
      .features-hero-title { font-size: 2.5rem; }
      .brand-logo { height: 50px; }
      .feature-card { padding: 30px 20px; }
    }
  </style>
</head>
<body>

  <!-- Abstract Background Shapes -->
  <div class="bg-shape shape-1"></div>
  <div class="bg-shape shape-2"></div>
  <div class="bg-shape shape-3"></div>

  <!-- ===== HEADER ===== -->
  <header class="header-nav">
    <div class="container">
      <div class="d-flex align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" class="brand-logo" style="background: white; padding: 2px;"></a>
      </div>
      
      <nav class="d-none d-lg-flex align-items-center">
        <a href="${pageContext.request.contextPath}/" class="nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/features.jsp" class="nav-link active">Features</a>
        <a href="${pageContext.request.contextPath}/#awareness" class="nav-link">Awareness</a>
        <a href="${pageContext.request.contextPath}/#emergency" class="nav-link">Emergency</a>
        <a href="${pageContext.request.contextPath}/#howitworks" class="nav-link">How It Works</a>
      </nav>

      <div class="d-flex align-items-center gap-2">
        <c:choose>
          <c:when test="${not empty user || not empty loggedProvider || not empty loggedCentre || not empty loggedDoctor || not empty loggedSalon || not empty loggedStylist || not empty loggedSeller || not empty admin}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/users/dashboard" />
            <c:if test="${not empty loggedProvider}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/marketplace/provider/dashboard" /></c:if>
            <c:if test="${not empty loggedCentre}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/centres/dashboard" /></c:if>
            <c:if test="${not empty loggedDoctor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/doctors/dashboard" /></c:if>
            <c:if test="${not empty admin}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/adminDashboard" /></c:if>
            <a href="${dashboardUrl}" class="btn-outline-custom d-none d-md-inline-block"><i class="fa-solid fa-gauge-high me-1"></i> Dashboard</a>
          </c:when>
          <c:otherwise>
            <div class="dropdown d-none d-md-inline-block">
              <button class="btn-outline-custom dropdown-toggle" type="button" data-bs-toggle="dropdown" style="color:#fff; border-color: rgba(255,255,255,0.5);"><i class="fa-solid fa-right-to-bracket me-1"></i> Login</button>
              <ul class="dropdown-menu dropdown-menu-dark">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">User</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctors/login">Doctor</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/centres/login">Martial Arts</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/salons/login">Salon</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/loginAdmin">Admin</a></li>
              </ul>
            </div>
            <div class="dropdown d-none d-md-inline-block">
              <button class="btn-primary-custom dropdown-toggle" type="button" data-bs-toggle="dropdown"><i class="fa-solid fa-user-plus me-1"></i> Register</button>
              <ul class="dropdown-menu dropdown-menu-dark">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/register">User</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctors/register">Doctor</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/centres/registerCentre">Martial Arts</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/salons/register">Salon</a></li>
              </ul>
            </div>
          </c:otherwise>
        </c:choose>
        <a href="${pageContext.request.contextPath}/sos/dashboard" class="btn-sos"><i class="fa-solid fa-phone"></i> SOS</a>
      </div>
    </div>
  </header>

  <!-- ===== MAIN CONTENT ===== -->
  <main>
    <div class="container">
      <div class="features-hero" data-aos="fade-up">
        <span class="hero-badge"><i class="fa-solid fa-wand-magic-sparkles me-2"></i> All-In-One Platform</span>
        <h1 class="features-hero-title">Everything You Need For <br><span>Women's Empowerment</span></h1>
        <p class="features-hero-desc">Discover the 9 core modules designed to protect, connect, and elevate women everywhere. We combine cutting-edge technology with community solidarity.</p>
      </div>

      <div class="feature-grid">
        
        <!-- 1. Core Safety -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-shield-halved"></i></div>
          <h3>1. Core Safety Features</h3>
          <p>Experience absolute security with instant SOS panic buttons, live location sharing, audio recording, and automated emergency contact alerts. Your invisible shield.</p>
          <div class="feature-tags">
            <span>SOS Alert</span>
            <span>Live Tracking</span>
            <span>Safe Route</span>
          </div>
        </div>

        <!-- 2. Community -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-users"></i></div>
          <h3>2. Community & Solidarity</h3>
          <p>You are never alone. Engage in community posts, Q&A sessions, safety stories, and build a powerful volunteer network and buddy system in your neighborhood.</p>
          <div class="feature-tags">
            <span>Chat</span>
            <span>Volunteer</span>
            <span>Buddy System</span>
          </div>
        </div>

        <!-- 3. Location Intelligence -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-location-dot"></i></div>
          <h3>3. Location Intelligence</h3>
          <p>Smart mapping that proactively warns you. Features include live GPS tracking, dynamic danger point mapping, and safe route navigation for stress-free journeys.</p>
          <div class="feature-tags">
            <span>Danger Maps</span>
            <span>Smart Routing</span>
            <span>GPS Tracking</span>
          </div>
        </div>

        <!-- 4. Skill Development -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="400">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-graduation-cap"></i></div>
          <h3>4. Skill Development</h3>
          <p>Self-defense and career training. Access online classes, track your progress, enroll in training programs, and master skills that boost your confidence.</p>
          <div class="feature-tags">
            <span>Online Classes</span>
            <span>Self-Defense</span>
            <span>Certificates</span>
          </div>
        </div>

        <!-- 5. Marketplace -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="500">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-store"></i></div>
          <h3>5. Women's Marketplace</h3>
          <p>A specialized marketplace for women's products. Enjoy secure digital wallet payments, exclusive offers, and seamless seller communication.</p>
          <div class="feature-tags">
            <span>E-Commerce</span>
            <span>Digital Wallet</span>
            <span>Exclusive Offers</span>
          </div>
        </div>

        <!-- 6. Beauty & Salon -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="600">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-spa"></i></div>
          <h3>6. Beauty & Salon Booking</h3>
          <p>Self-care made easy. Book appointments with top-rated professional stylists, explore treatment packages, and read verified stylist reviews.</p>
          <div class="feature-tags">
            <span>Salon Booking</span>
            <span>Stylist Reviews</span>
            <span>Treatments</span>
          </div>
        </div>

        <!-- 7. Professional Consultation -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="700">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-stethoscope"></i></div>
          <h3>7. Expert Consultations</h3>
          <p>Connect securely with verified Doctors through video appointments. Future expansions include accessible Lawyers, Therapists, and Career Mentors.</p>
          <div class="feature-tags">
            <span>Doctors</span>
            <span>Video Consult</span>
            <span>Mentors</span>
          </div>
        </div>

        <!-- 8. Communication -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="800">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-comments"></i></div>
          <h3>8. Secure Communication</h3>
          <p>End-to-end encrypted real-time chat, crystal-clear video calls, instant emergency alerts, and seamless messaging with your trusted contacts.</p>
          <div class="feature-tags">
            <span>Encrypted Chat</span>
            <span>Video Calls</span>
            <span>Alerts</span>
          </div>
        </div>

        <!-- 9. Content Platform -->
        <div class="feature-card" data-aos="fade-up" data-aos-delay="900">
          <div class="feature-icon-wrapper"><i class="fa-solid fa-video"></i></div>
          <h3>9. Content & Stories</h3>
          <p>A creator-style engagement platform to upload videos, watch curated safety content, share inspirational stories, and interact with media.</p>
          <div class="feature-tags">
            <span>Videos</span>
            <span>Stories</span>
            <span>Media</span>
          </div>
        </div>

      </div>
    </div>
  </main>

  <!-- ===== FOOTER ===== -->
  <footer class="footer">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3 col-md-6">
          <div class="footer-logo">
            <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear Logo" style="height: 85px; background: white; padding: 5px; border-radius: 10px;"></a>
          </div>
          <p style="color: #cbd5e1; font-size: 13px; line-height: 1.6;">Our mission is to empower women with technology and community support for a safer tomorrow.</p>
          <div class="social-links mt-3">
            <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="#"><i class="fa-brands fa-twitter"></i></a>
            <a href="#"><i class="fa-brands fa-instagram"></i></a>
            <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
            <a href="#"><i class="fa-brands fa-youtube"></i></a>
          </div>
        </div>
        <div class="col-lg-2 col-md-6">
          <h5>Quick Links</h5>
          <ul>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/features.jsp">Features</a></li>
            <li><a href="${pageContext.request.contextPath}/#awareness">Awareness</a></li>
            <li><a href="${pageContext.request.contextPath}/#emergency">Emergency</a></li>
            <li><a href="${pageContext.request.contextPath}/#howitworks">How It Works</a></li>
          </ul>
        </div>
        <div class="col-lg-3 col-md-6">
          <h5>Important Links</h5>
          <ul>
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#">Terms & Conditions</a></li>
            <li><a href="#">Refund Policy</a></li>
            <li><a href="#">Disclaimer</a></li>
            <li><a href="#">Help & Support</a></li>
          </ul>
        </div>
        <div class="col-lg-4 col-md-6">
          <h5>Contact Us</h5>
          <ul style="margin-bottom: 20px;">
            <li><i class="fa-solid fa-envelope" style="width:20px; color:var(--primary);"></i> support@womensafety.com</li>
            <li><i class="fa-solid fa-phone" style="width:20px; color:var(--primary);"></i> +91 98765 43210</li>
            <li><i class="fa-solid fa-location-dot" style="width:20px; color:var(--primary);"></i> Mumbai, Maharashtra, India</li>
          </ul>
          <h5>Newsletter</h5>
          <p style="color: #cbd5e1; font-size: 13px;">Subscribe to get latest updates and safety tips.</p>
          <form action="#">
            <input type="email" class="newsletter-input" placeholder="Enter your email" required>
            <button type="submit" class="newsletter-btn">Subscribe</button>
          </form>
        </div>
      </div>
      <div class="copyright">&copy; 2026 Fight D Fear. All Rights Reserved.</div>
    </div>
  </footer>

  <!-- Scripts -->
  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script>
    AOS.init({
      duration: 1000,
      easing: 'ease-out-cubic',
      once: true,
      mirror: false
    });
  </script>
</body>
</html>
