@echo off
rem Microsoft Security Essentials Scan Script
rem   Script by Andrew Wong (bearbear12345)
rem   Email: andrew.j.wong@outlook.com
rem   Skype: aw929292929683244

::::::::::::::::::::::::::::::::::::::::CONFIGURATION::::::::::::::::::::::::::::::::::::::::


:: Provide the path to your Microsoft Security Essentials Directory
:: Don't use quotes
rem Default: C:\Program Files\Microsoft Security Client
set SecurityEssentialsDirectory=C:\Program Files\Microsoft Security Client


:: Temporary File Locations
:: Don't use quotes
rem Default: %APPDATA%
set tempdir=%APPDATA%


:: SCAN TYPE
::   Types:
::     0 - Default, according to your configuration
::     1 - Quick Scan
::     2 - Full System Scan
::     3 - Custom File/Directory Scan
rem Default: 2
set scantype=2

::     Below Only Applies If scantype Is 3 (Custom File/Directory Scan)
:: Don't use quotes
rem EG: C:\Users\User\Downloads
rem EG: C:\Users\User\Downloads\Application.exe
set filedir=

:: Time (In Seconds) to wait before shutdown\
:: -1 will not turn off the computer.
:: 0 will turn off the computer instantly.
rem Note: You can cancel the shutdown timer by running `shutdown -a`
rem Default: 180 (3 minutes)
set timer=180

::::::::::::::::::::::::::::::::::::::END CONFIGURATION::::::::::::::::::::::::::::::::::::::















































:: DO NOT EDIT BELOW
:: WELL YOU CAN, IF YOU WANT IT TO BREAK!!










rem Clears The Screen
cls
rem Set background color to Black, and forgeground to Light Green
color 0A
rem Gives the batch script a title
title Microsoft Security Essentials Scan Script - Andrew Wong

::Configuration Field Checks
rem Checks if SecurityEssentialsDirectory is an actual path
if not exist "%SecurityEssentialsDirectory%" goto not_installed
rem Checks if SecurityEssentialsDirectory contains MpCmdRun.exe - Not exactly effective, but most people wouldn't troll around with virus protection :D
if not exist "%SecurityEssentialsDirectory%\MpCmdRun.exe" goto dir_error
rem Checks if the tempdir is defined
if not defined tempdir goto tempdir_not_defined
rem Checks if tempdir is existent
if not exist %tempdir% goto tempdir_not_exist
rem Checks if tempdir is writable by the user
bearbear12345_was_here_xD >"%tempdir%\.tempfilecheck" 2>nul
if not exist "%tempdir%\.tempfilecheck" goto tempdir_no_write
del "%tempdir%\.tempfilecheck"
rem Checks if scantype is defined
if not defined scantype goto scantype_not_defined
rem Checks for a good scantype value (0,1,2,3)
set scantotal=0
set increasescantotal=set /a scantotal=%scantotal%+1 
if %scantype%==0 %increasescantotal%
if %scantype%==1 %increasescantotal%
if %scantype%==2 %increasescantotal%
if %scantype%==3 %increasescantotal%
if %scantotal%==0 goto bad_scantype
rem Checks if filedir is defined when scantype is 3 (Custom File/Directory Scan)
if %scantype%==3 if not defined filedir goto filedir_not_defined
rem Checks if filedir is an actual path or directory
if %scantype%==3 if not exist "%filedir%" goto filedir_not_found
rem Checks for a timer value
if not defined timer goto aint_got_time_for_dat
::END Configuration Field Checks










::DATE AND TIME
rem Gets output of date /T and stores it in %tempdir%\.tempdate
date /T > %tempdir%\.tempdate
rem Sets variable date to the contents of %tempdir%\.tempdate
set /p date= < %tempdir%\.tempdate
rem Deletes %tempdir%\.tempdate
del %tempdir%\.tempdate

rem Gets output of time /T and stores it in %tempdir%\.temptime
time /T > %tempdir%\.temptime
rem Sets variable time to the contents of %tempdir%\.temptime
set /p time= < %tempdir%\.temptime
rem Deletes %tempdir%\.temptime
del %tempdir%\.temptime
::END DATE AND TIME










::INITITATION
rem Prints out initial date and time of scan
echo Automated Virus Scan Started: %date%%time%
rem New Line
echo.
rem Prints out configured MSE directory
echo Security Essentials Directory: %SecurityEssentialsDirectory%
echo.
rem Changes Directory To %SecurityEssentialsDirectory%
cd /D "%SecurityEssentialsDirectory%"










::VIRUS DEFINITIONS
rem Prints "Updating Virus Definitions..."
echo Updating Virus Definitions...
rem Updates Virus Definitions, or what they call signatures.
MpCmdRun.exe -signatureupdate
rem New line
echo.
::END VIRUS DEFINITIONS










::Scan type check
if %scantype%==0 goto scan_0 
if %scantype%==1 goto scan_1
if %scantype%==2 goto scan_2
if %scantype%==3 goto scan_3
::End Scan type check










::SCAN COMPONENT
:scan_0
rem Virus Scan on Default
echo Starting Virus Scan (Mode: Default)
rem Actually Starts The Scan
MpCmdRun.exe -scan -scantype 0
goto continue
:scan_1
rem Virus Scan on Quick Scan
echo Starting Virus Scan (Mode: Quick Scan)
rem Actually Starts The Scan
MpCmdRun.exe -scan -scantype 1
goto continue
:scan_2
rem Virus Scan on Full Scan
echo Starting Virus Scan (Mode: Full Scan)
rem Actually Starts The Scan
MpCmdRun.exe -scan -scantype 2
goto continue
:scan_3
rem Virus Scan on Custom Scan
echo Starting Virus Scan (Mode: Custom Scan)
echo File/Directory to scan: %filedir%
rem Actually Starts The Scan
MpCmdRun.exe -scan -scantype 3 -file "%filedir%"
goto continue

:continue
rem Checks errorlevel of scan, 0 means success
if %ERRORLEVEL%==0 (
echo Scan Completed! Your Computer Is Clean!
) else (
rem This is called when there is an error in the scan
rem EG: Virus can't be removed
echo Scan Completed! Problems Have Been Detected During Scan! 
echo Please check the History for more information!
)

goto end
::END SCAN COMPONENT










::ERRORS
:not_installed
rem Called when %SecurityEssentialsDirectory% is not existent
echo Microsoft Security Essentials is not installed!
echo For this script to work, please install it.
echo.
echo Website Link: 
echo http://windows.microsoft.com/en-au/windows/security-essentials-download
echo.
echo The website will be opened in 30 seconds.
echo If you would like to cancel, either close the window, or press Ctrl+C (followed by a 'y')
timeout /T 30 /nobreak
if %ERRORLEVEL%==0 (
start http://windows.microsoft.com/en-au/windows/security-essentials-download
echo Webpage opened!
echo Please install Microsoft Security Essentials, and restart this script to continue
echo Press a key to exit!
pause > nul
goto :EOF
)

:dir_error
rem Called when %SecurityEssentialsDirectory% is existent, but required files are not found
echo The folder %SecurityEssentialsDirectory% exists, but files are missing!
echo Please re-install or repair your copy of Microsoft Security Essentials!
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:tempdir_not_defined
rem Called when the tempdir field is empty
echo Please enter a directory path into the tempdir field of this script!
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:tempdir_not_exist
rem Called when the tempdir field is not existent
echo The path %tempdir% has been entered into the tempdir field, but it is not existent!
echo Please input an existent directory!
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:tempdir_no_write
rem Called when the tempdir field is existent, but cannot be written to
echo You do not have access to write files into %tempdir%!
echo Please change the tempdir field to a writable path!
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:scantype_not_defined
rem Called when the scantype field is empty
echo Please input a scan type!
echo.
echo Types:
echo   0 - Default, according to your configuration
echo   1 - Quick Scan
echo   2 - Full System Scan
echo   3 - Custom File/Directory Scan (And enter something in the filedir field)
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:bad_scantype
rem Called when the scantype field is an incorrect value of 0, 1, 2 or 3
echo You have entered a bad scan type!
echo Please change the scantype to a value below
echo.
echo Types:
echo   0 - Default, according to your configuration
echo   1 - Quick Scan
echo   2 - Full System Scan
echo   3 - Custom File/Directory Scan (And enter something in the filedir field)
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:filedir_not_defined
rem Called when the scantype field is 3, and filedir field is empty
echo Please enter a file or directory path into the filedir field of this script!
echo.
echo Press a key to exit!
pause > nul
goto :EOF

:filedir_not_found
rem Called when the scantype field is 3, and filedir field is not existent
echo The file/directory path %filedir% has been entered into the filedir field, but it is not existent!
echo Please input an existent file/directory path!
echo.
echo Press a key to exit!
pause > nul
goto :EOF
:aint_got_time_for_dat
rem Get it? I mean Git it?
echo Please enter a value into the timer field!
echo Value is in seconds. From -1 to 99999
echo -1 will not turn off the computer.
echo 0 will turn off the computer instantly.
echo.
echo Press a key to exit!
pause > nul
goto :EOF
::END ERRORS










:end
::Creates Startup Script Relaying Information

rem Checks if timer is -1, which would not turn off the computer, hence no startup script
if %timer%==-1 (
echo Press a key to exit!
pause > nul
goto :EOF
)

rem Checks OS is Windows XP or later, and defines file location of securityscan_result.vbs
if exist "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" (
::Windows Vista/7/8
set securityscan_result="%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\securityscan_result.vbs"
) else ( 
rem Fallback to XP directory
::Windows XP and below
set securityscan_result="%userprofile%\Start Menu\Programs\Startup\securityscan_result.vbs"
)
rem Creates result information
if %errorlevel%==0 (
set result=Your computer is protected!
set resultcode=64
) else (
set result=There were problems detected during scan, please rectify the issue!
set resultcode=48
)
rem Writes script to securityscan_result.vbs
echo CreateObject("Scripting.FileSystemObject").DeleteFile(Wscript.ScriptFullName) > %securityscan_result%
rem setlocal enableDelayedExpansion to put a variable into another one?
setlocal enableDelayedExpansion
set line2=msgbox "The Virus Scan Performed At %date%%time% was completed." + vbnewline + "%result%", %resultcode%
echo !line2! >> %securityscan_result%
endlocal
echo Startup Script Created!

rem Shuts computer down after (%timer% field) seconds
shutdown -s -t %timer% -c "Notice: Microsoft Security Essentials Has Finished Scanning And Will Turn Of In 3 Minutes."
echo To abort this, please run 'shutdown -a'
goto :EOF



































































































Script by Andrew Wong (bearbear12345)
Email: andrew.j.wong@outlook.com
Skype: aw929292929683244