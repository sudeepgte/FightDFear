<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Want to Earn | Apply for a Job</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- CSS -->
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --m-purple: #1e1b4b;
            --m-pink: #f43f5e;
            --m-bg: #fffcfd;
            --m-shadow: 0 15px 35px rgba(30, 27, 75, 0.1);
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--m-bg);
            color: #333;
            min-height: 100vh;
        }
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--m-shadow);
            margin-top: 50px;
            margin-bottom: 50px;
            border: 1px solid rgba(30, 27, 75, 0.1);
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            color: var(--m-purple);
        }
        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px 15px;
        }
        .btn-submit {
            background: linear-gradient(135deg, var(--m-purple) 0%, var(--m-pink) 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 700;
            width: 100%;
            transition: 0.3s;
        }
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(219, 39, 119, 0.3);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="form-container">
                    <div class="form-header">
                        <h2>Start Earning Today</h2>
                        <p class="text-muted">Fill out this application to offer your services.</p>
                    </div>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success text-center">
                            ${message}
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">
                            ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/marketplace/earn" method="POST" enctype="multipart/form-data">
                        <!-- User Details (Pre-filled) -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Full Name</label>
                            <input type="text" class="form-control" value="${user.fullName}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control" value="${user.email}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Phone Number</label>
                            <input type="text" class="form-control" value="${user.phoneNumber}" readonly>
                        </div>

                        <!-- Job Details -->
                        <div class="mb-3">
                            <label for="jobCategory" class="form-label fw-bold">Job Category <span class="text-danger">*</span></label>
                            <select class="form-select" id="jobCategory" name="jobCategory" required onchange="updateSubCategories()">
                                <option value="" disabled selected>Select Category</option>
                                <option value="Caregiver">Caregiver</option>
                                <option value="Babysitting">Babysitting</option>
                                <option value="Housekeeping">Housekeeping</option>
                                <option value="Cooking">Cooking</option>
                                <option value="Beauty & Salon">Beauty & Salon</option>
                                <option value="Healthcare">Healthcare</option>
                                <option value="Teaching">Teaching</option>
                                <option value="Office Jobs">Office Jobs</option>
                                <option value="Retail">Retail</option>
                                <option value="Hospitality">Hospitality</option>
                                <option value="Customer Support">Customer Support</option>
                                <option value="Delivery & Logistics">Delivery & Logistics</option>
                                <option value="Domestic Help">Domestic Help</option>
                                <option value="Tailoring & Fashion">Tailoring & Fashion</option>
                                <option value="Digital Jobs">Digital Jobs</option>
                                <option value="Freelancing">Freelancing</option>
                                <option value="Entrepreneurship">Entrepreneurship</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="jobSubCategory" class="form-label fw-bold">Specific Job <span class="text-danger">*</span></label>
                            <select class="form-select" id="jobSubCategory" name="jobSubCategory" required>
                                <option value="" disabled selected>Select Specific Job</option>
                            </select>
                        </div>

                        <!-- Proof Document -->
                        <div class="mb-4">
                            <label for="proofDocument" class="form-label fw-bold">Upload Proof Document (ID/Certificate) <span class="text-danger">*</span></label>
                            <input class="form-control" type="file" id="proofDocument" name="proofDocument" required>
                            <small class="text-muted">Please upload a clear PDF or image showing your qualifications or ID.</small>
                        </div>
                        
                        <div class="mb-4">
                            <label for="hourlyRate" class="form-label fw-bold">Hourly Rate (₹) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="hourlyRate" name="hourlyRate" min="0" step="0.01" placeholder="e.g. 500" required>
                            <small class="text-muted">Set your expected amount per hour for your services.</small>
                        </div>

                        <button type="submit" class="btn-submit">Submit Application</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const categories = {
            "Caregiver": ["Elderly Caregiver", "Patient Care Assistant", "Child Caregiver", "Home Care Assistant"],
            "Babysitting": ["Babysitter", "Nanny", "Daycare Assistant"],
            "Housekeeping": ["House Maid", "Housekeeper", "Cleaner"],
            "Cooking": ["Home Cook", "Personal Cook", "Kitchen Assistant"],
            "Beauty & Salon": ["Beautician", "Hair Stylist", "Makeup Artist", "Nail Technician"],
            "Healthcare": ["Nurse", "Care Assistant", "Receptionist", "Lab Assistant"],
            "Teaching": ["Tutor", "School Teacher", "Preschool Teacher"],
            "Office Jobs": ["Receptionist", "Office Assistant", "Data Entry Operator"],
            "Retail": ["Cashier", "Sales Executive", "Store Assistant"],
            "Hospitality": ["Hotel Receptionist", "Housekeeping Staff", "Waitress"],
            "Customer Support": ["Call Center Executive", "Customer Care Representative"],
            "Delivery & Logistics": ["Parcel Coordinator", "Delivery Executive (where applicable)"],
            "Domestic Help": ["Laundry Assistant", "Home Helper"],
            "Tailoring & Fashion": ["Tailor", "Boutique Assistant", "Fashion Designer"],
            "Digital Jobs": ["Content Writer", "Graphic Designer", "Social Media Executive"],
            "Freelancing": ["Virtual Assistant", "Translator", "Online Tutor"],
            "Entrepreneurship": ["Sell Handmade Products", "Home Bakery", "Boutique Owner"]
        };

        function updateSubCategories() {
            const categorySelect = document.getElementById("jobCategory");
            const subCategorySelect = document.getElementById("jobSubCategory");
            const selectedCategory = categorySelect.value;
            
            // Clear existing options
            subCategorySelect.innerHTML = '<option value="" disabled selected>Select Specific Job</option>';
            
            if (selectedCategory && categories[selectedCategory]) {
                categories[selectedCategory].forEach(subCat => {
                    const option = document.createElement("option");
                    option.value = subCat;
                    option.text = subCat;
                    subCategorySelect.appendChild(option);
                });
            }
        }
    </script>
    </div>
</div>
</body>
</html>
