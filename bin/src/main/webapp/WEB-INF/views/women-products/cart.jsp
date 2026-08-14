<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Shopping Cart — Fight D Fear</title>
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
    .cart-container {
      max-width: 900px;
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
    .page-title i {
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .cart-items-wrapper {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .cart-item {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 24px;
      box-shadow: var(--shadow-sm);
      transition: all 0.3s ease;
    }
    .cart-item:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--brand-pink-light);
    }
    .cart-item img {
      width: 100px;
      height: 100px;
      border-radius: 16px;
      object-fit: cover;
      background: #fdf2f8;
    }
    .cart-item .placeholder {
      width: 100px;
      height: 100px;
      border-radius: 16px;
      background: #fdf2f8;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--brand-pink-light);
      font-size: 32px;
    }
    .cart-info {
      flex: 1;
    }
    .cart-info .name {
      font-size: 18px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin-bottom: 4px;
    }
    .cart-info .seller {
      font-size: 13px;
      color: var(--fdf-muted);
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .cart-info .price {
      font-size: 20px;
      font-weight: 900;
      color: var(--brand-purple);
      margin-top: 10px;
    }

    .cart-qty-control {
      display: flex;
      align-items: center;
      background: #fdf2f8;
      padding: 6px;
      border-radius: 14px;
      gap: 12px;
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
    }
    .qty-btn:hover {
      background: var(--brand-purple);
      color: #fff;
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
      border: none;
      width: 44px;
      height: 44px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 20px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .remove-btn:hover {
      background: #ef4444;
      color: #fff;
      transform: scale(1.1);
    }

    .cart-footer {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 24px;
      padding: 30px;
      margin-top: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: var(--shadow-md);
    }
    .cart-total-label {
      font-size: 15px;
      font-weight: 700;
      color: var(--fdf-muted);
    }
    .cart-total-value {
      font-size: 28px;
      font-weight: 900;
      color: var(--brand-purple-dark);
      margin-top: 4px;
    }

    .btn-checkout-primary {
      padding: 16px 40px;
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      border-radius: 16px;
      font-size: 16px;
      font-weight: 800;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      gap: 12px;
      transition: all 0.3s;
      box-shadow: 0 10px 20px rgba(124, 45, 94, 0.2);
    }
    .btn-checkout-primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3);
      filter: brightness(1.1);
    }

    .empty-cart-state {
      text-align: center;
      padding: 100px 20px;
    }
    .empty-cart-state i {
      font-size: 80px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 24px;
      display: block;
    }

    @media (max-width: 600px) {
      .cart-item { flex-direction: column; align-items: flex-start; }
      .cart-item img, .cart-item .placeholder { width: 100%; height: 200px; }
      .cart-footer { flex-direction: column; gap: 24px; text-align: center; }
      .btn-checkout-primary { width: 100%; justify-content: center; }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
  <div class="cart-container">
    <a href="${pageContext.request.contextPath}/women-products" class="back-link">
      <i class="bi bi-arrow-left"></i> Keep Shopping
    </a>
    
    <div class="page-title"><i class="bi bi-cart3"></i> Your Collection</div>

    <c:if test="${empty cartItems}">
      <div class="empty-cart-state">
        <i class="bi bi-bag-heart"></i>
        <h2>Your collection is currently empty</h2>
        <p>You haven't added anything to your cart yet. Let's find something beautiful!</p>
        <a href="${pageContext.request.contextPath}/women-products" class="btn-checkout-primary mt-4">
          Explore Products
        </a>
      </div>
    </c:if>

    <div class="cart-items-wrapper">
      <c:forEach var="ci" items="${cartItems}">
        <div class="cart-item">
          <c:choose>
            <c:when test="${not empty ci.product.imagePath}">
              <img src="${pageContext.request.contextPath}${ci.product.imagePath}" alt="${ci.product.name}">
            </c:when>
            <c:otherwise>
              <div class="placeholder"><i class="bi bi-gift"></i></div>
            </c:otherwise>
          </c:choose>
          
          <div class="cart-info">
            <div class="name">${ci.product.name}</div>
            <div class="seller">
              <i class="bi bi-patch-check-fill text-primary"></i> 
              ${ci.product.seller.businessName}
            </div>
            <div class="price">&#8377;${ci.product.price}</div>
          </div>
          
          <div class="cart-qty-control">
            <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/update" method="post">
              <input type="hidden" name="quantity" value="${ci.quantity - 1}">
              <button type="submit" class="qty-btn" ${ci.quantity <= 1 ? 'disabled' : ''}>−</button>
            </form>
            <span class="qty-val">${ci.quantity}</span>
            <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/update" method="post">
              <input type="hidden" name="quantity" value="${ci.quantity + 1}">
              <button type="submit" class="qty-btn">+</button>
            </form>
          </div>
          
          <form action="${pageContext.request.contextPath}/women-products/cart/${ci.id}/remove" method="post">
            <button type="submit" class="remove-btn" title="Remove Item">
              <i class="bi bi-trash3"></i>
            </button>
          </form>
        </div>
      </c:forEach>
    </div>

    <c:if test="${not empty cartItems}">
      <div class="cart-footer">
        <div>
          <div class="cart-total-label">Subtotal</div>
          <div class="cart-total-value">&#8377;${cartTotal}</div>
        </div>
        <a href="${pageContext.request.contextPath}/women-products/checkout" class="btn-checkout-primary">
          Check Out Now <i class="bi bi-arrow-right"></i>
        </a>
      </div>
    </c:if>
  </div>
  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </div>
</div>
</body>
</html>


