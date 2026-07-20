<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Terms of Service - Fight D Fear</title>
  <link rel="stylesheet" href="resources/bootstrap/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
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
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
        color: var(--dark-bg);
        margin: 0;
        padding: 50px 20px;
    }

    .terms-container {
        max-width: 1000px;
        margin: auto;
        background-color: #ffffff;
        padding: 50px 40px;
        border-radius: 20px;
        box-shadow: var(--shadow-sm);
        animation: fadeIn 0.6s ease-in-out;
        transition: box-shadow 0.3s ease;
    }
    .terms-container:hover {
        box-shadow: var(--shadow-md);
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    h1 {
        color: var(--primary-purple-light);
        font-weight: 600;
        margin-bottom: 30px;
        text-align: center;
    }

    h3 {
        color: var(--primary-purple);
        margin-top: 35px;
        font-weight: 500;
    }

    p, li {
        font-size: 16px;
        line-height: 1.8;
    }

    ul {
        padding-left: 20px;
    }

    .back-link {
        display: inline-block;
        margin-top: 40px;
        text-decoration: none;
        font-weight: bold;
        color: var(--primary-purple-light);
        border: 1px solid var(--primary-purple-light);
        padding: 10px 20px;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .back-link:hover {
        background-color: var(--primary-purple-light);
        color: white;
        transform: translateY(-2px);
        box-shadow: var(--shadow-sm);
    }

    @media (max-width: 768px) {
        .terms-container {
            padding: 30px 20px;
        }
    }

    /* ============================================
       🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
       ============================================ */

    /* 1. Smooth scroll behavior for anchor links */
    html {
        scroll-behavior: smooth;
    }

    /* 2. Custom scrollbar (matches brand purple) */
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

    /* 3. Focus outlines for accessibility (keyboard navigation) */
    .back-link:focus-visible,
    a:focus-visible {
        outline: 3px solid var(--primary-gold);
        outline-offset: 3px;
        border-radius: 8px;
    }

    /* 4. Back link ripple effect on click (micro-interaction) */
    .back-link {
        position: relative;
        overflow: hidden;
    }
    .back-link::after {
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
    .back-link:active::after {
        width: 200px;
        height: 200px;
    }

    /* 5. Heading hover effects – subtle text shadow and color shift */
    h1, h3 {
        transition: text-shadow 0.2s, color 0.2s;
    }
    h1:hover {
        text-shadow: 0 2px 8px rgba(123,44,191,0.2);
    }
    h3:hover {
        color: var(--primary-purple-light);
        text-shadow: 0 1px 4px rgba(74,14,120,0.1);
    }

    /* 6. List items hover effect – subtle indent and background */
    li {
        transition: transform 0.2s, background 0.2s;
        padding: 2px 4px;
        border-radius: 4px;
    }
    li:hover {
        transform: translateX(4px);
        background: rgba(123,44,191,0.05);
    }

    /* 7. Paragraph hover effect – subtle color change */
    p {
        transition: color 0.2s;
    }
    p:hover {
        color: var(--primary-purple);
    }

    /* 8. Responsive touch improvements for very small screens */
    @media (max-width: 480px) {
        body {
            padding: 30px 15px;
        }
        .terms-container {
            padding: 20px 15px;
        }
        h1 {
            font-size: 1.6rem;
        }
        .back-link {
            padding: 8px 16px;
            font-size: 0.9rem;
        }
    }

    /* 9. Loading skeleton ready (optional – does nothing by default) */
    @keyframes shimmer {
        0% { background-position: -200% 0; }
        100% { background-position: 200% 0; }
    }
    .terms-container.skeleton {
        background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
        background-size: 200% 100%;
        animation: shimmer 1.5s infinite;
        pointer-events: none;
    }
</style>
</head>
<body>
<div class="terms-container">
  <h1>Terms of Service</h1>

  <p>Welcome to <strong>Fight D Fear</strong>. These Terms of Service outline the rules and responsibilities for using our application and related services. By accessing or using our services, you agree to these terms.</p>

  <h3>1. Acceptance of Terms</h3>
  <p>By using our app or website, you confirm that you have read, understood, and agree to be bound by these Terms and our Privacy Policy.</p>

  <h3>2. User Eligibility</h3>
  <p>Our services are available to users aged 13 and above. If under 18, parental consent is required.</p>

  <h3>3. Account Responsibilities</h3>
  <p>You are responsible for maintaining the confidentiality of your account and any activity occurring under it. Sharing accounts is strictly prohibited.</p>

  <h3>4. Emergency Features</h3>
  <p>Emergency tools such as SOS and panic alerts are for real, verified emergencies only. Any misuse may result in suspension or legal action.</p>

  <h3>5. Acceptable Use</h3>
  <p>Users must not:</p>
  <ul>
    <li>Post abusive or misleading content</li>
    <li>Violate laws or third-party rights</li>
    <li>Attempt unauthorized access to our systems</li>
  </ul>

  <h3>6. Privacy</h3>
  <p>We respect your privacy and collect only data necessary to deliver and improve our services. Please refer to our Privacy Policy for full details.</p>

  <h3>7. Location Access</h3>
  <p>Location permissions are used only during emergencies or user-requested tracking features. We do not share your data without consent.</p>

  <h3>8. Intellectual Property</h3>
  <p>All materials on Fight D Fear, including text, graphics, logos, and code, are our intellectual property or used with permission.</p>

  <h3>9. Suspension & Termination</h3>
  <p>We may suspend or terminate your account without prior notice if you breach any of these terms or misuse our services.</p>

  <h3>10. Limitation of Liability</h3>
  <p>While we aim to offer a safe platform, we are not liable for any loss or damage arising from use or inability to use our services.</p>

  <h3>11. Updates to Terms</h3>
  <p>We may revise these Terms of Service periodically. Continued use after updates implies acceptance of the revised terms.</p>

  <h3>12. Contact</h3>
  <p>For questions or support, contact us at <strong>abc@Fight D Fear.app</strong>.</p>

  <a href="${pageContext.request.contextPath}/index.html" class="back-link">← Back to Home</a>
</div>
</body>
</html>


