# FloTotemBar - Development Junction Setup
# Creates directory junctions instead of copying files for instant updates

param(
    [Parameter(Mandatory=$true)]
    [string]$WoWPath,
    
    [switch]$Remove,
    
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "FloTotemBar Development Junction Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Paths
$SourcePath = "$PSScriptRoot\FloTotemBar"  # Addon files are in subfolder

# Handle different WoW folder structures
$InterfaceAddOnsPath = "$WoWPath\Interface\AddOns"
if (Test-Path $InterfaceAddOnsPath) {
    # Standard structure: WoW\Interface\AddOns
    $TargetPath = "$InterfaceAddOnsPath\FloTotemBar"
    $wowAddOnsPath = $InterfaceAddOnsPath
    Write-Host "Detected: Standard WoW structure" -ForegroundColor Green
} elseif ((Get-ChildItem $WoWPath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*Blizzard*" -or $_.Name -like "*Titan*" -or $_.Name -like "*Flo*" }).Count -gt 2) {
    # Direct AddOns folder (OneDrive symlink case)
    $TargetPath = "$WoWPath\FloTotemBar"
    $wowAddOnsPath = $WoWPath
    Write-Host "Detected: Direct AddOns folder structure" -ForegroundColor Green
} else {
    Write-Host "ERROR: Cannot detect WoW AddOns structure!" -ForegroundColor Red
    Write-Host "Checked:" -ForegroundColor Yellow
    Write-Host "  Standard: $InterfaceAddOnsPath" -ForegroundColor Yellow
    Write-Host "  Direct:   $WoWPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "Source:  $SourcePath" -ForegroundColor Yellow
Write-Host "Target:  $TargetPath" -ForegroundColor Yellow

# Validate paths
if (-not (Test-Path $SourcePath)) {
    Write-Host "ERROR: Source path not found!" -ForegroundColor Red
    exit 1
}

# Check for TOC file to confirm this is a WoW addon
$tocFiles = Get-ChildItem $SourcePath -Filter "*.toc"
if ($tocFiles.Count -eq 0) {
    Write-Host "ERROR: No TOC file found in source directory!" -ForegroundColor Red
    Write-Host "Are you sure this is a WoW addon folder?" -ForegroundColor Yellow
    exit 1
}

if ($Remove) {
    Write-Host "`n=== REMOVING JUNCTION ===" -ForegroundColor Red
    
    if (Test-Path $TargetPath) {
        $item = Get-Item $TargetPath -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Host "Removing junction: $TargetPath" -ForegroundColor Yellow
            if (-not $DryRun) {
                Remove-Item $TargetPath -Force
                Write-Host "Junction removed successfully!" -ForegroundColor Green
            } else {
                Write-Host "[DRY RUN] Would remove junction" -ForegroundColor Gray
            }
        } else {
            Write-Host "WARNING: Target exists but is not a junction!" -ForegroundColor Yellow
            Write-Host "Manual cleanup may be required." -ForegroundColor Red
        }
    } else {
        Write-Host "No junction found to remove." -ForegroundColor Gray
    }
    
    exit 0
}

Write-Host "`n=== CREATING JUNCTION ===" -ForegroundColor Green

# Check if target already exists
if (Test-Path $TargetPath) {
    $item = Get-Item $TargetPath -Force
    
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Junction already exists!" -ForegroundColor Yellow
        
        # Check if it points to the correct location
        $target = (Get-Item $TargetPath).Target
        if ($target -eq $SourcePath) {
            Write-Host "Junction points to correct location." -ForegroundColor Green
            exit 0
        } else {
            Write-Host "Junction points to: $target" -ForegroundColor Red
            Write-Host "Expected: $SourcePath" -ForegroundColor Yellow
            Write-Host "Removing old junction..." -ForegroundColor Yellow
            if (-not $DryRun) {
                Remove-Item $TargetPath -Force
            }
        }
    } else {
        Write-Host "ERROR: Target directory already exists and is not a junction!" -ForegroundColor Red
        Write-Host "Please remove or move the existing folder first:" -ForegroundColor Yellow
        Write-Host "  $TargetPath" -ForegroundColor White
        exit 1
    }
}

# Create the junction
Write-Host "Creating junction..." -ForegroundColor Yellow
Write-Host "  Source: $SourcePath" -ForegroundColor White
Write-Host "  Target: $TargetPath" -ForegroundColor White

if (-not $DryRun) {
    try {
        New-Item -ItemType Junction -Path $TargetPath -Target $SourcePath | Out-Null
        Write-Host "`nJunction created successfully! 🎯" -ForegroundColor Green
        
        # Verify it works
        $testFile = Get-ChildItem $TargetPath -Name "*.toc" | Select-Object -First 1
        if ($testFile) {
            Write-Host "Verification: $testFile found in junction" -ForegroundColor Green
        }
        
        Write-Host "`n✅ INSTANT DEVELOPMENT MODE ACTIVE!" -ForegroundColor Cyan
        Write-Host "   • File changes are immediately available in-game" -ForegroundColor White
        Write-Host "   • No need to run deployment scripts" -ForegroundColor White
        Write-Host "   • Just edit code and /reload in WoW" -ForegroundColor White
        
    } catch {
        Write-Host "ERROR: Failed to create junction!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[DRY RUN] Would create junction" -ForegroundColor Gray
}

Write-Host "`n=== USAGE ===" -ForegroundColor Cyan
Write-Host "• Edit files in: $SourcePath" -ForegroundColor White
Write-Host "• Changes appear in WoW immediately" -ForegroundColor White
Write-Host "• Use /reload in-game to refresh addon" -ForegroundColor White
Write-Host "• To remove junction: .\SetupDevJunction.ps1 -WoWPath `"$WoWPath`" -Remove" -ForegroundColor Gray