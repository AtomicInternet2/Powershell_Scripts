cd "C:\Users\atomi\Downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; curl https://github.com/storj/storj/releases/latest/download/identity_windows_amd64.zip -o identity_windows_amd64.zip; Expand-Archive ./identity_windows_amd64.zip . -Force
./identity.exe create storagenode3
cd "C:\Program Files\Storj\Storage Node\"
.\storagenode.exe setup --identity-dir "C:\Users\atomi\AppData\Roaming\Storj\Identity\storagenode3\" --config-dir "C:\Program Files\Storj\Node3Config" --storage.path "E:\Node3Data"
New-Service -Name 'storagenode3' -DisplayName 'Storj V3 Storage Node 3' -Description 'Runs Storj V3 Storage Node as a background service.' -BinaryPathName '"C:\Program Files\Storj\Storage Node\storagenode.exe" run --config-dir "C:\Program Files\Storj\Node3Config\\"'
