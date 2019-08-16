//
// Created by Tank on 2019-08-16.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "UIView+VVExtend.h"

#import <objc/runtime.h>

@implementation UIView (VVExtend)

- (UIView *)vv_width {
    self.viewLayoutType = VVMakeLayoutTypeWidth;
    return self;
}

- (UIView *)vv_height {
    self.viewLayoutType = VVMakeLayoutTypeHeight;
    return self;
}

- (UIView *)vv_left {
    self.viewLayoutType = VVMakeLayoutTypeLeft;
    return self;
}

- (UIView *)vv_right {
    self.viewLayoutType = VVMakeLayoutTypeRight;
    return self;
}

- (UIView *)vv_top {
    self.viewLayoutType = VVMakeLayoutTypeTop;
    return self;
}

- (UIView *)vv_bottom {
    self.viewLayoutType = VVMakeLayoutTypeBottom;
    return self;
}

- (UIView *)vv_centerX {
    self.viewLayoutType = VVMakeLayoutTypeCenterX;
    return self;
}

- (UIView *)vv_centerY {
    self.viewLayoutType = VVMakeLayoutTypeCenterY;
    return self;
}

#pragma mark - Runtime

- (void)setViewLayoutType:(VVMakeLayoutType)viewLayoutType {
    objc_setAssociatedObject(self, @selector(viewLayoutType), @(viewLayoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VVMakeLayoutType)viewLayoutType {
    return (VVMakeLayoutType) [objc_getAssociatedObject(self, @selector(viewLayoutType)) integerValue];
}

@end