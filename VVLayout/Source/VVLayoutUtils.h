//
// Created by Tank on 2019-08-16.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE || TARGET_OS_TV

#import <UIKit/UIKit.h>

#define VV_VIEW UIView
#define EdgeInsets UIEdgeInsets

#elif TARGET_OS_MAC

#import <AppKit/AppKit.h>

#define VV_VIEW NSView
#define EdgeInsets NSEdgeInsets

#endif

#define VV_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

extern inline EdgeInsets VVEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

extern inline CGRect VVRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

extern inline CGSize VVSizeMake(CGFloat width, CGFloat height);

extern inline CGPoint VVPointMake(CGFloat x, CGFloat y);

extern inline id _VVBoxValue(const char *type, ...);

#define VVBoxValue(value) _VVBoxValue(@encode(__typeof__((value))), (value))

@interface VVLayoutUtils : NSObject

+ (UIEdgeInsets)safeAreaInsets;

+ (BOOL)isPortrait;

@end
