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
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        #sidebar-wrapper {
            min-width: 260px;
            max-width: 260px;
            background: var(--navy-dark);
            color: white;
            min-height: 100vh;
            border-top-right-radius: 40px;
            padding-top: 30px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
        }

        .sidebar-heading {
            padding: 10px 25px 25px;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
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
            flex: 1;
            padding: 40px;
        }

        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.03);
            max-width: 750px;
            margin: 0 auto;
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

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-briefcase-fill"></i> Entrepreneur
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/entrepreneur/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/entrepreneur/proposal/create" class="sidebar-link active">
                <i class="bi bi-file-earmark-plus"></i> Create Proposal
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-5">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
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
</body>
</html>
