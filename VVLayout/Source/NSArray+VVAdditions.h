//
// Created by Tank on 2019-08-22.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVLayout.h"

typedef NS_ENUM(NSUInteger, VVAxisType) {
    VVAxisTypeHorizontal,
    VVAxisTypeVertical
};

@interface NSArray (VVAdditions)

- (NSArray *)makeLayouts:(MakeHandler)makeHandler;

- (NSArray *)remakeLayouts:(MakeHandler)makeHandler;

- (NSArray *)updateLayouts:(MakeHandler)makeHandler;

- (NSArray *)layouts:(MakeHandler)makeHandler state:(NSNumber *)state;


/**
 *  distribute with fixed spacing
 *
 *  @param axisType     横排还是竖排
 *  @param fixedSpacing 两个控件间隔
 *  @param leadSpacing  第一个控件与边缘的间隔
 *  @param tailSpacing  最后一个控件与边缘的间隔
 */
- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;

/**
 *  distribute with fixed item size
 *
 *  @param axisType        横排还是竖排
 *  @param fixedItemLength 控件的宽或高
 *  @param leadSpacing     第一个控件与边缘的间隔
 *  @param tailSpacing     最后一个控件与边缘的间隔
 */
- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;

@end