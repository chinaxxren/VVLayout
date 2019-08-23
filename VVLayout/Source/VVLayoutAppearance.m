//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVLayoutAppearance.h"

static CGFloat vv_global_scale;
static BOOL vv_open_scale;
static BOOL vv_scale_font;

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

+ (BOOL)openScaleFont {
    return vv_scale_font;
}

+ (void)setScaleFont:(BOOL)scaleFont {
    vv_scale_font = scaleFont;
}

+ (BOOL)openGlobalScale {
    return vv_open_scale;
}

+ (void)setGlobalScale:(CGFloat)value {
    vv_global_scale = value;
}

+ (CGFloat)globalScale {
    if (!vv_open_scale) {
        return 1.0f;
    }

    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        vv_global_scale = [VVLayoutAppearance xMin] / 375.0f;
    });

    return vv_global_scale;
}

@end
