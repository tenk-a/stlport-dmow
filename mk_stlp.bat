@echo off
rem make stlport batch. by tenka@6809.net
setlocal EnableDelayedExpansion
set ORIG_INCLUDE=%INCLUDE%

if "%1"=="" goto L_HELP

set LIBNAME=stlport
set VER_MAJOR=5
set VER_MINOR=2

set "PROJ_PATH=%~dp0"
set STLPORT_DIR=..\..\..\
set STLPORT_INC_DIR=%STLPORT_DIR%stlport\
set LIBSRC_DIR=%STLPORT_DIR%src\
set OBJ_DIR=obj
set LIB_DIR=lib
set EXE_DIR=bin
set RC_SRCS=stlport

set LIBEXT=lib
set DLLEXT=dll
set MANIFESTEXT=manifest
set OBJEXT=obj

set LIB_NAME_PREFIX=
set DBG_SUFFIX=d

set Proj=rel
set LibType=sta
set CrtType=
rem set WINVER=0x0501
set WINVER=0x0600
set NoRtti=
set NoExcept=
set NoMT=
set NoIos=
set UseBoost=
set BoostDir=
set Verbose=
set OptStr=
set TgtLib=
set TgtEhTest=
set TgtUnitTest=
set TgtCmplTest=
set TgtKkkkTest=
set O_LNK_DLL2=
set DivCompile=0
set DirSep=\
set O_LNK_MANIFEST1=
set O_LNK_MANIFEST2=
set CmdLn=
set ERR=
if "%TargetArch%"=="" set TargetArch=x86

:ARG_LOOP
  if "%1"=="" goto ARG_LOOP_EXIT

  if /I "%1"=="help"    goto L_HELP
  if /I "%1"=="-help"   goto L_HELP
  if /I "%1"=="--help"  goto L_HELP
  if /I "%1"=="clean"   goto L_CLEAN

  if /I "%1"=="vc11"      set Compiler=vc11
  if /I "%1"=="vc10"      set Compiler=vc10
  if /I "%1"=="vc9"       set Compiler=vc9
  if /I "%1"=="vc8"       set Compiler=vc8
  if /I "%1"=="vc71"      set Compiler=vc71
  if /I "%1"=="mingw"    (set Compiler=mingw
                          set LIB_NAME_PREFIX=lib
                          set DBG_SUFFIX=g)
  if /I "%1"=="clang"    (set Compiler=clang
                          set LIB_NAME_PREFIX=lib
                          set DBG_SUFFIX=g)
  if /I "%1"=="dmc"       set Compiler=dmc
  if /I "%1"=="bcc"       set Compiler=bcc
  if /I "%1"=="watcom"    set Compiler=watcom

  if /I "%1"=="x86"       set TargetArch=x86
  if /I "%1"=="x64"       set TargetArch=x64

  if /I "%1"=="release"   set Proj=rel
  if /I "%1"=="rel"       set Proj=rel
  if /I "%1"=="debug"     set Proj=dbg
  if /I "%1"=="dbg"       set Proj=dbg
  if /I "%1"=="stldbg"    set Proj=stldbg

  if /I "%1"=="static"    set LibType=sta
  if /I "%1"=="shared"    set LibType=dll
  if /I "%1"=="dll"       set LibType=dll

  if /I "%1"=="rtsta"    set CrtType=rtsta
  if /I "%1"=="rtstatic" set CrtType=rtsta
  if /I "%1"=="rtdll"    set CrtType=rtdll

  if /I "%1"=="--no-rtti" (set NoRtti=1
                           set NoExcept=1
                           set OptStr=%OptStr% %1)
  if /I "%1"=="--no-mt"   (set NoMT=1
                           set OptStr=%OptStr% %1)
  if /I "%1"=="--no-thread" (set NoMT=1
                           set OptStr=%OptStr% --no-mt)
  if /I "%1"=="--boost"   (set UseBoost=1
                           set BoostDir=%2
                           set OptStr=%OptStr% %1)
                          )
  if /I "%1"=="--no-except" (set NoExcept=1
                             set OptStr=%OptStr% %1)
                            )
  if /I "%1"=="--no-ios"    (set NoIos=1
                             set OptStr=%OptStr% %1)
                            )
  if /I "%1"=="--verbose"  set Verbose=1

  if /I "%1"=="all"        (set TgtLib=1
                            set TgtEhTest=1
                            set TgtUnitTest=1)
  if /I "%1"=="lib"          set TgtLib=1
  if /I "%1"=="library"      set TgtLib=1
  if /I "%1"=="ehtest"       set TgtEhTest=1
  if /I "%1"=="unittest"     set TgtUnitTest=1
  if /I "%1"=="compilertest" set TgtCmplTest=1
  if /I "%1"=="kkkktest"     set TgtKkkkTest=1
  if /I "%1"=="kkkk"         set TgtKkkkTest=1
  shift
goto ARG_LOOP
:ARG_LOOP_EXIT

if "%Compiler%"=="" goto L_HELP

set LIB_NAME_BASE=%LIB_NAME_PREFIX%%LIBNAME%
if "%Proj%"=="dbg" (
  set LIB_NAME_BASE=%LIB_NAME_BASE%%DBG_SUFFIX%
)
if "%Proj%"=="stldbg" (
  set LIB_NAME_BASE=%LIB_NAME_BASE%stl%DBG_SUFFIX%
)

set LIB_NAME_SUFFIX=
if /I "%LibType%"=="dll" (
  set LIB_NAME_SUFFIX=.%VER_MAJOR%.%VER_MINOR%
  if not "%LIB_MOTIF%"=="" set LIB_NAME_SUFFIX=.%LIB_MOTIF%.%VAR_MAJOR%.%VAR_MINOR%
) else (
  set LIB_NAME_SUFFIX=
  if not "%LIB_MOTIF%"=="" set LIB_NAME_SUFFIX=.%LIB_MOTIF%
)

if "%Compiler%"=="dmc"         set CrtType=rtsta
if "%Compiler%"=="bcc"         set CrtType=rtsta

if "%CrtType%"=="" (
  if /I "%Compiler%"=="mingw"  set CrtType=rtdll
  if /I "%Compiler%"=="clang"  set CrtType=rtdll
  if /I "%LibType%"=="dll"     set CrtType=rtdll
)
if /I "%CrtType%"==""          set CrtType=rtsta

set LibCrtType=
if /I "%LibType%%CrtType%"=="staRtSta" (
  set LibCrtType=_static
)
if /I "%LibType%%CrtType%"=="staRtDll" (
  set LibCrtType=_statix
)
if /I "%LibType%%CrtType%"=="dllRtSta" (
  set LibCrtType=_x
)
set O_CC_LibType=
set LIB_NAME_BASE=%LIB_NAME_BASE%%LibCrtType%

set NAME_POSTFIX=
if "%NoMT%"=="1" (
    set NAME_POSTFIX=%NAME_POSTFIX%_nmt
)
if "%NoRtti%"=="1" (
    set NAME_POSTFIX=%NAME_POSTFIX%_nrtti
    set NoExcept=1
)
if "%NoExcept%"=="1" (
    set NAME_POSTFIX=%NAME_POSTFIX%_nexcept
)

if "%NoIos%"=="1" (
    set NAME_POSTFIX=%NAME_POSTFIX%_nios
)
if "%UseBoost%"=="1" (
    set NAME_POSTFIX=%NAME_POSTFIX%_boost
)
set LIB_NAME_BASE=%LIB_NAME_BASE%%NAME_POSTFIX%

if "%TgtLib%"=="" if "%TgtEhTest%"=="" if "%TgtUnitTest%"=="" if "%TgtCmplTest%"=="" if "%TgtKkkkTest%"=="" (
  set TgtLib=1
  set TgtEhTest=1
  set TgtUnitTest=1
)

if "%Compiler%"=="vc11"   goto L_VC_GE1400
if "%Compiler%"=="vc10"   goto L_VC_GE1400
if "%Compiler%"=="vc9"    goto L_VC_GE1400
if "%Compiler%"=="vc8"    goto L_VC_GE1400
if "%Compiler%"=="vc71"   goto L_VC_LT1400
if "%Compiler%"=="mingw"  goto L_MINGW
if "%Compiler%"=="clang"  goto L_CLANG
if "%Compiler%"=="dmc"    goto L_DMC
if "%Compiler%"=="ow"     goto L_OW
if "%Compiler%"=="bcc"    goto L_BORLANDC

goto L_HELP


rem Microsoft Visual C++
:L_VC_LT1400
  set O_CC_LibType=-MT
  if "%NoMT%"=="1" set O_CC_LibType=-ML
  goto L_VC

:L_VC_GE1400
  set O_CC_LibType=-MT
  goto L_VC

:L_VC
  set CC=cl
  set CXX=cl -TP
  set RC=rc
  set LNK=link
  set AR=lib
  set MT=mt
  set O_CC=-W4 -D_CRT_SECURE_NO_WARNINGS -DWINVER=%WINVER% -DWIN32 -D_WINDOWS -I%STLPORT_INC_DIR%
  set O_CC_CO=-c
  set O_CC_OUT=-Fo
  set O_CC_EXE_OUT=-Fe
  set O_CC_LIB=-link 
  set O_CC_DLL=
  set O_RC=
  set O_LNK=/fixed:no /nologo  /version:%VER_MAJOR%.%VER_MINOR% /pdb:%LIB_NAME_BASE%.pdb
  set O_LNK_DLL=%O_LNK%
  set O_LNK_DLL_OUT=/out:
  set O_LNK_OUT=/out:
  set O_AR=/nologo /MACHINE:%TargetArch%
  set O_AR_OUT=/out:
  set O_MT=

  if /I "%LibType%"=="dll" (
    set O_LNK_DLL=%O_LNK_DLL% /DLL
    set O_CC=%O_CC% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
  ) else (
    set O_CC=%O_CC% -D_STLP_USE_STATIC_LIB
  )
  if /I "%CrtType%"=="rtdll" (
    set O_CC_LibType=-D_STLP_RUNTIME_DLL -MD
    set O_LNK_MANIFEST1=/MANIFEST /MANIFESTFILE:
    set O_LNK_MANIFEST2=.intermediate.manifest /MANIFESTUAC:"level='asInvoker' uiAccess='false'"
  ) else (
    if /I "%LibType%"=="rtdll" (
      set O_CC_LibType=-LD
    ) else (
      rem set O_CC_LibType=-MT
    )
  )
  if /I not "%Proj%"=="rel" (
    set O_CC_LibType=%O_CC_LibType%d
  )
  set O_CC=%O_CC% %O_CC_LibType%
  if "%NoMT%"=="1" (
    set O_CC=%O_CC% -D_STLP_NO_THREADS
  )
  if "%UseBoost%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_BOOST_SUPPORT -I%BoostDir%
  )
  if "%NoRtti%"=="1" (
    set O_CC=%O_CC% -GR-
  ) else (
    set O_CC=%O_CC% -GR -EHsc
  )

  if /I "%Proj%"=="rel" (
    set O_CC=%O_CC% -Ox -DNDEBUG
    set O_LNK=%O_LNK% /incremental:no
  )
  if /I "%Proj%"=="dbg" (
    set O_CC=%O_CC% -ZI -Gm -RTC1 -D_DEBUG
    set O_RC=%O_RC% /DBUILD=d
    set O_LNK=%O_LNK% /debug /INCRIMENTAL
  )
  if /I "%Proj%"=="stldbg" (
    set O_CC=%O_CC% -ZI -Gm -RTC1 -D_DEBUG -D_STLP_DEBUG
    set O_RC=%O_RC% /DBUILD=stld
    set O_LNK=%O_LNK% /debug
  )
  set O_RC=%O_RC% /D "BUILD_INFOS=%O_CC%"
  set ERN=1
  goto L_COMPILE


rem MinGW32
:L_CLANG
  set CC=clang
  set CXX=clang++
  set LNK=clang++ -shared
  goto L_MINGW_CLANG
:L_MINGW
  set CC=gcc
  set CXX=g++
  set LNK=g++ -shared
:L_MINGW_CLANG
  set LIB_NAME_BASE=lib%LIB_NAME_BASE%
  set DirSep=/
  set STLPORT_INC_DIR=%STLPORT_INC_DIR:\=/%
  set LIBEXT=a
  set DLLEXT=dll
  set OBJEXT=o
  set AR=ar
  set RC=windres
  set O_CC=-Wall -Wsign-promo -Wcast-qual -fexceptions -DWINVER=%WINVER% -DWIN32 -D_WINDOWS --include-directory=%STLPORT_INC_DIR%
  set O_CC_CO=-c
  set O_CC_OUT=-o 
  set O_CC_EXE_OUT=-o 
  rem set O_CC_LIB=-l 
  set O_LNK=-nodefaultlibs
  set O_LNK_DLL=-nodefaultlibs -Wl,--enable-auto-image-base,--add-stdcall-alias,--out-implib=
  set O_LNK_DLL2=
  set O_LNK_DLL_OUT=-o 
  set O_LNK_OUT=-o 
  set O_AR=-rs
  set O_AR_OUT= 
  set O_RC=--include-dir=%STLPORT_INC_DIR% --output-format coff -DCOMP=gcc
  set O_LNK_TMP1=-lgcc_s
  if /I "%TargetArch%"=="x64" (
    set O_LNK_TMP2=-lmingw32
  )
  if /I "%LibType%"=="dll" (
    set O_CC=%O_CC% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
    set O_LNK_DLL=%O_LNK_DLL%%LIB_NAME_BASE%%LIB_NAME_SUFFIX%.%LIBEXT%
    set O_LNK_TMP1=-lgcc
  ) else (
    set O_CC=%O_CC% -D_STLP_USE_STATIC_LIB
    set O_LNK_DLL=%O_LNK_DLL%%LIB_NAME_BASE%.%LIBEXT%
  )
  set O_LNK_DLL2=-lsupc++ %O_LNK_TMP1% -lmingw32 -lmingwex %O_LNK_TMP2% -lmsvcrt -lm -lmoldname -lkernel32
  if /I "%CrtType%"=="rtdll" (
    set O_CC=%O_CC% -D_STLP_RUNTIME_DLL
  )
  if "%NoMT%"=="1" (
    set O_CC=%O_CC% -D_STLP_NO_THREADS
  ) else (
    set O_CC=%O_CC% -mthreads
  )
  if "%UseBoost%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_BOOST_SUPPORT --include-directory=%BoostDir%
  )
  if "%NoRtti%"=="1" (
    set O_CC=%O_CC% -fno-rtti -D_STLP_NO_RTTI
  ) else (
    rem set O_CC=%O_CC%
  )

  if "%Proj%"=="rel" (
    set O_CC=%O_CC% -O2 -DNDEBUG
    set O_RC=%O_RC% -DBUILD_INFOS=-O2
  )
  if "%Proj%"=="dbg" (
    set O_CC=%O_CC% -g -D_DEBUG
    set O_RC=%O_RC% -DBUILD=g -DBUILD_INFOS=-g
  )
  if "%Proj%"=="stldbg" (
    set O_CC=%O_CC% -g -D_DEBUG -D_STLP_DEBUG
    set O_RC=%O_RC% -DBUILD=stlg -DBUILD_INFOS="-g -D_STLP_DEBUG"
  )
  set ERN=2
  goto L_COMPILE


rem Digitalmars C++ v.8.5.6
:L_DMC
  set DivCompile=1
  set CrtType=rtsta
  set LIB_NAME_SUFFIX=%LIB_NAME_SUFFIX:.=_%
  set CC=dmc
  set CXX=dmc -cpp
  set RC=rc
  set LNK=dmc
  set AR=lib
  set O_CC= -6 -mn -HP99 -w -f -Aa -Ab -p -DWINVER=%WINVER% -DWIN32 -D_WINDOWS -I%STLPORT_INC_DIR%
  set O_CC_CO=-c
  set O_CC_OUT=-o
  set O_CC_EXE_OUT=-e 
  set O_CC_LIB=
  set O_RC=
  rem set O_LNK=-6 -mn -HP99 -w -f -Aa -Ab -p -L%PROJ_PATH%bin\for_dmc\link.exe
  set O_LNK=-6 -mn -HP99 -w -f -Aa -Ab -p
  set O_LNK_DLL=%O_LNK%
  set O_LNK_DLL_OUT=-o
  set O_LNK_OUT=-e 
  set O_AR=-n -c
  set O_AR_OUT=
  if "%LibType%"=="dll" (
    set O_LNK_DLL=%O_LNK_DLL% -WD -L/IMPL
    set O_LNK_DLL2=kernel32.lib user32.lib
    set O_CC=%O_CC% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
  ) else (
    set O_LNK=%O_LNK% -WA
    set O_CC=%O_CC% -D_STLP_USE_STATIC_LIB
  )
  if /I "%CrtType%"=="rtdll" (
    set O_CC=%O_CC% -D_STLP_RUNTIME_DLL -ND
  )
  if "%NoMT%"=="1" (
    set O_CC=%O_CC% -D_STLP_NO_THREADS
  ) else (
    set O_CC=%O_CC% -D_MT
  )
  if "%UseBoost%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_BOOST_SUPPORT -I%BoostDir%
  )
  if "%NoRtti%"=="1" (
    set O_CC=%O_CC%  -D_STLP_NO_RTTI
    set NoExcept=1
  ) else (
    rem set O_CC=%O_CC% -D_CPPRTTI -Ar
    set O_CC=%O_CC% -Ar
  )
  if "%NoExcept%"=="1" (
    set O_CC=%O_CC% -D_STLP_DONT_USE_EXCEPTIONS
  ) else (
    set O_CC=%O_CC% -Ae
  )

  if "%Proj%"=="rel" (
    rem set O_CC=%O_CC% -otxan -s -Nc -DNDEBUG
    rem set O_CC=%O_CC% -ox -Nc -DNDEBUG
    rem set O_CC=%O_CC% -obmilr -s -Nc -DNDEBUG
    rem set O_CC=%O_CC% -o -s -Nc -DNDEBUG
    set O_CC=%O_CC% -o+all -s -Nc -DNDEBUG
    set O_LNK=%O_LNK% -DNDEBUG
    set O_AR=%O_AR% -p512
  )
  if "%Proj%"=="dbg" (
    set O_AR=%O_AR% -p512
    set O_RC=%O_RC% /DBUILD=d
    rem set O_CC=%O_CC%   -s -S -Nc -C -o+none -D_DEBUG
    rem set O_LNK=%O_LNK% -s -S -Nc -C -o+none -D_DEBUG
    set O_CC=%O_CC%   -g -s -S -Nc -C -o+none -D_DEBUG
    set O_LNK=%O_LNK% -g -s -S -Nc -C -o+none -D_DEBUG
  )
  if "%Proj%"=="stldbg" (
    set O_AR=%O_AR% -p512
    set O_RC=%O_RC% /DBUILD=stld
    rem set O_CC=%O_CC%   -s -S -Nc -C -o+none -D_DEBUG -D_STLP_DEBUG
    rem set O_LNK=%O_LNK% -s -S -Nc -C -o+none -D_DEBUG -D_STLP_DEBUG
    set O_CC=%O_CC%   -g -s -S -Nc -C -o+none -D_DEBUG -D_STLP_DEBUG
    set O_LNK=%O_LNK% -g -s -S -Nc -C -o+none -D_DEBUG -D_STLP_DEBUG
  )
  set O_RC=%O_RC% /D "BUILD_INFOS=%O_CC%"
  set ERN=1
  goto L_COMPILE


rem Open Watcom C++ 1.9
:L_OW
  set INCLUDE=%STLPORT_INC_DIR%;%INCLUDE%
  set CC=wcl386
  set CXX=wcl386 -cc++
  set RC=rc
  set LNK=wcl386
  set AR=lib
  rem set O_CC=-6r -fpi87 -fp6 -DWINVER=%WINVER% -DWIN32 -D_WINDOWS -I=%STLPORT_INC_DIR% -D__IALIAS_H_INCLUDED
  set O_CC=-6r -fpi87 -fp6 -DWINVER=%WINVER% -DWIN32 -D_WINDOWS -I=%STLPORT_INC_DIR%
  set O_CC_CO=-c
  set O_CC_OUT=-fo
  set O_CC_EXE_OUT=-fe=
  set O_CC_LIB=
  set O_RC=
  set O_LNK=-bw -k400000 -bt=nt -zq
  set O_LNK_OUT=-l=nt -fe=
  set O_LNK_DLL=-bd %O_LNK%
  set O_LNK_DLL2=-"option implib"
  set O_LNK_DLL_OUT=-l=nt_dll -fe=
  set O_LNK_LIB_OUT=-l=
  set O_AR=-nologo
  set O_AR_OUT=-out:

  if /I "%LibType%"=="dll" (
    set O_CC=%O_CC% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
  ) else (
    set O_CC=%O_CC% -D_STLP_USE_STATIC_LIB
    set CPP_SRCS=s_watcom_new_handler %CPP_SRCS% 
    set O_LNK=%O_LNK%
  )
  if /I "%CrtType%"=="rtdll" (
    set O_CC=%O_CC% -br -D_STLP_RUNTIME_DLL
  )
  if "%NoMT%"=="1" (
    set O_CC=%O_CC% -D_STLP_NO_THREADS
  ) else (
    set O_CC=%O_CC% -bm -D_MT
  )
  if "%NoRtti%"=="1" (
    set CXX=%CXX% -D_STLP_NO_RTTI
    set NoExcept=1
  ) else (
    set O_CC=%O_CC% -D_CPPRTTI
  )
  if "%NoExcept%"=="1" (
    set O_CC=%O_CC% -D_STLP_DONT_USE_EXCEPTIONS
    set CXX=%CXX% -xr -ze
  ) else (
    set CXX=%CXX% -xr -ze -xs
  )
  
  if "%UseBoost%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_BOOST_SUPPORT -I=%BoostDir%
    rem set O_LNK=%O_LNK% -dll
  )
  if "%Proj%"=="rel" (
    rem -oe -ot hang ?
    rem set O_CC=%O_CC% -ox -DNDEBUG
    rem set O_CC=%O_CC% -otxan  -s -DNDEBUG
    set O_CC=%O_CC% -obmilr -s -DNDEBUG
    set O_LNK=%O_LNK% -DNDEBUG
  )
  if "%Proj%"=="dbg" (
    set O_RC=%O_RC% /DBUILD=d
    set O_CC=%O_CC% -d2 -db -od -D_DEBUG
    set O_LNK=%O_LNK% -d2 -db -od -D_DEBUG
  )
  if "%Proj%"=="stldbg" (
    set O_RC=%O_RC% /DBUILD=stld
    set O_CC=%O_CC% -d2 -db -od -D_DEBUG -D_STLP_DEBUG
    set O_LNK=%O_LNK% -d2 -db -od -D_DEBUG -D_STLP_DEBUG
    set O_AR=%O_AR%
  )
  set O_RC=%O_RC% /D "BUILD_INFOS=%O_CC%"
  set ERN=1
  goto L_COMPILE


rem Borland C++ v5.5.1
:L_BORLANDC
  set DivCompile=2
  set LIB_NAME_SUFFIX=%LIB_NAME_SUFFIX:.=_%
  set CrtType=rtsta
  set CC=bcc32
  set CXX=bcc32 -P
  set RC=brc32
  set LNK=bcc32
  set AR=tlib
  set O_CC=-w -w-8008 -w-8066 -g255 -I%STLPORT_INC_DIR%
  set O_CC_CO=-c
  set O_CC_OUT=-o
  set O_CC_EXE_OUT=-e
  set O_CC_LIB=-L
  set O_RC=
  set O_LNK=
  set O_LNK_DLL=
  set O_LNK_DLL_OUT=-e
  set O_LNK_OUT=-e
  set O_AR=
  set O_AR_OUT=
  set OldMsLib=tlib

  if "%LibType%"=="dll" (
    set O_LNK_DLL=%O_LNK_DLL% -tWD -lGi
    set O_CC=%O_CC% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
  ) else (
    set O_LNK=%O_LNK%
    set O_CC=%O_CC% -D_STLP_USE_STATIC_LIB
  )
  if /I "%CrtType%"=="rtdll" (
    set O_CC=%O_CC% -D_STLP_RUNTIME_DLL
  )
  if "%NoMT%"=="1" (
    set O_CC=%O_CC% -D_NOTHREADS
  ) else (
    set O_CC=%O_CC% -D__MT__
  )
  if "%UseBoost%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_BOOST_SUPPORT -I%BoostDir%
  )
  if "%NoRtti%"=="1" (
    set O_CC=%O_CC%  -D_STLP_NO_RTTI -RT-
    NoExcept=1
  ) else (
    set O_CC=%O_CC% -D_CPPRTTI -RT
  )
  if "%NoExcept%"=="1" (
    set O_CC=%O_CC% -D_STLP_DONT_USE_EXCEPTIONS
  )

  if /I "%Proj%"=="rel" (
    set O_CC=%O_CC% -O2 -Ox -d -DNDEBUG
  )
  if /I "%Proj%"=="dbg" (
    set O_CC=%O_CC%   -v -D_DEBUG
    set O_LNK=%O_LNK% -v -D_DEBUG
  )
  if /I "%Proj%"=="stldbg" (
    set O_CC=%O_CC%   -v -D_DEBUG -D_STLP_DEBUG
    set O_LNK=%O_LNK% -v -D_DEBUG -D_STLP_DEBUG
  )
  set ERN=1
  goto L_COMPILE


rem COMMON.
:L_COMPILE
  set BuildCompDir=%Compiler%_%TargetArch%
  if "%DirSep%"=="/" (
    set LIBSRC_DIR=%LIBSRC_DIR:\=/%
  )
  if "%NoIos%"=="1" (
    set O_CC=%O_CC% -D_STLP_USE_NO_IOSTREAMS
  )
  if "%Verbose%"=="1" (
    set O_CC=%O_CC% -D_STLP_VERBOSE
  )

  set LIB_NAME=%LIB_NAME_BASE%.%LIBEXT%
  rem set DLL_NAME=%LIB_NAME_BASE%.%DLLEXT%
  if "%LibType%"=="dll" (
    set DLL_NAME=%LIB_NAME_BASE%%LIB_NAME_SUFFIX%.%DLLEXT%
    set LIB_NAME=%LIB_NAME_BASE%%LIB_NAME_SUFFIX%.%LIBEXT%
  )

  if not exist %LIB_DIR%                md %LIB_DIR%
  if not exist %LIB_DIR%\%BuildCompDir% md %LIB_DIR%\%BuildCompDir%
  set TGT_LIB_DIR=%STLPORT_DIR%%LIB_DIR%\%BuildCompDir%

  if not exist %EXE_DIR%                md %EXE_DIR%
  if not exist %EXE_DIR%\%BuildCompDir% md %EXE_DIR%\%BuildCompDir%
  set TGT_EXE_DIR=%STLPORT_DIR%%EXE_DIR%\%BuildCompDir%

  if not exist %OBJ_DIR%                md %OBJ_DIR%
  if not exist %OBJ_DIR%\%BuildCompDir% md %OBJ_DIR%\%BuildCompDir%

  echo [%Compiler%] %TargetArch%  %Proj% %LibType% %CrtType% %OptStr%

goto L_COMPILE_LIB


rem Make Library.
:L_COMPILE_LIB
  if "%TgtLib%"=="" goto L_COMPILE_UNITTEST

  rem set BuildProjDir=%LIB_NAME_BASE%
  set BuildProjDir=lib_%Proj%_%LibType%_%CrtType%%NAME_POSTFIX%
  set ERR_FILE=err_lib.txt
  if not exist %OBJ_DIR%\%BuildCompDir%\%BuildProjDir% md %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  pushd %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  rem set MANIFEST_NAME=%LIB_NAME_BASE%.%MANIFESTEXT%

  rem for /f %%I in ('dir /b src\*.cpp') do set CPP_SRCS=!CPP_SRCS! %%~nI
  rem set C_SRCS=
  rem for /f %%I in ('dir /b src\*.c') do set C_SRCS=!C_SRCS! %%~nI

  set FIRST_DLL_SRC=dll_main
  set CPP_STATIC_SRCS1=s_signal_compile_compatibility s_allocator_voidp s_alloc_proxy_voidpp_voidp s_alloc_porxy_size_t_voidp s_alloc_proxy_voidppp_voidpp s_limg_bool s_exception s_debug s_debug_alloc_malloc s_debug_alloc_new s_debug_alloc_node s_vector_voidp s_list_global_bool s_list_voidp s_slist_voidp s_deque_voidp s_rb_global_bool s_sl_global_bool s_stl_prime_bool s_rope s_hashtable_bucket_types_export
  set CPP_STATIC_SRCS2=s_locale_impl_facets_container
  set CPP_SRCS1=allocators string bitset collate complex complex_io complex_trig ctype codecvt
  set CPP_SRCS2=locale locale_catalog locale_impl facets_byname messages monetary numpunct num_get num_get_float num_put num_put_float time_facets ios iostream istream fstream ostream sstream stdio_streambuf strstream
  set C_SRCS=%C_SRCS% cxa c_locale 

  if "%NoIos%"=="1" (
    set CPP_STATIC_SRCS=%CPP_STATIC_SRCS% %CPP_STATIC_SRCS1%
    set CPP_SRCS=%CPP_SRCS% %CPP_SRCS1%
  ) else (
    set CPP_STATIC_SRCS=%CPP_STATIC_SRCS% %CPP_STATIC_SRCS1% %CPP_STATIC_SRCS2%
    set CPP_SRCS=%CPP_SRCS% %CPP_SRCS1% %CPP_SRCS2%
  )
  rem set O_CC_DLL=
  if "%LibType%"=="dll" (
    set CPP_SRCS=%CPP_SRCS% %CPP_STATIC_SRCS% %FIRST_DLL_SRC%
    rem set O_CC_DLL=%O_CC_DLL% -D_STLP_USE_DYNAMIC_LIB -D_STLP_DLL
    rem set O_CC_DLL=%O_CC_DLL% -D__BUILDING_STLPORT
  ) else (
    set CPP_SRCS=%CPP_SRCS% %CPP_STATIC_SRCS%
    rem set O_CC_DLL=%O_CC_DLL% -D_STLP_USE_STATIC_LIB
  )

  rem echo %CPP_SRCS%
  rem echo %C_SRCS%

  if exist "%LIB_NAME%"               del "%LIB_NAME%"
  if exist "%TGT_LIB_DIR%\%LIB_NAME%" del "%TGT_LIB_DIR%\%LIB_NAME%"
  if not "%DLL_NAME%"=="" (
    if exist "%DLL_NAME%"               del "%DLL_NAME%"
    if exist "%TGT_LIB_DIR%\%DLL_NAME%" del "%TGT_LIB_DIR%\%DLL_NAME%"
    if exist "%TGT_EXE_DIR%\%DLL_NAME%" del "%TGT_EXE_DIR%\%DLL_NAME%"
  )

  echo.
  echo MAKE %LIB_NAME%
  echo MAKE %LIB_NAME% >%ERR_FILE%
  echo [%Compiler%] %TargetArch%  %Proj% %LibType% %CrtType% %OptStr% >>%ERR_FILE%
  set C_CPP_SRCS=
  for %%I in (%CPP_SRCS%) do set C_CPP_SRCS=!C_CPP_SRCS! %LIBSRC_DIR%%%I.cpp
  for %%I in (%C_SRCS%) do set C_CPP_SRCS=!C_CPP_SRCS! %LIBSRC_DIR%%%I.c

  set CmdLn=%CXX% %O_CC_CO% -D__BUILDING_STLPORT %O_CC_DLL% %O_CC% %C_CPP_SRCS%
  if "%Verbose%"=="1" echo %CmdLn%
  %CmdLn% %ERN%>>%ERR_FILE%
  if not "%errorlevel%"=="0" if not "%errorlevel%"=="" (
      echo FAILED: %LIB_NAME% %DLL_NAME%
      set ERR=1
      goto L_LIB_END
  )
  echo.
  set OBJS=
  for %%I in (%CPP_SRCS% %C_SRCS%) do set OBJS=!OBJS! %%I.%OBJEXT%
  if "%LibType%"=="dll" goto L_COMPILE_DLL_0
  if not "%OldMsLib%"=="" goto L_COMPILE_LIB_1
:L_COMPILE_LIB_0
    set CmdLn=%AR% %O_AR% %O_AR_OUT%%LIB_NAME% %OBJS%
    goto L_COMPILE_LIB_E
:L_COMPILE_LIB_1
    set OBJS=+
    for %%I in (%CPP_SRCS% %C_SRCS%) do set OBJS=!OBJS!+%%I.%OBJEXT%
    set CmdLn=%AR% %LIB_NAME% %OBJS%, %LIB_NAME_BASE%.lst

:L_COMPILE_LIB_E
    if "%Verbose%"=="1" echo %CmdLn%
    %CmdLn% %ERN%>>%ERR_FILE%
    if exist %LIB_NAME% (
      copy %LIB_NAME% %TGT_LIB_DIR%\%LIB_NAME%
      echo DONE : %LIB_NAME%
    ) else (
      echo FAILED : %LIB_NAME%
      set ERR=1
    )
    goto L_LIB_END

:L_COMPILE_DLL_0:
    set CmdLn=%LNK% %O_LNK_DLL% %O_LNK_DLL_OUT%%DLL_NAME% %OBJS% %O_LNK_DLL2%
    if "%Verbose%"=="1" echo %CmdLn%
    %CmdLn% %ERN%>>%ERR_FILE%
    if exist "%DLL_NAME%" if exist "%LIB_NAME%" (
      copy "%LIB_NAME%" "%TGT_LIB_DIR%\%LIB_NAME%"
      copy "%DLL_NAME%" "%TGT_LIB_DIR%\%DLL_NAME%"
      copy "%DLL_NAME%" "%TGT_EXE_DIR%\%DLL_NAME%"
      echo DONE : %LIB_NAME% %DLL_NAME%
      goto L_LIB_END
    )
    echo FAILED : %LIB_NAME% %DLL_NAME%
    set ERR=1
:L_LIB_END
  popd
  if not "%ERR%"=="" goto L_ERR
  goto L_COMPILE_UNITTEST

rem Make test/unit
:L_COMPILE_UNITTEST
  if "%TgtUnitTest%"=="" goto L_COMPILE_EHTEST

  set EXE_NAME_BASE=unittest_%Proj%_%LibType%_%CrtType%%NAME_POSTFIX%
  set EXE_NAME=%EXE_NAME_BASE%.exe
  set ERR_FILE=err_unittest.txt
  set BuildProjDir=%EXE_NAME_BASE%
  set O_LNK_MANIFEST=
  if not "%O_LNK_MANIFEST1%"=="" (
    set O_LNK_MANIFEST=%O_LNK_MANIFEST1%%EXE_NAME_BASE%%O_LNK_MANIFEST2%
  )

  if not exist %OBJ_DIR%\%BuildCompDir%\%BuildProjDir% md %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%
  pushd %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  if exist %EXE_NAME%               del %EXE_NAME%
  if exist %TGT_EXE_DIR%\%EXE_NAME% del %TGT_EXE_DIR%\%EXE_NAME%

  echo.
  echo MAKE %EXE_NAME% 
  echo MAKE %EXE_NAME%  >%ERR_FILE%
  echo [%Compiler%] %TargetArch%  %Proj% %LibType% %CrtType% %OptStr% >>%ERR_FILE%

  set SRC_DIR=%STLPORT_DIR%test\unit\
  set SRC_CPPUNIT_DIR=%STLPORT_DIR%test\unit\cppunit\

  set CPPUNIT_SRC=test_main

  set C_SRCS=assert_header_test ctype_header_test c_limits_header_test c_locale_header_test errno_header_test float_header_test iso646_header_test math_header_test setjmp_header_test signal_header_test stdarg_header_test stddef_header_test stdio_header_test stdlib_header_test string_header_test time_header_test wchar_header_test wctype_header_test

  set CPP_HDR_SRCS=algorithm_header_test bitset_header_test cassert_header_test cctype_header_test cerrno_header_test cfloat_header_test ciso646_header_test climits_header_test clocale_header_test cmath_header_test complex_header_test csetjmp_header_test cwctype_header_test csignal_header_test cstdarg_header_test cstddef_header_test cstdio_header_test cstdlib_header_test cstring_header_test ctime_header_test cwchar_header_test deque_header_test exception_header_test fstream_header_test functional_header_test iomanip_header_test iosfwd_header_test iostream_header_test ios_header_test istream_header_test iterator_header_test limits_header_test list_header_test locale_header_test map_header_test memory_header_test new_header_test numeric_header_test ostream_header_test queue_header_test stack_header_test sstream_header_test stdexcept_header_test streambuf_header_test string_header_test typeinfo_header_test valarray_header_test vector_header_test stldbg_include resolve_name macro_checks

  set CPP_TEST_SRCS=limits_test uninitialized_test accum_test adj_test advance_test allocator_test bcompos_test bind_test binsert_test bnegate_test bound_test bsearch_test bvector_test cmath_test cstring_test copy_test count_test deque_test divides_test epilog_test equal_test fill_test find_test finsert_test foreach_test func_test generator_test greater_test heap_test includes_test innerprod_test inplace_test insert_test iter_test iota_test less_test lexcmp_test list_test logic_test map_test max_test memory_test merge_test mfunptr_test min_test mismatch_test modulus_test multiset_test neq_test nthelm_test pair_test partial_test partition_test perm_test plusminus_test ptr2_test queue_test rawriter_test reviter_test rm_cp_test rndshf_test rotate_test search_test setdiff_test setinter_test  setunion_test sort_test  swap_test stack_test set_test test_errno transform_test unary_test unique_test utility_header_test valarray_test vector_test config_test exception_test alg_test ptrspec_test times_test unordered_test mvctor_test mvctor_declaration_test mvctor_traits_test bitset_test string_test slist_test hash_test rope_test

  set CPP_IOS_SRCS=istmit_test ostmit_test ioiter_test fstream_test sstream_test strstream_header_test strstream_buffer_read_test strstream_test iostream_test
  set CPP_LOCALE_SRCS=codecvt_test ctype_facets_test collate_facets_test messages_facets_test money_facets_test num_facets_test num_put_get_test time_facets_test locale_test

  set CPP_BOOST_SRCS=boost_check reference_wrapper_test shared_ptr_test type_traits_test

  set CPP_SRCS=%CPP_HDR_SRCS% %CPP_TEST_SRCS% %CPP_IOS_SRCS% %CPP_LOCALE_SRCS% %CPP_BOOST_SRCS%
  set C_CPP_SRCS=
  set OBJS=
  if not "%DivCompile%"=="0" goto L_UNITTEST_CASE_1
:L_UNITTEST_CASE_0
    for %%I in (%CPPUNIT_SRC%) do set C_CPP_SRCS=!C_CPP_SRCS! %SRC_CPPUNIT_DIR%%%I.cpp
    for %%I in (%C_SRCS%)      do set C_CPP_SRCS=!C_CPP_SRCS! %SRC_DIR%%%I.c
    for %%I in (%CPP_SRCS%)    do set C_CPP_SRCS=!C_CPP_SRCS! %SRC_DIR%%%I.cpp
    set CmdLn=%CXX% %O_CC% %O_CC_EXE_OUT%%EXE_NAME% %C_CPP_SRCS% %O_CC_LIB%%TGT_LIB_DIR%\%LIB_NAME%
    if "%Verbose%"=="1" echo %CmdLn%
    %CmdLn% %ERN%>>%ERR_FILE%
    goto L_UNITTEST_CASE_END
:L_UNITTEST_CASE_1
    for %%I in (%CPPUNIT_SRC%) do call :L_COMPILE_ONE %SRC_CPPUNIT_DIR% %%I cpp
    for %%I in (%C_SRCS%)      do call :L_COMPILE_ONE %SRC_DIR%         %%I c
    for %%I in (%CPP_SRCS%)    do call :L_COMPILE_ONE %SRC_DIR%         %%I cpp
    if not "%ERR%"=="" goto L_UNITETEST_ERR
    for %%I in (%CPPUNIT_SRC%) do set OBJS=!OBJS! %%I.obj
    for %%I in (%C_SRCS%)      do set OBJS=!OBJS! %%I.obj
    for %%I in (%CPP_SRCS%)    do set OBJS=!OBJS! %%I.obj
    if /I "%Compiler%"=="bcc" (
      set CmdLn=%LNK% %O_LNK% %O_LNK_OUT%%EXE_NAME% %O_CC_LIB%%TGT_LIB_DIR% %OBJS% %LIB_NAME%
    ) else (
      set CmdLn=%LNK% %O_LNK% %O_LNK_OUT%%EXE_NAME% %OBJS% %O_CC_LIB%%TGT_LIB_DIR%\%LIB_NAME%
    )
    if "%Verbose%"=="1" echo %CmdLn%
    %CmdLn% %ERN%>>%ERR_FILE%
    rem goto L_UNITTEST_CASE_END

:L_UNITTEST_CASE_END
  if not "%errorlevel%"=="0" if not "%errorlevel%"=="" goto L_UNITETEST_ERR
  if not exist %EXE_NAME% goto L_UNITETEST_ERR

  copy %EXE_NAME% %TGT_EXE_DIR%\%EXE_NAME%
  if exist %EXE_NAME%.%MANIFESTEXT% (
    copy %EXE_NAME%.%MANIFESTEXT% %TGT_EXE_DIR%\%EXE_NAME%.%MANIFESTEXT%
  )
  echo DONE : %EXE_NAME%
  goto L_UNITETEST_END

:L_UNITETEST_ERR
    echo FAILED : %EXE_NAME%
    set ERR=1

:L_UNITETEST_END
  popd
  if not "%ERR%"=="" goto L_ERR
  goto L_COMPILE_EHTEST

rem Make test/eh
:L_COMPILE_EHTEST
  if "%TgtEhTest%"=="" goto L_COMPILERTEST

  set EXE_NAME_BASE=ehtest_%Proj%_%LibType%_%CrtType%%NAME_POSTFIX%
  set EXE_NAME=%EXE_NAME_BASE%.exe
  set ERR_FILE=err_ehtest.txt
  set BuildProjDir=%EXE_NAME_BASE%
  if not exist %OBJ_DIR%\%BuildCompDir%\%BuildProjDir% md %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  pushd %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  if exist %EXE_NAME%               del %EXE_NAME%
  if exist %TGT_EXE_DIR%\%EXE_NAME% del %TGT_EXE_DIR%\%EXE_NAME%

  echo.
  echo MAKE %EXE_NAME% 
  echo MAKE %EXE_NAME%  >%ERR_FILE%
  echo [%Compiler%] %TargetArch%  %Proj% %LibType% %CrtType% %OptStr% >>%ERR_FILE%

  set SRC_DIR=%STLPORT_DIR%test\eh\
  set CPP_SRCS=TestClass main nc_alloc random_number test_algo test_algobase test_list test_slist test_bit_vector test_vector test_deque test_set test_map test_hash_map test_hash_set test_rope test_string test_bitset test_valarray

  set CPP_SRCS2=
  for %%I in (%CPP_SRCS%) do set CPP_SRCS2=!CPP_SRCS2! %SRC_DIR%%%I.cpp

  if /I "%Compiler%"=="bcc" (
    set CmdLn=%CXX% %O_CC% %O_CC_EXE_OUT%%EXE_NAME% %O_CC_LIB%%TGT_LIB_DIR% %CPP_SRCS2% %LIB_NAME%
  ) else (
    set CmdLn=%CXX% %O_CC% %O_CC_EXE_OUT%%EXE_NAME% %CPP_SRCS2% %O_CC_LIB%%TGT_LIB_DIR%\%LIB_NAME%
  )


  if "%Verbose%"=="1" echo %CmdLn%
  %CmdLn% %ERN%>>%ERR_FILE%

  if exist %EXE_NAME% (
    copy %EXE_NAME% %TGT_EXE_DIR%\%EXE_NAME%
    echo DONE : %EXE_NAME%
  ) else (
    echo FAILED : %EXE_NAME%
    set ERR=1
    goto L_END
  )

  popd
  rem if not "%ERR%"=="" goto L_ERR
  goto L_COMPILERTEST

:L_COMPILE_ONE
  echo %1%2.%3 %ERN%>>%ERR_FILE%
  if "%Verbose%"=="1" echo %CXX% %O_CC_CO% %O_CC% %O_CC_OUT%%2.obj %1%2.%3
  %CXX% %O_CC_CO% %O_CC% %O_CC_OUT%%2.obj %1%2.%3 %ERN%>>%ERR_FILE%
  if not "%errorlevel%"=="0" if not "%errorlevel%"=="" (
    echo %2.%3 : failed.
    set ERR=1
  )
  exit /b 0

rem test/compier
:L_COMPILERTEST
  if "%TgtCmplTest%"=="" goto L_KKKK

  set BuildProjDir=CompilterTest_%Proj%_%LibType%_%CrtType%%NAME_POSTFIX%
  set ERR_FILE="err_compiler.txt"
  if not exist %OBJ_DIR%\%BuildCompDir%\%BuildProjDir% md %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  pushd %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  set SRC_DIR=%STLPORT_DIR%test\Compiler\
  call :L_COMPIER_TEST_OBJ ttei1 cpp
  call :L_COMPIER_TEST_OBJ ttei2 cpp
  call :L_COMPIER_TEST_OBJ ttei3 cpp
  call :L_COMPIER_TEST_OBJ ttei4 cpp
  call :L_COMPIER_TEST_OBJ ttei5 cpp
  call :L_COMPIER_TEST_OBJ ttei6 cpp
  call :L_COMPIER_TEST_OBJ ttei7 cpp
  call :L_COMPIER_TEST_OBJ movable cpp
  call :L_COMPIER_TEST_OBJ partial_spec cpp
  call :L_COMPIER_TEST_EXE eh cc
  if "%errorlevel%"=="0" (
    eh.exe
  )
  set SRC_DIR=%STLPORT_DIR%test\Compiler\StTerm-order\
  call :L_COMPIER_TEST_EXE stterm-test cc
  if not "%errorlevel%"=="0" goto L_COMPILERTEST_END
  stterm-test.exe >stterm-test.rslt
  if not "%errorlevel%"=="0" goto L_COMPILERTEST_ERR
  fc /L stterm-test.rslt %SRC_DIR%stterm-test-ok.txt >nul
  if not "%errorlevel%"=="0" goto L_COMPILERTEST_ERR
  echo stterm-test : ok
  goto L_COMPILERTEST_END
:L_COMPILERTEST_ERR
  echo stterm-test : ng
:L_COMPILERTEST_END
  popd
  rem if not "%ERR%"=="" goto L_ERR
  goto L_KKKK

:L_COMPIER_TEST_EXE
  if /I exist %1.exe   del %1.exe
  if /I "%Compiler%"=="bcc" (
    %CXX% %O_CC% %O_CC_LIB%%TGT_LIB_DIR% %3 %4 %5 %6 %7 %8 %9 %O_CC_EXE_OUT%%1.exe %SRC_DIR%%1.%2 %LIB_NAME% %ERN%>>%ERR_FILE%
  ) else (
    %CXX% %O_CC% %3 %4 %5 %6 %7 %8 %9 %O_CC_EXE_OUT%%1.exe %SRC_DIR%%1.%2 %O_CC_LIB%%TGT_LIB_DIR%\%LIB_NAME% %ERN%>>%ERR_FILE%
  )
  if not "%errorlevel%"=="" (
    if /I exist %1.exe (
      echo %1 is compiled.
      rem %1.exe
      exit /b 0
    )
  )
  echo %1: compile failed.
  exit /b 1

:L_COMPIER_TEST_OBJ
  %CXX% %O_CC_CO% %O_CC% %3 %4 %5 %6 %7 %8 %9 %O_CC_OUT%%1.obj %SRC_DIR%%1.%2 %O_CC_LIB%%TGT_LIB_DIR%\%LIB_NAME% %ERN%>>%ERR_FILE%
  if not "%errorlevel%"=="" (
    if /I exist %1.obj (
      echo %1 is compiled.
      exit /b 0
    )
  )
  echo %1: failed.
  exit /b 1

:L_KKKK
  if "%TgtKkkkTest%"=="" goto L_END
  set BuildProjDir=KKKK_%Proj%_%LibType%_%CrtType%%NAME_POSTFIX%
  set ERR_FILE="err_kkkk.txt"
  if not exist %OBJ_DIR%\%BuildCompDir%\%BuildProjDir% md %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%

  pushd %OBJ_DIR%\%BuildCompDir%\%BuildProjDir%
  set SRC_DIR=%STLPORT_DIR%test\kkkk\
  call :L_COMPIER_TEST_EXE stlp_macname_chk cpp
  if "%errorlevel%"=="0" (
    copy stlp_macname_chk.exe %TGT_EXE_DIR%\stlp_macname_chk.exe
    stlp_macname_chk.exe 1>stlp_macname_chk.txt
  )
  popd
  goto L_END

rem delete work-files
:L_CLEAN
  del /s /q /f *.obj
  del /s /q /f *.o
  del /s /q /f err_*.txt
  del /s /q /f *.err
  goto L_END


rem help.
:L_HELP
  echo usage: build_stlp.bat [COMPILER] [TARGET] [x86/x64] [rel/dbg/stldbg] [static/shared] [rtdll/rtsta] [OPTS]
  echo COMPILER=dmc,ow,vc71,vc8,vc9,vc10,vc11,mingw,bcc
  echo TARGET:
  echo  lib                 make stlport.lib
  echo  ehtest              make test/eh
  echo  unittest            make test/unit
  echo  all                 lib,ehtest,unittest
  echo OPTS:
  echo  --no-mt             without Multi-Thread-Library
  echo  --no-except         without exceptions
  echo  --no-rtti           without RTTI and exceptions
  echo  --no-ios            without iostreams
  rem echo  --boost BOOST-PATH  use Boost-Library
  exit /b 1
  goto L_END

:L_ERR_EXIT
  exit /b 1

:L_ERR
  call :L_ERR_EXIT

rem finish
:L_END
@echo.
set "INCLUDE=%ORIG_INCLUDE%"

endlocal
