//
// Created by Tank on 2019-08-16.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVLayoutUtils.h"
#import "VVDevice.h"

extern inline EdgeInsets VVEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    EdgeInsets insert;
    insert.top = top * [VVDevice globalScale];
    insert.left = left * [VVDevice globalScale];
    insert.bottom = bottom * [VVDevice globalScale];
    insert.right = right * [VVDevice globalScale];
    return insert;
}

extern inline CGRect VVRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    CGRect rect;
    rect.origin.x = x * [VVDevice globalScale];
    rect.origin.y = y * [VVDevice globalScale];
    rect.size.width = width * [VVDevice globalScale];
    rect.size.height = height * [VVDevice globalScale];
    return rect;
}

extern inline CGSize VVSizeMake(CGFloat width, CGFloat height) {
    CGSize size;
    size.width = [VVDevice globalScale] * width;
    size.height = [VVDevice globalScale] * height;
    return size;
}

extern inline CGPoint VVPointMake(CGFloat x, CGFloat y) {
    CGPoint point;
    point.x = [VVDevice globalScale] * x;
    point.y = [VVDevice globalScale] * y;
    return point;
}

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
extern inline id _VVBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint) va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize) va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(EdgeInsets)) == 0) {
        EdgeInsets actual = (EdgeInsets) va_arg(v, EdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double) va_arg(v, double);
        obj = @(actual);
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float) va_arg(v, double);
        obj = @(actual);
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int) va_arg(v, int);
        obj = @(actual);
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long) va_arg(v, long);
        obj = @(actual);
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long) va_arg(v, long long);
        obj = @(actual);
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short) va_arg(v, int);
        obj = @(actual);
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char) va_arg(v, int);
        obj = @(actual);
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool) va_arg(v, int);
        obj = @(actual);
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char) va_arg(v, unsigned int);
        obj = @(actual);
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int) va_arg(v, unsigned int);
        obj = @(actual);
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long) va_arg(v, unsigned long);
        obj = @(actual);
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long) va_arg(v, unsigned long long);
        obj = @(actual);
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short) va_arg(v, unsigned int);
        obj = @(actual);
    }
    va_end(v);
    return obj;
}

@implementation VVLayoutUtils

+ (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

+ (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown;
}

@end
