<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Settings - Fight D Fear</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--light-bg, #f8f9fa);
        }
        .settings-card {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            overflow: hidden;
        }
        .settings-card-header {
            background: linear-gradient(135deg, var(--primary-color, #ff4d4d) 0%, var(--secondary-color, #ff1a1a) 100%);
            color: white;
            padding: 20px 25px;
            border-bottom: none;
        }
        .settings-card-header h5 {
            margin: 0;
            font-weight: 600;
        }
        .settings-card-body {
            padding: 30px;
        }
        .form-label {
            font-weight: 500;
            color: #495057;
        }
        .form-control:focus {
            border-color: var(--primary-color, #ff4d4d);
            box-shadow: 0 0 0 0.25rem rgba(255, 77, 77, 0.25);
        }
        .btn-save {
            background: linear-gradient(135deg, var(--primary-color, #ff4d4d) 0%, var(--secondary-color, #ff1a1a) 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 77, 77, 0.4);
            color: white;
        }
        .form-check-input:checked {
            background-color: var(--primary-color, #ff4d4d);
            border-color: var(--primary-color, #ff4d4d);
        }
        
        /* Modern Toggle Switch */
        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
            margin-top: 0.1em;
            margin-right: 15px;
        }
        .switch-label {
            display: flex;
            align-items: center;
            font-weight: 500;
            margin-bottom: 15px;
        }
        .switch-label i {
            font-size: 1.2rem;
            margin-right: 10px;
            color: var(--primary-color, #ff4d4d);
        }
        
        /* Sidebar layout adjustment */
        :root { --sidebar-width: 280px; }
        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        
        .main-content {
            padding: 25px;
            margin-left: var(--sidebar-width);
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

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Salon Settings</h2>
                <p class="text-muted mb-0">Manage your business profile, location, and amenities.</p>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/salon/settings/update" method="POST">
            
            <div class="row">
                <!-- Basic Information -->
                <div class="col-lg-8">
                    <div class="settings-card">
                        <div class="settings-card-header">
                            <h5><i class="bi bi-shop me-2"></i> Business Information</h5>
                        </div>
                        <div class="settings-card-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Salon Name</label>
                                    <input type="text" class="form-control" name="name" value="${salon.name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" class="form-control" name="email" value="${salon.email}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" name="phone" value="${salon.phone}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Availability Hours</label>
                                    <input type="text" class="form-control" name="availabilityHours" value="${salon.availabilityHours}" placeholder="e.g. Mon-Sun: 9 AM - 9 PM">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">About Salon (Bio)</label>
                                    <textarea class="form-control" name="bio" rows="4" placeholder="Brief description of your salon...">${salon.bio}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Location Settings -->
                    <div class="settings-card">
                        <div class="settings-card-header">
                            <h5><i class="bi bi-geo-alt me-2"></i> Location Details</h5>
                        </div>
                        <div class="settings-card-body">
                            <div class="row g-4">
                                <div class="col-12">
                                    <label class="form-label">Full Address</label>
                                    <input type="text" class="form-control" name="address" value="${salon.address}" required>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label">City</label>
                                    <input type="text" class="form-control" name="city" value="${salon.city}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">State</label>
                                    <input type="text" class="form-control" name="state" value="${salon.state}" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Pincode</label>
                                    <input type="text" class="form-control" name="pincode" value="${salon.pincode}" required>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Features & Amenities -->
                <div class="col-lg-4">
                    <div class="settings-card">
                        <div class="settings-card-header">
                            <h5><i class="bi bi-star me-2"></i> Amenities</h5>
                        </div>
                        <div class="settings-card-body">
                            
                            <div class="form-check form-switch switch-label">
                                <input class="form-check-input" type="checkbox" id="isWomenOnly" name="isWomenOnly" value="true" ${salon.isWomenOnly ? 'checked' : ''}>
                                <label class="form-check-label" for="isWomenOnly">
                                    <i class="bi bi-gender-female"></i> Women Only Salon
                                </label>
                            </div>
                            
                            <hr class="my-4">

                            <div class="form-check form-switch switch-label">
                                <input class="form-check-input" type="checkbox" id="hasParking" name="hasParking" value="true" ${salon.hasParking ? 'checked' : ''}>
                                <label class="form-check-label" for="hasParking">
                                    <i class="bi bi-p-circle"></i> Car Parking Available
                                </label>
                            </div>

                            <div class="form-check form-switch switch-label">
                                <input class="form-check-input" type="checkbox" id="hasAc" name="hasAc" value="true" ${salon.hasAc ? 'checked' : ''}>
                                <label class="form-check-label" for="hasAc">
                                    <i class="bi bi-snow"></i> Air Conditioned (AC)
                                </label>
                            </div>

                            <div class="form-check form-switch switch-label">
                                <input class="form-check-input" type="checkbox" id="hasWifi" name="hasWifi" value="true" ${salon.hasWifi ? 'checked' : ''}>
                                <label class="form-check-label" for="hasWifi">
                                    <i class="bi bi-wifi"></i> Free Wi-Fi
                                </label>
                            </div>
                            
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-save btn-lg">
                            <i class="bi bi-cloud-arrow-up me-2"></i> Save Changes
                        </button>
                    </div>
                </div>
            </div>
            
        </form>

    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts
        setTimeout(function() {
            var alert = document.querySelector('.alert');
            if(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 4000);
    </script>
</body>
</html>

