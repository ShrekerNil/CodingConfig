#!/bin/bash

echo ---------------------333-------------------

# 示例操作
echo "执行 script2.sh"

# 使用 eval 接收数组
# eval "SCRIPT_SOURCE=($1)"
# 或者
SCRIPT_SOURCE="$1"
IFS=' ' read -r -a SCRIPT_SOURCE <<< "$SCRIPT_SOURCE"

echo "(((((((((((((((((((((((((((((((((((((("
echo "SCRIPT_SOURCE in child:"
for element in "${SCRIPT_SOURCE[@]}"; do
  echo "$element"
done
echo "))))))))))))))))))))))))))))))))))))))"

echo 数量a：${#SCRIPT_SOURCE[@]}
echo "== ${BASH_SOURCE[0]}"
SCRIPT_SOURCE+=("${BASH_SOURCE[0]}")
echo 数量b：${#SCRIPT_SOURCE[@]}

echo "(((((((((((((((((((((((((((((((((((((("
echo "SCRIPT_SOURCE in child:"
for element in "${SCRIPT_SOURCE[@]}"; do
  echo "$element"
done
echo "))))))))))))))))))))))))))))))))))))))"

echo =====================333===================