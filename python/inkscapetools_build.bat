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
CALL :PRINT_LINE "║                      ╔═╗┬ ┬┬┌─┐┬ ┬┌─┐┌┬┐  ╔═╗┌┐┌┌┬┐┬─┐┌─┐┌─┐┬─┐┬┌─┐┌─┐┌─┐                        ║"
CALL :PRINT_LINE "║                      ║ ╦│ │││  ├─┤├┤  │   ║╣ │││ │ ├┬┘├┤ ├─┘├┬┘│└─┐├┤ └─┐                        ║"
CALL :PRINT_LINE "║                      ╚═╝└─┘┴└─┘┴ ┴└─┘ ┴   ╚═╝┘└┘ ┴ ┴└─└─┘┴  ┴└─┴└─┘└─┘└─┘                        ║"
CALL :PRINT_LINE "╚══════════════════════════════════════════════════════════════════════════════════════════════════╝"
REM ###############################################################################
python inkscapetools_setup.py build

