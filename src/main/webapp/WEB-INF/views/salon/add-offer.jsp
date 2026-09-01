<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Offer | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Offer | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #F8FAFC;
            --brand-purple: #F43F5E;
            --brand-purple-darker: #1E293B;
            --gradient-dark: linear-gradient(135deg, #1E293B 0%, #64748B 100%);
            --fdf-border: #cbd5e1;
        }

        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }

        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
            .main-content { margin-left: var(--sidebar-width); }
        }

        .form-section { background: white; border-radius: 20px; padding: 30px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); margin-bottom: 25px; }
        .section-title { font-weight: 800; color: var(--brand-purple-darker); margin-bottom: 25px; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
        
        .form-label { font-weight: 600; color: #4a5568; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #dee2e6; background-color: #f8f9fa; }
        .form-control:focus, .form-select:focus { border-color: var(--brand-purple); box-shadow: 0 0 0 0.25rem rgba(106, 13, 173, 0.1); background-color: white; }

        .btn-submit { background: #F43F5E !important; color: white !important; padding: 12px 30px; border-radius: 50px; font-weight: 700; border: none; transition: all 0.3s; text-transform: uppercase; letter-spacing: 1px; }
        .btn-submit:hover { background: #e11d48 !important; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(244, 63, 94, 0.3); }
        
        .select2-container--default .select2-selection--multiple { border-radius: 12px; border: 1px solid #dee2e6; background-color: #f8f9fa; padding: 6px; }
    </style>
</head>
<body>
    
    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="offers"/>
</jsp:include>

    <div class="main-content">
        <div class="container-fluid max-w-4xl" style="max-width: 900px; margin: 0 auto;">
            
            <div class="mb-4 d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${salonId}" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back
                </a>
                <h2 class="fw-800 m-0 text-purple" style="color: var(--brand-purple-darker) !important;">Create New Offer / Discount</h2>
            </div>

            <form action="${pageContext.request.contextPath}/salon/saveOffer" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="salonId" value="${salonId}">
                
                <!-- 1. Basic Info -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-info-circle-fill"></i> Basic Information</div>
                    
                    <div class="mb-3">
                        <label class="form-label">Offer Name *</label>
                        <input type="text" name="title" class="form-control" required placeholder="e.g. Hair Cut + Hair Spa Combo">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <textarea name="description" class="form-control" rows="2" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Offer Image (Optional)</label>
                        <input type="file" name="offerImage" class="form-control" accept="image/*">
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-select">
                                <option value="Hair">Hair</option>
                                <option value="Facial">Facial</option>
                                <option value="Skin Care">Skin Care</option>
                                <option value="Nails">Nails</option>
                                <option value="Bridal">Bridal</option>
                                <option value="Packages">Packages</option>
                                <option value="First Visit">First Visit</option>
                                <option value="Seasonal">Seasonal</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Offer Type</label>
                            <select name="offerType" class="form-select">
                                <option value="Service Combo">Service Combo</option>
                                <option value="Buy One Get One">Buy One Get One</option>
                                <option value="First Visit Offer">First Visit Offer</option>
                                <option value="Flat Discount">Flat Discount</option>
                                <option value="Percentage Discount">Percentage Discount</option>
                                <option value="Special Price">Special Price</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 2. Applicable Services -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-card-checklist"></i> Applicable Services</div>
                    <p class="text-muted small mb-3">Select the specific services this discount applies to.</p>
                    <select name="serviceIds" class="form-select select2-multiple" multiple="multiple" style="width: 100%;">
                        <c:forEach var="svc" items="${salonServices}">
                            <option value="${svc.id}">${svc.name} (₹${svc.price})</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 3. Pricing Configuration -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-currency-rupee"></i> Discount Configuration</div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Original Price (₹)</label>
                            <input type="number" name="originalPrice" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discounted / Offer Price (₹)</label>
                            <input type="number" name="discountedPrice" class="form-control" step="0.01" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Discount % (Optional)</label>
                            <input type="number" name="discountPercent" class="form-control" step="0.01" value="0">
                        </div>
                    </div>
                </div>

                <!-- 4. Conditions -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-shield-check"></i> Offer Conditions</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Minimum Booking Amount (₹)</label>
                            <input type="number" name="minBookingAmount" class="form-control" value="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Maximum Discount Amount (₹)</label>
                            <input type="number" name="maxDiscountAmount" class="form-control" value="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Customer Eligibility</label>
                            <select name="customerEligibility" class="form-select">
                                <option value="All Customers">All Customers</option>
                                <option value="New Customers Only">New Customers Only</option>
                                <option value="Returning Customers Only">Returning Customers Only</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Total Usage Limit (0 = Unlimited)</label>
                            <input type="number" name="totalUsageLimit" class="form-control" value="0">
                        </div>
                    </div>
                </div>

                <!-- 5. Validity Period -->
                <div class="form-section">
                    <div class="section-title"><i class="bi bi-calendar-range-fill"></i> Validity Period</div>
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
                            <label class="form-label">Applicable Start Time (Happy Hours)</label>
                            <input type="time" name="startTimeStr" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Applicable End Time</label>
                            <input type="time" name="endTimeStr" class="form-control">
                        </div>
                    </div>
                </div>

                <div class="text-end mb-5">
                    <button type="submit" class="btn btn-submit px-5 py-3 fs-5">
                        <i class="bi bi-check2-circle me-2"></i> Save Offer Details
                    </button>
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
                placeholder: "Select applicable services..."
            });
        });
    </script>
</body>
</html>


