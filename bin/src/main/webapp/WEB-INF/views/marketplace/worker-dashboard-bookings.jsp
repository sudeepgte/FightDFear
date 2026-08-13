<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Job Bookings - Worker Dashboard</title>

<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">

<style>
    :root {
        --m-purple: #1e1b4b;
        --m-coral: #f43f5e;
        --bg-light: #f8fafc;
    }
    body {
        background-color: var(--bg-light);
        font-family: 'Open Sans', sans-serif;
    }
    .booking-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        padding: 25px;
        margin-bottom: 25px;
    }
    .status-pill {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
    }
    .status-PENDING { background: #fffbeb; color: #d97706; }
    .status-ACCEPTED { background: #e0f2fe; color: #0284c7; }
    .status-PAID { background: #fef9c3; color: #ca8a04; }
    .status-COMPLETED { background: #dcfce7; color: #16a34a; }
    .status-REJECTED { background: #fee2e2; color: #ef4444; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div class="container" style="margin-top: 100px; min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold" style="color: var(--m-purple);"><i class="fas fa-briefcase"></i> My Job Bookings</h2>
        <a href="${pageContext.request.contextPath}/users/dashboard" class="btn btn-outline-secondary rounded-pill">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="booking-card">
        <c:choose>
            <c:when test="${not empty incomingBookings}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Client Name</th>
                                <th>Requested Date & Time</th>
                                <th>Notes</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="wb" items="${incomingBookings}">
                                <tr>
                                    <td>
                                        <div class="fw-bold" style="color: var(--m-purple);">${wb.client.fullName}</div>
                                        <div class="small text-muted">${wb.client.email}</div>
                                        <div class="small text-muted mt-1"><i class="fas fa-phone"></i> ${wb.client.phoneNumber}</div>
                                    </td>
                                    <td>
                                        <div class="small fw-semibold mb-2"><i class="far fa-calendar-alt text-muted"></i> ${wb.bookingDate}</div>
                                        <div class="badge bg-light text-dark border">
                                            <c:if test="${wb.hours != null}"><strong>Hours:</strong> ${wb.hours}</c:if>
                                            <c:if test="${wb.hours == null}"><strong>Custom Offer</strong></c:if>
                                        </div>
                                        <div class="badge bg-success-subtle text-success border border-success-subtle mt-1">
                                            <strong>Total:</strong> &#8377;${wb.totalAmount != null ? wb.totalAmount : 0.0}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="small text-muted fst-italic" style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            ${not empty wb.note ? wb.note : 'No notes'}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-pill status-${wb.status}">${wb.status}</span>
                                    </td>
                                    <td>
                                        <c:if test="${wb.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/marketplace/worker-booking/${wb.id}/status" method="POST" class="d-inline">
                                                <input type="hidden" name="status" value="ACCEPTED">
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 me-1">Accept</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/marketplace/worker-booking/${wb.id}/status" method="POST" class="d-inline">
                                                <input type="hidden" name="status" value="REJECTED">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">Reject</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${wb.status == 'COMPLETED' || wb.status == 'ACCEPTED'}">
                                            <div class="d-flex gap-2 align-items-center mb-2">
                                                <a href="${pageContext.request.contextPath}/chat/window/${wb.client.id}" class="btn btn-sm btn-outline-primary rounded-pill"><i class="fas fa-comment-dots"></i> Chat</a>
                                            </div>
                                            <c:if test="${wb.status == 'ACCEPTED'}">
                                                <form action="${pageContext.request.contextPath}/marketplace/worker-booking/${wb.id}/status" method="POST" class="d-inline">
                                                    <input type="hidden" name="status" value="COMPLETED">
                                                    <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3">Mark Complete</button>
                                                </form>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${wb.status == 'PAID' || wb.status == 'REJECTED'}">
                                            <span class="text-muted small">-</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                    <p class="text-muted fs-5">No incoming job requests yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
