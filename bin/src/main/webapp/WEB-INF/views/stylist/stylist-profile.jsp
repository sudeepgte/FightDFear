<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stylist Profile | Fight D Fear</title>

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

        .profile-card {
            background: white;
            border-radius: 24px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .profile-cover {
            height: 200px;
            background: linear-gradient(135deg, rgba(124, 45, 94, 0.8), rgba(64, 30, 89, 0.9)), url('https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&q=80') center/cover;
            position: relative;
        }

        .profile-header-standard {
            display: flex;
            align-items: flex-end;
            gap: 30px;
            padding: 0 40px 30px;
            margin-top: -60px;
            border-bottom: 1px solid #f1f3f5;
            position: relative;
        }

        .profile-img-standard {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 6px solid white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
            background: white;
            position: relative;
            z-index: 2;
        }

        .profile-info {
            padding-bottom: 10px;
            flex-grow: 1;
        }
        
        .profile-body {
            padding: 40px;
        }

        .form-label {
            font-weight: 700;
            color: var(--brand-purple-darker);
            font-size: 0.85rem;
            margin-bottom: 8px;
        }

        .input-group-custom {
            border-radius: 12px;
            border: 2px solid rgba(30, 27, 75, 0.1);
            background: #f8f9fa;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .input-group-custom:focus-within {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
            background: #fff;
        }

        .input-group-custom .input-group-text {
            border: none;
            background: transparent;
            color: var(--brand-purple);
        }

        .form-control-custom {
            padding: 12px 15px;
            border: none;
            background: transparent;
            font-weight: 500;
            box-shadow: none !important;
        }

        .form-control-custom[readonly] {
            cursor: not-allowed;
            opacity: 0.7;
        }

        .btn-update {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
            filter: brightness(1.1);
            color: white;
        }
        
        .btn-outline-purple {
            color: var(--brand-purple);
            border: 2px solid var(--brand-purple);
            background: white;
            transition: all 0.3s ease;
        }
        
        .btn-outline-purple:hover {
            background: var(--brand-purple);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(124, 45, 94, 0.2);
        }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar { padding: 20px; }
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
            .profile-header-standard { flex-direction: column; text-align: center; padding: 0 20px 20px; margin-top: -70px; gap: 15px; }
            .profile-body { padding: 20px; }
            .profile-header-standard .ms-auto { margin-left: 0 !important; margin-top: 10px; width: 100%; }
            .profile-header-standard .ms-auto .btn { width: 100%; }
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

        <a href="${pageContext.request.contextPath}/stylists/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i>
            <span>Fight D Fear</span>
        </a>

        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/stylists/profile">
                <i class="bi bi-person-circle"></i>
                <span>Stylist Profile</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/dashboard#bookings">
                <i class="bi bi-calendar-check"></i>
                <span>My Bookings</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/stylists/reviews">
                <i class="bi bi-star-half"></i>
                <span>Client Reviews</span>
            </a>
            <div class="mt-5">
                <a class="nav-link-custom text-danger" href="${pageContext.request.contextPath}/stylists/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </div>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="profile-card">
                <div class="profile-cover"></div>
                <div class="profile-header-standard">
                    <img id="profileImagePreview"
                         src="<c:out value='${pageContext.request.contextPath}${stylist.profileImage != null ? stylist.profileImage : "/beauty/images/default-stylist.jpg"}'/>"
                         alt="Profile" class="profile-img-standard">
                    <div class="profile-info">
                        <h2 class="fw-800 m-0">${stylist.firstName} ${stylist.lastName}</h2>
                        <p class="text-muted m-0 mt-1">${stylist.specialization} • ${stylist.experienceInYears} Years Experience</p>
                        <div class="mt-3">
                            <span class="badge bg-soft-warning text-dark px-3 py-2 rounded-pill"><i class="bi bi-star-fill text-warning me-1"></i> ${stylist.rating} Rating</span>
                            <span class="badge ${stylist.available ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'} px-3 py-2 rounded-pill ms-2">
                                <i class="bi ${stylist.available ? 'bi-check-circle' : 'bi-dash-circle'} me-1"></i>
                                ${stylist.available ? 'Available' : 'Unavailable'}
                            </span>
                        </div>
                    </div>
                    <div class="ms-auto mb-2">
                        <button type="button" id="editBtn" class="btn btn-outline-purple rounded-pill px-4 py-2 fw-700"><i class="bi bi-pencil-square me-2"></i>Edit Profile</button>
                    </div>
                </div>

                <div class="profile-body">
                    <form action="${pageContext.request.contextPath}/stylists/profile/update" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${stylist.id}">

                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="form-label">First Name</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="firstName" value="${stylist.firstName}" class="form-control form-control-custom editable" readonly required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Last Name</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="lastName" value="${stylist.lastName}" class="form-control form-control-custom editable" readonly required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email Address</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" name="email" value="${stylist.email}" class="form-control form-control-custom editable" readonly required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone Number</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <input type="text" name="contactNumber" value="${stylist.contactNumber}" class="form-control form-control-custom editable" readonly required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Specialization</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-scissors"></i></span>
                                    <input type="text" name="specialization" value="${stylist.specialization}" class="form-control form-control-custom editable" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Years of Experience</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-award"></i></span>
                                    <input type="number" name="experienceInYears" value="${stylist.experienceInYears}" class="form-control form-control-custom editable" readonly>
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Short Bio</label>
                                <div class="input-group input-group-custom p-0" style="align-items: flex-start;">
                                    <span class="input-group-text pt-3 border-0"><i class="bi bi-chat-left-text"></i></span>
                                    <textarea name="bio" class="form-control form-control-custom editable pt-3" rows="3" readonly>${stylist.bio}</textarea>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Update Profile Photo</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-image"></i></span>
                                    <input type="file" name="profileImageFile" id="profileImageInput" class="form-control form-control-custom editable" disabled>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Availability Hours</label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text"><i class="bi bi-clock"></i></span>
                                    <input type="text" name="availabilityHours" value="${stylist.availabilityHours}" class="form-control form-control-custom editable" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-center gap-3 mt-5">
                            <button type="submit" id="saveBtn" class="btn btn-update px-5" disabled><i class="bi bi-check-circle me-2"></i>Save Profile Changes</button>
                        </div>
                    </form>

                    <div class="mt-5 pt-4 border-top">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                            <div>
                                <h5 class="text-danger fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>Danger Zone</h5>
                                <p class="text-muted small m-0">Deleting your profile is permanent and will remove all your booking history.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/stylists/delete/${stylist.id}" 
                               onclick="return confirm('Are you sure you want to delete your profile? This cannot be undone.');" 
                               class="btn btn-outline-danger rounded-pill px-4 fw-700">Delete Profile</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script>
        document.getElementById("editBtn").addEventListener("click", function() {
            const editableFields = document.querySelectorAll(".editable");
            editableFields.forEach(field => {
                field.removeAttribute("readonly");
                field.removeAttribute("disabled");
            });
            document.getElementById("saveBtn").disabled = false;
            this.classList.add("d-none");
        });

        // Image Preview
        document.getElementById('profileImageInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileImagePreview').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

