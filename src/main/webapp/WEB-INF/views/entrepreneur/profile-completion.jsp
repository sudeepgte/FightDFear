<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Entrepreneur Profile — Fight D Fear</title>
    <!-- Google Fonts & Bootstrap Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --bg-page: #FFF8FA;
            --bg-card: #FFFFFF;
            --text-plum: #1E1B4B;
            --brand-pink: #F33F5E;
            --brand-pink-hover: #D92545;
            --pink-soft-bg: #FFEBF0;
            --gold-accent: #F59E0B;
            --border-light: #FCE8EB;
            --font-main: 'Outfit', sans-serif;
            --text-gray: #64748B;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--font-main);
            min-height: 100vh;
            background: var(--bg-page);
            color: var(--text-plum);
            display: flex;
            flex-direction: column;
        }

        /* Top Bar */
        .app-header {
            background: var(--bg-card);
            border-bottom: 2px solid var(--gold-accent);
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
            color: var(--text-plum);
            text-decoration: none;
        }

        .header-brand i { color: var(--brand-pink); font-size: 1.3rem; }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn-skip {
            padding: 8px 16px;
            border: 1px solid var(--border-light);
            background: var(--bg-card);
            color: var(--text-plum);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-skip:hover {
            background: var(--pink-soft-bg);
        }

        .btn-header-save {
            padding: 8px 16px;
            background: var(--brand-pink);
            color: #FFFFFF;
            border: none;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-header-save:hover {
            background: var(--brand-pink-hover);
        }

        .main-container {
            flex: 1;
            max-width: 760px;
            width: 100%;
            margin: 20px auto 40px;
            padding: 0 16px;
        }

        /* Profile Completion Progress Card */
        .profile-progress-card {
            background: var(--bg-card);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            padding: 18px 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
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
            color: var(--text-plum);
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
        .badge-approved { background: var(--pink-soft-bg); color: var(--brand-pink); }
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
            background: linear-gradient(90deg, #F43F5E, #FB7185);
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
            background: var(--brand-pink);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 14px rgba(244, 63, 94, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit-verification:hover:not(:disabled) {
            background: var(--brand-pink-hover);
        }

        .btn-submit-verification:disabled {
            background: #CBD5E1;
            cursor: not-allowed;
            box-shadow: none;
            color: #64748B;
        }

        /* Numbered Section Cards */
        .section-card {
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .section-header {
            font-size: 1.05rem;
            font-weight: 800;
            color: var(--text-plum);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-plum);
            margin-bottom: 6px;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            color: var(--text-plum);
            background: #FFFFFF;
            transition: all 0.2s;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--brand-pink);
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
            background: var(--brand-pink);
            color: #FFFFFF;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-bottom-save:hover {
            background: var(--brand-pink-hover);
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
            background: var(--pink-soft-bg);
            border: 1px solid var(--border-light);
            color: var(--brand-pink);
        }
    
        .bg-brand-pink { background-color: var(--brand-pink) !important; color: white !important; }
        .text-brand-pink { color: var(--brand-pink) !important; }
        .bg-soft-pink { background-color: var(--pink-soft-bg) !important; }
        .badge-brand { background-color: var(--pink-soft-bg) !important; color: var(--brand-pink) !important; border: 1px solid var(--border-light); }
        .btn-brand-pink { background-color: var(--brand-pink) !important; color: white !important; border: none; }
        .btn-brand-pink:hover { background-color: var(--brand-pink-hover) !important; color: white !important; }
</style>
</head>
<body>

    <!-- Header with Mobile & Martial Arts Parity Actions -->
    <header class="app-header">
        <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="header-brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="btn-skip">Skip for now</a>
            <button type="button" class="btn-header-save" onclick="document.getElementById('profileForm').submit()">Save Profile</button>
        </div>
    </header>

    <main class="main-container">

        <c:if test="${not empty message}">
            <div class="alert-box alert-success">
                <i class="bi bi-check-circle-fill"></i> ${message}
            </div>
        </c:if>

        <c:if test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
            <div style="background: linear-gradient(135deg, var(--brand-pink) 0%, var(--brand-pink-hover) 100%); border-radius: 16px; padding: 20px; color: white; margin-bottom: 20px; box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25);">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <span style="background: rgba(255,255,255,0.2); color: white; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 50px; text-transform: uppercase; letter-spacing: 0.5px;">Account Verified & Approved</span>
                        <h3 style="font-size: 1.25rem; font-weight: 800; margin: 8px 0 4px; color: white;"><i class="bi bi-patch-check-fill me-1"></i> Your Entrepreneur Dashboard is Unlocked!</h3>
                        <p style="margin: 0; font-size: 0.88rem; color: rgba(255,255,255,0.9);">Admin has verified your identity and business profile. You now have complete access to your live dashboard, pitch decks, and investor meetings.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" style="background: #FFFFFF; color: var(--brand-pink-hover); font-weight: 700; font-size: 0.95rem; padding: 12px 24px; border-radius: 50px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); transition: transform 0.2s;">
                        <i class="bi bi-speedometer2"></i> Open Entrepreneur Dashboard
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Dynamic Profile Completion Progress Card -->
        <div class="profile-progress-card">
            <div class="progress-header">
                <span class="progress-title">Profile Completion: <span id="pctText">${not empty entrepreneur.profileCompletionPct ? entrepreneur.profileCompletionPct : 20}%</span></span>
                <c:choose>
                    <c:when test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
                        <span class="status-badge badge-approved">Approved</span>
                    </c:when>
                    <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'CHANGES_REQUESTED'}">
                        <span class="status-badge badge-changes">Changes Requested</span>
                    </c:when>
                    <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                        <span class="status-badge badge-pending">Under Review</span>
                    </c:when>
                    <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'REJECTED'}">
                        <span class="status-badge badge-rejected">Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge badge-registered">Registered</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="progress-bar-container">
                <div class="progress-bar-fill" style="width: <c:out value='${not empty entrepreneur.profileCompletionPct ? entrepreneur.profileCompletionPct : 20}'/>%;"></div>
            </div>
            <p style="font-size: 0.8rem; color: var(--text-gray);">
                Complete all required sections below. Once your profile reaches required completeness, you can submit for Admin verification.
            </p>
        </div>

        <!-- Admin Feedback Banner (for Rejection / Notes) -->
        <c:if test="${not empty entrepreneur and not empty entrepreneur.rejectionReason}">
            <div class="feedback-banner">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="feedback-content">
                    <h4>Admin Feedback</h4>
                    <p><c:out value="${entrepreneur.rejectionReason}"/></p>
                </div>
            </div>
        </c:if>

        <!-- Submit for Verification Bar -->
        <div class="submit-bar">
            <c:choose>
                <c:when test="${not empty entrepreneur and (entrepreneur.partnerProfileStatus == 'APPROVED' or entrepreneur.verificationStatus == 'VERIFIED')}">
                    <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="btn-submit-verification" style="background:var(--brand-pink); color:white; text-decoration:none; display:flex; align-items:center; justify-content:center; gap:8px;">
                        <i class="bi bi-patch-check-fill"></i> Profile Verified — Open Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/entrepreneur/submit-verification" method="post">
                        <button type="submit" class="btn-submit-verification" 
                                <c:if test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${not empty entrepreneur and entrepreneur.partnerProfileStatus == 'PENDING_ADMIN_APPROVAL'}">
                                    <i class="bi bi-clock-history"></i> Submitted — Pending Admin Review
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

        <!-- Section Forms Container -->
        <form id="profileForm" action="${pageContext.request.contextPath}/entrepreneur/profile-completion" method="post" enctype="multipart/form-data">
            
            <!-- Section 1: Business & Identity -->
            <div class="section-card">
                <div class="section-header">1. Business identity & basic info</div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>1.1 Entrepreneur full name *</label>
                        <input type="text" name="fullName" class="form-input" value="<c:out value='${entrepreneur.fullName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label>1.2 Business / Venture name *</label>
                        <input type="text" name="businessName" class="form-input" value="<c:out value='${entrepreneur.businessName}'/>" placeholder="e.g. Lotus Crafts & Handloom" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.3 Business category *</label>
                        <select name="businessCategory" class="form-select">
                            <option value="Tea Shop" <c:if test="${entrepreneur.businessCategory == 'Tea Shop'}">selected</c:if>>Tea / Coffee Shop</option>
                            <option value="Food & Catering" <c:if test="${entrepreneur.businessCategory == 'Food & Catering'}">selected</c:if>>Food & Catering</option>
                            <option value="Apparel & Fashion" <c:if test="${entrepreneur.businessCategory == 'Apparel & Fashion'}">selected</c:if>>Apparel & Fashion</option>
                            <option value="Beauty & Wellness" <c:if test="${entrepreneur.businessCategory == 'Beauty & Wellness'}">selected</c:if>>Beauty & Wellness</option>
                            <option value="Handicrafts & Arts" <c:if test="${entrepreneur.businessCategory == 'Handicrafts & Arts'}">selected</c:if>>Handicrafts & Arts</option>
                            <option value="Education & Tutoring" <c:if test="${entrepreneur.businessCategory == 'Education & Tutoring'}">selected</c:if>>Education & Tutoring</option>
                            <option value="Tech & Digital Services" <c:if test="${entrepreneur.businessCategory == 'Tech & Digital Services'}">selected</c:if>>Tech & Digital Services</option>
                            <option value="Retail & E-commerce" <c:if test="${entrepreneur.businessCategory == 'Retail & E-commerce'}">selected</c:if>>Retail & E-commerce</option>
                            <option value="Other" <c:if test="${entrepreneur.businessCategory == 'Other'}">selected</c:if>>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>1.4 Designation</label>
                        <input type="text" name="designation" class="form-input" value="<c:out value='${entrepreneur.designation}'/>" placeholder="e.g. Founder / Proprietor">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>1.5 Mobile number *</label>
                        <input type="tel" name="phone" class="form-input" value="<c:out value='${entrepreneur.phone}'/>" maxlength="10" required>
                    </div>
                    <div class="form-group">
                        <label>1.6 WhatsApp number</label>
                        <input type="tel" name="whatsappNumber" class="form-input" value="<c:out value='${entrepreneur.whatsappNumber}'/>" placeholder="10-digit WhatsApp number" maxlength="10">
                    </div>
                </div>
            </div>

            <!-- Section 2: Location -->
            <div class="section-card">
                <div class="section-header">2. Location & operations</div>
                <div class="form-group">
                    <label>2.1 Street address / Landmark *</label>
                    <input type="text" name="businessLocation" class="form-input" value="<c:out value='${entrepreneur.businessLocation}'/>" placeholder="Shop/Office No, Building, Street" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>2.2 City *</label>
                        <input type="text" name="city" class="form-input" value="<c:out value='${entrepreneur.city}'/>" placeholder="City">
                    </div>
                    <div class="form-group">
                        <label>2.3 State *</label>
                        <input type="text" name="state" class="form-input" value="<c:out value='${entrepreneur.state}'/>" placeholder="State">
                    </div>
                </div>
                <div class="form-group">
                    <label>2.4 Pincode *</label>
                    <input type="text" name="pincode" class="form-input" value="<c:out value='${entrepreneur.pincode}'/>" placeholder="6-digit Pincode" maxlength="6">
                </div>
            </div>

            <!-- Section 3: Financial & Funding -->
            <div class="section-card">
                <div class="section-header">3. Financial & investment details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label>3.1 Funding / Investment required (₹) *</label>
                        <input type="number" step="1000" name="investmentNeeded" class="form-input" value="<c:out value='${entrepreneur.investmentNeeded}'/>" placeholder="e.g. 250000" required>
                    </div>
                    <div class="form-group">
                        <label>3.2 Expected monthly revenue (₹) *</label>
                        <input type="number" step="1000" name="expectedMonthlyIncome" class="form-input" value="<c:out value='${entrepreneur.expectedMonthlyIncome}'/>" placeholder="e.g. 50000" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>3.3 Business experience (Years) *</label>
                    <input type="number" name="businessExperience" class="form-input" value="<c:out value='${entrepreneur.businessExperience}'/>" placeholder="e.g. 3" required>
                </div>
            </div>

            <!-- Section 4: Identity Verification -->
            <div class="section-card">
                <div class="section-header">4. Identity & legal verification</div>
                <div class="form-group">
                    <label>4.1 Aadhaar number *</label>
                    <input type="text" name="aadhaarNumber" class="form-input" value="<c:out value='${entrepreneur.aadhaarNumber}'/>" placeholder="12-digit Aadhaar" maxlength="12" required>
                </div>
            </div>

            <!-- Section 5: Business Overview & Pitch Deck -->
            <div class="section-card">
                <div class="section-header">5. Business overview & pitch deck</div>
                <div class="form-group">
                    <label>5.1 Business description & vision *</label>
                    <textarea name="businessDescription" class="form-textarea" rows="4" placeholder="Describe your product/service, target customers, and expansion goals..."><c:out value="${entrepreneur.businessDescription}"/></textarea>
                </div>

                <div class="form-group">
                    <label>5.2 Entrepreneur Photo / Brand Logo</label>
                    <input type="file" name="profilePhotoFile" class="form-input" accept="image/*">
                </div>

                <div class="form-group">
                    <label>5.3 Pitch Deck Document (PDF / Image)</label>
                    <input type="file" name="pitchDeckFile" class="form-input" accept=".pdf,image/*">
                </div>

                <div class="form-group">
                    <label>5.4 Business / Product Gallery Photos</label>
                    <input type="file" name="businessPhotosFiles" class="form-input" accept="image/*" multiple>
                </div>
            </div>

            <!-- Section 6: Payout Details -->
            <div class="section-card">
                <div class="section-header">6. Payout & bank details</div>
                <div class="form-group">
                    <label>6.1 UPI ID (for direct funding / payouts)</label>
                    <input type="text" name="upiId" class="form-input" value="<c:out value='${entrepreneur.upiId}'/>" placeholder="name@upi">
                </div>
                <div class="form-group">
                    <label>6.2 Bank account details</label>
                    <textarea name="bankDetails" class="form-textarea" rows="2" placeholder="Account Name, Number, Bank, IFSC Code"><c:out value="${entrepreneur.bankDetails}"/></textarea>
                </div>
            </div>

            <div class="bottom-actions">
                <button type="submit" class="btn-bottom-save">Save Profile Details</button>
            </div>
        </form>

    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.querySelector("form[action*='profile-completion']");
            if (!form) return;

            function updateCompletionPct() {
                let pct = 0;
                const fullName = form.querySelector("[name='fullName']")?.value.trim();
                const phone = form.querySelector("[name='phone']")?.value.trim();
                const businessName = form.querySelector("[name='businessName']")?.value.trim();
                const businessCategory = form.querySelector("[name='businessCategory']")?.value.trim();
                const businessLocation = form.querySelector("[name='businessLocation']")?.value.trim();
                const investmentNeeded = parseFloat(form.querySelector("[name='investmentNeeded']")?.value);
                const expectedMonthlyIncome = parseFloat(form.querySelector("[name='expectedMonthlyIncome']")?.value);
                const businessExperience = form.querySelector("[name='businessExperience']")?.value;
                const aadhaarNumber = form.querySelector("[name='aadhaarNumber']")?.value.trim();
                const businessDescription = form.querySelector("[name='businessDescription']")?.value.trim();
                const upiId = form.querySelector("[name='upiId']")?.value.trim();
                const bankDetails = form.querySelector("[name='bankDetails']")?.value.trim();

                if (fullName) pct += 7;
                if (phone) pct += 13; // Basic contact complete (20%)

                if (businessName) pct += 7;
                if (businessCategory) pct += 7;
                if (businessLocation) pct += 6; // Business info complete (+20%)

                if (!isNaN(investmentNeeded) && investmentNeeded > 0) pct += 7;
                if (!isNaN(expectedMonthlyIncome) && expectedMonthlyIncome > 0) pct += 7;
                if (businessExperience !== "" && businessExperience !== null) pct += 6; // Financials complete (+20%)

                if (aadhaarNumber && aadhaarNumber.length >= 12) pct += 20; // Aadhaar complete (+20%)

                if (businessDescription) pct += 10;
                if (upiId || bankDetails) pct += 10; // Pitch & settlement complete (+20%)

                pct = Math.min(100, pct);

                const pctText = document.getElementById("pctText");
                const progressFill = document.querySelector(".progress-bar-fill");
                if (pctText) pctText.textContent = pct + "%";
                if (progressFill) progressFill.style.width = pct + "%";
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
