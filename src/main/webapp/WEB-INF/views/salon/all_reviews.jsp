<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Add Offer | Fight D Fear</title>

    <!-- ================= BOOTSTRAP ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">

    <!-- ================= GOOGLE FONTS ================= -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600;700&display=swap" rel="stylesheet">

    <!-- ================= ICONS ================= -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/open-iconic-bootstrap.min.css">

    <!-- ================= THEME CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/aos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/ionicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/jquery.timepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/icomoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <!-- ================= PROJECT CSS ================= -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">

    <title>All Salon Reviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
     
        

        

        .offer-form {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 600px;
            margin: 0 auto 60px;
        }

        .strike { text-decoration: line-through; color: #888; }
        .final-price { color: #28a745; font-weight: bold; }
  
     
        
        .review-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .stars i {
            color: #f8d03e;
        }
        .reply-box {
            margin-top: 15px;
            background: #f1f1f1;
            border-radius: 8px;
            padding: 10px;
        }
        .btn-purple { background-color: var(--fdf-pink) !important; color: white !important; border: none; }
        .btn-purple:hover { background-color: var(--fdf-rose) !important; }
    </style>

    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">
</head>
<body>
 
 
<div class="d-flex">
    <jsp:include page="../fragments/salon-sidebar.jsp">
        <jsp:param name="activeNav" value="reviews"/>
    </jsp:include>
    <div class="main-content w-100">
        <div class="container mt-5">
    <h2 class="text-center mb-4 header-title" style="color: var(--fdf-text-dark); font-weight: 700;">
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
 


