@echo off
setlocal EnableDelayedExpansion
set "STLPORT_DIR=%~dp0.."

set "INCLUDE=%STLPORT_DIR%\stlport;%INCLUDE%"
set "LIB=%STLPORT_DIR%\lib\dmc_x86;%LIB%"

dmc -DNDEBUG -D_MT -Aa -Ab -Ae -Ar hello.cpp stlport_static.lib

endlocal
