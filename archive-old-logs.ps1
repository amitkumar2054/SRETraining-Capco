# PowerShell script to archive .log files older than 30 days in c:\SRETraining\logs
$logDir = "c:\SRETraining\logs"
$daysOld = 30

# Ensure the log directory exists
if (!(Test-Path $logDir)) {
    Write-Host "Log directory does not exist: $logDir"
    exit 1
}

# Get all .log files older than 30 days
$oldLogs = Get-ChildItem -Path $logDir -Filter *.log | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) }

foreach ($log in $oldLogs) {
    $zipPath = Join-Path $logDir ("{0}.zip" -f $log.BaseName)
    Compress-Archive -Path $log.FullName -DestinationPath $zipPath -Force
    if (Test-Path $zipPath) {
        Remove-Item $log.FullName -Force
        Write-Host "Archived and removed: $($log.Name) -> $($zipPath)"
    } else {
        Write-Host "Failed to archive: $($log.Name)"
    }
}
