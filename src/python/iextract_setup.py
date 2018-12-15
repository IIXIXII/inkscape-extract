#!/usr/bin/env python
# -*- coding: utf-8 -*-
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
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
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
#
# invoke using:
#   python setup.py build
#
###############################################################################

import sys
import os
import os.path
import shutil

from cx_Freeze import setup, Executable


# Remove the existing folders folder
shutil.rmtree("build", ignore_errors=True)
shutil.rmtree("dist", ignore_errors=True)

sys.path.append(os.path.dirname(__file__))

###############################################################################
# Here is a list of the Executable options
###############################################################################
#
# "script":
#       the name of the file containing the script which is to be frozen
#
# "initScript":
#       the name of the initialization script that will be executed before
#       the actual script is executed; this script is used to set up the
#       environment for the executable; if a name is given without an absolute
#       path the names of files in the initscripts subdirectory of
#       the cx_Freeze package is searched
#
# "base":
#       the name of the base executable;
#       if a name is given without an absolute path the names of files
#       in the bases subdirectory of the cx_Freeze package is searched
#
# "path":
#       list of paths to search for modules
#
# "targetDir":
#       the directory in which to place the target executable
#       and any dependent files
#
# "targetName":
#       the name of the target executable; the default value is the name
#       of the script with the extension exchanged with the extension
#       for the base executable
#
# "includes":
#       list of names of modules to include
#
# "excludes":
#       list of names of modules to exclude
#
# "packages":
#       list of names of packages to include, including all
#       of the package's submodules
#
# "replacePaths":
#       Modify filenames attached to code objects, which appear
#       in tracebacks. Pass a list of 2-tuples containing paths to
#       search for and corresponding replacement values. A search for
#       '*' will match the directory containing the entire package,
#       leaving just the relative path to the module.
#
# "compress":
#       boolean value indicating if the module bytecode
#       should be compressed or not
#
# "copyDependentFiles":
#       boolean value indicating if dependent files should be
#       copied to the target directory or not
#
# "appendScriptToExe":
#       boolean value indicating if the script module should be
#       appended to the executable itself
#
# "appendScriptToLibrary":
#       boolean value indicating if the script module should be
#       appended to the shared library zipfile
#
# "icon":
#       name of icon which should be included in the executable
#       itself on Windows or placed in the target directory
#       for other platforms
#
# "namespacePackages":
#       list of packages to be treated as namespace packages
#       (path is extended using pkgutil)
#
# "shortcutName":
#       the name to give a shortcut for the executable when
#       included in an MSI package
#
# "shortcutDir":
#       the directory in which to place the shortcut when being
#       installed by an MSI package; see the MSI Shortcut table
#       documentation for more information on what values
#       can be placed here.
#
###############################################################################
MY_TARGET_EXE = Executable(
    # what to build
    script="iextract.py",
    initScript=None,
    # base='Win32GUI',
    base='Console',
    #  targetDir = r"dist",
    targetName="inkscape_extract.exe",
    #  compress = True,
    #  copyDependentFiles = True,
    #  appendScriptToExe = False,
    #  appendScriptToLibrary = False,
    icon=os.path.join(os.path.dirname(__file__), '..',
                      'nsis', 'icon', 'inkscape.ico'),
    trademarks="Florent Tournois @2017"
)

###############################################################################
# Here is a list of the build_exe options
###############################################################################
# 1) append the script module to the executable
APPEND_SCRIPT_TO_EXE = False
# 2) the name of the base executable to use which, if given as a relative
#       path, will be joined with the bases subdirectory of the cx_Freeze
#       installation; the default value is "Console"
BASE = "Console"
# 3) list of names of files to exclude when determining dependencies of
#       binary files that would normally be included; note that version
#       numbers that normally follow the shared object extension are
#       stripped prior to performing the comparison
BIN_EXCLUDES = []
# 4) list of names of files to include when determining dependencies of
#       binary files that would normally be excluded; note that version
#       numbers that normally follow the shared object extension are
#       stripped prior to performing the comparison
BIN_INCLUDES = []
# 5) list of paths from which to exclude files when determining
#       dependencies of binary files
BIN_PATH_EXCLUDES = []
# 6) list of paths from which to include files when determining
#       dependencies of binary files
BIN_PATH_INCLUDES = []
# 7) directory for built executables and dependent files,
#       defaults to build/
BUILD_EXE = "../../distribution/"
# 8) create a compressed zip file
COMPRESSED = False
# 9) comma separated list of constant values to include in the constants
#       module called BUILD_CONSTANTS in form <name>=<value>
CONSTANTS = []
# 10) copy all dependent files
COPY_DEPENDENT_FILES = True
# 11) create a shared zip file called library.zip which will contain
#       all modules shared by all executables which are built
CREATE_SHARED_ZIP = True
# 12) comma separated list of names of modules to exclude
EXCLUDES = ['Tkinter', 'email', 'unittest']
# 13) include the icon in the frozen executables on the Windows
#       platform and alongside the frozen executable on other platforms
ICON = os.path.join(os.path.dirname(__file__), '..',
                    'packaging', 'icon', 'ge.ico')
# 13) comma separated list of names of modules to include
INCLUDES = ['inkscape', 'lxml', 'bs4']
# 15) list containing files to be copied to the target directory;
#       it is expected that this list will contain strings or
#           2-tuples for the source and destination;
#       the source can be a file or a directory (in which case
#           the tree is copied except for .svn and CVS directories);
#       the target must not be an absolute path
#
# NOTE: INCLUDE FILES MUST BE OF THIS FORM OTHERWISE freezer.py line
#       128 WILL TRY AND DELETE dist/. AND FAIL!!!
# Here is a list of ALL the DLLs that are included in Python27\Scripts
INCLUDE_FILES = [
    ("inkscape\\template\\", "template\\"),
]
# 16) include the script module in the shared zip file
INCLUDE_IN_SHARED_ZIP = True
# 17) include the Microsoft Visual C runtime DLLs and (if necessary)
#       the manifest file required to run the executable without
#       needing the redistributable package installed
INCLUDE_MSVCR = False
# 18) the name of the script to use during initialization which,
#       if given as a relative path, will be joined with the initscripts
#       subdirectory of the cx_Freeze installation;
#       the default value is "Console"
INIT_SCRIPT = ""
# 19) comma separated list of packages to be treated as
#       namespace packages (path is extended using pkgutil)
NAMESPACE_PACKAGES = []
# 20) optimization level, one of 0 (disabled), 1 or 2
OPTIMIZE = 0
# 21) comma separated list of packages to include, which includes
#       all submodules in the package
PACKAGES = ['lxml', 'gzip']
# 22) comma separated list of paths to search; the default value is sys.path
PATH = sys.path + [os.path.dirname(__file__)]
# 23) Modify filenames attached to code objects, which appear in tracebacks.
#       Pass a comma separated list of paths in the form <search>=<replace>.
#       The value * in the search portion will match the directory
#       containing the entire package, leaving just the
#       relative path to the module.
REPLACE_PATHS = []
# 24) suppress all output except warnings
SILENT = False
# 25) list containing files to be included in the zip file directory;
#       it is expected that this list will contain strings or
#       2-tuples for the source and destination
ZIP_INCLUDES = []


LOCAL_OPTIONS = {
    #                            "append_script_to_exe": APPEND_SCRIPT_TO_EXE,
    #                            "base":                 BASE,
    #                            "bin_excludes":         BIN_EXCLUDES,
    #                            "bin_includes":         BIN_INCLUDES,
    #                            "bin_path_excludes":    BIN_PATH_EXCLUDES,
    #                            "bin_path_includes":    BIN_PATH_INCLUDES,
    "build_exe": BUILD_EXE,
    #  "compressed":           COMPRESSED,
    #                            "constants":            CONSTANTS,
    #  "copy_dependent_files": COPY_DEPENDENT_FILES,
    #                            "create_shared_zip":    CREATE_SHARED_ZIP,
    "excludes": EXCLUDES,
    #  "icon":                 ICON,
    "includes": INCLUDES,
    "include_files": INCLUDE_FILES,
    #                            "include_in_shared_zip":INCLUDE_IN_SHARED_ZIP,
    #                            "include_msvcr":        INCLUDE_MSVCR,
    #                            "init_script":          INIT_SCRIPT,
    #                            "namespace_packages":   NAMESPACE_PACKAGES,
    #                            "optimize":             OPTIMIZE,
    "packages": PACKAGES,
    "path": PATH,
    #                            "replace_paths":        REPLACE_PATHS,
    #                            "silent":               SILENT,
    #                            "zip_includes":         ZIP_INCLUDES,
}

setup(
    name="Inkscape Extract",
    version="0.1",
    description="Inkscape Extract",
    author="Florent Tournois",
    options={"build_exe": LOCAL_OPTIONS},
    executables=[MY_TARGET_EXE]
)
