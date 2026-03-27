# 貢献ガイドライン / Contributing Guidelines

このプロジェクトへの貢献を検討していただき、ありがとうございます！
Thank you for considering contributing to Mustang AutoExec Navigator!

## 日本語 (Japanese)

### バグ報告や機能提案
不具合を見つけた場合や、新しい自動起動ポイント（レジストリキーやスキャン対象）の追加提案は、[Issues](リンク) からお知らせください。
報告時には以下の情報を含めていただけると助かります。
- [cite_start]Windowsのバージョン (例: Windows 11 23H2 / Windows Server 2025) [cite: 16, 18]
- 再現手順またはスキャンできなかった項目の詳細

### プルリクエスト (PR) について
1. このリポジトリをフォークして、新しいブランチを作成してください。
2. [cite_start]スクリプトを修正した場合は、`StartAppNavigator_JP.ps1` と `StartAppNavigator_EN.ps1` の両方に変更を反映させるよう努めてください。 [cite: 13]
3. [cite_start]修正後は必ず `AutoRun.bat` を管理者権限で実行し、正常に動作することを確認してください。 [cite: 1, 13]
4. main ブランチに対してプルリクエストを送ってください。

---

## English

### Bug Reports & Feature Requests
If you find a bug or have a suggestion for new auto-run entry points (Registry keys, etc.), please open an [Issue](link).
Please include the following details:
- [cite_start]Windows Version (e.g., Windows 10 / 11 / Server 2016-2025) [cite: 16]
- Steps to reproduce or details of the missing items.

### Pull Requests (PR)
1. Fork the repository and create a new branch.
2. [cite_start]When modifying scripts, please ensure changes are applied to both `StartAppNavigator_JP.ps1` and `StartAppNavigator_EN.ps1` for consistency. [cite: 13]
3. [cite_start]After modification, always verify the tool by running `AutoRun.bat` as Administrator. [cite: 1, 13]
4. Submit your pull request to the `main` branch.

---

## 免責事項 / Disclaimer
[cite_start]本ツールは情報の参照とナビゲーションを目的としています。操作は自己責任で行ってください。 [cite: 17, 18]
This tool is for information and navigation purposes only. [cite_start]Perform all modifications at your own risk. [cite: 17]
