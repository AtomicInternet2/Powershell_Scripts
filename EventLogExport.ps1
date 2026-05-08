Write-Output '-------------------------- CPU / MEM ----------------------------'
$totalRam = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum
$count = 0
for ($num = 1 ; $num -le 5 ; $num++) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuTime = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
    $GpuMemTotal = (((Get-Counter "\GPU Process Memory(*)\Local Usage" -ErrorAction SilentlyContinue).CounterSamples | where CookedValue).CookedValue | measure -sum).sum
    $GpuUseTotal = (((Get-Counter "\GPU Engine(*engtype*)\Utilization Percentage" -ErrorAction SilentlyContinue).CounterSamples | where CookedValue).CookedValue | measure -sum).sum
    $date + ' > CPU: ' + $cpuTime.ToString("#,0.000") + '%, ' + $availMem.ToString("N0") + 'MB (' + (104857600 * $availMem / $totalRam).ToString("#,0.0") + '%) Free | GPU: ' + $([math]::Round($GpuUseTotal,2)) + '%, ' + $([math]::Round($GpuMemTotal/1MB,2)) + 'MB Used' 
    Start-Sleep -s 3
}

Write-Output '--------------------------- UPS -----------------------------'

$Battery = Get-CimInstance -ClassName win32_battery
Switch ($Battery.Availability) {
    1  { $Availability = "Other" ;break}
   2  { $Availability =  "Not using battery" ;break}
   3  { $Availability = "Running or Full Power";break}
   4  {$Availability =  "Warning" ;break}
   5  { $Availability = "In Test";break}
   6  { $Availability = "Not Applicable";break}
   7  { $Availability = "Power Off";break}
   8  { $Availability = "Off Line";break}
   9  { $Availability = "Off Duty";break}
   10  {$Availability =  "Degraded";break}
   11  {$Availability =  "Not Installed";break}
   12  {$Availability =  "Install Error";break}
   13  { $Availability = "Power Save - Unknown";break}
   14  { $Availability = "Power Save - Low Power Mode" ;break}
   15  { $Availability = "Power Save - Standby";break}
   16  { $Availability = "Power Cycle";break}
   17  { $Availability = "Power Save - Warning";break}
    }

$BatteryStatus = $Battery.Status
$BatteryName = "$($Battery.name)"
$Remaining = $Battery.EstimatedChargeRemaining
$EstRunTimeMinutes = $Battery.EstimatedRunTime
$EstCharge = $Battery.EstimatedChargeRemaining
$EstPercUsed = $Battery
$BatAvailability = $Availability

'Status: ' + $BatteryStatus
'Name: ' + $BatteryName
'Remaining: ' + $EstRunTimeMinutes + ' Minutes'
'Charge: ' + $EstCharge + '%'
'Availability: ' + $BatAvailability

Get-WinEvent -FilterHashTable @{Logname='System';Level=2,3} -MaxEvents 20 | Format-Table TimeCreated,ProviderName,Message -wrap
