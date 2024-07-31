$lastRestart = Get-Content -Path "~\.chia\mainnet\log\debug.log" -ReadCount 100 | foreach { $_ -match "started harvester" } | Select -last 1
$restartLast15 = $false

if ($lastRestart)
{
    $restartTime = [datetime]$lastRestart.SubString(0,23)
    $diff = New-Timespan -Start $restartTime -end (get-date)
    if ($diff.TotalMinutes -lt 15) 
    {
        $restartLast15 = $true
    }
    $diff
}

if (-Not $restartLast15) {
    $WebResponse = Invoke-WebRequest "https://spacefarmers.io/api/farmers/<farmerid>/partials"
    $jsonObj = ConvertFrom-Json $([String]::new($WebResponse.Content))
    if (($jsonObj.data[0].attributes.harvester_id.ToString() -ne "<harvesterid>") -and
    ($jsonObj.data[1].attributes.harvester_id.ToString() -ne "<harvesterid>") -and
    ($jsonObj.data[2].attributes.harvester_id.ToString() -ne "<harvesterid>") -and
    ($jsonObj.data[3].attributes.harvester_id.ToString() -ne "<harvesterid>") -and
    ($jsonObj.data[4].attributes.harvester_id.ToString() -ne "<harvesterid>"))
    {
       ~\AppData\Local\Programs\Chia\resources\app.asar.unpacked\daemon\chia.exe start harvester -r
    }
}
