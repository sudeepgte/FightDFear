<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Form | Fight D Fear</title>
    <meta name="description" content="Official martial arts trainee enrollment and batch admission form for Fight D Fear verified academies.">

    <%-- Fonts & icons — matching myAttendance.jsp --%>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

    <style>
        /* ── Design tokens mirroring myAttendance.jsp ── */
        :root {
            --rose: #F43F5E;
            --rose-soft: #FFF1F2;
            --rose-border: #FECDD3;
            --navy: #0F172A;
            --muted: #64748B;
            --bg: #F8FAFC;
            --border: #E2E8F0;
        }

        body { font-family: 'Poppins', sans-serif; background: var(--bg); color: var(--navy); margin: 0; }

        /* Page wrapper */
        .enroll-wrap { padding: 96px 20px 60px; max-width: 1100px; }

        /* Page heading row */
        .page-header-row { display: flex; flex-wrap: wrap; justify-content: space-between; align-items: flex-start; gap: 12px; margin-bottom: 24px; }
        .page-header-row h1 { font-size: 1.6rem; font-weight: 800; margin-bottom: 4px; }
        .page-header-row p  { color: var(--muted); font-size: 0.9rem; margin-bottom: 0; }

        /* Context banner */
        .context-banner { background:#fff; border:1px solid var(--border); border-radius:16px; box-shadow:0 4px 18px rgba(15,23,42,0.04); padding:20px 24px; margin-bottom:24px; display:flex; flex-wrap:wrap; gap:20px; align-items:center; justify-content:space-between; }
        .context-badge  { display:inline-flex; align-items:center; gap:6px; background:var(--rose-soft); color:var(--rose); border:1px solid var(--rose-border); border-radius:999px; font-size:0.72rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em; padding:4px 12px; margin-bottom:6px; }
        .context-title  { font-size:1.15rem; font-weight:800; color:var(--navy); margin-bottom:2px; }
        .context-location { font-size:0.85rem; color:var(--muted); }
        .context-meta { display:flex; gap:24px; flex-wrap:wrap; }
        .context-meta-item { text-align:center; }
        .context-meta-label { display:block; font-size:0.65rem; font-weight:700; text-transform:uppercase; letter-spacing:0.06em; color:var(--muted); margin-bottom:2px; }
        .context-meta-value { font-weight:700; color:var(--navy); font-size:0.95rem; }
        .context-meta-value.fee { color:#16A34A; font-size:1.05rem; }

        /* Card panel — same as myAttendance.jsp */
        .card-panel { background:#fff; border:1px solid var(--border); border-radius:16px; box-shadow:0 4px 18px rgba(15,23,42,0.04); padding:24px; margin-bottom:20px; }
        .card-panel-title { font-size:0.95rem; font-weight:700; color:var(--navy); display:flex; align-items:center; gap:10px; margin-bottom:20px; padding-bottom:14px; border-bottom:1px solid var(--border); }
        .card-panel-title .panel-icon { width:34px; height:34px; border-radius:10px; background:var(--rose-soft); color:var(--rose); display:inline-flex; align-items:center; justify-content:center; font-size:1rem; flex-shrink:0; }

        /* Summary sidebar */
        .summary-sticky { position: sticky; top: 96px; }
        .summary-panel  { background:var(--navy); border-radius:16px; padding:24px; color:#fff; box-shadow:0 10px 30px rgba(15,23,42,0.18); }
        .summary-panel-title { font-size:1rem; font-weight:800; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:14px; margin-bottom:18px; }
        .summary-item { display:flex; align-items:center; gap:14px; margin-bottom:14px; }
        .summary-icon { width:32px; height:32px; border-radius:8px; background:rgba(255,255,255,0.08); display:flex; align-items:center; justify-content:center; color:var(--rose); flex-shrink:0; }
        .summary-label { display:block; font-size:0.72rem; color:#94a3b8; font-weight:600; }
        .summary-value { font-weight:600; font-size:0.9rem; }
        .fee-badge { background:var(--rose); border-radius:12px; padding:14px; text-align:center; margin-top:18px; }
        .fee-badge .fee-label { font-size:0.8rem; opacity:0.9; display:block; margin-bottom:4px; }
        .fee-badge .fee-value { font-size:1.4rem; font-weight:800; }
        .privacy-note { margin-top:16px; padding:12px; border-radius:10px; background:rgba(255,255,255,0.05); font-size:0.8rem; color:#94a3b8; }

        /* Form controls */
        .form-label { font-weight:600; font-size:0.82rem; color:var(--muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.04em; }
        .form-control, .form-select { border-radius:10px; padding:10px 14px; border:1.5px solid var(--border); font-size:0.9rem; font-family:'Poppins',sans-serif; transition:all 0.2s; }
        .form-control:focus, .form-select:focus { border-color:var(--rose); box-shadow:0 0 0 3px rgba(244,63,94,0.1); outline:none; }
        .form-control.bg-light { background:#F8FAFC !important; }
        .form-check-input:checked { background-color:var(--rose); border-color:var(--rose); }

        /* Days pill-chips */
        .days-group { display:flex; flex-wrap:wrap; gap:8px; padding:16px; background:var(--bg); border-radius:12px; border:1px solid var(--border); }
        .day-chip { display:none; }
        .day-chip-label { display:inline-flex; align-items:center; justify-content:center; padding:6px 14px; border-radius:999px; font-size:0.8rem; font-weight:600; border:1.5px solid var(--border); background:#fff; color:var(--navy); cursor:pointer; transition:all 0.15s; user-select:none; }
        .day-chip:checked + .day-chip-label { background:var(--rose); border-color:var(--rose); color:#fff; }
        .day-chip:disabled + .day-chip-label { opacity:0.55; cursor:not-allowed; }

        /* Skill level pill display */
        .skill-level-pill {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 10px 16px; border-radius: 10px;
            background: var(--rose-soft); border: 1.5px solid var(--rose-border);
            color: var(--navy); font-weight: 700; font-size: 0.9rem;
            min-height: 42px; width: 100%;
        }
        .skill-level-pill.empty {
            background: var(--bg); border-color: var(--border);
            color: var(--muted); font-weight: 400; font-size: 0.85rem;
        }

        /* Buttons */
        .btn-rose { background:var(--rose); color:#fff; border:none; border-radius:999px; font-weight:700; padding:12px 28px; font-family:'Poppins',sans-serif; font-size:0.9rem; cursor:pointer; transition:background 0.2s, transform 0.15s; display:inline-flex; align-items:center; gap:8px; }
        .btn-rose:hover { background:#E11D48; color:#fff; transform:translateY(-1px); }
        .btn-rose:disabled { opacity:0.65; cursor:not-allowed; transform:none; }
        .btn-outline-rose { border:1px solid var(--border); color:var(--navy); background:#fff; border-radius:999px; font-weight:600; padding:10px 20px; text-decoration:none; font-size:0.87rem; font-family:'Poppins',sans-serif; display:inline-flex; align-items:center; gap:6px; }
        .btn-outline-rose:hover { background:var(--rose-soft); color:var(--navy); }

        /* Motivation textarea */
        .motivation-box { background:var(--bg); border:1.5px dashed var(--border); padding:18px; border-radius:12px; }
        .motivation-box .form-control { border:none; background:#fff; }

        /* Consent items */
        .consent-item { display:flex; align-items:flex-start; gap:12px; padding:14px 16px; border-radius:10px; border:1px solid var(--border); margin-bottom:10px; background:var(--bg); }
        .consent-item .form-check-input { flex-shrink:0; margin-top:2px; }
        .consent-item label { font-size:0.87rem; color:var(--navy); cursor:pointer; }

        /* Responsive */
        @media (max-width: 991px) { .summary-sticky { position:static; margin-top:8px; } .enroll-wrap { padding-top:24px; } }
        @media (max-width: 767px) { .context-meta { gap:14px; } .context-banner { flex-direction:column; } }
    </style>
</head>
<body>

    <%-- Shared header + sidebar (same as myAttendance.jsp) --%>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

        <div id="page-content-wrapper" style="min-height:100vh; background:var(--bg);">
            <div class="container enroll-wrap">

                <%-- Page heading row --%>
                <div class="page-header-row">
                    <div>
                        <h1><i class="bi bi-journal-text me-2" style="color:var(--rose);"></i>Martial Arts Enrollment</h1>
                        <p>Official registration and batch admission form for verified academy training.</p>
                    </div>
                    <a class="btn-outline-rose" href="${pageContext.request.contextPath}/centres/details/${center.id}">
                        <i class="bi bi-arrow-left"></i> Back to Centre
                    </a>
                </div>

                <%-- Centre + batch context banner --%>
                <div class="context-banner">
                    <div>
                        <div class="context-badge"><i class="bi bi-shield-check"></i> Verified Training Centre</div>
                        <div class="context-title"><c:out value="${center.name}"/></div>
                        <div class="context-location"><i class="bi bi-geo-alt-fill" style="color:var(--rose);"></i> <c:out value="${not empty center.location ? center.location : 'Campus Dojo'}"/></div>
                    </div>
                    <div class="context-meta">
                        <div class="context-meta-item">
                            <span class="context-meta-label">Program / Style</span>
                            <span class="context-meta-value" id="topSelectedStyle">—</span>
                        </div>
                        <div class="context-meta-item">
                            <span class="context-meta-label">Selected Batch</span>
                            <span class="context-meta-value" id="topSelectedBatch">—</span>
                        </div>
                        <div class="context-meta-item">
                            <span class="context-meta-label">Monthly Fee</span>
                            <span class="context-meta-value fee" id="topSelectedFee">—</span>
                        </div>
                    </div>
                </div>

                <%-- Two-column layout --%>
                <div class="row g-4">
                    <%-- Left: Form --%>
                    <div class="col-lg-8">
                        <form id="complexEnrollmentForm" novalidate>
                            <input type="hidden" id="centerId" value="${center.id}">

                            <%-- 1. Personal Details --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-person-circle"></i></span>
                                    1. Personal Details
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="fullName">Full Name *</label>
                                        <input type="text" id="fullName" class="form-control" placeholder="Enter full name" required oninput="updateSummary()">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label" for="dob">Date of Birth *</label>
                                        <input type="date" id="dob" class="form-control" required onchange="calculateAge(); updateSummary()" max="<%= java.time.LocalDate.now() %>">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label" for="age">Age</label>
                                        <input type="text" id="age" class="form-control bg-light" readonly placeholder="Auto">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label" for="gender">Gender *</label>
                                        <select id="gender" class="form-select" required>
                                            <option value="">Select</option>
                                            <option value="Female">Female</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label" for="phone">Phone Number *</label>
                                        <input type="tel" id="phone" class="form-control" value="${user.phoneNumber}" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label" for="email">Email Address *</label>
                                        <input type="email" id="email" class="form-control" value="${user.email}" required>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label" for="address">Residential Address *</label>
                                        <textarea id="address" class="form-control" rows="2" placeholder="Enter complete address" required></textarea>
                                    </div>
                                </div>
                            </div>

                            <%-- 2. Emergency Contact --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-telephone-plus"></i></span>
                                    2. Emergency Contact Details
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="eName">Contact Name *</label>
                                        <input type="text" id="eName" class="form-control" placeholder="Full name of emergency contact" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="ePhone">Contact Number *</label>
                                        <input type="tel" id="ePhone" class="form-control" pattern="[0-9]{10}" maxlength="10" minlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                                    </div>
                                </div>
                            </div>

                            <%-- 3. Training Preference --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-star"></i></span>
                                    3. Training Preference
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="batchId">Preferred Batch *</label>
                                        <c:choose>
                                            <c:when test="${empty batches}">
                                                <div class="alert alert-warning py-2 px-3 rounded-3 small mb-0">
                                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                                    No batches added yet. Please check back later or contact the centre.
                                                </div>
                                                <input type="hidden" id="batchId" value="">
                                            </c:when>
                                            <c:otherwise>
                                                <select id="batchId" name="batchId" class="form-select" required onchange="updateBatchInfo(); updateSummary()">
                                                    <option value="">Select a batch</option>
                                                    <c:forEach var="batch" items="${batches}">
                                                        <option value="${batch.id}"
                                                                data-style="${batch.style}"
                                                                data-level="${batch.skillLevel}"
                                                                data-days="${batch.availableDays}"
                                                                data-slot="${batch.timeSlot}"
                                                                data-fee="${batch.fee}"
                                                                data-instructor="${batch.instructor}"
                                                                data-agegroup="${batch.ageGroup}"
                                                                ${batch.id == preselectedBatchId ? 'selected' : ''}>
                                                            ${batch.name} (${batch.style})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="skillLevel">Skill Level</label>
                                        <div id="skillLevelDisplay" class="skill-level-pill">Select a batch above</div>
                                        <input type="hidden" id="skillLevel" value="">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Preferred Days</label>
                                        <div class="days-group" id="daysGroup">
                                            <input class="day-chip day-check" type="checkbox" value="MONDAY"    id="mon" onchange="updateSummary()"><label class="day-chip-label" for="mon">Mon</label>
                                            <input class="day-chip day-check" type="checkbox" value="TUESDAY"   id="tue" onchange="updateSummary()"><label class="day-chip-label" for="tue">Tue</label>
                                            <input class="day-chip day-check" type="checkbox" value="WEDNESDAY" id="wed" onchange="updateSummary()"><label class="day-chip-label" for="wed">Wed</label>
                                            <input class="day-chip day-check" type="checkbox" value="THURSDAY"  id="thu" onchange="updateSummary()"><label class="day-chip-label" for="thu">Thu</label>
                                            <input class="day-chip day-check" type="checkbox" value="FRIDAY"    id="fri" onchange="updateSummary()"><label class="day-chip-label" for="fri">Fri</label>
                                            <input class="day-chip day-check" type="checkbox" value="SATURDAY"  id="sat" onchange="updateSummary()"><label class="day-chip-label" for="sat">Sat</label>
                                            <input class="day-chip day-check" type="checkbox" value="SUNDAY"    id="sun" onchange="updateSummary()"><label class="day-chip-label" for="sun">Sun</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="goal">Training Goal *</label>
                                        <select id="goal" class="form-select" required onchange="updateSummary()">
                                            <option value="">Select primary goal</option>
                                            <option value="Self-defense">Self-defense</option>
                                            <option value="Fitness">Fitness</option>
                                            <option value="Competition">Competition</option>
                                            <option value="Discipline">Discipline</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="trainerPref">Trainer Preference</label>
                                        <select id="trainerPref" class="form-select">
                                            <option value="">Any available trainer</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <%-- 4. Health Information --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-heart-pulse"></i></span>
                                    4. Health Information
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="medical">Medical Conditions / Injuries</label>
                                        <textarea id="medical" class="form-control" rows="3" placeholder="Specify if any" maxlength="300"></textarea>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="allergies">Allergies</label>
                                        <textarea id="allergies" class="form-control" rows="3" placeholder="Specify if any" maxlength="300"></textarea>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label" for="fitnessNotes">Fitness Notes / Restrictions</label>
                                        <textarea id="fitnessNotes" class="form-control" rows="2" placeholder="Any notes for the trainer" maxlength="500"></textarea>
                                    </div>
                                </div>
                            </div>

                            <%-- 5. Motivation --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-chat-quote"></i></span>
                                    5. Additional Information
                                </div>
                                <div class="motivation-box">
                                    <label class="form-label d-block mb-2" for="motivation">Why do you want to learn martial arts? *</label>
                                    <textarea id="motivation" class="form-control" rows="4" placeholder="Share your motivation and goals…" required></textarea>
                                </div>
                            </div>

                            <%-- 6. Enrollment Details --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-calendar-check"></i></span>
                                    6. Enrollment Details
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="startDate">Proposed Start Date *</label>
                                        <input type="date" id="startDate" class="form-control" required onchange="validateStartDay(); updateSummary()">
                                    </div>
                                </div>
                            </div>

                            <%-- 7. Consent --%>
                            <div class="card-panel">
                                <div class="card-panel-title">
                                    <span class="panel-icon"><i class="bi bi-check2-all"></i></span>
                                    7. Consent
                                </div>
                                <div class="consent-item">
                                    <input class="form-check-input" type="checkbox" id="consentAcc" required>
                                    <label for="consentAcc">I confirm that the information provided is accurate to the best of my knowledge.</label>
                                </div>
                                <div class="consent-item">
                                    <input class="form-check-input" type="checkbox" id="consentRules" required>
                                    <label for="consentRules">I agree to follow the academy rules, safety guidelines, and training policies.</label>
                                </div>
                            </div>

                            <%-- Submit action --%>
                            <div class="mb-5 d-flex flex-wrap gap-2">
                                <button type="button" id="reviewBtn" class="btn-rose" onclick="openEnrollmentPreview()">
                                    <i class="bi bi-eye-fill"></i> Review Application
                                </button>
                                <button type="submit" id="submitBtn" class="btn-rose" style="display:none;">
                                    Confirm &amp; Submit
                                </button>
                            </div>

                        </form>
                    </div><!-- /col-lg-8 -->

                    <%-- Right: Sticky summary --%>
                    <div class="col-lg-4">
                        <div class="summary-sticky">
                            <div class="summary-panel">
                                <div class="summary-panel-title">
                                    <i class="bi bi-clipboard-data me-2" style="color:var(--rose);"></i>Enrollment Summary
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-fist-raised"></i></div>
                                    <div><span class="summary-label">Martial Art Style</span><span class="summary-value" id="sStyle">Not selected</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-chart-line"></i></div>
                                    <div><span class="summary-label">Skill Level</span><span class="summary-value" id="sLevel">—</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-layer-group"></i></div>
                                    <div><span class="summary-label">Preferred Batch</span><span class="summary-value" id="sBatch">—</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-calendar-alt"></i></div>
                                    <div><span class="summary-label">Preferred Days</span><span class="summary-value" id="sDays">—</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-clock"></i></div>
                                    <div><span class="summary-label">Time Slot</span><span class="summary-value" id="sSlot">—</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-bullseye"></i></div>
                                    <div><span class="summary-label">Training Goal</span><span class="summary-value" id="sGoal">—</span></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-icon"><i class="fas fa-play"></i></div>
                                    <div><span class="summary-label">Proposed Start Date</span><span class="summary-value" id="sStart">—</span></div>
                                </div>
                                <div class="fee-badge">
                                    <span class="fee-label">Monthly Enrollment Fee</span>
                                    <span class="fee-value">₹ <span id="sFee">0.00</span></span>
                                </div>
                                <div class="privacy-note">
                                    <i class="bi bi-shield-lock me-2"></i>Your information is safe and used only for training and communication.
                                </div>
                            </div>
                        </div>
                    </div><!-- /col-lg-4 -->

                </div><!-- /row -->

            </div><!-- /enroll-wrap -->
        </div><!-- /page-content-wrapper -->
    </div><!-- /wrapper -->

    <!-- Preview Modal -->
    <div class="modal fade" id="previewModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content p-4" style="border-radius:16px;">
                <h3 class="fw-bold mb-1" style="color:#0F172A;">Confirm Your Application</h3>
                <p class="text-muted small mb-3">Review everything before sending it to the centre.</p>
                <div id="previewBody" class="text-start mb-4" style="background:#F8FAFC;border:1px solid #E2E8F0;border-radius:12px;padding:16px;"></div>
                <div class="d-flex flex-wrap gap-2">
                    <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">← Edit Application</button>
                    <button type="button" id="confirmSubmitBtn" class="btn rounded-pill px-4 fw-bold text-white" style="background:#F43F5E;" onclick="confirmEnrollmentSubmit()">Confirm &amp; Submit</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" data-bs-backdrop="static" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center p-4">
                <div class="mb-3">
                    <i class="bi bi-check-circle-fill" style="font-size: 4rem; color:#F43F5E;"></i>
                </div>
                <h3 class="fw-bold" id="successModalTitle">Application Submitted</h3>
                <p class="text-muted" id="successModalBody">Your application has been sent for centre review.</p>
                <button id="proceedPaymentBtn" class="btn w-100 py-3 rounded-pill fw-bold text-white" style="background:#F43F5E;display:none;">Complete Payment</button>
                <a id="goToDashboardBtn" href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="btn w-100 py-3 rounded-pill fw-bold text-white mt-2" style="background:#F43F5E;">View My Martial Arts</a>
                <a href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-outline-secondary w-100 py-3 rounded-pill fw-bold mt-2">Back to Dashboard</a>
            </div>
        </div>
    </div>

    <%-- Scripts --%>
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <script>
        // On load: preselect batch + set start date minimum
        document.addEventListener('DOMContentLoaded', function () {
            const startDateInput = document.getElementById('startDate');
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            startDateInput.min = tomorrow.toISOString().split('T')[0];

            const preId = '${preselectedBatchId}';
            const batchSelect = document.getElementById('batchId');
            if (batchSelect && preId && preId !== '' && preId !== 'null') {
                batchSelect.value = preId;
                updateBatchInfo();
                updateSummary();
            } else if (batchSelect && batchSelect.value) {
                updateBatchInfo();
                updateSummary();
            }
        });

        function calculateAge() {
            const dobInput = document.getElementById('dob');
            const dob = dobInput.value;
            if (!dob) return;
            const birthDate = new Date(dob);
            const today = new Date();
            today.setHours(0,0,0,0);
            
            if (birthDate > today) {
                alert("Date of Birth cannot be in the future!");
                dobInput.value = "";
                document.getElementById('age').value = "";
                return;
            }

            let age = today.getFullYear() - birthDate.getFullYear();
            const m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            document.getElementById('age').value = age;
        }

        function updateBatchInfo() {
            const select = document.getElementById('batchId');
            if (!select) return;
            const option = select.options[select.selectedIndex];
            const display = document.getElementById('skillLevelDisplay');
            if (select.value && option) {
                // Skill level
                const lvl = option.dataset.level || '';
                document.getElementById('skillLevel').value = lvl;
                if (display) {
                    if (lvl) {
                        display.textContent = lvl;
                        display.className = 'skill-level-pill';
                    } else {
                        display.textContent = 'Not specified';
                        display.className = 'skill-level-pill empty';
                    }
                }

                // Issue 139: Lock schedule days to match selected batch, not user-overridable
                const days = option.dataset.days ? option.dataset.days.toUpperCase() : '';
                document.querySelectorAll('.day-check').forEach(chk => {
                    const dayMatch = days.split(',').some(d => days.includes(chk.value.substring(0,3)));
                    // Match MON -> MONDAY, TUE -> TUESDAY, etc.
                    const abbr = {
                        'MONDAY': 'MON', 'TUESDAY': 'TUE', 'WEDNESDAY': 'WED',
                        'THURSDAY': 'THU', 'FRIDAY': 'FRI', 'SATURDAY': 'SAT', 'SUNDAY': 'SUN'
                    };
                    const abbrVal = abbr[chk.value] || chk.value.substring(0,3);
                    const isInBatch = days.includes(abbrVal);
                    chk.checked = isInBatch;
                    chk.disabled = true; // Issue 139: Disable to prevent override
                });

                // Issue 136: Populate trainer dropdown with the batch instructor
                const trainerSelect = document.getElementById('trainerPref');
                trainerSelect.innerHTML = '<option value="">Any available trainer</option>';
                const instructor = option.dataset.instructor || '';
                if (instructor) {
                    const opt = document.createElement('option');
                    opt.value = instructor;
                    opt.text = instructor;
                    opt.selected = true;
                    trainerSelect.appendChild(opt);
                }
            } else {
                // No batch selected — reset
                document.getElementById('skillLevel').value = '';
                if (display) {
                    display.textContent = 'Select a batch above';
                    display.className = 'skill-level-pill empty';
                }
                document.querySelectorAll('.day-check').forEach(function (chk) {
                    chk.disabled = false;
                    chk.checked = false;
                });
            }
            updateSummary();
        }

        function updateSummary() {
            const batchSelect = document.getElementById('batchId');
            const batchOpt = batchSelect.options[batchSelect.selectedIndex];

            if (batchSelect.value && batchOpt) {
                const style = batchOpt.dataset.style || '--';
                const level = batchOpt.dataset.level || '--';
                const batchName = batchOpt.text || '--';
                const slot = batchOpt.dataset.slot || '--';
                const feeVal = parseFloat(batchOpt.dataset.fee || '0');
                const feeFormatted = feeVal > 0 ? ('₹ ' + feeVal.toLocaleString()) : 'FREE';

                document.getElementById('sStyle').innerText = style;
                document.getElementById('sLevel').innerText = level;
                document.getElementById('sBatch').innerText = batchName;
                document.getElementById('sSlot').innerText = slot;
                document.getElementById('sFee').innerText = feeVal.toLocaleString();

                // Top persistent card sync
                const topStyle = document.getElementById('topSelectedStyle');
                const topBatch = document.getElementById('topSelectedBatch');
                const topFee = document.getElementById('topSelectedFee');
                if (topStyle) topStyle.innerText = style;
                if (topBatch) topBatch.innerText = batchName;
                if (topFee) topFee.innerText = feeFormatted;
            } else {
                document.getElementById('sStyle').innerText = 'Not selected';
                document.getElementById('sLevel').innerText = '--';
                document.getElementById('sBatch').innerText = '--';
                document.getElementById('sSlot').innerText = '--';
                document.getElementById('sFee').innerText = '0.00';

                const topStyle = document.getElementById('topSelectedStyle');
                const topBatch = document.getElementById('topSelectedBatch');
                const topFee = document.getElementById('topSelectedFee');
                if (topStyle) topStyle.innerText = '--';
                if (topBatch) topBatch.innerText = 'Please select a batch';
                if (topFee) topFee.innerText = '--';
            }

            document.getElementById('sGoal').innerText = document.getElementById('goal').value || '--';
            document.getElementById('sStart').innerText = document.getElementById('startDate').value || '--';

            // Days — use nextElementSibling (the <label>) since chips have no wrapper div
            const checkedDays = Array.from(document.querySelectorAll('.day-check:checked')).map(c => c.nextElementSibling ? c.nextElementSibling.innerText.trim() : c.value);
            document.getElementById('sDays').innerText = checkedDays.join(', ') || '--';
        }

        // Preview → Confirm → Submit
        function openEnrollmentPreview() {
            const form = document.getElementById('complexEnrollmentForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            const batchSel = document.getElementById('batchId');
            const batchOpt = batchSel.options[batchSel.selectedIndex];
            const days = Array.from(document.querySelectorAll('.day-check:checked')).map(c => c.nextElementSibling ? c.nextElementSibling.innerText.trim() : c.value).join(', ') || '—';
            const feeVal = parseFloat(batchOpt?.dataset.fee || '0');
            document.getElementById('previewBody').innerHTML =
                '<div class="mb-3"><div class="text-uppercase small fw-bold text-muted">Student</div>' +
                '<div class="fw-semibold">' + (document.getElementById('fullName').value || '—') + '</div>' +
                '<div class="small text-muted">' + (document.getElementById('email').value || '') + ' · ' + (document.getElementById('phone').value || '') + '</div></div>' +
                '<div class="mb-3"><div class="text-uppercase small fw-bold text-muted">Training</div>' +
                '<div class="fw-semibold">' + (batchOpt?.dataset.style || '—') + ' — ' + (batchOpt?.text || '') + '</div>' +
                '<div class="small text-muted"><c:out value="${center.name}"/></div>' +
                '<div class="small text-muted">Coach: ' + (batchOpt?.dataset.instructor || '—') + '</div></div>' +
                '<div class="mb-3"><div class="text-uppercase small fw-bold text-muted">Schedule</div>' +
                '<div>' + days + '</div><div class="small text-muted">' + (batchOpt?.dataset.slot || '—') + '</div></div>' +
                '<div class="mb-3"><div class="text-uppercase small fw-bold text-muted">Fee</div>' +
                '<div class="fw-bold" style="color:#F43F5E;">' + (feeVal > 0 ? ('₹' + feeVal.toLocaleString() + ' / month') : 'FREE') + '</div></div>' +
                '<div><div class="text-uppercase small fw-bold text-muted">Emergency Contact</div>' +
                '<div>' + (document.getElementById('eName').value || '—') +
                (document.getElementById('ePhone') ? (' · ' + document.getElementById('ePhone').value) : '') + '</div></div>';
            new bootstrap.Modal(document.getElementById('previewModal')).show();
        }

        function confirmEnrollmentSubmit() {
            const previewModal = bootstrap.Modal.getInstance(document.getElementById('previewModal'));
            if (previewModal) previewModal.hide();
            document.getElementById('complexEnrollmentForm').requestSubmit();
        }

        // Form Submit
        document.getElementById('complexEnrollmentForm').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('confirmSubmitBtn');

            // Issue 138: Validate age group against selected batch
            const batchSel = document.getElementById('batchId');
            const batchOpt = batchSel.options[batchSel.selectedIndex];
            const ageGroup = batchOpt ? (batchOpt.dataset.agegroup || '') : '';
            const userAge = parseInt(document.getElementById('age').value) || 0;
            if (ageGroup && userAge > 0) {
                let ageOk = true;
                if (ageGroup.toLowerCase().includes('kids') && (userAge < 5 || userAge > 12)) ageOk = false;
                else if (ageGroup.toLowerCase().includes('teens') && (userAge < 13 || userAge > 17)) ageOk = false;
                else if (ageGroup.toLowerCase().includes('adults') && userAge < 18) ageOk = false;
                if (!ageOk) {
                    alert('Your age (' + userAge + ') does not match the required age group for this batch: ' + ageGroup);
                    return;
                }
            }

            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Submitting...';

            const payload = {
                centerId: document.getElementById('centerId').value,
                batchId: document.getElementById('batchId').value,
                fullName: document.getElementById('fullName').value,
                dob: document.getElementById('dob').value,
                age: parseInt(document.getElementById('age').value),
                gender: document.getElementById('gender').value,
                phoneNumber: document.getElementById('phone').value,
                email: document.getElementById('email').value,
                address: document.getElementById('address').value,
                emergencyName: document.getElementById('eName').value,
                emergencyPhone: document.getElementById('ePhone') ? document.getElementById('ePhone').value : null,
                skillLevel: document.getElementById('skillLevel').value,
                preferredDays: Array.from(document.querySelectorAll('.day-check:checked')).map(c => c.value),
                goal: document.getElementById('goal').value,
                motivation: document.getElementById('motivation').value,
                medicalConditions: document.getElementById('medical').value,
                allergies: document.getElementById('allergies').value,
                fitnessNotes: document.getElementById('fitnessNotes').value,
                startDate: document.getElementById('startDate').value,
                trainerPreference: document.getElementById('trainerPref').value,
                monthlyFee: parseFloat(document.getElementById('sFee').innerText.replace(/,/g, '')),
                consentAccuracy: document.getElementById('consentAcc').checked,
                consentRules: document.getElementById('consentRules').checked
            };

            try {
                const res = await fetch('${pageContext.request.contextPath}/enrollment/api/enrollments', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (res.status === 409) {
                    // Batch is full
                    alert('⚠️ This batch is full! No more seats are available. Please choose another batch.');
                    btn.disabled = false;
                    btn.innerHTML = 'Confirm &amp; Submit';
                    return;
                }

                if (res.ok) {
                    const data = await res.json();
                    document.getElementById('successModalTitle').innerText = 'Application Submitted';
                    document.getElementById('successModalBody').innerText =
                        'Your application has been sent to the centre for review. We will notify you when they approve or request changes. Payment is only available after centre approval.';
                    document.getElementById('proceedPaymentBtn').style.display = 'none';
                    document.getElementById('goToDashboardBtn').style.display = 'block';
                    const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                    successModal.show();
                } else {
                    const err = await res.text();
                    alert("Error: " + err);
                }
            } catch (err) {
                alert("Network error: " + err.message);
            } finally {
                btn.disabled = false;
                btn.innerHTML = 'Confirm &amp; Submit';
            }
        };

        // (Handled by the DOMContentLoaded listener at the top of this script)

        function validateStartDay() {
            const dateInput = document.getElementById('startDate');
            if (!dateInput.value) return;
            const date = new Date(dateInput.value);
            const daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
            const daySelected = daysOfWeek[date.getDay()];
            
            const batchSelect = document.getElementById('batchId');
            if (batchSelect && batchSelect.value) {
                const option = batchSelect.options[batchSelect.selectedIndex];
                const availableDaysStr = option.dataset.days ? option.dataset.days.toUpperCase() : '';
                if (availableDaysStr && !availableDaysStr.includes(daySelected)) {
                    alert("Please select a date that falls on the trainer's scheduled days: " + availableDaysStr);
                    dateInput.value = "";
                }
            }
        }

        async function initiateRazorpay(enrollmentId, amount) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/payment/create-order', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ amount, type: 'MARTIAL_ARTS' })
                });

                if (!response.ok) throw new Error('Order creation failed');
                const order = await response.json();

                const options = {
                    key: order.key,
                    amount: order.amount,
                    currency: 'INR',
                    name: 'Fight D Fear Martial Arts',
                    description: 'Batch Enrollment Fee',
                    order_id: order.orderId,
                    handler: async function (response) {
                        const verifyRes = await fetch('${pageContext.request.contextPath}/payment/verify', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_signature: response.razorpay_signature,
                                type: 'MARTIAL_ARTS',
                                enrollmentId: enrollmentId,
                                centerId: document.getElementById('centerId').value,
                                batchId: document.getElementById('batchId').value,
                                amount: amount
                            })
                        });

                        if (verifyRes.ok) {
                            alert('Success! You are now enrolled.');
                            window.location.href = '${pageContext.request.contextPath}/enrollment/enrollmentSuccess';
                        } else {
                            const errData = await verifyRes.json().catch(() => ({}));
                            alert('Payment verification failed: ' + (errData.error || 'Unknown error. Please contact support.'));
                        }
                    },
                    prefill: {
                        name: document.getElementById('fullName').value,
                        email: document.getElementById('email').value,
                        contact: document.getElementById('phone').value
                    },
                    theme: { color: '#f43f5e' }
                };

                const rzp = new Razorpay(options);
                rzp.open();
            } catch (error) {
                alert('Razorpay error: ' + error.message);
            }
        }
    </script>
</body>
</html>

