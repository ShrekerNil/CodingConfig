# Sublime Text 4

## Gists

- 参考Git文件夹中的Gists

## 常用快捷键

| 编号 |              功能               | 快捷键                                                       | 备注                                                         |
| ---- | :-----------------------------: | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    |  命令模式<br/>Command Palette   | Ctrl + Shift + P                                             | 命令提示框                                                   |
| 2    | 文件选择模式<br/>File Switching | Ctrl + P                                                     | 1. 输入@+函数名，可以快速查找到函数<br/>2. 输入#+文本，可以快速进行文件内文本匹配 |
| 3    |  方法选择模式<br/>Goto Symbols  | Ctrl+ R                                                      |                                                              |
| 4    |   多行编辑模式<br/>Multi-Edit   | 1. Ctrl + \<click\><br/>2. Shift + 右键<br/>3. Alt + F3<br/>4. Ctrl+Shift+L | 1. 自由多行编辑<br/>2. 连续多行编辑<br/>3. 选中相同编辑<br/>4. 选中行末尾编辑 |
|      |                                 |                                                              |                                                              |

## 常用插件

| 软件名称            | 用途             | 备注                                                         |
| ------------------- | ---------------- | ------------------------------------------------------------ |
| LSP                 | 编码编辑辅助功能 |                                                              |
| **Package Control** | 插件管理工具     |                                                              |
| **Emmet**           |                  | **使用方法:** `ctrl + alt + enter` ,并且开始输入Emmet风格的HTML, **[Emmet指南](https://scotch.io/tutorials/write-html-crazy-fast-with-emmet-an-interactive-guide)** |
| **CodeFormatter**   | 代码格式化工具   | https://github.com/akalongman/sublimetext-codeformatter      |
| **Sublimerge Pro**  |                  |                                                              |



## 我的配置

### 偏好设置

#### 中文系统

```json
{
    "always_prompt_for_file_reload": true,
    "auto_complete": true,
    "auto_complete_commit_on_tab": false,
    "auto_hide_menu": false,
    "auto_hide_tabs": false,
    "auto_wrap_break_long_word": true,
    "block_caret": false,
    "bold_folder_labels": true,
    "caret_extra_bottom": 0,
    "caret_extra_top": 0,
    "caret_extra_width": 1,
    "caret_style": "smooth",
    "close_find_after_find_all": false,
    "close_find_after_replace_all": false,
    "default_encoding": "UTF-8",
    "default_line_ending": "unix",
    "draw_white_space": ["selection"],
    "enable_tab_scrolling": true,
    "fade_fold_buttons": true,
    "file_tab_style": "rounded",
    "fold_buttons": true,
    "font_options": ["gdi","no_bold"],
    "font_size": 13,
    "hide_new_tab_button": true,
    "hide_tab_scrolling_buttons": false,
    "highlight_line": true,
    "highlight_modified_tabs": true,
    "index_files": true,
    "line_numbers": true,
    "line_padding_bottom": 1,
    "line_padding_top": 1,
    "margin": -15,
    "overlay_scroll_bars": "enable",
    "reload_file_on_change": true,
    "show_encoding": true,
    "show_indentation": true,
    "show_line_endings": true,
    "show_syntax": true,
    "show_tab_close_buttons": true,
    "theme": "Default Dark.sublime-theme",
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": true,
    "word_wrap": true,
    /*"font_face": "Cascadia Code PL Light",*/
    /*"font_face": "Cascadia Mono PL Light",*/
    /*"font_face": "JetBrains Mono",*/
    /*"font_face": "Microsoft YaHei UI Light",*/
    /*"font_face": "Microsoft YaHei UI",*/
    /*"font_face": "NSimSun",*/
    /*"font_face": "新宋体",*/
    "ignored_packages":
    [
		"Vintage",
    ],
}
```

#### 英文系统

```json
{
    "always_prompt_for_file_reload": true,
    "auto_complete": true,
    "auto_complete_commit_on_tab": false,
    "auto_hide_menu": false,
    "auto_hide_tabs": false,
    "auto_wrap_break_long_word": true,
    "block_caret": false,
    "bold_folder_labels": true,
    "caret_extra_bottom": 0,
    "caret_extra_top": 0,
    "caret_extra_width": 1,
    "caret_style": "smooth",
    "close_find_after_find_all": false,
    "close_find_after_replace_all": false,
    "default_encoding": "UTF-8",
    "default_line_ending": "unix",
    "draw_white_space": ["selection"],
    "enable_tab_scrolling": true,
    "fade_fold_buttons": true,
    "file_tab_style": "rounded",
    "fold_buttons": true,
    "font_options": ["gdi","no_bold"],
    "font_size": 15,
    "hide_new_tab_button": true,
    "hide_tab_scrolling_buttons": false,
    "highlight_line": true,
    "highlight_modified_tabs": true,
    "index_files": true,
    "line_numbers": true,
    "line_padding_bottom": 1,
    "line_padding_top": 1,
    "margin": -15,
    "overlay_scroll_bars": "enable",
    "reload_file_on_change": true,
    "show_encoding": true,
    "show_indentation": true,
    "show_line_endings": true,
    "show_syntax": true,
    "show_tab_close_buttons": true,
    "theme": "Default Dark.sublime-theme",
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": true,
    "word_wrap": true,
    /*"font_face": "Consolas",*/
    /*"font_face": "Cascadia Mono PL Light",*/
    /*"font_face": "JetBrains Mono",*/
    /*"font_face": "Sarasa Mono SC",*/
    /*"font_face": "Microsoft YaHei",*/
    /*"font_face": "新宋体",*/
    "font_face": "NSimSun",
    /*"font_face": "['NSimSun', 'Microsoft YaHei']",*/
    "ignored_packages": [
        "Vintage",
    ]
}
```



### 快捷键

```json
[
    { "keys": ["alt+l"], "command": "lower_case" },
    { "keys": ["alt+u"], "command": "upper_case" },
    { "keys": ["ctrl+shift+x"], "command": "swap_case" },
    { "keys": ["alt+/"], "command": "auto_complete" },
    { "keys": ["alt+["], "command": "swap_brackets" },
    { "keys": ["alt+]"], "command": "wrap_brackets" },
    { "keys": ["alt+down"], "command": "swap_line_down" },
    { "keys": ["alt+f"], "command": "show_panel", "args": { "panel": "find_in_files" } },
    { "keys": ["alt+m"], "command": "toggle_camel_case_word_selection" },
    { "keys": ["alt+s"], "command": "toggle_side_bar" },
    { "keys": ["alt+t"], "command": "capitalize_selection" },
    { "keys": ["alt+up"], "command": "swap_line_up" },
    { "keys": ["alt+w"], "command": "toggle_setting", "args": { "setting": "word_wrap" } },
    { "keys": ["ctrl+alt+down"], "command": "duplicate_line" },
    { "keys": ["ctrl+d"], "command": "run_macro_file", "args": { "file": "Packages/Default/Delete Line.sublime-macro" } },
    { "keys": ["ctrl+i"], "command": "reindent" },
    { "keys": ["ctrl+j"], "command": "join_lines" },
    { "keys": ["ctrl+k"], "command": "find_under_expand_skip" },
    { "keys": ["ctrl+l"], "command": "show_overlay", "args": { "overlay": "goto", "text": ":" } },
    { "keys": ["ctrl+o"], "command": "show_overlay", "args": { "overlay": "goto", "text": "@" } },
    { "keys": ["ctrl+shift+r"], "command": "show_overlay", "args": { "overlay": "goto", "show_files": true } },
    { "keys": ["shift+down"], "command": "select_lines", "args": { "forward": true } },
    { "keys": ["shift+enter"], "command": "run_macro_file", "args": { "file": "Packages/Default/Add Line.sublime-macro" } },
    { "keys": ["shift+up"], "command": "select_lines", "args": { "forward": false } },
]
```

## 常见问题

### 关于中文换行

全部中文的情况下，很有可能半行就自动换行了，目前没有找到解决方案

sublime怎么实现按照字符换行而不是按照单词换行



# Sublime 插件

## 常见插件

1. Package Control，开源地址：https://github.com/wbond/package_control
2. FileHeader，开源地址：https://github.com/shiyanhui/FileHeader
3. SublimePrettyJson：开源地址：https://github.com/dzhibas/SublimePrettyJson

# 大眼仔

> http://www.dayanzai.me/sublime-text.html

> 摘要：Sublime text 4 中文版 代码编辑器由大眼仔旭发布。Sublime Text 中文版是一个代码编辑器（Sublime Text 是收费软件，但可以无限期试用），也是HTML和散文先进的文本编辑器。Sublime Text 是由程序员 Jon Skinner 于 2008 年 1 月份所开发出来，它最初被设计…

[**Sublime text 4 中文版**](http://www.dayanzai.me/sublime-text-3.html) 代码编辑器由[**大眼仔旭**](http://www.dayanzai.me/)发布。Sublime Text 中文版是一个代码编辑器（Sublime Text 是收费软件，但可以无限期试用），也是HTML和散文先进的文本编辑器。Sublime Text 是由程序员 Jon Skinner 于 2008 年 1 月份所开发出来，它最初被设计为一个具有丰富扩展功能的 Vim。[Notepad++ 中文版](http://www.dayanzai.me/notepad-next.html)也是一款优秀免费的代码编辑器哦。

嘿！听说你在寻找一款优秀的文本编辑器？我想和你分享一下Sublime Text，这是我用了很长时间的一款工具。

Sublime Text 中文版的主要功能包括：拼写检查，书签，完整的 Python API ， Goto 功能，即时项目切换，多选择，多窗口等等。Sublime Text 是一个跨平台的编辑器，同时支持 Windows、Linux、Mac OS X 等操作系统。

## Sublime text 快捷键

Sublime Text是一个流行的文本编辑器，提供许多快捷键来加快编辑速度和流程。以下是一些常用的Sublime Text快捷键：

文件操作：

- 新建文件：Ctrl + N
- 打开文件：Ctrl + O
- 保存文件：Ctrl + S
- 另存为：Ctrl + Shift + S
- 关闭文件：Ctrl + W

编辑操作：

- 撤销：Ctrl + Z
- 重做：Ctrl + Y
- 复制：Ctrl + C
- 剪切：Ctrl + X
- 黏贴：Ctrl + V
- 全选：Ctrl + A

导航和选择：

- 跳转到行：Ctrl + G
- 跳转到指定字符：Ctrl + P，输入@符号
- 选择整行：Ctrl + L
- 选择单词：Ctrl + D（连续按多次可选择多个相同的单词）
- 多行编辑：按住Ctrl键，点击要编辑的行

查找和替换：

- 查找：Ctrl + F
- 替换：Ctrl + H
- 查找下一个：F3
- 查找上一个：Shift + F3

快速操作：

- 注释：Ctrl + /
- 缩进：Tab
- 取消缩进：Shift + Tab
- 上移一行：Ctrl + Shift + ↑
- 下移一行：Ctrl + Shift + ↓

多窗口和标签操作：

- 新建窗口：Ctrl + Shift + N
- 切换窗口：Ctrl + ` (反引号键)
- 在窗口间切换：Ctrl + 数字键（0-9）
- 新建标签：Ctrl + T
- 切换标签：Ctrl + Page Up / Page Down
- 关闭当前标签：Ctrl + W

代码编辑和补全：

- 代码格式化：Ctrl + Shift + P，输入”Format”并选择合适的命令
- 代码折叠：Ctrl + Shift + [ 或 ]
- 代码片段补全：输入片段关键词后按Tab键

行操作：

- 移动到行首：Ctrl + Home
- 移动到行尾：Ctrl + End
- 删除当前行：Ctrl + Shift + K
- 在当前行上方插入新行：Ctrl + Enter
- 在当前行下方插入新行：Ctrl + Shift + Enter

编辑器布局：

- 切换侧边栏：Ctrl + K + B
- 切换全屏：F11
- 增加编辑器宽度：Ctrl + +
- 减小编辑器宽度：Ctrl + –

特殊功能：

- 运行代码：Ctrl + B
- 打开命令面板：Ctrl + Shift + P
- 自动补全：Ctrl + Space
- 显示/隐藏侧边栏：Ctrl + K + 0 (数字零)

这只是 Sublime Text 的一小部分快捷键列表。您可以在编辑器的菜单栏或文档中找到更多的快捷键选项，或者通过自定义设置进行个性化配置。

## Sublime Text 插件管理



Sublime Text 提供了 Package Control 插件作为插件管理工具，让你轻松安装、更新和卸载插件。下面是使用 Package Control 进行插件管理的基本步骤：

1、打开 Sublime Text 编辑器，按下 Ctrl+“ 或者点击菜单栏的 View -> Show Console 打开控制台。

2、在控制台中粘贴以下代码，并按下回车键：

```
1

import urllib.request,os; pf = 'Package Control.sublime-package'; url = 'https://packagecontrol.io/' + pf.replace(' ', '%20'); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(sublime.packages_path(), pf), 'wb').write(urllib.request.urlopen(url).read())
```

3、等待一段时间，直到控制台显示安装成功的消息。

4、重启 Sublime Text，然后按下 Ctrl+Shift+P（Windows/Linux）或者 Cmd+Shift+P（Mac）打开命令面板。

5、在命令面板中输入 Package Control: Install Package 并选择该选项，然后等待片刻，直到弹出一个列表显示所有可用的插件。

6、在列表中浏览并选择你想要安装的插件。你可以使用箭头键上下移动选项，按回车键确认选择。

7、安装完成后，Package Control 会自动下载并安装所选的插件。

8、如果你想更新插件，可以再次打开命令面板，输入 Package Control: Upgrade Package 来更新已安装的插件，或者在列表中选择特定的插件进行更新。

9、如果你想卸载插件，同样打开命令面板，输入 Package Control: Remove Package 并选择要卸载的插件。

## Sublime Text 推荐插件



当涉及到 Sublime Text 的插件时，有许多优秀的选择。以下是一些备受推荐的插件，它们能够提供更好的开发和编辑体验：

1. Emmet：提供快速编写 HTML 和 CSS 的能力，通过简单的缩写语法快速生成代码。
2. SublimeLinter：实时检查你的代码，提供语法和错误提示，支持多种编程语言。
3. GitSavvy：提供 Git 版本控制的集成，让你可以在 Sublime Text 中执行常见的 Git 操作，如提交、拉取、合并等。
4. ColorPicker：提供一个取色器，使你可以轻松选择颜色，并将其插入到你的代码中。
5. DocBlockr：帮助自动生成函数和方法的文档注释，减少手动书写注释的时间。
6. SideBarEnhancements：增强侧边栏功能，提供更多的操作选项，如复制、粘贴、删除和重命名文件等。
7. AutoFileName：自动补全文件路径和文件名，方便快速打开或引用文件。
8. MarkdownEditing：提供 Markdown 编辑和预览功能，支持语法高亮和实时渲染。
9. All Autocomplete：在自动完成菜单中显示所有打开文件的建议，而不仅仅是当前文件。
10. Theme – Material Theme：一套美观的主题，为 Sublime Text 提供现代化的外观和操作体验。

以上只是一小部分值得推荐的插件。你可以使用 Package Control 搜索并安装这些插件，或者根据自己的需求在 Package Control 中探索更多插件。记得根据你使用的编程语言和开发环境选择适合的插件。希望你喜欢这些插件！

## Sublime Text 简体中文设置方法



按住 Ctrl + Shift + P，输入”install package”（第一次运行可能需要几秒），然后输入 Chinese，选择 ChineseLocalization (回车或者鼠标单击击)。

## [**官方主页**](http://anonymz.com/?http://www.sublimetext.com)

```
What’s new in Sublime Text 4 Build 4180
Aug 6, 2024
Various syntax highlighting improvements
Newly rewritten Lisp syntax highlighting thanks to deathaxe
Linux: Implemented kinetic scrolling under Wayland
Linux: Implemented xdg-activation protocol for wayland
Linux: Fixed crash on wayland related to tab dragging
Linux: Fixed issues with tab dragging under Wayland
Linux: Added workaround for KDE drag-drop issue causing the caret to get stuck (Also fixed in kwin 6.0.4)
Windows: Implemented scroll-resetting behavior when dragging scroll bar
Windows: Fixed copied text being truncated by null character
Windows: Fixed custom top-level menu items not being themed
Windows, Linux: Allow numbers as menu mnemonics
Mac: Files moved to trash now have a “Put Back” option
Mac: Fixed issues related to dragging the edges of windows
Mac: Fixed security entitlements for plugins not applying properly
Mac: Fixed some issues with applying find clipboard
Mac: Fixed multi-line environment variables not being read correctly
Mac, Linux: Fixed leak of shared memory
Added “goto_anything_file_preview” setting
Added “image_file_patterns” for controlling which files are automatically opened as an image
Added File > Open file as Text/Image for explicitly opening a file as an image or as text
Added context menu for image tabs
Improved behavior of Expand Selection in Python docstrings
The “menu” key now works in the sidebar
Reduced memory usage when editing large files
Full Screen is now restored when exiting Distraction Free Mode
Text selection is now retained when using Split View
Improved handling of invalid UTF-16 sequences
Fixed overlay scrollbars blocking input when invisible
Improved accuracy of scope selectors
Added enable toggle to indexing status dialog
Opening folder history in Sublime Merge now works recursively
Added entry in command palette for opening mouse bindings
Added syntax argument to run_syntax_tests command
Fixed syntax tests not running when files aren’t UTF-8 encoded
Files containing colons can now be opened from the command line
Fixed window closing when switching projects under certain conditions
Fixed focus of new windows starting on the last group when “remember_layout” is enabled
Fixed line numbers not being rendered correctly in some cases
Fixed an issue with rulers displaying incorrectly while scrolling under OpenGL
Fixed fold markers not having background rendering
Fixed PATH not being restored correctly when a build system fails to launch
Fixed git repository details not always showing
Find: Find in files history menu now deduplicates entries
Find: Fixed settings not applying to find-in-files
Find: Fixed a case where incorrect settings would be used when run immediately after find_under_expand
Tab Dragging: Improved clarity in mixed-dpi setups
Tab Dragging: Fixed various positioning bugs in mixed-dpi setups
Tab Dragging: Fixed misalignment of labels in some cases
minihtml: Improved error messages
minihtml: Added support for white-space: pre and white-space: pre-wrap
minihtml: <style> tags are now allowed within <head>
minihtml: HTML is no longer parsed within <style> tags
minihtml: Made HTML entity parsing more lenient
Theme: New unmodified files no longer have the “dirty” attribute
API: All functions are now available at import time
API: Optimized auto-completion
API: Fixed ViewEventListener occasionally leaking
API: Fixed Settings.get not always returning the default value on failure
API: Fixed View.style_for_scope not always returning the right “source_line”
API: Added View.utf8_code_units and View.utf16_code_units
```

## 下载

http://www.sublimetext.com/blog/articles/sublime-text-4

资源：283.rar
解压密码：www.dayanzai.me
转载请保留出处，谢谢合作~
[点击下载](https://pan.baidu.com/s/1o2ynSzpicI2yk1CCBb7gpA?pwd=wrui)（提取码：wrui）
[点击下载](https://url89.ctfile.com/f/3965089-1339868509-c7f386?p=536766)（提取码：536766）
[点击下载](https://url89.ctfile.com/f/3965089-1339868509-c7f386?p=536766)（提取码：536766）
[点击下载](https://pan.baidu.com/s/1tx2dbMpXzbNnr9QqTcZaaw?pwd=si4q)（提取码：si4q）

# 亿破姐

> https://www.ypojie.com/3138.html

[代码](https://www.ypojie.com/tag/代码)[编辑器](https://www.ypojie.com/tag/编辑器) [Sublime Text](https://www.ypojie.com/3138.html) 中文汉化版绿色正式版由亿破姐收集特意分享给学习代码的朋友使用， Sublime Text 官方正版太贵了亿破姐这种刚刚学习PHP代码的人来说简直负担不起，亿破姐收集的此 Sublime Text 使用官方版进行修改汉化、集成正版密钥默认已注册河蟹，去自动检测升级提示，整合Git、DocBlockr、MarkdownPreview、ColorPicker、AllAutocomplete、GBK插件支持简体中文等等插件，有钱的程序员可以支持正版。

Sublime Text 是个代码编辑器，也是HTML和散文先进的[文本编辑](https://www.ypojie.com/tag/文本编辑)器。Sublime Text 具有漂亮的用户界面和强大的功能，例如代码缩略图，Python的插件，代码段等。还可自定义键绑定，菜单和工具栏。Sublime Text 的主要功能包括：拼写检查，书签，完整的 Python API ， Goto 功能，即时项目切换，多选择，多窗口等等。Sublime Text 是一个跨平台的编辑器，同时支持Windows、Linux、Mac OS X等操作系统。

## 特性说明

转到任何东西
使用Goto Anything只需几个按键即可打开文件，并立即跳转到符号，线条或文字。

用Ctrl + P触发，可以：

键入文件名的一部分来打开它。
键入@以跳转到符号，#在文件中搜索并:转到行号。
这些快捷键可以合并，这样tp@rf可以带你到一个功能READ_FILE在文件中text_parser.py。同样，tp:100会带你到第100行的同一个文件。

转到定义
使用语法定义中的信息，Sublime Text自动生成每个类，方法和函数的项目范围索引。这个索引支持Goto Definition，它有三种不同的方式：

悬停在符号上时会显示一个弹出窗口
当插入符号时按F12
项目功能中的转到符号
可以通过配置文件按照语法定制符号索引，使用户可以根据自己的需要定制功能。

多选
同时进行十次更改，而不是一次更改十次。多重选择允许您一次交互地更改许多行，轻松重命名变量，以及比以前更快地操作文件。

尝试按Ctrl + Shift + L将选定内容分为行和Ctrl + D以选择下一个出现的选定单词。要使用鼠标进行多项选择，请查看“ 列选择”文档。

命令选项板
该命令调色板抱不常用的功能，如排序，改变语法和更改缩进设置。只需几个按键，您就可以搜索您想要的内容，而无需浏览菜单或记住模糊的键绑定。

用Ctrl + Shift + P显示命令面板。

强大的API和软件包生态系统
Sublime Text具有强大的Python API，允许插件增强内置功能。

软件包控制可以通过命令选项板进行安装，提供对社区构建的数千个软件包的简单访问。

自定义任何东西
键绑定，菜单，片段，宏，完成和更多 – 几乎所有在Sublime Text中都可以用简单的JSON文件进行定制。该系统为您提供了灵活性，因为可以在每个文件类型和每个项目的基础上指定设置。

分割编辑
利用分割编辑支持充分利用宽屏幕显示器。并排编辑文件，或在一个文件中编辑两个位置。您可以根据需要编辑尽可能多的行和列。通过使用多个窗口进行编辑并在每个窗口中使用多个分割来利用多个监视器。

查看分▶屏编辑选项的视图分屏菜单。要将多个视图打开到一个文件中，请使用文件▶新视图到文件菜单项。

即时项目切换
Sublime Text中的项目捕获工作区的全部内容，包括修改和未保存的文件。您可以按照与Goto Anything类似的方式在项目之间切换，并且切换是即时的，没有保存提示 – 所有修改将在下次打开项目时恢复。

性能
崇高文本由自定义组件构建，提供无与伦比的响应能力。从强大的自定义跨平台UI工具包到无与伦比的语法高亮引擎，Sublime Text设置了性能栏。

跨平台
Sublime Text可用于Mac，Windows和Linux。无论您使用何种操作系统，在您拥有的每台计算机上都需要使用一个许可证才能使用Sublime Text。

Sublime Text使用自定义UI工具包，针对速度和美观进行了优化，同时利用每个平台上的本地功能。

## 修改说明

Sublime Text 3 官方版进行完美汉化中文；集成Sublime Text正版密钥默认已注册完美正式版；

去除程序自动检测升级，即无更新选项也没有升级提示；制作成绿色正式版本Sublime Text32位及64位；

如何安装插件？

按快捷键Ctrl+Shift+P，输入 install 并回车，选择相应插件安装即可。
或者依次点击“首选项 – 插件控制 – Install Package”进行插件安装。

Sublime Text 本地化语言增加多国语言菜单插件包
https://github.com/zam1024t/LocalizedMenu

Sublime Text 侧边栏右键增强插件中文版
https://github.com/52fisher/SideBarEnhancements

PackageControl: 插件控制管理器（必装）
https://github.com/wbond/package_control/releases

解决官方版Package Control组件安装插件报错问题：
1, 下载Package Control最新版解压，将文件夹重新命名Package Control
2, 打开 Sublime，点击：首选项 -> 浏览插件，便会打开Packages文件夹！
然后删除文件夹内的Package Control文件夹，用下载的新版本文件夹替换。



城通网盘：[https://url94.ctfile.com/d/17401394-29687971-c1faff](https://www.ypojie.com/go/aHR0cHM6Ly91cmw5NC5jdGZpbGUuY29tL2QvMTc0MDEzOTQtMjk2ODc5NzEtYzFmYWZm)（访问密码：YPOJIE）

夸克网盘：[https://pan.quark.cn/s/bd1d979bf006](https://www.ypojie.com/go/aHR0cHM6Ly9wYW4ucXVhcmsuY24vcy9iZDFkOTc5YmYwMDY=)

UC网盘：[https://fast.uc.cn/s/6dd21f638ba44](https://www.ypojie.com/go/aHR0cHM6Ly9mYXN0LnVjLmNuL3MvNmRkMjFmNjM4YmE0NA==)

百度网盘：[https://pan.baidu.com/s/14bjAxjOhms2kSj0tsPYwFQ](https://www.ypojie.com/go/aHR0cHM6Ly9wYW4uYmFpZHUuY29tL3MvMTRiakF4ak9obXMya1NqMHRzUFl3RlE=) 提取码: d8xs