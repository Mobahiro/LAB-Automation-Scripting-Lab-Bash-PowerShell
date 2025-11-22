$LogFile = "C:\Logs\CPU_Usage.txt"
$IntervalSeconds = 5

$Dir = Split-Path $LogFile -Parent
if (-not (Test-Path $Dir)) { New-Item -Type Directory -Path $Dir | Out-Null }

"Started $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Add-Content $LogFile
Write-Host "Logging CPU usage to $LogFile every $IntervalSeconds s (Ctrl+C to stop), Created by Rodriguez, Michael Josh :>"

function Get-CPUUsage {
    try {
        (Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction Stop).CounterSamples.CookedValue
    } catch {
        (Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor | Where-Object Name -eq '_Total').PercentProcessorTime
    }
}

while ($true) {
    $v = [math]::Round((Get-CPUUsage),2)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') CPU: $v%"
    Add-Content $LogFile $line
    Write-Host $line
    Start-Sleep -Seconds $IntervalSeconds
}
