$ipv6 = (Get-NetIPAddress | Where-Object { $_.InterfaceAlias -eq 'Multigig' } | Where-Object { $_.AddressFamily -eq 'IPv6' } ).IPAddress[2]
$ipv4 = (Invoke-WebRequest -uri "https://api.ipify.org/").Content
$webrequest = "https://members.dyndns.org/v3/update?hostname=<hostname>&myip=$ipv6,$ipv4"
Write-Host $webrequest
$user = "user"
$pass= "pass"
$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($user, $secpasswd)
Invoke-RestMethod $webrequest -Credential $credential
