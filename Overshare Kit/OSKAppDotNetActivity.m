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

static NSInteger OSKAppDotNetActivity_MaxCharacterCount = 256;
static NSInteger OSKAppDotNetActivity_MaxUsernameLength = 20;
static NSInteger OSKAppDotNetActivity_MaxImageCount = 4;

// I am going to hell for this.
NSString *OSK_ADNAccessToken = nil;

@interface OSKAppDotNetActivity ()

@end

@implementation OSKAppDotNetActivity

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

+ (OSKPublishingViewControllerType)publishingViewControllerType {
    return OSKPublishingViewControllerType_Microblogging;
}

+ (OSKApplicationCredential *)applicationCredential {
	return [[OSKApplicationCredential alloc] initWithOvershareApplicationKey:@"ADNlol" applicationSecret:@"lol" appName:@"App.net for iPhone"];
}

- (BOOL)isReadyToPerform {
    OSKMicroblogPostContentItem *contentItem = (OSKMicroblogPostContentItem *)self.contentItem;
    NSInteger maxCharacterCount = [self maximumCharacterCount];
    return (contentItem.text.length > 0 && contentItem.text.length <= maxCharacterCount);
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
    OSKActivityOperation *op = nil;
    return op;
}

#pragma mark - Microblogging Activity Protocol

- (NSInteger)maximumCharacterCount {
    return OSKAppDotNetActivity_MaxCharacterCount;
}

- (NSInteger)maximumImageCount {
    return OSKAppDotNetActivity_MaxImageCount;
}

- (OSKMicroblogSyntaxHighlightingStyle)syntaxHighlightingStyle {
    return OSKMicroblogSyntaxHighlightingStyle_Twitter;
}

- (NSInteger)maximumUsernameLength {
    return OSKAppDotNetActivity_MaxUsernameLength;
}

@end
