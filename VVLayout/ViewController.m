//
//  ViewController.m
//  VVLayout
//
//  Created by Tank on 2019/8/6.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "VVLayout.h"
#import "ShopCartView.h"

@interface ViewController ()

@property(nonatomic, strong) UIView *view1;
@property(nonatomic, strong) UIView *view2;
@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) ShopCartView *shopCartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testShopCart];
}

- (void)testShopCart {
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.shopCartView];
    [self.shopCartView configure];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

/*
    [_view addSubview:_view1];
    [_view addSubview:_view2];

    [_view1 makeBlock:^(VVMake *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.centerX.equalTo(_view);
        make.centerY.equalTo(_view);
    }];

    NSLog(@"view1->%@", NSStringFromCGRect(_view1.frame));

    [_view2 makeBlock:^(VVMake *make) {
        make.width.vv_equalTo(50.0f);
        make.height.vv_equalTo(50.0f);
        make.bottom.equalTo(_view1.vv_top);
        make.left.equalTo(_view1.vv_right).offset(20.0f);
    }];
    
    NSLog(@"view2->%@", NSStringFromCGRect(_view2.frame));
 */
/*

    [_view addSubview:_view1];
    [_view1 addSubview:_view2];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.centerX.equalTo(_view);
        make.centerY.equalTo(_view);
    }];
    NSLog(@"view1->%@", NSStringFromCGRect(_view1.frame));

    [_view2 makeLayout:^(VVMakeLayout *make) {
        make.top.vv_equalTo(12.0f);
        make.bottom.vv_equalTo(14.0f);
        make.left.vv_equalTo(16.0f);
        make.width.equalTo(_view1.vv_height).multipliedBy(0.5f);
    }];
    NSLog(@"view2->%@", NSStringFromCGRect(_view2.frame));

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.sizeThatFits(CGSizeMake(100, 100)).offset(10);
    }];
*/
/*
    _label.text = @"分块下载还有一个比较使用的场景是断点续传，可以将文件分为若干个块，然后维护一个下载状态文件用以记录每一个块的状态，这样即使在网络中断后，也可以恢复中断前的状态，具体实现读者可以自己尝试一下，还是有一些细节需要特别注意的，比如分块大小多少合适？下载到一半的块如何处理？要不要维护一个任务队列";
    [_view addSubview:_label];

    [_label makeLayout:^(VVMakeLayout *make) {
        make.centerX.equalTo(_view);
        make.centerY.equalTo(_view);
        make.sizeThatFits(CGSizeMake(200, 40.0f));
    }];
*/
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.centerX.equalTo(_view);
        make.centerY.equalTo(_view);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
*/
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
//        make.edges.vv_equalTo(UIEdgeInsetsMake(150, 80, 200, 100));
        make.edges.equalTo(_view).vv_equalTo(UIEdgeInsetsMake(150, 80, 200, 100));
    }];
*/
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.center.equalTo(_view);
        make.width.equalTo(@100);
        make.height.equalTo(@160);
//        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.width.equalTo(@50);
    }             forState:@1];
    */
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.top.equalTo(@110);
        make.centerX.equalTo(@100);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
*/
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.top.offset(300);
        make.centerX.equalTo(_view);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
    */
/*
    [_view addSubview:_view1];

    [_view1 makeLayout:^(VVMakeLayout *make) {
        make.edges.equalTo(_view).insets(UIEdgeInsetsMake(150, 80, 200, 100));
    }];
    */

    [self.shopCartView makeLayout:^(VVMakeLayout *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.vv_equalTo(132.0f);
    }];
}

- (ShopCartView *)shopCartView {
    if (!_shopCartView) {
        _shopCartView = [ShopCartView new];
    }
    return _shopCartView;
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
        _label.backgroundColor = [UIColor greenColor];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _view1.vv_state = @1;
    [_view1 setNeedsLayout];
}

@end
