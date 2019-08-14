
#import "VVLayout.h"

#import "VVBlockT.h"
#import "VVBlockTInfo.h"
#import "UIView+VVExtend.h"
#import "UIView+VVLayout.h"

#define VVWeakify(o)   __weak   typeof(self) vvwo = o;
#define VVStrongify(o) __strong typeof(self) o = vvwo;


@interface VVLayout ()

@property(nonatomic, getter=isTopFrameInstalled) BOOL topFrameInstalled;
@property(nonatomic, getter=isLeftFrameInstalled) BOOL leftFrameInstalled;
@property(nonatomic) CGRect newFrame;

@property(nonatomic, nonnull) NSMutableArray <VVBlockTInfo *> *blockInfos;
@property(nonatomic, nonnull) NSMutableArray <VVBlockT *> *blcoks;
@property(nonatomic, weak, nullable) UIView *view;

@end

@implementation VVLayout

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _blockInfos = [NSMutableArray new];
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

+ (void)configView:(UIView *)view makeLayout:(MakeLayout)makeLayout {
    [self configView:view forState:@0 makeLayout:makeLayout];
}

+ (void)configView:(UIView *)view forState:(NSNumber *)state makeLayout:(MakeLayout)makeLayout {
    if (view.vv_state.integerValue == state.integerValue) {
        VVLayout *layout = [VVLayout new];
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
    NSLog(@"frame->%@", NSStringFromCGRect(self.newFrame));
}

// 按照优先级进行排序
- (void)configOrderHandlers {
    [self.blcoks sortUsingComparator:^NSComparisonResult(VVBlockT *_Nonnull block_t1, VVBlockT *block_t2) {
        if (block_t1.priority > block_t2.priority) {
            return NSOrderedAscending;
        }

        return (block_t1.priority == block_t2.priority) ? NSOrderedSame : NSOrderedDescending;
    }];
}

- (void)configFrames {
    [self configOrderHandlers];

    [self.blcoks enumerateObjectsUsingBlock:^(VVBlockT *_Nonnull block_t, NSUInteger idx, BOOL *_Nonnull stop) {
        block_t.block_t();
    }];

    [self endConfig];
}

#pragma mark - Helpers

// 得到当前 view 的属性的 VVBlockTInfo
- (VVBlockTInfo *)infoForType:(VVRelationType)type {
    // 使用指定的谓词过滤NSArray集合，返回符合条件的元素组成的新集合
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationType == %@", @(type)];
    return [self.blockInfos filteredArrayUsingPredicate:predicate].firstObject;
}

// 得到当前 view 的对应位置的值
- (CGFloat)valueForRelationType:(VVRelationType)type forView:(UIView *)view {
    CGRect convertedRect = [self.view.superview convertRect:view.frame fromView:view.superview];
    switch (type) {
        case VVRelationTypeTop:
            return CGRectGetMinY(convertedRect);
        case VVRelationTypeBottom:
            return CGRectGetMaxY(convertedRect);
        case VVRelationTypeCenterY:
            return CGRectGetMidY(convertedRect);
        case VVRelationTypeCenterX:
            return CGRectGetMidX(convertedRect);
        case VVRelationTypeRight:
            return CGRectGetMaxX(convertedRect);
        case VVRelationTypeLeft:
            return CGRectGetMinX(convertedRect);
        default:
            return 0;
    }
}

#pragma mark - Framer methods

- (VVLayout *)and {
    return self;
}

#pragma mark - Top priority

#pragma mark Width / Height relations

- (VVLayout *(^)(CGFloat))width {
    return ^id(CGFloat width) {
        [self setHighPriorityValue:width withType:VVRelationTypeWidth];
        return self;
    };
}

- (VVLayout *(^)(UIView *, CGFloat))width_to {
    return ^id(UIView *view, CGFloat multiplier) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);

            if (view != self.view) {

                CGFloat width = [self sizeForView:view withRelationType:relationType] * multiplier;
                [self setFrameValue:width type:VVRelationTypeWidth];
            } else {
                VVBlockTInfo *heightInfo = [self infoForType:VVRelationTypeHeight];
                if (heightInfo) {
                    CGFloat width = [heightInfo.first floatValue];
                    [self setFrameValue:width * multiplier type:VVRelationTypeWidth];

                } else if ([self infoForType:VVRelationTypeHeightTo]) {
                    VVBlockTInfo *heightToInfo = [self infoForType:VVRelationTypeHeightTo];

                    UIView *tempRelationView = heightToInfo.first;
                    CGFloat tempMultiplier = [heightToInfo.third floatValue];
                    VVRelationType relationType = (VVRelationType) [heightToInfo.second integerValue];

                    CGFloat width = [self sizeForView:tempRelationView withRelationType:relationType] * (tempMultiplier * multiplier);
                    [self setFrameValue:width type:VVRelationTypeWidth];

                } else {
                    VVBlockTInfo *topInfo = [self infoForType:VVRelationTypeTop];
                    VVBlockTInfo *bottomInfo = [self infoForType:VVRelationTypeBottom];

                    if (topInfo && bottomInfo) {
                        UIView *topView = topInfo.first;
                        CGFloat topInset = [topInfo.second floatValue];
                        VVRelationType topRelationType = (VVRelationType) [topInfo.third integerValue];

                        CGFloat topViewY = [self topRelationYForView:topView withInset:topInset relationType:topRelationType];

                        UIView *bottomView = bottomInfo.first;
                        CGFloat bottomInset = [bottomInfo.second floatValue];
                        VVRelationType bottomRelationType = (VVRelationType) [bottomInfo.third integerValue];

                        CGFloat bottomViewY = [self valueForRelationType:bottomRelationType forView:bottomView] - bottomInset;

                        [self setFrameValue:(bottomViewY - topViewY) * multiplier type:VVRelationTypeWidth];
                    }
                }
            }
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeWidthTo parameters:view, @(relationType), @(multiplier), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityHigh]];
        return self;
    };
}

- (VVLayout *(^)(CGFloat))height {
    return ^id(CGFloat height) {
        [self setHighPriorityValue:height withType:VVRelationTypeHeight];
        return self;
    };
}

- (VVLayout *(^)(UIView *, CGFloat))height_to {
    return ^id(UIView *view, CGFloat multiplier) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);

            if (view != self.view) {
                CGFloat height = [self sizeForView:view withRelationType:relationType] * multiplier;
                [self setFrameValue:height type:VVRelationTypeHeight];
            } else {
                VVBlockTInfo *widthInfo = [self infoForType:VVRelationTypeWidth];
                if (widthInfo) {
                    CGFloat height = [widthInfo.first floatValue];
                    [self setFrameValue:height * multiplier type:VVRelationTypeHeight];

                } else if ([self infoForType:VVRelationTypeWidthTo]) {
                    VVBlockTInfo *widthToInfo = [self infoForType:VVRelationTypeWidthTo];

                    UIView *tempRelationView = widthToInfo.first;
                    CGFloat tempMultiplier = [widthToInfo.third floatValue];
                    VVRelationType relationType = (VVRelationType) [widthToInfo.second integerValue];

                    CGFloat height = [self sizeForView:tempRelationView withRelationType:relationType] * (tempMultiplier * multiplier);
                    [self setFrameValue:height type:VVRelationTypeHeight];

                } else {
                    VVBlockTInfo *leftInfo = [self infoForType:VVRelationTypeLeft];
                    VVBlockTInfo *rightInfo = [self infoForType:VVRelationTypeRight];

                    if (leftInfo && rightInfo) {
                        UIView *leftView = leftInfo.first;
                        CGFloat leftInset = [leftInfo.second floatValue];
                        VVRelationType leftRelationType = (VVRelationType) [leftInfo.third integerValue];

                        CGFloat leftViewX = [self leftRelationXForView:leftView withInset:leftInset relationType:leftRelationType];

                        UIView *rightView = rightInfo.first;
                        CGFloat rightInset = [rightInfo.second floatValue];
                        VVRelationType rightRelationType = (VVRelationType) [rightInfo.third integerValue];

                        CGFloat rightViewX = [self valueForRelationType:rightRelationType forView:rightView] - rightInset;

                        [self setFrameValue:(rightViewX - leftViewX) * multiplier type:VVRelationTypeHeight];
                    }
                }
            }
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeHeightTo parameters:view, @(relationType), @(multiplier), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityHigh]];
        return self;
    };
}

// 得到当前view的宽或者高
- (CGFloat)sizeForView:(UIView *)view withRelationType:(VVRelationType)relationType {
    if (relationType == VVRelationTypeWidth) {
        return CGRectGetWidth(view.bounds);
    } else if (relationType == VVRelationTypeHeight) {
        return CGRectGetHeight(view.bounds);
    }
    return 0;
}

- (void)setHighPriorityValue:(CGFloat)value withType:(VVRelationType)type {
    VVWeakify(self);
    dispatch_block_t block_t = ^{
        VVStrongify(self);
        [self setFrameValue:value type:type];
    };

    [self.blockInfos addObject:[VVBlockTInfo infoWithType:type parameters:@(value), nil]];
    [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityHigh]];
}

// 改变Frame的值
- (void)setFrameValue:(CGFloat)value type:(VVRelationType)type {
    CGRect frame = self.newFrame;
    switch (type) {
        case VVRelationTypeWidth:
            frame.size.width = value;
            break;
        case VVRelationTypeHeight:
            frame.size.height = value;
            break;
        default:
            break;
    }
    self.newFrame = frame;
}

#pragma mark Left relations

- (VVLayout *(^)(CGFloat))left {
    return ^id(CGFloat inset) {
        return self.left_to(self.view.superview.vv_left, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))left_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGFloat x = [self leftRelationXForView:view withInset:inset relationType:relationType];
            CGRect frame = self.newFrame;
            frame.origin.x = x;
            self.newFrame = frame;
            self.leftFrameInstalled = YES;
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeLeft parameters:view, @(inset), @(relationType), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityHigh]];
        return self;
    };
}

- (CGFloat)leftRelationXForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat x = [self valueForRelationType:relationType forView:view];
    return x + inset;
}

#pragma mark Top relations

- (VVLayout *(^)(CGFloat))top {
    return ^id(CGFloat inset) {
        return self.top_to(self.view.superview.vv_top, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))top_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGFloat y = [self topRelationYForView:view withInset:inset relationType:relationType];
            CGRect frame = self.newFrame;
            frame.origin.y = y;
            self.newFrame = frame;
            self.topFrameInstalled = YES;
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeTop parameters:view, @(inset), @(relationType), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityHigh]];
        return self;
    };
}

- (CGFloat)topRelationYForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat y = [self valueForRelationType:relationType forView:view];
    return y + inset;
}

#pragma mark Container

- (VVLayout *(^)())container {
    return ^id() {
        CGRect frame = CGRectZero;
        for (UIView *subview in [self.view subviews]) {
            frame = CGRectUnion(frame, subview.frame);
        }

        [self setHighPriorityValue:CGRectGetWidth(frame) withType:VVRelationTypeWidth];
        [self setHighPriorityValue:CGRectGetHeight(frame) withType:VVRelationTypeHeight];
        return self;
    };
}

#pragma mark Fits

- (VVLayout *(^)())sizeToFit {
    return ^id() {
        [self.view sizeToFit];
        [self setHighPriorityValue:CGRectGetWidth(self.view.frame) withType:VVRelationTypeWidth];
        [self setHighPriorityValue:CGRectGetHeight(self.view.frame) withType:VVRelationTypeHeight];
        return self;
    };
}

- (VVLayout *(^)())widthToFit {
    return ^id() {
        [self.view sizeToFit];
        [self setHighPriorityValue:CGRectGetWidth(self.view.frame) withType:VVRelationTypeWidth];
        return self;
    };
}

- (VVLayout *(^)())heightToFit {
    return ^id() {
        [self.view sizeToFit];
        [self setHighPriorityValue:CGRectGetHeight(self.view.frame) withType:VVRelationTypeHeight];
        return self;
    };
}

- (VVLayout *(^)(CGSize size))sizeThatFits {
    return ^id(CGSize size) {
        CGSize fitSize = [self.view sizeThatFits:size];
        CGFloat width = MIN(size.width, fitSize.width);
        CGFloat height = MIN(size.height, fitSize.height);
        [self setHighPriorityValue:width withType:VVRelationTypeWidth];
        [self setHighPriorityValue:height withType:VVRelationTypeHeight];
        return self;
    };
}

#pragma mark - Middle priority

- (VVLayout *(^)(UIEdgeInsets))edges {
    return ^id(UIEdgeInsets insets) {

        VVWeakify(self);
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGFloat width = CGRectGetWidth(self.view.superview.bounds) - (insets.left + insets.right);
            CGFloat height = CGRectGetHeight(self.view.superview.bounds) - (insets.top + insets.bottom);
            CGRect frame = CGRectMake(insets.left, insets.top, width, height);
            self.newFrame = frame;
        };
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityMiddle]];
        return self;
    };
}

#pragma mark Bottom relations

- (VVLayout *(^)(CGFloat))bottom {
    return ^id(CGFloat inset) {
        return self.bottom_to(self.view.superview.vv_bottom, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))bottom_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            if (!self.isTopFrameInstalled) {
                CGFloat y = [self bottomRelationYForView:view withInset:inset relationType:relationType];
                frame.origin.y = y;
            } else {
                frame.size.height = [self bottomRelationHeightForView:view withInset:inset relationType:relationType];;
            }
            self.newFrame = frame;
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeBottom parameters:view, @(inset), @(relationType), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityMiddle]];
        return self;
    };
}

//当前view在传入view下面
- (CGFloat)bottomRelationHeightForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat height = fabs(CGRectGetMinY(self.newFrame) - [self valueForRelationType:relationType forView:view]);
    return height - inset;
}

//当前view在传入view上面
- (CGFloat)bottomRelationYForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat y = [self valueForRelationType:relationType forView:view];
    return y - inset - CGRectGetHeight(self.newFrame);
}

#pragma mark Right relations

- (VVLayout *(^)(CGFloat))right {
    return ^id(CGFloat inset) {
        return self.right_to(self.view.superview.vv_right, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))right_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            if (!self.isLeftFrameInstalled) {
                CGFloat x = [self rightRelationXForView:view withInset:inset relationType:relationType];
                frame.origin.x = x;
            } else {
                frame.size.width = [self rightRelationWidthForView:view withInset:inset relationType:relationType];;
            }
            self.newFrame = frame;
        };

        [self.blockInfos addObject:[VVBlockTInfo infoWithType:VVRelationTypeRight parameters:view, @(inset), @(relationType), nil]];
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityMiddle]];
        return self;
    };
}

- (CGFloat)rightRelationWidthForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat width = fabs(CGRectGetMinX(self.newFrame) - [self valueForRelationType:relationType forView:view]);
    return width - inset;
}

- (CGFloat)rightRelationXForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat x = [self valueForRelationType:relationType forView:view];
    return x - inset - CGRectGetWidth(self.newFrame);
}

#pragma mark - Low priority

#pragma mark Center X relations

- (VVLayout *(^)(CGFloat))centerX {
    return ^id(CGFloat x) {

        VVWeakify(self);
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.origin.x = x - CGRectGetWidth(frame) * 0.5f;
            self.newFrame = frame;
        };
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityLow]];
        return self;
    };
}

- (VVLayout *(^)(CGFloat))centerY {
    return ^id(CGFloat y) {

        VVWeakify(self);
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.origin.y = y - CGRectGetHeight(frame) * 0.5f;
            self.newFrame = frame;
        };
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityLow]];
        return self;
    };
}

- (VVLayout *(^)(CGFloat inset))super_centerX {
    return ^id(CGFloat inset) {
        return self.centerX_to(self.view.superview.vv_centerX, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))centerX_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.origin.x = [self centerRelationXForView:view withInset:inset relationType:relationType];
            self.newFrame = frame;
        };
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityLow]];
        return self;
    };
}

- (CGFloat)centerRelationXForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat x = [self valueForRelationType:relationType forView:view];
    return x - CGRectGetWidth(self.newFrame) * 0.5f - inset;
}

#pragma mark Center Y relations

- (VVLayout *(^)(CGFloat inset))super_centerY {
    return ^id(CGFloat inset) {
        return self.centerY_to(self.view.superview.vv_centerY, inset);
    };
}

- (VVLayout *(^)(UIView *, CGFloat))centerY_to {
    return ^id(UIView *view, CGFloat inset) {

        VVWeakify(self);
        VVRelationType relationType = view.relationType;
        dispatch_block_t block_t = ^{
            VVStrongify(self);
            CGRect frame = self.newFrame;
            frame.origin.y = [self centerRelationYForView:view withInset:inset relationType:relationType];
            self.newFrame = frame;
        };
        [self.blcoks addObject:[VVBlockT makeBlockT:block_t priority:VVBlockPriorityLow]];
        return self;
    };
}

- (CGFloat)centerRelationYForView:(UIView *)view withInset:(CGFloat)inset relationType:(VVRelationType)relationType {
    CGFloat y = [self valueForRelationType:relationType forView:view];
    return y - CGRectGetHeight(self.newFrame) * 0.5f - inset;
}

@end
