@ECHO OFF
REM ###############################################################################
REM # @copyright Copyright (C) Guichet Entreprises - All Rights Reserved
REM # 	All Rights Reserved.
REM # 	Unauthorized copying of this file, via any medium is strictly prohibited
REM # 	Dissemination of this information or reproduction of this material
REM # 	is strictly forbidden unless prior written permission is obtained
REM # 	from Guichet Entreprises.
REM ###############################################################################
REM
REM ###############################################################################
CHCP 65001
MODE 100,40
SETLOCAL EnableDelayedExpansion
GOTO GENERATE-EXPORT-END
:RESET_ERROR
exit /b 0
:PRINT_LINE <textVar>
(
    SET "LINE_HERE=%~1"
    @ECHO !LINE_HERE!
    exit /b
)
:SHORT_FROM_FILENAME <shortFilenameVar> <filenameVar>
(
    set "%~1=%~nx2"
    exit /b
)
:CREATE_PATH <pathVar>
(
    if not exist %1 (
        mkdir %1
        if "!errorlevel!" EQU "0" (
            @ECHO: Folder created successfully
        ) else (
            @ECHO: Error while creating folder
        )
    ) else (
      @ECHO: Folder already exists
    )
    exit /b
)
:TEST_FILE <pathVar>
(
    if exist %1 (
        @ECHO: File already exists
    ) else (
        @ECHO: File will be created
    )
    exit /b
)
:GENERATE-EXPORT
CLS
@ECHO OFF
CALL :PRINT_LINE "╔══════════════════════════════════════════════════════════════════════════════════════════════════╗"
CALL :PRINT_LINE "║                      ╔═╗┬ ┬┬┌─┐┬ ┬┌─┐┌┬┐  ╔═╗┌┐┌┌┬┐┬─┐┌─┐┌─┐┬─┐┬┌─┐┌─┐┌─┐                        ║"
CALL :PRINT_LINE "║                      ║ ╦│ │││  ├─┤├┤  │   ║╣ │││ │ ├┬┘├┤ ├─┘├┬┘│└─┐├┤ └─┐                        ║"
CALL :PRINT_LINE "║                      ╚═╝└─┘┴└─┘┴ ┴└─┘ ┴   ╚═╝┘└┘ ┴ ┴└─└─┘┴  ┴└─┴└─┘└─┘└─┘                        ║"
CALL :PRINT_LINE "╚══════════════════════════════════════════════════════════════════════════════════════════════════╝"
@ECHO:
@ECHO: Generate export from inkscape file %FILENAME%
@ECHO:
CALL :PRINT_LINE "├──────────────────────────────────────────────────────────────────────────────────────────────────┤"
@ECHO: PATH = %FILENAME_PATH%
CALL :PRINT_LINE "├──────────────────────────────────────────────────────────────────────────────────────────────────┤"
@ECHO:
@ECHO: image %COUNTER_IMG% / %NB_IMG%  --  export %COUNTER_EXPORT% / %NB_EXPORT%
@ECHO:
CALL :PRINT_LINE "├──────────────────────────────────────────────────────────────────────────────────────────────────┤"
@ECHO: 
CALL :SHORT_FROM_FILENAME SHORT_FILENAME "%OUTPUT_FILENAME%"
@ECHO: PATH = %OUTPUT_PATH%
CALL :CREATE_PATH %OUTPUT_PATH%
@ECHO:
@ECHO: FILE = %SHORT_FILENAME%
CALL :TEST_FILE %OUTPUT_FILENAME%
@ECHO:
@ECHO: Type:%EXPORT_TYPE%
@ECHO:
@ECHO: Parameters:%PARAM1%
@ECHO:            %PARAM2%
@ECHO:            %PARAM3%
@ECHO:            %PARAM4%
@ECHO: 
CALL :PRINT_LINE "├──────────────────────────────────────────────────────────────────────────────────────────────────┤"
@ECHO: %CMD_LINE%
EXIT /B
:GENERATE-EXPORT-END
REM ###############################################################################
SET NB_IMG={NB_IMAGE}
SET FILENAME="{FILENAME}"
SET FILENAME_PATH="{FILENAME_PATH}"
SET COUNTER_IMG=0
REM ###############################################################################
