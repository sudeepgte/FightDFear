<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Video — Fight D Fear Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

   <style>
    :root {
        --maroon:        #1e1b4b;
        --maroon-light:  #312e81;
        --maroon-dark:   #0b0920;
        --maroon-pale:   #f8fafc;
        --maroon-border: rgba(30, 27, 75, 0.12);
        --gradient-maroon: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
        --shadow-sm: 0 10px 30px rgba(125,42,90,0.08);
        --shadow-md: 0 20px 40px rgba(125,42,90,0.12);
    }

    body {
        background-color: var(--maroon-pale);
        font-family: 'Poppins', sans-serif;
        color: #1a1a2e;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
        padding: 20px;
    }

    .upload-container {
        background: #ffffff;
        padding: 40px;
        border-radius: 20px;
        box-shadow: var(--shadow-md);
        width: 100%;
        max-width: 480px;
        text-align: center;
        animation: fadeInScale 0.4s ease-out;
        border: 1px solid var(--maroon-border);
    }

    @keyframes fadeInScale {
        from { opacity: 0; transform: scale(0.95) translateY(10px); }
        to { opacity: 1; transform: scale(1) translateY(0); }
    }

    h2 {
        font-size: 24px;
        margin-bottom: 30px;
        font-weight: 700;
        color: var(--maroon-dark);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .alert {
        border-radius: 12px;
        font-size: 0.9rem;
        margin-bottom: 20px;
    }

    .form-group {
        margin-bottom: 20px;
        text-align: left;
    }

    label {
        font-size: 0.85rem;
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
        color: var(--maroon);
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    input[type="text"], 
    select, 
    input[type="file"] {
        width: 100%;
        padding: 12px 16px;
        border: 2px solid var(--maroon-border);
        border-radius: 10px;
        background-color: #fff;
        font-size: 0.95rem;
        color: #374151;
        transition: all 0.2s ease;
        outline: none;
    }

    input[type="text"]:focus, 
    select:focus {
        border-color: var(--maroon);
        box-shadow: 0 0 0 4px rgba(125, 42, 90, 0.1);
        background-color: #fff;
    }

    input[type="file"] {
        padding: 8px;
        background: #fdfdfd;
        cursor: pointer;
    }

    input[type="file"]::file-selector-button {
        background-color: var(--maroon);
        color: white;
        border: none;
        padding: 6px 14px;
        border-radius: 6px;
        font-weight: 600;
        font-size: 0.85rem;
        margin-right: 10px;
        cursor: pointer;
        transition: background 0.2s;
    }

    input[type="file"]:hover::file-selector-button {
        background-color: var(--maroon-light);
    }

    .btn-submit {
        background: var(--gradient-maroon);
        color: white;
        font-size: 1rem;
        padding: 12px;
        margin-top: 10px;
        border-radius: 12px;
        width: 100%;
        border: none;
        font-weight: 700;
        transition: all 0.3s ease;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(125, 42, 90, 0.2);
    }

    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(125, 42, 90, 0.3);
        background: var(--maroon-light);
    }

    .radio-group {
        display: flex;
        gap: 20px;
        margin-top: 10px;
    }

    .radio-option {
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        font-weight: 500;
        color: #4b5563;
    }

    .radio-option input[type="radio"] {
        width: 18px;
        height: 18px;
        accent-color: var(--maroon);
        cursor: pointer;
    }

    .btn-submit:active {
        transform: translateY(0);
    }

    .back-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        font-size: 0.9rem;
        color: #6b7280;
        background: #fff;
        padding: 12px;
        border-radius: 12px;
        margin-top: 15px;
        font-weight: 600;
        transition: all 0.2s;
        border: 1px solid #e5e7eb;
    }

    .back-btn:hover {
        background-color: #f9fafb;
        color: var(--maroon);
        border-color: var(--maroon-border);
    }

    /* Accessibility for keyboard users */
    .btn-submit:focus-visible, 
    .back-btn:focus-visible {
        outline: 3px solid var(--maroon-light);
        outline-offset: 2px;
    }

    /* Small screens padding */
    @media (max-width: 480px) {
        .upload-container {
            padding: 30px 20px;
        }
    }
</style>
</head>
<body>

<div class="upload-container">
    <h2><i class="fas fa-cloud-upload-alt"></i> Upload Video</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i> ${message}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/video/uploadingVideo" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="title">Video Title</label>
            <input type="text" name="title" id="title" placeholder="Enter a descriptive title" required>
        </div>

        <div class="form-group">
            <label>Upload Type</label>
            <div class="radio-group">
                <label class="radio-option">
                    <input type="radio" name="isReel" value="false" checked>
                    <span>Video</span>
                </label>
                <label class="radio-option">
                    <input type="radio" name="isReel" value="true">
                    <span>Reel</span>
                </label>
            </div>
        </div>

        <div class="form-group">
            <label for="category">Category</label>
            <select name="category" id="category">
                <c:forEach var="category" items="${categories}">
                    <option value="${category}">${category}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="videoFile">Select Video File</label>
            <input type="file" name="videoFile" id="videoFile" accept="video/*" required>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-upload me-2"></i> Start Upload
        </button>
    </form>

    <c:choose>
        <c:when test="${not empty sessionScope.admin}">
            <a href="${pageContext.request.contextPath}/video/videoManagement" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Video Library
            </a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/video/allVideos" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Video Gallery
            </a>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>


