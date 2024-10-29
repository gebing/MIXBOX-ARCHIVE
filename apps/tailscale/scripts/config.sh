#!/bin/sh
#copyright by monlor

eval `mbdb export tailscale`
source "$(mbdb get mixbox.main.path)"/bin/base
echo "********* $service ***********"
echo "[${appinfo}]"
readsh "启动${appname}服务[1/0] " "enable" "1"
if [ "$enable" == '1' ]; then
    # Scripts Here
    readsh "请输入${appname}的UDP端口" "port" "41641"
    readsh "请输入${appname}的HostName" "hostname" ""
    readsh "请输入${appname}的附加参数" "extra_args" ""
    readsh "重启${appname}服务[1/0] " "res" "1"
    [ "$res" != '0' ] && exit 0
fi
exit 1
