<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Job Profile | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-jobs-portal.css">
    <style>
        /* Profile-page only — does not load on dashboard/earnings */
        body.wj-profile-page {
            background: #F8FAFC;
            display: block;
        }
        body.wj-profile-page .wj-main { margin-left: 0; }
        body.wj-profile-page .wj-topbar {
            background: #FFFFFF;
            border-bottom: 1px solid #E2E8F0;
            padding: 20px 32px;
            box-shadow: 0 1px 0 rgba(30, 27, 75, 0.04);
        }
        body.wj-profile-page .wj-topbar h1 {
            font-size: 1.45rem;
            font-weight: 800;
            color: #1E1B4B;
            letter-spacing: -0.4px;
        }
        body.wj-profile-page .wj-topbar p {
            font-size: 0.9rem;
            color: #64748B;
            margin-top: 4px;
        }
        body.wj-profile-page .btn-skip {
            padding: 10px 18px;
            border: 1px solid #E2E8F0;
            background: #FFFFFF;
            color: #1E1B4B;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 42px;
            white-space: nowrap;
        }
        body.wj-profile-page .btn-skip:hover { background: #F8FAFC; color: #F43F5E; border-color: #F43F5E; }
        body.wj-profile-page .wj-content {
            max-width: 920px;
            margin: 0 auto;
            padding: 28px 24px 56px;
            width: 100%;
        }
        body.wj-profile-page .wj-card {
            border-radius: 20px;
            border: 1px solid #E2E8F0;
            box-shadow: 0 10px 32px rgba(30, 27, 75, 0.06);
        }
        body.wj-profile-page .wj-card-b.padded { padding: 28px 32px 32px; }
        body.wj-profile-page .wj-progress { display: flex; gap: 6px; margin-bottom: 18px; flex-wrap: wrap; }
        body.wj-profile-page .wj-progress span {
            flex: 1 1 calc(8.33% - 6px); min-width: 18px; height: 8px; border-radius: 99px; background: #E2E8F0;
        }
        body.wj-profile-page .wj-progress span.on { background: #F43F5E; }
        body.wj-profile-page .wj-step-title {
            font-size: 0.78rem;
            font-weight: 700;
            color: #1E1B4B;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        body.wj-profile-page .wj-step-desc {
            font-size: 0.88rem;
            color: #64748B;
            margin: 0 0 18px;
            font-weight: 500;
            text-transform: none;
            letter-spacing: 0;
        }
        body.wj-profile-page .wj-readonly {
            background: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 0.9rem;
            color: #1E1B4B;
            margin-bottom: 12px;
        }
        body.wj-profile-page .wj-readonly span { display: block; font-size: 0.72rem; font-weight: 700; color: #64748B; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px; }
        body.wj-profile-page .wj-field-err {
            display: none;
            color: #DC2626;
            font-size: 0.78rem;
            font-weight: 600;
            margin-top: 6px;
        }
        body.wj-profile-page .wj-field-err.on { display: block; }
        body.wj-profile-page .wj-hint {
            font-size: 0.82rem;
            color: #64748B;
            background: #FFF1F2;
            border: 1px solid #FFE4E6;
            border-radius: 10px;
            padding: 10px 12px;
            margin-bottom: 16px;
        }
        body.wj-profile-page .wj-mobile-tag {
            display: inline-block;
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #9F1239;
            background: #FFE4E6;
            border-radius: 6px;
            padding: 2px 8px;
            margin-left: 6px;
            vertical-align: middle;
        }
        body.wj-profile-page .wj-row { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 20px; }
        body.wj-profile-page .wj-row .full { grid-column: 1 / -1; }
        body.wj-profile-page .wj-field { margin-bottom: 0; }
        body.wj-profile-page .wj-label { margin-bottom: 8px; font-weight: 600; }
        body.wj-profile-page .wj-input,
        body.wj-profile-page .wj-textarea {
            border-radius: 12px;
            border: 1px solid #E2E8F0;
            padding: 13px 14px;
        }
        body.wj-profile-page .wj-textarea { min-height: 108px; resize: vertical; }
        body.wj-profile-page .wj-nav-btns {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 28px;
            flex-wrap: wrap;
        }
        body.wj-profile-page .wj-btn,
        body.wj-profile-page .btn-save {
            height: 44px;
            min-width: 120px;
            padding: 0 22px;
            border-radius: 12px;
            font-weight: 700;
        }
        body.wj-profile-page #btnProfileNext {
            background: #F43F5E;
            color: #fff;
            border: none;
        }
        body.wj-profile-page #btnProfileNext:hover { background: #E11D48; color: #fff; }
        body.wj-profile-page #btnProfileBack {
            background: #FFFFFF;
            color: #1E1B4B;
            border: 1px solid #E2E8F0;
        }
        body.wj-profile-page .btn-save {
            background-color: #F43F5E;
            color: white;
            border: none;
            font-family: inherit;
        }
        body.wj-profile-page .btn-save:hover { background-color: #E11D48; color: white; }
        @media (max-width: 640px) {
            body.wj-profile-page .wj-row { grid-template-columns: 1fr; }
            body.wj-profile-page .wj-topbar { padding: 16px; flex-wrap: wrap; }
            body.wj-profile-page .wj-card-b.padded { padding: 20px 16px 24px; }
            body.wj-profile-page .wj-nav-btns { flex-direction: column; align-items: stretch; }
            body.wj-profile-page .wj-nav-btns > div { margin-left: 0 !important; width: 100%; }
            body.wj-profile-page .wj-nav-btns .wj-btn,
            body.wj-profile-page .wj-nav-btns .btn-save,
            body.wj-profile-page .wj-nav-btns .btn-skip { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body class="wj-page wj-profile-page">
<main class="wj-main">
  <header class="wj-topbar">
    <div>
        <h1>Complete your profile</h1>
        <p>Add professional details so clients can book you with confidence</p>
    </div>
    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="btn-skip">Skip for now</a>
  </header>

  <div class="wj-content">
    <c:if test="${not empty success}">
        <div class="wj-alert wj-alert-ok"><i class="fas fa-check-circle"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="wj-alert wj-alert-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>
    <div id="js-profile-error" class="wj-alert wj-alert-err" style="display:none;">
        <i class="fas fa-exclamation-circle"></i> <span id="js-profile-error-msg"></span>
    </div>

    <div class="wj-card">
        <div class="wj-card-b padded">
            <div class="wj-progress" id="profileProgress">
                <span class="on"></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span>
            </div>
            <p class="wj-step-title" id="stepLabel">Step 1 of 11 — Worker identity</p>
            <p class="wj-step-desc" id="stepDesc">Your name, role, phone and experience.</p>

            <form action="${pageContext.request.contextPath}/women-jobs/profile" method="post" id="workerProfileForm" enctype="multipart/form-data">

                <div class="wj-step" data-step="1">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">1.1 Full name</label>
                            <input type="text" name="fullName" class="wj-input" maxlength="120" value="${workerApp.user.fullName}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Email <span class="wj-mobile-tag">Login identity — not changed here</span></label>
                            <div class="wj-readonly"><c:out value="${workerApp.user.email}"/></div>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">1.2 Role type / designation</label>
                            <input type="text" name="designation" class="wj-input" maxlength="120" placeholder="e.g. Senior Baby Care Specialist" value="${workerApp.designation}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">1.5 Official phone</label>
                            <input type="text" name="phone" class="wj-input" maxlength="10" inputmode="numeric" value="${workerApp.user.phoneNumber}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">1.6 WhatsApp</label>
                            <input type="text" name="whatsappNumber" id="whatsappNumber" class="wj-input" maxlength="10" inputmode="numeric" placeholder="e.g. 9876543210" value="${workerApp.whatsappNumber}">
                            <small class="wj-field-err" id="err-whatsappNumber"></small>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">1.7 Years of experience</label>
                            <input type="number" name="yearsExperience" id="yearsExperience" class="wj-input" min="0" max="50" placeholder="e.g. 5" value="${workerApp.yearsExperience}">
                            <small class="wj-field-err" id="err-yearsExperience"></small>
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="2" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">2.1 Landmark / address</label>
                            <input type="text" name="address" class="wj-input" maxlength="255" placeholder="Flat, Street, Area info" value="${workerApp.address}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">2.3 City</label>
                            <input type="text" name="city" class="wj-input" maxlength="80" placeholder="City" value="${workerApp.city}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">2.4 State</label>
                            <input type="text" name="state" class="wj-input" maxlength="80" placeholder="State" value="${workerApp.state}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">2.5 Pincode</label>
                            <input type="text" name="pincode" id="pincode" class="wj-input" maxlength="6" inputmode="numeric" placeholder="6-digit Pincode" value="${workerApp.pincode}">
                            <small class="wj-field-err" id="err-pincode"></small>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">2.6 Latitude</label>
                            <input type="text" name="latitude" class="wj-input" placeholder="e.g. 12.9716" value="${workerApp.latitude}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">2.7 Longitude</label>
                            <input type="text" name="longitude" class="wj-input" placeholder="e.g. 77.5946" value="${workerApp.longitude}">
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="3" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">3.1 Categories offered</label>
                            <input type="text" name="categoriesOffered" class="wj-input" maxlength="255" placeholder="e.g. Teaching, Tutoring" value="${workerApp.categoriesOffered}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Primary category</label>
                            <select id="jobCategory" name="jobCategory" class="wj-input" onchange="updateSubCategories()">
                                <option value="">Select Category</option>
                                <option value="Caregiver" ${workerApp.jobCategory == 'Caregiver' ? 'selected' : ''}>Caregiver</option>
                                <option value="Babysitting" ${workerApp.jobCategory == 'Babysitting' ? 'selected' : ''}>Babysitting</option>
                                <option value="Housekeeping" ${workerApp.jobCategory == 'Housekeeping' ? 'selected' : ''}>Housekeeping</option>
                                <option value="Cooking" ${workerApp.jobCategory == 'Cooking' ? 'selected' : ''}>Cooking</option>
                                <option value="Beauty & Salon" ${workerApp.jobCategory == 'Beauty & Salon' ? 'selected' : ''}>Beauty &amp; Salon</option>
                                <option value="Healthcare" ${workerApp.jobCategory == 'Healthcare' ? 'selected' : ''}>Healthcare</option>
                                <option value="Teaching" ${workerApp.jobCategory == 'Teaching' ? 'selected' : ''}>Teaching</option>
                                <option value="Office Jobs" ${workerApp.jobCategory == 'Office Jobs' ? 'selected' : ''}>Office Jobs</option>
                                <option value="Retail" ${workerApp.jobCategory == 'Retail' ? 'selected' : ''}>Retail</option>
                                <option value="Hospitality" ${workerApp.jobCategory == 'Hospitality' ? 'selected' : ''}>Hospitality</option>
                                <option value="Customer Support" ${workerApp.jobCategory == 'Customer Support' ? 'selected' : ''}>Customer Support</option>
                                <option value="Delivery & Logistics" ${workerApp.jobCategory == 'Delivery & Logistics' ? 'selected' : ''}>Delivery &amp; Logistics</option>
                                <option value="Domestic Help" ${workerApp.jobCategory == 'Domestic Help' ? 'selected' : ''}>Domestic Help</option>
                                <option value="Tailoring & Fashion" ${workerApp.jobCategory == 'Tailoring & Fashion' ? 'selected' : ''}>Tailoring &amp; Fashion</option>
                                <option value="Digital Jobs" ${workerApp.jobCategory == 'Digital Jobs' ? 'selected' : ''}>Digital Jobs</option>
                                <option value="Freelancing" ${workerApp.jobCategory == 'Freelancing' ? 'selected' : ''}>Freelancing</option>
                                <option value="Entrepreneurship" ${workerApp.jobCategory == 'Entrepreneurship' ? 'selected' : ''}>Entrepreneurship</option>
                            </select>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">Role / sub category</label>
                            <select id="jobSubCategory" name="jobSubCategory" class="wj-input">
                                <option value="${workerApp.jobSubCategory}"><c:out value="${empty workerApp.jobSubCategory ? 'Select specific job' : workerApp.jobSubCategory}"/></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="4" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">4.1 Audience</label>
                            <input type="text" name="audience" class="wj-input" maxlength="255" placeholder="e.g. Families, Seniors" value="${workerApp.audience}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">4.2 Door visits</label>
                            <select name="doorService" class="wj-input">
                                <option value="true" ${workerApp.doorService == true ? 'selected' : ''}>Yes</option>
                                <option value="false" ${workerApp.doorService != true ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">4.3 Languages</label>
                            <input type="text" name="languages" class="wj-input" maxlength="200" placeholder="e.g. English, Hindi, Punjabi" value="${workerApp.languages}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">4.4 Skills</label>
                            <input type="text" name="skills" class="wj-input" maxlength="255" placeholder="e.g. CPR, Newborn Care, Cooking, Tutoring" value="${workerApp.skills}">
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="5" style="display:none;">
                    <div class="wj-field">
                        <label class="wj-label">5.1 Amenities / readiness</label>
                        <input type="text" name="facilities" class="wj-input" maxlength="500" placeholder="e.g. First-aid kit, Own transport" value="${workerApp.facilities}">
                    </div>
                </div>

                <div class="wj-step" data-step="6" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">6.1 Open days</label>
                            <input type="text" name="openDays" class="wj-input" placeholder="Mon,Tue,Wed,Thu,Fri" value="${workerApp.openDays}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">6.2 Open time</label>
                            <input type="time" name="openTime" class="wj-input" value="${workerApp.openTime}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">6.3 Close time</label>
                            <input type="time" name="closeTime" class="wj-input" value="${workerApp.closeTime}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">6.4 Break start</label>
                            <input type="time" name="breakStart" class="wj-input" value="${workerApp.breakStart}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">6.5 Break end</label>
                            <input type="time" name="breakEnd" class="wj-input" value="${workerApp.breakEnd}">
                        </div>
                        <div class="wj-field full">
                            <label class="wj-label">6.6 Blocked dates</label>
                            <input type="text" name="blockedDates" class="wj-input" placeholder="YYYY-MM-DD, YYYY-MM-DD" value="${workerApp.blockedDates}">
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="7" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field full">
                            <label class="wj-label">7.1 About</label>
                            <textarea name="bio" class="wj-textarea" rows="4" maxlength="2000" placeholder="Tell clients about your work style, background, or child-care philosophy...">${workerApp.bio}</textarea>
                        </div>
                    </div>
                </div>

                <div class="wj-step" data-step="8" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">8.5 Hourly rate (₹)</label>
                            <input type="number" name="hourlyRate" id="hourlyRate" class="wj-input" min="1" step="0.01" value="${workerApp.hourlyRate}">
                            <small class="wj-field-err" id="err-hourlyRate"></small>
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">8.3 Duration (minutes)</label>
                            <input type="number" name="durationMinutes" class="wj-input" min="1" value="${workerApp.durationMinutes}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">8.4 Buffer (minutes)</label>
                            <input type="number" name="bufferMinutes" class="wj-input" min="0" value="${workerApp.bufferMinutes}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">8.6 Service mode</label>
                            <input type="text" name="serviceMode" class="wj-input" placeholder="e.g. DOOR / CENTRE" value="${workerApp.serviceMode}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">8.7 Work type</label>
                            <input type="text" name="workType" class="wj-input" placeholder="e.g. Full-time, Part-time" value="${workerApp.workType}">
                        </div>
                    </div>
                    <p class="wj-step-desc">Primary category and role are saved in Step 3.</p>
                </div>

                <div class="wj-step" data-step="9" style="display:none;">
                    <div class="wj-row">
                        <div class="wj-field">
                            <label class="wj-label">9.1 UPI ID</label>
                            <input type="text" name="upiId" class="wj-input" placeholder="e.g. upi-handle@bank" value="${workerApp.upiId}">
                        </div>
                        <div class="wj-field">
                            <label class="wj-label">9.2 Bank details</label>
                            <input type="text" name="bankDetails" class="wj-input" placeholder="Bank Name, A/C No, IFSC" value="${workerApp.bankDetails}">
                        </div>
                    </div>
                    <p class="wj-step-desc" style="margin-top:8px;">UPI is needed to withdraw. Earnings stay in your wallet until you request payout from Finance.</p>
                </div>

                <div class="wj-step" data-step="10" style="display:none;">
                    <div class="wj-field">
                        <label class="wj-label">10.1 Profile photo</label>
                        <input type="file" name="profileImage" class="wj-input" accept="image/*">
                        <c:if test="${not empty workerApp.profileImageUrl}">
                            <div class="wj-readonly" style="margin-top:8px;">Current: <c:out value="${workerApp.profileImageUrl}"/></div>
                        </c:if>
                    </div>
                    <div class="wj-field" style="margin-top:12px;">
                        <label class="wj-label">Proof document</label>
                        <input type="file" name="proofDocument" class="wj-input" accept="image/*,.pdf">
                        <c:if test="${not empty workerApp.documentPath}">
                            <div class="wj-readonly" style="margin-top:8px;">
                                <a href="${pageContext.request.contextPath}${workerApp.documentPath}" target="_blank">View existing proof document</a>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="wj-step" data-step="11" style="display:none;">
                    <div class="wj-field">
                        <label class="wj-label">11.1 Gallery photos</label>
                        <input type="file" name="galleryPhotos" class="wj-input" accept="image/*" multiple>
                        <c:if test="${not empty workerApp.galleryPhotos}">
                            <div class="wj-readonly" style="margin-top:8px;"><c:out value="${workerApp.galleryPhotos}"/></div>
                        </c:if>
                    </div>
                    <p class="wj-step-desc" style="margin-top:12px;">Save Profile still uses the existing email OTP, then stores all fields above.</p>
                </div>

                <div class="wj-nav-btns">
                    <a href="${pageContext.request.contextPath}/women-jobs/dashboard" class="btn-skip">Skip for now</a>
                    <button type="button" class="wj-btn wj-btn-ghost" id="btnProfileBack" style="display:none;">Back</button>
                    <div style="margin-left:auto;display:flex;gap:10px;align-items:center;">
                        <button type="button" class="wj-btn wj-btn-navy" id="btnProfileNext">Next</button>
                        <button type="submit" class="btn btn-save" id="btnProfileSave" style="display:none;"><i class="fas fa-save me-2"></i> Save Profile Details</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
  </div>
</main>

<div class="modal fade" id="otpConfirmModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="otpConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header bg-light" style="border-top-left-radius: 15px; border-top-right-radius: 15px;">
                <h5 class="modal-title fw-bold" id="otpConfirmModalLabel" style="color: #1E1B4B;"><i class="fas fa-user-shield me-2"></i> Security Verification</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <p class="text-muted small mb-4">
                    To save your profile changes, please verify your identity. A 6-digit OTP code has been sent to your registered email: <strong>${workerApp.user.email}</strong>
                </p>
                <div class="mb-3">
                    <input type="text" id="confirmOtpCode" class="form-control text-center fs-4 fw-bold letter-spacing-lg" placeholder="000000" maxlength="6" style="letter-spacing: 5px;" required>
                    <div id="otpModalError" class="text-danger small mt-2 d-none"></div>
                    <div id="otpModalSuccess" class="text-success small mt-2 d-none"></div>
                </div>
                <div class="mt-3">
                    <p class="text-muted small mb-0">
                        Didn't receive the OTP? <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold" id="resendOtpBtn" style="color: #F43F5E;">Resend OTP</button>
                    </p>
                </div>
            </div>
            <div class="modal-footer" style="border-bottom-left-radius: 15px; border-bottom-right-radius: 15px;">
                <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-save rounded-pill px-4" id="btnVerifyAndSubmit">Verify & Save</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const profileForm = document.querySelector('form[action$="/profile"]');
    let isProfileOtpVerified = false;
    let otpModalInstance = null;

    if (profileForm) {
        profileForm.addEventListener('submit', function(e) {
            var errBox = document.getElementById('js-profile-error');
            var errMsg = document.getElementById('js-profile-error-msg');
            errBox.style.display = 'none';
            var years = (profileForm.yearsExperience.value || '').trim();
            if (years !== '') {
                var y = parseInt(years, 10);
                if (isNaN(y) || y < 0 || y > 50) {
                    e.preventDefault();
                    errMsg.textContent = 'Years of Experience must be between 0 and 50.';
                    errBox.style.display = 'flex';
                    return;
                }
            }
            var rate = (profileForm.hourlyRate.value || '').trim();
            if (rate !== '') {
                var r = parseFloat(rate);
                if (isNaN(r) || r <= 0) {
                    e.preventDefault();
                    errMsg.textContent = 'Hourly rate must be greater than zero.';
                    errBox.style.display = 'flex';
                    return;
                }
            }
            var wa = (profileForm.whatsappNumber.value || '').trim();
            if (wa !== '' && !/^\d{10}$/.test(wa)) {
                e.preventDefault();
                errMsg.textContent = 'WhatsApp number must be exactly 10 digits.';
                errBox.style.display = 'flex';
                return;
            }
            var pin = (profileForm.pincode.value || '').trim();
            if (pin !== '' && !/^\d{6}$/.test(pin)) {
                e.preventDefault();
                errMsg.textContent = 'Pincode must be exactly 6 digits.';
                errBox.style.display = 'flex';
                return;
            }
            if (!isProfileOtpVerified) {
                e.preventDefault();
                sendProfileOtp();
                if (!otpModalInstance) {
                    otpModalInstance = new bootstrap.Modal(document.getElementById('otpConfirmModal'));
                }
                otpModalInstance.show();
            }
        });
    }

    function sendProfileOtp() {
        const errorDiv = document.getElementById('otpModalError');
        const successDiv = document.getElementById('otpModalSuccess');
        errorDiv.classList.add('d-none');
        successDiv.classList.add('d-none');

        const formData = new FormData();
        fetch('${pageContext.request.contextPath}/women-jobs/profile/send-otp', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                successDiv.innerText = "A new OTP code has been sent.";
                successDiv.classList.remove('d-none');
            } else {
                errorDiv.innerText = "Error sending OTP: " + data.message;
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(err => {
            errorDiv.innerText = "Network error. Please try again.";
            errorDiv.classList.remove('d-none');
        });
    }

    document.getElementById('resendOtpBtn').addEventListener('click', function(e) {
        e.preventDefault();
        sendProfileOtp();
    });

    document.getElementById('btnVerifyAndSubmit').addEventListener('click', function() {
        const otpCode = document.getElementById('confirmOtpCode').value.trim();
        const errorDiv = document.getElementById('otpModalError');
        const successDiv = document.getElementById('otpModalSuccess');

        errorDiv.classList.add('d-none');
        successDiv.classList.add('d-none');

        if (otpCode.length !== 6 || !/^\d+$/.test(otpCode)) {
            errorDiv.innerText = "Please enter a valid 6-digit OTP code.";
            errorDiv.classList.remove('d-none');
            return;
        }

        const formData = new FormData();
        formData.append('otp', otpCode);

        fetch('${pageContext.request.contextPath}/women-jobs/profile/verify-otp', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                isProfileOtpVerified = true;
                if (otpModalInstance) {
                    otpModalInstance.hide();
                }
                profileForm.submit();
            } else {
                errorDiv.innerText = data.message || "Invalid or expired OTP.";
                errorDiv.classList.remove('d-none');
            }
        })
        .catch(err => {
            errorDiv.innerText = "Verification failed. Please try again.";
            errorDiv.classList.remove('d-none');
        });
    });

    var labels = [
        'Step 1 of 11 — Worker identity',
        'Step 2 of 11 — Location',
        'Step 3 of 11 — Work categories',
        'Step 4 of 11 — Who I serve',
        'Step 5 of 11 — Facilities & readiness',
        'Step 6 of 11 — Hours & calendar',
        'Step 7 of 11 — About you',
        'Step 8 of 11 — First offering',
        'Step 9 of 11 — Payout',
        'Step 10 of 11 — Documents (optional)',
        'Step 11 of 11 — Work photos (optional)'
    ];
    var descs = [
        'Your name, role, phone and experience.',
        'Address clients will use to find you.',
        'Categories you offer, plus primary category and role.',
        'Audience, door visits, languages and skills.',
        'Amenities and readiness.',
        'Open days, hours, breaks and blocked dates.',
        'Tell clients about your work.',
        'Hourly rate, duration, buffer, mode and work type.',
        'How you receive payouts.',
        'Upload a profile photo or proof document (optional).',
        'Add work photos (optional). Save using the existing profile OTP.'
    ];
    var step = 1;
    var totalSteps = 11;
    function fieldError(id, text) {
        var el = document.getElementById(id);
        if (!el) return;
        el.textContent = text || '';
        el.classList.toggle('on', !!text);
    }
    function clearFieldErrors() {
        document.querySelectorAll('.wj-field-err').forEach(function(el) {
            el.textContent = '';
            el.classList.remove('on');
        });
    }
    function showProfileError(text) {
        var errBox = document.getElementById('js-profile-error');
        var errMsg = document.getElementById('js-profile-error-msg');
        errMsg.textContent = text;
        errBox.style.display = 'flex';
    }
    function validateCurrentStep() {
        var errBox = document.getElementById('js-profile-error');
        errBox.style.display = 'none';
        clearFieldErrors();
        if (step === 1) {
            var phone = (profileForm.phone.value || '').trim();
            if (phone !== '' && !/^\d{10}$/.test(phone)) {
                showProfileError('Phone number must be exactly 10 digits.');
                return false;
            }
            var years = (profileForm.yearsExperience.value || '').trim();
            if (years !== '') {
                var y = parseInt(years, 10);
                if (isNaN(y) || y < 0 || y > 50) {
                    fieldError('err-yearsExperience', 'Years of Experience must be between 0 and 50.');
                    showProfileError('Years of Experience must be between 0 and 50.');
                    return false;
                }
            }
            var wa = (profileForm.whatsappNumber.value || '').trim();
            if (wa !== '' && !/^\d{10}$/.test(wa)) {
                fieldError('err-whatsappNumber', 'WhatsApp number must be exactly 10 digits.');
                showProfileError('WhatsApp number must be exactly 10 digits.');
                return false;
            }
        }
        if (step === 2) {
            var pin = (profileForm.pincode.value || '').trim();
            if (pin !== '' && !/^\d{6}$/.test(pin)) {
                fieldError('err-pincode', 'Pincode must be exactly 6 digits.');
                showProfileError('Pincode must be exactly 6 digits.');
                return false;
            }
        }
        if (step === 8) {
            var rate = (profileForm.hourlyRate.value || '').trim();
            if (rate !== '') {
                var r = parseFloat(rate);
                if (isNaN(r) || r <= 0) {
                    fieldError('err-hourlyRate', 'Hourly rate must be greater than zero.');
                    showProfileError('Hourly rate must be greater than zero.');
                    return false;
                }
            }
        }
        return true;
    }
    function renderStep() {
        document.querySelectorAll('.wj-step').forEach(function(el) {
            el.style.display = String(el.getAttribute('data-step')) === String(step) ? 'block' : 'none';
        });
        document.querySelectorAll('#profileProgress span').forEach(function(el, i) {
            el.classList.toggle('on', i < step);
        });
        document.getElementById('stepLabel').textContent = labels[step - 1];
        document.getElementById('stepDesc').textContent = descs[step - 1];
        document.getElementById('btnProfileBack').style.display = step === 1 ? 'none' : 'inline-flex';
        document.getElementById('btnProfileNext').style.display = step === totalSteps ? 'none' : 'inline-flex';
        document.getElementById('btnProfileSave').style.display = step === totalSteps ? 'inline-flex' : 'none';
    }
    document.getElementById('btnProfileNext').addEventListener('click', function() {
        if (!validateCurrentStep()) return;
        if (step < totalSteps) { step++; renderStep(); }
    });
    document.getElementById('btnProfileBack').addEventListener('click', function() {
        if (step > 1) { step--; renderStep(); }
    });
    renderStep();

    var categories = {
        "Caregiver": ["Elderly Caregiver", "Patient Care Assistant", "Child Caregiver", "Home Care Assistant"],
        "Babysitting": ["Babysitter", "Nanny", "Daycare Assistant"],
        "Housekeeping": ["House Maid", "Housekeeper", "Cleaner"],
        "Cooking": ["Home Cook", "Personal Cook", "Kitchen Assistant"],
        "Beauty & Salon": ["Beautician", "Hair Stylist", "Makeup Artist", "Nail Technician"],
        "Healthcare": ["Nurse", "Care Assistant", "Receptionist", "Lab Assistant"],
        "Teaching": ["Tutor", "School Teacher", "Preschool Teacher"],
        "Office Jobs": ["Receptionist", "Office Assistant", "Data Entry Operator"],
        "Retail": ["Cashier", "Sales Executive", "Store Assistant"],
        "Hospitality": ["Hotel Receptionist", "Housekeeping Staff", "Waitress"],
        "Customer Support": ["Call Center Executive", "Customer Care Representative"],
        "Delivery & Logistics": ["Parcel Coordinator", "Delivery Executive (where applicable)"],
        "Domestic Help": ["Laundry Assistant", "Home Helper"],
        "Tailoring & Fashion": ["Tailor", "Boutique Assistant", "Fashion Designer"],
        "Digital Jobs": ["Content Writer", "Graphic Designer", "Social Media Executive"],
        "Freelancing": ["Virtual Assistant", "Translator", "Online Tutor"],
        "Entrepreneurship": ["Sell Handmade Products", "Home Bakery", "Boutique Owner"]
    };
    window.updateSubCategories = function () {
        var categorySelect = document.getElementById("jobCategory");
        var subCategorySelect = document.getElementById("jobSubCategory");
        if (!categorySelect || !subCategorySelect) return;
        var selectedCategory = categorySelect.value;
        var current = subCategorySelect.value;
        subCategorySelect.innerHTML = '<option value="">Select Specific Job</option>';
        if (selectedCategory && categories[selectedCategory]) {
            categories[selectedCategory].forEach(function (subCat) {
                var option = document.createElement("option");
                option.value = subCat;
                option.text = subCat;
                if (subCat === current) option.selected = true;
                subCategorySelect.appendChild(option);
            });
        }
        if (current && !subCategorySelect.value) {
            var keep = document.createElement("option");
            keep.value = current;
            keep.text = current;
            keep.selected = true;
            subCategorySelect.appendChild(keep);
        }
    };
    updateSubCategories();
});
</script>
</body>
</html>
