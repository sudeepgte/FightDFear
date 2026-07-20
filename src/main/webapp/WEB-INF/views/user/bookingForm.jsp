<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="today" value="<%= new java.util.Date() %>" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Your Booking | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">

    <style>
        :root {
            --brand-white: #ffffff;
            --brand-soft-pink: #fff5f8;
            --brand-purple-deep: #4c1d95;
            --text-dark: #1e293b;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fdf2f8 0%, #f5f3ff 100%);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .booking-card-white {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 32px;
            width: 100%;
            max-width: 1100px;
            display: flex;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(124, 45, 94, 0.05);
            animation: fadeInScale 0.7s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes fadeInScale {
            from { opacity: 0; transform: scale(0.98) translateY(20px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }

        .visual-panel {
            flex: 0.9;
            background: white;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-right: 1px solid #f1f3f5;
        }

        .form-panel {
            flex: 1.1;
            padding: 60px;
            background: rgba(255, 255, 255, 0.4);
        }

        .badge-category {
            background: var(--brand-soft-pink);
            color: var(--brand-pink);
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: inline-block;
            margin-bottom: 20px;
        }

        .item-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 2.8rem;
            color: var(--brand-purple-darker);
            line-height: 1.1;
            margin-bottom: 25px;
        }

        .description-box {
            font-size: 1rem;
            line-height: 1.8;
            color: var(--text-muted);
            margin-bottom: 40px;
            padding-left: 20px;
            border-left: 4px solid var(--brand-pink-light);
        }

        .price-chip {
            display: inline-flex;
            align-items: center;
            gap: 15px;
            background: var(--brand-purple-darker);
            color: white;
            padding: 12px 25px;
            border-radius: 20px;
            font-weight: 800;
            font-size: 1.4rem;
            box-shadow: 0 10px 20px rgba(76, 29, 149, 0.15);
        }

        .price-chip small {
            font-size: 0.8rem;
            opacity: 0.7;
            font-weight: 400;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-label-premium {
            display: block;
            font-weight: 700;
            font-size: 0.85rem;
            color: var(--brand-purple-dark);
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-premium {
            width: 100%;
            background: white;
            border: 2px solid #f1f3f5;
            border-radius: 16px;
            padding: 14px 20px;
            color: var(--text-dark);
            font-weight: 500;
            transition: all 0.3s ease;
            margin-bottom: 25px;
        }

        .input-premium:focus {
            outline: none;
            border-color: var(--brand-pink);
            box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05);
            background: #fff;
        }

        .btn-confirm-booking {
            width: 100%;
            padding: 20px;
            background: var(--gradient-primary);
            color: white;
            border: none;
            border-radius: 20px;
            font-weight: 800;
            font-size: 1.1rem;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 15px 35px rgba(124, 45, 94, 0.2);
        }

        .btn-confirm-booking:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 45px rgba(124, 45, 94, 0.3);
            filter: brightness(1.05);
        }

        .salon-tag {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
            color: var(--brand-pink);
            font-weight: 700;
            font-size: 0.9rem;
        }

        @media (max-width: 992px) {
            .booking-card-white { flex-direction: column; }
            .visual-panel, .form-panel { padding: 40px; }
            .visual-panel { border-right: none; border-bottom: 1px solid #f1f3f5; }
        }
    </style>
</head>
<body>

    <div class="booking-card-white">
        <!-- Left Panel: Treatment Visuals & Info -->
        <div class="visual-panel">
            <span class="badge-category">${type == 'SERVICE' ? 'Elite Service' : 'Specialized Treatment'}</span>
            <h1 class="item-title">${type == 'SERVICE' ? item.name : item.serviceName}</h1>
            
            <div class="salon-tag">
                <i class="bi bi-geo-alt-fill"></i>
                <span>${item.salon.name}</span>
            </div>

            <div class="description-box">
                <c:choose>
                    <c:when test="${not empty item.description}">
                        ${item.description}
                    </c:when>
                    <c:otherwise>
                        A deeply nourishing facial specially designed for dry skin. This treatment helps restore moisture, improve skin texture, and give a natural glow. It includes cleansing, exfoliation, hydrating mask, and gentle massage to rejuvenate dull and dehydrated skin.
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mt-auto">
                <div class="price-chip">
                    <span>₹${item.price}</span>
                    <small>|</small>
                    <small>${type == 'SERVICE' ? item.durationMinutes : item.duration} MIN</small>
                </div>
            </div>
        </div>

        <!-- Right Panel: Booking Form -->
        <div class="form-panel">
            <div class="d-flex align-items-center gap-3 mb-5">
                <div class="bg-white rounded-circle d-flex align-items-center justify-content-center border" style="width: 50px; height: 50px; color: var(--brand-pink);">
                    <i class="bi bi-person-heart fs-4"></i>
                </div>
                <div>
                    <h5 class="m-0 fw-800">Reservation for</h5>
                    <p class="m-0 text-muted small">${user.fullName}</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/booking/new" method="post">
                <c:choose>
                    <c:when test="${type == 'SERVICE'}">
                        <input type="hidden" name="serviceId" value="${item.id}" />
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="treatmentId" value="${item.id}" />
                    </c:otherwise>
                </c:choose>

                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label-premium">Select Date</label>
                        <input type="date" class="input-premium" name="bookingDate"
                               value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd'/>"
                               min="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd'/>"
                               required/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label-premium">Preferred Time</label>
                        <input type="time" class="input-premium" name="preferredTime" required>
                    </div>
                </div>

                <label class="form-label-premium">Emergency Contact</label>
                <input type="text" class="input-premium" name="emergencyContact" value="${user.phoneNumber}" required placeholder="Active mobile number">

                <label class="form-label-premium">Service Mode</label>
                <select name="bookingType" class="input-premium form-select" id="bookingType" style="background-image: none;">
                    <option value="ONLINE">Visit Parlour</option>
                    <option value="DOOR">At-Home Service</option>
                </select>

                <!-- Door Booking Address -->
                <div id="addressDiv" style="display:none;">
                    <label class="form-label-premium">Service Location</label>
                    <input type="text" class="input-premium" name="address" value="${user.homeAddress}" placeholder="Enter full address for home service">
                </div>

                <!-- Notes -->
                <div id="onlineDiv">
                    <label class="form-label-premium">Notes or Special Requirements</label>
                    <textarea class="input-premium" name="notes" rows="2" placeholder="e.g. Skin sensitivity, specific products..."></textarea>
                </div>

                <button type="submit" class="btn-confirm-booking">
                    Confirm Reservation <i class="bi bi-chevron-right ms-1"></i>
                </button>
            </form>
        </div>
    </div>

    <script>
        const bookingType = document.getElementById("bookingType");
        const addressDiv = document.getElementById("addressDiv");
        const onlineDiv = document.getElementById("onlineDiv");

        function toggleFields() {
            if (bookingType.value === "DOOR") {
                addressDiv.style.display = "block";
            } else {
                addressDiv.style.display = "none";
            }
        }
        bookingType.addEventListener("change", toggleFields);
        window.addEventListener("load", toggleFields);
    </script>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

