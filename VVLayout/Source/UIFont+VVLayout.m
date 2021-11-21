//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "UIFont+VVLayout.h"

#import "VVDevice.h"

@implementation UIFont (VVLayout)

+ (UIFont *)systemWithSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)boldSystemWithSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)lightPingFangWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Light" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)regularPingFangWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)mediumPingFangWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)semiboldPingFangWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)helveticaWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Helvetica" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)lightHelveticaWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Helvetica-Light" size:fontSize * [VVDevice globalScale]];
}

+ (UIFont *)boldHelveticaWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize * [VVDevice globalScale]];
}

@end
