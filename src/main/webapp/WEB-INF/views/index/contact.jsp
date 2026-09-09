<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Contact Us | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

    <style>
        :root {
            --fdf-pink: #F43F5E;
            --fdf-pink-dark: #E11D48;
            --fdf-bg-secondary: #FFF1F2;
            --fdf-border: #FFE4E6;
            --fdf-text: #0F172A;
            --fdf-muted: #64748B;
        }

        body {
            font-family: 'Inter', sans-serif;
            color: var(--fdf-text);
            background-color: #FAFAFA;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
        }

        .contact-wrapper {
            padding-top: 120px;
            padding-bottom: 80px;
            min-height: calc(100vh - 300px);
        }

        .contact-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .contact-header h1 {
            font-weight: 800;
            color: var(--fdf-text);
            font-size: 42px;
            margin-bottom: 15px;
        }

        .contact-header p {
            color: var(--fdf-muted);
            font-size: 18px;
            max-width: 600px;
            margin: 0 auto;
        }

        .glass-contact-card {
            background: #FFFFFF;
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(244, 63, 94, 0.08);
            border: 1px solid var(--fdf-border);
        }

        .info-pill {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 24px;
            background: var(--fdf-bg-secondary);
            border-radius: 16px;
            margin-bottom: 20px;
            border: 1px solid var(--fdf-border);
            transition: 0.3s;
        }

        .info-pill:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(244, 63, 94, 0.1);
        }

        .info-icon {
            width: 54px;
            height: 54px;
            background: #FFFFFF;
            color: var(--fdf-pink);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            box-shadow: 0 4px 10px rgba(244, 63, 94, 0.1);
        }

        .form-control {
            background-color: #F8FAFC;
            border: 1px solid #E2E8F0;
            color: var(--fdf-text);
        }

        .form-control:focus {
            background-color: #FFFFFF;
            border-color: var(--fdf-pink);
            box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1);
        }

        .btn-send-message {
            background: var(--fdf-pink);
            color: white;
            border: none;
            padding: 16px 32px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 16px;
            transition: 0.3s;
            width: 100%;
            box-shadow: 0 4px 15px rgba(244, 63, 94, 0.3);
        }

        .btn-send-message:hover {
            background: var(--fdf-pink-dark);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(244, 63, 94, 0.4);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="contact-wrapper">
        <div class="container">
            <div class="contact-header">
                <h1>Get In Touch</h1>
                <p>We're here to help you shine and stay safe. Reach out to our team anytime.</p>
            </div>

            <div class="glass-contact-card">
                <div class="row g-5">
                    <div class="col-lg-5">
                        <h3 class="fw-bold mb-4" style="font-size: 24px;">Our Information</h3>
                        <div class="info-pill">
                            <div class="info-icon"><i class="bi bi-geo-alt-fill"></i></div>
                            <div>
                                <div class="fw-bold" style="font-size: 17px; color: var(--fdf-text);">Headquarters</div>
                                <div class="small" style="color: var(--fdf-muted); margin-top: 4px;">198 West 21th Street, NY 10016</div>
                            </div>
                        </div>
                        <div class="info-pill">
                            <div class="info-icon"><i class="bi bi-telephone-fill"></i></div>
                            <div>
                                <div class="fw-bold" style="font-size: 17px; color: var(--fdf-text);">Call Us</div>
                                <div class="small" style="color: var(--fdf-muted); margin-top: 4px;">+1 235 2355 98</div>
                            </div>
                        </div>
                        <div class="info-pill">
                            <div class="info-icon"><i class="bi bi-envelope-fill"></i></div>
                            <div>
                                <div class="fw-bold" style="font-size: 17px; color: var(--fdf-text);">Support Email</div>
                                <div class="small" style="color: var(--fdf-muted); margin-top: 4px;">info@FightDFear.com</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <h3 class="fw-bold mb-4" style="font-size: 24px;">Send an Inquiry</h3>
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
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

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

