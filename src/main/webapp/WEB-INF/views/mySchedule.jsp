<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Schedule | Fight D Fear</title>
    
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Ant Design CSS -->
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

        /* Sidebar (Matching Journey Page) */
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

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
        }

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

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 32px;
            min-height: 100vh;
        }

        /* AntD Customizations to match theme */
        .ant-card {
            border-radius: 20px !important;
            border: 1px solid #F1F5F9 !important;
            box-shadow: var(--card-shadow) !important;
        }

        .ant-table {
            background: transparent !important;
        }

        .ant-table-thead > tr > th {
            background: #F8FAFC !important;
            font-weight: 700 !important;
            text-transform: uppercase !important;
            font-size: 0.75rem !important;
            letter-spacing: 0.05em !important;
            color: #64748B !important;
            border-bottom: 1px solid #F1F5F9 !important;
        }

        .ant-btn-primary {
            background: var(--primary-purple) !important;
            border-radius: 10px !important;
            height: 40px !important;
            font-weight: 600 !important;
        }

        .ant-input, .ant-select-selector {
            border-radius: 10px !important;
            border: 1px solid #E2E8F0 !important;
            height: 40px !important;
            display: flex !important;
            align-items: center !important;
        }

        .stat-icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }

        .stat-card-title {
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748B;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }

        .stat-card-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: #1E293B;
            margin-bottom: 4px;
        }

        .stat-card-label {
            font-size: 0.75rem;
            color: #94A3B8;
        }

        /* React Empty State Styles */
        .empty-state-container {
            padding: 80px 0;
            text-align: center;
        }

        .empty-state-title {
            font-weight: 800;
            font-size: 1.25rem;
            margin-top: 24px;
            margin-bottom: 8px;
            color: #1E293B;
        }

        .empty-state-desc {
            color: #64748B;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
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
                <a href="${pageContext.request.contextPath}/users/my-schedule" class="nav-link active">
                    <i class="bi bi-clock-history"></i> My Schedule
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

    <!-- Main Content -->
    <main class="main-content">
        <div id="react-root">
            <div style="display: flex; justify-content: center; align-items: center; height: 300px; color: #64748B;">
                <div style="text-align: center;">
                    <i class="fas fa-spinner fa-spin fa-2x mb-3"></i>
                    <p>Loading your schedule...</p>
                </div>
            </div>
        </div>
    </main>

    <!-- Dependencies -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.22.20/babel.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.10/dayjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/antd/5.10.0/antd.min.js"></script>
    <script src="https://unpkg.com/@ant-design/icons@5.2.6/dist/index.umd.min.js"></script>

    <!-- React Implementation -->
    <script type="text/babel">
        // Debugging
        console.log("React initialized:", !!window.React);
        console.log("Antd initialized:", !!window.antd);
        console.log("Icons initialized:", !!window.AntDesignIcons);

        const { useState, useEffect } = React;
        
        const App = () => {
            const [loading, setLoading] = useState(true);
            const [data, setData] = useState([]);
            const [error, setError] = useState(null);
            
            // Safe access to Antd components
            const Card = antd?.Card || 'div';
            const Table = antd?.Table || 'table';
            const Input = antd?.Input || 'input';
            const Select = antd?.Select || 'select';
            const Button = antd?.Button || 'button';
            const Space = antd?.Space || 'div';
            const Row = antd?.Row || 'div';
            const Col = antd?.Col || 'div';
            const Empty = antd?.Empty || 'div';
            const Pagination = antd?.Pagination || 'div';

            // Safe access to Icons
            const Icons = window.AntDesignIcons || {};
            const SearchOutlined = Icons.SearchOutlined || (() => null);
            const ReloadOutlined = Icons.ReloadOutlined || (() => null);
            const CalendarOutlined = Icons.CalendarOutlined || (() => null);
            const CheckCircleOutlined = Icons.CheckCircleOutlined || (() => null);
            const CloseCircleOutlined = Icons.CloseCircleOutlined || (() => null);
            const ClockCircleOutlined = Icons.ClockCircleOutlined || (() => null);
            const HistoryOutlined = Icons.HistoryOutlined || (() => null);
            const PercentageOutlined = Icons.PercentageOutlined || (() => null);

            const [stats, setStats] = useState([
                { title: 'Total Classes', value: '0', label: 'Total in Schedule', icon: <CalendarOutlined />, color: '#F0F5FF', iconColor: '#2F54EB' },
                { title: 'Attended', value: '0', label: 'This Month', icon: <CheckCircleOutlined />, color: '#F6FFED', iconColor: '#52C41A' },
                { title: 'Missed', value: '0', label: 'This Month', icon: <CloseCircleOutlined />, color: '#FFF1F0', iconColor: '#F5222D' },
                { title: 'Upcoming', value: '0', label: 'Next 7 Days', icon: <ClockCircleOutlined />, color: '#FFF7E6', iconColor: '#FAAD14' },
                { title: 'Total Hours', value: '0.0', label: 'Training Time', icon: <HistoryOutlined />, color: '#E6F7FF', iconColor: '#1890FF' },
                { title: 'Attendance %', value: '0%', label: 'Present Rate', icon: <PercentageOutlined />, color: '#FFF2E8', iconColor: '#FA541C' },
            ]);
            
            const [filters, setFilters] = useState({
                search: '',
                batch: 'All Batch',
                month: 'All Months',
                status: 'All Status'
            });

            useEffect(() => {
                fetchData();
            }, []);

            const fetchData = async () => {
                setLoading(true);
                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/schedule/my-schedule');
                    const json = await response.json();
                    setData(json.data);
                    
                    // Use server-side stats if available
                    setStats([
                        { title: 'Total Classes', value: (json.total || 0).toString(), label: 'Total in Schedule', icon: <CalendarOutlined />, color: '#F0F5FF', iconColor: '#2F54EB' },
                        { title: 'Attended', value: (json.attended || 0).toString(), label: 'This Month', icon: <CheckCircleOutlined />, color: '#F6FFED', iconColor: '#52C41A' },
                        { title: 'Missed', value: (json.missed || 0).toString(), label: 'This Month', icon: <CloseCircleOutlined />, color: '#FFF1F0', iconColor: '#F5222D' },
                        { title: 'Upcoming', value: (json.upcoming || 0).toString(), label: 'Next 7 Days', icon: <ClockCircleOutlined />, color: '#FFF7E6', iconColor: '#FAAD14' },
                        { title: 'Total Hours', value: (json.totalHours || 0).toFixed(1), label: 'Training Time', icon: <HistoryOutlined />, color: '#E6F7FF', iconColor: '#1890FF' },
                        { title: 'Attendance %', value: (json.attendanceRate || 0) + '%', label: 'Present Rate', icon: <PercentageOutlined />, color: '#FFF2E8', iconColor: '#FA541C' },
                    ]);
                } catch (error) {
                    console.error('Error fetching schedule:', error);
                } finally {
                    setLoading(false);
                }
            };

            const calculateStats = (scheduleItems) => {
                const total = scheduleItems.length;
                const attended = scheduleItems.filter(i => i.status === 'PRESENT').length;
                const missed = scheduleItems.filter(i => i.status === 'ABSENT').length;
                const upcoming = scheduleItems.filter(i => i.status === 'UPCOMING').length;
                const hours = scheduleItems.filter(i => i.status === 'PRESENT').reduce((acc, curr) => acc + (parseFloat(curr.duration) || 0), 0);
                const percent = (attended + missed) === 0 ? 0 : Math.round((attended / (attended + missed)) * 100);

                setStats([
                    { title: 'Total Classes', value: total.toString(), label: 'Total in Schedule', icon: <CalendarOutlined />, color: '#F0F5FF', iconColor: '#2F54EB' },
                    { title: 'Attended', value: attended.toString(), label: 'This Month', icon: <CheckCircleOutlined />, color: '#F6FFED', iconColor: '#52C41A' },
                    { title: 'Missed', value: missed.toString(), label: 'This Month', icon: <CloseCircleOutlined />, color: '#FFF1F0', iconColor: '#F5222D' },
                    { title: 'Upcoming', value: upcoming.toString(), label: 'Next 7 Days', icon: <ClockCircleOutlined />, color: '#FFF7E6', iconColor: '#FAAD14' },
                    { title: 'Total Hours', value: hours.toFixed(1), label: 'Training Time', icon: <HistoryOutlined />, color: '#E6F7FF', iconColor: '#1890FF' },
                    { title: 'Attendance %', value: percent + '%', label: 'Present Rate', icon: <PercentageOutlined />, color: '#FFF2E8', iconColor: '#FA541C' },
                ]);
            };

            const filteredData = data.filter(item => {
                const matchesSearch = !filters.search || 
                    item.batch.toLowerCase().includes(filters.search.toLowerCase()) || 
                    item.trainer.toLowerCase().includes(filters.search.toLowerCase());
                
                const matchesBatch = filters.batch === 'All Batch' || item.batch === filters.batch;
                const matchesStatus = filters.status === 'All Status' || item.status === filters.status;
                
                return matchesSearch && matchesBatch && matchesStatus;
            });

            const columns = [
                { title: 'DATE', dataIndex: 'date', key: 'date' },
                { title: 'BATCH', dataIndex: 'batch', key: 'batch' },
                { title: 'TIME SLOT', dataIndex: 'timeSlot', key: 'timeSlot' },
                { title: 'TRAINER', dataIndex: 'trainer', key: 'trainer' },
                { title: 'STATUS', dataIndex: 'status', key: 'status' },
                { title: 'DURATION', dataIndex: 'duration', key: 'duration' },
                { title: 'NOTES', dataIndex: 'notes', key: 'notes' },
            ];

            const handleReset = () => {
                setFilters({
                    search: '',
                    batch: 'All Batch',
                    month: 'All Months',
                    status: 'All Status'
                });
            };

            return (
                <div style={{ maxWidth: 1200, margin: '0 auto' }}>
                    {/* Header */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 32 }}>
                        <div>
                            <h1 style={{ fontSize: '1.75rem', fontWeight: 800, color: '#1e1b4b', margin: 0 }}>
                                <CalendarOutlined style={{ marginRight: 12 }} />
                                My Schedule
                            </h1>
                            <p style={{ color: '#64748B', marginTop: 4 }}>View your upcoming training sessions and manage your schedule.</p>
                        </div>
                        <Button 
                            icon={<i className="bi bi-arrow-left me-2"></i>}
                            onClick={() => window.location.href = '${pageContext.request.contextPath}/users/training-journey'}
                            style={{ borderRadius: 10, fontWeight: 600, height: 40 }}
                        >
                            Back to Journey
                        </Button>
                    </div>

                    {/* Stats Grid */}
                    <Row gutter={[24, 24]} style={{ marginBottom: 32 }}>
                        {stats.map((stat, idx) => (
                            <Col xs={24} sm={12} md={8} lg={4} key={idx}>
                                <Card bodyStyle={{ padding: 20 }}>
                                    <div className="stat-icon-wrapper" style={{ backgroundColor: stat.color, color: stat.iconColor }}>
                                        {stat.icon}
                                    </div>
                                    <div className="stat-card-title">{stat.title}</div>
                                    <div className="stat-card-value">{stat.value}</div>
                                    <div className="stat-card-label">{stat.label}</div>
                                </Card>
                            </Col>
                        ))}
                    </Row>

                    {/* Filters */}
                    <Card bodyStyle={{ padding: 16 }} style={{ marginBottom: 24 }}>
                        <Space wrap size={16} style={{ width: '100%', justifyContent: 'space-between' }}>
                            <Space wrap size={16}>
                                <Input 
                                    prefix={<SearchOutlined style={{ color: '#94A3B8' }} />}
                                    placeholder="Search by batch or trainer..."
                                    style={{ width: 300 }}
                                    value={filters.search}
                                    onChange={e => setFilters({...filters, search: e.target.value})}
                                />
                                <Select 
                                    style={{ width: 160 }}
                                    value={filters.batch}
                                    options={[{ label: 'All Batch', value: 'All Batch' }]}
                                    onChange={val => setFilters({...filters, batch: val})}
                                />
                                <Select 
                                    style={{ width: 160 }}
                                    value={filters.month}
                                    options={[{ label: 'All Months', value: 'All Months' }]}
                                    onChange={val => setFilters({...filters, month: val})}
                                />
                                <Select 
                                    style={{ width: 160 }}
                                    value={filters.status}
                                    options={[{ label: 'All Status', value: 'All Status' }]}
                                    onChange={val => setFilters({...filters, status: val})}
                                />
                            </Space>
                            <Button 
                                icon={<ReloadOutlined />} 
                                onClick={handleReset}
                                style={{ borderRadius: 10, fontWeight: 600 }}
                            >
                                Reset
                            </Button>
                        </Space>
                    </Card>

                    {/* Table */}
                    <Card bodyStyle={{ padding: 0 }}>
                        <Table 
                            loading={loading}
                            columns={columns}
                            dataSource={filteredData}
                            pagination={false}
                            locale={{
                                emptyText: (
                                    <div className="empty-state-container">
                                        <Empty 
                                            image="https://gw.alipayobjects.com/zos/antfincdn/ZHrcdLPrvN/empty.svg"
                                            imageStyle={{ height: 100 }}
                                            description={null}
                                        />
                                        <h3 className="empty-state-title">No schedule records found.</h3>
                                        <p className="empty-state-desc">You don't have any classes scheduled yet.</p>
                                        <Button 
                                            type="primary" 
                                            style={{ backgroundColor: '#1e1b4b' }}
                                        >
                                            No Classes Scheduled
                                        </Button>
                                    </div>
                                )
                            }}
                        />
                        
                        {/* Footer / Pagination Mock */}
                        <div style={{ padding: '16px 24px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderTop: '1px solid #F1F5F9' }}>
                            <span style={{ color: '#64748B', fontSize: '0.85rem' }}>
                                Showing {filteredData.length > 0 ? 1 : 0} to {filteredData.length} of {data.length} classes
                            </span>
                            <Pagination 
                                disabled={filteredData.length === 0} 
                                defaultCurrent={1} 
                                total={filteredData.length} 
                                pageSize={10}
                            />
                        </div>
                    </Card>
                </div>
            );
        };

        // Render with Error Boundary / Fallback check for icons
        const root = ReactDOM.createRoot(document.getElementById('react-root'));
        root.render(<App />);
    </script>
</body>
</html>

