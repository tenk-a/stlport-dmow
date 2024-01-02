@echo off
setlocal EnableDelayedExpansion
set "STLPORT_DIR=%~dp0.."

set "INCLUDE=%STLPORT_DIR%\stlport;%INCLUDE%"
set "LIB=%STLPORT_DIR%\lib\vc9_x64;%LIB%"

cl -DNDEBUG -EHsc hello.cpp

endlocal
