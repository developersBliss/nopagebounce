export ARCHS=armv7 arm64
export TARGET=iphone:latest:4.3

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = NoPageBounce
NoPageBounce_FILES = Tweak.xm
NoPageBounce_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += nopagebounceprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
