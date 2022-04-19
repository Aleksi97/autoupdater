#! /bin/bash

LOG_DIRPATH="/var/log/autoupdate/"
LOG_FILENAME="autoupdate.log"
DATETIME_STAMP=$(date +"%d.%m.%Y | %H:%M:%S")

LOG=${LOG_DIRPATH}${LOG_FILENAME}

PREFIX="---------------------------\n---${DATETIME_STAMP}---"
UPDATE="\n***UPDATE***\n"
UPGRADE="\n***UPGRADE***\n"
SUFFIX="---------------------------\n"

APT=("debian", "ubuntu", "linuxmint", "peppermint", "elementary", "zorin", "kali", "pop", "Deepin", "sparky", "devuan")
DNF=("rhel", "fedora", "rocky", "centos", "almalinux", "ol", "mageia", "qubes", "eurolinux", "openmandriva", "openmamba")
ZYPPER="opensuse"
DISTRO="$(. /etc/os-release; echo "$ID")"

function Apt() {
	echo -e $PREFIX >> ${LOG}
	echo -e $UPDATE >> ${LOG} && apt-get update >> ${LOG}
	echo -e $UPGRADE >> ${LOG} && apt-get upgrade -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function Dnf() {
	echo -e $PREFIX >> ${LOG}
	echo "\n***UPDATES AND UPGRADES***\n" >> ${LOG}
	dnf update -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function Zypper() {
	echo -e $PREFIX >> ${LOG}
	echo -e $UPDATE >> ${LOG} && zypper refresh >> ${LOG}
       	echo -e $UPGRADE >> ${LOG} && zypper update -y >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

function Error() {
	echo -e $PREFIX >> ${LOG}
	echo "Error: Distro not recognized" >> ${LOG}
	echo -e $SUFFIX >> ${LOG}
	exit 1
}

[[ ! -d ${LOG_DIRPATH} ]] && mkdir ${LOG_DIRPATH} && touch ${LOG}

[[ "${APT[*]}" =~ "${DISTRO}" ]] && Apt
[[ "${DNF[*]}" =~ "${DISTRO}" ]] && Dnf
[[ "${DISTRO}" == *"${ZYPPER}"* ]] && Zypper
Error
