Param([string]$Arch)
$ErrorActionPreference = 'Stop'
Write-Host 'Setting up Flutter'
choco install flutter --no-progress -y
$env:Path += ';C:\tools\flutter\bin'
flutter --version
flutter doctor
flutter pub get
flutter build windows --release
