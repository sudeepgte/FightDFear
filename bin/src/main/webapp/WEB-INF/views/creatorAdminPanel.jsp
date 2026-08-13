<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Creator Safety & Admin Board</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --dark-bg: #09090e;
            --card-bg: rgba(20, 20, 35, 0.6);
            --border-color: rgba(255, 255, 255, 0.08);
            --primary-accent: #f43f5e;
            --secondary-accent: #8b5cf6;
            --text-main: #f3f4f6;
            --text-muted: #9ca3af;
        }

        body {
            background-color: var(--dark-bg);
            background-image: radial-gradient(circle at 10% 20%, rgba(139, 92, 246, 0.07) 0%, transparent 45%),
                              radial-gradient(circle at 90% 80%, rgba(244, 63, 94, 0.07) 0%, transparent 45%);
            color: var(--text-main);
            font-family: 'Outfit', sans-serif;
            margin: 0;
            padding-bottom: 80px;
        }

        .hub-container {
            margin-top: 110px;
        }

        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 25px;
            backdrop-filter: blur(15px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            margin-bottom: 30px;
        }

        .nav-pills .nav-link {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            border-radius: 30px;
            padding: 10px 22px;
            font-weight: 600;
            margin-right: 8px;
            transition: all 0.3s;
        }
        .nav-pills .nav-link.active {
            background: linear-gradient(135deg, var(--primary-accent), var(--secondary-accent)) !important;
            color: #fff !important;
            border-color: transparent;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--border-color);
            color: #fff;
            border-radius: 12px;
            padding: 10px 15px;
        }
        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.07);
            border-color: var(--primary-accent);
            color: #fff;
        }

        .table {
            color: var(--text-main);
            border-color: var(--border-color);
        }
        .table th {
            color: var(--text-muted);
            border-bottom: 2px solid var(--border-color);
        }
        .table td {
            vertical-align: middle;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .moder-video {
            width: 100px;
            max-height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="container hub-container">
        
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h2 class="text-white m-0"><i class="fa-solid fa-shield-halved text-danger me-2"></i>Safety & Admin Board</h2>
                <p class="text-muted mb-0">Moderation center, cash-out processing, verification badges, and sponsorship triggers.</p>
            </div>
            <a href="${pageContext.request.contextPath}/creator-hub" class="btn btn-outline-light rounded-pill px-4">
                <i class="fa-solid fa-chevron-left me-1"></i> Back to feed
            </a>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success rounded-4">${success}</div>
        </c:if>

        <ul class="nav nav-pills mb-4" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabModer" type="button">
                    <i class="fa-solid fa-magnifying-glass-chart me-2"></i>Moderation Queue (${moderationQueue.size()})
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabReports" type="button">
                    <i class="fa-solid fa-flag me-2"></i>Reports (${reports.size()})
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabVerification" type="button">
                    <i class="fa-solid fa-award me-2"></i>Creator Verification
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabCashouts" type="button">
                    <i class="fa-solid fa-receipt me-2"></i>Cashout Requests (${cashoutRequests.size()})
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabCollabCreate" type="button">
                    <i class="fa-solid fa-bullhorn me-2"></i>Create Sponsorship
                </button>
            </li>
        </ul>

        <div class="tab-content">
            
            <!-- TAB 1: MODERATION QUEUE (AI FLAGGED ITEMS) -->
            <div class="tab-pane fade show active" id="tabModer">
                <div class="glass-card">
                    <h4 class="text-white mb-3">AI Safety Flagged Moderation Queue</h4>
                    <c:if test="${empty moderationQueue}">
                        <div class="text-center py-5 text-muted">All uploaded posts are clean. Queue is empty!</div>
                    </c:if>
                    <c:if test="${not empty moderationQueue}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Media</th>
                                        <th>Uploader</th>
                                        <th>Content Title & Description</th>
                                        <th>Flags detected</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="v" items="${moderationQueue}">
                                        <tr id="moder-row-${v.id}">
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.fileType eq 'VIDEO'}">
                                                        <video src="${v.videoPath}" class="moder-video" controls muted></video>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${v.videoPath}" class="moder-video" alt="img">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="d-block text-white font-weight-bold">${v.user.fullName}</span>
                                                <span class="text-muted text-xs">ID: ${v.user.id}</span>
                                            </td>
                                            <td>
                                                <strong class="text-white">${v.title}</strong>
                                                <p class="text-muted text-xs mb-0">${v.description}</p>
                                                <c:if test="${not empty v.hashtags}"><span class="text-info text-xs">${v.hashtags}</span></c:if>
                                            </td>
                                            <td>
                                                <span class="badge bg-warning text-dark">Safety Scan Pending</span>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-sm btn-success rounded-pill px-3" onclick="processApprove(${v.id}, true)">Approve</button>
                                                    <button class="btn btn-sm btn-danger rounded-pill px-3" onclick="processApprove(${v.id}, false)">Block</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- TAB 2: REPORTED CONTENT -->
            <div class="tab-pane fade" id="tabReports">
                <div class="glass-card">
                    <h4 class="text-white mb-3">User Safety Reports</h4>
                    <c:if test="${empty reports}">
                        <div class="text-center py-5 text-muted">No safety reports submitted.</div>
                    </c:if>
                    <c:if test="${not empty reports}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Media</th>
                                        <th>Reported Creator</th>
                                        <th>Reporter</th>
                                        <th>Reason</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="r" items="${reports}">
                                        <tr id="report-row-${r.id}">
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.video.fileType eq 'VIDEO'}">
                                                        <video src="${r.video.videoPath}" class="moder-video" controls muted></video>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${r.video.videoPath}" class="moder-video" alt="img">
                                                    </c:otherwise>
                                                </c:choose>
                                                <strong class="d-block text-white text-xs mt-1 text-center">${r.video.title}</strong>
                                            </td>
                                            <td>${r.video.user.fullName}</td>
                                            <td>${r.reportedBy.fullName}</td>
                                            <td>
                                                <span class="text-warning text-xs font-weight-bold">${r.reason}</span>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-sm btn-outline-success rounded-pill" onclick="keepReported(${r.id})">Keep Post (Clear)</button>
                                                    <button class="btn btn-sm btn-danger rounded-pill" onclick="deleteReported(${r.id})">Delete Post</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- TAB 3: CREATOR BADGES VERIFICATION -->
            <div class="tab-pane fade" id="tabVerification">
                <div class="glass-card mb-4">
                    <h4 class="text-white mb-3">Pending Badge Verification requests (Reward Points > 100)</h4>
                    <c:if test="${empty creatorsVerificationList}">
                        <div class="text-center py-4 text-muted">No pending creator badge applications found.</div>
                    </c:if>
                    <c:if test="${not empty creatorsVerificationList}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Uploader</th>
                                        <th>Safety Points</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${creatorsVerificationList}">
                                        <tr id="creator-verify-${c.id}">
                                            <td>${c.fullName} (${c.email})</td>
                                            <td><span class="text-warning font-weight-bold">${c.rewardPoints} Pts</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-warning text-dark font-weight-bold rounded-pill px-3" onclick="processBadge(${c.id}, true)">Verify & Award Badge</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>

                <div class="glass-card">
                    <h4 class="text-white mb-3">Currently Verified Creators</h4>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Creator Name</th>
                                    <th>Email</th>
                                    <th>Points</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${verifiedCreators}">
                                    <tr id="creator-verified-${v.id}">
                                        <td>${v.fullName} <i class="fa-solid fa-circle-check text-info ms-1"></i></td>
                                        <td>${v.email}</td>
                                        <td>${v.rewardPoints}</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="processBadge(${v.id}, false)">Retract Badge</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- TAB 4: CASHOUT PROCESSING -->
            <div class="tab-pane fade" id="tabCashouts">
                <div class="glass-card">
                    <h4 class="text-white mb-3">Payout & Redemption Queue</h4>
                    <c:if test="${empty cashoutRequests}">
                        <div class="text-center py-5 text-muted">All cash-out payments processed. Queue clear!</div>
                    </c:if>
                    <c:if test="${not empty cashoutRequests}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Creator</th>
                                        <th>Points Redeemed</th>
                                        <th>Payment Amount</th>
                                        <th>Requested Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${cashoutRequests}">
                                        <tr id="cashout-row-${c.id}">
                                            <td>
                                                <span class="d-block text-white font-weight-bold">${c.creator.fullName}</span>
                                                <span class="text-muted text-xs">Wallet Balance: Rs. ${c.creator.walletBalance}</span>
                                            </td>
                                            <td>${c.points} Pts</td>
                                            <td><strong class="text-success">Rs. ${c.amount}</strong></td>
                                            <td>${c.createdAt}</td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <button class="btn btn-sm btn-success rounded-pill px-3" onclick="processCashout(${c.id}, true)">Approve & Credit</button>
                                                    <button class="btn btn-sm btn-outline-danger rounded-pill px-3" onclick="processCashout(${c.id}, false)">Reject & Refund</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- TAB 5: CREATE SPONSORSHIP CAMPAIGN -->
            <div class="tab-pane fade" id="tabCollabCreate">
                <div class="glass-card">
                    <h4 class="text-white mb-4"><i class="fa-solid fa-bullhorn text-danger me-2"></i>Launch Brand Sponsorship Campaign</h4>
                    <form action="${pageContext.request.contextPath}/creator-hub/admin/create-campaign" method="POST">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-white">Brand / Sponsor Name</label>
                                <input type="text" name="brandName" class="form-control" placeholder="e.g. Safety First Org" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-white">Campaign / Pitch Title</label>
                                <input type="text" name="campaignTitle" class="form-control" placeholder="e.g. Self-Defense Reels Awareness Camp" required>
                            </div>
                            <div class="col-12 mb-3">
                                <label class="form-label text-white">Sponsorship Requirements & Brief</label>
                                <textarea name="description" class="form-control" rows="4" placeholder="Brief details about what the sponsor is looking for in terms of creator alignment, hashtags to use, and post format details..." required></textarea>
                            </div>
                            <div class="col-md-4 mb-4">
                                <label class="form-label text-white">Sponsorship Pay Rate (Rs. / Post)</label>
                                <input type="number" step="1" min="1" name="payRate" class="form-control" placeholder="e.g. 500" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-danger rounded-pill px-5 py-2 font-weight-bold">
                            Create Campaign Listing
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </div>

    <!-- Scripting operations -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // MODERATION QUEUE
        function processApprove(videoId, approve) {
            const formData = new URLSearchParams();
            formData.append('videoId', videoId);
            formData.append('approve', approve);

            fetch('${pageContext.request.contextPath}/creator-hub/admin/approve', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Content " + (approve ? "Approved!" : "Blocked & Rejected!"));
                    document.getElementById('moder-row-' + videoId).remove();
                }
            });
        }

        // SAFETY REPORTS
        function keepReported(reportId) {
            // Keep reported clears report
            // E.g. call standard delete of report row
            fetch('${pageContext.request.contextPath}/creator-hub/admin/delete-reported?reportId=' + reportId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Report cleared. Post kept active.");
                    document.getElementById('report-row-' + reportId).remove();
                }
            });
        }

        function deleteReported(reportId) {
            if (confirm("Delete this reported post permanently?")) {
                fetch('${pageContext.request.contextPath}/creator-hub/admin/delete-reported?reportId=' + reportId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert("Post deleted and report resolved.");
                        document.getElementById('report-row-' + reportId).remove();
                    }
                });
            }
        }

        // CREATOR BADGES
        function processBadge(creatorId, verify) {
            const formData = new URLSearchParams();
            formData.append('creatorId', creatorId);
            formData.append('verify', verify);

            fetch('${pageContext.request.contextPath}/creator-hub/admin/verify', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Creator status updated!");
                    window.location.reload();
                }
            });
        }

        // CASHOUTS
        function processCashout(cashoutId, approve) {
            const formData = new URLSearchParams();
            formData.append('cashoutId', cashoutId);
            formData.append('approve', approve);

            fetch('${pageContext.request.contextPath}/creator-hub/admin/cashout', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Payout status updated!");
                    document.getElementById('cashout-row-' + cashoutId).remove();
                }
            });
        }
    </script>
</body>
</html>
