//
// Created by Tank on 2019-08-22.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ArrayDemo : UIView

// 水平方向排列、固定控件间隔、控件长度不定
- (void)horizontalFixSpace;

// 垂直方向排列、固定控件间隔、控件高度不定
- (void)verticalFixSpace;

// 水平方向排列、固定控件长度、控件间隔不定
- (void)horizontalFixItemWidth;

- (void)verticalFixItemWidth;

@end