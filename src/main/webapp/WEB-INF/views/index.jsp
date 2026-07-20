<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Fight D Fear - Empowering Women</title>
  
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
      background: linear-gradient(-45deg, #f8fafc, #ffe4e6, #e0e7ff, #f8fafc);
      background-size: 400% 400%;
      animation: gradientBG 20s ease infinite;
      color: var(--text-dark);
      overflow-x: hidden;
    }
    
    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* ===== PREMIUM NAVBAR ===== */
    .header-nav {
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      padding: 8px 0;
      box-shadow: 0 4px 30px rgba(0, 0, 0, 0.06);
      border-bottom: 1px solid rgba(255, 255, 255, 0.3);
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
      color: var(--text-dark);
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
      background: rgba(244, 63, 94, 0.08);
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

    /* ===== HERO VIDEO SECTION ===== */
    .hero-video-section {
      height: 85vh;
      display: flex;
      align-items: center;
      position: relative;
      overflow: hidden;
      background: var(--navy-dark);
    }
    .hero-video-side {
      position: absolute;
      top: 0;
      width: 50%;
      height: 100%;
      overflow: hidden;
      z-index: 0;
    }
    .hero-video-side.left-side {
      left: 0;
    }
    .hero-video-side.right-side {
      right: 0;
    }
    .hero-video-bg-blurred-el {
      width: 100%;
      height: 100%;
      object-fit: cover;
      object-position: 10% center; /* Focuses on the golden spark side of the vertical video, hiding the woman silhouette */
      opacity: 0.55;
      filter: blur(2px) brightness(0.65) saturate(1.25);
    }
    .hero-video-side.right-side .hero-video-bg-blurred-el {
      transform: scaleX(-1); /* Flips/mirrors the right-side video so particles glow on both side margins symmetrically! */
      object-position: 10% center;
    }
    .hero-video-bg {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      height: 100%;
      max-width: 100%;
      object-fit: contain;
      z-index: 2;
      opacity: 1.0;
      /* Soft fade on left/right borders to make the vertical video blend seamlessly with the sides (removes straight lines) */
      -webkit-mask-image: linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12%, rgba(0, 0, 0, 1) 88%, rgba(0, 0, 0, 0) 100%);
      mask-image: linear-gradient(to right, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 1) 12%, rgba(0, 0, 0, 1) 88%, rgba(0, 0, 0, 0) 100%);
    }
    .hero-video-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to bottom, rgba(0, 0, 0, 0.05) 0%, rgba(0, 0, 0, 0.3) 100%);
      z-index: 1;
    }
    .hero-video-content-wrap {
      position: relative;
      z-index: 3;
      width: 100%;
      height: 85vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    /* Mute/volume toggle button */
    .hero-mute-btn {
      position: absolute;
      bottom: 30px;
      right: 30px;
      z-index: 10;
      background: rgba(255,255,255,0.2);
      border: 1px solid rgba(255,255,255,0.4);
      backdrop-filter: blur(12px);
      color: white;
      border-radius: 50%;
      width: 46px;
      height: 46px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 1.1rem;
    }
    .hero-mute-btn:hover {
      background: var(--primary);
      border-color: var(--primary);
      transform: scale(1.1);
    }
    /* Scroll-down indicator */
    .hero-scroll-indicator {
      position: absolute;
      bottom: 30px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 10;
      color: rgba(255,255,255,0.8);
      font-size: 0.75rem;
      letter-spacing: 1px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
      animation: bounce 2s infinite;
      text-shadow: 0 1px 4px rgba(0,0,0,0.5);
    }
    .hero-scroll-indicator i { font-size: 1.2rem; }
    @keyframes bounce {
      0%, 100% { transform: translateX(-50%) translateY(0); }
      50% { transform: translateX(-50%) translateY(8px); }
    }

    /* ===== RESPONSIVE HERO VIDEO ===== */
    @media (max-width: 768px) {
      .hero-video-section { height: 65vh; }
      .hero-video-content-wrap { height: 65vh; }
      .hero-video-side {
        display: none !important;
      }
      .hero-video-bg {
        top: 0 !important;
        left: 0 !important;
        transform: none !important;
        width: 100% !important;
        height: 100% !important;
        object-fit: cover !important;
        -webkit-mask-image: none !important;
        mask-image: none !important;
      }
    }
    @media (max-width: 575px) {
      .hero-video-section { height: 55vh; }
      .hero-video-content-wrap { height: 55vh; }
    }

    /* ===== PLATFORM WELCOME & SOS SECTION ===== */
    .welcome-emergency-section {
      background: #ffffff;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
      padding: 60px 0;
    }
    .welcome-badge {
      background: rgba(244, 63, 94, 0.08);
      color: var(--primary);
      padding: 6px 18px;
      font-size: 0.8rem;
      font-weight: 600;
      border-radius: 50px;
      letter-spacing: 1px;
    }
    .welcome-title {
      font-size: 2.8rem;
      font-weight: 800;
      color: var(--navy-dark);
      line-height: 1.2;
    }
    .text-primary-rose {
      color: var(--primary);
    }
    .welcome-text {
      font-size: 1.05rem;
      line-height: 1.7;
    }
    .btn-outline-rose {
      border: 2px solid var(--primary);
      color: var(--primary);
      transition: all 0.3s ease;
      background: transparent;
    }
    .btn-outline-rose:hover {
      background: var(--primary);
      color: white;
    }
    .btn-light-rose {
      background: rgba(244, 63, 94, 0.05);
      color: var(--primary);
      border: 1px solid rgba(244, 63, 94, 0.1);
      transition: all 0.3s ease;
    }
    .btn-light-rose:hover {
      background: rgba(244, 63, 94, 0.1);
      color: var(--primary-hover);
    }
    .sos-interactive-card {
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .sos-interactive-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(244, 63, 94, 0.08) !important;
    }
    .sos-circle-trigger {
      width: 120px;
      height: 120px;
      background: linear-gradient(145deg, var(--primary), var(--primary-hover));
      border-radius: 50%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: white;
      cursor: pointer;
      box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.6);
      animation: pulse-sos 1.8s infinite cubic-bezier(0.66, 0, 0, 1);
      transition: all 0.3s ease;
    }
    .sos-circle-trigger:hover {
      transform: scale(1.05);
    }
    .sos-circle-trigger h3 {
      font-size: 24px;
      font-weight: 800;
      margin: 0;
      letter-spacing: 1px;
    }
    .sos-circle-trigger span {
      font-size: 10px;
      font-weight: 500;
      text-transform: uppercase;
      opacity: 0.8;
      margin-top: 2px;
    }
    @keyframes pulse-sos {
      0% {
        box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.6);
      }
      70% {
        box-shadow: 0 0 0 20px rgba(244, 63, 94, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(244, 63, 94, 0);
      }
    }

    @media (max-width: 991px) {
      .welcome-title { font-size: 2.2rem; }
    }
    @media (max-width: 575px) {
      .welcome-title { font-size: 1.8rem; }
      .welcome-text { font-size: 0.95rem; }
    }

    .sos-circle-center {
      width: 140px;
      height: 140px;
      background: linear-gradient(145deg, var(--primary), var(--primary-hover));
      border-radius: 50%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
      text-align: center;
      box-shadow: 0 0 0 15px rgba(244, 63, 94, 0.25), 0 0 60px rgba(244, 63, 94, 0.4);
      animation: pulseSOSGlobe 2.5s infinite;
      cursor: pointer;
      transition: all 0.3s ease;
      margin: 20px auto 0;
    }
    .sos-circle-center:hover {
      transform: scale(1.08);
      box-shadow: 0 0 0 20px rgba(244, 63, 94, 0.3), 0 0 80px rgba(244, 63, 94, 0.5);
    }
    .sos-circle-center h3 { margin: 0; font-size: 30px; font-weight: 900; letter-spacing: 2px; }
    .sos-circle-center span { font-size: 12px; font-weight: 500; opacity: 0.9; text-transform: uppercase; letter-spacing: 1px; }
    
    @keyframes pulseSOSGlobe {
      0% { box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.5), 0 0 60px rgba(244, 63, 94, 0.3); }
      70% { box-shadow: 0 0 0 25px rgba(244, 63, 94, 0), 0 0 80px rgba(244, 63, 94, 0.1); }
      100% { box-shadow: 0 0 0 0 rgba(244, 63, 94, 0), 0 0 60px rgba(244, 63, 94, 0.3); }
    }

    .section-title {
      text-align: center;
      font-weight: 700;
      color: var(--navy-dark);
      margin-bottom: 50px;
      position: relative;
    }
    .section-title::after {
      content: '';
      position: absolute;
      bottom: -15px;
      left: 50%;
      transform: translateX(-50%);
      width: 50px;
      height: 3px;
      background: var(--primary);
    }

    /* ===== AWARENESS SECTION ===== */
    .awareness-section {
      padding: 100px 0;
      background: var(--bg-light);
    }
    .awareness-block {
      margin-bottom: 80px;
    }
    .awareness-block:last-child {
      margin-bottom: 0;
    }
    .awareness-img {
      border-radius: 20px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.1);
      transition: transform 0.4s;
      width: 100%;
      height: 400px;
      object-fit: cover;
    }
    .awareness-img:hover {
      transform: translateY(-10px);
    }
    .awareness-text {
      padding: 30px;
    }
    .awareness-text h3 {
      font-weight: 700;
      color: var(--navy-dark);
      margin-bottom: 20px;
      font-size: 2.2rem;
    }
    .awareness-text p {
      font-size: 1.1rem;
      color: var(--text-gray);
      line-height: 1.8;
      margin-bottom: 20px;
    }

    /* ===== FEATURES SECTION - 9 MODULES ===== */
    .features-section {
      padding: 100px 0;
      background: linear-gradient(180deg, #ffffff 0%, var(--bg-light) 100%);
      position: relative;
    }
    .features-section::before {
      content: '';
      position: absolute;
      top: -100px;
      right: -50px;
      width: 400px;
      height: 400px;
      background: radial-gradient(circle, rgba(244, 63, 94, 0.04) 0%, transparent 70%);
      border-radius: 50%;
      z-index: 0;
      pointer-events: none;
    }
    .features-section .container {
      position: relative;
      z-index: 1;
    }
    
    .feature-module-card {
      background: white;
      padding: 35px 25px;
      border-radius: 24px;
      text-align: center;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.03);
      border: 1px solid rgba(0, 0, 0, 0.02);
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
      height: 100%;
      position: relative;
      overflow: hidden;
    }
    .feature-module-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--primary), #fb7185);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.5s ease;
    }
    .feature-module-card:hover::before {
      transform: scaleX(1);
    }
    .feature-module-card:hover {
      transform: translateY(-12px);
      box-shadow: 0 30px 60px rgba(244, 63, 94, 0.08);
      border-color: rgba(244, 63, 94, 0.1);
    }
    
    .feature-module-icon {
      width: 75px;
      height: 75px;
      background: rgba(244, 63, 94, 0.08);
      border-radius: 20px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 30px;
      color: var(--primary);
      margin-bottom: 18px;
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    }
    .feature-module-card:hover .feature-module-icon {
      background: var(--primary);
      color: white;
      transform: scale(1.1) rotate(-4deg);
      box-shadow: 0 15px 30px rgba(244, 63, 94, 0.2);
    }
    
    .feature-module-card .module-number {
      display: inline-block;
      background: rgba(244, 63, 94, 0.06);
      color: var(--primary);
      font-size: 0.65rem;
      font-weight: 700;
      padding: 2px 12px;
      border-radius: 20px;
      letter-spacing: 0.5px;
      margin-bottom: 8px;
    }
    
    .feature-module-card h4 {
      font-size: 1.15rem;
      font-weight: 700;
      color: var(--navy-dark);
      margin-bottom: 8px;
    }
    .feature-module-card p {
      color: var(--text-gray);
      font-size: 0.85rem;
      line-height: 1.6;
      margin: 0;
    }
    
    .feature-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 5px;
      justify-content: center;
      margin-top: 12px;
    }
    .feature-tags span {
      background: rgba(244, 63, 94, 0.06);
      color: var(--text-gray);
      font-size: 0.6rem;
      padding: 3px 10px;
      border-radius: 12px;
      font-weight: 500;
    }
    .feature-tags span:hover {
      background: var(--primary);
      color: white;
      cursor: default;
    }

    /* ===== HOW IT WORKS ===== */
    .how-it-works-section {
      padding: 100px 0;
      background: linear-gradient(180deg, #ffffff 0%, var(--bg-light) 100%);
      overflow: hidden;
    }
    .how-it-works-section .section-badge {
      display: inline-block;
      background: rgba(244, 63, 94, 0.08);
      color: var(--primary);
      font-weight: 600;
      font-size: 0.75rem;
      padding: 6px 20px;
      border-radius: 50px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      margin-bottom: 10px;
    }
    .how-it-works-section .section-title-custom {
      font-weight: 800;
      font-size: 2.8rem;
      color: var(--navy-dark);
      margin-bottom: 10px;
      letter-spacing: -0.02em;
    }
    .how-it-works-section .section-sub {
      color: var(--text-gray);
      font-size: 1.1rem;
      margin-bottom: 40px;
    }

    .step-wrapper {
      position: relative;
      padding-left: 70px;
      margin-bottom: 35px;
      transition: all 0.4s ease;
      border-left: 3px solid transparent;
      padding-bottom: 5px;
    }
    .step-wrapper:last-child {
      margin-bottom: 0;
    }
    .step-wrapper:hover {
      transform: translateX(8px);
      border-left-color: var(--primary);
    }
    .step-icon-circle {
      position: absolute;
      left: 0;
      top: 0;
      width: 50px;
      height: 50px;
      background: rgba(244, 63, 94, 0.08);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.3rem;
      color: var(--primary);
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
      border: 2px solid rgba(244, 63, 94, 0.1);
    }
    .step-wrapper:hover .step-icon-circle {
      background: var(--primary);
      color: white;
      transform: scale(1.1) rotate(10deg);
      box-shadow: 0 10px 30px rgba(244, 63, 94, 0.2);
      border-color: var(--primary);
    }
    .step-wrapper .step-icon {
      font-size: 1.3rem;
    }
    .step-wrapper h4 {
      font-weight: 700;
      font-size: 1.3rem;
      color: var(--navy-dark);
      margin-bottom: 6px;
    }
    .step-wrapper p {
      color: var(--text-gray);
      font-size: 0.95rem;
      line-height: 1.7;
      max-width: 500px;
      margin-bottom: 0;
    }

    .how-it-works-image {
      position: relative;
      border-radius: 24px;
      overflow: hidden;
      box-shadow: 0 30px 60px rgba(0, 0, 0, 0.1);
      transition: all 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
    }
    .how-it-works-image:hover {
      transform: scale(1.02) translateY(-10px);
      box-shadow: 0 40px 80px rgba(244, 63, 94, 0.15);
    }
    .how-it-works-image img {
      width: 100%;
      height: 600px;
      object-fit: cover;
      transition: all 0.6s ease;
    }
    .how-it-works-image:hover img {
      transform: scale(1.05);
    }
    .how-it-works-image .image-overlay {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      padding: 40px;
      background: linear-gradient(transparent, rgba(30, 27, 75, 0.8));
      color: white;
    }
    .how-it-works-image .image-overlay h3 {
      font-weight: 700;
      font-size: 1.5rem;
      margin-bottom: 5px;
    }
    .how-it-works-image .image-overlay p {
      opacity: 0.9;
      font-size: 0.95rem;
    }

    /* Emergency Services */
    .emergency-section { padding: 100px 0; background: white; }
    .emergency-card {
      background: white;
      border: 1px solid rgba(0, 0, 0, 0.04);
      border-radius: 20px;
      padding: 25px;
      display: flex;
      align-items: center;
      gap: 20px;
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
      box-shadow: 0 10px 30px rgba(0,0,0,0.02);
    }
    .emergency-card:hover {
      border-color: var(--primary);
      box-shadow: 0 20px 40px rgba(244, 63, 94, 0.15);
      transform: translateY(-8px);
    }
    .em-icon { width: 65px; height: 65px; background: rgba(244, 63, 94, 0.08); border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 28px; color: var(--primary); transition: all 0.4s ease; }
    .emergency-card:hover .em-icon { background: var(--primary); color: white; transform: rotate(10deg); box-shadow: 0 10px 20px rgba(244, 63, 94, 0.3); }
    .em-details h5 { font-size: 14px; color: var(--text-gray); margin: 0; font-weight: 500; }
    .em-details h3 { font-size: 26px; font-weight: 800; color: var(--navy-dark); margin: 5px 0; letter-spacing: -0.5px; }
    .em-btn { background: rgba(244, 63, 94, 0.1); color: var(--primary); border: none; padding: 6px 18px; border-radius: 20px; font-size: 13px; font-weight: 700; transition: all 0.3s; }
    .emergency-card:hover .em-btn { background: var(--primary); color: white; }

    /* Map Section */
    .map-section { padding: 100px 0; background: var(--bg-light); }
    .map-container { border-radius: 24px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.1); border: 4px solid white; }
    .map-tag { padding: 8px 18px; border-radius: 25px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; transition: all 0.3s; cursor: pointer; }
    .map-tag:hover { transform: translateY(-3px); }
    .tag-high { background: rgba(244, 63, 94, 0.1); color: var(--primary); }
    .tag-high:hover { background: var(--primary); color: white; box-shadow: 0 10px 20px rgba(244, 63, 94, 0.3); }
    .tag-med { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
    .tag-med:hover { background: #f59e0b; color: white; box-shadow: 0 10px 20px rgba(245, 158, 11, 0.3); }
    .tag-safe { background: rgba(16, 185, 129, 0.1); color: #10b981; }
    .tag-safe:hover { background: #10b981; color: white; box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3); }

    /* Stats Banner */
    .stats-banner {
      background: linear-gradient(135deg, var(--navy-dark) 0%, var(--navy-light) 100%);
      padding: 50px 0;
      color: white;
      border-radius: 24px;
      margin: 60px auto;
      box-shadow: 0 30px 60px rgba(30, 27, 75, 0.2);
      position: relative;
      overflow: hidden;
    }
    .stats-banner::after { content: ''; position: absolute; top: -50%; right: -10%; width: 50%; height: 200%; background: radial-gradient(circle, rgba(244, 63, 94, 0.15) 0%, transparent 60%); pointer-events: none; }
    .stat-item { display: flex; align-items: center; justify-content: center; gap: 15px; transition: transform 0.3s; }
    .stat-item:hover { transform: translateY(-5px); }
    .stat-icon { font-size: 36px; color: var(--primary); filter: drop-shadow(0 0 15px rgba(244, 63, 94, 0.4)); }
    .stat-details h3 { font-size: 32px; font-weight: 800; margin: 0; letter-spacing: -1px; }
    .stat-details p { font-size: 13px; font-weight: 500; margin: 0; opacity: 0.8; letter-spacing: 1px; text-transform: uppercase; }

    /* Testimonials */
    .testimonial-card {
      background: white;
      padding: 40px 30px;
      border-radius: 20px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.03);
      border: 1px solid rgba(0,0,0,0.02);
      border-bottom: 4px solid transparent;
      height: 100%;
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    }
    .testimonial-card:hover {
      transform: translateY(-10px);
      box-shadow: 0 20px 40px rgba(244, 63, 94, 0.12);
      border-bottom: 4px solid var(--primary);
    }
    .user-info { display: flex; align-items: center; gap: 15px; margin-bottom: 20px; }
    .user-info img { width: 55px; height: 55px; border-radius: 50%; object-fit: cover; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    .stars { color: #f59e0b; font-size: 13px; }

    /* CTA Section */
    .cta-section {
      background: linear-gradient(135deg, rgba(244,63,94,0.08), rgba(49,46,129,0.08));
      border-radius: 30px;
      padding: 80px 50px;
      margin: 100px auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border: 1px solid rgba(255,255,255,0.5);
      box-shadow: 0 30px 60px rgba(0,0,0,0.05);
    }
    .cta-section img { transition: transform 0.5s cubic-bezier(0.165, 0.84, 0.44, 1); }
    .cta-section:hover img { transform: translateY(-15px) scale(1.05); }
    .app-btns img { height: 45px; margin-right: 15px; transition: transform 0.3s; }
    .app-btns img:hover { transform: translateY(-5px); }

    /* Footer */
    .footer {
      background: var(--navy-dark);
      color: white;
      padding: 80px 0 30px;
      position: relative;
      overflow: hidden;
    }
    .footer::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--navy-dark), var(--primary), var(--navy-dark)); }
    .footer h5 { font-size: 18px; font-weight: 700; margin-bottom: 25px; color: white; }
    .footer ul { list-style: none; padding: 0; margin: 0; }
    .footer ul li { margin-bottom: 12px; }
    .footer ul li a { color: #94a3b8; font-size: 14.5px; transition: all 0.3s; display: inline-block; }
    .footer ul li a:hover { color: var(--primary); transform: translateX(5px); }
    .footer-logo { display: flex; align-items: center; gap: 10px; font-size: 22px; font-weight: 800; margin-bottom: 20px; }
    .social-links a { color: white; width: 40px; height: 40px; background: rgba(255,255,255,0.05); display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; margin-right: 12px; transition: all 0.3s; }
    .social-links a:hover { background: var(--primary); transform: translateY(-5px) scale(1.1); box-shadow: 0 10px 20px rgba(244, 63, 94, 0.3); }
    .newsletter-input { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: white; padding: 12px 20px; border-radius: 8px; width: 100%; margin-bottom: 15px; transition: border-color 0.3s; }
    .newsletter-input:focus { outline: none; border-color: var(--primary); background: rgba(255,255,255,0.1); }
    .newsletter-btn { background: var(--primary); color: white; border: none; padding: 12px; width: 100%; border-radius: 8px; font-weight: 700; transition: all 0.3s; }
    .newsletter-btn:hover { background: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 10px 20px rgba(244, 63, 94, 0.2); }
    
    .copyright { text-align: center; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 25px; margin-top: 50px; font-size: 14px; color: #64748b; }

    /* ===== MOBILE NAV OFFCANVAS ===== */
    .mobile-menu-toggle {
      display: none;
      background: none;
      border: 2px solid var(--primary);
      color: var(--primary);
      font-size: 1.4rem;
      width: 44px;
      height: 44px;
      border-radius: 12px;
      cursor: pointer;
      transition: all 0.3s ease;
      align-items: center;
      justify-content: center;
    }
    .mobile-menu-toggle:hover {
      background: var(--primary);
      color: white;
    }
    .mobile-nav-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1998;
      opacity: 0;
      transition: opacity 0.3s ease;
    }
    .mobile-nav-overlay.active {
      display: block;
      opacity: 1;
    }
    .mobile-nav-drawer {
      position: fixed;
      top: 0;
      right: -320px;
      width: 300px;
      max-width: 85vw;
      height: 100vh;
      background: white;
      z-index: 1999;
      transition: right 0.35s cubic-bezier(0.4, 0, 0.2, 1);
      overflow-y: auto;
      box-shadow: -10px 0 40px rgba(0,0,0,0.15);
    }
    .mobile-nav-drawer.active {
      right: 0;
    }
    .mobile-nav-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px;
      border-bottom: 1px solid #f1f5f9;
    }
    .mobile-nav-close {
      background: none;
      border: none;
      font-size: 1.5rem;
      color: var(--text-gray);
      cursor: pointer;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s;
    }
    .mobile-nav-close:hover {
      background: #fee2e2;
      color: var(--primary);
    }
    .mobile-nav-links {
      padding: 15px 0;
    }
    .mobile-nav-links a {
      display: block;
      padding: 14px 25px;
      color: var(--text-dark);
      font-weight: 600;
      font-size: 1rem;
      text-decoration: none;
      border-left: 3px solid transparent;
      transition: all 0.3s;
    }
    .mobile-nav-links a:hover, .mobile-nav-links a.active {
      background: rgba(244, 63, 94, 0.05);
      color: var(--primary);
      border-left-color: var(--primary);
    }
    .mobile-nav-links a i {
      width: 24px;
      margin-right: 10px;
      font-size: 0.95rem;
    }
    .mobile-nav-actions {
      padding: 20px;
      border-top: 1px solid #f1f5f9;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .mobile-nav-actions .btn-sos {
      text-align: center;
      text-decoration: none;
      justify-content: center;
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 1199px) {
      .nav-link { font-size: 0.85rem; margin: 0 4px; padding: 8px 12px; }
      .btn-outline-custom, .btn-primary-custom { padding: 7px 18px; font-size: 0.82rem; }
    }

    @media (max-width: 991px) {
      .mobile-menu-toggle { display: flex; }
      .header-nav .container { padding: 0 15px; }
      .brand-logo { height: 55px; }
      .how-it-works-image { margin-top: 40px; }
      .awareness-block { margin-bottom: 50px; }
      .cta-section { padding: 50px 30px; flex-direction: column; text-align: center; }
      .hero-carousel-section .carousel-item .hero-title { font-size: 3rem; }
      .hero-carousel-section .carousel-item .hero-desc { font-size: 1rem; }
      .how-it-works-section .section-title-custom { font-size: 2.2rem; }
      .stats-banner { border-radius: 16px; margin: 40px auto; }
      .stat-item { justify-content: flex-start; padding: 10px 20px; }
      .stat-item .stat-details { text-align: left; }
      .awareness-section { padding: 70px 0; }
      .features-section { padding: 70px 0; }
      .how-it-works-section { padding: 70px 0; }
      .emergency-section { padding: 70px 0; }
      .map-section { padding: 70px 0; }
      .how-it-works-image img { height: 400px; }
      .footer { padding: 60px 0 25px; }
    }

    @media (max-width: 767px) {
      .hero-carousel-section { min-height: 80vh; }
      .hero-carousel-section .carousel-item { height: 80vh; }
      .hero-carousel-section .carousel-item .hero-title { font-size: 2.2rem; }
      .hero-carousel-section .carousel-item .hero-desc { font-size: 0.95rem; line-height: 1.6; padding: 0 10px; }
      .hero-carousel-section .carousel-item .hero-badge { font-size: 0.75rem; padding: 6px 20px; }
      .hero-carousel-section .carousel-item .hero-content { padding: 15px; }
      .hero-carousel-section .carousel-control-prev,
      .hero-carousel-section .carousel-control-next { width: 40px; height: 40px; }
      .hero-carousel-section .carousel-indicators { bottom: 20px; }
      .hero-carousel-section .carousel-indicators button { width: 10px; height: 10px; margin: 0 6px; }
      .sos-circle-center { width: 110px; height: 110px; }
      .sos-circle-center h3 { font-size: 22px; }
      .sos-circle-center span { font-size: 10px; }
      .brand-logo { height: 50px; }
      .btn-sos { padding: 6px 16px; font-size: 0.75rem; }
      .btn-outline-custom, .btn-primary-custom { padding: 6px 16px; font-size: 0.8rem; }
      .awareness-img { height: 280px; }
      .awareness-text { padding: 20px 5px; }
      .awareness-text h3 { font-size: 1.6rem; }
      .awareness-text p { font-size: 0.95rem; }
      .feature-module-card { padding: 25px 20px; }
      .section-title { font-size: 1.6rem; margin-bottom: 35px; }
      .how-it-works-image img { height: 300px; }
      .step-wrapper { padding-left: 60px; margin-bottom: 25px; }
      .step-icon-circle { width: 42px; height: 42px; font-size: 1rem; }
      .step-wrapper h4 { font-size: 1.1rem; }
      .step-wrapper p { font-size: 0.88rem; }
      .how-it-works-section .section-title-custom { font-size: 1.8rem; }
      .how-it-works-section .section-sub { font-size: 0.95rem; }
      .how-it-works-image .image-overlay { padding: 25px; }
      .how-it-works-image .image-overlay h3 { font-size: 1.2rem; }
      .emergency-card { padding: 18px; gap: 15px; }
      .em-icon { width: 55px; height: 55px; font-size: 22px; }
      .em-details h3 { font-size: 22px; }
      .stats-banner { padding: 30px 0; border-radius: 12px; margin: 30px 15px; }
      .stat-icon { font-size: 28px; }
      .stat-details h3 { font-size: 24px; }
      .stat-details p { font-size: 11px; }
      .stat-item { gap: 10px; border-right: none !important; padding: 12px 20px; }
      .cta-section { padding: 40px 20px; border-radius: 20px; margin: 60px 15px; }
      .cta-section img { height: 150px !important; }
      .app-btns img { height: 38px !important; margin-right: 8px; }
      .footer h5 { font-size: 16px; margin-bottom: 18px; }
      .copyright { font-size: 12px; margin-top: 30px; padding-top: 20px; }
      .map-container { height: 280px !important; }
      .testimonial-card { padding: 25px 20px; }
      .user-info img { width: 45px; height: 45px; }
    }

    @media (max-width: 575px) {
      .hero-carousel-section { min-height: 75vh; }
      .hero-carousel-section .carousel-item { height: 75vh; }
      .hero-carousel-section .carousel-item .hero-title { font-size: 1.8rem; }
      .hero-carousel-section .carousel-item .hero-desc { font-size: 0.88rem; }
      .hero-carousel-section .carousel-item .hero-content { max-width: 100%; }
      .sos-circle-center { width: 100px; height: 100px; }
      .sos-circle-center h3 { font-size: 20px; }
      .brand-logo { height: 45px; }
      .header-nav { padding: 6px 0; }
      .feature-module-card { padding: 22px 16px; }
      .feature-module-icon { width: 60px; height: 60px; font-size: 24px; }
      .feature-module-card h4 { font-size: 1.05rem; }
      .awareness-section { padding: 50px 0; }
      .awareness-img { height: 220px; }
      .awareness-text h3 { font-size: 1.4rem; }
      .features-section { padding: 50px 0; }
      .how-it-works-section { padding: 50px 0; }
      .emergency-section { padding: 50px 0; }
      .map-section { padding: 50px 0; }
      .step-wrapper { padding-left: 50px; }
      .step-icon-circle { width: 36px; height: 36px; font-size: 0.85rem; }
      .step-wrapper h4 { font-size: 1rem; }
      .stats-banner .row { flex-direction: column; }
      .stat-item { border-right: none !important; border-bottom: 1px solid rgba(255,255,255,0.1); padding: 15px 25px; }
      .stat-item:last-child { border-bottom: none; }
      .cta-section { padding: 30px 15px; margin: 40px 10px; }
      .app-btns { flex-direction: column; align-items: center; }
      .app-btns img { height: 42px !important; margin: 0; }
      .footer { padding: 40px 0 20px; }
      .social-links a { width: 36px; height: 36px; margin-right: 8px; }
      .newsletter-input { padding: 10px 15px; }
      .newsletter-btn { padding: 10px; }
      .map-container { height: 220px !important; border-width: 2px !important; }
      .emergency-card { flex-direction: column; text-align: center; }
      .em-details { text-align: center; }
    }

    @media (max-width: 400px) {
      .hero-carousel-section .carousel-item .hero-title { font-size: 1.5rem; }
      .hero-carousel-section .carousel-item .hero-desc { font-size: 0.82rem; }
      .sos-circle-center { width: 85px; height: 85px; }
      .sos-circle-center h3 { font-size: 18px; }
      .brand-logo { height: 40px; }
      .section-title { font-size: 1.4rem; }
      .how-it-works-section .section-title-custom { font-size: 1.5rem; }
    }

    /* ===== FLOATING QUICK ACTIONS ===== */
    .hero-quick-actions-container {
      position: relative;
      margin-top: -65px;
      z-index: 100;
      padding-bottom: 20px;
    }
    .quick-action-card {
      display: flex;
      align-items: center;
      gap: 15px;
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      padding: 20px 24px;
      border-radius: 24px;
      border: 1px solid rgba(255, 255, 255, 0.5);
      box-shadow: 0 20px 40px rgba(15, 23, 42, 0.08);
      text-decoration: none !important;
      transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    }
    .quick-action-card i {
      font-size: 24px;
      color: var(--primary);
      width: 52px;
      height: 52px;
      background: rgba(244, 63, 94, 0.08);
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.4s ease;
    }
    .quick-action-card h5 {
      font-size: 1rem;
      font-weight: 700;
      color: var(--navy-dark);
      margin: 0 0 2px 0;
    }
    .quick-action-card p {
      font-size: 0.78rem;
      color: var(--text-gray);
      margin: 0;
    }
    .quick-action-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 30px 60px rgba(244, 63, 94, 0.18);
      background: white;
      border-color: rgba(244, 63, 94, 0.3);
    }
    .quick-action-card:hover i {
      background: var(--primary);
      color: white;
      transform: scale(1.1);
    }
    .quick-action-card.active-emergency {
      background: linear-gradient(135deg, var(--primary), var(--primary-hover));
      border: none;
    }
    .quick-action-card.active-emergency h5 {
      color: white;
    }
    .quick-action-card.active-emergency p {
      color: rgba(255, 255, 255, 0.8);
    }
    .quick-action-card.active-emergency i {
      background: rgba(255, 255, 255, 0.2);
      color: white;
    }
    .quick-action-card.active-emergency:hover {
      box-shadow: 0 30px 60px rgba(244, 63, 94, 0.35);
    }
    @media (max-width: 768px) {
      .hero-quick-actions-container {
        margin-top: 20px;
      }
      .quick-action-card {
        padding: 16px;
      }
    }

    /* ===== LOOK WISE UPGRADES ===== */
    .features-section {
      background: radial-gradient(circle at 10% 20%, rgba(244,63,94,0.03) 0%, transparent 50%), radial-gradient(circle at 90% 80%, rgba(49,46,129,0.03) 0%, transparent 50%);
    }
    .testimonial-card {
      background: rgba(255, 255, 255, 0.8) !important;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.3) !important;
    }
    .cta-section {
      background: linear-gradient(135deg, var(--navy-dark) 0%, #0f172a 100%) !important;
      color: white !important;
      border-radius: 30px;
      padding: 80px 50px;
      margin: 100px auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      border: 1px solid rgba(255,255,255,0.1);
      box-shadow: 0 30px 60px rgba(0,0,0,0.15);
      position: relative;
      overflow: hidden;
    }
    .cta-section h3 {
      color: white !important;
    }
    .cta-section p {
      color: rgba(255, 255, 255, 0.7) !important;
    }
  </style>
</head>
<body>

  <!-- ===== HEADER ===== -->
  <header class="header-nav">
    <div class="container">
      <div class="d-flex align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" class="brand-logo"></a>
      </div>
      
      <nav class="d-none d-lg-flex align-items-center">
        <a href="#hero" class="nav-link active">Home</a>
        <a href="#features" class="nav-link">Features</a>
        <a href="${pageContext.request.contextPath}/women-events" class="nav-link">Events </a>
       
       
        <a href="#tips" class="nav-link"> Safety</a>
        <a href="#resources" class="nav-link">Resources</a>
        <a href="#emergency" class="nav-link"> Emergency</a>
        <a href="#community" class="nav-link"> Community</a>
        <a href="#contact" class="nav-link"> Contact</a>
      </nav>
      <button class="mobile-menu-toggle d-lg-none" onclick="openMobileNav()" aria-label="Open Menu">
        <i class="fa-solid fa-bars"></i>
      </button>

      <div class="d-flex align-items-center gap-2">
        <c:choose>
          <c:when test="${not empty user || not empty loggedProvider || not empty loggedCentre || not empty loggedDoctor || not empty loggedSalon || not empty loggedStylist || not empty loggedSeller || not empty loggedEntrepreneur || not empty loggedInvestor || not empty admin}">
            <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/users/dashboard" />
            <c:if test="${not empty loggedProvider}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/marketplace/provider/dashboard" /></c:if>
            <c:if test="${not empty loggedCentre}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/centres/dashboard" /></c:if>
            <c:if test="${not empty loggedDoctor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/doctors/dashboard" /></c:if>
            <c:if test="${not empty loggedEntrepreneur}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/entrepreneur/dashboard" /></c:if>
            <c:if test="${not empty loggedInvestor}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/investor/dashboard" /></c:if>
            <c:if test="${not empty admin}"><c:set var="dashboardUrl" value="${pageContext.request.contextPath}/admin/adminDashboard" /></c:if>
            <a href="${dashboardUrl}" class="btn-outline-custom d-none d-md-inline-block"><i class="fa-solid fa-gauge-high me-1"></i> Dashboard</a>
          </c:when>
          <c:otherwise>
            <div class="dropdown d-none d-md-inline-block">
              <button class="btn-outline-custom dropdown-toggle" type="button" data-bs-toggle="dropdown"><i class="fa-solid fa-right-to-bracket me-1"></i> Login</button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">User Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctors/login">Women Doctor Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/centres/loginCentre">Self-Defense Center Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/salons/login">Beauty Salon Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stylists/login">Hair Stylist Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/marketplace/provider/login">Service Partner Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/women-products/seller/login">Marketplace Seller Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/entrepreneur/login">Entrepreneur Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/investor/login">Investor Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/women-events/host/login">Event Host Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/fitness/trainer/login">Fitness Trainer Login</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/loginAdmin">Admin Login</a></li>
              </ul>
            </div>
            <div class="dropdown d-none d-md-inline-block ms-2">
              <button class="btn-primary-custom dropdown-toggle" type="button" data-bs-toggle="dropdown"><i class="fa-solid fa-user-plus me-1"></i> Join Us</button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/users/register">Join as Member</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doctors/register">Women Doctor</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/centres/registerCentre">Self-Defense Trainer</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/salons/register">Beauty and wellness</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stylists/register">Hair Stylist</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/marketplace/provider/register">Service Partner</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/women-products/seller/register">Marketplace Seller</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/women-jobs/jobs/register">women jobs</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/entrepreneur/register">Entrepreneur</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/investor/register">Investor</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/women-events/host/register">Event Host</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/fitness/trainer/register">Fitness Trainer</a></li>
              </ul>
            </div>
          </c:otherwise>
        </c:choose>

      </div>
    </div>
  </header>

  <!-- Mobile Navigation Drawer -->
  <div class="mobile-nav-overlay" id="mobileNavOverlay" onclick="closeMobileNav()"></div>
  <div class="mobile-nav-drawer" id="mobileNavDrawer">
    <div class="mobile-nav-header">
      <a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 45px; border-radius: 8px;"></a>
      <button class="mobile-nav-close" onclick="closeMobileNav()" aria-label="Close Menu"><i class="fa-solid fa-xmark"></i></button>
    </div>
    <div class="mobile-nav-links">
      <a href="#hero" class="active" onclick="closeMobileNav()"><i class="fa-solid fa-house"></i> Home</a>
      <a href="#features" onclick="closeMobileNav()"><i class="fa-solid fa-star"></i> Features</a>
      <a href="${pageContext.request.contextPath}/women-events" onclick="closeMobileNav()"><i class="fa-solid fa-calendar"></i> Events 🌸</a>
      <a href="#awareness" onclick="closeMobileNav()"><i class="fa-solid fa-hand-fist"></i> Awareness</a>
      <a href="#emergency" onclick="closeMobileNav()"><i class="fa-solid fa-phone-volume"></i> Emergency</a>
      <a href="#howitworks" onclick="closeMobileNav()"><i class="fa-solid fa-circle-check"></i> How It Works</a>
      <a href="#contact" onclick="closeMobileNav()"><i class="fa-solid fa-envelope"></i> Contact</a>
    </div>
    <div class="mobile-nav-actions">
      <c:choose>
        <c:when test="${not empty user || not empty loggedProvider || not empty loggedCentre || not empty loggedDoctor || not empty loggedSalon || not empty loggedStylist || not empty loggedSeller || not empty loggedEntrepreneur || not empty loggedInvestor || not empty admin}">
          <a href="${dashboardUrl}" class="btn-outline-custom" style="text-align:center; text-decoration:none;"><i class="fa-solid fa-gauge-high me-1"></i> Dashboard</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="btn-outline-custom" style="text-align:center; text-decoration:none;"><i class="fa-solid fa-right-to-bracket me-1"></i> Login</a>
          <a href="${pageContext.request.contextPath}/users/register" class="btn-primary-custom" style="text-align:center; text-decoration:none;"><i class="fa-solid fa-user-plus me-1"></i> Register</a>
        </c:otherwise>
      </c:choose>
      <a href="${pageContext.request.contextPath}/sos/dashboard" class="btn-sos" style="text-decoration:none;"><i class="fa-solid fa-phone"></i> SOS Emergency</a>
    </div>
  </div>

  <!-- ===== HERO VIDEO SECTION =====
       VIDEO SETUP INSTRUCTIONS:
       1. Download your video from: https://pin.it/70xzSfUyH
          (Right-click on the Pinterest video > Save video as... or use a tool like SnapInsta)
       2. Place the downloaded file at:
          src/main/webapp/assets/video/hero-video.mp4
       3. The video will auto-play muted in the background.
       ===== -->
  <section id="hero" class="hero-video-section">
    <!-- Blurred Background Video - Left Side -->
    <div class="hero-video-side left-side">
      <video id="heroVideoBgLeft" class="hero-video-bg-blurred-el" autoplay muted loop playsinline preload="auto">
        <source src="${pageContext.request.contextPath}/assets/video/hero-video.mp4" type="video/mp4">
      </video>
    </div>

    <!-- Blurred Background Video - Right Side (Mirrored) -->
    <div class="hero-video-side right-side">
      <video id="heroVideoBgRight" class="hero-video-bg-blurred-el" autoplay muted loop playsinline preload="auto">
        <source src="${pageContext.request.contextPath}/assets/video/hero-video.mp4" type="video/mp4">
      </video>
    </div>

    <!-- Sharp Foreground Video (shows full portrait figure without crop) -->
    <video id="heroVideo" class="hero-video-bg" autoplay muted loop playsinline preload="auto"
      onerror="this.style.display='none'; if(document.getElementById('heroVideoBgLeft')) document.getElementById('heroVideoBgLeft').style.display='none'; if(document.getElementById('heroVideoBgRight')) document.getElementById('heroVideoBgRight').style.display='none'; document.getElementById('heroVideoFallback').style.display='block';">
      <source src="${pageContext.request.contextPath}/assets/video/hero-video.mp4" type="video/mp4">
    </video>
    <!-- Fallback image if video missing -->
    <div id="heroVideoFallback" style="display:none; position:absolute; inset:0; background: url('${pageContext.request.contextPath}/assets/images/img6.jpg') center/cover no-repeat; z-index:0;"></div>

    <!-- Dark overlay -->
    <div class="hero-video-overlay"></div>



    <!-- Mute / Unmute Toggle -->
    <button class="hero-mute-btn" id="heroMuteBtn" title="Toggle Audio" onclick="toggleHeroMute()">
      <i class="fa-solid fa-volume-xmark" id="heroMuteIcon"></i>
    </button>

    <!-- Scroll down indicator -->
    <div class="hero-scroll-indicator">
      <span>SCROLL</span>
      <i class="fa-solid fa-chevron-down"></i>
    </div>
  </section>


  <!-- ===== FLOATING QUICK ACTIONS BAR ===== -->
  <div class="container hero-quick-actions-container">
    <div class="row g-3 justify-content-center hero-quick-actions-row">
      <div class="col-md-3 col-sm-6" data-aos="fade-up" data-aos-delay="100">
        <a href="${pageContext.request.contextPath}/sos/dashboard" class="quick-action-card active-emergency">
          <i class="fa-solid fa-triangle-exclamation"></i>
          <div>
            <h5>SOS Emergency</h5>
            <p>One-Tap Danger Alert</p>
          </div>
        </a>
      </div>
      <div class="col-md-3 col-sm-6" data-aos="fade-up" data-aos-delay="200">
        <a href="${pageContext.request.contextPath}/map" class="quick-action-card">
          <i class="fa-solid fa-map-location-dot"></i>
          <div>
            <h5>Danger Map</h5>
            <p>Avoid Unsafe Zones</p>
          </div>
        </a>
      </div>
      <div class="col-md-3 col-sm-6" data-aos="fade-up" data-aos-delay="300">
        <a href="${pageContext.request.contextPath}/women-events" class="quick-action-card">
          <i class="fa-solid fa-calendar-days"></i>
          <div>
            <h5>Women Events</h5>
            <p>Empowerment Meetups</p>
          </div>
        </a>
      </div>
      <div class="col-md-3 col-sm-6" data-aos="fade-up" data-aos-delay="400">
        <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="quick-action-card">
          <i class="fa-solid fa-hand-fist"></i>
          <div>
            <h5>Self-Defense</h5>
            <p>Verified Academies</p>
          </div>
        </a>
  </div>

  <!-- ===== PLATFORM WELCOME & SOS EMERGENCY HUB ===== -->
  <section class="welcome-emergency-section">
    <div class="container">
      <div class="row g-4 align-items-center">
        <!-- Left Column: Welcome & Info -->
        <div class="col-lg-7" data-aos="fade-right">
          <span class="welcome-badge mb-3 d-inline-block"><i class="fa-solid fa-shield-halved me-2"></i> FIGHT D FEAR &mdash; WOMEN SAFETY</span>
          <h2 class="welcome-title fw-black mb-3">Your Safety is <span class="text-primary-rose">Our Priority</span></h2>
          <p class="welcome-text text-muted mb-4">
            Empowering women with instant emergency response, self-defense training, community support and professional wellness resources &mdash; all in one platform.
          </p>
          <div class="d-flex gap-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn btn-outline-rose px-4 py-2.5 rounded-pill fw-bold text-decoration-none">
              <i class="fa-solid fa-shield me-2"></i> Find self-defense centres
            </a>
            <a href="${pageContext.request.contextPath}/stories" class="btn btn-light-rose px-4 py-2.5 rounded-pill fw-bold text-decoration-none">
              <i class="fa-solid fa-users me-2"></i> Read community stories
            </a>
          </div>
        </div>

        <!-- Right Column: Interactive SOS Card -->
        <div class="col-lg-5" data-aos="fade-left">
          <div class="sos-interactive-card text-center p-4 rounded-4 shadow-sm border border-danger border-opacity-10 bg-white">
            <div class="d-flex align-items-center justify-content-center mb-3">
              <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-1.5 rounded-pill fs-7 fw-bold">
                <span class="spinner-grow spinner-grow-sm text-danger me-1 align-middle" role="status" style="width: 10px; height: 10px; border-width: 2px;"></span> Emergency Panic Trigger
              </span>
            </div>
            <h4 class="fw-bold mb-2">Need Immediate Help?</h4>
            <p class="text-muted small mb-4">Click the button below to activate the SOS alert. This will instantly send your live location to contacts.</p>
            
            <div class="d-flex justify-content-center mb-4">
              <div class="sos-circle-trigger" onclick="window.location.href='${pageContext.request.contextPath}/sos/dashboard'">
                <h3>SOS</h3>
                <span>Press to Trigger</span>
              </div>
            </div>
            
            <a href="${pageContext.request.contextPath}/sos/dashboard" class="btn btn-danger w-100 py-2.5 rounded-pill fw-bold text-decoration-none">
              <i class="fa-solid fa-bell me-2"></i> Go to SOS Dashboard
            </a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== FEATURES SECTION - 9 MODULES ===== -->
  <section id="features" class="features-section">
    <div class="container">
      <div class="text-center mb-5" data-aos="fade-up">
        <span class="section-badge" style="display:inline-block; background:rgba(244,63,94,0.08); color:var(--primary); font-weight:600; font-size:0.75rem; padding:6px 20px; border-radius:50px; text-transform:uppercase; letter-spacing:1.5px; margin-bottom:10px;">
          <i class="fa-regular fa-star me-2"></i> All-in-One Platform
        </span>
        <h2 class="section-title" style="margin-top:15px;">Everything You Need for <span style="color:var(--primary);">Women's Safety</span></h2>
        <p class="text-muted" style="max-width:600px; margin:0 auto;">9 powerful modules designed to protect, empower, and connect women</p>
      </div>
      
      <div class="row g-4">
        <!-- 1. Core Safety Features -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
          <div class="feature-module-card">
            <span class="module-number">01</span>
            <div class="feature-module-icon"><i class="fa-solid fa-shield-halved"></i></div>
            <h4>Core Safety Features</h4>
            <p>SOS Panic Button, Audio Recording, Emergency Contacts, Live Location Sharing, Journey Tracking & more.</p>
            <div class="feature-tags">
              <span>SOS Alert</span>
              <span>Live Tracking</span>
              <span>Safe Route</span>
            </div>
          </div>
        </div>
        
        <!-- 2. Community Features -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="150">
          <div class="feature-module-card">
            <span class="module-number">02</span>
            <div class="feature-module-icon"><i class="fa-solid fa-users"></i></div>
            <h4>Community Features</h4>
            <p>Community posts, Q&A, Chat, Video Calling, Safety Stories, Volunteer Network & Buddy System.</p>
            <div class="feature-tags">
              <span>Chat</span>
              <span>Video Call</span>
              <span>Volunteer</span>
            </div>
          </div>
        </div>
        
        <!-- 3. Location Intelligence -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
          <div class="feature-module-card">
            <span class="module-number">03</span>
            <div class="feature-module-icon"><i class="fa-solid fa-location-dot"></i></div>
            <h4>Location Intelligence</h4>
            <p>Live GPS tracking, Safe Route navigation, Danger Points mapping & Journey Monitoring.</p>
            <div class="feature-tags">
              <span>Live GPS</span>
              <span>Safe Route</span>
              <span>Danger Points</span>
            </div>
          </div>
        </div>
        
        <!-- 4. Women's Skill Development -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="250">
          <div class="feature-module-card">
            <span class="module-number">04</span>
            <div class="feature-module-icon"><i class="fa-solid fa-graduation-cap"></i></div>
            <h4>Skill Development</h4>
            <p>Online classes, Training programs, Progress tracking, Course enrollment & Schedule management.</p>
            <div class="feature-tags">
              <span>Online Classes</span>
              <span>Training</span>
              <span>Certificates</span>
            </div>
          </div>
        </div>
        
        <!-- 5. Marketplace -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
          <div class="feature-module-card">
            <span class="module-number">05</span>
            <div class="feature-module-icon"><i class="fa-solid fa-store"></i></div>
            <h4>Marketplace</h4>
            <p>Women products marketplace, Secure payments, Digital wallet, Exclusive offers & Seller communication.</p>
            <div class="feature-tags">
              <span>Wallet</span>
              <span>Payments</span>
              <span>Offers</span>
            </div>
          </div>
        </div>
        
        <!-- 6. Beauty & Salon Services -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="350">
          <div class="feature-module-card">
            <span class="module-number">06</span>
            <div class="feature-module-icon"><i class="fa-solid fa-spa"></i></div>
            <h4>Beauty & Salon</h4>
            <p>Salon booking, Beauty services, Professional stylists, Stylist reviews & Treatment packages.</p>
            <div class="feature-tags">
              <span>Salon</span>
              <span>Stylists</span>
              <span>Treatments</span>
            </div>
          </div>
        </div>
        
        <!-- 7. Professional Consultation -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="400">
          <div class="feature-module-card">
            <span class="module-number">07</span>
            <div class="feature-module-icon"><i class="fa-solid fa-stethoscope"></i></div>
            <h4>Professional Consultation</h4>
            <p>Doctor consultation, Video appointments, Booking system & Future: Lawyers, Therapists, Career Mentors.</p>
            <div class="feature-tags">
              <span>Doctors</span>
              <span>Video Consult</span>
              <span>Booking</span>
            </div>
          </div>
        </div>
        
        <!-- 8. Communication -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="450">
          <div class="feature-module-card">
            <span class="module-number">08</span>
            <div class="feature-module-icon"><i class="fa-solid fa-comments"></i></div>
            <h4>Communication</h4>
            <p>Real-time chat, Video calls, Contact messaging, Notifications & Instant alerts for emergencies.</p>
            <div class="feature-tags">
              <span>Chat</span>
              <span>Video Calls</span>
              <span>Alerts</span>
            </div>
          </div>
        </div>
        
        <!-- 9. Content Platform -->
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="500">
          <div class="feature-module-card">
            <span class="module-number">09</span>
            <div class="feature-module-icon"><i class="fa-solid fa-video"></i></div>
            <h4>Content Platform</h4>
            <p>Upload videos, Watch content, Share media, Safety stories & Creator-style engagement.</p>
            <div class="feature-tags">
              <span>Videos</span>
              <span>Stories</span>
              <span>Media</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== AWARENESS & SOLIDARITY SECTION ===== -->
  <section class="awareness-section" id="awareness">
    <div class="container">
      <div class="text-center mb-5" data-aos="fade-up">
        <h2 class="section-title">Awareness & Solidarity</h2>
        <p class="text-muted">Together, we build a safer world through education and unity.</p>
      </div>

      <div class="row align-items-center awareness-block">
        <div class="col-lg-6 mb-4 mb-lg-0" data-aos="fade-right">
          <img src="${pageContext.request.contextPath}/assets/img/awareness_solidarity_1779965397029.png" alt="Women Solidarity" class="awareness-img">
        </div>
        <div class="col-lg-6" data-aos="fade-left">
          <div class="awareness-text">
            <h3>Strength in Sisterhood</h3>
            <p>Empowerment begins when we stand together. Fight D Fear fosters a community where women support each other, share critical information, and ensure no one walks alone.</p>
            <p>Join thousands of women who are actively creating safer neighborhoods by staying connected and vigilant.</p>
            <a href="${pageContext.request.contextPath}/stories" class="btn-primary-custom">Read Community Stories</a>
          </div>
        </div>
      </div>

      <div class="row align-items-center awareness-block flex-lg-row-reverse">
        <div class="col-lg-6 mb-4 mb-lg-0" data-aos="fade-left">
          <img src="${pageContext.request.contextPath}/assets/img/awareness_tech_shield_1779965413589.png" alt="Tech Shield" class="awareness-img">
        </div>
        <div class="col-lg-6" data-aos="fade-right">
          <div class="awareness-text">
            <h3>Proactive Digital Protection</h3>
            <p>Safety is no longer just physical—it's digital. With advanced Danger Maps, AI Safety Assistants, and real-time alerts, technology becomes your invisible shield.</p>
            <p>We leverage cutting-edge tools to predict unsafe zones and provide immediate assistance before an emergency escalates.</p>
            <a href="${pageContext.request.contextPath}/index/templates#services" class="btn-outline-custom">Explore Safety Tools</a>
          </div>
        </div>
      </div>

      <div class="row align-items-center awareness-block">
        <div class="col-lg-6 mb-4 mb-lg-0" data-aos="fade-right">
          <img src="${pageContext.request.contextPath}/assets/img/awareness_self_defense_1779965432813.png" alt="Self Defense Training" class="awareness-img">
        </div>
        <div class="col-lg-6" data-aos="fade-left">
          <div class="awareness-text">
            <h3>Equipped to Defend</h3>
            <p>Awareness is the first step, but preparation is the ultimate defense. Learning self-defense transforms fear into confidence, giving you the power to protect yourself and others.</p>
            <p>Discover local, verified martial arts centres and start your journey towards physical empowerment today.</p>
            <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn-primary-custom">Find a Training Centre</a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== HOW IT WORKS ===== -->
  <section class="how-it-works-section" id="howitworks">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6" data-aos="fade-right">
          <span class="section-badge"><i class="fa-regular fa-circle-check me-2"></i> How It Works</span>
          <h2 class="section-title-custom">Your Safety Journey in 4 Steps</h2>
          <p class="section-sub">Simple, fast, and secure — get protected in minutes</p>
          
          <div class="step-wrapper" data-aos="fade-up" data-aos-delay="100">
            <div class="step-icon-circle"><i class="fa-solid fa-user-plus step-icon"></i></div>
            <h4>Sign Up & Setup</h4>
            <p>Create your free account in under 2 minutes. Set up your profile, customize your safety preferences, and add emergency contacts who will be notified during critical situations.</p>
          </div>
          
          <div class="step-wrapper" data-aos="fade-up" data-aos-delay="200">
            <div class="step-icon-circle"><i class="fa-solid fa-address-book step-icon"></i></div>
            <h4>Add Trusted Contacts</h4>
            <p>Add your family members, friends, or colleagues who will receive your SOS alerts. You can manage multiple contacts and choose who gets notified during different types of emergencies.</p>
          </div>
          
          <div class="step-wrapper" data-aos="fade-up" data-aos-delay="300">
            <div class="step-icon-circle"><i class="fa-solid fa-hand-pointer step-icon"></i></div>
            <h4>Press SOS in Danger</h4>
            <p>In an emergency, tap the SOS button. Your live location, audio recording, and alert will be instantly sent to your trusted contacts and local authorities. Every second counts.</p>
          </div>
          
          <div class="step-wrapper" data-aos="fade-up" data-aos-delay="400">
            <div class="step-icon-circle"><i class="fa-solid fa-shield-halved step-icon"></i></div>
            <h4>Get Immediate Help</h4>
            <p>Your contacts receive your exact location and can track you in real-time. They can also listen to ambient audio and coordinate with emergency services to reach you quickly.</p>
          </div>
        </div>
        
        <div class="col-lg-6" data-aos="fade-left" data-aos-delay="200">
          <div class="how-it-works-image">
            <img src="https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&q=90" alt="Empowered Women Safety">
            <div class="image-overlay">
              <h3>Empowered Women, Safe Women</h3>
              <p>Join thousands of women who have taken control of their safety</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Emergency Services -->
  <section id="emergency" class="emergency-section">
    <div class="container">
      <h2 class="section-title" data-aos="fade-up">Emergency Services</h2>
      <div class="row g-4 mt-3">
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
          <div class="emergency-card"><div class="em-icon"><i class="fa-solid fa-user-shield"></i></div><div class="em-details"><h5>Police</h5><h3>100</h3><a href="tel:100"><button class="em-btn">Call Now</button></a></div></div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
          <div class="emergency-card"><div class="em-icon"><i class="fa-solid fa-truck-medical"></i></div><div class="em-details"><h5>Ambulance</h5><h3>108</h3><a href="tel:108"><button class="em-btn">Call Now</button></a></div></div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
          <div class="emergency-card"><div class="em-icon"><i class="fa-solid fa-phone-volume"></i></div><div class="em-details"><h5>Women Helpline</h5><h3>1091</h3><a href="tel:1091"><button class="em-btn">Call Now</button></a></div></div>
        </div>
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="400">
          <div class="emergency-card"><div class="em-icon"><i class="fa-solid fa-fire-extinguisher"></i></div><div class="em-details"><h5>Fire Service</h5><h3>101</h3><a href="tel:101"><button class="em-btn">Call Now</button></a></div></div>
        </div>
      </div>
    </div>
  </section>

  <!-- Map Section -->
  <section class="map-section">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6 mb-4 mb-lg-0" data-aos="fade-right">
          <div class="map-container" style="height: 400px; width: 100%; background: #e2e8f0;">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d224346.54005187762!2d77.04360370821017!3d28.527252737667746!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390cfd5b347eb62d%3A0x52c2b7494e204dce!2sNew%20Delhi%2C%20Delhi!5e0!3m2!1sen!2sin!4v1700000000000" width="100%" height="100%" style="border:0;" allowfullscreen></iframe>
          </div>
        </div>
        <div class="col-lg-6 px-lg-5" data-aos="fade-left">
          <span style="color: var(--primary); font-weight: 600; font-size: 14px;">Stay Aware</span>
          <h2 class="mb-3" style="color: var(--navy-dark); font-weight: 800;">Unsafe Area Map</h2>
          <p style="color: var(--text-gray); margin-bottom: 30px;">Check unsafe areas in and around your location in real-time. Stay alert, stay safe!</p>
          <div class="d-flex gap-3 flex-wrap mb-4">
            <div class="map-tag tag-high"><i class="fa-solid fa-circle"></i> High Risk Area</div>
            <div class="map-tag tag-med"><i class="fa-solid fa-circle"></i> Medium Risk Area</div>
            <div class="map-tag tag-safe"><i class="fa-solid fa-circle"></i> Safe Area</div>
          </div>
          <a href="${pageContext.request.contextPath}/map" class="btn-primary-custom d-inline-flex align-items-center gap-2">View Full Map <i class="fa-solid fa-arrow-right"></i></a>
        </div>
      </div>
    </div>
  </section>

  <!-- Stats Banner -->
  <div class="container">
    <div class="stats-banner" data-aos="zoom-in">
      <div class="row text-center">
        <div class="col-md-3 stat-item border-end border-light border-opacity-25">
          <i class="fa-solid fa-users stat-icon"></i><div class="stat-details text-start"><h3>10K+</h3><p>Users Protected</p></div>
        </div>
        <div class="col-md-3 stat-item border-end border-light border-opacity-25">
          <i class="fa-solid fa-bell stat-icon"></i><div class="stat-details text-start"><h3>5K+</h3><p>SOS Alerts Sent</p></div>
        </div>
        <div class="col-md-3 stat-item border-end border-light border-opacity-25">
          <i class="fa-solid fa-shield-halved stat-icon"></i><div class="stat-details text-start"><h3>100+</h3><p>Safe Zones</p></div>
        </div>
        <div class="col-md-3 stat-item">
          <i class="fa-regular fa-clock stat-icon"></i><div class="stat-details text-start"><h3>24/7</h3><p>Support Available</p></div>
        </div>
      </div>
    </div>
  </div>

  <!-- Testimonials -->
  <section class="steps-section" style="background: transparent; padding: 100px 0;">
    <div class="container">
      <h2 class="section-title" data-aos="fade-up">What Users Say</h2>
      <div class="row g-4 mt-4">
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="100">
          <div class="testimonial-card"><div class="user-info"><img src="${pageContext.request.contextPath}/assets/img/chat-user-1.png" onerror="this.src='https://via.placeholder.com/50'" alt="User"><div><h6 style="margin:0; font-weight:700; color:var(--navy-dark);">Sneha Patil</h6><div class="stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div></div></div><p style="color:var(--text-gray); font-size:14px; margin:0;">The SOS feature helped me alert my family instantly. I feel so much safer now!</p></div>
        </div>
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
          <div class="testimonial-card"><div class="user-info"><img src="${pageContext.request.contextPath}/assets/img/chat-user-2.jpg" onerror="this.src='https://via.placeholder.com/50'" alt="User"><div><h6 style="margin:0; font-weight:700; color:var(--navy-dark);">Anjali Sharma</h6><div class="stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div></div></div><p style="color:var(--text-gray); font-size:14px; margin:0;">Live tracking and audio recording features are amazing. A must-have app for every woman.</p></div>
        </div>
        <div class="col-lg-4" data-aos="fade-up" data-aos-delay="300">
          <div class="testimonial-card"><div class="user-info"><img src="${pageContext.request.contextPath}/assets/img/chat-user-3.jpg" onerror="this.src='https://via.placeholder.com/50'" alt="User"><div><h6 style="margin:0; font-weight:700; color:var(--navy-dark);">Riya Singh</h6><div class="stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div></div></div><p style="color:var(--text-gray); font-size:14px; margin:0;">The unsafe area alerts are very helpful. Thank you for creating such a wonderful app!</p></div>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <div class="container">
    <div class="cta-section" data-aos="fade-up">
      <div class="row align-items-center w-100">
        <div class="col-lg-4 d-flex justify-content-center mb-4 mb-lg-0">
          <img src="${pageContext.request.contextPath}/assets/img/about-img.svg" onerror="this.src='https://via.placeholder.com/200'" style="height: 200px;" alt="App Interface">
        </div>
        <div class="col-lg-4 text-center">
          <h3 style="color: var(--navy-dark); font-weight: 800; margin-bottom: 15px;">Download Our App</h3>
          <p style="color: var(--text-gray); margin-bottom: 20px;">Your safety companion, always with you.</p>
          <div class="app-btns d-flex justify-content-center gap-3">
            <a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Google Play"></a>
            <a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" alt="App Store"></a>
          </div>
        </div>
        <div class="col-lg-4 d-flex justify-content-center mt-4 mt-lg-0">
           <img src="${pageContext.request.contextPath}/assets/img/hero-img.svg" onerror="this.src='https://via.placeholder.com/200'" style="height: 250px;" alt="Phone Mockup">
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer class="footer">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3 col-md-6">
          <div class="footer-logo"><a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear Logo" class="brand-logo" style="height: 85px; background: white; padding: 5px;"></a></div>
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
          <ul><li><a href="#hero">Home</a></li><li><a href="${pageContext.request.contextPath}/features.jsp">Features</a></li><li><a href="#awareness">Awareness</a></li><li><a href="#emergency">Emergency</a></li><li><a href="#howitworks">How It Works</a></li><li><a href="#contact">Contact</a></li></ul>
        </div>
        <div class="col-lg-3 col-md-6">
          <h5>Important Links</h5>
          <ul><li><a href="#">Privacy Policy</a></li><li><a href="#">Terms & Conditions</a></li><li><a href="#">Refund Policy</a></li><li><a href="#">Disclaimer</a></li><li><a href="#">Help & Support</a></li></ul>
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
          <form action="#"><input type="email" class="newsletter-input" placeholder="Enter your email" required><button type="submit" class="newsletter-btn">Subscribe</button></form>
        </div>
      </div>
      <div class="copyright">&copy; 2026 Women Safety. All Rights Reserved.</div>
    </div>
  </footer>

  <!-- Scripts -->
  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script>
    AOS.init({
      duration: 800,
      easing: 'ease-in-out',
      once: true,
      mirror: false
    });

    // ===== HERO VIDEO CONTROLS =====
    document.addEventListener('DOMContentLoaded', function() {
      var heroVideo = document.getElementById('heroVideo');
      var heroVideoBgLeft = document.getElementById('heroVideoBgLeft');
      var heroVideoBgRight = document.getElementById('heroVideoBgRight');
      
      function initVideo(vid) {
        if (!vid) return;
        vid.play().catch(function() {
          vid.style.display = 'none';
          var fb = document.getElementById('heroVideoFallback');
          if (fb) fb.style.display = 'block';
        });
        vid.playbackRate = 0.5;
        vid.addEventListener('play', function() {
          vid.playbackRate = 0.5; // Ensure it stays slow after any browser reset
        });
      }

      initVideo(heroVideo);
      initVideo(heroVideoBgLeft);
      initVideo(heroVideoBgRight);

      // Trim the last ~1.5 seconds (the text/credits portion at the end)
      // Adjust CUT_FROM_END to set how many seconds to trim from the end
      var CUT_FROM_END = 1.5;
      if (heroVideo) {
        heroVideo.addEventListener('timeupdate', function() {
          if (heroVideo.duration && !isNaN(heroVideo.duration)) {
            var cutAt = heroVideo.duration - CUT_FROM_END;
            if (cutAt > 0 && heroVideo.currentTime >= cutAt) {
              if (heroVideoBgLeft) heroVideoBgLeft.currentTime = 0; // Reset left background video
              if (heroVideoBgRight) heroVideoBgRight.currentTime = 0; // Reset right background video
              heroVideo.currentTime = 0; // Loop main video back to start
            }
          }
        });
      }
    });

    // Mute / Unmute toggle
    function toggleHeroMute() {
      var vid = document.getElementById('heroVideo');
      var vidBgLeft = document.getElementById('heroVideoBgLeft');
      var vidBgRight = document.getElementById('heroVideoBgRight');
      var icon = document.getElementById('heroMuteIcon');
      if (!vid) return;
      
      var targetMute = !vid.muted;
      vid.muted = targetMute;
      if (vidBgLeft) vidBgLeft.muted = targetMute;
      if (vidBgRight) vidBgRight.muted = targetMute;
      
      if (targetMute) {
        icon.className = 'fa-solid fa-volume-xmark';
      } else {
        icon.className = 'fa-solid fa-volume-high';
      }
    }

    // Mobile Navigation
    function openMobileNav() {
      document.getElementById('mobileNavDrawer').classList.add('active');
      document.getElementById('mobileNavOverlay').classList.add('active');
      document.body.style.overflow = 'hidden';
    }
    function closeMobileNav() {
      document.getElementById('mobileNavDrawer').classList.remove('active');
      document.getElementById('mobileNavOverlay').classList.remove('active');
      document.body.style.overflow = '';
    }
  </script>
</body>
</html>