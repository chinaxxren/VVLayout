//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (VVMakeLayout *)width;

- (VVMakeLayout *)height;

- (VVMakeLayout *)edges;

- (VVMakeLayout *(^)(CGFloat))offset;

- (VVMakeLayout *(^)(CGFloat))vv_equalTo;

- (VVMakeLayout *(^)(UIView *))equalTo;

- (VVMakeLayout *(^)(CGFloat))multipliedBy;

- (VVMakeLayout *(^)(NSInteger))priority;

- (VVMakeLayout *)container;

- (VVMakeLayout *)sizeToFit;

- (VVMakeLayout *)widthToFit;

- (VVMakeLayout *)heightToFit;

- (VVMakeLayout *(^)(CGSize size))sizeThatFits;

@end