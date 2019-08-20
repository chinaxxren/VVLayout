//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayoutInfo.h"
#import "UIView+VVExtend.h"

@interface VVMakeLayoutInfo ()

@end

@implementation VVMakeLayoutInfo

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    self = [super init];
    if (self) {
        self.makeLayoutType = makeLayoutType;
        self.multiplied = 1.0f;
        self.viewLayoutType = VVMakeLayoutTypeNone;
        self.equalType = VVEqualNone;
        self.isNum = NO;
    }

    return self;
}

+ (instancetype)infoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    return [[self alloc] initWithMakeLayoutType:makeLayoutType];
}

- (void)changeAttribute:(id)attribute equalType:(VVEqualType)equalType {
    self.equalType = equalType;

    if ([attribute isKindOfClass:UIView.class]) {
        self.relateView = (UIView *) attribute;
        self.isNum = NO;
        self.viewLayoutType = self.relateView.viewLayoutType;
    } else {
        [self setAttribute:attribute];
        self.isNum = YES;
    }
}

- (void)setAttribute:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.value = [(NSNumber *) value floatValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.point = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.size = size;
    } else if (strcmp(value.objCType, @encode(VVEdgeInsets)) == 0) {
        VVEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

- (VVMakeLayoutType)viewLayoutType {
    if (_viewLayoutType == VVMakeLayoutTypeNone) {
        return _makeLayoutType;
    }

    return _viewLayoutType;
}

@end
