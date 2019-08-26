
#import <UIKit/UIKit.h>
#import "VVMakeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VVLayout)

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

- (void)makeLayout:(MakeLayout)makeLayout;

- (void)remakeLayout:(MakeLayout)makeLayout;

- (void)updateLayout:(MakeLayout)makeLayout;

- (void)layout:(MakeLayout)makeLayout state:(NSNumber *)state;

@end

NS_ASSUME_NONNULL_END
