//
//  ViewController.m
//  VVLayout
//
//  Created by Tank on 2019/8/6.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "VVMakeLayout.h"
#import "UIView+VVLayout.h"
#import "UIView+VVExtend.h"

@interface ViewController ()

@property(nonatomic, strong) UIView *view1;
@property(nonatomic, strong) UIView *view2;
@property(nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view1 = [UIView new];
    self.view1.tag = 1;
    self.view1.backgroundColor = [UIColor redColor];

    self.view2 = [UIView new];
    self.view2.tag = 2;
    self.view2.backgroundColor = [UIColor blueColor];

    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.backgroundColor = [UIColor greenColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.numberOfLines = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

/*
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];

    [self.view1 makeBlock:^(VVMake *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    NSLog(@"view1->%@", NSStringFromCGRect(self.view1.frame));

    [self.view2 makeBlock:^(VVMake *make) {
        make.width.vv_equalTo(50.0f);
        make.height.vv_equalTo(50.0f);
        make.bottom.equalTo(self.view1.vv_top);
        make.left.equalTo(self.view1.vv_right).offset(20.0f);
    }];
    
    NSLog(@"view2->%@", NSStringFromCGRect(self.view2.frame));
 */
/*

    [self.view addSubview:self.view1];
    [self.view1 addSubview:self.view2];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.width.vv_equalTo(100);
        make.height.vv_equalTo(100);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    NSLog(@"view1->%@", NSStringFromCGRect(self.view1.frame));

    [self.view2 makeLayout:^(VVMakeLayout *make) {
        make.top.vv_equalTo(12.0f);
        make.bottom.vv_equalTo(14.0f);
        make.left.vv_equalTo(16.0f);
        make.width.equalTo(self.view1.vv_height).multipliedBy(0.5f);
    }];
    NSLog(@"view2->%@", NSStringFromCGRect(self.view2.frame));

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.sizeThatFits(CGSizeMake(100, 100)).offset(10);
    }];
*/
/*
    self.label.text = @"分块下载还有一个比较使用的场景是断点续传，可以将文件分为若干个块，然后维护一个下载状态文件用以记录每一个块的状态，这样即使在网络中断后，也可以恢复中断前的状态，具体实现读者可以自己尝试一下，还是有一些细节需要特别注意的，比如分块大小多少合适？下载到一半的块如何处理？要不要维护一个任务队列";
    [self.view addSubview:self.label];

    [self.label makeLayout:^(VVMakeLayout *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.sizeThatFits(CGSizeMake(200, 40.0f));
    }];
*/
/*
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
*/
/*
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
//        make.edges.vv_equalTo(UIEdgeInsetsMake(150, 80, 200, 100));
        make.edges.equalTo(self.view).vv_equalTo(UIEdgeInsetsMake(150, 80, 200, 100));
    }];
*/
/*
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@160);
//        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.width.equalTo(@50);
    }             forState:@1];
    */
/*
    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.top.equalTo(@110);
        make.centerX.equalTo(@100);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
*/

    [self.view addSubview:self.view1];

    [self.view1 makeLayout:^(VVMakeLayout *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(200.0f);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    self.view1.vv_state = @1;
    [self.view setNeedsLayout];
}

@end
