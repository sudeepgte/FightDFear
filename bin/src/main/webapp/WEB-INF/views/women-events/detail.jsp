<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${event.name} — Women Events</title>
    <meta name="description" content="${event.description}"/>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: #faf7fb; color: #1a1a2e; margin: 0; }

        /* Hero banner */
        .event-hero {
            width: 100%; min-height: 420px; position: relative;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
            display: flex; align-items: flex-end;
        }
        .event-hero img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0.2) 60%, transparent 100%); }
        .hero-content { position: relative; z-index: 2; color: white; padding: 40px; max-width: 900px; }
        .cat-badge { background: rgba(255,255,255,0.2); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.3);
            border-radius: 20px; padding: 5px 14px; font-size: 0.8rem; font-weight: 600; display: inline-block; margin-bottom: 12px; }
        .event-title { font-size: clamp(1.8rem, 4vw, 3rem); font-weight: 800; margin-bottom: 12px; line-height: 1.2; }
        .hero-meta { display: flex; flex-wrap: wrap; gap: 18px; font-size: 0.9rem; opacity: 0.9; }
        .hero-meta span { display: flex; align-items: center; gap: 6px; }

        /* Layout */
        .detail-grid { display: grid; grid-template-columns: 1fr 360px; gap: 28px;
            max-width: 1200px; margin: 0 auto; padding: 36px 20px 60px; }
        @media (max-width: 900px) { .detail-grid { grid-template-columns: 1fr; } }

        /* Card blocks */
        .card-block { background: white; border-radius: 20px; padding: 28px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin-bottom: 24px; }
        .block-title { font-size: 1.1rem; font-weight: 700; color: #1e1b4b; margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px; border-bottom: 2px solid #f0e8f5; padding-bottom: 12px; }

        /* Register card (sticky) */
        .register-card { background: white; border-radius: 20px; padding: 28px;
            box-shadow: 0 8px 40px rgba(124,45,94,0.12); position: sticky; top: 24px; border: 2px solid #f0e8f5; }
        .price-display { font-size: 2rem; font-weight: 800; color: #1e1b4b; margin-bottom: 4px; }
        .price-sub { font-size: 0.85rem; color: #888; margin-bottom: 20px; }
        .reg-btn { width: 100%; background: linear-gradient(135deg, #1e1b4b, #f43f5e); color: white;
            border: none; border-radius: 14px; padding: 16px; font-family: 'Outfit', sans-serif;
            font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .reg-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(244,63,94,0.35); }
        .reg-btn:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
        .reg-info { display: flex; justify-content: space-between; padding: 10px 0;
            border-bottom: 1px solid #f5f0f8; font-size: 0.88rem; }
        .reg-info:last-child { border-bottom: none; }
        .reg-info .label { color: #888; }
        .reg-info .value { font-weight: 600; color: #333; }

        /* Stars */
        .stars { color: #f59e0b; font-size: 1.1rem; }
        .star-empty { color: #d1d5db; }

        /* Reviews */
        .review-item { padding: 16px 0; border-bottom: 1px solid #f5f0f8; }
        .review-item:last-child { border-bottom: none; }
        .reviewer-name { font-weight: 700; font-size: 0.9rem; }
        .review-date { font-size: 0.78rem; color: #aaa; }
        .review-text { font-size: 0.92rem; color: #444; margin-top: 6px; line-height: 1.5; }

        /* Gallery */
        .gallery-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 10px; }
        .gallery-img { width: 100%; height: 110px; object-fit: cover; border-radius: 12px; cursor: pointer;
            transition: transform 0.2s; }
        .gallery-img:hover { transform: scale(1.05); }

        /* Review form */
        .star-input { display: flex; gap: 6px; margin-bottom: 12px; }
        .star-input input { display: none; }
        .star-input label { font-size: 1.8rem; color: #d1d5db; cursor: pointer; transition: color 0.15s; }
        .star-input input:checked ~ label, .star-input label:hover,
        .star-input label:hover ~ label { color: #f59e0b; }
        .star-input { flex-direction: row-reverse; }

        /* Upload zone */
        .upload-zone { border: 2px dashed #d8b4fe; border-radius: 14px; padding: 24px;
            text-align: center; cursor: pointer; transition: all 0.2s; }
        .upload-zone:hover { background: #faf5ff; border-color: #a855f7; }

        /* Map embed */
        .map-frame { width: 100%; height: 200px; border: none; border-radius: 12px; }

        /* Flash */
        .flash-alert { position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 380px;
            border-radius: 14px; box-shadow: 0 10px 40px rgba(0,0,0,0.15); animation: slideIn 0.4s ease; }
        @keyframes slideIn { from { transform: translateX(120%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: clip; background: #faf7fb;">

<c:if test="${not empty success}">
    <div class="flash-alert alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="flash-alert alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Event Hero Banner -->
<div class="event-hero">
    <c:if test="${not empty event.bannerImage}">
        <img src="${pageContext.request.contextPath}/uploads/${event.bannerImage}" alt="${event.name}"/>
    </c:if>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <span class="cat-badge"><i class="bi bi-tag-fill me-1"></i>${event.category.displayName}</span>
        <div class="event-title">${event.name}</div>
        <div class="hero-meta">
            <span><i class="bi bi-calendar3"></i>${event.eventDate} <c:if test="${not empty event.eventTime}">at ${event.eventTime}</c:if></span>
            <span><i class="bi bi-geo-alt-fill"></i>${event.venue}, ${event.city}</span>
            <span><i class="bi bi-building"></i>${event.organizerName} (${event.organizerType})</span>
            <c:if test="${event.featured}"><span><i class="bi bi-star-fill" style="color:#f59e0b;"></i>Featured Event</span></c:if>
        </div>
    </div>
</div>

<!-- Breadcrumb -->
<div class="container mt-3" style="max-width:1200px;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb" style="font-size:0.85rem;">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events" style="color:#1e1b4b;">Events</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/women-events?category=${event.category}" style="color:#1e1b4b;">${event.category.displayName}</a></li>
            <li class="breadcrumb-item active">${event.name}</li>
        </ol>
    </nav>
</div>

<!-- Detail Grid -->
<div class="detail-grid">

    <!-- Left Column -->
    <div>
        <!-- About -->
        <div class="card-block">
            <div class="block-title"><i class="bi bi-info-circle-fill"></i>About This Event</div>
            <p style="line-height:1.8; color:#444; white-space:pre-line;">${event.description}</p>
        </div>

        <!-- Event Details -->
        <div class="card-block">
            <div class="block-title"><i class="bi bi-list-check"></i>Event Details</div>
            <div class="reg-info"><span class="label">📅 Date</span><span class="value">${event.eventDate}</span></div>
            <div class="reg-info"><span class="label">🕐 Time</span><span class="value">${not empty event.eventTime ? event.eventTime : 'TBA'}</span></div>
            <div class="reg-info"><span class="label">📍 Venue</span><span class="value">${event.venue}</span></div>
            <div class="reg-info"><span class="label">🏙️ City</span><span class="value">${event.city}</span></div>
            <div class="reg-info"><span class="label">💰 Entry Fee</span><span class="value">${event.free ? 'FREE' : '₹'.concat(event.entryFee.toString())}</span></div>
            <div class="reg-info"><span class="label">👥 Max Participants</span><span class="value">${not empty event.maxParticipants ? event.maxParticipants : 'Unlimited'}</span></div>
            <div class="reg-info"><span class="label">📞 Contact</span><span class="value">${event.contactInfo}</span></div>
            <div class="reg-info"><span class="label">🏢 Organizer</span><span class="value">${event.organizerName} (${event.organizerType})</span></div>
        </div>

        <!-- Map -->
        <c:if test="${not empty event.mapsLocation}">
            <div class="card-block">
                <div class="block-title"><i class="bi bi-map-fill"></i>Location</div>
                <iframe class="map-frame"
                        src="https://maps.google.com/maps?q=${event.mapsLocation}&output=embed"
                        allowfullscreen loading="lazy"></iframe>
                <a href="https://maps.google.com/maps?q=${event.mapsLocation}" target="_blank"
                   style="color:#1e1b4b; font-weight:600; font-size:0.9rem; display:inline-block; margin-top:10px;">
                    <i class="bi bi-box-arrow-up-right"></i> Open in Google Maps
                </a>
            </div>
        </c:if>

        <!-- Photo Gallery -->
        <div class="card-block">
            <div class="block-title"><i class="bi bi-images"></i>Photo Gallery (${photos.size()})</div>
            <c:choose>
                <c:when test="${not empty photos}">
                    <div class="gallery-grid">
                        <c:forEach var="ph" items="${photos}">
                            <img src="${pageContext.request.contextPath}/uploads/${ph.photoPath}"
                                 class="gallery-img" alt="${ph.caption}" data-bs-toggle="modal" data-bs-target="#photoModal"
                                 onclick="document.getElementById('modalPhoto').src=this.src"/>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-muted small">No photos uploaded yet. Be the first to share!</p>
                </c:otherwise>
            </c:choose>

            <!-- Upload photo (if registered & event passed) -->
            <c:if test="${alreadyRegistered && eventPassed && not empty loggedUser}">
                <hr style="margin: 20px 0; border-color: #f0e8f5;"/>
                <div class="block-title" style="font-size:0.95rem;"><i class="bi bi-cloud-upload-fill"></i>Share Your Photos</div>
                <form action="${pageContext.request.contextPath}/women-events/${event.id}/upload-photo" method="post" enctype="multipart/form-data">
                    <div class="upload-zone" onclick="document.getElementById('photoFile').click()">
                        <i class="bi bi-camera-fill" style="font-size:2rem; color:#a855f7; display:block; margin-bottom:8px;"></i>
                        <div style="font-weight:600; color:#555;">Click to upload event photos</div>
                        <div class="text-muted small">JPG, PNG up to 5MB</div>
                    </div>
                    <input type="file" id="photoFile" name="photo" accept="image/*" style="display:none;" required onchange="this.form.querySelector('.upload-zone div').textContent=this.files[0].name"/>
                    <input type="text" name="caption" class="form-control mt-2" placeholder="Add a caption (optional)" style="border-radius:10px; border:1.5px solid #e5e7eb; font-family:'Outfit',sans-serif;"/>
                    <button type="submit" class="reg-btn mt-2" style="font-size:0.9rem; padding:12px;">Upload Photo</button>
                </form>
            </c:if>
        </div>

        <!-- Reviews -->
        <div class="card-block">
            <div class="block-title">
                <i class="bi bi-star-fill" style="color:#f59e0b;"></i>Reviews & Ratings
                <span style="font-size:0.85rem; color:#888; font-weight:500; margin-left:auto;">${reviews.size()} reviews · Avg: ${avgRating} ⭐</span>
            </div>

            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="review-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="reviewer-name">${rev.user.fullName}</div>
                                    <div class="stars">
                                        <c:forEach begin="1" end="${rev.rating}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                        <c:forEach begin="${rev.rating + 1}" end="5" var="s"><i class="bi bi-star" class="star-empty"></i></c:forEach>
                                    </div>
                                </div>
                                <div class="review-date">${rev.createdAt}</div>
                            </div>
                            <div class="review-text">${rev.reviewText}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted small">No reviews yet. Attend this event and share your experience!</p>
                </c:otherwise>
            </c:choose>

            <!-- Submit review -->
            <c:if test="${alreadyRegistered && eventPassed && not alreadyReviewed && not empty loggedUser}">
                <hr style="margin: 20px 0; border-color: #f0e8f5;"/>
                <div class="block-title" style="font-size:0.95rem;"><i class="bi bi-pencil-square"></i>Write a Review</div>
                <form action="${pageContext.request.contextPath}/women-events/${event.id}/review" method="post">
                    <div class="star-input mb-3">
                        <input type="radio" id="s5" name="rating" value="5"/><label for="s5">★</label>
                        <input type="radio" id="s4" name="rating" value="4"/><label for="s4">★</label>
                        <input type="radio" id="s3" name="rating" value="3"/><label for="s3">★</label>
                        <input type="radio" id="s2" name="rating" value="2"/><label for="s2">★</label>
                        <input type="radio" id="s1" name="rating" value="1"/><label for="s1">★</label>
                    </div>
                    <textarea name="reviewText" rows="4" required placeholder="Share your experience at this event..." class="form-control" style="border-radius:12px; border:1.5px solid #e5e7eb; font-family:'Outfit',sans-serif; resize:none;"></textarea>
                    <button type="submit" class="reg-btn mt-3" style="font-size:0.9rem; padding:12px;">Submit Review</button>
                </form>
            </c:if>
        </div>
    </div>

    <!-- Right Sidebar -->
    <div>
        <div class="register-card">
            <div class="price-display">${event.free ? 'FREE' : '₹'.concat(event.entryFee.toString())}</div>
            <div class="price-sub">${event.free ? 'No registration fee' : 'Entry fee — pay at venue'}</div>

            <div class="reg-info">
                <span class="label"><i class="bi bi-people-fill text-primary"></i> Registered</span>
                <span class="value">${registrationCount} <c:if test="${not empty event.maxParticipants}">/ ${event.maxParticipants}</c:if></span>
            </div>
            <div class="reg-info">
                <span class="label"><i class="bi bi-calendar-event-fill text-danger"></i> Date</span>
                <span class="value">${event.eventDate}</span>
            </div>
            <div class="reg-info">
                <span class="label"><i class="bi bi-clock-fill text-warning"></i> Time</span>
                <span class="value">${not empty event.eventTime ? event.eventTime : 'TBA'}</span>
            </div>
            <div class="reg-info">
                <span class="label"><i class="bi bi-geo-alt-fill text-success"></i> City</span>
                <span class="value">${event.city}</span>
            </div>

            <div style="margin-top: 20px;">
                <c:choose>
                    <c:when test="${empty loggedUser}">
                        <a href="${pageContext.request.contextPath}/login" class="reg-btn d-block text-center" style="text-decoration:none; padding:16px;">
                            <i class="bi bi-person-circle me-2"></i>Login to Register
                        </a>
                    </c:when>
                    <c:when test="${alreadyRegistered}">
                        <div style="background:#f0fdf4; border-radius:12px; padding:16px; text-align:center;">
                            <i class="bi bi-check-circle-fill" style="color:#15803d; font-size:1.5rem;"></i>
                            <div style="font-weight:700; color:#15803d; margin-top:4px;">You're Registered!</div>
                            <a href="${pageContext.request.contextPath}/women-events/my-registrations"
                               style="color:#1e1b4b; font-weight:600; font-size:0.9rem; display:inline-block; margin-top:8px; text-decoration:none;">
                                <i class="bi bi-ticket-perforated-fill"></i> View My Ticket
                            </a>
                        </div>
                    </c:when>
                    <c:when test="${eventPassed}">
                        <button class="reg-btn" disabled>Event Has Passed</button>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${event.free}">
                                <form action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post">
                                    <button type="submit" class="reg-btn">
                                        <i class="bi bi-ticket-perforated-fill me-2"></i>Register Now — FREE
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="reg-btn" onclick="openEventCheckoutModal()">
                                    <i class="bi bi-ticket-perforated-fill me-2"></i>Register Now — ₹${event.entryFee}
                                </button>
                                <form id="eventRegisterForm" action="${pageContext.request.contextPath}/women-events/${event.id}/register" method="post" style="display:none;"></form>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>

            <hr style="margin: 20px 0; border-color: #f0e8f5;"/>
            <div style="font-size:0.82rem; color:#888; text-align:center; line-height: 1.6;">
                <i class="bi bi-shield-check text-success"></i> Safe & verified platform<br/>
                <i class="bi bi-bell-fill text-warning"></i> You'll receive a digital ticket after registering
            </div>
        </div>

        <!-- Share block -->
        <div class="card-block mt-3">
            <div class="block-title"><i class="bi bi-share-fill"></i>Share Event</div>
            <div class="d-flex gap-2 flex-wrap">
                <a href="https://wa.me/?text=Check+out+this+event:+${event.name}+at+${pageContext.request.contextPath}/women-events/${event.id}"
                   target="_blank" class="btn btn-sm btn-success rounded-pill"><i class="bi bi-whatsapp"></i> WhatsApp</a>
                <button onclick="navigator.clipboard.writeText(window.location.href).then(()=>alert('Link copied!'))"
                        class="btn btn-sm btn-outline-secondary rounded-pill"><i class="bi bi-link-45deg"></i> Copy Link</button>
            </div>
        </div>
    </div>
</div>

<!-- Photo Modal -->
<div class="modal fade" id="photoModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 bg-transparent">
            <div class="modal-body p-0 text-center">
                <img id="modalPhoto" src="" style="max-width:100%; border-radius:16px; max-height:80vh;"/>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>

<!-- Event Paid Booking Checkout Modal -->
<div class="modal fade" id="eventCheckoutModal" tabindex="-1" aria-hidden="true" style="backdrop-filter: blur(8px);">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 450px;">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 24px; background: #ffffff;">
            <!-- Modal Header -->
            <div class="modal-header border-0 pb-0" style="padding: 24px 24px 0;">
                <div class="d-flex align-items-center">
                    <div style="background: #fdf2f8; color: #f43f5e; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                        <i class="bi bi-wallet2"></i>
                    </div>
                    <div class="ms-3">
                        <h5 class="modal-title fw-bold" style="color: #1e1b4b; font-size: 1.15rem; font-family:'Outfit',sans-serif;">Razorpay Secure Gateway</h5>
                        <p class="text-muted small mb-0" style="font-size:0.75rem;">Simulated Test Transaction</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="box-shadow: none;"></button>
            </div>
            <!-- Modal Body -->
            <div class="modal-body py-4" style="padding: 24px;">
                <div class="p-3 mb-4" style="background: #f8fafc; border-radius: 16px; border: 1px solid #e2e8f0;">
                    <div class="d-flex justify-content-between mb-2 small text-muted">
                        <span>Event Ticket</span>
                        <span>₹${event.entryFee}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small text-muted">
                        <span>Internet Fee</span>
                        <span class="text-success">₹0.00</span>
                    </div>
                    <hr style="border-style: dashed; margin: 12px 0;">
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fw-semibold" style="color: #1e1b4b;">Total Payout</span>
                        <span class="fs-5 fw-bold text-primary" style="font-family:'Outfit',sans-serif;">₹${event.entryFee}</span>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label small text-muted mb-1">Select Payment Mode</label>
                    <div class="d-grid gap-2">
                        <div class="border rounded-3 p-2 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #cbd5e1;">
                            <input type="radio" name="eventPayMode" value="upi" checked class="me-2">
                            <i class="bi bi-qr-code text-primary me-2"></i> UPI (PhonePe / GPay / Paytm)
                        </div>
                        <div class="border rounded-3 p-2 d-flex align-items-center bg-white" style="font-size: 0.88rem; border-color: #cbd5e1;">
                            <input type="radio" name="eventPayMode" value="card" class="me-2">
                            <i class="bi bi-credit-card text-success me-2"></i> Credit or Debit Card
                        </div>
                    </div>
                </div>
                <div id="eventOtpSection" style="display:none;" class="mt-3">
                    <label class="form-label small text-danger mb-1">Enter Simulated OTP (123456)</label>
                    <input type="text" id="eventOtpInput" class="form-control text-center fs-5 fw-bold" maxlength="6" placeholder="------" style="letter-spacing: 5px;">
                    <div class="text-danger small mt-1 text-center" id="eventOtpError" style="display:none;">Invalid OTP! Please enter 123456.</div>
                </div>
            </div>
            <!-- Modal Footer -->
            <div class="modal-footer border-0 pt-0" style="padding: 0 24px 24px;">
                <button type="button" class="btn btn-outline-secondary w-100 mb-2 rounded-pill small" data-bs-dismiss="modal">Cancel Payout</button>
                <button type="button" class="btn-primary w-100 rounded-pill fw-semibold py-2" id="eventPayBtn" onclick="processEventBookingPayment()" style="background: linear-gradient(135deg, #1e1b4b, #f43f5e); border: none;">
                    Pay ₹${event.entryFee} Securely
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
            document.getElementById('eventPayBtn').textContent = 'Submit OTP & Verify';
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
