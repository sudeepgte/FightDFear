<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${service.id == null ? 'Add Service' : 'Edit Service'} | Fight D Fear</title>

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
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/viewServices">
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
                <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Services
                </a>
                <h2 class="fw-800 m-0 text-purple">${service.id == null ? 'Add New Service' : 'Edit Service details'}</h2>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/salon/addService" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${service.id}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Service Category</label>
                            <select name="category" class="form-select form-control-custom" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" <c:if test="${service.category == cat}">selected</c:if>>${cat}</option>
                                </c:forEach>
                            </select>
                            <div class="small text-muted mt-1">Select the most relevant category for your service.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Service Name</label>
                            <input type="text" name="name" class="form-control form-control-custom" value="${service.name}" placeholder="e.g. Premium Hair Spa" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Price (₹)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-2 border-end-0" style="border-radius: 12px 0 0 12px;">₹</span>
                                <input type="number" step="0.01" name="price" class="form-control form-control-custom border-start-0" style="border-radius: 0 12px 12px 0;" value="${service.price}" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Duration (Minutes)</label>
                            <input type="number" name="durationMinutes" class="form-control form-control-custom" value="${service.durationMinutes}" placeholder="e.g. 45" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Ingredients Used</label>
                            <input type="text" name="ingredients" class="form-control form-control-custom" value="${service.ingredients}" placeholder="e.g. Argan oil, Keratin">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Allergen Information</label>
                            <input type="text" name="allergenInfo" class="form-control form-control-custom" value="${service.allergenInfo}" placeholder="e.g. Contains nut extracts">
                        </div>

                        <div class="col-12">
                            <label class="form-label">Service Visuals (Photo)</label>
                            <div class="border-2 border-dashed p-4 text-center rounded-4 bg-light">
                                <i class="bi bi-cloud-upload text-purple" style="font-size: 2rem;"></i>
                                <div class="mt-2 fw-semibold">Click to upload or drag and drop</div>
                                <div class="small text-muted mb-3">JPG, PNG (Max 5MB)</div>
                                <input type="file" name="photo" class="form-control w-50 mx-auto">
                                
                                <c:if test="${not empty service.photoUrl}">
                                    <div class="mt-3">
                                        <p class="small fw-bold text-uppercase">Current Image:</p>
                                        <img src="${pageContext.request.contextPath}${service.photoUrl}" class="service-preview-img">
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-5">
                        <a href="${pageContext.request.contextPath}/salon/viewServices" class="btn btn-cancel">Discard</a>
                        <button type="submit" class="btn btn-submit">
                            <i class="bi bi-check2-circle me-2"></i> ${service.id == null ? 'Publish Service' : 'Update Service'}
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>



