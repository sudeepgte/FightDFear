<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Women Creator Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --dark-bg: #fffcfd;
            --card-bg: #ffffff;
            --border-color: rgba(0, 0, 0, 0.08);
            --primary-accent: #f43f5e;
            --secondary-accent: #8b5cf6;
            --text-main: #333333;
            --text-muted: #666666;
            --neon-glow: 0 4px 12px rgba(244, 63, 94, 0.15);
            --neon-purple: 0 4px 12px rgba(139, 92, 246, 0.15);
            --brand-purple: #7c3aed;
            --fdf-border: rgba(0,0,0,0.05);
        }

        html, body {
            overflow-x: hidden;
            width: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-main);
            font-family: 'Outfit', sans-serif;
            padding-bottom: 80px;
        }

        /* Glassmorphic Navbar Overlay override */
        .hub-navbar {
            backdrop-filter: blur(15px);
            background: rgba(255, 252, 253, 0.8) !important;
            border-bottom: 1px solid var(--border-color);
        }

        .hub-container {
            margin-top: 40px;
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
        .blob-1 { top: -100px; right: -100px; background: var(--secondary-accent); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--primary-accent); animation-delay: -5s; }
        
        @keyframes floatBlob {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(40px, 30px) scale(1.15); }
        }

        /* ── STORIES BAR ── */
        .stories-container {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 15px;
            display: flex;
            gap: 15px;
            overflow-x: auto;
            scrollbar-width: none;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
        .stories-container::-webkit-scrollbar {
            display: none;
        }
        .story-avatar-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            transition: transform 0.3s;
        }
        .story-avatar-wrapper:hover {
            transform: scale(1.05);
        }
        .story-ring {
            width: 68px;
            height: 68px;
            border-radius: 50%;
            padding: 3px;
            background: linear-gradient(45deg, var(--primary-accent), var(--secondary-accent));
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--neon-glow);
        }
        .story-ring.watched {
            background: #e5e7eb;
            box-shadow: none;
        }
        .story-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #ffffff;
        }
        .story-username {
            font-size: 11px;
            margin-top: 5px;
            color: var(--text-main);
            max-width: 75px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            text-align: center;
            font-weight: 600;
        }

        /* ── CATEGORY PILLS ── */
        .category-scroll {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none;
            margin-bottom: 25px;
            padding-bottom: 8px;
            width: 100%;
        }
        .category-scroll::-webkit-scrollbar {
            display: none;
        }
        .category-pill {
            background: #fff;
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            border-radius: 30px;
            padding: 8px 20px;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        .category-pill:hover, .category-pill.active {
            background: linear-gradient(135deg, var(--primary-accent), var(--secondary-accent));
            color: #fff;
            border-color: transparent;
            box-shadow: var(--neon-glow);
        }

        /* ── FEED POSTS ── */
        .post-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            margin-bottom: 30px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
        }
        .post-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
        }
        .post-header {
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .uploader-info {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text-main);
        }
        .uploader-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary-accent);
        }
        .uploader-name {
            font-weight: 700;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 5px;
            color: var(--brand-purple);
        }
        .verified-badge {
            color: #0ea5e9;
            font-size: 13px;
        }
        .post-location {
            font-size: 11px;
            color: var(--text-muted);
            display: block;
        }
        .post-time {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* ── MEDIA PLAYER CONTAINER ── */
        .post-media-container {
            position: relative;
            background: #f3f4f6;
            width: 100%;
            max-height: 520px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .post-media-container video, .post-media-container img {
            max-width: 100%;
            max-height: 520px;
            object-fit: contain;
        }
        .badge-type {
            position: absolute;
            top: 15px;
            left: 15px;
            background: rgba(255, 255, 255, 0.85);
            color: #333;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* Lock Overlay styles */
        .post-lock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 252, 253, 0.98);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 30px;
            z-index: 5;
        }
        .lock-icon {
            font-size: 48px;
            color: var(--primary-accent);
            margin-bottom: 15px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 0.8; }
        }

        /* Post Info & Actions */
        .post-footer {
            padding: 20px;
        }
        .post-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .action-group {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .action-btn {
            background: none;
            border: none;
            color: var(--text-main);
            font-size: 20px;
            cursor: pointer;
            transition: transform 0.2s, color 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .action-btn span {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
        .action-btn.liked {
            color: var(--primary-accent);
        }
        .action-btn.liked span {
            color: var(--primary-accent);
        }
        .action-btn.bookmarked {
            color: var(--secondary-accent);
        }

        .post-caption {
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 10px;
            color: #333;
        }
        .post-hashtags {
            color: #0284c7;
            font-weight: 600;
            font-size: 14px;
        }

        /* ── SIDEBAR CONTROLS ── */
        .sidebar-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 24px;
            margin-bottom: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }
        .sidebar-card .btn {
            font-weight: 700;
        }
        .sidebar-title {
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--brand-purple);
        }
        .trending-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--fdf-border);
            text-decoration: none;
            color: var(--text-main);
            transition: padding-left 0.2s;
            font-weight: 500;
        }
        .trending-item:hover {
            padding-left: 5px;
            color: var(--primary-accent);
        }
        .trending-item:last-child {
            border-bottom: none;
        }

        /* Floating action button */
        .fab-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-accent), var(--secondary-accent));
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3);
            transition: transform 0.3s, rotate 0.3s;
            z-index: 100;
            text-decoration: none;
        }
        .fab-btn:hover {
            transform: scale(1.1) rotate(90deg);
            color: #fff;
        }

        /* ── STORY MODAL & VIEWER ── */
        .story-modal {
            background: rgba(0, 0, 0, 0.95);
            color: #fff;
        }
        .story-progress-container {
            display: flex;
            gap: 4px;
            width: 100%;
            margin-bottom: 15px;
        }
        .story-progress-bar {
            height: 3px;
            background: rgba(255,255,255,0.3);
            flex-grow: 1;
            border-radius: 2px;
            overflow: hidden;
            position: relative;
        }
        .story-progress-fill {
            height: 100%;
            width: 0%;
            background: #fff;
            transition: width 0.1s linear;
        }

        /* Comment drawer style changes */
        .comment-drawer {
            position: fixed;
            top: 0;
            right: -420px;
            width: 420px;
            height: 100vh;
            height: 100dvh;
            background: #ffffff;
            border-left: 1px solid var(--border-color);
            box-shadow: -10px 0 30px rgba(0,0,0,0.05);
            z-index: 1050;
            transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1), visibility 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            visibility: hidden;
            color: #333;
        }
        .comment-drawer.open {
            right: 0;
            visibility: visible;
        }
        .comment-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .comment-header h5 {
            font-weight: 800;
            color: var(--brand-purple);
        }
        .comment-list {
            flex-grow: 1;
            overflow-y: auto;
            padding: 20px;
        }
        .comment-item {
            margin-bottom: 18px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            padding-bottom: 10px;
        }
        .comment-user {
            font-weight: 700;
            font-size: 13px;
            color: var(--primary-accent);
            margin-bottom: 4px;
        }
        .comment-text {
            font-size: 14px;
            color: #444;
        }
        .comment-input-area {
            padding: 15px 20px;
            border-top: 1px solid var(--border-color);
            background: #f9fafb;
        }
        .comment-input-area input {
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 10px 15px;
            font-size: 14px;
        }
        
        @media (max-width: 992px) {
            .hub-container {
                max-width: 100% !important;
                padding-left: 15px !important;
                padding-right: 15px !important;
                margin-top: 40px !important;
            }
        }
        @media (max-width: 576px) {
            .hub-container {
                padding-left: 8px !important;
                padding-right: 8px !important;
                margin-top: 20px !important;
            }
            .post-card {
                border-radius: 16px !important;
                margin-bottom: 20px !important;
            }
            .post-header {
                padding: 12px 15px !important;
            }
            .post-footer {
                padding: 15px !important;
            }
            .stories-container {
                padding: 10px !important;
                border-radius: 16px !important;
                gap: 10px !important;
                margin-bottom: 15px !important;
            }
            .story-ring {
                width: 56px !important;
                height: 56px !important;
            }
            .story-avatar {
                width: 48px !important;
                height: 48px !important;
            }
            .comment-drawer {
                width: 100% !important;
                right: -100%;
                visibility: hidden;
            }
            .comment-drawer.open {
                right: 0;
                visibility: visible;
            }
        }
    </style>
</head>
<body>

    <!-- Blobs overlay -->
    <div class="glow-bg-layer">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <!-- Include universal header -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div id="wrapper">
        <!-- Include general sidebar -->
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
        
        <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
            <div class="container hub-container">
                <div class="row">
            
            <!-- LEFT & CENTER FEED -->
            <div class="col-lg-8">
                
                <!-- Stories Carousel -->
                <div class="stories-container">
                    <c:if test="${empty storiesByUser}">
                        <div class="text-muted text-center w-100 py-3" style="font-size: 14px;">
                            <i class="fa-solid fa-circle-notch fa-spin me-2"></i> No active stories right now. Be the first to post!
                        </div>
                    </c:if>
                    
                    <c:forEach var="entry" items="${storiesByUser}">
                        <div class="story-avatar-wrapper" onclick="openStoryViewer(${entry.key.id}, '${entry.key.fullName}')">
                            <div class="story-ring">
                                <c:choose>
                                    <c:when test="${not empty entry.key.profilePhoto}">
                                        <img src="${entry.key.profilePhoto}" class="story-avatar" alt="story">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/assets/img/default-avatar.png" class="story-avatar" alt="story">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <span class="story-username">${entry.key.fullName}</span>
                        </div>
                    </c:forEach>
                </div>

                <!-- Category selector scroll -->
                <div class="d-flex align-items-center mb-4">
                    <button class="btn btn-sm btn-outline-secondary rounded-circle me-2" onclick="scrollCatLeft(this)">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <div class="category-scroll flex-grow-1" style="margin-bottom: 0 !important; overflow-x: auto; scroll-behavior: smooth;">
                        <a href="${pageContext.request.contextPath}/creator-hub" class="category-pill ${empty selectedCategory ? 'active' : ''}">All Feeds</a>
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/creator-hub?category=${cat}" class="category-pill ${selectedCategory eq cat ? 'active' : ''}">${cat}</a>
                        </c:forEach>
                    </div>
                    <button class="btn btn-sm btn-outline-secondary rounded-circle ms-2" onclick="scrollCatRight(this)">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <!-- Feed Items -->
                <c:if test="${empty feedContent}">
                    <div class="text-center py-5">
                        <i class="fa-solid fa-video-slash" style="font-size: 55px; color: var(--text-muted); opacity: 0.5; margin-bottom: 20px;"></i>
                        <h4 class="text-white">No Content Found</h4>
                        <p class="text-muted">Start following creators or choose a different category filter!</p>
                    </div>
                </c:if>

                <c:forEach var="post" items="${feedContent}">
                    <div class="post-card" id="post-${post.id}">
                        
                        <!-- Post Header -->
                        <div class="post-header">
                            <a href="${pageContext.request.contextPath}/creator-hub/creator/${post.user.id}" class="uploader-info">
                                <c:choose>
                                    <c:when test="${not empty post.user.profilePhoto}">
                                        <img src="${post.user.profilePhoto}" class="uploader-avatar" alt="avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/assets/img/default-avatar.png" class="uploader-avatar" alt="avatar">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="uploader-name">
                                        ${post.user.fullName}
                                        <c:if test="${post.user.verifiedCreator}">
                                            <i class="fa-solid fa-circle-check verified-badge" title="Verified Women Creator"></i>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty post.location}">
                                        <span class="post-location"><i class="fa-solid fa-location-dot me-1"></i>${post.location}</span>
                                    </c:if>
                                </div>
                            </a>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-secondary opacity-75" style="font-size: 11px;">${post.category}</span>
                                <span class="post-time"><i class="fa-regular fa-clock me-1"></i>${post.uploadTime}</span>
                            </div>
                        </div>

                        <!-- Post Media Container -->
                        <div class="post-media-container" onclick="triggerView(${post.id})">
                            <span class="badge-type">${post.reel ? 'REEL' : (post.fileType eq 'VIDEO' ? 'VIDEO' : 'IMAGE')}</span>
                            
                            <!-- Check Monetization Locks -->
                            <c:set var="subLockKey" value="subLocked_${post.id}" />
                            <c:set var="paidLockKey" value="paidLocked_${post.id}" />
                            <c:choose>
                                <c:when test="${requestScope[subLockKey]}">
                                    <div class="post-lock-overlay">
                                        <i class="fa-solid fa-lock lock-icon"></i>
                                        <h5 class="text-white">Subscriber Only Content</h5>
                                        <p class="text-muted text-sm px-4">This exclusive post is reserved for monthly subscribers. Unlock it to support the creator!</p>
                                        <button class="btn btn-danger btn-sm px-4 py-2 mt-2 rounded-pill shadow-lg" onclick="subscribeCreator(${post.user.id})">
                                            Subscribe to ${post.user.fullName}
                                        </button>
                                    </div>
                                </c:when>
                                <c:when test="${requestScope[paidLockKey]}">
                                    <div class="post-lock-overlay">
                                        <i class="fa-solid fa-graduation-cap lock-icon"></i>
                                        <h5 class="text-white">Premium Educational Course</h5>
                                        <p class="text-muted text-sm px-4">Unlock this paid educational video for Rs. ${post.price} to get lifetime access to skill-development content!</p>
                                        <button class="btn btn-warning btn-sm px-4 py-2 mt-2 text-dark font-weight-bold rounded-pill" onclick="unlockCourse(${post.id}, ${post.price})">
                                            Unlock Video for Rs. ${post.price}
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Render Media -->
                                    <c:choose>
                                        <c:when test="${post.fileType eq 'VIDEO'}">
                                            <video src="${post.videoPath}" controls loop preload="metadata"></video>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${post.videoPath}" alt="Post image">
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Post Footer & Interactions -->
                        <div class="post-footer">
                            <div class="post-actions">
                                <div class="action-group">
                                    <button class="action-btn ${post.likedByCurrentUser ? 'liked' : ''}" onclick="toggleLike(${post.id}, this)">
                                        <i class="${post.likedByCurrentUser ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
                                        <span id="like-count-${post.id}">${post.likeCount}</span>
                                    </button>
                                    
                                    <button class="action-btn" onclick="openComments(${post.id})">
                                        <i class="fa-regular fa-comment"></i>
                                        <span>Comment</span>
                                    </button>
                                    
                                    <button class="action-btn" onclick="sharePost(${post.id}, '${post.title}')">
                                        <i class="fa-regular fa-share-from-square"></i>
                                        <span>Share</span>
                                    </button>
                                </div>
                                
                                <c:set var="isBook" value="bookmarked_${post.id}" />
                                <button class="action-btn ${requestScope[isBook] ? 'bookmarked' : ''}" onclick="toggleBookmark(${post.id}, this)">
                                    <i class="${requestScope[isBook] ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
                                </button>
                            </div>

                            <h6 class="text-white mb-1 font-weight-bold">${post.title}</h6>
                            <p class="post-caption mb-2 text-white opacity-90">${post.description}</p>
                            <c:if test="${not empty post.hashtags}">
                                <div class="post-hashtags mb-2">${post.hashtags}</div>
                            </c:if>
                            
                            <!-- Affiliate link support -->
                            <c:if test="${not empty post.affiliateLink}">
                                <div class="mt-2 p-2 rounded" style="background: rgba(255,255,255,0.03); border: 1px dashed rgba(255,255,255,0.1)">
                                    <span class="text-muted text-xs d-block"><i class="fa-solid fa-tags text-warning me-1"></i>Sponsored Link / Recommended Product:</span>
                                    <a href="${post.affiliateLink}" target="_blank" class="text-info font-weight-bold" style="font-size: 14px; text-decoration: none;">
                                        Buy Recommended Item <i class="fa-solid fa-arrow-up-right-from-square ms-1" style="font-size: 11px;"></i>
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- RIGHT SIDEBAR -->
            <div class="col-lg-4">
                
                <!-- Quick Navigation Studio Buttons -->
                <div class="sidebar-card text-center">
                    <h5 class="sidebar-title justify-content-center mb-3">Creator Dashboard</h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/creator-hub/dashboard" class="btn btn-outline-danger py-2 rounded-pill">
                            <i class="fa-solid fa-clapperboard me-2"></i> Open Creator Studio
                        </a>
                        <a href="${pageContext.request.contextPath}/creator-hub/notifications" class="btn btn-outline-primary py-2 rounded-pill position-relative">
                            <i class="fa-regular fa-bell me-2"></i> Creator Notifications
                            <c:if test="${unreadNotifCount > 0}">
                                <span class="position-absolute top-50 start-100 translate-middle badge rounded-pill bg-danger">
                                    ${unreadNotifCount}
                                </span>
                            </c:if>
                        </a>
                        <a href="${pageContext.request.contextPath}/users/search?tab=requests" class="btn btn-outline-info py-2 rounded-pill position-relative">
                            <i class="fa-solid fa-user-plus me-2"></i> Let's Connect
                            <span id="pendingRequestsBadge" class="badge bg-danger ms-auto" style="display:none;">0</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/chat/users" class="btn btn-outline-primary py-2 rounded-pill">
                            <i class="fa-solid fa-message me-2"></i> Chat / DMs
                        </a>
                        
                        <!-- Show admin panel if admin is logged in -->
                        <c:if test="${not empty admin}">
                            <a href="${pageContext.request.contextPath}/creator-hub/admin" class="btn btn-danger py-2 rounded-pill mt-2">
                                <i class="fa-solid fa-shield-halved me-2"></i> Safety & Admin Board
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Search videos -->
                <div class="sidebar-card">
                    <h5 class="sidebar-title"><i class="fa-solid fa-magnifying-glass"></i> Search Hub</h5>
                    <form action="${pageContext.request.contextPath}/creator-hub" method="GET">
                        <div class="d-flex gap-2">
                            <input type="text" name="search" class="form-control bg-dark border-secondary text-white rounded-pill" placeholder="Search topics, hashtags..." value="${searchQuery}" style="flex: 1;">
                            <button class="btn btn-danger rounded-pill px-3" type="submit">
                                <i class="fa-solid fa-magnifying-glass"></i> Search
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Trending Topics -->
                <div class="sidebar-card">
                    <h5 class="sidebar-title"><i class="fa-solid fa-fire text-warning"></i> Trending Content</h5>
                    <c:forEach var="trPost" items="${trending}">
                        <a href="#post-${trPost.id}" class="trending-item">
                            <div>
                                <span class="d-block font-weight-bold" style="font-size: 14px;">${trPost.title}</span>
                                <span class="text-muted text-xs">${trPost.user.fullName}</span>
                            </div>
                            <span class="badge bg-dark text-muted"><i class="fa-regular fa-eye me-1"></i>${trPost.viewCount}</span>
                        </a>
                    </c:forEach>
                </div>

                <!-- Recommended creators -->
                <div class="sidebar-card">
                    <h5 class="sidebar-title"><i class="fa-solid fa-award text-info"></i> Verified Creators</h5>
                    <c:forEach var="rec" items="${recommendedCreators}">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <a href="${pageContext.request.contextPath}/creator-hub/creator/${rec.id}" class="uploader-info" style="gap: 10px;">
                                <c:choose>
                                    <c:when test="${not empty rec.profilePhoto}">
                                        <img src="${rec.profilePhoto}" style="width: 38px; height: 38px;" class="uploader-avatar" alt="avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/assets/img/default-avatar.png" style="width: 38px; height: 38px;" class="uploader-avatar" alt="avatar">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="uploader-name" style="font-size: 14px;">
                                        ${rec.fullName}
                                        <i class="fa-solid fa-circle-check verified-badge"></i>
                                    </div>
                                    <span class="text-muted" style="font-size: 11px;">Verified Creator</span>
                                </div>
                            </a>
                            <button class="btn btn-sm btn-outline-danger rounded-pill px-3 py-1" onclick="followCreator(${rec.id}, this)">
                                Follow
                            </button>
                        </div>
                    </c:forEach>
                </div>

            </div>

        </div>
    </div>

    <!-- Floating Create Action Button -->
    <a href="${pageContext.request.contextPath}/creator-hub/upload" class="fab-btn" title="Create / Upload Content">
        <i class="fa-solid fa-plus"></i>
    </a>

    <!-- COMMENTS SIDE-DRAWER -->
    <div class="comment-drawer" id="commentDrawer">
        <div class="comment-header">
            <h5 class="text-white m-0"><i class="fa-regular fa-comments text-danger me-2"></i>Comments</h5>
            <button class="btn-close btn-close-white" onclick="closeComments()"></button>
        </div>
        <div class="comment-list" id="commentList">
            <!-- Loaded via AJAX -->
        </div>
        <div class="comment-input-area">
            <div class="input-group">
                <input type="text" id="commentInput" class="form-control bg-dark border-secondary text-white rounded-start-pill" placeholder="Write a comment...">
                <button class="btn btn-danger rounded-end-pill px-3" onclick="submitComment()">
                    <i class="fa-solid fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- STORY VIEWER MODAL -->
    <div class="modal fade story-modal" id="storyViewerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
            <div class="modal-content bg-transparent border-0">
                <div class="modal-body p-4 bg-dark rounded-4 relative">
                    <div class="story-progress-container" id="storyProgressBarContainer">
                        <!-- Bars dynamically added -->
                    </div>
                    <div class="d-flex align-items-center justify-content-between mb-3 text-white">
                        <span id="storyViewerUsername" class="font-weight-bold">Creator Name</span>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="text-center rounded overflow-hidden bg-black" style="min-height: 480px; display: flex; align-items: center; justify-content: center;">
                        <img id="storyViewerImg" src="" style="max-width: 100%; max-height: 480px; object-fit: contain; display: none;">
                        <video id="storyViewerVideo" src="" style="max-width: 100%; max-height: 480px; object-fit: contain; display: none;" controls autoplay></video>
                    </div>
                    <p class="mt-3 text-white text-center opacity-90" id="storyViewerCaption"></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Story lists grouped by User ID
        const activeStoriesData = {};
        <c:forEach var="entry" items="${storiesByUser}">
            activeStoriesData["${entry.key.id}"] = [];
            <c:forEach var="story" items="${entry.value}">
                activeStoriesData["${entry.key.id}"].push({
                    mediaPath: "${story.mediaPath}",
                    fileType: "${story.fileType}",
                    caption: "${story.caption}"
                });
            </c:forEach>
        </c:forEach>

        let currentActiveStories = [];
        let currentStoryIndex = 0;
        let storyTimer = null;
        let activeCommentVideoId = null;

        // Open Stories Player
        function openStoryViewer(userId, username) {
            currentActiveStories = activeStoriesData[userId] || [];
            currentStoryIndex = 0;
            document.getElementById('storyViewerUsername').innerText = username;
            
            const modal = new bootstrap.Modal(document.getElementById('storyViewerModal'));
            modal.show();

            setupStoryBars();
            showStorySlide();
        }

        function setupStoryBars() {
            const container = document.getElementById('storyProgressBarContainer');
            container.innerHTML = '';
            currentActiveStories.forEach((s, idx) => {
                const bar = document.createElement('div');
                bar.className = 'story-progress-bar';
                bar.innerHTML = '<div class="story-progress-fill" id="story-fill-' + idx + '"></div>';
                container.appendChild(bar);
            });
        }

        function showStorySlide() {
            if (storyTimer) clearTimeout(storyTimer);
            if (currentStoryIndex >= currentActiveStories.length) {
                // Done with stories
                bootstrap.Modal.getInstance(document.getElementById('storyViewerModal')).hide();
                return;
            }

            // Reset progress bars
            for (let i = 0; i < currentActiveStories.length; i++) {
                const fill = document.getElementById('story-fill-' + i);
                if (fill) {
                    fill.style.width = (i < currentStoryIndex) ? '100%' : '0%';
                }
            }

            const current = currentActiveStories[currentStoryIndex];
            const imgEl = document.getElementById('storyViewerImg');
            const videoEl = document.getElementById('storyViewerVideo');
            const captionEl = document.getElementById('storyViewerCaption');

            captionEl.innerText = current.caption || '';

            if (current.fileType === 'VIDEO') {
                imgEl.style.display = 'none';
                videoEl.style.display = 'block';
                videoEl.src = current.mediaPath;
                videoEl.play();
                
                // Animate bar with video duration or default 8s
                animateProgressBar(currentStoryIndex, 8000);
                storyTimer = setTimeout(() => {
                    currentStoryIndex++;
                    showStorySlide();
                }, 8000);
            } else {
                videoEl.style.display = 'none';
                imgEl.style.display = 'block';
                imgEl.src = current.mediaPath;
                
                animateProgressBar(currentStoryIndex, 5000);
                storyTimer = setTimeout(() => {
                    currentStoryIndex++;
                    showStorySlide();
                }, 5000);
            }
        }

        function animateProgressBar(index, duration) {
            const fill = document.getElementById('story-fill-' + index);
            if (fill) {
                fill.style.width = '0%';
                setTimeout(() => {
                    fill.style.transition = 'width ' + duration + 'ms linear';
                    fill.style.width = '100%';
                }, 50);
            }
        }

        // Close modal resets timer
        document.getElementById('storyViewerModal').addEventListener('hidden.bs.modal', function () {
            if (storyTimer) clearTimeout(storyTimer);
            document.getElementById('storyViewerVideo').pause();
        });

        // VIEW INCREMENT LOGIC
        const viewedVideos = new Set();
        function triggerView(videoId) {
            if (viewedVideos.has(videoId)) return;
            viewedVideos.add(videoId);

            fetch('${pageContext.request.contextPath}/creator-hub/video/view-inc?videoId=' + videoId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                console.log("View count incremented");
            });
        }

        // LIKE LOGIC (AJAX)
        function toggleLike(videoId, btn) {
            fetch('/video/video/like?videoId=' + videoId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'LOGIN_REQUIRED') {
                    window.location.href = '/login';
                    return;
                }
                const countEl = document.getElementById('like-count-' + videoId);
                countEl.innerText = data.likeCount;

                if (data.liked) {
                    btn.classList.add('liked');
                    btn.querySelector('i').className = 'fa-solid fa-heart';
                } else {
                    btn.classList.remove('liked');
                    btn.querySelector('i').className = 'fa-regular fa-heart';
                }
            });
        }

        // BOOKMARK LOGIC
        function toggleBookmark(videoId, btn) {
            fetch('${pageContext.request.contextPath}/creator-hub/video/bookmark?videoId=' + videoId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'LOGIN_REQUIRED') {
                    window.location.href = '/login';
                    return;
                }
                if (data.bookmarked) {
                    btn.classList.add('bookmarked');
                    btn.querySelector('i').className = 'fa-solid fa-bookmark';
                } else {
                    btn.classList.remove('bookmarked');
                    btn.querySelector('i').className = 'fa-regular fa-bookmark';
                }
            });
        }

        // FOLLOW ACTIONS
        function followCreator(creatorId, btn) {
            fetch('${pageContext.request.contextPath}/creator-hub/creator/follow/' + creatorId, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'LOGIN_REQUIRED') {
                    window.location.href = '/login';
                    return;
                }
                if (data.status === 'FOLLOWED') {
                    btn.innerText = 'Following';
                    btn.className = 'btn btn-sm btn-danger rounded-pill px-3 py-1';
                } else if (data.status === 'REQUESTED') {
                    btn.innerText = 'Requested';
                    btn.className = 'btn btn-sm btn-secondary rounded-pill px-3 py-1';
                } else {
                    btn.innerText = 'Follow';
                    btn.className = 'btn btn-sm btn-outline-danger rounded-pill px-3 py-1';
                }
            });
        }

        // MONETIZATION TRIGGERS
        function subscribeCreator(creatorId) {
            if (confirm("Subscribe to this creator to unlock all subscriber-only posts? Subscription tier charges wallet balance monthly.")) {
                fetch('${pageContext.request.contextPath}/creator-hub/creator/subscribe?creatorId=' + creatorId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.error === 'INSUFFICIENT_FUNDS') {
                        alert("Insufficient funds in your safety wallet. Please recharge wallet.");
                    } else if (data.success) {
                        alert("Subscription unlocked successfully!");
                        window.location.reload();
                    } else {
                        alert("Error: " + data.error);
                    }
                });
            }
        }

        function unlockCourse(videoId, price) {
            if (confirm("Unlock this premium educational content for Rs. " + price + "? It will charge your wallet balance.")) {
                fetch('${pageContext.request.contextPath}/creator-hub/creator/unlock?videoId=' + videoId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if (data.error === 'INSUFFICIENT_FUNDS') {
                        alert("Insufficient wallet balance to purchase this video.");
                    } else if (data.success) {
                        alert("Video course unlocked successfully!");
                        window.location.reload();
                    } else {
                        alert("Error: " + data.error);
                    }
                });
            }
        }

        // COMMENTS ACTIONS
        function openComments(videoId) {
            activeCommentVideoId = videoId;
            document.getElementById('commentDrawer').classList.add('open');
            loadComments(videoId);
        }

        function closeComments() {
            document.getElementById('commentDrawer').classList.remove('open');
            activeCommentVideoId = null;
        }

        function loadComments(videoId) {
            const listEl = document.getElementById('commentList');
            listEl.innerHTML = '<div class="text-white text-center py-4"><i class="fa-solid fa-spinner fa-spin me-2"></i>Loading comments...</div>';

            fetch('${pageContext.request.contextPath}/video/comments/' + videoId)
            .then(res => res.text())
            .then(html => {
                // Parse and strip comments or load clean JSON
                // Since VideoUploadController returns JSP "video_comments" view, we can write an endpoint or parse list
                // To keep it simple, we'll fetch the clean comments list from our api or inject mock HTML.
                // Let's create an AJAX comments fetcher inside our controller or fetch from custom endpoint.
                // Wait! Let's mock a simple list here for immediate UI speed if API is rendering full JSPs, 
                // or fetch from VideoUploadController which returns /video/comments/{videoId} view.
                // To display it beautifully inside the Drawer, we can request /video/comments/{videoId} as text and extract comments.
                // Or let's make an AJAX endpoint in CreatorHubController to fetch comments!
                // Actually, let's write a quick AJAX endpoint in CreatorHubController if needed, 
                // but let's extract them from the returned text or write a dedicated AJAX method.
                // Let's do a simple fetch from a custom mock list or write a dedicated AJAX comments list.
                // Wait, we can fetch `/video/comments/{videoId}` which is returned as JSP.
                // A better way: Let's fetch clean comments. Let's make sure our script can parse them.
                // Actually, we can fetch the comments from a simple JSON API. Let's fetch comments from: `/creator-hub/video/comments?videoId=` which we can handle.
                // Let's implement /creator-hub/video/comments JSON endpoint in CreatorHubController!
                // Wait, I can modify CreatorHubController to support it, or I can just render comments.
                // Let's search inside comments.
                listEl.innerHTML = '';
                
                // Let's do a fetch call to `/video/comments/json/` if we want or just mock it.
                // Let's add `/creator-hub/comments-api?videoId=` JSON endpoint in the Controller to get clean comments.
                // Let's first mock some beautiful comments or extract them.
                // Let's fetch from `/video/comments/` JSON list or write a simple parser.
                // Actually, let's write a simple JSON endpoint in the controller:
                fetch('${pageContext.request.contextPath}/creator-hub/comments-api?videoId=' + videoId)
                .then(res => res.json())
                .then(comments => {
                    if (comments.length === 0) {
                        listEl.innerHTML = '<div class="text-muted text-center py-4">No comments yet. Start the conversation!</div>';
                        return;
                    }
                    comments.forEach(c => {
                        const item = document.createElement('div');
                        item.className = 'comment-item';
                        item.innerHTML = '<div class="comment-user">' + c.username + '</div>' + 
                                         '<div class="comment-text">' + c.text + '</div>';
                        listEl.appendChild(item);
                    });
                }).catch(() => {
                    listEl.innerHTML = '<div class="text-muted text-center py-4">No comments yet. Start the conversation!</div>';
                });
            });
        }

        function submitComment() {
            const input = document.getElementById('commentInput');
            const text = input.value.trim();
            if (!text || !activeCommentVideoId) return;

            const formData = new URLSearchParams();
            formData.append('videoId', activeCommentVideoId);
            formData.append('commentText', text);

            fetch('${pageContext.request.contextPath}/video/comment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.error === 'NOT_LOGGED_IN') {
                    window.location.href = '/login';
                    return;
                }
                input.value = '';
                loadComments(activeCommentVideoId);
            });
        }

        // SHARE POST
        function sharePost(videoId, title) {
            const shareUrl = window.location.origin + '${pageContext.request.contextPath}/creator-hub/creator/' + videoId; // link to profile
            navigator.clipboard.writeText(shareUrl).then(() => {
                alert("Link copied to clipboard: " + shareUrl);
            });
        }

        function scrollCatLeft(btn) {
            const container = btn.nextElementSibling;
            container.scrollBy({ left: -200, behavior: 'smooth' });
        }
        function scrollCatRight(btn) {
            const container = btn.previousElementSibling;
            container.scrollBy({ left: 200, behavior: 'smooth' });
        }
    </script>
        </div><!-- /#page-content-wrapper -->
    </div><!-- /#wrapper -->
</body>
</html>
