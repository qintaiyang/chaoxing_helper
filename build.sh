#!/bin/bash
# 超星 V2 编译脚本 - Ubuntu 服务器版
# 用法: ./build.sh

set -e

echo "=========================================="
echo "  超星 ChaoXing Helper V2 编译脚本"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Java 环境
echo -e "\n${YELLOW}[1/6] 检查 Java 环境...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}错误: 未找到 Java，请先安装 JDK 11+${NC}"
    echo "  sudo apt install openjdk-17-jdk"
    exit 1
fi
java -version

# 检查 Flutter 环境
echo -e "\n${YELLOW}[2/6] 检查 Flutter 环境...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}错误: 未找到 Flutter${NC}"
    echo "  请确保 Flutter 已添加到 PATH"
    exit 1
fi
flutter --version

# 图标处理
echo -e "\n${YELLOW}[3/6] 处理应用图标...${NC}"
ICON_PATH="./images/logo.png"

if [ -n "$1" ] && [ -f "$1" ]; then
    echo "使用自定义图标: $1"
    cp "$1" "$ICON_PATH"
else
    echo "使用默认图标"
fi

# 安装依赖
echo -e "\n${YELLOW}[4/6] 安装 Flutter 依赖...${NC}"
flutter pub get

# 生成图标
echo -e "\n${YELLOW}[5/6] 生成应用图标...${NC}"
if dart run flutter_launcher_icons; then
    echo -e "${GREEN}图标生成成功${NC}"
else
    echo -e "${RED}警告: 图标生成失败，将继续编译${NC}"
fi

# 编译 Release APK
echo -e "\n${YELLOW}[6/6] 编译 Release APK...${NC}"
flutter build apk --release

# 输出结果
echo -e "\n${GREEN}=========================================="
echo "  编译完成!"
echo "==========================================${NC}"
echo ""
echo "APK 位置: build/app/outputs/flutter-apk/app-release.apk"
echo "文件大小: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
echo ""

# 签名信息（如果需要）
if [ -f "android/upload-keystore.jks" ]; then
    echo "提示: 使用 debug 签名编译，如需正式签名请配置 key.properties"
fi

echo ""
echo -e "${YELLOW}提示: 如需使用百度地图，请确保已配置 SHA1${NC}"
