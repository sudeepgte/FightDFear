<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>

<html lang="en">
<meta charset="UTF-8">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Fight D Fear - Empowering Women</title>
  <meta name="description" content="">
  <meta name="keywords" content="">

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Fonts -->
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
  <!-- Purpose: global typography used by assets/css/main.css -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <!-- Bootstrap Icons CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
  <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

  <!-- Main CSS File -->
  <link href="assets/css/main.css" rel="stylesheet">
  <link href="assets/css/Fight D Fear-theme.css" rel="stylesheet">
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>

  <!-- =======================================================
  * Template Name: Ninestars
  * Template URL: https://bootstrapmade.com/ninestars-free-bootstrap-3-theme-for-creative/
  * Updated: Aug 07 2024 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
  
  <style>
  /* ===============================
     ULTRA PREMIUM PRELOADER
  ================================ */
  #preloader {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: #fffcfd;
    z-index: 99999;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: opacity 0.8s cubic-bezier(0.8, 0, 0.2, 1), visibility 0.8s;
  }
  #preloader::before {
    content: '';
    width: 60px;
    height: 60px;
    border: 4px solid rgba(219, 39, 119, 0.1);
    border-top-color: #f43f5e;
    border-radius: 50%;
    animation: spinPremium 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
  }
  @keyframes spinPremium { 100% { transform: rotate(360deg); } }

  /* GLASSMORPHISM HEADER */
  .header.sticky-top {
    background: rgba(255, 255, 255, 0.6) !important;
    backdrop-filter: blur(25px) saturate(200%);
    -webkit-backdrop-filter: blur(25px) saturate(200%);
    border-bottom: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    transition: all 0.4s ease;
  }

  html, body {
    overflow-x: hidden;
    width: 100%;
  }

  /* ===============================
   HERO SECTION
================================ */
.hero-section {
    padding: 30px 0 70px;
   background: transparent;
   position: relative;
   overflow: hidden;
}

.hero-section::before,
.hero-section::after,
.about::before,
.about::after{
  content:"";
  position:absolute;
  width:420px;
  height:420px;
  border-radius: 50%;
  filter: blur(55px);
  opacity: .35;
  z-index: 0;
  pointer-events:none;
  animation: floatBlob 10s ease-in-out infinite;
}
.hero-section::before, .about::before{
  top:-120px; left:-120px;
  background: radial-gradient(circle at 30% 30%, rgba(124, 45, 94, 0.85), rgba(219, 39, 119, 0.0) 60%);
}
.hero-section::after, .about::after{
  bottom:-150px; right:-140px;
  background: radial-gradient(circle at 30% 30%, rgba(219, 39, 119, 0.85), rgba(124, 45, 94, 0.0) 60%);
  animation-delay: -4s;
}
.about {
  position: relative;
  overflow: hidden;
  background: transparent;
}
@keyframes floatBlob{
  0%,100%{ transform: translate3d(0,0,0) scale(1); }
  50%{ transform: translate3d(18px,-10px,0) scale(1.06); }
}

.hero-title{font-size:clamp(2.25rem, 8vw, 3.5rem);font-weight:800;color:#3F1430!important;margin-bottom:20px;line-height:1.1}.text-gradient{background:linear-gradient(90deg,#1e1b4b,#f43f5e,#1e1b4b);background-size:200% auto;animation:shine 3s linear infinite;-webkit-background-clip:text;-webkit-text-fill-color:transparent}@keyframes shine{to{background-position:200% center}}.hero-content,.hero-image-wrapper{position:relative;z-index:2}.hero-lead,.hero-values{font-size:clamp(1rem, 4vw, 1.2rem);line-height:1.6;color:#1e1b4b!important;margin-bottom:20px;max-width:540px}.hero-values strong{color:#f43f5e!important}.btn-funky,.btn-funky-outline{border-radius:999px;font-weight:900;transition:all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);padding:14px 30px;position:relative;overflow:hidden;z-index:1}.btn-funky{background:linear-gradient(45deg,#1e1b4b,#f43f5e,#1e1b4b);background-size:200% auto;color:#fff!important;border:0;box-shadow:0 10px 20px rgba(124,45,94,0.2)}.btn-funky:hover{background-position:right center;box-shadow:0 15px 30px rgba(219,39,119,0.4);transform:translateY(-3px) scale(1.02)}.btn-funky-outline{background:rgba(255,255,255,0.7);color:#1e1b4b!important;border:1px solid rgba(124,45,94,0.3);backdrop-filter:blur(10px)}.btn-funky-outline:hover{background:#fff;box-shadow:0 10px 20px rgba(124,45,94,0.15);transform:translateY(-3px) scale(1.02)}.hero-actions{margin-top:25px;display:flex;gap:15px;flex-wrap:wrap}.navmenu a,.navmenu a:focus{color:#3F1430!important;font-weight:600;transition:color 0.3s ease}.navmenu a:hover{color:#f43f5e!important}

/* HERO IMAGE */
.hero-image{max-width:420px;width:100%;border-radius:18px}.hero-content{margin-top:-35px}.hero-image-wrapper{margin-top:-15px}
@media (max-width:992px){
    .hero-section{padding:60px 0;text-align:center}
    .hero-title{font-size:2.5rem; margin-top: 0;}
    .hero-lead, .hero-values { margin-left: auto; margin-right: auto; }
    .hero-actions{justify-content:center;margin-top:25px; flex-direction: column; align-items: center;}
    .hero-actions .btn, .hero-actions .role-dropdown { width: 100%; max-width: 350px; }
    .hero-image-wrapper { margin-top: 20px; }
    .hero-content { margin-top: 0; }
}

@media (max-width: 576px) {
    .hero-title { font-size: 2rem; }
    .hero-section { padding: 40px 0; }
    .hero-actions .btn, .hero-actions .role-dropdown-btn { padding: 12px 20px; font-size: 0.95rem; }
}

/* IMAGE WRAPPER */
.hero-image-wrapper {
    position: relative;
    display: inline-block;
    padding: 20px;
}

/* MAIN IMAGE */
.hero-image {
    max-width: 420px;
    width: 100%;
    border-radius: 24px;
    box-shadow: 
        0 25px 50px rgba(0, 0, 0, 0.15),
        0 10px 20px rgba(0, 0, 0, 0.08);
    transition: transform 0.4s ease, box-shadow 0.4s ease;
}

/* SUBTLE HOVER EFFECT */
.hero-image:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 
        0 35px 60px rgba(0, 0, 0, 0.18),
        0 15px 25px rgba(0, 0, 0, 0.12);
}

/* DECORATIVE BACK CIRCLE */
.hero-image-wrapper::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 300px;
    height: 300px;
    background: radial-gradient(circle, #FB7185, #f43f5e);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    z-index: -1;
    opacity: 0.25;
    filter: blur(40px);
}

/* MOBILE OPTIMIZATION */
@media (max-width: 992px) {
    .hero-image {
        max-width: 300px;
    }

    .hero-image-wrapper::before {
        width: 220px;
        height: 220px;
    }
}

/* Hero image container */
.hero-image-wrapper {
  position: relative;
  margin-top: -10px; /* lifts image slightly */
}

/* Image card effect */
.hero-image-card {
  background: linear-gradient(135deg, #fff5f7, #ffffff);
  padding: 20px;
  border-radius: 24px;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.12);
  transition: transform 0.4s ease, box-shadow 0.4s ease;
}

/* Hover subtle lift */
.hero-image-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 35px 70px rgba(0, 0, 0, 0.15);
}

/* Actual image */
.hero-image {
  width: 100%;
  max-width: 420px;
  height: auto;
  border-radius: 18px;
}

/* Mobile optimization */
@media (max-width: 992px) {
  .hero-image-wrapper {
    margin-top: 0;
  }

  .hero-image {
    max-width: 300px;
  }
}

.services.section {
  background: #fdf6f7;
}

.service-item {
  transition: all 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  transform: perspective(1000px) rotateX(0deg) rotateY(0deg);
}

.service-item:hover {
  transform: perspective(1000px) translateY(-15px) scale(1.03) rotateX(2deg) rotateY(-2deg);
  box-shadow: 0 30px 60px rgba(219, 39, 119, 0.12);
  border-color: rgba(219, 39, 119, 0.3);
  background: #fff;
}

.service-item .icon i {
  transition: transform 0.3s ease;
}

.service-item:hover .icon i {
  transform: scale(1.2);
}

.hover-scale {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
}

/* ===============================
   LIVE + INCLUSIVE SECTIONS
================================ */
.live-strip {
  background: rgba(142, 68, 173, 0.06);
  border: 1px solid rgba(142, 68, 173, 0.12);
  border-radius: 16px;
  padding: 14px;
}

.ticker {
  margin-top: 10px;
  background: rgba(255, 255, 255, 0.65);
  border: 1px solid rgba(142, 68, 173, 0.14);
  border-radius: 16px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}
.ticker-head{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap: 10px;
  padding: 10px 12px;
  border-bottom: 1px solid rgba(142, 68, 173, 0.10);
}
.ticker-title{
  font-weight: 900;
  display:flex;
  align-items:center;
  gap: 8px;
}
.ticker-body{
  overflow:hidden;
  white-space:nowrap;
}
.ticker-track{
  display:inline-flex;
  gap: 14px;
  padding: 10px 12px;
  will-change: transform;
  animation: tickerMove 28s linear infinite;
}
.ticker:hover .ticker-track{ animation-play-state: paused; }
.ticker-chip{
  display:inline-flex;
  align-items:center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(142, 68, 173, 0.08);
  border: 1px solid rgba(142, 68, 173, 0.16);
  font-weight: 800;
  font-size: 0.92rem;
}
.ticker-chip small{
  font-weight: 700;
  color: #6b7280;
}
.animated-text {
  display: block;
  font-size: 2rem;
  font-weight: 600;
  color: #f43f5e;
  animation: slideInTextPremium 1.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
  opacity: 0;
  transform-origin: left;
}
@keyframes slideInTextPremium {
  0% { transform: translateY(30px) scale(0.9); opacity: 0; filter: blur(10px); }
  100% { transform: translateY(0) scale(1); opacity: 1; filter: blur(0); }
}
.floating-anim {
  animation: float 3s ease-in-out infinite;
}
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}
.safety-badge {
   position: absolute;
   top: 10px;
   left: -20px;
   background: #fff;
   padding: 10px 20px;
   border-radius: 50px;
   box-shadow: 0 10px 25px rgba(0,0,0,0.1);
   font-weight: 700;
   color: #f43f5e;
   display: flex;
   align-items: center;
   gap: 8px;
   z-index: 10;
 }

 /* ===============================
     WOMEN ANIMATED DASHBOARD
  ================================ */
  .animated-safety-dashboard {
    background: #fff;
    border-radius: 30px;
    padding: 30px;
    box-shadow: 0 30px 60px rgba(0,0,0,0.12);
    position: relative;
    max-width: 450px;
    margin: 0 auto;
    border: 1px solid rgba(219, 39, 119, 0.1);
  }
 
  .main-visual {
    position: relative;
    height: 300px;
    background: radial-gradient(circle, #1e1b4b, #3F1430);
    border-radius: 20px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 25px;
  }
 
  .woman-central-icon {
    font-size: 80px;
    color: #fff;
    z-index: 10;
    filter: drop-shadow(0 0 15px rgba(255,255,255,0.5));
    animation: central-float 3s ease-in-out infinite;
  }

  @keyframes central-float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
  }
 
  .rotating-circles-container {
    position: absolute;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .dotted-circle {
    position: absolute;
    border-radius: 50%;
    border: 2px dotted rgba(255,255,255,0.3);
    animation: rotate-circle linear infinite;
  }

  .circle-1 { width: 140px; height: 140px; animation-duration: 8s; }
  .circle-2 { width: 200px; height: 200px; animation-duration: 12s; animation-direction: reverse; border-color: rgba(219, 39, 119, 0.4); }
  .circle-3 { width: 260px; height: 260px; animation-duration: 16s; border-color: rgba(255,255,255,0.15); }

  @keyframes rotate-circle {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }

  /* ===============================
     GLOBAL HALO EFFECTS
  ================================ */
  .halo-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: -1;
    overflow: hidden;
  }

  .halo {
    position: absolute;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(219, 39, 119, 0.15), transparent 70%);
    filter: blur(60px);
    animation: halo-float 20s infinite alternate ease-in-out;
  }

  .halo-1 { width: 600px; height: 600px; top: -100px; left: -100px; animation-duration: 25s; }
  .halo-2 { width: 500px; height: 500px; bottom: -100px; right: -100px; background: radial-gradient(circle, rgba(124, 45, 94, 0.15), transparent 70%); animation-duration: 30s; }
  .halo-3 { width: 400px; height: 400px; top: 40%; left: 60%; background: radial-gradient(circle, rgba(251, 113, 133, 0.1), transparent 70%); animation-duration: 20s; }

  @keyframes halo-float {
    0% { transform: translate(0, 0) scale(1); }
    100% { transform: translate(100px, 50px) scale(1.2); }
  }

 .feature-grid-animated {
   display: grid;
   grid-template-columns: 1fr 1fr;
   gap: 15px;
 }

 .feature-item-anim {
   background: #fdf2f8;
   padding: 15px;
   border-radius: 15px;
   text-align: center;
   transition: all 0.3s ease;
   border: 1px solid transparent;
 }

 .feature-item-anim:hover {
   transform: translateY(-5px);
   background: #fff;
   border-color: #f43f5e;
   box-shadow: 0 10px 20px rgba(219, 39, 119, 0.1);
 }

 .feature-item-anim i {
   font-size: 24px;
   color: #1e1b4b;
   margin-bottom: 8px;
   display: block;
 }

 .feature-item-anim span {
   font-size: 13px;
   font-weight: 700;
   color: #3F1430;
   display: block;
 }

 .scan-line {
   position: absolute;
   top: 0;
   left: 0;
   width: 100%;
   height: 2px;
   background: rgba(255,255,255,0.5);
   box-shadow: 0 0 15px rgba(255,255,255,0.8);
   animation: scan 4s linear infinite;
   z-index: 3;
 }

 @keyframes scan {
   0% { top: 0; }
   100% { top: 100%; }
 }

 @keyframes tickerMove{
  0%{ transform: translateX(0); }
  100%{ transform: translateX(-50%); }
}
.live-metric {
  background: #fff;
  border: 1px solid rgba(142, 68, 173, 0.12);
  border-radius: 16px;
  padding: 14px;
  box-shadow: 0 10px 24px rgba(17, 24, 39, 0.06);
}
.live-metric .num {
  font-weight: 900;
  font-size: 1.6rem;
  line-height: 1;
}
.live-metric .label {
  color: #6b7280;
  font-size: 0.9rem;
  margin-top: 6px;
}
.audience-card {
  background: #fff;
  border: 1px solid rgba(142, 68, 173, 0.14);
  border-radius: 18px;
  padding: 18px;
  box-shadow: 0 12px 28px rgba(17, 24, 39, 0.06);
  height: 100%;
}
.audience-card h5 { font-weight: 900; margin-bottom: 6px; }
.audience-card p { color: #6b7280; font-size: 0.95rem; margin-bottom: 12px; }
.audience-pill {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(142, 68, 173, 0.08);
  border: 1px solid rgba(142, 68, 173, 0.16);
  font-weight: 800;
  font-size: 0.85rem;
}
.trust-badge {
  display: flex;
  gap: 10px;
  align-items: center;
  padding: 10px 12px;
  border-radius: 16px;
  background: #fff;
  border: 1px solid rgba(142, 68, 173, 0.12);
}
.trust-badge i { color: #8e44ad; font-size: 1.25rem; }
.cta-band {
  background: linear-gradient(45deg, #1e1b4b, #f43f5e);
  color: #fff;
  border-radius: 18px;
  padding: 20px;
  box-shadow: 0 18px 40px rgba(124, 45, 94, 0.22);
}
.cta-band .btn {
  border-radius: 999px;
  font-weight: 900;
  padding: 10px 16px;
}

/* ===============================
   ROLE DROPDOWN STYLES
================================ */
.role-dropdown {
  position: relative;
  display: inline-block;
}

.role-dropdown-btn {
  background: linear-gradient(135deg, #1e1b4b, #1e1b4b);
  color: #fff;
  border: none;
  padding: 12px 30px;
  border-radius: 50px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(94, 31, 71, 0.35);
}

.role-dropdown-btn:hover {
  background: linear-gradient(135deg, #1e1b4b, #1e1b4b);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(94, 31, 71, 0.45);
}

.role-dropdown-btn .arrow-icon {
  transition: transform 0.3s ease;
  font-size: 0.75rem;
}

.role-dropdown:hover .arrow-icon {
  transform: rotate(180deg);
}

.role-dropdown-menu {
  position: absolute;
  top: calc(100% + 10px);
  left: 0;
  min-width: 280px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
  opacity: 0;
  visibility: hidden;
  transform: translateY(10px);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 1000;
  padding: 10px 0;
  border: 1px solid rgba(142, 68, 173, 0.1);
}

.role-dropdown:hover .role-dropdown-menu {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.role-dropdown-menu::before {
  content: '';
  position: absolute;
  top: -8px;
  left: 30px;
  width: 16px;
  height: 16px;
  background: #fff;
  transform: rotate(45deg);
  border-left: 1px solid rgba(142, 68, 173, 0.1);
  border-top: 1px solid rgba(142, 68, 173, 0.1);
  z-index: 1;
}

.role-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 20px;
  text-decoration: none;
  color: #333;
  transition: all 0.25s ease;
  border-left: 3px solid transparent;
}

.role-item:hover {
  background: linear-gradient(90deg, #f9f0ff, #fff);
  color: #6a0572;
  border-left-color: #8e44ad;
}

.role-item .role-icon {
  width: 38px;
  height: 38px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.1rem;
  flex-shrink: 0;
  transition: transform 0.25s ease;
}

.role-item:hover .role-icon {
  transform: scale(1.1);
}

.role-item .role-info {
  display: flex;
  flex-direction: column;
}

.role-item .role-name {
  font-weight: 700;
  font-size: 0.95rem;
  line-height: 1.2;
}

.role-item .role-desc {
  font-size: 0.75rem;
  color: #888;
  margin-top: 2px;
}

.role-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(142,68,173,0.15), transparent);
  margin: 4px 16px;
}

/* Role icon colors */
.role-icon.user-icon { background: #fff1f8; color: #1e1b4b; }
.role-icon.vendor-icon { background: #e8f5e9; color: #2e7d32; }
.role-icon.centre-icon { background: #fff3e0; color: #e65100; }
.role-icon.product-icon { background: #fff1f8; color: #f43f5e; }
.role-icon.lawyer-icon { background: #e3f2fd; color: #1565c0; }
.role-icon.fitness-icon { background: #f3e5f5; color: #7b1fa2; }

/* Header dropdown - right-aligned */
.header .role-dropdown-menu {
  left: auto;
  right: 0;
}

.header .role-dropdown-menu::before {
  left: auto;
  right: 30px;
}

/* Hero dropdown - larger size */
.hero-actions .role-dropdown-btn {
  padding: 14px 34px;
  font-size: 1.05rem;
}

@media (max-width: 992px) {
  .role-dropdown-menu {
    min-width: 250px;
    position: fixed;
    top: 50% !important;
    left: 50% !important;
    transform: translate(-50%, -50%) !important;
    max-height: 80vh;
    overflow-y: auto;
    width: 90%;
    z-index: 10001;
  }
  .role-dropdown:hover .role-dropdown-menu {
    transform: translate(-50%, -50%) scale(1) !important;
  }
  .role-dropdown-menu::before {
    display: none;
  }
  .hero-actions .role-dropdown {
    width: 100%;
    max-width: 350px;
  }
  .hero-actions .role-dropdown-btn {
    justify-content: center;
    width: 100%;
  }
  #dangerMap {
    height: 350px !important;
  }
  .btn-qna {
    padding: 8px 15px !important;
    font-size: 0.85rem !important;
    margin-right: 10px;
  }
  .role-dropdown-btn {
    padding: 8px 15px !important;
    font-size: 0.85rem !important;
  }
  
  /* 🎯 Mobile Centering Enhancements */
  .section, .about, .hero-section {
    text-align: center !important;
  }
  .about-content ul {
    text-align: left; /* Keep lists readable but center their container */
    display: inline-block;
    max-width: 100%;
    padding-left: 0;
  }
  .about-content ul li {
    display: flex;
    justify-content: center;
    text-align: left;
    margin-bottom: 20px;
  }
  .live-metric, .trust-badge {
    text-align: center;
    justify-content: center;
  }
  .trust-badge {
    flex-direction: column;
    text-align: center;
  }
  .about-content h3 {
    margin-left: auto;
    margin-right: auto;
  }
  .about-content p {
    margin-left: auto;
    margin-right: auto;
  }
  .ticker-head {
    flex-direction: column;
    text-align: center;
    gap: 5px;
  }
}

  /* 🎯 Navbar & Button Alignment Fixes */
  @media (min-width: 992px) {
    #header .container-xl {
      display: flex !important;
      align-items: center !important;
    }
    .navmenu {
      display: flex !important;
      align-items: center !important;
      margin-right: 15px;
    }
    .navmenu ul {
      display: flex !important;
      align-items: center !important;
      margin: 0 !important;
      padding: 0 !important;
    }
  }
  .btn-qna {
    height: 44px;
    display: inline-flex !important;
    align-items: center;
    justify-content: center;
    margin: 0 12px 0 0 !important;
    padding: 0 25px !important;
    font-size: 15px !important;
    white-space: nowrap;
    vertical-align: middle;
  }
  .role-dropdown {
    display: flex !important;
    align-items: center !important;
  }
  .role-dropdown-btn {
    height: 44px; /* Matches Q&A height */
    padding: 0 25px !important;
    font-size: 15px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
  }
  
  @media (max-width: 992px) {
    .header .btn-qna, .header .role-dropdown { display: none !important; }
    .btn-qna { margin-right: 10px !important; padding: 0 15px !important; font-size: 13px !important; height: 38px; }
    .role-dropdown-btn { padding: 0 15px !important; font-size: 13px !important; height: 38px; }
    
    /* 📱 Mobile Centering & Layout Enhancements */
    .section-title h2 { font-size: 2rem; }
    .hero-title { font-size: 2.2rem !important; }
    .hero-lead, .hero-values { font-size: 1rem !important; text-align: center; }
    
    .audience-card { margin-bottom: 15px; }
    
    #dangerMap {
        height: 400px !important; /* Slightly larger on mobile for better visibility */
        margin-top: 20px;
    }
    
    .about-content {
        text-align: center;
        padding-top: 30px;
    }
    .about-content h3 { font-size: 1.8rem; }
    .about-content ul {
        text-align: left;
        display: inline-block;
        padding-left: 0;
    }
    .about-content ul li {
        margin-bottom: 15px;
    }
    
    .faq-item h3 { font-size: 1rem; }
    
    /* 🎯 Better Button Stacking in Hero */
    .hero-actions {
        flex-direction: column;
        width: 100%;
        max-width: 400px;
        margin-left: auto;
        margin-right: auto;
    }
    .hero-actions .role-dropdown, .hero-actions .btn {
        width: 100% !important;
    }
    .hero-actions .role-dropdown-btn {
        width: 100%;
        justify-content: center;
        height: 50px !important;
        font-size: 1rem !important;
    }
  }

  @media (max-width: 576px) {
    .hero-title { font-size: 1.8rem !important; }
    .section-title h2 { font-size: 1.7rem; }
    .audience-card { padding: 15px; }
    .footer-top .row > div { text-align: center; }
    .social-links { justify-content: center; }
  }
  /* ===============================
     ENTIRE PAGE ULTRA PREMIUM ANIMATIONS
  ================================ */
  /* Audience Cards & Stats */
  .audience-card, .live-metric, .trust-badge {
    transition: all 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.8);
    transform: perspective(1000px) rotateX(0deg) rotateY(0deg);
    border-radius: 20px;
    padding: 24px;
    height: 100%;
  }
  .audience-card:hover, .live-metric:hover, .trust-badge:hover {
    transform: perspective(1000px) translateY(-15px) scale(1.03) rotateX(2deg) rotateY(-2deg);
    box-shadow: 0 30px 60px rgba(219, 39, 119, 0.12);
    border-color: rgba(219, 39, 119, 0.3);
    background: #fff;
  }
  
  .audience-pill {
    display: inline-block;
    padding: 6px 16px;
    background: rgba(219, 39, 119, 0.1);
    color: #f43f5e;
    border-radius: 50px;
    font-weight: 600;
    margin-bottom: 15px;
    transition: all 0.3s;
  }
  .audience-card:hover .audience-pill {
    background: #f43f5e;
    color: #fff;
    transform: scale(1.05);
  }

  /* Live Strip / Ticker - Premium Dashboard Style */
  .live-strip {
    background: linear-gradient(135deg, #1f0814, #3a0d24);
    backdrop-filter: blur(25px);
    border-radius: 24px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    border: 1px solid rgba(219, 39, 119, 0.4);
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    padding: 30px;
    color: #fff;
  }
  .live-strip:hover {
    transform: translateY(-5px);
    box-shadow: 0 25px 50px rgba(219, 39, 119, 0.5);
  }
  .live-strip .live-metric {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(219, 39, 119, 0.3);
    color: #fff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
  }
  .live-strip .live-metric .num {
    text-shadow: 0 0 10px rgba(219, 39, 119, 0.8);
  }
  .live-strip .live-metric .label {
    color: #ffb6d9;
  }
  .live-strip .trust-badge {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(219, 39, 119, 0.3);
    color: #fff;
  }
  .live-strip .trust-badge i {
    color: #f43f5e;
    text-shadow: 0 0 10px rgba(219, 39, 119, 0.6);
  }
  .live-strip .ticker {
    background: rgba(0, 0, 0, 0.3);
    border: 1px solid rgba(219, 39, 119, 0.3);
    color: #fff;
  }
  .live-strip .ticker-head {
    border-bottom: 1px solid rgba(219, 39, 119, 0.2);
  }
  .live-strip .ticker-chip {
    background: rgba(219, 39, 119, 0.2);
    border: 1px solid rgba(219, 39, 119, 0.5);
    color: #fff;
  }
  .live-strip .ticker-chip small {
    color: #ffd1e6;
  }
  .live-pulse {
    display: inline-block;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: #ff3e3e;
    box-shadow: 0 0 15px #ff3e3e;
    animation: pulseRed 1.5s infinite;
    margin-right: 8px;
    vertical-align: middle;
  }
  @keyframes pulseRed {
    0% { transform: scale(0.9); opacity: 1; }
    100% { transform: scale(2.5); opacity: 0; }
  }

  /* About Section Cards & Images */
  .about-content ul li {
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    padding: 15px 20px;
    border-radius: 12px;
    border: 1px solid transparent;
  }
  .about-content ul li:hover {
    background: rgba(219, 39, 119, 0.03);
    transform: translateX(15px);
    border-color: rgba(219, 39, 119, 0.1);
    box-shadow: 0 10px 25px rgba(219, 39, 119, 0.08);
  }
  .about-content ul li i {
    transition: transform 0.3s ease;
  }
  .about-content ul li:hover i {
    transform: scale(1.2) rotate(10deg);
  }

  /* Danger Map Section */
  #danger-map .bg-white {
    transition: all 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
    border-radius: 24px;
    border: 1px solid transparent;
  }
  #danger-map .bg-white:hover {
    transform: translateY(-10px);
    box-shadow: 0 25px 50px rgba(219, 39, 119, 0.12);
    border-color: rgba(219, 39, 119, 0.2);
  }

  /* Inputs & Selects */
  .form-select, .form-control {
    transition: all 0.3s ease;
    border-radius: 12px;
  }
  .form-select:focus, .form-control:focus {
    box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.2);
    border-color: #f43f5e;
    transform: translateY(-2px);
  }

  /* Map container */
  #map {
    transition: all 0.5s ease;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
  }
  #map:hover {
    box-shadow: 0 25px 50px rgba(219, 39, 119, 0.2);
    transform: scale(1.02);
  }

  /* Universal Buttons Outline */
  .btn-outline-dark {
    border-radius: 50px;
    transition: all 0.3s ease;
    font-weight: 600;
  }
  .btn-outline-dark:hover {
    background: #f43f5e;
    border-color: #f43f5e;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 10px 20px rgba(219, 39, 119, 0.3);
  }

  /* Section Titles Glow */
  .section-title h2 {
    position: relative;
    display: inline-block;
  }
  .section-title h2::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 60px;
    height: 4px;
    background: linear-gradient(90deg, #1e1b4b, #f43f5e);
    border-radius: 10px;
    transition: width 0.4s ease;
  }
  .section:hover .section-title h2::after {
    width: 120px;
  }
  /* ===============================
     MOVABLE BACKGROUND ELEMENTS
  ================================ */
  #premiumParticleCanvas {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: -2;
      pointer-events: none;
  }
  .orb-background {
      position: fixed;
      inset: 0;
      z-index: -3;
      overflow: hidden;
      pointer-events: none;
      background: linear-gradient(-45deg, #ffffff, #fff2f7, #fdf4f8, #ffffff);
      background-size: 400% 400%;
      animation: silkWave 15s ease infinite;
  }
  @keyframes silkWave {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
  }
  .orb-element {
      position: absolute;
      border-radius: 50%;
      filter: blur(120px);
      opacity: 0.35;
      animation: orbMovementPremium 25s infinite alternate ease-in-out;
  }
  .orb-1 { width: 50vw; height: 50vw; background: rgba(219, 39, 119, 0.2); top: -20vh; right: -10vw; animation-duration: 25s; }
  .orb-2 { width: 40vw; height: 40vw; background: rgba(124, 45, 94, 0.15); bottom: -20vh; left: -15vw; animation-duration: 32s; animation-delay: -6s; }
  .orb-3 { width: 35vw; height: 35vw; background: rgba(251, 113, 133, 0.1); top: 40vh; left: 30vw; animation-duration: 28s; }

  @keyframes orbMovementPremium {
      0% { transform: translate(0, 0) scale(1); }
      50% { transform: translate(12%, 15%) scale(1.15); }
      100% { transform: translate(-8%, -5%) scale(0.9); }
  }

/* ===============================
   THE GUARDIAN SONAR (CREATIVE)
================================ */
.guardian-sonar-wrapper {
  position: relative;
  width: 100%;
  max-width: 450px;
  margin: 0 auto;
  aspect-ratio: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  perspective: 1000px;
}

/* The Core Silhouette */
.guardian-core {
  position: relative;
  z-index: 10;
  width: 120px;
  height: 120px;
  background: linear-gradient(135deg, #f43f5e, #1e1b4b);
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 0 40px rgba(219, 39, 119, 0.6);
  animation: corePulse 3s infinite alternate;
}
.guardian-core i {
  font-size: 60px;
  color: white;
  filter: drop-shadow(0 0 10px rgba(255,255,255,0.8));
}
@keyframes corePulse {
  0% { transform: scale(1); box-shadow: 0 0 30px rgba(219, 39, 119, 0.4); }
  100% { transform: scale(1.05); box-shadow: 0 0 60px rgba(219, 39, 119, 0.8); }
}

/* The Sonar Shield Rings */
.sonar-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  border: 2px solid rgba(219, 39, 119, 0.3);
  pointer-events: none;
}
.sonar-ring-1 { width: 200px; height: 200px; animation: ringExpand 4s infinite linear; }
.sonar-ring-2 { width: 300px; height: 300px; animation: ringExpand 4s infinite linear 1.3s; }
.sonar-ring-3 { width: 400px; height: 400px; animation: ringExpand 4s infinite linear 2.6s; }

@keyframes ringExpand {
  0% { transform: translate(-50%, -50%) scale(0.5); opacity: 1; border-width: 4px; }
  100% { transform: translate(-50%, -50%) scale(1.5); opacity: 0; border-width: 1px; }
}

/* The Sweeping Radar Line */
.radar-sweep {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 200px;
  height: 200px;
  transform-origin: 0 0;
  background: conic-gradient(from 0deg, rgba(219, 39, 119, 0) 70%, rgba(219, 39, 119, 0.4) 100%);
  border-radius: 100% 0 0 0;
  animation: radarSpin 4s infinite linear;
  z-index: 5;
  pointer-events: none;
}
@keyframes radarSpin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Threat Dots (Interactive) */
.threat-dot {
  position: absolute;
  width: 15px;
  height: 15px;
  background: #FF3E3E;
  border-radius: 50%;
  box-shadow: 0 0 15px #FF3E3E;
  z-index: 8;
  transition: all 0.5s ease;
}
.threat-1 { top: 20%; left: 30%; animation: floatThreat 4s infinite alternate; }
.threat-2 { top: 70%; left: 80%; animation: floatThreat 5s infinite alternate-reverse; }
.threat-3 { top: 80%; left: 20%; animation: floatThreat 6s infinite alternate; }

@keyframes floatThreat {
  0% { transform: translateY(0); }
  100% { transform: translateY(-20px); }
}

/* Hover Interaction: Neutralize Threats & SOS Pulse */
.guardian-sonar-wrapper:hover .threat-dot {
  background: #10B981;
  box-shadow: 0 0 20px #10B981;
  transform: scale(0.5);
  opacity: 0;
}
.guardian-sonar-wrapper:hover .guardian-core {
  background: #FF3E3E;
  box-shadow: 0 0 80px rgba(255, 62, 62, 0.9);
  animation: panicCore 0.5s infinite alternate;
}
.guardian-sonar-wrapper:hover .radar-sweep {
  background: conic-gradient(from 0deg, rgba(255, 62, 62, 0) 70%, rgba(255, 62, 62, 0.6) 100%);
  animation-duration: 2s;
}
@keyframes panicCore {
  0% { transform: scale(1); filter: brightness(1); }
  100% { transform: scale(1.1); filter: brightness(1.5); }
}

/* HUD Text */
.guardian-hud {
  position: absolute;
  bottom: 0;
  background: rgba(0,0,0,0.7);
  color: #10B981;
  font-family: monospace;
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid #10B981;
  opacity: 0;
  transition: opacity 0.3s;
  z-index: 15;
}
.guardian-sonar-wrapper:hover .guardian-hud {
  opacity: 1;
}
.hud-text::after {
  content: '|';
  animation: blinkCursor 1s infinite;
}
@keyframes blinkCursor { 50% { opacity: 0; } }

/* Gallery Hover */
.gallery-hover {
  transition: transform 0.4s ease, box-shadow 0.4s ease;
  cursor: pointer;
}
.gallery-hover:hover {
  transform: translateY(-8px) scale(1.03);
  box-shadow: 0 15px 30px rgba(219, 39, 119, 0.2) !important;
}
</style>

</head>

<body class="index-page">
  <!-- Movable Background Orbs & Particles -->
  <div class="orb-background">
      <div class="orb-element orb-1"></div>
      <div class="orb-element orb-2"></div>
      <div class="orb-element orb-3"></div>
  </div>
  <canvas id="premiumParticleCanvas"></canvas>

  <div class="halo-container">
    <div class="halo halo-1"></div>
    <div class="halo halo-2"></div>
    <div class="halo halo-3"></div>
  </div>

  <header id="header" class="header d-flex align-items-center sticky-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">

      <a href="index.html" class="logo d-flex align-items-center me-auto">
        <!-- Uncomment the line below if you also wish to use an image logo -->
        <!-- <img src="assets/img/logo.png" alt=""> -->
        <h1 class="sitename">Fight D Fear</h1>
      </a>

      <nav id="navmenu" class="navmenu">
       <ul>
         
    <li><a href="#hero" class="active">Home</a></li>
    <li><a href="#about">About</a></li>
    <li><a href="#services">Services</a></li>

    <li><a href="#contact">Contact</a></li>
    

      
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>
<a class="btn-qna" href="qna" style="color: white; background-color: var(--primary-coral); border: none; border-radius: 30px; text-decoration: none; font-weight: bold; display: inline-block;">Q&A</a>

      <div class="role-dropdown">
        <c:choose>
          <c:when test="${not empty user || not empty loggedProvider || not empty loggedCentre || not empty loggedDoctor || not empty loggedSalon || not empty loggedStylist || not empty loggedSeller || not empty admin}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/users/dashboard" />
            <c:if test="${not empty loggedProvider}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/marketplace/provider/dashboard" /></c:if>
            <c:if test="${not empty loggedCentre}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/centres/dashboard" /></c:if>
            <c:if test="${not empty loggedDoctor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/doctors/dashboard" /></c:if>
            <c:if test="${not empty loggedSalon}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/salons/dashboard" /></c:if>
            <c:if test="${not empty loggedStylist}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/stylists/dashboard" /></c:if>
            <c:if test="${not empty loggedSeller}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/women-products/seller/dashboard" /></c:if>
            <c:if test="${not empty admin}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/adminDashboard" /></c:if>
            <a href="${dashboardUrl}" class="btn-funky" style="text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
              <i class="bi bi-speedometer2"></i> My Dashboard
            </a>
          </c:when>
          <c:otherwise>
            <button class="role-dropdown-btn" type="button">Get Started <i class="bi bi-chevron-down arrow-icon"></i></button>
            <div class="role-dropdown-menu">
              <a href="${pageContext.request.contextPath}/login" class="role-item"><span class="role-icon user-icon"><i class="bi bi-person-fill"></i></span><span class="role-info"><span class="role-name">User</span><span class="role-desc">Login or register as a user</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon vendor-icon"><i class="bi bi-shop"></i></span><span class="role-info"><span class="role-name">Vendor</span><span class="role-desc">Register or manage your shop</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/centres/login" class="role-item"><span class="role-icon centre-icon"><i class="fa-solid fa-dumbbell"></i></span><span class="role-info"><span class="role-name">Martial Arts Centre</span><span class="role-desc">Register or manage your centre</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/doctors/login" class="role-item"><span class="role-icon doctor-icon"><i class="bi bi-heart-pulse-fill"></i></span><span class="role-info"><span class="role-name">Womens Doctor</span><span class="role-desc">Consult with verified doctors</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/women-products/seller/login" class="role-item"><span class="role-icon product-icon"><i class="bi bi-bag-heart-fill"></i></span><span class="role-info"><span class="role-name">Womens Product</span><span class="role-desc">Explore premium products</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon lawyer-icon"><i class="bi bi-gavel"></i></span><span class="role-info"><span class="role-name">Women Lawyer</span><span class="role-desc">Legal assistance & advocacy</span></span></a><div class="role-divider"></div>
              <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon fitness-icon"><i class="bi bi-activity"></i></span><span class="role-info"><span class="role-name">Fitness Zumba</span><span class="role-desc">Lead empowering fitness sessions</span></span></a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
      
    </div>
  </header>

  <main class="main">

    <!-- Hero Section -->
<!-- Hero Section -->
<section id="hero" class="hero-section">
  <div class="container">
    <div class="row align-items-center gy-5">

      <!-- LEFT CONTENT -->
      <div class="col-lg-6 hero-content" data-aos="fade-up">

        <h1 class="hero-title" data-aos="zoom-in" data-aos-delay="100">
          Fight <span class="text-gradient">D</span> Fear
          <br>
          <span class="animated-text">Protect. Empower. Prevail.</span>
        </h1>

        <p class="hero-lead" data-aos="fade-up" data-aos-delay="200">
          Your Safety, Your Strength, Our Mission.
          <strong>Fight D Fear</strong> is the ultimate companion for women, 
          providing real-time protection and a community that stands together.
        </p>

        <p class="hero-values" data-aos="fade-up" data-aos-delay="300">
          We empower you to be
          <span class="badge rounded-pill bg-danger px-3 py-2">Fearless</span>
          <span class="badge rounded-pill bg-primary px-3 py-2">Confident</span>
          <span class="badge rounded-pill bg-success px-3 py-2">Strong</span>
        </p>

        <div class="hero-actions">
          <c:choose>
            <c:when test="${not empty user || not empty loggedProvider || not empty loggedCentre || not empty loggedDoctor || not empty loggedSalon || not empty loggedStylist || not empty loggedSeller || not empty admin}">
              <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/users/dashboard" />
              <c:if test="${not empty loggedProvider}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/marketplace/provider/dashboard" /></c:if>
              <c:if test="${not empty loggedCentre}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/centres/dashboard" /></c:if>
              <c:if test="${not empty loggedDoctor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/doctors/dashboard" /></c:if>
              <c:if test="${not empty loggedSalon}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/salons/dashboard" /></c:if>
              <c:if test="${not empty loggedStylist}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/stylists/dashboard" /></c:if>
              <c:if test="${not empty loggedSeller}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/women-products/seller/dashboard" /></c:if>
              <c:if test="${not empty admin}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/adminDashboard" /></c:if>
              <a href="${dashboardUrl}" class="btn btn-funky btn-lg d-flex align-items-center gap-2">
                <i class="bi bi-speedometer2"></i> My Dashboard
              </a>
            </c:when>
            <c:otherwise>
              <div class="role-dropdown">
                <button class="role-dropdown-btn btn-funky" type="button"><i class="bi bi-box-arrow-in-right"></i> Get Started <i class="bi bi-chevron-down arrow-icon"></i></button>
                <div class="role-dropdown-menu">
                  <a href="${pageContext.request.contextPath}/login" class="role-item"><span class="role-icon user-icon"><i class="bi bi-person-fill"></i></span><span class="role-info"><span class="role-name">User</span><span class="role-desc">Login or register as a user</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon vendor-icon"><i class="bi bi-shop"></i></span><span class="role-info"><span class="role-name">Vendor</span><span class="role-desc">Register or manage your shop</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/centres/login" class="role-item"><span class="role-icon centre-icon"><i class="fa-solid fa-dumbbell"></i></span><span class="role-info"><span class="role-name">Martial Arts Centre</span><span class="role-desc">Register or manage your centre</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/doctors/login" class="role-item"><span class="role-icon doctor-icon"><i class="bi bi-heart-pulse-fill"></i></span><span class="role-info"><span class="role-name">Womens Doctor</span><span class="role-desc">Consult with verified doctors</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/women-products/seller/login" class="role-item"><span class="role-icon product-icon"><i class="bi bi-bag-heart-fill"></i></span><span class="role-info"><span class="role-name">Womens Product</span><span class="role-desc">Explore premium products</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon lawyer-icon"><i class="bi bi-gavel"></i></span><span class="role-info"><span class="role-name">Women Lawyer</span><span class="role-desc">Legal assistance & advocacy</span></span></a><div class="role-divider"></div>
                  <a href="${pageContext.request.contextPath}/marketplace/provider/login" class="role-item"><span class="role-icon fitness-icon"><i class="bi bi-activity"></i></span><span class="role-info"><span class="role-name">Fitness Zumba</span><span class="role-desc">Lead empowering fitness sessions</span></span></a>
                </div>
              </div>
            </c:otherwise>
          </c:choose>

          <a href="https://www.youtube.com/watch?v=Y7f98aduVJ8"
             class="btn btn-funky-outline btn-lg d-flex align-items-center gap-2">
            <i class="bi bi-play-circle fs-4"></i>
            Watch Video
          </a>
        </div>
      </div>

      <!-- RIGHT IMAGE -->
   <div class="col-lg-6 text-center" 
     data-aos="zoom-out" data-aos-delay="200">

  <div class="guardian-sonar-wrapper" data-aos="zoom-in" data-aos-delay="400">
    <!-- Sonar Rings -->
    <div class="sonar-ring sonar-ring-1"></div>
    <div class="sonar-ring sonar-ring-2"></div>
    <div class="sonar-ring sonar-ring-3"></div>
    
    <!-- Sweeping Radar -->
    <div class="radar-sweep"></div>
    
    <!-- Threats -->
    <div class="threat-dot threat-1"></div>
    <div class="threat-dot threat-2"></div>
    <div class="threat-dot threat-3"></div>
    
    <!-- Core Silhouette -->
    <div class="guardian-core" style="background: transparent; box-shadow: none;">
      <svg viewBox="-60 0 420 500" width="300px" height="350px" style="position: absolute; overflow: visible; z-index: 10; pointer-events: none;" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="neonGlow" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#f43f5e" />
            <stop offset="100%" stop-color="#ff9eb5" />
          </linearGradient>
          <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
            <feGaussianBlur stdDeviation="4" result="blur" />
            <feMerge>
              <feMergeNode in="blur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>
        
        <!-- Outer Shield Rings -->
        <g class="shield-rings" style="animation: corePulse 3s infinite alternate; transform-origin: 150px 250px;">
            <circle cx="150" cy="250" r="180" fill="none" stroke="url(#neonGlow)" stroke-width="1" stroke-dasharray="4 12" opacity="0.5"/>
            <circle cx="150" cy="250" r="210" fill="none" stroke="#C4A747" stroke-width="1.5" stroke-dasharray="2 24" opacity="0.3"/>
            <circle cx="150" cy="250" r="140" fill="none" stroke="#D4A5A5" stroke-width="0.5" opacity="0.2"/>
        </g>

        <!-- Abstract Walking Woman Silhouette (Line Art) -->
        <g stroke="url(#neonGlow)" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" fill="none" filter="url(#glow)" class="guardian-lines">
            <!-- Head -->
            <circle cx="150" cy="110" r="14" fill="url(#neonGlow)" stroke="none"/>
            <!-- Torso / Flowing Dress -->
            <path d="M 150 130 C 130 170, 110 270, 90 350 C 120 370, 180 370, 210 350 C 190 270, 170 170, 150 130 Z"/>
            <!-- Arm (forward) -->
            <path d="M 140 140 C 110 180, 100 220, 105 260"/>
            <!-- Arm (back) -->
            <path d="M 160 140 C 190 160, 200 200, 195 240"/>
            <!-- Leg (forward) -->
            <path d="M 130 350 C 120 400, 115 440, 125 480"/>
            <!-- Leg (back) -->
            <path d="M 170 350 C 180 390, 185 430, 175 470"/>
        </g>
      </svg>
    </div>
    
    <!-- Interactive HUD -->
    <div class="guardian-hud">
      <span class="hud-text">STATUS: SECURE. THREATS NEUTRALIZED.</span>
    </div>
  </div>

</div>

    </div>
  </div>
</section>

 

<!-- /Hero Section -->
 <hr class="purple-line">

<!-- Live + inclusive onboarding -->
<section class="section py-4">
  <div class="container" data-aos="fade-up">
    <div class="live-strip">
      <div class="row g-2 align-items-center">
        <div class="col-12 col-md-4">
          <div class="live-metric">
            <div class="num" id="liveDangerCount">—</div>
            <div class="label">Danger points marked (live)</div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="live-metric">
            <div class="num" id="liveIncidentCount">—</div>
            <div class="label">Incidents reported (live)</div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="trust-badge h-100">
            <i class="bi bi-shield-check"></i>
            <div>
              <div style="font-weight:900;">Verified community</div>
              <div class="small" style="opacity:.9;">Admin verified users, doctors & providers</div>
            </div>
          </div>
        </div>
      </div>

      <div class="ticker" aria-live="polite">
        <div class="ticker-head">
          <div class="ticker-title"><span class="live-pulse"></span> <i class="bi bi-lightning-charge"></i> Live updates</div>
          <div class="small" style="opacity:.85;">Hover to pause</div>
        </div>
        <div class="ticker-body">
          <div class="ticker-track" id="liveActivityTrack">
            <span class="ticker-chip">Loading updates…</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section py-5" style="background:#fff6f8;">
  <div class="container" data-aos="fade-up">
    <div class="text-center mb-4">
      <h2>Built for every age group</h2>
      <p class="lead mb-0">Students, working women, mothers, and seniors — everyone feels supported.</p>
    </div>

    <div class="row g-3">
      <div class="col-md-6 col-lg-3">
        <div class="audience-card">
          <div class="audience-pill"><i class="bi bi-backpack"></i> Students</div>
          <h5 class="mt-3">Campus safety</h5>
          <p>Buddy mode after classes, quick SOS, and safety map awareness.</p>
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/users/dashboard">Go to Dashboard</a>
            </c:when>
            <c:otherwise>
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/users/register">Get started</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="audience-card">
          <div class="audience-pill"><i class="bi bi-briefcase"></i> Working women</div>
          <h5 class="mt-3">Commute support</h5>
          <p>Journey timer, routine reminders, and safe-route suggestions.</p>
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/users/dashboard">Open dashboard</a>
            </c:when>
            <c:otherwise>
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="audience-card">
          <div class="audience-pill"><i class="bi bi-heart-pulse"></i> Mothers</div>
          <h5 class="mt-3">Care + safety</h5>
          <p>Women doctors booking, trusted marketplace, emergency contacts.</p>
          <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/marketplace">Explore services</a>
        </div>
      </div>
      <div class="col-md-6 col-lg-3">
        <div class="audience-card">
          <div class="audience-pill"><i class="bi bi-person-heart"></i> Seniors</div>
          <h5 class="mt-3">Easy access</h5>
          <p>Simple flows, reminders, and quick help options when needed.</p>
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/users/dashboard">Open dashboard</a>
            </c:when>
            <c:otherwise>
              <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</section>
    <!-- About Section -->
<section id="about" class="section about">

  <div class="container">

    <div class="row gy-3">

<div class="col-lg-6 d-flex justify-content-center align-items-center hero-image-wrapper"
     data-aos="zoom-in"
     data-aos-delay="150">

  <div class="hero-image-card">
    <img src="assets/img/assets_task_01jz4xrahqf8er4exr6cx6necz_1751438416_img_1.webp"
         alt="Women Safety App Features"
         class="img-fluid hero-image">
  </div>

</div>


      <div class="col-lg-6 d-flex flex-column justify-content-center" data-aos="fade-up" data-aos-delay="200">
        <div class="about-content ps-0 ps-lg-3">
          <h3>Empowering Women with Advanced <span class="text-gradient">Safety Features</span></h3>
          <p class="fst-italic">
           We're not just building an App - we're creating a Movement. Fight D Fear empowers every Woman to feel Safe, confident, and connected - anytime.  </p>
          <ul>
            <li>
              <i class="bi bi-bell-fill"></i> <!-- Changed to a bell icon for emergency alert -->
              <div>
                <h4>Emergency Alert System</h4>
                <p>Instantly notify emergency contacts or authorities with your location in case of danger.</p>
              </div>
            </li>
            <li>
              <i class="bi bi-geo-alt"></i> <!-- Changed to geo-location icon for Safe Routes -->
              <div>
                <h4>Safe Routes & Location Sharing</h4>
                <p>Share your real-time location with trusted contacts to ensure your Safety while traveling.</p>
              </div>
            </li>
            <li>
              <i class="bi bi-shield-lock"></i> <!-- Changed to shield-lock icon for self-defense -->
              <div>
                <h4>Self-Defense Tips and Resources</h4>
                <p>Access educational content on Self-defense techniques and Safety strategies.</p>
              </div>
            </li>
          </ul>
          <p>
            Our goal is to create a Safer environment for Women by providing tools that help you stay Safe, informed, and connected in any situation. Join us in making the world a Safer place for everyone.
          </p>
        </div>

      </div>
    </div>

  </div>

</section>

<!-- /About Section -->

<!-- Awareness Gallery Section -->
<section id="awareness-gallery" class="section py-5" style="background:#fffcfd;">
  <div class="container" data-aos="fade-up">
    <div class="section-title text-center mb-5">
      <h2>Awareness Gallery</h2>
      <p class="lead mb-0">Empowering visuals that inspire strength, safety, and community support.</p>
    </div>
    <div class="row g-4">
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="100">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_1_1779945093720.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="150">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_2_1779945118958.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="200">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_3_1779945138080.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="250">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_4_1779945164060.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="300">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_5_1779945181656.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="350">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_6_1779945197981.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="400">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_7_1779945218381.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
      <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="450">
        <div class="gallery-item rounded-4 overflow-hidden shadow-sm gallery-hover">
          <img src="assets/img/women_safety_8_1779945239124.png" class="img-fluid w-100" style="aspect-ratio: 1/1; object-fit: cover;" alt="Women Safety Awareness">
        </div>
      </div>
    </div>
  </div>
</section>
<!-- /Awareness Gallery Section -->

    <!-- Services Section -->
  <section id="services" class="services section light-background py-5">
  <!-- Section Title -->
  <div class="container section-title text-center mb-5" data-aos="fade-up">
    <h2 class="mb-3">Our Services</h2>
    <p class="lead">Providing innovative Safety features to ensure the protection and well-being of Women everywhere.</p>
  </div>

  <div class="container">
    <div class="row g-4 justify-content-center">

      <!-- 1. Emergency SOS -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="100">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-bell-fill fs-2 text-danger"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/sos/dashboard" class="stretched-link text-decoration-none">Emergency SOS</a></h5>
          <p class="mb-0 small">Send real-time alerts with your location to emergency contacts or authorities instantly.</p>
        </div>
      </div>

      <!-- 2. Live Location & Routes -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="150">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-geo-alt fs-2 text-primary"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/livelocation" class="stretched-link text-decoration-none">Live Location & Routes</a></h5>
          <p class="mb-0 small">Share your live location & get real-time Safe route suggestions based on surroundings.</p>
        </div>
      </div>

      <!-- 3. Self-Defense Tutorials -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="200">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-shield-lock fs-2 text-success"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/video/allVideos" class="stretched-link text-decoration-none">Self-Defense Tutorials</a></h5>
          <p class="mb-0 small">Explore curated video lessons and tips for basic and advanced Self-defense moves.</p>
        </div>
      </div>

      <!-- 4. 24/7 Helpline -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="250">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-telephone-forward fs-2 text-warning"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/emergency-contacts" class="stretched-link text-decoration-none">24/7 Helpline</a></h5>
          <p class="mb-0 small">Reach out to verified helpline numbers and get immediate support in danger zones.</p>
        </div>
      </div>

      <!-- 5. Panic Button -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="300">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-exclamation-circle fs-2 text-danger"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/panic" class="stretched-link text-decoration-none">Panic Button</a></h5>
          <p class="mb-0 small">One tap to activate all emergency protocols including alert, location, and audio stream.</p>
        </div>
      </div>

      <!-- 6. Incident Reporting -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="550">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="bi bi-exclamation-triangle-fill fs-2 text-danger"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/incidents/report" class="stretched-link text-decoration-none">Incident Reporting</a></h5>
          <p class="mb-0 small">Quickly report harassment, accidents, or suspicious activities with details and location.</p>
        </div>
      </div>

      <!-- 7. Self-Defense Training Centers -->
      <div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="650">
        <div class="service-item text-center p-4 rounded shadow-sm h-100 hover-scale">
          <div class="icon mb-3"><i class="fa-solid fa-dumbbell fs-2 text-success"></i></div>
          <h5 class="mb-2"><a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="stretched-link text-decoration-none">Self-Defense Training</a></h5>
          <p class="mb-0 small">Access verified martial arts centers for self-defense training. Centers register and go live after admin approval, ensuring safety and authenticity for all users.</p>
        </div>
      </div>

    </div>
  </div>
</section>

    <!-- Danger Map Section (Heatmap + Safest Route) -->
    <section id="danger-map" class="section" style="background:#fff6f8;">
      <div class="container" data-aos="fade-up">
        <div class="section-title text-center mb-4">
          <h2>Community Safety Map</h2>
          <p class="lead mb-0">View danger hotspots marked by registered users and find a safer route.</p>
        </div>

        <div class="row gy-4">
          <div class="col-lg-4">
            <div class="p-4 rounded bg-white shadow-sm">
              <h5 class="mb-3">Mark a danger location</h5>

              <!-- Purpose: show login-gated action; backend enforces auth too. -->
              <c:choose>
                <c:when test="${not empty sessionScope.user}">
                  <p class="small text-muted mb-3">Click on the map to pick a location, then submit details.</p>
                  <div class="mb-3">
                    <label class="form-label">Severity</label>
                    <select id="dpSeverity" class="form-select">
                      <option value="1">1 (Low)</option>
                      <option value="2">2</option>
                      <option value="3" selected>3 (Medium)</option>
                      <option value="4">4</option>
                      <option value="5">5 (High)</option>
                    </select>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Category</label>
                    <select id="dpCategory" class="form-select">
                      <option value="general" selected>General</option>
                      <option value="harassment">Harassment</option>
                      <option value="theft">Theft</option>
                      <option value="poorLighting">Poor lighting</option>
                      <option value="stalking">Stalking</option>
                      <option value="unsafeTransport">Unsafe transport</option>
                    </select>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Note (optional)</label>
                    <input id="dpNote" type="text" class="form-control" maxlength="200" placeholder="Short note (avoid personal info)">
                  </div>
                  <button id="dpSubmit" class="btn btn-danger w-100" type="button" disabled>
                    Click map to select location
                  </button>
                  <div id="dpStatus" class="small mt-3 text-muted"></div>
                </c:when>
                <c:otherwise>
                  <p class="small text-muted">Login is required to mark a danger location.</p>
                  <a class="btn btn-outline-dark w-100" href="${pageContext.request.contextPath}/login?redirect=/">
                    Login to mark danger points
                  </a>
                </c:otherwise>
              </c:choose>

              <hr class="my-4">

              <h5 class="mb-3">Find a safer route</h5>
              <p class="small text-muted mb-3">We compare alternative routes and choose the one that avoids hotspots.</p>
              <div class="mb-3">
                <label class="form-label">From</label>
                <input id="routeFrom" type="text" class="form-control" placeholder="Start location">
              </div>
              <div class="mb-3">
                <label class="form-label">To</label>
                <input id="routeTo" type="text" class="form-control" placeholder="Destination">
              </div>
              <div class="mb-3">
                <label class="form-label">Travel mode</label>
                <!-- Purpose: allow safer route selection for walking vs driving. -->
                <select id="routeMode" class="form-select">
                  <option value="DRIVING" selected>Driving</option>
                  <option value="WALKING">Walking</option>
                  <option value="TRANSIT">Transit</option>
                </select>
              </div>
              <button id="routeGo" class="btn btn-primary w-100" type="button">
                Find safest route
              </button>
              <div class="d-flex gap-2 mt-3">
                <button id="toggleHeatmap" class="btn btn-outline-secondary btn-sm" type="button">Toggle heatmap</button>
                <button id="clearRoute" class="btn btn-outline-secondary btn-sm" type="button">Clear route</button>
              </div>
              <div id="routeStatus" class="small mt-3 text-muted"></div>
            </div>
          </div>

          <div class="col-lg-8">
            <!-- Purpose: map container; JS initializes Google Map + heatmap layer. -->
            <div id="dangerMap" class="rounded shadow-sm" style="height:520px; width:100%; background:#eee;"></div>
          </div>
        </div>
      </div>
    </section>



    <!-- Faq Section -->
   <section id="faq" class="faq section light-background">

  <!-- Section Title -->
  <div class="container section-title" data-aos="fade-up">
    <h2>Frequently Asked Questions</h2>
    <p>Find answers to your questions and learn more about how our Women Safety App keeps you safe.</p>
  </div><!-- End Section Title -->

  <div class="container">

    <div class="row">

      <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">

        <div class="faq-container">

          <div class="faq-item">
            <h3>How does the emergency alert system work?</h3>
            <div class="faq-content">
              <p>The emergency alert system allows you to send an instant alert to your emergency contacts or authorities with your live location in case of danger.</p>
            </div>
            <i class="faq-toggle bi bi-bell-fill"></i> <!-- Bell icon for emergency alert -->
          </div><!-- End Faq item-->

          <div class="faq-item">
            <h3>How can I share my location with trusted contacts?</h3>
            <div class="faq-content">
              <p>You can share your live location with trusted contacts, ensuring that they can track your Safety in real-time, especially while traveling.</p>
            </div>
            <i class="faq-toggle bi bi-geo-alt"></i> <!-- Geo-location icon for location sharing -->
          </div><!-- End Faq item-->

          <div class="faq-item">
            <h3>Can I access self-defense tutorials in the app?</h3>
            <div class="faq-content">
              <p>Yes, the app provides access to detailed self-defense tutorials and tips to empower women with the knowledge to protect themselves in risky situations.</p>
            </div>
            <i class="faq-toggle bi bi-shield-lock"></i> <!-- Shield-lock icon for self-defense -->
          </div><!-- End Faq item-->

        </div>

      </div><!-- End Faq Column-->

      <div class="col-lg-6" data-aos="fade-up" data-aos-delay="200">

        <div class="faq-container">

          <div class="faq-item">
            <h3>What should I do in case of an emergency?</h3>
            <div class="faq-content">
              <p>In case of an emergency, you can quickly trigger the alert system, share your location, and reach out to authorities directly from the app for immediate assistance.</p>
            </div>
            <i class="faq-toggle bi bi-telephone-forward"></i> <!-- Telephone icon for helpline -->
          </div><!-- End Faq item-->

          <div class="faq-item">
            <h3>Is the app available 24/7 for emergencies?</h3>
            <div class="faq-content">
              <p>Yes, the app operates 24/7, ensuring that help is always accessible whenever you need it. You can use the emergency alert system or contact helplines anytime.</p>
            </div>
            <i class="faq-toggle bi bi-clock"></i> <!-- Clock icon for 24/7 availability -->
          </div><!-- End Faq item-->

          <div class="faq-item">
            <h3>How can I contact customer support?</h3>
            <div class="faq-content">
              <p>If you need any assistance, you can contact customer support through the app's help section. We provide dedicated support for any issues or inquiries.</p>
            </div>
            <i class="faq-toggle bi bi-chat-dots"></i> <!-- Chat icon for customer support -->
          </div><!-- End Faq item-->

        </div>

      </div><!-- End Faq Column-->

    </div>

  </div>

</section>

    <!-- Contact Section -->
  <section id="contact" class="contact section">

  <!-- Section Title -->
  <div class="container section-title" data-aos="fade-up">
    <h2>Contact</h2>
    <p>For any inquiries or assistance, feel free to reach out to us.</p>
  </div><!-- End Section Title -->

  <div class="container" data-aos="fade-up" data-aos-delay="100">
    
    <div class="row justify-content-center">
      <div class="col-lg-8">

        <!-- Contact Form -->
        <div id="homeAlertContainer"></div>
        <form id="homeContactForm" action="${pageContext.request.contextPath}/sendMessage" method="post">

          <div class="row gy-4">

            <div class="col-md-6">
              <label for="homeContactName" class="pb-2">Your Name</label>
              <input type="text" name="name" id="homeContactName" class="form-control" required>
            </div>

            <div class="col-md-6">
              <label for="homeContactEmail" class="pb-2">Your Email</label>
              <input type="email" class="form-control" name="email" id="homeContactEmail" required>
            </div>

            <div class="col-md-12">
              <label for="homeContactSubject" class="pb-2">Subject</label>
              <input type="text" class="form-control" name="subject" id="homeContactSubject" required>
            </div>

            <div class="col-md-12">
              <label for="homeContactMessage" class="pb-2">Message</label>
              <textarea class="form-control" name="message" rows="6" id="homeContactMessage" required></textarea>
            </div>

            <div class="col-md-12 text-center">
              <button type="submit" id="btnHomeSubmitMessage" class="btn btn-primary rounded-pill px-4 py-2" style="background:#7d265a; border:none;">Send Message</button>
            </div>

          </div>
        </form>
        <!-- End Contact Form -->

      </div>
    </div>

  </div>

</section>
  <!-- /Contact Section -->

  </main>

 <footer id="footer" class="footer position-relative">

   

    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="index.html" class="d-flex align-items-center">
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
            <li><i class="bi bi-chevron-right"></i> <a href="index.html#hero">Home</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="index.html#about">About us</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="index.html#services">Services</a></li>
             <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
              </ul>
        
</a>
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
  <jsp:include page="/WEB-INF/views/fragments/social-follow.jsp" />
</div>


      </div>
    </div>

    <div class="container copyright text-center mt-4">
      <p>© <span>Copyright</span> <strong class="px-1 sitename">Fight D Fear</strong> <span>All Rights Reserved</span></p>
      <div class="credits">
        <!-- All the links in the footer should remain intact. -->
        <!-- You can delete the links only if you've purchased the pro version. -->
        <!-- Licensing information: https://bootstrapmade.com/license/ -->
        <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
       <!--  Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a> -->
      </div>
    </div>

  </footer>

  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Preloader -->
  <div id="preloader"></div>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- <script src="assets/vendor/php-email-form/validate.js"></script> -->
  <script src="assets/vendor/aos/aos.js"></script>
  <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
  <script src="assets/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
  <script src="assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
  <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>

  <!-- Main JS File -->
  <script src="assets/js/main.js"></script>

  <!-- Leaflet JS & Heatmap plugin -->
  <script>
    // Purpose: expose contextPath to the map script.
    window.__APP_CTX__ = "${pageContext.request.contextPath}";
  </script>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
  <script src="https://unpkg.com/leaflet.heat/dist/leaflet-heat.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/danger-map.js"></script>

  <!-- Live counters (safe to fail silently) -->
  <script>
    (function () {
      const ctx = "${pageContext.request.contextPath}";
      const dangerEl = document.getElementById("liveDangerCount");
      const incidentEl = document.getElementById("liveIncidentCount");
      const activityTrack = document.getElementById("liveActivityTrack");

      function animateValue(obj, start, end, duration) {
        if (!obj) return;
        if (start === end) {
          obj.textContent = end;
          return;
        }
        let startTimestamp = null;
        const step = (timestamp) => {
          if (!startTimestamp) startTimestamp = timestamp;
          const progress = Math.min((timestamp - startTimestamp) / duration, 1);
          obj.textContent = Math.floor(progress * (end - start) + start);
          if (progress < 1) {
            window.requestAnimationFrame(step);
          } else {
            obj.textContent = end;
          }
        };
        window.requestAnimationFrame(step);
      }

      function set(el, v) { 
        if (!el) return;
        if (v == null || v === "—") {
          el.textContent = "—";
        } else if (typeof v === 'number' || !isNaN(v)) {
          const targetVal = parseInt(v, 10);
          if (!el.dataset.animated) { 
            animateValue(el, 0, targetVal, 2000); 
            el.dataset.animated = "true";
          } else {
            el.textContent = targetVal;
          }
        } else {
          el.textContent = v;
        }
      }

      function safeText(s) {
        return String(s == null ? "" : s).replace(/\s+/g, " ").trim();
      }

      function timeAgo(createdAt) {
        if (!createdAt) return "just now";
        const t = new Date(createdAt);
        if (Number.isNaN(t.getTime())) return "just now";
        const diffMs = Date.now() - t.getTime();
        const mins = Math.max(0, Math.round(diffMs / 60000));
        if (mins < 1) return "just now";
        if (mins < 60) return mins + "m ago";
        const hrs = Math.round(mins / 60);
        if (hrs < 24) return hrs + "h ago";
        const days = Math.round(hrs / 24);
        return days + "d ago";
      }

      function renderActivity(points) {
        if (!activityTrack) return;
        let content = '';
        if (!Array.isArray(points) || points.length === 0) {
          content = '<span class="ticker-chip"><i class="bi bi-shield-check text-success" style="margin-right: 5px;"></i> <strong>SYSTEM ACTIVE</strong> <small>Monitoring safety signals...</small></span>' + 
                    '<span class="ticker-chip"><i class="bi bi-geo-alt text-primary" style="margin-right: 5px;"></i> <strong>Safe Routes</strong> <small>Live tracking enabled</small></span>' + 
                    '<span class="ticker-chip"><i class="bi bi-people text-info" style="margin-right: 5px;"></i> <strong>Community</strong> <small>2,400+ volunteers on standby</small></span>';
        } else {
          content = points.slice(0, 8).map(p => {
            const cat = safeText(p.category || "Alert");
            const sev = safeText(p.severity);
            const note = safeText(p.note);
            const when = timeAgo(p.createdAt || p.created_at || p.created);
            const main = [cat, sev ? ("S" + sev) : ""].filter(Boolean).join(" • ");
            const tail = note ? (" — " + note) : "";
            return `<span class="ticker-chip"><strong>${main}</strong><small>${when}${tail}</small></span>`;
          }).join("");
        }

        // Duplicate the content so CSS can loop smoothly.
        activityTrack.innerHTML = content + content + content;
      }

      async function refresh() {
        try {
          const dRes = await fetch(ctx + "/danger-points", { headers: { "Accept": "application/json" } });
          if (dRes.ok) {
            const arr = await dRes.json();
            set(dangerEl, Array.isArray(arr) ? arr.length : "—");
            if (Array.isArray(arr)) renderActivity(arr);
          }
        } catch (e) {}

        try {
          const iRes = await fetch(ctx + "/incidents/listForUser.meta", { headers: { "Accept": "application/json" } });
          if (iRes.ok) {
            const meta = await iRes.json();
            set(incidentEl, meta && meta.count);
          }
        } catch (e) {}
      }

      refresh();
      setInterval(refresh, 10000);
    })();
  </script>

  <script>
    (function() {
      const form = document.getElementById("homeContactForm");
      if (form) {
        form.addEventListener("submit", function(e) {
          e.preventDefault();
          const btn = document.getElementById("btnHomeSubmitMessage");
          const alertContainer = document.getElementById("homeAlertContainer");
          
          btn.disabled = true;
          btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Sending...';
          alertContainer.innerHTML = '';

          const params = new URLSearchParams();
          params.append("name", document.getElementById("homeContactName").value);
          params.append("email", document.getElementById("homeContactEmail").value);
          params.append("subject", document.getElementById("homeContactSubject").value);
          params.append("message", document.getElementById("homeContactMessage").value);

          fetch(this.action, {
              method: "POST",
              headers: {
                  "Content-Type": "application/x-www-form-urlencoded",
                  "X-Requested-With": "XMLHttpRequest"
              },
              body: params.toString()
          })
          .then(async response => {
              const text = await response.text();
              if (response.ok) {
                  alertContainer.innerHTML = `
                      <div class="alert alert-success alert-dismissible fade show rounded-4" role="alert" style="margin-bottom: 20px;">
                          <i class="bi bi-check-circle-fill me-2"></i> \${text === "OK" ? "Your message has been sent successfully!" : text}
                          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                      </div>
                  `;
                  form.reset();
              } else {
                  alertContainer.innerHTML = `
                      <div class="alert alert-danger alert-dismissible fade show rounded-4" role="alert" style="margin-bottom: 20px;">
                          <i class="bi bi-exclamation-triangle-fill me-2"></i> \${text}
                          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                      </div>
                  `;
              }
          })
          .catch(err => {
              alertContainer.innerHTML = `
                  <div class="alert alert-danger alert-dismissible fade show rounded-4" role="alert" style="margin-bottom: 20px;">
                      <i class="bi bi-exclamation-triangle-fill me-2"></i> Failed to send message. Please try again.
                      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>
              `;
          })
          .finally(() => {
              btn.disabled = false;
              btn.innerText = "Send Message";
          });
        });
      }
    })();
  </script>

  <!-- Premium Canvas Particle JS -->
  <script>
    document.addEventListener("DOMContentLoaded", function() {
        const canvas = document.getElementById('premiumParticleCanvas');
        if(!canvas) return;
        const ctx = canvas.getContext('2d');
        let width, height, particles;

        function initCanvas() {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
            particles = [];
            const numParticles = window.innerWidth > 768 ? 35 : 15;
            const symbols = ['♀', '🌸', '✨'];
            
            for(let i=0; i<numParticles; i++) {
                particles.push({
                    x: Math.random() * width,
                    y: Math.random() * height,
                    vx: (Math.random() - 0.5) * 0.5,
                    vy: (Math.random() - 0.5) * 0.5,
                    radius: Math.random() * 2 + 1,
                    symbol: symbols[Math.floor(Math.random() * symbols.length)]
                });
            }
        }

        function drawCanvas() {
            ctx.clearRect(0, 0, width, height);
            
            particles.forEach((p, i) => {
                p.x += p.vx;
                p.y += p.vy;
                
                if(p.x < 0 || p.x > width) p.vx *= -1;
                if(p.y < 0 || p.y > height) p.vy *= -1;
                
                // Draw women-empowerment symbols instead of plain circles
                ctx.font = (p.radius * 8) + "px Arial";
                ctx.fillStyle = 'rgba(219, 39, 119, 0.35)';
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';
                ctx.fillText(p.symbol, p.x, p.y);
                
                // Connect nearby particles to show networking/community
                for(let j=i+1; j<particles.length; j++) {
                    const p2 = particles[j];
                    const dist = Math.hypot(p.x - p2.x, p.y - p2.y);
                    
                    if(dist < 160) {
                        ctx.beginPath();
                        ctx.moveTo(p.x, p.y);
                        ctx.lineTo(p2.x, p2.y);
                        ctx.strokeStyle = `rgba(219, 39, 119, ${(160 - dist) / 160 * 0.12})`;
                        ctx.stroke();
                    }
                }
            });
            
            requestAnimationFrame(drawCanvas);
        }

        window.addEventListener('resize', initCanvas);
        initCanvas();
        drawCanvas();
    });
  </script>
</body>

</html>

