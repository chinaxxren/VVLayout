//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVViewLayoutInfo.h"

#import "UIView+VVExtend.h"
#import "VVLayoutAppearance.h"

@interface VVViewLayoutInfo ()

@end

@implementation VVViewLayoutInfo

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    self = [super init];
    if (self) {
        self.makeLayoutType = makeLayoutType;
        self.viewLayoutType = makeLayoutType;
        self.multiplied = 1.0f;
        self.equalType = VVEqualNone;
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
    CGFloat scale = [VVLayoutAppearance globalScale];
    if ([value isKindOfClass:NSNumber.class]) {
        self.value = [(NSNumber *) value floatValue] * scale;
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.point = CGPointMake(point.x * scale, point.y * scale);
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.size = CGSizeMake(size.width * scale, size.height * scale);
    } else if (strcmp(value.objCType, @encode(VVEdgeInsets)) == 0) {
        VVEdgeInsets insets;
        [value getValue:&insets];
        self.insets = UIEdgeInsetsMake(insets.top * scale, insets.left * scale, insets.bottom * scale, insets.right * scale);
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

@end
