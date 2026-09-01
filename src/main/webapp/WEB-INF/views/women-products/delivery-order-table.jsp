<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <c:forEach var="o" items="${list}">
      <tr>
        <td>#ORD-${o.id}</td>
        <td>${not empty o.user && not empty o.user.fullName ? o.user.fullName : 'Customer'}</td>
        <td>${not empty o.seller ? o.seller.address : '-'}</td>
        <td>${o.shippingAddress}</td>
        <td>&#8377;<fmt:formatNumber value="${o.totalPrice}" maxFractionDigits="0"/></td>
        <td><span class="status-pill">${o.status}</span></td>
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
