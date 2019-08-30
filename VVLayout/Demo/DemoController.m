//
//  DemoController.m
//  VVLayout
//
//  Created by Tank on 2019/8/6.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "DemoController.h"

#import "VVLayout.h"
#import "ShopCartCell.h"
#import "ArrayView.h"

@interface DemoController ()

@property(nonatomic, strong) UIView *view1;
@property(nonatomic, strong) UIView *view2;
@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) ShopCartCell *shopCartDemo;
@property(nonatomic, strong) ArrayView *arrayView;
@property(nonatomic, assign) NSInteger index;

@end

@implementation DemoController

- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.index = index;
    }

    return self;
}

+ (instancetype)controllerWithIndex:(NSInteger)index {
    return [[self alloc] initWithIndex:index];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)testArray {
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.arrayView];
    [self.arrayView makeLayout:^(VVMakeLayout *make) {
        make.edges.equalTo(self.view);
    }];

    if (self.index == 6) {
        [self.arrayView horizontalFixSpace];
    } else if (self.index == 7) {
        [self.arrayView verticalFixSpace];
    } else if (self.index == 8) {
        [self.arrayView horizontalFixItemWidth];
    } else if (self.index == 9) {
        [self.arrayView verticalFixItemWidth];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.index == 0) {

        // 两个不包含的View
        [self testDemo0];
    } else if (self.index == 1) {

        // 两个包含的View
        [self testDemo1];
    } else if (self.index == 2) {

        // 自动计算高度、宽度等
        [self testDemo2];
    } else if (self.index == 3) {

        // edges用法
        [self testDemo3];
    } else if (self.index == 4) {

        // 更新Frame
        [self testDemo4];
    } else if (self.index == 5) {

        // 更新Frame
        [self testSafeArea];
    } else {

        // Array
        [self testArray];
    }
}

- (void)testSafeArea {
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.edges.safe.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.index == 4) {
        [self.view1 updateLayout:^(VVMakeLayout *make) {
            make.top.offset(100);
        }];
    }
}

- (void)testDemo4 {
    [self.view addSubview:self.view1];
    [self.view1 remakeLayout:^(VVMakeLayout *make) {
        make.top.equalTo(@200);
        make.centerX.offset(0.0f);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)testDemo3 {
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.edges.vv_equalTo(UIEdgeInsetsMake(150, 80, 200, 100));
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(150, 80, 200, 100));
    }];
}

- (void)testDemo2 {
    [VVLayoutAppearance setGlobalViewScale:YES];
    [VVLayoutAppearance setGlobalScaleFont:YES];

    self.label.text = @"分块下载还有一个比较使用的场景是断点续传，可以将文件分为若干个块，"
                      "然后维护一个下载状态文件用以记录每一个块的状态，这样即使在网络中断后，"
                      "也可以恢复中断前的状态，具体实现读者可以自己尝试一下，还是有一些细节需"
                      "要特别注意的，比如分块大小多少合适？下载到一半的块如何处理？要不要维护"
                      "一个任务队列";
    [self.view addSubview:self.label];

    [self.label makeLayout:^(VVMakeLayout *make) {
        make.center.equalTo(self.view);
        make.width.vv_equalTo(200.0f);
        make.lessHeightThatFits(CGFLOAT_MAX);
    }];
}

- (void)testDemo1 {
    [self.view addSubview:self.view1];
    [self.view1 addSubview:self.view2];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.center.equalTo(self.view);
    }];

    [self.view2 makeLayout:^(VVMakeLayout *make) {
        make.top.vv_equalTo(12.0f);
        make.bottom.vv_equalTo(-14.0f);
        make.left.vv_equalTo(16.0f);
        make.width.equalTo(self.view1.vv_height).multipliedBy(0.5f);
    }];
}

- (void)testDemo0 {
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.center.equalTo(self.view);
    }];

    [self.view2 makeLayout:^(VVMakeLayout *make) {
        make.width.vv_equalTo(50.0f);
        make.height.vv_equalTo(50.0f);
        make.bottom.equalTo(self.view1.vv_top);
        make.left.equalTo(self.view1.vv_right).offset(20.0f);
    }];
}


- (ShopCartCell *)shopCartDemo {
    if (!_shopCartDemo) {
        _shopCartDemo = [ShopCartCell new];
        _shopCartDemo.backgroundColor = [UIColor brownColor];
    }
    return _shopCartDemo;
}

- (ArrayView *)arrayView {
    if (!_arrayView) {
        _arrayView = [ArrayView new];
        _arrayView.backgroundColor = [UIColor brownColor];
    }
    return _arrayView;
}

- (UIView *)view1 {
    if (!_view1) {
        _view1 = [UIView new];
        _view1.tag = 1;
        _view1.backgroundColor = [UIColor redColor];
    }
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        _view2 = [UIView new];
        _view2.tag = 2;
        _view2.backgroundColor = [UIColor blueColor];
    }

    return _view2;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14.0f];
        _label.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _label.textColor = [UIColor blackColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end
