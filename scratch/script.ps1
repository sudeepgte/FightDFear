$centre = Get-Content -Raw "src/main/webapp/WEB-INF/views/aboutCentre.jsp"
$entre = Get-Content -Raw "src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp"

# 1. Replace <head> entirely
$headStart = $centre.IndexOf("<head>")
$headEnd = $centre.IndexOf("</head>") + 7
$headHtml = $centre.Substring($headStart, $headEnd - $headStart)

# Update title
$headHtml = $headHtml -replace '<title>.*?</title>', '<title><c:out value="${entrepreneur.fullName}"/> — Entrepreneur Profile Review | Fight D Fear Admin</title>'

$entreHeadStart = $entre.IndexOf("<head>")
$entreHeadEnd = $entre.IndexOf("</head>") + 7
$entre = $entre.Remove($entreHeadStart, $entreHeadEnd - $entreHeadStart).Insert($entreHeadStart, $headHtml)

# 2. Extract wrapper layout
$wrapperMatch = [regex]::Match($centre, '(<c:choose>[\s\S]*?<div class="review-container"[\s\S]*?>)[\s\S]*?(<!-- Flash messages -->|<!-- 60/30/10)')
if ($wrapperMatch.Success) {
    $wrapperHtml = $wrapperMatch.Groups[1].Value
    
    # Fix the links for entrepreneur
    $wrapperHtml = $wrapperHtml -replace 'href=".*?/admin/martialManagement"', 'href="${pageContext.request.contextPath}/admin/pending-entrepreneurs"'
    $wrapperHtml = $wrapperHtml -replace 'Martial Arts Centres', 'Entrepreneurs'
    $wrapperHtml = $wrapperHtml -replace 'Back to Martial Arts Centres Management', 'Back to Entrepreneur Management'
    $wrapperHtml = $wrapperHtml -replace 'href=".*?/centres/dashboard"', 'href="${pageContext.request.contextPath}/entrepreneurs/dashboard"'
    $wrapperHtml = $wrapperHtml -replace 'Back to Centre Dashboard', 'Back to Entrepreneur Dashboard'

    # Replace the old topbar section in entrepreneur
    $entre = [regex]::Replace($entre, '<!-- Topbar -->[\s\S]*?<div class="review-container">[\s\S]*?<a href=".*?" class="back-nav">[\s\S]*?<\/a>', $wrapperHtml)
}

# 3. Ensure closing tags
if (-not $entre.Contains("</main>")) {
    $entre = $entre -replace '</body>', "</div></main></div></c:when><c:otherwise></div></c:otherwise></c:choose></body>"
}

# 4. Add the body class
$entre = $entre -replace '<body.*?>', '<body class="ap-page">'

# 5. Update header-card to hero-profile-card layout
$newHeader = @"
        <!-- 60/30/10 HERO PROFILE HEADER CARD -->
        <div class="hero-profile-card">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center gap-4">
                <div class="avatar-box">
                    <c:choose>
                        <c:when test="`${not empty entrepreneur.profilePhoto}">
                            <img src="`${pageContext.request.contextPath}`${entrepreneur.profilePhoto}" alt="<c:out value='`${entrepreneur.fullName}'/>">
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-person-circle" style="font-size:3.5rem; color:var(--ap-accent);"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex-grow-1" style="position:relative; z-index:1;">
                    <div class="d-flex flex-wrap align-items-center gap-3 mb-2">
                        <h1><c:out value="`${entrepreneur.fullName}"/></h1>
                        <c:set var="statusKey" value="`${entrepreneur.partnerProfileStatus != null ? entrepreneur.partnerProfileStatus : 'REGISTERED'}"/>
                        <span class="badge-status-lg status-`${statusKey}">
                            <i class="bi `${statusKey == 'APPROVED' ? 'bi-check-circle-fill' : 'bi-clock-history'}"></i>
                            `${statusKey}
                        </span>
                    </div>

                    <div class="d-flex flex-wrap gap-3 gap-md-4 small mb-3" style="color:var(--ap-muted);">
                        <div><i class="bi bi-envelope-fill me-1" style="color:var(--ap-accent);"></i> <a href="mailto:`${entrepreneur.email}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="`${entrepreneur.email}"/></a></div>
                        <div><i class="bi bi-telephone-fill me-1" style="color:var(--ap-accent);"></i> <a href="tel:`${entrepreneur.phone}" class="text-decoration-none fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="`${entrepreneur.phone}"/></a></div>
                        <div><i class="bi bi-building me-1" style="color:var(--ap-accent);"></i> <strong style="color:var(--ap-navy-mid);">Business:</strong> <c:out value="`${not empty entrepreneur.businessName ? entrepreneur.businessName : 'Not specified'}"/></div>
                        <div><i class="bi bi-geo-alt-fill me-1" style="color:var(--ap-accent);"></i> <span class="fw-semibold" style="color:var(--ap-navy-mid);"><c:out value="`${not empty entrepreneur.city ? entrepreneur.city : entrepreneur.businessLocation}"/></span></div>
                    </div>

                    <!-- Profile Completion -->
                    <div style="max-width: 480px;">
                        <div class="d-flex justify-content-between small fw-bold mb-1" style="color:var(--ap-navy-mid);">
                            <span>Profile Completion</span>
                            <span style="color:var(--ap-accent); font-weight:800;"><c:out value="`${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>%</span>
                        </div>
                        <div class="progress-wrap">
                            <c:set var="pctVal" value="`${entrepreneur.profileCompletionPct != null ? entrepreneur.profileCompletionPct : 0}"/>
                            <div class="progress-bar-fill" style="width: `${pctVal}%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
"@

$entre = [regex]::Replace($entre, '<!-- HEADER CARD -->[\s\S]*?<div class="review-card">', "$newHeader`r`n`r`n        <!-- 1. PERSONAL IDENTITY -->`r`n        <div class=`"review-card`">")

Set-Content -Path "src/main/webapp/WEB-INF/views/aboutEntrepreneur.jsp" -Value $entre
