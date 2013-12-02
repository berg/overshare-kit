//
//  OSKPresentationStyle.h
//  Overshare
//
//  Created by Jared on 10/31/13.
//  Copyright (c) 2013 Overshare Kit. All rights reserved.
//

@import Foundation;

@class OSKActivity;

typedef NS_ENUM(NSInteger, OSKActivitySheetViewControllerStyle) {
    OSKActivitySheetViewControllerStyle_Light,
    OSKActivitySheetViewControllerStyle_Dark,
};

///-----------------------------------------------
/// @name Presentation Style
///-----------------------------------------------

/**
 A protocol for overriding the default visual style of Overshare's views.
 */
@protocol OSKPresentationStyle <NSObject>
@optional

/**
 @return Returns the style to be used for the Overshare built-in view controllers (dark mode FTW.)
 */
- (OSKActivitySheetViewControllerStyle)osk_activitySheetStyle;

/**
 Buttons need borders in order to look tappable.
 
 @return Return `YES` to use the unjustifiably borderless look of iOS 7 buttons.
 */
- (BOOL)osk_toolbarsUseUnjustifiablyBorderlessButtons;

/**
 Returns an alternate icon for a given activity type. Useful if you want to customize built in activity icons.
 
 @param type An `OSKActivity` type.
 
 @param idiom The current user interface idiom.
 
 @return A square, opaque image of size 60x60 points (for iPhone) or 76x76 points (for iPad).
 */
- (UIImage *)osk_alternateIconForActivityType:(NSString *)type idiom:(UIUserInterfaceIdiom)idiom;

/**
 Returning YES (the default OSK setting) will automatically shorten links when recommended, i.e., when
 the user is editing a microblog post (Twitter, App.net, etc.) and a given URL is longer than a certain
 threshold (around 30 characters or more). Links are shortened via Bit.ly
 */
- (BOOL)osk_automaticallyShortenURLsWhenRecommended;

@end




