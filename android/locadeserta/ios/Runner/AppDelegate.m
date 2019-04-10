#include "AppDelegate.h"
#include <Flutter/Flutter.h>
#include "GeneratedPluginRegistrant.h"
#include "InkStory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FlutterViewController* controller = (FlutterViewController *) self.window.rootViewController;
    
    FlutterMethodChannel *inkChannel = [FlutterMethodChannel methodChannelWithName:@"gladimdim.locadeserta/Ink" binaryMessenger:controller];
    
    [inkChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult result) {
        if ([@"Init" isEqualToString:call.method]) {
            self.inkStory = [[[InkStory alloc] init] initWithJsonString:call.arguments];
            result(@"success");
        } else if ([@"canContinue" isEqualToString:call.method]) {
            bool canContinue = [self.inkStory canContinue];
            result([NSNumber numberWithBool:canContinue]);
        } else if ([@"Continue" isEqualToString:call.method]) {
            NSString* continueString = [self.inkStory continueStory];
            result(continueString);
        } else if ([@"getCurrentText" isEqualToString:call.method]) {
            NSString* currentText = [self.inkStory currentText];
            result(currentText);
        } else if ([@"getCurrentChoices" isEqualToString:call.method]) {
            NSArray* currentChoices = [self.inkStory currentChoices];
            result(currentChoices);
        } else if ([@"getCurrentTags" isEqualToString:call.method]) {
            NSArray* currentTags = [self.inkStory currentTags];
            result(currentTags);
        } else {
            result(FlutterMethodNotImplemented);
        }
        
    }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
