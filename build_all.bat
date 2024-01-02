@echo off
setlocal EnableDelayedExpansion
set ARG1=%1
set SKIP_MODE=0
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

call mk_stlp CompilerTest
call mk_stlp kkkk

if /I "%COMPILER%"=="mingw" goto J_MINGW
if /I "%COMPILER%"=="dmc"   goto J_DMC
if /I "%COMPILER%"=="bcc"   goto J_BCC

call mk_stlp rel sta rtsta %ARG1%
if /I "%SKIP_MODE%"=="1" goto J_END
call mk_stlp dbg sta rtsta %ARG1%
call mk_stlp rel sta rtdll %ARG1%
call mk_stlp dbg sta rtdll %ARG1%
call mk_stlp rel dll rtdll %ARG1%
call mk_stlp dbg dll rtdll %ARG1%

if /I "%COMPILER%"=="ow"  goto J_END
call mk_stlp stldbg sta rtsta %ARG1%
call mk_stlp stldbg sta rtdll %ARG1%
call mk_stlp stldbg dll rtdll %ARG1%
goto J_END

:J_MINGW
call mk_stlp rel sta rtdll %ARG1%
if /I "%SKIP_MODE%"=="1" goto J_END
call mk_stlp dbg sta rtdll %ARG1%
call mk_stlp rel dll rtdll %ARG1%
call mk_stlp dbg dll rtdll %ARG1%
call mk_stlp stldbg sta rtdll %ARG1%
call mk_stlp stldbg dll rtdll %ARG1%
goto J_END

:J_DMC
call mk_stlp rel sta rtsta %ARG1%
if /I "%SKIP_MODE%"=="1" goto J_END
call mk_stlp dbg sta rtsta lib ehtest %ARG1%
call mk_stlp rel dll rtsta lib %ARG1%
call mk_stlp dbg dll rtsta lib %ARG1%
goto J_END

:J_BCC
call mk_stlp rel sta rtsta %ARG1%
if /I "%SKIP_MODE%"=="1" goto J_END
call mk_stlp dbg sta rtsta %ARG1%
goto J_END

:J_END
endlocal
