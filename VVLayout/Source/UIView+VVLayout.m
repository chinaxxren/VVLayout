
#import "UIView+VVLayout.h"

#import <objc/runtime.h>

@implementation UIView (VVLayout)

#pragma mark - Make

- (void)makeLayout:(VVViewLayout)layout {
    if (!self.vv_state || [self.vv_state integerValue] != 0) {
        return;
    }
    
    self.vv_state = @0;
    [self layout:layout state:self.vv_state];
}

- (void)remakeLayout:(VVViewLayout)layout {
    self.vv_state = @0;
    [self layout:layout state:self.vv_state];
}

- (void)updateLayout:(VVViewLayout)layout {
    self.vv_state = @([self.vv_state integerValue] + 1);
    [self layout:layout state:self.vv_state];
}

- (void)layout:(VVViewLayout)layout state:(NSNumber *)state {
    [VVMakeLayout configView:self state:state layout:layout];
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
