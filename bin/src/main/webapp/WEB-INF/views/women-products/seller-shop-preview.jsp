<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Shop Preview — ${seller.businessName}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <style>
    :root {
      --shop-bg: #fffcfd;
      --card-bg: #ffffff;
      --brand-purple: #1e1b4b;
      --brand-pink: #f43f5e;
      --fdf-border: #f1f3f5;
      --fdf-text: #1e293b;
      --fdf-muted: #64748b;
      --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
    }
    * { box-sizing: border-box; }
    body {
      font-family: 'Poppins', sans-serif;
      background: var(--shop-bg);
      color: var(--fdf-text);
      margin: 0;
      min-height: 100vh;
    }
    .preview-bar {
      background: var(--brand-purple);
      color: #fff;
      padding: 14px 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      flex-wrap: wrap;
    }
    .preview-bar strong { font-weight: 800; }
    .preview-bar a {
      color: #fff;
      text-decoration: none;
      font-weight: 700;
      font-size: 0.9rem;
      padding: 8px 16px;
      border-radius: 999px;
      background: rgba(255,255,255,0.15);
    }
    .preview-bar a:hover { background: rgba(255,255,255,0.25); }
    .shop-header {
      padding: 48px 20px 32px;
      text-align: center;
      background: white;
      border-bottom: 1px solid var(--fdf-border);
    }
    .shop-header h1 {
      font-family: 'Montserrat', sans-serif;
      font-size: 34px;
      font-weight: 900;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin: 0 0 8px;
    }
    .shop-header p { color: var(--fdf-muted); margin: 0 auto; max-width: 560px; }
    .shop-nav {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-top: 24px;
      flex-wrap: wrap;
    }
    .shop-nav a {
      padding: 8px 18px;
      border-radius: 999px;
      background: #fff;
      border: 1px solid var(--fdf-border);
      color: var(--fdf-muted);
      text-decoration: none;
      font-size: 13px;
      font-weight: 600;
    }
    .shop-nav a.active, .shop-nav a:hover {
      background: var(--gradient-primary);
      color: #fff;
      border-color: transparent;
    }
    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
      gap: 22px;
      padding: 36px 20px;
      max-width: 1200px;
      margin: 0 auto;
    }
    .product-card {
      background: var(--card-bg);
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 4px 14px rgba(0,0,0,0.04);
    }
    .product-img-wrapper { display: block; height: 200px; background: #f8fafc; position: relative; text-decoration: none; color: inherit; }
    .product-img { width: 100%; height: 100%; object-fit: cover; }
    .product-img-placeholder { height: 100%; display: flex; align-items: center; justify-content: center; font-size: 48px; color: #cbd5e1; }
    .product-body { padding: 16px; }
    .product-category { font-size: 11px; font-weight: 800; text-transform: uppercase; color: var(--brand-pink); letter-spacing: 0.06em; }
    .product-name { font-weight: 700; margin: 6px 0 4px; min-height: 40px; }
    .product-seller { font-size: 12px; color: var(--fdf-muted); margin-bottom: 10px; }
    .product-price .current { font-size: 18px; font-weight: 800; color: var(--brand-purple); }
    .product-price .original { font-size: 13px; color: #94a3b8; text-decoration: line-through; margin-left: 8px; }
    .btn-shop {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      margin-top: 12px;
      padding: 10px 14px;
      border-radius: 12px;
      text-decoration: none;
      font-size: 13px;
      font-weight: 700;
      background: #fdf2f8;
      color: var(--brand-purple);
      border: 1px solid var(--fdf-border);
    }
    .empty-shop { text-align: center; padding: 80px 20px; color: var(--fdf-muted); }
    .empty-shop i { font-size: 64px; color: var(--brand-pink); display: block; margin-bottom: 16px; }
    .stock-badge {
      position: absolute; top: 12px; left: 12px;
      padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800;
      background: #fff; color: #10b981;
    }
    .stock-badge.out { background: rgba(0,0,0,0.6); color: #fff; }
  </style>
</head>
<body>
  <div class="preview-bar">
    <div>
      <strong><i class="bi bi-eye"></i> Shop Preview</strong>
      <span style="opacity:0.85; margin-left:10px; font-size:0.9rem;">How customers see ${seller.businessName}</span>
    </div>
    <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=overview">
      <i class="bi bi-arrow-left"></i> Back to Seller Dashboard
    </a>
  </div>

  <div class="shop-header">
    <h1>${seller.businessName}</h1>
    <p>
      <c:choose>
        <c:when test="${not empty seller.description}">${seller.description}</c:when>
        <c:otherwise>Your storefront preview — only your active products are listed here.</c:otherwise>
      </c:choose>
    </p>
    <div class="shop-nav">
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview" class="${empty selectedCategory ? 'active' : ''}">All</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=SKINCARE" class="${selectedCategory == 'SKINCARE' ? 'active' : ''}">Skincare</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=HAIRCARE" class="${selectedCategory == 'HAIRCARE' ? 'active' : ''}">Haircare</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=HYGIENE" class="${selectedCategory == 'HYGIENE' ? 'active' : ''}">Hygiene</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=CLOTHING" class="${selectedCategory == 'CLOTHING' ? 'active' : ''}">Clothing</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=ACCESSORIES" class="${selectedCategory == 'ACCESSORIES' ? 'active' : ''}">Accessories</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=WELLNESS" class="${selectedCategory == 'WELLNESS' ? 'active' : ''}">Wellness</a>
      <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=OTHER" class="${selectedCategory == 'OTHER' ? 'active' : ''}">Other</a>
    </div>
  </div>

  <c:if test="${empty products}">
    <div class="empty-shop">
      <i class="bi bi-bag-heart"></i>
      <h2>No active products yet</h2>
      <p>Add and activate products from your seller dashboard to see them here.</p>
    </div>
  </c:if>

  <div class="products-grid">
    <c:forEach var="p" items="${products}">
      <div class="product-card">
        <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="product-img-wrapper">
          <c:choose>
            <c:when test="${not empty p.imagePath}">
              <img src="${pageContext.request.contextPath}${p.imagePath}" class="product-img" alt="${p.name}">
            </c:when>
            <c:otherwise>
              <div class="product-img-placeholder"><i class="bi bi-gift"></i></div>
            </c:otherwise>
          </c:choose>
          <span class="stock-badge ${p.stock > 0 ? 'in' : 'out'}">
            ${p.stock > 0 ? 'In Stock' : 'Out of Stock'}
          </span>
        </a>
        <div class="product-body">
          <div class="product-category">${p.categoryLabel}</div>
          <div class="product-name">${p.name}</div>
          <div class="product-seller"><i class="bi bi-patch-check-fill"></i> ${seller.businessName}</div>
          <div class="product-price">
            <span class="current">&#8377;${p.price}</span>
            <c:if test="${p.originalPrice != null && p.originalPrice > p.price}">
              <span class="original">&#8377;${p.originalPrice}</span>
            </c:if>
          </div>
          <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="btn-shop">
            <i class="bi bi-eye"></i> View Details
          </a>
        </div>
      </div>
    </c:forEach>
  </div>
</body>
</html>
