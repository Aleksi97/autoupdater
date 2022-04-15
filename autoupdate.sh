#! /bin/bash

LOG_FILE="/var/log/cron/autoupdate.log"
DATETIME_STAMP=$(date +"%d.%m.%Y | %H:%M:%S")

PREFIX="---------------------------\n---${DATETIME_STAMP}---"
SUFFIX="---------------------------\n"

DISTRO=$1

function Debian() {
	echo -e $PREFIX >> ${LOG_FILE}
	apt-get -q update && apt-get -q upgrade -y >> ${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_FILE}
}

function Rhel() {
	echo -e $PREFIX >> ${LOG_FILE}
	dnf update -y >> ${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_FILE}
}

if [[ -n "$DISTRO" ]] && [[ "${DISTRO}" == "-d" ]] ; then
	Debian
elif [[ -n "$DISTRO" ]] && [[ "${DISTRO}" == "-r" ]] ; then
	Rhel
else
	echo -e $PREFIX >> ${LOG_FILE}
	echo "Error: Invalid distro parameter" >> ${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_FILE}
	exit 1
fi
