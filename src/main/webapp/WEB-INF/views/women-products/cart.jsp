<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Shopping Cart — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/women-products.css">
  <style>
    :root {
      --cart-bg: #F8FAFC;
      --card-bg: #ffffff;
    }
    body {
      font-family: 'Inter', 'Poppins', sans-serif;
      background: var(--cart-bg);
      color: var(--fdf-text);
      min-height: 100vh;
    }
    .cart-hero {
      background: #fff;
      border-bottom: 1px solid var(--fdf-border);
      padding: 28px 20px 24px;
    }
    .cart-hero-inner {
      max-width: 1000px;
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
    .page-title i {
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .page-subtitle {
      margin: 8px 0 0;
      color: var(--fdf-muted);
      font-size: 0.95rem;
      font-weight: 500;
    }

    .cart-container {
      max-width: 1000px;
      margin: 0 auto;
      padding: 28px 20px 60px;
    }
    .cart-layout {
      display: grid;
      grid-template-columns: 1fr;
      gap: 24px;
    }
    @media (min-width: 900px) {
      .cart-layout.has-items {
        grid-template-columns: 1fr 320px;
        align-items: start;
      }
    }

    .cart-items-wrapper {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .cart-item {
      background: var(--card-bg);
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      padding: 18px;
      display: grid;
      grid-template-columns: 96px 1fr auto;
      gap: 18px;
      align-items: center;
      box-shadow: var(--shadow-sm);
      transition: transform 0.25s ease, box-shadow 0.25s ease;
    }
    .cart-item:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
      border-color: rgba(244, 63, 94, 0.3);
    }
    .cart-item-media {
      width: 96px;
      height: 96px;
      border-radius: 16px;
      overflow: hidden;
      background: #fdf2f8;
      flex-shrink: 0;
    }
    .cart-item-media img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
    .cart-item-media .placeholder {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #f9a8d4;
      font-size: 32px;
    }
    .cart-info { min-width: 0; }
    .cart-info .category {
      font-size: 11px;
      font-weight: 800;
      letter-spacing: 0.05em;
      text-transform: uppercase;
      color: var(--brand-pink);
      margin-bottom: 4px;
    }
    .cart-info .name {
      font-size: 17px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin: 0 0 4px;
      line-height: 1.3;
    }
    .cart-info .name a {
      color: inherit;
      text-decoration: none;
    }
    .cart-info .name a:hover { color: var(--brand-pink); }
    .cart-info .seller {
      font-size: 12px;
      color: var(--fdf-muted);
      display: flex;
      align-items: center;
      gap: 6px;
      font-weight: 600;
    }
    .cart-info .seller i { color: #F43F5E; }
    .cart-info .unit-price {
      margin-top: 8px;
      font-size: 18px;
      font-weight: 900;
      color: var(--brand-purple);
    }
    .cart-info .line-total {
      font-size: 12px;
      color: var(--fdf-muted);
      font-weight: 600;
      margin-top: 2px;
    }

    .cart-controls {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 12px;
    }
    .cart-qty-control {
      display: flex;
      align-items: center;
      background: #fdf2f8;
      padding: 6px;
      border-radius: 14px;
      gap: 10px;
    }
    .qty-btn {
      width: 34px;
      height: 34px;
      border-radius: 10px;
      border: none;
      background: #fff;
      color: var(--brand-purple);
      font-size: 18px;
      font-weight: 800;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
      transition: all 0.2s;
      font-family: inherit;
    }
    .qty-btn:hover:not(:disabled) {
      background: var(--brand-purple);
      color: #fff;
    }
    .qty-btn:disabled {
      opacity: 0.45;
      cursor: not-allowed;
    }
    .qty-val {
      font-size: 15px;
      font-weight: 800;
      min-width: 24px;
      text-align: center;
    }
    .remove-btn {
      background: #fef2f2;
      color: #ef4444;
      border: 1px solid #fee2e2;
      width: 42px;
      height: 42px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .remove-btn:hover {
      background: #ef4444;
      color: #fff;
    }

    .cart-summary {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 24px;
      padding: 24px;
      box-shadow: var(--shadow-md);
      position: sticky;
      top: 20px;
    }
    .cart-summary h2 {
      font-family: 'Montserrat', sans-serif;
      font-size: 1.15rem;
      font-weight: 800;
      color: var(--brand-purple-darker);
      margin: 0 0 18px;
    }
    .summary-row {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      font-size: 14px;
      font-weight: 600;
      color: var(--fdf-muted);
      margin-bottom: 10px;
    }
    .summary-row.total {
      margin-top: 16px;
      padding-top: 16px;
      border-top: 1px solid var(--fdf-border);
      color: var(--brand-purple-dark);
      font-size: 16px;
      font-weight: 800;
    }
    .summary-row.total .value {
      font-size: 24px;
      font-weight: 900;
    }
    .btn-checkout-primary {
      margin-top: 20px;
      width: 100%;
      padding: 16px 24px;
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      border-radius: 16px;
      font-size: 15px;
      font-weight: 800;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      transition: all 0.3s;
      box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
      font-family: inherit;
    }
    .btn-checkout-primary:hover {
      transform: translateY(-2px);
      filter: brightness(1.06);
      color: #fff;
    }
    .continue-link {
      display: block;
      text-align: center;
      margin-top: 14px;
      font-size: 13px;
      font-weight: 700;
      color: var(--brand-purple);
      text-decoration: none;
    }
    .continue-link:hover { color: var(--brand-pink); }

    .empty-cart-state {
      text-align: center;
      padding: 80px 24px;
      background: #fff;
      border-radius: 24px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
      color: var(--fdf-muted);
    }
    .empty-cart-state i {
      font-size: 72px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 20px;
      display: block;
    }
    .empty-cart-state h2 {
      font-family: 'Montserrat', sans-serif;
      font-weight: 800;
      color: var(--brand-purple-darker);
      margin-bottom: 8px;
    }

    @media (max-width: 700px) {
      .cart-container { padding: 20px 14px 48px; }
      .cart-item {
        grid-template-columns: 80px 1fr;
        grid-template-areas:
          "media info"
          "controls controls";
      }
      .cart-item-media { width: 80px; height: 80px; grid-area: media; }
      .cart-info { grid-area: info; }
      .cart-controls {
        grid-area: controls;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
        width: 100%;
      }
    }
  </style>
</head>
<body class="wp-shop">
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
  <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
  <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">

    <div class="cart-hero">
      <div class="cart-hero-inner">
        <a href="${pageContext.request.contextPath}/women-products" class="back-link">
          <i class="bi bi-arrow-left"></i> Keep Shopping
        </a>
        <h1 class="page-title"><i class="bi bi-cart3"></i> Your Cart</h1>
        <p class="page-subtitle">
          <c:choose>
            <c:when test="${empty cartItems}">No items yet — browse the shop to add products.</c:when>
            <c:otherwise>${cartItems.size()} item<c:if test="${cartItems.size() != 1}">s</c:if> in your cart</c:otherwise>
          </c:choose>
        </p>
        <c:if test="${not empty error}">
          <div class="alert alert-danger" style="margin-top:12px;border-radius:10px;padding:12px 14px;font-weight:600;">
            <i class="bi bi-exclamation-circle-fill"></i> ${error}
          </div>
        </c:if>
        <c:if test="${not empty message}">
          <div class="alert alert-success" style="margin-top:12px;border-radius:10px;padding:12px 14px;font-weight:600;">
            <i class="bi bi-check-circle-fill"></i> ${message}
          </div>
        </c:if>
        <div class="wp-subnav" style="justify-content:flex-start;margin-top:14px;">
          <a href="${pageContext.request.contextPath}/women-products">Shop</a>
          <a href="${pageContext.request.contextPath}/women-products/wishlist">Wishlist</a>
          <a class="active" href="${pageContext.request.contextPath}/women-products/cart">Cart</a>
          <a href="${pageContext.request.contextPath}/women-products/my-orders">My Orders</a>
        </div>
      </div>
    </div>

    <div class="cart-container">
      <c:if test="${empty cartItems}">
        <div class="empty-cart-state">
          <i class="bi bi-bag-heart"></i>
          <h2>Your cart is empty</h2>
          <p>You haven’t added anything yet. Discover products made for you.</p>
          <a href="${pageContext.request.contextPath}/women-products" class="btn-checkout-primary" style="max-width: 280px; margin: 24px auto 0;">
            Explore Products
          </a>
        </div>
      </c:if>

      <c:if test="${not empty cartItems}">
        <div class="cart-layout has-items">
          <div class="cart-items-wrapper">
            <c:forEach var="ci" items="${cartItems}">
              <div class="cart-item">
                <a href="${pageContext.request.contextPath}/women-products/view/${ci.product.id}" class="cart-item-media">
                  <c:choose>
                    <c:when test="${not empty ci.product.publicImagePath}">
                      <img src="<c:choose><c:when test="${ci.product.remoteImage}">${ci.product.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${ci.product.publicImagePath}</c:otherwise></c:choose>" alt="<c:out value='${ci.product.name}'/>">
                    </c:when>
                    <c:otherwise>
                      <div class="placeholder"><i class="bi bi-gift"></i></div>
                    </c:otherwise>
                  </c:choose>
                </a>

                <div class="cart-info">
                  <div class="category">${ci.product.categoryLabel}</div>
                  <h3 class="name">
                    <a href="${pageContext.request.contextPath}/women-products/view/${ci.product.id}"><c:out value="${ci.product.name}"/></a>
                  </h3>
                  <div class="seller">
                    <i class="bi bi-patch-check-fill"></i>
                    <c:out value="${ci.product.seller.businessName}"/>
                  </div>
                  <div class="unit-price">&#8377;${ci.product.price}</div>
                  <div class="line-total">Line total: &#8377;${ci.product.price * ci.quantity}</div>
                </div>

                <div class="cart-controls">
                  <div class="cart-qty-control">
                    <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/update" method="post">
                      <input type="hidden" name="quantity" value="${ci.quantity - 1}">
                      <button type="submit" class="qty-btn" ${ci.quantity <= 1 ? 'disabled' : ''} aria-label="Decrease quantity">−</button>
                    </form>
                    <span class="qty-val">${ci.quantity}</span>
                    <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/update" method="post">
                      <input type="hidden" name="quantity" value="${ci.quantity + 1}">
                      <button type="submit" class="qty-btn" aria-label="Increase quantity">+</button>
                    </form>
                  </div>
                  <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/remove" method="post">
                    <button type="submit" class="remove-btn" title="Remove item">
                      <i class="bi bi-trash3"></i>
                    </button>
                  </form>
                </div>
              </div>
            </c:forEach>
          </div>

          <aside class="cart-summary">
            <h2>Order Summary</h2>
            <div class="summary-row">
              <span>Items</span>
              <span>${cartItems.size()}</span>
            </div>
            <div class="summary-row total">
              <span>Subtotal</span>
              <span class="value">&#8377;${cartTotal}</span>
            </div>
            <a href="${pageContext.request.contextPath}/women-products/checkout" class="btn-checkout-primary">
              Checkout <i class="bi bi-arrow-right"></i>
            </a>
            <a href="${pageContext.request.contextPath}/women-products" class="continue-link">
              Continue shopping
            </a>
          </aside>
        </div>
      </c:if>
    </div>

    <jsp:include page="/WEB-INF/views/women-products/wp-footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  </div>
</div>
</body>
</html>
