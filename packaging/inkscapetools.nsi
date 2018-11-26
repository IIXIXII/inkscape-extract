;##############################################################################
; @copyright Copyright (C) Guichet Entreprises - All Rights Reserved
; 	All Rights Reserved.
; 	Unauthorized copying of this file, via any medium is strictly prohibited
; 	Dissemination of this information or reproduction of this material
; 	is strictly forbidden unless prior written permission is obtained
; 	from Guichet Entreprises.
;##############################################################################
;---------------------------------
;  General
;---------------------------------
!addincludedir "./nsh"
!include "MUI2.nsh"
!include "StrFunc.nsh"
!include "fileassoc.nsh"

;---------------------------------
; The product
;---------------------------------
!define PRODUCT_SHORTNAME 	"inkscapetools"
!define PRODUCT_LONGNAME 	"Inkscape tools"
!define PRODUCT_VERSION 	"1.3"

!define BN_PKG "${PRODUCT_SHORTNAME}"
!include "build_number_increment.nsh"

;---------------------------------
; Explorer context and registry
;---------------------------------
!define DESCRIPTION 		"Inkscape File"
!define MENU_DESCRIPTION 	"GE Inkscape Tools"
!define EXT 			"svg"
!define FILECLASS 		"ge.inkscapetools.file"

;---------------------------------
; General
;---------------------------------
!define /date TIMESTAMP "%Y-%m-%d"

;---------------------------------
Name "${PRODUCT_LONGNAME}"
OutFile "setup_${PRODUCT_SHORTNAME}-v${PRODUCT_VERSION}-[${BUILD_NUMBER}]-${TIMESTAMP}.exe"
ShowInstDetails "nevershow"
ShowUninstDetails "nevershow"
CRCCheck On
XPStyle on
VIProductVersion "${PRODUCT_VERSION}-[${Build_NUMBER}]"
SpaceTexts none

;---------------------------------
!define MUI_ICON "icon/ge.ico"
!define MUI_UNICON "icon/ge.ico"
BrandingText "Guichet Entreprises - ${TIMESTAMP}"

;--------------------------------
;Folder selection page
InstallDir "$PROGRAMFILES\ge.fr\${PRODUCT_SHORTNAME}"
InstallDirRegKey HKCU "Software\${PRODUCT_SHORTNAME}" ""

;--------------------------------
;Modern UI Configuration
 
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages
;--------------------------------
!insertmacro MUI_LANGUAGE "French"

Var SvgFileClass

;-------------------------------- 
;Installer Sections     
Section "install"  
	;Add files
	SetOutPath "$INSTDIR"

 	File /r /x *.log "..\\python\\dist\\*.*"
 	File /r /x *.log "icon\\*.ico"
	
	ReadRegStr $SvgFileClass HKCR ".${EXT}" ""
; 	MessageBox MB_OK "Class : $SvgFileClass"

	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.${EXT}"
	DeleteRegKey HKCR ".${EXT}\OpenWithProgids"
	DeleteRegValue HKCR ".${EXT}" "Content Type"
	
	StrCmp $SvgFileClass "" notfound
; 		MessageBox MB_OK 'Found string $SvgFileClass'
		Goto done
	notfound:
		StrCpy $SvgFileClass "${FILECLASS}"
; 		MessageBox MB_OK 'Found string $SvgFileClass'
		WriteRegStr HKCR ".${EXT}" "" "$SvgFileClass"
		WriteRegStr  HKCR "$SvgFileClass" "" `${DESCRIPTION}`
		WriteRegStr  HKCR "$SvgFileClass\DefaultIcon" "" `$INSTDIR\inkscapetools.exe,0`

	done:
	
	
	DeleteRegKey HKCR "$SvgFileClass\shell\open"
	DeleteRegKey HKCR "$SvgFileClass\shell\opennew"
	DeleteRegKey HKCR "$SvgFileClass\shell\edit"
	DeleteRegKey HKCR "$SvgFileClass\shell\print"
	DeleteRegKey HKCR "$SvgFileClass\shell\printto"
	DeleteRegKey HKCR "$SvgFileClass\shell\inkscapeMenu"
	DeleteRegValue HKCR "$SvgFileClass" "CLSID"
	DeleteRegValue HKCR "$SvgFileClass" "FriendlyTypeName"
	DeleteRegValue HKCR "$SvgFileClass" "EditFlags"
	DeleteRegValue HKCR "$SvgFileClass" "AppUserModelID"
	
	WriteRegStr  HKCR "$SvgFileClass\Shell\InkscapeToolsMenu" "MUIVerb" `${MENU_DESCRIPTION}`
	WriteRegStr  HKCR "$SvgFileClass\Shell\InkscapeToolsMenu" "Icon" `"$INSTDIR\inkscapetools.exe"`
	WriteRegStr  HKCR "$SvgFileClass\Shell\InkscapeToolsMenu" "ExtendedSubCommandsKey" `$SvgFileClass\${PRODUCT_SHORTNAME}.command.menu`
	
 	WriteRegStr 		HKCR "$SvgFileClass\${PRODUCT_SHORTNAME}.command.menu\Shell\cmd1" "MUIVerb" `Create Batch for export`
 	WriteRegStr 		HKCR "$SvgFileClass\${PRODUCT_SHORTNAME}.command.menu\Shell\cmd1" "Icon" `"$INSTDIR\batch.ico"`
 	WriteRegExpandStr 	HKCR "$SvgFileClass\${PRODUCT_SHORTNAME}.command.menu\Shell\cmd1\command" "" `"$INSTDIR\inkscapetools.exe" --create-batch=yes "%1"`
  	
; 	!insertmacro UPDATEFILEASSOC

	WriteUninstaller "$INSTDIR\Uninstall.exe"
 
SectionEnd
 
 
;--------------------------------    
;Uninstaller Section  
Section "un.Uninstall"
 
	;Delete Files 
	RMDir /r "$INSTDIR\*.*"    

	;Remove the installation directory
	RMDir "$INSTDIR"

	ReadRegStr $SvgFileClass HKCR ".${EXT}" ""

	StrCmp $SvgFileClass "" notfound
		DeleteRegKey HKCR "$SvgFileClass\Shell\InkscapeToolsMenu"
		Goto done
	notfound:
		; ----
	done:
	
	DeleteRegKey HKCR `${FILECLASS}`

SectionEnd
