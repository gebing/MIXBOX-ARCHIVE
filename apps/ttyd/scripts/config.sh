#!/bin/sh
#copyright by monlor

eval `mbdb export ttyd`
source "$(mbdb get mixbox.main.path)"/bin/base
echo "********* $service ***********"
echo "[${appinfo}]"
readsh "启动${appname}服务[1/0] " "enable" "1"
if [ "$enable" == '1' ]; then
    # Scripts Here
    readsh "请输入${appname}端口号" "port" "7681"
    readsh "请输入${appname}的SSL证书路径" "cert_file" ""
    readsh "请输入${appname}的SSL私钥路径" "key_file" ""
    readsh "请输入${appname}外网访问配置[1/0]" "openport" "0"
    readsh "重启${appname}服务[1/0] " "res" "1"
    [ "$res" != '0' ] && exit 0
fi
exit 1