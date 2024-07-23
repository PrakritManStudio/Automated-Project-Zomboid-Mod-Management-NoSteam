@echo off

setlocal EnableDelayedExpansion

set "steamcmdPath=steamcmd.exe"

rem Generate a random query string to avoid caching
set "randomString=%random%%random%%random%"


set "workshopList=workshopList.txt"
set "workshopListURL=https://pastebin.com/raw/G858BSRK"

if not "%workshopListURL%"=="" (
    
    del /f /q "%workshopList%"
    curl -o %workshopList% %workshopListURL%
    @REM powershell -Command "Invoke-WebRequest -Uri '%workshopListURL%' -Headers @{'Cache-Control'='no-cache'} -OutFile '%workshopList%'"
)


if not exist "%workshopList%" (
    if "%workshopListURL%"=="" (
        echo "Please provide a workshop list URL or file."
        pause
        exit /b 1
    )
)

rem Declare an empty variable to store results
set "result="

rem Read the txt file line by line
for /f "tokens=*" %%a in (%workshopList%) do (
    set "result=!result!+workshop_download_item 108600 %%a "
)

rem Remove trailing spaces from "result"
set "result=!result:~0,-1!"

%steamcmdPath% +login anonymous %result% +quit

cd ./steamapps/workshop/content/108600
rmdir /s /q "%USERPROFILE%\Zomboid\mods"

for /d %%a in (*) do (
    xcopy /e /i /y "%%a\mods" "%USERPROFILE%\Zomboid\mods"
)

echo.
echo.
echo "---------- DOWNLOAD MODS COMPLETE ----------"
echo.
echo.

pause
