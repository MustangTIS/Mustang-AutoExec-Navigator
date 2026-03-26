# Mustang AutoExec Navigator v1.5

[🚀 Download Latest Release (zip)](https://github.com/MustangTIS/Mustang-AutoExec-Navigator/releases/latest)

A lightweight, powerful navigation tool for Windows Administrators to audit and manage "Auto-Run" items across the system.  
Windowsの自動起動項目を一括調査・管理するための、管理者向け軽量ナビゲーションツールです。

![Console Interface](Assets/Console.jpg)

## 🚀 Key Features / 主な機能

- **Unified Scan / 横断スキャン**: 
  - Services, Task Scheduler, Registry (Run keys), and Startup Folders.
  - サービス、タスク、レジストリ、スタートアップフォルダを1画面で俯瞰。
- **Noise Reduction / ノイズ除去**: 
  - Filter out Microsoft/System items to focus on what matters.
  - システム項目を隠し、ユーザーが追加した項目だけに集中。
- **Direct Action / 一撃アクション**: 
  - Jump directly to Registry keys or search unknown items on Google.
  - レジストリへの直接ジャンプや、不明な項目のGoogle検索。
- **Loop Mode / 連続操作**: 
  - Sequential investigation without re-opening the app.
  - 調査が終わるたびに一覧に戻るため、連続チェックがスムーズ。

## 🛠 Usage / 使い方

1.  **Run as Admin**: Right-click `AutoRun.bat` and select "Run as Administrator".  
    `AutoRun.bat` を右クリックして「管理者として実行」してください。
2.  **Select Language**: Choose JP (1) or EN (2) in the console window.  
    コンソール画面で言語（1:日本語 / 2:英語）を選択します。
3.  **Choose Mode**: Filter system items (1) or show everything (2).  
    表示モード（ユーザー項目のみ / 全て表示）を選択します。
4.  **Investigate**: Select an item from the grid and click [OK] to jump or search.  
    項目を選んで [OK] を押すと、場所が開くか検索が走ります。

## 💻 Requirements / 動作環境

- Windows 10 / 11 / Windows Server 2011 - 2025
- PowerShell 5.1 or higher

## 📜 License
This project is licensed under the **MIT License**.