param([Parameter(Mandatory=$true)][string]$VsixPath)
$ErrorActionPreference = 'Stop'
$themeGuid = '9b27d64e-946c-4d4e-aec7-26e3f408ad4e'
$radarThemeGuid = '9dbab5c6-1554-5d9a-b69d-8cbfb045d22b'
$vsixId = 'IBMTerminalTheme.VisualStudio2026.2f7db5b6-d4b9-48d8-80a0-c0d9f82c4e68'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $VsixPath))
try {
  $pkgdefs = @($zip.Entries | Where-Object { $_.FullName -like '*.pkgdef' })
  Write-Host "PKGDEF entries found: $($pkgdefs.Count)"
  foreach ($entry in $pkgdefs) { Write-Host "  - $($entry.FullName)" }
  if ($pkgdefs.Count -lt 2) { throw "Expected at least two .pkgdef entries: package + IBM Terminal theme colors." }
  $themeFound=$false; $radarFound=$false
  foreach ($entry in $pkgdefs) {
    $reader=New-Object System.IO.StreamReader($entry.Open())
    try { $text=$reader.ReadToEnd() } finally { $reader.Dispose() }
    if ($text -match [regex]::Escape("`$RootKey`$\Themes\{$themeGuid}")) { Write-Host "IBM Terminal theme registration found in: $($entry.FullName)"; $themeFound=$true }
    if ($text -match [regex]::Escape("`$RootKey`$\Themes\{$radarThemeGuid}")) { $radarFound=$true }
  }
  if (-not $themeFound) { throw "IBM Terminal theme registry key was NOT found in the built VSIX." }
  if ($radarFound) { throw "Radar theme GUID was found inside IBM Terminal VSIX. The themes must remain independent." }
  $manifestEntry=$zip.Entries | Where-Object { $_.FullName -eq 'extension.vsixmanifest' -or $_.FullName -eq 'source.extension.vsixmanifest' } | Select-Object -First 1
  if ($manifestEntry) {
    $reader=New-Object System.IO.StreamReader($manifestEntry.Open())
    try { $manifestText=$reader.ReadToEnd() } finally { $reader.Dispose() }
    if ($manifestText -notmatch [regex]::Escape($vsixId)) { throw "IBM Terminal VSIX identity was not found in packaged manifest." }
  }
  Write-Host "IBM TERMINAL VSIX verification PASSED." -ForegroundColor Green
} finally { $zip.Dispose() }
