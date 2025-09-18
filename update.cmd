@echo off
setlocal ENABLEEXTENSIONS

REM Step prompts
echo [Step 1] Get an updated file of students (for example, "alumnosMatriculados.xls").
pause
echo [Step 2] Get an updated roster file ("classroom_roster.csv").
pause

REM Run roster update
echo Running: java -jar roster.jar update
java -jar roster.jar update
set "rc=%ERRORLEVEL%"

REM Handle return codes from roster update
if "%rc%"=="1" (
  echo.
  echo The roster requires changes. Please follow these steps:
  echo 1. Apply the suggested changes to the roster using the web interface.
  echo 2. Download an updated "classroom_roster.csv".
  echo 3. Run this script "update.cmd" again to continue once you've made the changes.
  goto :EOF
)

if "%rc%"=="2" (
  echo.
  echo An error occurred while analysing the roster. Stopping.
  exit /b 2
)

if NOT "%rc%"=="0" (
  echo.
  echo Unexpected exit code %rc% from 'java -jar roster.jar update'. Stopping.
  exit /b %rc%
)

REM Continue if success (exit code 0)
echo The roster is updated. Continuing...
echo Running: java -jar teams.jar
java -jar teams.jar
set "rc2=%ERRORLEVEL%"

exit /b %rc2%
