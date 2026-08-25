<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Shop Preview — ${seller.businessName}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    body.wp-shop-preview {
      margin: 0;
      min-height: 100vh;
      font-family: Inter, sans-serif;
      background: #f8fafc;
      color: #0f172a;
    }
    .wp-preview-top {
      background: #fff;
      border-bottom: 1px solid #fecdd3;
      padding: 12px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }
    .wp-preview-top strong { color: #e11d48; font-weight: 800; }
    .wp-preview-top span { color: #64748b; font-size: 0.88rem; }
    .wp-preview-top a {
      text-decoration: none;
      font-weight: 700;
      font-size: 0.85rem;
      padding: 8px 16px;
      border-radius: 999px;
      background: #F43F5E;
      color: #fff;
    }
    .wp-preview-top a:hover { background: #E11D48; }
    .wp-preview-hero {
      max-width: 1100px;
      margin: 20px auto 0;
      padding: 0 16px;
      text-align: center;
    }
    .wp-preview-hero h1 {
      font-size: 1.75rem;
      font-weight: 800;
      margin: 0 0 6px;
      color: #0f172a;
    }
    .wp-preview-hero p { margin: 0; color: #64748b; font-size: 0.92rem; }
    .wp-preview-cats {
      max-width: 1100px;
      margin: 16px auto 0;
      padding: 0 16px;
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      justify-content: center;
    }
    .wp-preview-cats a {
      padding: 8px 16px;
      border-radius: 999px;
      background: #fff;
      border: 1px solid #e2e8f0;
      color: #64748b;
      text-decoration: none;
      font-size: 0.85rem;
      font-weight: 600;
    }
    .wp-preview-cats a:hover,
    .wp-preview-cats a.active {
      background: #F43F5E;
      color: #fff;
      border-color: #F43F5E;
    }
    .wp-preview-grid {
      max-width: 1100px;
      margin: 20px auto;
      padding: 0 16px 24px;
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
      gap: 16px;
    }
    .wp-preview-card {
      background: #fff;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      box-shadow: 0 2px 12px rgba(0,0,0,0.04);
    }
    .wp-preview-img {
      display: block;
      height: 180px;
      background: #fff1f2;
      position: relative;
      text-decoration: none;
      color: inherit;
    }
    .wp-preview-img img { width: 100%; height: 100%; object-fit: cover; }
    .wp-preview-img .ph {
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 42px;
      color: #F43F5E;
    }
    .wp-preview-body { padding: 14px; display: flex; flex-direction: column; flex: 1; }
    .wp-preview-cat { font-size: 10px; font-weight: 800; text-transform: uppercase; color: #F43F5E; letter-spacing: 0.05em; }
    .wp-preview-name { font-weight: 700; margin: 6px 0; min-height: 38px; font-size: 0.95rem; }
    .wp-preview-seller { font-size: 0.78rem; color: #64748b; margin-bottom: 8px; }
    .wp-preview-seller i { color: #F43F5E; }
    .wp-preview-price .now { font-size: 1.05rem; font-weight: 800; }
    .wp-preview-price .was { font-size: 0.8rem; color: #94a3b8; text-decoration: line-through; margin-left: 6px; }
    .wp-preview-btn {
      margin-top: auto;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      padding: 10px;
      border-radius: 10px;
      background: #F43F5E;
      color: #fff;
      text-decoration: none;
      font-size: 0.85rem;
      font-weight: 700;
    }
    .wp-preview-btn:hover { background: #E11D48; }
    .wp-stock {
      position: absolute; top: 10px; left: 10px;
      padding: 4px 10px; border-radius: 999px; font-size: 10px; font-weight: 800;
      background: #fff; color: #15803d;
    }
    .wp-stock.out { background: #ffe4e6; color: #be123c; }
    .wp-preview-empty {
      max-width: 500px;
      margin: 60px auto;
      text-align: center;
      color: #64748b;
      padding: 0 16px;
    }
    .wp-preview-empty i { font-size: 48px; color: #F43F5E; display: block; margin-bottom: 12px; }
    @media (max-width: 600px) {
      .wp-preview-grid { grid-template-columns: 1fr 1fr; gap: 10px; }
      .wp-preview-img { height: 130px; }
    }
  </style>
</head>
<body class="wp-shop wp-shop-preview">
  <div class="wp-preview-top">
    <div>
      <strong><i class="bi bi-eye"></i> Shop Preview</strong>
      <span> — ${seller.businessName}</span>
    </div>
    <a href="${pageContext.request.contextPath}/women-products/seller/dashboard?section=overview">
      <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <div class="wp-preview-hero">
    <h1>${seller.businessName}</h1>
    <p>
      <c:choose>
        <c:when test="${not empty seller.description}">${seller.description}</c:when>
        <c:otherwise>Preview of your active storefront listings.</c:otherwise>
      </c:choose>
    </p>
  </div>

  <div class="wp-preview-cats">
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview" class="${empty selectedCategory ? 'active' : ''}">All</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=SKINCARE" class="${selectedCategory == 'SKINCARE' ? 'active' : ''}">Skincare</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=HAIRCARE" class="${selectedCategory == 'HAIRCARE' ? 'active' : ''}">Haircare</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=HYGIENE" class="${selectedCategory == 'HYGIENE' ? 'active' : ''}">Hygiene</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=CLOTHING" class="${selectedCategory == 'CLOTHING' ? 'active' : ''}">Clothing</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=ACCESSORIES" class="${selectedCategory == 'ACCESSORIES' ? 'active' : ''}">Accessories</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=WELLNESS" class="${selectedCategory == 'WELLNESS' ? 'active' : ''}">Wellness</a>
    <a href="${pageContext.request.contextPath}/women-products/seller/shop-preview?category=OTHER" class="${selectedCategory == 'OTHER' ? 'active' : ''}">Other</a>
  </div>

  <c:if test="${empty products}">
    <div class="wp-preview-empty">
      <i class="bi bi-bag-heart"></i>
      <h2>No active products yet</h2>
      <p>Add and activate products from your seller dashboard.</p>
    </div>
  </c:if>

  <div class="wp-preview-grid">
    <c:forEach var="p" items="${products}">
      <div class="wp-preview-card">
        <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="wp-preview-img">
          <c:choose>
            <c:when test="${not empty p.publicImagePath}">
              <img src="<c:choose><c:when test="${p.remoteImage}">${p.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${p.publicImagePath}</c:otherwise></c:choose>" alt="<c:out value='${p.name}'/>">
            </c:when>
            <c:otherwise><div class="ph"><i class="bi bi-gift"></i></div></c:otherwise>
          </c:choose>
          <span class="wp-stock ${p.stock > 0 ? '' : 'out'}">${p.stock > 0 ? 'In Stock' : 'Out of Stock'}</span>
        </a>
        <div class="wp-preview-body">
          <div class="wp-preview-cat">${p.categoryLabel}</div>
          <div class="wp-preview-name">${p.name}</div>
          <div class="wp-preview-seller"><i class="bi bi-patch-check-fill"></i> ${seller.businessName}</div>
          <div class="wp-preview-price">
            <span class="now">&#8377;${p.price}</span>
            <c:if test="${p.originalPrice != null && p.originalPrice > p.price}">
              <span class="was">&#8377;${p.originalPrice}</span>
            </c:if>
          </div>
          <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="wp-preview-btn">
            <i class="bi bi-eye"></i> View Details
          </a>
        </div>
      </div>
    </c:forEach>
  </div>

  <jsp:include page="/WEB-INF/views/women-products/wp-footer.jsp" />
</body>
</html>
