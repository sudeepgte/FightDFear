<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Promotion | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
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

        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }

        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            
            .main-content { margin-left: var(--sidebar-width); }
        }

        .form-section { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); margin-bottom: 25px; }
        .section-title { font-weight: 800; color: var(--brand-purple-darker); margin-bottom: 25px; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
        
        .form-label { font-weight: 600; color: #4a5568; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #dee2e6; background-color: #f8f9fa; }
        .form-control:focus, .form-select:focus { border-color: var(--brand-purple); box-shadow: 0 0 0 0.25rem rgba(106, 13, 173, 0.1); background-color: white; }

        .btn-submit { background: var(--brand-purple); color: white; padding: 12px 30px; border-radius: 50px; font-weight: 600; border: none; transition: all 0.3s; }
        .btn-submit:hover { background: var(--brand-purple-darker); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(106, 13, 173, 0.3); }
        .btn-draft { background: white; color: var(--brand-purple); border: 2px solid var(--brand-purple); padding: 10px 25px; border-radius: 50px; font-weight: 600; transition: all 0.3s; }
        .btn-draft:hover { background: #f8f5ff; }

        .select2-container--default .select2-selection--multiple { border-radius: 12px; border: 1px solid #dee2e6; background-color: #f8f9fa; padding: 6px; }
    
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

    <div class="main-content">
        <div class="container-fluid max-w-4xl" style="max-width: 900px; margin: 0 auto;">
            
            <div class="mb-4 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/promotions" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back
                </a>
                <h2 class="fw-800 m-0 text-purple">Create New Promotion</h2>
            </div>

            <form action="${pageContext.request.contextPath}/salon/promotions/add" method="POST" id="promotionForm">
                
                <input type="hidden" name="status" id="promoStatus" value="Active">

                <!-- Promotion Details -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-megaphone-fill"></i> Promotion Details</div>
                    
                    <div class="mb-3">
                        <label class="form-label">Promotion Title *</label>
                        <input type="text" name="promotionName" class="form-control" required placeholder="e.g. Summer Hair Care Promotion">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <textarea name="description" class="form-control" rows="3" required placeholder="What is this campaign about?"></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Banner / Image URL (Optional)</label>
                        <input type="text" name="bannerUrl" class="form-control" placeholder="https://example.com/banner.jpg">
                    </div>
                </div>

                <!-- Category -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-tag-fill"></i> Promotion Category</div>
                    <div class="row">
                        <div class="col-md-6">
                            <select name="category" class="form-select">
                                <option value="Seasonal">Seasonal</option>
                                <option value="Festival">Festival</option>
                                <option value="Bridal">Bridal</option>
                                <option value="Student">Student</option>
                                <option value="Birthday">Birthday</option>
                                <option value="Special Event">Special Event</option>
                                <option value="General">General</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Campaign Period -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-calendar-range-fill"></i> Promotion Period</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Start Date *</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">End Date *</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Start Time (Optional)</label>
                            <input type="time" name="startTime" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">End Time (Optional)</label>
                            <input type="time" name="endTime" class="form-control">
                        </div>
                    </div>
                </div>

                <!-- Target Audience -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-people-fill"></i> Target Audience</div>
                    <div class="row">
                        <div class="col-md-6">
                            <select name="targetAudience" class="form-select">
                                <option value="All Customers">All Customers</option>
                                <option value="New Customers">New Customers</option>
                                <option value="Returning Customers">Returning Customers</option>
                                <option value="Male Customers">Male Customers</option>
                                <option value="Female Customers">Female Customers</option>
                                <option value="Students">Students</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Associated Offers -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-gift-fill"></i> Associated Offers</div>
                    <p class="text-muted small mb-3">Link this campaign to existing offers/discounts. <b>No price calculation happens here.</b></p>
                    <select name="offerIds" class="form-select select2-multiple" multiple="multiple" style="width: 100%;">
                        <c:forEach var="off" items="${existingOffers}">
                            <option value="${off.id}">${off.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- CTA Data -->
                <input type="hidden" name="headline" value="">
                <input type="hidden" name="ctaText" value="Book Now">

                <!-- Submit Area -->
                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/salon/promotions" class="text-muted text-decoration-none fw-bold">Cancel</a>
                    
                    <div class="d-flex gap-3">
                        <button type="button" class="btn btn-draft" onclick="submitDraft()">Save Draft</button>
                        <button type="submit" class="btn btn-submit"><i class="bi bi-check2-circle me-2"></i> Create Promotion</button>
                    </div>
                </div>

            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('.select2-multiple').select2({
                placeholder: "Select an existing offer...",
                allowClear: true
            });
        });

        function submitDraft() {
            document.getElementById('promoStatus').value = 'Draft';
            document.getElementById('promotionForm').submit();
        }
    </script>
</body>
</html>

