#!/usr/bin/env bash

main ()
{
	cp $BUILD_DIR/linux-lf-6.6.y/arch/arm64/boot/dts/freescale/imx8mp-debix*.dtb  ${BINARIES_DIR}/
	exit $?
}

set -e
main $@
