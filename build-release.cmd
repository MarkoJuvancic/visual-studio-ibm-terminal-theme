@echo off
setlocal
cd /d "%~dp0"

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo ERROR: vswhere.exe was not found.
  echo Open Visual Studio Installer and make sure Visual Studio 2026 is installed.
  pause
  exit /b 1
)

echo Locating MSBuild with vswhere...
set "MSBUILD="
set "MSBUILD_LIST=%TEMP%\ibmterminal-msbuild-%RANDOM%-%RANDOM%.txt"
"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe > "%MSBUILD_LIST%"
if errorlevel 1 (
  echo ERROR: vswhere failed while locating MSBuild.
  if exist "%MSBUILD_LIST%" del /q "%MSBUILD_LIST%" >nul 2>&1
  pause
  exit /b 1
)
if exist "%MSBUILD_LIST%" set /p "MSBUILD="<"%MSBUILD_LIST%"
if exist "%MSBUILD_LIST%" del /q "%MSBUILD_LIST%" >nul 2>&1
if not defined MSBUILD (
  echo ERROR: No Visual Studio installation with MSBuild was found.
  pause
  exit /b 1
)
if not exist "%MSBUILD%" (
  echo ERROR: vswhere returned an MSBuild path that does not exist:
  echo %MSBUILD%
  pause
  exit /b 1
)

echo MSBuild: %MSBUILD%
echo Cleaning old build output...
if exist bin rmdir /s /q bin
if exist obj rmdir /s /q obj
if exist "IBMTerminalTheme-VS2026-v0.2.0.vsix" del /q "IBMTerminalTheme-VS2026-v0.2.0.vsix"

echo Building IBM Terminal Theme v0.2.0 in Release mode...
"%MSBUILD%" "IBMTerminalTheme.csproj" /restore /t:Rebuild /p:Configuration=Release /m
if errorlevel 1 (
  echo.
  echo BUILD FAILED.
  echo If the error mentions VSSDK or Microsoft.VsSDK.targets, install the
  echo "Visual Studio extension development" workload in Visual Studio Installer.
  pause
  exit /b 1
)

echo.
echo BUILD SUCCEEDED.
set "VSIX="
for %%F in ("bin\Release\*.vsix") do set "VSIX=%%~fF"
if not defined VSIX (
  echo ERROR: Build succeeded but no VSIX was found in bin\Release.
  pause
  exit /b 1
)

echo VSIX: %VSIX%
echo Verifying independent IBM Terminal registration...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0verify-vsix.ps1" -VsixPath "%VSIX%"
if errorlevel 1 (
  echo.
  echo VSIX VERIFICATION FAILED. The package will NOT be opened for installation.
  pause
  exit /b 1
)

copy /y "%VSIX%" "%~dp0IBMTerminalTheme-VS2026-v0.2.0.vsix" >nul
if errorlevel 1 (
  echo ERROR: Could not create final named VSIX copy.
  pause
  exit /b 1
)

echo.
echo Final installer: %~dp0IBMTerminalTheme-VS2026-v0.2.0.vsix
echo Verification passed. Opening VSIX installer...
start "" "%~dp0IBMTerminalTheme-VS2026-v0.2.0.vsix"
pause
