//
// Created by Tank on 2019-08-21.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "ShopCartView.h"

#import "VVLayout.h"

@interface ShopCartView ()

@property(nonatomic, strong) UIView *groundView;
@property(nonatomic, strong) UIButton *checkBtn;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *minusBtn;
@property(nonatomic, strong) UIImageView *shopImgView;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *descLab;
@property(nonatomic, strong) UILabel *priceLab;

@property(nonatomic, strong) UITextField *countField;

@end

@implementation ShopCartView

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor lightGrayColor];

    [self addSubview:self.groundView];
    [self.groundView addSubview:self.checkBtn];
    [self.groundView addSubview:self.shopImgView];
    [self.groundView addSubview:self.titleLab];
    [self.groundView addSubview:self.descLab];
    [self.groundView addSubview:self.priceLab];
    [self.groundView addSubview:self.addBtn];
    [self.groundView addSubview:self.countField];
    [self.groundView addSubview:self.minusBtn];
}

- (void)configure {
    self.titleLab.text = @"小熊（bear）煮蛋器系列jdq-c31";
    self.descLab.text = @"单层dq-c311 送1架子 单层dq-c311 单层dq-c311 送1架子 单层dq-c311";
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.groundView makeLayout:^(VVMakeLayout *make) {
        make.edges.vv_equalTo(UIEdgeInsetsMake(0, 10.0f, 0.0f, 10.0f));
    }];

    [self.checkBtn makeLayout:^(VVMakeLayout *make) {
        make.left.offset(12.0f);
        make.centerY.offset(0.0f);
        make.size.vv_equalTo(CGSizeMake(19.0f, 19.0f));
    }];

    [self.shopImgView makeLayout:^(VVMakeLayout *make) {
        make.left.equalTo(self.checkBtn.vv_right).offset(10.0f);
        make.centerY.offset(0.0f);
        make.size.vv_equalTo(CGSizeMake(85.0f, 85.0f));
    }];

    [self.priceLab makeLayout:^(VVMakeLayout *make) {
        make.left.equalTo(self.shopImgView.vv_right).offset(12.0f);
        make.right.equalTo(self.groundView.vv_right).offset(-12.0f);
        make.bottom.offset(-23.0f);
        make.height.vv_equalTo(18.0f);
    }];

    [self.titleLab makeLayout:^(VVMakeLayout *make) {
        make.right.offset(-12.0f);
        make.left.equalTo(self.shopImgView.vv_right).offset(12.0f);
        make.top.equalTo(self.shopImgView.vv_top);
        make.height.vv_equalTo(16.0f);
    }];

    [self.descLab makeLayout:^(VVMakeLayout *make) {
        make.top.equalTo(self.titleLab.vv_bottom).offset(6.0f);
        make.right.offset(-12.0f);
        make.left.equalTo(self.titleLab.vv_left);
        make.autoHeight(CGFLOAT_MAX);
    }];

    [self.minusBtn makeLayout:^(VVMakeLayout *make) {
        make.right.offset(-12.0f);
        make.bottom.offset(-14.0f);
        make.size.vv_equalTo(CGSizeMake(21.0f, 21.0f));
    }];

    [self.countField makeLayout:^(VVMakeLayout *make) {
        make.right.equalTo(self.minusBtn.vv_left);
        make.centerY.equalTo(self.minusBtn.vv_centerY);
        make.size.vv_equalTo(CGSizeMake(35.0f, 21.0f));
    }];

    [self.addBtn makeLayout:^(VVMakeLayout *make) {
        make.right.equalTo(self.countField.vv_left);
        make.centerY.equalTo(self.minusBtn.vv_centerY);
        make.size.vv_equalTo(CGSizeMake(21.0f, 21.0f));
    }];
}

- (UIView *)groundView {
    if (!_groundView) {
        _groundView = [UIView new];
        _groundView.backgroundColor = [UIColor brownColor];
    }

    return _groundView;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton new];
        [_checkBtn setImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    }

    return _checkBtn;
}

- (UIImageView *)shopImgView {
    if (!_shopImgView) {
        _shopImgView = [UIImageView new];
        _shopImgView.backgroundColor = [UIColor redColor];
    }

    return _shopImgView;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setImage:[UIImage imageNamed:@"sc+"] forState:UIControlStateNormal];
    }

    return _addBtn;
}

- (UIButton *)minusBtn {
    if (!_minusBtn) {
        _minusBtn = [UIButton new];
        [_minusBtn setImage:[UIImage imageNamed:@"sc_"] forState:UIControlStateNormal];
    }

    return _minusBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.backgroundColor = [UIColor blueColor];
        _titleLab.font = [UIFont systemFontOfSize:12.0f];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 0;
    }

    return _titleLab;
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [UILabel new];
        _descLab.backgroundColor = [UIColor yellowColor];
        _descLab.font = [UIFont systemFontOfSize:12.0f];
        _descLab.textColor = [UIColor grayColor];
        _descLab.numberOfLines = 0;
    }

    return _descLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.backgroundColor = [UIColor brownColor];
        _priceLab.font = [UIFont systemFontOfSize:13.0f];
        _priceLab.textColor = [UIColor redColor];
        _priceLab.numberOfLines = 1;
        _priceLab.text = @"¥15.00";
    }

    return _priceLab;
}

- (UITextField *)countField {
    if (!_countField) {
        _countField = [UITextField new];
        _countField.backgroundColor = [UIColor cyanColor];
        _countField.font = [UIFont systemFontOfSize:6.0f];
        _countField.textColor = [UIColor blackColor];
        _countField.textAlignment = NSTextAlignmentCenter;
        _countField.text = @"1";
    }

    return _countField;
}

@end
