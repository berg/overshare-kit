//
//  OSKAppDotNetActivity.h
//  Overshare
//
//   
//  Copyright (c) 2013 Overshare Kit. All rights reserved.
//

#import "OSKActivity.h"

#import "OSKMicrobloggingActivity.h"
#import "OSKActivity_ManagedAccounts.h"
#import "OSKActivity_GenericAuthentication.h"

extern NSString *OSK_ADNAccessToken;

@interface OSKAppDotNetActivity : OSKActivity <OSKMicrobloggingActivity>

@end
