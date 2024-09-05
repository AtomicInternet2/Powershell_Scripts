$NodeNumber = 3 #Increment this for additional nodes
$NodeStorageDir = "E:\Node$NodeNumber_Data"
$NodePort = 28969 #Increment this for additional nodes

#Create new config dir
mkdir "C:\Program Files\Storj\Node$NodeNumber_Config"

#Create new identity
cd C:\Users\atomi\Downloads #--use your Download path here
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; curl https://github.com/storj/storj/releases/latest/download/identity_windows_amd64.zip -o identity_windows_amd64.zip; Expand-Archive ./identity_windows_amd64.zip . -Force
.\identity.exe create storagenode$NodeNumber
.\identity.exe authorize storagenode$NodeNumber <email>:<token>

#Setup new node config directory
cd "C:\Program Files\Storj\Storage Node\"
.\storagenode.exe setup --identity-dir "C:\Users\atomi\AppData\Roaming\Storj\Identity\storagenode$NodeNumber\" --config-dir "C:\Program Files\Storj\Node$NodeNumber_Config" --storage.path "$NodeStorageDir"

#Create new service and firewall rules
New-Service -Name "storagenode$NodeNumber" -DisplayName "Storj V3 Storage Node $NodeNumber" -Description 'Runs Storj V3 Storage Node as a background service.' -BinaryPathName '"C:\Program Files\Storj\Storage Node\storagenode.exe" run --config-dir "C:\Program Files\Storj\Node$NodeNumber_Config\\"'
New-NetFirewallRule -DisplayName "Storj v3 TCP $NodePort" -Direction Inbound -Protocol TCP -LocalPort $NodePort -Action allow
New-NetFirewallRule -DisplayName "Storj v3 UDP $NodePort" -Direction Inbound -Protocol UDP -LocalPort $NodePort -Action allow

#Now configure your router to forward the new port (TCP/UDP) to the new port
