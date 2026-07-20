<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Upload Content — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
            --accent-pink: #f43f5e;
            --accent-purple: #8b5cf6;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--accent-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--accent-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
            margin-bottom: 40px;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top Bar navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--accent-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--accent-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Form Layout */
        .upload-container {
            max-width: 800px;
            margin: 0 auto 60px;
            padding: 0 15px;
        }
        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            padding: 35px;
            box-shadow: var(--shadow-sm);
        }

        .form-control, .form-select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 12px 18px;
            font-size: 14px;
            background: #ffffff;
            color: #333;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 15px rgba(244, 63, 94, 0.15);
            color: #333;
        }

        .form-label {
            font-size: 12px;
            font-weight: 700;
            color: var(--brand-purple);
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        /* Drag zone */
        .upload-dropzone {
            border: 2px dashed var(--brand-pink-light);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            background: #fffcfd;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .upload-dropzone:hover {
            border-color: var(--accent-pink);
            background: rgba(244, 63, 94, 0.02);
        }
        .upload-icon {
            font-size: 40px;
            color: var(--accent-pink);
            margin-bottom: 15px;
        }

        /* Toggle switches list */
        .toggle-switch-card {
            background: #fafafb;
            border: 1px solid var(--fdf-border);
            border-radius: 16px;
            padding: 15px 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .form-check-input {
            width: 2.8em;
            height: 1.5em;
            background-color: #e4e4e7;
            border-color: transparent;
            cursor: pointer;
        }
        .form-check-input:checked {
            background-color: var(--accent-pink);
            border-color: var(--accent-pink);
        }

        /* Scan Overlay */
        .scan-overlay {
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(255, 255, 255, 0.98);
            z-index: 2000;
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            text-align: center;
        }
        .scan-radar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 2px solid var(--accent-pink);
            position: relative;
            animation: radar-pulse 1.5s infinite linear;
            margin-bottom: 25px;
        }
        @keyframes radar-pulse {
            0% { transform: scale(0.6); opacity: 1; }
            100% { transform: scale(1.4); opacity: 0; }
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/creator-hub" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-arrow-left"></i> Back to Hub
                </a>
            </div>
            
            <h1>Upload Creation</h1>
            <p>Share reels, long videos, stories, or images. Choose monetization structures, refer items, and trigger AI Moderation checks before publishing.</p>
        </div>

        <div class="upload-container">
            <div class="glass-card" data-aos="fade-up">
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-4 border-0 shadow-sm mb-4">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/creator-hub/upload" method="POST" enctype="multipart/form-data" id="uploadForm">
                    
                    <!-- Format Selector -->
                    <div class="mb-4">
                        <label class="form-label">Select Format</label>
                        <select name="uploadType" id="uploadType" class="form-select">
                            <option value="REEL">Short Reel (Vertical Video)</option>
                            <option value="LONG_VIDEO">Standard Video (Educational/Vlog)</option>
                            <option value="IMAGE">Image Post</option>
                            <option value="STORY">24h Expiring Story</option>
                        </select>
                    </div>

                    <!-- Dropzone -->
                    <div class="mb-4">
                        <label class="form-label">Upload Media File</label>
                        <div class="upload-dropzone" onclick="document.getElementById('fileInput').click()">
                            <i class="fa-solid fa-circle-play upload-icon" id="dropzoneIcon"></i>
                            <h6 class="fw-bold text-dark mb-1" id="dropzoneText">Drag &amp; Drop or Click to Upload</h6>
                            <p class="text-muted small mb-0" id="dropzoneSub">MP4, JPG, PNG or WEBP formats accepted</p>
                            <input type="file" name="file" id="fileInput" class="d-none" required onchange="handleFileSelected(this)">
                        </div>
                        <div id="filePreview" class="mt-3 text-center" style="display: none;">
                            <span class="badge bg-success py-2 px-3 rounded-pill">
                                <i class="fa-solid fa-circle-check me-2"></i>Selected File: <span id="fileName"></span>
                            </span>
                        </div>
                    </div>

                    <!-- Video Thumbnail (long videos) -->
                    <div class="mb-4" id="thumbGroup">
                        <label class="form-label">Upload Video Thumbnail (Optional)</label>
                        <input type="file" name="thumbnail" class="form-control" accept="image/*">
                    </div>

                    <!-- Title -->
                    <div class="mb-4" id="titleGroup">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" id="titleInput" class="form-control" placeholder="Describe the title of your content..." required>
                    </div>

                    <!-- Description -->
                    <div class="mb-4">
                        <label class="form-label" id="descLabel">Caption / Description</label>
                        <textarea name="description" id="descriptionInput" rows="4" class="form-control" placeholder="Share educational content summary, safety guidelines, tips, or inspirational text..." required></textarea>
                    </div>

                    <!-- Category -->
                    <div class="mb-4" id="catGroup">
                        <label class="form-label">Category</label>
                        <select name="category" class="form-select">
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}">${cat}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Location & Hashtags -->
                    <div class="row mb-4" id="locHashGroup">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <label class="form-label">Add Location</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g. Mumbai, Maharashtra">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hashtags</label>
                            <input type="text" name="hashtags" id="hashtagsInput" class="form-control" placeholder="e.g. #womensafety #entrepreneur">
                        </div>
                    </div>

                    <!-- Monetization Switches -->
                    <div class="mb-4" id="monetizationGroup">
                        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-coins text-warning me-2"></i>Monetization &amp; Privacy Settings</h5>
                        
                        <!-- Subscriber Only -->
                        <div class="toggle-switch-card">
                            <div>
                                <span class="d-block fw-bold text-dark">Subscriber Only</span>
                                <span class="text-muted small">Only monthly paying subscribers can view this content.</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isSubscriberOnly" value="true">
                            </div>
                        </div>

                        <!-- Paid Course -->
                        <div class="toggle-switch-card">
                            <div>
                                <span class="d-block fw-bold text-dark">Paid Educational Course / Video</span>
                                <span class="text-muted small">Set a direct unlock fee for this premium instructional video.</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isPaidContent" value="true" id="isPaidCheck" onchange="togglePriceField(this)">
                            </div>
                        </div>

                        <!-- Unlock Price -->
                        <div class="mb-3" id="priceFieldGroup" style="display: none; padding-left: 20px;">
                            <label class="form-label">Unlock Price (Rs.)</label>
                            <input type="number" step="1" min="10" name="price" class="form-control" placeholder="e.g. 199" style="max-width: 200px;">
                        </div>

                        <!-- Affiliate Link -->
                        <div class="toggle-switch-card">
                            <div>
                                <span class="d-block fw-bold text-dark">Affiliate Marketing Link</span>
                                <span class="text-muted small">Add an external product affiliate link below the video caption.</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="affiliateCheck" onchange="toggleAffiliateField(this)">
                            </div>
                        </div>

                        <!-- Product Link URL -->
                        <div class="mb-3" id="affiliateFieldGroup" style="display: none; padding-left: 20px;">
                            <label class="form-label">Product Affiliate Link URL</label>
                            <input type="url" name="affiliateLink" class="form-control" placeholder="https://amazon.com/product-referral...">
                        </div>
                    </div>

                    <!-- Draft -->
                    <div class="toggle-switch-card mb-4" id="draftGroup">
                        <div>
                            <span class="d-block fw-bold text-dark">Save as Draft</span>
                            <span class="text-muted small">Keep this content private in your studio. Publish later.</span>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isDraft" value="true">
                        </div>
                    </div>

                    <!-- Submit -->
                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-danger py-3 rounded-pill shadow-sm font-weight-bold" style="font-size: 16px; background: var(--gradient-primary); border: none;">
                            <i class="fa-solid fa-paper-plane me-2"></i> Submit and Moderation Scan
                        </button>
                    </div>

                </form>

            </div>
        </div>

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- AI MODERATION RADAR SIMULATION OVERLAY -->
<div class="scan-overlay" id="scanOverlay">
    <div class="scan-radar"></div>
    <h4 class="fw-bold text-dark mb-2">AI Content Safety Guard Active</h4>
    <p class="text-muted px-4" style="max-width: 500px;">
        Scanning video transcripts, metadata, captions, and tags for cyberbullying, hate speech, spam, and inappropriate safety violations...
    </p>
</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });

    // Format adjustments
    document.getElementById('uploadType').addEventListener('change', function() {
        const format = this.value;
        const thumbGroup = document.getElementById('thumbGroup');
        const titleGroup = document.getElementById('titleGroup');
        const locHashGroup = document.getElementById('locHashGroup');
        const draftGroup = document.getElementById('draftGroup');
        const monetGroup = document.getElementById('monetizationGroup');
        const catGroup = document.getElementById('catGroup');
        const fileInput = document.getElementById('fileInput');

        if (format === 'STORY') {
            thumbGroup.style.display = 'none';
            titleGroup.style.display = 'none';
            locHashGroup.style.display = 'none';
            monetGroup.style.display = 'none';
            catGroup.style.display = 'none';
            document.getElementById('descLabel').innerText = 'Story Caption';
            document.getElementById('dropzoneIcon').className = 'fa-solid fa-camera upload-icon';
            document.getElementById('titleInput').required = false;
        } else if (format === 'IMAGE') {
            thumbGroup.style.display = 'none';
            titleGroup.style.display = 'block';
            locHashGroup.style.display = 'flex';
            monetGroup.style.display = 'block';
            catGroup.style.display = 'block';
            document.getElementById('descLabel').innerText = 'Post Caption';
            document.getElementById('dropzoneIcon').className = 'fa-solid fa-image upload-icon';
            document.getElementById('titleInput').required = true;
        } else { // Reels / Long Videos
            thumbGroup.style.display = 'block';
            titleGroup.style.display = 'block';
            locHashGroup.style.display = 'flex';
            monetGroup.style.display = 'block';
            catGroup.style.display = 'block';
            document.getElementById('descLabel').innerText = 'Video Description';
            document.getElementById('dropzoneIcon').className = 'fa-solid fa-circle-play upload-icon';
            document.getElementById('titleInput').required = true;
        }
    });

    function handleFileSelected(input) {
        const filePreview = document.getElementById('filePreview');
        const fileName = document.getElementById('fileName');
        const dropText = document.getElementById('dropzoneText');
        
        if (input.files && input.files[0]) {
            const file = input.files[0];
            fileName.innerText = file.name + ' (' + (file.size / (1024 * 1024)).toFixed(2) + ' MB)';
            filePreview.style.display = 'block';
            dropText.innerText = 'File Selected!';
        }
    }

    function togglePriceField(checkbox) {
        const group = document.getElementById('priceFieldGroup');
        group.style.display = checkbox.checked ? 'block' : 'none';
    }

    function toggleAffiliateField(checkbox) {
        const group = document.getElementById('affiliateFieldGroup');
        group.style.display = checkbox.checked ? 'block' : 'none';
    }

    // Intercept upload to show AI safety scan animation
    document.getElementById('uploadForm').addEventListener('submit', function(e) {
        document.getElementById('scanOverlay').style.display = 'flex';
    });
</script>

</body>
</html>
