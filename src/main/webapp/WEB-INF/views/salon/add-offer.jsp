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
                <span>Our Services</span>
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
            
            <div class="mb-4 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Promotions
                </a>
                <h2 class="fw-800 m-0 text-purple">Create New Offer</h2>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/salon/saveOffer" method="post">
                    <input type="hidden" name="salonId" value="${sessionScope.loggedSalon.id}" />

                    <h5 class="section-title"><i class="bi bi-info-circle-fill me-2"></i>Offer Details</h5>
                    <div class="row g-4 mb-5">
                        <div class="col-12">
                            <label class="form-label">Offer Title</label>
                            <input type="text" name="title" class="form-control form-control-custom" placeholder="e.g. Summer Special 20% Off Haircuts" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Detailed Description</label>
                            <textarea name="description" class="form-control form-control-custom" rows="3" placeholder="Describe what this offer includes..." required></textarea>
                        </div>
                    </div>

                    <h5 class="section-title"><i class="bi bi-tag-fill me-2"></i>Pricing & Discount</h5>
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Original Price (₹)</label>
                            <input type="number" id="originalPrice" name="originalPrice" class="form-control form-control-custom" step="0.01" oninput="calculateDiscount()" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Offer Price (₹)</label>
                            <input type="number" id="offerPrice" name="offerPrice" class="form-control form-control-custom" step="0.01" oninput="calculateDiscount()" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discount Calculated (%)</label>
                            <input type="number" id="discountPercent" name="discountPercent" class="form-control form-control-custom" readonly style="background-color: #f1f3f5;">
                        </div>
                    </div>

                    <div id="pricePreviewBox" class="price-preview-box d-none">
                        <div id="pricePreview"></div>
                    </div>

                    <h5 class="section-title"><i class="bi bi-calendar-range-fill me-2"></i>Validity Period</h5>
                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <label class="form-label">Campaign Start Date</label>
                            <input type="date" name="startDate" class="form-control form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Campaign End Date</label>
                            <input type="date" name="endDate" class="form-control form-control-custom" required>
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
        function calculateDiscount() {
            const original = parseFloat(document.getElementById('originalPrice').value) || 0;
            const offer = parseFloat(document.getElementById('offerPrice').value) || 0;
            const previewBox = document.getElementById('pricePreviewBox');
            const previewText = document.getElementById('pricePreview');
            const discountInput = document.getElementById('discountPercent');

            if (original > offer && offer > 0) {
                const d = ((original - offer) / original) * 100;
                discountInput.value = d.toFixed(2);
                previewBox.classList.remove('d-none');
                previewText.innerHTML = `
                    <span class="strike-price">₹${original}</span> 
                    <i class="bi bi-arrow-right mx-2 text-muted"></i>
                    <span class="final-price">₹${offer}</span>
                    <div class="badge bg-danger ms-2">${d.toFixed(1)}% OFF</div>
                `;
            } else {
                discountInput.value = "";
                previewBox.classList.add('d-none');
            }
        }
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

