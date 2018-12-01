###############################################################################
# 
# Copyright (c) 2018 Florent TOURNOIS
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
###############################################################################
###############################################################################
# Simple script to define a BUILD_NUMBER macro variable in snsis execution
#
# to the main script add
#      !include "build_number_increment.nsh"
# and the build number will be created. the folder build_number will 
# be populated with the nsh file "build_number${NAME_PKG}.nsh" 
# defining the BUILD_NUMBERR
#
# you can define the package name before the include
#      !define BN_PKG "YOUR_PACKAGE_NAME"
#      !include "build_number_increment.nsh"
#
###############################################################################
!verbose push
!verbose 3

!ifndef BUILD_NUMBER_INCREMENT_NSH_
!define BUILD_NUMBER_INCREMENT_NSH_

!ifndef BN_PKG
    !define NAME_PKG ``
!else
    !define NAME_PKG `_${BN_PKG}`
!endif

###############################################################################
# Define all the path file and folder name
###############################################################################
!define BN_BUILD_NUMBER_PATH        "build_number"
!define BN_BUILD_NUMBER_FILENAME    "build_number${NAME_PKG}.nsh"
!define BN_BUILD_NUMBER_SCRIPT_BAT  "construct_build_number${NAME_PKG}.bat"

###############################################################################
# Create or add to the nsh build number the BUILD_NUMBER setting to 1
# If the file already exist, no impact will be done by this 
###############################################################################
!system 'MKDIR ${BN_BUILD_NUMBER_PATH}'
!system 'echo !ifndef BUILD_NUMBER >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'
!system 'echo !define BUILD_NUMBER 1 >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'
!system 'echo !endif >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'

###############################################################################
# Include and define the BUILD_NUMBER
###############################################################################
!addincludedir "${BN_BUILD_NUMBER_PATH}"
!include "${BN_BUILD_NUMBER_FILENAME}"

!ifndef NO_INCREMENT

###############################################################################
# Macro to add a line in the bat script file
###############################################################################
!macro BN_BUILD_NUMBER_ADD_LINE LINE
    !system 'echo ${LINE} >> ${BN_BUILD_NUMBER_SCRIPT_BAT}'
!macroend

###############################################################################
# Make the increment by creating a bat script.
# the bat scipt create the nsh script and add 1
###############################################################################
!system 'echo @echo off > ${BN_BUILD_NUMBER_SCRIPT_BAT}'
!insertmacro BN_BUILD_NUMBER_ADD_LINE "set /A BUILD_NUMBER=${BUILD_NUMBER}+1"
!insertmacro BN_BUILD_NUMBER_ADD_LINE "echo !ifndef BN_FILE_BUILD_NUMBER${NAME_PKG}_NSH_"
!insertmacro BN_BUILD_NUMBER_ADD_LINE "echo !define BN_FILE_BUILD_NUMBER${NAME_PKG}_NSH_"
!insertmacro BN_BUILD_NUMBER_ADD_LINE 'echo !define BUILD_NUMBER "%BUILD_NUMBER%"'
!insertmacro BN_BUILD_NUMBER_ADD_LINE 'echo !verbose push'
!insertmacro BN_BUILD_NUMBER_ADD_LINE 'echo !verbose 4'
!insertmacro BN_BUILD_NUMBER_ADD_LINE 'echo !echo "current build number is %BUILD_NUMBER%"'
!insertmacro BN_BUILD_NUMBER_ADD_LINE 'echo !verbose pop'
!insertmacro BN_BUILD_NUMBER_ADD_LINE "echo !endif # !ifndef BN_FILE_BUILD_NUMBER${NAME_PKG}_NSH_"

###############################################################################
# execute the bat script
###############################################################################
!system '${BN_BUILD_NUMBER_SCRIPT_BAT} > ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'

###############################################################################
# remove the bat script
###############################################################################
!system 'del ${BN_BUILD_NUMBER_SCRIPT_BAT}'

!endif ; NO_INCREMENT

!endif ; !ifndef BUILD_NUMBER_INCREMENT_NSH_

!verbose pop
