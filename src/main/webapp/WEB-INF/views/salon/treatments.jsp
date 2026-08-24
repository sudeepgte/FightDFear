<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${treatment.id == null ? 'Add specialized Treatment' : 'Edit Treatment'} | Fight D Fear</title>

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
            margin-left: var(--sidebar-width);
            padding: 40px;
            min-height: 100vh;
        }

        .form-card {
            background: white;
            border-radius: 24px;
            padding: 40px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            max-width: 850px;
            margin: 0 auto;
        }

        .form-label {
            font-weight: 700;
            color: var(--brand-purple-darker);
            font-size: 0.85rem;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control-custom {
            padding: 12px 15px;
            border-radius: 12px;
            border: 2px solid rgba(30, 27, 75, 0.1);
            background: #f8f9fa;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.1);
            background: #fff;
        }

        .btn-submit {
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 14px 40px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
            filter: brightness(1.1);
            color: white;
        }

        .btn-cancel {
            background: #f8f5ff;
            color: var(--brand-purple);
            border: 2px solid var(--brand-purple);
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-cancel:hover {
            background: var(--brand-purple);
            color: white;
        }

        .section-header {
            border-bottom: 2px solid #f1f3f5;
            padding-bottom: 15px;
            margin-bottom: 25px;
            color: var(--brand-purple);
            font-weight: 800;
        }

        /* Responsive */
        @media (max-width: 992px) {
            
            .sidebar-brand span, .nav-link-custom span { display: none; }
            .main-content { margin-left: 80px; }
        }
    
        /* Unified Premium Sidebar */
        .sidebar {
            background: linear-gradient(180deg, var(--fdf-burgundy) 0%, var(--fdf-burgundy-dark) 100%);
            color: white;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }

        .sidebar-brand-wrapper {
            padding: 24px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            margin-bottom: 20px;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 1.15rem;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .sidebar-brand i {
            color: var(--fdf-pink);
            font-size: 1.5rem;
        }

        .sidebar-brand-wrapper .subtitle {
            font-size: 0.72rem;
            color: rgba(255,255,255,0.4);
            margin-top: 4px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .nav-container {
            flex: 1;
            padding: 0 16px;
            overflow-y: auto;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 11px 16px;
            color: rgba(255,255,255,0.65);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 4px;
            transition: all 0.2s ease;
            font-weight: 500;
            font-size: 0.88rem;
        }

        .nav-link-custom:hover {
            background: rgba(255,255,255,0.05);
            color: white;
            transform: translateX(4px);
        }

        .nav-link-custom.active {
            background: linear-gradient(90deg, var(--fdf-pink) 0%, var(--fdf-rose) 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(219, 39, 119, 0.25);
            font-weight: 600;
        }

        .nav-link-custom i {
            font-size: 1.15rem;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <!-- Sidebar -->
    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <div class="sidebar-brand-wrapper">
            <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
                <i class="bi bi-gender-female"></i>
                <span>${empty salon.name ? 'Priya Beauty & Wellness' : salon.name}</span>
            </a>
            <div class="subtitle">Women's Salon • Beauty • Wellness • Hair Styling</div>
        </div>

        <div class="nav-container">
            <nav class="nav flex-column">
                <a class="nav-link-custom" active" href="${pageContext.request.contextPath}/salons/dashboard">
                    <i class="bi bi-grid-1x2"></i>
                    <span>Dashboard</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Salon Profile</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list">
                    <i class="bi bi-calendar-check"></i>
                    <span>Appointments</span>
                </a>
                <a class="nav-link-custom" href="#calendar" data-bs-toggle="modal" data-bs-target="#calendarModal">
                    <i class="bi bi-calendar3"></i>
                    <span>Calendar</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                    <i class="bi bi-magic"></i>
                    <span>Services</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists">
                    <i class="bi bi-people"></i>
                    <span>Staff / Stylists</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients">
                    <i class="bi bi-people-fill"></i>
                    <span>Clients</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages">
                    <i class="bi bi-box-seam"></i>
                    <span>Packages & Memberships</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salon.id}">
                    <i class="bi bi-percent"></i>
                    <span>Offers & Discounts</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/billing">
                    <i class="bi bi-receipt"></i>
                    <span>Billing & Invoices</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/payments">
                    <i class="bi bi-credit-card-2-front"></i>
                    <span>Payments & Payouts</span>
                </a>
                
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/inventory">
                    <i class="bi bi-box"></i>
                    <span>Inventory</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/reviews/list">
                    <i class="bi bi-star-half"></i>
                    <span>Reviews & Feedback</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/analytics">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports & Analytics</span>
                </a>

                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/settings">
                    <i class="bi bi-sliders"></i>
                    <span>Settings</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/support">
                    <i class="bi bi-question-circle"></i>
                    <span>Help & Support</span>
                </a>
                <a class="nav-link-custom text-danger mt-3" href="${pageContext.request.contextPath}/salons/logout">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Sign Out</span>
                </a>
            </nav>
        </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="mb-5 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/treatments/view" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Treatments
                </a>
                <h2 class="fw-800 m-0 text-purple">${treatment.id == null ? 'Define Specialized Treatment' : 'Refine Treatment details'}</h2>
            </div>

            <div class="form-card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-4 mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${error}"/>
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success rounded-4 mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><c:out value="${message}"/>
                    </div>
                </c:if>
                <form id="treatmentForm" action="${pageContext.request.contextPath}/salon/treatments/save" method="post">
                    <input type="hidden" name="id" value="${treatment.id}">

                    <div class="section-header">
                        <i class="bi bi-info-circle-fill me-2"></i> Core Information
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <label class="form-label">Category <span class="text-danger">*</span></label>
                            <select name="category" id="category" class="form-select form-control-custom" required onchange="toggleTreatmentSkin()">
                                <option value="">Select Category</option>
                                <option value="Skin" ${treatment.category == 'Skin' ? 'selected' : ''}>Skin Care</option>
                                <option value="Hair" ${treatment.category == 'Hair' ? 'selected' : ''}>Hair Care</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Service Name <span class="text-danger">*</span></label>
                            <input type="text" name="serviceName" id="serviceName" class="form-control form-control-custom"
                                   value="<c:out value='${treatment.serviceName}'/>"
                                   maxlength="150" minlength="2"
                                   placeholder="e.g. Deep Hydration Facial" required>
                        </div>

                        <!-- Treatment Type (Conditional) -->
                        <div class="col-md-6" id="treatmentTypeDiv" style="${treatment.category == 'Skin' ? 'display:block;' : 'display:none;'}">
                            <label class="form-label">Specific Treatment Type <span class="text-danger skin-required-mark">*</span></label>
                            <select name="treatmentType" id="treatmentType" class="form-select form-control-custom">
                                <option value="">--Select Type--</option>
                                <c:forEach var="type" items="${treatmentTypes}">
                                    <option value="${type}" ${treatment.treatmentType == type ? 'selected' : ''}>${type}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Skin Type (Conditional) -->
                        <div class="col-md-6" id="skinTypeDiv" style="${treatment.category == 'Skin' ? 'display:block;' : 'display:none;'}">
                            <label class="form-label">Recommended Skin Type <span class="text-danger skin-required-mark">*</span></label>
                            <select name="skinType" id="skinType" class="form-select form-control-custom">
                                <option value="">--Select Skin Type--</option>
                                <c:forEach var="skin" items="${skinTypes}">
                                    <option value="${skin}" ${treatment.skinType == skin ? 'selected' : ''}>${skin}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="section-header">
                        <i class="bi bi-cash-stack me-2"></i> Pricing & Duration
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <label class="form-label">Base Price (₹) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-2 border-end-0" style="border-radius: 12px 0 0 12px;">₹</span>
                                <input type="number" step="0.01" min="0" name="price" id="price"
                                       class="form-control form-control-custom border-start-0"
                                       style="border-radius: 0 12px 12px 0;"
                                       value="${treatment.id == null && treatment.price == 0 ? '' : treatment.price}"
                                       placeholder="0.00" required title="Base Price must be zero or a positive amount.">
                            </div>
                            <div class="form-text">Must be ₹0 or greater. Negative amounts are not allowed.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Duration (Minutes) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" name="duration" id="duration" min="1" max="1440" step="1"
                                       class="form-control form-control-custom border-end-0"
                                       style="border-radius: 12px 0 0 12px;"
                                       value="${treatment.duration == 0 ? '' : treatment.duration}"
                                       placeholder="e.g. 60" required title="Duration must be a positive number of minutes.">
                                <span class="input-group-text bg-light border-2 border-start-0" style="border-radius: 0 12px 12px 0;">min</span>
                            </div>
                            <div class="form-text">Must be at least 1 minute. Negative or zero values are not allowed.</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Detailed Description <span class="text-danger">*</span></label>
                            <textarea name="description" id="description" class="form-control form-control-custom" rows="4"
                                      minlength="10" maxlength="2000"
                                      placeholder="Describe the benefits, procedure, and expected results..." required><c:out value="${treatment.description}"/></textarea>
                            <div class="form-text">Required. Between 10 and 2000 characters.</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 pt-3">
                        <a href="${pageContext.request.contextPath}/salon/treatments/view" class="btn btn-cancel d-flex align-items-center">Discard Changes</a>
                        <button type="submit" class="btn btn-submit d-flex align-items-center">
                            <i class="bi bi-check2-circle me-2"></i> ${treatment.id == null ? 'Create Treatment' : 'Save Updates'}
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <script>
        function toggleTreatmentSkin() {
            const cat = document.getElementById('category').value;
            const typeDiv = document.getElementById('treatmentTypeDiv');
            const skinDiv = document.getElementById('skinTypeDiv');
            const typeSelect = document.getElementById('treatmentType');
            const skinSelect = document.getElementById('skinType');

            if (cat === "Skin") {
                typeDiv.style.display = "block";
                skinDiv.style.display = "block";
                if (typeSelect) typeSelect.required = true;
                if (skinSelect) skinSelect.required = true;
            } else {
                typeDiv.style.display = "none";
                skinDiv.style.display = "none";
                if (typeSelect) { typeSelect.required = false; typeSelect.value = ""; }
                if (skinSelect) { skinSelect.required = false; skinSelect.value = ""; }
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            toggleTreatmentSkin();
            const form = document.getElementById('treatmentForm');
            if (!form) return;
            form.addEventListener('submit', function (e) {
                const priceEl = document.getElementById('price');
                const durationEl = document.getElementById('duration');
                const descriptionEl = document.getElementById('description');
                const serviceNameEl = document.getElementById('serviceName');
                const price = parseFloat(priceEl.value);
                const duration = parseInt(durationEl.value, 10);
                const description = (descriptionEl.value || '').trim();
                const serviceName = (serviceNameEl.value || '').trim();

                if (!serviceName || serviceName.length < 2) {
                    e.preventDefault();
                    serviceNameEl.setCustomValidity('Service Name is required (at least 2 characters).');
                    serviceNameEl.reportValidity();
                    return;
                }
                serviceNameEl.setCustomValidity('');

                if (isNaN(price) || price < 0) {
                    e.preventDefault();
                    priceEl.setCustomValidity('Base Price cannot be negative.');
                    priceEl.reportValidity();
                    return;
                }
                priceEl.setCustomValidity('');

                if (isNaN(duration) || duration < 1) {
                    e.preventDefault();
                    durationEl.setCustomValidity('Duration must be at least 1 minute.');
                    durationEl.reportValidity();
                    return;
                }
                durationEl.setCustomValidity('');

                if (description.length < 10) {
                    e.preventDefault();
                    descriptionEl.setCustomValidity('Detailed Description must be at least 10 characters.');
                    descriptionEl.reportValidity();
                    return;
                }
                descriptionEl.setCustomValidity('');
            });
        });
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


