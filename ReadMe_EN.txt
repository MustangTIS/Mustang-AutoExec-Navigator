==========================================================
 Mustang AutoExec Navigator v1.6.2
==========================================================

[Overview]
Mustang AutoExec Navigator is a lightweight, powerful tool 
for Windows Administrators to audit and manage "Auto-Run" items[cite: 1].
It provides a unified view across Services, Task Scheduler, 
Registry, and Startup Folders[cite: 2].

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
- Noise Reduction Filter: Excludes Microsoft/System standard items[cite: 3].
- Direct Registry Jump: Opens Registry Editor at the specific key instantly[cite: 4].
- Advanced Google Search: Automatically searches for items using 
  Name + Publisher for high-accuracy results[cite: 5].
- Continuous Navigation: Returns to the list after each action[cite: 6].

[File Structure]
- AutoRun.bat               : Main Launcher (MUST Run as Administrator) [cite: 7]
- StartAppNavigator_JP.ps1  : Japanese Edition [cite: 7]
- StartAppNavigator_EN.ps1  : English Edition [cite: 7]

[How to Use]
1. Right-click "AutoRun.bat" and select "Run as Administrator".
2. Select Language (1.Japanese / 2.English).
3. Select Display Mode ([1] User Items Only is recommended)[cite: 8].
4. Select an item and click [OK] to jump to its location or search info[cite: 10].

[Requirements]
- Windows 10 / 11 / Windows Server 2011 - 2025 [cite: 12]
- PowerShell 5.1 or higher [cite: 12]

[Disclaimer]
This tool is for information and navigation purposes only. 
Perform all modifications at your own risk[cite: 13].
==========================================================