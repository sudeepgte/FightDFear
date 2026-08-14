<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investment Marketplace — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --navy-dark: #0f172a;
            --navy-light: #1e1b4b;
            --primary: #312e81;
            --coral: #f43f5e;
            --bg-light: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: #0f172a;
        }

        #wrapper {
            display: flex;
            width: 100%;
        }

        #sidebar-wrapper {
            min-width: 260px;
            max-width: 260px;
            background: var(--navy-dark);
            color: white;
            min-height: 100vh;
            border-top-right-radius: 40px;
            padding-top: 30px;
            box-shadow: 10px 0 20px rgba(0,0,0,0.05);
        }

        .sidebar-heading {
            padding: 10px 25px 25px;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 14px 25px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 15px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: white;
            background: rgba(255,255,255,0.05);
            border-left-color: var(--coral);
        }

        #page-content-wrapper {
            flex: 1;
            padding: 40px;
        }

        .proposal-card {
            background: white;
            border-radius: 16px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .proposal-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(49, 46, 129, 0.1);
        }

        .proposal-card.premium {
            border: 2px solid #ffd700;
            background: linear-gradient(180deg, #fffcf0 0%, #ffffff 100%);
        }

        .proposal-card.featured {
            border: 2px solid var(--coral);
        }

        .featured-banner {
            position: absolute;
            top: 15px;
            right: -30px;
            background: var(--coral);
            color: white;
            padding: 4px 30px;
            font-size: 0.7rem;
            font-weight: bold;
            transform: rotate(45deg);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .premium-badge {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            color: #1e1b4b;
            font-size: 0.75rem;
            font-weight: bold;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .progress {
            height: 8px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading">
            <i class="bi bi-wallet2"></i> Investor Panel
        </div>
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link active">
                <i class="bi bi-shop"></i> Marketplace
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-5">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
                <div>
                    <h2 class="fw-bold" style="color: var(--navy-dark);"><i class="bi bi-shop"></i> Investor Marketplace</h2>
                    <p class="text-muted m-0">Invest in women entrepreneurs and track real-time funding progress.</p>
                </div>
            </div>

            <!-- Filters Panel -->
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: 16px;">
                <form action="${pageContext.request.contextPath}/investor/marketplace" method="get">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold text-muted">Filter by Business Category</label>
                            <select name="category" class="form-select">
                                <option value="">All Categories</option>
                                <option value="Tea Shop" ${selectedCategory == 'Tea Shop' ? 'selected' : ''}>Tea Shop</option>
                                <option value="Fruits Shop" ${selectedCategory == 'Fruits Shop' ? 'selected' : ''}>Fruits Shop</option>
                                <option value="Tailoring Shop" ${selectedCategory == 'Tailoring Shop' ? 'selected' : ''}>Tailoring Shop</option>
                                <option value="Beauty Salon" ${selectedCategory == 'Beauty Salon' ? 'selected' : ''}>Beauty Salon</option>
                                <option value="Homemade Food Business" ${selectedCategory == 'Homemade Food Business' ? 'selected' : ''}>Homemade Food Business</option>
                                <option value="Pickle Business" ${selectedCategory == 'Pickle Business' ? 'selected' : ''}>Pickle Business</option>
                                <option value="Boutique" ${selectedCategory == 'Boutique' ? 'selected' : ''}>Boutique</option>
                                <option value="Candle Making" ${selectedCategory == 'Candle Making' ? 'selected' : ''}>Candle Making</option>
                                <option value="Soap Making" ${selectedCategory == 'Soap Making' ? 'selected' : ''}>Soap Making</option>
                                <option value="Dairy Business" ${selectedCategory == 'Dairy Business' ? 'selected' : ''}>Dairy Business</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold text-muted">Filter by Business Location</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g. city or state" value="${selectedLocation}">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100 rounded-pill py-2" style="background-color: var(--primary); border: none;">
                                <i class="bi bi-filter"></i> Apply
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Marketplace Grid -->
            <div class="row g-4">
                <c:forEach var="p" items="${proposals}">
                    <div class="col-md-6 col-lg-4">
                        <div class="proposal-card ${p.premium ? 'premium' : ''} ${p.featured ? 'featured' : ''}">
                            <c:if test="${p.featured}">
                                <div class="featured-banner">PINNED</div>
                            </c:if>
                            
                            <div class="p-4 flex-grow-1">
                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                    <span class="badge bg-secondary rounded-pill px-2 py-1" style="font-size:0.75rem;">${p.category}</span>
                                    <c:if test="${p.premium}">
                                        <span class="premium-badge"><i class="bi bi-award-fill"></i> Premium</span>
                                    </c:if>
                                </div>

                                <h5 class="fw-bold mb-2 text-navy-emphasis">${p.title}</h5>
                                <p class="text-secondary small mb-3" style="min-height: 50px;">
                                    ${p.description.length() > 100 ? p.description.substring(0, 100).concat("...") : p.description}
                                </p>

                                <div class="d-flex align-items-center gap-2 text-muted small mb-3">
                                    <i class="bi bi-geo-alt"></i> <span>${p.location}</span>
                                    <span class="mx-1">|</span>
                                    <i class="bi bi-person-fill"></i> <span>${p.entrepreneur.fullName}</span>
                                </div>

                                <div class="border-top pt-3">
                                    <div class="d-flex justify-content-between small text-muted mb-1">
                                        <span>₹${p.amountRaised} raised</span>
                                        <span>₹${p.fundingNeeded} target</span>
                                    </div>
                                    <div class="progress mb-2">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: ${(p.amountRaised/p.fundingNeeded)*100}%;"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="p-4 border-top bg-light">
                                <a href="${pageContext.request.contextPath}/investor/proposal/${p.id}" class="btn btn-navy w-100 rounded-pill py-2 text-white" style="background-color: var(--navy-light); border: none;">
                                    Open Proposal <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty proposals}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-shop-window" style="font-size:4rem; color:var(--primary);"></i>
                        <h5 class="fw-bold mt-3">No Proposals Found</h5>
                        <p class="small">Try adjusting your category or location filters.</p>
                    </div>
                </c:if>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
