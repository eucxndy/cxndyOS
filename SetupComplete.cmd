@echo off
start /wait BraveBrowserStandaloneSetup.exe /silent /install

dism /online /import-defaultappassociations:C:\Windows\System32\DefaultAssociations.xml
