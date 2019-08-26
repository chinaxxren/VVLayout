
#import "UIView+VVLayout.h"

#import <objc/runtime.h>

@implementation UIView (VVLayout)

#pragma mark - Make

- (void)makeLayout:(MakeLayout)makeLayout {
    self.vv_state = @0;
    [self layout:makeLayout state:self.vv_state];
}

- (void)updateLayout:(MakeLayout)makeLayout {
    self.vv_state = @([self.vv_state integerValue] + 1);
    [self layout:makeLayout state:self.vv_state];
}

- (void)layout:(MakeLayout)makeLayout state:(NSNumber *)state {
    [VVMakeLayout configView:self state:state makeLayout:makeLayout];
}

#pragma mark - Runtime

- (void)setVv_state:(NSNumber *)vv_state {
    objc_setAssociatedObject(self, @selector(vv_state), vv_state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)vv_state {
    NSNumber *vv_state = objc_getAssociatedObject(self, @selector(vv_state));
    return (vv_state) ?: @0;
}

@end
