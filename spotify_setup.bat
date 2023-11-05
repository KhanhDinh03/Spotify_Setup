@echo off
set "url=https://download.scdn.co/SpotifySetup.exe"
set "installer=SpotifySetup.exe"

echo Download from %url%
curl -o %installer% -L %url%

if %errorlevel% neq 0 (
  echo Download fail.
  exit /b 1
)

echo Installing %installer%
start /wait %installer%

del %installer%

echo Success installer.

echo Installing Script...

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1 | iex"

set "url_adblock=https://raw.githubusercontent.com/CharlieS1103/spicetify-extensions/main/adblock/adblock.js"
set "destination=%appdata%\spicetify\Extensions\adblock.js"

echo Download from %url_adblock%
curl -o "%destination%" -L %url_adblock%

if %errorlevel% neq 0 (
  echo Download fail.
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "spicetify config extensions adblock.js"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "spicetify apply"

echo Done!
exit /b 0
