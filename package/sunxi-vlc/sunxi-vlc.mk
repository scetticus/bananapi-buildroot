################################################################################
#
# sunxi-vlc
#
################################################################################

SUNXI_VLC_VERSION = 2.0.5
SUNXI_VLC_SITE = https://sourceforge.net/projects/sunxivlc/files/
SUNXI_VLC_SOURCE = sunxi-vlc.tar.xz
SUNXI_VLC_DEPENDENCIES = host-pkgconf
SUNXI_VLC_AUTORECONF = YES

# SUNXI_VLC defines two autoconf functions which are also defined by our own pkg.m4
# from pkgconf. Unfortunately, they are defined in a different way: SUNXI_VLC adds
# --enable- options, but pkg.m4 adds --with- options. To make sure we use
# SUNXI_VLC's definition, rename these two functions.
define SUNXI_VLC_OVERRIDE_PKG_M4
	$(SED) 's/PKG_WITH_MODULES/SUNXI_VLC_PKG_WITH_MODULES/g' \
		-e 's/PKG_HAVE_WITH_MODULES/SUNXI_VLC_PKG_HAVE_WITH_MODULES/g' \
		$(@D)/configure.ac $(@D)/m4/with_pkg.m4
endef
SUNXI_VLC_POST_PATCH_HOOKS += SUNXI_VLC_OVERRIDE_PKG_M4

SUNXI_VLC_CONF_OPTS += \
	--disable-gles1 \
	--disable-a52 \
	--disable-shout \
	--disable-twolame \
	--disable-dca \
	--disable-schroedinger \
	--disable-fluidsynth \
	--disable-zvbi \
	--disable-kate \
	--disable-caca \
	--disable-jack \
	--disable-samplerate \
	--disable-chromaprint \
	--disable-goom \
	--disable-projectm \
	--disable-vsxu \
	--disable-mtp \
	--disable-opencv \
	--disable-mmal-codec \
	--disable-mmal-vout \
	--disable-dvdnav \
	--disable-vpx \
	--disable-jpeg \
	--disable-x262 \
	--disable-x265 \
	--disable-mfx \
	--disable-vdpau \
	--disable-addonmanagermodules \
	--disable-mad\
	--disable-xcb\
	--disable-alsa\
	--disable-libgcrypt\
	--enable-cedar\
	--enable-libdvbpsi\
	--enable-ffmpeg\

# Building static and shared doesn't work, so force static off.
ifeq ($(BR2_STATIC_LIBS),)
SUNXI_VLC_CONF_OPTS += --disable-static
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
SUNXI_VLC_CONF_OPTS += --enable-altivec
else
SUNXI_VLC_CONF_OPTS += --disable-altivec
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
SUNXI_VLC_CONF_OPTS += --enable-alsa
SUNXI_VLC_DEPENDENCIES += alsa-lib
else
SUNXI_VLC_CONF_OPTS += --disable-alsa
endif

# bonjour support needs avahi-client, which needs avahi-daemon and dbus
ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yyy)
SUNXI_VLC_CONF_OPTS += --enable-bonjour
SUNXI_VLC_DEPENDENCIES += avahi dbus
else
SUNXI_VLC_CONF_OPTS += --disable-bonjour
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
SUNXI_VLC_CONF_OPTS += --enable-dbus
SUNXI_VLC_DEPENDENCIES += dbus
else
SUNXI_VLC_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_DIRECTFB),y)
SUNXI_VLC_CONF_OPTS += --enable-directfb
SUNXI_VLC_CONF_ENV += ac_cv_path_DIRECTFB_CONFIG=$(STAGING_DIR)/usr/bin/directfb-config
SUNXI_VLC_DEPENDENCIES += directfb
else
SUNXI_VLC_CONF_OPTS += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_FAAD2),y)
SUNXI_VLC_CONF_OPTS += --enable-faad
SUNXI_VLC_DEPENDENCIES += faad2
else
SUNXI_VLC_CONF_OPTS += --disable-faad
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
SUNXI_VLC_CONF_OPTS += --enable-avcodec
SUNXI_VLC_DEPENDENCIES += ffmpeg
else
SUNXI_VLC_CONF_OPTS += --disable-avcodec
endif

ifeq ($(BR2_PACKAGE_FFMPEG_POSTPROC),y)
SUNXI_VLC_CONF_OPTS += --enable-postproc
else
SUNXI_VLC_CONF_OPTS += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
SUNXI_VLC_CONF_OPTS += --enable-swscale
else
SUNXI_VLC_CONF_OPTS += --disable-swscale
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
SUNXI_VLC_CONF_OPTS += --enable-flac
SUNXI_VLC_DEPENDENCIES += flac
else
SUNXI_VLC_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_FREERDP),y)
SUNXI_VLC_CONF_OPTS += --enable-freerdp
SUNXI_VLC_DEPENDENCIES += freerdp
else
SUNXI_VLC_CONF_OPTS += --disable-libfreerdp
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
SUNXI_VLC_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
SUNXI_VLC_CONF_OPTS += --enable-gles2
SUNXI_VLC_DEPENDENCIES += libgles
else
SUNXI_VLC_CONF_OPTS += --disable-gles2
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
SUNXI_VLC_CONF_OPTS += --enable-opus
SUNXI_VLC_DEPENDENCIES += libvorbis opus
else
SUNXI_VLC_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_LIBASS),y)
SUNXI_VLC_CONF_OPTS += --enable-libass
SUNXI_VLC_DEPENDENCIES += libass
else
SUNXI_VLC_CONF_OPTS += --disable-libass
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
SUNXI_VLC_CONF_OPTS += --enable-libgcrypt
SUNXI_VLC_DEPENDENCIES += libgcrypt
SUNXI_VLC_CONF_ENV += \
	GCRYPT_CONFIG="$(STAGING_DIR)/usr/bin/libgcrypt-config"
else
SUNXI_VLC_CONF_OPTS += --disable-libgcrypt
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
SUNXI_VLC_CONF_OPTS += --enable-mad
SUNXI_VLC_DEPENDENCIES += libmad
else
SUNXI_VLC_CONF_OPTS += --disable-mad
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
SUNXI_VLC_CONF_OPTS += --enable-mod
SUNXI_VLC_DEPENDENCIES += libmodplug
else
SUNXI_VLC_CONF_OPTS += --disable-mod
endif

ifeq ($(BR2_PACKAGE_LIBMPEG2),y)
SUNXI_VLC_CONF_OPTS += --enable-libmpeg2
SUNXI_VLC_DEPENDENCIES += libmpeg2
else
SUNXI_VLC_CONF_OPTS += --disable-libmpeg2
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
SUNXI_VLC_CONF_OPTS += --enable-png
SUNXI_VLC_DEPENDENCIES += libpng
else
SUNXI_VLC_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
SUNXI_VLC_CONF_OPTS += --enable-svg --enable-svgdec
SUNXI_VLC_DEPENDENCIES += librsvg
else
SUNXI_VLC_CONF_OPTS += --disable-svg --disable-svgdec
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
SUNXI_VLC_CONF_OPTS += --enable-theora
SUNXI_VLC_DEPENDENCIES += libtheora
else
SUNXI_VLC_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_LIBUPNP),y)
SUNXI_VLC_CONF_OPTS += --enable-upnp
SUNXI_VLC_DEPENDENCIES += libupnp
else
SUNXI_VLC_CONF_OPTS += --disable-upnp
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SUNXI_VLC_CONF_OPTS += --enable-vorbis
SUNXI_VLC_DEPENDENCIES += libvorbis
else
SUNXI_VLC_CONF_OPTS += --disable-vorbis
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
SUNXI_VLC_CONF_OPTS += --enable-v4l2
SUNXI_VLC_DEPENDENCIES += libv4l
else
SUNXI_VLC_CONF_OPTS += --disable-v4l2
endif

ifeq ($(BR2_PACKAGE_LIBXCB),y)
SUNXI_VLC_CONF_OPTS += --enable-xcb
SUNXI_VLC_DEPENDENCIES += libxcb
else
SUNXI_VLC_CONF_OPTS += --disable-xcb
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
SUNXI_VLC_CONF_OPTS += --enable-libxml2
SUNXI_VLC_DEPENDENCIES += libxml2
else
SUNXI_VLC_CONF_OPTS += --disable-libxml2
endif

ifeq ($(BR2_PACKAGE_LIVE555),y)
SUNXI_VLC_CONF_OPTS += --enable-live555
SUNXI_VLC_DEPENDENCIES += live555
SUNXI_VLC_CONF_ENV += \
	LIVE555_CFLAGS="\
		-I$(STAGING_DIR)/usr/include/BasicUsageEnvironment \
		-I$(STAGING_DIR)/usr/include/groupsock \
		-I$(STAGING_DIR)/usr/include/liveMedia \
		-I$(STAGING_DIR)/usr/include/UsageEnvironment \
		" \
	LIVE555_LIBS="-L$(STAGING_DIR)/usr/lib -lliveMedia"
else
SUNXI_VLC_CONF_OPTS += --disable-live555
endif

ifeq ($(BR2_PACKAGE_LUA),y)
SUNXI_VLC_CONF_OPTS += --enable-lua
SUNXI_VLC_DEPENDENCIES += lua host-lua
else
SUNXI_VLC_CONF_OPTS += --disable-lua
endif

ifeq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
SUNXI_VLC_CONF_OPTS += --enable-qt
SUNXI_VLC_CONF_ENV += \
	ac_cv_path_MOC=$(HOST_DIR)/usr/bin/moc \
	ac_cv_path_RCC=$(HOST_DIR)/usr/bin/rcc \
	ac_cv_path_UIC=$(HOST_DIR)/usr/bin/uic
SUNXI_VLC_DEPENDENCIES += qt
else
SUNXI_VLC_CONF_OPTS += --disable-qt
endif

ifeq ($(BR2_PACKAGE_SDL_X11),y)
SUNXI_VLC_CONF_OPTS += --enable-sdl
SUNXI_VLC_DEPENDENCIES += sdl
else
SUNXI_VLC_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_SDL_IMAGE),y)
SUNXI_VLC_CONF_OPTS += --enable-sdl-image
SUNXI_VLC_DEPENDENCIES += sdl_image
else
SUNXI_VLC_CONF_OPTS += --disable-sdl-image
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
SUNXI_VLC_CONF_OPTS += --enable-speex
SUNXI_VLC_DEPENDENCIES += speex
else
SUNXI_VLC_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_TREMOR),y)
SUNXI_VLC_CONF_OPTS += --enable-tremor
SUNXI_VLC_DEPENDENCIES += tremor
else
SUNXI_VLC_CONF_OPTS += --disable-tremor
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
SUNXI_VLC_CONF_OPTS += --enable-udev
SUNXI_VLC_DEPENDENCIES += udev
else
SUNXI_VLC_CONF_OPTS += --disable-udev
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
SUNXI_VLC_CONF_OPTS += --with-x
SUNXI_VLC_DEPENDENCIES += xlib_libX11
else
SUNXI_VLC_CONF_OPTS += --without-x
endif

$(eval $(autotools-package))
