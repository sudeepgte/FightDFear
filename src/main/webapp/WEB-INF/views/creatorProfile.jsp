<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${creator.fullName} - Creator Hub</title>
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
            --neon-glow: 0 0 20px rgba(244, 63, 94, 0.35);
        }

        body {
            background-color: var(--dark-bg);
            background-image: radial-gradient(circle at 10% 20%, rgba(139, 92, 246, 0.08) 0%, transparent 40%),
                              radial-gradient(circle at 90% 80%, rgba(244, 63, 94, 0.08) 0%, transparent 40%);
            color: var(--text-main);
            font-family: 'Outfit', sans-serif;
            margin: 0;
            padding-bottom: 80px;
        }

        .hub-container {
            margin-top: 110px;
        }

        /* ── PROFILE CARD ── */
        .profile-header-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 28px;
            padding: 35px;
            backdrop-filter: blur(15px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            margin-bottom: 30px;
        }
        .profile-pic-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin-bottom: 20px;
        }
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-accent);
            box-shadow: var(--neon-glow);
        }
        .creator-title-name {
            font-size: 26px;
            font-weight: 800;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .verified-badge {
            color: #38bdf8;
            font-size: 20px;
        }

        .stat-box {
            text-align: center;
            padding: 10px 20px;
        }
        .stat-value {
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            display: block;
        }
        .stat-label {
            font-size: 13px;
            color: var(--text-muted);
        }

        .action-button-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        /* ── GRID CONTENT TABS ── */
        .nav-tabs {
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 25px;
        }
        .nav-link {
            border: none !important;
            color: var(--text-muted) !important;
            background: none !important;
            font-size: 16px;
            font-weight: 600;
            padding: 12px 25px;
            position: relative;
            transition: color 0.3s;
        }
        .nav-link.active {
            color: var(--primary-accent) !important;
        }
        .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-accent), var(--secondary-accent));
            border-radius: 4px 4px 0 0;
            box-shadow: var(--neon-glow);
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }
        .grid-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            overflow: hidden;
            backdrop-filter: blur(10px);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        .grid-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }
        .grid-thumbnail {
            position: relative;
            height: 180px;
            background: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .grid-thumbnail img, .grid-thumbnail video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .grid-info {
            padding: 15px;
        }
        .grid-title {
            font-size: 15px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .locker-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(9, 9, 14, 0.9);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            z-index: 5;
        }
        
        /* Modal Styles overlay */
        .modal-content {
            background: #0d0d15;
            border: 1px solid var(--border-color);
            border-radius: 24px;
            color: #fff;
        }
        .modal-header {
            border-bottom: 1px solid var(--border-color);
        }
        .modal-footer {
            border-top: 1px solid var(--border-color);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="container hub-container">
        
        <!-- Check Blocks -->
        <c:choose>
            <c:when test="${blocked}">
                <div class="row justify-content-center">
                    <div class="col-md-7 text-center py-5">
                        <i class="fa-solid fa-ban text-danger mb-4" style="font-size: 60px;"></i>
                        <h4 class="text-white">Profile Unavailable</h4>
                        <p class="text-muted">You are blocked or have blocked this user. Cannot view their profile details.</p>
                        <a href="${pageContext.request.contextPath}/creator-hub" class="btn btn-danger rounded-pill px-4 py-2 mt-3">Back to Hub</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                
                <!-- PROFILE INFORMATION -->
                <div class="profile-header-card">
                    <div class="row align-items-center">
                        <div class="col-md-3 text-center d-flex flex-column align-items-center">
                            <div class="profile-pic-container">
                                <c:choose>
                                    <c:when test="${not empty creator.profilePhoto}">
                                        <img src="${creator.profilePhoto}" class="profile-pic" alt="avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/assets/img/default-avatar.png" class="profile-pic" alt="avatar">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-9 text-center text-md-start">
                            <div class="creator-title-name mb-1">
                                ${creator.fullName}
                                <c:if test="${creator.verifiedCreator}">
                                    <i class="fa-solid fa-circle-check verified-badge" title="Verified Creator Badge"></i>
                                </c:if>
                            </div>
                            <span class="badge bg-danger mb-3 rounded-pill px-3 py-1" style="font-size: 11px;">Verified Woman Creator</span>
                            
                            <p class="text-white opacity-85 mb-3" style="max-width: 600px;">
                                ${not empty creator.hostBio ? creator.hostBio : 'Helping women grow, share safety practices, develop professional skills and expand creative potential!'}
                            </p>

                            <!-- User Follower Count Metrics -->
                            <div class="d-flex justify-content-center justify-content-md-start gap-4 mb-4">
                                <div class="stat-box">
                                    <span class="stat-value">${followersCount}</span>
                                    <span class="stat-label">Followers</span>
                                </div>
                                <div class="stat-box">
                                    <span class="stat-value">${followingCount}</span>
                                    <span class="stat-label">Following</span>
                                </div>
                                <div class="stat-box">
                                    <span class="stat-value">${uploads.size()}</span>
                                    <span class="stat-label">Uploads</span>
                                </div>
                            </div>

                            <!-- Actions Controls -->
                            <div class="action-button-group justify-content-center justify-content-md-start">
                                <!-- Follow/Unfollow Button -->
                                <c:if test="${creator.id != currentUser.id}">
                                    <button class="btn rounded-pill px-4 py-2 font-weight-bold ${isFollowing ? 'btn-danger' : (isRequested ? 'btn-secondary' : 'btn-outline-danger')}" id="followBtn" onclick="followCreator(${creator.id})">
                                        ${isFollowing ? 'Following' : (isRequested ? 'Requested' : 'Follow')}
                                    </button>
                                    
                                    <!-- Tip Button -->
                                    <button class="btn btn-outline-warning rounded-pill px-4 py-2" data-bs-toggle="modal" data-bs-target="#tipModal">
                                        <i class="fa-solid fa-hand-holding-dollar me-2"></i>Tip Creator
                                    </button>

                                    <!-- Subscribe Tier -->
                                    <c:if test="${creator.creatorSubscriptionPrice > 0}">
                                        <button class="btn btn-warning rounded-pill px-4 py-2 text-dark font-weight-bold" onclick="subscribeCreator(${creator.id})">
                                            <i class="fa-solid fa-star me-2"></i>${isSubscribed ? 'Subscribed' : 'Subscribe (Rs. '.concat(creator.creatorSubscriptionPrice).concat('/mo)')}
                                        </button>
                                    </c:if>

                                    <!-- Block User Action -->
                                    <button class="btn btn-outline-secondary rounded-pill px-3 py-2 btn-sm" onclick="blockUser(${creator.id})">
                                        <i class="fa-solid fa-ban me-1"></i> Block
                                    </button>
                                </c:if>
                                <c:if test="${creator.id == currentUser.id}">
                                    <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="btn btn-danger rounded-pill px-4 py-2">
                                        <i class="fa-solid fa-sliders me-2"></i> Manage Creator Studio
                                    </a>
                                </c:if>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- TABS & GRID CONTENT -->
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#allPosts" type="button">All Uploads</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#premiumCourses" type="button">Paid Courses</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#storiesTab" type="button">Stories (${stories.size()})</button>
                    </li>
                </ul>

                <div class="tab-content">
                    
                    <!-- TAB 1: ALL CONTENT -->
                    <div class="tab-pane fade show active" id="allPosts">
                        <c:if test="${empty uploads}">
                            <div class="text-center py-5 text-muted">No uploads published yet.</div>
                        </c:if>
                        <div class="content-grid">
                            <c:forEach var="video" items="${uploads}">
                                <div class="grid-card">
                                    <div class="grid-thumbnail">
                                        
                                        <!-- Locks checks -->
                                        <c:set var="subLockKey" value="subLocked_${video.id}" />
                                        <c:set var="paidLockKey" value="paidLocked_${video.id}" />
                                        <c:choose>
                                            <c:when test="${requestScope[subLockKey]}">
                                                <div class="locker-overlay">
                                                    <i class="fa-solid fa-lock text-danger mb-2" style="font-size: 24px;"></i>
                                                    <span class="text-white text-xs px-2">Subscribers Only</span>
                                                </div>
                                            </c:when>
                                            <c:when test="${requestScope[paidLockKey]}">
                                                <div class="locker-overlay">
                                                    <i class="fa-solid fa-graduation-cap text-warning mb-2" style="font-size: 24px;"></i>
                                                    <span class="text-white text-xs px-2">Premium Unlock (Rs. ${video.price})</span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Clickable preview -->
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${video.fileType eq 'VIDEO'}">
                                                <video src="${video.videoPath}" preload="metadata"></video>
                                                <i class="fa-solid fa-circle-play text-white position-absolute" style="font-size: 32px; opacity: 0.8;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${video.videoPath}" alt="thumb">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="grid-info">
                                        <h6 class="grid-title">${video.title}</h6>
                                        <div class="d-flex justify-content-between text-muted text-xs">
                                            <span><i class="fa-solid fa-heart text-danger me-1"></i>${video.likeCount}</span>
                                            <span><i class="fa-solid fa-eye me-1"></i>${video.viewCount} Views</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- TAB 2: PREMIUM COURSES -->
                    <div class="tab-pane fade" id="premiumCourses">
                        <div class="content-grid">
                            <c:set var="hasPaid" value="false" />
                            <c:forEach var="video" items="${uploads}">
                                <c:if test="${video.isPaidContent()}">
                                    <c:set var="hasPaid" value="true" />
                                    <div class="grid-card">
                                        <div class="grid-thumbnail">
                                            <c:set var="paidLockKey" value="paidLocked_${video.id}" />
                                            <c:if test="${requestScope[paidLockKey]}">
                                                <div class="locker-overlay">
                                                    <i class="fa-solid fa-lock text-warning mb-2" style="font-size: 24px;"></i>
                                                    <span class="text-white text-xs mb-2">Unlocked for Rs. ${video.price}</span>
                                                    <button class="btn btn-warning btn-xs rounded-pill text-dark font-weight-bold px-3 py-1" onclick="unlockCourse(${video.id}, ${video.price})">Unlock Now</button>
                                                </div>
                                            </c:if>
                                            <video src="${video.videoPath}"></video>
                                        </div>
                                        <div class="grid-info">
                                            <h6 class="grid-title">${video.title}</h6>
                                            <div class="d-flex justify-content-between text-muted text-xs">
                                                <span class="text-warning font-weight-bold">Paid Class</span>
                                                <span>Price: Rs. ${video.price}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasPaid}">
                                <div class="text-center py-5 text-muted w-100">No paid educational content published.</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- TAB 3: STORIES -->
                    <div class="tab-pane fade" id="storiesTab">
                        <c:if test="${empty stories}">
                            <div class="text-center py-5 text-muted">No active stories in the last 24 hours.</div>
                        </c:if>
                        <div class="content-grid">
                            <c:forEach var="story" items="${stories}">
                                <div class="grid-card" style="height: 240px;">
                                    <div class="grid-thumbnail h-100 w-100">
                                        <c:choose>
                                            <c:when test="${story.fileType eq 'VIDEO'}">
                                                <video src="${story.mediaPath}" muted autoplay loop></video>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${story.mediaPath}" alt="story">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="position-absolute bottom-0 start-0 w-100 p-2 text-white text-xs bg-dark bg-opacity-75">
                                            ${story.caption}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>

            </c:otherwise>
        </c:choose>

    </div>

    <!-- TIPPING MODAL -->
    <div class="modal fade" id="tipModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fa-solid fa-coins text-warning me-2"></i>Send Tip / Donation</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted text-xs">
                        Direct support helps creator produce safety content, research guidelines and build educational materials. Amounts are charged to your Safety Wallet balance.
                    </p>
                    <div class="mb-3">
                        <label class="form-label text-white">Amount (Rs.)</label>
                        <input type="number" id="tipAmount" class="form-control" placeholder="e.g. 50" min="5" value="50">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white">Encouragement Message</label>
                        <input type="text" id="tipMessage" class="form-control" placeholder="Great video, keep up the work!">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-warning text-dark font-weight-bold rounded-pill px-4" onclick="submitTip()">Send Tip</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function followCreator(creatorId) {
            fetch('${pageContext.request.contextPath}/creator-hub/creator/follow/' + creatorId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'LOGIN_REQUIRED') {
                    window.location.href = '/login';
                    return;
                }
                const btn = document.getElementById('followBtn');
                if (data.status === 'FOLLOWED') {
                    btn.innerText = 'Following';
                    btn.className = 'btn btn-danger rounded-pill px-4 py-2 font-weight-bold';
                } else if (data.status === 'REQUESTED') {
                    btn.innerText = 'Requested';
                    btn.className = 'btn btn-secondary rounded-pill px-4 py-2 font-weight-bold';
                } else {
                    btn.innerText = 'Follow';
                    btn.className = 'btn btn-outline-danger rounded-pill px-4 py-2 font-weight-bold';
                }
                window.location.reload(); // refresh stats count
            });
        }

        function submitTip() {
            const amount = document.getElementById('tipAmount').value;
            const message = document.getElementById('tipMessage').value;

            if (amount <= 0) {
                alert("Please enter a valid amount");
                return;
            }

            const formData = new URLSearchParams();
            formData.append('creatorId', '${creator.id}');
            formData.append('amount', amount);
            formData.append('message', message);

            fetch('${pageContext.request.contextPath}/creator-hub/creator/tip', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'INSUFFICIENT_FUNDS') {
                    alert("Insufficient balance in your Safety Wallet. Please top up your wallet.");
                } else if (data.success) {
                    alert("Thank you! Your tip has been sent to the creator successfully.");
                    bootstrap.Modal.getInstance(document.getElementById('tipModal')).hide();
                    window.location.reload();
                } else {
                    alert("Error: " + data.error);
                }
            });
        }

        function subscribeCreator(creatorId) {
            if (confirm("Subscribe to this creator to support and view exclusive subscriber-only content? It will charge your wallet.")) {
                fetch('${pageContext.request.contextPath}/creator-hub/creator/subscribe?creatorId=' + creatorId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.error === 'INSUFFICIENT_FUNDS') {
                        alert("Insufficient balance to subscribe.");
                    } else if (data.success) {
                        alert("Subscribed successfully!");
                        window.location.reload();
                    } else {
                        alert("Error: " + data.error);
                    }
                });
            }
        }

        function unlockCourse(videoId, price) {
            if (confirm("Unlock this course for Rs. " + price + "? It will charge your wallet.")) {
                fetch('${pageContext.request.contextPath}/creator-hub/creator/unlock?videoId=' + videoId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.error === 'INSUFFICIENT_FUNDS') {
                        alert("Insufficient balance to unlock this course.");
                    } else if (data.success) {
                        alert("Content unlocked successfully!");
                        window.location.reload();
                    } else {
                        alert("Error: " + data.error);
                    }
                });
            }
        }

        function blockUser(creatorId) {
            if (confirm("Block this user? You will not see their uploads, and they cannot interact with your feed.")) {
                const formData = new URLSearchParams();
                formData.append('blockedUserId', creatorId);
                fetch('${pageContext.request.contextPath}/creator-hub/creator/block', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert("User blocked successfully.");
                        window.location.href = '${pageContext.request.contextPath}/creator-hub';
                    }
                });
            }
        }
    </script>
</body>
</html>
