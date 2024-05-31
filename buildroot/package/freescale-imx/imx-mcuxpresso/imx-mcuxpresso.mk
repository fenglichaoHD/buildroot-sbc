################################################################################
#
# imx-mcuxpresso
#
################################################################################

IMX_MCUXPRESSO_VERSION = mcuxpresso_sdk_2.13.x
IMX_MCUXPRESSO_SITE = $(call github,fenglichaoHD,imx-mcuxpresso,$(IMX_MCUXPRESSO_VERSION))
IMX_MCUXPRESSO_LICENSE = GPL-2.0+
IMX_MCUXPRESSO_LICENSE_FILES = COPYING.GPL

# git, no configure
IMX_MCUXPRESSO_AUTORECONF = YES

	 
define IMX_MCUXPRESSO_BUILD_CMDS
	echo "$(@D)"
	export ARMGCC_DIR=$(HOST_DIR)/gcc-arm-none-eabi-10.3-2021.10 && \
	cd $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/  && ./build_all.sh
endef

define IMX_MCUXPRESSO_INSTALL_TARGET_CMDS
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/release/hello_world.bin ${BINARIES_DIR}/hello_world.bin  && \
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/release/hello_world.elf ${BINARIES_DIR}/hello_world.elf  && \
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/ddr_release/hello_world.bin ${BINARIES_DIR}/hello_world_ddr.bin  && \
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/ddr_release/hello_world.elf ${BINARIES_DIR}/hello_world_ddr.elf  && \
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/flash_release/hello_world.bin ${BINARIES_DIR}/hello_world_flash.bin && \
	cp $(@D)/boards/debix_mx8mp/demo_apps/hello_world/armgcc/flash_release/hello_world.elf ${BINARIES_DIR}/hello_world_flash.elf
endef

$(eval $(generic-package))
