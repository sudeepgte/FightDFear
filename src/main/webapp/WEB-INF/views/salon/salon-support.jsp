<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - Fight D Fear</title>
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
        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--light-bg, #f8f9fa);
        }
        .support-card {
            background: white;
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 25px;
            overflow: hidden;
            height: 100%;
        }
        .support-card-header {
            background: linear-gradient(135deg, var(--primary-color, #ff4d4d) 0%, var(--secondary-color, #ff1a1a) 100%);
            color: white;
            padding: 20px 25px;
            border-bottom: none;
        }
        .support-card-header h5 {
            margin: 0;
            font-weight: 600;
        }
        .support-card-body {
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
        .btn-submit {
            background: linear-gradient(135deg, var(--primary-color, #ff4d4d) 0%, var(--secondary-color, #ff1a1a) 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 77, 77, 0.4);
            color: white;
        }
        
        .accordion-button:not(.collapsed) {
            color: var(--primary-color, #ff4d4d);
            background-color: rgba(255, 77, 77, 0.1);
            box-shadow: inset 0 -1px 0 rgba(0,0,0,.125);
        }
        .accordion-button:focus {
            box-shadow: none;
            border-color: rgba(0,0,0,.125);
        }
        
        .contact-method {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 12px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .contact-method:hover {
            border-color: var(--primary-color, #ff4d4d);
            box-shadow: 0 4px 10px rgba(255, 77, 77, 0.1);
        }
        .contact-icon {
            font-size: 2rem;
            color: var(--primary-color, #ff4d4d);
            margin-right: 20px;
        }
        
        /* Sidebar layout adjustment */
        :root { --sidebar-width: 280px; }
        .sidebar { background: var(--gradient-dark); color: white; width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }
        
        .main-content {
            padding: 25px;
            margin-left: var(--sidebar-width);
        }
    </style>
</head>
<body>

    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="support"/>
</jsp:include>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Help & Support Center</h2>
                <p class="text-muted mb-0">Find answers or reach out to our team.</p>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Submit Ticket Form -->
            <div class="col-lg-7">
                <div class="support-card">
                    <div class="support-card-header">
                        <h5><i class="bi bi-envelope-paper me-2"></i> Submit a Support Ticket</h5>
                    </div>
                    <div class="support-card-body">
                        <form action="${pageContext.request.contextPath}/salon/support/submit" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Issue Category / Subject</label>
                                <select class="form-select" name="subject" required>
                                    <option value="" disabled selected>Select an issue category...</option>
                                    <option value="Billing & Payments Issue">Billing & Payments Issue</option>
                                    <option value="Booking System Problem">Booking System Problem</option>
                                    <option value="Account Settings Update">Account Settings Update</option>
                                    <option value="Technical Bug / Glitch">Technical Bug / Glitch</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Detailed Description</label>
                                <textarea class="form-control" name="message" rows="6" placeholder="Please describe your issue in detail. Include any relevant booking IDs, transaction numbers, or screenshots..." required></textarea>
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn btn-submit">
                                    <i class="bi bi-send-fill me-2"></i> Submit Ticket
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <!-- Direct Contact info -->
                <div class="support-card mb-4" style="height: auto;">
                    <div class="support-card-header" style="background: linear-gradient(135deg, #111 0%, #333 100%);">
                        <h5><i class="bi bi-headset me-2"></i> Instant Support</h5>
                    </div>
                    <div class="support-card-body">
                        <div class="contact-method">
                            <i class="bi bi-telephone-fill contact-icon"></i>
                            <div>
                                <h6 class="mb-1 fw-bold">Call Us (Toll Free)</h6>
                                <p class="mb-0 text-muted">1800-FIGHT-FEAR <br><small>Available Mon-Fri, 9am - 6pm</small></p>
                            </div>
                        </div>
                        <div class="contact-method">
                            <i class="bi bi-envelope-fill contact-icon text-primary"></i>
                            <div>
                                <h6 class="mb-1 fw-bold">Email Support</h6>
                                <p class="mb-0 text-muted">support@fightdfear.com <br><small>Usually responds in 2 hours</small></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- FAQs -->
                <div class="support-card" style="height: auto;">
                    <div class="support-card-header">
                        <h5><i class="bi bi-question-circle-fill me-2"></i> Frequently Asked Questions</h5>
                    </div>
                    <div class="support-card-body">
                        <div class="accordion" id="faqAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingOne">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        How do payouts work?
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-muted">
                                        Payouts for app bookings are processed automatically every Monday directly to your registered bank account minus the platform fee.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingTwo">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        How can I change my Salon's location?
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-muted">
                                        You can update your address, city, and pincode in the <strong>Settings</strong> tab on your dashboard.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingThree">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        Can I block a troublesome client?
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-muted">
                                        Yes, navigate to the <strong>Clients</strong> tab, find the client, and use the "Flag/Block" option. They will no longer be able to book your salon.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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

