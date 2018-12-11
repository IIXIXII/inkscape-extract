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

###############################################################################
# @package inkscape extract
#
###############################################################################

import logging
import sys
import os
import traceback
import argparse
import tempfile
import ctypes  # An included library with Python install.

from inkscape import create_batch_from_inkscape_file


__actions_list__ = {}
__actions_list__['create_batch'] = create_batch_from_inkscape_file

###############################################################################
# Test the frozen situation of the executable
###############################################################################
def is_frozen():
    return getattr(sys, 'frozen', False)


###############################################################################
# Change the std stream in the frozen case
###############################################################################
if is_frozen():
    class DummyStream:
        ''' DummyStream behaves like a stream but does nothing. '''

        def __init__(self):
            pass

        def write(self, data):
            pass

        def read(self, data):
            pass

        def flush(self):
            pass

        def close(self):
            pass

    # and now redirect all default streams to this DummyStream:
    sys.stdout = DummyStream()
    sys.stderr = DummyStream()
    sys.stdin = DummyStream()
    sys.__stdout__ = DummyStream()
    sys.__stderr__ = DummyStream()
    sys.__stdin__ = DummyStream()


###############################################################################
# Find the filename of this file (depend on the frozen or not)
# This function return the filename of this script.
# The function is complex for the frozen system
#
# @return the filename of THIS script.
###############################################################################
def __get_this_filename():
    result = ""
    if getattr(sys, 'frozen', False):
        # frozen
        result = sys.executable
    else:
        # unfrozen
        result = __file__
    return result

###############################################################################
# Create a windows message box
#
# @param text The message
# @param title The title of the windows
# @return nothing.
###############################################################################
def message_box(text, title):
    ctypes.windll.user32.MessageBoxW(0, text, title, 0)


###############################################################################
# Define the parsing of arguments of the command line
###############################################################################
def get_parser_for_command_line():
    docstring = ""
    for action in __actions_list__:
        docstring = docstring + action + ":\n" + \
            __actions_list__[action].__doc__.split("@")[0][0:-3] + "\n\n"

    description = \
        """This program take a list of markdown file(s)
and could apply one action.

""" + docstring

    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('--create-batch', action='store', dest='create_batch',
                        choices=['yes', 'no'], default='yes',
                        help='Create the batch to generate images')
    parser.add_argument('--windows', action='store', dest='windows',
                        choices=['yes', 'no'], default='yes',
                        help='Define if we need all popups windows.')
    parser.add_argument('--verbose', action='store', dest='verbose',
                        choices=['yes', 'no'], default='no',
                        help='Put the logging system on the console for info.')
    parser.add_argument('filenames', metavar='filename',
                        nargs='+',
                        help='list of filenames.')

    return parser

###############################################################################
# Logging system
###############################################################################
def __set_logging_system():
    log_filename = os.path.splitext(os.path.abspath(
        os.path.realpath(__get_this_filename())))[0] + '.log'

    if is_frozen():
        log_filename = os.path.abspath(os.path.join(
            tempfile.gettempdir(),
            os.path.basename(__get_this_filename()) + '.log'))

    logging.basicConfig(filename=log_filename, level=logging.INFO,
                        format='%(asctime)s: %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    console = logging.StreamHandler()
    console.setLevel(logging.ERROR)

    # set a format which is simpler for console use
    formatter = logging.Formatter('%(asctime)s: %(levelname)-8s %(message)s')
    # tell the handler to use this format
    console.setFormatter(formatter)
    # add the handler to the root logger
    logging.getLogger('').addHandler(console)

    return console


###############################################################################
# Main script
###############################################################################
def __main():
    console = __set_logging_system()
    # ------------------------------------
    logging.info('+')
    logging.info('-------------------------------------------------------->>')
    logging.info('Started %s', __get_this_filename())
    logging.info('The Python version is %s.%s.%s',
                 sys.version_info[0], sys.version_info[1], sys.version_info[2])

    try:
        parser = get_parser_for_command_line()
        logging.info("parsing args")
        args = parser.parse_args()
        logging.info("parsing done")
        if args.verbose == "yes":
            console.setLevel(logging.INFO)

        args.windows_bool = (args.windows == "yes")
        args.create_batch_bool = (args.create_batch == "yes")

        logging.info("verbose=%s", args.verbose)
        logging.info("filenames=%s", repr(args.filenames))
        logging.info("create-batch=%s", args.create_batch)

        count = 1
        max_count = len(args.filenames)

        error_msg = []

        for filename in args.filenames:
            logging.info(">>> Working on %03d / %03d : %s",
                         count, max_count, filename)
            count = count + 1
            try:
                local_filename = filename
                if ('args' in locals()) and (args.create_batch_bool):
                    create_batch_from_inkscape_file(local_filename)

            except Exception as ex:
                var = traceback.format_exc()
                logging.error('Unknown error : %s\n', var)
                # accumulate all error
                error_msg.append((filename, str(ex)))

        if len(error_msg) > 0:
            msg = "The following error(s) appends "\
                "during all the process : \r\n\r\n"
            for err in error_msg:
                msg = msg + \
                    "For filename=%s the following error append '%s'\r\n" % (
                        err[0], err[1])
            msg = msg + "\n\n No others errors appends on others files.\r\n"
            raise Exception(msg)

    except argparse.ArgumentError as errmsg:
        logging.error(str(errmsg))
        if ('args' in locals()) and (args.windows_bool):
            message_box(text=parser.format_usage(), title='Usage')

    except SystemExit:
        if ('args' in locals()) and (args.windows_bool):
            message_box(text=parser.format_help(), title='Help')

    except Exception as ex:
        logging.error(str(ex))
        if ('args' in locals()) and (args.windows_bool):
            message_box(text=str(ex), title='Usage')

    except:
        var = traceback.format_exc()
        logging.error('Unknown error : %s\n', var)
        if ('args' in locals()) and (args.windows_bool):
            message_box(text='Unknown error : \n' + var,
                        title='Error in this program')
        # raise

    logging.info('Finished')
    logging.info('<<--------------------------------------------------------')
    logging.info('+')
    # ------------------------------------


# -----------------------------------------------------------------------------
# Call main if the script is main
# -----------------------------------------------------------------------------
if __name__ == '__main__':
    __main()
