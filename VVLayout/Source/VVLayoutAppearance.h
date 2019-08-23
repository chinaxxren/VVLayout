//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVLayoutAppearance : NSObject

+ (BOOL)openScaleFont;

+ (void)setScaleFont:(BOOL)scaleFont;

+ (void)setOpenScale:(BOOL)open;

+ (BOOL)openGlobalScale;

+ (void)setGlobalScale:(CGFloat)value;

+ (CGFloat)globalScale;

@end