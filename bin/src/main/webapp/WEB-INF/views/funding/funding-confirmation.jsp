<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Application Submitted</title>
    
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
            min-height: 100vh;
        }
        
        .confirmation-container {
            max-width: 600px;
            margin: 80px auto;
            text-align: center;
            background: white;
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(124, 45, 94, 0.1);
            padding: 60px 40px;
        }
        
        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            font-size: 50px;
            color: white;
        }
        
        .btn-home {
            background: linear-gradient(135deg, var(--f-purple), var(--f-pink));
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 25px;
            font-weight: 700;
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(124, 45, 94, 0.4);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    
    <div class="container py-4">
        <div class="confirmation-container">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            <h1 class="text-dark mb-3">Application Submitted!</h1>
            <p class="text-muted mb-4">
                Thank you for applying for the funding scheme! Your application has been successfully submitted. We will review your application and get back to you soon.
            </p>
            <a href="${pageContext.request.contextPath}/funding" class="btn-home btn-lg">
                <i class="fas fa-home me-2"></i> Back to Funding Hub
            </a>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>