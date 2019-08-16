//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVLayoutUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VVMakeLayoutType) {
    VVMakeLayoutTypeNone = 0,
    VVMakeLayoutTypeLeft,
    VVMakeLayoutTypeRight,
    VVMakeLayoutTypeTop,
    VVMakeLayoutTypeBottom,
    VVMakeLayoutTypeCenterX,
    VVMakeLayoutTypeCenterY,
    VVMakeLayoutTypeHeight,
    VVMakeLayoutTypeWidth,
    VVMakeLayoutTypeSize,
    VVMakeLayoutTypeEdges,
};

@interface VVMakeLayoutInfo : NSObject

@property(nonatomic, assign) VVMakeLayoutType makeLayoutType;
@property(nonatomic, assign) VVMakeLayoutType viewLayoutType;
@property(nonatomic, strong) id attribute;
@property(nonatomic, assign) BOOL isNum;
@property(nonatomic, assign) CGFloat multiplied;
@property(nonatomic, assign) NSInteger priority;
@property(nonatomic, weak) UIView *view;

@property(nonatomic, assign, readonly) CGFloat value;
@property(nonatomic, assign, readonly) CGPoint point;
@property(nonatomic, assign, readonly) CGSize size;
@property(nonatomic, assign, readonly) VVEdgeInsets insets;

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType;

+ (instancetype)infoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType;

@end

NS_ASSUME_NONNULL_END
