<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Event Host Login | Fight D Fear</title>
    
    <link href="${pageContext.request.contextPath}/assets/img/favicon.png" rel="icon">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1e1b4b;
            --primary-accent: #f43f5e;
            --primary-light: #f8fafc;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-clr: #e2e8f0;
            --gradient-main: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; min-height: 100vh; display: block; color: var(--text-dark); background: white; }
        
        .split-layout { display: flex; width: 100%; min-height: 100vh; }
        
        /* Left Panel */
        .left-panel {
            flex: 0.8;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 40%, #f43f5e 100%);
            padding: 60px 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-right: 1px solid var(--border-clr);
            position: relative;
        }
        .icon-circle {
            width: 70px; height: 70px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin-bottom: 40px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .welcome-title { font-size: 2.8rem; font-weight: 800; line-height: 1.15; margin-bottom: 20px; color: white; }
        .welcome-title span { color: var(--primary-accent); }
        .welcome-desc { color: rgba(255,255,255,0.9); font-size: 1.1rem; line-height: 1.6; margin-bottom: 50px; max-width: 90%; font-weight: 300; }
        
        .feature-item { display: flex; align-items: flex-start; gap: 20px; margin-bottom: 30px; }
        .feature-icon { 
            width: 50px; height: 50px; min-width: 50px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }
        .feature-text h5 { font-size: 1.05rem; font-weight: 700; margin-bottom: 5px; color: white; }
        .feature-text p { font-size: 0.95rem; color: rgba(255,255,255,0.8); margin: 0; line-height: 1.5; }
        
        /* Right Panel */
        .right-panel {
            flex: 1.2;
            padding: 60px 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: white;
            overflow-y: auto;
        }
        
        .form-container { width: 100%; max-width: 480px; }
        
        .form-header { display: flex; align-items: center; gap: 15px; margin-bottom: 40px; }
        .form-header .icon {
            width: 45px; height: 45px; border-radius: 12px; border: 1.5px solid var(--border-clr); background: var(--primary-light);
            color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.4rem;
        }
        .form-header h2 { font-size: 1.8rem; font-weight: 800; color: var(--text-dark); margin: 0; font-family: 'Montserrat', sans-serif; border-left: 5px solid var(--primary-accent); padding-left: 15px; }
        
        .input-group-custom { margin-bottom: 25px; position: relative; }
        .input-group-custom label { display: block; font-size: 0.9rem; font-weight: 600; margin-bottom: 10px; color: var(--text-dark); }
        .input-wrap { position: relative; }
        .input-wrap i.prefix { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #a1a1aa; font-size: 1.2rem; }
        .input-wrap i.suffix { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #a1a1aa; font-size: 1.2rem; cursor: pointer; }
        
        .input-wrap input {
            width: 100%; padding: 14px 15px 14px 45px; border: 1.5px solid var(--border-clr);
            border-radius: 8px; font-family: inherit; font-size: 0.95rem; color: var(--text-dark); outline: none; transition: 0.2s;
        }
        .input-wrap input::placeholder { color: #a1a1aa; font-weight: 400; }
        .input-wrap input:focus { border-color: var(--primary-accent); box-shadow: 0 0 0 4px rgba(219,39,119,0.05); background: white; }
        
        .btn-submit {
            width: 100%; padding: 18px; background: var(--gradient-main); color: white;
            border: none; border-radius: 12px; font-family: inherit; font-size: 1.05rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer;
            transition: 0.3s; margin-top: 10px; box-shadow: 0 8px 20px rgba(124, 45, 94, 0.2);
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(124, 45, 94, 0.3); }
        
        .signin-link { text-align: center; margin-top: 25px; font-size: 0.95rem; color: var(--text-muted); }
        .signin-link a { color: var(--primary-accent); font-weight: 700; text-decoration: none; }
        .signin-link a:hover { text-decoration: underline; }

        .alert-error {
            background: #FEE2E2; color: #B91C1C; padding: 15px; border-radius: 8px; font-size: 0.9rem; font-weight: 500; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;
        }
        .alert-success {
            background: #ecfdf5; color: #047857; padding: 15px; border-radius: 8px; font-size: 0.9rem; font-weight: 500; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; border: 1px solid #d1fae5;
        }
        
        @media (max-width: 992px) {
            .split-layout { flex-direction: column; display: block; }
            .left-panel { padding: 40px 20px; min-height: auto; text-align: center; align-items: center; }
            .welcome-desc { text-align: center; margin: 0 auto 30px; }
            .feature-item { display: none; }
            .right-panel { padding: 40px 20px; display: block; height: auto; border-top: 1px solid var(--border-clr); }
        }
    </style>
</head>
<body>

<div class="split-layout">
    <!-- Left Visual Panel -->
    <div class="left-panel">
        <div class="icon-circle">
            <i class="bi bi-box-arrow-in-right"></i>
        </div>
        <h2 class="welcome-title">Welcome Back,<br><span>Event Organizer!</span></h2>
        <p class="welcome-desc">Log in to your organizer account and start managing your safety events.</p>
        
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-calendar2-check"></i></div>
            <div class="feature-text">
                <h5>Create Events</h5>
                <p>Organize and manage events seamlessly.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-people"></i></div>
            <div class="feature-text">
                <h5>Reach More People</h5>
                <p>Connect with participants and grow your community.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-graph-up-arrow"></i></div>
            <div class="feature-text">
                <h5>Track & Manage</h5>
                <p>Track registrations and manage everything in one place.</p>
            </div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="right-panel">
        <div class="form-container">
            <div class="form-header">
                <div class="icon"><i class="bi bi-person-circle"></i></div>
                <h2>Host Portal Login</h2>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert-error">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <c:if test="${param.registered}">
                <div class="alert-success">
                    <i class="bi bi-check-circle-fill"></i> Registration successful! Pending Admin approval.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/women-events/host/login" method="post">
                
                <div class="input-group-custom">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <i class="bi bi-envelope prefix"></i>
                        <input type="email" name="email" placeholder="organizer@example.com" required/>
                    </div>
                </div>

                <div class="input-group-custom">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <label style="margin-bottom: 0;">Password</label>
                    </div>
                    <div class="input-wrap">
                        <i class="bi bi-lock prefix"></i>
                        <input type="password" id="evPassword" name="password" placeholder="•••••••••" required/>
                        <i class="bi bi-eye suffix" onclick="const p=document.getElementById('evPassword'); p.type=p.type==='password'?'text':'password';"></i>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    Sign In as Host <i class="bi bi-arrow-right ms-2"></i>
                </button>

                <p class="signin-link">
                    Want to host events? <a href="${pageContext.request.contextPath}/women-events/host/register">Register Now</a>
                </p>
            </form>
        </div>
    </div>
</div>

</body>
</html>
