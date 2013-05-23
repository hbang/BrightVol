/**
 * BrightVol
 *
 * by HASHBANG Productions <http://hbang.ws>
 * GPL licensed <http://hbang.ws/s/gpl>
 */

#import <libactivator/libactivator.h>
#import <SpringBoard/SBBrightnessController.h>
#import <SpringBoard/VolumeControl.h>
#import <SpringBoard/SBRotationLockHUDView.h>
#import <SpringBoard/SBHUDController.h>

static BOOL brightnessMode = NO;
static NSTimer *timer;

@interface ADBrightVolListener : NSObject <LAListener>
@end
 
@implementation ADBrightVolListener
+ (void)load {
	if (![[LAActivator sharedInstance] hasSeenListenerWithName:@"ws.hbang.brightvol"]) {
		[[LAActivator sharedInstance] assignEvent:[LAEvent eventWithName:@"libactivator.volume.both.press"] toListenerWithName:@"ws.hbang.brightvol"];
	}

	[[LAActivator sharedInstance] registerListener:[self new] forName:@"ws.hbang.brightvol"];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	event.handled = YES;
	brightnessMode = !brightnessMode;

	SBRotationLockHUDView *hud = [[[%c(SBRotationLockHUDView) alloc] init] autorelease];
	hud.image = [UIImage imageNamed:brightnessMode ? @"brightness.png" : @"speaker.png"];
	[[%c(SBHUDController) sharedHUDController] presentHUDView:hud autoDismissWithDelay:1];
}
@end

%hook VolumeControl
- (void)increaseVolume {
	if (brightnessMode) {
		[[%c(SBBrightnessController) sharedBrightnessController] adjustBacklightLevel:YES];

		if (timer) {
			[timer invalidate];
		}

		timer = [[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(brightVol_timerFired) userInfo:nil repeats:NO] retain];
	} else {
		%orig;
	}
}

- (void)decreaseVolume {
	if (brightnessMode) {
		[[%c(SBBrightnessController) sharedBrightnessController] adjustBacklightLevel:NO];

		if (timer) {
			[timer invalidate];
		}

		timer = [[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(brightVol_timerFired) userInfo:nil repeats:NO] retain];
	} else {
		%orig;
	}
}

/*
 activator makes pressing volume keys call _changeVolumeBy:
 on ipad. most likely a leftover 3.2 compatibility thing...
*/

- (void)_changeVolumeBy:(float)by {
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

%new - (void)brightVol_timerFired {
	brightnessMode = NO;

	[timer release];
	timer = nil;
}
%end
