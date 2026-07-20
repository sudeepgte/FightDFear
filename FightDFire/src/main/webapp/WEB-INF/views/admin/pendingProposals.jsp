<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investment Platform Management — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --navy-light: #312e81;
            --primary: #f43f5e;
            --bg-light: #f4f6fa;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
        }

        .container {
            max-width: 1000px;
            margin-top: 40px;
        }

        .panel {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            margin-bottom: 30px;
        }

        .nav-tabs {
            border-bottom: 2px solid #e2e8f0;
        }

        .nav-link {
            font-weight: 600;
            color: #64748b;
            border: none;
            padding: 12px 20px;
            border-radius: 0;
            transition: all 0.3s;
        }

        .nav-link.active {
            color: var(--primary) !important;
            border-bottom: 3px solid var(--primary) !important;
            background-color: transparent !important;
        }

        .btn-approve {
            background-color: #16a34a;
            color: white;
            border: none;
            border-radius: 30px;
            padding: 6px 18px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all 0.3s;
        }

        .btn-approve:hover {
            background-color: #15803d;
            transform: translateY(-1px);
        }

        .btn-reject {
            background-color: #dc2626;
            color: white;
            border: none;
            border-radius: 30px;
            padding: 6px 18px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all 0.3s;
        }

        .btn-reject:hover {
            background-color: #b91c1c;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold" style="color: var(--navy-dark);"><i class="bi bi-shield-check-fill text-primary"></i> Platform Verification Desk</h2>
            <p class="text-muted">Review pending business projects, entrepreneur verifications, and investor profiles.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" class="btn btn-outline-secondary rounded-pill btn-sm">
            <i class="bi bi-chevron-left"></i> Admin Dashboard
        </a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
            <i class="bi bi-check-circle-fill"></i> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Summary Stats Bar -->
    <div class="row g-3 mb-4">
        <div class="col-md-4 col-sm-6">
            <div class="d-flex align-items-center p-3" style="background:white; border-radius:15px; border:1px solid rgba(0,0,0,0.04); box-shadow: 0 4px 6px rgba(0,0,0,0.01);">
                <div class="rounded-circle d-flex align-items-center justify-content-center bg-primary-subtle text-primary fs-3 me-3" style="width:50px; height:50px;">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <h5 class="fw-bold m-0">${allEntrepreneurs.size()}</h5>
                    <span class="text-muted small">Total Entrepreneurs</span>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-sm-6">
            <div class="d-flex align-items-center p-3" style="background:white; border-radius:15px; border:1px solid rgba(0,0,0,0.04); box-shadow: 0 4px 6px rgba(0,0,0,0.01);">
                <div class="rounded-circle d-flex align-items-center justify-content-center bg-info-subtle text-info fs-3 me-3" style="width:50px; height:50px;">
                    <i class="bi bi-person-badge-fill"></i>
                </div>
                <div>
                    <h5 class="fw-bold m-0">${allInvestors.size()}</h5>
                    <span class="text-muted small">Total Investors</span>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-sm-12">
            <div class="d-flex align-items-center p-3" style="background:white; border-radius:15px; border:1px solid rgba(0,0,0,0.04); box-shadow: 0 4px 6px rgba(0,0,0,0.01);">
                <div class="rounded-circle d-flex align-items-center justify-content-center bg-success-subtle text-success fs-3 me-3" style="width:50px; height:50px;">
                    <i class="bi bi-file-post"></i>
                </div>
                <div>
                    <h5 class="fw-bold m-0">${allProposals.size()}</h5>
                    <span class="text-muted small">Total Proposals Pitch</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="proposals-tab" data-bs-toggle="tab" data-bs-target="#proposals" type="button" role="tab">
                Proposals Directory (${allProposals.size()})
                <c:if test="${pendingProposalsCount > 0}">
                    <span class="badge bg-warning text-dark rounded-pill ms-1">${pendingProposalsCount}</span>
                </c:if>
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="entrepreneurs-tab" data-bs-toggle="tab" data-bs-target="#entrepreneurs" type="button" role="tab">
                Entrepreneurs Directory (${allEntrepreneurs.size()})
                <c:if test="${pendingEntCount > 0}">
                    <span class="badge bg-warning text-dark rounded-pill ms-1">${pendingEntCount}</span>
                </c:if>
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="investors-tab" data-bs-toggle="tab" data-bs-target="#investors" type="button" role="tab">
                Investors Directory (${allInvestors.size()})
                <c:if test="${pendingInvCount > 0}">
                    <span class="badge bg-warning text-dark rounded-pill ms-1">${pendingInvCount}</span>
                </c:if>
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="meetings-tab" data-bs-toggle="tab" data-bs-target="#meetings" type="button" role="tab">
                Meetings Log (${allMeetings.size()})
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="investments-tab" data-bs-toggle="tab" data-bs-target="#investments" type="button" role="tab">
                Investment Ledger (${allInvestments.size()})
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="qna-tab" data-bs-toggle="tab" data-bs-target="#qna" type="button" role="tab">
                Investor Q&As (${allQuestions.size()})
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="chats-tab" data-bs-toggle="tab" data-bs-target="#chats" type="button" role="tab">
                Chat Transcripts (${allChats.size()})
            </button>
        </li>
    </ul>

    <!-- Tab Contents -->
    <div class="tab-content" id="adminTabsContent">
        
        <!-- Tab 1: Proposals Directory -->
        <div class="tab-pane fade show active" id="proposals" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Proposal</th>
                                <th>Entrepreneur</th>
                                <th>Funding Goal</th>
                                <th>Upgrade</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${allProposals}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-navy">${p.title}</div>
                                        <div class="text-muted small">${p.category} | ${p.location}</div>
                                    </td>
                                    <td>${p.entrepreneur.fullName}</td>
                                    <td>
                                        <strong>₹${p.fundingNeeded}</strong>
                                        <div class="text-muted small">₹${p.amountRaised} raised</div>
                                    </td>
                                    <td>
                                        <c:if test="${p.premium}">
                                            <span class="badge bg-warning text-dark small"><i class="bi bi-award-fill"></i> Premium</span>
                                        </c:if>
                                        <c:if test="${p.featured}">
                                            <span class="badge bg-info text-dark small"><i class="bi bi-star-fill"></i> Featured</span>
                                        </c:if>
                                        <c:if test="${not p.premium and not p.featured}">
                                            <span class="text-muted small">Standard</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'VERIFIED'}">
                                                <span class="badge bg-success rounded-pill px-2 py-1"><i class="bi bi-check-circle"></i> Verified</span>
                                            </c:when>
                                            <c:when test="${p.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1"><i class="bi bi-hourglass-split"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger rounded-pill px-2 py-1"><i class="bi bi-x-circle"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'PENDING'}">
                                                <div class="d-flex gap-2">
                                                    <form action="${pageContext.request.contextPath}/admin/proposals/${p.id}/approve" method="post">
                                                        <button type="submit" class="btn btn-approve btn-sm">Approve</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/proposals/${p.id}/reject" method="post">
                                                        <button type="submit" class="btn btn-reject btn-sm">Reject</button>
                                                    </form>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">Processed</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allProposals}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No proposals submitted yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 2: Entrepreneurs Directory -->
        <div class="tab-pane fade" id="entrepreneurs" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Name / Email</th>
                                <th>Aadhaar Number</th>
                                <th>Experience</th>
                                <th>Verification Fee</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${allEntrepreneurs}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-navy">${e.fullName}</div>
                                        <div class="text-muted small">${e.email} | ${e.phone}</div>
                                    </td>
                                    <td>
                                        ${e.aadhaarNumber}
                                        <c:if test="${not empty e.aadhaarDocPath}">
                                            <div class="mt-1">
                                                <a href="${pageContext.request.contextPath}${e.aadhaarDocPath}" target="_blank" class="btn btn-outline-secondary btn-xs rounded-pill px-2 py-0" style="font-size:0.75rem;">
                                                    <i class="bi bi-file-earmark-arrow-down"></i> View ID Document
                                                </a>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>${e.businessExperience} Years</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.verificationFeePaid}">
                                                 <span class="badge bg-success-subtle text-success px-2 py-1"><i class="bi bi-credit-card-fill"></i> Paid (₹499)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary px-2 py-1">Unpaid</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.verificationStatus == 'VERIFIED'}">
                                                <span class="badge bg-success rounded-pill px-2 py-1"><i class="bi bi-check-circle"></i> Verified</span>
                                            </c:when>
                                            <c:when test="${e.verificationStatus == 'PENDING'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1"><i class="bi bi-hourglass-split"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger rounded-pill px-2 py-1"><i class="bi bi-x-circle"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column gap-2">
                                            <c:if test="${e.verificationStatus == 'PENDING'}">
                                                <div class="d-flex gap-1">
                                                    <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/approve" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-approve btn-xs" style="font-size:0.75rem; padding: 3px 10px;">Verify</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/entrepreneurs/${e.id}/reject" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-reject btn-xs" style="font-size:0.75rem; padding: 3px 10px;">Reject</button>
                                                    </form>
                                                </div>
                                            </c:if>
                                            <button class="btn btn-outline-primary btn-xs rounded-pill w-100" style="font-size:0.75rem; padding: 3px 10px;" data-bs-toggle="modal" data-bs-target="#activityModalEnt-${e.id}">
                                                <i class="bi bi-activity"></i> View Activity
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allEntrepreneurs}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No entrepreneurs registered yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 3: Investors Directory -->
        <div class="tab-pane fade" id="investors" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Name / Company</th>
                                <th>Email / Phone</th>
                                <th>Budget Range</th>
                                <th>Subscription</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="i" items="${allInvestors}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-navy">${i.fullName}</div>
                                        <div class="text-muted small">${i.companyName}</div>
                                    </td>
                                    <td>
                                        ${i.email} | ${i.phone}
                                        <c:if test="${not empty i.verificationDocuments}">
                                            <div class="mt-1">
                                                <a href="${pageContext.request.contextPath}${i.verificationDocuments}" target="_blank" class="btn btn-outline-secondary btn-xs rounded-pill px-2 py-0" style="font-size:0.75rem;">
                                                    <i class="bi bi-file-earmark-arrow-down"></i> View Doc
                                                </a>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>${i.budgetRange}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.subscribed}">
                                                 <span class="badge bg-success-subtle text-success px-2 py-1"><i class="bi bi-gem"></i> Premium (₹1999)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary px-2 py-1">Basic</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${i.verificationStatus == 'VERIFIED'}">
                                                <span class="badge bg-success rounded-pill px-2 py-1"><i class="bi bi-check-circle"></i> Verified</span>
                                            </c:when>
                                            <c:when test="${i.verificationStatus == 'PENDING'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1"><i class="bi bi-hourglass-split"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger rounded-pill px-2 py-1"><i class="bi bi-x-circle"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column gap-2">
                                            <c:if test="${i.verificationStatus == 'PENDING'}">
                                                <div class="d-flex gap-1">
                                                    <form action="${pageContext.request.contextPath}/admin/investors/${i.id}/approve" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-approve btn-xs" style="font-size:0.75rem; padding: 3px 10px;">Verify</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/investors/${i.id}/reject" method="post" class="d-inline">
                                                        <button type="submit" class="btn btn-reject btn-xs" style="font-size:0.75rem; padding: 3px 10px;">Reject</button>
                                                    </form>
                                                </div>
                                            </c:if>
                                            <button class="btn btn-outline-primary btn-xs rounded-pill w-100" style="font-size:0.75rem; padding: 3px 10px;" data-bs-toggle="modal" data-bs-target="#activityModalInv-${i.id}">
                                                <i class="bi bi-activity"></i> View Activity
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allInvestors}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No investors registered yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 4: Meetings Log -->
        <div class="tab-pane fade" id="meetings" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Proposal Title</th>
                                <th>Entrepreneur</th>
                                <th>Investor</th>
                                <th>Meeting Time</th>
                                <th>Location / Link</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${allMeetings}">
                                <tr>
                                    <td><div class="fw-bold text-navy">${m.proposal.title}</div></td>
                                    <td>${m.proposal.entrepreneur.fullName}</td>
                                    <td>${m.investor.fullName} (${m.investor.companyName})</td>
                                    <td><strong>${m.meetingTime}</strong></td>
                                    <td><span class="text-truncate d-inline-block" style="max-width:180px;" title="${m.location}">${m.location}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.status == 'ACCEPTED'}">
                                                <span class="badge bg-success rounded-pill px-2 py-1"><i class="bi bi-calendar-check"></i> Accepted</span>
                                            </c:when>
                                            <c:when test="${m.status == 'REJECTED'}">
                                                <span class="badge bg-danger rounded-pill px-2 py-1"><i class="bi bi-calendar-x"></i> Declined</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark rounded-pill px-2 py-1"><i class="bi bi-calendar-range"></i> Pending Reply</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allMeetings}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No consultation meetings requested yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 5: Investment Ledger -->
        <div class="tab-pane fade" id="investments" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Date / ID</th>
                                <th>Proposal Title</th>
                                <th>Entrepreneur</th>
                                <th>Investor</th>
                                <th>Funding Amount</th>
                                <th>Platform Commission</th>
                                <th>Status / Gateway Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inv" items="${allInvestments}">
                                <tr>
                                    <td>
                                        <span class="text-muted small">#${inv.id}</span>
                                    </td>
                                    <td><div class="fw-bold text-navy">${inv.proposal.title}</div></td>
                                    <td>${inv.proposal.entrepreneur.fullName}</td>
                                    <td>${inv.investor.fullName} (${inv.investor.companyName})</td>
                                    <td><strong class="text-success">₹${inv.amount}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inv.commissionPaid}">
                                                <span class="badge bg-success-subtle text-success px-2 py-1"><i class="bi bi-check-circle-fill"></i> Paid (₹${(inv.releasedAmount != null ? inv.releasedAmount : inv.amount) * 0.02})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger px-2 py-1"><i class="bi bi-exclamation-circle-fill"></i> Pending (₹${(inv.releasedAmount != null ? inv.releasedAmount : inv.amount) * 0.02})</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inv.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark mb-1 d-block text-center" style="max-width: 140px;"><i class="bi bi-hourglass-split"></i> Held in Gateway</span>
                                                <form action="${pageContext.request.contextPath}/admin/investments/${inv.id}/release" method="post" class="d-flex flex-column gap-1 align-items-center">
                                                    <div class="input-group input-group-sm" style="max-width: 140px;">
                                                        <span class="input-group-text px-2" style="font-size:0.75rem; padding: 2px 5px;">₹</span>
                                                        <input type="number" name="releasedAmount" class="form-control px-2" value="${inv.amount}" min="0" max="${inv.amount}" step="1" required style="font-size:0.75rem; height: 26px; padding: 2px 5px;">
                                                    </div>
                                                    <button type="submit" class="btn btn-approve btn-xs w-100" style="font-size:0.75rem; padding: 3px 10px; max-width: 140px;">Release Transfer</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success text-white d-block text-center mb-1" style="max-width: 140px;"><i class="bi bi-check-circle-fill"></i> Released</span>
                                                <div class="small text-muted" style="font-size:0.7rem; line-height: 1.2; text-align: left; max-width: 140px; margin: 0 auto;">
                                                    Released: <strong>₹${inv.releasedAmount != null ? inv.releasedAmount : inv.amount}</strong><br>
                                                    <c:if test="${inv.adminAmount != null && inv.adminAmount > 0}">
                                                        Retained: <strong class="text-danger">₹${inv.adminAmount}</strong>
                                                    </c:if>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allInvestments}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">No funding transactions completed yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 6: Investor Q&As -->
        <div class="tab-pane fade" id="qna" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Proposal</th>
                                <th>Investor</th>
                                <th>Question</th>
                                <th>Entrepreneur Reply</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="q" items="${allQuestions}">
                                <tr>
                                    <td><div class="fw-bold text-navy">${q.proposal.title}</div></td>
                                    <td>${q.investor.fullName} (${q.investor.companyName})</td>
                                    <td><span class="text-secondary">"${q.question}"</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty q.answer}">
                                                <span class="text-success fw-semibold">"${q.answer}"</span>
                                            </c:when>
                                            <c:otherwise>
                                                <em class="text-muted">Awaiting response...</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty q.answer}">
                                                <span class="badge bg-success rounded-pill px-2">Replied</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark rounded-pill px-2">Unanswered</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allQuestions}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">No Q&A interactions logged.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Tab 7: Chat Transcripts -->
        <div class="tab-pane fade" id="chats" role="tabpanel">
            <div class="panel">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Time / Date</th>
                                <th>Conversation</th>
                                <th>Sender</th>
                                <th>Message</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="chat" items="${allChats}">
                                <tr>
                                    <td class="small text-muted" style="white-space:nowrap;">
                                        ${chat.timestamp}
                                    </td>
                                    <td>
                                        <div class="fw-bold text-navy" style="font-size:0.85rem;">
                                            👩‍💼 ${chat.proposal.entrepreneur.fullName} (Pitch: "${chat.proposal.title}")
                                        </div>
                                        <div class="text-secondary small">
                                            💼 Investor: ${chat.investor.fullName} (${chat.investor.companyName})
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${chat.senderRole == 'INVESTOR'}">
                                                <span class="badge bg-info text-dark rounded-pill px-2">Investor</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary rounded-pill px-2">Entrepreneur</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="font-size:0.9rem; max-width:400px; word-wrap: break-word;">"${chat.message}"</div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty allChats}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">No chat messages exchanged yet.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

    <!-- Entrepreneur Activity Modals -->
    <c:forEach var="e" items="${allEntrepreneurs}">
        <div class="modal fade" id="activityModalEnt-${e.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content border-0 shadow-lg" style="border-radius:20px;">
                    <div class="modal-header bg-dark text-white border-0 py-3" style="border-top-left-radius:20px; border-top-right-radius:20px;">
                        <h5 class="modal-title fw-bold"><i class="bi bi-activity"></i> Activity Audit Feed — ${e.fullName}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        
                        <!-- Section 1: Proposals -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-file-earmark-post-fill"></i> Submitted Business Proposals</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasProposals" value="false" />
                            <c:forEach var="p" items="${allProposals}">
                                <c:if test="${p.entrepreneur.id == e.id}">
                                    <c:set var="hasProposals" value="true" />
                                    <li class="list-group-item d-flex justify-content-between align-items-center py-2 border-0 border-bottom">
                                        <div>
                                            <strong class="text-navy">${p.title}</strong>
                                            <div class="text-muted small">${p.category} | ${p.location}</div>
                                        </div>
                                        <div>
                                            <span class="badge bg-secondary-subtle text-secondary small">Goal: ₹${p.fundingNeeded}</span>
                                            <span class="badge bg-success-subtle text-success small">Raised: ₹${p.amountRaised}</span>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasProposals}">
                                <li class="list-group-item text-center text-muted small py-3">No proposals submitted.</li>
                            </c:if>
                        </ul>

                        <!-- Section 2: Meetings -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-calendar-check-fill"></i> Consultation & Interview Meetings</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasMeetings" value="false" />
                            <c:forEach var="m" items="${allMeetings}">
                                <c:if test="${m.proposal.entrepreneur.id == e.id}">
                                    <c:set var="hasMeetings" value="true" />
                                    <li class="list-group-item py-2 border-0 border-bottom">
                                        <div class="d-flex justify-content-between">
                                            <strong>Meeting with Investor ${m.investor.fullName}</strong>
                                            <span class="badge bg-info-subtle text-info">${m.status}</span>
                                        </div>
                                        <div class="text-secondary small">Time: ${m.meetingTime} | Location: ${m.location}</div>
                                        <div class="text-muted small">Notes: "${m.notes}"</div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasMeetings}">
                                <li class="list-group-item text-center text-muted small py-3">No meetings scheduled.</li>
                            </c:if>
                        </ul>

                        <!-- Section 3: Q&A Questions -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-question-square-fill"></i> Questions & Inquiries</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasQuestions" value="false" />
                            <c:forEach var="q" items="${allQuestions}">
                                <c:if test="${q.proposal.entrepreneur.id == e.id}">
                                    <c:set var="hasQuestions" value="true" />
                                    <li class="list-group-item py-2 border-0 border-bottom">
                                        <div class="fw-bold text-navy small">Question by ${q.investor.fullName} (Pitch: "${q.proposal.title}"):</div>
                                        <div class="text-secondary small mb-1">"${q.question}"</div>
                                        <div class="ps-2 border-start border-success">
                                            <span class="text-success small fw-semibold">Answer:</span>
                                            <span class="text-secondary small">
                                                <c:choose>
                                                    <c:when test="${not empty q.answer}">"${q.answer}"</c:when>
                                                    <c:otherwise><em>Awaiting response...</em></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasQuestions}">
                                <li class="list-group-item text-center text-muted small py-3">No questions asked.</li>
                            </c:if>
                        </ul>

                        <!-- Section 4: Chat messages -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-chat-dots-fill"></i> Direct Chat History Logs</h6>
                        <div style="max-height: 250px; overflow-y: auto; background:#f8f9fa; padding:15px; border-radius:10px;">
                            <c:set var="hasChats" value="false" />
                            <c:forEach var="chat" items="${allChats}">
                                <c:if test="${chat.proposal.entrepreneur.id == e.id}">
                                    <c:set var="hasChats" value="true" />
                                    <div class="mb-2 p-2 rounded" style="background:${chat.senderRole == 'INVESTOR' ? '#e2f0d9' : '#fff'}; border: 1px solid rgba(0,0,0,0.05); font-size:0.8rem;">
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span><strong>${chat.senderRole == 'INVESTOR' ? 'Investor' : 'Entrepreneur'}</strong> (${chat.senderRole == 'INVESTOR' ? chat.investor.fullName : e.fullName})</span>
                                            <span>${chat.timestamp}</span>
                                        </div>
                                        <div class="text-dark">"${chat.message}"</div>
                                        <div class="text-muted small mt-1" style="font-size:0.7rem;">Topic: "${chat.proposal.title}"</div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasChats}">
                                <div class="text-center text-muted small py-3">No chat messages sent.</div>
                            </c:if>
                        </div>

                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Investor Activity Modals -->
    <c:forEach var="i" items="${allInvestors}">
        <div class="modal fade" id="activityModalInv-${i.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content border-0 shadow-lg" style="border-radius:20px;">
                    <div class="modal-header bg-dark text-white border-0 py-3" style="border-top-left-radius:20px; border-top-right-radius:20px;">
                        <h5 class="modal-title fw-bold"><i class="bi bi-activity"></i> Activity Audit Feed — ${i.fullName}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        
                        <!-- Section 1: Investments -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-cash-stack"></i> Investments Ledger</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasInvestments" value="false" />
                            <c:forEach var="inv" items="${allInvestments}">
                                <c:if test="${inv.investor.id == i.id}">
                                    <c:set var="hasInvestments" value="true" />
                                    <li class="list-group-item d-flex justify-content-between align-items-center py-2 border-0 border-bottom">
                                        <div>
                                            <strong class="text-success">Invested ₹${inv.amount}</strong>
                                            <div class="text-muted small">In Pitch: "${inv.proposal.title}" (Entrepreneur: ${inv.proposal.entrepreneur.fullName})</div>
                                        </div>
                                        <div>
                                            <span class="badge bg-secondary-subtle text-secondary small">Status: ${inv.status}</span>
                                            <span class="badge ${inv.commissionPaid ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} small">
                                                Commission: ${inv.commissionPaid ? 'Paid' : 'Pending'}
                                            </span>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasInvestments}">
                                <li class="list-group-item text-center text-muted small py-3">No investments completed.</li>
                            </c:if>
                        </ul>

                        <!-- Section 2: Meetings -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-calendar-check-fill"></i> Requested Meetings Log</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasMeetings" value="false" />
                            <c:forEach var="m" items="${allMeetings}">
                                <c:if test="${m.investor.id == i.id}">
                                    <c:set var="hasMeetings" value="true" />
                                    <li class="list-group-item py-2 border-0 border-bottom">
                                        <div class="d-flex justify-content-between">
                                            <strong>Meeting with Entrepreneur ${m.proposal.entrepreneur.fullName}</strong>
                                            <span class="badge bg-info-subtle text-info">${m.status}</span>
                                        </div>
                                        <div class="text-secondary small">Time: ${m.meetingTime} | Location: ${m.location}</div>
                                        <div class="text-muted small">Notes: "${m.notes}"</div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasMeetings}">
                                <li class="list-group-item text-center text-muted small py-3">No meetings scheduled.</li>
                            </c:if>
                        </ul>

                        <!-- Section 3: Q&A Questions -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-question-square-fill"></i> Submitted Inquiries (Q&A)</h6>
                        <ul class="list-group mb-4">
                            <c:set var="hasQuestions" value="false" />
                            <c:forEach var="q" items="${allQuestions}">
                                <c:if test="${q.investor.id == i.id}">
                                    <c:set var="hasQuestions" value="true" />
                                    <li class="list-group-item py-2 border-0 border-bottom">
                                        <div class="fw-bold text-navy small">Question on Pitch "${q.proposal.title}" (Entrepreneur: ${q.proposal.entrepreneur.fullName}):</div>
                                        <div class="text-secondary small mb-1">"${q.question}"</div>
                                        <div class="ps-2 border-start border-success">
                                            <span class="text-success small fw-semibold">Answer:</span>
                                            <span class="text-secondary small">
                                                <c:choose>
                                                    <c:when test="${not empty q.answer}">"${q.answer}"</c:when>
                                                    <c:otherwise><em>Awaiting response...</em></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasQuestions}">
                                <li class="list-group-item text-center text-muted small py-3">No questions asked.</li>
                            </c:if>
                        </ul>

                        <!-- Section 4: Chat messages -->
                        <h6 class="fw-bold border-bottom pb-2 mb-3" style="color:var(--navy-dark);"><i class="bi bi-chat-dots-fill"></i> Direct Chat History Logs</h6>
                        <div style="max-height: 250px; overflow-y: auto; background:#f8f9fa; padding:15px; border-radius:10px;">
                            <c:set var="hasChats" value="false" />
                            <c:forEach var="chat" items="${allChats}">
                                <c:if test="${chat.investor.id == i.id}">
                                    <c:set var="hasChats" value="true" />
                                    <div class="mb-2 p-2 rounded" style="background:${chat.senderRole == 'INVESTOR' ? '#e2f0d9' : '#fff'}; border: 1px solid rgba(0,0,0,0.05); font-size:0.8rem;">
                                        <div class="d-flex justify-content-between small text-muted mb-1">
                                            <span><strong>${chat.senderRole == 'INVESTOR' ? 'Investor' : 'Entrepreneur'}</strong> (${chat.senderRole == 'INVESTOR' ? i.fullName : chat.proposal.entrepreneur.fullName})</span>
                                            <span>${chat.timestamp}</span>
                                        </div>
                                        <div class="text-dark">"${chat.message}"</div>
                                        <div class="text-muted small mt-1" style="font-size:0.7rem;">Topic: "${chat.proposal.title}"</div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${not hasChats}">
                                <div class="text-center text-muted small py-3">No chat messages sent.</div>
                            </c:if>
                        </div>

                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
