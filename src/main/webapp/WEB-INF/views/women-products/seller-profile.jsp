<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Complete seller profile — Women Products</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --navy: #1E1B4B;
            --text-gray: #64748B;
            --bg-page: #F8FAFC;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --success: #16A34A;
            --success-bg: #F0FDF4;
            --error: #DC2626;
            --error-bg: #FEF2F2;
            --rose-soft: #FFE4E6;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--navy);
            display: flex;
            flex-direction: column;
        }
        .app-header {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
            gap: 12px;
            flex-wrap: wrap;
        }
        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--navy);
            text-decoration: none;
        }
        .header-actions { display: flex; align-items: center; gap: 12px; }
        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            background: #FFFFFF;
            color: var(--navy);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
        }
        .btn-skip:hover { background: var(--bg-page); }
        .btn-header-save {
            padding: 8px 18px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-header-save:hover { background: var(--primary-hover); }
        .main-container {
            flex: 1;
            max-width: 1260px;
            width: 100%;
            margin: 24px auto 40px;
            padding: 0 20px;
        }
        .profile-layout-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 380px;
            gap: 28px;
            align-items: start;
        }
        @media (max-width: 991px) {
            .profile-layout-grid { grid-template-columns: 1fr; }
            .preview-column { order: 2; }
        }
        .profile-progress-card {
            background: #FFFFFF;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            gap: 10px;
        }
        .progress-title { font-size: 1rem; font-weight: 800; }
        .status-badge {
            font-size: 0.75rem; font-weight: 700; padding: 4px 10px;
            border-radius: 8px; text-transform: uppercase;
        }
        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-approved { background: var(--success-bg); color: var(--success); }
        .badge-rejected { background: var(--error-bg); color: var(--error); }
        .progress-bar-container {
            height: 8px; background: #E2E8F0; border-radius: 4px; overflow: hidden; margin-bottom: 12px;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #F43F5E, #FB7185);
            border-radius: 4px;
        }
        .section-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        .section-header {
            font-size: 1.05rem;
            font-weight: 800;
            margin-bottom: 16px;
        }
        .form-group { margin-bottom: 14px; }
        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .form-input, .form-textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--navy);
            background: #FFFFFF;
        }
        .form-input:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        @media (max-width: 600px) { .form-row { grid-template-columns: 1fr; } }
        .ro {
            background: #F8FAFC;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 0.9rem;
        }
        .tag {
            font-size: 0.65rem; font-weight: 800; text-transform: uppercase;
            background: #FFE4E6; color: #9F1239; padding: 2px 8px; border-radius: 6px; margin-left: 6px;
        }
        .hint {
            background: #FFF1F2; border: 1px solid #FFE4E6; border-radius: 10px;
            padding: 10px 12px; font-size: 0.82rem; color: var(--text-gray); margin-top: 10px;
        }
        .alert { padding: 12px 14px; border-radius: 10px; margin-bottom: 16px; font-size: 0.88rem; }
        .alert-err { background: #FEF2F2; color: var(--error); }
        .alert-ok { background: #F0FDF4; color: #16A34A; }
        .field-err { display: none; color: var(--error); font-size: 0.78rem; font-weight: 600; margin-top: 6px; }
        .field-err.on { display: block; }
        .btn-bottom-save {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
        }
        .btn-bottom-save:hover { background: var(--primary-hover); }
        .preview-sticky-wrap { position: sticky; top: 80px; }
        .live-preview-card {
            background: #FFFFFF;
            border-radius: 20px;
            border: 1px solid #FECDD3;
            box-shadow: 0 10px 30px rgba(244, 63, 94, 0.08);
            overflow: hidden;
        }
        .preview-banner-header {
            background: linear-gradient(135deg, #FFE4E6 0%, #FFF1F2 100%);
            padding: 16px 20px;
            border-bottom: 1px solid #FECDD3;
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--primary);
        }
        .preview-body { padding: 22px 20px; }
        .preview-name { font-size: 1.2rem; font-weight: 800; margin-bottom: 4px; }
        .preview-shop { color: var(--primary); font-weight: 700; margin-bottom: 12px; }
        .preview-meta {
            font-size: 0.85rem; color: var(--text-gray);
            display: flex; align-items: center; gap: 8px; margin-bottom: 8px;
        }
        .preview-meta i { color: var(--primary); }
    </style>
</head>
<body>
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/women-products/seller/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;">
            Fight D Fear Shop Profile
        </a>
        <div class="header-actions">
            <a class="btn-skip" href="${pageContext.request.contextPath}/women-products/seller/dashboard">Skip for now</a>
            <button type="button" class="btn-header-save" onclick="document.getElementById('sellerProfileForm').requestSubmit()">Save Profile</button>
        </div>
    </header>

    <main class="main-container">
        <div class="profile-layout-grid">
            <div class="form-column">
                <div class="profile-progress-card">
                    <div class="progress-header">
                        <span class="progress-title">Shop Profile Completion:
                            <span>${seller.profileCompletionPct != null ? seller.profileCompletionPct : 0}%</span>
                        </span>
                        <c:choose>
                            <c:when test="${seller.partnerProfileStatus == 'APPROVED'}">
                                <span class="status-badge badge-approved">Approved</span>
                            </c:when>
                            <c:when test="${seller.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                <span class="status-badge badge-pending">Under Review</span>
                            </c:when>
                            <c:when test="${seller.partnerProfileStatus == 'REJECTED'}">
                                <span class="status-badge badge-rejected">Rejected</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge badge-registered">Registered</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="progress-bar-container">
                        <div class="progress-bar-fill" style="width: ${seller.profileCompletionPct != null ? seller.profileCompletionPct : 0}%;"></div>
                    </div>
                    <p style="font-size: 0.8rem; color: var(--text-gray);">Fill the sections below and save. Skip anytime to return to your dashboard.</p>
                </div>

                <c:if test="${not empty error}"><div class="alert alert-err">${error}</div></c:if>
                <c:if test="${not empty message}"><div class="alert alert-ok">${message}</div></c:if>

                <form id="sellerProfileForm" action="${pageContext.request.contextPath}/women-products/seller/profile/update" method="post" enctype="multipart/form-data" novalidate>
                    <div class="section-card">
                        <div class="section-header">1. Seller identity</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>1.1 Full name *</label>
                                <input class="form-input" name="fullName" id="fullName" required maxlength="80" value="${seller.fullName}">
                                <small class="field-err" id="err-fullName"></small>
                            </div>
                            <div class="form-group">
                                <label>1.3 Shop name *</label>
                                <input class="form-input" name="businessName" id="businessName" required maxlength="100" value="${seller.businessName}">
                                <small class="field-err" id="err-businessName"></small>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Email <span class="tag">Not editable on web</span></label>
                                <div class="ro"><c:out value="${seller.email}"/></div>
                            </div>
                            <div class="form-group">
                                <label>1.5 Official phone *</label>
                                <input class="form-input" name="phone" id="phone" required maxlength="10" inputmode="numeric" value="${seller.phone}">
                                <small class="field-err" id="err-phone"></small>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>1.2 Role / designation</label>
                                <input class="form-input" name="designation" maxlength="120" value="${seller.designation}">
                            </div>
                            <div class="form-group">
                                <label>1.6 WhatsApp</label>
                                <input class="form-input" name="whatsappNumber" maxlength="10" inputmode="numeric" value="${seller.whatsappNumber}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>1.7 Experience</label>
                            <input class="form-input" name="experience" maxlength="100" value="${seller.experience}" placeholder="e.g. 5 years">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">2. Location</div>
                        <div class="form-group">
                            <label>2.1 Landmark / address *</label>
                            <input class="form-input" name="address" id="address" required maxlength="1000" value="${seller.address}">
                            <small class="field-err" id="err-address"></small>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>City</label>
                                <input class="form-input" name="city" maxlength="80" value="${seller.city}">
                            </div>
                            <div class="form-group">
                                <label>State</label>
                                <input class="form-input" name="state" maxlength="80" value="${seller.state}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Pincode</label>
                            <input class="form-input" name="pincode" maxlength="6" inputmode="numeric" value="${seller.pincode}">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">3. Categories you sell</div>
                        <div class="form-group">
                            <label>3.1 Categories you sell</label>
                            <input class="form-input" name="category" maxlength="100" value="${seller.category}" placeholder="Primary category">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">4. Who I serve</div>
                        <div class="form-group">
                            <label>Service area</label>
                            <input class="form-input" name="serviceArea" maxlength="255" value="${seller.serviceArea}" placeholder="Cities / regions you serve">
                        </div>
                        <div class="form-group">
                            <label>Languages spoken</label>
                            <input class="form-input" name="languagesSpoken" maxlength="255" value="${seller.languagesSpoken}" placeholder="e.g. English, Hindi">
                        </div>
                        <div class="form-group">
                            <label>Audience</label>
                            <input class="form-input" name="audience" maxlength="255" value="${seller.audience}" placeholder="e.g. Women, Families">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">5. Shop facilities</div>
                        <div class="form-group">
                            <label>Qualification / credentials</label>
                            <textarea class="form-textarea" name="qualification" rows="3" maxlength="2000">${seller.qualification}</textarea>
                        </div>
                        <div class="form-group">
                            <label>Shop amenities</label>
                            <input class="form-input" name="facilities" maxlength="500" value="${seller.facilities}" placeholder="e.g. Parking, Trial room">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">6. Hours &amp; calendar</div>
                        <div class="form-group">
                            <label>6.1 Open / available days</label>
                            <input class="form-input" name="availableDays" value="${seller.availableDays}" placeholder="Mon,Tue,Wed">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>6.2 Open from</label>
                                <input class="form-input" name="workingHoursFrom" maxlength="50" value="${seller.workingHoursFrom}" placeholder="09:00">
                            </div>
                            <div class="form-group">
                                <label>6.3 Close to</label>
                                <input class="form-input" name="workingHoursTo" maxlength="50" value="${seller.workingHoursTo}" placeholder="18:00">
                            </div>
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">7. About the shop</div>
                        <div class="form-group">
                            <label>7.1 About the shop</label>
                            <textarea class="form-textarea" name="description" rows="4" maxlength="2000">${seller.description}</textarea>
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">8. First listing defaults</div>
                        <div class="form-group">
                            <label>Brand / listing type</label>
                            <input class="form-input" name="brandType" maxlength="120" value="${seller.brandType}" placeholder="e.g. Handmade, Retail">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">9. Payout</div>
                        <div class="form-group">
                            <label>UPI ID</label>
                            <input class="form-input" name="upiId" value="${seller.upiId}" placeholder="upi-handle@bank">
                        </div>
                        <div class="form-group">
                            <label>GSTIN</label>
                            <input class="form-input" name="gstin" value="${seller.gstin}" placeholder="GST number">
                        </div>
                        <div class="form-group">
                            <label>Bank details</label>
                            <input class="form-input" name="bankDetails" value="${seller.bankDetails}" placeholder="Bank, A/C, IFSC">
                        </div>
                    </div>

                    <div class="section-card">
                        <div class="section-header">10. Documents (optional)</div>
                        <div class="form-group">
                            <label>Profile photo (optional update)</label>
                            <input class="form-input" type="file" name="profilePhoto" accept="image/png,image/jpeg,image/jpg,image/webp">
                        </div>
                        <div class="form-group">
                            <label>Identity document (optional update)</label>
                            <input class="form-input" type="file" name="identityDoc" accept="image/*,.pdf">
                        </div>
                        <c:if test="${not empty seller.identityDocPath}">
                            <p class="hint"><a href="${pageContext.request.contextPath}${seller.identityDocPath}" target="_blank">View current identity document</a></p>
                        </c:if>
                    </div>

                    <div class="section-card">
                        <div class="section-header">11. Work photos (optional)</div>
                        <div class="form-group">
                            <label>Gallery photos</label>
                            <input class="form-input" type="file" name="galleryPhotos" accept="image/*" multiple>
                        </div>
                        <c:if test="${not empty seller.galleryPhotos}">
                            <div class="ro" style="margin-top:10px;"><c:out value="${seller.galleryPhotos}"/></div>
                        </c:if>
                        <p class="hint">Save stores all profile fields, then opens the seller dashboard.</p>
                    </div>

                    <button type="submit" class="btn-bottom-save">Save Profile</button>
                </form>
            </div>

            <aside class="preview-column">
                <div class="preview-sticky-wrap">
                    <div class="live-preview-card">
                        <div class="preview-banner-header">Shop preview</div>
                        <div class="preview-body">
                            <div class="preview-name"><c:out value="${not empty seller.fullName ? seller.fullName : 'Your name'}"/></div>
                            <div class="preview-shop"><c:out value="${not empty seller.businessName ? seller.businessName : 'Shop name'}"/></div>
                            <div class="preview-meta"><i class="bi bi-envelope"></i> <c:out value="${seller.email}"/></div>
                            <div class="preview-meta"><i class="bi bi-telephone"></i> <c:out value="${not empty seller.phone ? seller.phone : 'Phone'}"/></div>
                            <div class="preview-meta"><i class="bi bi-geo-alt"></i>
                                <c:choose>
                                    <c:when test="${not empty seller.city}">${seller.city}<c:if test="${not empty seller.state}">, ${seller.state}</c:if></c:when>
                                    <c:otherwise>Location</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </main>
<script>
(function () {
    var form = document.getElementById('sellerProfileForm');
    function showErr(id, text) {
        var el = document.getElementById(id);
        if (!el) return;
        el.textContent = text || '';
        el.classList.toggle('on', !!text);
    }
    function validate() {
        document.querySelectorAll('.field-err').forEach(function (e) { e.classList.remove('on'); e.textContent=''; });
        var n = form.fullName.value.trim();
        if (n.length < 2 || !/^[A-Za-z][A-Za-z .'-]{1,79}$/.test(n)) {
            showErr('err-fullName','Full name must be 2–80 letters only.');
            form.fullName.focus();
            return false;
        }
        var b = form.businessName.value.trim();
        if (b.length < 2) {
            showErr('err-businessName','Shop name is required.');
            form.businessName.focus();
            return false;
        }
        var p = form.phone.value.trim();
        if (!/^[6-9]\d{9}$/.test(p)) {
            showErr('err-phone','Enter a valid 10-digit Indian mobile number.');
            form.phone.focus();
            return false;
        }
        var a = form.address.value.trim();
        if (a.length < 10) {
            showErr('err-address','Address must be at least 10 characters.');
            form.address.focus();
            return false;
        }
        return true;
    }
    form.addEventListener('submit', function (e) {
        if (!validate()) e.preventDefault();
    });
})();
</script>
</body>
</html>
