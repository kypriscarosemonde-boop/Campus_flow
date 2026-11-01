@echo off
cd /d "%~dp0"
flutter run -d chrome --web-port=5000
pause