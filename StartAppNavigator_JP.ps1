# ==========================================================
# Mustang AutoExec Navigator v1.5 [Pre-Filtered & Loop]
# ==========================================================

# 1. 最初に表示モードを選択 (ここで False を打つ手間を省く)
$choice = Read-Host "`n[MODE SELECT] `n 1: User Items Only (Hide Microsoft/System) `n 2: Show Everything (All Services/Tasks) `n Choose (1 or 2)"
$hideSystem = if ($choice -eq "2") { $false } else { $true }

$Report = New-Object System.Collections.Generic.List[PSCustomObject]

Write-Host "`nScanning... Please wait." -ForegroundColor Cyan

# --- サービス取得 ---
Get-CimInstance Win32_Service | ForEach-Object {
    $isSys = ($_.PathName -like "*C:\Windows\System32*" -or $_.AcceptPause -eq $false -and $_.ServiceType -eq "Share Process")
    $Report.Add([PSCustomObject]@{
        Status   = $_.State
        Type     = "Service"
        Name     = $_.DisplayName
        IsSystem = $isSys
        Command  = $_.PathName
        Location = "services.msc"
    })
}

# --- タスク取得 ---
Get-ScheduledTask | ForEach-Object {
    $isSys = ($_.TaskPath -like "\Microsoft\Windows\*")
    $actionInfo = if ($_.Actions -and $_.Actions.Execute) {
        $_.Actions.Execute + " " + $_.Actions.Arguments
    } else { "Other Action" }

    $Report.Add([PSCustomObject]@{
        Status   = $_.State
        Type     = "Task"
        Name     = $_.TaskName
        IsSystem = $isSys
        Command  = $actionInfo
        Location = "Task: " + $_.TaskPath
    })
}

# --- レジストリ取得 ---
$RunKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)
foreach ($key in $RunKeys) {
    if (Test-Path $key) {
        $reg = Get-ItemProperty $key
        $reg.PSObject.Properties | Where-Object { $_.Name -notin 'PSPath','PSParentPath','PSChildName','PSDrive','PSProvider' } | ForEach-Object {
            $Report.Add([PSCustomObject]@{
                Status   = "Enabled"; Type = "Registry"; Name = $_.Name; IsSystem = $false; Command = $_.Value; Location = $key
            })
        }
    }
}

# --- スタートアップフォルダ取得 ---
$StartupFolders = @([Environment]::GetFolderPath('Startup'), [Environment]::GetFolderPath('CommonStartup'))
foreach ($folder in $StartupFolders) {
    if (Test-Path $folder) {
        Get-ChildItem $folder -File | ForEach-Object {
            $Report.Add([PSCustomObject]@{
                Status   = "Enabled"; Type = "Folder"; Name = $_.BaseName; IsSystem = $false; Command = $_.FullName; Location = $folder
            })
        }
    }
}

# --- フィルタ適用 ---
# 最初に選んだモードに基づいて、表示用のリストを作成する
$DisplayList = if ($hideSystem) { 
    $Report | Where-Object { $_.IsSystem -eq $false } 
} else { 
    $Report 
}

Write-Host "Done! Filtering Ready." -ForegroundColor Green

# ==========================================================
# 連続ナビゲーション：ループ構造
# ==========================================================
do {
    $title = if ($hideSystem) { "USER ITEMS ONLY MODE - Select and OK to Jump" } else { "ALL ITEMS MODE - Select and OK to Jump" }
    
    # フィルタ済みの $DisplayList を表示し続けるので、検索ワード以外の「一覧の状態」は維持されます
    $selected = $DisplayList | Out-GridView -Title "$title (Cancel or Close to Exit)" -PassThru

    if ($selected) {
        $target = $selected[0]
        Write-Host "`nProcessing: $($target.Name)" -ForegroundColor Yellow
        
        # Google検索URL生成
        $query = [uri]::EscapeDataString("$($target.Name) $($target.Type) Windows")
        $searchUrl = "https://www.google.com/search?q=$query"

        # 1. レジストリ / フォルダ：場所を開く
        if ($target.Type -eq "Registry" -or $target.Type -eq "Folder") {
            Write-Host "Action: Opening Location..." -ForegroundColor Cyan
            if ($target.Type -eq "Registry") {
                $regPath = $target.Location.Replace("HKLM:\", "HKEY_LOCAL_MACHINE\").Replace("HKCU:\", "HKEY_CURRENT_USER\").Replace("HKLM:\SOFTWARE\WOW6432Node\", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\")
                Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "LastKey" -Value $regPath
                Start-Process "regedit.exe"
            } else {
                if (Test-Path $target.Location) { Start-Process "explorer.exe" $target.Location }
            }
        }
        
        # 2. サービス / タスク：検索 & 管理画面
        else {
            Write-Host "Action: Searching info..." -ForegroundColor Cyan
            Start-Process $searchUrl
            if ($target.Type -eq "Service") { Start-Process "services.msc" }
            if ($target.Type -eq "Task") { Start-Process "taskschd.msc" }
        }

        Write-Host "Done! Returning to List..." -ForegroundColor Green
        Start-Sleep -Milliseconds 300
    }
} while ($selected)

Write-Host "`nNavigator Closed. Have a nice day!" -ForegroundColor Cyan