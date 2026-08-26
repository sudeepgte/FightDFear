<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
    <!-- Custom Theme & Detail Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css"/>
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
            <div class="flash-alert alert alert-success alert-dismissible fade show m-3" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 9999; border-radius: 12px; box-shadow: var(--shadow-md);">
                <i class="bi bi-check-circle-fill me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash-alert alert alert-danger alert-dismissible fade show m-3" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 9999; border-radius: 12px; box-shadow: var(--shadow-md);">
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
                    <div style="position: absolute; inset: 0; background: linear-gradient(135deg, #1e1b4b 0%, #3F1430 50%, #f43f5e 100%);"></div>
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
                        <span style="background: rgba(245, 158, 11, 0.2); border: 1px solid #f59e0b; padding: 2px 10px; border-radius: 99px; font-weight: 700; color: #fbbf24;">
                            <i class="bi bi-star-fill" style="color:#fbbf24;"></i> Featured
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
                        ${event.description}
                    </p>
                </div>

                <!-- Feature Program Cards -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-stars"></i> What You'll Experience</div>
                    <div class="features-grid">
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-activity"></i></div>
                            <h4>Mental Wellness</h4>
                            <p>Interactive sessions focused on stress release, positive affirmation, and mindfulness techniques.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-egg-fried"></i></div>
                            <h4>Nutrition &amp; Diet</h4>
                            <p>Actionable coaching from dietitians for hormone balancing, nutrient-rich meal patterns, and energy.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-heart-pulse"></i></div>
                            <h4>Self-Care Rut</h4>
                            <p>Practical self-care journals, guided routines, and wellness checklists for home and workplace.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-fingerprint"></i></div>
                            <h4>Confidence Building</h4>
                            <p>Assertiveness drills, posture tuning, and public projection skills to build absolute self-assurance.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-shield-check"></i></div>
                            <h4>Women's Health Info</h4>
                            <p>Guidance on critical health checkups, preventive cycles, and daily physiological longevity.</p>
                        </div>
                        <div class="feature-card">
                            <div class="feature-icon-wrapper"><i class="bi bi-people"></i></div>
                            <h4>Safe Community</h4>
                            <p>Connect with a compassionate local network of motivated organizers, speakers, and participants.</p>
                        </div>
                    </div>
                </div>

                <!-- Schedule timeline -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-clock-history"></i> Workshop Schedule</div>
                    <div class="timeline-track">
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">09:30 AM – 10:00 AM</div>
                            <div class="timeline-content">
                                <h4>Reception &amp; Welcome Tea</h4>
                                <p>Arrival registration, welcome kit allocation, ice breaker bonding, and morning wellness refreshments.</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">10:00 AM – 11:30 AM</div>
                            <div class="timeline-content">
                                <h4>Mindfulness &amp; Self-Discovery</h4>
                                <p>Session led by Dr. Sarah Chen on stress control, digital boundary setup, and mental wellness pathways.</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">11:30 AM – 01:00 PM</div>
                            <div class="timeline-content">
                                <h4>Integrative Women's Nutrition</h4>
                                <p>Interactive food-mapping guide, active meal logs, and dietary planning session for optimal vitality.</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">01:00 PM – 02:00 PM</div>
                            <div class="timeline-content">
                                <h4>Healthy Organic Lunch</h4>
                                <p>Chef-cured superfoods lunch, networking conversation exchange, and safety partner community sharing.</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">02:00 PM – 03:30 PM</div>
                            <div class="timeline-content">
                                <h4>Confidence &amp; Boundless Self-Care</h4>
                                <p>Interactive workshop from Meera Joshi showing self-love triggers, boundary setting, and positive posture.</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-badge">03:30 PM – 04:30 PM</div>
                            <div class="timeline-content">
                                <h4>Gynecology &amp; Lifecycle Wellness Q&amp;A</h4>
                                <p>Open floor question-and-answer cycle on longevity, hormonal stages, clinical indicators, and physical health.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Facilitator profiles block -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-people-fill"></i> Meet Your Facilitators</div>
                    <div class="facilitator-item">
                        <div class="facilitator-avatar"><i class="bi bi-person-hearts"></i></div>
                        <div class="facilitator-info">
                            <div class="facilitator-role">Keynote Speaker</div>
                            <h4>Dr. Sarah Chen, PhD</h4>
                            <p class="facilitator-desc">Renowned clinical psychologist and health advocate with 14 years supporting female stressors, digital burnouts, and mindfulness therapies internationally.</p>
                        </div>
                    </div>
                    <div class="facilitator-item">
                        <div class="facilitator-avatar"><i class="bi bi-person-fill-check"></i></div>
                        <div class="facilitator-info">
                            <div class="facilitator-role">Co-Host / Coach</div>
                            <h4>Meera Joshi</h4>
                            <p class="facilitator-desc">Distinguished corporate assertiveness coach and organizer of the local self-care movement, specialized in women's leadership workshops and barrier mapping.</p>
                        </div>
                    </div>
                </div>

                <!-- What to Expect checklist -->
                <div class="card-block">
                    <div class="block-title"><i class="bi bi-patch-check-fill"></i> Useful Preparation</div>
                    <div class="expect-grid">
                        <div class="expect-item">
                            <i class="bi bi-journal-check"></i>
                            <div>
                                <h5>Comfortable Dress</h5>
                                <p>Wear casual attire suitable for micro-stretches and seating.</p>
                            </div>
                        </div>
                        <div class="expect-item">
                            <i class="bi bi-pen-fill"></i>
                            <div>
                                <h5>Notebook Included</h5>
                                <p>We provide wellness journals and session maps at entry.</p>
                            </div>
                        </div>
                        <div class="expect-item">
                            <i class="bi bi-brightness-high-fill"></i>
                            <div>
                                <h5>Arrival timing</h5>
                                <p>Please arrive 15 minutes early for registrations.</p>
                            </div>
                        </div>
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
                                    <h5 class="fw-bold mb-1" style="color: var(--text-primary); font-size: 1rem;"><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${event.venue}</h5>
                                    <p class="text-muted small mb-0">${event.city}, Safe Zone Mapping Enabled</p>
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
                        <span class="badge bg-secondary text-dark ms-2 font-weight-bold" style="font-size:0.75rem; border: 1px solid var(--border-secondary);">${photos.size()} Files</span>
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
                    <div class="block-title"><i class="bi bi-star-fill text-warning"></i> Ratings &amp; Reviews</div>
                    
                    <div class="reviews-summary-box">
                        <div>
                            <div class="avg-rating-value">${avgRating > 0 ? avgRating : '0.0'}</div>
                            <div class="avg-rating-stars">
                                <c:forEach begin="1" end="${avgRating.intValue() > 0 ? avgRating.intValue() : 0}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                <c:forEach begin="${(avgRating.intValue() > 0 ? avgRating.intValue() : 0) + 1}" end="5" var="s"><i class="bi bi-star star-empty"></i></c:forEach>
                            </div>
                            <div class="text-muted text-center mt-2 small" style="font-weight: 600;">${reviews.size()} Total Reviews</div>
                        </div>
                        <div class="rating-bar-chart">
                            <!-- Simulated distribution bar rates for clean dashboard feel -->
                            <div class="rating-chart-row">
                                <span>5 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width: 80%;"></div></div>
                                <span class="text-muted small">80%</span>
                            </div>
                            <div class="rating-chart-row">
                                <span>4 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width: 15%;"></div></div>
                                <span class="text-muted small">15%</span>
                            </div>
                            <div class="rating-chart-row">
                                <span>3 ★</span>
                                <div class="rating-bar-track"><div class="rating-bar-fill" style="width: 5%;"></div></div>
                                <span class="text-muted small">5%</span>
                            </div>
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
                            <div class="text-center py-4 bg-light rounded-4" style="border: 1px dashed var(--border-neutral);">
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
                                <textarea name="reviewText" rows="4" required class="form-control" placeholder="Tell us how the workshop impacted you, the host organization, and facilitators..."></textarea>
                            </div>
                            <button type="submit" class="btn-premium-cta" style="max-width: 250px; padding: 12px 24px; font-size: 0.95rem;">
                                <i class="bi bi-send-fill"></i> Submit Workshop Review
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <!-- Right Grid: Sticky Registration/Details Sidebar -->
            <div class="sidebar-column">
                <div class="register-sidebar">
                    
                    <div class="sidebar-card">
                        <div class="sidebar-price">${event.free ? 'FREE' : '₹'.concat(event.entryFee.toString())}</div>
                        <div class="sidebar-price-sub">${event.free ? 'Free wellness community event' : 'Entry fee - Payable at checkout'}</div>

                        <div class="sidebar-meta-list">
                            <div class="sidebar-meta-item">
                                <i class="bi bi-people-fill"></i>
                                <div>
                                    <div class="meta-label">Total Registered</div>
                                    <div class="meta-value">${registrationCount} <c:if test="${not empty event.maxParticipants}">/ ${event.maxParticipants}</c:if> Seats</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-calendar3"></i>
                                <div>
                                    <div class="meta-label">Scheduled Date</div>
                                    <div class="meta-value">${event.eventDate}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-clock-fill"></i>
                                <div>
                                    <div class="meta-label">Timing</div>
                                    <div class="meta-value">${not empty event.eventTime ? event.eventTime : 'TBA'}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-geo-alt-fill"></i>
                                <div>
                                    <div class="meta-label">Venue Location</div>
                                    <div class="meta-value">${event.venue}, ${event.city}</div>
                                </div>
                            </div>
                            <div class="sidebar-meta-item">
                                <i class="bi bi-telephone-fill"></i>
                                <div>
                                    <div class="meta-label">Contact Hotline</div>
                                    <div class="meta-value">${event.contactInfo}</div>
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
                                        <a href="${pageContext.request.contextPath}/women-events/my-registrations" class="btn btn-sm btn-link text-success fw-bold text-decoration-none mt-1">
                                            <i class="bi bi-ticket-perforated-fill"></i> View My Ticket code
                                        </a>
                                    </div>
                                </c:when>
                                <c:when test="${eventPassed}">
                                    <button class="btn-premium-cta" disabled>
                                        <i class="bi bi-x-circle-fill"></i> Event Has Passed
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${event.free}">
                                            <form action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="width: 100%;">
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
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr style="margin: 24px 0; border-color: var(--border-neutral);"/>
                        <div class="sidebar-extra">
                            <p class="mb-1"><i class="bi bi-shield-lock-fill text-success"></i> Highly secure identity protection system</p>
                            <p class="mb-0"><i class="bi bi-ticket-detailed-fill text-danger"></i> Digital secure ticket code issued instantly</p>
                        </div>
                    </div>

                    <!-- Share Event Card structure -->
                    <div class="sidebar-card">
                        <h5 class="fw-bold mb-3" style="color: var(--text-primary); font-size: 1rem;"><i class="bi bi-share-fill text-primary me-2"></i> Spread the Word</h5>
                        <div class="share-links-wrapper">
                            <a href="https://wa.me/?text=Check+out+this+workshop:+${event.name}+at+${pageContext.request.contextPath}/women-events/${event.id}"
                               target="_blank" class="btn btn-sm btn-success rounded-pill btn-share-pill"><i class="bi bi-whatsapp"></i> Share on WhatsApp</a>
                            <button onclick="navigator.clipboard.writeText(window.location.href).then(()=>alert('Link copied!'))" 
                                    class="btn btn-sm btn-outline-secondary rounded-pill btn-share-pill"><i class="bi bi-link-45deg"></i> Copy Details Link</button>
                        </div>
                    </div>

                </div>
            </div>
            
        </div>

        <!-- Full-Width Bottom Registration CTA Banner -->
        <div class="container px-3 pb-5" style="max-width: 1200px; margin: 0 auto;">
            <div class="bottom-registration-cta">
                <h3>Ready to Prioritize Your Wellness?</h3>
                <p>Join us for a beautiful day of active listening, wellness connections, self-care journals, and stress recovery alongside leading practitioners.</p>
                <c:choose>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta">
                            <i class="bi bi-person-circle"></i> Login and Book Seat
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <div class="d-inline-flex align-items-center gap-2 bg-success text-white py-3 px-5 rounded-pill fw-bold">
                            <i class="bi bi-check-circle-fill"></i> Seat Reserved &amp; Confirmed
                        </div>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="background:#555;">Event Complete</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventCheckoutModal()">
                            <i class="bi bi-ticket-perforated-fill"></i> Reserve Your Spot Now
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Mobile Sticky Bottom Buy Row -->
        <div class="mobile-sticky-action-bar">
            <div class="mobile-sticky-inner">
                <div class="mobile-price-section">
                    <span class="mobile-price-value">${event.free ? 'FREE' : '₹'.concat(event.entryFee.toString())}</span>
                    <span class="mobile-price-lbl">Entry Fee</span>
                </div>
                <c:choose>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn-premium-cta" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
                            <i class="bi bi-person-circle"></i> Login
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <span class="badge bg-success py-2 px-3 rounded-pill fw-bold" style="font-size: 0.85rem;"><i class="bi-check-circle-fill me-1"></i> Registered</span>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="btn-premium-cta" disabled style="padding: 12px 24px; font-size: 0.9rem; width: auto;">Passed</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-premium-cta" onclick="openEventCheckoutModal()" style="padding: 12px 24px; font-size: 0.9rem; width: auto;">
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

        <!-- Razorpay Sim Gateway Modal -->
        <div class="modal fade" id="eventCheckoutModal" tabindex="-1" aria-hidden="true" style="backdrop-filter: blur(8px);">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 450px;">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; background: #ffffff;">
                    <!-- Modal Header -->
                    <div class="modal-header border-0 pb-0" style="padding: 24px 24px 0;">
                        <div class="d-flex align-items-center">
                            <div style="background: #fdf2f8; color: #f43f5e; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; border: 1px solid var(--border-secondary);">
                                <i class="bi bi-wallet2"></i>
                            </div>
                            <div class="ms-3">
                                <h5 class="modal-title fw-bold" style="color: #1e1b4b; font-size: 1.15rem; font-family:'Outfit',sans-serif;">Razorpay Secure Gateway</h5>
                                <p class="text-muted small mb-0" style="font-size:0.75rem;">Simulated Test Transaction Mode</p>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="box-shadow: none;"></button>
                    </div>
                    <!-- Modal Body -->
                    <div class="modal-body py-4" style="padding: 24px;">
                        <div class="p-3 mb-4" style="background: #f8fafc; border-radius: 16px; border: 1px solid #e2e8f0;">
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Event Ticket entry fee</span>
                                <span class="fw-bold">₹${event.entryFee}</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Processing/Internet charge</span>
                                <span class="text-success fw-bold">₹0.00</span>
                            </div>
                            <hr style="border-style: dashed; margin: 12px 0;">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-semibold" style="color: #1e1b4b;">Total Payment</span>
                                <span class="fs-5 fw-bold text-primary" style="font-family:'Outfit',sans-serif;">₹${event.entryFee}</span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted mb-1 font-weight-bold">Choose Payment Method</label>
                            <div class="d-grid gap-2">
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #cbd5e1; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="upi" checked class="me-3">
                                    <i class="bi bi-qr-code text-primary me-2" style="font-size:1.15rem;"></i> UPI (PhonePe / GPay / Paytm / BHIM)
                                </div>
                                <div class="border rounded-3 p-3 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #cbd5e1; cursor: pointer;">
                                    <input type="radio" name="eventPayMode" value="card" class="me-3">
                                    <i class="bi bi-credit-card text-success me-2" style="font-size:1.15rem;"></i> Credit or Debit Card checkout
                                </div>
                            </div>
                        </div>
                        <div id="eventOtpSection" style="display:none;" class="mt-3">
                            <label class="form-label small text-danger mb-1 font-weight-bold">Simulated Authentication OTP (Enter 123456)</label>
                            <input type="text" id="eventOtpInput" class="form-control text-center fs-5 fw-bold" maxlength="6" placeholder="------" style="letter-spacing: 5px;">
                            <div class="text-danger small mt-1 text-center" id="eventOtpError" style="display:none; font-weight: 600;">Invalid verification OTP! Use simulated 123456 code.</div>
                        </div>
                    </div>
                    <!-- Modal Footer -->
                    <div class="modal-footer border-0 pt-0" style="padding: 0 24px 24px;">
                        <button type="button" class="btn btn-outline-secondary w-100 mb-2 rounded-pill small" data-bs-dismiss="modal">Cancel Transaction</button>
                        <button type="button" class="btn btn-primary w-100 rounded-pill fw-semibold py-2 btn-premium-cta" id="eventPayBtn" onclick="processEventBookingPayment()" style="background: var(--color-accent); border: none; box-shadow: none;">
                            Proceed Payment of ₹${event.entryFee} Securely
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script>
            setTimeout(() => {
                document.querySelectorAll('.flash-alert').forEach(el => {
                    el.style.transition='opacity 0.5s'; el.style.opacity='0';
                    setTimeout(()=>el.remove(),500);
                });
            }, 4000);

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
                        document.getElementById('eventRegisterForm').submit();
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
