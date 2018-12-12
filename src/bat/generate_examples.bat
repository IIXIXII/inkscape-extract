@ECHO OFF
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
SET FUN="common.bat" 
CALL %FUN% :CONFIGURE_DISPLAY
CALL %FUN% :CLEAR_SCREEN
CALL %FUN% :PRINT_LINE "   Generate example" 
REM ###############################################################################
SET IEXTRACT="%~dp0..\..\distribution\inkscape_extract.exe"
if exist %IEXTRACT% (
	@ECHO: Found inkscape_extract
	@ECHO: 		%IEXTRACT%
) else (
	@ECHO: Can not find inkscape_extract
	pause
	exit
)
CD ../../examples
FOR %%i in (*.svg) DO (
	ECHO:
	ECHO: %%i
	%IEXTRACT% --verbose=yes --windows=no --create-batch=yes %%i
)


