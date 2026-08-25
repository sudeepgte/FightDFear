<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Your Wishlist — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    :root {
      --wish-bg: #F8FAFC;
      --card-bg: #ffffff;
    }
    body {
      font-family: 'Poppins', sans-serif;
      background: var(--wish-bg);
      color: var(--fdf-text);
      min-height: 100vh;
    }
    .wish-hero {
      background: #fff;
      border-bottom: 1px solid var(--fdf-border);
      padding: 28px 20px 24px;
      margin-bottom: 8px;
    }
    .wish-hero-inner {
      max-width: 1100px;
      margin: 0 auto;
    }
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--brand-purple);
      text-decoration: none;
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 16px;
      padding: 8px 14px;
      background: #fff;
      border-radius: 999px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
      transition: all 0.25s ease;
    }
    .back-link:hover {
      background: var(--brand-purple);
      color: #fff;
    }
    .page-title {
      font-family: 'Montserrat', sans-serif;
      font-size: clamp(1.6rem, 3vw, 2rem);
      font-weight: 900;
      color: var(--brand-purple-darker);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .page-title i { color: var(--brand-pink); }
    .page-subtitle {
      margin: 8px 0 0;
      color: var(--fdf-muted);
      font-size: 0.95rem;
      font-weight: 500;
    }

    .wish-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 28px 20px 60px;
    }

    .wish-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
      gap: 24px;
    }
    .wish-card {
      background: var(--card-bg);
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      overflow: hidden;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      box-shadow: var(--shadow-sm);
      display: flex;
      flex-direction: column;
      height: 100%;
    }
    .wish-card:hover {
      transform: translateY(-6px);
      box-shadow: var(--shadow-lg);
      border-color: rgba(244, 63, 94, 0.35);
    }

    .wish-img-link {
      display: block;
      text-decoration: none;
      color: inherit;
    }
    .wish-img-wrapper {
      position: relative;
      height: 210px;
      overflow: hidden;
      background: #fdf2f8;
    }
    .wish-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.45s ease;
    }
    .wish-card:hover .wish-img { transform: scale(1.06); }
    .placeholder-icon {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #f9a8d4;
      font-size: 48px;
    }
    .wish-stock {
      position: absolute;
      top: 12px;
      left: 12px;
      padding: 5px 12px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      background: #fff;
      color: #10b981;
      box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    }
    .wish-stock.low { color: #c2410c; background: #fff7ed; }
    .wish-stock.out { color: #fff; background: rgba(0,0,0,0.65); }

    .wish-body {
      padding: 18px;
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .wish-category {
      font-size: 11px;
      font-weight: 800;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--brand-pink);
    }
    .wish-body .name {
      font-size: 16px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin: 0;
      min-height: 44px;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
    }
    .wish-body .name a {
      color: inherit;
      text-decoration: none;
    }
    .wish-body .name a:hover { color: var(--brand-pink); }
    .wish-seller {
      font-size: 12px;
      color: var(--fdf-muted);
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .wish-seller i { color: #F43F5E; }
    .wish-body .price {
      font-size: 20px;
      font-weight: 900;
      color: var(--brand-purple);
      margin: 4px 0 8px;
    }
    .wish-body .price .original {
      font-size: 13px;
      color: #94a3b8;
      text-decoration: line-through;
      font-weight: 600;
      margin-left: 8px;
    }

    .wish-actions {
      display: flex;
      gap: 10px;
      margin-top: auto;
      align-items: stretch;
    }
    .btn-wish-view {
      flex: 0 0 auto;
      padding: 10px 14px;
      background: #fdf2f8;
      color: var(--brand-purple);
      border: 1px solid var(--fdf-border);
      border-radius: 12px;
      font-size: 13px;
      font-weight: 700;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      transition: all 0.2s;
    }
    .btn-wish-view:hover {
      background: #fff;
      border-color: var(--brand-purple);
      color: var(--brand-purple);
    }
    .btn-wish-main {
      flex: 1;
      padding: 10px 12px;
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
      font-family: inherit;
    }
    .btn-wish-main:hover {
      filter: brightness(1.08);
    }
    .btn-wish-main:disabled {
      opacity: 0.55;
      cursor: not-allowed;
      filter: none;
    }
    .btn-wish-del {
      width: 42px;
      height: 42px;
      flex-shrink: 0;
      background: #fef2f2;
      color: #ef4444;
      border: 1px solid #fee2e2;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-wish-del:hover {
      background: #ef4444;
      color: #fff;
    }

    .empty-wishlist {
      text-align: center;
      padding: 80px 24px;
      background: #fff;
      border-radius: 24px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
      color: var(--fdf-muted);
    }
    .empty-wishlist i {
      font-size: 72px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 20px;
      display: block;
    }
    .empty-wishlist h2 {
      font-family: 'Montserrat', sans-serif;
      font-weight: 800;
      color: var(--brand-purple-darker);
      margin-bottom: 8px;
    }
    .empty-wishlist .btn-shop-cta {
      display: inline-flex;
      margin-top: 22px;
      padding: 12px 28px;
      border-radius: 14px;
      background: var(--gradient-primary);
      color: #fff;
      font-weight: 700;
      text-decoration: none;
      box-shadow: 0 8px 20px rgba(124, 45, 94, 0.2);
    }

    @media (max-width: 768px) {
      .wish-container { padding: 20px 14px 48px; }
      .wish-grid { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 14px; }
      .wish-img-wrapper { height: 160px; }
      .wish-body { padding: 14px; }
      .wish-body .name { font-size: 14px; min-height: 40px; }
      .wish-body .price { font-size: 16px; }
      .wish-actions { flex-wrap: wrap; }
      .btn-wish-view { flex: 1 1 100%; }
      .btn-wish-main { flex: 1; }
    }
  </style>
</head>
<body class="wp-shop">
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="wish-hero">
      <div class="wish-hero-inner">
        <a href="${pageContext.request.contextPath}/women-products" class="back-link">
          <i class="bi bi-arrow-left"></i> Back to Shop
        </a>
        <h1 class="page-title"><i class="bi bi-heart-fill"></i> Your Wishlist</h1>
        <p class="page-subtitle">
          <c:choose>
            <c:when test="${empty wishlistItems}">Saved favorites will appear here.</c:when>
            <c:otherwise>${wishlistItems.size()} saved item<c:if test="${wishlistItems.size() != 1}">s</c:if> ready for you.</c:otherwise>
          </c:choose>
        </p>
        <div class="wp-subnav" style="justify-content:flex-start;margin-top:14px;">
          <a href="${pageContext.request.contextPath}/women-products">Shop</a>
          <a class="active" href="${pageContext.request.contextPath}/women-products/wishlist">Wishlist</a>
          <a href="${pageContext.request.contextPath}/women-products/cart">Cart</a>
          <a href="${pageContext.request.contextPath}/women-products/my-orders">My Orders</a>
        </div>
      </div>
    </div>

    <div class="wish-container">
      <c:if test="${empty wishlistItems}">
        <div class="empty-wishlist">
          <i class="bi bi-heart"></i>
          <h2>Your wishlist is empty</h2>
          <p>Browse the shop and heart products you love — they’ll wait for you here.</p>
          <a href="${pageContext.request.contextPath}/women-products" class="btn-shop-cta">Start Shopping</a>
        </div>
      </c:if>

      <c:if test="${not empty wishlistItems}">
        <div class="wish-grid">
          <c:forEach var="w" items="${wishlistItems}">
            <article class="wish-card">
              <a href="${pageContext.request.contextPath}/women-products/view/${w.product.id}" class="wish-img-link">
                <div class="wish-img-wrapper">
                  <c:choose>
                    <c:when test="${not empty w.product.publicImagePath}">
                      <img src="<c:choose><c:when test="${w.product.remoteImage}">${w.product.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${w.product.publicImagePath}</c:otherwise></c:choose>" class="wish-img" alt="<c:out value='${w.product.name}'/>">
                    </c:when>
                    <c:otherwise>
                      <div class="placeholder-icon"><i class="bi bi-gift"></i></div>
                    </c:otherwise>
                  </c:choose>
                  <c:choose>
                    <c:when test="${w.product.stock == null || w.product.stock <= 0}">
                      <span class="wish-stock out">Out of Stock</span>
                    </c:when>
                    <c:when test="${w.product.lowStockAlertLevel != null && w.product.stock <= w.product.lowStockAlertLevel}">
                      <span class="wish-stock low">Only ${w.product.stock} left</span>
                    </c:when>
                    <c:otherwise>
                      <span class="wish-stock">In Stock</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </a>

              <div class="wish-body">
                <div class="wish-category">${w.product.categoryLabel}</div>
                <h3 class="name">
                  <a href="${pageContext.request.contextPath}/women-products/view/${w.product.id}"><c:out value="${w.product.name}"/></a>
                </h3>
                <c:if test="${not empty w.product.seller}">
                  <div class="wish-seller"><i class="bi bi-patch-check-fill"></i> ${w.product.seller.businessName}</div>
                </c:if>
                <div class="price">
                  &#8377;${w.product.price}
                  <c:if test="${w.product.discountPercent > 0}">
                    <span class="original">&#8377;${w.product.originalPrice}</span>
                    <span class="discount" style="font-size:11px;font-weight:800;color:#ef4444;margin-left:6px;">${w.product.discountPercent}% OFF</span>
                  </c:if>
                </div>

                <div class="wish-actions">
                  <a href="${pageContext.request.contextPath}/women-products/view/${w.product.id}" class="btn-wish-view" title="View product">
                    <i class="bi bi-eye"></i> View
                  </a>
                  <form action="${pageContext.request.contextPath}/women-products/cart/add" method="post" style="flex: 1; display: flex;">
                    <input type="hidden" name="productId" value="${w.product.id}">
                    <button type="submit" class="btn-wish-main" ${w.product.stock == null || w.product.stock <= 0 ? 'disabled' : ''}>
                      <i class="bi bi-cart-plus"></i> Add to Cart
                    </button>
                  </form>
                  <form action="${pageContext.request.contextPath}/women-products/wishlist/toggle" method="post">
                    <input type="hidden" name="productId" value="${w.product.id}">
                    <input type="hidden" name="returnTo" value="wishlist">
                    <button type="submit" class="btn-wish-del" title="Remove from wishlist">
                      <i class="bi bi-trash3"></i>
                    </button>
                  </form>
                </div>
              </div>
            </article>
          </c:forEach>
        </div>
      </c:if>
    </div>

    <jsp:include page="/WEB-INF/views/women-products/wp-footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  </div>
</div>
</body>
</html>
