<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${entrepreneur.fullName}"/> — Entrepreneur Profile Review | Fight D Fear Admin</title>

    <!-- Bootstrap & Icons & Typography -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy-dark: #0f0d26;
            --navy-primary: #1e1b4b;
            --navy-light: #312e81;
            --rose-primary: #f43f5e;
            --rose-light: #ffe4e6;
            --success-color: #059669;
            --warning-color: #d97706;
            --danger-color: #dc2626;
            --card-bg: #ffffff;
            --page-bg: #f8fafc;
            --border-color: #e2e8f0;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            background-color: var(--page-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
            margin: 0;
            padding-bottom: 90px;
        }

        /* Topbar */
        .admin-topbar {
            background: var(--navy-primary);
            color: white;
            padding: 14px 24px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .admin-topbar .brand {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.15rem;
            font-weight: 700;
        }

        .admin-topbar .brand img {
            height: 32px;
            width: 32px;
            border-radius: 8px;
            object-fit: cover;
        }

        .review-container {
            max-width: 1200px;
            margin: 28px auto 0;
            padding: 0 16px;
        }

        .back-nav {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.92rem;
            text-decoration: none;
            margin-bottom: 20px;
            transition: color 0.2s;
        }

        .back-nav:hover {
            color: var(--navy-primary);
        }

        /* Header Card */
        .header-card {
            background: linear-gradient(135deg, var(--navy-primary) 0%, var(--navy-light) 100%);
            border-radius: 20px;
            padding: 32px;
            color: white;
            box-shadow: 0 12px 30px rgba(30, 27, 75, 0.15);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }

        .header-card::after {
            content: '';
            position: absolute;
            right: -60px;
            top: -60px;
            width: 220px;
            height: 220px;
            background: rgba(244, 63, 94, 0.15);
            border-radius: 50%;
            pointer-events: none;
        }

        .avatar-box {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.25);
            overflow: hidden;
            background: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            flex-shrink: 0;
        }

        .avatar-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .badge-status-lg {
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.82rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-APPROVED { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .status-PENDING_ADMIN_APPROVAL, .status-PENDING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .status-CHANGES_REQUESTED { background: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; }
        .status-PROFILE_INCOMPLETE, .status-REGISTERED { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        .progress-wrap {
            background: rgba(255,255,255,0.15);
            border-radius: 50px;
            height: 10px;
            overflow: hidden;
            margin-top: 8px;
        }

        .progress-bar-fill {
            background: linear-gradient(90deg, #f43f5e, #10b981);
            height: 100%;
            border-radius: 50px;
            transition: width 0.6s ease;
        }

        /* Review Cards */
        .review-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 16px rgba(0,0,0,0.04);
            padding: 24px 28px;
            margin-bottom: 24px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
        }

        .section-header i {
            color: var(--rose-primary);
            font-size: 1.25rem;
        }

        .section-header h3 {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--navy-primary);
            margin: 0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 18px;
        }

        .info-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-field-label {
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
        }

        .info-field-value {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-dark);
            word-break: break-word;
        }

        .empty-text {
            color: var(--text-muted);
            font-style: italic;
            font-size: 0.9rem;
        }

        /* Sticky Action Dock */
        .action-dock {
            position: sticky;
            bottom: 20px;
            background: rgba(30, 27, 75, 0.95);
            backdrop-filter: blur(10px);
            padding: 16px 24px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            z-index: 900;
        }

        .btn-action-approve {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-approve:hover {
            background: #059669;
            color: white;
            transform: translateY(-1px);
        }

        .btn-action-changes {
            background: #f59e0b;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-changes:hover {
            background: #d97706;
            color: white;
            transform: translateY(-1px);
        }

        .btn-action-reject {
            background: #ef4444;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.2s;
        }
        .btn-action-reject:hover {
            background: #dc2626;
            color: white;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

    <!-- Topbar -->
    <header class="admin-topbar">
        <a href="${pageContext.request.contextPath}/admin/pending-entrepreneurs" class="brand">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear">
            <span>Fight D Fear Admin Portal</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <span class="badge bg-light text-dark fw-bold px-3 py-2">Entrepreneur Profile Review</span>
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-outline-light">
                <i class="bi bi-box-arrow-right"></i> Sign Out
            </a>
        </div>
    </header>

    <div class="review-container">

        <!-- Flash messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/admin/pending-entrepreneurs" class="back-nav">
            <i class="bi bi-arrow-left"></i> Back to Entrepreneur Management
        </a>

        <!-- HEADER CARD -->
        <div class="header-card">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="${not empty entrepreneur.profilePhoto}">
                            <img src="${pageContext.request.contextPath}${entrepreneur.profilePhoto}" alt="<c:out value='${entrepreneur.fullName}'/>">
                        </c:when>
                        <c:otherwise>
                            <div class="w-100 h-100 d-flex align-items-center justify-content-center bg-light text-muted">
                                <i class="bi bi-person-circle" style="font-size: 3.5rem; color: #94a3b8;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
<<<<<<< HEAD:src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp
                        <h1 class="h3 fw-bold mb-0 text-white"><c:out value="${entrepreneur.fullName}"/></h1>
                        <c:set var="statusKey" value="${entrepreneur.partnerProfileStatus != null ? entrepreneur.partnerProfileStatus : 'REGISTERED'}"/>
=======
                        <h1 class="h3 fw-bold mb-0 text-white">${trainer.fullName}</h1>
                        <c:if test="${empty statusKey}">
                            <c:set var="statusKey" value="${not empty trainer.partnerProfileStatus ? trainer.partnerProfileStatus.name() : (not empty trainer.verificationStatus ? (trainer.verificationStatus.name() == 'VERIFIED' ? 'APPROVED' : trainer.verificationStatus.name()) : 'PENDING')}"/>
                        </c:if>
>>>>>>> 4ace1291bbe5bd57198372fc588fdaba95947dbd:bin/src/main/webapp/WEB-INF/views/adminFitnessTrainerProfile.jsp
                        <span class="badge-status-lg status-${statusKey}">
                            <i class="bi ${statusKey == 'APPROVED' ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            ${statusKey}
                        </span>
<<<<<<< HEAD:src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp
=======

                        <c:if test="${trainer.suspended}">
                            <span class="badge bg-danger text-white px-3 py-1">SUSPENDED</span>
                        </c:if>
>>>>>>> 4ace1291bbe5bd57198372fc588fdaba95947dbd:bin/src/main/webapp/WEB-INF/views/adminFitnessTrainerProfile.jsp
                    </div>

                    <div class="d-flex flex-wrap gap-4 text-white-50 small mb-3">
                        <div><i class="bi bi-envelope-fill text-white"></i> <a href="mailto:${entrepreneur.email}" class="text-white text-decoration-none"><c:out value="${entrepreneur.email}"/></a></div>
                        <div><i class="bi bi-telephone-fill text-white"></i> <a href="tel:${entrepreneur.phone}" class="text-white text-decoration-none"><c:out value="${entrepreneur.phone}"/></a></div>
                        <div><i class="bi bi-building text-white"></i> <strong>Business:</strong> <c:out value="${not empty entrepreneur.businessName ? entrepreneur.businessName : 'Not specified'}"/></div>
                        <div><i class="bi bi-geo-alt-fill text-white"></i> <c:out value="${not empty entrepreneur.city ? entrepreneur.city : entrepreneur.businessLocation}"/></div>
                    </div>

                    <!-- Profile Completion -->
                    <div class="mt-2" style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold text-white mb-1">
                            <span>Profile Completion</span>
                            <span><c:out value="${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>%</span>
                        </div>
                        <div class="progress-wrap">
                            <c:set var="pctVal" value="${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>
                            <div class="progress-bar-fill" style="width: ${pctVal}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. PERSONAL IDENTITY -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-person-vcard-fill"></i>
                <h3>1. Entrepreneur Personal Identity</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Full Name</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.fullName ? entrepreneur.fullName : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Official Email</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.email ? entrepreneur.email : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Primary Phone</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.phone ? entrepreneur.phone : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">WhatsApp Helpline</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.whatsappNumber ? entrepreneur.whatsappNumber : 'Same as phone'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Date of Birth</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.dob ? entrepreneur.dob : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Gender</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.gender ? entrepreneur.gender : 'Not specified'}"/></span>
                </div>
            </div>
        </div>

        <!-- 2. BUSINESS OVERVIEW -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-briefcase-fill"></i>
                <h3>2. Business & Enterprise Overview</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Business / Venture Name</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessName ? entrepreneur.businessName : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Business Category</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessCategory ? entrepreneur.businessCategory : 'Not specified'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Business Location / Address</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.businessLocation ? entrepreneur.businessLocation : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">City</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.city ? entrepreneur.city : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">State</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.state ? entrepreneur.state : 'Not provided'}"/></span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Postal Pincode</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.pincode ? entrepreneur.pincode : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 3. FINANCIALS & INVESTMENT NEEDED -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-cash-stack"></i>
                <h3>3. Funding Required & Financial Projections</h3>
            </div>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Investment / Capital Needed</span>
                        <div class="h4 fw-bold text-success mb-0 mt-1">₹<c:out value="${entrepreneur.investmentNeeded != null ? entrepreneur.investmentNeeded : 0}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Expected Monthly Revenue</span>
                        <div class="h4 fw-bold text-primary mb-0 mt-1">₹<c:out value="${entrepreneur.expectedMonthlyIncome != null ? entrepreneur.expectedMonthlyIncome : 0}"/></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-3 bg-light rounded-3">
                        <span class="info-field-label">Business Experience</span>
                        <div class="h4 fw-bold text-dark mb-0 mt-1"><c:out value="${entrepreneur.businessExperience != null ? entrepreneur.businessExperience : 0}"/> <small class="fs-6 fw-normal text-muted">Years</small></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. AADHAAR IDENTITY PROOF -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-shield-lock-fill"></i>
                <h3>4. Aadhaar Identity Verification</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">Aadhaar Number (Encrypted / Verified)</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.aadhaarNumber ? entrepreneur.aadhaarNumber : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 5. BUSINESS DESCRIPTION & PITCH -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-journal-text"></i>
                <h3>5. Business Description & Pitch Overview</h3>
            </div>
            <div class="p-3 bg-light rounded-3 text-secondary" style="font-size: 0.95rem; line-height: 1.6;">
                <c:choose>
                    <c:when test="${not empty entrepreneur.businessDescription}">
                        <c:out value="${entrepreneur.businessDescription}"/>
                    </c:when>
                    <c:otherwise>
                        <span class="empty-text">No detailed pitch description provided yet.</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 6. BANK & SETTLEMENT DETAILS -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-bank"></i>
                <h3>6. Payment Settlement & Bank Details</h3>
            </div>
            <div class="info-grid">
                <div class="info-field">
                    <span class="info-field-label">UPI Identifier</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.upiId ? entrepreneur.upiId : 'Not provided'}"/></span>
                </div>
                <div class="info-field" style="grid-column: 1 / -1;">
                    <span class="info-field-label">Bank Account / IFSC Details</span>
                    <span class="info-field-value"><c:out value="${not empty entrepreneur.bankDetails ? entrepreneur.bankDetails : 'Not provided'}"/></span>
                </div>
            </div>
        </div>

        <!-- 7. AUDIT TRAIL & FEEDBACK -->
        <div class="review-card">
            <div class="section-header">
                <i class="bi bi-clipboard-check-fill"></i>
                <h3>7. Verification Audit Trail & Admin Feedback</h3>
            </div>
            <div class="info-grid mb-3">
                <div class="info-field">
                    <span class="info-field-label">Current Status</span>
                    <span class="info-field-value">
                        <span class="badge-status-lg status-${statusKey}">
                            ${statusKey}
                        </span>
                    </span>
                </div>
                <div class="info-field">
                    <span class="info-field-label">Verification Status</span>
                    <span class="info-field-value"><c:out value="${entrepreneur.verificationStatus != null ? entrepreneur.verificationStatus : 'PENDING'}"/></span>
                </div>
            </div>

            <c:if test="${not empty entrepreneur.rejectionReason}">
                <div class="alert alert-danger rounded-3 mt-3">
                    <strong><i class="bi bi-x-octagon-fill me-1"></i> Rejection Reason on Record:</strong>
                    <div class="mt-1"><c:out value="${entrepreneur.rejectionReason}"/></div>
                </div>
            </c:if>

            <c:if test="${not empty entrepreneur.changesRequestedNote}">
                <div class="alert alert-warning rounded-3 mt-3">
                    <strong><i class="bi bi-pencil-square me-1"></i> Changes Requested Note on Record:</strong>
                    <div class="mt-1"><c:out value="${entrepreneur.changesRequestedNote}"/></div>
                </div>
            </c:if>
        </div>

        <!-- STICKY ACTION DOCK -->
        <div class="action-dock">
            <div>
                <span class="small text-white-50 d-block">Admin Decision Workflow</span>
                <strong class="text-white"><c:out value="${entrepreneur.fullName}"/></strong>
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <!-- Approve -->
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/approve" method="post" class="m-0">
                    <button type="submit" class="btn-action-approve" onclick="return confirm('Approve this entrepreneur for platform access?');">
                        <i class="bi bi-check-lg me-1"></i> Approve Entrepreneur
                    </button>
                </form>

                <!-- Request Changes Modal Trigger -->
                <button type="button" class="btn-action-changes" data-bs-toggle="modal" data-bs-target="#requestChangesModal">
                    <i class="bi bi-pencil me-1"></i> Request Changes
                </button>

                <!-- Reject Modal Trigger -->
                <button type="button" class="btn-action-reject" data-bs-toggle="modal" data-bs-target="#rejectModal">
                    <i class="bi bi-x-lg me-1"></i> Reject
                </button>
            </div>
        </div>

    </div>

    <!-- REQUEST CHANGES MODAL -->
    <div class="modal fade" id="requestChangesModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/request-changes" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-warning me-2"></i> Request Profile Changes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide specific feedback explaining what needs to be updated before approval.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Feedback Note</label>
                            <textarea name="note" class="form-control" rows="4" placeholder="e.g., Please enter a valid Aadhaar number and expand your business pitch..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark">Send Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- REJECT MODAL -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${entrepreneur.id}/reject" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger"><i class="bi bi-x-octagon me-2"></i> Reject Application</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="small text-muted">Provide the reason for rejecting this entrepreneur profile.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rejection Reason</label>
                            <textarea name="reason" class="form-control" rows="4" placeholder="e.g., Incomplete documentation or invalid credentials..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger fw-bold">Confirm Rejection</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
