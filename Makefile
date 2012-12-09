TARGET = iphone:5.1:5.0

include theos/makefiles/common.mk

TWEAK_NAME = BrightVol
BrightVol_FILES = Tweak.xm
BrightVol_FRAMEWORKS = UIKit
BrightVol_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
