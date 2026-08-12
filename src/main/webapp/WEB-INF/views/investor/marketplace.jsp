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
            width: 210px;
            min-width: 210px;
            max-width: 210px;
            background: var(--navy-dark);
            color: white;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            border-radius: 0;
            padding: 20px 0;
            margin: 0;
            z-index: 1000;
            box-shadow: 5px 0 25px rgba(0,0,0,0.08);
        }

        .sidebar-heading {
            padding: 10px 20px 20px;
            font-size: 1.1rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-link {
            background: transparent;
            color: rgba(255,255,255,0.7);
            padding: 10px 20px;
            margin-bottom: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: white;
            background: rgba(255,255,255,0.05);
            border-left-color: var(--coral);
        }

        #page-content-wrapper {
            flex: 1;
            margin-left: 210px;
            padding: 20px 30px;
            overflow-y: auto;
        }

        .proposal-card {
            background: white;
            border-radius: 12px;
            border: 1px solid rgba(0, 0, 0, 0.05); /* Lighter border */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03); /* Thinner shadow */
            transition: all 0.2s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .proposal-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(49, 46, 129, 0.08); /* Minimal lift */
        }

        .proposal-card.premium {
            border-top: 4px solid #ffd700;
            background: white; /* Removed yellow background gradient */
        }

        .proposal-card.featured {
            border-top: 4px solid var(--coral);
        }

        .featured-banner {
            position: absolute;
            top: 10px;
            right: -25px;
            background: var(--coral);
            color: white;
            padding: 3px 25px;
            font-size: 0.6rem;
            font-weight: bold;
            transform: rotate(45deg);
        }

        .premium-badge {
            background: #fff8e1;
            color: #d97706;
            font-size: 0.65rem;
            font-weight: bold;
            padding: 3px 8px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .desc-text {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;  
            overflow: hidden;
            word-wrap: break-word;
            margin-bottom: 12px;
            font-size: 0.8rem;
            color: #64748b;
        }

        @media (max-width: 992px) {
            #wrapper {
                flex-direction: column !important;
            }
            #sidebar-wrapper {
                min-width: 100% !important;
                max-width: 100% !important;
                width: 100% !important;
                height: auto !important;
                position: static !important;
                border-radius: 0 0 20px 20px !important;
                padding: 20px 15px !important;
            }
            #sidebar-wrapper .mt-1 {
                display: flex !important;
                flex-wrap: wrap !important;
                flex-direction: row !important;
                gap: 8px !important;
            }
            .sidebar-link {
                padding: 8px 15px !important;
                border-radius: 20px !important;
                border-left: none !important;
                background: rgba(255, 255, 255, 0.05) !important;
                display: inline-flex !important;
                white-space: nowrap !important;
                margin-bottom: 0 !important;
            }
            .sidebar-link:hover, .sidebar-link.active {
                border-left-color: transparent !important;
                background: var(--coral) !important;
            }
            #page-content-wrapper {
                margin-left: 0 !important;
                padding: 20px 15px !important;
            }
        }
    </style>
</head>
<body>

<div style="display: none; visibility: hidden;">
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
</div>

<div id="wrapper">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading fs-6 pb-3 px-3 mx-2 mb-2">
            <i class="bi bi-wallet2"></i> Investor Panel
        </div>
        <div class="mt-1 d-flex flex-column">
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-house"></i> Home
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/investor/marketplace" class="sidebar-link active">
                <i class="bi bi-shop"></i> Marketplace
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-calendar2-check"></i> My Bookings
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-wallet2"></i> Wallet
            </a>
            <a href="${pageContext.request.contextPath}/investor/dashboard" class="sidebar-link">
                <i class="bi bi-person"></i> Profile
            </a>
            <a href="${pageContext.request.contextPath}/" class="sidebar-link">
                <i class="bi bi-shield-check"></i> Safety Hub Home
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-link text-danger mt-3">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            
            <div class="text-center mb-4 position-relative">
                <h5 class="fw-bold m-0" style="color: var(--navy-dark);"><i class="bi bi-shop"></i> Investor Marketplace</h5>
                <p class="text-muted small m-0 mt-1">Invest in women entrepreneurs and track real-time funding progress.</p>
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
                            
                            <div class="p-3 flex-grow-1">
                                <div class="mb-2 d-flex justify-content-between align-items-center">
                                    <span class="badge bg-light text-secondary border rounded-pill px-2 py-1" style="font-size:0.65rem;">${p.category}</span>
                                    <c:if test="${p.premium}">
                                        <span class="premium-badge"><i class="bi bi-award-fill"></i> Premium</span>
                                    </c:if>
                                </div>

                                <h6 class="fw-bold mb-1 text-navy-emphasis text-truncate">${p.title}</h6>
                                <p class="desc-text">
                                    ${p.description.length() > 100 ? p.description.substring(0, 100).concat("...") : p.description}
                                </p>

                                <div class="d-flex flex-wrap align-items-center gap-2 text-muted mb-3" style="font-size:0.75rem;">
                                    <span><i class="bi bi-geo-alt"></i> ${p.location}</span>
                                    <span class="mx-1">|</span>
                                    <span><i class="bi bi-person-fill"></i> ${p.entrepreneur.fullName}</span>
                                </div>

                                <div class="border-top pt-2">
                                    <div class="d-flex justify-content-between text-muted mb-1" style="font-size:0.75rem;">
                                        <span><strong class="text-success">₹${p.amountRaised}</strong> raised</span>
                                        <span>₹${p.fundingNeeded} target</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: ${(p.amountRaised/p.fundingNeeded)*100}%;"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="p-3 border-top bg-white">
                                <a href="${pageContext.request.contextPath}/investor/proposal/${p.id}" class="btn btn-sm w-100 rounded-pill py-1 text-white fw-semibold" style="background-color: var(--navy-light); border: none; font-size:0.8rem;">
                                    View Details <i class="bi bi-arrow-right-short"></i>
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
