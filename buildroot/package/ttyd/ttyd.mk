################################################################################
#
# ttyd
#
################################################################################

TTYD_VERSION = 1.7.3
TTYD_SITE = $(call github,tsl0922,ttyd,$(TTYD_VERSION))
TTYD_LICENSE = MIT
TTYD_LICENSE_FILES = LICENSE
TTYD_DEPENDENCIES = json-c libuv libwebsockets openssl zlib
TTYD_CPE_ID_VALID = YES

$(eval $(cmake-package))
