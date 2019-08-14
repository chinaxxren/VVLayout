
#import "UIView+VVExtend.h"

#import <objc/runtime.h>

@implementation UIView (VVExtend)

- (UIView *)vv_width {
    self.relationType = VVRelationTypeWidth;
    return self;
}

- (UIView *)vv_height {
    self.relationType = VVRelationTypeHeight;
    return self;
}

- (UIView *)vv_left {
    self.relationType = VVRelationTypeLeft;
    return self;
}

- (UIView *)vv_right {
    self.relationType = VVRelationTypeRight;
    return self;
}

- (UIView *)vv_top {
    self.relationType = VVRelationTypeTop;
    return self;
}

- (UIView *)vv_bottom {
    self.relationType = VVRelationTypeBottom;
    return self;
}

- (UIView *)vv_centerX {
    self.relationType = VVRelationTypeCenterX;
    return self;
}

- (UIView *)vv_centerY {
    self.relationType = VVRelationTypeCenterY;
    return self;
}

#pragma mark - Runtime

- (void)setRelationType:(VVRelationType)relationType {
    objc_setAssociatedObject(self, @selector(relationType), @(relationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VVRelationType)relationType {
    return (VVRelationType) [objc_getAssociatedObject(self, @selector(relationType)) integerValue];
}

@end
