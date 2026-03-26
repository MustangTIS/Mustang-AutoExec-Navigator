==========================================================
 Mustang AutoExec Navigator v1.5
==========================================================

[Overview]
Mustang AutoExec Navigator is a lightweight, powerful tool 
for Windows Administrators to audit and manage "Auto-Run" items.

It provides a unified view of items scattered across 
Services, Task Scheduler, Registry (Run keys), and Startup Folders.

[Key Features]
1. Noise Reduction Filter (Selectable at Launch)
   Excludes Microsoft/System standard items, focusing only on 
   user-installed or third-party applications.
2. Direct Registry Jump
   Select a Registry item and click [OK] to open the 
   Registry Editor directly at that specific key.
3. Automatic Google Search (Services/Tasks)
   Instantly searches for the item name in your browser 
   to help identify unknown services or tasks.
4. Continuous Navigation (Loop Mode)
   Returns to the list after each action, allowing for 
   rapid, sequential investigation.

[File Structure]
- AutoRun.bat               : Main Launcher (Run as Admin recommended)
- StartAppNavigator_JP.ps1  : Japanese Edition
- StartAppNavigator_EN.ps1  : English Edition

[How to Use]
1. Run "AutoRun.bat".
2. Select the display mode in the console window:
   [1] User Items Only : Recommended for daily audits.
   [2] Show Everything : For full system investigation.
3. Select an item from the grid and click [OK]:
   - Registry/Folder : Opens the specific location.
   - Service/Task    : Opens Google Search and Management Consoles.
4. To exit, close the grid window or click [Cancel].

[Requirements]
- Windows 10 / 11 / Windows Server 2011 - 2025
- PowerShell 5.1 or higher

[Disclaimer]
This tool is for information and navigation purposes only. 
Any modifications to the registry or stopping services should 
be performed at your own risk.
==========================================================