# You need SeaChest_SMART_x64_windows.exe installed and referenced in the loop below
$j = 50 # <-- Number of drives in your system
for ($i=1; $i -lt $j+1; $i++)
{
    C:\users\atomi\documents\SeaChest_SMART_x64_windows.exe -d PD$i --deviceStatistics --noBanner | Select -Index (1,11,19,20)
}
