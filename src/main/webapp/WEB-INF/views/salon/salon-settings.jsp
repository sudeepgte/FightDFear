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
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
    <style>
        :root { 
            --sidebar-width: 280px; 
            --dashboard-bg: #F8FAFC;
            --primary-accent: #F43F5E;
            --secondary-subtext: #64748B;
            --card-bg: #FFFFFF;
            
            --success-bg: #F0FDF4;
            --success-text: #16A34A;
            
            --warning-bg: #FFF7ED;
            --warning-text: #C2410C;
            
            --error-bg: #FEF2F2;
            --error-text: #DC2626;
            
            --border-color: #E2E8F0;
            --text-main: #0F172A;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--text-main);
            overflow-x: hidden;
            margin: 0;
        }
        
        .settings-card {
            background: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            margin-bottom: 25px;
            overflow: hidden;
        }
        .settings-card-header {
            background: var(--card-bg);
            color: var(--text-main);
            padding: 24px 25px;
            border-bottom: 1px solid var(--border-color);
        }
        .settings-card-header h5 {
            margin: 0;
            font-weight: 700;
        }
        .settings-card-header h5 i {
            color: var(--primary-accent);
        }
        .settings-card-body {
            padding: 30px;
        }
        .form-label {
            font-weight: 600;
            color: var(--secondary-subtext);
        }
        .form-control:focus {
            border-color: var(--primary-accent);
            box-shadow: 0 0 0 0.25rem rgba(244, 63, 94, 0.25);
        }
        .btn-save {
            background-color: var(--primary-accent);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.3);
            color: white;
            background-color: #E11D48;
        }
        .form-check-input:checked {
            background-color: var(--primary-accent);
            border-color: var(--primary-accent);
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
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-main);
        }
        .switch-label i {
            font-size: 1.2rem;
            margin-right: 10px;
            color: var(--primary-accent);
        }
        
        /* Sidebar layout adjustment */
        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 4px 0 24px rgba(0,0,0,0.04);
                background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }
        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: var(--primary-accent); color: white; transform: translateX(5px); }
        
        .main-content {
            padding: 40px;
            background-color: var(--dashboard-bg);
            min-height: 100vh;
        }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="settings"/>
</jsp:include>

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

