TARGET = iphone::4.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BrightVol BrightVolLegacy

BrightVol_FILES = $(wildcard *.x)
BrightVol_FRAMEWORKS = UIKit
BrightVol_PRIVATE_FRAMEWORKS = BackBoardServices
BrightVol_LIBRARIES = activator
BrightVol_ARCHS = armv7 arm64

BrightVolLegacy_FILES = $(wildcard *.x)
BrightVolLegacy_FRAMEWORKS = UIKit
BrightVolLegacy_LIBRARIES = activator
BrightVolLegacy_CFLAGS = -DBRIGHTVOL_LEGACY
BrightVolLegacy_ARCHS = armv6

include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Activator/Listeners/ws.hbang.brightvol$(ECHO_END)
	$(ECHO_NOTHING)cp -r Resources/ $(THEOS_STAGING_DIR)/Library/Activator/Listeners/ws.hbang.brightvol$(ECHO_END)

after-install::
	install.exec spring
