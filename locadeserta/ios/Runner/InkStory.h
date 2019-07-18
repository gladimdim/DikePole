//
//  InkStory.h
//  Created by Russell Quinn
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface InkStory : NSObject

@property (strong, nonatomic) JSContext *jsContext;

- (instancetype)initWithStoryJsonFile:(NSString *)filePath;
- (instancetype) initWithJsonString:(NSString *) jsonString;

- (NSString *)toJson;
- (void)loadJson:(NSString *)json;
- (BOOL)canContinue;
- (NSString *)continueStory;
- (NSString *)currentText;
- (NSArray *)currentErrors;
- (NSArray *)currentChoices;
- (void)chooseChoiceIndex:(NSInteger)index;
- (NSArray *)currentTags;
- (NSArray *)globalTags;
- (NSArray *)tagsForContentAtPath:(NSString *)path;
- (void)choosePathString:(NSString *)path;
- (void) resetState;

- (JSValue *)evaluateScriptInContext:(NSString *)jsToRun;

@end
