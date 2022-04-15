#! /bin/bash

LOG_FILE="/var/log/cron/autoupdate.log"
DATETIME_STAMP=$(date +"%d.%m.%Y | %H:%M:%S")

PREFIX="---${DATETIME_STAMP}---"
SUFFIX="---------------------------"

DISTRO=$1

function Debian() {
	echo $PREFIX >> ${LOG_FILE}
	apt-get -q update && apt-get -q upgrade -y >> ${LOG_FILE}
	echo $SUFFIX >> ${LOG_FILE}
}

function Rhel() {
	echo $PREFIX >> ${LOG_FILE}
	dnf update -y >> ${LOG_FILE}
	echo $SUFFIX >> ${LOG_FILE}
}

if [[ "${DISTRO}" == "-d" ]] ; then
	Debian
elif [[ "${DISTRO}" == "-r" ]] ; then
	Rhel
else
	echo $PREFIX >> ${LOG_FILE}
	echo "Error: Invalid distro parameter" >> ${LOG_FILE}
	echo $SUFFIX >> ${LOG_FILE}
	exit 1
fi
