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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">

    <style>
        /* /marketplace/earn only — Women Jobs / Martial Arts 60-30-10 */
        body.wj-earn-page {
            --wj-rose: #F43F5E;
            --wj-rose-hover: #E11D48;
            --wj-navy: #0F172A;
            --wj-text: #0F172A;
            --wj-muted: #64748B;
            --wj-bg: #F8FAFC;
            --wj-border: #E2E8F0;
            font-family: 'Inter', sans-serif;
            background: var(--wj-bg);
            color: var(--wj-text);
            min-height: 100vh;
        }
        body.wj-earn-page #page-content-wrapper {
            background: var(--wj-bg);
        }
        body.wj-earn-page .form-container {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02);
            margin-top: 30px;
            margin-bottom: 30px;
            border: 1px solid var(--wj-border);
        }

        body.wj-earn-page .form-label {
            color: var(--wj-navy);
        }
        body.wj-earn-page .form-header {
            margin: -30px -30px 24px -30px;
            padding: 20px 30px 20px 30px;
            background: var(--wj-navy);
            border-radius: 16px 16px 0 0;
            color: #fff;
        }
        body.wj-earn-page .form-header h2 {
            color: #fff !important;
        }
        body.wj-earn-page .form-header p {
            color: #cbd5e1 !important;
        }
        @media (max-width: 576px) {
            body.wj-earn-page .form-container {
                padding: 20px 15px;
                margin-top: 15px;
                margin-bottom: 15px;
            }
            body.wj-earn-page .form-header {
                margin: -20px -15px 20px -15px;
                padding: 15px 15px;
            }
        }
        body.wj-earn-page .form-control,
        body.wj-earn-page .form-select {
            border-radius: 8px;
            padding: 12px 14px;
            border: 1px solid var(--wj-border);
            font-size: 0.9rem;
            max-width: 100%;
        }
        body.wj-earn-page .form-select {
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
        }
        body.wj-earn-page .form-control:focus,
        body.wj-earn-page .form-select:focus {
            border-color: var(--wj-rose);
            box-shadow: 0 0 0 0.2rem rgba(244, 63, 94, 0.15);
        }
        body.wj-earn-page .btn-submit {
            background: var(--wj-rose);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            width: 100%;
            transition: 0.2s;
            margin-top: 10px;
        }
        body.wj-earn-page .btn-submit:hover {
            background: var(--wj-rose-hover);
            color: #fff;
            box-shadow: 0 10px 20px rgba(244, 63, 94, 0.25);
        }
    </style>
</head>
<body class="wj-earn-page">
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="form-container">
                    <div class="form-header border-bottom">
                        <h2 class="m-0 fs-4 fw-bold">Start Earning Today</h2>
                        <p class="mt-2 mb-0" style="font-size: 0.9rem;">Fill out this application to offer your services.</p>
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
                            <label class="form-label fw-bold">Job Category <span class="text-danger">*</span></label>
                            <input type="hidden" id="jobCategory" name="jobCategory" required>
                            <div class="dropdown">
                                <button class="btn w-100 text-start d-flex justify-content-between align-items-center" type="button" id="categoryDropdownBtn" data-bs-toggle="dropdown" aria-expanded="false" style="background:#fff; border: 1px solid var(--wj-border); color: #334155; padding: 12px 14px; border-radius: 8px;">
                                    <span>Select Category</span>
                                    <i class="fas fa-chevron-down text-muted" style="font-size: 0.8rem;"></i>
                                </button>
                                <ul class="dropdown-menu w-100 shadow" aria-labelledby="categoryDropdownBtn" style="max-height: 250px; overflow-y: auto; border-radius: 8px; border: 1px solid var(--wj-border);">
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Caregiver', event)">Caregiver</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Babysitting', event)">Babysitting</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Housekeeping', event)">Housekeeping</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Cooking', event)">Cooking</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Beauty', event)">Beauty & Salon</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Healthcare', event)">Healthcare</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Teaching', event)">Teaching</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Office', event)">Office Jobs</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Retail', event)">Retail</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Hospitality', event)">Hospitality</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Support', event)">Support / Care</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Delivery', event)">Delivery</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Domestic', event)">Domestic Help</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Tailoring', event)">Tailoring</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Digital', event)">Digital Jobs</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Freelancing', event)">Freelancing</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="selectCategory('Business', event)">Business</a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Specific Job <span class="text-danger">*</span></label>
                            <input type="hidden" id="jobSubCategory" name="jobSubCategory" required>
                            <div class="dropdown">
                                <button class="btn w-100 text-start d-flex justify-content-between align-items-center" type="button" id="subCategoryDropdownBtn" data-bs-toggle="dropdown" aria-expanded="false" style="background:#fff; border: 1px solid var(--wj-border); color: #334155; padding: 12px 14px; border-radius: 8px;">
                                    <span>Select Specific Job</span>
                                    <i class="fas fa-chevron-down text-muted" style="font-size: 0.8rem;"></i>
                                </button>
                                <ul class="dropdown-menu w-100 shadow" id="subCategoryList" aria-labelledby="subCategoryDropdownBtn" style="max-height: 250px; overflow-y: auto; border-radius: 8px; border: 1px solid var(--wj-border);">
                                    <li><a class="dropdown-item text-muted" href="#" onclick="event.preventDefault();">Please select a Job Category first</a></li>
                                </ul>
                            </div>
                        </div>

                        <!-- Proof Document -->
                        <div class="mb-4">
                            <label for="proofDocument" class="form-label fw-bold">Upload Proof Document (ID/Certificate) <span class="text-danger">*</span></label>
                            <input class="form-control" type="file" id="proofDocument" name="proofDocument" required>
                            <small class="text-muted">Please upload a clear PDF or image showing your qualifications or ID.</small>
                        </div>
                        
                        <div class="mb-4">
                            <label for="hourlyRate" class="form-label fw-bold">Hourly Rate (₹) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="hourlyRate" name="hourlyRate" min="1" step="0.01" placeholder="e.g. 500" required>
                            <small class="text-muted">Set your expected amount per hour for your services.</small>
                        </div>

                        <button type="submit" class="btn-submit">Submit Application</button>
                    </form>
                </div>
            </div>
        </div>
    </div>



    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        const categories = {
            "Caregiver": ["Elder Care", "Patient Care", "Child Care", "Home Care"],
            "Babysitting": ["Babysitter", "Nanny", "Daycare"],
            "Housekeeping": ["House Maid", "Housekeeper", "Cleaner"],
            "Cooking": ["Home Cook", "Personal Cook", "Kitchen Help"],
            "Beauty": ["Beautician", "Hair Stylist", "Makeup Artist", "Nails"],
            "Healthcare": ["Nurse", "Care Assist", "Receptionist", "Lab Assist"],
            "Teaching": ["Tutor", "Teacher", "Preschool"],
            "Office": ["Receptionist", "Office Assist", "Data Entry"],
            "Retail": ["Cashier", "Sales Exec", "Store Assist"],
            "Hospitality": ["Hotel Desk", "Housekeeping", "Waitress"],
            "Support": ["Call Center", "Care Rep"],
            "Delivery": ["Parcel Coord", "Delivery Exec"],
            "Domestic": ["Laundry", "Home Helper"],
            "Tailoring": ["Tailor", "Boutique Help", "Fashion"],
            "Digital": ["Writer", "Designer", "Social Media"],
            "Freelancing": ["Virtual Assist", "Translator", "Online Tutor"],
            "Business": ["Handmade Goods", "Home Bakery", "Boutique Owner"]
        };

        function selectCategory(categoryValue, event) {
            event.preventDefault();
            const categoryText = event.target.innerText;
            
            // Set hidden input and button text
            document.getElementById("jobCategory").value = categoryValue;
            document.querySelector("#categoryDropdownBtn span").innerText = categoryText;
            
            // Update sub-category button and options
            const subCategoryList = document.getElementById("subCategoryList");
            const subCategoryInput = document.getElementById("jobSubCategory");
            
            document.querySelector("#subCategoryDropdownBtn span").innerText = "Select Specific Job";
            subCategoryInput.value = "";
            
            subCategoryList.innerHTML = '';
            
            if (categoryValue && categories[categoryValue]) {
                categories[categoryValue].forEach(subCat => {
                    const li = document.createElement("li");
                    const a = document.createElement("a");
                    a.className = "dropdown-item";
                    a.href = "#";
                    a.innerText = subCat;
                    a.onclick = function(e) {
                        e.preventDefault();
                        subCategoryInput.value = subCat;
                        document.querySelector("#subCategoryDropdownBtn span").innerText = subCat;
                    };
                    li.appendChild(a);
                    subCategoryList.appendChild(li);
                });
            }
        }
        
        // Add form validation to prevent submission if hidden inputs are empty
        document.querySelector("form").addEventListener("submit", function(e) {
            if(!document.getElementById("jobCategory").value || !document.getElementById("jobSubCategory").value) {
                e.preventDefault();
                alert("Please select both a Job Category and a Specific Job from the dropdown menus.");
            }
        });
    </script>
    </div>
</div>
</body>
</html>
