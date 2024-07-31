Get-WmiObject Win32_Volume -Filter "DriveType='3'" | ForEach {
    New-Object PSObject -Property @{
        Name = $_.Name
        Label = $_.Label
        FreeSpace_GB = ([Math]::Round($_.FreeSpace /1GB,2))
        TotalSize_GB = ([Math]::Round($_.Capacity /1GB,2))
    }
}

$Drives = Get-PSDrive -PSProvider 'FileSystem'
$SystemDrive = (Get-WmiObject Win32_OperatingSystem).SystemDrive + "\"
$MountPointDir = "C:\Mount\"
$TotalPlots = 0

Write-Output "`nNon-Plot Files: "

foreach($Drive in $drives) {
    #skip system drive
    if ($Drive.Root -ne $SystemDrive)
    {
        #get plot counts from all drives
        $TotalPlots = $TotalPlots + [int](Get-ChildItem $Drive.Root -Recurse -File -Include *.plot | Measure-Object | %{$_.Count})

        #get non-plot files
        Write-Output (Get-ChildItem $Drive.Root -Recurse -File -Exclude *.plot | %{$_.FullName}) 
       
    }
}

#REMOVE IF NO MOUNT POINTS
#get all plot counts from mount points
$TotalPlots = $TotalPlots + [int](Get-ChildItem $MountPointDir -Recurse -File -Include *.plot | Measure-Object | %{$_.Count})
#get all non-plots in mount points
Write-Output (Get-ChildItem $MountPointDir -Recurse -File -Exclude *.plot | %{$_.FullName}) 


Write-Output "`nTotal Plots: " $TotalPlots.ToString() 

Write-Output ""
Write-Output "Looking for missing drives..."

Get-Disk | Where-Object -ErrorAction SilentlyContinue -FilterScript {$_.Bustype -Ne "USB"} | Select FriendlyName, SerialNumber > C:\status\DiskList.txt
fc.exe C:\status\DiskListRef.txt C:\status\DiskList.txt
