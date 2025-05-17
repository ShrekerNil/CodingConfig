#! /usr/bin/env python
# -*- coding:<encoding UTF-8> -*-
# 
# author: Shreker
# date  : 2022/12/17
#

import os
import os.path
import re
import json


def include_path(lst, part):
    for url in lst:
        if part.startswith(url):
            return True
    return False


def replace_win_separator(dir_path):
    return dir_path.replace('\\', '/')


def start_process(root):
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    print(f"Start Synchronizing Root: {root}")
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    
    result = list()
    list_recorded = list()
    
    for dir_path, dir_names, _ in os.walk(root):
        dir_path = replace_win_separator(dir_path)
        if include_path(list_recorded, dir_path):
            continue
        if '.git' in dir_names:
            print(f'Found Git Repo:{dir_path}')
            
            ori = os.popen(f'git -C {dir_path} remote -v').read()
            re_temp = re.search(r'(git|https).*git', ori)
            if re_temp is None:
                continue
            remote_url = re_temp.group()
            basename = os.path.basename(dir_path)
            
            dic_item = dict()
            dic_item['dir_path'] = dir_path
            dic_item['remote_url'] = remote_url
            dic_item['repo_name'] = basename

            list_recorded.append(dir_path)
            result.append(dic_item)
    return result


if __name__ == '__main__':
    result = start_process('D:/QLRepo')
    json_res = json.dumps(result)
    print(json_res)
    with open("D:/QLRepo/QLNotes/Config/Git/Backup/QLRepo-Bak.data", 'w') as file:
        file.write(json_res)
