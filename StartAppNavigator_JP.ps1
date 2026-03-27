# ==========================================================
# Mustang AutoExec Navigator v1.6.2 [日本語完全対応版]
# ==========================================================

# 1. 表示モードの選択
$choice = Read-Host "`n[モード選択] `n 1: ユーザー項目のみ表示 (推奨) `n 2: 全ての項目を表示 (システムを含む) `n 番号を入力してください (1 または 2)"
$hideSystem = if ($choice -eq "2") { $false } else { $true }

$Report = New-Object System.Collections.Generic.List[PSCustomObject]

# デジタル署名から発行元を取得する関数
function Get-Publisher {
    param($path)
    if (-not $path -or -not (Test-Path $path)) { return "N/A" }
    try {
        $sig = Get-AuthenticodeSignature $path -ErrorAction SilentlyContinue
        if ($sig.SignerCertificate) {
            return $sig.SignerCertificate.Subject.Split(',')[0].Replace('CN=', '')
        } else { return "署名なし" }
    } catch { return "検証不可" }
}

Write-Host "`nシステムをスキャン中... しばらくお待ちください。" -ForegroundColor Cyan

# --- サービス取得 ---
Get-CimInstance Win32_Service | ForEach-Object {
    $isSys = ($_.PathName -like "*C:\Windows\System32*" -or $_.AcceptPause -eq $false)
    $execPath = $_.PathName.Split(' ')[0].Trim('"')
    $Report.Add([PSCustomObject]@{
        システム項目 = if($isSys){"はい"}else{"いいえ"}
        種類     = "サービス"
        名前     = $_.DisplayName
        実行権限   = $_.StartName
        状態     = $_.State
        発行元    = Get-Publisher $execPath
        コマンド   = $_.PathName
        場所     = "services.msc"
    })
}

# --- タスク取得 ---
Get-ScheduledTask | ForEach-Object {
    $isSys = ($_.TaskPath -like "\Microsoft\Windows\*")
    $execPath = if ($_.Actions.Execute) { $_.Actions.Execute.Trim('"') } else { $null }
    $Report.Add([PSCustomObject]@{
        システム項目 = if($isSys){"はい"}else{"いいえ"}
        種類     = "タスク"
        名前     = $_.TaskName
        実行権限   = $_.Principal.UserId
        状態     = $_.State
        発行元    = Get-Publisher $execPath
        コマンド   = $_.Actions.Execute
        場所     = "Task: " + $_.TaskPath
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
            $execPath = $_.Value.Split(' ')[0].Trim('"')
            $Report.Add([PSCustomObject]@{
                システム項目 = "いいえ"
                種類     = "レジストリ"
                名前     = $_.Name
                実行権限   = "ログインユーザー"
                状態     = "有効"
                発行元    = Get-Publisher $execPath
                コマンド   = $_.Value
                場所     = $key
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
                システム項目 = "いいえ"
                種類     = "フォルダ"
                名前     = $_.BaseName
                実行権限   = "ログインユーザー"
                状態     = "有効"
                発行元    = Get-Publisher $_.FullName
                コマンド   = $_.FullName
                場所     = $folder
            })
        }
    }
}

# 表示リストのフィルタリング
$DisplayList = if ($hideSystem) { $Report | Where-Object { $_.システム項目 -eq "いいえ" } } else { $Report }

Write-Host "スキャン完了！" -ForegroundColor Green

# 連続ナビゲーションループ
do {
    $titleText = if ($hideSystem) { "ユーザー項目のみ表示中" } else { "全項目表示中" }
    $selected = $DisplayList | Out-GridView -Title "Navigator v1.6.2 [$titleText] - 項目を選んで[OK]で詳細へ（キャンセルで終了）" -PassThru

    if ($selected) {
        $target = $selected[0]
        $query = [uri]::EscapeDataString("$($target.名前) $($target.発行元) Windows")
        $searchUrl = "https://www.google.com/search?q=$query"

        if ($target.種類 -eq "レジストリ" -or $target.種類 -eq "フォルダ") {
            if ($target.種類 -eq "レジストリ") {
                $regPath = $target.場所.Replace("HKLM:\", "HKEY_LOCAL_MACHINE\").Replace("HKCU:\", "HKEY_CURRENT_USER\").Replace("HKLM:\SOFTWARE\WOW6432Node\", "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\")
                Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name "LastKey" -Value $regPath
                Start-Process "regedit.exe"
            } else { Start-Process "explorer.exe" $target.場所 }
        } else {
            Start-Process $searchUrl
            if ($target.種類 -eq "サービス") { Start-Process "services.msc" }
            if ($target.種類 -eq "タスク") { Start-Process "taskschd.msc" }
        }
        Start-Sleep -Milliseconds 300
    }
} while ($selected)