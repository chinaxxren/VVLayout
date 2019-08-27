//
//  ShopCartController.m
//  VVLayout
//
//  Created by Tank on 2019/8/27.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ShopCartController.h"
#import "ShopCartCell.h"

@interface ShopCartController ()

@property(nonatomic, strong) NSMutableArray *textList;

@end

@implementation ShopCartController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[ShopCartCell class] forCellReuseIdentifier:@"ShopCartCell"];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.textList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    [cell configure:self.textList[row] index:row];
    return cell;
}

- (NSMutableArray *)textList {
    if (!_textList) {
        _textList = [NSMutableArray new];
        [_textList addObject:@"0小熊dq-c311 送1架子 dq-c311单层"];
        [_textList addObject:@"1小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层"];
        [_textList addObject:@"2小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层"];
        [_textList addObject:@"3小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层 小熊dq-c311 送4架子 dq-c311单层"];
        [_textList addObject:@"4小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层 小熊dq-c311 送4架子 dq-c311单层 小熊dq-c311 送5架子 dq-c311单层"];
        [_textList addObject:@"5小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层 小熊dq-c311 送4架子 dq-c311单层 小熊dq-c311 送5架子 dq-c311单层 小熊dq-c311 送6架子 dq-c311单层"];
        [_textList addObject:@"7小熊dq-c311 送1架子 dq-c311单层"];
        [_textList addObject:@"8小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层"];
        [_textList addObject:@"9小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层"];
        [_textList addObject:@"10小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层 小熊dq-c311 送4架子 dq-c311单层"];
        [_textList addObject:@"11小熊dq-c311 送1架子 dq-c311单层 小熊dq-c311 送2架子 dq-c311单层 小熊dq-c311 送3架子 dq-c311单层 小熊dq-c311 送4架子 dq-c311单层 小熊dq-c311 送5架子 dq-c311单层"];
    }

    return _textList;
}

@end
