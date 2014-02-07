#import "HBBVListener.h"
#import <SpringBoard/SBHUDController.h>
#import <SpringBoard/SBHUDView.h>

BOOL HBBVToggleMode();

@implementation HBBVListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	event.handled = YES;

	SBHUDView *hud = [[[%c(SBHUDView) alloc] initWithHUDViewLevel:0] autorelease];
	hud.image = [UIImage imageNamed:HBBVToggleMode() ? @"brightness" : @"speaker"];
	[[%c(SBHUDController) sharedHUDController] presentHUDView:hud autoDismissWithDelay:1];
}

@end
