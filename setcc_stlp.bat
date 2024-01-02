@echo off
rem コマンドラインコンパイラ環境切り替えバッチ.
rem 各自のコンパイラのインストール環境に合わせて、書き換えてください.
set INCLUDE= 
set LIB= 
rem set "DX9_DIR=C:\Program Files (x86)\Microsoft DirectX 9.0 SDK (December 2004)"

set "STLPORT_DIR=%~dp0"
set "STLPORT_TEST_EXE_DIR=%STLPORT_DIR%\bin\"
if "%cc_save_path%"=="" set "cc_save_path=%path%"
set "cc_base_path=%cc_save_path%"

set COMPILER=%1
set TargetArch=x86

shift
rem if "%COMPILER%"=="" 	set COMPILER=vc

if /i "%COMPILER%"=="vc11"   	goto L_VC11
if /i "%COMPILER%"=="vc11x64"	goto L_VC11x64
if /i "%COMPILER%"=="vc10"   	goto L_VC10
if /i "%COMPILER%"=="vc10x64"	goto L_VC10x64
if /i "%COMPILER%"=="vc9"   	goto L_VC9
if /i "%COMPILER%"=="vc9x64"   	goto L_VC9x64
if /i "%COMPILER%"=="vc8"   	goto L_VC8
if /i "%COMPILER%"=="vc8x64"   	goto L_VC8x64
if /i "%COMPILER%"=="vc71"   	goto L_VC71
if /i "%COMPILER%"=="mingw"	goto L_MINGW
if /i "%COMPILER%"=="mingw64"	goto L_MINGW64
if /i "%COMPILER%"=="tdm32"     goto L_TDM32
if /i "%COMPILER%"=="tdm64"     goto L_TDM64
if /i "%COMPILER%"=="clang"	goto L_CLANG
if /i "%COMPILER%"=="dmc" 	goto L_DMC
if /i "%COMPILER%"=="dm" 	goto L_DMC
if /i "%COMPILER%"=="ow"   	goto L_OW
if /i "%COMPILER%"=="watcom"   	goto L_OW
if /i "%COMPILER%"=="bcc"       goto L_BCC551
if /i "%COMPILER%"=="borland"   goto L_BCC551

echo setcc_stlp COMPILER
echo   COMPILER:
echo       vc11,vc10,vc9,vc8,vc71
echo       vc11x64,vc10x64,vc9x64,vc8x64
echo       mingw,mingw64( tdm32, tdm64 )
echo       dm,ow,bcc
goto :L_END

:L_VC11
	set COMPILER=vc11
	set "PATH=%cc_base_path%"
	call "%VS110COMNTOOLS%vsvars32.bat"
	goto L_VC_CMN

:L_VC11x64
	set COMPILER=vc11
	set TargetArch=x64
	set "PATH=%cc_base_path%"
	call "%VS110COMNTOOLS%..\..\vc\bin\amd64\vcvars64.bat"
	goto L_VC_CMN64

:L_VC10
	set COMPILER=vc10
	set "PATH=%cc_base_path%"
	call "%VS100COMNTOOLS%vsvars32.bat"
	goto L_VC_CMN

:L_VC10x64
	set COMPILER=vc10
	set TargetArch=x64
	set "PATH=%cc_base_path%"
	call "%VS100COMNTOOLS%..\..\vc\bin\amd64\vcvarsamd64.bat"
	goto L_VC_CMN64

:L_VC9
	set COMPILER=vc9
	set "PATH=%cc_base_path%"
	call "%VS90COMNTOOLS%vsvars32.bat"
	goto L_VC_CMN

:L_VC9x64
	set COMPILER=vc9
	set TargetArch=x64
	set "PATH=%cc_base_path%"
	call "%VS90COMNTOOLS%..\..\vc\bin\amd64\vcvarsamd64.bat"
	goto L_VC_CMN64

:L_VC8
	set COMPILER=vc8
	set "PATH=%cc_base_path%"
	call "%VS80COMNTOOLS%vsvars32.bat"
	goto L_VC_CMN

:L_VC8x64
	set COMPILER=vc8
	set TargetArch=x64
	set "PATH=%cc_base_path%"
	call "%VS80COMNTOOLS%..\..\vc\bin\amd64\vcvarsamd64.bat"
	goto L_VC_CMN64

:L_VC71
	set COMPILER=vc71
	set "PATH=%cc_base_path%"
	set "INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\SDK\v1.1\include\"
	set "LIB=C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\SDK\v1.1\Lib\"
	call "%VS71COMNTOOLS%vsvars32.bat"
	goto L_VC_CMN

:L_VC_CMN
	rem set "INCLUDE=%DX9_DIR%\include;%INCLUDE%"
	rem set "LIB=%DX9_DIR%\lib\x86;%LIB%"
	goto :L_END

:L_VC_CMN64
	rem set "INCLUDE=%DX9_DIR%\include;%INCLUDE%"
	rem set "LIB=%DX9_DIR%\lib\x64;%LIB%"
	goto :L_END

:L_MINGW
:L_TDM32
	set COMPILER=mingw
	set "MINGW_DIR=c:\tools\MinGW32_471tdm"
	set "PATH=%MINGW_DIR%\bin;%cc_base_path%"
	goto :L_END

:L_MINGW64
:L_TDM64
	set COMPILER=mingw
	set TargetArch=x64
	set "MINGW_DIR=c:\tools\MinGW64_471tdm"
	set "PATH=%MINGW_DIR%\bin;%cc_base_path%"
	goto :L_END

:L_CLANG
	set COMPILER=clang
	set "MINGW_DIR=c:\MinGW"
	set "MSYS_ROOT=%MINGW_DIR%\msys\1.0"
	set "PATH=%MINGW_DIR%\bin;%MINGW_DIR%\bin;%cc_base_path%"
	goto :L_END

:L_DMC
	set COMPILER=dmc
	set "DMC_DIR=c:\dm"
	set "PATH=%DMC_DIR%\bin;%cc_base_path%"
	rem set "DMD2_DIR=c:\dmd2"
	rem set "PATH=%DMC_DIR%\bin;%DMD2_DIR%\windows\bin;%cc_base_path%"
	goto :L_END

:L_OW
	set COMPILER=ow
	set "WATCOM=C:\WATCOM"
	set "PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%cc_base_path%"
	set "EDPATH=%WATCOM%\EDDAT"
	set "INCLUDE=%WATCOM%\H;%WATCOM%\H\NT;%INCLUDE%"
	set "FINCLUDE=%WATCOM%\SRC\FORTRAN"
	goto :L_END

:L_BCC551
	set COMPILER=bcc
	set "BORLANDC_DIR=c:\tools\borland\bcc55"
	set "PATH=%BORLANDC_DIR%\bin;%cc_base_path%"
	set "include=%BORLANDC_DIR%\include;%BORLANDC_DIR%\include\Rw;%BORLANDC_DIR%\include\psdk"
	goto :L_END

:L_END
	set "PATH=%STLPORT_DIR%\bin\%COMPILER%_%TargetArch%;%STLPORT_DIR%\bin;%PATH%"
