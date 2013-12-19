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

static NSInteger OSKFacebookActivity_MaxCharacterCount = 6000;
static NSInteger OSKFacebookActivity_MaxUsernameLength = 20;
static NSInteger OSKFacebookActivity_MaxImageCount = 3;

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
    return OSKShareableContentItemType_MicroblogPost;
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

+ (OSKPublishingViewControllerType)publishingViewControllerType {
    return OSKPublishingViewControllerType_None;
}

- (FBShareDialogParams *)paramsForContentItem {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = ((OSKMicroblogPostContentItem *)self.contentItem).url;

    return params;
}

- (BOOL)isReadyToPerform {
    return [FBDialogs canPresentShareDialogWithParams:self.dialogParams];
}

- (void)performActivity:(OSKActivityCompletionHandler)completion {
    __weak OSKFacebookActivity *weakSelf = self;
	[FBDialogs presentShareDialogWithParams:self.dialogParams clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
		BOOL successful = NO;
		if ([results[@"didComplete"] boolValue] && [results[@"completionGesture"] isEqualToString:@"post"]) {
			successful = YES;
		}

		if (completion) {
			completion(weakSelf, successful, error);
		}
	}];
}

+ (BOOL)canPerformViaOperation {
    return NO;
}

- (OSKActivityOperation *)operationForActivityWithCompletion:(OSKActivityCompletionHandler)completion {
    return nil;
}

#pragma mark - Microblogging Activity Protocol

- (NSInteger)maximumCharacterCount {
    return OSKFacebookActivity_MaxCharacterCount;
}

- (NSInteger)maximumImageCount {
    return OSKFacebookActivity_MaxImageCount;
}

- (OSKMicroblogSyntaxHighlightingStyle)syntaxHighlightingStyle {
    return OSKMicroblogSyntaxHighlightingStyle_LinksOnly;
}

- (NSInteger)maximumUsernameLength {
    return OSKFacebookActivity_MaxUsernameLength;
}

@end
