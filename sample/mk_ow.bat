@echo off
setlocal EnableDelayedExpansion
set "STLPORT_DIR=%~dp0.."

set "INCLUDE=%STLPORT_DIR%\stlport;%INCLUDE%"
set "LIB=%STLPORT_DIR%\lib\ow_x86;%LIB%"

wcl386 -DNDEBUG -xr -ze -xs -bm hello.cpp stlport_static.lib

endlocal
