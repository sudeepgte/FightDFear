$content = Get-Content -Path "c:\Users\priya\Desktop\FightDfire\FightDFear\src\main\webapp\WEB-INF\views\userDashboard.jsp" -Raw -Encoding UTF8

$content = $content -replace 'bi bi-arrow-right', 'fas fa-arrow-right'
$content = $content -replace 'bi bi-calendar2-heart', 'fas fa-calendar-alt'
$content = $content -replace 'bi bi-shield-check', 'fas fa-shield-alt'
$content = $content -replace 'bi bi-building', 'fas fa-building'
$content = $content -replace 'bi bi-bell', 'fas fa-bell'
$content = $content -replace 'bi bi-calendar3', 'fas fa-calendar'
$content = $content -replace 'bi bi-people', 'fas fa-users'
$content = $content -replace 'bi bi-calendar2-x', 'fas fa-calendar-times'
$content = $content -replace 'bi bi-activity', 'fas fa-heartbeat'
$content = $content -replace 'bi bi-shield', 'fas fa-shield-alt'
$content = $content -replace 'bi bi-check2-circle', 'fas fa-check-circle'
$content = $content -replace 'bi bi-heart-pulse-fill', 'fas fa-heartbeat'
$content = $content -replace 'bi bi-heart-pulse', 'fas fa-heartbeat'
$content = $content -replace 'bi bi-calendar-check', 'fas fa-calendar-check'
$content = $content -replace 'bi bi-journal-check', 'fas fa-book'
$content = $content -replace 'bi bi-person', 'fas fa-user'
$content = $content -replace 'bi bi-headset', 'fas fa-headset'
$content = $content -replace 'bi bi-bell-fill', 'fas fa-bell'

Set-Content -Path "c:\Users\priya\Desktop\FightDfire\FightDFear\src\main\webapp\WEB-INF\views\userDashboard.jsp" -Value $content -Encoding UTF8
Write-Output "Done replacing."
