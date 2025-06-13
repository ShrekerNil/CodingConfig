#!/bin/bash

echo "Configing global user.name=Shreker.Nil ..."
git config --global user.name Shreker.Nil

echo "Configing global user.email=shrekernil@qq.com ..."
git config --global user.email shrekernil@qq.com

# reject mix line endings
echo "Configing git config --global core.safecrlf true ..."
git config --global core.safecrlf true
  #拒绝提交包含混合换行符的文件
  # git config --global core.safecrlf true
  #允许提交包含混合换行符的文件
  # git config --global core.safecrlf false
  #提交包含混合换行符的文件时给出警告并继续
  # git config --global core.safecrlf warn

# translate to LF when commit, not change when checkout
echo "Configing git config --global core.autocrlf=false ..."
git config --global core.autocrlf false
  #提交时转换为LF，检出时转换为CRLF
  # git config --global core.autocrlf true   
  #提交时转换为LF，检出时不转换
  # git config --global core.autocrlf input   
  #提交检出均不转换
  # git config --global core.autocrlf false

# all in UTF-8
# git config --global gui.encoding utf-8
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
export LESSCHARSET=utf-8

# 解决git status不能显示中文
# source: https://zhuanlan.zhihu.com/p/133706032
    # [gui]
    #     encoding = utf-8
    #     # 代码库统一使用utf-8
    # [i18n]
    #     commitencoding = utf-8
    #     # log编码
    # [svn]
    #     pathnameencoding = utf-8
    #     # 支持中文路径
    # [core]
    #     quotepath = false
    #     # status引用路径不再是八进制（反过来说就是允许显示中文了）
echo "Configing global core.quotepath=false ..."
git config --global core.quotepath false

# 增加缓存大小，有时候目标仓库的文件太大会导致clone失败
echo "Configing global http.postBuffer=1048576000 ..."
git config --global http.postBuffer 1048576000

echo "Configing global core.longpaths=true ..."
git config --global core.longpaths true

echo "Configing global core.ignorecase=false ..."
git config --global core.ignorecase false

# compression 取值为 [-1, 9]
#   -1 以 zlib 为默认压缩库，
#   0 表示不进行压缩，
#   1~9 是压缩速度与最终获得文件大小的不同程度的权衡，数字越大，压缩越慢，最后得到的文件会越小
echo "Configing global core.compression=-1 ..."
git config --global core.compression -1

# 处理新版git添加工作目录为安全目录的问题
echo "Configing global safe.directory=* ..."
git config --global --add safe.directory "*"

# 大小写敏感的问题
# 如果全局不起作用, 那么需要在该仓库本地设置: git config core.ignorecase false
echo "Configing global core.ignorecase false ..."
git config --global core.ignorecase false

echo -e "\n"
read -p "PRESS [ENTER] TO EXIT ... "
