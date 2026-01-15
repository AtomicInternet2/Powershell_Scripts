Write-Output "Stopping web server"
net stop "W3SVC"

Write-Output "Renewing Certs"
cd "C:\Program Files\Certbot\bin"
certbot renew --standalone

$pfxPasswordPlain = "<<insert password here>>"
$pfxpass = $pfxPasswordPlain | ConvertTo-SecureString -AsPlainText -Force

# AtomicInternet
Write-Output "Converting AtomicInternet cert"
$atomicPath = "C:\Certbot\live\atomicinternet.homeip.net"
cd $atomicPath
openssl pkcs12 -export -out atomicinternet.pfx -inkey privkey.pem -in cert.pem -passout pass:$pfxPasswordPlain
$atomiccertname = Join-Path $atomicPath "atomicinternet.pfx"

# Cougarfest
Write-Output "Converting Cougarfest cert"
$cougarPath = "C:\Certbot\live\cougarfest.com"
cd $cougarPath
openssl pkcs12 -export -out cougarfest.pfx -inkey privkey.pem -in cert.pem -passout pass:$pfxPasswordPlain
$cougarcertname = Join-Path $cougarPath "cougarfest.pfx"

Write-Output "Purging old certs"
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match "atomicinternet.homeip.net|cougarfest.com" } | Remove-Item

# Import new certs and grant permission
$newatomicCert = Import-PfxCertificate -FilePath $atomiccertname -CertStoreLocation "Cert:\LocalMachine\My" -Password $pfxpass -Exportable
$atomicKeyPath = $newatomicCert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
$atomicFullPath = "$env:ProgramData\Microsoft\Crypto\RSA\MachineKeys\$atomicKeyPath"
icacls $atomicFullPath /grant "IIS_IUSRS:R" /T

$newcougarCert = Import-PfxCertificate -FilePath $cougarcertname -CertStoreLocation "Cert:\LocalMachine\My" -Password $pfxpass -Exportable
$cougarKeyPath = $newcougarCert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
$cougarFullPath = "$env:ProgramData\Microsoft\Crypto\RSA\MachineKeys\$cougarKeyPath"
icacls $cougarFullPath /grant "IIS_IUSRS:R" /T

Import-Module WebAdministration
Write-Output "Restarting web server for cert changes"
Restart-Service W3SVC

# AtomicInternet binding
Write-Output "Installing New AtomicInternet Cert"
$site = Get-ChildItem IIS:\Sites | Where-Object { $_.Name -eq "Default Web Site" }
$binding = $site.Bindings.Collection | Where-Object { $_.protocol -eq 'https' -and $_.bindingInformation -eq '*:443:' }
$binding.AddSslCertificate($newatomicCert.Thumbprint, "my")

# Cougarfest binding
Write-Output "Installing New Cougarfest Cert"
$site = Get-ChildItem IIS:\Sites | Where-Object { $_.Name -eq "cougarfest.com" }
$binding = $site.Bindings.Collection | Where-Object { $_.protocol -eq 'https' -and $_.bindingInformation -like '*:443:*cougarfest*' }
$binding.AddSslCertificate($newcougarCert.Thumbprint, "my")

