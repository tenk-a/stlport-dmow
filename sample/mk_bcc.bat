@echo off
rem for borland-c++ 5.5.1
setlocal EnableDelayedExpansion
set "STLPORT_DIR=%~dp0.."

bcc32 -D_MT -DNDEBUG -I%STLPORT_DIR%\stlport -L%STLPORT_DIR%\lib\bcc_x86 hello.cpp stlport_static.lib

endlocal
