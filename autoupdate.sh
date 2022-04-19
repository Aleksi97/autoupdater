#! /bin/bash

LOG_DIRPATH="/var/log/cron/"
LOG_FILENAME="autoupdate.log"
DATETIME_STAMP=$(date +"%d.%m.%Y | %H:%M:%S")

LOG=${LOG_DIRPATH}${LOG_FILENAME}

PREFIX="---------------------------\n---${DATETIME_STAMP}---"
UPDATE="\n***UPDATE***\n"
UPGRADE="\n***UPGRADE***\n"
SUFFIX="---------------------------\n"

DISTRO=$1

function Debian() {
	echo -e $PREFIX >> ${LOG}
	echo -e $UPDATE >> ${LOG} && apt-get update >> ${LOG}
	echo -e $UPGRADE >> ${LOG} && apt-get upgrade -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function Rhel() {
	echo -e $PREFIX >> ${LOG}
	echo "\n***UPDATES AND UPGRADES***\n" >> ${LOG}
	dnf update -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function OpenSuse() {
	echo -e $PREFIX >> ${LOG}
	echo -e $UPDATE >> ${LOG} && zypper refresh >> ${LOG}
       	echo -e $UPGRADE >> ${LOG} && zypper update -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function Error() {
	echo -e $PREFIX >> ${LOG}
	echo "Error: Invalid distro argument or it wasn't given." >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

[[ ! -d ${LOG_DIRPATH} ]] && mkdir ${LOG_DIRPATH} && touch ${LOG}

[[ -z "$DISTRO" ]] && Error

[[ "${DISTRO}" == "-d" ]] && Debian
[[ "${DISTRO}" == "-r" ]] && Rhel
[[ "${DISTRO}" == "-os" ]] && OpenSuse
Error
