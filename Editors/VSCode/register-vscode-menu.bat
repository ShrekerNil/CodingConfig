@Echo Off

title VSCode Portable Edition Context Menu Management BAT Tool
SetLocal EnableDelayedExpansion

SET SourceFile=Code.exe

if exist "!cd!\!SourceFile!" (

    echo 1. Install Context Menu
    echo 2. Uninstall Context Menu
    echo 0. Exit
    echo=
    echo=
    echo=

    :start
    Set /p u=Please enter a number and press Enter to confirm:

    IF "!u!"=="1" (
        @echo off

        reg add>nul 2>nul "HKEY_CLASSES_ROOT\*\shell\VSCode" /d "Open with VSCode" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\*\shell\VSCode" /v "Icon" /d "!cd!\!SourceFile!" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\*\shell\VSCode\command" /d "\"!cd!\!SourceFile!\" \"%%1\"" /t "REG_EXPAND_SZ" /f

        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\background\shell\VSCode" /d "Open with VSCode" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\background\shell\VSCode" /v "Icon" /d "!cd!\!SourceFile!" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\background\shell\VSCode\command" /d "\"!cd!\!SourceFile!\" \"%%V\"" /t "REG_EXPAND_SZ" /f

        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\shell\VSCode" /d "Open with VSCode" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\shell\VSCode" /v "Icon" /d "!cd!\!SourceFile!" /t "REG_EXPAND_SZ" /f
        reg add>nul 2>nul "HKEY_CLASSES_ROOT\directory\shell\VSCode\command" /d "\"!cd!\!SourceFile!\" \"%%V\"" /t "REG_EXPAND_SZ" /f

        set u=<nul
        echo=
        echo Installation completed.
        goto start

    ) ELSE IF "!u!"=="2" (
        @echo off

        reg delete>nul 2>nul "HKEY_CLASSES_ROOT\*\shell\VSCode" /f
        reg delete>nul 2>nul "HKEY_CLASSES_ROOT\directory\background\shell\VSCode" /f
        reg delete>nul 2>nul "HKEY_CLASSES_ROOT\directory\shell\VSCode" /f

        set u=<nul
        echo=
        echo Uninstallation completed.
        goto start

    ) ELSE IF "!u!"=="0" (
        exit
    ) ELSE (
        goto start
    )

) else (
    set /p=Please place this script in the directory where !SourceFile! is located...<nul & pause >nul
)
endlocal
