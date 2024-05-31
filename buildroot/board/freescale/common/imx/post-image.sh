#!/usr/bin/env bash

#
# dtb_list extracts the list of DTB files from BR2_LINUX_KERNEL_INTREE_DTS_NAME
# in ${BR_CONFIG}, then prints the corresponding list of file names for the
# genimage configuration file
#
dtb_list()
{
	local DTB_LIST

	DTB_LIST="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\([\/a-z0-9 \-]*\)"$/\1/p' "${BR2_CONFIG}")"

	for dt in $DTB_LIST; do
		echo -n "\"$(basename "${dt}").dtb\", "
	done
	echo -n "\"imx8mp-debix-model-a-m7.dtb\","
}

#
# linux_image extracts the Linux image format from BR2_LINUX_KERNEL_UIMAGE in
# ${BR_CONFIG}, then prints the corresponding file name for the genimage
# configuration file
#
linux_image()
{
	if grep -Eq "^BR2_LINUX_KERNEL_UIMAGE=y$" "${BR2_CONFIG}"; then
		echo "\"uImage\""
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGE=y$" "${BR2_CONFIG}"; then
		echo "\"Image\""
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGEGZ=y$" "${BR2_CONFIG}"; then
		echo "\"Image.gz\""
	else
		echo "\"zImage\""
	fi
}

genimage_type()
{
	if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8M=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MM=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MN=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MP=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8X=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8DXL=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx8"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX91=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx9"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX93=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_imx9"
	elif grep -Eq "^BR2_LINUX_KERNEL_INSTALL_TARGET=y$" "${BR2_CONFIG}"; then
		if grep -Eq "^BR2_TARGET_UBOOT_SPL=y$" "${BR2_CONFIG}"; then
		    echo "genimage.cfg.template_no_boot_part_spl"
		else
		    echo "genimage.cfg.template_no_boot_part"
		fi
	elif grep -Eq "^BR2_TARGET_UBOOT_SPL=y$" "${BR2_CONFIG}"; then
		echo "genimage.cfg.template_spl"
	else
		echo "genimage.cfg.template"
	fi
}

imx_offset()
{
	if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8M=y$" "${BR2_CONFIG}"; then
		echo "33K"
	elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MM=y$" "${BR2_CONFIG}"; then
		echo "33K"
	else
		echo "32K"
	fi
}

uboot_image()
{
	if grep -Eq "^BR2_TARGET_UBOOT_FORMAT_DTB_IMX=y$" "${BR2_CONFIG}"; then
		echo "u-boot-dtb.imx"
	elif grep -Eq "^BR2_TARGET_UBOOT_FORMAT_IMX=y$" "${BR2_CONFIG}"; then
		echo "u-boot.imx"
	elif grep -Eq "^BR2_TARGET_UBOOT_FORMAT_DTB_IMG=y$" "${BR2_CONFIG}"; then
	    echo "u-boot-dtb.img"
	elif grep -Eq "^BR2_TARGET_UBOOT_FORMAT_IMG=y$" "${BR2_CONFIG}"; then
	    echo "u-boot.img"
	fi
}

mcu_image()
{
	echo ",\"hello_world.bin\", \"hello_world.elf\", \"hello_world_ddr.bin\", \"hello_world_ddr.elf\", \"hello_world_flash.bin\" , \"hello_world_flash.elf\" "
}

main()
{
	local FILES IMXOFFSET UBOOTBIN GENIMAGE_CFG GENIMAGE_TMP EXTLINUX
	FILES="$(dtb_list) $(linux_image)  $(mcu_image)"
	echo "$(dtb_list)"
	echo "$FILES"
	EXTLINUX="extlinux.conf"
	IMXOFFSET="$(imx_offset)"
	UBOOTBIN="$(uboot_image)"
	GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	echo "------------------>${EXTLINUX}"
	sed -e "s/%FILES%/${FILES}/" \
		-e "s/%IMXOFFSET%/${IMXOFFSET}/" \
		-e "s/%UBOOTBIN%/${UBOOTBIN}/" \
		-e "s/%EXTLINUX%/${EXTLINUX}/" \
		"board/freescale/common/imx/$(genimage_type)" > "${GENIMAGE_CFG}"

	rm -rf "${GENIMAGE_TMP}"

	genimage \
		--rootpath "${TARGET_DIR}" \
		--tmppath "${GENIMAGE_TMP}" \
		--inputpath "${BINARIES_DIR}" \
		--outputpath "${BINARIES_DIR}" \
		--config "${GENIMAGE_CFG}"

	rm -f "${GENIMAGE_CFG}"

	exit $?
}

main "$@"
