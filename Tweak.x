#import "HBBVListener.h"
#import <BackBoardServices/BKSDisplayBrightness.h>
#import <SpringBoard/SBBrightnessController.h>
#import <SpringBoard/SBBrightnessHUDView.h>
#import <SpringBoard/SBHUDController.h>
#import <SpringBoard/VolumeControl.h>
#import <version.h>

BOOL brightnessMode;
NSTimer *timer;

BOOL HBBVToggleMode() {
	brightnessMode = !brightnessMode;
	return brightnessMode;
}

void HBBVSetBrightness(BOOL direction, VolumeControl* volumeControl) {
#ifdef BRIGHTVOL_LEGACY
	[[%c(SBBrightnessController) sharedBrightnessController] adjustBacklightLevel:direction];
#else
	BKSDisplayBrightnessTransactionRef transaction = BKSDisplayBrightnessTransactionCreate(kCFAllocatorDefault);
	CGFloat brightness = BKSDisplayBrightnessGetCurrent() + (direction ? [%c(SBHUDView) progressIndicatorStep] : -[%c(SBHUDView) progressIndicatorStep]);

	if (brightness > 1.f) {
		brightness = 1.f;
	} else if (brightness < 0.f) {
		brightness = 0.f;
	}

	BKSDisplayBrightnessSet(brightness, 1);
	CFRelease(transaction);

	SBBrightnessHUDView *hud = [[[%c(SBBrightnessHUDView) alloc] init] autorelease];
	hud.progress = brightness;
	[[%c(SBHUDController) sharedHUDController] presentHUDView:hud autoDismissWithDelay:1];
#endif

	if (timer) {
		[timer invalidate];
		[timer release];
	}

	timer = [[NSTimer scheduledTimerWithTimeInterval:30 target:volumeControl selector:@selector(_brightvol_timerFired) userInfo:nil repeats:NO] retain];
}

%hook VolumeControl

- (void)increaseVolume {
	if (brightnessMode) {
		HBBVSetBrightness(YES, self);
	} else {
		%orig;
	}
}

- (void)decreaseVolume {
	if (brightnessMode) {
		HBBVSetBrightness(NO, self);
	} else {
		%orig;
	}
}

/*
 activator makes pressing volume keys call _changeVolumeBy:
 on ipad. most likely a leftover 3.2 compatibility thing...
*/

- (void)_changeVolumeBy:(CGFloat)by {
	if (brightnessMode) {
		if (by > 0) {
			[self increaseVolume];
		} else {
			[self decreaseVolume];
		}
	} else {
		%orig;
	}
}

%new - (void)_brightvol_timerFired {
	brightnessMode = NO;

	[timer release];
	timer = nil;
}

%end

%ctor {
	if (![[LAActivator sharedInstance] hasSeenListenerWithName:@"ws.hbang.brightvol"]) {
		[[LAActivator sharedInstance] assignEvent:[LAEvent eventWithName:@"libactivator.volume.both.press"] toListenerWithName:@"ws.hbang.brightvol"];
	}

	[[LAActivator sharedInstance] registerListener:[[HBBVListener alloc] init] forName:@"ws.hbang.brightvol"];
}
