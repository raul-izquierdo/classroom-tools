@echo off

echo Initial versions of 'roster.jar', 'teams.jar', and 'solutions.jar':
call :show_versions

rem Use -f to fail on HTTP >= 400, -S to show errors, -L to follow redirects
curl -fS -L -o roster.jar https://github.com/raul-izquierdo/roster/releases/latest/download/roster.jar
if errorlevel 1 (
	echo ERROR: Failed to download roster.jar
	if exist "roster.jar" del /q "roster.jar"
	exit /b 1
)

curl -fS -L -o teams.jar https://github.com/raul-izquierdo/teams/releases/latest/download/teams.jar
if errorlevel 1 (
	echo ERROR: Failed to download teams.jar
	if exist "teams.jar" del /q "teams.jar"
	exit /b 1
)

curl -fS -L -o solutions.jar https://github.com/raul-izquierdo/solutions/releases/latest/download/solutions.jar
if errorlevel 1 (
	echo ERROR: Failed to download solutions.jar
	if exist "solutions.jar" del /q "solutions.jar"
	exit /b 1
)


echo All jars downloaded.

echo Current versions of 'roster.jar', 'teams.jar', and 'solutions.jar':
call :show_versions

exit /b 0

:show_versions
java -jar roster.jar -V
java -jar teams.jar -V
java -jar solutions.jar -V
goto :eof
