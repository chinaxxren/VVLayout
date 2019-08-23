//
// Created by Tank on 2019-08-22.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "ArrayDemo.h"
#import "VVLayout.h"


@interface ArrayDemo ()

@property(nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation ArrayDemo

- (NSMutableArray *)viewArray {
    if (!_viewArray) {

        _viewArray = [NSMutableArray array];

        for (int i = 0; i < 4; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor redColor];
            [self addSubview:view];
            [_viewArray addObject:view];
        }
    }

    return _viewArray;
}

// 水平方向排列、固定控件间隔、控件长度不定
- (void)horizontalFixSpace {

    // 实现水平固定间隔方法
    [self.viewArray distributeViewsAlongAxis:VVAxisTypeHorizontal withFixedSpacing:30 leadSpacing:20 tailSpacing:-10];

    // 设置array的垂直方向的约束
    [self.viewArray makeLayouts:^(VVMakeLayout *make) {
        make.top.vv_equalTo(160);
        make.height.vv_equalTo(80);
    }];
}

// 垂直方向排列、固定控件间隔、控件高度不定
- (void)verticalFixSpace {

    // 实现垂直固定控件高度方法
    [self.viewArray distributeViewsAlongAxis:VVAxisTypeVertical withFixedSpacing:30 leadSpacing:50 tailSpacing:-20];

    // 设置array的水平方向的约束
    [self.viewArray makeLayouts:^(VVMakeLayout *make) {
        make.left.vv_equalTo(160.0f);
        make.width.vv_equalTo(80.0f);
    }];
}

// 水平方向排列、固定控件长度、控件间隔不定
- (void)horizontalFixItemWidth {

    // 实现水平固定控件宽度方法
    [self.viewArray distributeViewsAlongAxis:VVAxisTypeHorizontal withFixedItemLength:80 leadSpacing:10 tailSpacing:-10];

    // 设置array的垂直方向的约束
    [self.viewArray makeLayouts:^(VVMakeLayout *make) {
        make.top.vv_equalTo(160);
        make.height.vv_equalTo(80);
    }];
}

// 垂直方向排列、固定控件高度、控件间隔不定
- (void)verticalFixItemWidth {

    // 实现垂直方向固定控件高度方法
    [self.viewArray distributeViewsAlongAxis:VVAxisTypeVertical withFixedItemLength:80 leadSpacing:50 tailSpacing:-20];

    // 设置array的水平方向的约束
    [self.viewArray makeLayouts:^(VVMakeLayout *make) {
        make.left.vv_equalTo(160);
        make.width.vv_equalTo(80);
    }];
}

@end