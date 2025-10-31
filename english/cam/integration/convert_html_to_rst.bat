@echo off
call :treeProcess
goto :eof

:treeProcess
rem Do whatever you want here over the files of this subdir (e.g., process .tif files)
for %%f in (*.htm) do (
    echo Converting file: %%f
    pandoc --from=html %%f --to=rst --extract-media=./media -o %%~nf.rst
)

rem Recurse into subdirectories
for /D %%d in (*) do (
    cd %%d
    call :treeProcess
    cd ..
)
exit /b
