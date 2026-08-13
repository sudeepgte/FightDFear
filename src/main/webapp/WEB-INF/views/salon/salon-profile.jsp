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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



