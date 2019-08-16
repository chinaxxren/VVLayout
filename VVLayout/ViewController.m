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

}


@end
