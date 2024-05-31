#!/usr/bin/env bash

main ()
{
	if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MP=y$" ${BR2_CONFIG}; then

		if [[ ! -d $HOST_DIR/gcc-arm-none-eabi-10.3-2021.10 ]]; then
			if [[ ! -e $HOST_DIR/toolchain/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 ]]; then
				mkdir -p $HOST_DIR/toolchain
				wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -P $HOST_DIR/toolchain
				tar xvf $HOST_DIR/toolchain/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C  $HOST_DIR/
			else
				tar xvf $HOST_DIR/toolchain/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C  $HOST_DIR/
			fi
		fi
	fi

	exit $?
}

set -e
main $@


