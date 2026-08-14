<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Profile | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        :root {
            --sidebar-width: 250px;
            --brand-pink: #ec1868;
            --brand-pink-light: #fbe6f0;
            --sidebar-bg: #27142b;
            --sidebar-text: #d1cbd5;
            --bg-color: #f7f9fa;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --border-color: #e5e7eb;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color) !important;
            color: var(--text-dark);
            margin: 0;
            font-size: 0.8rem;
        }

        /* Sidebar */
        .sidebar { background: var(--sidebar-bg); width: var(--sidebar-width); position: fixed; height: 100vh; overflow-y: auto; color: white; padding: 20px 15px; z-index: 1000; }
        .sidebar::-webkit-scrollbar { width: 4px; }
        .sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 4px; }
        
        .sidebar-brand { display: flex; align-items: center; gap: 12px; margin-bottom: 30px; padding: 0 10px; }
        .sidebar-brand img { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
        .sidebar-brand .sb-name { font-weight: 700; font-size: 0.95rem; line-height: 1.2; }
        .sidebar-brand .sb-sub { font-size: 0.65rem; color: #a39ca8; }
        
        .nav-item { display: flex; align-items: center; gap: 12px; color: var(--sidebar-text); text-decoration: none; padding: 10px 12px; margin-bottom: 2px; border-radius: 8px; font-weight: 500; font-size: 0.85rem; transition: 0.2s;}
        .nav-item i { font-size: 1.1rem; width: 20px; text-align: center; }
        .nav-item:hover { color: white; background: rgba(255,255,255,0.05); }
        .nav-item.active { background: var(--brand-pink); color: white; }
        
        .nav-item.sign-out { color: var(--brand-pink); margin-top: 20px;}
        .nav-item.sign-out:hover { background: rgba(236, 24, 104, 0.1); }

        /* Main Content */
        .main-wrapper { margin-left: var(--sidebar-width); padding: 25px 35px 80px; }
        
        /* Top Header */
        .top-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .header-title h2 { font-size: 1.4rem; font-weight: 600; margin: 0; color: #111827; }
        .header-title p { margin: 0; color: var(--text-muted); font-size: 0.85rem; }
        
        .header-actions { display: flex; align-items: center; gap: 15px; }
        .btn-preview { background-color: var(--brand-pink); color: white; border: none; padding: 8px 16px; border-radius: 6px; font-weight: 500; font-size: 0.8rem; display: flex; align-items: center; gap: 8px; }
        .bell-icon { position: relative; width: 35px; height: 35px; border-radius: 50%; border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center; color: var(--text-muted); }
        .bell-badge { position: absolute; top: -2px; right: -2px; background: var(--brand-pink); color: white; font-size: 0.6rem; width: 14px; height: 14px; display: flex; align-items: center; justify-content: center; border-radius: 50%; }
        
        .profile-badge { display: flex; align-items: center; gap: 10px; }
        .profile-badge img { width: 35px; height: 35px; border-radius: 50%; object-fit: cover; }
        
        /* Dropdowns */
        .dropdown-menu { border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-radius: 8px; font-size: 0.8rem; }
        .dropdown-item { padding: 8px 15px; font-weight: 500; }
        .dropdown-item i { margin-right: 8px; color: var(--brand-pink); }
        .notif-item { padding: 10px 15px; border-bottom: 1px solid var(--border-color); cursor: pointer; }
        .notif-item:hover { background-color: var(--bg-color); }
        .notif-item .n-title { font-weight: 600; color: var(--text-dark); margin-bottom: 3px; }
        .notif-item .n-desc { font-size: 0.7rem; color: var(--text-muted); }
        
        /* Hero Section */
        .hero-section { background: white; border-radius: 12px; padding: 25px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .hero-top-row { display: flex; gap: 30px; margin-bottom: 20px;}
        
        /* Left: Logo & Info */
        .hero-info-box { width: 35%; display: flex; gap: 20px; align-items: flex-start; }
        .logo-container { position: relative; width: 140px; height: 140px; flex-shrink: 0; }
        .logo-img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .cam-icon { position: absolute; bottom: 0; right: 0; background: white; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 5px rgba(0,0,0,0.15); color: var(--text-dark); cursor: pointer; font-size: 1.1rem;}
        
        .info-details { padding-top: 5px; }
        .info-details h3 { font-size: 1.3rem; font-weight: 700; margin-bottom: 5px; display: flex; align-items: center; gap: 6px; color: #111827; }
        .verified-badge { color: var(--brand-pink); font-size: 1.1rem; }
        .subtitle { font-size: 0.75rem; color: var(--text-muted); margin-bottom: 12px; display: flex; align-items: center; gap: 10px; flex-wrap: wrap;}
        .women-pill { color: var(--brand-pink); font-weight: 500; }
        
        .contact-list { list-style: none; padding: 0; margin: 0; font-size: 0.8rem; color: var(--text-dark); font-weight: 500;}
        .contact-list li { margin-bottom: 6px; display: flex; align-items: flex-start; gap: 10px; }
        .contact-list i { color: var(--brand-pink); font-size: 0.9rem; margin-top: 2px; }
        .contact-list .text-muted { font-weight: 400; font-size: 0.75rem; }
        
        /* Right: Cover & Photos */
        .hero-photos-box { width: 65%; display: flex; flex-direction: column; gap: 12px; }
        .cover-img-container { position: relative; width: 100%; height: 130px; border-radius: 12px; overflow: hidden; }
        .cover-img { width: 100%; height: 100%; object-fit: cover; }
        
        .thumb-row { display: flex; gap: 10px; align-items: center; overflow-x: auto; padding-bottom: 5px; }
        .thumb-img { width: 60px; height: 60px; border-radius: 8px; object-fit: cover; flex-shrink: 0; }
        .btn-add-photo { height: 60px; border: 1px dashed var(--brand-pink); border-radius: 8px; background: var(--brand-pink-light); color: var(--brand-pink); display: flex; align-items: center; justify-content: center; font-weight: 500; font-size: 0.8rem; cursor: pointer; padding: 0 15px; flex-shrink: 0; gap: 8px; white-space: nowrap; }

        .hero-bottom-actions { display: flex; justify-content: space-between; align-items: center; padding-top: 15px; border-top: 1px solid var(--border-color); }
        .rating-box { display: flex; align-items: center; gap: 15px; font-size: 0.85rem; font-weight: 500; }
        .rating-box .star { color: #f59e0b; font-size: 1.1rem; }
        .rating-box .open-status { color: #10b981; }
        .action-btns { display: flex; gap: 10px; }
        .btn-edit { border: 1px solid var(--brand-pink); color: var(--brand-pink); background: white; padding: 6px 16px; border-radius: 6px; font-weight: 500; font-size: 0.8rem; display: flex; align-items: center; gap: 6px;}
        
        /* Tabs */
        .custom-tabs { display: flex; gap: 30px; border-bottom: 1px solid var(--border-color); margin-bottom: 25px; overflow-x: auto; background: transparent;}
        .custom-tab { text-decoration: none; padding: 10px 0; color: var(--text-muted); font-weight: 500; cursor: pointer; border-bottom: 2px solid transparent; display: flex; align-items: center; gap: 8px; white-space: nowrap; transition: 0.2s; font-size: 0.85rem;}
        .custom-tab:hover { color: var(--brand-pink); }
        .custom-tab i { font-size: 1rem; }
        .custom-tab.active { color: var(--brand-pink); border-bottom-color: var(--brand-pink); }
        
        /* 3-Column Form Layout */
        .form-grid-3col { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px; }
        
        .form-section { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .section-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
        .section-header i { background: var(--brand-pink-light); color: var(--brand-pink); width: 30px; height: 30px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1rem; }
        .section-header h4 { font-size: 0.95rem; font-weight: 600; margin: 0; color: var(--text-dark); }
        
        .f-group { margin-bottom: 15px; }
        .f-label { display: block; font-weight: 500; margin-bottom: 6px; color: var(--text-dark); font-size: 0.75rem; }
        .f-label .req { color: var(--brand-pink); }
        
        .f-control { width: 100%; padding: 8px 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 0.8rem; color: var(--text-dark); background: white; transition: 0.2s; font-family: inherit;}
        .f-control:focus { outline: none; border-color: var(--brand-pink); }
        select.f-control { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23666' class='bi bi-chevron-down' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 10px center; padding-right: 30px; }
        
        .f-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .f-row-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; }
        
        .char-count { font-size: 0.7rem; color: var(--text-muted); text-align: left; margin-top: 4px; }
        
        .toggle-switch { display: flex; align-items: center; gap: 8px; }
        .switch { position: relative; display: inline-block; width: 34px; height: 18px; }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #ccc; transition: .4s; border-radius: 18px; }
        .slider:before { position: absolute; content: ""; height: 14px; width: 14px; left: 2px; bottom: 2px; background-color: white; transition: .4s; border-radius: 50%; }
        input:checked + .slider { background-color: var(--brand-pink); }
        input:checked + .slider:before { transform: translateX(16px); }
        
        .chip-container { display: flex; flex-wrap: wrap; gap: 6px; padding: 6px; border: 1px solid var(--border-color); border-radius: 6px; min-height: 38px; align-items: center; }
        .chip { background: var(--brand-pink-light); color: var(--brand-pink); font-size: 0.7rem; padding: 3px 8px; border-radius: 4px; display: flex; align-items: center; gap: 6px; font-weight: 500; }
        .chip i { cursor: pointer; font-size: 0.8rem; }
        
        /* Documents Section */
        .doc-section { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .doc-header-text { font-size: 0.75rem; color: var(--text-muted); margin-bottom: 15px; margin-top: -10px; padding-left: 40px;}
        .doc-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 15px; }
        
        .doc-card { border: 1px solid var(--border-color); border-radius: 8px; padding: 15px 10px; display: flex; align-items: center; gap: 10px; position: relative; transition: 0.2s; }
        .doc-card:hover { border-color: var(--brand-pink); }
        
        .doc-icon-wrapper { width: 35px; height: 35px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex-shrink: 0;}
        .doc-info { flex-grow: 1; }
        .doc-title { font-size: 0.7rem; font-weight: 600; color: var(--text-dark); line-height: 1.2; margin-bottom: 4px; }
        .doc-action { color: var(--brand-pink); font-size: 0.7rem; font-weight: 500; text-decoration: none; cursor: pointer; }
        .doc-check { position: absolute; top: -6px; right: -6px; color: white; background: #10b981; font-size: 0.6rem; width: 14px; height: 14px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 2px solid white;}

        /* Bottom Fixed Bar */
        .bottom-action-bar { position: fixed; bottom: 0; left: var(--sidebar-width); right: 0; background: transparent; padding: 15px 35px; display: flex; justify-content: flex-end; gap: 15px; z-index: 99; }
        .btn-cancel { background: white; border: 1px solid var(--border-color); padding: 8px 24px; border-radius: 6px; font-weight: 500; color: var(--text-dark); font-size: 0.85rem; cursor: pointer; }
        .btn-save { background: var(--brand-pink); border: 1px solid var(--brand-pink); padding: 8px 24px; border-radius: 6px; font-weight: 500; color: white; font-size: 0.85rem; cursor: pointer; }

        /* Profile Tracker */
        .profile-tracker { background: white; border-radius: 12px; padding: 25px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; gap: 20px; }
        .pt-left { display: flex; align-items: center; gap: 20px; width: 25%; }
        .pt-circle-wrap { position: relative; width: 65px; height: 65px; border-radius: 50%; background: #f0f0f0; display: flex; align-items: center; justify-content: center; }
        .pt-circle-inner { width: 55px; height: 55px; border-radius: 50%; background: white; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: 700; color: #111827; position: absolute; }
        .pt-text h4 { font-size: 0.95rem; font-weight: 600; margin: 0 0 5px 0; color: #111827; }
        .pt-text p { font-size: 0.65rem; color: var(--text-muted); margin: 0; line-height: 1.3; }
        
        .pt-steps { flex-grow: 1; display: flex; justify-content: space-between; position: relative; --progress: 0%; }
        .pt-steps::before { content: ""; position: absolute; top: 12px; left: 20px; right: 20px; height: 2px; background: linear-gradient(to right, var(--brand-pink) var(--progress), var(--brand-pink-light) var(--progress)); z-index: 1; }
        .pt-step { position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; gap: 8px; width: 70px; }
        .pt-icon { width: 26px; height: 26px; border-radius: 50%; background: white; border: 2px solid var(--border-color); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; color: var(--border-color); }
        .pt-step.done .pt-icon { border-color: var(--brand-pink); color: white; background: var(--brand-pink); }
        .pt-label { font-size: 0.65rem; font-weight: 600; color: #111827; text-align: center; line-height: 1.2; }
        .pt-status { font-size: 0.6rem; color: var(--text-muted); }
        .pt-step.done .pt-status { color: #10b981; }
        
        .btn-visibility { background: white; border: 1px solid var(--brand-pink); color: var(--brand-pink); padding: 8px 16px; border-radius: 6px; font-weight: 500; font-size: 0.75rem; text-decoration: none; display: flex; align-items: center; gap: 8px; white-space: nowrap; transition: 0.2s;}
        .btn-visibility:hover { background: var(--brand-pink-light); color: var(--brand-pink); }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <c:choose>
                <c:when test="${not empty salon.profileImageUrl}">
                    <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" alt="Logo">
                </c:when>
                <c:otherwise>
                    <img src="https://ui-avatars.com/api/?name=${salon.name}&background=ec1868&color=fff" alt="Logo">
                </c:otherwise>
            </c:choose>
            <div>
                <div class="sb-name">${salon.name}</div>
                <div class="sb-sub">Women's Salon • Beauty • <br> Wellness • Hair Styling</div>
            </div>
        </div>
        
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="nav-item"><i class="bi bi-house"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/salons/profile" class="nav-item active"><i class="bi bi-shop"></i> Salon Profile</a>
        <a href="#" class="nav-item"><i class="bi bi-calendar-check"></i> Appointments</a>
        <a href="#" class="nav-item"><i class="bi bi-calendar3"></i> Calendar</a>
        <a href="${pageContext.request.contextPath}/salon/viewServices" class="nav-item"><i class="bi bi-scissors"></i> Services</a>
        <a href="#" class="nav-item"><i class="bi bi-people"></i> Staff / Stylists</a>
        <a href="#" class="nav-item"><i class="bi bi-person"></i> Clients</a>
        <a href="#" class="nav-item"><i class="bi bi-person-walking"></i> Walk-in Clients</a>
        <a href="#" class="nav-item"><i class="bi bi-box"></i> Packages & Memberships</a>
        <a href="#" class="nav-item"><i class="bi bi-megaphone"></i> Promotions</a>
        <a href="#" class="nav-item"><i class="bi bi-tags"></i> Offers & Discounts</a>
        <a href="#" class="nav-item"><i class="bi bi-receipt"></i> Billing & Invoices</a>
        <a href="#" class="nav-item"><i class="bi bi-credit-card"></i> Payments & Payouts</a>
        <a href="#" class="nav-item"><i class="bi bi-award"></i> Loyalty Program</a>
        <a href="#" class="nav-item"><i class="bi bi-box-seam"></i> Inventory</a>
        <a href="#" class="nav-item"><i class="bi bi-star"></i> Reviews & Feedback</a>
        <a href="#" class="nav-item"><i class="bi bi-bar-chart"></i> Reports & Analytics</a>
        <a href="#" class="nav-item"><i class="bi bi-gear"></i> Settings</a>
        <br>
        <a href="#" class="nav-item"><i class="bi bi-question-circle"></i> Help & Support</a>
        <a href="${pageContext.request.contextPath}/salons/logout" class="nav-item sign-out"><i class="bi bi-box-arrow-right"></i> Sign Out</a>
    </div>

    <!-- Main Content Area -->
    <div class="main-wrapper">
        <form action="${pageContext.request.contextPath}/salons/updateProfile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${salon.id}">
            

            <div class="profile-card">
                <c:if test="${not empty message}">
                    <div class="alert alert-success rounded-4 border-0 mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-4 border-0 mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    </div>
                </c:if>
                <div class="profile-header">
                    <div class="profile-img-wrapper">
                        <c:choose>
                            <c:when test="${not empty salon.profileImageUrl}">
                                <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" alt="Profile" class="profile-img">
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${salon.name}&background=7C2D5E&color=fff&size=200" alt="Default" class="profile-img">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-info">
                        <h3><c:out value="${salon.name}"/></h3>
                        <p><i class="bi bi-geo-alt-fill me-2"></i><c:out value="${salon.city}, ${salon.state}"/></p>
                        <div class="mt-3">
                            <span class="badge bg-primary px-3 py-2 rounded-pill"><i class="bi bi-star-fill me-1"></i> ${salon.averageRating} Rating</span>
                            <c:if test="${salon.isCertified}"><span class="badge bg-success px-3 py-2 rounded-pill ms-2"><i class="bi bi-patch-check-fill me-1"></i> Certified</span></c:if>
                        </div>
                    </div>
                    <div class="ms-auto">
                        <button type="button" id="editBtn" class="btn btn-edit-toggle"><i class="bi bi-pencil-square me-2"></i>Edit Profile</button>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/salons/updateProfile" method="post" enctype="multipart/form-data" id="salonProfileForm" novalidate>
                    <input type="hidden" name="id" value="${salon.id}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Salon Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-custom editable" name="name" id="name"
                                   value="<c:out value='${salon.name}'/>" readonly required minlength="3" maxlength="255">
                            <div class="invalid-feedback">Salon name must be 3–255 characters.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Username (Permanent)</label>
                            <input type="text" class="form-control form-control-custom" name="username"
                                   value="<c:out value='${salon.username}'/>" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control form-control-custom editable" name="email" id="email"
                                   value="<c:out value='${salon.email}'/>" readonly required maxlength="255">
                            <div class="invalid-feedback">Please enter a valid email address.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Contact Number <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control form-control-custom editable" name="phone" id="phone"
                                   value="<c:out value='${salon.phone}'/>" readonly required pattern="[0-9]{10}"
                                   minlength="10" maxlength="10" inputmode="numeric">
                            <div class="invalid-feedback">Phone number must be exactly 10 digits.</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Full Address <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-custom editable" name="address" id="address"
                                   value="<c:out value='${salon.address}'/>" readonly required maxlength="500">
                            <div class="invalid-feedback">Full Address is required (max 500 characters).</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">City <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-custom editable" name="city" id="city"
                                   value="<c:out value='${salon.city}'/>" readonly required minlength="2" maxlength="100">
                            <div class="invalid-feedback">City is required (2–100 characters).</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">State <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-custom editable" name="state" id="state"
                                   value="<c:out value='${salon.state}'/>" readonly required minlength="2" maxlength="100">
                            <div class="invalid-feedback">State is required (2–100 characters).</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Pincode</label>
                            <input type="text" class="form-control form-control-custom editable" name="pincode" id="pincode"
                                   value="<c:out value='${salon.pincode}'/>" readonly pattern="[0-9]{6}"
                                   minlength="6" maxlength="6" inputmode="numeric">
                            <div class="invalid-feedback">Pincode must be exactly 6 digits.</div>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Bio / Description</label>
                            <textarea class="form-control form-control-custom editable" name="bio" id="bio" rows="3"
                                      readonly maxlength="2000"><c:out value="${salon.bio}"/></textarea>
                            <div class="form-text">Optional. Maximum 2000 characters.</div>
                            <div class="invalid-feedback">Bio cannot exceed 2000 characters.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Change Profile Photo</label>
                            <input type="file" name="profileImage" id="profileImage"
                                   class="form-control form-control-custom editable"
                                   accept=".jpg,.jpeg,.png,image/jpeg,image/png"
                                   disabled>
                            <div class="form-text mt-2" style="font-size:0.8rem;color:#6b7280;font-weight:500;line-height:1.4;">
                                Accepted formats: ${empty profileImageAccepted ? 'JPG, JPEG, PNG' : profileImageAccepted}
                                | Maximum size: ${empty profileImageMaxSizeMb ? 2 : profileImageMaxSizeMb} MB
                            </div>
                            <div class="invalid-feedback" id="profileImageFeedback">
                                Profile photo must be JPG/JPEG or PNG and at most ${empty profileImageMaxSizeMb ? 2 : profileImageMaxSizeMb} MB.
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Established Year</label>
                            <input type="text" class="form-control form-control-custom editable" name="establishedYear" id="establishedYear"
                                   value="${salon.establishedYear}" readonly
                                   inputmode="numeric" pattern="\d{4}" maxlength="4"
                                   title="Enter a 4-digit year between 1900 and the current year.">
                            <div class="form-text">Exactly 4 digits. Allowed range: 1900–current year.</div>
                            <div class="invalid-feedback" id="establishedYearFeedback">Enter a valid 4-digit year (1900–current year).</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Website</label>
                            <input type="text" class="form-control form-control-custom editable" name="website" id="website"
                                   value="<c:out value='${salon.website}'/>" readonly maxlength="255"
                                   placeholder="https://www.example.com">
                            <div class="form-text">Optional. Enter a valid URL (e.g. https://www.mysalon.com).</div>
                            <div class="invalid-feedback">Please enter a valid website URL.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Availability / Working Hours</label>
                            <input type="text" class="form-control form-control-custom editable" name="availabilityHours" id="availabilityHours"
                                   value="<c:out value='${salon.availabilityHours}'/>" readonly maxlength="255"
                                   placeholder="e.g. Mon-Fri: 10am-8pm, Sat-Sun: 10am-6pm">
                            <div class="form-text">Optional. Describe when the salon is open (max 255 characters).</div>
                            <div class="invalid-feedback">Availability cannot exceed 255 characters.</div>
                        </div>

            <!-- Top Header -->
            <div class="top-header">
                <div class="header-title">
                    <h2>Salon Profile</h2>
                    <p>Manage your salon information and business details</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/salons/preview" target="_blank" class="btn-preview text-decoration-none"><i class="bi bi-eye"></i> Preview Salon Profile</a>
                    
                    <!-- Notifications Dropdown -->
                    <div class="dropdown">
                        <div class="bell-icon" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;"><i class="bi bi-bell"></i><div class="bell-badge" id="notifBadge">0</div></div>
                        <ul class="dropdown-menu dropdown-menu-end" style="width: 280px; padding: 0;" id="notifList">
                            <li class="p-2 border-bottom fw-bold text-center">Notifications</li>
                            <li><a class="dropdown-item text-center text-pink py-2" href="#">View All Notifications</a></li>
                        </ul>

                    </div>

                    <!-- Messages Dropdown -->
                    <div class="dropdown">
                        <div class="bell-icon" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;"><i class="bi bi-chat-dots"></i><div class="bell-badge" id="chatBadge" style="display:none;">0</div></div>
                        <ul class="dropdown-menu dropdown-menu-end" style="width: 280px; padding: 0;" id="chatList">
                            <li class="p-2 border-bottom fw-bold text-center">Messages</li>
                            <li><a class="dropdown-item text-center text-pink py-2" href="#">View All Messages</a></li>
                        </ul>
                    </div>

                    <!-- Profile Dropdown -->
                    <div class="dropdown">
                        <div class="profile-badge ms-2" data-bs-toggle="dropdown" aria-expanded="false" style="cursor:pointer;">
                            <c:choose>
                                <c:when test="${not empty salon.profileImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" alt="Owner">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${salon.name}&background=ec1868&color=fff" alt="Owner">
                                </c:otherwise>
                            </c:choose>
                            <div class="d-flex flex-column lh-1">
                                <span class="fw-bold text-dark" style="font-size:0.8rem">${salon.name}</span>
                                <span class="text-muted" style="font-size:0.65rem">Owner</span>
                            </div>
                        </div>
                        <ul class="dropdown-menu dropdown-menu-end mt-2">
                            <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> My Account</a></li>
                            <li><a class="dropdown-item" href="#"><i class="bi bi-gear"></i> Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/salons/logout"><i class="bi bi-box-arrow-right text-danger"></i> Sign Out</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Hero Section -->
            <div class="hero-section">
                <div class="hero-top-row">
                    <!-- Left Info -->
                    <div class="hero-info-box">
                        <div class="logo-container">
                            <c:choose>
                                <c:when test="${not empty salon.profileImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.profileImageUrl}" class="logo-img" alt="Logo" id="profileImgPreview">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${salon.name}&background=1a1a2e&color=fff" class="logo-img" alt="Logo" id="profileImgPreview">
                                </c:otherwise>
                            </c:choose>
                            <div class="cam-icon" onclick="document.getElementById('profileImageInput').click()"><i class="bi bi-camera"></i></div>
                            <input type="file" name="profileImage" accept="image/*" style="display:none;" id="profileImageInput" onchange="previewImage(this, 'profileImgPreview')">
                        </div>
                        <div class="info-details">
                            <h3>${salon.name} <i class="bi bi-patch-check-fill verified-badge"></i></h3>
                            <div class="subtitle">
                                ${not empty salon.salonCategory ? salon.salonCategory : "Women's Beauty • Wellness • Hair Styling"}
                                <c:if test="${salon.isWomenOnly}"><span class="women-pill">Women Only Salon</span></c:if>
                            </div>
                            <ul class="contact-list">
                                <li><i class="bi bi-telephone"></i> ${not empty salon.phone ? salon.phone : "+91 98765 43210"}</li>
                                <li><i class="bi bi-envelope"></i> ${not empty salon.email ? salon.email : "info@salon.com"}</li>
                                <li><i class="bi bi-globe"></i> ${not empty salon.website ? salon.website : "www.salon.com"}</li>
                                <li><i class="bi bi-geo-alt"></i> <span class="text-muted">${salon.address}, ${salon.city}, ${salon.state} - ${salon.pincode}</span></li>
                            </ul>
                        </div>
                    </div>

                    <!-- Right Photos -->
                    <div class="hero-photos-box">
                        <div class="cover-img-container">
                            <c:choose>
                                <c:when test="${not empty salon.coverImageUrl}">
                                    <img src="${pageContext.request.contextPath}${salon.coverImageUrl}" class="cover-img" alt="Cover" id="coverImgPreview">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1200&q=80" class="cover-img" alt="Cover Default" id="coverImgPreview">
                                </c:otherwise>
                            </c:choose>
                            <div class="cam-icon" style="bottom: 15px; right: 15px;" onclick="document.getElementById('coverImageInput').click()"><i class="bi bi-camera"></i></div>
                            <input type="file" name="coverImage" accept="image/*" style="display:none;" id="coverImageInput" onchange="previewImage(this, 'coverImgPreview')">
                        </div>
                        <div class="thumb-row" id="interiorImagesPreviewContainer">
                            <c:choose>
                                <c:when test="${empty interiorImagesList}">
                                    <div class="text-muted" style="font-size:0.75rem; padding: 20px;" id="noInteriorText">No interior photos uploaded yet.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="imgUrl" items="${interiorImagesList}">
                                        <img src="${pageContext.request.contextPath}${imgUrl}" class="thumb-img">
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            <div class="btn-add-photo" onclick="document.getElementById('interiorImageInput').click()"><i class="bi bi-plus text-pink fs-5"></i> Add More Photos</div>
                            <input type="file" name="interiorImages" accept="image/*" multiple style="display:none;" id="interiorImageInput" onchange="previewMultipleImages(this, 'interiorImagesPreviewContainer')">
                        </div>
                    </div>
                </div>
                
                <div class="hero-bottom-actions">
                    <div class="rating-box">
                        <i class="bi bi-star-fill star"></i> ${not empty salon.averageRating ? salon.averageRating : '0.0'} (0 Reviews) &nbsp;&nbsp;&nbsp;
                        <span class="open-status">${salon.currentStatus}</span> 
                        
                        <div class="dropdown d-inline-block ms-2">
                            <span class="text-muted dropdown-toggle" data-bs-toggle="dropdown" style="cursor:pointer;">
                                <i class="bi bi-clock"></i> Timings
                            </span>
                            <div class="dropdown-menu p-3 shadow-sm" style="min-width: 220px; font-size:0.9rem;">
                                <h6 class="dropdown-header px-0 text-dark border-bottom pb-2 mb-2">Weekly Timings</h6>
                                <div class="d-flex justify-content-between mb-1"><span>Mon:</span> <span class="fw-medium">${not empty salonHoursDisplay['monday'] ? salonHoursDisplay['monday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Tue:</span> <span class="fw-medium">${not empty salonHoursDisplay['tuesday'] ? salonHoursDisplay['tuesday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Wed:</span> <span class="fw-medium">${not empty salonHoursDisplay['wednesday'] ? salonHoursDisplay['wednesday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Thu:</span> <span class="fw-medium">${not empty salonHoursDisplay['thursday'] ? salonHoursDisplay['thursday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Fri:</span> <span class="fw-medium">${not empty salonHoursDisplay['friday'] ? salonHoursDisplay['friday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Sat:</span> <span class="fw-medium">${not empty salonHoursDisplay['saturday'] ? salonHoursDisplay['saturday'] : 'Not set'}</span></div>
                                <div class="d-flex justify-content-between mb-1"><span>Sun:</span> <span class="fw-medium">${not empty salonHoursDisplay['sunday'] ? salonHoursDisplay['sunday'] : 'Not set'}</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="action-btns">
                        <button type="button" class="btn-edit" id="btnEditProfile" onclick="openEditMode()"><i class="bi bi-pencil"></i> Edit Profile</button>
                        <a href="${pageContext.request.contextPath}/salons/preview" target="_blank" class="btn-preview text-decoration-none"><i class="bi bi-eye"></i> Preview Salon Profile</a>
                    </div>
                </div>
            </div>

            <!-- Profile Completion Tracker -->
            <div class="profile-tracker">
                <div class="pt-left">
                    <div class="pt-circle-wrap" style="background: conic-gradient(var(--brand-pink) ${completionPercentage}%, #f0f0f0 0);">
                        <div class="pt-circle-inner">${completionPercentage}%</div>
                    </div>
                    <div class="pt-text">
                        <h4>Profile Completion</h4>
                        <p>Great! Keep going to make your salon profile even stronger.</p>
                    </div>
                </div>
                
                <div class="pt-steps" style="--progress: ${completionPercentage}%;">
                    <div class="pt-step ${stepBasicInfo ? 'done' : ''}" onclick="openEditMode('tab-business')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Basic<br>Information</div>
                        <div class="pt-status">${stepBasicInfo ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepSalonDetails ? 'done' : ''}" onclick="openEditMode('tab-details')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Salon<br>Details</div>
                        <div class="pt-status">${stepSalonDetails ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepServices ? 'done' : ''}" onclick="window.location.href='${pageContext.request.contextPath}/salon/viewServices'" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Services<br>Offered</div>
                        <div class="pt-status">${stepServices ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepPhotos ? 'done' : ''}" onclick="window.scrollTo({top:0, behavior:'smooth'})" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Photos</div>
                        <div class="pt-status">${stepPhotos ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepFacilities ? 'done' : ''}" onclick="openEditMode('tab-facilities')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Facilities &<br>Amenities</div>
                        <div class="pt-status">${stepFacilities ? 'Completed' : 'Pending'}</div>
                    </div>
                    <div class="pt-step ${stepDocs ? 'done' : ''}" onclick="openEditMode('tab-documents')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Documents</div>
                        <div class="pt-status">${docsCount}/${docsTotal} Completed</div>
                    </div>
                    <div class="pt-step ${stepSocial ? 'done' : ''}" onclick="openEditMode('tab-social')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Social<br>Media</div>
                        <div class="pt-status">${socialCount}/${socialTotal} Completed</div>
                    </div>
                    <div class="pt-step ${stepPref ? 'done' : ''}" onclick="openEditMode('tab-preferences')" style="cursor:pointer;">
                        <div class="pt-icon"><i class="bi bi-check2"></i></div>
                        <div class="pt-label">Preferences</div>
                        <div class="pt-status">${stepPref ? 'Completed' : 'Pending'}</div>
                    </div>
                </div>
                
                <a href="javascript:void(0)" onclick="openEditMode()" class="btn-visibility">Increase Visibility <i class="bi bi-arrow-right"></i></a>
            </div>

            <!-- Tabs Navigation -->
            <div class="custom-tabs" id="profileTabs">
                <a href="#" class="custom-tab active" data-target="tab-business">Business Information</a>
                <a href="#" class="custom-tab" data-target="tab-details">Salon Details</a>
                <a href="${pageContext.request.contextPath}/salon/viewServices" class="custom-tab"><i class="bi bi-scissors"></i> Services Offered</a>
                <a href="#" class="custom-tab" data-target="tab-facilities">Facilities & Amenities</a>
                <a href="#" class="custom-tab" data-target="tab-documents">Documents</a>
                <a href="#" class="custom-tab" data-target="tab-social">Social Media</a>
                <a href="#" class="custom-tab" data-target="tab-preferences">Preferences</a>
            </div>

            <!-- Wrapper to hide form until edit is clicked -->
            <div id="editableSections" style="display: none;">
                
                <!-- Tab Content Area -->
                <div class="tab-content-container">
                
                <!-- Tab: Business Info -->
                <div class="tab-pane active" id="tab-business">
                    <div class="form-grid-2col">
                        <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-journal-text"></i>
                        <h4>Basic Information</h4>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label">Salon Name <span class="req">*</span></label>
                            <input type="text" class="f-control" name="name" value="${salon.name}" required>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Business Type <span class="req">*</span></label>
                            <select class="f-control" name="salonCategory">
                                <option value="Beauty, Wellness & Hair Salon" ${salon.salonCategory == 'Beauty, Wellness & Hair Salon' ? 'selected' : ''}>Beauty, Wellness & Hair Salon</option>
                                <option value="Premium Salon" ${salon.salonCategory == 'Premium Salon' ? 'selected' : ''}>Premium Salon</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label">Tagline / Motto</label>
                        <input type="text" class="f-control" name="salonTagline" value="${salon.salonTagline}" placeholder="Enhancing Beauty, Elevating Confidence">
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label">Business Registration No.</label>
                            <input type="text" class="f-control" name="businessRegistrationNo" value="${salon.businessRegistrationNo}" placeholder="KA03AB1234C">
                        </div>
                        <div class="f-group">
                            <label class="f-label">GST Number (Optional)</label>
                            <input type="text" class="f-control" name="gstNumber" value="${salon.gstNumber}" placeholder="29ABCDE1234F1Z5">
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label">Established Year</label>
                            <select class="f-control" name="establishedYear">
                                <option value="2020" ${salon.establishedYear == 2020 ? 'selected' : ''}>2020</option>
                                <option value="2021" ${salon.establishedYear == 2021 ? 'selected' : ''}>2021</option>
                                <option value="2022" ${salon.establishedYear == 2022 ? 'selected' : ''}>2022</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Salon Category</label>
                            <select class="f-control" name="salonCategory">
                                <option value="Premium Salon">Premium Salon</option>
                            </select>
                        </div>
                        <div class="f-group text-end">
                            <label class="f-label">Women Only Salon</label>
                            <div class="toggle-switch justify-content-end pt-1">
                                <label class="switch">
                                    <input type="checkbox" name="isWomenOnly" value="true" ${salon.isWomenOnly ? 'checked' : ''}>
                                    <span class="slider"></span>
                                </label>
                                <span style="font-size:0.75rem; font-weight:500;">Yes</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="f-group mt-2">
                        <label class="f-label">Description <span class="req">*</span></label>
                        <textarea class="f-control" name="bio" rows="4" placeholder="Enter description...">${salon.bio}</textarea>
                        <div class="char-count">156 / 500</div>
                    </div>
                </div>

                </div>
                
                <!-- Col 2: Contact Info -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-person-lines-fill"></i>
                        <h4>Contact Information</h4>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label">Phone Number <span class="req">*</span></label>
                        <input type="text" class="f-control" name="phone" value="${salon.phone}" required>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label">Alternate Number</label>
                        <input type="text" class="f-control" name="alternateNumber" value="${salon.alternateNumber}" placeholder="+91 91234 56789">
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label">Email Address <span class="req">*</span></label>
                        <input type="email" class="f-control" name="email" value="${salon.email}" required>
                    </div>
                    
                    <div class="f-group">
                        <label class="f-label">Full Address <span class="req">*</span></label>
                        <textarea class="f-control" name="address" rows="3" required>${salon.address}</textarea>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label">City <span class="req">*</span></label>
                            <input type="text" class="f-control" name="city" value="${salon.city}" required>
                        </div>
                        <div class="f-group">
                            <label class="f-label">State <span class="req">*</span></label>
                            <select class="f-control" name="state">
                                <option value="Karnataka" ${salon.state == 'Karnataka' ? 'selected' : ''}>Karnataka</option>
                                <option value="Maharashtra" ${salon.state == 'Maharashtra' ? 'selected' : ''}>Maharashtra</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Pincode <span class="req">*</span></label>
                            <input type="text" class="f-control" name="pincode" value="${salon.pincode}" required>
                        </div>
                    </div>
                    
                    <div class="f-group mt-2">
                        <label class="f-label">Landmark</label>
                        <input type="text" class="f-control" name="landmark" value="${salon.landmark}" placeholder="Near Metro Station">
                    </div>
                </div>

                </div>
                </div> <!-- End Tab Business -->

                <!-- Tab: Salon Details -->
                <div class="tab-pane" id="tab-details" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-gem"></i>
                        <h4>Salon Information</h4>
                    </div>
                    
                    <!-- Weekly Operating Hours Grid -->
                    <div class="section-header mt-4 mb-3">
                        <i class="bi bi-clock"></i>
                        <h4>Weekly Operating Hours</h4>
                    </div>
                    <style>
                        .hours-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; background: #fff; padding: 10px; border: 1px solid #e9ecef; border-radius: 8px; }
                        .hours-day { width: 90px; font-weight: 500; font-size: 0.95rem; }
                        .hours-inputs { display: flex; align-items: center; gap: 10px; flex-grow: 1; }
                        .hours-input { padding: 6px; border: 1px solid #d1d5db; border-radius: 4px; width: 110px; font-size: 0.85rem; }
                        .hours-closed { display: flex; align-items: center; gap: 5px; font-size: 0.85rem; }
                    </style>
                    <div class="hours-grid">
                        <c:forEach var="day" items="monday,tuesday,wednesday,thursday,friday,saturday,sunday">
                            <div class="hours-row">
                                <div class="hours-day" style="text-transform: capitalize;">${day}</div>
                                <div class="hours-inputs">
                                    <input type="time" class="hours-input" name="hours_${day}_open" value="${fn:split(salonHours[day], ' - ')[0]}">
                                    <span>to</span>
                                    <input type="time" class="hours-input" name="hours_${day}_close" value="${fn:split(salonHours[day], ' - ')[1]}">
                                </div>
                                <div class="hours-closed">
                                    <input type="checkbox" name="hours_${day}_closed" value="true" ${salonHours[day] == 'Closed' ? 'checked' : ''}> Closed
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label">Total Chairs / Stations</label>
                            <input type="number" class="f-control" name="totalChairs" value="${not empty salon.totalChairs ? salon.totalChairs : 12}">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Total Treatment Rooms</label>
                            <input type="number" class="f-control" name="treatmentRooms" value="${not empty salon.treatmentRooms ? salon.treatmentRooms : 4}">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Reception Area</label>
                            <select class="f-control" name="hasReceptionArea">
                                <option value="true" ${salon.hasReceptionArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasReceptionArea ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="f-row-3">
                        <div class="f-group">
                            <label class="f-label">Waiting Area</label>
                            <select class="f-control" name="hasWaitingArea">
                                <option value="true" ${salon.hasWaitingArea ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWaitingArea ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Parking Facility</label>
                            <select class="f-control" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Washrooms</label>
                            <input type="number" class="f-control" name="washrooms" value="${not empty salon.washrooms ? salon.washrooms : 2}">
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label">Salon Size (sq.ft)</label>
                            <input type="number" class="f-control" name="salonSizeSqFt" value="${not empty salon.salonSizeSqFt ? salon.salonSizeSqFt : 1500}">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Salon License No.</label>
                            <input type="text" class="f-control" name="salonLicenseNo" value="${salon.salonLicenseNo}" placeholder="BBMP/2020/12345">
                        </div>
                    </div>
                    
                    <div class="f-row-2">
                        <div class="f-group">
                            <label class="f-label">Hygiene Standard</label>
                            <select class="f-control" name="hygieneStandard">
                                <option value="Premium" ${salon.hygieneStandard == 'Premium' ? 'selected' : ''}>Premium</option>
                                <option value="Standard" ${salon.hygieneStandard == 'Standard' ? 'selected' : ''}>Standard</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Languages Spoken</label>
                            <input type="text" class="f-control" name="languagesSpoken" value="${salon.languagesSpoken}" placeholder="English, Hindi, Kannada">
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Details -->

                <div class="tab-pane" id="tab-facilities" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-star"></i>
                        <h4>Facilities & Amenities</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label">Air Conditioning (AC)</label>
                            <select class="f-control" name="hasAc">
                                <option value="true" ${salon.hasAc ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasAc ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Free Wi-Fi</label>
                            <select class="f-control" name="hasWifi">
                                <option value="true" ${salon.hasWifi ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasWifi ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label">Customer Parking</label>
                            <select class="f-control" name="hasParking">
                                <option value="true" ${salon.hasParking ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasParking ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Power Backup</label>
                            <select class="f-control" name="hasPowerBackup">
                                <option value="true" ${salon.hasPowerBackup ? 'selected' : ''}>Yes</option>
                                <option value="false" ${!salon.hasPowerBackup ? 'selected' : ''}>No</option>
                            </select>
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Facilities -->
                
                <!-- Tab: Social Media -->
                <div class="tab-pane" id="tab-social" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-share"></i>
                        <h4>Social Media Links</h4>
                    </div>
                    
                    <div class="f-row-2 mt-3">
                        <div class="f-group">
                            <label class="f-label"><i class="bi bi-instagram text-pink"></i> Instagram Username/URL</label>
                            <input type="text" class="f-control" name="socialInstagram" placeholder="@beautysalon">
                        </div>
                        <div class="f-group">
                            <label class="f-label"><i class="bi bi-facebook text-primary"></i> Facebook Page/URL</label>
                            <input type="text" class="f-control" name="socialFacebook" placeholder="facebook.com/beautysalon">
                        </div>
                    </div>
                    
                    <div class="f-row-2 mt-2">
                        <div class="f-group">
                            <label class="f-label"><i class="bi bi-globe"></i> Website Link</label>
                            <input type="url" class="f-control" name="socialWebsite" placeholder="https://www.mysalon.com">
                        </div>
                    </div>
                </div>
                </div> <!-- End Tab Social Media -->
                
                <!-- Tab: Preferences -->
                <div class="tab-pane" id="tab-preferences" style="display:none;">
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-sliders"></i>
                        <h4>Preferences</h4>
                    </div>
                    
                    <style>
                    .pref-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px; }
                    .pref-box { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 12px; padding: 20px; }
                    .pref-box h5 { font-size: 1rem; font-weight: 600; color: #111827; margin-bottom: 15px; border-bottom: 1px solid #e9ecef; padding-bottom: 10px; display: flex; align-items: center; gap: 8px; }
                    .pref-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; font-size: 0.9rem; color: #4b5563; }
                    .pref-row:last-child { margin-bottom: 0; }
                    .pref-input { width: 90px; padding: 4px 8px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 0.85rem; }
                    .pref-select { width: 90px; padding: 4px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 0.85rem; background: white; }
                    </style>

                    <div class="pref-grid">
                        <!-- Box 1 -->
                        <div class="pref-box">
                            <h5>📅 Booking Preferences</h5>
                            <div class="pref-row"><span>Online Booking</span><select class="pref-select" name="pref_onlineBooking"><option value="ON" ${salonPrefs['pref_onlineBooking'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_onlineBooking'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Walk-ins</span><select class="pref-select" name="pref_walkins"><option value="ON" ${salonPrefs['pref_walkins'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_walkins'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Same-Day Booking</span><select class="pref-select" name="pref_sameDayBooking"><option value="ON" ${salonPrefs['pref_sameDayBooking'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_sameDayBooking'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Multiple Services</span><select class="pref-select" name="pref_multipleServices"><option value="ON" ${salonPrefs['pref_multipleServices'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_multipleServices'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                        </div>
                        
                        <!-- Box 2 -->
                        <div class="pref-box">
                            <h5>🚫 Cancellation & Rescheduling</h5>
                            <div class="pref-row"><span>Cancellation Allowed</span><select class="pref-select" name="pref_cancelAllowed"><option value="ON" ${salonPrefs['pref_cancelAllowed'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_cancelAllowed'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Notice Period</span><input type="text" class="pref-input" name="pref_noticePeriod" value="${salonPrefs['pref_noticePeriod']}" placeholder="24 hrs"></div>
                            <div class="pref-row"><span>Rescheduling</span><select class="pref-select" name="pref_rescheduling"><option value="ON" ${salonPrefs['pref_rescheduling'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_rescheduling'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Advance Payment</span><input type="text" class="pref-input" name="pref_advancePayment" value="${salonPrefs['pref_advancePayment']}" placeholder="20%"></div>
                        </div>
                        
                        <!-- Box 3 -->
                        <div class="pref-box">
                            <h5>👩 Customer Preferences</h5>
                            <!-- Legacy isWomenOnly preserved as part of the entity but represented here -->
                            <div class="pref-row"><span>Women Only</span><select class="pref-select" name="isWomenOnly"><option value="true" ${salon.isWomenOnly ? 'selected' : ''}>ON</option><option value="false" ${!salon.isWomenOnly ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>New Customers</span><select class="pref-select" name="pref_newCustomers"><option value="ON" ${salonPrefs['pref_newCustomers'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_newCustomers'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Select Preferred Staff</span><select class="pref-select" name="pref_selectStaff"><option value="ON" ${salonPrefs['pref_selectStaff'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_selectStaff'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Female Staff Request</span><select class="pref-select" name="pref_femaleStaff"><option value="ON" ${salonPrefs['pref_femaleStaff'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_femaleStaff'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                        </div>

                        <!-- Box 4 -->
                        <div class="pref-box">
                            <h5>🔔 Notifications</h5>
                            <div class="pref-row"><span>Booking Alerts</span><select class="pref-select" name="pref_bookingAlerts"><option value="ON" ${salonPrefs['pref_bookingAlerts'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_bookingAlerts'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>WhatsApp</span><select class="pref-select" name="pref_whatsapp"><option value="ON" ${salonPrefs['pref_whatsapp'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_whatsapp'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>SMS</span><select class="pref-select" name="pref_sms"><option value="ON" ${salonPrefs['pref_sms'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_sms'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Email</span><select class="pref-select" name="pref_email"><option value="ON" ${salonPrefs['pref_email'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_email'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                        </div>
                        
                        <!-- Box 5 -->
                        <div class="pref-box">
                            <h5>🕐 Availability</h5>
                            <div class="pref-row"><span>Buffer Time</span><input type="text" class="pref-input" name="pref_bufferTime" value="${salonPrefs['pref_bufferTime']}" placeholder="10 min"></div>
                            <div class="pref-row"><span>Walk-in Queue</span><select class="pref-select" name="pref_walkinQueue"><option value="ON" ${salonPrefs['pref_walkinQueue'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_walkinQueue'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Holiday Mode</span><select class="pref-select" name="pref_holidayMode"><option value="ON" ${salonPrefs['pref_holidayMode'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_holidayMode'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                        </div>

                        <!-- Box 6 -->
                        <div class="pref-box">
                            <h5>🛡 Hygiene & Privacy</h5>
                            <div class="pref-row"><span>Treatment Consultation</span><select class="pref-select" name="pref_consultation"><option value="ON" ${salonPrefs['pref_consultation'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_consultation'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Patch Test Required</span><select class="pref-select" name="pref_patchTest"><option value="ON" ${salonPrefs['pref_patchTest'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_patchTest'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <!-- Legacy isWheelchairAccessible preserved as part of the entity but moved here for privacy or elsewhere, wait we already have it in entity, just mapping to private treatment rooms for now -->
                            <div class="pref-row"><span>Private Treatment Rooms</span><select class="pref-select" name="pref_privateRooms"><option value="ON" ${salonPrefs['pref_privateRooms'] == 'ON' ? 'selected' : ''}>ON</option><option value="OFF" ${salonPrefs['pref_privateRooms'] == 'OFF' ? 'selected' : ''}>OFF</option></select></div>
                            <div class="pref-row"><span>Wheelchair Accessible</span><select class="pref-select" name="isWheelchairAccessible"><option value="true" ${salon.isWheelchairAccessible ? 'selected' : ''}>ON</option><option value="false" ${!salon.isWheelchairAccessible ? 'selected' : ''}>OFF</option></select></div>
                        </div>

                    </div>
                </div>
                </div> <!-- End Tab Facilities -->

                <!-- Tab: Documents -->
                <div class="tab-pane" id="tab-documents" style="display:none;">
                <!-- Documents Section -->
                <div class="doc-section">
                <div class="section-header mb-0">
                    <i class="bi bi-building"></i>
                    <h4>Documents & Certificates</h4>
                </div>
                <p class="doc-header-text">Upload necessary documents and certificates</p>
                
                <div class="doc-grid">
                    <!-- Doc 1 -->
                    <div class="doc-card">
                        <c:if test="${not empty salon.businessRegistrationUrl}"><i class="bi bi-check doc-check"></i></c:if>
                        <div class="doc-icon-wrapper" style="color:#a855f7; background:#f3e8ff;"><i class="bi bi-file-earmark-text"></i></div>
                        <div class="doc-info">
                            <div class="doc-title">Business Registration <br>Certificate</div>
                            <div class="doc-action" onclick="document.getElementById('fileBus').click()">View / Upload</div>
                        </div>
                        <input type="file" name="businessRegistration" style="display:none;" id="fileBus">
                    </div>
                    <!-- Doc 2 -->
                    <div class="doc-card">
                        <c:if test="${not empty salon.salonLicenseUrl}"><i class="bi bi-check doc-check"></i></c:if>
                        <div class="doc-icon-wrapper" style="color:#3b82f6; background:#eff6ff;"><i class="bi bi-file-text"></i></div>
                        <div class="doc-info">
                            <div class="doc-title"><br>Salon License</div>
                            <div class="doc-action" onclick="document.getElementById('fileLic').click()">View / Upload</div>
                        </div>
                        <input type="file" name="salonLicense" style="display:none;" id="fileLic">
                    </div>
                    <!-- Doc 3 -->
                    <div class="doc-card">
                        <c:if test="${not empty salon.gstCertificateUrl}"><i class="bi bi-check doc-check"></i></c:if>
                        <div class="doc-icon-wrapper" style="color:#10b981; background:#ecfdf5;"><i class="bi bi-receipt"></i></div>
                        <div class="doc-info">
                            <div class="doc-title">GST Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(If Applicable)</span></div>
                            <div class="doc-action" onclick="document.getElementById('fileGst').click()">View / Upload</div>
                        </div>
                        <input type="file" name="gstCertificate" style="display:none;" id="fileGst">
                    </div>
                    <!-- Doc 4 -->
                    <div class="doc-card">
                        <c:if test="${not empty salon.hygieneCertificateUrl}"><i class="bi bi-check doc-check"></i></c:if>
                        <div class="doc-icon-wrapper" style="color:#ec4899; background:#fdf2f8;"><i class="bi bi-droplet"></i></div>
                        <div class="doc-info">
                            <div class="doc-title"><br>Hygiene Certificate</div>
                            <div class="doc-action" onclick="document.getElementById('fileHyg').click()">View / Upload</div>
                        </div>
                        <input type="file" name="hygieneCertificate" style="display:none;" id="fileHyg">
                    </div>
                    <!-- Doc 5 -->
                    <div class="doc-card">
                        <c:if test="${not empty salon.fireSafetyUrl}"><i class="bi bi-check doc-check"></i></c:if>
                        <div class="doc-icon-wrapper" style="color:#ef4444; background:#fef2f2;"><i class="bi bi-fire"></i></div>
                        <div class="doc-info">
                            <div class="doc-title"><br>Fire Safety Certificate</div>
                            <div class="doc-action" onclick="document.getElementById('fileFire').click()">View / Upload</div>
                        </div>
                        <input type="file" name="fireSafety" style="display:none;" id="fileFire">
                    </div>
                    <!-- Doc 6 -->
                    <div class="doc-card">
                        <div class="doc-icon-wrapper" style="color:#0ea5e9; background:#f0f9ff;"><i class="bi bi-shield-check"></i></div>
                        <div class="doc-info">
                            <div class="doc-title">Insurance Certificate <br><span class="text-muted fw-normal" style="font-size:0.6rem">(Optional)</span></div>
                            <div class="doc-action">View / Upload</div>
                        </div>
                    </div>
                </div>
            </div>

                </div>
                </div> <!-- End Tab Documents -->
                </div> <!-- End Tab Content Container -->

                <!-- Fixed Bottom Action Bar -->
                <div class="bottom-action-bar">
                    <button type="button" class="btn-cancel" id="btnCancelEdit">Cancel</button>
                    <button type="submit" class="btn-save">Save Changes</button>
                </div>
            </div> <!-- End editableSections wrapper -->
            
        </form>
    </div>

    <!-- Bootstrap JS for dropdowns -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function openEditMode(tabId) {
            document.getElementById('editableSections').style.display = 'block';
            if(tabId) {
                var targetTab = document.querySelector('.custom-tab[data-target="' + tabId + '"]');
                if(targetTab) targetTab.click();
            } else {
                var firstTab = document.querySelector('.custom-tab[data-target]');
                if(firstTab) firstTab.click();
            }
            setTimeout(function() {
                var tabsSection = document.getElementById('profileTabs');
                if(tabsSection) {
                    window.scrollTo({top: tabsSection.offsetTop - 20, behavior: 'smooth'});
                }
            }, 50);
        }

        document.getElementById('btnCancelEdit').addEventListener('click', function() {
            document.getElementById('editableSections').style.display = 'none';
        });

        function previewImage(input, imgId) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(imgId).src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        const interiorImagesDataTransfer = new DataTransfer();

        function previewMultipleImages(input, containerId) {
            var container = document.getElementById(containerId);
            if (input.files && input.files.length > 0) {
                
                // Accumulate newly selected files
                for (let i = 0; i < input.files.length; i++) {
                    if (interiorImagesDataTransfer.items.length < 10) {
                        interiorImagesDataTransfer.items.add(input.files[i]);
                    } else {
                        alert("You can only upload a maximum of 10 photos. Any extras were ignored.");
                        break;
                    }
                }
                
                // Overwrite the input's files with our accumulated list so the form submits all of them
                input.files = interiorImagesDataTransfer.files;

                var noText = document.getElementById('noInteriorText');
                if (noText) noText.style.display = 'none';
                
                // Remove existing image previews
                var existingImages = container.querySelectorAll('.thumb-img');
                existingImages.forEach(img => img.remove());

                // Read and preview each accumulated file
                for (var i = 0; i < input.files.length; i++) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        var img = document.createElement("img");
                        img.src = e.target.result;
                        img.className = "thumb-img";
                        
                        // Insert the image before the "Add More Photos" button
                        var addBtn = container.querySelector('.btn-add-photo');
                        container.insertBefore(img, addBtn);
                    }
                    reader.readAsDataURL(input.files[i]);
                }
            }
        }

        // Tab Switching Logic
        document.addEventListener("DOMContentLoaded", function() {
            const tabs = document.querySelectorAll("#profileTabs .custom-tab[data-target]");
            const panes = document.querySelectorAll(".tab-pane");

            tabs.forEach(tab => {
                tab.addEventListener("click", function(e) {
                    e.preventDefault();
                    
                    // Remove active from all tabs
                    tabs.forEach(t => t.classList.remove("active"));
                    // Add active to clicked tab
                    this.classList.add("active");

                    // Hide all panes
                    panes.forEach(pane => pane.style.display = "none");
                    
                    // Show target pane
                    const targetId = this.getAttribute("data-target");
                    document.getElementById(targetId).style.display = "block";
                });
            });
            
        });
    </script>

    <!-- Real-time WebSocket Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var salonId = ${salon.id};
            var contextPath = '${pageContext.request.contextPath}';
            
            var socket = new SockJS(contextPath + '/ws-chat');
            var stompClient = Stomp.over(socket);
            stompClient.debug = null; // disable debug logs
            
            stompClient.connect({}, function (frame) {
                // Subscribe to notifications
                stompClient.subscribe('/topic/salon/notifications/' + salonId, function (message) {
                    var notif = JSON.parse(message.body);
                    addNotification(notif);
                });
                
                // Subscribe to chat
                stompClient.subscribe('/topic/salon/chat/' + salonId, function (message) {
                    var chat = JSON.parse(message.body);
                    addChatMessage(chat);
                });
            });
            
            function addNotification(notif) {
                var badge = document.getElementById('notifBadge');
                badge.innerText = parseInt(badge.innerText || 0) + 1;
                badge.style.display = 'flex';
                
                var list = document.getElementById('notifList');
                var li = document.createElement('li');
                li.innerHTML = '<div class="notif-item"><div class="n-title">' + notif.title + '</div><div class="n-desc">' + notif.message + '</div></div>';
                list.insertBefore(li, list.children[1]);
            }
            
            function addChatMessage(chat) {
                var badge = document.getElementById('chatBadge');
                badge.innerText = parseInt(badge.innerText || 0) + 1;
                badge.style.display = 'flex';
                
                var list = document.getElementById('chatList');
                var li = document.createElement('li');
                var senderName = chat.senderRole === 'USER' ? (chat.user ? chat.user.name : 'User') : chat.senderRole;
                li.innerHTML = '<div class="notif-item"><div class="n-title">' + senderName + '</div><div class="n-desc">' + chat.message + '</div></div>';
                list.insertBefore(li, list.children[1]);
            }
            
            // Load initial via AJAX
            fetch(contextPath + '/api/salon/notifications')
                .then(r => r.json())
                .then(data => {
                    var badge = document.getElementById('notifBadge');
                    var unread = data.filter(n => !n.read).length;
                    if(unread > 0) {
                        badge.innerText = unread;
                        badge.style.display = 'flex';
                    } else {
                        badge.style.display = 'none';
                    }
                    
                    var list = document.getElementById('notifList');
                    data.slice(0, 5).forEach(n => {
                        var li = document.createElement('li');
                        li.innerHTML = '<div class="notif-item"><div class="n-title">' + n.title + '</div><div class="n-desc">' + n.message + '</div></div>';
                        list.insertBefore(li, list.children[1]);
                    });
                });
                
            fetch(contextPath + '/api/salon/chat')
                .then(r => r.json())
                .then(data => {
                    var badge = document.getElementById('chatBadge');
                    var unread = data.filter(c => !c.read).length;
                    if (unread > 0) {
                        badge.innerText = unread;
                        badge.style.display = 'flex';
                    } else {
                        badge.style.display = 'none';
                    }
                    
                    var list = document.getElementById('chatList');
                    data.slice(0, 5).reverse().forEach(chat => {
                        var li = document.createElement('li');
                        var senderName = chat.senderRole === 'USER' ? (chat.user ? chat.user.name : 'User') : chat.senderRole;
                        li.innerHTML = '<div class="notif-item"><div class="n-title">' + senderName + '</div><div class="n-desc">' + chat.message + '</div></div>';
                        list.insertBefore(li, list.children[1]);
                    });
                });
                
            // Click to mark notifs read
            document.querySelector('#notifBadge').parentElement.addEventListener('click', function() {
                var badge = document.getElementById('notifBadge');
                if (badge.innerText !== '0' && badge.style.display !== 'none') {
                    fetch(contextPath + '/api/salon/notifications/mark-read', {method: 'POST'})
                        .then(() => {
                            badge.innerText = '0';
                            badge.style.display = 'none';
                        });
                }
            });
        });

        const phoneInput = document.getElementById("phone");
        if (phoneInput) {
            phoneInput.addEventListener("input", function() {
                this.value = this.value.replace(/\D/g, "").slice(0, 10);
            });
        }
        const pincodeInput = document.getElementById("pincode");
        if (pincodeInput) {
            pincodeInput.addEventListener("input", function() {
                this.value = this.value.replace(/\D/g, "").slice(0, 6);
            });
        }
        const yearInput = document.getElementById("establishedYear");
        if (yearInput) {
            yearInput.addEventListener("input", function() {
                this.value = this.value.replace(/\D/g, "").slice(0, 4);
            });
        }

        document.getElementById("salonProfileForm").addEventListener("submit", function(e) {
            const name = (document.getElementById("name").value || "").trim();
            const email = (document.getElementById("email").value || "").trim();
            const phone = (document.getElementById("phone").value || "").trim();
            const address = (document.getElementById("address").value || "").trim();
            const city = (document.getElementById("city").value || "").trim();
            const state = (document.getElementById("state").value || "").trim();
            const pincode = (document.getElementById("pincode").value || "").trim();
            const bio = (document.getElementById("bio").value || "").trim();
            const yearEl = document.getElementById("establishedYear");
            const yearRaw = (yearEl.value || "").trim();
            const currentYear = new Date().getFullYear();
            const maxPhotoBytes = ${empty profileImageMaxBytes ? 2097152 : profileImageMaxBytes};
            let valid = true;

            function mark(id, ok) {
                const el = document.getElementById(id);
                if (!el) return;
                el.classList.toggle("is-invalid", !ok);
                el.classList.toggle("is-valid", ok);
                if (!ok) valid = false;
            }

            mark("name", name.length >= 3 && name.length <= 255);
            mark("email", /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && email.length <= 255);
            mark("phone", /^\d{10}$/.test(phone));
            mark("address", address.length > 0 && address.length <= 500);
            mark("city", city.length >= 2 && city.length <= 100);
            mark("state", state.length >= 2 && state.length <= 100);
            mark("pincode", pincode === "" || /^\d{6}$/.test(pincode));
            mark("bio", bio.length <= 2000);

            let yearOk = true;
            if (yearRaw !== "") {
                if (!/^\d{4}$/.test(yearRaw)) {
                    yearOk = false;
                } else {
                    const year = parseInt(yearRaw, 10);
                    yearOk = !isNaN(year) && year >= 1900 && year <= currentYear;
                }
            }
            mark("establishedYear", yearOk);
            if (!yearOk) {
                const fb = document.getElementById("establishedYearFeedback");
                if (fb) {
                    if (yearRaw !== "" && !/^\d{4}$/.test(yearRaw)) {
                        fb.textContent = "Established Year must be exactly 4 digits.";
                    } else {
                        fb.textContent = "Established Year must be between 1900 and " + currentYear + ".";
                    }
                }
            }

            const website = (document.getElementById("website") ? document.getElementById("website").value : "").trim();
            const hours = (document.getElementById("availabilityHours") ? document.getElementById("availabilityHours").value : "").trim();
            const websiteOk = website === "" || /^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/\S*)?$/i.test(website);
            mark("website", websiteOk && website.length <= 255);
            mark("availabilityHours", hours.length <= 255);
            const photoEl = document.getElementById("profileImage");
            if (photoEl && photoEl.files && photoEl.files[0]) {
                const file = photoEl.files[0];
                const type = (file.type || "").toLowerCase();
                const fileName = (file.name || "").toLowerCase();
                const typeOk = type === "image/jpeg" || type === "image/jpg" || type === "image/png"
                    || fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".png");
                const sizeOk = file.size <= maxPhotoBytes;
                const photoOk = typeOk && sizeOk;
                photoEl.classList.toggle("is-invalid", !photoOk);
                photoEl.classList.toggle("is-valid", photoOk);
                if (!photoOk) {
                    valid = false;
                    const fb = document.getElementById("profileImageFeedback");
                    if (fb) {
                        if (!typeOk) fb.textContent = "Profile photo must be JPG/JPEG or PNG only (PDF and other formats are not allowed).";
                        else fb.textContent = "Profile photo must be at most " + Math.round(maxPhotoBytes / (1024 * 1024)) + " MB.";
                    }
                }
            }

            if (!valid) {
                e.preventDefault();
            }
        });

        const profileImageInput = document.getElementById("profileImage");
        if (profileImageInput) {
            profileImageInput.addEventListener("change", function() {
                if (!this.files || !this.files[0]) {
                    this.classList.remove("is-invalid", "is-valid");
                    return;
                }
                const file = this.files[0];
                const type = (file.type || "").toLowerCase();
                const fileName = (file.name || "").toLowerCase();
                const maxPhotoBytes = ${empty profileImageMaxBytes ? 2097152 : profileImageMaxBytes};
                const typeOk = type === "image/jpeg" || type === "image/jpg" || type === "image/png"
                    || fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".png");
                const sizeOk = file.size <= maxPhotoBytes;
                const ok = typeOk && sizeOk;
                this.classList.toggle("is-invalid", !ok);
                this.classList.toggle("is-valid", ok);
                const fb = document.getElementById("profileImageFeedback");
                if (fb && !ok) {
                    if (!typeOk) fb.textContent = "Profile photo must be JPG/JPEG or PNG only (PDF and other formats are not allowed).";
                    else fb.textContent = "Profile photo must be at most " + Math.round(maxPhotoBytes / (1024 * 1024)) + " MB.";
                }
            });
        }
    </script>
</body>
</html>
