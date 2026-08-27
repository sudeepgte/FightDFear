<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Profile — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-rose: #f43f5e;
            --primary-rose-hover: #e11d48;
            --primary-plum: #4c0519;
            --bg-scaffold: #f8fafc;
            --bg-surface: #ffffff;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --border-light: #e2e8f0;
            --rose-bg-light: #ffe4e6;
            --rose-text-dark: #be123c;
            --font-heading: 'Poppins', sans-serif;
            --font-body: 'Inter', sans-serif;
            --border-color: #F8C8D4;
        }

        body {
            font-family: var(--font-body);
            background-color: var(--bg-scaffold);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 0;
            margin: 0;
        }

        /* Top Bar */
        .app-header {
            background: #FFFFFF;
            border-bottom: 2px solid var(--primary-rose);
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--primary-plum);
            text-decoration: none;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-light);
            background: #FFFFFF;
            color: var(--text-primary);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-skip:hover {
            background: var(--bg-scaffold);
        }

        .btn-header-save {
            padding: 8px 16px;
            background: var(--primary-rose);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-header-save:hover {
            background: var(--primary-rose-hover);
        }

        .main-container {
            flex: 1;
            max-width: 760px;
            width: 100%;
            margin: 20px auto 40px;
            padding: 0 16px;
        }

        .profile-progress-card {
            background: var(--rose-bg-light);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.05);
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .progress-title {
            font-size: 1rem;
            font-weight: 800;
            color: var(--primary-plum);
        }

        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 8px;
            text-transform: uppercase;
        }

        .badge-registered { background: #E2E8F0; color: #475569; }
        .badge-pending { background: #FEF3C7; color: #92400E; }
        .badge-changes { background: #FFF7ED; color: #C2410C; border: 1px solid #FFEDD5; }
        .badge-approved { background: var(--rose-bg-light); color: var(--primary-rose); }
        .badge-rejected { background: #FEF2F2; color: #DC2626; }

        .progress-bar-container {
            height: 8px;
            background: #E2E8F0;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 12px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-rose), #FB7185);
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        /* Admin Feedback Banner */
        .feedback-banner {
            background: #FFFBEB;
            border: 1px solid #FCD34D;
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 16px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .feedback-banner i {
            color: #D97706;
            font-size: 1.3rem;
            margin-top: 2px;
        }

        .feedback-content h4 {
            font-size: 0.9rem;
            font-weight: 800;
            color: #92400E;
            margin-bottom: 4px;
        }

        .feedback-content p {
            font-size: 0.85rem;
            color: #78350F;
            line-height: 1.4;
        }

        /* Submit Action Bar */
        .submit-bar {
            margin-bottom: 20px;
        }

        .btn-submit-verification {
            width: 100%;
            padding: 14px;
            background: var(--primary-rose);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--primary-rose-hover);
        }

        .btn-submit-verification:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748B;
        }

        /* Numbered Section Cards */
        .section-card {
            background: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .section-header {
            font-family: var(--font-heading);
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--primary-plum);
            background: #fff1f2;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-left: 4px solid var(--primary-rose);
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--primary-plum);
            margin-bottom: 6px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--text-primary);
            background: #FFFFFF;
            transition: all 0.2s;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary-rose);
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.12);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        @media (max-width: 600px) {
            .form-row { grid-template-columns: 1fr; }
        }

        /* Save Button at Bottom */
        .bottom-actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
        }

        .btn-bottom-save {
            flex: 1;
            padding: 14px;
            background: var(--primary-rose);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-bottom-save:hover {
            background: var(--primary-rose-hover);
        }

        .alert-box {
            padding: 12px 14px;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-success {
            background: var(--rose-bg-light);
            border: 1px solid var(--border-color);
            color: var(--primary-rose);
        }
    
        .bg-rose { background-color: #f43f5e !important; color: white !important; }
        .text-rose { color: #f43f5e !important; }
        .badge-rose { background-color: #ffe4e6 !important; color: #f43f5e !important; border: 1px solid #F8C8D4; }
</style>
</head>
<body>

    <!-- Header with Skip Form Actions -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/investor/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-skip">Skip to Dashboard</a>
            <button type="button" class="btn-header-save" onclick="document.getElementById('profileForm').submit()">Save Profile</button>
        </div>
    </header>

    <main class="main-container">

        <c:if test="${not empty success}">
            <div class="alert-box alert-success">
                <i class="bi bi-check-circle-fill"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert-box alert-danger text-danger badge-rose p-3 rounded border border-danger-subtle mb-3">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
            <div style="background: linear-gradient(135deg, var(--primary-rose) 0%, var(--primary-rose-hover) 100%); border-radius: 16px; padding: 20px; color: white; margin-bottom: 20px; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <span style="background: rgba(255,255,255,0.2); color: white; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 50px; text-transform: uppercase; letter-spacing: 0.5px;">Account Verified & Approved</span>
                        <h3 style="font-size: 1.25rem; font-weight: 800; margin: 8px 0 4px; color: white;"><i class="bi bi-patch-check-fill me-1"></i> Your Investor Dashboard is Unlocked!</h3>
                        <p style="margin: 0; font-size: 0.88rem; color: rgba(255,255,255,0.9);">Admin has approved your profile credentials. You can now access and invest directly in startups within the marketplace.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/investor/dashboard" style="background: #FFFFFF; color: var(--primary-rose-hover); font-weight: 700; font-size: 0.95rem; padding: 12px 24px; border-radius: 50px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); transition: transform 0.2s;">
                        <i class="bi bi-speedometer2"></i> Open Investor Dashboard
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Dynamic Profile Completion Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <span class="progress-title">Profile Completion: <span id="pctText">${not empty investor.profileCompletionPct ? investor.profileCompletionPct : 20}%</span></span>
                <c:choose>
                    <c:when test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
                        <span class="status-badge badge-approved">Approved</span>
                    </c:when>
                    <c:when test="${not empty investor and investor.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes">Changes Requested</span>
                    </c:when>
                    <c:when test="${not empty investor and investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending">Under Review</span>
                    </c:when>
                    <c:when test="${not empty investor and investor.partnerProfileStatus == 'REJECTED'}">
                        <span class="status-badge badge-rejected">Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered">Registered</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="progress-bar-container">
                <div class="progress-bar-fill" style="width: <c:out value='${not empty investor.profileCompletionPct ? investor.profileCompletionPct : 20}'/>%;"></div>
            </div>
            <p style="font-size: 0.8rem; color: var(--text-secondary);">
                Please complete all required fields below. Submit for Admin verification once your completeness reaches 100%.
            </p>
        </div>

        <!-- Admin Feedback Banner -->
        <c:if test="${not empty investor and not empty investor.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Feedback</h4>
                    <p><c:out value="${investor.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty investor and not empty investor.changesRequestedNote}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Required Revisions</h4>
                    <p><c:out value="${investor.changesRequestedNote}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Submit for Verification Bar -->
        <div class="submit-bar">
            <c:choose>
                <c:when test="${not empty investor and (investor.partnerProfileStatus == 'APPROVED' or investor.verificationStatus == 'VERIFIED')}">
                    <a href="${pageContext.request.contextPath}/investor/dashboard" class="btn-submit-verification" style="background:var(--primary-rose); color:white; text-decoration:none; display:flex; align-items:center; justify-content:center; gap:8px;">
                        <i class="bi bi-patch-check-fill"></i> Profile Approved — Open Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/investor/submit-verification" method="post">
                        <button type="submit" id="btnSubmitVerification" class="btn-submit-verification" 
                                <c:if test="${(empty investor.profileCompletionPct or investor.profileCompletionPct < 100) or investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${not empty investor and investor.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Under Review — Pending Admin Approval
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-send-check-fill"></i> Submit for Admin Verification
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Onboarding and profile completion form -->
        <form id="profileForm" action="${pageContext.request.contextPath}/investor/complete-profile" method="post">
            
            <!-- Section 1: Business Profile & Credentials -->
            <div class="section-card">
                <div class="section-header">1. Business Profile & Identity</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>1.1 Full Name *</label>
                        <input type="text" name="fullName" class="form-input" value="<c:out value='${investor.fullName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label>1.2 Role / Designation *</label>
                        <input type="text" name="designation" class="form-input" value="<c:out value='${investor.designation}'/>" placeholder="e.g. Managing Partner / Director" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.3 Business / Company Name *</label>
                        <input type="text" name="companyName" class="form-input" value="<c:out value='${investor.companyName}'/>" placeholder="e.g. Apex Capital Ventures" required>
                    </div>
                    <div class="form-group">
                        <label>1.4 SEBI / AIF / PAN ID *</label>
                        <input type="text" name="credentialNumber" class="form-input" value="<c:out value='${investor.credentialNumber}'/>" placeholder="10-character SEBI ID or PAN Card Number" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.5 Mobile Number *</label>
                        <input type="tel" name="phone" class="form-input" value="<c:out value='${investor.phone}'/>" maxlength="10" required>
                    </div>
                    <div class="form-group">
                        <label>1.6 WhatsApp Number</label>
                        <input type="tel" name="whatsappNumber" class="form-input" value="<c:out value='${investor.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                    </div>
                </div>
            </div>

            <!-- Section 2: Address & Location -->
            <div class="section-card">
                <div class="section-header">2. Address & Operations</div>
                
                <div class="form-group">
                    <label>2.1 Street Address *</label>
                    <input type="text" name="address" class="form-input" value="<c:out value='${investor.address}'/>" placeholder="Shop/Office No, Building Name, Landmark" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>2.2 City *</label>
                        <input type="text" name="city" class="form-input" value="<c:out value='${investor.city}'/>" placeholder="City" required>
                    </div>
                    <div class="form-group">
                        <label>2.3 State *</label>
                        <input type="text" name="state" class="form-input" value="<c:out value='${investor.state}'/>" placeholder="State" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>2.4 Pincode *</label>
                    <input type="text" name="pincode" class="form-input" value="<c:out value='${investor.pincode}'/>" placeholder="6-digit Pincode" maxlength="6" required>
                </div>
            </div>

            <!-- Section 3: Sector & Cheque Details -->
            <div class="section-card">
                <div class="section-header">3. Investment Thesis Details</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>3.1 Target Sectors / Categories *</label>
                        <input type="text" name="categoriesOffered" class="form-input" value="<c:out value='${investor.categoriesOffered}'/>" placeholder="e.g. Tech, Retail, Apparel, Handicrafts" required>
                    </div>
                    <div class="form-group">
                        <label>3.2 Who I Fund (Audience) *</label>
                        <input type="text" name="audience" class="form-input" value="<c:out value='${investor.audience}'/>" placeholder="e.g. Women Entrepreneurs, Tech Startups" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>3.3 Investment Stage (Ticket Mode) *</label>
                        <select name="ticketMode" class="form-select" required>
                            <option value="Angel" <c:if test="${investor.ticketMode == 'Angel'}">selected</c:if>>Angel (₹10K - ₹2L)</option>
                            <option value="Seed" <c:if test="${investor.ticketMode == 'Seed'}">selected</c:if>>Seed (₹2L - ₹10L)</option>
                            <option value="Series" <c:if test="${investor.ticketMode == 'Series'}">selected</c:if>>Series (₹10L - ₹50L)</option>
                            <option value="Grant" <c:if test="${investor.ticketMode == 'Grant'}">selected</c:if>>Grant (Non-equity/Social)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>3.4 Typical Cheque / Budget Size (₹) *</label>
                        <input type="number" step="1000" name="typicalPrice" class="form-input" value="<c:out value='${investor.typicalCheque}'/>" placeholder="e.g. 50000" required>
                    </div>
                </div>
            </div>

            <!-- Section 4: Schedule & Meeting Slot Settings -->
            <div class="section-card">
                <div class="section-header">4. Call & Meeting Slot Settings</div>
                
                <div class="form-group">
                    <label>4.1 Available Days *</label>
                    <input type="text" name="openDays" class="form-input" value="<c:out value='${investor.openDays}'/>" placeholder="e.g. Mon-Fri or Monday, Wednesday" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>4.2 Availability Start Time *</label>
                        <input type="time" name="openTime" class="form-input" value="<c:out value='${investor.openTime}'/>" required>
                    </div>
                    <div class="form-group">
                        <label>4.3 Availability End Time *</label>
                        <input type="time" name="closeTime" class="form-input" value="<c:out value='${investor.closeTime}'/>" required>
                    </div>
                </div>
            </div>

            <!-- Section 5: Profile Bio & Investment Focus -->
            <div class="section-card">
                <div class="section-header">5. Profile Bio & Focus</div>
                <div class="form-group">
                    <label>5.1 About Me / Investment Focus Notes *</label>
                    <textarea name="bio" class="form-textarea" rows="4" placeholder="Briefly introduce your investment criteria, support, and mentorship expertise..." required><c:out value="${investor.bio}"/></textarea>
                </div>
            </div>

            <!-- Section 6: Settlement & Bank Info (For Commissions/Transfers) -->
            <div class="section-card">
                <div class="section-header">6. Payout & Bank Settling Info</div>
                <div class="form-group">
                    <label>6.1 UPI ID</label>
                    <input type="text" name="upiId" class="form-input" value="<c:out value='${investor.upiId}'/>" placeholder="e.g. pay@bank">
                </div>
                <div class="form-group">
                    <label>6.2 Bank Routing Info</label>
                    <textarea name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, IFSC routing code"><c:out value="${investor.bankDetails}"/></textarea>
                </div>
            </div>

            <div class="bottom-actions">
                <button type="submit" class="btn-bottom-save">Save Profile Details</button>
            </div>
        </form>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("profileForm");
            if (!form) return;

            function updateCompletionPct() {
                let filledCount = 0;
                const totalRequired = 16;

                // 1. Full name
                if (form.querySelector("[name='fullName']")?.value.trim()) filledCount++;
                // 2. Designation
                if (form.querySelector("[name='designation']")?.value.trim()) filledCount++;
                // 3. Company name
                if (form.querySelector("[name='companyName']")?.value.trim()) filledCount++;
                // 4. Mobile phone (10 digits)
                const phone = form.querySelector("[name='phone']")?.value.trim() || "";
                if (phone && phone.length === 10) filledCount++;
                // 5. Credential (PAN / SEBI)
                if (form.querySelector("[name='credentialNumber']")?.value.trim()) filledCount++;
                // 6. Address
                if (form.querySelector("[name='address']")?.value.trim()) filledCount++;
                // 7. City
                if (form.querySelector("[name='city']")?.value.trim()) filledCount++;
                // 8. State
                if (form.querySelector("[name='state']")?.value.trim()) filledCount++;
                // 9. Pincode (6 digits)
                const pincode = form.querySelector("[name='pincode']")?.value.trim() || "";
                if (pincode && pincode.length === 6) filledCount++;
                // 10. Sectors (Categories offered)
                if (form.querySelector("[name='categoriesOffered']")?.value.trim()) filledCount++;
                // 11. Who I fund (Audience)
                if (form.querySelector("[name='audience']")?.value.trim()) filledCount++;
                // 12. Open days
                if (form.querySelector("[name='openDays']")?.value.trim()) filledCount++;
                // 13. Open time
                if (form.querySelector("[name='openTime']")?.value) filledCount++;
                // 14. Close time
                if (form.querySelector("[name='closeTime']")?.value) filledCount++;
                // 15. Bio
                if (form.querySelector("[name='bio']")?.value.trim()) filledCount++;
                // 16. Ticket modes & cheque
                const cheque = parseFloat(form.querySelector("[name='typicalPrice']")?.value);
                const stage = form.querySelector("[name='ticketMode']")?.value;
                if (stage && !isNaN(cheque) && cheque > 0) filledCount++;

                const pct = Math.round((filledCount / totalRequired) * 100);

                const pctText = document.getElementById("pctText");
                const progressFill = document.querySelector(".progress-bar-fill");
                const verificationBtn = document.getElementById("btnSubmitVerification");

                if (pctText) pctText.textContent = pct + "%";
                if (progressFill) progressFill.style.width = pct + "%";
                
                if (verificationBtn) {
                    if (pct >= 100) {
                        verificationBtn.disabled = false;
                    } else {
                        verificationBtn.disabled = true;
                    }
                }
            }

            form.querySelectorAll("input, select, textarea").forEach(input => {
                input.addEventListener("input", updateCompletionPct);
                input.addEventListener("change", updateCompletionPct);
            });

            // Initial trigger
            updateCompletionPct();
        });
    </script>
</body>
</html>
