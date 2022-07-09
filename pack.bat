@echo off
setlocal enabledelayedexpansion
set pt=Rcomage\
set col=!pt!nhcolor

if not exist new_rco md new_rco
set nr=new_rco

for %%i in (rcofile\*.rco) do (
set im=%%~dpi%%~ni\img
set xm=%%~dpi%%~ni
set rco=!nr!\%%~ni.rco
)

start !pt!Wbusy "rco pack" "Running pack rco"  /marquee 

for /f "tokens=1,2" %%a in (%xm%\list.txt) do (
GimConv\GimConv.exe %im%\%%a.png -o %im%\%%a.gim %%b
rem del /Q %im%\%%a.png
)
echo Wait - compile |!col! 0A

!pt!rcomage.exe compile !xm!.xml !rco! --pack-hdr zlib

!pt!Wbusy "rco pack" "Done" /Stop /sound /timeout:1

echo.
echo Finished. |!col! 0A
