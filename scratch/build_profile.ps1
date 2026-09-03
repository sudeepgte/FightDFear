$lawyer = Get-Content -Path C:\Users\priya\.gemini\antigravity\brain\eea6f601-11a9-4df3-bb69-54337d21c0a2\scratch\lawyer-profile.jsp -Raw

# Replacements
$lawyer = $lawyer -replace "lawyer/profile-completion/save", "women-jobs/profile"
$lawyer = $lawyer -replace "lawyer/dashboard", "women-jobs/dashboard"
$lawyer = $lawyer -replace "lawyer/profile-completion", "women-jobs/profile"
$lawyer = $lawyer -replace "Complete Lawyer Profile", "Complete Worker Profile"
$lawyer = $lawyer -replace "Lawyer Identity", "Worker Identity"
$lawyer = $lawyer -replace "LAWYER PROFILE", "WORKER PROFILE"
$lawyer = $lawyer -replace "ABOUT LAWYER", "ABOUT WORKER"
$lawyer = $lawyer -replace "lawyer\.", "workerApp."
$lawyer = $lawyer -replace "\\{lawyer\\}", "{workerApp}"

# Write it out
Set-Content -Path src/main/webapp/WEB-INF/views/marketplace/worker-profile.jsp -Value $lawyer -Encoding UTF8
