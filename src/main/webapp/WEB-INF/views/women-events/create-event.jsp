<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Event — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizer-hub.css?v=2"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.css"/>
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    <style>
      .we-modal-overlay { display:none; position:fixed; inset:0; background:rgba(15,23,42,.45); z-index:2000; align-items:center; justify-content:center; padding:20px; }
      .we-modal-overlay.open { display:flex; }

      /* Leaflet Map Picker Modal */
      .modal-overlay {
          position: fixed;
          top: 0; left: 0; right: 0; bottom: 0;
          background: rgba(15, 23, 42, 0.65);
          backdrop-filter: blur(4px);
          z-index: 3000;
          display: none;
          align-items: center;
          justify-content: center;
          padding: 16px;
      }
      .modal-overlay.open { display: flex; }
      .map-modal-card {
          background: #FFFFFF;
          border-radius: 18px;
          width: 100%;
          max-width: 780px;
          max-height: 90vh;
          display: flex;
          flex-direction: column;
          overflow: hidden;
          box-shadow: 0 20px 45px rgba(15,23,42,0.25);
          animation: modalPop 0.2s ease-out;
      }
      @keyframes modalPop {
          from { opacity: 0; transform: scale(0.96); }
          to { opacity: 1; transform: scale(1); }
      }
      .modal-header-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 16px 22px;
          border-bottom: 1px solid var(--fdf-border);
      }
      .modal-title {
          font-size: 1.05rem;
          font-weight: 800;
          color: var(--fdf-navy);
          display: flex;
          align-items: center;
          gap: 8px;
      }
      .btn-close-modal {
          background: none;
          border: none;
          font-size: 1.5rem;
          color: var(--fdf-text-muted);
          cursor: pointer;
          line-height: 1;
          padding: 0;
      }
      .btn-close-modal:hover { color: var(--fdf-navy); }
      .map-search-bar {
          padding: 12px 20px;
          background: #F8FAFC;
          border-bottom: 1px solid var(--fdf-border);
          display: flex;
          gap: 8px;
          position: relative;
      }
      .map-search-input {
          flex: 1;
          height: 40px;
          padding: 0 14px;
          border: 1px solid var(--fdf-border);
          border-radius: 8px;
          font-size: 0.9rem;
          font-family: inherit;
      }
      .map-search-input:focus {
          outline: none;
          border-color: var(--fdf-accent);
      }
      .map-suggestions-box {
          position: absolute;
          top: 56px;
          left: 20px;
          right: 20px;
          background: #FFFFFF;
          border: 1px solid var(--fdf-border);
          border-radius: 8px;
          box-shadow: 0 10px 25px rgba(0,0,0,0.12);
          max-height: 180px;
          overflow-y: auto;
          z-index: 1050;
          display: none;
      }
      .map-suggestion-item {
          padding: 10px 14px;
          font-size: 0.84rem;
          cursor: pointer;
          border-bottom: 1px solid #F1F5F9;
      }
      .map-suggestion-item:hover {
          background: #FFF1F2;
          color: var(--fdf-accent);
      }
      #mapContainer {
          width: 100%;
          height: 380px;
          background: #E2E8F0;
      }
      .map-modal-footer {
          padding: 14px 20px;
          border-top: 1px solid var(--fdf-border);
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 12px;
          flex-wrap: wrap;
          background: #FFFFFF;
      }
      .map-selected-address-box {
          font-size: 0.85rem;
          color: var(--fdf-text-muted);
          flex: 1;
          min-width: 220px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          display: flex;
          align-items: center;
          gap: 6px;
      }
      .map-modal-actions {
          display: flex;
          gap: 8px;
      }
      .location-action-bar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          background: var(--fdf-rose-soft);
          border: 1px solid var(--fdf-rose-border);
          border-radius: 12px;
          padding: 14px 18px;
          margin-bottom: 16px;
          flex-wrap: wrap;
          gap: 12px;
      }
      .btn-map-picker {
          background: var(--fdf-accent);
          color: #FFFFFF;
          border: none;
          padding: 10px 18px;
          border-radius: 10px;
          font-size: 0.86rem;
          font-weight: 700;
          cursor: pointer;
          display: inline-flex;
          align-items: center;
          gap: 8px;
          box-shadow: 0 4px 12px rgba(244,63,94,0.25);
          transition: all 0.2s;
      }
      .btn-map-picker:hover {
          background: var(--fdf-accent-hover);
          transform: translateY(-1px);
      }
      .spin { animation: spin 1s linear infinite; }
      @keyframes spin { 100% { transform: rotate(360deg); } }
    </style>
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
            transition: border-color 0.2s, box-shadow 0.2s, background-color 0.2s;
        }
        .fg input:focus, .fg select:focus, .fg textarea:focus {
            border-color: var(--fdf-accent);
            box-shadow: 0 0 0 3px var(--fdf-accent-shadow);
        }
        .fg input.is-invalid, .fg select.is-invalid, .fg textarea.is-invalid {
            border-color: #E11D48 !important;
            background-color: #FFF1F2 !important;
            box-shadow: 0 0 0 3px rgba(225, 29, 72, 0.15) !important;
        }
        .fg input.is-valid, .fg select.is-valid, .fg textarea.is-valid {
            border-color: #10B981 !important;
        }
        .field-error {
            display: none;
            font-size: 0.78rem;
            color: #E11D48;
            margin-top: 6px;
            font-weight: 600;
            line-height: 1.35;
            align-items: center;
            gap: 6px;
        }
        .field-error.show {
            display: flex;
        }
        .field-hint-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 4px;
        }
        .char-counter {
            font-size: 0.75rem;
            color: var(--fdf-text-muted);
            font-weight: 600;
        }
        .char-counter.valid {
            color: #10B981;
        }
        .char-counter.invalid {
            color: #E11D48;
        }
        .alert-error {
            background: #FEF2F2;
            border: 1px solid #FECACA;
            color: #DC2626;
            padding: 12px 18px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.88rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeIn 0.25s ease-in-out;
        }
        .alert-error i {
            font-size: 1.15rem;
            flex-shrink: 0;
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
            <div class="org-topbar-header-wrap">
                <button class="org-sidebar-toggle" onclick="document.body.classList.toggle('sidebar-open')">
                    <i class="bi bi-list"></i>
                </button>
                <div>
                    <h2>Create New Event</h2>
                    <p>Fill in the details — your event will be reviewed by admin before going live.</p>
                </div>
            </div>
        </div>
        <div class="org-topbar-right">
            <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="org-btn-secondary">
                <i class="bi bi-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <div class="org-page-content">

        <c:if test="${not empty error}">
            <div class="alert-error"><i class="bi bi-exclamation-triangle-fill"></i> <span>${error}</span></div>
        </c:if>

        <div id="formValidationSummary" class="alert-error" style="display:none;">
            <i class="bi bi-exclamation-circle-fill"></i>
            <span id="formValidationSummaryText">Please correct the highlighted fields below before submitting.</span>
        </div>

        <div class="progress-steps">
            <div class="step active"><div class="step-num">1</div><div class="step-label">Basic Info</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">2</div><div class="step-label">Date &amp; Location</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">3</div><div class="step-label">Fee &amp; Capacity</div></div>
            <div class="step-divider"></div>
            <div class="step"><div class="step-num">4</div><div class="step-label">Banner &amp; Submit</div></div>
        </div>

        <form action="${pageContext.request.contextPath}/women-events/organizer/create${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" id="createEventForm" novalidate>
            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
            <input type="hidden" name="saveDraft" id="saveDraftInput" value="false" />
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
                                <input type="text" name="name" id="eventNameInput" required placeholder="e.g., Women's Day Yoga &amp; Wellness Camp" maxlength="150"/>
                                <div class="field-error" id="err-name"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter an event name (at least 3 characters).</span></div>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>Category <span class="req">*</span></label>
                                    <select name="category" id="categorySelect" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat}">${cat.displayName}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="field-error" id="err-category"><i class="bi bi-exclamation-circle-fill"></i><span>Please select an event category.</span></div>
                                </div>
                                <div class="fg">
                                    <label>Organizer Type <span class="req">*</span></label>
                                    <select name="organizerType" id="organizerTypeSelect" required>
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
                                    <div class="field-error" id="err-organizerType"><i class="bi bi-exclamation-circle-fill"></i><span>Please select an organizer type.</span></div>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Organizer / Organization Name <span class="req">*</span></label>
                                <input type="text" name="organizerName" id="organizerNameInput" required placeholder="e.g., She Leads Foundation" maxlength="120"/>
                                <div class="field-error" id="err-organizerName"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter the organizer or organization name.</span></div>
                            </div>
                            <div class="fg">
                                <label>Event Description <span class="req">*</span></label>
                                <textarea name="description" id="descriptionInput" required rows="5" placeholder="Describe your event — what will happen, who should attend, what they'll gain..."></textarea>
                                <div class="field-hint-bar">
                                    <div class="hint">Minimum 20 characters describing the event schedule, audience, and takeaways.</div>
                                    <div class="char-counter" id="descCharCount">0 / 20 min</div>
                                </div>
                                <div class="field-error" id="err-description"><i class="bi bi-exclamation-circle-fill"></i><span>Please provide a detailed description (at least 20 characters).</span></div>
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
                                    <input type="date" name="eventDate" id="eventDateInput" required/>
                                    <div class="field-error" id="err-eventDate"><i class="bi bi-exclamation-circle-fill"></i><span>Please select a valid upcoming event date.</span></div>
                                </div>
                                <div class="fg">
                                    <label>Start Time</label>
                                    <input type="time" name="eventTime" id="eventTimeInput"/>
                                    <div class="field-error" id="err-eventTime"><i class="bi bi-exclamation-circle-fill"></i><span>Please specify a valid start time.</span></div>
                                </div>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>End Date</label>
                                    <input type="date" name="endDate" id="endDateInput"/>
                                    <div class="field-error" id="err-endDate"><i class="bi bi-exclamation-circle-fill"></i><span>End date cannot be earlier than event start date.</span></div>
                                </div>
                                <div class="fg">
                                    <label>End Time</label>
                                    <input type="time" name="endTime" id="endTimeInput"/>
                                    <div class="field-error" id="err-endTime"><i class="bi bi-exclamation-circle-fill"></i><span>End time must be after start time on the same date.</span></div>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Registration Closes</label>
                                <input type="datetime-local" name="registrationCloses" id="registrationClosesInput"/>
                                <div class="hint">Cannot be after event start. Timezone: Asia/Kolkata.</div>
                                <div class="field-error" id="err-registrationCloses"><i class="bi bi-exclamation-circle-fill"></i><span>Registration closing time cannot be after event start time.</span></div>
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
                                <input type="url" name="streamLink" id="streamLinkInput" placeholder="Zoom, Google Meet, YouTube stream URL"/>
                                <div class="field-error" id="err-streamLink"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter a valid link (starting with http:// or https://).</span></div>
                            </div>
                            <div id="offlineLocationWrapper">
                                <div class="location-action-bar">
                                    <div>
                                        <span style="font-size: 0.9rem; font-weight: 700; color: var(--fdf-navy); display: block;">Pinpoint Venue via Interactive Map</span>
                                        <span style="font-size: 0.8rem; color: var(--fdf-text-muted);">Search landmarks, drop a pin, or use current location to auto-detect City &amp; Address</span>
                                    </div>
                                    <button type="button" id="btnOpenMapPicker" class="btn-map-picker">
                                        <i class="bi bi-geo-alt-fill"></i> Select Location on Map
                                    </button>
                                </div>

                                <div class="fg">
                                    <label>Street Address / Venue Name <span class="req">*</span></label>
                                    <input type="text" name="venue" id="venueField" required placeholder="Building, hall name, street or landmark" value="<c:out value='${host.officeAddress}'/>"/>
                                    <div class="field-error" id="err-venue"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter the venue name or street address (at least 3 characters).</span></div>
                                </div>

                                <div class="two-col">
                                    <div class="fg">
                                        <label>State / UT <span class="req">*</span> <span id="stateSpinner" style="display:none;font-size:0.75rem;color:var(--fdf-accent);"><i class="bi bi-arrow-repeat spin"></i></span></label>
                                        <select name="venueState" id="stateSelect" required onchange="onStateChange()">
                                            <option value="">-- Select State / UT --</option>
                                        </select>
                                        <div class="field-error" id="err-state"><i class="bi bi-exclamation-circle-fill"></i><span>Please select a State or Union Territory.</span></div>
                                    </div>
                                    <div class="fg">
                                        <label>City / District <span class="req">*</span> <span id="districtSpinner" style="display:none;font-size:0.75rem;color:var(--fdf-accent);"><i class="bi bi-arrow-repeat spin"></i></span></label>
                                        <select id="districtSelect" required onchange="onDistrictChange()">
                                            <option value="">-- Select State First --</option>
                                        </select>
                                        <input type="hidden" name="city" id="cityField" value="<c:out value='${host.city}'/>"/>
                                        <div class="field-error" id="err-city"><i class="bi bi-exclamation-circle-fill"></i><span>Please select a City or District.</span></div>
                                    </div>
                                </div>

                                <div class="fg" id="customCityGroup" style="display:none;">
                                    <label>Custom City / Town Name <span class="req">*</span></label>
                                    <input type="text" id="customCityInput" placeholder="Enter your city / town name" oninput="onCustomCityInput()"/>
                                    <div class="field-error" id="err-customCity"><i class="bi bi-exclamation-circle-fill"></i><span>Please specify the city or town name.</span></div>
                                </div>

                                <div class="two-col">
                                    <div class="fg">
                                        <label>Postal Pincode</label>
                                        <input type="text" name="venuePincode" id="pincodeField" placeholder="6-digit Pincode" maxlength="6" inputmode="numeric" value="<c:out value='${host.pincode}'/>"/>
                                        <div class="field-error" id="err-pincode"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter a valid 6-digit Indian PIN code.</span></div>
                                    </div>
                                    <div class="fg">
                                        <label>Area / Neighborhood</label>
                                        <input type="text" name="venueArea" id="areaField" placeholder="e.g. Bandra West, Indiranagar" value="<c:out value='${host.area}'/>"/>
                                    </div>
                                </div>

                                <div class="fg" id="mapsFieldGroup">
                                    <label>Google Maps Link / Coordinates</label>
                                    <input type="text" name="mapsLocation" id="mapsLocationField" placeholder="Auto-filled via Map Picker or paste Google Maps URL" value="<c:out value='${not empty host.website && host.website.contains(\"maps\") ? host.website : \"\"}'/>"/>
                                    <div class="field-error" id="err-mapsLocation"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter a valid URL or coordinates.</span></div>
                                    <div class="hint" id="coordsDisplay"><i class="bi bi-pin-map-fill" style="color:var(--fdf-accent);"></i> Coordinates: <span id="coordsSpan">${host.latitude != null ? host.latitude : '—'}, ${host.longitude != null ? host.longitude : '—'}</span></div>
                                </div>
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
                                            <input type="radio" name="isFree" id="isFreeTrue" value="true" onchange="toggleFee(true)" checked/>
                                            Free Event
                                        </label>
                                        <label class="fee-option">
                                            <input type="radio" name="isFree" id="isFreeFalse" value="false" onchange="toggleFee(false)"/>
                                            Paid Event
                                        </label>
                                    </div>
                                    <div id="feeInput" style="display:none;">
                                        <input type="number" name="entryFee" id="entryFeeField" min="0" placeholder="Amount in ₹" value="0"/>
                                        <div class="field-error" id="err-entryFee"><i class="bi bi-exclamation-circle-fill"></i><span>Entry fee must be greater than ₹0 for paid events.</span></div>
                                    </div>
                                </div>
                                <div class="fg">
                                    <label>Booth / Stall Booking Fee</label>
                                    <input type="number" name="boothFee" id="boothFeeField" min="0" value="0"/>
                                    <div class="field-error" id="err-boothFee"><i class="bi bi-exclamation-circle-fill"></i><span>Booth fee cannot be negative.</span></div>
                                </div>
                            </div>
                            <div class="fg" style="max-width:260px;">
                                <label>Maximum Participants</label>
                                <input type="number" name="maxParticipants" id="maxParticipantsField" min="1" placeholder="Unlimited if blank"/>
                                <div class="field-error" id="err-maxParticipants"><i class="bi bi-exclamation-circle-fill"></i><span>Capacity must be at least 1 participant.</span></div>
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
                                <textarea name="cancellationPolicy" id="cancellationPolicyInput" rows="2" placeholder="Platform policy applies if left blank."></textarea>
                            </div>
                            <div class="fg">
                                <label>Refund Policy</label>
                                <textarea name="refundPolicy" id="refundPolicyInput" rows="2"></textarea>
                            </div>
                            <div class="two-col">
                                <div class="fg">
                                    <label>Age Restriction</label>
                                    <input type="text" name="ageRestriction" id="ageRestrictionInput" placeholder="e.g. 18+"/>
                                </div>
                                <div class="fg">
                                    <label>What to Bring</label>
                                    <input type="text" name="whatToBring" id="whatToBringInput" placeholder="ID, water bottle"/>
                                </div>
                            </div>
                            <div class="fg">
                                <label>Participant Requirements</label>
                                <textarea name="participantRequirements" id="participantRequirementsInput" rows="2"></textarea>
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
                                <input type="text" name="contactInfo" id="contactInfoInput" required placeholder="10-digit Phone number or Email address"/>
                                <div class="field-error" id="err-contactInfo"><i class="bi bi-exclamation-circle-fill"></i><span>Please enter a valid 10-digit mobile number or email address.</span></div>
                            </div>
                        </div>
                    </div>

                    <div class="form-card">
                        <div class="form-card-header">
                            <div class="header-icon"><i class="bi bi-image"></i></div>
                            <h3>Event Banner</h3>
                        </div>
                        <div class="form-card-body">
                            <div class="upload-zone" id="bannerUploadZone" onclick="document.getElementById('bannerFile').click()">
                                <i class="bi bi-cloud-arrow-up" style="font-size:2.2rem;color:var(--fdf-accent);display:block;margin-bottom:10px;"></i>
                                <div style="font-weight:700;color:var(--fdf-navy);" id="uploadLabel">Click to upload banner image</div>
                                <div class="hint" style="margin-top:6px;">1200×600px · JPG or PNG · Max 5MB</div>
                                <img id="bannerPreview" class="upload-preview" alt="Banner preview"/>
                            </div>
                            <input type="file" id="bannerFile" name="bannerImage" accept="image/*" style="display:none;" onchange="previewBanner(this)"/>
                            <div class="field-error" id="err-banner" style="margin-top:10px;"><i class="bi bi-exclamation-circle-fill"></i><span>Please select a valid image file (JPG, PNG, WebP) under 5MB.</span></div>
                        </div>
                    </div>
                </div>

                <div class="sticky-panel">
                    <div class="submit-card">
                        <div class="info-box">
                            <i class="bi bi-info-circle"></i>
                            Your event is submitted for admin approval before it appears publicly.
                        </div>
                        <button type="button" class="submit-btn" id="btnSubmitApproval" onclick="handleFormAction('submit')"><i class="bi bi-send"></i> Submit for Approval</button>
                        <button type="button" class="cancel-btn" id="btnSaveDraft" onclick="handleFormAction('draft')" style="cursor:pointer;">Save Draft</button>
                        <button type="button" class="submit-btn" id="btnReviewEvent" onclick="handleFormAction('review')"><i class="bi bi-eye"></i> Review event</button>
                        <a href="${pageContext.request.contextPath}/women-events/organizer/dashboard" class="cancel-btn">Cancel</a>
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

<div id="createPreviewOverlay" class="we-modal-overlay" onclick="if(event.target===this)closeCreatePreview()">
    <div class="we-modal" role="dialog">
        <div class="we-modal-header">
            <div>
                <h3>Preview event</h3>
                <p>This is what you are submitting for admin approval.</p>
            </div>
            <button type="button" class="we-modal-close" onclick="closeCreatePreview()" aria-label="Close">&times;</button>
        </div>
        <div class="we-modal-body" id="createPreviewBody"></div>
        <div class="we-modal-footer">
            <button type="button" class="we-modal-btn secondary" onclick="closeCreatePreview()">Edit</button>
            <button type="button" class="we-modal-btn primary" id="createPreviewSubmitBtn" onclick="submitCreateAfterPreview()">Submit for approval</button>
        </div>
    </div>
</div>

<!-- LEAFLET MAP MODAL (OpenStreetMap + Leaflet, CSP Compliant) -->
<div id="mapPickerModal" class="modal-overlay" role="dialog" aria-modal="true" aria-labelledby="mapModalTitle">
    <div class="map-modal-card">
        <div class="modal-header-row">
            <div class="modal-title">
                <i class="bi bi-geo-alt-fill" style="color:var(--fdf-accent);"></i>
                <span id="mapModalTitle">Select Event Venue &amp; City Location</span>
            </div>
            <button type="button" class="btn-close-modal" id="btnCloseMapModal" aria-label="Close">&times;</button>
        </div>

        <div class="map-search-bar">
            <input type="text" id="mapSearchInput" class="map-search-input" placeholder="Search landmark, street, city or area in India...">
            <button type="button" class="btn-map-picker" id="btnSearchMap" style="padding: 0 16px; border-radius: 8px;">
                <i class="bi bi-search"></i>
            </button>
            <button type="button" class="btn-secondary" id="btnLocateMe" style="padding: 0 14px; font-size: 0.84rem; border: 1px solid var(--fdf-border); background: #FFF; border-radius:8px; cursor:pointer;" title="Use my current location">
                <i class="bi bi-crosshair"></i> Current Location
            </button>
            <div id="mapSuggestions" class="map-suggestions-box"></div>
        </div>

        <div id="mapPickerAlert" style="display:none;background:#FEF2F2;border:1px solid #FECACA;color:#DC2626;padding:8px 16px;font-size:0.8rem;"></div>

        <div id="mapContainer"></div>

        <div class="map-modal-footer">
            <div class="map-selected-address-box">
                <i class="bi bi-pin-map-fill" style="color:var(--fdf-accent);"></i>
                <span id="mapSelectedAddress">Click on the map or drag the pin to select venue location</span>
            </div>
            <div class="map-modal-actions">
                <button type="button" class="btn-secondary" id="btnCancelMap" style="padding: 8px 16px; border-radius: 8px; border: 1px solid var(--fdf-border); background: #FFF; cursor:pointer;">Cancel</button>
                <button type="button" class="btn-map-picker" id="btnConfirmLocation" disabled>
                    <i class="bi bi-check-lg"></i> Confirm Location
                </button>
            </div>
        </div>
    </div>
</div>

<style>
.check-item { display: flex; align-items: center; gap: 10px; font-size: 0.85rem; color: var(--fdf-text-muted); }
.check-item i { color: var(--fdf-border); font-size: 1rem; }
.check-item.done i { color: #16A34A; }
.check-item.done span { color: var(--fdf-navy); }
</style>

<!-- Leaflet Map JS -->
<script src="https://cdn.jsdelivr.net/npm/leaflet@1.9.4/dist/leaflet.js"></script>

<script>
const ctx = '${pageContext.request.contextPath}';

// -------------------------------------------------------------
// Curated Indian States & Cities / Districts Dictionary
// -------------------------------------------------------------
const INDIA_STATES_DATA = {
    "Andhra Pradesh": ["Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool", "Kakinada", "Rajahmundry", "Tirupati", "Kadapa", "Anantapur", "Vizianagaram", "Eluru", "Ongole", "Nandyal", "Machilipatnam", "Other"],
    "Arunachal Pradesh": ["Itanagar", "Naharlagun", "Pasighat", "Tawang", "Ziro", "Other"],
    "Assam": ["Guwahati (Kamrup Metro)", "Silchar", "Dibrugarh", "Jorhat", "Nagaon", "Tinsukia", "Tezpur", "Bongaigaon", "Other"],
    "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia", "Darbhanga", "Bihar Sharif", "Arrah", "Begusarai", "Katihar", "Other"],
    "Chhattisgarh": ["Raipur", "Bhilai", "Bilaspur", "Korba", "Rajnandgaon", "Jagdalpur", "Raigarh", "Other"],
    "Goa": ["Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "North Goa", "South Goa", "Other"],
    "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Gandhinagar", "Junagadh", "Anand", "Navsari", "Morbi", "Other"],
    "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", "Karnal", "Sonipat", "Panchkula", "Other"],
    "Himachal Pradesh": ["Shimla", "Dharamshala", "Mandi", "Solan", "Kullu", "Hamirpur", "Una", "Other"],
    "Jharkhand": ["Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Deoghar", "Hazaribagh", "Other"],
    "Karnataka": ["Bengaluru", "Mysuru", "Hubballi-Dharwad", "Mangaluru", "Belagavi", "Kalaburagi", "Davanagere", "Ballari", "Shivamogga", "Udupi", "Other"],
    "Kerala": ["Thiruvananthapuram", "Kochi (Ernakulam)", "Kozhikode", "Thrissur", "Kollam", "Palakkad", "Kannur", "Kottayam", "Alappuzha", "Other"],
    "Madhya Pradesh": ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna", "Ratlam", "Other"],
    "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Thane", "Nashik", "Chhatrapati Sambhajinagar (Aurangabad)", "Solapur", "Kolhapur", "Navi Mumbai", "Amravati", "Other"],
    "Manipur": ["Imphal West", "Imphal East", "Thoubal", "Churachandpur", "Other"],
    "Meghalaya": ["Shillong", "Tura", "Jowai", "Other"],
    "Mizoram": ["Aizawl", "Lunglei", "Champhai", "Other"],
    "Nagaland": ["Kohima", "Dimapur", "Mokokchung", "Other"],
    "Odisha": ["Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur", "Puri", "Balasore", "Other"],
    "Punjab": ["Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "SAS Nagar (Mohali)", "Hoshiarpur", "Other"],
    "Rajasthan": ["Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar", "Other"],
    "Sikkim": ["Gangtok", "Namchi", "Gyalshing", "Other"],
    "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Vellore", "Erode", "Other"],
    "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar", "Ramagundam", "Secunderabad", "Other"],
    "Tripura": ["Agartala", "Dharmanagar", "Udaipur", "Other"],
    "Uttar Pradesh": ["Lucknow", "Kanpur", "Varanasi", "Agra", "Prayagraj", "Noida / Greater Noida", "Ghaziabad", "Meerut", "Bareilly", "Aligarh", "Other"],
    "Uttarakhand": ["Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rishikesh", "Nainital", "Other"],
    "West Bengal": ["Kolkata", "Howrah", "Durgapur", "Asansol", "Siliguri", "Darjeeling", "Other"],
    "Delhi": ["New Delhi", "Central Delhi", "South Delhi", "North Delhi", "East Delhi", "West Delhi", "Other"],
    "Chandigarh": ["Chandigarh", "Other"],
    "Jammu and Kashmir": ["Srinagar", "Jammu", "Anantnag", "Baramulla", "Other"],
    "Ladakh": ["Leh", "Kargil", "Other"],
    "Puducherry": ["Puducherry", "Karaikal", "Other"]
};

const savedState = "<c:out value='${host.state}'/>";
const savedCity = "<c:out value='${host.city}'/>";
const defaultHostLat = ${host.latitude != null ? host.latitude : 19.0760};
const defaultHostLng = ${host.longitude != null ? host.longitude : 72.8777};

// Populate state dropdown on page load
function initLocationDropdowns() {
    const stateSel = document.getElementById('stateSelect');
    if (!stateSel) return;
    stateSel.innerHTML = '<option value="">-- Select State / UT --</option>';
    Object.keys(INDIA_STATES_DATA).sort().forEach(st => {
        const opt = document.createElement('option');
        opt.value = st;
        opt.textContent = st;
        if (savedState && savedState.toLowerCase() === st.toLowerCase()) {
            opt.selected = true;
        }
        stateSel.appendChild(opt);
    });
    if (stateSel.value) {
        onStateChange(savedCity);
    }
}

function onStateChange(presetCity) {
    const stateSel = document.getElementById('stateSelect');
    const distSel = document.getElementById('districtSelect');
    const customGroup = document.getElementById('customCityGroup');
    const cityInput = document.getElementById('cityField');
    if (!stateSel || !distSel) return;

    const state = stateSel.value;
    distSel.innerHTML = '';

    if (!state || !INDIA_STATES_DATA[state]) {
        distSel.innerHTML = '<option value="">-- Select State First --</option>';
        if (customGroup) customGroup.style.display = 'none';
        return;
    }

    distSel.innerHTML = '<option value="">-- Select City / District --</option>';
    const cities = INDIA_STATES_DATA[state];
    let matched = false;
    const targetCity = presetCity || (cityInput ? cityInput.value : '');

    cities.forEach(c => {
        const opt = document.createElement('option');
        opt.value = c;
        opt.textContent = c;
        if (targetCity && (targetCity.toLowerCase() === c.toLowerCase() || c.toLowerCase().includes(targetCity.toLowerCase()))) {
            opt.selected = true;
            matched = true;
        }
        distSel.appendChild(opt);
    });

    if (targetCity && !matched && targetCity.trim() && targetCity !== 'Virtual') {
        distSel.value = 'Other';
        if (customGroup) customGroup.style.display = 'block';
        const customInput = document.getElementById('customCityInput');
        if (customInput) customInput.value = targetCity;
        if (cityInput) cityInput.value = targetCity;
    } else {
        if (customGroup) customGroup.style.display = 'none';
        if (cityInput && distSel.value && distSel.value !== 'Other') {
            cityInput.value = distSel.value;
        }
    }
    validateField('state');
    validateField('city');
    updateChecklist();
}

function onDistrictChange() {
    const distSel = document.getElementById('districtSelect');
    const customGroup = document.getElementById('customCityGroup');
    const customInput = document.getElementById('customCityInput');
    const cityInput = document.getElementById('cityField');
    if (!distSel) return;

    if (distSel.value === 'Other') {
        if (customGroup) customGroup.style.display = 'block';
        if (cityInput) cityInput.value = (customInput?.value || '').trim();
    } else {
        if (customGroup) customGroup.style.display = 'none';
        if (cityInput) cityInput.value = distSel.value;
    }
    validateField('city');
    updateChecklist();
}

function onCustomCityInput() {
    const customInput = document.getElementById('customCityInput');
    const cityInput = document.getElementById('cityField');
    if (cityInput && customInput) {
        cityInput.value = customInput.value.trim();
    }
    validateField('city');
    updateChecklist();
}

// -------------------------------------------------------------
// Interactive Leaflet Map Picker
// -------------------------------------------------------------
let mapInitialized = false;
let currentMap = null;
let currentMarker = null;
let selectedCoords = null;
let selectedAddressText = '';
let selectedComponents = {};

const mapModal = document.getElementById('mapPickerModal');
const btnOpenMap = document.getElementById('btnOpenMapPicker');
const btnCloseMap = document.getElementById('btnCloseMapModal');
const btnCancelMap = document.getElementById('btnCancelMap');
const btnConfirmMap = document.getElementById('btnConfirmLocation');
const btnSearchMap = document.getElementById('btnSearchMap');
const btnLocateMe = document.getElementById('btnLocateMe');
const mapSearchInput = document.getElementById('mapSearchInput');
const mapSuggestions = document.getElementById('mapSuggestions');
const mapSelectedAddressEl = document.getElementById('mapSelectedAddress');
const mapAlertEl = document.getElementById('mapPickerAlert');

function showMapAlert(msg) {
    if (!mapAlertEl) return;
    if (msg) {
        mapAlertEl.textContent = msg;
        mapAlertEl.style.display = 'block';
    } else {
        mapAlertEl.style.display = 'none';
        mapAlertEl.textContent = '';
    }
}

function setMapSelectedLocation(address, lat, lng, comps) {
    selectedCoords = { lat: lat, lng: lng };
    selectedAddressText = address || '';
    if (comps) selectedComponents = comps;
    if (mapSelectedAddressEl) {
        mapSelectedAddressEl.textContent = address || ('Selected: ' + lat.toFixed(5) + ', ' + lng.toFixed(5));
    }
    if (btnConfirmMap) {
        btnConfirmMap.disabled = false;
    }
}

async function reverseGeocodeCoords(lat, lng) {
    setMapSelectedLocation('Resolving venue address…', lat, lng);
    showMapAlert('');
    selectedComponents = {};

    // 1. Try local backend geocoding proxy
    try {
        const res = await fetch(ctx + '/api/auth/geo/reverse?lat=' + encodeURIComponent(lat) + '&lng=' + encodeURIComponent(lng), {
            headers: { 'Accept': 'application/json' },
            credentials: 'same-origin'
        });
        if (res.ok) {
            const data = await res.json();
            if (data && data.success && data.address) {
                setMapSelectedLocation(data.address, lat, lng);
                parseAddressString(data.address);
                return;
            }
        }
    } catch (e) {
        console.warn('[MapPicker] Backend reverse geocode error:', e);
    }

    // 2. Fallback to OpenStreetMap Nominatim
    try {
        const nomRes = await fetch('https://nominatim.openstreetmap.org/reverse?format=json&lat=' + encodeURIComponent(lat) + '&lon=' + encodeURIComponent(lng) + '&addressdetails=1', {
            headers: { 'Accept': 'application/json' }
        });
        if (nomRes.ok) {
            const nomData = await nomRes.json();
            if (nomData && nomData.display_name) {
                const addr = nomData.address || {};
                selectedComponents = {
                    city: addr.city || addr.town || addr.village || addr.city_district || addr.suburb || '',
                    state: addr.state || '',
                    pincode: addr.postcode || '',
                    road: addr.road || addr.building || ''
                };
                setMapSelectedLocation(nomData.display_name, lat, lng, selectedComponents);
                return;
            }
        }
    } catch (e) {
        console.warn('[MapPicker] Nominatim reverse geocode error:', e);
    }

    setMapSelectedLocation('Venue Coordinates (' + lat.toFixed(5) + ', ' + lng.toFixed(5) + ')', lat, lng);
}

function parseAddressString(fullAddress) {
    if (!fullAddress) return;
    const parts = fullAddress.split(',').map(s => s.trim());
    if (parts.length > 0) {
        // Check for pincode pattern (6 digits)
        const pinMatch = fullAddress.match(/\b\d{6}\b/);
        if (pinMatch) selectedComponents.pincode = pinMatch[0];

        // Match state against our known states
        for (let st of Object.keys(INDIA_STATES_DATA)) {
            if (fullAddress.toLowerCase().includes(st.toLowerCase())) {
                selectedComponents.state = st;
                // Check if any district from this state matches
                for (let d of INDIA_STATES_DATA[st]) {
                    if (d !== 'Other' && fullAddress.toLowerCase().includes(d.toLowerCase())) {
                        selectedComponents.city = d;
                        break;
                    }
                }
                break;
            }
        }
    }
}

function initMap() {
    if (typeof L === 'undefined') {
        showMapAlert('Map library failed to load. You can paste your Google Maps link directly.');
        return;
    }

    if (mapInitialized && currentMap) {
        currentMap.invalidateSize();
        return;
    }

    const initLat = selectedCoords ? selectedCoords.lat : defaultHostLat;
    const initLng = selectedCoords ? selectedCoords.lng : defaultHostLng;

    currentMap = L.map('mapContainer').setView([initLat, initLng], 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(currentMap);

    currentMarker = L.marker([initLat, initLng], { draggable: true }).addTo(currentMap);

    currentMarker.on('dragend', function (e) {
        const pos = e.target.getLatLng();
        reverseGeocodeCoords(pos.lat, pos.lng);
    });

    currentMap.on('click', function (e) {
        if (currentMarker) {
            currentMarker.setLatLng(e.latlng);
        } else {
            currentMarker = L.marker(e.latlng, { draggable: true }).addTo(currentMap);
            currentMarker.on('dragend', function (ev) {
                const pos = ev.target.getLatLng();
                reverseGeocodeCoords(pos.lat, pos.lng);
            });
        }
        reverseGeocodeCoords(e.latlng.lat, e.latlng.lng);
    });

    mapInitialized = true;
    reverseGeocodeCoords(initLat, initLng);
}

function openMapModal() {
    if (!mapModal) return;
    mapModal.classList.add('open');
    showMapAlert('');
    setTimeout(() => {
        initMap();
        if (currentMap) currentMap.invalidateSize();
    }, 200);
}

function closeMapModal() {
    if (mapModal) mapModal.classList.remove('open');
    if (mapSuggestions) mapSuggestions.style.display = 'none';
}

// Search locations
let searchDebounce = null;
async function performMapSearch(query) {
    if (!query || query.trim().length < 3) return;
    showMapAlert('');
    mapSuggestions.innerHTML = '<div class="map-suggestion-item" style="color:var(--fdf-text-muted);"><i class="bi bi-hourglass-split"></i> Searching…</div>';
    mapSuggestions.style.display = 'block';

    try {
        let results = [];
        // 1. Try local proxy
        try {
            const res = await fetch(ctx + '/api/auth/geo/search?q=' + encodeURIComponent(query.trim()), {
                headers: { 'Accept': 'application/json' },
                credentials: 'same-origin'
            });
            if (res.ok) {
                const data = await res.json();
                if (data && data.success && Array.isArray(data.results)) {
                    results = data.results.map(r => ({
                        name: r.name || r.formattedAddress || r.address,
                        lat: parseFloat(r.lat || (r.location && r.location.lat)),
                        lng: parseFloat(r.lng || (r.location && r.location.lng))
                    }));
                }
            }
        } catch (_) {}

        // 2. Fallback Nominatim
        if (results.length === 0) {
            const nomRes = await fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query.trim() + ', India') + '&limit=5', {
                headers: { 'Accept': 'application/json' }
            });
            if (nomRes.ok) {
                const nomData = await nomRes.json();
                results = nomData.map(r => ({
                    name: r.display_name,
                    lat: parseFloat(r.lat),
                    lng: parseFloat(r.lon)
                }));
            }
        }

        if (results.length === 0) {
            mapSuggestions.innerHTML = '<div class="map-suggestion-item" style="color:var(--fdf-text-muted);">No locations found. Try a different landmark or area.</div>';
            return;
        }

        mapSuggestions.innerHTML = '';
        results.forEach(item => {
            const div = document.createElement('div');
            div.className = 'map-suggestion-item';
            div.innerHTML = '<i class="bi bi-geo-alt-fill me-1" style="color:var(--fdf-accent);"></i> ' + item.name;
            div.onclick = function () {
                mapSuggestions.style.display = 'none';
                if (mapSearchInput) mapSearchInput.value = item.name;
                if (currentMap) {
                    currentMap.setView([item.lat, item.lng], 16);
                    if (currentMarker) currentMarker.setLatLng([item.lat, item.lng]);
                }
                reverseGeocodeCoords(item.lat, item.lng);
            };
            mapSuggestions.appendChild(div);
        });

    } catch (e) {
        mapSuggestions.innerHTML = '<div class="map-suggestion-item" style="color:#DC2626;">Error searching location.</div>';
    }
}

// Current location button
function locateUserOnMap() {
    if (!navigator.geolocation) {
        showMapAlert('Geolocation is not supported by your browser.');
        return;
    }
    showMapAlert('');
    btnLocateMe.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Locating…';
    navigator.geolocation.getCurrentPosition(
        function (pos) {
            btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> Current Location';
            const lat = pos.coords.latitude;
            const lng = pos.coords.longitude;
            if (currentMap) {
                currentMap.setView([lat, lng], 16);
                if (currentMarker) currentMarker.setLatLng([lat, lng]);
            }
            reverseGeocodeCoords(lat, lng);
        },
        function (err) {
            btnLocateMe.innerHTML = '<i class="bi bi-crosshair"></i> Current Location';
            showMapAlert('Unable to retrieve location: ' + err.message);
        },
        { enableHighAccuracy: true, timeout: 10000 }
    );
}

// Confirm location selection
function confirmSelectedLocation() {
    if (!selectedCoords) return;

    // 1. Google maps link & coords
    const mapsUrl = 'https://maps.google.com/?q=' + selectedCoords.lat.toFixed(6) + ',' + selectedCoords.lng.toFixed(6);
    const mapsField = document.getElementById('mapsLocationField');
    if (mapsField) mapsField.value = mapsUrl;

    const coordsSpan = document.getElementById('coordsSpan');
    if (coordsSpan) coordsSpan.textContent = selectedCoords.lat.toFixed(5) + ', ' + selectedCoords.lng.toFixed(5);

    // 2. Fill venue / street address if empty or user wants it
    const venueField = document.getElementById('venueField');
    if (venueField && (!venueField.value || venueField.value.trim() === '')) {
        venueField.value = selectedAddressText;
    }

    // 3. Auto-detect State & City
    if (selectedComponents.state) {
        const stateSel = document.getElementById('stateSelect');
        if (stateSel) {
            for (let opt of stateSel.options) {
                if (opt.value && opt.value.toLowerCase() === selectedComponents.state.toLowerCase()) {
                    opt.selected = true;
                    onStateChange(selectedComponents.city || '');
                    break;
                }
            }
        }
    } else if (selectedAddressText) {
        // Scan full address for state
        const stateSel = document.getElementById('stateSelect');
        if (stateSel) {
            for (let st of Object.keys(INDIA_STATES_DATA)) {
                if (selectedAddressText.toLowerCase().includes(st.toLowerCase())) {
                    stateSel.value = st;
                    onStateChange();
                    break;
                }
            }
        }
    }

    // 4. Match City / District
    if (selectedComponents.city) {
        const distSel = document.getElementById('districtSelect');
        const cityField = document.getElementById('cityField');
        if (distSel) {
            let matched = false;
            for (let opt of distSel.options) {
                if (opt.value && opt.value.toLowerCase() === selectedComponents.city.toLowerCase()) {
                    opt.selected = true;
                    if (cityField) cityField.value = opt.value;
                    matched = true;
                    break;
                }
            }
            if (!matched && selectedComponents.city.trim()) {
                distSel.value = 'Other';
                const customGroup = document.getElementById('customCityGroup');
                const customInput = document.getElementById('customCityInput');
                if (customGroup) customGroup.style.display = 'block';
                if (customInput) customInput.value = selectedComponents.city;
                if (cityField) cityField.value = selectedComponents.city;
            }
        }
    }

    // 5. Postal Pincode
    if (selectedComponents.pincode) {
        const pincodeField = document.getElementById('pincodeField');
        if (pincodeField) pincodeField.value = selectedComponents.pincode;
    }

    // 6. Area / neighborhood
    if (selectedComponents.road) {
        const areaField = document.getElementById('areaField');
        if (areaField && !areaField.value) areaField.value = selectedComponents.road;
    }

    // Re-validate populated fields to clear any error states
    validateField('venue');
    validateField('state');
    validateField('city');
    validateField('pincode');
    validateField('mapsLocation');

    closeMapModal();
    updateChecklist();
}

// -------------------------------------------------------------
// Page Event Listeners
// -------------------------------------------------------------
document.addEventListener('DOMContentLoaded', () => {
    const todayStr = new Date().toISOString().split('T')[0];
    const dateInput = document.querySelector('[name="eventDate"]');
    if (dateInput) dateInput.min = todayStr;

    initLocationDropdowns();

    // Map button listeners
    if (btnOpenMap) btnOpenMap.addEventListener('click', openMapModal);
    if (btnCloseMap) btnCloseMap.addEventListener('click', closeMapModal);
    if (btnCancelMap) btnCancelMap.addEventListener('click', closeMapModal);
    if (btnConfirmMap) btnConfirmMap.addEventListener('click', confirmSelectedLocation);
    if (btnLocateMe) btnLocateMe.addEventListener('click', locateUserOnMap);

    if (btnSearchMap) {
        btnSearchMap.addEventListener('click', () => {
            if (mapSearchInput) performMapSearch(mapSearchInput.value);
        });
    }

    if (mapSearchInput) {
        mapSearchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                performMapSearch(mapSearchInput.value);
            }
        });
        mapSearchInput.addEventListener('input', () => {
            clearTimeout(searchDebounce);
            const val = mapSearchInput.value.trim();
            if (val.length >= 3) {
                searchDebounce = setTimeout(() => performMapSearch(val), 400);
            } else if (mapSuggestions) {
                mapSuggestions.style.display = 'none';
            }
        });
    }
});

// -------------------------------------------------------------
// Form Validation & Live Field Feedback
// -------------------------------------------------------------
function setFieldError(fieldId, errorId, errorMsg) {
    const el = document.getElementById(fieldId);
    const errEl = document.getElementById(errorId);
    if (el) {
        el.classList.add('is-invalid');
        el.classList.remove('is-valid');
    }
    if (errEl) {
        if (errorMsg) {
            const span = errEl.querySelector('span');
            if (span) span.textContent = errorMsg;
        }
        errEl.classList.add('show');
    }
}

function clearFieldError(fieldId, errorId, markValid = true) {
    const el = document.getElementById(fieldId);
    const errEl = document.getElementById(errorId);
    if (el) {
        el.classList.remove('is-invalid');
        if (markValid && el.value && el.value.trim().length > 0) {
            el.classList.add('is-valid');
        } else {
            el.classList.remove('is-valid');
        }
    }
    if (errEl) {
        errEl.classList.remove('show');
    }
}

function isValidContactInfo(val) {
    if (!val) return false;
    val = val.trim();
    // 10 digit Indian mobile (optionally with +91 or 0 prefix)
    const phoneRegex = /^(\+91[\-\s]?)?[0]?[6-9]\d{9}$/;
    const cleanDigits = val.replace(/\D/g, '');
    const isPhone = phoneRegex.test(val) || (cleanDigits.length === 10 && ['6','7','8','9'].includes(cleanDigits[0]));
    // Email regex
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
    const isEmail = emailRegex.test(val);
    return isPhone || isEmail;
}

function validateField(name) {
    const isVirtual = document.getElementById('virtualBox')?.checked;

    switch (name) {
        case 'name': {
            const el = document.getElementById('eventNameInput');
            const val = el ? el.value.trim() : '';
            if (!val) {
                setFieldError('eventNameInput', 'err-name', 'Event name is required.');
                return false;
            } else if (val.length < 3) {
                setFieldError('eventNameInput', 'err-name', 'Event name must be at least 3 characters.');
                return false;
            } else {
                clearFieldError('eventNameInput', 'err-name');
                return true;
            }
        }
        case 'category': {
            const el = document.getElementById('categorySelect');
            const val = el ? el.value : '';
            if (!val) {
                setFieldError('categorySelect', 'err-category', 'Please select an event category.');
                return false;
            } else {
                clearFieldError('categorySelect', 'err-category');
                return true;
            }
        }
        case 'organizerType': {
            const el = document.getElementById('organizerTypeSelect');
            const val = el ? el.value : '';
            if (!val) {
                setFieldError('organizerTypeSelect', 'err-organizerType', 'Please select an organizer type.');
                return false;
            } else {
                clearFieldError('organizerTypeSelect', 'err-organizerType');
                return true;
            }
        }
        case 'organizerName': {
            const el = document.getElementById('organizerNameInput');
            const val = el ? el.value.trim() : '';
            if (!val) {
                setFieldError('organizerNameInput', 'err-organizerName', 'Organizer / organization name is required.');
                return false;
            } else if (val.length < 2) {
                setFieldError('organizerNameInput', 'err-organizerName', 'Organizer name must be at least 2 characters.');
                return false;
            } else {
                clearFieldError('organizerNameInput', 'err-organizerName');
                return true;
            }
        }
        case 'description': {
            const el = document.getElementById('descriptionInput');
            const val = el ? el.value.trim() : '';
            const counter = document.getElementById('descCharCount');
            if (counter) {
                counter.textContent = val.length + ' / 20 min';
                counter.className = 'char-counter ' + (val.length >= 20 ? 'valid' : (val.length > 0 ? 'invalid' : ''));
            }
            if (!val) {
                setFieldError('descriptionInput', 'err-description', 'Event description is required.');
                return false;
            } else if (val.length < 20) {
                setFieldError('descriptionInput', 'err-description', 'Please provide a detailed description (at least 20 characters).');
                return false;
            } else {
                clearFieldError('descriptionInput', 'err-description');
                return true;
            }
        }
        case 'eventDate': {
            const el = document.getElementById('eventDateInput');
            const val = el ? el.value : '';
            if (!val) {
                setFieldError('eventDateInput', 'err-eventDate', 'Please select an event date.');
                return false;
            }
            const selDate = new Date(val + 'T00:00:00');
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (selDate < today) {
                setFieldError('eventDateInput', 'err-eventDate', 'Event date cannot be in the past.');
                return false;
            } else {
                clearFieldError('eventDateInput', 'err-eventDate');
                if (document.getElementById('endDateInput')?.value) validateField('endDate');
                if (document.getElementById('registrationClosesInput')?.value) validateField('registrationCloses');
                return true;
            }
        }
        case 'endDate': {
            const startEl = document.getElementById('eventDateInput');
            const endEl = document.getElementById('endDateInput');
            const sVal = startEl ? startEl.value : '';
            const eVal = endEl ? endEl.value : '';
            if (eVal && sVal) {
                if (eVal < sVal) {
                    setFieldError('endDateInput', 'err-endDate', 'End date cannot be earlier than event start date.');
                    return false;
                }
            }
            clearFieldError('endDateInput', 'err-endDate');
            if (document.getElementById('endTimeInput')?.value) validateField('endTime');
            return true;
        }
        case 'endTime': {
            const startD = document.getElementById('eventDateInput')?.value || '';
            const endD = document.getElementById('endDateInput')?.value || '';
            const startT = document.getElementById('eventTimeInput')?.value || '';
            const endT = document.getElementById('endTimeInput')?.value || '';
            if (endT && startT && (endD === '' || endD === startD)) {
                if (endT <= startT) {
                    setFieldError('endTimeInput', 'err-endTime', 'End time must be after start time.');
                    return false;
                }
            }
            clearFieldError('endTimeInput', 'err-endTime');
            return true;
        }
        case 'registrationCloses': {
            const regEl = document.getElementById('registrationClosesInput');
            const rVal = regEl ? regEl.value : '';
            const startD = document.getElementById('eventDateInput')?.value || '';
            const startT = document.getElementById('eventTimeInput')?.value || '10:00';
            if (rVal && startD) {
                const regDate = new Date(rVal);
                const eventStartDate = new Date(startD + 'T' + startT);
                if (regDate > eventStartDate) {
                    setFieldError('registrationClosesInput', 'err-registrationCloses', 'Registration closing time cannot be after event start.');
                    return false;
                }
            }
            clearFieldError('registrationClosesInput', 'err-registrationCloses');
            return true;
        }
        case 'venue': {
            if (isVirtual) {
                clearFieldError('venueField', 'err-venue', false);
                return true;
            }
            const el = document.getElementById('venueField');
            const val = el ? el.value.trim() : '';
            if (!val || val === 'Online / Virtual') {
                setFieldError('venueField', 'err-venue', 'Street address or venue name is required.');
                return false;
            } else if (val.length < 3) {
                setFieldError('venueField', 'err-venue', 'Venue address must be at least 3 characters.');
                return false;
            } else {
                clearFieldError('venueField', 'err-venue');
                return true;
            }
        }
        case 'state': {
            if (isVirtual) {
                clearFieldError('stateSelect', 'err-state', false);
                return true;
            }
            const el = document.getElementById('stateSelect');
            const val = el ? el.value : '';
            if (!val) {
                setFieldError('stateSelect', 'err-state', 'Please select a State or Union Territory.');
                return false;
            } else {
                clearFieldError('stateSelect', 'err-state');
                return true;
            }
        }
        case 'city': {
            if (isVirtual) {
                clearFieldError('districtSelect', 'err-city', false);
                clearFieldError('customCityInput', 'err-customCity', false);
                return true;
            }
            const distEl = document.getElementById('districtSelect');
            const distVal = distEl ? distEl.value : '';
            if (!distVal) {
                setFieldError('districtSelect', 'err-city', 'Please select a City or District.');
                return false;
            }
            if (distVal === 'Other') {
                const customEl = document.getElementById('customCityInput');
                const customVal = customEl ? customEl.value.trim() : '';
                if (!customVal) {
                    setFieldError('customCityInput', 'err-customCity', 'Please enter your custom city or town name.');
                    return false;
                } else {
                    clearFieldError('customCityInput', 'err-customCity');
                }
            } else {
                clearFieldError('customCityInput', 'err-customCity', false);
            }
            clearFieldError('districtSelect', 'err-city');
            return true;
        }
        case 'pincode': {
            const el = document.getElementById('pincodeField');
            const val = el ? el.value.trim() : '';
            if (val) {
                const pinRegex = /^[1-9][0-9]{5}$/;
                if (!pinRegex.test(val)) {
                    setFieldError('pincodeField', 'err-pincode', 'Please enter a valid 6-digit Indian PIN code.');
                    return false;
                }
            }
            clearFieldError('pincodeField', 'err-pincode');
            return true;
        }
        case 'mapsLocation': {
            const el = document.getElementById('mapsLocationField');
            const val = el ? el.value.trim() : '';
            if (val && !val.startsWith('http://') && !val.startsWith('https://') && !val.includes(',')) {
                setFieldError('mapsLocationField', 'err-mapsLocation', 'Please enter a valid Google Maps link (https://...) or coordinates.');
                return false;
            }
            clearFieldError('mapsLocationField', 'err-mapsLocation');
            return true;
        }
        case 'streamLink': {
            if (!isVirtual) {
                clearFieldError('streamLinkInput', 'err-streamLink', false);
                return true;
            }
            const el = document.getElementById('streamLinkInput');
            const val = el ? el.value.trim() : '';
            if (val && !val.startsWith('http://') && !val.startsWith('https://')) {
                setFieldError('streamLinkInput', 'err-streamLink', 'Stream link must start with http:// or https://');
                return false;
            }
            clearFieldError('streamLinkInput', 'err-streamLink');
            return true;
        }
        case 'entryFee': {
            const isFree = document.getElementById('isFreeTrue')?.checked;
            if (isFree) {
                clearFieldError('entryFeeField', 'err-entryFee', false);
                return true;
            }
            const el = document.getElementById('entryFeeField');
            const val = el ? parseFloat(el.value) : 0;
            if (isNaN(val) || val <= 0) {
                setFieldError('entryFeeField', 'err-entryFee', 'Entry fee must be greater than ₹0 for paid events.');
                return false;
            } else {
                clearFieldError('entryFeeField', 'err-entryFee');
                return true;
            }
        }
        case 'boothFee': {
            const el = document.getElementById('boothFeeField');
            const val = el && el.value !== '' ? parseFloat(el.value) : 0;
            if (isNaN(val) || val < 0) {
                setFieldError('boothFeeField', 'err-boothFee', 'Booth fee cannot be negative.');
                return false;
            }
            clearFieldError('boothFeeField', 'err-boothFee');
            return true;
        }
        case 'maxParticipants': {
            const el = document.getElementById('maxParticipantsField');
            const val = el ? el.value.trim() : '';
            if (val !== '') {
                const num = parseInt(val, 10);
                if (isNaN(num) || num < 1) {
                    setFieldError('maxParticipantsField', 'err-maxParticipants', 'Maximum capacity must be at least 1.');
                    return false;
                }
            }
            clearFieldError('maxParticipantsField', 'err-maxParticipants');
            return true;
        }
        case 'contactInfo': {
            const el = document.getElementById('contactInfoInput');
            const val = el ? el.value.trim() : '';
            if (!val) {
                setFieldError('contactInfoInput', 'err-contactInfo', 'Contact information is required.');
                return false;
            } else if (!isValidContactInfo(val)) {
                setFieldError('contactInfoInput', 'err-contactInfo', 'Please enter a valid 10-digit mobile number or email address.');
                return false;
            } else {
                clearFieldError('contactInfoInput', 'err-contactInfo');
                return true;
            }
        }
        case 'banner': {
            const fileInput = document.getElementById('bannerFile');
            if (fileInput && fileInput.files && fileInput.files[0]) {
                const file = fileInput.files[0];
                if (file.size > 5 * 1024 * 1024) {
                    setFieldError('bannerUploadZone', 'err-banner', 'Banner file exceeds 5MB limit. Please choose a smaller image.');
                    return false;
                }
                if (!file.type.startsWith('image/')) {
                    setFieldError('bannerUploadZone', 'err-banner', 'Selected file is not an image (JPG, PNG, WebP only).');
                    return false;
                }
            }
            clearFieldError('bannerUploadZone', 'err-banner');
            return true;
        }
        default:
            return true;
    }
}

function validateForm(forDraft = false) {
    let isValid = true;
    let firstInvalidEl = null;

    const fieldsToCheck = [
        { name: 'name', el: document.getElementById('eventNameInput') },
        { name: 'category', el: document.getElementById('categorySelect') },
        { name: 'organizerType', el: document.getElementById('organizerTypeSelect') },
        { name: 'organizerName', el: document.getElementById('organizerNameInput') },
        { name: 'description', el: document.getElementById('descriptionInput') },
        { name: 'eventDate', el: document.getElementById('eventDateInput') },
        { name: 'endDate', el: document.getElementById('endDateInput') },
        { name: 'endTime', el: document.getElementById('endTimeInput') },
        { name: 'registrationCloses', el: document.getElementById('registrationClosesInput') },
        { name: 'venue', el: document.getElementById('venueField') },
        { name: 'state', el: document.getElementById('stateSelect') },
        { name: 'city', el: document.getElementById('districtSelect') },
        { name: 'pincode', el: document.getElementById('pincodeField') },
        { name: 'mapsLocation', el: document.getElementById('mapsLocationField') },
        { name: 'streamLink', el: document.getElementById('streamLinkInput') },
        { name: 'entryFee', el: document.getElementById('entryFeeField') },
        { name: 'boothFee', el: document.getElementById('boothFeeField') },
        { name: 'maxParticipants', el: document.getElementById('maxParticipantsField') },
        { name: 'contactInfo', el: document.getElementById('contactInfoInput') },
        { name: 'banner', el: document.getElementById('bannerUploadZone') }
    ];

    for (let f of fieldsToCheck) {
        const fieldOk = validateField(f.name);
        if (!fieldOk) {
            isValid = false;
            if (!firstInvalidEl && f.el) {
                firstInvalidEl = f.el;
            }
        }
    }

    const summary = document.getElementById('formValidationSummary');
    if (!isValid) {
        if (summary) {
            summary.style.display = 'flex';
            const sumText = document.getElementById('formValidationSummaryText');
            if (sumText) sumText.textContent = 'Please correct the highlighted fields with errors below before submitting.';
        }
        if (firstInvalidEl) {
            firstInvalidEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
            if (typeof firstInvalidEl.focus === 'function') firstInvalidEl.focus();
        }
    } else {
        if (summary) summary.style.display = 'none';
    }

    return isValid;
}

function handleFormAction(action) {
    const saveDraftInput = document.getElementById('saveDraftInput');
    const form = document.getElementById('createEventForm');

    if (action === 'draft') {
        if (saveDraftInput) saveDraftInput.value = 'true';
        const valid = validateForm(true);
        if (!valid) return;
        form.dataset.confirmed = '1';
        form.submit();
        return;
    }

    if (saveDraftInput) saveDraftInput.value = 'false';

    if (action === 'review' || action === 'submit') {
        const valid = validateForm(false);
        if (!valid) return;
        openCreatePreview();
    }
}

function updateChecklist() {
    function setCheck(id, filled) {
        const el = document.getElementById(id);
        if (!el) return;
        el.classList.toggle('done', filled);
        const icon = el.querySelector('i');
        if (icon) icon.className = filled ? 'bi bi-check-circle-fill' : 'bi bi-circle';
    }
    setCheck('chk-name', (document.querySelector('[name="name"]')?.value || '').trim().length >= 3);
    setCheck('chk-cat', document.querySelector('[name="category"]')?.value !== '');
    setCheck('chk-desc', (document.querySelector('[name="description"]')?.value || '').trim().length >= 20);
    setCheck('chk-date', document.querySelector('[name="eventDate"]')?.value !== '');

    const isVirtual = document.querySelector('[name="virtual"]')?.checked;
    if (isVirtual) {
        setCheck('chk-venue', true);
    } else {
        const hasVenue = (document.querySelector('[name="venue"]')?.value || '').trim().length >= 3;
        const hasCity = (document.getElementById('cityField')?.value || '').trim().length > 0;
        setCheck('chk-venue', hasVenue && hasCity);
    }
    setCheck('chk-contact', isValidContactInfo(document.querySelector('[name="contactInfo"]')?.value || ''));
}

// Bind live validation on blur & input
const fieldMappings = [
    { id: 'eventNameInput', name: 'name' },
    { id: 'categorySelect', name: 'category' },
    { id: 'organizerTypeSelect', name: 'organizerType' },
    { id: 'organizerNameInput', name: 'organizerName' },
    { id: 'descriptionInput', name: 'description' },
    { id: 'eventDateInput', name: 'eventDate' },
    { id: 'endDateInput', name: 'endDate' },
    { id: 'endTimeInput', name: 'endTime' },
    { id: 'registrationClosesInput', name: 'registrationCloses' },
    { id: 'venueField', name: 'venue' },
    { id: 'stateSelect', name: 'state' },
    { id: 'districtSelect', name: 'city' },
    { id: 'customCityInput', name: 'city' },
    { id: 'pincodeField', name: 'pincode' },
    { id: 'mapsLocationField', name: 'mapsLocation' },
    { id: 'streamLinkInput', name: 'streamLink' },
    { id: 'entryFeeField', name: 'entryFee' },
    { id: 'boothFeeField', name: 'boothFee' },
    { id: 'maxParticipantsField', name: 'maxParticipants' },
    { id: 'contactInfoInput', name: 'contactInfo' }
];

fieldMappings.forEach(mapping => {
    const el = document.getElementById(mapping.id);
    if (el) {
        el.addEventListener('blur', () => validateField(mapping.name));
        el.addEventListener('input', () => {
            validateField(mapping.name);
            updateChecklist();
        });
        el.addEventListener('change', () => {
            validateField(mapping.name);
            updateChecklist();
        });
    }
});

updateChecklist();

document.getElementById('createEventForm')?.addEventListener('submit', function(e) {
    if (this.dataset.confirmed === '1') return;
    e.preventDefault();
    handleFormAction('submit');
});

function fv(name) {
    const el = document.querySelector('[name="' + name + '"]');
    return el && el.value ? el.value.trim() : '';
}

function openCreatePreview() {
    const catSel = document.querySelector('[name="category"]');
    const catLabel = catSel && catSel.selectedOptions[0] ? catSel.selectedOptions[0].text : fv('category');
    const isFree = document.querySelector('[name="isFree"]:checked')?.value === 'true';
    const isVirtual = document.querySelector('[name="virtual"]')?.checked;
    const rows = [
        ['Event name', fv('name')],
        ['Category', catLabel],
        ['Organizer type', fv('organizerType')],
        ['Organizer name', fv('organizerName')],
        ['Description', fv('description')],
        ['Date', fv('eventDate') || 'Not provided'],
        ['Time', fv('eventTime') || 'Not provided'],
        ['End date', fv('endDate') || 'Same day'],
        ['End time', fv('endTime') || 'Not specified'],
        ['Registration closes', fv('registrationCloses') || 'At event start'],
        ['Mode', isVirtual ? 'Online' : 'In person'],
        ['Stream link', fv('streamLink') || 'Not provided'],
        ['Venue', fv('venue') || 'Not provided'],
        ['City', fv('city') || 'Not provided'],
        ['State', fv('venueState') || 'Not provided'],
        ['Pincode', fv('venuePincode') || 'Not provided'],
        ['Area', fv('venueArea') || 'Not provided'],
        ['Maps / address', fv('mapsLocation') || 'Not provided'],
        ['Entry', isFree ? 'Free' : ('₹' + (fv('entryFee') || '0'))],
        ['Booth fee', fv('boothFee') || '0'],
        ['Capacity', fv('maxParticipants') || 'Not limited'],
        ['Contact', fv('contactInfo') || 'Not provided'],
        ['Banner', document.getElementById('bannerFile')?.files?.[0]?.name || 'Not uploaded']
    ];
    document.getElementById('createPreviewBody').innerHTML = rows.map(function(r) {
        return '<div class="we-modal-row"><span class="k">' + r[0] + '</span><span class="v">' +
            (r[1] ? r[1].replace(/</g,'&lt;') : 'Not provided') + '</span></div>';
    }).join('');
    document.getElementById('createPreviewOverlay').classList.add('open');
}

function closeCreatePreview() {
    document.getElementById('createPreviewOverlay').classList.remove('open');
}

function submitCreateAfterPreview() {
    const form = document.getElementById('createEventForm');
    const btn = document.getElementById('createPreviewSubmitBtn');
    if (btn) { btn.disabled = true; btn.textContent = 'Submitting…'; }
    form.dataset.confirmed = '1';
    form.submit();
}

function toggleFee(isFree) {
    const feeInput = document.getElementById('feeInput');
    const feeField = document.getElementById('entryFeeField');
    if (feeInput) feeInput.style.display = isFree ? 'none' : 'block';
    if (isFree) {
        if (feeField) { feeField.value = '0'; feeField.min = '0'; feeField.required = false; }
        clearFieldError('entryFeeField', 'err-entryFee', false);
    } else {
        if (feeField) {
            feeField.min = '1';
            if (feeField.value === '0') feeField.value = '';
            feeField.required = true;
        }
        validateField('entryFee');
    }
}

function toggleFormat(fmt) {
    const box = document.getElementById('virtualBox');
    if (!box) return;
    box.checked = fmt === 'ONLINE' || fmt === 'HYBRID';
    toggleVirtual(box);
}

function toggleVirtual(checkbox) {
    const isVirtual = checkbox.checked;
    const streamGroup = document.getElementById('streamLinkGroup');
    if (streamGroup) streamGroup.style.display = isVirtual ? 'block' : 'none';
    const locWrapper = document.getElementById('offlineLocationWrapper');
    const venueField = document.getElementById('venueField');
    const cityField = document.getElementById('cityField');
    const stateSelect = document.getElementById('stateSelect');
    const districtSelect = document.getElementById('districtSelect');

    if (isVirtual) {
        if (locWrapper) locWrapper.style.display = 'none';
        if (venueField) { venueField.value = 'Online / Virtual'; venueField.required = false; }
        if (cityField) cityField.value = 'Virtual';
        if (stateSelect) stateSelect.required = false;
        if (districtSelect) districtSelect.required = false;
        clearFieldError('venueField', 'err-venue', false);
        clearFieldError('stateSelect', 'err-state', false);
        clearFieldError('districtSelect', 'err-city', false);
    } else {
        if (locWrapper) locWrapper.style.display = 'block';
        if (venueField && venueField.value === 'Online / Virtual') {
            venueField.value = '${not empty host.officeAddress ? host.officeAddress : ""}';
            venueField.required = true;
        }
        if (cityField && cityField.value === 'Virtual') {
            cityField.value = '${not empty host.city ? host.city : ""}';
        }
        if (stateSelect) stateSelect.required = true;
        if (districtSelect) districtSelect.required = true;
    }
    updateChecklist();
}

function previewBanner(input) {
    const preview = document.getElementById('bannerPreview');
    if (input.files && input.files[0]) {
        const file = input.files[0];
        const valid = validateField('banner');
        if (!valid) {
            if (preview) preview.style.display = 'none';
            document.getElementById('uploadLabel').textContent = 'Click to upload banner image';
            input.value = '';
            return;
        }
        const reader = new FileReader();
        reader.onload = e => { preview.src = e.target.result; preview.style.display = 'block'; };
        reader.readAsDataURL(file);
        document.getElementById('uploadLabel').textContent = file.name;
    }
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
