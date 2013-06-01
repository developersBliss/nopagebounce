export ARCHS=armv7
export TARGET=iphone:latest:4.0

include theos/makefiles/common.mk

TWEAK_NAME = NoPageBounce
NoPageBounce_FILES = Tweak.xm
NoPageBounce_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
