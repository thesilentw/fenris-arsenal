@echo off

REM Source directory name. DO NOT MODIFY!

set sourcedirname=src




REM *******************************************************
REM *           MODIFY THE VARIABLES BELOW TO SUIT        *
REM *                      YOUR PROJECT                   *
REM *******************************************************




REM Set the path to your game executable (ZDoom, GZDoom, whatever)
REM and the executable itself below.
set exepath=E:\Games\GZDoom
set exename=gzdoom.exe

REM Set the path to your project below.
set projectpath=E:\Games\GZDoom\dev\moonly-fiesta




REM *******************************************************
REM *           PROCEED TO COMPILE ACS LIBRARIES,         *
REM *                    AND MAP SCRIPTS                  *
REM *******************************************************



REM First, delete all previously compiled libraries
cd %sourcedirname%\acs
del *.o
del error.txt

REM Now let's go to the source directory
cd ../mfacs
del *.o
del error.txt

REM Compile all libraries
for %%v in (*.acs) do (
acc "%%v" ../acs/"%%~nv.o"
REM pause
if exist acs.err ren acs.err error.txt
if exist error.txt goto acserror
)

goto acsnoerror

:acsnoerror

echo ACS compiled successfully.

REM Generate the LOADACS
type NUL > ../loadacs.txt
echo // Generated automatically by build script at %TIME% on %DATE%, do not edit>>../loadacs.txt
for %%v in (*.o) do (
echo %%~nv>>../loadacs.txt
)

goto acsend

:acserror

echo Errors found in compiling ACS libraries. Aborting...
error.txt
exit

:acsend

:compileend