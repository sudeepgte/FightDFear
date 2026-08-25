<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Women Products — Fight D Fear Shop</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <style>
    :root {
      --shop-bg: #fffcfd;
      --card-bg: #ffffff;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background: var(--shop-bg);
      color: var(--fdf-text);
      overflow-x: hidden;
    }

    /* Background blobs for premium feel */
    .shop-bg-layer {
      position: fixed;
      top: 0; left: 0; width: 100%; height: 100%;
      z-index: -1;
      overflow: hidden;
      pointer-events: none;
    }
    .blob {
      position: absolute;
      width: 500px; height: 500px;
      border-radius: 50%;
      filter: blur(80px);
      opacity: 0.15;
      animation: floatBlob 20s infinite alternate;
    }
    .blob-1 { top: -100px; right: -100px; background: var(--brand-purple); }
    .blob-2 { bottom: -150px; left: -150px; background: var(--brand-pink); animation-delay: -5s; }
    @keyframes floatBlob {
      0% { transform: translate(0, 0) scale(1); }
      100% { transform: translate(40px, 30px) scale(1.1); }
    }

    .shop-header {
      padding: 60px 20px 40px;
      text-align: center;
      background: white;
      border-bottom: 1px solid var(--fdf-border);
      position: relative;
    }
    .shop-header h1 {
      font-family: 'Montserrat', sans-serif;
      font-size: 38px;
      font-weight: 900;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 8px;
    }
    .shop-header p {
      color: var(--fdf-muted);
      font-size: 15px;
      max-width: 600px;
      margin: 0 auto;
    }

    .top-bar {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      padding: 16px 30px;
      position: absolute;
      top: 0; right: 0;
      width: 100%;
    }
    .top-btn {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      border-radius: 999px;
      background: #fff;
      border: 1px solid var(--fdf-border);
      color: var(--brand-purple);
      text-decoration: none;
      font-size: 13px;
      font-weight: 700;
      transition: all 0.3s ease;
      box-shadow: var(--shadow-sm);
    }
    .top-btn:hover {
      background: var(--brand-purple);
      color: #fff;
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
    }

    .shop-nav {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 30px;
      flex-wrap: wrap;
    }
    .shop-nav a {
      padding: 10px 24px;
      border-radius: 999px;
      background: #fff;
      border: 1px solid var(--fdf-border);
      color: var(--fdf-muted);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
      transition: all 0.3s;
    }
    .shop-nav a:hover, .shop-nav a.active {
      background: var(--gradient-primary);
      color: #fff;
      border-color: transparent;
      box-shadow: 0 4px 15px rgba(124, 45, 94, 0.2);
    }

    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 24px;
      padding: 40px 20px;
      max-width: 1200px;
      margin: 0 auto;
    }
    .product-card {
      background: var(--card-bg);
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      overflow: hidden;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      box-shadow: var(--shadow-sm);
    }
    .product-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--shadow-lg);
      border-color: var(--brand-pink-light);
    }
    .product-img-wrapper {
      position: relative;
      overflow: hidden;
      height: 240px;
    }
    .product-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }
    .product-card:hover .product-img {
      transform: scale(1.08);
    }
    .product-img-placeholder {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #fdf2f8, #f5f3ff);
      font-size: 60px;
      color: var(--brand-pink-light);
    }

    .product-body {
      padding: 20px;
    }
    .product-category {
      font-size: 11px;
      font-weight: 800;
      color: var(--brand-pink);
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 6px;
    }
    .product-name {
      font-size: 17px;
      font-weight: 800;
      color: var(--brand-purple);
      margin: 4px 0 8px;
      line-height: 1.3;
      height: 44px;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }
    .product-seller {
      font-size: 12px;
      color: var(--fdf-muted);
      margin-bottom: 16px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .product-price {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
    }
    .product-price .current {
      font-size: 20px;
      font-weight: 900;
      color: var(--brand-purple-dark);
    }
    .product-price .original {
      font-size: 13px;
      color: #9ca3af;
      text-decoration: line-through;
    }
    .product-price .discount {
      font-size: 11px;
      font-weight: 800;
      background: #fee2e2;
      color: #ef4444;
      padding: 3px 10px;
      border-radius: 999px;
    }

    .product-actions {
      display: flex;
      gap: 10px;
    }
    .btn-shop {
      flex: 1;
      padding: 12px;
      border-radius: 12px;
      font-size: 13px;
      font-weight: 700;
      cursor: pointer;
      border: none;
      transition: all 0.2s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      text-decoration: none;
    }
    .btn-shop-primary {
      background: var(--gradient-primary);
      color: #fff;
    }
    .btn-shop-primary:hover {
      filter: brightness(1.1);
      transform: scale(1.02);
    }
    .btn-shop-outline {
      background: #fdf2f8;
      color: var(--brand-purple);
      border: 1px solid var(--fdf-border);
    }
    .btn-shop-outline:hover {
      background: #fff;
      border-color: var(--brand-purple);
    }

    .stock-badge {
      position: absolute;
      top: 15px;
      left: 15px;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      z-index: 2;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .stock-badge.in { background: #fff; color: #10b981; }
    .stock-badge.low {
      background: #fff7ed;
      color: #c2410c;
      border: 1px solid #fdba74;
    }
    .stock-badge.out { background: rgba(0,0,0,0.6); color: #fff; backdrop-filter: blur(4px); }

    .offer-badge {
      position: absolute;
      top: 15px;
      right: 15px;
      background: var(--brand-pink);
      color: #fff;
      padding: 4px 12px;
      border-radius: 8px;
      font-size: 11px;
      font-weight: 900;
      z-index: 2;
      text-transform: uppercase;
      letter-spacing: 1px;
      box-shadow: 0 4px 10px rgba(219, 39, 119, 0.4);
    }

    .empty-shop {
      text-align: center;
      padding: 100px 20px;
      color: var(--fdf-muted);
    }
    .empty-shop i {
      font-size: 72px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 24px;
      display: block;
    }
    .shop-toolbar {
      max-width: 1200px;
      margin: 24px auto 0;
      padding: 0 20px;
    }
    .shop-search-row {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-bottom: 14px;
    }
    .shop-search-row input[type="search"] {
      flex: 1;
      min-width: 180px;
      padding: 12px 16px;
      border-radius: 14px;
      border: 1px solid var(--fdf-border);
      font-family: inherit;
      font-size: 14px;
    }
    .shop-filters {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
      gap: 10px;
    }
    .shop-filters select {
      width: 100%;
      padding: 10px 12px;
      border-radius: 12px;
      border: 1px solid var(--fdf-border);
      font-family: inherit;
      font-size: 13px;
      background: #fff;
    }
    .featured-wrap {
      max-width: 1200px;
      margin: 28px auto 0;
      padding: 0 20px;
    }
    .featured-wrap h2 {
      font-family: 'Montserrat', sans-serif;
      font-size: 20px;
      font-weight: 800;
      color: var(--brand-purple-darker);
      margin: 0 0 14px;
    }
    .wish-float {
      position: absolute;
      top: 12px;
      right: 12px;
      z-index: 3;
    }
    .wish-float button {
      width: 38px; height: 38px; border-radius: 50%;
      border: none; background: #fff; color: var(--brand-pink);
      box-shadow: 0 4px 12px rgba(0,0,0,0.12); cursor: pointer;
    }
    .product-brand { font-size: 12px; font-weight: 700; color: var(--fdf-muted); margin-bottom: 4px; }
    .product-rating { font-size: 12px; color: #d97706; font-weight: 700; margin-bottom: 8px; }
    .product-price { flex-wrap: wrap; }

    @media (max-width: 768px) {
      .shop-header { padding-top: 20px; padding-bottom: 20px; }
      .top-bar { 
          position: relative; 
          justify-content: center; 
          padding: 10px; 
          flex-wrap: wrap; 
          gap: 8px;
          margin-bottom: 20px;
      }
      .top-btn {
          padding: 8px 12px;
          font-size: 12px;
          margin-right: 0 !important;
      }
      .shop-header h1 { font-size: 28px; }
      .shop-nav { gap: 8px; margin-top: 20px; }
      .shop-nav a { padding: 8px 16px; font-size: 12px; }
      .products-grid {
          grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
          gap: 15px;
          padding: 20px 10px;
      }
      .product-img-wrapper { height: 160px; }
      .product-body { padding: 12px; }
      .product-name { font-size: 14px; height: 38px; margin-bottom: 5px; }
      .product-price { margin-bottom: 12px; flex-wrap: wrap; gap: 5px; }
      .product-price .current { font-size: 16px; }
      .product-price .original { font-size: 12px; }
      .btn-shop { padding: 8px; font-size: 11px; }
      .stock-badge, .offer-badge { padding: 4px 8px; font-size: 9px; top: 10px; }
      .stock-badge { left: 10px; }
      .offer-badge { right: 10px; }
      .wish-float { top: 8px; right: 8px; }
      .product-actions { flex-direction: column; }
      .shop-toolbar { padding: 0 10px; }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

  <div class="shop-bg-layer">
    <div class="blob blob-1"></div>
    <div class="blob blob-2"></div>
  </div>

  <div class="shop-header">
    <div class="top-bar">
      <a href="${pageContext.request.contextPath}/women-products/wishlist" class="top-btn"><i class="bi bi-heart"></i> Wishlist</a>
      <a href="${pageContext.request.contextPath}/women-products/cart" class="top-btn"><i class="bi bi-cart3"></i> Cart</a>
      <a href="${pageContext.request.contextPath}/women-products/my-orders" class="top-btn"><i class="bi bi-box-seam"></i> Orders</a>
    </div>
    
    <h1>Women Products</h1>
    <p>Empowering female entrepreneurs and creators. Shop the finest, curated products designed for you.</p>
    
    <div class="shop-nav">
      <a href="${pageContext.request.contextPath}/women-products" class="${empty selectedCategory ? 'active' : ''}">All Collections</a>
      <c:forEach var="code" items="${categoryCodes}">
        <a href="${pageContext.request.contextPath}/women-products?category=${code}" class="${selectedCategory == code ? 'active' : ''}">
          <c:choose>
            <c:when test="${code == 'SKINCARE'}">Skincare</c:when>
            <c:when test="${code == 'HAIRCARE'}">Haircare</c:when>
            <c:when test="${code == 'HYGIENE'}">Hygiene</c:when>
            <c:when test="${code == 'CLOTHING'}">Clothing</c:when>
            <c:when test="${code == 'ACCESSORIES'}">Accessories</c:when>
            <c:when test="${code == 'WELLNESS'}">Wellness</c:when>
            <c:otherwise>Other</c:otherwise>
          </c:choose>
        </a>
      </c:forEach>
    </div>
  </div>

  <form class="shop-toolbar" method="get" action="${pageContext.request.contextPath}/women-products">
    <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${fn:escapeXml(selectedCategory)}"></c:if>
    <div class="shop-search-row">
      <input type="search" name="q" value="${fn:escapeXml(searchQuery)}" placeholder="Search women products..." maxlength="80" aria-label="Search products">
      <button type="submit" class="top-btn" style="position:static;"><i class="bi bi-search"></i> Search</button>
    </div>
    <div class="shop-filters">
      <select name="price" onchange="this.form.submit()" aria-label="Price">
        <option value="">Any price</option>
        <option value="under500" ${selectedPrice == 'under500' ? 'selected' : ''}>Under ₹500</option>
        <option value="500-1000" ${selectedPrice == '500-1000' ? 'selected' : ''}>₹500–₹1,000</option>
        <option value="1000-2000" ${selectedPrice == '1000-2000' ? 'selected' : ''}>₹1,000–₹2,000</option>
        <option value="2000plus" ${selectedPrice == '2000plus' ? 'selected' : ''}>₹2,000+</option>
      </select>
      <select name="rating" onchange="this.form.submit()" aria-label="Rating">
        <option value="">Any rating</option>
        <option value="4" ${selectedRating == '4' ? 'selected' : ''}>4★ and up</option>
        <option value="3" ${selectedRating == '3' ? 'selected' : ''}>3★ and up</option>
      </select>
      <select name="stock" onchange="this.form.submit()" aria-label="Stock">
        <option value="">All stock</option>
        <option value="in" ${selectedStock == 'in' ? 'selected' : ''}>In stock</option>
        <option value="out" ${selectedStock == 'out' ? 'selected' : ''}>Out of stock</option>
      </select>
      <select name="brand" onchange="this.form.submit()" aria-label="Brand">
        <option value="">All brands</option>
        <c:forEach var="b" items="${availableBrands}">
          <option value="${fn:escapeXml(b)}" ${selectedBrand == b ? 'selected' : ''}><c:out value="${b}"/></option>
        </c:forEach>
      </select>
      <select name="sort" onchange="this.form.submit()" aria-label="Sort">
        <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Newest</option>
        <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
        <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
        <option value="rating" ${selectedSort == 'rating' ? 'selected' : ''}>Highest Rated</option>
        <option value="discount" ${selectedSort == 'discount' ? 'selected' : ''}>Biggest Discount</option>
      </select>
    </div>
  </form>

  <c:if test="${not empty featuredProducts}">
    <div class="featured-wrap">
      <h2>Featured Products</h2>
      <div class="products-grid" style="padding:0;">
        <c:forEach var="p" items="${featuredProducts}">
          <c:set var="p" value="${p}" scope="request"/>
          <jsp:include page="/WEB-INF/views/women-products/product-card.jsp"/>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <c:if test="${empty products}">
    <div class="empty-shop">
      <i class="bi bi-bag-heart"></i>
      <h2>The shop is quiet right now</h2>
      <p>We're curating new amazing products for you. Please check back soon!</p>
    </div>
  </c:if>

  <div class="products-grid">
    <c:forEach var="p" items="${products}">
      <c:set var="p" value="${p}" scope="request"/>
      <jsp:include page="/WEB-INF/views/women-products/product-card.jsp"/>
    </c:forEach>
  </div>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </div>
</div>
</body>
</html>


