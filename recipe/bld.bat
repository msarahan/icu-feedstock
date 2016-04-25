cd source

:: MSYS includes a link.exe that is not MSVC's linker.  Hide it.
MOVE %LIBRARY_PREFIX%\usr\bin\link.exe %LIBRARY_PREFIX%\usr\bin\link.exe.backup

set LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%
set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

bash -c "echo $PATH"
bash -c "echo $(which link.exe)"
bash runConfigureICU MSYS/MSVC --prefix=%LIBRARY_PREFIX% --enable-static
if errorlevel 1 exit 1
make
if errorlevel 1 exit 1
make check
if errorlevel 1 exit 1
make install
if errorlevel 1 exit 1

set LIBRARY_PREFIX=%LIBRARY_PREFIX:/=\%

:: Restore MSYS' link.exe
MOVE %LIBRARY_PREFIX%\usr\bin\link.exe.backup %LIBRARY_PREFIX%\usr\bin\link.exe
exit 0
