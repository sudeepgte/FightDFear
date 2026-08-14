<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Event — Women Events Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; color: #1a1a2e; }
        .page-header { background: linear-gradient(135deg, #1e1b4b, #a855f7); padding: 50px 20px; color: white; text-align: center; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 6px; }
        .form-container { max-width: 860px; margin: -30px auto 60px; padding: 0 20px; }
        .form-card { background: white; border-radius: 24px; padding: 40px;
            box-shadow: 0 20px 60px rgba(124,45,94,0.1); }
        .section-title { font-size: 1.05rem; font-weight: 700; color: #1e1b4b; margin: 28px 0 16px;
            display: flex; align-items: center; gap: 8px; border-bottom: 2px solid #f0e8f5; padding-bottom: 10px; }
        .section-title:first-child { margin-top: 0; }
        .form-group { margin-bottom: 18px; }
        .form-label { display: block; font-weight: 600; font-size: 0.88rem; color: #555; margin-bottom: 6px; }
        .form-label .req { color: #e11d48; margin-left: 2px; }
        .form-control, .form-select {
            width: 100%; border: 1.5px solid #e5e7eb; border-radius: 12px; padding: 12px 16px;
            font-family: 'Outfit', sans-serif; font-size: 0.95rem; outline: none; transition: border-color 0.2s;
            background: #fafafa; }
        .form-control:focus, .form-select:focus { border-color: #1e1b4b; background: white; }
        textarea.form-control { resize: vertical; min-height: 120px; }

        .upload-zone { border: 2px dashed #d8b4fe; border-radius: 14px; padding: 30px;
            text-align: center; cursor: pointer; transition: all 0.2s; background: #fdf5ff; }
        .upload-zone:hover { background: #f5f0ff; border-color: #a855f7; }
        .upload-preview { max-width: 100%; max-height: 200px; border-radius: 12px; margin-top: 12px; display: none; }

        .submit-btn { width: 100%; background: linear-gradient(135deg, #1e1b4b, #a855f7); color: white;
            border: none; border-radius: 14px; padding: 18px; font-family: 'Outfit', sans-serif;
            font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; margin-top: 24px; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(124,45,94,0.35); }

        .fee-toggle { display: flex; gap: 12px; margin-bottom: 12px; }
        .fee-toggle label { display: flex; align-items: center; gap: 8px; cursor: pointer;
            padding: 10px 18px; border-radius: 10px; border: 1.5px solid #e5e7eb; font-weight: 600;
            font-size: 0.9rem; transition: all 0.2s; }
        .fee-toggle input { display: none; }
        .fee-toggle input:checked + span { color: #1e1b4b; }
        .fee-toggle label:has(input:checked) { border-color: #1e1b4b; background: #fdf5ff; color: #1e1b4b; }

        .hint { font-size: 0.78rem; color: #aaa; margin-top: 4px; }
        .row { display: flex; gap: 16px; }
        .row .form-group { flex: 1; }
        @media (max-width: 600px) { .row { flex-direction: column; } }

        .alert-info-box { background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 12px;
            padding: 14px 18px; font-size: 0.88rem; color: #075985; margin-bottom: 20px; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show m-3 rounded-3">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="page-header">
    <h1><i class="bi bi-calendar-plus-fill me-2"></i>Create a Women's Event</h1>
    <p style="opacity:0.85; margin:0;">Fill in the details below. Your event will be reviewed by our admin team.</p>
</div>

<div class="form-container">
    <div class="form-card">

        <div class="alert-info-box">
            <i class="bi bi-info-circle-fill me-2"></i>
            Your event will be submitted for admin approval. Once approved, it will be publicly listed on the platform.
        </div>

        <form action="${pageContext.request.contextPath}/women-events/organizer/create" method="post" enctype="multipart/form-data">

            <!-- Basic Info -->
            <div class="section-title"><i class="bi bi-info-circle-fill"></i>Basic Information</div>

            <div class="form-group">
                <label class="form-label">Event Name <span class="req">*</span></label>
                <input type="text" name="name" class="form-control" required placeholder="e.g., Women's Day Yoga & Wellness Camp"/>
            </div>

            <div class="row">
                <div class="form-group">
                    <label class="form-label">Category <span class="req">*</span></label>
                    <select name="category" class="form-select" required>
                        <option value="">Select Category</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat.displayName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Organizer Type <span class="req">*</span></label>
                    <select name="organizerType" class="form-select" required>
                        <option value="">Select Type</option>
                        <option value="NGO">NGO</option>
                        <option value="Government">Government</option>
                        <option value="College">College / University</option>
                        <option value="Company">Company</option>
                        <option value="Community">Community</option>
                        <option value="Gym">Gym / Fitness Centre</option>
                        <option value="Hospital">Hospital / Clinic</option>
                        <option value="Fitness Trainer">Fitness Trainer</option>
                        <option value="Women Entrepreneur">Women Entrepreneur</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Organizer / Organization Name <span class="req">*</span></label>
                <input type="text" name="organizerName" class="form-control" required placeholder="e.g., She Leads Foundation"/>
            </div>

            <div class="form-group">
                <label class="form-label">Event Description <span class="req">*</span></label>
                <textarea name="description" class="form-control" required rows="6"
                          placeholder="Describe your event — what will happen, who should attend, what they'll gain..."></textarea>
            </div>

            <!-- Date & Time -->
            <div class="section-title"><i class="bi bi-clock-fill"></i>Date, Time & Location</div>

            <div class="row">
                <div class="form-group">
                    <label class="form-label">Event Date <span class="req">*</span></label>
                    <input type="date" name="eventDate" class="form-control" required/>
                </div>
                <div class="form-group">
                    <label class="form-label">Event Time</label>
                    <input type="time" name="eventTime" class="form-control"/>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <input type="checkbox" name="virtual" value="true" onchange="toggleVirtual(this)" style="width:20px; height:20px;"/>
                    <span>💻 This is a Virtual / Online Event</span>
                </label>
            </div>

            <div class="form-group" id="streamLinkGroup" style="display:none;">
                <label class="form-label">Live Stream / Meeting Link</label>
                <input type="url" name="streamLink" class="form-control" placeholder="e.g., Zoom link, Google Meet, YouTube stream URL"/>
                <div class="hint">Only registered attendees will be able to access this link.</div>
            </div>

            <div class="row" id="locationFields">
                <div class="form-group">
                    <label class="form-label">Venue / Location <span class="req">*</span></label>
                    <input type="text" name="venue" id="venueField" class="form-control" required placeholder="e.g., City Community Hall, 3rd Floor"/>
                </div>
                <div class="form-group">
                    <label class="form-label">City <span class="req">*</span></label>
                    <input type="text" name="city" id="cityField" class="form-control" required placeholder="e.g., Mumbai"/>
                </div>
            </div>

            <div class="form-group" id="mapsFieldGroup">
                <label class="form-label">Google Maps Location / Address</label>
                <input type="text" name="mapsLocation" class="form-control" placeholder="Paste maps link or address for embedded map"/>
                <div class="hint">This will show an embedded map on the event page.</div>
            </div>

            <!-- Fee -->
            <div class="section-title"><i class="bi bi-cash-coin"></i>Entry Fee, Booth Booking & Capacity</div>

            <div class="row">
                <div class="form-group">
                    <label class="form-label">Entry Fee</label>
                    <div class="fee-toggle">
                        <label><input type="radio" name="isFree" value="true" id="freeRadio" onchange="toggleFee(true)" checked/><span>🆓 Free Event</span></label>
                        <label><input type="radio" name="isFree" value="false" id="paidRadio" onchange="toggleFee(false)"/><span>💰 Paid Event</span></label>
                    </div>
                    <div id="feeInput" style="display:none;">
                        <input type="number" name="entryFee" id="entryFeeField" class="form-control" min="1" placeholder="Enter amount in ₹" value="0"/>
                        <div class="hint">Fee will be collected at the venue by the organizer.</div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Booth / Stall Booking Fee (Exhibitions)</label>
                    <input type="number" name="boothFee" class="form-control" min="0" placeholder="e.g., ₹2000 for stall booking" value="0"/>
                    <div class="hint">Optional fee for booking a booth/stall.</div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Maximum Participants</label>
                <input type="number" name="maxParticipants" class="form-control" min="1" placeholder="Leave blank for unlimited" style="max-width:200px;"/>
            </div>

            <!-- Contact -->
            <div class="section-title"><i class="bi bi-telephone-fill"></i>Contact</div>
            <div class="form-group">
                <label class="form-label">Contact Information <span class="req">*</span></label>
                <input type="text" name="contactInfo" class="form-control" required placeholder="Phone number, email, or WhatsApp"/>
            </div>

            <!-- Banner -->
            <div class="section-title"><i class="bi bi-image-fill"></i>Event Banner</div>
            <div class="form-group">
                <div class="upload-zone" onclick="document.getElementById('bannerFile').click()">
                    <i class="bi bi-cloud-arrow-up-fill" style="font-size:2.5rem; color:#a855f7; display:block; margin-bottom:10px;"></i>
                    <div style="font-weight:600; color:#555;">Click to upload banner image</div>
                    <div class="hint">Recommended size: 1200×600px · JPG or PNG · Max 5MB</div>
                    <img id="bannerPreview" class="upload-preview" alt="Banner preview"/>
                </div>
                <input type="file" id="bannerFile" name="bannerImage" accept="image/*" style="display:none;"
                       onchange="previewBanner(this)"/>
            </div>

            <button type="submit" class="submit-btn">
                <i class="bi bi-send-fill me-2"></i>Submit Event for Approval
            </button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleFee(isFree) {
        const feeInput = document.getElementById('feeInput');
        const feeField = document.getElementById('entryFeeField');
        feeInput.style.display = isFree ? 'none' : 'block';
        if (isFree) feeField.value = '0';
        feeField.required = !isFree;
    }

    function toggleVirtual(checkbox) {
        const isVirtual = checkbox.checked;
        const streamLinkGroup = document.getElementById('streamLinkGroup');
        const locationFields = document.getElementById('locationFields');
        const mapsFieldGroup = document.getElementById('mapsFieldGroup');
        const venueField = document.getElementById('venueField');
        const cityField = document.getElementById('cityField');

        streamLinkGroup.style.display = isVirtual ? 'block' : 'none';
        
        if (isVirtual) {
            venueField.value = "Online / Virtual";
            cityField.value = "Virtual";
            mapsFieldGroup.style.display = 'none';
        } else {
            venueField.value = "";
            cityField.value = "";
            mapsFieldGroup.style.display = 'block';
        }
    }

    function previewBanner(input) {
        const preview = document.getElementById('bannerPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => { preview.src = e.target.result; preview.style.display = 'block'; };
            reader.readAsDataURL(input.files[0]);
            input.closest('.upload-zone').querySelector('div').textContent = input.files[0].name;
        }
    }
</script>
</body>
</html>
