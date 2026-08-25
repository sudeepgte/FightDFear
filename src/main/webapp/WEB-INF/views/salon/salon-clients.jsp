<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Clients | Fight D Fear</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Fight D Fear-theme.css">
    <!-- Global Dashboard Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/salon-global-theme.css">

    <style>
        :root {
            --sidebar-width: 280px;
            --dashboard-bg: #f8f5ff;
            --brand-purple: #6a0dad;
            --brand-purple-darker: #4a0080;
            --gradient-dark: linear-gradient(135deg, #2b1055 0%, #7597de 100%);
            --fdf-border: #eee;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--dashboard-bg);
            color: var(--brand-purple-darker);
            margin: 0;
            overflow-x: hidden;
        }

        /* Modern Sidebar */
        .sidebar {
            background: var(--gradient-dark);
            color: white;
        }

        .sidebar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: 1.5rem;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            text-decoration: none;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .nav-link-custom i {
            font-size: 1.2rem;
        }

        /* Main Content */
        .main-content {
            padding: 40px;
            min-height: 100vh;
        }

        @media (min-width: 992px) {
            .sidebar {
                width: var(--sidebar-width);
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 30px 20px;
                z-index: 1000;
                box-shadow: 10px 0 30px rgba(0,0,0,0.1);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .glass-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }

        .page-header {
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-header h2 {
            font-weight: 800;
            color: var(--brand-purple-darker);
            margin: 0;
        }
        
        .btn-add-new {
            background: var(--brand-purple);
            color: white;
            padding: 10px 24px;
            border-radius: 50px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-add-new:hover {
            background: var(--brand-purple-darker);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(106, 13, 173, 0.3);
        }

        /* Dashboard Stats */
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            border: 1px solid var(--fdf-border);
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.05);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
        }
        
        .stat-purple { background: rgba(106, 13, 173, 0.1); color: var(--brand-purple); }
        .stat-success { background: rgba(32, 201, 151, 0.1); color: #20c997; }
        .stat-warning { background: rgba(255, 193, 7, 0.1); color: #ffc107; }
        .stat-info { background: rgba(13, 110, 253, 0.1); color: #0d6efd; }

        .stat-content h3 { font-size: 1.8rem; font-weight: 800; margin: 0; color: var(--brand-purple-darker); }
        .stat-content p { color: #6c757d; font-weight: 500; margin: 0; font-size: 0.9rem; }

        /* Client List */
        .client-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #f8f5ff;
        }

        .table-custom {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
        }
        
        .table-custom th {
            color: #6c757d;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0 20px;
            border: none;
        }
        
        .table-custom td {
            background: white;
            padding: 16px 20px;
            vertical-align: middle;
            border-top: 1px solid var(--fdf-border);
            border-bottom: 1px solid var(--fdf-border);
        }
        
        .table-custom td:first-child { border-left: 1px solid var(--fdf-border); border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .table-custom td:last-child { border-right: 1px solid var(--fdf-border); border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        
        .table-custom tr { transition: all 0.2s; }
        .table-custom tr:hover td { background: #fdfcff; }

        .status-badge {
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-New { background: rgba(32, 201, 151, 0.1); color: #20c997; }
        .status-Active { background: rgba(13, 110, 253, 0.1); color: #0d6efd; }
        .status-Returning { background: rgba(106, 13, 173, 0.1); color: var(--brand-purple); }

        .btn-view {
            background: #f8f9fa;
            color: var(--brand-purple-darker);
            border: none;
            padding: 6px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .btn-view:hover { background: var(--brand-purple); color: white; }

        .search-bar {
            background: white;
            border: 1px solid var(--fdf-border);
            border-radius: 50px;
            padding: 10px 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            max-width: 400px;
        }
        
        .search-bar input { border: none; outline: none; width: 100%; font-family: 'Poppins', sans-serif; }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar { padding: 20px; }
            .sidebar-brand-desktop { display: none; }
            .main-content { padding: 20px; margin-left: 0; }
        }
        
        .mobile-header {
            background: var(--gradient-dark);
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
        }
    </style>
</head>
<body>

    <!-- Mobile Header -->
    <div class="mobile-header d-lg-none shadow-sm">
        <h4 class="m-0 fw-bold d-flex align-items-center gap-2"><i class="bi bi-stars"></i> Fight D Fear</h4>
        <button class="btn btn-link text-white p-0 border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
            <i class="bi bi-list" style="font-size: 2rem;"></i>
        </button>
    </div>

    <!-- Sidebar -->
    <jsp:include page="../fragments/salon-sidebar.jsp">
    <jsp:param name="activeNav" value="clients"/>
</jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            
            <div class="page-header">
                <h2>Clients Dashboard</h2>
                <button type="button" class="btn-add-new" data-bs-toggle="modal" data-bs-target="#addClientModal">
                    <i class="bi bi-plus-lg"></i> Add Client
                </button>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-3 mb-4"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success rounded-3 mb-4"><i class="bi bi-check-circle-fill me-2"></i>${message}</div>
            </c:if>

            <!-- Stats -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="stat-icon stat-purple"><i class="bi bi-people-fill"></i></div>
                        <div class="stat-content">
                            <h3>${totalClients}</h3>
                            <p>Total Clients</p>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="stat-icon stat-success"><i class="bi bi-person-plus-fill"></i></div>
                        <div class="stat-content">
                            <h3>${newClients}</h3>
                            <p>New Clients</p>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="stat-icon stat-info"><i class="bi bi-arrow-repeat"></i></div>
                        <div class="stat-content">
                            <h3>${returningClients}</h3>
                            <p>Returning</p>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="stat-icon stat-warning"><i class="bi bi-activity"></i></div>
                        <div class="stat-content">
                            <h3>${activeClients}</h3>
                            <p>Active Clients</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div class="search-bar flex-grow-1">
                    <i class="bi bi-search text-muted"></i>
                    <input type="text" id="clientSearch" placeholder="Search by name, phone or email...">
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-secondary rounded-pill active filter-btn" data-filter="all">All</button>
                    <button class="btn btn-outline-secondary rounded-pill filter-btn" data-filter="New">New</button>
                    <button class="btn btn-outline-secondary rounded-pill filter-btn" data-filter="Returning">Returning</button>
                    <button class="btn btn-outline-secondary rounded-pill filter-btn" data-filter="Active">Active</button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table-custom" id="clientsTable">
                    <thead>
                        <tr>
                            <th>Client</th>
                            <th>Contact Info</th>
                            <th>Visits</th>
                            <th>Last Visit</th>
                            <th>Total Spent</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="data" items="${clientsData}">
                            <tr class="client-row" data-status="${data.status}">
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${not empty data.client.user.profilePhoto ? pageContext.request.contextPath.concat(data.client.user.profilePhoto) : 'https://ui-avatars.com/api/?name='.concat(data.client.user.fullName).concat('&background=6a0dad&color=fff')}" class="client-avatar" onerror="this.src='https://ui-avatars.com/api/?name=${data.client.user.fullName}&background=6a0dad&color=fff';">
                                        <div>
                                            <div class="fw-bold text-dark">${data.client.user.fullName}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="client-phone"><i class="bi bi-telephone text-muted me-1"></i> ${data.client.user.phoneNumber}</div>
                                    <div class="client-email small text-muted"><i class="bi bi-envelope me-1"></i> ${not empty data.client.user.email ? data.client.user.email : 'N/A'}</div>
                                </td>
                                <td><span class="fw-bold">${data.visits}</span> Visits</td>
                                <td>${data.lastVisit}</td>
                                <td><span class="fw-bold text-success">₹${data.totalSpent}</span></td>
                                <td><span class="status-badge status-${data.status}">${data.status}</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/salon/clients/view/${data.client.id}" class="btn-view">View <i class="bi bi-arrow-right"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty clientsData}">
                    <div class="text-center py-5">
                        <i class="bi bi-people text-muted" style="font-size: 3rem;"></i>
                        <h5 class="mt-3 fw-bold">No Clients Found</h5>
                        <p class="text-muted">Start adding your clients to manage their profiles.</p>
                    </div>
                </c:if>
            </div>

        </div>
    </div>

    <!-- Add Client Modal -->
    <div class="modal fade" id="addClientModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="border-radius: 20px; border: none;">
                <div class="modal-header border-0 pb-0">
                    <h4 class="modal-title fw-bold" style="color: var(--brand-purple-darker);">Add New Client</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/salon/clients/add" method="POST">
                        <div class="alert alert-info rounded-3 mb-4">
                            <i class="bi bi-info-circle-fill me-2"></i> If the phone number already exists, we will securely link their existing profile to your salon.
                        </div>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Full Name *</label>
                                <input type="text" name="fullName" class="form-control rounded-pill" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Phone Number *</label>
                                <input type="text" name="phoneNumber" class="form-control rounded-pill" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Email</label>
                                <input type="email" name="email" class="form-control rounded-pill">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold">Date of Birth</label>
                                <input type="date" name="dob" class="form-control rounded-pill">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold">Gender</label>
                                <select name="gender" class="form-select rounded-pill">
                                    <option value="">Select...</option>
                                    <option value="MALE">Male</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold">Home Address</label>
                                <input type="text" name="homeAddress" class="form-control rounded-pill">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold text-purple">Salon Notes <small class="text-muted fw-normal">(Only visible to your salon)</small></label>
                                <textarea name="clientNotes" class="form-control rounded-3" rows="2" placeholder="E.g., Preferred stylist, conversation topics..."></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold text-purple">Preferences <small class="text-muted fw-normal">(Product preferences, allergies, etc.)</small></label>
                                <textarea name="preferences" class="form-control rounded-3" rows="2" placeholder="E.g., Allergic to ammonia, prefers cold water wash..."></textarea>
                            </div>
                        </div>
                        
                        <div class="text-end mt-4">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-add-new px-5 ms-2">Save Client</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Simple client-side search and filter
        document.addEventListener('DOMContentLoaded', () => {
            const searchInput = document.getElementById('clientSearch');
            const filterBtns = document.querySelectorAll('.filter-btn');
            const rows = document.querySelectorAll('.client-row');

            let currentFilter = 'all';

            function filterRows() {
                const searchTerm = searchInput.value.toLowerCase();
                
                rows.forEach(row => {
                    const status = row.getAttribute('data-status');
                    const text = row.innerText.toLowerCase();
                    
                    const matchesSearch = text.includes(searchTerm);
                    const matchesFilter = currentFilter === 'all' || status === currentFilter;
                    
                    if (matchesSearch && matchesFilter) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            searchInput.addEventListener('input', filterRows);

            filterBtns.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    filterBtns.forEach(b => b.classList.remove('active', 'btn-secondary', 'text-white'));
                    filterBtns.forEach(b => b.classList.add('btn-outline-secondary'));
                    
                    e.target.classList.remove('btn-outline-secondary');
                    e.target.classList.add('active', 'btn-secondary', 'text-white');
                    
                    currentFilter = e.target.getAttribute('data-filter');
                    filterRows();
                });
            });
        });
    </script>
</body>
</html>

