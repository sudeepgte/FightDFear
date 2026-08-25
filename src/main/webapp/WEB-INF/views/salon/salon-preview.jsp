<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${salon.name} - Salon Preview</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; font-family: 'Inter', sans-serif; }
        .cover-section { 
            height: 300px; 
            background-color: #333; 
            background-size: cover; 
            background-position: center; 
            position: relative;
        }
        .hero-section { background: #fff; padding: 0 0 40px 0; border-bottom: 1px solid #eaeaea; margin-top: -75px; }
        .profile-img { width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 5px solid #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.15); background: #fff; position: relative; z-index: 10; margin-top: -75px; }
        .salon-title { font-weight: 700; color: #333; margin-top: 15px; }
        .category-badge { background: #ffe4f0; color: #d63384; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block; margin-bottom: 10px; }
        .status-badge { background: #d1e7dd; color: #0f5132; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; display: inline-block; margin-left: 10px; }
        .info-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .section-title { font-size: 1.25rem; font-weight: 600; margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; }
        .interior-img { width: 100%; height: 200px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; }
        .contact-item { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; color: #555; }
        .contact-item i { color: #d63384; font-size: 1.1rem; }
        .badge-facility { background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; font-weight: 500; margin: 3px; }
        .badge-pref { background: #f8f9fa; color: #495057; border: 1px solid #dee2e6; font-weight: 500; font-size: 0.85rem; padding: 6px 12px; margin: 3px; display: inline-block; border-radius: 6px; }
        .data-label { color: #6c757d; font-size: 0.85rem; display: block; margin-bottom: 2px; text-transform: uppercase; letter-spacing: 0.5px; }
        .data-value { font-weight: 500; color: #212529; }
        .doc-link { display: flex; align-items: center; gap: 10px; padding: 10px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; margin-bottom: 10px; color: #333; text-decoration: none; transition: 0.2s; }
        .doc-link:hover { background: #e9ecef; }
        .doc-link i { font-size: 1.5rem; color: #d63384; }
    </style>

    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
</head>
<body>

    <!-- Cover Image Section -->
    <div class="cover-section" style="background-image: url('${not empty salon.coverImageUrl ? salon.coverImageUrl : 'https://via.placeholder.com/1200x300?text=No+Cover+Image'}');"></div>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <c:choose>
                <c:when test="${not empty salon.profileImageUrl}">
                    <img src="${salon.profileImageUrl}" alt="Profile Photo" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="https://via.placeholder.com/150" alt="Default Profile" class="profile-img">
                </c:otherwise>
            </c:choose>
            <h1 class="salon-title">${not empty salon.name ? salon.name : 'Your Salon Name'}</h1>
            <div>
                <div class="category-badge">${not empty salon.salonCategory ? salon.salonCategory : 'Category not set'}</div>
                <c:if test="${not empty salon.currentStatus}">
                    <div class="status-badge">${salon.currentStatus}</div>
                </c:if>
            </div>
            
            <p class="text-muted mb-2" style="max-width: 600px; margin: 0 auto; font-style: italic; font-size: 1.1rem;">
                ${not empty salon.salonTagline ? salon.salonTagline : ''}
            </p>
            <p class="text-secondary mt-3" style="max-width: 800px; margin: 0 auto;">
                ${not empty salon.bio ? salon.bio : 'No bio provided yet.'}
            </p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mt-4 mb-5">
        <div class="row">
            <!-- Left Column -->
            <div class="col-lg-8">
                <!-- Interior Photos -->
                <div class="info-card">
                    <h3 class="section-title">Interior Photos</h3>
                    <div class="row">
                        <c:choose>
                            <c:when test="${not empty interiorImagesList}">
                                <c:forEach var="img" items="${interiorImagesList}">
                                    <div class="col-md-6">
                                        <img src="${img}" class="interior-img" alt="Interior Photo">
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12"><p class="text-muted">No interior photos uploaded yet.</p></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Salon Details -->
                <div class="info-card">
                    <h3 class="section-title">About the Salon</h3>
                    <div class="row mb-4">
                        <div class="col-sm-4 mb-3"><span class="data-label">Established Year</span><span class="data-value">${not empty salon.establishedYear ? salon.establishedYear : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Total Chairs</span><span class="data-value">${not empty salon.totalChairs ? salon.totalChairs : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Treatment Rooms</span><span class="data-value">${not empty salon.treatmentRooms ? salon.treatmentRooms : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Languages</span><span class="data-value">${not empty salon.languagesSpoken ? salon.languagesSpoken : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Salon Size</span><span class="data-value">${not empty salon.salonSizeSqFt ? salon.salonSizeSqFt += ' sq ft' : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Total Floors</span><span class="data-value">${not empty salon.totalFloors ? salon.totalFloors : 'N/A'}</span></div>
                        <div class="col-sm-4 mb-3"><span class="data-label">Washrooms</span><span class="data-value">${not empty salon.washrooms ? salon.washrooms : 'N/A'}</span></div>
                    </div>
                    
                    <h5 class="fw-semibold mb-3" style="font-size: 1rem;">Facilities & Amenities</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:if test="${salon.hasAc}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-snow"></i> Air Conditioned</span></c:if>
                        <c:if test="${salon.hasWifi}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-wifi"></i> Free Wi-Fi</span></c:if>
                        <c:if test="${salon.hasParking}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-car-front-fill"></i> Parking Available</span></c:if>
                        <c:if test="${salon.hasPowerBackup}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-lightning-fill"></i> Power Backup</span></c:if>
                        <c:if test="${salon.isWheelchairAccessible}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-person-wheelchair"></i> Wheelchair Accessible</span></c:if>
                        <c:if test="${salon.isWomenOnly}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-gender-female"></i> Women Only</span></c:if>
                        <c:if test="${salon.hasReceptionArea}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-building"></i> Reception Area</span></c:if>
                        <c:if test="${salon.hasWaitingArea}"><span class="badge badge-facility px-3 py-2 rounded-pill"><i class="bi bi-cup-hot"></i> Waiting Lounge</span></c:if>
                    </div>
                </div>

                <!-- Preferences -->
                <div class="info-card">
                    <h3 class="section-title">Salon Policies & Preferences</h3>
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-semibold text-dark" style="font-size: 0.95rem;">Booking Policies</h5>
                            <c:if test="${salonPrefs['pref_online_booking'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Online Booking Accepted</div></c:if>
                            <c:if test="${salonPrefs['pref_walkins'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Walk-ins Welcome</div></c:if>
                            <c:if test="${salonPrefs['pref_sameday'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Same-Day Booking</div></c:if>
                            <c:if test="${salonPrefs['pref_multiple_services'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Multiple Services Allowed</div></c:if>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-semibold text-dark" style="font-size: 0.95rem;">Cancellation Policies</h5>
                            <c:if test="${salonPrefs['pref_cancellation'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Cancellation Allowed (${salonPrefs['pref_notice_period']} hrs notice)</div></c:if>
                            <c:if test="${salonPrefs['pref_rescheduling'] == 'true'}"><div class="badge-pref"><i class="bi bi-check-circle-fill text-success"></i> Rescheduling Allowed</div></c:if>
                            <c:if test="${not empty salonPrefs['pref_advance_payment']}"><div class="badge-pref"><i class="bi bi-currency-dollar text-success"></i> Advance: ${salonPrefs['pref_advance_payment']}%</div></c:if>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-semibold text-dark" style="font-size: 0.95rem;">Customer Preferences</h5>
                            <c:if test="${salonPrefs['pref_women_only'] == 'true'}"><div class="badge-pref"><i class="bi bi-gender-female text-primary"></i> Women Only Services</div></c:if>
                            <c:if test="${salonPrefs['pref_new_customers'] == 'true'}"><div class="badge-pref"><i class="bi bi-person-plus text-primary"></i> Accepting New Clients</div></c:if>
                            <c:if test="${salonPrefs['pref_preferred_staff'] == 'true'}"><div class="badge-pref"><i class="bi bi-person-check text-primary"></i> Select Preferred Staff</div></c:if>
                            <c:if test="${salonPrefs['pref_female_staff'] == 'true'}"><div class="badge-pref"><i class="bi bi-person-badge text-primary"></i> Female Staff Available</div></c:if>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-semibold text-dark" style="font-size: 0.95rem;">Hygiene & Privacy</h5>
                            <c:if test="${salonPrefs['pref_consultation'] == 'true'}"><div class="badge-pref"><i class="bi bi-chat-text text-info"></i> Pre-service Consultation</div></c:if>
                            <c:if test="${salonPrefs['pref_patch_test'] == 'true'}"><div class="badge-pref"><i class="bi bi-patch-check text-info"></i> Patch Testing Required</div></c:if>
                            <c:if test="${salonPrefs['pref_private_rooms'] == 'true'}"><div class="badge-pref"><i class="bi bi-door-closed text-info"></i> Private Rooms Available</div></c:if>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-semibold text-dark" style="font-size: 0.95rem;">Notifications & Alerts</h5>
                            <c:if test="${salonPrefs['pref_alerts'] == 'true'}"><div class="badge-pref"><i class="bi bi-bell text-warning"></i> Push Alerts</div></c:if>
                            <c:if test="${salonPrefs['pref_whatsapp'] == 'true'}"><div class="badge-pref"><i class="bi bi-whatsapp text-success"></i> WhatsApp Updates</div></c:if>
                            <c:if test="${salonPrefs['pref_sms'] == 'true'}"><div class="badge-pref"><i class="bi bi-chat-dots text-primary"></i> SMS Updates</div></c:if>
                            <c:if test="${salonPrefs['pref_email'] == 'true'}"><div class="badge-pref"><i class="bi bi-envelope text-secondary"></i> Email Updates</div></c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-lg-4">
                <!-- Contact Info -->
                <div class="info-card">
                    <h3 class="section-title">Contact Information</h3>
                    <div class="contact-item"><i class="bi bi-geo-alt-fill"></i> 
                        <div>
                            ${not empty salon.address ? salon.address : 'Address not set'}<br>
                            ${salon.city} ${salon.state} ${salon.pincode}
                        </div>
                    </div>
                    <c:if test="${not empty salon.landmark}"><div class="contact-item"><i class="bi bi-geo"></i> Landmark: ${salon.landmark}</div></c:if>
                    
                    <div class="contact-item"><i class="bi bi-telephone-fill"></i> ${not empty salon.phone ? salon.phone : 'Phone not set'}</div>
                    <c:if test="${not empty salon.alternateNumber}"><div class="contact-item"><i class="bi bi-telephone"></i> ${salon.alternateNumber} (Alt)</div></c:if>
                    
                    <div class="contact-item"><i class="bi bi-envelope-fill"></i> ${not empty salon.email ? salon.email : 'Email not set'}</div>
                    <c:if test="${not empty salon.website}">
                        <div class="contact-item"><i class="bi bi-globe"></i> <a href="${salon.website}" target="_blank" class="text-decoration-none">${salon.website}</a></div>
                    </c:if>
                    
                    <hr class="my-3">
                    
                    <!-- Social Media Links -->
                    <h5 class="fw-semibold mb-3" style="font-size: 1rem;">Social Media</h5>
                    <div class="d-flex gap-3">
                        <c:if test="${not empty salonSocial['instagram']}">
                            <a href="https://instagram.com/${salonSocial['instagram']}" target="_blank" class="text-dark fs-4"><i class="bi bi-instagram text-danger"></i></a>
                        </c:if>
                        <c:if test="${not empty salonSocial['facebook']}">
                            <a href="${salonSocial['facebook']}" target="_blank" class="text-dark fs-4"><i class="bi bi-facebook text-primary"></i></a>
                        </c:if>
                        <c:if test="${empty salonSocial['instagram'] and empty salonSocial['facebook']}">
                            <p class="text-muted small">No social media added.</p>
                        </c:if>
                    </div>
                </div>

                <!-- Operating Hours -->
                <div class="info-card">
                    <h3 class="section-title">Operating Hours</h3>
                    <c:choose>
                        <c:when test="${not empty salonHoursDisplay}">
                            <c:forEach var="day" items="monday,tuesday,wednesday,thursday,friday,saturday,sunday">
                                <div class="d-flex justify-content-between mb-2 pb-2 border-bottom" style="font-size: 0.95rem;">
                                    <span style="text-transform: capitalize; font-weight: 500; color: #495057;">${day}</span>
                                    <span class="fw-semibold text-dark">${salonHoursDisplay[day]}</span>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Hours not set</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Trust & Safety & Documents -->
                <div class="info-card bg-light border-0">
                    <h3 class="section-title" style="border-bottom-color: #ddd;">Trust & Safety</h3>
                    <c:if test="${salon.isCertified}"><div class="mb-2 text-success fw-medium"><i class="bi bi-shield-check me-2"></i> Certified Professionals</div></c:if>
                    <c:if test="${salon.isEcoFriendly}"><div class="mb-2 text-success fw-medium"><i class="bi bi-tree me-2"></i> Eco-Friendly Products</div></c:if>
                    <c:if test="${not empty salon.hygieneStandard}"><div class="mb-2 text-dark fw-medium"><i class="bi bi-stars me-2 text-warning"></i> Hygiene: ${salon.hygieneStandard}</div></c:if>
                    
                    <hr class="my-3 border-secondary">
                    <h5 class="fw-semibold mb-3" style="font-size: 1rem;">Official Documents</h5>
                    
                    <c:if test="${not empty salon.businessRegistrationNo}"><div class="mb-2 text-muted" style="font-size: 0.85rem;"><strong>Reg No:</strong> ${salon.businessRegistrationNo}</div></c:if>
                    <c:if test="${not empty salon.salonLicenseNo}"><div class="mb-2 text-muted" style="font-size: 0.85rem;"><strong>License:</strong> ${salon.salonLicenseNo}</div></c:if>
                    <c:if test="${not empty salon.gstNumber}"><div class="mb-3 text-muted" style="font-size: 0.85rem;"><strong>GST:</strong> ${salon.gstNumber}</div></c:if>

                    <c:if test="${not empty salon.businessRegistrationUrl}">
                        <a href="${salon.businessRegistrationUrl}" target="_blank" class="doc-link">
                            <i class="bi bi-file-earmark-text"></i>
                            <div>
                                <div class="fw-semibold" style="font-size: 0.9rem;">Business Registration</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Click to view document</div>
                            </div>
                        </a>
                    </c:if>
                    <c:if test="${not empty salon.salonLicenseUrl}">
                        <a href="${salon.salonLicenseUrl}" target="_blank" class="doc-link">
                            <i class="bi bi-file-earmark-check"></i>
                            <div>
                                <div class="fw-semibold" style="font-size: 0.9rem;">Salon License</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Click to view document</div>
                            </div>
                        </a>
                    </c:if>
                    <c:if test="${not empty salon.fireSafetyUrl}">
                        <a href="${salon.fireSafetyUrl}" target="_blank" class="doc-link">
                            <i class="bi bi-fire text-danger"></i>
                            <div>
                                <div class="fw-semibold" style="font-size: 0.9rem;">Fire Safety Certificate</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Click to view document</div>
                            </div>
                        </a>
                    </c:if>
                    <c:if test="${not empty salon.hygieneCertificateUrl}">
                        <a href="${salon.hygieneCertificateUrl}" target="_blank" class="doc-link">
                            <i class="bi bi-shield-plus text-success"></i>
                            <div>
                                <div class="fw-semibold" style="font-size: 0.9rem;">Hygiene Certificate</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Click to view document</div>
                            </div>
                        </a>
                    </c:if>
                    <c:if test="${not empty salon.gstCertificateUrl}">
                        <a href="${salon.gstCertificateUrl}" target="_blank" class="doc-link">
                            <i class="bi bi-receipt-cutoff text-info"></i>
                            <div>
                                <div class="fw-semibold" style="font-size: 0.9rem;">GST Certificate</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Click to view document</div>
                            </div>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

