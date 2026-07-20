<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Payment</title>
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
        }

        body {
            background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            max-width: 500px;
            margin: 0 auto;
        }

        .payment-card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow-md);
            padding: 30px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .payment-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        h2 {
            color: var(--primary-purple);
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }

        .form-label {
            color: var(--primary-purple);
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-control {
            border: 2px solid rgba(123, 44, 191, 0.3);
            border-radius: 12px;
            padding: 12px 15px;
            transition: all 0.2s;
        }
        .form-control:focus {
            border-color: var(--primary-purple-light);
            box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
            outline: none;
        }

        .btn-primary {
            background: var(--gradient-primary);
            border: none;
            border-radius: 40px;
            padding: 12px 20px;
            font-weight: 700;
            font-size: 1.1rem;
            width: 100%;
            transition: all 0.2s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
            filter: brightness(1.02);
        }
        .btn-primary:active {
            transform: translateY(0);
        }

        /* ============================================
           🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
           ============================================ */

        /* 1. Smooth fade-in animation for the payment card */
        .payment-card {
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
        .btn-primary {
            position: relative;
            overflow: hidden;
        }
        .btn-primary::after {
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
        .btn-primary:active::after {
            width: 200px;
            height: 200px;
        }

        /* 3. Focus outline for accessibility (keyboard navigation) */
        .btn-primary:focus-visible,
        .form-control:focus-visible {
            outline: 3px solid var(--primary-gold);
            outline-offset: 3px;
            border-radius: 12px;
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

        /* 8. Responsive touch improvements for very small screens */
        @media (max-width: 480px) {
            .payment-card {
                padding: 20px;
            }
            .btn-primary {
                padding: 14px;
                font-size: 1rem;
            }
            .form-control {
                padding: 14px;
                font-size: 16px; /* prevents zoom on iOS */
            }
            h2 {
                font-size: 1.6rem;
            }
        }

        /* 9. Loading skeleton ready (optional – does nothing by default) */
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        .payment-card.skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
            pointer-events: none;
        }
</style>

</head>


<body>
    <div class="container">
        <h2 class="text-center my-4">Make Payment</h2>
        <form id="paymentForm">
            <div class="mb-3">
                <label class="form-label">Amount</label>
                <input type="number" class="form-control" id="amount" required>
            </div>
            <button type="submit" class="btn btn-primary">Pay Now</button>
        </form>
    </div>

    <script>
        document.getElementById("paymentForm").addEventListener("submit", function(event) {
            event.preventDefault();
            let amount = document.getElementById("amount").value;
            
            fetch("/payment/pay", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ amount: amount })
            }).then(res => res.text()).then(alert);
        });
    </script>
</body>
</html>

