# Capture system name for dynamic filename
$systemName = $env:COMPUTERNAME
$exportPath = "\\proton\sysinfo\Forensics\${systemName}_SystemLog_Last500.csv"

# Get the last 500 events from the System log in strict chronological order
$events = Get-WinEvent -LogName System -MaxEvents 300 |
    Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message, RecordId

# Display to screen
$events | Format-Table -AutoSize

# Export for offline forensic analysis
$events | Export-Csv -NoTypeInformation -Encoding UTF8 $exportPath
