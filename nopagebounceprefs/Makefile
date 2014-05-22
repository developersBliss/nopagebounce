include theos/makefiles/common.mk

BUNDLE_NAME = nopagebounceprefs
nopagebounceprefs_FILES = nopagebounceprefs.mm
nopagebounceprefs_INSTALL_PATH = /Library/PreferenceBundles
nopagebounceprefs_FRAMEWORKS = UIKit
nopagebounceprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/nopagebounceprefs.plist$(ECHO_END)
