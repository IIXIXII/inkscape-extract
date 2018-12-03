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
CALL %*
GOTO EOF
REM -------------------------------------------------------------------------------
:PRINT_LINE <textVar>
(
    SET "LINE_HERE=%~1"
    SETLOCAL EnableDelayedExpansion
    @ECHO !LINE_HERE!
    ENDLOCAL
    exit /b
)
REM -------------------------------------------------------------------------------
:CONFIGURE_DISPLAY
(
    CHCP 65001
    MODE 100,40
    exit /b
)
REM -------------------------------------------------------------------------------
:START_BAT
(
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
    exit /b
)
REM -------------------------------------------------------------------------------
:EOF
