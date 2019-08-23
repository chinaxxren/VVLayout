//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "UIFont+VVLayout.h"
#import "VVLayoutAppearance.h"

#import <objc/message.h>

@implementation UIFont (VVLayout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(systemFontOfSize:) anotherMethod:@selector(vv_systemFontOfSize:)];
        [self swizzleMethod:@selector(boldSystemFontOfSize:) anotherMethod:@selector(vv_boldSystemFontOfSize:)];
        [self swizzleMethod:@selector(italicSystemFontOfSize:) anotherMethod:@selector(vv_italicSystemFontOfSize:)];
    });
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (UIFont *)vv_systemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize * [VVLayoutAppearance scale]];
}

+ (UIFont *)vv_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize * [VVLayoutAppearance scale]];
}

+ (UIFont *)vv_italicSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont italicSystemFontOfSize:fontSize * [VVLayoutAppearance scale]];
}

@end