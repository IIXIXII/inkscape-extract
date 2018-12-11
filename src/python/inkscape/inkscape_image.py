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
# Core function for inkscape exploration and create batch file for extraction
###############################################################################

import logging
import sys
import os
import os.path
import copy
from bs4 import BeautifulSoup

if (__package__ in [None, '']) and ('.' not in __name__):
    import common
else:
    from . import common

###############################################################################
# The name for the general command
###############################################################################
__INKSCAPE_GENERAL_COMMAND__ = "general_command"

###############################################################################
# The name for the complete image
###############################################################################
__INKSCAPE_IMAGE__ = "image"

###############################################################################
# The name for the command
###############################################################################
__INKSCAPE_COMMAND__ = "command"

###############################################################################
# The name for the picture
###############################################################################
__INKSCAPE_PICTURE__ = "picture"

###############################################################################
# The name for the name of the icon or image
###############################################################################
__INKSCAPE_NAME__ = "name"

###############################################################################
# Find the list of command from the svg
# transform the comand lines from
#   name=value;value; value
#   name2 = value; value
#
# into a dict
#   {name:[value, value], name2:[value, value]}
#
# @param command the command lines
# @param previous_command the previous command lines
# @return commands parsed
###############################################################################
def parse_command(command, previous_command=None):
    result = {}
    if previous_command is not None:
        result = copy.deepcopy(previous_command)

    command = command.replace(' ', '')
    lines = command.splitlines()
    for line in lines:
        split = line.split("=", 1)
        args = ""
        if len(split) > 1:
            args = split[1]
        args = args.split(";")

        name = split[0]
        result[name] = []
        for arg in args:
            if len(arg) > 0:
                result[name].append(arg)

    return result

###############################################################################
# extract the commands part in the svg
#
# @param commands xml comands part
# @return the string with the comands
###############################################################################
def extract_lines_from_xml_element(commands):
    result = ""
    for command in commands:
        command_xml_list = command.find_all("tspan")
        for xcomd in command_xml_list:
            if xcomd.string is not None:
                result += xcomd.string + "\n"

    return result

###############################################################################
# Find Inkscape
#
# @return inkscape exe complete path
###############################################################################
def __find_inkscape():
    logging.info('Search inkscape')

    start_points = ["C:\\Program Files\\Inkscape\\",
                    "./",
                    __get_this_filename(),
                    "D:\\Program Files\\Inkscape\\"]

    relative_paths = ['',
                      'bin',
                      'inkscape',
                      'inkscape/bin',
                      'software/inkscape/bin',
                      'software/inkscape',
                      'software/bin',
                      'software']

    return common.search_for_file("inkscape.exe", start_points,
                                  relative_paths, nb_up_path=4)


def test_find_inkscape():
    assert __find_inkscape() is not None


###############################################################################
# get the inkscape exe
#
# @return inkscape exe complete path
###############################################################################
@common.static(__inkscape_exe__=None)
def get_inkscape():
    if get_inkscape.__inkscape_exe__ is None:
        get_inkscape.__inkscape_exe__ = __find_inkscape()

    return get_inkscape.__inkscape_exe__


def test_get_inkscape():
    assert get_inkscape() is not None


###############################################################################
# Create dos batch command lines for a command line
#
# @param parameters the dict of parameter
# @param cmd the command
# @return the list of dos batch command.
###############################################################################
def generate_batch_lines(cmd, export_type, output_filename, params=None):
    list_params = []
    if params is not None:
        list_params = params

    while len(list_params) < 4:
        list_params.append("")

    output_path = os.path.split(output_filename)[0]

    local_template_folder = common.check_folder(os.path.join(os.path.split(
        __get_this_filename())[0], "template"))

    result = ""
    header_export = common.get_file_content(os.path.join(local_template_folder,
                                                         "header_export.bat"))
    result += header_export.format(OUTPUT_FILENAME=output_filename,
                                   OUTPUT_PATH=output_path,
                                   EXPORT_TYPE=export_type,
                                   PARAM1=list_params[0],
                                   PARAM2=list_params[1],
                                   PARAM3=list_params[2],
                                   PARAM4=list_params[3],
                                   CMD_LINE=cmd)

    return [result]

###############################################################################
# Create dos batch command lines for a command svg
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_svg_from_parameter(parameters, begin_cmd):
    output_filename = "%s.svg" % (common.set_correct_path(os.path.join(
        parameters['output_folder'], parameters['name'])))

    new_cmd_line = '%s --export-plain-svg="%s"' % (
        begin_cmd, output_filename)
    result = []
    result += generate_batch_lines(new_cmd_line,
                                   "SVG", output_filename)

    return result


###############################################################################
# Create dos batch command lines for a command pdf
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_pdf_from_parameter(parameters, begin_cmd):
    output_filename = "%s.pdf" % (common.set_correct_path(os.path.join(
        parameters['output_folder'], parameters['name'])))

    new_cmd_line = '%s  --export-area-drawing --export-pdf="%s"' % (
        begin_cmd, output_filename)
    result = []
    result += generate_batch_lines(new_cmd_line,
                                   "PDF", output_filename)

    return result


###############################################################################
# Create dos batch command lines for a command pdf
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_eps_from_parameter(parameters, begin_cmd):
    output_filename = "%s.eps" % (common.set_correct_path(os.path.join(
        parameters['output_folder'], parameters['name'])))

    new_cmd_line = '%s  --export-eps="%s"' % (
        begin_cmd, output_filename)
    result = []
    result += generate_batch_lines(new_cmd_line,
                                   "EPS", output_filename)

    return result

###############################################################################
# Create dos batch command lines for a command pdf
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_png_trans(unused_parameters, output_png_name,
                        begin_cmd, params):
    output_png_trans = '%s-trans.png' % (output_png_name)
    new_cmd_line = '%s --export-background-opacity="%s" --export-png="%s"' % (
        begin_cmd, "0", output_png_trans)
    new_param = params
    new_param.append("transparent")
    result = []
    result += generate_batch_lines(new_cmd_line, "PNG",
                                   output_png_trans, new_param)

    return result

###############################################################################
# Create dos batch command lines for a command png opacity
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_png_bg_from_parameter(parameters, output_png_name,
                                    begin_cmd, params):
    result = []

    if 'background' in parameters:
        for bgcolor in parameters['background']:
            bg_ext = bgcolor
            bg_ext = bg_ext.lower().replace(',', '-').replace('rgb', '') \
                .replace('(', '').replace(')', '')
            output_png_bg = '%s-bg%s.png' % (output_png_name, bg_ext)
            cmd_line_bg = '%s --export-background="%s"' % (begin_cmd, bgcolor)
            cmd_final = '%s --export-png="%s"' % (
                cmd_line_bg, output_png_bg)

            new_param = params
            new_param.append("BACKGROUND COLOR %s" % bgcolor)
            result += generate_batch_lines(cmd_final, "PNG",
                                           output_png_bg, new_param)
    else:
        output_png = "%s.png" % output_png_name
        cmd_final = '%s --export-png="%s"' % (begin_cmd, output_png)
        result += generate_batch_lines(cmd_final, "PNG",
                                       output_png, params)

    return result


###############################################################################
# Create dos batch command lines for a command png opacity
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_png_bgo(parameters, output_png_name,
                      begin_cmd, params):
    result = []
    if 'background-opacity' in parameters:
        for bg_opacity in parameters['background-opacity']:
            if bg_opacity == "0":
                result += batch_cmd_png_trans(parameters,
                                              output_png_name,
                                              begin_cmd, params)
            else:
                output_png_o = '%s-opacity%s' % (output_png_name,
                                                 bg_opacity.lower())
                cmd_line_bgo = '%s --export-background-opacity="%s"' % (
                    begin_cmd, bg_opacity)
                result += batch_cmd_png_bg_from_parameter(parameters,
                                                          output_png_o,
                                                          cmd_line_bgo,
                                                          params)

    else:
        result += batch_cmd_png_bg_from_parameter(parameters, output_png_name,
                                                  begin_cmd, params)

    return result


###############################################################################
# Create dos batch command lines for a command png
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_png_from_parameter(parameters, begin_cmd):
    output_name = common.set_correct_path(os.path.join(
        parameters['output_folder'], parameters['name']))

    result = []

    if 'height' in parameters:
        for height in parameters['height']:
            output_png_height = '%s-h%s' % (output_name, height)
            cmd_line_height = '%s --export-height="%s"' % (begin_cmd, height)
            result += batch_cmd_png_bgo(parameters,
                                        output_png_height,
                                        cmd_line_height,
                                        ["HEIGHT=%s" % height])

    if 'width' in parameters:
        for width in parameters['width']:
            output_png_width = '%s-w%s' % (output_name, width)
            cmd_line_width = '%s --export-width="%s"' % (begin_cmd, width)
            result += batch_cmd_png_bgo(parameters,
                                        output_png_width,
                                        cmd_line_width,
                                        ["WIDTH=%s" % width])

    if 'dpi' in parameters:
        for dpi in parameters['dpi']:
            output_png_dpi = '%s-dpi%s' % (output_name, dpi)
            cmd_line_dpi = '%s --export-dpi="%s"' % (begin_cmd, dpi)
            result += batch_cmd_png_bgo(parameters,
                                        output_png_dpi,
                                        cmd_line_dpi,
                                        ["DPI=%s" % dpi])

    return result

###############################################################################
# Create dos batch command lines for a command
#
# @param parameters the dict of parameter
# @return the list of dos batch command.
###############################################################################
def batch_cmd_from_parameter(parameters):
    logging.info('For the id=%s create png filename %s execute command',
                 parameters['picture_id'], parameters['filename'])

    begin_cmd = '"%s" -z --export-id="%s" --export-id-only --file="%s" ' % (
        get_inkscape(), parameters['picture_id'], parameters['filename'])

    cmd_list = []

    if 'png' in parameters:
        cmd_list += batch_cmd_png_from_parameter(parameters, begin_cmd)

    if 'eps' in parameters:
        cmd_list += batch_cmd_eps_from_parameter(parameters, begin_cmd)

    if 'pdf' in parameters:
        cmd_list += batch_cmd_pdf_from_parameter(parameters, begin_cmd)

    if 'svg' in parameters:
        cmd_list += batch_cmd_svg_from_parameter(parameters, begin_cmd)

    return cmd_list

###############################################################################
# get the general command from the xml
#
# @param xml_content the xml
# @return the command list.
###############################################################################
def get_general_command(xml_content):
    result = {}
    general_command = xml_content.find_all(
        attrs={"inkscape:label": __INKSCAPE_GENERAL_COMMAND__})
    if len(general_command) > 0:
        logging.info('Find %d general command object', len(general_command))
        result = parse_command(
            extract_lines_from_xml_element(general_command))

    logging.info('Find general_command "%s"', result)

    return result

###############################################################################
# get picture from image
#
# @param xml_content the xml
# @return the command list.
###############################################################################
def get_picture_id_from_img(xml_content):
    pictures = xml_content.find_all(attrs={"inkscape:label": "picture"})

    if len(pictures) != 1:
        logging.error('image id="%s" has too many pictures (%d)',
                      xml_content['id'], len(pictures))
        raise Exception('image id="%s" has too many pictures (%d)' % (
            xml_content['id'], len(pictures)))

    return pictures[0]['id']

###############################################################################
# get name from image
#
# @param xml_content the xml
# @return the command list.
###############################################################################
def get_name_from_img(xml_content):
    names = xml_content.find_all(attrs={"inkscape:label": "name"})

    if len(names) != 1:
        logging.error('image id="%s" has too many names (%d)',
                      xml_content['id'], len(names))
        raise Exception('image id="%s" has too many names (%d)' % (
            xml_content['id'], len(names)))

    name = extract_lines_from_xml_element(names)
    name = name.replace('\n', '').replace('\xa0', '')

    return name


###############################################################################
# get command from image
#
# @param xml_content the xml
# @return the command list.
###############################################################################
def get_command_from_img(xml_content):
    commands = xml_content.find_all(attrs={"inkscape:label": "command"})

    if len(commands) > 1:
        logging.error('image id="%s" has too many commands (%d)',
                      xml_content['id'], len(commands))
        raise Exception('image id="%s" has too many commands (%d)' % (
            xml_content['id'], len(commands)))

    return extract_lines_from_xml_element(commands)

###############################################################################
# get output param from command
#
# @param xml_content the xml
# @param svg_filename the inkscape file
# @return the command list.
###############################################################################
def get_output_folder_parameter(command, svg_filename):
    output_folder = os.path.split(svg_filename)[0]

    if 'output_folder' not in command:
        return output_folder

    if len(command['output_folder']) != 1:
        logging.error('output_folder has too many instruction (%d)',
                      len(command['output_folder']))
        raise Exception('output_folder has too many instruction (%d)' % (
            len(command['output_folder'])))

    if os.path.isabs(command['output_folder'][0]):
        return command['output_folder'][0]

    return os.path.join(output_folder, command['output_folder'][0])


###############################################################################
# get the commands from the svg file
#
# @exception RuntimeError if the name is not an inkscape or if the extension
#                         is not correct
#
# @param filename the file name
# @return the command list.
###############################################################################
def get_commands_from_inkscape_file(filename):
    logging.info('Find command from the filename %s', filename)
    filename = check_is_inkscape_file(filename)

    result = {}

    svg_file = BeautifulSoup(common.get_file_content(filename), "lxml")

    general_command = get_general_command(svg_file)

    list_image = svg_file.find_all(attrs={"inkscape:label": "image"})
    logging.info('Find %d images', len(list_image))

    for img in list_image:
        logging.info('Find image id %s', img['id'])
        picture_id = get_picture_id_from_img(img)
        name = get_name_from_img(img)
        command = get_command_from_img(img)

        parse_cmd = parse_command(command, general_command)

        logging.debug('Find command "%s"', command)
        logging.debug('Find name "%s"', name)
        logging.debug('Find picture id "%s"', picture_id)
        logging.debug('Find parse_cmd "%s"', parse_cmd)

        result[picture_id] = copy.deepcopy(parse_cmd)
        result[picture_id]['name'] = name
        result[picture_id]['filename'] = filename
        result[picture_id]['output_folder'] = \
            get_output_folder_parameter(parse_cmd, filename)
        result[picture_id]['picture_id'] = picture_id

    return result

###############################################################################
# create the batch file from the svg file
#
# @exception RuntimeError if the name is not an inkscape or if the extension
#                         is not correct
#
# @param filename the file name
# @return the command list.
###############################################################################
def create_batch_from_inkscape_file(filename):
    '''
    This function take a file, load the content, create a batch filename
    with the same name and another extension.

    @type filename: string
    @param filename: The name and path of the file to work with.
                     This file is supposed to be a inkscape file.
    @return nothing
    '''
    filename = common.check_is_file_and_correct_path(filename)
    short_filename = os.path.split(filename)[1]
    filename_path = os.path.split(filename)[0]
    parameters_list = get_commands_from_inkscape_file(filename)
    nb_image = len(parameters_list)

    local_template_folder = common.check_folder(os.path.join(os.path.split(
        __get_this_filename())[0], "template"))

    result = ""
    header = common.get_file_content(os.path.join(local_template_folder,
                                                  "header.bat"))
    result += header.format(NB_IMAGE=nb_image,
                            FILENAME=short_filename,
                            FILENAME_PATH=filename_path)

    for parameters in parameters_list:
        batch_list = batch_cmd_from_parameter(parameters_list[parameters])
        nb_export = len(batch_list)
        header_img = common.get_file_content(
            os.path.join(local_template_folder,
                         "header_img.bat"))
        result += header_img.format(NB_EXPORT=nb_export)
        for cmd in batch_list:
            result += cmd

    common.set_file_content(filename + ".gen.bat", result)
    return result

###############################################################################
# test if the fiel is an inkscape file
#
# @exception RuntimeError if the name is not an inkscape or if the extension
#                         is not correct
#
# @param filename the file name
# @return true if the file is good.
###############################################################################
def check_is_inkscape_file(filename):
    filename = common.check_is_file_and_correct_path(filename, ".svg")

    svg_file = BeautifulSoup(common.get_file_content(filename), "lxml")

    pass_test = svg_file.svg['xmlns:inkscape'] == \
        "http://www.inkscape.org/namespaces/inkscape"

    if not pass_test:
        logging.error('%s is not an inkscape filename', filename)
        raise RuntimeError('%s is not an inkscape filename' % filename)

    return filename


def test_check_is_inkscape_file():
    local_path = os.path.split(__get_this_filename())[0]
    file1 = os.path.join(local_path, "test-svg", "test1.svg")
    assert check_is_inkscape_file(file1)


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
# Set up the logging system
###############################################################################
def __set_logging_system():
    log_filename = os.path.splitext(os.path.abspath(
        os.path.realpath(__get_this_filename())))[0] + '.log'
    logging.basicConfig(filename=log_filename, level=logging.DEBUG,
                        format='%(asctime)s: %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    # set a format which is simpler for console use
    formatter = logging.Formatter('%(asctime)s: %(levelname)-8s %(message)s')
    # tell the handler to use this format
    console.setFormatter(formatter)
    # add the handler to the root logger
    logging.getLogger('').addHandler(console)


###############################################################################
# Launch the test
###############################################################################
def __launch_test():
    import pytest
    pytest.main(__get_this_filename())


###############################################################################
# Main script call only if this script is runned directly
###############################################################################
def __main():
    # ------------------------------------
    logging.info('Started %s', __get_this_filename())
    logging.info('The Python version is %s.%s.%s',
                 sys.version_info[0], sys.version_info[1], sys.version_info[2])

    local_path = os.path.split(__get_this_filename())[0]
    file1 = os.path.join(local_path, "test-svg", "test1.svg")

    create_batch_from_inkscape_file(file1)

    logging.info('Finished')
    # ------------------------------------


###############################################################################
# Call main function if the script is main
# Exec only if this script is runned directly
###############################################################################
if __name__ == '__main__':
    __set_logging_system()
    __main()
