
#import <UIKit/UIKit.h>

@class VVLayout;

typedef void (^MakeLayout)(VVLayout *_Nonnull layout);

@interface VVLayout : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *	Optional semantic property for improvements readability.
 */
- (VVLayout *)and;

/**
 *  Relation for settings custom width.
 */
- (VVLayout *(^)(CGFloat width))width;

/**
 *  Relation for settings custom height.
 */
- (VVLayout *(^)(CGFloat height))height;

/**
 *  Relation for settings custom width with some multiplier.
 *  @param multiplier Additional multiplier configuration.
 */
- (VVLayout *(^)(UIView *view, CGFloat multiplier))width_to;

/**
 *  Relation for settings custom height with some multiplier.
 *  @param multiplier Additional multiplier configuration.
 */
- (VVLayout *(^)(UIView *view, CGFloat multiplier))height_to;

/**
 *  Left relation relatively superview.
 *  @param inset Additional inset between self.view and superview.
 */
- (VVLayout *(^)(CGFloat inset))left;

/**
 *  Top relation relatively superview.
 *  @param inset Additional inset between self.view and superview.
 */
- (VVLayout *(^)(CGFloat inset))top;

/**
 *  Bottom relation relatively superview.
 *  @param inset Additional inset between self.view and superview.
 */
- (VVLayout *(^)(CGFloat inset))bottom;

/**
 *  Right relation relatively superview.
 *  @param inset Additional inset between self.view and superview.
 */
- (VVLayout *(^)(CGFloat inset))right;

/**
 *  Conveniently edges relations for setting left / right/ top / bottom in one method.
 *  @params edges Edges between view and superview.
 */
- (VVLayout *(^)(UIEdgeInsets insets))edges;

/**
 *  Configure wrapped frame by all subviews.
 *  @warning You should not use 'bottom' and 'right' (relatively superview) configurations by subviews.
 */
- (VVLayout *(^)())container;

/**
    Resizes and moves the receiver view so it just encloses its subviews.
    @see -sizeToFit method (UIKit)
 */
- (VVLayout *(^)())sizeToFit;

/**
    Resizes and moves the receiver view so it just encloses its subviews only for width.
 */
- (VVLayout *(^)())widthToFit;

/**
    Resizes and moves the receiver view so it just encloses its subviews only for height.
 */
- (VVLayout *(^)())heightToFit;

/**
    Calculate the size that best fits the specified size.
    @param size The size for best-fitting.
 */
- (VVLayout *(^)(CGSize size))sizeThatFits;

/**
 *	Left relation relatively other view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))left_to;

/**
 *	Right relation relatively other view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))right_to;

/**
 *	Top relation relatively other view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))top_to;

/**
 *	Bottom relation relatively other view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))bottom_to;

/**
 *	CenterX relation with relatively view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between center of self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))centerX_to;

/**
 *	CenterY relation with relatively view. Possible to use these methods for superview.
 *  @param view  The view with which you want to add relation.
 *  @param inset Additional inset between center of self.view and other view.
 */
- (VVLayout *(^)(UIView *view, CGFloat inset))centerY_to;

/**
 *	Just set needed X for center point.
 */
- (VVLayout *(^)(CGFloat x))centerX;

/**
 *	Just set needed Y for center point.
 */
- (VVLayout *(^)(CGFloat y))centerY;

/**
 *	CenterX relation relatively superview.
 *  @param inset Additional inset between centerX of self.view and centerX of superview.
 */
- (VVLayout *(^)(CGFloat inset))super_centerX;

/**
 *	CenterY relation relatively superview.
 *  @param inset Additional inset between centerY of self.view and centerY of superview.
 */
- (VVLayout *(^)(CGFloat inset))super_centerY;

/**
 *	Configuration method.
 *  @param view The view for which create relations.
 */
+ (void)configView:(UIView *)view makeLayout:(MakeLayout)makeLayout;

+ (void)configView:(UIView *)view forState:(NSNumber *)state makeLayout:(MakeLayout)makeLayout;

NS_ASSUME_NONNULL_END

@end
