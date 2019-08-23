//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVLayoutAppearance.h"

static CGFloat vv_global_scale;
static BOOL vv_open_view_scale;
static BOOL vv_font_scale;

@implementation VVLayoutAppearance

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)xMinWidth {
    return MIN([VVLayoutAppearance height], [VVLayoutAppearance width]);
}

+ (CGFloat)xMaxHeight {
    return MAX([VVLayoutAppearance height], [VVLayoutAppearance width]);
}

+ (BOOL)hasGlobalFontScale {
    return vv_font_scale;
}

+ (void)setGlobalScaleFont:(BOOL)scaleFont {
    vv_font_scale = scaleFont;
}

+ (BOOL)hasGlobalViewScale {
    return vv_open_view_scale;
}

+ (void)setGlobalViewScale:(BOOL)open {
    vv_open_view_scale = open;
}

+ (CGFloat)globalScale {
    if (!vv_open_view_scale) {
        return 1.0f;
    }

    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        vv_global_scale = [VVLayoutAppearance xMinWidth] / 375.0f;
    });

    return vv_global_scale;
}

+ (void)setGlobalScale:(CGFloat)value {
    vv_global_scale = value;
}

@end
