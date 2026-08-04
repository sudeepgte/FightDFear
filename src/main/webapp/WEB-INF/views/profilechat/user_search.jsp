<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Connect with Members — Fight D Fear</title>
    
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
        .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
        .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
        
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
            color: var(--brand-purple);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }
        .top-btn:hover {
            background: var(--brand-purple);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Category Scroll Bar */
        .cat-scroll-wrap {
            display: flex;
            align-items: center;
            gap: 8px;
            max-width: 920px;
            width: 100%;
            margin: 30px auto 0;
            padding: 0 4px;
        }
        .cat-scroll-container {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: 0;
            overflow-x: auto;
            overflow-y: hidden;
            white-space: nowrap;
            scroll-behavior: smooth;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none;
            padding: 4px 12px 12px;
            justify-content: flex-start;
        }
        .cat-scroll-container::-webkit-scrollbar {
            display: none;
        }
        .cat-scroll-btn {
            flex-shrink: 0;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }
        .btn-cat-pill {
            padding: 8px 20px;
            border-radius: 999px;
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--fdf-muted);
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            flex-shrink: 0;
        }
        .btn-cat-pill:hover, .btn-cat-pill.active {
            background: var(--gradient-primary);
            color: #fff;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2);
        }

        /* User Cards layout */
        .social-container {
            max-width: 1000px;
            margin: 40px auto 60px;
            padding: 0 15px;
        }
        .tab-content.d-none {
            display: none !important;
        }
        .tab-content {
            display: block;
        }
        .social-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
        }
        .user-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px 15px;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff5f7;
            border: 3px solid var(--brand-pink-light);
            margin-bottom: 12px;
        }
        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .user-card h5 {
            font-size: 15px;
            font-weight: 800;
            color: var(--brand-purple);
            margin-bottom: 12px;
        }
        .user-card form, .user-card a {
            width: 100%;
        }
        .btn-social {
            width: 100%;
            padding: 8px 12px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            text-decoration: none !important;
        }
        .btn-social-primary {
            background: var(--gradient-primary);
            color: #fff;
        }
        .btn-social-primary:hover {
            filter: brightness(1.1);
            color: #fff;
        }
        .btn-social-outline {
            background: #fff;
            border: 1px solid var(--fdf-border);
            color: var(--brand-purple);
        }
        .btn-social-outline:hover {
            background: var(--brand-purple);
            color: #fff;
            border-color: transparent;
        }
        .btn-social-danger {
            background: #fee2e2;
            color: #dc2626;
        }
        .btn-social-danger:hover {
            background: #dc2626;
            color: #fff;
        }

        /* Groups card specific */
        .group-card {
            background: var(--card-bg);
            border: 1px solid var(--fdf-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .group-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--brand-pink-light);
        }
        .group-avatar {
            width: 60px;
            height: 60px;
            border-radius: 14px;
            overflow: hidden;
            border: 1px solid var(--fdf-border);
        }
        .group-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        @media (max-width: 768px) {
            .glow-header { padding-top: 30px; padding-bottom: 20px; }
            .cat-scroll-wrap {
                max-width: 100%;
                padding: 0 8px;
                gap: 4px;
            }
            .cat-scroll-container {
                padding: 4px 8px 10px;
            }
            .btn-cat-pill {
                font-size: 12px;
                padding: 7px 14px;
            }
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
            .cat-scroll-container {
                justify-content: flex-start;
                padding: 10px 15px;
            }
            .social-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
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
            
            <h1>Let's Connect</h1>
            <p>Welcome, ${currentUser.fullName}. Grow your circle, start interactive chat threads with friends, or organize customized chat groups.</p>
            
            <!-- Connection Tabs Menu -->
            <div class="cat-scroll-wrap">
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollCatLeft(this)" aria-label="Scroll tabs left">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <div class="cat-scroll-container" id="catScrollContainer">
                    <button id="btn-followers" class="btn-cat-pill active" onclick="switchTab('followers')">
                        Followers (${followers != null ? followers.size() : 0})
                    </button>
                    <button id="btn-following" class="btn-cat-pill" onclick="switchTab('following')">
                        Following (${following != null ? following.size() : 0})
                    </button>
                    <button id="btn-friends" class="btn-cat-pill" onclick="switchTab('friends')">
                        Friends (${friends != null ? friends.size() : 0})
                    </button>
                    <button id="btn-groups" class="btn-cat-pill" onclick="switchTab('groups')">
                        Groups (${groups != null ? groups.size() : 0})
                    </button>
                    <button id="btn-requests" class="btn-cat-pill" onclick="switchTab('requests')">
                        Requests (${followRequests != null ? followRequests.size() : 0})
                    </button>
                    <button id="btn-search" class="btn-cat-pill" onclick="switchTab('search')">
                        <i class="bi bi-search"></i> Search Members
                    </button>
                </div>
                <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle cat-scroll-btn" onclick="scrollCatRight(this)" aria-label="Scroll tabs right">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>
        </div>

        <div class="social-container" id="main-content">
            
            <!-- 🧍 FOLLOWERS TAB -->
            <div id="followers" class="tab-content">
                <h4 class="mb-4 fw-bold text-dark"><i class="bi bi-people-fill me-2 text-primary"></i> Followers</h4>
                <div class="social-grid">
                    <c:forEach var="f" items="${followers}">
                        <div class="user-card">
                            <div class="user-avatar">
                                <img src="${pageContext.request.contextPath}${f.profilePhoto}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                                     alt="${f.fullName}">
                            </div>
                            <h5>${f.fullName}</h5>
                            <div class="d-flex flex-column gap-2 w-100">
                                <c:choose>
                                    <c:when test="${followingStatus[f.id]}">
                                        <span class="badge bg-success py-2 rounded-pill mb-1">Mutual Friend</span>
                                        <a href="${pageContext.request.contextPath}/chat/window/${f.id}" class="btn-social btn-social-outline">💬 Chat</a>
                                    </c:when>
                                    <c:when test="${pendingStatus[f.id]}">
                                        <button type="button" class="btn-social btn-social-outline" disabled>⏳ Requested</button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/users/follow/${f.id}" method="post">
                                            <input type="hidden" name="tab" value="followers">
                                            <button class="btn-social btn-social-primary">➕ Follow Back</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty followers}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">No followers yet. Publish content in the Creator Hub to get noticed!</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 👣 FOLLOWING TAB -->
            <div id="following" class="tab-content d-none">
                <h4 class="mb-4 fw-bold text-dark"><i class="bi bi-person-check-fill me-2 text-primary"></i> Following</h4>
                <div class="social-grid">
                    <c:forEach var="f" items="${following}">
                        <div class="user-card">
                            <div class="user-avatar">
                                <img src="${pageContext.request.contextPath}${f.profilePhoto}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                                     alt="${f.fullName}">
                            </div>
                            <h5>${f.fullName}</h5>
                            <div class="d-flex flex-column gap-2 w-100">
                                <c:if test="${friends.contains(f)}">
                                    <a href="${pageContext.request.contextPath}/chat/window/${f.id}" class="btn-social btn-social-outline mb-1">💬 Chat</a>
                                </c:if>
                                <form action="${pageContext.request.contextPath}/users/unfollow/${f.id}" method="post">
                                    <button class="btn-social btn-social-danger">❌ Unfollow</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty following}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">You aren't following anyone yet. Search for members to connect!</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 👥 FRIENDS TAB -->
            <div id="friends" class="tab-content d-none">
                <h4 class="mb-4 fw-bold text-dark"><i class="bi bi-heart-fill me-2 text-primary"></i> Mutual Friends</h4>
                <div class="social-grid">
                    <c:forEach var="f" items="${friends}">
                        <div class="user-card">
                            <div class="user-avatar">
                                <img src="${pageContext.request.contextPath}${f.profilePhoto}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                                     alt="${f.fullName}">
                            </div>
                            <h5>${f.fullName}</h5>
                            <div class="d-flex flex-column gap-2 w-100">
                                <a href="${pageContext.request.contextPath}/chat/window/${f.id}" class="btn-social btn-social-outline">💬 Chat</a>
                                <form action="${pageContext.request.contextPath}/users/unfollow/${f.id}" method="post">
                                    <button class="btn-social btn-social-danger">❌ Unfriend</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty friends}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">No mutual friends yet. Mutual friends are contacts who follow each other back.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 📁 GROUPS TAB -->
            <div id="groups" class="tab-content d-none">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="mb-0 fw-bold text-dark"><i class="bi bi-collection-fill me-2 text-primary"></i> Groups</h4>
                    <button class="btn btn-social btn-social-primary w-auto px-4" data-bs-toggle="modal" data-bs-target="#createGroupModal">
                        <i class="bi bi-plus-circle"></i> Create Group
                    </button>
                </div>
                
                <div class="row g-4">
                    <c:forEach var="group" items="${groups}">
                        <div class="col-md-6 col-lg-4">
                            <div class="group-card">
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <div class="group-avatar">
                                        <img src="${pageContext.request.contextPath}${group.photoPath}"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-group.png';"
                                             alt="${group.name}">
                                    </div>
                                    <div>
                                        <h5 class="mb-0 text-dark" style="font-size: 16px; font-weight:800;">${group.name}</h5>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 mt-auto">
                                    <a href="${pageContext.request.contextPath}/users/groups/view/${group.id}" class="btn-social btn-social-outline text-center flex-grow-1">
                                        View Chat
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty groups}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">No groups created yet. Create a group to chat with multiple friends.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 🔔 REQUESTS TAB -->
            <div id="requests" class="tab-content d-none">
                <h4 class="mb-4 fw-bold text-dark"><i class="bi bi-bell-fill me-2 text-primary"></i> Connection Requests</h4>
                <div class="social-grid">
                    <c:forEach var="req" items="${followRequests}">
                        <div class="user-card">
                            <div class="user-avatar">
                                <img src="${pageContext.request.contextPath}${req.profilePhoto}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                                     alt="${req.fullName}">
                            </div>
                            <h5>${req.fullName}</h5>
                            <div class="d-flex flex-column gap-2 w-100 mt-2">
                                <form action="${pageContext.request.contextPath}/users/acceptRequest/${req.id}" method="post">
                                    <button class="btn-social btn-social-primary">✓ Accept</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/users/declineRequest/${req.id}" method="post">
                                    <button class="btn-social btn-social-danger">✗ Decline</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty followRequests}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">No pending connection requests.</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 🔍 SEARCH TAB -->
            <div id="search" class="tab-content d-none">
                <h4 class="mb-4 fw-bold text-dark"><i class="bi bi-search me-2 text-primary"></i> Search Members</h4>
                
                <form action="${pageContext.request.contextPath}/users/search" method="get" class="mb-4 filter-card">
                    <input type="hidden" name="tab" value="search">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-9">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                                <input type="text" name="keyword" value="${keyword}" class="form-control bg-light border-0" placeholder="Search by name or email...">
                            </div>
                        </div>
                        <div class="col-md-3 d-grid">
                            <button type="submit" class="btn-social btn-social-primary py-2.5">Find Member</button>
                        </div>
                    </div>
                </form>

                <div class="social-grid">
                    <c:forEach var="u" items="${users}">
                        <div class="user-card">
                            <div class="user-avatar">
                                <img src="${pageContext.request.contextPath}${u.profilePhoto}"
                                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-profile.png';"
                                     alt="${u.fullName}">
                            </div>
                            <h5>${u.fullName}</h5>
                            <div class="d-flex flex-column gap-2 w-100">
                                <c:choose>
                                    <c:when test="${followingStatus[u.id]}">
                                        <button class="btn-social btn-social-outline" disabled>✓ Friends</button>
                                    </c:when>
                                    <c:when test="${pendingStatus[u.id]}">
                                        <button class="btn-social btn-social-outline" disabled>⏳ Pending</button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/users/follow/${u.id}" method="post">
                                            <input type="hidden" name="tab" value="search">
                                            <input type="hidden" name="keyword" value="${keyword}">
                                            <button class="btn-social btn-social-primary">➕ Connect</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty users && not empty keyword}">
                        <div class="col-12 text-center py-5 text-muted bg-white rounded-4 border border-1 border-light">
                            <p class="mb-0">No members matched your search query. Try another keyword!</p>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    </div><!-- /#page-content-wrapper -->
</div><!-- /#wrapper -->

<!-- 🆕 Create Group Modal -->
<div class="modal fade" id="createGroupModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
            <div class="modal-header px-4 py-3 border-0 bg-light">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-collection-fill me-2 text-primary"></i> Create Group</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/users/groups/create" method="post" enctype="multipart/form-data">
                <div class="modal-body p-4 bg-white">
                    <!-- Photo -->
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small text-uppercase">Group Image</label>
                        <input type="file" name="groupPhoto" accept="image/*" class="form-control" required>
                    </div>
                    
                    <!-- Group Name -->
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small text-uppercase">Group Name</label>
                        <input type="text" name="groupName" class="form-control" placeholder="Enter group name..." required>
                    </div>
                    
                    <!-- Friends List -->
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small text-uppercase">Add Friends</label>
                        <div class="p-2 border rounded-3 bg-light" style="max-height: 180px; overflow-y: auto;">
                            <c:forEach var="f" items="${friends}">
                                <div class="form-check p-1 mb-1 border-bottom">
                                    <input class="form-check-input" type="checkbox" name="memberIds" value="${f.id}" id="friendModal-${f.id}">
                                    <label class="form-check-label ms-2 small fw-bold text-dark" for="friendModal-${f.id}">
                                        ${f.fullName}
                                    </label>
                                </div>
                            </c:forEach>
                            <c:if test="${empty friends}">
                                <div class="text-center py-3 text-muted small">No friends available to add.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer px-4 py-3 border-0 bg-light d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4" style="background: var(--brand-purple); border: none;">Create Group</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true
    });

    function getCatScrollContainer() {
        return document.getElementById('catScrollContainer');
    }

    function scrollActiveTabIntoView() {
        const container = getCatScrollContainer();
        const active = container ? container.querySelector('.btn-cat-pill.active') : null;
        if (!container || !active) return;

        const tabLeft = active.offsetLeft;
        const tabRight = tabLeft + active.offsetWidth;
        const viewLeft = container.scrollLeft;
        const viewRight = viewLeft + container.clientWidth;

        if (tabLeft < viewLeft + 8) {
            container.scrollTo({ left: Math.max(0, tabLeft - 12), behavior: 'smooth' });
        } else if (tabRight > viewRight - 8) {
            container.scrollTo({ left: tabRight - container.clientWidth + 12, behavior: 'smooth' });
        }
    }

    function switchTab(tabId, shouldScroll = true) {
        document.querySelectorAll('.tab-content').forEach(tab => tab.classList.add('d-none'));
        const targetTab = document.getElementById(tabId);
        if(targetTab) targetTab.classList.remove('d-none');
        
        document.querySelectorAll('.btn-cat-pill').forEach(btn => btn.classList.remove('active'));
        const btn = document.getElementById('btn-' + tabId);
        if(btn) btn.classList.add('active');

        scrollActiveTabIntoView();

        if(shouldScroll) {
            const target = document.getElementById('main-content');
            if(target) target.scrollIntoView({ behavior: 'smooth' });
        }
    }

    (function () {
        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        const keyword = urlParams.get('keyword');
        const initialTab = "${activeTab}";

        if (tabParam) {
            switchTab(tabParam, true);
        } else if (keyword) {
            switchTab('search', true);
        } else if (initialTab) {
            switchTab(initialTab, true);
        }

        window.addEventListener('load', function() {
            scrollActiveTabIntoView();
        });
    })();

    function scrollCatLeft(btn) {
        const container = getCatScrollContainer();
        if (!container) return;
        const step = Math.max(container.clientWidth * 0.8, 200);
        if (container.scrollLeft <= step) {
            container.scrollTo({ left: 0, behavior: 'smooth' });
        } else {
            container.scrollBy({ left: -step, behavior: 'smooth' });
        }
    }

    function scrollCatRight(btn) {
        const container = getCatScrollContainer();
        if (!container) return;
        const step = Math.max(container.clientWidth * 0.8, 200);
        const maxScroll = container.scrollWidth - container.clientWidth;
        if (container.scrollLeft >= maxScroll - step) {
            container.scrollTo({ left: maxScroll, behavior: 'smooth' });
        } else {
            container.scrollBy({ left: step, behavior: 'smooth' });
        }
    }
</script>

<!-- SockJS + Stomp Live updates Reload -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
    (function(){
        const userId = ${currentUser.id};
        const socket = new SockJS('${pageContext.request.contextPath}/ws-chat');
        const client = Stomp.over(socket);
        client.debug = null;

        client.connect({}, function(){
            client.subscribe("/topic/follow/" + userId, function(frame){
                try{
                    const evt = JSON.parse(frame.body || "{}");
                    if (evt && evt.type === "FOLLOW_STATE_CHANGED") {
                        window.location.reload();
                    }
                }catch(e){}
            });
        });
    })();
</script>

</body>
</html>
