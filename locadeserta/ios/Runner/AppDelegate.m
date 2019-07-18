#include "AppDelegate.h"
#include <Flutter/Flutter.h>
#include "GeneratedPluginRegistrant.h"
#include "InkStory.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    FlutterViewController* controller = (FlutterViewController *) self.window.rootViewController;
    
    FlutterMethodChannel *inkChannel = [FlutterMethodChannel methodChannelWithName:@"gladimdim.locadeserta/Ink" binaryMessenger:controller];
    NSString *storyString;
    [inkChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult result) {
        if ([@"Init" isEqualToString:call.method]) {
            self.storyString = call.arguments;
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
            NSMutableArray* choices = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in currentChoices) {
                NSString* text = dict[@"text"];
                [choices addObject:text];
            }
            result(choices);
        } else if ([@"getCurrentTags" isEqualToString:call.method]) {
            NSArray* currentTags = [self.inkStory currentTags];
            result(currentTags);
        } else if ([@"chooseChoiceIndex" isEqualToString:call.method]) {
            [self.inkStory chooseChoiceIndex:[call.arguments integerValue]];
            result([self.inkStory currentText]);
        } else if ([@"restoreState" isEqualToString:call.method]) {
            NSDictionary *dict = call.arguments;
            NSString *str = [NSString stringWithFormat:@"%@", [dict valueForKey:@"text"]];
            [self.inkStory loadJson:str];
            result(@"success");
        } else if ([@"saveState" isEqualToString:call.method]) {
            NSString *state =  [self.inkStory toJson];
            return result(state);
        } else if ([@"resetState" isEqualToString:call.method]) {
            self.inkStory = [[[InkStory alloc] init] initWithJsonString:self.storyString];
            result(@"success");
        } else {
            result(FlutterMethodNotImplemented);
        }
        
    }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
