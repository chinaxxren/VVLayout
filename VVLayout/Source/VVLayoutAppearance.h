//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVLayoutAppearance : NSObject

+ (CGFloat)width;

+ (CGFloat)height;

+ (CGFloat)xMinWidth;

+ (CGFloat)xMaxHeight;

// 是否全局的字体屏幕适配
+ (BOOL)hasGlobalFontScale;

// 设置全局的字体屏幕适配是否开启
+ (void)setGlobalScaleFont:(BOOL)scaleFont;

// 是否全局的View屏幕适配
+ (BOOL)hasGlobalViewScale;

// 设置全局的View屏幕适配是否开启
+ (void)setGlobalViewScale:(BOOL)open;

// 设置全局的屏幕适配的比例
+ (void)setGlobalScale:(CGFloat)value;

// 返回屏幕适配的比例
+ (CGFloat)globalScale;

@end
