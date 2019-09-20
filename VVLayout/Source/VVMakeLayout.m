//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayout.h"

#import "VVViewLayoutInfo.h"
#import "VVMakeBlock.h"
#import "UIView+VVLayout.h"
#import "UIView+VVExtend.h"
#import "VVLayoutAppearance.h"

#define EmptyMethodExcetion() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"This is a empty %@ method.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

#if DEBUG && OPENLOG
# define VVLog(fmt,...) NSLog((@"[file:%s]\n" "[method:%s]\n" "[line:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define VVLog(...);
#endif

@interface VVMakeLayout ()

@property(nonatomic, strong) VVViewLayoutInfo *viewLayoutInfo;

@property(nonatomic, getter=isTopMaked) BOOL topMaked;
@property(nonatomic, getter=isLeftMaked) BOOL leftMaked;
@property(nonatomic) CGRect newFrame;

@property(nonatomic, nonnull) NSMutableArray <VVViewLayoutInfo *> *viewLayoutInfos;
@property(nonatomic, nonnull) NSMutableArray <VVMakeBlock *> *makeBlcoks;
@property(nonatomic, weak, nullable) UIView *view;

@end

@implementation VVMakeLayout


#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewLayoutInfos = [NSMutableArray new];
        _makeBlcoks = [NSMutableArray new];

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
        VVLog(@"%@", NSStringFromCGRect(vvf.newFrame));
    }
}
#endif

#pragma mark - Configurate methods

+ (void)configView:(UIView *)view layout:(VVViewLayout)layout {
    [self configView:view state:@0 layout:layout];
}

+ (void)configView:(UIView *)view state:(NSNumber *)state layout:(VVViewLayout)layout {
    if (view.vv_state.integerValue == state.integerValue) {
        VVMakeLayout *makeLayout = [VVMakeLayout new];
        makeLayout.view = view;

        [makeLayout startConfig];

        // 在Block中进行设置操作
        if (layout) {
            layout(makeLayout);
        }

        [makeLayout configFrames];
    }
}

// 将记录当前 View的frame的值
- (void)startConfig {
    VVLog(@"start %@ %@", self.view, NSStringFromCGRect(self.view.frame));
    self.newFrame = self.view.frame;
}

// 将新的frame赋值给当前 View
- (void)endConfig {
    VVLog(@"end %@ %@", self.view, NSStringFromCGRect(self.newFrame));
    self.view.frame = self.newFrame;
}

// 按照优先级进行排序
- (void)configOrderHandlers {
    for (VVViewLayoutInfo *makeInfo in self.viewLayoutInfos) {
        if (makeInfo.equalType == VVEqualTo) {
            [self equalWithMakeInfo:makeInfo];
        } else {
            [self noEqualWithMakeInfo:makeInfo];
        }
    }

    [self.makeBlcoks sortUsingComparator:^NSComparisonResult(VVMakeBlock *_Nonnull block_t1, VVMakeBlock *block_t2) {
        if (block_t1.priority > block_t2.priority) {
            return NSOrderedAscending;
        }

        return (block_t1.priority == block_t2.priority) ? NSOrderedSame : NSOrderedDescending;
    }];
}

- (void)equalWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
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
        case VVMakeLayoutTypeCenter: {
            [self centerWithMakeInfo:makeInfo];
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
        case VVMakeLayoutTypeSize: {
            [self sizeWithMakeInfo:makeInfo];
        }
            break;
        case VVMakeLayoutTypeEdges: {
            [self edgesWithMakeInfo:makeInfo];
            break;
        }
        default:
            break;
    }
}

- (void)noEqualWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    switch (makeInfo.makeLayoutType) {
        case VVMakeLayoutTypeWidth: {
            switch (makeInfo.equalType) {
                case VVGreaterThanOrEqualTo: {
                    [self greatWidthWithMakeInfo:makeInfo];
                }
                case VVLessThanOrEqualTo: {
                    [self lessWidthWithMakeInfo:makeInfo];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case VVMakeLayoutTypeHeight: {
            switch (makeInfo.equalType) {
                case VVGreaterThanOrEqualTo: {
                    [self greatHeightWithMakeInfo:makeInfo];
                }
                case VVLessThanOrEqualTo: {
                    [self lessHeightWithMakeInfo:makeInfo];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case VVMakeLayoutTypeSize: {
            switch (makeInfo.equalType) {
                case VVGreaterThanOrEqualTo: {
                    [self greatSizeWithMakeInfo:makeInfo];
                }
                case VVLessThanOrEqualTo: {
                    [self lessSizeWithMakeInfo:makeInfo];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)configFrames {
    [self configOrderHandlers];

    [self.makeBlcoks enumerateObjectsUsingBlock:^(VVMakeBlock *_Nonnull block_t, NSUInteger idx, BOOL *_Nonnull stop) {
        block_t.make_block_t();
    }];

    [self endConfig];
}

- (VVMakeLayout *)and {
    return self;
}

- (VVMakeLayout *)with {
    return self;
}

- (VVMakeLayout *)safe {
    self.viewLayoutInfo.safe = YES;
    return self;
}

- (VVMakeLayout *)left {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeLeft];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)right {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeRight];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)top {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeTop];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)bottom {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeBottom];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerX {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeCenterX];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerY {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeCenterY];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)center {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeCenter];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)width {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeWidth];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)height {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeHeight];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)size {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeSize];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *)edges {
    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeEdges];
    [self.viewLayoutInfos addObject:self.viewLayoutInfo];
    return self;
}

- (VVMakeLayout *(^)(id))equalTo {
    return ^(id attribute) {
        [self.viewLayoutInfo changeAttribute:attribute equalType:VVEqualTo];
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))offset {
    return ^id(CGFloat offset) {
        self.viewLayoutInfo.value = offset * [VVLayoutAppearance globalScale];
        return self;
    };
}

- (VVMakeLayout *(^)(CGSize))sizeOffset {
    return ^id(CGSize size) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.viewLayoutInfo.size = CGSizeMake(size.width * scale, size.height * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(CGPoint))centerOffset {
    return ^id(CGPoint point) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.viewLayoutInfo.point = CGPointMake(point.x * scale, point.y * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(VVEdgeInsets))insets {
    return ^id(VVEdgeInsets insets) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.viewLayoutInfo.insets = UIEdgeInsetsMake(insets.top * scale, insets.left * scale, insets.bottom * scale, insets.right * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(NSValue *))valueOffset {
    return ^id(NSValue *value) {
        [self.viewLayoutInfo setAttribute:value];
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplied) {
        self.viewLayoutInfo.multiplied = multiplied;
        return self;
    };
}

- (VVMakeLayout *(^)(NSInteger))priority {
    return ^id(NSInteger priority) {
        self.viewLayoutInfo.priority = priority;
        return self;
    };
}

#pragma mark - Helpers

- (VVViewLayoutInfo *)viewInfoForType:(VVMakeLayoutType)type {
    for (VVViewLayoutInfo *mi in self.viewLayoutInfos) {
        if (mi.makeLayoutType == type && mi.isNum) {
            return mi;
        }
    }

    return nil;
}

// 得到当前 view 的对应位置的值
- (CGFloat)valueForMakeLayoutType:(VVMakeLayoutType)type forView:(UIView *)view {
    view = view ?: self.view.superview;
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

- (void)leftWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGFloat x = [self leftXForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
        CGRect frame = self.newFrame;
        frame.origin.x = x;
        self.newFrame = frame;
        self.leftMaked = YES;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (CGFloat)leftXForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x + value;
}

#pragma mark Top relations

- (void)topWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGFloat y = [self topYForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
        CGRect frame = self.newFrame;
        frame.origin.y = y;
        self.newFrame = frame;
        self.topMaked = YES;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (CGFloat)topYForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y + value;
}

#pragma mark Bottom relations

- (void)bottomWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        if (!self.topMaked) {
            CGFloat y = [self bottomYForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
            frame.origin.y = y;
        } else {
            frame.size.height = [self bottomHeightForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];;
        }
        self.newFrame = frame;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (CGFloat)bottomYForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y + value - CGRectGetHeight(self.newFrame);
}

- (CGFloat)bottomHeightForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat height = fabsf(CGRectGetMinY(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return height + value;
}

#pragma mark Right relations

- (void)rightWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        if (!self.leftMaked) {
            CGFloat x = [self rightXForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
            frame.origin.x = x;
        } else {
            frame.size.width = [self rightWidthForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];;
        }
        self.newFrame = frame;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (CGFloat)rightXForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x + value - CGRectGetWidth(self.newFrame);
}

- (CGFloat)rightWidthForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat width = fabsf(CGRectGetMinX(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return width + value;
}

#pragma mark - Low priority

#pragma mark Center X relations

- (void)centerWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        if (makeLayoutType == VVMakeLayoutTypeCenter) {
            frame.origin.x = [self centerXForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:VVMakeLayoutTypeCenterX];
            frame.origin.y = [self centerYForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:VVMakeLayoutTypeCenterY];
        } else {
            frame.origin.x = [self centerXForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
            frame.origin.y = [self centerYForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
        }

        self.newFrame = frame;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (void)centerXWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.x = [self centerXForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (CGFloat)centerXForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat x = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return x - CGRectGetWidth(self.newFrame) * 0.5f + value;
}

#pragma mark Center Y relations

- (void)centerYWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.origin.y = [self centerYForView:makeInfo.relateView withValue:makeInfo.value makeLayoutType:makeLayoutType];
        self.newFrame = frame;
    };

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
}

- (CGFloat)centerYForView:(UIView *)view withValue:(CGFloat)value makeLayoutType:(VVMakeLayoutType)makeLayoutType {
    CGFloat y = [self valueForMakeLayoutType:makeLayoutType forView:view];
    return y - CGRectGetHeight(self.newFrame) * 0.5f + value;
}

#pragma mark - Top priority

#pragma mark Width / Height relations

- (void)widthWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    dispatch_block_t block_t;
    if (makeInfo.isNum) {
        VVWeakify(self);
        block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.size.width = makeInfo.value;
            self.newFrame = frame;
        };
    } else {
        VVWeakify(self);
        VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
        block_t = ^{
            VVStrongify(self);

            if (makeInfo.relateView && makeInfo.relateView != self.view) {
                CGFloat width = [self sizeForView:makeInfo.relateView withMakeLayoutType:makeLayoutType] * makeInfo.multiplied;
                [self setSizeValue:width type:VVMakeLayoutTypeWidth];
            } else {
                VVViewLayoutInfo *heightInfo = [self viewInfoForType:VVMakeLayoutTypeHeight];
                if (heightInfo && heightInfo.isNum) {
                    CGFloat width = heightInfo.value;
                    [self setSizeValue:width * makeInfo.multiplied type:VVMakeLayoutTypeWidth];

                } else if (heightInfo && !heightInfo.isNum) {
                    UIView *tempView = heightInfo.relateView;
                    CGFloat tempMultiplier = heightInfo.multiplied;
                    VVMakeLayoutType makeType = heightInfo.makeLayoutType;

                    CGFloat width = [self sizeForView:tempView withMakeLayoutType:makeType] * (tempMultiplier * makeInfo.multiplied);
                    [self setSizeValue:width type:VVMakeLayoutTypeWidth];

                } else {
                    VVViewLayoutInfo *topInfo = [self viewInfoForType:VVMakeLayoutTypeTop];
                    VVViewLayoutInfo *bottomInfo = [self viewInfoForType:VVMakeLayoutTypeBottom];

                    if (topInfo && bottomInfo) {
                        UIView *topView = topInfo.relateView;
                        CGFloat topInset = topInfo.value;
                        VVMakeLayoutType topMakeLayoutType = topInfo.makeLayoutType;

                        CGFloat topViewY = [self topYForView:topView withValue:topInset makeLayoutType:topMakeLayoutType];

                        UIView *bottomView = bottomInfo.relateView;
                        CGFloat bottomInset = bottomInfo.value;
                        VVMakeLayoutType bottomMakeLayoutType = bottomInfo.makeLayoutType;

                        CGFloat bottomViewY = [self valueForMakeLayoutType:bottomMakeLayoutType forView:bottomView] - bottomInset;

                        [self setSizeValue:(bottomViewY - topViewY) * makeInfo.multiplied type:VVMakeLayoutTypeWidth];
                    }
                }
            }
        };
    }

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

- (void)heightWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    dispatch_block_t block_t;
    if (makeInfo.isNum) {
        VVWeakify(self);
        block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.size.height = makeInfo.value;
            self.newFrame = frame;
        };
    } else {
        VVWeakify(self);
        VVMakeLayoutType makeLayoutType = makeInfo.viewLayoutType;
        block_t = ^{
            VVStrongify(self);
            if (makeInfo.relateView && makeInfo.relateView != self.view) {// 获取的View的值进行设值
                CGFloat height = [self sizeForView:makeInfo.relateView withMakeLayoutType:makeLayoutType] * makeInfo.multiplied;
                [self setSizeValue:height type:VVMakeLayoutTypeHeight];
            } else {
                VVViewLayoutInfo *widthInfo = [self viewInfoForType:VVMakeLayoutTypeWidth];
                if (widthInfo && widthInfo.isNum) {// 获取输入的数字设值
                    CGFloat height = widthInfo.value;
                    [self setSizeValue:height * widthInfo.multiplied type:VVMakeLayoutTypeHeight];

                } else if (widthInfo && !widthInfo.isNum) {// 与自己的已经确定的宽进行设值
                    VVViewLayoutInfo *widthToInfo = [self viewInfoForType:VVMakeLayoutTypeWidth];

                    UIView *tempView = widthToInfo.relateView;
                    CGFloat tempMultiplier = widthToInfo.multiplied;
                    VVMakeLayoutType makeType = widthToInfo.makeLayoutType;

                    CGFloat height = [self sizeForView:tempView withMakeLayoutType:makeType] * (tempMultiplier * makeInfo.multiplied);
                    [self setSizeValue:height type:VVMakeLayoutTypeHeight];

                } else {// 与自己的左右值计算得到的宽进行设值
                    VVViewLayoutInfo *leftInfo = [self viewInfoForType:VVMakeLayoutTypeLeft];
                    VVViewLayoutInfo *rightInfo = [self viewInfoForType:VVMakeLayoutTypeRight];

                    if (leftInfo && rightInfo) {
                        UIView *leftView = leftInfo.relateView;
                        CGFloat leftInset = leftInfo.value;
                        VVMakeLayoutType leftMakeLayoutType = leftInfo.makeLayoutType;

                        CGFloat leftViewX = [self leftXForView:leftView withValue:leftInset makeLayoutType:leftMakeLayoutType];

                        UIView *rightView = rightInfo.relateView;
                        CGFloat rightInset = rightInfo.value;
                        VVMakeLayoutType rightMakeLayoutType = rightInfo.makeLayoutType;

                        CGFloat rightViewX = [self valueForMakeLayoutType:rightMakeLayoutType forView:rightView] - rightInset;

                        [self setSizeValue:(rightViewX - leftViewX) * makeInfo.multiplied type:VVMakeLayoutTypeHeight];
                    }
                }
            }
        };
    }

    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

// 得到当前view的宽或者高
- (CGFloat)sizeForView:(UIView *)view withMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    if (makeLayoutType == VVMakeLayoutTypeWidth) {
        return CGRectGetWidth(view.bounds);
    } else if (makeLayoutType == VVMakeLayoutTypeHeight) {
        return CGRectGetHeight(view.bounds);
    }

    return 0.0f;
}

- (void)setMiddlePriorityValue:(CGFloat)value withType:(VVMakeLayoutType)type {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        [self setSizeValue:value type:type];
    };

    self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:type];
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

// 改变Frame的值
- (void)setSizeValue:(CGFloat)value type:(VVMakeLayoutType)type {
    CGRect frame = self.newFrame;
    switch (type) {
        case VVMakeLayoutTypeWidth:
            frame.size.width = value + self.viewLayoutInfo.size.width;
            break;
        case VVMakeLayoutTypeHeight:
            frame.size.height = value + self.viewLayoutInfo.size.height;
            break;
        default:
            break;
    }
    self.newFrame = frame;
}

- (VVMakeLayout *)sizeWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    CGSize size = makeInfo.size;
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGRect frame = self.newFrame;
        frame.size = size;
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
    return self;
}

- (VVMakeLayout *)edgesWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    UIEdgeInsets insets = makeInfo.insets;
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        UIView *relateView = makeInfo.relateView;
        if (!relateView) {
            relateView = [self.view superview];
        }
        CGFloat width = CGRectGetWidth(relateView.bounds) - insets.left + insets.right;
        CGFloat height = CGRectGetHeight(relateView.bounds) - insets.top + insets.bottom;
        CGRect frame = CGRectMake(insets.left, insets.top, width, height);
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
    return self;
}

#pragma mark Container

- (VVMakeLayout *)container {
    CGRect frame = CGRectZero;
    for (UIView *subview in [self.view subviews]) {
        frame = CGRectUnion(frame, subview.frame);
    }

    [self setMiddlePriorityValue:CGRectGetWidth(frame) withType:VVMakeLayoutTypeWidth];
    [self setMiddlePriorityValue:CGRectGetHeight(frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

#pragma mark Fits

- (VVMakeLayout *)sizeToFit {
    [self.view sizeToFit];
    [self setMiddlePriorityValue:CGRectGetWidth(self.view.frame) withType:VVMakeLayoutTypeWidth];
    [self setMiddlePriorityValue:CGRectGetHeight(self.view.frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

- (VVMakeLayout *)widthToFit {
    [self.view sizeToFit];
    [self setMiddlePriorityValue:CGRectGetWidth(self.view.frame) withType:VVMakeLayoutTypeWidth];
    return self;
}

- (VVMakeLayout *)heightToFit {
    [self.view sizeToFit];
    [self setMiddlePriorityValue:CGRectGetHeight(self.view.frame) withType:VVMakeLayoutTypeHeight];
    return self;
}

- (VVMakeLayout *(^)(CGSize size))lessSizeThatFits {
    return ^id(CGSize size) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeSize];
        self.viewLayoutInfo.equalType = VVLessThanOrEqualTo;
        self.viewLayoutInfo.fitSize = size;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)lessSizeWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat width = MIN(makeInfo.fitSize.width, fitSize.width);
    CGFloat height = MIN(makeInfo.fitSize.height, fitSize.height);
    [self setMiddlePriorityValue:width withType:VVMakeLayoutTypeWidth];
    [self setMiddlePriorityValue:height withType:VVMakeLayoutTypeHeight];
}

- (VVMakeLayout *(^)(CGSize size))greatSizeThatFits {
    return ^id(CGSize size) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeSize];
        self.viewLayoutInfo.equalType = VVGreaterThanOrEqualTo;
        self.viewLayoutInfo.fitSize = size;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)greatSizeWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat width = MAX(makeInfo.fitSize.width, fitSize.width);
    CGFloat height = MAX(makeInfo.fitSize.height, fitSize.height);
    [self setMiddlePriorityValue:width withType:VVMakeLayoutTypeWidth];
    [self setMiddlePriorityValue:height withType:VVMakeLayoutTypeHeight];
}

- (VVMakeLayout *(^)(CGFloat))lessHeightThatFits {
    return ^id(CGFloat height) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeHeight];
        self.viewLayoutInfo.equalType = VVLessThanOrEqualTo;
        self.viewLayoutInfo.fitValue = height;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)lessHeightWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGRectGetWidth(self.newFrame), CGFLOAT_MAX)];
        CGRect frame = self.newFrame;
        frame.size.height = MIN(fitSize.height, makeInfo.fitValue) + makeInfo.value;
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (VVMakeLayout *(^)(CGFloat))greatHeightThatFits {
    return ^id(CGFloat height) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeHeight];
        self.viewLayoutInfo.equalType = VVGreaterThanOrEqualTo;
        self.viewLayoutInfo.fitValue = height;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)greatHeightWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGRectGetWidth(self.newFrame), CGFLOAT_MAX)];
        CGRect frame = self.newFrame;
        frame.size.height = MAX(fitSize.height, makeInfo.fitValue) + makeInfo.value;
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (VVMakeLayout *(^)(CGFloat))lessWidthThatFits {
    return ^id(CGFloat width) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeWidth];
        self.viewLayoutInfo.equalType = VVLessThanOrEqualTo;
        self.viewLayoutInfo.fitValue = width;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)lessWidthWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.newFrame))];
        CGRect frame = self.newFrame;
        frame.size.width = MIN(fitSize.width, makeInfo.fitValue) + makeInfo.value;
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

- (VVMakeLayout *(^)(CGFloat))greatWidthThatFits {
    return ^id(CGFloat width) {
        self.viewLayoutInfo = [VVViewLayoutInfo viewInfoWithMakeLayoutType:VVMakeLayoutTypeWidth];
        self.viewLayoutInfo.equalType = VVGreaterThanOrEqualTo;
        self.viewLayoutInfo.fitValue = width;
        [self.viewLayoutInfos addObject:self.viewLayoutInfo];
        return self;
    };
}

- (void)greatWidthWithMakeInfo:(VVViewLayoutInfo *)makeInfo {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.newFrame))];
        CGRect frame = self.newFrame;
        frame.size.width = MAX(fitSize.width, makeInfo.fitValue) + makeInfo.value;
        self.newFrame = frame;
    };
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityMiddle]];
}

@end

@implementation VVMakeLayout (AutoboxingSupport)

- (VVMakeLayout *(^)(id))vv_equalTo {
    EmptyMethodExcetion();
}

@end
