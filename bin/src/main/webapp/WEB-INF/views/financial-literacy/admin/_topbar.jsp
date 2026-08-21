<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Shared FL Admin topbar. Set request attribute "flAdminTitle" before include. --%>
<div class="topbar">
  <div class="container">
    <div class="wrap">
      <div class="d-flex align-items-center gap-3">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard"
           class="text-decoration-none text-white" style="font-weight: 700;">
          <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
        </a>
      </div>
      <h5>${not empty flAdminTitle ? flAdminTitle : 'Financial Literacy Admin'}</h5>
    </div>
  </div>
</div>
