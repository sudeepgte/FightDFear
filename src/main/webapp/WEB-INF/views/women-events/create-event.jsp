<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Event — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css"/>
    <style>
        .progress-steps {
            display: flex; align-items: center; gap: 0; margin-bottom: 24px;
            background: var(--fdf-white); border: 1px solid var(--fdf-border);
            border-radius: 14px; padding: 16px 24px;
        }
        .step { display: flex; align-items: center; gap: 10px; flex: 1; }
        .step-num {
            width: 32px; height: 32px; border-radius: 50%; border: 2px solid var(--fdf-border);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem; font-weight: 800; color: var(--fdf-text-muted); flex-shrink: 0;
        }
        .step.active .step-num { background: var(--fdf-accent); border-color: var(--fdf-accent); color: #fff; }
        .step-label { font-size: 0.82rem; font-weight: 700; color: var(--fdf-text-muted); }
        .step.active .step-label { color: var(--fdf-navy); }
        .step-divider { flex: 1; height: 2px; background: var(--fdf-border); margin: 0 8px; }

        .form-grid { display: grid; grid-template-columns: 1fr 320px; gap: 20px; align-items: start; }
        .form-card {
            background: var(--fdf-white); border: 1px solid var(--fdf-border);
            border-radius: 16px; overflow: hidden;
        }
        .form-card-header {
            padding: 18px 24px; border-bottom: 1px solid var(--fdf-border);
            display: flex; align-items: center; gap: 10px; background: var(--fdf-white);
        }
        .form-card-header h3 { font-size: 1rem; font-weight: 800; color: var(--fdf-navy); margin: 0; }
        .header-icon {
            width: 36px; height: 36px; border-radius: 10px; background: var(--fdf-rose-soft);
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; color: var(--fdf-accent); flex-shrink: 0;
        }
        .form-card-body { padding: 22px 24px; }
        .fg { margin-bottom: 16px; }
        .fg label {
            display: block; font-weight: 700; font-size: 0.82rem;
            color: var(--fdf-text-muted); margin-bottom: 6px;
            text-transform: uppercase; letter-spacing: 0.04em;
        }
        .fg label .req { color: var(--fdf-accent); }
        .fg input, .fg select, .fg textarea {
            width: 100%; border: 1px solid var(--fdf-border); border-radius: 10px;
            padding: 10px 14px; font-family: inherit; font-size: 0.92rem;
            outline: none; background: var(--fdf-white); color: var(--fdf-navy);
        }
        .fg input:focus, .fg select:focus, .fg textarea:focus {
            border-color: var(--fdf-accent);
            box-shadow: 0 0 0 3px var(--fdf-accent-shadow);
        }
        .fg textarea { resize: vertical; min-height: 110px; }
        .fg .hint { font-size: 0.75rem; color: var(--fdf-text-muted); margin-top: 4px; }
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        .fee-toggle { display: flex; gap: 10px; margin-bottom: 10px; }
        .fee-option {
            flex: 1; border: 1px solid var(--fdf-border); border-radius: 10px;
            padding: 10px 14px; cursor: pointer; display: flex; align-items: center; gap: 8px;
            font-weight: 600; font-size: 0.88rem; background: var(--fdf-white);
        }
        .fee-option input { display: none; }
        .fee-option:has(input:checked) {
            border-color: var(--fdf-accent); background: var(--fdf-rose-soft); color: var(--fdf-accent);
        }

        .upload-zone {
            border: 2px dashed var(--fdf-rose-muted); border-radius: 12px; padding: 28px 20px;
            text-align: center; cursor: pointer; background: var(--fdf-rose-soft);
        }
        .upload-zone:hover { border-color: var(--fdf-accent); }
        .upload-preview { max-width: 100%; max-height: 180px; border-radius: 10px; margin-top: 12px; display: none; }

        .virtual-toggle {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 14px; border: 1px solid var(--fdf-border); border-radius: 10px;
            cursor: pointer; font-weight: 600; font-size: 0.88rem; background: var(--fdf-white);
        }
        .virtual-toggle input { width: 18px; height: 18px; accent-color: var(--fdf-accent); }
        .virtual-toggle:has(input:checked) {
            border-color: var(--fdf-accent); background: var(--fdf-rose-soft); color: var(--fdf-navy);
        }

        .submit-card {
            background: var(--fdf-white); border: 1px solid var(--fdf-border);
            border-radius: 16px; padding: 20px 24px; display: flex; flex-direction: column; gap: 12px;
        }
        .submit-btn {
            width: 100%; background: var(--fdf-accent); color: #fff; border: none;
            border-radius: 12px; padding: 16px; font-family: inherit; font-size: 1rem; font-weight: 800;
            cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .submit-btn:hover { background: var(--fdf-accent-hover); }
        .cancel-btn {
            width: 100%; background: var(--fdf-white); color: var(--fdf-text-muted);
            border: 1px solid var(--fdf-border); border-radius: 12px; padding: 13px;
            font-family: inherit; font-size: 0.92rem; font-weight: 700; text-align: center; text-decoration: none;
        }
        .cancel-btn:hover { border-color: var(--fdf-accent); color: var(--fdf-accent); }

        .info-box {
            background: var(--fdf-rose-soft); border: 1px solid var(--fdf-rose-muted);
            border-radius: 12px; padding: 14px 16px; font-size: 0.83rem; color: var(--fdf-navy);
            display: flex; align-items: flex-start; gap: 8px;
        }
        .info-box i { color: var(--fdf-accent); flex-shrink: 0; margin-top: 1px; }

        .tips-card {
            background: var(--fdf-white); border: 1px solid var(--fdf-border);
            border-radius: 16px; padding: 20px;
        }
        .tips-card h4 {
            font-size: 0.95rem; font-weight: 800; margin-bottom: 14px;
            color: var(--fdf-navy); display: flex; align-items: center; gap: 8px;
        }
        .tips-card h4 i { color: var(--fdf-accent); }
        .tip-item { display: flex; gap: 10px; margin-bottom: 13px; font-size: 0.82rem; line-height: 1.5; color: var(--fdf-text-muted); }
        .tip-icon {
            width: 28px; height: 28px; border-radius: 8px; background: var(--fdf-rose-soft);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem; color: var(--fdf-accent); flex-shrink: 0;
        }

        .sticky-panel { position: sticky; top: 80px; display: flex; flex-direction: column; gap: 16px; }
        .alert-error {
            background: #FEF2F2; border: 1px solid #FECACA; color: #B91C1C;
            border-radius: 12px; padding: 12px 16px; margin-bottom: 16px; font-size: 0.9rem;
        }

        @media (max-width: 960px) { .form-grid { grid-template-columns: 1fr; } .sticky-panel { position: static; } }
        @media (max-width: 768px) { .two-col { grid-template-columns: 1fr; } .progress-steps { overflow-x: auto; } }
    </style>
</head>
<body class="org-hub">

<%@ include file="../fragments/organizer-sidebar.jsp" %>

<div class="org-main-wrapper">
    <div class="org-topbar">
        <div class="org-topbar-left">
            <h2>Create New Event</h2>
            <p>Fill in the details — your event will be reviewed by admin before going live.</p>
        </div>
        <div class="org-topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="org-btn-secondary">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="org-page-content">

        <c:if test="${not empty error}">
            <div class="alert-error"><i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}</div>
        </c:if>

        <div class="progress-steps">
            <div class="step active"><div class="step-num">1</div><div class="step-label">Basic Info</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">2</div><div class="step-label">Date &amp; Location</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">3</div><div class="step-label">Fee &amp; Capacity</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">4</div><div class="step-label">Banner &amp; Submit</div></div>
        </div>

        <form action="${pageContext.request.contextPath}/women-events/organizer/create" method="post" enctype="multipart/form-data" id="createEventForm">
            <div class="form-grid">

                <div style="display:flex;flex-direction:column;gap:16px;">

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-info-circle"></i></div>
                            <h3>Basic Information</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="fg">
                                <label>Event Name <span class="req">*</span></label>
                                <input type="text" name="name" required placeholder="e.g., Women's Day Yoga &amp; Wellness Camp"/>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>Category <span class="req">*</span></label>
                                    <select name="category" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat}">${cat.displayName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="fg">
                                    <label>Organizer Type <span class="req">*</span></label>
                                    <select name="organizerType" required>
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
                            <div class="fg">
                                <label>Organizer / Organization Name <span class="req">*</span></label>
                                <input type="text" name="organizerName" required placeholder="e.g., She Leads Foundation"/>
                            </div>
                            <div class="fg">
                                <label>Event Description <span class="req">*</span></label>
                                <textarea name="description" required rows="5" placeholder="Describe your event — what will happen, who should attend, what they'll gain..."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-clock"></i></div>
                            <h3>Date, Time &amp; Location</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="two-col">
                                <div class="fg">
                                    <label>Event Date <span class="req">*</span></label>
                                    <input type="date" name="eventDate" required/>
                                </div>
                                <div class="fg">
                                    <label>Start Time</label>
                                    <input type="time" name="eventTime"/>
                                </div>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>End Date</label>
                                    <input type="date" name="endDate"/>
                                </div>
                                <div class="fg">
                                    <label>End Time</label>
                                    <input type="time" name="endTime"/>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Registration Closes</label>
                                <input type="datetime-local" name="registrationCloses"/>
                                <div class="hint">Cannot be after event start. Timezone: Asia/Kolkata.</div>
                            </div>
                            <div class="fg">
                                <label>Event Format</label>
                                <div class="fee-toggle">
                                    <label class="fee-option"><input type="radio" name="eventFormat" value="OFFLINE" checked onchange="toggleFormat('OFFLINE')"/> Offline</label>
                                    <label class="fee-option"><input type="radio" name="eventFormat" value="ONLINE" onchange="toggleFormat('ONLINE')"/> Online</label>
                                    <label class="fee-option"><input type="radio" name="eventFormat" value="HYBRID" onchange="toggleFormat('HYBRID')"/> Hybrid</label>
                                </div>
                            </div>
                            <div class="fg">
                                <label class="virtual-toggle">
                                    <input type="checkbox" name="virtual" value="true" id="virtualBox" onchange="toggleVirtual(this)"/>
                                    <span>This is a Virtual / Online Event</span>
                                </label>
                            </div>
                            <div class="fg" id="streamLinkGroup" style="display:none;">
                                <label>Live Stream / Meeting Link</label>
                                <input type="url" name="streamLink" placeholder="Zoom, Google Meet, YouTube stream URL"/>
                            </div>
                            <div class="two-col" id="locationFields">
                                <div class="fg">
                                    <label>Venue / Location <span class="req">*</span></label>
                                    <input type="text" name="venue" id="venueField" required placeholder="City Community Hall"/>
                                </div>
                                <div class="fg">
                                    <label>City <span class="req">*</span></label>
                                    <input type="text" name="city" id="cityField" required placeholder="e.g., Mumbai"/>
                                </div>
                            </div>
                            <div class="fg" id="mapsFieldGroup">
                                <label>Google Maps Location / Address</label>
                                <input type="text" name="mapsLocation" placeholder="Paste maps link or address"/>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-cash-coin"></i></div>
                            <h3>Entry Fee, Booth &amp; Capacity</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="two-col">
                                <div class="fg">
                                    <label>Entry Fee</label>
                                    <div class="fee-toggle">
                                        <label class="fee-option">
                                            <input type="radio" name="isFree" value="true" onchange="toggleFee(true)" checked/>
                                            Free Event
                                        </label>
                                        <label class="fee-option">
                                            <input type="radio" name="isFree" value="false" onchange="toggleFee(false)"/>
                                            Paid Event
                                        </label>
                                    </div>
                                    <div id="feeInput" style="display:none;">
                                        <input type="number" name="entryFee" id="entryFeeField" min="0" placeholder="Amount in ₹" value="0"/>
                                    </div>
                                </div>
                                <div class="fg">
                                    <label>Booth / Stall Booking Fee</label>
                                    <input type="number" name="boothFee" min="0" value="0"/>
                                </div>
                            </div>
                            <div class="fg" style="max-width:260px;">
                                <label>Maximum Participants</label>
                                <input type="number" name="maxParticipants" min="1" placeholder="Unlimited if blank"/>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-shield-check"></i></div>
                            <h3>Policies</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="fg">
                                <label>Cancellation Policy</label>
                                <textarea name="cancellationPolicy" rows="2" placeholder="Platform policy applies if left blank."></textarea>
                            </div>
                            <div class="fg">
                                <label>Refund Policy</label>
                                <textarea name="refundPolicy" rows="2"></textarea>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>Age Restriction</label>
                                    <input type="text" name="ageRestriction" placeholder="e.g. 18+"/>
                                </div>
                                <div class="fg">
                                    <label>What to Bring</label>
                                    <input type="text" name="whatToBring" placeholder="ID, water bottle"/>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Participant Requirements</label>
                                <textarea name="participantRequirements" rows="2"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-telephone"></i></div>
                            <h3>Contact Information</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="fg">
                                <label>Contact Info <span class="req">*</span></label>
                                <input type="text" name="contactInfo" required placeholder="Phone, email, or WhatsApp"/>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-image"></i></div>
                            <h3>Event Banner</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="upload-zone" onclick="document.getElementById('bannerFile').click()">
                                <i class="bi bi-cloud-arrow-up" style="font-size:2.2rem;color:var(--fdf-accent);display:block;margin-bottom:10px;"></i>
                                <div style="font-weight:700;color:var(--fdf-navy);" id="uploadLabel">Click to upload banner image</div>
                                <div class="hint" style="margin-top:6px;">1200×600px · JPG or PNG · Max 5MB</div>
                                <img id="bannerPreview" class="upload-preview" alt="Banner preview"/>
                            </div>
                            <input type="file" id="bannerFile" name="bannerImage" accept="image/*" style="display:none;" onchange="previewBanner(this)"/>
                        </div>
                    </div>
                </div>

                <div class="sticky-panel">
                    <div class="submit-card">
                        <div class="info-box">
                            <i class="bi bi-info-circle"></i>
                            Your event is submitted for admin approval before it appears publicly.
                        </div>
                        <button type="submit" class="submit-btn" name="saveDraft" value="false"><i class="bi bi-send"></i> Submit for Approval</button>
                        <button type="submit" class="cancel-btn" name="saveDraft" value="true" style="cursor:pointer;">Save Draft</button>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-check2-all"></i></div>
                            <h3>Checklist</h3>
                        </div>
                        <div class="form-card-body" style="padding:16px 20px;">
                            <div id="checklistItems" style="display:flex;flex-direction:column;gap:10px;">
                                <div class="check-item" id="chk-name"><i class="bi bi-circle"></i><span>Event name filled</span></div>
                                <div class="check-item" id="chk-cat"><i class="bi bi-circle"></i><span>Category selected</span></div>
                                <div class="check-item" id="chk-desc"><i class="bi bi-circle"></i><span>Description added</span></div>
                                <div class="check-item" id="chk-date"><i class="bi bi-circle"></i><span>Date set</span></div>
                                <div class="check-item" id="chk-venue"><i class="bi bi-circle"></i><span>Venue &amp; city added</span></div>
                                <div class="check-item" id="chk-contact"><i class="bi bi-circle"></i><span>Contact info added</span></div>
                            </div>
                        </div>
                    </div>

                    <div class="tips-card">
                        <h4><i class="bi bi-lightbulb"></i> Tips for a Great Event</h4>
                        <div class="tip-item"><div class="tip-icon"><i class="bi bi-image"></i></div><span>Upload a high-quality banner — events with images get more registrations.</span></div>
                        <div class="tip-item"><div class="tip-icon"><i class="bi bi-pencil"></i></div><span>Write a clear description to attract the right audience.</span></div>
                        <div class="tip-item"><div class="tip-icon"><i class="bi bi-calendar-check"></i></div><span>Publish at least 2 weeks before the event date.</span></div>
                        <div class="tip-item"><div class="tip-icon"><i class="bi bi-geo-alt"></i></div><span>Add a maps link so attendees can find the venue easily.</span></div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<style>
.check-item { display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--fdf-text-muted); }
.check-item i { color: var(--fdf-border); font-size: 1rem; }
.check-item.done i { color: #16A34A; }
.check-item.done span { color: var(--fdf-navy); }
</style>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const todayStr = new Date().toISOString().split('T')[0];
    const dateInput = document.querySelector('[name="eventDate"]');
    if (dateInput) dateInput.min = todayStr;
});

function updateChecklist() {
    function setCheck(id, filled) {
        const el = document.getElementById(id);
        if (!el) return;
        el.classList.toggle('done', filled);
        const icon = el.querySelector('i');
        icon.className = filled ? 'bi bi-check-circle-fill' : 'bi bi-circle';
    }
    setCheck('chk-name', document.querySelector('[name="name"]')?.value.trim().length > 0);
    setCheck('chk-cat', document.querySelector('[name="category"]')?.value !== '');
    setCheck('chk-desc', document.querySelector('[name="description"]')?.value.trim().length > 10);
    setCheck('chk-date', document.querySelector('[name="eventDate"]')?.value !== '');
    setCheck('chk-venue', document.querySelector('[name="venue"]')?.value.trim().length > 0
        && document.querySelector('[name="city"]')?.value.trim().length > 0);
    setCheck('chk-contact', document.querySelector('[name="contactInfo"]')?.value.trim().length > 0);
}
document.querySelectorAll('input, select, textarea').forEach(el => el.addEventListener('input', updateChecklist));
updateChecklist();

document.getElementById('createEventForm')?.addEventListener('submit', function(e) {
    const dateInp = document.querySelector('[name="eventDate"]');
    if (dateInp && dateInp.value) {
        const selected = new Date(dateInp.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        if (selected < today) {
            e.preventDefault();
            alert('Event date cannot be in the past.');
            dateInp.focus();
        }
    }
});

function toggleFee(isFree) {
    const feeInput = document.getElementById('feeInput');
    const feeField = document.getElementById('entryFeeField');
    feeInput.style.display = isFree ? 'none' : 'block';
    if (isFree) { feeField.value = '0'; feeField.min = '0'; }
    else { feeField.min = '1'; if (feeField.value === '0') feeField.value = ''; }
    feeField.required = !isFree;
}

function toggleFormat(fmt) {
    const box = document.getElementById('virtualBox');
    if (!box) return;
    box.checked = fmt === 'ONLINE' || fmt === 'HYBRID';
    toggleVirtual(box);
}

function toggleVirtual(checkbox) {
    const isVirtual = checkbox.checked;
    document.getElementById('streamLinkGroup').style.display = isVirtual ? 'block' : 'none';
    const venueField = document.getElementById('venueField');
    const cityField = document.getElementById('cityField');
    const mapsGroup = document.getElementById('mapsFieldGroup');
    if (isVirtual) {
        venueField.value = 'Online / Virtual';
        cityField.value = 'Virtual';
        mapsGroup.style.display = 'none';
    } else {
        venueField.value = '';
        cityField.value = '';
        mapsGroup.style.display = 'block';
    }
    updateChecklist();
}

function previewBanner(input) {
    const preview = document.getElementById('bannerPreview');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => { preview.src = e.target.result; preview.style.display = 'block'; };
        reader.readAsDataURL(input.files[0]);
        document.getElementById('uploadLabel').textContent = input.files[0].name;
    }
}
</script>
</body>
</html>
