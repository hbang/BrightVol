#import "HBBVListener.h"
#import <BackBoardServices/BKSDisplayBrightness.h>
#import <SpringBoard/SBBrightnessController.h>
#import <SpringBoard/SBHUDController.h>
#import <SpringBoard/SBHUDView.h>
#import <SpringBoard/VolumeControl.h>

@implementation HBBVListener {
	NSTimer *_timer;
}

- (void)setBrightness:(BOOL)direction volumeControl:(VolumeControl *)volumeControl {
	[[%c(SBBrightnessController) sharedBrightnessController] adjustBacklightLevel:direction];

#ifndef BRIGHTVOL_LEGACY
	BKSDisplayBrightnessTransactionRef transaction = BKSDisplayBrightnessTransactionCreate(kCFAllocatorDefault);
	BKSDisplayBrightnessSet(BKSDisplayBrightnessGetCurrent(), 1);
	CFRelease(transaction);
#endif

	// if a timer already exists, cancel it
	if (_timer) {
		[_timer invalidate];
	}

	// set a new timer
	_timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeoutFired) userInfo:nil repeats:NO];
}

- (void)timeoutFired {
	// the timer has expired, so we need to reset the mode back to default
	_brightnessMode = NO;
	_timer = nil;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	// tell activator we’re handling this event
	event.handled = YES;

	// flip the mode
	_brightnessMode = !_brightnessMode;

	// show a HUD with the current mode icon so the user knows what mode they’re in now
	SBHUDView *hud = [[%c(SBHUDView) alloc] initWithHUDViewLevel:0];
	hud.image = [UIImage imageNamed:_brightnessMode ? @"brightness" : @"speaker"];
	[[%c(SBHUDController) sharedHUDController] presentHUDView:hud autoDismissWithDelay:1];
}

@end
