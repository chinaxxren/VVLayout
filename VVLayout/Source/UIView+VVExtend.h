//
// Created by Tank on 2019-08-16.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VVViewInfo.h"

@interface UIView (VVExtend)

@property(nonatomic, assign) VVMakeLayoutType viewLayoutType;

@property(nonatomic, readonly) UIView *vv_width;
@property(nonatomic, readonly) UIView *vv_height;
@property(nonatomic, readonly) UIView *vv_left;
@property(nonatomic, readonly) UIView *vv_right;
@property(nonatomic, readonly) UIView *vv_top;
@property(nonatomic, readonly) UIView *vv_bottom;
@property(nonatomic, readonly) UIView *vv_centerX;
@property(nonatomic, readonly) UIView *vv_centerY;
@property(nonatomic, readonly) UIView *vv_center;

@end