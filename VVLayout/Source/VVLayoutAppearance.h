//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVLayoutAppearance : NSObject

+ (void)setOpenScale:(BOOL)open;

+ (BOOL)openScale;

+ (void)setScale:(CGFloat)value;

+ (CGFloat)scale;

@end