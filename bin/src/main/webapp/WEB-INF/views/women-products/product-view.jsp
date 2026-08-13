<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${product.name} — Fight D Fear Shop</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: #fffcfd;
      color: var(--fdf-text);
      min-height: 100vh;
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
    
    .product-detail-container {
      background: #fff;
      border-radius: 30px;
      overflow: hidden;
      box-shadow: var(--shadow-lg);
      border: 1px solid var(--fdf-border);
      max-width: 1100px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1.2fr;
    }
    
    .product-image-side {
      position: relative;
      background: #fdf2f8;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 30px;
    }
    .product-image-side img {
      width: 100%;
      height: 100%;
      max-height: 500px;
      object-fit: contain;
      border-radius: 20px;
      filter: drop-shadow(0 20px 40px rgba(0,0,0,0.1));
    }
    .placeholder-icon {
      font-size: 120px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      opacity: 0.3;
    }

    .product-info-side {
      padding: 50px;
      display: flex;
      flex-direction: column;
    }
    .category-label {
      font-size: 12px;
      font-weight: 800;
      color: var(--brand-pink);
      text-transform: uppercase;
      letter-spacing: 2px;
      margin-bottom: 12px;
    }
    .product-title {
      font-family: 'Montserrat', sans-serif;
      font-size: 34px;
      font-weight: 900;
      color: var(--brand-purple-darker);
      line-height: 1.2;
      margin-bottom: 16px;
    }
    .seller-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 16px;
      background: #f5f3ff;
      border-radius: 999px;
      font-size: 14px;
      color: var(--fdf-muted);
      margin-bottom: 30px;
    }
    .seller-badge strong { color: var(--brand-purple); }

    .price-section {
      display: flex;
      align-items: center;
      gap: 15px;
      margin-bottom: 30px;
    }
    .price-section .current {
      font-size: 36px;
      font-weight: 900;
      color: var(--brand-purple-dark);
    }
    .price-section .original {
      font-size: 18px;
      color: #9ca3af;
      text-decoration: line-through;
    }
    .price-section .disc-tag {
      background: #fee2e2;
      color: #ef4444;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 800;
    }

    .product-desc {
      font-size: 16px;
      line-height: 1.8;
      color: #4b5563;
      margin-bottom: 35px;
      border-top: 1px solid #f3f4f6;
      padding-top: 25px;
    }

    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 40px;
    }
    .status-pill.in { background: #ecfdf5; color: #059669; border: 1px solid #10b98133; }
    .status-pill.out { background: #fef2f2; color: #dc2626; border: 1px solid #ef444433; }

    .btn-group {
      display: flex;
      gap: 15px;
      margin-top: auto;
    }
    .btn-fdf-main {
      flex: 2;
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      padding: 18px;
      border-radius: 16px;
      font-size: 16px;
      font-weight: 800;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: all 0.3s;
      box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
    }
    .btn-fdf-main:hover {
      transform: translateY(-3px);
      box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
      filter: brightness(1.1);
    }
    .btn-fdf-secondary {
      flex: 1;
      background: #fff;
      color: var(--brand-purple);
      border: 2px solid var(--fdf-border);
      padding: 18px;
      border-radius: 16px;
      font-size: 16px;
      font-weight: 800;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: all 0.3s;
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

    /* New Specific Styles for the matched layout */
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
      gap: 8px;
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 24px;
    }
    .ratings-block i { color: #f59e0b; }
    
    .price-box {
      background: #fafafa;
      border-radius: 12px;
      padding: 16px 20px;
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 16px;
    }
    .price-box .current { font-size: 28px; font-weight: 900; color: #16a34a; }
    .price-box .original { font-size: 16px; color: #9ca3af; text-decoration: line-through; }
    
    .stock-text {
      color: #16a34a;
      font-weight: 700;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 6px;
      margin-bottom: 24px;
    }

    .highlights-box {
      margin-top: 30px;
    }
    .highlights-box h4 {
      font-size: 15px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin-bottom: 15px;
    }
    .highlight-item {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 14px;
      color: #4b5563;
      margin-bottom: 10px;
    }
    .highlight-item i { color: #16a34a; font-size: 16px; }
    .highlight-item strong { color: var(--brand-purple-dark); }

    .delivery-box {
      background: #fafafa;
      border-radius: 16px;
      padding: 24px;
      margin-top: 30px;
    }
    .delivery-box h4 {
      font-size: 14px;
      font-weight: 800;
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 12px;
    }
    .pincode-input-group {
      display: flex;
      gap: 10px;
    }
    .pincode-input {
      flex: 1;
      padding: 12px 16px;
      border: 1px solid var(--fdf-border);
      border-radius: 8px;
      font-size: 14px;
      outline: none;
    }
    .pincode-btn {
      background: #166534;
      color: #fff;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      font-weight: 700;
      cursor: pointer;
    }
    .delivery-msg {
      margin-top: 12px;
      font-size: 13px;
      font-weight: 600;
      display: none;
    }
    .delivery-msg.success { color: #16a34a; display: block; }
    .delivery-msg.error { color: #dc2626; display: block; }

    /* Additional Sections Styling */
    .product-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
      margin-top: 15px;
      margin-bottom: 20px;
      padding-bottom: 20px;
      border-bottom: 1px solid #f3f4f6;
    }
    .meta-item {
      font-size: 13px;
      color: #6b7280;
    }
    .meta-item strong {
      color: var(--brand-purple-dark);
      font-weight: 700;
    }
    .tags-container {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 15px;
    }
    .tag-badge {
      background: #fdf2f8;
      color: var(--brand-pink);
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 600;
    }
    
    .tabs-section {
      margin-top: 50px;
      background: #fff;
      border-radius: 30px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--fdf-border);
      overflow: hidden;
    }
    .tabs-header {
      display: flex;
      border-bottom: 1px solid var(--fdf-border);
      overflow-x: auto;
    }
    .tab-btn {
      flex: 1;
      padding: 20px;
      background: transparent;
      border: none;
      font-size: 15px;
      font-weight: 700;
      color: var(--fdf-muted);
      cursor: pointer;
      border-bottom: 3px solid transparent;
      transition: all 0.3s;
      min-width: 150px;
    }
    .tab-btn.active {
      color: var(--brand-purple);
      border-bottom-color: var(--brand-purple);
      background: #fdf2f855;
    }
    .tab-content {
      padding: 40px;
      display: none;
      font-size: 15px;
      line-height: 1.8;
      color: #4b5563;
    }
    .tab-content.active {
      display: block;
      animation: fadeIn 0.5s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Gallery Styling */
    .gallery-container {
      display: flex;
      flex-direction: column;
      gap: 15px;
      width: 100%;
    }
    .main-img-box {
      background: #fff;
      border-radius: 20px;
      height: 400px;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      border: 1px solid var(--fdf-border);
    }
    .main-img-box img {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }
    .thumb-strip {
      display: flex;
      gap: 10px;
      overflow-x: auto;
      padding-bottom: 10px;
    }
    .thumb-box {
      width: 80px;
      height: 80px;
      border-radius: 12px;
      border: 2px solid transparent;
      overflow: hidden;
      cursor: pointer;
      opacity: 0.7;
      transition: all 0.3s;
      flex-shrink: 0;
      background: #fff;
    }
    .thumb-box.active {
      border-color: var(--brand-pink);
      opacity: 1;
    }
    .thumb-box img {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }

    @media (max-width: 992px) {
      .product-detail-container { grid-template-columns: 1fr; }
      .product-info-side { padding: 30px; }
      .product-image-side { height: auto; padding: 20px; }
      .main-img-box { height: 350px; }
      .reviews-grid { grid-template-columns: 1fr; gap: 20px; }
    }
    
    @media (max-width: 768px) {
      body { padding: 20px 10px; }
      .product-detail-container { border-radius: 20px; }
      .product-info-side { padding: 20px; }
      .product-title { font-size: 26px; }
      .main-img-box { height: 280px; }
      .price-box { flex-wrap: wrap; }
      .price-box .current { font-size: 24px; }
      .btn-group { flex-direction: column; gap: 10px; }
      .btn-fdf-main, .btn-fdf-secondary { padding: 15px; }
      .tab-btn { padding: 15px 10px; font-size: 14px; min-width: 130px; }
      .tab-content { padding: 20px; }
      .pincode-input-group { flex-direction: column; }
    }
    
    .reviews-grid {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 40px;
    }
  </style>
</head>
<body>
  <div style="max-width:1100px; margin: 0 auto;">
    <a href="${pageContext.request.contextPath}/women-products" class="back-link">
      <i class="bi bi-arrow-left"></i> Explore More Products
    </a>
    
    <div class="product-detail-container">
      <div class="product-image-side">
        <div class="gallery-container">
          <c:choose>
            <c:when test="${not empty product.imagePath}">
              <div class="main-img-box">
                <img id="mainImage" src="${pageContext.request.contextPath}${product.imagePath}" alt="${product.name}">
              </div>
              <c:if test="${not empty product.additionalImagePaths}">
                <div class="thumb-strip">
                  <div class="thumb-box active" onclick="changeImage(this, '${pageContext.request.contextPath}${product.imagePath}')">
                    <img src="${pageContext.request.contextPath}${product.imagePath}" alt="Thumbnail">
                  </div>
                  <c:forEach var="addImg" items="${fn:split(product.additionalImagePaths, ',')}">
                    <div class="thumb-box" onclick="changeImage(this, '${pageContext.request.contextPath}${addImg}')">
                      <img src="${pageContext.request.contextPath}${addImg}" alt="Thumbnail">
                    </div>
                  </c:forEach>
                </div>
              </c:if>
            </c:when>
            <c:otherwise>
              <div class="placeholder-icon"><i class="bi bi-gift-fill"></i></div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      
      <div class="product-info-side">
        <c:if test="${not empty product.brand}">
          <div class="brand-top">${product.brand}</div>
        </c:if>
        <h1 class="product-title" style="margin-bottom: 8px;">${product.name}</h1>
        
        <div class="ratings-block" onclick="document.getElementById('reviewsSection').scrollIntoView({behavior:'smooth'})" style="cursor:pointer;">
          <div>
            <c:forEach begin="1" end="5" var="i">
              <i class="bi ${i <= avgRating ? 'bi-star-fill' : (i - avgRating < 1 ? 'bi-star-half' : 'bi-star')}"></i>
            </c:forEach>
          </div>
          <span>${avgRating} (${reviewCount} reviews) | ${fn:length(reviews)} sold</span>
        </div>

        <div class="price-box">
          <span class="current">&#8377;${product.price}</span>
          <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
            <span class="original">&#8377;${product.originalPrice}</span>
            <span style="background:#ef4444; color:#fff; padding:4px 8px; border-radius:6px; font-size:11px; font-weight:800;">${Math.round((1 - product.price / product.originalPrice) * 100)}% OFF</span>
          </c:if>
        </div>

        <c:choose>
          <c:when test="${product.stock > 0}">
            <div class="stock-text"><i class="bi bi-check-circle-fill"></i> In Stock (${product.stock} available)</div>
          </c:when>
          <c:otherwise>
            <div class="stock-text" style="color: #dc2626;"><i class="bi bi-x-circle-fill"></i> Out of Stock</div>
          </c:otherwise>
        </c:choose>
        
        <div class="product-desc" style="border:none; padding:0; margin-bottom:15px; font-size:14px;">${product.description}</div>
        
        <div class="highlights-box">
          <h4>Highlights</h4>
          <div class="highlight-item"><i class="bi bi-tag-fill"></i> Category: <strong>${product.category}</strong></div>
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
            <input type="text" id="pincodeInput" class="pincode-input" placeholder="Enter pincode" maxlength="6" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
            <button class="pincode-btn" onclick="checkDelivery()">Check</button>
          </div>
          <div id="deliveryMsg" class="delivery-msg"></div>
        </div>
        
        <div class="seller-badge" style="margin-top: 30px; margin-bottom: 15px; background: #fff; border: 1px solid var(--fdf-border);">
          <i class="bi bi-shop"></i> 
          Seller Information: <strong>${product.seller.businessName}</strong>
        </div>

        <c:if test="${not empty product.tags}">
          <div class="tags-container" style="margin-bottom: 25px;">
            <c:forEach var="tag" items="${fn:split(product.tags, ',')}">
              <span class="tag-badge">#${fn:trim(tag)}</span>
            </c:forEach>
          </div>
        </c:if>

        <div class="btn-group" style="margin-top:20px;">
          <c:if test="${product.stock > 0}">
            <form action="${pageContext.request.contextPath}/women-products/cart/add" method="post" style="flex: 2;">
              <input type="hidden" name="productId" value="${product.id}">
              <button type="submit" class="btn-fdf-main" style="background: #166534; box-shadow: none;">
                <i class="bi bi-cart-plus-fill"></i> Add to Cart
              </button>
            </form>
          </c:if>
          
          <form action="${pageContext.request.contextPath}/women-products/wishlist/toggle" method="post" style="flex: 1;">
            <input type="hidden" name="productId" value="${product.id}">
            <button type="submit" class="btn-fdf-secondary ${inWishlist ? 'active' : ''}">
              <i class="bi ${inWishlist ? 'bi-heart-fill' : 'bi-heart'}"></i>
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- Tabs Section -->
    <div class="tabs-section">
      <div class="tabs-header">
        <c:if test="${not empty product.fullDescription}"><button class="tab-btn active" onclick="openTab(event, 'desc')">Product Description</button></c:if>
        <c:if test="${not empty product.ingredients}"><button class="tab-btn ${empty product.fullDescription ? 'active' : ''}" onclick="openTab(event, 'ing')">Ingredients</button></c:if>
        <c:if test="${not empty product.benefits}"><button class="tab-btn ${empty product.fullDescription && empty product.ingredients ? 'active' : ''}" onclick="openTab(event, 'ben')">Benefits</button></c:if>
        <c:if test="${not empty product.usageInstructions}"><button class="tab-btn ${empty product.fullDescription && empty product.ingredients && empty product.benefits ? 'active' : ''}" onclick="openTab(event, 'use')">How to Use</button></c:if>
      </div>
      
      <c:if test="${not empty product.fullDescription}">
        <div id="desc" class="tab-content active">${product.fullDescription}</div>
      </c:if>
      <c:if test="${not empty product.ingredients}">
        <div id="ing" class="tab-content ${empty product.fullDescription ? 'active' : ''}">${product.ingredients}</div>
      </c:if>
      <c:if test="${not empty product.benefits}">
        <div id="ben" class="tab-content ${empty product.fullDescription && empty product.ingredients ? 'active' : ''}">${product.benefits}</div>
      </c:if>
      <c:if test="${not empty product.usageInstructions}">
        <div id="use" class="tab-content ${empty product.fullDescription && empty product.ingredients && empty product.benefits ? 'active' : ''}">${product.usageInstructions}</div>
      </c:if>
    </div>

    <!-- Reviews Section -->
    <div id="reviewsSection" class="tabs-section" style="margin-top: 30px; margin-bottom: 60px;">
      <div class="tabs-header">
        <button class="tab-btn active">Customer Ratings & Reviews</button>
      </div>
      <div class="tab-content active">
        <c:choose>
          <c:when test="${not empty reviews}">
            <div class="reviews-grid">
              <!-- Rating Summary -->
              <div style="padding: 20px; background: #fafafa; border-radius: 20px; height: fit-content;">
                <div style="font-size: 48px; font-weight: 900; color: var(--brand-purple-dark); line-height: 1;">${avgRating}</div>
                <div style="color: #ffca08; margin: 10px 0; font-size: 20px;">
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

              <!-- Reviews List -->
              <div style="display: flex; flex-direction: column; gap: 20px;">
                <c:forEach var="r" items="${reviews}">
                  <div style="padding: 20px; border-bottom: 1px solid #f0f0f0;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                      <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 36px; height: 36px; border-radius: 10px; background: var(--gradient-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px;">
                          ${not empty r.user.fullName ? r.user.fullName.substring(0,1) : 'U'}
                        </div>
                        <div>
                          <div style="font-weight: 800; font-size: 14px; color: var(--brand-purple-darker);">${r.user.fullName}</div>
                          <div style="font-size: 11px; color: #9ca3af; font-weight: 600;"><i class="bi bi-patch-check-fill" style="color:#16a34a"></i> Verified Purchase</div>
                        </div>
                      </div>
                      <div style="color: #ffca08; font-size: 12px;">
                        <c:forEach begin="1" end="${r.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                        <c:forEach begin="${r.rating + 1}" end="5"><i class="bi bi-star" style="color: #ddd;"></i></c:forEach>
                      </div>
                    </div>
                    <p style="font-size: 14px; color: #4b5563; line-height: 1.6; margin-bottom: 8px;">${r.review}</p>
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
  
  <script>
    function changeImage(element, src) {
      document.getElementById('mainImage').src = src;
      document.querySelectorAll('.thumb-box').forEach(el => el.classList.remove('active'));
      element.classList.add('active');
    }

    function openTab(evt, tabId) {
      document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
      document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
      
      document.getElementById(tabId).classList.add('active');
      if (evt && evt.currentTarget) {
        evt.currentTarget.classList.add('active');
      } else if (window.event && window.event.srcElement) {
        window.event.srcElement.classList.add('active');
      }
    }

    function checkDelivery() {
      const input = document.getElementById('pincodeInput').value.trim();
      const msgBox = document.getElementById('deliveryMsg');
      
      const fakePincodes = ['111111', '222222', '333333', '444444', '555555', '666666', '777777', '888888', '999999', '123456', '654321'];
      if (/^[1-8]\d{5}$/.test(input) && !fakePincodes.includes(input)) {
        // Deterministic pseudo-random days based on pincode
        let sum = 0;
        for (let i = 0; i < input.length; i++) {
          sum += parseInt(input.charAt(i));
        }
        
        // Base days between 2 and 7
        let daysToAdd = (sum % 6) + 2;
        
        // Special fast delivery for certain prefixes (e.g., major metros like 56 for BLR, 11 for DEL, 40 for MUM, 60 for CHN)
        const prefix = input.substring(0, 2);
        if (['56', '11', '40', '60'].includes(prefix)) {
          daysToAdd = (sum % 2) + 1; // 1 to 2 days
        }
        
        const deliveryDate = new Date();
        deliveryDate.setDate(deliveryDate.getDate() + daysToAdd);
        
        const options = { weekday: 'long', day: 'numeric', month: 'short' };
        const dateString = deliveryDate.toLocaleDateString('en-IN', options);
        
        msgBox.className = 'delivery-msg success';
        msgBox.innerHTML = '<i class="bi bi-check-circle-fill"></i> Arriving by <strong>' + dateString + '</strong>';
      } else {
        msgBox.className = 'delivery-msg error';
        msgBox.innerHTML = '<i class="bi bi-exclamation-triangle-fill"></i> Please enter a valid 6-digit pincode.';
      }
    }
  </script>

  <footer style="margin-top: 60px; text-align: center; color: var(--fdf-muted); font-size: 14px; padding-bottom: 40px;">
    <p>Safeher Shop — Empowering women through secure and verified marketplace.</p>
  </footer>
</body>
</html>


