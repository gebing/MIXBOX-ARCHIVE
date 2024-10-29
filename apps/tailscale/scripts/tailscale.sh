#!/bin/sh
source /etc/mixbox/bin/base
eval `mbdb export tailscale`

daemonname="tailscaled"
port=${port:-41641}
config_path="${mbroot}/var/state/tailscale"

start () {

	[ -n "$(pidof ${appname})" ] && logsh "【$service】" "${appname}已经在运行！" && exit 1
	logsh "【$service】" "正在启动${appname}服务... "
	cru a "${appname}" "0 6 * * * ${mbroot}/apps/${appname}/scripts/${appname}.sh restart"
	# Scripts Here
	${mbroot}/apps/${appname}/bin/${daemonname} --cleanup
	# Start tailscaled
	ARGS="--state $config_path/tailscaled.state"
	[ -n "$port" ] && ARGS="$ARGS --port $port"
	[ -d $config_path ] || mkdir -p $config_path
	daemon ${mbroot}/apps/${appname}/bin/${daemonname} $ARGS
	if [ $? -ne 0 ]; then
		logsh "【$service】" "启动${appname}服务失败！"
		exit 2
	fi
	# Login tailscale
	ARGS="up --reset"
	[ -n "$hostname" ] && ARGS="$ARGS --hostname=$hostname"
	${mbroot}/apps/${appname}/bin/${appname} $ARGS $extra_args
	if [ $? -ne 0 ]; then
		logsh "【$service】" "注册${appname}服务失败！"
		exit 3
	fi
	logsh "【$service】" "启动${appname}服务完成！"
}

stop () {

	logsh "【$service】" "正在停止${appname}服务... "
	${mbroot}/apps/${appname}/bin/${daemonname} --cleanup
	killall -9 ${daemonname} &> /dev/null
}


status() {
	if pgrep -x "${mbroot}/apps/${appname}/bin/${daemonname}" >/dev/null; then
		status="运行端口号: ${port}|1"
	else
		status="未运行|0"
	fi

	mbdb set $appname.main.status="$status"
}

case "$1" in
	start) start ;;
	stop) stop ;;
	restart) stop; start ;;
	reload) stop; start ;;
	status) status ;;
esac
