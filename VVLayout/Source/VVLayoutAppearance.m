//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVLayoutAppearance.h"

static CGFloat vv_scale;
static BOOL vv_open_scale;

@implementation VVLayoutAppearance

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)xMin {
    return MIN([VVLayoutAppearance height], [VVLayoutAppearance width]);
}

+ (CGFloat)xMax {
    return MAX([VVLayoutAppearance height], [VVLayoutAppearance width]);
}

+ (void)setOpenScale:(BOOL)open {
    vv_open_scale = open;
}

+ (BOOL)openScale {
    return vv_open_scale;
}

+ (void)setScale:(CGFloat)value {
    vv_scale = value;
}

+ (CGFloat)scale {
    if (!vv_open_scale) {
        return 1.0f;
    }

    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        vv_scale = [VVLayoutAppearance xMin] / 375.0f;
    });

    return vv_scale;
}