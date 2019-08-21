//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVLayoutUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VVMakeLayoutType) {
    VVMakeLayoutTypeLeft,
    VVMakeLayoutTypeRight,
    VVMakeLayoutTypeTop,
    VVMakeLayoutTypeBottom,
    VVMakeLayoutTypeCenterX,
    VVMakeLayoutTypeCenterY,
    VVMakeLayoutTypeCenter,
    VVMakeLayoutTypeHeight,
    VVMakeLayoutTypeWidth,
    VVMakeLayoutTypeSize,
    VVMakeLayoutTypeEdges,
};

typedef NS_ENUM(NSUInteger, VVEqualType) {
    VVEqualNone,
    VVEqualTo,
    VVGreaterThanOrEqualTo,
    VVLessThanOrEqualTo,
};

@interface VVMakeLayoutInfo : NSObject

@property(nonatomic, assign) VVMakeLayoutType makeLayoutType;
@property(nonatomic, assign) VVMakeLayoutType viewLayoutType;
@property(nonatomic, assign) VVEqualType equalType;
@property(nonatomic, assign) BOOL isNum;
@property(nonatomic, assign) CGFloat multiplied;
@property(nonatomic, assign) NSInteger priority;

@property(nonatomic, weak) UIView *relateView;
@property(nonatomic, assign) CGFloat value;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) VVEdgeInsets insets;

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType;

+ (instancetype)infoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType;

- (void)changeAttribute:(id)attribute equalType:(VVEqualType)equalType;

- (void)setAttribute:(NSValue *)value;

@end

NS_ASSUME_NONNULL_END
