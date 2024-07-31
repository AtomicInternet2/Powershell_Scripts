$diskdrives = get-wmiobject Win32_DiskDrive | sort Index
$colSize = @{Name='Size';Expression={Get-HRSize $_.Size}}
foreach ( $disk in $diskdrives ) {
    $SMARTData = Get-PhysicalDisk -DeviceNumber $disk.Index | Get-StorageReliabilityCounter | Select-Object -Property Wear,Temperature,TemperatureMax
    if ($disk.Index -eq 1)
    {
        $scsi_details = '<tr><td><span class="label label-primary">System</span></td>'
    } else {
        $scsi_details = '<tr><td><span class="label label-success">Storj Volume</span></td>'
    }
    $scsi_details += '<td>' + $disk.Model + '</td><td>' + $disk.FirmwareRevision + '</td><td>' + $SMARTData.Temperature  + '&deg;C</td><td>' + $SMARTData.TemperatureMax  + '&deg;C</td></tr>'
    write $($scsi_details)
} # end foreach disk
