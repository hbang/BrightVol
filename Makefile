include theos/makefiles/common.mk

TWEAK_NAME = BrightVol
BrightVol_FILES = Tweak.xm
BrightVol_FRAMEWORKS = UIKit
BrightVol_PRIVATE_FRAMEWORKS = GraphicsServices
BrightVol_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
