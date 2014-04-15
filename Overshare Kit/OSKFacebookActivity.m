//
//  OSKFacebookActivity.m
//  Overshare
//
//  Created by Jared Sinclair on 10/15/13.
//  Copyright (c) 2013 Overshare Kit. All rights reserved.
//

#import "OSKFacebookActivity.h"
#import "OSKShareableContentItem.h"
#import "OSKApplicationCredential.h"
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>
#import "NSString+OSKEmoji.h"

@implementation OSKFacebookActivity

- (instancetype)initWithContentItem:(OSKShareableContentItem *)item {
    self = [super initWithContentItem:item];
    if (self) {
        self.dialogParams = [self paramsForContentItem];
    }
    return self;
}

#pragma mark - Methods for OSKActivity Subclasses

+ (NSString *)supportedContentItemType {
    return OSKShareableContentItemType_Facebook;
}

+ (BOOL)isAvailable {
    return YES; // This is *in general*, not whether account access has been granted.
}

+ (NSString *)activityType {
    return @"OSKActivityType_iOS_Facebook_Bespoke";
}

+ (NSString *)activityName {
    return @"Facebook";
}

+ (UIImage *)iconForIdiom:(UIUserInterfaceIdiom)idiom {
    UIImage *image = nil;
    if (idiom == UIUserInterfaceIdiomPhone) {
        image = [UIImage imageNamed:@"osk-facebookIcon-60.png"];
    } else {
        image = [UIImage imageNamed:@"osk-facebookIcon-76.png"];
    }
    return image;
}

+ (UIImage *)settingsIcon {
    return [self iconForIdiom:UIUserInterfaceIdiomPhone];
}

+ (OSKAuthenticationMethod)authenticationMethod {
    return OSKAuthenticationMethod_None;
}

+ (BOOL)requiresApplicationCredential {
    return NO;
}

- (FBShareDialogParams *)paramsForContentItem {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = ((OSKFacebookContentItem *)self.contentItem).link;

    return params;
}

+ (OSKPublishingMethod)publishingMethod {
    return OSKPublishingMethod_None;
}

- (BOOL)isReadyToPerform {
    return [FBDialogs canPresentShareDialogWithParams:self.dialogParams];
}

- (void)performActivity:(OSKActivityCompletionHandler)completion {
    __weak OSKFacebookActivity *weakSelf = self;

    UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (completion) {
            completion(weakSelf, NO, nil);
        }
    }];

    [FBDialogs presentShareDialogWithParams:self.dialogParams clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        BOOL successful = NO;
        if ([results[@"didComplete"] boolValue] && [results[@"completionGesture"] isEqualToString:@"post"]) {
            successful = YES;
        }

        if (completion) {
            completion(weakSelf, successful, error);
        }

        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
    }];
}

+ (BOOL)canPerformViaOperation {
    return NO;
}

- (OSKActivityOperation *)operationForActivityWithCompletion:(OSKActivityCompletionHandler)completion {
    return nil;
}

- (BOOL)allowLinkShortening {
    return YES;
}

@end
