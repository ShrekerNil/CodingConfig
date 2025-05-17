#!/bin/bash

# 设置仓库根目录路径
REPO_ROOT_DIR="/d/QLRepo"

# 分隔符
SEP="<sep>"

# 输出文件
OUTPUT_FILE="git-repos-collect-list.txt"

# 清空输出文件
> "$OUTPUT_FILE"

# 检查 REPO_ROOT_DIR 是否存在
if [ ! -d "$REPO_ROOT_DIR" ]; then
    echo "错误: 目录 $REPO_ROOT_DIR 不存在。请检查路径并重试。"
    exit 1
fi

# 函数：收集仓库信息并写入文件
collect_repos() {
    find "$REPO_ROOT_DIR" -type d -name ".git" -print0 | while IFS= read -r -d '' GIT_DIR; do
        echo "Handling Repo: $GIT_DIR"
        REPO_DIR=$(dirname "$GIT_DIR")
        REPO_NAME=$(basename "$REPO_DIR")

        # 使用 --no-pager 防止 git 输出分页，使用 -z 处理可能的特殊字符
        REMOTE_OUTPUT=$(git --git-dir="$GIT_DIR" remote -v 2>&1)  # 重定向标准错误到标准输出

        # 检查 git 命令是否成功执行
        if [ $? -eq 0 ]; then
            # 输出仓库根目录和仓库名
            echo "$REPO_DIR$SEP$REPO_NAME：" >> "$OUTPUT_FILE"

            # 提取所有 Fetch URL
            echo "$REMOTE_OUTPUT" | grep '(fetch)' | awk '{print $2}' | while read -r FETCH_URL; do
                echo "==>$FETCH_URL" >> "$OUTPUT_FILE"
            done

            # 添加一个空行作为分隔
            echo "" >> "$OUTPUT_FILE"
        else
            echo "警告: 在 $REPO_DIR 中执行 git remote -v 失败。跳过。"  # 输出警告信息
        fi
    done

    # 输出结束标记
    echo -n "Done" >> "$OUTPUT_FILE"

    echo "---------------------------------------------"
    echo "仓库信息已收集并保存到 $OUTPUT_FILE"
    echo "============================================="
}

# 函数：根据文件重新克隆或拉取仓库，并配置远程仓库
reclone_repos() {
    if [ ! -f "$OUTPUT_FILE" ]; then
        echo "错误: 文件 $OUTPUT_FILE 不存在。请先运行脚本以收集仓库信息。"
        exit 1
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        # 跳过空行和 Done 标记
        if [[ -z "$line" || "$line" == "Done" ]]; then
            continue
        fi

        # 检查行是否以 ':' 结尾，表示仓库根目录和仓库名行
        if [[ "$line" == *":" ]]; then
            # 提取仓库根目录和仓库名
            REPO_DIR=$(echo "$line" | cut -d "$SEP" -f1)
            REPO_NAME=$(echo "$line" | cut -d ":" -f1 | awk -F"$SEP" '{print $2}')

            echo "Processing Repo: $REPO_NAME"

            # 检查仓库是否已经存在
            if [ -d "$REPO_DIR" ]; then
                echo "仓库 $REPO_NAME 已存在，拉取最新代码..."
                cd "$REPO_DIR" || { echo "错误: 无法进入目录 $REPO_DIR"; continue; }
                git pull
            else
                echo "仓库 $REPO_NAME 不存在，克隆仓库..."

                # 提取所有远程仓库地址
                REMOTE_URLS=$(grep "==>" "$OUTPUT_FILE" | grep "$REPO_NAME" | cut -d'>' -f2)

                # 初始化 Gitee_URL 为空
                GITEE_URL=""

                # 遍历所有远程仓库地址，查找包含 Gitee 的地址
                for REMOTE_URL in $REMOTE_URLS; do
                    if [[ "$REMOTE_URL" == *gitee* ]]; then
                        GITEE_URL=$REMOTE_URL
                        break
                    fi
                done

                # 如果找到了 Gitee 的远程仓库地址，则使用它进行克隆
                if [ -n "$GITEE_URL" ]; then
                    echo "使用 Gitee 远程仓库地址进行克隆: $GITEE_URL"
                    git clone "$GITEE_URL"
                else
                    # 如果没有找到 Gitee 的远程仓库地址，则使用第一个远程仓库地址进行克隆
                    FIRST_REMOTE_URL=$(echo "$REMOTE_URLS" | head -n1)
                    echo "使用第一个远程仓库地址进行克隆: $FIRST_REMOTE_URL"
                    git clone "$FIRST_REMOTE_URL"
                fi
            fi

            # 添加其他远程仓库
            # 提取当前仓库的所有远程仓库地址
            REMOTE_URLS=$(grep "==>" "$OUTPUT_FILE" | grep "$REPO_NAME" | cut -d'>' -f2)
            for REMOTE_URL in $REMOTE_URLS; do
                # 跳过第一个远程仓库（已经克隆）
                if [ "$REMOTE_URL" == $(git --git-dir="$REPO_DIR/.git" remote get-url origin) ]; then
                    continue
                fi
                REMOTE_NAME=$(echo "$REMOTE_URL" | cut -d':' -f2 | cut -d'/' -f1)
                echo "添加远程仓库 $REMOTE_NAME: $REMOTE_URL"
                git --git-dir="$REPO_DIR/.git" remote add "$REMOTE_NAME" "$REMOTE_URL"
            done
        fi
    done < "$OUTPUT_FILE"

    echo "---------------------------------------------"
    echo "仓库已经从 $OUTPUT_FILE 恢复"
    echo "============================================="
}

# 函数：显示菜单
show_menu() {
    echo ""
    echo -e "\e[1;34m=============================================\e[0m"
    echo -e "              \e[1;32mGit Repos Manager\e[0m"
    echo -e "=============================================\e[0m"
    echo ""
    echo -e "    \e[1;33m1. 收集仓库信息\e[0m"
    echo -e "    \e[1;33m2. 重新克隆仓库\e[0m"
    echo -e "    \e[1;33m3. 退出\e[0m"
    echo ""
    echo -e "=============================================\e[0m"
    echo ""
}

# 主逻辑
while true; do
    show_menu
    read -p "请输入编号 (1-3): " choice
    case "$choice" in
        1)
            collect_repos
            ;;
        2)
            reclone_repos
            ;;
        3)
            echo "退出脚本。"
            exit 0
            ;;
        *)
            echo "无效的选项，请重新输入。"
            ;;
    esac
    echo ""
done

echo "---------------------------------------------"
echo "操作完成。"
echo "---------------------------------------------"
