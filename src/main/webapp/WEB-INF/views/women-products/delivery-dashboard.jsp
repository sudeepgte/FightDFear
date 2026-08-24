<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Delivery Dashboard — Women Products</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&family=Montserrat:wght@800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
  <style>
    body { font-family:'Poppins',sans-serif; background:#fdf2f8; margin:0; color:#1e293b; }
    .wrap { max-width:1100px; margin:0 auto; padding:24px 16px 60px; }
    h1 { font-family:Montserrat,sans-serif; color:#3F1430; }
    .stats { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:12px; margin:20px 0; }
    .stat { background:#fff; border-radius:16px; padding:16px; border:1px solid #f1f3f5; }
    .stat h3 { margin:0; font-size:1.4rem; }
    .stat p { margin:4px 0 0; color:#64748b; font-size:0.85rem; font-weight:600; }
    table { width:100%; border-collapse:collapse; background:#fff; border-radius:16px; overflow:hidden; }
    th, td { padding:12px; text-align:left; border-bottom:1px solid #f1f5f9; font-size:0.9rem; }
    th { background:#3F1430; color:#fff; }
    .msg { background:#ecfdf5; color:#047857; padding:10px 14px; border-radius:10px; font-weight:700; }
    .err { background:#fef2f2; color:#b91c1c; padding:10px 14px; border-radius:10px; font-weight:700; }
    .btn { background:linear-gradient(135deg,#1e1b4b,#f43f5e); color:#fff; border:none; padding:6px 12px; border-radius:10px; font-weight:700; cursor:pointer; }
    select { padding:6px 8px; border-radius:8px; border:1px solid #e2e8f0; }
    .top { display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap; }
    a.out { color:#ef4444; font-weight:800; text-decoration:none; }
  </style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <div>
      <h1>Women Products delivery</h1>
      <p>${partner.fullName} · ${partner.email}</p>
    </div>
    <a class="out" href="${pageContext.request.contextPath}/logout">Logout</a>
  </div>
  <c:if test="${not empty message}"><div class="msg">${message}</div></c:if>
  <c:if test="${not empty error}"><div class="err">${error}</div></c:if>
  <c:if test="${not approved}"><div class="err">Waiting for admin approval. You can view this page, but status updates are locked.</div></c:if>
  <div class="stats">
    <div class="stat"><h3>${pickupOrders.size()}</h3><p>Pickup</p></div>
    <div class="stat"><h3>${activeDeliveries.size()}</h3><p>Active deliveries</p></div>
    <div class="stat"><h3>${deliveredOrders.size()}</h3><p>Delivered</p></div>
    <div class="stat"><h3>${assigned.size()}</h3><p>Assigned total</p></div>
  </div>
  <h2>Assigned orders</h2>
  <c:if test="${empty assigned}">
    <p>No assigned Women Products deliveries yet.</p>
  </c:if>
  <c:if test="${not empty assigned}">
    <table>
      <thead>
        <tr>
          <th>Order</th>
          <th>Customer</th>
          <th>Pickup</th>
          <th>Delivery address</th>
          <th>Amount</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="o" items="${assigned}">
          <tr>
            <td>#ORD-${o.id}</td>
            <td>${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer'}</td>
            <td>${not empty o.seller ? o.seller.address : '-'}</td>
            <td>${o.shippingAddress}</td>
            <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0"/></td>
            <td>${o.status}</td>
            <td>
              <c:set var="opts" value="${nextStatuses[o.id]}"/>
              <c:if test="${approved && not empty opts}">
                <form method="post" action="${pageContext.request.contextPath}/women-products/delivery/orders/${o.id}/status">
                  <select name="status">
                    <c:forEach var="st" items="${opts}">
                      <option value="${st}">${st}</option>
                    </c:forEach>
                  </select>
                  <button class="btn" type="submit">Update</button>
                </form>
              </c:if>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>
</body>
</html>
