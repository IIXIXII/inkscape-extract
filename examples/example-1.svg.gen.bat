@ECHO off
REM ###############################################################################
REM # 
REM # Copyright (c) 2018 Florent TOURNOIS
REM # 
REM # Permission is hereby granted, free of charge, to any person obtaining a copy
REM # of this software and associated documentation files (the "Software"), to deal
REM # in the Software without restriction, including without limitation the rights
REM # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM # copies of the Software, and to permit persons to whom the Software is
REM # furnished to do so, subject to the following conditions:
REM # 
REM # The above copyright notice and this permission notice shall be included in 
REM # all copies or substantial portions of the Software.
REM # 
REM # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM # SOFTWARE.
REM # 
REM ###############################################################################
REM
REM ###############################################################################
CHCP 65001
MODE 100,45
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
CALL :PRINT_LINE "║         _____       _                               ______      _                  _             ║"
CALL :PRINT_LINE "║        |_   _|     | |                             |  ____|    | |                | |            ║"
CALL :PRINT_LINE "║          | |  _ __ | | _____  ___ __ _ _ __   ___  | |__  __  _| |_ _ __ __ _  ___| |_           ║"
CALL :PRINT_LINE "║          | | | '_ \| |/ / __|/ __/ _` | '_ \ / _ \ |  __| \ \/ / __| '__/ _` |/ __| __|          ║"
CALL :PRINT_LINE "║         _| |_| | | |   <\__ \ (_| (_| | |_) |  __/ | |____ >  <| |_| | | (_| | (__| |_           ║"
CALL :PRINT_LINE "║        |_____|_| |_|_|\_\___/\___\__,_| .__/ \___| |______/_/\_\\__|_|  \__,_|\___|\__|          ║"
CALL :PRINT_LINE "║                                       | |                                                        ║"
CALL :PRINT_LINE "║                                       |_|                                                        ║"
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
SET NB_IMG=2
SET FILENAME="example-1.svg"
SET FILENAME_PATH="C:\tournois-family\dev\inkscape-extract\examples"
SET COUNTER_IMG=0
REM ###############################################################################
REM ###############################################################################
SET NB_EXPORT=4
SET COUNTER_EXPORT=0
SET /a COUNTER_IMG=%COUNTER_IMG% + 1
REM ###############################################################################
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h64-trans.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\trium"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=64
SET PARAM2=transparent
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h64-trans.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h64-trans.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h128-trans.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\trium"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=128
SET PARAM2=transparent
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h128-trans.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h128-trans.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h1024-trans.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\trium"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=1024
SET PARAM2=transparent
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="1024" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h1024-trans.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="1024" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h1024-trans.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h2048-trans.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\trium"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=2048
SET PARAM2=transparent
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="2048" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h2048-trans.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g4700" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="2048" --export-background-opacity="0" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\trium\trium-team-h2048-trans.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ###############################################################################
SET NB_EXPORT=15
SET COUNTER_EXPORT=0
SET /a COUNTER_IMG=%COUNTER_IMG% + 1
REM ###############################################################################
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg0-146-188.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=16
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg0-146-188.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg0-146-188.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg229-49-56.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=16
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg229-49-56.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg229-49-56.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg132-134-135.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=16
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg132-134-135.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="16" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h16-opacity255-bg132-134-135.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg0-146-188.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=32
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg0-146-188.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg0-146-188.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg229-49-56.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=32
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg229-49-56.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg229-49-56.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg132-134-135.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=32
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg132-134-135.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="32" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h32-opacity255-bg132-134-135.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg0-146-188.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=64
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg0-146-188.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg0-146-188.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg229-49-56.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=64
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg229-49-56.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg229-49-56.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg132-134-135.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=64
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg132-134-135.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="64" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h64-opacity255-bg132-134-135.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg0-146-188.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=128
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg0-146-188.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg0-146-188.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg229-49-56.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=128
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg229-49-56.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg229-49-56.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg132-134-135.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=128
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg132-134-135.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="128" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h128-opacity255-bg132-134-135.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg0-146-188.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=256
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg0-146-188.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(0,146,188)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg0-146-188.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg229-49-56.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=256
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg229-49-56.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(229,49,56)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg229-49-56.png"
    TIMEOUT /T 3 /NOBREAK
)
REM ------------------------------------------------------------
SET /a COUNTER_EXPORT=%COUNTER_EXPORT% + 1
SET OUTPUT_FILENAME="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg132-134-135.png"
SET OUTPUT_PATH="C:\tournois-family\dev\inkscape-extract\examples\output\ge"
SET EXPORT_TYPE=PNG
SET PARAM1=HEIGHT=256
SET PARAM2=BACKGROUND COLOR rgb(0,146,188)
SET PARAM3=
SET PARAM4=
SET CMD_LINE="C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg132-134-135.png"
CALL :GENERATE-EXPORT
CALL :RESET_ERROR
if exist %OUTPUT_FILENAME% (
    @ECHO: No need to create
) else (
    "C:\Program Files\Inkscape\inkscape.exe" -z --export-id="g11778" --export-id-only --file="C:\tournois-family\dev\inkscape-extract\examples\example-1.svg"  --export-height="256" --export-background-opacity="255" --export-background="rgb(132,134,135)" --export-png="C:\tournois-family\dev\inkscape-extract\examples\output\ge\ge-icon-mono-h256-opacity255-bg132-134-135.png"
    TIMEOUT /T 3 /NOBREAK
)
