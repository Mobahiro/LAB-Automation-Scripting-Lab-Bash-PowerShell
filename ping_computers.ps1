$ComputersFile = "C:\Users\Shiro\Desktop\PingLogs\computers.txt"
$LogFile = "C:\Users\Shiro\Desktop\PingLogs\ping_results.log"
$LogDir = Split-Path $LogFile -Parent
if (-not (Test-Path $LogDir)) { New-Item -Type Directory -Path $LogDir | Out-Null }
$PingCount = 1

if (-not (Test-Path $ComputersFile)) {
@"
# One host per line
localhost
8.8.8.8
google.com
"@ | Out-File $ComputersFile -Encoding UTF8
Write-Host "Created sample $ComputersFile. Edit it then rerun."
exit
}

"Started $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File $LogFile -Encoding UTF8
$ok=0; $fail=0; $total=0

Get-Content $ComputersFile | ForEach-Object {
  $h = $_.Trim()
  if (-not $h -or $h.StartsWith('#')) { return }
  $total++
  $isUp = Test-Connection -ComputerName $h -Count $PingCount -Quiet -ErrorAction SilentlyContinue
  $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
  if ($isUp) {
    $ok++
    "$stamp UP   $h" | Add-Content $LogFile
    Write-Host "UP   $h"
  } else {
    $fail++
    "$stamp DOWN $h" | Add-Content $LogFile
    Write-Host "DOWN $h"
  }
}

"Finished $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Add-Content $LogFile
"Totals: $total hosts, $ok up, $fail down" | Add-Content $LogFile
Write-Host "Log written to $LogFile"
