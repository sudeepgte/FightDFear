<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${product.name} — Fight D Fear Shop</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    :root {
      --pv-bg: #fffcfd;
      --card-bg: #ffffff;
    }
    body {
      font-family: 'Poppins', sans-serif;
      background: var(--pv-bg);
      color: var(--fdf-text);
      min-height: 100vh;
      margin: 0;
    }
    .pv-hero {
      background: #fff;
      border-bottom: 1px solid var(--fdf-border);
      padding: 28px 20px 24px;
    }
    .pv-hero-inner {
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
    .pv-page-title {
      font-family: 'Montserrat', sans-serif;
      font-size: clamp(1.35rem, 2.5vw, 1.75rem);
      font-weight: 900;
      color: var(--brand-purple-darker);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .pv-page-title i { color: var(--brand-pink); }
    .pv-page-subtitle {
      margin: 8px 0 0;
      color: var(--fdf-muted);
      font-size: 0.95rem;
      font-weight: 500;
    }
    .pv-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 28px 20px 40px;
    }

    .product-detail-container {
      background: var(--card-bg);
      border-radius: 24px;
      overflow: hidden;
      box-shadow: var(--shadow-md);
      border: 1px solid var(--fdf-border);
      display: grid;
      grid-template-columns: minmax(280px, 1fr) minmax(320px, 1.15fr);
      align-items: stretch;
    }

    .product-image-side {
      position: relative;
      background: linear-gradient(165deg, #fdf2f8 0%, #f5f3ff 55%, #fff 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 28px;
      border-right: 1px solid var(--fdf-border);
    }
    .placeholder-icon {
      font-size: 100px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      opacity: 0.35;
      text-align: center;
    }

    .product-info-side {
      padding: 36px 40px;
      display: flex;
      flex-direction: column;
    }
    .category-label {
      font-size: 11px;
      font-weight: 800;
      color: var(--brand-pink);
      text-transform: uppercase;
      letter-spacing: 1.5px;
      margin-bottom: 8px;
    }
    .product-title {
      font-family: 'Montserrat', sans-serif;
      font-size: clamp(1.5rem, 2.8vw, 2rem);
      font-weight: 900;
      color: var(--brand-purple-darker);
      line-height: 1.25;
      margin: 0 0 10px;
    }
    .seller-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 16px;
      background: #fafafa;
      border-radius: 12px;
      font-size: 13px;
      color: var(--fdf-muted);
      border: 1px solid var(--fdf-border);
      width: fit-content;
      max-width: 100%;
    }
    .seller-badge strong { color: var(--brand-purple); }

    .product-desc {
      font-size: 15px;
      line-height: 1.75;
      color: #4b5563;
      margin: 0 0 8px;
    }

    .btn-group {
      display: flex;
      gap: 12px;
      margin-top: 8px;
      align-items: stretch;
    }
    .btn-group form {
      display: flex;
      margin: 0;
    }
    .btn-group form.cart-form { flex: 2; }
    .btn-group form.wish-form { flex: 0 0 auto; }
    .btn-group form .btn-fdf-main,
    .btn-group form .btn-fdf-secondary {
      width: 100%;
    }
    .btn-fdf-main {
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      padding: 16px 20px;
      border-radius: 14px;
      font-size: 15px;
      font-weight: 800;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: all 0.25s ease;
      box-shadow: 0 10px 20px rgba(124, 45, 94, 0.18);
      font-family: inherit;
    }
    .btn-fdf-main:hover {
      transform: translateY(-2px);
      box-shadow: 0 14px 28px rgba(124, 45, 94, 0.28);
      filter: brightness(1.05);
      color: #fff;
    }
    .btn-fdf-secondary {
      background: #fff;
      color: var(--brand-purple);
      border: 2px solid var(--fdf-border);
      padding: 14px 18px;
      border-radius: 14px;
      font-size: 16px;
      font-weight: 800;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: all 0.25s ease;
      min-width: 56px;
      font-family: inherit;
    }
    .btn-fdf-secondary:hover {
      border-color: var(--brand-purple);
      color: var(--brand-purple-dark);
      background: #fdf2f8;
    }
    .btn-fdf-secondary.active {
      background: #fee2e2;
      border-color: var(--brand-pink);
      color: var(--brand-pink);
    }

    .brand-top {
      font-size: 11px;
      font-weight: 800;
      color: var(--fdf-muted);
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 4px;
    }
    .ratings-block {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 8px;
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 18px;
    }
    .ratings-block i { color: #f59e0b; }

    .price-box {
      background: #f8fafc;
      border: 1px solid #eef2f7;
      border-radius: 14px;
      padding: 16px 18px;
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 14px;
    }
    .price-box .current {
      font-size: 28px;
      font-weight: 900;
      color: var(--brand-purple-dark);
      line-height: 1;
    }
    .price-box .original {
      font-size: 15px;
      color: #9ca3af;
      text-decoration: line-through;
    }
    .price-box .disc-tag {
      background: #fee2e2;
      color: #dc2626;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 800;
    }

    .stock-text {
      color: #16a34a;
      font-weight: 700;
      font-size: 14px;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      margin-bottom: 18px;
    }
    .stock-text.low {
      color: #c2410c;
      background: #fff7ed;
      border: 1px solid #fdba74;
      padding: 8px 14px;
      border-radius: 10px;
    }
    .stock-text.out { color: #dc2626; }

    .highlights-box {
      margin-top: 8px;
      padding: 18px;
      background: #fafafa;
      border-radius: 14px;
      border: 1px solid #f0f0f0;
    }
    .highlights-box h4 {
      font-size: 14px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin: 0 0 12px;
    }
    .highlight-item {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      font-size: 14px;
      color: #4b5563;
      margin-bottom: 8px;
      line-height: 1.45;
    }
    .highlight-item:last-child { margin-bottom: 0; }
    .highlight-item i { color: #16a34a; font-size: 15px; margin-top: 2px; flex-shrink: 0; }
    .highlight-item strong { color: var(--brand-purple-dark); }

    .delivery-box {
      background: #f8fafc;
      border: 1px solid #eef2f7;
      border-radius: 14px;
      padding: 18px;
      margin-top: 16px;
    }
    .delivery-box h4 {
      font-size: 14px;
      font-weight: 800;
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 0 0 12px;
      color: var(--brand-purple-dark);
    }
    .pincode-input-group {
      display: flex;
      gap: 10px;
      align-items: stretch;
    }
    .pincode-input {
      flex: 1;
      min-width: 0;
      padding: 12px 14px;
      border: 1px solid var(--fdf-border);
      border-radius: 10px;
      font-size: 14px;
      outline: none;
      font-family: inherit;
      background: #fff;
    }
    .pincode-input:focus {
      border-color: var(--brand-purple);
      box-shadow: 0 0 0 3px rgba(124, 45, 94, 0.12);
    }
    .pincode-btn {
      background: var(--brand-purple) !important;
      color: #fff !important;
      border: none !important;
      padding: 12px 18px;
      border-radius: 10px;
      font-weight: 700;
      cursor: pointer;
      flex-shrink: 0;
      min-width: 148px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-size: 14px;
      font-family: inherit;
      transition: filter 0.2s ease;
    }
    .pincode-btn:hover { filter: brightness(1.08); }
    .delivery-msg {
      margin-top: 12px;
      font-size: 13px;
      font-weight: 600;
      display: none;
    }
    .delivery-msg.success { color: #16a34a; display: block; }
    .delivery-msg.error { color: #dc2626; display: block; }

    .detail-sections {
      margin-top: 28px;
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .detail-card {
      background: var(--card-bg);
      border-radius: 20px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
      padding: 24px 28px;
    }
    .detail-card h3 {
      font-family: 'Montserrat', sans-serif;
      font-size: 17px;
      font-weight: 800;
      color: var(--brand-purple-darker);
      margin: 0 0 12px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .detail-card h3 i { color: var(--brand-pink); }
    .detail-card .detail-body {
      font-size: 15px;
      line-height: 1.8;
      color: #4b5563;
      white-space: pre-wrap;
      word-break: break-word;
    }

    .tags-container {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 14px;
      margin-bottom: 4px;
    }
    .tag-badge {
      background: #fdf2f8;
      color: var(--brand-pink);
      padding: 5px 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid #fce7f3;
    }

    .tabs-section {
      margin-top: 28px;
      margin-bottom: 40px;
      background: var(--card-bg);
      border-radius: 20px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--fdf-border);
      overflow: hidden;
    }
    .tabs-header {
      display: flex;
      border-bottom: 1px solid var(--fdf-border);
      overflow-x: auto;
      background: #fafafa;
    }
    .tab-btn {
      flex: 1;
      padding: 18px 20px;
      background: transparent;
      border: none;
      font-size: 15px;
      font-weight: 700;
      color: var(--brand-purple);
      cursor: default;
      border-bottom: 3px solid var(--brand-purple);
      min-width: 150px;
      font-family: inherit;
    }
    .tab-content {
      padding: 28px;
      display: block;
      font-size: 15px;
      line-height: 1.8;
      color: #4b5563;
    }

    .gallery-container {
      display: flex;
      flex-direction: column;
      gap: 14px;
      width: 100%;
    }
    .main-img-box {
      background: #fff;
      border-radius: 18px;
      height: 420px;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
    }
    .main-img-box img {
      width: 100%;
      height: 100%;
      object-fit: contain;
      padding: 12px;
    }
    .thumb-strip {
      display: flex;
      gap: 10px;
      overflow-x: auto;
      padding-bottom: 4px;
    }
    .thumb-box {
      width: 72px;
      height: 72px;
      border-radius: 12px;
      border: 2px solid transparent;
      overflow: hidden;
      cursor: pointer;
      opacity: 0.75;
      transition: all 0.25s ease;
      flex-shrink: 0;
      background: #fff;
      box-shadow: var(--shadow-sm);
    }
    .thumb-box:hover { opacity: 1; }
    .thumb-box.active {
      border-color: var(--brand-pink);
      opacity: 1;
    }
    .thumb-box img {
      width: 100%;
      height: 100%;
      object-fit: contain;
      padding: 4px;
    }

    .reviews-grid {
      display: grid;
      grid-template-columns: minmax(200px, 1fr) minmax(260px, 2fr);
      gap: 28px;
    }
    .review-summary {
      padding: 20px;
      background: #fafafa;
      border-radius: 16px;
      border: 1px solid #f0f0f0;
      height: fit-content;
    }
    .review-item {
      padding: 18px 0;
      border-bottom: 1px solid #f0f0f0;
    }
    .review-item:last-child { border-bottom: none; }

    .pv-footer {
      text-align: center;
      color: var(--fdf-muted);
      font-size: 13px;
      padding: 12px 20px 40px;
    }

    @media (max-width: 992px) {
      .product-detail-container { grid-template-columns: 1fr; }
      .product-image-side {
        border-right: none;
        border-bottom: 1px solid var(--fdf-border);
        padding: 20px;
      }
      .product-info-side { padding: 28px 24px; }
      .main-img-box { height: 340px; }
      .reviews-grid { grid-template-columns: 1fr; gap: 20px; }
    }

    @media (max-width: 768px) {
      .pv-hero { padding: 20px 16px 18px; }
      .pv-container { padding: 20px 14px 32px; }
      .product-detail-container { border-radius: 18px; }
      .product-info-side { padding: 20px 16px; }
      .main-img-box { height: 260px; }
      .btn-group { flex-direction: column; }
      .btn-group form.wish-form { width: 100%; }
      .btn-group form.wish-form .btn-fdf-secondary { width: 100%; }
      .pincode-input-group { flex-direction: column; }
      .pincode-btn { width: 100%; min-width: 0; }
      .detail-card { padding: 18px; }
      .tab-content { padding: 18px; }
      .thumb-box { width: 64px; height: 64px; }
    }
  </style>
</head>
<body class="wp-shop">
  <header class="pv-hero">
    <div class="pv-hero-inner">
      <a href="${pageContext.request.contextPath}/women-products" class="back-link">
        <i class="bi bi-arrow-left"></i> Back to Shop
      </a>
      <h1 class="pv-page-title"><i class="bi bi-bag-heart-fill"></i> Product Details</h1>
      <p class="pv-page-subtitle">Review product information, pricing, and availability before you buy.</p>
      <div class="wp-subnav" style="justify-content:flex-start;margin-top:14px;">
        <a href="${pageContext.request.contextPath}/women-products">Shop</a>
        <a href="${pageContext.request.contextPath}/women-products/wishlist">Wishlist</a>
        <a href="${pageContext.request.contextPath}/women-products/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/women-products/my-orders">My Orders</a>
      </div>
    </div>
  </header>

  <div class="pv-container">
    <div class="product-detail-container">
      <div class="product-image-side">
        <div class="gallery-container">
          <c:choose>
            <c:when test="${not empty productImageUrl}">
              <div class="main-img-box">
                <img id="mainImage" src="${pageContext.request.contextPath}${productImageUrl}" alt="${product.name}"
                     onerror="this.onerror=null; this.style.display='none'; this.parentElement.innerHTML='<div class=&quot;placeholder-icon&quot;><i class=&quot;bi bi-gift-fill&quot;></i></div>';">
              </div>
              <c:if test="${not empty additionalImageUrls}">
                <div class="thumb-strip">
                  <div class="thumb-box active" onclick="changeImage(this, '${pageContext.request.contextPath}${productImageUrl}')">
                    <img src="${pageContext.request.contextPath}${productImageUrl}" alt="Thumbnail">
                  </div>
                  <c:forEach var="addImg" items="${additionalImageUrls}">
                    <div class="thumb-box" onclick="changeImage(this, '${pageContext.request.contextPath}${addImg}')">
                      <img src="${pageContext.request.contextPath}${addImg}" alt="Thumbnail">
                    </div>
                  </c:forEach>
                </div>
              </c:if>
            </c:when>
            <c:otherwise>
              <div class="placeholder-icon"><i class="bi bi-gift-fill"></i></div>
              <p style="margin-top:12px; color:var(--fdf-muted); font-weight:600; text-align:center;">No product image available</p>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="product-info-side">
        <div class="category-label">${product.categoryLabel}</div>
        <c:if test="${not empty product.brand}">
          <div class="brand-top">${product.brand}</div>
        </c:if>
        <h2 class="product-title"><c:out value="${product.name}"/></h2>

        <div class="ratings-block" onclick="document.getElementById('reviewsSection').scrollIntoView({behavior:'smooth'})" style="cursor:pointer;">
          <div>
            <c:forEach begin="1" end="5" var="i">
              <i class="bi ${i <= avgRating ? 'bi-star-fill' : (i - avgRating < 1 ? 'bi-star-half' : 'bi-star')}"></i>
            </c:forEach>
          </div>
          <span>${avgRating} (${reviewCount} reviews)</span>
        </div>

        <div class="price-box">
          <span class="current">&#8377;<fmt:formatNumber value="${product.price}" maxFractionDigits="2" minFractionDigits="0"/></span>
          <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
            <span class="original">&#8377;<fmt:formatNumber value="${product.originalPrice}" maxFractionDigits="2" minFractionDigits="0"/></span>
            <c:set var="discPct" value="${((product.originalPrice - product.price) / product.originalPrice) * 100}" />
            <span class="disc-tag"><fmt:formatNumber value="${discPct}" maxFractionDigits="0"/>% OFF</span>
          </c:if>
        </div>


        <c:choose>
          <c:when test="${product.stock == null || product.stock <= 0}">
            <div class="stock-text out"><i class="bi bi-x-circle-fill"></i> Out of Stock</div>
          </c:when>
          <c:when test="${product.lowStockAlertLevel != null && product.stock <= product.lowStockAlertLevel}">
            <div class="stock-text low">
              <i class="bi bi-exclamation-triangle-fill"></i>
              Hurry — only ${product.stock} left in stock!
            </div>
          </c:when>
          <c:otherwise>
            <div class="stock-text"><i class="bi bi-check-circle-fill"></i> In Stock (${product.stock} available)</div>
          </c:otherwise>
        </c:choose>

        <c:if test="${not empty product.description}">
          <div class="product-desc"><c:out value="${product.description}"/></div>
        </c:if>

        <div id="stockContainer" style="margin-bottom: 20px;"></div>

        <div class="quantity-selector-block" style="margin-bottom: 20px; display: flex; align-items: center; gap: 14px;">
          <label style="font-weight: 800; font-size: 14px; color: var(--brand-purple-dark);">Quantity:</label>
          <c:choose>
            <c:when test="${product.stock > 0}">
              <input type="number" id="productQuantity" min="1" max="${product.stock}" value="1" class="form-control" style="width: 100px; text-align: center; font-weight: 800; border-radius: 12px; border: 2px solid var(--fdf-border); font-size: 15px;">
            </c:when>
            <c:otherwise>
              <input type="number" id="productQuantity" min="0" max="0" value="0" disabled class="form-control" style="width: 100px; text-align: center; font-weight: 800; border-radius: 12px; background: #f3f4f6; color: #9ca3af; font-size: 15px;">
            </c:otherwise>
          </c:choose>
        </div>

        <div class="highlights-box">
          <h4>Highlights</h4>
          <div class="highlight-item"><i class="bi bi-tag-fill"></i> Category: <strong>${product.categoryLabel}</strong></div>
          <c:if test="${not empty product.brand}">
            <div class="highlight-item"><i class="bi bi-patch-check-fill"></i> Brand: <strong>${product.brand}</strong></div>
          </c:if>
          <c:if test="${not empty product.weightSize}">
            <div class="highlight-item"><i class="bi bi-box-seam-fill"></i> Weight/Size: <strong>${product.weightSize}</strong></div>
          </c:if>
          <c:if test="${not empty product.manufacturer}">
            <div class="highlight-item"><i class="bi bi-building-fill"></i> Manufacturer: <strong>${product.manufacturer}</strong></div>
          </c:if>
          <div class="highlight-item"><i class="bi bi-globe-americas"></i> Country of Origin: <strong>India</strong></div>
        </div>

        <div class="delivery-box">
          <h4><i class="bi bi-truck"></i> Delivery</h4>
          <div class="pincode-input-group">
            <input type="text" id="pincodeInput" class="pincode-input" placeholder="Enter 6-digit pincode"
                   maxlength="6" inputmode="numeric" autocomplete="postal-code"
                   aria-label="Delivery pincode"
                   oninput="this.value=this.value.replace(/[^0-9]/g,'')">
            <button type="button" id="checkDeliveryBtn" class="pincode-btn" onclick="checkDelivery()">
              <i class="bi bi-search"></i> Check Delivery
            </button>
          </div>
          <div id="deliveryMsg" class="delivery-msg" role="status" aria-live="polite"></div>
        </div>

        <div class="seller-badge" style="margin-top: 16px;">
          <i class="bi bi-shop"></i>
          Sold by <strong><c:out value="${product.seller.businessName}"/></strong>
          <c:if test="${sellerApproved}"><span style="margin-left:8px;font-size:11px;font-weight:800;color:#059669;">Verified seller</span></c:if>
        </div>

        <c:if test="${not empty product.tags}">
          <div class="tags-container">
            <c:forEach var="tag" items="${fn:split(product.tags, ',')}">
              <span class="tag-badge">#<c:out value="${fn:trim(tag)}"/></span>
            </c:forEach>
          </div>
        </c:if>

        <div class="btn-group" style="margin-top:20px; gap:12px;">
          <form action="${pageContext.request.contextPath}/women-products/buy-now" method="post" id="buyNowForm" style="flex: 2;">
            <input type="hidden" name="productId" value="${product.id}">
            <input type="hidden" name="quantity" id="buyNowQty" value="1">
            <button type="submit" class="btn-fdf-main" id="buyNowBtn" ${product.stock <= 0 ? 'disabled style="opacity:0.5; cursor:not-allowed; background:#9ca3af; box-shadow:none;"' : ''}>
              <i class="bi bi-lightning-charge-fill"></i> Buy Now
            </button>
          </form>
          <form action="${pageContext.request.contextPath}/women-products/cart/add" method="post" id="addToCartForm" style="flex: 2;">
            <input type="hidden" name="productId" value="${product.id}">
            <input type="hidden" name="quantity" id="addToCartQty" value="1">
            <button type="submit" class="btn-fdf-main" id="addToCartBtn" ${product.stock <= 0 ? 'disabled style="opacity:0.5; cursor:not-allowed; background:#9ca3af; box-shadow:none;"' : 'style="background: #166534; box-shadow: none;"'}>
              <i class="bi bi-cart-plus-fill"></i> Add to Cart
            </button>
          </form>
          <form action="${pageContext.request.contextPath}/women-products/wishlist/toggle" method="post" style="flex: 1;">
            <input type="hidden" name="productId" value="${product.id}">
            <button type="submit" class="btn-fdf-secondary ${inWishlist ? 'active' : ''}" title="${inWishlist ? 'Remove from wishlist' : 'Add to wishlist'}">
              <i class="bi ${inWishlist ? 'bi-heart-fill' : 'bi-heart'}"></i>
            </button>
          </form>
        </div>
      </div>
    </div>

    <c:set var="hasFullDesc" value="${not empty fullDescription}" />
    <c:set var="hasIngredients" value="${not empty ingredients}" />
    <c:set var="hasBenefits" value="${not empty benefits}" />
    <c:set var="hasUsage" value="${not empty usageInstructions}" />
    <c:if test="${hasFullDesc or hasIngredients or hasBenefits or hasUsage}">
      <div class="detail-sections">
        <c:if test="${hasFullDesc}">
          <section class="detail-card">
            <h3><i class="bi bi-card-text"></i> Product Description</h3>
            <div class="detail-body"><c:out value="${fullDescription}" /></div>
          </section>
        </c:if>
        <c:if test="${hasIngredients}">
          <section class="detail-card" id="ingredientsSection">
            <h3><i class="bi bi-flask"></i> Ingredients</h3>
            <div class="detail-body"><c:out value="${ingredients}" /></div>
          </section>
        </c:if>
        <c:if test="${hasBenefits}">
          <section class="detail-card" id="benefitsSection">
            <h3><i class="bi bi-heart-pulse"></i> Benefits</h3>
            <div class="detail-body"><c:out value="${benefits}" /></div>
          </section>
        </c:if>
        <c:if test="${hasUsage}">
          <section class="detail-card" id="usageSection">
            <h3><i class="bi bi-info-circle"></i> How to Use</h3>
            <div class="detail-body"><c:out value="${usageInstructions}" /></div>
          </section>
        </c:if>
      </div>
    </c:if>

    <div id="reviewsSection" class="tabs-section">
      <div class="tabs-header">
        <button type="button" class="tab-btn">Customer Ratings &amp; Reviews</button>
      </div>
      <div class="tab-content">
        <c:choose>
          <c:when test="${not empty reviews}">
            <div class="reviews-grid">
              <div class="review-summary">
                <div style="font-size: 48px; font-weight: 900; color: var(--brand-purple-dark); line-height: 1;">${avgRating}</div>
                <div style="color: #f59e0b; margin: 10px 0; font-size: 20px;">
                  <c:forEach begin="1" end="5" var="i">
                    <i class="bi ${i <= avgRating ? 'bi-star-fill' : (i - avgRating < 1 ? 'bi-star-half' : 'bi-star')}"></i>
                  </c:forEach>
                </div>
                <div style="font-size: 14px; font-weight: 700; color: var(--fdf-muted); margin-bottom: 20px;">Based on ${reviewCount} reviews</div>

                <div style="display: flex; flex-direction: column; gap: 8px;">
                  <c:forEach begin="1" end="5" var="i">
                    <c:set var="starLevel" value="${6-i}" />
                    <c:set var="count" value="0" />
                    <c:forEach var="r" items="${reviews}"><c:if test="${r.rating == starLevel}"><c:set var="count" value="${count + 1}" /></c:if></c:forEach>
                    <c:set var="percent" value="${reviewCount > 0 ? (count * 100 / reviewCount) : 0}" />
                    <div style="display: flex; align-items: center; gap: 10px;">
                      <span style="font-size: 12px; font-weight: 700; width: 40px;">${starLevel} Star</span>
                      <div style="flex: 1; height: 8px; background: #eee; border-radius: 4px; overflow: hidden;">
                        <div style="width: ${percent}%; height: 100%; background: var(--brand-pink);"></div>
                      </div>
                      <span style="font-size: 12px; font-weight: 700; color: var(--fdf-muted); width: 25px;">${count}</span>
                    </div>
                  </c:forEach>
                </div>
              </div>

              <div style="display: flex; flex-direction: column; gap: 4px;">
                <c:forEach var="r" items="${reviews}">
                  <div class="review-item">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; gap: 12px; flex-wrap: wrap;">
                      <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 36px; height: 36px; border-radius: 10px; background: var(--gradient-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px;">
                          ${not empty r.user.fullName ? r.user.fullName.substring(0,1) : 'U'}
                        </div>
                        <div>
                          <div style="font-weight: 800; font-size: 14px; color: var(--brand-purple-darker);"><c:out value="${r.user.fullName}"/></div>
                          <div style="font-size: 11px; color: #9ca3af; font-weight: 600;"><i class="bi bi-patch-check-fill" style="color:#16a34a"></i> Verified Purchase</div>
                        </div>
                      </div>
                      <div style="color: #f59e0b; font-size: 12px;">
                        <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                        <c:forEach begin="${r.rating + 1}" end="5"><i class="bi bi-star" style="color: #ddd;"></i></c:forEach>
                      </div>
                    </div>
                    <p style="font-size: 14px; color: #4b5563; line-height: 1.6; margin-bottom: 8px;"><c:out value="${r.review}"/></p>
                    <div style="font-size: 11px; color: #9ca3af;">Posted on ${r.orderTime}</div>
                  </div>
                </c:forEach>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div style="text-align: center; padding: 40px; color: var(--fdf-muted);">
              <i class="bi bi-chat-square-dots" style="font-size: 48px; display: block; margin-bottom: 15px; opacity: 0.3;"></i>
              No reviews for this product yet.
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <c:if test="${not empty relatedProducts}">
    <div class="pv-container" style="padding-top:0;">
      <h3 style="font-family:Montserrat,sans-serif;font-weight:800;color:var(--brand-purple-darker);margin:0 0 16px;">You May Also Like</h3>
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;">
        <c:forEach var="rp" items="${relatedProducts}">
          <a href="${pageContext.request.contextPath}/women-products/view/${rp.id}" style="text-decoration:none;color:inherit;background:#fff;border:1px solid var(--fdf-border);border-radius:16px;overflow:hidden;box-shadow:var(--shadow-sm);">
            <div style="height:140px;background:#fdf2f8;">
              <c:if test="${not empty rp.publicImagePath}">
                <img src="<c:choose><c:when test="${rp.remoteImage}">${rp.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${rp.publicImagePath}</c:otherwise></c:choose>" alt="<c:out value='${rp.name}'/>" style="width:100%;height:100%;object-fit:cover;">
              </c:if>
            </div>
            <div style="padding:12px;">
              <div style="font-weight:800;font-size:14px;color:var(--brand-purple);"><c:out value="${rp.name}"/></div>
              <div style="font-weight:900;margin-top:6px;">&#8377;<fmt:formatNumber value="${rp.price}" maxFractionDigits="2"/></div>
            </div>
          </a>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <script>
    function changeImage(element, src) {
      const main = document.getElementById('mainImage');
      if (main) main.src = src;
      document.querySelectorAll('.thumb-box').forEach(el => el.classList.remove('active'));
      element.classList.add('active');
    }

    function checkDelivery() {
      const inputEl = document.getElementById('pincodeInput');
      const input = (inputEl.value || '').trim();
      const msgBox = document.getElementById('deliveryMsg');
      if (!inputEl || !msgBox) return;

      if (!/^\d{6}$/.test(input)) {
        msgBox.className = 'delivery-msg error';
        msgBox.innerHTML = '<i class="bi bi-exclamation-triangle-fill"></i> Please enter a valid 6-digit pincode.';
        return;
      }

      const fakePincodes = ['000000', '111111', '222222', '333333', '444444', '555555', '666666', '777777', '888888', '999999'];
      if (fakePincodes.includes(input) || !/^[1-9]\d{5}$/.test(input)) {
        msgBox.className = 'delivery-msg error';
        msgBox.innerHTML = '<i class="bi bi-x-circle-fill"></i> Sorry, delivery is not available for this pincode.';
        return;
      }

      let sum = 0;
      for (let i = 0; i < input.length; i++) {
        sum += parseInt(input.charAt(i), 10);
      }
      let daysToAdd = (sum % 6) + 2;
      const prefix = input.substring(0, 2);
      if (['56', '11', '40', '60', '70', '50', '12', '13', '14', '20', '30'].includes(prefix)) {
        daysToAdd = (sum % 2) + 1;
      }

      const deliveryDate = new Date();
      deliveryDate.setDate(deliveryDate.getDate() + daysToAdd);
      const dateString = deliveryDate.toLocaleDateString('en-IN', { weekday: 'long', day: 'numeric', month: 'short' });
      msgBox.className = 'delivery-msg success';
      msgBox.innerHTML = '<i class="bi bi-check-circle-fill"></i> Delivery available — arriving by <strong>' + dateString + '</strong>.';
    }

    function updateQtyInputs(inputEl, maxStock) {
      let val = parseInt(inputEl.value, 10) || 1;
      if (val < 1) val = 1;
      if (val > maxStock) val = maxStock;
      inputEl.value = val;
      const buyNowQty = document.getElementById('buyNowQty');
      const addToCartQty = document.getElementById('addToCartQty');
      if (buyNowQty) buyNowQty.value = val;
      if (addToCartQty) addToCartQty.value = val;
    }

    function pollProductStock() {
      const productId = '${product.id}';
      if (!productId) return;
      fetch('${pageContext.request.contextPath}/women-products/api/product/' + productId + '/stock')
        .then(res => res.json())
        .then(data => {
          if (!data.exists) return;
          const stock = data.stock;
          const container = document.getElementById('stockContainer');
          const qtyInput = document.getElementById('productQuantity');
          const buyNowBtn = document.getElementById('buyNowBtn');
          const addToCartBtn = document.getElementById('addToCartBtn');
          if (container) {
            if (stock > 5) {
              container.innerHTML = '<div class="stock-badge-pill" style="display:inline-flex;align-items:center;gap:8px;padding:8px 16px;background:#ecfdf5;color:#059669;border-radius:12px;font-weight:800;font-size:14px;"><i class="bi bi-check-circle-fill"></i> In Stock</div>';
            } else if (stock >= 2) {
              container.innerHTML = '<div class="stock-badge-pill" style="display:inline-flex;align-items:center;gap:8px;padding:8px 16px;background:#fffbe0;color:#d97706;border-radius:12px;font-weight:800;font-size:14px;"><i class="bi bi-exclamation-triangle-fill"></i> Only ' + stock + ' left in stock</div>';
            } else if (stock === 1) {
              container.innerHTML = '<div class="stock-badge-pill" style="display:inline-flex;align-items:center;gap:8px;padding:8px 16px;background:#fef2f2;color:#dc2626;border-radius:12px;font-weight:800;font-size:14px;"><i class="bi bi-fire"></i> Only 1 left in stock</div>';
            } else {
              container.innerHTML = '<div class="stock-badge-pill" style="display:inline-flex;align-items:center;gap:8px;padding:8px 16px;background:#fee2e2;color:#991b1b;border-radius:12px;font-weight:800;font-size:14px;"><i class="bi bi-x-circle-fill"></i> Out of Stock</div>';
            }
          }
          if (qtyInput) {
            if (stock <= 0) {
              qtyInput.value = 0;
              qtyInput.max = 0;
              qtyInput.disabled = true;
            } else {
              qtyInput.disabled = false;
              qtyInput.min = 1;
              qtyInput.max = stock;
              if (parseInt(qtyInput.value, 10) > stock) updateQtyInputs(qtyInput, stock);
            }
          }
          [buyNowBtn, addToCartBtn].forEach(function(btn) {
            if (!btn) return;
            btn.disabled = stock <= 0;
            btn.style.opacity = stock <= 0 ? '0.5' : '1';
            btn.style.cursor = stock <= 0 ? 'not-allowed' : 'pointer';
          });
        })
        .catch(function() { /* ignore */ });
    }

    document.addEventListener('DOMContentLoaded', function () {
      const qtyInput = document.getElementById('productQuantity');
      const maxStock = ${product.stock == null ? 0 : product.stock};
      if (qtyInput) {
        qtyInput.addEventListener('input', function () { updateQtyInputs(qtyInput, parseInt(qtyInput.max, 10) || maxStock); });
        updateQtyInputs(qtyInput, maxStock > 0 ? maxStock : 1);
      }
      const pincodeInput = document.getElementById('pincodeInput');
      if (pincodeInput) {
        pincodeInput.addEventListener('keydown', function (e) {
          if (e.key === 'Enter') { e.preventDefault(); checkDelivery(); }
        });
      }
      pollProductStock();
      setInterval(pollProductStock, 3000);
    });
  </script>

  <jsp:include page="/WEB-INF/views/women-products/wp-footer.jsp" />
</body>
</html>
