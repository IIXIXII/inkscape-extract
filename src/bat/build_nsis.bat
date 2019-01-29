@ECHO off
REM ###############################################################################
REM #  
REM #  Copyright (c) 2018 Florent TOURNOIS
REM #  
REM #  Permission is hereby granted, free of charge, to any person obtaining a copy
REM #  of this software and associated documentation files (the "Software"), to deal
REM #  in the Software without restriction, including without limitation the rights
REM #  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
REM #  copies of the Software, and to permit persons to whom the Software is
REM #  furnished to do so, subject to the following conditions:
REM #  
REM #  The above copyright notice and this permission notice shall be included in all
REM #  copies or substantial portions of the Software.
REM #  
REM #  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM #  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM #  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM #  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM #  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM #  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM #  SOFTWARE.
REM #  
REM ###############################################################################
SET FUN="common.bat" 
CALL %FUN% :CONFIGURE_DISPLAY
CALL %FUN% :CLEAR_SCREEN
CALL %FUN% :PRINT_LINE "   Create installer with NSIS" 
REM ###############################################################################
cd ../../doc
SET NSIS_PATH=C:\\Program Files (x86)\\NSIS
SET NSIS_EXE=makensis.exe
SET NSIS_CMD=%NSIS_PATH%\\%NSIS_EXE%
SET NSIS_FOLDER=%~dp0\\..\\..\\src\\nsis

SET NSIS_FILE="%NSIS_FOLDER%\\inkscape_extract.nsi"

IF EXIST "%NSIS_CMD%" (
	ECHO "Found NSIS %NSIS_CMD%"
) ELSE (
	ECHO "%NSIS_CMD%"
	ECHO "Nsis not found"
	pause
	GOTO:END
)

IF EXIST "%NSIS_FILE%" (
	ECHO "Found nsis file %NSIS_FILE%"
) ELSE (
	ECHO "%NSIS_FILE%"
	ECHO "NSIS file not found"
	pause
	GOTO:END
)

ECHO ------------------------------------------
ECHO "Start NSIS generation"
"%NSIS_CMD%"  /V4 "%NSIS_FILE%"
pause
:END
ECHO ------------------------------------------