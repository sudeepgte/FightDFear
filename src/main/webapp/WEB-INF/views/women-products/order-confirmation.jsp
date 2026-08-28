<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Order confirmed — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&family=Montserrat:wght@800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    body { font-family: Inter, Poppins, sans-serif; background: #F8FAFC; margin: 0; color: var(--fdf-text); }
    .wrap { max-width: 760px; margin: 0 auto; padding: 36px 20px 64px; }
    .hero { text-align:center; margin-bottom: 24px; }
    .hero .ok-icon { width:72px;height:72px;border-radius:50%;background:#F0FDF4;color:#16A34A;display:inline-flex;align-items:center;justify-content:center;font-size:2rem;margin-bottom:12px; }
    .card { background: #fff; border: 1px solid #E2E8F0; border-radius: 20px; padding: 24px; box-shadow: 0 8px 24px rgba(30,27,75,.05); margin-bottom: 16px; }
    h1 { font-family: Montserrat, sans-serif; font-size: 1.55rem; color: #1E1B4B; margin: 8px 0; }
    .ok { color: #059669; font-weight: 800; }
    .btn-main { background: #F43F5E; color: #fff; }
    .btn-sec { background: #FFF1F2; color: #1E1B4B; }
    .ok { color: #059669; font-weight: 800; }
    .line { display: flex; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f3f4f6; }
    .line img { width: 64px; height: 64px; object-fit: cover; border-radius: 12px; }
    .btn { display: inline-flex; align-items: center; gap: 8px; padding: 12px 18px; border-radius: 12px; font-weight: 800; text-decoration: none; margin-right: 8px; margin-top: 12px; }
    .btn-main { background: var(--gradient-primary); color: #fff; }
    .btn-sec { background: #fdf2f8; color: var(--brand-purple); }
    @media (max-width: 600px) { .wrap { padding: 20px 12px 48px; } h1 { font-size: 1.3rem; } }
  </style>
</head>
<body class="wp-shop">
  <div class="wrap">
    <div class="hero">
      <div class="ok-icon"><i class="bi bi-check-lg"></i></div>
      <p class="ok">Order placed successfully</p>
      <h1>Thank you — your order is confirmed</h1>
      <p style="color:#64748B;">We’ve recorded your order. Track status anytime from My Orders.</p>
    </div>

    <c:forEach var="o" items="${orders}">
      <div class="card">
        <div style="font-size:12px;font-weight:700;color:var(--fdf-muted);">Order reference</div>
        <div style="font-weight:900;font-size:18px;margin-bottom:10px;">#${o.id}</div>
        <div class="line">
          <c:choose>
            <c:when test="${not empty o.product.publicImagePath}">
              <img src="<c:choose><c:when test="${o.product.remoteImage}">${o.product.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${o.product.publicImagePath}</c:otherwise></c:choose>" alt="">
            </c:when>
            <c:otherwise><div style="width:64px;height:64px;background:#fdf2f8;border-radius:12px;"></div></c:otherwise>
          </c:choose>
          <div>
            <div style="font-weight:800;"><c:out value="${o.product.name}"/></div>
            <div style="font-size:13px;color:var(--fdf-muted);">Qty ${o.quantity} · Status: <c:out value="${o.status}"/></div>
            <div style="font-size:13px;">Payment: <c:out value="${o.paymentMethod}"/> · <c:out value="${empty o.paymentStatus ? 'Recorded' : o.paymentStatus}"/></div>
            <c:if test="${not empty expectedDeliveryLabels[o.id]}">
              <div style="font-size:13px;color:#059669;font-weight:700;margin-top:4px;">Expected: ${expectedDeliveryLabels[o.id]}</div>
            </c:if>
          </div>
          <div style="margin-left:auto;font-weight:900;">&#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="2"/></div>
        </div>
      </div>
    </c:forEach>

    <div class="card">
      <div style="display:flex;justify-content:space-between;font-weight:800;">
        <span>Total</span>
        <span>&#8377;<fmt:formatNumber value="${orderTotal}" maxFractionDigits="2"/></span>
      </div>
      <a class="btn btn-main" href="${pageContext.request.contextPath}/women-products/my-orders"><i class="bi bi-geo-alt"></i> Track / View My Orders</a>
      <a class="btn btn-sec" href="${pageContext.request.contextPath}/women-products">Continue shopping</a>
    </div>
  </div>
  <jsp:include page="/WEB-INF/views/women-products/wp-footer.jsp" />
</body>
</html>
