<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salon Partner Login — Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <style>
        :root {
            --brand-purple: #1e1b4b;
            --brand-purple-dark: #1e1b4b;
            --brand-purple-darker: #3F1430;
            --brand-pink: #f43f5e;
            --fdf-border: #f1f3f5;
            --fdf-text: #1e293b;
            --fdf-muted: #64748b;
            --gradient-primary: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --error-red: #ef4444;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Poppins', sans-serif; 
            min-height: 100vh; 
            display: flex; 
            background: #fffcfd; 
            color: var(--fdf-text);
        }
        
        .auth-container {
            flex: 1;
            display: flex;
            width: 100%;
        }

        .visual-panel { 
            flex: 1; 
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%); 
            display: flex; 
            flex-direction: column; 
            justify-content: center; 
            align-items: center;
            padding: 80px; 
            position: relative; 
            overflow: hidden; 
            color: white;
        }
        
        .visual-panel .content { position: relative; z-index: 2; }
        .brand-logo { 
            font-size: 2.5rem; 
            font-weight: 800; 
            margin-bottom: 20px; 
            display: flex; align-items: center; gap: 12px;
        }
        .brand-logo i { font-size: 2.22rem; opacity: 0.9; }
        .brand-tagline { 
            font-size: 1.15rem; 
            font-weight: 300; 
            opacity: 0.9; 
            max-width: 380px; 
            line-height: 1.7; 
            margin-bottom: 40px; 
        }

        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 20px; }
        .feature-list li { display: flex; align-items: center; gap: 15px; font-weight: 400; font-size: 0.95rem; }
        .feat-icon { 
            width: 40px; height: 40px; background: rgba(255,255,255,0.15); 
            display: flex; align-items: center; justify-content: center; 
            border-radius: 12px; font-size: 1.1rem; flex-shrink: 0;
        }

        .form-panel { 
            flex: 1.2; display: flex; justify-content: center; align-items: center; padding: 60px; background: #fff;
        }
        .login-card { width: 100%; max-width: 450px; }
        .login-card h2 { 
            font-family: 'Montserrat', sans-serif; 
            font-size: 2.2rem; 
            font-weight: 900; 
            color: var(--brand-purple-darker); 
            margin-bottom: 12px; 
            border-left: 6px solid var(--brand-pink); 
            padding-left: 20px;
            line-height: 1.1;
        }
        .login-card .subtitle { color: var(--fdf-muted); font-size: 1rem; margin-bottom: 40px; padding-left: 26px; }
        
        .fdf-form-group { margin-bottom: 24px; }
        .fdf-form-group label { 
            display: block; font-size: 0.75rem; font-weight: 800; color: var(--brand-purple-dark); 
            margin-bottom: 10px; text-transform: uppercase; letter-spacing: 1px;
        }
        .input-wrapper { position: relative; }
        .input-wrapper i { 
            position: absolute; left: 18px; top: 50%; transform: translateY(-50%); 
            color: var(--brand-purple); opacity: 0.5; font-size: 1.1rem;
        }
        .fdf-input { 
            width: 100%; padding: 15px 15px 15px 50px; border: 2px solid var(--fdf-border); 
            border-radius: 16px; background: #f8fafc; outline: none; transition: 0.3s;
            font-family: inherit; font-weight: 500;
        }
        .fdf-input:focus { border-color: var(--brand-pink); background: #fff; box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05); }

        .form-options { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; font-size: 0.9rem; }
        .remember-me { display: flex; align-items: center; gap: 8px; font-weight: 600; color: var(--fdf-muted); cursor: pointer; }
        .forgot-pass { color: var(--brand-purple); text-decoration: none; font-weight: 700; }

        .btn-fdf-login { 
            width: 100%; padding: 18px; background: var(--gradient-primary); color: #fff; 
            border: none; border-radius: 18px; font-size: 1.1rem; font-weight: 800; 
            cursor: pointer; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 12px;
            box-shadow: 0 10px 25px rgba(124, 45, 94, 0.25);
        }
        .btn-fdf-login:hover { transform: translateY(-2px); filter: brightness(1.1); box-shadow: 0 15px 30px rgba(124, 45, 94, 0.3); }

        .or-divider { display: flex; align-items: center; gap: 15px; margin: 30px 0; color: #cbd5e1; font-weight: 600; font-size: 0.85rem; }
        .or-divider::before, .or-divider::after { content: ''; flex: 1; height: 1px; background: #e2e8f0; }

        .register-link { text-align: center; font-size: 0.95rem; color: var(--fdf-muted); }
        .register-link a { color: var(--brand-pink); text-decoration: none; font-weight: 800; }
        
        .back-home { 
            display: inline-flex; align-items: center; gap: 10px; color: var(--fdf-muted); 
            text-decoration: none; font-size: 0.95rem; font-weight: 600; margin-bottom: 25px; transition: 0.3s;
        }
        .back-home:hover { color: var(--brand-purple); }

        .alert { 
            background: #fef2f2; color: #b91c1c; padding: 15px 20px; border-radius: 14px; 
            font-size: 0.9rem; margin-bottom: 25px; font-weight: 600; border: 1px solid #fee2e2;
            display: flex; align-items: center; gap: 12px;
        }

        @media (max-width: 992px) {
            body, .auth-container { flex-direction: column; }
            .visual-panel {
                min-height: 30vh;
                padding: 50px 30px;
                text-align: center;
            }
            .feature-list { display: none; }
            .brand-tagline { margin: 0 auto; font-size: 1rem; }
            .form-panel {
                padding: 40px 20px;
                border-top-left-radius: 30px;
                border-top-right-radius: 30px;
                margin-top: -30px;
                position: relative;
                z-index: 5;
            }
            .login-card h2 { font-size: 1.8rem; }
        }

        @media (max-width: 480px) {
            .brand-logo { font-size: 2rem; }
            .login-card h2 { font-size: 1.5rem; padding-left: 15px; }
            .fdf-input { padding: 12px 15px 12px 45px; border-radius: 12px; }
            .btn-fdf-login { padding: 16px; border-radius: 14px; }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="visual-panel">
            <div class="content">
                <div class="brand-logo"><i class="bi bi-shield-check"></i> Fight D Fear</div>
                <p class="brand-tagline">Empowering Women's Safety Through Technology. Your safety is our mission — anytime, anywhere.</p>
                
                <ul class="feature-list">
                    <li><span class="feat-icon"><i class="bi bi-star-fill"></i></span> Premium Beauty Safety Standards</li>
                    <li><span class="feat-icon"><i class="bi bi-shield-shaded"></i></span> Verified Salon Professional Network</li>
                    <li><span class="feat-icon"><i class="bi bi-calendar-check-fill"></i></span> Secure Booking Management</li>
                    <li><span class="feat-icon"><i class="bi bi-heart-pulse-fill"></i></span> Women-Centric Wellness Space</li>
                </ul>
            </div>
        </div>

        <div class="form-panel">
            <div class="login-card">
                <a href="${pageContext.request.contextPath}/index.html" class="back-home"><i class="bi bi-arrow-left"></i> Return Home</a>
                
                <h2>Welcome Back 👋</h2>
                <p class="subtitle">Salon Partner Portal</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert"><i class="bi bi-exclamation-octagon-fill"></i> <%= request.getAttribute("error") %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/salons/login" method="post">
                    <div class="fdf-form-group">
                        <label>Username or Email</label>
                        <div class="input-wrapper">
                            <i class="bi bi-envelope"></i>
                            <input type="text" name="username" class="fdf-input" placeholder="Enter your credentials" required>
                        </div>
                    </div>
                    <div class="fdf-form-group">
                        <label>Password</label>
                        <div class="input-wrapper">
                            <i class="bi bi-lock"></i>
                            <input type="password" name="password" class="fdf-input" placeholder="Enter your password" required>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="remember-me">
                            <input type="checkbox" id="rememberMe" style="width:18px; height:18px; accent-color:var(--brand-pink);">
                            Remember me
                        </label>
                        <a href="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-pass">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn-fdf-login">
                        Access Dashboard <i class="bi bi-arrow-right"></i>
                    </button>
                </form>
                
                <div class="or-divider">or</div>

                <p class="register-link">
                    Don't have a partner account? <br>
                    <a href="${pageContext.request.contextPath}/salons/register">Initialize Salon Registration</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>

