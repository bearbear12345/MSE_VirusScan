===================================================
==MICROSOFT SECURITY ESSENTIALS VIRUS SCAN SCRIPT==
===================================================

[WINDOWS] [MSE] Virus Scan Script for Microsoft Security Essentials

This scan script will firstly update the MSE Virus Definitions, then start a scan, depending on the configurations.
After the scan completes, by default, after 3 minutes the computer will turn off. A startup VBS file will be created which will run and delete itself on the next login of the account used to scan, notifying you of the results again.

File: MSE VirusScan.bat
CRC-32: 09fd92a2
MD4: 45fd1b5b6197d2e530d4a5176cd860b9
MD5: 795eaa0406bd3c787034e62f9cb7f4a0
SHA-1: 0e485c3256786a6eb648b7acda0593b996563411

How to configure:
1) Open up your preferred text editor
2) Open the file "MSE VirusScan.bat" (Or whatever you renamed it to)
3) Configure Variables
   - If MSE is installed to a custom path, change the variable of SecurityEssentialsDirectory, removing quotes.
     Default: C:\Program Files\Microsoft Security Client
   - If you for some reason want to change the temporary directory, change the variable of tempdir, removing quotes.
     Default: %APPDATA%
   - Change the scan type from 0-3
     Types:
       0 - Default, according to your configuration
       1 - Quick Scan
       2 - Full System Scan
       3 - Custom File/Directory Scan
         - Change the variable filedir to the wanted scan target
     Default: 2
   - To change the shutdown timer, change the variable of timer to another number, in seconds
     Default: 180 (3 minutes)

OS: Windows
Prerequisites: Microsoft Security Essentials (http://windows.microsoft.com/en-au/windows/security-essentials-download)

Script by Andrew Wong (bearbear12345)
Email: andrew.j.wong@outlook.com
Skype: aw929292929683244
===================================================
