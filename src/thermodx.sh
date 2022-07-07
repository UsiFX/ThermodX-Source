#!/vendor/bin/sh
#
#   Copyright (C) 2022  xprjkt°
#   Copyright (C) 2021 2022  Youssef Mahmoud
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Tool version
export THERMODX_VERSION=1401

MODPATH="/data/adb/modules/ThermodX"
THERMAL_SOURCES=$(echo /system/vendor/etc/thermal*.conf /vendor/etc/thermal*.conf 2>&1)
TARGET_COMPATIBLE=true
TARGET_DEV_MODE=true

source $(pwd)/thermodx.lib1.sh

##########
# init
##########

__setup_workspace()
{
	if [ ! -d ${MODPATH}/.workspace ]; then
		mkdir ${MODPATH}/.workspace
	fi
}

__backup_thermals()
{
	if [ ! -d ${MODPATH}/.workspace/bckup ]; then
		mkdir -p ${MODPATH}/.workspace/bckup
		for bckup in ${THERMAL_SOURCES[@]}
		do
			cp -af $bckup ${MODPATH}/.workspace/bckup
		done
	fi
}

__compatible_check()
{
	if $(getprop ro.boot.hardware | grep qcom); then
		TARGET_IS_QCOM=true
	elif $(getprop ro.boot.hardware | grep exynos); then
		TARGET_IS_EXYNOS=true
	elif $(getprop ro.boot.hardware | grep mt); then
		TARGET_IS_MTK=true
	else
		TARGET_ARCH_UNKNOWN=true
		TARGET_COMPATIBLE=false
	fi
}

__print_help()
{
cat <<EOF
usage: thermodx [-v | --version] [-h | --help]

These are common ThermodX arguments used for every situation
[WIP]

EOF
}

if [[ ${TARGET_DEV_MODE} == 'true' ]]; then
	set -x
	if [ ${MODPATH} != *$(pwd)* ]; then
		typeset -r MODPATH=$(pwd)
		__setup_workspace
	fi
else
	set +x
fi

if [ $# -eq "0" ] && tty -s
then
	__print_help
else
		case $* in
			"-h"|"--help") __print_help ;;
			"-v"|"--version") echo "ThermodX version 1.4.0.1" ;;
			*) console_print -w "$0: '$*' is not thermodx command, See 'thermodx --help'." ;;
		esac
fi
