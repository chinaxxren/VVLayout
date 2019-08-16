//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayout.h"

#import "VVMakeLayoutInfo.h"
#import "VVMakeBlock.h"
#import "UIView+VVLayout.h"
#import "UIView+VVExtend.h"

@interface VVMakeLayout ()

@property(nonatomic, strong) VVMakeLayoutInfo *makeLayoutInfo;

@property(nonatomic, getter=isTopFrameInstalled) BOOL topFrameInstalled;
@property(nonatomic, getter=isLeftFrameInstalled) BOOL leftFrameInstalled;
@property(nonatomic) CGRect newFrame;

@property(nonatomic, nonnull) NSMutableArray <VVMakeLayoutInfo *> *makeInfos;
@property(nonatomic, nonnull) NSMutableArray <VVMakeBlock *> *blcoks;
@property(nonatomic, weak, nullable) UIView *view;

@end

@implementation VVMakeLayout


#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _makeInfos = [NSMutableArray new];
        _blcoks = [NSMutableArray new];

#ifdef VVOBS
        [self addObserver:self forKeyPath:@"newFrame" options:NSKeyValueObservingOptionNew context:nil];
#endif

    }
    return self;
}

#ifdef VVOBS
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"newFrame"]) {
        VVLayout *vvf = (VVLayout *) object;
        NSLog(@"%@", NSStringFromCGRect(vvf.newFrame));
    }
}
#endif

#pragma mark - Configurate methods

+ (void)configView:(UIView *)view makeLayout:(MakeLayout)make {
    [self configView:view forState:@0 makeLayout:make];
}

+ (void)configView:(UIView *)view forState:(NSNumber *)state makeLayout:(MakeLayout)makeLayout {
    if (view.vv_state.integerValue == state.integerValue) {
        VVMakeLayout *layout = [VVMakeLayout new];
        layout.view = view;

        [layout startConfig];

        // 在Block中进行设置操作
        if (makeLayout) {
            makeLayout(layout);
        }

        [layout configFrames];
    }
}

// 将记录当前 View的frame的值
- (void)startConfig {
    self.newFrame = self.view.frame;
}

// 将新的frame赋值给当前 View
- (void)endConfig {
    self.view.frame = self.newFrame;
}

// 按照优先级进行排序
- (void)configOrderHandlers {
    for (VVMakeLayoutInfo *makeInfo in self.makeInfos) {
        switch (makeInfo.makeLayoutType) {
            case VVMakeLayoutTypeTop: {
                [self topWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeBottom: {
                [self bottomWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeLeft: {
                [self leftWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeRight: {
                [self rightWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeCenterX: {
                [self centerXWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeCenterY: {
                [self centerYWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeWidth: {
                [self widthWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeHeight: {
                [self heightWithMakeInfo:makeInfo];
            }
                break;
            case VVMakeLayoutTypeEdges: {
                // [self edgesWithMakeInfo:makeInfo];
            }
                break;
            default:
                break;
        }
    }

    [self.blcoks sortUsingComparator:^NSComparisonResult(VVMakeBlock *_Nonnull block_t1, VVMakeBlock *block_t2) {
        if (block_t1.priority > block_t2.priority) {
            return NSOrderedAscending;
        }

        return (block_t1.priority == block_t2.priority) ? NSOrderedSame : NSOrderedDescending;
    }];
}

- (void)configFrames {
    [self configOrderHandlers];

    [self.blcoks enumerateObjectsUsingBlock:^(VVMakeBlock *_Nonnull block_t, NSUInteger idx, BOOL *_Nonnull stop) {
        block_t.make_block_t();
    }];

    [self endConfig];
}

- (VVMakeLayout *)left {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeLeft];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)right {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeRight];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)top {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeTop];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)bottom {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeBottom];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerX {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeCenterX];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerY {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeCenterY];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)width {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeWidth];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)height {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeHeight];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)edges {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeEdges];
    [self.makeInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *(^)(CGFloat))vv_equalTo {
    return ^id(CGFloat inset) {
        self.makeLayoutInfo.isNum = YES;
        self.makeLayoutInfo.value = inset;
        self.makeLayoutInfo.viewLayoutType = self.makeLayoutInfo.makeLayoutType;
        return self;
    };
}

- (VVMakeLayout *(^)(UIView *))equalTo {
    return ^(UIView *view) {
        self.makeLayoutInfo.isNum = NO;
        self.makeLayoutInfo.view = view;
        if (view.viewLayoutType == VVMakeLayoutTypeNone) {
            self.makeLayoutInfo.viewLayoutType = self.makeLayoutInfo.makeLayoutType;
        } else {
            self.makeLayoutInfo.viewLayoutType = view.viewLayoutType;
        }
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))offset {
    return ^id(CGFloat inset) {
        self.makeLayoutInfo.value = inset;
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplied) {
        self.makeLayoutInfo.multiplied = multiplied;
        return self;
    };
}

- (VVMakeLayout *(^)(NSInteger))priority {
    return ^id(NSInteger priority) {
        self.makeLayoutInfo.priority = priority;
        return self;
    };
}

#pragma mark - Helpers

- (VVMakeLayoutInfo *)infoForType:(VVMakeLayoutType)type {
    for (VVMakeLayoutInfo *mi in self.makeInfos) {
        if (mi.makeLayoutType == type && mi.isNum) {
            return mi;
        }
    }

    return nil;
}

// 得到当前 view 的对应位置的值
- (CGFloat)valueForMakeLayoutType:(VVMakeLayoutType)type forView:(UIView *)view {
    if (!view) {
        view = self.view.superview;
    }
    CGRect convertedRect = [self.view.superview convertRect:view.frame fromView:view.superview];
    switch (type) {
        case VVMakeLayoutTypeTop:
            return CGRectGetMinY(convertedRect);
        case VVMakeLayoutTypeBottom:
            return CGRectGetMaxY(convertedRect);
        case VVMakeLayoutTypeCenterY:
            return CGRectGetMidY(convertedRect);
        case VVMakeLayoutTypeCenterX:
            return CGRectGetMidX(convertedRect);
        case VVMakeLayoutTypeRight:
            return CGRectGetMaxX(convertedRect);
        case VVMakeLayoutTypeLeft:
            return CGRectGetMinX(convertedRect);
        default:
            return 0;
    }
}

#pragma mark Left relations

- (void)leftWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGFloat x = [self leftRelationXForView:makeInfo.view
                                     withInset:makeInfo.value
                                makeLayoutType:makeLayoutType];
        CGRect frame = self.newFrame;
        frame.origin.x = x;
        self.newFrame = frame;
        self.leftFrameInstalled = YES;
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (CGFloat)leftRelationXForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x + inset;
}


#pragma mark Top relations

- (void)topWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGFloat y = [self topRelationYForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];
        CGRect frame = self.newFrame;
        frame.origin.y = y;
        self.newFrame = frame;
        self.topFrameInstalled = YES;
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (CGFloat)topRelationYForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y + inset;
}


#pragma mark Bottom relations

- (void)bottomWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        if (!self.isTopFrameInstalled) {
            CGFloat y = [self bottomRelationYForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];
            frame.origin.y = y;
        } else {
            frame.size.height = [self bottomRelationHeightForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];;
        }
        self.newFrame = frame;
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

//当前view在传入view下面
- (CGFloat)bottomRelationHeightForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat height = fabs(CGRectGetMinY(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return height - inset;
}

//当前view在传入view上面
- (CGFloat)bottomRelationYForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y - inset - CGRectGetHeight(self.newFrame);
}

#pragma mark Right relations

- (void)rightWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        if (!self.isLeftFrameInstalled) {
            CGFloat x = [self rightRelationXForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];
            frame.origin.x = x;
        } else {
            frame.size.width = [self rightRelationWidthForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];;
        }
        self.newFrame = frame;
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (CGFloat)rightRelationWidthForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat width = fabs(CGRectGetMinX(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return width - inset;
}

- (CGFloat)rightRelationXForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x - inset - CGRectGetWidth(self.newFrame);
}

#pragma mark - Low priority

#pragma mark Center X relations

- (void)vv_centerXWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.x = makeInfo.value - CGRectGetWidth(frame) * 0.5f;
        self.newFrame = frame;
    };
    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (void)vv_centerYWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.y = makeInfo.value - CGRectGetHeight(frame) * 0.5f;
        self.newFrame = frame;
    };
    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (void)centerXWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.x = [self centerRelationXForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];
        self.newFrame = frame;
    };
    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (CGFloat)centerRelationXForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x - CGRectGetWidth(self.newFrame) * 0.5f - inset;
}

#pragma mark Center Y relations

- (void)centerYWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.y = [self centerRelationYForView:makeInfo.view withInset:makeInfo.value makeLayoutType:makeLayoutType];
        self.newFrame = frame;
    };
    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (CGFloat)centerRelationYForView:(UIView *)view withInset:(CGFloat)inset makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y - CGRectGetHeight(self.newFrame) * 0.5f - inset;
}

#pragma mark - Top priority

#pragma mark Width / Height relations

- (void)widthWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);

        if (makeInfo.view && makeInfo.view != self.view) {
            CGFloat width = [self sizeForView:makeInfo.view withMakeLayoutType:makeLayoutType] * makeInfo.multiplied;
            [self setFrameValue:width type:VVMakeLayoutTypeWidth];
        } else {
            VVMakeLayoutInfo *heightInfo = [self infoForType:VVMakeLayoutTypeHeight];
            if (heightInfo && heightInfo.isNum) {
                CGFloat width = heightInfo.value;
                [self setFrameValue:width * makeInfo.multiplied type:VVMakeLayoutTypeWidth];

            } else if (heightInfo && !heightInfo.isNum) {
                UIView *tempRelationView = heightInfo.view;
                CGFloat tempMultiplier = heightInfo.multiplied;
                VVMakeLayoutType makeType = heightInfo.makeLayoutType;

                CGFloat width = [self sizeForView:tempRelationView withMakeLayoutType:makeType] * (tempMultiplier * makeInfo.multiplied);
                [self setFrameValue:width type:VVMakeLayoutTypeWidth];

            } else {
                VVMakeLayoutInfo *topInfo = [self infoForType:VVMakeLayoutTypeTop];
                VVMakeLayoutInfo *bottomInfo = [self infoForType:VVMakeLayoutTypeBottom];

                if (topInfo && bottomInfo) {
                    UIView *topView = topInfo.view;
                    CGFloat topInset = topInfo.value;
                    VVMakeLayoutType topMakeLayoutType = topInfo.makeLayoutType;

                    CGFloat topViewY = [self topRelationYForView:topView withInset:topInset makeLayoutType:topMakeLayoutType];

                    UIView *bottomView = bottomInfo.view;
                    CGFloat bottomInset = bottomInfo.value;
                    VVMakeLayoutType bottomMakeLayoutType = bottomInfo.makeLayoutType;

                    CGFloat bottomViewY = [self valueForMakeLayoutType:bottomMakeLayoutType forView:bottomView] - bottomInset;

                    [self setFrameValue:(bottomViewY - topViewY) * makeInfo.multiplied type:VVMakeLayoutTypeWidth];
                }
            }
        }
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (void)heightWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);

        if (makeInfo.view && makeInfo.view != self.view) {
            CGFloat height = [self sizeForView:makeInfo.view withMakeLayoutType:makeLayoutType] * makeInfo.multiplied;
            [self setFrameValue:height type:VVMakeLayoutTypeHeight];
        } else {
            VVMakeLayoutInfo *widthInfo = [self infoForType:VVMakeLayoutTypeWidth];
            if (widthInfo && widthInfo.isNum) {
                CGFloat height = widthInfo.value;
                [self setFrameValue:height * widthInfo.multiplied type:VVMakeLayoutTypeHeight];

            } else if (widthInfo && !widthInfo.isNum) {
                VVMakeLayoutInfo *widthToInfo = [self infoForType:VVMakeLayoutTypeWidth];

                UIView *tempRelationView = widthToInfo.view;
                CGFloat tempMultiplier = widthToInfo.multiplied;
                VVMakeLayoutType makeType = widthToInfo.makeLayoutType;

                CGFloat height = [self sizeForView:tempRelationView withMakeLayoutType:makeType] * (tempMultiplier * makeInfo.multiplied);
                [self setFrameValue:height type:VVMakeLayoutTypeHeight];

            } else {
                VVMakeLayoutInfo *leftInfo = [self infoForType:VVMakeLayoutTypeLeft];
                VVMakeLayoutInfo *rightInfo = [self infoForType:VVMakeLayoutTypeRight];

                if (leftInfo && rightInfo) {
                    UIView *leftView = leftInfo.view;
                    CGFloat leftInset = leftInfo.value;
                    VVMakeLayoutType leftMakeLayoutType = leftInfo.makeLayoutType;

                    CGFloat leftViewX = [self leftRelationXForView:leftView withInset:leftInset makeLayoutType:leftMakeLayoutType];

                    UIView *rightView = rightInfo.view;
                    CGFloat rightInset = rightInfo.value;
                    VVMakeLayoutType rightMakeLayoutType = rightInfo.makeLayoutType;

                    CGFloat rightViewX = [self valueForMakeLayoutType:rightMakeLayoutType forView:rightView] - rightInset;

                    [self setFrameValue:(rightViewX - leftViewX) * makeInfo.multiplied type:VVMakeLayoutTypeHeight];
                }
            }
        }
    };

    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

// 得到当前view的宽或者高
- (CGFloat)sizeForView:(UIView *)view withMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    if (makeLayoutType == VVMakeLayoutTypeWidth) {
        return CGRectGetWidth(view.bounds);
    } else if (makeLayoutType == VVMakeLayoutTypeHeight) {
        return CGRectGetHeight(view.bounds);
    }
    return 0;
}

- (void)setHighPriorityValue:(CGFloat)value withType:(VVMakeLayoutType)type {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        [self setFrameValue:value type:type];
    };

    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:type];
    [self.blcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

// 改变Frame的值
- (void)setFrameValue:(CGFloat)value type:(VVMakeLayoutType)type {
    CGRect frame = self.newFrame;
    switch (type) {
        case VVMakeLayoutTypeWidth:
            frame.size.width = value;
            break;
        case VVMakeLayoutTypeHeight:
            frame.size.height = value;
            break;
        default:
            break;
    }
    self.newFrame = frame;
}

#pragma mark Container

- (VVMakeLayout *)container {
    CGRect frame = CGRectZero;
    for (UIView *subview in [self.view subviews]) {
        frame = CGRectUnion(frame, subview.frame);
    }

    [self setHighPriorityValue:CGRectGetWidth(frame) withType:VVMakeLayoutTypeWidth];
    [self setHighPriorityValue:CGRectGetHeight(frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

#pragma mark Fits

- (VVMakeLayout *)sizeToFit {
    [self.view sizeToFit];
    [self setHighPriorityValue:CGRectGetWidth(self.view.frame) withType:VVMakeLayoutTypeWidth];
    [self setHighPriorityValue:CGRectGetHeight(self.view.frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

- (VVMakeLayout *)widthToFit {
    [self.view sizeToFit];
    [self setHighPriorityValue:CGRectGetWidth(self.view.frame) withType:VVMakeLayoutTypeWidth];
    return self;
}

- (VVMakeLayout *)heightToFit {
    [self.view sizeToFit];
    [self setHighPriorityValue:CGRectGetHeight(self.view.frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

- (VVMakeLayout *(^)(CGSize size))sizeThatFits {
    return ^id(CGSize size) {
        CGSize fitSize = [self.view sizeThatFits:size];
        CGFloat width = MIN(size.width, fitSize.width);
        CGFloat height = MIN(size.height, fitSize.height);
        [self setHighPriorityValue:width withType:VVMakeLayoutTypeWidth];
        [self setHighPriorityValue:height withType:VVMakeLayoutTypeHeight];
        return self;
    };
}

@end
