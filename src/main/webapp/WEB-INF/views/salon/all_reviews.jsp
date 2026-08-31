<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>All Salon Reviews</title>

    <!-- ================= BOOTSTRAP & FONTS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">

    <!-- ================= ICONS ================= -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- ================= THEME CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root { 
            --sidebar-width: 280px; 
            --dashboard-bg: #F8FAFC;
            --primary-accent: #F43F5E;
            --secondary-subtext: #64748B;
            --card-bg: #FFFFFF;
            --border-color: #E2E8F0;
            --text-main: #0F172A;
        }

        body { 
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg); 
            color: var(--text-main); 
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar */
        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 4px 0 24px rgba(0,0,0,0.04);
                background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }
        
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: var(--primary-accent); color: white; transform: translateX(5px); }

        .main-content {
            background-color: var(--dashboard-bg);
            min-height: 100vh;
            padding: 40px;
        }
        
        .review-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid var(--border-color);
        }
        .review-card h5 { color: var(--text-main); font-weight: 700; }
        .review-card p { color: var(--secondary-subtext); line-height: 1.6; }
        .stars i { color: #FBBF24; }
        .btn-purple { background-color: var(--primary-accent) !important; color: white !important; border: none; font-weight: 600; padding: 10px 20px; border-radius: 8px; }
        .btn-purple:hover { background-color: #E11D48 !important; }
        .btn-secondary { background-color: var(--secondary-subtext) !important; color: white !important; border: none; font-weight: 600; padding: 10px 20px; border-radius: 8px; }
        .btn-secondary:hover { background-color: #475569 !important; }
        
        .header-title { color: var(--text-main) !important; font-weight: 800 !important; }
    </style>
</head>
<body>
 
<jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="reviews"/>
</jsp:include>

<div class="main-content">
    <div class="container-fluid">
        <h2 class="text-center mb-4 header-title">
            <i class="fas fa-comments"></i> All Salon Reviews
        </h2>

        <!-- Success Message -->
        <c:if test="${not empty msg}">
        <div class="alert alert-success text-center">${msg}</div>
    </c:if>
 
    <!-- No Reviews -->
    <c:if test="${empty reviews}">
        <div class="alert alert-warning text-center">No reviews available yet!</div>
    </c:if>
 
    <!-- Reviews List -->
    <c:forEach var="review" items="${reviews}">
        <div class="review-card">
            <h5>${review.userName}</h5>
            <div class="stars">
                <c:forEach begin="1" end="${review.rating}">
                    <i class="fas fa-star"></i>
                </c:forEach>
                <c:forEach begin="${review.rating + 1}" end="5">
                    <i class="far fa-star"></i>
                </c:forEach>
            </div>
            <p class="mt-2">${review.comment}</p>
            <small class="text-muted">
                <i class="far fa-clock"></i>
                ${review.createdAt}
            </small>
 
            <!-- Reply Section -->
         <%--    <c:choose>
                <c:when test="${not empty review.reply}">
                    <div class="reply-box mt-3">
                        <strong>Reply:</strong> ${review.reply} <br>
                        <small class="text-muted">Replied on: ${review.repliedAt}</small>
                    </div>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/salon/reviews/reply" method="post" class="mt-3">
                    
                        <input type="hidden" name="reviewId" value="${review.id}">
                        <textarea name="replyText" rows="2" class="form-control mb-2"
                                  placeholder="Write a reply..." required></textarea>
                        <button type="submit" class="btn btn-purple btn-sm">
                            <i class="fas fa-paper-plane"></i> Reply
                        </button>
                    </form>
                </c:otherwise>
            </c:choose> --%>
        </div>
    </c:forEach>
 
    <!-- Go Back -->
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Go Back
        </a>
    </div>
</div>
 


    </div>
</div>
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
 
</body>
</html>
 


