<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>24/7 Emergency Helplines - Fight D Fear</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #f43f5e;
            --primary-glow: rgba(219,39,119,0.3);
            --accent: #1e1b4b;
            --success: #10B981;
            --warning: #F59E0B;
            --blue: #3B82F6;
            --bg: #0f0f1a;
            --card: rgba(255,255,255,0.04);
            --card-border: rgba(255,255,255,0.08);
            --text: #f1f1f1;
            --text-muted: rgba(255,255,255,0.45);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* Ambient glow */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 50%;
            width: 800px; height: 400px;
            background: radial-gradient(ellipse, var(--primary-glow) 0%, transparent 70%);
            transform: translateX(-50%);
            z-index: 0;
            pointer-events: none;
        }

        /* Top bar */
        .topbar {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 24px;
            background: rgba(15,15,26,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--card-border);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .topbar a {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 1.2rem;
            transition: color 0.2s;
        }
        .topbar a:hover { color: var(--text); }

        .topbar h1 {
            font-size: 1.1rem;
            font-weight: 700;
        }

        /* Content */
        .content {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px 60px;
        }

        /* Hero */
        .hero {
            text-align: center;
            margin-bottom: 40px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(239,68,68,0.12);
            border: 1px solid rgba(239,68,68,0.25);
            color: #EF4444;
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 20px;
        }

        .hero h2 {
            font-size: 2.2rem;
            font-weight: 900;
            margin-bottom: 12px;
            background: linear-gradient(135deg, var(--text), rgba(255,255,255,0.7));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero p {
            color: var(--text-muted);
            font-size: 1rem;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.7;
        }

        /* SOS quick call bar */
        .sos-bar {
            background: linear-gradient(135deg, #EF4444, #DC2626);
            border-radius: 18px;
            padding: 24px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 32px;
            box-shadow: 0 10px 40px rgba(239,68,68,0.3);
        }

        .sos-bar-info h3 {
            font-size: 1.3rem;
            font-weight: 800;
            color: white;
        }

        .sos-bar-info p {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-top: 4px;
        }

        .sos-call-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            background: white;
            color: #DC2626;
            text-decoration: none;
            padding: 14px 28px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 800;
            transition: all 0.25s;
            white-space: nowrap;
        }
        .sos-call-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        /* Section title */
        .section-title {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--text-muted);
            margin-bottom: 16px;
            padding-left: 4px;
        }

        /* Helpline grid */
        .helpline-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 14px;
            margin-bottom: 40px;
        }

        .helpline-card {
            background: var(--card);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            transition: all 0.25s;
        }
        .helpline-card:hover {
            background: rgba(255,255,255,0.07);
            transform: translateY(-2px);
            border-color: rgba(255,255,255,0.15);
        }

        .helpline-icon {
            width: 48px; height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .helpline-icon.red { background: rgba(239,68,68,0.12); color: #EF4444; }
        .helpline-icon.pink { background: rgba(219,39,119,0.12); color: #f43f5e; }
        .helpline-icon.blue { background: rgba(59,130,246,0.12); color: #3B82F6; }
        .helpline-icon.green { background: rgba(16,185,129,0.12); color: #10B981; }
        .helpline-icon.amber { background: rgba(245,158,11,0.12); color: #F59E0B; }
        .helpline-icon.purple { background: rgba(139,92,246,0.12); color: #8B5CF6; }

        .helpline-info h4 {
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .helpline-info .helpline-desc {
            font-size: 0.78rem;
            color: var(--text-muted);
            margin-bottom: 10px;
            line-height: 1.5;
        }

        .helpline-number {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.06);
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 800;
            color: var(--text);
            text-decoration: none;
            transition: all 0.2s;
            font-variant-numeric: tabular-nums;
        }
        .helpline-number:hover {
            background: var(--primary);
            color: white;
        }

        .helpline-number i { font-size: 0.85rem; }

        /* Tips section */
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 14px;
            margin-bottom: 40px;
        }

        .tip-card {
            background: var(--card);
            border: 1px solid var(--card-border);
            border-radius: 14px;
            padding: 20px;
        }

        .tip-card .tip-num {
            font-size: 0.7rem;
            font-weight: 800;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .tip-card h5 {
            font-size: 0.9rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .tip-card p {
            font-size: 0.78rem;
            color: var(--text-muted);
            line-height: 1.6;
        }

        /* CTA */
        .cta-section {
            text-align: center;
            padding: 40px 20px;
            background: var(--card);
            border: 1px solid var(--card-border);
            border-radius: 20px;
        }

        .cta-section h3 {
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .cta-section p {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 20px;
        }

        .cta-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            text-decoration: none;
            padding: 14px 32px;
            border-radius: 50px;
            font-size: 0.95rem;
            font-weight: 700;
            transition: all 0.25s;
            box-shadow: 0 8px 30px var(--primary-glow);
        }
        .cta-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 40px var(--primary-glow);
        }

        @media (max-width: 600px) {
            .hero h2 { font-size: 1.6rem; }
            .sos-bar { flex-direction: column; gap: 16px; text-align: center; }
            .helpline-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Top bar -->
    <div class="topbar">
        <a href="${pageContext.request.contextPath}/"><i class="bi bi-arrow-left"></i></a>
        <h1><i class="bi bi-telephone-fill" style="color:var(--warning)"></i> 24/7 Helplines</h1>
    </div>

    <div class="content">
        <!-- Hero -->
        <div class="hero">
            <div class="hero-badge">
                <i class="bi bi-shield-check"></i> Verified Numbers
            </div>
            <h2>Emergency Helpline Numbers</h2>
            <p>These are verified government helpline numbers available 24/7 across India. Tap any number to call directly.</p>
        </div>

        <!-- SOS Quick Call -->
        <div class="sos-bar">
            <div class="sos-bar-info">
                <h3>Women Helpline (All India)</h3>
                <p>Immediate support for women in distress — 24 hours, 7 days</p>
            </div>
            <a href="tel:181" class="sos-call-btn">
                <i class="bi bi-telephone-fill"></i> Call 181
            </a>
        </div>

        <!-- Primary Helplines -->
        <div class="section-title">Primary Emergency Numbers</div>
        <div class="helpline-grid">
            <div class="helpline-card">
                <div class="helpline-icon red"><i class="bi bi-exclamation-triangle-fill"></i></div>
                <div class="helpline-info">
                    <h4>Police</h4>
                    <div class="helpline-desc">Report crime, harassment, or any law and order issue</div>
                    <a href="tel:100" class="helpline-number"><i class="bi bi-telephone"></i> 100</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon pink"><i class="bi bi-heart-pulse-fill"></i></div>
                <div class="helpline-info">
                    <h4>Ambulance</h4>
                    <div class="helpline-desc">Medical emergency and ambulance services</div>
                    <a href="tel:102" class="helpline-number"><i class="bi bi-telephone"></i> 102</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon amber"><i class="bi bi-fire"></i></div>
                <div class="helpline-info">
                    <h4>Fire Brigade</h4>
                    <div class="helpline-desc">Fire emergencies and rescue operations</div>
                    <a href="tel:101" class="helpline-number"><i class="bi bi-telephone"></i> 101</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon blue"><i class="bi bi-telephone-forward-fill"></i></div>
                <div class="helpline-info">
                    <h4>Emergency (Universal)</h4>
                    <div class="helpline-desc">Unified emergency number for all services</div>
                    <a href="tel:112" class="helpline-number"><i class="bi bi-telephone"></i> 112</a>
                </div>
            </div>
        </div>

        <!-- Women-specific helplines -->
        <div class="section-title">Women Safety Helplines</div>
        <div class="helpline-grid">
            <div class="helpline-card">
                <div class="helpline-icon pink"><i class="bi bi-person-heart"></i></div>
                <div class="helpline-info">
                    <h4>Women Helpline (All India)</h4>
                    <div class="helpline-desc">Domestic violence, harassment, dowry abuse</div>
                    <a href="tel:181" class="helpline-number"><i class="bi bi-telephone"></i> 181</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon red"><i class="bi bi-shield-exclamation"></i></div>
                <div class="helpline-info">
                    <h4>Women Helpline (Domestic Abuse)</h4>
                    <div class="helpline-desc">National Commission for Women</div>
                    <a href="tel:7827-170-170" class="helpline-number"><i class="bi bi-telephone"></i> 7827-170-170</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon purple"><i class="bi bi-people-fill"></i></div>
                <div class="helpline-info">
                    <h4>Childline (Under 18)</h4>
                    <div class="helpline-desc">Child abuse, trafficking, missing children</div>
                    <a href="tel:1098" class="helpline-number"><i class="bi bi-telephone"></i> 1098</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon green"><i class="bi bi-chat-heart-fill"></i></div>
                <div class="helpline-info">
                    <h4>Cyber Crime Helpline</h4>
                    <div class="helpline-desc">Online harassment, cyber stalking, threats</div>
                    <a href="tel:1930" class="helpline-number"><i class="bi bi-telephone"></i> 1930</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon blue"><i class="bi bi-emoji-frown"></i></div>
                <div class="helpline-info">
                    <h4>Mental Health Helpline</h4>
                    <div class="helpline-desc">Emotional support, anxiety, depression</div>
                    <a href="tel:08046110007" class="helpline-number"><i class="bi bi-telephone"></i> 0804-611-0007</a>
                </div>
            </div>

            <div class="helpline-card">
                <div class="helpline-icon amber"><i class="bi bi-car-front-fill"></i></div>
                <div class="helpline-info">
                    <h4>Road Accident Emergency</h4>
                    <div class="helpline-desc">Highway accident, vehicle breakdown help</div>
                    <a href="tel:1073" class="helpline-number"><i class="bi bi-telephone"></i> 1073</a>
                </div>
            </div>
        </div>

        <!-- Tips -->
        <div class="section-title">What To Do In An Emergency</div>
        <div class="tips-grid">
            <div class="tip-card">
                <div class="tip-num">Step 1</div>
                <h5>Stay Calm</h5>
                <p>Take a deep breath. Panicking can make the situation worse. Try to think clearly.</p>
            </div>
            <div class="tip-card">
                <div class="tip-num">Step 2</div>
                <h5>Call For Help</h5>
                <p>Dial 112 or the relevant helpline. Give your location, name, and describe the situation.</p>
            </div>
            <div class="tip-card">
                <div class="tip-num">Step 3</div>
                <h5>Share Location</h5>
                <p>Use Fight D Fear's SOS or Panic Button to automatically share your GPS location.</p>
            </div>
        </div>

        <!-- CTA -->
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <div class="cta-section">
                    <h3>Manage Your Emergency Contacts</h3>
                    <p>Add trusted contacts so they get notified automatically when you trigger SOS or Panic.</p>
                    <a href="${pageContext.request.contextPath}/users/${sessionScope.user.id}/emergency-contacts" class="cta-btn">
                        <i class="bi bi-person-plus-fill"></i> Manage Contacts
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cta-section">
                    <h3>Want Automatic Emergency Alerts?</h3>
                    <p>Login to add emergency contacts. When you trigger SOS or Panic, they'll be notified with your location.</p>
                    <a href="${pageContext.request.contextPath}/login" class="cta-btn">
                        <i class="bi bi-box-arrow-in-right"></i> Login to Get Started
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

