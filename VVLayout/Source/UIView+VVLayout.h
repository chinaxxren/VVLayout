
#import <UIKit/UIKit.h>
#import "VVLayout.h"

@interface UIView (VVLayout)

NS_ASSUME_NONNULL_BEGIN

/*
    Apply new configuration state without frame updating.
 */
@property(nonatomic) NSNumber *vv_state;

/**
 *  Creates and configurates VVFramer object for each view.
 *  @param CreateBlock An Create block within which you can configurate frame relations.
 */
- (void)makeLayout:(MakeLayout)makeLayout;

- (void)makeLayout:(MakeLayout)makeLayout forState:(NSNumber *)state;

NS_ASSUME_NONNULL_END

@end
