<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Creator Studio Dashboard — Fight D Fear</title>
    
    <!-- Icons & Fonts -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Theme files -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    
    <style>
        :root {
            --glow-bg: #fffcfd;
            --card-bg: #ffffff;
            --accent-pink: #f43f5e;
            --accent-purple: #8b5cf6;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--glow-bg);
            color: var(--fdf-text);
            overflow-x: hidden;
        }

        /* Floating background blobs */
        .glow-bg-layer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        .blob {
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.12;
            animation: floatBlob 20s infinite alternate;
        }
        .blob-1 { top: -100px; right: -100px; background: var(--accent-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--accent-pink); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* Clean Minimal Header */
        .glow-header {
            padding: 60px 20px 40px;
            text-align: center;
            background: white;
            border-bottom: 1px solid var(--fdf-border);
            position: relative;
            margin-bottom: 40px;
        }
        .glow-header h1 {
            font-family: 'Montserrat', sans-serif;
            font-size: 38px;
            font-weight: 900;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .glow-header p {
            color: var(--fdf-muted);
            font-size: 15px;
            max-width: 650px;
            margin: 0 auto;
            line-height: 1.6;
        }

        /* Top Bar navigation */
        .top-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 16px 30px;
            position: absolute;
            top: 0; right: 0;
            width: 100%;
        }
        .top-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--accent-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--accent-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Studio Container */
        .studio-container {
            max-width: 1100px;
            margin: 0 auto 60px;
            padding: 0 15px;
        }
        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 24px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
        }
        .metric-card {
            background: #ffffff;
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 20px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .metric-value {
            font-size: 28px;
            font-weight: 800;
        }
        .metric-label {
            font-size: 12px;
            color: var(--fdf-muted);
            font-weight: 600;
            text-transform: uppercase;
            display: block;
            margin-top: 4px;
        }

        .nav-pills {
            gap: 8px;
            margin-bottom: 30px;
        }
        .nav-pills .nav-link {
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            border-radius: 30px;
            padding: 10px 22px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        .nav-pills .nav-link.active {
            background: var(--gradient-primary) !important;
            color: #fff !important;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        .table {
            color: var(--fdf-text);
        }
        .table th {
            color: var(--fdf-muted);
            font-weight: 700;
            border-bottom-width: 2px;
        }
        .table td {
            vertical-align: middle;
            font-size: 14px;
            color: #444;
        }
        .draft-thumb {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            background: #000;
            border: 1px solid var(--fdf-border);
        }

        .form-control, .form-select {
            border: 1px solid var(--fdf-border);
            border-radius: 12px;
            padding: 10px 15px;
            font-size: 14px;
        }

        .form-label {
            font-size: 12px;
            font-weight: 700;
            color: var(--brand-purple);
            text-transform: uppercase;
        }

        /* Modal Overrides */
        .modal-content {
            border-radius: 24px;
            border: none;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
        }
        .modal-header {
            background: #f9fafb;
            border-bottom: none;
            padding: 20px 24px;
        }
        .modal-body {
            padding: 24px;
            background: #fff;
        }
        .modal-footer {
            background: #f9fafb;
            border-top: none;
            padding: 16px 24px;
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .top-bar {
                position: relative;
                justify-content: center;
                padding: 10px;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }
            .top-btn {
                padding: 8px 14px;
                font-size: 12px;
                margin-right: 0 !important;
            }
            .glow-header h1 { font-size: 28px; }
            .nav-pills {
                flex-wrap: nowrap;
                overflow-x: auto;
                padding-bottom: 8px;
                scrollbar-width: none;
            }
            .nav-pills::-webkit-scrollbar { display: none; }
            .nav-pills .nav-link { white-space: nowrap; }
        }
    </style>
</head>
<body>

<!-- Header -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <!-- Content wrapper -->
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
        
        <!-- Blobs overlay -->
        <div class="glow-bg-layer">
            <div class="blob blob-1"></div>
            <div class="blob blob-2"></div>
        </div>

        <!-- Dashboard Header -->
        <div class="glow-header">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/creator-hub" class="top-btn" style="margin-right: auto;">
                    <i class="bi bi-arrow-left"></i> Back to Hub
                </a>
            </div>
            
            <h1>Creator Studio</h1>
            <p>Welcome back, ${user.fullName}. Manage your digital uploads, request ad revenue, redeem safety program points, or settings.</p>
        </div>

        <div class="studio-container">
            <c:if test="${not empty success}">
                <div class="alert alert-success rounded-4 border-0 shadow-sm mb-4">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-4 border-0 shadow-sm mb-4">${error}</div>
            </c:if>

            <!-- ANALYTICS METRICS BAR -->
            <div class="row g-3 mb-5">
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <span class="metric-value text-primary">${totalViews}</span>
                        <span class="metric-label">Total Views</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <span class="metric-value text-danger">${totalLikes}</span>
                        <span class="metric-label">Total Likes</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <span class="metric-value text-warning">${subscriberCount}</span>
                        <span class="metric-label">Subscribers</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <span class="metric-value text-success">${user.rewardPoints}</span>
                        <span class="metric-label">Rewards Points</span>
                    </div>
                </div>
            </div>

            <!-- STUDIO TAB NAVIGATION -->
            <ul class="nav nav-pills" id="studioTab" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabContent" type="button"><i class="fa-solid fa-photo-film me-2"></i>My Content</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabMonetize" type="button"><i class="fa-solid fa-coins me-2"></i>Monetization Center</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabCollabs" type="button"><i class="fa-solid fa-handshake-angle me-2"></i>Sponsorships</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabSafety" type="button"><i class="fa-solid fa-shield-cat me-2"></i>Safety &amp; Blocks</button>
                </li>
            </ul>

            <div class="tab-content">
                
                <!-- TAB 1: MY CONTENT & DRAFTS -->
                <div class="tab-pane fade show active" id="tabContent">
                    <div class="row">
                        <!-- Published Uploads -->
                        <div class="col-12 mb-4">
                            <div class="glass-card">
                                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>Published Uploads</h4>
                                <c:if test="${empty published}">
                                    <div class="text-muted text-center py-4">No content published yet.</div>
                                </c:if>
                                <c:if test="${not empty published}">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Media</th>
                                                    <th>Title</th>
                                                    <th>Category</th>
                                                    <th>Views</th>
                                                    <th>Likes</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="post" items="${published}">
                                                    <tr>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${post.fileType eq 'VIDEO'}">
                                                                    <video src="${post.videoPath}" class="draft-thumb" muted></video>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${post.videoPath}" class="draft-thumb" alt="thumb">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="d-block fw-bold text-dark">${post.title}</span>
                                                            <span class="text-muted text-xs">${post.uploadTime}</span>
                                                        </td>
                                                        <td>${post.category}</td>
                                                        <td>${post.viewCount}</td>
                                                        <td>${post.likeCount}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${post.status eq 'APPROVED'}">
                                                                    <span class="badge bg-success">Approved</span>
                                                                </c:when>
                                                                <c:when test="${post.status eq 'PENDING_MODERATION'}">
                                                                    <span class="badge bg-warning text-dark">Under Review</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-danger">Blocked</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/creator-hub/dashboard/deleteUpload" method="POST" onsubmit="return confirm('Delete this post permanently?')">
                                                                <input type="hidden" name="videoId" value="${post.id}">
                                                                <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill"><i class="fa-regular fa-trash-can"></i> Delete</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Saved Drafts -->
                        <div class="col-12">
                            <div class="glass-card">
                                <h4 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-file-signature text-warning me-2"></i>Saved Drafts</h4>
                                <c:if test="${empty drafts}">
                                    <div class="text-muted text-center py-4">No drafts saved.</div>
                                </c:if>
                                <c:if test="${not empty drafts}">
                                    <div class="table-responsive">
                                        <table class="table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Media</th>
                                                    <th>Title</th>
                                                    <th>Category</th>
                                                    <th>Monetization</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="draft" items="${drafts}">
                                                    <tr>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${draft.fileType eq 'VIDEO'}">
                                                                    <video src="${draft.videoPath}" class="draft-thumb" muted></video>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${draft.videoPath}" class="draft-thumb" alt="thumb">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="d-block fw-bold text-dark">${draft.title}</span>
                                                        </td>
                                                        <td>${draft.category}</td>
                                                        <td>
                                                            <c:if test="${draft.subscriberOnly}"><span class="badge bg-primary me-1">Sub Only</span></c:if>
                                                            <c:if test="${draft.paidContent}"><span class="badge bg-warning text-dark">Course (Rs.${draft.price})</span></c:if>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                <form action="${pageContext.request.contextPath}/creator-hub/dashboard/publishDraft" method="POST">
                                                                    <input type="hidden" name="videoId" value="${draft.id}">
                                                                    <button type="submit" class="btn btn-sm btn-success rounded-pill px-3"><i class="fa-solid fa-paper-plane me-1"></i> Publish</button>
                                                                </form>
                                                                <form action="${pageContext.request.contextPath}/creator-hub/dashboard/deleteUpload" method="POST">
                                                                    <input type="hidden" name="videoId" value="${draft.id}">
                                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill"><i class="fa-regular fa-trash-can"></i> Delete</button>
                                                                </form>
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
                    </div>
                </div>

                <!-- TAB 2: MONETIZATION CENTER -->
                <div class="tab-pane fade" id="tabMonetize">
                    <div class="row">
                        <!-- Ad Revenue Sharing -->
                        <div class="col-md-6 mb-4">
                            <div class="glass-card h-100">
                                <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-rectangle-ad text-danger me-2"></i>Ad Revenue Sharing</h4>
                                <p class="text-muted text-xs">Claim accumulated ad share based on your overall video views (Rs. 0.05 per view).</p>
                                
                                <div class="p-3 rounded-4 mb-4" style="background: #fafafb; border: 1px solid var(--fdf-border);">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Total Views:</span>
                                        <span class="fw-bold text-dark">${totalViews}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Views Claimed:</span>
                                        <span class="fw-bold text-dark">${user.adViewsClaimed}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="text-muted">Unclaimed Views:</span>
                                        <span class="fw-bold text-primary">${unclaimedViews}</span>
                                    </div>
                                    <hr class="my-2">
                                    <div class="d-flex justify-content-between">
                                        <span class="text-muted">Claimable Revenue:</span>
                                        <span class="fw-bold text-success" style="font-size: 18px;">Rs. ${estAdRevenue}</span>
                                    </div>
                                </div>
                                
                                <button class="btn btn-danger w-100 rounded-pill py-2 font-weight-bold" id="claimAdBtn" onclick="claimAdRevenue()">
                                    Claim Ad Share to Wallet
                                </button>
                            </div>
                        </div>

                        <!-- Creator Rewards Program -->
                        <div class="col-md-6 mb-4">
                            <div class="glass-card h-100">
                                <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-gift text-warning me-2"></i>Creator Rewards Program</h4>
                                <p class="text-muted text-xs">Convert reward points earned from user likes and views into Safety Wallet cash (100 points = Rs. 10).</p>
                                
                                <div class="p-3 rounded-4 mb-3" style="background: #fafafb; border: 1px solid var(--fdf-border);">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-muted">My Points:</span>
                                        <span class="badge bg-warning text-dark fw-bold py-2 px-3" style="font-size: 14px;">${user.rewardPoints} Points</span>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Points to Redeem</label>
                                    <input type="number" id="redeemPointsInput" class="form-control" placeholder="Minimum 100 points" min="100" step="100">
                                </div>

                                <button class="btn btn-warning text-dark font-weight-bold w-100 rounded-pill py-2" onclick="requestPointsRedeem()">
                                    Redeem Points
                                </button>

                                <!-- Redemptions List -->
                                <div class="mt-4">
                                    <h6 class="fw-bold text-dark mb-2">Redemption History</h6>
                                    <div style="max-height: 150px; overflow-y: auto;">
                                        <c:forEach var="c" items="${cashouts}">
                                            <div class="d-flex justify-content-between py-2 border-bottom text-xs">
                                                <span class="text-muted">${c.points} pts &rarr; Rs. ${c.amount}</span>
                                                <span class="badge ${c.status eq 'APPROVED' ? 'bg-success' : (c.status eq 'PENDING' ? 'bg-warning text-dark' : 'bg-danger')}">${c.status}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Creator Profile Custom Settings -->
                        <div class="col-12">
                            <div class="glass-card">
                                <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-sliders text-info me-2"></i>Creator Profile Tier Config</h4>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Custom Monthly Subscription Price (Rs.)</label>
                                        <div class="input-group">
                                            <input type="number" id="subPriceInput" class="form-control" placeholder="e.g. 99" value="${user.creatorSubscriptionPrice}">
                                            <button class="btn btn-outline-danger" onclick="saveSubscriptionPrice()">Save</button>
                                        </div>
                                        <small class="text-muted small">Setting a price above Rs. 0 enables monthly subscriber posts locking.</small>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Creator Affiliate Referral Code</label>
                                        <div class="input-group">
                                            <input type="text" id="affiliateCodeInput" class="form-control" placeholder="e.g. WOMENPOWER" value="${user.creatorAffiliateCode}">
                                            <button class="btn btn-outline-danger" onclick="saveAffiliateCode()">Save</button>
                                        </div>
                                        <small class="text-muted small">Used to generate affiliate product tags inside captions.</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 3: SPONSORSHIPS & BRAND COLLABS -->
                <div class="tab-pane fade" id="tabCollabs">
                    <div class="glass-card">
                        <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-circle-check text-info me-2"></i>Active Brand Sponsor Listings</h4>
                        <c:if test="${empty brandCampaigns}">
                            <div class="text-muted text-center py-4">No active brand campaigns listed right now. Check back soon!</div>
                        </c:if>
                        <c:if test="${not empty brandCampaigns}">
                            <div class="row">
                                <c:forEach var="bc" items="${brandCampaigns}">
                                    <div class="col-md-6 mb-3">
                                        <div class="p-3 rounded-4 h-100" style="background: #fafafb; border: 1px solid var(--fdf-border);">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="badge bg-danger">${bc.brandName}</span>
                                                <span class="text-success font-weight-bold">Rs. ${bc.payRate} / Post</span>
                                            </div>
                                            <h5 class="fw-bold text-dark">${bc.campaignTitle}</h5>
                                            <p class="text-muted text-xs mb-3">${bc.description}</p>
                                            
                                            <!-- Check if applied -->
                                            <c:set var="applied" value="false" />
                                            <c:forEach var="app" items="${myCollabApps}">
                                                <c:if test="${app.collaboration.id == bc.id}">
                                                    <c:set var="applied" value="true" />
                                                    <c:set var="appStatus" value="${app.status}" />
                                                </c:if>
                                            </c:forEach>

                                            <c:choose>
                                                <c:when test="${applied}">
                                                    <button class="btn btn-secondary btn-sm w-100 rounded-pill" disabled>
                                                        Applied (<c:out value="${appStatus}" />)
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-danger btn-sm w-100 rounded-pill" onclick="openApplyCollabModal(${bc.id}, '${bc.campaignTitle}')">
                                                        Apply Sponsorship
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- TAB 4: SAFETY SETTINGS -->
                <div class="tab-pane fade" id="tabSafety">
                    <div class="row">
                        <!-- Account privacy setting -->
                        <div class="col-md-6 mb-4">
                            <div class="glass-card h-100">
                                <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-lock text-danger me-2"></i>Creator Safety Mode</h4>
                                <p class="text-muted text-xs">Switching to Private mode hides your profile details from non-followers.</p>
                                
                                <div class="form-check form-switch p-0 mt-4 d-flex align-items-center justify-content-between">
                                    <label class="form-check-label fw-bold text-dark" for="privateToggle">Private Profile Mode</label>
                                    <input class="form-check-input ms-0" type="checkbox" id="privateToggle" onchange="toggleProfilePrivacy()" ${user.privateProfile ? 'checked' : ''} style="width: 50px; height: 26px;">
                                </div>
                            </div>
                        </div>

                        <!-- Blocking list -->
                        <div class="col-md-6 mb-4">
                            <div class="glass-card h-100">
                                <h4 class="fw-bold text-dark mb-3"><i class="fa-solid fa-user-slash text-warning me-2"></i>Block List</h4>
                                <p class="text-muted text-xs">Blocked users cannot follow you or comment on your creations.</p>
                                
                                <div class="mt-4" style="max-height: 180px; overflow-y: auto;">
                                    <c:forEach var="block" items="${blockedUsers}">
                                        <div class="d-flex align-items-center justify-content-between py-2 border-bottom">
                                            <span class="fw-bold text-dark text-xs">${block.blockedUser.fullName}</span>
                                            <button class="btn btn-outline-danger btn-xs py-1 px-3 rounded-pill" onclick="unblockUser(${block.blockedUser.id})">
                                                Unblock
                                            </button>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty blockedUsers}">
                                        <div class="text-muted text-center py-3">Block list is empty.</div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- Apply Collaboration Modal -->
<div class="modal fade" id="applyCollabModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-dark" id="collabModalTitle">Apply Sponsorship</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body bg-white">
                <input type="hidden" id="collabCampaignId">
                <div class="mb-3">
                    <label class="form-label">Submit your pitch / creator statistics</label>
                    <textarea id="collabPitch" class="form-control" rows="4" placeholder="Briefly pitch why your creator audience is suitable for this campaign (e.g. typical engagement rates, follower demographics)..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger rounded-pill px-4" onclick="submitCollabApplication()">Submit Pitch</button>
            </div>
        </div>
    </div>
</div>

<!-- JS Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });

    // CLAIM AD REVENUE
    function claimAdRevenue() {
        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/claim-ad-revenue', { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                alert("Error: " + data.error);
            } else {
                alert("Success! Rs. " + data.claimedAmount + " has been added to your Safety Wallet.");
                window.location.reload();
            }
        });
    }

    // REDEEM REWARDS
    function requestPointsRedeem() {
        const points = document.getElementById('redeemPointsInput').value;
        if (points < 100) {
            alert("Minimum 100 points required to redeem.");
            return;
        }

        const formData = new URLSearchParams();
        formData.append('points', points);

        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/cashout', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                alert("Error: " + data.error);
            } else {
                alert("Success! Redemption request for Rs. " + data.amount + " submitted to safety board.");
                window.location.reload();
            }
        });
    }

    // SAVE PROFILE SETTINGS
    function saveSubscriptionPrice() {
        const price = document.getElementById('subPriceInput').value;
        const formData = new URLSearchParams();
        formData.append('price', price);

        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/subscription-price', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("Monthly subscription price updated!");
            }
        });
    }

    function saveAffiliateCode() {
        const code = document.getElementById('affiliateCodeInput').value;
        const formData = new URLSearchParams();
        formData.append('code', code);

        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/affiliate-code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("Affiliate Referral code updated!");
            }
        });
    }

    // PRIVACY SWITCH
    function toggleProfilePrivacy() {
        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/toggle-privacy', { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("Profile privacy updated: Now " + (data.isPrivate ? "Private" : "Public"));
            }
        });
    }

    // BLOCK SETTINGS
    function unblockUser(userId) {
        const formData = new URLSearchParams();
        formData.append('blockedUserId', userId);
        fetch('${pageContext.request.contextPath}/creator-hub/dashboard/unblock', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("User unblocked successfully.");
                window.location.reload();
            }
        });
    }

    // BRAND SPONSORSHIPS
    function openApplyCollabModal(id, title) {
        document.getElementById('collabCampaignId').value = id;
        document.getElementById('collabModalTitle').innerText = 'Apply Sponsorship - ' + title;
        new bootstrap.Modal(document.getElementById('applyCollabModal')).show();
    }

    function submitCollabApplication() {
        const id = document.getElementById('collabCampaignId').value;
        const pitch = document.getElementById('collabPitch').value;

        if (!pitch.trim()) {
            alert("Please submit your pitch");
            return;
        }

        const formData = new URLSearchParams();
        formData.append('campaignId', id);
        formData.append('pitch', pitch);

        fetch('${pageContext.request.contextPath}/creator-hub/collab/apply', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("Application submitted successfully!");
                bootstrap.Modal.getInstance(document.getElementById('applyCollabModal')).hide();
                window.location.reload();
            } else {
                alert("Error: " + data.error);
            }
        });
    }
</script>

</body>
</html>
