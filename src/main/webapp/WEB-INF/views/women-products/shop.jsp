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
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    /* Page-local overrides only */
    body.wp-shop { overflow-x: hidden; }
    .product-category { font-size: 10px; font-weight: 800; color: #F43F5E; text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 4px; }
    .product-brand { font-size: 11px; font-weight: 600; color: #94a3b8; margin-bottom: 2px; }
    .product-name { font-size: 0.95rem; font-weight: 700; color: #0f172a; line-height: 1.35; min-height: 40px; margin: 0 0 6px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .product-seller { font-size: 0.75rem; color: #64748b; margin-bottom: 6px; display: flex; align-items: center; gap: 4px; flex-wrap: wrap; }
    .product-rating { font-size: 0.75rem; color: #d97706; font-weight: 700; margin-bottom: 6px; }
    .product-price { display: flex; flex-wrap: wrap; align-items: center; gap: 6px; margin-bottom: 10px; }
    .product-price .current { font-size: 1.05rem; font-weight: 800; color: #0f172a; }
    .product-price .original { font-size: 0.78rem; color: #94a3b8; text-decoration: line-through; }
    .product-price .discount { font-size: 0.68rem; font-weight: 800; background: #ffe4e6; color: #e11d48; padding: 2px 8px; border-radius: 999px; }
    .btn-shop { width: 100%; padding: 9px 8px; border-radius: 10px; font-size: 0.78rem; font-weight: 700; cursor: pointer; border: none; display: inline-flex; align-items: center; justify-content: center; gap: 4px; text-decoration: none; font-family: inherit; }
    .btn-shop-primary { background: #F43F5E; color: #fff; }
    .btn-shop-primary:hover { background: #E11D48; color: #fff; }
    .btn-shop-outline { background: #fff; color: #e11d48; border: 1px solid #fecdd3; }
    .btn-shop-outline:hover { background: #fff1f2; }
    .stock-badge { position: absolute; top: 10px; left: 10px; padding: 4px 10px; border-radius: 999px; font-size: 10px; font-weight: 800; z-index: 2; background: #fff; color: #15803d; }
    .stock-badge.low { background: #fff7ed; color: #c2410c; }
    .stock-badge.out { background: rgba(15,23,42,0.65); color: #fff; }
    .offer-badge { position: absolute; top: 10px; right: 44px; background: #F43F5E; color: #fff; padding: 3px 8px; border-radius: 6px; font-size: 10px; font-weight: 800; z-index: 2; }
    .product-img { width: 100%; height: 100%; object-fit: cover; }
    .product-img-placeholder { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: #fff1f2; font-size: 42px; color: #fda4af; }
    .product-img-wrapper { position: relative; overflow: hidden; display: block; text-decoration: none; color: inherit; }
    .wish-float { position: absolute; top: 10px; right: 10px; z-index: 3; }
    .wish-float button { width: 34px; height: 34px; border-radius: 50%; border: none; background: #fff; color: #F43F5E; box-shadow: 0 2px 8px rgba(0,0,0,0.12); cursor: pointer; }
    .empty-shop { text-align: center; padding: 48px 16px; color: #64748b; background: #fff; border: 1px solid #e2e8f0; border-radius: 14px; }
    .empty-shop i { font-size: 48px; color: #F43F5E; display: block; margin-bottom: 12px; }
  </style>
</head>
<body class="wp-shop">
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper" class="wp-shop-content" style="min-height: 100vh; overflow-x: hidden;">

    <div class="wp-shop-page">

      <div class="wp-shop-hero">
        <h1><i class="bi bi-bag-heart-fill"></i> Women Products</h1>
        <p>Empowering female entrepreneurs. Shop curated products designed for you.</p>
        <div class="wp-quick-nav">
          <a href="${pageContext.request.contextPath}/women-products" class="active"><i class="bi bi-shop"></i> Shop</a>
          <a href="${pageContext.request.contextPath}/women-products/wishlist"><i class="bi bi-heart"></i> Wishlist</a>
          <a href="${pageContext.request.contextPath}/women-products/cart"><i class="bi bi-cart3"></i> Cart</a>
          <a href="${pageContext.request.contextPath}/women-products/my-orders"><i class="bi bi-box-seam"></i> My Orders</a>
        </div>
      </div>

      <div class="wp-category-bar">
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

      <form class="wp-filter-toolbar" method="get" action="${pageContext.request.contextPath}/women-products">
        <c:if test="${not empty selectedCategory}"><input type="hidden" name="category" value="${fn:escapeXml(selectedCategory)}"></c:if>
        <div class="wp-search-row">
          <input type="search" name="q" value="${fn:escapeXml(searchQuery)}" placeholder="Search women products..." maxlength="80" aria-label="Search products">
          <button type="submit" class="wp-search-btn"><i class="bi bi-search"></i> Search</button>
        </div>
        <div class="wp-filter-grid">
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
          <h2><i class="bi bi-stars" style="color:#F43F5E;"></i> Featured Products</h2>
          <div class="products-grid">
            <c:forEach var="p" items="${featuredProducts}">
              <%@ include file="product-card.jsp" %>
            </c:forEach>
          </div>
        </div>
      </c:if>

      <c:if test="${empty products}">
        <div class="empty-shop">
          <i class="bi bi-bag-heart"></i>
          <h2>No products found</h2>
          <p>Try a different category or adjust your filters.</p>
        </div>
      </c:if>

      <div class="products-grid">
        <c:forEach var="p" items="${products}">
          <%@ include file="product-card.jsp" %>
        </c:forEach>
      </div>

      <%@ include file="wp-footer.jsp" %>

    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
