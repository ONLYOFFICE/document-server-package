@ECHO off
ECHO | SET /p="Preparing for shutdown, it can take a lot of time, please wait..."
powershell.exe -ExecutionPolicy Bypass -File "%~dp0\documentserver-prepare4shutdown.ps1"
ECHO Done