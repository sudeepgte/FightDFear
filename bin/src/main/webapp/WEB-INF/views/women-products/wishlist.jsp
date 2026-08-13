<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Your Wishlist — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: #fffcfd;
      color: var(--fdf-text);
      min-height: 100vh;
    }
    .wish-container {
      max-width: 1000px;
      margin: 0 auto;
      padding: 40px 20px;
    }
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      color: var(--brand-purple);
      text-decoration: none;
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 30px;
      transition: all 0.3s ease;
      padding: 8px 16px;
      background: #fff;
      border-radius: 999px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
    }
    .back-link:hover {
      background: var(--brand-purple);
      color: #fff;
      transform: translateX(-5px);
    }
    .page-title {
      font-family: 'Montserrat', sans-serif;
      font-size: 32px;
      font-weight: 900;
      color: var(--brand-purple-darker);
      margin-bottom: 30px;
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .page-title i { color: var(--brand-pink); }

    .wish-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
      gap: 20px;
    }
    .wish-card {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: var(--shadow-sm);
      display: flex;
      flex-direction: column;
    }
    .wish-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--shadow-lg);
      border-color: var(--brand-pink-light);
    }
    
    .wish-img-wrapper {
      position: relative;
      height: 200px;
      overflow: hidden;
    }
    .wish-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }
    .wish-card:hover .wish-img {
      transform: scale(1.1);
    }
    .placeholder-icon {
      width: 100%;
      height: 100%;
      background: #fdf2f8;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--brand-pink-light);
      font-size: 48px;
    }

    .wish-body {
      padding: 18px;
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .wish-body .name {
      font-size: 16px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin-bottom: 6px;
      height: 48px;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
    }
    .wish-body .price {
      font-size: 18px;
      font-weight: 900;
      color: var(--brand-purple);
      margin-bottom: 18px;
    }

    .wish-actions {
      display: flex;
      gap: 10px;
      margin-top: auto;
    }
    .btn-wish-main {
      flex: 1;
      padding: 10px;
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 13px;
      font-weight: 700;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-wish-main:hover {
      filter: brightness(1.1);
      transform: scale(1.02);
    }
    .btn-wish-del {
      width: 40px;
      height: 40px;
      background: #fef2f2;
      color: #ef4444;
      border: 1px solid #fee2e2;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-wish-del:hover {
      background: #ef4444;
      color: #fff;
    }

    .empty-wishlist {
      text-align: center;
      padding: 100px 20px;
      color: var(--fdf-muted);
    }
    .empty-wishlist i {
      font-size: 80px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 24px;
      display: block;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
  <div class="wish-container">
    <a href="${pageContext.request.contextPath}/women-products" class="back-link">
      <i class="bi bi-arrow-left"></i> Back to Shop
    </a>
    
    <div class="page-title"><i class="bi bi-heart-fill"></i> Your Wishlist</div>

    <c:if test="${empty wishlistItems}">
      <div class="empty-wishlist">
        <i class="bi bi-emoji-smile"></i>
        <h2>Your wishlist is breathing...</h2>
        <p>Save products you love and they'll wait for you here!</p>
        <a href="${pageContext.request.contextPath}/women-products" class="btn btn-fdf mt-4" style="padding: 12px 30px; text-decoration: none;">Start Browsing</a>
      </div>
    </c:if>

    <div class="wish-grid">
      <c:forEach var="w" items="${wishlistItems}">
        <div class="wish-card">
          <div class="wish-img-wrapper">
            <c:choose>
              <c:when test="${not empty w.product.imagePath}">
                <img src="${pageContext.request.contextPath}${w.product.imagePath}" class="wish-img" alt="${w.product.name}">
              </c:when>
              <c:otherwise>
                <div class="placeholder-icon"><i class="bi bi-gift"></i></div>
              </c:otherwise>
            </c:choose>
          </div>
          
          <div class="wish-body">
            <div class="name">${w.product.name}</div>
            <div class="price">&#8377;${w.product.price}</div>
            <div class="wish-actions">
              <form action="${pageContext.request.contextPath}/women-products/cart/add" method="post" style="flex: 1;">
                <input type="hidden" name="productId" value="${w.product.id}">
                <button type="submit" class="btn-wish-main">
                  <i class="bi bi-cart-plus"></i> Add to Cart
                </button>
              </form>
              <form action="${pageContext.request.contextPath}/women-products/wishlist/toggle" method="post">
                <input type="hidden" name="productId" value="${w.product.id}">
                <button type="submit" class="btn-wish-del" title="Remove">
                  <i class="bi bi-trash3"></i>
                </button>
              </form>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </div>
</div>
</body>
</html>


