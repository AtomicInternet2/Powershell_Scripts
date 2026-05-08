param(
    [Parameter(Mandatory=$true)]
    [string]$DriveLetter
)

# Thresholds
$minFreeGB = 100
$maxFileKB = 42000000   # 42,000,000 KB

# Convert thresholds
$minFreeBytes = $minFreeGB * 1GB
$maxFileBytes = $maxFileKB * 1KB

# Normalize drive root
$drivePath = "${DriveLetter}:\"

# Get drive info
$drive = Get-PSDrive -Name $DriveLetter

if (-not $drive) {
    Write-Host "Drive ${DriveLetter} not found."
    exit 1
}

function Get-FreeSpace {
    return (Get-PSDrive -Name $DriveLetter).Free
}

$free = Get-FreeSpace

Write-Host "Current free space on ${DriveLetter}: $([math]::Round($free/1GB,2)) GB"

# If already above threshold, exit
if ($free -ge $minFreeBytes) {
    Write-Host "Drive already has at least $minFreeGB GB free. No action taken."
    exit 0
}

Write-Host "Searching for .FPT files under $([math]::Round($maxFileBytes/1GB,2)) GB..."

# Correct Get-ChildItem usage
$fptFiles = Get-ChildItem -Path $drivePath -Recurse -Filter *.FPT -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -lt $maxFileBytes } |
    Sort-Object Length -Descending

if ($fptFiles.Count -eq 0) {
    Write-Host "No .FPT files under size limit found. Cannot free space."
    exit 1
}

Write-Host "Found $($fptFiles.Count) candidate files."

foreach ($file in $fptFiles) {
    Write-Host "Deleting $($file.FullName) ($([math]::Round($file.Length/1GB,2)) GB)"
    Remove-Item $file.FullName -Force

    # Recalculate free space
    $free = Get-FreeSpace
    Write-Host "Free space now: $([math]::Round($free/1GB,2)) GB"

    if ($free -ge $minFreeBytes) {
        Write-Host "Target reached: $([math]::Round($free/1GB,2)) GB free."
        exit 0
    }
}

Write-Host "All candidate files deleted but free space is still below $minFreeGB GB."
exit 1
