<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Become an Event Host — Women Safety App</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"/>
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
        
        .form-container { width: 100%; max-width: 650px; }
        
        .form-header { display: flex; align-items: center; gap: 15px; margin-bottom: 40px; }
        .form-header .icon {
            width: 45px; height: 45px; border-radius: 12px; border: 1.5px solid var(--border-clr); background: var(--primary-light);
            color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 1.4rem;
        }
        .form-header h2 { font-size: 1.8rem; font-weight: 800; color: var(--text-dark); margin: 0; font-family: 'Montserrat', sans-serif; border-left: 5px solid var(--primary-accent); padding-left: 15px; }
        
        .input-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 5px; }
        .input-group-custom { margin-bottom: 25px; position: relative; }
        .input-group-custom label { display: block; font-size: 0.9rem; font-weight: 600; margin-bottom: 10px; color: var(--text-dark); }
        .input-wrap { position: relative; }
        .input-wrap i.prefix { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #a1a1aa; font-size: 1.2rem; }
        .input-wrap i.suffix { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #a1a1aa; font-size: 1.2rem; cursor: pointer; }
        
        .input-wrap input, .input-wrap select, .input-wrap textarea {
            width: 100%; padding: 14px 15px 14px 45px; border: 1.5px solid var(--border-clr);
            border-radius: 8px; font-family: inherit; font-size: 0.95rem; color: var(--text-dark); outline: none; transition: 0.2s;
        }
        .input-wrap input::placeholder, .input-wrap textarea::placeholder { color: #a1a1aa; font-weight: 400; }
        .input-wrap textarea { padding-left: 15px; padding-top: 15px; resize: vertical; } 
        .input-wrap select { padding-left: 15px; appearance: none; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-chevron-down' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E") no-repeat right 15px center/14px; } 
        
        .input-wrap input:focus, .input-wrap select:focus, .input-wrap textarea:focus { border-color: var(--primary-accent); box-shadow: 0 0 0 4px rgba(219,39,119,0.05); background: white; }
        
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
        
        @media (max-width: 992px) {
            .split-layout { flex-direction: column; display: block; }
            .left-panel { padding: 40px 20px; min-height: auto; text-align: center; align-items: center; }
            .welcome-desc { text-align: center; margin: 0 auto 30px; }
            .feature-item { display: none; }
            .right-panel { padding: 40px 20px; display: block; height: auto; border-top: 1px solid var(--border-clr); }
            .input-row { grid-template-columns: 1fr; gap: 0; }
        }
    </style>
</head>
<body>

<div class="split-layout">
    <!-- Left Visual Panel -->
    <div class="left-panel">
        <div class="icon-circle">
            <i class="bi bi-people-fill"></i>
        </div>
        <h2 class="welcome-title">Welcome,<br><span>Event Organizer!</span></h2>
        <p class="welcome-desc">Create your organizer account and start managing your events with ease.</p>
        
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
                <div class="icon"><i class="bi bi-person-plus"></i></div>
                <h2>Organizer Registration</h2>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert-error">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/women-events/host/register" method="post">
                <div class="input-row">
                    <div class="input-group-custom">
                        <label>Full Name</label>
                        <div class="input-wrap">
                            <i class="bi bi-person prefix"></i>
                            <input type="text" name="fullName" placeholder="e.g. Anjali Sharma" required/>
                        </div>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Address</label>
                        <div class="input-wrap">
                            <i class="bi bi-envelope prefix"></i>
                            <input type="email" name="email" placeholder="yogesh@gmail.com" required/>
                        </div>
                    </div>
                </div>

                <div class="input-row">
                    <div class="input-group-custom">
                        <label>Phone Number (10 digits)</label>
                        <div class="input-wrap">
                            <i class="bi bi-telephone prefix"></i>
                            <input type="text" name="phone" placeholder="e.g. 9876543210" required pattern="^\d{10}$"/>
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
                </div>

                <div class="input-group-custom">
                    <label>Host / Organization Name</label>
                    <div class="input-wrap">
                        <i class="bi bi-building prefix"></i>
                        <input type="text" name="organizerName" placeholder="e.g. She Leads Foundation" required/>
                    </div>
                </div>

                <div class="input-group-custom">
                    <label>Organizer Type</label>
                    <div class="input-wrap">
                        <select name="organizerType" required>
                            <option value="">-- Select Type --</option>
                            <option value="NGO">NGO</option>
                            <option value="Government">Government</option>
                            <option value="College">College / University</option>
                            <option value="Company">Corporate Company</option>
                            <option value="Community">Community Group</option>
                            <option value="Gym">Gym / Self-Defense Studio</option>
                            <option value="Hospital">Hospital / Medical Center</option>
                            <option value="Fitness Trainer">Fitness Trainer</option>
                            <option value="Women Entrepreneur">Women Entrepreneur</option>
                        </select>
                    </div>
                </div>

                <div class="input-group-custom">
                    <label>Contact Information</label>
                    <div class="input-wrap">
                        <i class="bi bi-info-circle prefix"></i>
                        <input type="text" name="hostContact" placeholder="e.g. info@organization.com or +91 XXXXX XXXXX" required/>
                    </div>
                </div>

                <div class="input-group-custom">
                    <label>Organizer Bio / Purpose</label>
                    <div class="input-wrap">
                        <textarea name="hostBio" rows="3" placeholder="Briefly describe your purpose or safety training background..." required></textarea>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="bi bi-person-plus"></i> Create Account
                </button>

                <p class="signin-link">
                    Already registered? <a href="${pageContext.request.contextPath}/women-events/host/login">Sign in here</a>
                </p>
            </form>
        </div>
    </div>
</div>

</body>
</html>
