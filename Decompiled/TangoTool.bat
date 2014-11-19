@echo off
color 0F
echo ========================================= Copyright (C) 2014 Ricky Divjakovski(Ricky310711) ===============================================
echo.
echo *you cannot redistribute this and/or modify in any way, commits are welcome on git and will be reviewed - ricky310711@github             *
echo.
echo *This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of          *
echo.
echo *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                                                                                    *
echo.
echo *This tool was originally part of AET(android everything tool) also made by me(ricky310711).                                             *
echo.
echo *I do not ask for money but if you would like to contribute to my work go ahead and donate and i will appreciate you and add you to      *
echo.
echo *the "Special thanks list" where all donators will be listed                                                                             *
echo.
echo *This program is designed for users to experiance android the way they want it and be able to release roms with their creatvity included *
echo.
echo ===========================================================================================================================================
echo.
cls

mode con:cols=80 lines=60
:unpacktools
cls
echo unpacking tools..
if not exist tools.zip goto unpacktools
mkdir tools
7z e "tools.zip" -o"tools"

:main
cls
if not exist tools/adb.exe goto main
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
"tools/adb.exe" devices
echo.
echo   1- Instructions to root
echo   2- Debrand device
echo   3- Install busybox
echo   4- Install bash
echo   5- Add init.d support
echo   6- Wipe menu
echo   7- Unroot
echo   8- Reboot menu
echo   9- Donate To This Project
echo.
echo.
echo ********************************************************************************
echo.
set selection=RICKY310711
set /P selection=Make your decision:
if %selection% == 1 goto howtoroot
if %selection% == 2 goto debranddevice
if %selection% == 3 goto installbusybox
if %selection% == 4 goto installbash
if %selection% == 5 goto addinitd
if %selection% == 6 goto wipemenu
if %selection% == 7 goto unroot
if %selection% == 8 goto rebootmenu
if %selection% == 9 goto donate
set selection=RICKYDIVJAKOVSKI
echo OOOPS, looks like you typed something wrong..
echo.
pause>nul
goto main

:howtoroot
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Step 1. connect your device to pc
echo   Step 2. slide down the statusbar and press the usb notification
echo   Step 3. choose install driver and install the driver on your pc
echo   Step 4. go to settings-about phone and press the build number tab 5 times
echo   Step 5. go back to settings and open the new developer options tab
echo   Step 6. enable USB debigging from the developer options menu
echo   Step 7. go to http://www.kingoapp.com/ and download and install the program
echo   Step 8. open the program on your pc and click the root button
echo   Step 9. ENJOY!
echo.
echo.
echo ********************************************************************************
pause
goto main

:debranddevice
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Debranding the device will remove all BOOST files from device.
echo   You must be rooted and you must have busybox installed.
echo.
echo                                  Continue? Y/N
echo ********************************************************************************
echo.
set selection=n
set /P selection=Make your decision:
if %selection% == n goto main
if %selection% == N goto main
tools/abd pull /system/xbin/busybox
if not exist busybox echo [*] ERROR: INSTALL BUSYBOX FIRST
if not exist busybox pause
if not exist busybox exit
del busybox
echo [*] Remounting system r/w
tools/abd shell "su -c busybox mount -o remount rw /system/">nul
if errorlevel 1 (echo [*] ERROR: Failed to debrand device
exit
)
cls
echo [*] Debranding device
tools/abd shell "su -c rm /system/app/Boost.apk">nul
tools/abd shell "su -c rm /system/app/Browser.apk">nul
tools/abd shell "su -c rm /system/app/Browser.odex">nul
tools/abd shell "su -c rm /system/app/TouchPal.apk">nul
tools/abd shell "su -c rm /system/app/Mi-EasyAccess.apk">nul
tools/abd shell "su -c rm /system/app/Mi-EasyAccess.odex">nul
cls
echo [*] Pulling files for editing
tools/abd pull /system/build.prop
cls
echo [*] Editing files
tools/sed build.prop "ro.build.display.id=B790_M01" "ro.build.display.id=STOCK_ZTE"
cls
echo [*] Pushing files
tools/abd push build.prop /data/local/tmp
cls
echo [*] Moving files to system
tools/abd shell "su -c cp -rf /data/local/tmp/build.prop /system/build.prop"
cls
echo [*] Setting file permissions
tools/abd shell "su -c chmod 644 /system/build.prop">nul
cls
echo [*] Wiping dalvik cache
tools/abd shell "rm -rf /data/dalvik-cache">nul
cls
echo [*] Rebooting
tools/abd reboot>nul
cls
echo [*] Waiting for tools/abd server
tools/abd wait-for-device>nul
cls
echo [*] Remounting system r/w
tools/abd shell "su -c busybox mount -o remount rw /system/">nul
cls
echo [*] Checking result
tools/abd shell "getprop ro.build.display.id" > out.txt
set /p output=<out.txt
if %output% == B790_M01 (
echo [*] ERROR: Failed to debrand device
)
if %output% == STOCK_ZTE (
echo [*] SUCCESS: Successfully debranded device
)
del build.prop
del out.txt
pause
goto main

:installbusybox
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Installing busybox will allow you to use some apps that require it not to
echo   mention it being close to mandatory for root apps.
echo   You must be rooted and you must have busybox installed.
echo.
echo                                  Continue? Y/N
echo ********************************************************************************
echo.
set selection=n
set /P selection=Make your decision:
if %selection% == n goto main
if %selection% == N goto main
echo [*] Remounting system r/w
"tools/adb.exe" shell "mount -o remount rw /system/"
cls
echo [*] Pushing files to tmp
"tools/adb.exe" push tools/busybox /data/local/tmp/
cls
echo [*] Moving files to system
"tools/adb.exe" shell "su -c cp /data/local/tmp/busybox /system/xbin/"
cls
echo [*] Removing obsolete files
"tools/adb.exe" shell "su -c rm /data/local/tmp/busybox"
cls
echo [*] Setting file permissions
"tools/adb.exe" shell "su -c chmod 775 /system/xbin/busybox"
cls
echo [*] Installing busybox
"tools/adb.exe" shell "su -c /system/xbin/busybox --install /system/xbin"
if errorlevel 1 goto errbusybox
cls
echo [*] SUCCESS: busybox successfully installed
pause
exit
:errbusybox
cls
echo [*] ERROR: Busybox failed to install
pause
goto main

:installbash
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Installing allows extra functionality within the shell.
echo   You must be rooted and you must have busybox installed.
echo.
echo                                  Continue? Y/N
echo ********************************************************************************
echo.
set selection=n
set /P selection=Make your decision:
if %selection% == n goto main
if %selection% == N goto main
@echo off
echo [*] Remounting system r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /system/">nul
cls
echo [*] Pushing files to tmp
"tools/adb.exe" push tools/bash /data/local/tmp/
cls
echo [*] Moving files to system
"tools/adb.exe" shell "su -c cp /data/local/tmp/bash /system/bin/"
cls
echo [*] Removing obsolete files
"tools/adb.exe" shell "su -c rm /data/local/tmp/bash"
cls
echo [*] Setting file permissions
"tools/adb.exe" shell "su -c chmod 777 /system/bin/bash"
cls
echo [*] Checking result
mkdir tmp
"tools/adb.exe" pull /system/bin/bash tmp
cls
if exist tmp/bash (echo [*] SUCCESS: bash successfully installed) else (echo [*] ERROR: bash failed to install)
rmdir /s /q tmp
pause
goto main

:addinitd
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Init.d is the abillity to run scripts from /system/etc/init.d on boot.
echo   You must be rooted and you must have busybox installed.
echo.
echo                                  Continue? Y/N
echo ********************************************************************************
echo.
set selection=n
set /P selection=Make your decision:
if %selection% == n goto main
if %selection% == N goto main
echo [*] Remounting system r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /system/">nul
cls
echo [*] Pushing files to tmp
"tools/adb.exe" push tools/sysinit /data/local/tmp
"tools/adb.exe" push tools/install-recovery.sh /data/local/tmp
"tools/adb.exe" push tools/99test /data/local/tmp
"tools/adb.exe" push tools/run-parts /data/local/tmp
cls
echo [*] Making /system/etc/init.d
"tools/adb.exe" shell "su -c mkdir -p /system/etc/init.d">nul
cls
echo [*] Moving files to system
"tools/adb.exe" shell "su -c cp /data/local/tmp/sysinit /system/bin/sysinit">nul
"tools/adb.exe" shell "su -c cp /data/local/tmp/install-recovery.sh /system/etc/install-recovery.sh">nul
"tools/adb.exe" shell "su -c cp /data/local/tmp/99test /system/etc/init.d/99test">nul
"tools/adb.exe" shell "su -c cp /data/local/tmp/run-parts /system/xbin/run-parts">nul
cls
echo [*] Removing obsolete files
scripts\"tools/adb.exe" shell "rm /data/local/tmp/sysinit"
scripts\"tools/adb.exe" shell "rm /data/local/tmp/install-recovery.sh"
scripts\"tools/adb.exe" shell "rm /data/local/tmp/99test"
scripts\"tools/adb.exe" shell "rm /data/local/tmp/run-parts"
cls
echo [*] Setting file permissions
"tools/adb.exe" shell "su -c chmod 777 /system/etc/install-recovery.sh">nul
"tools/adb.exe" shell "su -c chown 0.2000 /system/etc/install-recovery.sh">nul
"tools/adb.exe" shell "su -c chmod 755 /system/bin/sysinit">nul
"tools/adb.exe" shell "su -c chown 0.2000 /system/bin/sysinit">nul
"tools/adb.exe" shell "su -c chmod 777 /system/xbin/run-parts">nul
"tools/adb.exe" shell "su -c chown 0.2000 /system/xbin/run-parts">nul
"tools/adb.exe" shell "su -c chmod -R 777 /system/etc/init.d">nul
"tools/adb.exe" shell "su -c chown 0.0 /system/etc/init.d">nul
cls
echo [*] Rebooting for test
"tools/adb.exe" reboot>nul
cls
echo [*] Waiting for "tools/adb.exe" server
"tools/adb.exe" wait-for-device>nul
cls
echo [*] Remounting system r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /system/">nul
cls
echo [*] Checking result
"tools/adb.exe" pull /data/local/tmp/test.txt
cls
if exist test.txt (echo [*] SUCCESS: Init.d successfully merged to boot process) else (echo [*] ERROR: init.d failed to merge to boot process)
if exist test.txt (del test.txt)
pause
goto main

:wipemenu
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   1- Wipe dalvik cache
echo   2- Wipe data factory reset
echo   0- Main menu
echo.
echo.
echo ********************************************************************************
echo.
set selection=RICKY310711
set /P selection=Make your decision:
if %selection% == 1 goto wipedalvik
if %selection% == 2 goto factoryreset
if %selection% == 0 goto main

:wipedalvik
cls
"tools/adb.exe" pull /system/xbin/busybox
if not exist busybox echo [*] ERROR: INSTALL BUSYBOX FIRST
if not exist busybox pause
if not exist busybox exit
del busybox
echo [*] Remounting data r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /data/">nul
cls
echo [*] Wiping dalvik cache
"tools/adb.exe" shell "rm -rf /data/dalvik-cache">nul
cls
echo [*] Rebooting
"tools/adb.exe" reboot>nul
cls
echo [*] SUCCESS: Successfully wiped dalvik-cache
pause
goto wipemenu

:factoryreset
cls
"tools/adb.exe" pull /system/xbin/busybox
if not exist busybox echo [*] ERROR: INSTALL BUSYBOX FIRST
if not exist busybox pause
if not exist busybox exit
del busybox
echo [*] Remounting data r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /data/">nul
cls
echo [*] Remounting cache r/w
"tools/adb.exe" shell "su -c busybox mount -o remount rw /cache/">nul
cls
echo [*] Wiping cache
"tools/adb.exe" shell "busybox rm -rf /cache/.">nul
cls
echo [*] Wiping data
"tools/adb.exe" shell "busybox rm -rf /data/.">nul
cls
exit
echo [*] Rebooting
"tools/adb.exe" reboot>nul
cls
echo [*] SUCCESS: Successfully performed factory reset
pause
goto wipemenu

:unroot
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   Unrooting is what it is.
echo   It completely removes root access from your device.
echo   You must be rooted.
echo.
echo                                  Continue? Y/N
echo ********************************************************************************
echo.
set selection=n
set /P selection=Make your decision:
if %selection% == n goto main
if %selection% == N goto main
echo [*] Remounting system r/w
"tools/adb.exe" shell "su -c mount -o remount rw /"
cls
echo [*] Removing root files
"tools/adb.exe" shell "su -c rm /system/app/Superuser.apk"
"tools/adb.exe" shell "su -c rm /system/xbin/daemonsu"
"tools/adb.exe" shell "su -c rm /system/xbin/su"
cls
echo [*] Rebooting for test
"tools/adb.exe" reboot>nul
cls
echo [*] Waiting for "tools/adb.exe" server
"tools/adb.exe" wait-for-device>nul
cls
echo [*] Checking result
"tools/adb.exe" pull /system/xbin/su
cls
if exist su (echo [*] ERROR: Failed to unroot) else (echo [*] SUCCESS: Successfully unrooted device)
if exist su (del su)
pause
goto main

:rebootmenu
cls
echo ********************************************************************************
echo                          TANGOTOOL BY RICKY DIVJAKOVSKI 
echo. 
echo ********************************************************************************
echo.
echo.
echo   1- Reboot
echo   2- Reboot recovery
echo   3- Reboot bootloader
echo   0- Main menu
echo.
echo.
echo ********************************************************************************
echo.
set selection=RICKY310711
set /P selection=Make your decision:
if %selection% == 1 goto reboot
if %selection% == 2 goto rebootrecovery
if %selection% == 3 goto rebootbootloader
if %selection% == 0 goto main

:reboot
"tools/adb.exe" reboot
echo [*] SUCCESS: Successfully rebooted device
pause
goto main

:rebootrecovery
"tools/adb.exe" reboot recovery
echo [*] SUCCESS: Successfully rebooted device into recovery
pause
goto main

:rebootbootloader
"tools/adb.exe" reboot bootloader
echo [*] SUCCESS: Successfully rebooted device into bootloader
pause
goto main

:donate
start tools/donate.url
goto main