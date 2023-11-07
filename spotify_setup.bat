@echo off
setlocal enabledelayedexpansion

set "searchTerm=Spotify"
set "PackageID="

for /f "delims=" %%A in ('powershell -Command "Get-ChildItem 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages\' | ForEach-Object { Get-ItemProperty $_.PSPath } | Where-Object { $_.PSChildName -like '*%searchTerm%*' } | Select-Object -ExpandProperty PSChildName"') do (
  cd "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages\%%A"
  for /f "tokens=3" %%B in ('reg query "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages\%%A" /v PackageID ^| find "PackageID"') do (
    set "PackageID=%%B"
  )
)

if not "!PackageID!" == "" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Remove-AppxPackage -Package !PackageID!"
)

if exist "%userprofile%\AppData\Roaming\Spotify\Spotify.exe" (
  echo Spotify is installed
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
) else (
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
)

exit /b 0
