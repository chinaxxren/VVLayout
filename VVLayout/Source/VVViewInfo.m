//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVViewInfo.h"

#import "UIView+VVExtend.h"
#import "VVDevice.h"

@interface VVViewInfo ()

@end

@implementation VVViewInfo

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    self = [super init];
    if (self) {
        self.makeLayoutType = makeLayoutType;
        self.viewLayoutType = makeLayoutType;
        self.equalType = VVEqualTo;
        self.multiplied = 1.0f;
        self.safe = NO;
        self.isNum = NO;
    }

    return self;
}

+ (instancetype)viewInfoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    return [[self alloc] initWithMakeLayoutType:makeLayoutType];
}

- (void)changeAttribute:(id)attribute equalType:(VVEqualType)equalType {
    self.equalType = equalType;

    if ([attribute isKindOfClass:UIView.class]) {
        self.relateView = (UIView *) attribute;
        self.isNum = NO;

        if (self.relateView.viewLayoutType != VVMakeLayoutTypeNone) {
            self.viewLayoutType = self.relateView.viewLayoutType;
            self.relateView.viewLayoutType = VVMakeLayoutTypeNone;
        }
    } else {
        [self setAttribute:attribute];
        self.isNum = YES;
    }
}

- (void)setAttribute:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.value = [(NSNumber *) value floatValue] *  [VVDevice globalScale];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.point = VVPointMake(point.x, point.y);
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.size = VVSizeMake(size.width, size.height);
    } else if (strcmp(value.objCType, @encode(EdgeInsets)) == 0) {
        EdgeInsets insets;
        [value getValue:&insets];
        self.insets = VVEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right);
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

- (CGFloat)value {
    if (self.safe && self.makeLayoutType == self.viewLayoutType) {
        UIEdgeInsets safeAreaInsets = [VVLayoutUtils safeAreaInsets];
        if (self.makeLayoutType == VVMakeLayoutTypeLeft) {
            return _value + safeAreaInsets.left;
        } else if (self.makeLayoutType == VVMakeLayoutTypeRight) {
            return _value - safeAreaInsets.right;
        } else if (self.makeLayoutType == VVMakeLayoutTypeTop) {
            return _value + safeAreaInsets.top;
        } else if (self.makeLayoutType == VVMakeLayoutTypeBottom) {
            return _value - safeAreaInsets.bottom;
        }
    }

    return _value;
}

- (EdgeInsets)insets {
    if (self.safe && self.makeLayoutType == self.viewLayoutType && self.makeLayoutType == VVMakeLayoutTypeEdges) {
        UIEdgeInsets safeAreaInsets = [VVLayoutUtils safeAreaInsets];
        return UIEdgeInsetsMake(_insets.top + safeAreaInsets.top, _insets.left + safeAreaInsets.left, _insets.bottom - safeAreaInsets.bottom, _insets.right - safeAreaInsets.right);
    }

    return _insets;
}

- (void)setFitValue:(CGFloat)fitValue {
    _fitValue = fitValue * [VVDevice globalScale];
}

- (void)setFitSize:(CGSize)fitSize {
    CGFloat scale = [VVDevice globalScale];
    _fitSize = CGSizeMake(fitSize.width * scale, fitSize.height * scale);
}

@end
