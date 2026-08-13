<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${center.name} — Center Profile</title>

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --maroon: #1e1b4b;
            --maroon-light: #312e81;
            --maroon-dark: #0b0920;
            --maroon-pale: #fdf2f8;
            --maroon-border: rgba(125, 42, 90, 0.15);
            --shadow-lg: 0 15px 35px rgba(125, 42, 90, 0.12);
        }

        body {
            background-color: #fcfcfd;
            font-family: 'Poppins', sans-serif;
            color: #1f2937;
            margin: 0;
            padding-bottom: 50px;
        }

        /* ── TOPBAR ── */
        .top-nav {
            background: var(--maroon);
            padding: 14px 0;
            margin-bottom: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .top-nav .brand {
            color: #fff;
            font-size: 1.25rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ── PROFILE CARD ── */
        .profile-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .profile-card {
            background: #fff;
            border-radius: 24px;
            border: 1px solid var(--maroon-border);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .profile-header {
            background: linear-gradient(135deg, var(--maroon) 0%, var(--maroon-light) 100%);
            padding: 40px;
            color: #fff;
            text-align: center;
        }
        .profile-header h2 {
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.02em;
        }

        .content-wrap {
            padding: 40px;
        }

        /* Profile Image */
        .img-container {
            position: relative;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border: 4px solid #fff;
            background: #fff;
        }
        .profile-img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: transform 0.5s;
        }
        .img-container:hover .profile-img {
            transform: scale(1.05);
        }

        /* Details */
        .info-label {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--maroon-light);
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }
        .info-value {
            font-size: 1rem;
            color: #374151;
            margin-bottom: 20px;
            font-weight: 500;
        }
        .info-value i {
            color: var(--maroon);
            width: 20px;
            margin-right: 8px;
        }

        /* List Group */
        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--maroon-dark);
            margin: 30px 0 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--maroon-border);
        }

        .type-item {
            background: var(--maroon-pale);
            border: 1px solid var(--maroon-border);
            border-radius: 12px;
            padding: 12px 18px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s;
        }
        .type-item:hover {
            transform: translateX(5px);
            border-color: var(--maroon-light);
            background: #fff;
        }
        .type-name { font-weight: 600; color: var(--maroon-dark); }
        .type-cost { font-weight: 700; color: #059669; }

        /* Buttons */
        .btn-action-group {
            margin-top: 40px;
            display: flex;
            gap: 12px;
        }
        .btn-edit {
            background: var(--maroon);
            color: #fff;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 600;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
        }
        .btn-edit:hover {
            background: var(--maroon-dark);
            transform: translateY(-2px);
            color: #fff;
            box-shadow: 0 4px 12px rgba(125,42,90,0.2);
        }
        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 600;
            border: 1px solid #fecaca;
            transition: all 0.2s;
        }
        .btn-delete:hover {
            background: #dc2626;
            color: #fff;
            transform: translateY(-2px);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #6b7280;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 20px;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--maroon); }

    </style>
</head>
<body>

<nav class="top-nav">
    <div class="container">
        <a href="#" class="brand">
            <i class="fas fa-shield-alt"></i> Fight D Fear Center Portal
        </a>
    </div>
</nav>

<div class="container">
    <div class="profile-container">
        
        <c:choose>
            <c:when test="${not empty sessionScope.admin}">
                <a href="${pageContext.request.contextPath}/admin/martialManagement" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
                </a>
            </c:when>
            <c:when test="${not empty sessionScope.loggedCentre}">
                <a href="${pageContext.request.contextPath}/centres/dashboard1" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to My Dashboard
                </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:history.back()" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </c:otherwise>
        </c:choose>

        <div class="profile-card">
            <div class="profile-header">
                <h2>${center.name}</h2>
            </div>

            <div class="content-wrap">
                <div class="row g-5">
                    <div class="col-md-5">
                        <div class="img-container">
                            <c:choose>
                                <c:when test="${not empty center.profilePhoto}">
                                    <img src="${pageContext.request.contextPath}${center.profilePhoto}" class="profile-img" alt="Center Photo">
                                </c:when>
                                <c:otherwise>
                                    <div class="profile-img d-flex align-items-center justify-content-center bg-light" style="height: 300px;">
                                        <i class="fas fa-building fa-4x text-muted opacity-25"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-md-7">
                        <div class="info-label">Contact Email</div>
                        <div class="info-value"><i class="fas fa-envelope"></i> ${center.email}</div>

                        <div class="info-label">Phone Number</div>
                        <div class="info-value"><i class="fas fa-phone"></i> ${center.phoneNumber}</div>

                        <div class="info-label">Base Location</div>
                        <div class="info-value"><i class="fas fa-map-marker-alt"></i> ${center.location}</div>

                        <div class="section-title">Training Programs</div>
                        <div class="types-list">
                            <c:forEach var="type" items="${types}">
                                <div class="type-item">
                                    <span class="type-name">${type.name}</span>
                                    <span class="type-cost">₹${type.cost}</span>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="btn-action-group">
                            <form action="${pageContext.request.contextPath}/centres/delete/${center.id}" method="post" class="m-0" 
                                  onsubmit="return confirm('Are you sure you want to permanently delete this center?');">
                                <button type="submit" class="btn-delete">
                                    <i class="fas fa-trash-alt me-2"></i> Delete Account
                                </button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

