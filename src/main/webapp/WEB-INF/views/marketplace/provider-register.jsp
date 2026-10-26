<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Provider Registration — Fight D Fear</title>
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
  <style>
      :root {
          --primary: #F43F5E;
          --primary-hover: #E11D48;
          --navy: #1E1B4B;
          --text-gray: #64748B;
          --bg-page: #F8FAFC;
          --card-bg: #FFFFFF;
          --border-color: #E2E8F0;
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

      .main-container {
          flex: 1;
          max-width: 600px;
          width: 100%;
          margin: 40px auto;
          padding: 0 16px;
      }

      .form-card {
          background: var(--card-bg);
          border: 1px solid var(--border-color);
          border-radius: 16px;
          padding: 40px 32px;
          box-shadow: 0 4px 20px rgba(0,0,0,0.03);
      }

      .card-header-area { text-align: center; margin-bottom: 30px; }
      .card-header-area h2 { font-size: 1.8rem; font-weight: 800; color: var(--navy); margin-bottom: 6px; }
      .card-header-area p { font-size: 0.95rem; color: var(--text-gray); }

      .fdf-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 16px; }
      .fdf-group { margin-bottom: 18px; text-align: left; }
      .fdf-group label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--navy); margin-bottom: 6px; }
      .fdf-input { width: 100%; padding: 12px 14px; border: 1px solid var(--border-color); border-radius: 10px; font-size: 0.95rem; font-family: inherit; color: var(--navy); background: #FFFFFF; transition: all 0.2s ease; }
      .fdf-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12); }

      .btn-dr { padding: 14px 28px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.3s; border: none; font-size: 1rem; }
      .btn-dr-next { background: var(--primary); color: #fff; width: 100%; margin-top: 10px; }
      .btn-dr-next:hover { background: var(--primary-hover); transform: translateY(-1px); }
      .btn-dr-prev { background: #f1f5f9; color: var(--text-gray); width: 100%; }
      .btn-dr-prev:hover { background: #e2e8f0; }

      .dr-progress { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
      .dr-step-dot { width: 36px; height: 36px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem; transition: 0.3s; color: var(--text-gray); }
      .dr-step-dot.active { background: var(--primary); color: #fff; transform: scale(1.1); box-shadow: 0 4px 10px rgba(244, 63, 94, 0.3); }
      .dr-step-dot.completed { background: var(--navy); color: #fff; }
      
      .dr-step-panel { display: none; animation: fadeIn 0.4s ease; }
      .dr-step-panel.active { display: block; }
      @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

      .login-footer { text-align: center; margin-top: 24px; font-size: 0.9rem; color: var(--text-gray); }
      .login-footer a { color: var(--primary); text-decoration: none; font-weight: 700; }

      @media (max-width: 600px) {
          .fdf-row { grid-template-columns: 1fr; gap: 0; }
      }
      @media (max-width: 480px) {
          .main-container { padding: 0 16px; margin: 20px auto; width: 100%; }
          .form-card { padding: 24px 16px; width: 100%; }
      }

      /* Terms Modal Styles */
      .modal-overlay {
          position: fixed;
          top: 0; left: 0; right: 0; bottom: 0;
          background: rgba(15, 23, 42, 0.6);
          backdrop-filter: blur(4px);
          display: none;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          padding: 16px;
      }
      .modal-card {
          background: #FFFFFF;
          border-radius: 20px;
          max-width: 580px;
          width: 100%;
          padding: 24px;
          box-shadow: 0 20px 40px rgba(0,0,0,0.15);
      }
      .modal-header {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 16px;
      }
      .modal-header .icon-wrap {
          width: 44px;
          height: 44px;
          border-radius: 12px;
          background: #FDF2F8;
          color: var(--primary);
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.3rem;
      }
      .modal-actions {
          display: flex;
          gap: 12px;
          margin-top: 18px;
      }
      .btn-modal-cancel {
          flex: 1;
          padding: 12px;
          background: #F1F5F9;
          border: 1px solid #CBD5E1;
          border-radius: 10px;
          font-weight: 700;
          color: #475569;
          cursor: pointer;
      }
      .btn-modal-confirm {
          flex: 1.5;
          padding: 12px;
          background: var(--primary);
          border: none;
          border-radius: 10px;
          font-weight: 700;
          color: #FFFFFF;
          cursor: pointer;
      }
  </style>
</head>
<body>


  <header class="app-header">
      <div style="display: flex; align-items: center; gap: 16px;">
          <a href="javascript:history.back()" style="color: var(--navy); text-decoration: none; font-size: 1.2rem; display: none;" class="mobile-back-btn">
              <i class="bi bi-arrow-left"></i>
          </a>
          <a href="${pageContext.request.contextPath}/" class="header-brand">
              <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
          </a>
      </div>
  </header>

  <main class="main-container">
      <div class="form-card">
          <div class="card-header-area">
              <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 64px; width: 64px; border-radius: 16px; object-fit: cover; margin-bottom: 12px; box-shadow: 0 4px 12px rgba(244,63,94,0.15);">
              <h2>Provider Registration</h2>
              <p>Register your services to join the platform</p>
          </div>


          <div class="dr-progress">
              <div class="dr-step-dot active" data-step="1" id="dot1">1</div>
              <div class="dr-step-dot" data-step="2" id="dot2">2</div>
          </div>

          <c:if test="${not empty error}">
              <div class="alert alert-danger" style="border-radius:12px; padding:12px; font-size:0.9rem; margin-bottom:20px;">${error}</div>
          </c:if>
          
          <form action="${pageContext.request.contextPath}/marketplace/provider/register" method="post" enctype="multipart/form-data" id="providerForm">
              <!-- Step 1: Account Information -->
              <div class="dr-step-panel active" id="step1">
                  <h4 style="margin-bottom:20px; color:var(--navy); font-weight:700;">Account Details</h4>
                  <div class="fdf-row">
                      <div class="fdf-group"><label>Full Name</label><input class="fdf-input" name="fullName" placeholder="Priya Sharma" required></div>
                      <div class="fdf-group"><label>Email</label><input class="fdf-input" type="email" name="email" placeholder="priya@example.com" required></div>
                  </div>
                  <div class="fdf-row">
                      <div class="fdf-group"><label>Phone</label><input class="fdf-input" type="tel" name="phone" placeholder="10-digit number" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required></div>
                      <div class="fdf-group"><label>Password</label><input class="fdf-input" type="password" name="password" placeholder="Min. 8 characters" minlength="8" required></div>
                  </div>
                  <button type="button" class="btn-dr btn-dr-next" onclick="nextStep(1)">Continue to Professional Details <i class="bi bi-arrow-right"></i></button>
              </div>

              <!-- Step 2: Professional Details -->
              <div class="dr-step-panel" id="step2">
                  <h4 style="margin-bottom:20px; color:var(--navy); font-weight:700;">Professional Details</h4>
                  <div class="fdf-row">
                      <div class="fdf-group">
                          <label>Category</label>
                          <select class="fdf-input" name="category" id="categorySelect" required>
                              <option value="" disabled ${empty param.category ? 'selected' : ''}>Choose a category</option>
                              <c:forEach var="cat" items="${providerCategories}">
                                  <option value="${cat.name()}" ${param.category == cat.name() ? 'selected' : ''}>${cat.displayName}</option>
                              </c:forEach>
                              <c:if test="${empty providerCategories}">
                                  <option value="TUTOR" ${param.category == 'TUTOR' ? 'selected' : ''}>Tutor</option>
                                  <option value="TAILOR" ${param.category == 'TAILOR' ? 'selected' : ''}>Tailor</option>
                                  <option value="HOME_COOK" ${param.category == 'HOME_COOK' ? 'selected' : ''}>Home Cook</option>
                                  <option value="CATERING_SERVICE" ${param.category == 'CATERING_SERVICE' ? 'selected' : ''}>Catering Service</option>
                                  <option value="EVENT_PLANNER" ${param.category == 'EVENT_PLANNER' ? 'selected' : ''}>Event Planner</option>
                                  <option value="BABYSITTER" ${param.category == 'BABYSITTER' ? 'selected' : ''}>Babysitter</option>
                                  <option value="PET_CARE" ${param.category == 'PET_CARE' ? 'selected' : ''}>Pet Care</option>
                                  <option value="DIETITIAN" ${param.category == 'DIETITIAN' ? 'selected' : ''}>Dietitian</option>
                                  <option value="HOME_CLEANER" ${param.category == 'HOME_CLEANER' ? 'selected' : ''}>Home Cleaner</option>
                                  <option value="INTERIOR_DESIGNER" ${param.category == 'INTERIOR_DESIGNER' ? 'selected' : ''}>Interior Designer</option>
                                  <option value="HANDICRAFT_SELLER" ${param.category == 'HANDICRAFT_SELLER' ? 'selected' : ''}>Handicraft Seller</option>
                                  <option value="DIGITAL_MARKETING_CONSULTANT" ${param.category == 'DIGITAL_MARKETING_CONSULTANT' ? 'selected' : ''}>Digital Marketing Consultant</option>
                                  <option value="HOME_BAKER" ${param.category == 'HOME_BAKER' ? 'selected' : ''}>Home Baker</option>
                                  <option value="LANGUAGE_TRAINER" ${param.category == 'LANGUAGE_TRAINER' ? 'selected' : ''}>Language Trainer</option>
                                  <option value="WOMEN_PRODUCTS" ${param.category == 'WOMEN_PRODUCTS' ? 'selected' : ''}>Women Products</option>
                                  <option value="WOMEN_LAWYER" ${param.category == 'WOMEN_LAWYER' ? 'selected' : ''}>Women Lawyer</option>
                                  <option value="FITNESS_ZUMBA" ${param.category == 'FITNESS_ZUMBA' ? 'selected' : ''}>Fitness / Zumba</option>
                                  <option value="BEAUTICIAN" ${param.category == 'BEAUTICIAN' ? 'selected' : ''}>Beautician</option>
                                  <option value="MAKEUP_ARTIST" ${param.category == 'MAKEUP_ARTIST' ? 'selected' : ''}>Makeup Artist</option>
                                  <option value="MEHENDI_ARTIST" ${param.category == 'MEHENDI_ARTIST' ? 'selected' : ''}>Mehendi Artist</option>
                                  <option value="PHOTOGRAPHER" ${param.category == 'PHOTOGRAPHER' ? 'selected' : ''}>Photographer</option>
                                  <option value="YOGA_TRAINER" ${param.category == 'YOGA_TRAINER' ? 'selected' : ''}>Yoga Trainer</option>
                                  <option value="FITNESS_TRAINER" ${param.category == 'FITNESS_TRAINER' ? 'selected' : ''}>Fitness Trainer</option>
                                  <option value="DANCE_INSTRUCTOR" ${param.category == 'DANCE_INSTRUCTOR' ? 'selected' : ''}>Dance Instructor</option>
                                  <option value="MUSIC_TEACHER" ${param.category == 'MUSIC_TEACHER' ? 'selected' : ''}>Music Teacher</option>
                                  <option value="CRAFT_SELLER" ${param.category == 'CRAFT_SELLER' ? 'selected' : ''}>Craft Seller</option>
                                  <option value="HANDMADE_PRODUCTS" ${param.category == 'HANDMADE_PRODUCTS' ? 'selected' : ''}>Handmade Products</option>
                                  <option value="BOUTIQUE" ${param.category == 'BOUTIQUE' ? 'selected' : ''}>Boutique</option>
                                  <option value="FASHION_DESIGNER" ${param.category == 'FASHION_DESIGNER' ? 'selected' : ''}>Fashion Designer</option>
                                  <option value="FREELANCER" ${param.category == 'FREELANCER' ? 'selected' : ''}>Freelancer</option>
                                  <option value="GRAPHIC_DESIGNER" ${param.category == 'GRAPHIC_DESIGNER' ? 'selected' : ''}>Graphic Designer</option>
                                  <option value="CONTENT_WRITER" ${param.category == 'CONTENT_WRITER' ? 'selected' : ''}>Content Writer</option>
                                  <option value="MARTIAL_ARTS" ${param.category == 'MARTIAL_ARTS' ? 'selected' : ''}>Martial Arts</option>
                                  <option value="FEMALE_DOCTORS" ${param.category == 'FEMALE_DOCTORS' ? 'selected' : ''}>Female Doctors</option>
                              </c:if>
                          </select>
                      </div>
                      <div class="fdf-group"><label>Location</label><input class="fdf-input" name="locationText" placeholder="City / Area" required></div>
                  </div>
                  <div class="fdf-group"><label>Profile Bio / Description</label><textarea class="fdf-input" name="description" rows="3" maxlength="300" placeholder="Tell us about your services..." required></textarea></div>
                  <div class="fdf-group"><label>Gov ID Identification (PDF/IMG)</label><input class="fdf-input" type="file" name="identityDoc" style="padding:10px;" required></div>
                  
                  <!-- Terms & Conditions Box with Modal Link -->
                  <div class="terms-box" style="background:#FDF2F8; border:1px solid #FBCFE8; border-radius:12px; padding:12px 14px; margin:20px 0 10px;">
                      <div style="display:flex; align-items:flex-start; gap:10px;">
                          <input type="checkbox" name="acceptedTerms" id="termsCheck" value="true" required style="width:18px; height:18px; accent-color:var(--primary); cursor:pointer; margin-top:2px;">
                          <label for="termsCheck" style="font-size:0.88rem; color:var(--navy); font-weight:500; cursor:pointer; line-height:1.45; margin:0;">
                              I have read and agree to the 
                              <a href="javascript:void(0)" onclick="openTermsModal('Terms &amp; Conditions', false)" style="color:var(--primary); font-weight:700; text-decoration:underline;">
                                  Terms &amp; Conditions
                              </a>
                              and <a href="javascript:void(0)" onclick="openTermsModal('Privacy Policy &amp; Data Security', true)" style="color:var(--primary); font-weight:700; text-decoration:underline;">Privacy Policy</a> *
                          </label>
                      </div>
                      <div id="termsCheckBadge" style="display:none; font-size:0.8rem; color:#16A34A; font-weight:700; margin-top:6px; padding-left:28px;">
                          <i class="bi bi-check-circle-fill"></i> Terms accepted &amp; verified
                      </div>
                  </div>

                  <div style="display:flex; justify-content:space-between; gap:15px; margin-top:20px;">
                      <button type="button" class="btn-dr btn-dr-prev w-50" onclick="showStep(1)"><i class="bi bi-arrow-left"></i> Back</button>
                      <button type="submit" class="btn-dr btn-dr-next w-50" style="margin-top:0;">Register</button>
                  </div>
              </div>
          </form>
          
          <div class="login-footer">
              Already registered? <a href="${pageContext.request.contextPath}/marketplace/provider/login">Sign In</a>
          </div>
      </div>
  </main>

  <!-- Terms & Conditions Modal -->
  <div id="termsModal" class="modal-overlay">
      <div class="modal-card" style="max-width: 580px; max-height: 85vh; display: flex; flex-direction: column;">
          <div class="modal-header" style="border-bottom: 1px solid var(--border-color); padding-bottom: 14px; margin-bottom: 14px;">
              <div class="icon-wrap"><i class="bi bi-journal-check"></i></div>
              <div style="flex: 1;">
                  <h3 id="termsModalTitle" style="margin:0; font-size:1.15rem; font-weight:800; color:var(--navy);">Terms &amp; Conditions</h3>
                  <p style="font-size: 0.82rem; color: var(--text-gray); margin: 0;">Fight D Fear — Women Community &amp; Safety Platform</p>
              </div>
              <button type="button" onclick="closeTermsModal()" style="background:none; border:none; font-size:1.5rem; color:var(--text-gray); cursor:pointer; line-height:1;">&times;</button>
          </div>
          <div class="modal-body" id="termsModalContent" style="overflow-y: auto; max-height: 48vh; font-size: 0.88rem; line-height: 1.6; color: var(--navy); background: #FFF; padding: 14px 18px; border: 1px solid var(--border-color); border-radius: 12px;">
              <div id="termsTextSection">
                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">1. Purpose &amp; Women-Centric Services</h4>
                  <p style="margin-bottom:12px; color:var(--text-gray);">Fight D Fear provides an empowerment, personal safety, and trusted freelance service network. By registering as a provider, you commit to professional excellence, safety, and mutual respect.</p>

                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">2. Professional Integrity &amp; Verification</h4>
                  <p style="margin-bottom:12px; color:var(--text-gray);">All certifications, portfolio work, skills, and identification documents must be authentic. Providing falsified information results in account revocation.</p>

                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">3. Service Safety &amp; Code of Conduct</h4>
                  <p style="margin-bottom:12px; color:var(--text-gray);">Service providers must strictly adhere to personal safety guidelines when interacting with clients. Misconduct or violation of client safety triggers zero-tolerance termination.</p>

                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">4. Privacy &amp; Data Security</h4>
                  <p style="margin-bottom:0; color:var(--text-gray);">All user contact information and transaction details are encrypted and maintained with highest safety standards.</p>
              </div>
              <div id="privacyTextSection" style="display:none;">
                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">1. Information We Collect</h4>
                  <p style="margin-bottom:12px; color:var(--text-gray);">We collect contact data, service specialties, identity verification documents, and payout records strictly for platform operation and safety checks.</p>

                  <h4 style="font-size:0.95rem; font-weight:800; color:var(--navy); margin-bottom:4px;">2. Security &amp; Data Protection</h4>
                  <p style="margin-bottom:0; color:var(--text-gray);">We use industry-standard encryption protocols to safeguard your personal credentials and government ID records.</p>
              </div>
          </div>
          <div class="modal-actions" style="margin-top: 14px;">
              <button type="button" class="btn-modal-cancel" onclick="closeTermsModal()">Close</button>
              <button type="button" class="btn-modal-confirm" onclick="acceptTermsAndClose()">
                  I Agree &amp; Accept <i class="bi bi-check2-circle"></i>
              </button>
          </div>
      </div>
  </div>

  <script>
      function openTermsModal(title, isPrivacy) {
          document.getElementById('termsModalTitle').textContent = title;
          document.getElementById('termsTextSection').style.display = isPrivacy ? 'none' : 'block';
          document.getElementById('privacyTextSection').style.display = isPrivacy ? 'block' : 'none';
          document.getElementById('termsModal').style.display = 'flex';
      }

      function closeTermsModal() {
          document.getElementById('termsModal').style.display = 'none';
      }

      function acceptTermsAndClose() {
          var chk = document.getElementById('termsCheck');
          if (chk) {
              chk.checked = true;
              syncTermsCheckBadge();
          }
          closeTermsModal();
      }

      function syncTermsCheckBadge() {
          var chk = document.getElementById('termsCheck');
          var badge = document.getElementById('termsCheckBadge');
          if (badge && chk) {
              badge.style.display = chk.checked ? 'block' : 'none';
          }
      }

      function showStep(s) {
          document.querySelectorAll('.dr-step-panel').forEach(p => p.classList.remove('active'));
          document.getElementById('step' + s).classList.add('active');
          document.querySelectorAll('.dr-step-dot').forEach(d => {
              const step = parseInt(d.dataset.step);
              d.classList.remove('active', 'completed');
              if (step === s) d.classList.add('active');
              else if (step < s) d.classList.add('completed');
          });
      }

      function nextStep(s) {
          const panel = document.getElementById('step' + s);
          const req = panel.querySelectorAll('[required]');
          let valid = true;
          req.forEach(el => { if (!el.value) { el.style.borderColor = 'red'; valid = false; } else { el.style.borderColor = ''; } });
          if (valid) showStep(s + 1);
      }

      document.addEventListener('DOMContentLoaded', function() {
          var chk = document.getElementById('termsCheck');
          if (chk) {
              chk.addEventListener('change', syncTermsCheckBadge);
          }
          var form = document.getElementById('providerForm');
          if (form) {
              form.addEventListener('submit', function(e) {
                  var terms = document.getElementById('termsCheck');
                  if (terms && !terms.checked) {
                      e.preventDefault();
                      terms.focus();
                      alert('Please agree to the Terms & Conditions and Privacy Policy to register.');
                  }
              });
          }
      });
  </script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>

</body>
</html>
