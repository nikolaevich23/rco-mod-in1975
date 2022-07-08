@echo off
setlocal enabledelayedexpansion
set pt=.\Rcomage\
set col=!pt!nhcolor

if not exist .\new_rco md .\new_rco
set nr=.\new_rco

for %%i in (.\rcofile\*.rco) do (
set im=%%~dpi%%~ni\img
set xm=%%~dpi%%~ni
set rco=!nr!\%%~ni.rco
)

for /f "tokens=1,2" %%a in (%im%\list.txt) do (
.\GimConv\GimConv.exe %im%\%%a.png -o %im%\%%a.gim %%b
rem del /Q %im%\%%a.png
)
echo Wait - compile |!col! 0A

if "%~1"=="ProgressBar" (call :ProgressBarEx& exit)

echo.
echo Begin LONG operation

call :ProgressBar Start

%pt%rcomage.exe compile !xm!.xml !rco! --pack-hdr zlib

call :ProgressBar Stop

echo.
echo Finished. |!col! 0A
goto :eof


:ProgressBar [Start/Stop]
  if /i "%~1"=="Stop" (del "RegBack.reg"& exit /B)
  >nul reg export "HKCU\Console" RegBack.reg /y
  >nul reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "ScreenBufferSize" /t REG_DWORD /d 0x1001e /f
  >nul reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowSize" /t REG_DWORD /d 0x1001e /f
  start cmd /k "%~f0" ProgressBar
Exit /B

:ProgressBarEx
  >nul 2>&1 reg import "RegBack.reg"
  title Ожидайте ...
  For /L %%C in (1,1,2147483647) do (
    ping 127.1 -n 1 >nul
    if not exist "RegBack.reg" exit
    set /p="|"<NUL
  )
exit /B
