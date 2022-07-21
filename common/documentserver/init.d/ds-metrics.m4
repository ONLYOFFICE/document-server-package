#!/bin/sh

### BEGIN INIT INFO
# Provides:			ds-metrics
# Required-Stop:		$remote_fs $network $named
# Required-Stop:		$remote_fs $network $named
# Default-Start:		2 3 5
# Default-Stop:		0 1 6
# Short-Description:	Docs Metrics
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

DAEMON="/var/www/M4_DS_PREFIX/server/Metrics/metrics"
DAEMON_CONFIG="/var/www/M4_DS_PREFIX/server/Metrics/config/config.js"
DAEMON_ARGS="NODE_DISABLE_COLORS=1"
LOG_DIR="/var/log/M4_DS_PREFIX/metrics"
NAME="ds-metrics"
DESC="Docs Metrics"
USER="ds"
PID_FILE="/var/run/ds/${NAME}.pid"
STOP_SCHEDULE="${STOP_SCHEDULE:-QUIT/5/TERM/5/KILL/5}"

test -x ${DAEMON} || exit 0

RETVAL=0
set -e

[ -f /etc/default/${NAME} ] && . /etc/default/${NAME}

. /lib/init/vars.sh
. /lib/lsb/init-functions

ensure_pid_dir () {
	PID_DIR=$(dirname ${PID_FILE})
	if [ ! -d ${PID_DIR} ]; then
		mkdir -p ${PID_DIR}
		chown -R ${USER}:${USER} ${PID_DIR}
		chmod 755 ${PID_DIR}
	fi
}

remove_pid () {
	rm -f ${PID_FILE}
}

start_ds() {
		status_ds quiet
		if [ ${RETVAL} != 0 ] ; then
			ensure_pid_dir
			set +e
			start-stop-daemon --start --quiet --chuid ${USER}:${USER} \
			--make-pidfile --pidfile ${PID_FILE} --background \
			--startas /bin/bash -- -c "${DAEMON_ARGS} exec ${DAEMON} ${DAEMON_CONFIG} \
			>> ${LOG_DIR}/out.log 2>> ${LOG_DIR}/err.log"
			RETVAL=$?
			set -e
			if [ ${RETVAL} != 0 ]; then
					remove_pid
			fi
		else
		RETVAL=3
	fi
}


stop_ds() {
	status_ds quiet
	if [ ${RETVAL} = 0 ]; then
		set +e
		start-stop-daemon --stop --quiet --retry=${STOP_SCHEDULE} --oknodo --pidfile ${PID_FILE}
		RETVAL=$?
		set -e
		if [ ${RETVAL} = 0 ]; then
			remove_pid
		fi
	else
		RETVAL=3
	fi
}

status_ds() {
	set +e
	if [ "$1" != "quiet" ]; then
		status_of_proc -p ${PID_FILE} "${DAEMON}" "${NAME}" 2>&1
	else
		status_of_proc -p ${PID_FILE} "${DAEMON}" "${NAME}" >/dev/null 2>&1
	fi
	
	if [ $? != 0 ]; then
		RETVAL=3
	fi
}

start_stop_end() {
	case "${RETVAL}" in
		0)
			[ -x /sbin/initctl ] && /sbin/initctl emit --no-wait "${NAME}-${1}"
			log_end_msg 0
			;;
		3)
			log_warning_msg "${DESC} already ${1}"
			log_end_msg 0
			RETVAL=0
			;;
		*)
			log_warning_msg "FAILED"
			log_end_msg 1
			;;
	esac
}

case "$1" in
	start)
		log_daemon_msg "Starting ${DESC}" ${NAME}
		start_ds
		start_stop_end "running"
		;;
	stop)
		log_daemon_msg "Stopping ${DESC}" ${NAME}
		stop_ds
		start_stop_end "stopped"
		;;
	restart)
		log_daemon_msg "Restarting $DESC" ${NAME}
		stop_ds
		start_ds
		if [ ${RETVAL} = 0 ] ; then
			log_end_msg 0
		else
			log_end_msg 1
		fi

		;;
	status)
		status_ds
		;;
	*)
		echo "Usage: /etc/init.d/${NAME} {start|stop|restart|status}" >&2
		exit 3
		;;
esac

exit ${RETVAL}