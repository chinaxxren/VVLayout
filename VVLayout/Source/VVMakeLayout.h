//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVLayoutUtils.h"

#define vv_equalTo(...)                 equalTo(VVBoxValue((__VA_ARGS__)))
// #define vv_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(VVBoxValue((__VA_ARGS__)))
// #define vv_lessThanOrEqualTo(...)       lessThanOrEqualTo(VVBoxValue((__VA_ARGS__)))

#define vv_offset(...)                  valueOffset(VVBoxValue((__VA_ARGS__)))

#ifdef VV_SHORTHAND_GLOBALS

#define equalTo(...)                     vv_equalTo(__VA_ARGS__)
// #define greaterThanOrEqualTo(...)        vv_greaterThanOrEqualTo(__VA_ARGS__)
// #define lessThanOrEqualTo(...)           vv_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      vv_offset(__VA_ARGS__)

#endif

@class VVMakeLayout;

typedef void (^MakeLayout)(VVMakeLayout *make);

@interface VVMakeLayout : NSObject

+ (void)configView:(UIView *)view makeLayout:(MakeLayout)make;

+ (void)configView:(UIView *)view forState:(NSNumber *)state makeLayout:(MakeLayout)makeLayout;

- (VVMakeLayout *)left;

- (VVMakeLayout *)right;

- (VVMakeLayout *)top;

- (VVMakeLayout *)bottom;

- (VVMakeLayout *)centerX;

- (VVMakeLayout *)centerY;

- (VVMakeLayout *)center;

- (VVMakeLayout *)width;

- (VVMakeLayout *)height;

- (VVMakeLayout *)edges;

- (VVMakeLayout *)size;

- (VVMakeLayout *(^)(CGFloat))offset;

- (VVMakeLayout *(^)(CGSize))sizeOffset;

- (VVMakeLayout *(^)(CGPoint))centerOffset;

- (VVMakeLayout *(^)(VVEdgeInsets))insets;

- (VVMakeLayout *(^)(NSValue *))valueOffset;

- (VVMakeLayout *(^)(id))equalTo;

//- (VVMakeLayout *(^)(id))greaterThanOrEqualTo;
//
//- (VVMakeLayout *(^)(id))lessThanOrEqualTo;

- (VVMakeLayout *(^)(CGFloat))multipliedBy;

- (VVMakeLayout *(^)(NSInteger))priority;

- (VVMakeLayout *)container;

- (VVMakeLayout *)sizeToFit;

- (VVMakeLayout *)widthToFit;

- (VVMakeLayout *)heightToFit;

- (VVMakeLayout *(^)(CGSize size))sizeThatFits;

@end
