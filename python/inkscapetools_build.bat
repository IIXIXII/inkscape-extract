@ECHO OFF
REM ###############################################################################
REM # @copyright Copyright (C) Guichet Entreprises - All Rights Reserved
REM # 	All Rights Reserved.
REM # 	Unauthorized copying of this file, via any medium is strictly prohibited
REM # 	Dissemination of this information or reproduction of this material
REM # 	is strictly forbidden unless prior written permission is obtained
REM # 	from Guichet Entreprises.
REM ###############################################################################
GOTO DECLARE_FUNCTION_END
:PRINT_LINE <textVar>
(
    SET "LINE_HERE=%~1"
    SETLOCAL EnableDelayedExpansion
    @ECHO !LINE_HERE!
    ENDLOCAL
    exit /b
)
:DECLARE_FUNCTION_END
CHCP 65001
MODE 100,40
CALL :PRINT_LINE "╔══════════════════════════════════════════════════════════════════════════════════════════════════╗"
CALL :PRINT_LINE "║         _____       _                               ______      _                  _             ║"
CALL :PRINT_LINE "║        |_   _|     | |                             |  ____|    | |                | |            ║"
CALL :PRINT_LINE "║          | |  _ __ | | _____  ___ __ _ _ __   ___  | |__  __  _| |_ _ __ __ _  ___| |_           ║"
CALL :PRINT_LINE "║          | | | '_ \| |/ / __|/ __/ _` | '_ \ / _ \ |  __| \ \/ / __| '__/ _` |/ __| __|          ║"
CALL :PRINT_LINE "║         _| |_| | | |   <\__ \ (_| (_| | |_) |  __/ | |____ >  <| |_| | | (_| | (__| |_           ║"
CALL :PRINT_LINE "║        |_____|_| |_|_|\_\___/\___\__,_| .__/ \___| |______/_/\_\\__|_|  \__,_|\___|\__|          ║"
CALL :PRINT_LINE "║                                       | |                                                        ║"
CALL :PRINT_LINE "║                                       |_|                                                        ║"
CALL :PRINT_LINE "╚══════════════════════════════════════════════════════════════════════════════════════════════════╝"
REM ###############################################################################
CALL :PRINT_LINE "Freeze the application"
python inkscapetools_setup.py build

