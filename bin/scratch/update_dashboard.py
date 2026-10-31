import re

file_path = r"c:\Users\priya\Desktop\FightDfire\FightDFear\src\main\webapp\WEB-INF\views\salon\salon-dashboard.jsp"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Sidebar Brand
content = content.replace(
    "<span>Priya Beauty & Wellness</span>",
    "<span>${empty salon.name ? 'Priya Beauty & Wellness' : salon.name}</span>"
)

# 2. Sidebar Profile Link
content = content.replace(
    """<a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Business Profile</span>
                </a>""",
    """<a class="nav-link-custom" href="${pageContext.request.contextPath}/salons/profile">
                    <i class="bi bi-shop"></i>
                    <span>Business Profile</span>
                </a>
                <a class="nav-link-custom" href="${pageContext.request.contextPath}/salon/profile/view/${salon.id}" target="_blank">
                    <i class="bi bi-person-badge"></i>
                    <span>Public Profile</span>
                </a>"""
)

# 3. Dashboard Header
content = content.replace(
    "<h2>Welcome back, Priya! ✨</h2>",
    "<h2>Welcome back, ${empty salon.name ? 'Priya' : salon.name}! ✨</h2>"
)

# 4. Header Profile Button
content = content.replace(
    """<img src="${pageContext.request.contextPath}/assets/images/img6.jpg" alt="Priya Sharma" onerror="this.src='https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=60'">
                        <div class="info">
                            <h6>Priya Sharma</h6>
                            <span>Owner</span>
                        </div>""",
    """<img src="${not empty salon.profileImageUrl ? pageContext.request.contextPath.concat(salon.profileImageUrl) : pageContext.request.contextPath.concat('/assets/images/img6.jpg')}" alt="Owner" onerror="this.src='https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format&fit=crop&q=60'">
                        <div class="info">
                            <h6>${empty salon.name ? 'Owner' : salon.name}</h6>
                            <span>Owner</span>
                        </div>"""
)

# 5. Date and Status
content = content.replace(
    "<span>10 May 2026, Saturday</span>",
    "<span>${empty todayDate ? '10 May 2026, Saturday' : todayDate}</span>"
)
content = content.replace(
    "(Closes at 9:00 PM)",
    "(Hours: ${empty salon.availabilityHours ? '09:00 AM - 09:00 PM' : salon.availabilityHours})"
)

# 6. KPI Card 1: Today's Appts
content = content.replace(
    """<span>Today's Appts</span>
                            <h3>24</h3>""",
    """<span>Today's Appts</span>
                            <h3>${todayCount != null ? todayCount : 24}</h3>"""
)

# 7. KPI Card 2: Completed
content = content.replace(
    """<span>Completed</span>
                            <h3>18</h3>""",
    """<span>Completed</span>
                            <h3>${completedCount != null ? completedCount : 18}</h3>"""
)

# 8. KPI Card 3: Today's Revenue
content = content.replace(
    """<span>Today's Revenue</span>
                            <h3>₹32,450</h3>""",
    """<span>Today's Revenue</span>
                            <h3>₹${todayRevenue != null ? todayRevenue : '32,450'}</h3>"""
)

# 9. KPI Card 4: New Customers -> Total Bookings
content = content.replace(
    """<span>New Customers</span>
                            <h3>6</h3>""",
    """<span>Total Bookings</span>
                            <h3>${totalBookings != null ? totalBookings : 0}</h3>"""
)

# 10. KPI Card 5: Average Rating
content = content.replace(
    """<span>Average Rating</span>
                            <h3>4.9 ★</h3>
                            <div class="kpi-trend" style="color: #f59e0b; font-weight:700;">Based on 236 reviews</div>""",
    """<span>Average Rating</span>
                            <h3>${avgRating != null ? avgRating : '4.9'} ★</h3>
                            <div class="kpi-trend" style="color: #f59e0b; font-weight:700;">Based on ${reviewCount != null ? reviewCount : 236} reviews</div>"""
)

# 11. Our Services Card
services_grid_orig = """<div class="services-grid">
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-gem"></i></div>
                                <h6>Hair Care</h6>
                                <span>18 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-heart-pulse"></i></div>
                                <h6>Skin Care</h6>
                                <span>16 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-palette"></i></div>
                                <h6>Makeup</h6>
                                <span>14 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-person-check"></i></div>
                                <h6>Bridal</h6>
                                <span>12 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-hand-index"></i></div>
                                <h6>Nail Care</h6>
                                <span>10 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-scissors"></i></div>
                                <h6>Hair Styling</h6>
                                <span>12 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-droplet"></i></div>
                                <h6>Hair Treatment</h6>
                                <span>8 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-flower1"></i></div>
                                <h6>Body Spa</h6>
                                <span>10 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-stars"></i></div>
                                <h6>Facials</h6>
                                <span>12 Services</span>
                            </div>
                            <div class="service-cat-item">
                                <div class="icon-circle"><i class="bi bi-three-dots"></i></div>
                                <h6>More</h6>
                                <span>8+ Services</span>
                            </div>
                        </div>"""

services_grid_new = """<div class="services-grid">
                            <c:choose>
                                <c:when test="${not empty allServices}">
                                    <c:forEach items="${allServices}" var="svc" end="9">
                                        <div class="service-cat-item">
                                            <div class="icon-circle"><i class="bi bi-gem"></i></div>
                                            <h6>${svc.name}</h6>
                                            <span>₹${svc.price}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12 text-center text-muted py-3">No services added yet.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>"""

content = content.replace(services_grid_orig, services_grid_new)

# 12. Today's Schedule Card
schedule_orig = """<div class="timeline-wrapper">
                            <div class="timeline-item">
                                <div class="timeline-time">09:00 AM</div>
                                <div class="timeline-info">
                                    <h6>Riya Sharma</h6>
                                    <span>Hair Spa • Staff: Priya</span>
                                </div>
                                <span class="timeline-status status-confirmed">Confirmed</span>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-time">09:30 AM</div>
                                <div class="timeline-info">
                                    <h6>Neha Verma</h6>
                                    <span>Skin Brightening Facial • Staff: Anjali</span>
                                </div>
                                <span class="timeline-status status-confirmed">Confirmed</span>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-time">10:00 AM</div>
                                <div class="timeline-info">
                                    <h6>Pooja Mehta</h6>
                                    <span>Hair Cut & Styling • Staff: Priya</span>
                                </div>
                                <span class="timeline-status status-inprogress">In Progress</span>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-time">10:45 AM</div>
                                <div class="timeline-info">
                                    <h6>Anjali Singh</h6>
                                    <span>Gel Nail Extension • Staff: Megha</span>
                                </div>
                                <span class="timeline-status status-confirmed">Confirmed</span>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-time">11:30 AM</div>
                                <div class="timeline-info">
                                    <h6>Walk-in Client</h6>
                                    <span>Threading</span>
                                </div>
                                <span class="timeline-status status-walkin">Walk-in</span>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-time">12:15 PM</div>
                                <div class="timeline-info">
                                    <h6>Kavya Patel</h6>
                                    <span>Hair Colour • Staff: Priya</span>
                                </div>
                                <span class="timeline-status status-confirmed">Confirmed</span>
                            </div>
                        </div>"""

schedule_new = """<div class="timeline-wrapper">
                            <c:choose>
                                <c:when test="${not empty todayBookings}">
                                    <c:forEach items="${todayBookings}" var="bkg" end="5">
                                        <div class="timeline-item">
                                            <div class="timeline-time">
                                                ${bkg.bookingTime.toLocalTime().toString()}
                                            </div>
                                            <div class="timeline-info">
                                                <h6>${bkg.user.name != null ? bkg.user.name : 'Client'}</h6>
                                                <span>${bkg.service.name} • Staff: ${bkg.stylist.firstName}</span>
                                            </div>
                                            <c:choose>
                                                <c:when test="${bkg.status == 'COMPLETED'}">
                                                    <span class="timeline-status status-confirmed" style="background:#e6fcf5;color:#0ca678;">Completed</span>
                                                </c:when>
                                                <c:when test="${bkg.status == 'PENDING'}">
                                                    <span class="timeline-status status-walkin" style="background:#fdf2f8;color:#db2777;">Pending</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="timeline-status status-inprogress" style="background:#e7f5ff;color:#1c7ed6;">${bkg.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-3">No appointments scheduled today.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>"""
content = content.replace(schedule_orig, schedule_new)

# 13. Donut chart numbers
content = content.replace(
    """<ul class="donut-legend mt-2">
                                    <li><span class="legend-color" style="background:#10b981;"></span> Completed (98)</li>
                                    <li><span class="legend-color" style="background:#3b82f6;"></span> Pending (32)</li>
                                    <li><span class="legend-color" style="background:#ef4444;"></span> Cancelled (12)</li>
                                </ul>""",
    """<ul class="donut-legend mt-2">
                                    <li><span class="legend-color" style="background:#10b981;"></span> Completed (${completedCount != null ? completedCount : 98})</li>
                                    <li><span class="legend-color" style="background:#3b82f6;"></span> Pending (${pendingCount != null ? pendingCount : 32})</li>
                                    <li><span class="legend-color" style="background:#ef4444;"></span> Others (${todayCount - completedCount - pendingCount})</li>
                                </ul>"""
)

content = content.replace(
    """<h4 style="font-weight:800; margin-top:2px; font-size:1.4rem;">142</h4>""",
    """<h4 style="font-weight:800; margin-top:2px; font-size:1.4rem;">${todayCount != null ? todayCount : 142}</h4>"""
)

content = content.replace(
    """<text x="50%" y="54%" class="chart-number" text-anchor="middle" font-size="6" font-weight="800" fill="var(--fdf-text-dark)">142</text>""",
    """<text x="50%" y="54%" class="chart-number" text-anchor="middle" font-size="6" font-weight="800" fill="var(--fdf-text-dark)">${todayCount != null ? todayCount : 142}</text>"""
)

# 14. Recent Appointments Table
table_orig = """<tbody>
                                    <tr>
                                        <td>
                                            <div class="avatar-info">
                                                <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                                <h6>Sneha Jain</h6>
                                            </div>
                                        </td>
                                        <td>Hair Cut & Styling</td>
                                        <td>10 May, 09:00 AM</td>
                                        <td><span class="timeline-status status-confirmed">Confirmed</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="avatar-info">
                                                <img src="${pageContext.request.contextPath}/assets/images/img2.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=60'">
                                                <h6>Megha Patel</h6>
                                            </div>
                                        </td>
                                        <td>Hair Spa</td>
                                        <td>10 May, 09:30 AM</td>
                                        <td><span class="timeline-status status-confirmed">Confirmed</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="avatar-info">
                                                <img src="${pageContext.request.contextPath}/assets/images/img3.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60'">
                                                <h6>Pooja Mehta</h6>
                                            </div>
                                        </td>
                                        <td>Hair Colour</td>
                                        <td>10 May, 10:00 AM</td>
                                        <td><span class="timeline-status status-inprogress">In Progress</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="avatar-info">
                                                <span class="icon-btn-circle d-flex align-items-center justify-content-center" style="width:32px; height:32px; font-size:0.8rem; background:#eae7ee; font-weight:700;">WI</span>
                                                <h6 style="margin-left:12px;">Walk-in Client</h6>
                                            </div>
                                        </td>
                                        <td>Threading</td>
                                        <td>10 May, 10:45 AM</td>
                                        <td><span class="timeline-status status-walkin">Walk-in</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="avatar-info">
                                                <img src="${pageContext.request.contextPath}/assets/images/img4.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&auto=format&fit=crop&q=60'">
                                                <h6>Anjali Singh</h6>
                                            </div>
                                        </td>
                                        <td>Facial</td>
                                        <td>10 May, 11:30 AM</td>
                                        <td><span class="timeline-status status-confirmed">Confirmed</span></td>
                                    </tr>
                                </tbody>"""

table_new = """<tbody>
                                    <c:choose>
                                        <c:when test="${not empty todayBookings}">
                                            <c:forEach items="${todayBookings}" var="b" end="4">
                                                <tr>
                                                    <td>
                                                        <div class="avatar-info">
                                                            <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="Client" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                                            <h6>${b.user.name != null ? b.user.name : 'Client'}</h6>
                                                        </div>
                                                    </td>
                                                    <td>${b.service.name}</td>
                                                    <td>${b.bookingTime.toLocalDate().toString()}, ${b.bookingTime.toLocalTime().toString()}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${b.status == 'COMPLETED'}">
                                                                <span class="timeline-status status-confirmed" style="background:#e6fcf5;color:#0ca678;">Completed</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="timeline-status status-inprogress" style="background:#e7f5ff;color:#1c7ed6;">${b.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="4" class="text-center text-muted">No appointments today.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>"""
content = content.replace(table_orig, table_new)

# 15. Recent Reviews
reviews_orig = """<div class="reviews-wrapper">
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="review-author">
                                        <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="User" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                        <h6>Priya S.</h6>
                                    </div>
                                    <div class="stars-box">
                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                    </div>
                                </div>
                                <p class="review-text">"Amazing experience! Very professional staff and excellent service."</p>
                                <span class="review-time">2 hours ago</span>
                            </div>
                            
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="review-author">
                                        <img src="${pageContext.request.contextPath}/assets/images/img2.jpg" alt="User" onerror="this.src='https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&auto=format&fit=crop&q=60'">
                                        <h6>Neha V.</h6>
                                    </div>
                                    <div class="stars-box">
                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                    </div>
                                </div>
                                <p class="review-text">"Loved the facial and hair spa. My skin feels so fresh and glowing."</p>
                                <span class="review-time">1 day ago</span>
                            </div>
                            
                            <div class="review-item">
                                <div class="review-header">
                                    <div class="review-author">
                                        <img src="${pageContext.request.contextPath}/assets/images/img3.jpg" alt="User" onerror="this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60'">
                                        <h6>Anjali M.</h6>
                                    </div>
                                    <div class="stars-box">
                                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                    </div>
                                </div>
                                <p class="review-text">"Best salon in town! Highly recommend for event and bridal makeup."</p>
                                <span class="review-time">2 days ago</span>
                            </div>
                        </div>"""

reviews_new = """<div class="reviews-wrapper">
                            <c:choose>
                                <c:when test="${not empty recentReviews}">
                                    <c:forEach items="${recentReviews}" var="rev" end="2">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <div class="review-author">
                                                    <img src="${pageContext.request.contextPath}/assets/images/img1.jpg" alt="User" onerror="this.src='https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop&q=60'">
                                                    <h6>${rev.user != null ? rev.user.name : 'Client'}</h6>
                                                </div>
                                                <div class="stars-box">
                                                    <c:forEach begin="1" end="${rev.rating}">
                                                        <i class="bi bi-star-fill"></i>
                                                    </c:forEach>
                                                    <c:forEach begin="${rev.rating + 1}" end="5">
                                                        <i class="bi bi-star"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <p class="review-text">"${rev.comment}"</p>
                                            <span class="review-time">${rev.createdAt.toLocalDate().toString()}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-3">No reviews yet.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>"""
content = content.replace(reviews_orig, reviews_new)

# 16. Bottom Summary Bar (Staff Count & Services Count)
content = content.replace(
    """<span>Staff on Duty</span>
                        <h5>6 <span style="font-size:0.72rem; color:#10b981; font-weight:600;">(Active)</span></h5>""",
    """<span>Total Staff</span>
                        <h5>${staffCount != null ? staffCount : 6} <span style="font-size:0.72rem; color:#10b981; font-weight:600;">(Active)</span></h5>"""
)

content = content.replace(
    """<span>Products in Stock</span>
                        <h5>132 <span style="font-size:0.75rem; color:#10b981; font-weight:700;">In Stock</span></h5>""",
    """<span>Total Services</span>
                        <h5>${servicesCount != null ? servicesCount : 0} <span style="font-size:0.75rem; color:#10b981; font-weight:700;">Active</span></h5>"""
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated salon-dashboard.jsp successfully.")
