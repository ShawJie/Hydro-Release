@echo off
set param=%1

:start
if %param% EQU -i (
goto install
)
if %param% EQU -u (
goto update
)
if %param% EQU -s (
goto shutdown
)

:install
java -jar -Dfile.encoding=utf-8 -Dloader.path=.,"hydro-config.yaml" hydro.jar
goto exit

:update
set root=%~dp1
echo root is %root%

if not exist %root%update\hydro (
echo cannot find the update package - %root%update\hydro
) else (
curl -X POST 127.0.0.1:12138/HydroSys/shutdown
rem delay after server shutdown
ping /n 3 127.0.0.1 >nul

echo Starting copy files
echo copy %root%update\hydro to %root%
xcopy %root%update\hydro %root% /Y /E
echo.

rd /s/q %root%update
echo update file is delete

goto install
)
goto exit

:shutdown
curl -X POST 127.0.0.1:12138/HydroSys/shutdown
goto exit

:exit
pause