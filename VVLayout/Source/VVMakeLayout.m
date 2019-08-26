//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayout.h"

#import "VVMakeLayoutInfo.h"
#import "VVMakeBlock.h"
#import "UIView+VVLayout.h"
#import "UIView+VVExtend.h"
#import "VVLayoutAppearance.h"

#define MAX_LAYOUT_VALUE 10000.f

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

@property(nonatomic, strong) VVMakeLayoutInfo *makeLayoutInfo;

@property(nonatomic, getter=isTopMaked) BOOL topMaked;
@property(nonatomic, getter=isLeftMaked) BOOL leftMaked;
@property(nonatomic) CGRect newFrame;

@property(nonatomic, nonnull) NSMutableArray <VVMakeLayoutInfo *> *makeLayoutInfos;
@property(nonatomic, nonnull) NSMutableArray <VVMakeBlock *> *makeBlcoks;
@property(nonatomic, weak, nullable) UIView *view;

@end

@implementation VVMakeLayout


#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _makeLayoutInfos = [NSMutableArray new];
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

+ (void)configView:(UIView *)view makeLayout:(MakeLayout)make {
    [self configView:view state:@0 makeLayout:make];
}

+ (void)configView:(UIView *)view state:(NSNumber *)state makeLayout:(MakeLayout)makeLayout {
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
    for (VVMakeLayoutInfo *makeInfo in self.makeLayoutInfos) {
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

    [self.makeBlcoks sortUsingComparator:^NSComparisonResult(VVMakeBlock *_Nonnull block_t1, VVMakeBlock *block_t2) {
        if (block_t1.priority > block_t2.priority) {
            return NSOrderedAscending;
        }

        return (block_t1.priority == block_t2.priority) ? NSOrderedSame : NSOrderedDescending;
    }];
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

- (VVMakeLayout *)left {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeLeft];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)right {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeRight];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)top {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeTop];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)bottom {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeBottom];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerX {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeCenterX];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)centerY {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeCenterY];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)center {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeCenter];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)width {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeWidth];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)height {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeHeight];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)size {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeSize];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *)edges {
    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:VVMakeLayoutTypeEdges];
    [self.makeLayoutInfos addObject:self.makeLayoutInfo];
    return self;
}

- (VVMakeLayout *(^)(id))equalTo {
    return ^(id attribute) {
        [self.makeLayoutInfo changeAttribute:attribute equalType:VVEqualTo];
        return self;
    };
}

- (VVMakeLayout *(^)(id))greaterThanOrEqualTo {
    return ^(id attribute) {
        [self.makeLayoutInfo changeAttribute:attribute equalType:VVGreaterThanOrEqualTo];
        return self;
    };
}

- (VVMakeLayout *(^)(id))lessThanOrEqualTo {
    return ^(id attribute) {
        [self.makeLayoutInfo changeAttribute:attribute equalType:VVLessThanOrEqualTo];
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))offset {
    return ^id(CGFloat value) {
        self.makeLayoutInfo.value = value * [VVLayoutAppearance globalScale];
        return self;
    };
}

- (VVMakeLayout *(^)(CGSize))sizeOffset {
    return ^id(CGSize size) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.makeLayoutInfo.size = CGSizeMake(size.width * scale, size.height * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(CGPoint))centerOffset {
    return ^id(CGPoint point) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.makeLayoutInfo.point = CGPointMake(point.x * scale, point.y * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(VVEdgeInsets))insets {
    return ^id(VVEdgeInsets insets) {
        CGFloat scale = [VVLayoutAppearance globalScale];
        self.makeLayoutInfo.insets = UIEdgeInsetsMake(insets.top * scale, insets.left * scale, insets.bottom * scale, insets.right * scale);
        return self;
    };
}

- (VVMakeLayout *(^)(NSValue *))valueOffset {
    return ^id(NSValue *value) {
        [self.makeLayoutInfo setAttribute:value];
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
    for (VVMakeLayoutInfo *mi in self.makeLayoutInfos) {
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

- (void)leftWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (void)topWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (void)bottomWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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
    CGFloat height = fabs(CGRectGetMinY(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return height + value;
}

#pragma mark Right relations

- (void)rightWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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
    CGFloat width = fabs(CGRectGetMinX(self.newFrame) - [self valueForMakeLayoutType:makeLayoutType forView:view]);
    return width + value;
}

#pragma mark - Low priority

#pragma mark Center X relations

- (void)centerWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (void)centerXWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (void)centerYWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (void)widthWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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
                VVMakeLayoutInfo *heightInfo = [self infoForType:VVMakeLayoutTypeHeight];
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
                    VVMakeLayoutInfo *topInfo = [self infoForType:VVMakeLayoutTypeTop];
                    VVMakeLayoutInfo *bottomInfo = [self infoForType:VVMakeLayoutTypeBottom];

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

- (void)heightWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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
                VVMakeLayoutInfo *widthInfo = [self infoForType:VVMakeLayoutTypeWidth];
                if (widthInfo && widthInfo.isNum) {// 获取输入的数字设值
                    CGFloat height = widthInfo.value;
                    [self setSizeValue:height * widthInfo.multiplied type:VVMakeLayoutTypeHeight];

                } else if (widthInfo && !widthInfo.isNum) {// 与自己的已经确定的宽进行设值
                    VVMakeLayoutInfo *widthToInfo = [self infoForType:VVMakeLayoutTypeWidth];

                    UIView *tempView = widthToInfo.relateView;
                    CGFloat tempMultiplier = widthToInfo.multiplied;
                    VVMakeLayoutType makeType = widthToInfo.makeLayoutType;

                    CGFloat height = [self sizeForView:tempView withMakeLayoutType:makeType] * (tempMultiplier * makeInfo.multiplied);
                    [self setSizeValue:height type:VVMakeLayoutTypeHeight];

                } else {// 与自己的左右值计算得到的宽进行设值
                    VVMakeLayoutInfo *leftInfo = [self infoForType:VVMakeLayoutTypeLeft];
                    VVMakeLayoutInfo *rightInfo = [self infoForType:VVMakeLayoutTypeRight];

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

- (void)setHighPriorityValue:(CGFloat)value withType:(VVMakeLayoutType)type {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        [self setSizeValue:value type:type];
    };

    self.makeLayoutInfo = [VVMakeLayoutInfo infoWithMakeLayoutType:type];
    [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityHigh]];
}

// 改变Frame的值
- (void)setSizeValue:(CGFloat)value type:(VVMakeLayoutType)type {
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

- (VVMakeLayout *)sizeWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
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

- (VVMakeLayout *)edgesWithMakeInfo:(VVMakeLayoutInfo *)makeInfo {
    UIEdgeInsets insets = makeInfo.insets;
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        UIView *relateView = makeInfo.relateView;
        if (!relateView) {
            relateView = [self.view superview];
        }
        CGFloat width = CGRectGetWidth(relateView.bounds) - (insets.left + insets.right);
        CGFloat height = CGRectGetHeight(relateView.bounds) - (insets.top + insets.bottom);
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
        CGFloat scale = [VVLayoutAppearance globalScale];
        CGSize fitSize = [self.view sizeThatFits:size];
        CGFloat width = size.width > MAX_LAYOUT_VALUE ? MAX_LAYOUT_VALUE : size.width * scale;
        CGFloat height = size.height > MAX_LAYOUT_VALUE ? MAX_LAYOUT_VALUE : size.height * scale;
        width = MIN(width, fitSize.width);
        height = MIN(height, fitSize.height);
        [self setHighPriorityValue:width withType:VVMakeLayoutTypeWidth];
        [self setHighPriorityValue:height withType:VVMakeLayoutTypeHeight];
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))heightThatFits {
    return ^id(CGFloat maxHeight) {
        VVWeakify(self);
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGFloat height = maxHeight > MAX_LAYOUT_VALUE ? MAX_LAYOUT_VALUE : maxHeight * [VVLayoutAppearance globalScale];
            CGSize fitSize = [self.view sizeThatFits:CGSizeMake(CGRectGetWidth(self.newFrame), height)];
            CGRect frame = self.newFrame;
            frame.size.height = fitSize.height;
            self.newFrame = frame;
        };
        [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
        return self;
    };
}

- (VVMakeLayout *(^)(CGFloat))widthThatFits {
    return ^id(CGFloat maxWidth) {
        VVWeakify(self);
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGFloat height = maxWidth > MAX_LAYOUT_VALUE ? MAX_LAYOUT_VALUE : maxWidth * [VVLayoutAppearance globalScale];
            CGSize fitSize = [self.view sizeThatFits:CGSizeMake(height, CGRectGetHeight(self.newFrame))];
            CGRect frame = self.newFrame;
            frame.size.width = fitSize.width;
            self.newFrame = frame;
        };
        [self.makeBlcoks addObject:[VVMakeBlock makeBlockT:block_t priority:VVMakeBlockPriorityLow]];
        return self;
    };
}

@end

@implementation VVMakeLayout (AutoboxingSupport)

- (VVMakeLayout *(^)(id))vv_equalTo {
    EmptyMethodExcetion();
}

@end
