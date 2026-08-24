<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Contact Us | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    
    <!-- Icons & CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <style>
        :root {
            --fdf-mulberry: #6a0dad;
            --fdf-plum: #312e81;
            --fdf-rose: #d63384;
            --brand-purple: #7d265a;
        }

        /* Navbar Theme */
        #header {
            background: #7d265a !important; /* wine/deep plum */
            box-shadow: 0 2px 15px rgba(0,0,0,0.2);
        }
        #header .logo h1, #header .navmenu a {
            color: #fff !important;
        }
        #header .navmenu a:hover, #header .navmenu .active {
            color: #ffd6ff !important;
        }

        .contact-hero {
            background: linear-gradient(rgba(125, 38, 90, 0.8), rgba(0, 0, 0, 0.7)), 
                        url('${pageContext.request.contextPath}/beauty/images/bg_2.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            padding: 150px 0 100px;
            color: white;
            text-align: center;
        }

        .glass-contact-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 30px;
            padding: 50px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.1);
            margin-top: -80px;
            position: relative;
            z-index: 10;
        }

        .info-pill {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background: #fff;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 1px solid #eee;
        }

        .info-icon {
            width: 50px;
            height: 50px;
            background: var(--fdf-plum);
            color: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .btn-send-message {
            background: var(--fdf-plum);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: 700;
            transition: 0.3s;
            width: 100%;
        }

        .btn-send-message:hover {
            background: var(--fdf-mulberry);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .footer {
            margin-top: 50px;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/index-beauty-header.jsp" />

    <!-- Hero -->
    <div class="contact-hero">
        <div class="container">
            <h1 class="display-4 fw-bold">Get In Touch</h1>
            <p class="lead">We're here to help you shine and stay safe.</p>
        </div>
    </div>

    <!-- Contact Content -->
    <div class="container mb-5">
        <div class="glass-contact-card">
            <div class="row g-5">
                <div class="col-lg-5">
                    <h2 class="fw-bold mb-4">Our Information</h2>
                    <div class="info-pill">
                        <div class="info-icon"><i class="bi bi-geo-alt"></i></div>
                        <div>
                            <div class="fw-bold">Headquarters</div>
                            <div class="text-muted small">198 West 21th Street, NY 10016</div>
                        </div>
                    </div>
                    <div class="info-pill">
                        <div class="info-icon"><i class="bi bi-telephone"></i></div>
                        <div>
                            <div class="fw-bold">Call Us</div>
                            <div class="text-muted small">+1 235 2355 98</div>
                        </div>
                    </div>
                    <div class="info-pill">
                        <div class="info-icon"><i class="bi bi-envelope"></i></div>
                        <div>
                            <div class="fw-bold">Support Email</div>
                            <div class="text-muted small">info@Fight D Fear.com</div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <h2 class="fw-bold mb-4">Send an Inquiry</h2>
                    <div id="alertContainer"></div>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger rounded-4" role="alert"><c:out value="${error}"/></div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success rounded-4" role="alert"><c:out value="${success}"/></div>
                    </c:if>
                    <form id="inquiryForm" action="${pageContext.request.contextPath}/sendMessage" method="post" novalidate>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="inquiryName" class="form-label fw-semibold">Your Name <span class="text-danger">*</span></label>
                                <input type="text" id="inquiryName" name="name" class="form-control p-3 rounded-4"
                                       placeholder="Full Name" required minlength="2" maxlength="80"
                                       pattern="[A-Za-z]([A-Za-z .'-]*[A-Za-z])?"
                                       title="Letters only (spaces, apostrophes, hyphens allowed). No numbers.">
                                <div class="invalid-feedback">Enter a valid name (letters only, 2–80 characters).</div>
                            </div>
                            <div class="col-md-6">
                                <label for="inquiryEmail" class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                <input type="email" id="inquiryEmail" name="email" class="form-control p-3 rounded-4" placeholder="Email Address" required maxlength="255">
                                <div class="invalid-feedback">Please enter a valid email address.</div>
                            </div>
                            <div class="col-12">
                                <label for="inquirySubject" class="form-label fw-semibold">Subject <span class="text-danger">*</span></label>
                                <input type="text" id="inquirySubject" name="subject" class="form-control p-3 rounded-4" placeholder="Subject" required maxlength="150">
                                <div class="invalid-feedback">Subject is required (max 150 characters).</div>
                            </div>
                            <div class="col-12">
                                <label for="inquiryMessage" class="form-label fw-semibold">Message <span class="text-danger">*</span></label>
                                <textarea id="inquiryMessage" name="message" rows="5" class="form-control p-3 rounded-4"
                                          placeholder="Message" required minlength="10" maxlength="2000"></textarea>
                                <div class="invalid-feedback">Message must be 10–2000 characters.</div>
                            </div>
                        </div>
                        <button type="submit" id="btnSubmitMessage" class="btn-send-message mt-4">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer id="footer" class="footer position-relative">
        <div class="container footer-top">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6 footer-about">
                    <a href="${pageContext.request.contextPath}/index/templates" class="d-flex align-items-center">Fight D Fear</a>
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
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/index/templates#services">Services</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="${pageContext.request.contextPath}/terms">Terms</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 col-md-12">
                    <h4>Follow Us</h4>
                    <p>Stay connected for safety updates.</p>
                    <jsp:include page="/WEB-INF/views/fragments/social-follow.jsp" />
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const nameInput = document.getElementById("inquiryName");
        if (nameInput) {
            nameInput.addEventListener("input", function () {
                this.value = this.value.replace(/[^A-Za-z .'-]/g, "");
            });
        }

        document.getElementById("inquiryForm").addEventListener("submit", function(e) {
            e.preventDefault();
            const btn = document.getElementById("btnSubmitMessage");
            const alertContainer = document.getElementById("alertContainer");
            const name = (document.getElementById("inquiryName").value || "").trim();
            const email = (document.getElementById("inquiryEmail").value || "").trim();
            const subject = (document.getElementById("inquirySubject").value || "").trim();
            const message = (document.getElementById("inquiryMessage").value || "").trim();

            function mark(id, ok) {
                const el = document.getElementById(id);
                if (!el) return;
                el.classList.toggle("is-invalid", !ok);
                el.classList.toggle("is-valid", ok);
            }

            const nameOk = /^[A-Za-z]([A-Za-z .'-]*[A-Za-z])?$/.test(name) && name.length >= 2 && name.length <= 80;
            const emailOk = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/.test(email);
            const subjectOk = subject.length > 0 && subject.length <= 150;
            const messageOk = message.length >= 10 && message.length <= 2000;
            mark("inquiryName", nameOk);
            mark("inquiryEmail", emailOk);
            mark("inquirySubject", subjectOk);
            mark("inquiryMessage", messageOk);
            if (!nameOk || !emailOk || !subjectOk || !messageOk) {
                alertContainer.innerHTML =
                    '<div class="alert alert-danger alert-dismissible fade show rounded-4" role="alert">' +
                    '<i class="bi bi-exclamation-triangle-fill me-2"></i> Please correct the highlighted fields.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
                return;
            }

            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Sending...';
            alertContainer.innerHTML = '';

            const params = new URLSearchParams();
            params.append("name", name);
            params.append("email", email);
            params.append("subject", subject);
            params.append("message", message);

            fetch(this.action, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: params.toString()
            })
            .then(async response => {
                const text = await response.text();
                if (response.ok) {
                    const okMsg = (text === "OK") ? "Your message has been sent successfully!" : text;
                    alertContainer.innerHTML =
                        '<div class="alert alert-success alert-dismissible fade show rounded-4" role="alert">' +
                        '<i class="bi bi-check-circle-fill me-2"></i> ' + okMsg +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
                    document.getElementById("inquiryForm").reset();
                    ["inquiryName","inquiryEmail","inquirySubject","inquiryMessage"].forEach(function(id) {
                        const el = document.getElementById(id);
                        if (el) el.classList.remove("is-valid", "is-invalid");
                    });
                } else {
                    alertContainer.innerHTML =
                        '<div class="alert alert-danger alert-dismissible fade show rounded-4" role="alert">' +
                        '<i class="bi bi-exclamation-triangle-fill me-2"></i> ' + (text || "Failed to send message. Please try again.") +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
                }
            })
            .catch(function() {
                alertContainer.innerHTML =
                    '<div class="alert alert-danger alert-dismissible fade show rounded-4" role="alert">' +
                    '<i class="bi bi-exclamation-triangle-fill me-2"></i> Failed to send message. Please try again.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
            })
            .finally(function() {
                btn.disabled = false;
                btn.innerText = "Send Message";
            });
        });
    </script>
</body>
</html>

