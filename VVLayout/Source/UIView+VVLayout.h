
#import <UIKit/UIKit.h>
#import "VVMakeLayout.h"

@interface UIView (VVLayout)

NS_ASSUME_NONNULL_BEGIN

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

- (void)makeLayout:(MakeLayout)makeLayout;

- (void)updateLayout:(MakeLayout)makeLayout;

- (void)layout:(MakeLayout)makeLayout state:(NSNumber *)state;

NS_ASSUME_NONNULL_END

@end
