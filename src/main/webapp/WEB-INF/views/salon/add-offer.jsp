<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Promotion | Fight D Fear</title>

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
            max-width: 800px;
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

        .price-preview-box {
            background: #fdf2f8;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            margin-bottom: 25px;
            border: 1px dashed var(--brand-pink);
        }

        .strike-price {
            text-decoration: line-through;
            color: #888;
            font-size: 1rem;
        }

        .final-price {
            color: #157347;
            font-weight: 800;
            font-size: 1.8rem;
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

        .section-title {
            color: var(--brand-purple);
            font-weight: 800;
            border-bottom: 2px solid #f1f3f5;
            padding-bottom: 10px;
            margin-bottom: 25px;
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
            
            <div class="mb-4 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Promotions
                </a>
                <h2 class="fw-800 m-0 text-purple">Create New Offer</h2>
            </div>

            <div class="form-card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger rounded-4 mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${error}"/>
                    </div>
                </c:if>
                <form id="offerForm" action="${pageContext.request.contextPath}/salon/saveOffer" method="post">
                    <input type="hidden" name="salonId" value="${not empty salonId ? salonId : (not empty salon ? salon.id : sessionScope.loggedSalon.id)}" />

                    <h5 class="section-title"><i class="bi bi-info-circle-fill me-2"></i>Offer Details</h5>
                    <div class="row g-4 mb-5">
                        <div class="col-12">
                            <label class="form-label">Offer Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-custom"
                                   value="<c:out value='${offer.title}'/>"
                                   maxlength="255" placeholder="e.g. Summer Special 20% Off Haircuts" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Detailed Description <span class="text-danger">*</span></label>
                            <textarea name="description" class="form-control form-control-custom" rows="3"
                                      maxlength="500" placeholder="Describe what this offer includes..." required><c:out value="${offer.description}"/></textarea>
                            <div class="form-text">Required. Maximum 500 characters.</div>
                        </div>
                    </div>

                    <h5 class="section-title"><i class="bi bi-tag-fill me-2"></i>Pricing & Discount</h5>
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Original Price (₹) <span class="text-danger">*</span></label>
                            <input type="number" id="originalPrice" name="originalPrice" class="form-control form-control-custom"
                                   step="0.01" min="0.01" value="${offer.originalPrice > 0 ? offer.originalPrice : ''}"
                                   oninput="onOriginalOrOfferChange()" required title="Original price must be greater than zero.">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Offer Price (₹) <span class="text-danger">*</span></label>
                            <input type="number" id="offerPrice" name="offerPrice" class="form-control form-control-custom"
                                   step="0.01" min="0" value="${offer.offerPrice > 0 ? offer.offerPrice : (offer.offerPrice == 0 && offer.originalPrice > 0 ? 0 : '')}"
                                   oninput="onOriginalOrOfferChange()" required title="Offer price must be less than the original price.">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discount (%) <span class="text-danger">*</span></label>
                            <input type="number" id="discountPercent" name="discountPercent" class="form-control form-control-custom"
                                   step="0.01" min="0.01" max="99.99"
                                   value="${offer.discountPercent > 0 ? offer.discountPercent : ''}"
                                   oninput="onDiscountChange()" required
                                   title="Enter a discount between 0.01 and 99.99.">
                            <div class="form-text">Enter a number from 0.01 to 99.99. Offer price updates automatically.</div>
                        </div>
                    </div>

                    <div id="pricePreviewBox" class="price-preview-box d-none">
                        <div id="pricePreview"></div>
                    </div>
                    <div id="dateError" class="alert alert-danger rounded-4 d-none" role="alert"></div>

                    <h5 class="section-title"><i class="bi bi-calendar-range-fill me-2"></i>Validity Period</h5>
                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <label class="form-label">Campaign Start Date <span class="text-danger">*</span></label>
                            <input type="date" name="startDate" id="startDate" class="form-control form-control-custom"
                                   value="${offer.startDate}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Campaign End Date <span class="text-danger">*</span></label>
                            <input type="date" name="endDate" id="endDate" class="form-control form-control-custom"
                                   value="${offer.endDate}" required>
                            <div class="form-text">Must be after the Campaign Start Date.</div>
                        </div>
                    </div>

                    <div class="text-center pt-3">
                        <button type="submit" class="btn btn-submit px-5">
                            <i class="bi bi-check2-circle me-2"></i> Launch Promotion
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <script>
        function updatePreview(original, offer, discount) {
            const previewBox = document.getElementById('pricePreviewBox');
            const previewText = document.getElementById('pricePreview');
            if (original > offer && offer >= 0 && original > 0 && discount > 0) {
                previewBox.classList.remove('d-none');
                previewText.innerHTML =
                    '<span class="strike-price">₹' + original.toFixed(2) + '</span>' +
                    '<i class="bi bi-arrow-right mx-2 text-muted"></i>' +
                    '<span class="final-price">₹' + offer.toFixed(2) + '</span>' +
                    '<div class="badge bg-danger ms-2">' + discount.toFixed(1) + '% OFF</div>';
            } else {
                previewBox.classList.add('d-none');
            }
        }

        function onOriginalOrOfferChange() {
            const original = parseFloat(document.getElementById('originalPrice').value);
            const offer = parseFloat(document.getElementById('offerPrice').value);
            const discountInput = document.getElementById('discountPercent');
            if (!isNaN(original) && original > 0 && !isNaN(offer) && offer >= 0 && offer < original) {
                const d = ((original - offer) / original) * 100;
                discountInput.value = d.toFixed(2);
                updatePreview(original, offer, d);
            } else {
                updatePreview(original || 0, offer || 0, 0);
            }
        }

        function onDiscountChange() {
            const original = parseFloat(document.getElementById('originalPrice').value);
            const discount = parseFloat(document.getElementById('discountPercent').value);
            const offerInput = document.getElementById('offerPrice');
            if (!isNaN(original) && original > 0 && !isNaN(discount) && discount > 0 && discount < 100) {
                const offer = original * (1 - (discount / 100));
                offerInput.value = offer.toFixed(2);
                updatePreview(original, offer, discount);
            } else {
                updatePreview(original || 0, parseFloat(offerInput.value) || 0, discount || 0);
            }
        }

        function dayAfter(isoDate) {
            const d = new Date(isoDate + 'T00:00:00');
            d.setDate(d.getDate() + 1);
            const yyyy = d.getFullYear();
            const mm = String(d.getMonth() + 1).padStart(2, '0');
            const dd = String(d.getDate()).padStart(2, '0');
            return yyyy + '-' + mm + '-' + dd;
        }

        (function initOfferForm() {
            const start = document.getElementById('startDate');
            const end = document.getElementById('endDate');
            const form = document.getElementById('offerForm');
            const dateError = document.getElementById('dateError');
            if (!start || !end || !form) return;

            function syncEndMin() {
                if (start.value) {
                    end.min = dayAfter(start.value);
                } else {
                    end.removeAttribute('min');
                }
            }

            function showDateError(msg) {
                if (!dateError) return;
                if (msg) {
                    dateError.textContent = msg;
                    dateError.classList.remove('d-none');
                } else {
                    dateError.textContent = '';
                    dateError.classList.add('d-none');
                }
            }

            start.addEventListener('change', function () {
                syncEndMin();
                if (end.value && end.value <= start.value) {
                    showDateError('Campaign End Date must be after the Campaign Start Date.');
                    end.setCustomValidity('Campaign End Date must be after the Campaign Start Date.');
                } else {
                    showDateError('');
                    end.setCustomValidity('');
                }
            });
            end.addEventListener('change', function () {
                if (start.value && end.value && end.value <= start.value) {
                    showDateError('Campaign End Date must be after the Campaign Start Date.');
                    end.setCustomValidity('Campaign End Date must be after the Campaign Start Date.');
                } else {
                    showDateError('');
                    end.setCustomValidity('');
                }
            });

            form.addEventListener('submit', function (e) {
                syncEndMin();
                const discount = parseFloat(document.getElementById('discountPercent').value);
                if (isNaN(discount) || discount <= 0 || discount >= 100) {
                    e.preventDefault();
                    document.getElementById('discountPercent').setCustomValidity('Discount must be greater than 0 and less than 100.');
                    document.getElementById('discountPercent').reportValidity();
                    return;
                }
                document.getElementById('discountPercent').setCustomValidity('');
                if (!start.value || !end.value || end.value <= start.value) {
                    e.preventDefault();
                    showDateError('Campaign End Date must be after the Campaign Start Date.');
                    end.setCustomValidity('Campaign End Date must be after the Campaign Start Date.');
                    end.reportValidity();
                    return;
                }
                end.setCustomValidity('');
                showDateError('');
            });

            syncEndMin();
            onOriginalOrOfferChange();
        })();
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
