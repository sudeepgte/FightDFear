<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${salon.name} — Reviews | Fight D Fear</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ── CSS Variables ── */
        :root {
            --brand-plum:    #7d265a;
            --brand-purple:  #6a0dad;
            --brand-light:   #ffd6ff;
            --bg-page:       #f7f7fa;
        }

        html, body {
            overflow-x: hidden;
            width: 100%;
            margin: 0;
            padding: 0;
            background: var(--bg-page);
            font-family: 'Poppins', 'Open Sans', sans-serif;
        }

        /* ── Navbar ── */
        .reviews-navbar {
            background: linear-gradient(135deg, var(--brand-plum), var(--brand-purple));
            padding: 14px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 15px rgba(0,0,0,0.2);
        }
        .reviews-navbar .brand {
            color: #fff;
            font-size: 1.25rem;
            font-weight: 700;
            text-decoration: none;
        }
        .reviews-navbar .nav-links {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .reviews-navbar .nav-btn {
            color: #fff;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.35);
            border-radius: 50px;
            padding: 6px 16px;
            text-decoration: none;
            font-size: 0.88rem;
            transition: 0.2s;
        }
        .reviews-navbar .nav-btn:hover {
            background: rgba(255,255,255,0.3);
            color: #fff;
        }

        /* ── Page Layout ── */
        .reviews-page {
            padding: 30px 16px 60px;
        }

        .review-card {
            max-width: 860px;
            margin: 0 auto 30px;
            background: #fff;
            border-radius: 16px;
            padding: 28px 32px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
        }

        /* ── Salon Header ── */
        .salon-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--brand-plum);
            margin-bottom: 4px;
        }
        .salon-meta {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 20px;
        }
        .avg-rating-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, var(--brand-plum), var(--brand-purple));
            color: #fff;
            border-radius: 50px;
            padding: 6px 18px;
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 24px;
        }

        /* ── Individual Review ── */
        .review-item {
            border-bottom: 1px solid #eee;
            padding: 16px 0;
        }
        .review-item:last-child { border-bottom: none; }

        .stars i { color: #f4c430; font-size: 1rem; }
        .reviewer-name { font-weight: 600; color: #333; }
        .review-date { font-size: 0.82rem; color: #999; margin-left: 8px; }
        .review-comment { margin: 8px 0 0; color: #555; line-height: 1.6; }

        .reply-box {
            background: #f8f0ff;
            border-left: 4px solid var(--brand-purple);
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 12px;
            font-size: 0.9rem;
            color: #4a0072;
        }
        .reply-box strong { display: block; margin-bottom: 4px; }

        /* ── Write Review Form ── */
        .write-review-card {
            max-width: 860px;
            margin: 0 auto;
            background: #fff;
            border-radius: 16px;
            padding: 28px 32px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
        }
        .write-review-card h3 {
            color: var(--brand-plum);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: var(--brand-purple);
            box-shadow: 0 0 0 0.2rem rgba(106,13,173,0.2);
        }
        .btn-submit-review {
            background: linear-gradient(135deg, var(--brand-plum), var(--brand-purple));
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 10px 30px;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-submit-review:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(106,13,173,0.35);
        }

        .no-reviews {
            text-align: center;
            color: #888;
            padding: 30px 0;
            font-size: 1rem;
        }

        /* ── Mobile Responsive ── */
        @media (max-width: 576px) {
            .review-card, .write-review-card { padding: 18px 16px; }
            .salon-title { font-size: 1.4rem; }
            .reviews-navbar .brand { font-size: 1.1rem; }
        }
    </style>
</head>
<body>

    <!-- Sticky Navbar -->
    <nav class="reviews-navbar">
        <a class="brand" href="${pageContext.request.contextPath}/users/dashboard">
            <i class="fas fa-spa me-2"></i>Fight D Fear
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/user/salons" class="nav-btn">
                <i class="fas fa-store me-1"></i>Salons
            </a>
            <a href="${pageContext.request.contextPath}/user/salon/view?id=${salon.id}" class="nav-btn">
                <i class="fas fa-arrow-left me-1"></i>Back to Salon
            </a>
            <a href="${pageContext.request.contextPath}/users/dashboard" class="nav-btn">
                <i class="fas fa-th-large me-1"></i>Dashboard
            </a>
        </div>
    </nav>

    <div class="reviews-page">

        <!-- Reviews Card -->
        <div class="review-card">
            <h1 class="salon-title"><i class="fas fa-star me-2" style="color:#f4c430;"></i>${salon.name}</h1>
            <p class="salon-meta">${totalReviews} review<c:if test="${totalReviews != 1}">s</c:if></p>

            <c:if test="${totalReviews > 0}">
                <div class="avg-rating-badge">
                    <i class="fas fa-star"></i> ${averageRating} / 5.0
                </div>
            </c:if>

            <hr>

            <!-- Existing Reviews -->
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-item">
                            <div class="d-flex align-items-center flex-wrap gap-2 mb-1">
                                <div class="stars">
                                    <c:forEach begin="1" end="${review.rating}">
                                        <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:forEach begin="${review.rating+1}" end="5">
                                        <i class="far fa-star"></i>
                                    </c:forEach>
                                </div>
                                <span class="reviewer-name">${review.userName}</span>
                                <span class="review-date">${review.createdAt}</span>
                            </div>
                            <p class="review-comment">${review.comment}</p>
                            <!-- Show salon reply if available -->
                            <c:if test="${not empty review.reply}">
                                <div class="reply-box">
                                    <strong><i class="fas fa-reply me-1"></i>Salon Reply:</strong>
                                    ${review.reply}
                                    <small class="d-block mt-1 text-muted">
                                        <i class="far fa-clock me-1"></i>${review.repliedAt}
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-reviews">
                        <i class="far fa-comment-dots fa-2x mb-2 d-block" style="color:#ccc;"></i>
                        No reviews yet. Be the first to review this salon!
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Write Review Card -->
        <div class="write-review-card" id="addReview">
            <h3><i class="fas fa-pen me-2"></i>Write Your Review</h3>
            <form action="${pageContext.request.contextPath}/salon/reviews/save" method="post">
                <input type="hidden" name="salonId" value="${salon.id}">

                <div class="mb-3">
                    <label for="userName" class="form-label fw-semibold">Your Name</label>
                    <input type="text" name="userName" id="userName" class="form-control" placeholder="Enter your name" required>
                </div>

                <div class="mb-3">
                    <label for="rating" class="form-label fw-semibold">Rating</label>
                    <select name="rating" id="rating" class="form-select" required>
                        <option value="">Select Rating</option>
                        <option value="5">⭐⭐⭐⭐⭐ — Excellent</option>
                        <option value="4">⭐⭐⭐⭐ — Very Good</option>
                        <option value="3">⭐⭐⭐ — Good</option>
                        <option value="2">⭐⭐ — Fair</option>
                        <option value="1">⭐ — Poor</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="comment" class="form-label fw-semibold">Your Comment</label>
                    <textarea name="comment" id="comment" class="form-control" rows="4"
                              placeholder="Share your experience with this salon..." required></textarea>
                </div>

                <button type="submit" class="btn btn-submit-review">
                    <i class="fas fa-paper-plane me-2"></i>Submit Review
                </button>
            </form>
        </div>

    </div><!-- /reviews-page -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
