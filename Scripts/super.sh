#!/bin/bash

# 判断是否支持颜色
if tput setaf 1 &> /dev/null; then
  RED=$(tput setaf 1)
  RESET=$(tput sgr0)
else
  RED=""
  RESET=""
fi

# 输出彩色文本
echo -n "${RED}这是一个红色的消息${RESET}"
echo

# 将输出重定向到日志文件
{
  echo -n "${RED}这是一个红色的消息${RESET}"
  echo
} > output.log