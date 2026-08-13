<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Progress | Fight D Fear</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/antd/5.10.0/reset.min.css">
    
    <style>
        :root {
            --sidebar-width: 260px;
            --primary-red: #E11D48;
            --primary-purple: #1e1b4b;
            --primary-dark: #0F172A;
            --bg-light: #F8FAFC;
            --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
            background: var(--primary-dark);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            padding: 24px;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-logo { display: flex; align-items: center; gap: 12px; margin-bottom: 40px; }
        .sidebar-logo span { font-weight: 800; font-size: 1.25rem; letter-spacing: -0.5px; }

        .nav-menu { list-style: none; padding: 0; margin: 0; }
        .nav-item { margin-bottom: 8px; }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #94A3B8;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-link:hover { background: rgba(255, 255, 255, 0.05); color: white; }
        .nav-link.active { background: var(--primary-red); color: white; box-shadow: 0 4px 15px rgba(225, 29, 72, 0.3); }

        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 32px;
            min-height: 100vh;
        }

        /* AntD Customizations */
        .ant-card { border-radius: 20px !important; border: 1px solid #F1F5F9 !important; box-shadow: var(--card-shadow) !important; }
        .ant-progress-bg { background-color: var(--primary-red) !important; }
        
        .skill-card { text-align: center; padding: 24px; }
        .skill-icon { font-size: 2rem; color: var(--primary-red); margin-bottom: 16px; }
        .skill-name { font-weight: 700; color: #1E293B; margin-bottom: 8px; display: block; }
        
        .achievement-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px;
            border-bottom: 1px solid #F1F5F9;
        }
        .achievement-icon {
            width: 40px; height: 40px; border-radius: 10px;
            background: #FFF1F2; color: var(--primary-red);
            display: flex; align-items: center; justify-content: center;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-hand-fist fa-2x text-danger"></i>
            <span>Fight D Fear</span>
        </div>
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/centres/allacceptedcentres" class="nav-link">
                    <i class="bi bi-grid"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/training-journey" class="nav-link">
                    <i class="bi bi-compass"></i> My Journey
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/attendance/my-attendance" class="nav-link">
                    <i class="bi bi-calendar-check"></i> Attendance
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link">
                    <i class="bi bi-clock-history"></i> My Schedule
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/my-progress" class="nav-link active">
                    <i class="bi bi-bar-chart"></i> My Progress
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/payment/users/my-payments" class="nav-link">
                    <i class="bi bi-wallet2"></i> Payments
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/users/profile/${user.id}" class="nav-link">
                    <i class="bi bi-person"></i> Profile
                </a>
            </li>
        </ul>
    </aside>

    <main class="main-content">
        <div id="react-root">
            <div style="display: flex; justify-content: center; align-items: center; height: 300px; color: #64748B;">
                <div style="text-align: center;">
                    <i class="fas fa-spinner fa-spin fa-2x mb-3"></i>
                    <p>Calculating your progress...</p>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.22.20/babel.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/dayjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/antd/5.10.0/antd.min.js"></script>
    <script src="https://unpkg.com/@ant-design/icons@5.2.6/dist/index.umd.min.js"></script>

    <script type="text/babel">
        // Debugging
        console.log("React initialized:", !!window.React);
        console.log("Antd initialized:", !!window.antd);
        console.log("Icons initialized:", !!window.AntDesignIcons);

        const { useState, useEffect } = React;
        
        const App = () => {
            const [loading, setLoading] = useState(true);
            const [data, setData] = useState(null);
            
            // Safe access to Antd components
            const Card = antd?.Card || 'div';
            const Progress = antd?.Progress || 'div';
            const Row = antd?.Row || 'div';
            const Col = antd?.Col || 'div';
            const Typography = antd?.Typography || 'div';
            const Tag = antd?.Tag || 'span';
            const Button = antd?.Button || 'button';
            const List = antd?.List || 'ul';
            const Avatar = antd?.Avatar || 'span';

            // Safe access to Icons
            const Icons = window.AntDesignIcons || {};
            const TrophyOutlined = Icons.TrophyOutlined || (() => null);
            const FireOutlined = Icons.FireOutlined || (() => null);
            const ThunderboltOutlined = Icons.ThunderboltOutlined || (() => null);
            const CrownOutlined = Icons.CrownOutlined || (() => null);
            const CheckCircleOutlined = Icons.CheckCircleOutlined || (() => null);
            const StarOutlined = Icons.StarOutlined || (() => null);

            useEffect(() => {
                fetchData();
            }, []);

            const fetchData = async () => {
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/progress/my-progress');
                    const json = await response.json();
                    setData(json);
                } catch (e) {
                    console.error("Fetch error:", e);
                } finally {
                    setLoading(false);
                }
            };

            if (loading) return (
                <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '300px' }}>
                    <FireOutlined spin style={{ fontSize: 40, color: '#E11D48' }} />
                </div>
            );

            if (!data) return <div>Error loading progress data.</div>;

            // Calculate overall progress as average of skills
            const skillValues = Object.values(data.skills);
            const overallProgress = Math.round(skillValues.reduce((a, b) => a + b, 0) / skillValues.length);

            return (
                <div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 32 }}>
                        <div>
                            <h1 style={{ color: '#1e1b4b', fontWeight: 800, margin: 0 }}>My Training Progress</h1>
                            <p style={{ color: '#64748B' }}>Analyze your skills, achievements, and belt progression.</p>
                        </div>
                        <Button onClick={() => window.location.href='${pageContext.request.contextPath}/users/training-journey'}>Back to Journey</Button>
                    </div>

                    <Row gutter={[24, 24]}>
                        {/* Overall Progress & Belt */}
                        <Col lg={12} md={24}>
                            <Card style={{ height: '100%', textAlign: 'center' }}>
                                <Typography.Title level={4}>Overall Training Progress</Typography.Title>
                                <Progress 
                                    type="circle" 
                                    percent={overallProgress} 
                                    size={180} 
                                    strokeWidth={8}
                                    strokeColor={{ '0%': '#1e1b4b', '100%': '#E11D48' }}
                                    format={percent => (
                                        <div>
                                            <div style={{ fontSize: '2.5rem', fontWeight: 800, color: '#1E293B' }}>{percent}%</div>
                                            <div style={{ fontSize: '0.85rem', color: '#64748B' }}>Total Mastery</div>
                                        </div>
                                    )}
                                />
                                <div style={{ marginTop: 24 }}>
                                    <Tag color="purple" style={{ fontSize: '1rem', padding: '4px 12px', borderRadius: 8 }}>
                                        Current Rank: {data.currentBelt}
                                    </Tag>
                                </div>
                            </Card>
                        </Col>

                        <Col lg={12} md={24}>
                            <Card title={<span><FireOutlined /> Progress to Next Belt</span>} style={{ height: '100%' }}>
                                <div style={{ textAlign: 'center', padding: '20px 0' }}>
                                    <h2 style={{ color: '#1e1b4b' }}>{data.currentBelt}</h2>
                                    <Progress 
                                        percent={data.beltProgress} 
                                        status="active" 
                                        strokeColor={{ from: '#1e1b4b', to: '#E11D48' }}
                                    />
                                    <p style={{ marginTop: 16, color: '#64748B' }}>You are {data.beltProgress}% of the way to your Green Belt!</p>
                                    
                                    <div style={{ display: 'flex', justifyContent: 'center', gap: 24, marginTop: 24 }}>
                                        <div style={{ textAlign: 'center' }}>
                                            <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#E11D48' }}>{data.trainingStreak}</div>
                                            <div style={{ fontSize: '0.75rem', color: '#64748B' }}>Day Streak</div>
                                        </div>
                                        <div style={{ width: 1, background: '#E2E8F0' }}></div>
                                        <div style={{ textAlign: 'center' }}>
                                            <div style={{ fontSize: '1.5rem', fontWeight: 800, color: '#1e1b4b' }}>{data.recentAchievements.length}</div>
                                            <div style={{ fontSize: '0.75rem', color: '#64748B' }}>Badges</div>
                                        </div>
                                    </div>
                                </div>
                            </Card>
                        </Col>

                        {/* Skill Grid */}
                        <Col lg={16} md={24}>
                            <Card title={<span><ThunderboltOutlined /> Skill Mastery</span>}>
                                <Row gutter={[16, 16]}>
                                    {Object.entries(data.skills).map(([skill, val]) => (
                                        <Col span={8} key={skill}>
                                            <div className="skill-card">
                                                <span className="skill-name">{skill}</span>
                                                <Progress type="circle" percent={val} size={80} strokeColor="#E11D48" />
                                            </div>
                                        </Col>
                                    ))}
                                </Row>
                            </Card>
                        </Col>

                        {/* Achievements & Streak */}
                        <Col lg={8} md={24}>
                            <Card title={<span><FireOutlined /> Training Streak</span>} style={{ marginBottom: 24 }}>
                                <div style={{ textAlign: 'center' }}>
                                    <h1 style={{ fontSize: '3rem', margin: 0, color: '#E11D48' }}>{data.trainingStreak}</h1>
                                    <p style={{ fontWeight: 700 }}>Day Streak!</p>
                                    <FireOutlined style={{ fontSize: '4rem', color: '#FFD700', opacity: 0.2, position: 'absolute', right: 20, bottom: 20 }} />
                                </div>
                            </Card>

                            <Card title={<span><TrophyOutlined /> Recent Achievements</span>}>
                                <List
                                    itemLayout="horizontal"
                                    dataSource={data.recentAchievements}
                                    renderItem={item => (
                                        <List.Item>
                                            <List.Item.Meta
                                                avatar={<Avatar icon={<CheckCircleOutlined />} style={{ backgroundColor: '#F0FDF4', color: '#16A34A' }} />}
                                                title={<span style={{ fontSize: '0.85rem' }}>{item.split(' - ')[0]}</span>}
                                                description={<span style={{ fontSize: '0.75rem' }}>{item.split(' - ')[1]}</span>}
                                            />
                                        </List.Item>
                                    )}
                                />
                            </Card>
                        </Col>
                    </Row>
                </div>
            );
        };

        const root = ReactDOM.createRoot(document.getElementById('react-root'));
        root.render(<App />);
    </script>
</body>
</html>

