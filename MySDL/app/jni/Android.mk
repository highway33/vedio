LOCAL_PATH := $(call my-dir)

###########################
#
# SDL shared library
#
###########################

include $(CLEAR_VARS)

LOCAL_MODULE := SDL2

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

LOCAL_SRC_FILES := \
	$(subst $(LOCAL_PATH)/,, \
	$(wildcard $(LOCAL_PATH)/src/*.c) \
	$(wildcard $(LOCAL_PATH)/src/audio/*.c) \
	$(wildcard $(LOCAL_PATH)/src/audio/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/audio/dummy/*.c) \
	$(LOCAL_PATH)/src/atomic/SDL_atomic.c \
	$(LOCAL_PATH)/src/atomic/SDL_spinlock.c.arm \
	$(wildcard $(LOCAL_PATH)/src/core/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/cpuinfo/*.c) \
	$(wildcard $(LOCAL_PATH)/src/dynapi/*.c) \
	$(wildcard $(LOCAL_PATH)/src/events/*.c) \
	$(wildcard $(LOCAL_PATH)/src/file/*.c) \
	$(wildcard $(LOCAL_PATH)/src/haptic/*.c) \
	$(wildcard $(LOCAL_PATH)/src/haptic/dummy/*.c) \
	$(wildcard $(LOCAL_PATH)/src/joystick/*.c) \
	$(wildcard $(LOCAL_PATH)/src/joystick/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/loadso/dlopen/*.c) \
	$(wildcard $(LOCAL_PATH)/src/power/*.c) \
	$(wildcard $(LOCAL_PATH)/src/power/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/filesystem/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/render/*.c) \
	$(wildcard $(LOCAL_PATH)/src/render/*/*.c) \
	$(wildcard $(LOCAL_PATH)/src/stdlib/*.c) \
	$(wildcard $(LOCAL_PATH)/src/thread/*.c) \
	$(wildcard $(LOCAL_PATH)/src/thread/pthread/*.c) \
	$(wildcard $(LOCAL_PATH)/src/timer/*.c) \
	$(wildcard $(LOCAL_PATH)/src/timer/unix/*.c) \
	$(wildcard $(LOCAL_PATH)/src/video/*.c) \
	$(wildcard $(LOCAL_PATH)/src/video/android/*.c) \
	$(wildcard $(LOCAL_PATH)/src/test/*.c))

LOCAL_CFLAGS += -DGL_GLEXT_PROTOTYPES
LOCAL_LDLIBS := -ldl -lGLESv1_CM -lGLESv2 -llog -landroid

include $(BUILD_SHARED_LIBRARY)

###########################
#
# SDL static library
#
###########################

LOCAL_MODULE := SDL2_static

LOCAL_MODULE_FILENAME := libSDL2

LOCAL_SRC_FILES += $(subst $(LOCAL_PATH)/,,$(LOCAL_PATH)/src/main/android/SDL_android_main.c)

LOCAL_LDLIBS := 
LOCAL_EXPORT_LDLIBS := -Wl,--undefined=Java_org_libsdl_app_SDLActivity_nativeInit -ldl -lGLESv1_CM -lGLESv2 -llog -landroid

include $(BUILD_STATIC_LIBRARY)

################
#imag sdl library
####################
include $(CLEAR_VARS)

LOCAL_MODULE := SDL2_image

# Enable this if you want to support loading JPEG images
# The library path should be a relative path to this directory.
SUPPORT_JPG = true
JPG_LIBRARY_PATH := external/jpeg-9



# Enable this if you want to support loading PNG images
# The library path should be a relative path to this directory.
SUPPORT_PNG = true
PNG_LIBRARY_PATH := external/libpng-1.6.2

# Enable this if you want to support loading WebP images
# The library path should be a relative path to this directory.
#
# IMPORTANT: In order to enable this must have a symlink in your jni directory to external/libwebp-0.3.0.
SUPPORT_WEBP = false
WEBP_LIBRARY_PATH := external/libwebp-0.3.0


LOCAL_C_INCLUDES := $(LOCAL_PATH)
LOCAL_CFLAGS := -DLOAD_BMP -DLOAD_GIF -DLOAD_LBM -DLOAD_PCX -DLOAD_PNM \
                -DLOAD_TGA -DLOAD_XCF -DLOAD_XPM -DLOAD_XV
LOCAL_CFLAGS += -O3 -fstrict-aliasing -fprefetch-loop-arrays

LOCAL_SRC_FILES := $(notdir $(filter-out %/showimage.c, $(wildcard $(LOCAL_PATH)/*.c)))

LOCAL_LDLIBS := -ldl -lGLESv1_CM -lGLESv2 -llog -landroid
LOCAL_STATIC_LIBRARIES :=
LOCAL_SHARED_LIBRARIES := SDL2

ifeq ($(SUPPORT_JPG),true)
    LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(JPG_LIBRARY_PATH)
    LOCAL_CFLAGS += -DLOAD_JPG
    # We can include the sources directly so the user doesn't have to...
    #LOCAL_STATIC_LIBRARIES += jpeg
    LOCAL_CFLAGS += -DAVOID_TABLES
    LOCAL_SRC_FILES += \
        $(JPG_LIBRARY_PATH)/jaricom.c \
        $(JPG_LIBRARY_PATH)/jcapimin.c \
        $(JPG_LIBRARY_PATH)/jcapistd.c \
        $(JPG_LIBRARY_PATH)/jcarith.c \
        $(JPG_LIBRARY_PATH)/jccoefct.c \
        $(JPG_LIBRARY_PATH)/jccolor.c \
        $(JPG_LIBRARY_PATH)/jcdctmgr.c \
        $(JPG_LIBRARY_PATH)/jchuff.c \
        $(JPG_LIBRARY_PATH)/jcinit.c \
        $(JPG_LIBRARY_PATH)/jcmainct.c \
        $(JPG_LIBRARY_PATH)/jcmarker.c \
        $(JPG_LIBRARY_PATH)/jcmaster.c \
        $(JPG_LIBRARY_PATH)/jcomapi.c \
        $(JPG_LIBRARY_PATH)/jcparam.c \
        $(JPG_LIBRARY_PATH)/jcprepct.c \
        $(JPG_LIBRARY_PATH)/jcsample.c \
        $(JPG_LIBRARY_PATH)/jctrans.c \
        $(JPG_LIBRARY_PATH)/jdapimin.c \
        $(JPG_LIBRARY_PATH)/jdapistd.c \
        $(JPG_LIBRARY_PATH)/jdarith.c \
        $(JPG_LIBRARY_PATH)/jdatadst.c \
        $(JPG_LIBRARY_PATH)/jdatasrc.c \
        $(JPG_LIBRARY_PATH)/jdcoefct.c \
        $(JPG_LIBRARY_PATH)/jdcolor.c \
        $(JPG_LIBRARY_PATH)/jddctmgr.c \
        $(JPG_LIBRARY_PATH)/jdhuff.c \
        $(JPG_LIBRARY_PATH)/jdinput.c \
        $(JPG_LIBRARY_PATH)/jdmainct.c \
        $(JPG_LIBRARY_PATH)/jdmarker.c \
        $(JPG_LIBRARY_PATH)/jdmaster.c \
        $(JPG_LIBRARY_PATH)/jdmerge.c \
        $(JPG_LIBRARY_PATH)/jdpostct.c \
        $(JPG_LIBRARY_PATH)/jdsample.c \
        $(JPG_LIBRARY_PATH)/jdtrans.c \
        $(JPG_LIBRARY_PATH)/jerror.c \
        $(JPG_LIBRARY_PATH)/jfdctflt.c \
        $(JPG_LIBRARY_PATH)/jfdctfst.c \
        $(JPG_LIBRARY_PATH)/jfdctint.c \
        $(JPG_LIBRARY_PATH)/jidctflt.c \
        $(JPG_LIBRARY_PATH)/jidctint.c \
        $(JPG_LIBRARY_PATH)/jquant1.c \
        $(JPG_LIBRARY_PATH)/jquant2.c \
        $(JPG_LIBRARY_PATH)/jutils.c \
        $(JPG_LIBRARY_PATH)/jmemmgr.c \
        $(JPG_LIBRARY_PATH)/jmem-android.c

    # assembler support is available for arm
    ifeq ($(TARGET_ARCH),arm)
        LOCAL_SRC_FILES += $(JPG_LIBRARY_PATH)/jidctfst.S
    else
        LOCAL_SRC_FILES += $(JPG_LIBRARY_PATH)/jidctfst.c
    endif
endif

ifeq ($(SUPPORT_PNG),true)
    LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(PNG_LIBRARY_PATH)
    LOCAL_CFLAGS += -DLOAD_PNG
    # We can include the sources directly so the user doesn't have to...
    #LOCAL_STATIC_LIBRARIES += png
    LOCAL_SRC_FILES += \
        $(PNG_LIBRARY_PATH)/png.c \
        $(PNG_LIBRARY_PATH)/pngerror.c \
        $(PNG_LIBRARY_PATH)/pngget.c \
        $(PNG_LIBRARY_PATH)/pngmem.c \
        $(PNG_LIBRARY_PATH)/pngpread.c \
        $(PNG_LIBRARY_PATH)/pngread.c \
        $(PNG_LIBRARY_PATH)/pngrio.c \
        $(PNG_LIBRARY_PATH)/pngrtran.c \
        $(PNG_LIBRARY_PATH)/pngrutil.c \
        $(PNG_LIBRARY_PATH)/pngset.c \
        $(PNG_LIBRARY_PATH)/pngtrans.c \
        $(PNG_LIBRARY_PATH)/pngwio.c \
        $(PNG_LIBRARY_PATH)/pngwrite.c \
        $(PNG_LIBRARY_PATH)/pngwtran.c \
        $(PNG_LIBRARY_PATH)/pngwutil.c
    LOCAL_LDLIBS += -lz
endif

ifeq ($(SUPPORT_WEBP),true)
    LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(WEBP_LIBRARY_PATH)/src
    LOCAL_CFLAGS += -DLOAD_WEBP
    LOCAL_STATIC_LIBRARIES += webp
endif

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_C_INCLUDES)

include $(BUILD_SHARED_LIBRARY)


#libSDL2main=======================================
# Lei Xiaohua
include $(CLEAR_VARS)
LOCAL_MODULE := SDL2main
SDL_PATH := ./
LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(SDL_PATH)/include \
$(LOCAL_PATH)/$(SDL_PATH)/SDL_image.h \
$(LOCAL_PATH)/$(SDL_PATH)/miniz.h
# Add your application source files here...
LOCAL_SRC_FILES := $(SDL_PATH)/src/main/android/SDL_android_main.c \
    $(SDL_PATH)/simplest_showbmp.c
LOCAL_SHARED_LIBRARIES := SDL2_image SDL2 libutils libcutils
LOCAL_LDLIBS := -lGLESv1_CM -lGLESv2 -llog  -lm
include $(BUILD_SHARED_LIBRARY)
