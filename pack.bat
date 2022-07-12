@echo off
setlocal enabledelayedexpansion
set pt=Rcomage\
set col=!pt!nhcolor

if not exist new_rco md new_rco
set nr=new_rco

start !pt!Wbusy "rco pack" "Running pack rco"  /marquee 
for %%i in (rcofile\*.rco) do (
set xm=%%~dpi%%~ni
set rco=!nr!\%%~ni.rco
set ln=%%~ni

for /f "tokens=1,2" %%a in (!xm!\!ln!-list.txt) do (
if exist !xm!\%%a.vtxt (
for /f "tokens=1,2" %%c in (!xm!\%%a.vtxt) do (
set g1=%%c
if !g1!==GimConv (set g2=%%d
set g2=!g2:~4,1!
set "op=--update_fileinfo on"
)
)
) else (
set g2=e
set "op="
)
GimConv\GimConv!g2! !xm!\img\%%a.png -o !xm!\img\%%a.gim %%b !op!
set /a n1=0
for /f "tokens=*" %%m in ('CertUtil -hashfile !xm!\img\%%a.gim MD5') do (
set /a n1+=1 && if !n1!==2 set hash=%%m && set MD5=!hash: =!
)
echo %%a.gim !MD5! >> !xm!\gim.md5
)
echo Wait - compile |!col! 0A

for /f "tokens=1" %%h in (!xm!\!ln!-conf.txt) do (
!pt!rcomage.exe compile !xm!.xml !rco! --pack-hdr %%h
)

)
!pt!Wbusy "rco pack" "Done" /Stop /sound /timeout:1

echo.
echo Finished. |!col! 0A
:end