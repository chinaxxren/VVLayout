//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVLayoutUtils.h"

#define vv_equalTo(...)                 equalTo(VVBoxValue((__VA_ARGS__)))
#define vv_offset(...)                  valueOffset(VVBoxValue((__VA_ARGS__)))

@class VVMakeLayout;

typedef void (^VVViewLayout)(VVMakeLayout *make);

@interface VVMakeLayout : NSObject

+ (void)configView:(UIView *)view layout:(VVViewLayout)layout;

+ (void)configView:(UIView *)view state:(NSNumber *)state layout:(VVViewLayout)layout;

- (VVMakeLayout *)and;

- (VVMakeLayout *)with;

- (VVMakeLayout *)left;

- (VVMakeLayout *)right;

- (VVMakeLayout *)top;

- (VVMakeLayout *)bottom;

- (VVMakeLayout *)safe;

- (VVMakeLayout *)centerX;

- (VVMakeLayout *)centerY;

- (VVMakeLayout *)center;

- (VVMakeLayout *)width;

- (VVMakeLayout *)height;

- (VVMakeLayout *)edges;

- (VVMakeLayout *)size;

- (VVMakeLayout *(^)(CGFloat))offset;

- (VVMakeLayout *(^)(CGPoint))centerOffset;

- (VVMakeLayout *(^)(EdgeInsets))insets;

- (VVMakeLayout *(^)(NSValue *))valueOffset;

- (VVMakeLayout *(^)(id))equalTo;

- (VVMakeLayout *(^)(CGFloat))multipliedBy;

- (VVMakeLayout *(^)(NSInteger))priority;

- (VVMakeLayout *(^)(CGSize size))lessSizeThatFits;

- (VVMakeLayout *(^)(CGSize size))greatSizeThatFits;

- (VVMakeLayout *(^)(CGFloat))lessHeightThatFits;

- (VVMakeLayout *(^)(CGFloat))greatHeightThatFits;

- (VVMakeLayout *(^)(CGFloat))lessWidthThatFits;

- (VVMakeLayout *(^)(CGFloat))greatWidthThatFits;

@end

@interface VVMakeLayout (AutoboxingSupport)

- (VVMakeLayout *(^)(id))vv_equalTo;

@end
