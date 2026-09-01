<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${event.name} — Women Events</title>
    <meta name="description" content="${event.description}"/>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    
    <!-- Event detail theme only — cream / plum / pink. No global palette. -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/detail-premium.css?v=20260901"/>
    <style>
        :root {
            --bg-primary: #FFF4F6;
            --bg-card: #FFFFFF;
            --bg-secondary: #FFF1F2;
            --border-neutral: #F3D4DC;
            --border-secondary: #FDA4AF;
            --color-accent: #F43F5E;
            --color-accent-hover: #E11D48;
            --text-primary: #2D142C;
            --text-secondary: #6B3A4A;
            --shadow-sm: 0 4px 12px rgba(45, 20, 44, 0.04);
            --shadow-md: 0 12px 30px rgba(45, 20, 44, 0.07);
            --shadow-lg: 0 20px 48px rgba(45, 20, 44, 0.1);
        }
        body, #page-content-wrapper {
            background-color: #FFF4F6 !important;
            color: #2D142C !important;
        }
        .event-hero { background: #2D142C !important; }
        .hero-overlay {
            background: linear-gradient(to top, rgba(45, 20, 44, 0.95) 0%, rgba(45, 20, 44, 0.5) 60%, transparent 100%) !important;
        }
        .block-title, .event-title, .sidebar-price, .feature-card h4, .timeline-content h4,
        .facilitator-info h4, .expect-item h5, .avg-rating-value, .reviewer-title-name,
        .breadcrumb-container .breadcrumb-item.active, .sidebar-meta-item .meta-value {
            color: #2D142C !important;
        }
        .register-sidebar,
        .mobile-sticky-action-bar {
            position: static !important;
            top: auto !important;
        }
        .feature-card, .feature-card:hover,
        .btn-premium-cta, .btn-premium-cta:hover,
        .gallery-card-item img, .gallery-card-item:hover img,
        .btn-map-guide, .btn-map-guide:hover {
            transform: none !important;
            transition: none !important;
        }
        .gallery-overlay-effect { background: rgba(45, 20, 44, 0.35) !important; }
        .registered-badge-box {
            background: #FFF1F2 !important;
            border-color: #FDA4AF !important;
            color: #F43F5E !important;
        }
        .avg-rating-stars, .rating-bar-fill, .review-stars-metric,
        .star-input input:checked ~ label,
        .star-input label:hover,
        .star-input label:hover ~ label {
            color: #F43F5E !important;
            background-color: #F43F5E;
        }
        .avg-rating-stars, .review-stars-metric { background-color: transparent !important; }
        .bottom-registration-cta {
            background: linear-gradient(135deg, #2D142C 0%, #4A1A3A 70%, #F43F5E 100%) !important;
        }
        #page-content-wrapper .text-primary,
        #page-content-wrapper .text-success,
        #page-content-wrapper .text-warning,
        #page-content-wrapper .text-danger { color: #F43F5E !important; }
        #page-content-wrapper .bg-success { background-color: #F43F5E !important; }
        #page-content-wrapper .bg-light { background-color: #FFF1F2 !important; }
        #page-content-wrapper a { color: #F43F5E; }
        #page-content-wrapper .btn-premium-cta,
        #page-content-wrapper .btn-share-pill { color: #FFFFFF !important; }
        .hero-featured-badge {
            background: rgba(244, 63, 94, 0.22);
            border: 1px solid #FDA4AF;
            padding: 2px 10px;
            border-radius: 99px;
            font-weight: 700;
            color: #FFFFFF;
        }
        .reserved-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #F43F5E;
            color: #FFFFFF;
            padding: 14px 28px;
            border-radius: 99px;
            font-weight: 700;
        }
        .btn-share-pill {
            background: #F43F5E;
            color: #FFFFFF !important;
            border: none;
            border-radius: 99px;
            padding: 8px 16px;
            font-weight: 700;
            text-decoration: none;
        }
        .btn-share-outline {
            background: transparent;
            color: #2D142C !important;
            border: 1px solid #FDA4AF;
        }
        @media (max-width: 991px) {
            .detail-grid { padding-bottom: 40px !important; }
            .mobile-sticky-action-bar { display: block; position: static !important; }
        }
    </style>
    <!-- Custom Theme & Detail Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-events-tokens.css"/>
    <jsp:include page="/WEB-INF/views/women-events/we-tokens-inline.jsp"/>
    <style>
      .we-modal-overlay { display:none; position:fixed; inset:0; background:rgba(15,23,42,.45); z-index:2000; align-items:center; justify-content:center; padding:20px; }
      .we-modal-overlay.open { display:flex; }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/detail-premium.css"/>
</head>
<body>

<!-- Header Component -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <!-- Sidebar Component -->
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip;">

        <!-- Alert Banners -->
        <c:if test="${not empty success}">
            <div class="flash-alert alert alert-dismissible fade show m-3" role="alert" style="background:#FFF1F2; border:1px solid #FDA4AF; color:#2D142C; border-radius: 12px;">
                <i class="bi bi-check-circle-fill me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-alert alert alert-dismissible fade show m-3" role="alert" style="background:#FFF1F2; border:1px solid #F43F5E; color:#2D142C; border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Premium Hero Section -->
        <div class="event-hero">
            <c:choose>
                <c:when test="${not empty event.bannerImage}">
                    <img src="${pageContext.request.contextPath}/uploads/${event.bannerImage}" alt="${event.name}"/>
                </c:when>
                <c:otherwise>
                    <!-- Fallback abstract premium background pattern if banner is missing -->
                    <div style="position: absolute; inset: 0; background: linear-gradient(135deg, #2D142C 0%, #4A1A3A 55%, #F43F5E 100%);"></div>
                    <div style="position: absolute; inset: 0; background: linear-gradient(135deg, #0F172A 0%, #1E293B 60%, #F43F5E 140%);"></div>
                </c:otherwise>
            </c:choose>
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <span class="hero-cat-badge">
                    <i class="bi bi-bookmark-heart-fill"></i> ${event.category.displayName}
                </span>
                <h1 class="event-title">${event.name}</h1>
                <div class="hero-meta">
                    <span><i class="bi bi-calendar3"></i> ${event.eventDate} <c:if test="${not empty event.eventTime}">at ${event.eventTime}</c:if></span>
                    <span><i class="bi bi-geo-alt-fill"></i> ${event.venue}, ${event.city}</span>
                    <span><i class="bi bi-building-fill-check"></i> By ${event.organizerName}</span>
                    <c:if test="${event.featured}">
                        <span class="hero-featured-badge">
                            <i class="bi bi-star-fill"></i> Featured
                        </span>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb" style="font-size:0.88rem; margin: 0;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events">Events</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events?category=${event.category}">${event.category.displayName}</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${event.name}</li>
                </ol>
            </nav>
        </div>

        <!-- Two-Column Page Layout -->
        <div class="detail-grid">
            
            <!-- Left Grid: Event Contents -->
            <div class="main-content-column">
                
                <!-- About Block -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-info-circle-fill"></i> About The Event</div>
                    <p style="color: var(--text-primary); font-size: 1.05rem; line-height: 1.8; white-space: pre-line; margin-bottom: 0;">
                        <c:choose>
                            <c:when test="${not empty event.description}">${event.description}</c:when>
                            <c:otherwise>Not provided</c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="card-block">
                    <div class="block-title"><i class="bi bi-calendar-event"></i> Event details</div>
                    <div class="we-fact-grid">
                        <div class="we-fact"><div class="k">Date</div><div class="v">${not empty event.eventDate ? event.eventDate : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Time</div><div class="v">${not empty event.eventTime ? event.eventTime : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Venue</div><div class="v">${not empty event.venue ? event.venue : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">City</div><div class="v">${not empty event.city ? event.city : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Mode</div><div class="v">${event.virtual ? 'Online' : 'In person'}</div></div>
                        <div class="we-fact"><div class="k">Capacity</div><div class="v">${event.maxParticipants != null ? event.maxParticipants : 'Not limited'}</div></div>
                        <div class="we-fact"><div class="k">Entry</div><div class="v"><c:choose><c:when test="${event.free}">Free</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></div></div>
                        <div class="we-fact"><div class="k">Registered</div><div class="v">${registrationCount}</div></div>
                    </div>
                    <c:if test="${event.virtual && not empty event.streamLink}">
                        <p class="mt-3 mb-0 small text-muted">Stream link is shared with registered attendees.</p>
                    </c:if>
                </div>

                <div class="card-block">
                    <div class="block-title"><i class="bi bi-building"></i> Organizer</div>
                    <div class="we-fact-grid">
                        <div class="we-fact"><div class="k">Name</div><div class="v">${not empty event.organizerName ? event.organizerName : 'Not provided'}</div></div>
                        <div class="we-fact"><div class="k">Type</div><div class="v">${not empty event.organizerType ? event.organizerType : 'Not provided'}</div></div>
                        <div class="we-fact" style="grid-column:1 / -1;"><div class="k">Contact</div><div class="v">${not empty event.contactInfo ? event.contactInfo : 'Not provided'}</div></div>
                    </div>
                </div>

                <!-- Map & Directions -->
                <c:if test="${not empty event.mapsLocation}">
                    <div class="card-block">
                        <div class="block-title"><i class="bi bi-map-fill"></i> Location &amp; Directions</div>
                        <div class="map-container">
                            <iframe class="map-frame"
                                    src="https://maps.google.com/maps?q=${event.mapsLocation}&output=embed"
                                    allowfullscreen loading="lazy"></iframe>
                            <div class="map-address-block">
                                <div>
                                    <h5 class="fw-bold mb-1" style="color: var(--text-primary); font-size: 1rem;"><i class="bi bi-geo-alt-fill me-1" style="color:#F43F5E;"></i> ${event.venue}</h5>
                                    <p class="text-muted small mb-0">${event.city}, Safe Zone Mapping Enabled</p>
                                    <h5 class="fw-bold mb-1" style="color: var(--text-primary); font-size: 1rem;"><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${event.venue}</h5>
                                    <p class="text-muted small mb-0">${not empty event.city ? event.city : 'Not provided'}</p>
                                </div>
                                <a href="https://maps.google.com/maps?q=${event.mapsLocation}" target="_blank" class="btn-map-guide">
                                    <i class="bi bi-box-arrow-up-right"></i> Get Directions
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Photo Gallery section -->
                <div class="card-block">
                    <div class="block-title">
                        <i class="bi bi-images"></i> Photo Gallery 
                        <span class="count-pill">${photos.size()} Files</span>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty photos}">
                            <div class="premium-gallery">
                                <c:forEach var="ph" items="${photos}">
                                    <div class="gallery-card-item" data-bs-toggle="modal" data-bs-target="#photoModal"
                                         onclick="document.getElementById('modalPhoto').src=this.querySelector('img').src">
                                        <img src="${pageContext.request.contextPath}/uploads/${ph.photoPath}" alt="${ph.caption}"/>
                                        <div class="gallery-overlay-effect">
                                            <i class="bi bi-zoom-in"></i>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="gallery-empty">
                                <i class="bi bi-flower1"></i>
                                <h5>No Gallery Photos Yet</h5>
                                <p>Be the first to share your positive visual experience from this event!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Upload Zone (if registered & event passed) -->
                    <c:if test="${alreadyRegistered && eventPassed && not empty loggedUser}">
                        <hr style="margin: 32px 0; border-color: var(--border-neutral);"/>
                        <div class="block-title" style="font-size:1.05rem;"><i class="bi bi-cloud-upload-fill"></i> Add Photo to Event Gallery</div>
                        <form action="${pageContext.request.contextPath}/women-events/${event.id}/upload-photo" method="post" enctype="multipart/form-data">
                            <div class="upload-zone" onclick="document.getElementById('photoFile').click()">
                                <i class="bi bi-camera-fill" style="font-size:2rem; color:var(--color-accent); display:block; margin-bottom:8px;"></i>
                                <div style="font-weight:700; color:var(--text-primary);">Click to pick a photo</div>
                                <div class="text-muted small">PNG, JPG or JPEG files up to 5MB supported</div>
                            </div>
                            <input type="file" id="photoFile" name="photo" accept="image/*" style="display:none;" required 
                                   onchange="this.form.querySelector('.upload-zone div').textContent=this.files[0].name"/>
                            <input type="text" name="caption" class="form-control mt-3" placeholder="Write a short photo caption (optional)"/>
                            <button type="submit" class="btn-premium-cta mt-3" style="padding: 12px 24px; font-size: 0.95rem; max-width: 250px;">
                                <i class="bi bi-cloud-arrow-up-fill"></i> Upload Image file
                            </button>
                        </form>
                    </c:if>
                </div>

                <!-- Reviews and Rating Section -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-star-fill"></i> Ratings &amp; Reviews</div>
                    
                    <div class="reviews-summary-box">
                        <div>
                            <div class="avg-rating-value">${avgRating > 0 ? avgRating : '—'}</div>
                            <div class="avg-rating-stars">
                                <c:forEach begin="1" end="${avgRating.intValue() > 0 ? avgRating.intValue() : 0}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                <c:forEach begin="${(avgRating.intValue() > 0 ? avgRating.intValue() : 0) + 1}" end="5" var="s"><i class="bi bi-star star-empty"></i></c:forEach>
                            </div>
                            <div class="text-muted text-center mt-2 small" style="font-weight: 600;">${reviews.size()} review${reviews.size() != 1 ? 's' : ''}</div>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <div class="reviews-list-container">
                                <c:forEach var="rev" items="${reviews}">
                                    <div class="premium-review-card">
                                        <div class="review-card-header">
                                            <div class="reviewer-avatar-box">
                                                <div class="reviewer-avatar">${rev.user.fullName.substring(0,1).toUpperCase()}</div>
                                                <div>
                                                    <div class="reviewer-title-name">${rev.user.fullName}</div>
                                                    <div class="review-stars-metric">
                                                        <c:forEach begin="1" end="${rev.rating}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                                        <c:forEach begin="${rev.rating + 1}" end="5" var="s"><i class="bi bi-star star-empty"></i></c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="review-item-date">${rev.createdAt}</div>
                                        </div>
                                        <div class="review-body-text">${rev.reviewText}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 rounded-4" style="background: var(--bg-secondary); border: 1px dashed var(--border-neutral);">
                                <i class="bi bi-chat-heart text-muted mb-2" style="font-size: 2rem;"></i>
                                <p class="text-muted small mb-0">No reviews published yet for this event.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Critique Submission Form (registered & passed event) -->
                    <c:if test="${alreadyRegistered && eventPassed && not alreadyReviewed && not empty loggedUser}">
                        <hr style="margin: 32px 0; border-color: var(--border-neutral);"/>
                        <div class="block-title" style="font-size: 1.05rem;"><i class="bi bi-chat-quote-fill"></i> Share Your Review</div>
                        <form action="${pageContext.request.contextPath}/women-events/${event.id}/review" method="post">
                            <div class="mb-3">
                                <label class="form-label small text-muted font-weight-bold">Rate this Workshop</label>
                                <div class="star-input">
                                    <input type="radio" id="s5" name="rating" value="5" required/><label for="s5">★</label>
                                    <input type="radio" id="s4" name="rating" value="4"/><label for="s4">★</label>
                                    <input type="radio" id="s3" name="rating" value="3"/><label for="s3">★</label>
                                    <input type="radio" id="s2" name="rating" value="2"/><label for="s2">★</label>
                                    <input type="radio" id="s1" name="rating" value="1"/><label for="s1">★</label>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small text-muted font-weight-bold">Feedback Details</label>
                                <textarea name="reviewText" rows="4" required class="form-control" placeholder="Share how the event went for you..."></textarea>
                            </div>
                            <button type="submit" class="btn-premium-cta" style="max-width: 250px; padding: 12px 24px; font-size: 0.95rem;">
                                <i class="bi bi-send-fill"></i> Submit review
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- Right Grid: Sticky Registration/Details Sidebar -->
            <div class="sidebar-column">
                <div class="register-sidebar">
                    
                    <div class="sidebar-card">
                        <div class="sidebar-price"><c:choose><c:when test="${event.free}">FREE</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></div>
                        <div class="sidebar-price-sub">${event.free ? 'No entry fee' : 'Entry fee — paid at checkout'}</div>

                        <div class="sidebar-meta-list">
                            <div class="sidebar-meta-item">
                                <i class="bi bi-people-fill"></i>
                                <div>
                                    <div class="meta-label">Registered</div>
                                    <div class="meta-value">${registrationCount}<c:if test="${not empty event.maxParticipants}"> / ${event.maxParticipants}</c:if></div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-calendar3"></i>
                                <div>
                                    <div class="meta-label">Date</div>
                                    <div class="meta-value">${not empty event.eventDate ? event.eventDate : 'Not provided'}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-clock-fill"></i>
                                <div>
                                    <div class="meta-label">Time</div>
                                    <div class="meta-value">${not empty event.eventTime ? event.eventTime : 'Not provided'}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-geo-alt-fill"></i>
                                <div>
                                    <div class="meta-label">Venue</div>
                                    <div class="meta-value">${not empty event.venue ? event.venue : 'Not provided'}<c:if test="${not empty event.city}">, ${event.city}</c:if></div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-telephone-fill"></i>
                                <div>
                                    <div class="meta-label">Contact</div>
                                    <div class="meta-value">${not empty event.contactInfo ? event.contactInfo : 'Not provided'}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="sidebar-action-button-layer">
                            <c:choose>
                                <c:when test="${empty loggedUser}">
                                    <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta">
                                        <i class="bi bi-person-circle"></i> Login to Register
                                    </a>
                                </c:when>
                                <c:when test="${alreadyRegistered}">
                                    <div class="registered-badge-box">
                                        <i class="bi bi-check-circle-fill"></i>
                                        <h5>Registration Active</h5>
                                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="ticket-link">
                                            <i class="bi bi-ticket-perforated-fill"></i> View My Ticket
                                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="btn btn-sm btn-link text-success fw-bold text-decoration-none mt-1">
                                            <i class="bi bi-ticket-perforated-fill"></i> View my ticket
                                        </a>
                                    </div>
                                </c:when>
                                <c:when test="${soldOut}">
                                    <button class="btn-premium-cta" disabled>
                                        <i class="bi bi-x-circle-fill"></i> SOLD OUT
                                    </button>
                                </c:when>
                                <c:when test="${registrationOpen == false}">
                                    <button class="btn-premium-cta" disabled>
                                        Registration for this event has closed.
                                    </button>
                                </c:when>
                                <c:when test="${eventPassed}">
                                    <button class="btn-premium-cta" disabled>
                                        <i class="bi bi-x-circle-fill"></i> Event has passed
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${event.free}">
                                            <form action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="width: 100%;">
                                                <c:if test="${not empty coinQuote}">
                                                    <p class="small text-muted mb-2">Coins available: ${coinQuote.availableCoins}. Max redeemable: ${coinQuote.maxRedeemableCoins}.</p>
                                                    <input type="number" name="coins" min="0" max="${coinQuote.maxRedeemableCoins}" value="0" class="form-control mb-2" placeholder="Coins to apply"/>
                                                </c:if>
                                                <button type="submit" class="btn-premium-cta">
                                                    <i class="bi bi-ticket-perforated-fill"></i> Claim Free Ticket
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-premium-cta" onclick="openEventCheckoutModal()">
                                                <i class="bi bi-ticket-perforated-fill"></i> Secure Claim — ₹${event.entryFee}
                                            </button>
                                            <form id="eventRegisterForm" action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="display:none;"></form>
                                        </c:otherwise>
                                    </c:choose>
=======
                                    <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                                        <i class="bi bi-ticket-perforated-fill"></i>
                                        <c:choose>
                                            <c:when test="${event.free}">Review &amp; register</c:when>
                                            <c:otherwise>Review &amp; pay ₹${event.entryFee}</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <form id="eventRegisterForm" action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="display:none;"></form>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr style="margin: 24px 0; border-color: var(--border-neutral);"/>
                        <div class="sidebar-extra">
                            <p class="mb-1"><i class="bi bi-shield-lock-fill"></i> Highly secure identity protection system</p>
                            <p class="mb-0"><i class="bi bi-ticket-detailed-fill"></i> Digital secure ticket code issued instantly</p>
                            <p class="mb-1"><i class="bi bi-ticket-detailed-fill" style="color:var(--we-accent);"></i> A ticket code is issued after registration</p>
                            <p class="mb-0"><i class="bi bi-shield-check" style="color:var(--we-success);"></i> Show your ticket at entry</p>
                        </div>
                    </div>

                    <!-- Share Event Card structure -->
                    <div class="sidebar-card">
                        <h5 class="share-title"><i class="bi bi-share-fill"></i> Spread the Word</h5>
                        <div class="share-links-wrapper">
                            <a href="https://wa.me/?text=Check+out+this+workshop:+${event.name}+at+${pageContext.request.contextPath}/women-events/${event.id}"
                               target="_blank" class="btn-share-pill"><i class="bi bi-whatsapp"></i> Share on WhatsApp</a>
                            <button type="button" onclick="navigator.clipboard.writeText(window.location.href).then(()=>alert('Link copied!'))"
                                    class="btn-share-pill btn-share-outline"><i class="bi bi-link-45deg"></i> Copy Details Link</button>
                        </div>
                    </div>

                </div>
            </div>
            
        </div>

        <!-- Full-Width Bottom Registration CTA Banner -->
        <div class="container px-3 pb-5" style="max-width: 1200px; margin: 0 auto;">
            <div class="bottom-registration-cta">
                <h3>Register for ${event.name}</h3>
                <p>Review your booking details, then confirm. A ticket code is issued after registration.</p>
                <c:choose>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta">
                            <i class="bi bi-person-circle"></i> Login and register
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <div class="reserved-pill">
                            <i class="bi bi-check-circle-fill"></i> Seat Reserved &amp; Confirmed
                        </div>
                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="btn-premium-cta">
                            <i class="bi bi-ticket-perforated-fill"></i> View my ticket
                        </a>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="background:#555;">Event complete</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()">
                            <i class="bi bi-ticket-perforated-fill"></i> Review &amp; register
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Mobile Sticky Bottom Buy Row -->
        <div class="mobile-sticky-action-bar">
            <div class="mobile-sticky-inner">
                <div class="mobile-price-section">
                    <span class="mobile-price-value"><c:choose><c:when test="${event.free}">FREE</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></span>
                    <span class="mobile-price-lbl">Entry</span>
                </div>
                <c:choose>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
                            <i class="bi bi-person-circle"></i> Login
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <span class="reserved-pill compact"><i class="bi bi-check-circle-fill me-1"></i> Registered</span>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="padding: 12px 24px; font-size: 0.9rem; width: auto;">Passed</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventReviewModal()" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
                            <i class="bi bi-ticket-perforated-fill"></i> Register
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Lightbox Photo Viewer Modal -->
        <div class="modal fade" id="photoModal" tabindex="-1" style="backdrop-filter: blur(10px);">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 bg-transparent">
                    <div class="modal-body p-0 text-center">
                        <img id="modalPhoto" src="" style="max-width:100%; border-radius:16px; max-height:85vh; box-shadow: var(--shadow-lg); border: 2px solid white;"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- Booking review -->
        <div id="weReviewOverlay" class="we-modal-overlay" onclick="if(event.target===this)closeEventReviewModal()">
            <div class="we-modal" role="dialog" aria-labelledby="weReviewTitle">
                <div class="we-modal-header">
                    <div>
                        <h3 id="weReviewTitle">Review registration</h3>
                        <p>Confirm these details before submitting. Quantity is 1 attendee ticket.</p>
                    </div>
                    <button type="button" class="we-modal-close" onclick="closeEventReviewModal()" aria-label="Close">&times;</button>
                </div>
                <div class="we-modal-body">
                    <div class="we-modal-row"><span class="k">Event</span><span class="v">${event.name}</span></div>
                    <div class="we-modal-row"><span class="k">Organizer</span><span class="v">${not empty event.organizerName ? event.organizerName : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Date</span><span class="v">${not empty event.eventDate ? event.eventDate : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Time</span><span class="v">${not empty event.eventTime ? event.eventTime : 'Not provided'}</span></div>
                    <div class="we-modal-row"><span class="k">Venue</span><span class="v">${not empty event.venue ? event.venue : 'Not provided'}<c:if test="${not empty event.city}">, ${event.city}</c:if></span></div>
                    <div class="we-modal-row"><span class="k">Attendee</span><span class="v">${not empty loggedUser.fullName ? loggedUser.fullName : 'Signed-in user'}</span></div>
                    <div class="we-modal-row"><span class="k">Ticket</span><span class="v">1 × attendee</span></div>
                    <div class="we-modal-row"><span class="k">Amount</span><span class="v"><c:choose><c:when test="${event.free}">Free</c:when><c:otherwise>₹${event.entryFee}</c:otherwise></c:choose></span></div>
                </div>
                <div class="we-modal-footer">
                    <button type="button" class="we-modal-btn secondary" onclick="closeEventReviewModal()">Edit</button>
                    <button type="button" class="we-modal-btn primary" id="weConfirmRegisterBtn" onclick="confirmEventRegistration()">
                        <c:choose>
                            <c:when test="${event.free}">Confirm registration</c:when>
                            <c:otherwise>Continue to payment</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </div>
        </div>

        <!-- Razorpay Sim Gateway Modal -->
        <div class="modal fade" id="eventCheckoutModal" tabindex="-1" aria-hidden="true" style="backdrop-filter: blur(8px);">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 450px;">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; background: #ffffff;">
                    <!-- Modal Header -->
                    <div class="modal-header border-0 pb-0" style="padding: 24px 24px 0;">
                        <div class="d-flex align-items-center">
                            <div style="background: #fff1f2; color: #f43f5e; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; border: 1px solid var(--we-border);">
                                <i class="bi bi-wallet2"></i>
                            </div>
                            <div class="ms-3">
                                <h5 class="modal-title fw-bold" style="color: #2D142C; font-size: 1.15rem; font-family:'Outfit',sans-serif;">Razorpay Secure Gateway</h5>
                                <h5 class="modal-title fw-bold" style="color: #0F172A; font-size: 1.15rem; font-family:'Outfit',sans-serif;">Razorpay Secure Gateway</h5>
                                <p class="text-muted small mb-0" style="font-size:0.75rem;">Simulated Test Transaction Mode</p>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="box-shadow: none;"></button>
                    </div>
                    <!-- Modal Body -->
                    <div class="modal-body py-4" style="padding: 24px;">
                        <div class="p-3 mb-4" style="background: #f8fafc; border-radius: 16px; border: 1px solid #e2e8f0;">
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Event ticket</span>
                                <span class="fw-bold">₹${event.entryFee}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Processing/Internet charge</span>
                                <span class="fw-bold" style="color:#F43F5E;">₹0.00</span>
                            </div>
                            <hr style="border-style: dashed; margin: 12px 0;">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-semibold" style="color: #2D142C;">Total Payment</span>
                                <span class="fs-5 fw-bold" style="font-family:'Outfit',sans-serif;color:#F43F5E;">₹${event.entryFee}</span>
                                <span>Processing charge</span>
                                <span class="fw-bold" style="color:#16A34A;">₹0.00</span>
                            </div>
                            <hr style="border-style: dashed; margin: 12px 0;">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-semibold" style="color: #0F172A;">Total</span>
                                <span class="fs-5 fw-bold" style="font-family:'Outfit',sans-serif; color:#0F172A;">₹${event.entryFee}</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted mb-1 font-weight-bold">Choose Payment Method</label>
                            <div class="d-grid gap-2">
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #FDA4AF; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="upi" checked class="me-3">
                                    <i class="bi bi-qr-code me-2" style="font-size:1.15rem;color:#F43F5E;"></i> UPI (PhonePe / GPay / Paytm / BHIM)
                                    <i class="bi bi-qr-code me-2" style="font-size:1.15rem; color:#F43F5E;"></i> UPI (PhonePe / GPay / Paytm / BHIM)
                                </div>
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #FDA4AF; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="card" class="me-3">
                                    <i class="bi bi-credit-card me-2" style="font-size:1.15rem;color:#F43F5E;"></i> Credit or Debit Card checkout
                                    <i class="bi bi-credit-card me-2" style="font-size:1.15rem; color:#16A34A;"></i> Credit or Debit Card checkout
                                </div>
                            </div>
                        </div>
                        <div id="eventOtpSection" style="display:none;" class="mt-3">
                            <label class="form-label small mb-1 font-weight-bold" style="color:#F43F5E;">Simulated Authentication OTP (Enter 123456)</label>
                            <input type="text" id="eventOtpInput" class="form-control text-center fs-5 fw-bold" maxlength="6" placeholder="------" style="letter-spacing: 5px;">
                            <div class="small mt-1 text-center" id="eventOtpError" style="display:none; font-weight: 600; color:#F43F5E;">Invalid verification OTP! Use simulated 123456 code.</div>
                        </div>
                    </div>
                    <!-- Modal Footer -->
                    <div class="modal-footer border-0 pt-0" style="padding: 0 24px 24px;">
                        <button type="button" class="btn-share-outline w-100 mb-2 rounded-pill small" data-bs-dismiss="modal" style="padding:10px;">Cancel Transaction</button>
                        <button type="button" class="btn-premium-cta" id="eventPayBtn" onclick="processEventBookingPayment()">
                        <button type="button" class="btn btn-outline-secondary w-100 mb-2 rounded-pill small" data-bs-dismiss="modal">Cancel Transaction</button>
                        <button type="button" class="btn w-100 rounded-pill fw-semibold py-2 btn-premium-cta" id="eventPayBtn" onclick="processEventBookingPayment()" style="background: var(--we-accent); border: none; box-shadow: none;">
                            Proceed Payment of ₹${event.entryFee} Securely
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script>
            var weEventIsFree = ${event.free};
            var weSubmitting = false;

            setTimeout(() => {
                document.querySelectorAll('.flash-alert').forEach(el => {
                    el.style.transition='opacity 0.5s'; el.style.opacity='0';
                    setTimeout(()=>el.remove(),500);
                });
            }, 4000);

            function openEventReviewModal() {
                document.getElementById('weReviewOverlay').classList.add('open');
            }
            function closeEventReviewModal() {
                document.getElementById('weReviewOverlay').classList.remove('open');
            }
            function confirmEventRegistration() {
                if (weSubmitting) return;
                closeEventReviewModal();
                if (weEventIsFree) {
                    submitEventRegisterForm();
                } else {
                    openEventCheckoutModal();
                }
            }
            function submitEventRegisterForm() {
                if (weSubmitting) return;
                var form = document.getElementById('eventRegisterForm');
                if (!form) return;
                weSubmitting = true;
                var btn = document.getElementById('weConfirmRegisterBtn');
                if (btn) { btn.disabled = true; btn.textContent = 'Submitting…'; }
                form.submit();
            }
            function openEventCheckoutModal() {
                var modal = new bootstrap.Modal(document.getElementById('eventCheckoutModal'));
                modal.show();
            }

            var eventPaymentStep = 1;
            function processEventBookingPayment() {
                if (eventPaymentStep === 1) {
                    document.getElementById('eventOtpSection').style.display = 'block';
                    document.getElementById('eventPayBtn').textContent = 'Verify simulated OTP';
                    eventPaymentStep = 2;
                } else if (eventPaymentStep === 2) {
                    var otp = document.getElementById('eventOtpInput').value;
                    if (otp === '123456') {
                        document.getElementById('eventOtpError').style.display = 'none';
                        submitEventRegisterForm();
                    } else {
                        document.getElementById('eventOtpError').style.display = 'block';
                    }
                }
            }
        </script>
    </div>
</div>
</body>
</html>
