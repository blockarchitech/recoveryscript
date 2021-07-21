@echo off
color 17


echo "__        ___           _                     _ _    ___  ___"
echo "\ \      / (_)_ __   __| | _____      _____  / / |  / / |/ _ \"
echo  "\ \ /\ / /| | '_ \ / _` |/ _ \ \ /\ / / __| | | | / /| | | | |"
echo   "\ V  V / | | | | | (_| | (_) \ V  V /\__ \ | | |/ / | | |_| |"
echo    "\_/\_/  |_|_| |_|\__,_|\___/ \_/\_/ |___/ |_|_/_/  |_|\___/""

echo " ____"
echo "|  _ \ ___  ___ _____   _____ _ __ _   _"
echo "| |_) / _ \/ __/ _ \ \ / / _ \ '__| | | |"
echo "|  _ <  __/ (_| (_) \ V /  __/ |  | |_| |"
echo "|_| \_\___|\___\___/ \_/ \___|_|   \__, |"
echo  "                                  |___/"
echo " ____            _       _"
echo "/ ___|  ___ _ __(_)_ __ | |_"
echo "\___ \ / __| '__| | '_ \| __|"
echo  "___) | (__| |  | | |_) | |_"
echo "|____/ \___|_|  |_| .__/ \__|"
echo  "                 |_|   "

echo Getting system info. Please wait...
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
systeminfo | findstr /B /C:"System Manufacturer" /C:"System Model"
systeminfo | findstr /B /C:"Host Name"
systeminfo | findstr /B /C:"Processor(s)"
echo "Built by blockarchitech on GitHub. github.com/blockarchitech/recoveryscript"
echo "THIS SCRIPT IS ONLY MEANT TO BE RUN IN A RECOVERY SHELL. DO NOT RUN ELSEWHERE!"
echo "I, NOR THE INSTUCTOR TELLING YOU TO RUN THIS SCRIPT IS LIABLE FOR ANY DAMAGES CAUSED BY THIS SCRIPT. YOU DECIDED TO RUN THIS."
:start
ECHO 1. Run CHKDSK and SFC
ECHO 2. Fix MBR, Rebuild BCD, try to go into recovery mode. NOTE: THIS WILL MAKE YOUR COMPUTER BOOT INTO RECOVERY MODE EVERY TIME. RUN bcdedit /set {default} recoveryenabled No WHEN DONE.
ECHO 3. Boot into Safe Mode NOTE: THIS WILL MAKE YOUR COMPUTER BOOT INTO SAFE MODE EVERY TIME. RUN bcdedit /deletevalue {default} safeboot WHEN DONE.
ECHO 4. Full System Info.
ECHO 5. Go back!
set choice=
set /p choice=Type what you want to run.
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto chkdsk
if '%choice%'=='2' goto FixMBR
if '%choice%'=='3' goto safemode
if '%choice%'=='4' goto fullsysinfo
if '%choice%'=='5' goto exit
ECHO "%choice%" is not valid, try again
ECHO
goto start
:chkdsk
ECHO Running CHKDSK /F and SFC /SCANNOW

echo "NOTICE: CHKDSK may have to run at next startup if this is *not* in a recovery shell."

echo Running CHKDSK /F on drive C
chkdsk /F C:

echo Running sfc /scannow
sfc /scannow
echo Returning...
goto start
:fullsysinfo
ECHO Printing full system info.
systeminfo
echo Returning...
goto start
:FixMBR
ECHO Fixing MBR and Attempting to boot into Automatic Repair.
bootrec /fixboot
bootrec /fixmbr
bootrec /rebuildbcd
echo Attempting to boot into automatic repair. Please wait.
bcdedit /set {default} device partition=c:
bcdedit /set {default} osdevice partition=c:
bcdedit /set {default} recoveryenabled Yes
echo Waiting 5 seconds til restart
timeout 5
shutdown /r
goto start
:end
echo Attempting a safemode boot
bcdedit /set {default} safeboot minimal
echo Waiting 5 seconds before reboot.
timeout 5
shutdown /r
goto start

:exit
pause
