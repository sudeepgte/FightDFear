<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Proposal — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #1e1b4b;
            --navy-light: #312e81;
            --primary: #f43f5e;
            --bg-light: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
            overflow-x: hidden; /* Crucial for preventing horizontal pan on mobile */
            width: 100vw;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        #sidebar-wrapper {
            width: 210px;
            background: var(--navy-dark);
            color: white;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            border-top-right-radius: 40px;
            padding-top: 30px;
            padding-bottom: 40px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .sidebar-heading {
            padding: 10px 15px 25px;
            font-size: 1.05rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 12px 15px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: white;
            background: rgba(255,255,255,0.05);
            border-left-color: var(--primary);
        }

        #page-content-wrapper {
            margin-left: 210px;
            flex: 1;
            min-width: 0;
            padding: 15px 20px;
            min-height: 100vh;
            transition: all 0.3s ease;
        }
        
        .mobile-nav-toggle {
            display: none;
        }
        
        @media (max-width: 992px) {
            #sidebar-wrapper {
                margin-left: -210px;
                position: fixed;
                z-index: 1000;
                height: 100%;
                border-radius: 0;
                padding-top: 15px;
            }
            #wrapper.toggled #sidebar-wrapper {
                margin-left: 0;
                box-shadow: 5px 0 15px rgba(0,0,0,0.2);
            }
            #wrapper.toggled #page-content-wrapper {
                opacity: 0.5;
                pointer-events: none;
                transform: translateX(210px);
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 15px 10px;
                width: 100%;
                transition: transform 0.3s ease, opacity 0.3s ease;
                overflow-x: hidden;
            }
            .mobile-nav-toggle {
                display: block;
                position: relative;
                z-index: 1050;
                margin-bottom: 15px !important;
            }
            .sidebar-heading {
                padding-bottom: 10px;
            }
            .form-container {
                padding: 20px 15px;
                border-radius: 12px;
            }
        }

        /* Hide the global header UI but keep its DOM for WebSockets/Modals */
        #header {
            visibility: hidden !important;
            height: 0 !important;
            padding: 0 !important;
            overflow: hidden !important;
            position: absolute !important;
        }

        .broadcast-badge {
            background-color: var(--primary);
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.7rem;
            margin-left: 5px;
        }

        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            max-width: 1100px;
            margin: 0; /* Aligns left properly without massive gaps */
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1.5px solid #cbd5e1;
            padding: 10px 15px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #f43f5e;
            box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }

        .btn-submit {
            background: linear-gradient(135deg, #1e1b4b, #f43f5e);
            color: white;
            border: none;
            padding: 12px 30px;
            font-weight: 700;
            border-radius: 30px;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(244, 63, 94, 0.3);
            color: white;
        }
    </style>
</head>
<body>

<!-- Hidden header for global background scripts (WebRTC, broadcasts) -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3 d-flex flex-column" style="flex: 1;">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link active">
                <i class="bi bi-file-earmark-plus"></i> Create Proposal
            </a>
            
            <a href="${pageContext.request.contextPath}/entrepreneur/bookings" class="sidebar-link">
                <i class="bi bi-calendar-check"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/wallet" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <c:if test="${not empty user}">
                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="sidebar-link">
                    <i class="bi bi-person-circle"></i> My Profile
                </a>
            </c:if>
            <a href="#" data-bs-toggle="modal" data-bs-target="#broadcastModal" onclick="markBroadcastsAsRead()" class="sidebar-link">
                <i class="bi bi-bell"></i> Notifications
                <c:if test="${unreadBroadcastCount > 0}">
                    <span class="broadcast-badge">${unreadBroadcastCount}</span>
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light rounded-pill mx-3 mt-4 mb-3 text-start" style="font-size: 0.9rem; padding: 10px 15px;">
                <i class="bi bi-arrow-left-circle me-1"></i> Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <button class="btn btn-primary d-lg-none mobile-nav-toggle shadow-sm px-3 mb-4" id="menu-toggle">
            <i class="bi bi-list fs-5"></i>
        </button>
        <div class="form-container">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="text-secondary text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <h3 class="fw-bold mb-4" style="color: var(--navy-dark);">Create New Business Proposal</h3>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/entrepreneur/proposal/create" method="post" enctype="multipart/form-data">
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Proposal Title *</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Expansion of Tailoring Shop" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Category *</label>
                        <select name="category" class="form-select" required>
                            <option value="">Select Category</option>
                            <option value="Tea Shop">Tea Shop</option>
                            <option value="Fruits Shop">Fruits Shop</option>
                            <option value="Tailoring Shop">Tailoring Shop</option>
                            <option value="Beauty Salon">Beauty Salon</option>
                            <option value="Homemade Food Business">Homemade Food Business</option>
                            <option value="Pickle Business">Pickle Business</option>
                            <option value="Boutique">Boutique</option>
                            <option value="Candle Making">Candle Making</option>
                            <option value="Soap Making">Soap Making</option>
                            <option value="Dairy Business">Dairy Business</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Business Location *</label>
                        <input type="text" name="location" class="form-control" placeholder="City or State" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Investment Needed (₹) *</label>
                        <input type="number" name="fundingNeeded" class="form-control" min="1" placeholder="Total funding requested" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Expected Monthly Income (₹) *</label>
                        <input type="number" name="expectedMonthlyIncome" class="form-control" min="1" placeholder="Expected profit/income" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Business Description *</label>
                        <textarea name="description" class="form-control" rows="5" placeholder="Detailed business model, growth plan, and usage of funds..." required></textarea>
                    </div>
                </div>

                <h5 class="fw-bold mb-3" style="color: var(--navy-dark); border-bottom: 1px solid #cbd5e1; padding-bottom:8px;">Media Attachments</h5>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Upload Business Photos *</label>
                        <input type="file" name="photos" class="form-control" accept="image/*" multiple required>
                        <div class="form-text text-muted">Select one or more images representing your business location or products.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Upload Business Documents *</label>
                        <input type="file" name="documents" class="form-control" accept=".pdf,.doc,.docx" multiple required>
                        <div class="form-text text-muted">Select licensing, registration, or business plan documents.</div>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Video Pitch (Optional)</label>
                        <input type="file" name="videoPitch" class="form-control" accept="video/*">
                        <div class="form-text text-muted">Upload a video explaining your pitch to investors directly.</div>
                    </div>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-submit">Submit Proposal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Mobile Sidebar Toggle
    const toggleBtn = document.getElementById('menu-toggle');
    if(toggleBtn) {
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
        });
    }
</script>
</body>
</html>
