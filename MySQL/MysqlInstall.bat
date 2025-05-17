@echo off
echo ~~~~~~~~~~~~~~~~~~~~~~~
echo ~ 解压版MySQL安装脚本 ~
echo ~~~~~~~~~~~~~~~~~~~~~~~

echo 停止mysql服务（如果存在）
net stop mysql

rem 以下测试路径
echo 当前盘符：%~d0 
echo 当前盘符和路径：%~dp0
echo 当前批处理全路径：%~f0
echo 当前盘符和路径的短文件名格式：%~sdp0
echo 当前CMD默认目录：%cd%

set mypath=%~dp0
set mypath=%mypath:\=\\%
echo 批处理文件所在路径转为双斜杠短名: %mypath%
echo 当前批处理正工作的路径转换后: %cd:\=\\%

rem 找到当前路径
rem 将temp.txt文件中内容拷贝到temp.bat文件中
rem temp.txt文件中的内容是“set PathTemp=”
rem 特别注意：“=”后面不能加回车
copy temp.txt temp.bat

rem 将路径添加到temp.bat文件中
cd>>temp.bat

rem 执行temp.bat文件中命令
rem temp.bat文件执行后，路径已经保存在PathTemp变量中
call temp.bat

rem 删除temp.bat文件
rem del temp.bat

rem 复制 my-default.ini文件
copy my-default.ini my.ini

rem 设置my.ini的标记位
set tag=[mysqld]

rem 设置添加到my.ini文件中的数据库路径和数据路径
rem set datadir=datadir=%PathTemp%\data的意思是：
rem 将字符串“datadir=”、变量PathTemp对应的字符串以及字符串“\data”赋值给datadir变量
set basedir=basedir=%PathTemp:\=\\%
set datadir=datadir=%PathTemp:\=\\%\data

rem 设置运行环境变量homedir
set homedir=%PathTemp%\bin

rem 设置变量延迟
rem 注意：使用变量延迟后，相关变量用！！包围，这样程序才能正确识别
setlocal enabledelayedexpansion

rem 循环查找my.ini文件中的内容
for /f "tokens=*" %%i in (my.ini) do (

rem 将从my-default.ini文件中读到的字符串，赋值给变量p
set p=%%i

rem 如果变量p的内容和my-default.ini的标记位相同
rem 将变量p的内容写入my.ini文件中，同时在其后面加入两行内容：
rem basedir的内容和datadir的内容；
rem 如果不同，只将变量p的内容写入my.ini文件中
if "!p!"== "%tag%" (
echo !p!>>my.ini
echo !basedir!>>my.ini
echo !datadir!>>my.ini
echo #开启查询缓存>>my.ini
echo explicit_defaults_for_timestamp=true>>my.ini 
)
if not "!p!"== "%tag%" echo !p!>>my.ini
)
rem TIMESTAMP with implicit DEFAULT value is deprecated
rem 设置删除mysql服务的命令
set uninstallcmd=.\bin\mysqld.exe remove mysql
rem 调用删除命令
call !uninstallcmd!

rem 设置安装mysql服务的命令
set installcmd=.\bin\mysqld.exe -install mysql

rem 调用安装命令
call !installcmd!

rem 启动mysql服务
net start mysql

rem 调用update.sql文件中的sql语句，将mysql的远程访问方式打开，以备远程访问服务器；
rem 同时，将mysql的密码更改，本批处理命令将mysql密码更改为root
.\bin\mysql -u root <.\update.sql

rem 重启mysql服务
net stop mysql
net start mysql
echo 任务执行完毕，按下任意键退出程序。。。
pause>nul
