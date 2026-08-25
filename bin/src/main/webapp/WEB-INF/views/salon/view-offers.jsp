<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offers & Discounts | Fight D Fear</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root { --sidebar-width: 280px; --dashboard-bg: #f8f5ff; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--dashboard-bg); color: var(--brand-purple-darker); overflow-x: hidden; }
        
        .sidebar { background: var(--gradient-dark); color: white; }
        .sidebar-brand { font-family: 'Montserrat', sans-serif; font-weight: 900; font-size: 1.5rem; margin-bottom: 40px; display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .nav-link-custom { display: flex; align-items: center; gap: 15px; padding: 12px 20px; color: rgba(255,255,255,0.7); text-decoration: none; border-radius: 12px; margin-bottom: 8px; transition: all 0.3s ease; font-weight: 500; }
        .nav-link-custom:hover, .nav-link-custom.active { background: rgba(255,255,255,0.1); color: white; transform: translateX(5px); }

        .main-content { padding: 40px; min-height: 100vh; }
        @media (min-width: 992px) {
            .sidebar { width: var(--sidebar-width); height: 100vh; position: fixed; left: 0; top: 0; padding: 30px 20px; z-index: 1000; box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
            .main-content { margin-left: var(--sidebar-width); }
        }

        .page-header { margin-bottom: 30px; display: flex; align-items: center; justify-content: space-between; }
        .page-header h2 { font-weight: 800; color: var(--brand-purple-darker); margin: 0; }
        
        .btn-add-new { background: var(--gradient-primary); color: white; border: none; padding: 12px 30px; border-radius: 12px; font-weight: 700; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 10px; text-decoration: none; }
        .btn-add-new:hover { filter: brightness(1.1); color: white; transform: translateY(-2px); }

        .stat-card { background: white; border-radius: 20px; padding: 25px; border: 1px solid var(--fdf-border); box-shadow: 0 10px 30px rgba(0,0,0,0.02); text-align: center; height: 100%; transition: all 0.3s; }
        .stat-val { font-size: 2.5rem; font-weight: 900; line-height: 1; margin-bottom: 5px; }
        .stat-label { color: #6c757d; font-weight: 600; text-transform: uppercase; font-size: 0.85rem; }

        .offer-card { background: white; border-radius: 24px; padding: 25px; border: 1px solid var(--fdf-border); transition: all 0.3s ease; height: 100%; position: relative; display: flex; flex-direction: column; }
        .offer-card:hover { transform: translateY(-4px); box-shadow: 0 15px 30px rgba(0,0,0,0.05); }
        
        .offer-status { position: absolute; top: 20px; right: 20px; padding: 5px 15px; border-radius: 50px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }
        .status-Active { background: rgba(32, 201, 151, 0.15); color: #20c997; }
        .status-Scheduled { background: rgba(13, 110, 253, 0.15); color: #0d6efd; }
        .status-Expired { background: rgba(108, 117, 125, 0.15); color: #6c757d; }
        .status-Paused { background: rgba(255, 193, 7, 0.15); color: #ffc107; }

        .offer-title { font-weight: 800; color: var(--brand-purple-darker); margin-bottom: 5px; padding-right: 90px; font-size: 1.25rem; }
        .offer-type { font-size: 0.85rem; color: var(--brand-purple); font-weight: 700; text-transform: uppercase; margin-bottom: 15px; }
        
        .offer-desc { color: #6c757d; font-size: 0.9rem; margin-bottom: 15px; flex-grow: 1; }

        .price-tag { background: #f8f5ff; padding: 12px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .price-label { font-size: 0.8rem; color: #6c757d; font-weight: 600; }
        .strike-price { text-decoration: line-through; color: #888; font-size: 0.9rem; font-weight: 600; }
        .final-price { color: #157347; font-weight: 800; font-size: 1.2rem; }
        
        .usage-stats { display: flex; justify-content: space-between; border-top: 1px dashed #eee; padding-top: 15px; margin-bottom: 15px; font-size: 0.85rem; }
        .usage-stat-val { font-weight: 700; color: #333; }

        .offer-actions { display: flex; gap: 8px; }
        .btn-action { flex: 1; padding: 8px; border-radius: 10px; font-weight: 600; border: none; font-size: 0.9rem; transition: all 0.2s; }
        .btn-pause { background: rgba(255, 193, 7, 0.1); color: #d39e00; }
        .btn-pause:hover { background: #ffc107; color: white; }
        .btn-resume { background: rgba(32, 201, 151, 0.1); color: #20c997; }
        .btn-resume:hover { background: #20c997; color: white; }
        .btn-archive { background: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .btn-archive:hover { background: #dc3545; color: white; }
    </style>
</head>
<body>

    <div class="sidebar offcanvas-lg offcanvas-start" tabindex="-1" id="sidebarMenu">
        <a href="${pageContext.request.contextPath}/salons/dashboard" class="sidebar-brand sidebar-brand-desktop">
            <i class="bi bi-stars"></i> <span>Fight D Fear</span>
        </a>
        <nav class="nav flex-column">
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/dashboard"><i class="bi bi-grid-1x2-fill"></i> <span>Dashboard</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile"><i class="bi bi-person-circle"></i> <span>Salon Profile</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/booking/list"><i class="bi bi-calendar-check"></i> <span>Manage Bookings</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/clients"><i class="bi bi-people-fill"></i> <span>Clients</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/stylists"><i class="bi bi-person-badge"></i> <span>Staff / Stylists</span></a>
            <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/packages"><i class="bi bi-box-seam"></i> <span>Packages & Memberships</span></a>
            
            <a class="nav-link-custom active" href="${pageContext.request.contextPath}/salon/viewOffers?salonId=${sessionScope.loggedSalon.id}"><i class="bi bi-tags"></i> <span>Offers & Discounts</span></a>
        </nav>
    </div>

    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <div>
                    <h2 class="fw-800">Salon Offers & Discounts</h2>
                    <p class="text-muted mb-0">Manage actual price reductions and discount rules.</p>
                </div>
                <a href="${pageContext.request.contextPath}/salon/addOffer?salonId=${salonId}" class="btn-add-new">
                    <i class="bi bi-plus-lg"></i> Create Offer
                </a>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <div class="row g-4 mb-5">
                <div class="col-md-3 col-6"><div class="stat-card"><div class="stat-val text-dark">${totalCount}</div><div class="stat-label">Total Offers</div></div></div>
                <div class="col-md-3 col-6"><div class="stat-card"><div class="stat-val text-success">${activeCount}</div><div class="stat-label">Active</div></div></div>
                <div class="col-md-3 col-6"><div class="stat-card"><div class="stat-val text-primary">${scheduledCount}</div><div class="stat-label">Scheduled</div></div></div>
                <div class="col-md-3 col-6"><div class="stat-card"><div class="stat-val text-muted">${expiredCount}</div><div class="stat-label">Expired</div></div></div>
            </div>

            <div class="row g-4">
                <c:forEach var="offer" items="${offers}">
                    <div class="col-xl-4 col-md-6">
                        <div class="offer-card">
                            <c:set var="status" value="${offer.dynamicStatus}" />
                            <div class="offer-status status-${status}">${status}</div>
                            
                            <h4 class="offer-title">${offer.title}</h4>
                            <div class="offer-type"><i class="bi bi-tag-fill me-1"></i> ${offer.offerType}</div>
                            
                            <p class="offer-desc">${offer.description}</p>
                            
                            <div class="price-tag">
                                <div>
                                    <div class="price-label">Original</div>
                                    <div class="strike-price">₹${offer.originalPrice}</div>
                                </div>
                                <div class="text-end">
                                    <div class="price-label">Offer Price</div>
                                    <div class="final-price">₹${offer.discountedPrice > 0 ? offer.discountedPrice : offer.originalPrice}</div>
                                </div>
                            </div>
                            
                            <div class="usage-stats">
                                <div><i class="bi bi-calendar-event me-1"></i> Valid: <span class="usage-stat-val">${offer.startDate} to ${offer.endDate}</span></div>
                            </div>
                            <div class="usage-stats">
                                <div><i class="bi bi-person-check me-1"></i> Used: <span class="usage-stat-val">${offer.usageCount} times</span></div>
                                <c:if test="${offer.totalUsageLimit > 0}">
                                    <div>Limit: <span class="usage-stat-val">${offer.totalUsageLimit}</span></div>
                                </c:if>
                            </div>

                            <div class="offer-actions mt-auto pt-3">
                                <c:choose>
                                    <c:when test="${status == 'Paused'}">
                                        <form action="${pageContext.request.contextPath}/salon/updateOfferStatus" method="POST" class="m-0 flex-grow-1">
                                            <input type="hidden" name="offerId" value="${offer.id}">
                                            <input type="hidden" name="salonId" value="${salonId}">
                                            <input type="hidden" name="status" value="Resume">
                                            <button type="submit" class="btn-action btn-resume w-100"><i class="bi bi-play-circle me-1"></i> Resume</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/salon/updateOfferStatus" method="POST" class="m-0 flex-grow-1">
                                            <input type="hidden" name="offerId" value="${offer.id}">
                                            <input type="hidden" name="salonId" value="${salonId}">
                                            <input type="hidden" name="status" value="Paused">
                                            <button type="submit" class="btn-action btn-pause w-100" ${status == 'Expired' ? 'disabled' : ''}><i class="bi bi-pause-circle me-1"></i> Pause</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                                <form action="${pageContext.request.contextPath}/salon/deleteOffer" method="POST" class="m-0 flex-grow-1" onsubmit="return confirm('Are you sure you want to delete this offer?');">
                                    <input type="hidden" name="offerId" value="${offer.id}">
                                    <input type="hidden" name="salonId" value="${salonId}">
                                    <button type="submit" class="btn-action btn-archive w-100"><i class="bi bi-trash me-1"></i> Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty offers}">
                <div class="text-center py-5">
                    <i class="bi bi-tags text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-4 fw-bold">No Offers Available</h4>
                    <p class="text-muted">Create actual discounts and pricing rules here.</p>
                </div>
            </c:if>

        </div>
    </div>
</body>
</html>

