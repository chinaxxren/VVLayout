//
// Created by Tank on 2019-08-22.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "UIView+Addition.h"


@implementation UIView (Addition)

- (instancetype)vv_closestCommonSuperview:(UIView *)view {
    UIView *closestCommonSuperview = nil;

    UIView *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        UIView *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end