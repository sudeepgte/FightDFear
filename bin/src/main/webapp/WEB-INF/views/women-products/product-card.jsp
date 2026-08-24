<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<article class="product-card">
  <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="product-img-wrapper" style="display:block; text-decoration:none; color:inherit;">
    <c:choose>
      <c:when test="${not empty p.publicImagePath}">
        <img src="<c:choose><c:when test="${p.remoteImage}">${p.publicImagePath}</c:when><c:otherwise>${pageContext.request.contextPath}${p.publicImagePath}</c:otherwise></c:choose>"
             class="product-img" alt="<c:out value='${p.name}'/>">
      </c:when>
      <c:otherwise>
        <div class="product-img-placeholder"><i class="bi bi-gift"></i></div>
      </c:otherwise>
    </c:choose>
    <c:choose>
      <c:when test="${p.stock == null || p.stock <= 0}">
        <span class="stock-badge out"><i class="bi bi-x-circle-fill"></i> Out of Stock</span>
      </c:when>
      <c:when test="${p.lowStockAlertLevel != null && p.stock <= p.lowStockAlertLevel}">
        <span class="stock-badge low"><i class="bi bi-exclamation-triangle-fill"></i> Only ${p.stock} left!</span>
      </c:when>
      <c:otherwise>
        <span class="stock-badge in"><i class="bi bi-check-circle-fill"></i> In Stock</span>
      </c:otherwise>
    </c:choose>
    <c:if test="${p.discountPercent > 0}">
      <span class="offer-badge">${p.discountPercent}% OFF</span>
    </c:if>
  </a>
  <form class="wish-float" action="${pageContext.request.contextPath}/women-products/wishlist/toggle" method="post">
    <input type="hidden" name="productId" value="${p.id}">
    <input type="hidden" name="returnTo" value="shop">
    <button type="submit" title="Wishlist" aria-label="Toggle wishlist">
      <i class="bi ${wishlistIds.contains(p.id) ? 'bi-heart-fill' : 'bi-heart'}"></i>
    </button>
  </form>
  <div class="product-body">
    <div class="product-category"><c:out value="${p.categoryLabel}"/></div>
    <c:if test="${not empty p.brand}"><div class="product-brand"><c:out value="${p.brand}"/></div></c:if>
    <div class="product-name"><c:out value="${p.name}"/></div>
    <div class="product-seller">
      <i class="bi bi-patch-check-fill" style="color:#2563eb;"></i>
      <c:out value="${p.seller.businessName}"/>
      <c:if test="${p.seller.approvedForCatalog}"><span style="font-size:10px;font-weight:800;color:#059669;">Verified seller</span></c:if>
    </div>
    <c:set var="avg" value="${avgRatings[p.id]}"/>
    <c:set var="rc" value="${reviewCounts[p.id]}"/>
    <div class="product-rating">
      <c:choose>
        <c:when test="${avg != null && avg > 0}">
          <i class="bi bi-star-fill"></i> <fmt:formatNumber value="${avg}" maxFractionDigits="1"/> (${rc})
        </c:when>
        <c:otherwise>No ratings yet</c:otherwise>
      </c:choose>
    </div>
    <div class="product-price">
      <span class="current">&#8377;<fmt:formatNumber value="${p.price}" maxFractionDigits="2"/></span>
      <c:if test="${p.discountPercent > 0}">
        <span class="original">&#8377;<fmt:formatNumber value="${p.originalPrice}" maxFractionDigits="2"/></span>
        <span class="discount">${p.discountPercent}% OFF</span>
      </c:if>
    </div>
    <div class="product-actions">
      <a href="${pageContext.request.contextPath}/women-products/view/${p.id}" class="btn-shop btn-shop-outline">
        <i class="bi bi-eye"></i> Details
      </a>
      <c:if test="${p.stock > 0}">
        <form action="${pageContext.request.contextPath}/women-products/cart/add" method="post" style="flex: 1;">
          <input type="hidden" name="productId" value="${p.id}">
          <button type="submit" class="btn-shop btn-shop-primary w-100">
            <i class="bi bi-cart-plus"></i> Add to Cart
          </button>
        </form>
      </c:if>
    </div>
  </div>
</article>
