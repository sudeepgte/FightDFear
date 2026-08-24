<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Pricing Treatments | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Prata&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/beauty/css/style.css">

    <style>
        #header {
            background: #7d265a !important;
            box-shadow: 0 2px 15px rgba(0,0,0,0.2);
        }
        #header .logo h1, #header .navmenu a { color: #fff !important; }
        .pricing-hero {
            background: linear-gradient(rgba(106, 13, 173, 0.4), rgba(0, 0, 0, 0.7)),
                        url('${pageContext.request.contextPath}/beauty/images/bg_2.jpg');
            background-size: cover;
            background-position: center;
            padding: 150px 0 100px;
            color: white;
            text-align: center;
        }
        .block-7 {
            background: #fff;
            margin-bottom: 30px;
            padding: 40px 20px 80px;
            position: relative;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
            height: 100%;
        }
        .block-7 .price .number { font-size: 2.5rem; font-weight: 700; color: #7d265a; }
        .block-7 .price sup { color: #7d265a; font-size: 1.25rem; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/index-beauty-header.jsp" />

    <div class="pricing-hero">
        <div class="container">
            <h1 class="display-4 fw-bold">Pricing Treatments</h1>
            <p class="lead">Transparent Indian Rupee pricing for every treatment plan.</p>
        </div>
    </div>

    <section class="ftco-section bg-light">
        <div class="container">
            <div class="row justify-content-center mb-5 pb-3">
                <div class="col-md-7 heading-section text-center">
                    <h3 class="subheading">Pricing Tables</h3>
                    <h2 class="mb-1">Pricing Treatments</h2>
                </div>
            </div>

            <div class="row">
                <c:choose>
                    <c:when test="${not empty treatments}">
                        <c:forEach var="treatment" items="${treatments}">
                            <div class="col-md-4 mb-4">
                                <div class="block-7">
                                    <div class="text-center">
                                        <h2 class="heading">${treatment.serviceName}</h2>
                                        <span class="price">
                                            <sup>&#8377;</sup>
                                            <span class="number">
                                                <fmt:formatNumber value="${treatment.price}" type="number" maxFractionDigits="0"/>
                                            </span>
                                        </span>
                                        <span class="excerpt d-block">
                                            <c:out value="${treatment.duration}"/> mins session
                                        </span>
                                        <h3 class="heading-2 my-4">Treatment Details</h3>
                                        <ul class="pricing-text mb-5 text-start mx-auto" style="max-width: 260px;">
                                            <li><c:out value="${treatment.description}"/></li>
                                            <c:if test="${not empty treatment.salon}">
                                                <li>Salon: <c:out value="${treatment.salon.name}"/></li>
                                            </c:if>
                                        </ul>
                                        <a href="${pageContext.request.contextPath}/booking/new?treatmentId=${treatment.id}"
                                           class="btn btn-primary d-block px-2 py-3">Get Started</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center">
                            <p class="text-muted">No treatments are listed yet. Browse salons to explore available plans.</p>
                            <a href="${pageContext.request.contextPath}/user/salons" class="btn btn-primary">Explore Salons</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
