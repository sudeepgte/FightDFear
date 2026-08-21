<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Organizer Profile Completion — Women Safety Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css"/>
    <style>
        :root {
            --primary-navy: #1e1b4b;
            --primary-pink: #f43f5e;
            --soft-pink: #fff1f2;
            --soft-pink-border: #fecdd3;
            --bg-soft: #ffffff;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-clr: #ffe4e6;
            --card-bg: #ffffff;
            --gradient-main: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --success-bg: #ecfdf5;
            --success-text: #047857;
            --danger-bg: #fee2e2;
            --danger-text: #b91c1c;
            --warning-bg: #fffbeb;
            --warning-text: #b45309;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background: var(--bg-soft); color: var(--text-dark); display: flex; min-height: 100vh; }

        /* Main Area (Standalone Full-Width Soft Light Pink Header Layout) */
        .main-wrapper { margin-left: 0; flex: 1; display: flex; flex-direction: column; min-width: 0; width: 100%; }
        .topbar { background: var(--soft-pink); color: var(--primary-navy); padding: 18px 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--soft-pink-border); position: sticky; top: 0; z-index: 50; }
        .topbar-brand { display: flex; align-items: center; gap: 14px; }
        .topbar-brand .brand-icon { width: 42px; height: 42px; background: var(--primary-pink); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; color: #fff; box-shadow: 0 4px 12px rgba(244, 63, 94, 0.2); }
        .topbar h2 { font-size: 1.3rem; font-weight: 800; color: var(--primary-navy); margin: 0; }
        .topbar p { font-size: 0.88rem; color: #475569; margin: 3px 0 0; font-weight: 500; }

        .page-content { padding: 28px 32px; flex: 1; max-width: 1200px; margin: 0 auto; width: 100%; background: #ffffff; }

        /* Status & Progress Cards */
        .progress-card {
            background: var(--card-bg); border-radius: 16px; padding: 22px 28px;
            box-shadow: 0 4px 20px rgba(30,27,75,0.05); border: 1px solid var(--border-clr); margin-bottom: 24px;
        }
        .progress-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
        .progress-header h4 { font-size: 1.05rem; font-weight: 800; color: var(--primary-navy); margin: 0; }
        .progress-bar-wrap { height: 12px; background: #e2e8f0; border-radius: 10px; overflow: hidden; margin-bottom: 12px; }
        .progress-bar-fill { height: 100%; background: var(--gradient-main); border-radius: 10px; transition: width 0.4s ease; }

        .status-badge {
            display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 20px;
            font-size: 0.82rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-INCOMPLETE { background: var(--soft-pink); color: var(--primary-pink); border: 1px solid #fca5a5; }
        .status-PENDING { background: var(--warning-bg); color: var(--warning-text); border: 1px solid #fde68a; }
        .status-APPROVED { background: var(--success-bg); color: var(--success-text); border: 1px solid #a7f3d0; }
        .status-CHANGES { background: var(--warning-bg); color: var(--warning-text); border: 1px solid #fde68a; }
        .status-REJECTED { background: var(--danger-bg); color: var(--danger-text); border: 1px solid #fca5a5; }

        /* 11 Section Tab Switcher */
        .section-tabs {
            display: flex; gap: 8px; overflow-x: auto; padding-bottom: 12px; margin-bottom: 24px;
            border-bottom: 2px solid var(--border-clr); scrollbar-width: thin;
        }
        .sec-tab {
            padding: 10px 18px; background: var(--card-bg); border: 1px solid var(--border-clr);
            border-radius: 10px; font-size: 0.88rem; font-weight: 700; color: var(--text-muted);
            cursor: pointer; transition: 0.2s; white-space: nowrap; display: flex; align-items: center; gap: 8px;
        }
        .sec-tab:hover { color: var(--primary-pink); border-color: var(--primary-pink); }
        .sec-tab.active { background: var(--primary-navy); color: white; border-color: var(--primary-navy); box-shadow: 0 4px 12px rgba(30,27,75,0.15); }
        .sec-tab i { font-size: 1rem; }

        /* Section Container */
        .section-pane { display: none; background: var(--card-bg); border-radius: 16px; padding: 30px; border: 1px solid var(--border-clr); box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
        .section-pane.active { display: block; animation: fadeIn 0.3s ease; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

        .pane-title { font-size: 1.2rem; font-weight: 800; color: var(--primary-navy); margin-bottom: 6px; border-left: 4px solid var(--primary-pink); padding-left: 12px; }
        .pane-sub { font-size: 0.88rem; color: var(--text-muted); margin-bottom: 24px; }

        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group-full { grid-column: span 2; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 0.88rem; font-weight: 700; color: var(--text-dark); margin-bottom: 8px; }
        .form-group label span.req { color: var(--primary-pink); }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 12px 14px; border: 1.5px solid var(--border-clr); border-radius: 10px;
            font-family: inherit; font-size: 0.92rem; color: var(--text-dark); outline: none; transition: 0.2s; background: #fafafa;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: var(--primary-pink); background: white; box-shadow: 0 0 0 3.5px rgba(244,63,94,0.1);
        }

        /* Interactive Chips Selector */
        .chips-grid { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 6px; }
        .chip-item {
            padding: 8px 16px; background: #f1f5f9; border: 1.5px solid var(--border-clr);
            border-radius: 20px; font-size: 0.85rem; font-weight: 600; color: var(--text-dark);
            cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px; user-select: none;
        }
        .chip-item:hover { border-color: var(--primary-pink); color: var(--primary-pink); }
        .chip-item.selected { background: var(--soft-pink); border-color: var(--primary-pink); color: var(--primary-pink); font-weight: 700; }
        .chip-item.selected i { display: inline-block; }
        .chip-item i { display: none; }

        /* Footer Actions */
        .actions-footer {
            margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--border-clr);
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
        }
        .btn-save-progress {
            padding: 13px 26px; background: var(--card-bg); border: 2px solid var(--primary-navy);
            color: var(--primary-navy); border-radius: 10px; font-family: inherit; font-size: 0.95rem; font-weight: 700;
            cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-save-progress:hover { background: var(--primary-navy); color: white; }

        .btn-submit-verify {
            padding: 13px 28px; background: var(--gradient-main); border: none;
            color: white; border-radius: 10px; font-family: inherit; font-size: 0.95rem; font-weight: 700;
            cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 4px 14px rgba(244,63,94,0.25);
        }
        .btn-submit-verify:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 8px 18px rgba(244,63,94,0.35); }
        .btn-submit-verify:disabled { opacity: 0.5; cursor: not-allowed; transform: none; box-shadow: none; }

        @media (max-width: 992px) {
            body { display: block; }
            .sidebar { width: 100%; position: relative; height: auto; }
            .main-wrapper { margin-left: 0; }
            .form-grid-2 { grid-template-columns: 1fr; }
            .form-group-full { grid-column: span 1; }
        }
    </style>
</head>
<body>

<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-brand">
            <div class="brand-icon"><i class="bi bi-shield-heart-fill"></i></div>
            <div>
                <h2>Host Profile Completion</h2>
                <p>Complete all 11 required sections to submit your host application for Admin Approval.</p>
            </div>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/women-events/host/logout" style="background:#ffffff; color:#f43f5e; border:1px solid #fecdd3; border-radius:10px; padding:8px 18px; font-size:0.85rem; font-weight:700; text-decoration:none; display:inline-flex; align-items:center; gap:6px; box-shadow:0 2px 6px rgba(244,63,94,0.08);">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <div class="page-content">
        <!-- Status & Progress Overview -->
        <div class="progress-card">
            <div class="progress-header">
                <div>
                    <h4>Profile Completion Progress: <span id="pctText">${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%</span></h4>
                </div>
                <div>
                    <c:set var="statusStr" value="${host.partnerProfileStatus != null ? host.partnerProfileStatus.name() : 'PROFILE_INCOMPLETE'}"/>
                    <span class="status-badge status-${fn:contains(statusStr, 'APPROVED') ? 'APPROVED' : fn:contains(statusStr, 'PENDING') ? 'PENDING' : fn:contains(statusStr, 'CHANGES') ? 'CHANGES' : fn:contains(statusStr, 'REJECTED') ? 'REJECTED' : 'INCOMPLETE'}">
                        <i class="bi bi-info-circle-fill"></i> Status: ${host.partnerProfileStatus != null ? host.partnerProfileStatus.name() : 'PROFILE_INCOMPLETE'}
                    </span>
                </div>
            </div>
            <div class="progress-bar-wrap">
                <div class="progress-bar-fill" id="progressBarFill" style="width: ${host.profileCompletionPct != null ? host.profileCompletionPct : 0}%;"></div>
            </div>
            
            <!-- Conditional Guidance Banner -->
            <c:if test="${statusStr eq 'PENDING_ADMIN_APPROVAL'}">
                <div class="alert alert-warning mb-0 mt-3 rounded-3" style="font-size: 0.9rem;">
                    <i class="bi bi-clock-history me-2"></i> <strong>Submitted for Verification:</strong> Your profile is currently under admin review. You cannot edit fields while pending approval.
                </div>
            </c:if>
            <c:if test="${statusStr eq 'CHANGES_REQUESTED'}">
                <div class="alert alert-warning mb-0 mt-3 rounded-3" style="font-size: 0.9rem;">
                    <i class="bi bi-exclamation-circle-fill me-2"></i> <strong>Admin Feedback:</strong> ${host.changesRequestedNote}
                </div>
            </c:if>
            <c:if test="${statusStr eq 'APPROVED'}">
                <div class="alert alert-success mb-0 mt-3 rounded-3" style="font-size: 0.9rem;">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Verified & Approved:</strong> Your host account is fully verified. You can now publish events to the public.
                </div>
            </c:if>
            <c:if test="${statusStr eq 'REJECTED'}">
                <div class="alert alert-danger mb-0 mt-3 rounded-3" style="font-size: 0.9rem;">
                    <i class="bi bi-x-circle-fill me-2"></i> <strong>Application Rejected:</strong> ${host.rejectionReason}
                </div>
            </c:if>
        </div>

        <div id="alertBox" class="alert alert-danger rounded-3" style="display: none;" role="alert"></div>

        <!-- 11 Section Tabs -->
        <div class="section-tabs">
            <div class="sec-tab active" onclick="switchTab(1)"><i class="bi bi-person-vcard"></i> 1. Identity</div>
            <div class="sec-tab" onclick="switchTab(2)"><i class="bi bi-geo-alt"></i> 2. Location</div>
            <div class="sec-tab" onclick="switchTab(3)"><i class="bi bi-tags"></i> 3. Categories</div>
            <div class="sec-tab" onclick="switchTab(4)"><i class="bi bi-people"></i> 4. Audience</div>
            <div class="sec-tab" onclick="switchTab(5)"><i class="bi bi-building-gear"></i> 5. Facilities</div>
            <div class="sec-tab" onclick="switchTab(6)"><i class="bi bi-clock-history"></i> 6. Hours</div>
            <div class="sec-tab" onclick="switchTab(7)"><i class="bi bi-card-text"></i> 7. About</div>
            <div class="sec-tab" onclick="switchTab(8)"><i class="bi bi-ticket-perforated"></i> 8. Offering</div>
            <div class="sec-tab" onclick="switchTab(9)"><i class="bi bi-credit-card"></i> 9. Payout</div>
            <div class="sec-tab" onclick="switchTab(10)"><i class="bi bi-image"></i> 10. Profile Image</div>
            <div class="sec-tab" onclick="switchTab(11)"><i class="bi bi-images"></i> 11. Gallery</div>
        </div>

        <!-- Form for Profile Sections -->
        <form id="profileForm" onsubmit="saveProfile(event)">

            <!-- Section 1: Identity -->
            <div class="section-pane active" id="pane1">
                <div class="pane-title">Section 1: Host Identity &amp; Organization</div>
                <div class="pane-sub">Basic credentials and contact details.</div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Full Name <span class="req">*</span></label>
                        <input type="text" id="fullName" name="fullName" value="${host.fullName}" required/>
                    </div>
                    <div class="form-group">
                        <label>Organizer Type <span class="req">*</span></label>
                        <select id="organizerType" name="organizerType" required>
                            <option value="">Select Type...</option>
                            <option value="NGO" ${host.organizerType eq 'NGO' ? 'selected' : ''}>NGO</option>
                            <option value="Company" ${host.organizerType eq 'Company' ? 'selected' : ''}>Company</option>
                            <option value="Educational Institution" ${host.organizerType eq 'Educational Institution' ? 'selected' : ''}>Educational Institution</option>
                            <option value="Government Department" ${host.organizerType eq 'Government Department' ? 'selected' : ''}>Government Department</option>
                            <option value="Community Organization" ${host.organizerType eq 'Community Organization' ? 'selected' : ''}>Community Organization</option>
                            <option value="Women Self Help Group" ${host.organizerType eq 'Women Self Help Group' ? 'selected' : ''}>Women Self Help Group</option>
                            <option value="Startup" ${host.organizerType eq 'Startup' ? 'selected' : ''}>Startup</option>
                            <option value="Fitness Organization" ${host.organizerType eq 'Fitness Organization' ? 'selected' : ''}>Fitness Organization</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Organization Name <span class="req">*</span></label>
                        <input type="text" id="organizerName" name="organizerName" value="${host.organizerName}" required/>
                    </div>
                    <div class="form-group">
                        <label>Official Phone Number (10 Digits) <span class="req">*</span></label>
                        <input type="text" id="phone" name="phone" value="${host.phone}" required pattern="^\d{10}$" maxlength="10"/>
                    </div>
                    <div class="form-group">
                        <label>GST / NGO / CIN / Registration Number <span class="req">*</span></label>
                        <input type="text" id="credentialNumber" name="credentialNumber" value="${host.credentialNumber}" placeholder="e.g. 29AAAAA0000A1Z5" required/>
                    </div>
                    <div class="form-group">
                        <label>WhatsApp Contact Number</label>
                        <input type="text" id="whatsappNumber" name="whatsappNumber" value="${host.whatsappNumber}" placeholder="e.g. 9876543210"/>
                    </div>
                    <div class="form-group">
                        <label>Years of Experience</label>
                        <input type="number" id="yearsExperience" name="yearsExperience" value="${host.yearsExperience}" min="0"/>
                    </div>
                </div>
            </div>

            <!-- Section 2: Location -->
            <div class="section-pane" id="pane2">
                <div class="pane-title">Section 2: Office &amp; Venue Location</div>
                <div class="pane-sub">Physical address details for safety verification.</div>
                <div class="form-grid-2">
                    <div class="form-group form-group-full">
                        <label>Street Address / Office Address <span class="req">*</span></label>
                        <input type="text" id="address" name="address" value="${host.officeAddress}" required/>
                    </div>
                    <div class="form-group">
                        <label>City <span class="req">*</span></label>
                        <input type="text" id="city" name="city" value="${host.city}" required/>
                    </div>
                    <div class="form-group">
                        <label>State <span class="req">*</span></label>
                        <select id="stateSelect" name="state" onchange="toggleStateOther(this.value)" required>
                            <option value="">Select State...</option>
                            <option value="Karnataka">Karnataka</option>
                            <option value="Maharashtra">Maharashtra</option>
                            <option value="Delhi">Delhi</option>
                            <option value="Tamil Nadu">Tamil Nadu</option>
                            <option value="Telangana">Telangana</option>
                            <option value="Kerala">Kerala</option>
                            <option value="Other">Other</option>
                        </select>
                        <input type="text" id="stateOtherInput" placeholder="Specify state..." style="display: none; margin-top: 8px;"/>
                    </div>
                    <div class="form-group">
                        <label>Pincode (6 Digits) <span class="req">*</span></label>
                        <input type="text" id="pincode" name="pincode" value="${host.pincode}" required pattern="^\d{6}$" maxlength="6"/>
                    </div>
                    <div class="form-group">
                        <label>Google Maps Location Link</label>
                        <input type="url" id="mapsLocation" name="mapsLocation" value="${host.website}" placeholder="https://maps.google.com/..."/>
                    </div>
                </div>
            </div>

            <!-- Section 3: Event Categories -->
            <div class="section-pane" id="pane3">
                <div class="pane-title">Section 3: Event Categories Offered <span class="req">*</span></div>
                <div class="pane-sub">Select all types of events your organization hosts.</div>
                <div class="chips-grid" id="categoryChips">
                    <div class="chip-item" onclick="toggleChip(this, 'Health & Wellness')"><i class="bi bi-check2"></i> Health &amp; Wellness</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Entrepreneurship & Career')"><i class="bi bi-check2"></i> Entrepreneurship &amp; Career</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Fitness & Sports')"><i class="bi bi-check2"></i> Fitness &amp; Sports</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Education & Skills')"><i class="bi bi-check2"></i> Education &amp; Skills</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Social & Community')"><i class="bi bi-check2"></i> Social &amp; Community</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Safety & Awareness')"><i class="bi bi-check2"></i> Safety &amp; Awareness</div>
                </div>
                <input type="hidden" id="eventCategories" name="eventCategories" value="${host.eventCategories}"/>
            </div>

            <!-- Section 4: Audience -->
            <div class="section-pane" id="pane4">
                <div class="pane-title">Section 4: Who I Serve &amp; Services <span class="req">*</span></div>
                <div class="pane-sub">Define target audiences and doorstep service availability.</div>
                <div class="chips-grid" id="audienceChips">
                    <div class="chip-item" onclick="toggleChip(this, 'Women Only')"><i class="bi bi-check2"></i> Women Only</div>
                    <div class="chip-item" onclick="toggleChip(this, 'College Girls')"><i class="bi bi-check2"></i> College Girls</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Working Professionals')"><i class="bi bi-check2"></i> Working Professionals</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Mothers & Homemakers')"><i class="bi bi-check2"></i> Mothers &amp; Homemakers</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Senior Citizens')"><i class="bi bi-check2"></i> Senior Citizens</div>
                </div>
                <input type="hidden" id="audience" name="audience" value="${host.audience}"/>

                <div class="form-group mt-4">
                    <label>
                        <input type="checkbox" id="doorService" name="doorService" ${host.doorService ? 'checked' : ''} style="width: auto; margin-right: 8px;"/>
                        Available for Doorstep / On-site Private Sessions
                    </label>
                </div>
            </div>

            <!-- Section 5: Facilities -->
            <div class="section-pane" id="pane5">
                <div class="pane-title">Section 5: Facilities Available at Venue</div>
                <div class="pane-sub">Select venue amenities available for participants.</div>
                <div class="chips-grid" id="facilityChips">
                    <div class="chip-item" onclick="toggleChip(this, 'Parking')"><i class="bi bi-check2"></i> Parking</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Wi-Fi')"><i class="bi bi-check2"></i> Wi-Fi</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Projector / Screen')"><i class="bi bi-check2"></i> Projector / Screen</div>
                    <div class="chip-item" onclick="toggleChip(this, 'AC')"><i class="bi bi-check2"></i> Air Conditioned</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Restroom')"><i class="bi bi-check2"></i> Clean Restroom</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Refreshments')"><i class="bi bi-check2"></i> Refreshments</div>
                    <div class="chip-item" onclick="toggleChip(this, 'First Aid')"><i class="bi bi-check2"></i> First Aid Kit</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Sound System')"><i class="bi bi-check2"></i> Sound System</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Wheelchair Accessible')"><i class="bi bi-check2"></i> Wheelchair Accessible</div>
                </div>
                <input type="hidden" id="facilities" name="facilities" value="${host.facilities}"/>
            </div>

            <!-- Section 6: Hours & Calendar -->
            <div class="section-pane" id="pane6">
                <div class="pane-title">Section 6: Operating Hours &amp; Days</div>
                <div class="pane-sub">Specify operational schedule.</div>
                <label>Open Days <span class="req">*</span></label>
                <div class="chips-grid mb-4" id="daysChips">
                    <div class="chip-item" onclick="toggleChip(this, 'Mon')"><i class="bi bi-check2"></i> Mon</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Tue')"><i class="bi bi-check2"></i> Tue</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Wed')"><i class="bi bi-check2"></i> Wed</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Thu')"><i class="bi bi-check2"></i> Thu</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Fri')"><i class="bi bi-check2"></i> Fri</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Sat')"><i class="bi bi-check2"></i> Sat</div>
                    <div class="chip-item" onclick="toggleChip(this, 'Sun')"><i class="bi bi-check2"></i> Sun</div>
                </div>
                <input type="hidden" id="openDays" name="openDays" value="${host.openDays}"/>

                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Opening Time <span class="req">*</span></label>
                        <input type="time" id="openTime" name="openTime" value="${host.openTime}" required/>
                    </div>
                    <div class="form-group">
                        <label>Closing Time <span class="req">*</span></label>
                        <input type="time" id="closeTime" name="closeTime" value="${host.closeTime}" required/>
                    </div>
                </div>
            </div>

            <!-- Section 7: About -->
            <div class="section-pane" id="pane7">
                <div class="pane-title">Section 7: About Organization / Host Bio <span class="req">*</span></div>
                <div class="pane-sub">Detailed description shown to women attendees.</div>
                <div class="form-group">
                    <textarea id="hostBio" name="hostBio" rows="6" required placeholder="Describe your mission, background, and previous experience hosting safety/wellness events...">${host.hostBio}</textarea>
                </div>
            </div>

            <!-- Section 8: Offering -->
            <div class="section-pane" id="pane8">
                <div class="pane-title">Section 8: Typical Event Offering</div>
                <div class="pane-sub">Define standard session parameters.</div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label>Session Mode <span class="req">*</span></label>
                        <select id="sessionMode" name="sessionMode" required>
                            <option value="">Select Mode...</option>
                            <option value="In-Person" ${host.sessionMode eq 'In-Person' ? 'selected' : ''}>In-Person</option>
                            <option value="Virtual" ${host.sessionMode eq 'Virtual' ? 'selected' : ''}>Virtual / Online</option>
                            <option value="Hybrid" ${host.sessionMode eq 'Hybrid' ? 'selected' : ''}>Hybrid</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Duration (Minutes)</label>
                        <input type="number" id="durationMinutes" name="durationMinutes" value="${host.durationMinutes}" placeholder="60"/>
                    </div>
                    <div class="form-group">
                        <label>Typical Ticket Price (₹) <span class="req">*</span></label>
                        <input type="number" id="typicalPrice" name="typicalPrice" value="${host.typicalPrice}" step="0.01" required placeholder="0.00 for Free"/>
                    </div>
                </div>
            </div>

            <!-- Section 9: Payout -->
            <div class="section-pane" id="pane9">
                <div class="pane-title">Section 9: Payout &amp; Financial Details</div>
                <div class="pane-sub">Used for ticket fee payouts.</div>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label>UPI ID (for Direct Payouts)</label>
                        <input type="text" id="upiId" name="upiId" value="${host.upiId}" placeholder="username@upi"/>
                    </div>
                    <div class="form-group form-group-full">
                        <label>Bank Account Details (Account No, IFSC Code, Bank Name)</label>
                        <textarea id="bankDetails" name="bankDetails" rows="3" placeholder="Account No: 123456789, IFSC: SBIN0001234...">${host.bankDetails}</textarea>
                    </div>
                </div>
            </div>

            <!-- Section 10: Profile Image -->
            <div class="section-pane" id="pane10">
                <div class="pane-title">Section 10: Profile Image / Logo</div>
                <div class="pane-sub">Upload branding image for event listings.</div>
                <div class="form-group">
                    <label>Profile Image / Logo URL or Path</label>
                    <input type="text" id="logoPath" name="logoPath" value="${host.logoPath}"/>
                </div>
            </div>

            <!-- Section 11: Gallery -->
            <div class="section-pane" id="pane11">
                <div class="pane-title">Section 11: Event Photo Gallery</div>
                <div class="pane-sub">Gallery URLs separated by commas.</div>
                <div class="form-group">
                    <label>Gallery Image URLs (Comma-separated)</label>
                    <textarea id="galleryPhotos" name="galleryPhotos" rows="4">${host.galleryPhotos}</textarea>
                </div>
            </div>

            <!-- Footer Actions -->
            <div class="actions-footer">
                <button type="button" class="btn-save-progress" onclick="saveProfile(event)">
                    <i class="bi bi-floppy"></i> Save Progress
                </button>

                <button type="button" id="btnSubmitVerification" class="btn-submit-verify" onclick="submitForVerification()">
                    <i class="bi bi-shield-check"></i> Submit for Admin Verification
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    function switchTab(num) {
        document.querySelectorAll('.sec-tab').forEach((t, i) => {
            t.classList.toggle('active', i === (num - 1));
        });
        document.querySelectorAll('.section-pane').forEach((p, i) => {
            p.classList.toggle('active', i === (num - 1));
        });
    }

    function toggleChip(el, value) {
        el.classList.toggle('selected');
        const parent = el.parentElement;
        const hiddenId = parent.id.replace('Chips', '');
        const selectedValues = Array.from(parent.querySelectorAll('.chip-item.selected'))
            .map(c => c.innerText.trim());
        const hiddenInp = document.getElementById(hiddenId);
        if (hiddenInp) {
            hiddenInp.value = selectedValues.join(',');
        }
    }

    function initChips(hiddenId, containerId) {
        const hiddenInp = document.getElementById(hiddenId);
        if (!hiddenInp || !hiddenInp.value) return;
        const selected = hiddenInp.value.split(',').map(s => s.trim());
        const chips = document.querySelectorAll('#' + containerId + ' .chip-item');
        chips.forEach(c => {
            const txt = c.innerText.trim();
            if (selected.includes(txt)) {
                c.classList.add('selected');
            }
        });
    }

    document.addEventListener('DOMContentLoaded', () => {
        initChips('eventCategories', 'categoryChips');
        initChips('audience', 'audienceChips');
        initChips('facilities', 'facilityChips');
        initChips('openDays', 'daysChips');

        // Preset state select if value exists
        const currentPropsState = "${host.state}";
        if (currentPropsState) {
            const select = document.getElementById('stateSelect');
            if (select) {
                const optExists = Array.from(select.options).some(o => o.value === currentPropsState);
                if (optExists) select.value = currentPropsState;
                else {
                    select.value = 'Other';
                    toggleStateOther('Other');
                    document.getElementById('stateOtherInput').value = currentPropsState;
                }
            }
        }
    });

    function toggleStateOther(val) {
        const inp = document.getElementById('stateOtherInput');
        inp.style.display = (val === 'Other') ? 'block' : 'none';
    }

    async function saveProfile(e) {
        if (e) e.preventDefault();
        const alertBox = document.getElementById('alertBox');
        alertBox.style.display = 'none';

        // Custom State handling
        const stateSelect = document.getElementById('stateSelect');
        let stateVal = stateSelect ? stateSelect.value : '';
        if (stateVal === 'Other') {
            stateVal = document.getElementById('stateOtherInput').value.trim();
        }

        const payload = {
            fullName: document.getElementById('fullName').value.trim(),
            organizerType: document.getElementById('organizerType').value,
            organizerName: document.getElementById('organizerName').value.trim(),
            phone: document.getElementById('phone').value.trim(),
            credentialNumber: document.getElementById('credentialNumber').value.trim(),
            whatsappNumber: document.getElementById('whatsappNumber').value.trim(),
            yearsExperience: document.getElementById('yearsExperience').value,
            address: document.getElementById('address').value.trim(),
            city: document.getElementById('city').value.trim(),
            state: stateVal,
            pincode: document.getElementById('pincode').value.trim(),
            mapsLocation: document.getElementById('mapsLocation').value.trim(),
            eventCategories: document.getElementById('eventCategories').value,
            audience: document.getElementById('audience').value,
            doorService: document.getElementById('doorService').checked,
            facilities: document.getElementById('facilities').value,
            openDays: document.getElementById('openDays').value,
            openTime: document.getElementById('openTime').value,
            closeTime: document.getElementById('closeTime').value,
            bio: document.getElementById('hostBio').value.trim(),
            sessionMode: document.getElementById('sessionMode').value,
            durationMinutes: document.getElementById('durationMinutes').value,
            typicalPrice: document.getElementById('typicalPrice').value,
            upiId: document.getElementById('upiId').value.trim(),
            bankDetails: document.getElementById('bankDetails').value.trim(),
            logoPath: document.getElementById('logoPath').value.trim(),
            galleryPhotos: document.getElementById('galleryPhotos').value.trim()
        };

        try {
            const res = await fetch(contextPath + '/api/women-events/host/profile', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            const data = await res.json();
            if (data.success) {
                const pct = data.profileCompletionPct || 0;
                document.getElementById('pctText').innerText = pct + '%';
                document.getElementById('progressBarFill').style.width = pct + '%';
                alertBox.className = 'alert alert-success rounded-3';
                alertBox.innerText = 'Profile saved successfully!';
                alertBox.style.display = 'block';
            } else {
                alertBox.className = 'alert alert-danger rounded-3';
                alertBox.innerText = data.error || 'Failed to save profile.';
                alertBox.style.display = 'block';
            }
        } catch (err) {
            alertBox.className = 'alert alert-danger rounded-3';
            alertBox.innerText = 'Network error saving profile.';
            alertBox.style.display = 'block';
        }
    }

    async function submitForVerification() {
        const alertBox = document.getElementById('alertBox');
        alertBox.style.display = 'none';

        try {
            const res = await fetch(contextPath + '/api/women-events/host/submit-verification', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            });
            const data = await res.json();
            if (data.success) {
                window.location.href = contextPath + '/women-events/host/login?submitted=true';
            } else {
                alertBox.className = 'alert alert-danger rounded-3';
                alertBox.innerText = data.error || 'Cannot submit for verification yet. Please complete all required fields.';
                alertBox.style.display = 'block';
            }
        } catch (err) {
            alertBox.className = 'alert alert-danger rounded-3';
            alertBox.innerText = 'Network error submitting profile.';
            alertBox.style.display = 'block';
        }
    }
</script>

</body>
</html>
