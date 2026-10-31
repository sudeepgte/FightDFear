$f = 'C:\Users\Hp\git\Fight D Fear\src\main\webapp\WEB-INF\views\centreDashboard.jsp'
$lines = [System.IO.File]::ReadAllLines($f)
$out = New-Object System.Collections.Generic.List[string]
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($i -ge 653 -and $i -le 655) { continue }
    $out.Add($lines[$i])
}
[System.IO.File]::WriteAllLines($f, $out)
Write-Host "Done. Total lines: $($out.Count)"

