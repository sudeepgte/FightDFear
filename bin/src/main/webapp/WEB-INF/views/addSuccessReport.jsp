<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Success Report</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    body {
        background: linear-gradient(to right, #f3d9ff, #f8edff);
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 0;
    }

    .container {
        max-width: 650px;
        background: #fff;
        margin: 60px auto;
        padding: 40px;
        border-radius: 15px;
        box-shadow: 0 6px 20px rgba(142, 68, 173, 0.2);
    }

    h1 {
        font-size: 2rem;
        text-align: center;
        color: #312e81;
        margin-bottom: 30px;
        font-family: 'Playfair Display', serif;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
    }

    h1 i {
        color: #312e81;
    }

    label {
        font-weight: 600;
        color: #6a0572;
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 6px;
    }

    .form-control,
    input[type="file"] {
        padding: 10px;
        border: 1px solid #cba8f7;
        border-radius: 8px;
        background-color: #f6efff;
        color: #4a148c;
        font-size: 15px;
    }

    textarea.form-control {
        resize: vertical;
        height: 120px;
    }

    .btn-submit {
        width: 100%;
        background-color: #312e81;
        color: white;
        font-weight: 600;
        padding: 12px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        transition: background 0.3s ease;
        margin-top: 10px;
    }

    .btn-submit:hover {
        background-color: #5a189a;
    }

   .btn-back {
        background-color: #312e81;
        border: none;
        color: white;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 500;
        font-size: 15px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 10px rgba(142, 68, 173, 0.2);
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .btn-back:hover {
        background-color: #5a189a;
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .container {
            padding: 25px;
            margin: 40px 15px;
        }
        h1 {
            font-size: 1.6rem;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the container */
    .container {
        animation: slideUpFade 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes slideUpFade {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Input focus enhancement (glow + border) */
    .form-control:focus,
    input[type="file"]:focus {
        border-color: #312e81;
        outline: none;
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        transition: all 0.2s;
    }

    /* 3. Label hover effect */
    label {
        transition: color 0.2s, transform 0.2s;
    }
    label:hover {
        color: #9b4dca;
        transform: translateX(2px);
    }

    /* 4. Button ripple effect on click (micro-interaction) */
    .btn-submit, .btn-back {
        position: relative;
        overflow: hidden;
    }
    .btn-submit::after, .btn-back::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
    }
    .btn-submit:active::after, .btn-back:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Hover lift for buttons (already partly present, but we add shadow increase) */
    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 18px rgba(123, 44, 191, 0.3);
    }
    .btn-back:hover {
        box-shadow: 0 8px 18px rgba(123, 44, 191, 0.3);
    }

    /* 6. Focus outlines for accessibility (keyboard navigation) */
    .btn-submit:focus-visible,
    .btn-back:focus-visible,
    .form-control:focus-visible {
        outline: 3px solid #ffd700;
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 7. Custom scrollbar (matches purple theme) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: #f3e5ff;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: #312e81;
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: #5a189a;
    }

    /* 8. Add a subtle transition to the container shadow */
    .container {
        transition: box-shadow 0.3s, transform 0.2s;
    }
    .container:hover {
        box-shadow: 0 12px 28px rgba(142, 68, 173, 0.25);
    }

    /* 9. Enhance file input button styling (if supported) */
    input[type="file"]::file-selector-button {
        background-color: #312e81;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 6px 12px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.2s;
    }
    input[type="file"]::file-selector-button:hover {
        background-color: #5a189a;
    }

    /* 10. Responsive touch target improvements for mobile */
    @media (max-width: 768px) {
        .btn-submit, .btn-back {
            padding: 14px 20px;
            font-size: 1rem;
        }
        .form-control, input[type="file"] {
            padding: 12px;
            font-size: 16px; /* prevents zoom on iOS */
        }
    }
</style>
</head>
<body>
    <div class="container">
     <h1><i class="fas fa-check-circle"></i> Add Success Report</h1>

        <form action="${pageContext.request.contextPath}/volunteer/${volunteerId}/addSuccessReport" method="post" enctype="multipart/form-data">
            <div class="mb-3">
    <label for="description"><i class="fas fa-align-left"></i> Description:</label>
    <textarea id="description" name="description" class="form-control" required></textarea>
</div>

<div class="mb-3">
    <label for="location"><i class="fas fa-map-marker-alt"></i> Location:</label>
    <input type="text" id="location" name="location" class="form-control" required>
</div>

<div class="mb-3">
    <label for="date"><i class="fas fa-calendar-alt"></i> Date:</label>
    <input type="date" id="date" name="date" class="form-control" required>
</div>

<div class="mb-3">
    <label><i class="fas fa-upload"></i> Upload Evidence:</label>
    <input type="file" name="file" class="form-control">
</div>
            <button type="submit" class="btn btn-submit">Submit</button>
        </form>

       <div class="d-flex justify-content-center gap-3 mt-4 flex-wrap">
    <a href="${pageContext.request.contextPath}/volunteer/${volunteerId}/successReports" class="btn btn-back">
        <i class="fas fa-list"></i> Success Reports
    </a>
    <a href="${pageContext.request.contextPath}/volunteer/dashboard" class="btn btn-back">
        <i class="fas fa-home"></i> Dashboard
    </a>
</div>

    </div>
</body>
</html>

