<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Safety Stories</title>
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
<style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
    }

    body {
        background: var(--light-bg) !important;
        font-family: 'Poppins', sans-serif;
    }

    .container {
        max-width: 1000px;
    }

    h3, h5 {
        color: var(--primary-purple);
        font-weight: 700;
    }

    .text-muted {
        color: var(--primary-purple-light) !important;
        opacity: 0.8;
    }

    /* Cards */
    .card {
        border: none;
        border-radius: 1.25rem !important;
        box-shadow: var(--shadow-sm);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .card:hover {
        box-shadow: var(--shadow-md);
        transform: translateY(-2px);
    }

    /* Form controls */
    .form-control {
        border-radius: 0.75rem;
        border: 1px solid rgba(123, 44, 191, 0.3);
        transition: all 0.2s;
    }
    .form-control:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        outline: none;
    }

    /* Primary button */
    .btn-primary {
        background-color: var(--primary-purple);
        border: none;
        border-radius: 2rem;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
        transition: all 0.2s;
    }
    .btn-primary:hover {
        background-color: var(--primary-purple-light);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    /* Outline secondary button */
    .btn-outline-secondary {
        border-color: var(--primary-purple-light);
        color: var(--primary-purple);
        border-radius: 2rem;
        transition: all 0.2s;
    }
    .btn-outline-secondary:hover {
        background-color: var(--primary-purple-light);
        border-color: var(--primary-purple-light);
        color: white;
        transform: translateY(-2px);
    }

    /* Alert */
    .alert-info {
        background-color: rgba(255, 215, 0, 0.1);
        border-left: 4px solid var(--primary-gold);
        color: var(--dark-bg);
        border-radius: 1rem;
    }

    /* Attachment link */
    a:not(.btn) {
        color: var(--primary-purple-light);
        text-decoration: none;
        font-weight: 500;
        transition: color 0.2s;
    }
    a:not(.btn):hover {
        color: var(--primary-purple);
        text-decoration: underline;
    }

    /* Post card metadata */
    .fw-bold {
        color: var(--primary-purple);
    }

    /* File input button (webkit) */
    input[type="file"]::-webkit-file-upload-button {
        background-color: var(--primary-purple-light);
        border: none;
        color: white;
        border-radius: 2rem;
        padding: 0.3rem 1rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    input[type="file"]::-webkit-file-upload-button:hover {
        background-color: var(--primary-purple);
    }

    @media (max-width: 768px) {
        .d-flex.gap-2 {
            flex-direction: column;
            align-items: stretch !important;
        }
        input.form-control[type="file"] {
            max-width: 100% !important;
        }
        .btn-primary {
            margin-top: 0.5rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the whole page */
    body {
        animation: fadeInPage 0.5s ease-out forwards;
    }
    @keyframes fadeInPage {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    /* 2. Button ripple effect on click (micro-interaction) */
    .btn-primary, .btn-outline-secondary, input[type="file"]::-webkit-file-upload-button {
        position: relative;
        overflow: hidden;
    }
    .btn-primary::after, .btn-outline-secondary::after, input[type="file"]::-webkit-file-upload-button::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-primary:active::after, .btn-outline-secondary:active::after,
    input[type="file"]::-webkit-file-upload-button:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .btn-primary:focus-visible, .btn-outline-secondary:focus-visible,
    .form-control:focus-visible, a:not(.btn):focus-visible,
    input[type="file"]:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 2rem;
    }

    /* 4. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Card inner content hover effect – subtle scale for icons/images */
    .card img, .card i {
        transition: transform 0.2s;
    }
    .card:hover img, .card:hover i {
        transform: scale(1.02);
    }

    /* 6. Alert hover effect – subtle background change */
    .alert-info {
        transition: background-color 0.2s, transform 0.2s;
    }
    .alert-info:hover {
        background-color: rgba(255, 215, 0, 0.2);
        transform: translateX(3px);
    }

    /* 7. Label hover effect (if labels exist) */
    label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    label:hover {
        color: var(--primary-purple-light);
        transform: translateX(2px);
    }

    /* 8. Input placeholder styling (softer) */
    .form-control::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    .form-control:focus::placeholder {
        opacity: 0.6;
    }

    /* 9. Responsive touch improvements for very small screens */
    @media (max-width: 480px) {
        .btn-primary, .btn-outline-secondary {
            padding: 0.6rem 1rem;
            font-size: 0.85rem;
        }
        .card {
            padding: 0.75rem !important;
        }
        h3, h5 {
            font-size: 1.25rem;
        }
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .card.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>

<body style="background: var(--light-bg);">

<div class="container py-4" style="max-width:1000px;">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <div>
      <h3 class="mb-1">Safety Stories</h3>
      <div class="text-muted small">Share experiences, tips, and support each other.</div>
    </div>
    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/users/dashboard">Back</a>
  </div>

  <c:if test="${not empty message}">
    <div class="alert alert-info">${message}</div>
  </c:if>

  <div class="card p-3 shadow-sm rounded-4 mb-3">
    <h5 class="mb-3">Share your story</h5>
    <form action="${pageContext.request.contextPath}/stories/create" method="post" enctype="multipart/form-data">
      <div class="mb-2">
        <textarea class="form-control" name="content" rows="3" maxlength="1200" placeholder="Write your experience or safety tip…" required></textarea>
      </div>
      <div class="d-flex gap-2 align-items-center">
        <input class="form-control" type="file" name="media" style="max-width:360px;">
        <button class="btn btn-primary" type="submit">Post</button>
      </div>
      <div class="text-muted small mt-2">Avoid sharing phone numbers, addresses, or sensitive personal info.</div>
    </form>
  </div>

  <c:if test="${empty posts}">
    <div class="text-muted">No stories yet.</div>
  </c:if>
  <c:forEach var="p" items="${posts}">
    <div class="card p-3 shadow-sm rounded-4 mb-3">
      <div class="d-flex justify-content-between align-items-center">
        <div class="fw-bold">${p.user.fullName}</div>
        <div class="text-muted small">${p.createdAt}</div>
      </div>
      <div class="mt-2">${p.content}</div>
      <c:if test="${not empty p.mediaUrl}">
        <div class="mt-2">
          <a href="${pageContext.request.contextPath}${p.mediaUrl}" target="_blank">View attachment</a>
        </div>
      </c:if>
    </div>
  </c:forEach>
</div>

</body>
</html>


