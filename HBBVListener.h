#import <libactivator/libactivator.h>

@class VolumeControl;

@interface HBBVListener : NSObject <LAListener>

@property (nonatomic) BOOL brightnessMode;

- (void)setBrightness:(BOOL)direction volumeControl:(VolumeControl *)volumeControl;

@end
