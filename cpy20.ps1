# Read arguments
param (
    [int]$ChunkSize = 20 , 
    [string]$From = $(throw "-From is required."),    
    [string]$To = $(throw "-To is required.")
)
# Get current working directory
$cwd = Resolve-Path -Path .

$SourceDir = "$cwd\$from"
$DestDir = "$cwd\$To"

# Read number of files
$numberOfItems = (Get-ChildItem $SourceDir).count

# Calculate distribution
$numberOfFolders = [Math]::Ceiling( $numberOfItems / $ChunkSize )

Copy-item -Force -Recurse -Path $SourceDir -Destination $DestDir

$i = 0;
$f = 0;
foreach ($item in Get-ChildItem -Path $DestDir) {
    $i++
    if ($i % $ChunkSize -eq 0) {
        $f++
        $folder = "f$f"
        $moveTo = "$To\f$f"
        New-Item -Name $moveTo -ItemType directory
    }
    $name = Split-Path $item -Leaf
    Move-Item $item -Destination $DestDir\$folder\$name 
}
# Log to console
Write-Host $ChunkSize
Write-Host $From
Write-Host $To
Write-Host $cwd
Write-Host $numberOfItems
Write-Host $numberOfFolders
Write-Host $sourceDir
# End script
