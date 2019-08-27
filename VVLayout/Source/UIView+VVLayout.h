
#import <UIKit/UIKit.h>
#import "VVMakeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VVLayout)

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

- (void)makeLayout:(VVViewLayout)layout;

- (void)remakeLayout:(VVViewLayout)layout;

- (void)updateLayout:(VVViewLayout)layout;

- (void)layout:(VVViewLayout)layout state:(NSNumber *)state;

@end

NS_ASSUME_NONNULL_END
