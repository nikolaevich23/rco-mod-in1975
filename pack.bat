@echo off
setlocal enabledelayedexpansion
set pt=Rcomage\
set col=!pt!nhcolor

if not exist new_rco md new_rco
set nr=new_rco

for %%i in (rcofile\*.rco) do (
set xm=%%~dpi%%~ni
set rco=!nr!\%%~ni.rco
set ln=%%~ni
)

start !pt!Wbusy "rco pack" "Running pack rco"  /marquee 

for /f "tokens=1,2" %%a in (!xm!\!ln!-list.txt) do (
GimConv\GimConv.exe %xm%\img\%%a.png -o %xm%\img\%%a.gim %%b
rem del /Q !xm!\img\%%a.png
)
echo Wait - compile |!col! 0A

!pt!rcomage.exe compile !xm!.xml !rco! --pack-hdr zlib

!pt!Wbusy "rco pack" "Done" /Stop /sound /timeout:1

echo.
echo Finished. |!col! 0A
