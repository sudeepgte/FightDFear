<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Video — Fight D Fear</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800&display=swap" rel="stylesheet">

   <style>
    :root {
        --primary: #F43F5E;
        --primary-hover: #E11D48;
        --navy: #1E1B4B;
        --navy-dark: #0F172A;
        --text-gray: #64748B;
        --bg-page: #F8FAFC;
        --card-bg: #FFFFFF;
        --border-color: #E2E8F0;
        --rose-soft: #FFE4E6;
        --error: #DC2626;
        --error-bg: #FEF2F2;
        --gradient-primary: linear-gradient(135deg, #1E1B4B 0%, #312E81 100%);
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        background-color: var(--bg-page);
        font-family: 'Poppins', -apple-system, sans-serif;
        color: var(--navy-dark);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        padding: 24px 16px;
    }

    .upload-container {
        background: var(--card-bg);
        padding: 36px 30px;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
        width: 100%;
        max-width: 500px;
        text-align: center;
        animation: fadeInScale 0.35s ease-out;
        border: 1px solid var(--border-color);
    }

    @keyframes fadeInScale {
        from { opacity: 0; transform: scale(0.96) translateY(8px); }
        to { opacity: 1; transform: scale(1) translateY(0); }
    }

    .header-icon {
        width: 60px;
        height: 60px;
        border-radius: 18px;
        background: var(--rose-soft);
        color: var(--primary);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 1.6rem;
        margin-bottom: 12px;
    }

    h2 {
        font-family: 'Montserrat', sans-serif;
        font-size: 1.4rem;
        margin-bottom: 6px;
        font-weight: 800;
        color: var(--navy-dark);
    }

    .sub-text {
        font-size: 0.88rem;
        color: var(--text-gray);
        margin-bottom: 24px;
    }

    .form-group {
        margin-bottom: 20px;
        text-align: left;
    }

    label {
        font-size: 0.78rem;
        font-weight: 700;
        margin-bottom: 8px;
        display: block;
        color: var(--text-gray);
        text-transform: uppercase;
        letter-spacing: 0.04em;
    }

    input[type="text"], 
    select, 
    input[type="file"] {
        width: 100%;
        padding: 12px 14px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        background-color: #fff;
        font-size: 0.95rem;
        color: var(--navy-dark);
        transition: all 0.2s ease;
        outline: none;
    }

    input[type="text"]:focus, 
    select:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
    }

    input[type="file"] {
        padding: 10px;
        background: #F8FAFC;
        cursor: pointer;
    }

    input[type="file"]::file-selector-button {
        background-color: var(--navy);
        color: white;
        border: none;
        padding: 8px 14px;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.85rem;
        margin-right: 12px;
        cursor: pointer;
        transition: background 0.2s;
    }

    input[type="file"]:hover::file-selector-button {
        background-color: var(--primary);
    }

    .btn-submit {
        background: var(--primary);
        color: white;
        font-size: 1rem;
        padding: 14px;
        margin-top: 10px;
        border-radius: 12px;
        width: 100%;
        border: none;
        font-weight: 700;
        transition: all 0.25s ease;
        cursor: pointer;
        box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .btn-submit:hover {
        background: var(--primary-hover);
        transform: translateY(-1px);
    }

    .radio-group {
        display: flex;
        gap: 16px;
        margin-top: 6px;
    }

    .radio-option {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 11px 14px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        cursor: pointer;
        font-weight: 600;
        font-size: 0.9rem;
        color: var(--navy-dark);
        background: #FFFFFF;
        transition: all 0.2s ease;
    }

    .radio-option:has(input:checked) {
        border-color: var(--primary);
        background: var(--rose-soft);
        color: var(--primary);
    }

    .radio-option input[type="radio"] {
        accent-color: var(--primary);
        cursor: pointer;
    }

    .back-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        font-size: 0.88rem;
        color: var(--text-gray);
        background: #fff;
        padding: 12px 18px;
        border-radius: 12px;
        margin-top: 18px;
        font-weight: 600;
        transition: all 0.2s;
        border: 1px solid var(--border-color);
        width: 100%;
    }

    .back-btn:hover {
        background-color: #F1F5F9;
        color: var(--navy-dark);
    }

    .error-alert {
        background: var(--error-bg);
        border: 1px solid #FECACA;
        color: var(--error);
        padding: 12px 14px;
        border-radius: 12px;
        font-size: 0.85rem;
        margin-bottom: 18px;
        text-align: left;
        display: none;
    }

    .file-hint {
        font-size: 0.76rem;
        color: var(--text-gray);
        margin-top: 6px;
        display: block;
        text-align: left;
    }

    @media (max-width: 480px) {
        .upload-container { padding: 26px 18px; border-radius: 16px; }
        h2 { font-size: 1.25rem; }
    }
</style>
</head>
<body>

<div class="upload-container">
    <div class="header-icon"><i class="bi bi-cloud-arrow-up-fill"></i></div>
    <h2>Upload Video / Reel</h2>
    <p class="sub-text">Share self-defense techniques, safety tips & community reels</p>

    <c:if test="${not empty message}">
        <div class="alert alert-info rounded-3 text-start small mb-3">
            <i class="bi bi-info-circle-fill me-1"></i> ${message}
        </div>
    </c:if>

    <div id="jsErrorAlert" class="error-alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i> <span id="jsErrorText"></span>
    </div>

    <form action="${pageContext.request.contextPath}/video/uploadingVideo${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" id="videoUploadForm" onsubmit="return validateVideoForm(event)">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </c:if>

        <div class="form-group">
            <label for="title">Video Title *</label>
            <input type="text" name="title" id="title" placeholder="Enter a descriptive video title" required minlength="3" maxlength="150">
        </div>

        <div class="form-group">
            <label>Upload Format *</label>
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
            <label for="category">Category *</label>
            <select name="category" id="category" required>
                <c:forEach var="category" items="${categories}">
                    <option value="${category}">${category}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="videoFile">Select Video File *</label>
            <input type="file" name="videoFile" id="videoFile" accept="video/mp4,video/quicktime,video/webm,video/x-matroska,video/avi" required>
            <span class="file-hint"><i class="bi bi-file-earmark-play me-1"></i> Supported: MP4, MOV, WebM, MKV, AVI (Max 200MB)</span>
        </div>

        <button type="submit" class="btn-submit">
            <i class="bi bi-upload"></i> Start Upload
        </button>
    </form>

    <c:choose>
        <c:when test="${not empty sessionScope.admin}">
            <a href="${pageContext.request.contextPath}/video/videoManagement" class="back-btn">
                <i class="bi bi-arrow-left"></i> Back to Video Library
            </a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/video/allVideos" class="back-btn">
                <i class="bi bi-arrow-left"></i> Back to Video Gallery
            </a>
        </c:otherwise>
    </c:choose>
</div>

<script>
function showJsError(msg) {
    var alertBox = document.getElementById('jsErrorAlert');
    var textSpan = document.getElementById('jsErrorText');
    textSpan.textContent = msg;
    alertBox.style.display = 'block';
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function validateVideoForm(e) {
    var alertBox = document.getElementById('jsErrorAlert');
    alertBox.style.display = 'none';

    var title = (document.getElementById('title').value || '').trim();
    var fileInput = document.getElementById('videoFile');
    var category = document.getElementById('category').value;

    if (!title || title.length < 3) {
        showJsError('Video Title is required and must be at least 3 characters.');
        e.preventDefault();
        return false;
    }

    if (/^\d+$/.test(title)) {
        showJsError('Video Title cannot be numbers only. Please enter a meaningful title containing letters.');
        e.preventDefault();
        return false;
    }

    if (!category) {
        showJsError('Please select a valid video category.');
        e.preventDefault();
        return false;
    }

    if (!fileInput.files || fileInput.files.length === 0) {
        showJsError('Please select a video file to upload.');
        e.preventDefault();
        return false;
    }

    var file = fileInput.files[0];
    var fileName = file.name.toLowerCase();
    var validExts = ['.mp4', '.mov', '.webm', '.mkv', '.avi'];
    var isValidExt = validExts.some(function(ext) { return fileName.endsWith(ext); });

    if (!isValidExt) {
        showJsError('Unsupported file format. Allowed formats: MP4, MOV, WebM, MKV, AVI.');
        e.preventDefault();
        return false;
    }

    var maxBytes = 200 * 1024 * 1024; // 200MB
    if (file.size > maxBytes) {
        var sizeMB = (file.size / (1024 * 1024)).toFixed(1);
        showJsError('File size (' + sizeMB + 'MB) exceeds the maximum allowed limit of 200MB.');
        e.preventDefault();
        return false;
    }

    return true;
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
