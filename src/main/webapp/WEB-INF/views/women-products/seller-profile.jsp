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
        :root { --rose:#F43F5E; --navy:#1E1B4B; --muted:#64748B; --bg:#F8FAFC; --border:#E2E8F0; --err:#DC2626; }
        * { box-sizing: border-box; }
        body { margin:0; font-family:Inter,sans-serif; background:var(--bg); color:var(--navy); }
        .top { background:#fff; border-bottom:1px solid var(--border); padding:18px 28px; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap; }
        .top h1 { margin:0; font-size:1.35rem; }
        .top p { margin:4px 0 0; color:var(--muted); font-size:0.88rem; }
        .btn-skip { display:inline-flex; align-items:center; height:42px; padding:0 16px; border:1px solid var(--border); border-radius:10px; color:var(--navy); text-decoration:none; font-weight:600; background:#fff; }
        .wrap { max-width:920px; margin:0 auto; padding:28px 20px 56px; }
        .card { background:#fff; border:1px solid var(--border); border-radius:20px; padding:28px; box-shadow:0 10px 32px rgba(30,27,75,.06); }
        .progress { display:flex; gap:6px; flex-wrap:wrap; margin-bottom:16px; }
        .progress span { flex:1 1 18px; height:8px; border-radius:99px; background:#E2E8F0; }
        .progress span.on { background:var(--rose); }
        .step-title { font-size:0.78rem; font-weight:800; letter-spacing:.06em; text-transform:uppercase; margin:0 0 6px; }
        .step-desc { color:var(--muted); margin:0 0 18px; font-size:0.9rem; }
        .grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .full { grid-column:1/-1; }
        label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:6px; }
        input, textarea { width:100%; padding:12px 14px; border:1px solid var(--border); border-radius:12px; font:inherit; }
        input:focus, textarea:focus { outline:none; border-color:var(--rose); }
        .ro { background:#F8FAFC; border:1px solid var(--border); border-radius:12px; padding:12px; font-size:0.9rem; }
        .tag { font-size:0.65rem; font-weight:800; text-transform:uppercase; background:#FFE4E6; color:#9F1239; padding:2px 8px; border-radius:6px; margin-left:6px; }
        .hint { background:#FFF1F2; border:1px solid #FFE4E6; border-radius:10px; padding:10px 12px; font-size:0.82rem; color:var(--muted); margin-bottom:14px; }
        .wp-profile-nav { margin-top: 24px; }
        .wp-profile-nav .btn-skip { margin-bottom: 12px; }
        .wp-profile-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            width: 100%;
        }
        .wp-profile-actions .btn {
            height: 44px;
            min-width: 120px;
            padding: 0 20px;
            border-radius: 12px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            box-sizing: border-box;
            flex-shrink: 0;
        }
        .wp-profile-actions .btn-next,
        .wp-profile-actions .btn-save { margin-left: auto; }
        .btn-next, .btn-save { background:var(--rose); color:#fff; border:none; }
        .btn-back { background:#fff; border:1px solid var(--border); color:var(--navy); }
        @media (max-width:640px) {
            .grid { grid-template-columns:1fr; }
            .top { padding:16px; }
            .card { padding:18px 14px; }
            .wp-profile-actions { flex-direction: column; align-items: stretch; }
            .wp-profile-actions .btn { width: 100%; min-width: 0; margin-left: 0; }
        }
        .alert { padding:12px 14px; border-radius:10px; margin-bottom:16px; font-size:0.88rem; }
        .alert-err { background:#FEF2F2; color:var(--err); }
        .alert-ok { background:#F0FDF4; color:#16A34A; }
        .field-err { display:none; color:var(--err); font-size:0.78rem; font-weight:600; margin-top:6px; }
        .field-err.on { display:block; }
    </style>
</head>
<body>
<header class="top">
    <div>
        <h1>Complete your shop profile</h1>
        <p>12 sections using fields the web profile save already supports</p>
    </div>
    <a class="btn-skip" href="${pageContext.request.contextPath}/women-products/seller/dashboard">Skip for now</a>
</header>
<main class="wrap">
    <c:if test="${not empty error}"><div class="alert alert-err">${error}</div></c:if>
    <c:if test="${not empty message}"><div class="alert alert-ok">${message}</div></c:if>
    <div class="card">
        <div class="progress" id="progress"><span class="on"></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span></div>
        <p class="step-title" id="stepLabel">Step 1 of 12 — Seller identity</p>
        <p class="step-desc" id="stepDesc">Owner, shop name and contact phone.</p>
        <form id="sellerProfileForm" action="${pageContext.request.contextPath}/women-products/seller/profile/update" method="post" enctype="multipart/form-data" novalidate>
            <div class="wj-step" data-step="1">
                <div class="grid">
                    <div><label>1.1 Full name *</label><input name="fullName" id="fullName" required maxlength="80" value="${seller.fullName}"><small class="field-err" id="err-fullName"></small></div>
                    <div><label>1.3 Shop name *</label><input name="businessName" id="businessName" required maxlength="100" value="${seller.businessName}"><small class="field-err" id="err-businessName"></small></div>
                    <div><label>Email <span class="tag">Not editable on web</span></label><div class="ro"><c:out value="${seller.email}"/></div></div>
                    <div><label>1.5 Official phone *</label><input name="phone" id="phone" required maxlength="10" inputmode="numeric" value="${seller.phone}"><small class="field-err" id="err-phone"></small></div>
                    <div><label>1.7 Experience</label><input name="experience" maxlength="100" value="${seller.experience}" placeholder="e.g. 5 years"></div>
                </div>
            </div>
            <div class="wj-step" data-step="2" style="display:none;">
                <div class="grid">
                    <div class="full"><label>2.1 Landmark / address *</label><input name="address" id="address" required maxlength="1000" value="${seller.address}"><small class="field-err" id="err-address"></small></div>
                    <div><label>City <span class="tag">Not editable on web save</span></label><div class="ro"><c:out value="${empty seller.city ? 'Not set' : seller.city}"/></div></div>
                    <div><label>State / pincode <span class="tag">Not editable on web save</span></label><div class="ro"><c:out value="${seller.state}"/> · <c:out value="${seller.pincode}"/></div></div>
                </div>
            </div>
            <div class="wj-step" data-step="3" style="display:none;">
                <label>3.1 Categories you sell</label>
                <input name="category" maxlength="100" value="${seller.category}" placeholder="Primary category">
            </div>
            <div class="wj-step" data-step="4" style="display:none;">
                <label>Service area</label>
                <input name="serviceArea" maxlength="255" value="${seller.serviceArea}" placeholder="Cities / regions you serve">
                <div class="hint" style="margin-top:12px;">Audience / pickup options are mobile-managed and are not on the web save.</div>
            </div>
            <div class="wj-step" data-step="5" style="display:none;">
                <label>Qualification / credentials</label>
                <textarea name="qualification" rows="3" maxlength="2000">${seller.qualification}</textarea>
                <div class="hint" style="margin-top:12px;">Shop amenity chips are mobile-managed.</div>
            </div>
            <div class="wj-step" data-step="6" style="display:none;">
                <div class="grid">
                    <div class="full"><label>6.1 Open / available days</label><input name="availableDays" value="${seller.availableDays}" placeholder="Mon,Tue,Wed"></div>
                    <div><label>6.2 Open from</label><input name="workingHoursFrom" maxlength="50" value="${seller.workingHoursFrom}" placeholder="09:00"></div>
                    <div><label>6.3 Close to</label><input name="workingHoursTo" maxlength="50" value="${seller.workingHoursTo}" placeholder="18:00"></div>
                </div>
            </div>
            <div class="wj-step" data-step="7" style="display:none;">
                <label>7.1 About the shop</label>
                <textarea name="description" rows="4" maxlength="2000">${seller.description}</textarea>
            </div>
            <div class="wj-step" data-step="8" style="display:none;">
                <p class="hint">Listing defaults such as brand type and dispatch hours are mobile-managed. Primary category is saved in section 3.</p>
            </div>
            <div class="wj-step" data-step="9" style="display:none;">
                <p class="hint">UPI / GST / bank payout fields exist on the seller record but are not included in the web profile save.</p>
                <div class="ro"><c:out value="${empty seller.upiId ? 'UPI not set' : seller.upiId}"/></div>
            </div>
            <div class="wj-step" data-step="10" style="display:none;">
                <label>Profile photo (optional update)</label>
                <input type="file" name="profilePhoto" accept="image/png,image/jpeg,image/jpg,image/webp">
                <p class="hint" style="margin-top:10px;">Identity document is already on file and is not re-uploaded here.</p>
            </div>
            <div class="wj-step" data-step="11" style="display:none;">
                <p class="hint">Gallery photos are mobile-managed.</p>
                <div class="ro"><c:out value="${empty seller.galleryPhotos ? 'No gallery photos on file' : seller.galleryPhotos}"/></div>
            </div>
            <div class="wj-step" data-step="12" style="display:none;">
                <p class="hint">Save uses the existing profile update. Skip goes straight to the seller dashboard.</p>
            </div>
            <div class="wp-profile-nav">
                <a class="btn-skip" href="${pageContext.request.contextPath}/women-products/seller/dashboard">Skip for now</a>
                <div class="wp-profile-actions">
                    <button type="button" class="btn btn-back" id="btnBack" style="display:none;">Back</button>
                    <button type="button" class="btn btn-next" id="btnNext">Next</button>
                    <button type="submit" class="btn btn-save" id="btnSave" style="display:none;">Save Profile</button>
                </div>
            </div>
        </form>
    </div>
</main>
<script>
(function () {
    var form = document.getElementById('sellerProfileForm');
    var step = 1, total = 12;
    var labels = [
        'Step 1 of 12 — Seller identity','Step 2 of 12 — Location','Step 3 of 12 — Categories you sell',
        'Step 4 of 12 — Who I serve','Step 5 of 12 — Shop facilities','Step 6 of 12 — Hours & calendar',
        'Step 7 of 12 — About the shop','Step 8 of 12 — First listing defaults','Step 9 of 12 — Payout',
        'Step 10 of 12 — Documents (optional)','Step 11 of 12 — Work photos (optional)','Step 12 of 12 — Review & save'
    ];
    var descs = [
        'Owner, shop name and contact phone.','Shop address.','Primary sell category.',
        'Service area you cover.','Credentials shown to customers.','Days and hours.',
        'About the shop.','Mobile-managed listing defaults.','Payout details on file.',
        'Optional photo update.','Gallery on file.','Save or skip to dashboard.'
    ];
    function showErr(id, text) {
        var el = document.getElementById(id);
        if (!el) return;
        el.textContent = text || '';
        el.classList.toggle('on', !!text);
    }
    function validate() {
        document.querySelectorAll('.field-err').forEach(function (e) { e.classList.remove('on'); e.textContent=''; });
        if (step === 1) {
            var n = form.fullName.value.trim();
            if (n.length < 2 || !/^[A-Za-z][A-Za-z .'-]{1,79}$/.test(n)) { showErr('err-fullName','Full name must be 2–80 letters only.'); return false; }
            var b = form.businessName.value.trim();
            if (b.length < 2) { showErr('err-businessName','Shop name is required.'); return false; }
            var p = form.phone.value.trim();
            if (!/^[6-9]\d{9}$/.test(p)) { showErr('err-phone','Enter a valid 10-digit Indian mobile number.'); return false; }
        }
        if (step === 2) {
            var a = form.address.value.trim();
            if (a.length < 10) { showErr('err-address','Address must be at least 10 characters.'); return false; }
        }
        return true;
    }
    function render() {
        document.querySelectorAll('.wj-step').forEach(function (el) {
            el.style.display = String(el.getAttribute('data-step')) === String(step) ? 'block' : 'none';
        });
        document.querySelectorAll('#progress span').forEach(function (el, i) { el.classList.toggle('on', i < step); });
        document.getElementById('stepLabel').textContent = labels[step-1];
        document.getElementById('stepDesc').textContent = descs[step-1];
        document.getElementById('btnBack').style.display = step === 1 ? 'none' : 'inline-flex';
        document.getElementById('btnNext').style.display = step === total ? 'none' : 'inline-flex';
        document.getElementById('btnSave').style.display = step === total ? 'inline-flex' : 'none';
    }
    document.getElementById('btnNext').addEventListener('click', function () { if (!validate()) return; if (step < total) { step++; render(); } });
    document.getElementById('btnBack').addEventListener('click', function () { if (step > 1) { step--; render(); } });
    form.addEventListener('submit', function (e) {
        step = 1; if (!validate()) { e.preventDefault(); render(); return; }
        step = 2; if (!validate()) { e.preventDefault(); render(); return; }
    });
    render();
})();
</script>
</body>
</html>
