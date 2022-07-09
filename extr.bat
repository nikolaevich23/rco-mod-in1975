@echo off
setlocal enabledelayedexpansion
set pt=Rcomage\
set tl=0x44 0x02
set col=!pt!nhcolor

start !pt!Wbusy "rco unpack" "Running unpack rco"  /marquee 

for %%i in (rcofile\*.rco) do (
if not exist %%~pi%%~ni md %%~pi%%~ni
if not exist %%~pi%%~ni\txt md %%~pi%%~ni\txt
if not exist %%~pi%%~ni\img md %%~pi%%~ni\img
%pt%rcomage.exe dump %%i %%~dpi%%~ni.xml --RESDIR %%~dpi%%~ni --text txt --images img
set ld=%%~dpi%%~ni
set ln=%%~ni
)

if exist !ld!\!ln!-list.txt del /Q !ld!\!ln!-list.txt

for %%f in (%ld%\img\*.gim) do (
for /f "usebackq" %%a in (`%pt%sfk hexdump -pure -nofile -rawname -offlen %tl% %%f`) do set np=%%a
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
echo %%~nf !opt! >> !ld!\!ln!-list.txt
GimConv\GimConv.exe %%f -o !ld!\img\%%~nf.png 
del /Q %%f
)
echo Finished. |!col! 0A
!pt!Wbusy "rco unpack" "Done" /Stop /sound /timeout:1
