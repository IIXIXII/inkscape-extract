#=============================================================================#
#    Atelier de développement                                                 #
#    Copyright (C) 2005 INSEE                                                 #
#    Licence GPL                                                              #
#=============================================================================#

!verbose push
!verbose 3

!ifndef BUILD_NUMBER_INCREMENT_NSH_
!define BUILD_NUMBER_INCREMENT_NSH_

!ifndef BN_PKG
    !define NAME_PKG ``
!else
    !define NAME_PKG `_${BN_PKG}`
!endif

; avancement du build_number
; l'avancement automatique du build number est produit par une suite de commande dos
; le fichier construct_build_number.bat est construit en serie
;       ce ficher definit la variable d'environnement BUILD_NUMBER
;       et affiche !define BUILD_NUMBER "%BUILD_NUMBER%"
; le resultat est mis dans le fichier include/build_number.nsh

;chemin d'accès
!define BN_BUILD_NUMBER_PATH        "build_number"
!define BN_BUILD_NUMBER_FILENAME    "build_number${NAME_PKG}.nsh"
!define BN_BUILD_NUMBER_SCRIPT_BAT  "construct_build_number${NAME_PKG}.bat"

; ajout d'une ligne dans le script bat
!macro BN_BUILD_NUMBER_ADD_LINE LINE
    !system 'echo ${LINE} >> ${BN_BUILD_NUMBER_SCRIPT_BAT}'
!macroend

!system 'MKDIR ${BN_BUILD_NUMBER_PATH}'
!system 'echo !ifndef BUILD_NUMBER >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'
!system 'echo !define BUILD_NUMBER 1 >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'
!system 'echo !endif >> ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'

;inclusion du build_number actuel
!addincludedir "${BN_BUILD_NUMBER_PATH}"
!include "${BN_BUILD_NUMBER_FILENAME}"

!ifndef NO_INCREMENT

; création du script bat
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

; lancement du script
!system '${BN_BUILD_NUMBER_SCRIPT_BAT} > ${BN_BUILD_NUMBER_PATH}\${BN_BUILD_NUMBER_FILENAME}'

;effacement du script
!system 'del ${BN_BUILD_NUMBER_SCRIPT_BAT}'

!endif ; NO_INCREMENT

!endif ; !ifndef BUILD_NUMBER_INCREMENT_NSH_

!verbose pop
