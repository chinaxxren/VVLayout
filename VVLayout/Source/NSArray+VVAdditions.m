//
// Created by Tank on 2019-08-22.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "NSArray+VVAdditions.h"

#import "UIView+VVLayout.h"
#import "UIView+Addition.h"

@implementation NSArray (VVAdditions)

- (NSArray *)makeLayouts:(MakeHandler)makeHandler {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        [view makeLayout:makeHandler];
        [constraints addObject:view];
    }
    return constraints;
}

- (NSArray *)remakeLayouts:(MakeHandler)makeHandler {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        [view remakeLayout:makeHandler];
        [constraints addObject:view];
    }
    return constraints;
}

- (NSArray *)updateLayouts:(MakeHandler)makeHandler {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        [view updateLayout:makeHandler];
        [constraints addObject:view];
    }
    return constraints;
}

- (NSArray *)layouts:(MakeHandler)makeHandler state:(NSNumber *)state {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        [view layout:makeHandler state:state];
        [constraints addObject:view];
    }
    return constraints;
}

- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count > 1, @"views to distribute need to bigger than one");
        return;
    }

    UIView *tempSuperView = [self commonSuperviewOfViews];

    if (axisType == VVAxisTypeHorizontal) {
        CGFloat width = CGRectGetWidth(tempSuperView.frame);
        width = (width - leadSpacing + tailSpacing - (self.count - 1) * fixedSpacing) / self.count;

        UIView *prev;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v makeLayout:^(VVMakeLayout *make) {
                make.width.vv_equalTo(width);
                if (prev) {
                    make.left.equalTo(prev.vv_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(tailSpacing);
                    }
                } else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    } else {
        CGFloat height = CGRectGetHeight(tempSuperView.frame);
        height = (height - leadSpacing + tailSpacing - (self.count - 1) * fixedSpacing) / self.count;

        UIView *prev;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v makeLayout:^(VVMakeLayout *make) {
                make.height.vv_equalTo(height);
                if (prev) {
                    make.top.equalTo(prev.vv_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(tailSpacing);
                    }
                } else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count > 1, @"views to distribute need to bigger than one");
        return;
    }

    UIView *tempSuperView = [self commonSuperviewOfViews];

    if (axisType == VVAxisTypeHorizontal) {
        CGFloat fixedSpacing = CGRectGetWidth(tempSuperView.frame);
        fixedSpacing = (fixedSpacing - fixedItemLength * self.count - leadSpacing + tailSpacing) / (self.count - 1);
        UIView *prev;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v makeLayout:^(VVMakeLayout *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(tailSpacing);
                    } else {
                        make.left.equalTo(prev.vv_right).offset(fixedSpacing);
                    }
                } else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    } else {
        CGFloat fixedSpacing = CGRectGetHeight(tempSuperView.frame);
        fixedSpacing = (fixedSpacing - fixedItemLength * self.count - leadSpacing + tailSpacing) / (self.count - 1);

        UIView *prev;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v makeLayout:^(VVMakeLayout *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(tailSpacing);
                    } else {
                        make.top.equalTo(prev.vv_bottom).offset(fixedSpacing);
                    }
                } else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (UIView *)commonSuperviewOfViews {
    UIView *commonSuperview = nil;
    UIView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *) object;
            if (previousView) {
                commonSuperview = [view vv_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
