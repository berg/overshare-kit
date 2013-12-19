//
//  OSKFacebookActivity.h
//  Overshare
//
//  Created by Jared Sinclair on 10/15/13.
//  Copyright (c) 2013 Overshare Kit. All rights reserved.
//

#import "OSKActivity.h"

#import "OSKMicrobloggingActivity.h"

@class FBShareDialogParams;

@interface OSKFacebookActivity : OSKActivity <OSKMicrobloggingActivity>

@property (strong, nonatomic) FBShareDialogParams *dialogParams;

@end
