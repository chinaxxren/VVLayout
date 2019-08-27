
#import <UIKit/UIKit.h>
#import "VVMakeLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VVLayout)

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

- (void)makeLayout:(MakeHandler)makeHandler;

- (void)remakeLayout:(MakeHandler)makeHandler;

- (void)updateLayout:(MakeHandler)makeHandler;

- (void)layout:(MakeHandler)makeHandler state:(NSNumber *)state;

@end

NS_ASSUME_NONNULL_END
