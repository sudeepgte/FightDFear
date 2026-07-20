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
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: var(--gradient-dark);
            color: white;
            padding: 30px 20px;
            z-index: 1000;
            box-shadow: 10px 0 30px rgba(0,0,0,0.1);
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
            .sidebar { width: 80px; padding: 30px 10px; }
            .sidebar-brand span, .nav-link-custom span { display: none; }
            .main-content { margin-left: 80px; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand">
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
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/viewServices">
                <i class="bi bi-magic"></i>
                <span>Service Menu</span>
            </a>
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/treatments/view">
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
            
            <div class="mb-5 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/treatments/view" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Treatments
                </a>
                <h2 class="fw-800 m-0 text-purple">${treatment.id == null ? 'Define Specialized Treatment' : 'Refine Treatment details'}</h2>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/salon/treatments/save" method="post">
                    <input type="hidden" name="id" value="${treatment.id}">

                    <div class="section-header">
                        <i class="bi bi-info-circle-fill me-2"></i> Core Information
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <label class="form-label">Category</label>
                            <select name="category" id="category" class="form-select form-control-custom" required onchange="toggleTreatmentSkin()">
                                <option value="">Select Category</option>
                                <option value="Skin" ${treatment.category == 'Skin' ? 'selected' : ''}>Skin Care</option>
                                <option value="Hair" ${treatment.category == 'Hair' ? 'selected' : ''}>Hair Care</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Service Name</label>
                            <input type="text" name="serviceName" class="form-control form-control-custom" value="${treatment.serviceName}" placeholder="e.g. Deep Hydration Facial" required>
                        </div>

                        <!-- Treatment Type (Conditional) -->
                        <div class="col-md-6" id="treatmentTypeDiv" style="${treatment.category == 'Skin' ? 'display:block;' : 'display:none;'}">
                            <label class="form-label">Specific Treatment Type</label>
                            <select name="treatmentType" class="form-select form-control-custom">
                                <option value="">--Select Type--</option>
                                <c:forEach var="type" items="${treatmentTypes}">
                                    <option value="${type}" ${treatment.treatmentType == type ? 'selected' : ''}>${type}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Skin Type (Conditional) -->
                        <div class="col-md-6" id="skinTypeDiv" style="${treatment.category == 'Skin' ? 'display:block;' : 'display:none;'}">
                            <label class="form-label">Recommended Skin Type</label>
                            <select name="skinType" class="form-select form-control-custom">
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
                            <label class="form-label">Base Price (₹)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-2 border-end-0" style="border-radius: 12px 0 0 12px;">₹</span>
                                <input type="number" step="0.01" name="price" class="form-control form-control-custom border-start-0" style="border-radius: 0 12px 12px 0;" value="${treatment.price}" placeholder="0.00" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Duration (Minutes)</label>
                            <div class="input-group">
                                <input type="number" name="duration" class="form-control form-control-custom border-end-0" style="border-radius: 12px 0 0 12px;" value="${treatment.duration}" placeholder="e.g. 60" required>
                                <span class="input-group-text bg-light border-2 border-start-0" style="border-radius: 0 12px 12px 0;">min</span>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Detailed Description</label>
                            <textarea name="description" class="form-control form-control-custom" rows="4" placeholder="Describe the benefits, procedure, and expected results...">${treatment.description}</textarea>
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
            
            if (cat === "Skin") {
                typeDiv.style.display = "block";
                skinDiv.style.display = "block";
                typeDiv.classList.add('animate__animated', 'animate__fadeIn');
                skinDiv.classList.add('animate__animated', 'animate__fadeIn');
            } else {
                typeDiv.style.display = "none";
                skinDiv.style.display = "none";
            }
        }
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

