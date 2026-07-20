<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Upload Reel</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
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
        background: var(--light-bg);
        font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    }

    .card-shell {
        max-width: 900px;
        margin: 40px auto;
        background: #fff;
        border-radius: 24px;
        box-shadow: var(--shadow-md);
        overflow: hidden;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .card-shell:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-lg);
    }

    .hero {
        padding: 28px 32px;
        background: var(--gradient-primary);
        color: #fff;
        text-align: center;
    }
    .hero h2 {
        margin: 0;
        font-weight: 800;
        font-size: 1.8rem;
        letter-spacing: -0.5px;
    }
    .hero p {
        margin: 8px 0 0;
        opacity: 0.95;
        font-weight: 500;
    }

    .body {
        padding: 32px;
    }

    .dropzone {
        border: 2px dashed var(--primary-purple-light);
        border-radius: 20px;
        padding: 24px;
        background: rgba(74, 14, 120, 0.03);
        cursor: pointer;
        transition: all 0.25s ease;
        text-align: center;
    }
    .dropzone:hover {
        background: rgba(74, 14, 120, 0.06);
        border-color: var(--primary-purple);
    }
    .dropzone.dragover {
        background: rgba(74, 14, 120, 0.1);
        border-color: var(--primary-coral);
        border-style: solid;
        box-shadow: var(--shadow-sm);
    }

    .preview {
        border-radius: 20px;
        overflow: hidden;
        background: var(--dark-bg);
        aspect-ratio: 16 / 9;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-top: 20px;
        box-shadow: var(--shadow-sm);
    }
    .preview video,
    .preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    .small-muted {
        color: var(--primary-purple-light);
        font-size: 0.85rem;
        opacity: 0.8;
    }

    @media (max-width: 768px) {
        .card-shell {
            margin: 20px;
        }
        .hero {
            padding: 20px 16px;
        }
        .hero h2 {
            font-size: 1.4rem;
        }
        .body {
            padding: 20px;
        }
        .dropzone {
            padding: 16px;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the card shell */
    .card-shell {
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

    /* 2. Custom scrollbar (matches brand purple) */
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

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .dropzone:focus-visible,
    .preview:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 20px;
    }

    /* 4. Hero text staggered fade-in */
    .hero h2 {
        animation: fadeInUp 0.6s ease-out forwards;
    }
    .hero p {
        animation: fadeInUp 0.6s ease-out 0.1s forwards;
        opacity: 0;
        animation-fill-mode: forwards;
    }
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 5. Dropzone inner icon/text hover effect (if any icons exist) */
    .dropzone i, .dropzone svg {
        transition: transform 0.2s;
    }
    .dropzone:hover i, .dropzone:hover svg {
        transform: scale(1.05);
    }

    /* 6. Preview area hover scale for media */
    .preview video, .preview img {
        transition: transform 0.2s;
    }
    .preview:hover video, .preview:hover img {
        transform: scale(1.01);
    }

    /* 7. Small muted text hover effect */
    .small-muted {
        transition: color 0.2s, opacity 0.2s;
    }
    .small-muted:hover {
        color: var(--primary-purple);
        opacity: 1;
    }

    /* 8. Responsive improvements for very small devices */
    @media (max-width: 480px) {
        .hero h2 {
            font-size: 1.2rem;
        }
        .body {
            padding: 16px;
        }
        .dropzone {
            padding: 12px;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .card-shell.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>

<body>

<div class="card-shell fdf-card">
  <div class="hero">
    <h2>${isReel ? 'Upload a Reel' : 'Upload Video'}</h2>
    <p>${isReel ? 'Share your short creative clip. Upload happens instantly with a progress bar.' : 'Upload your training or safety video. Standard YouTube-style video.'}</p>
  </div>

  <div class="body">
    <div id="alertArea"></div>

    <!-- Fallback: normal form submit still works if JS is blocked -->
    <form id="uploadForm"
          action="${pageContext.request.contextPath}/video/upload"
          method="post"
          enctype="multipart/form-data"
          class="row g-3">
      
      <input type="hidden" name="isReel" value="${isReel}">

      <div class="col-lg-7">
        <div class="mb-2">
          <label class="form-label fw-semibold">Title</label>
          <input type="text" name="title" id="title" class="form-control" maxlength="80" required>
        </div>

        <div class="mb-2">
          <label class="form-label fw-semibold">Description</label>
          <textarea name="description" id="description" class="form-control" rows="4" maxlength="500"
                    placeholder="Optional"></textarea>
          <div class="small-muted mt-1">Tip: keep it short and clear.</div>
        </div>

        <div class="row mb-2">
          <div class="col-md-6">
            <label class="form-label fw-semibold">Category</label>
            <select name="category" id="category" class="form-select">
              <option value="SELF_DEFENSE">Self Defense</option>
              <option value="WOMEN_SAFETY">Women Safety</option>
              <option value="EMERGENCY_TIPS">Emergency Tips</option>
              <option value="LEGAL_RIGHTS">Legal Rights</option>
              <option value="AWARENESS">Awareness</option>
              <option value="FITNESS">Fitness & Health</option>
              <option value="COMMUNITY_STORIES">Community Stories</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold">Privacy</label>
            <select name="isPrivate" id="isPrivate" class="form-select">
              <option value="false">Public</option>
              <option value="true">Private</option>
            </select>
          </div>
        </div>

        <div class="mb-2">
          <label class="form-label fw-semibold">Thumbnail (Optional)</label>
          <input type="file" name="thumbnail" id="thumbnail" class="form-control" accept="image/*">
        </div>

        <div class="mb-2">
          <label class="form-label fw-semibold">File</label>
          <div id="dropzone" class="dropzone">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
              <div>
                <div class="fw-semibold">Drag & drop to upload</div>
                <div class="small-muted">or click to choose a file (MP4, WEBM, JPG, PNG)</div>
              </div>
              <button type="button" class="btn btn-outline-primary btn-sm">Choose file</button>
            </div>
            <input type="file" name="file" id="file" class="form-control mt-3"
                   accept="image/*,video/*" required style="display:none;">
            <div class="small-muted mt-2" id="fileName">No file selected</div>
          </div>
        </div>

        <div class="mb-2">
          <div class="progress" style="height: 10px; display:none;" id="progressWrap">
            <div class="progress-bar" role="progressbar" style="width:0%" id="progressBar"></div>
          </div>
          <div class="small-muted mt-1" id="progressText" style="display:none;">Uploading…</div>
        </div>

        <div class="d-grid d-md-flex gap-2 mt-2">
          <button type="submit" class="btn btn-primary" id="submitBtn">Upload</button>
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/users/dashboard">Back</a>
          <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/video/myVideos">My Videos</a>
        </div>

        <c:if test="${not empty error}">
          <div class="alert alert-danger mt-3">${error}</div>
        </c:if>
      </div>

      <div class="col-lg-5">
        <div class="fw-semibold mb-2">Preview</div>
        <div class="preview" id="preview">
          <div class="small-muted">Select a file to preview</div>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- 🔴 Real-time upload acknowledgement (WebSocket) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
  (function () {
    const userId = ${sessionScope.user.id};
    const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
    const client = Stomp.over(socket);
    client.debug = null;

    client.connect({}, function () {
      client.subscribe("/topic/reels", function (frame) {
        try {
          const evt = JSON.parse(frame.body || "{}");
          if (evt.type === "NEW_UPLOAD" && evt.isReel && Number(evt.uploaderId) === Number(userId)) {
            showAlert("success", "Reel uploaded successfully!");
            setTimeout(() => window.location.href = "${pageContext.request.contextPath}/video/reels", 900);
          }
        } catch (e) {}
      });
      client.subscribe("/topic/userVideos/" + userId, function (frame) {
        try {
          const evt = JSON.parse(frame.body || "{}");
          if (evt.type === "NEW_UPLOAD" && !evt.isReel && Number(evt.uploaderId) === Number(userId)) {
            showAlert("success", "Video uploaded successfully!");
            setTimeout(() => window.location.href = "${pageContext.request.contextPath}/video/myVideos", 900);
          }
        } catch (e) {}
      });
    });
  })();
</script>

<script>
  const form = document.getElementById("uploadForm");
  const dropzone = document.getElementById("dropzone");
  const fileInput = document.getElementById("file");
  const fileName = document.getElementById("fileName");
  const preview = document.getElementById("preview");
  const submitBtn = document.getElementById("submitBtn");
  const isReelInput = document.querySelector('input[name="isReel"]');

  const progressWrap = document.getElementById("progressWrap");
  const progressBar = document.getElementById("progressBar");
  const progressText = document.getElementById("progressText");
  const alertArea = document.getElementById("alertArea");

  function showAlert(kind, text) {
    alertArea.innerHTML =
      `<div class="alert alert-${kind}">${text}</div>`;
  }

  function setUploading(isUploading) {
    submitBtn.disabled = isUploading;
    progressWrap.style.display = isUploading ? "flex" : "none";
    progressText.style.display = isUploading ? "block" : "none";
    if (!isUploading) {
      progressBar.style.width = "0%";
      progressBar.classList.remove("bg-success");
    }
  }

  function renderPreview(file) {
    preview.innerHTML = "";
    if (!file) {
      preview.innerHTML = `<div class="small-muted">Select a file to preview</div>`;
      return;
    }
    const url = URL.createObjectURL(file);
    if (file.type.startsWith("video/")) {
      const v = document.createElement("video");
      v.src = url;
      v.controls = true;
      v.autoplay = true;
      v.muted = true;
      v.loop = true;
      preview.appendChild(v);
    } else if (file.type.startsWith("image/")) {
      const img = document.createElement("img");
      img.src = url;
      preview.appendChild(img);
    } else {
      preview.innerHTML = `<div class="small-muted">No preview available for this file type.</div>`;
    }
  }

  dropzone.addEventListener("click", () => fileInput.click());
  dropzone.addEventListener("dragover", e => {
    e.preventDefault();
    dropzone.classList.add("dragover");
  });
  dropzone.addEventListener("dragleave", () => dropzone.classList.remove("dragover"));
  dropzone.addEventListener("drop", e => {
    e.preventDefault();
    dropzone.classList.remove("dragover");
    const files = e.dataTransfer.files;
    if (files.length > 0) {
      fileInput.files = files;
      fileName.textContent = files[0].name;
      renderPreview(files[0]);
    }
  });

  fileInput.addEventListener("change", () => {
    if (fileInput.files.length > 0) {
      fileName.textContent = fileInput.files[0].name;
      renderPreview(fileInput.files[0]);
    } else {
      fileName.textContent = "No file selected";
      renderPreview(null);
    }
  });

  form.addEventListener("submit", async e => {
    e.preventDefault();
    setUploading(true);

    const formData = new FormData();
    formData.append("title", document.getElementById("title").value);
    formData.append("description", document.getElementById("description").value);
    formData.append("category", document.getElementById("category").value);
    formData.append("isPrivate", document.getElementById("isPrivate").value);
    formData.append("file", fileInput.files[0]);
    formData.append("isReel", isReelInput.value); // Pass isReel value

    const thumbnailInput = document.getElementById("thumbnail");
    if (thumbnailInput.files.length > 0) {
      formData.append("thumbnail", thumbnailInput.files[0]);
    }

    try {
      const res = await fetch("${pageContext.request.contextPath}/video/uploadAjax", {
        method: "POST",
        body: formData
      });

      if (!res.ok) {
        const errorData = await res.json();
        showAlert("danger", errorData.message || "Upload failed.");
        setUploading(false);
        return;
      }

      // Success is handled by WebSocket, so just update UI
      progressBar.style.width = "100%";
      progressBar.classList.add("bg-success");
      progressText.textContent = "Upload complete!";

    } catch (err) {
      showAlert("danger", "Network error: " + err.message);
      setUploading(false);
    }
  });
</script>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>


