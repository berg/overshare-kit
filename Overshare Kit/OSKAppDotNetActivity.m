//
//  OSKAppDotNetActivity.m
//  Overshare
//
//   
//  Copyright (c) 2013 Overshare Kit. All rights reserved.
//

#import "OSKAppDotNetActivity.h"
#import "OSKMicrobloggingActivity.h"

#import "OSKActivitiesManager.h"
#import "OSKActivity_ManagedAccounts.h"
#import "OSKADNLoginManager.h"
#import "OSKAppDotNetUtility.h"
#import "OSKLogger.h"
#import "OSKManagedAccount.h"
#import "OSKShareableContentItem.h"
#import "OSKApplicationCredential.h"
#import "OSKManagedAccountCredential.h"
#import "NSString+OSKEmoji.h"

static NSInteger OSKAppDotNetActivity_MaxCharacterCount = 256;
static NSInteger OSKAppDotNetActivity_MaxUsernameLength = 20;
static NSInteger OSKAppDotNetActivity_MaxImageCount = 4;

// I am going to hell for this.
NSString *OSK_ADNAccessToken = nil;

@interface OSKAppDotNetActivity ()

@end

@implementation OSKAppDotNetActivity

@synthesize remainingCharacterCount = _remainingCharacterCount;

- (instancetype)initWithContentItem:(OSKShareableContentItem *)item {
    self = [super initWithContentItem:item];
    if (self) {
    }
    return self;
}

#pragma mark - Methods for OSKActivity Subclasses

+ (NSString *)supportedContentItemType {
    return OSKShareableContentItemType_MicroblogPost;
}

+ (BOOL)isAvailable {
    return YES;
}

+ (NSString *)activityType {
    return OSKActivityType_API_AppDotNet;
}

+ (NSString *)activityName {
    return @"App.net";
}

+ (UIImage *)iconForIdiom:(UIUserInterfaceIdiom)idiom {
    UIImage *image = nil;
    if (idiom == UIUserInterfaceIdiomPhone) {
        image = [UIImage imageNamed:@"osk-appDotNetIcon-60.png"];
    } else {
        image = [UIImage imageNamed:@"osk-appDotNetIcon-76.png"];
    }
    return image;
}

+ (UIImage *)settingsIcon {
    return [UIImage imageNamed:@"osk-appDotNetIcon-29.png"];
}

+ (OSKAuthenticationMethod)authenticationMethod {
    return OSKAuthenticationMethod_None;
}

+ (BOOL)requiresApplicationCredential {
    return YES;
}

- (OSKManagedAccount *)activeManagedAccount {
    return [OSKManagedAccount new];
}

- (OSKManagedAccountCredential *)credential {
	return [[OSKManagedAccountCredential alloc] initWithOvershareAccountIdentifier:@"ADN" accessToken:OSK_ADNAccessToken];
}

+ (OSKPublishingMethod)publishingMethod {
    return OSKPublishingMethod_ViewController_Microblogging;
}

+ (OSKApplicationCredential *)applicationCredential {
	return [[OSKApplicationCredential alloc] initWithOvershareApplicationKey:@"ADNlol" applicationSecret:@"lol" appName:@"App.net for iPhone"];
}

- (BOOL)isReadyToPerform {
    NSInteger maxCharacterCount = [self maximumCharacterCount];
    return (0 <= self.remainingCharacterCount && self.remainingCharacterCount < maxCharacterCount);
}

- (void)performActivity:(OSKActivityCompletionHandler)completion {
    __weak OSKAppDotNetActivity *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OSKAppDotNetUtility
         postContentItem:(OSKMicroblogPostContentItem *)weakSelf.contentItem
         withCredential:weakSelf.credential
         appCredential:[weakSelf.class applicationCredential]
         completion:^(BOOL success, NSError *error) {
             OSKLog(@"Success! Sent new post to App.net.");
             if (completion) {
                 completion(weakSelf, success, error);
             }
         }];
    });
}

+ (BOOL)canPerformViaOperation {
    return NO;
}

- (OSKActivityOperation *)operationForActivityWithCompletion:(OSKActivityCompletionHandler)completion {
    return nil;
}

#pragma mark - Microblogging Activity Protocol

- (NSInteger)maximumCharacterCount {
    return OSKAppDotNetActivity_MaxCharacterCount;
}

- (NSInteger)maximumImageCount {
    return OSKAppDotNetActivity_MaxImageCount;
}

- (OSKSyntaxHighlighting)syntaxHighlighting {
    return OSKSyntaxHighlighting_Hashtags | OSKSyntaxHighlighting_Links | OSKSyntaxHighlighting_Usernames;
}

- (NSInteger)maximumUsernameLength {
    return OSKAppDotNetActivity_MaxUsernameLength;
}

- (NSInteger)updateRemainingCharacterCount:(OSKMicroblogPostContentItem *)contentItem urlEntities:(NSArray *)urlEntities {
    
    NSString *text = contentItem.text;
    NSInteger composedLength = [text osk_lengthAdjustingForComposedCharacters];
    NSInteger remainingCharacterCount = [self maximumCharacterCount] - composedLength;
    
    [self setRemainingCharacterCount:remainingCharacterCount];
    
    return remainingCharacterCount;
}

@end
