@echo off

setlocal EnableDelayedExpansion

set steamcmdPaht="steamcmd.exe"
set "wordshopList=wordshopList.txt"

rem ประกาศตัวแปรว่างสำหรับเก็บผลลัพธ์
set "result="

rem อ่านไฟล์ txt ทีละบรรทัด
for /f "tokens=*" %%a in (%wordshopList%) do (
  set "result=!result!+workshop_download_item 108600 %%a "
)

rem ลบช่องว่างออกจากท้าย "result"
set "result=!result:~0,-1!"

%steamcmdPaht% +login anonymous %result% +quit

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
