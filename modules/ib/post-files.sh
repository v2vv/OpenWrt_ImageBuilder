
# 用 CONFIG_* 环境变量更新 .config
printenv | grep '^CONFIG_' | while IFS='=' read -r config_name config_value; do
    sed -i "s|^$config_name=.*|$config_name=$config_value|" .config
done

# 判断项目名称
if echo "$PWD" | grep -q "immortalwrt"; then
    PROJECT_NAME="immortalwrt"
else
    PROJECT_NAME="openwrt"
fi

# 如果启用镜像源
if [ "$USE_MIRROR" = "1" ]; then
    sed -i "s|https://downloads.$PROJECT_NAME.org|https://$MIRROR/$PROJECT_NAME|g" ./repositories.conf
fi
