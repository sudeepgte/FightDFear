<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>User Dashboard — Fight D Fear</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css" rel="stylesheet">

<style>
    :root {
        --fdf-rose: #F43F5E;
        --fdf-rose-dark: #E11D48;
        --fdf-rose-soft: #FFF1F2;
        --fdf-rose-light: #FFE4E6;
        --fdf-navy: #0F172A;
        --fdf-muted: #64748B;
        --fdf-border: #E2E8F0;
        --fdf-bg: #F8FAFC;
        --fdf-white: #FFFFFF;
        --shadow-card: 0 4px 20px rgba(15, 23, 42, 0.04);
        --radius-lg: 18px;
        --radius-md: 14px;
    }

    body {
        background: var(--fdf-bg);
        overflow-x: hidden;
        font-family: 'Poppins', 'Inter', sans-serif;
        color: var(--fdf-navy);
    }

    #page-content-wrapper {
        flex: 1;
        min-width: 0;
        display: flex;
        flex-direction: column;
        padding: 28px 28px 40px !important;
        background: var(--fdf-bg) !important;
    }

    .ud-greeting h1 {
        font-size: 1.65rem;
        font-weight: 800;
        color: var(--fdf-navy);
        margin: 0 0 4px;
        letter-spacing: -0.3px;
    }
    .ud-greeting p {
        color: var(--fdf-muted);
        font-size: 0.95rem;
        margin: 0;
    }

    .ud-card {
        background: var(--fdf-white);
        border: 1px solid var(--fdf-border);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-card);
        padding: 22px;
        height: 100%;
    }

    .ud-section-title {
        font-size: 1.05rem;
        font-weight: 700;
        color: var(--fdf-navy);
        margin: 0 0 16px;
    }

    /* Profile completion */
    .ud-profile-card {
        display: flex;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
        background: var(--fdf-white);
        border: 1px solid var(--fdf-border);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-card);
        padding: 22px 24px;
        margin: 22px 0 24px;
    }
    .ud-ring {
        width: 72px;
        height: 72px;
        border-radius: 50%;
        display: grid;
        place-items: center;
        flex-shrink: 0;
        background:
            radial-gradient(closest-side, #fff 72%, transparent 73% 100%),
            conic-gradient(var(--fdf-rose) calc(var(--pct) * 1%), var(--fdf-rose-light) 0);
    }
    .ud-ring span {
        font-weight: 800;
        font-size: 0.95rem;
        color: var(--fdf-rose);
    }
    .ud-profile-card .copy { flex: 1; min-width: 200px; }
    .ud-profile-card .copy h3 {
        font-size: 1.05rem;
        font-weight: 700;
        margin: 0 0 4px;
        color: var(--fdf-navy);
    }
    .ud-profile-card .copy p {
        margin: 0;
        color: var(--fdf-muted);
        font-size: 0.88rem;
    }
    .btn-ud-primary {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: var(--fdf-rose);
        color: #fff !important;
        border: none;
        border-radius: 999px;
        padding: 11px 20px;
        font-weight: 700;
        font-size: 0.88rem;
        text-decoration: none !important;
        white-space: nowrap;
        transition: background 0.2s, transform 0.15s;
    }
    .btn-ud-primary:hover { background: var(--fdf-rose-dark); color: #fff !important; transform: translateY(-1px); }
    .btn-ud-outline {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: #fff;
        color: var(--fdf-rose) !important;
        border: 1.5px solid var(--fdf-rose);
        border-radius: 999px;
        padding: 10px 18px;
        font-weight: 700;
        font-size: 0.88rem;
        text-decoration: none !important;
        transition: background 0.2s;
    }
    .btn-ud-outline:hover { background: var(--fdf-rose-soft); }

    /* Stat cards */
    .ud-stats {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 16px;
        margin-bottom: 24px;
    }
    .ud-stat {
        background: var(--fdf-white);
        border: 1px solid var(--fdf-border);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-card);
        padding: 20px;
        display: flex;
        flex-direction: column;
        gap: 10px;
        min-width: 0;
    }
    .ud-stat-icon {
        width: 42px;
        height: 42px;
        border-radius: 12px;
        background: var(--fdf-rose-soft);
        color: var(--fdf-rose);
        display: grid;
        place-items: center;
        font-size: 1.15rem;
    }
    .ud-stat .num {
        font-size: 1.75rem;
        font-weight: 800;
        color: var(--fdf-navy);
        line-height: 1.1;
    }
    .ud-stat .label {
        font-size: 0.86rem;
        color: var(--fdf-muted);
        font-weight: 500;
    }
    .ud-stat a {
        font-size: 0.82rem;
        font-weight: 700;
        color: var(--fdf-rose);
        text-decoration: none;
    }
    .ud-stat a:hover { text-decoration: underline; }

    .ud-grid {
        display: grid;
        grid-template-columns: minmax(0, 1.6fr) minmax(260px, 0.9fr);
        gap: 20px;
        align-items: start;
    }

    .ud-empty {
        text-align: center;
        padding: 28px 16px 12px;
        color: var(--fdf-muted);
    }
    .ud-empty-icon {
        width: 72px;
        height: 72px;
        margin: 0 auto 14px;
        border-radius: 18px;
        background: var(--fdf-rose-soft);
        color: var(--fdf-rose);
        display: grid;
        place-items: center;
        font-size: 1.8rem;
    }
    .ud-empty h4 {
        font-size: 1rem;
        font-weight: 700;
        color: var(--fdf-navy);
        margin: 0 0 6px;
    }
    .ud-empty p {
        font-size: 0.88rem;
        margin: 0 0 16px;
        max-width: 320px;
        margin-left: auto;
        margin-right: auto;
    }
    .ud-empty-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        justify-content: center;
    }

    .ud-booking-row {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        align-items: flex-start;
        padding: 14px 0;
        border-bottom: 1px solid var(--fdf-border);
    }
    .ud-booking-row:last-child { border-bottom: none; padding-bottom: 0; }
    .ud-booking-row:first-child { padding-top: 0; }
    .ud-badge {
        display: inline-block;
        font-size: 0.72rem;
        font-weight: 700;
        padding: 3px 10px;
        border-radius: 999px;
        background: var(--fdf-rose-soft);
        color: var(--fdf-rose-dark);
        border: 1px solid var(--fdf-rose-light);
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    .ud-qa-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }
    .ud-qa {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
        padding: 14px;
        border-radius: 14px;
        background: var(--fdf-bg);
        border: 1px solid var(--fdf-border);
        text-decoration: none !important;
        color: var(--fdf-navy) !important;
        font-size: 0.82rem;
        font-weight: 600;
        transition: border-color 0.2s, background 0.2s;
        min-height: 88px;
    }
    .ud-qa:hover {
        border-color: #FECDD3;
        background: var(--fdf-rose-soft);
        color: var(--fdf-navy) !important;
    }
    .ud-qa i {
        width: 34px;
        height: 34px;
        border-radius: 10px;
        background: #fff;
        border: 1px solid var(--fdf-border);
        color: var(--fdf-rose);
        display: grid;
        place-items: center;
    }

    .ud-side-stack { display: flex; flex-direction: column; gap: 16px; }
    .ud-side-card {
        background: var(--fdf-white);
        border: 1px solid var(--fdf-border);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-card);
        padding: 20px;
    }
    .ud-side-card .icon-lg {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        background: var(--fdf-rose-soft);
        color: var(--fdf-rose);
        display: grid;
        place-items: center;
        font-size: 1.2rem;
        margin-bottom: 12px;
    }
    .ud-side-card h4 {
        font-size: 1rem;
        font-weight: 700;
        margin: 0 0 6px;
    }
    .ud-side-card p {
        font-size: 0.86rem;
        color: var(--fdf-muted);
        margin: 0 0 14px;
        line-height: 1.5;
    }

    .ud-activity-item {
        display: flex;
        gap: 12px;
        align-items: flex-start;
        padding: 12px 0;
        border-bottom: 1px solid var(--fdf-border);
    }
    .ud-activity-item:last-child { border-bottom: none; }
    .ud-activity-dot {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        background: var(--fdf-rose-soft);
        color: var(--fdf-rose);
        display: grid;
        place-items: center;
        flex-shrink: 0;
    }

    @media (max-width: 1100px) {
        .ud-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .ud-grid { grid-template-columns: 1fr; }
    }
    @media (max-width: 768px) {
        #page-content-wrapper { padding: 16px 12px 28px !important; }
        .ud-greeting h1 { font-size: 1.35rem; }
        .ud-profile-card { padding: 18px; }
        .ud-stats { grid-template-columns: 1fr 1fr; gap: 12px; }
    }
    @media (max-width: 430px) {
        .ud-stats { grid-template-columns: 1fr; }
        .ud-qa-grid { grid-template-columns: 1fr; }
        .ud-profile-card { flex-direction: column; align-items: flex-start; }
        .btn-ud-primary, .btn-ud-outline { width: 100%; justify-content: center; }
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<div id="wrapper">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp" />

    <div id="page-content-wrapper" data-skip-global-back="true">

        <div class="ud-greeting d-flex justify-content-between align-items-start flex-wrap gap-2">
            <div>
                <h1>${dayGreeting}, <c:out value="${user.fullName}"/> 👋</h1>
                <p>Welcome back to Fight D Fear</p>
            </div>
            <c:if test="${isWorker}">
                <span class="ud-badge"><i class="fas fa-user-check me-1"></i> Verified Worker</span>
            </c:if>
        </div>

        <c:if test="${profileCompletionPct == null || profileCompletionPct < 100}">
            <div class="ud-profile-card">
                <div class="ud-ring" style="--pct: ${profileCompletionPct != null ? profileCompletionPct : 0};">
                    <span>${profileCompletionPct != null ? profileCompletionPct : 0}%</span>
                </div>
                <div class="copy">
                    <h3>Complete Your Profile</h3>
                    <p>Complete your profile to get the best personalised experience.
                        <c:if test="${not empty profileMissingItems}">
                            Missing:
                            <c:forEach var="m" items="${profileMissingItems}" varStatus="st">${m}<c:if test="${!st.last}">, </c:if></c:forEach>
                        </c:if>
                    </p>
                </div>
                <a class="btn-ud-primary" href="${pageContext.request.contextPath}/users/update/${user.id}">
                    Complete Profile <i class="bi bi-arrow-right"></i>
                </a>
            </div>
        </c:if>

        <div class="ud-stats">
            <div class="ud-stat">
                <div class="ud-stat-icon"><i class="bi bi-calendar2-heart"></i></div>
                <div class="num">${upcomingFitnessCount != null ? upcomingFitnessCount : 0}</div>
                <div class="label">Active Fitness Bookings</div>
                <c:if test="${upcomingFitnessCount == null || upcomingFitnessCount == 0}">
                    <a href="${pageContext.request.contextPath}/fitness">Explore Fitness →</a>
                </c:if>
                <c:if test="${upcomingFitnessCount != null && upcomingFitnessCount > 0}">
                    <a href="${pageContext.request.contextPath}/fitness/bookings">View bookings →</a>
                </c:if>
            </div>
            <div class="ud-stat">
                <div class="ud-stat-icon"><i class="bi bi-shield-check"></i></div>
                <div class="num">${activeEnrollmentCount != null ? activeEnrollmentCount : 0}</div>
                <div class="label">Martial Arts Enrollments</div>
                <c:if test="${activeEnrollmentCount == null || activeEnrollmentCount == 0}">
                    <a href="${pageContext.request.contextPath}/centres/allacceptedcentres">Explore Martial Arts →</a>
                </c:if>
                <c:if test="${activeEnrollmentCount != null && activeEnrollmentCount > 0}">
                    <a href="${pageContext.request.contextPath}/centres/allacceptedcentres">View centres →</a>
                </c:if>
            </div>
            <div class="ud-stat">
                <div class="ud-stat-icon"><i class="bi bi-building"></i></div>
                <div class="num">${approvedCentreCount != null ? approvedCentreCount : 0}</div>
                <div class="label">Martial Arts Centres</div>
            </div>
            <div class="ud-stat">
                <div class="ud-stat-icon"><i class="bi bi-bell"></i></div>
                <div class="num">${unreadBroadcastCount != null ? unreadBroadcastCount : 0}</div>
                <div class="label">Unread Alerts</div>
            </div>
        </div>

        <div class="ud-grid">
            <div class="d-flex flex-column gap-3">
                <!-- Upcoming -->
                <div class="ud-card">
                    <h2 class="ud-section-title">Upcoming Bookings</h2>

                    <c:set var="hasUpcoming" value="${(not empty upcomingFitnessBookings) || (not empty userEnrollments)}" />

                    <c:choose>
                        <c:when test="${hasUpcoming}">
                            <c:forEach var="b" items="${upcomingFitnessBookings}">
                                <div class="ud-booking-row">
                                    <div>
                                        <div class="fw-bold text-dark mb-1">
                                            <c:out value="${not empty b.category ? b.category : 'Fitness Session'}"/>
                                            <c:if test="${not empty b.trainer}"><span class="text-muted fw-normal"> · <c:out value="${b.trainer.fullName}"/></span></c:if>
                                        </div>
                                        <div class="small text-muted">
                                            <i class="bi bi-calendar3 me-1"></i>${b.bookingDate}
                                            <c:if test="${not empty b.bookingTime}"> · ${b.bookingTime}</c:if>
                                        </div>
                                    </div>
                                    <span class="ud-badge">${b.status}</span>
                                </div>
                            </c:forEach>
                            <c:forEach var="e" items="${userEnrollments}" end="4">
                                <div class="ud-booking-row">
                                    <div>
                                        <div class="fw-bold text-dark mb-1">
                                            Martial Arts Enrollment
                                            <c:if test="${not empty e.center}"><span class="text-muted fw-normal"> · <c:out value="${e.center.name}"/></span></c:if>
                                        </div>
                                        <div class="small text-muted">
                                            <c:if test="${not empty e.batch}">
                                                <i class="bi bi-people me-1"></i><c:out value="${e.batch.name}"/>
                                                <c:if test="${not empty e.batch.timeSlot}"> · ${e.batch.timeSlot}</c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                    <span class="ud-badge">${e.status}</span>
                                </div>
                            </c:forEach>
                            <div class="mt-3">
                                <a class="btn-ud-outline" href="${pageContext.request.contextPath}/fitness/bookings">My Fitness Bookings</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="ud-empty">
                                <div class="ud-empty-icon"><i class="bi bi-calendar2-x"></i></div>
                                <h4>You have no upcoming bookings</h4>
                                <p>Explore fitness classes or martial arts centres to get started.</p>
                                <div class="ud-empty-actions">
                                    <a class="btn-ud-primary" href="${pageContext.request.contextPath}/fitness">Explore Fitness</a>
                                    <a class="btn-ud-outline" href="${pageContext.request.contextPath}/centres/allacceptedcentres">Explore Martial Arts</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Recent activity -->
                <div class="ud-card">
                    <h2 class="ud-section-title">Recent Activity</h2>
                    <c:set var="hasActivity" value="${(not empty upcomingFitnessBookings) || (not empty userEnrollments) || (not empty completedFitnessBookings) || (not empty activeSubscriptions)}" />
                    <c:choose>
                        <c:when test="${hasActivity}">
                            <c:forEach var="b" items="${upcomingFitnessBookings}" end="2">
                                <div class="ud-activity-item">
                                    <div class="ud-activity-dot"><i class="bi bi-activity"></i></div>
                                    <div>
                                        <div class="fw-semibold small">Fitness booking · <c:out value="${b.status}"/></div>
                                        <div class="text-muted" style="font-size:0.8rem;">
                                            <c:out value="${b.category}"/> · ${b.bookingDate}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:forEach var="e" items="${userEnrollments}" end="2">
                                <div class="ud-activity-item">
                                    <div class="ud-activity-dot"><i class="bi bi-shield"></i></div>
                                    <div>
                                        <div class="fw-semibold small">Martial arts enrollment · <c:out value="${e.status}"/></div>
                                        <div class="text-muted" style="font-size:0.8rem;">
                                            <c:if test="${not empty e.center}"><c:out value="${e.center.name}"/></c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:forEach var="c" items="${completedFitnessBookings}" end="1">
                                <div class="ud-activity-item">
                                    <div class="ud-activity-dot"><i class="bi bi-check2-circle"></i></div>
                                    <div>
                                        <div class="fw-semibold small">Completed session awaiting review</div>
                                        <div class="text-muted" style="font-size:0.8rem;"><c:out value="${c.category}"/></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="ud-empty py-4">
                                <div class="ud-empty-icon"><i class="bi bi-activity"></i></div>
                                <h4>No recent activity yet</h4>
                                <p>Your recent bookings and activities will appear here.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="ud-side-stack">
                <div class="ud-side-card">
                    <h2 class="ud-section-title mb-3">Quick Actions</h2>
                    <div class="ud-qa-grid">
                        <a class="ud-qa" href="${pageContext.request.contextPath}/fitness">
                            <i class="bi bi-heart-pulse"></i>
                            Find Fitness Classes
                        </a>
                        <a class="ud-qa" href="${pageContext.request.contextPath}/centres/allacceptedcentres">
                            <i class="bi bi-shield-check"></i>
                            Find Martial Arts Centres
                        </a>
                        <a class="ud-qa" href="${pageContext.request.contextPath}/user/bookings">
                            <i class="bi bi-journal-check"></i>
                            My Bookings
                        </a>
                        <a class="ud-qa" href="${pageContext.request.contextPath}/users/profile/${user.id}">
                            <i class="bi bi-person"></i>
                            My Profile
                        </a>
                    </div>
                </div>

                <div class="ud-side-card">
                    <div class="icon-lg"><i class="bi bi-people"></i></div>
                    <h4>Join Our Community</h4>
                    <p>Stay updated with events, tips, and inspiration from Fight D Fear.</p>
                    <a class="btn-ud-primary" href="${pageContext.request.contextPath}/video/reels">Join Community <i class="bi bi-arrow-right"></i></a>
                </div>

                <div class="ud-side-card">
                    <div class="icon-lg"><i class="bi bi-headset"></i></div>
                    <h4>Need Help?</h4>
                    <p>Our support team is here to help you.</p>
                    <a class="btn-ud-primary" href="${pageContext.request.contextPath}/contact">Contact Support <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Broadcast alerts modal (header bell) -->
<div class="modal fade" id="broadcastModal" tabindex="-1" aria-labelledby="broadcastModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content border-0" style="border-radius:18px;">
      <div class="modal-header border-0" style="background:#FFF1F2;">
        <h5 class="modal-title fw-bold" id="broadcastModalLabel" style="color:#0F172A;">
          <i class="bi bi-bell-fill me-2" style="color:#F43F5E;"></i> Alerts
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <c:choose>
          <c:when test="${empty recentBroadcasts}">
            <p class="text-muted text-center py-4 mb-0">No alerts right now.</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="b" items="${recentBroadcasts}">
              <div class="mb-3 pb-3 border-bottom">
                <div class="fw-semibold" style="color:#0F172A;"><c:out value="${b.title != null ? b.title : 'Announcement'}"/></div>
                <div class="small text-muted mt-1"><c:out value="${b.message}"/></div>
                <c:if test="${not empty b.sentAt}">
                  <div class="small text-muted mt-1" style="font-size:0.75rem;">${b.sentAt}</div>
                </c:if>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>
<script>
function markBroadcastsAsRead() {
  fetch('${pageContext.request.contextPath}/users/broadcast/read', { method: 'POST' })
    .then(function () {
      var badge = document.getElementById('broadcastBadge');
      if (badge) badge.style.display = 'none';
    })
    .catch(function () {});
}
</script>
</body>
</html>
