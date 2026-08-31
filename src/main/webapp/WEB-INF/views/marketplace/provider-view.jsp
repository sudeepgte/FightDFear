<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>${provider.fullName} | Women Marketplace</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">

    <style>
        :root {
            --primary: #F43F5E;
            --primary-hover: #E11D48;
            --secondary: #64748B;
            --bg: #F8FAFC;
            --card: #FFFFFF;
            --text-main: #0F172A;
            --border: #E2E8F0;
            --success-text: #16A34A;
            --success-bg: #DCFCE7;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text-main);
        }

        /* Layout overrides */
        #wrapper { margin-top: 0 !important; }
        #sidebar-wrapper { top: 0 !important; }
        #page-content-wrapper { padding: 0 !important; width: 100% !important; }

        .profile-container {
            width: 100% !important;
            max-width: 100% !important;
            margin: 0;
            padding: 20px 40px;
            padding-bottom: 80px;
        }

        /* Top Nav */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .top-nav a, .top-nav i {
            font-size: 1.3rem;
            color: var(--text-main);
            cursor: pointer;
            text-decoration: none;
        }
        .nav-actions {
            display: flex;
            gap: 15px;
        }

        /* Header Card */
        .card-box {
            background: var(--card);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
        }

        .header-main {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .profile-photo {
            width: 100px;
            height: 100px;
            border-radius: 16px;
            object-fit: cover;
            background: #E2E8F0;
        }
        .profile-info h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .verified-badge {
            color: var(--success-text);
            font-size: 1rem;
        }
        .designation {
            font-size: 0.9rem;
            color: var(--secondary);
            margin-bottom: 12px;
        }
        .meta-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .meta-list li {
            font-size: 0.8rem;
            color: var(--secondary);
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .meta-list li i {
            width: 16px;
            text-align: center;
        }
        .meta-list li i.star { color: #F59E0B; }

        .council-verified {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--success-bg);
            color: var(--success-text);
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .btn-group-custom {
            display: flex;
            gap: 15px;
        }
        .btn-solid, .btn-outline {
            flex: 1;
            padding: 12px;
            border-radius: 12px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }
        .btn-solid {
            background: var(--primary);
            color: white;
            border: 1px solid var(--primary);
        }
        .btn-solid:hover { background: var(--primary-hover); color: white; }
        .btn-outline {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }
        .btn-outline:hover { background: #fff0f2; color: var(--primary); }

        /* Sections */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-main);
            margin: 0;
        }
        .view-all {
            color: var(--primary);
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
        }

        /* Practice Areas */
        .tags-wrapper {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .tag-pill {
            background: var(--bg);
            border: 1px solid var(--border);
            color: var(--secondary);
            font-size: 0.8rem;
            padding: 8px 16px;
            border-radius: 50px;
        }

        /* About */
        .about-text {
            font-size: 0.9rem;
            color: var(--secondary);
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .read-more {
            color: var(--primary);
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
        }

        /* Consultation */
        .consult-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .consult-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1;
            margin-bottom: 4px;
        }
        .consult-label {
            font-size: 0.75rem;
            color: var(--secondary);
        }
        .consult-modes {
            font-size: 0.8rem;
            color: var(--secondary);
        }
        .consult-modes div {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 4px;
        }
        .dot {
            width: 6px;
            height: 6px;
            background: var(--success-text);
            border-radius: 50%;
        }
        .mode-pills {
            display: flex;
            gap: 10px;
        }
        .mode-pill {
            flex: 1;
            text-align: center;
            padding: 10px 5px;
            border: 1px solid var(--border);
            border-radius: 12px;
            font-size: 0.75rem;
            color: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        /* Availability */
        .avail-status {
            color: var(--success-text);
            font-size: 0.8rem;
            font-weight: 600;
        }
        .schedule-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .schedule-list li {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            color: var(--secondary);
            margin-bottom: 12px;
        }
        .schedule-list li span.closed { color: var(--primary); }

        /* Reviews */
        .review-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .review-score {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1;
        }
        .review-stars {
            color: #F59E0B;
            font-size: 1.2rem;
            margin-bottom: 2px;
        }
        .review-bars {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .bar-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.75rem;
            color: var(--secondary);
        }
        .progress {
            flex: 1;
            height: 6px;
            background: var(--border);
            border-radius: 10px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: var(--primary);
            border-radius: 10px;
        }

        /* Bottom Mobile Nav */
        .bottom-nav {
            background: white;
            display: flex;
            justify-content: space-around;
            padding: 20px 0;
            border-top: 1px solid var(--border);
            margin-top: 40px;
            border-radius: 20px;
        }
        .bottom-nav .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--secondary);
            font-size: 0.85rem;
            font-weight: 500;
            gap: 6px;
        }
        .bottom-nav .nav-item i {
            font-size: 1.5rem;
            line-height: 1;
        }
        .bottom-nav .nav-item.active {
            color: var(--primary);
        }
        .bottom-nav .nav-item.active i {
            text-shadow: 0 0 1px var(--primary);
        }

    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden; background-color: var(--bg);">

    <div class="profile-container">
        
        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="border-radius: 12px; font-size:0.9rem;">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-success" style="border-radius: 12px; font-size:0.9rem;">
                <i class="bi bi-check-circle-fill"></i> ${message}
            </div>
        </c:if>

        <!-- Removed Top Nav as requested -->

        <!-- Profile Header Box -->
        <div class="card-box">
            <div class="header-main">
                <c:choose>
                    <c:when test="${not empty provider.profilePhoto}">
                        <c:set var="pUrl" value="${provider.profilePhoto}" />
                        <c:if test="${not fn:startsWith(pUrl, 'http') and not fn:startsWith(pUrl, '/')}">
                            <c:set var="pUrl" value="/uploads/${pUrl}" />
                        </c:if>
                        <c:if test="${not fn:startsWith(pUrl, 'http')}">
                            <c:set var="pUrl" value="${pageContext.request.contextPath}${pUrl}" />
                        </c:if>
                        <img src="${pUrl}" class="profile-photo" alt="Photo">
                    </c:when>
                    <c:otherwise>
                        <div class="profile-photo" style="display:flex; align-items:center; justify-content:center; color:var(--primary); font-size:2.5rem; font-weight:700;">
                            ${fn:substring(provider.fullName, 0, 1)}
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="profile-info">
                    <h1>
                        ${provider.fullName}
                        <i class="bi bi-patch-check-fill verified-badge"></i>
                    </h1>
                    <div class="designation">${not empty provider.designation ? provider.designation : provider.category.label}</div>
                    
                    <ul class="meta-list">
                        <li>
                            <i class="bi bi-star-fill star"></i>
                            <span style="font-weight:600; color:var(--text-main);">${provider.rating > 0 ? provider.rating : 'New'}</span>
                            (${not empty reviews ? reviews.size() : '0'} Reviews)
                        </li>
                        <li>
                            <i class="bi bi-calendar3"></i>
                            ${not empty provider.experienceYears ? provider.experienceYears : '5'}+ Years Experience
                        </li>
                        <li>
                            <i class="bi bi-geo-alt"></i>
                            ${not empty provider.city ? provider.city.concat(', ').concat(provider.state) : provider.locationText}
                        </li>
                    </ul>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty provider.barCouncilId or provider.verificationStatus == 'VERIFIED'}">
                    <div class="council-verified">
                        <i class="bi bi-patch-check-fill"></i> Bar Council Verified
                    </div>
                </c:when>
            </c:choose>

            <div class="btn-group-custom">
                <a href="#" class="btn-solid" data-bs-toggle="modal" data-bs-target="#bookModal">Book Consultation</a>
                <a href="#" class="btn-outline" data-bs-toggle="modal" data-bs-target="#contactModal">Contact Lawyer</a>
            </div>
        </div>

        <!-- Contact Modal -->
        <div class="modal fade" id="contactModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content" style="border-radius:20px; border:none;">
                    <div class="modal-header" style="border-bottom:1px solid var(--border); padding:20px 25px;">
                        <h5 class="modal-title" style="font-weight:700; font-size:1.1rem;">Connect</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" style="padding:25px; display:flex; flex-direction:column; gap:15px;">
                        <c:if test="${not empty provider.phone}">
                            <a href="tel:${provider.phone}" class="btn-outline" style="display:flex; align-items:center; justify-content:center; gap:10px; text-decoration:none;">
                                <i class="bi bi-telephone-fill"></i> Call ${provider.phone}
                            </a>
                        </c:if>
                        <c:if test="${not empty provider.whatsappNumber}">
                            <a href="https://wa.me/91${provider.whatsappNumber}" target="_blank" class="btn-outline" style="display:flex; align-items:center; justify-content:center; gap:10px; color:#25D366; border-color:#25D366; text-decoration:none;">
                                <i class="bi bi-whatsapp"></i> WhatsApp
                            </a>
                        </c:if>
                        <c:if test="${not empty provider.email}">
                            <a href="mailto:${provider.email}" class="btn-outline" style="display:flex; align-items:center; justify-content:center; gap:10px; color:var(--secondary); border-color:var(--secondary); text-decoration:none;">
                                <i class="bi bi-envelope-fill"></i> Email
                            </a>
                        </c:if>
                        <c:if test="${empty provider.phone and empty provider.whatsappNumber and empty provider.email}">
                            <div style="text-align:center; color:var(--secondary); font-size:0.9rem;">Contact details not available.</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Booking Modal -->
        <div class="modal fade" id="bookModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:20px; border:none;">
                    <div class="modal-header" style="border-bottom:1px solid var(--border); padding:20px 25px;">
                        <h5 class="modal-title" style="font-weight:700;">Book Consultation</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="bookingForm" action="${pageContext.request.contextPath}/marketplace/book" method="post">
                        <div class="modal-body" style="padding:25px;">
                            <input type="hidden" name="providerId" value="${provider.id}">
                            
                            <div class="mb-4 p-3" style="background:var(--bg); border-radius:12px; border:1px solid var(--border); display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <h6 style="margin:0; font-weight:700;">Consultation Charge</h6>
                                    <small class="text-muted" style="font-size:0.75rem;">Standard Booking Fee</small>
                                </div>
                                <h4 style="margin:0; font-weight:800; color:var(--text-main);">₹${not empty provider.consultationFee ? provider.consultationFee : '1,500'}</h4>
                            </div>

                            <div class="mb-3">
                                <label style="font-size:0.85rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Consultation Mode</label>
                                <select id="consultMode" class="form-control" style="border-radius:12px; padding:12px; cursor:pointer;" required>
                                    <option value="Online">Online Consultation</option>
                                    <option value="In-Person">In-Person / Direct Visit</option>
                                </select>
                            </div>

                            <div class="mb-3" id="callTypeGroup">
                                <label style="font-size:0.85rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Call Type</label>
                                <select id="callType" class="form-control" style="border-radius:12px; padding:12px; cursor:pointer;">
                                    <option value="Video Call">Video Call</option>
                                    <option value="Audio Call">Audio / Phone Call</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label style="font-size:0.85rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Preferred Date & Time</label>
                                <input type="datetime-local" name="requestedTime" id="requestedTimeInput" class="form-control" style="border-radius:12px; padding:12px;" required>
                            </div>
                            
                            <div class="mb-4">
                                <label style="font-size:0.85rem; font-weight:600; color:var(--secondary); margin-bottom:8px;">Case Topic / Note</label>
                                <textarea id="baseNote" class="form-control" rows="2" style="border-radius:12px; padding:12px;" placeholder="Briefly describe your legal issue..." required></textarea>
                            </div>
                            <input type="hidden" name="note" id="finalNote">
                        </div>
                        <div class="modal-footer" style="border-top:1px solid var(--border); padding:20px 25px;">
                            <button type="submit" class="btn-solid" style="width:100%; border:none;">Confirm Booking</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Practice Areas Box -->
        <div class="card-box">
            <div class="section-header">
                <h3 class="section-title">Practice Areas</h3>
                <a href="#" class="view-all">View all</a>
            </div>
            <div class="tags-wrapper">
                <c:choose>
                    <c:when test="${not empty provider.practiceAreas}">
                        <c:forEach var="tag" items="${fn:split(provider.practiceAreas, ',')}">
                            <div class="tag-pill">${fn:trim(tag)}</div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="tag-pill">Divorce</div>
                        <div class="tag-pill">Child Custody</div>
                        <div class="tag-pill">Domestic Violence</div>
                        <div class="tag-pill">Property Law</div>
                        <div class="tag-pill">Mediation</div>
                        <div class="tag-pill">Family Law</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- About Box -->
        <div class="card-box">
            <div class="section-header">
                <h3 class="section-title">About</h3>
            </div>
            <div class="about-text">
                <c:choose>
                    <c:when test="${not empty provider.description}">
                        ${provider.description}
                    </c:when>
                    <c:when test="${not empty provider.bio}">
                        ${provider.bio}
                    </c:when>
                    <c:otherwise>
                        ${provider.fullName} is a dedicated legal specialist with ${not empty provider.experienceYears ? provider.experienceYears : '5'}+ years of experience in handling complex cases and providing expert guidance to clients with compassion and dedication.
                    </c:otherwise>
                </c:choose>
            </div>
            
            <hr style="margin: 20px 0; border-color: var(--border); opacity: 1;">
            
            <div style="display:flex; flex-direction:column; gap:15px;">
                <c:if test="${not empty provider.qualification}">
                    <div>
                        <h6 style="font-size:0.85rem; color:var(--secondary); font-weight:600; margin-bottom:4px;">Education & Qualifications</h6>
                        <div style="font-size:0.9rem; color:var(--text-main); font-weight:500;"><i class="bi bi-mortarboard text-primary me-2"></i> ${provider.qualification}</div>
                    </div>
                </c:if>
                <c:if test="${not empty provider.languages or not empty provider.languagesSpoken}">
                    <div>
                        <h6 style="font-size:0.85rem; color:var(--secondary); font-weight:600; margin-bottom:4px;">Languages Spoken</h6>
                        <div style="font-size:0.9rem; color:var(--text-main); font-weight:500;"><i class="bi bi-translate text-primary me-2"></i> ${not empty provider.languages ? provider.languages : provider.languagesSpoken}</div>
                    </div>
                </c:if>
                <c:if test="${not empty provider.address}">
                    <div>
                        <h6 style="font-size:0.85rem; color:var(--secondary); font-weight:600; margin-bottom:4px;">Office Address</h6>
                        <div style="font-size:0.9rem; color:var(--text-main); font-weight:500;"><i class="bi bi-building text-primary me-2"></i> ${provider.address}, ${provider.city}, ${provider.state} ${provider.pincode}</div>
                    </div>
                </c:if>
                <c:if test="${not empty provider.facilities}">
                    <div>
                        <h6 style="font-size:0.85rem; color:var(--secondary); font-weight:600; margin-bottom:4px;">Facilities</h6>
                        <div style="font-size:0.9rem; color:var(--text-main); font-weight:500;"><i class="bi bi-check2-circle text-primary me-2"></i> ${provider.facilities}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Consultation Box -->
        <div class="card-box">
            <div class="section-header">
                <h3 class="section-title">Consultation</h3>
            </div>
            <div class="consult-info">
                <div>
                    <div class="consult-price">₹${not empty provider.consultationFee ? provider.consultationFee : '1,500'}</div>
                    <div class="consult-label">Starting Consultation Fee</div>
                </div>
                <div class="consult-modes">
                    <c:choose>
                        <c:when test="${not empty provider.consultationMode}">
                            <c:if test="${fn:containsIgnoreCase(provider.consultationMode, 'Online') or fn:containsIgnoreCase(provider.consultationMode, 'Both')}">
                                <div><div class="dot"></div> Online Consultation</div>
                            </c:if>
                            <c:if test="${fn:containsIgnoreCase(provider.consultationMode, 'In-Person') or fn:containsIgnoreCase(provider.consultationMode, 'Both')}">
                                <div><div class="dot"></div> In-Person Consultation</div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div><div class="dot"></div> Online Consultation</div>
                            <div><div class="dot"></div> In-Person Consultation</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="mode-pills">
                <c:choose>
                    <c:when test="${not empty provider.serviceMode}">
                        <c:if test="${fn:containsIgnoreCase(provider.serviceMode, 'Video')}">
                            <div class="mode-pill"><i class="bi bi-camera-video"></i> Video Call</div>
                        </c:if>
                        <c:if test="${fn:containsIgnoreCase(provider.serviceMode, 'Phone')}">
                            <div class="mode-pill"><i class="bi bi-telephone"></i> Phone Call</div>
                        </c:if>
                        <c:if test="${fn:containsIgnoreCase(provider.serviceMode, 'Chamber') or fn:containsIgnoreCase(provider.serviceMode, 'Clinic')}">
                            <div class="mode-pill"><i class="bi bi-house"></i> Chamber Visit</div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="mode-pill"><i class="bi bi-camera-video"></i> Video Call</div>
                        <div class="mode-pill"><i class="bi bi-telephone"></i> Phone Call</div>
                        <div class="mode-pill"><i class="bi bi-house"></i> Chamber Visit</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Chamber Photos Box -->
        <c:if test="${not empty provider.galleryPhotos or not empty provider.identityDocumentPath}">
            <div class="card-box">
                <div class="section-header">
                    <h3 class="section-title">Chamber Photos</h3>
                </div>
                <div style="display:flex; gap:15px; overflow-x:auto; padding-bottom:10px;">
                    <!-- Dashboard Chamber Photo -->
                    <c:if test="${not empty provider.identityDocumentPath}">
                        <c:set var="idUrl" value="${provider.identityDocumentPath}" />
                        <c:if test="${not fn:startsWith(idUrl, 'http') and not fn:startsWith(idUrl, '/')}">
                            <c:set var="idUrl" value="/uploads/${idUrl}" />
                        </c:if>
                        <c:if test="${not fn:startsWith(idUrl, 'http')}">
                            <c:set var="idUrl" value="${pageContext.request.contextPath}${idUrl}" />
                        </c:if>
                        <img src="${idUrl}" style="height: 120px; min-width: 160px; object-fit: cover; border-radius: 12px; border: 1px solid var(--border);" alt="Chamber Photo">
                    </c:if>

                    <!-- Mobile Gallery Photos -->
                    <c:if test="${not empty provider.galleryPhotos}">
                        <c:forEach var="photo" items="${fn:split(provider.galleryPhotos, ',')}">
                            <c:set var="gUrl" value="${fn:trim(photo)}" />
                            <c:if test="${not fn:startsWith(gUrl, 'http') and not fn:startsWith(gUrl, '/')}">
                                <c:set var="gUrl" value="/uploads/${gUrl}" />
                            </c:if>
                            <c:if test="${not fn:startsWith(gUrl, 'http')}">
                                <c:set var="gUrl" value="${pageContext.request.contextPath}${gUrl}" />
                            </c:if>
                            <img src="${gUrl}" style="height: 120px; min-width: 160px; object-fit: cover; border-radius: 12px; border: 1px solid var(--border);" alt="Chamber Photo">
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Availability Box -->
        <div class="card-box">
            <div class="section-header">
                <h3 class="section-title">Availability</h3>
                <span class="avail-status">Available Today</span>
            </div>
            <ul class="schedule-list">
                <c:choose>
                    <c:when test="${not empty provider.openDays}">
                        <li><span>${provider.openDays}</span> <span>${not empty provider.openTime ? provider.openTime : '10:00'} - ${not empty provider.closeTime ? provider.closeTime : '18:00'}</span></li>
                        <c:if test="${not empty provider.blockedDates}">
                            <li><span>Unavailable</span> <span class="closed">${provider.blockedDates}</span></li>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <li><span>Mon - Fri</span> <span>10:00 AM - 06:00 PM</span></li>
                        <li><span>Saturday</span> <span>10:00 AM - 02:00 PM</span></li>
                        <li><span>Sunday</span> <span class="closed">Closed</span></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <!-- Reviews Box -->
        <div class="card-box mb-5">
            <div class="section-header">
                <h3 class="section-title">Reviews <span style="color:var(--secondary); font-weight:normal; font-size:0.9rem;">(${not empty reviews ? reviews.size() : '0'})</span></h3>
                <a href="#" class="view-all">View all</a>
            </div>
            
            <div class="review-header">
                <div class="review-score">${provider.rating > 0 ? provider.rating : '0.0'}</div>
                <div>
                    <div class="review-stars">
                        <c:set var="ratingVal" value="${provider.rating > 0 ? provider.rating : 0}" />
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${ratingVal >= i}">
                                    <i class="bi bi-star-fill"></i>
                                </c:when>
                                <c:when test="${ratingVal >= i - 0.5}">
                                    <i class="bi bi-star-half"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-star"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <c:set var="totalRev" value="${empty reviews ? 0 : reviews.size()}" />
            <c:set var="s5" value="0"/><c:set var="s4" value="0"/><c:set var="s3" value="0"/><c:set var="s2" value="0"/><c:set var="s1" value="0"/>
            <c:forEach var="r" items="${reviews}">
                <c:if test="${r.rating == 5}"><c:set var="s5" value="${s5 + 1}"/></c:if>
                <c:if test="${r.rating == 4}"><c:set var="s4" value="${s4 + 1}"/></c:if>
                <c:if test="${r.rating == 3}"><c:set var="s3" value="${s3 + 1}"/></c:if>
                <c:if test="${r.rating == 2}"><c:set var="s2" value="${s2 + 1}"/></c:if>
                <c:if test="${r.rating == 1}"><c:set var="s1" value="${s1 + 1}"/></c:if>
            </c:forEach>
            <c:set var="p5" value="${totalRev > 0 ? (s5 * 100 / totalRev) : 0}" />
            <c:set var="p4" value="${totalRev > 0 ? (s4 * 100 / totalRev) : 0}" />
            <c:set var="p3" value="${totalRev > 0 ? (s3 * 100 / totalRev) : 0}" />
            <c:set var="p2" value="${totalRev > 0 ? (s2 * 100 / totalRev) : 0}" />
            <c:set var="p1" value="${totalRev > 0 ? (s1 * 100 / totalRev) : 0}" />

            <div class="review-bars">
                <c:choose>
                    <c:when test="${totalRev > 0}">
                        <div class="bar-row">
                            <span>5 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:${p5}%"></div></div>
                            <span style="width:40px;">${fn:substringBefore(p5.toString().concat('.'), '.')}%</span>
                        </div>
                        <div class="bar-row">
                            <span>4 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:${p4}%; background:#F97316;"></div></div>
                            <span style="width:40px;">${fn:substringBefore(p4.toString().concat('.'), '.')}%</span>
                        </div>
                        <div class="bar-row">
                            <span>3 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:${p3}%; background:#F97316;"></div></div>
                            <span style="width:40px;">${fn:substringBefore(p3.toString().concat('.'), '.')}%</span>
                        </div>
                        <div class="bar-row">
                            <span>2 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:${p2}%; background:#F97316;"></div></div>
                            <span style="width:40px;">${fn:substringBefore(p2.toString().concat('.'), '.')}%</span>
                        </div>
                        <div class="bar-row">
                            <span>1 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:${p1}%; background:#F97316;"></div></div>
                            <span style="width:40px;">${fn:substringBefore(p1.toString().concat('.'), '.')}%</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bar-row">
                            <span>5 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:0%"></div></div>
                            <span style="width:40px;">0%</span>
                        </div>
                        <div class="bar-row">
                            <span>4 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:0%; background:#F97316;"></div></div>
                            <span style="width:40px;">0%</span>
                        </div>
                        <div class="bar-row">
                            <span>3 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:0%; background:#F97316;"></div></div>
                            <span style="width:40px;">0%</span>
                        </div>
                        <div class="bar-row">
                            <span>2 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:0%; background:#F97316;"></div></div>
                            <span style="width:40px;">0%</span>
                        </div>
                        <div class="bar-row">
                            <span>1 <i class="bi bi-star-fill" style="font-size:0.6rem;"></i></span>
                            <div class="progress"><div class="progress-bar-fill" style="width:0%; background:#F97316;"></div></div>
                            <span style="width:40px;">0%</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Write Ratings Button -->
            <div class="mt-4 text-center">
                <button class="btn btn-solid w-100" data-bs-toggle="modal" data-bs-target="#reviewModal">
                    Write Ratings
                </button>
            </div>

            <!-- Reviews List -->
            <div class="mt-5">
                <h5 class="fw-bold mb-3">Recent Reviews</h5>
                <c:if test="${empty reviews}">
                    <p class="text-muted">No reviews yet.</p>
                </c:if>
                <c:forEach var="rev" items="${reviews}">
                    <div class="p-3 mb-3 border rounded-3 bg-light">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <strong class="text-dark">${rev.user.fullName}</strong>
                            <div class="text-warning">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${rev.rating >= i}"><i class="bi bi-star-fill"></i></c:when>
                                        <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="text-muted small mb-0">${rev.comment}</p>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Write Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:20px; border:none;">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold">Write a Review</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/marketplace/review" method="post">
                        <input type="hidden" name="providerId" value="${provider.id}">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label fw-600">Rating (1-5)</label>
                                <select name="rating" class="form-select form-input" required>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Very Good</option>
                                    <option value="3">3 - Average</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Terrible</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-600">Comment (Optional)</label>
                                <textarea name="comment" class="form-control form-input" rows="4" placeholder="Share your experience..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer border-0 pt-0">
                            <button type="submit" class="btn btn-solid w-100">Submit Review</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div>
    </div>
</div>

<!-- Bottom Mobile Nav -->
<c:set var="navUserId" value="${not empty user ? user.id : (not empty sessionScope.user ? sessionScope.user.id : '')}" />
<div class="bottom-nav">
    <a href="${pageContext.request.contextPath}/users/dashboard" class="nav-item">
        <i class="bi bi-house-door-fill"></i>
        <span>Home</span>
    </a>
    <a href="${pageContext.request.contextPath}/marketplace/list?category=WOMEN_LAWYER" class="nav-item active">
        <i class="bi bi-people-fill"></i>
        <span>Lawyers</span>
    </a>
    <a href="${pageContext.request.contextPath}/marketplace/myBookings" class="nav-item">
        <i class="bi bi-calendar-event"></i>
        <span>Appointments</span>
    </a>
    <a href="${pageContext.request.contextPath}/users/profile/${navUserId}" class="nav-item">
        <i class="bi bi-person"></i>
        <span>Profile</span>
    </a>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const requestedTimeInput = document.getElementById('requestedTimeInput');
        if (requestedTimeInput) {
            const now = new Date();
            const tzOffset = now.getTimezoneOffset() * 60000;
            const localISOTime = (new Date(now - tzOffset)).toISOString().slice(0, 16);
            requestedTimeInput.setAttribute('min', localISOTime);
        }

        const consultMode = document.getElementById('consultMode');
        const callTypeGroup = document.getElementById('callTypeGroup');
        const bookingForm = document.getElementById('bookingForm');
        
        if (consultMode && callTypeGroup) {
            consultMode.addEventListener('change', function() {
                if (this.value === 'In-Person') {
                    callTypeGroup.style.display = 'none';
                } else {
                    callTypeGroup.style.display = 'block';
                }
            });
        }

        if (bookingForm) {
            bookingForm.addEventListener('submit', function(e) {
                const mode = document.getElementById('consultMode').value;
                const type = document.getElementById('callType').value;
                const baseNote = document.getElementById('baseNote').value;
                
                let combinedNote = `[Mode: ${mode}]`;
                if (mode === 'Online') {
                    combinedNote += ` [Type: ${type}]`;
                }
                combinedNote += ` - ${baseNote}`;
                
                document.getElementById('finalNote').value = combinedNote;
            });
        }
    });
</script>
</body>
</html>
