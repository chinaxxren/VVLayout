# VVLayout

1. 支持Masonry基本接口的方法
2. 底层采用Frame布局方式
3. 支持按手机屏幕适配大小

## 支持
* 单个View
```obj-c
left、right、top、bottom、centerX、centerY、center、width、height、edges等
```
* 数组View

```obj-c

/**
 *  distribute with fixed spacing
 *
 *  @param axisType     横排还是竖排
 *  @param fixedSpacing 两个控件间隔
 *  @param leadSpacing  第一个控件与边缘的间隔
 *  @param tailSpacing  最后一个控件与边缘的间隔
 */
- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;

/**
 *  distribute with fixed item size
 *
 *  @param axisType        横排还是竖排
 *  @param fixedItemLength 控件的宽或高
 *  @param leadSpacing     第一个控件与边缘的间隔
 *  @param tailSpacing     最后一个控件与边缘的间隔
 */
- (void)distributeViewsAlongAxis:(VVAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing;

```
## 不支持
* 不支持greaterThanOrEqualTo和lessThanOrEqualTo，UILabel替代方案lessHeightThatFits、greatHeightThatFits、lessWidthThatFits、greatWidthThatFits
* 不支持属性值连续链式调用，只能用一个。例如：width.height 或者 top.left.right。

## 例子
* 两个View的不包含
![alt Framer](https://user-gold-cdn.xitu.io/2019/8/27/16cd11eae9807e99?w=446&h=378&f=png&s=4330)

```obj-c
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
```
* 两个View的包含
![alt Framer](https://user-gold-cdn.xitu.io/2019/8/27/16cd12287b59f6fc?w=202&h=188&f=png&s=1528)
```obj-c
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
```
* 自动计算高度、宽度等
![alt Framer](https://user-gold-cdn.xitu.io/2019/8/27/16cd1262a29170be?w=448&h=370&f=png&s=114928)
```obj-c
    self.label.text = @"分块下载还有一个比较使用的场景是断点续传，可以将文件分为若干个块，"
                      "然后维护一个下载状态文件用以记录每一个块的状态，这样即使在网络中断后，"
                      "也可以恢复中断前的状态，具体实现读者可以自己尝试一下，还是有一些细节需"
                      "要特别注意的，比如分块大小多少合适？下载到一半的块如何处理？要不要维护"
                      "一个任务队列";
    [self.label makeLayout:^(VVMakeLayout *make) {
        make.center.equalTo(self.view);
        make.width.vv_equalTo(200.0f);
        make.lessHeightThatFits(CGFLOAT_MAX);
    }];
```
* view的更新
```obj-c
    [self.view1 updateLayout:^(VVMakeLayout *make) {
        make.top.offset(100);
    }];
```
* view的重新布局
```obj-c
    [self.view1 remakeLayout:^(VVMakeLayout *make) {
        make.top.equalTo(@200);
        make.centerX.offset(0.0f);
        make.size.vv_equalTo(CGSizeMake(100, 100));
    }];
```

# 使用
pod 'VVLayout'

