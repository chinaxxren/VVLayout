
#import "UIView+VVLayout.h"

#import <objc/runtime.h>

@implementation UIView (VVLayout)

#pragma mark - Make

- (void)makeLayout:(MakeLayout)makeLayout {
    [self makeLayout:makeLayout forState:@0];
}

- (void)makeLayout:(MakeLayout)makeLayout forState:(NSNumber *)state {
    [VVMakeLayout configView:self forState:state makeLayout:makeLayout];
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
