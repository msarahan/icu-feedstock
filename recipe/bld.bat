::if "%ARCH%"=="32" (
::   set ARCH=Win32
::   set COPYSUFFIX=
::) else (
::  set ARCH=x64
::  set COPYSUFFIX=64
::)

setlocal enabledelayedexpansion

:: line feed, see http://stackoverflow.com/a/5642300/1170370
(SET LF=^

)

set "command=if [[ $(uname -s) =~ ^CYGWIN* ]]; then !LF!"
set "command=!command!     PREFIX=$(cygpath %LIBRARY_PREFIX:\=\\%) !LF!"
set "command=!command!else !LF!"
set "command=!command!     PREFIX=%LIBRARY_PREFIX:\=/% !LF!"
set "command=!command!fi !LF!"

set "command=!command!OLD_LINK=$(which link) !LF!"
set "command=!command!if [[ ${OLD_LINK} =~ *usr/bin* ]]; then !LF!"
set "command=!command!    mv ${OLD_LINK} link_backup !LF!"
set "command=!command!else !LF!"
set "command=!command!    unset OLD_LINK !LF!"
set "command=!command!fi !LF!"

set "command=!command!if [[ $(uname -s) =~ ^CYGWIN* ]]; then !LF!"
set "command=!command!     cd $(cygpath %SRC_DIR:\=\\%\\source)!LF!"
set "command=!command!else !LF!"
set "command=!command!     cd %SRC_DIR:\=/%/source!LF!"
set "command=!command!fi !LF!"

set "command=!command!./runConfigureICU Cygwin/MSVC --prefix=${PREFIX} --enable-static --disable-samples --disable-extras --disable-layout --disable-tests !LF!"

 set "command=!command!make && make check && make install !LF!"

set "command=!command!if [[ -n ""$OLD_LINK"" ]]; then !LF!"
set "command=!command!    mv link_backup ${OLD_LINK} !LF!"
set "command=!command!fi !LF!"
echo !command! > "bash_cmd.sh"

endlocal

bash.exe -x bash_cmd.sh

:: msbuild source\allinone\allinone.sln /p:Configuration=Release;Platform=%ARCH%

:: ROBOCOPY bin%COPYSUFFIX% %LIBRARY_BIN% *.dll /E
:: ROBOCOPY lib%COPYSUFFIX% %LIBRARY_LIB% *.lib /E
:: ROBOCOPY include %LIBRARY_inc% * /E

:: if %ERRORLEVEL% LSS 8 exit 0
