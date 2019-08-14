//
//  ViewController.m
//  VVLayout
//
//  Created by Tank on 2019/8/6.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "VVLayout.h"
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
 
    [self.view1 makeLayout:^(VVLayout *_Nonnull layout) {
        layout.width(100).height(100);
        layout.super_centerX(0);
        layout.super_centerY(0);
    }];

    NSLog(@"view1->%@", NSStringFromCGRect(self.view1.frame));

    [self.view2 makeLayout:^(VVLayout *_Nonnull layout) {
        layout.width(50).height(50);
        layout.bottom_to(self.view1.vv_top, 0);
        layout.left_to(self.view1.vv_right, 20);
    }];

    NSLog(@"view2->%@", NSStringFromCGRect(self.view2.frame));
*/

    [self.view addSubview:self.view1];
    [self.view1 addSubview:self.view2];
    
    [self.view1 makeLayout:^(VVLayout *_Nonnull layout) {
        layout.width(100);
        layout.height(100);
        layout.super_centerX(0).and.super_centerY(0);
    }];
    NSLog(@"view1->%@", NSStringFromCGRect(self.view1.frame));

    [self.view2 makeLayout:^(VVLayout *_Nonnull layout) {
        layout.top(12);
        layout.bottom(14);
        layout.left(16);
        layout.width_to(self.view2.vv_height, 0.5); // width * 0.5 = 50
    }];
    NSLog(@"view2->%@", NSStringFromCGRect(self.view2.frame));
}


@end
