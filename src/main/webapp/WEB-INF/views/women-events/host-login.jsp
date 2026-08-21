<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Event Host Login | Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
    <style>
        :root {
            --primary-navy: #1e1b4b;
            --primary-pink: #f43f5e;
            --soft-pink: #fff1f2;
            --bg-soft: #faf7f8;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --border-clr: #e2e8f0;
            --gradient-main: linear-gradient(135deg, #1e1b4b 0%, #f43f5e 100%);
            --success-bg: #ecfdf5;
            --success-text: #047857;
            --danger-bg: #fee2e2;
            --danger-text: #b91c1c;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; min-height: 100vh; display: block; color: var(--text-dark); background: var(--bg-soft); }
        
        .split-layout { display: flex; width: 100%; min-height: 100vh; }
        
        /* Left Panel */
        .left-panel {
            flex: 0.85;
            background: linear-gradient(135deg, #1e1b4b 0%, #1e1b4b 45%, #f43f5e 100%);
            padding: 60px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-right: 1px solid var(--border-clr);
            position: relative;
        }
        .icon-circle {
            width: 70px; height: 70px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin-bottom: 35px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .welcome-title { font-size: 2.6rem; font-weight: 800; line-height: 1.15; margin-bottom: 18px; color: white; }
        .welcome-title span { color: var(--primary-pink); }
        .welcome-desc { color: rgba(255,255,255,0.9); font-size: 1.05rem; line-height: 1.6; margin-bottom: 45px; max-width: 90%; font-weight: 300; }
        
        .feature-item { display: flex; align-items: flex-start; gap: 18px; margin-bottom: 25px; }
        .feature-icon { 
            width: 48px; height: 48px; min-width: 48px; background: rgba(255,255,255,0.15); color: white;
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
        }
        .feature-text h5 { font-size: 1.05rem; font-weight: 700; margin-bottom: 4px; color: white; }
        .feature-text p { font-size: 0.9rem; color: rgba(255,255,255,0.8); margin: 0; line-height: 1.45; }
        
        /* Right Panel */
        .right-panel {
            flex: 1.15;
            padding: 50px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: white;
            overflow-y: auto;
        }
        
        .form-container { width: 100%; max-width: 480px; }
        
        .form-header { display: flex; align-items: center; gap: 14px; margin-bottom: 35px; }
        .form-header .icon {
            width: 46px; height: 46px; border-radius: 12px; border: 1.5px solid var(--border-clr); background: var(--soft-pink);
            color: var(--primary-pink); display: flex; align-items: center; justify-content: center; font-size: 1.35rem;
        }
        .form-header h2 { font-size: 1.75rem; font-weight: 800; color: var(--primary-navy); margin: 0; border-left: 4px solid var(--primary-pink); padding-left: 14px; }
        
        .input-group-custom { margin-bottom: 22px; position: relative; }
        .input-group-custom label { display: block; font-size: 0.88rem; font-weight: 600; margin-bottom: 8px; color: var(--text-dark); }
        .input-wrap { position: relative; display: flex; align-items: center; }
        .input-wrap i.prefix { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1.1rem; }
        .input-wrap i.suffix { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1.1rem; cursor: pointer; }
        
        .input-wrap input {
            width: 100%; padding: 13px 14px 13px 44px; border: 1.5px solid var(--border-clr);
            border-radius: 10px; font-family: inherit; font-size: 0.95rem; color: var(--text-dark); outline: none; transition: 0.2s;
        }
        .input-wrap input::placeholder { color: #94a3b8; font-weight: 400; }
        .input-wrap input:focus { border-color: var(--primary-pink); box-shadow: 0 0 0 3.5px rgba(244,63,94,0.1); background: white; }
        
        .btn-submit {
            width: 100%; padding: 16px; background: var(--gradient-main); color: white;
            border: none; border-radius: 12px; font-family: inherit; font-size: 1.05rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer;
            transition: 0.3s; margin-top: 10px; box-shadow: 0 6px 18px rgba(244, 63, 94, 0.25);
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 22px rgba(244, 63, 94, 0.35); }
        
        .signin-link { text-align: center; margin-top: 25px; font-size: 0.92rem; color: var(--text-muted); }
        .signin-link a { color: var(--primary-pink); font-weight: 700; text-decoration: none; }
        .signin-link a:hover { text-decoration: underline; }

        .alert-custom { padding: 14px 16px; border-radius: 10px; font-size: 0.88rem; font-weight: 500; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .alert-custom.danger { background: var(--danger-bg); color: var(--danger-text); border: 1px solid #fca5a5; }
        .alert-custom.success { background: var(--success-bg); color: var(--success-text); border: 1px solid #a7f3d0; }
        
        @media (max-width: 992px) {
            .split-layout { flex-direction: column; display: block; }
            .left-panel { padding: 35px 20px; min-height: auto; text-align: center; align-items: center; }
            .welcome-desc { text-align: center; margin: 0 auto 20px; }
            .feature-item { display: none; }
            .right-panel { padding: 35px 20px; display: block; height: auto; border-top: 1px solid var(--border-clr); }
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
        <p class="welcome-desc">Log in to manage your profile, create safety events, and view attendee registrations.</p>
        
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-calendar2-check"></i></div>
            <div class="feature-text">
                <h5>Create & Manage Events</h5>
                <p>Submit events for community participation.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-people"></i></div>
            <div class="feature-text">
                <h5>Attendee Management</h5>
                <p>Track signups and perform fast check-ins.</p>
            </div>
        </div>
        <div class="feature-item">
            <div class="feature-icon"><i class="bi bi-cash-stack"></i></div>
            <div class="feature-text">
                <h5>Payout Management</h5>
                <p>Request payouts for paid event ticket sales.</p>
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
                <div class="alert-custom danger">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <c:if test="${param.registered}">
                <div class="alert-custom success">
                    <i class="bi bi-check-circle-fill"></i> Account created! Please log in to complete your organizer profile.
                </div>
            </c:if>

            <c:if test="${param.submitted}">
                <div class="alert-custom success">
                    <i class="bi bi-clock-history"></i> Profile submitted for verification. Waiting for admin approval.
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
                    <label>Password</label>
                    <div class="input-wrap">
                        <i class="bi bi-lock prefix"></i>
                        <input type="password" id="evPassword" name="password" placeholder="•••••••••" required/>
                        <i class="bi bi-eye suffix" onclick="const p=document.getElementById('evPassword'); p.type=p.type==='password'?'text':'password';"></i>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    Sign In as Host <i class="bi bi-arrow-right"></i>
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
