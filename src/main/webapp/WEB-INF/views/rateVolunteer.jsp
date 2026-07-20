<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Rate Volunteer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.bundle.min.js"></script>

    <style>
    /* ============================================
       ORIGINAL STYLES (kept exactly as is)
       ============================================ */
    :root {
        --primary-purple: #1e1b4b;
        --primary-purple-light: #312e81;
        --primary-coral: #f43f5e;
        --primary-coral-dark: #1e1b4b;
        --primary-teal: #20c997;
        --primary-gold: #ffd700;
        --dark-bg: #0f0f1a;
        --light-bg: #fffcfd;
        --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #f43f5e 100%);
        --shadow-sm: 0 10px 30px rgba(0, 0, 0, 0.08);
        --shadow-md: 0 20px 40px rgba(0, 0, 0, 0.12);
        --shadow-lg: 0 30px 60px rgba(0, 0, 0, 0.15);
    }

    body {
        background: linear-gradient(to right, var(--light-bg), #e9d5ff);
        font-family: 'Poppins', sans-serif;
        margin: 0;
        padding: 0;
    }
    .review-container {
        max-width: 500px;
        margin: 50px auto;
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: var(--shadow-sm);
        border-top: 5px solid var(--primary-purple-light);
        transition: transform 0.3s ease-in-out, box-shadow 0.3s;
    }
    .review-container:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-md);
    }
    h2 {
        color: var(--primary-purple-light);
        text-align: center;
        font-weight: bold;
        margin-bottom: 20px;
    }
    .form-label {
        font-weight: bold;
        color: var(--primary-purple);
        font-size: 16px;
    }
    .form-control {
        border-radius: 8px;
        border: 1px solid var(--primary-purple-light);
        transition: all 0.3s ease-in-out;
    }
    .form-control:focus {
        border-color: var(--primary-purple-light);
        box-shadow: 0 0 8px rgba(123, 44, 191, 0.5);
        outline: none;
    }
    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: center;
    }
    .star-rating input {
        display: none;
    }
    .star-rating label {
        font-size: 30px;
        color: #ccc;
        cursor: pointer;
        transition: color 0.3s ease-in-out, transform 0.2s ease-in-out;
    }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: var(--primary-gold);
        transform: scale(1.2);
    }
    .btn-submit {
        background: var(--gradient-primary);
        border: none;
        font-weight: bold;
        padding: 12px;
        border-radius: 8px;
        color: white;
        transition: all 0.3s ease-in-out;
    }
    .btn-submit:hover {
        transform: scale(1.03);
        box-shadow: var(--shadow-sm);
        filter: brightness(1.02);
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth fade-in animation for the review container */
    .review-container {
        animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
    }
    @keyframes fadeSlideUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 2. Button ripple effect on click (micro-interaction) */
    .btn-submit {
        position: relative;
        overflow: hidden;
    }
    .btn-submit::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.4);
        transform: translate(-50%, -50%);
        transition: width 0.4s ease, height 0.4s ease;
        pointer-events: none;
    }
    .btn-submit:active::after {
        width: 200px;
        height: 200px;
    }

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .btn-submit:focus-visible,
    .form-control:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 2px;
        border-radius: 8px;
    }

    /* 4. Custom scrollbar (matches brand purple) */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: var(--light-bg);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb {
        background: var(--primary-purple-light);
        border-radius: 10px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary-purple);
    }

    /* 5. Label hover effect – subtle color shift */
    .form-label {
        transition: color 0.2s, transform 0.2s;
        display: inline-block;
    }
    .form-label:hover {
        color: var(--primary-purple-light);
        transform: translateX(2px);
    }

    /* 6. Input placeholder styling (softer) */
    .form-control::placeholder {
        color: rgba(74, 14, 120, 0.4);
        transition: opacity 0.2s;
    }
    .form-control:focus::placeholder {
        opacity: 0.6;
    }

    /* 7. Heading hover effect – subtle text shadow */
    h2 {
        transition: text-shadow 0.2s;
    }
    h2:hover {
        text-shadow: 0 2px 8px rgba(74,14,120,0.15);
    }

    /* 8. Responsive improvements for mobile */
    @media (max-width: 550px) {
        .review-container {
            margin: 30px 20px;
            padding: 20px;
        }
        .btn-submit {
            padding: 14px;
            font-size: 1rem;
        }
        .form-control {
            padding: 12px;
            font-size: 16px; /* prevents zoom on iOS */
        }
        h2 {
            font-size: 1.5rem;
        }
        .star-rating label {
            font-size: 24px;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .review-container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
            
        
</head>
<body>

<div class="container">
    <div class="review-container">
        <h2>Rate Volunteer</h2>
        <form action="${pageContext.request.contextPath}/volunteer/${volunteerId}/addReview" method="post">
            
            <div class="mb-3">
                <label class="form-label">Your Name</label>
                <input type="text" name="reviewerName" class="form-control" placeholder="Enter your name" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Rating</label>
                <div class="star-rating">
                    <input type="radio" name="rating" id="star5" value="5"><label for="star5"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star4" value="4"><label for="star4"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star3" value="3"><label for="star3"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star2" value="2"><label for="star2"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star1" value="1" checked><label for="star1"><i class="fas fa-star"></i></label>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Write Your Review</label>
                <textarea name="reviewText" class="form-control" rows="4" placeholder="Write your review here..." required></textarea>
            </div>

            <button type="submit" class="btn btn-submit w-100">Submit Review</button>

        </form>
    </div>
</div>

</body>
</html>

