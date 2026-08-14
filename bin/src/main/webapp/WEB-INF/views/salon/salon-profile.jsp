<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Profile | Fight D Fear</title>

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

        .profile-card {
            background: white;
            border-radius: 24px;
            padding: 40px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 40px;
            border-bottom: 1px solid #f1f3f5;
            padding-bottom: 30px;
        }

        .profile-img-wrapper {
            position: relative;
            width: 150px;
            height: 150px;
        }

        .profile-img {
            width: 100%;
            height: 100%;
            border-radius: 20px;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .profile-info h3 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin-bottom: 5px;
        }

        .profile-info p {
            color: var(--fdf-muted);
            margin: 0;
            font-weight: 500;
        }

        .form-label {
            font-weight: 700;
            color: var(--brand-purple-darker);
            font-size: 0.85rem;
            margin-bottom: 8px;
        }

        .form-control-custom {
            padding: 12px 15px;
            border-radius: 12px;
            border: 2px solid rgba(30, 27, 75, 0.1);
            background: #f8f9fa;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control-custom:focus:not([readonly]) {
            outline: none;
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
            background: #fff;
        }

        .form-control-custom[readonly] {
            background: #f1f3f5;
            cursor: not-allowed;
            border-color: transparent;
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

        .btn-edit-toggle {
            background: #f8f5ff;
            color: var(--brand-purple);
            border: 2px solid var(--brand-purple);
            padding: 10px 25px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-edit-toggle:hover {
            background: var(--brand-purple);
            color: white;
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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salons/profile">
                <i class="bi bi-person-circle"></i>
                <span>Salon Profile</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                <i class="bi bi-calendar-check"></i>
                <span>Manage Bookings</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/treatments/view">
                <i class="bi bi-droplet-half"></i>
                <span>Specialized Treatments</span>
            </a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
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
            
            <div class="profile-card">
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

                <form action="${pageContext.request.contextPath}/salons/updateProfile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${salon.id}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Salon Name</label>
                            <input type="text" class="form-control form-control-custom editable" name="name" value="${salon.name}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Username (Permanent)</label>
                            <input type="text" class="form-control form-control-custom" name="username" value="${salon.username}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="form-control form-control-custom editable" name="email" value="${salon.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Contact Number</label>
                            <input type="text" class="form-control form-control-custom editable" name="phone" value="${salon.phone}" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Full Address</label>
                            <input type="text" class="form-control form-control-custom editable" name="address" value="${salon.address}" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control form-control-custom editable" name="city" value="${salon.city}" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">State</label>
                            <input type="text" class="form-control form-control-custom editable" name="state" value="${salon.state}" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Pincode</label>
                            <input type="text" class="form-control form-control-custom editable" name="pincode" value="${salon.pincode}" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Bio / Description</label>
                            <textarea class="form-control form-control-custom editable" name="bio" rows="3" readonly>${salon.bio}</textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Change Profile Photo</label>
                            <input type="file" name="profileImage" class="form-control form-control-custom editable" disabled>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Established Year</label>
                            <input type="number" class="form-control form-control-custom editable" name="establishedYear" value="${salon.establishedYear}" readonly>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-5">
                        <button type="submit" id="updateBtn" class="btn btn-update px-5" disabled>Save Changes</button>
                    </div>
                </form>

                <div class="mt-5 pt-4 border-top">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <h5 class="text-danger fw-bold">Danger Zone</h5>
                            <p class="text-muted small m-0">Deleting your account will remove all your data permanently.</p>
                        </div>
                        <button type="button" class="btn btn-outline-danger px-4" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">Delete Account</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header bg-danger text-white border-0 py-3" style="border-radius: 20px 20px 0 0;">
                    <h5 class="modal-title fw-bold">Delete Account?</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <i class="bi bi-exclamation-octagon text-danger" style="font-size: 3rem;"></i>
                    <h4 class="fw-bold mt-3">Are you absolutely sure?</h4>
                    <p class="text-muted">This action is irreversible. All your services, bookings, and profile data will be permanently deleted from our servers.</p>
                </div>
                <div class="modal-footer border-0 pb-4 px-4 justify-content-center">
                    <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Cancel</button>
                    <form action="${pageContext.request.contextPath}/salons/deleteProfile" method="post">
                        <input type="hidden" name="id" value="${salon.id}">
                        <button type="submit" class="btn btn-danger px-4">Yes, Delete Account</button>
                    </form>
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
            document.getElementById("updateBtn").disabled = false;
            this.classList.add("d-none");
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



