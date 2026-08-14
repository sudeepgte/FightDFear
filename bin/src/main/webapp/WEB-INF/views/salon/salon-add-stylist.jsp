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
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        #ftco-navbar {
            position: sticky !important;
            top: 0;
            z-index: 1050;
            background-color: #6a0dad !important;
        }

        #ftco-navbar .navbar-brand,
        #ftco-navbar .nav-link {
            color: #ffffff !important;
        }

        #ftco-navbar .nav-link:hover {
            color: #ffd6ff !important;
        }

        main {
            flex: 1;
            padding-top: 40px;
        }

        .offer-form {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 600px;
            margin: 0 auto 60px;
        }

        .strike { text-decoration: line-through; color: #888; }
        .final-price { color: #28a745; font-weight: bold; }
   </style>
 
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index/templates">
            <span class="flaticon-lotus"></span> Fight D Fear
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

            <form action="${pageContext.request.contextPath}/saveStylist" method="post" enctype="multipart/form-data">
                <input type="hidden" name="salonId" value="${salon.id}" />

                <div class="mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control" name="firstName" id="firstName" placeholder="First Name" required>
                </div>

                <div class="mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="lastName" id="lastName" placeholder="Last Name">
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" name="email" id="email" placeholder="Email" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                </div>

                <div class="mb-3">
                    <label for="specialization" class="form-label">Specialization</label>
                    <input type="text" class="form-control" name="specialization" id="specialization" placeholder="Haircut, Spa, Color, etc.">
                </div>

                <div class="mb-3">
                    <label for="experienceInYears" class="form-label">Experience (Years)</label>
                    <input type="number" class="form-control" name="experienceInYears" id="experienceInYears" placeholder="e.g. 5">
                </div>

                <div class="mb-3">
                    <label for="contactNumber" class="form-label">Contact Number</label>
                    <input type="text" class="form-control" name="contactNumber" id="contactNumber" placeholder="Phone Number">
                </div>

                <div class="mb-3">
                    <label for="availabilityHours" class="form-label">Availability Hours</label>
                    <input type="text" class="form-control" name="availabilityHours" id="availabilityHours" placeholder="e.g. 10 AM - 7 PM">
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
<footer id="footer" class="footer position-relative">
    <div class="container footer-top">
        <div class="row gy-4">

            <div class="col-lg-4 col-md-6 footer-about">
                <a href="${pageContext.request.contextPath}/index/templates"
                   class="d-flex align-items-center">
                   Fight D Fear
                </a>
                <div class="pt-3">
                    <p class="fw-semibold">Our Values</p>
                    <p>Awareness • Safety • Equality • Empowerment</p>
                    <p class="mt-2">Building a safer tomorrow, together.</p>
                </div>
            </div>

            <div class="col-lg-2 col-md-3 footer-links">
                <h4>Useful Links</h4>
                <ul>
                    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates">Home</a></li>
                    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/about">About us</a></li>
                    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/services">Services</a></li>
                    <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
                </ul>
            </div>

            <div class="col-lg-2 col-md-3 footer-links">
                <h4>Our Services</h4>
                <ul>
                    <li><i class="bi bi-chevron-right"></i> Emergency Assistance</li>
                    <li><i class="bi bi-chevron-right"></i> Safety Education</li>
                    <li><i class="bi bi-chevron-right"></i> Self-defense Training</li>
                    <li><i class="bi bi-chevron-right"></i> Community Support</li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-12">
                <h4>Follow Us</h4>
                <p>Stay connected with us for safety updates and empowerment.</p>
                <div class="social-links d-flex">
                    <a href="#"><i class="bi bi-twitter"></i></a>
                    <a href="#"><i class="bi bi-facebook"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

        </div>
    </div>

    <div class="container text-center mt-4">
        <p>© <strong>Fight D Fear</strong> All Rights Reserved</p>
    </div>
</footer>

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
</body>
</html>


