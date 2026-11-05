<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${service.id == null ? 'Add Service' : 'Edit Service'} | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet"><link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

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
            max-width: 900px;
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

        .service-preview-img {
            width: 100%;
            max-width: 250px;
            height: 180px;
            border-radius: 20px;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            margin-top: 15px;
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
        }
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

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
            max-width: 900px;
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

        .service-preview-img {
            width: 100%;
            max-width: 250px;
            height: 180px;
            border-radius: 20px;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            margin-top: 15px;
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
        }

        .btn-cancel:hover {
            background: var(--brand-purple);
            color: white;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .sidebar { display: none !important; }
            .main-content { margin-left: 0 !important; padding: 15px; width: 100%; overflow-x: hidden; }
            .form-card { padding: 20px; border-radius: 16px; margin: 0; }
            .mb-4.d-flex.align-items-center.gap-3 { flex-direction: column; align-items: flex-start !important; gap: 15px !important; }
            h2.fw-800 { font-size: 1.5rem; }
            .btn-submit, .btn-cancel { width: 100%; padding: 12px; display: block; text-align: center; }
            .d-flex.justify-content-center.gap-3.mt-5 { flex-direction: column; gap: 10px !important; width: 100%; }
            .input-group-text { padding: 8px 12px; }
            input.w-50 { width: 100% !important; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="services"/>
</jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="mb-4 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Services
                </a>
                <h2 class="fw-800 m-0 text-purple">${service.id == null ? 'Add New Service' : 'Edit Service details'}</h2>
            </div>

            <div class="form-card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 shadow-sm" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form id="serviceForm" action="${pageContext.request.contextPath}/salon/addService${not empty _csrf ? '?'.concat(_csrf.parameterName).concat('=').concat(_csrf.token) : ''}" method="post" enctype="multipart/form-data" onsubmit="return validateServiceForm(event)" novalidate>
                    <c:if test="${not empty _csrf}">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </c:if>
                    <input type="hidden" name="id" value="${service.id}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label" for="inputCategory">Service Category <span class="text-danger">*</span></label>
                            <select name="category" id="inputCategory" class="form-select form-control-custom" required>
                                <option value="" disabled <c:if test="${empty service.category}">selected</c:if>>-- Select Category --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" <c:if test="${service.category == cat}">selected</c:if>>${cat}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback" id="categoryFeedback">Please select a valid service category.</div>
                            <div class="small text-muted mt-1">Select the most relevant category for your service.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="inputName">Service Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" id="inputName" class="form-control form-control-custom" value="${service.name}" placeholder="e.g. Premium Hair Spa" required maxlength="100">
                            <div class="invalid-feedback" id="nameFeedback">Service name must be between 3 and 100 characters.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="inputPrice">Price (₹) <span class="text-danger">*</span></label>
                            <div class="input-group has-validation">
                                <span class="input-group-text bg-light border-2 border-end-0" style="border-radius: 12px 0 0 12px;">₹</span>
                                <input type="number" step="0.01" min="1" max="100000" name="price" id="inputPrice" class="form-control form-control-custom border-start-0" style="border-radius: 0 12px 12px 0;" value="${service.price}" placeholder="e.g. 499" required>
                                <div class="invalid-feedback" id="priceFeedback">Please enter a valid price greater than ₹0.</div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="inputDuration">Duration (Minutes) <span class="text-danger">*</span></label>
                            <input type="number" min="5" max="480" name="durationMinutes" id="inputDuration" class="form-control form-control-custom" value="${service.durationMinutes}" placeholder="e.g. 45" required>
                            <div class="invalid-feedback" id="durationFeedback">Duration must be between 5 and 480 minutes.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="inputIngredients">Ingredients Used</label>
                            <input type="text" name="ingredients" id="inputIngredients" class="form-control form-control-custom" value="${service.ingredients}" placeholder="e.g. Argan oil, Keratin" maxlength="250">
                            <div class="invalid-feedback" id="ingredientsFeedback">Ingredients text cannot exceed 250 characters.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="inputAllergen">Allergen Information</label>
                            <input type="text" name="allergenInfo" id="inputAllergen" class="form-control form-control-custom" value="${service.allergenInfo}" placeholder="e.g. Contains nut extracts" maxlength="250">
                            <div class="invalid-feedback" id="allergenFeedback">Allergen info cannot exceed 250 characters.</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label" for="inputPhoto">Service Visuals (Photo)</label>
                            <div class="border-2 border-dashed p-4 text-center rounded-4 bg-light">
                                <i class="bi bi-cloud-upload text-purple" style="font-size: 2rem;"></i>
                                <div class="mt-2 fw-semibold">Click to upload or drag and drop</div>
                                <div class="small text-muted mb-3">JPG, JPEG, PNG, WEBP (Max 5MB)</div>
                                <input type="file" name="photo" id="inputPhoto" class="form-control w-50 mx-auto" accept="image/jpeg,image/png,image/jpg,image/webp" onchange="previewServiceImage(this)">
                                <div class="invalid-feedback d-block text-danger fw-semibold mt-2" id="photoFeedback" style="display:none !important;"></div>
                                
                                <div id="imagePreviewContainer" class="mt-3" style="${not empty service.photoUrl ? '' : 'display:none;'}">
                                    <p class="small fw-bold text-uppercase text-muted mb-1">Image Preview:</p>
                                    <img id="servicePreviewImg" src="${not empty service.photoUrl ? pageContext.request.contextPath.concat(service.photoUrl) : ''}" class="service-preview-img">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-5">
                        <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn btn-cancel">Discard</a>
                        <button type="submit" class="btn btn-submit" id="btnSubmitService">
                            <i class="bi bi-check2-circle me-2"></i> ${service.id == null ? 'Publish Service' : 'Update Service'}
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
    <script>
        function previewServiceImage(input) {
            const photoErr = document.getElementById('photoFeedback');
            const previewContainer = document.getElementById('imagePreviewContainer');
            const previewImg = document.getElementById('servicePreviewImg');

            if (photoErr) {
                photoErr.style.setProperty('display', 'none', 'important');
                photoErr.textContent = '';
            }

            if (input.files && input.files[0]) {
                const file = input.files[0];
                const validTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/webp'];
                const maxBytes = 5 * 1024 * 1024; // 5 MB

                if (!validTypes.includes(file.type.toLowerCase())) {
                    if (photoErr) {
                        photoErr.textContent = 'Please select a valid image file (JPG, PNG, WEBP).';
                        photoErr.style.setProperty('display', 'block', 'important');
                    }
                    input.value = '';
                    return false;
                }

                if (file.size > maxBytes) {
                    if (photoErr) {
                        photoErr.textContent = 'File size exceeds 5MB limit. Please choose a smaller image.';
                        photoErr.style.setProperty('display', 'block', 'important');
                    }
                    input.value = '';
                    return false;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    if (previewImg) previewImg.src = e.target.result;
                    if (previewContainer) previewContainer.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
            return true;
        }

        function validateServiceForm(e) {
            let isValid = true;

            const category = document.getElementById('inputCategory');
            const name = document.getElementById('inputName');
            const price = document.getElementById('inputPrice');
            const duration = document.getElementById('inputDuration');
            const ingredients = document.getElementById('inputIngredients');
            const allergen = document.getElementById('inputAllergen');
            const photo = document.getElementById('inputPhoto');

            // Reset field states
            [category, name, price, duration, ingredients, allergen].forEach(el => {
                if (el) el.classList.remove('is-invalid');
            });

            // Validate Category
            if (!category || !category.value || category.value.trim() === '') {
                category.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Name
            if (!name || !name.value || name.value.trim().length < 3 || name.value.trim().length > 100) {
                name.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Price
            const priceVal = parseFloat(price ? price.value : '0');
            if (isNaN(priceVal) || priceVal <= 0 || priceVal > 100000) {
                price.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Duration
            const durVal = parseInt(duration ? duration.value : '0', 10);
            if (isNaN(durVal) || durVal < 5 || durVal > 480) {
                duration.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Ingredients max length
            if (ingredients && ingredients.value && ingredients.value.trim().length > 250) {
                ingredients.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Allergen max length
            if (allergen && allergen.value && allergen.value.trim().length > 250) {
                allergen.classList.add('is-invalid');
                isValid = false;
            }

            // Validate Photo if selected
            if (photo && photo.files && photo.files[0]) {
                if (!previewServiceImage(photo)) {
                    isValid = false;
                }
            }

            if (!isValid) {
                if (e) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                const firstInvalid = document.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
                return false;
            }

            return true;
        }

        document.addEventListener('DOMContentLoaded', function() {
            const inputs = ['inputCategory', 'inputName', 'inputPrice', 'inputDuration', 'inputIngredients', 'inputAllergen'];
            inputs.forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', function() {
                        if (this.classList.contains('is-invalid')) {
                            this.classList.remove('is-invalid');
                        }
                    });
                    el.addEventListener('change', function() {
                        if (this.classList.contains('is-invalid')) {
                            this.classList.remove('is-invalid');
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>




