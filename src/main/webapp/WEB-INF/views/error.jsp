<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error ${status} - Fight D Fear</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: #f8fafc;
            color: #1e293b;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 1.5rem;
        }
        .error-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            max-width: 480px;
            width: 100%;
            padding: 2.5rem 2rem;
            text-align: center;
            border: 1px solid #e2e8f0;
        }
        .status-code {
            font-size: 4rem;
            font-weight: 800;
            color: #e11d48;
            line-height: 1;
            margin-bottom: 0.75rem;
        }
        .error-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 0.75rem;
        }
        .error-desc {
            color: #64748b;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1.5rem;
        }
        .correlation {
            background: #f1f5f9;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8rem;
            color: #475569;
            word-break: break-all;
            margin-bottom: 1.75rem;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        }
        .btn-home {
            display: inline-block;
            background: #e11d48;
            color: #ffffff;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.75rem 1.75rem;
            border-radius: 8px;
            transition: background 0.2s ease;
        }
        .btn-home:hover {
            background: #be123c;
        }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="status-code">${status != null ? status : 500}</div>
        <h1 class="error-title">
            <c:choose>
                <c:when test="${status == 404}">Page Not Found</c:when>
                <c:when test="${status == 403}">Access Denied</c:when>
                <c:when test="${status == 401}">Authentication Required</c:when>
                <c:otherwise>Something went wrong</c:otherwise>
            </c:choose>
        </h1>
        <p class="error-desc">${error != null ? error : "An unexpected error occurred. Please try again later."}</p>
        <c:if test="${not empty correlationId and correlationId ne 'none'}">
            <div class="correlation">
                Reference ID: <c:out value="${correlationId}" />
            </div>
        </c:if>
        <a href="<c:url value='/'/>" class="btn-home">Back to Home</a>
    </div>
<script src="${pageContext.request.contextPath}/resources/js/csrf-sync.js"></script>
</body>
</html>
