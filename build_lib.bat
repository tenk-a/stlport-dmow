@echo off
setlocal EnableDelayedExpansion
chcp | findstr 932 >nul
set no932=%errorlevel%
if "%no932%"=="1" (
  echo "The library, unittest, and ehtest of release/debug/(stldbg) version of STLport are compiled briefly. Since time starts, it is careful."
) else (
  echo "STLport の release,debug,(stldbg)版の ライブラリ・unittest・ehtest をひと通りコンパイルする.(時間かかるので注意)"
)
if /I "%COMPILER%"=="" (
  if "%no932%"=="1" (
    echo Please perform setcc_stlp.bat beforehand. 
  ) else (
    echo 予め setcc_stlp.bat を実行してください.
  )
  goto J_END
)
pause

if /I "%COMPILER%"=="mingw" goto J_MINGW
if /I "%COMPILER%"=="dmc"   goto J_DMC
if /I "%COMPILER%"=="bcc"   goto J_BCC
call mk_stlp lib rel sta rtsta
call mk_stlp lib rel sta rtdll
call mk_stlp lib rel dll rtdll
call mk_stlp lib dbg sta rtsta
call mk_stlp lib dbg sta rtdll
call mk_stlp lib dbg dll rtdll
if /I "%COMPILER%"=="ow"  goto J_END
call mk_stlp lib stldbg sta rtsta
call mk_stlp lib stldbg sta rtdll
call mk_stlp lib stldbg dll rtdll
goto J_END

:J_MINGW
call mk_stlp lib rel sta rtdll
call mk_stlp lib rel dll rtdll
call mk_stlp lib dbg sta rtdll
call mk_stlp lib dbg dll rtdll
call mk_stlp lib stldbg sta rtdll
call mk_stlp lib stldbg dll rtdll
goto J_END

:J_DMC
call mk_stlp lib rel sta rtsta
call mk_stlp lib dbg sta rtsta
call mk_stlp lib rel dll rtsta
call mk_stlp lib dbg dll rtsta
goto J_END

:J_BCC
call mk_stlp lib rel sta rtsta
call mk_stlp lib dbg sta rtsta
goto J_END

:J_END
endlocal
