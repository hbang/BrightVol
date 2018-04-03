#import "HBBVListener.h"
#import <SpringBoard/VolumeControl.h>

static HBBVListener *listener;

%hook VolumeControl

- (void)increaseVolume {
	// if we’re in brightness mode, call our brightness changer method. otherwise call the original
	// implementation (change volume)
	if (listener.brightnessMode) {
		[listener setBrightness:YES volumeControl:self];
	} else {
		%orig;
	}
}

- (void)decreaseVolume {
	if (listener.brightnessMode) {
		[listener setBrightness:NO volumeControl:self];
	} else {
		%orig;
	}
}

- (void)_changeVolumeBy:(CGFloat)by {
	// activator makes pressing volume keys call _changeVolumeBy: on ipad rather than the above
	// methods. seems most likely a leftover 3.2 compatibility thing (ew).
	if (listener.brightnessMode) {
		if (by > 0) {
			[self increaseVolume];
		} else {
			[self decreaseVolume];
		}
	} else {
		%orig;
	}
}

%end

%ctor {
	LAActivator *activator = [LAActivator sharedInstance];

	// if activator has never seen us before, assign ourself with the default event
	if (![activator hasSeenListenerWithName:@"ws.hbang.brightvol"]) {
		[activator assignEvent:[LAEvent eventWithName:@"libactivator.volume.both.press"] toListenerWithName:@"ws.hbang.brightvol"];
	}

	// register the listener with activator
	listener = [[HBBVListener alloc] init];
	[activator registerListener:listener forName:@"ws.hbang.brightvol"];
}
