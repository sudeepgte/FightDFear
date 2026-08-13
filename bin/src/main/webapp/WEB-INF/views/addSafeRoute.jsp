<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Safe Route - Fight D Fear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--light-bg) 0%, #ffffff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 28px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .form-container:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .form-header {
            background: var(--gradient-primary);
            padding: 25px 30px;
            color: white;
        }
        .form-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
        }
        .form-header p {
            margin: 8px 0 0;
            opacity: 0.9;
            font-size: 0.9rem;
        }

        form {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: 600;
            color: var(--primary-purple);
            margin-bottom: 6px;
        }
        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid rgba(123, 44, 191, 0.3);
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.2s;
            font-family: inherit;
        }
        input[type="text"]:focus {
            border-color: var(--primary-purple-light);
            outline: none;
            box-shadow: 0 0 0 3px rgba(123, 44, 191, 0.2);
        }

        button {
            background: var(--gradient-primary);
            color: white;
            border: none;
            border-radius: 40px;
            padding: 12px 20px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            width: 100%;
            transition: all 0.2s;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
            filter: brightness(1.02);
        }

        @media (max-width: 550px) {
            .form-header { padding: 20px; }
            .form-header h2 { font-size: 1.4rem; }
            form { padding: 20px; }
        }

        /* ============================================
           🚀 ADDITIONAL ENHANCEMENTS (no existing rules changed)
           ============================================ */

        /* 1. Smooth fade-in animation for the entire form container */
        .form-container {
            animation: slideUpFade 0.5s cubic-bezier(0.2, 0.9, 0.4, 1.1) forwards;
        }
        @keyframes slideUpFade {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 2. Input focus ring enhancement (adds a subtle glow) */
        input[type="text"]:focus {
            border-color: var(--primary-purple-light);
            outline: none;
            box-shadow: 0 0 0 4px rgba(123, 44, 191, 0.15), var(--shadow-sm);
        }

        /* 3. Button ripple effect on click (micro-interaction) */
        button {
            position: relative;
            overflow: hidden;
        }
        button::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
        }
        button:active::after {
            width: 200px;
            height: 200px;
        }

        /* 4. Label hover effect (subtle color shift) */
        label {
            transition: color 0.2s;
        }
        label:hover {
            color: var(--primary-purple-light);
        }

        /* 5. Input icon simulation (using pseudo-element) – optional visual cue */
        .form-group {
            position: relative;
        }
        /* If you want to add an icon, uncomment and adjust; but not required */
        /*
        .form-group::before {
            content: '📍';
            position: absolute;
            left: 15px;
            top: 42px;
            opacity: 0.5;
            pointer-events: none;
        }
        input[type="text"] {
            padding-left: 40px;
        }
        */

        /* 6. Focus outline for keyboard navigation (accessibility) */
        button:focus-visible,
        input:focus-visible {
            outline: 3px solid var(--primary-gold);
            outline-offset: 2px;
            border-radius: 12px;
        }

        /* 7. Subtle gradient text for header (if desired, but keep original colors) */
        .form-header h2 {
            background: linear-gradient(135deg, #fff, var(--primary-gold));
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            text-shadow: none;
        }
        /* Keep original white text for fallback, but add gradient overlay */
        /* This does not break anything – it just makes the title more premium */

        /* 8. Custom scrollbar for the whole page (matches brand colors) */
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

        /* 9. Responsive touch-friendly improvements for buttons */
        @media (max-width: 550px) {
            button {
                padding: 14px 20px;
                font-size: 1rem;
            }
            input[type="text"] {
                padding: 14px 15px;
            }
        }

        /* 10. Loading state simulation (optional – if you add a loading class later) */
        .btn-loading {
            position: relative;
            pointer-events: none;
            opacity: 0.7;
        }
        .btn-loading::before {
            content: '';
            position: absolute;
            width: 18px;
            height: 18px;
            border: 2px solid white;
            border-top-color: transparent;
            border-radius: 50%;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            animation: spin 0.6s linear infinite;
        }
        @keyframes spin {
            to { transform: translate(-50%, -50%) rotate(360deg); }
        }
</style>
</head>
<body>
<div class="form-container">
    <div class="form-header">
        <h2>🛡️ Add Safe Route</h2>
        <p>Help the community by adding a verified safe path</p>
    </div>
    <form action="${pageContext.request.contextPath}/admin/saferoutes/save" method="post">
        <div class="form-group">
            <label>📍 From</label>
            <input type="text" name="fromLocation" required placeholder="Starting point...">
        </div>
        <div class="form-group">
            <label>📍 To</label>
            <input type="text" name="toLocation" required placeholder="Destination...">
        </div>
        <div class="form-group">
            <label>📝 Description</label>
            <input type="text" name="description" placeholder="Optional details (e.g., well-lit, police presence)">
        </div>
        <button type="submit">✓ Save Route</button>
    </form>
</div>
</body>
</html>

