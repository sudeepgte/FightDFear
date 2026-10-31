/**
 * In-page reel recorder: camera capture, trim/filter edit, upload via /video/uploadAjax
 */
(function () {
  const ctx = window.REEL_STUDIO_CTX || "";
  const modalEl = document.getElementById("reelStudioModal");
  if (!modalEl) return;

  const liveVideo = document.getElementById("reelLiveVideo");
  const editVideo = document.getElementById("reelEditVideo");
  const recordBtn = document.getElementById("reelRecordBtn");
  const stopBtn = document.getElementById("reelStopBtn");
  const flipBtn = document.getElementById("reelFlipCameraBtn");
  const recIndicator = document.getElementById("reelRecIndicator");
  const recTimerEl = document.getElementById("reelRecTimer");
  const fileInput = document.getElementById("reelFileInput");
  const tabEdit = document.getElementById("tab-edit");
  const tabRecord = document.getElementById("tab-record");
  const trimStart = document.getElementById("reelTrimStart");
  const trimEnd = document.getElementById("reelTrimEnd");
  const filterSelect = document.getElementById("reelFilter");
  const publishBtn = document.getElementById("reelPublishBtn");
  const retakeBtn = document.getElementById("reelRetakeBtn");
  const reelTitle = document.getElementById("reelTitle");
  const reelDescription = document.getElementById("reelDescription");
  const reelCategory = document.getElementById("reelCategory");
  const alertArea = document.getElementById("reelStudioAlert");
  const progressWrap = document.getElementById("reelUploadProgressWrap");
  const progressBar = document.getElementById("reelUploadProgressBar");

  const MAX_SEC = 60;
  let mediaStream = null;
  let mediaRecorder = null;
  let recordedChunks = [];
  let rawBlob = null;
  let rawIsImage = false;
  let facingMode = "user";
  let recordStartedAt = 0;
  let recordTimerIv = null;

  function showAlert(type, msg) {
    if (!alertArea) return;
    alertArea.innerHTML =
      '<div class="alert alert-' + type + ' py-2 mb-0">' + msg + "</div>";
  }

  function clearAlert() {
    if (alertArea) alertArea.innerHTML = "";
  }

  function updateTrimLabels() {
    const s = document.getElementById("reelTrimStartLbl");
    const e = document.getElementById("reelTrimEndLbl");
    if (s) s.textContent = Number(trimStart.value).toFixed(1) + "s";
    if (e) e.textContent = Number(trimEnd.value).toFixed(1) + "s";
  }

  function enableEditTab() {
    tabEdit.classList.remove("disabled");
    tabEdit.removeAttribute("disabled");
    bootstrap.Tab.getOrCreateInstance(tabEdit).show();
  }

  function resetEditTab() {
    tabEdit.classList.add("disabled");
    tabEdit.setAttribute("disabled", "disabled");
    rawBlob = null;
    rawIsImage = false;
    if (editVideo) {
      editVideo.pause();
      if (editVideo.src && editVideo.src.startsWith("blob:")) {
        URL.revokeObjectURL(editVideo.src);
      }
      editVideo.removeAttribute("src");
      editVideo.load();
    }
    if (fileInput) fileInput.value = "";
  }

  async function startCamera() {
    stopCamera();
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      showAlert(
        "warning",
        "Camera not supported in this browser. Use Upload file instead."
      );
      return;
    }
    try {
      mediaStream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: facingMode,
          width: { ideal: 720 },
          height: { ideal: 1280 },
        },
        audio: true,
      });
      liveVideo.srcObject = mediaStream;
    } catch (err) {
      showAlert(
        "warning",
        "Could not open camera. Allow permission or use Upload file."
      );
    }
  }

  function stopCamera() {
    if (mediaStream) {
      mediaStream.getTracks().forEach(function (t) {
        t.stop();
      });
      mediaStream = null;
    }
    if (liveVideo) liveVideo.srcObject = null;
  }

  function goToEdit(blob, isImage) {
    rawBlob = blob;
    rawIsImage = isImage;
    enableEditTab();
    clearAlert();

    const url = URL.createObjectURL(blob);
    editVideo.style.display = "block";
    editVideo.src = url;
    applyFilterPreview();

    if (isImage) {
      trimStart.disabled = true;
      trimEnd.disabled = true;
      return;
    }

    trimStart.disabled = false;
    trimEnd.disabled = false;
    editVideo.onloadedmetadata = function () {
      const dur =
        editVideo.duration && isFinite(editVideo.duration)
          ? Math.min(editVideo.duration, MAX_SEC)
          : MAX_SEC;
      trimEnd.max = dur;
      trimStart.max = dur;
      trimEnd.value = dur;
      trimStart.value = 0;
      if (parseFloat(trimEnd.value) < parseFloat(trimStart.value)) {
        trimEnd.value = dur;
      }
      updateTrimLabels();
    };
  }

  function applyFilterPreview() {
    const f = filterSelect.value;
    editVideo.style.filter = f === "none" ? "none" : f;
  }

  function pickMimeType() {
    const types = [
      "video/webm;codecs=vp9,opus",
      "video/webm;codecs=vp8,opus",
      "video/webm",
      "video/mp4",
    ];
    for (var i = 0; i < types.length; i++) {
      if (MediaRecorder.isTypeSupported(types[i])) return types[i];
    }
    return "";
  }

  function startRecording() {
    if (!mediaStream) return;
    recordedChunks = [];
    var mime = pickMimeType();
    var options = mime ? { mimeType: mime } : undefined;
    try {
      mediaRecorder = new MediaRecorder(mediaStream, options);
    } catch (e) {
      mediaRecorder = new MediaRecorder(mediaStream);
    }
    mediaRecorder.ondataavailable = function (e) {
      if (e.data && e.data.size) recordedChunks.push(e.data);
    };
    mediaRecorder.onstop = function () {
      var type = mediaRecorder.mimeType || "video/webm";
      var blob = new Blob(recordedChunks, { type: type });
      stopCamera();
      goToEdit(blob, false);
    };
    mediaRecorder.start(250);
    recordStartedAt = Date.now();
    recIndicator.classList.add("active");
    recordBtn.classList.add("d-none");
    stopBtn.classList.remove("d-none");
    recordTimerIv = setInterval(function () {
      var s = Math.floor((Date.now() - recordStartedAt) / 1000);
      var m = Math.floor(s / 60);
      recTimerEl.textContent =
        m + ":" + String(s % 60).padStart(2, "0");
      if (s >= MAX_SEC) stopRecording();
    }, 200);
  }

  function stopRecording() {
    if (mediaRecorder && mediaRecorder.state !== "inactive") {
      mediaRecorder.stop();
    }
    clearInterval(recordTimerIv);
    recIndicator.classList.remove("active");
    recordBtn.classList.remove("d-none");
    stopBtn.classList.add("d-none");
  }

  function needsVideoProcessing() {
    if (rawIsImage) return false;
    var filter = filterSelect.value;
    var start = parseFloat(trimStart.value);
    var end = parseFloat(trimEnd.value);
    var dur = editVideo.duration && isFinite(editVideo.duration) ? editVideo.duration : MAX_SEC;
    var trimmed = end - start < dur - 0.15;
    var filtered = filter && filter !== "none";
    return trimmed || filtered;
  }

  function exportVideoWithEdits(video, start, end, filterCss) {
    var duration = Math.max(0.3, end - start);
    return new Promise(function (resolve, reject) {
      var canvas = document.createElement("canvas");
      var c = canvas.getContext("2d");
      video.muted = true;
      video.pause();
      video.currentTime = start;

      video.onseeked = function () {
        canvas.width = video.videoWidth || 720;
        canvas.height = video.videoHeight || 1280;
        var stream = canvas.captureStream(30);
        var mime = pickMimeType() || "video/webm";
        var recorder;
        try {
          recorder = new MediaRecorder(stream, { mimeType: mime });
        } catch (e) {
          recorder = new MediaRecorder(stream);
        }
        var chunks = [];
        recorder.ondataavailable = function (ev) {
          if (ev.data.size) chunks.push(ev.data);
        };
        recorder.onstop = function () {
          video.pause();
          resolve(
            new Blob(chunks, {
              type: recorder.mimeType || "video/webm",
            })
          );
        };
        recorder.start(200);
        var t0 = performance.now();

        function frame() {
          var elapsed = (performance.now() - t0) / 1000;
          if (elapsed >= duration) {
            recorder.stop();
            return;
          }
          c.filter = filterCss === "none" ? "none" : filterCss;
          c.drawImage(video, 0, 0, canvas.width, canvas.height);
          if (video.paused) video.play().catch(function () {});
          requestAnimationFrame(frame);
        }
        video.play().then(frame).catch(reject);
      };
      video.onerror = function () {
        reject(new Error("Could not process video"));
      };
    });
  }

  async function buildUploadBlob() {
    if (!rawBlob) throw new Error("No media to upload");
    if (rawIsImage) return rawBlob;
    if (rawBlob instanceof File && !needsVideoProcessing()) return rawBlob;
    if (!needsVideoProcessing()) return rawBlob;

    var start = parseFloat(trimStart.value);
    var end = parseFloat(trimEnd.value);
    if (end <= start) throw new Error("Invalid trim range");
    return exportVideoWithEdits(
      editVideo,
      start,
      end,
      filterSelect.value
    );
  }

  function uploadBlob(blob) {
    var fd = new FormData();
    fd.append("title", reelTitle.value.trim());
    fd.append("description", reelDescription.value.trim());
    fd.append("category", reelCategory.value);
    fd.append("isPrivate", "false");
    fd.append("isReel", "true");

    var ext = "webm";
    if (blob.type.indexOf("mp4") >= 0) ext = "mp4";
    else if (blob.type.indexOf("image") >= 0) {
      ext = blob.type.indexOf("png") >= 0 ? "png" : "jpg";
    }
    fd.append("file", blob, "reel." + ext);

    return new Promise(function (resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", ctx + "/video/uploadAjax");
      xhr.upload.onprogress = function (e) {
        if (e.lengthComputable && progressBar) {
          progressBar.style.width =
            Math.round((e.loaded / e.total) * 100) + "%";
        }
      };
      xhr.onload = function () {
        try {
          resolve(JSON.parse(xhr.responseText));
        } catch (e) {
          reject(new Error("Invalid server response"));
        }
      };
      xhr.onerror = function () {
        reject(new Error("Network error"));
      };
      xhr.send(fd);
    });
  }

  if (recordBtn) {
    recordBtn.addEventListener("click", function () {
      clearAlert();
      if (!mediaStream) {
        startCamera().then(function () {
          if (mediaStream) startRecording();
        });
        return;
      }
      startRecording();
    });
  }

  if (stopBtn) stopBtn.addEventListener("click", stopRecording);

  if (flipBtn) {
    flipBtn.addEventListener("click", function () {
      facingMode = facingMode === "user" ? "environment" : "user";
      if (mediaRecorder && mediaRecorder.state === "recording") return;
      startCamera();
    });
  }

  if (fileInput) {
    fileInput.addEventListener("change", function () {
      var file = fileInput.files && fileInput.files[0];
      if (!file) return;
      goToEdit(file, file.type.indexOf("image/") === 0);
    });
  }

  if (filterSelect) filterSelect.addEventListener("change", applyFilterPreview);
  if (trimStart) trimStart.addEventListener("input", updateTrimLabels);
  if (trimEnd) trimEnd.addEventListener("input", updateTrimLabels);

  if (retakeBtn) {
    retakeBtn.addEventListener("click", function () {
      resetEditTab();
      clearAlert();
      bootstrap.Tab.getOrCreateInstance(tabRecord).show();
      startCamera();
    });
  }

  if (publishBtn) {
    publishBtn.addEventListener("click", async function () {
      if (!reelTitle.value.trim()) {
        showAlert("danger", "Please enter a title.");
        return;
      }
      publishBtn.disabled = true;
      progressWrap.classList.remove("d-none");
      if (progressBar) progressBar.style.width = "0%";
      try {
        var blob = await buildUploadBlob();
        var res = await uploadBlob(blob);
        if (res.ok) {
          showAlert("success", "Reel posted successfully!");
          setTimeout(function () {
            window.location.reload();
          }, 700);
        } else if (res.error === "LOGIN_REQUIRED") {
          window.location.href = ctx + "/login";
        } else {
          showAlert(
            "danger",
            res.message || res.error || "Upload failed"
          );
          publishBtn.disabled = false;
        }
      } catch (err) {
        showAlert("danger", err.message || "Upload failed");
        publishBtn.disabled = false;
      } finally {
        progressWrap.classList.add("d-none");
      }
    });
  }

  modalEl.addEventListener("shown.bs.modal", function () {
    clearAlert();
    resetEditTab();
    bootstrap.Tab.getOrCreateInstance(tabRecord).show();
    startCamera();
  });

  modalEl.addEventListener("hidden.bs.modal", function () {
    stopRecording();
    stopCamera();
    resetEditTab();
    clearAlert();
  });
})();
