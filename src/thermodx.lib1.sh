#!/vendor/bin/sh

#
# Main Library for ThermodX™
# This library helps the tool to do some basic tasks
# such as printing something or verbose a/an error in console
#
# Copyright (c) 2022 Youssef Mahmoud (UsiFX <xprjkts@gmail.com>)
#

TARGET_THERMODX_LIBRARY1_VERSION=1401

console_print()
{
	while getopts ":n:e:w:" opt
	do
		case "${opt}" in
			n) printf "[*] $2 \n" ;;
			e) printf "[×] $2 \n" ;;
			w) printf "[!] $2 \n" ;;
		esac
	done
}
