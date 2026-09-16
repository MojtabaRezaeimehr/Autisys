
@echo off
echo Cleaning Delphi temporary files...
del /s /q *.dcu
del /s /q *.exe
del /s /q *.stat
del /s /q *.~*
del /s /q *.tvsconfig
del /s /q *.local
del /s /q *.map
del /s /q *.identcache
echo Done.
pause
