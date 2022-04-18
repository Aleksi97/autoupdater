#! /bin/bash

LOG_DIR="/var/log/cron/"
LOG_FILE="autoupdate.log"
DATETIME_STAMP=$(date +"%d.%m.%Y | %H:%M:%S")

PREFIX="---------------------------\n---${DATETIME_STAMP}---"
SUFFIX="---------------------------\n"

DISTRO=$1

function Debian() {
	echo -e $PREFIX >> ${LOG_DIR}${LOG_FILE}
	apt-get -q update && apt-get -q upgrade -y >> ${LOG_DIR}${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_DIR}${LOG_FILE}
	exit 1
}

function Rhel() {
	echo -e $PREFIX >> ${LOG_DIR}${LOG_FILE}
	dnf update -y >> ${LOG_DIR}${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_DIR}${LOG_FILE}
	exit 1
}

function OpenSuse() {
	echo -e $PREFIX >> ${LOG_DIR}${LOG_FILE}
	sudo zypper refresh && sudo zypper update -y >> ${LOG_DIR}${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_DIR}${LOG_FILE}
	exit 1
}

function Error() {
	echo -e $PREFIX >> ${LOG_DIR}${LOG_FILE}
	echo "Error: Invalid distro parameter or it wasn't given." >> ${LOG_DIR}${LOG_FILE}
	echo -e $SUFFIX >> ${LOG_DIR}${LOG_FILE}
	exit 1
}

[[ ! -d ${LOG_DIR} ]] && mkdir ${LOG_DIR} && touch ${LOG_DIR}${LOG_FILE}

[[ -z "$DISTRO" ]] && Error

[[ "${DISTRO}" == "-d" ]] && Debian
[[ "${DISTRO}" == "-r" ]] && Rhel
[[ "${DISTRO}" == "-os" ]] && OpenSuse
Error
