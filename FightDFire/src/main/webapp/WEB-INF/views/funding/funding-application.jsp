<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Funding Application</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --f-purple: #7C2D5E;
            --f-pink: #DB2777;
            --f-bg: #fffcfd;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--f-bg);
        }
        
        .form-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(124, 45, 94, 0.1);
            padding: 40px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-header h1 {
            color: var(--f-purple);
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
        }
        
        .form-label {
            color: var(--f-purple);
            font-weight: 600;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 25px;
            font-weight: 700;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(124, 45, 94, 0.4);
        }
        
        .back-btn {
            color: var(--f-purple);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    
    <div class="container py-4">
        <a href="${pageContext.request.contextPath}/funding" class="back-btn mb-4">
            <i class="bi bi-arrow-left"></i> Back to Funding Hub
        </a>
        
        <div class="form-container">
            <div class="form-header">
                <h1>Apply for Funding Scheme</h1>
                <p class="text-muted mt-2">Fill out the form below to apply for the funding scheme</p>
            </div>
            
            <form>
                <div class="mb-4">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" placeholder="Enter your full name">
                </div>
                
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-control" placeholder="Enter your email">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" placeholder="Enter your phone number">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Address</label>
                    <textarea class="form-control" rows="3" placeholder="Enter your address"></textarea>
                </div>
                
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Aadhaar Number</label>
                        <input type="text" class="form-control" placeholder="Enter Aadhaar number">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">PAN Number</label>
                        <input type="text" class="form-control" placeholder="Enter PAN number">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Select Funding Scheme</label>
                    <select class="form-control">
                        <option>PM Mudra Yojana</option>
                        <option>Stand-Up India</option>
                        <option>Mahila Samriddhi Yojana</option>
                        <option>PMEGP</option>
                        <option>Annapurna Scheme</option>
                        <option>Udyogini Scheme</option>
                        <option>Stree Shakti Package</option>
                        <option>Bharatiya Mahila Bank</option>
                    </select>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Business Type</label>
                    <input type="text" class="form-control" placeholder="Enter your business type">
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Loan Amount Required</label>
                    <input type="number" class="form-control" placeholder="Enter amount in INR">
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Business Description</label>
                    <textarea class="form-control" rows="5" placeholder="Describe your business and purpose of loan"></textarea>
                </div>
                
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/funding/confirmation" class="btn-submit btn-lg">
                        <i class="fas fa-paper-plane me-2"></i> Submit Application
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>