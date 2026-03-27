# ==========================================================
# Mustang AutoExec Navigator v1.6.2 [English Edition]
# ==========================================================

# 1. Mode Selection
$choice = Read-Host "`n[MODE SELECT] `n 1: User Items Only (Recommended) `n 2: Show Everything (Including System) `n Choose (1 or 2)"
$hideSystem = if ($choice -eq "2") { $false } else { $true }

$Report = New-Object System.Collections.Generic.List[PSCustomObject]

# Function to get digital signature / Publisher
function Get-Publisher {
    param($path)
    if (-not $path -or -not (Test-Path $path)) { return "N/A" }
    try {
        $sig = Get-AuthenticodeSignature $path -ErrorAction SilentlyContinue
        if ($sig.SignerCertificate) {
            return $sig.SignerCertificate.Subject.Split(',')[0].Replace('CN=', '')
        } else { return "Unsigned" }
    } catch { return "Verify Failed" }
}

Write-Host "`nScanning system items... Please wait." -ForegroundColor Cyan

# --- Services ---
Get-CimInstance Win32_Service | ForEach-Object {
    $isSys = ($_.PathName -like "*C:\Windows\System32*" -or $_.AcceptPause -eq $false)
    $execPath = $_.PathName.Split(' ')[0].Trim('"')
    $Report.Add([PSCustomObject]@{
        SystemItem = if($isSys){"Yes"}else{"No"}
        Type       = "Service"
        Name       = $_.DisplayName
        RunAs      = $_.StartName
        Status     = $_.State
        Publisher  = Get-Publisher $execPath
        Command    = $_.PathName
        Location   = "services.msc"
    })
}

# --- Scheduled Tasks ---
Get-ScheduledTask | ForEach-Object {
    $isSys = ($_.TaskPath -like "\Microsoft\Windows\*")
    $execPath = if ($_.Actions.Execute) { $_.Actions.Execute.Trim('"') } else { $null }
    $Report.Add([PSCustomObject]@{
        SystemItem = if($isSys){"Yes"}else{"No"}
        Type       = "Task"
        Name       = $_.TaskName
        RunAs      = $_.Principal.UserId
        Status     = $_.State
        Publisher  = Get-Publisher $execPath
        Command    = $_.Actions.Execute
        Location   = "Task: " + $_.TaskPath
    })
}

# --- Registry ---
$RunKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)
foreach ($key in $RunKeys) {
    if (Test-Path $key) {
        $reg = Get-ItemProperty $key
        $reg.PSObject.Properties | Where-Object { $_.Name -notin 'PSPath','PSParentPath','PSChildName','PSDrive','PSProvider' } | ForEach-Object {
            $execPath = $_.Value.Split(' ')[0].Trim('"')
            $Report.Add([PSCustomObject]@{
                SystemItem = "No"
                Type       = "Registry"
                Name       = $_.Name
                RunAs      = "Logged-in User"
                Status     = "Enabled"
                Publisher  = Get-Publisher $execPath
                Command    = $_.Value
                Location   = $key
            })
        }
    }
}

# --- Startup Folders ---
$StartupFolders = @([Environment]::GetFolderPath('Startup'), [Environment]::GetFolderPath('CommonStartup'))
foreach ($folder in $StartupFolders) {
    if (Test-Path $folder) {
        Get-ChildItem $folder -File | ForEach-Object {
            $Report.Add([PSCustomObject]@{
                SystemItem = "No"
                Type       = "Folder"
                Name       = $_.BaseName
                RunAs      = "Logged-in User"
                Status     = "Enabled"
                Publisher  = Get-Publisher $_.FullName
                Command    = $_.FullName
                Location   = $folder
            })
        }
    }
}

# Filtering
$DisplayList = if ($hideSystem) { $Report | Where-Object { $_.SystemItem -eq "No" } } else { $Report }

Write-Host "Scan Completed!" -ForegroundColor Green

# Navigation Loop
do {
    $titleText = if ($hideSystem) { "USER ITEMS ONLY" } else { "ALL ITEMS" }
    $selected = $DisplayList | Out-GridView -Title "Navigator v1.6.2 [$titleText] - Select item and OK to Jump (Cancel to Exit)" -PassThru

    if ($selected) {
        $target = $selected[0]
        $query = [uri]::EscapeDataString("$($target.Name) $($target.Publisher) Windows")
        $searchUrl = "https://www.google.com/search?q=$query"

        if ($target.Type -eq "Registry" -or $target.Type -eq "Folder") {
            if ($target.Type -eq "Registry") {
                $regPath = $target.Location.Replace("HKLM:\", "HKEY_LOCAL_MACHINE\").Replace("HKCU:\", "HKEY_CURRENT_USER\").Replace("HKLM:\SOFTWARE\WOW6432Node\", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\")
                Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "LastKey" -Value $regPath
                Start-Process "regedit.exe"
            } else { Start-Process "explorer.exe" $target.Location }
        } else {
            Start-Process $searchUrl
            if ($target.Type -eq "Service") { Start-Process "services.msc" }
            if ($target.Type -eq "Task") { Start-Process "taskschd.msc" }
        }
        Start-Sleep -Milliseconds 300
    }
} while ($selected)