//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVDevice.h"

static CGFloat vv_global_scale;
static BOOL vv_open_view_scale;
static BOOL vv_font_scale;

@implementation VVDevice

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)minWidth {
    return MIN([VVDevice height], [VVDevice width]);
}

+ (CGFloat)maxHeight {
    return MAX([VVDevice height], [VVDevice width]);
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

+ (void)setOpenScale:(BOOL)open {
    vv_open_view_scale = open;
}

+ (CGFloat)globalScale {
    if (!vv_open_view_scale) {
        return 1.0f;
    }

    return vv_global_scale;
}

+ (void)setGlobalScale:(CGFloat)scale {
    vv_global_scale = scale;
}

@end
