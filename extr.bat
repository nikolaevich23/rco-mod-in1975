@echo off
setlocal enabledelayedexpansion
set pt=Rcomage\
set col=!pt!nhcolor
set tl=0x44 0x02
set hdr=0x0C 0x04
set h1=0x5c 0x4
set h2=0x60 0x4
set h3=0x10

start !pt!Wbusy "rco unpack" "Running unpack rco"  /marquee 

for %%i in (rcofile\*.rco) do (
if not exist %%~pi%%~ni md %%~pi%%~ni
if not exist %%~pi%%~ni\txt md %%~pi%%~ni\txt
if not exist %%~pi%%~ni\img md %%~pi%%~ni\img
set ld=%%~dpi%%~ni
set ln=%%~ni
for /f "usebackq" %%h in (`!pt!sfk hexdump -pure -nofile -rawname -offlen !hdr! %%i`) do set hc=%%h
if !hc!==00000000 set opt=none
if !hc!==00000010 set opt=zlib
if !hc!==00000020 set opt=rlz
echo !opt! > !ld!\!ln!-conf.txt
!pt!rcomage.exe dump %%i !ld!.xml --RESDIR !ld! --text txt --images img
if exist !ld!\!ln!-list.txt del /Q !ld!\!ln!-list.txt

for %%f in (!ld!\img\*.gim) do (
echo check %%f 
set /a rez=0
set /a n1=0
for /f "usebackq" %%a in (`!pt!sfk hexdump -pure -nofile -rawname -offlen !tl! %%f`) do set np=%%a
if !np!==0000 set opt=-ps3rgba5650
if !np!==0001 set opt=-ps3rgba5551
if !np!==0002 set opt=-ps3rgba4444
if !np!==0003 set opt=-ps3rgba8888
if !np!==0004 set opt=-ps3index4
if !np!==0005 set opt=-ps3index8
if !np!==0006 set opt=-ps3index16
if !np!==0007 set opt=-ps3index32
if !np!==0008 set opt=-ps3dxt1
if !np!==0009 set opt=-ps3dxt3
if !np!==000A set opt=-ps3dxt5
if !np!==0108 set opt=-ps3dxt1ext
if !np!==0109 set opt=-ps3dxt3ext
if !np!==010A set opt=-ps3dxt5ext
for /f "usebackq" %%j in (`!pt!sfk hexdump -pure -nofile -rawname -offlen !h1! %%f`) do set hc1=%%j
for /f "usebackq" %%g in (`!pt!sfk hexdump -pure -nofile -rawname -offlen !h2! %%f`) do set hc2=%%g
set /a rez=0x!hc1!+0x!hc2!+!h3!
for %%l in ("%%f") do set size=%%~zl
IF !rez! LEQ !size! (
!pt!sfk partcopy %%f -quiet -allfrom -yes !rez! !ld!\%%~nf.vtxt
!pt!sfk rep !ld!\%%~nf.vtxt -bin /00/0D0A/ -yes -quiet
for /f "UseBackQ Delims=" %%V IN (!ld!\%%~nf.vtxt) do (
set /a c+=1
if !c!==4 set "cver=%%V"
)
echo !cver!> !ld!\%%~nf.vtxt
)
set /a c=0
for /f "tokens=*" %%m in ('CertUtil -hashfile %%f MD5') do (
set /a n1+=1 && if !n1!==2 set hash=%%m && set MD5=!hash: =!
)
echo %%~nf !opt! !MD5!>> !ld!\!ln!-list.txt
GimConv\GimConv.exe %%f -o !ld!\img\%%~nf.png 
)
)
del /Q /S rcofile\*.gim

echo Finished. |!col! 0A
!pt!Wbusy "rco unpack" "Done" /Stop /sound /timeout:1