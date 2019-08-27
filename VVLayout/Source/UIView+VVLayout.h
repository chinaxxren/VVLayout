
#import <UIKit/UIKit.h>
#import "VVMakeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VVLayout)

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

- (void)makeLayout:(LayoutMake)layoutMake;

- (void)remakeLayout:(LayoutMake)layoutMake;

- (void)updateLayout:(LayoutMake)layoutMake;

- (void)layoutMake:(LayoutMake)layoutMake state:(NSNumber *)state;

@end

NS_ASSUME_NONNULL_END
