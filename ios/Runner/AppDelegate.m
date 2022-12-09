#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <FirebaseCore/FirebaseCore.h>

#import "GoogleMaps/GoogleMaps.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [GMSServices provideAPIKey:@"AIzaSyCWsGrUuzgLzaLQVsS5g6Q-lfOhiz96NcY"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
