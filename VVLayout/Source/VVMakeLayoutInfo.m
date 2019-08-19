//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayoutInfo.h"
#import "UIView+VVExtend.h"

@interface VVMakeLayoutInfo ()

@property(nonatomic, assign) CGFloat value;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) VVEdgeInsets insets;

@end

@implementation VVMakeLayoutInfo

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    self = [super init];
    if (self) {
        self.makeLayoutType = makeLayoutType;
        self.multiplied = 1.0f;
        self.viewLayoutType = VVMakeLayoutTypeNone;
    }

    return self;
}

+ (instancetype)infoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    return [[self alloc] initWithMakeLayoutType:makeLayoutType];
}

- (void)setAttribute:(id)attribute {
    if ([attribute isKindOfClass:UIView.class]) {
        self.view = (UIView *) attribute;
        self.isNum = NO;

        if (self.view.viewLayoutType == VVMakeLayoutTypeNone) {
            self.viewLayoutType = self.makeLayoutType;
        } else {
            self.viewLayoutType = self.view.viewLayoutType;
        }
    } else {
        _attribute = attribute;
        [self setAttributeValue:_attribute];
        self.isNum = YES;

        self.viewLayoutType = self.makeLayoutType;
    }
}

- (void)setAttributeValue:(NSValue *)value {
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

@end
