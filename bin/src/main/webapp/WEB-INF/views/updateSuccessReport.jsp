<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Success Report</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

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
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        background-color: var(--light-bg);
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 20px;
    }

    .container {
        max-width: 600px;
        margin: 50px auto;
        background: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: var(--shadow-sm);
        transition: box-shadow 0.3s ease;
    }
    .container:hover {
        box-shadow: var(--shadow-md);
    }

    h1 {
        text-align: center;
        color: var(--primary-purple);
        font-weight: bold;
        margin-bottom: 20px;
    }

    label {
        font-weight: bold;
        color: var(--primary-purple);
        display: block;
        margin-top: 15px;
    }

    input, textarea {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: 1px solid var(--primary-purple-light);
        border-radius: 5px;
        font-size: 14px;
        transition: all 0.2s ease;
    }
    input:focus, textarea:focus {
        border-color: var(--primary-purple);
        outline: none;
        box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
    }

    textarea {
        height: 100px;
        resize: vertical;
    }

    .form-control-file {
        border: none;
        padding: 5px 0;
    }

    .btn-submit {
        width: 100%;
        background-color: var(--primary-purple);
        color: white;
        padding: 10px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.2s ease;
        margin-top: 20px;
    }
    .btn-submit:hover {
        background-color: var(--primary-purple-light);
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    .btn-back {
        display: block;
        width: max-content;
        margin: 20px auto 0;
        text-decoration: none;
        color: #fff;
        background-color: var(--primary-purple-light);
        padding: 8px 20px;
        border-radius: 5px;
        transition: all 0.2s ease;
        text-align: center;
    }
    .btn-back:hover {
        background-color: var(--primary-purple);
        transform: translateY(-2px);
    }

    @media (max-width: 640px) {
        .container {
            margin: 20px;
            padding: 20px;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the container */
    .container {
        animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Button ripple effect on click (micro-interaction) */
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
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-submit:active::after, .btn-back:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .btn-submit:focus-visible, .btn-back:focus-visible,
    input:focus-visible, textarea:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 5px;
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

    /* 5. Label hover effect – subtle color shift */
    label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    label:hover {
        color: var(--primary-purple-light);
        transform: translateX(2px);
    }

    /* 6. Input placeholder styling (softer) */
    input::placeholder, textarea::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    input:focus::placeholder, textarea:focus::placeholder {
        opacity: 0.6;
    }

    /* 7. Heading hover effect – subtle text shadow */
    h1 {
        transition: text-shadow 0.2s;
    }
    h1:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.15);
    }

    /* 8. Input hover effect – border darkens (preserves focus ring) */
    input:hover, textarea:hover {
        border-color: var(--primary-purple);
    }

    /* 9. Form container inner spacing polish */
    .form-control-file {
        background: rgba(123, 44, 191, 0.02);
        border-radius: 5px;
        padding: 8px;
        transition: background 0.2s;
    }
    .form-control-file:hover {
        background: rgba(123, 44, 191, 0.05);
    }

    /* 10. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>
    <div class="container">
        <h1>Update Success Report</h1>

        <form action="${pageContext.request.contextPath}/volunteer/${volunteerId}/successReports/${report.id}/update" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="description">Description:</label>
                <textarea id="description" name="description" class="form-control" required>${report.description}</textarea>
            </div>

            <div class="mb-3">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" class="form-control" value="${report.location}" required>
            </div>

            <div class="mb-3">
                <label for="date">Date:</label>
                <input type="date" id="date" name="date" class="form-control" value="${report.date}" required>
            </div>

            <div class="mb-3">
                <label>Upload Evidence:</label>
                <input type="file" name="file" class="form-control-file">
            </div>

            <button type="submit" class="btn btn-submit">Update Report</button>
        </form>

        <a href="${pageContext.request.contextPath}/volunteer/${volunteerId}/successReports" class="btn-back">Back to Success Reports</a>
    </div>
</body>
</html>

