==========================================================
 Mustang AutoExec Navigator v1.6.2
==========================================================

[Overview]
Mustang AutoExec Navigator is a lightweight, powerful tool 
for Windows Administrators to audit and manage "Auto-Run" items.
It provides a unified view across Services, Task Scheduler, 
Registry, and Startup Folders.

[Key Features (v1.6.2)]
1. Digital Signature (Publisher) Verification
   Automatically retrieves publisher names (e.g., Microsoft, Adobe).
   Helps identify "Unsigned" items that may require investigation.
2. Execution Context (RunAs) Visibility
   Displays whether an item runs under "SYSTEM" or "User" privileges.
   Essential for assessing the impact of disabling a specific item.
3. Optimized Column Layout
   Reorganized columns based on administrative workflow:
   [SystemItem] -> [Type] -> [Name] -> [RunAs] -> [Status] -> [Publisher].

[Standard Features]
- Noise Reduction Filter: Excludes Microsoft/System standard items.
- Direct Registry Jump: Opens Registry Editor at the specific key instantly.
- Advanced Google Search: Automatically searches for items using 
  Name + Publisher for high-accuracy results.
- Continuous Navigation: Returns to the list after each action.

[File Structure]
- AutoRun.bat               : Main Launcher (MUST Run as Administrator)
- StartAppNavigator_JP.ps1  : Japanese Edition
- StartAppNavigator_EN.ps1  : English Edition

[How to Use]
1. Right-click "AutoRun.bat" and select "Run as Administrator".
2. Select Language (1.Japanese / 2.English).
3. Select Display Mode ([1] User Items Only is recommended).
4. Select an item and click [OK] to jump to its location or search info.

[Requirements]
- Windows 10 / 11 / Windows Server 2016 - 2025
- PowerShell 5.1 or higher

[Disclaimer]
This tool is for information and navigation purposes only. 
Perform all modifications at your own risk.
==========================================================