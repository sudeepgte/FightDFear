<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Orders — Fight D Fear</title>
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
    .orders-container {
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
    .page-title i { color: var(--brand-pink); }

    .order-card {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 20px;
      margin-bottom: 16px;
      display: flex;
      flex-direction: column;
      box-shadow: var(--shadow-sm);
      transition: all 0.3s ease;
      overflow: hidden;
    }
    .order-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-md);
      border-color: var(--brand-pink-light);
    }
    .order-card-header {
      padding: 16px 24px;
      border-bottom: 1px solid #f3f4f6;
      display: flex;
      align-items: center;
      justify-content: space-between;
      cursor: pointer;
      user-select: none;
      transition: background 0.3s;
    }
    .order-card-header:hover {
      background: #fafafa;
    }
    .order-id-block {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .order-id-icon {
      width: 40px;
      height: 40px;
      background: #fdf2f8;
      color: var(--brand-pink);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 12px;
      font-size: 20px;
    }
    .order-card-body {
      padding: 24px;
      display: flex;
      gap: 24px;
      align-items: center;
    }
    .tracking-toggle-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--brand-purple);
      font-weight: 800;
      font-size: 13px;
      cursor: pointer;
      padding: 8px 16px;
      background: #fdf2f8;
      border-radius: 8px;
      transition: all 0.3s;
    }
    .tracking-toggle-btn:hover {
      background: #fce7f3;
    }
    .tracking-toggle-btn i.bi-chevron-down {
      transition: transform 0.3s;
    }
    .tracking-container {
      animation: fadeIn 0.3s ease;
      margin-top: 15px;
      padding-left: 10px;
      border-left: 2px solid #fdf2f8;
    }
    
    /* Action Buttons (Exchange / Refund) */
    .action-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      font-weight: 800;
      font-size: 13px;
      cursor: pointer;
      padding: 8px 16px;
      border-radius: 8px;
      transition: all 0.3s;
    }
    .exchange-btn {
      color: #ea580c;
      background: #fff7ed;
      border: 1px dashed #ea580c;
    }
    .exchange-btn:hover { background: #ffedd5; }
    
    .refund-btn {
      color: #0284c7;
      background: #f0f9ff;
      border: 1px dashed #0284c7;
    }
    .refund-btn:hover { background: #e0f2fe; }

    .rate-btn {
      color: #ff9800;
      background: #fff3e0;
      border: 1px dashed #ff9800;
    }
    .rate-btn:hover { background: #ffe0b2; }

    /* Rating Stars */
    .star-rating {
      display: flex;
      flex-direction: row-reverse;
      justify-content: center;
      gap: 10px;
      margin: 20px 0;
    }
    .star-rating input { display: none; }
    .star-rating label {
      font-size: 32px;
      color: #ddd;
      cursor: pointer;
      transition: color 0.2s;
    }
    .star-rating label:hover,
    .star-rating label:hover ~ label,
    .star-rating input:checked ~ label {
      color: #ffca08;
    }

    /* Modals */
    .fdf-modal-overlay {
      position: fixed; top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1000;
      display: none;
      align-items: center;
      justify-content: center;
    }
    .fdf-modal-overlay.active { display: flex; }
    .fdf-modal {
      background: #fff;
      border-radius: 20px;
      width: 90%;
      max-width: 500px;
      padding: 24px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.2);
    }
    .modal-header {
      display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
    }
    .modal-title { font-size: 18px; font-weight: 800; color: var(--brand-purple); }
    .close-modal { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
    .fdf-form-group { margin-bottom: 15px; text-align: left; }
    .fdf-form-group label { display: block; font-size: 12px; font-weight: 700; color: #666; margin-bottom: 6px; text-transform: uppercase;}
    .fdf-input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 10px; font-family: 'Poppins', sans-serif; font-size: 14px; }
    .fdf-input:focus { outline: none; border-color: var(--brand-pink); }
    .btn-submit { width: 100%; padding: 14px; background: var(--gradient-primary); color: #fff; border: none; border-radius: 12px; font-size: 15px; font-weight: 800; cursor: pointer; transition: all 0.3s; margin-top: 10px; }
    .btn-submit:hover { filter: brightness(1.1); transform: translateY(-2px); }
    
    .order-img {
      width: 100px;
      height: 100px;
      border-radius: 16px;
      object-fit: cover;
      background: #fdf2f8;
    }
    .placeholder-icon {
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

    .order-info {
      flex: 1;
    }
    .order-info .product-name {
      font-size: 18px;
      font-weight: 800;
      color: var(--brand-purple-dark);
      margin-bottom: 4px;
    }
    .order-info .seller {
      font-size: 13px;
      color: var(--fdf-muted);
      display: flex;
      align-items: center;
      gap: 6px;
    }
    
    .order-meta {
      display: grid;
      grid-template-columns: auto auto;
      gap: 12px 24px;
      margin-top: 12px;
    }
    .meta-item {
      font-size: 12px;
      color: var(--fdf-muted);
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .meta-item i { color: var(--brand-purple); }

    .order-right {
      text-align: right;
      padding-left: 20px;
      border-left: 1px solid #f3f4f6;
    }
    .price-tag {
      font-size: 22px;
      font-weight: 900;
      color: var(--brand-purple);
    }
    .qty-display {
      font-size: 13px;
      color: var(--fdf-muted);
      font-weight: 600;
    }

    .status-badge {
      display: inline-block;
      margin-top: 10px;
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .status-PLACED { background: #fef3c7; color: #92400e; }
    .status-CONFIRMED { background: #dbeafe; color: #1e40af; }
    .status-SHIPPED { background: #f3e8ff; color: #6b21a8; }
    .status-DELIVERED { background: #d1fae5; color: #065f46; }
    .status-CANCELLED { background: #fee2e2; color: #991b1b; }

    /* Order Tracking Styles - Vertical */
    .tracking-wrapper {
      display: flex;
      flex-direction: column;
      gap: 24px;
      position: relative;
      padding-left: 8px;
    }
    .tracking-wrapper::before {
      content: '';
      position: absolute;
      top: 10px;
      bottom: 10px;
      left: 21px; /* 8px padding + 13px half-icon */
      width: 4px;
      height: auto;
      background: #f3f4f6;
      z-index: 1;
    }
    .track-step {
      position: relative;
      z-index: 2;
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 16px;
    }
    .track-icon {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      background: #f3f4f6;
      color: #9ca3af;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      transition: all 0.3s;
    }
    .track-label {
      font-size: 12px;
      font-weight: 800;
      color: #9ca3af;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .track-step.active .track-icon { background: var(--brand-pink); color: #fff; box-shadow: 0 0 0 4px rgba(219,39,119,0.2); }
    .track-step.active .track-label { color: var(--brand-pink); }
    .track-step.completed .track-icon { background: #16a34a; color: #fff; }
    .track-step.completed .track-label { color: #16a34a; }

    .success-alert {
      background: #ecfdf5;
      border: 1px solid #10b98133;
      color: #059669;
      padding: 16px 24px;
      border-radius: 16px;
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 12px;
      box-shadow: 0 4px 12px rgba(16, 185, 129, 0.1);
    }

    .empty-state {
      text-align: center;
      padding: 80px 20px;
      color: var(--fdf-muted);
    }
    .empty-state i {
      font-size: 72px;
      background: var(--gradient-primary);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      margin-bottom: 24px;
      display: block;
    }

    @media (max-width: 700px) {
      .order-card-body { flex-direction: column; align-items: flex-start; gap: 16px; }
      .order-right { text-align: left; padding: 0; border: none; width: 100%; border-top: 1px solid #f3f4f6; padding-top: 16px; }
      .order-meta { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />
    <div id="page-content-wrapper" style="min-height: 100vh; overflow-x: hidden;">
  <div class="orders-container">
    <a href="${pageContext.request.contextPath}/women-products" class="back-link">
      <i class="bi bi-arrow-left"></i> Explore More Products
    </a>
    
    <div class="page-title"><i class="bi bi-box-seam-fill"></i> Your Orders</div>

    <c:if test="${not empty message}">
      <div class="success-alert">
        <i class="bi bi-check-circle-fill"></i> ${message}
      </div>
    </c:if>

    <c:if test="${empty orders}">
      <div class="empty-state">
        <i class="bi bi-journal-text"></i>
        <h2>No order history found</h2>
        <p>You haven't placed any orders yet. Start your journey in our marketplace!</p>
        <a href="${pageContext.request.contextPath}/women-products" class="btn btn-fdf mt-4" style="padding: 12px 30px; text-decoration: none;">Shop Now</a>
      </div>
    </c:if>

    <c:forEach var="o" items="${orders}">
      <div class="order-card">
        <!-- Order Header -->
        <div class="order-card-header" onclick="toggleTrackingFromHeader(this)" style="cursor: pointer;">
          <div class="order-id-block">
            <div class="order-id-icon"><i class="bi bi-box-seam"></i></div>
            <div>
              <div style="font-size: 13px; color: var(--fdf-muted); font-weight: 500; margin-bottom: 2px;">Order Id:</div>
              <div style="font-size: 16px; font-family: 'Montserrat', sans-serif; font-weight: 800; color: var(--brand-purple-dark);">#FDF-FDFPL2808267${o.id}</div>
            </div>
          </div>
        </div>

        <!-- Order Body -->
        <div class="order-card-body">
          <c:choose>
            <c:when test="${not empty o.product.imagePath}">
              <img src="${pageContext.request.contextPath}${o.product.imagePath}" class="order-img" alt="${o.product.name}">
            </c:when>
            <c:otherwise>
              <div class="placeholder-icon"><i class="bi bi-gift"></i></div>
            </c:otherwise>
          </c:choose>
          
          <div class="order-info">
            <div class="product-name">${o.product.name}</div>
            <div class="seller"><i class="bi bi-patch-check-fill text-primary"></i> ${o.seller.businessName}</div>
            
            <div class="order-meta">
              <div class="meta-item"><i class="bi bi-calendar3"></i> ${o.orderTime}</div>
              <div class="meta-item"><i class="bi bi-credit-card"></i> ${o.paymentMethod}</div>
              <div class="meta-item" style="grid-column: span 2;"><i class="bi bi-geo-alt"></i> ${o.shippingAddress}</div>
            </div>
            
            <c:if test="${o.status == 'CANCELLED'}">
              <div style="margin-top:20px; display:inline-block; color: #dc2626; font-weight:800; font-size:12px; background:#fee2e2; padding:8px 16px; border-radius:8px; text-transform:uppercase;">
                <i class="bi bi-x-circle-fill"></i> Order Cancelled
              </div>
            </c:if>
            <c:if test="${o.status != 'CANCELLED'}">
              <c:if test="${o.status != 'DELIVERED'}">
                <div class="dynamic-delivery" data-order-date="${o.orderTime}" data-address="${o.shippingAddress}" style="margin-top: 15px; font-size: 13px; color: #16a34a; font-weight: 700; background: #ecfdf5; display: inline-block; padding: 6px 12px; border-radius: 8px;">
                  <i class="bi bi-truck"></i> Calculating expected delivery...
                </div>
              </c:if>
              
              <div class="order-actions" style="display:flex; gap:10px; flex-wrap:wrap; margin-top:15px;">
                <div class="tracking-toggle-btn" onclick="toggleTracking(this)">
                  <i class="bi bi-geo-alt-fill"></i> Order Tracking <i class="bi bi-chevron-down"></i>
                </div>
                
                <c:if test="${o.status == 'DELIVERED' && empty o.returnRequest}">
                  <c:if test="${empty o.rating}">
                    <div class="action-btn rate-btn" onclick="openRatingModal('${o.id}', '${o.product.name}')">
                      <i class="bi bi-star-fill"></i> Rate & Review
                    </div>
                  </c:if>
                  <c:if test="${not empty o.rating}">
                    <div style="font-size: 12px; color: #ffca08; font-weight: 800; display: flex; align-items: center; gap: 4px; background: #fffbeb; padding: 6px 12px; border-radius: 8px;">
                      <i class="bi bi-check-circle-fill"></i> Rated: ${o.rating} stars
                    </div>
                  </c:if>
                  <div class="action-btn exchange-btn" onclick="openExchangeModal('${o.id}')">
                    <i class="bi bi-arrow-left-right"></i> Exchange
                  </div>
                  <div class="action-btn refund-btn" onclick="openRefundModal('${o.id}')">
                    <i class="bi bi-currency-rupee"></i> Refund
                  </div>
                </c:if>
                <c:if test="${not empty o.returnRequest}">
                  <div style="margin-top:10px; display:inline-block; color: #7c3aed; font-weight:800; font-size:12px; background:#f5f3ff; padding:8px 16px; border-radius:8px; text-transform:uppercase;">
                    <i class="bi bi-info-circle-fill"></i> ${o.returnRequest.type == 'RETURN' ? 'REFUND' : o.returnRequest.type} Status: ${o.returnRequest.status}
                  </div>
                  <c:if test="${o.returnRequest.status == 'COMPLETED' && (o.returnRequest.type == 'REFUND' || o.returnRequest.type == 'RETURN')}">
                    <div style="font-size: 11px; color: #059669; font-weight: 700; margin-top: 6px; padding-left: 10px; display: flex; align-items: center; gap: 6px;">
                      <i class="bi bi-clock-history"></i> By 24 hours your amount will credit to your account
                    </div>
                  </c:if>
                  <c:if test="${o.returnRequest.status == 'COMPLETED' && o.returnRequest.type == 'EXCHANGE'}">
                    <c:set var="arrival" value="<%= new java.util.Date(System.currentTimeMillis() + 259200000L) %>" />
                    <div style="font-size: 11px; color: #059669; font-weight: 700; margin-top: 6px; padding-left: 10px; display: flex; align-items: center; gap: 6px;">
                      <i class="bi bi-truck"></i> Your replacement will arrive by <fmt:formatDate value="${arrival}" pattern="EEEE, dd MMM" />
                    </div>
                  </c:if>
                </c:if>
              </div>
              
              <div class="tracking-container" style="display: none;">
                <div class="tracking-wrapper">
                  <c:set var="placedState" value="${o.status == 'PLACED' ? 'active' : 'completed'}" />
                  <c:set var="confirmedState" value="${o.status == 'CONFIRMED' ? 'active' : (o.status == 'SHIPPED' || o.status == 'DELIVERED' ? 'completed' : '')}" />
                  <c:set var="shippedState" value="${o.status == 'SHIPPED' ? 'active' : (o.status == 'DELIVERED' ? 'completed' : '')}" />
                  <c:set var="deliveredState" value="${o.status == 'DELIVERED' ? 'completed' : ''}" />
                  
                  <div class="track-step ${placedState}"><div class="track-icon"><i class="bi bi-receipt"></i></div><div class="track-label">Placed</div></div>
                  <div class="track-step ${confirmedState}"><div class="track-icon"><i class="bi bi-box-seam"></i></div><div class="track-label">Confirmed</div></div>
                  <div class="track-step ${shippedState}"><div class="track-icon"><i class="bi bi-truck"></i></div><div class="track-label">Shipped</div></div>
                  <div class="track-step ${deliveredState}"><div class="track-icon"><i class="bi bi-house-door"></i></div><div class="track-label">Delivered</div></div>
                </div>
              </div>
            </c:if>
          </div>
          
          <div class="order-right">
            <div class="price-tag">&#8377;${o.totalPrice}</div>
            <div class="qty-display">Quantity: ${o.quantity}</div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
  
  <!-- Exchange Modal -->
  <div class="fdf-modal-overlay" id="exchangeModal">
    <div class="fdf-modal">
      <div class="modal-header">
        <div class="modal-title">Request Exchange</div>
        <button type="button" class="close-modal" onclick="closeModal('exchangeModal')">&times;</button>
      </div>
      <form id="exchangeForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="type" value="EXCHANGE">
        <div class="fdf-form-group">
          <label>Reason for Exchange</label>
          <select name="reason" class="fdf-input" required>
            <option value="">Select a reason</option>
            <option value="damaged">Product Damaged</option>
            <option value="wrong_item">Wrong Item Delivered</option>
            <option value="size_issue">Size / Fit Issue</option>
            <option value="other">Other</option>
          </select>
        </div>
        <div class="fdf-form-group">
          <label>Additional Comments</label>
          <textarea name="comments" class="fdf-input" rows="3" placeholder="Please elaborate on the issue..."></textarea>
        </div>
        <div class="fdf-form-group">
          <label>Upload Product Image</label>
          <input type="file" name="image" class="fdf-input" accept="image/*" required style="padding: 9px;">
        </div>
        <button type="submit" class="btn-submit">Submit Exchange Request</button>
      </form>
    </div>
  </div>

  <!-- Refund Modal -->
  <div class="fdf-modal-overlay" id="refundModal">
    <div class="fdf-modal">
      <div class="modal-header">
        <div class="modal-title">Request Refund</div>
        <button type="button" class="close-modal" onclick="closeModal('refundModal')">&times;</button>
      </div>
      <form id="refundForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="type" value="REFUND">
        <div class="fdf-form-group">
          <label>Refund Reason</label>
          <select name="reason" class="fdf-input" required>
            <option value="">Select a reason</option>
            <option value="quality">Quality not as expected</option>
            <option value="defective">Defective Product</option>
            <option value="not_needed">No longer needed</option>
            <option value="other">Other</option>
          </select>
        </div>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
          <div class="fdf-form-group" style="margin-bottom:0;">
            <label>Bank Holder Name</label>
            <input type="text" name="holderName" class="fdf-input" placeholder="Name as per bank" required>
          </div>
          <div class="fdf-form-group" style="margin-bottom:0;">
            <label>Account Number</label>
            <input type="text" name="accountNumber" class="fdf-input" placeholder="Enter number" required maxlength="18" minlength="9" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
          </div>
        </div>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
          <div class="fdf-form-group" style="margin-bottom:0;">
            <label>IFSC Code</label>
            <input type="text" name="ifsc" class="fdf-input" placeholder="e.g. SBIN0001234" required maxlength="11" oninput="this.value=this.value.toUpperCase().replace(/[^A-Z0-9]/g,'')">
          </div>
          <div class="fdf-form-group" style="margin-bottom:0;">
            <label>Branch Name</label>
            <input type="text" name="branch" class="fdf-input" placeholder="City/Branch" required>
          </div>
        </div>
        <div class="fdf-form-group">
          <label>Additional Comments</label>
          <textarea name="comments" class="fdf-input" rows="2" placeholder="Any additional info..."></textarea>
        </div>
        <button type="submit" class="btn-submit">Submit Refund Request</button>
      </form>
    </div>
  </div>

  <!-- Rating & Feedback Modal -->
  <div class="fdf-modal-overlay" id="ratingModal">
    <div class="fdf-modal">
      <div class="modal-header">
        <div class="modal-title">Rate Your Experience</div>
        <button type="button" class="close-modal" onclick="closeModal('ratingModal')">&times;</button>
      </div>
      <p style="text-align: center; color: var(--fdf-muted); font-size: 14px; margin-bottom: 5px;">How would you rate your purchase of</p>
      <p id="ratingProductName" style="text-align: center; font-weight: 800; color: var(--brand-purple-dark); margin-bottom: 20px;"></p>
      
      <form id="ratingForm">
        <input type="hidden" name="orderId" id="ratingOrderId">
        <div class="star-rating">
          <input type="radio" id="star5" name="rating" value="5" required><label for="star5" class="bi bi-star-fill"></label>
          <input type="radio" id="star4" name="rating" value="4"><label for="star4" class="bi bi-star-fill"></label>
          <input type="radio" id="star3" name="rating" value="3"><label for="star3" class="bi bi-star-fill"></label>
          <input type="radio" id="star2" name="rating" value="2"><label for="star2" class="bi bi-star-fill"></label>
          <input type="radio" id="star1" name="rating" value="1"><label for="star1" class="bi bi-star-fill"></label>
        </div>

        <div class="fdf-form-group">
          <label>Your Feedback</label>
          <textarea name="review" class="fdf-input" rows="3" placeholder="Tell us more about the product..."></textarea>
        </div>
        
        <button type="submit" class="btn-submit" id="submitRatingBtn">Submit Review</button>
        <div id="ratingProcessing" style="display:none; text-align:center; margin-top:10px; font-weight:700; color:var(--brand-purple);">
          <i class="bi bi-arrow-repeat spin"></i> Processing...
        </div>
      </form>
    </div>
  </div>

  <script>
    // Modal Functions
    function openExchangeModal(orderId) {
      document.getElementById('exchangeForm').action = '${pageContext.request.contextPath}/women-products/orders/' + orderId + '/return';
      document.getElementById('exchangeModal').classList.add('active');
    }

    function openRefundModal(orderId) {
      document.getElementById('refundForm').action = '${pageContext.request.contextPath}/women-products/orders/' + orderId + '/return';
      document.getElementById('refundModal').classList.add('active');
    }

    function closeModal(modalId) {
      document.getElementById(modalId).classList.remove('active');
    }

    function openRatingModal(orderId, productName) {
      document.getElementById('ratingOrderId').value = orderId;
      document.getElementById('ratingProductName').innerText = productName;
      document.getElementById('ratingModal').classList.add('active');
    }

    document.getElementById('ratingForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const btn = document.getElementById('submitRatingBtn');
      const processing = document.getElementById('ratingProcessing');
      btn.style.display = 'none';
      processing.style.display = 'block';

      const formData = new FormData(this);
      fetch('${pageContext.request.contextPath}/women-products/order/rate', {
        method: 'POST',
        body: new URLSearchParams(formData)
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'SUCCESS') {
          window.location.reload();
        } else {
          alert("Error submitting review.");
          btn.style.display = 'block';
          processing.style.display = 'none';
        }
      })
      .catch(err => {
        alert("An error occurred.");
        btn.style.display = 'block';
        processing.style.display = 'none';
      });
    });

    function submitForm(event, modalId, message) {
      event.preventDefault();
      alert(message);
      closeModal(modalId);
      event.target.reset();
    }

    function toggleTracking(el) {
      const container = el.closest('.order-card-body').querySelector('.tracking-container');
      const icon = el.querySelector('.bi-chevron-down');
      if (container.style.display === 'none' || container.style.display === '') {
        container.style.display = 'block';
        if(icon) icon.style.transform = 'rotate(180deg)';
      } else {
        container.style.display = 'none';
        if(icon) icon.style.transform = 'rotate(0deg)';
      }
    }
    
    function toggleTrackingFromHeader(el) {
      const card = el.closest('.order-card');
      const toggleBtn = card.querySelector('.tracking-toggle-btn');
      if(toggleBtn) {
        toggleTracking(toggleBtn);
      }
    }

    document.addEventListener('DOMContentLoaded', function() {
      const refundForm = document.getElementById('refundForm');
      if (refundForm) {
        refundForm.addEventListener('submit', function(e) {
          const accNum = this.querySelector('[name="accountNumber"]').value.trim();
          const ifsc = this.querySelector('[name="ifsc"]').value.trim();
          
          if (!/^\d{9,18}$/.test(accNum)) {
            alert("Account number must be between 9 and 18 numeric digits.");
            e.preventDefault();
            return false;
          }
          if (!/^[A-Z]{4}0[A-Z0-9]{6}$/.test(ifsc)) {
            alert("Please enter a valid 11-character Indian IFSC code (e.g. SBIN0001234).");
            e.preventDefault();
            return false;
          }
        });
      }

      const deliveryElements = document.querySelectorAll('.dynamic-delivery');
      
      deliveryElements.forEach(el => {
        const address = el.getAttribute('data-address');
        const orderDateStr = el.getAttribute('data-order-date');
        
        let pincode = null;
        const pinMatch = address.match(/Pincode:\s*(\d{6})/i);
        if (pinMatch) {
          pincode = pinMatch[1];
        } else {
          const anyPinMatch = address.match(/\b(\d{6})\b/);
          if (anyPinMatch) pincode = anyPinMatch[1];
        }
        
        if (pincode) {
          let sum = 0;
          for (let i = 0; i < pincode.length; i++) {
            sum += parseInt(pincode.charAt(i));
          }
          
          let daysToAdd = (sum % 6) + 2;
          const prefix = pincode.substring(0, 2);
          if (['56', '11', '40', '60'].includes(prefix)) {
            daysToAdd = (sum % 2) + 1;
          }
          
          let baseDate = new Date();
          if (orderDateStr) {
             const parsed = new Date(orderDateStr.replace(' ', 'T'));
             if (!isNaN(parsed.getTime())) {
                baseDate = parsed;
             }
          }
          
          baseDate.setDate(baseDate.getDate() + daysToAdd);
          
          const options = { weekday: 'long', day: 'numeric', month: 'short' };
          const dateString = baseDate.toLocaleDateString('en-IN', options);
          
          el.innerHTML = '<i class="bi bi-truck"></i> Expected Delivery: <strong>' + dateString + '</strong>';
        } else {
          el.innerHTML = '<i class="bi bi-truck"></i> Expected Delivery: <strong>Within 3-5 working days</strong>';
        }
      });
    });
  </script>
  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
  <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </div>
</div>
</body>
</html>


