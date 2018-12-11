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
# Standard commonfunction are here.
###############################################################################

import logging
import sys
import os
import os.path
import shutil
import codecs
import tempfile
import time

###############################################################################
# define a static decorator for function
#
# \code{.py}
# @static(__folder_md_test__=None)
# def get_test_folder():
#     if get_test_folder.__folder_md_test__ is None:
#         get_test_folder.__folder_md_test__ = check_folder(os.path.join(
#             os.path.split(__get_this_filename())[0], "test-md"))

#     return get_test_folder.__folder_md_test__
# \endcode
#
# @param kwargs list of arguments
# @return the wrap function
###############################################################################
def static(**kwargs):
    def wrap(the_decorated_function):
        for key, value in kwargs.items():
            setattr(the_decorated_function, key, value)
        return the_decorated_function
    return wrap


###############################################################################
# Retrive the correct complet path
# This function return a folder or filename with a standard way of writing.
#
# @param folder_or_file_name the folder or file name
# @return the folder or filename normalized.
###############################################################################
def set_correct_path(folder_or_file_name):
    return os.path.abspath(folder_or_file_name)

def test_set_correct_path():
    # ~ current_dir = os.path.split(__get_this_filename())[0]
    # ~ root = os.path.abspath(os.path.join(current_dir, "./../../"))
    # ~ assert set_correct_path(current_dir + "/././../") == root + "\\python"
    # ~ assert set_correct_path(current_dir + "/././../../") == root
    assert set_correct_path("C:/") == "C:\\"


###############################################################################
#  def create_test_set_correct_path():
    #  test_list=[]
    #  test_list.append(__file__)
    #  test_list.append("./")
    #  test_list.append("././../")
    #  test_list.append("././../../")
    #  test_list.append("C:/")

    #  for t in test_list:
    #  print('\tassert(set_correct_path("%s") == "%s")'%(t,
    #             set_correct_path(t).replace("\\","\\\\")))

###############################################################################
# Test a folder
# Test if the folder exist.
#
# @exception RuntimeError if the name is a file or not a folder
#
# @param folder the folder name
# @return the folder normalized.
###############################################################################
def check_folder(folder):
    if os.path.isfile(folder):
        logging.error('%s can not be a folder (it is a file)', folder)
        raise RuntimeError('%s can not be a folder (it is a file)' % folder)

    if not os.path.isdir(folder):
        logging.error('%s is not a folder', folder)
        raise RuntimeError('%s is not a folder' % folder)

    return set_correct_path(folder)

def test_check_folder():
    # ~ current_dir = os.path.split(__get_this_filename())[0]
    # ~ root = os.path.abspath(os.path.join(current_dir, "./../../"))
    # ~ assert check_folder(current_dir + "/././../") == root + "\\python"
    # ~ assert check_folder(current_dir + "/././../../") == root
    assert check_folder("C:/") == "C:\\"

    import pytest
    with pytest.raises(RuntimeError):
        check_folder(__file__)
    with pytest.raises(RuntimeError):
        check_folder("AA:/")

#  def create_test_check_folder():
    #  test_list=[]
    #  test_list.append("./")
    #  test_list.append("././../")
    #  test_list.append("././../../")
    #  test_list.append("C:/")

    #  test_list_exception=[]
    #  test_list_exception.append(__file__)
    #  test_list_exception.append("AA:/")

    #  for t in test_list:
        #  print('\tassert(check_folder("%s") == "%s")'%(t,
        #              set_correct_path(t).replace("\\","\\\\")))

    #  for t in test_list_exception:
        #  print('\twith pytest.raises(RuntimeError):\n'
        #        '\t\tassert check_folder("FFF%s") == "%s"'
        #        ''%(t,set_correct_path(t).replace("\\","\\\\")))


###############################################################################
# Test a folder
# test if the folder exist and create it if possible and necessary.
#
# @exception RuntimeError if the name is a file
#
# @param folder the folder name
# @return the folder normalized.
###############################################################################
def check_create_folder(folder):
    if os.path.isfile(folder):
        logging.error('%s can not be a folder (it is a file)', folder)
        raise RuntimeError('%s can not be a folder (it is a file)' % folder)

    if not os.path.isdir(folder):
        os.makedirs(folder, exist_ok=True)

    return set_correct_path(folder)

def test_check_create_folder():
    import pytest

    current_folder = os.path.abspath("./")
    assert check_create_folder("./") == current_folder

    random_name = '.{}'.format(hash(os.times()))
    test_foldername = "./" + random_name

    with pytest.raises(RuntimeError):
        check_folder(test_foldername)
    assert check_create_folder(
        test_foldername) == os.path.abspath(test_foldername)
    assert check_folder(test_foldername) == os.path.abspath(test_foldername)

    os.rmdir(test_foldername)
    with pytest.raises(RuntimeError):
        check_folder(test_foldername)

    with pytest.raises(RuntimeError):
        check_create_folder(__file__)


###############################################################################
# test if this is a file and correct the path
#
# @exception RuntimeError if the name is not a file or if the extension
#                         is not correct
#
# @param filename the file name
# @param filename_ext the file name extension like ".ext" or ".md"
# @return the filename normalized.
###############################################################################
def check_is_file_and_correct_path(filename, filename_ext=None):
    filename = set_correct_path(filename)

    if not os.path.isfile(filename):
        logging.error('"%s" is not a file', (filename))
        raise Exception('"%s" is not a file' % (filename))

    current_ext = os.path.splitext(filename)[1]
    if (filename_ext is not None) and (current_ext != filename_ext):

        raise Exception('The extension of the file %s '
                        'is %s and not %s as expected.' % (
                            filename, current_ext, filename_ext))

    return filename

def test_check_is_file_and_correct():
    import pytest

    random_name = '.{}'.format(hash(os.times()))
    test_filename = "./" + random_name + ".txt"

    with pytest.raises(RuntimeError):
        check_folder(test_filename)

    assert check_is_file_and_correct_path(
        __get_this_filename()) == os.path.abspath(__get_this_filename())

###############################################################################
# get the number of subfolder in an path
#
# @param filename the filename
# @return the value
###############################################################################
def number_of_subfolder(filename):
    name = os.path.normpath(filename)

    counter = -1
    counter_max = 100
    while (name != os.path.split(name)[0]) and (counter < counter_max):
        name = os.path.split(name)[0]
        counter += 1

    if counter >= counter_max:
        logging.error('Can not count the number of subfolder '
                      'in the filename %s.', filename)
        raise RuntimeError('Can not count the number of subfolder '
                           'in the filename %s.' % filename)

    return max(counter, 0)

def test_number_of_subfolder():
    import pytest

    assert number_of_subfolder("A/B") == 1
    assert number_of_subfolder("A/////B") == 1
    assert number_of_subfolder("A\\\\B") == 1
    assert number_of_subfolder("/A/B") == 1
    assert number_of_subfolder("//A/////B") == 1
    assert number_of_subfolder("//A\\\\B") == 1

###############################################################################
# Create a backup of a file in the same folder with an extension .xxx.bak
#
#
# @exception RuntimeError a new filename for the backup cannot be found
#
# @param filename the file name
# @param backup_ext the backup file name extension like ".bak"
# @return the backup filename normalized.
###############################################################################
def create_backup(filename, backup_ext=".bak"):
    logging.info('Create the backup file for %s', filename)

    filename = check_is_file_and_correct_path(filename)

    count = 0
    nb_max = 100

    today = get_today()
    new_filename = "%s.%s-%03d%s" % (filename, today, count, backup_ext)

    while (os.path.isfile(new_filename)) and (count < nb_max):
        count = count + 1
        new_filename = "%s.%s-%03d%s" % (filename, today, count, backup_ext)

    if count >= nb_max:
        logging.error('Can not find a backup filename for %s', (filename))
        raise Exception('Can not find a backup filename for %s' % (filename))

    logging.info('Backup filename %s to %s', filename, new_filename)
    shutil.copyfile(filename, new_filename)

    return new_filename

def test_create_backup():
    import pytest

    random_name = '.{}'.format(hash(os.times()))
    test_filename = "./" + random_name + ".txt"

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename)

    file_content = "Test"

    # create the file
    output_file = codecs.open(test_filename, "w", encoding="utf-8")
    output_file.write(file_content)
    output_file.close()

    assert(check_is_file_and_correct_path(
        test_filename) == os.path.abspath(test_filename))

    today = get_today()
    bak1 = os.path.abspath("./" + test_filename + "." + today + "-000.bak")
    bak2 = os.path.abspath("./" + test_filename + "." + today + "-001.bak")

    if os.path.isfile(bak1):
        os.remove(bak1)
    if os.path.isfile(bak2):
        os.remove(bak2)

    with pytest.raises(Exception):
        check_is_file_and_correct_path(bak1)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(bak2)

    assert create_backup(test_filename) == bak1
    assert create_backup(test_filename) == bak2
    assert check_is_file_and_correct_path(bak1) == os.path.abspath(bak1)
    assert check_is_file_and_correct_path(bak2) == os.path.abspath(bak2)

    input_file = codecs.open(bak1, mode="r", encoding="utf-8")
    content_bak1 = input_file.read()
    input_file.close()

    input_file = codecs.open(bak2, mode="r", encoding="utf-8")
    content_bak2 = input_file.read()
    input_file.close()

    assert file_content == content_bak1
    assert file_content == content_bak2

    if os.path.isfile(bak1):
        os.remove(bak1)
    if os.path.isfile(bak2):
        os.remove(bak2)

    with pytest.raises(Exception):
        check_is_file_and_correct_path(bak1)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(bak2)

    if os.path.isfile(test_filename):
        os.remove(test_filename)

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename)


###############################################################################
# Get the content of a file. This function delete the BOM.
#
# @param filename the file name
# @param encoding the encoding of the file
# @return the content
###############################################################################
def get_file_content(filename, encoding="utf-8"):
    logging.debug('Get content of the filename %s', (filename))
    filename = check_is_file_and_correct_path(filename)

    # Read the file
    input_file = codecs.open(filename, mode="r", encoding=encoding)
    content = input_file.read()
    input_file.close()

    if content.startswith(u'\ufeff'):
        content = content[1:]

    return content

def test_get_file_content():
    import pytest

    random_name = '.{}'.format(hash(os.times()))
    test_filename_1 = "./" + random_name + "1.txt"
    test_filename_2 = "./" + random_name + "2.txt"

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename_1)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename_2)

    file_content = "Test"

    # create the file
    output_file = codecs.open(test_filename_1, "w", encoding="utf-8")
    output_file.write(file_content)
    output_file.close()
    # create the file
    output_file = codecs.open(test_filename_2, "w", encoding="utf-8")
    output_file.write(u'\ufeff' + file_content)
    output_file.close()

    assert check_is_file_and_correct_path(
        test_filename_1) == os.path.abspath(test_filename_1)
    assert check_is_file_and_correct_path(
        test_filename_2) == os.path.abspath(test_filename_2)

    assert get_file_content(test_filename_1) == file_content
    assert get_file_content(test_filename_2) == file_content

    if os.path.isfile(test_filename_1):
        os.remove(test_filename_1)
    if os.path.isfile(test_filename_2):
        os.remove(test_filename_2)

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename_2)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename_2)


###############################################################################
# Set the content of a file. This function create a BOM in the UTF-8 encoding.
# This function create the file or overwrite the file.
#
# @param filename the file name
# @param content the content
# @param encoding the encoding of the file
# @return filename corrected
###############################################################################
def set_file_content(filename, content, encoding="utf-8"):
    logging.debug('Ser content of the filename %s', (filename))
    filename = set_correct_path(filename)

    output_file = codecs.open(filename, "w", encoding=encoding)

    if (not content.startswith(u'\ufeff')) and (encoding == "utf-8"):
        output_file.write(u'\ufeff')

    output_file.write(content)
    output_file.close()

    return filename

def test_set_file_content():
    import pytest

    random_name = '.{}'.format(hash(os.times()))
    test_filename1 = "./" + random_name + "1.txt"
    test_filename2 = "./" + random_name + "2.txt"

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename1)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename2)

    file_content = "Test"

    # create the file
    output_file = codecs.open(test_filename1, "w", encoding="utf-8")
    output_file.write(file_content)
    output_file.close()

    assert set_file_content(
        test_filename1, file_content) == os.path.abspath(test_filename1)
    assert set_file_content(
        test_filename2, file_content) == os.path.abspath(test_filename2)

    input_file = codecs.open(test_filename1, mode="r", encoding="utf-8")
    content_file1 = input_file.read()
    input_file.close()

    input_file = codecs.open(test_filename2, mode="r", encoding="utf-8")
    content_file2 = input_file.read()
    input_file.close()

    assert content_file1 == u'\ufeff' + file_content
    assert content_file2 == u'\ufeff' + file_content

    if os.path.isfile(test_filename1):
        os.remove(test_filename1)
    if os.path.isfile(test_filename2):
        os.remove(test_filename2)

    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename2)
    with pytest.raises(Exception):
        check_is_file_and_correct_path(test_filename2)


###############################################################################
# Transform a string to be a good filename for windows
#
# @param filename the file name
# @param char_to_replace the special char to replace
# @param replacement the replacement char ("_" for example)
# @return the right filename
###############################################################################
def get_good_filename(filename,
                      char_to_replace=r'[\\/*?:"<>|()]', replacement="_"):
    import re
    name = re.sub(char_to_replace, replacement, filename)
    return name

#  def create_test_get_good_filename():
    #  test_list=[]
    #  test_list.append(__file__)
    #  test_list.append("KJYKG78-(ç-èç756_(-'è('37('9èçè_-ç_è-")
    #  test_list.append("/.?:;,§/;,MLjkML;,!:;,")
    #  test_list.append("/.?:;,§/;,MLjkML;,!:;,")
    #  test_list.append("/.?:;,§/;,MLjkML;,!èè````'':;,")

    #  for t in test_list:
    #  print('\tassert get_good_filename("%s") == "%s"'
    #        ''%(t,get_good_filename(t).replace("\\","\\\\")))

def test_get_good_filename():
    assert get_good_filename("common.py") == "common.py"
    assert get_good_filename(
        "/.?:;,§/;,MLjkML;,!:;,") == "_.__;,§_;,MLjkML;,!_;,"
    assert get_good_filename(
        "/.?:;,§/;,MLjkML;,!:;,") == "_.__;,§_;,MLjkML;,!_;,"
    assert get_good_filename(
        "/.?:;,§/;,MLjkML;,!èè````'':;,") == "_.__;,§_;,MLjkML;,!èè````''_;,"


###############################################################################
# Create a temproray folder in an appropriate temp area
#
# @return A empty folder located in a temp area
###############################################################################
def get_new_temp_dir():
    tmp_start = os.path.join(tempfile.gettempdir(),
                             get_good_filename('.{}'.format(hash(os.times()))))

    count = 0
    nb_max = 100

    new_tmp = "%s.%03d" % (tmp_start, count)

    while (os.path.isdir(new_tmp)) and (count < nb_max):
        count = count + 1
        new_tmp = "%s.%03d" % (tmp_start, count)

    if count >= nb_max:
        logging.error('Can not find a temp dir')
        raise Exception('Can not find a temp dir')

    logging.info('Create temp dir %s', new_tmp)
    os.makedirs(new_tmp)

    return new_tmp

def test_get_new_temp_dir():
    import pytest
    temp1 = get_new_temp_dir()
    temp2 = get_new_temp_dir()

    assert temp1 != temp2
    assert check_folder(temp1) == os.path.abspath(temp1)
    assert check_folder(temp2) == os.path.abspath(temp2)

    assert len(os.listdir(temp1)) == 0
    assert len(os.listdir(temp2)) == 0

    if os.path.isdir(temp1):
        os.rmdir(temp1)
    if os.path.isdir(temp2):
        os.rmdir(temp2)

    with pytest.raises(RuntimeError):
        check_folder(temp1)
    with pytest.raises(RuntimeError):
        check_folder(temp2)


###############################################################################
# Get today date
#
# @return a string "YYYY-MM-DD"
###############################################################################
def get_today():
    return time.strftime("%Y-%m-%d", time.gmtime())


def test_get_today():
    assert len(get_today()) == 10
    assert get_today()[4] == "-"
    assert get_today()[7] == "-"


###############################################################################
# Find a file with a deep search
# the search is like this
# 	for begin_path in start_points:
# 		for number_of_parent_path in [0; nb_up_path]:
# 			for relative_path in relative_paths:
#    			Search in begin_path/((../)*number_of_parent_path)/relative_paths
# return the first file found
#
# @param file_wanted the filename we are looking for.
# @param start_points the absolute path to some potential
#                     beginning of the search.
# @param relative_paths potential relative path to search for
# @param nb_up_path up path to search
# @return full path to the seached file
###############################################################################
def search_for_file(file_wanted, start_points, relative_paths, nb_up_path=4):
    logging.info('Search for the file %s', file_wanted)

    result = []

    for begin_path in start_points:
        for num_up in range(0, nb_up_path):
            for relative_path in relative_paths:
                file_to_test = set_correct_path(os.path.join(
                    begin_path, "../" * num_up, relative_path, file_wanted))
                if os.path.isfile(file_to_test):
                    logging.info('Found the file %s', (file_to_test))
                    result.append(file_to_test)

    if len(result) == 0:
        raise Exception('Not able to find the file %s' % file_wanted)

    return result[0]

def test_search_for_file():
    start_point = os.path.split(__get_this_filename())[0]
    assert(search_for_file("common.py", ["./", start_point],
                           ["./", "python"]) is not None)


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

    # print(os.path.split(__get_this_filename())[0])
    # print(set_correct_path("./"))
    __launch_test()
    # test_search_for_file()
    # links = search_link_in_md_file("./test-md/testLinks.md")
    # for link in links:
    # 	print(link)
    #  create_test_set_correct_path()
    #  create_test_check_folder()
    #  create_test_get_good_filename()
    #  create_test_get_flat_filename()

    # test_number_of_subfolder()

    logging.info('Finished')
    # ------------------------------------


###############################################################################
# Call main function if the script is main
# Exec only if this script is runned directly
###############################################################################
if __name__ == '__main__':
    __set_logging_system()
    __main()
