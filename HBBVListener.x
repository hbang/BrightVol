#import "HBBVListener.h"
#import <SpringBoard/SBHUDController.h>
#import <SpringBoard/SBRotationLockHUDView.h>

BOOL HBBVToggleMode();

@implementation HBBVListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	event.handled = YES;

	SBRotationLockHUDView *hud = [[[%c(SBRotationLockHUDView) alloc] init] autorelease];
	hud.image = [UIImage imageNamed:HBBVToggleMode() ? @"brightness" : @"speaker"];
	[[%c(SBHUDController) sharedHUDController] presentHUDView:hud autoDismissWithDelay:1];
}

@end
