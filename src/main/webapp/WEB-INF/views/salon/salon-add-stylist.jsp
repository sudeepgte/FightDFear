<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Add Offer | Fight D Fear</title>

    <!-- ================= BOOTSTRAP ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

    <!-- ================= GOOGLE FONTS ================= -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- ================= ICONS ================= -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/open-iconic-bootstrap.min.css">

    <!-- ================= THEME CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/aos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/ionicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/jquery.timepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/icomoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <!-- ================= PROJECT CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <meta charset="UTF-8">
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Add Offer | Fight D Fear</title>

    <!-- ================= BOOTSTRAP ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

    <!-- ================= GOOGLE FONTS ================= -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- ================= ICONS ================= -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/open-iconic-bootstrap.min.css">

    <!-- ================= THEME CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/aos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/ionicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/jquery.timepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/icomoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <!-- ================= PROJECT CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <meta charset="UTF-8">
    <title>Add Stylist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
     footer {
    margin-top: 60px;
}
        :root {
            --brand-pink: #F43F5E;
            --bg-color: #F8FAFC;
            --text-dark: #1E293B;
            --text-muted: #64748B;
            --white: #FFFFFF;
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Poppins', 'Open Sans', sans-serif;
        }

        #ftco-navbar {
            position: sticky !important;
            top: 0;
            z-index: 1050;
            background-color: var(--white) !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        #ftco-navbar .navbar-brand {
            color: var(--brand-pink) !important;
            font-weight: 700;
        }

        #ftco-navbar .nav-link {
            color: var(--text-dark) !important;
            font-weight: 500;
        }

        #ftco-navbar .nav-link:hover, #ftco-navbar .nav-item.active .nav-link {
            color: var(--brand-pink) !important;
        }

        main {
            flex: 1;
            padding-top: 40px;
        }

        .offer-form {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            padding: 30px;
            max-width: 600px;
            margin: 0 auto 60px;
        }

        .strike { text-decoration: line-through; color: var(--text-muted); }
        .final-price { color: #28a745; font-weight: bold; }
        
        /* Form Card Styling */
        .container.mt-5 > .row > .col-md-8 {
            background: var(--white);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin-bottom: 50px;
        }
        
        h2, .container h2, h2.mb-4 {
            color: var(--text-dark) !important;
            font-weight: 700 !important;
            font-family: 'Poppins', sans-serif !important;
            text-shadow: none !important;
            -webkit-text-stroke: 0 !important;
            letter-spacing: normal !important;
        }
        
        .form-label, form label {
            font-weight: 500 !important;
            color: var(--text-dark) !important;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            padding: 10px 15px;
        }
        
        .form-control:focus {
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 0.2rem rgba(244, 63, 94, 0.25);
        }
        
        .btn.btn-primary, button.btn-primary {
            background-color: var(--brand-pink) !important;
            border-color: var(--brand-pink) !important;
            color: var(--white) !important;
            font-weight: 600 !important;
            border-radius: 8px !important;
            padding: 10px 24px !important;
            transition: 0.2s !important;
            text-transform: uppercase !important;
            letter-spacing: 1px !important;
        }
        
        .btn.btn-primary:hover, button.btn-primary:hover {
            background-color: #e11d48 !important;
            border-color: #e11d48 !important;
            color: var(--white) !important;
        }
        
        a.btn-secondary, .btn.btn-secondary {
            background-color: var(--white) !important;
            color: var(--text-muted) !important;
            border: 1px solid #cbd5e1 !important;
            font-weight: 600 !important;
            border-radius: 8px !important;
            padding: 10px 24px !important;
            text-transform: uppercase !important;
            letter-spacing: 1px !important;
        }
        
        a.btn-secondary:hover, .btn.btn-secondary:hover {
            background-color: #f1f5f9 !important;
            color: var(--text-dark) !important;
        }
    </style>
 

    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index/templates">
            <img src="${pageContext.request.contextPath}/assets/img/fightdfear-logo.jpg" alt="Fight D Fear" style="height: 32px; width: 32px; border-radius: 8px; object-fit: cover;"> Fight D Fear
        </a>

        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#ftco-nav" aria-controls="ftco-nav"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="oi oi-menu"></span>
        </button>

        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/salons/dashboard">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/salons/profile">Profile</a></li>
        
                <li class="nav-item active"><a class="nav-link" href="${pageContext.request.contextPath}/booking/list">View Bookings</a>
                </li>
                 
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/salon/viewServices">View Services</a>
              </li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/salons/logout">Logout</a>
               </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <h2 class="mb-4">Add New Stylist</h2>

            <!-- Display error or success messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/saveStylist" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                <input type="hidden" name="salonId" value="${salon.id}" />

                <div class="mb-3">
                    <label for="firstName" class="form-label">First Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="firstName" id="firstName" placeholder="First Name" required minlength="2" maxlength="50">
                    <div class="invalid-feedback">Please enter a valid first name (2-50 characters).</div>
                </div>

                <div class="mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="lastName" id="lastName" placeholder="Last Name" maxlength="50">
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" name="email" id="email" placeholder="Email" required pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                    <div class="invalid-feedback">Please enter a valid email address (e.g. name@domain.com).</div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Password" required minlength="8" maxlength="20" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
                    <div class="invalid-feedback">Password must be 8-20 characters long and include at least one uppercase letter, one lowercase letter, and one number.</div>
                </div>

                <div class="mb-3">
                    <label for="specialization" class="form-label">Specialization</label>
                    <input type="text" class="form-control" name="specialization" id="specialization" placeholder="Haircut, Spa, Color, etc." maxlength="100">
                </div>

                <div class="mb-3">
                    <label for="experienceInYears" class="form-label">Experience (Years)</label>
                    <input type="number" class="form-control" name="experienceInYears" id="experienceInYears" placeholder="e.g. 5" min="0" max="60">
                    <div class="invalid-feedback">Experience must be a realistic number.</div>
                </div>

                <div class="mb-3">
                    <label for="contactNumber" class="form-label">Contact Number <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="contactNumber" id="contactNumber" placeholder="10-digit Phone Number" required pattern="^[0-9]{10}$" maxlength="10" minlength="10">
                    <div class="invalid-feedback">Please enter exactly 10 digits.</div>
                </div>

                <div class="mb-3">
                    <label for="availabilityHours" class="form-label">Availability Hours</label>
                    <input type="text" class="form-control" name="availabilityHours" id="availabilityHours" placeholder="e.g. 10 AM - 7 PM" maxlength="100">
                </div>

                <div class="mb-3">
                    <label for="bio" class="form-label">Bio</label>
                    <textarea class="form-control" name="bio" id="bio" rows="3" placeholder="Short description about stylist"></textarea>
                </div>

                <div class="mb-3">
                    <label for="profileImage" class="form-label">Profile Image</label>
                    <input type="file" class="form-control" name="profileImage" id="profileImage" accept="image/*">
                </div>

                <button type="submit" class="btn btn-primary">Add Stylist</button>
                <a href="${pageContext.request.contextPath}/myStylists" class="btn btn-secondary ms-2">Back to List</a>
            </form>

        </div>
    </div>
</div>

<!-- ================= JS FILES ================= -->
<script src="${pageContext.request.contextPath}/beauty/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery-migrate-3.0.1.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.easing.1.3.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.stellar.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.animateNumber.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/bootstrap-datepicker.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/jquery.timepicker.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/scrollax.min.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/google-map.js"></script>
<script src="${pageContext.request.contextPath}/beauty/js/main.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation script
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>
</body>
</html>
