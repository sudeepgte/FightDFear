<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Proposal — Fight D Fear</title>
    <!-- Premium Google Fonts matching index.jsp -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* Hide fragment header to prevent dark blue header override */
        #header {
            display: none !important;
        }

        :root {
            --bg-page: #FFF8FA;          /* Soft Blush background matching screenshot */
            --bg-card: #FFFFFF;
            --text-plum: #1E1B4B;         /* Dark navy/plum text */
            --text-muted-custom: #64748B;
            --brand-pink: #F33F5E;        /* Flame pink / primary */
            --brand-pink-hover: #D92545;
            --pink-soft-bg: #FFEBF0;      /* Active sidebar pill bg */
            --gold-accent: #F59E0B;
            --border-light: #FCE8EB;
            --border-muted: #FCE8EB;
            --white: #FFFFFF;
            --font-main: 'Outfit', sans-serif;
            --font-serif: 'Playfair Display', serif;
        }

        body {
            font-family: var(--font-main);
            background-color: var(--bg-page);
            color: var(--text-plum);
            overflow-x: hidden;
            width: 100vw;
            margin: 0;
        }

        /* Top Header Navbar */
        .top-navbar {
            height: 70px;
            background: #FFFFFF;
            border-bottom: 1px solid #FCE8EB;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1020;
        }

        .top-brand {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 800;
            font-size: 1.35rem;
            color: var(--text-plum);
            text-decoration: none;
        }

        .top-brand i {
            color: var(--brand-pink);
            font-size: 1.5rem;
        }

        .top-nav-links {
            display: flex;
            gap: 32px;
            align-items: center;
        }

        .top-nav-link {
            text-decoration: none;
            color: #475569;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 22px 0;
            position: relative;
        }

        .top-nav-link.active {
            color: var(--brand-pink);
        }

        .top-nav-link.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--brand-pink);
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
        }

        .top-user-area {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .notification-btn {
            position: relative;
            background: transparent;
            border: none;
            color: #475569;
            font-size: 1.2rem;
            cursor: pointer;
        }

        .notification-btn .badge-count {
            position: absolute;
            top: -4px;
            right: -6px;
            background: var(--brand-pink);
            color: white;
            font-size: 0.65rem;
            font-weight: 700;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #FCE8EB;
        }

        /* Layout Container */
        #wrapper {
            display: flex;
            width: 100%;
            padding-top: 70px;
        }

        /* Left Sidebar */
        #sidebar-wrapper {
            width: 240px;
            background: #FFF8FA;
            color: var(--text-plum);
            height: calc(100vh - 70px);
            position: fixed;
            top: 70px;
            left: 0;
            z-index: 1000;
            padding: 24px 16px;
            border-right: 1px solid #FCE8EB;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .sidebar-heading {
            padding: 0 12px 20px;
            font-size: 1.15rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-plum);
            border-bottom: 1px solid #FCE8EB;
            margin-bottom: 16px;
        }

        .sidebar-heading i {
            color: var(--brand-pink);
            font-size: 1.2rem;
        }

        .sidebar-link {
            background: transparent;
            color: #475569;
            padding: 12px 16px;
            font-size: 0.95rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
            transition: all 0.2s;
            border-radius: 12px;
            margin-bottom: 4px;
        }

        .sidebar-link:hover {
            color: var(--brand-pink);
            background: #FFEBF0;
        }

        .sidebar-link.active {
            color: var(--brand-pink);
            background: #FFEBF0;
            font-weight: 700;
        }

        .sidebar-link i {
            font-size: 1.15rem;
        }

        /* Bottom Sidebar Illustration */
        .sidebar-illustration {
            margin-top: auto;
            padding-top: 20px;
            text-align: center;
        }

        .sidebar-illustration svg, .sidebar-illustration img {
            max-width: 100%;
            height: auto;
        }

        /* Page Content Wrapper */
        #page-content-wrapper {
            margin-left: 240px;
            flex: 1;
            min-width: 0;
            padding: 32px 40px;
            min-height: calc(100vh - 70px);
            background-color: var(--bg-page);
        }
        
        .mobile-nav-toggle {
            display: none;
        }
        
        @media (max-width: 992px) {
            #sidebar-wrapper {
                margin-left: -240px;
            }
            #wrapper.toggled #sidebar-wrapper {
                margin-left: 0;
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 20px;
                width: 100%;
            }
            .mobile-nav-toggle {
                display: block;
                position: relative;
                z-index: 1050;
                margin-bottom: 15px !important;
            }
            .top-nav-links { display: none; }
        }

        /* Form Container */
        .form-container {
            background: #FFFFFF;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(30, 27, 75, 0.04);
            border: 1px solid var(--border-muted);
            max-width: 1100px;
            margin: 0;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1.5px solid var(--border-muted);
            padding: 10px 15px;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 3px rgba(243, 63, 94, 0.15);
        }

        .btn-submit {
            background: var(--brand-pink);
            color: white;
            border: none;
            padding: 12px 30px;
            font-weight: 700;
            border-radius: 30px;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(243, 63, 94, 0.25);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            background: var(--brand-pink-hover);
            box-shadow: 0 8px 20px rgba(243, 63, 94, 0.35);
            color: white;
        }

        .btn-mobile-menu {
            background-color: var(--brand-pink);
            color: white;
            border: none;
        }
        .btn-mobile-menu:hover {
            background-color: var(--brand-pink-hover);
            color: white;
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

<!-- Hidden header for global background scripts (WebRTC, broadcasts) -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<!-- Top Navbar Header -->
<div class="top-navbar">
    <a href="${pageContext.request.contextPath}/" class="top-brand">
        <i class="bi bi-fire"></i> Fight D Fear
    </a>
    
    <div class="top-nav-links">
        <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="top-nav-link">Home</a>
        <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="top-nav-link">My Bookings</a>
        <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="top-nav-link">Wallet</a>
    </div>

    <div class="top-user-area">
        <button type="button" class="notification-btn" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()">
            <i class="bi bi-bell-fill"></i>
            <c:if test="${unreadBroadcastCount > 0}">
                <span class="badge-count">${unreadBroadcastCount}</span>
            </c:if>
            <c:if test="${empty unreadBroadcastCount || unreadBroadcastCount == 0}">
                <span class="badge-count">3</span>
            </c:if>
        </button>

        <div class="user-pill dropdown">
            <c:choose>
                <c:when test="${not empty entrepreneur.profilePhoto}">
                    <img src="${pageContext.request.contextPath}${entrepreneur.profilePhoto}" alt="User" class="user-avatar">
                </c:when>
                <c:otherwise>
                    <div class="user-avatar bg-warning text-dark fw-bold d-flex align-items-center justify-content-center">
                        ${entrepreneur.fullName != null ? entrepreneur.fullName.substring(0,1) : (loggedEntrepreneur.fullName != null ? loggedEntrepreneur.fullName.substring(0,1) : 'S')}
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="d-none d-sm-block text-start">
                <div class="fw-bold" style="font-size: 0.9rem; line-height: 1.1; color: var(--text-plum);">${entrepreneur.fullName != null ? entrepreneur.fullName : (loggedEntrepreneur.fullName != null ? loggedEntrepreneur.fullName : 'Sindhu')}</div>
                <div class="small text-muted" style="font-size: 0.75rem;">Entrepreneur</div>
            </div>
            <i class="bi bi-chevron-down text-muted small ms-1"></i>
        </div>
    </div>
</div>

<div id="wrapper">
    <!-- Left Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        
        <div class="d-flex flex-column" style="flex: 1;">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-house-door-fill"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/chat/0" class="sidebar-link">
                <i class="bi bi-chat-left-dots-fill"></i> Chat
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link active">
                <i class="bi bi-plus-square-fill"></i> Create Proposal
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="sidebar-link">
                <i class="bi bi-calendar-event-fill"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <a href="#" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()" class="sidebar-link">
                <i class="bi bi-bell-fill"></i> Notifications
                <span class="badge bg-brand-pink rounded-circle ms-auto" style="font-size:0.7rem;">3</span>
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/profile-completion" class="sidebar-link">
                <i class="bi bi-person-circle"></i> My Profile
            </a>

            <hr style="border-top: 1px solid #FCE8EB; margin: 12px 0;">

            <a href="${pageContext.request.contextPath}/entrepreneur/logout" class="sidebar-link text-brand-pink">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>

    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <button class="btn btn-mobile-menu d-lg-none mobile-nav-toggle shadow-sm px-3 mb-4 rounded-3" id="menu-toggle">
            <i class="bi bi-list fs-5"></i> Menu
        </button>
        <div class="form-container">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="text-secondary text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <h3 class="fw-bold mb-4" style="color: var(--navy-dark);">Create New Business Proposal</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/entrepreneur/proposal/create" method="post" enctype="multipart/form-data">
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Proposal Title *</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Expansion of Tailoring Shop" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Category *</label>
                        <select name="category" class="form-select" required>
                            <option value="">Select Category</option>
                            <option value="Tea Shop">Tea Shop</option>
                            <option value="Fruits Shop">Fruits Shop</option>
                            <option value="Tailoring Shop">Tailoring Shop</option>
                            <option value="Beauty Salon">Beauty Salon</option>
                            <option value="Homemade Food Business">Homemade Food Business</option>
                            <option value="Pickle Business">Pickle Business</option>
                            <option value="Boutique">Boutique</option>
                            <option value="Candle Making">Candle Making</option>
                            <option value="Soap Making">Soap Making</option>
                            <option value="Dairy Business">Dairy Business</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Location *</label>
                        <input type="text" name="location" class="form-control" placeholder="City or State" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Investment Needed (₹) *</label>
                        <input type="number" name="fundingNeeded" class="form-control" min="1" placeholder="Total funding requested" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Expected Monthly Income (₹) *</label>
                        <input type="number" name="expectedMonthlyIncome" class="form-control" min="1" placeholder="Expected profit/income" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Business Description *</label>
                        <textarea name="description" class="form-control" rows="5" placeholder="Detailed business model, growth plan, and usage of funds..." required></textarea>
                    </div>
                </div>

                <h5 class="fw-bold mb-3" style="color: var(--navy-dark); border-bottom: 1px solid #cbd5e1; padding-bottom:8px;">Media Attachments</h5>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Upload Business Photos *</label>
                        <input type="file" name="photos" class="form-control" accept="image/*" multiple required>
                        <div class="form-text text-muted">Select one or more images representing your business location or products.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Upload Business Documents *</label>
                        <input type="file" name="documents" class="form-control" accept=".pdf,.doc,.docx" multiple required>
                        <div class="form-text text-muted">Select licensing, registration, or business plan documents.</div>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Video Pitch (Optional)</label>
                        <input type="file" name="videoPitch" class="form-control" accept="video/*">
                        <div class="form-text text-muted">Upload a video explaining your pitch to investors directly.</div>
                    </div>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-submit">Submit Proposal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- BROADCAST NOTIFICATIONS MODAL -->
<div class="modal fade" id="broadcastModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-header border-0 pb-0 pt-4 px-4">
                <div class="d-flex align-items-center gap-2">
                    <div class="p-2 rounded-circle bg-soft-pink text-brand-pink fs-5 d-flex align-items-center justify-content-center" style="width:38px; height:38px;">
                        <i class="bi bi-bell-fill"></i>
                    </div>
                    <div>
                        <h6 class="modal-title fw-bold m-0" style="color: var(--text-plum);">Platform Notifications</h6>
                        <span class="text-muted small" style="font-size:12px;">Stay updated on opportunities & announcements</span>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="d-flex flex-column gap-3">
                    <div class="p-3 rounded-3 border bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold text-brand-pink small"><i class="bi bi-megaphone-fill me-1"></i> Admin Announcement</span>
                            <span class="text-muted" style="font-size: 11px;">Today</span>
                        </div>
                        <p class="m-0 text-dark small">Welcome to the Fight D Fear Entrepreneur Portal! Complete your profile verification to connect with active investors.</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 pb-4 px-4">
                <button type="button" class="btn w-100 rounded-pill py-2 text-white fw-bold" style="background-color: var(--brand-pink);" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function markBroadcastsAsRead() {
        const badge = document.querySelector('.badge-count');
        if (badge) {
            badge.style.display = 'none';
        }
    }

    // Mobile Sidebar Toggle
    const toggleBtn = document.getElementById('menu-toggle');
    if(toggleBtn) {
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
        });
    }
</script>
</body>
</html>
