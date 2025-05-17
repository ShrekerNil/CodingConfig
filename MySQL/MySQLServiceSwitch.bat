@ECHO off
title Windows SERVICE MANAGEMENT TOOL

ECHO ++++++++++++++++++++++++++++++++++++ AUTOMATICALLY ESCALATE RUNNING PERMISSIONS ++++++++++++++++++++++++++++++++++++
%1 %2
ver|find "5.">nul && goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close) & goto :eof
:Admin
ECHO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ECHO ++++++++++++++++++++++++++++++++++++ LISTING SERVICES STATUS ++++++++++++++++++++++++++++++++++++
for /f "skip=3 tokens=4" %%i in ('sc query "mysql"') do set "zt=%%i" & goto :next
:next
if /i "%zt%"=="RUNNING" (
  ECHO   SERVICE OF === MySQL === IS RUNNING ...
) else (
  ECHO   SERVICE OF === MySQL === STOPPPED.
)


ECHO +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO +         1: ENABLE MySQL SERVICE   2: DISABLE MySQL SERVICE        +
ECHO +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
choice /c:12 /m "INPUT YOUR CHOICE:"
if errorlevel 2 goto two
if errorlevel 1 goto one

:one
ECHO ++++++++++++++++++++++++++++++++++++ STARTING SERVICES ++++++++++++++++++++++++++++++++++++
net start "mysql"

ECHO.
ECHO TASK FINISHED, PRESS ANY KEY TO CONTINUE ...
pause>nul
exit

:two
ECHO.
ECHO ++++++++++++++++++++++++++++++++++++ STOPPING SERVICES ++++++++++++++++++++++++++++++++++++
for /f "skip=3 tokens=4" %%i in ('sc query "mysql"') do set "zt=%%i" & goto :next
:next
if /i "%zt%"=="RUNNING" (
  ECHO   SERVICE OF === MySQL === IS RUNNING, Stopping ...
  NET STOP "mysql"
) else (
  ECHO   SERVICE OF === MySQL === Already STOPPPED.
)

ECHO.
ECHO TASK FINISHED, PRESS ANY KEY TO CONTINUE ...
pause>nul
exit
