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

'Status: Not Connected'
'Name: None'
'Remaining: 0'
'Charge: 0'
'Availability: 0'

Get-WinEvent -FilterHashTable @{Logname='System';Level=2,3} -MaxEvents 20 | Format-Table TimeCreated,ProviderName,Message -wrap
