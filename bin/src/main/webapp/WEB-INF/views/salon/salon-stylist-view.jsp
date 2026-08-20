<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Stylist | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f5ff;
            --brand-purple: #6a0dad;
            --brand-purple-darker: #4a0080;
            --gradient-dark: linear-gradient(135deg, #2b1055 0%, #7597de 100%);
            --fdf-border: #eee;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--brand-purple-darker);
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar */
        .sidebar {
            background: var(--gradient-dark);
            color: white;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            text-decoration: none;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .nav-link-custom i {
            font-size: 1.2rem;
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 10px 0 30px rgba(0,0,0,0.1);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .glass-card {
            background: white;
            border-radius: 24px;
            padding: 40px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }

        .page-header {
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-header h2 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin: 0;
        }

        .btn-back {
            background: white;
            color: var(--brand-purple-darker);
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 600;
            border: 1px solid var(--fdf-border);
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back:hover {
            background: var(--brand-purple-darker);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid var(--fdf-border);
        }

        .profile-image-large {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #f8f5ff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .profile-name {
            font-size: 2rem;
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin-bottom: 5px;
        }

        .profile-role {
            font-size: 1.1rem;
            color: #6c757d;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .profile-badge {
            background: rgba(106, 13, 173, 0.1);
            color: var(--brand-purple);
            padding: 6px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 16px;
            border: 1px solid var(--fdf-border);
        }
        
        .info-label {
            font-size: 0.85rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brand-purple-darker);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .bio-section {
            margin-top: 40px;
            background: #f8f9fa;
            padding: 30px;
            border-radius: 16px;
            border: 1px solid var(--fdf-border);
        }
        
        .bio-section h4 {
            font-weight: 700;
            margin-bottom: 15px;
            color: var(--brand-purple-darker);
        }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar { padding: 20px; }
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
            .profile-header { flex-direction: column; text-align: center; }
        }

        .mobile-header {
            background: var(--gradient-dark);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold d-flex align-items-center gap-2"><i class="bi bi-stars"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 2rem;"></i>
        </button>
    </div>

    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="offcanvas-header d-lg-none border-bottom border-secondary mb-3 pb-3">
            <h5 class="offcanvas-title text-white fw-bold"><i class="bi bi-stars"></i> Fight D Fear</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebarMenu"></button>
        </div>

        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i>
            <span>Fight D Fear</span>
        </a>

        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                <i class="bi bi-person-circle"></i>
                <span>Salon Profile</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                <i class="bi bi-calendar-check"></i>
                <span>Manage Bookings</span>
            </a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/stylists">
                <i class="bi bi-people"></i>
                <span>Staff / Stylists</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/treatments/view">
                <i class="bi bi-droplet-half"></i>
                <span>Specialized Treatments</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}">
                <i class="bi bi-percent"></i>
                <span>Offers & Promotions</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                <i class="bi bi-star-half"></i>
                <span>Customer Reviews</span>
            </a>
            <div class="mt-5">
                <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/salons/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </div>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <h2>Stylist Profile</h2>
                <a href="${pageContext.request.contextPath}/salon/stylists" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Back to Stylists
                </a>
            </div>

            <div class="glass-card">
                <div class="profile-header">
                    <img src="${not empty stylist.profileImage ? pageContext.request.contextPath.concat(stylist.profileImage) : 'https://ui-avatars.com/api/?name='.concat(stylist.firstName).concat('+').concat(stylist.lastName).concat('&background=6a0dad&color=fff&size=150')}" alt="${stylist.firstName}" class="profile-image-large" onerror="this.src='https://ui-avatars.com/api/?name=${stylist.firstName}+${stylist.lastName}&background=6a0dad&color=fff&size=150';">
                    
                    <div>
                        <h2 class="profile-name">${stylist.firstName} ${stylist.lastName}</h2>
                        <div class="profile-role">${not empty stylist.specialization ? stylist.specialization : 'Professional Stylist'}</div>
                        
                        <div class="d-flex gap-2 flex-wrap">
                            <span class="profile-badge">
                                <i class="bi bi-star-fill text-warning"></i> ${not empty stylist.rating ? stylist.rating : '0.0'} Rating
                            </span>
                            <span class="profile-badge" style="background: ${stylist.available ? 'rgba(32, 201, 151, 0.1)' : 'rgba(108, 117, 125, 0.1)'}; color: ${stylist.available ? '#20c997' : '#6c757d'};">
                                <i class="bi ${stylist.available ? 'bi-check-circle-fill' : 'bi-dash-circle-fill'}"></i> 
                                ${stylist.available ? 'Currently Available' : 'Currently Unavailable'}
                            </span>
                            <c:if test="${stylist.isIndependent}">
                                <span class="profile-badge" style="background: rgba(13, 110, 253, 0.1); color: #0d6efd;">
                                    <i class="bi bi-person-badge-fill"></i> Independent Stylist
                                </span>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <h4 class="fw-bold mb-4">Professional Details</h4>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><i class="bi bi-envelope-at text-muted"></i> ${not empty stylist.email ? stylist.email : 'Not Provided'}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Contact Number</div>
                        <div class="info-value"><i class="bi bi-telephone text-muted"></i> ${not empty stylist.contactNumber ? stylist.contactNumber : 'Not Provided'}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Experience</div>
                        <div class="info-value"><i class="bi bi-briefcase text-muted"></i> ${stylist.experienceInYears} Years</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Availability Hours</div>
                        <div class="info-value"><i class="bi bi-clock text-muted"></i> ${not empty stylist.availabilityHours ? stylist.availabilityHours : 'Standard Hours'}</div>
                    </div>
                </div>
                
                <c:if test="${not empty stylist.bio}">
                    <div class="bio-section">
                        <h4>About ${stylist.firstName}</h4>
                        <p class="text-muted m-0" style="line-height: 1.8;">${stylist.bio}</p>
                    </div>
                </c:if>
                
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



