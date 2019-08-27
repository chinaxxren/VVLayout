//
//  ViewController.m
//  VVLayout
//
//  Created by Tank on 2019/8/27.
//  Copyright © 2019 Tank. All rights reserved.
//

#import "ViewController.h"

#import "DemoController.h"
#import "ShopCartController.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableArray *textList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.textList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.textList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 9) {
        ShopCartController *shopCartController = [ShopCartController new];
        shopCartController.title = self.textList[indexPath.row];
        [self.navigationController pushViewController:shopCartController animated:YES];
    } else {
        DemoController *demoController = [[DemoController alloc] initWithIndex:row];
        demoController.title = self.textList[indexPath.row];
        [self.navigationController pushViewController:demoController animated:YES];
    }
}

- (NSMutableArray *)textList {
    if (!_textList) {
        _textList = [NSMutableArray new];
        [_textList addObject:@"两个不包含的View"];
        [_textList addObject:@"两个包含的View"];
        [_textList addObject:@"自动计算高度、宽度等"];
        [_textList addObject:@"edges用法"];
        [_textList addObject:@"更新Frame（点击空白触发更新)"];
        [_textList addObject:@"水平方向排列、固定控件间隔、控件长度不定"];
        [_textList addObject:@"垂直方向排列、固定控件间隔、控件高度不定"];
        [_textList addObject:@"水平方向排列、固定控件长度、控件间隔不定"];
        [_textList addObject:@"垂直方向排列、固定控件高度、控件间隔不定"];
        [_textList addObject:@"TableCell例子"];
    }

    return _textList;
}

@end
