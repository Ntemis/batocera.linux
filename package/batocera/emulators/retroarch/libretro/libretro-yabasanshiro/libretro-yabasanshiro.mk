################################################################################
#
# libretro-yabasanshiro
#
################################################################################
# Version: Commits on Jun 3, 2023
# Need to use this branch : https://github.com/libretro/yabause/tree/yabasanshiro
LIBRETRO_YABASANSHIRO_VERSION = 7513c8459034a0fe415d3cae4d692a54d0f90296
LIBRETRO_YABASANSHIRO_SITE = $(call github,libretro,yabause,$(LIBRETRO_YABASANSHIRO_VERSION))
LIBRETRO_YABASANSHIRO_LICENSE = GPLv2

LIBRETRO_YABASANSHIRO_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_XU4),y)
LIBRETRO_YABASANSHIRO_PLATFORM = odroid
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += BOARD=ODROID-XU4

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X)$(BR2_PACKAGE_BATOCERA_TARGET_A3GEN2),y)
LIBRETRO_YABASANSHIRO_PLATFORM = odroid-n2

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_BCM2711),y)
LIBRETRO_YABASANSHIRO_PLATFORM = rpi4

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3399),y)
LIBRETRO_YABASANSHIRO_PLATFORM = rockpro64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3288),y)
LIBRETRO_YABASANSHIRO_PLATFORM = RK RK3288

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S912),y)
LIBRETRO_YABASANSHIRO_PLATFORM = arm64_cortex_a53_gles3

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S905GEN3)$(BR2_PACKAGE_BATOCERA_TARGET_RK3568),y)
LIBRETRO_YABASANSHIRO_PLATFORM = odroid-c4

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3588),y)
LIBRETRO_YABASANSHIRO_PLATFORM = RK3588

else ifeq ($(BR2_aarch64),y)
LIBRETRO_YABASANSHIRO_PLATFORM = unix
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += arch=arm64 HAVE_SSE=0
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -shared -Wl,--no-undefined -pthread

else ifeq ($(BR2_x86_64),y)
LIBRETRO_YABASANSHIRO_PLATFORM = unix
LIBRETRO_YABASANSHIRO_EXTRA_ARGS = FORCE_GLES=0
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -shared -Wl,--no-undefined -pthread -lGL
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
LIBRETRO_YABASANSHIRO_DEPENDENCIES += libmali
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -lmali
endif

define LIBRETRO_YABASANSHIRO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		-C $(@D)/yabause/src/libretro -f Makefile platform="$(LIBRETRO_YABASANSHIRO_PLATFORM)" $(LIBRETRO_YABASANSHIRO_EXTRA_ARGS) \
        GIT_VERSION="-$(shell echo $(LIBRETRO_YABASANSHIRO_VERSION) | cut -c 1-7)"
endef

define LIBRETRO_YABASANSHIRO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/yabause/src/libretro/yabasanshiro_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/yabasanshiro_libretro.so
endef

$(eval $(generic-package))
