#!/bin/bash
# 更新 RoseLine：其余应用用 BeautyLine 图案套底板，文件夹换成 BeautyLine。
# 旧版留在 ~/.local/share/icons/.RoseLine-old，想退回：bash update-theme.sh --undo
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"
I="$HOME/.local/share/icons"
reload() {  # 让桌面重新读图标：切走再切回
  if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark; sleep 1
    gsettings set org.gnome.desktop.interface icon-theme RoseLine
  fi
}
if [ "${1:-}" = --undo ]; then
  [ -d "$I/.RoseLine-old" ] || { echo "没有旧版可退。"; exit 1; }
  rm -rf "$I/RoseLine"; mv "$I/.RoseLine-old" "$I/RoseLine"; reload
  echo "已退回旧版 RoseLine。"; exit 0
fi
[ -d "$HERE/RoseLine" ] || { echo "包里没有 RoseLine 文件夹。"; exit 1; }
rm -rf "$I/.RoseLine-old"
[ -d "$I/RoseLine" ] && mv "$I/RoseLine" "$I/.RoseLine-old"
cp -r "$HERE/RoseLine" "$I/RoseLine"
gtk-update-icon-cache -f -q "$I/RoseLine" 2>/dev/null || true
reload
echo "已更新：$(find "$I/RoseLine" -name '*.svg' | wc -l) 个图标。"
echo "启动器、Dock 一般马上换；文件管理器重开一次。还有没变的，注销重新登录。"
