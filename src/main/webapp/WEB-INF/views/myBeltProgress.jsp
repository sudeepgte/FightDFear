<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Belt Progress Journey | Fight D Fear</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/antd/5.10.0/reset.min.css">
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-purple: #1e1b4b;
            --bg-light: #F8FAFC;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: #1E293B;
            margin: 0;
            display: flex;
        }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: #0F172A;
            color: white;
            position: fixed;
            padding: 24px;
            z-index: 1000;
        }

        .sidebar-logo { display: flex; align-items: center; gap: 12px; margin-bottom: 40px; font-weight: 800; font-size: 1.25rem; }

        .nav-menu { list-style: none; padding: 0; }
        .nav-link {
            display: flex; align-items: center; gap: 12px; padding: 12px 16px;
            color: #94A3B8; text-decoration: none; border-radius: 12px;
            font-weight: 500; transition: 0.3s;
        }
        .nav-link:hover { background: rgba(255,255,255,0.05); color: white; }
        .nav-link.active { background: #E11D48; color: white; }

        .main-content { margin-left: var(--sidebar-width); flex: 1; padding: 32px; }

        /* Belt Card Styles */
        .belt-card {
            border-radius: 20px;
            margin-bottom: 24px;
            transition: transform 0.3s;
            overflow: hidden;
            border: 1px solid #E2E8F0;
        }
        .belt-card:hover { transform: translateY(-5px); }
        .belt-header {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }
        .belt-body { padding: 20px; background: white; }
        
        /* Belt Colors */
        .bg-white { background: #94A3B8; color: #1E293B !important; }
        .bg-yellow { background: #FACC15; color: #1E293B !important; }
        .bg-green { background: #22C55E; }
        .bg-blue { background: #3B82F6; }
        .bg-red { background: #EF4444; }
        .bg-brown { background: #78350F; }
        .bg-black { background: #1E293B; }
        
        .locked-overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(255,255,255,0.7);
            display: flex; align-items: center; justify-content: center;
            z-index: 10; font-weight: 700; color: #64748B;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-hand-fist text-danger"></i>
            <span>Fight D Fear</span>
        </div>
        <ul class="nav-menu">
            <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link"><i class="fas fa-grid-2"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/users/training-journey" class="nav-link"><i class="fas fa-compass"></i> My Journey</a>
            <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="nav-link"><i class="fas fa-calendar-check"></i> Attendance</a>
            <a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link"><i class="fas fa-clock"></i> My Schedule</a>
            <a href="${pageContext.request.contextPath}/payment/users/my-payments" class="nav-link"><i class="fas fa-wallet"></i> Payments</a>
        </ul>
    </aside>

    <main class="main-content">
        <div id="react-root">
            <div style="display: flex; justify-content: center; align-items: center; height: 300px;">
                <i class="fas fa-spinner fa-spin fa-2x"></i>
            </div>
        </div>
    </main>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.22.20/babel.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/antd/5.10.0/antd.min.js"></script>
    <script src="https://unpkg.com/@ant-design/icons@5.2.6/dist/index.umd.min.js"></script>

    <script type="text/babel">
        const { useState, useEffect } = React;
        const { Card, Steps, Progress, Tag, Typography, Row, Col, Badge } = antd;
        const { LockOutlined, CheckCircleOutlined, TrophyOutlined } = AntDesignIcons;

        const App = () => {
            const [data, setData] = useState(null);
            const [loading, setLoading] = useState(true);

            useEffect(() => {
                fetch('${pageContext.request.contextPath}/api/progress/belt-hierarchy')
                    .then(res => res.json())
                    .then(json => { setData(json); setLoading(false); });
            }, []);

            if (loading) return <div>Loading Journey...</div>;

            const getBeltClass = (name) => `bg-${name.toLowerCase()}`;

            return (
                <div>
                    <div style={{ marginBottom: 40 }}>
                        <Typography.Title level={2} style={{ color: '#1e1b4b', fontWeight: 800 }}>Belt Graduation Journey</Typography.Title>
                        <Typography.Paragraph style={{ color: '#64748B', fontSize: '1.1rem' }}>
                            Your path from beginner to expert. Complete technical requirements to unlock your next rank.
                        </Typography.Paragraph>
                    </div>

                    <Row gutter={[24, 24]}>
                        {data.belts.map((belt, index) => (
                            <Col span={24} key={belt.name}>
                                <div className="belt-card" style={{ position: 'relative' }}>
                                    {!belt.completed && belt.progress === 0 && (
                                        <div className="locked-overlay">
                                            <div style={{ textAlign: 'center' }}>
                                                <LockOutlined style={{ fontSize: 32, marginBottom: 8 }} /><br/>
                                                LOCKED
                                            </div>
                                        </div>
                                    )}
                                    <div className={"belt-header " + getBeltClass(belt.name)}>
                                        <div>
                                            <Typography.Title level={4} style={{ color: 'inherit', margin: 0 }}>
                                                {belt.name} Belt 
                                                {belt.completed && <CheckCircleOutlined style={{ marginLeft: 10, color: '#fff' }} />}
                                            </Typography.Title>
                                            <span style={{ fontSize: '0.9rem', opacity: 0.8 }}>{belt.level} Level</span>
                                        </div>
                                        <div style={{ textAlign: 'right' }}>
                                            <Typography.Title level={5} style={{ color: 'inherit', margin: 0 }}>Rank {index + 1}</Typography.Title>
                                        </div>
                                    </div>
                                    <div className="belt-body">
                                        <Row align="middle" gutter={24}>
                                            <Col span={18}>
                                                <Typography.Text strong>Current Requirement Status:</Typography.Text>
                                                <Typography.Paragraph style={{ marginBottom: 16 }}>{belt.requirement}</Typography.Paragraph>
                                                <Progress 
                                                    percent={belt.progress} 
                                                    strokeColor={belt.completed ? '#22C55E' : '#1e1b4b'} 
                                                    status={belt.completed ? 'success' : 'active'}
                                                />
                                            </Col>
                                            <Col span={6} style={{ textAlign: 'center' }}>
                                                {belt.completed ? (
                                                    <Tag color="success" style={{ padding: '8px 16px', borderRadius: 8 }}>GRADUATED</Tag>
                                                ) : (
                                                    belt.progress > 0 ? (
                                                        <Tag color="processing" style={{ padding: '8px 16px', borderRadius: 8 }}>IN TRAINING</Tag>
                                                    ) : (
                                                        <Tag color="default" style={{ padding: '8px 16px', borderRadius: 8 }}>NOT STARTED</Tag>
                                                    )
                                                )}
                                            </Col>
                                        </Row>
                                    </div>
                                </div>
                            </Col>
                        ))}
                    </Row>
                </div>
            );
        };

        ReactDOM.createRoot(document.getElementById('react-root')).render(<App />);
    </script>
</body>
</html>

