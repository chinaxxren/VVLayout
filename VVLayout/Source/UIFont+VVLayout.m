//
// Created by Tank on 2019-08-23.
// Copyright (c) 2019 Tank. All rights reserved.
//


#import "UIFont+VVLayout.h"

#import <objc/message.h>

#import "VVLayoutAppearance.h"

@implementation UIFont (VVLayout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(_systemFontOfSize_:) originalMethod:@selector(systemFontOfSize:)];
        [self swizzleMethod:@selector(_boldSystemFontOfSize_:) originalMethod:@selector(boldSystemFontOfSize:)];
        [self swizzleMethod:@selector(_italicSystemFontOfSize_:) originalMethod:@selector(italicSystemFontOfSize:)];
    });
}

+ (void)swizzleMethod:(SEL)swizzleMethod originalMethod:(SEL)originalMethod {
    Method newMethod = class_getClassMethod([self class], swizzleMethod);
    Method method = class_getClassMethod([self class], originalMethod);
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)_systemFontOfSize_:(CGFloat)fontSize {
    if ([VVLayoutAppearance hasGlobalFontScale]) {
        return [UIFont _systemFontOfSize_:fontSize * [VVLayoutAppearance globalScale]];
    }

    return [UIFont _systemFontOfSize_:fontSize];
}

+ (UIFont *)_boldSystemFontOfSize_:(CGFloat)fontSize {
    if ([VVLayoutAppearance hasGlobalFontScale]) {
        return [UIFont _boldSystemFontOfSize_:fontSize * [VVLayoutAppearance globalScale]];
    }
    return [UIFont _boldSystemFontOfSize_:fontSize];
}

+ (UIFont *)_italicSystemFontOfSize_:(CGFloat)fontSize {
    if ([VVLayoutAppearance hasGlobalFontScale]) {
        return [UIFont _italicSystemFontOfSize_:fontSize * [VVLayoutAppearance globalScale]];
    }

    return [UIFont _italicSystemFontOfSize_:fontSize];
}

+ (UIFont *)vv_systemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize * [VVLayoutAppearance globalScale]];
}

+ (UIFont *)vv_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize * [VVLayoutAppearance globalScale]];
}

+ (UIFont *)vv_italicSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont italicSystemFontOfSize:fontSize * [VVLayoutAppearance globalScale]];
}

@end
