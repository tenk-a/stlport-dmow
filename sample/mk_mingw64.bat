@echo off
setlocal EnableDelayedExpansion
set "STLPORT_DIR=%~dp0.."
set STLPORT_DIR=%STLPORT_DIR:\=/%

g++ -DNDEBUG -D_STLP_USE_STATIC_LIB -D_STLP_RUNTIME_DLL -fexceptions -mthreads -nodefaultlibs --include-directory=%STLPORT_DIR%/stlport -o hello.exe hello.cpp %STLPORT_DIR%/lib/mingw_x64/libstlport_statix.a -lsupc++ -lgcc -lmingw32 -lmingwex -lmingw32 -lmsvcrt -lm -lmoldname -lkernel32

endlocal
